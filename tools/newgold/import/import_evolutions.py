#!/usr/bin/env python3
"""Add the new species' evolutions to files/poketool/personal/evo.json.

Only evolutions this repository can already express are written: an evolution
needing a method, item or move HGSS does not have yet is reported and left out,
so nothing silently evolves into the wrong thing.

Usage: import_evolutions.py REFERENCE_CHECKOUT [--write] [--levels-only | --engine-reworks]

--engine-reworks writes the other kind: what hg-engine itself changed about a
species HeartGold already had -- a Linking Cord in place of a trade, a stone
in place of a place Johto does not have. Those rows are the engine's, so they
are read at the engine's revision, ENGINE_REVISION, and a species konefr's
range touches is left to the rows that are his.
"""

import argparse
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
EVOLUTIONS = ROOT / "files/poketool/personal/evo.json"
MAX_EVOS = int(re.search(r"#define MAX_EVOS_PER_POKE (\d+)", (ROOT / "include/pokemon_types_def.h").read_text()).group(1))

import import_species  # noqa: E402


def constants(path, prefix):
    return set(re.findall(r"\b(" + prefix + r"[A-Z0-9_]+)", (ROOT / path).read_text()))


# hg-engine as it was before konefr's first commit: the parent of his range.
ENGINE_REVISION = "d0380a487"


def reference_table(reference, revision=None):
    if revision is None:
        source = (reference / "data/Evolutions.c").read_text(errors="replace")
    else:
        source = subprocess.run(["git", "-C", str(reference), "show", f"{revision}:data/Evolutions.c"],
                                capture_output=True, text=True, check=True).stdout
    blocks = re.split(r"\n    \[(SPECIES_[A-Z0-9_]+)\] = \{", source)
    return {blocks[i]: blocks[i + 1] for i in range(1, len(blocks), 2)}


# A row is a method, a bare parameter and a target; the target may be a form of
# another species, MON_WITH_FORM(SPECIES_SLOWBRO, 2). The older pattern matched
# only a plain SPECIES_, so the 36 form lines were not left out but unseen --
# they never reached the report at all.
ROW = re.compile(r"\{\s*(EVO_[A-Z0-9_]+)\s*,\s*([A-Za-z0-9_-]+)\s*,\s*"
                 r"(SPECIES_[A-Z0-9_]+|MON_WITH_FORM\(\s*SPECIES_[A-Z0-9_]+\s*,\s*\d+\s*\))\s*\}")

# This repository's evolution data has no form field, so a form can only be an
# evolution target where the port carries it as a species of its own.
FORM_TARGETS = {
    ("SPECIES_SLOWBRO", "2"): "SPECIES_SLOWBRO_GALARIAN",
}


# Where the engine's table is not the games' and the port writes the games'
# row instead (Paolo, 2026-09-23: a defect of the reference is fixed to the
# canonical behaviour, never copied). hg-engine's Evolutions.c at d0380a487
# evolves Spritzee and Swirlix by any trade; in the games they evolve traded
# while holding a Sachet or a Whipped Dream, which is what the two items'
# own hold effects, HOLD_EFFECT_EVOLVE_SPRITZEE and _SWIRLIX, stand for.
# Keyed by the engine's row as ROW reads it; the value is the row written.
CANONICAL_ROWS = {
    ("SPECIES_SPRITZEE", "EVO_TRADE", "0", "SPECIES_AROMATISSE"): ("EVO_TRADE_ITEM", "ITEM_SACHET", "SPECIES_AROMATISSE"),
    ("SPECIES_SWIRLIX", "EVO_TRADE", "0", "SPECIES_SLURPUFF"): ("EVO_TRADE_ITEM", "ITEM_WHIPPED_DREAM", "SPECIES_SLURPUFF"),
    # Not a defect but a spelling: the engine writes Pancham's level, 32, as
    # SPECIES_NIDORAN_M, which is 32 in both trees. The level is written as
    # the level.
    ("SPECIES_PANCHAM", "EVO_LEVEL_DARK_TYPE_MON_IN_PARTY", "SPECIES_NIDORAN_M", "SPECIES_PANGORO"): ("EVO_LEVEL_DARK_TYPE_MON_IN_PARTY", "32", "SPECIES_PANGORO"),
}


# Paolo's own designs (2026-09-23), beyond the reference and konefr's: rows a
# species is given that neither tree gives it, after the reference's own.
DESIGNED_ROWS = {
    # Kingambit, levelling up knowing Swords Dance. The engine's row beside
    # it, three Bisharp holding a Leader's Crest defeated, stays; no Bisharp
    # in the game holds one.
    "SPECIES_BISHARP": [("EVO_HAS_MOVE", "MOVE_SWORDS_DANCE", "SPECIES_KINGAMBIT")],
    # Gholdengo, levelling up knowing Pay Day, which both forms learn at 55
    # (wotbl.py's DESIGNED_MOVES). The engine's 999 Gimmighoul Coins stay
    # the Chest Form's other way; no coin is placed anywhere.
    "SPECIES_GIMMIGHOUL": [("EVO_HAS_MOVE", "MOVE_PAY_DAY", "SPECIES_GHOLDENGO")],
    "SPECIES_GIMMIGHOUL_ROAMING": [("EVO_HAS_MOVE", "MOVE_PAY_DAY", "SPECIES_GHOLDENGO")],
    # Alcremie, levelling up anywhere in the Ice Path holding a Berry, which
    # picks the Sweet and is used up; no other way. They take the place of
    # the reference's nine EVO_SPIN_* rows, a method its engine never checks,
    # aimed at forms 1..8 of Alcremie, of which 7 is Gigantamax and 8 is not
    # there.
    "SPECIES_MILCERY": [
        ("EVO_ITEM_ICE_PATH", "ITEM_CHERI_BERRY", "SPECIES_ALCREMIE"),  # the Strawberry Sweet
        ("EVO_ITEM_ICE_PATH", "ITEM_ORAN_BERRY", "SPECIES_ALCREMIE_BERRY_SWEET"),
        ("EVO_ITEM_ICE_PATH", "ITEM_PECHA_BERRY", "SPECIES_ALCREMIE_LOVE_SWEET"),
        ("EVO_ITEM_ICE_PATH", "ITEM_SITRUS_BERRY", "SPECIES_ALCREMIE_STAR_SWEET"),
        ("EVO_ITEM_ICE_PATH", "ITEM_LUM_BERRY", "SPECIES_ALCREMIE_CLOVER_SWEET"),
        ("EVO_ITEM_ICE_PATH", "ITEM_ASPEAR_BERRY", "SPECIES_ALCREMIE_FLOWER_SWEET"),
        ("EVO_ITEM_ICE_PATH", "ITEM_NANAB_BERRY", "SPECIES_ALCREMIE_RIBBON_SWEET"),
    ],
}


FORMS_OF = {}


def form_table(reference):
    """The reference's PokeFormDataTbl: each base species' forms, in order,
    so that form n of a species is the n-th name listed for it."""
    source = (reference / "data/PokeFormDataTbl.c").read_text(errors="replace")
    table = {}
    for m in re.finditer(r"\[SPECIES_([A-Z0-9_]+)\] = \{(.*?)\}", source, re.S):
        table[m.group(1)] = re.findall(r"SPECIES_([A-Z0-9_]+)", m.group(2))
    return table


def carried_form(base, target):
    """A form keeps its form when it evolves: the reference writes the base
    target and carries the form number over, so an Antique Sinistea becomes
    an Antique Polteageist. Here a form is a species, so the target is the
    same-numbered form of the target species when it has one."""
    if not target.startswith("SPECIES_") or " form " in target:
        return target
    base, target = base[len("SPECIES_"):], target[len("SPECIES_"):]
    for species, forms in FORMS_OF.items():
        if base in forms:
            number = forms.index(base)
            if target in FORMS_OF and number < len(FORMS_OF[target]) and target not in forms:
                return "SPECIES_" + FORMS_OF[target][number]
            break
    return "SPECIES_" + target


def native_target(target):
    """The target under this repository's spelling, or a name nothing defines.

    A form is the n-th name the reference's form table lists for its base;
    one this port does not carry comes back as "SPECIES_URSHIFU form 1",
    which is in no header and so is reported as missing rather than written.
    """
    form = re.fullmatch(r"MON_WITH_FORM\(\s*SPECIES_([A-Z0-9_]+)\s*,\s*(\d+)\s*\)", target)
    if not form:
        return target
    base, number = form.group(1), int(form.group(2))
    listed = FORMS_OF.get(base, [])
    if 1 <= number <= len(listed):
        return "SPECIES_" + listed[number - 1]
    return FORM_TARGETS.get(("SPECIES_" + base, str(number)), f"SPECIES_{base} form {number}")


def relevelled(table, evolutions):
    """Rows this table and the reference share that differ only in a number.

    Of konefr's nine changes to species HeartGold already had, seven move a
    level number and two add an `EVO_HAS_MOVE` line; these are the seven. A row
    is matched by method and target, which is unique within a species, and only
    when both sides give a bare number -- the reference writes Kirlia's Dawn
    Stone as the literal 109 where this tree names the item, which is a
    spelling difference and not a change. Every other disagreement over a
    vanilla row is hg-engine's rework of the method itself (a Linking Cord for
    a trade, an Ice Stone for Glaceon) and is left alone here.
    """
    changes = []
    for entry in evolutions["evoTable"]:
        body = table.get(entry["baseSpecies"])
        if body is None:
            continue
        theirs = {(method, native_target(target)): param
                  for method, param, target in ROW.findall(body)}
        for evo in entry["evos"]:
            param = theirs.get((evo["method"], evo["target"]))
            if param is None or not param.lstrip("-").isdigit():
                continue
            if not str(evo["param"]).lstrip("-").isdigit() or int(param) == int(evo["param"]):
                continue
            changes.append((entry["baseSpecies"], evo["target"], evo, int(param)))
    return changes


def engine_reworks(reference, evolutions, known, spell):
    """hg-engine's rows for species HeartGold already had, where they differ
    from this table by more than spelling and konefr has not touched them.

    A row this table has and the engine has not is replaced in place by the
    engine's row for the same target when there is one -- Eevee's Eterna and
    Route 217 become the Leaf and Ice Stones where they stood, so Sylveon keeps
    her place ahead of Espeon -- and dropped otherwise; what is left of the
    engine's rows goes at the end. Rows by a method this game has not got are
    reported and left out, as everywhere else in this file."""
    engine = reference_table(reference, ENGINE_REVISION)
    theirs = reference_table(reference)
    numbers = {int(v): n for n, v in re.findall(r"#define (SPECIES_[A-Z0-9_]+)\s+(\d+)",
                                                  (ROOT / "include/constants/species.h").read_text())}
    retail = {name for number, name in numbers.items() if 0 < number <= 493}
    out = []
    for entry in evolutions["evoTable"]:
        base = entry["baseSpecies"]
        if base not in retail or base not in engine or theirs.get(base) != engine[base]:
            continue
        rows, missing = [], []
        for method, param, target in ROW.findall(engine[base]):
            if target == "SPECIES_NONE":
                continue  # the padding rows, EVO_NONE to nothing
            target = native_target(target)
            param = spell(method, param)
            absent = [name for name in [method, target] + ([] if isinstance(param, int) else [param])
                      if name not in known]
            (missing if absent else rows).append((method, param, target))
        mine = [(e["method"], e["param"], e["target"]) for e in entry["evos"]]
        extra = [row for row in rows if row not in mine]
        gone = [row for row in mine if row not in rows]
        if not extra and not gone:
            continue
        new = []
        for row in mine:
            if row in rows:
                new.append(row)
                continue
            swap = next((r for r in extra if r[2] == row[2]), None)
            if swap:
                extra.remove(swap)
                new.append(swap)
        new += extra
        out.append((base, [e for e in mine if e not in new], [e for e in new if e not in mine], missing,
                    [{"method": m, "param": p, "target": s} for m, p, s in new]))
    return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    # The 163 species that gain an evolution and the seven that move a level
    # are separate debts on separate ledger rows, so either can be written on
    # its own without dragging the other in.
    parser.add_argument("--levels-only", action="store_true")
    parser.add_argument("--engine-reworks", action="store_true")
    args = parser.parse_args()

    methods = constants("include/constants/pokemon.h", "EVO_")
    species = constants("include/constants/species.h", "SPECIES_")
    moves = constants("include/constants/moves.h", "MOVE_")
    items = constants("include/constants/items.h", "ITEM_")
    types = constants("include/constants/pokemon.h", "TYPE_")
    known = methods | species | moves | items | types
    squashed_items = {name.replace("_", ""): name for name in items}

    FORMS_OF.update(form_table(args.reference))
    table = reference_table(args.reference)
    evolutions = json.loads(EVOLUTIONS.read_text())
    for entry in evolutions["evoTable"]:
        for evo in entry["evos"]:
            # A level written as "16" renders the same as 16, and compares differently.
            if isinstance(evo["param"], str) and evo["param"].lstrip("-").isdigit():
                evo["param"] = int(evo["param"])
    already = {entry["baseSpecies"]: entry for entry in evolutions["evoTable"]}
    wanted = {"SPECIES_" + name for name in import_species.added_species()}

    added, merged, skipped = [], [], []
    for base, body in table.items():
        rows = [(method, param, carried_form(base, native_target(target))) for method, param, target in ROW.findall(body)]
        rows = [(method, param, target) for method, param, target in rows if target != "SPECIES_NONE"]
        rows = [CANONICAL_ROWS.get((base, *row), row) for row in rows]
        # A design stands in for the reference's rows by a method this game
        # has not got -- Milcery's spins -- so those are dropped, not reported.
        rows = [row for row in rows if base not in DESIGNED_ROWS or row[0] in methods] + DESIGNED_ROWS.get(base, [])
        # Only lines that touch a new species: either it evolves, or something
        # already here gains a way to become one.
        rows = [row for row in rows if base in wanted or row[2] in wanted]
        if not rows:
            continue

        if base not in known:
            # A form the reference splits out that this repository does not
            # define, such as Pumpkaboo's sizes.
            skipped.append((base, [("base species not defined", "", "", [base])]))
            continue

        usable, missing = [], []
        for method, param, target in rows:
            # The reference spells a few items with an underscore this game does
            # not: ITEM_THUNDER_STONE is ITEM_THUNDERSTONE here. Unmapped, it
            # dropped Eelektrik's, Charjabug's and Tadbulb's evolutions.
            param = squashed_items.get(param.replace("_", ""), param) if param.startswith("ITEM_") else param
            needed = [method, target] + ([param] if not param.lstrip("-").isdigit() else [])
            absent = [name for name in needed if name not in known]
            if absent:
                missing.append((method, param, target, absent))
                continue
            param = int(param) if param.lstrip("-").isdigit() else param
            usable.append({"method": method, "param": param, "target": target})

        if missing:
            skipped.append((base, missing))
        if not usable:
            continue
        if base in already:
            # A species this tree already evolves gets the rows it is missing,
            # up to the limit: Scyther keeps Scizor and gains Kleavor.
            entry = already[base]
            have = {(row["method"], str(row["param"]), row["target"]) for row in entry["evos"]}
            new = [row for row in usable if (row["method"], str(row["param"]), row["target"]) not in have]
            if new:
                if len(entry["evos"]) + len(new) > MAX_EVOS:
                    raise SystemExit(f"{base} would have {len(entry['evos']) + len(new)} evolutions; the limit is {MAX_EVOS}")
                merged.append((base, new))
            continue
        added.append({"baseSpecies": base, "evos": usable})

    changes = relevelled(table, evolutions)

    item_names = {int(v): n for n, v in re.findall(r"#define (ITEM_[A-Z0-9_]+)\s+(\d+)\b",
                                                   (ROOT / "include/constants/items.h").read_text())}

    def spell(method, param):
        """A parameter as this table writes it: a number stays a number, except
        an item the reference gives by its number (Kirlia's Dawn Stone is 109)."""
        if param.lstrip("-").isdigit():
            if method.startswith(("EVO_STONE", "EVO_TRADE_ITEM", "EVO_ITEM")) and int(param) in item_names:
                return item_names[int(param)]
            return int(param)
        return squashed_items.get(param.replace("_", ""), param) if param.startswith("ITEM_") else param

    reworks = engine_reworks(args.reference, evolutions, known, spell) if args.engine_reworks else []
    for base, gone, new, missing, _ in reworks:
        print(f"  {base} (engine): " + ", ".join([f"-{m} {p} {s}" for m, p, s in gone] + [f"+{m} {p} {s}" for m, p, s in new]))
        for method, param, target in missing:
            print(f"    left out {method} {param} {target}")

    print(f"{len(added)} species gain evolutions, {len(merged)} listed already gain a row")
    for base, rows in merged:
        for row in rows:
            print(f"  {base} also -> {row['target']} ({row['method']}, {row['param']})")
    for base, missing in skipped:
        for method, param, target, absent in missing:
            detail = ", ".join(absent) if absent else "the table already lists it"
            print(f"  left out {base} -> {target or '?'} ({method}): {detail}")
    print(f"{len(changes)} species evolve at a different level")
    for base, target, evo, param in changes:
        print(f"  {base} -> {target}: {evo['param']} becomes {param}")

    if not args.write:
        return
    if args.engine_reworks:
        for base, _, _, _, rows in reworks:
            if len(rows) > MAX_EVOS:
                raise SystemExit(f"{base} would have {len(rows)} evolutions; the limit is {MAX_EVOS}")
            already[base]["evos"] = rows
        EVOLUTIONS.write_text(json.dumps(evolutions, indent=2) + "\n")
        print(f"wrote {EVOLUTIONS.relative_to(ROOT)}: {len(reworks)} species take the engine's rows")
        return
    if not args.levels_only:
        evolutions["evoTable"].extend(added)
        for base, rows in merged:
            already[base]["evos"].extend(rows)
    for _, _, evo, param in changes:
        evo["param"] = param
    EVOLUTIONS.write_text(json.dumps(evolutions, indent=2) + "\n")
    print(f"wrote {EVOLUTIONS.relative_to(ROOT)} with {len(evolutions['evoTable'])} entries")


if __name__ == "__main__":
    main()
