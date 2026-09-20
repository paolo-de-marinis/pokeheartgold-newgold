#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/ribbon.h"
#include "constants/field_move_response.h"
#include "msgdata/msg/msg_0300.h"
	.include "asm/macros.inc"
	.include "unk_02088288.inc"
	.include "global.inc"

	.public gOverlayTemplate_Battle
	.public gNatureStatMods

	.text

	thumb_func_start sub_02088288
sub_02088288: ; 0x02088288
	mov r0, #1
	bx lr
	thumb_func_end sub_02088288

	thumb_func_start sub_0208828C
sub_0208828C: ; 0x0208828C
	push {r3, lr}
	bl Save_VarsFlags_Get
	bl CheckFlag982
	pop {r3, pc}
	thumb_func_end sub_0208828C

	thumb_func_start PokemonSummary_Init
PokemonSummary_Init: ; 0x02088298
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r1, #1
	lsl r1, r1, #0x1a
	ldr r0, [r1]
	ldr r2, _02088408 ; =0xFFFFE0FF
	and r0, r2
	str r0, [r1]
	ldr r0, _0208840C ; =0x04001000
	ldr r3, [r0]
	and r2, r3
	str r2, [r0]
	ldr r3, [r1]
	ldr r2, _02088410 ; =0xFFFF1FFF
	and r3, r2
	str r3, [r1]
	ldr r3, [r0]
	add r1, #0x50
	and r2, r3
	str r2, [r0]
	mov r2, #0
	strh r2, [r1]
	add r0, #0x50
	strh r2, [r0]
	mov r0, #4
	mov r1, #8
	bl SetKeyRepeatTimers
	mov r2, #0x45
	mov r0, #3
	mov r1, #0x13
	lsl r2, r2, #0xc
	bl Heap_Create
	mov r0, #0x27
	mov r1, #0x13
	bl NARC_New
	add r7, r0, #0
	mov r0, #0xa2
	mov r1, #0x13
	bl NARC_New
	add r5, r0, #0
	ldr r1, _02088414 ; =0x000007D8
	add r0, r6, #0
	mov r2, #0x13
	bl OverlayManager_CreateAndGetData
	ldr r2, _02088414 ; =0x000007D8
	mov r1, #0
	add r4, r0, #0
	bl memset
	add r0, r6, #0
	bl OverlayManager_GetArgs
	mov r1, #0x8b
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x13
	bl BgConfig_Alloc
	str r0, [r4]
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	str r1, [r0, #0x38]
	mov r1, #1
	mov r0, #0x13
	add r2, r1, #0
	bl sub_02016EDC
	mov r1, #0xb3
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0xb4
	mov r1, #0x13
	bl NARC_New
	ldr r1, _02088418 ; =0x000007B8
	str r0, [r4, r1]
	mov r0, #0
	mov r1, #0x13
	bl FontID_SetAccessDirect
	bl sub_020210BC
	mov r0, #4
	bl sub_02021148
	bl sub_02088610
	ldr r0, [r4]
	bl sub_02088630
	add r0, r4, #0
	add r1, r7, #0
	add r2, r5, #0
	bl sub_020887C4
	bl sub_0208887C
	add r0, r4, #0
	bl sub_0208DE40
	mov r0, #4
	mov r1, #0x13
	bl FontID_Alloc
	add r0, r4, #0
	bl sub_02088894
	add r0, r4, #0
	add r1, r5, #0
	bl sub_020889D0
	add r0, r4, #0
	bl sub_020897C0
	add r0, r4, #0
	bl sub_0208B1AC
	add r0, r4, #0
	bl sub_0208B2C0
	add r0, r4, #0
	bl sub_0208E3AC
	add r0, r4, #0
	bl sub_0208B48C
	add r0, r4, #0
	bl sub_0208B4EC
	add r0, r4, #0
	bl sub_0208BECC
	add r0, r4, #0
	bl sub_0208C3E4
	add r0, r4, #0
	bl sub_02089CB4
	add r0, r4, #0
	bl sub_0208DF2C
	ldr r0, _0208841C ; =sub_020885DC
	add r1, r4, #0
	bl Main_SetVBlankIntrCB
	ldr r2, _02088420 ; =0x04000304
	ldrh r1, [r2]
	lsr r0, r2, #0xb
	orr r0, r1
	strh r0, [r2]
	bl GfGfx_BothDispOn
	mov r1, #0
	mov r0, #0x3d
	add r2, r1, #0
	bl Sound_SetSceneAndPlayBGM
	bl sub_0203A964
	add r0, r5, #0
	bl NARC_Delete
	add r0, r7, #0
	bl NARC_Delete
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02088408: .word 0xFFFFE0FF
_0208840C: .word 0x04001000
_02088410: .word 0xFFFF1FFF
_02088414: .word 0x000007D8
_02088418: .word 0x000007B8
_0208841C: .word sub_020885DC
_02088420: .word 0x04000304
	thumb_func_end PokemonSummary_Init

	thumb_func_start PokemonSummary_Main
PokemonSummary_Main: ; 0x02088424
	push {r3, r4, r5, lr}
	add r4, r1, #0
	bl OverlayManager_GetData
	ldr r1, [r4]
	add r5, r0, #0
	cmp r1, #0x16
	bls _02088436
	b _0208854A
_02088436:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02088442: ; jump table
	.short _02088470 - _02088442 - 2 ; case 0
	.short _0208848C - _02088442 - 2 ; case 1
	.short _02088494 - _02088442 - 2 ; case 2
	.short _0208849C - _02088442 - 2 ; case 3
	.short _020884A4 - _02088442 - 2 ; case 4
	.short _020884AC - _02088442 - 2 ; case 5
	.short _020884BC - _02088442 - 2 ; case 6
	.short _020884B4 - _02088442 - 2 ; case 7
	.short _020884C4 - _02088442 - 2 ; case 8
	.short _020884CC - _02088442 - 2 ; case 9
	.short _020884D4 - _02088442 - 2 ; case 10
	.short _020884DC - _02088442 - 2 ; case 11
	.short _020884E4 - _02088442 - 2 ; case 12
	.short _020884EC - _02088442 - 2 ; case 13
	.short _020884F4 - _02088442 - 2 ; case 14
	.short _020884FC - _02088442 - 2 ; case 15
	.short _02088504 - _02088442 - 2 ; case 16
	.short _0208850C - _02088442 - 2 ; case 17
	.short _02088514 - _02088442 - 2 ; case 18
	.short _02088530 - _02088442 - 2 ; case 19
	.short _02088544 - _02088442 - 2 ; case 20
	.short _0208851C - _02088442 - 2 ; case 21
	.short _02088524 - _02088442 - 2 ; case 22
_02088470:
	mov r0, #0
	mov r1, #0x13
	bl sub_020880CC
	mov r0, #0x2d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #6
	mov r2, #0
	bl Pokepic_SetAttr
	mov r0, #1
	str r0, [r4]
	b _0208854A
_0208848C:
	bl sub_02088B08
	str r0, [r4]
	b _0208854A
_02088494:
	bl sub_02088B40
	str r0, [r4]
	b _0208854A
_0208849C:
	bl sub_02088D18
	str r0, [r4]
	b _0208854A
_020884A4:
	bl sub_02088D34
	str r0, [r4]
	b _0208854A
_020884AC:
	bl sub_02088D48
	str r0, [r4]
	b _0208854A
_020884B4:
	bl sub_02088E68
	str r0, [r4]
	b _0208854A
_020884BC:
	bl sub_02088E98
	str r0, [r4]
	b _0208854A
_020884C4:
	bl sub_02089028
	str r0, [r4]
	b _0208854A
_020884CC:
	bl sub_02089208
	str r0, [r4]
	b _0208854A
_020884D4:
	bl sub_020892F4
	str r0, [r4]
	b _0208854A
_020884DC:
	bl sub_02089308
	str r0, [r4]
	b _0208854A
_020884E4:
	bl sub_0208931C
	str r0, [r4]
	b _0208854A
_020884EC:
	bl sub_0208942C
	str r0, [r4]
	b _0208854A
_020884F4:
	bl sub_02089454
	str r0, [r4]
	b _0208854A
_020884FC:
	bl sub_02089698
	str r0, [r4]
	b _0208854A
_02088504:
	bl sub_02089478
	str r0, [r4]
	b _0208854A
_0208850C:
	bl sub_02089608
	str r0, [r4]
	b _0208854A
_02088514:
	bl sub_02089658
	str r0, [r4]
	b _0208854A
_0208851C:
	bl sub_02089670
	str r0, [r4]
	b _0208854A
_02088524:
	bl sub_02089680
	cmp r0, #1
	bne _0208854A
	mov r0, #1
	pop {r3, r4, r5, pc}
_02088530:
	mov r0, #0x2d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #6
	mov r2, #0
	bl Pokepic_SetAttr
	mov r0, #2
	str r0, [r4]
	b _0208854A
_02088544:
	bl sub_02089794
	str r0, [r4]
_0208854A:
	add r0, r5, #0
	bl sub_0208B278
	add r0, r5, #0
	bl sub_0208C3C0
	mov r0, #1
	lsl r0, r0, #0xa
	ldr r0, [r5, r0]
	bl SpriteSystem_DrawSprites
	add r0, r5, #0
	bl sub_0208DEDC
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end PokemonSummary_Main

	thumb_func_start PokemonSummary_Exit
PokemonSummary_Exit: ; 0x0208856C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	add r0, r4, #0
	bl sub_0208DEFC
	add r0, r4, #0
	bl sub_0208B258
	add r0, r4, #0
	bl sub_0208C560
	ldr r0, [r4]
	bl sub_0208877C
	bl sub_02021238
	bl GF_DestroyVramTransferManager
	add r0, r4, #0
	bl sub_02088AF8
	add r0, r4, #0
	bl sub_0208895C
	mov r0, #4
	bl FontID_Release
	ldr r0, _020885D4 ; =0x000007B8
	ldr r0, [r4, r0]
	bl NARC_Delete
	mov r0, #0
	bl FontID_SetAccessLazy
	ldr r0, _020885D8 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	add r0, r5, #0
	bl OverlayManager_FreeData
	mov r0, #0x13
	bl Heap_Destroy
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_020885D4: .word 0x000007B8
_020885D8: .word 0x04000050
	thumb_func_end PokemonSummary_Exit

	thumb_func_start sub_020885DC
sub_020885DC: ; 0x020885DC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	bl DoScheduledBgGpuUpdates
	mov r0, #0x2a
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl PokepicManager_HandleLoadImgAndOrPltt
	bl GF_RunVramTransferTasks
	bl SpriteSystem_TransferOam
	ldr r3, _02088608 ; =OS_IRQTable
	ldr r1, _0208860C ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r4, pc}
	nop
_02088608: .word OS_IRQTable
_0208860C: .word 0x00003FF8
	thumb_func_end sub_020885DC

	thumb_func_start sub_02088610
sub_02088610: ; 0x02088610
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _0208862C ; =_02103990
	add r3, sp, #0
	mov r2, #5
_0208861A:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0208861A
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_0208862C: .word _02103990
	thumb_func_end sub_02088610

	thumb_func_start sub_02088630
sub_02088630: ; 0x02088630
	push {r3, r4, r5, lr}
	sub sp, #0xb8
	ldr r5, _02088760 ; =_021038C4
	add r3, sp, #0xa8
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r5, _02088764 ; =_021038E8
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02088768 ; =_02103904
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
	mov r2, #0
	add r0, r4, #0
	mov r1, #2
	add r3, r2, #0
	bl ScheduleSetBgPosText
	add r0, r4, #0
	mov r1, #2
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	ldr r5, _0208876C ; =_02103920
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
	ldr r5, _02088770 ; =_0210393C
	add r3, sp, #0x38
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
	mov r1, #4
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02088774 ; =_02103958
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02088778 ; =_02103974
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x13
	bl BG_ClearCharDataRange
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x13
	bl BG_ClearCharDataRange
	add sp, #0xb8
	pop {r3, r4, r5, pc}
	nop
_02088760: .word _021038C4
_02088764: .word _021038E8
_02088768: .word _02103904
_0208876C: .word _02103920
_02088770: .word _0210393C
_02088774: .word _02103958
_02088778: .word _02103974
	thumb_func_end sub_02088630

	thumb_func_start sub_0208877C
sub_0208877C: ; 0x0208877C
	push {r4, lr}
	add r4, r0, #0
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
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
	mov r0, #0x13
	add r1, r4, #0
	bl Heap_FreeExplicit
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_0208877C

	thumb_func_start sub_020887C4
sub_020887C4: ; 0x020887C4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #2
	lsl r0, r0, #8
	str r0, [sp]
	mov r0, #0x13
	mov r1, #0
	add r4, r2, #0
	str r0, [sp, #4]
	add r0, r4, #0
	add r2, r1, #0
	add r3, r1, #0
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r1, #0
	mov r0, #0x11
	str r1, [sp]
	lsl r0, r0, #0xa
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0x13
	str r0, [sp, #0xc]
	ldr r2, [r5]
	add r0, r4, #0
	mov r1, #2
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x13
	str r0, [sp, #0xc]
	ldr r2, [r5]
	add r0, r4, #0
	mov r1, #0xd
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #2
	lsl r0, r0, #8
	str r0, [sp]
	mov r0, #0x13
	mov r1, #0
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #4
	add r3, r1, #0
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r1, #0
	mov r0, #0x11
	str r1, [sp]
	lsl r0, r0, #0xa
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0x13
	str r0, [sp, #0xc]
	ldr r2, [r5]
	add r0, r4, #0
	mov r1, #1
	mov r3, #6
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x13
	str r0, [sp, #0xc]
	ldr r2, [r5]
	add r0, r4, #0
	mov r1, #0x14
	mov r3, #5
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x13
	str r0, [sp, #0xc]
	ldr r2, [r5]
	add r0, r4, #0
	mov r1, #0x15
	mov r3, #5
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end sub_020887C4

	thumb_func_start sub_0208887C
sub_0208887C: ; 0x0208887C
	push {r3, lr}
	mov r0, #8
	str r0, [sp]
	ldr r0, _02088890 ; =0x04000050
	mov r1, #1
	mov r2, #0x1e
	mov r3, #0x17
	bl G2x_SetBlendAlpha_
	pop {r3, pc}
	.balign 4, 0
_02088890: .word 0x04000050
	thumb_func_end sub_0208887C

	thumb_func_start sub_02088894
sub_02088894: ; 0x02088894
	push {r4, lr}
	ldr r2, _02088940 ; =0x0000012E
	add r4, r0, #0
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x13
	bl NewMsgDataFromNarc
	mov r1, #0x7a
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r2, #0x6a
	mov r0, #1
	mov r1, #0x1b
	lsl r2, r2, #2
	mov r3, #0x13
	bl NewMsgDataFromNarc
	ldr r1, _02088944 ; =0x000007A4
	mov r2, #0
	str r0, [r4, r1]
	mov r0, #1
	mov r1, #2
	mov r3, #0x13
	bl MessagePrinter_New
	ldr r1, _02088948 ; =0x0000079C
	str r0, [r4, r1]
	mov r0, #0x13
	bl MessageFormat_New
	ldr r1, _0208894C ; =0x000007A8
	str r0, [r4, r1]
	mov r0, #0xc
	mov r1, #0x13
	bl String_New
	mov r1, #0x23
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #0xc
	mov r1, #0x13
	bl String_New
	mov r1, #0x8d
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #8
	mov r1, #0x13
	bl String_New
	mov r1, #0x8e
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x80
	mov r1, #0x13
	bl String_New
	ldr r1, _02088950 ; =0x000007AC
	ldr r2, _02088954 ; =0x000002EE
	str r0, [r4, r1]
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x13
	bl NewMsgDataFromNarc
	ldr r1, _02088958 ; =0x000007B4
	str r0, [r4, r1]
	mov r0, #8
	mov r1, #0x13
	bl String_New
	mov r2, #0x7b
	lsl r2, r2, #4
	str r0, [r4, r2]
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldr r1, [r0, #8]
	cmp r1, #0
	beq _0208893C
	ldr r0, [r4, r2]
	bl CopyU16ArrayToString
_0208893C:
	pop {r4, pc}
	nop
_02088940: .word 0x0000012E
_02088944: .word 0x000007A4
_02088948: .word 0x0000079C
_0208894C: .word 0x000007A8
_02088950: .word 0x000007AC
_02088954: .word 0x000002EE
_02088958: .word 0x000007B4
	thumb_func_end sub_02088894

	thumb_func_start sub_0208895C
sub_0208895C: ; 0x0208895C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _020889BC ; =0x000007B4
	ldr r0, [r4, r0]
	bl DestroyMsgData
	ldr r0, _020889C0 ; =0x000007A4
	ldr r0, [r4, r0]
	bl DestroyMsgData
	mov r0, #0x7a
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl DestroyMsgData
	ldr r0, _020889C4 ; =0x0000079C
	ldr r0, [r4, r0]
	bl MessagePrinter_Delete
	ldr r0, _020889C8 ; =0x000007A8
	ldr r0, [r4, r0]
	bl MessageFormat_Delete
	mov r0, #0x23
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl String_Delete
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	mov r0, #0x8e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _020889CC ; =0x000007AC
	ldr r0, [r4, r0]
	bl String_Delete
	mov r0, #0x7b
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl String_Delete
	pop {r4, pc}
	.balign 4, 0
_020889BC: .word 0x000007B4
_020889C0: .word 0x000007A4
_020889C4: .word 0x0000079C
_020889C8: .word 0x000007A8
_020889CC: .word 0x000007AC
	thumb_func_end sub_0208895C

	thumb_func_start sub_020889D0
sub_020889D0: ; 0x020889D0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r4, r1, #0
	mov r1, #2
	mov r2, #7
	mov r3, #0x13
	bl sub_0201956C
	mov r1, #0x7d
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r2, #6
	str r2, [sp]
	ldr r0, [r5, r1]
	mov r1, #0
	mov r3, #0x11
	bl sub_020195F4
	mov r1, #0
	mov r0, #0x7d
	str r1, [sp]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	add r2, r4, #0
	mov r3, #0x45
	bl sub_020196B8
	mov r2, #6
	mov r0, #0x7d
	str r2, [sp]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	mov r3, #0x11
	bl sub_020195F4
	mov r0, #0
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	add r2, r4, #0
	mov r3, #0x46
	bl sub_020196B8
	mov r0, #4
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #2
	mov r2, #6
	mov r3, #0xa
	bl sub_020195F4
	mov r0, #0
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #2
	add r2, r4, #0
	mov r3, #0x47
	bl sub_020196B8
	mov r0, #4
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #3
	mov r2, #6
	mov r3, #0xa
	bl sub_020195F4
	mov r0, #0
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #3
	add r2, r4, #0
	mov r3, #0x48
	bl sub_020196B8
	mov r0, #0xe
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #4
	mov r2, #6
	mov r3, #0xb
	bl sub_020195F4
	mov r0, #0
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #4
	add r2, r4, #0
	mov r3, #0x49
	bl sub_020196B8
	mov r0, #3
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	mov r2, #6
	ldr r0, [r5, r0]
	mov r1, #5
	add r3, r2, #0
	bl sub_020195F4
	mov r0, #0
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #5
	add r2, r4, #0
	mov r3, #0x4a
	bl sub_020196B8
	mov r1, #6
	mov r0, #3
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	add r2, r1, #0
	add r3, r1, #0
	bl sub_020195F4
	mov r0, #0
	str r0, [sp]
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #6
	add r2, r4, #0
	mov r3, #0x4b
	bl sub_020196B8
	pop {r3, r4, r5, pc}
	thumb_func_end sub_020889D0

	thumb_func_start sub_02088AF8
sub_02088AF8: ; 0x02088AF8
	mov r1, #0x7d
	lsl r1, r1, #4
	ldr r3, _02088B04 ; =sub_020195C0
	ldr r0, [r0, r1]
	bx r3
	nop
_02088B04: .word sub_020195C0
	thumb_func_end sub_02088AF8

	thumb_func_start sub_02088B08
sub_02088B08: ; 0x02088B08
	push {r4, lr}
	add r4, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _02088B3C
	add r0, r4, #0
	bl sub_0208E444
	add r0, r4, #0
	bl sub_02089C50
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #2
	bne _02088B30
	mov r0, #8
	pop {r4, pc}
_02088B30:
	cmp r0, #4
	bne _02088B38
	mov r0, #0x10
	pop {r4, pc}
_02088B38:
	mov r0, #2
	pop {r4, pc}
_02088B3C:
	mov r0, #1
	pop {r4, pc}
	thumb_func_end sub_02088B08

	thumb_func_start sub_02088B40
sub_02088B40: ; 0x02088B40
	push {r4, r5, r6, lr}
	ldr r2, _02088CF8 ; =0x000007BF
	add r5, r0, #0
	ldrb r1, [r5, r2]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1c
	cmp r1, #1
	bne _02088B5E
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	strb r1, [r0, #0x17]
	mov r0, #0x15
	pop {r4, r5, r6, pc}
_02088B5E:
	ldr r3, _02088CFC ; =gSystem
	mov r1, #0x20
	ldr r4, [r3, #0x4c]
	add r6, r4, #0
	tst r6, r1
	beq _02088B74
	sub r1, #0x21
	bl sub_02089E30
	mov r0, #2
	pop {r4, r5, r6, pc}
_02088B74:
	mov r1, #0x10
	tst r1, r4
	beq _02088B84
	mov r1, #1
	bl sub_02089E30
	mov r0, #2
	pop {r4, r5, r6, pc}
_02088B84:
	mov r1, #0x40
	add r6, r4, #0
	tst r6, r1
	beq _02088B96
	sub r1, #0x41
	bl sub_0208A2C0
	mov r0, #0x13
	pop {r4, r5, r6, pc}
_02088B96:
	mov r1, #0x80
	tst r1, r4
	beq _02088BA6
	mov r1, #1
	bl sub_0208A2C0
	mov r0, #0x13
	pop {r4, r5, r6, pc}
_02088BA6:
	ldr r1, [r3, #0x48]
	mov r0, #2
	tst r0, r1
	beq _02088BD2
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	strb r1, [r0, #0x17]
	add r0, r5, #0
	mov r1, #0
	bl sub_0208ADB8
	add r0, r5, #0
	mov r1, #0x15
	bl sub_0208B044
	pop {r4, r5, r6, pc}
_02088BD2:
	mov r0, #1
	tst r0, r1
	beq _02088C12
	sub r0, r2, #3
	ldrsb r0, [r5, r0]
	cmp r0, #1
	beq _02088BE6
	cmp r0, #2
	beq _02088BFA
	b _02088C12
_02088BE6:
	ldr r0, _02088D00 ; =0x0000069B
	bl PlaySE
	ldr r1, _02088D04 ; =0x000007BD
	mov r0, #0xf
	ldrb r2, [r5, r1]
	bic r2, r0
	strb r2, [r5, r1]
	mov r0, #3
	pop {r4, r5, r6, pc}
_02088BFA:
	add r0, r2, #7
	ldrb r0, [r5, r0]
	cmp r0, #0
	beq _02088C12
	ldr r0, _02088D08 ; =0x000005DD
	bl PlaySE
	ldr r0, _02088D0C ; =0x000007C4
	mov r1, #0
	strb r1, [r5, r0]
	mov r0, #0xa
	pop {r4, r5, r6, pc}
_02088C12:
	ldr r0, _02088D10 ; =0x000007BC
	ldrsb r0, [r5, r0]
	cmp r0, #1
	bne _02088C56
	add r0, r5, #0
	bl sub_0208ADCC
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	beq _02088C56
	lsl r0, r4, #1
	add r1, r5, r0
	mov r0, #0x99
	lsl r0, r0, #2
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _02088C56
	ldr r0, _02088D00 ; =0x0000069B
	bl PlaySE
	ldr r2, _02088D04 ; =0x000007BD
	mov r1, #0xf
	ldrb r0, [r5, r2]
	bic r0, r1
	lsl r1, r4, #0x18
	lsr r3, r1, #0x18
	mov r1, #0xf
	and r1, r3
	orr r0, r1
	strb r0, [r5, r2]
	mov r0, #3
	pop {r4, r5, r6, pc}
_02088C56:
	ldr r0, _02088D10 ; =0x000007BC
	ldrsb r0, [r5, r0]
	cmp r0, #2
	bne _02088C88
	add r0, r5, #0
	bl sub_0208AEC4
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	beq _02088C88
	cmp r4, #9
	bge _02088C88
	ldr r0, _02088D14 ; =0x000007C6
	ldrb r0, [r5, r0]
	cmp r4, r0
	bge _02088C88
	ldr r0, _02088D08 ; =0x000005DD
	bl PlaySE
	ldr r0, _02088D0C ; =0x000007C4
	strb r4, [r5, r0]
	mov r0, #0xa
	pop {r4, r5, r6, pc}
_02088C88:
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldrb r0, [r0, #0x11]
	cmp r0, #2
	bne _02088CF0
	add r0, r5, #0
	bl sub_0208AEB4
	cmp r0, #0
	bne _02088CC6
	mov r1, #0
	add r0, r5, #0
	mvn r1, r1
	bl sub_0208A2E0
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _02088CC2
	ldr r0, _02088D08 ; =0x000005DD
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x14
	bl sub_0208B0B0
	pop {r4, r5, r6, pc}
_02088CC2:
	mov r0, #2
	pop {r4, r5, r6, pc}
_02088CC6:
	cmp r0, #1
	bne _02088CF0
	add r0, r5, #0
	mov r1, #1
	bl sub_0208A2E0
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _02088CEC
	ldr r0, _02088D08 ; =0x000005DD
	bl PlaySE
	add r0, r5, #0
	mov r1, #1
	mov r2, #0x14
	bl sub_0208B0B0
	pop {r4, r5, r6, pc}
_02088CEC:
	mov r0, #2
	pop {r4, r5, r6, pc}
_02088CF0:
	add r0, r5, #0
	bl sub_02089E98
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02088CF8: .word 0x000007BF
_02088CFC: .word gSystem
_02088D00: .word 0x0000069B
_02088D04: .word 0x000007BD
_02088D08: .word 0x000005DD
_02088D0C: .word 0x000007C4
_02088D10: .word 0x000007BC
_02088D14: .word 0x000007C6
	thumb_func_end sub_02088B40

	thumb_func_start sub_02088D18
sub_02088D18: ; 0x02088D18
	push {r4, lr}
	add r4, r0, #0
	bl sub_0208A564
	cmp r0, #1
	bne _02088D30
	add r0, r4, #0
	mov r1, #1
	bl sub_0208AFA0
	mov r0, #5
	pop {r4, pc}
_02088D30:
	mov r0, #3
	pop {r4, pc}
	thumb_func_end sub_02088D18

	thumb_func_start sub_02088D34
sub_02088D34: ; 0x02088D34
	push {r3, lr}
	bl sub_0208A63C
	cmp r0, #1
	bne _02088D42
	mov r0, #2
	pop {r3, pc}
_02088D42:
	mov r0, #4
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end sub_02088D34

	thumb_func_start sub_02088D48
sub_02088D48: ; 0x02088D48
	push {r4, lr}
	ldr r1, _02088E58 ; =gSystem
	add r4, r0, #0
	ldr r2, [r1, #0x48]
	mov r1, #0x40
	add r3, r2, #0
	tst r3, r1
	beq _02088D72
	sub r1, #0x41
	bl sub_0208A71C
	cmp r0, #1
	bne _02088D6E
	ldr r0, _02088E5C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl sub_0208A79C
_02088D6E:
	mov r0, #5
	pop {r4, pc}
_02088D72:
	mov r1, #0x80
	tst r1, r2
	beq _02088D92
	mov r1, #1
	bl sub_0208A71C
	cmp r0, #1
	bne _02088D8E
	ldr r0, _02088E5C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl sub_0208A79C
_02088D8E:
	mov r0, #5
	pop {r4, pc}
_02088D92:
	mov r0, #1
	tst r0, r2
	beq _02088DB4
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #1
	beq _02088DB4
	ldr r0, _02088E60 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	bl sub_0208B08C
	pop {r4, pc}
_02088DB4:
	mov r0, #2
	tst r0, r2
	beq _02088DD4
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl sub_0208AFA0
	add r0, r4, #0
	mov r1, #4
	bl sub_0208B044
	pop {r4, pc}
_02088DD4:
	add r0, r4, #0
	bl sub_0208AE08
	cmp r0, #4
	bne _02088DFA
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #1
	beq _02088E52
	ldr r0, _02088E60 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	bl sub_0208B08C
	pop {r4, pc}
_02088DFA:
	cmp r0, #5
	bne _02088E18
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl sub_0208AFA0
	add r0, r4, #0
	mov r1, #4
	bl sub_0208B044
	pop {r4, pc}
_02088E18:
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _02088E52
	lsl r1, r0, #1
	add r2, r4, r1
	mov r1, #0x99
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	cmp r1, #0
	beq _02088E52
	ldr r3, _02088E64 ; =0x000007BD
	mov r2, #0xf
	ldrb r1, [r4, r3]
	lsl r0, r0, #0x18
	bic r1, r2
	lsr r2, r0, #0x18
	mov r0, #0xf
	and r0, r2
	orr r0, r1
	strb r0, [r4, r3]
	ldr r0, _02088E5C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl sub_0208A79C
	mov r0, #5
	pop {r4, pc}
_02088E52:
	mov r0, #5
	pop {r4, pc}
	nop
_02088E58: .word gSystem
_02088E5C: .word 0x000005DC
_02088E60: .word 0x000005DD
_02088E64: .word 0x000007BD
	thumb_func_end sub_02088D48

	thumb_func_start sub_02088E68
sub_02088E68: ; 0x02088E68
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl sub_0208AFA0
	add r0, r4, #0
	bl sub_0208BC78
	ldr r2, _02088E94 ; =0x000007BD
	mov r1, #0xf0
	ldrb r3, [r4, r2]
	add r0, r3, #0
	bic r0, r1
	lsl r1, r3, #0x1c
	lsr r1, r1, #0x1c
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x18
	orr r0, r1
	strb r0, [r4, r2]
	mov r0, #6
	pop {r4, pc}
	nop
_02088E94: .word 0x000007BD
	thumb_func_end sub_02088E68

	thumb_func_start sub_02088E98
sub_02088E98: ; 0x02088E98
	push {r3, r4, r5, lr}
	ldr r1, _02089014 ; =gSystem
	add r5, r0, #0
	ldr r2, [r1, #0x48]
	mov r1, #0x40
	add r3, r2, #0
	tst r3, r1
	beq _02088EC2
	sub r1, #0x41
	bl sub_0208A71C
	cmp r0, #1
	bne _02088EBE
	ldr r0, _02089018 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	bl sub_0208A79C
_02088EBE:
	mov r0, #6
	pop {r3, r4, r5, pc}
_02088EC2:
	mov r1, #0x80
	tst r1, r2
	beq _02088EE2
	mov r1, #1
	bl sub_0208A71C
	cmp r0, #1
	bne _02088EDE
	ldr r0, _02089018 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	bl sub_0208A79C
_02088EDE:
	mov r0, #6
	pop {r3, r4, r5, pc}
_02088EE2:
	mov r1, #1
	add r3, r2, #0
	tst r3, r1
	beq _02088F3E
	bl sub_0208AFA0
	ldr r0, _0208901C ; =0x0000042C
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _02089020 ; =0x000007BD
	ldrb r0, [r5, r0]
	lsl r1, r0, #0x1c
	lsl r0, r0, #0x18
	lsr r1, r1, #0x1c
	lsr r0, r0, #0x1c
	cmp r1, r0
	beq _02088F34
	ldr r0, _02089024 ; =0x000005DD
	bl PlaySE
	add r0, r5, #0
	bl sub_0208A834
	ldr r1, _02089020 ; =0x000007BD
	add r0, r5, #0
	ldrb r2, [r5, r1]
	lsl r1, r2, #0x1c
	lsl r2, r2, #0x18
	lsr r1, r1, #0x1c
	lsr r2, r2, #0x1c
	bl sub_0208BB24
	add r0, r5, #0
	bl sub_0208DB64
	add r0, r5, #0
	bl sub_0208A79C
	b _02088F3A
_02088F34:
	ldr r0, _02089018 ; =0x000005DC
	bl PlaySE
_02088F3A:
	mov r0, #5
	pop {r3, r4, r5, pc}
_02088F3E:
	mov r1, #2
	tst r1, r2
	beq _02088F68
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add r0, r5, #0
	mov r1, #1
	bl sub_0208AFA0
	ldr r0, _0208901C ; =0x0000042C
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	add r0, r5, #0
	mov r1, #5
	bl sub_0208B044
	pop {r3, r4, r5, pc}
_02088F68:
	bl sub_0208ADDC
	add r4, r0, #0
	cmp r4, #4
	bne _02088F96
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add r0, r5, #0
	mov r1, #1
	bl sub_0208AFA0
	ldr r0, _0208901C ; =0x0000042C
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	add r0, r5, #0
	mov r1, #5
	bl sub_0208B044
	pop {r3, r4, r5, pc}
_02088F96:
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	beq _02089010
	lsl r0, r4, #1
	add r1, r5, r0
	mov r0, #0x99
	lsl r0, r0, #2
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _02089010
	add r0, r5, #0
	mov r1, #1
	bl sub_0208AFA0
	ldr r0, _0208901C ; =0x0000042C
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	ldr r2, _02089020 ; =0x000007BD
	ldrb r0, [r5, r2]
	lsl r1, r0, #0x18
	lsr r1, r1, #0x1c
	cmp r4, r1
	beq _02089006
	mov r1, #0xf
	bic r0, r1
	lsl r1, r4, #0x18
	lsr r3, r1, #0x18
	mov r1, #0xf
	and r1, r3
	orr r0, r1
	strb r0, [r5, r2]
	ldr r0, _02089024 ; =0x000005DD
	bl PlaySE
	add r0, r5, #0
	bl sub_0208A834
	ldr r1, _02089020 ; =0x000007BD
	add r0, r5, #0
	ldrb r2, [r5, r1]
	lsl r1, r2, #0x1c
	lsl r2, r2, #0x18
	lsr r1, r1, #0x1c
	lsr r2, r2, #0x1c
	bl sub_0208BB24
	add r0, r5, #0
	bl sub_0208DB64
	add r0, r5, #0
	bl sub_0208A79C
	b _0208900C
_02089006:
	ldr r0, _02089018 ; =0x000005DC
	bl PlaySE
_0208900C:
	mov r0, #5
	pop {r3, r4, r5, pc}
_02089010:
	mov r0, #6
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02089014: .word gSystem
_02089018: .word 0x000005DC
_0208901C: .word 0x0000042C
_02089020: .word 0x000007BD
_02089024: .word 0x000005DD
	thumb_func_end sub_02088E98

	thumb_func_start sub_02089028
sub_02089028: ; 0x02089028
	push {r3, r4, r5, r6, r7, lr}
	ldr r1, _020891F4 ; =gSystem
	add r5, r0, #0
	ldr r2, [r1, #0x48]
	mov r1, #0x40
	add r3, r2, #0
	tst r3, r1
	beq _02089052
	sub r1, #0x41
	bl sub_0208A71C
	cmp r0, #1
	bne _0208904E
	ldr r0, _020891F8 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	bl sub_0208A79C
_0208904E:
	mov r0, #8
	pop {r3, r4, r5, r6, r7, pc}
_02089052:
	mov r1, #0x80
	tst r1, r2
	beq _02089072
	mov r1, #1
	bl sub_0208A71C
	cmp r0, #1
	bne _0208906E
	ldr r0, _020891F8 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	bl sub_0208A79C
_0208906E:
	mov r0, #8
	pop {r3, r4, r5, r6, r7, pc}
_02089072:
	mov r1, #1
	tst r1, r2
	beq _020890D8
	ldr r0, _020891FC ; =0x000005DD
	bl PlaySE
	ldr r0, _02089200 ; =0x000007BD
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	cmp r0, #4
	bne _0208909E
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	mov r2, #4
	strb r2, [r1, #0x16]
	ldr r0, [r5, r0]
	mov r1, #0
	strb r1, [r0, #0x17]
	mov r0, #0x15
	pop {r3, r4, r5, r6, r7, pc}
_0208909E:
	lsl r0, r0, #1
	add r1, r5, r0
	mov r0, #0x99
	lsl r0, r0, #2
	ldrh r0, [r1, r0]
	bl MoveIsHM
	cmp r0, #1
	bne _020890D0
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldrh r0, [r0, #0x18]
	cmp r0, #0
	beq _020890D0
	ldr r0, _02089204 ; =0x0000044C
	mov r1, #0
	ldr r0, [r5, r0]
	bl thunk_Sprite_SetDrawFlag
	add r0, r5, #0
	bl sub_0208DBF0
	mov r0, #8
	pop {r3, r4, r5, r6, r7, pc}
_020890D0:
	add r0, r5, #0
	bl sub_0208AED4
	pop {r3, r4, r5, r6, r7, pc}
_020890D8:
	mov r1, #2
	tst r1, r2
	beq _02089100
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	mov r2, #4
	strb r2, [r1, #0x16]
	ldr r0, [r5, r0]
	mov r1, #1
	strb r1, [r0, #0x17]
	add r0, r5, #0
	mov r1, #0x15
	bl sub_0208B044
	pop {r3, r4, r5, r6, r7, pc}
_02089100:
	bl sub_0208AE48
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	beq _020891F0
	cmp r4, #4
	beq _02089118
	cmp r4, #5
	beq _02089140
	b _02089170
_02089118:
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldrh r0, [r0, #0x18]
	cmp r0, #0
	beq _020891F0
	ldr r0, _020891FC ; =0x000005DD
	bl PlaySE
	ldr r1, _02089200 ; =0x000007BD
	mov r0, #0xf
	ldrb r2, [r5, r1]
	bic r2, r0
	mov r0, #4
	orr r0, r2
	strb r0, [r5, r1]
	add r0, r5, #0
	bl sub_0208A79C
	b _020891F0
_02089140:
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	ldr r1, _02089200 ; =0x000007BD
	mov r0, #0xf
	ldrb r2, [r5, r1]
	bic r2, r0
	mov r0, #5
	orr r0, r2
	strb r0, [r5, r1]
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	mov r2, #4
	strb r2, [r1, #0x16]
	ldr r0, [r5, r0]
	mov r1, #0
	strb r1, [r0, #0x17]
	add r0, r5, #0
	mov r1, #0x15
	bl sub_0208B044
	pop {r3, r4, r5, r6, r7, pc}
_02089170:
	mov r0, #0x99
	lsl r0, r0, #2
	add r6, r5, r0
	lsl r7, r4, #1
	ldrh r0, [r6, r7]
	bl MoveIsHM
	cmp r0, #1
	bne _020891C2
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldrh r0, [r0, #0x18]
	cmp r0, #0
	beq _020891C2
	ldr r0, _020891FC ; =0x000005DD
	bl PlaySE
	ldr r2, _02089200 ; =0x000007BD
	mov r1, #0xf
	ldrb r0, [r5, r2]
	bic r0, r1
	lsl r1, r4, #0x18
	lsr r3, r1, #0x18
	mov r1, #0xf
	and r1, r3
	orr r0, r1
	strb r0, [r5, r2]
	ldr r0, _02089204 ; =0x0000044C
	mov r1, #0
	ldr r0, [r5, r0]
	bl thunk_Sprite_SetDrawFlag
	add r0, r5, #0
	bl sub_0208BBDC
	add r0, r5, #0
	bl sub_0208DBF0
	mov r0, #8
	pop {r3, r4, r5, r6, r7, pc}
_020891C2:
	ldrh r0, [r6, r7]
	cmp r0, #0
	beq _020891F0
	ldr r0, _020891FC ; =0x000005DD
	bl PlaySE
	ldr r2, _02089200 ; =0x000007BD
	mov r1, #0xf
	ldrb r0, [r5, r2]
	bic r0, r1
	lsl r1, r4, #0x18
	lsr r3, r1, #0x18
	mov r1, #0xf
	and r1, r3
	orr r0, r1
	strb r0, [r5, r2]
	add r0, r5, #0
	bl sub_0208A79C
	add r0, r5, #0
	bl sub_0208AED4
	pop {r3, r4, r5, r6, r7, pc}
_020891F0:
	mov r0, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_020891F4: .word gSystem
_020891F8: .word 0x000005DC
_020891FC: .word 0x000005DD
_02089200: .word 0x000007BD
_02089204: .word 0x0000044C
	thumb_func_end sub_02089028

	thumb_func_start sub_02089208
sub_02089208: ; 0x02089208
	push {r4, lr}
	ldr r1, _020892E0 ; =gSystem
	add r4, r0, #0
	ldr r2, [r1, #0x48]
	mov r1, #1
	tst r1, r2
	beq _0208923C
	ldr r0, _020892E4 ; =0x000005DD
	bl PlaySE
	ldr r0, _020892E8 ; =0x000007BD
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1c
	lsr r2, r0, #0x1c
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	strb r2, [r1, #0x16]
	ldr r0, [r4, r0]
	mov r1, #0
	strb r1, [r0, #0x17]
	add r0, r4, #0
	mov r1, #0x15
	bl sub_0208B068
	pop {r4, pc}
_0208923C:
	mov r1, #2
	tst r1, r2
	beq _02089270
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	ldr r0, _020892EC ; =0x00000428
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetAnimCtrlSeq
	ldr r0, _020892F0 ; =0x0000042C
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #0
	bl sub_0208AF08
	add r0, r4, #0
	mov r1, #8
	bl sub_0208B044
	pop {r4, pc}
_02089270:
	bl sub_0208AE88
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _020892DA
	cmp r0, #0
	beq _02089286
	cmp r0, #1
	beq _020892AC
	b _020892DA
_02089286:
	ldr r0, _020892E4 ; =0x000005DD
	bl PlaySE
	ldr r0, _020892E8 ; =0x000007BD
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1c
	lsr r2, r0, #0x1c
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	strb r2, [r1, #0x16]
	ldr r0, [r4, r0]
	mov r1, #0
	strb r1, [r0, #0x17]
	add r0, r4, #0
	mov r1, #0x15
	bl sub_0208B068
	pop {r4, pc}
_020892AC:
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	ldr r0, _020892EC ; =0x00000428
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetAnimCtrlSeq
	ldr r0, _020892F0 ; =0x0000042C
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #0
	bl sub_0208AF08
	add r0, r4, #0
	mov r1, #8
	bl sub_0208B044
	pop {r4, pc}
_020892DA:
	mov r0, #9
	pop {r4, pc}
	nop
_020892E0: .word gSystem
_020892E4: .word 0x000005DD
_020892E8: .word 0x000007BD
_020892EC: .word 0x00000428
_020892F0: .word 0x0000042C
	thumb_func_end sub_02089208

	thumb_func_start sub_020892F4
sub_020892F4: ; 0x020892F4
	push {r3, lr}
	bl sub_0208A9C4
	cmp r0, #1
	bne _02089302
	mov r0, #0xc
	pop {r3, pc}
_02089302:
	mov r0, #0xa
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end sub_020892F4

	thumb_func_start sub_02089308
sub_02089308: ; 0x02089308
	push {r3, lr}
	bl sub_0208AA9C
	cmp r0, #1
	bne _02089316
	mov r0, #2
	pop {r3, pc}
_02089316:
	mov r0, #0xb
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end sub_02089308

	thumb_func_start sub_0208931C
sub_0208931C: ; 0x0208931C
	push {r3, r4, r5, lr}
	ldr r3, _02089418 ; =gSystem
	mov r1, #0x20
	ldr r2, [r3, #0x4c]
	add r4, r0, #0
	add r5, r2, #0
	tst r5, r1
	beq _02089336
	sub r1, #0x21
	bl sub_0208AB58
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_02089336:
	mov r1, #0x10
	tst r1, r2
	beq _02089346
	mov r1, #1
	bl sub_0208AB58
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_02089346:
	mov r1, #0x40
	add r5, r2, #0
	tst r5, r1
	beq _02089358
	sub r1, #0x43
	bl sub_0208AB58
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_02089358:
	mov r1, #0x80
	tst r1, r2
	beq _02089368
	mov r1, #3
	bl sub_0208AB58
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_02089368:
	ldr r2, [r3, #0x48]
	mov r1, #3
	tst r1, r2
	beq _02089382
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xb
	bl sub_0208B0F4
	pop {r3, r4, r5, pc}
_02089382:
	bl sub_0208AEC4
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bgt _02089392
	beq _02089414
	b _020893F8
_02089392:
	cmp r0, #0xb
	bgt _020893F8
	cmp r0, #9
	blt _020893F8
	beq _020893A6
	cmp r0, #0xa
	beq _020893C6
	cmp r0, #0xb
	beq _020893E6
	b _020893F8
_020893A6:
	ldr r0, _0208941C ; =0x00000504
	ldr r0, [r4, r0]
	bl Sprite_GetDrawFlag
	cmp r0, #1
	bne _02089414
	ldr r0, _02089420 ; =0x000005DC
	bl PlaySE
	ldr r0, _0208941C ; =0x00000504
	mov r1, #2
	ldr r0, [r4, r0]
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0xd
	pop {r3, r4, r5, pc}
_020893C6:
	ldr r0, _02089424 ; =0x00000508
	ldr r0, [r4, r0]
	bl Sprite_GetDrawFlag
	cmp r0, #1
	bne _02089414
	ldr r0, _02089420 ; =0x000005DC
	bl PlaySE
	ldr r0, _02089424 ; =0x00000508
	mov r1, #3
	ldr r0, [r4, r0]
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0xe
	pop {r3, r4, r5, pc}
_020893E6:
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xb
	bl sub_0208B0F4
	pop {r3, r4, r5, pc}
_020893F8:
	ldr r1, _02089428 ; =0x000007C4
	ldrb r2, [r4, r1]
	cmp r2, r0
	beq _02089410
	strb r0, [r4, r1]
	ldr r0, _02089420 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl sub_0208AB58
_02089410:
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_02089414:
	mov r0, #0xc
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02089418: .word gSystem
_0208941C: .word 0x00000504
_02089420: .word 0x000005DC
_02089424: .word 0x00000508
_02089428: .word 0x000007C4
	thumb_func_end sub_0208931C

	thumb_func_start sub_0208942C
sub_0208942C: ; 0x0208942C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02089450 ; =0x00000504
	ldr r0, [r4, r0]
	bl Sprite_IsAnimated
	cmp r0, #0
	bne _0208944A
	mov r1, #8
	add r0, r4, #0
	mvn r1, r1
	bl sub_0208AB58
	mov r0, #0xc
	pop {r4, pc}
_0208944A:
	mov r0, #0xd
	pop {r4, pc}
	nop
_02089450: .word 0x00000504
	thumb_func_end sub_0208942C

	thumb_func_start sub_02089454
sub_02089454: ; 0x02089454
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02089474 ; =0x00000508
	ldr r0, [r4, r0]
	bl Sprite_IsAnimated
	cmp r0, #0
	bne _02089470
	add r0, r4, #0
	mov r1, #9
	bl sub_0208AB58
	mov r0, #0xc
	pop {r4, pc}
_02089470:
	mov r0, #0xe
	pop {r4, pc}
	.balign 4, 0
_02089474: .word 0x00000508
	thumb_func_end sub_02089454

	thumb_func_start sub_02089478
sub_02089478: ; 0x02089478
	push {r4, r5, r6, lr}
	sub sp, #8
	ldr r1, _020895E8 ; =gSystem
	add r5, r0, #0
	ldr r2, [r1, #0x48]
	mov r1, #3
	tst r1, r2
	bne _0208948A
	b _020895E0
_0208948A:
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	ldrb r1, [r1, #0x11]
	cmp r1, #2
	bne _020894AE
	bl sub_0208A520
	add r6, r0, #0
	mov r0, #0x13
	bl AllocMonZeroed
	add r4, r0, #0
	add r0, r6, #0
	add r1, r4, #0
	bl CopyBoxPokemonToPokemon
	b _020894B4
_020894AE:
	bl sub_0208A520
	add r4, r0, #0
_020894B4:
	ldr r0, _020895EC ; =0x000007BE
	mov r2, #0
	strb r2, [r5, r0]
	ldr r0, _020895F0 ; =0x00000275
	mov r1, #0x13
	ldrb r6, [r5, r0]
	add r0, r4, #0
	bl GetMonData
	ldr r1, _020895F0 ; =0x00000275
	strb r0, [r5, r1]
	ldrb r0, [r5, r1]
	cmp r6, r0
	beq _020894DA
	ldr r1, _020895EC ; =0x000007BE
	mov r0, #1
	ldrb r2, [r5, r1]
	orr r0, r2
	strb r0, [r5, r1]
_020894DA:
	ldr r0, _020895F4 ; =0x00000276
	mov r1, #0x14
	ldrb r6, [r5, r0]
	add r0, r4, #0
	mov r2, #0
	bl GetMonData
	ldr r1, _020895F4 ; =0x00000276
	strb r0, [r5, r1]
	ldrb r0, [r5, r1]
	cmp r6, r0
	beq _020894FC
	ldr r1, _020895EC ; =0x000007BE
	mov r0, #2
	ldrb r2, [r5, r1]
	orr r0, r2
	strb r0, [r5, r1]
_020894FC:
	ldr r0, _020895F8 ; =0x00000277
	mov r1, #0x15
	ldrb r6, [r5, r0]
	add r0, r4, #0
	mov r2, #0
	bl GetMonData
	ldr r1, _020895F8 ; =0x00000277
	strb r0, [r5, r1]
	ldrb r0, [r5, r1]
	cmp r6, r0
	beq _0208951E
	ldr r1, _020895EC ; =0x000007BE
	mov r0, #4
	ldrb r2, [r5, r1]
	orr r0, r2
	strb r0, [r5, r1]
_0208951E:
	mov r0, #0x9e
	lsl r0, r0, #2
	ldrb r6, [r5, r0]
	add r0, r4, #0
	mov r1, #0x16
	mov r2, #0
	bl GetMonData
	mov r1, #0x9e
	lsl r1, r1, #2
	strb r0, [r5, r1]
	ldrb r0, [r5, r1]
	cmp r6, r0
	beq _02089544
	ldr r1, _020895EC ; =0x000007BE
	mov r0, #8
	ldrb r2, [r5, r1]
	orr r0, r2
	strb r0, [r5, r1]
_02089544:
	ldr r0, _020895FC ; =0x00000279
	mov r1, #0x17
	ldrb r6, [r5, r0]
	add r0, r4, #0
	mov r2, #0
	bl GetMonData
	ldr r1, _020895FC ; =0x00000279
	strb r0, [r5, r1]
	ldrb r0, [r5, r1]
	cmp r6, r0
	beq _02089566
	ldr r1, _020895EC ; =0x000007BE
	mov r0, #0x10
	ldrb r2, [r5, r1]
	orr r0, r2
	strb r0, [r5, r1]
_02089566:
	add r0, r4, #0
	mov r1, #0x18
	mov r2, #0
	bl GetMonData
	ldr r1, _02089600 ; =0x0000027A
	strb r0, [r5, r1]
	sub r1, #0x4e
	ldr r0, [r5, r1]
	ldrb r0, [r0, #0x11]
	cmp r0, #2
	bne _02089584
	add r0, r4, #0
	bl Heap_Free
_02089584:
	mov r1, #7
	mov r0, #0
	lsl r1, r1, #6
	mov r2, #0x13
	bl LoadFontPal1
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0, #4]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x13
	str r0, [sp, #4]
	ldr r0, [r5]
	ldr r2, _02089604 ; =0x000003E2
	mov r1, #1
	mov r3, #0xd
	bl LoadUserFrameGfx2
	ldr r0, _020895EC ; =0x000007BE
	ldrb r0, [r5, r0]
	cmp r0, #0
	bne _020895C8
	add r0, r5, #0
	mov r1, #0xfe
	bl sub_0208DDA0
	add sp, #8
	mov r0, #0x12
	pop {r4, r5, r6, pc}
_020895C8:
	add r0, r5, #0
	bl sub_0208E174
	add r0, r5, #0
	bl sub_0208BCD4
	add r0, r5, #0
	bl sub_0208BDC8
	add sp, #8
	mov r0, #0x11
	pop {r4, r5, r6, pc}
_020895E0:
	mov r0, #0x10
	add sp, #8
	pop {r4, r5, r6, pc}
	nop
_020895E8: .word gSystem
_020895EC: .word 0x000007BE
_020895F0: .word 0x00000275
_020895F4: .word 0x00000276
_020895F8: .word 0x00000277
_020895FC: .word 0x00000279
_02089600: .word 0x0000027A
_02089604: .word 0x000003E2
	thumb_func_end sub_02089478

	thumb_func_start sub_02089608
sub_02089608: ; 0x02089608
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _02089650 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _0208964A
	ldr r0, _02089654 ; =0x000007BE
	mov r1, #0
	ldrb r2, [r5, r0]
	mov r0, #1
_0208961E:
	add r4, r0, #0
	lsl r4, r1
	add r3, r2, #0
	tst r3, r4
	beq _02089640
	add r0, r5, #0
	bl sub_0208DDA0
	ldr r0, _02089654 ; =0x000007BE
	ldrb r1, [r5, r0]
	eor r1, r4
	strb r1, [r5, r0]
	ldrb r0, [r5, r0]
	cmp r0, #0
	bne _0208964A
	mov r0, #0x12
	pop {r3, r4, r5, pc}
_02089640:
	add r1, r1, #1
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	cmp r1, #5
	blo _0208961E
_0208964A:
	mov r0, #0x11
	pop {r3, r4, r5, pc}
	nop
_02089650: .word gSystem
_02089654: .word 0x000007BE
	thumb_func_end sub_02089608

	thumb_func_start sub_02089658
sub_02089658: ; 0x02089658
	ldr r0, _0208966C ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _02089666
	mov r0, #0x15
	bx lr
_02089666:
	mov r0, #0x12
	bx lr
	nop
_0208966C: .word gSystem
	thumb_func_end sub_02089658

	thumb_func_start sub_02089670
sub_02089670: ; 0x02089670
	push {r3, lr}
	mov r0, #1
	mov r1, #0x13
	bl sub_020880CC
	mov r0, #0x16
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end sub_02089670

	thumb_func_start sub_02089680
sub_02089680: ; 0x02089680
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _0208968E
	mov r0, #1
	b _02089690
_0208968E:
	mov r0, #0
_02089690:
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end sub_02089680

	thumb_func_start sub_02089698
sub_02089698: ; 0x02089698
	push {r3, r4, lr}
	sub sp, #0xc
	ldr r3, _02089788 ; =0x000007BE
	add r4, r0, #0
	ldrb r0, [r4, r3]
	cmp r0, #0
	beq _020896B0
	cmp r0, #1
	beq _020896F6
	cmp r0, #2
	beq _0208975E
	b _02089782
_020896B0:
	add r0, r3, #0
	add r0, #0xc
	ldrb r0, [r4, r0]
	add r1, r3, #0
	add r2, r3, #0
	str r0, [sp]
	add r0, r3, #0
	add r0, #0xd
	ldrb r0, [r4, r0]
	add r1, #0xf
	add r2, #0xa
	str r0, [sp, #4]
	add r0, r3, #0
	add r0, #0xe
	ldrb r0, [r4, r0]
	add r3, #0xb
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	str r0, [sp, #8]
	ldrb r1, [r4, r1]
	ldrb r2, [r4, r2]
	ldrb r3, [r4, r3]
	ldr r0, [r4]
	bl BgTilemapRectChangePalette
	ldr r1, _0208978C ; =0x000007CD
	ldr r0, [r4]
	ldrb r1, [r4, r1]
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, _02089788 ; =0x000007BE
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _02089782
_020896F6:
	add r0, r3, #0
	add r0, #0x10
	ldrb r0, [r4, r0]
	add r1, r0, #1
	add r0, r3, #0
	add r0, #0x10
	strb r1, [r4, r0]
	add r0, r3, #0
	add r0, #0x10
	ldrb r0, [r4, r0]
	cmp r0, #4
	bne _02089782
	add r0, r3, #0
	add r0, #0xc
	ldrb r0, [r4, r0]
	add r1, r3, #0
	add r2, r3, #0
	str r0, [sp]
	add r0, r3, #0
	add r0, #0xd
	ldrb r0, [r4, r0]
	add r1, #0xf
	add r2, #0xa
	str r0, [sp, #4]
	add r0, r3, #0
	add r0, #0xe
	ldrb r0, [r4, r0]
	add r3, #0xb
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1c
	str r0, [sp, #8]
	ldrb r1, [r4, r1]
	ldrb r2, [r4, r2]
	ldrb r3, [r4, r3]
	ldr r0, [r4]
	bl BgTilemapRectChangePalette
	ldr r1, _0208978C ; =0x000007CD
	ldr r0, [r4]
	ldrb r1, [r4, r1]
	bl ScheduleBgTilemapBufferTransfer
	ldr r1, _02089790 ; =0x000007CE
	mov r0, #0
	strb r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x10
	ldrb r0, [r4, r0]
	sub r1, #0x10
	add r0, r0, #1
	strb r0, [r4, r1]
	b _02089782
_0208975E:
	add r0, r3, #0
	add r0, #0x10
	ldrb r0, [r4, r0]
	add r1, r0, #1
	add r0, r3, #0
	add r0, #0x10
	strb r1, [r4, r0]
	add r0, r3, #0
	add r0, #0x10
	ldrb r0, [r4, r0]
	cmp r0, #2
	bne _02089782
	mov r0, #0
	strb r0, [r4, r3]
	add r3, #0x11
	add sp, #0xc
	ldrb r0, [r4, r3]
	pop {r3, r4, pc}
_02089782:
	mov r0, #0xf
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_02089788: .word 0x000007BE
_0208978C: .word 0x000007CD
_02089790: .word 0x000007CE
	thumb_func_end sub_02089698

	thumb_func_start sub_02089794
sub_02089794: ; 0x02089794
	push {r4, lr}
	ldr r1, _020897BC ; =0x000007C9
	add r4, r0, #0
	ldrb r1, [r4, r1]
	cmp r1, #5
	bne _020897AA
	mov r1, #0
	mvn r1, r1
	bl sub_0208A2C0
	b _020897B0
_020897AA:
	mov r1, #1
	bl sub_0208A2C0
_020897B0:
	add r0, r4, #0
	bl sub_0208B118
	mov r0, #0x13
	pop {r4, pc}
	nop
_020897BC: .word 0x000007C9
	thumb_func_end sub_02089794

	thumb_func_start sub_020897C0
sub_020897C0: ; 0x020897C0
	push {r4, lr}
	add r4, r0, #0
	bl sub_0208A520
	mov r2, #0x8b
	lsl r2, r2, #2
	add r1, r0, #0
	ldr r0, [r4, r2]
	ldrb r0, [r0, #0x11]
	cmp r0, #2
	bne _020897E2
	add r2, r2, #4
	add r0, r4, #0
	add r2, r4, r2
	bl sub_020897F0
	pop {r4, pc}
_020897E2:
	add r2, r2, #4
	add r0, r4, #0
	add r2, r4, r2
	bl sub_0208981C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_020897C0

	thumb_func_start sub_020897F0
sub_020897F0: ; 0x020897F0
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x13
	add r6, r1, #0
	add r7, r2, #0
	bl AllocMonZeroed
	add r4, r0, #0
	add r0, r6, #0
	add r1, r4, #0
	bl CopyBoxPokemonToPokemon
	add r0, r5, #0
	add r1, r4, #0
	add r2, r7, #0
	bl sub_0208981C
	add r0, r4, #0
	bl Heap_Free
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end sub_020897F0
