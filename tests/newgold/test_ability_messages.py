#!/usr/bin/env python3
"""Check native ability resource indices/text without enabling expanded IDs."""

import unittest
import xml.etree.ElementTree as ET

from test_repels import BASELINE, REFERENCE, ROOT, revision


class AbilityMessages(unittest.TestCase):
    def test_native_banks_and_original_rows(self):
        changes = {720: {14: 'CompoundEyes', 31: 'Lightning Rod'},
                   721: {31: 'LIGHTNING ROD'}, 722: {}}
        for bank in (720, 721, 722):
            path = f'files/msgdata/msg/msg_{bank:04}.gmm'
            rows = ET.parse(ROOT / path).getroot().findall('row')
            self.assertEqual(len(rows), 320)
            baseline = ET.fromstring(revision(ROOT, BASELINE, path)).findall('row')
            for i, row in enumerate(rows):
                expected_attrs = baseline[i].attrib if i < len(baseline) else {
                    'id': f'msg_{bank:04}_{i:05}', 'index': str(i)}
                self.assertEqual(row.attrib, expected_attrs)
                self.assertIsNotNone(row.find("language[@name='English']").text)
                if i < len(baseline):
                    original = baseline[i]
                    if i in changes[bank]:
                        original.find("language[@name='English']").text = changes[bank][i]
                    row.tail = original.tail = None
                    self.assertEqual(ET.tostring(row), ET.tostring(original))

    @unittest.skipIf(REFERENCE is None, 'Pinned NewGold checkout not configured')
    def test_all_960_rows_are_new_gold_s_on_the_engine_s(self):
        """New Gold's text at ccf2c9f5, row for row, and the engine layer under
        it recoverable: hg-engine's own d0380a487 text differs from it only in
        konefr's rows -- Eelevate's description (313), Irrigation in the
        engine's ABILITY_TEMP2 slot (314) and Evaporate past its last row
        (319)."""
        konefr = {720: {314, 319}, 721: {314, 319}, 722: {313, 314, 319}}
        for bank in (720, 721, 722):
            engine = revision(REFERENCE, 'd0380a487', f'data/text/{bank}.txt').splitlines()
            newgold = revision(REFERENCE, '8cbe6ab86', f'data/text/{bank}.txt').splitlines()
            rows = ET.parse(ROOT / f'files/msgdata/msg/msg_{bank:04}.gmm').getroot().findall('row')
            actual = [row.find("language[@name='English']").text for row in rows]
            self.assertEqual(actual, newgold)
            differ = {i for i, line in enumerate(newgold) if i >= len(engine) or engine[i] != line}
            self.assertEqual(differ, konefr[bank])

if __name__ == '__main__':
    unittest.main()
