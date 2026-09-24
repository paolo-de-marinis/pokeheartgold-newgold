#!/usr/bin/env python3
"""Check an archive built from a template is rebuilt when a header it
includes changes.

jsonproc turns a json file and a template into C or assembly, which is
compiled on the spot and packed into the archive. The compiler's dependency
files are only kept for the objects under build/, so a header the rule does
not name is invisible to make: renumber a constant or change a record's
layout, and an incremental build keeps the old archive. It happened once
already -- evo.narc stayed 575 members long for 1042 species.

global.h is left out: every rule has it order-only, for the fx_const.h it
needs generated first, as pret wrote them.
"""

import re
import unittest

from test_level_cap import ROOT

# Each template that includes a header, and the makefile of its rule.
RULES = {
    "files/application/zukanlist/zkn_data/zukan_data.json.txt": "files/application/zukanlist/zkn_data/zukan_data.mk",
    "files/arc/headbutt.json.txt": "files/arc/headbutt.mk",
    "files/arc/ppark.json.txt": "files/arc/ppark.mk",
    "files/arc/safari_enc.json.txt": "files/arc/safari_enc.mk",
    "files/data/photo_data.json.txt": "files/data/photo_data.mk",
    "files/data/resdat.json.txt": "files/data/resdat.mk",
    "files/fielddata/encountdata/gs_enc_data.json.txt": "files/fielddata/encountdata/gs_enc_data.mk",
    "files/fielddata/eventdata/zone_event.json.txt": "files/fielddata/eventdata/zone_event.mk",
    "files/fielddata/wazaoshie/waza_oshie.json.txt": "files/fielddata/wazaoshie/waza_oshie.mk",
    "files/poketool/personal/evo.json.txt": "files/poketool/personal/evo.mk",
    "files/poketool/personal/personal.json.txt": "files/poketool/personal/personal.mk",
    "files/poketool/trainer/trdata.json.txt": "files/poketool/trainer/trainer.mk",
    "files/poketool/trainer/trpoke.json.txt": "files/poketool/trainer/trainer.mk",
    "files/tel/pmtel_book.json.txt": "files/tel/pmtel_book.mk",
}

# Each template that loops over a json object (for key, value in object), and
# what keeps the order of that object's keys the order the loop needs.
OBJECT_LOOPS = {
    # the archive's members, one per method and species: dex_areas.py pads
    # the species' numbers to one width, test_dex_area checks the order
    "files/application/zukanlist/zkn_data/zukan_enc.json.txt": "tools/newgold/devkit/dex_areas.py",
}


class ArchiveRuleTests(unittest.TestCase):
    def test_every_included_header_is_a_prerequisite(self):
        for template, makefile in RULES.items():
            rule = (ROOT / makefile).read_text()
            # A header named by the json ({{ header }}) is not a fixed file.
            for header in re.findall(r'#include "([^"{]+)"', (ROOT / template).read_text()):
                if header != "global.h":
                    self.assertTrue("include/" + header in rule, f"{makefile}: {template} includes {header}")

    def test_jsonproc_is_not_handed_the_headers(self):
        """It takes exactly the json, the template and the output; given a
        header as well it prints its usage line and writes nothing."""
        for makefile in sorted(ROOT.glob("files/**/*.mk")):
            self.assertFalse("$(JSONPROC) $^" in makefile.read_text(), makefile.relative_to(ROOT))

    def test_a_template_that_loops_over_an_object_is_known(self):
        """jsonproc reads a json object into a sorted map, so a loop over one
        takes the members in their keys' order, not the file's: mon_1000
        before mon_100, and an archive's members out of place with no error.
        A template that does must be listed above with what holds its keys'
        order."""
        loop = re.compile(r"(?:^[ \t]*##|\{%-?)\s*for\s+\w+\s*,\s*\w+\s+in\b", re.M)
        found = {str(t.relative_to(ROOT)) for t in ROOT.glob("files/**/*.json.txt") if loop.search(t.read_text())}
        self.assertEqual(found, set(OBJECT_LOOPS))
        for keeper in OBJECT_LOOPS.values():
            self.assertTrue((ROOT / keeper).exists(), keeper)


if __name__ == "__main__":
    unittest.main()
