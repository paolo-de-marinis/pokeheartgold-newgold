	.include "asm/macros.inc"
	.include "overlay_10.inc"
	.include "global.inc"

	.text

	thumb_func_start ov10_0221DCEC
ov10_0221DCEC: ; 0x0221DCEC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r6, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	cmp r4, #0
	beq _0221DD24
	cmp r4, #1
	beq _0221DD3E
	pop {r3, r4, r5, r6, r7, pc}
_0221DD24:
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221DD58 ; =0x00002DC8
	add r1, r5, r1
	ldr r0, [r1, r0]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	beq _0221DD56
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221DD3E:
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221DD58 ; =0x00002DC8
	add r1, r5, r1
	ldr r0, [r1, r0]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1d
	beq _0221DD56
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221DD56:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221DD58: .word 0x00002DC8
	thumb_func_end ov10_0221DCEC

	thumb_func_start ov10_0221DD5C
ov10_0221DD5C: ; 0x0221DD5C
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r5, r0, #0
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	cmp r5, #0
	beq _0221DD82
	cmp r5, #1
	beq _0221DDA0
	pop {r3, r4, r5, pc}
_0221DD82:
	ldr r2, _0221DDC0 ; =0x00000356
	ldrh r0, [r4, r2]
	add r2, #0x79
	ldrb r3, [r4, r2]
	mov r2, #0xc0
	mul r2, r3
	add r3, r4, r2
	ldr r2, _0221DDC4 ; =0x00002DE8
	ldrh r2, [r3, r2]
	cmp r0, r2
	bne _0221DDBC
	add r0, r4, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, pc}
_0221DDA0:
	ldr r2, _0221DDC0 ; =0x00000356
	ldrh r0, [r4, r2]
	add r2, #0x79
	ldrb r3, [r4, r2]
	mov r2, #0xc0
	mul r2, r3
	add r3, r4, r2
	ldr r2, _0221DDC8 ; =0x00002DEC
	ldrh r2, [r3, r2]
	cmp r0, r2
	bne _0221DDBC
	add r0, r4, #0
	bl ov10_0221EF24
_0221DDBC:
	pop {r3, r4, r5, pc}
	nop
_0221DDC0: .word 0x00000356
_0221DDC4: .word 0x00002DE8
_0221DDC8: .word 0x00002DEC
	thumb_func_end ov10_0221DD5C

	thumb_func_start ov10_0221DDCC
ov10_0221DDCC: ; 0x0221DDCC
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r1, #0xd9
	lsl r1, r1, #2
	ldrb r2, [r4, r1]
	mov r0, #0xb
	orr r0, r2
	strb r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov10_0221DDCC

	thumb_func_start ov10_0221DDE8
ov10_0221DDE8: ; 0x0221DDE8
	bx lr
	.balign 4, 0
	thumb_func_end ov10_0221DDE8

	thumb_func_start ov10_0221DDEC
ov10_0221DDEC: ; 0x0221DDEC
	bx lr
	.balign 4, 0
	thumb_func_end ov10_0221DDEC

	thumb_func_start ov10_0221DDF0
ov10_0221DDF0: ; 0x0221DDF0
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221DE20 ; =0x00002DB8
	add r1, r4, r1
	ldrh r1, [r1, r0]
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221DE20: .word 0x00002DB8
	thumb_func_end ov10_0221DDF0

	thumb_func_start ov10_0221DE24
ov10_0221DE24: ; 0x0221DE24
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	ldr r1, _0221DE80 ; =0x000003CF
	add r2, r0, #0
	ldrb r0, [r4, r1]
	cmp r0, r2
	beq _0221DE64
	lsl r2, r2, #1
	add r2, r4, r2
	sub r1, #0x3b
	ldrh r1, [r2, r1]
	add r0, r4, #0
	mov r2, #1
	bl GetItemVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
_0221DE64:
	mov r1, #0xc0
	mul r1, r2
	add r2, r4, r1
	ldr r1, _0221DE84 ; =0x00002DB8
	add r0, r4, #0
	ldrh r1, [r2, r1]
	mov r2, #1
	bl GetItemVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_0221DE80: .word 0x000003CF
_0221DE84: .word 0x00002DB8
	thumb_func_end ov10_0221DE24

	thumb_func_start ov10_0221DE88
ov10_0221DE88: ; 0x0221DE88
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r6, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r6, r0, #0
	ldr r0, _0221DEE8 ; =0x000003CF
	mov r1, #1
	add r3, r6, #0
	ldrb r2, [r5, r0]
	and r3, r1
	and r1, r2
	cmp r3, r1
	bne _0221DED2
	mov r0, #0xc0
	mul r0, r6
	add r1, r5, r0
	ldr r0, _0221DEEC ; =0x00002DB8
	b _0221DED8
_0221DED2:
	lsl r1, r6, #1
	add r1, r5, r1
	sub r0, #0x3b
_0221DED8:
	ldrh r0, [r1, r0]
	cmp r0, r4
	bne _0221DEE6
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221DEE6:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221DEE8: .word 0x000003CF
_0221DEEC: .word 0x00002DB8
	thumb_func_end ov10_0221DE88

	thumb_func_start ov10_0221DEF0
ov10_0221DEF0: ; 0x0221DEF0
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	tst r0, r4
	beq _0221DF1C
	add r0, r5, #0
	bl ov10_0221EF24
_0221DF1C:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221DEF0

	thumb_func_start ov10_0221DF20
ov10_0221DF20: ; 0x0221DF20
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r6, #0x18
	add r4, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r1, r0, #0
	add r0, r7, #0
	bl BattleSystem_GetFieldSide
	cmp r4, #4
	beq _0221DF5E
	mov r1, #1
	lsl r1, r1, #0xa
	cmp r4, r1
	beq _0221DF74
	pop {r3, r4, r5, r6, r7, pc}
_0221DF5E:
	lsl r0, r0, #3
	add r1, r5, r0
	mov r0, #0x72
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	lsl r0, r0, #0x1e
	lsr r1, r0, #0x1e
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r5, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0221DF74:
	lsl r0, r0, #3
	add r2, r5, r0
	mov r0, #0x72
	lsl r0, r0, #2
	ldr r0, [r2, r0]
	sub r1, #0xa4
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1e
	str r0, [r5, r1]
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov10_0221DF20

	thumb_func_start ov10_0221DF88
ov10_0221DF88: ; 0x0221DF88
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	str r1, [sp]
	add r0, r1, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, [sp]
	bl ov10_0221EEF0
	add r4, r0, #0
	ldr r0, [sp]
	bl ov10_0221EEF0
	str r0, [sp, #8]
	lsl r1, r4, #0x18
	ldr r0, [sp]
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r6, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	mov r4, #0
	bl BattleSystem_GetPartySize
	cmp r0, #0
	ble _0221E010
	ldr r0, [sp]
	add r0, r0, r6
	str r0, [sp, #4]
_0221DFC8:
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl BattleSystem_GetPartyMon
	ldr r2, [sp, #4]
	ldr r1, _0221E014 ; =0x0000219C
	str r0, [sp, #0xc]
	ldrb r1, [r2, r1]
	cmp r4, r1
	beq _0221E002
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	add r7, r0, #0
	ldr r0, [sp, #0xc]
	mov r1, #0xa4
	mov r2, #0
	bl GetMonData
	cmp r7, r0
	beq _0221E002
	ldr r0, [sp]
	ldr r1, [sp, #8]
	bl ov10_0221EF24
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
_0221E002:
	add r0, r5, #0
	add r1, r6, #0
	add r4, r4, #1
	bl BattleSystem_GetPartySize
	cmp r4, r0
	blt _0221DFC8
_0221E010:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E014: .word 0x0000219C
	thumb_func_end ov10_0221DF88

	thumb_func_start ov10_0221E018
ov10_0221E018: ; 0x0221E018
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	str r0, [sp]
	str r1, [sp, #4]
	add r0, r1, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, [sp, #4]
	bl ov10_0221EEF0
	add r4, r0, #0
	ldr r0, [sp, #4]
	bl ov10_0221EEF0
	str r0, [sp, #0x10]
	lsl r1, r4, #0x18
	ldr r0, [sp, #4]
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	str r0, [sp, #8]
	ldr r0, [sp]
	ldr r1, [sp, #8]
	mov r7, #0
	bl BattleSystem_GetPartySize
	cmp r0, #0
	ble _0221E0B2
	ldr r1, [sp, #4]
	ldr r0, [sp, #8]
	add r0, r1, r0
	str r0, [sp, #0xc]
_0221E05A:
	ldr r0, [sp]
	ldr r1, [sp, #8]
	add r2, r7, #0
	bl BattleSystem_GetPartyMon
	add r5, r0, #0
	ldr r1, [sp, #0xc]
	ldr r0, _0221E0B8 ; =0x0000219C
	ldrb r0, [r1, r0]
	cmp r7, r0
	beq _0221E0A4
	mov r4, #0
_0221E072:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0x3a
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r6, r0, #0
	add r0, r5, #0
	add r1, #0x42
	mov r2, #0
	bl GetMonData
	cmp r6, r0
	beq _0221E09A
	ldr r0, [sp, #4]
	ldr r1, [sp, #0x10]
	bl ov10_0221EF24
	b _0221E0A0
_0221E09A:
	add r4, r4, #1
	cmp r4, #4
	blt _0221E072
_0221E0A0:
	cmp r4, #4
	bne _0221E0B2
_0221E0A4:
	ldr r0, [sp]
	ldr r1, [sp, #8]
	add r7, r7, #1
	bl BattleSystem_GetPartySize
	cmp r7, r0
	blt _0221E05A
_0221E0B2:
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0221E0B8: .word 0x0000219C
	thumb_func_end ov10_0221E018

	thumb_func_start ov10_0221E0BC
ov10_0221E0BC: ; 0x0221E0BC
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r1, r0, #0
	add r0, r4, #0
	bl GetHeldItemFlingPower
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov10_0221E0BC

	thumb_func_start ov10_0221E0EC
ov10_0221E0EC: ; 0x0221E0EC
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r1, _0221E114 ; =0x000003CF
	mov r0, #0xc0
	ldrb r2, [r4, r1]
	mul r0, r2
	add r2, r4, r0
	add r0, r1, #0
	sub r0, #0x7a
	ldrb r0, [r4, r0]
	sub r1, #0x73
	add r2, r2, r0
	ldr r0, _0221E118 ; =0x00002D6C
	ldrb r0, [r2, r0]
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_0221E114: .word 0x000003CF
_0221E118: .word 0x00002D6C
	thumb_func_end ov10_0221E0EC

	thumb_func_start ov10_0221E11C
ov10_0221E11C: ; 0x0221E11C
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r6, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r5, r0, #0
	add r0, r4, #0
	bl ov10_0221EEF0
	lsl r1, r5, #0x18
	add r7, r0, #0
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r5, r0, #0
	add r0, r6, #0
	add r1, r4, #0
	add r2, r5, #0
	bl GetBattlerLearnedMoveCount
	mov r1, #0xc0
	mul r1, r5
	add r2, r4, r1
	ldr r1, _0221E174 ; =0x00002DCC
	ldr r1, [r2, r1]
	lsl r1, r1, #0x13
	lsr r2, r1, #0x1d
	sub r1, r0, #1
	cmp r2, r1
	blo _0221E170
	cmp r0, #1
	ble _0221E170
	add r0, r4, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221E170:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221E174: .word 0x00002DCC
	thumb_func_end ov10_0221E11C
