	.include "asm/macros.inc"
	.include "overlay_10.inc"
	.include "global.inc"

	.text

	thumb_func_start ov10_0221D260
ov10_0221D260: ; 0x0221D260
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r1, #0
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r0, #0
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [sp, #0x10]
	str r0, [r5, r1]
	add r4, r0, #0
_0221D27C:
	mov r0, #0
	str r0, [sp, #0x14]
	ldr r0, _0221D308 ; =0x000003CF
	ldrb r2, [r5, r0]
	mov r0, #0xc0
	mul r0, r2
	add r0, r5, r0
	add r1, r4, r0
	ldr r0, _0221D30C ; =0x00002D4C
	ldrh r6, [r1, r0]
	add r0, r7, #0
	add r1, r5, #0
	add r3, r6, #0
	bl ov10_0221F47C
	add r3, r0, #0
	cmp r6, #0
	beq _0221D2F8
	ldr r0, _0221D308 ; =0x000003CF
	add r1, r5, #0
	ldrb r0, [r5, r0]
	add r2, r6, #0
	str r0, [sp]
	mov r0, #0x3d
	lsl r0, r0, #4
	ldrb r0, [r5, r0]
	str r0, [sp, #4]
	mov r0, #0x28
	str r0, [sp, #8]
	add r0, sp, #0x14
	str r0, [sp, #0xc]
	add r0, r7, #0
	bl ov12_02251D28
	cmp r0, #0x78
	bne _0221D2C8
	mov r0, #0x50
	b _0221D2DE
_0221D2C8:
	cmp r0, #0xf0
	bne _0221D2D0
	mov r0, #0xa0
	b _0221D2DE
_0221D2D0:
	cmp r0, #0x1e
	bne _0221D2D8
	mov r0, #0x14
	b _0221D2DE
_0221D2D8:
	cmp r0, #0xf
	bne _0221D2DE
	mov r0, #0xa
_0221D2DE:
	ldr r2, [sp, #0x14]
	ldr r1, _0221D310 ; =0x00140808
	tst r1, r2
	beq _0221D2E8
	mov r0, #0
_0221D2E8:
	mov r1, #0xd7
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	cmp r1, r0
	bhs _0221D2F8
	mov r1, #0xd7
	lsl r1, r1, #2
	str r0, [r5, r1]
_0221D2F8:
	ldr r0, [sp, #0x10]
	add r4, r4, #2
	add r0, r0, #1
	str r0, [sp, #0x10]
	cmp r0, #4
	blt _0221D27C
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D308: .word 0x000003CF
_0221D30C: .word 0x00002D4C
_0221D310: .word 0x00140808
	thumb_func_end ov10_0221D260

	thumb_func_start ov10_0221D314
ov10_0221D314: ; 0x0221D314
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r7, r0, #0
	add r0, r4, #0
	bl ov10_0221EEF0
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0x14]
	ldr r3, _0221D3A4 ; =0x000003CF
	add r0, r5, #0
	ldrb r6, [r4, r3]
	sub r3, #0x79
	ldrh r3, [r4, r3]
	add r1, r4, #0
	add r2, r6, #0
	bl ov10_0221F47C
	mov r2, #0x3d
	str r6, [sp]
	lsl r2, r2, #4
	add r3, r0, #0
	ldrb r0, [r4, r2]
	sub r2, #0x7a
	add r1, r4, #0
	str r0, [sp, #4]
	mov r0, #0x28
	str r0, [sp, #8]
	add r0, sp, #0x14
	str r0, [sp, #0xc]
	ldrh r2, [r4, r2]
	add r0, r5, #0
	bl ov12_02251D28
	cmp r0, #0x78
	bne _0221D372
	mov r0, #0x50
	b _0221D388
_0221D372:
	cmp r0, #0xf0
	bne _0221D37A
	mov r0, #0xa0
	b _0221D388
_0221D37A:
	cmp r0, #0x1e
	bne _0221D382
	mov r0, #0x14
	b _0221D388
_0221D382:
	cmp r0, #0xf
	bne _0221D388
	mov r0, #0xa
_0221D388:
	ldr r2, [sp, #0x14]
	ldr r1, _0221D3A8 ; =0x00140808
	tst r1, r2
	beq _0221D392
	mov r0, #0
_0221D392:
	cmp r0, r7
	bne _0221D39E
	ldr r1, [sp, #0x10]
	add r0, r4, #0
	bl ov10_0221EF24
_0221D39E:
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221D3A4: .word 0x000003CF
_0221D3A8: .word 0x00140808
	thumb_func_end ov10_0221D314

	thumb_func_start ov10_0221D3AC
ov10_0221D3AC: ; 0x0221D3AC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r7, r0, #0
	str r1, [sp]
	add r0, r1, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, [sp]
	bl ov10_0221EEF0
	add r4, r0, #0
	ldr r0, [sp]
	bl ov10_0221EEF0
	str r0, [sp, #0x10]
	ldr r0, [sp]
	bl ov10_0221EEF0
	str r0, [sp, #0xc]
	lsl r1, r4, #0x18
	ldr r0, [sp]
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r6, r0, #0
	ldr r1, [r7, #0x2c]
	mov r0, #2
	tst r0, r1
	beq _0221D406
	ldr r0, [sp]
	add r1, r0, r6
	ldr r0, _0221D498 ; =0x0000219C
	ldrb r0, [r1, r0]
	add r1, r6, #0
	str r0, [sp, #8]
	add r0, r7, #0
	bl BattleSystem_GetBattlerIdPartner
	ldr r1, [sp]
	add r1, r1, r0
	ldr r0, _0221D498 ; =0x0000219C
	ldrb r0, [r1, r0]
	str r0, [sp, #4]
	b _0221D412
_0221D406:
	ldr r0, [sp]
	add r1, r0, r6
	ldr r0, _0221D498 ; =0x0000219C
	ldrb r0, [r1, r0]
	str r0, [sp, #4]
	str r0, [sp, #8]
_0221D412:
	add r0, r7, #0
	add r1, r6, #0
	bl BattleSystem_GetParty
	str r0, [sp, #0x14]
	add r0, r7, #0
	add r1, r6, #0
	mov r5, #0
	bl BattleSystem_GetPartySize
	cmp r0, #0
	ble _0221D494
_0221D42A:
	ldr r0, [sp, #0x14]
	add r1, r5, #0
	bl Party_GetMonByIndex
	ldr r1, [sp, #8]
	add r4, r0, #0
	cmp r5, r1
	beq _0221D486
	ldr r1, [sp, #4]
	cmp r5, r1
	beq _0221D486
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221D486
	add r0, r4, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221D486
	add r0, r4, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	ldr r1, _0221D49C ; =0x000001EE
	cmp r0, r1
	beq _0221D486
	add r0, r4, #0
	mov r1, #0xa0
	mov r2, #0
	bl GetMonData
	ldr r1, [sp, #0x10]
	tst r0, r1
	beq _0221D486
	ldr r0, [sp]
	ldr r1, [sp, #0xc]
	bl ov10_0221EF24
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
_0221D486:
	add r0, r7, #0
	add r1, r6, #0
	add r5, r5, #1
	bl BattleSystem_GetPartySize
	cmp r5, r0
	blt _0221D42A
_0221D494:
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D498: .word 0x0000219C
_0221D49C: .word 0x000001EE
	thumb_func_end ov10_0221D3AC

	thumb_func_start ov10_0221D4A0
ov10_0221D4A0: ; 0x0221D4A0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r7, r0, #0
	str r1, [sp]
	add r0, r1, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, [sp]
	bl ov10_0221EEF0
	add r4, r0, #0
	ldr r0, [sp]
	bl ov10_0221EEF0
	str r0, [sp, #0x10]
	ldr r0, [sp]
	bl ov10_0221EEF0
	str r0, [sp, #0xc]
	lsl r1, r4, #0x18
	ldr r0, [sp]
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r6, r0, #0
	ldr r1, [r7, #0x2c]
	mov r0, #2
	tst r0, r1
	beq _0221D4FA
	ldr r0, [sp]
	add r1, r0, r6
	ldr r0, _0221D58C ; =0x0000219C
	ldrb r0, [r1, r0]
	add r1, r6, #0
	str r0, [sp, #8]
	add r0, r7, #0
	bl BattleSystem_GetBattlerIdPartner
	ldr r1, [sp]
	add r1, r1, r0
	ldr r0, _0221D58C ; =0x0000219C
	ldrb r0, [r1, r0]
	str r0, [sp, #4]
	b _0221D506
_0221D4FA:
	ldr r0, [sp]
	add r1, r0, r6
	ldr r0, _0221D58C ; =0x0000219C
	ldrb r0, [r1, r0]
	str r0, [sp, #4]
	str r0, [sp, #8]
_0221D506:
	add r0, r7, #0
	add r1, r6, #0
	bl BattleSystem_GetParty
	str r0, [sp, #0x14]
	add r0, r7, #0
	add r1, r6, #0
	mov r5, #0
	bl BattleSystem_GetPartySize
	cmp r0, #0
	ble _0221D588
_0221D51E:
	ldr r0, [sp, #0x14]
	add r1, r5, #0
	bl Party_GetMonByIndex
	ldr r1, [sp, #8]
	add r4, r0, #0
	cmp r5, r1
	beq _0221D57A
	ldr r1, [sp, #4]
	cmp r5, r1
	beq _0221D57A
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221D57A
	add r0, r4, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221D57A
	add r0, r4, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	ldr r1, _0221D590 ; =0x000001EE
	cmp r0, r1
	beq _0221D57A
	add r0, r4, #0
	mov r1, #0xa0
	mov r2, #0
	bl GetMonData
	ldr r1, [sp, #0x10]
	tst r0, r1
	bne _0221D57A
	ldr r0, [sp]
	ldr r1, [sp, #0xc]
	bl ov10_0221EF24
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
_0221D57A:
	add r0, r7, #0
	add r1, r6, #0
	add r5, r5, #1
	bl BattleSystem_GetPartySize
	cmp r5, r0
	blt _0221D51E
_0221D588:
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D58C: .word 0x0000219C
_0221D590: .word 0x000001EE
	thumb_func_end ov10_0221D4A0

	thumb_func_start ov10_0221D594
ov10_0221D594: ; 0x0221D594
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	mov r1, #6
	lsl r1, r1, #6
	ldr r2, [r4, r1]
	mov r1, #3
	tst r1, r2
	beq _0221D5B8
	mov r1, #2
	str r1, [r4, r0]
_0221D5B8:
	mov r0, #6
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	mov r0, #0xc
	tst r0, r1
	beq _0221D5CC
	mov r0, #0xd7
	mov r1, #3
	lsl r0, r0, #2
	str r1, [r4, r0]
_0221D5CC:
	mov r0, #6
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	mov r0, #0x30
	tst r0, r1
	beq _0221D5E0
	mov r0, #0xd7
	mov r1, #1
	lsl r0, r0, #2
	str r1, [r4, r0]
_0221D5E0:
	mov r0, #6
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	mov r0, #0xc0
	tst r0, r1
	beq _0221D5F4
	mov r0, #0xd7
	mov r1, #4
	lsl r0, r0, #2
	str r1, [r4, r0]
_0221D5F4:
	mov r0, #6
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	mov r0, #2
	lsl r0, r0, #0xe
	tst r0, r1
	beq _0221D60A
	mov r0, #0xd7
	mov r1, #5
	lsl r0, r0, #2
	str r1, [r4, r0]
_0221D60A:
	pop {r4, pc}
	thumb_func_end ov10_0221D594

	thumb_func_start ov10_0221D60C
ov10_0221D60C: ; 0x0221D60C
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
	ldr r0, _0221D640 ; =0x00000356
	ldrh r2, [r5, r0]
	add r0, #0x88
	lsl r2, r2, #4
	add r2, r5, r2
	ldrh r0, [r2, r0]
	cmp r4, r0
	bne _0221D63E
	add r0, r5, #0
	bl ov10_0221EF24
_0221D63E:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D640: .word 0x00000356
	thumb_func_end ov10_0221D60C

	thumb_func_start ov10_0221D644
ov10_0221D644: ; 0x0221D644
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
	ldr r0, _0221D678 ; =0x00000356
	ldrh r2, [r5, r0]
	add r0, #0x88
	lsl r2, r2, #4
	add r2, r5, r2
	ldrh r0, [r2, r0]
	cmp r4, r0
	beq _0221D676
	add r0, r5, #0
	bl ov10_0221EF24
_0221D676:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D678: .word 0x00000356
	thumb_func_end ov10_0221D644

	thumb_func_start ov10_0221D67C
ov10_0221D67C: ; 0x0221D67C
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
	add r7, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	str r0, [sp]
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	add r0, r5, r1
	add r1, r0, r6
	ldr r0, _0221D6CC ; =0x00002D58
	ldrsb r0, [r1, r0]
	cmp r0, r7
	bge _0221D6CA
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
_0221D6CA:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D6CC: .word 0x00002D58
	thumb_func_end ov10_0221D67C

	thumb_func_start ov10_0221D6D0
ov10_0221D6D0: ; 0x0221D6D0
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
	add r7, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	str r0, [sp]
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	add r0, r5, r1
	add r1, r0, r6
	ldr r0, _0221D720 ; =0x00002D58
	ldrsb r0, [r1, r0]
	cmp r0, r7
	ble _0221D71E
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
_0221D71E:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D720: .word 0x00002D58
	thumb_func_end ov10_0221D6D0

	thumb_func_start ov10_0221D724
ov10_0221D724: ; 0x0221D724
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
	add r7, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	str r0, [sp]
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	add r0, r5, r1
	add r1, r0, r6
	ldr r0, _0221D774 ; =0x00002D58
	ldrsb r0, [r1, r0]
	cmp r7, r0
	bne _0221D772
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
_0221D772:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D774: .word 0x00002D58
	thumb_func_end ov10_0221D724

	thumb_func_start ov10_0221D778
ov10_0221D778: ; 0x0221D778
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
	add r7, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	lsl r1, r4, #0x18
	str r0, [sp]
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	add r0, r5, r1
	add r1, r0, r6
	ldr r0, _0221D7C8 ; =0x00002D58
	ldrsb r0, [r1, r0]
	cmp r7, r0
	beq _0221D7C6
	ldr r1, [sp]
	add r0, r5, #0
	bl ov10_0221EF24
_0221D7C6:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D7C8: .word 0x00002D58
	thumb_func_end ov10_0221D778

	thumb_func_start ov10_0221D7CC
ov10_0221D7CC: ; 0x0221D7CC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r6, r1, #0
	str r0, [sp, #0x14]
	add r0, r6, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r6, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r6, #0
	bl ov10_0221EEF0
	str r0, [sp, #0x1c]
	cmp r4, #1
	bne _0221D7FE
	ldr r0, _0221D8D4 ; =0x00000355
	ldrb r1, [r6, r0]
	add r0, #0x17
	add r1, r6, r1
	ldrb r0, [r1, r0]
	str r0, [sp, #0x18]
	b _0221D802
_0221D7FE:
	mov r0, #0x64
	str r0, [sp, #0x18]
_0221D802:
	ldr r2, _0221D8D8 ; =0x00000356
	ldr r1, _0221D8DC ; =ov10_0222B098
	ldrh r3, [r6, r2]
	add r2, #0x88
	mov r0, #0
	lsl r7, r3, #4
	add r3, r6, r7
	ldrh r3, [r3, r2]
	ldr r2, _0221D8E0 ; =0x0000FFFF
_0221D814:
	ldrh r4, [r1]
	cmp r3, r4
	beq _0221D824
	add r1, r1, #2
	ldrh r4, [r1]
	add r0, r0, #1
	cmp r4, r2
	bne _0221D814
_0221D824:
	ldr r2, _0221D8E4 ; =ov10_0222B080
	ldr r4, _0221D8E0 ; =0x0000FFFF
	mov r1, #0
_0221D82A:
	ldrh r5, [r2]
	cmp r3, r5
	beq _0221D83A
	add r2, r2, #2
	ldrh r5, [r2]
	add r1, r1, #1
	cmp r5, r4
	bne _0221D82A
_0221D83A:
	lsl r2, r1, #1
	ldr r1, _0221D8E4 ; =ov10_0222B080
	ldrh r1, [r1, r2]
	ldr r2, _0221D8E0 ; =0x0000FFFF
	cmp r1, r2
	bne _0221D85A
	ldr r1, _0221D8E8 ; =0x000003E1
	add r3, r6, r7
	ldrb r1, [r3, r1]
	cmp r1, #1
	bls _0221D8D0
	lsl r1, r0, #1
	ldr r0, _0221D8DC ; =ov10_0222B098
	ldrh r0, [r0, r1]
	cmp r0, r2
	bne _0221D8D0
_0221D85A:
	ldr r7, _0221D8EC ; =0x000003CF
	mov r4, #0
	add r5, sp, #0x20
_0221D860:
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
	blt _0221D860
	ldr r0, _0221D8EC ; =0x000003CF
	ldrb r4, [r6, r0]
	add r0, r6, #0
	add r1, r4, #0
	bl GetBattlerAbility
	add r1, sp, #0x20
	str r1, [sp]
	str r4, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0xc0
	mul r0, r4
	ldr r3, _0221D8F0 ; =0x00002DCC
	add r4, r6, r0
	ldr r0, [r4, r3]
	ldr r2, _0221D8D8 ; =0x00000356
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1d
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x18]
	sub r3, #0x14
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x10]
	ldrh r2, [r6, r2]
	ldrh r3, [r4, r3]
	ldr r0, [sp, #0x14]
	add r1, r6, #0
	bl ov10_0221F084
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r2, [r6, r1]
	mov r1, #0xc0
	mul r1, r2
	add r2, r6, r1
	ldr r1, _0221D8F4 ; =0x00002D8C
	ldr r1, [r2, r1]
	cmp r1, r0
	bhi _0221D8D0
	ldr r1, [sp, #0x1c]
	add r0, r6, #0
	bl ov10_0221EF24
_0221D8D0:
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D8D4: .word 0x00000355
_0221D8D8: .word 0x00000356
_0221D8DC: .word ov10_0222B098
_0221D8E0: .word 0x0000FFFF
_0221D8E4: .word ov10_0222B080
_0221D8E8: .word 0x000003E1
_0221D8EC: .word 0x000003CF
_0221D8F0: .word 0x00002DCC
_0221D8F4: .word 0x00002D8C
	thumb_func_end ov10_0221D7CC

	thumb_func_start ov10_0221D8F8
ov10_0221D8F8: ; 0x0221D8F8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r6, r1, #0
	str r0, [sp, #0x14]
	add r0, r6, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r6, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r6, #0
	bl ov10_0221EEF0
	str r0, [sp, #0x1c]
	cmp r4, #1
	bne _0221D92A
	ldr r0, _0221DA00 ; =0x00000355
	ldrb r1, [r6, r0]
	add r0, #0x17
	add r1, r6, r1
	ldrb r0, [r1, r0]
	str r0, [sp, #0x18]
	b _0221D92E
_0221D92A:
	mov r0, #0x64
	str r0, [sp, #0x18]
_0221D92E:
	ldr r2, _0221DA04 ; =0x00000356
	ldr r1, _0221DA08 ; =ov10_0222B098
	ldrh r3, [r6, r2]
	add r2, #0x88
	mov r0, #0
	lsl r7, r3, #4
	add r3, r6, r7
	ldrh r3, [r3, r2]
	ldr r2, _0221DA0C ; =0x0000FFFF
_0221D940:
	ldrh r4, [r1]
	cmp r3, r4
	beq _0221D950
	add r1, r1, #2
	ldrh r4, [r1]
	add r0, r0, #1
	cmp r4, r2
	bne _0221D940
_0221D950:
	ldr r2, _0221DA10 ; =ov10_0222B080
	ldr r4, _0221DA0C ; =0x0000FFFF
	mov r1, #0
_0221D956:
	ldrh r5, [r2]
	cmp r3, r5
	beq _0221D966
	add r2, r2, #2
	ldrh r5, [r2]
	add r1, r1, #1
	cmp r5, r4
	bne _0221D956
_0221D966:
	lsl r2, r1, #1
	ldr r1, _0221DA10 ; =ov10_0222B080
	ldrh r1, [r1, r2]
	ldr r2, _0221DA0C ; =0x0000FFFF
	cmp r1, r2
	bne _0221D986
	ldr r1, _0221DA14 ; =0x000003E1
	add r3, r6, r7
	ldrb r1, [r3, r1]
	cmp r1, #1
	bls _0221D9FC
	lsl r1, r0, #1
	ldr r0, _0221DA08 ; =ov10_0222B098
	ldrh r0, [r0, r1]
	cmp r0, r2
	bne _0221D9FC
_0221D986:
	ldr r7, _0221DA18 ; =0x000003CF
	mov r4, #0
	add r5, sp, #0x20
_0221D98C:
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
	blt _0221D98C
	ldr r0, _0221DA18 ; =0x000003CF
	ldrb r4, [r6, r0]
	add r0, r6, #0
	add r1, r4, #0
	bl GetBattlerAbility
	add r1, sp, #0x20
	str r1, [sp]
	str r4, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0xc0
	mul r0, r4
	ldr r3, _0221DA1C ; =0x00002DCC
	add r4, r6, r0
	ldr r0, [r4, r3]
	ldr r2, _0221DA04 ; =0x00000356
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1d
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x18]
	sub r3, #0x14
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x10]
	ldrh r2, [r6, r2]
	ldrh r3, [r4, r3]
	ldr r0, [sp, #0x14]
	add r1, r6, #0
	bl ov10_0221F084
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r2, [r6, r1]
	mov r1, #0xc0
	mul r1, r2
	add r2, r6, r1
	ldr r1, _0221DA20 ; =0x00002D8C
	ldr r1, [r2, r1]
	cmp r1, r0
	bls _0221D9FC
	ldr r1, [sp, #0x1c]
	add r0, r6, #0
	bl ov10_0221EF24
_0221D9FC:
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221DA00: .word 0x00000355
_0221DA04: .word 0x00000356
_0221DA08: .word ov10_0222B098
_0221DA0C: .word 0x0000FFFF
_0221DA10: .word ov10_0222B080
_0221DA14: .word 0x000003E1
_0221DA18: .word 0x000003CF
_0221DA1C: .word 0x00002DCC
_0221DA20: .word 0x00002D8C
	thumb_func_end ov10_0221D8F8

	thumb_func_start ov10_0221DA24
ov10_0221DA24: ; 0x0221DA24
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
	cmp r6, #0
	beq _0221DAB4
	cmp r6, #1
	beq _0221DA60
	cmp r6, #3
	beq _0221DA86
	pop {r3, r4, r5, r6, r7, pc}
_0221DA60:
	mov r2, #0xc0
	mul r2, r0
	ldr r0, _0221DADC ; =0x00002D4C
	mov r1, #0
	add r3, r5, r2
_0221DA6A:
	ldrh r2, [r3, r0]
	cmp r4, r2
	beq _0221DA78
	add r1, r1, #1
	add r3, r3, #2
	cmp r1, #4
	blt _0221DA6A
_0221DA78:
	cmp r1, #4
	bge _0221DAD8
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221DA86:
	mov r1, #0xc0
	mul r1, r0
	add r0, r5, r1
	ldr r1, _0221DAE0 ; =0x00002D8C
	ldr r1, [r0, r1]
	cmp r1, #0
	beq _0221DAD8
	ldr r1, _0221DADC ; =0x00002D4C
	mov r3, #0
_0221DA98:
	ldrh r2, [r0, r1]
	cmp r4, r2
	beq _0221DAA6
	add r3, r3, #1
	add r0, r0, #2
	cmp r3, #4
	blt _0221DA98
_0221DAA6:
	cmp r3, #4
	bge _0221DAD8
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221DAB4:
	lsl r0, r0, #3
	add r3, r5, r0
	mov r0, #0x37
	mov r1, #0
	lsl r0, r0, #4
_0221DABE:
	ldrh r2, [r3, r0]
	cmp r4, r2
	beq _0221DACC
	add r1, r1, #1
	add r3, r3, #2
	cmp r1, #4
	blt _0221DABE
_0221DACC:
	cmp r1, #4
	bge _0221DAD8
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221DAD8:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DADC: .word 0x00002D4C
_0221DAE0: .word 0x00002D8C
	thumb_func_end ov10_0221DA24

	thumb_func_start ov10_0221DAE4
ov10_0221DAE4: ; 0x0221DAE4
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
	cmp r6, #0
	beq _0221DB74
	cmp r6, #1
	beq _0221DB20
	cmp r6, #3
	beq _0221DB46
	pop {r3, r4, r5, r6, r7, pc}
_0221DB20:
	mov r2, #0xc0
	mul r2, r0
	ldr r0, _0221DB9C ; =0x00002D4C
	mov r1, #0
	add r3, r5, r2
_0221DB2A:
	ldrh r2, [r3, r0]
	cmp r4, r2
	beq _0221DB38
	add r1, r1, #1
	add r3, r3, #2
	cmp r1, #4
	blt _0221DB2A
_0221DB38:
	cmp r1, #4
	bne _0221DB98
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221DB46:
	mov r1, #0xc0
	mul r1, r0
	add r0, r5, r1
	ldr r1, _0221DBA0 ; =0x00002D8C
	ldr r1, [r0, r1]
	cmp r1, #0
	beq _0221DB98
	ldr r1, _0221DB9C ; =0x00002D4C
	mov r3, #0
_0221DB58:
	ldrh r2, [r0, r1]
	cmp r4, r2
	beq _0221DB66
	add r3, r3, #1
	add r0, r0, #2
	cmp r3, #4
	blt _0221DB58
_0221DB66:
	cmp r3, #4
	bne _0221DB98
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221DB74:
	lsl r0, r0, #3
	add r3, r5, r0
	mov r0, #0x37
	mov r1, #0
	lsl r0, r0, #4
_0221DB7E:
	ldrh r2, [r3, r0]
	cmp r4, r2
	beq _0221DB8C
	add r1, r1, #1
	add r3, r3, #2
	cmp r1, #4
	blt _0221DB7E
_0221DB8C:
	cmp r1, #4
	bne _0221DB98
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221DB98:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DB9C: .word 0x00002D4C
_0221DBA0: .word 0x00002D8C
	thumb_func_end ov10_0221DAE4

	thumb_func_start ov10_0221DBA4
ov10_0221DBA4: ; 0x0221DBA4
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
	cmp r6, #0
	beq _0221DC0C
	cmp r6, #1
	bne _0221DC3C
	mov r2, #0xc0
	mul r2, r0
	add r0, r5, r2
	ldr r2, _0221DC40 ; =0x000003DE
	ldr r3, _0221DC44 ; =0x00002D4C
	mov r1, #0
_0221DBE6:
	ldrh r6, [r0, r3]
	cmp r6, #0
	beq _0221DBF6
	lsl r6, r6, #4
	add r6, r5, r6
	ldrh r6, [r6, r2]
	cmp r4, r6
	beq _0221DBFE
_0221DBF6:
	add r1, r1, #1
	add r0, r0, #2
	cmp r1, #4
	blt _0221DBE6
_0221DBFE:
	cmp r1, #4
	bge _0221DC3C
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221DC0C:
	ldr r2, _0221DC40 ; =0x000003DE
	lsl r0, r0, #3
	add r3, r2, #0
	mov r1, #0
	add r0, r5, r0
	sub r3, #0x6e
_0221DC18:
	ldrh r6, [r0, r3]
	cmp r6, #0
	beq _0221DC28
	lsl r6, r6, #4
	add r6, r5, r6
	ldrh r6, [r6, r2]
	cmp r4, r6
	beq _0221DC30
_0221DC28:
	add r1, r1, #1
	add r0, r0, #2
	cmp r1, #4
	blt _0221DC18
_0221DC30:
	cmp r1, #4
	bge _0221DC3C
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221DC3C:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DC40: .word 0x000003DE
_0221DC44: .word 0x00002D4C
	thumb_func_end ov10_0221DBA4

	thumb_func_start ov10_0221DC48
ov10_0221DC48: ; 0x0221DC48
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
	cmp r6, #0
	beq _0221DCB0
	cmp r6, #1
	bne _0221DCE0
	mov r2, #0xc0
	mul r2, r0
	add r0, r5, r2
	ldr r2, _0221DCE4 ; =0x000003DE
	ldr r3, _0221DCE8 ; =0x00002D4C
	mov r1, #0
_0221DC8A:
	ldrh r6, [r0, r3]
	cmp r6, #0
	beq _0221DC9A
	lsl r6, r6, #4
	add r6, r5, r6
	ldrh r6, [r6, r2]
	cmp r4, r6
	beq _0221DCA2
_0221DC9A:
	add r1, r1, #1
	add r0, r0, #2
	cmp r1, #4
	blt _0221DC8A
_0221DCA2:
	cmp r1, #4
	bne _0221DCE0
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
	pop {r3, r4, r5, r6, r7, pc}
_0221DCB0:
	ldr r2, _0221DCE4 ; =0x000003DE
	lsl r0, r0, #3
	add r3, r2, #0
	mov r1, #0
	add r0, r5, r0
	sub r3, #0x6e
_0221DCBC:
	ldrh r6, [r0, r3]
	cmp r6, #0
	beq _0221DCCC
	lsl r6, r6, #4
	add r6, r5, r6
	ldrh r6, [r6, r2]
	cmp r4, r6
	beq _0221DCD4
_0221DCCC:
	add r1, r1, #1
	add r0, r0, #2
	cmp r1, #4
	blt _0221DCBC
_0221DCD4:
	cmp r1, #4
	bne _0221DCE0
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221DCE0:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DCE4: .word 0x000003DE
_0221DCE8: .word 0x00002D4C
	thumb_func_end ov10_0221DC48

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

	thumb_func_start ov10_0221E178
ov10_0221E178: ; 0x0221E178
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, _0221E198 ; =0x00000356
	ldrh r1, [r4, r0]
	lsl r1, r1, #4
	add r2, r4, r1
	add r1, r0, #0
	add r1, #0x8a
	ldrb r1, [r2, r1]
	add r0, r0, #6
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221E198: .word 0x00000356
	thumb_func_end ov10_0221E178

	thumb_func_start ov10_0221E19C
ov10_0221E19C: ; 0x0221E19C
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r0, [r4, r1]
	lsl r0, r0, #1
	add r2, r4, r0
	ldr r0, _0221E1C8 ; =0x0000307C
	ldrh r0, [r2, r0]
	lsl r0, r0, #4
	add r2, r4, r0
	add r0, r1, #0
	add r0, #0x10
	ldrb r0, [r2, r0]
	sub r1, #0x74
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_0221E1C8: .word 0x0000307C
	thumb_func_end ov10_0221E19C

	thumb_func_start ov10_0221E1CC
ov10_0221E1CC: ; 0x0221E1CC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	str r0, [sp, #4]
	str r1, [sp, #8]
	add r0, r1, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, [sp, #8]
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	ldr r0, [sp, #8]
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	str r0, [sp, #0x10]
	ldr r0, [sp, #4]
	bl BattleSystem_GetMaxBattlers
	mov r1, #0
	str r0, [sp, #0x14]
	cmp r0, #0
	ble _0221E20A
	add r2, sp, #0x24
_0221E200:
	ldr r0, [sp, #0x14]
	stmia r2!, {r1}
	add r1, r1, #1
	cmp r1, r0
	blt _0221E200
_0221E20A:
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x14]
	sub r0, r0, #1
	str r0, [sp, #0x1c]
	cmp r0, #0
	ble _0221E264
	add r6, sp, #0x24
	str r6, [sp, #0x20]
_0221E21C:
	ldr r0, [sp, #0xc]
	add r7, r0, #1
	ldr r0, [sp, #0x14]
	cmp r7, r0
	bge _0221E256
	ldr r0, [sp, #0x20]
	lsl r1, r7, #2
	add r5, r0, r1
_0221E22C:
	ldr r0, [r6]
	ldr r4, [r5]
	str r0, [sp, #0x18]
	mov r0, #1
	str r0, [sp]
	ldr r0, [sp, #4]
	ldr r1, [sp, #8]
	ldr r2, [sp, #0x18]
	add r3, r4, #0
	bl CheckSortSpeed
	cmp r0, #0
	beq _0221E24C
	ldr r0, [sp, #0x18]
	str r4, [r6]
	str r0, [r5]
_0221E24C:
	ldr r0, [sp, #0x14]
	add r7, r7, #1
	add r5, r5, #4
	cmp r7, r0
	blt _0221E22C
_0221E256:
	ldr r0, [sp, #0xc]
	add r6, r6, #4
	add r1, r0, #1
	ldr r0, [sp, #0x1c]
	str r1, [sp, #0xc]
	cmp r1, r0
	blt _0221E21C
_0221E264:
	ldr r1, [sp, #0x14]
	mov r0, #0
	cmp r1, #0
	ble _0221E28C
	add r3, sp, #0x24
_0221E26E:
	ldr r2, [r3]
	ldr r1, [sp, #0x10]
	cmp r1, r2
	bne _0221E282
	mov r2, #0xd7
	ldr r1, [sp, #8]
	lsl r2, r2, #2
	str r0, [r1, r2]
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
_0221E282:
	ldr r1, [sp, #0x14]
	add r0, r0, #1
	add r3, r3, #4
	cmp r0, r1
	blt _0221E26E
_0221E28C:
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov10_0221E1CC

	thumb_func_start ov10_0221E290
ov10_0221E290: ; 0x0221E290
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
	mov r1, #0x15
	lsl r1, r1, #4
	ldr r2, [r4, r1]
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221E2C8 ; =0x00002DD4
	add r1, r4, r1
	ldr r0, [r1, r0]
	sub r1, r2, r0
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221E2C8: .word 0x00002DD4
	thumb_func_end ov10_0221E290

	thumb_func_start ov10_0221E2CC
ov10_0221E2CC: ; 0x0221E2CC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x54
	str r0, [sp, #0x18]
	str r1, [sp, #0x1c]
	add r0, r1, #0
	mov r1, #1
	bl ov10_0221EF24
	ldr r0, [sp, #0x1c]
	bl ov10_0221EEF0
	str r0, [sp, #0x30]
	ldr r0, [sp, #0x1c]
	bl ov10_0221EEF0
	str r0, [sp, #0x2c]
	mov r4, #0
	ldr r1, _0221E450 ; =0x000003CF
	ldr r0, [sp, #0x1c]
	add r5, sp, #0x34
	ldrb r0, [r0, r1]
	add r6, r4, #0
	str r0, [sp, #0x28]
_0221E2FA:
	add r2, r4, #0
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x28]
	add r2, #0xa
	add r3, r6, #0
	bl GetBattlerVar
	strb r0, [r5]
	add r4, r4, #1
	add r5, r5, #1
	cmp r4, #6
	blt _0221E2FA
	ldr r0, [sp, #0x28]
	mov r1, #0xc0
	add r4, r0, #0
	mul r4, r1
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x28]
	bl GetBattlerAbility
	add r1, sp, #0x44
	str r1, [sp]
	ldr r1, [sp, #0x1c]
	ldr r3, _0221E454 ; =0x00002DB8
	add r2, r1, r4
	ldrh r1, [r2, r3]
	ldr r5, _0221E450 ; =0x000003CF
	str r1, [sp, #4]
	add r1, sp, #0x34
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	add r0, r3, #0
	add r0, #0x14
	ldr r0, [r2, r0]
	ldr r1, [sp, #0x1c]
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1d
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x30]
	add r2, r1, #0
	str r0, [sp, #0x14]
	ldrb r2, [r2, r5]
	sub r3, #0x6c
	add r5, r1, #0
	add r3, r5, r3
	ldr r0, [sp, #0x18]
	add r3, r3, r4
	bl ov10_0221EF7C
	str r0, [sp, #0x24]
	ldr r0, [sp, #0x18]
	ldr r1, [sp, #0x28]
	mov r7, #0
	bl BattleSystem_GetPartySize
	cmp r0, #0
	ble _0221E44A
	ldr r1, [sp, #0x1c]
	ldr r0, [sp, #0x28]
	add r0, r1, r0
	str r0, [sp, #0x20]
_0221E374:
	ldr r1, _0221E458 ; =0x0000219C
	ldr r0, [sp, #0x20]
	ldrb r0, [r0, r1]
	cmp r7, r0
	beq _0221E43C
	ldr r0, [sp, #0x18]
	ldr r1, [sp, #0x28]
	add r2, r7, #0
	bl BattleSystem_GetPartyMon
	mov r1, #0xa3
	mov r2, #0
	add r6, r0, #0
	bl GetMonData
	cmp r0, #0
	beq _0221E43C
	add r0, r6, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221E43C
	add r0, r6, #0
	mov r1, #0xae
	mov r2, #0
	bl GetMonData
	ldr r1, _0221E45C ; =0x000001EE
	cmp r0, r1
	beq _0221E43C
	add r5, sp, #0x38
	mov r4, #0
	add r5, #2
_0221E3BA:
	add r1, r4, #0
	add r0, r6, #0
	add r1, #0x36
	mov r2, #0
	bl GetMonData
	strh r0, [r5]
	add r4, r4, #1
	add r5, r5, #2
	cmp r4, #4
	blt _0221E3BA
	mov r5, #0
	add r4, sp, #0x34
_0221E3D4:
	add r1, r5, #0
	add r0, r6, #0
	add r1, #0x46
	mov r2, #0
	bl GetMonData
	strb r0, [r4]
	add r5, r5, #1
	add r4, r4, #1
	cmp r5, #6
	blt _0221E3D4
	add r0, r6, #0
	mov r1, #6
	mov r2, #0
	bl GetMonData
	add r4, r0, #0
	add r0, r6, #0
	mov r1, #0xa
	mov r2, #0
	bl GetMonData
	add r1, sp, #0x44
	str r1, [sp]
	lsl r1, r4, #0x10
	lsr r1, r1, #0x10
	str r1, [sp, #4]
	add r1, sp, #0x34
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x30]
	ldr r1, [sp, #0x1c]
	str r0, [sp, #0x14]
	ldr r3, _0221E450 ; =0x000003CF
	add r2, r1, #0
	ldrb r2, [r2, r3]
	add r3, sp, #0x38
	ldr r0, [sp, #0x18]
	add r3, #2
	bl ov10_0221EF7C
	ldr r1, [sp, #0x24]
	cmp r0, r1
	ble _0221E43C
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x2c]
	bl ov10_0221EF24
	add sp, #0x54
	pop {r4, r5, r6, r7, pc}
_0221E43C:
	ldr r0, [sp, #0x18]
	ldr r1, [sp, #0x28]
	add r7, r7, #1
	bl BattleSystem_GetPartySize
	cmp r7, r0
	blt _0221E374
_0221E44A:
	add sp, #0x54
	pop {r4, r5, r6, r7, pc}
	nop
_0221E450: .word 0x000003CF
_0221E454: .word 0x00002DB8
_0221E458: .word 0x0000219C
_0221E45C: .word 0x000001EE
	thumb_func_end ov10_0221E2CC

	thumb_func_start ov10_0221E460
ov10_0221E460: ; 0x0221E460
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	ldr r2, _0221E494 ; =0x000003CF
	add r6, r0, #0
	ldrb r2, [r4, r2]
	add r0, r5, #0
	add r1, r4, #0
	mov r3, #1
	bl ov10_0221FD34
	cmp r0, #1
	bne _0221E490
	add r0, r4, #0
	add r1, r6, #0
	bl ov10_0221EF24
_0221E490:
	pop {r4, r5, r6, pc}
	nop
_0221E494: .word 0x000003CF
	thumb_func_end ov10_0221E460

	thumb_func_start ov10_0221E498
ov10_0221E498: ; 0x0221E498
	push {r4, r5, r6, r7, lr}
	sub sp, #0x44
	add r6, r1, #0
	str r0, [sp, #0x18]
	add r0, r6, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r6, #0
	bl ov10_0221EEF0
	str r0, [sp, #0x28]
	add r0, r6, #0
	bl ov10_0221EEF0
	str r0, [sp, #0x24]
	add r0, r6, #0
	bl ov10_0221EEF0
	ldr r7, _0221E59C ; =0x000003CF
	str r0, [sp, #0x20]
	mov r4, #0
	add r5, sp, #0x2c
_0221E4C6:
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
	blt _0221E4C6
	ldr r0, _0221E59C ; =0x000003CF
	ldrb r4, [r6, r0]
	mov r0, #0xc0
	add r5, r4, #0
	mul r5, r0
	add r0, r6, #0
	add r1, r4, #0
	bl GetBattlerAbility
	add r1, sp, #0x34
	str r1, [sp]
	ldr r3, _0221E5A0 ; =0x00002DB8
	add r1, r6, r5
	ldrh r1, [r1, r3]
	add r2, r4, #0
	str r1, [sp, #4]
	add r1, sp, #0x2c
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
	ldr r0, [sp, #0x24]
	add r3, r6, r3
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x18]
	add r1, r6, #0
	add r3, r3, r5
	bl ov10_0221EF7C
	ldr r1, [sp, #0x28]
	str r0, [sp, #0x1c]
	lsl r1, r1, #0x18
	add r0, r6, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r4, r0, #0
	ldr r0, [sp, #0x24]
	cmp r0, #1
	bne _0221E54A
	ldr r0, _0221E5A4 ; =0x00000355
	ldrb r1, [r6, r0]
	add r0, #0x17
	add r1, r6, r1
	ldrb r5, [r1, r0]
	b _0221E54C
_0221E54A:
	mov r5, #0x64
_0221E54C:
	mov r0, #0xc0
	add r7, r4, #0
	mul r7, r0
	add r0, r6, #0
	add r1, r4, #0
	bl GetBattlerAbility
	add r1, sp, #0x2c
	str r1, [sp]
	str r4, [sp, #4]
	lsl r2, r4, #1
	add r4, r6, r2
	ldr r3, _0221E5A8 ; =0x00002DCC
	add r7, r6, r7
	str r0, [sp, #8]
	ldr r0, [r7, r3]
	ldr r2, _0221E5AC ; =0x0000307C
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1d
	str r0, [sp, #0xc]
	lsl r0, r5, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x10]
	sub r3, #0x14
	ldrh r2, [r4, r2]
	ldrh r3, [r7, r3]
	ldr r0, [sp, #0x18]
	add r1, r6, #0
	bl ov10_0221F084
	ldr r1, [sp, #0x1c]
	cmp r0, r1
	ble _0221E596
	ldr r1, [sp, #0x20]
	add r0, r6, #0
	bl ov10_0221EF24
_0221E596:
	add sp, #0x44
	pop {r4, r5, r6, r7, pc}
	nop
_0221E59C: .word 0x000003CF
_0221E5A0: .word 0x00002DB8
_0221E5A4: .word 0x00000355
_0221E5A8: .word 0x00002DCC
_0221E5AC: .word 0x0000307C
	thumb_func_end ov10_0221E498

	thumb_func_start ov10_0221E5B0
ov10_0221E5B0: ; 0x0221E5B0
	push {r4, r5, r6, lr}
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
	mov r2, #0xd7
	mov r3, #0xd7
	mov r1, #0
	lsl r2, r2, #2
	str r1, [r4, r2]
	mov r2, #0xc0
	mul r2, r0
	add r0, r4, r2
	ldr r2, _0221E5FC ; =0x00002D58
	lsl r3, r3, #2
_0221E5E2:
	ldrsb r5, [r0, r2]
	cmp r5, #6
	ble _0221E5F0
	ldr r6, [r4, r3]
	sub r5, r5, #6
	add r5, r6, r5
	str r5, [r4, r3]
_0221E5F0:
	add r1, r1, #1
	add r0, r0, #1
	cmp r1, #8
	blt _0221E5E2
	pop {r4, r5, r6, pc}
	nop
_0221E5FC: .word 0x00002D58
	thumb_func_end ov10_0221E5B0

	thumb_func_start ov10_0221E600
ov10_0221E600: ; 0x0221E600
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
	ldr r3, _0221E648 ; =0x000003CF
	mov r1, #0xc0
	ldrb r6, [r5, r3]
	add r2, r0, #0
	mul r2, r1
	add r0, r5, r2
	mul r1, r6
	add r1, r5, r1
	ldr r2, _0221E64C ; =0x00002D58
	add r0, r0, r4
	add r1, r1, r4
	ldrsb r0, [r0, r2]
	ldrsb r1, [r1, r2]
	sub r3, #0x73
	sub r0, r0, r1
	str r0, [r5, r3]
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221E648: .word 0x000003CF
_0221E64C: .word 0x00002D58
	thumb_func_end ov10_0221E600

	thumb_func_start ov10_0221E650
ov10_0221E650: ; 0x0221E650
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
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
	add r1, r0, #0
	str r6, [sp]
	add r0, r5, #0
	add r2, sp, #8
	add r3, sp, #4
	bl ov10_0221E74C
	ldr r1, [sp, #8]
	ldr r0, [sp, #4]
	cmp r1, r0
	bge _0221E69E
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221E69E:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221E650

	thumb_func_start ov10_0221E6A4
ov10_0221E6A4: ; 0x0221E6A4
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
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
	add r1, r0, #0
	str r6, [sp]
	add r0, r5, #0
	add r2, sp, #8
	add r3, sp, #4
	bl ov10_0221E74C
	ldr r1, [sp, #8]
	ldr r0, [sp, #4]
	cmp r1, r0
	ble _0221E6F2
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221E6F2:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221E6A4

	thumb_func_start ov10_0221E6F8
ov10_0221E6F8: ; 0x0221E6F8
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
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
	add r1, r0, #0
	str r6, [sp]
	add r0, r5, #0
	add r2, sp, #8
	add r3, sp, #4
	bl ov10_0221E74C
	ldr r1, [sp, #8]
	ldr r0, [sp, #4]
	cmp r1, r0
	bne _0221E746
	add r0, r5, #0
	add r1, r7, #0
	bl ov10_0221EF24
_0221E746:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov10_0221E6F8

	thumb_func_start ov10_0221E74C
ov10_0221E74C: ; 0x0221E74C
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r1, r3, #0
	ldr r3, [sp, #0x10]
	cmp r3, #5
	bhi _0221E824
	add r3, r3, r3
	add r3, pc
	ldrh r3, [r3, #6]
	lsl r3, r3, #0x10
	asr r3, r3, #0x10
	add pc, r3
_0221E764: ; jump table
	.short _0221E770 - _0221E764 - 2 ; case 0
	.short _0221E78E - _0221E764 - 2 ; case 1
	.short _0221E7AC - _0221E764 - 2 ; case 2
	.short _0221E806 - _0221E764 - 2 ; case 3
	.short _0221E7CA - _0221E764 - 2 ; case 4
	.short _0221E7E8 - _0221E764 - 2 ; case 5
_0221E770:
	ldr r3, _0221E82C ; =0x000003CF
	ldrb r5, [r0, r3]
	mov r3, #0xc0
	add r6, r5, #0
	mul r6, r3
	ldr r5, _0221E830 ; =0x00002D8C
	add r6, r0, r6
	ldr r6, [r6, r5]
	str r6, [r2]
	add r2, r4, #0
	mul r2, r3
	add r0, r0, r2
	ldr r0, [r0, r5]
	str r0, [r1]
	pop {r4, r5, r6, pc}
_0221E78E:
	ldr r3, _0221E82C ; =0x000003CF
	ldrb r5, [r0, r3]
	mov r3, #0xc0
	add r6, r5, #0
	mul r6, r3
	ldr r5, _0221E834 ; =0x00002D42
	add r6, r0, r6
	ldrh r6, [r6, r5]
	str r6, [r2]
	add r2, r4, #0
	mul r2, r3
	add r0, r0, r2
	ldrh r0, [r0, r5]
	str r0, [r1]
	pop {r4, r5, r6, pc}
_0221E7AC:
	ldr r3, _0221E82C ; =0x000003CF
	ldrb r5, [r0, r3]
	mov r3, #0xc0
	add r6, r5, #0
	mul r6, r3
	ldr r5, _0221E838 ; =0x00002D44
	add r6, r0, r6
	ldrh r6, [r6, r5]
	str r6, [r2]
	add r2, r4, #0
	mul r2, r3
	add r0, r0, r2
	ldrh r0, [r0, r5]
	str r0, [r1]
	pop {r4, r5, r6, pc}
_0221E7CA:
	ldr r3, _0221E82C ; =0x000003CF
	ldrb r5, [r0, r3]
	mov r3, #0xc0
	add r6, r5, #0
	mul r6, r3
	ldr r5, _0221E83C ; =0x00002D48
	add r6, r0, r6
	ldrh r6, [r6, r5]
	str r6, [r2]
	add r2, r4, #0
	mul r2, r3
	add r0, r0, r2
	ldrh r0, [r0, r5]
	str r0, [r1]
	pop {r4, r5, r6, pc}
_0221E7E8:
	ldr r3, _0221E82C ; =0x000003CF
	ldrb r5, [r0, r3]
	mov r3, #0xc0
	add r6, r5, #0
	mul r6, r3
	ldr r5, _0221E840 ; =0x00002D4A
	add r6, r0, r6
	ldrh r6, [r6, r5]
	str r6, [r2]
	add r2, r4, #0
	mul r2, r3
	add r0, r0, r2
	ldrh r0, [r0, r5]
	str r0, [r1]
	pop {r4, r5, r6, pc}
_0221E806:
	ldr r3, _0221E82C ; =0x000003CF
	ldrb r5, [r0, r3]
	mov r3, #0xc0
	add r6, r5, #0
	mul r6, r3
	ldr r5, _0221E844 ; =0x00002D46
	add r6, r0, r6
	ldrh r6, [r6, r5]
	str r6, [r2]
	add r2, r4, #0
	mul r2, r3
	add r0, r0, r2
	ldrh r0, [r0, r5]
	str r0, [r1]
	pop {r4, r5, r6, pc}
_0221E824:
	bl GF_AssertFail
	pop {r4, r5, r6, pc}
	nop
_0221E82C: .word 0x000003CF
_0221E830: .word 0x00002D8C
_0221E834: .word 0x00002D42
_0221E838: .word 0x00002D44
_0221E83C: .word 0x00002D48
_0221E840: .word 0x00002D4A
_0221E844: .word 0x00002D46
	thumb_func_end ov10_0221E74C

	thumb_func_start ov10_0221E848
ov10_0221E848: ; 0x0221E848
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x40
	add r6, r1, #0
	str r0, [sp, #0x18]
	add r0, r6, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r6, #0
	bl ov10_0221EEF0
	ldr r2, _0221E984 ; =0x00000356
	str r0, [sp, #0x20]
	ldrh r3, [r6, r2]
	add r2, #0x88
	ldr r1, _0221E988 ; =ov10_0222B098
	lsl r7, r3, #4
	add r3, r6, r7
	ldrh r3, [r3, r2]
	ldr r2, _0221E98C ; =0x0000FFFF
	mov r0, #0
_0221E872:
	ldrh r4, [r1]
	cmp r3, r4
	beq _0221E882
	add r1, r1, #2
	ldrh r4, [r1]
	add r0, r0, #1
	cmp r4, r2
	bne _0221E872
_0221E882:
	ldr r2, _0221E990 ; =ov10_0222B080
	ldr r4, _0221E98C ; =0x0000FFFF
	mov r1, #0
_0221E888:
	ldrh r5, [r2]
	cmp r3, r5
	beq _0221E898
	add r2, r2, #2
	ldrh r5, [r2]
	add r1, r1, #1
	cmp r5, r4
	bne _0221E888
_0221E898:
	lsl r2, r1, #1
	ldr r1, _0221E990 ; =ov10_0222B080
	ldrh r1, [r1, r2]
	ldr r2, _0221E98C ; =0x0000FFFF
	cmp r1, r2
	bne _0221E8B8
	ldr r1, _0221E994 ; =0x000003E1
	add r3, r6, r7
	ldrb r1, [r3, r1]
	cmp r1, #1
	bls _0221E976
	lsl r1, r0, #1
	ldr r0, _0221E988 ; =ov10_0222B098
	ldrh r0, [r0, r1]
	cmp r0, r2
	bne _0221E976
_0221E8B8:
	ldr r0, _0221E998 ; =0x000003CF
	ldrb r7, [r6, r0]
	mov r0, #0
	str r0, [sp, #0x1c]
_0221E8C0:
	mov r4, #0
	add r5, sp, #0x28
_0221E8C4:
	add r2, r4, #0
	add r0, r6, #0
	add r1, r7, #0
	add r2, #0xa
	mov r3, #0
	bl GetBattlerVar
	strb r0, [r5]
	add r4, r4, #1
	add r5, r5, #1
	cmp r4, #6
	blt _0221E8C4
	mov r0, #0xc0
	add r4, r7, #0
	mul r4, r0
	add r0, r6, #0
	add r1, r7, #0
	bl GetBattlerAbility
	add r1, sp, #0x30
	str r1, [sp]
	ldr r3, _0221E99C ; =0x00002DB8
	add r1, r6, r4
	ldrh r2, [r1, r3]
	str r2, [sp, #4]
	add r2, sp, #0x28
	str r2, [sp, #8]
	str r0, [sp, #0xc]
	add r0, r3, #0
	add r0, #0x14
	ldr r0, [r1, r0]
	sub r3, #0x6c
	lsl r0, r0, #0xa
	lsr r0, r0, #0x1d
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x20]
	add r3, r6, r3
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x18]
	add r1, r6, #0
	add r2, r7, #0
	add r3, r3, r4
	bl ov10_0221EF7C
	ldr r1, _0221E998 ; =0x000003CF
	ldr r0, [sp, #0x18]
	ldrb r1, [r6, r1]
	bl BattleSystem_GetBattlerIdPartner
	add r7, r0, #0
	ldr r0, [sp, #0x1c]
	cmp r0, #0
	bne _0221E93A
	ldr r0, _0221E9A0 ; =0x00000355
	ldrb r0, [r6, r0]
	lsl r1, r0, #2
	add r0, sp, #0x30
	ldr r0, [r0, r1]
	str r0, [sp, #0x24]
_0221E93A:
	mov r3, #0
	add r2, sp, #0x30
_0221E93E:
	ldr r1, [r2]
	ldr r0, [sp, #0x24]
	cmp r1, r0
	bgt _0221E94E
	add r3, r3, #1
	add r2, r2, #4
	cmp r3, #4
	blt _0221E93E
_0221E94E:
	cmp r3, #4
	bne _0221E95C
	mov r0, #0xd7
	mov r1, #2
	lsl r0, r0, #2
	str r1, [r6, r0]
	b _0221E968
_0221E95C:
	mov r0, #0xd7
	mov r1, #1
	lsl r0, r0, #2
	add sp, #0x40
	str r1, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0221E968:
	ldr r0, [sp, #0x1c]
	add r0, r0, #1
	str r0, [sp, #0x1c]
	cmp r0, #2
	blt _0221E8C0
	add sp, #0x40
	pop {r3, r4, r5, r6, r7, pc}
_0221E976:
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r6, r0]
	add sp, #0x40
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221E984: .word 0x00000356
_0221E988: .word ov10_0222B098
_0221E98C: .word 0x0000FFFF
_0221E990: .word ov10_0222B080
_0221E994: .word 0x000003E1
_0221E998: .word 0x000003CF
_0221E99C: .word 0x00002DB8
_0221E9A0: .word 0x00000355
	thumb_func_end ov10_0221E848

	thumb_func_start ov10_0221E9A4
ov10_0221E9A4: ; 0x0221E9A4
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
	add r6, r0, #0
	cmp r4, #1
	bne _0221E9C8
	bl GF_AssertFail
_0221E9C8:
	cmp r4, #0
	bne _0221E9D0
	bl GF_AssertFail
_0221E9D0:
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	bl MaskOfFlagNo
	ldr r1, _0221E9F0 ; =0x00003108
	ldrb r1, [r5, r1]
	tst r0, r1
	beq _0221E9EE
	add r0, r5, #0
	add r1, r6, #0
	bl ov10_0221EF24
_0221E9EE:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221E9F0: .word 0x00003108
	thumb_func_end ov10_0221E9A4

	thumb_func_start ov10_0221E9F4
ov10_0221E9F4: ; 0x0221E9F4
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
	add r6, r0, #0
	cmp r4, #1
	bne _0221EA18
	bl GF_AssertFail
_0221EA18:
	cmp r4, #0
	bne _0221EA20
	bl GF_AssertFail
_0221EA20:
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	bl MaskOfFlagNo
	ldr r1, _0221EA40 ; =0x00003108
	ldrb r1, [r5, r1]
	tst r0, r1
	bne _0221EA3E
	add r0, r5, #0
	add r1, r6, #0
	bl ov10_0221EF24
_0221EA3E:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221EA40: .word 0x00003108
	thumb_func_end ov10_0221E9F4

	thumb_func_start ov10_0221EA44
ov10_0221EA44: ; 0x0221EA44
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
	ldr r0, _0221EA78 ; =0x00002DBE
	add r1, r4, r1
	ldrb r0, [r1, r0]
	lsl r0, r0, #0x1c
	lsr r1, r0, #0x1c
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221EA78: .word 0x00002DBE
	thumb_func_end ov10_0221EA44

	thumb_func_start ov10_0221EA7C
ov10_0221EA7C: ; 0x0221EA7C
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
	add r2, r0, #0
	mov r1, #0xc0
	mul r2, r1
	ldr r0, _0221EAC4 ; =0x00002DD4
	add r2, r4, r2
	add r1, #0x90
	ldr r2, [r2, r0]
	ldr r0, [r4, r1]
	cmp r2, r0
	bge _0221EAB8
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
_0221EAB8:
	mov r1, #1
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0221EAC4: .word 0x00002DD4
	thumb_func_end ov10_0221EA7C

	thumb_func_start ov10_0221EAC8
ov10_0221EAC8: ; 0x0221EAC8
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
	ldr r0, _0221EAFC ; =0x00002DC8
	add r1, r4, r1
	ldr r0, [r1, r0]
	lsl r0, r0, #8
	lsr r1, r0, #0x1d
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221EAFC: .word 0x00002DC8
	thumb_func_end ov10_0221EAC8

	thumb_func_start ov10_0221EB00
ov10_0221EB00: ; 0x0221EB00
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r0, #0xd7
	ldr r1, [r5, #0x2c]
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r3, r4, r5, pc}
	thumb_func_end ov10_0221EB00

	thumb_func_start ov10_0221EB18
ov10_0221EB18: ; 0x0221EB18
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
	ldr r0, _0221EB48 ; =0x00003124
	ldrh r1, [r1, r0]
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0221EB48: .word 0x00003124
	thumb_func_end ov10_0221EB18

	thumb_func_start ov10_0221EB4C
ov10_0221EB4C: ; 0x0221EB4C
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r1, #0xd7
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	lsl r0, r0, #4
	add r2, r4, r0
	add r0, r1, #0
	add r0, #0x86
	ldrb r0, [r2, r0]
	str r0, [r4, r1]
	pop {r4, pc}
	thumb_func_end ov10_0221EB4C

	thumb_func_start ov10_0221EB6C
ov10_0221EB6C: ; 0x0221EB6C
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r1, #0xd7
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	lsl r0, r0, #4
	add r2, r4, r0
	add r0, r1, #0
	add r0, #0x85
	ldrb r0, [r2, r0]
	str r0, [r4, r1]
	pop {r4, pc}
	thumb_func_end ov10_0221EB6C

	thumb_func_start ov10_0221EB8C
ov10_0221EB8C: ; 0x0221EB8C
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r1, #0xd7
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	lsl r0, r0, #4
	add r2, r4, r0
	add r0, r1, #0
	add r0, #0x82
	ldrh r0, [r2, r0]
	str r0, [r4, r1]
	pop {r4, pc}
	thumb_func_end ov10_0221EB8C

	thumb_func_start ov10_0221EBAC
ov10_0221EBAC: ; 0x0221EBAC
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
	lsl r1, r0, #1
	add r2, r4, r1
	ldr r1, _0221EC00 ; =0x0000305C
	ldrh r1, [r2, r1]
	cmp r1, #0xb6
	beq _0221EBE8
	cmp r1, #0xc5
	beq _0221EBE8
	cmp r1, #0xcb
	beq _0221EBE8
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
_0221EBE8:
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221EC04 ; =0x00002DC8
	add r1, r4, r1
	ldr r0, [r1, r0]
	lsl r0, r0, #0x13
	lsr r1, r0, #0x1e
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0221EC00: .word 0x0000305C
_0221EC04: .word 0x00002DC8
	thumb_func_end ov10_0221EBAC

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

	thumb_func_start ov10_0221EF7C
ov10_0221EF7C: ; 0x0221EF7C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x44]
	ldr r6, [sp, #0x40]
	str r0, [sp, #0x44]
	ldr r0, [sp, #0x48]
	add r7, r1, #0
	str r0, [sp, #0x48]
	ldr r0, [sp, #0x4c]
	str r2, [sp, #0x18]
	str r0, [sp, #0x4c]
	ldr r0, [sp, #0x50]
	str r3, [sp, #0x1c]
	str r0, [sp, #0x50]
	ldr r0, [sp, #0x54]
	str r0, [sp, #0x54]
	mov r0, #0
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
_0221EFA4:
	ldr r2, [sp, #0x1c]
	ldr r3, _0221F070 ; =0x000003DE
	ldrh r2, [r2]
	ldr r1, _0221F074 ; =ov10_0222B098
	mov r0, #0
	mov ip, r2
	lsl r2, r2, #4
	add r2, r7, r2
	ldrh r3, [r2, r3]
	str r2, [sp, #0x20]
	ldr r2, _0221F078 ; =0x0000FFFF
_0221EFBA:
	ldrh r4, [r1]
	cmp r4, r3
	beq _0221EFCA
	add r1, r1, #2
	ldrh r4, [r1]
	add r0, r0, #1
	cmp r4, r2
	bne _0221EFBA
_0221EFCA:
	ldr r2, _0221F07C ; =ov10_0222B080
	ldr r4, _0221F078 ; =0x0000FFFF
	mov r1, #0
_0221EFD0:
	ldrh r5, [r2]
	cmp r5, r3
	beq _0221EFE0
	add r2, r2, #2
	ldrh r5, [r2]
	add r1, r1, #1
	cmp r5, r4
	bne _0221EFD0
_0221EFE0:
	lsl r2, r1, #1
	ldr r1, _0221F07C ; =ov10_0222B080
	ldrh r1, [r1, r2]
	ldr r2, _0221F078 ; =0x0000FFFF
	cmp r1, r2
	bne _0221F006
	mov r1, ip
	cmp r1, #0
	beq _0221F03C
	lsl r1, r0, #1
	ldr r0, _0221F074 ; =ov10_0222B098
	ldrh r0, [r0, r1]
	cmp r0, r2
	bne _0221F03C
	ldr r1, _0221F080 ; =0x000003E1
	ldr r0, [sp, #0x20]
	ldrb r0, [r0, r1]
	cmp r0, #1
	bls _0221F03C
_0221F006:
	ldr r0, [sp, #0x54]
	cmp r0, #1
	bne _0221F018
	ldr r0, [sp, #0x28]
	add r1, r7, r0
	mov r0, #0xdb
	lsl r0, r0, #2
	ldrb r0, [r1, r0]
	b _0221F01A
_0221F018:
	mov r0, #0x64
_0221F01A:
	ldr r1, [sp, #0x48]
	mov r2, ip
	str r1, [sp]
	ldr r1, [sp, #0x18]
	str r1, [sp, #4]
	ldr r1, [sp, #0x4c]
	str r1, [sp, #8]
	ldr r1, [sp, #0x50]
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [sp, #0x44]
	add r1, r7, #0
	bl ov10_0221F084
	str r0, [r6]
	b _0221F040
_0221F03C:
	mov r0, #0
	str r0, [r6]
_0221F040:
	ldr r0, [sp, #0x1c]
	add r6, r6, #4
	add r0, r0, #2
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x28]
	add r0, r0, #1
	str r0, [sp, #0x28]
	cmp r0, #4
	blt _0221EFA4
	ldr r2, [sp, #0x40]
	mov r3, #0
_0221F056:
	ldr r1, [r2]
	ldr r0, [sp, #0x24]
	cmp r0, r1
	bge _0221F060
	str r1, [sp, #0x24]
_0221F060:
	add r3, r3, #1
	add r2, r2, #4
	cmp r3, #4
	blt _0221F056
	ldr r0, [sp, #0x24]
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	nop
_0221F070: .word 0x000003DE
_0221F074: .word ov10_0222B098
_0221F078: .word 0x0000FFFF
_0221F07C: .word ov10_0222B080
_0221F080: .word 0x000003E1
	thumb_func_end ov10_0221EF7C

	thumb_func_start ov10_0221F084
ov10_0221F084: ; 0x0221F084
	push {r4, r5, r6, r7, lr}
	sub sp, #0x4c
	add r6, r1, #0
	ldr r1, [sp, #0x60]
	str r3, [sp, #0x1c]
	str r1, [sp, #0x60]
	ldr r1, [sp, #0x64]
	str r0, [sp, #0x18]
	str r1, [sp, #0x64]
	mov r1, #0x3d
	lsl r1, r1, #4
	ldrb r1, [r6, r1]
	add r5, r2, #0
	bl BattleSystem_GetFieldSide
	mov r4, #0
	str r0, [sp, #0x28]
	add r0, r4, #0
	add r7, r4, #0
	str r4, [sp, #0x20]
	str r0, [sp, #0x48]
	cmp r5, #0xd8
	bgt _0221F0EA
	blt _0221F0B6
	b _0221F2F4
_0221F0B6:
	cmp r5, #0x52
	bgt _0221F0D8
	blt _0221F0BE
	b _0221F2B8
_0221F0BE:
	cmp r5, #0x31
	bgt _0221F0C8
	bne _0221F0C6
	b _0221F36E
_0221F0C6:
	b _0221F3B0
_0221F0C8:
	cmp r5, #0x45
	bgt _0221F0D6
	cmp r5, #0x43
	blt _0221F0D6
	beq _0221F120
	cmp r5, #0x45
	beq _0221F0DE
_0221F0D6:
	b _0221F3B0
_0221F0D8:
	cmp r5, #0x65
	bgt _0221F0E2
	bne _0221F0E0
_0221F0DE:
	b _0221F2BE
_0221F0E0:
	b _0221F3B0
_0221F0E2:
	cmp r5, #0x95
	bne _0221F0E8
	b _0221F2CE
_0221F0E8:
	b _0221F3B0
_0221F0EA:
	mov r0, #0x5a
	lsl r0, r0, #2
	cmp r5, r0
	bgt _0221F110
	blt _0221F0F6
	b _0221F28E
_0221F0F6:
	cmp r5, #0xde
	bgt _0221F10A
	cmp r5, #0xda
	blt _0221F108
	bne _0221F102
	b _0221F30E
_0221F102:
	cmp r5, #0xde
	bne _0221F108
	b _0221F32C
_0221F108:
	b _0221F3B0
_0221F10A:
	cmp r5, #0xed
	beq _0221F1E8
	b _0221F3B0
_0221F110:
	add r1, r0, #0
	add r1, #0x57
	cmp r5, r1
	bgt _0221F12A
	add r1, r0, #0
	add r1, #0x57
	cmp r5, r1
	blt _0221F122
_0221F120:
	b _0221F374
_0221F122:
	add r0, r0, #3
	cmp r5, r0
	beq _0221F132
	b _0221F3B0
_0221F12A:
	add r0, #0x59
	cmp r5, r0
	beq _0221F15A
	b _0221F3B0
_0221F132:
	ldr r0, [sp, #0x68]
	cmp r0, #0x67
	beq _0221F166
	ldr r0, [sp, #0x6c]
	cmp r0, #0
	bne _0221F166
	ldr r1, [sp, #0x1c]
	add r0, r6, #0
	mov r2, #0xb
	bl GetItemVar
	add r4, r0, #0
	beq _0221F166
	ldr r1, [sp, #0x1c]
	add r0, r6, #0
	mov r2, #0xc
	bl GetItemVar
	add r7, r0, #0
	b _0221F3B4
_0221F15A:
	ldr r0, [sp, #0x68]
	cmp r0, #0x67
	beq _0221F166
	ldr r0, [sp, #0x6c]
	cmp r0, #0
	beq _0221F168
_0221F166:
	b _0221F3B4
_0221F168:
	ldr r1, [sp, #0x1c]
	add r0, r6, #0
	mov r2, #1
	bl GetItemVar
	sub r0, #0x7e
	cmp r0, #0xf
	bhi _0221F1E4
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221F184: ; jump table
	.short _0221F1C4 - _0221F184 - 2 ; case 0
	.short _0221F1C8 - _0221F184 - 2 ; case 1
	.short _0221F1D0 - _0221F184 - 2 ; case 2
	.short _0221F1CC - _0221F184 - 2 ; case 3
	.short _0221F1D8 - _0221F184 - 2 ; case 4
	.short _0221F1A4 - _0221F184 - 2 ; case 5
	.short _0221F1AC - _0221F184 - 2 ; case 6
	.short _0221F1B0 - _0221F184 - 2 ; case 7
	.short _0221F1A8 - _0221F184 - 2 ; case 8
	.short _0221F1D4 - _0221F184 - 2 ; case 9
	.short _0221F1B8 - _0221F184 - 2 ; case 10
	.short _0221F1B4 - _0221F184 - 2 ; case 11
	.short _0221F1BC - _0221F184 - 2 ; case 12
	.short _0221F1DC - _0221F184 - 2 ; case 13
	.short _0221F1E0 - _0221F184 - 2 ; case 14
	.short _0221F1C0 - _0221F184 - 2 ; case 15
_0221F1A4:
	mov r7, #1
	b _0221F3B4
_0221F1A8:
	mov r7, #2
	b _0221F3B4
_0221F1AC:
	mov r7, #3
	b _0221F3B4
_0221F1B0:
	mov r7, #4
	b _0221F3B4
_0221F1B4:
	mov r7, #5
	b _0221F3B4
_0221F1B8:
	mov r7, #6
	b _0221F3B4
_0221F1BC:
	mov r7, #7
	b _0221F3B4
_0221F1C0:
	mov r7, #8
	b _0221F3B4
_0221F1C4:
	mov r7, #0xa
	b _0221F3B4
_0221F1C8:
	mov r7, #0xb
	b _0221F3B4
_0221F1CC:
	mov r7, #0xc
	b _0221F3B4
_0221F1D0:
	mov r7, #0xd
	b _0221F3B4
_0221F1D4:
	mov r7, #0xe
	b _0221F3B4
_0221F1D8:
	mov r7, #0xf
	b _0221F3B4
_0221F1DC:
	mov r7, #0x10
	b _0221F3B4
_0221F1E0:
	mov r7, #0x11
	b _0221F3B4
_0221F1E4:
	mov r7, #0
	b _0221F3B4
_0221F1E8:
	ldr r0, [sp, #0x60]
	ldr r1, [sp, #0x60]
	ldrb r0, [r0, #1]
	ldrb r3, [r1, #4]
	ldrb r1, [r1, #5]
	str r0, [sp, #0x2c]
	ldr r0, [sp, #0x60]
	str r1, [sp, #0x34]
	ldrb r0, [r0]
	lsl r1, r1, #0x1f
	lsr r1, r1, #0x1a
	str r0, [sp, #0x30]
	ldr r0, [sp, #0x60]
	str r1, [sp, #0x38]
	ldrb r2, [r0, #2]
	lsl r1, r3, #0x1f
	lsr r1, r1, #0x1b
	ldrb r0, [r0, #3]
	str r1, [sp, #0x3c]
	mov r4, #1
	lsl r1, r0, #0x1f
	lsr r1, r1, #0x1c
	str r1, [sp, #0x40]
	lsl r1, r2, #0x1f
	lsr r7, r1, #0x1d
	ldr r1, [sp, #0x30]
	and r1, r4
	ldr r4, [sp, #0x2c]
	lsl r4, r4, #0x1f
	lsr r4, r4, #0x1e
	orr r1, r4
	add r4, r7, #0
	orr r4, r1
	ldr r1, [sp, #0x40]
	orr r4, r1
	ldr r1, [sp, #0x3c]
	orr r4, r1
	ldr r1, [sp, #0x38]
	orr r1, r4
	str r1, [sp, #0x24]
	mov r1, #2
	ldr r4, [sp, #0x34]
	and r3, r1
	and r4, r1
	lsl r4, r4, #4
	str r4, [sp, #0x44]
	and r0, r1
	lsl r4, r3, #3
	lsl r3, r0, #2
	add r0, r2, #0
	and r0, r1
	lsl r2, r0, #1
	ldr r0, [sp, #0x30]
	and r0, r1
	asr r7, r0, #1
	ldr r0, [sp, #0x2c]
	and r0, r1
	orr r0, r7
	orr r0, r2
	orr r0, r3
	add r1, r4, #0
	orr r1, r0
	ldr r0, [sp, #0x44]
	orr r1, r0
	mov r0, #0x28
	mul r0, r1
	mov r1, #0x3f
	bl _s32_div_f
	add r4, r0, #0
	ldr r1, [sp, #0x24]
	mov r0, #0xf
	mul r0, r1
	mov r1, #0x3f
	add r4, #0x1e
	bl _s32_div_f
	add r7, r0, #1
	cmp r7, #9
	bge _0221F28A
	b _0221F3B4
_0221F28A:
	add r7, r7, #1
	b _0221F3B4
_0221F28E:
	mov r0, #0x3d
	lsl r0, r0, #4
	ldrb r0, [r6, r0]
	ldr r2, _0221F454 ; =0x000021F0
	lsl r0, r0, #2
	add r0, r6, r0
	ldr r1, [r0, r2]
	mov r0, #0x19
	mul r0, r1
	ldr r1, [sp, #0x64]
	lsl r1, r1, #2
	add r1, r6, r1
	ldr r1, [r1, r2]
	bl _u32_div_f
	add r4, r0, #1
	cmp r4, #0x96
	ble _0221F2B4
	mov r4, #0x96
_0221F2B4:
	mov r7, #0
	b _0221F3B4
_0221F2B8:
	mov r0, #0x28
	str r0, [sp, #0x20]
	b _0221F3B4
_0221F2BE:
	ldr r0, [sp, #0x64]
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221F458 ; =0x00002D74
	add r1, r6, r1
	ldrb r0, [r1, r0]
	str r0, [sp, #0x20]
	b _0221F3B4
_0221F2CE:
	ldr r0, [sp, #0x18]
	bl BattleSystem_Random
	mov r1, #0xb
	bl _s32_div_f
	ldr r0, [sp, #0x64]
	mov r2, #0xc0
	mul r2, r0
	ldr r0, _0221F458 ; =0x00002D74
	add r2, r6, r2
	ldrb r2, [r2, r0]
	add r0, r1, #5
	mov r1, #0xa
	mul r0, r2
	bl _s32_div_f
	str r0, [sp, #0x20]
	b _0221F3B4
_0221F2F4:
	ldr r0, [sp, #0x64]
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221F45C ; =0x00002D75
	add r1, r6, r1
	ldrb r1, [r1, r0]
	mov r0, #0xa
	mul r0, r1
	mov r1, #0x19
	bl _s32_div_f
	add r4, r0, #0
	b _0221F3B4
_0221F30E:
	ldr r0, [sp, #0x64]
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221F45C ; =0x00002D75
	add r1, r6, r1
	ldrb r1, [r1, r0]
	mov r0, #0xff
	sub r1, r0, r1
	mov r0, #0xa
	mul r0, r1
	mov r1, #0x19
	bl _s32_div_f
	add r4, r0, #0
	b _0221F3B4
_0221F32C:
	ldr r0, [sp, #0x18]
	bl BattleSystem_Random
	mov r1, #0x64
	bl _s32_div_f
	cmp r1, #5
	bge _0221F340
	mov r4, #0xa
	b _0221F36A
_0221F340:
	cmp r1, #0xf
	bge _0221F348
	mov r4, #0x1e
	b _0221F36A
_0221F348:
	cmp r1, #0x23
	bge _0221F350
	mov r4, #0x32
	b _0221F36A
_0221F350:
	cmp r1, #0x41
	bge _0221F358
	mov r4, #0x46
	b _0221F36A
_0221F358:
	cmp r1, #0x55
	bge _0221F360
	mov r4, #0x5a
	b _0221F36A
_0221F360:
	cmp r1, #0x5f
	bge _0221F368
	mov r4, #0x6e
	b _0221F36A
_0221F368:
	mov r4, #0x96
_0221F36A:
	mov r7, #0
	b _0221F3B4
_0221F36E:
	mov r0, #0x14
	str r0, [sp, #0x20]
	b _0221F3B4
_0221F374:
	mov r2, #0x3d
	lsl r2, r2, #4
	ldrb r3, [r6, r2]
	mov r2, #0xc0
	ldr r1, _0221F460 ; =ov10_0222B068
	mul r2, r3
	add r3, r6, r2
	ldr r2, _0221F464 ; =0x00002D60
	ldr r4, _0221F468 ; =0x0000FFFF
	ldr r2, [r3, r2]
	mov r0, #0
_0221F38A:
	ldrh r3, [r1]
	cmp r3, r2
	bge _0221F39A
	add r1, r1, #4
	ldrh r3, [r1]
	add r0, r0, #1
	cmp r3, r4
	bne _0221F38A
_0221F39A:
	ldr r1, _0221F460 ; =ov10_0222B068
	lsl r0, r0, #2
	ldrh r2, [r1, r0]
	ldr r1, _0221F468 ; =0x0000FFFF
	cmp r2, r1
	beq _0221F3AC
	ldr r1, _0221F46C ; =ov10_0222B06A
	ldrh r4, [r1, r0]
	b _0221F3B4
_0221F3AC:
	mov r4, #0x78
	b _0221F3B4
_0221F3B0:
	mov r4, #0
	add r7, r4, #0
_0221F3B4:
	ldr r0, [sp, #0x20]
	cmp r0, #0
	bne _0221F3FE
	mov r0, #6
	lsl r0, r0, #6
	mov ip, r0
	ldr r0, [r6, r0]
	ldr r3, [sp, #0x28]
	str r0, [sp]
	lsl r0, r4, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #4]
	lsl r0, r7, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	ldr r0, [sp, #0x64]
	lsl r3, r3, #2
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0xc]
	mov r0, #0x3d
	lsl r0, r0, #4
	ldrb r0, [r6, r0]
	add r4, r6, r3
	mov r3, ip
	str r0, [sp, #0x10]
	mov r0, #1
	str r0, [sp, #0x14]
	add r3, #0x3c
	ldr r0, [sp, #0x18]
	ldr r3, [r4, r3]
	add r1, r6, #0
	add r2, r5, #0
	bl CalcMoveDamage
	str r0, [sp, #0x20]
	b _0221F40A
_0221F3FE:
	ldr r1, _0221F470 ; =0x0000213C
	mov r0, #2
	ldr r2, [r6, r1]
	lsl r0, r0, #0xa
	orr r0, r2
	str r0, [r6, r1]
_0221F40A:
	ldr r0, [sp, #0x64]
	add r1, r6, #0
	str r0, [sp]
	mov r0, #0x3d
	lsl r0, r0, #4
	ldrb r0, [r6, r0]
	add r2, r5, #0
	add r3, r7, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x20]
	str r0, [sp, #8]
	add r0, sp, #0x48
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x18]
	bl ov12_02251D28
	ldr r2, _0221F470 ; =0x0000213C
	ldr r1, _0221F474 ; =0xFFFFF7FF
	ldr r3, [r6, r2]
	and r1, r3
	str r1, [r6, r2]
	ldr r2, [sp, #0x48]
	ldr r1, _0221F478 ; =0x00140808
	tst r1, r2
	beq _0221F442
	add sp, #0x4c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0221F442:
	add r1, sp, #0x70
	ldrb r1, [r1]
	mul r1, r0
	add r0, r1, #0
	mov r1, #0x64
	bl DamageDivide
	add sp, #0x4c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F454: .word 0x000021F0
_0221F458: .word 0x00002D74
_0221F45C: .word 0x00002D75
_0221F460: .word ov10_0222B068
_0221F464: .word 0x00002D60
_0221F468: .word 0x0000FFFF
_0221F46C: .word ov10_0222B06A
_0221F470: .word 0x0000213C
_0221F474: .word 0xFFFFF7FF
_0221F478: .word 0x00140808
	thumb_func_end ov10_0221F084

	thumb_func_start ov10_0221F47C
ov10_0221F47C: ; 0x0221F47C
	push {r3, r4, r5, r6, r7, lr}
	add r6, r2, #0
	ldr r2, _0221F5E8 ; =0x00000137
	add r7, r0, #0
	add r4, r1, #0
	cmp r3, r2
	bgt _0221F494
	blt _0221F48E
	b _0221F590
_0221F48E:
	cmp r3, #0xed
	beq _0221F536
	b _0221F5E2
_0221F494:
	add r0, r2, #0
	add r0, #0x34
	cmp r3, r0
	bgt _0221F4A4
	add r2, #0x34
	cmp r3, r2
	beq _0221F4AC
	b _0221F5E2
_0221F4A4:
	add r2, #0x8a
	cmp r3, r2
	beq _0221F4B8
	b _0221F5E2
_0221F4AC:
	add r0, r4, #0
	add r1, r6, #0
	bl GetNaturalGiftType
	add r5, r0, #0
	b _0221F5E4
_0221F4B8:
	add r0, r4, #0
	add r1, r6, #0
	bl GetBattlerHeldItemEffect
	sub r0, #0x7e
	cmp r0, #0xf
	bhi _0221F532
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221F4D2: ; jump table
	.short _0221F512 - _0221F4D2 - 2 ; case 0
	.short _0221F516 - _0221F4D2 - 2 ; case 1
	.short _0221F51E - _0221F4D2 - 2 ; case 2
	.short _0221F51A - _0221F4D2 - 2 ; case 3
	.short _0221F526 - _0221F4D2 - 2 ; case 4
	.short _0221F4F2 - _0221F4D2 - 2 ; case 5
	.short _0221F4FA - _0221F4D2 - 2 ; case 6
	.short _0221F4FE - _0221F4D2 - 2 ; case 7
	.short _0221F4F6 - _0221F4D2 - 2 ; case 8
	.short _0221F522 - _0221F4D2 - 2 ; case 9
	.short _0221F506 - _0221F4D2 - 2 ; case 10
	.short _0221F502 - _0221F4D2 - 2 ; case 11
	.short _0221F50A - _0221F4D2 - 2 ; case 12
	.short _0221F52A - _0221F4D2 - 2 ; case 13
	.short _0221F52E - _0221F4D2 - 2 ; case 14
	.short _0221F50E - _0221F4D2 - 2 ; case 15
_0221F4F2:
	mov r5, #1
	b _0221F5E4
_0221F4F6:
	mov r5, #2
	b _0221F5E4
_0221F4FA:
	mov r5, #3
	b _0221F5E4
_0221F4FE:
	mov r5, #4
	b _0221F5E4
_0221F502:
	mov r5, #5
	b _0221F5E4
_0221F506:
	mov r5, #6
	b _0221F5E4
_0221F50A:
	mov r5, #7
	b _0221F5E4
_0221F50E:
	mov r5, #8
	b _0221F5E4
_0221F512:
	mov r5, #0xa
	b _0221F5E4
_0221F516:
	mov r5, #0xb
	b _0221F5E4
_0221F51A:
	mov r5, #0xc
	b _0221F5E4
_0221F51E:
	mov r5, #0xd
	b _0221F5E4
_0221F522:
	mov r5, #0xe
	b _0221F5E4
_0221F526:
	mov r5, #0xf
	b _0221F5E4
_0221F52A:
	mov r5, #0x10
	b _0221F5E4
_0221F52E:
	mov r5, #0x11
	b _0221F5E4
_0221F532:
	mov r5, #0
	b _0221F5E4
_0221F536:
	ldr r0, _0221F5EC ; =0x00002D54
	add r1, r4, r0
	mov r0, #0xc0
	mul r0, r6
	ldr r4, [r1, r0]
	lsl r0, r4, #2
	lsr r0, r0, #0x1b
	lsl r0, r0, #0x1f
	lsr r5, r0, #0x1a
	lsl r0, r4, #7
	lsr r0, r0, #0x1b
	lsl r0, r0, #0x1f
	lsr r3, r0, #0x1b
	lsl r0, r4, #0xc
	lsr r0, r0, #0x1b
	lsl r0, r0, #0x1f
	lsr r2, r0, #0x1c
	lsl r0, r4, #0x11
	lsr r0, r0, #0x1b
	lsl r0, r0, #0x1f
	lsr r1, r0, #0x1d
	lsl r0, r4, #0x1b
	lsl r4, r4, #0x16
	lsr r4, r4, #0x1b
	lsr r6, r0, #0x1b
	mov r0, #1
	lsl r4, r4, #0x1f
	and r0, r6
	lsr r4, r4, #0x1e
	orr r0, r4
	orr r0, r1
	orr r0, r2
	orr r0, r3
	add r1, r5, #0
	orr r1, r0
	mov r0, #0xf
	mul r0, r1
	mov r1, #0x3f
	bl _s32_div_f
	add r5, r0, #1
	cmp r5, #9
	blt _0221F5E4
	add r5, r5, #1
	b _0221F5E4
_0221F590:
	mov r2, #0xd
	str r2, [sp]
	mov r2, #8
	mov r3, #0
	bl CheckAbilityActive
	cmp r0, #0
	bne _0221F5E4
	mov r0, #0x4c
	str r0, [sp]
	add r0, r7, #0
	add r1, r4, #0
	mov r2, #8
	mov r3, #0
	bl CheckAbilityActive
	cmp r0, #0
	bne _0221F5E4
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	ldr r1, _0221F5F0 ; =0x000080FF
	tst r1, r0
	beq _0221F5E4
	mov r1, #3
	tst r1, r0
	beq _0221F5C8
	mov r5, #0xb
_0221F5C8:
	mov r1, #0xc
	tst r1, r0
	beq _0221F5D0
	mov r5, #5
_0221F5D0:
	mov r1, #0x30
	tst r1, r0
	beq _0221F5D8
	mov r5, #0xa
_0221F5D8:
	mov r1, #0xc0
	tst r0, r1
	beq _0221F5E4
	mov r5, #0xf
	b _0221F5E4
_0221F5E2:
	mov r5, #0
_0221F5E4:
	add r0, r5, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F5E8: .word 0x00000137
_0221F5EC: .word 0x00002D54
_0221F5F0: .word 0x000080FF
	thumb_func_end ov10_0221F47C

	thumb_func_start ov10_0221F5F4
ov10_0221F5F4: ; 0x0221F5F4
	push {r4, r5}
	mov r2, #0xc0
	mul r2, r1
	add r5, r0, r2
	mov r2, #0xb7
	lsl r2, r2, #6
	ldr r4, [r5, r2]
	mov r3, #0x20
	tst r3, r4
	beq _0221F620
	add r2, #8
	ldr r2, [r5, r2]
	lsl r2, r2, #0x11
	lsr r2, r2, #0x1e
	bne _0221F620
	add r1, r0, r1
	ldr r0, _0221F628 ; =0x000021A4
	mov r2, #6
	strb r2, [r1, r0]
	mov r0, #1
	pop {r4, r5}
	bx lr
_0221F620:
	mov r0, #0
	pop {r4, r5}
	bx lr
	nop
_0221F628: .word 0x000021A4
	thumb_func_end ov10_0221F5F4
