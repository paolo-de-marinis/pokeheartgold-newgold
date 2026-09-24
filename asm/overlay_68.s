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

	thumb_func_start MoveRelearner_Init
MoveRelearner_Init: ; 0x021E5900
	push {r3, r4, r5, lr}
	mov r2, #9
	add r5, r0, #0
	mov r0, #3
	mov r1, #0x42
	lsl r2, r2, #0xe
	bl Heap_Create
	mov r1, #0x77
	add r0, r5, #0
	lsl r1, r1, #2
	mov r2, #0x42
	bl OverlayManager_CreateAndGetData
	mov r2, #0x77
	mov r1, #0
	lsl r2, r2, #2
	add r4, r0, #0
	bl memset
	add r0, r5, #0
	bl OverlayManager_GetArgs
	str r0, [r4]
	add r0, r4, #0
	bl ov68_021E5A58
	ldr r1, [r4]
	add r0, r4, #0
	ldrh r1, [r1, #0x14]
	mov r2, #3
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl ov68_021E73A4
	mov r0, #0x1b
	mov r1, #1
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov68_021E7424
	ldr r0, _021E5964 ; =ov68_021E5B6C
	add r1, r4, #0
	bl Main_SetVBlankIntrCB
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E5964: .word ov68_021E5B6C
	thumb_func_end MoveRelearner_Init

	thumb_func_start MoveRelearner_Main
MoveRelearner_Main: ; 0x021E5968
	push {r3, r4, r5, lr}
	add r4, r1, #0
	bl OverlayManager_GetData
	ldr r1, [r4]
	add r5, r0, #0
	cmp r1, #0xf
	bhi _021E5A22
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E5984: ; jump table
	.short _021E59A4 - _021E5984 - 2 ; case 0
	.short _021E59AC - _021E5984 - 2 ; case 1
	.short _021E59B4 - _021E5984 - 2 ; case 2
	.short _021E59BC - _021E5984 - 2 ; case 3
	.short _021E59C4 - _021E5984 - 2 ; case 4
	.short _021E59CC - _021E5984 - 2 ; case 5
	.short _021E59D4 - _021E5984 - 2 ; case 6
	.short _021E59DC - _021E5984 - 2 ; case 7
	.short _021E59E4 - _021E5984 - 2 ; case 8
	.short _021E59EC - _021E5984 - 2 ; case 9
	.short _021E59F0 - _021E5984 - 2 ; case 10
	.short _021E59F8 - _021E5984 - 2 ; case 11
	.short _021E5A02 - _021E5984 - 2 ; case 12
	.short _021E5A0C - _021E5984 - 2 ; case 13
	.short _021E5A14 - _021E5984 - 2 ; case 14
	.short _021E5A1C - _021E5984 - 2 ; case 15
_021E59A4:
	bl ov68_021E5F50
	str r0, [r4]
	b _021E5A22
_021E59AC:
	bl ov68_021E5F68
	str r0, [r4]
	b _021E5A22
_021E59B4:
	bl ov68_021E6058
	str r0, [r4]
	b _021E5A22
_021E59BC:
	bl ov68_021E6078
	str r0, [r4]
	b _021E5A22
_021E59C4:
	bl ov68_021E60D8
	str r0, [r4]
	b _021E5A22
_021E59CC:
	bl ov68_021E614C
	str r0, [r4]
	b _021E5A22
_021E59D4:
	bl ov68_021E61A0
	str r0, [r4]
	b _021E5A22
_021E59DC:
	bl ov68_021E61B8
	str r0, [r4]
	b _021E5A22
_021E59E4:
	bl ov68_021E61EC
	str r0, [r4]
	b _021E5A22
_021E59EC:
	mov r0, #1
	pop {r3, r4, r5, pc}
_021E59F0:
	bl ov68_021E74C0
	str r0, [r4]
	b _021E5A22
_021E59F8:
	bl ov68_021E74D8
	str r0, [r4]
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E5A02:
	bl ov68_021E7568
	str r0, [r4]
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E5A0C:
	bl ov68_021E7AD8
	str r0, [r4]
	b _021E5A22
_021E5A14:
	bl ov68_021E7B6C
	str r0, [r4]
	b _021E5A22
_021E5A1C:
	bl ov68_021E7B8C
	str r0, [r4]
_021E5A22:
	mov r0, #0x55
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov68_021E734C
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl SpriteSystem_DrawSprites
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end MoveRelearner_Main

	thumb_func_start MoveRelearner_Exit
MoveRelearner_Exit: ; 0x021E5A3C
	push {r4, lr}
	add r4, r0, #0
	bl OverlayManager_GetData
	bl ov68_021E5B14
	add r0, r4, #0
	bl OverlayManager_FreeData
	mov r0, #0x42
	bl Heap_Destroy
	mov r0, #1
	pop {r4, pc}
	thumb_func_end MoveRelearner_Exit

	thumb_func_start ov68_021E5A58
ov68_021E5A58: ; 0x021E5A58
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _021E5B08 ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _021E5B0C ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	mov r0, #1
	bl TextFlags_SetCanTouchSpeedUpPrint
	ldr r0, [r4]
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_GetState
	mov r1, #0x6d
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x42
	bl BgConfig_Alloc
	str r0, [r4, #4]
	mov r0, #0x6e
	mov r1, #0x42
	bl NARC_New
	add r5, r0, #0
	bl ov68_021E5BA0
	ldr r0, [r4, #4]
	bl ov68_021E5BC0
	add r0, r4, #0
	add r1, r5, #0
	bl ov68_021E5D24
	add r0, r4, #0
	add r1, r5, #0
	bl ov68_021E7178
	add r0, r4, #0
	bl ov68_021E7288
	add r0, r4, #0
	bl ov68_021E5EBC
	add r0, r4, #0
	bl ov68_021E5E48
	add r0, r4, #0
	bl ov68_021E6820
	add r0, r4, #0
	bl ov68_021E6204
	add r0, r4, #0
	bl ov68_021E6320
	add r0, r4, #0
	bl ov68_021E75C0
	mov r0, #0
	mov r1, #0x42
	bl sub_020880CC
	ldr r0, _021E5B10 ; =ov68_021E5B6C
	add r1, r4, #0
	bl Main_SetVBlankIntrCB
	add r0, r5, #0
	bl NARC_Delete
	pop {r3, r4, r5, pc}
	nop
_021E5B08: .word 0xFFFFE0FF
_021E5B0C: .word 0x04001000
_021E5B10: .word ov68_021E5B6C
	thumb_func_end ov68_021E5A58

	thumb_func_start ov68_021E5B14
ov68_021E5B14: ; 0x021E5B14
	push {r4, lr}
	add r4, r0, #0
	bl ov68_021E7604
	add r0, r4, #0
	bl ov68_021E68C4
	add r0, r4, #0
	bl ov68_021E5E94
	add r0, r4, #0
	bl ov68_021E5E38
	ldr r0, [r4, #4]
	bl ov68_021E5CD8
	add r0, r4, #0
	bl ov68_021E5F18
	mov r0, #0x55
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov68_021E7388
	add r0, r4, #0
	bl ov68_021E6E84
	ldr r0, [r4]
	mov r1, #0x6d
	lsl r1, r1, #2
	ldr r0, [r0, #0xc]
	ldr r1, [r4, r1]
	bl MenuInputStateMgr_SetState
	mov r0, #0
	bl TextFlags_SetCanTouchSpeedUpPrint
	bl GF_DestroyVramTransferManager
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	pop {r4, pc}
	thumb_func_end ov68_021E5B14

	thumb_func_start ov68_021E5B6C
ov68_021E5B6C: ; 0x021E5B6C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #4]
	bl DoScheduledBgGpuUpdates
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl PokepicManager_HandleLoadImgAndOrPltt
	bl GF_RunVramTransferTasks
	bl SpriteSystem_TransferOam
	ldr r3, _021E5B98 ; =0x027E0000
	ldr r1, _021E5B9C ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r4, pc}
	nop
_021E5B98: .word 0x027E0000
_021E5B9C: .word 0x00003FF8
	thumb_func_end ov68_021E5B6C

	thumb_func_start ov68_021E5BA0
ov68_021E5BA0: ; 0x021E5BA0
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _021E5BBC ; =ov68_021E7D14
	add r3, sp, #0
	mov r2, #5
_021E5BAA:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021E5BAA
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_021E5BBC: .word ov68_021E7D14
	thumb_func_end ov68_021E5BA0

	thumb_func_start ov68_021E5BC0
ov68_021E5BC0: ; 0x021E5BC0
	push {r4, r5, lr}
	sub sp, #0x9c
	ldr r5, _021E5CC0 ; =ov68_021E7BF8
	add r3, sp, #0x8c
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r5, _021E5CC4 ; =ov68_021E7C60
	add r3, sp, #0x70
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #2
	str r0, [r3]
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E5CC8 ; =ov68_021E7C44
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E5CCC ; =ov68_021E7C7C
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E5CD0 ; =ov68_021E7C98
	add r3, sp, #0x1c
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E5CD4 ; =ov68_021E7CB4
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #7
	str r0, [r3]
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	mov r0, #2
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x42
	bl BG_ClearCharDataRange
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x42
	bl BG_ClearCharDataRange
	add sp, #0x9c
	pop {r4, r5, pc}
	nop
_021E5CC0: .word ov68_021E7BF8
_021E5CC4: .word ov68_021E7C60
_021E5CC8: .word ov68_021E7C44
_021E5CCC: .word ov68_021E7C7C
_021E5CD0: .word ov68_021E7C98
_021E5CD4: .word ov68_021E7CB4
	thumb_func_end ov68_021E5BC0

	thumb_func_start ov68_021E5CD8
ov68_021E5CD8: ; 0x021E5CD8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1d
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #7
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #6
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
	mov r0, #0x42
	add r1, r4, #0
	bl Heap_FreeExplicit
	ldr r2, _021E5D20 ; =0x04000304
	ldrh r1, [r2]
	lsr r0, r2, #0xb
	orr r0, r1
	strh r0, [r2]
	pop {r4, pc}
	.balign 4, 0
_021E5D20: .word 0x04000304
	thumb_func_end ov68_021E5CD8

	thumb_func_start ov68_021E5D24
ov68_021E5D24: ; 0x021E5D24
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	add r4, r1, #0
	mov r0, #0
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, [r5, #4]
	mov r1, #0x42
	add r2, r4, #0
	mov r3, #0x6e
	bl BgConfig_LoadAssetFromOpenNarc
	mov r0, #4
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	lsl r0, r0, #0xb
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	ldr r0, [r5, #4]
	mov r1, #0x42
	add r2, r4, #0
	mov r3, #0x6e
	bl BgConfig_LoadAssetFromOpenNarc
	mov r1, #0
	str r1, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r0, [r5, #4]
	mov r1, #0x42
	add r2, r4, #0
	mov r3, #0x6e
	bl BgConfig_LoadAssetFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, [r5, #4]
	mov r1, #0x42
	add r2, r4, #0
	mov r3, #0x6e
	bl BgConfig_LoadAssetFromOpenNarc
	mov r0, #2
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	lsl r0, r0, #0xb
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	ldr r0, [r5, #4]
	mov r1, #0x42
	add r2, r4, #0
	mov r3, #0x6e
	bl BgConfig_LoadAssetFromOpenNarc
	mov r1, #0
	str r1, [sp]
	mov r0, #7
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r0, [r5, #4]
	mov r1, #0x42
	add r2, r4, #0
	mov r3, #0x6e
	bl BgConfig_LoadAssetFromOpenNarc
	mov r3, #0x71
	mov r0, #0x42
	lsl r3, r3, #2
	str r0, [sp]
	add r0, r4, #0
	mov r1, #3
	mov r2, #0
	add r3, r5, r3
	bl GfGfxLoader_GetScrnDataFromOpenNarc
	mov r1, #7
	lsl r1, r1, #6
	str r0, [r5, r1]
	mov r0, #4
	mov r2, #0x42
	bl LoadFontPal1
	mov r1, #0x1e
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #0x42
	bl LoadFontPal0
	mov r1, #0x1e
	mov r0, #4
	lsl r1, r1, #4
	mov r2, #0x42
	bl LoadFontPal0
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x42
	str r0, [sp, #4]
	ldr r0, [r5, #4]
	mov r1, #4
	mov r2, #0x3d
	mov r3, #0xd
	bl LoadUserFrameGfx2
	add sp, #0x14
	pop {r4, r5, pc}
	thumb_func_end ov68_021E5D24

	thumb_func_start ov68_021E5E38
ov68_021E5E38: ; 0x021E5E38
	mov r1, #7
	lsl r1, r1, #6
	ldr r3, _021E5E44 ; =Heap_Free
	ldr r0, [r0, r1]
	bx r3
	nop
_021E5E44: .word Heap_Free
	thumb_func_end ov68_021E5E38

	thumb_func_start ov68_021E5E48
ov68_021E5E48: ; 0x021E5E48
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #4
	mov r1, #0x42
	bl FontID_Alloc
	add r5, r7, #0
	ldr r4, _021E5E90 ; =ov68_021E7DFC
	mov r6, #0
	add r5, #8
_021E5E5C:
	ldr r0, [r7, #4]
	add r1, r5, #0
	add r2, r4, #0
	bl AddWindow
	add r0, r5, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r6, r6, #1
	add r4, #8
	add r5, #0x10
	cmp r6, #0xf
	blo _021E5E5C
	add r0, r7, #0
	add r0, #0x88
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x42
	bl YesNoPrompt_Create
	mov r1, #0x46
	lsl r1, r1, #2
	str r0, [r7, r1]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E5E90: .word ov68_021E7DFC
	thumb_func_end ov68_021E5E48

	thumb_func_start ov68_021E5E94
ov68_021E5E94: ; 0x021E5E94
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	mov r5, #0
	add r4, #8
_021E5EA6:
	add r0, r4, #0
	bl RemoveWindow
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #0xf
	blo _021E5EA6
	mov r0, #4
	bl FontID_Release
	pop {r3, r4, r5, pc}
	thumb_func_end ov68_021E5E94

	thumb_func_start ov68_021E5EBC
ov68_021E5EBC: ; 0x021E5EBC
	push {r4, lr}
	ldr r2, _021E5F14 ; =0x000002EB
	add r4, r0, #0
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x42
	bl NewMsgDataFromNarc
	add r1, r4, #0
	add r1, #0xf8
	str r0, [r1]
	mov r0, #0x42
	bl MessageFormat_New
	add r1, r4, #0
	add r1, #0xfc
	str r0, [r1]
	mov r0, #1
	lsl r0, r0, #8
	mov r1, #0x42
	bl String_New
	mov r1, #1
	lsl r1, r1, #8
	str r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xf8
	ldr r0, [r0]
	mov r1, #0x19
	bl NewString_ReadMsgData
	mov r1, #0x41
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xf8
	ldr r0, [r0]
	mov r1, #0x1f
	bl NewString_ReadMsgData
	mov r1, #0x42
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021E5F14: .word 0x000002EB
	thumb_func_end ov68_021E5EBC

	thumb_func_start ov68_021E5F18
ov68_021E5F18: ; 0x021E5F18
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xf8
	ldr r0, [r0]
	bl DestroyMsgData
	add r0, r4, #0
	add r0, #0xfc
	ldr r0, [r0]
	bl MessageFormat_Delete
	mov r0, #1
	lsl r0, r0, #8
	ldr r0, [r4, r0]
	bl String_Delete
	mov r0, #0x41
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	mov r0, #0x42
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov68_021E5F18

	thumb_func_start ov68_021E5F50
ov68_021E5F50: ; 0x021E5F50
	push {r4, lr}
	add r4, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021E5F64
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	pop {r4, pc}
_021E5F64:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov68_021E5F50

	thumb_func_start ov68_021E5F68
ov68_021E5F68: ; 0x021E5F68
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x72
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl GridInputHandler_GetNextInput
	mov r1, #0x73
	lsl r1, r1, #2
	strh r0, [r4, r1]
	sub r0, r1, #4
	ldr r0, [r4, r0]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021E5FB8
	bhs _021E604E
	cmp r5, #7
	bhi _021E5FB0
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E5FA0: ; jump table
	.short _021E5FC8 - _021E5FA0 - 2 ; case 0
	.short _021E5FC8 - _021E5FA0 - 2 ; case 1
	.short _021E5FC8 - _021E5FA0 - 2 ; case 2
	.short _021E5FC8 - _021E5FA0 - 2 ; case 3
	.short _021E604E - _021E5FA0 - 2 ; case 4
	.short _021E604E - _021E5FA0 - 2 ; case 5
	.short _021E601E - _021E5FA0 - 2 ; case 6
	.short _021E603E - _021E5FA0 - 2 ; case 7
_021E5FB0:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	b _021E604E
_021E5FB8:
	add r0, r1, #1
	cmp r5, r0
	bhi _021E5FC2
	beq _021E601E
	b _021E604E
_021E5FC2:
	add r0, r1, #2
	cmp r5, r0
	b _021E604E
_021E5FC8:
	bl System_GetTouchNew
	cmp r0, #0
	ldr r0, [r4]
	bne _021E5FF6
	ldrh r0, [r0, #0x16]
	add r1, r0, r5
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r0, [r4, r0]
	cmp r1, r0
	bhs _021E604E
	ldr r0, _021E6054 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov68_021E7A18
	add r0, r4, #0
	bl ov68_021E7B94
	pop {r3, r4, r5, pc}
_021E5FF6:
	ldrh r0, [r0, #0x16]
	add r1, r0, r5
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r0, [r4, r0]
	cmp r1, r0
	bhs _021E6014
	ldr r0, _021E6054 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov68_021E7A18
	b _021E604E
_021E6014:
	add r0, r4, #0
	mov r1, #5
	bl ov68_021E7A18
	b _021E604E
_021E601E:
	ldr r0, _021E6054 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	bl ov68_021E7A18
	add r0, r4, #0
	mov r1, #0
	bl ov68_021E7898
	add r0, r4, #0
	mov r1, #0xe
	bl ov68_021E7A90
	pop {r3, r4, r5, pc}
_021E603E:
	ldr r0, _021E6054 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xf
	bl ov68_021E7AB4
	pop {r3, r4, r5, pc}
_021E604E:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021E6054: .word 0x000005DD
	thumb_func_end ov68_021E5F68

	thumb_func_start ov68_021E6058
ov68_021E6058: ; 0x021E6058
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E6074 ; =0x000001B9
	ldrb r0, [r4, r0]
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021E6070
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	pop {r4, pc}
_021E6070:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021E6074: .word 0x000001B9
	thumb_func_end ov68_021E6058

	thumb_func_start ov68_021E6078
ov68_021E6078: ; 0x021E6078
	push {r4, r5, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r0, sp, #0
	mov r1, #0
	mov r2, #0x14
	bl MI_CpuFill8
	ldr r0, [r4, #4]
	mov r3, #0x6d
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xb
	str r0, [sp, #0xc]
	mov r1, #0x1a
	add r0, sp, #0
	strb r1, [r0, #0x10]
	mov r1, #0xa
	strb r1, [r0, #0x11]
	ldrb r1, [r0, #0x12]
	mov r2, #0xf
	lsl r3, r3, #2
	bic r1, r2
	ldr r2, [r4, r3]
	sub r3, #0x9c
	lsl r2, r2, #0x18
	lsr r5, r2, #0x18
	mov r2, #0xf
	and r2, r5
	orr r1, r2
	strb r1, [r0, #0x12]
	ldrb r2, [r0, #0x12]
	mov r1, #0xf0
	bic r2, r1
	strb r2, [r0, #0x12]
	ldr r0, [r4, r3]
	add r1, sp, #0
	bl YesNoPrompt_InitFromTemplate
	mov r0, #1
	bl ov68_021E7BC8
	mov r0, #4
	add sp, #0x14
	pop {r4, r5, pc}
	thumb_func_end ov68_021E6078

	thumb_func_start ov68_021E60D8
ov68_021E60D8: ; 0x021E60D8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _021E60F0
	cmp r0, #2
	beq _021E6108
	b _021E6120
_021E60F0:
	ldr r1, _021E6140 ; =0x000001BA
	add r0, r5, #0
	ldrb r1, [r5, r1]
	lsl r2, r1, #3
	ldr r1, _021E6144 ; =ov68_021E7D3C
	ldr r1, [r1, r2]
	blx r1
	add r4, r0, #0
	mov r0, #0
	bl ov68_021E7BC8
	b _021E6124
_021E6108:
	ldr r1, _021E6140 ; =0x000001BA
	add r0, r5, #0
	ldrb r1, [r5, r1]
	lsl r2, r1, #3
	ldr r1, _021E6148 ; =ov68_021E7D40
	ldr r1, [r1, r2]
	blx r1
	add r4, r0, #0
	mov r0, #0
	bl ov68_021E7BC8
	b _021E6124
_021E6120:
	mov r0, #4
	pop {r3, r4, r5, pc}
_021E6124:
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl YesNoPrompt_IsInTouchMode
	mov r1, #0x6d
	lsl r1, r1, #2
	str r0, [r5, r1]
	sub r1, #0x9c
	ldr r0, [r5, r1]
	bl YesNoPrompt_Reset
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E6140: .word 0x000001BA
_021E6144: .word ov68_021E7D3C
_021E6148: .word ov68_021E7D40
	thumb_func_end ov68_021E60D8

	thumb_func_start ov68_021E614C
ov68_021E614C: ; 0x021E614C
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	bl ov68_021E6BEC
	str r0, [sp]
	ldr r1, [r4]
	add r2, sp, #0
	ldr r0, [r1]
	ldrb r1, [r1, #0x1b]
	add r1, #0x36
	bl SetMonData
	mov r0, #0
	str r0, [sp]
	ldr r1, [r4]
	add r2, sp, #0
	ldr r0, [r1]
	ldrb r1, [r1, #0x1b]
	add r1, #0x3e
	bl SetMonData
	add r0, r4, #0
	bl ov68_021E6BEC
	mov r1, #0
	bl GetMoveMaxPP
	str r0, [sp]
	ldr r1, [r4]
	add r2, sp, #0
	ldr r0, [r1]
	ldrb r1, [r1, #0x1b]
	add r1, #0x3a
	bl SetMonData
	ldr r0, [r4]
	mov r1, #0
	strb r1, [r0, #0x1a]
	mov r0, #8
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov68_021E614C

	thumb_func_start ov68_021E61A0
ov68_021E61A0: ; 0x021E61A0
	push {r4, lr}
	mov r1, #6
	add r4, r0, #0
	bl ov68_021E6C14
	mov r0, #0x1b
	mov r1, #5
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov68_021E61A0

	thumb_func_start ov68_021E61B8
ov68_021E61B8: ; 0x021E61B8
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4]
	ldrb r1, [r1, #0x1b]
	cmp r1, #4
	bhs _021E61CE
	mov r1, #0xa
	bl ov68_021E6C14
	mov r1, #4
	b _021E61D6
_021E61CE:
	mov r1, #7
	bl ov68_021E6C14
	mov r1, #3
_021E61D6:
	ldr r0, _021E61E8 ; =0x000001BA
	strb r1, [r4, r0]
	mov r0, #0x1b
	mov r1, #3
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #2
	pop {r4, pc}
	nop
_021E61E8: .word 0x000001BA
	thumb_func_end ov68_021E61B8

	thumb_func_start ov68_021E61EC
ov68_021E61EC: ; 0x021E61EC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	mov r1, #0x42
	bl sub_020880CC
	mov r0, #0x1b
	mov r1, #9
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov68_021E61EC

	thumb_func_start ov68_021E6204
ov68_021E6204: ; 0x021E6204
	push {r4, lr}
	add r4, r0, #0
	bl ov68_021E6BEC
	add r1, r0, #0
	ldr r0, _021E6230 ; =0x0000FFFF
	cmp r1, r0
	beq _021E621C
	add r0, r4, #0
	bl ov68_021E68D4
	b _021E6226
_021E621C:
	mov r1, #1
	add r0, r4, #0
	mvn r1, r1
	bl ov68_021E68D4
_021E6226:
	add r0, r4, #0
	bl ov68_021E70BC
	pop {r4, pc}
	nop
_021E6230: .word 0x0000FFFF
	thumb_func_end ov68_021E6204

	thumb_func_start ov68_021E6234
ov68_021E6234: ; 0x021E6234
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [sp, #0x28]
	add r4, r1, #0
	add r7, r2, #0
	str r3, [sp, #0x10]
	cmp r0, #0
	beq _021E6250
	cmp r0, #1
	beq _021E6254
	cmp r0, #2
	beq _021E627E
	b _021E62AA
_021E6250:
	mov r3, #0
	b _021E62AA
_021E6254:
	mov r1, #1
	lsl r1, r1, #8
	ldr r1, [r5, r1]
	add r0, r7, #0
	mov r2, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	add r1, r5, #0
	lsr r6, r0, #0x18
	add r1, #8
	lsl r0, r4, #4
	add r0, r1, r0
	bl GetWindowWidth
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x18
	sub r0, r0, r6
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	b _021E62AA
_021E627E:
	mov r1, #1
	lsl r1, r1, #8
	ldr r1, [r5, r1]
	add r0, r7, #0
	mov r2, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	add r1, r5, #0
	lsr r6, r0, #0x18
	add r1, #8
	lsl r0, r4, #4
	add r0, r1, r0
	bl GetWindowWidth
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x18
	sub r1, r0, r6
	lsr r0, r1, #0x1f
	add r0, r1, r0
	lsl r0, r0, #0x17
	lsr r3, r0, #0x18
_021E62AA:
	add r0, sp, #0x18
	ldrb r0, [r0, #0x14]
	add r1, r5, #0
	mov r2, #0xff
	str r0, [sp]
	str r2, [sp, #4]
	ldr r0, [sp, #0x10]
	add r2, r2, #1
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r1, #8
	lsl r0, r4, #4
	add r0, r1, r0
	ldr r2, [r5, r2]
	add r1, r7, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov68_021E6234

	thumb_func_start ov68_021E62D4
ov68_021E62D4: ; 0x021E62D4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	add r0, #0xf8
	ldr r0, [r0]
	add r6, r2, #0
	add r7, r3, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, sp, #0x10
	ldrb r0, [r0, #0x10]
	mov r1, #0
	add r2, r6, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	add r0, r5, #0
	add r0, #0xfc
	ldr r0, [r0]
	add r3, r7, #0
	bl BufferIntegerAsString
	add r0, r5, #0
	mov r1, #1
	add r0, #0xfc
	lsl r1, r1, #8
	ldr r0, [r0]
	ldr r1, [r5, r1]
	add r2, r4, #0
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov68_021E62D4
