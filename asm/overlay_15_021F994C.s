#include "constants/sndseq.h"
#include "constants/items.h"
#include "msgdata/msg/msg_0010.h"
	.include "asm/macros.inc"
	.include "overlay_15.inc"
	.include "global.inc"

	.text

	thumb_func_start BagApp_SetFlute
BagApp_SetFlute: ; 0x021F994C
	push {r4, lr}
	add r4, r1, #0
	bl BagApp_GetSaveRoamers
	add r1, r4, #0
	bl RoamerSave_SetFlute
	pop {r4, pc}
	thumb_func_end BagApp_SetFlute

	thumb_func_start ov15_021F995C
ov15_021F995C: ; 0x021F995C
	push {r3, lr}
	ldr r0, [r0]
	bl DoScheduledBgGpuUpdates
	bl GF_RunVramTransferTasks
	bl SpriteSystem_TransferOam
	ldr r3, _021F997C ; =0x027E0000
	ldr r1, _021F9980 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r3, pc}
	nop
_021F997C: .word 0x027E0000
_021F9980: .word 0x00003FF8
	thumb_func_end ov15_021F995C

	thumb_func_start ov15_021F9984
ov15_021F9984: ; 0x021F9984
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _021F99A0 ; =ov15_02200618
	add r3, sp, #0
	mov r2, #5
_021F998E:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F998E
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_021F99A0: .word ov15_02200618
	thumb_func_end ov15_021F9984

	thumb_func_start ov15_021F99A4
ov15_021F99A4: ; 0x021F99A4
	push {r4, r5, lr}
	sub sp, #0x14
	ldr r5, _021F9A68 ; =ov15_02200518
	add r3, sp, #4
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r2, _021F9A6C ; =ov15_022006CC
	add r0, r4, #0
	mov r1, #1
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021F9A70 ; =ov15_022006E8
	add r0, r4, #0
	mov r1, #2
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021F9A74 ; =ov15_02200704
	add r0, r4, #0
	mov r1, #3
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	mov r3, #6
	bl BG_ClearCharDataRange
	ldr r2, _021F9A78 ; =ov15_02200720
	add r0, r4, #0
	mov r1, #4
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021F9A7C ; =ov15_0220073C
	add r0, r4, #0
	mov r1, #5
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021F9A80 ; =ov15_02200758
	add r0, r4, #0
	mov r1, #6
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021F9A84 ; =ov15_02200774
	add r0, r4, #0
	mov r1, #7
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #6
	bl BG_ClearCharDataRange
	mov r0, #7
	mov r1, #0x20
	mov r2, #0
	mov r3, #6
	bl BG_ClearCharDataRange
	mov r1, #0
	ldr r0, _021F9A88 ; =0x04000050
	mov r2, #8
	add r3, r1, #0
	str r1, [sp]
	bl G2x_SetBlendAlpha_
	add sp, #0x14
	pop {r4, r5, pc}
	.balign 4, 0
_021F9A68: .word ov15_02200518
_021F9A6C: .word ov15_022006CC
_021F9A70: .word ov15_022006E8
_021F9A74: .word ov15_02200704
_021F9A78: .word ov15_02200720
_021F9A7C: .word ov15_0220073C
_021F9A80: .word ov15_02200758
_021F9A84: .word ov15_02200774
_021F9A88: .word 0x04000050
	thumb_func_end ov15_021F99A4

	thumb_func_start ov15_021F9A8C
ov15_021F9A8C: ; 0x021F9A8C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x1b
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #7
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #6
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #3
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #2
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #1
	bl FreeBgTilemapBuffer
	mov r0, #6
	add r1, r4, #0
	bl Heap_FreeExplicit
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov15_021F9A8C

	thumb_func_start ov15_021F9AE4
ov15_021F9AE4: ; 0x021F9AE4
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0xf
	mov r1, #6
	bl NARC_New
	mov r1, #0x91
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #6
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0xf
	mov r1, #7
	mov r3, #2
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #6
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0xf
	mov r1, #0x36
	mov r3, #2
	bl GfGfxLoader_LoadScrnData
	ldr r0, _021F9C60 ; =0x00000615
	ldrb r0, [r4, r0]
	cmp r0, #0
	bne _021F9B4A
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #6
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0xf
	mov r1, #0x5e
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
	b _021F9B62
_021F9B4A:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #6
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0xf
	mov r1, #0x5d
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
_021F9B62:
	mov r2, #0
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0xf
	mov r1, #8
	add r3, r2, #0
	bl GfGfxLoader_GXLoadPal
	mov r0, #0x20
	str r0, [sp]
	mov r0, #6
	mov r3, #0x1a
	str r0, [sp, #4]
	mov r0, #0xf
	mov r1, #0x11
	mov r2, #0
	lsl r3, r3, #4
	bl GfGfxLoader_GXLoadPal
	mov r1, #0x16
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #6
	bl LoadFontPal1
	mov r0, #0
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, [r4]
	ldr r2, _021F9C64 ; =0x000003F7
	mov r1, #1
	mov r3, #0xe
	bl LoadUserFrameGfx1
	mov r0, #9
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, [r4]
	ldr r2, _021F9C68 ; =0x000003D9
	mov r1, #1
	mov r3, #0xc
	bl LoadUserFrameGfx2
	mov r3, #0
	str r3, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0xf
	mov r1, #0x26
	mov r2, #4
	bl GfGfxLoader_GXLoadPal
	mov r1, #0x16
	mov r0, #4
	lsl r1, r1, #4
	mov r2, #6
	bl LoadFontPal1
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r3, #6
	str r3, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0xf
	mov r1, #0x2e
	bl GfGfxLoader_LoadCharData
	ldr r2, _021F9C6C ; =0x00000694
	mov r0, #0xf
	mov r1, #0x28
	add r2, r4, r2
	mov r3, #6
	bl GfGfxLoader_GetPlttData
	ldr r2, _021F9C70 ; =0x0000068C
	mov r1, #0x29
	str r0, [r4, r2]
	add r2, #0xc
	mov r0, #0xf
	add r2, r4, r2
	mov r3, #6
	bl GfGfxLoader_GetPlttData
	mov r1, #0x69
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #0x80
	mov r2, #4
	str r0, [sp]
	mov r0, #6
	add r3, r2, #0
	str r0, [sp, #4]
	mov r0, #0xf
	mov r1, #8
	add r3, #0xfc
	bl GfGfxLoader_GXLoadPal
	mov r0, #9
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, [r4]
	ldr r2, _021F9C74 ; =0x000003E2
	mov r1, #4
	mov r3, #0xc
	bl LoadUserFrameGfx2
	add sp, #0x10
	pop {r4, pc}
	nop
_021F9C60: .word 0x00000615
_021F9C64: .word 0x000003F7
_021F9C68: .word 0x000003D9
_021F9C6C: .word 0x00000694
_021F9C70: .word 0x0000068C
_021F9C74: .word 0x000003E2
	thumb_func_end ov15_021F9AE4

	thumb_func_start ov15_021F9C78
ov15_021F9C78: ; 0x021F9C78
	push {r3, lr}
	sub sp, #0x10
	add r2, r0, #0
	cmp r1, #1
	bne _021F9C9E
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #6
	str r0, [sp, #0xc]
	ldr r2, [r2]
	mov r0, #0xf
	mov r1, #0x36
	mov r3, #2
	bl GfGfxLoader_LoadScrnData
	add sp, #0x10
	pop {r3, pc}
_021F9C9E:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #6
	str r0, [sp, #0xc]
	ldr r2, [r2]
	mov r0, #0xf
	mov r1, #9
	mov r3, #2
	bl GfGfxLoader_LoadScrnData
	add sp, #0x10
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov15_021F9C78

	thumb_func_start ov15_021F9CBC
ov15_021F9CBC: ; 0x021F9CBC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0
	mov r1, #0x1b
	mov r2, #0xa
	mov r3, #6
	bl NewMsgDataFromNarc
	mov r1, #0x2f
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #1
	mov r1, #2
	mov r2, #0
	mov r3, #6
	bl MessagePrinter_New
	mov r1, #0xbb
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #6
	bl MessageFormat_New
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0
	mov r1, #0x1b
	mov r2, #0xde
	mov r3, #6
	bl NewMsgDataFromNarc
	mov r2, #0xbe
	lsl r2, r2, #2
	str r0, [r4, r2]
	mov r0, #0
	mov r1, #0x1b
	sub r2, #0xa
	mov r3, #6
	bl NewMsgDataFromNarc
	mov r1, #0xbf
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #1
	lsl r0, r0, #8
	mov r1, #6
	bl String_New
	ldr r1, _021F9D24 ; =0x000005E4
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021F9D24: .word 0x000005E4
	thumb_func_end ov15_021F9CBC

	thumb_func_start ov15_021F9D28
ov15_021F9D28: ; 0x021F9D28
	push {r3, r4, r5, r6}
	ldr r2, _021F9D5C ; =0x00000614
	mov r1, #0
	strb r1, [r0, r2]
	add r4, r2, #0
	mov r2, #0x8d
	lsl r2, r2, #2
	mov r3, #0xc
_021F9D38:
	add r5, r1, #0
	ldr r6, [r0, r2]
	mul r5, r3
	add r5, r6, r5
	ldr r5, [r5, #4]
	cmp r5, #0
	beq _021F9D4C
	ldrb r5, [r0, r4]
	add r5, r5, #1
	strb r5, [r0, r4]
_021F9D4C:
	add r1, r1, #1
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	cmp r1, #8
	blo _021F9D38
	pop {r3, r4, r5, r6}
	bx lr
	nop
_021F9D5C: .word 0x00000614
	thumb_func_end ov15_021F9D28

	thumb_func_start ov15_021F9D60
ov15_021F9D60: ; 0x021F9D60
	push {r3, r4}
	mov r3, #0x8d
	lsl r3, r3, #2
	ldr r0, [r0, r3]
	add r4, r0, #4
	add r0, #0x64
	ldrb r3, [r0]
	mov r0, #0xc
	mul r0, r3
	cmp r2, #0
	ldr r2, [r4, r0]
	bne _021F9D80
	lsl r0, r1, #2
	ldrh r0, [r2, r0]
	pop {r3, r4}
	bx lr
_021F9D80:
	lsl r0, r1, #2
	add r0, r2, r0
	ldrh r0, [r0, #2]
	pop {r3, r4}
	bx lr
	.balign 4, 0
	thumb_func_end ov15_021F9D60

	thumb_func_start ov15_021F9D8C
ov15_021F9D8C: ; 0x021F9D8C
	add r3, r1, #0
	add r1, r2, #0
	add r2, r3, #0
	ldr r3, _021F9D98 ; =ReadMsgDataIntoString
	bx r3
	nop
_021F9D98: .word ReadMsgDataIntoString
	thumb_func_end ov15_021F9D8C

	thumb_func_start ov15_021F9D9C
ov15_021F9D9C: ; 0x021F9D9C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	add r0, r2, #0
	bl TMHMGetMove
	add r1, r0, #0
	add r0, r5, #0
	add r2, r4, #0
	bl ReadMsgDataIntoString
	pop {r3, r4, r5, pc}
	thumb_func_end ov15_021F9D9C

	thumb_func_start ov15_021F9DB4
ov15_021F9DB4: ; 0x021F9DB4
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r1, [r7, r0]
	mov r5, #0
	add r1, #0x64
	strb r5, [r1]
	ldr r0, [r7, r0]
	add r4, r0, #4
	ldr r0, [r0, #0x6c]
	cmp r0, #0
	bne _021F9E12
	add r2, r5, #0
	mov r1, #0xc
_021F9DD2:
	add r0, r5, #0
	mul r0, r1
	add r3, r4, r0
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021F9DE2
	strh r2, [r3, #4]
	strh r2, [r3, #6]
_021F9DE2:
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #8
	blo _021F9DD2
	mov r2, #0
	mov r1, #0xc
_021F9DF0:
	add r0, r2, #0
	mul r0, r1
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021F9E06
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	add r0, #0x64
	strb r2, [r0]
	pop {r3, r4, r5, r6, r7, pc}
_021F9E06:
	add r0, r2, #1
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	cmp r2, #8
	blo _021F9DF0
	pop {r3, r4, r5, r6, r7, pc}
_021F9E12:
	mov r0, #0xc
	mul r0, r5
	add r6, r4, r0
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021F9E3E
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	ldrb r1, [r6, #8]
	add r2, sp, #0
	ldr r0, [r0, #0x6c]
	add r2, #1
	add r3, sp, #0
	bl BagCursor_Field_PocketGetPosition
	add r0, sp, #0
	ldrb r0, [r0, #1]
	strh r0, [r6, #4]
	add r0, sp, #0
	ldrb r0, [r0]
	strh r0, [r6, #6]
_021F9E3E:
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #8
	blo _021F9E12
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	ldr r0, [r0, #0x6c]
	bl BagCursor_Field_GetPocket
	mov r1, #0xc
	mul r1, r0
	ldr r1, [r4, r1]
	cmp r1, #0
	bne _021F9E7A
	mov r3, #0
	mov r2, #0xc
_021F9E62:
	add r1, r3, #0
	mul r1, r2
	ldr r1, [r4, r1]
	cmp r1, #0
	beq _021F9E70
	add r0, r3, #0
	b _021F9E7A
_021F9E70:
	add r1, r3, #1
	lsl r1, r1, #0x10
	lsr r3, r1, #0x10
	cmp r3, #8
	blo _021F9E62
_021F9E7A:
	mov r1, #0
	mov r2, #0xc
_021F9E7E:
	add r3, r1, #0
	mul r3, r2
	add r5, r4, r3
	ldr r3, [r4, r3]
	cmp r3, #0
	beq _021F9E9C
	ldrb r3, [r5, #8]
	cmp r0, r3
	bne _021F9E9C
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	add r0, #0x64
	strb r1, [r0]
	pop {r3, r4, r5, r6, r7, pc}
_021F9E9C:
	add r1, r1, #1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	cmp r1, #8
	blo _021F9E7E
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov15_021F9DB4

	thumb_func_start ov15_021F9EA8
ov15_021F9EA8: ; 0x021F9EA8
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r1, [r6, r0]
	ldr r0, [r1, #0x6c]
	cmp r0, #0
	beq _021F9F06
	add r0, r1, #4
	str r0, [sp]
	mov r4, #0
	add r5, r0, #0
	mov r7, #6
_021F9EC2:
	ldr r0, [r5]
	cmp r0, #0
	beq _021F9EE2
	mov r0, #0x8d
	lsl r0, r0, #2
	ldrh r2, [r5, #4]
	ldrsh r3, [r5, r7]
	ldr r0, [r6, r0]
	lsl r2, r2, #0x18
	lsl r3, r3, #0x18
	ldrb r1, [r5, #8]
	ldr r0, [r0, #0x6c]
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl BagCursor_Field_PocketSetPosition
_021F9EE2:
	add r4, r4, #1
	add r5, #0xc
	cmp r4, #8
	blo _021F9EC2
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r1, [r6, r0]
	ldr r0, [r1, #0x6c]
	add r1, #0x64
	ldrb r2, [r1]
	mov r1, #0xc
	add r3, r2, #0
	mul r3, r1
	ldr r1, [sp]
	add r1, r1, r3
	ldrb r1, [r1, #8]
	bl BagCursor_Field_SetPocket
_021F9F06:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov15_021F9EA8
