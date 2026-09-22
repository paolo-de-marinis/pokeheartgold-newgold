#!/usr/bin/env python3
"""Check that a built archive's allocation table matches its image.

o2narc starts every member on a four byte boundary, so a table whose row is
not a multiple of four needs padding inserted after each row. It used to write
that padding over the image instead, which left the image packed while the
table walked it in aligned strides: from the second member on, the table
pointed two bytes further along for every odd-sized member before it, and the
last members pointed past the end of the image entirely.

Only one archive here has ever had an odd-sized row -- evo.narc's became 50
bytes when MAX_EVOS_PER_POKE went to 8 for Sylveon, and from then until this
was found every Pokemon's evolutions were read from the wrong offset. Nothing
about it was loud: the archive built, the ROM booted, and the mons simply
evolved into whatever the misread bytes named.

The archives are build output, so this passes vacuously in a clean tree.
"""

import struct
import unittest

from test_level_cap import ROOT


def chunks(data):
    header_size, count = struct.unpack_from("<HH", data, 12)
    found, offset = {}, header_size
    for _ in range(count):
        name, size = struct.unpack_from("<4sI", data, offset)
        found[name] = (offset, size)
        offset += size
    return found


def allocation(path):
    """(members, last byte the table claims, bytes the image holds)."""
    data = path.read_bytes()
    if data[:4] != b"NARC":
        return None
    found = chunks(data)
    table = found[b"BTAF"][0]
    count = struct.unpack_from("<I", data, table + 8)[0]
    if not count:
        return None
    entries = [struct.unpack_from("<II", data, table + 12 + 8 * i) for i in range(count)]
    return count, max(end for _, end in entries), found[b"GMIF"][1] - 8


class NarcAllocationTests(unittest.TestCase):
    def test_no_allocation_table_runs_past_its_image(self):
        built = 0
        for path in sorted((ROOT / "files").rglob("*.narc")):
            found = allocation(path)
            if found is None:
                continue
            built += 1
            count, claimed, held = found
            self.assertLessEqual(claimed, held,
                                 f"{path.relative_to(ROOT)}: the table claims {claimed} bytes "
                                 f"for {count} members, the image holds {held}")
        print(f"\n{built} built archives checked")


if __name__ == "__main__":
    unittest.main()
