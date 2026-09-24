#!/usr/bin/env python3
"""Run the Vs. Recorder's letter-group bounds on the host against this Dex.

The search by Pokemon offers nine letter groups, ABC to YZ, each a stretch
of the Dex's alphabetical order (zukan data 13). VsRecorder_GetLetterGroupBounds
(src/overlay_40_02235E34.c) adds up the sizes of the groups' own lists in the
same archive; retail's written-in bounds stopped at its 493rd species, so YZ
showed Lickitung to Linoone. Here every species of the alphabetical order
falls in the group of its initial. test_dex_sort_lists checks that the
archive holds what zukan_data.json says, so the sizes are taken from there.
"""

import json
import unittest

from test_form_dex import run
from test_level_cap import ROOT, function

DATA = ROOT / "files/application/zukanlist/zkn_data/zukan_data.json"
GROUPS = ["abc", "def", "ghi", "jkl", "mno", "pqr", "stu", "vwx", "yz"]

PROGRAM = r'''
#include <stdio.h>
#include <stdint.h>
typedef uint16_t u16; typedef uint32_t u32;
enum { NARC_application_zukanlist_zkn_data_zukan_data = 74, NARC_zukan_data_sort_order_letter_groups_abc = 93 };
static const u32 sizes[] = { @SIZES@ };
u32 GetNarcMemberSizeByIdPair(int narc, int member) {
    return narc == NARC_application_zukanlist_zkn_data_zukan_data ? sizes[member - NARC_zukan_data_sort_order_letter_groups_abc] : 0;
}
@FUNCTION@
int main(void) {
    for (int group = 0; group < 9; group++) {
        int start, end;
        VsRecorder_GetLetterGroupBounds(group, &start, &end);
        printf("%d %d\n", start, end);
    }
    return 0;
}
'''


class VsRecorderLetterGroupTests(unittest.TestCase):
    def test_every_species_is_in_the_group_of_its_initial(self):
        options = {option["id"]: option["mons"] for group in json.loads(DATA.read_text())["sorting"] for option in group["options"]}
        naix = (ROOT / "files/application/zukanlist/zkn_data/zukan_data.naix").read_text()
        self.assertIn("NARC_zukan_data_sort_order_letter_groups_abc = 93,", naix)
        sizes = ", ".join(str(len(options[group]) * 2) for group in GROUPS)
        source = (ROOT / "src/overlay_40_02235E34.c").read_text()
        program = PROGRAM.replace("@SIZES@", sizes).replace("@FUNCTION@", function(source, "VsRecorder_GetLetterGroupBounds"))
        bounds = [tuple(map(int, line.split())) for line in run(program, "vs_recorder_").splitlines()]

        alphabetical = options["alphabetical"]
        self.assertEqual(bounds[0][0], 0)
        self.assertEqual(bounds[-1][1], len(alphabetical))
        for letters, (start, end) in zip(GROUPS, bounds):
            initials = {species[len("SPECIES_")].lower() for species in alphabetical[start:end]}
            self.assertLessEqual(initials, set(letters), f"{letters.upper()}: {start}..{end}")
        self.assertEqual(sum(end - start for start, end in bounds), len(alphabetical))


if __name__ == "__main__":
    unittest.main()
