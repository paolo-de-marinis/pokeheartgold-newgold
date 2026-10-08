#include "constants/pokemon.h"
#include "constants/sndseq.h"
	.include "asm/macros.inc"
	.include "overlay_12_battle_controller_opponent.inc"
	.include "global.inc"

.public ov12_0225FD14
.public ov12_0225FF80
.public ov12_0225FFDC
.public ov12_02260030
.public ov12_022600F0
.public ov12_0226037C
.public ov12_02260418
.public ov12_02260584
.public ov12_022605D0
.public ov12_02260614
.public ov12_02260668
.public ov12_022609F8
.public ov12_02260B30
.public ov12_02260BA0
.public ov12_02260C58
.public ov12_02260CDC
.public ov12_02260D28
.public ov12_02260D84
.public ov12_02261284
.public ov12_022612A4
.public ov12_02261390
.public ov12_02261464
.public ov12_02261544
.public ov12_022615F0
.public ov12_02261928
.public ov12_022619E4
.public ov12_02261AD4
.public ov12_02261B2C
.public ov12_02261B80
.public ov12_02261CA8
.public ov12_02261D30
.public ov12_02261DC8
.public ov12_02261EB8
.public ov12_02261ED4
.public ov12_02261EF0
.public ov12_02261F38
.public ov12_0226D010
.public ov12_0226D120
.public ov12_0226D128
.public ov12_0226D140
.public ov12_0226D141
.public ov12_0226D15A
.public ov12_0226D1E8
.public ov12_0226D1EA
.public ov12_02259928
.public ov12_02259944
.public ov12_02259968
.public ov12_02259BA8
.public ov12_02259D48
.public ov12_02259F30
.public ov12_0225A018
.public ov12_0225A07C
.public ov12_0225A2A0
.public ov12_0225A334
.public ov12_0225A37C
.public ov12_0225A414
.public ov12_0225A4DC
.public ov12_0225A524
.public ov12_0225A604
.public ov12_0225A674
.public ov12_0225A700
.public ov12_0225A7AC
.public ov12_0225A818
.public ov12_0225A85C
.public ov12_0225A8C4
.public ov12_0225A914
.public ov12_0225A9B0
.public ov12_0225A9E0
.public ov12_0225AA6C
.public ov12_0225AAE0
.public ov12_0225ABB8
.public ov12_0225ABE8
.public ov12_0225AC1C
.public ov12_0225ACB0
.public ov12_0225ACE8
.public ov12_0225AD44
.public ov12_0225AD9C
.public ov12_0225ADF4
.public ov12_0225AE48
.public ov12_0225AEA0
.public ov12_0225AED8
.public ov12_0225AF74
.public ov12_0225B028
.public ov12_0225B060

	.text

	thumb_func_start ov12_02258D74
ov12_02258D74: ; 0x02258D74
	push {r3, r4, r5, lr}
	add r5, r1, #0
	mov r1, #0x6b
	mov r0, #5
	lsl r1, r1, #2
	bl Heap_Alloc
	add r4, r0, #0
	mov r2, #0x6b
	mov r0, #0
	add r1, r4, #0
	lsl r2, r2, #2
	bl MIi_CpuClearFast
	mov r0, #0x65
	ldrb r1, [r5]
	lsl r0, r0, #2
	strb r1, [r4, r0]
	ldrb r1, [r5, #1]
	add r0, r0, #1
	strb r1, [r4, r0]
	mov r0, #0xb4
	mov r1, #5
	bl NARC_New
	mov r1, #0x69
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov12_02258D74

	thumb_func_start ov12_02258DB0
ov12_02258DB0: ; 0x02258DB0
	push {r4, r5, r6, lr}
	sub sp, #0x28
	add r5, r0, #0
	add r4, r1, #0
	add r6, r2, #0
	bl BattleSystem_GetBattleType
	mov r1, #0x22
	lsl r1, r1, #4
	tst r0, r1
	bne _02258E48
	sub r1, #0x8b
	ldrb r1, [r4, r1]
	mov r0, #1
	tst r0, r1
	beq _02258DDC
	add r0, r5, #0
	bl BattleSystem_GetBattleType
	mov r1, #1
	tst r0, r1
	beq _02258E48
_02258DDC:
	ldr r0, _02258E4C ; =0x00000195
	ldr r1, _02258E50 ; =ov12_0226D120
	ldrb r2, [r4, r0]
	sub r0, r0, #1
	ldrb r1, [r1, r2]
	str r1, [sp]
	mov r1, #5
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	ldrb r0, [r4, r0]
	str r0, [sp, #0xc]
	add r0, r5, #0
	str r6, [sp, #0x10]
	bl BattleSystem_GetSpriteSystem
	str r0, [sp, #0x1c]
	add r0, r5, #0
	bl BattleSystem_GetPaletteData
	str r0, [sp, #0x20]
	mov r0, #0
	str r0, [sp, #0x18]
	mov r0, #1
	str r0, [sp, #0x14]
	add r0, sp, #0
	bl ov07_02233DB8
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	mov r1, #0x64
	bl ov07_022344C4
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	mov r1, #2
	bl ov07_022344D0
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	mov r1, #0
	bl ov07_0223449C
	add r4, #0x88
	ldr r0, [r4]
	mov r1, #0
	bl ov07_022344C0
_02258E48:
	add sp, #0x28
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02258E4C: .word 0x00000195
_02258E50: .word ov12_0226D120
	thumb_func_end ov12_02258DB0

	thumb_func_start ov12_02258E54
ov12_02258E54: ; 0x02258E54
	push {r3, lr}
	add r2, r1, #0
	add r2, #0x94
	ldrb r2, [r2]
	cmp r2, #0
	beq _02258E76
	mov r2, #0x6a
	mov r3, #0
	lsl r2, r2, #2
	strb r3, [r1, r2]
	add r2, r1, #0
	add r2, #0x94
	ldrb r2, [r2]
	lsl r3, r2, #2
	ldr r2, _02258E78 ; =ov12_0226D010
	ldr r2, [r2, r3]
	blx r2
_02258E76:
	pop {r3, pc}
	.balign 4, 0
_02258E78: .word ov12_0226D010
	thumb_func_end ov12_02258E54

	thumb_func_start ov12_02258E7C
ov12_02258E7C: ; 0x02258E7C
	push {r4, lr}
	add r4, r1, #0
	cmp r2, #2
	beq _02258E8C
	add r0, r4, #0
	add r0, #0x28
	bl BattleHpBar_FreeResources
_02258E8C:
	ldr r0, [r4, #0x18]
	cmp r0, #0
	beq _02258E96
	bl Sprite_DeleteAndFreeResources
_02258E96:
	add r0, r4, #0
	bl ov12_02262014
	mov r0, #0x69
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl NARC_Delete
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov12_02258E7C

	thumb_func_start ov12_02258EB0
ov12_02258EB0: ; 0x02258EB0
	bx lr
	.balign 4, 0
	thumb_func_end ov12_02258EB0

	thumb_func_start ov12_02258EB4
ov12_02258EB4: ; 0x02258EB4
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r1, #0x98
	ldr r1, [r1]
	add r5, r0, #0
	bl BattleSystem_SetRandTemp
	add r0, r5, #0
	add r1, r4, #0
	bl ov12_02259944
	mov r1, #0x65
	lsl r1, r1, #2
	ldrb r1, [r4, r1]
	add r0, r5, #0
	mov r2, #1
	bl ov12_0226430C
	add r0, r4, #0
	bl ov12_02259928
	pop {r3, r4, r5, pc}
	thumb_func_end ov12_02258EB4

	thumb_func_start ov12_02258EE0
ov12_02258EE0: ; 0x02258EE0
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_02259968
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258EE0

	thumb_func_start ov12_02258EF4
ov12_02258EF4: ; 0x02258EF4
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_02259BA8
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258EF4

	thumb_func_start ov12_02258F08
ov12_02258F08: ; 0x02258F08
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_02259D48
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258F08

	thumb_func_start ov12_02258F1C
ov12_02258F1C: ; 0x02258F1C
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_02259F30
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258F1C

	thumb_func_start ov12_02258F30
ov12_02258F30: ; 0x02258F30
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A018
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258F30

	thumb_func_start ov12_02258F44
ov12_02258F44: ; 0x02258F44
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	ldr r0, [r4, #0x20]
	bl Pokepic_Delete
	mov r1, #0x65
	lsl r1, r1, #2
	ldrb r1, [r4, r1]
	add r0, r5, #0
	mov r2, #7
	bl ov12_0226430C
	add r0, r4, #0
	bl ov12_02259928
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov12_02258F44

	thumb_func_start ov12_02258F68
ov12_02258F68: ; 0x02258F68
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A07C
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258F68

	thumb_func_start ov12_02258F7C
ov12_02258F7C: ; 0x02258F7C
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A2A0
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258F7C

	thumb_func_start ov12_02258F90
ov12_02258F90: ; 0x02258F90
	push {r4, lr}
	add r4, r1, #0
	bl ov12_0225A334
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258F90

	thumb_func_start ov12_02258FA0
ov12_02258FA0: ; 0x02258FA0
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A37C
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258FA0

	thumb_func_start ov12_02258FB4
ov12_02258FB4: ; 0x02258FB4
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A414
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258FB4

	thumb_func_start ov12_02258FC8
ov12_02258FC8: ; 0x02258FC8
	push {r4, lr}
	add r4, r1, #0
	bl ov12_0225A4DC
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02258FC8

	thumb_func_start ov12_02258FD8
ov12_02258FD8: ; 0x02258FD8
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r6, r4, #0
	add r6, #0x94
	add r1, r6, #0
	add r1, #0x29
	ldrb r1, [r1]
	add r5, r0, #0
	bl ov12_0223BB6C
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov12_0225A524
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov12_02258FD8

	thumb_func_start ov12_02259000
ov12_02259000: ; 0x02259000
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A604
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259000

	thumb_func_start ov12_02259014
ov12_02259014: ; 0x02259014
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A674
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259014

	thumb_func_start ov12_02259028
ov12_02259028: ; 0x02259028
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A700
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259028

	thumb_func_start ov12_0225903C
ov12_0225903C: ; 0x0225903C
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A7AC
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_0225903C

	thumb_func_start ov12_02259050
ov12_02259050: ; 0x02259050
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A818
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259050

	thumb_func_start ov12_02259064
ov12_02259064: ; 0x02259064
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A85C
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259064

	thumb_func_start ov12_02259078
ov12_02259078: ; 0x02259078
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A8C4
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259078

	thumb_func_start ov12_0225908C
ov12_0225908C: ; 0x0225908C
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A914
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_0225908C

	thumb_func_start ov12_022590A0
ov12_022590A0: ; 0x022590A0
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	ldr r0, [r4, #0x20]
	mov r1, #6
	bl Pokepic_GetAttr
	cmp r0, #1
	bne _022590C2
	mov r1, #0x65
	lsl r1, r1, #2
	ldrb r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x17
	bl ov12_0226430C
	b _022590CA
_022590C2:
	add r0, r5, #0
	add r1, r4, #0
	bl ov12_0225A9B0
_022590CA:
	add r0, r4, #0
	bl ov12_02259928
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov12_022590A0

	thumb_func_start ov12_022590D4
ov12_022590D4: ; 0x022590D4
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225A9E0
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022590D4

	thumb_func_start ov12_022590E8
ov12_022590E8: ; 0x022590E8
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AA6C
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022590E8

	thumb_func_start ov12_022590FC
ov12_022590FC: ; 0x022590FC
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AAE0
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022590FC

	thumb_func_start ov12_02259110
ov12_02259110: ; 0x02259110
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225ABB8
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259110

	thumb_func_start ov12_02259124
ov12_02259124: ; 0x02259124
	push {r4, lr}
	add r4, r1, #0
	bl ov12_0225ABE8
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259124

	thumb_func_start ov12_02259134
ov12_02259134: ; 0x02259134
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AC1C
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259134

	thumb_func_start ov12_02259148
ov12_02259148: ; 0x02259148
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225ACB0
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259148

	thumb_func_start ov12_0225915C
ov12_0225915C: ; 0x0225915C
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225ACE8
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_0225915C

	thumb_func_start ov12_02259170
ov12_02259170: ; 0x02259170
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AD44
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259170

	thumb_func_start ov12_02259184
ov12_02259184: ; 0x02259184
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AD9C
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259184

	thumb_func_start ov12_02259198
ov12_02259198: ; 0x02259198
	push {r4, lr}
	add r4, r1, #0
	bl ov12_0225ADF4
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_02259198

	thumb_func_start ov12_022591A8
ov12_022591A8: ; 0x022591A8
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AE48
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022591A8

	thumb_func_start ov12_022591BC
ov12_022591BC: ; 0x022591BC
	push {r4, lr}
	add r4, r1, #0
	bl ov12_0225AEA0
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022591BC

	thumb_func_start ov12_022591CC
ov12_022591CC: ; 0x022591CC
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AED8
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022591CC

	thumb_func_start ov12_022591E0
ov12_022591E0: ; 0x022591E0
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225AF74
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022591E0

	thumb_func_start ov12_022591F4
ov12_022591F4: ; 0x022591F4
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r1, #0
	mov r2, #0x65
	add r6, #0x94
	lsl r2, r2, #2
	str r1, [sp, #4]
	ldrb r1, [r1, r2]
	ldrb r2, [r6, #1]
	str r0, [sp]
	lsl r2, r2, #0x1c
	lsr r2, r2, #0x1c
	bl BattleSystem_GetPartyMon
	add r7, r0, #0
	mov r0, #2
	ldr r1, [r6, #0x1c]
	lsl r0, r0, #0x14
	tst r0, r1
	bne _0225925C
	add r0, r6, #0
	add r5, r6, #0
	str r0, [sp, #8]
	add r0, #0x16
	mov r4, #0
	add r5, #0xe
	str r0, [sp, #8]
_0225922A:
	add r0, r4, #0
	bl MaskOfFlagNo
	ldrb r1, [r6, #1]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1c
	tst r0, r1
	bne _02259254
	add r1, r4, #0
	add r0, r7, #0
	add r1, #0x36
	add r2, r5, #0
	bl SetMonData
	ldr r2, [sp, #8]
	add r1, r4, #0
	add r0, r7, #0
	add r1, #0x3a
	add r2, r2, r4
	bl SetMonData
_02259254:
	add r4, r4, #1
	add r5, r5, #2
	cmp r4, #4
	blt _0225922A
_0225925C:
	ldrb r0, [r6, #1]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	bl MaskOfFlagNo
	ldr r1, [r6, #8]
	tst r0, r1
	bne _02259278
	add r2, r6, #0
	add r0, r7, #0
	mov r1, #6
	add r2, #0xc
	bl SetMonData
_02259278:
	add r0, r7, #0
	mov r1, #0xa3
	add r2, r6, #2
	bl SetMonData
	add r0, r7, #0
	mov r1, #0xa0
	add r2, r6, #4
	bl SetMonData
	ldrh r0, [r6, #0x2a]
	cmp r0, #0
	beq _0225929E
	add r2, r6, #0
	add r0, r7, #0
	mov r1, #0x70
	add r2, #0x20
	bl SetMonData
_0225929E:
	ldrh r0, [r6, #0x28]
	cmp r0, #0
	beq _022592B6
	add r2, r6, #0
	add r0, r7, #0
	mov r1, #0xa
	add r2, #0x24
	bl SetMonData
	add r0, r7, #0
	bl CalcMonLevelAndStats
_022592B6:
	mov r2, #0x65
	ldr r1, [sp, #4]
	lsl r2, r2, #2
	ldrb r1, [r1, r2]
	ldrb r2, [r6]
	ldr r0, [sp]
	bl ov12_0226430C
	ldr r0, [sp, #4]
	bl ov12_02259928
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov12_022591F4

	thumb_func_start ov12_022592D0
ov12_022592D0: ; 0x022592D0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl BattleSystem_GetBattleType
	add r6, r0, #0
	add r0, r5, #0
	bl BattleSystem_GetBattleInput
	ldr r2, _02259320 ; =0x00000196
	ldrb r1, [r4, r2]
	cmp r1, #0
	bne _02259304
	mov r1, #8
	and r1, r6
	bne _022592FC
	cmp r1, #0
	bne _02259304
	sub r1, r2, #1
	ldrb r1, [r4, r1]
	cmp r1, #4
	beq _02259304
_022592FC:
	ldr r1, _02259324 ; =0xFFFFF300
	mov r2, #0
	bl BattleInput_StartMenuScrollHorizontalTask
_02259304:
	mov r1, #0x65
	add r2, r4, #0
	lsl r1, r1, #2
	add r2, #0x94
	ldrb r1, [r4, r1]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov12_0226430C
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, r5, r6, pc}
	nop
_02259320: .word 0x00000196
_02259324: .word 0xFFFFF300
	thumb_func_end ov12_022592D0

	thumb_func_start ov12_02259328
ov12_02259328: ; 0x02259328
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	add r0, #0x28
	bl ov12_02264EB4
	add r0, r4, #0
	bl ov12_02262014
	mov r1, #0x65
	add r2, r4, #0
	lsl r1, r1, #2
	add r2, #0x94
	ldrb r1, [r4, r1]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov12_0226430C
	add r0, r4, #0
	bl ov12_02259928
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov12_02259328

	thumb_func_start ov12_02259358
ov12_02259358: ; 0x02259358
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r1, #0
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #0x65
	lsl r1, r1, #2
	add r4, r7, #0
	ldrb r1, [r7, r1]
	str r0, [sp]
	add r4, #0x94
	bl BattleSystem_GetPartySize
	mov r5, #0
	str r0, [sp, #4]
	cmp r0, #0
	ble _022593BA
_0225937A:
	mov r1, #0x65
	lsl r1, r1, #2
	ldrb r1, [r7, r1]
	ldr r0, [sp]
	add r2, r5, #0
	bl BattleSystem_GetPartyMon
	ldrb r1, [r4, #1]
	add r6, r0, #0
	cmp r1, #0x68
	bne _02259394
	mov r0, #0
	b _0225939C
_02259394:
	mov r1, #0xa
	mov r2, #0
	bl GetMonData
_0225939C:
	ldrh r1, [r4, #2]
	cmp r1, #0xd7
	bne _022593A8
	bne _022593B2
	cmp r0, #0x2b
	beq _022593B2
_022593A8:
	add r0, r6, #0
	mov r1, #0xa0
	add r2, sp, #8
	bl SetMonData
_022593B2:
	ldr r0, [sp, #4]
	add r5, r5, #1
	cmp r5, r0
	blt _0225937A
_022593BA:
	mov r1, #0x65
	lsl r1, r1, #2
	ldrb r1, [r7, r1]
	ldrb r2, [r4]
	ldr r0, [sp]
	bl ov12_0226430C
	add r0, r7, #0
	bl ov12_02259928
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov12_02259358

	thumb_func_start ov12_022593D4
ov12_022593D4: ; 0x022593D4
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225B028
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022593D4

	thumb_func_start ov12_022593E8
ov12_022593E8: ; 0x022593E8
	push {r4, lr}
	add r4, r1, #0
	add r2, r4, #0
	add r2, #0x94
	bl ov12_0225B060
	add r0, r4, #0
	bl ov12_02259928
	pop {r4, pc}
	thumb_func_end ov12_022593E8
