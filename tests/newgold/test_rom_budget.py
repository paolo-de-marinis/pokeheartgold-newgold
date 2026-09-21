#!/usr/bin/env python3
"""Check that the card is big enough for the range being imported.

The whole next phase is bounded by one number in rom.rsf. At 1G the two ROMs
used 128,766,012 of 134,217,728 bytes, so about five megabytes were free and
the 501 species still to come need roughly eleven in battle sprites alone: the
import would have failed at the last archive, after everything else was right.

The header carries the used size, so the free space is measured rather than
assumed, and a build that outgrows the card fails here instead of at link time.
"""

import struct
import unittest
from pathlib import Path

from test_level_cap import ROOT

USED_SIZE = 0x80        # the NDS header's total used ROM size
WANTED = "2G"
HEADROOM = 64 * 1024 * 1024

ROMS = {"HeartGold": ROOT / "build/heartgold.us/pokeheartgold.us.nds",
        "SoulSilver": ROOT / "build/soulsilver.us/pokesoulsilver.us.nds"}


class RomBudgetTests(unittest.TestCase):
    def test_the_card_is_the_size_the_phase_needs(self):
        rsf = (ROOT / "rom.rsf").read_text()
        self.assertIn(f"RomSize {WANTED}", rsf,
                      "the expansion needs the bigger card; see docs/newgold/SCOPE.md")

    def test_every_built_rom_has_room_to_grow(self):
        built = {name: path for name, path in ROMS.items() if path.exists()}
        if not built:
            self.skipTest("neither ROM has been built")
        for name, path in built.items():
            header = path.read_bytes()[:0x100]
            used, = struct.unpack("<I", header[USED_SIZE:USED_SIZE + 4])
            size = path.stat().st_size
            self.assertLessEqual(used, size, f"{name} says it uses more than it is")
            self.assertGreaterEqual(size - used, HEADROOM,
                                    f"{name} has {(size - used) // 1048576} MiB free")
            print(f"PASS: {name} uses {used:,} of {size:,} bytes, "
                  f"{(size - used) / 1048576:.0f} MiB free.")


if __name__ == "__main__":
    unittest.main()
