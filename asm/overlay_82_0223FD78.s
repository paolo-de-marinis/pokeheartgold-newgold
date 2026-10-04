	.include "asm/macros.inc"
	.include "overlay_82.inc"
	.include "global.inc"

	.text

	thumb_func_start ov82_0223FD78
ov82_0223FD78: ; 0x0223FD78
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r1, #0
	add r4, r0, #0
	bl GetWindowBgId
	add r1, r0, #0
	lsl r0, r5, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x69
	str r0, [sp, #4]
	ldr r0, [r4]
	ldr r2, _0223FDB4 ; =0x000003D9
	mov r3, #0xa
	bl LoadUserFrameGfx2
	add r0, r4, #0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r2, _0223FDB4 ; =0x000003D9
	add r0, r4, #0
	mov r1, #0
	mov r3, #0xa
	bl DrawFrameAndWindow2
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_0223FDB4: .word 0x000003D9
	thumb_func_end ov82_0223FD78

	thumb_func_start ov82_0223FDB8
ov82_0223FDB8: ; 0x0223FDB8
	ldr r3, _0223FDBC ; =YesNoPrompt_Create
	bx r3
	.balign 4, 0
_0223FDBC: .word YesNoPrompt_Create
	thumb_func_end ov82_0223FDB8

	thumb_func_start ov82_0223FDC0
ov82_0223FDC0: ; 0x0223FDC0
	ldr r3, _0223FDC4 ; =YesNoPrompt_Destroy
	bx r3
	.balign 4, 0
_0223FDC4: .word YesNoPrompt_Destroy
	thumb_func_end ov82_0223FDC0

	thumb_func_start ov82_0223FDC8
ov82_0223FDC8: ; 0x0223FDC8
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r6, r0, #0
	add r5, r1, #0
	add r4, r2, #0
	add r0, sp, #0
	mov r1, #0
	mov r2, #0x14
	bl MI_CpuFill8
	mov r0, #0x6d
	mov r2, #0
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	str r5, [sp]
	str r2, [sp, #4]
	mov r1, #0x18
	add r0, sp, #0
	strb r1, [r0, #0x10]
	mov r1, #0xa
	strb r1, [r0, #0x11]
	ldrb r1, [r0, #0x12]
	mov r3, #0xf
	bic r1, r3
	mov r3, #0xf
	and r3, r4
	orr r1, r3
	strb r1, [r0, #0x12]
	ldrb r3, [r0, #0x12]
	mov r1, #0xf0
	bic r3, r1
	strb r3, [r0, #0x12]
	strb r2, [r0, #0x13]
	add r0, r6, #0
	add r1, sp, #0
	bl YesNoPrompt_InitFromTemplate
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov82_0223FDC8

	thumb_func_start ov82_0223FE18
ov82_0223FE18: ; 0x0223FE18
	ldr r3, _0223FE1C ; =YesNoPrompt_HandleInput
	bx r3
	.balign 4, 0
_0223FE1C: .word YesNoPrompt_HandleInput
	thumb_func_end ov82_0223FE18
