#!/usr/bin/env python3
"""save_layout.json, the save's block sizes for a tree with no build, and
the one header make generates that the editor's compiles include.

The sizes come out of the built ROM, since the game's Save_*_sizeof exist in
no other form; a clone has no ROM, so the save editor reads them from this
file instead. A block that changes size without the file written again is a
clone that misreads every save, so it fails here. After make:

    python3 tools/newgold/devkit/harness/save_budget.py --write
"""

import json
import shutil
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from test_level_cap import ROOT

sys.path[:0] = [str(ROOT / "tools/newgold" / sub) for sub in ("import", "devkit", "devkit/harness")]
import save_budget  # noqa: E402
import savedit as sv  # noqa: E402

BUILD = ROOT / "build/heartgold.us"


class SaveLayoutFileTests(unittest.TestCase):
    def setUp(self):
        if not (BUILD / "main.sbin").exists():
            self.skipTest("the ROM has not been built")

    def test_the_file_is_what_the_build_measures(self):
        self.assertEqual(json.loads(save_budget.LAYOUT.read_text()), save_budget.sizes(BUILD),
                         "a save block changed size: python3 tools/newgold/devkit/harness/save_budget.py --write")

    def test_a_clone_lays_the_save_out_as_the_build_does(self):
        """No build, nothing behind it, nothing to disagree with."""
        with tempfile.TemporaryDirectory() as none:
            self.assertIsNone(sv.linked(none))
            self.assertEqual(sv.blocks(none), sv.blocks(BUILD))
            self.assertEqual(sv.extra_chunks(none), sv.extra_chunks(BUILD))
            self.assertEqual((sv.build_behind(none), sv.layout_file_differs(none)), ([], []))

    def test_a_file_the_build_disagrees_with_is_named(self):
        with tempfile.TemporaryDirectory() as tmp:
            kept = json.loads(save_budget.LAYOUT.read_text())
            kept["Save_Pokedex_sizeof"] += 4
            stale = Path(tmp) / "save_layout.json"
            stale.write_text(json.dumps(kept))
            with mock.patch.object(save_budget, "LAYOUT", stale):
                self.assertEqual(sv.layout_file_differs(BUILD), ["Save_Pokedex_sizeof"])

    def test_a_clone_makes_fx_const_h_as_make_does(self):
        """global.h includes it, and only make writes it (ignored by git)."""
        with tempfile.TemporaryDirectory() as tmp:
            shutil.copytree(ROOT / "tools/gen_fx_consts", Path(tmp) / "tools/gen_fx_consts")
            (Path(tmp) / "lib/include/nitro/fx").mkdir(parents=True)
            with mock.patch.object(sv, "ROOT", Path(tmp)):
                sv.made_fx_const()
            self.assertEqual(sorted(p.name for p in (Path(tmp) / "lib/include/nitro/fx").iterdir()), ["fx_const.h"])
            self.assertEqual((Path(tmp) / "lib/include/nitro/fx/fx_const.h").read_bytes(),
                             (ROOT / "lib/include/nitro/fx/fx_const.h").read_bytes())


if __name__ == "__main__":
    unittest.main()
