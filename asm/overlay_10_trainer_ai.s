	.include "asm/macros.inc"
	.include "overlay_10.inc"
	.include "global.inc"

	.text

	thumb_func_start ov10_0221C278
ov10_0221C278: ; 0x0221C278
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #0xd5
	add r5, r1, #0
	lsl r0, r0, #2
	ldrb r0, [r5, r0]
	cmp r0, #2
	beq _0221C35E
	mov r6, #0xd9
	lsl r6, r6, #2
	add r4, r6, #0
	sub r4, #0x10
_0221C290:
	cmp r0, #0
	beq _0221C29C
	cmp r0, #1
	beq _0221C2DC
	cmp r0, #2
	b _0221C354
_0221C29C:
	ldr r1, _0221C360 ; =0x00000365
	ldr r0, _0221C364 ; =0x00002134
	ldrb r1, [r5, r1]
	ldr r0, [r5, r0]
	lsl r1, r1, #2
	ldr r1, [r0, r1]
	ldr r0, _0221C368 ; =0x00002138
	str r1, [r5, r0]
	ldr r0, _0221C36C ; =0x000003CF
	ldrb r1, [r5, r0]
	mov r0, #0xc0
	mul r0, r1
	add r3, r5, r0
	ldr r0, _0221C370 ; =0x00000355
	ldrb r2, [r5, r0]
	ldr r0, _0221C374 ; =0x00002D6C
	add r1, r3, r2
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _0221C2C8
	mov r1, #0
	b _0221C2D0
_0221C2C8:
	lsl r0, r2, #1
	add r1, r3, r0
	ldr r0, _0221C378 ; =0x00002D4C
	ldrh r1, [r1, r0]
_0221C2D0:
	ldr r0, _0221C37C ; =0x00000356
	strh r1, [r5, r0]
	ldrb r0, [r5, r4]
	add r0, r0, #1
	strb r0, [r5, r4]
	b _0221C354
_0221C2DC:
	ldr r0, _0221C37C ; =0x00000356
	ldrh r0, [r5, r0]
	cmp r0, #0
	beq _0221C2FE
	ldr r3, _0221C368 ; =0x00002138
	ldr r2, _0221C364 ; =0x00002134
	ldr r3, [r5, r3]
	ldr r2, [r5, r2]
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	add r0, r7, #0
	lsl r3, r2, #2
	ldr r2, _0221C380 ; =ov10_0222B0B4
	add r1, r5, #0
	ldr r2, [r2, r3]
	blx r2
	b _0221C314
_0221C2FE:
	ldr r0, _0221C370 ; =0x00000355
	mov r1, #0
	ldrb r0, [r5, r0]
	add r2, r5, r0
	mov r0, #0xd6
	lsl r0, r0, #2
	strb r1, [r2, r0]
	ldrb r1, [r5, r6]
	mov r0, #1
	orr r0, r1
	strb r0, [r5, r6]
_0221C314:
	mov r0, #0xd9
	lsl r0, r0, #2
	ldrb r1, [r5, r0]
	mov r0, #1
	tst r0, r1
	beq _0221C354
	ldr r0, _0221C370 ; =0x00000355
	ldrb r0, [r5, r0]
	add r1, r0, #1
	ldr r0, _0221C370 ; =0x00000355
	strb r1, [r5, r0]
	ldrb r0, [r5, r0]
	cmp r0, #4
	bhs _0221C346
	mov r0, #0xd9
	lsl r0, r0, #2
	ldrb r1, [r5, r0]
	mov r0, #8
	tst r0, r1
	bne _0221C346
	mov r0, #0xd5
	mov r1, #0
	lsl r0, r0, #2
	strb r1, [r5, r0]
	b _0221C34C
_0221C346:
	ldrb r0, [r5, r4]
	add r0, r0, #1
	strb r0, [r5, r4]
_0221C34C:
	ldrb r1, [r5, r6]
	mov r0, #0xfe
	and r0, r1
	strb r0, [r5, r6]
_0221C354:
	mov r0, #0xd5
	lsl r0, r0, #2
	ldrb r0, [r5, r0]
	cmp r0, #2
	bne _0221C290
_0221C35E:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221C360: .word 0x00000365
_0221C364: .word 0x00002134
_0221C368: .word 0x00002138
_0221C36C: .word 0x000003CF
_0221C370: .word 0x00000355
_0221C374: .word 0x00002D6C
_0221C378: .word 0x00002D4C
_0221C37C: .word 0x00000356
_0221C380: .word ov10_0222B0B4
	thumb_func_end ov10_0221C278

	thumb_func_start ov10_0221C384
ov10_0221C384: ; 0x0221C384
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r7, r0, #0
	add r0, r6, #0
	bl BattleSystem_Random
	lsr r2, r0, #0x1f
	lsl r1, r0, #0x18
	sub r1, r1, r2
	mov r0, #0x18
	ror r1, r0
	add r0, r2, r1
	cmp r0, r4
	bge _0221C3C0
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C3C0:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C384

	thumb_func_start ov10_0221C3C4
ov10_0221C3C4: ; 0x0221C3C4
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r7, r0, #0
	add r0, r6, #0
	bl BattleSystem_Random
	lsr r2, r0, #0x1f
	lsl r1, r0, #0x18
	sub r1, r1, r2
	mov r0, #0x18
	ror r1, r0
	add r0, r2, r1
	cmp r0, r4
	ble _0221C400
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C400:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C3C4

	thumb_func_start ov10_0221C404
ov10_0221C404: ; 0x0221C404
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r7, r0, #0
	add r0, r6, #0
	bl BattleSystem_Random
	lsr r2, r0, #0x1f
	lsl r1, r0, #0x18
	sub r1, r1, r2
	mov r0, #0x18
	ror r1, r0
	add r0, r2, r1
	cmp r4, r0
	bne _0221C440
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C440:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C404

	thumb_func_start ov10_0221C444
ov10_0221C444: ; 0x0221C444
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r7, r0, #0
	add r0, r6, #0
	bl BattleSystem_Random
	lsr r2, r0, #0x1f
	lsl r1, r0, #0x18
	sub r1, r1, r2
	mov r0, #0x18
	ror r1, r0
	add r0, r2, r1
	cmp r4, r0
	beq _0221C480
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C480:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C444

	thumb_func_start ov10_0221C484
ov10_0221C484: ; 0x0221C484
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	mov r2, #0xd6
	lsl r2, r2, #2
	sub r3, r2, #3
	ldrb r5, [r4, r3]
	add r1, r4, r2
	ldrsb r3, [r1, r5]
	add r0, r3, r0
	strb r0, [r1, r5]
	sub r0, r2, #3
	ldrb r2, [r4, r0]
	ldrsb r0, [r1, r2]
	cmp r0, #0
	bge _0221C4B4
	mov r0, #0
	strb r0, [r1, r2]
_0221C4B4:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C484

	thumb_func_start ov10_0221C4B8
ov10_0221C4B8: ; 0x0221C4B8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r3, _0221C50C ; =0x00002D8C
	add r2, r5, r1
	ldr r1, [r2, r3]
	mov r0, #0x64
	mul r0, r1
	add r1, r3, #4
	ldr r1, [r2, r1]
	bl _u32_div_f
	cmp r0, r6
	bhs _0221C508
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C508:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C50C: .word 0x00002D8C
	thumb_func_end ov10_0221C4B8

	thumb_func_start ov10_0221C510
ov10_0221C510: ; 0x0221C510
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r3, _0221C564 ; =0x00002D8C
	add r2, r5, r1
	ldr r1, [r2, r3]
	mov r0, #0x64
	mul r0, r1
	add r1, r3, #4
	ldr r1, [r2, r1]
	bl _u32_div_f
	cmp r0, r6
	bls _0221C560
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C560:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C564: .word 0x00002D8C
	thumb_func_end ov10_0221C510

	thumb_func_start ov10_0221C568
ov10_0221C568: ; 0x0221C568
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r3, _0221C5BC ; =0x00002D8C
	add r2, r5, r1
	ldr r1, [r2, r3]
	mov r0, #0x64
	mul r0, r1
	add r1, r3, #4
	ldr r1, [r2, r1]
	bl _u32_div_f
	cmp r0, r6
	bne _0221C5B8
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C5B8:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C5BC: .word 0x00002D8C
	thumb_func_end ov10_0221C568

	thumb_func_start ov10_0221C5C0
ov10_0221C5C0: ; 0x0221C5C0
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r3, _0221C614 ; =0x00002D8C
	add r2, r5, r1
	ldr r1, [r2, r3]
	mov r0, #0x64
	mul r0, r1
	add r1, r3, #4
	ldr r1, [r2, r1]
	bl _u32_div_f
	cmp r0, r6
	beq _0221C610
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C610:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C614: .word 0x00002D8C
	thumb_func_end ov10_0221C5C0

	thumb_func_start ov10_0221C618
ov10_0221C618: ; 0x0221C618
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221C660 ; =0x00002DAC
	add r1, r5, r1
	ldr r0, [r1, r0]
	tst r0, r6
	beq _0221C65C
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C65C:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C660: .word 0x00002DAC
	thumb_func_end ov10_0221C618

	thumb_func_start ov10_0221C664
ov10_0221C664: ; 0x0221C664
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221C6AC ; =0x00002DAC
	add r1, r5, r1
	ldr r0, [r1, r0]
	tst r0, r6
	bne _0221C6A8
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C6A8:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C6AC: .word 0x00002DAC
	thumb_func_end ov10_0221C664

	thumb_func_start ov10_0221C6B0
ov10_0221C6B0: ; 0x0221C6B0
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221C6F8 ; =0x00002DB0
	add r1, r5, r1
	ldr r0, [r1, r0]
	tst r0, r6
	beq _0221C6F4
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C6F4:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C6F8: .word 0x00002DB0
	thumb_func_end ov10_0221C6B0

	thumb_func_start ov10_0221C6FC
ov10_0221C6FC: ; 0x0221C6FC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221C744 ; =0x00002DB0
	add r1, r5, r1
	ldr r0, [r1, r0]
	tst r0, r6
	bne _0221C740
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C740:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C744: .word 0x00002DB0
	thumb_func_end ov10_0221C6FC

	thumb_func_start ov10_0221C748
ov10_0221C748: ; 0x0221C748
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	mov r0, #0xb7
	add r1, r5, r1
	lsl r0, r0, #6
	ldr r0, [r1, r0]
	tst r0, r6
	beq _0221C78E
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C78E:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov10_0221C748

	thumb_func_start ov10_0221C790
ov10_0221C790: ; 0x0221C790
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	add r7, r0, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	mov r0, #0xb7
	add r1, r5, r1
	lsl r0, r0, #6
	ldr r0, [r1, r0]
	tst r0, r6
	bne _0221C7D6
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221C7D6:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov10_0221C790

	thumb_func_start ov10_0221C7D8
ov10_0221C7D8: ; 0x0221C7D8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	str r0, [sp]
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r1, r0, #0
	add r0, r7, #0
	bl BattleSystem_GetFieldSide
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0x6f
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	tst r0, r6
	beq _0221C826
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
_0221C826:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov10_0221C7D8

	thumb_func_start ov10_0221C828
ov10_0221C828: ; 0x0221C828
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	str r0, [sp]
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r1, r0, #0
	add r0, r7, #0
	bl BattleSystem_GetFieldSide
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0x6f
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	tst r0, r6
	bne _0221C876
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
_0221C876:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov10_0221C828

	thumb_func_start ov10_0221C878
ov10_0221C878: ; 0x0221C878
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
	mov r0, #0xd7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, r4
	bge _0221C8A4
	add r0, r5, #0
	bl ov10_0221EF24
_0221C8A4:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C878

	thumb_func_start ov10_0221C8A8
ov10_0221C8A8: ; 0x0221C8A8
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
	mov r0, #0xd7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, r4
	ble _0221C8D4
	add r0, r5, #0
	bl ov10_0221EF24
_0221C8D4:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C8A8

	thumb_func_start ov10_0221C8D8
ov10_0221C8D8: ; 0x0221C8D8
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
	mov r0, #0xd7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, r4
	bne _0221C904
	add r0, r5, #0
	bl ov10_0221EF24
_0221C904:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C8D8

	thumb_func_start ov10_0221C908
ov10_0221C908: ; 0x0221C908
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
	mov r0, #0xd7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, r4
	beq _0221C934
	add r0, r5, #0
	bl ov10_0221EF24
_0221C934:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C908

	thumb_func_start ov10_0221C938
ov10_0221C938: ; 0x0221C938
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
	mov r0, #0xd7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	tst r0, r4
	beq _0221C964
	add r0, r5, #0
	bl ov10_0221EF24
_0221C964:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C938

	thumb_func_start ov10_0221C968
ov10_0221C968: ; 0x0221C968
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
	mov r0, #0xd7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	tst r0, r4
	bne _0221C994
	add r0, r5, #0
	bl ov10_0221EF24
_0221C994:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C968

	thumb_func_start ov10_0221C998
ov10_0221C998: ; 0x0221C998
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
	ldr r0, _0221C9C4 ; =0x00000356
	ldrh r0, [r5, r0]
	cmp r0, r4
	bne _0221C9C2
	add r0, r5, #0
	bl ov10_0221EF24
_0221C9C2:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221C9C4: .word 0x00000356
	thumb_func_end ov10_0221C998

	thumb_func_start ov10_0221C9C8
ov10_0221C9C8: ; 0x0221C9C8
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
	ldr r0, _0221C9F4 ; =0x00000356
	ldrh r0, [r5, r0]
	cmp r0, r4
	beq _0221C9F2
	add r0, r5, #0
	bl ov10_0221EF24
_0221C9F2:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221C9F4: .word 0x00000356
	thumb_func_end ov10_0221C9C8

	thumb_func_start ov10_0221C9F8
ov10_0221C9F8: ; 0x0221C9F8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	str r0, [sp]
	add r0, r5, #0
	add r1, r4, #0
	bl ov10_0221EF10
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _0221CA48
	mov r6, #0xd7
	add r7, r1, #0
	lsl r6, r6, #2
_0221CA2A:
	ldr r1, [r5, r6]
	cmp r1, r0
	bne _0221CA3A
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221CA3A:
	add r4, r4, #1
	add r0, r5, #0
	add r1, r4, #0
	bl ov10_0221EF10
	cmp r0, r7
	bne _0221CA2A
_0221CA48:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221C9F8

	thumb_func_start ov10_0221CA4C
ov10_0221CA4C: ; 0x0221CA4C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	str r0, [sp]
	add r0, r5, #0
	add r1, r4, #0
	bl ov10_0221EF10
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _0221CA92
	mov r6, #0xd7
	add r7, r1, #0
	lsl r6, r6, #2
_0221CA7E:
	ldr r1, [r5, r6]
	cmp r1, r0
	beq _0221CA9A
	add r4, r4, #1
	add r0, r5, #0
	add r1, r4, #0
	bl ov10_0221EF10
	cmp r0, r7
	bne _0221CA7E
_0221CA92:
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
_0221CA9A:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov10_0221CA4C
