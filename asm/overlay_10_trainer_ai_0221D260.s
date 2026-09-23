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
