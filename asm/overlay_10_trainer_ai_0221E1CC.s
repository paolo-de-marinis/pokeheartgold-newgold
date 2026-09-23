	.include "asm/macros.inc"
	.include "overlay_10.inc"
	.include "global.inc"

	.text

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
