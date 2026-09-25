	.include "asm/macros.inc"
	.include "overlay_12_battle_controller.inc"
	.include "global.inc"

	.text

	thumb_func_start BattleController_EmitPlayMoveSE
BattleController_EmitPlayMoveSE: ; 0x02264228
	push {r3, r4, r5, lr}
	sub sp, #8
	mov r3, #0x3f
	add r4, sp, #4
	strb r3, [r4]
	ldr r3, _02264264 ; =0x0000216C
	ldr r5, [r1, r3]
	mov r1, #2
	add r3, r5, #0
	tst r3, r1
	beq _02264242
	strb r1, [r4, #1]
	b _02264252
_02264242:
	mov r1, #4
	tst r1, r5
	beq _0226424E
	mov r1, #1
	strb r1, [r4, #1]
	b _02264252
_0226424E:
	mov r1, #0
	strb r1, [r4, #1]
_02264252:
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_02264264: .word 0x0000216C
	thumb_func_end BattleController_EmitPlayMoveSE

	thumb_func_start BattleController_EmitPlaySong
BattleController_EmitPlaySong: ; 0x02264268
	push {r4, lr}
	sub sp, #8
	add r4, r1, #0
	mov r3, #0x40
	add r1, sp, #4
	strb r3, [r1]
	strh r2, [r1, #2]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r4, pc}
	thumb_func_end BattleController_EmitPlaySong

	thumb_func_start BattleController_EmitSetBattleResults
BattleController_EmitSetBattleResults: ; 0x02264288
	push {r3, r4, r5, lr}
	sub sp, #0x28
	add r5, r0, #0
	bl BattleSystem_GetBattleType
	add r4, r0, #0
	mov r1, #0x41
	add r0, sp, #4
	strb r1, [r0]
	add r0, r5, #0
	bl BattleSystem_GetBattleOutcomeFlags
	str r0, [sp, #8]
	mov r1, #0
	add r0, sp, #4
	strh r1, [r0, #2]
	mov r0, #4
	tst r0, r4
	beq _022642D6
	bl sub_0202FC48
	cmp r0, #1
	bne _022642D6
	ldr r0, _022642EC ; =0x0000240C
	ldr r1, [r5, r0]
	mov r0, #0x10
	tst r0, r1
	bne _022642D6
	add r0, r5, #0
	add r1, sp, #0xc
	bl ov12_0223BE68
	add r1, sp, #4
	strh r0, [r1, #2]
	ldrh r0, [r1, #2]
	cmp r0, #0x1c
	bls _022642D6
	bl GF_AssertFail
_022642D6:
	mov r0, #0x24
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0x28
	pop {r3, r4, r5, pc}
	nop
_022642EC: .word 0x0000240C
	thumb_func_end BattleController_EmitSetBattleResults

	thumb_func_start BattleController_EmitBlankMessage
BattleController_EmitBlankMessage: ; 0x022642F0
	push {r3, lr}
	sub sp, #8
	mov r1, #0x42
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
	thumb_func_end BattleController_EmitBlankMessage

	thumb_func_start ov12_0226430C
ov12_0226430C: ; 0x0226430C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	add r0, sp, #4
	add r4, r1, #0
	strb r2, [r0]
	bl sub_0203769C
	add r1, sp, #4
	strb r0, [r1, #1]
	mov r0, #4
	str r0, [sp]
	add r0, r5, #0
	mov r1, #2
	add r2, r4, #0
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, r4, r5, pc}
	thumb_func_end ov12_0226430C

	thumb_func_start ov12_02264334
ov12_02264334: ; 0x02264334
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	mov r1, #1
	ldrb r3, [r5, #3]
	str r1, [sp]
	ldrb r2, [r5]
	ldrb r1, [r5, #2]
	lsl r3, r3, #8
	add r4, r0, #0
	orr r1, r3
	ldrb r6, [r5, #1]
	cmp r2, #0
	bne _0226436E
	mov r2, #0
	cmp r1, #0
	ble _022643C2
	mov r7, #0x23
	lsl r3, r6, #8
	lsl r7, r7, #8
_0226435A:
	add r0, r5, r2
	ldr r6, [r4, #0x30]
	ldrb r0, [r0, #4]
	add r6, r3, r6
	add r6, r2, r6
	add r2, r2, #1
	strb r0, [r6, r7]
	cmp r2, r1
	blt _0226435A
	b _022643C2
_0226436E:
	cmp r2, #1
	bne _022643A6
	lsl r0, r6, #2
	add r0, r4, r0
	mov r3, #0x6a
	ldr r4, [r0, #0x34]
	lsl r3, r3, #2
	ldrb r2, [r4, r3]
	cmp r2, #0
	bne _022643A0
	ldr r2, [sp]
	strb r2, [r4, r3]
	mov r2, #0
	cmp r1, #0
	ble _022643C2
_0226438C:
	add r3, r5, r2
	ldrb r4, [r3, #4]
	ldr r3, [r0, #0x34]
	add r3, r3, r2
	add r3, #0x94
	add r2, r2, #1
	strb r4, [r3]
	cmp r2, r1
	blt _0226438C
	b _022643C2
_022643A0:
	mov r0, #0
	str r0, [sp]
	b _022643C2
_022643A6:
	cmp r2, #2
	bne _022643C2
	ldrb r7, [r5, #4]
	ldrb r5, [r5, #5]
	bl ov12_0223B688
	cmp r0, #0
	beq _022643C2
	ldr r0, [r4, #0x30]
	add r1, r5, #0
	add r2, r6, #0
	add r3, r7, #0
	bl ov12_0224ED00
_022643C2:
	ldr r0, [sp]
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov12_02264334
