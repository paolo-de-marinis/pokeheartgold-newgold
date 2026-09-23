# Save layout

What a save is in this port, the layouts the game reads, why they carry no
version number, and what the next change to the save has to do.

## What the game looks for

Each half of the flash (0 and 0x40000) holds the region SaveData_InitSubstructs
lays out: 42 blocks in two slots, each block its sizeof rounded up to a word
with a CRC word after it. The first slot is SAVE_SYSINFO to SAVE_TRAINER_HOUSE;
the second, on the next 0x100, is SAVE_PCSTORAGE, thirty boxes. Each slot ends
in a 16-byte footer, `struct SaveChunkFooter`: the save counter, the slot's
size, SAVE_CHUNK_MAGIC (0x20060623, HeartGold's), the slot's number and the
slot's CRC. The chunks past the region (gExtraSaveChunkHeaders) have footers
of their own (CreateChunkFooter) and are not part of the layout.

The game finds a save by those footers alone. ValidateSaveSectorFooter looks
at the offset the layout gives and wants the size the layout gives, the magic,
the slot number and the CRC. Nothing in a save says which layout wrote it: the
layout is told by where the footers are and what size they give.

## The layouts it reads

| Layout | First slot | PC's slot | Written by |
| --- | --- | --- | --- |
| before the DNA Splicers | 64140 bytes | at 0xFB00 | this port before 34eb81136 |
| now | 65088 bytes | at 0xFF00 | this port since 34eb81136 |

They differ in one block: SAVE_MISC is SAVE_MISC_LEGACY_SIZE (0x2E0,
HeartGold's) in the first and has hg-engine's storedMons[4] and isMonStored[4]
after that in the second, 948 bytes more. The PC's slot is the same 124156
bytes in both. Nothing older is read: a HeartGold save (eighteen boxes) or one
from this port before thirty boxes (668543b5d) does not load.

Save_GetSaveFilesStatus checks both halves as "now". Only when neither reads as
"now" does it look for the footers where the older layout put them
(Save_GetLegacySlotSpecs) and set legacyMiscLayout. Save_LoadDynamicRegion
then reads that save through Save_LoadLegacySlots: the PC's slot from its old
place to its new one, the first slot as it was, each checked against its own
footer, and Save_ConvertLegacyFirstSlot moves the blocks after SAVE_MISC up and
clears the new fields. Both halves are marked for a full write, so the next two
saves put everything in the "now" layout. After the first of them the flash
holds one half of each; the "now" half reads, the older one reads as a bad
half, and the game loads the "now" half as it loads any save with one good
half.

## Why there is no version number yet

The reference has none. hg-engine's ALLOW_SAVE_CHANGES, on at d0380a487 and
at ccf2c9f5, grows the misc block (and EXPAND_PC_BOXES the PC) and keeps
HeartGold's footer check as it is, magic and all: a save from before does not
load there, and its include/config.h says only that the change breaks
compatibility with PKHeX. The game's own save has no field to spare. The footer's
five fields are all checked, and the misc block's expansion is the reference's
struct to the byte (0x2E0 + 4 * 0xEC + 4). A field added to hold a version
would itself be a third layout, which the game, savedit and saveui would all
have to read.

The one place a version fits without a byte more is the footer's magic. Giving
today's saves a new one would add a third footer to accept and would tell
apart nothing the sizes do not: the two layouts differ in the first slot's
size, which is where the game looks. So SAVE_CHUNK_MAGIC is version 0 and
stands for both layouts above, told apart by size as now, and the version
starts with the next change. test_save_legacy pins the slot sizes of "now", so
a change that moves them fails there and points here.

## What the next change to the save must do

This is any change to a block's size, to the blocks' order or slots, or to
what a block's bytes mean (a field moved, reused or read differently), whether
it is the engine's or konefr's.

1. The new layout gets its own footer magic, a new date in SAVE_CHUNK_MAGIC's
   style. SaveSlot_BuildFooter writes it for the region's two slots. The
   extra chunks keep SAVE_CHUNK_MAGIC unless the change is to one of them.
2. ValidateSaveSectorFooter takes the magic of the layout it checks: the new
   one for the new layout, SAVE_CHUNK_MAGIC for "now" and "before the DNA
   Splicers". A change that keeps every size is told apart by the magic alone.
3. legacyMiscLayout becomes a layout number, and Save_GetLegacySlotSpecs one
   function per older layout. Save_GetSaveFilesStatus tries the layouts newest
   first and stops at the first one a half reads as, so a flash with one half
   of each still loads its newer half.
4. An older save is converted one step at a time, oldest first: "before the
   DNA Splicers" to "now" (Save_ConvertLegacyFirstSlot), then "now" to the new
   layout. Each step is one function over the region, compiled natively in a
   test as test_save_legacy does.
5. What the new layout adds starts as a new game has it: cleared, or set by
   the block's init function.
6. Both halves are marked for a full write, as Save_LoadLegacySlots does.
7. The pin in test_save_legacy takes the new layout's slot sizes.
8. savedit and saveui learn the new layout (below).
9. A save of each older layout is loaded in the emulator, continued, saved
   and loaded again, as 34eb81136 did with ~/hgss-saves/gyms/falkner.sav.

## How savedit and saveui read both layouts

savedit measures the layout from the build (main.sbin and main.elf), as the
game computes it at boot. `blocks(build)` is SaveData_InitSubstructs, and
`blocks(build, legacy=True)` is the same with SAVE_MISC at
SAVE_MISC_LEGACY_SIZE, which is Save_GetLegacySlotSpecs's layout; `slot_specs`
gives the two slots of either. `Save(path)` tries "now" first and, when
neither half is valid, "before the DNA Splicers"; `Save.legacy` says which it
found, and the newest valid half is the one opened. A save in the older
layout is read and written in that layout: `reseal` writes its blocks' CRCs
and its footers with its own sizes, and the game converts it the next time it
loads it. saveui opens saves through `Save` and shows the older layout as
"Formato: quello di prima dei DNA Splicers" (`info`'s `legacy`).

For the next layout, `legacy` becomes the layout. Each older one is the
build's sizes with the blocks it had at other sizes put back
({SAVE_MISC: SAVE_MISC_LEGACY_SIZE} for "before the DNA Splicers"), and each
has the magic its footers carry. `Save` tries them newest first, as the game
does, `valid` checks the magic of the layout it tries, and saveui names the
layout rather than showing a yes or no. A change that keeps every size but
changes what bytes mean also needs savedit's readers of that block to follow
the layout.
