	.include "asm/macros.inc"
	.include "overlay_12_battle_controller.inc"
	.include "global.inc"

	.extern ov12_022645F8

	.text

	thumb_func_start ov12_02263D14
ov12_02263D14: ; 0x02263D14
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r1, #0
	add r7, r0, #0
	add r4, r2, #0
	add r6, r3, #0
	bl BattleSystem_GetBattleContext
	add r1, r5, #0
	bl BattleBuffer_Clear
	mov r1, #0x2b
	add r0, sp, #4
	strb r1, [r0]
	strh r4, [r0, #2]
	strb r6, [r0, #1]
	mov r0, #4
	str r0, [sp]
	add r0, r7, #0
	mov r1, #1
	add r2, r5, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov12_02263D14

	thumb_func_start BattleController_EmitPlayMosaicAnimation
BattleController_EmitPlayMosaicAnimation: ; 0x02263D48
	push {r3, r4, r5, lr}
	sub sp, #8
	add r4, r1, #0
	mov r5, #0x2c
	add r1, sp, #4
	strb r5, [r1]
	strb r2, [r1, #1]
	strb r3, [r1, #2]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitPlayMosaicAnimation

	thumb_func_start BattleController_EmitChangeForm
BattleController_EmitChangeForm: ; 0x02263D6C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r7, r1, #0
	mov r1, #0x2d
	add r3, sp, #4
	strb r1, [r3]
	mov r1, #0xc0
	add r6, r7, #0
	mul r6, r1
	ldr r1, [r0, #0x30]
	add r2, r1, r6
	mov r1, #0xb5
	lsl r1, r1, #6
	ldrh r2, [r2, r1]
	strh r2, [r3, #2]
	ldr r2, [r0, #0x30]
	add r4, r2, r6
	add r2, r1, #0
	add r2, #0x26
	ldrb r2, [r4, r2]
	lsl r2, r2, #0x1a
	lsr r2, r2, #0x1f
	strb r2, [r3, #5]
	ldr r2, [r0, #0x30]
	add r5, r2, r6
	add r2, r1, #0
	add r2, #0x70
	ldr r4, [r5, r2]
	mov r2, #2
	lsl r2, r2, #0x14
	tst r2, r4
	beq _02263DC0
	add r2, r1, #0
	add r2, #0xba
	ldrh r2, [r5, r2]
	add r1, #0xa4
	strb r2, [r3, #4]
	ldr r2, [r0, #0x30]
	add r2, r2, r6
	ldr r1, [r2, r1]
	str r1, [sp, #0xc]
	b _02263DD6
_02263DC0:
	add r2, r1, #0
	add r2, #0x7e
	ldrb r2, [r5, r2]
	add r1, #0x68
	lsl r2, r2, #0x1c
	lsr r2, r2, #0x1c
	strb r2, [r3, #4]
	ldr r2, [r0, #0x30]
	add r2, r2, r6
	ldr r1, [r2, r1]
	str r1, [sp, #0xc]
_02263DD6:
	ldr r1, [r0, #0x30]
	add r3, sp, #4
	add r2, r1, r6
	ldr r1, _02263DF8 ; =0x00002D66
	ldrb r1, [r2, r1]
	lsl r1, r1, #0x1b
	lsr r2, r1, #0x1b
	add r1, sp, #4
	strb r2, [r1, #1]
	mov r1, #0xc
	str r1, [sp]
	mov r1, #1
	add r2, r7, #0
	bl ov12_02262240
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02263DF8: .word 0x00002D66
	thumb_func_end BattleController_EmitChangeForm

	thumb_func_start BattleController_EmitSetBattleBackground
BattleController_EmitSetBattleBackground: ; 0x02263DFC
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0x2e
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitSetBattleBackground

	thumb_func_start ov12_02263E18
ov12_02263E18: ; 0x02263E18
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0x2f
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov12_02263E18

	thumb_func_start BattleController_EmitInitStartBallGauge
BattleController_EmitInitStartBallGauge: ; 0x02263E34
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	str r4, [sp]
	ldr r1, [r5, #0x30]
	add r2, sp, #4
	mov r3, #0x30
	bl ov12_022645F8
	mov r0, #8
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end BattleController_EmitInitStartBallGauge

	thumb_func_start BattleController_EmitDeleteStartBallGauge
BattleController_EmitDeleteStartBallGauge: ; 0x02263E5C
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	str r4, [sp]
	ldr r1, [r5, #0x30]
	add r2, sp, #4
	mov r3, #0x31
	bl ov12_022645F8
	mov r0, #8
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end BattleController_EmitDeleteStartBallGauge

	thumb_func_start BattleController_EmitInitBallGauge
BattleController_EmitInitBallGauge: ; 0x02263E84
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	str r4, [sp]
	ldr r1, [r5, #0x30]
	add r2, sp, #4
	mov r3, #0x32
	bl ov12_022645F8
	mov r0, #8
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end BattleController_EmitInitBallGauge

	thumb_func_start BattleController_EmitDeleteBallGauge
BattleController_EmitDeleteBallGauge: ; 0x02263EAC
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	str r4, [sp]
	ldr r1, [r5, #0x30]
	add r2, sp, #4
	mov r3, #0x33
	bl ov12_022645F8
	mov r0, #8
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end BattleController_EmitDeleteBallGauge

	thumb_func_start BattleController_EmitLoadBallGfx
BattleController_EmitLoadBallGfx: ; 0x02263ED4
	push {r3, lr}
	sub sp, #8
	mov r1, #0x34
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	mov r2, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitLoadBallGfx

	thumb_func_start BattleController_EmitDeleteBallGfx
BattleController_EmitDeleteBallGfx: ; 0x02263EF0
	push {r3, lr}
	sub sp, #8
	mov r1, #0x35
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	mov r2, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitDeleteBallGfx

	thumb_func_start BattleController_EmitIncrementGameStat
BattleController_EmitIncrementGameStat: ; 0x02263F0C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r4, r1, #0
	mov r5, #0x36
	add r1, sp, #4
	strb r5, [r1]
	strb r2, [r1, #1]
	strh r3, [r1, #2]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitIncrementGameStat

	thumb_func_start BattleController_EmitShowWaitMessage
BattleController_EmitShowWaitMessage: ; 0x02263F30
	push {r4, r5, lr}
	sub sp, #0x24
	add r5, r0, #0
	add r4, r1, #0
	bl BattleSystem_GetBattleType
	mov r2, #0x37
	add r1, sp, #4
	strb r2, [r1]
	mov r2, #0
	strh r2, [r1, #2]
	mov r1, #4
	tst r0, r1
	beq _02263F84
	bl sub_0202FC48
	cmp r0, #1
	bne _02263F84
	ldr r0, _02263F88 ; =0x0000240C
	ldr r1, [r5, r0]
	mov r0, #0x10
	tst r0, r1
	bne _02263F84
	add r0, r5, #0
	add r1, sp, #8
	bl ov12_0223BE68
	add r1, sp, #4
	strh r0, [r1, #2]
	ldrh r0, [r1, #2]
	cmp r0, #0x1c
	blo _02263F74
	bl GF_AssertFail
_02263F74:
	mov r0, #0x20
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
_02263F84:
	add sp, #0x24
	pop {r4, r5, pc}
	.balign 4, 0
_02263F88: .word 0x0000240C
	thumb_func_end BattleController_EmitShowWaitMessage

	thumb_func_start ov12_02263F8C
ov12_02263F8C: ; 0x02263F8C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x64
	str r0, [sp, #4]
	add r3, r1, #0
	mov r1, #0x38
	add r0, sp, #0xc
	strb r1, [r0]
	mov r0, #0
	add r7, sp, #0xc
	str r2, [sp, #8]
	ldr r4, _02264024 ; =0x00002D66
	mov ip, r0
	add r0, r3, r4
	add r4, #0x58
	add r1, r7, #0
	add r2, r7, #0
	add r6, r3, r4
_02263FAE:
	mov r4, #0xb5
	lsl r4, r4, #6
	ldrh r4, [r3, r4]
	strh r4, [r7, #0x18]
	ldrb r4, [r0]
	lsl r4, r4, #0x1a
	lsr r5, r4, #0x1f
	add r4, r1, #0
	add r4, #0x24
	strb r5, [r4]
	ldrb r4, [r0]
	lsl r4, r4, #0x1b
	lsr r5, r4, #0x1b
	add r4, r1, #0
	add r4, #0x28
	strb r5, [r4]
	ldr r4, _02264028 ; =0x00002DB0
	ldr r5, [r3, r4]
	mov r4, #2
	lsl r4, r4, #0x14
	tst r4, r5
	beq _02263FE8
	ldr r4, _0226402C ; =0x00002DFA
	ldrh r5, [r3, r4]
	add r4, r1, #0
	add r4, #0x20
	strb r5, [r4]
	ldr r4, _02264030 ; =0x00002DE4
	b _02263FF6
_02263FE8:
	ldrb r4, [r6]
	lsl r4, r4, #0x1c
	lsr r5, r4, #0x1c
	add r4, r1, #0
	add r4, #0x20
	strb r5, [r4]
	ldr r4, _02264034 ; =0x00002DA8
_02263FF6:
	ldr r4, [r3, r4]
	add r3, #0xc0
	str r4, [r2, #0x2c]
	mov r4, ip
	add r4, r4, #1
	add r7, r7, #2
	add r0, #0xc0
	add r1, r1, #1
	add r2, r2, #4
	add r6, #0xc0
	mov ip, r4
	cmp r4, #4
	blt _02263FAE
	mov r0, #0x58
	str r0, [sp]
	ldr r0, [sp, #4]
	ldr r2, [sp, #8]
	mov r1, #1
	add r3, sp, #0xc
	bl ov12_02262240
	add sp, #0x64
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02264024: .word 0x00002D66
_02264028: .word 0x00002DB0
_0226402C: .word 0x00002DFA
_02264030: .word 0x00002DE4
_02264034: .word 0x00002DA8
	thumb_func_end ov12_02263F8C

	thumb_func_start ov12_02264038
ov12_02264038: ; 0x02264038
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0x39
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov12_02264038

	thumb_func_start ov12_02264054
ov12_02264054: ; 0x02264054
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0x3a
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov12_02264054

	thumb_func_start BattleController_EmitPrintResultMessage
BattleController_EmitPrintResultMessage: ; 0x02264070
	push {r3, lr}
	sub sp, #8
	mov r1, #0x3b
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	mov r2, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitPrintResultMessage

	thumb_func_start BattleController_EmitRunAwayMessage
BattleController_EmitRunAwayMessage: ; 0x0226408C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r6, r0, #0
	add r5, r1, #0
	bl BattleSystem_GetBattleType
	str r0, [sp, #4]
	mov r1, #0x3c
	add r0, sp, #8
	strb r1, [r0]
	mov r4, #0
	strb r4, [r0, #1]
	strh r4, [r0, #2]
	add r0, r6, #0
	bl BattleSystem_GetMaxBattlers
	cmp r0, #0
	ble _022640D4
	add r7, sp, #8
_022640B2:
	ldr r0, _02264118 ; =0x000021A8
	ldr r0, [r5, r0]
	cmp r0, #0x10
	bne _022640C6
	add r0, r4, #0
	bl MaskOfFlagNo
	ldrb r1, [r7, #1]
	orr r0, r1
	strb r0, [r7, #1]
_022640C6:
	add r0, r6, #0
	add r5, #0x10
	add r4, r4, #1
	bl BattleSystem_GetMaxBattlers
	cmp r4, r0
	blt _022640B2
_022640D4:
	ldr r0, [sp, #4]
	mov r1, #4
	tst r0, r1
	beq _02264104
	bl sub_0202FC48
	cmp r0, #1
	bne _02264104
	ldr r0, _0226411C ; =0x0000240C
	ldr r1, [r6, r0]
	mov r0, #0x10
	tst r0, r1
	bne _02264104
	add r0, r6, #0
	add r1, sp, #0xc
	bl ov12_0223BE68
	add r1, sp, #8
	strh r0, [r1, #2]
	ldrh r0, [r1, #2]
	cmp r0, #0x1c
	blo _02264104
	bl GF_AssertFail
_02264104:
	mov r0, #0x20
	str r0, [sp]
	add r0, r6, #0
	mov r1, #1
	mov r2, #0
	add r3, sp, #8
	bl ov12_02262240
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02264118: .word 0x000021A8
_0226411C: .word 0x0000240C
	thumb_func_end BattleController_EmitRunAwayMessage

	thumb_func_start BattleController_EmitForefitMessage
BattleController_EmitForefitMessage: ; 0x02264120
	push {r3, r4, lr}
	sub sp, #0x24
	add r4, r0, #0
	bl BattleSystem_GetBattleType
	mov r2, #0x3d
	add r1, sp, #4
	strb r2, [r1]
	mov r2, #0
	strh r2, [r1, #2]
	mov r1, #4
	tst r0, r1
	beq _02264162
	bl sub_0202FC48
	cmp r0, #1
	bne _02264162
	ldr r0, _02264178 ; =0x0000240C
	ldr r1, [r4, r0]
	mov r0, #0x10
	tst r0, r1
	bne _02264162
	add r0, r4, #0
	add r1, sp, #8
	bl ov12_0223BE68
	add r1, sp, #4
	strh r0, [r1, #2]
	ldrh r0, [r1, #2]
	cmp r0, #0x1c
	blo _02264162
	bl GF_AssertFail
_02264162:
	mov r0, #0x20
	str r0, [sp]
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0x24
	pop {r3, r4, pc}
	nop
_02264178: .word 0x0000240C
	thumb_func_end BattleController_EmitForefitMessage
