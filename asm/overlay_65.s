#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_65.inc"
	.include "global.inc"

.public ov65_0221D674
.public ov65_0221D8C4
.public ov65_0221D930
.public ov65_0221DCBC
.public ov65_0221DD34
.public ov65_0221DDC0
.public ov65_0221DE10
.public ov65_0221DE24
.public ov65_0221DE64
.public ov65_0221DE8C
.public ov65_0221DEA0
.public ov65_0221DF0C
.public ov65_0221E050
.public ov65_0221E06C
.public ov65_0221F714
.public ov65_0221F760
.public ov65_0221F780
.public ov65_0221F850
.public ov65_0221F864
.public ov65_0221F8D0
.public ov65_0221FAE0
.public ov65_0221FB4C
.public ov65_0221FB90
.public ov65_0221FD48
.public ov65_0221FD58
.public ov65_0221FD80
.public ov65_0221FD9C
.public ov65_0221FDB8
.public ov65_0221FDD4
.public ov65_0221FDF0
.public ov65_0221FE0C
.public ov65_0221FE28
.public ov65_0221FE44
.public ov65_0221FEEC

	.text

	thumb_func_start WirelessTradeSelectMon_Init
WirelessTradeSelectMon_Init: ; 0x0221BE20
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r6, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _0221BF9C ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _0221BFA0 ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	ldr r2, _0221BFA4 ; =0x00070FA0
	mov r0, #3
	mov r1, #0x1a
	bl Heap_Create
	mov r0, #4
	mov r1, #0x1a
	bl FontID_Alloc
	mov r0, #0x34
	mov r1, #0x1a
	bl NARC_New
	add r5, r0, #0
	ldr r1, _0221BFA8 ; =0x000036CC
	add r0, r6, #0
	mov r2, #0x1a
	bl OverlayManager_CreateAndGetData
	add r4, r0, #0
	ldr r2, _0221BFA8 ; =0x000036CC
	mov r0, #0
	add r1, r4, #0
	bl MIi_CpuClearFast
	mov r0, #0x1a
	bl BgConfig_Alloc
	mov r1, #6
	lsl r1, r1, #6
	str r0, [r4, r1]
	mov r0, #0xc
	mov r1, #0x16
	mov r2, #0x1a
	bl MessageFormat_New_Custom
	mov r1, #0x61
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x1a
	bl MessageFormat_New
	mov r1, #0x62
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x1a
	bl MessageFormat_New
	mov r1, #0x63
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0
	mov r1, #0x1b
	mov r2, #0xb7
	mov r3, #0x1a
	bl NewMsgDataFromNarc
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #0
	str r0, [r4, #0x4c]
	add r0, r4, #0
	add r1, r6, #0
	bl ov65_0221D0EC
	mov r0, #4
	mov r1, #8
	bl SetKeyRepeatTimers
	bl ov65_0221CE98
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl ov65_0221CEB8
	mov r0, #0x10
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x1a
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	add r0, r4, #0
	add r1, r5, #0
	bl ov65_0221D280
	ldr r0, _0221BFAC ; =ov65_0221CE1C
	add r1, r4, #0
	bl Main_SetVBlankIntrCB
	bl ov65_0221D3B8
	add r0, r4, #0
	add r1, r5, #0
	bl ov65_0221D3E8
	add r0, r4, #0
	bl ov65_0221D930
	mov r0, #6
	ldr r2, [r4, #8]
	lsl r0, r0, #6
	ldr r1, _0221BFB0 ; =0x00000444
	ldr r0, [r4, r0]
	ldr r2, [r2, #0x18]
	add r1, r4, r1
	bl ov65_0221F8D0
	ldr r0, [r4, #8]
	add r1, r4, #0
	ldr r0, [r0]
	str r0, [r4]
	bl sub_0208F7E0
	mov r3, #0x61
	lsl r3, r3, #2
	ldr r0, [r4, r3]
	add r3, #0xc
	str r0, [sp]
	ldr r0, _0221BFB4 ; =0x000005B4
	ldr r3, [r4, r3]
	add r0, r4, r0
	mov r1, #0x14
	mov r2, #1
	bl ov65_0221FB90
	ldr r0, [r4]
	bl sub_0208F658
	mov r0, #0
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r1, #6
	lsl r1, r1, #6
	ldr r1, [r4, r1]
	mov r0, #0x1a
	bl sub_020399FC
	bl sub_0203A880
	bl IsNighttime
	ldr r1, _0221BFB8 ; =0x00000427
	mov r0, #0
	bl sub_02055198
	ldr r0, _0221BFB8 ; =0x00000427
	bl sub_02005448
	add r0, r5, #0
	bl NARC_Delete
	mov r0, #1
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	nop
_0221BF9C: .word 0xFFFFE0FF
_0221BFA0: .word 0x04001000
_0221BFA4: .word 0x00070FA0
_0221BFA8: .word 0x000036CC
_0221BFAC: .word ov65_0221CE1C
_0221BFB0: .word 0x00000444
_0221BFB4: .word 0x000005B4
_0221BFB8: .word 0x00000427
	thumb_func_end WirelessTradeSelectMon_Init

	thumb_func_start ov65_0221BFBC
ov65_0221BFBC: ; 0x0221BFBC
	push {r4, r5, r6, lr}
	add r5, r1, #0
	ldr r1, [sp, #0x10]
	add r4, r2, #0
	lsl r1, r1, #4
	add r1, #0x92
	mov r2, #2
	ldr r0, [r0, #0x14]
	add r6, r3, #0
	lsl r1, r1, #5
	lsl r2, r2, #8
	bl GX_LoadOBJ
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl GetMonIconPaletteEx
	add r1, r0, #0
	ldr r0, [sp, #0x14]
	add r1, #0xa
	bl Sprite_SetPalOffset
	pop {r4, r5, r6, pc}
	thumb_func_end ov65_0221BFBC

	thumb_func_start ov65_0221BFEC
ov65_0221BFEC: ; 0x0221BFEC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	bl sub_0203769C
	bl sub_02034818
	add r4, r0, #0
	bl sub_0203769C
	mov r1, #1
	eor r0, r1
	bl sub_02034818
	add r6, r0, #0
	add r0, r4, #0
	mov r1, #0x1a
	bl PlayerProfile_GetPlayerName_NewString
	add r4, r0, #0
	add r0, r6, #0
	mov r1, #0x1a
	bl PlayerProfile_GetPlayerName_NewString
	add r6, r0, #0
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x32
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221C080 ; =0x00000444
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xa
	mov r3, #0
	bl ov65_0221FB4C
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221C084 ; =0x00000454
	add r1, r6, #0
	add r0, r5, r0
	mov r2, #0xa
	mov r3, #0
	bl ov65_0221FB4C
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221C088 ; =0x000004A4
	add r1, r7, #0
	add r0, r5, r0
	mov r2, #5
	mov r3, #0
	bl ov65_0221FB4C
	add r0, r7, #0
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221C080: .word 0x00000444
_0221C084: .word 0x00000454
_0221C088: .word 0x000004A4
	thumb_func_end ov65_0221BFEC

	thumb_func_start ov65_0221C08C
ov65_0221C08C: ; 0x0221C08C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x34
	mov r1, #0x1a
	bl NARC_New
	add r4, r0, #0
	bl ov65_0221CE98
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	bl ov65_0221CEB8
	add r0, r5, #0
	add r1, r4, #0
	bl ov65_0221D280
	add r0, r5, #0
	bl ov65_0221C1C4
	add r0, r5, #0
	bl ov65_0221BFEC
	ldr r0, [r5, #8]
	ldr r0, [r0, #0x18]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x1a
	str r0, [sp, #4]
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	ldr r2, _0221C1AC ; =0x000003D9
	mov r1, #0
	mov r3, #0xa
	bl LoadUserFrameGfx2
	mov r1, #0
	str r1, [sp]
	mov r0, #0x1a
	str r0, [sp, #4]
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	ldr r2, _0221C1B0 ; =0x000003F7
	mov r3, #0xb
	bl LoadUserFrameGfx1
	mov r3, #0x61
	lsl r3, r3, #2
	ldr r0, [r5, r3]
	add r3, #0xc
	str r0, [sp]
	ldr r0, _0221C1B4 ; =0x00000594
	ldr r3, [r5, r3]
	add r0, r5, r0
	mov r1, #0xf
	mov r2, #1
	bl ov65_0221FB90
	mov r0, #4
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #5
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #6
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #1
	add r1, r0, #0
	bl ToggleBgLayer
	mov r0, #2
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #3
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	bl ov65_0221D3B8
	add r0, r5, #0
	add r1, r4, #0
	bl ov65_0221D3E8
	add r0, r5, #0
	bl ov65_0221D930
	ldr r0, _0221C1B8 ; =0x00002224
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r5, #0
	bl ov65_0221C46C
	ldr r0, _0221C1BC ; =0x00002228
	mov r1, #6
	ldr r0, [r5, r0]
	add r2, r5, #0
	bl ov65_0221C46C
	mov r0, #0xd1
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0xd2
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, _0221C1C0 ; =ov65_0221CE1C
	add r1, r5, #0
	bl Main_SetVBlankIntrCB
	add r0, r4, #0
	bl NARC_Delete
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_0221C1AC: .word 0x000003D9
_0221C1B0: .word 0x000003F7
_0221C1B4: .word 0x00000594
_0221C1B8: .word 0x00002224
_0221C1BC: .word 0x00002228
_0221C1C0: .word ov65_0221CE1C
	thumb_func_end ov65_0221C08C

	thumb_func_start ov65_0221C1C4
ov65_0221C1C4: ; 0x0221C1C4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x61
	ldr r1, _0221C240 ; =0x00002224
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	mov r2, #0
	bl ov65_0221C3DC
	mov r0, #0x61
	ldr r1, _0221C244 ; =0x00002228
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	mov r2, #6
	bl ov65_0221C3DC
	mov r0, #0
	mov r2, #0x61
	str r0, [sp]
	lsl r2, r2, #2
	ldr r3, _0221C240 ; =0x00002224
	ldr r0, _0221C248 ; =0x000004B4
	ldr r1, [r5, r2]
	add r2, #0xc
	ldr r2, [r5, r2]
	ldr r3, [r5, r3]
	add r0, r5, r0
	bl ov65_0221C414
	mov r0, #6
	mov r2, #0x61
	str r0, [sp]
	lsl r2, r2, #2
	ldr r3, _0221C244 ; =0x00002228
	ldr r0, _0221C24C ; =0x00000514
	ldr r1, [r5, r2]
	add r2, #0xc
	ldr r2, [r5, r2]
	ldr r3, [r5, r3]
	add r0, r5, r0
	bl ov65_0221C414
	ldr r0, _0221C240 ; =0x00002224
	ldr r0, [r5, r0]
	bl Party_GetCount
	add r4, r0, #0
	ldr r0, _0221C244 ; =0x00002228
	ldr r0, [r5, r0]
	bl Party_GetCount
	add r2, r0, #0
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl ov65_0221D25C
	pop {r3, r4, r5, pc}
	nop
_0221C240: .word 0x00002224
_0221C244: .word 0x00002228
_0221C248: .word 0x000004B4
_0221C24C: .word 0x00000514
	thumb_func_end ov65_0221C1C4

	thumb_func_start WirelessTradeSelectMon_Main
WirelessTradeSelectMon_Main: ; 0x0221C250
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r1, #0
	bl OverlayManager_GetData
	ldr r1, [r5]
	add r4, r0, #0
	mov r6, #0
	cmp r1, #0
	beq _0221C270
	cmp r1, #1
	beq _0221C284
	cmp r1, #2
	bne _0221C26E
	b _0221C3AA
_0221C26E:
	b _0221C3B4
_0221C270:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _0221C28A
	mov r0, #1
	str r0, [r5]
	add r0, r4, #0
	bl ov65_0221BFEC
	b _0221C3B4
_0221C284:
	ldr r1, [r4, #0x54]
	cmp r1, #7
	bls _0221C28C
_0221C28A:
	b _0221C3B4
_0221C28C:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221C298: ; jump table
	.short _0221C2A8 - _0221C298 - 2 ; case 0
	.short _0221C2B0 - _0221C298 - 2 ; case 1
	.short _0221C2B8 - _0221C298 - 2 ; case 2
	.short _0221C2D6 - _0221C298 - 2 ; case 3
	.short _0221C2F4 - _0221C298 - 2 ; case 4
	.short _0221C330 - _0221C298 - 2 ; case 5
	.short _0221C380 - _0221C298 - 2 ; case 6
	.short _0221C39C - _0221C298 - 2 ; case 7
_0221C2A8:
	bl ov65_0221C5E0
	str r0, [r4, #0x54]
	b _0221C3B4
_0221C2B0:
	bl ov65_0221CC0C
	str r0, [r4, #0x54]
	b _0221C3B4
_0221C2B8:
	mov r0, #8
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x1a
	str r0, [sp, #8]
	add r0, r6, #0
	add r1, r6, #0
	add r2, r6, #0
	add r3, r6, #0
	bl BeginNormalPaletteFade
	mov r0, #2
	str r0, [r5]
	b _0221C3B4
_0221C2D6:
	mov r0, #8
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x1a
	str r0, [sp, #8]
	add r0, r6, #0
	add r1, r6, #0
	add r2, r6, #0
	add r3, r6, #0
	bl BeginNormalPaletteFade
	mov r0, #4
	str r0, [r4, #0x54]
	b _0221C3B4
_0221C2F4:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _0221C3B4
	add r0, r4, #0
	bl ov65_0221CD0C
	add r0, r4, #0
	bl ov65_0221CCB0
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl ov65_0221D1C8
	mov r0, #1
	str r0, [r4, #0x50]
	mov r0, #5
	str r0, [r4, #0x54]
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r1, r0, #0
	add r0, r4, #0
	bl ov65_0221E06C
	b _0221C3B4
_0221C330:
	ldr r0, [r4, #0x4c]
	bl OverlayManager_Run
	cmp r0, #0
	beq _0221C3B4
	ldr r0, [r4, #0x4c]
	bl OverlayManager_Delete
	add r0, r4, #0
	bl ov65_0221C08C
	add r0, r6, #0
	str r0, [r4, #0x50]
	add r0, r4, #0
	add r0, #0x20
	ldrb r2, [r0]
	ldr r1, [r4, #0x48]
	mov r0, #6
	mul r0, r1
	add r1, r2, r0
	add r0, r4, #0
	add r0, #0x94
	str r1, [r0]
	add r0, r4, #0
	bl ov65_0221CB5C
	add r0, r4, #0
	mov r1, #0xd1
	add r0, #0x94
	lsl r1, r1, #2
	ldr r0, [r0]
	ldr r1, [r4, r1]
	add r2, r6, #0
	bl ov65_0221DD34
	bl sub_0203A880
	mov r0, #6
	str r0, [r4, #0x54]
	b _0221C3B4
_0221C380:
	mov r0, #8
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x1a
	str r0, [sp, #8]
	add r0, r6, #0
	add r2, r1, #0
	add r3, r6, #0
	bl BeginNormalPaletteFade
	mov r0, #7
	str r0, [r4, #0x54]
	b _0221C3B4
_0221C39C:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _0221C3B4
	mov r0, #1
	str r0, [r4, #0x54]
	b _0221C3B4
_0221C3AA:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _0221C3B4
	mov r6, #1
_0221C3B4:
	ldr r0, [r4, #0x50]
	cmp r0, #0
	bne _0221C3CA
	add r0, r4, #0
	bl ov65_0221F714
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl SpriteList_RenderAndAnimateSprites
_0221C3CA:
	mov r1, #6
	lsl r1, r1, #6
	ldr r1, [r4, r1]
	mov r0, #0x1a
	bl sub_020399FC
	add r0, r6, #0
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end WirelessTradeSelectMon_Main

	thumb_func_start ov65_0221C3DC
ov65_0221C3DC: ; 0x0221C3DC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r7, r0, #0
	add r0, r5, #0
	add r6, r2, #0
	mov r4, #0
	bl Party_GetCount
	cmp r0, #0
	ble _0221C412
_0221C3F0:
	add r0, r5, #0
	add r1, r4, #0
	bl Party_GetMonByIndex
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r7, #0
	add r1, r4, r6
	bl BufferBoxMonNickname
	add r0, r5, #0
	add r4, r4, #1
	bl Party_GetCount
	cmp r4, r0
	blt _0221C3F0
_0221C412:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov65_0221C3DC

	thumb_func_start ov65_0221C414
ov65_0221C414: ; 0x0221C414
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	add r0, r3, #0
	str r1, [sp, #8]
	str r2, [sp, #0xc]
	str r3, [sp, #0x10]
	ldr r6, [sp, #0x28]
	mov r4, #0
	bl Party_GetCount
	cmp r0, #0
	ble _0221C466
	add r7, r6, #1
_0221C430:
	ldr r0, [sp, #8]
	ldr r1, [sp, #0xc]
	add r2, r7, r4
	mov r3, #0x1a
	bl ReadMsgData_ExpandPlaceholders
	add r6, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #8
	mov r3, #0
	bl ov65_0221FB4C
	add r0, r6, #0
	bl String_Delete
	ldr r0, [sp, #0x10]
	add r5, #0x10
	add r4, r4, #1
	bl Party_GetCount
	cmp r4, r0
	blt _0221C430
_0221C466:
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov65_0221C414

	thumb_func_start ov65_0221C46C
ov65_0221C46C: ; 0x0221C46C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	str r2, [sp, #0x20]
	mov r7, #0
	bl Party_GetCount
	cmp r0, #0
	bgt _0221C482
	b _0221C584
_0221C482:
	ldr r1, _0221C5C4 ; =0x000007CC
	ldr r0, [sp, #0x20]
	add r0, r0, r1
	str r0, [sp, #0x1c]
_0221C48A:
	ldr r0, [sp, #0xc]
	ldr r2, _0221C5C8 ; =0x000006A2
	add r0, r7, r0
	str r0, [sp, #0x10]
	lsl r0, r0, #2
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x10]
	lsl r1, r0, #4
	ldr r0, [sp, #0x20]
	add r4, r0, r1
	ldr r1, [sp, #0x18]
	ldrb r2, [r4, r2]
	add r5, r0, r1
	ldr r0, _0221C5CC ; =0x0000069C
	ldr r1, _0221C5D0 ; =0x000006A1
	ldrh r0, [r4, r0]
	ldrb r1, [r4, r1]
	bl GetMonIconNaixEx
	add r1, r0, #0
	mov r0, #0x1a
	str r0, [sp]
	ldr r6, [sp, #0x1c]
	ldr r3, [sp, #0x18]
	mov r0, #0x14
	mov r2, #0
	add r3, r6, r3
	bl GfGfxLoader_GetCharData
	ldr r1, _0221C5D4 ; =0x0000079C
	str r0, [r5, r1]
	add r0, r1, #0
	add r0, #0x30
	ldr r0, [r5, r0]
	mov r1, #2
	ldr r0, [r0, #0x14]
	lsl r1, r1, #8
	bl DC_FlushRange
	ldr r0, [sp, #0x10]
	ldr r1, _0221C5CC ; =0x0000069C
	str r0, [sp]
	mov r0, #0xdf
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r2, _0221C5C8 ; =0x000006A2
	str r0, [sp, #4]
	ldr r3, _0221C5D0 ; =0x000006A1
	ldr r0, _0221C5C4 ; =0x000007CC
	ldrh r1, [r4, r1]
	ldrb r2, [r4, r2]
	ldrb r3, [r4, r3]
	ldr r0, [r5, r0]
	bl ov65_0221BFBC
	mov r0, #0xdf
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, _0221C5D8 ; =0x0000069E
	ldrh r0, [r4, r0]
	cmp r0, #0
	bne _0221C51A
	mov r0, #0xeb
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
	b _0221C542
_0221C51A:
	ldr r0, [sp, #0x10]
	lsl r1, r0, #2
	ldr r0, [sp, #0x20]
	add r1, r0, r1
	mov r0, #0xeb
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	str r1, [sp, #0x14]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0xeb
	ldr r1, [sp, #0x14]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	ldr r1, _0221C5D8 ; =0x0000069E
	ldrh r1, [r4, r1]
	add r1, r1, #2
	bl Sprite_SetAnimCtrlSeq
_0221C542:
	ldr r0, _0221C5DC ; =0x000006A8
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0221C558
	mov r0, #0xf7
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
	b _0221C578
_0221C558:
	ldr r0, [sp, #0x10]
	lsl r1, r0, #2
	ldr r0, [sp, #0x20]
	add r4, r0, r1
	mov r0, #0xf7
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0xf7
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x15
	bl Sprite_SetAnimCtrlSeq
_0221C578:
	ldr r0, [sp, #8]
	add r7, r7, #1
	bl Party_GetCount
	cmp r7, r0
	blt _0221C48A
_0221C584:
	cmp r7, #6
	bge _0221C5C0
	ldr r0, [sp, #0xc]
	mov r6, #0xeb
	lsl r1, r0, #2
	ldr r0, [sp, #0x20]
	lsl r6, r6, #2
	add r1, r0, r1
	lsl r0, r7, #2
	add r5, r6, #0
	add r4, r1, r0
	add r5, #0x30
_0221C59C:
	mov r0, #0xdf
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r4, r6]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r4, r5]
	mov r1, #0
	bl Sprite_SetDrawFlag
	add r7, r7, #1
	add r4, r4, #4
	cmp r7, #6
	blt _0221C59C
_0221C5C0:
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221C5C4: .word 0x000007CC
_0221C5C8: .word 0x000006A2
_0221C5CC: .word 0x0000069C
_0221C5D0: .word 0x000006A1
_0221C5D4: .word 0x0000079C
_0221C5D8: .word 0x0000069E
_0221C5DC: .word 0x000006A8
	thumb_func_end ov65_0221C46C

	thumb_func_start ov65_0221C5E0
ov65_0221C5E0: ; 0x0221C5E0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov65_0221F864
	ldr r0, [r4, #0x58]
	cmp r0, #0x13
	bls _0221C5F2
	b _0221C99E
_0221C5F2:
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221C5FE: ; jump table
	.short _0221C626 - _0221C5FE - 2 ; case 0
	.short _0221C68E - _0221C5FE - 2 ; case 1
	.short _0221C6D8 - _0221C5FE - 2 ; case 2
	.short _0221C6E6 - _0221C5FE - 2 ; case 3
	.short _0221C6FA - _0221C5FE - 2 ; case 4
	.short _0221C70A - _0221C5FE - 2 ; case 5
	.short _0221C722 - _0221C5FE - 2 ; case 6
	.short _0221C736 - _0221C5FE - 2 ; case 7
	.short _0221C748 - _0221C5FE - 2 ; case 8
	.short _0221C774 - _0221C5FE - 2 ; case 9
	.short _0221C782 - _0221C5FE - 2 ; case 10
	.short _0221C78E - _0221C5FE - 2 ; case 11
	.short _0221C812 - _0221C5FE - 2 ; case 12
	.short _0221C82E - _0221C5FE - 2 ; case 13
	.short _0221C83A - _0221C5FE - 2 ; case 14
	.short _0221C84C - _0221C5FE - 2 ; case 15
	.short _0221C890 - _0221C5FE - 2 ; case 16
	.short _0221C8CA - _0221C5FE - 2 ; case 17
	.short _0221C90C - _0221C5FE - 2 ; case 18
	.short _0221C94C - _0221C5FE - 2 ; case 19
_0221C626:
	mov r0, #0x50
	bl sub_02037AC0
	mov r0, #2
	bl sub_0201A728
	add r0, r4, #0
	bl ov65_0221F760
	ldr r0, [r4, #8]
	mov r5, #0
	ldr r0, [r0, #8]
	bl Party_GetCount
	cmp r0, #0
	ble _0221C686
	mov r7, #0x7b
	lsl r7, r7, #2
_0221C64A:
	ldr r0, [r4, #8]
	add r1, r5, #0
	ldr r0, [r0, #8]
	bl Party_GetMonByIndex
	mov r1, #0xae
	mov r2, #0
	add r6, r0, #0
	bl GetMonData
	cmp r0, r7
	bne _0221C678
	add r0, r6, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0221C678
	add r0, r6, #0
	mov r1, #0
	bl Mon_UpdateShayminForm
_0221C678:
	ldr r0, [r4, #8]
	add r5, r5, #1
	ldr r0, [r0, #8]
	bl Party_GetCount
	cmp r5, r0
	blt _0221C64A
_0221C686:
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C68E:
	mov r0, #0x50
	bl sub_02037B38
	cmp r0, #0
	beq _0221C77A
	ldr r0, [r4, #8]
	ldr r0, [r0, #0x30]
	cmp r0, #0
	bne _0221C6A4
	mov r0, #6
	b _0221C6A6
_0221C6A4:
	mov r0, #2
_0221C6A6:
	str r0, [r4, #0x58]
	bl sub_0203769C
	cmp r0, #0
	bne _0221C6CA
	bl LCRandom
	mov r1, #0x3c
	bl _s32_div_f
	lsl r0, r1, #0x10
	lsr r5, r0, #0x10
	bl sub_0203769C
	mov r1, #0x1f
	add r2, r5, #3
	bl ov65_0221DE10
_0221C6CA:
	ldr r0, [r4, #4]
	bl ov65_0221DE8C
	add r0, r4, #0
	bl ov65_0221F850
	b _0221C99E
_0221C6D8:
	ldr r1, _0221C9A4 ; =0x000022CC
	ldr r1, [r4, r1]
	cmp r1, #0
	beq _0221C77A
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C6E6:
	ldr r0, _0221C9A4 ; =0x000022CC
	ldr r1, [r4, r0]
	sub r1, r1, #1
	str r1, [r4, r0]
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0221C77A
	mov r0, #4
	str r0, [r4, #0x58]
	b _0221C99E
_0221C6FA:
	ldr r0, _0221C9A8 ; =0x000036A8
	add r0, r4, r0
	bl sub_02039EAC
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C70A:
	ldr r2, _0221C9A8 ; =0x000036A8
	ldr r0, [r4, #4]
	mov r1, #2
	add r2, r4, r2
	bl sub_02039EB4
	cmp r0, #0
	beq _0221C77A
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C722:
	mov r0, #1
	bl sub_020378E4
	mov r0, #0x51
	bl sub_02037AC0
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C736:
	mov r0, #0x51
	bl sub_02037B38
	cmp r0, #0
	beq _0221C77A
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C748:
	mov r0, #0
	str r0, [r4, #0x5c]
	str r0, [r4, #0x60]
	str r0, [r4, #0x64]
	bl sub_0203769C
	cmp r0, #1
	bne _0221C76C
	bl sub_0203769C
	ldr r1, _0221C9AC ; =0x00002224
	ldr r2, [r4, #0x5c]
	ldr r1, [r4, r1]
	bl ov65_0221DE64
	ldr r0, [r4, #0x5c]
	add r0, r0, #1
	str r0, [r4, #0x5c]
_0221C76C:
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C774:
	ldr r0, [r4, #0x60]
	cmp r0, #0
	bne _0221C77C
_0221C77A:
	b _0221C99E
_0221C77C:
	mov r0, #0xa
	str r0, [r4, #0x58]
	b _0221C99E
_0221C782:
	add r0, r0, #1
	str r0, [r4, #0x58]
	add r0, r4, #0
	bl ov65_0221C1C4
	b _0221C99E
_0221C78E:
	mov r1, #0
	ldr r0, _0221C9B0 ; =0x0000069C
	add r2, r4, #0
	add r5, r1, #0
_0221C796:
	add r1, r1, #1
	strh r5, [r2, r0]
	add r2, #0x10
	cmp r1, #0xd
	blt _0221C796
	ldr r0, _0221C9AC ; =0x00002224
	ldr r0, [r4, r0]
	bl Party_GetCount
	cmp r0, #0
	ble _0221C7D0
	ldr r0, _0221C9B0 ; =0x0000069C
	ldr r7, _0221C9AC ; =0x00002224
	add r6, r4, r0
_0221C7B2:
	ldr r0, _0221C9AC ; =0x00002224
	add r1, r5, #0
	ldr r0, [r4, r0]
	bl Party_GetMonByIndex
	add r1, r6, #0
	bl ov65_0221C9D8
	ldr r0, [r4, r7]
	add r6, #0x10
	add r5, r5, #1
	bl Party_GetCount
	cmp r5, r0
	blt _0221C7B2
_0221C7D0:
	ldr r0, _0221C9B4 ; =0x00002228
	mov r5, #0
	ldr r0, [r4, r0]
	bl Party_GetCount
	cmp r0, #0
	ble _0221C804
	ldr r0, _0221C9B0 ; =0x0000069C
	ldr r7, _0221C9B4 ; =0x00002228
	add r6, r4, r0
_0221C7E4:
	ldr r0, _0221C9B4 ; =0x00002228
	add r1, r5, #0
	ldr r0, [r4, r0]
	bl Party_GetMonByIndex
	add r1, r5, #6
	lsl r1, r1, #4
	add r1, r6, r1
	bl ov65_0221C9D8
	ldr r0, [r4, r7]
	add r5, r5, #1
	bl Party_GetCount
	cmp r5, r0
	blt _0221C7E4
_0221C804:
	ldr r0, _0221C9B8 ; =0x0000075C
	mov r1, #1
	strh r1, [r4, r0]
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C812:
	bl sub_0203769C
	bl sub_02034818
	ldr r2, _0221C9BC ; =0x00002230
	ldr r1, [r4, r2]
	add r2, r2, #4
	add r2, r4, r2
	bl ov65_0221DEA0
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C82E:
	ldr r1, [r4, #0x60]
	cmp r1, #3
	bne _0221C88E
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C83A:
	ldr r0, [r4, #4]
	bl Save_Chatot_Get
	bl ov65_0221DF0C
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C84C:
	ldr r1, [r4, #0x60]
	cmp r1, #4
	bne _0221C88E
	add r0, r0, #1
	str r0, [r4, #0x58]
	mov r0, #0x10
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, _0221C9AC ; =0x00002224
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r4, #0
	bl ov65_0221C46C
	ldr r0, _0221C9B4 ; =0x00002228
	mov r1, #6
	ldr r0, [r4, r0]
	add r2, r4, #0
	bl ov65_0221C46C
	mov r6, #0xd1
	mov r5, #0
	mov r7, #1
	lsl r6, r6, #2
_0221C87E:
	ldr r0, [r4, r6]
	add r1, r7, #0
	bl Sprite_SetDrawFlag
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #2
	blt _0221C87E
_0221C88E:
	b _0221C99E
_0221C890:
	mov r1, #0
	mov r0, #1
	add r2, r1, #0
	str r0, [sp]
	mov r0, #8
	sub r2, #0x10
	mov r3, #0x1e
	bl StartBrightnessTransition
	mov r0, #1
	add r1, r0, #0
	bl ToggleBgLayer
	mov r0, #2
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #3
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C8CA:
	mov r0, #1
	bl IsBrightnessTransitionActive
	cmp r0, #0
	beq _0221C99E
	ldr r0, _0221C9AC ; =0x00002224
	mov r1, #0
	ldr r0, [r4, r0]
	bl Party_GetMonByIndex
	ldr r2, _0221C9C0 ; =0x000007FC
	ldr r3, _0221C9C4 ; =0x000020FC
	add r1, r0, #0
	mov r0, #0
	add r2, r4, r2
	add r3, r4, r3
	bl ov65_0221D57C
	ldr r1, _0221C9C8 ; =0x0000211C
	ldr r2, _0221C9AC ; =0x00002224
	str r0, [r4, r1]
	str r4, [sp]
	ldr r0, _0221C9CC ; =0x00000444
	mov r1, #0
	ldr r2, [r4, r2]
	add r0, r4, r0
	add r3, r1, #0
	bl ov65_0221D674
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	b _0221C99E
_0221C90C:
	mov r1, #0
	mov r0, #2
	add r2, r1, #0
	str r0, [sp]
	mov r0, #8
	sub r2, #0x10
	mov r3, #0x17
	bl StartBrightnessTransition
	mov r0, #4
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #5
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #6
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #0x58]
	add r0, r0, #1
	str r0, [r4, #0x58]
	add r0, r4, #0
	bl ov65_0221F780
	b _0221C99E
_0221C94C:
	mov r0, #2
	bl IsBrightnessTransitionActive
	cmp r0, #0
	beq _0221C99E
	ldr r0, _0221C9D0 ; =0x000005B4
	mov r1, #1
	add r0, r4, r0
	bl ClearFrameAndWindow2
	mov r1, #0
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	add r2, r1, #0
	add r3, r1, #0
	bl FillBgTilemapRect
	mov r3, #0x61
	lsl r3, r3, #2
	ldr r0, [r4, r3]
	add r3, #0xc
	str r0, [sp]
	ldr r0, _0221C9D4 ; =0x00000594
	ldr r3, [r4, r3]
	add r0, r4, r0
	mov r1, #0xf
	mov r2, #1
	bl ov65_0221FB90
	mov r0, #2
	bl sub_0201A738
	add sp, #0x10
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0221C99E:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221C9A4: .word 0x000022CC
_0221C9A8: .word 0x000036A8
_0221C9AC: .word 0x00002224
_0221C9B0: .word 0x0000069C
_0221C9B4: .word 0x00002228
_0221C9B8: .word 0x0000075C
_0221C9BC: .word 0x00002230
_0221C9C0: .word 0x000007FC
_0221C9C4: .word 0x000020FC
_0221C9C8: .word 0x0000211C
_0221C9CC: .word 0x00000444
_0221C9D0: .word 0x000005B4
_0221C9D4: .word 0x00000594
	thumb_func_end ov65_0221C5E0

	thumb_func_start ov65_0221C9D8
ov65_0221C9D8: ; 0x0221C9D8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl AcquireMonLock
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #0x9b
	mov r2, #0
	bl GetMonData
	strb r0, [r4, #4]
	add r0, r5, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	strh r0, [r4]
	add r0, r5, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	strb r0, [r4, #6]
	add r0, r5, #0
	mov r1, #0x4c
	mov r2, #0
	bl GetMonData
	strb r0, [r4, #5]
	add r0, r5, #0
	mov r1, #0x6f
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #8]
	add r0, r5, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	str r0, [r4, #0xc]
	add r0, r5, #0
	mov r1, #6
	mov r2, #0
	bl GetMonData
	add r6, r0, #0
	add r0, r5, #0
	add r1, r7, #0
	bl ReleaseMonLock
	ldrh r0, [r4]
	cmp r0, #0
	beq _0221CA50
	ldrb r1, [r4, #6]
	mov r2, #0x1c
	bl GetMonBaseStat_HandleAlternateForm
	strh r0, [r4, #0xa]
_0221CA50:
	cmp r6, #0
	beq _0221CA60
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	add r0, r0, #1
	strh r0, [r4, #2]
_0221CA60:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov65_0221C9D8

	thumb_func_start ov65_0221CA64
ov65_0221CA64: ; 0x0221CA64
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r1, #0
	ldr r1, _0221CAD4 ; =0x0000040C
	lsl r7, r5, #2
	add r6, r0, r1
	add r4, r2, #0
	ldr r0, [r6, r7]
	add r1, r4, #7
	bl Sprite_SetAnimCtrlSeq
	cmp r5, #2
	bne _0221CAA6
	mov r0, #0x20
	sub r1, r4, #1
	str r0, [sp]
	mov r0, #0x1a
	lsl r2, r1, #2
	ldr r1, _0221CAD8 ; =ov65_0221FEEC
	str r0, [sp, #4]
	mov r0, #0xa2
	ldr r1, [r1, r2]
	add r3, r0, #0
	mov r2, #5
	add r3, #0xbe
	bl GfGfxLoader_GXLoadPal
	ldr r0, [r6, r7]
	mov r1, #0xb
	bl Sprite_SetPaletteOverride
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_0221CAA6:
	cmp r5, #3
	bne _0221CACE
	mov r0, #0x20
	sub r1, r4, #1
	str r0, [sp]
	mov r0, #0x1a
	lsl r2, r1, #2
	ldr r1, _0221CAD8 ; =ov65_0221FEEC
	str r0, [sp, #4]
	mov r0, #0xa2
	ldr r1, [r1, r2]
	add r3, r0, #0
	mov r2, #5
	add r3, #0xde
	bl GfGfxLoader_GXLoadPal
	ldr r0, [r6, r7]
	mov r1, #0xc
	bl Sprite_SetPaletteOverride
_0221CACE:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CAD4: .word 0x0000040C
_0221CAD8: .word ov65_0221FEEC
	thumb_func_end ov65_0221CA64

	thumb_func_start ov65_0221CADC
ov65_0221CADC: ; 0x0221CADC
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #6
	bl _s32_div_f
	ldr r0, _0221CB48 ; =0x00002228
	add r7, r1, #0
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	add r6, r0, #0
	add r0, r4, #0
	mov r1, #6
	bl _s32_div_f
	add r1, r6, #0
	ldr r2, _0221CB4C ; =0x000007FC
	mov r6, #0x32
	add r3, r0, #0
	lsl r6, r6, #6
	mul r6, r3
	add r2, r5, r2
	add r2, r2, r6
	ldr r6, _0221CB50 ; =0x000020FC
	lsl r3, r3, #4
	add r6, r5, r6
	mov r0, #1
	add r3, r6, r3
	bl ov65_0221D57C
	ldr r1, _0221CB54 ; =0x0000211C
	ldr r2, _0221CB48 ; =0x00002228
	str r0, [r5, r1]
	str r5, [sp]
	ldr r0, _0221CB58 ; =0x00000444
	ldr r2, [r5, r2]
	add r0, r5, r0
	mov r1, #1
	add r3, r7, #0
	bl ov65_0221D674
	lsl r2, r4, #4
	add r3, r5, r2
	mov r2, #0x6a
	lsl r2, r2, #4
	ldrb r2, [r3, r2]
	add r0, r5, #0
	mov r1, #3
	bl ov65_0221CA64
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CB48: .word 0x00002228
_0221CB4C: .word 0x000007FC
_0221CB50: .word 0x000020FC
_0221CB54: .word 0x0000211C
_0221CB58: .word 0x00000444
	thumb_func_end ov65_0221CADC

	thumb_func_start ov65_0221CB5C
ov65_0221CB5C: ; 0x0221CB5C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x94
	ldr r1, [r1]
	cmp r1, #0xc
	beq _0221CBEE
	cmp r1, #6
	bge _0221CBD4
	ldr r0, _0221CBF0 ; =0x00002224
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x94
	ldr r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r3, r0, #0
	ldr r2, _0221CBF4 ; =0x000007FC
	add r1, r4, #0
	add r4, r5, r2
	mov r2, #0x32
	lsl r2, r2, #6
	mul r2, r3
	add r2, r4, r2
	ldr r4, _0221CBF8 ; =0x000020FC
	lsl r3, r3, #4
	add r4, r5, r4
	mov r0, #0
	add r3, r4, r3
	bl ov65_0221D57C
	ldr r1, _0221CBFC ; =0x0000211C
	add r3, r5, #0
	str r0, [r5, r1]
	ldr r0, _0221CC00 ; =0x00000444
	ldr r2, _0221CBF0 ; =0x00002224
	str r5, [sp]
	add r3, #0x94
	ldr r2, [r5, r2]
	ldr r3, [r3]
	add r0, r5, r0
	mov r1, #0
	bl ov65_0221D674
	ldr r0, _0221CC00 ; =0x00000444
	mov r1, #1
	add r0, r5, r0
	add r2, r5, #0
	bl ov65_0221D8C4
	ldr r0, _0221CC04 ; =0x00000418
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_0221CBD4:
	bl ov65_0221CADC
	ldr r0, _0221CC00 ; =0x00000444
	mov r1, #0
	add r0, r5, r0
	add r2, r5, #0
	bl ov65_0221D8C4
	ldr r0, _0221CC08 ; =0x00000414
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
_0221CBEE:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221CBF0: .word 0x00002224
_0221CBF4: .word 0x000007FC
_0221CBF8: .word 0x000020FC
_0221CBFC: .word 0x0000211C
_0221CC00: .word 0x00000444
_0221CC04: .word 0x00000418
_0221CC08: .word 0x00000414
	thumb_func_end ov65_0221CB5C

	thumb_func_start ov65_0221CC0C
ov65_0221CC0C: ; 0x0221CC0C
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _0221CCA8 ; =0x00002220
	add r4, r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0
	beq _0221CC22
	blx r1
	mov r1, #0x53
	lsl r1, r1, #2
	str r0, [r4, r1]
_0221CC22:
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #3
	bhi _0221CC4C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221CC38: ; jump table
	.short _0221CC4C - _0221CC38 - 2 ; case 0
	.short _0221CC4C - _0221CC38 - 2 ; case 1
	.short _0221CC40 - _0221CC38 - 2 ; case 2
	.short _0221CC46 - _0221CC38 - 2 ; case 3
_0221CC40:
	add sp, #4
	mov r0, #2
	pop {r3, r4, pc}
_0221CC46:
	add sp, #4
	mov r0, #3
	pop {r3, r4, pc}
_0221CC4C:
	mov r0, #0
	mov r2, #0xd1
	str r0, [sp]
	mov r0, #0x56
	lsl r2, r2, #2
	ldr r3, _0221CCAC ; =0x0000069C
	lsl r0, r0, #2
	add r1, r4, #0
	ldr r2, [r4, r2]
	add r0, r4, r0
	add r1, #0x94
	add r3, r4, r3
	bl ov65_0221DDC0
	cmp r0, #0
	beq _0221CC72
	add r0, r4, #0
	bl ov65_0221CB5C
_0221CC72:
	mov r0, #1
	mov r2, #0xd2
	str r0, [sp]
	mov r0, #0x57
	lsl r2, r2, #2
	ldr r3, _0221CCAC ; =0x0000069C
	lsl r0, r0, #2
	add r1, r4, #0
	ldr r2, [r4, r2]
	add r0, r4, r0
	add r1, #0x98
	add r3, r4, r3
	bl ov65_0221DDC0
	add r0, r4, #0
	add r0, #0x9c
	bl ov65_0221DCBC
	add r0, r4, #0
	add r4, #0x94
	ldr r2, [r4]
	mov r1, #0x17
	bl ov65_0221DE24
	mov r0, #1
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_0221CCA8: .word 0x00002220
_0221CCAC: .word 0x0000069C
	thumb_func_end ov65_0221CC0C

	thumb_func_start ov65_0221CCB0
ov65_0221CCB0: ; 0x0221CCB0
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r0, #0xb7
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl SpriteTransfer_DeleteCharTransferTask
	mov r0, #0xbb
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl SpriteTransfer_DeleteCharTransferTask
	mov r0, #0x2e
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	bl SpriteTransfer_DeletePlttTransferTask
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	bl SpriteTransfer_DeletePlttTransferTask
	mov r7, #0xb3
	mov r4, #0
	add r5, r6, #0
	lsl r7, r7, #2
_0221CCE4:
	ldr r0, [r5, r7]
	bl Destroy2DGfxResObjMan
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _0221CCE4
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	bl SpriteList_Delete
	bl OamManager_Free
	bl ObjCharTransfer_Destroy
	bl ObjPlttTransfer_Destroy
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov65_0221CCB0

	thumb_func_start ov65_0221CD0C
ov65_0221CD0C: ; 0x0221CD0C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _0221CD64 ; =0x00002224
	mov r6, #0
	ldr r0, [r5, r0]
	bl Party_GetCount
	cmp r0, #0
	ble _0221CD38
	ldr r7, _0221CD64 ; =0x00002224
	add r4, r5, #0
_0221CD22:
	ldr r0, _0221CD68 ; =0x0000079C
	ldr r0, [r4, r0]
	bl Heap_Free
	ldr r0, [r5, r7]
	add r4, r4, #4
	add r6, r6, #1
	bl Party_GetCount
	cmp r6, r0
	blt _0221CD22
_0221CD38:
	ldr r0, _0221CD6C ; =0x00002228
	mov r6, #0
	ldr r0, [r5, r0]
	bl Party_GetCount
	cmp r0, #0
	ble _0221CD60
	ldr r7, _0221CD6C ; =0x00002228
	add r4, r5, #0
_0221CD4A:
	ldr r0, _0221CD70 ; =0x000007B4
	ldr r0, [r4, r0]
	bl Heap_Free
	ldr r0, [r5, r7]
	add r4, r4, #4
	add r6, r6, #1
	bl Party_GetCount
	cmp r6, r0
	blt _0221CD4A
_0221CD60:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CD64: .word 0x00002224
_0221CD68: .word 0x0000079C
_0221CD6C: .word 0x00002228
_0221CD70: .word 0x000007B4
	thumb_func_end ov65_0221CD0C

	thumb_func_start WirelessTradeSelectMon_Exit
WirelessTradeSelectMon_Exit: ; 0x0221CD74
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	add r0, r5, #0
	bl OverlayManager_GetArgs
	ldr r1, [r4, #0x68]
	str r1, [r0, #0x24]
	add r0, r4, #0
	bl ov65_0221CD0C
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _0221CE14 ; =0x00002228
	ldr r0, [r4, r0]
	bl Heap_Free
	add r0, r4, #0
	bl ov65_0221CCB0
	ldr r0, _0221CE18 ; =0x00000444
	add r0, r4, r0
	bl ov65_0221FAE0
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl ov65_0221D1C8
	mov r1, #6
	lsl r1, r1, #6
	ldr r1, [r4, r1]
	mov r0, #0x1a
	bl Heap_FreeExplicit
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl DestroyMsgData
	mov r0, #0x63
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl MessageFormat_Delete
	mov r0, #0x62
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl MessageFormat_Delete
	mov r0, #0x61
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl MessageFormat_Delete
	mov r0, #0x66
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	add r0, r5, #0
	bl OverlayManager_FreeData
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	mov r0, #4
	bl FontID_Release
	mov r0, #0x1a
	bl Heap_Destroy
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221CE14: .word 0x00002228
_0221CE18: .word 0x00000444
	thumb_func_end WirelessTradeSelectMon_Exit

	thumb_func_start ov65_0221CE1C
ov65_0221CE1C: ; 0x0221CE1C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #6
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	bl DoScheduledBgGpuUpdates
	ldr r0, _0221CE84 ; =0x0000211C
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0221CE6C
	sub r4, r0, #1
	ldr r0, _0221CE88 ; =0x000007FC
	mov r2, #0x32
	lsl r2, r2, #6
	add r1, r4, #0
	add r0, r5, r0
	mul r1, r2
	add r0, r0, r1
	bl GXS_LoadOBJ
	lsl r1, r4, #4
	mov r0, #0x20
	add r2, r5, r1
	str r0, [sp]
	mov r0, #0x1a
	add r3, r4, #2
	ldr r1, _0221CE8C ; =0x000020FC
	str r0, [sp, #4]
	ldrh r0, [r2, r1]
	add r1, r1, #4
	ldrh r1, [r2, r1]
	mov r2, #5
	lsl r3, r3, #5
	bl GfGfxLoader_GXLoadPal
	ldr r0, _0221CE84 ; =0x0000211C
	mov r1, #0
	str r1, [r5, r0]
_0221CE6C:
	bl GF_RunVramTransferTasks
	bl OamManager_ApplyAndResetBuffers
	ldr r3, _0221CE90 ; =0x027E0000
	ldr r1, _0221CE94 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221CE84: .word 0x0000211C
_0221CE88: .word 0x000007FC
_0221CE8C: .word 0x000020FC
_0221CE90: .word 0x027E0000
_0221CE94: .word 0x00003FF8
	thumb_func_end ov65_0221CE1C

	thumb_func_start ov65_0221CE98
ov65_0221CE98: ; 0x0221CE98
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _0221CEB4 ; =ov65_0221FE44
	add r3, sp, #0
	mov r2, #5
_0221CEA2:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0221CEA2
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_0221CEB4: .word ov65_0221FE44
	thumb_func_end ov65_0221CE98

	thumb_func_start ov65_0221CEB8
ov65_0221CEB8: ; 0x0221CEB8
	push {r4, r5, r6, r7, lr}
	sub sp, #0xd4
	ldr r4, _0221D0C0 ; =ov65_0221FD58
	add r3, sp, #0xc4
	add r5, r0, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r4, _0221D0C4 ; =ov65_0221FDF0
	add r3, sp, #0xa8
	ldmia r4!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	mov r1, #0
	str r0, [r3]
	add r0, r5, #0
	add r3, r1, #0
	bl InitBgFromTemplate
	add r0, r5, #0
	mov r1, #0
	bl BgClearTilemapBufferAndCommit
	ldr r4, _0221D0C8 ; =ov65_0221FDB8
	add r3, sp, #0x8c
	ldmia r4!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	mov r1, #1
	str r0, [r3]
	add r0, r5, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r5, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r4, _0221D0CC ; =ov65_0221FE0C
	add r3, sp, #0x70
	ldmia r4!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	mov r1, #2
	str r0, [r3]
	add r0, r5, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r5, #0
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r4, _0221D0D0 ; =ov65_0221FE28
	add r3, sp, #0x54
	ldmia r4!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	mov r1, #3
	str r0, [r3]
	add r0, r5, #0
	mov r3, #0
	bl InitBgFromTemplate
	ldr r4, _0221D0D4 ; =ov65_0221FD80
	add r3, sp, #0x38
	ldmia r4!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	str r0, [r3]
	add r0, r5, #0
	mov r1, #4
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r5, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r4, _0221D0D8 ; =ov65_0221FD9C
	add r3, sp, #0x1c
	ldmia r4!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	mov r1, #5
	str r0, [r3]
	add r0, r5, #0
	mov r3, #0
	bl InitBgFromTemplate
	ldr r4, _0221D0DC ; =ov65_0221FDD4
	add r3, sp, #0
	ldmia r4!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	mov r1, #6
	str r0, [r3]
	add r0, r5, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #0
	mov r1, #0x20
	add r2, r0, #0
	mov r3, #0x1a
	bl BG_ClearCharDataRange
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x1a
	bl BG_ClearCharDataRange
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x1a
	bl BG_ClearCharDataRange
	mov r4, #0
	mov r6, #3
	add r7, r4, #0
_0221CFFC:
	lsl r1, r4, #0x18
	mov r2, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	add r2, r6, #0
	add r3, r7, #0
	bl BgSetPosTextAndCommit
	add r1, r4, #4
	lsl r1, r1, #0x18
	mov r2, #0
	add r0, r5, #0
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r1, r4, #4
	lsl r1, r1, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	mov r2, #3
	mov r3, #0
	bl BgSetPosTextAndCommit
	add r4, r4, #1
	cmp r4, #4
	blt _0221CFFC
	mov r0, #0
	add r1, r0, #0
	bl ToggleBgLayer
	mov r0, #1
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #2
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #3
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #4
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #5
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #6
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #1
	lsl r0, r0, #0x1a
	add r3, r0, #0
	ldr r2, [r0]
	ldr r1, _0221D0E0 ; =0xFFFF1FFF
	add r3, #0x48
	and r1, r2
	str r1, [r0]
	ldrh r4, [r3]
	mov r1, #0x3f
	mov r2, #0x1f
	bic r4, r1
	orr r4, r2
	strh r4, [r3]
	add r3, r0, #0
	add r3, #0x4a
	ldrh r4, [r3]
	bic r4, r1
	orr r2, r4
	mov r1, #0x20
	orr r1, r2
	strh r1, [r3]
	add r1, r0, #0
	mov r2, #0xf
	lsl r2, r2, #0xc
	add r1, #0x40
	strh r2, [r1]
	ldr r2, _0221D0E4 ; =0x04000304
	mov r1, #0x10
	add r0, #0x44
	strh r1, [r0]
	ldrh r1, [r2]
	ldr r0, _0221D0E8 ; =0xFFFF7FFF
	and r0, r1
	strh r0, [r2]
	add sp, #0xd4
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D0C0: .word ov65_0221FD58
_0221D0C4: .word ov65_0221FDF0
_0221D0C8: .word ov65_0221FDB8
_0221D0CC: .word ov65_0221FE0C
_0221D0D0: .word ov65_0221FE28
_0221D0D4: .word ov65_0221FD80
_0221D0D8: .word ov65_0221FD9C
_0221D0DC: .word ov65_0221FDD4
_0221D0E0: .word 0xFFFF1FFF
_0221D0E4: .word 0x04000304
_0221D0E8: .word 0xFFFF7FFF
	thumb_func_end ov65_0221CEB8

	thumb_func_start ov65_0221D0EC
ov65_0221D0EC: ; 0x0221D0EC
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r0, r1, #0
	bl OverlayManager_GetArgs
	add r4, r0, #0
	mov r2, #6
	ldr r0, _0221D1B0 ; =0x00000674
	str r4, [r5, #8]
	mov r1, #4
	str r1, [r5, r0]
	mov r3, #0
	str r3, [r5, #0x50]
	sub r0, r0, #4
	str r3, [r5, r0]
	mov r0, #0x5e
	lsl r0, r0, #2
	str r2, [r5, r0]
	add r1, r0, #4
	str r2, [r5, r1]
	add r1, r5, #0
	add r1, #0x94
	str r3, [r1]
	add r1, r5, #0
	add r1, #0x98
	str r2, [r1]
	sub r0, #0x2c
	str r3, [r5, r0]
	str r3, [r5, #0x54]
	ldr r0, _0221D1B4 ; =ov65_0221E050
	ldr r1, _0221D1B8 ; =0x00002220
	str r3, [r5, #0x58]
	str r0, [r5, r1]
	str r3, [r5, #0x6c]
	str r3, [r5, #0x70]
	ldr r0, _0221D1BC ; =0x0000211C
	str r3, [r5, #0x68]
	str r3, [r5, r0]
	ldr r0, _0221D1C0 ; =0x000036AC
	sub r6, r2, #7
	str r6, [r5, r0]
	add r2, r0, #4
	str r6, [r5, r2]
	add r2, r1, #0
	add r2, #0xac
	str r3, [r5, r2]
	add r2, r0, #0
	add r2, #0xc
	str r3, [r5, r2]
	add r0, #0x10
	str r3, [r5, r0]
	add r0, r1, #4
	ldr r2, [r4, #8]
	add r1, #0x10
	str r2, [r5, r0]
	ldr r0, [r4, #0xc]
	str r0, [r5, r1]
	ldr r0, [r4, #0x10]
	str r0, [r5, #4]
	bl SaveArray_Party_sizeof
	add r1, r0, #0
	mov r0, #0x1a
	bl Heap_Alloc
	ldr r1, _0221D1C4 ; =0x00002228
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	mov r1, #6
	bl Party_InitWithMaxSize
	bl SaveArray_Party_sizeof
	add r2, r0, #0
	ldr r0, _0221D1C4 ; =0x00002228
	mov r1, #0xff
	ldr r0, [r5, r0]
	bl memset
	ldr r0, [r4, #4]
	mov r1, #0x1a
	bl PlayerProfile_GetPlayerName_NewString
	mov r1, #0x66
	lsl r1, r1, #2
	str r0, [r5, r1]
	sub r1, #8
	ldr r0, [r5, r1]
	mov r1, #0x2a
	bl NewString_ReadMsgData
	mov r1, #0x67
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r4, #0x14]
	bl sub_02039F68
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221D1B0: .word 0x00000674
_0221D1B4: .word ov65_0221E050
_0221D1B8: .word 0x00002220
_0221D1BC: .word 0x0000211C
_0221D1C0: .word 0x000036AC
_0221D1C4: .word 0x00002228
	thumb_func_end ov65_0221D0EC

	thumb_func_start ov65_0221D1C8
ov65_0221D1C8: ; 0x0221D1C8
	push {r4, lr}
	add r4, r0, #0
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
	add r0, r4, #0
	mov r1, #0
	bl FreeBgTilemapBuffer
	pop {r4, pc}
	thumb_func_end ov65_0221D1C8

	thumb_func_start ov65_0221D204
ov65_0221D204: ; 0x0221D204
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r2, #0
	mov r2, #1
	add r4, r3, #0
	str r2, [sp]
	ldr r2, [sp, #0x20]
	ldr r3, [sp, #0x24]
	bl GfGfxLoader_LoadFromOpenNarc
	add r6, r0, #0
	beq _0221D256
	add r1, sp, #4
	bl NNS_G2dGetUnpackedScreenData
	cmp r0, #0
	beq _0221D250
	ldr r0, [sp, #0x1c]
	cmp r0, #0
	bne _0221D232
	ldr r0, [sp, #4]
	ldr r0, [r0, #8]
	str r0, [sp, #0x1c]
_0221D232:
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl GetBgTilemapBuffer
	cmp r0, #0
	beq _0221D250
	ldr r2, [sp, #4]
	lsl r1, r4, #0x18
	ldr r3, [sp, #0x1c]
	add r0, r5, #0
	lsr r1, r1, #0x18
	add r2, #0xc
	bl BG_LoadScreenTilemapData
_0221D250:
	add r0, r6, #0
	bl Heap_Free
_0221D256:
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov65_0221D204

	thumb_func_start ov65_0221D25C
ov65_0221D25C: ; 0x0221D25C
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #2
	add r4, r0, #0
	bl GetBgTilemapBuffer
	add r2, r0, #0
	mov r0, #0
	mov r3, #6
	str r0, [sp]
	add r0, r4, #0
	mov r1, #2
	lsl r3, r3, #8
	bl BgCopyOrUncompressTilemapBufferRangeToVram
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov65_0221D25C

	thumb_func_start ov65_0221D280
ov65_0221D280: ; 0x0221D280
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r1, #0
	mov r1, #6
	lsl r1, r1, #6
	ldr r4, [r0, r1]
	sub r1, #0x60
	str r1, [sp]
	mov r0, #0x1a
	mov r1, #0
	str r0, [sp, #4]
	add r0, r5, #0
	mov r2, #4
	add r3, r1, #0
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r1, #0
	mov r0, #0x12
	lsl r0, r0, #4
	str r0, [sp]
	mov r0, #0x1a
	str r0, [sp, #4]
	add r0, r5, #0
	add r2, r1, #0
	add r3, r1, #0
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r0, #0
	add r1, r0, #0
	bl BG_SetMaskColor
	mov r0, #4
	mov r1, #0
	bl BG_SetMaskColor
	mov r1, #0x1a
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #0x1a
	bl LoadFontPal1
	mov r0, #0
	str r0, [sp]
	mov r0, #9
	lsl r0, r0, #0xa
	str r0, [sp, #4]
	mov r1, #1
	str r1, [sp, #8]
	mov r0, #0x1a
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r2, r4, #0
	mov r3, #2
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #6
	lsl r0, r0, #8
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x1a
	str r0, [sp, #0xc]
	add r0, r5, #0
	mov r1, #3
	add r2, r4, #0
	mov r3, #2
	bl ov65_0221D204
	mov r0, #0
	str r0, [sp]
	mov r0, #6
	lsl r0, r0, #8
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x1a
	str r0, [sp, #0xc]
	add r0, r5, #0
	mov r1, #4
	add r2, r4, #0
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	mov r1, #0x40
	mov r2, #0x1a
	bl LoadFontPal1
	mov r0, #0
	mov r1, #0x60
	mov r2, #0x1a
	bl LoadFontPal0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	lsl r0, r0, #0xa
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x1a
	str r0, [sp, #0xc]
	add r0, r5, #0
	mov r1, #2
	add r2, r4, #0
	mov r3, #5
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #6
	lsl r0, r0, #8
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x1a
	mov r1, #5
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r2, r4, #0
	add r3, r1, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #6
	lsl r0, r0, #8
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x1a
	mov r1, #6
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r2, r4, #0
	add r3, r1, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #4
	mov r1, #0x40
	mov r2, #0x1a
	bl LoadFontPal1
	mov r0, #4
	mov r1, #0x60
	mov r2, #0x1a
	bl LoadFontPal0
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov65_0221D280

	thumb_func_start ov65_0221D3B8
ov65_0221D3B8: ; 0x0221D3B8
	push {r4, lr}
	sub sp, #0x10
	ldr r4, _0221D3E4 ; =ov65_0221FD48
	add r3, sp, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl ObjCharTransfer_Init
	mov r0, #0x14
	mov r1, #0x1a
	bl ObjPlttTransfer_Init
	bl ObjCharTransfer_ClearBuffers
	bl ObjPlttTransfer_Reset
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_0221D3E4: .word ov65_0221FD48
	thumb_func_end ov65_0221D3B8

	thumb_func_start ov65_0221D3E8
ov65_0221D3E8: ; 0x0221D3E8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	add r7, r1, #0
	bl NNS_G2dInitOamManagerModule
	mov r0, #0
	str r0, [sp]
	mov r1, #0x64
	str r1, [sp, #4]
	str r0, [sp, #8]
	mov r3, #0x20
	str r3, [sp, #0xc]
	mov r2, #0x1a
	str r2, [sp, #0x10]
	add r2, r0, #0
	bl OamManager_Create
	mov r1, #0x69
	lsl r1, r1, #2
	mov r0, #0x2d
	add r1, r5, r1
	mov r2, #0x1a
	bl G2dRenderer_Init
	mov r1, #0x1a
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r6, #0
	add r4, r5, #0
_0221D424:
	mov r0, #2
	add r1, r6, #0
	mov r2, #0x1a
	bl Create2DGfxResObjMan
	mov r1, #0xb3
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #4
	blt _0221D424
	mov r0, #0
	str r0, [sp]
	mov r3, #1
	str r3, [sp, #4]
	mov r0, #0x1a
	str r0, [sp, #8]
	add r0, r1, #0
	ldr r0, [r5, r0]
	add r1, r7, #0
	mov r2, #7
	bl AddCharResObjFromOpenNarc
	mov r1, #0xb7
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r2, #0
	str r2, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #9
	str r0, [sp, #8]
	mov r0, #0x1a
	sub r1, #0xc
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r7, #0
	add r3, r2, #0
	bl AddPlttResObjFromOpenNarc
	mov r1, #0x2e
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x1a
	sub r1, #0xc
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r7, #0
	mov r2, #8
	mov r3, #1
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0xb9
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x1a
	sub r1, #0xc
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r7, #0
	mov r2, #9
	mov r3, #1
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0xba
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r3, #1
	str r3, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x1a
	sub r1, #0x1c
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r7, #0
	mov r2, #0xa
	bl AddCharResObjFromOpenNarc
	mov r1, #0xbb
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0xa
	str r0, [sp, #8]
	mov r0, #0x1a
	mov r2, #0
	sub r1, #0x1c
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r7, #0
	add r3, r2, #0
	bl AddPlttResObjFromOpenNarc
	mov r1, #0x2f
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r3, #1
	str r3, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x1a
	sub r1, #0x1c
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r7, #0
	mov r2, #0xb
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r3, #1
	str r3, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x1a
	sub r1, #0x1c
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r7, #0
	mov r2, #0xc
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0xbe
	lsl r1, r1, #2
	str r0, [r5, r1]
	sub r1, #0x1c
	ldr r0, [r5, r1]
	bl SpriteTransfer_CreateCharTransferTask
	mov r0, #0xbb
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl SpriteTransfer_CreateCharTransferTask
	mov r0, #0x2e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl SpriteTransfer_CreateExtPlttTransferTask
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl SpriteTransfer_CreateExtPlttTransferTask
	bl sub_02074490
	add r1, r0, #0
	mov r0, #0x80
	str r0, [sp]
	mov r0, #0x1a
	str r0, [sp, #4]
	mov r0, #0x14
	mov r2, #1
	lsl r3, r0, #4
	bl GfGfxLoader_GXLoadPal
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov65_0221D3E8

	thumb_func_start ov65_0221D57C
ov65_0221D57C: ; 0x0221D57C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r7, r0, #0
	add r6, r2, #0
	add r0, r3, #0
	mov r2, #2
	add r5, r1, #0
	str r3, [sp, #0x20]
	bl GetPokemonSpriteCharAndPlttNarcIds
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	bl GetMonData
	str r0, [sp, #0x24]
	add r0, r5, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #0x4c
	mov r2, #0
	bl GetMonData
	cmp r0, #1
	bne _0221D5C0
	ldr r0, _0221D5F8 ; =0x00000147
	cmp r4, r0
	bne _0221D5C0
	add r4, r0, #0
	add r4, #0xa7
_0221D5C0:
	mov r3, #0
	str r3, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [sp, #0x24]
	str r6, [sp, #0xc]
	str r0, [sp, #0x10]
	str r3, [sp, #0x14]
	mov r0, #2
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x20]
	str r4, [sp, #0x1c]
	ldr r1, [sp, #0x20]
	ldrh r0, [r0]
	ldrh r1, [r1, #2]
	mov r2, #0x1a
	bl sub_02014494
	mov r1, #0x32
	add r0, r6, #0
	lsl r1, r1, #6
	bl DC_FlushRange
	add r0, r7, #1
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221D5F8: .word 0x00000147
	thumb_func_end ov65_0221D57C

	thumb_func_start ov65_0221D5FC
ov65_0221D5FC: ; 0x0221D5FC
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r6, r1, #0
	add r7, r2, #0
	mov r0, #0x14
	mov r1, #0x1a
	str r3, [sp, #8]
	bl String_New
	add r4, r0, #0
	add r0, r6, #0
	add r1, r7, #0
	bl Party_GetMonByIndex
	mov r1, #0x77
	add r2, r4, #0
	bl GetMonData
	add r0, r5, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x20]
	ldr r2, [sp, #8]
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	mov r3, #0
	bl ov65_0221FB4C
	add r0, r4, #0
	bl String_Delete
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov65_0221D5FC

	thumb_func_start ov65_0221D648
ov65_0221D648: ; 0x0221D648
	push {r4, lr}
	ldrh r0, [r0]
	add r4, r3, #0
	cmp r0, #0x1d
	beq _0221D656
	cmp r0, #0x20
	bne _0221D66E
_0221D656:
	add r0, r1, #0
	add r1, r2, #0
	bl Party_GetMonByIndex
	mov r1, #0x4d
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	bne _0221D66E
	mov r0, #2
	pop {r4, pc}
_0221D66E:
	add r0, r4, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov65_0221D648
