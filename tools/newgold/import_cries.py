#!/usr/bin/env python3
"""Give the added species their cries.

A cry is bank N and wave archive N played as sequence 2, where N is the
species number, so the cries stop where HeartGold's species do. The added ones
get banks of their own past the end of the archive, and PlayCry is told where
to find them.

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

ROOT = Path(__file__).resolve().parents[2]
ARCHIVE = ROOT / "files/data/sound/gs_sound_data.sdat"

sys.path.insert(0, str(Path(__file__).resolve().parent))
import import_species  # noqa: E402
import sdat  # noqa: E402

# The rate HeartGold's own cries are recorded at, and the timer the hardware
# needs for it.
CRY_RATE = 10512
NDS_CLOCK = 16756991

# A form has no cry of its own; it uses its base species'.
SHARED_WITH = {
    "SLOWPOKE_GALARIAN": "SLOWPOKE",
    "SLOWBRO_GALARIAN": "SLOWBRO",
}


def reference_species(reference):
    header = (reference / "include/constants/species.h").read_text(errors="replace")
    return {m[1][len("SPECIES_"):]: int(m[2]) for m in
            re.finditer(r"#define (SPECIES_[A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}


def our_species():
    header = (ROOT / "include/constants/species.h").read_text()
    return {m[1][len("SPECIES_"):]: int(m[2]) for m in
            re.finditer(r"#define (SPECIES_[A-Z0-9_]+)\s+(\d+)\s*$", header, re.M)}


def samples(path):
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
    wanted = max(1, round(len(values) * CRY_RATE / rate))
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


def wave_archive(pcm):
    """A SWAR holding one sample, which is all a cry ever is."""
    swav = struct.pack("<BBHHHI", 0, 0, CRY_RATE, round(NDS_CLOCK / CRY_RATE),
                       0, len(pcm) // 4) + pcm
    size = 0x40 + len(swav)
    out = bytearray(b"SWAR" + struct.pack("<IIHH", 0x0100FEFF, size, 0x10, 1))
    out += b"DATA" + struct.pack("<I", size - 0x10) + b"\0" * 32
    out += struct.pack("<II", 1, 0x40)  # one sample, and where it starts
    out += swav
    return bytes(out)


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
    added = [name for name in import_species.NEW_SPECIES if name not in SHARED_WITH]
    shared = {name: ours[base] for name, base in SHARED_WITH.items()}

    firstBank = len(archive.records["SBNK"])
    model = archive.records["SBNK"][1]
    modelFile = struct.unpack("<H", model[:2])[0]
    bankBytes = archive.files[modelFile]

    mapping, bytesAdded = {}, 0
    for offset, name in enumerate(added):
        number = theirs.get(name)
        path = args.reference / "sound/cries" / f"{number:03d}.wav" if number else None
        if path is None or not path.exists():
            raise SystemExit(f"the reference has no cry for {name}")
        war = wave_archive(samples(path))
        bytesAdded += len(war) + len(bankBytes)

        warFile = len(archive.files)
        archive.files.append(war)
        archive.fatExtra.append((0, 0))
        bankFile = len(archive.files)
        archive.files.append(bankBytes)
        archive.fatExtra.append((0, 0))

        index = firstBank + offset
        archive.records["SWAR"].append(struct.pack("<HH", warFile, 0))
        archive.records["SBNK"].append(struct.pack("<HH4H", bankFile, 0, index, 0xFFFF, 0xFFFF, 0xFFFF))
        archive.names["SWAR"].append(None)
        archive.names["SBNK"].append(None)
        mapping[name] = index

    for name, base in shared.items():
        mapping[name] = base

    print(f"{len(added)} cries added as banks {firstBank} to {firstBank + len(added) - 1}, "
          f"{bytesAdded // 1024} KiB")
    for name, base in SHARED_WITH.items():
        print(f"  {name} shares {base}'s cry, bank {mapping[name]}")

    table = "\n".join(f"    {mapping[name]}, // {name.title().replace('_', ' ')}"
                      for name in import_species.NEW_SPECIES)
    if not args.write:
        print("nothing written; pass --write")
        print(table)
        return

    ARCHIVE.write_bytes(archive.build())
    print(f"wrote {ARCHIVE.relative_to(ROOT)}, {ARCHIVE.stat().st_size // 1024} KiB")
    (ROOT / "tools/newgold/cry_banks.txt").write_text(table + "\n")


if __name__ == "__main__":
    main()
