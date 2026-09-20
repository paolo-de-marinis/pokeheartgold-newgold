	.include "asm/macros.inc"
	.include "overlay_12_battle_controller.inc"
	.include "global.inc"

	.text

	thumb_func_start BattleController_EmitBackgroundSlideIn
BattleController_EmitBackgroundSlideIn: ; 0x02263CB0
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0x28
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitBackgroundSlideIn

	thumb_func_start ov12_02263CCC
ov12_02263CCC: ; 0x02263CCC
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0x29
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov12_02263CCC
