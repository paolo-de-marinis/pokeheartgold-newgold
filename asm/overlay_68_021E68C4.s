	.include "asm/macros.inc"
	.include "overlay_68.inc"
	.include "global.inc"

.public ov68_021E70BC
.public ov68_021E7124
.public ov68_021E7178
.public ov68_021E7288
.public ov68_021E734C
.public ov68_021E7388
.public ov68_021E73A4
.public ov68_021E7424
.public ov68_021E74C0
.public ov68_021E74D8
.public ov68_021E7568
.public ov68_021E75C0
.public ov68_021E7604
.public ov68_021E7898
.public ov68_021E7A18
.public ov68_021E7A90
.public ov68_021E7AB4
.public ov68_021E7AD8
.public ov68_021E7B6C
.public ov68_021E7B8C
.public ov68_021E7B94
.public ov68_021E7BC8
.public ov68_021E7BF8
.public ov68_021E7C18
.public ov68_021E7C2C
.public ov68_021E7C44
.public ov68_021E7C60
.public ov68_021E7C7C
.public ov68_021E7C98
.public ov68_021E7CB4
.public ov68_021E7CD0
.public ov68_021E7D14
.public ov68_021E7D3C
.public ov68_021E7D40
.public ov68_021E7DA4
.public ov68_021E7DFC

	.text

	thumb_func_start ov68_021E68C4
ov68_021E68C4: ; 0x021E68C4
	mov r1, #0x11
	lsl r1, r1, #4
	ldr r3, _021E68D0 ; =ListMenuItems_Delete
	ldr r0, [r0, r1]
	bx r3
	nop
_021E68D0: .word ListMenuItems_Delete
	thumb_func_end ov68_021E68C4

	thumb_func_start ov68_021E68D4
ov68_021E68D4: ; 0x021E68D4
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r1, #0
	add r0, #0x58
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x38
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x48
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _021E69EE
	add r0, r4, #0
	mov r1, #2
	bl GetMoveAttr
	add r2, r0, #0
	cmp r2, #1
	bhi _021E692E
	mov r1, #0x21
	add r0, r5, #0
	add r2, r1, #0
	add r0, #0xf8
	add r2, #0xdf
	ldr r0, [r0]
	ldr r2, [r5, r2]
	bl ReadMsgDataIntoString
	b _021E693C
_021E692E:
	mov r0, #0
	str r0, [sp]
	add r0, r5, #0
	mov r1, #0x1d
	mov r3, #3
	bl ov68_021E62D4
_021E693C:
	mov r0, #1
	str r0, [sp]
	mov r2, #0
	ldr r3, _021E6A24 ; =0x00010200
	add r0, r5, #0
	mov r1, #3
	str r2, [sp, #4]
	bl ov68_021E6234
	add r0, r4, #0
	mov r1, #4
	bl GetMoveAttr
	add r2, r0, #0
	bne _021E696E
	mov r1, #0x21
	add r0, r5, #0
	add r2, r1, #0
	add r0, #0xf8
	add r2, #0xdf
	ldr r0, [r0]
	ldr r2, [r5, r2]
	bl ReadMsgDataIntoString
	b _021E697C
_021E696E:
	mov r0, #0
	str r0, [sp]
	add r0, r5, #0
	mov r1, #0x1e
	mov r3, #3
	bl ov68_021E62D4
_021E697C:
	mov r0, #1
	str r0, [sp]
	mov r2, #0
	ldr r3, _021E6A24 ; =0x00010200
	add r0, r5, #0
	mov r1, #4
	str r2, [sp, #4]
	bl ov68_021E6234
	ldr r2, _021E6A28 ; =0x000002ED
	mov r0, #1
	mov r1, #0x1b
	mov r3, #0x42
	bl NewMsgDataFromNarc
	mov r2, #1
	lsl r2, r2, #8
	ldr r2, [r5, r2]
	add r1, r4, #0
	add r6, r0, #0
	bl ReadMsgDataIntoString
	mov r2, #0
	str r2, [sp]
	ldr r3, _021E6A24 ; =0x00010200
	add r0, r5, #0
	mov r1, #5
	str r2, [sp, #4]
	bl ov68_021E6234
	add r0, r6, #0
	bl DestroyMsgData
	lsl r1, r4, #0x10
	add r0, r5, #0
	lsr r1, r1, #0x10
	bl ov68_021E7124
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r0, #8
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x18
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x28
	bl ScheduleWindowCopyToVram
	b _021E6A06
_021E69EE:
	add r0, r5, #0
	add r0, #8
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r5, #0
	add r0, #0x18
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r5, #0
	add r0, #0x28
	bl ClearWindowTilemapAndScheduleTransfer
_021E6A06:
	add r0, r5, #0
	add r0, #0x58
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x38
	bl ScheduleWindowCopyToVram
	add r5, #0x48
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add sp, #8
	pop {r4, r5, r6, pc}
	nop
_021E6A24: .word 0x00010200
_021E6A28: .word 0x000002ED
	thumb_func_end ov68_021E68D4

	thumb_func_start ov68_021E6A2C
ov68_021E6A2C: ; 0x021E6A2C
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r4, r0, #0
	cmp r5, #0xa
	bls _021E6A38
	b _021E6BB0
_021E6A38:
	add r1, r5, r5
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E6A44: ; jump table
	.short _021E6A5A - _021E6A44 - 2 ; case 0
	.short _021E6A72 - _021E6A44 - 2 ; case 1
	.short _021E6A86 - _021E6A44 - 2 ; case 2
	.short _021E6A9E - _021E6A44 - 2 ; case 3
	.short _021E6ACA - _021E6A44 - 2 ; case 4
	.short _021E6AF6 - _021E6A44 - 2 ; case 5
	.short _021E6B22 - _021E6A44 - 2 ; case 6
	.short _021E6B4E - _021E6A44 - 2 ; case 7
	.short _021E6B62 - _021E6A44 - 2 ; case 8
	.short _021E6B8E - _021E6A44 - 2 ; case 9
	.short _021E6B9E - _021E6A44 - 2 ; case 10
_021E6A5A:
	ldr r0, [r4]
	ldr r0, [r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferBoxMonNickname
	b _021E6BB0
_021E6A72:
	bl ov68_021E6BEC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #1
	bl BufferMoveName
	b _021E6BB0
_021E6A86:
	ldr r0, [r4]
	ldr r0, [r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferBoxMonNickname
	b _021E6BB0
_021E6A9E:
	ldr r0, [r4]
	ldr r0, [r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferBoxMonNickname
	add r0, r4, #0
	bl ov68_021E6BEC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #1
	bl BufferMoveName
	b _021E6BB0
_021E6ACA:
	ldr r0, [r4]
	ldr r0, [r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferBoxMonNickname
	add r0, r4, #0
	bl ov68_021E6BEC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #1
	bl BufferMoveName
	b _021E6BB0
_021E6AF6:
	ldr r0, [r4]
	ldr r0, [r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferBoxMonNickname
	add r0, r4, #0
	bl ov68_021E6BFC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #1
	bl BufferMoveName
	b _021E6BB0
_021E6B22:
	ldr r0, [r4]
	ldr r0, [r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferBoxMonNickname
	add r0, r4, #0
	bl ov68_021E6BEC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #1
	bl BufferMoveName
	b _021E6BB0
_021E6B4E:
	bl ov68_021E6BEC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #1
	bl BufferMoveName
	b _021E6BB0
_021E6B62:
	ldr r0, [r4]
	ldr r0, [r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferBoxMonNickname
	add r0, r4, #0
	bl ov68_021E6BEC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #1
	bl BufferMoveName
	b _021E6BB0
_021E6B8E:
	ldr r2, [r4]
	add r0, #0xfc
	ldr r0, [r0]
	ldr r2, [r2, #4]
	mov r1, #2
	bl BufferPlayersName
	b _021E6BB0
_021E6B9E:
	bl ov68_021E6BFC
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	mov r1, #0
	bl BufferMoveName
_021E6BB0:
	ldr r1, [r4]
	add r0, r4, #0
	ldrb r2, [r1, #0x19]
	add r0, #0xf8
	mov r1, #0x2c
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021E6BE8 ; =ov68_021E7DA4
	lsl r2, r5, #2
	add r1, r1, r3
	ldr r0, [r0]
	ldr r1, [r2, r1]
	bl NewString_ReadMsgData
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	add r0, #0xfc
	lsl r1, r1, #8
	ldr r0, [r0]
	ldr r1, [r4, r1]
	add r2, r5, #0
	bl StringExpandPlaceholders
	add r0, r5, #0
	bl String_Delete
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E6BE8: .word ov68_021E7DA4
	thumb_func_end ov68_021E6A2C

	thumb_func_start ov68_021E6BEC
ov68_021E6BEC: ; 0x021E6BEC
	ldr r0, [r0]
	ldr r2, [r0, #0x10]
	ldrh r1, [r0, #0x16]
	ldrh r0, [r0, #0x14]
	add r0, r1, r0
	lsl r0, r0, #1
	ldrh r0, [r2, r0]
	bx lr
	thumb_func_end ov68_021E6BEC

	thumb_func_start ov68_021E6BFC
ov68_021E6BFC: ; 0x021E6BFC
	push {r3, lr}
	ldr r1, [r0]
	mov r2, #0
	ldr r0, [r1]
	ldrb r1, [r1, #0x1b]
	add r1, #0x36
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov68_021E6BFC

	thumb_func_start ov68_021E6C14
ov68_021E6C14: ; 0x021E6C14
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	add r5, r1, #0
	add r0, #0x68
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0x68
	mov r1, #0
	mov r2, #0x3d
	mov r3, #0xd
	bl DrawFrameAndWindow2
	add r0, r4, #0
	add r1, r5, #0
	bl ov68_021E6A2C
	mov r0, #1
	bl TextFlags_SetCanABSpeedUpPrint
	ldr r0, [r4]
	ldr r0, [r0, #8]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	ldr r0, _021E6C6C ; =ov68_021E6C8C
	mov r1, #1
	add r2, r1, #0
	str r0, [sp, #8]
	add r2, #0xff
	add r0, r4, #0
	ldr r2, [r4, r2]
	add r0, #0x68
	bl AddTextPrinterParameterized
	ldr r1, _021E6C70 ; =0x000001B9
	strb r0, [r4, r1]
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_021E6C6C: .word ov68_021E6C8C
_021E6C70: .word 0x000001B9
	thumb_func_end ov68_021E6C14

	thumb_func_start ov68_021E6C74
ov68_021E6C74: ; 0x021E6C74
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x68
	mov r1, #1
	bl ClearFrameAndWindow2
	add r4, #0x68
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov68_021E6C74

	thumb_func_start ov68_021E6C8C
ov68_021E6C8C: ; 0x021E6C8C
	push {r3, lr}
	cmp r1, #5
	bhi _021E6CD0
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E6C9E: ; jump table
	.short _021E6CD0 - _021E6C9E - 2 ; case 0
	.short _021E6CAA - _021E6C9E - 2 ; case 1
	.short _021E6CB0 - _021E6C9E - 2 ; case 2
	.short _021E6CB6 - _021E6C9E - 2 ; case 3
	.short _021E6CBE - _021E6C9E - 2 ; case 4
	.short _021E6CC8 - _021E6C9E - 2 ; case 5
_021E6CAA:
	bl GF_IsAnySEPlaying
	pop {r3, pc}
_021E6CB0:
	bl IsFanfarePlaying
	pop {r3, pc}
_021E6CB6:
	ldr r0, _021E6CD4 ; =0x000005E6
	bl PlaySE
	b _021E6CD0
_021E6CBE:
	mov r0, #0x4a
	lsl r0, r0, #4
	bl PlayFanfare
	b _021E6CD0
_021E6CC8:
	ldr r0, _021E6CD4 ; =0x000005E6
	bl IsSEPlaying
	pop {r3, pc}
_021E6CD0:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021E6CD4: .word 0x000005E6
	thumb_func_end ov68_021E6C8C

	thumb_func_start ov68_021E6CD8
ov68_021E6CD8: ; 0x021E6CD8
	push {r4, r5, r6, lr}
	mov r4, #0
	add r5, r0, #0
	add r6, r4, #0
_021E6CE0:
	ldr r0, [r5]
	add r1, r4, #0
	ldr r0, [r0]
	add r1, #0x36
	add r2, r6, #0
	bl GetMonData
	cmp r0, #0
	beq _021E6CFC
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _021E6CE0
_021E6CFC:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov68_021E6CD8

	thumb_func_start ov68_021E6D00
ov68_021E6D00: ; 0x021E6D00
	push {r4, lr}
	add r4, r0, #0
	mov r1, #3
	bl ov68_021E6C14
	add r0, r4, #0
	bl ov68_021E6CD8
	ldr r1, [r4]
	strb r0, [r1, #0x1b]
	mov r0, #0x1b
	mov r1, #5
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #2
	pop {r4, pc}
	thumb_func_end ov68_021E6D00

	thumb_func_start ov68_021E6D20
ov68_021E6D20: ; 0x021E6D20
	push {r4, lr}
	add r4, r0, #0
	bl ov68_021E6C74
	ldr r0, _021E6D3C ; =0x000001CE
	ldrh r0, [r4, r0]
	cmp r0, #0
	bne _021E6D38
	add r0, r4, #0
	mov r1, #5
	bl ov68_021E7A18
_021E6D38:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021E6D3C: .word 0x000001CE
	thumb_func_end ov68_021E6D20

	thumb_func_start ov68_021E6D40
ov68_021E6D40: ; 0x021E6D40
	ldr r0, [r0]
	mov r1, #1
	strb r1, [r0, #0x1a]
	mov r0, #8
	bx lr
	.balign 4, 0
	thumb_func_end ov68_021E6D40

	thumb_func_start ov68_021E6D4C
ov68_021E6D4C: ; 0x021E6D4C
	push {r3, lr}
	bl ov68_021E6C74
	mov r0, #1
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov68_021E6D4C

	thumb_func_start ov68_021E6D58
ov68_021E6D58: ; 0x021E6D58
	mov r1, #0x1b
	mov r2, #0xa
	lsl r1, r1, #4
	str r2, [r0, r1]
	mov r0, #0
	bx lr
	thumb_func_end ov68_021E6D58

	thumb_func_start ov68_021E6D64
ov68_021E6D64: ; 0x021E6D64
	push {r4, lr}
	mov r1, #7
	add r4, r0, #0
	bl ov68_021E6C14
	ldr r0, _021E6D7C ; =0x000001BA
	mov r1, #3
	strb r1, [r4, r0]
	sub r0, #0xa
	str r1, [r4, r0]
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021E6D7C: .word 0x000001BA
	thumb_func_end ov68_021E6D64

	thumb_func_start ov68_021E6D80
ov68_021E6D80: ; 0x021E6D80
	push {r4, lr}
	mov r1, #8
	add r4, r0, #0
	bl ov68_021E6C14
	mov r0, #0x1b
	mov r1, #8
	lsl r0, r0, #4
	str r1, [r4, r0]
	ldr r0, [r4]
	mov r1, #1
	strb r1, [r0, #0x1a]
	mov r0, #2
	pop {r4, pc}
	thumb_func_end ov68_021E6D80

	thumb_func_start ov68_021E6D9C
ov68_021E6D9C: ; 0x021E6D9C
	push {r4, lr}
	mov r1, #4
	add r4, r0, #0
	bl ov68_021E6C14
	ldr r1, _021E6DB4 ; =0x000001BA
	mov r0, #2
	strb r0, [r4, r1]
	mov r2, #3
	sub r1, #0xa
	str r2, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021E6DB4: .word 0x000001BA
	thumb_func_end ov68_021E6D9C

	thumb_func_start ov68_021E6DB8
ov68_021E6DB8: ; 0x021E6DB8
	push {r4, lr}
	mov r1, #5
	add r4, r0, #0
	bl ov68_021E6C14
	mov r0, #0x1b
	mov r1, #6
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov68_021E6DB8

	thumb_func_start ov68_021E6DD0
ov68_021E6DD0: ; 0x021E6DD0
	mov r1, #0x1b
	mov r2, #0xa
	lsl r1, r1, #4
	str r2, [r0, r1]
	mov r0, #0
	bx lr
	thumb_func_end ov68_021E6DD0

	thumb_func_start ov68_021E6DDC
ov68_021E6DDC: ; 0x021E6DDC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x4c
	ldr r3, _021E6E78 ; =ov68_021E7C2C
	add r2, sp, #0x34
	add r4, r0, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	mov r0, #0x40
	mov r1, #0x42
	bl GF_CreateVramTransferManager
	mov r0, #0x42
	bl SpriteSystem_Alloc
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	bl SpriteManager_New
	mov r7, #0x12
	lsl r7, r7, #4
	add r2, sp, #0x14
	ldr r3, _021E6E7C ; =ov68_021E7CD0
	str r0, [r4, r7]
	ldmia r3!, {r0, r1}
	add r6, r2, #0
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	ldr r5, _021E6E80 ; =ov68_021E7C18
	stmia r2!, {r0, r1}
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	add r1, r6, #0
	str r0, [r3]
	sub r0, r7, #4
	ldr r0, [r4, r0]
	mov r3, #0x20
	bl SpriteSystem_Init
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0xc
	bl SpriteSystem_InitSprites
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	add r2, sp, #0x34
	bl SpriteSystem_InitManagerWithCapacities
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add sp, #0x4c
	pop {r4, r5, r6, r7, pc}
	nop
_021E6E78: .word ov68_021E7C2C
_021E6E7C: .word ov68_021E7CD0
_021E6E80: .word ov68_021E7C18
	thumb_func_end ov68_021E6DDC

	thumb_func_start ov68_021E6E84
ov68_021E6E84: ; 0x021E6E84
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r6, #0x49
	mov r4, #0
	add r5, r7, #0
	lsl r6, r6, #2
_021E6E90:
	ldr r0, [r5, r6]
	bl Sprite_DeleteAndFreeResources
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0xc
	blo _021E6E90
	mov r1, #0x47
	lsl r1, r1, #2
	ldr r0, [r7, r1]
	add r1, r1, #4
	ldr r1, [r7, r1]
	bl SpriteSystem_FreeResourcesAndManager
	mov r0, #0x47
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	bl SpriteSystem_Free
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov68_021E6E84

	thumb_func_start ov68_021E6EB8
ov68_021E6EB8: ; 0x021E6EB8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	add r6, r1, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021E7014 ; =0x0000B8A8
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	mov r3, #6
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021E7018 ; =0x0000B8A9
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	mov r3, #0xb
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r4, _021E701C ; =0x0000B8AB
	add r7, r4, #4
_021E6F00:
	cmp r4, r7
	str r4, [sp]
	bhs _021E6F1C
	mov r0, #0x47
	mov r1, #0x12
	lsl r0, r0, #2
	lsl r1, r1, #4
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	mov r2, #2
	mov r3, #0
	bl sub_020776B8
	b _021E6F30
_021E6F1C:
	mov r0, #0x47
	mov r1, #0x12
	lsl r0, r0, #2
	lsl r1, r1, #4
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	mov r2, #1
	mov r3, #0
	bl sub_020776B8
_021E6F30:
	ldr r0, _021E7020 ; =0x0000B8B2
	add r4, r4, #1
	cmp r4, r0
	bls _021E6F00
	mov r1, #0x47
	sub r0, #8
	lsl r1, r1, #2
	str r0, [sp]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #2
	mov r3, #0
	bl sub_02077834
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	ldr r0, _021E7014 ; =0x0000B8A8
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	mov r3, #5
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r1, #0x47
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r3, _021E7018 ; =0x0000B8A9
	mov r2, #2
	bl sub_020776EC
	mov r1, #0x47
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r3, _021E7024 ; =0x0000B8AA
	mov r2, #1
	bl sub_020776EC
	mov r0, #0
	str r0, [sp]
	ldr r0, _021E7014 ; =0x0000B8A8
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	mov r3, #7
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _021E7018 ; =0x0000B8A9
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	mov r3, #0xa
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _021E7014 ; =0x0000B8A8
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	mov r3, #8
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _021E7018 ; =0x0000B8A9
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	mov r3, #9
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r1, #0x47
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r2, _021E7024 ; =0x0000B8AA
	ldr r1, [r5, r1]
	add r3, r2, #0
	bl sub_0207775C
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E7014: .word 0x0000B8A8
_021E7018: .word 0x0000B8A9
_021E701C: .word 0x0000B8AB
_021E7020: .word 0x0000B8B2
_021E7024: .word 0x0000B8AA
	thumb_func_end ov68_021E6EB8
