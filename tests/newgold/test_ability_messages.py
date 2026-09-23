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
    def test_all_960_rows_are_the_engine_s(self):
        """The engine layer: hg-engine's own text at d0380a487, row for row.
        Evaporate (319) is past the engine's last row and reads as its unused
        slot; Irrigation is the engine's slot 314, ABILITY_TEMP2. konefr's
        names for both and the Eelevate description (313) are New Gold's."""
        unused = {720: 'Placeholder', 721: 'PLACEHOLDER', 722: 'Placeholder'}
        pinned = {720: ['Eelevate', 'Placeholder', 'Placeholder'],
                  721: ['EELEVATE', 'PLACEHOLDER', 'PLACEHOLDER'], 722: ['Placeholder'] * 3}
        for bank in (720, 721, 722):
            expected = revision(REFERENCE, 'd0380a487', f'data/text/{bank}.txt').splitlines()
            rows = ET.parse(ROOT / f'files/msgdata/msg/msg_{bank:04}.gmm').getroot().findall('row')
            actual = [row.find("language[@name='English']").text for row in rows]
            self.assertEqual(actual, expected + [unused[bank]])
            self.assertEqual([actual[i] for i in (313, 314, 319)], pinned[bank])


if __name__ == '__main__':
    unittest.main()
