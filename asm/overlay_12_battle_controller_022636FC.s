	.include "asm/macros.inc"
	.include "overlay_12_battle_controller.inc"
	.include "global.inc"

	.text

	thumb_func_start BattleController_EmitPlaySE
BattleController_EmitPlaySE: ; 0x022636FC
	push {r4, lr}
	sub sp, #8
	mov r4, #0x1b
	add r1, sp, #4
	strb r4, [r1]
	strh r2, [r1, #2]
	mov r1, #4
	str r1, [sp]
	add r2, r3, #0
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitPlaySE

	thumb_func_start BattleController_EmitFadeOutBattle
BattleController_EmitFadeOutBattle: ; 0x0226371C
	push {r3, lr}
	sub sp, #8
	mov r1, #0x1c
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
	thumb_func_end BattleController_EmitFadeOutBattle

	thumb_func_start BattleController_EmitToggleVanish
BattleController_EmitToggleVanish: ; 0x02263738
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	mov ip, r1
	mov r3, #0x1d
	add r1, sp, #8
	strb r3, [r1]
	strb r2, [r1, #1]
	ldr r3, [r0, #0x30]
	mov r2, #0xc0
	mov r1, ip
	mul r2, r1
	ldr r1, _022637F0 ; =0x00002DB0
	add r2, r3, r2
	ldr r2, [r2, r1]
	mov r1, #1
	lsl r1, r1, #0x18
	tst r1, r2
	beq _02263760
	mov r2, #1
	b _02263762
_02263760:
	mov r2, #0
_02263762:
	add r7, sp, #8
	add r1, sp, #8
	mov r3, #0
	strb r2, [r1, #2]
	str r3, [sp, #4]
	add r4, r7, #0
	add r5, r7, #0
_02263770:
	ldr r1, [r0, #0x30]
	add r2, r1, r3
	mov r1, #0xb5
	lsl r1, r1, #6
	ldrh r1, [r2, r1]
	strh r1, [r7, #4]
	ldr r1, [r0, #0x30]
	add r2, r1, r3
	ldr r1, _022637F4 ; =0x00002D66
	ldrb r1, [r2, r1]
	lsl r1, r1, #0x1a
	lsr r1, r1, #0x1f
	strb r1, [r4, #0x10]
	ldr r1, [r0, #0x30]
	add r2, r1, r3
	ldr r1, _022637F4 ; =0x00002D66
	ldrb r1, [r2, r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1b
	strb r1, [r4, #0x14]
	ldr r1, [r0, #0x30]
	add r6, r1, r3
	ldr r1, _022637F0 ; =0x00002DB0
	ldr r2, [r6, r1]
	mov r1, #2
	lsl r1, r1, #0x14
	tst r1, r2
	beq _022637B6
	ldr r1, _022637F8 ; =0x00002DFA
	ldrh r1, [r6, r1]
	strb r1, [r4, #0xc]
	ldr r1, [r0, #0x30]
	add r2, r1, r3
	ldr r1, _022637FC ; =0x00002DE4
	b _022637C6
_022637B6:
	ldr r1, _02263800 ; =0x00002DBE
	ldrb r1, [r6, r1]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	strb r1, [r4, #0xc]
	ldr r1, [r0, #0x30]
	add r2, r1, r3
	ldr r1, _02263804 ; =0x00002DA8
_022637C6:
	ldr r1, [r2, r1]
	add r3, #0xc0
	str r1, [r5, #0x18]
	ldr r1, [sp, #4]
	add r7, r7, #2
	add r1, r1, #1
	add r4, r4, #1
	add r5, r5, #4
	str r1, [sp, #4]
	cmp r1, #4
	blt _02263770
	mov r1, #0x28
	str r1, [sp]
	mov r1, #1
	mov r2, ip
	add r3, sp, #8
	bl ov12_02262240
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	nop
_022637F0: .word 0x00002DB0
_022637F4: .word 0x00002D66
_022637F8: .word 0x00002DFA
_022637FC: .word 0x00002DE4
_02263800: .word 0x00002DBE
_02263804: .word 0x00002DA8
	thumb_func_end BattleController_EmitToggleVanish

	thumb_func_start BattleController_EmitHealthbarStatus
BattleController_EmitHealthbarStatus: ; 0x02263808
	push {r4, lr}
	sub sp, #8
	add r4, r1, #0
	mov r3, #0x1e
	add r1, sp, #4
	strb r3, [r1]
	strb r2, [r1, #1]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r4, pc}
	thumb_func_end BattleController_EmitHealthbarStatus

	thumb_func_start BattleController_EmitPrintTrainerMessage
BattleController_EmitPrintTrainerMessage: ; 0x02263828
	push {r4, lr}
	sub sp, #8
	add r4, r1, #0
	mov r3, #0x1f
	add r1, sp, #4
	strb r3, [r1]
	strb r2, [r1, #1]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r4, pc}
	thumb_func_end BattleController_EmitPrintTrainerMessage

	thumb_func_start BattleController_EmitSetStatus2Effect
BattleController_EmitSetStatus2Effect: ; 0x02263848
	push {r3, r4, r5, lr}
	sub sp, #0x68
	add r4, r2, #0
	str r3, [sp]
	str r4, [sp, #4]
	str r4, [sp, #8]
	mov r2, #0
	str r2, [sp, #0xc]
	add r2, sp, #0x10
	mov r3, #1
	add r5, r0, #0
	bl ov12_022643C8
	mov r0, #0x58
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #0x10
	bl ov12_02262240
	add sp, #0x68
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitSetStatus2Effect

	thumb_func_start BattleController_EmitCopyStatus2Effect
BattleController_EmitCopyStatus2Effect: ; 0x02263878
	push {r3, r4, r5, lr}
	sub sp, #0x68
	add r4, r2, #0
	ldr r2, [sp, #0x78]
	add r5, r0, #0
	str r2, [sp]
	str r4, [sp, #4]
	str r3, [sp, #8]
	mov r2, #0
	str r2, [sp, #0xc]
	add r2, sp, #0x10
	mov r3, #1
	bl ov12_022643C8
	mov r0, #0x58
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #0x10
	bl ov12_02262240
	add sp, #0x68
	pop {r3, r4, r5, pc}
	thumb_func_end BattleController_EmitCopyStatus2Effect

	thumb_func_start BattleController_EmitPrintReturnMessage
BattleController_EmitPrintReturnMessage: ; 0x022638A8
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r2, #0
	mov r2, #0x20
	add r0, sp, #4
	strb r2, [r0]
	strb r3, [r0, #1]
	ldr r0, _022638E4 ; =0x00003122
	ldrsh r2, [r1, r0]
	ldr r0, _022638E8 ; =0x00002E4C
	ldr r0, [r1, r0]
	sub r1, r2, r0
	mov r0, #0x64
	mul r0, r1
	add r1, r2, #0
	bl _s32_div_f
	add r1, sp, #4
	strh r0, [r1, #2]
	mov r0, #4
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022638E4: .word 0x00003122
_022638E8: .word 0x00002E4C
	thumb_func_end BattleController_EmitPrintReturnMessage

	thumb_func_start BattleController_EmitPrintSendOutMessage
BattleController_EmitPrintSendOutMessage: ; 0x022638EC
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r6, r1, #0
	add r4, r2, #0
	mov r1, #0x21
	add r0, sp, #4
	strb r1, [r0]
	ldr r2, _02263934 ; =0x00002E4C
	strb r3, [r0, #1]
	ldr r1, [r6, r2]
	cmp r1, #0
	bne _0226390E
	mov r1, #0xfa
	lsl r1, r1, #2
	strh r1, [r0, #2]
	b _02263920
_0226390E:
	mov r0, #0xfa
	lsl r0, r0, #2
	mul r0, r1
	add r1, r2, #4
	ldr r1, [r6, r1]
	bl _u32_div_f
	add r1, sp, #4
	strh r0, [r1, #2]
_02263920:
	mov r0, #4
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02263934: .word 0x00002E4C
	thumb_func_end BattleController_EmitPrintSendOutMessage

	thumb_func_start BattleController_EmitPrintEncounterMessage
BattleController_EmitPrintEncounterMessage: ; 0x02263938
	push {r3, lr}
	sub sp, #8
	mov r1, #0x22
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	thumb_func_end BattleController_EmitPrintEncounterMessage

	thumb_func_start BattleController_EmitPrintFirstSendOutMessage
BattleController_EmitPrintFirstSendOutMessage: ; 0x02263950
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r7, r1, #0
	str r2, [sp, #4]
	mov r2, #0x23
	add r1, sp, #8
	add r6, r0, #0
	strb r2, [r1]
	mov r4, #0
	bl BattleSystem_GetMaxBattlers
	cmp r0, #0
	ble _02263982
	add r5, sp, #8
_0226396C:
	ldr r0, _02263998 ; =0x0000219C
	add r1, r7, r4
	ldrb r0, [r1, r0]
	add r4, r4, #1
	strb r0, [r5, #4]
	add r0, r6, #0
	add r5, r5, #1
	bl BattleSystem_GetMaxBattlers
	cmp r4, r0
	blt _0226396C
_02263982:
	mov r0, #8
	str r0, [sp]
	ldr r2, [sp, #4]
	add r0, r6, #0
	mov r1, #1
	add r3, sp, #8
	bl ov12_02262240
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02263998: .word 0x0000219C
	thumb_func_end BattleController_EmitPrintFirstSendOutMessage

	thumb_func_start ov12_0226399C
ov12_0226399C: ; 0x0226399C
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0x24
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov12_0226399C

	thumb_func_start ov12_022639B8
ov12_022639B8: ; 0x022639B8
	push {r0, r1, r2, r3}
	push {r3, r4, r5, r6, lr}
	sub sp, #0x2c
	add r4, r1, #0
	add r5, r0, #0
	bl BattleSystem_GetBattleContext
	add r1, r4, #0
	bl BattleBuffer_Clear
	mov r1, #0x25
	add r0, sp, #4
	strb r1, [r0]
	add r6, sp, #0x48
	add r3, sp, #8
	mov r2, #4
_022639D8:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _022639D8
	ldr r0, [r6]
	mov r1, #1
	str r0, [r3]
	mov r0, #0x28
	str r0, [sp]
	add r0, r5, #0
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0x2c
	pop {r3, r4, r5, r6}
	pop {r3}
	add sp, #0x10
	bx r3
	.balign 4, 0
	thumb_func_end ov12_022639B8

	thumb_func_start ov12_02263A00
ov12_02263A00: ; 0x02263A00
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #1
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov12_02263A00
