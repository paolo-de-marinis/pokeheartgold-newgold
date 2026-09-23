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


if __name__ == "__main__":
    unittest.main()
