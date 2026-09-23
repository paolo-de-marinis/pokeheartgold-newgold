#include "constants/pokemon.h"
#include "constants/moves.h"
	.include "asm/macros.inc"

	.text

    .rodata

; Eight of battle_command.c's read-only tables, between the ones in
; src/battle/overlay_12_0226C2F8.c and src/battle/overlay_12_0226C3E8.c. The
; first is a stat list nothing reads, which the linker would drop from a C
; file, and the last, the Safari table, starts two bytes past a word boundary,
; where no section can start, so it has to share one with Nature Power's before
; it. The six in between are left here with them.

ov12_0226C324: ; 0x0226C324
	.word NUM_BATTLE_STATS
	.word STAT_ATK
	.word STAT_DEF
	.word STAT_SPATK
	.word STAT_SPDEF
	.word STAT_SPEED

.public ov12_0226C33C
ov12_0226C33C: ; 0x0226C33C
	.word MON_DATA_MAX_HP
	.word MON_DATA_ATK
	.word MON_DATA_DEF
	.word MON_DATA_SP_ATK
	.word MON_DATA_SP_DEF
	.word MON_DATA_SPEED

.public ov12_0226C354
ov12_0226C354: ; 0x0226C354
	.word MON_DATA_MAX_HP
	.word MON_DATA_ATK
	.word MON_DATA_DEF
	.word MON_DATA_SP_ATK
	.word MON_DATA_SP_DEF
	.word MON_DATA_SPEED

.public ov12_0226C36C
ov12_0226C36C: ; 0x0226C36C
	.word NUM_BATTLE_STATS
	.word STAT_ATK
	.word STAT_DEF
	.word STAT_SPATK
	.word STAT_SPDEF
	.word STAT_SPEED

.public ov12_0226C384
ov12_0226C384: ; 0x0226C384
	.word MON_DATA_MAX_HP
	.word MON_DATA_ATK
	.word MON_DATA_DEF
	.word MON_DATA_SP_ATK
	.word MON_DATA_SP_DEF
	.word MON_DATA_SPEED

.public sLowKickDamageTable

sLowKickDamageTable:
	.short 100, 20
	.short 250, 40
	.short 500, 60
	.short 1000, 80
	.short 2000, 100
	.short 0xFFFF, 0xFFFF

.public sNaturePowerMoveTable

sNaturePowerMoveTable: ; 0x0226C3B4
	.short MOVE_EARTHQUAKE, MOVE_EARTHQUAKE, MOVE_SEED_BOMB, MOVE_SEED_BOMB, MOVE_ROCK_SLIDE, MOVE_ROCK_SLIDE
	.short MOVE_BLIZZARD, MOVE_HYDRO_PUMP, MOVE_ICE_BEAM, MOVE_TRI_ATTACK, MOVE_MUD_BOMB, MOVE_AIR_SLASH, MOVE_TRI_ATTACK

.public sSafariCatchRateStages
; Numerator, Denominator
sSafariCatchRateStages: ; 0x0226C3CE
	.byte 10, 40
	.byte 10, 35
	.byte 10, 30
	.byte 10, 25
	.byte 10, 20
	.byte 10, 15
	.byte 10, 10
	.byte 15, 10
	.byte 20, 10
	.byte 25, 10
	.byte 30, 10
	.byte 35, 10
	.byte 40, 10
