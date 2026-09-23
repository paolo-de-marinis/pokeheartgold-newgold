#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start ov14_021F4A64
ov14_021F4A64: ; 0x021F4A64
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	str r0, [sp]
	mov r0, #0xb
	str r0, [sp, #0x10]
	mov r0, #0
	str r1, [sp, #4]
	str r2, [sp, #8]
	str r0, [sp, #0x20]
_021F4A76:
	mov r0, #0xa
	str r0, [sp, #0x18]
	mov r0, #0
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x20]
	mov r1, #6
	mul r1, r0
	ldr r0, [sp, #0x10]
	str r1, [sp, #0x14]
	add r5, r0, #2
_021F4A8A:
	ldr r0, [sp]
	ldr r3, [sp, #0x1c]
	ldr r2, [sp, #0x14]
	ldr r0, [r0, #4]
	ldr r1, [sp, #4]
	add r2, r3, r2
	bl PCStorage_GetMonByIndexPair
	str r0, [sp, #0x28]
	bl AcquireBoxMonLock
	str r0, [sp, #0x24]
	ldr r0, [sp, #0x28]
	mov r1, #5
	mov r2, #0
	bl GetBoxMonData
	add r4, r0, #0
	ldr r0, [sp, #0x28]
	mov r1, #0xac
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _021F4B4A
	ldr r0, [sp, #0x28]
	mov r1, #0x4c
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	bne _021F4AF0
	ldr r0, [sp, #0x28]
	mov r1, #0x70
	mov r2, #0
	bl GetBoxMonData
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	ldr r0, [sp]
	mov r3, #0x1b
	ldr r1, [r0, #0x34]
	mov r0, #0x45
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r4, #0
	bl GetMonBaseStatEx_HandleAlternateForm
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	b _021F4AFC
_021F4AF0:
	ldr r0, _021F4B88 ; =0x000001EA
	cmp r4, r0
	bne _021F4AFA
	mov r1, #1
	b _021F4AFC
_021F4AFA:
	mov r1, #8
_021F4AFC:
	ldr r0, _021F4B8C ; =ov14_021F8080
	ldr r4, [sp, #0x10]
	ldrb r0, [r0, r1]
	add r0, #0x20
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	lsl r0, r1, #8
	orr r0, r1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0xc]
	add r0, r4, #0
	cmp r0, r5
	bge _021F4B4A
	ldr r0, [sp, #0x18]
	add r1, r0, #0
	asr r7, r0, #3
	mov r0, #7
	add r6, r1, #0
	and r6, r0
_021F4B24:
	asr r2, r4, #3
	lsl r2, r2, #2
	lsl r1, r4, #0x1d
	add r2, r2, r7
	lsr r1, r1, #0x1a
	lsl r2, r2, #6
	add r1, r1, r2
	add r2, r6, r1
	ldr r1, [sp, #8]
	ldr r0, [sp, #0xc]
	add r1, r1, r2
	mov r2, #2
	bl MIi_CpuClear16
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, r5
	blt _021F4B24
_021F4B4A:
	ldr r0, [sp, #0x28]
	ldr r1, [sp, #0x24]
	bl ReleaseBoxMonLock
	ldr r0, [sp, #0x18]
	add r0, r0, #2
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x1c]
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x1c]
	cmp r0, #6
	blo _021F4A8A
	ldr r0, [sp, #0x10]
	add r0, r0, #2
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x20]
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x20]
	cmp r0, #5
	bhs _021F4B84
	b _021F4A76
_021F4B84:
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F4B88: .word 0x000001EA
_021F4B8C: .word ov14_021F8080
	thumb_func_end ov14_021F4A64

	thumb_func_start ov14_021F4B90
ov14_021F4B90: ; 0x021F4B90
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	bl ManagedSprite_SetPositionXY
	ldr r2, [sp, #0x10]
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F2A18
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov14_021F2A60
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F4B90

	thumb_func_start ov14_021F4BC0
ov14_021F4BC0: ; 0x021F4BC0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x34]
	mov r1, #4
	mov r2, #0xc
	mov r3, #0x54
	bl ov14_021F4B90
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x34]
	mov r1, #5
	mov r2, #0xf4
	mov r3, #0x54
	bl ov14_021F4B90
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x34]
	mov r1, #6
	mov r2, #0x2b
	mov r3, #0x54
	bl ov14_021F4B90
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x34]
	mov r1, #7
	mov r2, #0x80
	mov r3, #0x41
	bl ov14_021F4B90
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x34]
	mov r1, #8
	mov r2, #0x80
	mov r3, #0x4d
	bl ov14_021F4B90
	mov r6, #0
	add r4, r6, #0
	mov r7, #1
_021F4C1C:
	ldr r0, [r5, #0x34]
	add r2, sp, #4
	add r1, r0, r4
	mov r0, #0xce
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r1, #2
	bl ManagedSprite_GetPositionXY
	str r7, [sp]
	add r1, r6, #0
	add r3, sp, #4
	mov r2, #2
	ldrsh r2, [r3, r2]
	ldr r0, [r5, #0x34]
	add r1, #0xf
	mov r3, #0x54
	bl ov14_021F4B90
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #6
	blo _021F4C1C
	add r0, r5, #0
	bl ov14_021F49E0
	ldr r0, [r5, #0x34]
	mov r1, #7
	mov r2, #5
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	bl ov14_021F46F4
	ldr r1, [r5, #0x34]
	ldr r0, _021F4C98 ; =0x00000414
	ldr r0, [r1, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r1, [r5, #0x34]
	ldr r0, _021F4C9C ; =0x00000424
	ldr r0, [r1, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r1, [r5, #0x34]
	ldr r0, _021F4C98 ; =0x00000414
	ldr r0, [r1, r0]
	mov r1, #0
	bl sub_020137F0
	ldr r1, [r5, #0x34]
	ldr r0, _021F4C9C ; =0x00000424
	ldr r0, [r1, r0]
	mov r1, #0
	bl sub_020137F0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F4C98: .word 0x00000414
_021F4C9C: .word 0x00000424
	thumb_func_end ov14_021F4BC0

	thumb_func_start ov14_021F4CA0
ov14_021F4CA0: ; 0x021F4CA0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #4
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r1, #5
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r1, #6
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r1, #7
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r1, #8
	mov r2, #0
	bl ov14_021F2A18
	mov r4, #0
	add r6, r4, #0
_021F4CDA:
	add r1, r4, #0
	ldr r0, [r5, #0x34]
	add r1, #0xf
	add r2, r6, #0
	bl ov14_021F2A18
	add r4, r4, #1
	cmp r4, #6
	blo _021F4CDA
	ldr r1, [r5, #0x34]
	ldr r0, _021F4D08 ; =0x00000414
	ldr r0, [r1, r0]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	ldr r1, [r5, #0x34]
	ldr r0, _021F4D0C ; =0x00000424
	ldr r0, [r1, r0]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	pop {r4, r5, r6, pc}
	nop
_021F4D08: .word 0x00000414
_021F4D0C: .word 0x00000424
	thumb_func_end ov14_021F4CA0

	thumb_func_start ov14_021F4D10
ov14_021F4D10: ; 0x021F4D10
	push {r3, r4, r5, lr}
	sub sp, #0x48
	add r4, r0, #0
	mov r0, #2
	mov r1, #0xa
	bl FontSystem_NewInit
	mov r1, #0x41
	lsl r1, r1, #4
	str r0, [r4, r1]
	add r0, r1, #4
	add r5, r4, r0
	add r0, sp, #0x38
	bl InitWindow
	mov r0, #0
	str r0, [sp]
	mov r3, #2
	str r3, [sp, #4]
	ldr r0, [r4, #0x14]
	add r1, sp, #0x38
	mov r2, #0xc
	bl AddTextWindowTopLeftCorner
	add r0, sp, #0x38
	mov r1, #1
	mov r2, #0xa
	bl sub_02013688
	mov r1, #1
	add r2, r1, #0
	add r3, r5, #4
	bl sub_02021AC8
	mov r0, #0x41
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	str r0, [sp, #8]
	add r0, sp, #0x38
	str r0, [sp, #0xc]
	mov r0, #0xbe
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl SpriteManager_GetSpriteList
	str r0, [sp, #0x10]
	mov r0, #0xbe
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldr r1, _021F4E5C ; =0x0000C101
	bl SpriteManager_FindPlttResourceProxy
	str r0, [sp, #0x14]
	mov r0, #0xc6
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	ldr r0, [r0]
	str r0, [sp, #0x18]
	ldr r0, [r5, #8]
	str r0, [sp, #0x1c]
	mov r0, #0x80
	str r0, [sp, #0x20]
	sub r0, #0x9c
	str r0, [sp, #0x24]
	mov r0, #4
	str r0, [sp, #0x2c]
	mov r0, #0xa
	str r0, [sp, #0x34]
	add r0, sp, #8
	str r1, [sp, #0x28]
	str r1, [sp, #0x30]
	bl sub_020135D8
	ldr r1, _021F4E60 ; =0x00000414
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	mov r1, #1
	bl sub_020138B0
	ldr r0, _021F4E60 ; =0x00000414
	mov r1, #1
	ldr r0, [r4, r0]
	bl sub_020138E0
	add r0, sp, #0x38
	bl RemoveWindow
	ldr r0, _021F4E64 ; =0x00000424
	add r5, r4, r0
	add r0, sp, #0x38
	bl InitWindow
	mov r0, #0
	str r0, [sp]
	mov r3, #2
	str r3, [sp, #4]
	ldr r0, [r4, #0x14]
	add r1, sp, #0x38
	mov r2, #5
	bl AddTextWindowTopLeftCorner
	add r0, sp, #0x38
	mov r1, #1
	mov r2, #0xa
	bl sub_02013688
	mov r1, #1
	add r2, r1, #0
	add r3, r5, #4
	bl sub_02021AC8
	mov r0, #0x41
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	str r0, [sp, #8]
	add r0, sp, #0x38
	str r0, [sp, #0xc]
	mov r0, #0xbe
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl SpriteManager_GetSpriteList
	str r0, [sp, #0x10]
	mov r0, #0xbe
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldr r1, _021F4E5C ; =0x0000C101
	bl SpriteManager_FindPlttResourceProxy
	str r0, [sp, #0x14]
	mov r0, #0xc6
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	ldr r0, [r0]
	str r0, [sp, #0x18]
	ldr r0, [r5, #8]
	str r0, [sp, #0x1c]
	mov r0, #0x80
	str r0, [sp, #0x20]
	sub r0, #0x9c
	str r0, [sp, #0x24]
	mov r0, #4
	str r0, [sp, #0x2c]
	mov r0, #0xa
	str r0, [sp, #0x34]
	str r1, [sp, #0x28]
	str r1, [sp, #0x30]
	add r0, sp, #8
	bl sub_020135D8
	str r0, [r5]
	mov r1, #1
	bl sub_020138B0
	ldr r0, [r5]
	mov r1, #1
	bl sub_020138E0
	add r0, sp, #0x38
	bl RemoveWindow
	add sp, #0x48
	pop {r3, r4, r5, pc}
	nop
_021F4E5C: .word 0x0000C101
_021F4E60: .word 0x00000414
_021F4E64: .word 0x00000424
	thumb_func_end ov14_021F4D10

	thumb_func_start ov14_021F4E68
ov14_021F4E68: ; 0x021F4E68
	push {r3, r4, r5, r6, r7, lr}
	ldr r1, _021F4E9C ; =0x00000418
	str r0, [sp]
	mov r6, #0
	add r4, r0, r1
	add r5, r0, #0
	sub r7, r1, #4
_021F4E76:
	add r0, r4, #0
	bl sub_02021B5C
	ldr r0, [r5, r7]
	bl FontOAM_Delete
	add r6, r6, #1
	add r4, #0x10
	add r5, #0x10
	cmp r6, #2
	blo _021F4E76
	mov r1, #0x41
	ldr r0, [sp]
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	bl sub_020135AC
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F4E9C: .word 0x00000418
	thumb_func_end ov14_021F4E68

	thumb_func_start ov14_021F4EA0
ov14_021F4EA0: ; 0x021F4EA0
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r6, r2, #0
	add r0, r4, #0
	mov r1, #0xa
	bl sub_02013910
	add r7, r0, #0
	lsl r0, r6, #4
	add r1, r5, r0
	ldr r0, _021F4ECC ; =0x00000414
	add r2, r4, #0
	ldr r0, [r1, r0]
	add r1, r7, #0
	mov r3, #0xa
	bl TextOBJ_CopyFromBGWindow
	add r0, r7, #0
	bl sub_02013938
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F4ECC: .word 0x00000414
	thumb_func_end ov14_021F4EA0

	thumb_func_start ov14_021F4ED0
ov14_021F4ED0: ; 0x021F4ED0
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #4
	mov r1, #0xa
	bl FontID_Alloc
	mov r6, #0
	ldr r4, _021F4EFC ; =ov14_021F84B4
	add r5, r6, #0
_021F4EE2:
	ldr r1, [r7, #0x34]
	add r2, r4, #0
	ldr r0, [r1, #0x14]
	add r1, #0x30
	add r1, r1, r5
	bl AddWindow
	add r6, r6, #1
	add r4, #8
	add r5, #0x10
	cmp r6, #0x2c
	blo _021F4EE2
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F4EFC: .word ov14_021F84B4
	thumb_func_end ov14_021F4ED0

	thumb_func_start ov14_021F4F00
ov14_021F4F00: ; 0x021F4F00
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
_021F4F06:
	ldr r1, [r5, #0x34]
	lsl r0, r4, #4
	add r1, #0x30
	add r0, r1, r0
	bl RemoveWindow
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x2c
	blo _021F4F06
	mov r0, #4
	bl FontID_Release
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F4F00

	thumb_func_start ov14_021F4F24
ov14_021F4F24: ; 0x021F4F24
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r0, #0
	ldr r0, [sp, #0x30]
	str r1, [sp, #0x10]
	add r5, r2, #0
	add r6, r3, #0
	ldr r4, [sp, #0x28]
	cmp r0, #1
	bne _021F4F44
	add r0, r4, #0
	mov r2, #0
	bl FontID_String_GetWidth
	sub r5, r5, r0
	b _021F4F66
_021F4F44:
	cmp r0, #2
	bne _021F4F56
	add r0, r4, #0
	mov r2, #0
	bl FontID_String_GetWidth
	lsr r0, r0, #1
	sub r5, r5, r0
	b _021F4F66
_021F4F56:
	cmp r0, #3
	bne _021F4F66
	add r0, r4, #0
	mov r2, #0
	bl FontID_String_GetWidthMultiline
	lsr r0, r0, #1
	sub r5, r5, r0
_021F4F66:
	str r6, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, [sp, #0x2c]
	ldr r2, [sp, #0x10]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r7, #0
	add r1, r4, #0
	add r3, r5, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov14_021F4F24

	thumb_func_start ov14_021F4F84
ov14_021F4F84: ; 0x021F4F84
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	add r1, r3, #0
	add r4, r2, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r0, [sp, #0x28]
	add r5, #0x30
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	ldr r2, [sp, #0x20]
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	ldr r3, [sp, #0x24]
	str r0, [sp, #8]
	lsl r0, r4, #4
	add r0, r5, r0
	add r1, r6, #0
	bl ov14_021F4F24
	add r0, r6, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov14_021F4F84

	thumb_func_start ov14_021F4FBC
ov14_021F4FBC: ; 0x021F4FBC
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	add r1, r3, #0
	add r4, r2, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r0, [r5, #0x24]
	ldr r1, [r5, #0x28]
	add r2, r6, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x28]
	add r1, r5, #0
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	add r1, #0x30
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	ldr r2, [sp, #0x20]
	str r0, [sp, #8]
	lsl r0, r4, #4
	add r0, r1, r0
	ldr r1, [r5, #0x28]
	ldr r3, [sp, #0x24]
	bl ov14_021F4F24
	add r0, r6, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov14_021F4FBC

	thumb_func_start ov14_021F5000
ov14_021F5000: ; 0x021F5000
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r4, r5, #0
	add r0, r2, #0
	add r6, r1, #0
	add r4, #0x30
	lsl r7, r0, #4
	add r0, r4, r7
	mov r1, #0
	str r2, [sp, #0x14]
	bl FillWindowPixelBuffer
	ldrb r0, [r6, #0x12]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _021F5044
	ldr r0, [r5, #0x24]
	ldr r2, [r6]
	mov r1, #0
	bl BufferBoxMonSpeciesName
	mov r3, #0
	str r3, [sp]
	str r3, [sp, #4]
	ldr r0, _021F5050 ; =0x00010200
	str r3, [sp, #8]
	str r0, [sp, #0xc]
	str r3, [sp, #0x10]
	ldr r1, [r5, #0x20]
	ldr r2, [sp, #0x14]
	add r0, r5, #0
	bl ov14_021F4FBC
_021F5044:
	add r0, r4, r7
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F5050: .word 0x00010200
	thumb_func_end ov14_021F5000

	thumb_func_start ov14_021F5054
ov14_021F5054: ; 0x021F5054
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r4, r5, #0
	add r0, r2, #0
	add r7, r1, #0
	add r4, #0x30
	lsl r6, r0, #4
	add r0, r4, r6
	mov r1, #0
	str r2, [sp, #0x14]
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x24]
	ldr r2, [r7]
	mov r1, #0
	bl BufferBoxMonNickname
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r0, _021F509C ; =0x00010200
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, [r5, #0x20]
	ldr r2, [sp, #0x14]
	add r0, r5, #0
	mov r3, #1
	bl ov14_021F4FBC
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F509C: .word 0x00010200
	thumb_func_end ov14_021F5054

	thumb_func_start ov14_021F50A0
ov14_021F50A0: ; 0x021F50A0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r4, r5, #0
	add r0, r2, #0
	add r7, r1, #0
	add r4, #0x30
	lsl r6, r0, #4
	add r0, r4, r6
	mov r1, #0
	str r2, [sp, #0x14]
	bl FillWindowPixelBuffer
	ldrb r0, [r7, #0x12]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _021F5104
	mov r0, #5
	str r0, [sp]
	ldr r0, [r5, #0x1c]
	mov r1, #1
	add r2, r4, r6
	mov r3, #0
	bl sub_0200CDAC
	mov r1, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldrb r2, [r7, #0x12]
	ldr r0, [r5, #0x24]
	mov r3, #3
	lsl r2, r2, #0x19
	lsr r2, r2, #0x19
	bl BufferIntegerAsString
	mov r0, #0x10
	str r0, [sp]
	mov r1, #0
	str r1, [sp, #4]
	ldr r0, _021F5110 ; =0x00010200
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, [r5, #0x20]
	ldr r2, [sp, #0x14]
	add r0, r5, #0
	mov r3, #0x5a
	bl ov14_021F4FBC
_021F5104:
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F5110: .word 0x00010200
	thumb_func_end ov14_021F50A0

	thumb_func_start ov14_021F5114
ov14_021F5114: ; 0x021F5114
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r6, r0, #0
	add r4, r6, #0
	add r0, r2, #0
	add r5, r1, #0
	add r4, #0x30
	lsl r7, r0, #4
	add r0, r4, r7
	mov r1, #0
	str r2, [sp, #0x14]
	bl FillWindowPixelBuffer
	ldrb r0, [r5, #0x12]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _021F5182
	ldrb r0, [r5, #0x13]
	lsl r1, r0, #0x18
	lsr r1, r1, #0x1f
	cmp r1, #1
	bne _021F5182
	lsl r0, r0, #0x19
	lsr r0, r0, #0x19
	bne _021F5162
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r0, _021F518C ; =0x00070800
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, [r6, #0x20]
	ldr r2, [sp, #0x14]
	add r0, r6, #0
	mov r3, #0x52
	bl ov14_021F4F84
	b _021F5182
_021F5162:
	cmp r0, #1
	bne _021F5182
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	mov r0, #0xc1
	str r1, [sp, #8]
	lsl r0, r0, #0xa
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, [r6, #0x20]
	ldr r2, [sp, #0x14]
	add r0, r6, #0
	mov r3, #0x53
	bl ov14_021F4F84
_021F5182:
	add r0, r4, r7
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F518C: .word 0x00070800
	thumb_func_end ov14_021F5114
