#!/usr/bin/env python3
"""Check the reader that says where the player is.

It walks sFieldSysPtr to the player's tile and to the party count through
structs this repository declares. If one of those structs gains a field in
front of the one it reads, the walk silently lands somewhere else, and the
scripted sessions it drives would be aiming at nothing. So the offsets are
held against the headers they came from.
"""

import re
import sys
import unittest
from pathlib import Path

from test_level_cap import ROOT

sys.path.insert(0, str(ROOT / "tools/newgold"))
import where  # noqa: E402


def field_offset(header, struct_name, field):
    """Count a struct of words and pointers up to one of its fields.

    Everything before the fields this reads is one word wide, so the offset is
    the field's place in the list times four. A field that is not a single
    word would break that, and the test says so rather than guessing.
    """
    lines = (ROOT / header).read_text().splitlines()
    start = next(i for i, l in enumerate(lines)
                 if re.search(re.escape(struct_name) + r"\b", l) and "{" in l)
    offset = 0
    for line in lines[start + 1:]:
        if line.startswith("}"):
            break
        line = re.sub(r"/\*.*?\*/", "", line.split("//")[0]).strip()
        if not line:
            continue
        match = re.search(r"(\w+);$", line)
        if not match:
            return None
        if match.group(1) == field:
            return offset
        if "[" in line or ":" in line:
            return None  # not one word wide, so the count stops meaning anything
        offset += 4
    return None


class WhereTests(unittest.TestCase):
    def test_the_symbol_is_in_the_rom(self):
        if not (ROOT / "build/heartgold.us/main.elf").exists():
            self.skipTest("the ROM has not been built")
        address = where.symbol("sFieldSysPtr")
        self.assertTrue(0x02000000 <= address < 0x02400000, hex(address))
        print(f"PASS: sFieldSysPtr at {address:#010x}.")

    def test_the_field_system_still_keeps_the_avatar_where_this_looks(self):
        self.assertEqual(field_offset("include/field_system.h", "struct FieldSystem", "playerAvatar"),
                         where.PLAYER_AVATAR)
        self.assertEqual(field_offset("include/field_system.h", "struct FieldSystem", "saveData"),
                         where.SAVE_DATA)

    def test_the_avatar_still_keeps_its_map_object_where_this_looks(self):
        self.assertEqual(field_offset("include/player_avatar.h", "struct PlayerAvatar", "mapObject"),
                         where.MAP_OBJECT)

    def test_the_map_object_still_keeps_its_tile_where_this_looks(self):
        text = (ROOT / "include/map_object.h").read_text()
        for name, offset in (("currentX", where.CURRENT_X), ("currentZ", where.CURRENT_Z)):
            match = re.search(rf"/\*(0x[0-9A-Fa-f]+)\*/ u32 {name};", text)
            self.assertIsNotNone(match, name)
            self.assertEqual(int(match.group(1), 16), offset, name)

    def test_the_party_count_is_where_this_looks(self):
        self.assertEqual(field_offset("include/pokemon_types_def.h", "typedef struct PartyCore", "curCount"),
                         where.PARTY_COUNT)


if __name__ == "__main__":
    unittest.main()
