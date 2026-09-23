#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "unk_020755E8.inc"
	.include "global.inc"

	.text

	thumb_func_start sub_02076C90
sub_02076C90: ; 0x02076C90
	push {r4, r5, r6, lr}
	sub sp, #0x20
	add r4, r0, #0
	ldr r0, [r4, #0x78]
	cmp r0, #6
	bgt _02076CA4
	bne _02076CA0
	b _02076E50
_02076CA0:
	add sp, #0x20
	pop {r4, r5, r6, pc}
_02076CA4:
	sub r0, #0xd
	cmp r0, #6
	bhi _02076CE4
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02076CB6: ; jump table
	.short _02076CC4 - _02076CB6 - 2 ; case 0
	.short _02076CC4 - _02076CB6 - 2 ; case 1
	.short _02076E5E - _02076CB6 - 2 ; case 2
	.short _02076E5E - _02076CB6 - 2 ; case 3
	.short _02076E5E - _02076CB6 - 2 ; case 4
	.short _02076E50 - _02076CB6 - 2 ; case 5
	.short _02076E50 - _02076CB6 - 2 ; case 6
_02076CC4:
	ldr r0, [r4, #0x4c]
	ldr r2, [r4, #0x5c]
	mov r1, #4
	bl Bag_GetQuantity
	cmp r0, #0
	beq _02076CE4
	ldr r0, [r4, #0x24]
	bl Party_GetCount
	add r5, r0, #0
	ldr r0, [r4, #0x24]
	bl Party_GetMaxCount
	cmp r5, r0
	blt _02076CE6
_02076CE4:
	b _02076E5E
_02076CE6:
	ldr r0, [r4, #0x5c]
	bl AllocMonZeroed
	add r5, r0, #0
	ldr r0, [r4, #0x28]
	add r1, r5, #0
	bl CopyPokemonToPokemon
	mov r0, #0x49
	lsl r0, r0, #2
	str r0, [sp]
	add r0, r5, #0
	mov r1, #MON_DATA_SPECIES
	add r2, sp, #0
	bl SetMonData
	mov r0, #4
	str r0, [sp]
	add r0, r5, #0
	mov r1, #MON_DATA_POKEBALL
	add r2, sp, #0
	bl SetMonData
	mov r0, #0
	str r0, [sp]
	add r0, r5, #0
	mov r1, #MON_DATA_HELD_ITEM
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #MON_DATA_MARKINGS
	add r2, sp, #0
	bl SetMonData
	mov r1, #MON_DATA_SINNOH_CHAMP_RIBBON
	str r1, [sp, #4]
	add r6, sp, #0
_02076D32:
	add r0, r5, #0
	add r2, r6, #0
	bl SetMonData
	ldr r0, [sp, #4]
	add r1, r0, #1
	str r1, [sp, #4]
	cmp r1, #0x36
	blt _02076D32
	mov r1, #MON_DATA_COOL_RIBBON
	str r1, [sp, #4]
	add r6, sp, #0
_02076D4A:
	add r0, r5, #0
	add r2, r6, #0
	bl SetMonData
	ldr r0, [sp, #4]
	add r1, r0, #1
	str r1, [sp, #4]
	cmp r1, #0x6e
	blt _02076D4A
	mov r1, #MON_DATA_SUPER_COOL_RIBBON
	str r1, [sp, #4]
	add r6, sp, #0
_02076D62:
	add r0, r5, #0
	add r2, r6, #0
	bl SetMonData
	ldr r0, [sp, #4]
	add r1, r0, #1
	str r1, [sp, #4]
	cmp r1, #0x90
	blt _02076D62
	add r0, r5, #0
	mov r1, #MON_DATA_SHINY_LEAF_A
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #MON_DATA_SHINY_LEAF_B
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #MON_DATA_SHINY_LEAF_C
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #MON_DATA_SHINY_LEAF_D
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #MON_DATA_SHINY_LEAF_E
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #MON_DATA_SHINY_LEAF_CROWN
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #MON_DATA_MOOD
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #0xb3
	mov r2, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #0x4d
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #0xa0
	add r2, sp, #0
	bl SetMonData
	ldr r0, [r4, #0x5c]
	bl Mail_New
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #0xaa
	add r2, r6, #0
	bl SetMonData
	add r0, r6, #0
	bl Heap_Free
	add r0, r5, #0
	mov r1, #0xa2
	add r2, sp, #0
	bl SetMonData
	mov r0, #0
	add r1, sp, #8
	mov r2, #0x18
	bl MIi_CpuClearFast
	add r0, r5, #0
	mov r1, #0xab
	add r2, sp, #8
	bl SetMonData
	add r0, r5, #0
	bl UpdateMonAbility
	add r0, r5, #0
	bl CalcMonLevelAndStats
	ldr r0, [r4, #0x24]
	add r1, r5, #0
	bl Party_AddMon
	ldr r0, [r4, #0x48]
	add r1, r5, #0
	bl Pokedex_SetMonCaughtFlag
	ldr r0, [r4, #0x50]
	mov r1, #0xd ; GAME_STAT_UNIQUE_MONS_CAUGHT
	bl GameStats_Inc
	ldr r0, [r4, #0x50]
	mov r1, #0x15 ; SCORE_EVENT_REGISTER_SPECIES_CAUGHT
	bl GameStats_AddScore
	add r0, r5, #0
	bl Heap_Free
	ldr r0, [r4, #0x4c]
	ldr r3, [r4, #0x5c]
	mov r1, #4
	mov r2, #1
	bl Bag_TakeItem
	add sp, #0x20
	pop {r4, r5, r6, pc}
_02076E50:
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, [r4, #0x28]
	mov r1, #6
	add r2, sp, #4
	bl SetMonData
_02076E5E:
	add sp, #0x20
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end sub_02076C90

	thumb_func_start sub_02076E64
sub_02076E64: ; 0x02076E64
	push {r4, r5, r6, lr}
	sub sp, #0xf0
	add r5, r0, #0
	add r4, r1, #0
	bl GfGfx_DisableEngineAPlanes
	ldr r6, _02077180 ; =_020FFF34
	add r3, sp, #0x20
	mov r2, #5
_02076E76:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _02076E76
	add r0, sp, #0x20
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
	ldr r6, _02077184 ; =_020FFED8
	add r3, sp, #0x10
	add r2, r3, #0
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r6, _02077188 ; =_020FFF90
	add r3, sp, #0x9c
	mov r2, #0xa
_02076ED6:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _02076ED6
	ldr r0, [r6]
	mov r1, #1
	str r0, [r3]
	add r0, r4, #0
	add r2, sp, #0x9c
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #2
	add r2, sp, #0xb8
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #3
	add r2, sp, #0xd4
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r1, _0207718C ; =0x04000008
	mov r0, #3
	ldrh r2, [r1]
	bic r2, r0
	mov r0, #1
	orr r2, r0
	strh r2, [r1]
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	ldr r6, _02077190 ; =_020FFFE4
	add r3, sp, #0x48
	mov r2, #0xa
_02076F38:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _02076F38
	ldr r0, [r6]
	mov r1, #4
	str r0, [r3]
	add r0, r4, #0
	add r2, sp, #0x48
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #5
	add r2, sp, #0x64
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #6
	add r2, sp, #0x80
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x2c]
	bl Options_GetFrame
	add r6, r0, #0
	lsl r0, r6, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldr r0, [r5, #0x5c]
	mov r1, #1
	str r0, [sp, #4]
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0xa
	bl sub_0200EB80
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5, #0x5c]
	add r2, r4, #0
	str r0, [sp, #0xc]
	mov r0, #0x73
	mov r3, #3
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r1, #1
	str r1, [sp, #8]
	ldr r0, [r5, #0x5c]
	add r2, r4, #0
	str r0, [sp, #0xc]
	mov r0, #0x73
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
	mov r1, #0
	str r1, [sp]
	mov r0, #0x40
	str r0, [sp, #4]
	str r1, [sp, #8]
	ldr r0, [r5, #0x14]
	ldr r3, [r5, #0x5c]
	mov r1, #0x73
	mov r2, #8
	bl PaletteData_LoadNarc
	add r0, r6, #0
	bl sub_0200E640
	add r2, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xa0
	str r0, [sp, #8]
	ldr r0, [r5, #0x14]
	ldr r3, [r5, #0x5c]
	mov r1, #0x26
	bl PaletteData_LoadNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xb0
	str r0, [sp, #8]
	ldr r0, [r5, #0x14]
	ldr r3, [r5, #0x5c]
	mov r1, #0x10
	mov r2, #8
	bl PaletteData_LoadNarc
	ldr r0, [r5, #0x5c]
	mov r1, #2
	str r0, [sp]
	ldr r0, [r5]
	mov r2, #1
	mov r3, #0
	bl sub_0200E398
	bl sub_0200E3D8
	add r2, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x80
	str r0, [sp, #8]
	ldr r0, [r5, #0x14]
	ldr r3, [r5, #0x5c]
	mov r1, #0x26
	bl PaletteData_LoadNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #0xa0
	str r0, [sp, #4]
	mov r2, #0
	str r2, [sp, #8]
	ldr r0, [r5, #0x14]
	ldr r3, [r5, #0x5c]
	mov r1, #0xef
	bl PaletteData_LoadNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x90
	str r0, [sp, #8]
	ldr r0, [r5, #0x14]
	ldr r3, [r5, #0x5c]
	mov r1, #0xef
	mov r2, #0xf
	bl PaletteData_LoadNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xf0
	str r0, [sp, #8]
	ldr r0, [r5, #0x14]
	ldr r3, [r5, #0x5c]
	mov r1, #0x10
	mov r2, #9
	bl PaletteData_LoadNarc
	ldr r1, [r5, #0x5c]
	mov r0, #0xef
	bl NARC_New
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	str r1, [sp, #8]
	ldr r1, [r5, #0x5c]
	add r2, r4, #0
	str r1, [sp, #0xc]
	mov r1, #0x10
	mov r3, #4
	add r6, r0, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5, #0x5c]
	mov r1, #0x11
	str r0, [sp, #0xc]
	add r0, r6, #0
	add r2, r4, #0
	mov r3, #4
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5, #0x5c]
	mov r1, #1
	str r0, [sp, #0xc]
	add r0, r6, #0
	add r2, r4, #0
	mov r3, #5
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5, #0x5c]
	mov r1, #0xa
	str r0, [sp, #0xc]
	add r0, r6, #0
	add r2, r4, #0
	mov r3, #5
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add r0, r6, #0
	bl NARC_Delete
	mov r0, #5
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #6
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #1
	lsl r0, r0, #0x1a
	ldr r1, [r0]
	ldr r2, _02077194 ; =0xFFFF1FFF
	add r3, r1, #0
	and r3, r2
	lsr r1, r0, #0xd
	orr r1, r3
	ldr r3, _02077198 ; =0x04001000
	str r1, [r0]
	ldr r1, [r3]
	and r1, r2
	str r1, [r3]
	add r3, r0, #0
	add r3, #0x48
	ldrh r4, [r3]
	mov r1, #0x3f
	mov r2, #0x1f
	bic r4, r1
	orr r2, r4
	strh r2, [r3]
	add r0, #0x4a
	ldrh r2, [r0]
	bic r2, r1
	mov r1, #0x12
	orr r1, r2
	strh r1, [r0]
	add r0, r5, #0
	mov r1, #0
	add r0, #0x72
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x73
	strb r1, [r0]
	add r0, r5, #0
	mov r1, #0xff
	add r0, #0x74
	strb r1, [r0]
	add r0, r5, #0
	mov r1, #0xa0
	add r0, #0x75
	strb r1, [r0]
	bl GfGfx_BothDispOn
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, _0207719C ; =sub_02077270
	add r1, r5, #0
	bl Main_SetVBlankIntrCB
	add sp, #0xf0
	pop {r4, r5, r6, pc}
	nop
_02077180: .word _020FFF34
_02077184: .word _020FFED8
_02077188: .word _020FFF90
_0207718C: .word 0x04000008
_02077190: .word _020FFFE4
_02077194: .word 0xFFFF1FFF
_02077198: .word 0x04001000
_0207719C: .word sub_02077270
	thumb_func_end sub_02076E64

	thumb_func_start sub_020771A0
sub_020771A0: ; 0x020771A0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #2
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r4, #0
	mov r1, #1
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #2
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #3
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #6
	bl FreeBgTilemapBuffer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_020771A0

	thumb_func_start sub_020771E8
sub_020771E8: ; 0x020771E8
	push {r3, r4, r5, lr}
	sub sp, #0x20
	add r4, r0, #0
	ldr r1, [r4, #0x28]
	add r0, sp, #0x10
	mov r2, #2
	bl GetPokemonSpriteCharAndPlttNarcIds
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	add r1, sp, #0x10
	mov r2, #0x80
	mov r3, #0x50
	bl PokepicManager_CreatePokepic
	str r0, [r4, #0x1c]
	ldr r0, [r4, #0x5c]
	bl AllocMonZeroed
	add r5, r0, #0
	ldr r0, [r4, #0x28]
	add r1, r5, #0
	bl CopyPokemonToPokemon
	add r2, r4, #0
	add r0, r5, #0
	mov r1, #5
	add r2, #0x62
	bl SetMonData
	add r0, r5, #0
	bl CalcMonLevelAndStats
	add r0, sp, #0x10
	add r1, r5, #0
	mov r2, #2
	bl GetPokemonSpriteCharAndPlttNarcIds
	add r0, r5, #0
	bl Heap_Free
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	add r1, sp, #0x10
	mov r2, #0x80
	mov r3, #0x50
	bl PokepicManager_CreatePokepic
	str r0, [r4, #0x20]
	mov r1, #0xc
	mov r2, #0
	bl Pokepic_SetAttr
	ldr r0, [r4, #0x20]
	mov r1, #0xd
	mov r2, #0
	bl Pokepic_SetAttr
	add sp, #0x20
	pop {r3, r4, r5, pc}
	thumb_func_end sub_020771E8

	thumb_func_start sub_02077270
sub_02077270: ; 0x02077270
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r0, #0x75
	ldrb r2, [r0]
	add r0, r4, #0
	add r0, #0x73
	ldrb r1, [r0]
	add r0, r4, #0
	add r0, #0x72
	ldrb r0, [r0]
	mov r3, #0xff
	lsl r3, r3, #8
	lsl r0, r0, #8
	add r5, r0, #0
	add r0, r4, #0
	add r0, #0x74
	lsl r1, r1, #8
	and r1, r3
	ldrb r0, [r0]
	and r5, r3
	orr r1, r2
	orr r5, r0
	ldr r0, _020772EC ; =0x04000040
	strh r5, [r0]
	strh r1, [r0, #4]
	ldr r0, [r4, #0x18]
	bl PokepicManager_HandleLoadImgAndOrPltt
	add r0, r4, #0
	add r0, #0xb8
	ldr r0, [r0]
	cmp r0, #0
	beq _020772CE
	add r0, r4, #0
	add r0, #0xb0
	ldr r0, [r0]
	cmp r0, #0
	bne _020772C0
	bl GF_AssertFail
_020772C0:
	add r0, r4, #0
	add r0, #0xb0
	ldr r0, [r0]
	bl SpriteSystem_DrawSprites
	bl SpriteSystem_TransferOam
_020772CE:
	bl GF_RunVramTransferTasks
	ldr r0, [r4, #0x14]
	bl PaletteData_PushTransparentBuffers
	ldr r0, [r4]
	bl DoScheduledBgGpuUpdates
	ldr r3, _020772F0 ; =OS_IRQTable
	ldr r1, _020772F4 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_020772EC: .word 0x04000040
_020772F0: .word OS_IRQTable
_020772F4: .word 0x00003FF8
	thumb_func_end sub_02077270

	thumb_func_start sub_020772F8
sub_020772F8: ; 0x020772F8
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, [r4, #8]
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r0, [r4, #0xc]
	ldr r1, [r4, #0x10]
	add r2, r5, #0
	bl StringExpandPlaceholders
	add r0, r5, #0
	bl Heap_Free
	ldr r0, [r4, #4]
	mov r1, #0xff
	bl FillWindowPixelBuffer
	ldr r0, [r4, #0x2c]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	ldr r0, _0207733C ; =sub_02077340
	mov r1, #1
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	ldr r2, [r4, #0x10]
	bl AddTextPrinterParameterized
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0207733C: .word sub_02077340
	thumb_func_end sub_020772F8

	thumb_func_start sub_02077340
sub_02077340: ; 0x02077340
	push {r4, lr}
	mov r4, #0
	cmp r1, #5
	bhi _02077388
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02077354: ; jump table
	.short _02077388 - _02077354 - 2 ; case 0
	.short _02077360 - _02077354 - 2 ; case 1
	.short _02077368 - _02077354 - 2 ; case 2
	.short _02077370 - _02077354 - 2 ; case 3
	.short _02077378 - _02077354 - 2 ; case 4
	.short _02077380 - _02077354 - 2 ; case 5
_02077360:
	bl GF_IsAnySEPlaying
	add r4, r0, #0
	b _02077388
_02077368:
	bl IsFanfarePlaying
	add r4, r0, #0
	b _02077388
_02077370:
	ldr r0, _0207738C ; =0x000004A4
	bl PlayFanfare
	b _02077388
_02077378:
	ldr r0, _02077390 ; =0x000005E6
	bl PlaySE
	b _02077388
_02077380:
	mov r0, #0x4a
	lsl r0, r0, #4
	bl PlayFanfare
_02077388:
	add r0, r4, #0
	pop {r4, pc}
	.balign 4, 0
_0207738C: .word 0x000004A4
_02077390: .word 0x000005E6
	thumb_func_end sub_02077340

	thumb_func_start sub_02077394
sub_02077394: ; 0x02077394
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _020773A8 ; =gOverlayTemplate_PokemonSummary
	ldr r1, [r4, #0x3c]
	ldr r2, [r4, #0x5c]
	bl OverlayManager_New
	str r0, [r4, #0x38]
	pop {r4, pc}
	nop
_020773A8: .word gOverlayTemplate_PokemonSummary
	thumb_func_end sub_02077394
