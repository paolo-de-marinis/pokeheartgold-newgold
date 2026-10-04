# Save layout

What a save is in this port, the layouts the game reads, how it tells them
apart, and what the next change to the save has to do.

## What the game looks for

Each half of the flash (0 and 0x40000) holds the region SaveData_InitSubstructs
lays out: 42 blocks in two slots, each block its sizeof rounded up to a word
with a CRC word after it. The first slot is SAVE_SYSINFO to SAVE_TRAINER_HOUSE;
the second, on the next 0x100, is SAVE_PCSTORAGE, thirty boxes. Each slot ends
in a 16-byte footer, `struct SaveChunkFooter`: the save counter, the slot's
size, a magic, the slot's number and the slot's CRC. The chunks past the
region (gExtraSaveChunkHeaders) have footers of their own (CreateChunkFooter),
keep SAVE_CHUNK_MAGIC (0x20060623, HeartGold's), and are not part of the
layout.

The game finds a save by those footers alone. ValidateSaveSectorFooter looks
at the offset the layout gives and wants the size the layout gives, the
layout's magic, the slot number and the CRC. The layout is told by where the
footers are, what size they give and which magic they carry.

## The layouts it reads

`enum SaveLayout` (include/save.h), the newest first:

| Layout | First slot | PC's slot | Magic | Written by |
| --- | --- | --- | --- | --- |
| SAVE_LAYOUT_NOW | 65676 bytes | at 0x10100 | SAVE_CHUNK_MAGIC_BERRY_POCKET (0x20260925) | this port since TM93 to TM148 |
| SAVE_LAYOUT_BEFORE_TM_POCKET | 65456 bytes | at 0x10000 | SAVE_CHUNK_MAGIC_BERRY_POCKET | this port from the Dex recording the forms until then |
| SAVE_LAYOUT_BEFORE_DEX_FORMS | 65232 bytes | at 0xFF00 | SAVE_CHUNK_MAGIC_BERRY_POCKET | this port from the Berries pocket holding every Berry until then |
| SAVE_LAYOUT_BEFORE_BERRY_POCKET | 65088 bytes | at 0xFF00 | SAVE_CHUNK_MAGIC | this port from 34eb81136 until then |
| SAVE_LAYOUT_BEFORE_DNA_SPLICERS | 64140 bytes | at 0xFB00 | SAVE_CHUNK_MAGIC | this port before 34eb81136 |

Each differs from the next newer one in one block, which grew at one place
(Save_LayoutGrowth):

- before TM93 to TM148, SAVE_BAG's TMs/HMs pocket had HeartGold's 101 slots
  (NUM_BAG_TMS_HMS_LEGACY); now it has 156 (92 + 56 + 8), so the mail and
  every pocket after it, and every block after the bag, sit 220 bytes
  further on. The pocket's machines were hg-engine's, so this change also
  rewrites what the pocket holds (Bag_ConvertLegacyMachines, below);
- before the Dex recorded the forms, SAVE_POKEDEX ended at HeartGold's
  record, without formsSeen and formsCaught after it (a bit a species from
  DEX_FIRST_FORM, the Galarian Slowpoke, to the last form), 224 bytes less;
- before the Berries pocket held every Berry, SAVE_BAG's Berries pocket had
  HeartGold's 64 slots (NUM_BAG_BERRIES_LEGACY); now it has 100, so the balls
  and the battle items after it, and every block after the bag, sit 144 bytes
  further on;
- before the DNA Splicers, SAVE_MISC was SAVE_MISC_LEGACY_SIZE (0x2E0,
  HeartGold's), without hg-engine's storedMons[4] and isMonStored[4] after it,
  948 bytes less.

The PC's slot is the same 124156 bytes in all five. Nothing older is read: a
HeartGold save (eighteen boxes) or one from this port before thirty boxes
(668543b5d) does not load. The PC's slot is also at the same place in the
layouts before the Dex's record and before the Berries pocket: only the magic
tells their footers apart, which is why the first of them has one of its
own. The two layouts after it keep that magic: each moved the PC's slot
0x100 further on and changed the first slot's size, so the footers' places
and sizes tell them apart from the one before.

Save_GetSaveFilesStatus checks both halves as SAVE_LAYOUT_NOW. Only when
neither reads does it try the older layouts, newest first, each where it put
its footers and with its magic (Save_GetLayoutSlotSpecs), and it stops at the
first one a half reads as, keeping it in saveLayout. Save_LoadDynamicRegion
then reads that save through Save_LoadLegacySlots: the PC's slot from its old
place to its new one, the first slot as it was, each checked against its own
footer, and Save_ConvertFirstSlot makes the first slot this layout's one change
at a time, the oldest first, each opening its bytes clear where they go and
moving everything after them up; a place in a block counts what the
changes still to come add before it, in an earlier block or earlier in its
own. The TMs/HMs pocket's change then makes the machines it holds New
Gold's: each of hg-engine's becomes New Gold's machine with the same move
(LegacyMachineToItem, from its place in hg-engine's numbering), or goes
where none has it, one of each and a TM once, and the pocket is sorted.
Both halves are marked for a full write, so
the next two saves put everything in the layout of now. After the first of
them the flash holds one half of each; the newer half reads, the older one
reads as a bad half, and the game loads the newer half as it loads any save
with one good half.

## Bits the port keeps in HeartGold's fields

One change used bits no save had ever set, and needed no layout: the two top
bits of each byte of the Dex's caughtLanguages (DEX_SEEN_AS_FORM_ONLY and
DEX_FORM_SEEN_FIRST, include/pokedex.h), which shows which look the Dex draws
a species in. HeartGold keeps a language a bit there in the six low bits
(LanguageToDexFlag) and never sets the two above them, so every save from
before has them clear, and clear is what such a save meant: the species
drawn as itself. A save made before them where a species was seen only as
its forms draws it as itself, as it did then. A field reused this way is an
exception to the rule below only because a save from before reads the same
through it; anything else is a new layout.

## Why the magic, and not a version number

The reference has no version. hg-engine's ALLOW_SAVE_CHANGES, on at d0380a487
and at ccf2c9f5, grows the misc block (and EXPAND_PC_BOXES the PC) and keeps
HeartGold's footer check as it is, magic and all: a save from before does not
load there, and its include/config.h says only that the change breaks
compatibility with PKHeX. The game's own save has no field to spare. The
footer's five fields are all checked, and a field added to hold a version
would itself be a layout, which the game, savedit and saveui would all have
to read. The one place a version fits without a byte more is the footer's
magic: SAVE_CHUNK_MAGIC stands for the two oldest layouts, told apart by
size, and SAVE_CHUNK_MAGIC_BERRY_POCKET for the two newest, told apart by
size and by where the PC's slot is. A layout needs a magic of its own only
where both its slots would sit where the layout before put them: then
nothing else tells their footers apart. test_save_legacy pins every layout's
slot sizes and the magics, so a change that moves them fails there and points
here.

## What the next change to the save must do

This is any change to a block's size, to the blocks' order or slots, or to
what a block's bytes mean (a field moved, reused or read differently), whether
it is the engine's or konefr's.

1. Where the new layout's two slots sit where the one it replaces put them
   (the PC's slot at the same 0x100, the first slot's footer at the same
   place), it gets its own footer magic, a new date in SAVE_CHUNK_MAGIC's
   style, and SaveSlot_BuildFooter writes it for the region's two slots.
   Where the change moves the PC's slot, the footers' places tell the two
   layouts apart and the magic stays: ValidateSaveSectorFooter is main's code,
   and every byte of main is the boot's arena (tests/newgold/test_heaps.py),
   which is how the Dex's record of the forms kept the Berries pocket's
   magic. The extra chunks keep SAVE_CHUNK_MAGIC unless the change is to one
   of them.
2. SAVE_LAYOUT_NOW is the new layout, and the one it replaces gets a name of
   its own after it in `enum SaveLayout`, before the older ones.
   ValidateSaveSectorFooter gives each layout its magic
   (SAVE_CHUNK_MAGIC_BERRY_POCKET to SAVE_LAYOUT_BEFORE_DEX_FORMS and the
   newer, SAVE_CHUNK_MAGIC to the older ones).
3. Save_LayoutGrowth learns the change: the block, where in it the new bytes
   start, and how many. A change that is not bytes added at one place needs a
   step of its own in Save_ConvertFirstSlot, as the TMs/HMs pocket's has.
4. What the new layout adds starts as a new game has it: clear, or set by the
   block's init function after the conversion.
5. The pins in test_save_legacy take the new layout's slot sizes, and its
   native test the new step.
6. savedit and saveui learn the new layout (below).
7. A save of each older layout is loaded in the emulator, continued, saved
   and loaded again, as 34eb81136 did with ~/hgss-saves/gyms/falkner.sav,
   the Berries pocket's change did with a copy of route29-official.sav given
   balls, battle items and Berries, the Dex's record of the forms did with a
   save of the layout before it, and the TMs/HMs pocket's did with a copy of
   the playthrough chain's Goldenrod save given hg-engine's machines.

## How savedit and saveui read every layout

savedit measures the layout from the build (main.sbin and main.elf), as the
game computes it at boot. `blocks(build)` is SaveData_InitSubstructs, and
`blocks(build, layout)` the same for an older layout: the build's sizes less
what every change since added (`layout_growth`, Save_LayoutGrowth); `slot_specs`
gives the two slots of any. `Save(path)` tries the layouts newest first, as
the game does, `valid` checking the magic of the layout it tries; `Save.layout`
says which one read (`Save.legacy`, whether it is an older one), and the
newest valid half is the one opened. A save in an older layout is read and
written in that layout: `reseal` writes its blocks' CRCs and its footers with
its own sizes and magic, and the game converts it the next time it loads it.
The bag's readers follow the layout: `pockets(layout)` has the TMs/HMs pocket
at 101 slots before it grew and the Berries pocket at 64 before that one
grew, and each pocket after a smaller one that much earlier. A save from
before the Dex recorded the forms has no record to read (`dex(save)` gives
none) or write (`set_form_record` refuses); `Save.has_form_record` says
which.
saveui opens saves through `Save` and names an older layout on the save's
page ("Formato").
