	.include "asm/macros.inc"
	.include "overlay_80_0222F608.inc"
	.include "global.inc"

    .text

	thumb_func_start FrtCmd_092
FrtCmd_092: ; 0x0222F608
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	bl FrontierScript_ReadVar
	add r7, r0, #0
	add r0, r5, #0
	bl FrontierScript_ReadVar
	add r4, r0, #0
	add r0, r5, #0
	bl FrontierScript_ReadVar
	add r6, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_GetLaunchArgs
	lsl r2, r4, #0x18
	lsl r3, r6, #0x18
	ldr r0, [r0, #8]
	add r1, r7, #0
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl ov80_0222FD08
	add r1, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_SetData
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end FrtCmd_092

	thumb_func_start FrtCmd_093
FrtCmd_093: ; 0x0222F648
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl FrontierScript_ReadVar
	add r4, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_GetData
	add r1, r4, #0
	bl ov80_0222FEEC
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end FrtCmd_093

	thumb_func_start FrtCmd_094
FrtCmd_094: ; 0x0222F664
	push {r3, lr}
	ldr r0, [r0]
	ldr r0, [r0]
	bl Frontier_GetData
	bl ov80_02230424
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end FrtCmd_094

	thumb_func_start FrtCmd_095
FrtCmd_095: ; 0x0222F678
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r0, [r6]
	ldr r0, [r0]
	bl Frontier_GetLaunchArgs
	add r7, r0, #0
	ldr r0, [r6]
	ldr r0, [r0]
	bl Frontier_GetData
	add r5, r0, #0
	mov r0, #0xb
	mov r1, #0x24
	bl Heap_Alloc
	mov r1, #0
	mov r2, #0x24
	add r4, r0, #0
	bl MI_CpuFill8
	ldr r0, [r7, #8]
	mov r3, #0
	str r0, [r4]
	ldrb r0, [r5, #4]
	add r2, r4, #0
	strb r0, [r4, #4]
	ldrb r0, [r5, #5]
	strb r0, [r4, #5]
	ldr r0, _0222F6D4 ; =0x000004D4
	strb r3, [r4, #6]
	ldr r1, [r5, r0]
	add r0, r0, #4
	str r1, [r4, #8]
	ldr r0, [r5, r0]
	ldr r1, _0222F6D8 ; =ov80_0223BDB4
	str r0, [r4, #0xc]
	ldr r0, _0222F6DC ; =ov80_0222F7CC
	str r5, [r4, #0x1c]
	str r0, [sp]
	ldr r0, [r6]
	ldr r0, [r0]
	bl Frontier_LaunchApplication
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0222F6D4: .word 0x000004D4
_0222F6D8: .word ov80_0223BDB4
_0222F6DC: .word ov80_0222F7CC
	thumb_func_end FrtCmd_095

	thumb_func_start FrtCmd_096
FrtCmd_096: ; 0x0222F6E0
	push {r3, r4, r5, lr}
	ldr r0, [r0]
	ldr r0, [r0]
	bl Frontier_GetData
	add r4, r0, #0
	ldr r0, _0222F704 ; =0x000004FC
	ldr r5, [r4, r0]
	ldr r0, [r5, #0x14]
	bl IsBattleResultWin
	str r0, [r4, #0x14]
	add r0, r5, #0
	bl BattleSetup_Delete
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0222F704: .word 0x000004FC
	thumb_func_end FrtCmd_096

	thumb_func_start FrtCmd_097
FrtCmd_097: ; 0x0222F708
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_GetLaunchArgs
	add r6, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_GetData
	add r1, r6, #0
	add r4, r0, #0
	bl ov80_02236F24
	add r2, r0, #0
	ldr r0, _0222F744 ; =0x000004FC
	mov r3, #0
	str r2, [r4, r0]
	str r3, [sp]
	ldr r0, [r5]
	ldr r1, _0222F748 ; =gOverlayTemplate_Battle
	ldr r0, [r0]
	bl Frontier_LaunchApplication
	mov r0, #1
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	nop
_0222F744: .word 0x000004FC
_0222F748: .word gOverlayTemplate_Battle
	thumb_func_end FrtCmd_097

	thumb_func_start FrtCmd_098
FrtCmd_098: ; 0x0222F74C
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r0, [r6]
	ldr r0, [r0]
	bl Frontier_GetLaunchArgs
	add r7, r0, #0
	ldr r0, [r6]
	ldr r0, [r0]
	bl Frontier_GetData
	add r5, r0, #0
	mov r2, #0
	ldr r0, _0222F7BC ; =0x000004DC
	add r3, r5, #0
	add r1, r2, #0
_0222F76C:
	add r2, r2, #1
	strh r1, [r3, r0]
	add r3, r3, #2
	cmp r2, #6
	blt _0222F76C
	mov r0, #0xb
	mov r1, #0x24
	bl Heap_Alloc
	mov r1, #0
	mov r2, #0x24
	add r4, r0, #0
	bl MI_CpuFill8
	ldr r0, [r7, #8]
	add r2, r4, #0
	str r0, [r4]
	ldrb r0, [r5, #4]
	mov r3, #0
	strb r0, [r4, #4]
	ldrb r0, [r5, #5]
	strb r0, [r4, #5]
	mov r0, #1
	strb r0, [r4, #6]
	ldr r0, _0222F7C0 ; =0x000004D4
	ldr r1, [r5, r0]
	add r0, r0, #4
	str r1, [r4, #8]
	ldr r0, [r5, r0]
	ldr r1, _0222F7C4 ; =ov80_0223BDC4
	str r0, [r4, #0xc]
	ldr r0, _0222F7C8 ; =ov80_0222F7CC
	str r5, [r4, #0x1c]
	str r0, [sp]
	ldr r0, [r6]
	ldr r0, [r0]
	bl Frontier_LaunchApplication
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0222F7BC: .word 0x000004DC
_0222F7C0: .word 0x000004D4
_0222F7C4: .word ov80_0223BDC4
_0222F7C8: .word ov80_0222F7CC
	thumb_func_end FrtCmd_098

	thumb_func_start ov80_0222F7CC
ov80_0222F7CC: ; 0x0222F7CC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x1c]
	add r1, r4, #0
	bl ov80_02230460
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov80_0222F7CC

	thumb_func_start FrtCmd_099
FrtCmd_099: ; 0x0222F7E0
	push {r3, lr}
	ldr r0, [r0]
	ldr r0, [r0]
	bl Frontier_GetData
	bl ov80_022307F0
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end FrtCmd_099

	thumb_func_start FrtCmd_100
FrtCmd_100: ; 0x0222F7F4
	push {r3, lr}
	ldr r0, [r0]
	ldr r0, [r0]
	bl Frontier_GetData
	bl ov80_022308C4
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end FrtCmd_100

	thumb_func_start FrtCmd_101
FrtCmd_101: ; 0x0222F808
	push {r3, lr}
	ldr r0, [r0]
	ldr r0, [r0]
	bl Frontier_GetData
	bl ov80_022309F8
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end FrtCmd_101

	thumb_func_start FrtCmd_102
FrtCmd_102: ; 0x0222F81C
	push {r3, lr}
	ldr r0, [r0]
	ldr r0, [r0]
	bl Frontier_GetData
	bl ov80_02230A60
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end FrtCmd_102

