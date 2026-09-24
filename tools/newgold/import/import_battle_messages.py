#!/usr/bin/env python3
"""Write msg_0197, the battle messages, from the reference's data/text/197.txt.

Rows 0 to 1786 are the reference's own, as the revision given has them: the
engine (d0380a487) by default, New Gold with --revision ccf2c9f5. The two files
are the same; konefr changed no battle message. The reference rewrote retail's
1276 rows in place and added 511 of its own after them. Where retail has a
garbage row the reference has an empty line, and that is what is written: a
used row with no text, which msgenc encodes as an empty string (a garbage row
would come out as spaces).

After the reference's last row come the lines this port prints and the
reference has no text for (PORT_ROWS). A line about one Pokemon is three rows,
the player's, the wild one's and the opposing trainer's, because the battle
adds one or two to the row for the other side
(BattleSystem_AdjustMessageForSide); a block with fewer would print whatever
follows it.

Usage: import_battle_messages.py [--revision REV] [--write]
Without --write it reports what it would change and touches nothing.
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import gmm  # noqa: E402

BANK = 197

# Each block: why the reference has no row for it, then its rows in order.
PORT_ROWS = [
    # Wandering Spirit. The reference swaps the two abilities under an ability
    # popup and prints nothing (subscript_0517); this game has no popup, so it
    # says what happened. The player's row is the port's own; the wild and
    # opposing rows follow the reference's Mummy rows 1307 and 1308, which say
    # the same thing about one ability.
    ("wandering spirit", [
        r"{STRVAR_1 1, 0, 0}’s Ability\nbecame {STRVAR_1 5, 1, 0}!",
        r"The wild {STRVAR_1 1, 0, 0}’s Ability\nbecame {STRVAR_1 5, 1, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0}’s Ability\nbecame {STRVAR_1 5, 1, 0}!",
    ]),
    # Belch without a Berry. The reference has 1610 alone and prints it with
    # TAG_NICKNAME, so for a wild or a trainer's Pokemon it shows 1611 or 1612
    # (BattleController_BeforeMove.c, other_battle_calculators.c): its bug.
    ("belch", [
        r"{STRVAR_1 1, 0, 0} hasn’t eaten any held Berries,\nso it can’t possibly belch!",
        r"The wild {STRVAR_1 1, 0, 0} hasn’t eaten any held\nBerries, so it can’t possibly belch!",
        r"The opposing {STRVAR_1 1, 0, 0} hasn’t eaten any held\nBerries, so it can’t possibly belch!",
    ]),
    # Snow at the end of a turn. The reference's FIELD_CONDITION_SNOW_ALL
    # branch (ServerFieldConditionCheck.c) never sets the message id before
    # WEATHER_CONTINUES, so it has no row to print.
    ("snow continues", [
        r"The snow continues to fall.",
    ]),
    # Beat Up, one line a hit. The reference's Beat Up is the later games',
    # with no line for each party member, and it marks retail's 481 to 483
    # "(Unused)". This game printed one until its Beat Up became the engine's
    # too; the three rows stay, printed by nothing, because taking them out
    # would renumber every row after them.
    ("beat up", [
        r"{STRVAR_1 1, 0, 0}’s attack!",
        r"The wild {STRVAR_1 1, 0, 0}’s attack!",
        r"The foe’s {STRVAR_1 1, 0, 0}’s attack!",
    ]),
    # Quick Draw. The reference gives the ability no effect and so no line;
    # this is the Custap Berry's 1254 to 1256 naming the ability instead.
    ("quick draw", [
        r"{STRVAR_1 1, 0, 0}\ncan act faster than normal,\fthanks to its {STRVAR_1 5, 1, 0}!",
        r"The wild {STRVAR_1 1, 0, 0}\ncan act faster than normal,\fthanks to its {STRVAR_1 5, 1, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0}\ncan act faster than normal,\fthanks to its {STRVAR_1 5, 1, 0}!",
    ]),
    # Neutralizing Gas coming and going. The reference gives the ability no
    # effect and so no line; these are the later games' two, about the field
    # rather than a Pokemon, so one row each.
    ("neutralizing gas", [
        r"Neutralizing gas filled the area!",
    ]),
    ("neutralizing gas ends", [
        r"The effects of the neutralizing gas\nwore off!",
    ]),
    # Cud Chew eating a Berry again. The reference gives the ability no effect;
    # the later games show its popup, which this game has not, so the line says
    # what happened, as Harvest's "found one" does.
    ("cud chew", [
        r"{STRVAR_1 1, 0, 0} ate its\n{STRVAR_1 8, 1, 0} again!",
        r"The wild {STRVAR_1 1, 0, 0} ate its\n{STRVAR_1 8, 1, 0} again!",
        r"The opposing {STRVAR_1 1, 0, 0} ate its\n{STRVAR_1 8, 1, 0} again!",
    ]),
    # Tera Shell taking a hit at full HP. The reference gives the ability no
    # effect (BattleController_CheckTeraShell is a TODO); these are the later
    # games' line.
    ("tera shell", [
        r"{STRVAR_1 1, 0, 0} made its shell gleam!\nIt’s distorting type matchups!",
        r"The wild {STRVAR_1 1, 0, 0} made its\nshell gleam!\fIt’s distorting type matchups!",
        r"The opposing {STRVAR_1 1, 0, 0} made its\nshell gleam!\fIt’s distorting type matchups!",
    ]),
    # Battle Bond's rises. The reference shows the ability's popup and no
    # line (subscript_0515); this game has no popup, so it prints the later
    # games' line for the ability.
    ("battle bond", [
        r"{STRVAR_1 1, 0, 0} became fully charged due\nto its bond with its Trainer!",
        r"The wild {STRVAR_1 1, 0, 0} became fully charged\ndue to its bond with its Trainer!",
        r"The opposing {STRVAR_1 1, 0, 0} became fully\ncharged due to its bond with its Trainer!",
    ]),
    # Supreme Overlord coming in with fallen to count. The reference gives the
    # ability no effect; the later games show its popup and this line, which
    # here has to say it all.
    ("supreme overlord", [
        r"{STRVAR_1 1, 0, 0} gained strength\nfrom the fallen!",
        r"The wild {STRVAR_1 1, 0, 0} gained\nstrength from the fallen!",
        r"The opposing {STRVAR_1 1, 0, 0} gained\nstrength from the fallen!",
    ]),
    # Curious Medicine clearing its ally's stat changes on the way in. The
    # reference gives the ability no effect; the later games show its popup
    # and this line.
    ("curious medicine", [
        r"{STRVAR_1 1, 0, 0}’s stat changes\nwere removed!",
        r"The wild {STRVAR_1 1, 0, 0}’s stat\nchanges were removed!",
        r"The opposing {STRVAR_1 1, 0, 0}’s stat\nchanges were removed!",
    ]),
    # Symbiosis handing its item to a partner that used its own up. The
    # reference gives the ability no effect; the later games show its popup
    # and this line. Two Pokemon, so the seven rows two-Pokemon lines have;
    # only the three where both are on one side are ever printed.
    ("symbiosis", [
        r"{STRVAR_1 1, 0, 0} shared its\n{STRVAR_1 8, 1, 0} with {STRVAR_1 1, 2, 0}!",
        r"{STRVAR_1 1, 0, 0} shared its\n{STRVAR_1 8, 1, 0} with the wild {STRVAR_1 1, 2, 0}!",
        r"{STRVAR_1 1, 0, 0} shared its\n{STRVAR_1 8, 1, 0} with the opposing\f{STRVAR_1 1, 2, 0}!",
        r"The wild {STRVAR_1 1, 0, 0} shared\nits {STRVAR_1 8, 1, 0} with {STRVAR_1 1, 2, 0}!",
        r"The wild {STRVAR_1 1, 0, 0} shared\nits {STRVAR_1 8, 1, 0} with the\fwild {STRVAR_1 1, 2, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0} shared\nits {STRVAR_1 8, 1, 0} with {STRVAR_1 1, 2, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0} shared\nits {STRVAR_1 8, 1, 0} with the\fopposing {STRVAR_1 1, 2, 0}!",
    ]),
    # A Mirror Herb copying the other side's stat stages. The reference has a
    # TODO where the herb goes and so no line; this is the later games' line.
    ("mirror herb", [
        r"{STRVAR_1 1, 0, 0} used its\n{STRVAR_1 8, 1, 0} to mirror its\fopponent’s stat changes!",
        r"The wild {STRVAR_1 1, 0, 0} used its\n{STRVAR_1 8, 1, 0} to mirror its\fopponent’s stat changes!",
        r"The opposing {STRVAR_1 1, 0, 0} used\nits {STRVAR_1 8, 1, 0} to mirror its\fopponent’s stat changes!",
    ]),
    # Wonder Room and Magic Room going up and coming down. The engine leaves
    # both moves unimplemented and so has no line; these are the later
    # games', about the field, so one row each.
    ("wonder room", [
        r"It created a bizarre area in which\nDefense and Sp. Def stats are swapped!",
    ]),
    ("wonder room ends", [
        r"Wonder Room wore off, and Defense\nand Sp. Def stats returned to normal!",
    ]),
    ("magic room", [
        r"It created a bizarre area in which\nPokémon’s held items lose their effects!",
    ]),
    ("magic room ends", [
        r"Magic Room wore off, and held items’\neffects returned to normal!",
    ]),
    # Speed Swap. The engine leaves the move unimplemented; the later games'
    # line.
    ("speed swap", [
        r"{STRVAR_1 1, 0, 0} switched Speed\nwith its target!",
        r"The wild {STRVAR_1 1, 0, 0} switched\nSpeed with its target!",
        r"The opposing {STRVAR_1 1, 0, 0} switched\nSpeed with its target!",
    ]),
    # Topsy-Turvy. The engine leaves the move unimplemented; the later games'
    # line, about the target.
    ("topsy-turvy", [
        r"{STRVAR_1 1, 0, 0}’s stat changes\nwere all reversed!",
        r"The wild {STRVAR_1 1, 0, 0}’s stat\nchanges were all reversed!",
        r"The opposing {STRVAR_1 1, 0, 0}’s stat\nchanges were all reversed!",
    ]),
    # Reflect Type. The engine leaves the move unimplemented; the later
    # games' line. Two Pokemon, so the seven rows of Psych Up's 452 to 458.
    ("reflect type", [
        r"{STRVAR_1 1, 0, 0}’s type became the\nsame as {STRVAR_1 1, 1, 0}’s type!",
        r"{STRVAR_1 1, 0, 0}’s type became the same\nas the wild {STRVAR_1 1, 1, 0}’s type!",
        r"{STRVAR_1 1, 0, 0}’s type became the same\nas the opposing {STRVAR_1 1, 1, 0}’s type!",
        r"The wild {STRVAR_1 1, 0, 0}’s type became\nthe same as {STRVAR_1 1, 1, 0}’s type!",
        r"The wild {STRVAR_1 1, 0, 0}’s type became the\nsame as the wild {STRVAR_1 1, 1, 0}’s type!",
        r"The opposing {STRVAR_1 1, 0, 0}’s type became\nthe same as {STRVAR_1 1, 1, 0}’s type!",
        r"The opposing {STRVAR_1 1, 0, 0}’s type\nbecame the same as the\fopposing {STRVAR_1 1, 1, 0}’s type!",
    ]),
    # Electrify. The engine leaves the move unimplemented; the later games'
    # line, about the target.
    ("electrify", [
        r"{STRVAR_1 1, 0, 0}’s moves have\nbeen electrified!",
        r"The wild {STRVAR_1 1, 0, 0}’s moves\nhave been electrified!",
        r"The opposing {STRVAR_1 1, 0, 0}’s moves\nhave been electrified!",
    ]),
    # No Retreat. The engine leaves the move unimplemented; the later games'
    # line.
    ("no retreat", [
        r"{STRVAR_1 1, 0, 0} can no longer escape\nbecause it used No Retreat!",
        r"The wild {STRVAR_1 1, 0, 0} can no longer\nescape because it used No Retreat!",
        r"The opposing {STRVAR_1 1, 0, 0} can no longer\nescape because it used No Retreat!",
    ]),
    # Salt Cure, landing and at each turn's end. The engine leaves the move
    # unimplemented; the later games' lines.
    ("salt cure", [
        r"{STRVAR_1 1, 0, 0} is being salt cured!",
        r"The wild {STRVAR_1 1, 0, 0} is being\nsalt cured!",
        r"The opposing {STRVAR_1 1, 0, 0} is being\nsalt cured!",
    ]),
    ("salt cure damage", [
        r"{STRVAR_1 1, 0, 0} is hurt by\nSalt Cure!",
        r"The wild {STRVAR_1 1, 0, 0} is hurt by\nSalt Cure!",
        r"The opposing {STRVAR_1 1, 0, 0} is hurt by\nSalt Cure!",
    ]),
    # Syrup Bomb landing. The engine leaves the move unimplemented; the later
    # games' line.
    ("syrup bomb", [
        r"{STRVAR_1 1, 0, 0} got covered\nin sticky candy syrup!",
        r"The wild {STRVAR_1 1, 0, 0} got covered\nin sticky candy syrup!",
        r"The opposing {STRVAR_1 1, 0, 0} got covered\nin sticky candy syrup!",
    ]),
    # Tar Shot. The engine leaves the move unimplemented; the later games'
    # line.
    ("tar shot", [
        r"{STRVAR_1 1, 0, 0} became weaker\nto fire!",
        r"The wild {STRVAR_1 1, 0, 0} became\nweaker to fire!",
        r"The opposing {STRVAR_1 1, 0, 0} became\nweaker to fire!",
    ]),
    # Fairy Lock. The engine leaves the move unimplemented; the later games'
    # line, about the field, so one row.
    ("fairy lock", [
        r"No one will be able to run away\nduring the next turn!",
    ]),
    # Corrosive Gas. The engine leaves the move unimplemented; the later
    # games' line, in the seven rows of Knock Off's 552 to 558.
    ("corrosive gas", [
        r"{STRVAR_1 1, 0, 0} corroded\n{STRVAR_1 1, 1, 0}’s {STRVAR_1 8, 2, 0}!",
        r"{STRVAR_1 1, 0, 0} corroded the wild\n{STRVAR_1 1, 1, 0}’s {STRVAR_1 8, 2, 0}!",
        r"{STRVAR_1 1, 0, 0} corroded the opposing\n{STRVAR_1 1, 1, 0}’s {STRVAR_1 8, 2, 0}!",
        r"The wild {STRVAR_1 1, 0, 0} corroded\n{STRVAR_1 1, 1, 0}’s {STRVAR_1 8, 2, 0}!",
        r"The wild {STRVAR_1 1, 0, 0} corroded the\nwild {STRVAR_1 1, 1, 0}’s {STRVAR_1 8, 2, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0} corroded\n{STRVAR_1 1, 1, 0}’s {STRVAR_1 8, 2, 0}!",
        r"The opposing {STRVAR_1 1, 0, 0} corroded\nthe opposing {STRVAR_1 1, 1, 0}’s\f{STRVAR_1 8, 2, 0}!",
    ]),
    # Chilly Reception's user, before it is said to use the move. The engine
    # leaves the move unimplemented; the later games' line.
    ("chilly reception", [
        r"{STRVAR_1 1, 0, 0} is preparing to tell\na chillingly bad joke!",
        r"The wild {STRVAR_1 1, 0, 0} is preparing to\ntell a chillingly bad joke!",
        r"The opposing {STRVAR_1 1, 0, 0} is preparing\nto tell a chillingly bad joke!",
    ]),
    # Spectral Thief taking its target's raised stages. The engine leaves the
    # move unimplemented; the later games' line.
    ("spectral thief", [
        r"{STRVAR_1 1, 0, 0} stole the target’s\nboosted stats!",
        r"The wild {STRVAR_1 1, 0, 0} stole the\ntarget’s boosted stats!",
        r"The opposing {STRVAR_1 1, 0, 0} stole the\ntarget’s boosted stats!",
    ]),
    # Court Change. The engine leaves the move unimplemented; the later
    # games' line.
    ("court change", [
        r"{STRVAR_1 1, 0, 0} swapped the battle effects\naffecting each side of the field!",
        r"The wild {STRVAR_1 1, 0, 0} swapped the battle\neffects affecting each side of the field!",
        r"The opposing {STRVAR_1 1, 0, 0} swapped the\nbattle effects affecting each side\fof the field!",
    ]),
    # Telekinesis lifting its target and letting it down. The engine leaves
    # the move unimplemented; the later games' lines.
    ("telekinesis", [
        r"{STRVAR_1 1, 0, 0} was hurled\ninto the air!",
        r"The wild {STRVAR_1 1, 0, 0} was hurled\ninto the air!",
        r"The opposing {STRVAR_1 1, 0, 0} was hurled\ninto the air!",
    ]),
    ("telekinesis ends", [
        r"{STRVAR_1 1, 0, 0} was freed\nfrom the telekinesis!",
        r"The wild {STRVAR_1 1, 0, 0} was freed\nfrom the telekinesis!",
        r"The opposing {STRVAR_1 1, 0, 0} was freed\nfrom the telekinesis!",
    ]),
    # Beak Blast heating up as the turn begins. The engine leaves the move
    # unimplemented; the later games' line.
    ("beak blast", [
        r"{STRVAR_1 1, 0, 0} started heating\nup its beak!",
        r"The wild {STRVAR_1 1, 0, 0} started heating\nup its beak!",
        r"The opposing {STRVAR_1 1, 0, 0} started\nheating up its beak!",
    ]),
    # Shell Trap set as the turn begins, and left unsprung. The engine leaves
    # the move unimplemented; the later games' lines.
    ("shell trap", [
        r"{STRVAR_1 1, 0, 0} set a shell trap!",
        r"The wild {STRVAR_1 1, 0, 0} set\na shell trap!",
        r"The opposing {STRVAR_1 1, 0, 0} set\na shell trap!",
    ]),
    ("shell trap failed", [
        r"{STRVAR_1 1, 0, 0}’s shell trap\ndidn’t work!",
        r"The wild {STRVAR_1 1, 0, 0}’s shell trap\ndidn’t work!",
        r"The opposing {STRVAR_1 1, 0, 0}’s shell\ntrap didn’t work!",
    ]),
    # Teatime. The engine leaves the move unimplemented; the later games'
    # line, about the field, so one row.
    ("teatime", [
        r"It’s teatime! Everyone dug in to\ntheir Berries!",
    ]),
    # Commander taking a Tatsugiri into its Dondozo's mouth. The engine
    # declares the ability and gives it nothing; the later games' line
    # (Pokemon Showdown's transcription of it, the one text source found:
    # neither Bulbapedia nor Pokemon Central quotes it). Seven rows, as for
    # any line about two Pokemon; the pair is always on one side, so only the
    # player's, the wild and the opposing pairs are ever shown.
    ("commander", [
        r"{STRVAR_1 1, 0, 0} was swallowed\nby {STRVAR_1 1, 1, 0} and became\f{STRVAR_1 1, 1, 0}’s commander!",
        r"{STRVAR_1 1, 0, 0} was swallowed by\nthe wild {STRVAR_1 1, 1, 0} and\fbecame the wild\n{STRVAR_1 1, 1, 0}’s commander!",
        r"{STRVAR_1 1, 0, 0} was swallowed by\nthe opposing {STRVAR_1 1, 1, 0} and\fbecame the opposing\n{STRVAR_1 1, 1, 0}’s commander!",
        r"The wild {STRVAR_1 1, 0, 0}\nwas swallowed by {STRVAR_1 1, 1, 0} and\fbecame {STRVAR_1 1, 1, 0}’s commander!",
        r"The wild {STRVAR_1 1, 0, 0}\nwas swallowed by the wild\f{STRVAR_1 1, 1, 0} and became the\nwild {STRVAR_1 1, 1, 0}’s commander!",
        r"The opposing {STRVAR_1 1, 0, 0}\nwas swallowed by {STRVAR_1 1, 1, 0} and\fbecame {STRVAR_1 1, 1, 0}’s commander!",
        r"The opposing {STRVAR_1 1, 0, 0}\nwas swallowed by the opposing\f{STRVAR_1 1, 1, 0} and became the\nopposing {STRVAR_1 1, 1, 0}’s commander!",
    ]),
    # Ally Switch. The engine leaves the move unimplemented; the later games'
    # line, about two Pokemon, so the seven rows TAG_NICKNAME_NICKNAME picks
    # from by the two sides (BattleSystem_AdjustMessageForSide), though the
    # two are always on one.
    ("ally switch", [
        r"{STRVAR_1 1, 0, 0} and {STRVAR_1 1, 1, 0}\nswitched places!",
        r"{STRVAR_1 1, 0, 0} and the wild {STRVAR_1 1, 1, 0}\nswitched places!",
        r"{STRVAR_1 1, 0, 0} and the opposing {STRVAR_1 1, 1, 0}\nswitched places!",
        r"The wild {STRVAR_1 1, 0, 0} and {STRVAR_1 1, 1, 0}\nswitched places!",
        r"The wild {STRVAR_1 1, 0, 0} and\nthe wild {STRVAR_1 1, 1, 0} switched places!",
        r"The opposing {STRVAR_1 1, 0, 0} and {STRVAR_1 1, 1, 0}\nswitched places!",
        r"The opposing {STRVAR_1 1, 0, 0} and\nthe opposing {STRVAR_1 1, 1, 0} switched places!",
    ]),
]


def rows(revision):
    texts = gmm.reference_rows(revision, BANK)
    if texts is None:
        raise SystemExit(f"{revision} has no data/text/{BANK:03d}.txt")
    for _, block in PORT_ROWS:
        texts += block
    return [gmm.new_row(BANK, index, text) for index, text in enumerate(texts)]


def port_row(name):
    """The index of a port block's first row, as the scripts and C use it."""
    first = len(gmm.reference_rows(gmm.ENGINE, BANK))
    for block_name, block in PORT_ROWS:
        if block_name == name:
            return first
        first += len(block)
    raise KeyError(name)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--revision", default=gmm.ENGINE)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()

    new = rows(args.revision)
    old = gmm.read(BANK)
    changed = [row["index"] for row in new
               if row["index"] >= len(old) or (old[row["index"]]["text"], old[row["index"]]["context"])
               != (row["text"], row["context"])]
    print(f"msg_{BANK:04d}: {len(old)} -> {len(new)} rows, {len(changed)} written differently")
    if args.write:
        gmm.write(BANK, new)


if __name__ == "__main__":
    main()
