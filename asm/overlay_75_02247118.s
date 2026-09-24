	.include "asm/macros.inc"
	.include "overlay_75.inc"
	.include "global.inc"
	.public gApplication_TitleScreen

	.text

	thumb_func_start ov75_02247118
ov75_02247118: ; 0x02247118
	push {r4, r5, r6, lr}
	add r5, r1, #0
	bl OverlayManager_GetData
	ldr r1, [r5]
	add r4, r0, #0
	cmp r1, #0
	beq _02247132
	cmp r1, #1
	beq _02247140
	cmp r1, #2
	beq _0224716C
	b _02247178
_02247132:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _02247178
	mov r0, #1
	str r0, [r5]
	b _02247178
_02247140:
	ldr r6, [r4, #8]
	ldr r1, _0224717C ; =ov75_02249B30
	lsl r2, r6, #2
	ldr r1, [r1, r2]
	blx r1
	ldr r1, [r4, #8]
	cmp r6, r1
	beq _02247162
	add r1, r4, #0
	mov r2, #0
	add r1, #0x94
	str r2, [r1]
	add r1, r4, #0
	add r1, #0x9c
	str r2, [r1]
	add r4, #0x98
	str r2, [r4]
_02247162:
	cmp r0, #1
	bne _02247178
	mov r0, #2
	str r0, [r5]
	b _02247178
_0224716C:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _02247178
	mov r0, #1
	pop {r4, r5, r6, pc}
_02247178:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224717C: .word ov75_02249B30
	thumb_func_end ov75_02247118

	thumb_func_start ov75_02247180
ov75_02247180: ; 0x02247180
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	add r0, #0xec
	ldr r0, [r0]
	cmp r0, #0
	beq _022471A4
	bl SysTask_Destroy
	add r0, r4, #0
	mov r1, #0
	add r0, #0xec
	str r1, [r0]
	add r0, r4, #0
	add r0, #0xf0
	str r1, [r0]
_022471A4:
	ldr r0, [r4, #0x34]
	bl DestroyMsgData
	ldr r0, [r4, #0x28]
	bl DestroyMsgData
	ldr r0, [r4, #0x30]
	bl DestroyMsgData
	ldr r0, [r4, #0x2c]
	bl DestroyMsgData
	ldr r0, [r4, #0x24]
	bl DestroyMsgData
	ldr r0, [r4, #0x20]
	bl MessageFormat_Delete
	ldr r0, [r4, #0x3c]
	bl String_Delete
	ldr r0, [r4, #0x40]
	bl String_Delete
	ldr r0, [r4, #0x38]
	bl String_Delete
	add r0, r4, #0
	bl ov75_02247838
	ldr r0, [r4, #4]
	bl Heap_Free
	ldr r0, [r4, #4]
	bl ov75_0224741C
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GF_DestroyVramTransferManager
	bl sub_02021238
	mov r0, #0
	bl TextFlags_SetCanABSpeedUpPrint
	mov r0, #0
	bl TextFlags_SetAutoScrollParam
	mov r0, #0
	bl TextFlags_SetCanTouchSpeedUpPrint
	bl sub_0203A914
	add r0, r5, #0
	bl OverlayManager_FreeData
	mov r0, #0x74
	bl Heap_Destroy
	ldr r0, _02247230 ; =gSystem + 0x60
	mov r1, #0
	strb r1, [r0, #9]
	bl GfGfx_SwapDisplay
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02247230: .word gSystem + 0x60
	thumb_func_end ov75_02247180

	thumb_func_start ov75_02247234
ov75_02247234: ; 0x02247234
	push {r4, lr}
	add r4, r0, #0
	bl GF_RunVramTransferTasks
	bl OamManager_ApplyAndResetBuffers
	ldr r0, [r4, #4]
	bl DoScheduledBgGpuUpdates
	ldr r3, _02247254 ; =0x027E0000
	ldr r1, _02247258 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r4, pc}
	.balign 4, 0
_02247254: .word 0x027E0000
_02247258: .word 0x00003FF8
	thumb_func_end ov75_02247234

	thumb_func_start ov75_0224725C
ov75_0224725C: ; 0x0224725C
	push {r3, r4, r5, lr}
	sub sp, #0xe0
	add r4, r0, #0
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	ldr r5, _0224740C ; =ov75_022499FC
	add r3, sp, #0x48
	mov r2, #5
_02247270:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _02247270
	add r0, sp, #0x48
	bl GfGfx_SetBanks
	mov r1, #6
	mov r2, #2
	mov r0, #0
	lsl r1, r1, #0x18
	lsl r2, r2, #0x12
	bl MIi_CpuClear32
	mov r1, #0x62
	mov r2, #2
	mov r0, #0
	lsl r1, r1, #0x14
	lsl r2, r2, #0x10
	bl MIi_CpuClear32
	mov r1, #0x19
	mov r2, #1
	mov r0, #0
	lsl r1, r1, #0x16
	lsl r2, r2, #0x12
	bl MIi_CpuClear32
	mov r1, #0x66
	mov r2, #2
	mov r0, #0
	lsl r1, r1, #0x14
	lsl r2, r2, #0x10
	bl MIi_CpuClear32
	ldr r5, _02247410 ; =ov75_0224997C
	add r3, sp, #0x38
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r5, _02247414 ; =ov75_02249A5C
	add r3, sp, #0x70
	mov r2, #0xe
_022472D0:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _022472D0
	mov r1, #0
	add r0, r4, #0
	add r2, sp, #0x70
	add r3, r1, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #0
	bl BgClearTilemapBufferAndCommit
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	add r3, r1, #0
	bl BgSetPosTextAndCommit
	mov r1, #0
	add r0, r4, #0
	mov r2, #3
	add r3, r1, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #1
	add r2, sp, #0x8c
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	mov r2, #0
	add r0, r4, #0
	mov r1, #1
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #1
	mov r2, #3
	mov r3, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #2
	add r2, sp, #0xa8
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	mov r2, #0
	add r0, r4, #0
	mov r1, #2
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #2
	mov r2, #3
	mov r3, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #3
	add r2, sp, #0xc4
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	mov r2, #0
	add r0, r4, #0
	mov r1, #3
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	mov r1, #3
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0
	bl BgSetPosTextAndCommit
	ldr r5, _02247418 ; =ov75_02249A24
	add r3, sp, #0
	mov r2, #7
_0224738E:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0224738E
	add r0, r4, #0
	mov r1, #4
	add r2, sp, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	mov r2, #0
	add r0, r4, #0
	mov r1, #4
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #4
	mov r2, #3
	mov r3, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #5
	add r2, sp, #0x1c
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	mov r2, #0
	add r0, r4, #0
	mov r1, #5
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #5
	mov r2, #3
	mov r3, #0
	bl BgSetPosTextAndCommit
	mov r0, #0
	mov r1, #0x20
	add r2, r0, #0
	mov r3, #0x74
	bl BG_ClearCharDataRange
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x74
	bl BG_ClearCharDataRange
	add sp, #0xe0
	pop {r3, r4, r5, pc}
	nop
_0224740C: .word ov75_022499FC
_02247410: .word ov75_0224997C
_02247414: .word ov75_02249A5C
_02247418: .word ov75_02249A24
	thumb_func_end ov75_0224725C

	thumb_func_start ov75_0224741C
ov75_0224741C: ; 0x0224741C
	push {r4, lr}
	add r4, r0, #0
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
	add r0, r4, #0
	mov r1, #0
	bl FreeBgTilemapBuffer
	pop {r4, pc}
	thumb_func_end ov75_0224741C

	thumb_func_start ov75_02247450
ov75_02247450: ; 0x02247450
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x40
	str r0, [sp, #0x10]
	ldr r0, [r0, #4]
	mov r1, #0x74
	str r0, [sp, #0x30]
	mov r0, #0x58
	bl NARC_New
	mov r2, #0
	str r2, [sp]
	mov r1, #0x74
	str r1, [sp, #4]
	mov r1, #3
	add r3, r2, #0
	str r0, [sp, #0x2c]
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r3, #0
	str r3, [sp]
	mov r0, #0x74
	str r0, [sp, #4]
	ldr r0, [sp, #0x2c]
	mov r1, #3
	mov r2, #4
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r1, #0x1a
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #0x74
	bl LoadFontPal1
	mov r1, #0x1a
	mov r0, #4
	lsl r1, r1, #4
	mov r2, #0x74
	bl LoadFontPal1
	ldr r0, [sp, #0x10]
	ldr r0, [r0]
	ldr r0, [r0, #8]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x74
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	mov r1, #0
	mov r2, #1
	mov r3, #0xa
	bl LoadUserFrameGfx2
	mov r1, #0
	str r1, [sp]
	mov r0, #0x74
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	mov r2, #0x1f
	mov r3, #0xb
	bl LoadUserFrameGfx1
	mov r0, #0
	str r0, [sp]
	mov r0, #0x74
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	mov r1, #2
	mov r2, #0x1f
	mov r3, #0xb
	bl LoadUserFrameGfx1
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x74
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	ldr r2, [sp, #0x30]
	mov r1, #2
	mov r3, #1
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r1, #0
	mov r0, #6
	str r1, [sp]
	lsl r0, r0, #8
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0x74
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	ldr r2, [sp, #0x30]
	mov r1, #6
	mov r3, #1
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x74
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	ldr r2, [sp, #0x30]
	mov r1, #0xb
	mov r3, #5
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r1, #0
	mov r0, #6
	str r1, [sp]
	lsl r0, r0, #8
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0x74
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	ldr r2, [sp, #0x30]
	mov r1, #0xc
	mov r3, #5
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	add r1, r0, #0
	bl BG_SetMaskColor
	mov r0, #4
	mov r1, #0
	bl BG_SetMaskColor
	ldr r0, [sp, #0x10]
	mov r2, #0x33
	add r0, #0xec
	mov r1, #0
	lsl r2, r2, #4
	bl MI_CpuFill8
	ldr r0, [sp, #0x2c]
	mov r1, #5
	add r2, sp, #0x3c
	mov r3, #0x74
	bl GfGfxLoader_GetPlttDataFromOpenNarc
	add r4, r0, #0
	ldr r0, [sp, #0x3c]
	ldr r1, [sp, #0x10]
	ldr r0, [r0, #0xc]
	add r1, #0xf4
	mov r2, #0x80
	bl MIi_CpuCopy16
	ldr r0, [sp, #0x3c]
	mov r2, #0x5d
	ldr r1, [sp, #0x10]
	lsl r2, r2, #2
	add r1, r1, r2
	ldr r0, [r0, #0xc]
	mov r2, #0x80
	bl MIi_CpuCopy16
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	mov r1, #0x5d
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x10]
	lsl r1, r1, #2
	add r0, r0, r1
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x10]
	str r0, [sp, #0x14]
	add r0, #0xf4
	str r0, [sp, #0x14]
_022475B6:
	mov r0, #0
	str r0, [sp, #0x20]
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x28]
	add r0, r0, #1
	lsl r1, r0, #5
	ldr r0, [sp, #0x10]
	add r0, r0, r1
	str r0, [sp, #0x34]
_022475C8:
	ldr r0, [sp, #0x24]
	cmp r0, #0x15
	blt _022475D2
	bl GF_AssertFail
_022475D2:
	ldr r0, [sp, #0x34]
	mov r7, #1
	add r6, r0, #2
	ldr r0, [sp, #0x18]
	add r4, r0, #2
	ldr r0, [sp, #0x14]
	add r5, r0, #2
	ldr r0, [sp, #0x20]
	asr r0, r0, #8
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x38]
_022475EA:
	add r0, r6, #0
	add r0, #0xf4
	ldrh r0, [r0]
	ldr r3, [sp, #0x38]
	add r1, r4, #0
	str r0, [sp]
	add r0, r5, #0
	mov r2, #1
	bl BlendPalette
	add r7, r7, #1
	add r6, r6, #2
	add r4, r4, #2
	add r5, r5, #2
	cmp r7, #0x10
	blt _022475EA
	ldr r0, [sp, #0x18]
	add r0, #0x20
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x24]
	add r0, r0, #1
	str r0, [sp, #0x24]
	ldr r0, [sp, #0x1c]
	cmp r0, #1
	beq _02247636
	mov r0, #3
	ldr r1, [sp, #0x20]
	lsl r0, r0, #8
	add r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [sp, #0x20]
	cmp r1, r0
	blt _022475C8
	str r0, [sp, #0x20]
	mov r0, #1
	str r0, [sp, #0x1c]
	b _022475C8
_02247636:
	ldr r0, [sp, #0x14]
	add r0, #0x20
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x28]
	add r0, r0, #1
	str r0, [sp, #0x28]
	cmp r0, #3
	blt _022475B6
	mov r1, #0x5d
	ldr r0, [sp, #0x10]
	lsl r1, r1, #2
	add r0, r0, r1
	mov r1, #0x2a
	lsl r1, r1, #4
	bl DC_FlushRange
	ldr r0, [sp, #0x10]
	mov r1, #1
	add r0, #0xf0
	str r1, [r0]
	ldr r1, _022476E0 ; =0x00000418
	ldr r0, [sp, #0x10]
	mov r2, #0
	str r2, [r0, r1]
	ldr r1, [sp, #0x10]
	ldr r0, _022476E4 ; =ov75_022476E8
	add r1, #0xec
	mov r2, #0x14
	bl SysTask_CreateOnVBlankQueue
	ldr r1, [sp, #0x10]
	add r1, #0xec
	str r0, [r1]
	ldr r0, [sp, #0x2c]
	str r1, [sp, #0x10]
	bl NARC_Delete
	mov r0, #0xc7
	mov r1, #0x74
	bl NARC_New
	add r4, r0, #0
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x74
	str r0, [sp, #0xc]
	ldr r2, [sp, #0x30]
	add r0, r4, #0
	mov r1, #0xb
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x74
	str r0, [sp, #0xc]
	ldr r2, [sp, #0x30]
	add r0, r4, #0
	mov r1, #0xa
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0x20
	str r0, [sp]
	mov r3, #0x74
	str r3, [sp, #4]
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0
	add r3, #0xac
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x40
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_022476E0: .word 0x00000418
_022476E4: .word ov75_022476E8
	thumb_func_end ov75_02247450

	thumb_func_start ov75_022476E8
ov75_022476E8: ; 0x022476E8
	push {r4, lr}
	add r4, r1, #0
	ldr r0, [r4, #4]
	cmp r0, #0
	beq _02247786
	ldr r1, _02247788 ; =0x0000032B
	mov r0, #1
	ldrb r2, [r4, r1]
	eor r2, r0
	strb r2, [r4, r1]
	ldrb r2, [r4, r1]
	tst r0, r2
	bne _02247786
	add r0, r1, #1
	ldr r0, [r4, r0]
	cmp r0, #1
	bhi _0224771E
	sub r0, r1, #3
	ldrsh r0, [r4, r0]
	add r2, r4, #0
	add r2, #0x88
	lsl r0, r0, #5
	add r0, r2, r0
	mov r1, #0
	mov r2, #0x20
	bl GX_LoadBGPltt
_0224771E:
	mov r0, #0xcb
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0224772C
	cmp r0, #2
	bne _02247742
_0224772C:
	mov r0, #0xca
	lsl r0, r0, #2
	ldrsh r0, [r4, r0]
	add r1, r4, #0
	add r1, #0x88
	lsl r0, r0, #5
	add r0, r1, r0
	mov r1, #0
	mov r2, #0x20
	bl GXS_LoadBGPltt
_02247742:
	ldr r0, _0224778C ; =0x0000032A
	ldrsb r1, [r4, r0]
	cmp r1, #0
	bne _0224776A
	sub r1, r0, #2
	ldrsh r1, [r4, r1]
	add r2, r1, #1
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsh r1, [r4, r1]
	cmp r1, #0x15
	blt _02247786
	mov r2, #0x13
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsb r2, [r4, r0]
	mov r1, #1
	eor r1, r2
	strb r1, [r4, r0]
	pop {r4, pc}
_0224776A:
	sub r1, r0, #2
	ldrsh r1, [r4, r1]
	sub r2, r1, #1
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsh r1, [r4, r1]
	cmp r1, #0
	bge _02247786
	mov r2, #1
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsb r1, [r4, r0]
	eor r1, r2
	strb r1, [r4, r0]
_02247786:
	pop {r4, pc}
	.balign 4, 0
_02247788: .word 0x0000032B
_0224778C: .word 0x0000032A
	thumb_func_end ov75_022476E8

	thumb_func_start ov75_02247790
ov75_02247790: ; 0x02247790
	push {r3, r4, lr}
	sub sp, #0x14
	mov r3, #4
	add r4, r0, #0
	str r3, [sp]
	mov r0, #0x17
	str r0, [sp, #4]
	mov r0, #0x10
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x94
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x68
	mov r2, #0
	bl AddWindowParameterized
	add r0, r4, #0
	add r0, #0x68
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #1
	str r0, [sp]
	mov r0, #0x18
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x81
	lsl r0, r0, #2
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x58
	mov r2, #0
	mov r3, #4
	bl AddWindowParameterized
	add r0, r4, #0
	add r0, #0x58
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #1
	ldr r0, _02247834 ; =0x000F0E00
	str r3, [sp]
	str r0, [sp, #4]
	add r0, r4, #0
	ldr r1, [r4, #0x3c]
	add r0, #0x58
	mov r2, #0
	bl ov75_02249684
	mov r0, #0x13
	str r0, [sp]
	mov r0, #0x1b
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x28
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x48
	mov r2, #0
	mov r3, #2
	bl AddWindowParameterized
	add r4, #0x48
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	add sp, #0x14
	pop {r3, r4, pc}
	nop
_02247834: .word 0x000F0E00
	thumb_func_end ov75_02247790

	thumb_func_start ov75_02247838
ov75_02247838: ; 0x02247838
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x48
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0x58
	bl RemoveWindow
	add r4, #0x68
	add r0, r4, #0
	bl RemoveWindow
	pop {r4, pc}
	thumb_func_end ov75_02247838

	thumb_func_start ov75_02247854
ov75_02247854: ; 0x02247854
	str r1, [r0, #8]
	str r2, [r0, #0xc]
	bx lr
	.balign 4, 0
	thumb_func_end ov75_02247854

	thumb_func_start ov75_0224785C
ov75_0224785C: ; 0x0224785C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x8c
	ldr r0, [r0]
	cmp r0, #0
	bne _02247876
	add r0, r4, #0
	add r0, #0x48
	mov r1, #1
	bl WaitingIcon_New
	add r4, #0x8c
	str r0, [r4]
_02247876:
	pop {r4, pc}
	thumb_func_end ov75_0224785C

	thumb_func_start ov75_02247878
ov75_02247878: ; 0x02247878
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x8c
	ldr r0, [r0]
	cmp r0, #0
	beq _0224788E
	bl sub_0200F450
	mov r0, #0
	add r4, #0x8c
	str r0, [r4]
_0224788E:
	pop {r4, pc}
	thumb_func_end ov75_02247878

	thumb_func_start ov75_02247890
ov75_02247890: ; 0x02247890
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x74
	add r4, r1, #0
	add r6, r2, #0
	bl YesNoPrompt_Create
	mov r3, #0
	mov r1, #0xe
	str r1, [sp, #0xc]
	str r5, [sp]
	str r3, [sp, #4]
	str r4, [sp, #8]
	mov r2, #0x19
	add r1, sp, #0
	strb r2, [r1, #0x10]
	mov r2, #0xa
	strb r2, [r1, #0x11]
	ldrb r4, [r1, #0x12]
	mov r2, #0xf
	add r7, r0, #0
	bic r4, r2
	strb r4, [r1, #0x12]
	ldrb r2, [r1, #0x12]
	mov r4, #0xf0
	bic r2, r4
	lsl r4, r6, #0x18
	lsr r4, r4, #0x18
	lsl r4, r4, #0x1c
	lsr r4, r4, #0x18
	orr r2, r4
	strb r2, [r1, #0x12]
	strb r3, [r1, #0x13]
	add r1, sp, #0
	bl YesNoPrompt_InitFromTemplate
	add r0, r7, #0
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov75_02247890

	thumb_func_start ov75_022478E0
ov75_022478E0: ; 0x022478E0
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	add r5, r0, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _022478F4
	cmp r0, #1
	beq _022479C0
	b _02247A1C
_022478F4:
	ldr r0, [r5]
	ldr r0, [r0, #4]
	bl sub_02031744
	cmp r0, #1
	bne _0224790A
	ldr r3, _02247A5C ; =ov75_02249974
	ldr r4, _02247A60 ; =ov75_022499BC
	mov r7, #4
	ldr r2, _02247A64 ; =ov75_022499DC
	b _02247912
_0224790A:
	ldr r3, _02247A68 ; =ov75_02249978
	ldr r4, _02247A6C ; =ov75_0224998C
	ldr r2, _02247A70 ; =ov75_0224999C
	mov r7, #2
_02247912:
	add r6, sp, #0x14
	ldmia r2!, {r0, r1}
	stmia r6!, {r0, r1}
	ldmia r2!, {r0, r1}
	stmia r6!, {r0, r1}
	ldmia r2!, {r0, r1}
	stmia r6!, {r0, r1}
	ldmia r2!, {r0, r1}
	stmia r6!, {r0, r1}
	ldrb r0, [r3, #1]
	add r1, r5, #0
	add r1, #0x78
	str r0, [sp]
	ldrb r0, [r3, #2]
	mov r2, #0
	str r0, [sp, #4]
	ldrb r0, [r3, #3]
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x94
	str r0, [sp, #0x10]
	ldrb r3, [r3]
	ldr r0, [r5, #4]
	bl AddWindowParameterized
	add r0, r7, #0
	mov r1, #0x74
	bl ListMenuItems_New
	add r1, r5, #0
	add r1, #0xa0
	mov r6, #0
	str r0, [r1]
	cmp r7, #0
	ble _02247972
_0224795A:
	add r0, r5, #0
	add r0, #0xa0
	ldr r0, [r0]
	ldr r1, [r5, #0x34]
	ldr r2, [r4]
	ldr r3, [r4, #4]
	bl ListMenuItems_AppendFromMsgData
	add r6, r6, #1
	add r4, #8
	cmp r6, r7
	blt _0224795A
_02247972:
	add r0, r5, #0
	add r0, #0x78
	str r0, [sp, #0x20]
	add r0, r5, #0
	add r0, #0xa0
	ldr r0, [r0]
	mov r1, #0
	str r0, [sp, #0x14]
	add r0, sp, #0x14
	add r2, r1, #0
	mov r3, #0x74
	bl ListMenuInit
	add r1, r5, #0
	add r1, #0xa4
	str r0, [r1]
	add r0, r5, #0
	add r0, #0x78
	mov r1, #1
	mov r2, #0x1f
	mov r3, #0xb
	bl DrawFrameAndWindow1
	add r0, r5, #0
	add r0, #0x48
	mov r1, #1
	bl ClearFrameAndWindow2
	add r0, r5, #0
	add r0, #0x78
	bl CopyWindowToVram
	add r0, r5, #0
	add r0, #0x94
	ldr r0, [r0]
	add r5, #0x94
	add r0, r0, #1
	str r0, [r5]
	b _02247A56
_022479C0:
	add r0, r5, #0
	add r0, #0xa4
	ldr r0, [r0]
	bl ListMenu_ProcessInput
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _022479DC
	add r0, r0, #1
	cmp r4, r0
	beq _02247A56
	b _02247A02
_022479DC:
	ldr r0, _02247A74 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5]
	mov r1, #6
	mov r2, #0
	bl ov75_02246BCC
	add r0, r5, #0
	mov r1, #0x1d
	add r0, #0x9c
	str r1, [r0]
	add r0, r5, #0
	add r0, #0x94
	ldr r0, [r0]
	add r5, #0x94
	add r0, r0, #1
	str r0, [r5]
	b _02247A56
_02247A02:
	ldr r0, _02247A74 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	add r0, #0x9c
	str r4, [r0]
	add r0, r5, #0
	add r0, #0x94
	ldr r0, [r0]
	add r5, #0x94
	add r0, r0, #1
	str r0, [r5]
	b _02247A56
_02247A1C:
	add r0, r5, #0
	add r0, #0xa0
	ldr r0, [r0]
	bl ListMenuItems_Delete
	add r0, r5, #0
	add r0, #0xa4
	mov r1, #0
	ldr r0, [r0]
	add r2, r1, #0
	bl DestroyListMenu
	add r0, r5, #0
	add r0, #0x78
	mov r1, #1
	bl sub_0200E5D4
	add r0, r5, #0
	add r0, #0x78
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	add r0, #0x78
	bl RemoveWindow
	add r0, r5, #0
	add r0, #0x9c
	ldr r0, [r0]
	str r0, [r5, #8]
_02247A56:
	mov r0, #0
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02247A5C: .word ov75_02249974
_02247A60: .word ov75_022499BC
_02247A64: .word ov75_022499DC
_02247A68: .word ov75_02249978
_02247A6C: .word ov75_0224998C
_02247A70: .word ov75_0224999C
_02247A74: .word 0x000005DC
	thumb_func_end ov75_022478E0

	thumb_func_start ov75_02247A78
ov75_02247A78: ; 0x02247A78
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #4
	mov r2, #3
	bl ov75_02246BCC
	ldr r0, [r4]
	mov r1, #0x26
	bl ov75_02246BE0
	mov r0, #0x1d
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02247A78

	thumb_func_start ov75_02247A98
ov75_02247A98: ; 0x02247A98
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02247AAE
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02247AAE:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #3
	bhi _02247B8E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02247AC4: ; jump table
	.short _02247ACC - _02247AC4 - 2 ; case 0
	.short _02247AEA - _02247AC4 - 2 ; case 1
	.short _02247B0A - _02247AC4 - 2 ; case 2
	.short _02247B84 - _02247AC4 - 2 ; case 3
_02247ACC:
	ldr r0, _02247B94 ; =0x00000F0F
	mov r2, #0x19
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02247B8E
_02247AEA:
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #0
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02247B8E
_02247B0A:
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _02247B4C
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	ldr r0, _02247B94 ; =0x00000F0F
	mov r2, #0x1a
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #4]
	mov r2, #1
	bl sub_02031780
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02247B8E
_02247B4C:
	cmp r0, #2
	bne _02247B8E
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	ldr r0, _02247B94 ; =0x00000F0F
	mov r2, #0x1b
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #4]
	add r2, r1, #0
	bl sub_02031780
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02247B8E
_02247B84:
	add r0, r4, #0
	mov r1, #0x19
	mov r2, #0
	bl ov75_02247854
_02247B8E:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02247B94: .word 0x00000F0F
	thumb_func_end ov75_02247A98

	thumb_func_start ov75_02247B98
ov75_02247B98: ; 0x02247B98
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02247BAE
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02247BAE:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #3
	bhi _02247C66
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02247BC4: ; jump table
	.short _02247BCC - _02247BC4 - 2 ; case 0
	.short _02247BEA - _02247BC4 - 2 ; case 1
	.short _02247C0A - _02247BC4 - 2 ; case 2
	.short _02247C5C - _02247BC4 - 2 ; case 3
_02247BCC:
	ldr r0, _02247C6C ; =0x00000F0F
	mov r2, #0x1c
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02247C66
_02247BEA:
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #1
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02247C66
_02247C0A:
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _02247C48
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	ldr r0, _02247C6C ; =0x00000F0F
	mov r2, #0x1d
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	ldr r0, [r4]
	ldr r0, [r0, #4]
	bl sub_02031734
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02247C66
_02247C48:
	cmp r0, #2
	bne _02247C66
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	mov r0, #0
	str r0, [r4, #8]
	b _02247C66
_02247C5C:
	add r0, r4, #0
	mov r1, #0x19
	mov r2, #0
	bl ov75_02247854
_02247C66:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02247C6C: .word 0x00000F0F
	thumb_func_end ov75_02247B98

	thumb_func_start ov75_02247C70
ov75_02247C70: ; 0x02247C70
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	add r0, #0xd4
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r0, [r4, #0x34]
	mov r1, #0x2a
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r3, _02247D00 ; =_02249B20
	mov r1, #0
	ldr r0, [r3, #4]
	add r2, r5, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	str r1, [sp, #8]
	ldr r3, [r3]
	add r0, r4, #0
	add r0, #0xd4
	add r3, #0xc
	bl AddTextPrinterParameterized
	add r0, r5, #0
	bl String_Delete
	ldr r0, [r4, #0x34]
	mov r1, #0x2b
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r3, _02247D00 ; =_02249B20
	mov r1, #0
	ldr r0, [r3, #0xc]
	add r2, r5, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	str r1, [sp, #8]
	ldr r3, [r3, #8]
	add r0, r4, #0
	add r0, #0xd4
	add r3, #0xc
	bl AddTextPrinterParameterized
	add r0, r5, #0
	bl String_Delete
	add r0, r4, #0
	add r0, #0xb0
	ldr r0, [r0]
	add r1, r4, #0
	lsl r3, r0, #3
	add r0, r4, #0
	ldr r2, _02247D04 ; =_02249B20
	add r0, #0xe4
	ldr r5, _02247D08 ; =ov75_02249B24
	ldr r2, [r2, r3]
	ldr r0, [r0]
	ldr r3, [r5, r3]
	add r1, #0xd4
	bl ListMenuUpdateCursorObj
	add r4, #0xd4
	add r0, r4, #0
	bl CopyWindowToVram
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_02247D00: .word _02249B20
_02247D04: .word _02249B20
_02247D08: .word ov75_02249B24
	thumb_func_end ov75_02247C70

	thumb_func_start ov75_02247D0C
ov75_02247D0C: ; 0x02247D0C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xd4
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r4, #0xd4
	add r0, r4, #0
	bl CopyWindowToVram
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02247D0C

	thumb_func_start ov75_02247D24
ov75_02247D24: ; 0x02247D24
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r0, #0xbc
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r4, #0
	add r0, #0xbc
	str r1, [r0]
	add r0, r4, #0
	add r0, #0xbc
	ldr r0, [r0]
	cmp r0, #8
	beq _02247D42
	b _02248030
_02247D42:
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	mov r1, #1
	add r2, r0, #0
	add r0, r4, #0
	eor r2, r1
	add r0, #0xc0
	str r2, [r0]
	add r0, r4, #0
	mov r2, #0
	add r0, #0xbc
	str r2, [r0]
	add r0, r4, #0
	add r0, #0xac
	ldr r0, [r0]
	add r3, r0, #6
	add r0, r4, #0
	add r0, #0xb4
	ldr r0, [r0]
	cmp r3, r0
	bne _02247D70
	b _02247EAE
_02247D70:
	mov r0, #0x11
	str r0, [sp]
	str r1, [sp, #4]
	str r1, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, r2, #1
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0xe
	bl FillBgTilemapRect
	mov r0, #0x11
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, r2, #2
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0xf
	bl FillBgTilemapRect
	mov r0, #0x11
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, r2, #3
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0x10
	bl FillBgTilemapRect
	mov r3, #0x11
	add r2, r4, #0
	str r3, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r5, [r2]
	mov r2, #0x14
	mul r2, r5
	add r2, r2, #4
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	bl FillBgTilemapRect
	mov r0, #0x12
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0xb
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0xe
	bl FillBgTilemapRect
	mov r0, #0x12
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0xc
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0xf
	bl FillBgTilemapRect
	mov r0, #0x12
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0xd
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0x10
	bl FillBgTilemapRect
	mov r0, #0x12
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0xe
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0x11
	bl FillBgTilemapRect
	b _02247EC8
_02247EAE:
	mov r0, #0x11
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #9
	str r0, [sp, #0xc]
	ldr r0, [r4, #4]
	mov r1, #3
	mov r3, #0xe
	bl FillBgTilemapRect
_02247EC8:
	add r0, r4, #0
	add r0, #0xac
	ldr r0, [r0]
	cmp r0, #0
	bne _02247ED4
	b _0224800E
_02247ED4:
	mov r1, #3
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, r2, #5
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	lsr r2, r2, #0x10
	mov r3, #0xe
	bl FillBgTilemapRect
	mov r1, #3
	add r2, r4, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, r2, #6
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	lsr r2, r2, #0x10
	mov r3, #0xf
	bl FillBgTilemapRect
	mov r1, #3
	add r2, r4, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, r2, #7
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	lsr r2, r2, #0x10
	mov r3, #0x10
	bl FillBgTilemapRect
	mov r1, #3
	add r2, r4, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #8
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	lsr r2, r2, #0x10
	mov r3, #0x11
	bl FillBgTilemapRect
	mov r0, #4
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0xf
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0xe
	bl FillBgTilemapRect
	mov r0, #4
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0xf
	bl FillBgTilemapRect
	mov r0, #4
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0x11
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0x10
	bl FillBgTilemapRect
	mov r0, #4
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #9
	add r2, r4, #0
	str r0, [sp, #0xc]
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x14
	mul r2, r3
	add r2, #0x12
	lsl r2, r2, #0x10
	ldr r0, [r4, #4]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0x11
	bl FillBgTilemapRect
	b _02248028
_0224800E:
	mov r1, #3
	str r1, [sp]
	mov r0, #4
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #9
	str r0, [sp, #0xc]
	ldr r0, [r4, #4]
	mov r2, #0
	mov r3, #0xe
	bl FillBgTilemapRect
_02248028:
	ldr r0, [r4, #4]
	mov r1, #3
	bl ScheduleBgTilemapBufferTransfer
_02248030:
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov75_02247D24

	thumb_func_start ov75_02248034
ov75_02248034: ; 0x02248034
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r0, #0
	add r0, #0xc4
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r0, [r7, #0x34]
	mov r1, #0x2c
	bl NewString_ReadMsgData
	str r0, [sp, #0xc]
	bl String_GetLength
	mov r1, #0x74
	bl String_New
	add r6, r0, #0
	add r0, r7, #0
	add r0, #0xac
	ldr r4, [r0]
	add r0, r4, #6
	cmp r4, r0
	bge _0224809E
	add r0, r7, #0
	str r0, [sp, #0x10]
	add r0, #0xc4
	mov r5, #0
	str r0, [sp, #0x10]
_0224806E:
	ldr r1, [sp, #0xc]
	add r0, r6, #0
	add r2, r4, #0
	bl String_GetLineN
	str r5, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	ldr r0, [sp, #0x10]
	mov r1, #0
	add r2, r6, #0
	mov r3, #4
	bl AddTextPrinterParameterized
	add r0, r7, #0
	add r0, #0xac
	ldr r0, [r0]
	add r4, r4, #1
	add r0, r0, #6
	add r5, #0x10
	cmp r4, r0
	blt _0224806E
_0224809E:
	ldr r0, [sp, #0xc]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	add r7, #0xc4
	add r0, r7, #0
	bl CopyWindowToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov75_02248034

	thumb_func_start ov75_022480B8
ov75_022480B8: ; 0x022480B8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0xa8
	ldr r1, [r1]
	cmp r1, #0
	beq _022480D6
	cmp r1, #1
	bne _022480CE
	b _02248220
_022480CE:
	cmp r1, #2
	bne _022480D4
	b _022482CE
_022480D4:
	b _0224837C
_022480D6:
	ldr r0, [r5, #0x34]
	mov r1, #0x2c
	bl NewString_ReadMsgData
	str r0, [sp, #0x14]
	bl String_CountLines
	add r1, r5, #0
	mov r2, #0
	add r1, #0xac
	str r2, [r1]
	add r1, r5, #0
	add r1, #0xb0
	str r2, [r1]
	add r1, r5, #0
	add r1, #0xb8
	str r2, [r1]
	add r1, r5, #0
	add r1, #0xb4
	str r0, [r1]
	mov r0, #5
	str r0, [sp]
	mov r0, #0x1e
	str r0, [sp, #4]
	mov r0, #0xc
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x94
	str r0, [sp, #0x10]
	add r1, r5, #0
	ldr r0, [r5, #4]
	add r1, #0xc4
	mov r2, #2
	mov r3, #1
	bl AddWindowParameterized
	mov r0, #0x13
	str r0, [sp]
	mov r0, #0x1e
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x7f
	lsl r0, r0, #2
	str r0, [sp, #0x10]
	add r1, r5, #0
	ldr r0, [r5, #4]
	add r1, #0xd4
	mov r2, #2
	mov r3, #1
	bl AddWindowParameterized
	add r0, r5, #0
	add r0, #0xc4
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	bl String_GetLength
	mov r1, #0x74
	bl String_New
	add r7, r0, #0
	add r0, r5, #0
	mov r6, #0
	str r0, [sp, #0x18]
	add r0, #0xc4
	add r4, r6, #0
	str r0, [sp, #0x18]
_02248168:
	ldr r1, [sp, #0x14]
	add r0, r7, #0
	add r2, r6, #0
	bl String_GetLineN
	str r4, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	ldr r0, [sp, #0x18]
	mov r1, #0
	add r2, r7, #0
	mov r3, #4
	bl AddTextPrinterParameterized
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #6
	blt _02248168
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	add r0, r5, #0
	add r0, #0xc4
	mov r1, #1
	mov r2, #0x1f
	mov r3, #0xb
	bl DrawFrameAndWindow1
	add r0, r5, #0
	add r0, #0xc4
	bl CopyWindowToVram
	add r0, r5, #0
	add r0, #0xd4
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0xd4
	mov r1, #1
	mov r2, #0x1f
	mov r3, #0xb
	bl DrawFrameAndWindow1
	add r0, r5, #0
	add r0, #0xd4
	bl CopyWindowToVram
	mov r0, #0x74
	bl ListMenuCursorNew
	add r1, r5, #0
	add r1, #0xe4
	str r0, [r1]
	add r0, r5, #0
	add r0, #0x48
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x48
	mov r1, #1
	bl ClearFrameAndWindow2
	add r0, r5, #0
	add r0, #0x48
	bl ClearWindowTilemapAndCopyToVram
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	mov r1, #0
	add r0, #0xbc
	str r1, [r0]
	add r0, r5, #0
	add r0, #0xc0
	str r1, [r0]
	add r0, r5, #0
	add r0, #0xa8
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r5, #0
	add r0, #0xa8
	str r1, [r0]
	b _022483D8
_02248220:
	ldr r1, _022483E4 ; =gSystem
	add r0, #0xac
	ldr r2, [r1, #0x4c]
	ldr r4, [r0]
	mov r0, #0x40
	tst r0, r2
	beq _02248248
	cmp r4, #0
	beq _022482BA
	add r0, r5, #0
	add r0, #0xac
	ldr r0, [r0]
	sub r1, r0, #1
	add r0, r5, #0
	add r0, #0xac
	str r1, [r0]
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
	b _022482BA
_02248248:
	mov r0, #0x80
	tst r0, r2
	beq _0224829C
	add r0, r5, #0
	add r0, #0xb4
	ldr r0, [r0]
	add r1, r4, #6
	cmp r1, r0
	bge _0224826E
	add r0, r5, #0
	add r0, #0xac
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r5, #0
	add r0, #0xac
	str r1, [r0]
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
_0224826E:
	add r0, r5, #0
	add r0, #0xac
	ldr r0, [r0]
	add r1, r0, #6
	add r0, r5, #0
	add r0, #0xb4
	ldr r0, [r0]
	cmp r1, r0
	bne _022482BA
	add r0, r5, #0
	bl ov75_02247C70
	add r0, r5, #0
	add r0, #0xa8
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r5, #0
	add r0, #0xa8
	str r1, [r0]
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
	b _022482BA
_0224829C:
	ldr r1, [r1, #0x48]
	mov r0, #2
	tst r0, r1
	beq _022482BA
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	mov r1, #2
	add r0, #0xb8
	str r1, [r0]
	add r0, r5, #0
	mov r1, #0xff
	add r0, #0xa8
	str r1, [r0]
_022482BA:
	add r0, r5, #0
	add r0, #0xac
	ldr r0, [r0]
	cmp r4, r0
	bne _022482C6
	b _022483D8
_022482C6:
	add r0, r5, #0
	bl ov75_02248034
	b _022483D8
_022482CE:
	ldr r1, _022483E4 ; =gSystem
	mov r2, #0x10
	ldr r1, [r1, #0x48]
	tst r2, r1
	bne _022482DE
	mov r2, #0x20
	tst r2, r1
	beq _022482FC
_022482DE:
	add r0, r5, #0
	add r0, #0xb0
	ldr r1, [r0]
	mov r0, #1
	eor r1, r0
	add r0, r5, #0
	add r0, #0xb0
	str r1, [r0]
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	bl ov75_02247C70
	b _022483D8
_022482FC:
	mov r2, #1
	tst r2, r1
	beq _02248326
	add r0, #0xb0
	ldr r1, [r0]
	mov r0, #2
	sub r1, r0, r1
	add r0, r5, #0
	add r0, #0xb8
	str r1, [r0]
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	add r0, #0xa8
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r5, #0
	add r0, #0xa8
	str r1, [r0]
	b _022483D8
_02248326:
	mov r2, #2
	add r3, r1, #0
	tst r3, r2
	beq _02248348
	add r0, #0xb8
	str r2, [r0]
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	add r0, #0xa8
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r5, #0
	add r0, #0xa8
	str r1, [r0]
	b _022483D8
_02248348:
	mov r2, #0x40
	tst r1, r2
	beq _022483D8
	bl ov75_02247D0C
	ldr r0, _022483E8 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	add r0, #0xa8
	ldr r0, [r0]
	sub r1, r0, #1
	add r0, r5, #0
	add r0, #0xa8
	str r1, [r0]
	add r0, r5, #0
	add r0, #0xac
	ldr r0, [r0]
	sub r1, r0, #1
	add r0, r5, #0
	add r0, #0xac
	str r1, [r0]
	add r0, r5, #0
	bl ov75_02248034
	b _022483D8
_0224837C:
	add r0, #0xc4
	mov r1, #0
	bl sub_0200E5D4
	add r0, r5, #0
	add r0, #0xc4
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	add r0, #0xc4
	bl RemoveWindow
	add r0, r5, #0
	add r0, #0xd4
	mov r1, #0
	bl sub_0200E5D4
	add r0, r5, #0
	add r0, #0xd4
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	add r0, #0xd4
	bl RemoveWindow
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	bl DestroyListMenuCursorObj
	ldr r0, [r5, #4]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	mov r1, #0
	add r0, #0xa8
	str r1, [r0]
	add r5, #0xb8
	add sp, #0x1c
	ldr r0, [r5]
	pop {r4, r5, r6, r7, pc}
_022483D8:
	add r0, r5, #0
	bl ov75_02247D24
	mov r0, #0
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_022483E4: .word gSystem
_022483E8: .word 0x000005DC
	thumb_func_end ov75_022480B8

	thumb_func_start ov75_022483EC
ov75_022483EC: ; 0x022483EC
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02248402
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02248402:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #4
	bhi _022484DC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248418: ; jump table
	.short _02248422 - _02248418 - 2 ; case 0
	.short _0224842A - _02248418 - 2 ; case 1
	.short _02248438 - _02248418 - 2 ; case 2
	.short _02248484 - _02248418 - 2 ; case 3
	.short _022484BC - _02248418 - 2 ; case 4
_02248422:
	mov r0, #3
	add r4, #0x94
	str r0, [r4]
	b _02248522
_0224842A:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248522
_02248438:
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _02248468
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	ldr r0, _02248528 ; =0x00000F0F
	mov r2, #9
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	mov r0, #4
	add r4, #0x94
	str r0, [r4]
	b _02248522
_02248468:
	cmp r0, #2
	bne _02248522
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248522
_02248484:
	add r0, r4, #0
	bl ov75_022480B8
	cmp r0, #1
	bne _022484AC
	ldr r0, _02248528 ; =0x00000F0F
	mov r2, #9
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248522
_022484AC:
	cmp r0, #2
	bne _02248522
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0
	bl ov75_02247854
	b _02248522
_022484BC:
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #0
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248522
_022484DC:
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _022484FA
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	mov r0, #5
	str r0, [r4, #8]
	b _02248522
_022484FA:
	cmp r0, #2
	bne _02248522
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	ldr r0, _02248528 ; =0x00000F0F
	mov r2, #0xa
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0
	bl ov75_02247854
_02248522:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02248528: .word 0x00000F0F
	thumb_func_end ov75_022483EC

	thumb_func_start ov75_0224852C
ov75_0224852C: ; 0x0224852C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #1
	mov r2, #0
	bl ov75_02246BCC
	ldr r0, [r4]
	mov r1, #6
	bl ov75_02246BE0
	mov r0, #0x1d
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_0224852C

	thumb_func_start ov75_0224854C
ov75_0224854C: ; 0x0224854C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	bl ov75_02246CF8
	cmp r0, #1
	beq _02248564
	cmp r0, #2
	beq _0224856A
	cmp r0, #3
	beq _0224856A
	b _02248572
_02248564:
	mov r0, #0
	str r0, [r4, #8]
	pop {r4, pc}
_0224856A:
	mov r0, #0x25
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
_02248572:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	bne _02248580
	mov r0, #7
	str r0, [r4, #8]
_02248580:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov75_0224854C

	thumb_func_start ov75_02248584
ov75_02248584: ; 0x02248584
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _0224859A
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_0224859A:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #4
	bhi _02248678
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022485B0: ; jump table
	.short _022485BA - _022485B0 - 2 ; case 0
	.short _022485C8 - _022485B0 - 2 ; case 1
	.short _022485E6 - _022485B0 - 2 ; case 2
	.short _02248606 - _022485B0 - 2 ; case 3
	.short _02248646 - _022485B0 - 2 ; case 4
_022485BA:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248678
_022485C8:
	ldr r0, _02248680 ; =0x00000F0F
	mov r2, #0xb
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248678
_022485E6:
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #0
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248678
_02248606:
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _0224862C
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248678
_0224862C:
	cmp r0, #2
	bne _02248678
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0
	bl ov75_02247854
	b _02248678
_02248646:
	ldr r0, [r4]
	ldr r0, [r0, #4]
	bl sub_0203A05C
	cmp r0, #0
	bne _0224866E
	ldr r0, [r4]
	mov r1, #5
	mov r2, #0
	bl ov75_02246BCC
	ldr r0, [r4]
	mov r1, #0xc
	bl ov75_02246BE0
	mov r0, #0x1d
	str r0, [r4, #8]
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_0224866E:
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0xc
	bl ov75_02247854
_02248678:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	nop
_02248680: .word 0x00000F0F
	thumb_func_end ov75_02248584

	thumb_func_start ov75_02248684
ov75_02248684: ; 0x02248684
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _022486C2
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	ldr r0, _022486E8 ; =0x00000F0F
	mov r2, #1
	str r0, [sp]
	ldr r1, [r4, #0x2c]
	add r0, r4, #0
	add r3, r2, #0
	bl ov75_022494CC
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0xc
	bl ov75_02247854
	add r0, r4, #0
	bl ov75_0224785C
	b _022486E2
_022486C2:
	cmp r0, #2
	bne _022486E2
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	bl sub_0203957C
	ldr r0, [r4]
	mov r1, #6
	mov r2, #0
	bl ov75_02246BCC
	mov r0, #0x1d
	str r0, [r4, #8]
_022486E2:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022486E8: .word 0x00000F0F
	thumb_func_end ov75_02248684

	thumb_func_start ov75_022486EC
ov75_022486EC: ; 0x022486EC
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _02248710 ; =0x00000F0F
	add r4, r0, #0
	str r1, [sp]
	ldr r1, [r4, #0x30]
	mov r2, #0x1a
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0xa
	bl ov75_02247854
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02248710: .word 0x00000F0F
	thumb_func_end ov75_022486EC

	thumb_func_start ov75_02248714
ov75_02248714: ; 0x02248714
	push {r4, lr}
	add r4, r0, #0
	bl sub_0203957C
	bl ov00_021EC8D8
	bl sub_0203A914
	mov r0, #4
	bl Sys_ClearSleepDisableFlag
	mov r0, #0x46
	ldr r1, [r4]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r0, #1
	bne _02248744
	bl ov70_02237F2C
	mov r0, #0x46
	ldr r1, [r4]
	mov r2, #0
	lsl r0, r0, #2
	str r2, [r1, r0]
_02248744:
	mov r0, #0xb
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov75_02248714

	thumb_func_start ov75_0224874C
ov75_0224874C: ; 0x0224874C
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _02248770 ; =0x00000F0F
	add r4, r0, #0
	str r1, [sp]
	ldr r1, [r4, #0x30]
	mov r2, #0x1b
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	mov r1, #0x23
	mov r2, #0x1d
	bl ov75_02247854
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02248770: .word 0x00000F0F
	thumb_func_end ov75_0224874C

	thumb_func_start ov75_02248774
ov75_02248774: ; 0x02248774
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _0224878C
	cmp r0, #1
	beq _022487BC
	cmp r0, #2
	beq _022487D4
	b _022487F6
_0224878C:
	ldr r0, [r4]
	ldr r0, [r0, #4]
	bl sub_02039528
	bl sub_0203A880
	ldr r0, _022487FC ; =0x00000F0F
	mov r2, #1
	str r0, [sp]
	ldr r1, [r4, #0x2c]
	add r0, r4, #0
	add r3, r2, #0
	bl ov75_022494CC
	add r0, r4, #0
	bl ov75_0224785C
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022487F6
_022487BC:
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _022487F6
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022487F6
_022487D4:
	mov r0, #4
	bl Sys_SetSleepDisableFlag
	ldr r0, [r4]
	mov r1, #2
	add r0, #0x14
	mov r2, #1
	mov r3, #0x14
	bl ov00_021EC3F0
	mov r0, #2
	bl ov00_021EC454
	bl ov00_021EC4A4
	mov r0, #0xd
	str r0, [r4, #8]
_022487F6:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022487FC: .word 0x00000F0F
	thumb_func_end ov75_02248774

	thumb_func_start ov75_02248800
ov75_02248800: ; 0x02248800
	push {r4, lr}
	sub sp, #0x48
	add r4, r0, #0
	bl ov00_021EC60C
	bl ov00_021EC5B4
	cmp r0, #0
	beq _022488A6
	bl ov00_021EC724
	cmp r0, #8
	bhi _02248886
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248826: ; jump table
	.short _02248886 - _02248826 - 2 ; case 0
	.short _02248886 - _02248826 - 2 ; case 1
	.short _02248886 - _02248826 - 2 ; case 2
	.short _02248886 - _02248826 - 2 ; case 3
	.short _0224889C - _02248826 - 2 ; case 4
	.short _02248886 - _02248826 - 2 ; case 5
	.short _02248886 - _02248826 - 2 ; case 6
	.short _02248838 - _02248826 - 2 ; case 7
	.short _02248886 - _02248826 - 2 ; case 8
_02248838:
	add r0, sp, #8
	add r1, sp, #4
	bl ov00_021EC11C
	str r0, [r4, #0x14]
	ldr r0, [sp, #8]
	str r0, [r4, #0x18]
	ldr r0, [sp, #4]
	str r0, [r4, #0x1c]
	bl ov00_021EC210
	bl ov00_021EC8D8
	bl sub_0203A914
	bl sub_0203957C
	mov r0, #4
	bl Sys_ClearSleepDisableFlag
	mov r0, #0x46
	ldr r1, [r4]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r0, #1
	bne _0224887A
	bl ov70_02237F2C
	mov r0, #0x46
	ldr r1, [r4]
	mov r2, #0
	lsl r0, r0, #2
	str r2, [r1, r0]
_0224887A:
	add r0, r4, #0
	bl ov75_02247878
	mov r0, #0x1b
	str r0, [r4, #8]
	b _022488A6
_02248886:
	add r0, sp, #0
	bl ov00_021EC0FC
	add r0, r4, #0
	bl ov75_02247878
	mov r0, #0x20
	str r0, [r4, #8]
	sub r0, #0x22
	str r0, [r4, #0x10]
	b _022488A6
_0224889C:
	add r0, sp, #0xc
	bl ov00_021EC9E0
	mov r0, #0xe
	str r0, [r4, #8]
_022488A6:
	mov r0, #0
	add sp, #0x48
	pop {r4, pc}
	thumb_func_end ov75_02248800

	thumb_func_start ov75_022488AC
ov75_022488AC: ; 0x022488AC
	push {r4, lr}
	add r4, r0, #0
	bl ov00_021ECD04
	mov r0, #0xf
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov75_022488AC

	thumb_func_start ov75_022488BC
ov75_022488BC: ; 0x022488BC
	push {r4, lr}
	sub sp, #8
	add r4, r0, #0
	bl ov00_021ECDC8
	cmp r0, #5
	bhi _02248984
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022488D6: ; jump table
	.short _022488E8 - _022488D6 - 2 ; case 0
	.short _02248984 - _022488D6 - 2 ; case 1
	.short _02248984 - _022488D6 - 2 ; case 2
	.short _022488E2 - _022488D6 - 2 ; case 3
	.short _022488E8 - _022488D6 - 2 ; case 4
	.short _022488E8 - _022488D6 - 2 ; case 5
_022488E2:
	mov r0, #0x10
	str r0, [r4, #8]
	b _02248984
_022488E8:
	add r0, r4, #0
	bl ov75_02247878
	add r0, sp, #4
	add r1, sp, #0
	bl ov00_021EC11C
	str r0, [r4, #0x14]
	ldr r0, [sp, #4]
	str r0, [r4, #0x18]
	bl ov00_021EC210
	bl ov00_021EC8D8
	bl sub_0203A914
	bl sub_0203957C
	mov r0, #4
	bl Sys_ClearSleepDisableFlag
	mov r0, #0x46
	ldr r1, [r4]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r0, #1
	bne _0224892C
	bl ov70_02237F2C
	mov r0, #0x46
	ldr r1, [r4]
	mov r2, #0
	lsl r0, r0, #2
	str r2, [r1, r0]
_0224892C:
	mov r0, #0x1b
	str r0, [r4, #8]
	ldr r1, [sp]
	cmp r1, #7
	bhi _02248972
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02248942: ; jump table
	.short _02248972 - _02248942 - 2 ; case 0
	.short _02248952 - _02248942 - 2 ; case 1
	.short _02248952 - _02248942 - 2 ; case 2
	.short _02248964 - _02248942 - 2 ; case 3
	.short _02248956 - _02248942 - 2 ; case 4
	.short _0224896E - _02248942 - 2 ; case 5
	.short _02248960 - _02248942 - 2 ; case 6
	.short _0224896E - _02248942 - 2 ; case 7
_02248952:
	str r0, [r4, #8]
	b _02248972
_02248956:
	bl ov00_021FA0D8
	mov r0, #0x1b
	str r0, [r4, #8]
	b _02248972
_02248960:
	str r0, [r4, #8]
	b _02248972
_02248964:
	bl ov00_021ED9B4
	mov r0, #0x1b
	str r0, [r4, #8]
	b _02248972
_0224896E:
	bl sub_020399EC
_02248972:
	ldr r1, [sp, #4]
	ldr r0, _0224898C ; =0xFFFFB1E0
	cmp r1, r0
	bge _02248984
	ldr r0, _02248990 ; =0xFFFF8AD1
	cmp r1, r0
	blt _02248984
	mov r0, #0x1b
	str r0, [r4, #8]
_02248984:
	mov r0, #0
	add sp, #8
	pop {r4, pc}
	nop
_0224898C: .word 0xFFFFB1E0
_02248990: .word 0xFFFF8AD1
	thumb_func_end ov75_022488BC

	thumb_func_start ov75_02248994
ov75_02248994: ; 0x02248994
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #4]
	bl sub_0202C6F4
	add r6, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #4]
	bl Save_SysInfo_Get
	add r4, r0, #0
	add r0, r6, #0
	bl sub_0202C08C
	add r7, r0, #0
	add r0, r4, #0
	bl Save_SysInfo_GetDwcProfileId
	cmp r0, #0
	bne _022489CC
	add r0, r6, #0
	bl sub_0203A040
	add r1, r0, #0
	add r0, r4, #0
	bl Save_SysInfo_SetDwcProfileId
_022489CC:
	add r0, r4, #0
	bl Save_SysInfo_GetDwcProfileId
	add r4, r0, #0
	add r0, r7, #0
	bl DWC_CreateFriendKey
	add r3, r0, #0
	add r2, r1, #0
	add r0, r4, #0
	add r1, r3, #0
	bl ov70_022378C0
	mov r0, #0x46
	ldr r1, [r5]
	mov r2, #1
	lsl r0, r0, #2
	str r2, [r1, r0]
	mov r0, #0x11
	str r0, [r5, #8]
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov75_02248994

	thumb_func_start ov75_022489F8
ov75_022489F8: ; 0x022489F8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	bl ov75_02246CA0
	ldr r0, [r4]
	bl ov75_02246CB8
	ldr r1, [r4]
	add r0, r1, #0
	add r0, #0x98
	add r1, #0xfc
	bl ov70_02238304
	mov r0, #0x12
	str r0, [r4, #8]
	mov r0, #0
	add r4, #0xe8
	str r0, [r4]
	pop {r4, pc}
	thumb_func_end ov75_022489F8

	thumb_func_start ov75_02248A20
ov75_02248A20: ; 0x02248A20
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov70_02237F38
	cmp r0, #0
	bne _02248A2E
	b _02248B56
_02248A2E:
	bl ov70_02237F58
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #0
	add r0, #0xe8
	str r1, [r0]
	add r0, r5, #0
	add r0, #0xf
	cmp r0, #0x11
	bls _02248A46
	b _02248B4A
_02248A46:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248A52: ; jump table
	.short _02248B2E - _02248A52 - 2 ; case 0
	.short _02248B3C - _02248A52 - 2 ; case 1
	.short _02248B4A - _02248A52 - 2 ; case 2
	.short _02248B2E - _02248A52 - 2 ; case 3
	.short _02248B4A - _02248A52 - 2 ; case 4
	.short _02248B4A - _02248A52 - 2 ; case 5
	.short _02248B4A - _02248A52 - 2 ; case 6
	.short _02248B4A - _02248A52 - 2 ; case 7
	.short _02248B4A - _02248A52 - 2 ; case 8
	.short _02248B4A - _02248A52 - 2 ; case 9
	.short _02248B4A - _02248A52 - 2 ; case 10
	.short _02248B4A - _02248A52 - 2 ; case 11
	.short _02248B4A - _02248A52 - 2 ; case 12
	.short _02248B3C - _02248A52 - 2 ; case 13
	.short _02248B20 - _02248A52 - 2 ; case 14
	.short _02248A76 - _02248A52 - 2 ; case 15
	.short _02248B12 - _02248A52 - 2 ; case 16
	.short _02248B20 - _02248A52 - 2 ; case 17
_02248A76:
	ldr r1, [r4]
	add r0, r1, #0
	add r0, #0xfc
	ldr r0, [r0]
	cmp r0, #0
	beq _02248A8C
	cmp r0, #1
	beq _02248AE6
	cmp r0, #2
	beq _02248AF6
	b _02248B06
_02248A8C:
	mov r0, #1
	lsl r0, r0, #8
	ldr r0, [r1, r0]
	cmp r0, #3
	bhi _02248AE0
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248AA2: ; jump table
	.short _02248AC0 - _02248AA2 - 2 ; case 0
	.short _02248AAA - _02248AA2 - 2 ; case 1
	.short _02248AB0 - _02248AA2 - 2 ; case 2
	.short _02248AD0 - _02248AA2 - 2 ; case 3
_02248AAA:
	mov r0, #0x13
	str r0, [r4, #8]
	b _02248B74
_02248AB0:
	add r0, r4, #0
	bl ov75_02247878
	ldr r0, _02248B78 ; =0xFFFFEC77
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248AC0:
	add r0, r4, #0
	bl ov75_02247878
	ldr r0, _02248B7C ; =0xFFFFEC76
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248AD0:
	add r0, r4, #0
	bl ov75_02247878
	ldr r0, _02248B80 ; =0xFFFFEC75
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248AE0:
	bl sub_020399EC
	b _02248B74
_02248AE6:
	add r0, r4, #0
	bl ov75_02247878
	ldr r0, _02248B84 ; =0xFFFFEC74
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248AF6:
	add r0, r4, #0
	bl ov75_02247878
	ldr r0, _02248B88 ; =0xFFFFEC73
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248B06:
	add r0, r4, #0
	bl ov75_02247878
	bl sub_020399EC
	b _02248B74
_02248B12:
	add r0, r4, #0
	bl ov75_02247878
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248B20:
	add r0, r4, #0
	bl ov75_02247878
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248B2E:
	add r0, r4, #0
	bl ov75_02247878
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248B3C:
	add r0, r4, #0
	bl ov75_02247878
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248B74
_02248B4A:
	add r0, r4, #0
	bl ov75_02247878
	bl sub_020399EC
	b _02248B74
_02248B56:
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r4, #0
	add r0, #0xe8
	str r1, [r0]
	add r4, #0xe8
	mov r0, #0xe1
	ldr r1, [r4]
	lsl r0, r0, #4
	cmp r1, r0
	bne _02248B74
	bl sub_020399EC
_02248B74:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02248B78: .word 0xFFFFEC77
_02248B7C: .word 0xFFFFEC76
_02248B80: .word 0xFFFFEC75
_02248B84: .word 0xFFFFEC74
_02248B88: .word 0xFFFFEC73
	thumb_func_end ov75_02248A20

	thumb_func_start ov75_02248B8C
ov75_02248B8C: ; 0x02248B8C
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02248BA2
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02248BA2:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #3
	bhi _02248C58
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248BB8: ; jump table
	.short _02248BC0 - _02248BB8 - 2 ; case 0
	.short _02248BE4 - _02248BB8 - 2 ; case 1
	.short _02248C04 - _02248BB8 - 2 ; case 2
	.short _02248C3E - _02248BB8 - 2 ; case 3
_02248BC0:
	add r0, r4, #0
	bl ov75_02247878
	ldr r0, _02248C60 ; =0x00000F0F
	mov r2, #0xd
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248C58
_02248BE4:
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #0
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248C58
_02248C04:
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _02248C2A
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248C58
_02248C2A:
	cmp r0, #2
	bne _02248C58
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	mov r0, #0x15
	str r0, [r4, #8]
	b _02248C58
_02248C3E:
	ldr r0, _02248C60 ; =0x00000F0F
	mov r2, #0x11
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0x14
	bl ov75_02247854
_02248C58:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	nop
_02248C60: .word 0x00000F0F
	thumb_func_end ov75_02248B8C

	thumb_func_start ov75_02248C64
ov75_02248C64: ; 0x02248C64
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #2
	mov r2, #1
	bl ov75_02246BCC
	ldr r0, [r4]
	mov r1, #0x16
	bl ov75_02246BE0
	mov r0, #0x1e
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02248C64

	thumb_func_start ov75_02248C84
ov75_02248C84: ; 0x02248C84
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02248C9A
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02248C9A:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _02248CAE
	cmp r0, #1
	beq _02248CCC
	cmp r0, #2
	beq _02248CEC
	b _02248D22
_02248CAE:
	ldr r0, _02248D28 ; =0x00000F0F
	mov r2, #0xe
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248D22
_02248CCC:
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #0
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248D22
_02248CEC:
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	bne _02248D10
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	add r0, r4, #0
	mov r1, #0x1a
	mov r2, #0
	bl ov75_02247854
	b _02248D22
_02248D10:
	cmp r0, #2
	bne _02248D22
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	bl YesNoPrompt_Destroy
	mov r0, #0x13
	str r0, [r4, #8]
_02248D22:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02248D28: .word 0x00000F0F
	thumb_func_end ov75_02248C84

	thumb_func_start ov75_02248D2C
ov75_02248D2C: ; 0x02248D2C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, [r4]
	bl ov75_02246CE0
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _02248D46
	mov r0, #0x15
	str r0, [r4, #8]
	mov r0, #0
	pop {r3, r4, r5, pc}
_02248D46:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #3
	bls _02248D52
	b _02248F00
_02248D52:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248D5E: ; jump table
	.short _02248D66 - _02248D5E - 2 ; case 0
	.short _02248D9C - _02248D5E - 2 ; case 1
	.short _02248ECE - _02248D5E - 2 ; case 2
	.short _02248EEC - _02248D5E - 2 ; case 3
_02248D66:
	ldr r0, _02248F04 ; =0x00000F0F
	mov r2, #0x12
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #0
	bl ov75_022494CC
	add r0, r4, #0
	bl ov75_0224785C
	ldr r0, [r4]
	bl ov75_02246CCC
	ldr r1, [r4]
	add r0, r1, #0
	add r0, #0x98
	add r1, #0xfc
	bl ov70_02238304
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248F00
_02248D9C:
	bl ov70_02237F38
	cmp r0, #0
	bne _02248DA6
	b _02248EAE
_02248DA6:
	bl ov70_02237F58
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #0
	add r0, #0xe8
	str r1, [r0]
	add r0, r4, #0
	bl ov75_02247878
	add r0, r5, #0
	add r0, #0xf
	cmp r0, #0x11
	bhi _02248EA8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248DCE: ; jump table
	.short _02248E98 - _02248DCE - 2 ; case 0
	.short _02248EA0 - _02248DCE - 2 ; case 1
	.short _02248EA8 - _02248DCE - 2 ; case 2
	.short _02248E98 - _02248DCE - 2 ; case 3
	.short _02248EA8 - _02248DCE - 2 ; case 4
	.short _02248EA8 - _02248DCE - 2 ; case 5
	.short _02248EA8 - _02248DCE - 2 ; case 6
	.short _02248EA8 - _02248DCE - 2 ; case 7
	.short _02248EA8 - _02248DCE - 2 ; case 8
	.short _02248EA8 - _02248DCE - 2 ; case 9
	.short _02248EA8 - _02248DCE - 2 ; case 10
	.short _02248EA8 - _02248DCE - 2 ; case 11
	.short _02248EA8 - _02248DCE - 2 ; case 12
	.short _02248EA0 - _02248DCE - 2 ; case 13
	.short _02248E90 - _02248DCE - 2 ; case 14
	.short _02248DF2 - _02248DCE - 2 ; case 15
	.short _02248E88 - _02248DCE - 2 ; case 16
	.short _02248E90 - _02248DCE - 2 ; case 17
_02248DF2:
	ldr r1, [r4]
	add r0, r1, #0
	add r0, #0xfc
	ldr r0, [r0]
	cmp r0, #0
	beq _02248E08
	cmp r0, #1
	beq _02248E6A
	cmp r0, #2
	beq _02248E74
	b _02248E7E
_02248E08:
	mov r0, #1
	lsl r0, r0, #8
	ldr r0, [r1, r0]
	cmp r0, #3
	bhi _02248E64
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02248E1E: ; jump table
	.short _02248E26 - _02248E1E - 2 ; case 0
	.short _02248E50 - _02248E1E - 2 ; case 1
	.short _02248E5A - _02248E1E - 2 ; case 2
	.short _02248E34 - _02248E1E - 2 ; case 3
_02248E26:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248F00
_02248E34:
	ldr r0, _02248F04 ; =0x00000F0F
	mov r2, #0x13
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0x15
	bl ov75_02247854
	b _02248F00
_02248E50:
	ldr r0, _02248F08 ; =0xFFFFEC72
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248E5A:
	ldr r0, _02248F0C ; =0xFFFFEC71
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248E64:
	bl sub_020399EC
	b _02248F00
_02248E6A:
	ldr r0, _02248F10 ; =0xFFFFEC6E
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248E74:
	ldr r0, _02248F14 ; =0xFFFFEC6D
	str r0, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248E7E:
	bl GF_AssertFail
	bl sub_020399EC
	b _02248F00
_02248E88:
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248E90:
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248E98:
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248EA0:
	str r5, [r4, #0x10]
	mov r0, #0x20
	str r0, [r4, #8]
	b _02248F00
_02248EA8:
	bl sub_020399EC
	b _02248F00
_02248EAE:
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r4, #0
	add r0, #0xe8
	str r1, [r0]
	add r4, #0xe8
	mov r0, #0xe1
	ldr r1, [r4]
	lsl r0, r0, #4
	cmp r1, r0
	bne _02248F00
	bl sub_020399EC
	b _02248F00
_02248ECE:
	ldr r0, _02248F04 ; =0x00000F0F
	mov r2, #0x14
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248F00
_02248EEC:
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _02248F00
	add r0, r4, #0
	mov r1, #0x1a
	mov r2, #0x17
	bl ov75_02247854
_02248F00:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02248F04: .word 0x00000F0F
_02248F08: .word 0xFFFFEC72
_02248F0C: .word 0xFFFFEC71
_02248F10: .word 0xFFFFEC6E
_02248F14: .word 0xFFFFEC6D
	thumb_func_end ov75_02248D2C

	thumb_func_start ov75_02248F18
ov75_02248F18: ; 0x02248F18
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02248F2E
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02248F2E:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _02248F3E
	cmp r0, #1
	beq _02248F5C
	b _02248F72
_02248F3E:
	ldr r0, _02248F78 ; =0x00000F0F
	mov r2, #0x15
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248F72
_02248F5C:
	ldr r0, [r4]
	mov r1, #3
	mov r2, #2
	bl ov75_02246BCC
	ldr r0, [r4]
	mov r1, #0x18
	bl ov75_02246BE0
	mov r0, #0x1e
	str r0, [r4, #8]
_02248F72:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02248F78: .word 0x00000F0F
	thumb_func_end ov75_02248F18

	thumb_func_start ov75_02248F7C
ov75_02248F7C: ; 0x02248F7C
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02248F92
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02248F92:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _02248FA2
	cmp r0, #1
	beq _02248FC0
	b _02248FDC
_02248FA2:
	ldr r0, _02248FE4 ; =0x00000F0F
	mov r2, #0x18
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02248FDC
_02248FC0:
	ldr r0, [r4]
	bl ov75_02246C3C
	ldr r0, [r4]
	bl ov75_02246C68
	ldr r0, [r4]
	bl ov75_02246C8C
	add r0, r4, #0
	mov r1, #0x19
	mov r2, #0
	bl ov75_02247854
_02248FDC:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	nop
_02248FE4: .word 0x00000F0F
	thumb_func_end ov75_02248F7C

	thumb_func_start ov75_02248FE8
ov75_02248FE8: ; 0x02248FE8
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x94
	ldr r1, [r1]
	cmp r1, #3
	bhi _022490CA
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02249004: ; jump table
	.short _0224900C - _02249004 - 2 ; case 0
	.short _0224902E - _02249004 - 2 ; case 1
	.short _02249090 - _02249004 - 2 ; case 2
	.short _022490A8 - _02249004 - 2 ; case 3
_0224900C:
	ldr r1, _022490D0 ; =0x00000F0F
	mov r2, #0x20
	str r1, [sp]
	ldr r1, [r4, #0x34]
	mov r3, #0
	bl ov75_022494CC
	add r0, r4, #0
	bl ov75_0224785C
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022490CA
_0224902E:
	ldr r0, [r4]
	ldr r0, [r0, #4]
	bl SaveGameNormal
	cmp r0, #2
	bne _0224906C
	ldr r0, [r4]
	ldr r0, [r0, #4]
	bl Save_PlayerData_GetProfile
	add r2, r0, #0
	ldr r0, [r4, #0x20]
	mov r1, #0
	bl BufferPlayersName
	ldr r0, _022490D0 ; =0x00000F0F
	mov r2, #0x21
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #0
	bl ov75_022494CC
	ldr r0, _022490D4 ; =0x0000061A
	bl PlaySE
	ldr r0, [r4]
	ldr r0, [r0, #4]
	bl Save_ClearStatusFlags
	b _0224907C
_0224906C:
	ldr r0, _022490D0 ; =0x00000F0F
	mov r2, #0x22
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #0
	bl ov75_022494CC
_0224907C:
	add r0, r4, #0
	bl ov75_02247878
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022490CA
_02249090:
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _022490CA
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022490CA
_022490A8:
	add r0, #0x98
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r4, #0
	add r0, #0x98
	str r1, [r0]
	add r0, r4, #0
	add r0, #0x98
	ldr r0, [r0]
	cmp r0, #0x3c
	ble _022490CA
	add r0, r4, #0
	mov r1, #0
	add r0, #0x98
	str r1, [r0]
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
_022490CA:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022490D0: .word 0x00000F0F
_022490D4: .word 0x0000061A
	thumb_func_end ov75_02248FE8

	thumb_func_start ov75_022490D8
ov75_022490D8: ; 0x022490D8
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _022490EE
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_022490EE:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #4
	bhi _022491C2
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02249104: ; jump table
	.short _0224910E - _02249104 - 2 ; case 0
	.short _0224912C - _02249104 - 2 ; case 1
	.short _02249166 - _02249104 - 2 ; case 2
	.short _0224918E - _02249104 - 2 ; case 3
	.short _022491A6 - _02249104 - 2 ; case 4
_0224910E:
	ldr r0, _022491C8 ; =0x00000F0F
	mov r2, #0xf
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022491C2
_0224912C:
	bl ov00_021EC8D8
	bl sub_0203A914
	bl sub_0203957C
	mov r0, #4
	bl Sys_ClearSleepDisableFlag
	mov r0, #0x46
	ldr r1, [r4]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r0, #1
	bne _02249158
	bl ov70_02237F2C
	mov r0, #0x46
	ldr r1, [r4]
	mov r2, #0
	lsl r0, r0, #2
	str r2, [r1, r0]
_02249158:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022491C2
_02249166:
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _022491C2
	ldr r0, _022491C8 ; =0x00000F0F
	mov r2, #0x10
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022491C2
_0224918E:
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _022491C2
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022491C2
_022491A6:
	add r0, r4, #0
	add r0, #0x90
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r4, #0
	add r0, #0x90
	str r1, [r0]
	add r0, r4, #0
	add r0, #0x90
	ldr r0, [r0]
	cmp r0, #0x1e
	ble _022491C2
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
_022491C2:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022491C8: .word 0x00000F0F
	thumb_func_end ov75_022490D8

	thumb_func_start ov75_022491CC
ov75_022491CC: ; 0x022491CC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	ldr r1, [r4, #0x1c]
	neg r0, r0
	bl ov00_021E6A70
	ldr r2, [r4, #0x18]
	add r1, r0, #0
	add r0, r4, #0
	neg r2, r2
	bl ov75_0224971C
	mov r0, #0x1c
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_022491CC

	thumb_func_start ov75_022491F0
ov75_022491F0: ; 0x022491F0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02249218 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _02249204
	mov r0, #2
	tst r0, r1
	beq _02249212
_02249204:
	add r0, r4, #0
	add r0, #0x68
	mov r1, #0
	bl sub_0200E5D4
	mov r0, #0
	str r0, [r4, #8]
_02249212:
	mov r0, #0
	pop {r4, pc}
	nop
_02249218: .word gSystem
	thumb_func_end ov75_022491F0

	thumb_func_start ov75_0224921C
ov75_0224921C: ; 0x0224921C
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, [r4, #8]
	cmp r0, #0x1e
	beq _0224922C
	bl sub_0203957C
_0224922C:
	bl sub_0203A914
	add r0, r4, #0
	bl ov75_02247878
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x74
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #1
	add sp, #0xc
	pop {r3, r4, pc}
	thumb_func_end ov75_0224921C

	thumb_func_start ov75_02249258
ov75_02249258: ; 0x02249258
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #0
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02249258

	thumb_func_start ov75_02249278
ov75_02249278: ; 0x02249278
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r1, #0
	ldr r0, [r4, #0x10]
	sub r2, r1, #5
	cmp r0, r2
	bgt _022492D6
	bge _0224930A
	add r2, r1, #0
	sub r2, #0xf
	cmp r0, r2
	bgt _022492C4
	add r2, r1, #0
	sub r2, #0xf
	cmp r0, r2
	bge _0224930A
	ldr r2, _02249374 ; =0x00001393
	add r2, r0, r2
	cmp r2, #0xa
	bhi _0224930A
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_022492AE: ; jump table
	.short _0224933E - _022492AE - 2 ; case 0
	.short _02249338 - _022492AE - 2 ; case 1
	.short _0224930A - _022492AE - 2 ; case 2
	.short _0224930A - _022492AE - 2 ; case 3
	.short _02249332 - _022492AE - 2 ; case 4
	.short _0224932C - _022492AE - 2 ; case 5
	.short _02249326 - _022492AE - 2 ; case 6
	.short _02249320 - _022492AE - 2 ; case 7
	.short _0224931A - _022492AE - 2 ; case 8
	.short _02249314 - _022492AE - 2 ; case 9
	.short _0224930E - _022492AE - 2 ; case 10
_022492C4:
	mov r2, #0xd
	mvn r2, r2
	cmp r0, r2
	bgt _022492D0
	beq _02249306
	b _0224930A
_022492D0:
	add r2, r2, #2
	cmp r0, r2
	b _0224930A
_022492D6:
	sub r2, r1, #1
	cmp r0, r2
	bgt _022492F0
	bge _02249302
	sub r2, r1, #3
	cmp r0, r2
	bgt _022492E8
	cmp r0, r2
	b _0224930A
_022492E8:
	sub r2, r1, #2
	cmp r0, r2
	beq _02249306
	b _0224930A
_022492F0:
	cmp r0, #1
	bgt _022492F8
	beq _022492FE
	b _0224930A
_022492F8:
	cmp r0, #2
	beq _02249302
	b _0224930A
_022492FE:
	mov r2, #0x36
	b _02249342
_02249302:
	mov r2, #0x37
	b _02249342
_02249306:
	mov r2, #0x39
	b _02249342
_0224930A:
	mov r2, #0x38
	b _02249342
_0224930E:
	mov r2, #0xb5
	add r1, r1, #1
	b _02249342
_02249314:
	mov r2, #0xb6
	add r1, r1, #1
	b _02249342
_0224931A:
	mov r2, #0xb6
	add r1, r1, #1
	b _02249342
_02249320:
	mov r2, #0xb7
	add r1, r1, #1
	b _02249342
_02249326:
	mov r2, #0xb8
	add r1, r1, #1
	b _02249342
_0224932C:
	mov r2, #0xb6
	add r1, r1, #1
	b _02249342
_02249332:
	mov r2, #0xb6
	add r1, r1, #1
	b _02249342
_02249338:
	mov r2, #0xb7
	add r1, r1, #1
	b _02249342
_0224933E:
	mov r2, #0xb8
	add r1, r1, #1
_02249342:
	cmp r1, #0
	ldr r0, _02249378 ; =0x00000F0F
	bne _02249356
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
	b _02249362
_02249356:
	str r0, [sp]
	ldr r1, [r4, #0x24]
	add r0, r4, #0
	mov r3, #1
	bl ov75_022494CC
_02249362:
	add r0, r4, #0
	mov r1, #0x22
	mov r2, #0x21
	bl ov75_02247854
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	nop
_02249374: .word 0x00001393
_02249378: .word 0x00000F0F
	thumb_func_end ov75_02249278

	thumb_func_start ov75_0224937C
ov75_0224937C: ; 0x0224937C
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x94
	ldr r1, [r1]
	cmp r1, #3
	bhi _02249434
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02249398: ; jump table
	.short _022493A0 - _02249398 - 2 ; case 0
	.short _022493BC - _02249398 - 2 ; case 1
	.short _02249400 - _02249398 - 2 ; case 2
	.short _0224941C - _02249398 - 2 ; case 3
_022493A0:
	ldr r1, _0224945C ; =0x00000F0F
	mov r2, #0xf
	str r1, [sp]
	ldr r1, [r4, #0x34]
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02249456
_022493BC:
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _02249456
	bl sub_0203957C
	bl ov00_021EC8D8
	bl sub_0203A914
	mov r0, #4
	bl Sys_ClearSleepDisableFlag
	mov r0, #0x46
	ldr r1, [r4]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r0, #1
	bne _022493F2
	bl ov70_02237F2C
	mov r0, #0x46
	ldr r1, [r4]
	mov r2, #0
	lsl r0, r0, #2
	str r2, [r1, r0]
_022493F2:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02249456
_02249400:
	ldr r1, _0224945C ; =0x00000F0F
	mov r2, #0x10
	str r1, [sp]
	ldr r1, [r4, #0x34]
	mov r3, #1
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02249456
_0224941C:
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _02249456
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _02249456
_02249434:
	add r0, r4, #0
	add r0, #0x90
	ldr r0, [r0]
	add r1, r0, #1
	add r0, r4, #0
	add r0, #0x90
	str r1, [r0]
	add r0, r4, #0
	add r0, #0x90
	ldr r0, [r0]
	cmp r0, #0x1e
	ble _02249456
	ldr r0, [r4]
	bl ov75_02246BD8
	mov r0, #0x1d
	str r0, [r4, #8]
_02249456:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_0224945C: .word 0x00000F0F
	thumb_func_end ov75_0224937C

	thumb_func_start ov75_02249460
ov75_02249460: ; 0x02249460
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _02249472
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
_02249472:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02249460

	thumb_func_start ov75_02249478
ov75_02249478: ; 0x02249478
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _022494A0
	add r0, r4, #0
	add r0, #0x90
	ldr r0, [r0]
	cmp r0, #0x1e
	ble _02249494
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
_02249494:
	add r0, r4, #0
	add r0, #0x90
	ldr r0, [r0]
	add r4, #0x90
	add r0, r0, #1
	str r0, [r4]
_022494A0:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov75_02249478

	thumb_func_start ov75_022494A4
ov75_022494A4: ; 0x022494A4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #0
	bne _022494C8
	mov r1, #0x8d
	ldr r0, [r4, #4]
	lsl r1, r1, #2
	mov r2, #0
	bl ov75_02247890
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
_022494C8:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov75_022494A4

	thumb_func_start ov75_022494CC
ov75_022494CC: ; 0x022494CC
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	add r1, r2, #0
	add r4, r3, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r0, [r5, #0x20]
	ldr r1, [r5, #0x38]
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	add r0, r5, #0
	add r0, #0x48
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x48
	mov r1, #0
	mov r2, #1
	mov r3, #0xa
	bl DrawFrameAndWindow2
	mov r3, #0
	str r3, [sp]
	str r4, [sp, #4]
	str r3, [sp, #8]
	add r0, r5, #0
	ldr r2, [r5, #0x38]
	add r0, #0x48
	mov r1, #1
	bl AddTextPrinterParameterized
	str r0, [r5, #0x44]
	add r0, r5, #0
	mov r1, #0
	add r0, #0x90
	str r1, [r0]
	cmp r4, #0xff
	beq _0224952C
	cmp r4, #0
	bne _02249530
_0224952C:
	mov r0, #0xff
	str r0, [r5, #0x44]
_02249530:
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov75_022494CC

	thumb_func_start ov75_02249534
ov75_02249534: ; 0x02249534
	push {r3, lr}
	cmp r0, #0xff
	beq _02249546
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _0224954A
_02249546:
	mov r0, #0
	pop {r3, pc}
_0224954A:
	mov r0, #1
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov75_02249534

	thumb_func_start ov75_02249550
ov75_02249550: ; 0x02249550
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	bl ov75_02249534
	cmp r0, #1
	bne _02249566
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_02249566:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _02249576
	cmp r0, #1
	beq _022495A2
	b _022495A6
_02249576:
	ldr r0, [r4]
	bl ov75_02246CF8
	cmp r0, #2
	bne _02249584
	mov r2, #0x26
	b _02249586
_02249584:
	mov r2, #0x27
_02249586:
	ldr r0, _022495AC ; =0x00000F0F
	mov r3, #1
	str r0, [sp]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	bl ov75_022494CC
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	add r4, #0x94
	add r0, r0, #1
	str r0, [r4]
	b _022495A6
_022495A2:
	mov r0, #5
	str r0, [r4, #8]
_022495A6:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022495AC: .word 0x00000F0F
	thumb_func_end ov75_02249550

	thumb_func_start ov75_022495B0
ov75_022495B0: ; 0x022495B0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r6, r0, #0
	ldr r0, [r6, #0x44]
	ldr r4, [r6]
	bl ov75_02249534
	cmp r0, #1
	bne _022495C8
	add sp, #0x18
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_022495C8:
	add r0, r6, #0
	add r0, #0x94
	ldr r0, [r0]
	cmp r0, #0
	beq _022495D8
	cmp r0, #1
	beq _0224963C
	b _02249640
_022495D8:
	add r0, r4, #0
	bl ov75_02246CE8
	add r5, r0, #0
	ldr r0, [r4, #4]
	mov r1, #3
	bl sub_020317BC
	cmp r5, r0
	bne _0224961E
	ldr r0, [r4, #4]
	bl sub_02031774
	add r1, sp, #8
	mov r2, #0x73
	bl ov75_02249884
	mov r4, #0
	add r5, sp, #8
	mov r7, #2
_02249600:
	str r7, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, [r6, #0x20]
	ldr r2, [r5]
	add r1, r4, #0
	mov r3, #4
	bl BufferIntegerAsString
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blo _02249600
	mov r2, #0x29
	b _02249620
_0224961E:
	mov r2, #0x28
_02249620:
	ldr r0, _02249648 ; =0x00000F0F
	mov r3, #1
	str r0, [sp]
	ldr r1, [r6, #0x34]
	add r0, r6, #0
	bl ov75_022494CC
	add r0, r6, #0
	add r0, #0x94
	ldr r0, [r0]
	add r6, #0x94
	add r0, r0, #1
	str r0, [r6]
	b _02249640
_0224963C:
	mov r0, #0
	str r0, [r6, #8]
_02249640:
	mov r0, #0
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02249648: .word 0x00000F0F
	thumb_func_end ov75_022495B0

	thumb_func_start ov75_0224964C
ov75_0224964C: ; 0x0224964C
	push {r4, lr}
	add r4, r0, #0
	cmp r3, #1
	beq _0224965A
	cmp r3, #2
	beq _02249670
	b _0224967E
_0224965A:
	ldr r0, [sp, #0xc]
	mov r2, #0
	bl FontID_String_GetWidth
	ldrb r1, [r4, #7]
	lsl r1, r1, #3
	sub r1, r1, r0
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r2, r0, #1
	b _0224967E
_02249670:
	ldr r0, [sp, #0xc]
	mov r2, #0
	bl FontID_String_GetWidth
	ldrb r1, [r4, #7]
	lsl r1, r1, #3
	sub r2, r1, r0
_0224967E:
	add r0, r2, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_0224964C

	thumb_func_start ov75_02249684
ov75_02249684: ; 0x02249684
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r3, #0
	ldr r3, [sp, #0x24]
	add r5, r0, #0
	str r3, [sp]
	mov r3, #1
	str r3, [sp, #4]
	ldr r3, [sp, #0x20]
	add r6, r1, #0
	bl ov75_0224964C
	add r3, r0, #0
	str r4, [sp]
	mov r1, #0
	ldr r0, [sp, #0x24]
	str r1, [sp, #4]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r0, r5, #0
	mov r1, #1
	add r2, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r4, r5, r6, pc}
	thumb_func_end ov75_02249684

	thumb_func_start ov75_022496B8
ov75_022496B8: ; 0x022496B8
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #1
	add r6, r1, #0
	lsl r0, r0, #8
	mov r1, #0x74
	bl String_New
	add r4, r0, #0
	ldr r0, [r5, #0x30]
	add r1, r6, #0
	add r2, r4, #0
	bl ReadMsgDataIntoString
	ldr r0, [r5, #0x20]
	ldr r1, [r5, #0x40]
	add r2, r4, #0
	bl StringExpandPlaceholders
	add r0, r5, #0
	add r0, #0x68
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x68
	mov r1, #1
	mov r2, #0x1f
	mov r3, #0xb
	bl DrawFrameAndWindow1
	mov r3, #0
	str r3, [sp]
	str r3, [sp, #4]
	str r3, [sp, #8]
	add r0, r5, #0
	ldr r2, [r5, #0x40]
	add r0, #0x68
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r0, #0xff
	str r0, [r5, #0x44]
	add r0, r4, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov75_022496B8

	thumb_func_start ov75_0224971C
ov75_0224971C: ; 0x0224971C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0
	add r4, r1, #0
	mvn r0, r0
	cmp r4, r0
	bne _0224972E
	mov r4, #0xb
_0224972E:
	mov r0, #2
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, [r5, #0x20]
	mov r1, #0
	mov r3, #5
	bl BufferIntegerAsString
	add r0, r5, #0
	add r0, #0x48
	mov r1, #1
	bl ClearFrameAndWindow2
	add r0, r5, #0
	add r1, r4, #0
	bl ov75_022496B8
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov75_0224971C

	thumb_func_start ov75_02249758
ov75_02249758: ; 0x02249758
	push {r3, lr}
	cmp r2, #0
	bne _02249764
	ldr r0, _02249768 ; =0x000005DC
	bl PlaySE
_02249764:
	pop {r3, pc}
	nop
_02249768: .word 0x000005DC
	thumb_func_end ov75_02249758

	thumb_func_start ov75_0224976C
ov75_0224976C: ; 0x0224976C
	push {r3, lr}
	cmp r2, #0
	bne _02249778
	ldr r0, _0224977C ; =0x000005DC
	bl PlaySE
_02249778:
	pop {r3, pc}
	nop
_0224977C: .word 0x000005DC
	thumb_func_end ov75_0224976C

	thumb_func_start ov75_02249780
ov75_02249780: ; 0x02249780
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r7, r2, #0
	mov r4, #0
	add r5, r1, #0
	ldr r2, _02249828 ; =ov75_02249ACC
	str r0, [sp]
	add r1, r4, #0
	add r0, r2, #0
	add r3, r4, #0
_02249794:
	add r6, r1, #0
	ldrsb r6, [r0, r6]
	add r2, r2, #1
	add r1, r1, #1
	strb r6, [r5, r4]
	ldrsb r6, [r2, r3]
	add r4, r4, #1
	cmp r6, #0
	bne _02249794
	add r0, r7, #0
	mov r1, #0xc8
	bl Heap_Alloc
	str r0, [sp, #4]
	ldr r0, [sp]
	ldr r1, [sp, #4]
	mov r2, #0x64
	bl CopyStringToU16Array
	ldr r7, [sp, #4]
	mov r6, #0
_022497BE:
	ldrh r1, [r7]
	ldr r0, _0224982C ; =0x0000FFFF
	cmp r1, r0
	bne _022497CC
	mov r2, #0
	strb r2, [r5, r4]
	b _02249802
_022497CC:
	ldr r2, [sp, #4]
	lsl r3, r6, #1
	ldrh r3, [r2, r3]
	ldr r1, _02249830 ; =ov75_02249ADC
	mov r0, #0
_022497D6:
	ldrh r2, [r1]
	cmp r2, r3
	bne _022497EA
	ldr r1, _02249830 ; =ov75_02249ADC
	lsl r2, r0, #2
	add r2, r1, r2
	mov r1, #2
	ldrsb r1, [r2, r1]
	strb r1, [r5, r4]
	b _022497F2
_022497EA:
	add r0, r0, #1
	add r1, r1, #4
	cmp r0, #0xa
	blo _022497D6
_022497F2:
	cmp r0, #0xa
	blo _022497FA
	bl GF_AssertFail
_022497FA:
	add r4, r4, #1
	add r7, r7, #2
	add r6, r6, #1
	b _022497BE
_02249802:
	ldr r1, _02249834 ; =ov75_02249AD0
	add r3, r2, #0
	add r0, r1, #0
_02249808:
	add r6, r2, #0
	ldrsb r6, [r0, r6]
	add r1, r1, #1
	add r2, r2, #1
	strb r6, [r5, r4]
	ldrsb r6, [r1, r3]
	add r4, r4, #1
	cmp r6, #0
	bne _02249808
	mov r0, #0
	strb r0, [r5, r4]
	ldr r0, [sp, #4]
	bl Heap_Free
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02249828: .word ov75_02249ACC
_0224982C: .word 0x0000FFFF
_02249830: .word ov75_02249ADC
_02249834: .word ov75_02249AD0
	thumb_func_end ov75_02249780

	thumb_func_start ov75_02249838
ov75_02249838: ; 0x02249838
	push {r4, r5, r6, lr}
	add r6, r0, #0
	add r0, r1, #0
	mov r1, #0xc8
	mov r5, #1
	bl Heap_Alloc
	add r4, r0, #0
	add r0, r6, #0
	add r1, r4, #0
	mov r2, #0x64
	bl CopyStringToU16Array
	ldrh r1, [r4]
	ldr r0, _0224987C ; =0x0000FFFF
	cmp r1, r0
	beq _02249870
	ldr r1, _02249880 ; =0x00000121
	add r3, r4, #0
_0224985E:
	ldrh r2, [r3]
	cmp r2, r1
	beq _02249868
	mov r5, #0
	b _02249870
_02249868:
	add r3, r3, #2
	ldrh r2, [r3]
	cmp r2, r0
	bne _0224985E
_02249870:
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	pop {r4, r5, r6, pc}
	nop
_0224987C: .word 0x0000FFFF
_02249880: .word 0x00000121
	thumb_func_end ov75_02249838

	thumb_func_start ov75_02249884
ov75_02249884: ; 0x02249884
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	mov r4, #0
	add r5, r0, #0
	add r7, r1, #0
	str r4, [sp, #4]
_02249890:
	mov r0, #0
	str r0, [r7]
	str r0, [sp]
	b _022498CC
_02249898:
	cmp r0, #0
	bne _022498A4
	bne _022498B2
	bl GF_AssertFail
	b _022498B2
_022498A4:
	add r4, r4, #1
_022498A6:
	ldrsb r0, [r5, r4]
	add r6, r5, r4
	cmp r0, #0x30
	blt _02249898
	cmp r0, #0x39
	bgt _02249898
_022498B2:
	ldr r1, [r7]
	mov r0, #0xa
	mul r0, r1
	str r0, [r7]
	mov r1, #0
	ldrsb r1, [r6, r1]
	add r4, r4, #1
	sub r1, #0x30
	add r0, r0, r1
	str r0, [r7]
	ldr r0, [sp]
	add r0, r0, #1
	str r0, [sp]
_022498CC:
	ldr r0, [sp]
	cmp r0, #4
	blt _022498A6
	ldr r0, [sp, #4]
	add r7, r7, #4
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #4
	blt _02249890
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov75_02249884
