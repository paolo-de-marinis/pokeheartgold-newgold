#!/usr/bin/env python3
"""Give the added species their cries.

A cry is wave archive N played as sequence 2, where N is the species number,
so the cries stop where HeartGold's species do. HeartGold gives each one a
bank N too, but every cry bank is the same seventy-six bytes naming one
instrument, and each bank costs the sound heap its records; so bank 1 is kept
and the others go, an added cry is a wave archive past the end of the archive
and nothing else, and the loader (lib/NitroSystem/src/sndarc_loader.c) plays a
number with a wave archive and no bank on bank 1's instrument, as hg-engine
does. PlayCry is told where to find each added one.

The sound itself comes from the reference, which ships a cry for every species
the engine knows as a mono WAV. It is resampled and reduced to the eight-bit
samples this archive uses, at the rate the game's own cries are recorded at.

The two regional forms have no cry of their own in the reference either; they
share the one their base species has, which this game already has.

Usage: import_cries.py REFERENCE_CHECKOUT [--write]
"""

import argparse
import re
import struct
import sys
import wave
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
ARCHIVE = ROOT / "files/data/sound/gs_sound_data.sdat"

sys.path.insert(0, str(Path(__file__).resolve().parent))
import import_species  # noqa: E402
import sdat  # noqa: E402

# The rate HeartGold's own cries are recorded at, and the timer the hardware
# needs for it.
CRY_RATE = 10512
NDS_CLOCK = 16756991
# The archive this import appends to: HeartGold's own, 778 banks, as it was
# before any cry was added -- `git show 4c8176ea1^:files/data/sound/
# gs_sound_data.sdat`. Every run appends the whole added range, so it has to
# start from that one or the archive doubles. It used to start from the 843
# banks 4c8176ea1 left, the first sixty-five added species among them, and
# appended those sixty-five again: 778 to 842 were copies nothing played,
# 3,648 bytes of the sound heap the archive's tables are loaded into.
BASE_BANKS = 778

# A form has no cry of its own; it uses its base species'.
SHARED_WITH = {
    "SLOWPOKE_GALARIAN": "SLOWPOKE",
    "SLOWBRO_GALARIAN": "SLOWBRO",
}


def reference_species(reference):
    """The reference's numbers. A few of its lines carry a trailing comment --
    Vivillon's names its pattern -- so the number is read without anchoring at
    the end of the line."""
    header = (reference / "include/constants/species.h").read_text(errors="replace")
    return {m[1][len("SPECIES_"):]: int(m[2]) for m in
            re.finditer(r"#define (SPECIES_[A-Z0-9_]+)\s+(\d+)\s*(?://.*)?$", header, re.M)}


def our_species():
    header = (ROOT / "include/constants/species.h").read_text()
    return {m[1][len("SPECIES_"):]: int(m[2]) for m in
            re.finditer(r"#define (SPECIES_[A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}


def samples(path, target=CRY_RATE):
    """Mono eight-bit samples at the rate this archive uses."""
    with wave.open(str(path)) as source:
        channels, width, rate, frames = (source.getnchannels(), source.getsampwidth(),
                                         source.getframerate(), source.getnframes())
        raw = source.readframes(frames)
    if width != 2:
        raise SystemExit(f"{path.name}: expected sixteen-bit samples, got {width * 8}")
    values = list(struct.unpack(f"<{len(raw) // 2}h", raw))
    if channels > 1:
        values = [sum(values[i:i + channels]) // channels
                  for i in range(0, len(values) - channels + 1, channels)]

    # Linear resampling. The source rates are close to the target and the
    # sounds are short, so nothing more elaborate earns its place here.
    wanted = max(1, round(len(values) * target / rate))
    out = bytearray()
    for i in range(wanted):
        position = i * (len(values) - 1) / max(1, wanted - 1)
        low = int(position)
        high = min(low + 1, len(values) - 1)
        value = values[low] + (values[high] - values[low]) * (position - low)
        out.append(int(max(-128, min(127, round(value / 256)))) & 0xFF)
    while len(out) % 4:
        out.append(0)
    return bytes(out)


def wave_archive(pcm, rate=CRY_RATE):
    """A SWAR holding one sample, which is all a cry ever is."""
    swav = struct.pack("<BBHHHI", 0, 0, rate, round(NDS_CLOCK / rate),
                       0, len(pcm) // 4) + pcm
    size = 0x40 + len(swav)
    out = bytearray(b"SWAR" + struct.pack("<IIHH", 0x0100FEFF, size, 0x10, 1))
    out += b"DATA" + struct.pack("<I", size - 0x10) + b"\0" * 32
    out += struct.pack("<II", 1, 0x40)  # one sample, and where it starts
    out += swav
    return bytes(out)


def cry_room(archive):
    """The most a cry's bank and wave archive may weigh together: HeartGold's
    largest, Jynx's. A cry plays from the heap of the player sequence 2 runs
    on (PLAYER 0, 24,200 bytes), which the sequence, the bank and the wave
    archive all load into; one that does not fit is never started, and the
    species has no cry at all. The bank is bank 1's, whichever the cry."""
    bank = len(archive.files[struct.unpack("<H", archive.records["SBNK"][1][:2])[0]])
    return max(bank + len(archive.files[struct.unpack("<H", archive.records["SWAR"][war][:2])[0]])
               for war in range(1, 0x1EF))


def fitted_cry(path, room, bankSize):
    """The cry's wave archive, at the archive's rate when it fits the cry
    player's heap and at the rate that makes it fit when it does not: a long
    cry sampled a little lower still plays whole."""
    rate = CRY_RATE
    war = wave_archive(samples(path, rate), rate)
    while len(war) + bankSize > room:
        # The samples take all but the 0x4C bytes of the archive's headers.
        rate = int(rate * (room - bankSize - 0x4C) / (len(war) - 0x4C))
        war = wave_archive(samples(path, rate), rate)
    return war


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    archive = sdat.load(ARCHIVE)
    if archive.build() != archive.data:
        raise SystemExit("the archive does not round-trip; refusing to write")

    theirs = reference_species(args.reference)
    ours = our_species()
    # A form has no cry of its own; it uses its base species'.
    sharing = dict(SHARED_WITH)
    for form, base in import_species.base_species_of(args.reference).items():
        if form in ours:
            sharing.setdefault(form, base)
    added = [name for name in import_species.added_species() if name not in sharing]

    first = len(archive.records["SWAR"])
    if first != BASE_BANKS or len(archive.records["SBNK"]) != BASE_BANKS:
        raise SystemExit(f"the archive holds {first} wave archives and this import appends to the one with "
                         f"{BASE_BANKS}: git show 4c8176ea1^:files/data/sound/gs_sound_data.sdat > "
                         "files/data/sound/gs_sound_data.sdat first")
    model = archive.records["SBNK"][1]
    modelFile = struct.unpack("<H", model[:2])[0]
    bankBytes = archive.files[modelFile]
    room = cry_room(archive)

    # HeartGold's own cry banks, 2 to 494: each is bank 1's instrument on its
    # own wave archive, so each goes, record and file, and the loader plays
    # the wave archive on bank 1. Bank 1 stays, the instrument they share.
    for bank in range(2, 0x1EF):
        fileId, _, *waves = struct.unpack("<HH4H", archive.records["SBNK"][bank])
        if archive.files[fileId] != bankBytes or waves != [bank, 0xFFFF, 0xFFFF, 0xFFFF]:
            raise SystemExit(f"bank {bank} is not bank 1's instrument on wave archive {bank}")
        archive.records["SBNK"][bank] = None
        archive.names["SBNK"][bank] = None

    mapping, bytesAdded = {}, 0
    for offset, name in enumerate(added):
        number = theirs.get(name)
        path = args.reference / "sound/cries" / f"{number:03d}.wav" if number else None
        if path is None or not path.exists():
            raise SystemExit(f"the reference has no cry for {name}")
        war = fitted_cry(path, room, len(bankBytes))
        bytesAdded += len(war)

        warFile = len(archive.files)
        archive.files.append(war)
        archive.fatExtra.append((0, 0))

        index = first + offset
        archive.records["SWAR"].append(struct.pack("<HH", warFile, 0))
        archive.names["SWAR"].append(None)
        mapping[name] = index

    archive.drop_unused_files()

    for name, base in sharing.items():
        # An added base has a wave archive of its own; a retail one's is its number.
        mapping[name] = mapping[base] if base in mapping else ours[base]

    print(f"{len(added)} cries added as wave archives {first} to {first + len(added) - 1}, "
          f"{bytesAdded // 1024} KiB")
    print(f"  {len(sharing)} share their base species' cry")

    table = "\n".join(f"    {mapping[name]}, // {name.title().replace('_', ' ')}"
                      for name in import_species.added_species())
    if not args.write:
        print("nothing written; pass --write")
        print(table)
        return

    ARCHIVE.write_bytes(archive.build())
    print(f"wrote {ARCHIVE.relative_to(ROOT)}, {ARCHIVE.stat().st_size // 1024} KiB")
    (ROOT / "tools/newgold/import/cry_banks.txt").write_text(table + "\n")

    # The lookup that turns a species into a bank lives in C and used to be
    # kept by hand, which is how it came to name sixty-seven species while the
    # archive held five hundred. It is written from the same mapping now, so
    # the two cannot drift apart again.
    source = ROOT / "src/unk_02005D10.c"
    text = source.read_text()
    start = text.index("static const u16 sAddedCryBanks[] = {")
    end = text.index("};", start) + len("};")
    text = text[:start] + "static const u16 sAddedCryBanks[] = {\n" + table + "\n};" + text[end:]
    text = re.sub(r"#define ARCHIVE_WAVE_ARC_COUNT\s+\d+",
                  f"#define ARCHIVE_WAVE_ARC_COUNT {len(archive.records['SWAR'])}", text)
    source.write_text(text)
    print(f"wrote {source.relative_to(ROOT)}: {len(mapping)} cries, "
          f"ARCHIVE_WAVE_ARC_COUNT {len(archive.records['SWAR'])}")


if __name__ == "__main__":
    main()
