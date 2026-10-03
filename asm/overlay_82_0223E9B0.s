	.include "asm/macros.inc"
	.include "overlay_82.inc"
	.include "global.inc"

	.text

	thumb_func_start ov82_0223E9B0
ov82_0223E9B0: ; 0x0223E9B0
	push {r3, lr}
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	mov r0, #0
	add r1, r0, #0
	bl Main_SetHBlankIntrCB
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _0223E9E0 ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _0223E9E4 ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	pop {r3, pc}
	.balign 4, 0
_0223E9E0: .word 0xFFFFE0FF
_0223E9E4: .word 0x04001000
	thumb_func_end ov82_0223E9B0

	thumb_func_start ov82_0223E9E8
ov82_0223E9E8: ; 0x0223E9E8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0xb7
	mov r1, #0x69
	bl NARC_New
	mov r1, #0x22
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r5, #0
	bl ov82_0223EB3C
	add r0, r5, #0
	bl ov82_0223EB9C
	ldr r2, _0223EB2C ; =0x000001B9
	mov r0, #1
	mov r1, #0x1b
	mov r3, #0x69
	bl NewMsgDataFromNarc
	str r0, [r5, #0x20]
	mov r0, #0x69
	bl MessageFormat_New
	str r0, [r5, #0x24]
	mov r0, #0x96
	lsl r0, r0, #2
	mov r1, #0x69
	bl String_New
	str r0, [r5, #0x28]
	mov r0, #0x96
	lsl r0, r0, #2
	mov r1, #0x69
	bl String_New
	str r0, [r5, #0x2c]
	mov r6, #0
	add r4, r5, #0
	mov r7, #0x20
_0223EA3C:
	add r0, r7, #0
	mov r1, #0x69
	bl String_New
	str r0, [r4, #0x30]
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #2
	blt _0223EA3C
	mov r1, #0x1a
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #0x69
	bl LoadFontPal0
	mov r1, #6
	mov r0, #0
	lsl r1, r1, #6
	mov r2, #0x69
	bl LoadFontPal1
	mov r0, #4
	mov r1, #0x40
	mov r2, #0x69
	bl LoadFontPal0
	mov r0, #0xf
	mov r1, #0xe
	mov r2, #0
	mov r3, #0x69
	bl MessagePrinter_New
	add r1, r5, #0
	add r1, #0x98
	str r0, [r1]
	add r1, r5, #0
	ldr r0, [r5, #0x48]
	add r1, #0x4c
	bl ov82_0223FD2C
	ldr r1, [r5, #0x48]
	add r0, r5, #0
	bl ov82_0223F580
	ldr r2, _0223EB30 ; =0x04000304
	ldr r0, _0223EB34 ; =0xFFFF7FFF
	ldrh r1, [r2]
	and r0, r1
	strh r0, [r2]
	bl GfGfx_BothDispOn
	add r0, r5, #0
	bl ov82_0223F558
	add r4, r0, #0
	add r0, r5, #0
	bl ov82_0223F570
	str r0, [sp]
	add r0, r5, #0
	mov r1, #0
	add r0, #0xa8
	mov r2, #1
	add r3, r4, #0
	str r1, [sp, #4]
	bl ov82_0223FC48
	mov r1, #0x81
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r3, #0xa0
	mov r1, #1
	str r3, [sp]
	mov r0, #0
	str r0, [sp, #4]
	add r0, r5, #0
	add r0, #0xa8
	add r2, r1, #0
	bl ov82_0223FC48
	mov r1, #0x82
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r1, #0xc
	ldr r0, [r5, r1]
	mov r1, #0
	bl Party_GetMonByIndex
	add r1, r0, #0
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl ov82_0223FD18
	bl sub_02037474
	cmp r0, #0
	beq _0223EB12
	mov r0, #1
	mov r1, #0x10
	bl G2dRenderer_SetObjCharTransferReservedRegion
	mov r0, #1
	bl G2dRenderer_SetPlttTransferReservedRegion
	bl sub_0203A880
_0223EB12:
	mov r0, #0x69
	bl ov82_0223FDB8
	add r1, r5, #0
	add r1, #0x8c
	str r0, [r1]
	ldr r0, _0223EB38 ; =ov82_0223EC0C
	add r1, r5, #0
	bl Main_SetVBlankIntrCB
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223EB2C: .word 0x000001B9
_0223EB30: .word 0x04000304
_0223EB34: .word 0xFFFF7FFF
_0223EB38: .word ov82_0223EC0C
	thumb_func_end ov82_0223E9E8

	thumb_func_start ov82_0223EB3C
ov82_0223EB3C: ; 0x0223EB3C
	push {r4, lr}
	add r4, r0, #0
	bl ov82_0223EC48
	ldr r0, [r4, #0x48]
	bl ov82_0223EC68
	add r0, r4, #0
	bl ov82_0223ED94
	mov r0, #0x69
	bl PaletteData_Init
	add r1, r4, #0
	add r1, #0x94
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x94
	mov r1, #2
	ldr r0, [r0]
	lsl r2, r1, #8
	mov r3, #0x69
	bl PaletteData_AllocBuffers
	add r0, r4, #0
	add r0, #0x94
	mov r2, #2
	ldr r0, [r0]
	mov r1, #0
	lsl r2, r2, #8
	mov r3, #0x69
	bl PaletteData_AllocBuffers
	add r0, r4, #0
	mov r1, #3
	bl ov82_0223EDF0
	bl ov82_0223EE38
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r4, #0
	mov r1, #5
	bl ov82_0223EE6C
	pop {r4, pc}
	thumb_func_end ov82_0223EB3C

	thumb_func_start ov82_0223EB9C
ov82_0223EB9C: ; 0x0223EB9C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x85
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl Party_GetMonByIndex
	add r4, #0xa8
	add r1, r0, #0
	add r0, r4, #0
	bl ov82_0223F95C
	pop {r4, pc}
	thumb_func_end ov82_0223EB9C

	thumb_func_start ov82_0223EBB8
ov82_0223EBB8: ; 0x0223EBB8
	push {r4, lr}
	mov r2, #1
	lsl r2, r2, #0x1a
	add r4, r0, #0
	ldr r1, [r2]
	ldr r0, _0223EC08 ; =0xFFFF1FFF
	and r0, r1
	str r0, [r2]
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #3
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #1
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #0
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	.balign 4, 0
_0223EC08: .word 0xFFFF1FFF
	thumb_func_end ov82_0223EBB8

	thumb_func_start ov82_0223EC0C
ov82_0223EC0C: ; 0x0223EC0C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #4]
	cmp r0, #0
	bne _0223EC3E
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _0223EC24
	bl PaletteData_PushTransparentBuffers
_0223EC24:
	ldr r0, [r4, #0x48]
	bl DoScheduledBgGpuUpdates
	bl GF_RunVramTransferTasks
	bl OamManager_ApplyAndResetBuffers
	ldr r3, _0223EC40 ; =0x027E0000
	ldr r1, _0223EC44 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
_0223EC3E:
	pop {r4, pc}
	.balign 4, 0
_0223EC40: .word 0x027E0000
_0223EC44: .word 0x00003FF8
	thumb_func_end ov82_0223EC0C

	thumb_func_start ov82_0223EC48
ov82_0223EC48: ; 0x0223EC48
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _0223EC64 ; =ov82_0223FEC4
	add r3, sp, #0
	mov r2, #5
_0223EC52:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0223EC52
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_0223EC64: .word ov82_0223FEC4
	thumb_func_end ov82_0223EC48

	thumb_func_start ov82_0223EC68
ov82_0223EC68: ; 0x0223EC68
	push {r4, r5, lr}
	sub sp, #0x9c
	ldr r5, _0223ED78 ; =ov82_0223FE28
	add r3, sp, #0x8c
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r5, _0223ED7C ; =ov82_0223FE54
	add r3, sp, #0x70
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
	add r0, r4, #0
	add r3, r1, #0
	bl InitBgFromTemplate
	mov r0, #0
	mov r1, #0x20
	add r2, r0, #0
	mov r3, #0x69
	bl BG_ClearCharDataRange
	add r0, r4, #0
	mov r1, #0
	bl BgClearTilemapBufferAndCommit
	ldr r5, _0223ED80 ; =ov82_0223FE70
	add r3, sp, #0x54
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x69
	bl BG_ClearCharDataRange
	add r0, r4, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r5, _0223ED84 ; =ov82_0223FE8C
	add r3, sp, #0x38
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r5, _0223ED88 ; =ov82_0223FEA8
	add r3, sp, #0x1c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	str r0, [r3]
	add r0, r4, #0
	mov r1, #5
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r5, _0223ED8C ; =ov82_0223FE38
	add r3, sp, #0
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r1, _0223ED90 ; =0x04000008
	mov r0, #3
	ldrh r2, [r1]
	bic r2, r0
	mov r0, #1
	strh r2, [r1]
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	add sp, #0x9c
	pop {r4, r5, pc}
	.balign 4, 0
_0223ED78: .word ov82_0223FE28
_0223ED7C: .word ov82_0223FE54
_0223ED80: .word ov82_0223FE70
_0223ED84: .word ov82_0223FE8C
_0223ED88: .word ov82_0223FEA8
_0223ED8C: .word ov82_0223FE38
_0223ED90: .word 0x04000008
	thumb_func_end ov82_0223EC68

	thumb_func_start ov82_0223ED94
ov82_0223ED94: ; 0x0223ED94
	push {r3, r4, r5, lr}
	ldrb r0, [r0, #9]
	bl ov80_0223792C
	cmp r0, #0
	beq _0223EDEA
	mov r0, #1
	lsl r0, r0, #0x1a
	ldr r1, [r0]
	ldr r3, _0223EDEC ; =0xFFFF1FFF
	add r4, r0, #0
	and r1, r3
	str r1, [r0]
	add r4, #0x48
	ldrh r5, [r4]
	mov r1, #0x3f
	mov r2, #0x1f
	bic r5, r1
	orr r5, r2
	strh r5, [r4]
	add r4, r0, #0
	add r4, #0x4a
	ldrh r5, [r4]
	bic r5, r1
	orr r2, r5
	mov r1, #0x20
	orr r1, r2
	strh r1, [r4]
	mov r2, #0xf
	add r1, r0, #0
	lsl r2, r2, #0xc
	add r1, #0x40
	strh r2, [r1]
	add r1, r0, #0
	mov r4, #0x10
	add r1, #0x44
	strh r4, [r1]
	ldr r1, [r0]
	add r2, r1, #0
	and r2, r3
	lsl r1, r4, #9
	orr r1, r2
	str r1, [r0]
_0223EDEA:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223EDEC: .word 0xFFFF1FFF
	thumb_func_end ov82_0223ED94

	thumb_func_start ov82_0223EDF0
ov82_0223EDF0: ; 0x0223EDF0
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	add r4, r1, #0
	mov r0, #0x69
	str r0, [sp, #0xc]
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x48]
	mov r1, #0x17
	add r3, r4, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x69
	str r0, [sp, #0xc]
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x48]
	mov r1, #0x18
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov82_0223EDF0

	thumb_func_start ov82_0223EE38
ov82_0223EE38: ; 0x0223EE38
	push {r3, r4, lr}
	sub sp, #4
	mov r0, #0xb7
	mov r1, #0x99
	add r2, sp, #0
	mov r3, #0x69
	bl GfGfxLoader_GetPlttData
	add r4, r0, #0
	ldr r0, [sp]
	mov r1, #0xc0
	ldr r0, [r0, #0xc]
	bl DC_FlushRange
	ldr r0, [sp]
	mov r1, #0
	ldr r0, [r0, #0xc]
	mov r2, #0xc0
	bl GX_LoadBGPltt
	add r0, r4, #0
	bl Heap_Free
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov82_0223EE38

	thumb_func_start ov82_0223EE6C
ov82_0223EE6C: ; 0x0223EE6C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	add r4, r1, #0
	mov r0, #0x69
	str r0, [sp, #0xc]
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x48]
	mov r1, #0x81
	add r3, r4, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x69
	str r0, [sp, #0xc]
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x48]
	mov r1, #0x82
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0x69
	str r0, [sp, #4]
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xbe
	mov r2, #4
	mov r3, #0
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov82_0223EE6C

	thumb_func_start ov82_0223EECC
ov82_0223EECC: ; 0x0223EECC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r1, #0
	add r5, r0, #0
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x69
	bl BG_ClearCharDataRange
	mov r1, #1
	str r1, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0x69
	str r0, [sp, #0xc]
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x48]
	mov r1, #0x85
	add r3, r4, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r3, #0x20
	str r3, [sp]
	mov r0, #0x69
	str r0, [sp, #4]
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xc0
	mov r2, #4
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov82_0223EECC

	thumb_func_start ov82_0223EF1C
ov82_0223EF1C: ; 0x0223EF1C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r1, #0
	add r1, sp, #0x38
	ldrb r1, [r1]
	add r5, r0, #0
	add r0, r4, #0
	add r6, r2, #0
	add r7, r3, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x20]
	ldr r2, [r5, #0x2c]
	add r1, r6, #0
	bl ReadMsgDataIntoString
	ldr r0, [r5, #0x24]
	ldr r1, [r5, #0x28]
	ldr r2, [r5, #0x2c]
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x28]
	add r2, sp, #0x18
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	add r3, r7, #0
	str r0, [sp, #4]
	add r0, sp, #0x38
	ldrb r1, [r0]
	ldrb r0, [r2, #0x18]
	ldrb r2, [r2, #0x1c]
	lsl r0, r0, #0x18
	lsl r2, r2, #0x18
	lsr r0, r0, #8
	lsr r2, r2, #0x10
	orr r0, r2
	orr r0, r1
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r1, sp, #0x3c
	ldrb r1, [r1]
	ldr r2, [r5, #0x28]
	add r0, r4, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov82_0223EF1C

	thumb_func_start ov82_0223EF7C
ov82_0223EF7C: ; 0x0223EF7C
	push {r3, r4, r5, lr}
	sub sp, #0x18
	mov r3, #1
	add r4, r1, #0
	str r3, [sp]
	mov r1, #0
	str r1, [sp, #4]
	str r3, [sp, #8]
	mov r1, #2
	str r1, [sp, #0xc]
	mov r1, #0xf
	str r1, [sp, #0x10]
	add r5, r0, #0
	add r1, r5, #0
	str r2, [sp, #0x14]
	add r1, #0x4c
	add r2, r4, #0
	bl ov82_0223EF1C
	add r5, #0x4c
	add r4, r0, #0
	add r0, r5, #0
	bl CopyWindowToVram
	add r0, r4, #0
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov82_0223EF7C

	thumb_func_start ov82_0223EFB4
ov82_0223EFB4: ; 0x0223EFB4
	push {r3, lr}
	sub sp, #8
	mov r3, #0
	str r3, [sp]
	mov r3, #1
	str r3, [sp, #4]
	ldr r0, [r0, #0x24]
	mov r3, #2
	bl BufferIntegerAsString
	add sp, #8
	pop {r3, pc}
	thumb_func_end ov82_0223EFB4

	thumb_func_start ov82_0223EFCC
ov82_0223EFCC: ; 0x0223EFCC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r1, #0
	mov r1, #0x85
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	mov r1, #0
	add r7, r2, #0
	add r4, r3, #0
	bl Party_GetMonByIndex
	mov r1, #0xb3
	add r2, sp, #0x10
	bl GetMonData
	add r1, sp, #0x30
	ldrb r1, [r1, #0x18]
	add r0, r5, #0
	bl FillWindowPixelBuffer
	mov r0, #0xb
	mov r1, #0x69
	bl String_New
	add r1, sp, #0x10
	add r6, r0, #0
	bl CopyU16ArrayToString
	str r4, [sp]
	mov r4, #0
	str r4, [sp, #4]
	add r2, sp, #0x30
	ldrb r0, [r2, #0x10]
	ldrb r3, [r2, #0x14]
	ldrb r1, [r2, #0x18]
	lsl r0, r0, #0x18
	lsl r3, r3, #0x18
	lsr r0, r0, #8
	lsr r3, r3, #0x10
	orr r0, r3
	orr r0, r1
	str r0, [sp, #8]
	str r4, [sp, #0xc]
	ldrb r1, [r2, #0x1c]
	add r0, r5, #0
	add r2, r6, #0
	add r3, r7, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r5, #0
	bl CopyWindowToVram
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov82_0223EFCC

	thumb_func_start ov82_0223F040
ov82_0223F040: ; 0x0223F040
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	str r1, [sp, #0x10]
	add r0, r1, #0
	add r1, sp, #0x30
	ldrb r1, [r1, #0x10]
	add r4, r2, #0
	add r6, r3, #0
	bl FillWindowPixelBuffer
	ldr r2, _0223F108 ; =0x000002DF
	mov r0, #1
	mov r1, #0x1b
	mov r3, #0x69
	bl NewMsgDataFromNarc
	str r0, [sp, #0x24]
	mov r0, #0xb
	mov r1, #0x69
	bl String_New
	add r5, r0, #0
	mov r0, #0
	lsl r2, r4, #0x18
	lsr r3, r2, #8
	lsl r2, r6, #0x18
	lsr r2, r2, #0x10
	str r0, [sp, #0x28]
	str r0, [sp, #0x20]
	mov r0, #0x10
	add r1, sp, #0x30
	str r0, [sp, #0x14]
	ldrb r0, [r1, #0x10]
	orr r2, r3
	orr r0, r2
	str r0, [sp, #0x1c]
	ldrb r0, [r1, #0x14]
	str r0, [sp, #0x18]
_0223F08C:
	mov r4, #0
	mov r6, #1
_0223F090:
	ldr r0, [sp, #0x20]
	add r7, r4, r0
	lsl r0, r7, #0x18
	lsr r0, r0, #0x18
	bl ov80_02237920
	cmp r0, #0xfe
	beq _0223F0D4
	add r0, r5, #0
	bl String_SetEmpty
	lsl r0, r7, #0x18
	lsr r0, r0, #0x18
	bl ov80_02237920
	add r1, r0, #0
	ldr r0, [sp, #0x24]
	add r2, r5, #0
	bl ReadMsgDataIntoString
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x1c]
	add r2, r5, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x10]
	add r3, r6, #0
	bl AddTextPrinterParameterizedWithColor
_0223F0D4:
	add r4, r4, #1
	add r6, #0x40
	cmp r4, #4
	blt _0223F090
	ldr r0, [sp, #0x20]
	add r0, r0, #4
	str r0, [sp, #0x20]
	ldr r0, [sp, #0x14]
	add r0, #0x24
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x28]
	add r0, r0, #1
	str r0, [sp, #0x28]
	cmp r0, #5
	blt _0223F08C
	add r0, r5, #0
	bl String_Delete
	ldr r0, [sp, #0x24]
	bl DestroyMsgData
	ldr r0, [sp, #0x10]
	bl CopyWindowToVram
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0223F108: .word 0x000002DF
	thumb_func_end ov82_0223F040

	thumb_func_start ov82_0223F10C
ov82_0223F10C: ; 0x0223F10C
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r1, #0
	str r4, [sp]
	str r3, [sp, #4]
	ldr r1, [sp, #0x18]
	add r0, #0x98
	str r1, [sp, #8]
	add r1, r2, #0
	ldr r0, [r0]
	mov r2, #2
	mov r3, #0
	bl PrintUIntOnWindow
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov82_0223F10C

	thumb_func_start ov82_0223F134
ov82_0223F134: ; 0x0223F134
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r0, #0
	mov r0, #0
	str r0, [sp, #0x10]
	str r0, [sp, #0xc]
	mov r0, #4
	str r1, [sp, #4]
	str r0, [sp, #8]
_0223F146:
	mov r4, #0
	mov r5, #0x12
_0223F14A:
	ldr r0, [sp, #0xc]
	add r7, r4, r0
	lsl r0, r7, #0x18
	lsr r0, r0, #0x18
	bl ov80_02237920
	cmp r0, #0xfe
	beq _0223F18A
	cmp r0, #9
	beq _0223F18A
	lsl r0, r7, #0x18
	lsr r0, r0, #0x18
	bl ov82_0223F6C4
	mov r1, #0x86
	lsl r1, r1, #2
	ldr r1, [r6, r1]
	bl sub_02030BD0
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	cmp r2, #0xa
	bls _0223F17C
	mov r2, #0xa
_0223F17C:
	ldr r0, [sp, #8]
	ldr r1, [sp, #4]
	str r0, [sp]
	add r0, r6, #0
	add r3, r5, #0
	bl ov82_0223F10C
_0223F18A:
	add r4, r4, #1
	add r5, #0x40
	cmp r4, #4
	blt _0223F14A
	ldr r0, [sp, #0xc]
	add r0, r0, #4
	str r0, [sp, #0xc]
	ldr r0, [sp, #8]
	add r0, #0x24
	str r0, [sp, #8]
	ldr r0, [sp, #0x10]
	add r0, r0, #1
	str r0, [sp, #0x10]
	cmp r0, #5
	blt _0223F146
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov82_0223F134

	thumb_func_start ov82_0223F1AC
ov82_0223F1AC: ; 0x0223F1AC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r1, #0
	add r1, sp, #0x18
	ldrb r1, [r1, #0x18]
	add r0, r5, #0
	add r7, r2, #0
	add r4, r3, #0
	bl FillWindowPixelBuffer
	ldr r2, _0223F220 ; =0x000001B9
	mov r0, #1
	mov r1, #0x1b
	mov r3, #0x69
	bl NewMsgDataFromNarc
	mov r1, #0x25
	str r0, [sp, #0x10]
	bl NewString_ReadMsgData
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	str r4, [sp]
	mov r4, #0
	str r4, [sp, #4]
	add r2, sp, #0x18
	ldrb r0, [r2, #0x10]
	ldrb r3, [r2, #0x14]
	ldrb r1, [r2, #0x18]
	lsl r0, r0, #0x18
	lsl r3, r3, #0x18
	lsr r0, r0, #8
	lsr r3, r3, #0x10
	orr r0, r3
	orr r0, r1
	str r0, [sp, #8]
	str r4, [sp, #0xc]
	ldrb r1, [r2, #0x1c]
	add r0, r5, #0
	add r2, r6, #0
	add r3, r7, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, [sp, #0x10]
	bl DestroyMsgData
	add r0, r5, #0
	bl CopyWindowToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0223F220: .word 0x000001B9
	thumb_func_end ov82_0223F1AC

	thumb_func_start ov82_0223F224
ov82_0223F224: ; 0x0223F224
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x69
	mov r1, #0x3c
	bl Heap_Alloc
	add r1, r4, #0
	add r1, #0xa4
	str r0, [r1]
	add r0, r4, #0
	add r0, #0xa4
	ldr r0, [r0]
	mov r1, #0
	mov r2, #0x3c
	bl memset
	mov r0, #0x85
	add r1, r4, #0
	lsl r0, r0, #2
	add r1, #0xa4
	ldr r2, [r4, r0]
	ldr r1, [r1]
	str r2, [r1]
	add r2, r4, #0
	add r2, #0xa4
	ldr r2, [r2]
	mov r1, #1
	strb r1, [r2, #0x11]
	add r2, r4, #0
	add r2, #0x9c
	ldr r3, [r2]
	add r2, r4, #0
	add r2, #0xa4
	ldr r2, [r2]
	str r3, [r2, #4]
	add r2, r4, #0
	add r2, #0xa4
	ldr r2, [r2]
	strb r1, [r2, #0x12]
	ldr r0, [r4, r0]
	bl Party_GetCount
	add r1, r4, #0
	add r1, #0xa4
	ldr r1, [r1]
	strb r0, [r1, #0x13]
	add r0, r4, #0
	add r0, #0xa4
	ldr r0, [r0]
	mov r1, #0
	strb r1, [r0, #0x14]
	add r0, r4, #0
	add r0, #0xa4
	ldr r0, [r0]
	strh r1, [r0, #0x18]
	add r0, r4, #0
	add r0, #0xa0
	ldr r0, [r0]
	bl SaveArray_IsNatDexEnabled
	add r1, r4, #0
	add r1, #0xa4
	ldr r1, [r1]
	str r0, [r1, #0x1c]
	add r0, r4, #0
	add r0, #0xa0
	ldr r0, [r0]
	bl sub_02088288
	add r1, r4, #0
	add r1, #0xa4
	ldr r1, [r1]
	str r0, [r1, #0x2c]
	add r0, r4, #0
	add r0, #0xa0
	ldr r0, [r0]
	bl Save_SpecialRibbons_Get
	add r1, r4, #0
	add r1, #0xa4
	ldr r1, [r1]
	str r0, [r1, #0x20]
	add r0, r4, #0
	add r0, #0xa4
	ldr r0, [r0]
	mov r1, #0
	str r1, [r0, #0x34]
	add r0, r4, #0
	add r0, #0xa4
	ldr r0, [r0]
	ldr r1, _0223F2F4 ; =_0223FE20
	bl sub_02089D40
	add r0, r4, #0
	add r0, #0xa0
	ldr r0, [r0]
	bl Save_PlayerData_GetProfile
	add r4, #0xa4
	add r1, r0, #0
	ldr r0, [r4]
	bl sub_0208AD34
	pop {r4, pc}
	.balign 4, 0
_0223F2F4: .word _0223FE20
	thumb_func_end ov82_0223F224

	thumb_func_start ov82_0223F2F8
ov82_0223F2F8: ; 0x0223F2F8
	mov r3, #0
	strb r3, [r0, #8]
	str r2, [r1]
	bx lr
	thumb_func_end ov82_0223F2F8
