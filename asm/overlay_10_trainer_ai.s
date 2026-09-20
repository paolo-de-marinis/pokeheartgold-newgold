	.include "asm/macros.inc"
	.include "overlay_10.inc"
	.include "global.inc"

	.text

	thumb_func_start ov10_0221BF44
ov10_0221BF44: ; 0x0221BF44
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	str r0, [sp]
	add r5, r1, #0
	bl ov10_0221EE88
	mov r0, #0x36
	lsl r0, r0, #4
	ldr r1, [r5, r0]
	cmp r1, #0
	beq _0221BF9A
	add r6, r0, #0
	add r4, r0, #5
_0221BF5E:
	mov r0, #1
	tst r0, r1
	beq _0221BF80
	mov r0, #0xd9
	lsl r0, r0, #2
	ldrb r1, [r5, r0]
	mov r0, #0x10
	tst r0, r1
	bne _0221BF78
	mov r0, #0xd5
	mov r1, #0
	lsl r0, r0, #2
	strb r1, [r5, r0]
_0221BF78:
	ldr r0, [sp]
	add r1, r5, #0
	bl ov10_0221C278
_0221BF80:
	ldr r0, [r5, r6]
	mov r1, #0
	lsr r0, r0, #1
	str r0, [r5, r6]
	ldrb r0, [r5, r4]
	add r0, r0, #1
	strb r0, [r5, r4]
	ldr r0, _0221C030 ; =0x00000355
	strb r1, [r5, r0]
	add r0, #0xb
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _0221BF5E
_0221BF9A:
	mov r3, #0xd9
	lsl r3, r3, #2
	ldrb r1, [r5, r3]
	mov r0, #2
	tst r0, r1
	beq _0221BFAA
	mov r0, #4
	b _0221C01C
_0221BFAA:
	mov r0, #4
	tst r0, r1
	beq _0221BFB4
	mov r0, #5
	b _0221C01C
_0221BFB4:
	add r0, r3, #0
	sub r0, #0xc
	ldrsb r0, [r5, r0]
	add r1, sp, #4
	mov r4, #1
	strb r0, [r1, #4]
	mov r0, #0
	strb r0, [r1]
	add r3, #0x6b
	ldrb r3, [r5, r3]
	mov r0, #0xc0
	add r2, r4, #0
	mul r0, r3
	add r0, r5, r0
	add r3, r0, #2
_0221BFD2:
	ldr r0, _0221C034 ; =0x00002D4C
	ldrh r0, [r3, r0]
	cmp r0, #0
	beq _0221C004
	mov r0, #0xd6
	add r6, r5, r2
	lsl r0, r0, #2
	ldrsb r6, [r6, r0]
	ldrb r0, [r1, #4]
	cmp r0, r6
	bne _0221BFF8
	add r0, sp, #8
	strb r6, [r0, r4]
	add r0, r4, #1
	lsl r0, r0, #0x18
	add r7, r4, #0
	lsr r4, r0, #0x18
	add r0, sp, #4
	strb r2, [r0, r7]
_0221BFF8:
	ldrb r0, [r1, #4]
	cmp r0, r6
	bge _0221C004
	strb r6, [r1, #4]
	mov r4, #1
	strb r2, [r1]
_0221C004:
	add r2, r2, #1
	add r3, r3, #2
	cmp r2, #4
	blt _0221BFD2
	ldr r0, [sp]
	bl BattleSystem_Random
	add r1, r4, #0
	bl _s32_div_f
	add r0, sp, #4
	ldrb r0, [r0, r1]
_0221C01C:
	mov r2, #0x3d
	lsl r2, r2, #4
	sub r1, r2, #1
	ldrb r1, [r5, r1]
	ldrb r3, [r5, r2]
	add r2, #0xa
	add r1, r5, r1
	strb r3, [r1, r2]
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221C030: .word 0x00000355
_0221C034: .word 0x00002D4C
	thumb_func_end ov10_0221BF44

	thumb_func_start ov10_0221C038
ov10_0221C038: ; 0x0221C038
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r7, r0, #0
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, sp, #0x18
	add r5, r1, #0
	str r0, [sp, #4]
	add r0, sp, #0x20
	str r5, [sp, #8]
	str r0, [sp]
_0221C04E:
	ldr r0, _0221C264 ; =0x000003CF
	ldrb r2, [r5, r0]
	ldr r0, [sp, #0xc]
	cmp r0, r2
	beq _0221C062
	ldr r1, _0221C268 ; =0x00002D8C
	ldr r0, [sp, #8]
	ldr r0, [r0, r1]
	cmp r0, #0
	bne _0221C070
_0221C062:
	mov r1, #0
	ldr r0, [sp, #4]
	mvn r1, r1
	strb r1, [r0]
	ldr r0, [sp]
	strh r1, [r0]
	b _0221C190
_0221C070:
	add r0, r7, #0
	add r1, r5, #0
	mov r3, #0xf
	bl ov10_0221BE20
	mov r1, #0x3d
	ldr r0, [sp, #0xc]
	lsl r1, r1, #4
	strb r0, [r5, r1]
	sub r1, r1, #1
	mov r2, #1
	ldrb r1, [r5, r1]
	and r0, r2
	and r1, r2
	cmp r0, r1
	beq _0221C098
	add r0, r7, #0
	add r1, r5, #0
	bl ov10_0221EE88
_0221C098:
	ldr r0, _0221C26C ; =0x00000365
	mov r2, #0
	add r1, r0, #0
	strb r2, [r5, r0]
	sub r1, #0x10
	strb r2, [r5, r1]
	sub r0, r0, #5
	ldr r4, [r5, r0]
	cmp r4, #0
	beq _0221C0E2
	ldr r6, _0221C26C ; =0x00000365
_0221C0AE:
	mov r0, #1
	tst r0, r4
	beq _0221C0D0
	mov r0, #0xd9
	lsl r0, r0, #2
	ldrb r1, [r5, r0]
	mov r0, #0x10
	tst r0, r1
	bne _0221C0C8
	mov r0, #0xd5
	mov r1, #0
	lsl r0, r0, #2
	strb r1, [r5, r0]
_0221C0C8:
	add r0, r7, #0
	add r1, r5, #0
	bl ov10_0221C278
_0221C0D0:
	ldrb r0, [r5, r6]
	asr r4, r4, #1
	mov r1, #0
	add r0, r0, #1
	strb r0, [r5, r6]
	ldr r0, _0221C270 ; =0x00000355
	cmp r4, #0
	strb r1, [r5, r0]
	bne _0221C0AE
_0221C0E2:
	mov r2, #0xd9
	lsl r2, r2, #2
	ldrb r1, [r5, r2]
	mov r0, #2
	tst r0, r1
	beq _0221C0F6
	ldr r0, [sp, #4]
	mov r1, #4
	strb r1, [r0]
	b _0221C190
_0221C0F6:
	mov r0, #4
	tst r0, r1
	beq _0221C104
	ldr r0, [sp, #4]
	mov r1, #5
	strb r1, [r0]
	b _0221C190
_0221C104:
	add r0, r2, #0
	sub r0, #0xc
	ldrsb r1, [r5, r0]
	add r0, sp, #0x10
	add r2, #0x6b
	strb r1, [r0, #4]
	mov r1, #0
	strb r1, [r0]
	ldrb r3, [r5, r2]
	mov r2, #0xc0
	mov r4, #1
	mul r2, r3
	add r2, r5, r2
	add r1, r4, #0
	add r2, r2, #2
_0221C122:
	ldr r3, _0221C274 ; =0x00002D4C
	ldrh r3, [r2, r3]
	cmp r3, #0
	beq _0221C14E
	mov r3, #0xd6
	add r6, r5, r1
	lsl r3, r3, #2
	ldrsb r3, [r6, r3]
	ldrb r6, [r0, #4]
	cmp r6, r3
	bne _0221C142
	add r6, sp, #0x14
	strb r3, [r6, r4]
	add r6, sp, #0x10
	strb r1, [r6, r4]
	add r4, r4, #1
_0221C142:
	ldrb r6, [r0, #4]
	cmp r6, r3
	bge _0221C14E
	strb r3, [r0, #4]
	strb r1, [r0]
	mov r4, #1
_0221C14E:
	add r1, r1, #1
	add r2, r2, #2
	cmp r1, #4
	blt _0221C122
	add r0, r7, #0
	bl BattleSystem_Random
	add r1, r4, #0
	bl _s32_div_f
	add r0, sp, #0x10
	ldrb r1, [r0, r1]
	ldr r0, [sp, #4]
	strb r1, [r0]
	add r0, sp, #0x10
	ldrb r1, [r0, #4]
	ldr r0, [sp]
	strh r1, [r0]
	ldr r0, _0221C264 ; =0x000003CF
	ldrb r1, [r5, r0]
	mov r0, #2
	eor r1, r0
	ldr r0, [sp, #0xc]
	cmp r0, r1
	bne _0221C190
	ldr r0, [sp]
	mov r1, #0
	ldrsh r0, [r0, r1]
	cmp r0, #0x64
	bge _0221C190
	ldr r0, [sp]
	sub r1, r1, #1
	strh r1, [r0]
_0221C190:
	ldr r0, [sp, #8]
	add r0, #0xc0
	str r0, [sp, #8]
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	ldr r0, [sp]
	add r0, r0, #2
	str r0, [sp]
	ldr r0, [sp, #0xc]
	add r0, r0, #1
	str r0, [sp, #0xc]
	cmp r0, #4
	bge _0221C1AE
	b _0221C04E
_0221C1AE:
	mov r1, #0x10
	add r0, sp, #0x10
	ldrsh r1, [r0, r1]
	mov r2, #0
	mov r6, #1
	strb r2, [r0, #0xc]
	add r2, sp, #0x20
	add r4, r6, #0
	add r2, #2
_0221C1C0:
	mov r0, #0
	ldrsh r3, [r2, r0]
	cmp r1, r3
	bne _0221C1CE
	add r0, sp, #0x1c
	strb r4, [r0, r6]
	add r6, r6, #1
_0221C1CE:
	cmp r1, r3
	bge _0221C1DA
	add r0, sp, #0x10
	add r1, r3, #0
	strb r4, [r0, #0xc]
	mov r6, #1
_0221C1DA:
	add r4, r4, #1
	add r2, r2, #2
	cmp r4, #4
	blt _0221C1C0
	add r0, r7, #0
	bl BattleSystem_Random
	add r1, r6, #0
	bl _s32_div_f
	add r0, sp, #0x1c
	ldrb r3, [r0, r1]
	ldr r0, _0221C264 ; =0x000003CF
	ldrb r1, [r5, r0]
	add r2, r5, r1
	add r1, r0, #0
	add r1, #0xb
	strb r3, [r2, r1]
	ldrb r2, [r5, r0]
	add r1, r0, #0
	add r1, #0xb
	add r3, r5, r2
	ldrb r1, [r3, r1]
	add r3, sp, #0x18
	add r0, #0x17
	ldrsb r4, [r3, r1]
	mov r3, #0xc0
	mul r3, r2
	add r3, r5, r3
	lsl r2, r4, #1
	add r3, r3, r2
	ldr r2, _0221C274 ; =0x00002D4C
	ldrh r6, [r3, r2]
	lsl r2, r6, #4
	add r2, r5, r2
	ldrh r2, [r2, r0]
	mov r0, #2
	lsl r0, r0, #8
	cmp r2, r0
	bne _0221C23E
	add r0, r7, #0
	bl BattleSystem_GetFieldSide
	cmp r0, #0
	bne _0221C23E
	ldr r0, _0221C264 ; =0x000003CF
	ldrb r2, [r5, r0]
	add r0, #0xb
	add r1, r5, r2
	strb r2, [r1, r0]
_0221C23E:
	cmp r6, #0xae
	bne _0221C25C
	ldr r2, _0221C264 ; =0x000003CF
	add r0, r5, #0
	ldrb r2, [r5, r2]
	add r1, r6, #0
	bl CurseUserIsGhost
	cmp r0, #0
	bne _0221C25C
	ldr r0, _0221C264 ; =0x000003CF
	ldrb r2, [r5, r0]
	add r0, #0xb
	add r1, r5, r2
	strb r2, [r1, r0]
_0221C25C:
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221C264: .word 0x000003CF
_0221C268: .word 0x00002D8C
_0221C26C: .word 0x00000365
_0221C270: .word 0x00000355
_0221C274: .word 0x00002D4C
	thumb_func_end ov10_0221C038

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

	thumb_func_start ov10_0221CA9C
ov10_0221CA9C: ; 0x0221CA9C
	push {r3, r4, r5, r6, r7, lr}
	add r6, r1, #0
	add r0, r6, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r6, #0
	bl ov10_0221EEF0
	ldr r1, _0221CAF4 ; =0x000003CF
	mov ip, r0
	ldrb r2, [r6, r1]
	mov r1, #0xc0
	mov r0, #0
	mul r1, r2
	add r3, r6, r1
	ldr r7, _0221CAF8 ; =0x00002D4C
	add r1, r3, #0
	add r2, r0, #0
_0221CAC2:
	ldrh r4, [r1, r7]
	cmp r4, #0
	beq _0221CADA
	ldr r4, _0221CAF8 ; =0x00002D4C
	add r5, r3, r2
	ldrh r4, [r5, r4]
	lsl r4, r4, #4
	add r5, r6, r4
	ldr r4, _0221CAFC ; =0x000003E1
	ldrb r4, [r5, r4]
	cmp r4, #0
	bne _0221CAE4
_0221CADA:
	add r0, r0, #1
	add r1, r1, #2
	add r2, r2, #2
	cmp r0, #4
	blt _0221CAC2
_0221CAE4:
	cmp r0, #4
	bge _0221CAF0
	add r0, r6, #0
	mov r1, ip
	bl ov10_0221EF24
_0221CAF0:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CAF4: .word 0x000003CF
_0221CAF8: .word 0x00002D4C
_0221CAFC: .word 0x000003E1
	thumb_func_end ov10_0221CA9C

	thumb_func_start ov10_0221CB00
ov10_0221CB00: ; 0x0221CB00
	push {r3, r4, r5, r6, r7, lr}
	add r6, r1, #0
	add r0, r6, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r6, #0
	bl ov10_0221EEF0
	ldr r1, _0221CB58 ; =0x000003CF
	mov ip, r0
	ldrb r2, [r6, r1]
	mov r1, #0xc0
	mov r0, #0
	mul r1, r2
	add r3, r6, r1
	ldr r7, _0221CB5C ; =0x00002D4C
	add r1, r3, #0
	add r2, r0, #0
_0221CB26:
	ldrh r4, [r1, r7]
	cmp r4, #0
	beq _0221CB3E
	ldr r4, _0221CB5C ; =0x00002D4C
	add r5, r3, r2
	ldrh r4, [r5, r4]
	lsl r4, r4, #4
	add r5, r6, r4
	ldr r4, _0221CB60 ; =0x000003E1
	ldrb r4, [r5, r4]
	cmp r4, #0
	bne _0221CB48
_0221CB3E:
	add r0, r0, #1
	add r1, r1, #2
	add r2, r2, #2
	cmp r0, #4
	blt _0221CB26
_0221CB48:
	cmp r0, #4
	bne _0221CB54
	add r0, r6, #0
	mov r1, ip
	bl ov10_0221EF24
_0221CB54:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CB58: .word 0x000003CF
_0221CB5C: .word 0x00002D4C
_0221CB60: .word 0x000003E1
	thumb_func_end ov10_0221CB00

	thumb_func_start ov10_0221CB64
ov10_0221CB64: ; 0x0221CB64
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov10_0221CB64

	thumb_func_start ov10_0221CB80
ov10_0221CB80: ; 0x0221CB80
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	cmp r0, #8
	bls _0221CB9A
	b _0221CCA4
_0221CB9A:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221CBA6: ; jump table
	.short _0221CBCE - _0221CBA6 - 2 ; case 0
	.short _0221CBB8 - _0221CBA6 - 2 ; case 1
	.short _0221CBFC - _0221CBA6 - 2 ; case 2
	.short _0221CBE6 - _0221CBA6 - 2 ; case 3
	.short _0221CC14 - _0221CBA6 - 2 ; case 4
	.short _0221CC46 - _0221CBA6 - 2 ; case 5
	.short _0221CC28 - _0221CBA6 - 2 ; case 6
	.short _0221CC84 - _0221CBA6 - 2 ; case 7
	.short _0221CC66 - _0221CBA6 - 2 ; case 8
_0221CBB8:
	ldr r1, _0221CCAC ; =0x000003CF
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #0x1b
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CBCE:
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x1b
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CBE6:
	ldr r1, _0221CCAC ; =0x000003CF
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #0x1c
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CBFC:
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x1c
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CC14:
	ldr r0, _0221CCB0 ; =0x00000356
	ldrh r1, [r4, r0]
	lsl r1, r1, #4
	add r2, r4, r1
	add r1, r0, #0
	add r1, #0x8c
	ldrb r1, [r2, r1]
	add r0, r0, #6
	str r1, [r4, r0]
	pop {r3, r4, r5, pc}
_0221CC28:
	ldr r1, _0221CCAC ; =0x000003CF
	add r0, r5, #0
	ldrb r1, [r4, r1]
	bl BattleSystem_GetBattlerIdPartner
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0x1b
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CC46:
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r1, [r4, r1]
	add r0, r5, #0
	bl BattleSystem_GetBattlerIdPartner
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0x1b
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CC66:
	ldr r1, _0221CCAC ; =0x000003CF
	add r0, r5, #0
	ldrb r1, [r4, r1]
	bl BattleSystem_GetBattlerIdPartner
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0x1c
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CC84:
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r1, [r4, r1]
	add r0, r5, #0
	bl BattleSystem_GetBattlerIdPartner
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0x1b
	mov r3, #0
	bl GetBattlerVar
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r3, r4, r5, pc}
_0221CCA4:
	bl GF_AssertFail
	pop {r3, r4, r5, pc}
	nop
_0221CCAC: .word 0x000003CF
_0221CCB0: .word 0x00000356
	thumb_func_end ov10_0221CB80

	thumb_func_start ov10_0221CCB4
ov10_0221CCB4: ; 0x0221CCB4
	push {r4, r5, r6, lr}
	add r5, r1, #0
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
	add r6, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #0x1b
	mov r3, #0
	bl GetBattlerVar
	cmp r4, r0
	beq _0221CCFC
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #0x1c
	mov r3, #0
	bl GetBattlerVar
	cmp r4, r0
	bne _0221CD06
_0221CCFC:
	mov r0, #0xd7
	mov r1, #1
	lsl r0, r0, #2
	str r1, [r5, r0]
	pop {r4, r5, r6, pc}
_0221CD06:
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r5, r0]
	pop {r4, r5, r6, pc}
	thumb_func_end ov10_0221CCB4

	thumb_func_start ov10_0221CD10
ov10_0221CD10: ; 0x0221CD10
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, _0221CD30 ; =0x00000356
	ldrh r1, [r4, r0]
	lsl r1, r1, #4
	add r2, r4, r1
	add r1, r0, #0
	add r1, #0x8b
	ldrb r1, [r2, r1]
	add r0, r0, #6
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221CD30: .word 0x00000356
	thumb_func_end ov10_0221CD10

	thumb_func_start ov10_0221CD34
ov10_0221CD34: ; 0x0221CD34
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x38
	add r6, r1, #0
	str r0, [sp, #0x18]
	add r0, r6, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r6, #0
	bl ov10_0221EEF0
	ldr r2, _0221CE50 ; =0x00000356
	str r0, [sp, #0x1c]
	ldrh r3, [r6, r2]
	add r2, #0x88
	ldr r1, _0221CE54 ; =ov10_0222B098
	lsl r7, r3, #4
	add r3, r6, r7
	ldrh r3, [r3, r2]
	ldr r2, _0221CE58 ; =0x0000FFFF
	mov r0, #0
_0221CD5E:
	ldrh r4, [r1]
	cmp r3, r4
	beq _0221CD6E
	add r1, r1, #2
	ldrh r4, [r1]
	add r0, r0, #1
	cmp r4, r2
	bne _0221CD5E
_0221CD6E:
	ldr r2, _0221CE5C ; =ov10_0222B080
	ldr r4, _0221CE58 ; =0x0000FFFF
	mov r1, #0
_0221CD74:
	ldrh r5, [r2]
	cmp r3, r5
	beq _0221CD84
	add r2, r2, #2
	ldrh r5, [r2]
	add r1, r1, #1
	cmp r5, r4
	bne _0221CD74
_0221CD84:
	lsl r2, r1, #1
	ldr r1, _0221CE5C ; =ov10_0222B080
	ldrh r1, [r1, r2]
	ldr r2, _0221CE58 ; =0x0000FFFF
	cmp r1, r2
	bne _0221CDA4
	ldr r1, _0221CE60 ; =0x000003E1
	add r3, r6, r7
	ldrb r1, [r3, r1]
	cmp r1, #1
	bls _0221CE42
	lsl r1, r0, #1
	ldr r0, _0221CE54 ; =ov10_0222B098
	ldrh r0, [r0, r1]
	cmp r0, r2
	bne _0221CE42
_0221CDA4:
	ldr r7, _0221CE64 ; =0x000003CF
	mov r4, #0
	add r5, sp, #0x20
_0221CDAA:
	ldrb r1, [r6, r7]
	add r2, r4, #0
	add r0, r6, #0
	add r2, #0xa
	mov r3, #0
	bl GetBattlerVar
	strb r0, [r5]
	add r4, r4, #1
	add r5, r5, #1
	cmp r4, #6
	blt _0221CDAA
	ldr r0, _0221CE64 ; =0x000003CF
	ldrb r4, [r6, r0]
	mov r0, #0xc0
	add r5, r4, #0
	mul r5, r0
	add r0, r6, #0
	add r1, r4, #0
	bl GetBattlerAbility
	add r1, sp, #0x28
	str r1, [sp]
	ldr r3, _0221CE68 ; =0x00002DB8
	add r1, r6, r5
	ldrh r1, [r1, r3]
	add r2, r4, #0
	str r1, [sp, #4]
	add r1, sp, #0x20
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	mov r0, #0xc0
	mul r0, r4
	add r1, r6, r0
	add r0, r3, #0
	add r0, #0x14
	ldr r0, [r1, r0]
	sub r3, #0x6c
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1d
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x1c]
	add r3, r6, r3
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x18]
	add r1, r6, #0
	add r3, r3, r5
	bl ov10_0221EF7C
	ldr r0, _0221CE6C ; =0x00000355
	add r1, sp, #0x28
	ldrb r0, [r6, r0]
	mov r3, #0
	lsl r0, r0, #2
	ldr r2, [r1, r0]
_0221CE18:
	ldr r0, [r1]
	cmp r0, r2
	bgt _0221CE26
	add r3, r3, #1
	add r1, r1, #4
	cmp r3, #4
	blt _0221CE18
_0221CE26:
	cmp r3, #4
	bne _0221CE36
	mov r0, #0xd7
	mov r1, #2
	lsl r0, r0, #2
	add sp, #0x38
	str r1, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0221CE36:
	mov r0, #0xd7
	mov r1, #1
	lsl r0, r0, #2
	add sp, #0x38
	str r1, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0221CE42:
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r6, r0]
	add sp, #0x38
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CE50: .word 0x00000356
_0221CE54: .word ov10_0222B098
_0221CE58: .word 0x0000FFFF
_0221CE5C: .word ov10_0222B080
_0221CE60: .word 0x000003E1
_0221CE64: .word 0x000003CF
_0221CE68: .word 0x00002DB8
_0221CE6C: .word 0x00000355
	thumb_func_end ov10_0221CD34

	thumb_func_start ov10_0221CE70
ov10_0221CE70: ; 0x0221CE70
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
	lsl r0, r0, #1
	add r1, r4, r0
	ldr r0, _0221CEA0 ; =0x0000307C
	ldrh r1, [r1, r0]
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0221CEA0: .word 0x0000307C
	thumb_func_end ov10_0221CE70

	thumb_func_start ov10_0221CEA4
ov10_0221CEA4: ; 0x0221CEA4
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
	cmp r4, r0
	bne _0221CED0
	add r0, r5, #0
	bl ov10_0221EF24
_0221CED0:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221CEA4

	thumb_func_start ov10_0221CED4
ov10_0221CED4: ; 0x0221CED4
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
	cmp r4, r0
	beq _0221CF00
	add r0, r5, #0
	bl ov10_0221EF24
_0221CF00:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov10_0221CED4

	thumb_func_start ov10_0221CF04
ov10_0221CF04: ; 0x0221CF04
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
	mov r0, #1
	str r0, [sp]
	ldr r3, _0221CF44 ; =0x000003CF
	add r0, r6, #0
	ldrb r2, [r5, r3]
	add r3, r3, #1
	ldrb r3, [r5, r3]
	add r1, r5, #0
	bl CheckSortSpeed
	cmp r4, r0
	bne _0221CF42
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221CF42:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221CF44: .word 0x000003CF
	thumb_func_end ov10_0221CF04

	thumb_func_start ov10_0221CF48
ov10_0221CF48: ; 0x0221CF48
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
	mov r0, #1
	str r0, [sp]
	ldr r3, _0221CF88 ; =0x000003CF
	add r0, r6, #0
	ldrb r2, [r5, r3]
	add r3, r3, #1
	ldrb r3, [r5, r3]
	add r1, r5, #0
	bl CheckSortSpeed
	cmp r4, r0
	beq _0221CF86
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221CF86:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221CF88: .word 0x000003CF
	thumb_func_end ov10_0221CF48

	thumb_func_start ov10_0221CF8C
ov10_0221CF8C: ; 0x0221CF8C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r1, #0
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r2, r0, #0
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r5, r0]
	lsl r1, r2, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	str r0, [sp]
	ldr r1, [sp]
	add r0, r7, #0
	bl BattleSystem_GetParty
	str r0, [sp, #0xc]
	ldr r1, [r7, #0x2c]
	mov r0, #2
	tst r0, r1
	beq _0221CFE6
	ldr r0, [sp]
	add r1, r5, r0
	ldr r0, _0221D060 ; =0x0000219C
	ldrb r0, [r1, r0]
	ldr r1, [sp]
	str r0, [sp, #8]
	add r0, r7, #0
	bl BattleSystem_GetBattlerIdPartner
	add r1, r5, r0
	ldr r0, _0221D060 ; =0x0000219C
	ldrb r0, [r1, r0]
	str r0, [sp, #4]
	b _0221CFF2
_0221CFE6:
	ldr r0, [sp]
	add r1, r5, r0
	ldr r0, _0221D060 ; =0x0000219C
	ldrb r0, [r1, r0]
	str r0, [sp, #4]
	str r0, [sp, #8]
_0221CFF2:
	ldr r1, [sp]
	add r0, r7, #0
	mov r4, #0
	bl BattleSystem_GetPartySize
	cmp r0, #0
	ble _0221D05C
_0221D000:
	ldr r0, [sp, #0xc]
	add r1, r4, #0
	bl Party_GetMonByIndex
	ldr r1, [sp, #8]
	add r6, r0, #0
	cmp r4, r1
	beq _0221D04E
	ldr r1, [sp, #4]
	cmp r4, r1
	beq _0221D04E
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221D04E
	add r0, r6, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221D04E
	add r0, r6, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	ldr r1, _0221D064 ; =0x000001EE
	cmp r0, r1
	beq _0221D04E
	mov r0, #0xd7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r0, #1
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r5, r0]
_0221D04E:
	ldr r1, [sp]
	add r0, r7, #0
	add r4, r4, #1
	bl BattleSystem_GetPartySize
	cmp r4, r0
	blt _0221D000
_0221D05C:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D060: .word 0x0000219C
_0221D064: .word 0x000001EE
	thumb_func_end ov10_0221CF8C

	thumb_func_start ov10_0221D068
ov10_0221D068: ; 0x0221D068
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, _0221D080 ; =0x00000356
	ldrh r1, [r4, r0]
	add r0, r0, #6
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0221D080: .word 0x00000356
	thumb_func_end ov10_0221D068

	thumb_func_start ov10_0221D084
ov10_0221D084: ; 0x0221D084
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, _0221D0A4 ; =0x00000356
	ldrh r1, [r4, r0]
	lsl r1, r1, #4
	add r2, r4, r1
	add r1, r0, #0
	add r1, #0x88
	ldrh r1, [r2, r1]
	add r0, r0, #6
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221D0A4: .word 0x00000356
	thumb_func_end ov10_0221D084
