	.include "asm/macros.inc"
	.include "overlay_80_02229EE0.inc"
	.include "global.inc"

	.text

	thumb_func_start ov80_02229EE0
ov80_02229EE0: ; 0x02229EE0
	push {r4, lr}
	add r4, r0, #0
	add r3, r1, #0
	add r0, r2, #0
	add r1, r4, #0
	add r2, r3, #0
	bl AllocAndReadWholeNarcMemberByIdPair
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov80_02229EE0

	thumb_func_start ov80_02229EF4
ov80_02229EF4: ; 0x02229EF4
	add r3, r1, #0
	add r1, r2, #0
	add r2, r3, #0
	ldr r3, _02229F00 ; =ReadWholeNarcMemberByIdPair
	bx r3
	nop
_02229F00: .word ReadWholeNarcMemberByIdPair
	thumb_func_end ov80_02229EF4

	thumb_func_start ov80_02229F04
ov80_02229F04: ; 0x02229F04
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r6, r2, #0
	mov r1, #0x1b
	str r3, [sp]
	mov r0, #1
	add r2, r1, #0
	add r3, r6, #0
	bl NewMsgDataFromNarc
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x30
	bl MI_CpuFill8
	lsl r0, r4, #0x10
	ldr r2, [sp]
	lsr r0, r0, #0x10
	add r1, r6, #0
	bl ov80_02229EE0
	add r6, r0, #0
	ldr r0, _02229F68 ; =0x0000FFFF
	str r4, [r5]
	strh r0, [r5, #0x18]
	lsl r0, r4, #1
	add r0, r4, r0
	strh r0, [r5, #0x1a]
	ldrh r0, [r6]
	add r1, r4, #0
	strh r0, [r5, #4]
	add r0, r7, #0
	bl NewString_ReadMsgData
	add r5, #8
	add r4, r0, #0
	add r1, r5, #0
	mov r2, #8
	bl CopyStringToU16Array
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl DestroyMsgData
	add r0, r6, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02229F68: .word 0x0000FFFF
	thumb_func_end ov80_02229F04
