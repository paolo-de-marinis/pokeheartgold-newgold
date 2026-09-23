#include "constants/moves.h"
	.include "asm/macros.inc"
	.include "overlay_08.inc"
	.include "global.inc"

	.text

	thumb_func_start ov08_02222D78
ov08_02222D78: ; 0x02222D78
	push {r3, lr}
	mov r1, #0
	bl ov08_02223300
	mov r0, #1
	pop {r3, pc}
	thumb_func_end ov08_02222D78

	thumb_func_start ov08_02222D84
ov08_02222D84: ; 0x02222D84
	push {r3, lr}
	mov r1, #1
	bl ov08_02223300
	mov r0, #2
	pop {r3, pc}
	thumb_func_end ov08_02222D84

	thumb_func_start ov08_02222D90
ov08_02222D90: ; 0x02222D90
	push {r3, lr}
	mov r1, #2
	bl ov08_02223300
	mov r0, #3
	pop {r3, pc}
	thumb_func_end ov08_02222D90

	thumb_func_start ov08_02222D9C
ov08_02222D9C: ; 0x02222D9C
	push {r3, lr}
	add r0, #0x1c
	mov r1, #0
	bl ClearFrameAndWindow2
	mov r0, #3
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov08_02222D9C

	thumb_func_start ov08_02222DAC
ov08_02222DAC: ; 0x02222DAC
	push {r3, lr}
	add r0, #0x32
	ldrb r0, [r0]
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _02222DBE
	mov r0, #0xa
	pop {r3, pc}
_02222DBE:
	mov r0, #9
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov08_02222DAC

	thumb_func_start ov08_02222DC4
ov08_02222DC4: ; 0x02222DC4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02222DE4 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	bne _02222DDA
	bl System_GetTouchNew
	cmp r0, #1
	bne _02222DE0
_02222DDA:
	ldr r0, _02222DE8 ; =0x0000114B
	ldrb r0, [r4, r0]
	pop {r4, pc}
_02222DE0:
	mov r0, #0xa
	pop {r4, pc}
	.balign 4, 0
_02222DE4: .word gSystem
_02222DE8: .word 0x0000114B
	thumb_func_end ov08_02222DC4

	thumb_func_start ov08_02222DEC
ov08_02222DEC: ; 0x02222DEC
	ldr r1, _02222E00 ; =0x0000113E
	ldrb r2, [r0, r1]
	cmp r2, #2
	bne _02222DFA
	add r1, #0xd
	ldrb r0, [r0, r1]
	bx lr
_02222DFA:
	mov r0, #0xb
	bx lr
	nop
_02222E00: .word 0x0000113E
	thumb_func_end ov08_02222DEC

	thumb_func_start ov08_02222E04
ov08_02222E04: ; 0x02222E04
	push {lr}
	sub sp, #0xc
	mov r2, #0
	str r2, [sp]
	mov r1, #0x10
	str r1, [sp, #4]
	str r2, [sp, #8]
	mov r1, #0xa
	add r3, r1, #0
	ldr r0, [r0, #8]
	ldr r2, _02222E28 ; =0x0000FFFF
	sub r3, #0x12
	bl PaletteData_BeginPaletteFade
	mov r0, #0xe
	add sp, #0xc
	pop {pc}
	nop
_02222E28: .word 0x0000FFFF
	thumb_func_end ov08_02222E04

	thumb_func_start ov08_02222E2C
ov08_02222E2C: ; 0x02222E2C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r7, r0, #0
	ldr r0, [r5, #8]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	beq _02222E40
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_02222E40:
	add r0, r5, #0
	bl ov08_02223F34
	add r0, r5, #0
	bl ov08_02223464
	add r0, r5, #0
	bl ov08_02223228
	ldr r0, [r5, #4]
	bl ov08_022230CC
	ldr r0, [r5, #0x34]
	bl ov08_02224B8C
	ldr r1, [r5]
	add r1, #0x25
	strb r0, [r1]
	ldr r0, [r5, #0x34]
	bl ov08_02224B7C
	mov r0, #4
	bl FontID_Release
	ldr r1, [r5]
	ldrh r0, [r1, #0x1c]
	cmp r0, #0
	beq _02222EAC
	ldr r0, [r1]
	bl BattleSystem_GetBagCursor
	add r6, r0, #0
	mov r4, #0
_02222E82:
	ldr r3, [r5]
	add r0, r6, #0
	add r2, r3, r4
	add r3, r3, r4
	add r2, #0x27
	add r3, #0x2c
	ldrb r2, [r2]
	ldrb r3, [r3]
	add r1, r4, #0
	bl BagCursor_Battle_PocketSetPosition
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #5
	blo _02222E82
	ldr r1, _02222EC0 ; =0x0000114D
	add r0, r6, #0
	ldrb r1, [r5, r1]
	bl BagCursor_Battle_SetPocket
_02222EAC:
	ldr r0, [r5]
	mov r1, #1
	add r0, #0x26
	strb r1, [r0]
	add r0, r7, #0
	bl DestroySysTaskAndEnvironment
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02222EC0: .word 0x0000114D
	thumb_func_end ov08_02222E2C

	thumb_func_start ov08_02222EC4
ov08_02222EC4: ; 0x02222EC4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #8]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	beq _02222ED6
	mov r0, #0xc
	pop {r4, pc}
_02222ED6:
	ldr r0, _02222FF0 ; =0x00001159
	ldrb r0, [r4, r0]
	cmp r0, #4
	bls _02222EE0
	b _02222FEA
_02222EE0:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02222EEC: ; jump table
	.short _02222EF6 - _02222EEC - 2 ; case 0
	.short _02222F38 - _02222EEC - 2 ; case 1
	.short _02222F48 - _02222EEC - 2 ; case 2
	.short _02222F92 - _02222EEC - 2 ; case 3
	.short _02222FA2 - _02222EEC - 2 ; case 4
_02222EF6:
	ldr r0, [r4, #0x38]
	bl ov12_0226BD50
	cmp r0, #1
	bne _02222F2E
	ldr r0, _02222FF4 ; =0x000005DD
	bl PlaySE
	ldr r0, _02222FF8 ; =0x0000114D
	mov r1, #2
	strb r1, [r4, r0]
	mov r2, #0xc
	sub r0, r0, #2
	strb r2, [r4, r0]
	add r0, r4, #0
	mov r2, #0
	bl ov08_02224938
	ldr r0, _02222FFC ; =0x0000115A
	mov r1, #0
	strb r1, [r4, r0]
	sub r1, r0, #1
	ldrb r1, [r4, r1]
	sub r0, r0, #1
	add r1, r1, #1
	strb r1, [r4, r0]
	mov r0, #0xb
	pop {r4, pc}
_02222F2E:
	ldr r0, _02222FFC ; =0x0000115A
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _02222FEA
_02222F38:
	add r0, r4, #0
	bl ov08_02222D84
	ldr r0, _02222FF0 ; =0x00001159
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _02222FEA
_02222F48:
	ldr r0, [r4, #0x38]
	bl ov12_0226BD50
	cmp r0, #1
	bne _02222F88
	ldr r0, _02222FF4 ; =0x000005DD
	bl PlaySE
	ldr r0, _02222FF8 ; =0x0000114D
	ldr r3, [r4]
	ldrb r1, [r4, r0]
	mov r2, #0
	sub r0, r0, #2
	add r1, r3, r1
	add r1, #0x27
	strb r2, [r1]
	mov r1, #0xc
	strb r1, [r4, r0]
	add r0, r4, #0
	mov r1, #6
	bl ov08_02224938
	ldr r0, _02222FFC ; =0x0000115A
	mov r1, #0
	strb r1, [r4, r0]
	sub r1, r0, #1
	ldrb r1, [r4, r1]
	sub r0, r0, #1
	add r1, r1, #1
	strb r1, [r4, r0]
	mov r0, #0xb
	pop {r4, pc}
_02222F88:
	ldr r0, _02222FFC ; =0x0000115A
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _02222FEA
_02222F92:
	add r0, r4, #0
	bl ov08_02222D90
	ldr r0, _02222FF0 ; =0x00001159
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _02222FEA
_02222FA2:
	ldr r0, [r4, #0x38]
	bl ov12_0226BD50
	cmp r0, #1
	bne _02222FE2
	ldr r0, _02222FF4 ; =0x000005DD
	bl PlaySE
	ldr r1, _02222FF8 ; =0x0000114D
	ldr r2, [r4]
	ldrb r1, [r4, r1]
	add r0, r4, #0
	add r1, r2, r1
	add r1, #0x27
	ldrb r1, [r1]
	bl ov08_02223CD4
	ldr r1, [r4]
	mov r2, #0
	strh r0, [r1, #0x1c]
	ldr r0, _02222FF8 ; =0x0000114D
	ldrb r1, [r4, r0]
	ldr r0, [r4]
	strb r1, [r0, #0x1e]
	add r0, r4, #0
	mov r1, #0xf
	bl ov08_02224938
	add r0, r4, #0
	bl ov08_02222B8C
	pop {r4, pc}
_02222FE2:
	ldr r0, _02222FFC ; =0x0000115A
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
_02222FEA:
	mov r0, #0xc
	pop {r4, pc}
	nop
_02222FF0: .word 0x00001159
_02222FF4: .word 0x000005DD
_02222FF8: .word 0x0000114D
_02222FFC: .word 0x0000115A
	thumb_func_end ov08_02222EC4

	thumb_func_start ov08_02223000
ov08_02223000: ; 0x02223000
	push {r4, r5, lr}
	sub sp, #0x64
	ldr r5, _022230BC ; =ov08_02225AE8
	add r3, sp, #0x54
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	mov r1, #1
	bl SetScreenModeAndDisable
	ldr r5, _022230C0 ; =ov08_02225B30
	add r3, sp, #0x38
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
	ldr r0, [r4, #4]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r5, _022230C4 ; =ov08_02225B14
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
	ldr r0, [r4, #4]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r0, [r4, #4]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r5, _022230C8 ; =ov08_02225AF8
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
	ldr r0, [r4, #4]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r0, [r4, #4]
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r3, [r4]
	mov r0, #5
	ldr r3, [r3, #0xc]
	mov r1, #0x20
	mov r2, #0
	bl BG_ClearCharDataRange
	ldr r3, [r4]
	mov r0, #4
	ldr r3, [r3, #0xc]
	mov r1, #0x20
	mov r2, #0
	bl BG_ClearCharDataRange
	ldr r0, [r4, #4]
	mov r1, #5
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, [r4, #4]
	mov r1, #4
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x64
	pop {r4, r5, pc}
	.balign 4, 0
_022230BC: .word ov08_02225AE8
_022230C0: .word ov08_02225B30
_022230C4: .word ov08_02225B14
_022230C8: .word ov08_02225AF8
	thumb_func_end ov08_02223000

	thumb_func_start ov08_022230CC
ov08_022230CC: ; 0x022230CC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x17
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
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
	thumb_func_end ov08_022230CC

	thumb_func_start ov08_022230F4
ov08_022230F4: ; 0x022230F4
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r1, [r5]
	mov r0, #0x4d
	ldr r1, [r1, #0xc]
	bl NARC_New
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	str r1, [sp, #8]
	ldr r1, [r5]
	mov r3, #6
	ldr r1, [r1, #0xc]
	add r4, r0, #0
	str r1, [sp, #0xc]
	ldr r2, [r5, #4]
	mov r1, #2
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	str r1, [sp, #8]
	ldr r0, [r5]
	mov r3, #6
	ldr r0, [r0, #0xc]
	str r0, [sp, #0xc]
	ldr r2, [r5, #4]
	add r0, r4, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r2, [r5]
	add r0, r4, #0
	ldr r2, [r2, #0xc]
	mov r1, #1
	bl NARC_AllocAndReadWholeMember
	add r1, sp, #0x10
	add r6, r0, #0
	bl NNS_G2dGetUnpackedScreenData
	ldr r1, [sp, #0x10]
	add r0, r5, #0
	add r1, #0xc
	bl ov08_02224254
	add r0, r6, #0
	bl Heap_Free
	add r0, r4, #0
	bl NARC_Delete
	mov r0, #1
	str r0, [sp]
	mov r0, #6
	lsl r0, r0, #6
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	ldr r3, [r5]
	ldr r0, [r5, #8]
	ldr r3, [r3, #0xc]
	mov r1, #0x4d
	mov r2, #3
	bl PaletteData_LoadNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xf0
	str r0, [sp, #8]
	ldr r3, [r5]
	ldr r0, [r5, #8]
	ldr r3, [r3, #0xc]
	mov r1, #0x10
	mov r2, #8
	bl PaletteData_LoadNarc
	ldr r0, [r5]
	ldr r0, [r0]
	bl BattleSystem_GetFrame
	add r4, r0, #0
	bl sub_0200E63C
	add r1, r0, #0
	ldr r0, _022231E4 ; =0x000003E2
	mov r3, #4
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5]
	ldr r0, [r0, #0xc]
	str r0, [sp, #0xc]
	ldr r2, [r5, #4]
	mov r0, #0x26
	bl GfGfxLoader_LoadCharData
	add r0, r4, #0
	bl sub_0200E640
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xe0
	str r0, [sp, #8]
	ldr r3, [r5]
	ldr r0, [r5, #8]
	ldr r3, [r3, #0xc]
	mov r1, #0x26
	bl PaletteData_LoadNarc
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_022231E4: .word 0x000003E2
	thumb_func_end ov08_022230F4

	thumb_func_start ov08_022231E8
ov08_022231E8: ; 0x022231E8
	push {r4, lr}
	add r4, r0, #0
	ldr r3, [r4]
	mov r0, #0
	ldr r3, [r3, #0xc]
	mov r1, #0x1b
	mov r2, #5
	bl NewMsgDataFromNarc
	str r0, [r4, #0x10]
	ldr r3, [r4]
	mov r0, #0xf
	ldr r3, [r3, #0xc]
	mov r1, #0xe
	mov r2, #0
	bl MessagePrinter_New
	str r0, [r4, #0xc]
	ldr r0, [r4]
	ldr r0, [r0, #0xc]
	bl MessageFormat_New
	str r0, [r4, #0x14]
	ldr r1, [r4]
	mov r0, #2
	ldr r1, [r1, #0xc]
	lsl r0, r0, #8
	bl String_New
	str r0, [r4, #0x18]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_022231E8

	thumb_func_start ov08_02223228
ov08_02223228: ; 0x02223228
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x10]
	bl DestroyMsgData
	ldr r0, [r4, #0xc]
	bl MessagePrinter_Delete
	ldr r0, [r4, #0x14]
	bl MessageFormat_Delete
	ldr r0, [r4, #0x18]
	bl String_Delete
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_02223228

	thumb_func_start ov08_02223248
ov08_02223248: ; 0x02223248
	push {r4, lr}
	add r4, r0, #0
	cmp r1, #0
	beq _0222325A
	cmp r1, #1
	beq _02223274
	cmp r1, #2
	beq _02223290
	pop {r4, pc}
_0222325A:
	mov r2, #0
	ldr r0, [r4, #4]
	mov r1, #6
	add r3, r2, #0
	bl ScheduleSetBgPosText
	ldr r0, [r4, #4]
	mov r1, #6
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	pop {r4, pc}
_02223274:
	mov r1, #6
	add r3, r1, #0
	ldr r0, [r4, #4]
	mov r2, #0
	add r3, #0xfa
	bl ScheduleSetBgPosText
	ldr r0, [r4, #4]
	mov r1, #6
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	pop {r4, pc}
_02223290:
	mov r2, #0
	ldr r0, [r4, #4]
	mov r1, #6
	add r3, r2, #0
	bl ScheduleSetBgPosText
	mov r2, #3
	add r3, r2, #0
	ldr r0, [r4, #4]
	mov r1, #6
	add r3, #0xfd
	bl ScheduleSetBgPosText
	pop {r4, pc}
	thumb_func_end ov08_02223248

	thumb_func_start ov08_022232AC
ov08_022232AC: ; 0x022232AC
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	cmp r1, #2
	bne _022232F6
	mov r0, #0x1c
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _022232FC ; =0x0000114D
	mov r1, #6
	ldrb r0, [r4, r0]
	mov r2, #2
	mov r3, #0x23
	add r0, #8
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	bl BgTilemapRectChangePalette
	mov r0, #0x1c
	str r0, [sp]
	mov r0, #8
	str r0, [sp, #4]
	ldr r0, _022232FC ; =0x0000114D
	mov r1, #6
	ldrb r0, [r4, r0]
	mov r2, #2
	mov r3, #0x28
	add r0, #8
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	bl BgTilemapRectChangePalette
_022232F6:
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_022232FC: .word 0x0000114D
	thumb_func_end ov08_022232AC

	thumb_func_start ov08_02223300
ov08_02223300: ; 0x02223300
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov08_022232AC
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02223248
	ldr r0, [r5, #4]
	mov r1, #4
	mov r2, #0
	bl BgFillTilemapBufferAndSchedule
	ldr r0, [r5, #4]
	mov r1, #5
	mov r2, #0
	bl BgFillTilemapBufferAndSchedule
	add r0, r5, #0
	bl ov08_02223454
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_022233DC
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02223480
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02224A50
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02224134
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_0222421C
	ldr r1, _02223364 ; =0x0000114C
	add r0, r5, #0
	strb r4, [r5, r1]
	ldrb r1, [r5, r1]
	bl ov08_02223F94
	pop {r3, r4, r5, pc}
	nop
_02223364: .word 0x0000114C
	thumb_func_end ov08_02223300

	thumb_func_start ov08_02223368
ov08_02223368: ; 0x02223368
	ldr r3, _02223370 ; =TouchscreenHitbox_FindRectAtTouchNew
	add r0, r1, #0
	bx r3
	nop
_02223370: .word TouchscreenHitbox_FindRectAtTouchNew
	thumb_func_end ov08_02223368

	thumb_func_start ov08_02223374
ov08_02223374: ; 0x02223374
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5]
	ldr r0, [r4]
	bl BattleSystem_GetBattleContext
	add r1, r0, #0
	ldr r0, [r5]
	ldr r3, [r4, #0x10]
	ldr r0, [r0]
	mov r2, #2
	bl ov12_022581D4
	pop {r3, r4, r5, pc}
	thumb_func_end ov08_02223374

	thumb_func_start ov08_02223390
ov08_02223390: ; 0x02223390
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r4, r3, #0
	add r6, r0, #0
	add r7, r2, #0
	bl BattleSystem_GetBag
	add r1, r5, #0
	mov r2, #1
	add r3, r4, #0
	bl Bag_TakeItem
	add r0, r6, #0
	bl BattleSystem_GetBagCursor
	add r1, r5, #0
	add r2, r7, #0
	bl BagCursor_Battle_SetLastUsedItem
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov08_02223390

	thumb_func_start ov08_022233B8
ov08_022233B8: ; 0x022233B8
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	ldr r0, [r4, #4]
	ldr r2, _022233D4 ; =ov08_02225B90
	add r1, #0x1c
	bl AddWindow
	ldr r1, _022233D8 ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_022233DC
	pop {r4, pc}
	.balign 4, 0
_022233D4: .word ov08_02225B90
_022233D8: .word 0x0000114C
	thumb_func_end ov08_022233B8

	thumb_func_start ov08_022233DC
ov08_022233DC: ; 0x022233DC
	push {r4, r5, r6, lr}
	add r5, r0, #0
	cmp r1, #0
	beq _022233EE
	cmp r1, #1
	beq _022233F8
	cmp r1, #2
	beq _02223402
	b _0222340A
_022233EE:
	mov r1, #5
	add r0, #0x30
	ldr r6, _02223448 ; =ov08_02225BB8
	strb r1, [r0]
	b _0222340A
_022233F8:
	mov r1, #0x1a
	add r0, #0x30
	ldr r6, _0222344C ; =ov08_02225C10
	strb r1, [r0]
	b _0222340A
_02223402:
	ldr r6, _02223450 ; =ov08_02225B98
	mov r1, #4
	add r0, #0x30
	strb r1, [r0]
_0222340A:
	add r1, r5, #0
	ldr r0, [r5]
	add r1, #0x30
	ldrb r1, [r1]
	ldr r0, [r0, #0xc]
	bl AllocWindows
	str r0, [r5, #0x2c]
	add r0, r5, #0
	add r0, #0x30
	ldrb r0, [r0]
	mov r4, #0
	cmp r0, #0
	bls _02223446
_02223426:
	ldr r2, [r5, #0x2c]
	lsl r1, r4, #4
	add r1, r2, r1
	lsl r2, r4, #3
	ldr r0, [r5, #4]
	add r2, r6, r2
	bl AddWindow
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	add r0, r5, #0
	add r0, #0x30
	ldrb r0, [r0]
	cmp r4, r0
	blo _02223426
_02223446:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02223448: .word ov08_02225BB8
_0222344C: .word ov08_02225C10
_02223450: .word ov08_02225B98
	thumb_func_end ov08_022233DC

	thumb_func_start ov08_02223454
ov08_02223454: ; 0x02223454
	add r1, r0, #0
	ldr r0, [r1, #0x2c]
	add r1, #0x30
	ldr r3, _02223460 ; =WindowArray_Delete
	ldrb r1, [r1]
	bx r3
	.balign 4, 0
_02223460: .word WindowArray_Delete
	thumb_func_end ov08_02223454

	thumb_func_start ov08_02223464
ov08_02223464: ; 0x02223464
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x30
	ldrb r1, [r1]
	ldr r0, [r4, #0x2c]
	bl WindowArray_Delete
	add r4, #0x1c
	add r0, r4, #0
	bl RemoveWindow
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_02223464

	thumb_func_start ov08_02223480
ov08_02223480: ; 0x02223480
	push {r3, lr}
	cmp r1, #0
	beq _02223490
	cmp r1, #1
	beq _02223496
	cmp r1, #2
	beq _0222349C
	pop {r3, pc}
_02223490:
	bl ov08_022234FC
	pop {r3, pc}
_02223496:
	bl ov08_022239B4
	pop {r3, pc}
_0222349C:
	bl ov08_02223AA0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov08_02223480

	thumb_func_start ov08_022234A4
ov08_022234A4: ; 0x022234A4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	ldr r5, [r0, #0x2c]
	lsl r4, r1, #4
	ldr r0, [r0, #0x10]
	add r1, r2, #0
	add r6, r3, #0
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	ldr r1, [sp, #0x10]
	add r0, r6, #0
	mov r2, #0
	bl FontID_String_GetWidth
	add r7, r0, #0
	add r0, r5, r4
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsr r3, r0, #1
	ldr r0, [sp, #0x28]
	ldr r2, [sp, #0x10]
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, [sp, #0x2c]
	add r1, r6, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r5, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_022234A4

	thumb_func_start ov08_022234FC
ov08_022234FC: ; 0x022234FC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	mov r6, #0
	add r5, r0, #0
	add r4, r6, #0
	add r7, r6, #0
_02223508:
	ldr r0, [r5, #0x2c]
	add r1, r7, #0
	add r0, r0, r4
	bl FillWindowPixelBuffer
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #5
	blo _02223508
	mov r0, #7
	str r0, [sp]
	ldr r0, _022235D0 ; =0x00030201
	mov r1, #0
	str r0, [sp, #4]
	add r0, r5, #0
	add r2, r1, #0
	mov r3, #4
	bl ov08_022234A4
	mov r0, #0x17
	str r0, [sp]
	ldr r0, _022235D0 ; =0x00030201
	mov r1, #0
	str r0, [sp, #4]
	add r0, r5, #0
	mov r2, #1
	mov r3, #4
	bl ov08_022234A4
	mov r0, #7
	str r0, [sp]
	ldr r0, _022235D0 ; =0x00030201
	mov r1, #1
	str r0, [sp, #4]
	add r0, r5, #0
	mov r2, #2
	mov r3, #4
	bl ov08_022234A4
	mov r0, #0x17
	str r0, [sp]
	ldr r0, _022235D0 ; =0x00030201
	mov r1, #1
	str r0, [sp, #4]
	add r0, r5, #0
	mov r2, #3
	mov r3, #4
	bl ov08_022234A4
	mov r2, #7
	ldr r0, _022235D0 ; =0x00030201
	str r2, [sp]
	str r0, [sp, #4]
	add r0, r5, #0
	mov r1, #2
	mov r3, #4
	bl ov08_022234A4
	mov r0, #7
	str r0, [sp]
	ldr r0, _022235D0 ; =0x00030201
	mov r1, #3
	str r0, [sp, #4]
	add r0, r5, #0
	mov r2, #6
	mov r3, #4
	bl ov08_022234A4
	ldr r0, [r5]
	ldrh r0, [r0, #0x20]
	cmp r0, #0
	beq _022235CC
	ldr r0, [r5, #0x10]
	mov r1, #8
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #5
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022235D0 ; =0x00030201
	mov r3, #0
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	ldr r0, [r5, #0x2c]
	mov r1, #4
	add r0, #0x40
	add r2, r4, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	ldr r0, [r5, #0x2c]
	add r0, #0x40
	bl ScheduleWindowCopyToVram
_022235CC:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_022235D0: .word 0x00030201
	thumb_func_end ov08_022234FC

	thumb_func_start ov08_022235D4
ov08_022235D4: ; 0x022235D4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r4, [r5, #0x2c]
	lsl r6, r3, #4
	add r7, r1, #0
	add r0, r4, r6
	mov r1, #0
	str r2, [sp, #0x10]
	bl FillWindowPixelBuffer
	ldr r0, _02223670 ; =0x0000114D
	lsl r7, r7, #2
	ldrb r1, [r5, r0]
	mov r0, #0x90
	mul r0, r1
	add r0, r5, r0
	add r0, r0, r7
	ldrh r0, [r0, #0x3c]
	cmp r0, #0
	beq _02223666
	ldr r1, [sp, #0x10]
	ldr r0, [r5, #0x10]
	lsl r2, r1, #3
	ldr r1, _02223674 ; =ov08_02225BE0
	ldr r1, [r1, r2]
	bl NewString_ReadMsgData
	ldr r2, _02223670 ; =0x0000114D
	str r0, [sp, #0x14]
	ldrb r3, [r5, r2]
	mov r2, #0x90
	ldr r0, [r5, #0x14]
	mul r2, r3
	add r2, r5, r2
	add r2, r2, r7
	ldrh r2, [r2, #0x3c]
	mov r1, #0
	bl BufferItemName
	ldr r0, [r5, #0x14]
	ldr r1, [r5, #0x18]
	ldr r2, [sp, #0x14]
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x30]
	ldr r1, [r5, #0x18]
	mov r2, #0
	bl FontID_String_GetWidth
	add r7, r0, #0
	add r0, r4, r6
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsr r3, r0, #1
	mov r0, #7
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, [sp, #0x34]
	ldr r1, [sp, #0x30]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r2, [r5, #0x18]
	add r0, r4, r6
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x14]
	bl String_Delete
_02223666:
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02223670: .word 0x0000114D
_02223674: .word ov08_02225BE0
	thumb_func_end ov08_022235D4

	thumb_func_start ov08_02223678
ov08_02223678: ; 0x02223678
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r4, [r5, #0x2c]
	lsl r7, r3, #4
	add r6, r1, #0
	add r0, r4, r7
	mov r1, #0
	str r2, [sp, #0x10]
	bl FillWindowPixelBuffer
	ldr r0, _02223704 ; =0x0000114D
	lsl r6, r6, #2
	ldrb r1, [r5, r0]
	mov r0, #0x90
	mul r0, r1
	add r0, r5, r0
	add r0, r0, r6
	ldrh r0, [r0, #0x3e]
	cmp r0, #0
	beq _022236FA
	ldr r1, [sp, #0x10]
	ldr r0, [r5, #0x10]
	lsl r2, r1, #3
	ldr r1, _02223708 ; =ov08_02225BE4
	ldr r1, [r1, r2]
	bl NewString_ReadMsgData
	mov r1, #0
	str r0, [sp, #0x14]
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, _02223704 ; =0x0000114D
	ldr r0, [r5, #0x14]
	ldrb r3, [r5, r2]
	mov r2, #0x90
	mul r2, r3
	add r2, r5, r2
	add r2, r2, r6
	ldrh r2, [r2, #0x3e]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, [r5, #0x14]
	ldr r1, [r5, #0x18]
	ldr r2, [sp, #0x14]
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x34]
	mov r3, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, [sp, #0x38]
	ldr r1, [sp, #0x30]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	ldr r2, [r5, #0x18]
	add r0, r4, r7
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x14]
	bl String_Delete
_022236FA:
	add r0, r4, r7
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02223704: .word 0x0000114D
_02223708: .word ov08_02225BE4
	thumb_func_end ov08_02223678

	thumb_func_start ov08_0222370C
ov08_0222370C: ; 0x0222370C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r6, r0, #0
	ldr r0, _02223770 ; =0x0000114D
	add r5, r1, #0
	ldrb r0, [r6, r0]
	ldr r1, [r6]
	add r0, r1, r0
	add r0, #0x2c
	ldrb r1, [r0]
	mov r0, #6
	mul r0, r1
	str r0, [sp, #0xc]
	add r0, r6, #0
	add r0, #0x31
	ldrb r0, [r0]
	cmp r0, #0
	bne _02223734
	mov r4, #0
	b _02223736
_02223734:
	mov r4, #0xc
_02223736:
	mov r0, #4
	str r0, [sp]
	ldr r0, _02223774 ; =0x00030201
	ldr r1, [sp, #0xc]
	lsl r7, r5, #1
	str r0, [sp, #4]
	add r0, r6, #0
	add r1, r5, r1
	add r2, r5, #0
	add r3, r4, r7
	bl ov08_022235D4
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _02223778 ; =0x00010200
	ldr r1, [sp, #0xc]
	add r3, r4, #1
	str r0, [sp, #8]
	add r0, r6, #0
	add r1, r5, r1
	add r2, r5, #0
	add r3, r3, r7
	bl ov08_02223678
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02223770: .word 0x0000114D
_02223774: .word 0x00030201
_02223778: .word 0x00010200
	thumb_func_end ov08_0222370C

	thumb_func_start ov08_0222377C
ov08_0222377C: ; 0x0222377C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x13
	str r0, [sp, #8]
	mov r0, #0x11
	str r0, [sp, #0xc]
	ldr r0, [r4, #4]
	mov r1, #5
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r5, #0
_0222379E:
	add r0, r4, #0
	add r1, r5, #0
	bl ov08_0222370C
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #6
	blo _0222379E
	add r0, r4, #0
	add r0, #0x31
	ldrb r1, [r0]
	mov r0, #1
	add r4, #0x31
	eor r0, r1
	strb r0, [r4]
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov08_0222377C

	thumb_func_start ov08_022237C4
ov08_022237C4: ; 0x022237C4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	mov r0, #0x19
	ldr r1, [r5, #0x2c]
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x10]
	mov r1, #0x1c
	ldr r4, [r5, #0x2c]
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	mov r0, #0
	ldr r1, [sp, #0x10]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r7, r0, #0
	mov r0, #0x19
	lsl r0, r0, #4
	add r0, r4, r0
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsr r6, r0, #1
	mov r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022238EC ; =0x00010200
	ldr r2, [sp, #0x10]
	str r0, [sp, #8]
	mov r0, #0x19
	lsl r0, r0, #4
	mov r1, #0
	add r0, r4, r0
	add r3, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	ldr r0, [r5, #0x10]
	mov r1, #0x1d
	bl NewString_ReadMsgData
	mov r1, #0
	str r0, [sp, #0x14]
	ldr r3, _022238F0 ; =0x0000114D
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, _022238F0 ; =0x0000114D
	add r3, r3, #7
	ldrb r2, [r5, r2]
	ldr r0, [r5, #0x14]
	add r2, r5, r2
	ldrb r2, [r2, r3]
	mov r3, #2
	add r2, r2, #1
	bl BufferIntegerAsString
	ldr r0, [r5, #0x14]
	ldr r1, [r5, #0x18]
	ldr r2, [sp, #0x14]
	bl StringExpandPlaceholders
	mov r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022238EC ; =0x00010200
	mov r1, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r2, [r5, #0x18]
	add r0, r4, r0
	add r3, r6, r7
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x14]
	bl String_Delete
	ldr r0, [r5, #0x10]
	mov r1, #0x1e
	bl NewString_ReadMsgData
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r3, _022238F0 ; =0x0000114D
	ldr r2, [r5]
	ldrb r3, [r5, r3]
	ldr r0, [r5, #0x14]
	add r2, r2, r3
	add r2, #0x2c
	ldrb r2, [r2]
	mov r3, #2
	add r2, r2, #1
	bl BufferIntegerAsString
	ldr r0, [r5, #0x14]
	ldr r1, [r5, #0x18]
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	ldr r1, [r5, #0x18]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r3, r0, #0
	mov r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022238EC ; =0x00010200
	mov r1, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r2, [r5, #0x18]
	add r0, r4, r0
	sub r3, r6, r3
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	mov r0, #0x19
	lsl r0, r0, #4
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_022238EC: .word 0x00010200
_022238F0: .word 0x0000114D
	thumb_func_end ov08_022237C4

	thumb_func_start ov08_022238F4
ov08_022238F4: ; 0x022238F4
	push {r4, lr}
	sub sp, #8
	add r4, r0, #0
	mov r0, #6
	ldr r1, [r4, #0x2c]
	lsl r0, r0, #6
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _022239AC ; =0x0000114D
	ldrb r0, [r4, r0]
	cmp r0, #3
	bhi _022239A8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0222391C: ; jump table
	.short _02223924 - _0222391C - 2 ; case 0
	.short _02223950 - _0222391C - 2 ; case 1
	.short _0222397C - _0222391C - 2 ; case 2
	.short _02223994 - _0222391C - 2 ; case 3
_02223924:
	mov r0, #4
	str r0, [sp]
	ldr r0, _022239B0 ; =0x00010200
	mov r1, #0x18
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0x16
	mov r3, #0
	bl ov08_022234A4
	mov r0, #0x14
	str r0, [sp]
	ldr r0, _022239B0 ; =0x00010200
	mov r1, #0x18
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0x17
	mov r3, #0
	bl ov08_022234A4
	add sp, #8
	pop {r4, pc}
_02223950:
	mov r0, #4
	str r0, [sp]
	ldr r0, _022239B0 ; =0x00010200
	mov r1, #0x18
	str r0, [sp, #4]
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0
	bl ov08_022234A4
	mov r0, #0x14
	str r0, [sp]
	ldr r0, _022239B0 ; =0x00010200
	mov r1, #0x18
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0x19
	mov r3, #0
	bl ov08_022234A4
	add sp, #8
	pop {r4, pc}
_0222397C:
	mov r0, #0xc
	str r0, [sp]
	ldr r0, _022239B0 ; =0x00010200
	mov r1, #0x18
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0x1a
	mov r3, #0
	bl ov08_022234A4
	add sp, #8
	pop {r4, pc}
_02223994:
	mov r0, #0xc
	str r0, [sp]
	ldr r0, _022239B0 ; =0x00010200
	mov r1, #0x18
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0x1b
	mov r3, #0
	bl ov08_022234A4
_022239A8:
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
_022239AC: .word 0x0000114D
_022239B0: .word 0x00010200
	thumb_func_end ov08_022238F4

	thumb_func_start ov08_022239B4
ov08_022239B4: ; 0x022239B4
	push {r4, lr}
	add r4, r0, #0
	bl ov08_0222377C
	add r0, r4, #0
	bl ov08_022238F4
	add r0, r4, #0
	bl ov08_022237C4
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_022239B4

	thumb_func_start ov08_022239CC
ov08_022239CC: ; 0x022239CC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, [r5, #0x10]
	add r6, r1, #0
	mov r1, #9
	ldr r4, [r5, #0x2c]
	bl NewString_ReadMsgData
	ldr r2, _02223A34 ; =0x0000114D
	add r7, r0, #0
	ldrb r3, [r5, r2]
	mov r2, #0x90
	ldr r0, [r5, #0x14]
	mul r2, r3
	add r2, r5, r2
	lsl r3, r6, #2
	add r2, r2, r3
	ldrh r2, [r2, #0x3c]
	mov r1, #0
	bl BufferItemName
	ldr r0, [r5, #0x14]
	ldr r1, [r5, #0x18]
	add r2, r7, #0
	bl StringExpandPlaceholders
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02223A38 ; =0x00010200
	add r3, r1, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, [r5, #0x18]
	add r0, r4, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02223A34: .word 0x0000114D
_02223A38: .word 0x00010200
	thumb_func_end ov08_022239CC

	thumb_func_start ov08_02223A3C
ov08_02223A3C: ; 0x02223A3C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r6, r1, #0
	ldr r1, [r5]
	ldr r4, [r5, #0x2c]
	ldr r1, [r1, #0xc]
	mov r0, #0x82
	add r4, #0x20
	bl String_New
	ldr r1, _02223A98 ; =0x0000114D
	add r7, r0, #0
	ldrb r2, [r5, r1]
	mov r1, #0x90
	mul r1, r2
	add r2, r5, r1
	lsl r1, r6, #2
	add r1, r2, r1
	ldr r2, [r5]
	ldrh r1, [r1, #0x3c]
	ldr r2, [r2, #0xc]
	lsl r2, r2, #0x10
	lsr r2, r2, #0x10
	bl GetItemDescIntoString
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02223A9C ; =0x00010200
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, #0
	mov r3, #4
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02223A98: .word 0x0000114D
_02223A9C: .word 0x00010200
	thumb_func_end ov08_02223A3C

	thumb_func_start ov08_02223AA0
ov08_02223AA0: ; 0x02223AA0
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	mov r6, #0
	add r5, r0, #0
	add r4, r6, #0
	add r7, r6, #0
_02223AAC:
	ldr r0, [r5, #0x2c]
	add r1, r7, #0
	add r0, r0, r4
	bl FillWindowPixelBuffer
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #4
	blo _02223AAC
	ldr r0, _02223B14 ; =0x0000114D
	ldr r1, [r5]
	ldrb r2, [r5, r0]
	add r0, r1, r2
	add r0, #0x27
	ldrb r4, [r0]
	add r0, r1, r2
	add r0, #0x2c
	ldrb r1, [r0]
	mov r0, #6
	add r6, r1, #0
	mul r6, r0
	add r0, r5, #0
	add r1, r4, r6
	bl ov08_022239CC
	mov r2, #0
	str r2, [sp]
	ldr r0, _02223B18 ; =0x00010200
	str r2, [sp, #4]
	str r0, [sp, #8]
	add r0, r5, #0
	add r1, r4, r6
	mov r3, #1
	bl ov08_02223678
	add r0, r5, #0
	add r1, r4, r6
	bl ov08_02223A3C
	mov r0, #5
	str r0, [sp]
	ldr r0, _02223B1C ; =0x00030201
	mov r1, #3
	str r0, [sp, #4]
	add r0, r5, #0
	mov r2, #0x1f
	mov r3, #4
	bl ov08_022234A4
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_02223B14: .word 0x0000114D
_02223B18: .word 0x00010200
_02223B1C: .word 0x00030201
	thumb_func_end ov08_02223AA0

	thumb_func_start ov08_02223B20
ov08_02223B20: ; 0x02223B20
	push {r4, lr}
	ldr r2, _02223B44 ; =0x000003E2
	add r4, r0, #0
	add r0, #0x1c
	mov r1, #1
	mov r3, #0xe
	bl DrawFrameAndWindow2
	add r0, r4, #0
	add r0, #0x1c
	mov r1, #0xf
	bl FillWindowPixelBuffer
	add r0, r4, #0
	bl ov08_02223B48
	pop {r4, pc}
	nop
_02223B44: .word 0x000003E2
	thumb_func_end ov08_02223B20

	thumb_func_start ov08_02223B48
ov08_02223B48: ; 0x02223B48
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	bl TextFlags_SetCanABSpeedUpPrint
	ldr r0, [r4]
	ldr r0, [r0]
	bl BattleSystem_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	str r3, [sp, #8]
	add r0, r4, #0
	ldr r2, [r4, #0x18]
	add r0, #0x1c
	mov r1, #1
	bl AddTextPrinterParameterized
	add r4, #0x32
	strb r0, [r4]
	add sp, #0xc
	pop {r3, r4, pc}
	thumb_func_end ov08_02223B48

	thumb_func_start ov08_02223B78
ov08_02223B78: ; 0x02223B78
	push {r4, lr}
	add r4, r0, #0
	ldr r3, [r4]
	ldrh r1, [r3, #0x20]
	cmp r1, #0
	bne _02223B88
	mov r0, #0
	pop {r4, pc}
_02223B88:
	ldr r0, [r3, #8]
	ldr r3, [r3, #0xc]
	mov r2, #1
	bl Bag_HasItem
	cmp r0, #0
	bne _02223BA2
	ldr r1, [r4]
	mov r0, #0
	strh r0, [r1, #0x20]
	ldr r1, [r4]
	strb r0, [r1, #0x1f]
	pop {r4, pc}
_02223BA2:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_02223B78

	thumb_func_start ov08_02223BA8
ov08_02223BA8: ; 0x02223BA8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _02223BF0 ; =0x0000114D
	ldr r6, [r5]
	ldrb r7, [r5, r0]
	mov r0, #0x90
	ldrh r2, [r6, #0x20]
	mul r0, r7
	mov r4, #0
	add r1, r5, r0
_02223BBC:
	ldrh r0, [r1, #0x3c]
	cmp r2, r0
	bne _02223BE6
	add r0, r4, #0
	mov r1, #6
	bl _u32_div_f
	add r0, r6, r7
	add r0, #0x27
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #6
	bl _u32_div_f
	ldr r1, _02223BF0 ; =0x0000114D
	ldr r2, [r5]
	ldrb r1, [r5, r1]
	add r1, r2, r1
	add r1, #0x2c
	strb r0, [r1]
	pop {r3, r4, r5, r6, r7, pc}
_02223BE6:
	add r4, r4, #1
	add r1, r1, #4
	cmp r4, #0x24
	blo _02223BBC
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02223BF0: .word 0x0000114D
	thumb_func_end ov08_02223BA8

	thumb_func_start ov08_02223BF4
ov08_02223BF4: ; 0x02223BF4
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0
	str r0, [sp, #4]
_02223BFE:
	mov r0, #0
	str r0, [sp]
	ldr r0, [sp, #4]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
_02223C0A:
	ldr r0, [r4]
	ldr r2, [sp]
	ldr r0, [r0, #8]
	lsl r2, r2, #0x10
	ldr r1, [sp, #8]
	lsr r2, r2, #0x10
	bl Bag_GetPocketSlotN
	add r5, r0, #0
	beq _02223C7C
	ldrh r0, [r5]
	cmp r0, #0
	beq _02223C74
	ldrh r1, [r5, #2]
	cmp r1, #0
	beq _02223C74
	ldr r2, [r4]
	mov r1, #0xd
	ldr r2, [r2, #0xc]
	bl GetItemAttr
	add r7, r0, #0
	ldr r1, _02223CC8 ; =ov08_02225CE0
	mov r0, #0
_02223C3A:
	mov r2, #1
	lsl r2, r0
	tst r2, r7
	beq _02223C6C
	ldrb r2, [r1]
	mov r3, #0x90
	add r6, r2, #0
	mul r6, r3
	add r3, r4, r2
	ldr r2, _02223CCC ; =0x0000114F
	ldrb r2, [r3, r2]
	add r3, r4, r6
	lsl r2, r2, #2
	add r2, r2, r3
	ldrh r3, [r5]
	strh r3, [r2, #0x3c]
	ldrh r3, [r5, #2]
	strh r3, [r2, #0x3e]
	ldrb r2, [r1]
	add r6, r4, r2
	ldr r2, _02223CCC ; =0x0000114F
	ldrb r2, [r6, r2]
	add r3, r2, #1
	ldr r2, _02223CCC ; =0x0000114F
	strb r3, [r6, r2]
_02223C6C:
	add r0, r0, #1
	add r1, r1, #1
	cmp r0, #5
	blo _02223C3A
_02223C74:
	ldr r0, [sp]
	add r0, r0, #1
	str r0, [sp]
	b _02223C0A
_02223C7C:
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #8
	blo _02223BFE
	mov r5, #0
	add r7, r5, #0
_02223C8A:
	ldr r0, _02223CCC ; =0x0000114F
	add r6, r4, r5
	ldrb r0, [r6, r0]
	cmp r0, #0
	bne _02223C9A
	ldr r0, _02223CD0 ; =0x00001154
	strb r7, [r6, r0]
	b _02223CA6
_02223C9A:
	sub r0, r0, #1
	mov r1, #6
	bl _s32_div_f
	ldr r1, _02223CD0 ; =0x00001154
	strb r0, [r6, r1]
_02223CA6:
	ldr r1, [r4]
	ldr r0, _02223CD0 ; =0x00001154
	add r2, r1, r5
	add r2, #0x2c
	ldrb r0, [r6, r0]
	ldrb r2, [r2]
	cmp r0, r2
	bhs _02223CBC
	add r1, r1, r5
	add r1, #0x2c
	strb r0, [r1]
_02223CBC:
	add r5, r5, #1
	cmp r5, #5
	blo _02223C8A
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_02223CC8: .word ov08_02225CE0
_02223CCC: .word 0x0000114F
_02223CD0: .word 0x00001154
	thumb_func_end ov08_02223BF4

	thumb_func_start ov08_02223CD4
ov08_02223CD4: ; 0x02223CD4
	push {r3, r4}
	ldr r2, _02223D04 ; =0x0000114D
	ldr r3, [r0]
	ldrb r2, [r0, r2]
	add r3, r3, r2
	add r3, #0x2c
	ldrb r4, [r3]
	mov r3, #6
	mul r3, r4
	add r1, r1, r3
	lsl r3, r1, #2
	mov r1, #0x90
	mul r1, r2
	add r0, r0, r1
	add r1, r0, r3
	ldrh r0, [r1, #0x3c]
	cmp r0, #0
	beq _02223CFE
	ldrh r1, [r1, #0x3e]
	cmp r1, #0
	bne _02223D00
_02223CFE:
	mov r0, #0
_02223D00:
	pop {r3, r4}
	bx lr
	.balign 4, 0
_02223D04: .word 0x0000114D
	thumb_func_end ov08_02223CD4

	thumb_func_start ov08_02223D08
ov08_02223D08: ; 0x02223D08
	push {r4, lr}
	add r4, r0, #0
	bl ov08_02223D34
	add r0, r4, #0
	bl ov08_02223D80
	add r0, r4, #0
	bl ov08_02223F14
	add r0, r4, #0
	bl ov08_022240A8
	add r0, r4, #0
	bl ov08_0222419C
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_02223D08

	thumb_func_start ov08_02223D34
ov08_02223D34: ; 0x02223D34
	push {r3, r4, r5, lr}
	sub sp, #0x18
	ldr r3, _02223D7C ; =ov08_02225D14
	add r2, sp, #0
	add r5, r0, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r5]
	ldr r0, [r0]
	bl BattleSystem_GetSpriteSystem
	add r4, r0, #0
	bl SpriteManager_New
	mov r1, #0xc3
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r1, [r5, r1]
	add r0, r4, #0
	mov r2, #0xc
	bl SpriteSystem_InitSprites
	mov r1, #0xc3
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	add r0, r4, #0
	add r2, sp, #0
	bl SpriteSystem_InitManagerWithCapacities
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_02223D7C: .word ov08_02225D14
	thumb_func_end ov08_02223D34

	thumb_func_start ov08_02223D80
ov08_02223D80: ; 0x02223D80
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r6, r0, #0
	ldr r1, [r6]
	mov r0, #0x12
	ldr r1, [r1, #0xc]
	bl NARC_New
	add r7, r0, #0
	ldr r0, [r6]
	ldr r0, [r0]
	bl BattleSystem_GetSpriteSystem
	str r0, [sp, #0x18]
	mov r4, #0
_02223D9E:
	ldr r0, _02223E38 ; =0x0000B4B7
	add r5, r4, r0
	mov r0, #1
	add r1, r0, #0
	bl GetItemIndexMapping
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r1, #0xc3
	str r5, [sp, #8]
	lsl r1, r1, #2
	ldr r0, [sp, #0x18]
	ldr r1, [r6, r1]
	add r2, r7, #0
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	mov r1, #2
	bl GetItemIndexMapping
	str r7, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	mov r3, #0xc3
	str r5, [sp, #0x14]
	lsl r3, r3, #2
	ldr r0, [r6, #8]
	ldr r2, [sp, #0x18]
	ldr r3, [r6, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	add r4, r4, #1
	cmp r4, #6
	blo _02223D9E
	bl GetItemIconCell
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _02223E38 ; =0x0000B4B7
	mov r1, #0xc3
	str r0, [sp, #4]
	lsl r1, r1, #2
	ldr r0, [sp, #0x18]
	ldr r1, [r6, r1]
	add r2, r7, #0
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	bl GetItemIconAnim
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _02223E38 ; =0x0000B4B7
	mov r1, #0xc3
	str r0, [sp, #4]
	lsl r1, r1, #2
	ldr r0, [sp, #0x18]
	ldr r1, [r6, r1]
	add r2, r7, #0
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add r0, r7, #0
	bl NARC_Delete
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_02223E38: .word 0x0000B4B7
	thumb_func_end ov08_02223D80

	thumb_func_start ov08_02223E3C
ov08_02223E3C: ; 0x02223E3C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, [r5]
	add r6, r1, #0
	ldr r0, [r0]
	add r4, r2, #0
	bl BattleSystem_GetSpriteSystem
	add r7, r0, #0
	add r0, r6, #0
	mov r1, #1
	bl GetItemIndexMapping
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r1, #0xc3
	str r4, [sp, #4]
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	add r0, r7, #0
	mov r2, #0x12
	bl SpriteSystem_ReplaceCharResObj
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_02223E3C

	thumb_func_start ov08_02223E74
ov08_02223E74: ; 0x02223E74
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #2
	add r4, r2, #0
	bl GetItemIndexMapping
	add r2, r0, #0
	mov r0, #3
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	lsl r0, r4, #0x14
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	ldr r3, [r5]
	ldr r0, [r5, #8]
	ldr r3, [r3, #0xc]
	mov r1, #0x12
	bl PaletteData_LoadNarc
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov08_02223E74

	thumb_func_start ov08_02223EA4
ov08_02223EA4: ; 0x02223EA4
	push {r4, r5, lr}
	sub sp, #0x34
	add r5, r0, #0
	ldr r0, [r5]
	add r4, r1, #0
	ldr r0, [r0]
	bl BattleSystem_GetSpriteSystem
	mov r2, #0
	add r1, sp, #0
	strh r2, [r1]
	strh r2, [r1, #2]
	strh r2, [r1, #4]
	strh r2, [r1, #6]
	mov r1, #0x14
	ldr r3, _02223F00 ; =ov08_02225DEC
	mul r1, r4
	ldr r3, [r3, r1]
	str r2, [sp, #0xc]
	str r3, [sp, #8]
	mov r3, #2
	str r3, [sp, #0x10]
	ldr r3, _02223F04 ; =ov08_02225DDC
	str r2, [sp, #0x30]
	ldr r3, [r3, r1]
	add r2, sp, #0
	str r3, [sp, #0x14]
	ldr r3, _02223F08 ; =ov08_02225DE0
	ldr r3, [r3, r1]
	str r3, [sp, #0x18]
	ldr r3, _02223F0C ; =ov08_02225DE4
	ldr r3, [r3, r1]
	str r3, [sp, #0x1c]
	ldr r3, _02223F10 ; =ov08_02225DE8
	ldr r1, [r3, r1]
	str r1, [sp, #0x20]
	mov r1, #1
	str r1, [sp, #0x2c]
	mov r1, #0xc3
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	bl SpriteSystem_NewSprite
	add sp, #0x34
	pop {r4, r5, pc}
	nop
_02223F00: .word ov08_02225DEC
_02223F04: .word ov08_02225DDC
_02223F08: .word ov08_02225DE0
_02223F0C: .word ov08_02225DE4
_02223F10: .word ov08_02225DE8
	thumb_func_end ov08_02223EA4

	thumb_func_start ov08_02223F14
ov08_02223F14: ; 0x02223F14
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r7, #0x31
	mov r4, #0
	add r5, r6, #0
	lsl r7, r7, #4
_02223F20:
	add r0, r6, #0
	add r1, r4, #0
	bl ov08_02223EA4
	str r0, [r5, r7]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blo _02223F20
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov08_02223F14

	thumb_func_start ov08_02223F34
ov08_02223F34: ; 0x02223F34
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	ldr r0, [r7]
	ldr r0, [r0]
	bl BattleSystem_GetSpriteSystem
	mov r6, #0x31
	str r0, [sp]
	mov r4, #0
	add r5, r7, #0
	lsl r6, r6, #4
_02223F4A:
	ldr r0, [r5, r6]
	bl Sprite_DeleteAndFreeResources
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blo _02223F4A
	add r0, r7, #0
	bl ov08_02224108
	add r0, r7, #0
	bl ov08_022241F4
	mov r1, #0xc3
	lsl r1, r1, #2
	ldr r0, [sp]
	ldr r1, [r7, r1]
	bl SpriteSystem_FreeResourcesAndManager
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_02223F34

	thumb_func_start ov08_02223F74
ov08_02223F74: ; 0x02223F74
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r2, #0
	mov r1, #1
	add r6, r0, #0
	bl ManagedSprite_SetDrawFlag
	lsl r1, r5, #0x10
	lsl r2, r4, #0x10
	add r0, r6, #0
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov08_02223F74

	thumb_func_start ov08_02223F94
ov08_02223F94: ; 0x02223F94
	push {r3, r4, r5, r6, r7, lr}
	mov r6, #0x31
	str r0, [sp]
	add r7, r1, #0
	mov r4, #0
	add r5, r0, #0
	lsl r6, r6, #4
_02223FA2:
	ldr r0, [r5, r6]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blo _02223FA2
	cmp r7, #0
	beq _02223FC0
	cmp r7, #1
	beq _02223FC8
	cmp r7, #2
	beq _02223FD0
	pop {r3, r4, r5, r6, r7, pc}
_02223FC0:
	ldr r0, [sp]
	bl ov08_02223FD8
	pop {r3, r4, r5, r6, r7, pc}
_02223FC8:
	ldr r0, [sp]
	bl ov08_0222400C
	pop {r3, r4, r5, r6, r7, pc}
_02223FD0:
	ldr r0, [sp]
	bl ov08_02224064
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov08_02223F94

	thumb_func_start ov08_02223FD8
ov08_02223FD8: ; 0x02223FD8
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4]
	ldrh r1, [r1, #0x20]
	cmp r1, #0
	beq _02224006
	ldr r2, _02224008 ; =0x0000B4B7
	bl ov08_02223E3C
	ldr r1, [r4]
	ldr r3, _02224008 ; =0x0000B4B7
	ldrh r1, [r1, #0x20]
	add r0, r4, #0
	mov r2, #0
	bl ov08_02223E74
	mov r0, #0x31
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0x18
	mov r2, #0xb2
	bl ov08_02223F74
_02224006:
	pop {r4, pc}
	.balign 4, 0
_02224008: .word 0x0000B4B7
	thumb_func_end ov08_02223FD8

	thumb_func_start ov08_0222400C
ov08_0222400C: ; 0x0222400C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r6, _0222405C ; =ov08_02225D74
	mov r4, #0
	add r7, r5, #0
_02224016:
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02223CD4
	str r0, [sp]
	cmp r0, #0
	beq _0222404E
	ldr r2, _02224060 ; =0x0000B4B7
	ldr r1, [sp]
	add r0, r5, #0
	add r2, r4, r2
	bl ov08_02223E3C
	ldr r3, _02224060 ; =0x0000B4B7
	lsl r2, r4, #0x10
	ldr r1, [sp]
	add r0, r5, #0
	lsr r2, r2, #0x10
	add r3, r4, r3
	bl ov08_02223E74
	mov r0, #0x31
	lsl r0, r0, #4
	ldr r0, [r7, r0]
	ldr r1, [r6]
	ldr r2, [r6, #4]
	bl ov08_02223F74
_0222404E:
	add r4, r4, #1
	add r6, #8
	add r7, r7, #4
	cmp r4, #6
	blo _02224016
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0222405C: .word ov08_02225D74
_02224060: .word 0x0000B4B7
	thumb_func_end ov08_0222400C

	thumb_func_start ov08_02224064
ov08_02224064: ; 0x02224064
	push {r3, r4, r5, lr}
	ldr r1, _022240A0 ; =0x0000114D
	add r4, r0, #0
	ldrb r1, [r4, r1]
	ldr r2, [r4]
	add r1, r2, r1
	add r1, #0x27
	ldrb r1, [r1]
	bl ov08_02223CD4
	add r5, r0, #0
	ldr r2, _022240A4 ; =0x0000B4B7
	add r0, r4, #0
	add r1, r5, #0
	bl ov08_02223E3C
	ldr r3, _022240A4 ; =0x0000B4B7
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0
	bl ov08_02223E74
	mov r0, #0x31
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0x28
	mov r2, #0x2c
	bl ov08_02223F74
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022240A0: .word 0x0000114D
_022240A4: .word 0x0000B4B7
	thumb_func_end ov08_02224064

	thumb_func_start ov08_022240A8
ov08_022240A8: ; 0x022240A8
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl BattleSystem_GetSpriteSystem
	ldr r1, _02224104 ; =0x0000B4BE
	add r4, r0, #0
	str r1, [sp]
	str r1, [sp, #4]
	sub r1, r1, #5
	str r1, [sp, #8]
	str r1, [sp, #0xc]
	mov r1, #0xc3
	ldr r3, [r5]
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	ldr r2, [r5, #8]
	ldr r3, [r3, #0xc]
	bl BattleCursor_LoadResources
	ldr r3, _02224104 ; =0x0000B4BE
	mov r1, #0xc3
	str r3, [sp]
	sub r0, r3, #5
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r2, [r5]
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	ldr r2, [r2, #0xc]
	add r0, r4, #0
	bl BattleCursor_New
	add r1, r0, #0
	ldr r0, [r5, #0x34]
	bl ov08_02224B94
	add sp, #0x14
	pop {r4, r5, pc}
	nop
_02224104: .word 0x0000B4BE
	thumb_func_end ov08_022240A8

	thumb_func_start ov08_02224108
ov08_02224108: ; 0x02224108
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov08_02224B84
	bl BattleCursor_Delete
	ldr r3, _02224130 ; =0x0000B4B9
	mov r0, #0xc3
	add r1, r3, #5
	str r3, [sp]
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl BattleCursor_FreeResources
	add sp, #4
	pop {r3, r4, pc}
	nop
_02224130: .word 0x0000B4B9
	thumb_func_end ov08_02224108

	thumb_func_start ov08_02224134
ov08_02224134: ; 0x02224134
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	ldr r1, _02224174 ; =ov08_02225CF8
	lsl r2, r4, #2
	ldr r0, [r5, #0x34]
	ldr r1, [r1, r2]
	bl ov08_02224BCC
	cmp r4, #0
	beq _02224152
	cmp r4, #1
	beq _0222415E
	cmp r4, #2
	pop {r3, r4, r5, pc}
_02224152:
	ldr r1, _02224178 ; =0x0000114D
	ldr r0, [r5, #0x34]
	ldrb r1, [r5, r1]
	bl ov08_02224B98
	pop {r3, r4, r5, pc}
_0222415E:
	ldr r1, _02224178 ; =0x0000114D
	ldr r2, [r5]
	ldrb r1, [r5, r1]
	ldr r0, [r5, #0x34]
	add r1, r2, r1
	add r1, #0x27
	ldrb r1, [r1]
	bl ov08_02224B98
	pop {r3, r4, r5, pc}
	nop
_02224174: .word ov08_02225CF8
_02224178: .word 0x0000114D
	thumb_func_end ov08_02224134

	thumb_func_start ov08_0222417C
ov08_0222417C: ; 0x0222417C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov08_02224B90
	ldr r0, [r4, #0x34]
	bl ov08_02224BC0
	ldr r0, [r4, #0x34]
	bl ov08_02224B84
	bl BattleCursor_Disable
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_0222417C

	thumb_func_start ov08_0222419C
ov08_0222419C: ; 0x0222419C
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl BattleSystem_GetSpriteSystem
	ldr r1, _022241F0 ; =0x0000B4BD
	add r4, r0, #0
	str r1, [sp]
	str r1, [sp, #4]
	sub r1, r1, #5
	str r1, [sp, #8]
	str r1, [sp, #0xc]
	mov r1, #0xc3
	ldr r2, [r5]
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	ldr r2, [r2, #0xc]
	ldr r3, [r5, #8]
	bl BattleFinger_LoadResources
	ldr r3, _022241F0 ; =0x0000B4BD
	mov r1, #0xc3
	str r3, [sp]
	sub r0, r3, #5
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r2, [r5]
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	ldr r2, [r2, #0xc]
	add r0, r4, #0
	bl BattleFinger_New
	str r0, [r5, #0x38]
	add sp, #0x14
	pop {r4, r5, pc}
	nop
_022241F0: .word 0x0000B4BD
	thumb_func_end ov08_0222419C

	thumb_func_start ov08_022241F4
ov08_022241F4: ; 0x022241F4
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x38]
	bl BattleFinger_Delete
	ldr r3, _02224218 ; =0x0000B4B8
	mov r0, #0xc3
	add r1, r3, #5
	str r3, [sp]
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl BattleFinger_FreeResources
	add sp, #4
	pop {r3, r4, pc}
	nop
_02224218: .word 0x0000B4B8
	thumb_func_end ov08_022241F4

	thumb_func_start ov08_0222421C
ov08_0222421C: ; 0x0222421C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	ldr r0, [r0, #0x14]
	cmp r0, #1
	bne _02224242
	lsl r3, r1, #3
	ldr r1, _0222424C ; =ov08_02225D2C
	ldr r2, _02224250 ; =ov08_02225D30
	ldr r0, [r4, #0x38]
	ldr r1, [r1, r3]
	ldr r2, [r2, r3]
	bl ov12_0226BD2C
	ldr r0, [r4, #0x38]
	mov r1, #0x3c
	bl ov12_0226BD4C
	pop {r4, pc}
_02224242:
	ldr r0, [r4, #0x38]
	bl BattleFinger_Disable
	pop {r4, pc}
	nop
_0222424C: .word ov08_02225D2C
_02224250: .word ov08_02225D30
	thumb_func_end ov08_0222421C

	thumb_func_start ov08_02224254
ov08_02224254: ; 0x02224254
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #9
	str r0, [sp, #4]
	mov r0, #0xca
	lsl r0, r0, #2
	mov r2, #0
	add r0, r5, r0
	add r3, r2, #0
	add r4, r1, #0
	bl ov08_0222458C
	mov r0, #0x10
	str r0, [sp]
	ldr r0, _02224510 ; =0x00000448
	mov r3, #9
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	str r3, [sp, #4]
	bl ov08_0222458C
	mov r0, #0x10
	str r0, [sp]
	mov r0, #9
	str r0, [sp, #4]
	ldr r0, _02224514 ; =0x00000568
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x12
	bl ov08_0222458C
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _02224518 ; =0x00000688
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x1b
	bl ov08_0222458C
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _0222451C ; =0x0000078C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x20
	bl ov08_0222458C
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #0x89
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	mov r3, #0x25
	bl ov08_0222458C
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _02224520 ; =0x00000994
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x2a
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224524 ; =0x00000A98
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x39
	bl ov08_0222458C
	ldr r0, _02224528 ; =0x00000ACA
	mov r2, #5
	str r2, [sp]
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x39
	str r2, [sp, #4]
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0222452C ; =0x00000AFC
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xa
	mov r3, #0x39
	bl ov08_0222458C
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, _02224530 ; =0x00000B2E
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0
	bl ov08_0222458C
	ldr r0, _02224534 ; =0x00000BEE
	mov r2, #0x10
	str r2, [sp]
	mov r3, #6
	add r0, r5, r0
	add r1, r4, #0
	str r3, [sp, #4]
	bl ov08_0222458C
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, _02224538 ; =0x00000CAE
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0xc
	bl ov08_0222458C
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, _0222453C ; =0x00000D6E
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0x12
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224540 ; =0x00000E2E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x2f
	bl ov08_0222458C
	mov r0, #0xe6
	mov r2, #5
	lsl r0, r0, #4
	str r2, [sp]
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x2f
	str r2, [sp, #4]
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224544 ; =0x00000E92
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xa
	mov r3, #0x2f
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224548 ; =0x00000EC4
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xf
	mov r3, #0x2f
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0222454C ; =0x00000EF6
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x34
	bl ov08_0222458C
	ldr r0, _02224550 ; =0x00000F28
	mov r2, #5
	str r2, [sp]
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x34
	str r2, [sp, #4]
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224554 ; =0x00000F5A
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xa
	mov r3, #0x34
	bl ov08_0222458C
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224558 ; =0x00000F8C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xf
	mov r3, #0x34
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0222455C ; =0x00000FBE
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x14
	mov r3, #0x2f
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224560 ; =0x00000FDE
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x18
	mov r3, #0x2f
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224564 ; =0x00000FFE
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1c
	mov r3, #0x2f
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224568 ; =0x0000101E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x14
	mov r3, #0x33
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0222456C ; =0x0000103E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x18
	mov r3, #0x33
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224570 ; =0x0000105E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1c
	mov r3, #0x33
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224574 ; =0x0000107E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x14
	mov r3, #0x37
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224578 ; =0x0000109E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x18
	mov r3, #0x37
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0222457C ; =0x000010BE
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1c
	mov r3, #0x37
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224580 ; =0x000010DE
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x14
	mov r3, #0x3b
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224584 ; =0x000010FE
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x18
	mov r3, #0x3b
	bl ov08_0222458C
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02224588 ; =0x0000111E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1c
	mov r3, #0x3b
	bl ov08_0222458C
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02224510: .word 0x00000448
_02224514: .word 0x00000568
_02224518: .word 0x00000688
_0222451C: .word 0x0000078C
_02224520: .word 0x00000994
_02224524: .word 0x00000A98
_02224528: .word 0x00000ACA
_0222452C: .word 0x00000AFC
_02224530: .word 0x00000B2E
_02224534: .word 0x00000BEE
_02224538: .word 0x00000CAE
_0222453C: .word 0x00000D6E
_02224540: .word 0x00000E2E
_02224544: .word 0x00000E92
_02224548: .word 0x00000EC4
_0222454C: .word 0x00000EF6
_02224550: .word 0x00000F28
_02224554: .word 0x00000F5A
_02224558: .word 0x00000F8C
_0222455C: .word 0x00000FBE
_02224560: .word 0x00000FDE
_02224564: .word 0x00000FFE
_02224568: .word 0x0000101E
_0222456C: .word 0x0000103E
_02224570: .word 0x0000105E
_02224574: .word 0x0000107E
_02224578: .word 0x0000109E
_0222457C: .word 0x000010BE
_02224580: .word 0x000010DE
_02224584: .word 0x000010FE
_02224588: .word 0x0000111E
	thumb_func_end ov08_02224254

	thumb_func_start ov08_0222458C
ov08_0222458C: ; 0x0222458C
	push {r3, r4, r5, r6, r7, lr}
	str r0, [sp]
	add r0, sp, #8
	mov lr, r3
	ldrb r3, [r0, #0x14]
	mov r6, #0
	mov ip, r3
	cmp r3, #0
	ble _022245D8
	ldrb r3, [r0, #0x10]
	lsl r2, r2, #1
	add r7, r1, r2
_022245A4:
	mov r2, #0
	cmp r3, #0
	ble _022245CC
	mov r0, lr
	add r0, r0, r6
	lsl r0, r0, #6
	add r5, r7, r0
	add r0, r6, #0
	mul r0, r3
	lsl r1, r0, #1
	ldr r0, [sp]
	add r4, r0, r1
_022245BC:
	lsl r1, r2, #1
	ldrh r0, [r5, r1]
	strh r0, [r4, r1]
	add r0, r2, #1
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	cmp r2, r3
	blt _022245BC
_022245CC:
	add r0, r6, #1
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	mov r0, ip
	cmp r6, r0
	blt _022245A4
_022245D8:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_0222458C

	thumb_func_start ov08_022245DC
ov08_022245DC: ; 0x022245DC
	cmp r1, #0x10
	bhi _0222466A
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022245EC: ; jump table
	.short _0222460E - _022245EC - 2 ; case 0
	.short _0222460E - _022245EC - 2 ; case 1
	.short _0222460E - _022245EC - 2 ; case 2
	.short _0222460E - _022245EC - 2 ; case 3
	.short _0222461E - _022245EC - 2 ; case 4
	.short _0222462C - _022245EC - 2 ; case 5
	.short _02224638 - _022245EC - 2 ; case 6
	.short _02224638 - _022245EC - 2 ; case 7
	.short _02224638 - _022245EC - 2 ; case 8
	.short _02224638 - _022245EC - 2 ; case 9
	.short _02224638 - _022245EC - 2 ; case 10
	.short _02224638 - _022245EC - 2 ; case 11
	.short _02224644 - _022245EC - 2 ; case 12
	.short _02224650 - _022245EC - 2 ; case 13
	.short _0222462C - _022245EC - 2 ; case 14
	.short _0222465C - _022245EC - 2 ; case 15
	.short _0222462C - _022245EC - 2 ; case 16
_0222460E:
	mov r1, #0xca
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x12
	lsl r0, r0, #4
	mul r0, r2
	add r0, r1, r0
	bx lr
_0222461E:
	ldr r1, _02224670 ; =0x00000688
	add r1, r0, r1
	lsl r0, r2, #6
	add r0, r2, r0
	lsl r0, r0, #2
	add r0, r1, r0
	bx lr
_0222462C:
	ldr r1, _02224674 ; =0x00000A98
	add r1, r0, r1
	mov r0, #0x32
	mul r0, r2
	add r0, r1, r0
	bx lr
_02224638:
	ldr r1, _02224678 ; =0x00000B2E
	add r1, r0, r1
	mov r0, #0xc0
	mul r0, r2
	add r0, r1, r0
	bx lr
_02224644:
	ldr r1, _0222467C ; =0x00000E2E
	add r1, r0, r1
	mov r0, #0x32
	mul r0, r2
	add r0, r1, r0
	bx lr
_02224650:
	ldr r1, _02224680 ; =0x00000EF6
	add r1, r0, r1
	mov r0, #0x32
	mul r0, r2
	add r0, r1, r0
	bx lr
_0222465C:
	ldr r1, _02224670 ; =0x00000688
	add r1, r0, r1
	lsl r0, r2, #6
	add r0, r2, r0
	lsl r0, r0, #2
	add r0, r1, r0
	bx lr
_0222466A:
	mov r0, #0
	bx lr
	nop
_02224670: .word 0x00000688
_02224674: .word 0x00000A98
_02224678: .word 0x00000B2E
_0222467C: .word 0x00000E2E
_02224680: .word 0x00000EF6
	thumb_func_end ov08_022245DC

	thumb_func_start ov08_02224684
ov08_02224684: ; 0x02224684
	cmp r2, #3
	bne _0222468C
	mov r0, #5
	bx lr
_0222468C:
	cmp r1, #0x10
	bhi _022246EA
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0222469C: ; jump table
	.short _022246BE - _0222469C - 2 ; case 0
	.short _022246BE - _0222469C - 2 ; case 1
	.short _022246BE - _0222469C - 2 ; case 2
	.short _022246BE - _0222469C - 2 ; case 3
	.short _022246C2 - _0222469C - 2 ; case 4
	.short _022246C6 - _0222469C - 2 ; case 5
	.short _022246CA - _0222469C - 2 ; case 6
	.short _022246CA - _0222469C - 2 ; case 7
	.short _022246CA - _0222469C - 2 ; case 8
	.short _022246CA - _0222469C - 2 ; case 9
	.short _022246CA - _0222469C - 2 ; case 10
	.short _022246CA - _0222469C - 2 ; case 11
	.short _022246C6 - _0222469C - 2 ; case 12
	.short _022246C6 - _0222469C - 2 ; case 13
	.short _022246C6 - _0222469C - 2 ; case 14
	.short _022246D6 - _0222469C - 2 ; case 15
	.short _022246C6 - _0222469C - 2 ; case 16
_022246BE:
	mov r0, #0
	bx lr
_022246C2:
	mov r0, #3
	bx lr
_022246C6:
	mov r0, #2
	bx lr
_022246CA:
	ldr r1, _022246F0 ; =0x0000114D
	ldrb r0, [r0, r1]
	add r0, #8
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
_022246D6:
	cmp r3, #2
	bne _022246E6
	ldr r1, _022246F0 ; =0x0000114D
	ldrb r0, [r0, r1]
	add r0, #8
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bx lr
_022246E6:
	mov r0, #1
	bx lr
_022246EA:
	mov r0, #0
	bx lr
	nop
_022246F0: .word 0x0000114D
	thumb_func_end ov08_02224684

	thumb_func_start ov08_022246F4
ov08_022246F4: ; 0x022246F4
	push {r4, r5, r6, r7}
	cmp r2, #0
	bne _02224704
	ldr r2, _02224758 ; =0x00000FBE
	add r2, r0, r2
	lsl r0, r3, #5
	add r0, r2, r0
	b _0222472C
_02224704:
	cmp r2, #1
	bne _02224712
	ldr r2, _0222475C ; =0x0000101E
	add r2, r0, r2
	lsl r0, r3, #5
	add r0, r2, r0
	b _0222472C
_02224712:
	cmp r2, #2
	bne _02224720
	ldr r2, _02224760 ; =0x0000107E
	add r2, r0, r2
	lsl r0, r3, #5
	add r0, r2, r0
	b _0222472C
_02224720:
	cmp r2, #3
	bne _02224754
	ldr r2, _02224764 ; =0x000010DE
	add r2, r0, r2
	lsl r0, r3, #5
	add r0, r2, r0
_0222472C:
	mov r2, #0
_0222472E:
	lsl r4, r2, #3
	lsl r5, r2, #5
	mov r3, #0
	add r4, r0, r4
	add r5, r1, r5
_02224738:
	lsl r6, r3, #1
	ldrh r7, [r4, r6]
	add r3, r3, #1
	lsl r3, r3, #0x10
	add r6, r5, r6
	lsr r3, r3, #0x10
	strh r7, [r6, #0xc]
	cmp r3, #4
	blo _02224738
	add r2, r2, #1
	lsl r2, r2, #0x10
	lsr r2, r2, #0x10
	cmp r2, #4
	blo _0222472E
_02224754:
	pop {r4, r5, r6, r7}
	bx lr
	.balign 4, 0
_02224758: .word 0x00000FBE
_0222475C: .word 0x0000101E
_02224760: .word 0x0000107E
_02224764: .word 0x000010DE
	thumb_func_end ov08_022246F4

	thumb_func_start ov08_02224768
ov08_02224768: ; 0x02224768
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	str r2, [sp, #4]
	str r3, [sp, #8]
	add r5, r1, #0
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	str r0, [sp]
	bl ov08_022245DC
	add r3, sp, #0x10
	add r4, r0, #0
	ldrb r3, [r3, #0x10]
	ldr r0, [sp]
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	bl ov08_02224684
	lsl r0, r0, #0x1c
	lsr r2, r0, #0x10
	ldr r0, [sp, #4]
	ldr r6, _022247D4 ; =ov08_02225E9F
	lsl r3, r0, #2
	ldr r0, _022247D8 ; =ov08_02225E9E
	ldrb r6, [r6, r3]
	ldrb r0, [r0, r3]
	mov r1, #0
	mul r6, r0
	cmp r6, #0
	ble _022247C4
	ldr r0, _022247DC ; =ov08_02225E9C
	ldr r7, _022247E0 ; =0x00000FFF
	add r3, r0, r3
_022247AA:
	lsl r0, r1, #1
	ldrh r6, [r4, r0]
	and r6, r7
	orr r6, r2
	strh r6, [r5, r0]
	add r0, r1, #1
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	ldrb r6, [r3, #2]
	ldrb r0, [r3, #3]
	mul r0, r6
	cmp r1, r0
	blt _022247AA
_022247C4:
	ldr r0, [sp]
	ldr r2, [sp, #4]
	ldr r3, [sp, #8]
	add r1, r5, #0
	bl ov08_022246F4
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_022247D4: .word ov08_02225E9F
_022247D8: .word ov08_02225E9E
_022247DC: .word ov08_02225E9C
_022247E0: .word 0x00000FFF
	thumb_func_end ov08_02224768

	thumb_func_start ov08_022247E4
ov08_022247E4: ; 0x022247E4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	str r1, [sp, #0xc]
	str r2, [sp, #0x10]
	str r3, [sp, #0x14]
	add r5, r0, #0
	ldr r0, [sp, #0xc]
	lsl r4, r0, #2
	ldr r0, _02224848 ; =ov08_02225E9F
	ldrb r7, [r0, r4]
	ldr r0, _0222484C ; =ov08_02225E9E
	ldrb r6, [r0, r4]
	ldr r0, [r5]
	add r1, r6, #0
	mul r1, r7
	ldr r0, [r0, #0xc]
	lsl r1, r1, #1
	bl Heap_Alloc
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	str r0, [sp]
	ldr r2, [sp, #0xc]
	ldr r3, [sp, #0x10]
	add r0, r5, #0
	bl ov08_02224768
	ldr r0, _02224850 ; =ov08_02225E9D
	ldr r3, _02224854 ; =ov08_02225E9C
	ldrb r0, [r0, r4]
	ldrb r3, [r3, r4]
	ldr r2, [sp, #0x18]
	str r0, [sp]
	str r6, [sp, #4]
	str r7, [sp, #8]
	ldr r0, [r5, #4]
	mov r1, #6
	bl LoadRectToBgTilemapRect
	ldr r0, [r5, #4]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, [sp, #0x18]
	bl Heap_Free
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_02224848: .word ov08_02225E9F
_0222484C: .word ov08_02225E9E
_02224850: .word ov08_02225E9D
_02224854: .word ov08_02225E9C
	thumb_func_end ov08_022247E4

	thumb_func_start ov08_02224858
ov08_02224858: ; 0x02224858
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	cmp r1, #6
	blo _02224876
	cmp r1, #0xb
	bhi _02224876
	add r0, #0x31
	ldrb r0, [r0]
	cmp r0, #0
	bne _02224876
	add r1, #0xb
	ldr r0, _022248CC ; =ov08_02225EE0
	lsl r1, r1, #2
	ldr r4, [r0, r1]
	b _0222487C
_02224876:
	ldr r0, _022248CC ; =ov08_02225EE0
	lsl r1, r1, #2
	ldr r4, [r0, r1]
_0222487C:
	cmp r4, #0
	beq _022248C8
	cmp r2, #0
	beq _0222488C
	cmp r2, #1
	beq _02224894
	cmp r2, #2
	bne _0222489A
_0222488C:
	mov r0, #1
	str r0, [sp]
	mov r7, #2
	b _0222489A
_02224894:
	mov r0, #0
	str r0, [sp]
	mov r7, #4
_0222489A:
	mov r5, #0
_0222489C:
	ldrb r0, [r4, r5]
	cmp r0, #0xff
	beq _022248C8
	ldr r1, [r6, #0x2c]
	lsl r0, r0, #4
	add r0, r1, r0
	ldr r1, [sp]
	add r2, r7, #0
	mov r3, #0
	bl ScrollWindow
	ldrb r0, [r4, r5]
	ldr r1, [r6, #0x2c]
	lsl r0, r0, #4
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #8
	blo _0222489C
_022248C8:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_022248CC: .word ov08_02225EE0
	thumb_func_end ov08_02224858

	thumb_func_start ov08_022248D0
ov08_022248D0: ; 0x022248D0
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	str r2, [sp]
	cmp r1, #6
	blo _022248EC
	cmp r1, #0xb
	bhi _022248EC
	sub r0, r1, #6
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0x31
	lsl r0, r0, #4
	ldr r6, [r1, r0]
	b _02224910
_022248EC:
	cmp r1, #4
	bne _02224934
	mov r7, #0x31
	mov r4, #0
	lsl r7, r7, #4
_022248F6:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r6, [r0, r7]
	add r0, r6, #0
	bl ManagedSprite_GetDrawFlag
	cmp r0, #0
	bne _02224910
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #6
	blo _022248F6
_02224910:
	ldr r0, [sp]
	cmp r0, #0
	beq _0222491E
	cmp r0, #1
	beq _0222492A
	cmp r0, #2
	bne _02224934
_0222491E:
	add r0, r6, #0
	mov r1, #0
	mov r2, #2
	bl ManagedSprite_OffsetPositionXY
	pop {r3, r4, r5, r6, r7, pc}
_0222492A:
	mov r1, #0
	add r0, r6, #0
	sub r2, r1, #4
	bl ManagedSprite_OffsetPositionXY
_02224934:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_022248D0

	thumb_func_start ov08_02224938
ov08_02224938: ; 0x02224938
	push {r4, r5}
	ldr r3, _02224970 ; =0x0000113E
	mov r5, #0
	strb r5, [r0, r3]
	add r4, r3, #1
	strb r5, [r0, r4]
	add r4, r3, #2
	strb r1, [r0, r4]
	add r1, r3, #3
	ldrb r4, [r0, r1]
	mov r1, #0xf0
	bic r4, r1
	lsl r1, r2, #0x1c
	lsr r1, r1, #0x18
	add r2, r4, #0
	orr r2, r1
	add r1, r3, #3
	strb r2, [r0, r1]
	ldrb r2, [r0, r1]
	mov r1, #0xf
	bic r2, r1
	mov r1, #1
	orr r2, r1
	add r1, r3, #3
	strb r2, [r0, r1]
	pop {r4, r5}
	bx lr
	nop
_02224970: .word 0x0000113E
	thumb_func_end ov08_02224938

	thumb_func_start ov08_02224974
ov08_02224974: ; 0x02224974
	push {r4, lr}
	ldr r3, _02224A48 ; =0x00001141
	add r4, r0, #0
	ldrb r1, [r4, r3]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	beq _02224A44
	sub r1, r3, #3
	ldrb r1, [r4, r1]
	cmp r1, #0
	beq _02224994
	cmp r1, #1
	beq _022249CC
	cmp r1, #2
	beq _02224A04
	pop {r4, pc}
_02224994:
	sub r1, r3, #1
	add r3, #0xb
	ldrb r1, [r4, r1]
	ldrb r3, [r4, r3]
	mov r2, #1
	bl ov08_022247E4
	mov r1, #0x45
	lsl r1, r1, #6
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #1
	bl ov08_02224858
	mov r1, #0x45
	lsl r1, r1, #6
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #1
	bl ov08_022248D0
	ldr r0, _02224A4C ; =0x0000113F
	mov r1, #0
	strb r1, [r4, r0]
	mov r1, #1
	sub r0, r0, #1
	strb r1, [r4, r0]
	pop {r4, pc}
_022249CC:
	sub r1, r3, #1
	add r3, #0xb
	ldrb r1, [r4, r1]
	ldrb r3, [r4, r3]
	mov r2, #2
	bl ov08_022247E4
	mov r1, #0x45
	lsl r1, r1, #6
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #2
	bl ov08_02224858
	mov r1, #0x45
	lsl r1, r1, #6
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #2
	bl ov08_022248D0
	ldr r0, _02224A4C ; =0x0000113F
	mov r1, #0
	strb r1, [r4, r0]
	mov r1, #2
	sub r0, r0, #1
	strb r1, [r4, r0]
	pop {r4, pc}
_02224A04:
	sub r1, r3, #1
	add r3, #0xb
	ldrb r1, [r4, r1]
	ldrb r3, [r4, r3]
	mov r2, #0
	bl ov08_022247E4
	mov r1, #0x45
	lsl r1, r1, #6
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0
	bl ov08_02224858
	mov r1, #0x45
	lsl r1, r1, #6
	ldrb r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0
	bl ov08_022248D0
	ldr r0, _02224A4C ; =0x0000113F
	mov r2, #0
	strb r2, [r4, r0]
	sub r1, r0, #1
	strb r2, [r4, r1]
	add r1, r0, #2
	ldrb r2, [r4, r1]
	mov r1, #0xf
	add r0, r0, #2
	bic r2, r1
	strb r2, [r4, r0]
_02224A44:
	pop {r4, pc}
	nop
_02224A48: .word 0x00001141
_02224A4C: .word 0x0000113F
	thumb_func_end ov08_02224974

	thumb_func_start ov08_02224A50
ov08_02224A50: ; 0x02224A50
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	beq _02224A62
	cmp r6, #1
	beq _02224AC0
	cmp r6, #2
	beq _02224B46
	pop {r3, r4, r5, r6, r7, pc}
_02224A62:
	mov r1, #0
	add r2, r1, #0
	add r3, r6, #0
	bl ov08_022247E4
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	add r0, r5, #0
	mov r1, #2
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	add r0, r5, #0
	mov r1, #3
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	ldr r0, [r5]
	ldrh r0, [r0, #0x20]
	cmp r0, #0
	bne _02224AA6
	add r0, r5, #0
	mov r1, #4
	mov r2, #3
	add r3, r6, #0
	bl ov08_022247E4
	b _02224AB2
_02224AA6:
	add r0, r5, #0
	mov r1, #4
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
_02224AB2:
	add r0, r5, #0
	mov r1, #5
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	pop {r3, r4, r5, r6, r7, pc}
_02224AC0:
	mov r4, #0
	mov r7, #3
_02224AC4:
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02223CD4
	cmp r0, #0
	bne _02224AE2
	add r1, r4, #6
	lsl r1, r1, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	add r2, r7, #0
	add r3, r6, #0
	bl ov08_022247E4
	b _02224AF2
_02224AE2:
	add r1, r4, #6
	lsl r1, r1, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
_02224AF2:
	add r4, r4, #1
	cmp r4, #6
	blo _02224AC4
	ldr r0, _02224B60 ; =0x0000114D
	ldrb r1, [r5, r0]
	add r0, r0, #7
	add r1, r5, r1
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _02224B20
	add r0, r5, #0
	mov r1, #0xc
	mov r2, #3
	add r3, r6, #0
	bl ov08_022247E4
	add r0, r5, #0
	mov r1, #0xd
	mov r2, #3
	add r3, r6, #0
	bl ov08_022247E4
	b _02224B38
_02224B20:
	add r0, r5, #0
	mov r1, #0xc
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	add r0, r5, #0
	mov r1, #0xd
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
_02224B38:
	add r0, r5, #0
	mov r1, #0xe
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	pop {r3, r4, r5, r6, r7, pc}
_02224B46:
	mov r1, #0xf
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	add r0, r5, #0
	mov r1, #0x10
	mov r2, #0
	add r3, r6, #0
	bl ov08_022247E4
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02224B60: .word 0x0000114D
	thumb_func_end ov08_02224A50

	thumb_func_start ov08_02224B64
ov08_02224B64: ; 0x02224B64
	push {r3, lr}
	mov r1, #0x10
	bl Heap_Alloc
	add r3, r0, #0
	mov r2, #0x10
	mov r1, #0
_02224B72:
	strb r1, [r3]
	add r3, r3, #1
	sub r2, r2, #1
	bne _02224B72
	pop {r3, pc}
	thumb_func_end ov08_02224B64

	thumb_func_start ov08_02224B7C
ov08_02224B7C: ; 0x02224B7C
	ldr r3, _02224B80 ; =Heap_Free
	bx r3
	.balign 4, 0
_02224B80: .word Heap_Free
	thumb_func_end ov08_02224B7C

	thumb_func_start ov08_02224B84
ov08_02224B84: ; 0x02224B84
	ldr r0, [r0]
	bx lr
	thumb_func_end ov08_02224B84

	thumb_func_start ov08_02224B88
ov08_02224B88: ; 0x02224B88
	ldrb r0, [r0, #9]
	bx lr
	thumb_func_end ov08_02224B88

	thumb_func_start ov08_02224B8C
ov08_02224B8C: ; 0x02224B8C
	ldrb r0, [r0, #8]
	bx lr
	thumb_func_end ov08_02224B8C

	thumb_func_start ov08_02224B90
ov08_02224B90: ; 0x02224B90
	strb r1, [r0, #8]
	bx lr
	thumb_func_end ov08_02224B90

	thumb_func_start ov08_02224B94
ov08_02224B94: ; 0x02224B94
	str r1, [r0]
	bx lr
	thumb_func_end ov08_02224B94

	thumb_func_start ov08_02224B98
ov08_02224B98: ; 0x02224B98
	push {r3, r4, lr}
	sub sp, #4
	strb r1, [r0, #9]
	ldrb r1, [r0, #8]
	cmp r1, #1
	bne _02224BBC
	ldrb r1, [r0, #9]
	ldr r2, [r0, #4]
	lsl r4, r1, #3
	add r3, r2, r4
	ldrb r1, [r3, #3]
	str r1, [sp]
	ldrb r1, [r2, r4]
	ldrb r2, [r3, #2]
	ldrb r3, [r3, #1]
	ldr r0, [r0]
	bl ov12_0226BAFC
_02224BBC:
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov08_02224B98

	thumb_func_start ov08_02224BC0
ov08_02224BC0: ; 0x02224BC0
	mov r1, #0
	strb r1, [r0, #9]
	mov r1, #0xff
	strb r1, [r0, #0xa]
	bx lr
	.balign 4, 0
	thumb_func_end ov08_02224BC0

	thumb_func_start ov08_02224BCC
ov08_02224BCC: ; 0x02224BCC
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r5, r1, #0
	bl ov08_02224BC0
	mov r0, #0
	str r5, [r4, #4]
	mvn r0, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #8]
	cmp r0, #1
	bne _02224BF6
	ldr r3, [r4, #4]
	ldrb r0, [r3, #3]
	str r0, [sp]
	ldrb r1, [r3]
	ldrb r2, [r3, #2]
	ldrb r3, [r3, #1]
	ldr r0, [r4]
	bl ov12_0226BAFC
_02224BF6:
	pop {r3, r4, r5, pc}
	thumb_func_end ov08_02224BCC

	thumb_func_start ov08_02224BF8
ov08_02224BF8: ; 0x02224BF8
	str r1, [r0, #0xc]
	bx lr
	thumb_func_end ov08_02224BF8

	thumb_func_start ov08_02224BFC
ov08_02224BFC: ; 0x02224BFC
	push {r3, r4, lr}
	sub sp, #4
	ldrb r1, [r0, #8]
	cmp r1, #1
	bne _02224C0C
	add sp, #4
	mov r0, #1
	pop {r3, r4, pc}
_02224C0C:
	ldr r1, _02224C40 ; =gSystem
	ldr r2, [r1, #0x48]
	mov r1, #0xf3
	tst r1, r2
	beq _02224C38
	mov r1, #1
	strb r1, [r0, #8]
	ldrb r1, [r0, #9]
	ldr r2, [r0, #4]
	lsl r4, r1, #3
	add r3, r2, r4
	ldrb r1, [r3, #3]
	str r1, [sp]
	ldrb r1, [r2, r4]
	ldrb r2, [r3, #2]
	ldrb r3, [r3, #1]
	ldr r0, [r0]
	bl ov12_0226BAFC
	ldr r0, _02224C44 ; =0x000005DC
	bl PlaySE
_02224C38:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	nop
_02224C40: .word gSystem
_02224C44: .word 0x000005DC
	thumb_func_end ov08_02224BFC

	thumb_func_start ov08_02224C48
ov08_02224C48: ; 0x02224C48
	cmp r1, #3
	bhi _02224C90
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02224C58: ; jump table
	.short _02224C60 - _02224C58 - 2 ; case 0
	.short _02224C6C - _02224C58 - 2 ; case 1
	.short _02224C78 - _02224C58 - 2 ; case 2
	.short _02224C84 - _02224C58 - 2 ; case 3
_02224C60:
	ldrb r1, [r0, #5]
	mov r0, #0x80
	tst r0, r1
	beq _02224C90
	mov r0, #1
	bx lr
_02224C6C:
	ldrb r1, [r0, #4]
	mov r0, #0x80
	tst r0, r1
	beq _02224C90
	mov r0, #1
	bx lr
_02224C78:
	ldrb r1, [r0, #7]
	mov r0, #0x80
	tst r0, r1
	beq _02224C90
	mov r0, #1
	bx lr
_02224C84:
	ldrb r1, [r0, #6]
	mov r0, #0x80
	tst r0, r1
	beq _02224C90
	mov r0, #1
	bx lr
_02224C90:
	mov r0, #0
	bx lr
	thumb_func_end ov08_02224C48

	thumb_func_start ov08_02224C94
ov08_02224C94: ; 0x02224C94
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	bl ov08_02224BFC
	cmp r0, #0
	bne _02224CAA
	mov r0, #0
	add sp, #0x14
	mvn r0, r0
	pop {r4, r5, r6, r7, pc}
_02224CAA:
	ldr r0, _02224E20 ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _02224CCE
	mov r1, #0
	str r1, [sp]
	ldrb r0, [r5, #9]
	add r2, r1, #0
	add r3, r1, #0
	str r0, [sp, #4]
	str r1, [sp, #8]
	ldr r0, [r5, #4]
	bl DpadMenuBox_GetNeighborInDirection
	add r4, r0, #0
	mov r6, #0
	b _02224D36
_02224CCE:
	mov r1, #0x80
	tst r1, r0
	beq _02224CF0
	mov r1, #0
	str r1, [sp]
	ldrb r0, [r5, #9]
	add r2, r1, #0
	add r3, r1, #0
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5, #4]
	bl DpadMenuBox_GetNeighborInDirection
	add r4, r0, #0
	mov r6, #1
	b _02224D36
_02224CF0:
	mov r1, #0x20
	tst r1, r0
	beq _02224D12
	mov r1, #0
	str r1, [sp]
	ldrb r0, [r5, #9]
	add r2, r1, #0
	add r3, r1, #0
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	ldr r0, [r5, #4]
	bl DpadMenuBox_GetNeighborInDirection
	add r4, r0, #0
	mov r6, #2
	b _02224D36
_02224D12:
	mov r1, #0x10
	tst r0, r1
	beq _02224D34
	mov r1, #0
	str r1, [sp]
	ldrb r0, [r5, #9]
	add r2, r1, #0
	add r3, r1, #0
	str r0, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	ldr r0, [r5, #4]
	bl DpadMenuBox_GetNeighborInDirection
	add r4, r0, #0
	mov r6, #3
	b _02224D36
_02224D34:
	mov r4, #0xff
_02224D36:
	cmp r4, #0xff
	beq _02224DF6
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #0x80
	add r1, r4, #0
	tst r1, r0
	beq _02224D56
	ldrb r1, [r5, #0xa]
	cmp r1, #0xff
	beq _02224D50
	add r4, r1, #0
	b _02224D56
_02224D50:
	eor r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_02224D56:
	mov r7, #0
_02224D58:
	mov r0, #1
	ldr r1, [r5, #0xc]
	lsl r0, r4
	tst r0, r1
	bne _02224D90
	str r7, [sp, #0xc]
	str r7, [sp]
	str r4, [sp, #4]
	str r6, [sp, #8]
	ldr r0, [r5, #4]
	add r1, r7, #0
	add r2, r7, #0
	add r3, r7, #0
	bl DpadMenuBox_GetNeighborInDirection
	mov r1, #0x7f
	and r0, r1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	cmp r1, r4
	beq _02224D88
	ldrb r0, [r5, #9]
	cmp r1, r0
	bne _02224D8C
_02224D88:
	ldrb r4, [r5, #9]
	b _02224D90
_02224D8C:
	add r4, r1, #0
	b _02224D58
_02224D90:
	ldrb r0, [r5, #9]
	cmp r0, r4
	beq _02224DEE
	ldr r0, [r5, #4]
	lsl r7, r4, #3
	add r1, sp, #0x10
	add r2, sp, #0x10
	add r0, r0, r7
	add r1, #3
	add r2, #2
	bl DpadMenuBox_GetPosition
	ldr r0, [r5, #4]
	add r1, sp, #0x10
	add r0, r0, r7
	add r1, #1
	add r2, sp, #0x10
	bl DpadMenuBox_GetDimensions
	ldr r0, [r5, #4]
	add r1, r6, #0
	add r0, r0, r7
	bl ov08_02224C48
	cmp r0, #1
	bne _02224DD0
	ldr r0, [sp, #0xc]
	cmp r0, #0
	beq _02224DD0
	ldrb r0, [r5, #9]
	strb r0, [r5, #0xa]
	b _02224DD4
_02224DD0:
	mov r0, #0xff
	strb r0, [r5, #0xa]
_02224DD4:
	strb r4, [r5, #9]
	add r3, sp, #0x10
	ldrb r0, [r3]
	str r0, [sp]
	ldrb r1, [r3, #3]
	ldrb r2, [r3, #1]
	ldrb r3, [r3, #2]
	ldr r0, [r5]
	bl ov12_0226BAFC
	ldr r0, _02224E24 ; =0x000005DC
	bl PlaySE
_02224DEE:
	mov r0, #0
	add sp, #0x14
	mvn r0, r0
	pop {r4, r5, r6, r7, pc}
_02224DF6:
	ldr r0, _02224E20 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	beq _02224E06
	add sp, #0x14
	ldrb r0, [r5, #9]
	pop {r4, r5, r6, r7, pc}
_02224E06:
	mov r0, #2
	tst r1, r0
	beq _02224E1A
	ldr r0, _02224E28 ; =0x000005DD
	bl PlaySE
	mov r0, #1
	add sp, #0x14
	mvn r0, r0
	pop {r4, r5, r6, r7, pc}
_02224E1A:
	sub r0, r0, #3
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02224E20: .word gSystem
_02224E24: .word 0x000005DC
_02224E28: .word 0x000005DD
	thumb_func_end ov08_02224C94

	.rodata

ov08_02224E2C:
	.byte 0x00, 0x02, 0x04, 0x01
	.byte 0x03, 0x05, 0x00, 0x00

ov08_02224E34: ; 0x02224E34
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00

ov08_02224E44: ; 0x02224E44
	.byte 0x98, 0xBF, 0x00, 0xCF, 0x00, 0x27, 0xB8, 0xFF, 0x98, 0xBF, 0xD8, 0xFF
	.byte 0xFF, 0x00, 0x00, 0x00

ov08_02224E54: ; 0x02224E54
	.byte 0x08, 0x8F, 0x08, 0xF7, 0x98, 0xBF, 0x00, 0x67, 0x98, 0xBF, 0x68, 0xCF
	.byte 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02224E68: ; 0x02224E68
	.byte 0x98, 0xBF, 0x00, 0x27, 0x98, 0xBF, 0x28, 0x4F
	.byte 0x98, 0xBF, 0x60, 0xC7, 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02224E7C: ; 0x02224E7C
	.byte 0x98, 0xA7, 0x58, 0x7F
	.byte 0x98, 0xA7, 0x80, 0xA7, 0xA8, 0xB7, 0x58, 0x7F, 0xA8, 0xB7, 0x80, 0xA7, 0x98, 0xBF, 0xD8, 0xFF
	.byte 0xFF, 0x00, 0x00, 0x00

ov08_02224E94: ; 0x02224E94
	.byte 0x30, 0x5F, 0x00, 0x7F, 0x30, 0x5F, 0x80, 0xFF, 0x60, 0x8F, 0x00, 0x7F
	.byte 0x60, 0x8F, 0x80, 0xFF, 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02224EAC: ; 0x02224EAC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x02
	.byte 0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov08_02224EC8: ; 0x02224EC8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x03, 0x06, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov08_02224EE4: ; 0x02224EE4
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x02, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov08_02224F00: ; 0x02224F00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x02, 0x04, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov08_02224F1C: ; 0x02224F1C
	.byte 0x00, 0x2F, 0x00, 0x7F
	.byte 0x08, 0x37, 0x80, 0xFF, 0x30, 0x5F, 0x00, 0x7F, 0x38, 0x67, 0x80, 0xFF, 0x60, 0x8F, 0x00, 0x7F
	.byte 0x68, 0x97, 0x80, 0xFF, 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02224F3C: ; 0x02224F3C
	.byte 0x30, 0x5F, 0x00, 0x7F
	.byte 0x30, 0x5F, 0x80, 0xFF, 0x60, 0x8F, 0x00, 0x7F, 0x60, 0x8F, 0x80, 0xFF, 0x90, 0xBF, 0x40, 0xBF
	.byte 0x00, 0x27, 0xB8, 0xFF, 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02224F5C: ; 0x02224F5C
	.byte 0x30, 0x5F, 0x00, 0x7F
	.byte 0x30, 0x5F, 0x80, 0xFF, 0x60, 0x8F, 0x00, 0x7F, 0x60, 0x8F, 0x80, 0xFF, 0x98, 0xBF, 0x00, 0x27
	.byte 0x98, 0xBF, 0x28, 0x4F, 0x98, 0xBF, 0x60, 0xC7, 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02224F80: ; 0x02224F80
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00
	.byte 0x05, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x07, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00
	.byte 0x0B, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00
	.byte 0x0D, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00

ov08_02224FD0: ; 0x02224FD0
	.byte 0x04, 0x02, 0x15, 0x16, 0x02, 0x0F, 0x1F, 0x00, 0x04, 0x02, 0x13, 0x1B, 0x04, 0x0F, 0x1F, 0x00

ov08_02224FE0: ; 0x02224FE0
	.byte 0x3D, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00, 0x46, 0x00, 0x00, 0x00
	.byte 0x49, 0x00, 0x00, 0x00

ov08_02224FF4: ; 0x02224FF4
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00

ov08_0222500C: ; 0x0222500C
	.byte 0x05, 0x0A, 0x04, 0x0C
	.byte 0x03, 0x09, 0x01, 0x00, 0x05, 0x0B, 0x0C, 0x0A, 0x03, 0x09, 0x25, 0x00, 0x05, 0x01, 0x14, 0x0B
	.byte 0x03, 0x09, 0x43, 0x00, 0x05, 0x0E, 0x14, 0x0B, 0x03, 0x09, 0x64, 0x00

ov08_0222502C: ; 0x0222502C
	.byte 0x04, 0x05, 0x01, 0x09
	.byte 0x02, 0x0D, 0x8B, 0x00, 0x04, 0x01, 0x06, 0x0E, 0x05, 0x09, 0x9D, 0x00, 0x04, 0x11, 0x06, 0x0E
	.byte 0x05, 0x09, 0xE3, 0x00, 0x04, 0x01, 0x0C, 0x0E, 0x05, 0x09, 0x29, 0x01, 0x04, 0x11, 0x0C, 0x0E
	.byte 0x05, 0x09, 0x6F, 0x01

ov08_02225054: ; 0x02225054
	.byte 0x04, 0x05, 0x01, 0x09, 0x02, 0x0D, 0x85, 0x00, 0x04, 0x01, 0x06, 0x0E
	.byte 0x05, 0x09, 0x97, 0x00, 0x04, 0x11, 0x06, 0x0E, 0x05, 0x09, 0xDD, 0x00, 0x04, 0x01, 0x0C, 0x0E
	.byte 0x05, 0x09, 0x23, 0x01, 0x04, 0x11, 0x0C, 0x0E, 0x05, 0x09, 0x69, 0x01, 0x04, 0x09, 0x12, 0x0E
	.byte 0x05, 0x09, 0xAF, 0x01

ov08_02225084: ; 0x02225084
	.byte 0x05, 0x00, 0x00, 0x0F, 0x05, 0x09, 0x85, 0x00, 0x05, 0x10, 0x01, 0x0F
	.byte 0x05, 0x09, 0xD0, 0x00, 0x05, 0x00, 0x06, 0x0F, 0x05, 0x09, 0x1B, 0x01, 0x05, 0x10, 0x07, 0x0F
	.byte 0x05, 0x09, 0x66, 0x01, 0x05, 0x00, 0x0C, 0x0F, 0x05, 0x09, 0xB1, 0x01, 0x05, 0x10, 0x0D, 0x0F
	.byte 0x05, 0x09, 0xFC, 0x01

ov08_022250B4: ; 0x022250B4
	.byte 0x05, 0x05, 0x01, 0x09, 0x02, 0x0D, 0x01, 0x00, 0x05, 0x04, 0x08, 0x0B
	.byte 0x02, 0x0D, 0x13, 0x00, 0x05, 0x14, 0x08, 0x02, 0x02, 0x0D, 0x29, 0x00, 0x05, 0x17, 0x08, 0x05
	.byte 0x02, 0x0D, 0x2D, 0x00, 0x05, 0x02, 0x0B, 0x0C, 0x02, 0x0D, 0x45, 0x01, 0x05, 0x10, 0x0B, 0x0F
	.byte 0x06, 0x0D, 0x5D, 0x01, 0x05, 0x07, 0x14, 0x0C, 0x03, 0x09, 0x37, 0x00

ov08_022250EC: ; 0x022250EC
	.byte 0x05, 0x05, 0x01, 0x09
	.byte 0x02, 0x0D, 0x25, 0x01, 0x05, 0x01, 0x06, 0x0E, 0x05, 0x09, 0x49, 0x01, 0x05, 0x11, 0x06, 0x0E
	.byte 0x05, 0x09, 0x8F, 0x01, 0x05, 0x01, 0x0C, 0x0E, 0x05, 0x09, 0xD5, 0x01, 0x05, 0x11, 0x0C, 0x0E
	.byte 0x05, 0x09, 0x1B, 0x02, 0x05, 0x0D, 0x14, 0x0B, 0x03, 0x09, 0x04, 0x01, 0x05, 0x05, 0x01, 0x09
	.byte 0x02, 0x0D, 0x37, 0x01, 0x05, 0x01, 0x06, 0x0E, 0x05, 0x09, 0x61, 0x02, 0x05, 0x11, 0x06, 0x0E
	.byte 0x05, 0x09, 0xA7, 0x02, 0x05, 0x01, 0x0C, 0x0E, 0x05, 0x09, 0xED, 0x02, 0x05, 0x11, 0x0C, 0x0E
	.byte 0x05, 0x09, 0x33, 0x03

ov08_02225144: ; 0x02225144
	.byte 0x05, 0x05, 0x01, 0x09, 0x02, 0x0D, 0x01, 0x00, 0x05, 0x04, 0x05, 0x0B
	.byte 0x02, 0x0D, 0x13, 0x00, 0x05, 0x14, 0x05, 0x02, 0x02, 0x0D, 0x29, 0x00, 0x05, 0x17, 0x05, 0x05
	.byte 0x02, 0x0D, 0x2D, 0x00, 0x05, 0x01, 0x10, 0x08, 0x02, 0x0D, 0x5B, 0x00, 0x05, 0x01, 0x0D, 0x08
	.byte 0x02, 0x0D, 0x6B, 0x00, 0x05, 0x0A, 0x10, 0x03, 0x02, 0x0D, 0x7B, 0x00, 0x05, 0x0A, 0x0D, 0x03
	.byte 0x02, 0x0D, 0x81, 0x00, 0x05, 0x10, 0x08, 0x0F, 0x0A, 0x0D, 0x87, 0x00, 0x05, 0x01, 0x08, 0x0C
	.byte 0x02, 0x0D, 0x1D, 0x01, 0x05, 0x06, 0x0A, 0x08, 0x02, 0x0D, 0x35, 0x01, 0x05, 0x07, 0x14, 0x0C
	.byte 0x03, 0x09, 0x37, 0x00

ov08_022251A4: ; 0x022251A4
	.byte 0x04, 0x04, 0x05, 0x0B, 0x02, 0x0D, 0x9D, 0x00, 0x04, 0x17, 0x05, 0x05
	.byte 0x02, 0x0D, 0xB7, 0x00, 0x04, 0x0A, 0x10, 0x03, 0x02, 0x0D, 0xE1, 0x00, 0x04, 0x0A, 0x0D, 0x03
	.byte 0x02, 0x0D, 0xE7, 0x00, 0x04, 0x10, 0x08, 0x0F, 0x0A, 0x0D, 0xED, 0x00, 0x04, 0x06, 0x0A, 0x08
	.byte 0x02, 0x0D, 0x9B, 0x01, 0x04, 0x05, 0x01, 0x09, 0x02, 0x0D, 0x8B, 0x00, 0x04, 0x14, 0x05, 0x02
	.byte 0x02, 0x0D, 0xB3, 0x00, 0x04, 0x01, 0x10, 0x08, 0x02, 0x0D, 0xC1, 0x00, 0x04, 0x01, 0x0D, 0x08
	.byte 0x02, 0x0D, 0xD1, 0x00, 0x04, 0x01, 0x08, 0x0C, 0x02, 0x0D, 0x83, 0x01, 0x04, 0x04, 0x05, 0x0B
	.byte 0x02, 0x0D, 0xAB, 0x01, 0x04, 0x17, 0x05, 0x05, 0x02, 0x0D, 0xC1, 0x01, 0x04, 0x0A, 0x10, 0x03
	.byte 0x02, 0x0D, 0xCB, 0x01, 0x04, 0x0A, 0x0D, 0x03, 0x02, 0x0D, 0xD1, 0x01, 0x04, 0x10, 0x08, 0x0F
	.byte 0x0A, 0x0D, 0xD7, 0x01, 0x04, 0x06, 0x0A, 0x08, 0x02, 0x0D, 0x6D, 0x02

ov08_0222522C: ; 0x0222522C
	.byte 0x05, 0x05, 0x01, 0x09
	.byte 0x02, 0x0D, 0x25, 0x01, 0x05, 0x01, 0x09, 0x0B, 0x02, 0x0D, 0x49, 0x01, 0x05, 0x01, 0x0B, 0x12
	.byte 0x04, 0x0D, 0x5F, 0x01, 0x05, 0x04, 0x10, 0x0C, 0x02, 0x0D, 0xA7, 0x01, 0x05, 0x18, 0x04, 0x07
	.byte 0x02, 0x0D, 0xBF, 0x01, 0x05, 0x1C, 0x07, 0x03, 0x02, 0x0D, 0xCD, 0x01, 0x05, 0x1C, 0x09, 0x03
	.byte 0x02, 0x0D, 0xD3, 0x01, 0x05, 0x1C, 0x0F, 0x03, 0x02, 0x0D, 0xD9, 0x01, 0x05, 0x1C, 0x0B, 0x03
	.byte 0x02, 0x0D, 0xDF, 0x01, 0x05, 0x1C, 0x0D, 0x03, 0x02, 0x0D, 0xE5, 0x01, 0x05, 0x19, 0x06, 0x06
	.byte 0x01, 0x09, 0xEB, 0x01, 0x05, 0x05, 0x04, 0x03, 0x02, 0x0D, 0xF1, 0x01, 0x05, 0x0D, 0x06, 0x06
	.byte 0x02, 0x0D, 0xF7, 0x01, 0x05, 0x15, 0x04, 0x02, 0x02, 0x0D, 0x85, 0x00, 0x05, 0x15, 0x07, 0x06
	.byte 0x02, 0x0D, 0x89, 0x00, 0x05, 0x15, 0x09, 0x06, 0x02, 0x0D, 0x95, 0x00, 0x05, 0x15, 0x0F, 0x06
	.byte 0x02, 0x0D, 0xA1, 0x00, 0x05, 0x15, 0x0B, 0x06, 0x02, 0x0D, 0xAD, 0x00, 0x05, 0x15, 0x0D, 0x06
	.byte 0x02, 0x0D, 0xB9, 0x00, 0x05, 0x01, 0x04, 0x04, 0x02, 0x0D, 0xC5, 0x00, 0x05, 0x01, 0x06, 0x0B
	.byte 0x02, 0x0D, 0xCD, 0x00, 0x05, 0x0D, 0x14, 0x0B, 0x03, 0x09, 0xE3, 0x00, 0x05, 0x05, 0x01, 0x09
	.byte 0x02, 0x0D, 0x37, 0x01, 0x05, 0x01, 0x09, 0x0B, 0x02, 0x0D, 0x61, 0x02, 0x05, 0x01, 0x0B, 0x12
	.byte 0x04, 0x0D, 0x77, 0x02, 0x05, 0x04, 0x10, 0x0C, 0x02, 0x0D, 0xBF, 0x02, 0x05, 0x18, 0x04, 0x07
	.byte 0x02, 0x0D, 0xD7, 0x02, 0x05, 0x1C, 0x07, 0x03, 0x02, 0x0D, 0xE5, 0x02, 0x05, 0x1C, 0x09, 0x03
	.byte 0x02, 0x0D, 0xEB, 0x02, 0x05, 0x1C, 0x0F, 0x03, 0x02, 0x0D, 0xF1, 0x02, 0x05, 0x1C, 0x0B, 0x03
	.byte 0x02, 0x0D, 0xF7, 0x02, 0x05, 0x1C, 0x0D, 0x03, 0x02, 0x0D, 0xFD, 0x02, 0x05, 0x19, 0x06, 0x06
	.byte 0x01, 0x09, 0x03, 0x03, 0x05, 0x05, 0x04, 0x03, 0x02, 0x0D, 0x09, 0x03, 0x05, 0x0D, 0x06, 0x06
	.byte 0x02, 0x0D, 0x0F, 0x03, 0x18, 0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00
	.byte 0x48, 0x00, 0x00, 0x00, 0xC6, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x88, 0x00, 0x00, 0x00
	.byte 0x30, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00
	.byte 0x0C, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0xC6, 0x00, 0x00, 0x00
	.byte 0x14, 0x00, 0x00, 0x00, 0xC6, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x88, 0x00, 0x00, 0x00
	.byte 0x48, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x88, 0x00, 0x00, 0x00
	.byte 0x30, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00
	.byte 0x0C, 0x00, 0x00, 0x00

ov08_022253B4: ; 0x022253B4
	.byte 0x82, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0xA4, 0x00, 0x00, 0x00
	.byte 0x10, 0x00, 0x00, 0x00

ov08_022253C4: ; 0x022253C4
	.byte 0x82, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0xA4, 0x00, 0x00, 0x00
	.byte 0x10, 0x00, 0x00, 0x00

ov08_022253D4: ; 0x022253D4
	.byte 0x82, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0xA4, 0x00, 0x00, 0x00
	.byte 0x10, 0x00, 0x00, 0x00

ov08_022253E4: ; 0x022253E4
	.byte 0x82, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0xA4, 0x00, 0x00, 0x00
	.byte 0x10, 0x00, 0x00, 0x00

ov08_022253F4: ; 0x022253F4
	.byte 0x82, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0xA4, 0x00, 0x00, 0x00
	.byte 0x10, 0x00, 0x00, 0x00

ov08_02225404:
	.byte 0x08, 0xA0, 0xC8, 0xB8, 0x01, 0x00, 0x00, 0x02, 0xC0, 0x08, 0xF8, 0x18
	.byte 0x01, 0x82, 0x00, 0x01, 0xE0, 0xA0, 0xF8, 0xB8, 0x01, 0x02, 0x00, 0x02

ov08_0222541C: ; 0x0222541C
	.byte 0x12, 0x00, 0x00, 0x00
	.byte 0x06, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov08_02225434:
	.byte 0x08, 0xA0, 0x20, 0xB8, 0x00, 0x00, 0x00, 0x01, 0x30, 0xA0, 0x48, 0xB8
	.byte 0x01, 0x01, 0x00, 0x02, 0x68, 0xA0, 0xC0, 0xB8, 0x02, 0x02, 0x01, 0x03, 0xE0, 0xA0, 0xF8, 0xB8
	.byte 0x03, 0x03, 0x02, 0x03

ov08_02225454: ; 0x02225454
	.byte 0x18, 0x00, 0x00, 0x00, 0x50, 0x00, 0x00, 0x00, 0x98, 0x00, 0x00, 0x00
	.byte 0x50, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x98, 0x00, 0x00, 0x00
	.byte 0x80, 0x00, 0x00, 0x00

ov08_02225474:
	.byte 0x10, 0x10, 0xF0, 0x88, 0x00, 0x81, 0x00, 0x00, 0x08, 0xA0, 0x60, 0xB8
	.byte 0x00, 0x01, 0x01, 0x02, 0x70, 0xA0, 0xC8, 0xB8, 0x00, 0x02, 0x01, 0x03, 0xE0, 0xA0, 0xF8, 0xB8
	.byte 0x00, 0x03, 0x02, 0x03

ov08_02225494:
	.byte 0x5C, 0x9D, 0x7C, 0xA5, 0x00, 0x02, 0x00, 0x01, 0x84, 0x9D, 0xA4, 0xA5
	.byte 0x01, 0x03, 0x00, 0x04, 0x5C, 0xAD, 0x7C, 0xB5, 0x00, 0x02, 0x02, 0x03, 0x84, 0xAD, 0xA4, 0xB5
	.byte 0x01, 0x03, 0x02, 0x04, 0xE0, 0xA0, 0xF8, 0xB8, 0x04, 0x04, 0x83, 0x04

ov08_022254BC: ; 0x022254BC
	.word ov08_02225594
	.word ov08_02225474
	.word ov08_02225434
	.word ov08_02225604
	.word ov08_02225494
	.word ov08_022254E4
	.word ov08_022255CC
	.word ov08_02225404
	.word ov08_022255CC
	.word ov08_02225404

ov08_022254E4:
	.byte 0x08, 0x38, 0x78, 0x58, 0x00, 0x02, 0x00, 0x01, 0x88, 0x38, 0xF8, 0x58
	.byte 0x01, 0x03, 0x00, 0x01, 0x08, 0x68, 0x78, 0x88, 0x00, 0x04, 0x02, 0x03, 0x88, 0x68, 0xF8, 0x88
	.byte 0x01, 0x04, 0x02, 0x03, 0xE0, 0xA0, 0xF8, 0xB8, 0x83, 0x04, 0x04, 0x04

ov08_0222550C: ; 0x0222550C
	.byte 0x18, 0x00, 0x00, 0x00
	.byte 0x50, 0x00, 0x00, 0x00, 0x98, 0x00, 0x00, 0x00, 0x50, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00
	.byte 0x80, 0x00, 0x00, 0x00, 0x98, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00
	.byte 0xB0, 0x00, 0x00, 0x00

ov08_02225534: ; 0x02225534
	.byte 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00
	.byte 0x18, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00
	.byte 0x48, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00
	.byte 0x78, 0x00, 0x00, 0x00

ov08_02225564: ; 0x02225564
	.byte 0x1C, 0x00, 0x00, 0x00, 0x28, 0x00, 0x00, 0x00, 0x9C, 0x00, 0x00, 0x00
	.byte 0x30, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x9C, 0x00, 0x00, 0x00
	.byte 0x60, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x88, 0x00, 0x00, 0x00, 0x9C, 0x00, 0x00, 0x00
	.byte 0x90, 0x00, 0x00, 0x00

ov08_02225594:
	.byte 0x08, 0x08, 0x78, 0x28, 0x06, 0x02, 0x06, 0x01, 0x88, 0x10, 0xF8, 0x30
	.byte 0x04, 0x03, 0x00, 0x02, 0x08, 0x38, 0x78, 0x58, 0x00, 0x04, 0x01, 0x03, 0x88, 0x40, 0xF8, 0x60
	.byte 0x01, 0x05, 0x02, 0x04, 0x08, 0x68, 0x78, 0x88, 0x02, 0x01, 0x03, 0x05, 0x88, 0x70, 0xF8, 0x90
	.byte 0x03, 0x06, 0x04, 0x06, 0xE0, 0xA0, 0xF8, 0xB8, 0x05, 0x00, 0x05, 0x00

ov08_022255CC:
	.byte 0x08, 0x38, 0x78, 0x58
	.byte 0x05, 0x02, 0x00, 0x01, 0x88, 0x38, 0xF8, 0x58, 0x05, 0x03, 0x00, 0x01, 0x08, 0x68, 0x78, 0x88
	.byte 0x00, 0x04, 0x02, 0x03, 0x88, 0x68, 0xF8, 0x88, 0x01, 0x06, 0x02, 0x03, 0x48, 0x98, 0xB8, 0xB8
	.byte 0x02, 0x04, 0x04, 0x06, 0xC0, 0x08, 0xF8, 0x18, 0x05, 0x81, 0x00, 0x05, 0xE0, 0xA0, 0xF8, 0xB8
	.byte 0x03, 0x06, 0x04, 0x06

ov08_02225604:
	.byte 0x08, 0x38, 0x78, 0x58, 0x00, 0x02, 0x00, 0x01, 0x88, 0x38, 0xF8, 0x58
	.byte 0x01, 0x03, 0x00, 0x01, 0x08, 0x68, 0x78, 0x88, 0x00, 0x84, 0x02, 0x03, 0x88, 0x68, 0xF8, 0x88
	.byte 0x01, 0x87, 0x02, 0x03, 0x08, 0xA0, 0x20, 0xB8, 0x02, 0x04, 0x04, 0x05, 0x30, 0xA0, 0x48, 0xB8
	.byte 0x02, 0x05, 0x04, 0x06, 0x68, 0xA0, 0xC0, 0xB8, 0x03, 0x06, 0x05, 0x07, 0xE0, 0xA0, 0xF8, 0xB8
	.byte 0x03, 0x07, 0x06, 0x07

ov08_02225644: ; 0x02225644
	.byte 0x16, 0xB0, 0x00, 0x00

ov08_02225648: ; 0x02225648
	.byte 0x0A, 0xB0, 0x00, 0x00

ov08_0222564C: ; 0x0222564C
	.byte 0x0A, 0xB0, 0x00, 0x00

ov08_02225650: ; 0x02225650
	.byte 0x0A, 0xB0, 0x00, 0x00

ov08_02225654: ; 0x02225654
	.byte 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00
	.byte 0x07, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00
	.byte 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x0B, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x0C, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00, 0x07, 0xB0, 0x00, 0x00
	.byte 0x07, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00
	.byte 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0xB0, 0x00, 0x00
	.byte 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x0D, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x0D, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00
	.byte 0x08, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00
	.byte 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0xB0, 0x00, 0x00
	.byte 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x08, 0xB0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x0E, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x0F, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00
	.byte 0x09, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00
	.byte 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11, 0xB0, 0x00, 0x00
	.byte 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x12, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x13, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00
	.byte 0x09, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x14, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00
	.byte 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x15, 0xB0, 0x00, 0x00
	.byte 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x09, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x17, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x17, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00
	.byte 0x0B, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00
	.byte 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17, 0xB0, 0x00, 0x00
	.byte 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x17, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00, 0x0B, 0xB0, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0xB0, 0x00, 0x00
	.byte 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x0A, 0xB0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov08_02225950:
	.byte 0x02, 0xFF, 0x00, 0x00

ov08_02225954:
	.byte 0x03, 0xFF, 0x00, 0x00

ov08_02225958:
	.byte 0x04, 0xFF, 0x00, 0x00

ov08_0222595C:
	.byte 0x01, 0xFF, 0x00, 0x00

ov08_02225960:
	.byte 0x01, 0xFF, 0x00, 0x00

ov08_02225964:
	.byte 0x0B, 0xFF, 0x00, 0x00

ov08_02225968:
	.byte 0x00, 0xFF, 0x00, 0x00

ov08_0222596C:
	.byte 0x03, 0xFF, 0x00, 0x00

ov08_02225970:
	.byte 0x05, 0xFF, 0x00, 0x00

ov08_02225974:
	.byte 0x02, 0xFF, 0x00, 0x00

ov08_02225978:
	.byte 0x06, 0xFF, 0x00, 0x00

ov08_0222597C:
	.byte 0x04, 0xFF, 0x00, 0x00

ov08_02225980:
	.byte 0x03, 0xFF, 0x00, 0x00

ov08_02225984:
	.byte 0x02, 0xFF, 0x00, 0x00

ov08_02225988:
	.byte 0x05, 0xFF, 0x00, 0x00

ov08_0222598C:
	.byte 0x01, 0xFF, 0x00, 0x00

ov08_02225990:
	.byte 0x04, 0xFF, 0x00, 0x00

ov08_02225994:
	.byte 0x02, 0xFF, 0x00, 0x00

ov08_02225998:
	.byte 0x03, 0xFF, 0x00, 0x00

ov08_0222599C:
	.byte 0x05, 0xFF, 0x00, 0x00

ov08_022259A0:
	.byte 0x15, 0xFF, 0x00, 0x00

ov08_022259A4:
	.byte 0x00, 0x01, 0xFF, 0x00

ov08_022259A8:
	.byte 0x07, 0x01, 0xFF, 0x00

ov08_022259AC: ; 0x022259AC
	.byte 0x02, 0x04, 0x02, 0x00

ov08_022259B0:
	.byte 0x08, 0x02, 0xFF, 0x00

ov08_022259B4:
	.byte 0x09, 0x03, 0xFF, 0x00

ov08_022259B8:
	.byte 0x0A, 0x04, 0xFF, 0x00

ov08_022259BC: ; 0x022259BC
	.byte 0x02, 0x03, 0x01, 0x00

ov08_022259C0: ; 0x022259C0
	.byte 0x02, 0x00, 0xFC, 0xFF, 0x02, 0x00

ov08_022259C6: ; 0x022259C6
	.byte 0x02, 0x00, 0xFD, 0xFF, 0x01, 0x00

ov08_022259CC: ; 0x022259CC
	.word ov08_02225968
	.word ov08_02225960
	.word ov08_02225994
	.word ov08_0222596C
	.word ov08_02225958
	.word ov08_02225970
	.word 0
	.word ov08_022259A4
	.word ov08_02225950
	.word ov08_0222599C
	.word ov08_02225954
	.word ov08_022259A0
	.word 0
	.word 0
	.word ov08_022259A8
	.word ov08_022259B0
	.word ov08_022259B4
	.word ov08_022259B8
	.word 0
	.word ov08_0222598C
	.word ov08_02225984
	.word ov08_02225980
	.word ov08_0222597C
	.word ov08_0222595C
	.word ov08_02225974
	.word ov08_02225998
	.word ov08_02225990
	.word ov08_02225988
	.word ov08_02225964
	.word ov08_02225978
	.word 0
	.word 0
	.word 0
	.word 0

ov08_02225A54: ; 0x02225A54
	.byte 0x00

ov08_02225A55: ; 0x02225A55
	.byte 0x00

ov08_02225A56: ; 0x02225A56
	.byte 0x10

ov08_02225A57: ; 0x02225A57
	.byte 0x06, 0x10, 0x01, 0x10, 0x06, 0x00, 0x06, 0x10, 0x06
	.byte 0x10, 0x07, 0x10, 0x06, 0x00, 0x0C, 0x10, 0x06, 0x10, 0x0D, 0x10, 0x06, 0x1B, 0x13, 0x05, 0x05
	.byte 0x01, 0x01, 0x1E, 0x11, 0x00, 0x13, 0x0D, 0x05, 0x0C, 0x13, 0x0D, 0x05, 0x0D, 0x13, 0x0D, 0x05
	.byte 0x0C, 0x13, 0x0D, 0x05, 0x00, 0x13, 0x05, 0x05, 0x05, 0x13, 0x05, 0x05, 0x00, 0x06, 0x10, 0x06
	.byte 0x10, 0x06, 0x10, 0x06, 0x00, 0x0C, 0x10, 0x06, 0x10, 0x0C, 0x10, 0x06, 0x17, 0x00, 0x09, 0x04
	.byte 0x00, 0x06, 0x10, 0x06, 0x10, 0x06, 0x10, 0x06, 0x00, 0x0C, 0x10, 0x06, 0x10, 0x0C, 0x10, 0x06
	.byte 0x00, 0x06, 0x10, 0x06, 0x10, 0x06, 0x10, 0x06, 0x00, 0x0C, 0x10, 0x06, 0x10, 0x0C, 0x10, 0x06
	.byte 0x08, 0x12, 0x10, 0x06, 0x00, 0x13, 0x1A, 0x05, 0x00, 0x13, 0x1A, 0x05, 0x0B, 0x13, 0x05, 0x02
	.byte 0x10, 0x13, 0x05, 0x02, 0x0B, 0x15, 0x05, 0x02, 0x10, 0x15, 0x05, 0x02

ov08_02225ADC: ; 0x02225ADC
	.byte 0x98, 0xBF, 0x00, 0xCF
	.byte 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02225AE8: ; 0x02225AE8
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00

ov08_02225AF8: ; 0x02225AF8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov08_02225B14: ; 0x02225B14
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x04, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov08_02225B30: ; 0x02225B30
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0x1A, 0x00, 0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov08_02225B4C: ; 0x02225B4C
	.byte 0x08, 0x4F, 0x00, 0x7F
	.byte 0x50, 0x97, 0x00, 0x7F, 0x08, 0x4F, 0x80, 0xFF, 0x50, 0x97, 0x80, 0xFF, 0x98, 0xBF, 0x00, 0xCF
	.byte 0x98, 0xBF, 0xD8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov08_02225B68: ; 0x02225B68
	.byte 0x08, 0x37, 0x00, 0x7F, 0x08, 0x37, 0x80, 0xFF
	.byte 0x38, 0x67, 0x00, 0x7F, 0x38, 0x67, 0x80, 0xFF, 0x68, 0x97, 0x00, 0x7F, 0x68, 0x97, 0x80, 0xFF
	.byte 0x98, 0xBF, 0xD8, 0xFF, 0x98, 0xBF, 0x00, 0x27, 0x98, 0xBF, 0x28, 0x4F, 0xFF, 0x00, 0x00, 0x00

ov08_02225B90: ; 0x02225B90
	.byte 0x04, 0x02, 0x13, 0x1B, 0x04, 0x0F, 0x76, 0x03

ov08_02225B98: ; 0x02225B98
	.byte 0x05, 0x07, 0x04, 0x0C, 0x02, 0x04, 0xC7, 0x02
	.byte 0x05, 0x14, 0x04, 0x04, 0x02, 0x04, 0xDF, 0x02, 0x05, 0x02, 0x09, 0x1C, 0x06, 0x04, 0xE7, 0x02
	.byte 0x05, 0x08, 0x14, 0x0A, 0x03, 0x00, 0x8F, 0x03

ov08_02225BB8: ; 0x02225BB8
	.byte 0x04, 0x02, 0x04, 0x0C, 0x05, 0x00, 0xCE, 0x02
	.byte 0x04, 0x02, 0x0D, 0x0C, 0x05, 0x00, 0x0A, 0x03, 0x04, 0x12, 0x05, 0x0C, 0x03, 0x00, 0x86, 0x02
	.byte 0x04, 0x12, 0x0E, 0x0C, 0x03, 0x00, 0xAA, 0x02, 0x04, 0x05, 0x14, 0x14, 0x03, 0x00, 0x4A, 0x02

ov08_02225BE0: ; 0x02225BE0
	.byte 0x09, 0x00, 0x00, 0x00

ov08_02225BE4: ; 0x02225BE4
	.byte 0x0A, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00
	.byte 0x0D, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00
	.byte 0x11, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00

ov08_02225C10: ; 0x02225C10
	.byte 0x05, 0x01, 0x01, 0x0E, 0x03, 0x00, 0x01, 0x00, 0x05, 0x08, 0x04, 0x04, 0x03, 0x04, 0x2B, 0x00
	.byte 0x05, 0x11, 0x01, 0x0E, 0x03, 0x00, 0x37, 0x00, 0x05, 0x18, 0x04, 0x04, 0x03, 0x04, 0x61, 0x00
	.byte 0x05, 0x01, 0x07, 0x0E, 0x03, 0x00, 0x6D, 0x00, 0x05, 0x08, 0x0A, 0x04, 0x03, 0x04, 0x97, 0x00
	.byte 0x05, 0x11, 0x07, 0x0E, 0x03, 0x00, 0xA3, 0x00, 0x05, 0x18, 0x0A, 0x04, 0x03, 0x04, 0xCD, 0x00
	.byte 0x05, 0x01, 0x0D, 0x0E, 0x03, 0x00, 0xD9, 0x00, 0x05, 0x08, 0x10, 0x04, 0x03, 0x04, 0x03, 0x01
	.byte 0x05, 0x11, 0x0D, 0x0E, 0x03, 0x00, 0x0F, 0x01, 0x05, 0x18, 0x10, 0x04, 0x03, 0x04, 0x39, 0x01
	.byte 0x05, 0x01, 0x01, 0x0E, 0x03, 0x00, 0x45, 0x01, 0x05, 0x08, 0x04, 0x04, 0x03, 0x04, 0x6F, 0x01
	.byte 0x05, 0x11, 0x01, 0x0E, 0x03, 0x00, 0x7B, 0x01, 0x05, 0x18, 0x04, 0x04, 0x03, 0x04, 0xA5, 0x01
	.byte 0x05, 0x01, 0x07, 0x0E, 0x03, 0x00, 0xB1, 0x01, 0x05, 0x08, 0x0A, 0x04, 0x03, 0x04, 0xDB, 0x01
	.byte 0x05, 0x11, 0x07, 0x0E, 0x03, 0x00, 0xE7, 0x01, 0x05, 0x18, 0x0A, 0x04, 0x03, 0x04, 0x11, 0x02
	.byte 0x05, 0x01, 0x0D, 0x0E, 0x03, 0x00, 0x1D, 0x02, 0x05, 0x08, 0x10, 0x04, 0x03, 0x04, 0x47, 0x02
	.byte 0x05, 0x11, 0x0D, 0x0E, 0x03, 0x00, 0x53, 0x02, 0x05, 0x18, 0x10, 0x04, 0x03, 0x04, 0x7D, 0x02
	.byte 0x05, 0x0B, 0x13, 0x0A, 0x05, 0x04, 0x89, 0x02, 0x05, 0x16, 0x14, 0x04, 0x03, 0x04, 0xBB, 0x02
ov08_02225CE0:
	.byte 0x02, 0x03, 0x00, 0x01, 0x00

	.balign 4
ov08_02225CE8:
	.byte 0x28, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00
	.byte 0x18, 0x00, 0x00, 0x00, 0xB2, 0x00, 0x00, 0x00

ov08_02225CF8: ; 0x02225CF8
	.word ov08_02225D44
	.word ov08_02225DA4
	.word ov08_02225D04

ov08_02225D04:
	.byte 0x08, 0xA0, 0xC8, 0xB8, 0x00, 0x00, 0x00, 0x01, 0xE0, 0xA0, 0xF8, 0xB8, 0x01, 0x01, 0x00, 0x01

ov08_02225D14: ; 0x02225D14
	.byte 0x08, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov08_02225D2C: ; 0x02225D2C
	.byte 0xC0, 0x00, 0x00, 0x00

ov08_02225D30: ; 0x02225D30
	.byte 0x18, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x68, 0x00, 0x00, 0x00
	.byte 0x98, 0x00, 0x00, 0x00

ov08_02225D44:
	.byte 0x08, 0x10, 0x78, 0x48, 0x00, 0x01, 0x00, 0x02, 0x08, 0x58, 0x78, 0x90
	.byte 0x00, 0x04, 0x01, 0x03, 0x88, 0x10, 0xF8, 0x48, 0x02, 0x03, 0x00, 0x02, 0x88, 0x58, 0xF8, 0x90
	.byte 0x02, 0x05, 0x01, 0x03, 0x08, 0xA0, 0xC8, 0xB8, 0x01, 0x04, 0x04, 0x05, 0xE0, 0xA0, 0xF8, 0xB8
	.byte 0x83, 0x05, 0x04, 0x05

ov08_02225D74: ; 0x02225D74
	.byte 0x2C, 0x00, 0x00, 0x00, 0x2D, 0x00, 0x00, 0x00, 0xAC, 0x00, 0x00, 0x00
	.byte 0x2D, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x5D, 0x00, 0x00, 0x00, 0xAC, 0x00, 0x00, 0x00
	.byte 0x5D, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x8D, 0x00, 0x00, 0x00, 0xAC, 0x00, 0x00, 0x00
	.byte 0x8D, 0x00, 0x00, 0x00

ov08_02225DA4:
	.byte 0x08, 0x10, 0x78, 0x30, 0x00, 0x02, 0x00, 0x01, 0x88, 0x10, 0xF8, 0x30
	.byte 0x01, 0x03, 0x00, 0x01, 0x08, 0x40, 0x78, 0x60, 0x00, 0x04, 0x02, 0x03, 0x88, 0x40, 0xF8, 0x60
	.byte 0x01, 0x05, 0x02, 0x03, 0x08, 0x70, 0x78, 0x90, 0x02, 0x06, 0x04, 0x05, 0x88, 0x70, 0xF8, 0x90
	.byte 0x03, 0x06, 0x04, 0x05, 0xE0, 0xA0, 0xF8, 0xB8, 0x85, 0x06, 0x06, 0x06

ov08_02225DDC: ; 0x02225DDC
	.byte 0xB7, 0xB4, 0x00, 0x00

ov08_02225DE0: ; 0x02225DE0
	.byte 0xB7, 0xB4, 0x00, 0x00

ov08_02225DE4: ; 0x02225DE4
	.byte 0xB7, 0xB4, 0x00, 0x00

ov08_02225DE8: ; 0x02225DE8
	.byte 0xB7, 0xB4, 0x00, 0x00

ov08_02225DEC: ; 0x02225DEC
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0xB8, 0xB4, 0x00, 0x00, 0xB8, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0xB9, 0xB4, 0x00, 0x00, 0xB9, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00
	.byte 0xB7, 0xB4, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xBA, 0xB4, 0x00, 0x00, 0xBA, 0xB4, 0x00, 0x00
	.byte 0xB7, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xBB, 0xB4, 0x00, 0x00
	.byte 0xBB, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0xBC, 0xB4, 0x00, 0x00, 0xBC, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00, 0xB7, 0xB4, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00

ov08_02225E54:
	.byte 0x03, 0xFF, 0x00, 0x00

ov08_02225E58:
	.byte 0x03, 0xFF, 0x00, 0x00

ov08_02225E5C:
	.byte 0x01, 0xFF, 0x00, 0x00

ov08_02225E60:
	.byte 0x04, 0xFF, 0x00, 0x00

ov08_02225E64:
	.byte 0x02, 0xFF, 0x00, 0x00

ov08_02225E68:
	.byte 0x00, 0xFF, 0x00, 0x00

ov08_02225E6C:
	.byte 0x0E, 0x0F, 0xFF, 0x00

ov08_02225E70:
	.byte 0x10, 0x11, 0xFF, 0x00

ov08_02225E74:
	.byte 0x16, 0x17, 0xFF, 0x00

ov08_02225E78:
	.byte 0x06, 0x07, 0xFF, 0x00

ov08_02225E7C:
	.byte 0x04, 0x05, 0xFF, 0x00

ov08_02225E80:
	.byte 0x02, 0x03, 0xFF, 0x00

ov08_02225E84:
	.byte 0x00, 0x01, 0xFF, 0x00

ov08_02225E88:
	.byte 0x08, 0x09, 0xFF, 0x00

ov08_02225E8C:
	.byte 0x12, 0x13, 0xFF, 0x00

ov08_02225E90:
	.byte 0x0A, 0x0B, 0xFF, 0x00

ov08_02225E94:
	.byte 0x0C, 0x0D, 0xFF, 0x00

ov08_02225E98:
	.byte 0x14, 0x15, 0xFF, 0x00

ov08_02225E9C: ; 0x02225E9C
	.byte 0x00

ov08_02225E9D: ; 0x02225E9D
	.byte 0x01

ov08_02225E9E: ; 0x02225E9E
	.byte 0x10

ov08_02225E9F: ; 0x02225E9F
	.byte 0x09
	.byte 0x00, 0x0A, 0x10, 0x09, 0x10, 0x01, 0x10, 0x09, 0x10, 0x0A, 0x10, 0x09, 0x00, 0x13, 0x1A, 0x05
	.byte 0x1B, 0x13, 0x05, 0x05, 0x20, 0x01, 0x10, 0x06, 0x30, 0x01, 0x10, 0x06, 0x20, 0x07, 0x10, 0x06
	.byte 0x30, 0x07, 0x10, 0x06, 0x20, 0x0D, 0x10, 0x06, 0x30, 0x0D, 0x10, 0x06, 0x20, 0x13, 0x05, 0x05
	.byte 0x25, 0x13, 0x05, 0x05, 0x3B, 0x13, 0x05, 0x05, 0x00, 0x33, 0x1A, 0x05, 0x1B, 0x33, 0x05, 0x05

ov08_02225EE0: ; 0x02225EE0
	.word ov08_02225E68
	.word ov08_02225E5C
	.word ov08_02225E64
	.word ov08_02225E54
	.word ov08_02225E60
	.word 0
	.word ov08_02225E84
	.word ov08_02225E80
	.word ov08_02225E7C
	.word ov08_02225E78
	.word ov08_02225E88
	.word ov08_02225E90
	.word 0
	.word 0
	.word 0
	.word ov08_02225E58
	.word 0
	.word ov08_02225E94
	.word ov08_02225E6C
	.word ov08_02225E70
	.word ov08_02225E8C
	.word ov08_02225E98
	.word ov08_02225E74
