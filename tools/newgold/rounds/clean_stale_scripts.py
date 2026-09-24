#!/usr/bin/env python3
"""Remove built script pieces (.bin, .o, .d) whose .s is gone, in the tree
this runs in: the archive rule packs every .bin in the folder, so a renamed
subscript's old .bin would ship."""
from pathlib import Path
n = 0
for folder in ("subscript", "effect_script", "move_script"):
    d = Path("files/battledata/script") / folder
    for built in list(d.glob("*.bin")) + list(d.glob("*.o")) + list(d.glob("*.d")):
        if not built.with_suffix(".s").exists():
            built.unlink()
            n += 1
print(n, "stale pieces removed")
