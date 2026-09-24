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

