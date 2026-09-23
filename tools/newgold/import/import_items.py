#!/usr/bin/env python3
"""Bring the reference's items into this game, renumbered densely from here.

WHY THE NUMBERS ARE NOT THE REFERENCE'S

konefr numbers an added item wherever there was room: their Black Augurite is
1691. This tree numbered its own additions densely instead, and that Black
Augurite is 537. Adopting their numbering would renumber every item this game
already has, which is Paolo's save, his bag and every held item in the data --
so an imported item gets the next free id HERE, and the mapping from their name
to that id is written to tools/newgold/import/item_map.csv for the next script and for
anyone reading. Their id is never the answer.

WHICH ITEM IS WHICH

Both trees were dumped from the same ROM, so up to the Enigma Stone -- 536, the
last item HeartGold had -- an id means the same item in both, whatever either
tree spells it. That matters, because the spellings disagree 180 times in that
range: PARLYZ_HEAL against PARALYZE_HEAL, TM01 against TM002, UNUSED_114
against UNKNOWN_72. Matching those by name would import a second copy of every
one of them. Past 536 the two trees numbered their own additions from the same
place, so a number there means different things and only the name carries over.

ALIASES holds the handful of renames anyone would reach for by hand; it is
checked against the id pairing rather than trusted, so a drift fails loudly.

THE SAME STORY FOR HOLD EFFECTS

An item names a hold effect, and the two trees disagree about those names in
exactly the same shape: 0 to 146 came from the ROM and match by number (this
game's HOLD_EFFECT_FLINCH_CHANCE is the reference's SOMETIMES_FLINCH, both 56),
and from 147 both trees numbered their own additions, so there a name matches
and anything new is given the next free number here. Nothing reads the new ones
yet -- the items come first, the effects are someone else's pass.

WHAT COMES OUT OF WHERE

    include/constants/items.h              the constant, ITEMS_COUNT, hold effects
    files/itemtool/itemdata/item_data.csv  the record, from data/itemdata/itemdata.c
    files/itemtool/itemdata/item_data.mk   the icon build rule
    files/itemtool/itemdata/item_icon/     the PNG, from data/graphics/item
    files/msgdata/msg/msg_0221..0224.gmm   description, name, with-article, plural,
                                           from data/text at --revision
    src/item.c                             sItemNarcIds
    tools/newgold/import/item_map.csv             the mapping

An icon is resolved by ARCHIVE MEMBER, never by name: data/graphics/itemgra.mk
keys a PNG by the member, which is the item's id plus two, and 1634 of those
PNGs are byte-identical to none.png -- snowball_pla.png is not the Snowball's.
An item whose art is the blank one is given ITEM_NONE's icon here knowingly,
rather than 1610 more copies of the same empty square.

Every run rewrites its own generated blocks rather than appending to them, so
running it twice is running it once.

Usage: import_items.py REFERENCE_CHECKOUT [--write] [--limit N] [--revision REV] [--text-only]
Without --write it reports what it would change and touches nothing.
--text-only rewrites the four item banks from item_map.csv and nothing else.
"""

import argparse
import bisect
import csv
import hashlib
import re
import shutil
from pathlib import Path

import gmm

ROOT = Path(__file__).resolve().parents[3]
ITEMS_H = ROOT / "include/constants/items.h"
ITEM_CSV = ROOT / "files/itemtool/itemdata/item_data.csv"
ITEM_MK = ROOT / "files/itemtool/itemdata/item_data.mk"
ICON_DIR = ROOT / "files/itemtool/itemdata/item_icon"
ITEM_C = ROOT / "src/item.c"
ITEM_MAP = ROOT / "tools/newgold/import/item_map.csv"

# The last item HeartGold had. Up to here the two trees hold the same item at
# the same id, whatever either calls it.
SHARED_LAST = 536
SHARED_LAST_NAME = "ITEM_ENIGMA_STONE"

# The same for hold effects.
LAST_VANILLA_HOLD_EFFECT = 146

# A slot HeartGold left empty. Both trees kept the gaps the retail game had and
# both name them this way, so a gap pairs with a gap. konefr filled eight of
# theirs with real items -- the four Genesect Drives, the Tea, the Autograph,
# the Pokemon Box, the Sweet Heart -- and a real item facing a gap is not the
# same item under another spelling: the slot is free here and the item is
# imported like any other the reference has and this tree has not.
EMPTY_SLOT = re.compile(r"ITEM_(UNUSED|UNKNOWN)_[0-9A-F]+$")

# ITEM_NONE's own icon: the question mark this game already shows for a thing
# with no picture. Every imported item whose art is konefr's blank placeholder
# points at it.
BLANK_ICON = (793, 794)

# Spellings this tree writes differently from the reference. Every one of these
# is also derivable from the id pairing below -- they are written down because a
# person reaching for one by hand would look here, and checked against the
# pairing because a table that is only written down goes stale.
ALIASES = {
    "ITEM_PARALYZE_HEAL": "ITEM_PARLYZ_HEAL",
    "ITEM_THUNDER_STONE": "ITEM_THUNDERSTONE",
    "ITEM_NEVER_MELT_ICE": "ITEM_NEVERMELTICE",
    "ITEM_DEEP_SEA_SCALE": "ITEM_DEEPSEASCALE",
    "ITEM_DEEP_SEA_TOOTH": "ITEM_DEEPSEATOOTH",
    "ITEM_BRIGHT_POWDER": "ITEM_BRIGHTPOWDER",
    "ITEM_SILVER_POWDER": "ITEM_SILVERPOWDER",
    "ITEM_TWISTED_SPOON": "ITEM_TWISTEDSPOON",
    "ITEM_TINY_MUSHROOM": "ITEM_TINYMUSHROOM",
    "ITEM_ENERGY_POWDER": "ITEM_ENERGYPOWDER",
    "ITEM_UP_GRADE": "ITEM_UPGRADE",
    "ITEM_LEEK": "ITEM_STICK",
}

# Eviolite is in both trees under two names for the one effect, which a name
# match above 146 would otherwise import a second time. The reference's
# EVOLVE_FEEBAS is deliberately NOT here: this game's Prism Scale evolves
# through partyUse and has no hold effect, so that one really is new.
HOLD_EFFECT_ALIASES = {
    "HOLD_EFFECT_EVIOLITE": "HOLD_EFFECT_BOOST_IF_NOT_EVOLVED",
}

# hg-engine keeps an item's text by generation, not in the retail banks: its
# description, its name with an article and its plural are banks 830, 831 and
# 832 plus four for each generation after the fourth (833 and every fourth
# after it is a "give item" wording nothing reads), at the item's id less the
# first id of its generation -- ITEM_GENERATION and ITEM_MSG_OFFSET in its
# include/constants/item.h. Its 221, 223 and 224 are one row each, the text for
# an item past the Canari Bread, which no item is. Its names stay flat in 222.
# This game keeps one flat bank for each, indexed by its own id, so each row is
# filled from the engine's bank for the item's reference id.
GENERATION_ENDS = ("ITEM_ENIGMA_STONE", "ITEM_REVEAL_GLASS", "ITEM_EON_FLUTE",
                   "ITEM_UNKNOWN_1073", "ITEM_LEGEND_PLATE", "ITEM_CANARI_BREAD")

# What a previous run wrote, so a run reads what was here before it.
GENERATED = {
    ITEMS_H: (r"\n// The hold effects the reference brings with it.*?(?=\n#define ITEM_NONE 0)",
              r"\n// The rest of the reference's items.*?(?=\n#define ITEMS_COUNT)"),
    ITEM_C: (r"\n// The rest of the reference's items take no rows.*?\n\};\n",),
    ITEM_MK: (r"\n# The rest of the reference's item icons.*?(?=\n\$\(ITEMICON_NARC\))",),
}


def original(path):
    text = path.read_text()
    for pattern in GENERATED[path]:
        text = re.sub(pattern, "", text, flags=re.S)
    return text


def defines(text, prefix):
    """Every `#define NAME number` with the given prefix, trailing comment or not.

    The comment matters: the reference writes one on eighteen of its item ids,
    and every one of those is a note about how it differs from this game --
    "Replaced UNKNOWN_74", "Added a Zero to all TMS". Anchoring on the end of
    the line made those eighteen invisible, which quietly dropped the eight
    items konefr put in slots HeartGold never used.
    """
    return {name: int(value) for name, value
            in re.findall(r"^#define[ \t]+(" + prefix + r"[A-Z0-9_]+)[ \t]+(\d+)[ \t]*(?://.*)?$",
                          text, re.M)}


# Types by name, out of THIS tree's header. The reference still has TYPE_FAIRY
# at 9 beside TYPE_MYSTERY with a TODO beside it; this game moved it to 18. The
# name means the same thing in both trees, the number does not, so a type that
# reaches a record is resolved by name and a type this game has not got stops
# the run rather than landing on someone else's number.
TYPES = defines((ROOT / "include/constants/pokemon.h").read_text(), "TYPE_")

# naturalGiftType is five bits and every row already here writes all ones: this
# game does not give an item a Natural Gift type, it gives it a power of zero
# and the move fails. That is where a type this game has not got goes.
NO_NATURAL_GIFT = 31


def field_use_funcs():
    """How many entries sItemFieldUseFuncs has, read from the table itself.

    GetItemFieldUseFunc indexes it with the item's fieldUseFunc and checks
    nothing, so a record naming a routine this game has not got is a jump
    through whatever follows the table.
    """
    body = (ROOT / "src/field_use_item.c").read_text()
    body = body[body.index("sItemFieldUseFuncs[] = {"):]
    return body[:body.index("\n};")].count("\n    {")


# The reference's table is this game's thirty with six of konefr's after it --
# Reveal Glass, DNA Splicers, Ability Capsule, Mint, Nectar, Rotom Catalog --
# and none of those routines is here. Routine 0 is the one an item with no field
# use has: it sits in the bag and does nothing, rather than indexing past the end
# of the table.
GENERIC_FIELD_USE = 0

# Routine 1 opens the party menu on the item and lets the party menu decide what
# it does there. It is what every medicine uses, konefr's Ability Patch included.
PARTY_MENU_FIELD_USE = 1

# What each of konefr's six becomes here. The Reveal Glass and the Nectars keep
# their routines, which src/field_use_item.c has in the same places. The
# Ability Capsule and the twenty-one Mints need no form at all, and all their
# routine ever did was open the party menu on the item -- so they get routine
# 1, the same one konefr give the Ability Patch, and src/party_menu.c answers
# them the way it answers the Gracidea. The others are not ported yet and stay
# at routine 0.
FIELD_USE_ROUTINES = {
    30: 30,                    # Reveal Glass
    31: GENERIC_FIELD_USE,     # DNA Splicers -- needs somewhere to keep the Reshiram or Zekrom
    32: PARTY_MENU_FIELD_USE,  # Ability Capsule
    33: PARTY_MENU_FIELD_USE,  # Mint
    34: 34,                    # Nectar
    35: 35,                    # Rotom Catalog
}

FIELD_USE_FUNCS = field_use_funcs()


def item_block(text):
    """The item ids, without the hold effects above them or ITEM_VAR_ below."""
    return defines(text[text.index("#define ITEM_NONE 0"):text.index("#define ITEMS_COUNT")],
                   "ITEM_")


# --- the reference -------------------------------------------------------


class Reference:
    def __init__(self, path):
        self.path = path
        self.header = (path / "include/constants/item.h").read_text()
        self.ids = defines(self.header, "ITEM_")
        self.hold_effects = defines((path / "include/constants/hold_item_effects.h").read_text(),
                                    "HOLD_EFFECT_")
        self._effect_by_number = {number: name for name, number in self.hold_effects.items()}
        # item.h and hold_item_effects.h between them name every constant a
        # record reaches for -- including the aliases, SOUBI_NONE for
        # HOLD_EFFECT_NONE and TUIBAMU_NONE for no pluck effect.
        self.symbols = {}
        for header in ("include/constants/item.h", "include/constants/hold_item_effects.h"):
            self.symbols.update(re.findall(r"^#define[ \t]+([A-Z][A-Z0-9_]*)[ \t]+(\S[^\n]*?)[ \t]*$",
                                           (path / header).read_text(), re.M))
        for name, value in self._config().items():
            self.symbols.setdefault(name, value)
        self.records = self._records()
        self.names = (path / "data/text/222.txt").read_text(encoding="utf-8").split("\n")
        self.icons = self._icons()
        # Their type numbering, for the records that write a bare number where a
        # type belongs. It is not this game's: see natural_gift_type below.
        self._type_by_number = {}
        for name, number in defines((path / "include/constants/pokemon.h").read_text(),
                                    "TYPE_").items():
            self._type_by_number.setdefault(number, name)

    def _config(self):
        """config.h, skipping the branches a normal build does not take."""
        out, taken = {}, [True]
        for line in (self.path / "include/config.h").read_text().splitlines():
            line = line.strip()
            guard = re.match(r"#ifdef\s+(\w+)", line)
            if guard:
                taken.append(not guard.group(1).startswith("DEBUG_"))
            elif line.startswith("#ifndef") or line.startswith("#if "):
                taken.append(True)
            elif line.startswith("#else"):
                taken[-1] = not taken[-1]
            elif line.startswith("#endif"):
                if len(taken) > 1:
                    taken.pop()
            else:
                found = re.match(r"#define[ \t]+([A-Z][A-Z0-9_]*)[ \t]+(\S.*?)[ \t]*$", line)
                if found and all(taken):
                    out.setdefault(found.group(1), found.group(2))
        return out

    def _records(self):
        source = (self.path / "data/itemdata/itemdata.c").read_text(errors="replace")
        blocks = re.split(r"\n\[(ITEM_[A-Z0-9_]+)\] =\n\{", source)
        return {blocks[i]: blocks[i + 1] for i in range(1, len(blocks), 2)}

    def _icons(self):
        """Archive member -> the PNG built into it, and whether it is the blank.

        itemgra.mk is the only thing that says which PNG belongs to which item,
        and it says it by member number. Nothing else does: a third of that
        directory is copies of none.png under names that read like real items.
        """
        art = self.path / "data/graphics/item"
        digest = {png.stem: hashlib.md5(png.read_bytes()).digest() for png in art.glob("*.png")}
        blank = digest["none"]
        rules = re.findall(r"\$\(ITEMGFX_DIR\)/(\d+)-00\.NCGR:"
                           r"\$\(ITEMGFX_DEPENDENCIES_DIR\)/(\S+)\.png",
                           (self.path / "data/graphics/itemgra.mk").read_text())
        return {int(member): (art / f"{png}.png", digest[png] == blank) for member, png in rules}

    def natural_gift_type(self, token):
        """A record's natural gift type, in THIS game's numbering.

        The two trees number types differently and the reference writes this
        field both ways: 1132 records name a type, 1457 write a bare number.
        Their 18 is TYPE_TYPELESS and this game's 18 is Fairy, so carrying the
        number across would hand seven hundred imported items a Fairy Natural
        Gift. Resolved by name, written as this game's name the way the rows
        already here write it, and a type this game has not got -- TYPELESS,
        STELLAR -- lands on the field's own none.
        """
        token = token.strip()
        name = token if token.startswith("TYPE_") else self._type_by_number.get(self.number(token))
        return name if name in TYPES else str(NO_NATURAL_GIFT)

    def hold_effect(self, token):
        """The reference's own name for a hold effect it wrote as a bare 0."""
        token = token.strip()
        if token.startswith("HOLD_EFFECT_"):
            return token
        return self._effect_by_number[self.number(token)]

    def number(self, token, depth=0):
        """A field's value as a number, through the reference's own constants."""
        token = token.strip()
        if re.fullmatch(r"-?\d+", token):
            return int(token)
        if token in TYPES:
            return TYPES[token]
        if token in ("FALSE", "TUIBAMU_NONE"):
            return 0
        if token == "TRUE":
            return 1
        # `(SETTING < n ? a : b)` is whichever of the two the setting picks.
        choice = re.fullmatch(r"\(?(\w+)\s*<\s*(\d+)\s*\?\s*(\d+)\s*:\s*(\d+)\)?", token)
        if choice:
            setting, bound, low, high = choice.groups()
            return int(low if self.number(setting, depth + 1) < int(bound) else high)
        if "|" in token:
            value = 0
            for part in token.split("|"):
                value |= self.number(part, depth + 1)
            return value
        if depth > 8 or token not in self.symbols:
            raise SystemExit(f"{token} is not a constant the reference's headers name")
        return self.number(self.symbols[token], depth + 1)


# --- which item is which -------------------------------------------------


def correspondence(reference, here):
    """reference name -> this tree's name, for everything both trees have."""
    by_id = {number: name for name, number in here.items()}
    pairs = {}
    for name, number in reference.ids.items():
        if number <= SHARED_LAST:
            if number in by_id and not (EMPTY_SLOT.match(by_id[number])
                                        and not EMPTY_SLOT.match(name)):
                pairs[name] = by_id[number]
        elif name in here:
            pairs[name] = name
    if here.get(SHARED_LAST_NAME) != SHARED_LAST or reference.ids.get(SHARED_LAST_NAME) != SHARED_LAST:
        raise SystemExit(f"{SHARED_LAST_NAME} is no longer {SHARED_LAST} in both trees; "
                         "the shared range has moved and the pairing above it is guesswork")
    for theirs, ours in ALIASES.items():
        if pairs.get(theirs) != ours:
            raise SystemExit(f"ALIASES says {theirs} is {ours}, the id pairing says "
                             f"{pairs.get(theirs)}")
    return pairs


def hold_effect_map(reference, here_effects):
    """reference hold effect name -> this tree's, where this tree has one."""
    by_number = {number: name for name, number in here_effects.items()}
    out = dict(HOLD_EFFECT_ALIASES)
    for name, number in reference.hold_effects.items():
        if number <= LAST_VANILLA_HOLD_EFFECT:
            if number in by_number:
                out.setdefault(name, by_number[number])
        elif name in here_effects:
            out.setdefault(name, name)
    return out


# --- the record ----------------------------------------------------------

BOOLEANS = {"prevent_toss", "selectable", "slp_heal", "psn_heal", "brn_heal", "frz_heal",
            "prz_heal", "cfs_heal", "inf_heal", "guard_spec", "revive", "revive_all",
            "level_up", "evolve", "pp_up", "pp_max", "pp_restore", "pp_restore_all",
            "hp_restore", "hp_ev_up", "atk_ev_up", "def_ev_up", "speed_ev_up",
            "spatk_ev_up", "spdef_ev_up", "friendship_mod_lo", "friendship_mod_med",
            "friendship_mod_hi"}
# Both trees number the pockets the same way; the reference also reaches them
# through its own FPOCKET_ names, which resolve to these.
POCKETS = ["POCKET_ITEMS", "POCKET_MEDICINE", "POCKET_BALLS", "POCKET_TMHMS",
           "POCKET_BERRIES", "POCKET_MAIL", "POCKET_BATTLE_ITEMS", "POCKET_KEY_ITEMS"]
# This game's price field is the sixteen bits Gen 4 gave it. The reference added
# a nibble beside it for the three items that cost more.
# The price is sixteen bits in the record plus a four-bit tail, as the
# reference splits it: konefr sells an Ability Patch for 500000.
MAX_PRICE = 0xFFFF
MAX_PRICE_WHOLE = 0xFFFFF


def record(reference, name, fields, effects, report):
    """One row of item_data.csv, field by field out of the reference's record."""
    body = reference.records[name]
    values = {field: value.strip() for field, value
              in re.findall(r"\.(\w+) = ([^,\n]+),", body)}
    # Most records say ITEM_PRICE(n), which splits n across the field and the
    # nibble the reference added beside it; forty-five write the two halves
    # straight out instead.
    whole = re.search(r"ITEM_PRICE\(([^)]*)\)", body)
    if whole:
        price = int(whole.group(1))
    else:
        price = reference.number(values["price"])
        price |= reference.number(values.get("price_high", "0")) << 16
    if price > MAX_PRICE_WHOLE:
        report.setdefault("prices past twenty bits", []).append((name, price))
        price = MAX_PRICE_WHOLE
    row = []
    for field in fields:
        if field == "price":
            row.append(str(price & 0xFFFF))
        elif field == "price_high":
            row.append(str((price >> 16) & 0xF))
        elif field == "pricepad":
            row.append("0")
        elif field == "holdEffect":
            theirs = reference.hold_effect(values[field])
            row.append(effects.get(theirs, theirs))
        elif field == "fieldPocket":
            row.append(POCKETS[reference.number(values[field])])
        elif field == "naturalGiftType":
            row.append(reference.natural_gift_type(values[field]))
        elif field == "fieldUseFunc":
            theirs = reference.number(values[field])
            routine = FIELD_USE_ROUTINES.get(theirs, theirs)
            if routine >= FIELD_USE_FUNCS:
                routine = GENERIC_FIELD_USE
            if routine == GENERIC_FIELD_USE != theirs:
                report.setdefault("field use routines this game has not got", []).append((name, theirs))
            row.append(str(routine))
        elif field in BOOLEANS:
            row.append("true" if values[field] == "TRUE" else "false")
        else:
            row.append(str(reference.number(values[field])))
    return row


# --- the text ------------------------------------------------------------


def item_text(revision, reference=gmm.REFERENCE):
    """bank -> {item id here: text}, hg-engine's item text at a revision.

    Every item item_map.csv names gets its reference id's row. The eight slots
    HeartGold left empty and konefr filled (113, 115-119, 121, 134) have no
    reference id and are not here, so they keep what they have. The engine's
    850 stops five rows short of its 856 items; hg-engine reads past the end
    of the bank there and shows nothing, so those rows are empty.
    """
    ids = defines(gmm.git_show(revision, "include/constants/item.h", reference), "ITEM_")
    ends = [ids[name] for name in GENERATION_ENDS]
    engine = {}
    out = {221: {}, 222: {}, 223: {}, 224: {}}
    names = gmm.reference_rows(revision, 222, reference)
    for row in csv.DictReader(ITEM_MAP.read_text().splitlines()):
        theirs, ours = int(row["reference_id"]), int(row["item_id"])
        if ids.get(row["reference_name"]) != theirs:
            raise SystemExit(f"{row['reference_name']} is not {theirs} at {revision}")
        generation = bisect.bisect_left(ends, theirs)
        offset = theirs - (ends[generation - 1] + 1 if generation else 0)
        out[222][ours] = names[theirs]
        for bank, kind in ((221, 0), (223, 1), (224, 2)):
            number = 830 + 4 * generation + kind
            if number not in engine:
                engine[number] = gmm.reference_rows(revision, number, reference)
            out[bank][ours] = engine[number][offset] if offset < len(engine[number]) else ""
    return out


def write_text(text, count, write):
    """The four banks, rows 0..count-1, each mapped row set to its text; rows
    the mapping does not name are kept as they are. Returns the rows changed."""
    changed = {}
    for bank, values in text.items():
        rows = gmm.read(bank)[:count]
        for index in range(count):
            if index in values:
                row = gmm.new_row(bank, index, values[index])
                if index >= len(rows):
                    rows.append(row)
                elif rows[index] != row:
                    changed.setdefault(bank, []).append((index, rows[index]["text"], values[index]))
                    rows[index] = row
            elif index >= len(rows):
                raise SystemExit(f"bank {bank}: row {index} is no item's and was never written")
        if write:
            gmm.write(bank, rows)
    return changed


# --- the self-check ------------------------------------------------------


# Fields where a shared item's record disagreeing with the reference means
# konefr changed the number and this port owes the change. Everything else
# that disagrees is a difference in how the two engines do the same thing,
# and is named in KEPT below with the reason.
SYNCED = ("price", "price_high", "naturalGiftPower", "flingPower", "holdEffectParam")

KEPT = {
    # This engine evolves a Pokemon by a party-use routine, not by a hold
    # effect: Prism Scale here has fieldUseFunc 20, partyUse and evolve set
    # and no hold effect, which is how every other evolution stone in the
    # game is written. Taking the reference's HOLD_EFFECT_EVOLVE_FEEBAS and
    # its zeroes would leave Feebas unable to evolve at all.
    ("ITEM_PRISM_SCALE", "holdEffect"),
    ("ITEM_PRISM_SCALE", "fieldUseFunc"),
    ("ITEM_PRISM_SCALE", "partyUse"),
    ("ITEM_PRISM_SCALE", "evolve"),
}


def sync(reference, pairs, effects, fields, rows, report):
    """Bring the shared items' records up to the reference's numbers.

    The importer only ever adds an item it has not got, so a record that came
    over with the ROM keeps the value Game Freak gave it even where konefr
    changed his. That is most of the economy -- an Amulet Coin is 100 here and
    30000 there -- and all of Natural Gift's sixth-generation powers.
    """
    changed = {}
    index = {name: i for i, name in enumerate(fields)}
    for theirs, ours in sorted(pairs.items()):
        if theirs not in reference.records or ours not in rows:
            continue
        got = record(reference, theirs, fields, effects, {})
        for field in SYNCED:
            if (ours, field) in KEPT:
                continue
            at = index[field]
            if rows[ours][at] != got[at]:
                changed.setdefault(field, []).append((ours, rows[ours][at], got[at]))
                rows[ours][at] = got[at]
    report["shared records brought up to the reference"] = {
        field: len(v) for field, v in sorted(changed.items())}
    return changed


def check(reference, pairs, effects, fields, here_rows, report):
    """Rebuild the items both trees already have and say where they disagree.

    Nothing here is written; this is how the conversion above earns its keep.
    A field that disagrees on a shared item is either a rule that is wrong or a
    number konefr changed, and either way it wants saying out loud before two
    thousand rows are written with it.
    """
    disagree = {}
    for theirs, ours in sorted(pairs.items()):
        if theirs not in reference.records or ours not in here_rows:
            continue
        got = record(reference, theirs, fields, effects, {})
        for field, mine, theirs_value in zip(fields, got, here_rows[ours]):
            if mine != theirs_value:
                disagree.setdefault(field, []).append((ours, mine, theirs_value))
    report["shared records checked"] = len(pairs)
    report["fields that disagree on a shared item"] = {
        field: len(rows) for field, rows in sorted(disagree.items())}


# --- writing -------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--limit", type=int, help="import only the first N, for a look by eye")
    parser.add_argument("--sync", action="store_true",
                        help="also bring the shared items' records up to the reference's numbers")
    parser.add_argument("--revision", default=gmm.ENGINE,
                        help="the reference revision the item text is read at (hg-engine's by default)")
    parser.add_argument("--text-only", action="store_true",
                        help="only rewrite msg_0221..0224 from item_map.csv")
    args = parser.parse_args()

    if args.text_only:
        changed = write_text(item_text(args.revision, args.reference),
                             len(item_block(ITEMS_H.read_text())), args.write)
        for bank, rows in sorted(changed.items()):
            print(f"msg_{bank:04d}: {len(rows)} rows change")
            for index, old, new in rows:
                print(f"  {index}: {old!r} -> {new!r}")
        if not args.write:
            print("\nnothing written; pass --write")
        return

    reference = Reference(args.reference)
    header = original(ITEMS_H)
    here = item_block(header)
    here_effects = defines(header, "HOLD_EFFECT_")
    pairs = correspondence(reference, here)
    effects = hold_effect_map(reference, here_effects)

    rows = list(csv.reader(ITEM_CSV.read_text().splitlines()))
    fields = rows[0][1:]
    here_rows = {row[0]: row[1:] for row in rows[1:]}

    report = {}
    check(reference, pairs, effects, fields, here_rows, report)
    if args.sync:
        sync(reference, pairs, effects, fields, here_rows, report)

    missing = [name for number, name in sorted((n, i) for i, n in reference.ids.items())
               if name not in pairs]
    report["items the reference has that this tree has not"] = len(missing)
    if args.limit:
        missing = missing[:args.limit]

    # Every hold effect the imported items name and this game has not got, in
    # the order they are first reached, numbered densely from here.
    next_effect = max(here_effects.values()) + 1
    new_effects = {}
    for name in missing:
        used = reference.hold_effect(
            re.search(r"\.holdEffect = ([^,\n]+),", reference.records[name]).group(1))
        if used not in effects and used not in new_effects:
            new_effects[used] = next_effect
            next_effect += 1
    effects = dict(effects, **{name: name for name in new_effects})
    report["hold effects the reference brings with it"] = len(new_effects)

    next_id = max(here.values()) + 1
    next_data = max(int(member) for member in
                    re.findall(r"NARC_item_data_(\d+)_bin", original(ITEM_C))) + 1
    # Both numbers of every rule, not just the first: a call names the tiles
    # and the palette, and starting the next pair on the last palette would
    # overwrite it.
    built = [int(member) for pair in
             re.findall(r"ITEMICON_FROM_PNG,(\d+),(\d+),", original(ITEM_MK)) for member in pair]
    next_icon = max(built + list(BLANK_ICON)) + 1

    constants, csv_rows, narc_rows, icon_rules, icons, mapping = [], [], [], [], [], []
    blank_art = unnamed = 0
    for name in missing:
        item_id, next_id = next_id, next_id + 1
        data_member, next_data = next_data, next_data + 1
        constants.append((name, item_id))
        csv_rows.append([name] + record(reference, name, fields, effects, report))

        member = reference.ids[name] + 2
        png, is_blank = reference.icons[member]
        if is_blank:
            blank_art += 1
            tiles, palette = BLANK_ICON
        else:
            tiles, palette = next_icon, next_icon + 1
            next_icon += 2
            icon_rules.append((tiles, palette, png.stem))
            icons.append((png, ICON_DIR / png.name))
        narc_rows.append((name, data_member, tiles, palette))

        # Eighty-four of konefr's constants are reserved gaps with no name in
        # 222.txt; they get the engine's own rows, like every other item.
        if not reference.names[reference.ids[name]].strip():
            unnamed += 1
        mapping.append((reference.ids[name], name, item_id, name))

    for theirs, ours in sorted(pairs.items(), key=lambda pair: reference.ids[pair[0]]):
        mapping.append((reference.ids[theirs], theirs, here[ours], ours))
    mapping.sort()

    report["items imported"] = len(missing)
    report["items taking the blank icon"] = blank_art
    report["items the reference leaves unnamed"] = unnamed
    report["item icons built from a PNG"] = len(icon_rules)
    if narc_rows:
        here_after = dict(here, **dict(constants))
        by_id = sorted(narc_rows, key=lambda r: here_after[r[0]])
        first_id, first_data = here_after[by_id[0][0]], by_id[0][1]
    report["ITEMS_COUNT"] = f"{len(here)} -> {len(here) + len(missing)}"
    for key, value in report.items():
        print(f"{key}: {value}")
    if not args.write:
        print("\nnothing written; pass --write")
        return

    count = len(here) + len(missing)
    width = max((len(name) for name, _ in constants), default=0) + 1
    text = header
    if new_effects:
        block = ["// The hold effects the reference brings with it. The names are konefr's,",
                 "// the numbers are this game's, since the reference numbers its own additions",
                 "// around a list this game does not have. Nothing reads them yet: the items",
                 "// come first, the effects are someone else's pass.", ""]
        effect_width = max(len(name) for name in new_effects) + 2
        block += [f"#define {name:<{effect_width}}{number}" for name, number in new_effects.items()]
        block.append("")
        text = text.replace("\n#define ITEM_NONE 0", "\n" + "\n".join(block) + "\n#define ITEM_NONE 0")
    if constants:
        block = ["// The rest of the reference's items, renumbered densely from where this tree",
                 "// is: konefr's id is theirs, not ours, and adopting it would renumber every",
                 "// item already here. tools/newgold/import/item_map.csv holds both.", ""]
        block += [f"#define {name:<{width}}{number}" for name, number in constants]
        block.append("")
        text = text.replace("\n#define ITEMS_COUNT", "\n" + "\n".join(block) + "\n#define ITEMS_COUNT")
    text = re.sub(r"#define ITEMS_COUNT[ \t]+\d+", f"#define ITEMS_COUNT       {count}", text)
    if narc_rows:
        text = re.sub(r"#define FIRST_IMPORTED_ITEM[ \t]+\d+", f"#define FIRST_IMPORTED_ITEM      {first_id}", text)
        text = re.sub(r"#define FIRST_IMPORTED_ITEM_DATA[ \t]+\d+", f"#define FIRST_IMPORTED_ITEM_DATA {first_data}", text)
    ITEMS_H.write_text(text)

    # here_rows is what sync() edits in place, so the kept rows are read back
    # out of it rather than out of the file as it was.
    kept = [[row[0]] + here_rows[row[0]] for row in rows[1:] if row[0] in here]
    with ITEM_CSV.open("w", newline="") as out:
        writer = csv.writer(out, lineterminator="\n")
        writer.writerow(rows[0])
        writer.writerows(kept + csv_rows)

    table = original(ITEM_C)
    if narc_rows:
        # One halfword an item: the data member follows the id, the AGB code is
        # none, and the icon is its own tiles member (the palette is always the
        # next one) or zero for the blank pair. The full four-column rows cost
        # the main arena 21 KB, and that arena is what a new heap is carved from.
        for k, (name, data, tiles, palette) in enumerate(by_id):
            if data != first_data + k:
                raise SystemExit(f"{name}: data member {data} breaks the run from {first_data}")
            if tiles != BLANK_ICON[0] and palette != tiles + 1:
                raise SystemExit(f"{name}: palette {palette} is not the member after its tiles {tiles}")
        icon_members = [0 if tiles == BLANK_ICON[0] else tiles for _, _, tiles, _ in by_id]
        lines = ["// The rest of the reference's items take no rows: their data members run in",
                 "// order from FIRST_IMPORTED_ITEM_DATA, their AGB code is none, and their icon",
                 "// is either a member of their own -- the palette is always the next one -- or",
                 "// the blank pair ITEM_NONE draws with, which is what a zero here means. Kept",
                 "// as one halfword an item instead of four, because the full table cost the",
                 "// arena 21 KB it did not have to spend.",
                 "static const u16 sImportedItemIcons[ITEMS_COUNT - FIRST_IMPORTED_ITEM] = {"]
        lines += ["    " + ", ".join(f"{v:4d}" for v in icon_members[k:k + 12]) + "," for k in range(0, len(icon_members), 12)]
        lines.append("};")
        head, marker, rest = table.partition("sItemNarcIds[FIRST_IMPORTED_ITEM][4] = {")
        end = rest.index("\n};\n") + len("\n};\n")
        table = head + marker + rest[:end] + "\n" + "\n".join(lines) + "\n" + rest[end:]
    ITEM_C.write_text(table)

    makefile = original(ITEM_MK)
    if icon_rules:
        lines = ["# The rest of the reference's item icons, resolved by archive member --",
                 "# itemgra.mk keys a PNG by the member, which is the item's id plus two, so a",
                 "# name is not evidence. The blank ones are not here: they take ITEM_NONE's.", ""]
        lines += [f"$(eval $(call ITEMICON_FROM_PNG,{tiles},{palette},{stem}))"
                  for tiles, palette, stem in icon_rules]
        lines.append("")
        makefile = makefile.replace("\n$(ITEMICON_NARC)", "\n" + "\n".join(lines) + "\n$(ITEMICON_NARC)", 1)
    ITEM_MK.write_text(makefile)

    for source, destination in icons:
        shutil.copyfile(source, destination)

    with ITEM_MAP.open("w", newline="") as out:
        writer = csv.writer(out, lineterminator="\n")
        writer.writerow(["reference_id", "reference_name", "item_id", "item_name"])
        writer.writerows(mapping)
    write_text(item_text(args.revision, args.reference), count, True)
    print(f"\nwritten; {ITEM_MAP.relative_to(ROOT)} holds {len(mapping)} names")


if __name__ == "__main__":
    main()
