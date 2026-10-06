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

	thumb_func_start ov31_0225E700
ov31_0225E700: ; 0x0225E700
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r0, sp, #0
	mov r1, #0
	mov r2, #0x14
	bl MI_CpuFill8
	ldr r0, [r4, #4]
	mov r2, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #0x60
	str r0, [sp, #8]
	mov r0, #8
	str r0, [sp, #0xc]
	add r0, sp, #0
	strb r2, [r0, #0x10]
	mov r1, #6
	strb r1, [r0, #0x11]
	ldr r0, [r4, #0x1c]
	add r2, #0xf2
	add r0, r0, r2
	bl MenuInputStateMgr_GetState
	add r1, sp, #0
	ldrb r2, [r1, #0x12]
	mov r3, #0xf
	lsl r0, r0, #0x18
	bic r2, r3
	lsr r3, r0, #0x18
	mov r0, #0xf
	and r0, r3
	orr r0, r2
	strb r0, [r1, #0x12]
	ldrb r2, [r1, #0x12]
	mov r0, #0xf0
	bic r2, r0
	strb r2, [r1, #0x12]
	mov r0, #0
	strb r0, [r1, #0x13]
	ldr r0, [r4, #4]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	mov r0, #8
	bl YesNoPrompt_Create
	mov r1, #0x17
	lsl r1, r1, #4
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	add r1, sp, #0
	bl YesNoPrompt_InitFromTemplate
	add sp, #0x14
	pop {r3, r4, pc}
	thumb_func_end ov31_0225E700

	thumb_func_start ov31_0225E774
ov31_0225E774: ; 0x0225E774
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x17
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0225E786
	mov r0, #0
	pop {r4, pc}
_0225E786:
	bl YesNoPrompt_HandleInputForSave
	cmp r0, #1
	beq _0225E794
	cmp r0, #2
	beq _0225E7B2
	b _0225E7D0
_0225E794:
	mov r0, #0x17
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	mov r0, #0x17
	mov r2, #0
	lsl r0, r0, #4
	str r2, [r4, r0]
	mov r0, #0xa5
	ldr r1, [r4, #0x14]
	lsl r0, r0, #2
	str r2, [r1, r0]
	mov r0, #1
	pop {r4, pc}
_0225E7B2:
	mov r0, #0x17
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	mov r0, #0x17
	mov r1, #0
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0xa5
	ldr r2, [r4, #0x14]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [r2, r1]
	pop {r4, pc}
_0225E7D0:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov31_0225E774

	thumb_func_start ov31_0225E7D4
ov31_0225E7D4: ; 0x0225E7D4
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r3, [r4, #0x14]
	ldr r2, _0225E938 ; =0x00000286
	ldrsh r0, [r3, r2]
	cmp r0, #1
	ble _0225E7FA
	sub r0, r2, #3
	mov r1, #0x55
	sub r2, r2, #2
	lsl r1, r1, #2
	ldrb r0, [r3, r0]
	ldrh r2, [r3, r2]
	ldr r1, [r4, r1]
	mov r3, #0
	bl ov31_0225E4EC
	b _0225E80E
_0225E7FA:
	sub r0, r2, #3
	mov r1, #0x55
	sub r2, r2, #2
	lsl r1, r1, #2
	ldrb r0, [r3, r0]
	ldrh r2, [r3, r2]
	ldr r1, [r4, r1]
	mov r3, #0
	bl ov31_0225E4BC
_0225E80E:
	ldr r1, [r4, #0x14]
	ldr r0, _0225E93C ; =0x00000283
	ldrb r2, [r1, r0]
	cmp r2, #4
	bhi _0225E8CC
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_0225E824: ; jump table
	.short _0225E82E - _0225E824 - 2 ; case 0
	.short _0225E8BC - _0225E824 - 2 ; case 1
	.short _0225E8CC - _0225E824 - 2 ; case 2
	.short _0225E85C - _0225E824 - 2 ; case 3
	.short _0225E8AC - _0225E824 - 2 ; case 4
_0225E82E:
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0xf
	bl NewString_ReadMsgData
	add r5, r0, #0
	mov r0, #0xa1
	ldr r1, [r4, #0x14]
	lsl r0, r0, #2
	ldrh r0, [r1, r0]
	mov r1, #5
	mov r2, #0xb
	bl GetItemAttr
	add r2, r0, #0
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl BufferPocketName
	b _0225E8DA
_0225E85C:
	add r2, r0, #1
	ldrh r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x9e
	cmp r2, r1
	blo _0225E87E
	sub r0, #0x98
	cmp r2, r0
	bhi _0225E87E
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x31
	bl NewString_ReadMsgData
	add r5, r0, #0
	b _0225E8DA
_0225E87E:
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0xf
	bl NewString_ReadMsgData
	add r5, r0, #0
	mov r0, #0xa1
	ldr r1, [r4, #0x14]
	lsl r0, r0, #2
	ldrh r0, [r1, r0]
	mov r1, #5
	mov r2, #0xb
	bl GetItemAttr
	add r2, r0, #0
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl BufferPocketName
	b _0225E8DA
_0225E8AC:
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x31
	bl NewString_ReadMsgData
	add r5, r0, #0
	b _0225E8DA
_0225E8BC:
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x15
	bl NewString_ReadMsgData
	add r5, r0, #0
	b _0225E8DA
_0225E8CC:
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x17
	bl NewString_ReadMsgData
	add r5, r0, #0
_0225E8DA:
	mov r1, #0x55
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	add r1, #0x34
	ldr r1, [r4, r1]
	add r2, r5, #0
	bl StringExpandPlaceholders
	add r0, r5, #0
	bl String_Delete
	add r0, r4, #0
	add r0, #0x44
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r0, r4, #0
	ldr r2, _0225E940 ; =0x000001B5
	add r0, #0x44
	mov r1, #1
	mov r3, #5
	bl DrawFrameAndWindow2
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	ldr r0, _0225E944 ; =ov31_0225E948
	mov r2, #0x62
	str r0, [sp, #8]
	lsl r2, r2, #2
	add r0, r4, #0
	ldr r2, [r4, r2]
	add r0, #0x44
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xa
	ldr r2, [r4, #0x14]
	lsl r1, r1, #6
	strb r0, [r2, r1]
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0225E938: .word 0x00000286
_0225E93C: .word 0x00000283
_0225E940: .word 0x000001B5
_0225E944: .word ov31_0225E948
	thumb_func_end ov31_0225E7D4

	thumb_func_start ov31_0225E948
ov31_0225E948: ; 0x0225E948
	push {r3, lr}
	cmp r1, #1
	bne _0225E954
	ldr r0, _0225E958 ; =0x00000643
	bl PlaySE
_0225E954:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_0225E958: .word 0x00000643
	thumb_func_end ov31_0225E948

	thumb_func_start ov31_0225E95C
ov31_0225E95C: ; 0x0225E95C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _0225E9C8 ; =0x00000283
	add r4, r1, #0
	ldrb r1, [r5, r0]
	add r1, #0xfd
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	cmp r1, #1
	bhi _0225E97A
	sub r0, #0x2f
	ldr r0, [r5, r0]
	bl PokeathlonSave_GetAthletePoints
	b _0225E982
_0225E97A:
	sub r0, #0x3b
	ldr r0, [r5, r0]
	bl PlayerProfile_GetMoney
_0225E982:
	add r1, r0, #0
	add r0, r5, #0
	bl ov03_02257814
	cmp r0, #2
	bne _0225E998
	add r0, r4, #0
	mov r1, #0x19
	bl NewString_ReadMsgData
	pop {r3, r4, r5, pc}
_0225E998:
	cmp r0, #3
	bne _0225E9A6
	add r0, r4, #0
	mov r1, #0x1a
	bl NewString_ReadMsgData
	pop {r3, r4, r5, pc}
_0225E9A6:
	ldr r0, _0225E9C8 ; =0x00000283
	ldrb r0, [r5, r0]
	add r0, #0xfd
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r0, #1
	bhi _0225E9BE
	add r0, r4, #0
	mov r1, #0x30
	bl NewString_ReadMsgData
	pop {r3, r4, r5, pc}
_0225E9BE:
	add r0, r4, #0
	mov r1, #0xb
	bl NewString_ReadMsgData
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0225E9C8: .word 0x00000283
	thumb_func_end ov31_0225E95C

	thumb_func_start ov31_0225E9CC
ov31_0225E9CC: ; 0x0225E9CC
	ldr r2, _0225EA00 ; =0x00000283
	ldrb r0, [r0, r2]
	cmp r0, #0
	bne _0225E9D8
	mov r3, #0x10
	b _0225E9F6
_0225E9D8:
	cmp r0, #1
	bne _0225E9E0
	mov r3, #0x16
	b _0225E9F6
_0225E9E0:
	cmp r0, #2
	bne _0225E9E8
	mov r3, #0x18
	b _0225E9F6
_0225E9E8:
	cmp r0, #3
	bne _0225E9F0
	mov r3, #0x19
	b _0225E9F6
_0225E9F0:
	cmp r0, #4
	bne _0225E9F6
	mov r3, #0x1a
_0225E9F6:
	add r0, r1, #0
	add r1, r3, #0
	ldr r3, _0225EA04 ; =NewString_ReadMsgData
	bx r3
	nop
_0225EA00: .word 0x00000283
_0225EA04: .word NewString_ReadMsgData
	thumb_func_end ov31_0225E9CC

	thumb_func_start ov31_0225EA08
ov31_0225EA08: ; 0x0225EA08
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x56
	add r5, r0, #0
	lsl r1, r1, #2
	ldr r0, [r5, #0x14]
	ldr r1, [r5, r1]
	bl ov31_0225E95C
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
	add r0, r5, #0
	add r0, #0x44
	mov r1, #0xf
	bl FillWindowPixelBuffer
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
	ldr r2, _0225EA98 ; =0x000001B5
	mov r3, #5
	bl LoadUserFrameGfx2
	add r0, r5, #0
	ldr r2, _0225EA98 ; =0x000001B5
	add r0, #0x44
	mov r1, #1
	mov r3, #5
	bl DrawFrameAndWindow2
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	mov r2, #0x62
	add r0, r5, #0
	str r3, [sp, #8]
	lsl r2, r2, #2
	ldr r2, [r5, r2]
	add r0, #0x44
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xa
	ldr r2, [r5, #0x14]
	lsl r1, r1, #6
	strb r0, [r2, r1]
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_0225EA98: .word 0x000001B5
	thumb_func_end ov31_0225EA08

	thumb_func_start ov31_0225EA9C
ov31_0225EA9C: ; 0x0225EA9C
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x56
	add r5, r0, #0
	lsl r1, r1, #2
	ldr r0, [r5, #0x14]
	ldr r1, [r5, r1]
	bl ov31_0225E9CC
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
	add r0, r5, #0
	add r0, #0x44
	mov r1, #0xf
	bl FillWindowPixelBuffer
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
	ldr r2, _0225EB2C ; =0x000001B5
	mov r3, #5
	bl LoadUserFrameGfx2
	add r0, r5, #0
	ldr r2, _0225EB2C ; =0x000001B5
	add r0, #0x44
	mov r1, #1
	mov r3, #5
	bl DrawFrameAndWindow2
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	mov r2, #0x62
	add r0, r5, #0
	str r3, [sp, #8]
	lsl r2, r2, #2
	ldr r2, [r5, r2]
	add r0, #0x44
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xa
	ldr r2, [r5, #0x14]
	lsl r1, r1, #6
	strb r0, [r2, r1]
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_0225EB2C: .word 0x000001B5
	thumb_func_end ov31_0225EA9C

	thumb_func_start ov31_0225EB30
ov31_0225EB30: ; 0x0225EB30
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x10
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
	add r0, r5, #0
	add r0, #0x44
	mov r1, #0xf
	bl FillWindowPixelBuffer
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
	ldr r2, _0225EBC0 ; =0x000001B5
	mov r3, #5
	bl LoadUserFrameGfx2
	add r0, r5, #0
	ldr r2, _0225EBC0 ; =0x000001B5
	add r0, #0x44
	mov r1, #1
	mov r3, #5
	bl DrawFrameAndWindow2
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	mov r2, #0x62
	add r0, r5, #0
	str r3, [sp, #8]
	lsl r2, r2, #2
	ldr r2, [r5, r2]
	add r0, #0x44
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xa
	ldr r2, [r5, #0x14]
	lsl r1, r1, #6
	strb r0, [r2, r1]
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_0225EBC0: .word 0x000001B5
	thumb_func_end ov31_0225EB30

	thumb_func_start ov31_0225EBC4
ov31_0225EBC4: ; 0x0225EBC4
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x14
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
	add r0, r5, #0
	add r0, #0x44
	mov r1, #0xf
	bl FillWindowPixelBuffer
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
	ldr r2, _0225EC54 ; =0x000001B5
	mov r3, #5
	bl LoadUserFrameGfx2
	add r0, r5, #0
	ldr r2, _0225EC54 ; =0x000001B5
	add r0, #0x44
	mov r1, #1
	mov r3, #5
	bl DrawFrameAndWindow2
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	mov r2, #0x62
	add r0, r5, #0
	str r3, [sp, #8]
	lsl r2, r2, #2
	ldr r2, [r5, r2]
	add r0, #0x44
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xa
	ldr r2, [r5, #0x14]
	lsl r1, r1, #6
	strb r0, [r2, r1]
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_0225EC54: .word 0x000001B5
	thumb_func_end ov31_0225EBC4

	thumb_func_start ov31_0225EC58
ov31_0225EC58: ; 0x0225EC58
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	mov r0, #7
	str r0, [sp]
	mov r0, #0xb
	str r0, [sp, #4]
	mov r2, #4
	add r1, r4, #0
	str r2, [sp, #8]
	mov r3, #0xc
	str r3, [sp, #0xc]
	mov r0, #0xad
	str r0, [sp, #0x10]
	ldr r0, [r4, #4]
	add r1, #0xe4
	bl AddWindowParameterized
	mov r0, #0xe
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	mov r0, #0xc
	str r0, [sp, #0xc]
	mov r0, #0xd9
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0xf4
	mov r2, #4
	mov r3, #0x10
	bl AddWindowParameterized
	mov r0, #0xe
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	mov r0, #0xc
	str r0, [sp, #0xc]
	mov r1, #0xdf
	str r1, [sp, #0x10]
	add r1, #0x25
	ldr r0, [r4, #4]
	add r1, r4, r1
	mov r2, #4
	mov r3, #0x14
	bl AddWindowParameterized
	mov r0, #0x15
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xc
	str r0, [sp, #0xc]
	mov r1, #0xe5
	str r1, [sp, #0x10]
	add r1, #0x2f
	ldr r0, [r4, #4]
	add r1, r4, r1
	mov r2, #4
	mov r3, #0xe
	bl AddWindowParameterized
	mov r0, #0xd
	str r0, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #5
	str r0, [sp, #8]
	mov r0, #0xb
	str r0, [sp, #0xc]
	mov r1, #0xf3
	str r1, [sp, #0x10]
	add r1, #0x31
	ldr r0, [r4, #4]
	add r1, r4, r1
	mov r2, #4
	mov r3, #1
	bl AddWindowParameterized
	mov r0, #0xe
	str r0, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	mov r0, #0xc
	ldr r1, _0225ED98 ; =0x0000011B
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	add r1, #0x19
	ldr r0, [r4, #4]
	add r1, r4, r1
	mov r2, #4
	mov r3, #0x17
	bl AddWindowParameterized
	mov r0, #1
	str r0, [sp]
	mov r0, #0x11
	str r0, [sp, #4]
	mov r2, #4
	str r2, [sp, #8]
	mov r3, #0xc
	ldr r1, _0225ED9C ; =0x00000133
	str r3, [sp, #0xc]
	str r1, [sp, #0x10]
	add r1, #0x11
	ldr r0, [r4, #4]
	add r1, r4, r1
	bl AddWindowParameterized
	add r0, r4, #0
	add r0, #0xe4
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0xf4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x41
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x49
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x4d
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x51
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add sp, #0x14
	pop {r3, r4, pc}
	.balign 4, 0
_0225ED98: .word 0x0000011B
_0225ED9C: .word 0x00000133
	thumb_func_end ov31_0225EC58

	thumb_func_start ov31_0225EDA0
ov31_0225EDA0: ; 0x0225EDA0
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xe4
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xf4
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x41
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x49
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x4d
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x51
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x51
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #1
	bl ClearFrameAndWindow2
	add r0, r4, #0
	add r0, #0x44
	mov r1, #0
	bl ClearFrameAndWindow2
	add r0, r4, #0
	add r0, #0xe4
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0xf4
	bl RemoveWindow
	mov r0, #0x41
	lsl r0, r0, #2
	add r0, r4, r0
	bl RemoveWindow
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	bl RemoveWindow
	mov r0, #0x49
	lsl r0, r0, #2
	add r0, r4, r0
	bl RemoveWindow
	mov r0, #0x4d
	lsl r0, r0, #2
	add r0, r4, r0
	bl RemoveWindow
	mov r0, #0x51
	lsl r0, r0, #2
	add r0, r4, r0
	bl RemoveWindow
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov31_0225EDA0
