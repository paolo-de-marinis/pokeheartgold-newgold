#include "config.h"
	.include "asm/macros.inc"
	.include "overlay_112.inc"
	.include "global.inc"
	.public gApplication_TitleScreen

	.text

	thumb_func_start ov112_021EECF0
ov112_021EECF0: ; 0x021EECF0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	bl ov112_021EEAF0
	add r0, r4, #0
	bl ov112_021EEA7C
	add r0, r4, #0
	bl ov112_021EE920
	pop {r4, pc}
	thumb_func_end ov112_021EECF0

	thumb_func_start ov112_021EED08
ov112_021EED08: ; 0x021EED08
	push {r4, lr}
	ldr r1, _021EEDE0 ; =0x0001E430
	add r4, r0, #0
	mov r2, #0
	str r2, [r4, r1]
	ldr r1, [r4, #0x10]
	cmp r1, #1
	bne _021EED8E
	bl ov112_021EE7A8
	add r0, r4, #0
	mov r1, #1
	bl ov112_021EEAF0
	add r0, r4, #0
	bl ov112_021EEA7C
	add r0, r4, #0
	bl ov112_021EE920
	ldr r0, _021EEDE4 ; =0x000010E7
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	bne _021EED46
	ldr r0, _021EEDE8 ; =0x0001E440
	mov r1, #1
	ldr r0, [r4, r0]
	mov r2, #0
	bl sub_020326A4
_021EED46:
	ldr r0, _021EEDE0 ; =0x0001E430
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021EED76
	ldr r2, _021EEDEC ; =0x0001D7AC
	mov r3, #0
	add r1, r4, r2
	sub r2, #0x10
	add r2, r4, r2
	bl ov112_021E9290
	add r0, r4, #0
	bl ov112_021ED0C8
	add r0, r4, #0
	bl ov112_021EAA10
	ldr r0, _021EEDF0 ; =0x0001F2C2
	mov r1, #0
	strb r1, [r4, r0]
	ldr r0, _021EEDF4 ; =0x000004A2
	bl PlayFanfare
	b _021EED82
_021EED76:
	add r0, r4, #0
	bl ov112_021EAA10
	ldr r0, _021EEDF8 ; =0x0001F2D6
	mov r1, #0x1f
	strh r1, [r4, r0]
_021EED82:
	add r0, r4, #0
	bl ov112_021E95A0
	mov r0, #0
	str r0, [r4, #8]
	b _021EEDD2
_021EED8E:
	cmp r1, #2
	bne _021EEDA4
	bl ov112_021EEA7C
	add r0, r4, #0
	mov r1, #0
	bl ov112_021EEAF0
	mov r0, #5
	str r0, [r4, #8]
	b _021EEDD2
_021EEDA4:
	cmp r1, #4
	bne _021EEDD2
	bl ov112_021EE7A8
	ldr r0, _021EEDE0 ; =0x0001E430
	ldr r2, _021EEDEC ; =0x0001D7AC
	ldr r0, [r4, r0]
	add r1, r4, r2
	sub r2, #0x10
	add r2, r4, r2
	mov r3, #0
	bl ov112_021E9290
	add r0, r4, #0
	bl ov112_021ED0C8
	mov r2, #0
	ldr r0, _021EEDE8 ; =0x0001E440
	str r2, [r4, #8]
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020326A4
_021EEDD2:
	ldr r1, _021EEDE4 ; =0x000010E7
	mov r0, #4
	ldrb r2, [r4, r1]
	bic r2, r0
	strb r2, [r4, r1]
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EEDE0: .word 0x0001E430
_021EEDE4: .word 0x000010E7
_021EEDE8: .word 0x0001E440
_021EEDEC: .word 0x0001D7AC
_021EEDF0: .word 0x0001F2C2
_021EEDF4: .word 0x000004A2
_021EEDF8: .word 0x0001F2D6
	thumb_func_end ov112_021EED08

	thumb_func_start ov112_021EEDFC
ov112_021EEDFC: ; 0x021EEDFC
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	lsl r2, r1, #2
	ldr r1, _021EEE1C ; =ov112_021FF8F8
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4, #8]
	cmp r0, #0xb
	bne _021EEE18
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #3
	pop {r4, pc}
_021EEE18:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EEE1C: .word ov112_021FF8F8
	thumb_func_end ov112_021EEDFC

	thumb_func_start ov112_021EEE20
ov112_021EEE20: ; 0x021EEE20
	push {r3, lr}
	mov r1, #8
	bl ov112_021EA688
	mov r0, #1
	pop {r3, pc}
	thumb_func_end ov112_021EEE20

	thumb_func_start ov112_021EEE2C
ov112_021EEE2C: ; 0x021EEE2C
	push {r4, lr}
	mov r1, #2
	mov r2, #0xd
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EEE48 ; =0x0001E524
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov112_021EA5A4
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021EEE48: .word 0x0001E524
	thumb_func_end ov112_021EEE2C

	thumb_func_start ov112_021EEE4C
ov112_021EEE4C: ; 0x021EEE4C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EEE84 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EEE7E
	ldr r0, _021EEE88 ; =0x0001F2D6
	ldrh r0, [r4, r0]
	cmp r0, #0x1f
	bne _021EEE7E
	bl sub_02006B84
	cmp r0, #0
	bne _021EEE7E
	bl IsFanfarePlaying
	add r0, r4, #0
	bl ov112_021EA17C
	mov r0, #2
	pop {r4, pc}
_021EEE7E:
	mov r0, #1
	pop {r4, pc}
	nop
_021EEE84: .word 0x0001E524
_021EEE88: .word 0x0001F2D6
	thumb_func_end ov112_021EEE4C

	thumb_func_start ov112_021EEE8C
ov112_021EEE8C: ; 0x021EEE8C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x20]
	bl SaveGameNormal
	ldr r0, [r4, #0x20]
	bl Save_ClearStatusFlags
	mov r0, #3
	pop {r4, pc}
	thumb_func_end ov112_021EEE8C

	thumb_func_start ov112_021EEEA0
ov112_021EEEA0: ; 0x021EEEA0
	push {r3, lr}
	bl ov112_021EA19C
	mov r0, #4
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EEEA0

	thumb_func_start ov112_021EEEAC
ov112_021EEEAC: ; 0x021EEEAC
	ldr r1, [r0, #0x10]
	cmp r1, #4
	bne _021EEEB6
	mov r1, #0
	b _021EEEB8
_021EEEB6:
	mov r1, #8
_021EEEB8:
	str r1, [r0, #4]
	mov r0, #0xa
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021EEEAC

	thumb_func_start ov112_021EEEC0
ov112_021EEEC0: ; 0x021EEEC0
	push {r4, lr}
	mov r1, #2
	mov r2, #0xd
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EEEDC ; =0x0001E524
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov112_021EA5A4
	mov r0, #6
	pop {r4, pc}
	.balign 4, 0
_021EEEDC: .word 0x0001E524
	thumb_func_end ov112_021EEEC0

	thumb_func_start ov112_021EEEE0
ov112_021EEEE0: ; 0x021EEEE0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EEF04 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EEEFE
	add r0, r4, #0
	bl ov112_021EA17C
	mov r0, #7
	pop {r4, pc}
_021EEEFE:
	mov r0, #6
	pop {r4, pc}
	nop
_021EEF04: .word 0x0001E524
	thumb_func_end ov112_021EEEE0

	thumb_func_start ov112_021EEF08
ov112_021EEF08: ; 0x021EEF08
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x20]
	bl SaveGameNormal
	ldr r0, [r4, #0x20]
	bl Save_ClearStatusFlags
	mov r0, #8
	pop {r4, pc}
	thumb_func_end ov112_021EEF08

	thumb_func_start ov112_021EEF1C
ov112_021EEF1C: ; 0x021EEF1C
	push {r3, lr}
	bl ov112_021EA19C
	mov r0, #9
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EEF1C

	thumb_func_start ov112_021EEF28
ov112_021EEF28: ; 0x021EEF28
	mov r1, #0xa
	str r1, [r0, #4]
	add r0, r1, #0
	bx lr
	thumb_func_end ov112_021EEF28

	thumb_func_start ov112_021EEF30
ov112_021EEF30: ; 0x021EEF30
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #6
	bl ov112_021EA688
	mov r0, #0xb
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EEF30

	thumb_func_start ov112_021EEF68
ov112_021EEF68: ; 0x021EEF68
	push {r3, r4, r5, r6, lr}
	sub sp, #0x24
	ldr r6, _021EF028 ; =0x0001D764
	add r5, r0, #0
	ldr r1, [r5, r6]
	cmp r1, #0
	beq _021EEF7C
	cmp r1, #1
	beq _021EEF86
	b _021EF022
_021EEF7C:
	bl ov112_021E77E4
	mov r0, #1
	str r0, [r5, r6]
	b _021EF022
_021EEF86:
	mov r0, #0x9a
	bl BgConfig_Alloc
	str r0, [r5, #0x18]
	bl ov112_021EF15C
	mov r0, #0x9a
	mov r1, #1
	mov r2, #0x12
	bl sub_020932E0
	add r1, r6, #4
	str r0, [r5, r1]
	mov r0, #0x9a
	bl ov112_021F039C
	add r1, r6, #0
	add r1, #8
	str r0, [r5, r1]
	ldr r0, [r5, #0x18]
	bl ov112_021EF17C
	bl ov112_021EF19C
	add r0, r6, #0
	add r0, r5, r0
	bl ov112_021EF1CC
	mov r1, #0
	add r0, r6, #0
	str r1, [r5, r0]
	ldr r0, [r5, #0x20]
	bl SaveArray_PCStorage_Get
	add r4, r0, #0
	ldr r0, [r5, #0x20]
	bl SaveArray_Party_Get
	mov r1, #0
	str r1, [sp]
	add r3, r0, #0
	str r1, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, _021EF02C ; =ov112_021EF298
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, _021EF030 ; =ov112_021EF300
	add r2, r4, #0
	str r0, [sp, #0x14]
	add r0, r6, #0
	add r0, #0xc
	add r1, r5, r0
	str r1, [sp, #0x18]
	ldr r1, _021EF034 ; =ov112_021EF3F8
	sub r0, #8
	str r1, [sp, #0x1c]
	str r5, [sp, #0x20]
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x18]
	bl sub_02093440
	add r0, r6, #0
	add r0, #8
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x18]
	bl ov112_021F03BC
	add r1, r6, #0
	ldr r0, _021EF038 ; =ov112_021EF310
	add r1, r5, r1
	bl Main_SetVBlankIntrCB
	mov r0, #0
	str r0, [r5, r6]
	add sp, #0x24
	mov r0, #2
	pop {r3, r4, r5, r6, pc}
_021EF022:
	mov r0, #1
	add sp, #0x24
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EF028: .word 0x0001D764
_021EF02C: .word ov112_021EF298
_021EF030: .word ov112_021EF300
_021EF034: .word ov112_021EF3F8
_021EF038: .word ov112_021EF310
	thumb_func_end ov112_021EEF68

	thumb_func_start ov112_021EF03C
ov112_021EF03C: ; 0x021EF03C
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, _021EF0FC ; =0x0001D764
	add r4, r5, r0
	ldr r0, [r4]
	cmp r0, #5
	bhi _021EF0EA
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EF058: ; jump table
	.short _021EF064 - _021EF058 - 2 ; case 0
	.short _021EF06A - _021EF058 - 2 ; case 1
	.short _021EF086 - _021EF058 - 2 ; case 2
	.short _021EF094 - _021EF058 - 2 ; case 3
	.short _021EF0B6 - _021EF058 - 2 ; case 4
	.short _021EF0D4 - _021EF058 - 2 ; case 5
_021EF064:
	mov r0, #1
	str r0, [r4]
	b _021EF0EA
_021EF06A:
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #2
	str r0, [r4]
	b _021EF0EA
_021EF086:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021EF0EA
	mov r0, #3
	str r0, [r4]
	b _021EF0EA
_021EF094:
	ldr r0, [r4, #4]
	bl sub_020935E0
	cmp r0, #2
	bne _021EF0A8
	mov r0, #0
	str r0, [r4, #0x14]
	mov r0, #4
	str r0, [r4]
	b _021EF0EA
_021EF0A8:
	cmp r0, #3
	bne _021EF0EA
	mov r0, #1
	str r0, [r4, #0x14]
	mov r0, #4
	str r0, [r4]
	b _021EF0EA
_021EF0B6:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #5
	str r0, [r4]
	b _021EF0EA
_021EF0D4:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021EF0EA
	add r0, r4, #0
	add r1, r5, #0
	bl ov112_021EF31C
	add sp, #0xc
	mov r0, #3
	pop {r4, r5, pc}
_021EF0EA:
	ldr r0, [r4, #4]
	bl sub_02093A40
	ldr r0, [r4, #8]
	bl ov112_021F050C
	mov r0, #2
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_021EF0FC: .word 0x0001D764
	thumb_func_end ov112_021EF03C

	thumb_func_start ov112_021EF100
ov112_021EF100: ; 0x021EF100
	push {r4, lr}
	ldr r1, _021EF14C ; =0x0001D764
	add r4, r0, #0
	mov r0, #0
	str r0, [r4, r1]
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	ldr r0, _021EF150 ; =0x0001D768
	ldr r0, [r4, r0]
	bl sub_02093354
	ldr r0, _021EF154 ; =0x0001D76C
	ldr r0, [r4, r0]
	bl ov112_021F051C
	bl OamManager_Free
	bl ObjCharTransfer_Destroy
	bl ObjPlttTransfer_Destroy
	ldr r0, [r4, #0x18]
	bl Heap_Free
	add r0, r4, #0
	bl ov112_021E7768
	ldr r0, _021EF158 ; =0x0001D778
	ldr r0, [r4, r0]
	cmp r0, #1
	bne _021EF144
	mov r0, #0
	b _021EF146
_021EF144:
	mov r0, #3
_021EF146:
	str r0, [r4, #4]
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021EF14C: .word 0x0001D764
_021EF150: .word 0x0001D768
_021EF154: .word 0x0001D76C
_021EF158: .word 0x0001D778
	thumb_func_end ov112_021EF100

	thumb_func_start ov112_021EF15C
ov112_021EF15C: ; 0x021EF15C
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _021EF178 ; =ov112_021FF0FC
	add r3, sp, #0
	mov r2, #5
_021EF166:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021EF166
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_021EF178: .word ov112_021FF0FC
	thumb_func_end ov112_021EF15C

	thumb_func_start ov112_021EF17C
ov112_021EF17C: ; 0x021EF17C
	push {r4, lr}
	sub sp, #0x10
	ldr r4, _021EF198 ; =ov112_021FF0DC
	add r3, sp, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EF198: .word ov112_021FF0DC
	thumb_func_end ov112_021EF17C

	thumb_func_start ov112_021EF19C
ov112_021EF19C: ; 0x021EF19C
	push {r4, lr}
	sub sp, #0x10
	ldr r4, _021EF1C8 ; =ov112_021FF0EC
	add r3, sp, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl ObjCharTransfer_Init
	mov r0, #0x14
	mov r1, #0x9a
	bl ObjPlttTransfer_Init
	bl ObjCharTransfer_ClearBuffers
	bl ObjPlttTransfer_Reset
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EF1C8: .word ov112_021FF0EC
	thumb_func_end ov112_021EF19C

	thumb_func_start ov112_021EF1CC
ov112_021EF1CC: ; 0x021EF1CC
	push {lr}
	sub sp, #0x14
	bl NNS_G2dInitOamManagerModule
	mov r0, #0
	str r0, [sp]
	mov r1, #0x7e
	str r1, [sp, #4]
	str r0, [sp, #8]
	mov r3, #0x20
	str r3, [sp, #0xc]
	mov r2, #0x9a
	str r2, [sp, #0x10]
	add r2, r0, #0
	bl OamManager_Create
	add sp, #0x14
	pop {pc}
	thumb_func_end ov112_021EF1CC

	thumb_func_start ov112_021EF1F0
ov112_021EF1F0: ; 0x021EF1F0
	push {r3, r4, r5, lr}
	add r5, r3, #0
	bl PCStorage_GetMonByIndexPair
	mov r1, #0xac
	mov r2, #0
	add r4, r0, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _021EF282
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl GetBoxMonData
	mov r1, #0
	str r0, [r5]
	add r0, r4, #0
	add r2, r1, #0
	bl GetBoxMonData
	str r0, [r5, #4]
	add r0, r4, #0
	mov r1, #0x4c
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r5, #8]
	add r0, r4, #0
	mov r1, #0x70
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r5, #0xa]
	add r0, r4, #0
	mov r1, #6
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r5, #0xc]
	mov r0, #0
	add r2, r5, #0
	strh r0, [r5, #0xe]
	add r0, r4, #0
	mov r1, #0x75
	add r2, #0x18
	bl GetBoxMonData
	add r0, r4, #0
	bl BoxMonIsShiny
	strh r0, [r5, #0x10]
	add r0, r4, #0
	mov r1, #0x6f
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r5, #0x12]
	add r0, r4, #0
	mov r1, #0xa1
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r5, #0x14]
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r5, #0x16]
	mov r0, #1
	pop {r3, r4, r5, pc}
_021EF282:
	mov r0, #0
	str r0, [r5]
	str r0, [r5, #4]
	strh r0, [r5, #8]
	strh r0, [r5, #0xa]
	strh r0, [r5, #0xc]
	strh r0, [r5, #0xe]
	strh r0, [r5, #0x10]
	strh r0, [r5, #0x12]
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov112_021EF1F0

	thumb_func_start ov112_021EF298
ov112_021EF298: ; 0x021EF298
	push {r3, r4, r5, lr}
	add r4, r3, #0
	bl PCStorage_GetMonByIndexPair
	mov r1, #0xac
	mov r2, #0
	add r5, r0, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _021EF2E6
	add r0, r5, #0
	mov r1, #5
	mov r2, #0
	bl GetBoxMonData
	str r0, [r4]
	mov r2, #0
	str r2, [r4, #4]
	add r0, r5, #0
	mov r1, #0x4c
	bl GetBoxMonData
	strh r0, [r4, #8]
	add r0, r5, #0
	mov r1, #0x70
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r4, #0xa]
	mov r0, #0
	strh r0, [r4, #0xc]
	strh r0, [r4, #0xe]
	strh r0, [r4, #0x10]
	strh r0, [r4, #0x12]
	strh r0, [r4, #0x14]
	strh r0, [r4, #0x16]
	mov r0, #1
	pop {r3, r4, r5, pc}
_021EF2E6:
	mov r0, #0
	str r0, [r4]
	str r0, [r4, #4]
	strh r0, [r4, #8]
	strh r0, [r4, #0xa]
	strh r0, [r4, #0xc]
	strh r0, [r4, #0xe]
	strh r0, [r4, #0x10]
	strh r0, [r4, #0x12]
	strh r0, [r4, #0x14]
	strh r0, [r4, #0x16]
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov112_021EF298

	thumb_func_start ov112_021EF300
ov112_021EF300: ; 0x021EF300
	add r3, r0, #0
	add r0, r1, #0
	add r1, r2, #0
	add r2, r3, #0
	ldr r3, _021EF30C ; =PCStorage_GetBoxName
	bx r3
	.balign 4, 0
_021EF30C: .word PCStorage_GetBoxName
	thumb_func_end ov112_021EF300

	thumb_func_start ov112_021EF310
ov112_021EF310: ; 0x021EF310
	ldr r3, _021EF318 ; =sub_02093594
	ldr r0, [r0, #4]
	bx r3
	nop
_021EF318: .word sub_02093594
	thumb_func_end ov112_021EF310
