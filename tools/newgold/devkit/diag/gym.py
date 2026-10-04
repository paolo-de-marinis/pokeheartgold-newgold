#!/usr/bin/env python3
"""Fight what a save stands the player in front of, and report it as text.

    gym.py SAVE [--move N] [--frames N]

Without --move it plays each turn as a player weighs it (Scorer.choose),
from the battlers the battle holds -- their stats and stages, types,
abilities, items and moves, read from the battle context -- and the game's
own tables: the damage formula with the same-type bonus, the type chart,
the weather, the screens, a burn, the abilities a player is told of and the
items that strengthen a move, each move's chance to land. A move that
knocks the foe out before it answers; the bag's Potions and the like, or a
move that gives HP back, when the Pokemon would lose the exchange and the
HP wins it; a status move where it pays -- sleep, paralysis on a faster
foe, a burn on a physical one, Toxic -- or one raising the stat its attack
uses; otherwise the attack that takes most of the foe's HP. A Pokemon that
loses the exchange is relieved by one from the bench that wins it, the hit
it takes coming in counted (Scorer.relief), once against each foe, and
after a faint the best of the bench against the foe comes in (rank). It
is a heuristic -- no critical hits, no foe switching, no double-battle
partner weighed for the other -- but it plays a leader the way a player
does. A move the battle says did nothing to a foe (Levitate against a
Ground move) is not chosen against that species again in the battle.

The ROM is the NEWGOLD_DIAG=1 build, run in-process by core.py. Nothing is
drawn and nothing is looked at: after every few frames the diagnostics'
memory says what the battle printed, who is fighting, and whether the game
is waiting for the player, and the player answers through the game's own
menus -- a touch on FIGHT, on a move, on a Pokemon -- exactly where a thumb
would go. B moves text on and declines "will you switch?" and a caught
Pokemon's nickname; A moves it on through an evolution, which B would stop,
and a caught Pokemon's Dex entry, which B does not close. A move a level-up
brings to a Pokemon that knows four is learned or given up by a rule
(forgets): the strongest damaging move of each type is kept, strongest
first, then the other damaging moves, then the rest. A wild battle's "Use
next Pokemon?" is answered with the next one. A wild Pokemon the caller
wants caught is weakened and a ball thrown at it (fight's catch).

The report is the battle's own lines, the battlers each turn, what the
trainer's AI spent, anything that asserted, and the party before and after.
"""
import argparse
import csv
import math
import os
import re
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import savedit  # noqa: E402
from core import Core, pin_clock  # noqa: E402
from markers import BATTLER, DIAG_ELF, STATES, Markers  # noqa: E402
from party import badges, party, sealed_mons  # noqa: E402
from party import bag as in_bag, mons as party_mons  # noqa: E402

ROOT = Path(__file__).resolve().parents[4]
ROM = ROOT / "build/heartgold.us.diag/pokeheartgold.us.nds"
# The bottom screen, in its own pixels (256 by 192).
FIGHT = (128, 83)
RUN = (128, 170)             # under FIGHT
MOVES = [(64, 51), (192, 51), (64, 116), (192, 116)]
PARTY = [(64, 35), (192, 38), (64, 78), (192, 81), (64, 123), (192, 126)]
SHIFT = (127, 113)
KEEP_BATTLING = (128, 139)   # "will you switch?" -- the lower of the two
GIVE_UP = (128, 67)          # "give up on learning this new move?" -- the upper of the two
USE_NEXT = (128, 67)         # a wild battle's "Use next Pokemon?" -- the upper; the lower flees
FORGET_A_MOVE = (128, 67)    # "Make it forget another move?" -- the upper, "Forget a move!"
# The battle party menu a move to forget opens (its mode 3): on screen 6 the
# four moves where the fight menu has them, the new one below and the back
# arrow, which gives the new one up; on screen 7, a move's page, FORGET.
LEARN_MOVES, LEARN_BACK, LEARN_FORGET = [(64, 73), (192, 73), (64, 120), (192, 120)], (234, 170), (104, 170)
LEARN_MODE, LEARN_LIST, LEARN_PAGE = 3, 6, 7
BAG = (40, 170)              # left of RUN
POKEMON = (216, 170)         # right of RUN
# The battle bag, overlay 8, by its hitbox tables: the Poke Balls pocket at
# the upper right (ov08_02225B4C), a pocket page's first item at the upper
# left (ov08_02225B68), USE along the bottom (ov08_02225ADC).
BALLS, FIRST_ITEM, USE = (192, 43), (64, 31), (104, 171)
# The HP/PP pocket at the upper left, BattleBag.pocketItems[0]; a page's six
# items, two to a row (ov08_02225B68).
HP_POCKET, CELLS = (64, 43), [(64, 31), (192, 31), (64, 79), (192, 79), (64, 127), (192, 127)]
IN_BAG = 8                   # gDiagBattlePrompt while the bag is up (SSI_STATE_8)
MARGIN = 50                  # a Pokemon to catch is weakened while it has more than this share of its HP
# The lines after which the party screen asks who comes in for a Pokemon that
# is still standing: a pivot move's or Parting Shot's, the Eject items',
# Baton Pass's (whose move line is the last before the screen) and Shed
# Tail's. A Baton Pass with nobody to pass to says "But it failed!" after it.
PIVOT_LINES = ("went back to", "switched out with the Eject Button", "switched out by the Eject Pack",
               "used Baton Pass!", "shed its tail to create a decoy!")
# A double battle's target screen: the foes above, battler 3 on the left and
# battler 1 on the right, and the player's two below, the first on the left.
# A move on the user's side is confirmed on its own panel.
FOE_PANELS = [(64, 43), (192, 43)]
OWN_PANELS = {0: (64, 115), 2: (192, 115)}
RANGE_USER, RANGE_USER_SIDE, RANGE_ALLY = 1 << 4, 1 << 5, 1 << 8   # include/constants/moves.h
BATTLE_MAIN, EXIT = STATES.index("BATTLE_MAIN"), STATES.index("EXIT")
EVOLVING = (STATES.index("EVOLUTION_INIT"), STATES.index("EVOLUTION_MAIN"))

# What the picker knows (Scorer.choose), by the tree's own names. A move's
# split in waza_tbl; a stat's place in BattleMon.statChanges (constants/
# pokemon.h); the status bits (constants/battle.h).
PHYSICAL, SPECIAL, STATUS_MOVE = 0, 1, 2
STAT_ATK, STAT_DEF, STAT_SPEED, STAT_SPATK, STAT_SPDEF, STAT_ACC, STAT_EVASION = 1, 2, 3, 4, 5, 6, 7
SLEEP, POISONED, BURN, PARALYSIS = 7, (1 << 3) | (1 << 7), 1 << 4, 1 << 6
STATUS_ANY = SLEEP | POISONED | BURN | PARALYSIS | (1 << 5)
# Powders, which a Grass type or Overcoat shrugs off: waza_tbl has no flag for it.
POWDERS = ("SLEEP_POWDER", "STUN_SPORE", "POISON_POWDER", "SPORE", "COTTON_SPORE", "RAGE_POWDER", "MAGIC_POWDER")
# The abilities a player is told of and the picker weighs: a type they take
# nothing from, a pinch ability's type, the -ate abilities' type.
IMMUNE = {"LEVITATE": "GROUND", "EARTH_EATER": "GROUND", "FLASH_FIRE": "FIRE", "WELL_BAKED_BODY": "FIRE",
          "WATER_ABSORB": "WATER", "STORM_DRAIN": "WATER", "DRY_SKIN": "WATER", "VOLT_ABSORB": "ELECTRIC",
          "LIGHTNINGROD": "ELECTRIC", "MOTOR_DRIVE": "ELECTRIC", "SAP_SIPPER": "GRASS"}
PINCH = {"OVERGROW": "GRASS", "BLAZE": "FIRE", "TORRENT": "WATER", "SWARM": "BUG"}
ATE = {"PIXILATE": "FAIRY", "AERILATE": "FLYING", "REFRIGERATE": "ICE", "GALVANIZE": "ELECTRIC"}
STATUS_IMMUNE = {SLEEP: ("INSOMNIA", "VITAL_SPIRIT", "SWEET_VEIL"), PARALYSIS: ("LIMBER",),
                 BURN: ("WATER_VEIL", "WATER_BUBBLE", "THERMAL_EXCHANGE"), POISONED: ("IMMUNITY", "PASTEL_VEIL")}
TYPE_IMMUNE = {PARALYSIS: ("ELECTRIC",), BURN: ("FIRE",), POISONED: ("POISON", "STEEL")}
# Move effects by their names in constants/move_effects.h: what costs the
# user itself, what deals nothing a player can count on, the fixed damage,
# the strikes of a multi-strike move (2 to 5 averaging 3.1), the moves that
# take a turn more (a charge or a recharge: half the worth, unless they knock
# out), the moves that give HP back and the stats a move raises.
SELF_KO = {"HALVE_DEFENSE", "FAINT_AND_FULL_HEAL_NEXT_MON", "FAINT_FULL_RESTORE_NEXT_MON", "FINAL_GAMBIT",
           "FAINT_AND_ATK_SP_ATK_DOWN_2"}
NO_DAMAGE = {"COUNTER", "MIRROR_COAT", "METAL_BURST", "BIDE", "ALWAYS_FLINCH_FIRST_TURN_ONLY", "FIRST_TURN_ONLY",
             "HIT_LAST_WHIFF_IF_HIT", "SPIT_UP", "FLING", "NATURAL_GIFT", "BEAT_UP", "HIT_IN_3_TURNS"}
FIXED = {"LEVEL_DAMAGE_FLAT", "RANDOM_DAMAGE_1_TO_150_LEVEL", "40_DAMAGE_FLAT", "10_DAMAGE_FLAT", "HALVE_HP"}
HITS = {"MULTI_HIT": 3.1, "HIT_TWICE": 2, "POISON_MULTI_HIT": 2, "HIT_TWICE_AND_FLINCH": 2, "HIT_THREE_TIMES": 6,
        "HIT_THREE_TIMES_INCREMENT_BASE_POWER_20": 6, "HIT_THREE_TIMES_ALWAYS_CRITICAL": 4.5,
        "HIT_THREE_TIMES_FLAT": 3, "UP_TO_10_HITS": 5}
SLOW = {"RECHARGE_AFTER", "CHARGE_TURN_HIGH_CRIT", "CHARGE_TURN_HIGH_CRIT_FLINCH", "CHARGE_TURN_DEF_UP", "151", "FLY",
        "DIG", "DIVE", "BOUNCE", "SHADOW_FORCE", "CHARGE_TURN_ATK_SP_ATK_SPEED_UP_2", "CHARGE_TURN_SP_ATK_UP",
        "CHARGE_TURN_SP_ATK_UP_RAIN_SKIPS", "CHARGE_TURN_PARALYZE_HIT", "CHARGE_TURN_BURN_HIT"}
RESTORES = {"RESTORE_HALF_HP", "HEAL_HALF_MORE_IN_SUN", "HEAL_HALF_REMOVE_FLYING_TYPE"}
BOOSTS = {"ATK_UP": (STAT_ATK,), "ATK_UP_2": (STAT_ATK,), "ATK_UP_3": (STAT_ATK,), "SP_ATK_UP": (STAT_SPATK,),
          "SP_ATK_UP_2": (STAT_SPATK,), "SP_ATK_UP_3": (STAT_SPATK,), "ATK_SPD_UP": (STAT_ATK, STAT_SPEED),
          "SP_ATK_SP_DEF_UP": (STAT_SPATK, STAT_SPDEF), "ATK_DEF_UP": (STAT_ATK, STAT_DEF),
          "SP_ATK_SP_DEF_SPEED_UP": (STAT_SPATK, STAT_SPDEF, STAT_SPEED), "ATK_SP_ATK_UP": (STAT_ATK, STAT_SPATK),
          "ATK_SP_ATK_SPEED_UP_2_DEF_SP_DEF_DOWN": (STAT_ATK, STAT_SPATK, STAT_SPEED), "ATK_ACC_UP": (STAT_ATK,),
          "ATK_DEF_ACC_UP": (STAT_ATK, STAT_DEF), "HOWL": (STAT_ATK,), "SPEED_UP_2_ATK_UP": (STAT_ATK, STAT_SPEED)}


def at_stage(value, stage):
    """A stat at its stage: BattleMon.statChanges holds 0 to 12, 6 for none."""
    s = stage - 6
    return value * (2 + s) / 2 if s >= 0 else value * 2 / (2 - s)


def narc(path):
    """The members of an archive, as bytes."""
    data = path.read_bytes()
    count = struct.unpack_from("<H", data, 0x18)[0]
    spans = [struct.unpack_from("<II", data, 0x1C + 8 * i) for i in range(count)]
    base = data.index(b"GMIF") + 8
    return [data[base + start:base + end] for start, end in spans]


class Scorer:
    """How hard a move hits a Pokemon, from the data this tree builds."""

    def __init__(self):
        self.moves = narc(ROOT / "files/poketool/waza/waza_tbl.narc")
        self.personal = narc(ROOT / "files/poketool/personal/personal.narc")
        header = (ROOT / "include/constants/pokemon.h").read_text()
        # TYPE_FORESIGHT is 0xFE: read as a bare \d+ it is 0, and the Foresight
        # marker row becomes "Normal does nothing to Normal".
        numbers = {name: int(value, 0) for name, value in
                   re.findall(r"#define (TYPE_\w+)\s+(0x[0-9A-Fa-f]+|\d+)\b", header)}
        source = (ROOT / "src/battle/overlay_12_0224E4FC.c").read_text()
        table = source[source.index("sTypeEffectiveness[][3] = {"):]
        table = table[:table.index("};")]
        self.chart = {(numbers[a], numbers[d]): numbers[m] / 10
                      for a, d, m in re.findall(r"\{\s*(TYPE_\w+),\s*(TYPE_\w+),\s*(TYPE_MUL_\w+)\s*\}", table)}

    def types(self, species):
        record = self.personal[species] if species < len(self.personal) else b""
        return set(record[6:8]) if len(record) >= 8 else set()

    def panel(self, move, battler, tries):
        """Where to touch on the target screen for this move of this battler."""
        record = self.moves[move] if move < len(self.moves) else b""
        reach = struct.unpack_from("<H", record, 8)[0] if len(record) >= 10 else 0
        if reach & (RANGE_USER | RANGE_USER_SIDE):
            return OWN_PANELS[battler]
        if reach & RANGE_ALLY:
            return OWN_PANELS[2 - battler]
        # The player's first aims at battler 3, its second at battler 1, each
        # at the other foe when that touch is not taken (the foe gone).
        return FOE_PANELS[(tries + battler // 2) % 2]

    def kind(self, move):
        record = self.moves[move] if move < len(self.moves) else b""
        return record[4] if len(record) >= 5 else None

    def strength(self, move, user):
        """A move's power with its same-type bonus, 0 for a status move: how
        forgets() ranks what a Pokemon knows, against no foe in particular."""
        record = self.moves[move] if move < len(self.moves) else b""
        if len(record) < 5 or record[3] == 0:
            return 0
        return record[3] * (1.5 if record[4] in self.types(user) else 1)

    def score(self, move, user, target):
        record = self.moves[move] if move < len(self.moves) else b""
        # effect (2 bytes), split, power, type: import_moves.py's RECORD.
        if len(record) < 5 or record[3] == 0:
            return 0.1  # a status move, or one this table does not know: last resort
        power, kind = record[3], record[4]
        value = power * (1.5 if kind in self.types(user) else 1)
        for defending in self.types(target):
            value *= self.chart.get((kind, defending), 1)
        return value

    # -- the picker: what a player weighs before touching a move ----------

    def record(self, move):
        """A move's (effect name, split, power, type, accuracy, priority)."""
        record = self.moves[move] if move < len(self.moves) else b""
        if len(record) < 11:
            return "", STATUS_MOVE, 0, 0, 0, 0
        effect, split, power, kind, accuracy = struct.unpack_from("<HBBBB", record, 0)
        return self.effects.get(effect, ""), split, power, kind, accuracy, struct.unpack_from("<b", record, 10)[0]

    @property
    def effects(self):
        if not hasattr(self, "_effects"):
            self._effects = {n: k[len("MOVE_EFFECT_"):] for k, n in
                             savedit.constants("include/constants/move_effects.h", "MOVE_EFFECT_").items()}
            self._abilities = {n: k[len("ABILITY_"):] for k, n in
                               savedit.constants("include/constants/abilities.h", "ABILITY_").items()}
            self._type = {k[len("TYPE_"):]: n for k, n in
                          savedit.constants("include/constants/pokemon.h", "TYPE_").items()}
            items = savedit.constants("include/constants/items.h", "ITEM_")
            with (ROOT / "files/itemtool/itemdata/item_data.csv").open() as f:
                self._items = {items[row["item"]]: row for row in csv.DictReader(f) if row["item"] in items}
            moves = savedit.move_numbers()
            self._powders = {moves[name] for name in POWDERS if name in moves}
        return self._effects

    def ability(self, mon):
        self.effects
        return self._abilities.get(mon["ability"], "")

    def held(self, mon):
        """The hold effect of a battler's item, by its name: STRENGTHEN_FIRE, CHOICE_ATK..."""
        self.effects
        row = self._items.get(mon["item"])
        return row["holdEffect"][len("HOLD_EFFECT_"):] if row else ""

    def heal_items(self):
        """The items the battle bag's HP/PP pocket lists that give HP back to
        a Pokemon still standing."""
        self.effects
        return [item for item, row in self._items.items()
                if row["hp_restore"] == "true" and row["revive"] == "false" and row["battlePocket"] != "0"]

    def heal(self, item):
        """The HP an item from the bag gives back (hp_restore_param), 0 for one
        that gives none; 255 is all of it, 253 a quarter."""
        self.effects
        row = self._items.get(item)
        return int(row["hp_restore_param"]) if row and row["hp_restore"] == "true" else 0

    def speed(self, mon, field):
        """A battler's Speed as the turn order reads it: its stage, paralysis,
        a Choice Scarf, Quick Feet, Swift Swim and Chlorophyll."""
        value, ability = at_stage(mon["speed"], mon["stages"][STAT_SPEED]), self.ability(mon)
        if mon["status"] & STATUS_ANY:
            value *= 1.5 if ability == "QUICK_FEET" else 0.5 if mon["status"] & PARALYSIS else 1
        if self.held(mon) == "CHOICE_SPEED":
            value *= 1.5
        if (ability == "SWIFT_SWIM" and field["rain"]) or (ability == "CHLOROPHYLL" and field["sun"]):
            value *= 2
        return value

    def hit(self, move, user, foe, field, guard=0):
        """(the HP `move` takes off `foe` when it lands, on an average roll;
        the chance that it lands): the damage formula with both battlers'
        stats at their stages, the same-type bonus, the type chart, a burn,
        the weather, the foe's side's screens (`guard`, its side condition
        flags), the held items that strengthen a move and the abilities a
        player is told of (IMMUNE, PINCH, ATE and the few named here); (0, 0)
        for a move that deals nothing to it."""
        name, split, power, kind, accuracy, _ = self.record(move)
        user_ability, foe_ability, item = self.ability(user), self.ability(foe), self.held(user)
        if split == STATUS_MOVE or name in SELF_KO or name in NO_DAMAGE:
            return 0, 0
        if (name == "DAMAGE_WHILE_ASLEEP" and not user["status"] & SLEEP) or \
                (name == "RECOVER_DAMAGE_SLEEP" and not foe["status"] & SLEEP):
            return 0, 0
        if name == "CHANGE_TYPE_WITH_WEATHER" and (field["rain"] or field["sun"]):
            kind, power = self._type["WATER" if field["rain"] else "FIRE"], power * 2
        boost = 1
        if kind == self._type["NORMAL"] and user_ability in ATE:
            kind, boost = self._type[ATE[user_ability]], 1.2
        if name == "RANDOM_POWER_BASED_ON_IVS":
            kind = None     # Hidden Power's type comes from the IVs: taken as neutral
        effective = 1
        for defending in foe["types"] if kind is not None else ():
            rate = self.chart.get((kind, defending), 1)
            if rate == 0 and user_ability in ("SCRAPPY", "MINDS_EYE") and defending == self._type["GHOST"]:
                rate = 1
            effective *= rate
        if kind is not None and IMMUNE.get(foe_ability) == self._kind_name(kind):
            effective = 0
        if foe_ability == "WONDER_GUARD" and effective <= 1:
            effective = 0
        if effective == 0:
            return 0, 0
        chance = self.chance(accuracy, split, user, foe, field)
        if name in FIXED:
            fixed = {"LEVEL_DAMAGE_FLAT": user["level"], "RANDOM_DAMAGE_1_TO_150_LEVEL": user["level"],
                     "40_DAMAGE_FLAT": 40, "10_DAMAGE_FLAT": 20, "HALVE_HP": max(1, foe["hp"] // 2)}
            return fixed[name], chance
        if name == "ONE_HIT_KO":
            return (foe["hp"], 0.3) if user["level"] >= foe["level"] else (0, 0)
        power = self.power(name, power, user, foe, field) * boost
        if user_ability == "TECHNICIAN" and power <= 60:
            power *= 1.5
        physical = split == PHYSICAL
        attack = at_stage(user["atk"] if physical else user["spAtk"], user["stages"][STAT_ATK if physical else STAT_SPATK])
        defense = at_stage(foe["def"] if physical else foe["spDef"], foe["stages"][STAT_DEF if physical else STAT_SPDEF])
        if physical and user_ability in ("HUGE_POWER", "PURE_POWER"):
            attack *= 2
        if physical and (user_ability == "HUSTLE" or (user_ability == "GUTS" and user["status"] & STATUS_ANY)):
            attack *= 1.5
        if item == ("CHOICE_ATK" if physical else "CHOICE_SPATK"):
            attack *= 1.5
        if user_ability in PINCH and kind == self._type[PINCH[user_ability]] and 3 * user["hp"] <= user["maxHp"]:
            attack *= 1.5
        if foe_ability == "THICK_FAT" and kind in (self._type["FIRE"], self._type["ICE"]):
            attack *= 0.5
        if self.held(foe) == "BOOST_IF_NOT_EVOLVED" or (self.held(foe) == "SPDEF_BOOST_NO_STATUS_MOVES" and not physical):
            defense *= 1.5
        if physical and (foe_ability == "FUR_COAT" or (foe_ability == "MARVEL_SCALE" and foe["status"] & STATUS_ANY)):
            defense *= 2 if foe_ability == "FUR_COAT" else 1.5
        damage = (2 * user["level"] // 5 + 2) * power * attack / max(defense, 1) / 50 + 2
        if kind is not None and kind in user["types"] or user_ability in ("PROTEAN", "LIBERO"):
            damage *= 2 if user_ability == "ADAPTABILITY" else 1.5
        damage *= effective * 0.925
        if field["rain"] or field["sun"]:
            if kind == self._type["FIRE"]:
                damage *= 1.5 if field["sun"] else 0.5
            elif kind == self._type["WATER"]:
                damage *= 1.5 if field["rain"] else 0.5
        if physical and user["status"] & BURN and user_ability != "GUTS" and name != "DOUBLE_POWER_WHEN_STATUSED":
            damage *= 0.5
        if guard & (field["reflect"] if physical else field["screen"]) or guard & field["veil"]:
            damage *= 0.5
        if item.startswith("STRENGTHEN_") and kind == self._type.get(item[len("STRENGTHEN_"):].replace("FIGHT", "FIGHTING")):
            damage *= 1.2
        damage *= {"HP_DRAIN_ON_ATK": 1.3, "POWER_UP_PHYS": 1.1 if physical else 1,
                   "POWER_UP_SPEC": 1 if physical else 1.1, "POWER_UP_SE": 1.2 if effective > 1 else 1}.get(item, 1)
        damage *= (0.75 if foe_ability in ("FILTER", "SOLID_ROCK", "PRISM_ARMOR") and effective > 1 else 1) \
            * (2 if user_ability == "TINTED_LENS" and effective < 1 else 1) \
            * (0.5 if foe_ability in ("MULTISCALE", "SHADOW_SHIELD") and foe["hp"] == foe["maxHp"] else 1) \
            * (0.5 if foe_ability == "HEATPROOF" and kind == self._type["FIRE"] else 1) \
            * (1.25 if foe_ability == "DRY_SKIN" and kind == self._type["FIRE"] else 1) \
            * (0.5 if foe_ability == "ICE_SCALES" and not physical else 1) \
            * (0.5 if foe_ability == "PURIFYING_SALT" and kind == self._type["GHOST"] else 1)
        hits = 5 if name == "MULTI_HIT" and user_ability == "SKILL_LINK" else HITS.get(name, 1)
        return damage * hits, chance

    def _kind_name(self, kind):
        return next((k for k, n in self._type.items() if n == kind), "")

    def chance(self, accuracy, split, user, foe, field):
        """The chance a move of that accuracy lands: the stages of the user's
        accuracy against the foe's evasion, Compound Eyes, Hustle, No Guard."""
        if accuracy == 0 or "NO_GUARD" in (self.ability(user), self.ability(foe)):
            return 1.0
        stage = max(-6, min(6, user["stages"][STAT_ACC] - foe["stages"][STAT_EVASION]))
        chance = accuracy / 100 * ((3 + stage) / 3 if stage >= 0 else 3 / (3 - stage))
        chance *= {"COMPOUND_EYES": 1.3, "HUSTLE": 0.8 if split == PHYSICAL else 1}.get(self.ability(user), 1)
        return min(chance, 1.0)

    def power(self, name, power, user, foe, field):
        """A move's power where its effect sets it: by the HP, the weight, the
        Speed, the status of either side."""
        if name == "INCREASE_POWER_WITH_LESS_HP":
            p = 48 * user["hp"] // max(user["maxHp"], 1)
            return 200 if p < 2 else 150 if p < 5 else 100 if p < 10 else 80 if p < 17 else 40 if p < 33 else 20
        if name == "INCREASE_POWER_WITH_WEIGHT":
            return next((p for w, p in ((100, 20), (250, 40), (500, 60), (1000, 80), (2000, 100)) if foe["weight"] < w), 120)
        if name == "HEAVY_SLAM":
            ratio = user["weight"] / max(foe["weight"], 1)
            return next((p for r, p in ((5, 120), (4, 100), (3, 80), (2, 60)) if ratio >= r), 40)
        if name == "POWER_BASED_ON_LOW_SPEED":
            return min(150, 25 * self.speed(foe, field) / max(self.speed(user, field), 1) + 1)
        if name == "INCREASE_POWER_WITH_MORE_HP":
            return max(1, 150 * user["hp"] // max(user["maxHp"], 1))
        if name == "DECREASE_POWER_WITH_LESS_USER_HP":
            return max(1, 120 * foe["hp"] // max(foe["maxHp"], 1))
        if name == "INCREASE_POWER_WITH_MORE_STAT_UP":
            return 20 + 20 * sum(max(0, s - 6) for s in user["stages"][1:])
        doubled = {"DOUBLE_POWER_WHEN_STATUSED": user["status"] & STATUS_ANY,
                   "DOUBLE_DAMAGE_ON_STATUS": foe["status"] & STATUS_ANY,
                   "BURN_HIT_DOUBLE_POWER_ON_STATUS": foe["status"] & STATUS_ANY,
                   "DOUBLE_POWER_ON_POISONED": foe["status"] & POISONED,
                   "POISON_HIT_DOUBLE_POWER_ON_POISONED": foe["status"] & POISONED,
                   "DOUBLE_POWER_AND_CURE_PARALYSIS": foe["status"] & PARALYSIS,
                   "DOUBLE_POWER_HEAL_SLEEP": foe["status"] & SLEEP,
                   "DOUBLE_POWER_WHEN_BELOW_HALF": 2 * foe["hp"] <= foe["maxHp"],
                   "DOUBLE_POWER_WITHOUT_ITEM": not user["item"]}
        if doubled.get(name):
            power *= 2
        return {"POWER_BASED_ON_FRIENDSHIP": 102, "POWER_BASED_ON_LOW_FRIENDSHIP": 40, "RANDOM_POWER_10_CASES": 71,
                "RANDOM_POWER_MAYBE_HEAL": 52, "STRUGGLE": 50}.get(name, 60 if power == 1 else power)

    def weigh(self, user, foe, usable, field):
        """The exchange between `user`, with the move slots `usable`, and
        `foe`: each move's (HP it takes when it lands, its chance), its worth
        a turn (that HP, at most the foe's, by the chance, halved for a move
        that takes a turn more), the HP each of the foe's moves takes, the
        most of them (threat), the most the foe takes before each move acts
        (ahead), whether each acts before the foe's hardest hit (first), the
        foe's hits the user lasts, the best move, the turns it needs, and
        whether it wins: the foe down before the user falls (taken)."""
        moves = {slot: user["moves"][slot] for slot in usable}
        hits = {slot: self.hit(move, user, foe, field, field["sides"][1]) for slot, move in moves.items()}
        slow = {slot: 0.5 if self.record(moves[slot])[0] in SLOW and hits[slot][0] < foe["hp"] else 1 for slot in usable}
        value = {slot: min(raw, foe["hp"]) * chance * slow[slot] for slot, (raw, chance) in hits.items()}
        threats = {m: self.hit(m, foe, user, field, field["sides"][0])[0]
                   for m, pp in zip(foe["moves"], foe["pp"]) if m and pp}
        threat = max(threats.values(), default=0)
        mine, theirs = self.speed(user, field), self.speed(foe, field)
        # The most the foe can take before each move acts: its moves of a
        # higher priority, and of the same when it is as fast or faster
        # (Bullet Punch before a Pokemon faster than Scizor).
        ahead = {slot: max((hp for m, hp in threats.items() if self.record(m)[5] > self.record(move)[5]
                            or (self.record(m)[5] == self.record(move)[5] and theirs >= mine)), default=0)
                 for slot, move in moves.items()}
        # Whether each move acts before the foe's hardest hit, for the exchange.
        strongest = self.record(max(threats, key=threats.get))[5] if threats else -8
        first = {slot: self.record(move)[5] > strongest or (self.record(move)[5] == strongest and mine > theirs)
                 for slot, move in moves.items()}
        lasts = math.ceil(user["hp"] / threat) if threat else 99     # the foe's hits it takes to fall
        best = max(usable, key=lambda s: (value[s], hits[s][1])) if usable else None
        needed = (math.ceil(foe["hp"] / (hits[best][0] * slow[best])) / hits[best][1]
                  if best is not None and value[best] else 99)
        return {"moves": moves, "hits": hits, "value": value, "threats": threats, "threat": threat,
                "speed": (mine, theirs), "ahead": ahead, "first": first, "lasts": lasts, "best": best, "needed": needed,
                "wins": best is not None and self.taken(needed, threat, ahead[best], first[best]) < user["hp"],
                # the share of the foe's HP it takes before it falls: its best move each turn it acts
                "dealt": 0 if best is None or ahead[best] >= user["hp"] else
                min(1, value[best] * max(0, lasts if first[best] else lasts - 1) / max(foe["hp"], 1))}

    @staticmethod
    def taken(needed, threat, ahead, first):
        """The HP the user loses before its last needed hit lands: the foe's
        hardest hit each turn before that one, and on that turn, when the
        user moves before that hit, what the foe can still bring first
        (`ahead`: Bullet Punch); otherwise the hardest hit again."""
        turns = math.ceil(needed)
        return (turns - 1) * threat + (ahead if first else threat)

    def choose(self, user, foe, usable, field, heals=None, last=False, bench=()):
        """What the player does this turn, weighed as a player weighs it:
        ("move", slot, why) or ("item", item, why[, party slot]). `usable` are
        the move slots it may pick; `heals` the bag's items that give HP
        back, {item: count}; `last`, whether it is the last Pokemon the
        player has; `bench`, (party slot, HP, maximum HP) of the others still
        standing. In order: a move that knocks the foe out before it can
        answer; an item for a Pokemon on the bench below three quarters of its HP, while
        the foe needs four hits or more to take the one out down (Bugsy's
        Shuckle, against which a hurt Quilava is healed for his Heracross); a move
        or an item from the bag that gives HP back, when the Pokemon would
        lose the exchange below half its HP and with the HP given -- the
        foe's hardest hit taken in the turn it costs -- it wins it (or, the
        last Pokemon, lasts longer): the move first, then the smallest item
        that does; a status move -- sleep, paralysis on a faster foe,
        a burn on one that hits physically, Toxic -- on a foe with none that
        takes three turns or more to knock out while this one lasts two; a
        move raising the stat its best attack uses, or a screen against the
        foe's, while it lasts three; and otherwise the attack that takes
        most of the foe's HP on average, its chance to land counted in."""
        w = self.weigh(user, foe, usable, field)
        moves, hits, value, threats, threat, first, lasts, best, needed, wins = (
            w[k] for k in ("moves", "hits", "value", "threats", "threat", "first", "lasts", "best", "needed", "wins"))
        mine, theirs = w["speed"]
        # on the lowest roll (85 of the average's 92.5), and before the foe's
        # hits that come first take the user down
        kills = [s for s in usable if hits[s][0] * 0.85 / 0.925 >= foe["hp"] and w["ahead"][s] < user["hp"]]
        if kills:
            slot = max(kills, key=lambda s: (hits[s][1], first[s], hits[s][0]))
            return "move", slot, "knocks it out"
        hurt = [(slot, most - hp) for slot, hp, most in bench if hp and hp * 4 < 3 * most]
        items = [item for item, count in (heals or {}).items() if count and self.heal(item)]
        if hurt and items and lasts >= 4:
            slot, lost = max(hurt, key=lambda h: h[1])
            item = min(items, key=lambda i: (self.heal(i) < min(lost, 50), self.heal(i)))
            return "item", item, f"heals party slot {slot} on the bench", slot
        if not wins and 2 * user["hp"] < user["maxHp"] and threat:
            lost = user["maxHp"] - user["hp"]
            # (the move slot or None, the item or None, the HP given, the HP
            # left after the turn it takes), for each way to give HP back.
            ways = [(slot, None, min(lost, user["maxHp"] // 2)) for slot in usable
                    if self.record(moves[slot])[0] in RESTORES and (first[slot] or user["hp"] > threat)]
            ways += [(None, item, min(lost, self.heal(item) if self.heal(item) < 253 else lost))
                     for item, count in sorted((heals or {}).items()) if count and self.heal(item)]

            def turns(hp):      # whether the user wins from `hp` after the turn the HP took
                return best is not None and self.taken(needed, threat, w["ahead"][best], first[best]) < hp
            after = [(slot, item, given, user["hp"] + given - threat) for slot, item, given in ways]
            buys = [w for w in after if w[3] > 0 and (turns(w[3]) or (last and w[3] > user["hp"] - threat))]
            if buys:
                slot, item, given, _ = min(buys, key=lambda w: (w[1] is not None, not turns(w[3]), w[2]))
                if slot is not None:
                    return "move", slot, "gives HP back"
                return "item", item, f"gives {given} HP back"
        if needed >= 3 and lasts >= 2 and not foe["status"] & STATUS_ANY:
            for slot in usable:
                why = self.status_pays(moves[slot], user, foe, field, needed, theirs > mine)
                if why:
                    return "move", slot, why
        if needed >= 3 and lasts >= 3 and best is not None:
            physical = self.record(moves[best])[1] == PHYSICAL
            strongest = max(threats, key=threats.get) if threats else None
            for slot in usable:
                name = self.record(moves[slot])[0]
                raised = BOOSTS.get(name, ())
                if (STAT_ATK if physical else STAT_SPATK) in raised and \
                        user["stages"][STAT_ATK if physical else STAT_SPATK] < 8:
                    return "move", slot, "raises its attack"
                screen = {"SET_REFLECT": (PHYSICAL, "reflect"), "SET_LIGHT_SCREEN": (SPECIAL, "screen")}.get(name)
                if screen and strongest and self.record(strongest)[1] == screen[0] \
                        and not field["sides"][0] & field[screen[1]]:
                    return "move", slot, "puts up a screen"
        if best is not None and value[best]:
            return "move", best, "hits hardest"
        return "move", (usable or [0])[0], "nothing better"

    def standing(self, mon, foe, field):
        """How a Pokemon fares against `foe` with every move it has PP for:
        (whether it wins the exchange, the share of the foe's HP it takes
        before it falls, the turns it needs, negated, the hits it lasts);
        (False, 0, -99, 0) for an egg (None)."""
        if mon is None:
            return False, 0, -99, 0
        w = self.weigh(mon, foe, [i for i in range(4) if mon["moves"][i] and mon["pp"][i]], field)
        return w["wins"], w["dealt"], -w["needed"], w["lasts"]

    def rocks(self, mon, field):
        """What Stealth Rock on the player's side takes off a Pokemon coming
        in: an eighth of its HP by the Rock type's chart against it."""
        if not field.get("rocks") or not field["sides"][0] & field["rocks"]:
            return 0
        self.effects
        rate = 1
        for t in mon["types"]:
            rate *= self.chart.get((self._type["ROCK"], t), 1)
        return mon["maxHp"] * rate // 8

    def rank(self, team, foe, field):
        """The party slots of `team`, {slot: battler}, best first against `foe`:
        those that win the exchange, then by the share of its HP they take
        before they fall, the turns they need, the hits they last -- each
        with what Stealth Rock takes as it comes in; on a tie the earlier
        slot."""
        def entered(mon):
            return mon and {**mon, "hp": max(0, mon["hp"] - self.rocks(mon, field))}
        return sorted(team, key=lambda slot: (self.standing(entered(team[slot]), foe, field), -slot), reverse=True)

    def relief(self, user, foe, team, field):
        """The party slot to bring in for `user`, as a player does, or None:
        `user` loses the exchange, and the one brought in, taking as it comes
        the move the foe would use on `user`, wins it, or takes half the
        foe's HP more than `user` would before falling -- the first of
        rank() that does (a Quilava for a Geodude that Scizor's Bullet Punch
        takes down before it moves; anyone that can hurt a Larvitar for a
        Mareep whose Thunder Shock cannot)."""
        w = self.weigh(user, foe, [i for i in range(4) if user["moves"][i] and user["pp"][i]], field)
        if w["wins"] or not w["threats"]:
            return None
        aimed = max(w["threats"], key=w["threats"].get)     # what the foe would use on the one going out
        for slot in self.rank(team, foe, field):
            mon = team[slot]
            hit = self.hit(aimed, foe, mon, field, field["sides"][0])[0] if mon else 0
            left = mon["hp"] - hit - self.rocks(mon, field) if mon else 0
            standing = self.standing({**mon, "hp": left}, foe, field) if left > 0 else None
            if standing and (standing[0] or standing[1] >= w["dealt"] + 0.5 or (w["needed"] >= 99 and standing[1] > 0)):
                return slot
        return None

    def status_pays(self, move, user, foe, field, needed, slower):
        """Why a status move pays against `foe`, or None: sleep; paralysis on
        a faster foe, or one that takes four turns; a burn on a foe that hits
        harder physically; Toxic on one that takes four turns, poison five --
        each where the foe's types and ability let it, at even odds or
        better to land."""
        name, _, _, kind, accuracy, _ = self.record(move)
        status = {"STATUS_SLEEP": SLEEP, "STATUS_PARALYZE": PARALYSIS, "STATUS_BURN": BURN,
                  "STATUS_BADLY_POISON": POISONED, "STATUS_POISON": POISONED}.get(name)
        if not status or self.chance(accuracy, STATUS_MOVE, user, foe, field) < 0.55:
            return None
        ability, types = self.ability(foe), foe["types"]
        if ability in ("COMATOSE", "PURIFYING_SALT") or ability in STATUS_IMMUNE.get(status, ()):
            return None
        if move in self._powders and (self._type["GRASS"] in types or ability == "OVERCOAT"):
            return None
        if any(self.chart.get((kind, t), 1) == 0 for t in types) and kind == self._type["ELECTRIC"]:
            return None     # Thunder Wave into a Ground type
        if any(self._type[t] in types for t in TYPE_IMMUNE.get(status, ())):
            return None
        if status == SLEEP:
            return "puts it to sleep"
        if status == PARALYSIS and (slower or needed >= 4):
            return "paralyzes it"
        if status == BURN and at_stage(foe["atk"], foe["stages"][STAT_ATK]) > at_stage(foe["spAtk"], foe["stages"][STAT_SPATK]):
            return "burns it"
        if status == POISONED and needed >= (4 if name == "STATUS_BADLY_POISON" else 5):
            return "poisons it"
        return None


def forgets(scorer, species, moves):
    """Which of a Pokemon's moves -- the four it knows, then the one a
    level-up or a machine brings -- it lets go: the last in the order it
    keeps them, the strongest damaging move of each type first, strongest
    first, then its other damaging moves, then the moves that deal no
    damage; on a tie the move known before, so 4 is the new one given up."""
    power = [scorer.strength(move, species) for move in moves]
    order = sorted(range(len(moves)), key=lambda i: -power[i])
    kinds, best = set(), []
    for i in order:
        if power[i] and scorer.kind(moves[i]) not in kinds:
            kinds.add(scorer.kind(moves[i]))
            best.append(i)
    ranked = best + [i for i in order if power[i] and i not in best] + [i for i in range(len(moves)) if not power[i]]
    return ranked[-1]


def battler_hp(line):
    """The HP a battler line of markers.battle gives, "you Raichu Alolan L30
    12/80 ...": found by its shape, since a species name can be two words."""
    return int(re.search(r" (\d+)/\d+", line).group(1))


def runs(view, wild, flee):
    """Whether the player runs this turn: a wild battle, and its Pokemon
    (markers.battle's first line) under `flee` percent of its HP."""
    hp = re.search(r" (\d+)/(\d+)", view[0]) if view else None
    return bool(wild and hp and int(hp.group(1)) * 100 < flee * int(hp.group(2)))


def throws_now(hp, max_hp, hit, damaging):
    """Whether a wild Pokemon to be caught gets a ball this turn rather than
    the player's weakest damaging move: at MARGIN percent of its HP or
    under, within half again the most a move has taken off it (a critical
    hit, a high roll), or with no damaging move left to weaken it."""
    return hp * 100 <= MARGIN * max_hp or 2 * hp <= 3 * hit or not damaging


def may_run(wild, line):
    """Whether the player may still run after this battle line: a wild
    battle, until a try has failed ("You couldn't get away!") or the
    Pokemon is trapped ("You can't escape!", CantEscape: Wrap, Mean Look...,
    with no turn spent, so trying again would choose RUN for ever); it
    fights instead."""
    return (wild or line.startswith("You encountered a wild")) and "get away" not in line and "escape" not in line


def aimed_at(ram, markers, battler):
    """The foe a move of the player's `battler` (0 or 2) is scored against:
    the one its touch on the target screen goes to (Scorer.panel) --
    battler 3 for the first, battler 1 for the second -- or the other foe
    when that one is not up (no battler 3 in a single battle, or fainted)."""
    at, size = markers.address("gDiagBattlers") - 0x02000000, struct.calcsize(BATTLER)
    first, other = (3, 1) if battler == 0 else (1, 3)
    foe = struct.unpack_from(BATTLER, ram, at + first * size)
    return foe if foe[0] and foe[1] else struct.unpack_from(BATTLER, ram, at + other * size)


@savedit.tree_cache
def mon_layout():
    """What the picker reads of a BattleMon, where the battle context keeps
    the four, the weather and the two sides' screens, and their bits."""
    fields = ("species", "atk", "def", "speed", "spAtk", "spDef", "moves", "statChanges", "weight", "type1", "type2",
              "movePPCur", "level", "hp", "maxHp", "status", "item", "ability")
    names = tuple(f"__builtin_offsetof(BattleMon, {f})" for f in fields) + (
        "sizeof(BattleMon)", "__builtin_offsetof(BattleContext, battleMons)", "__builtin_offsetof(BattleContext, fieldCondition)",
        "__builtin_offsetof(BattleContext, fieldSideConditionFlags)", "FIELD_CONDITION_RAIN_ALL", "FIELD_CONDITION_SUN_ALL",
        "SIDE_CONDITION_REFLECT", "SIDE_CONDITION_LIGHT_SCREEN", "SIDE_CONDITION_AURORA_VEIL", "SIDE_CONDITION_STEALTH_ROCKS")
    values = savedit.compile_c(exprs=names, headers=savedit.LAYOUT_HEADERS + ("battle/battle.h", "constants/battle.h"))[0]
    return dict(zip(fields + ("size", "mons", "field", "sides", "rain", "sun", "reflect", "screen", "veil", "rocks"), values))


def read_mon(ram, at):
    """The battler whose BattleMon is at `at` in `ram`, as the picker weighs it."""
    layout = mon_layout()

    def word(field, size="H", k=0):
        return struct.unpack_from("<" + size, ram, at + layout[field] + struct.calcsize(size) * k)[0]
    return {"species": word("species"), "atk": word("atk"), "def": word("def"), "speed": word("speed"),
            "spAtk": word("spAtk"), "spDef": word("spDef"), "moves": [word("moves", "H", k) for k in range(4)],
            "stages": list(struct.unpack_from("<8b", ram, at + layout["statChanges"])), "weight": word("weight", "i"),
            "types": {ram[at + layout["type1"]], ram[at + layout["type2"]]},
            "pp": list(ram[at + layout["movePPCur"]:at + layout["movePPCur"] + 4]), "level": ram[at + layout["level"]],
            "hp": word("hp", "i"), "maxHp": word("maxHp", "I"), "status": word("status", "I"), "item": word("item"),
            "ability": word("ability")}


def battle_at(ram, markers, known=None):
    """Where the battle context is in `ram`, found by battler 0's BattleMon --
    the species, HP and maximum HP gDiagBattlers shows -- since it lives on
    the battle heap and no symbol points at it; `known`, the place found
    before, while battler 0's BattleMon there still matches. None when the
    pattern is not found once."""
    layout = mon_layout()
    shown = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000)
    if known is not None:
        mon = known + layout["mons"]
        if struct.unpack_from("<H", ram, mon)[0] == shown[0] and \
                struct.unpack_from("<iI", ram, mon + layout["hp"]) == shown[1:3]:
            return known
    pattern = re.escape(struct.pack("<H", shown[0])) + b".{%d}" % (layout["hp"] - 2) + re.escape(struct.pack("<iI", *shown[1:3]))
    found = [m.start() for m in re.finditer(pattern, ram, re.S) if m.start() % 4 == 0]
    return found[0] - layout["mons"] if len(found) == 1 else None


@savedit.tree_cache
def system_layout():
    """Where BattleSystem keeps its battle type, its context and its battler
    count, and the trainer battle's bit."""
    names = ("__builtin_offsetof(BattleSystem, battleType)", "__builtin_offsetof(BattleSystem, ctx)",
             "__builtin_offsetof(BattleSystem, maxBattlers)", "BATTLE_TYPE_TRAINER")
    values = savedit.compile_c(exprs=names, headers=savedit.LAYOUT_HEADERS + ("battle/battle.h", "constants/battle.h"))[0]
    return dict(zip(("type", "ctx", "count", "trainer"), values))


def trainer_battle(ram, at):
    """Whether the battle whose context is at `at` is a trainer's: its
    BattleSystem's battleType, the system found by its pointer to the
    context (and a battler count of 2 or 4); None when it is not found. The
    lines tell it only while "You encountered a wild" is still among them,
    which a battle played in two fight: steps has passed."""
    layout = system_layout()
    for m in re.finditer(re.escape(struct.pack("<I", 0x02000000 + at)), ram):
        system = m.start() - layout["ctx"]
        if m.start() % 4 == 0 and system >= 0 and struct.unpack_from("<i", ram, system + layout["count"])[0] in (2, 4):
            return bool(struct.unpack_from("<I", ram, system + layout["type"])[0] & layout["trainer"])
    return None


def battlers(ram, at):
    """The four battlers and the field, read from the battle context at `at`:
    ([battler 0..3], {rain, sun, sides, and the screens' bits})."""
    layout = mon_layout()
    mons = [read_mon(ram, at + layout["mons"] + b * layout["size"]) for b in range(4)]
    weather = struct.unpack_from("<I", ram, at + layout["field"])[0]
    return mons, {"rain": bool(weather & layout["rain"]), "sun": bool(weather & layout["sun"]),
                  "sides": struct.unpack_from("<2I", ram, at + layout["sides"]),
                  "reflect": layout["reflect"], "screen": layout["screen"], "veil": layout["veil"], "rocks": layout["rocks"]}


@savedit.tree_cache
def bag_state_at():
    """Where the battle bag keeps the state its task runs (BattleBag.state)."""
    return savedit.compile_c(exprs=("__builtin_offsetof(BattleBag, state)",),
                             headers=savedit.LAYOUT_HEADERS + ("battle_bag.h",))[0][0]


def task_data(ram, markers, func, priority):
    """Where the data of the task running `func` at `priority` is in `ram`
    (a SysTask's priority, data and func in a row; a task ended is
    cleared, and the function's address in a literal pool is no task), or
    None."""
    func = markers.address(func) & ~1
    for word in (func | 1, func):
        for m in re.finditer(re.escape(struct.pack("<I", word)), ram):
            if m.start() % 4 == 0:
                at, data = struct.unpack_from("<II", ram, m.start() - 8)
                if at == priority and 0x02000000 <= data < 0x02400000:
                    return data - 0x02000000
    return None


def bag_screen(ram, markers):
    """The battle bag's state: 1 its pockets, 2 a pocket's items, 3 an
    item's USE, anything else between them. Found through the bag's task,
    the one running ov08_02222670 at priority 100, the bag its data; None
    when there is none."""
    bag = task_data(ram, markers, "ov08_02222670", 100)
    return None if bag is None else ram[bag + bag_state_at()]


@savedit.tree_cache
def learn_layout():
    """What learn_menu reads of the battle party menu and its arguments."""
    names = ("BattlePartyMenu, args", "BattlePartyMenu, screen", "BattlePartyMenu, mons", "BattlePartyMenuMon, moves",
             "BattlePartyMenuArgs, selectedPos", "BattlePartyMenuArgs, cannotSwitch", "BattlePartyMenuArgs, mode")
    values = savedit.compile_c(exprs=tuple(f"__builtin_offsetof({n})" for n in names)
                               + ("sizeof(BattlePartyMenuMon)", "sizeof(((BattlePartyMenuMon *)0)->moves[0])"),
                               headers=savedit.LAYOUT_HEADERS + ("battle_party_menu.h",))[0]
    return dict(zip(("args", "screen", "mons", "moves", "slot", "move", "mode", "mon", "entry"), values))


def learn_menu(ram, markers):
    """The battle party menu while a level-up asks which move to forget:
    (its screen, the party slot learning, the four moves that Pokemon
    knows, the one it wants to learn), or None. Its task runs ov08_0221BE98
    at priority 0, the menu its data; in that mode (3) the menu lists the
    party by slot, selectedPos is the one learning and cannotSwitch holds
    the new move."""
    menu = task_data(ram, markers, "ov08_0221BE98", 0)
    layout = learn_layout()
    if menu is None:
        return None
    args = struct.unpack_from("<I", ram, menu + layout["args"])[0] - 0x02000000
    if not 0 <= args < len(ram) or ram[args + layout["mode"]] != LEARN_MODE:
        return None
    slot = ram[args + layout["slot"]] % 6
    mon = menu + layout["mons"] + slot * layout["mon"] + layout["moves"]
    known = [struct.unpack_from("<H", ram, mon + k * layout["entry"])[0] for k in range(4)]
    return ram[menu + layout["screen"]], slot, known, struct.unpack_from("<H", ram, args + layout["move"])[0]


@savedit.tree_cache
def pocket_items_at():
    """Where the battle bag keeps the lists it shows (BattleBag.pocketItems)."""
    return savedit.compile_c(exprs=("__builtin_offsetof(BattleBag, pocketItems)",),
                             headers=savedit.LAYOUT_HEADERS + ("battle_bag.h",))[0][0]


def use_item(core, markers, hold, item, place, frames=1500):
    """`item` from the bag's HP/PP pocket given to the Pokemon at `place` on
    the battle's party screen: BAG while the command prompt asks, the
    pocket, the item's cell -- on the pocket's first page, as the battle's
    copy of the bag lists it -- USE, and once the bag has closed on "Use on
    which Pokemon?", the Pokemon, touched again while the screen is up.
    Each touch waits for the bag's own state, as throw()'s do. True once
    the prompt has moved past the bag; False, the bag left with B, when the
    item is not on that page or the screens never closed."""
    end, seen, used = core.frames + frames, False, False
    while core.frames < end:
        prompt = markers.read(core.ram(), "gDiagBattlePrompt")
        if prompt == 1 and not seen:
            core.touch(*BAG, 6, hold)
        core.step(10, hold)
        ram = core.ram()
        if markers.read(ram, "gDiagBattlePrompt") != IN_BAG:
            if seen:
                return used
            continue
        seen = True
        bag = task_data(ram, markers, "ov08_02222670", 100)
        if bag is None:
            if used:            # the party screen USE opened, once it is up
                core.step(30, hold)
                core.touch(*PARTY[place], 6, hold)
            continue
        state = ram[bag + bag_state_at()]
        if state == 1:
            core.touch(*HP_POCKET, 6, hold)
        elif state == 2:
            listed = [struct.unpack_from("<H", ram, bag + pocket_items_at() + 4 * k)[0] for k in range(len(CELLS))]
            if item not in listed:
                break
            core.touch(*CELLS[listed.index(item)], 6, hold)
        elif state == 3:
            core.touch(*USE, 6, hold)
            used = True
    for _ in range(4):
        core.press("B", 6, hold)
        core.step(20, hold)
    return False


def throw(core, markers, hold, frames=1500):
    """The bag's first ball thrown: BAG, then the Poke Balls pocket, the
    first ball on its page and USE, each touched while the bag's state says
    that screen takes input -- again while it fades in, when a touch is not
    read, and BAG again while the command menu is still asking (its buttons
    come up a little after the prompt). True once the bag has closed on it."""
    touches, seen, end = {1: BALLS, 2: FIRST_ITEM, 3: USE}, False, core.frames + frames
    while core.frames < end:
        prompt = markers.read(core.ram(), "gDiagBattlePrompt")
        if prompt == 1 and not seen:
            core.touch(*BAG, 6, hold)
        core.step(10, hold)
        ram = core.ram()
        if markers.read(ram, "gDiagBattlePrompt") != IN_BAG:
            if seen:
                return True
            continue
        seen = True
        state = bag_screen(ram, markers)
        if state in touches:
            core.touch(*touches[state], 6, hold)
    return False


def relieve(core, markers, hold, slot, frames=900):
    """Party slot `slot` sent in for the Pokemon out: POKEMON while the
    command prompt still asks, then, once the party screen asks (prompt 9
    or 10), the slot's place on it and SHIFT. True once the prompt has
    moved past the party screen."""
    end, asked = core.frames + frames, False
    while core.frames < end:
        prompt = markers.read(core.ram(), "gDiagBattlePrompt")
        if prompt == 1 and not asked:
            core.touch(*POKEMON, 6, hold)
        elif prompt in (9, 10):
            asked = True
            core.step(20, hold)
            core.touch(*PARTY[place(core.ram(), markers, slot)], 6, hold)
            core.step(30, hold)
            core.touch(*SHIFT, 6, hold)
        elif asked:
            return True
        core.step(10, hold)
    return False


def wasted(line, foe, move):
    """The (foe species, move) this battle line shows did nothing to the
    foe -- what the type chart does not know: Levitate against a Ground
    move, an immunity an ability or a form gives -- or None. The move is the
    last the player's first Pokemon chose (ponytail: in a double battle the
    partner's is not told apart)."""
    said = ("makes Ground moves", "doesn’t affect", "doesn't affect", "is unaffected")
    if move and any(part in line for part in said) and ("opposing" in line or "wild" in line):
        return foe, move
    return None


def second_down(ram, markers):
    """Whether the player's second Pokemon in a double battle has fainted."""
    second = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000 + 2 * struct.calcsize(BATTLER))
    return second[0] != 0 and second[1] == 0


def reserves(ram, markers):
    """The party slots the party screen after a faint or a pivot may send:
    the Pokemon with HP left, by party slot, that are not already out -- in
    a double battle, not the partner still standing. place() finds one on
    the screen."""
    at, size = markers.address("gDiagBattlers") - 0x02000000, struct.calcsize(BATTLER)
    out = {mon[4] for mon in (struct.unpack_from(BATTLER, ram, at + b * size) for b in (0, 2)) if mon[0] and mon[1]}
    species = struct.unpack_from("<6H", ram, markers.address("gDiagPartySpecies") - 0x02000000)
    hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
    return [i for i in range(6) if species[i] and hp[i] and i not in out]


def reserve(ram, markers):
    """The first of reserves(), or None."""
    return next(iter(reserves(ram, markers)), None)


def bench(ram, markers, scorer):
    """The player's party as battlers the picker weighs, by party slot, read
    from the save block the field keeps (party.mons) with the HP the battle
    has (gDiagPartyHp); None for an egg. Their stages are none, their types
    the species'."""
    hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
    return [None if mon["egg"] else {**mon, "hp": hp[slot], "stages": [6] * 8, "types": scorer.types(mon["species"]),
                                     "spAtk": mon["spatk"], "spDef": mon["spdef"], "weight": 500} for slot, mon in enumerate(party_mons(ram, markers.elf))]


def place(ram, markers, slot):
    """Where the battle's party screen shows party slot `slot`: the battle
    keeps its own order (gDiagPartyOrder), which a switch changes -- the
    Pokemon that came in moves to the top."""
    order = struct.unpack_from("<6B", ram, markers.address("gDiagPartyOrder") - 0x02000000)
    return order.index(slot)


def quiet():
    """The core prints its own diagnostics to the process's stdout and stderr;
    keep ours, and Python's own stderr so a crash still says why."""
    keep, keep_err = os.dup(1), os.dup(2)
    null = os.open(os.devnull, os.O_WRONLY)
    os.dup2(null, 1)
    os.dup2(null, 2)
    sys.stderr = os.fdopen(keep_err, "w", buffering=1)
    return os.fdopen(keep, "w", buffering=1)


def fight(core, markers, hold, say, move=-1, frames=40000, scorer=None, turns=None, since=0, partner=None, flee=0,
          catch=None, shift=None):
    """Play the battle that is up until it is over or the core reaches
    `frames`, and return the last line it printed. `move` is a move slot,
    1 to 4, to use every turn; 0 the first with PP; -1 the hardest-hitting
    by the Scorer. `hold` runs before every frame, `say` gets the report.
    With `turns`, it stops as the turn after that many starts its choosing,
    the battle waiting, so what a turn did can be read (on turn one before
    the command menu is up: see below); called again, it goes on,
    and `since` (the text counter then) keeps it from saying old lines again.
    The player's own Revival Blessing opens the party menu in its revive
    mode, which takes only a fainted Pokemon: the first fainted is chosen.
    `partner`, in a double battle, says where the player's second Pokemon is
    in choosing (its BattleContext.unk_0, as gDiagBattlePrompt is the
    first's); it chooses as the first does, from its own moves. A move that
    asks for a target is aimed, every turn, by the player's first at battler
    3 and by its second at battler 1 -- at the other foe when that touch is
    not taken -- and one on the user's side at the user or its partner; each
    scores its moves against the foe it aims at (aimed_at). With
    `flee`, a percentage, the player runs from a wild Pokemon when its own has
    less than that share of its HP left, as a player walking a long route
    does rather than black out.

    With `catch`, a function of a wild Pokemon's species giving how many
    balls the player may throw at it (0: none, it is not wanted), the
    player weakens a wanted one with its weakest damaging move while the
    wild one has more than MARGIN percent of its HP and more than half again
    the most that move has taken off it, then throws them, one a turn, from
    the bag: the battle keeps a copy of the bag, so the balls thrown are
    counted here. Running, when `flee` says so, comes first.

    With `shift`, a party slot, a wild battle's first Pokemon out is
    relieved by that one at the first prompt: it fights, and the first,
    which has been out, shares what the battle pays -- the way a player
    trains a Pokemon too weak to win its own battles.

    Memory is read every four frames, but the text ring is decoded only when
    its counter has moved: decoding it every time halved the frame rate.
    """
    scorer = scorer or Scorer()
    seen, last_view, stuck, idle, last_line = set(range(since)), None, 0, 0, ""
    refused, last_slot = set(), None   # moves the game turned down this turn: Taunt, Disable, no PP
    last_count, last_asserts, restarts, decoded = 0, 0, 0, None
    last_prompt, commands, revive, use_next = None, 0, None, None
    moves_chosen, tries = {}, 0        # the move each of the player's two took, for its target screen
    wild, useless = False, set()       # useless: (foe, move) a line said did nothing
    wild_battle, weakening, foe_before, hit, thrown = False, False, None, 0, 0
    learning = None                    # the (party slot, move) a level-up's choice was said for
    found = {"at": None, "heals": None}  # the battle context (battle_at), the bag's HP items when first asked

    def is_wild():
        """Whether this is a wild battle: by the battle's own type once its
        context is found, else by its lines."""
        ram = core.ram()
        found["at"] = battle_at(ram, markers, found["at"])
        kind = trainer_battle(ram, found["at"]) if found["at"] is not None else None
        return wild_battle if kind is None else not kind
    switched = set()                   # the foes a Pokemon was brought in against (switch_to)

    def picker(ram, battler):
        """Scorer.choose for the player's `battler` (0 or 2) against the foe
        it aims at, with the moves it may pick and, for the first, the bag's
        HP items; None when the battle context is not found."""
        found["at"] = battle_at(ram, markers, found["at"])
        if found["at"] is None:
            return None
        mons, field = battlers(ram, found["at"])
        first, other = (3, 1) if battler == 0 else (1, 3)
        foe = mons[first] if mons[first]["species"] and mons[first]["hp"] else mons[other]
        user = mons[battler]
        usable = [i for i in range(4) if user["moves"][i] and user["pp"][i] and (battler or i not in refused)
                  and (foe["species"], user["moves"][i]) not in useless]
        if found["heals"] is None:
            try:
                found["heals"] = {item: in_bag(ram, markers.elf, item) for item in scorer.heal_items()}
            except SystemExit:
                found["heals"] = {}
        # The bag is kept for trainers: a wild Pokemon is run from (flee) instead.
        others = reserves(ram, markers)
        try:
            team = bench(ram, markers, scorer) if others else []
        except SystemExit:
            team = []
        return scorer.choose(user, foe, usable, field, found["heals"] if battler == 0 and not is_wild() else None,
                             not others, [(slot, team[slot]["hp"], team[slot]["maxHp"]) for slot in others
                                          if slot < len(team) and team[slot]])

    def facing(ram):
        """(the battle's four battlers, the field, the foe the player's first
        aims at), or None when the battle context is not found."""
        found["at"] = battle_at(ram, markers, found["at"])
        if found["at"] is None:
            return None
        mons, field = battlers(ram, found["at"])
        return mons, field, mons[3] if mons[3]["species"] and mons[3]["hp"] else mons[1]

    def send(ram):
        """The Pokemon the party screen after a faint or a pivot sends: of
        reserves(), the one Scorer.rank puts first against the foe the
        player's first faces; the first of them when it cannot weigh, and
        when the battle is played with a fixed move (fight:N), as a
        scenario that sets up its battle does."""
        slots = reserves(ram, markers)
        seen_now = facing(ram) if len(slots) > 1 and move < 0 else None
        if not seen_now or not seen_now[2]["hp"]:
            return slots[0]
        try:
            team = bench(ram, markers, scorer)
        except SystemExit:
            return slots[0]
        return scorer.rank({slot: team[slot] for slot in slots}, seen_now[2], seen_now[1])[0]

    def switch_to(ram):
        """Scorer.relief for the player's first in a single battle, once
        against each foe; None when nobody comes in."""
        seen_now = facing(ram)
        if not seen_now or seen_now[0][2]["species"] or seen_now[2]["species"] in switched:
            return None
        try:
            team = bench(ram, markers, scorer)
        except SystemExit:
            return None
        mons, field, foe = seen_now
        slot = scorer.relief(mons[0], foe, {slot: team[slot] for slot in reserves(ram, markers)}, field)
        if slot is not None:
            switched.add(foe["species"])
        return slot

    while core.frames < frames:
        core.step(4, hold)
        ram = core.ram()
        # A console reset clears the diagnostics with the rest of memory: the
        # line counter going backwards is how it shows. Say so, and start the
        # lines over, or everything after it looks like silence.
        count = markers.read(ram, "gDiagBattleTextCount")
        if count < last_count:
            restarts += 1
            say(f"[{core.frames}] the game restarted")
            seen = set()
            if restarts > 2:
                break
        last_count = count
        asserts = markers.read(ram, "gDiagAssertCount")
        if asserts != last_asserts:
            say(f"[{core.frames}] an assertion failed: " + markers.describe(ram).split("asserts ", 1)[1].split(" | ")[0])
            at = markers.address("gDiagLastMessage")
            if at is not None:
                say(f"[{core.frames}]   the last message asked for: row, tag, params = {struct.unpack_from('<5I', ram, at - 0x02000000)}")
                say(f"[{core.frames}]   the last message a script asked for: row, archive, member, position = "
                    f"{struct.unpack_from('<4I', ram, markers.address('gDiagLastScriptMessage') - 0x02000000)}")
                say(f"[{core.frames}]   the script running: archive, member, position = "
                    f"{struct.unpack_from('<3I', ram, markers.address('gDiagBattleScript') - 0x02000000)}")
            last_asserts = asserts
        for index, line in markers.text(ram) if count != decoded else ():
            if index not in seen and line:
                seen.add(index)
                last_line = line
                if last_slot is not None and any(word in line for word in ("can’t use", "can't use", "is disabled", "no PP left", "can’t be used")):
                    refused.add(last_slot)
                if " used " in line and not line.startswith("The foe") and "Leader" not in line:
                    refused.clear()
                if " used Revival Blessing!" in line and not line.startswith(("The opposing", "The wild")):
                    revive = core.frames
                if "But it failed" in line or "was revived" in line:
                    revive = None
                if "Use next Pok" in line:
                    use_next = core.frames
                wild_battle = wild_battle or line.startswith("You encountered a wild")
                wild = may_run(wild, line)
                useless.add(wasted(line, aimed_at(ram, markers, 0)[0], moves_chosen.get(0)))
                if not line.startswith("What will"):
                    say(f"[{core.frames}] {line}")
        decoded = count
        state = markers.read(ram, "gDiagBattleState")
        if state == EXIT:
            say(f"[{core.frames}] the battle is over")
            break
        view = markers.battle(ram)
        prompt = markers.read(ram, "gDiagBattlePrompt")
        you_hp = battler_hp(view[0]) if view and view[0].startswith("you") else 1
        # A turn's command is the first place's to give, or, with the first
        # place empty in a double battle, the second's.
        asked = partner() if you_hp == 0 and partner else prompt
        # A turn's choosing starts at 1 or, on turn one, at 2, where the
        # player waits for the AI's choice and the menu is not up yet
        # (markers.PROMPTS): `turns` stops there, where on turn one the foe
        # has often not answered yet, so a teach: or set: then is what its
        # first choice is made with (teach: asks again one that has).
        if asked in (1, 2) and last_prompt not in (1, 2):
            commands += 1
        last_prompt = asked
        if asked in (1, 2) and turns is not None and commands > turns:
            return last_line
        if prompt == 2:
            pass        # no menu to touch until the AI has chosen
        elif prompt == 1:
            if view != last_view:
                say(f"[{core.frames}]   " + "\n          ".join(view[:-1]))
                last_view = view
            at = markers.address("gDiagBattlers") - 0x02000000
            you = struct.unpack_from(BATTLER, ram, at)
            foe = struct.unpack_from(BATTLER, ram, at + struct.calcsize(BATTLER))
            if foe_before is not None:
                hit, foe_before = max(hit, foe_before - foe[1]), None
            wanted = bool(catch and wild_battle and foe[1] and thrown < catch(foe[0]))
            hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
            relieving = (shift is not None and wild_battle and you[4] != shift and hp[shift] and you[1]
                         and commands == 1 and not wanted)
            damaging = [i for i in range(4) if you[7 + i] and you[11 + i] and scorer.score(you[7 + i], you[0], foe[0]) > 0.1]
            if relieving:
                say(f"[{core.frames}] party slot {shift} relieves slot {you[4]}")
                relieve(core, markers, hold, shift)
                shift = None
            elif runs(view, wild, flee):
                core.touch(*RUN, 6, hold)
            elif move < 0 and not is_wild() and (better := switch_to(ram)) is not None:
                say(f"[{core.frames}] party slot {better} comes in for slot {you[4]}")
                relieve(core, markers, hold, better)
            elif wanted and throws_now(foe[1], foe[2], hit, damaging):
                say(f"[{core.frames}] ball {thrown + 1} of {catch(foe[0])} thrown")
                if throw(core, markers, hold):
                    thrown += 1
                else:
                    catch = None    # the bag never opened or never closed: fight on
                    say(f"[{core.frames}] the bag did not take the throw")
            else:
                weakening = wanted
                foe_before = foe[1] if wanted else None
                plan = picker(ram, 0) if move < 0 and not wanted else None
                if plan and plan[0] == "item":
                    say(f"[{core.frames}] the bag: item {plan[1]}, {plan[2]}")
                    if use_item(core, markers, hold, plan[1], place(ram, markers, plan[3] if len(plan) > 3 else you[4])):
                        found["heals"][plan[1]] -= 1
                    else:
                        found["heals"][plan[1]] = 0
                        say(f"[{core.frames}] the bag did not take it")
                else:
                    core.touch(*FIGHT, 6, hold)
            core.step(20, hold)
        elif prompt in (3, 4):
            moves = view[0].split("|")[1].split(",")
            usable = [i for i, part in enumerate(moves) if not part.strip().endswith(" 0") and i not in refused]
            slot = move - 1 if 1 <= move <= 4 and move - 1 not in refused else (usable or [0])[0]
            if move < 0 and usable:
                you = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000)
                foe = aimed_at(ram, markers, 0)
                usable = [i for i in usable if (foe[0], you[7 + i]) not in useless] or usable
                slot = max(usable, key=lambda i: scorer.score(you[7 + i], you[0], foe[0]))
                gentle = [i for i in usable if scorer.score(you[7 + i], you[0], foe[0]) > 0.1]
                plan = None if weakening else picker(ram, 0)
                if plan and plan[0] == "move" and plan[1] in usable:
                    slot = plan[1]
                    if plan[2] not in ("hits hardest", "knocks it out"):
                        say(f"[{core.frames}] move {slot + 1}: {plan[2]}")
                if weakening and gentle:
                    slot = min(gentle, key=lambda i: scorer.score(you[7 + i], you[0], foe[0]))
            last_slot = slot
            moves_chosen[0] = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000)[7 + slot]
            tries = 0       # each one's target screen starts from its own foe
            core.touch(*MOVES[slot], 6, hold)
            core.step(20, hold)
        elif revive is not None and core.frames - revive > 90:
            species = struct.unpack_from("<6H", ram, markers.address("gDiagPartySpecies") - 0x02000000)
            hp = struct.unpack_from("<6H", ram, markers.address("gDiagPartyHp") - 0x02000000)
            fainted = [i for i in range(6) if species[i] and not hp[i]]
            if fainted:
                core.touch(*PARTY[place(ram, markers, fainted[0])], 6, hold)
                core.step(30, hold)
                core.touch(*SHIFT, 6, hold)
                core.step(60, hold)
            revive = core.frames    # again later if the menu was not up yet
        elif prompt in (5, 6) or (partner and prompt not in (1, 2, 3, 4) and partner() in (5, 6)):
            battler = 0 if prompt in (5, 6) else 2
            core.touch(*scorer.panel(moves_chosen.get(battler, 0), battler, tries), 6, hold)
            core.step(20, hold)
            tries += 1
        elif partner and prompt not in (1, 2, 3, 4) and partner() == 1:
            core.touch(*FIGHT, 6, hold)
            core.step(20, hold)
        elif partner and prompt not in (1, 2, 3, 4) and partner() in (3, 4):
            second = struct.unpack_from(BATTLER, ram, markers.address("gDiagBattlers") - 0x02000000
                                        + 2 * struct.calcsize(BATTLER))
            usable = [i for i in range(4) if second[7 + i] and second[11 + i]]
            slot = move - 1 if 1 <= move <= 4 else (usable or [0])[0]
            if move < 0 and usable:
                foe = aimed_at(ram, markers, 2)
                slot = max(usable, key=lambda i: scorer.score(second[7 + i], second[0], foe[0]))
                plan = picker(ram, 2)
                if plan and plan[1] in usable:
                    slot = plan[1]
            moves_chosen[2] = second[7 + slot]
            tries = 0
            core.touch(*MOVES[slot], 6, hold)
            core.step(20, hold)
        elif use_next is not None:
            # A wild battle's lead has fainted with others left: the upper
            # button goes on with the next Pokemon; the lower one flees, and
            # the SHIFT touch of the branch below lands on it. The buttons
            # come up a while after the question is printed (sooner or later
            # with the save's text speed), and a touch there on the party
            # screen after them lands on nothing: touch it for five seconds,
            # then leave the party screen to the branch below.
            core.touch(*USE_NEXT, 6, hold)
            core.step(30, hold)
            if core.frames - use_next > 300:
                use_next = None
        elif state == BATTLE_MAIN and (you_hp == 0 or second_down(ram, markers)) and reserve(ram, markers) is not None:
            stuck += 1
            if stuck > 60:
                # The party screen after a faint, for the first of the
                # player's two or, in a double battle, the second -- also
                # at the end of a turn where a Revive or a Revival Blessing
                # gave an empty place someone to send. With no one to send
                # the place stays empty, and B below moves the text on.
                core.touch(*PARTY[place(ram, markers, send(ram))], 6, hold)
                core.step(30, hold)
                core.touch(*SHIFT, 6, hold)
                core.step(60, hold)
                stuck = 0
        elif (any(line in last_line for line in PIVOT_LINES) and not last_line.startswith(("The opposing", "The wild"))
              and reserve(ram, markers) is not None):
            # Parting Shot, U-turn, Baton Pass, Shed Tail, an Eject Button or
            # an Eject Pack has sent the player's Pokemon back, and the party
            # screen asks who comes in: the first that can, once the screen
            # is up. Until a "Go!" line the touches land on nothing.
            core.touch(*PARTY[place(ram, markers, send(ram))], 6, hold)
            core.step(30, hold)
            core.touch(*SHIFT, 6, hold)
            core.step(60, hold)
        elif "forget another move" in last_line:
            # A move learnt by level with four already known: "Forget a
            # move!", once the buttons are up; the menu that opens decides.
            core.touch(*FORGET_A_MOVE, 6, hold)
            core.step(30, hold)
        elif "should be forgotten" in last_line:
            # The menu's moves: the one forgets() lets go touched, then its
            # page's FORGET; the new one given up by the back arrow.
            menu = learn_menu(ram, markers)
            if menu and menu[0] == LEARN_LIST:
                _, slot, known, new = menu
                species = struct.unpack_from("<6H", ram, markers.address("gDiagPartySpecies") - 0x02000000)[slot]
                gone = forgets(scorer, species, known + [new])
                if (slot, new) != learning:
                    say(f"[{core.frames}] the rule lets go of {'the new move' if gone == 4 else f'move {gone + 1}'}")
                    learning = (slot, new)
                core.touch(*(LEARN_BACK if gone == 4 else LEARN_MOVES[gone]), 6, hold)
            elif menu and menu[0] == LEARN_PAGE:
                core.touch(*LEARN_FORGET, 6, hold)
            core.step(30, hold)
        elif "give up on learning" in last_line:
            # The new move given up (the back arrow above): the top button,
            # once the question has finished printing and the buttons are
            # up. B here would say no to giving it up, and the whole thing
            # would be asked again for ever.
            core.touch(*GIVE_UP, 6, hold)
            core.step(30, hold)
        elif "Will you switch" in last_line:
            core.touch(*KEEP_BATTLING, 6, hold)
            core.step(30, hold)
            last_line = ""
        else:
            stuck = 0
            idle += 1
            if idle % 8 == 0:
                # A through an evolution and a caught Pokemon's Dex entry,
                # which B would stop or never close; B declines its nickname.
                core.press("A" if state in EVOLVING or "added to the Pok" in last_line else "B", 4, hold)

    return last_line


def main():
    pin_clock()
    parser = argparse.ArgumentParser()
    parser.add_argument("save", type=Path)
    parser.add_argument("--move", type=int, default=-1,
                        help="the move slot to use, 1 to 4; 0 for the first with PP; left out, the hardest-hitting")
    parser.add_argument("--frames", type=int, default=40000)
    args = parser.parse_args()

    out = quiet()
    say = lambda line: print(line, file=out)  # noqa: E731
    markers = Markers(DIAG_ELF)
    scorer = Scorer()
    core = Core(ROM, save=args.save)
    ignore = markers.address("gDiagIgnoreCommunicationError")
    hold = [lambda c: c.poke(ignore, 1)]
    read = lambda name: markers.read(core.ram(), name)  # noqa: E731

    # Title, Continue, and the leader's lines: A until the battle is up.
    while core.frames < 6000 and read("gDiagBattleState") != BATTLE_MAIN:
        core.press("A", 6, hold)
        core.step(30, hold)
    say(f"[{core.frames}] the battle is up")
    before = None

    last_line = fight(core, markers, hold, say, args.move, args.frames, scorer)

    ram = core.ram()
    say(f"[{core.frames}] trainer items {markers.read(ram, 'gDiagAiItemCount')}")
    # After a win the gym's script hands over the badge: the leader's lines,
    # the badge, the TM. A until the field is back and the count stops moving.
    if markers.read(ram, "gDiagBattleState") == EXIT:
        try:
            held = badges(ram, DIAG_ELF)
        except SystemExit:
            held = None
        for _ in range(60):
            core.press("A", 6, hold)
            core.step(60, hold)
            try:
                now = badges(core.ram(), DIAG_ELF)
            except SystemExit:
                continue
            if held is None:
                held = now
            elif now != held:
                say(f"[{core.frames}] badges {held} -> {now}")
                held = now
        say(f"[{core.frames}] badges held: {held}")
        ram = core.ram()
    say("at the end: " + markers.describe(ram))
    if markers.read(ram, "gDiagBattleState") != EXIT:
        say("the battle did not finish; last prompt " + str(markers.read(ram, "gDiagBattlePrompt"))
            + ", last line: " + repr(last_line[:80]))
    try:
        say("party at the end:\n  " + "\n  ".join(party(ram, DIAG_ELF, sealed_mons(core, DIAG_ELF, hold))))
    except SystemExit as field_down:
        say(f"party: {field_down}")
    core.close()


if __name__ == "__main__":
    main()
