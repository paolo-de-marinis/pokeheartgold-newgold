#!/usr/bin/env python3
"""Check native ability resource indices/text without enabling expanded IDs."""

import unittest
import xml.etree.ElementTree as ET

from test_repels import BASELINE, REFERENCE, REFERENCE_COMMIT, ROOT, revision


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
    def test_all_960_rows_match_pinned_newgold(self):
        for bank in (720, 721, 722):
            expected = revision(REFERENCE, REFERENCE_COMMIT, f'data/text/{bank}.txt').splitlines()
            rows = ET.parse(ROOT / f'files/msgdata/msg/msg_{bank:04}.gmm').getroot().findall('row')
            actual = [row.find("language[@name='English']").text for row in rows]
            self.assertEqual(actual, expected)


if __name__ == '__main__':
    unittest.main()
