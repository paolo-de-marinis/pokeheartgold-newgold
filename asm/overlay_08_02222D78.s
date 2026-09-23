#include "constants/moves.h"
	.include "asm/macros.inc"
	.include "overlay_08.inc"
	.include "global.inc"

.public ov08_02223AA0
.public ov08_02223CD4
.public ov08_02223F34
.public ov08_02223F94
.public ov08_02224134
.public ov08_0222421C
.public ov08_02224254
.public ov08_02224938
.public ov08_02224A50
.public ov08_02224B7C
.public ov08_02224B8C
.public ov08_02225AE8
.public ov08_02225AF8
.public ov08_02225B14
.public ov08_02225B30
.public ov08_02225B90
.public ov08_02225B98
.public ov08_02225BB8
.public ov08_02225BE0
.public ov08_02225BE4
.public ov08_02225C10

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
