#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start PCBox_Init
PCBox_Init: ; 0x021E5900
	push {r3, r4, r5, lr}
	mov r2, #1
	add r5, r0, #0
	mov r0, #3
	mov r1, #9
	lsl r2, r2, #0x10
	bl Heap_Create
	add r0, r5, #0
	mov r1, #0x38
	mov r2, #9
	bl OverlayManager_CreateAndGetData
	mov r1, #0
	mov r2, #0x38
	add r4, r0, #0
	bl MI_CpuFill8
	add r0, r5, #0
	bl OverlayManager_GetArgs
	str r0, [r4]
	ldr r0, [r0]
	bl SaveArray_PCStorage_Get
	str r0, [r4, #4]
	bl PCStorage_GetActiveBox
	strb r0, [r4, #0x1f]
	ldr r0, [r4]
	ldr r0, [r0]
	bl SaveArray_Party_Get
	str r0, [r4, #8]
	ldr r0, [r4]
	ldr r0, [r0]
	bl Save_Bag_Get
	str r0, [r4, #0xc]
	ldr r0, [r4]
	ldr r0, [r0]
	bl Save_PlayerData_GetOptionsAddr
	str r0, [r4, #0x10]
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	mov r0, #0
	str r0, [r4, #0x2c]
	mov r0, #0xb
	str r0, [r4, #0x30]
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end PCBox_Init

	thumb_func_start PCBox_Main
PCBox_Main: ; 0x021E596C
	push {r4, lr}
	add r4, r1, #0
	bl OverlayManager_GetData
	add r1, r4, #0
	bl ov14_021EAF8C
	cmp r0, #0
	bne _021E5982
	mov r0, #1
	pop {r4, pc}
_021E5982:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end PCBox_Main

	thumb_func_start PCBox_Exit
PCBox_Exit: ; 0x021E5988
	push {r4, lr}
	add r4, r0, #0
	bl OverlayManager_GetData
	add r1, r0, #0
	ldr r0, [r1, #4]
	ldrb r1, [r1, #0x1f]
	bl PCStorage_SetActiveBox
	add r0, r4, #0
	bl OverlayManager_FreeData
	mov r0, #9
	bl Heap_Destroy
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end PCBox_Exit

	thumb_func_start ov14_021E59AC
ov14_021E59AC: ; 0x021E59AC
	push {r4, lr}
	add r4, r1, #0
	ldr r0, [r4, #0x34]
	ldr r1, [r0, #4]
	cmp r1, #0
	beq _021E59C6
	add r0, r4, #0
	blx r1
	cmp r0, #0
	bne _021E59C6
	ldr r0, [r4, #0x34]
	mov r1, #0
	str r1, [r0, #4]
_021E59C6:
	add r0, r4, #0
	bl ov14_021E5A14
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x18]
	bl PaletteData_PushTransparentBuffers
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x14]
	bl DoScheduledBgGpuUpdates
	ldr r0, [r4, #0x34]
	bl ov14_021F29C4
	ldr r1, [r4, #0x34]
	ldr r0, _021E5A08 ; =0x000088D2
	ldrh r0, [r1, r0]
	cmp r0, #0
	bne _021E59FA
	mov r0, #0xbe
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl SpriteSystem_DrawSprites
	bl SpriteSystem_TransferOam
_021E59FA:
	ldr r3, _021E5A0C ; =0x027E0000
	ldr r1, _021E5A10 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r4, pc}
	.balign 4, 0
_021E5A08: .word 0x000088D2
_021E5A0C: .word 0x027E0000
_021E5A10: .word 0x00003FF8
	thumb_func_end ov14_021E59AC

	thumb_func_start ov14_021E5A14
ov14_021E5A14: ; 0x021E5A14
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	ldr r1, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021E5A30
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	bl sub_02019978
	pop {r4, pc}
_021E5A30:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	bl sub_02019978
	ldr r0, [r4, #0x34]
	bl ov14_021F3BC0
	pop {r4, pc}
	thumb_func_end ov14_021E5A14

	thumb_func_start ov14_021E5A44
ov14_021E5A44: ; 0x021E5A44
	mov r2, #0
	strh r2, [r0, #0x10]
	strh r2, [r0, #0x12]
	str r1, [r0, #4]
	str r2, [r0, #8]
	bx lr
	thumb_func_end ov14_021E5A44

	thumb_func_start ov14_021E5A50
ov14_021E5A50: ; 0x021E5A50
	str r1, [r0, #8]
	bx lr
	thumb_func_end ov14_021E5A50

	thumb_func_start ov14_021E5A54
ov14_021E5A54: ; 0x021E5A54
	ldr r3, _021E5A5C ; =ov14_021E5A44
	ldr r1, [r0, #8]
	bx r3
	nop
_021E5A5C: .word ov14_021E5A44
	thumb_func_end ov14_021E5A54

	thumb_func_start ov14_021E5A60
ov14_021E5A60: ; 0x021E5A60
	ldr r3, _021E5A68 ; =GfGfx_SetBanks
	ldr r0, _021E5A6C ; =ov14_021F7CE4
	bx r3
	nop
_021E5A68: .word GfGfx_SetBanks
_021E5A6C: .word ov14_021F7CE4
	thumb_func_end ov14_021E5A60

	thumb_func_start ov14_021E5A70
ov14_021E5A70: ; 0x021E5A70
	push {r4, r5, lr}
	sub sp, #0xd4
	add r4, r0, #0
	mov r0, #0xa
	bl BgConfig_Alloc
	ldr r1, [r4, #0x34]
	add r3, sp, #0xc4
	ldr r5, _021E5BE0 ; =ov14_021F7BC8
	str r0, [r1, #0x14]
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r5, _021E5BE4 ; =ov14_021F7C20
	add r3, sp, #0xa8
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #0
	str r0, [r3]
	ldr r0, [r4, #0x34]
	add r3, r1, #0
	ldr r0, [r0, #0x14]
	bl InitBgFromTemplate
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x14]
	bl BgClearTilemapBufferAndCommit
	mov r0, #0
	mov r1, #0x20
	add r2, r0, #0
	mov r3, #0xa
	bl BG_ClearCharDataRange
	ldr r5, _021E5BE8 ; =ov14_021F7C3C
	add r3, sp, #0x8c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #1
	str r0, [r3]
	ldr r0, [r4, #0x34]
	mov r3, #0
	ldr r0, [r0, #0x14]
	bl InitBgFromTemplate
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x14]
	bl BgClearTilemapBufferAndCommit
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	mov r3, #0xa
	bl BG_ClearCharDataRange
	ldr r5, _021E5BEC ; =ov14_021F7C74
	add r3, sp, #0x70
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	str r0, [r3]
	ldr r0, [r4, #0x34]
	mov r1, #2
	ldr r0, [r0, #0x14]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r5, _021E5BF0 ; =ov14_021F7C90
	add r3, sp, #0x54
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #3
	str r0, [r3]
	ldr r0, [r4, #0x34]
	mov r3, #0
	ldr r0, [r0, #0x14]
	bl InitBgFromTemplate
	ldr r5, _021E5BF4 ; =ov14_021F7C58
	add r3, sp, #0x38
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #4
	str r0, [r3]
	ldr r0, [r4, #0x34]
	mov r3, #0
	ldr r0, [r0, #0x14]
	bl InitBgFromTemplate
	ldr r0, [r4, #0x34]
	mov r1, #4
	ldr r0, [r0, #0x14]
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #0xa
	bl BG_ClearCharDataRange
	ldr r5, _021E5BF8 ; =ov14_021F7CAC
	add r3, sp, #0x1c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #5
	str r0, [r3]
	ldr r0, [r4, #0x34]
	mov r3, #0
	ldr r0, [r0, #0x14]
	bl InitBgFromTemplate
	ldr r5, _021E5BFC ; =ov14_021F7CC8
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #6
	str r0, [r3]
	ldr r0, [r4, #0x34]
	mov r3, #0
	ldr r0, [r0, #0x14]
	bl InitBgFromTemplate
	ldr r0, [r4, #0x34]
	mov r1, #6
	ldr r0, [r0, #0x14]
	bl BgClearTilemapBufferAndCommit
	mov r0, #6
	mov r1, #0x20
	mov r2, #0
	mov r3, #0xa
	bl BG_ClearCharDataRange
	add sp, #0xd4
	pop {r4, r5, pc}
	nop
_021E5BE0: .word ov14_021F7BC8
_021E5BE4: .word ov14_021F7C20
_021E5BE8: .word ov14_021F7C3C
_021E5BEC: .word ov14_021F7C74
_021E5BF0: .word ov14_021F7C90
_021E5BF4: .word ov14_021F7C58
_021E5BF8: .word ov14_021F7CAC
_021E5BFC: .word ov14_021F7CC8
	thumb_func_end ov14_021E5A70

	thumb_func_start ov14_021E5C00
ov14_021E5C00: ; 0x021E5C00
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #6
	ldr r0, [r0, #0x14]
	bl FreeBgTilemapBuffer
	ldr r0, [r4, #0x34]
	mov r1, #5
	ldr r0, [r0, #0x14]
	bl FreeBgTilemapBuffer
	ldr r0, [r4, #0x34]
	mov r1, #4
	ldr r0, [r0, #0x14]
	bl FreeBgTilemapBuffer
	ldr r0, [r4, #0x34]
	mov r1, #3
	ldr r0, [r0, #0x14]
	bl FreeBgTilemapBuffer
	ldr r0, [r4, #0x34]
	mov r1, #2
	ldr r0, [r0, #0x14]
	bl FreeBgTilemapBuffer
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x14]
	bl FreeBgTilemapBuffer
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x14]
	bl FreeBgTilemapBuffer
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x14]
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov14_021E5C00

	thumb_func_start ov14_021E5C54
ov14_021E5C54: ; 0x021E5C54
	push {r4, lr}
	sub sp, #0x10
	mov r3, #0
	str r3, [sp]
	add r4, r0, #0
	str r3, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r0, #0x13
	ldr r2, [r2, #0x14]
	mov r1, #0xe
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r3, #1
	str r3, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r0, #0x13
	ldr r2, [r2, #0x14]
	mov r1, #0xe
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r0, #0x13
	ldr r2, [r2, #0x14]
	mov r1, #3
	mov r3, #2
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r1, #2
	ldr r2, [r2, #0x14]
	mov r0, #0x13
	add r3, r1, #0
	bl GfGfxLoader_LoadScrnData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r1, #1
	str r1, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r0, #0x13
	ldr r2, [r2, #0x14]
	mov r3, #3
	bl GfGfxLoader_LoadCharData
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r0, #0x13
	ldr r2, [r2, #0x14]
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
	mov r0, #0x80
	str r0, [sp]
	mov r0, #0xa
	mov r2, #0
	str r0, [sp, #4]
	mov r0, #0x13
	mov r1, #4
	add r3, r2, #0
	bl GfGfxLoader_GXLoadPal
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r0, #0x13
	ldr r2, [r2, #0x14]
	mov r1, #6
	mov r3, #5
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r1, #5
	ldr r2, [r2, #0x14]
	mov r0, #0x13
	add r3, r1, #0
	bl GfGfxLoader_LoadScrnData
	mov r3, #0
	str r3, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #0x13
	mov r1, #7
	mov r2, #4
	bl GfGfxLoader_GXLoadPal
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x34]
	mov r1, #6
	ldr r2, [r2, #0x14]
	mov r0, #0x13
	add r3, r1, #0
	bl GfGfxLoader_LoadCharData
	add sp, #0x10
	pop {r4, pc}
	thumb_func_end ov14_021E5C54

	thumb_func_start ov14_021E5D78
ov14_021E5D78: ; 0x021E5D78
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0
	mov r1, #0x1b
	mov r2, #0x18
	mov r3, #0xa
	bl NewMsgDataFromNarc
	ldr r1, [r4, #0x34]
	mov r2, #0
	str r0, [r1, #0x20]
	mov r0, #1
	mov r1, #2
	mov r3, #0xa
	bl MessagePrinter_New
	ldr r1, [r4, #0x34]
	str r0, [r1, #0x1c]
	mov r0, #0xa
	bl MessageFormat_New
	ldr r1, [r4, #0x34]
	str r0, [r1, #0x24]
	mov r0, #1
	lsl r0, r0, #0xa
	mov r1, #0xa
	bl String_New
	ldr r1, [r4, #0x34]
	str r0, [r1, #0x28]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E5D78

	thumb_func_start ov14_021E5DB8
ov14_021E5DB8: ; 0x021E5DB8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x28]
	bl String_Delete
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x24]
	bl MessageFormat_Delete
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x1c]
	bl MessagePrinter_Delete
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x20]
	bl DestroyMsgData
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E5DB8

	thumb_func_start ov14_021E5DE0
ov14_021E5DE0: ; 0x021E5DE0
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0xfa
	ldr r4, [r5, #0x34]
	lsl r0, r0, #2
	str r0, [sp]
	sub r0, #0xe8
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x14]
	mov r0, #0x13
	mov r1, #0x40
	mov r3, #0
	bl GfGfxLoader_LoadCharData
	mov r0, #0xfa
	lsl r0, r0, #2
	str r0, [sp]
	sub r0, #0xe8
	str r0, [sp, #4]
	mov r3, #1
	str r3, [sp, #8]
	mov r0, #0xa
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x14]
	mov r0, #0x13
	mov r1, #0x40
	bl GfGfxLoader_LoadCharData
	mov r0, #0x40
	str r0, [sp]
	mov r0, #0xa
	mov r3, #6
	str r0, [sp, #4]
	mov r0, #0x13
	mov r1, #0x41
	mov r2, #0
	lsl r3, r3, #6
	bl GfGfxLoader_GXLoadPal
	ldr r0, [r5, #0x10]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r3, #0xa
	str r3, [sp, #4]
	ldr r0, [r4, #0x14]
	ldr r2, _021E5E70 ; =0x0000038E
	mov r1, #0
	bl LoadUserFrameGfx2
	mov r1, #0x16
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #0xa
	bl LoadFontPal1
	mov r1, #0x1e
	mov r0, #4
	lsl r1, r1, #4
	mov r2, #0xa
	bl LoadFontPal0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021E5E70: .word 0x0000038E
	thumb_func_end ov14_021E5DE0

	thumb_func_start ov14_021E5E74
ov14_021E5E74: ; 0x021E5E74
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xa
	bl PaletteData_Init
	ldr r1, [r4, #0x34]
	mov r2, #2
	str r0, [r1, #0x18]
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x18]
	lsl r2, r2, #8
	mov r3, #0xa
	bl PaletteData_AllocBuffers
	pop {r4, pc}
	thumb_func_end ov14_021E5E74

	thumb_func_start ov14_021E5E94
ov14_021E5E94: ; 0x021E5E94
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x18]
	bl PaletteData_FreeBuffers
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x18]
	bl PaletteData_Free
	pop {r4, pc}
	thumb_func_end ov14_021E5E94

	thumb_func_start ov14_021E5EAC
ov14_021E5EAC: ; 0x021E5EAC
	push {r3, lr}
	cmp r0, #1
	bne _021E5EC4
	mov r0, #0xa
	str r0, [sp]
	ldr r0, _021E5ECC ; =0x04000050
	mov r1, #0
	mov r2, #0x2a
	mov r3, #6
	bl G2x_SetBlendAlpha_
	pop {r3, pc}
_021E5EC4:
	ldr r0, _021E5ECC ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	pop {r3, pc}
	.balign 4, 0
_021E5ECC: .word 0x04000050
	thumb_func_end ov14_021E5EAC

	thumb_func_start ov14_021E5ED0
ov14_021E5ED0: ; 0x021E5ED0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xa
	bl YesNoPrompt_Create
	ldr r2, [r4, #0x34]
	ldr r1, _021E5EE4 ; =0x00000434
	str r0, [r2, r1]
	pop {r4, pc}
	nop
_021E5EE4: .word 0x00000434
	thumb_func_end ov14_021E5ED0

	thumb_func_start ov14_021E5EE8
ov14_021E5EE8: ; 0x021E5EE8
	ldr r1, [r0, #0x34]
	ldr r0, _021E5EF4 ; =0x00000434
	ldr r3, _021E5EF8 ; =YesNoPrompt_Destroy
	ldr r0, [r1, r0]
	bx r3
	nop
_021E5EF4: .word 0x00000434
_021E5EF8: .word YesNoPrompt_Destroy
	thumb_func_end ov14_021E5EE8

	thumb_func_start ov14_021E5EFC
ov14_021E5EFC: ; 0x021E5EFC
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	ldr r2, [r0, #0x34]
	mov r4, #0xeb
	ldr r2, [r2, #0x14]
	mov r5, #0
	str r2, [sp]
	lsl r4, r4, #2
	mov r2, #8
	str r4, [sp, #8]
	str r2, [sp, #0xc]
	str r5, [sp, #4]
	mov r3, #0x19
	add r2, sp, #0
	strb r3, [r2, #0x10]
	mov r3, #0xc
	strb r3, [r2, #0x11]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	lsl r1, r1, #0x1c
	ldrb r6, [r2, #0x12]
	mov r3, #0xf
	lsr r1, r1, #0x18
	bic r6, r3
	strb r6, [r2, #0x12]
	ldrb r3, [r2, #0x12]
	mov r6, #0xf0
	add r4, #0x88
	bic r3, r6
	orr r1, r3
	strb r1, [r2, #0x12]
	strb r5, [r2, #0x13]
	ldr r0, [r0, #0x34]
	add r1, sp, #0
	ldr r0, [r0, r4]
	bl YesNoPrompt_InitFromTemplate
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021E5EFC

	thumb_func_start ov14_021E5F4C
ov14_021E5F4C: ; 0x021E5F4C
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r1, _021E6044 ; =0x000088D4
	add r4, r0, r1
	ldrb r1, [r4, #2]
	cmp r1, #0
	beq _021E5F68
	cmp r1, #1
	beq _021E5FC0
	cmp r1, #2
	beq _021E602C
	b _021E603E
_021E5F68:
	ldrb r1, [r4]
	lsl r2, r1, #0x1f
	lsr r2, r2, #0x1f
	bne _021E5F8A
	lsl r1, r1, #0x18
	lsr r1, r1, #0x19
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	ldrb r1, [r4, #1]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	bl ManagedSprite_SetPaletteOverride
	b _021E5FB8
_021E5F8A:
	ldrb r1, [r4, #6]
	str r1, [sp]
	ldrb r1, [r4, #7]
	str r1, [sp, #4]
	ldrb r1, [r4, #1]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	str r1, [sp, #8]
	ldrb r1, [r4]
	ldrb r2, [r4, #4]
	ldrb r3, [r4, #5]
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x14]
	lsr r1, r1, #0x19
	bl BgTilemapRectChangePalette
	ldrb r1, [r4]
	ldr r0, [r5, #0x34]
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x14]
	lsr r1, r1, #0x19
	bl ScheduleBgTilemapBufferTransfer
_021E5FB8:
	ldrb r0, [r4, #2]
	add r0, r0, #1
	strb r0, [r4, #2]
	b _021E603E
_021E5FC0:
	ldrb r0, [r4, #3]
	add r0, r0, #1
	strb r0, [r4, #3]
	ldrb r0, [r4, #3]
	cmp r0, #4
	bne _021E603E
	ldrb r0, [r4]
	lsl r1, r0, #0x1f
	lsr r1, r1, #0x1f
	bne _021E5FF0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x19
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	add r1, r1, r0
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	ldrb r1, [r4, #1]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1c
	bl ManagedSprite_SetPaletteOverride
	b _021E6020
_021E5FF0:
	ldrb r0, [r4, #6]
	str r0, [sp]
	ldrb r0, [r4, #7]
	str r0, [sp, #4]
	ldrb r0, [r4, #1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1c
	str r0, [sp, #8]
	ldrb r1, [r4]
	ldr r0, [r5, #0x34]
	ldrb r2, [r4, #4]
	lsl r1, r1, #0x18
	ldrb r3, [r4, #5]
	ldr r0, [r0, #0x14]
	lsr r1, r1, #0x19
	bl BgTilemapRectChangePalette
	ldrb r1, [r4]
	ldr r0, [r5, #0x34]
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x14]
	lsr r1, r1, #0x19
	bl ScheduleBgTilemapBufferTransfer
_021E6020:
	mov r0, #0
	strb r0, [r4, #3]
	ldrb r0, [r4, #2]
	add r0, r0, #1
	strb r0, [r4, #2]
	b _021E603E
_021E602C:
	ldrb r0, [r4, #3]
	add r0, r0, #1
	strb r0, [r4, #3]
	ldrb r0, [r4, #3]
	cmp r0, #2
	bne _021E603E
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_021E603E:
	mov r0, #1
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_021E6044: .word 0x000088D4
	thumb_func_end ov14_021E5F4C

	thumb_func_start ov14_021E6048
ov14_021E6048: ; 0x021E6048
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_IsButtonInputMode
	cmp r0, #1
	ldr r0, [r4]
	bne _021E6064
	ldr r0, [r0, #4]
	mov r1, #0
	bl MenuInputStateMgr_SetState
	pop {r4, pc}
_021E6064:
	ldr r0, [r0, #4]
	mov r1, #1
	bl MenuInputStateMgr_SetState
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E6048

	thumb_func_start ov14_021E6070
ov14_021E6070: ; 0x021E6070
	push {r4, r5, r6, lr}
	add r6, r1, #0
	ldrb r1, [r0, #0x1f]
	add r5, r2, #0
	add r2, r6, #0
	add r4, r3, #0
	bl ov14_021E60C0
	cmp r0, #0
	bne _021E6088
	mov r0, #0
	pop {r4, r5, r6, pc}
_021E6088:
	add r1, r5, #0
	add r2, r4, #0
	bl GetBoxMonData
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021E6070

	thumb_func_start ov14_021E6094
ov14_021E6094: ; 0x021E6094
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r4, r1, #0
	ldrb r1, [r5, #0x1f]
	add r6, r2, #0
	add r2, r4, #0
	add r7, r3, #0
	bl ov14_021E60C0
	cmp r0, #0
	beq _021E60BE
	add r1, r6, #0
	add r2, r7, #0
	bl SetBoxMonData
	cmp r4, #0x1e
	bhs _021E60BE
	ldrb r1, [r5, #0x1f]
	ldr r0, [r5, #4]
	bl PCStorage_SetBoxModified
_021E60BE:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021E6094

	thumb_func_start ov14_021E60C0
ov14_021E60C0: ; 0x021E60C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	cmp r1, #0xff
	beq _021E60CE
	cmp r4, #0x1e
	blo _021E60F0
_021E60CE:
	cmp r4, #0x1e
	blo _021E60D4
	sub r4, #0x1e
_021E60D4:
	ldr r0, [r5, #8]
	bl Party_GetCount
	cmp r0, r4
	bls _021E60EC
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl Party_GetMonByIndex
	bl Mon_GetBoxMon
	pop {r3, r4, r5, pc}
_021E60EC:
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E60F0:
	cmp r4, #0xff
	bne _021E60F8
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E60F8:
	ldr r0, [r5, #4]
	bl PCStorage_GetMonByIndexPair
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E60C0

	thumb_func_start ov14_021E6100
ov14_021E6100: ; 0x021E6100
	push {r3, lr}
	cmp r2, #0x1e
	bhs _021E610E
	ldr r0, [r0, #4]
	bl PCStorage_DeleteBoxMonByIndexPair
	pop {r3, pc}
_021E610E:
	sub r2, #0x1e
	ldr r0, [r0, #8]
	add r1, r2, #0
	bl Party_RemoveMon
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E6100

	thumb_func_start ov14_021E611C
ov14_021E611C: ; 0x021E611C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	add r4, r2, #0
	ldrb r1, [r5, #0x1f]
	ldr r2, [r6, #4]
	bl ov14_021E60C0
	ldr r1, [r6]
	bl CopyBoxPokemonToPokemon
	ldr r7, [r4, #4]
	ldr r0, [r5, #8]
	sub r7, #0x1e
	add r1, r7, #0
	bl Party_GetMonByIndex
	ldr r1, [r4]
	bl CopyPokemonToPokemon
	mov r1, #0
	add r0, sp, #0
	strb r1, [r0]
	ldr r0, [r4]
	mov r1, #MON_DATA_MOOD
	add r2, sp, #0
	bl SetMonData
	ldr r0, [r5, #8]
	ldr r2, [r6]
	add r1, r7, #0
	bl Party_SafeCopyMonToSlot_ResetAprijuiceModifiers
	ldr r0, [r4]
	bl Mon_GetBoxMon
	add r3, r0, #0
	ldrb r1, [r5, #0x1f]
	ldr r0, [r5, #4]
	ldr r2, [r4, #8]
	bl PCStorage_PlaceMonInBoxByIndexPair
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4958
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4A20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E611C

	thumb_func_start ov14_021E6184
ov14_021E6184: ; 0x021E6184
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	ldrb r1, [r5, #0x1f]
	ldr r2, [r4, #4]
	bl ov14_021E60C0
	ldr r1, [r4]
	bl CopyBoxPokemonToPokemon
	ldr r0, [r5, #8]
	ldr r1, [r4]
	bl Party_AddMon
	ldrb r1, [r5, #0x1f]
	ldr r2, [r4, #4]
	add r0, r5, #0
	bl ov14_021E6100
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4958
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4A20
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E6184

	thumb_func_start ov14_021E61BC
ov14_021E61BC: ; 0x021E61BC
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r4, r1, #0
	add r5, r0, #0
	ldr r1, [r4, #4]
	ldr r0, [r5, #8]
	sub r1, #0x1e
	bl Party_GetMonByIndex
	mov r2, #0
	add r1, sp, #0
	strb r2, [r1]
	add r6, r0, #0
	mov r1, #MON_DATA_MOOD
	add r2, sp, #0
	bl SetMonData
	add r0, r6, #0
	bl Mon_GetBoxMon
	add r3, r0, #0
	ldrb r1, [r5, #0x1f]
	ldr r0, [r5, #4]
	ldr r2, [r4, #8]
	bl PCStorage_PlaceMonInBoxByIndexPair
	ldrb r1, [r5, #0x1f]
	ldr r2, [r4, #4]
	add r0, r5, #0
	bl ov14_021E6100
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4958
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4A20
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021E61BC

	thumb_func_start ov14_021E6210
ov14_021E6210: ; 0x021E6210
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r1, #0
	ldr r7, [r6, #4]
	add r5, r0, #0
	ldr r4, [r6, #8]
	sub r7, #0x1e
	ldr r0, [r5, #8]
	add r1, r7, #0
	sub r4, #0x1e
	bl Party_GetMonByIndex
	ldr r1, [r6]
	bl CopyPokemonToPokemon
	add r1, sp, #4
	ldr r0, [r5, #8]
	add r1, #1
	add r2, r7, #0
	bl Party_GetMonAprijuiceModifiers
	ldr r0, [r5, #8]
	add r1, sp, #0
	add r2, r4, #0
	bl Party_GetMonAprijuiceModifiers
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl Party_GetMonByIndex
	add r2, r0, #0
	ldr r0, [r5, #8]
	add r1, r7, #0
	bl Party_SafeCopyMonToSlot_ResetAprijuiceModifiers
	ldr r0, [r5, #8]
	ldr r2, [r6]
	add r1, r4, #0
	bl Party_SafeCopyMonToSlot_ResetAprijuiceModifiers
	ldr r0, [r5, #8]
	add r1, sp, #0
	add r2, r7, #0
	bl Party_SetMonAprijuiceModifiers
	add r1, sp, #4
	ldr r0, [r5, #8]
	add r1, #1
	add r2, r4, #0
	bl Party_SetMonAprijuiceModifiers
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E6210

	thumb_func_start ov14_021E627C
ov14_021E627C: ; 0x021E627C
	push {r4, r5, r6, lr}
	sub sp, #8
	add r4, r1, #0
	ldr r6, [r4, #4]
	add r5, r0, #0
	sub r6, #0x1e
	ldr r0, [r5, #8]
	add r1, r6, #0
	bl Party_GetMonByIndex
	ldr r1, [r4]
	bl CopyPokemonToPokemon
	ldr r0, [r5, #8]
	add r1, sp, #0
	add r2, r6, #0
	bl Party_GetMonAprijuiceModifiers
	ldrb r1, [r5, #0x1f]
	ldr r2, [r4, #4]
	add r0, r5, #0
	bl ov14_021E6100
	ldr r0, [r5, #8]
	ldr r1, [r4]
	bl Party_AddMon
	ldr r0, [r5, #8]
	bl Party_GetCount
	sub r2, r0, #1
	ldr r0, [r5, #8]
	add r1, sp, #0
	bl Party_SetMonAprijuiceModifiers
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021E627C

	thumb_func_start ov14_021E62C8
ov14_021E62C8: ; 0x021E62C8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r4, r1, #0
	ldrb r1, [r5, #0x1f]
	ldr r2, [r4, #4]
	bl ov14_021E60C0
	add r6, r0, #0
	ldr r1, [r4, #8]
	add r0, r5, #0
	bl ov14_021E6464
	add r7, r0, #0
	ldr r0, [r5, #4]
	add r1, r7, #0
	add r2, r6, #0
	bl PCStorage_PlaceMonInBoxFirstEmptySlot
	ldrb r1, [r5, #0x1f]
	ldr r0, [r5, #4]
	ldr r2, [r4, #4]
	bl PCStorage_DeleteBoxMonByIndexPair
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4958
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4A20
	add r0, r5, #0
	add r1, r7, #0
	bl ov14_021F4958
	add r0, r5, #0
	add r1, r7, #0
	bl ov14_021F4A20
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021E62C8

	thumb_func_start ov14_021E6318
ov14_021E6318: ; 0x021E6318
	push {r4, r5, r6, lr}
	add r4, r1, #0
	ldr r1, [r4, #8]
	add r5, r0, #0
	bl ov14_021E6464
	ldr r1, [r4, #4]
	add r6, r0, #0
	ldr r0, [r5, #8]
	sub r1, #0x1e
	bl Party_GetMonByIndex
	ldr r1, [r4]
	bl CopyPokemonToPokemon
	ldr r0, [r4]
	mov r1, #5
	mov r2, #0
	bl GetMonData
	mov r1, #0x7b
	lsl r1, r1, #2
	cmp r0, r1
	bne _021E6350
	ldr r0, [r4]
	mov r1, #0
	bl Mon_UpdateShayminForm
_021E6350:
	ldr r0, [r4]
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, [r5, #4]
	add r1, r6, #0
	bl PCStorage_PlaceMonInBoxFirstEmptySlot
	ldrb r1, [r5, #0x1f]
	ldr r2, [r4, #4]
	add r0, r5, #0
	bl ov14_021E6100
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F4958
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F4A20
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021E6318

	thumb_func_start ov14_021E637C
ov14_021E637C: ; 0x021E637C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	add r0, r4, #0
	add r0, #0xe4
	ldr r0, [r0]
	cmp r0, #0xff
	beq _021E6462
	ldr r0, [r5, #8]
	bl Party_GetCount
	add r1, r4, #0
	add r1, #0xe8
	ldr r3, [r1]
	mov r1, #0x80
	tst r1, r3
	beq _021E63CA
	add r0, r5, #0
	add r1, r3, #0
	bl ov14_021E6464
	add r0, r4, #0
	add r0, #0xe4
	ldr r1, [r0]
	cmp r1, #0x1e
	bhs _021E63BC
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021E62C8
	pop {r3, r4, r5, pc}
_021E63BC:
	sub r1, #0x1e
	lsl r1, r1, #5
	add r0, r5, #0
	add r1, r4, r1
	bl ov14_021E6318
	pop {r3, r4, r5, pc}
_021E63CA:
	add r1, r4, #0
	add r1, #0xe4
	ldr r2, [r1]
	cmp r2, #0x1e
	bhs _021E6410
	cmp r3, #0x1e
	bhs _021E63F2
	ldrb r1, [r5, #0x1f]
	ldr r0, [r5, #4]
	bl PCStorage_SwapMonsInBoxByIndexPair
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4958
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	bl ov14_021F4A20
	pop {r3, r4, r5, pc}
_021E63F2:
	sub r3, #0x1e
	cmp r3, r0
	bhs _021E6406
	add r1, r4, #0
	add r4, #0x20
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021E611C
	pop {r3, r4, r5, pc}
_021E6406:
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021E6184
	pop {r3, r4, r5, pc}
_021E6410:
	cmp r3, #0x1e
	bhs _021E6446
	add r1, r3, #0
	add r0, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021E6432
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0x20
	add r2, r4, #0
	bl ov14_021E611C
	pop {r3, r4, r5, pc}
_021E6432:
	add r1, r4, #0
	add r1, #0xe4
	ldr r1, [r1]
	add r0, r5, #0
	sub r1, #0x1e
	lsl r1, r1, #5
	add r1, r4, r1
	bl ov14_021E61BC
	pop {r3, r4, r5, pc}
_021E6446:
	sub r3, #0x1e
	cmp r3, r0
	bhs _021E6456
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021E6210
	pop {r3, r4, r5, pc}
_021E6456:
	sub r2, #0x1e
	lsl r1, r2, #5
	add r0, r5, #0
	add r1, r4, r1
	bl ov14_021E627C
_021E6462:
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E637C

	thumb_func_start ov14_021E6464
ov14_021E6464: ; 0x021E6464
	push {r4, lr}
	add r0, #0x25
	ldrb r0, [r0]
	add r4, r1, #0
	mov r1, #6
	bl _s32_div_f
	mov r1, #0x7f
	add r2, r4, #0
	and r2, r1
	mov r1, #6
	mul r1, r0
	add r0, r2, r1
	pop {r4, pc}
	thumb_func_end ov14_021E6464

	thumb_func_start ov14_021E6480
ov14_021E6480: ; 0x021E6480
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #8]
	add r7, r1, #0
	mov r4, #0
	bl Party_GetCount
	cmp r0, #0
	bls _021E64CA
_021E6492:
	cmp r4, r7
	beq _021E64BE
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl Party_GetMonByIndex
	mov r1, #0x4c
	mov r2, #0
	add r6, r0, #0
	bl GetMonData
	cmp r0, #0
	bne _021E64BE
	add r0, r6, #0
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021E64BE
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021E64BE:
	ldr r0, [r5, #8]
	add r4, r4, #1
	bl Party_GetCount
	cmp r4, r0
	blo _021E6492
_021E64CA:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E6480
