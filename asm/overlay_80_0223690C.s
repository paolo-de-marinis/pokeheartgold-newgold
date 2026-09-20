	.include "asm/macros.inc"
	.include "overlay_80_02236450.inc"
	.include "global.inc"

    .text

	thumb_func_start ov80_0223690C
ov80_0223690C: ; 0x0223690C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldrb r0, [r5, #0xf]
	add r4, r1, #0
	bl ov80_02236A88
	add r1, r0, #0
	ldr r0, [r5, #4]
	bl BattleSetup_New
	add r7, r0, #0
	ldr r0, [r4, #8]
	bl SaveArray_Party_Get
	str r0, [sp, #8]
	ldr r0, [r4, #0xc]
	mov r1, #0
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	str r0, [sp, #4]
	ldr r2, [r4, #8]
	ldr r3, [r4, #0x18]
	add r0, r7, #0
	bl sub_02051D18
	mov r0, #0x53
	mov r1, #0x12
	lsl r0, r0, #2
	str r1, [r7, r0]
	add r0, r0, #4
	str r1, [r7, r0]
	ldr r0, [r5, #4]
	bl AllocMonZeroed
	add r4, r0, #0
	ldrb r1, [r5, #0xe]
	ldr r0, [r7, #4]
	bl Party_InitWithMaxSize
	ldrb r0, [r5, #0xe]
	mov r6, #0
	cmp r0, #0
	ble _022369B8
_02236964:
	add r1, r5, r6
	add r1, #0x2a
	ldrb r1, [r1]
	ldr r0, [sp, #8]
	bl Party_GetMonByIndex
	add r1, r4, #0
	bl CopyPokemonToPokemon
	add r0, r4, #0
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	cmp r0, #0x32
	bls _022369A6
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	mov r1, #0x32
	bl GetMonExpBySpeciesAndLevel
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #8
	add r2, sp, #0xc
	bl SetMonData
	add r0, r4, #0
	bl CalcMonLevelAndStats
_022369A6:
	add r0, r7, #0
	add r1, r4, #0
	mov r2, #0
	bl BattleSetup_AddMonToParty
	ldrb r0, [r5, #0xe]
	add r6, r6, #1
	cmp r6, r0
	blt _02236964
_022369B8:
	add r0, r4, #0
	bl Heap_Free
	add r0, r7, #0
	bl BattleSetup_SetAllySideBattlersToPlayer
	ldr r0, [r5, #4]
	add r1, r5, #0
	str r0, [sp]
	ldrb r2, [r5, #0xe]
	add r0, r7, #0
	add r1, #0x78
	mov r3, #1
	bl ov80_02236A34
	mov r2, #0
	add r1, r7, #0
	mov r0, #7
_022369DC:
	add r2, r2, #1
	str r0, [r1, #0x34]
	add r1, #0x34
	cmp r2, #4
	blt _022369DC
	ldrb r0, [r5, #0xf]
	cmp r0, #2
	beq _022369F6
	cmp r0, #3
	beq _02236A18
	cmp r0, #6
	beq _02236A18
	b _02236A2C
_022369F6:
	ldr r0, [r5, #4]
	mov r1, #0xa6
	str r0, [sp]
	ldrb r2, [r5, #0x10]
	lsl r1, r1, #2
	add r1, r5, r1
	lsl r2, r2, #0x18
	lsr r3, r2, #0x1d
	lsl r2, r3, #4
	add r2, r3, r2
	lsl r2, r2, #4
	add r1, r1, r2
	ldrb r2, [r5, #0xe]
	add r0, r7, #0
	mov r3, #2
	bl ov80_02236A34
_02236A18:
	ldr r0, [r5, #4]
	mov r1, #0x62
	str r0, [sp]
	ldrb r2, [r5, #0xe]
	lsl r1, r1, #2
	add r0, r7, #0
	add r1, r5, r1
	mov r3, #3
	bl ov80_02236A34
_02236A2C:
	add r0, r7, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov80_0223690C

	thumb_func_start ov80_02236A34
ov80_02236A34: ; 0x02236A34
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	ldr r4, [sp, #0x28]
	str r0, [sp, #4]
	add r5, r1, #0
	add r7, r2, #0
	str r3, [sp, #8]
	str r4, [sp]
	bl ov80_0222A480
	ldr r0, [sp, #0x28]
	bl AllocMonZeroed
	add r4, r0, #0
	mov r6, #0
	cmp r7, #0
	ble _02236A7E
	ldr r0, [sp, #8]
	add r5, #0x30
	lsl r1, r0, #2
	ldr r0, [sp, #4]
	add r0, r0, r1
	str r0, [sp, #0xc]
_02236A62:
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x78
	bl ov80_0222A140
	ldr r0, [sp, #0xc]
	add r1, r4, #0
	ldr r0, [r0, #4]
	bl Party_AddMon
	add r6, r6, #1
	add r5, #0x38
	cmp r6, r7
	blt _02236A62
_02236A7E:
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov80_02236A34

	thumb_func_start ov80_02236A88
ov80_02236A88: ; 0x02236A88
	cmp r0, #6
	bhi _02236AB6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02236A98: ; jump table
	.short _02236AA6 - _02236A98 - 2 ; case 0
	.short _02236AAA - _02236A98 - 2 ; case 1
	.short _02236AAE - _02236A98 - 2 ; case 2
	.short _02236AB2 - _02236A98 - 2 ; case 3
	.short _02236AA6 - _02236A98 - 2 ; case 4
	.short _02236AB6 - _02236A98 - 2 ; case 5
	.short _02236AB2 - _02236A98 - 2 ; case 6
_02236AA6:
	mov r0, #0x81
	bx lr
_02236AAA:
	mov r0, #0x83
	bx lr
_02236AAE:
	mov r0, #0xcb
	bx lr
_02236AB2:
	mov r0, #0x8f
	bx lr
_02236AB6:
	mov r0, #0x81
	bx lr
	.balign 4, 0
	thumb_func_end ov80_02236A88

	thumb_func_start ov80_02236ABC
ov80_02236ABC: ; 0x02236ABC
	ldrb r3, [r0, #0x10]
	mov r2, #8
	bic r3, r2
	lsl r2, r1, #0x18
	lsr r2, r2, #0x18
	lsl r2, r2, #0x1f
	lsr r2, r2, #0x1c
	orr r2, r3
	strb r2, [r0, #0x10]
	ldr r2, _02236AD4 ; =0x0000083E
	strh r1, [r0, r2]
	bx lr
	.balign 4, 0
_02236AD4: .word 0x0000083E
	thumb_func_end ov80_02236ABC

	thumb_func_start ov80_02236AD8
ov80_02236AD8: ; 0x02236AD8
	ldrb r0, [r0, #0x10]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1f
	bne _02236AE6
	ldrh r0, [r1]
	cmp r0, #0
	beq _02236AEA
_02236AE6:
	mov r0, #1
	bx lr
_02236AEA:
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov80_02236AD8

	thumb_func_start ov80_02236AF0
ov80_02236AF0: ; 0x02236AF0
	push {r3, lr}
	bl ov80_02236B30
	cmp r0, #0
	bne _02236AFE
	mov r0, #0x81
	pop {r3, pc}
_02236AFE:
	mov r0, #0xcd
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov80_02236AF0

	thumb_func_start ov80_02236B04
ov80_02236B04: ; 0x02236B04
	push {r3, lr}
	bl ov80_02236B30
	cmp r0, #0
	bne _02236B12
	mov r0, #0x80
	pop {r3, pc}
_02236B12:
	mov r0, #0xcc
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov80_02236B04

	thumb_func_start ov80_02236B18
ov80_02236B18: ; 0x02236B18
	push {r3, lr}
	bl ov80_02236B30
	cmp r0, #0
	bne _02236B26
	ldr r0, _02236B2C ; =0x000002D3
	pop {r3, pc}
_02236B26:
	mov r0, #0xb5
	lsl r0, r0, #2
	pop {r3, pc}
	.balign 4, 0
_02236B2C: .word 0x000002D3
	thumb_func_end ov80_02236B18

	thumb_func_start ov80_02236B30
ov80_02236B30: ; 0x02236B30
	push {r3, r4, r5, lr}
	cmp r0, #3
	beq _02236B3A
	cmp r0, #6
	bne _02236B74
_02236B3A:
	mov r0, #0
	bl sub_02034818
	add r5, r0, #0
	bne _02236B48
	bl GF_AssertFail
_02236B48:
	mov r0, #1
	bl sub_02034818
	add r4, r0, #0
	bne _02236B56
	bl GF_AssertFail
_02236B56:
	add r0, r5, #0
	bl PlayerProfile_GetVersion
	add r5, r0, #0
	add r0, r4, #0
	bl PlayerProfile_GetVersion
	cmp r5, #0
	beq _02236B6C
	cmp r0, #0
	bne _02236B70
_02236B6C:
	mov r0, #0
	pop {r3, r4, r5, pc}
_02236B70:
	mov r0, #1
	pop {r3, r4, r5, pc}
_02236B74:
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end ov80_02236B30
