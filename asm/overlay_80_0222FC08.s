	.include "asm/macros.inc"
	.include "overlay_80_0222F608.inc"
	.include "global.inc"

    .text

	thumb_func_start ov80_0222FC08
ov80_0222FC08: ; 0x0222FC08
	push {r4, lr}
	add r4, r1, #0
	ldr r0, [r4]
	mov r1, #2
	bl Bg_GetYpos
	cmp r0, #0xff
	ldr r0, [r4]
	blt _0222FC26
	mov r1, #2
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	pop {r4, pc}
_0222FC26:
	mov r1, #2
	mov r2, #4
	mov r3, #1
	bl ScheduleSetBgPosText
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov80_0222FC08

	thumb_func_start FrtCmd_104
FrtCmd_104: ; 0x0222FC34
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl FrontierScript_ReadVarPtr
	add r4, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_GetData
	ldr r0, [r0, #0x14]
	strh r0, [r4]
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end FrtCmd_104

	thumb_func_start FrtCmd_105
FrtCmd_105: ; 0x0222FC50
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	bl FrontierScript_ReadVar
	add r6, r0, #0
	add r0, r5, #0
	bl FrontierScript_ReadVar
	add r7, r0, #0
	add r0, r5, #0
	bl FrontierScript_ReadVarPtr
	add r4, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_GetData
	add r1, r6, #0
	add r2, r7, #0
	bl ov80_02230AF8
	strh r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end FrtCmd_105

	thumb_func_start FrtCmd_106
FrtCmd_106: ; 0x0222FC80
	push {r4, lr}
	add r4, r0, #0
	bl FrontierScriptContext_ReadHalfWord
	add r1, r4, #0
	add r1, #0x78
	strh r0, [r1]
	ldr r1, _0222FC9C ; =ov80_0222FCA0
	add r0, r4, #0
	bl FrontierScriptContext_Pause
	mov r0, #1
	pop {r4, pc}
	nop
_0222FC9C: .word ov80_0222FCA0
	thumb_func_end FrtCmd_106

	thumb_func_start ov80_0222FCA0
ov80_0222FCA0: ; 0x0222FCA0
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x78
	ldrh r1, [r1]
	bl ov80_0222BE9C
	ldr r0, [r4]
	ldr r0, [r0]
	bl Frontier_GetData
	ldr r1, _0222FCCC ; =0x00000702
	ldrb r2, [r0, r1]
	cmp r2, #2
	blo _0222FCC6
	mov r2, #0
	strb r2, [r0, r1]
	mov r0, #1
	pop {r4, pc}
_0222FCC6:
	mov r0, #0
	pop {r4, pc}
	nop
_0222FCCC: .word 0x00000702
	thumb_func_end ov80_0222FCA0

	thumb_func_start FrtCmd_107
FrtCmd_107: ; 0x0222FCD0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Frontier_GetLaunchArgs
	ldr r1, [r5, #0x1c]
	add r0, r1, #1
	str r0, [r5, #0x1c]
	ldr r0, [r5]
	ldrb r4, [r1]
	ldr r0, [r0]
	bl Frontier_GetData
	add r2, r0, #0
	bne _0222FCF4
	mov r0, #0
	pop {r3, r4, r5, pc}
_0222FCF4:
	lsl r1, r4, #4
	add r1, r4, r1
	add r2, #0x4c
	lsl r1, r1, #4
	add r0, r5, #0
	add r1, r2, r1
	bl ov80_0222F44C
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end FrtCmd_107
