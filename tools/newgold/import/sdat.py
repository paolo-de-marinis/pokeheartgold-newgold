#!/usr/bin/env python3
"""Read and write the sound archive.

pret ships files/data/sound/gs_sound_data.sdat as a binary, so there is no
text source to add sounds to. This decodes the four blocks it is made of and
re-encodes them, and refuses to be trusted until the round trip reproduces the
original byte for byte.

    SYMB  a name for each record, most of them empty
    INFO  one record per sound, saying which file holds it
    FAT   where each file is and how long
    FILE  the files themselves

A Pokemon's cry is wave archive N, where N is its number, played as sequence 2
on bank N -- or, where N has no bank of its own (every added cry), on bank 1:
all of HeartGold's cry banks are the same seventy-six bytes naming one
instrument, and the wave archive holds the one sample.
"""

import struct
from pathlib import Path

KINDS = ["SSEQ", "SSAR", "SBNK", "SWAR", "PLAYER", "GROUP", "PLAYER2", "STRM"]
HEADER_SIZE = 0x40


def _align(n, to=4):
    return (n + to - 1) & ~(to - 1)


class Sdat:
    def __init__(self, data):
        self.data = data
        size, headerSize, blocks = struct.unpack("<IHH", data[8:16])
        if data[:4] != b"SDAT" or size != len(data):
            raise ValueError("not a sound archive")
        self.blockCount = blocks
        offsets = struct.unpack("<8I", data[0x10:0x30])
        self.blocks = {name: (offsets[2 * i], offsets[2 * i + 1])
                       for i, name in enumerate(["SYMB", "INFO", "FAT", "FILE"])}
        self._readSymbols()
        self._readInfo()
        self._readFiles()

    # --- reading ---

    def _readSymbols(self):
        base = self.blocks["SYMB"][0]
        pointers = struct.unpack("<8I", self.data[base + 8:base + 0x28])
        self.names = {}
        for kind, pointer in zip(KINDS, pointers):
            if not pointer:
                self.names[kind] = []
                continue
            here = base + pointer
            count, = struct.unpack("<I", self.data[here:here + 4])
            entries = struct.unpack(f"<{count}I", self.data[here + 4:here + 4 + 4 * count])
            out = []
            for entry in entries:
                if entry == 0:
                    out.append(None)
                else:
                    end = self.data.index(b"\0", base + entry)
                    out.append(self.data[base + entry:end].decode("ascii"))
            self.names[kind] = out

    def _readInfo(self):
        base = self.blocks["INFO"][0]
        pointers = struct.unpack("<8I", self.data[base + 8:base + 0x28])
        self.records = {}
        for kind, pointer in zip(KINDS, pointers):
            here = base + pointer
            count, = struct.unpack("<I", self.data[here:here + 4])
            entries = struct.unpack(f"<{count}I", self.data[here + 4:here + 4 + 4 * count])
            out = []
            for entry in entries:
                out.append(None if entry == 0 else self._recordBytes(base + entry, kind))
            self.records[kind] = out

    _SIZES = {"SSEQ": 12, "SSAR": 4, "SBNK": 12, "SWAR": 4,
              "PLAYER": 8, "GROUP": 0, "PLAYER2": 4, "STRM": 12}

    def _recordBytes(self, at, kind):
        if kind == "GROUP":
            count, = struct.unpack("<I", self.data[at:at + 4])
            return self.data[at:at + 4 + 8 * count]
        return self.data[at:at + self._SIZES[kind]]

    def _readFiles(self):
        base = self.blocks["FAT"][0]
        count, = struct.unpack("<I", self.data[base + 8:base + 12])
        self.files = []
        self.fatExtra = []
        for i in range(count):
            here = base + 12 + 16 * i
            start, size, a, b = struct.unpack("<IIII", self.data[here:here + 16])
            self.files.append(self.data[start:start + size])
            self.fatExtra.append((a, b))

    # --- writing ---

    def build(self):
        symb = self._buildSymbols()
        info = self._buildInfo()
        fatOffset = HEADER_SIZE + len(symb) + len(info)
        fatSize = 12 + 16 * len(self.files)
        fileOffset = fatOffset + fatSize
        fat, fileBlock = self._buildFilesAndFat(fileOffset)

        size = HEADER_SIZE + len(symb) + len(info) + len(fat) + len(fileBlock)
        header = bytearray(HEADER_SIZE)
        header[0:4] = b"SDAT"
        struct.pack_into("<HHIHH", header, 4, 0xFEFF, 0x0100, size, HEADER_SIZE, self.blockCount)
        struct.pack_into("<8I", header, 0x10,
                         HEADER_SIZE, self.symbolsExactSize,
                         HEADER_SIZE + len(symb), len(info),
                         fatOffset, len(fat),
                         fileOffset, len(fileBlock))
        return bytes(header) + symb + info + fat + fileBlock

    def _buildSymbols(self):
        # The names follow the tables, and every offset is from the block start.
        tables, strings = bytearray(), bytearray()
        head = 8 + 4 * 8 + 24  # magic, size, eight pointers, the padding retail leaves
        pointers = []
        for kind in KINDS:
            # Retail writes a table for every kind, empty ones included, so the
            # pointers are never zero and the strings start after all eight.
            entries = self.names[kind]
            pointers.append(head + len(tables))
            tables += struct.pack("<I", len(entries)) + b"\0" * (4 * len(entries))
        stringBase = head + len(tables)
        cursor = {}
        for kind in KINDS:
            for name in self.names[kind]:
                if name is not None and name not in cursor:
                    cursor[name] = stringBase + len(strings)
                    strings += name.encode("ascii") + b"\0"
        at = 0
        for kind in KINDS:
            entries = self.names[kind]
            for i, name in enumerate(entries):
                struct.pack_into("<I", tables, at + 4 + 4 * i, 0 if name is None else cursor[name])
            at += 4 + 4 * len(entries)

        body = bytearray(struct.pack("<8I", *pointers)) + b"\0" * 24 + tables + strings
        # The block's own size field is rounded up; the archive header records
        # where the content actually ends. Retail writes both.
        exact = 8 + len(body)
        size = _align(exact, 4)
        block = bytearray(b"SYMB" + struct.pack("<I", size) + body)
        block += b"\0" * (size - len(block))
        self.symbolsExactSize = exact
        return bytes(block)

    def _buildInfo(self):
        # Unlike the names, each kind's records follow its own table rather
        # than all the tables coming first.
        head = 8 + 4 * 8 + 24
        body, pointers = bytearray(), []
        for kind in KINDS:
            entries = self.records[kind]
            pointers.append(head + len(body))
            table = bytearray(struct.pack("<I", len(entries)) + b"\0" * (4 * len(entries)))
            records = bytearray()
            recordBase = head + len(body) + len(table)
            for i, record in enumerate(entries):
                if record is None:
                    continue
                struct.pack_into("<I", table, 4 + 4 * i, recordBase + len(records))
                records += record
            body += table + records

        block = bytearray(struct.pack("<8I", *pointers)) + b"\0" * 24 + body
        exact = 8 + len(block)
        size = _align(exact, 4)
        out = bytearray(b"INFO" + struct.pack("<I", size) + block)
        out += b"\0" * (size - len(out))
        return bytes(out)

    def _buildFilesAndFat(self, fileOffset):
        fat = bytearray(b"FAT " + struct.pack("<II", 12 + 16 * len(self.files), len(self.files)))
        # Sixteen bytes of block header, then every file on a thirty-two byte
        # boundary measured from the start of the archive.
        header = 16
        body = bytearray()
        for i, blob in enumerate(self.files):
            start = _align(fileOffset + header + len(body), 32)
            body += b"\0" * (start - (fileOffset + header + len(body))) + blob
            fat += struct.pack("<IIII", start, len(blob), *self.fatExtra[i])
        end = _align(fileOffset + header + len(body), 32)
        body += b"\0" * (end - (fileOffset + header + len(body)))
        block = b"FILE" + struct.pack("<II", header + len(body), len(self.files)) + b"\0" * 4 + bytes(body)
        return bytes(fat), block


def load(path):
    return Sdat(Path(path).read_bytes())
