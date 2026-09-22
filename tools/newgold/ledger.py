#!/usr/bin/env python3
"""Regenerate the ledger's counters, and the page, from the repository.

docs/newgold/LEDGER.md is the ledger. Everything else is made from it:

  the counters between its LEDGER:COUNTS markers are read out of the tree --
    what this repository defines against what the reference defines, so a bar
    cannot quietly say something the tree does not
  the same block is copied into README.md between the same markers
  docs/index.html is rendered from the whole file: the heading, the two blocks
    of bars, and the four tables, with the Markdown's three columns becoming
    the page's three -- name and detail, a bar, and a chip whose class the
    state picks

    ledger.py            rewrite the counters and render the page
    ledger.py --check    say what is out of date, and change nothing

  the summary between its LEDGER:SUMMARY markers is counted from the states in
    the tables, because the only judgement there is which state a row carries

Edit the Markdown; everything else comes from it. Keep them apart and within a
day the wrong one is the prettier -- which is what happened to the page, and
then to the summary that was the last thing left by hand.

Usage: ledger.py [--check] [--reference PATH]
"""
import argparse
import re
import struct
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PAGE = ROOT / "docs/index.html"
LEDGER = ROOT / "docs/newgold/LEDGER.md"
REFERENCE = Path("/home/paolo/Porting HGSS/hg-engine-newgold-reference")
FILES = [LEDGER, ROOT / "README.md"]
START, END = "<!-- LEDGER:COUNTS:START -->", "<!-- LEDGER:COUNTS:END -->"
SUMMARY_START = "<!-- LEDGER:SUMMARY:START -->"
SUMMARY_END = "<!-- LEDGER:SUMMARY:END -->"

WIDTH = 50
FULL, EMPTY = "█", "░"


def highest(path, prefix):
    """The largest number a header gives a constant with this prefix.

    Mostly these are plain decimals. One is not: the reference writes its own
    added move as `#define MOVE_SOLAR_SEEDS (NUM_OF_CANONICAL_MOVES)`, and
    that is a real move with a real number, so a name standing for another
    constant in the same header is followed one step. Anything with
    arithmetic in it -- the reference's commented-out custom slots, its G-Max
    moves at `NUM_OF_MOVES - 1 + 1` -- is not a ceiling and is left alone.
    """
    text = Path(path).read_text(errors="replace")
    defines = dict(re.findall(r"^#define\s+([A-Z][A-Z0-9_]*)\s+(.+?)\s*$", text, re.M))
    numbers = []
    for name, value in defines.items():
        if not name.startswith(prefix):
            continue
        plain = re.fullmatch(r"\(?\s*(\d+)\s*\)?", value)
        if plain:
            numbers.append(int(plain.group(1)))
            continue
        indirect = re.fullmatch(r"\(?\s*([A-Z][A-Z0-9_]*)\s*\)?", value)
        if indirect and indirect.group(1) in defines:
            step = re.fullmatch(r"\(?\s*(\d+)\s*\)?", defines[indirect.group(1)])
            if step:
                numbers.append(int(step.group(1)))
    if not numbers:
        raise SystemExit(f"{path} defines nothing starting with {prefix}")
    return max(numbers)



# ------------------------------------------------------------- the summary

# Where a row's state puts it. The judgement is which state a row carries;
# the arithmetic below is not a judgement and is not typed by hand.
BUCKETS = ["done, seen running", "done, never played", "partial",
           "still to do", "deferred / no scope"]
VERIFICATION = "Verification"


def ledger_rows():
    """Every table row in the ledger, as (section, item, detail, state)."""
    rows, section = [], None
    for line in LEDGER.read_text().splitlines():
        if line.startswith("## "):
            section = line[3:].strip()
        match = re.match(r"^\| (.+?) \| (.+?) \| (.+?) \|$", line)
        if match and match.group(1) not in ("Feature", "Item") \
                and not set(match.group(1)) <= set("-: "):
            rows.append((section, *match.groups()))
    return rows


def bucket_of(section, state):
    if state.startswith("\u2705"):
        return 0 if section == VERIFICATION else 1
    if state.startswith("\U0001f7e0"):
        return 2
    if state.startswith("\U0001f534"):
        return 3
    return 4


def score(rows):
    """Done counts one, partial a half, and a deferred row is not counted at
    all -- it is out of scope, not a failure."""
    done = sum(1 for r in rows if bucket_of(*r) in (0, 1))
    partial = sum(1 for r in rows if bucket_of(*r) == 2)
    todo = sum(1 for r in rows if bucket_of(*r) == 3)
    within = done + partial + todo
    return round(100 * (done + partial / 2) / within) if within else 0


def summary():
    rows = [(section, state) for section, _, _, state in ledger_rows()]
    counts = [sum(1 for r in rows if bucket_of(*r) == i) for i in range(len(BUCKETS))]
    total = sum(counts) or 1
    shares = [round(100 * n / total) for n in counts]

    overall = score(rows)
    built = score([r for r in rows if r[0] != VERIFICATION])
    # Of the rows that are done, the share that has been seen running. A row
    # that is only partly there cannot have been played, so it is not in the
    # denominator.
    seen = counts[0] + counts[1]
    played = round(100 * counts[0] / seen) if seen else 0

    width = max(len(label) for label in BUCKETS) + 2
    lines = [f"{'Overall':<{width + 2}}{' ' * WIDTH} {overall:>3}%"]
    for label, share in zip(BUCKETS, shares):
        lines.append(f"  {label:<{width}}{bar(share, 100)} {share:>3}%")
    lines.append("")
    lines.append(f"{'Implementation':<{width + 2}}{bar(built, 100)} {built:>3}%")
    lines.append(f"{'Verified in play':<{width + 2}}{bar(played, 100)} {played:>3}%")
    lines.append("")
    lines.append("Overall and Implementation: done 1, partial a half, deferred rows")
    lines.append("out of the denominator. Verified in play: of the rows that are done,")
    lines.append("the share seen running. All three from the states in the tables.")
    return "```\n" + "\n".join(lines) + "\n```"


def bar(have, want):
    if want <= 0:
        return FULL * WIDTH
    filled = min(WIDTH, max(0, round(WIDTH * have / want)))
    return FULL * filled + EMPTY * (WIDTH - filled)


def rom_figures():
    """What the built card uses, from its own header, and how big it is.

    The header keeps the used size at 0x80; the rest of the card is the room
    the expansion to 2G bought.
    """
    rom = ROOT / "build/heartgold.us/pokeheartgold.us.nds"
    if not rom.exists():
        return None
    used = struct.unpack_from("<I", rom.read_bytes()[:0x100], 0x80)[0]
    return used, rom.stat().st_size


def trainer_count():
    import json
    data = json.loads((ROOT / "files/poketool/trainer/trainers.json").read_text())
    return len(data["trainers"])


def reference_trainer_count(reference):
    """The reference declares its trainers one numbered block each.

    They are `[1] = { .name = ... }` at the top level of Trainers.c, so the
    count is the highest index it gives plus the zeroth.
    """
    source = (reference / "data/Trainers.c").read_text(errors="replace")
    indices = [int(n) for n in re.findall(r"^\s{0,4}\[(\d+)\]\s*=\s*\{", source, re.M)]
    if not indices:
        raise SystemExit("the reference's Trainers.c declares no trainers")
    return max(indices) + 1


def counts(reference):
    rows = []

    def pair(label, have, want):
        rows.append(f"{label:<11} {bar(have, want)} {have:>5} / {want:>4}")

    pair("Species", highest(ROOT / "include/constants/species.h", "SPECIES_"),
         highest(reference / "include/constants/species.h", "SPECIES_"))
    pair("Moves", highest(ROOT / "include/constants/moves.h", "MOVE_"),
         highest(reference / "include/constants/moves.h", "MOVE_"))
    pair("Abilities", highest(ROOT / "include/constants/abilities.h", "ABILITY_"),
         highest(reference / "include/constants/ability.h", "ABILITY_"))
    pair("Items", highest(ROOT / "include/constants/items.h", "ITEM_"),
         highest(reference / "include/constants/item.h", "ITEM_"))
    pair("Trainers", trainer_count(), reference_trainer_count(reference))

    tests = len(list((ROOT / "tests/newgold").glob("test_*.py")))
    rows.append(f"{'Tests':<11} {tests} files")

    figures = rom_figures()
    if figures:
        used, total = figures
        rows.append(f"{'ROM':<11} {used / 1e6:.1f} MB of {total / 1e6:.1f} MB"
                    f"   (2G card, {round(100 * used / total)}% used)")
    else:
        rows.append(f"{'ROM':<11} not built")
    return "```\n" + "\n".join(rows) + "\n```"


# ---------------------------------------------------------------- the page

# The page's own stylesheet, kept as it was written: two themes in tokens, IBM
# Plex, a row that is a name, a bar and a chip. Nothing here invents styling.
STYLE = """<style>
  :root{
    --ground:#faf8f4; --surface:#ffffff; --sunk:#f3efe6;
    --ink:#1a1813; --ink-2:#4a4436; --muted:#7d7566; --rule:#e4ded0; --rule-2:#d2cab8;
    --accent:#8f6b14; --accent-soft:#f0e5c8;
    --done:#4a7343; --done-soft:#e0ead9;
    --part:#a96a22; --part-soft:#f6e6d2;
    --gap:#93433a; --gap-soft:#f4dfdb;
    --f-disp:"IBM Plex Sans Condensed",-apple-system,"Segoe UI",sans-serif;
    --f-body:"IBM Plex Sans",-apple-system,"Segoe UI",sans-serif;
    --f-mono:"IBM Plex Mono",ui-monospace,"SF Mono",Menlo,monospace;
  }
  @media (prefers-color-scheme:dark){
    :root:not([data-theme="light"]){
      --ground:#15130e; --surface:#1d1a14; --sunk:#221e17;
      --ink:#f2eee3; --ink-2:#c9c2b0; --muted:#948c7b; 
      --rule:#2e291f; --rule-2:#3d372a;
      --accent:#d6a63c; --accent-soft:#3a3020;
      --done:#7fae74; --done-soft:#26301f;
      --part:#d69a53; --part-soft:#332618;
      --gap:#cf7a6d; --gap-soft:#32211d;
    }
  }
  :root[data-theme="dark"]{
    --ground:#15130e; --surface:#1d1a14; --sunk:#221e17;
    --ink:#f2eee3; --ink-2:#c9c2b0; --muted:#948c7b; --rule:#2e291f; --rule-2:#3d372a;
    --accent:#d6a63c; --accent-soft:#3a3020;
    --done:#7fae74; --done-soft:#26301f;
    --part:#d69a53; --part-soft:#332618;
    --gap:#cf7a6d; --gap-soft:#32211d;
  }
  *{box-sizing:border-box}
  body{background:var(--ground);color:var(--ink);font-family:var(--f-body);
       font-size:15px;line-height:1.55;-webkit-font-smoothing:antialiased}
  .wrap{max-width:1000px;margin:0 auto;padding:40px 28px 80px}

  header{border-bottom:2px solid var(--ink);padding-bottom:18px;margin-bottom:34px}
  h1{font-family:var(--f-disp);font-weight:700;font-size:38px;line-height:1.05;
     letter-spacing:-.01em;margin:0 0 10px;text-wrap:balance}
  .sub{color:var(--muted);font-size:14px;max-width:62ch;margin:0}
  .pins{display:flex;flex-wrap:wrap;gap:6px 22px;margin-top:14px;
        font-family:var(--f-mono);font-size:11.5px;color:var(--ink-2)}
  .pins b{color:var(--muted);font-weight:500}

  .total{background:var(--surface);border:1px solid var(--rule);padding:22px 24px;margin-bottom:12px}
  .total-top{display:flex;justify-content:space-between;align-items:baseline;
             gap:16px;flex-wrap:wrap;margin-bottom:14px}
  .total-top h2{font-family:var(--f-disp);font-size:13px;font-weight:600;margin:0;
                text-transform:uppercase;letter-spacing:.1em;color:var(--muted)}
  .big{font-family:var(--f-mono);font-size:44px;font-weight:600;line-height:1;
       letter-spacing:-.02em;font-variant-numeric:tabular-nums}
  .stack{height:26px;display:flex;background:var(--sunk);
         border:1px solid var(--rule-2);overflow:hidden}
  .stack span{display:block}
  .legend{display:flex;flex-wrap:wrap;gap:6px 20px;margin-top:12px;
          font-size:12.5px;color:var(--ink-2)}
  .legend i{display:inline-block;width:10px;height:10px;margin-right:6px;
            vertical-align:-1px;font-style:normal}
  .legend b{font-family:var(--f-mono);font-variant-numeric:tabular-nums;font-weight:600}

  .split{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
         gap:12px;margin-bottom:40px}
  .half{background:var(--surface);border:1px solid var(--rule);padding:18px 20px}
  .half h3{font-family:var(--f-disp);font-size:12px;font-weight:600;margin:0 0 6px;
           text-transform:uppercase;letter-spacing:.09em;color:var(--muted)}
  .half .n{font-family:var(--f-mono);font-size:30px;font-weight:600;line-height:1;
           font-variant-numeric:tabular-nums}
  .half p{margin:8px 0 0;font-size:13px;color:var(--ink-2);line-height:1.45}

  section{margin-bottom:38px}
  .shead{display:flex;align-items:baseline;gap:14px;
         border-bottom:1px solid var(--ink);padding-bottom:7px;margin-bottom:2px}
  .shead h2{font-family:var(--f-disp);font-size:21px;font-weight:700;margin:0;
            letter-spacing:-.005em}
  .shead .cnt{font-family:var(--f-mono);font-size:12px;color:var(--muted);
              margin-left:auto;font-variant-numeric:tabular-nums;white-space:nowrap}

  .rows{display:flex;flex-direction:column}
  .row{display:grid;grid-template-columns:minmax(0,1fr) 88px 96px;gap:16px;
       align-items:center;padding:11px 0;border-bottom:1px solid var(--rule)}
  .row .name{font-weight:500;font-size:14.5px;margin:0 0 2px}
  .row .det{margin:0;font-size:12.5px;color:var(--muted);line-height:1.4}
  .row code{font-family:var(--f-mono);font-size:11.5px;color:var(--ink-2);
            background:var(--sunk);padding:1px 4px;border-radius:2px}
  .bar{height:7px;background:var(--sunk);border:1px solid var(--rule-2);overflow:hidden}
  .bar span{display:block;height:100%}
  .chip{font-family:var(--f-mono);font-size:10.5px;font-weight:600;
        text-transform:uppercase;letter-spacing:.06em;padding:3px 7px;
        text-align:center;white-space:nowrap}
  .c-done{background:var(--done-soft);color:var(--done)}
  .c-part{background:var(--part-soft);color:var(--part)}
  .c-gap{background:var(--gap-soft);color:var(--gap)}
  .c-defer{background:var(--sunk);color:var(--muted)}
  .b-done{background:var(--done)} .b-part{background:var(--part)}
  .b-gap{background:var(--gap)} .b-defer{background:var(--rule-2)}

  .note{background:var(--sunk);border-left:3px solid var(--accent);
        padding:14px 18px;font-size:13.5px;color:var(--ink-2);line-height:1.5}
  .note strong{color:var(--ink)}
  footer{margin-top:46px;padding-top:18px;border-top:1px solid var(--rule);
         font-size:12.5px;color:var(--muted);line-height:1.6}
  @media (max-width:620px){
    .row{grid-template-columns:minmax(0,1fr) 78px;row-gap:8px}
    .row .chip{grid-column:2}
    .row .bar{grid-column:1/-1;order:3}
    h1{font-size:30px}
  }
</style>"""

# What a state means for the chip beside a row and for the bar in front of it.
# A state that carries a fraction -- "🟠 1041 / 1075" -- takes its width from
# the fraction instead.
STATES = [
    ("\u2705", "done", "c-done", "b-done", 100),
    ("\U0001f7e0", "partial", "c-part", "b-part", 55),
    ("\U0001f534", "open", "c-gap", "b-gap", 25),
    ("\u2b1c", "deferred", "c-defer", "b-defer", 0),
]
NEVER = {"never", "to do"}


def escape(text):
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


def inline(text):
    """The little Markdown a ledger cell uses: code spans and bold."""
    out = escape(text)
    out = re.sub(r"`([^`]+)`", r"<code>\1</code>", out)
    out = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", out)
    out = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"<em>\1</em>", out)
    return out


def state_of(cell):
    """The chip label, its class, the bar's class and how wide the bar is."""
    for mark, default, chip, fill, width in STATES:
        if not cell.startswith(mark):
            continue
        rest = cell[len(mark):].strip()
        fraction = re.fullmatch(r"(\d+)\s*/\s*(\d+)", rest)
        if fraction:
            have, want = int(fraction.group(1)), int(fraction.group(2))
            return rest, chip, fill, min(100, round(100 * have / max(want, 1)))
        label = rest or default
        if label in NEVER:
            width = 0
        return label, chip, fill, width
    return escape(cell), "c-defer", "b-defer", 0


def read_ledger():
    """Pull the page's content out of the Markdown, in the order it is in."""
    text = LEDGER.read_text()
    page = {"pins": [], "sections": [], "note": "", "footer": []}

    page["title"] = re.search(r"^# (.+)$", text, re.M).group(1)
    intro = text.split("\n\n")[1].replace("\n", " ").strip()
    page["intro"] = intro

    pins = re.search(r"^\| \| \|\n\|[^\n]*\n((?:\|.*\n)+)", text, re.M)
    if pins:
        for line in pins.group(1).strip().splitlines():
            cells = [c.strip() for c in line.strip("|").split("|")]
            if len(cells) == 2:
                page["pins"].append((cells[0], cells[1]))

    for name, key in (("SUMMARY", "summary"), ("COUNTS", "counts")):
        block = re.search(r"<!-- LEDGER:" + name + r":START -->\n```\n(.*?)\n```",
                          text, re.S)
        page[key] = block.group(1).splitlines() if block else []

    for chunk in re.split(r"^## ", text, flags=re.M)[1:]:
        heading, _, body = chunk.partition("\n")
        rows = []
        for line in body.splitlines():
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            if len(cells) != 3 or set(cells[0]) <= set("-: ") or cells[2] in ("State", ":--"):
                continue
            rows.append(cells)
        # The paragraph under the heading, if there is one: the first block
        # that is prose rather than the table itself.
        # The paragraph under the heading, if there is one: the first block
        # that is prose rather than the table itself. Only its first sentence
        # -- the page puts it on one line beside the heading.
        blurb = next((" ".join(block.split()) for block in body.split("\n\n")
                      if block.strip() and not block.lstrip().startswith("|")), "")
        blurb = blurb.split(". ")[0].rstrip(".")
        if rows:
            page["sections"].append({"heading": heading.strip(), "blurb": blurb, "rows": rows})
        elif heading.strip().startswith("Why"):
            paragraphs = [p for p in body.split("\n\n") if p.strip()]
            page["note"] = (f"<strong>{escape(heading.strip())}.</strong> "
                            + " ".join(inline(" ".join(p.split())) for p in paragraphs))
        else:
            page["footer"].append(inline(" ".join(body.split())))
    return page


def summary_html(lines):
    """The overall bar, its legend, and the two halves under it."""
    buckets, halves, overall, rule = [], [], "\u2014", []
    for line in lines:
        if line and "%" not in line:
            rule.append(line.strip())
            continue
        match = re.match(r"^(\S.*?)\s{2,}[\u2588\u2591]*\s*(\d+)%$", line)
        if match and not line.startswith("  "):
            if match.group(1).strip() == "Overall":
                overall = match.group(2)
            else:
                halves.append((match.group(1).strip(), match.group(2)))
            continue
        match = re.match(r"^\s+(.+?)\s{2,}[\u2588\u2591]+\s+(\d+)%$", line)
        if match:
            buckets.append((match.group(1).strip(), match.group(2)))
    colours = ["var(--done)", "var(--part)", "var(--accent)", "var(--gap)", "var(--rule-2)"]
    last = len(colours) - 1
    stack = "".join(f'<span style="width:{value}%;background:{colours[min(i, last)]}"></span>'
                    for i, (_, value) in enumerate(buckets))
    legend = "".join(f'<span><i style="background:{colours[min(i, last)]}"></i>'
                     f'{escape(label)} <b>{value}%</b></span>'
                     for i, (label, value) in enumerate(buckets))
    tone = ["var(--done)", "var(--gap)"]
    split = "".join(
        f'<div class="half"><h3>{escape(label)}</h3>'
        f'<div class="n" style="color:{tone[min(i, 1)]}">{value}%</div></div>'
        for i, (label, value) in enumerate(halves))
    caption = (f'<p style="margin:10px 0 0;font-size:12.5px;color:var(--muted)">'
               f'{escape(" ".join(rule))}</p>') if rule else ""
    return f"""<div class="total">
  <div class="total-top">
    <h2>Overall</h2>
    <div class="big">{overall}<span style="font-size:24px;color:var(--muted)">%</span></div>
  </div>
  <div class="stack">{stack}</div>
  <div class="legend">{legend}</div>
</div>

<div class="split">{split}</div>
{caption}"""


def counts_html(lines):
    """The derived counters, as the same rows the tables use."""
    rows = []
    for line in lines:
        match = re.match(r"^(\S+)\s+[\u2588\u2591]+\s+(\d+)\s*/\s*(\d+)\s*$", line)
        if match:
            label, have, want = match.group(1), int(match.group(2)), int(match.group(3))
            width = min(100, round(100 * have / max(want, 1)))
            fill = "b-done" if have >= want else "b-part"
            chip = "c-done" if have >= want else "c-part"
            rows.append(f'<div class="row"><div><p class="name">{escape(label)}</p></div>'
                        f'<div class="bar"><span class="{fill}" style="width:{width}%"></span></div>'
                        f'<div class="chip {chip}">{have} / {want}</div></div>')
        else:
            label, _, rest = line.partition(" ")
            rows.append(f'<div class="row"><div><p class="name">{escape(label)}</p>'
                        f'<p class="det">{escape(rest.strip())}</p></div>'
                        f'<div class="bar"><span class="b-defer" style="width:0%"></span></div>'
                        f'<div class="chip c-defer">counted</div></div>')
    return ('<section>\n  <div class="shead">\n    <h2>Counted from the tree</h2>\n'
            '    <span class="cnt">regenerated by tools/newgold/ledger.py</span>\n'
            '  </div>\n  <div class="rows">\n' + "\n".join(rows) + "\n  </div>\n</section>")


def section_html(section):
    rows = []
    for name, detail, state in section["rows"]:
        label, chip, fill, width = state_of(state)
        rows.append(f'<div class="row"><div><p class="name">{inline(name)}</p>'
                    f'<p class="det">{inline(detail)}</p></div>'
                    f'<div class="bar"><span class="{fill}" style="width:{width}%"></span></div>'
                    f'<div class="chip {chip}">{escape(label)}</div></div>')
    blurb = f'<span class="cnt">{inline(section["blurb"])}</span>' if section["blurb"] else ""
    return ('<section>\n  <div class="shead">\n'
            f'    <h2>{inline(section["heading"])}</h2>\n    {blurb}\n'
            '  </div>\n  <div class="rows">\n' + "\n".join(rows) + "\n  </div>\n</section>")


def render_page():
    page = read_ledger()
    pins = "".join(f"<span><b>{inline(key)}</b> {inline(value)}</span>"
                   for key, value in page["pins"])
    body = "\n\n".join([summary_html(page["summary"]), counts_html(page["counts"])]
                        + [section_html(s) for s in page["sections"]])
    note = f'<div class="note">{page["note"]}</div>' if page["note"] else ""
    footer = "<br>\n  ".join(page["footer"])
    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="{escape(page["intro"])[:180]}">
<title>{escape(page["title"])}</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600&amp;family=IBM+Plex+Sans+Condensed:wght@500;600;700&amp;family=IBM+Plex+Sans:wght@400;500;600&amp;display=swap">
{STYLE}
</head>
<body>
<!-- Made by tools/newgold/ledger.py from docs/newgold/LEDGER.md. Edit that. -->
<div class="wrap">

<header>
  <h1>{escape(page["title"])}</h1>
  <p class="sub">{inline(page["intro"])}</p>
  <div class="pins">{pins}</div>
</header>

{body}

{note}

<footer>
  {footer}
</footer>

</div>

</body>
</html>
"""


def replace_between(path, block, start, end):
    text = path.read_text()
    if start not in text or end not in text:
        raise SystemExit(f"{path} has no {start} ... {end} markers")
    before, rest = text.split(start, 1)
    _, after = rest.split(end, 1)
    return before + start + "\n" + block + "\n" + end + after


def replace(path, block):
    text = path.read_text()
    if START not in text or END not in text:
        raise SystemExit(f"{path} has no {START} ... {END} markers")
    before, rest = text.split(START, 1)
    _, after = rest.split(END, 1)
    return before + START + "\n" + block + "\n" + END + after


def pins():
    """The two rows of the top table that are facts about the repository.

    `base` and `reference` are pins -- a person chooses those. The other two
    were being typed, and by the time anyone read them they were a dozen
    commits out. They are git's to answer.
    """
    def git(*args):
        return subprocess.run(["git", "-C", str(ROOT), *args],
                              capture_output=True, text=True).stdout.strip()
    # The port's own commits, not the decompilation's five thousand: count
    # from the base this table already pins.
    base = re.search(r"^\| base \| `([0-9a-f]+)`", LEDGER.read_text(), re.M).group(1)
    count = git("rev-list", "--count", f"{base}..HEAD")
    when = git("log", "-1", "--date=format:%Y-%m-%d %H:%M", "--format=%cd")
    return {"port": f"{count} commits", "generated": when}


def rewrite_pins(text):
    for key, value in pins().items():
        text = re.sub(rf"^\| {key} \| .*? \|$", f"| {key} | {value} |", text, flags=re.M)
    return text


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true",
                        help="say whether the blocks are current; write nothing")
    parser.add_argument("--reference", type=Path, default=REFERENCE)
    args = parser.parse_args()

    block = counts(args.reference)
    stale = []
    for path in FILES:
        updated = replace_between(path, block, START, END)
        if updated != path.read_text():
            stale.append(path)
            if not args.check:
                path.write_text(updated)

    # The summary comes from the states in the tables, after the counters are
    # in: the judgement is which state a row carries, and nothing past that.
    # The two git-answered pins go in with it. They are deliberately outside
    # --check: they move with every commit, and a check that fails because
    # time passed teaches nothing.
    if not args.check:
        LEDGER.write_text(rewrite_pins(LEDGER.read_text()))
        LEDGER.write_text(replace_between(LEDGER, summary(), SUMMARY_START, SUMMARY_END))
    digest = summary()
    for path in FILES:
        updated = replace_between(path, digest, SUMMARY_START, SUMMARY_END)
        if updated != path.read_text():
            if path not in stale:
                stale.append(path)
            if not args.check:
                path.write_text(updated)

    # The page comes last: it is rendered from the Markdown as the counters
    # have just left it, so the two cannot disagree.
    page = render_page()
    if not PAGE.exists() or PAGE.read_text() != page:
        stale.append(PAGE)
        if not args.check:
            PAGE.write_text(page)

    for path in stale:
        print(f"{'out of date:' if args.check else 'rewrote'} {path.relative_to(ROOT)}")
    if not stale:
        print("already current")
    print(block)
    return 1 if (args.check and stale) else 0


if __name__ == "__main__":
    sys.exit(main())
