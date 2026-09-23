	.include "asm/macros.inc"
	.include "overlay_10.inc"
	.include "global.inc"

	.text

	thumb_func_start ov10_0221EC08
ov10_0221EC08: ; 0x0221EC08
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl ov10_0221EE28
	pop {r3, r4, r5, pc}
	thumb_func_end ov10_0221EC08

	thumb_func_start ov10_0221EC28
ov10_0221EC28: ; 0x0221EC28
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	add r0, r4, #0
	bl ov10_0221EF24
	pop {r4, pc}
	thumb_func_end ov10_0221EC28

	thumb_func_start ov10_0221EC44
ov10_0221EC44: ; 0x0221EC44
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	add r1, r4, #0
	bl ov10_0221EE60
	cmp r0, #1
	beq _0221EC6A
	mov r1, #0xd9
	lsl r1, r1, #2
	ldrb r2, [r4, r1]
	mov r0, #1
	orr r0, r2
	strb r0, [r4, r1]
_0221EC6A:
	pop {r3, r4, r5, pc}
	thumb_func_end ov10_0221EC44

	thumb_func_start ov10_0221EC6C
ov10_0221EC6C: ; 0x0221EC6C
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
	cmp r4, #0
	beq _0221EC96
	cmp r4, #1
	beq _0221ECBC
	cmp r4, #2
	beq _0221ECE2
	pop {r3, r4, r5, pc}
_0221EC96:
	ldr r2, _0221ED08 ; =0x000003CF
	mov r3, #0xc0
	ldrb r0, [r5, r2]
	add r2, r2, #1
	ldrb r2, [r5, r2]
	add r4, r0, #0
	mul r4, r3
	add r0, r5, r4
	ldr r4, _0221ED0C ; =0x00002D74
	mul r3, r2
	add r2, r5, r3
	ldrb r0, [r0, r4]
	ldrb r2, [r2, r4]
	cmp r0, r2
	bls _0221ED06
	add r0, r5, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, pc}
_0221ECBC:
	ldr r2, _0221ED08 ; =0x000003CF
	mov r3, #0xc0
	ldrb r0, [r5, r2]
	add r2, r2, #1
	ldrb r2, [r5, r2]
	add r4, r0, #0
	mul r4, r3
	add r0, r5, r4
	ldr r4, _0221ED0C ; =0x00002D74
	mul r3, r2
	add r2, r5, r3
	ldrb r0, [r0, r4]
	ldrb r2, [r2, r4]
	cmp r0, r2
	bhs _0221ED06
	add r0, r5, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, pc}
_0221ECE2:
	ldr r2, _0221ED08 ; =0x000003CF
	mov r3, #0xc0
	ldrb r0, [r5, r2]
	add r2, r2, #1
	ldrb r2, [r5, r2]
	add r4, r0, #0
	mul r4, r3
	add r0, r5, r4
	ldr r4, _0221ED0C ; =0x00002D74
	mul r3, r2
	add r2, r5, r3
	ldrb r0, [r0, r4]
	ldrb r2, [r2, r4]
	cmp r0, r2
	bne _0221ED06
	add r0, r5, #0
	bl ov10_0221EF24
_0221ED06:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221ED08: .word 0x000003CF
_0221ED0C: .word 0x00002D74
	thumb_func_end ov10_0221EC6C

	thumb_func_start ov10_0221ED10
ov10_0221ED10: ; 0x0221ED10
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	mov r0, #0x3d
	lsl r0, r0, #4
	ldrb r2, [r4, r0]
	mov r0, #0xc0
	mul r0, r2
	add r2, r4, r0
	ldr r0, _0221ED44 ; =0x00002DC8
	ldr r0, [r2, r0]
	lsl r0, r0, #0x15
	lsr r0, r0, #0x1d
	beq _0221ED40
	add r0, r4, #0
	bl ov10_0221EF24
_0221ED40:
	pop {r4, pc}
	nop
_0221ED44: .word 0x00002DC8
	thumb_func_end ov10_0221ED10

	thumb_func_start ov10_0221ED48
ov10_0221ED48: ; 0x0221ED48
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	mov r0, #0x3d
	lsl r0, r0, #4
	ldrb r2, [r4, r0]
	mov r0, #0xc0
	mul r0, r2
	add r2, r4, r0
	ldr r0, _0221ED7C ; =0x00002DC8
	ldr r0, [r2, r0]
	lsl r0, r0, #0x15
	lsr r0, r0, #0x1d
	bne _0221ED78
	add r0, r4, #0
	bl ov10_0221EF24
_0221ED78:
	pop {r4, pc}
	nop
_0221ED7C: .word 0x00002DC8
	thumb_func_end ov10_0221ED48

	thumb_func_start ov10_0221ED80
ov10_0221ED80: ; 0x0221ED80
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	ldr r2, _0221EDB0 ; =0x000003CF
	add r1, r0, #0
	ldrb r0, [r4, r2]
	add r2, r2, #1
	mov r3, #1
	ldrb r2, [r4, r2]
	and r0, r3
	and r2, r3
	cmp r0, r2
	bne _0221EDAC
	add r0, r4, #0
	bl ov10_0221EF24
_0221EDAC:
	pop {r4, pc}
	nop
_0221EDB0: .word 0x000003CF
	thumb_func_end ov10_0221ED80

	thumb_func_start ov10_0221EDB4
ov10_0221EDB4: ; 0x0221EDB4
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r6, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221EDF4 ; =0x00002DC8
	add r1, r5, r1
	ldr r0, [r1, r0]
	lsr r0, r0, #0x1f
	beq _0221EDF0
	add r0, r5, #0
	add r1, r6, #0
	bl ov10_0221EF24
_0221EDF0:
	pop {r4, r5, r6, pc}
	nop
_0221EDF4: .word 0x00002DC8
	thumb_func_end ov10_0221EDB4

	thumb_func_start ov10_0221EDF8
ov10_0221EDF8: ; 0x0221EDF8
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
	bl GetBattlerAbility
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov10_0221EDF8

	thumb_func_start ov10_0221EE28
ov10_0221EE28: ; 0x0221EE28
	push {r3, r4, r5, lr}
	add r4, r1, #0
	mov r1, #0xf3
	lsl r1, r1, #2
	ldrb r5, [r4, r1]
	add r0, r5, #1
	strb r0, [r4, r1]
	ldr r0, _0221EE5C ; =0x00002138
	sub r1, #0x20
	ldr r3, [r4, r0]
	lsl r0, r5, #2
	add r0, r4, r0
	str r3, [r0, r1]
	add r0, r4, #0
	add r1, r2, #0
	bl ov10_0221EF24
	mov r0, #0xf3
	lsl r0, r0, #2
	ldrb r0, [r4, r0]
	cmp r0, #8
	bls _0221EE58
	bl GF_AssertFail
_0221EE58:
	pop {r3, r4, r5, pc}
	nop
_0221EE5C: .word 0x00002138
	thumb_func_end ov10_0221EE28

	thumb_func_start ov10_0221EE60
ov10_0221EE60: ; 0x0221EE60
	mov r0, #0xf3
	lsl r0, r0, #2
	ldrb r2, [r1, r0]
	cmp r2, #0
	beq _0221EE80
	sub r2, r2, #1
	strb r2, [r1, r0]
	ldrb r2, [r1, r0]
	sub r0, #0x20
	lsl r2, r2, #2
	add r2, r1, r2
	ldr r2, [r2, r0]
	ldr r0, _0221EE84 ; =0x00002138
	str r2, [r1, r0]
	mov r0, #1
	bx lr
_0221EE80:
	mov r0, #0
	bx lr
	.balign 4, 0
_0221EE84: .word 0x00002138
	thumb_func_end ov10_0221EE60

	thumb_func_start ov10_0221EE88
ov10_0221EE88: ; 0x0221EE88
	push {r3, r4, r5, r6, r7, lr}
	mov r2, #0x3d
	lsl r2, r2, #4
	str r1, [sp]
	ldrb r1, [r1, r2]
	mov r7, #0x37
	lsl r7, r7, #4
	mov lr, r1
	mov r3, lr
	lsl r4, r3, #1
	ldr r3, [sp]
	ldr r2, [sp]
	lsl r1, r1, #3
	add r4, r3, r4
	ldr r3, _0221EEEC ; =0x0000307C
	mov r0, #0
	add r5, r2, r1
	mov ip, r1
	ldrh r3, [r4, r3]
	add r1, r5, #0
	add r2, r0, #0
	add r6, r7, #0
_0221EEB4:
	ldrh r4, [r1, r6]
	cmp r3, r4
	beq _0221EEEA
	add r4, r5, r2
	ldrh r4, [r4, r7]
	cmp r4, #0
	bne _0221EEE0
	mov r1, lr
	lsl r2, r1, #1
	ldr r1, [sp]
	ldr r3, [sp]
	add r2, r1, r2
	ldr r1, _0221EEEC ; =0x0000307C
	lsl r0, r0, #1
	ldrh r1, [r2, r1]
	mov r2, ip
	add r2, r3, r2
	add r2, r2, r0
	mov r0, #0x37
	lsl r0, r0, #4
	strh r1, [r2, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0221EEE0:
	add r0, r0, #1
	add r1, r1, #2
	add r2, r2, #2
	cmp r0, #4
	blt _0221EEB4
_0221EEEA:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221EEEC: .word 0x0000307C
	thumb_func_end ov10_0221EE88

	thumb_func_start ov10_0221EEF0
ov10_0221EEF0: ; 0x0221EEF0
	ldr r1, _0221EF0C ; =0x00002134
	add r2, r1, #4
	ldr r2, [r0, r2]
	ldr r3, [r0, r1]
	lsl r2, r2, #2
	ldr r3, [r3, r2]
	add r2, r1, #4
	ldr r2, [r0, r2]
	add r1, r1, #4
	add r2, r2, #1
	str r2, [r0, r1]
	add r0, r3, #0
	bx lr
	nop
_0221EF0C: .word 0x00002134
	thumb_func_end ov10_0221EEF0

	thumb_func_start ov10_0221EF10
ov10_0221EF10: ; 0x0221EF10
	ldr r2, _0221EF20 ; =0x00002134
	ldr r3, [r0, r2]
	add r2, r2, #4
	ldr r0, [r0, r2]
	add r0, r0, r1
	lsl r0, r0, #2
	ldr r0, [r3, r0]
	bx lr
	.balign 4, 0
_0221EF20: .word 0x00002134
	thumb_func_end ov10_0221EF10

	thumb_func_start ov10_0221EF24
ov10_0221EF24: ; 0x0221EF24
	ldr r2, _0221EF30 ; =0x00002138
	ldr r3, [r0, r2]
	add r1, r3, r1
	str r1, [r0, r2]
	bx lr
	nop
_0221EF30: .word 0x00002138
	thumb_func_end ov10_0221EF24

	thumb_func_start ov10_0221EF34
ov10_0221EF34: ; 0x0221EF34
	cmp r1, #3
	bhi _0221EF52
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221EF44: ; jump table
	.short _0221EF52 - _0221EF44 - 2 ; case 0
	.short _0221EF4C - _0221EF44 - 2 ; case 1
	.short _0221EF68 - _0221EF44 - 2 ; case 2
	.short _0221EF5A - _0221EF44 - 2 ; case 3
_0221EF4C:
	ldr r1, _0221EF78 ; =0x000003CF
	ldrb r0, [r0, r1]
	bx lr
_0221EF52:
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r0, [r0, r1]
	bx lr
_0221EF5A:
	ldr r1, _0221EF78 ; =0x000003CF
	ldrb r1, [r0, r1]
	mov r0, #2
	eor r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bx lr
_0221EF68:
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r1, [r0, r1]
	mov r0, #2
	eor r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bx lr
	.balign 4, 0
_0221EF78: .word 0x000003CF
	thumb_func_end ov10_0221EF34
