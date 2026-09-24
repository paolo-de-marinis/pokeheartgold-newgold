#!/usr/bin/env python3
"""Put back the </row> a union merge of two appended blocks drops."""
import re
from pathlib import Path

p = Path("files/msgdata/msg/msg_0197.gmm")
t = p.read_text()
t2 = re.sub(r"(</language>\n)(\t<row )", r"\1\t</row>\n\2", t)
t2 = re.sub(r"(</language>\n)(</body>)", r"\1\t</row>\n\2", t2)
if t2 != t:
    p.write_text(t2)
    print("gmm: closed", t2.count("</row>") - t.count("</row>"), "rows")
ids = [int(n) for n in re.findall(r'id="msg_0197_(\d+)"', t2)]
assert ids == list(range(len(ids))), "rows out of order"
assert t2.count("<row ") == t2.count("</row>")
