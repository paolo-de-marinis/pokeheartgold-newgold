#!/usr/bin/env python3
"""Bring the reference's items into this game, renumbered densely from here.

WHY THE NUMBERS ARE NOT THE REFERENCE'S

konefr numbers an added item wherever there was room: their Black Augurite is
1691. This tree numbered its own additions densely instead, and that Black
Augurite is 537. Adopting their numbering would renumber every item this game
already has, which is Paolo's save, his bag and every held item in the data --
so an imported item gets the next free id HERE, and the mapping from their name
to that id is written to tools/newgold/item_map.csv for the next script and for
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
    files/msgdata/msg/msg_0221..0224.gmm   description, name, with-article, plural
    src/item.c                             sItemNarcIds
    tools/newgold/item_map.csv             the mapping

An icon is resolved by ARCHIVE MEMBER, never by name: data/graphics/itemgra.mk
keys a PNG by the member, which is the item's id plus two, and 1634 of those
PNGs are byte-identical to none.png -- snowball_pla.png is not the Snowball's.
An item whose art is the blank one is given ITEM_NONE's icon here knowingly,
rather than 1610 more copies of the same empty square.

Every run rewrites its own generated blocks rather than appending to them, so
running it twice is running it once.

Usage: import_items.py REFERENCE_CHECKOUT [--write] [--limit N]
Without --write it reports what it would change and touches nothing.
"""

import argparse
import csv
import hashlib
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ITEMS_H = ROOT / "include/constants/items.h"
ITEM_CSV = ROOT / "files/itemtool/itemdata/item_data.csv"
ITEM_MK = ROOT / "files/itemtool/itemdata/item_data.mk"
ICON_DIR = ROOT / "files/itemtool/itemdata/item_icon"
ITEM_C = ROOT / "src/item.c"
MSG = ROOT / "files/msgdata/msg"
ITEM_MAP = ROOT / "tools/newgold/item_map.csv"

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

# The reference's description bank, data/text/221.txt, is a single line for the
# whole game -- there is no per-item description to carry. An imported item gets
# that line, which is what konefr's own bag shows. Writing real descriptions is
# prose, not an import.
NO_DESCRIPTION = "Custom item description"

# What a previous run wrote, so a run reads what was here before it.
GENERATED = {
    ITEMS_H: (r"\n// The hold effects the reference brings with it.*?(?=\n#define ITEM_NONE 0)",
              r"\n// The rest of the reference's items.*?(?=\n#define ITEMS_COUNT)"),
    ITEM_C: (r"\n    // The rest of the reference's items.*?(?=\n\};)",),
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

# What each of konefr's six becomes here. Four of them change a form this game
# has no species record and no sprite for, so those records really do have
# nothing to do and stay at routine 0. The Ability Capsule and the twenty-one
# Mints need no form at all, and all their routine ever did was open the party
# menu on the item -- so they get routine 1, the same one konefr give the
# Ability Patch, and src/party_menu.c answers them the way it answers the
# Gracidea.
FIELD_USE_ROUTINES = {
    30: GENERIC_FIELD_USE,     # Reveal Glass -- no Therian forms here
    31: GENERIC_FIELD_USE,     # DNA Splicers -- no Kyurem Black or White here
    32: PARTY_MENU_FIELD_USE,  # Ability Capsule
    33: PARTY_MENU_FIELD_USE,  # Mint
    34: GENERIC_FIELD_USE,     # Nectar -- no Oricorio forms here
    35: GENERIC_FIELD_USE,     # Rotom Catalog -- needs the appliance list menu
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
            routine = reference.number(values[field])
            if routine >= FIELD_USE_FUNCS:
                here = FIELD_USE_ROUTINES.get(routine, GENERIC_FIELD_USE)
                if here == GENERIC_FIELD_USE:
                    report.setdefault("field use routines this game has not got", []).append(
                        (name, routine))
                routine = here
            row.append(str(routine))
        elif field in BOOLEANS:
            row.append("true" if values[field] == "TRUE" else "false")
        else:
            row.append(str(reference.number(values[field])))
    return row


# --- the text ------------------------------------------------------------

# A letter that is read aloud starting with a vowel, for the items whose name
# begins with an initialism: an HM01, an X Attack, a TM01.
SPOKEN_VOWEL = set("AEFHILMNORSX")


def with_article(name):
    first = name.split()[0]
    if re.fullmatch(r"[A-Z]{1,3}\d*\.?", first):
        article = "an" if first[0] in SPOKEN_VOWEL else "a"
    else:
        article = "an" if name[0].upper() in "AEIOU" else "a"
    return f"{article} {{COLOR 255}}{name}{{COLOR 0}}"


def plural(name):
    """Cheri Berry pluralises to Cheri Berries, Scroll of Darkness to Scrolls.

    ponytail: regular English only. The bank's own irregulars -- Mail and
    Honey, which do not pluralise, Scarf to Scarves, Old Gateaux -- are left to
    whoever cares; check() counts how many of the existing rows the rule would
    not have produced so the ceiling is a number rather than a feeling.
    """
    head, of, rest = name.partition(" of ")
    if head.endswith(("f",)):
        head = head[:-1] + "ves"
    elif head.endswith("fe"):
        head = head[:-2] + "ves"
    elif head.endswith("y") and head[-2:-1].lower() not in "aeiou":
        head = head[:-1] + "ies"
    elif head.endswith(("s", "x", "z", "ch", "sh")):
        head = head + "es"
    else:
        head = head + "s"
    return head + of + rest


def bank_rows(path):
    return re.findall(r"\t<row id=\"[^\"]+\" index=\"\d+\">\n(.*?)\n\t</row>\n",
                      path.read_text(encoding="utf-8"), re.S)


def write_bank(path, bodies):
    out = ['<?xml version="1.0"?>', '<body language="English">']
    stem = path.stem
    for index, body in enumerate(bodies):
        out.append(f'\t<row id="{stem}_{index:05d}" index="{index}">')
        out.append(body)
        out.append("\t</row>")
    out.append("</body>")
    path.write_text("\n".join(out) + "\n", encoding="utf-8")


def row_body(text):
    return ('\t\t<attribute name="window_context_name">used</attribute>\n'
            f'\t\t<language name="English">{text}</language>')


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

    names = bank_text(MSG / "msg_0222.gmm")
    articles, plurals = bank_text(MSG / "msg_0223.gmm"), bank_text(MSG / "msg_0224.gmm")
    report["rows the article rule would not reproduce"] = sum(
        1 for name, value in zip(names, articles) if name != "???" and with_article(name) != value)
    report["rows the plural rule would not reproduce"] = sum(
        1 for name, value in zip(names, plurals) if name != "???" and plural(name) != value)


def bank_text(path):
    return re.findall(r'<language name="English">(.*?)</language>',
                      path.read_text(encoding="utf-8"), re.S)


# --- writing -------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", type=Path)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--limit", type=int, help="import only the first N, for a look by eye")
    parser.add_argument("--sync", action="store_true",
                        help="also bring the shared items' records up to the reference's numbers")
    args = parser.parse_args()

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
    banks = {bank: bank_rows(MSG / f"msg_{bank}.gmm")[:len(here)] for bank in
             ("0221", "0222", "0223", "0224")}
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
        # 222.txt. This game already writes such a slot the same way -- an empty
        # description and ??? in the other three -- so they are written that way
        # rather than given an invented name.
        text = reference.names[reference.ids[name]].strip()
        if text:
            banks["0221"].append(row_body(NO_DESCRIPTION))
            banks["0222"].append(row_body(text))
            banks["0223"].append(row_body(with_article(text)))
            banks["0224"].append(row_body(plural(text)))
        else:
            unnamed += 1
            banks["0221"].append(row_body(""))
            for bank in ("0222", "0223", "0224"):
                banks[bank].append(row_body("???"))
        mapping.append((reference.ids[name], name, item_id, name))

    for theirs, ours in sorted(pairs.items(), key=lambda pair: reference.ids[pair[0]]):
        mapping.append((reference.ids[theirs], theirs, here[ours], ours))
    mapping.sort()

    report["items imported"] = len(missing)
    report["items taking the blank icon"] = blank_art
    report["items the reference leaves unnamed"] = unnamed
    report["item icons built from a PNG"] = len(icon_rules)
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
                 "// item already here. tools/newgold/item_map.csv holds both.", ""]
        block += [f"#define {name:<{width}}{number}" for name, number in constants]
        block.append("")
        text = text.replace("\n#define ITEMS_COUNT", "\n" + "\n".join(block) + "\n#define ITEMS_COUNT")
    text = re.sub(r"#define ITEMS_COUNT[ \t]+\d+", f"#define ITEMS_COUNT       {count}", text)
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
        lines = ["    // The rest of the reference's items. An item whose art is konefr's blank",
                 f"    // placeholder takes ITEM_NONE's icon, members {BLANK_ICON[0]} and",
                 f"    // {BLANK_ICON[1]}; the rest are built from the PNGs in item_icon."]
        lines += [f"    [{name}] = {{ NARC_item_data_{data:04d}_bin, "
                  f"NARC_item_icon_item_icon_{tiles:03d}_NCGR, "
                  f"NARC_item_icon_item_icon_{palette:03d}_NCLR, AGB_ITEM_NONE }},"
                  for name, data, tiles, palette in narc_rows]
        # The table's own closing brace, not the first one in the file: this
        # went into sPocketCounts once.
        head, marker, rest = table.partition("sItemNarcIds[ITEMS_COUNT][4] = {")
        end = rest.index("\n};")
        table = head + marker + rest[:end] + "\n" + "\n".join(lines) + rest[end:]
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

    for bank, bodies in banks.items():
        write_bank(MSG / f"msg_{bank}.gmm", bodies)

    with ITEM_MAP.open("w", newline="") as out:
        writer = csv.writer(out, lineterminator="\n")
        writer.writerow(["reference_id", "reference_name", "item_id", "item_name"])
        writer.writerows(mapping)
    print(f"\nwritten; {ITEM_MAP.relative_to(ROOT)} holds {len(mapping)} names")


if __name__ == "__main__":
    main()
