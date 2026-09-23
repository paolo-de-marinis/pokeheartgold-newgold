	.include "asm/macros.inc"

	.text

    .rodata

; The first two of battle_command.c's read-only tables. Nothing reads the first,
; and the linker drops a section nothing reads, so it has to share one with the
; table after it, which a C file would not give it. The tables after them are
; src/battle/overlay_12_0226C2F8.c.

.public sStandardBallCatchRates

sStandardBallCatchRates: ; 0x0226C2EC
	.byte 20, 15, 10, 15

.public sTrumpCardPowerTable

sTrumpCardPowerTable: ; 0x0226C2F0
	.byte 200, 80, 60, 50, 40
