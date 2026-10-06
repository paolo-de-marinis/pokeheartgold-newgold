	.include "asm/macros.inc"
	.include "overlay_31.inc"
	.include "global.inc"

.public _0225EE40
.public _0225EF40
.public ov31_0225DE00
.public ov31_0225EE88
.public ov31_0225EED0
.public ov31_0225EEEC
.public ov31_0225EF08

	.text

	thumb_func_start ov31_0225E184
ov31_0225E184: ; 0x0225E184
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x29
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r2, [r5, #0x14]
	add r0, r1, #0
	sub r0, #0x1f
	ldr r3, [r2, r1]
	ldrb r0, [r2, r0]
	sub r1, #0x28
	ldr r1, [r2, r1]
	add r6, r3, r0
	lsl r4, r6, #1
	mov r0, #0x57
	lsl r0, r0, #2
	ldrh r1, [r1, r4]
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0xe4
	add r2, r7, #0
	add r3, r6, #0
	bl ov31_0225DE00
	add r0, r7, #0
	bl String_Delete
	mov r2, #0x9a
	ldr r0, [r5, #0x14]
	lsl r2, r2, #2
	ldr r2, [r0, r2]
	add r1, r6, #0
	ldrh r2, [r2, r4]
	bl ov31_0225E12C
	cmp r0, #0
	beq _0225E1FE
	ldr r6, [r5, #0x14]
	mov r1, #0x9a
	lsl r1, r1, #2
	ldr r1, [r6, r1]
	add r0, r6, #0
	ldrh r1, [r1, r4]
	bl ov03_02258120
	add r3, r0, #0
	ldr r0, _0225E208 ; =0x00000283
	mov r1, #0x55
	ldrb r0, [r6, r0]
	add r2, r5, #0
	lsl r1, r1, #2
	str r0, [sp]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, #0xe4
	bl ov31_0225DE24
_0225E1FE:
	add r5, #0xe4
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0225E208: .word 0x00000283
	thumb_func_end ov31_0225E184

	thumb_func_start ov31_0225E20C
ov31_0225E20C: ; 0x0225E20C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x23
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #4
	str r0, [sp]
	mov r2, #0xff
	str r2, [sp, #4]
	ldr r0, _0225E2D0 ; =0x00010200
	mov r1, #0
	str r0, [sp, #8]
	add r2, #0x25
	add r0, r5, r2
	add r2, r4, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	mov r0, #5
	mov r1, #0xb
	bl String_New
	add r4, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x24
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r1, #0xa1
	ldr r0, [r5, #0x14]
	lsl r1, r1, #2
	ldrh r1, [r0, r1]
	bl ov03_02257978
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	mov r3, #3
	bl BufferIntegerAsString
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r6, r0, #0
	mov r0, #0x14
	str r0, [sp]
	mov r2, #0xff
	str r2, [sp, #4]
	ldr r0, _0225E2D0 ; =0x00010200
	mov r3, #0x40
	add r2, #0x25
	str r0, [sp, #8]
	mov r1, #0
	add r0, r5, r2
	add r2, r4, #0
	sub r3, r3, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	mov r0, #0x49
	lsl r0, r0, #2
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0225E2D0: .word 0x00010200
	thumb_func_end ov31_0225E20C

	thumb_func_start ov31_0225E2D4
ov31_0225E2D4: ; 0x0225E2D4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #2
	mov r1, #0xb
	bl String_New
	add r6, r0, #0
	mov r0, #2
	mov r1, #0xb
	bl String_New
	add r7, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x2c
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x2d
	bl NewString_ReadMsgData
	str r0, [sp, #0x14]
	add r0, r4, #0
	mov r1, #0xa
	bl _s32_div_f
	mov r3, #1
	add r2, r0, #0
	str r3, [sp]
	mov r0, #0x55
	str r3, [sp, #4]
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl BufferIntegerAsString
	add r0, r4, #0
	mov r1, #0xa
	bl _s32_div_f
	add r2, r1, #0
	mov r1, #1
	str r1, [sp]
	mov r0, #0x55
	str r1, [sp, #4]
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r3, r1, #0
	bl BufferIntegerAsString
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x10]
	add r1, r6, #0
	bl StringExpandPlaceholders
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x14]
	add r1, r7, #0
	bl StringExpandPlaceholders
	add r0, r5, #0
	add r0, #0xf4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x41
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0225E470 ; =0x00010200
	mov r1, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0xf4
	add r2, r6, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	mov r0, #4
	str r0, [sp]
	mov r2, #0xff
	mov r1, #0
	ldr r0, _0225E470 ; =0x00010200
	str r2, [sp, #4]
	str r0, [sp, #8]
	add r0, r2, #5
	add r0, r5, r0
	add r2, r7, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	ldr r0, [sp, #0x10]
	bl String_Delete
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r5, #0
	add r0, #0xf4
	bl ScheduleWindowCopyToVram
	mov r0, #0x41
	lsl r0, r0, #2
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	mov r0, #0x4d
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #9
	mov r1, #0xb
	bl String_New
	add r6, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x26
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r2, #0xa3
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r3, [r5, #0x14]
	lsl r2, r2, #2
	ldr r3, [r3, r2]
	ldr r0, [r5, r0]
	add r2, r3, #0
	mov r1, #0
	mul r2, r4
	mov r3, #6
	bl BufferIntegerAsString
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r6, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r4, r0, #0
	mov r0, #4
	str r0, [sp]
	mov r2, #0xff
	str r2, [sp, #4]
	ldr r0, _0225E470 ; =0x00010200
	mov r3, #0x40
	add r2, #0x35
	str r0, [sp, #8]
	mov r1, #0
	add r0, r5, r2
	add r2, r6, #0
	sub r3, r3, r4
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	mov r0, #0x4d
	lsl r0, r0, #2
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0225E470: .word 0x00010200
	thumb_func_end ov31_0225E2D4

	thumb_func_start ov31_0225E474
ov31_0225E474: ; 0x0225E474
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x2a
	bl NewString_ReadMsgData
	mov r1, #0
	add r4, r0, #0
	str r1, [sp]
	mov r2, #0xff
	str r2, [sp, #4]
	ldr r0, _0225E4B8 ; =0x000F0E00
	add r2, #0x15
	str r0, [sp, #8]
	add r0, r5, r2
	add r2, r4, #0
	mov r3, #4
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_0225E4B8: .word 0x000F0E00
	thumb_func_end ov31_0225E474

	thumb_func_start ov31_0225E4BC
ov31_0225E4BC: ; 0x0225E4BC
	push {r3, lr}
	cmp r0, #4
	bhi _0225E4EA
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0225E4CE: ; jump table
	.short _0225E4D8 - _0225E4CE - 2 ; case 0
	.short _0225E4E2 - _0225E4CE - 2 ; case 1
	.short _0225E4EA - _0225E4CE - 2 ; case 2
	.short _0225E4D8 - _0225E4CE - 2 ; case 3
	.short _0225E4D8 - _0225E4CE - 2 ; case 4
_0225E4D8:
	add r0, r1, #0
	add r1, r3, #0
	bl BufferItemName
	pop {r3, pc}
_0225E4E2:
	add r0, r1, #0
	add r1, r3, #0
	bl BufferDecorationName
_0225E4EA:
	pop {r3, pc}
	thumb_func_end ov31_0225E4BC

	thumb_func_start ov31_0225E4EC
ov31_0225E4EC: ; 0x0225E4EC
	push {r3, lr}
	cmp r0, #4
	bhi _0225E51A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0225E4FE: ; jump table
	.short _0225E508 - _0225E4FE - 2 ; case 0
	.short _0225E512 - _0225E4FE - 2 ; case 1
	.short _0225E51A - _0225E4FE - 2 ; case 2
	.short _0225E508 - _0225E4FE - 2 ; case 3
	.short _0225E508 - _0225E4FE - 2 ; case 4
_0225E508:
	add r0, r1, #0
	add r1, r3, #0
	bl BufferItemNamePlural
	pop {r3, pc}
_0225E512:
	add r0, r1, #0
	add r1, r3, #0
	bl BufferDecorationName
_0225E51A:
	pop {r3, pc}
	thumb_func_end ov31_0225E4EC

	thumb_func_start ov31_0225E51C
ov31_0225E51C: ; 0x0225E51C
	push {r3, lr}
	cmp r0, #4
	bhi _0225E54A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0225E52E: ; jump table
	.short _0225E538 - _0225E52E - 2 ; case 0
	.short _0225E542 - _0225E52E - 2 ; case 1
	.short _0225E54A - _0225E52E - 2 ; case 2
	.short _0225E538 - _0225E52E - 2 ; case 3
	.short _0225E538 - _0225E52E - 2 ; case 4
_0225E538:
	add r0, r1, #0
	add r1, r3, #0
	bl BufferItemNameWithIndefArticle
	pop {r3, pc}
_0225E542:
	add r0, r1, #0
	add r1, r3, #0
	bl BufferDecorationName
_0225E54A:
	pop {r3, pc}
	thumb_func_end ov31_0225E51C

	thumb_func_start ov31_0225E54C
ov31_0225E54C: ; 0x0225E54C
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0x51
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	mov r1, #0x55
	lsl r1, r1, #2
	ldr r3, [r5, #0x14]
	ldr r2, _0225E5F4 ; =0x00000283
	ldr r1, [r5, r1]
	ldrb r0, [r3, r2]
	add r2, r2, #1
	ldrh r2, [r3, r2]
	mov r3, #0
	bl ov31_0225E4BC
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0xc
	bl NewString_ReadMsgData
	mov r1, #0x55
	add r4, r0, #0
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	add r1, #0x34
	ldr r1, [r5, r1]
	add r2, r4, #0
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r1, #4
	str r1, [sp, #4]
	ldr r0, [r5, #4]
	ldr r2, _0225E5F8 ; =0x000001B5
	mov r3, #5
	bl LoadUserFrameGfx2
	mov r2, #0x51
	lsl r2, r2, #2
	add r0, r5, r2
	mov r1, #1
	add r2, #0x71
	mov r3, #5
	bl DrawFrameAndWindow2
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	mov r2, #0x51
	str r0, [sp, #4]
	lsl r2, r2, #2
	add r0, r5, r2
	str r3, [sp, #8]
	add r2, #0x44
	ldr r2, [r5, r2]
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xa
	ldr r2, [r5, #0x14]
	lsl r1, r1, #6
	strb r0, [r2, r1]
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0225E5F4: .word 0x00000283
_0225E5F8: .word 0x000001B5
	thumb_func_end ov31_0225E54C
