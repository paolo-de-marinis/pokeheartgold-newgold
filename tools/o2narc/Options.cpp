#include "Options.h"

#include <algorithm>
#include <cstring>
#include <iostream>
#include <vector>

#include "Narc.h"
#include "RelocElfReader.h"

static const char usage[] = "usage: o2narc [options] OBJ NARC\n"
                            "\n"
                            "-f, --flatten        Create a single flat binary\n"
                            "-p U8, --padding U8  Override fill value after each NARC member\n"
                            "-n, --naix           Create a .naix file that can be included by C\n"
                            "-N, --naix-names     Use symbol names in naix symbols. Implies --naix.\n"
                            "-h, --help           Show this message and exit\n";

Options::Options(int argc, char **argv) {
    for (int i = 1; i < argc; i++) {
        string arg { argv[i] };
        if (arg == "-f" || arg == "--flatten") {
            flatten = true;
        } else if (arg == "-p" || arg == "--padding") {
            int padval_i = stoi(argv[++i], nullptr, 0);
            if (padval_i < 0 || padval_i > 255) {
                throw command_error(string { "invalid 8-bit value " } + argv[i] + " for " + arg);
            }
            padval = static_cast<char>(padval_i);
        } else if (arg == "-n" || arg == "--naix") {
            naix = true;
        } else if (arg == "-N" || arg == "--naix-names") {
            naix_names = true;
            naix = true;
        } else if (arg == "-h" || arg == "--help") {
            std::cout << usage;
            std::exit(1);
        } else if (arg[0] == '-') {
            throw command_error("unrecognized option flag: " + arg);
        } else if (posargs.size() >= 2) {
            throw command_error("unrecognized positional argument: " + arg);
        } else {
            posargs.emplace_back(arg);
        }
    }
    if (posargs.size() < 2) {
        throw command_error("missing positional arg");
    }
    objfile.open(posargs[0], ios::in | ios::binary);
    narcfile.open(posargs[1], ios::out | ios::binary);
}

void Options::ReadObjectFile(vector<unsigned char> &rodata, vector<uint32_t> &sizes, vector<string> &names) {
    ELF_ASSERT(objfile.HasSection(".rodata"));
    rodata.resize(objfile.GetSectionHeader(".rodata").sh_size);
    objfile.ReadSectionData(objfile.GetSectionHeader(".rodata"), rodata.data());
    // Determine what O file we're dealing with
    if (objfile.HasSymbol("__size")) {
        uint32_t size = objfile.GetSymbol("__size").st_size;
        if (size == sizeof(uint32_t)) {
            objfile.ReadSymbolData(objfile.GetSymbol("__size"), &size);
            sizes.resize((rodata.size() + size - 1) / size);
            fill(sizes.begin(), sizes.end(), size);
        } else {
            sizes.resize(objfile.GetSymbol("__size").st_size / sizeof(uint32_t));
            objfile.ReadSymbolData(objfile.GetSymbol("__size"), sizes.data());
        }
    } else {
        auto pred = [&](const Elf32_Sym &sym) {
            return ELF32_ST_TYPE(sym.st_info) == STT_OBJECT
                && strcmp(objfile.GetSectionName(objfile.sections()[sym.st_shndx]), ".rodata") == 0
                && strcmp(objfile.GetSymbolName(sym), "__size") != 0
                && strcmp(objfile.GetSymbolName(sym), "__data") != 0
                && strcmp(objfile.GetSymbolName(sym), ".rodata") != 0;
        };
        sizes.resize(count_if(objfile.symbols().begin(), objfile.symbols().end(), pred));
        ELF_ASSERT(!sizes.empty());
        names.resize(sizes.size());
        offsets.resize(sizes.size());
        int t = 0;
        for (const auto &sym : objfile.symbols()) {
            if (pred(sym)) {
                sizes[t] = sym.st_size;
                names[t] = objfile.GetSymbolName(sym);
                offsets[t] = sym.st_value;
                ++t;
            }
        }
        if (naix_names) {
            if (std::unique(names.begin(), names.end()) != names.end()) {
                std::cerr << "FATAL: Duplicate symbol names detected\n";
                std::exit(1);
            }
        }
    }
}

// The file allocation table starts every member on a four byte boundary, so a
// member whose size is not a multiple of four needs its padding INSERTED after
// it. Writing that padding over the image in place, as this used to, left the
// image packed while the table walked it in aligned strides: each member began
// two bytes earlier than the table said for every odd-sized member before it,
// and the pad bytes landed inside the next member rather than after this one.
// Every row in this repository is a multiple of four but one -- evo.narc's
// became 50 bytes when a Pokemon was allowed an eighth evolution -- and that
// archive has read as noise from Ivysaur onwards ever since.
//
// That holds for rows laid out back to back (__size). Members that are
// symbols are where the assembler put them, which for zukan_data is after a
// ".balign 4, 255": counting them as packed took each member after an
// odd-sized one from two bytes too early, so every Dex sort list began with
// the previous one's last species or its padding. They are read from their
// own offsets.
void Options::OverwritePadding(vector<unsigned char> &rodata, vector<uint32_t> &sizes) const {
    vector<unsigned char> padded;
    padded.reserve((rodata.size() + 3) & ~3);
    size_t start = 0;
    for (size_t i = 0; i < sizes.size(); i++) {
        const uint32_t size = sizes[i];
        if (!offsets.empty()) {
            start = offsets[i];
        }
        size_t end = start + size;
        if (end > rodata.size()) {
            end = rodata.size();
        }
        padded.insert(padded.end(), rodata.begin() + start, rodata.begin() + end);
        padded.resize((padded.size() + 3) & ~3, padval);
        start = end;
    }
    // Anything the sizes did not account for is kept as it was, aligned; past
    // the last symbol there is only the assembler's alignment.
    if (offsets.empty() && start < rodata.size()) {
        padded.insert(padded.end(), rodata.begin() + start, rodata.end());
        padded.resize((padded.size() + 3) & ~3, padval);
    }
    rodata.swap(padded);
}

void Options::WriteNarc(vector<unsigned char> &rodata, vector<uint32_t> &sizes) {
    if (!flatten) {
        FileImages fimg(rodata);
        FileNameTableEntry fntent;
        FileNameTable fnt;
        vector<FileAllocationTableEntry> fatent = FileAllocationTableEntry::_make(sizes);
        FileAllocationTable fat(fatent);
        NarcHeader narc(fat, fnt, fimg);
        narcfile.write((char *)&narc, sizeof(narc));
        narcfile.write((char *)&fat, sizeof(fat));
        narcfile.write((char *)fatent.data(), fatent.size() * sizeof(FileAllocationTableEntry));
        narcfile.write((char *)&fnt, sizeof(fnt));
        narcfile.write((char *)&fntent, sizeof(fntent));
        narcfile.write((char *)&fimg, sizeof(fimg));
    }
    narcfile.write((char *)rodata.data(), rodata.size());
}

void Options::WriteNaix(vector<uint32_t> &sizes, vector<string> &names) {
    if (naix) {
        string naixname = posargs[1].substr(0, posargs[1].find_last_of('.')) + ".naix";
        string stem = naixname.substr(naixname.find_last_of('/') + 1, naixname.find_last_of('.') - naixname.find_last_of('/') - 1);
        string stem_upper = stem;
        for (auto &c : stem_upper) {
            c = toupper(c);
        }
        ofstream naixfile(naixname);
        naixfile << "/*\n"
                    " * THIS FILE WAS AUTOMATICALLY\n"
                    " *  GENERATED BY tools/o2narc\n"
                    " *      DO NOT MODIFY!!!\n"
                    " */\n"
                    "\n"
                    "#ifndef NARC_"
                 << stem_upper << "_NAIX_\n"
                                  "#define NARC_"
                 << stem_upper << "_NAIX_\n"
                                  "\n"
                                  "enum {\n";
        char num_buf[9] = "00000000";
        for (int i = 0; i < sizes.size(); i++) {
            naixfile << "    NARC_" << stem << "_";
            if (naix_names) {
                naixfile << names[i];
            } else {
                naixfile << stem << "_" << num_buf;
                for (int k = 7; k >= 0; k--) {
                    num_buf[k]++;
                    if (num_buf[k] > '9') {
                        num_buf[k] = '0';
                    } else {
                        break;
                    }
                }
            }
            naixfile << " = " << i << "," << endl;
        }
        naixfile << "};\n\n#endif //NARC_" << stem_upper << "_NAIX_\n";
    }
}

int Options::main() {
    vector<uint32_t> sizes;
    vector<string> names;
    vector<unsigned char> rodata;

    ReadObjectFile(rodata, sizes, names);
    OverwritePadding(rodata, sizes);
    WriteNarc(rodata, sizes);
    WriteNaix(sizes, names);
    return 0;
}
