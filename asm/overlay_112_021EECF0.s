#include "constants/pokemon.h"
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

	thumb_func_start ov112_021EF31C
ov112_021EF31C: ; 0x021EF31C
	push {r4, r5, r6, lr}
	sub sp, #0x30
	add r5, r0, #0
	ldr r0, [r5, #0x14]
	add r4, r1, #0
	cmp r0, #0
	bne _021EF3EA
	ldr r6, [r5, #0xc]
	ldr r0, [r4, #0x20]
	cmp r6, #NUM_BOXES
	bne _021EF38C
	bl SaveArray_Party_Get
	ldr r1, [r5, #0x10]
	bl Party_GetMonByIndex
	add r6, r0, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	strh r0, [r5, #0x18]
	add r0, r6, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r1, r5, #0
	add r1, #0x30
	strb r0, [r1]
	add r2, r5, #0
	add r0, r6, #0
	mov r1, #0x75
	add r2, #0x1a
	bl GetMonData
	add r0, r6, #0
	bl MonIsShiny
	add r1, r5, #0
	add r1, #0x31
	strb r0, [r1]
	add r0, r6, #0
	mov r1, #0x6f
	mov r2, #0
	bl GetMonData
	add r5, #0x32
	strb r0, [r5]
	ldr r0, _021EF3F0 ; =0x0001E42C
	mov r1, #0
	str r6, [r4, r0]
	add r0, r0, #4
	add sp, #0x30
	str r1, [r4, r0]
	pop {r4, r5, r6, pc}
_021EF38C:
	bl SaveArray_PCStorage_Get
	ldr r2, [r5, #0x10]
	add r1, r6, #0
	bl PCStorage_GetMonByIndexPair
	mov r1, #0xac
	mov r2, #0
	add r6, r0, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _021EF3B0
	ldr r0, _021EF3F4 ; =0x0001E430
	mov r1, #0
	str r6, [r4, r0]
	sub r0, r0, #4
	str r1, [r4, r0]
_021EF3B0:
	ldr r0, [r4, #0x20]
	bl SaveArray_PCStorage_Get
	ldr r1, [r5, #0xc]
	ldr r2, [r5, #0x10]
	add r3, sp, #0
	bl ov112_021EF1F0
	ldr r0, [sp]
	mov r2, #0xb
	strh r0, [r5, #0x18]
	add r0, sp, #0
	ldrh r1, [r0, #0xa]
	add r0, r5, #0
	add r0, #0x30
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x1a
	add r1, sp, #0x18
	bl CopyU16StringArrayN
	add r0, r5, #0
	add r1, sp, #0
	ldrh r2, [r1, #0x10]
	add r0, #0x31
	add r5, #0x32
	strb r2, [r0]
	ldrh r0, [r1, #0x12]
	strb r0, [r5]
_021EF3EA:
	add sp, #0x30
	pop {r4, r5, r6, pc}
	nop
_021EF3F0: .word 0x0001E42C
_021EF3F4: .word 0x0001E430
	thumb_func_end ov112_021EF31C

	thumb_func_start ov112_021EF3F8
ov112_021EF3F8: ; 0x021EF3F8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x60
	add r5, r0, #0
	ldr r0, _021EF564 ; =0x0001D764
	add r4, r1, #0
	add r0, r2, r0
	str r0, [sp]
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EF412
	cmp r4, r0
	bne _021EF414
_021EF412:
	b _021EF550
_021EF414:
	mov r1, #2
	add r0, sp, #0x34
	strb r1, [r0, #9]
	cmp r5, #NUM_BOXES
	ldr r0, [r2, #0x20]
	bne _021EF4D6
	bl SaveArray_Party_Get
	add r1, r4, #0
	bl Party_GetMonByIndex
	mov r1, #0
	add r7, r0, #0
	add r2, r1, #0
	bl GetMonData
	str r0, [sp, #0x34]
	add r0, r7, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	add r1, sp, #4
	strh r0, [r1, #0x34]
	add r0, r7, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r1, sp, #0x34
	strb r0, [r1, #7]
	add r2, sp, #0x3c
	add r0, r7, #0
	mov r1, #0x75
	add r2, #2
	bl GetMonData
	add r0, r7, #0
	bl MonIsShiny
	add r1, sp, #0x34
	strb r0, [r1, #6]
	add r0, r7, #0
	mov r1, #0x6f
	mov r2, #0
	bl GetMonData
	add r1, sp, #0x34
	strb r0, [r1, #8]
	add r0, r7, #0
	mov r1, #0xb
	mov r2, #0
	bl GetMonData
	mov r4, #0
	mov r3, #1
	add r5, r0, #0
	add r1, r4, #0
	add r2, sp, #0x34
	add r0, r3, #0
_021EF48C:
	add r6, r5, #0
	asr r6, r4
	tst r6, r0
	beq _021EF49C
	add r6, r2, r4
	add r6, #0x20
	strb r3, [r6]
	b _021EF4A2
_021EF49C:
	add r6, r2, r4
	add r6, #0x20
	strb r1, [r6]
_021EF4A2:
	add r4, r4, #1
	lsl r4, r4, #0x18
	lsr r4, r4, #0x18
	cmp r4, #6
	blo _021EF48C
	add r0, r7, #0
	mov r1, #6
	mov r2, #0
	bl GetMonData
	add r1, sp, #0x34
	strh r0, [r1, #0x26]
	add r0, r7, #0
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	add r1, sp, #0x54
	strb r0, [r1, #8]
	ldr r0, [sp]
	add r1, sp, #0x34
	ldr r0, [r0, #8]
	bl ov112_021F04DC
	add sp, #0x60
	pop {r3, r4, r5, r6, r7, pc}
_021EF4D6:
	bl SaveArray_PCStorage_Get
	add r1, r5, #0
	add r2, r4, #0
	add r3, sp, #4
	bl ov112_021EF1F0
	ldr r0, [sp, #8]
	ldr r1, [sp, #4]
	str r0, [sp, #0x34]
	add r0, sp, #4
	strh r1, [r0, #0x34]
	ldrh r1, [r0, #0xa]
	add r0, sp, #0x34
	mov r2, #0xb
	strb r1, [r0, #7]
	add r0, sp, #0x3c
	add r0, #2
	add r1, sp, #0x1c
	bl CopyU16StringArrayN
	add r0, sp, #4
	ldrh r1, [r0, #0x10]
	add r2, sp, #0x34
	mov r5, #0
	strb r1, [r2, #6]
	ldrh r1, [r0, #0x12]
	mov r3, #1
	strb r1, [r2, #8]
	ldrh r4, [r0, #0x16]
	add r1, r5, #0
	add r0, r3, #0
_021EF516:
	add r6, r4, #0
	asr r6, r5
	tst r6, r0
	beq _021EF526
	add r6, r2, r5
	add r6, #0x20
	strb r3, [r6]
	b _021EF52C
_021EF526:
	add r6, r2, r5
	add r6, #0x20
	strb r1, [r6]
_021EF52C:
	add r5, r5, #1
	lsl r5, r5, #0x18
	lsr r5, r5, #0x18
	cmp r5, #6
	blo _021EF516
	add r0, sp, #4
	ldrh r2, [r0, #0xc]
	add r1, sp, #0x34
	strh r2, [r1, #0x26]
	ldrh r2, [r0, #0x14]
	add r0, sp, #0x54
	strb r2, [r0, #8]
	ldr r0, [sp]
	ldr r0, [r0, #8]
	bl ov112_021F04DC
	add sp, #0x60
	pop {r3, r4, r5, r6, r7, pc}
_021EF550:
	mov r0, #0
	add r1, sp, #0x34
	strb r0, [r1, #9]
	ldr r0, [sp]
	ldr r0, [r0, #8]
	bl ov112_021F04DC
	add sp, #0x60
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF564: .word 0x0001D764
	thumb_func_end ov112_021EF3F8

	thumb_func_start ov112_021EF568
ov112_021EF568: ; 0x021EF568
	push {lr}
	sub sp, #0xc
	ldr r2, [r0, #0x20]
	ldr r1, _021EF5A0 ; =0x0001D750
	ldr r3, _021EF5A4 ; =0x00007FFF
	str r2, [r0, r1]
	ldr r2, _021EF5A8 ; =0x00009DFC
	add r1, r1, #4
	add r2, r0, r2
	str r2, [r0, r1]
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0
	mov r1, #0x10
	bl GF_SndStartFadeOutBGM
	mov r0, #2
	add sp, #0xc
	pop {pc}
	.balign 4, 0
_021EF5A0: .word 0x0001D750
_021EF5A4: .word 0x00007FFF
_021EF5A8: .word 0x00009DFC
	thumb_func_end ov112_021EF568

	thumb_func_start ov112_021EF5AC
ov112_021EF5AC: ; 0x021EF5AC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #8]
	cmp r0, #3
	bhi _021EF61C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EF5C2: ; jump table
	.short _021EF5CA - _021EF5C2 - 2 ; case 0
	.short _021EF5EE - _021EF5C2 - 2 ; case 1
	.short _021EF602 - _021EF5C2 - 2 ; case 2
	.short _021EF618 - _021EF5C2 - 2 ; case 3
_021EF5CA:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EF61C
	add r0, r4, #0
	bl ov112_021E77E4
	ldr r0, _021EF620 ; =0x00009DFC
	add r0, r4, r0
	bl ov112_021F31D8
	cmp r0, #0
	beq _021EF5E8
	mov r0, #3
	pop {r4, pc}
_021EF5E8:
	mov r0, #1
	str r0, [r4, #8]
	b _021EF61C
_021EF5EE:
	ldr r1, _021EF624 ; =0x0001D750
	ldr r0, _021EF628 ; =ov112_021FF124
	add r1, r4, r1
	mov r2, #0x9a
	bl OverlayManager_New
	str r0, [r4, #0x1c]
	mov r0, #2
	str r0, [r4, #8]
	b _021EF61C
_021EF602:
	ldr r0, [r4, #0x1c]
	bl OverlayManager_Run
	cmp r0, #0
	beq _021EF61C
	ldr r0, [r4, #0x1c]
	bl OverlayManager_Delete
	mov r0, #3
	str r0, [r4, #8]
	b _021EF61C
_021EF618:
	mov r0, #3
	pop {r4, pc}
_021EF61C:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EF620: .word 0x00009DFC
_021EF624: .word 0x0001D750
_021EF628: .word ov112_021FF124
	thumb_func_end ov112_021EF5AC

	thumb_func_start ov112_021EF62C
ov112_021EF62C: ; 0x021EF62C
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021E7768
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #0xa
	str r0, [r4, #4]
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov112_021EF62C

	thumb_func_start ov112_021EF640
ov112_021EF640: ; 0x021EF640
	mov r0, #2
	bx lr
	thumb_func_end ov112_021EF640

	thumb_func_start ov112_021EF644
ov112_021EF644: ; 0x021EF644
	ldr r1, _021EF65C ; =gSystem
	ldr r2, [r1, #0x48]
	mov r1, #0x80
	tst r1, r2
	beq _021EF656
	mov r1, #3
	str r1, [r0, #4]
	add r0, r1, #0
	bx lr
_021EF656:
	mov r0, #2
	bx lr
	nop
_021EF65C: .word gSystem
	thumb_func_end ov112_021EF644

	thumb_func_start ov112_021EF660
ov112_021EF660: ; 0x021EF660
	mov r0, #1
	bx lr
	thumb_func_end ov112_021EF660

	thumb_func_start ov112_021EF664
ov112_021EF664: ; 0x021EF664
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #4
	bl ov112_021E9A78
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EF664

	thumb_func_start ov112_021EF67C
ov112_021EF67C: ; 0x021EF67C
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	lsl r2, r1, #2
	ldr r1, _021EF69C ; =ov112_021FF924
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4, #8]
	cmp r0, #0x25
	bne _021EF698
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #3
	pop {r4, pc}
_021EF698:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EF69C: .word ov112_021FF924
	thumb_func_end ov112_021EF67C

	thumb_func_start ov112_021EF6A0
ov112_021EF6A0: ; 0x021EF6A0
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
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #6
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r0, #1
	add sp, #0x10
	pop {r4, pc}
	thumb_func_end ov112_021EF6A0

	thumb_func_start ov112_021EF700
ov112_021EF700: ; 0x021EF700
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
	ldr r0, [r4, #0x10]
	cmp r0, #2
	bne _021EF72C
	add sp, #0x10
	mov r0, #0x16
	pop {r4, pc}
_021EF72C:
	cmp r0, #3
	bne _021EF736
	add sp, #0x10
	mov r0, #0x1e
	pop {r4, pc}
_021EF736:
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xf
	bl ov112_021E7CA4
	ldr r2, _021EF754 ; =0x0001E494
	add r0, r4, #0
	ldr r2, [r4, r2]
	mov r1, #1
	mov r3, #0
	bl ov112_021E9FD8
	mov r0, #1
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EF754: .word 0x0001E494
	thumb_func_end ov112_021EF700

	thumb_func_start ov112_021EF758
ov112_021EF758: ; 0x021EF758
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, _021EF8A0 ; =0x0001E440
	mov r4, #0
	ldr r0, [r5, r0]
	bl sub_02032718
	add r2, r0, #0
	ldr r0, _021EF8A4 ; =0x0001E448
	lsl r2, r2, #0x18
	ldr r0, [r5, r0]
	mov r1, #2
	lsr r2, r2, #0x18
	bl BufferPokewalkerCourseName
	ldr r0, _021EF8A8 ; =0x000010F0
	ldr r1, [r5, r0]
	ldr r0, _021EF8AC ; =0x0001D758
	ldr r0, [r5, r0]
	cmp r1, r0
	bls _021EF786
	sub r4, r1, r0
_021EF786:
	ldr r0, _021EF8A0 ; =0x0001E440
	add r1, sp, #0x10
	ldr r0, [r5, r0]
	add r2, sp, #0xc
	bl sub_02032674
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021EF8A4 ; =0x0001E448
	mov r1, #5
	ldr r0, [r5, r0]
	add r2, r4, #0
	mov r3, #7
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, _021EF8B0 ; =0x00009D7A
	ldr r0, _021EF8A4 ; =0x0001E448
	ldrh r2, [r5, r2]
	ldr r0, [r5, r0]
	mov r1, #3
	mov r3, #7
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021EF8A4 ; =0x0001E448
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	mov r1, #6
	mov r3, #7
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021EF8A4 ; =0x0001E448
	mov r1, #7
	ldr r0, [r5, r0]
	ldr r2, [sp, #0xc]
	add r3, r1, #0
	bl BufferIntegerAsString
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #2
	mov r2, #0x38
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #3
	mov r2, #0x39
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #4
	mov r2, #0x3a
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp]
	ldr r2, _021EF8B4 ; =0x0001E4B4
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #5
	mov r3, #0
	bl ov112_021E9FA4
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x3c
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp]
	ldr r2, _021EF8B8 ; =0x0001E4BC
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #7
	mov r3, #0
	bl ov112_021E9FA4
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #8
	mov r2, #0x3e
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	add r0, r5, #0
	mov r1, #9
	bl ov112_021EA670
	add r0, r5, #0
	mov r1, #9
	mov r2, #0xd2
	mov r3, #0x40
	bl ov112_021EA6B8
	ldr r3, _021EF8BC ; =0x00009D44
	add r0, r5, #0
	ldrh r2, [r5, r3]
	add r3, #0xd
	ldrb r3, [r5, r3]
	mov r1, #0
	lsl r3, r3, #0x1b
	lsr r3, r3, #0x1b
	bl ov112_021EAB78
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
	add sp, #0x14
	pop {r4, r5, pc}
	nop
_021EF8A0: .word 0x0001E440
_021EF8A4: .word 0x0001E448
_021EF8A8: .word 0x000010F0
_021EF8AC: .word 0x0001D758
_021EF8B0: .word 0x00009D7A
_021EF8B4: .word 0x0001E4B4
_021EF8B8: .word 0x0001E4BC
_021EF8BC: .word 0x00009D44
	thumb_func_end ov112_021EF758

	thumb_func_start ov112_021EF8C0
ov112_021EF8C0: ; 0x021EF8C0
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EF8CE
	mov r0, #3
	pop {r3, pc}
_021EF8CE:
	mov r0, #2
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EF8C0

	thumb_func_start ov112_021EF8D4
ov112_021EF8D4: ; 0x021EF8D4
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, _021EF940 ; =0x0001E440
	ldr r0, [r5, r0]
	bl sub_02032718
	add r2, r0, #0
	ldr r0, _021EF944 ; =0x0001E448
	lsl r2, r2, #0x18
	ldr r0, [r5, r0]
	mov r1, #1
	lsr r2, r2, #0x18
	bl BufferPokewalkerCourseName
	mov r0, #0xc
	mov r1, #0x9a
	bl String_New
	ldr r1, _021EF948 ; =0x00009D54
	mov r2, #0xb
	add r1, r5, r1
	add r4, r0, #0
	bl CopyU16ArrayToStringN
	mov r1, #1
	ldr r0, _021EF94C ; =0x00001090
	str r1, [sp]
	ldr r0, [r5, r0]
	ldr r3, _021EF950 ; =0x00009D51
	str r0, [sp, #4]
	ldrb r3, [r5, r3]
	ldr r0, _021EF944 ; =0x0001E448
	add r2, r4, #0
	lsl r3, r3, #0x19
	ldr r0, [r5, r0]
	lsr r3, r3, #0x1e
	bl BufferString
	add r0, r4, #0
	bl String_Delete
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x2c
	bl ov112_021EA08C
	ldr r1, _021EF954 ; =0x0001E524
	str r0, [r5, r1]
	mov r0, #4
	str r0, [r5, #0xc]
	mov r0, #0x23
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF940: .word 0x0001E440
_021EF944: .word 0x0001E448
_021EF948: .word 0x00009D54
_021EF94C: .word 0x00001090
_021EF950: .word 0x00009D51
_021EF954: .word 0x0001E524
	thumb_func_end ov112_021EF8D4

	thumb_func_start ov112_021EF958
ov112_021EF958: ; 0x021EF958
	push {r4, lr}
	ldr r1, _021EF98C ; =0x0001F374
	add r4, r0, #0
	ldrh r1, [r4, r1]
	cmp r1, #0
	bne _021EF968
	mov r0, #5
	pop {r4, pc}
_021EF968:
	mov r1, #0
	mov r2, #0x34
	bl ov112_021EA08C
	ldr r1, _021EF990 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #5
	str r0, [r4, #0xc]
	mov r0, #0x4a
	lsl r0, r0, #4
	bl PlayFanfare
	ldr r0, _021EF98C ; =0x0001F374
	mov r1, #0
	strh r1, [r4, r0]
	mov r0, #0x23
	pop {r4, pc}
	nop
_021EF98C: .word 0x0001F374
_021EF990: .word 0x0001E524
	thumb_func_end ov112_021EF958

	thumb_func_start ov112_021EF994
ov112_021EF994: ; 0x021EF994
	push {r4, lr}
	ldr r1, _021EF9C8 ; =0x00009D7A
	add r4, r0, #0
	ldrh r1, [r4, r1]
	cmp r1, #0
	bne _021EF9AA
	mov r1, #0
	mov r2, #0x2e
	bl ov112_021EA08C
	b _021EF9BA
_021EF9AA:
	ldr r0, _021EF9CC ; =0x000004A1
	bl PlayFanfare
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x2d
	bl ov112_021EA08C
_021EF9BA:
	ldr r1, _021EF9D0 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #6
	str r0, [r4, #0xc]
	mov r0, #0x23
	pop {r4, pc}
	nop
_021EF9C8: .word 0x00009D7A
_021EF9CC: .word 0x000004A1
_021EF9D0: .word 0x0001E524
	thumb_func_end ov112_021EF994

	thumb_func_start ov112_021EF9D4
ov112_021EF9D4: ; 0x021EF9D4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EFA10 ; =0x0001EC78
	ldr r2, [r4, r0]
	cmp r2, #0
	beq _021EFA0A
	ldr r0, _021EFA14 ; =0x0001E448
	lsl r2, r2, #0x18
	ldr r0, [r4, r0]
	mov r1, #4
	lsr r2, r2, #0x18
	bl BufferPokewalkerCourseName
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x30
	bl ov112_021EA08C
	ldr r1, _021EFA18 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #7
	str r0, [r4, #0xc]
	ldr r0, _021EFA10 ; =0x0001EC78
	mov r1, #0
	str r1, [r4, r0]
	mov r0, #0x23
	pop {r4, pc}
_021EFA0A:
	mov r0, #8
	pop {r4, pc}
	nop
_021EFA10: .word 0x0001EC78
_021EFA14: .word 0x0001E448
_021EFA18: .word 0x0001E524
	thumb_func_end ov112_021EF9D4

	thumb_func_start ov112_021EFA1C
ov112_021EFA1C: ; 0x021EFA1C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EFA3C ; =0x000004A2
	bl PlayFanfare
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x37
	bl ov112_021EA08C
	ldr r1, _021EFA40 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #8
	str r0, [r4, #0xc]
	mov r0, #0x23
	pop {r4, pc}
	.balign 4, 0
_021EFA3C: .word 0x000004A2
_021EFA40: .word 0x0001E524
	thumb_func_end ov112_021EFA1C

	thumb_func_start ov112_021EFA44
ov112_021EFA44: ; 0x021EFA44
	push {r4, lr}
	ldr r2, _021EFA6C ; =0x0001F376
	add r4, r0, #0
	ldrh r1, [r4, r2]
	cmp r1, #0
	beq _021EFA66
	mov r1, #0
	strh r1, [r4, r2]
	mov r2, #0x35
	bl ov112_021EA08C
	ldr r1, _021EFA70 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #9
	str r0, [r4, #0xc]
	mov r0, #0x23
	pop {r4, pc}
_021EFA66:
	mov r0, #0xa
	pop {r4, pc}
	nop
_021EFA6C: .word 0x0001F376
_021EFA70: .word 0x0001E524
	thumb_func_end ov112_021EFA44

	thumb_func_start ov112_021EFA74
ov112_021EFA74: ; 0x021EFA74
	push {r4, lr}
	mov r1, #0
	mov r2, #0x36
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EFA94 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0xa
	str r0, [r4, #0xc]
	ldr r0, _021EFA98 ; =0x000004A2
	bl PlayFanfare
	mov r0, #0x23
	pop {r4, pc}
	nop
_021EFA94: .word 0x0001E524
_021EFA98: .word 0x000004A2
	thumb_func_end ov112_021EFA74

	thumb_func_start ov112_021EFA9C
ov112_021EFA9C: ; 0x021EFA9C
	push {lr}
	sub sp, #0xc
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
	mov r0, #0xb
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021EFA9C

	thumb_func_start ov112_021EFAC0
ov112_021EFAC0: ; 0x021EFAC0
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EFACE
	mov r0, #0xc
	pop {r3, pc}
_021EFACE:
	mov r0, #0xb
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EFAC0

	thumb_func_start ov112_021EFAD4
ov112_021EFAD4: ; 0x021EFAD4
	push {r4, r5}
	mov r2, #0
	ldr r3, _021EFB10 ; =0x000001ED
	add r5, r2, #0
_021EFADC:
	ldrh r4, [r0, #0xc]
	cmp r4, #0
	beq _021EFAE8
	cmp r4, r3
	bhi _021EFAE8
	add r2, r2, #1
_021EFAE8:
	add r5, r5, #1
	add r0, #0x10
	cmp r5, #3
	blt _021EFADC
	ldrb r0, [r1]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1f
	beq _021EFB0A
	mov r0, #0x91
	lsl r0, r0, #2
	ldrh r1, [r1, r0]
	cmp r1, #0
	beq _021EFB0A
	sub r0, #0x57
	cmp r1, r0
	bhi _021EFB0A
	add r2, r2, #1
_021EFB0A:
	add r0, r2, #0
	pop {r4, r5}
	bx lr
	.balign 4, 0
_021EFB10: .word 0x000001ED
	thumb_func_end ov112_021EFAD4

	thumb_func_start ov112_021EFB14
ov112_021EFB14: ; 0x021EFB14
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r1, #4
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #5
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EFC84 ; =0x00009D70
	ldr r1, _021EFC88 ; =0x0000AABC
	add r0, r5, r0
	add r1, r5, r1
	bl ov112_021EFAD4
	cmp r0, #0
	bne _021EFB60
	add r0, r5, #0
	mov r1, #9
	bl ov112_021EA688
	add sp, #0x10
	mov r0, #0x11
	pop {r3, r4, r5, r6, r7, pc}
_021EFB60:
	add r0, r5, #0
	mov r1, #2
	mov r2, #0xf
	bl ov112_021E7CA4
	ldr r2, _021EFC8C ; =0x0001E4A0
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #1
	mov r3, #0
	bl ov112_021E9FD8
	ldr r2, _021EFC8C ; =0x0001E4A0
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #1
	mov r3, #0
	bl ov112_021E9FD8
	mov r4, #0
_021EFB88:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #9
	bl ov112_021EA688
	add r4, r4, #1
	cmp r4, #4
	blt _021EFB88
	add r0, r5, #0
	mov r1, #9
	mov r2, #0x28
	mov r3, #0x40
	bl ov112_021EA6B8
	add r0, r5, #0
	mov r1, #0xa
	mov r2, #0x90
	mov r3, #0x40
	bl ov112_021EA6B8
	add r0, r5, #0
	mov r1, #0xb
	mov r2, #0x28
	mov r3, #0x60
	bl ov112_021EA6B8
	add r0, r5, #0
	mov r1, #0xc
	mov r2, #0x90
	mov r3, #0x60
	bl ov112_021EA6B8
	ldr r0, _021EFC90 ; =0x00009D89
	mov r4, #0
	add r6, r5, #0
	add r7, r5, r0
_021EFBD0:
	ldr r0, _021EFC94 ; =0x00009D7C
	ldrh r0, [r6, r0]
	cmp r0, #0
	beq _021EFC14
	add r1, r4, #0
	add r0, r5, #0
	add r1, #9
	bl ov112_021EA670
	ldr r2, _021EFC94 ; =0x00009D7C
	ldr r0, _021EFC98 ; =0x0001E448
	add r1, r4, #0
	ldrh r2, [r6, r2]
	ldr r0, [r5, r0]
	add r1, #8
	bl BufferSpeciesName
	add r2, r4, #0
	mov r3, #0xc1
	add r0, r5, #0
	add r1, r4, #3
	add r2, #0x43
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	ldr r2, _021EFC94 ; =0x00009D7C
	ldrb r3, [r7]
	ldrh r2, [r6, r2]
	add r0, r5, #0
	lsl r3, r3, #0x1b
	add r1, r4, #0
	lsr r3, r3, #0x1b
	bl ov112_021EAB78
_021EFC14:
	add r4, r4, #1
	add r6, #0x10
	add r7, #0x10
	cmp r4, #3
	blt _021EFBD0
	ldr r0, _021EFC88 ; =0x0000AABC
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1f
	beq _021EFC66
	mov r0, #0xad
	lsl r0, r0, #8
	add r4, r5, r0
	ldrh r0, [r4]
	cmp r0, #0
	beq _021EFC66
	add r0, r5, #0
	mov r1, #0xc
	bl ov112_021EA670
	ldr r0, _021EFC98 ; =0x0001E448
	ldrh r2, [r4]
	ldr r0, [r5, r0]
	mov r1, #0xb
	bl BufferSpeciesName
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x46
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	ldrb r3, [r4, #0xd]
	ldrh r2, [r4]
	add r0, r5, #0
	lsl r3, r3, #0x1b
	mov r1, #3
	lsr r3, r3, #0x1b
	bl ov112_021EAB78
_021EFC66:
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
	mov r0, #0xd
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EFC84: .word 0x00009D70
_021EFC88: .word 0x0000AABC
_021EFC8C: .word 0x0001E4A0
_021EFC90: .word 0x00009D89
_021EFC94: .word 0x00009D7C
_021EFC98: .word 0x0001E448
	thumb_func_end ov112_021EFB14

	thumb_func_start ov112_021EFC9C
ov112_021EFC9C: ; 0x021EFC9C
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EFCAA
	mov r0, #0xe
	pop {r3, pc}
_021EFCAA:
	mov r0, #0xd
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EFC9C

	thumb_func_start ov112_021EFCB0
ov112_021EFCB0: ; 0x021EFCB0
	push {r4, lr}
	mov r1, #0
	mov r2, #0x31
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EFCD0 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0xf
	str r0, [r4, #0xc]
	ldr r0, _021EFCD4 ; =0x000004A2
	bl PlayFanfare
	mov r0, #0x23
	pop {r4, pc}
	nop
_021EFCD0: .word 0x0001E524
_021EFCD4: .word 0x000004A2
	thumb_func_end ov112_021EFCB0

	thumb_func_start ov112_021EFCD8
ov112_021EFCD8: ; 0x021EFCD8
	push {lr}
	sub sp, #0xc
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
	mov r0, #0x10
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021EFCD8

	thumb_func_start ov112_021EFCFC
ov112_021EFCFC: ; 0x021EFCFC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EFD1E
	mov r4, #0
_021EFD0A:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #9
	bl ov112_021EA688
	add r4, r4, #1
	cmp r4, #4
	blt _021EFD0A
	mov r0, #0x11
	pop {r3, r4, r5, pc}
_021EFD1E:
	mov r0, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov112_021EFCFC

	thumb_func_start ov112_021EFD24
ov112_021EFD24: ; 0x021EFD24
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r6, r1, #0
	mov r4, #0
	add r1, r5, #0
_021EFD2E:
	ldrh r0, [r1]
	cmp r0, #0
	beq _021EFD3C
	add r4, r4, #1
	add r1, r1, #2
	cmp r4, #0xe
	blt _021EFD2E
_021EFD3C:
	cmp r4, #0xe
	blt _021EFD44
	bl GF_AssertFail
_021EFD44:
	lsl r0, r4, #1
	strh r6, [r5, r0]
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov112_021EFD24

	thumb_func_start ov112_021EFD4C
ov112_021EFD4C: ; 0x021EFD4C
	push {r4, r5}
	mov r1, #0
	ldr r2, _021EFD98 ; =0x00009DAC
	add r4, r1, #0
	add r5, r0, #0
_021EFD56:
	ldrh r3, [r5, r2]
	cmp r3, #0
	beq _021EFD5E
	add r1, r1, #1
_021EFD5E:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #3
	blt _021EFD56
	ldr r2, _021EFD9C ; =0x00009DB8
	mov r5, #0
	add r4, r0, #0
_021EFD6C:
	ldrh r3, [r4, r2]
	cmp r3, #0
	beq _021EFD74
	add r1, r1, #1
_021EFD74:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #0xa
	blt _021EFD6C
	ldr r2, _021EFDA0 ; =0x0000AABC
	ldrb r2, [r0, r2]
	lsl r2, r2, #0x19
	lsr r2, r2, #0x1f
	beq _021EFD90
	ldr r2, _021EFDA4 ; =0x0000B002
	ldrh r0, [r0, r2]
	cmp r0, #0
	beq _021EFD90
	add r1, r1, #1
_021EFD90:
	add r0, r1, #0
	pop {r4, r5}
	bx lr
	nop
_021EFD98: .word 0x00009DAC
_021EFD9C: .word 0x00009DB8
_021EFDA0: .word 0x0000AABC
_021EFDA4: .word 0x0000B002
	thumb_func_end ov112_021EFD4C

	thumb_func_start ov112_021EFDA8
ov112_021EFDA8: ; 0x021EFDA8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	add r7, r0, #0
	mov r1, #5
	bl ov112_021E9C10
	add r0, r7, #0
	mov r1, #6
	bl ov112_021E9A78
	add r0, r7, #0
	bl ov112_021EFD4C
	cmp r0, #0
	bne _021EFDCC
	add sp, #0x2c
	mov r0, #0x24
	pop {r4, r5, r6, r7, pc}
_021EFDCC:
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r7, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	add r0, r7, #0
	mov r1, #2
	mov r2, #0xf
	bl ov112_021E7CA4
	ldr r2, _021EFEB8 ; =0x0001E4A4
	add r0, r7, #0
	ldr r2, [r7, r2]
	mov r1, #1
	mov r3, #0
	bl ov112_021E9FD8
	mov r0, #0
	add r1, sp, #0x10
	mov r2, #0x1c
	bl MIi_CpuClearFast
	ldr r6, _021EFEBC ; =0x00009DAC
	mov r4, #0
	add r5, r7, #0
_021EFE0E:
	ldrh r1, [r5, r6]
	add r0, sp, #0x10
	bl ov112_021EFD24
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #3
	blt _021EFE0E
	ldr r6, _021EFEC0 ; =0x00009DB8
	mov r5, #0
	add r4, r7, #0
_021EFE24:
	ldrh r1, [r4, r6]
	add r0, sp, #0x10
	bl ov112_021EFD24
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #0xa
	blt _021EFE24
	ldr r0, _021EFEC4 ; =0x0000AABC
	ldrb r0, [r7, r0]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1f
	beq _021EFE60
	ldr r1, _021EFEC8 ; =0x0000B002
	add r0, sp, #0x10
	ldrh r1, [r7, r1]
	bl ov112_021EFD24
	ldr r1, _021EFEC4 ; =0x0000AABC
	ldr r2, _021EFECC ; =0x000006C8
	mov r0, #0
	add r1, r7, r1
	bl MIi_CpuClearFast
	ldr r1, _021EFED0 ; =0x00009D70
	ldr r2, _021EFED4 ; =0x00000D4C
	mov r0, #0
	add r1, r7, r1
	bl MIi_CpuClearFast
_021EFE60:
	mov r0, #0x13
	mov r1, #0x9a
	bl String_New
	add r6, r0, #0
	mov r5, #0
	add r4, sp, #0x10
_021EFE6E:
	ldrh r1, [r4]
	cmp r1, #0
	beq _021EFE96
	add r0, r6, #0
	mov r2, #0x9a
	bl GetItemNameIntoString
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp]
	add r0, r7, #0
	add r1, r5, #2
	add r2, r6, #0
	mov r3, #0
	bl ov112_021E9FA4
	add r5, r5, #1
	add r4, r4, #2
	cmp r5, #0xe
	blt _021EFE6E
_021EFE96:
	add r0, r6, #0
	bl String_Delete
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
	mov r0, #0x12
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021EFEB8: .word 0x0001E4A4
_021EFEBC: .word 0x00009DAC
_021EFEC0: .word 0x00009DB8
_021EFEC4: .word 0x0000AABC
_021EFEC8: .word 0x0000B002
_021EFECC: .word 0x000006C8
_021EFED0: .word 0x00009D70
_021EFED4: .word 0x00000D4C
	thumb_func_end ov112_021EFDA8

	thumb_func_start ov112_021EFED8
ov112_021EFED8: ; 0x021EFED8
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EFEE6
	mov r0, #0x13
	pop {r3, pc}
_021EFEE6:
	mov r0, #0x12
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EFED8

	thumb_func_start ov112_021EFEEC
ov112_021EFEEC: ; 0x021EFEEC
	push {r4, lr}
	mov r1, #0
	mov r2, #0x32
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EFF0C ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x14
	str r0, [r4, #0xc]
	ldr r0, _021EFF10 ; =0x000004A2
	bl PlayFanfare
	mov r0, #0x23
	pop {r4, pc}
	nop
_021EFF0C: .word 0x0001E524
_021EFF10: .word 0x000004A2
	thumb_func_end ov112_021EFEEC

	thumb_func_start ov112_021EFF14
ov112_021EFF14: ; 0x021EFF14
	push {lr}
	sub sp, #0xc
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
	mov r0, #0x15
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021EFF14

	thumb_func_start ov112_021EFF38
ov112_021EFF38: ; 0x021EFF38
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EFF46
	mov r0, #0x24
	pop {r3, pc}
_021EFF46:
	mov r0, #0x15
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EFF38

	thumb_func_start ov112_021EFF4C
ov112_021EFF4C: ; 0x021EFF4C
	push {lr}
	sub sp, #0xc
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
	mov r0, #0x17
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021EFF4C

	thumb_func_start ov112_021EFF70
ov112_021EFF70: ; 0x021EFF70
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EFF7E
	mov r0, #0x18
	pop {r3, pc}
_021EFF7E:
	mov r0, #0x17
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EFF70

	thumb_func_start ov112_021EFF84
ov112_021EFF84: ; 0x021EFF84
	push {r3, r4, r5, lr}
	sub sp, #0x18
	mov r4, #0
	add r5, r0, #0
	str r4, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r2, r4, #0
	add r3, r4, #0
	bl FillBgTilemapRect
	add r0, r5, #0
	mov r1, #2
	mov r2, #0xf
	bl ov112_021E7CA4
	ldr r2, _021F00AC ; =0x0001E498
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #1
	add r3, r4, #0
	bl ov112_021E9FD8
	ldr r0, _021F00B0 ; =0x0001E440
	ldr r0, [r5, r0]
	bl sub_02032718
	add r2, r0, #0
	ldr r0, _021F00B4 ; =0x0001E448
	lsl r2, r2, #0x18
	ldr r0, [r5, r0]
	mov r1, #2
	lsr r2, r2, #0x18
	bl BufferPokewalkerCourseName
	ldr r0, _021F00B8 ; =0x000010F0
	ldr r1, [r5, r0]
	ldr r0, _021F00BC ; =0x0001D758
	ldr r0, [r5, r0]
	cmp r1, r0
	bls _021EFFE4
	sub r4, r1, r0
_021EFFE4:
	ldr r0, _021F00B0 ; =0x0001E440
	add r1, sp, #0x14
	ldr r0, [r5, r0]
	add r2, sp, #0x10
	bl sub_02032674
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021F00B4 ; =0x0001E448
	mov r1, #5
	ldr r0, [r5, r0]
	add r2, r4, #0
	mov r3, #7
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, _021F00C0 ; =0x00009D7A
	ldr r0, _021F00B4 ; =0x0001E448
	ldrh r2, [r5, r2]
	ldr r0, [r5, r0]
	mov r1, #3
	mov r3, #5
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021F00B4 ; =0x0001E448
	ldr r2, [sp, #0x14]
	ldr r0, [r5, r0]
	mov r1, #6
	mov r3, #7
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021F00B4 ; =0x0001E448
	mov r1, #7
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x10]
	add r3, r1, #0
	bl BufferIntegerAsString
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp]
	ldr r2, _021F00C4 ; =0x0001E4B4
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #5
	mov r3, #0
	bl ov112_021E9FA4
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x3c
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp]
	ldr r2, _021F00C8 ; =0x0001E4BC
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #7
	mov r3, #0
	bl ov112_021E9FA4
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #8
	mov r2, #0x3e
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
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
	mov r0, #0x19
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_021F00AC: .word 0x0001E498
_021F00B0: .word 0x0001E440
_021F00B4: .word 0x0001E448
_021F00B8: .word 0x000010F0
_021F00BC: .word 0x0001D758
_021F00C0: .word 0x00009D7A
_021F00C4: .word 0x0001E4B4
_021F00C8: .word 0x0001E4BC
	thumb_func_end ov112_021EFF84

	thumb_func_start ov112_021F00CC
ov112_021F00CC: ; 0x021F00CC
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021F00DA
	mov r0, #0x1a
	pop {r3, pc}
_021F00DA:
	mov r0, #0x19
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021F00CC

	thumb_func_start ov112_021F00E0
ov112_021F00E0: ; 0x021F00E0
	push {r4, lr}
	ldr r1, _021F010C ; =0x00009D7A
	add r4, r0, #0
	ldrh r1, [r4, r1]
	cmp r1, #0
	bne _021F00F6
	mov r1, #0
	mov r2, #0x2e
	bl ov112_021EA08C
	b _021F00FE
_021F00F6:
	mov r1, #0
	mov r2, #0x2d
	bl ov112_021EA08C
_021F00FE:
	ldr r1, _021F0110 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x1b
	str r0, [r4, #0xc]
	mov r0, #0x23
	pop {r4, pc}
	nop
_021F010C: .word 0x00009D7A
_021F0110: .word 0x0001E524
	thumb_func_end ov112_021F00E0

	thumb_func_start ov112_021F0114
ov112_021F0114: ; 0x021F0114
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F0150 ; =0x0001EC78
	ldr r2, [r4, r0]
	cmp r2, #0
	beq _021F014A
	ldr r0, _021F0154 ; =0x0001E448
	lsl r2, r2, #0x18
	ldr r0, [r4, r0]
	mov r1, #4
	lsr r2, r2, #0x18
	bl BufferPokewalkerCourseName
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x30
	bl ov112_021EA08C
	ldr r1, _021F0158 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x1c
	str r0, [r4, #0xc]
	ldr r0, _021F0150 ; =0x0001EC78
	mov r1, #0
	str r1, [r4, r0]
	mov r0, #0x23
	pop {r4, pc}
_021F014A:
	mov r0, #0x1c
	pop {r4, pc}
	nop
_021F0150: .word 0x0001EC78
_021F0154: .word 0x0001E448
_021F0158: .word 0x0001E524
	thumb_func_end ov112_021F0114

	thumb_func_start ov112_021F015C
ov112_021F015C: ; 0x021F015C
	push {lr}
	sub sp, #0xc
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
	mov r0, #0x1d
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021F015C

	thumb_func_start ov112_021F0180
ov112_021F0180: ; 0x021F0180
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021F018E
	mov r0, #0xc
	pop {r3, pc}
_021F018E:
	mov r0, #0x1d
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021F0180

	thumb_func_start ov112_021F0194
ov112_021F0194: ; 0x021F0194
	push {lr}
	sub sp, #0xc
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
	mov r0, #0x1f
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021F0194

	thumb_func_start ov112_021F01B8
ov112_021F01B8: ; 0x021F01B8
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021F01C6
	mov r0, #0x20
	pop {r3, pc}
_021F01C6:
	mov r0, #0x1f
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021F01B8

	thumb_func_start ov112_021F01CC
ov112_021F01CC: ; 0x021F01CC
	push {r3, r4, r5, lr}
	sub sp, #0x18
	mov r4, #0
	add r5, r0, #0
	str r4, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r2, r4, #0
	add r3, r4, #0
	bl FillBgTilemapRect
	add r0, r5, #0
	mov r1, #2
	mov r2, #0xf
	bl ov112_021E7CA4
	ldr r2, _021F02F4 ; =0x0001E49C
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #1
	add r3, r4, #0
	bl ov112_021E9FD8
	ldr r0, _021F02F8 ; =0x0001E440
	ldr r0, [r5, r0]
	bl sub_02032718
	add r2, r0, #0
	ldr r0, _021F02FC ; =0x0001E448
	lsl r2, r2, #0x18
	ldr r0, [r5, r0]
	mov r1, #2
	lsr r2, r2, #0x18
	bl BufferPokewalkerCourseName
	ldr r0, _021F0300 ; =0x000010F0
	ldr r1, [r5, r0]
	ldr r0, _021F0304 ; =0x0001D758
	ldr r0, [r5, r0]
	cmp r1, r0
	bls _021F022C
	sub r4, r1, r0
_021F022C:
	ldr r0, _021F02F8 ; =0x0001E440
	add r1, sp, #0x14
	ldr r0, [r5, r0]
	add r2, sp, #0x10
	bl sub_02032674
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021F02FC ; =0x0001E448
	mov r1, #5
	ldr r0, [r5, r0]
	add r2, r4, #0
	mov r3, #7
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, _021F0308 ; =0x00009D7A
	ldr r0, _021F02FC ; =0x0001E448
	ldrh r2, [r5, r2]
	ldr r0, [r5, r0]
	mov r1, #3
	mov r3, #5
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021F02FC ; =0x0001E448
	ldr r2, [sp, #0x14]
	ldr r0, [r5, r0]
	mov r1, #6
	mov r3, #7
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021F02FC ; =0x0001E448
	mov r1, #7
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x10]
	add r3, r1, #0
	bl BufferIntegerAsString
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp]
	ldr r2, _021F030C ; =0x0001E4B4
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #5
	mov r3, #0
	bl ov112_021E9FA4
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x3c
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp]
	ldr r2, _021F0310 ; =0x0001E4BC
	add r0, r5, #0
	ldr r2, [r5, r2]
	mov r1, #7
	mov r3, #0
	bl ov112_021E9FA4
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #8
	mov r2, #0x3e
	lsl r3, r3, #0xa
	bl ov112_021E9F5C
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
	mov r0, #0x21
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_021F02F4: .word 0x0001E49C
_021F02F8: .word 0x0001E440
_021F02FC: .word 0x0001E448
_021F0300: .word 0x000010F0
_021F0304: .word 0x0001D758
_021F0308: .word 0x00009D7A
_021F030C: .word 0x0001E4B4
_021F0310: .word 0x0001E4BC
	thumb_func_end ov112_021F01CC

	thumb_func_start ov112_021F0314
ov112_021F0314: ; 0x021F0314
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021F0322
	mov r0, #0x22
	pop {r3, pc}
_021F0322:
	mov r0, #0x21
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021F0314

	thumb_func_start ov112_021F0328
ov112_021F0328: ; 0x021F0328
	push {r4, lr}
	ldr r1, _021F035C ; =0x00009D7A
	add r4, r0, #0
	ldrh r1, [r4, r1]
	cmp r1, #0
	bne _021F033E
	mov r1, #0
	mov r2, #0x2f
	bl ov112_021EA08C
	b _021F034E
_021F033E:
	ldr r0, _021F0360 ; =0x000004A1
	bl PlayFanfare
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x2d
	bl ov112_021EA08C
_021F034E:
	ldr r1, _021F0364 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #8
	str r0, [r4, #0xc]
	mov r0, #0x23
	pop {r4, pc}
	nop
_021F035C: .word 0x00009D7A
_021F0360: .word 0x000004A1
_021F0364: .word 0x0001E524
	thumb_func_end ov112_021F0328

	thumb_func_start ov112_021F0368
ov112_021F0368: ; 0x021F0368
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F0390 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021F038A
	bl IsFanfarePlaying
	cmp r0, #0
	bne _021F038A
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	pop {r4, pc}
_021F038A:
	mov r0, #0x23
	pop {r4, pc}
	nop
_021F0390: .word 0x0001E524
	thumb_func_end ov112_021F0368

	thumb_func_start ov112_021F0394
ov112_021F0394: ; 0x021F0394
	mov r1, #0
	str r1, [r0, #4]
	mov r0, #0x25
	bx lr
	thumb_func_end ov112_021F0394

	thumb_func_start ov112_021F039C
ov112_021F039C: ; 0x021F039C
	push {r3, r4, r5, lr}
	mov r1, #0x96
	lsl r1, r1, #2
	add r5, r0, #0
	bl Heap_Alloc
	mov r2, #0x96
	mov r1, #0
	lsl r2, r2, #2
	add r4, r0, #0
	bl MI_CpuFill8
	str r5, [r4]
	str r5, [r4, #0x74]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021F039C

	thumb_func_start ov112_021F03BC
ov112_021F03BC: ; 0x021F03BC
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	str r1, [r4, #4]
	add r0, r1, #0
	ldr r1, [r4]
	bl ov112_021F05FC
	mov r0, #9
	str r0, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #0x1d
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #8
	mov r2, #5
	mov r3, #0xe
	bl AddWindowParameterized
	mov r0, #6
	str r0, [sp]
	mov r2, #5
	add r1, r4, #0
	str r2, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #0x11
	str r0, [sp, #0x10]
	ldr r0, [r4, #4]
	add r1, #0x18
	mov r3, #0x17
	bl AddWindowParameterized
	mov r0, #0xc
	str r0, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #0x31
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x28
	mov r2, #5
	mov r3, #0xe
	bl AddWindowParameterized
	mov r0, #6
	str r0, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x38
	mov r2, #5
	mov r3, #0xe
	bl AddWindowParameterized
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #0x1b
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x48
	mov r2, #5
	mov r3, #0x16
	bl AddWindowParameterized
	mov r3, #0xe
	str r3, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #0x41
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x58
	mov r2, #5
	bl AddWindowParameterized
	mov r1, #0x1b
	add r2, r1, #0
	ldr r3, [r4]
	mov r0, #1
	add r2, #0xf9
	bl NewMsgDataFromNarc
	str r0, [r4, #0x68]
	ldr r0, [r4]
	bl MessageFormat_New
	str r0, [r4, #0x6c]
	ldr r1, [r4]
	mov r0, #0xb
	bl String_New
	str r0, [r4, #0x70]
	add r0, r4, #0
	add r0, #0x74
	bl ov112_021F09B4
	add r4, #0x74
	add r0, r4, #0
	bl ov112_021F0B28
	mov r0, #2
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add sp, #0x14
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F03BC

	thumb_func_start ov112_021F04DC
ov112_021F04DC: ; 0x021F04DC
	push {r3, r4, r5, lr}
	add r4, r1, #0
	ldrb r2, [r4, #9]
	add r5, r0, #0
	cmp r2, #2
	bne _021F04FE
	bl ov112_021F0908
	add r0, r5, #0
	add r1, r4, #0
	bl ov112_021F06CC
	mov r0, #2
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	pop {r3, r4, r5, pc}
_021F04FE:
	bl ov112_021F0980
	mov r0, #2
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021F04DC

	thumb_func_start ov112_021F050C
ov112_021F050C: ; 0x021F050C
	push {r3, lr}
	ldr r0, [r0, #0x78]
	cmp r0, #0
	beq _021F0518
	bl SpriteList_RenderAndAnimateSprites
_021F0518:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021F050C

	thumb_func_start ov112_021F051C
ov112_021F051C: ; 0x021F051C
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	ldr r0, [r7, #0x68]
	bl DestroyMsgData
	ldr r0, [r7, #0x6c]
	bl MessageFormat_Delete
	ldr r0, [r7, #0x70]
	bl String_Delete
	add r0, r7, #0
	add r0, #8
	bl RemoveWindow
	add r0, r7, #0
	add r0, #0x18
	bl RemoveWindow
	add r0, r7, #0
	add r0, #0x28
	bl RemoveWindow
	add r0, r7, #0
	add r0, #0x38
	bl RemoveWindow
	add r0, r7, #0
	add r0, #0x48
	bl RemoveWindow
	add r0, r7, #0
	add r0, #0x58
	bl RemoveWindow
	ldr r0, [r7, #4]
	mov r1, #5
	bl FreeBgTilemapBuffer
	ldr r0, [r7, #4]
	mov r1, #7
	bl FreeBgTilemapBuffer
	add r5, r7, #0
	add r5, #0x74
	add r0, r5, #0
	bl ov112_021F05CC
	mov r4, #0
_021F057E:
	mov r0, #0x18
	mul r0, r4
	add r6, r5, r0
	mov r0, #0x52
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl SpriteTransfer_DeleteCharTransferTask
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl SpriteTransfer_DeletePlttTransferTask
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #2
	blo _021F057E
	mov r6, #0x13
	mov r4, #0
	lsl r6, r6, #4
_021F05A8:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl Destroy2DGfxResObjMan
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #6
	blo _021F05A8
	ldr r0, [r5, #4]
	bl SpriteList_Delete
	add r0, r7, #0
	bl Heap_Free
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F051C

	thumb_func_start ov112_021F05CC
ov112_021F05CC: ; 0x021F05CC
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r6, #0x67
	mov r4, #0
	add r5, r7, #0
	lsl r6, r6, #2
_021F05D8:
	ldr r0, [r5, r6]
	bl Sprite_Delete
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blt _021F05D8
	mov r0, #0x6d
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	bl Sprite_Delete
	mov r0, #0x6e
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	bl Heap_Free
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov112_021F05CC

	thumb_func_start ov112_021F05FC
ov112_021F05FC: ; 0x021F05FC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r4, r1, #0
	bl ov112_021F0668
	mov r1, #0
	str r1, [sp]
	ldr r0, _021F0664 ; =0x00000103
	mov r2, #4
	add r3, r1, #0
	str r4, [sp, #4]
	bl GfGfxLoader_GXLoadPal
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r1, #1
	str r1, [sp, #8]
	ldr r0, _021F0664 ; =0x00000103
	add r2, r5, #0
	mov r3, #7
	str r4, [sp, #0xc]
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	mov r0, #6
	lsl r0, r0, #8
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, _021F0664 ; =0x00000103
	mov r1, #2
	add r2, r5, #0
	mov r3, #7
	str r4, [sp, #0xc]
	bl GfGfxLoader_LoadScrnData
	add r0, r5, #0
	mov r1, #7
	bl BgCommitTilemapBufferToVram
	mov r1, #0x1e
	mov r0, #4
	lsl r1, r1, #4
	add r2, r4, #0
	bl LoadFontPal0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021F0664: .word 0x00000103
	thumb_func_end ov112_021F05FC

	thumb_func_start ov112_021F0668
ov112_021F0668: ; 0x021F0668
	push {r3, r4, r5, lr}
	sub sp, #0x38
	ldr r5, _021F06C4 ; =ov112_021FF134
	add r4, r0, #0
	ldmia r5!, {r0, r1}
	add r3, sp, #0x1c
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
	ldr r5, _021F06C8 ; =ov112_021FF150
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
	add sp, #0x38
	pop {r3, r4, r5, pc}
	nop
_021F06C4: .word ov112_021FF134
_021F06C8: .word ov112_021FF150
	thumb_func_end ov112_021F0668

	thumb_func_start ov112_021F06CC
ov112_021F06CC: ; 0x021F06CC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	add r0, #0x28
	ldrb r7, [r0]
	ldrh r0, [r4, #0x26]
	add r1, #0xa
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x70]
	bl CopyU16ArrayToString
	add r0, r5, #0
	add r0, #0x38
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F0900 ; =0x00010200
	add r3, r1, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r0, r5, #0
	ldr r2, [r5, #0x70]
	add r0, #0x38
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	add r0, #0x38
	bl CopyWindowToVram
	ldrh r0, [r4, #4]
	ldr r1, [r5]
	bl GetSpeciesName
	add r6, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r3, #2
	str r3, [sp, #4]
	ldr r0, [r5, #0x6c]
	mov r1, #0
	add r2, r6, #0
	bl BufferString
	add r0, r6, #0
	bl String_Delete
	ldr r0, [r5, #0x6c]
	ldr r1, [r5, #0x68]
	ldr r3, [r5]
	mov r2, #0
	bl ReadMsgData_ExpandPlaceholders
	add r6, r0, #0
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F0900 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #8
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	add r0, #8
	bl CopyWindowToVram
	add r0, r6, #0
	bl String_Delete
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r5, #0x6c]
	mov r1, #0
	add r2, r7, #0
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, [r5, #0x6c]
	ldr r1, [r5, #0x68]
	ldr r3, [r5]
	mov r2, #3
	bl ReadMsgData_ExpandPlaceholders
	add r6, r0, #0
	add r0, r5, #0
	add r0, #0x18
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x18
	bl GetWindowWidth
	add r7, r0, #0
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r1, r7, #3
	sub r3, r1, r0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F0900 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x18
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	add r0, #0x18
	bl CopyWindowToVram
	add r0, r6, #0
	bl String_Delete
	ldrb r0, [r4, #8]
	cmp r0, #0
	bne _021F0820
	ldr r0, [r5, #0x68]
	mov r1, #1
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x48
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F0904 ; =0x00070800
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x48
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	add r0, #0x48
	bl CopyWindowToVram
	add r0, r4, #0
	bl String_Delete
	b _021F0876
_021F0820:
	cmp r0, #1
	bne _021F0864
	ldr r0, [r5, #0x68]
	mov r1, #2
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x48
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x48
	add r2, r4, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	add r0, #0x48
	bl CopyWindowToVram
	add r0, r4, #0
	bl String_Delete
	b _021F0876
_021F0864:
	add r0, r5, #0
	add r0, #0x48
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x48
	bl CopyWindowToVram
_021F0876:
	ldr r0, [r5, #0x68]
	mov r1, #4
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x28
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F0900 ; =0x00010200
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x28
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	add r0, #0x28
	bl CopyWindowToVram
	add r0, r4, #0
	bl String_Delete
	ldr r0, [r5, #0x6c]
	ldr r2, [sp, #0x10]
	mov r1, #0
	bl BufferItemName
	ldr r0, [r5, #0x6c]
	ldr r1, [r5, #0x68]
	ldr r3, [r5]
	mov r2, #5
	bl ReadMsgData_ExpandPlaceholders
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x58
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F0900 ; =0x00010200
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x58
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r5, #0x58
	add r0, r5, #0
	bl CopyWindowToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0900: .word 0x00010200
_021F0904: .word 0x00070800
	thumb_func_end ov112_021F06CC

	thumb_func_start ov112_021F0908
ov112_021F0908: ; 0x021F0908
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	add r5, r4, #0
	add r5, #0x74
	add r0, r5, #0
	add r7, r1, #0
	bl ov112_021F0C8C
	add r0, r4, #0
	add r0, #0x74
	bl ov112_021F0D04
	mov r0, #0x8a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r4, #0
_021F092E:
	add r0, r7, r4
	add r0, #0x20
	ldrb r0, [r0]
	cmp r0, #0
	beq _021F0958
	lsl r0, r4, #2
	add r6, r5, r0
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0x67
	lsl r0, r0, #2
	lsl r1, r4, #1
	ldr r0, [r6, r0]
	add r1, r1, #1
	bl Sprite_SetAnimCtrlSeq
	b _021F0974
_021F0958:
	lsl r0, r4, #2
	add r6, r5, r0
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	lsl r1, r4, #1
	bl Sprite_SetAnimCtrlSeq
_021F0974:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #6
	blo _021F092E
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov112_021F0908

	thumb_func_start ov112_021F0980
ov112_021F0980: ; 0x021F0980
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r4, #0
	mov r6, #0x67
	add r5, #0x74
	add r7, r4, #0
	lsl r6, r6, #2
_021F098E:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r6]
	add r1, r7, #0
	bl Sprite_SetDrawFlag
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #6
	blo _021F098E
	mov r0, #0x6d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F0980

	thumb_func_start ov112_021F09B4
ov112_021F09B4: ; 0x021F09B4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r1, r5, #0
	ldr r2, [r5]
	mov r0, #7
	add r1, #8
	bl G2dRenderer_Init
	str r0, [r5, #4]
	add r0, r5, #0
	mov r2, #1
	add r0, #8
	mov r1, #0
	lsl r2, r2, #0x14
	bl G2dRenderer_SetSubSurfaceCoords
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r7, #0x13
	mov r6, #0
	add r4, r5, #0
	lsl r7, r7, #4
_021F09E6:
	ldr r2, [r5]
	mov r0, #2
	add r1, r6, #0
	bl Create2DGfxResObjMan
	str r0, [r4, r7]
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #6
	blt _021F09E6
	mov r3, #1
	str r3, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r5]
	mov r1, #0x13
	lsl r1, r1, #4
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	sub r1, #0x2d
	mov r2, #4
	bl AddCharResObjFromNarc
	mov r2, #0x52
	lsl r2, r2, #2
	str r0, [r5, r2]
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	ldr r0, [r5]
	sub r2, #0x14
	str r0, [sp, #0xc]
	ldr r0, [r5, r2]
	add r1, #0xff
	mov r2, #3
	mov r3, #0
	bl AddPlttResObjFromNarc
	mov r1, #0x53
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r3, #1
	str r3, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r5]
	mov r2, #6
	str r0, [sp, #8]
	add r0, r1, #0
	sub r0, #0x14
	ldr r0, [r5, r0]
	sub r1, #0x49
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x15
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r3, #1
	str r3, [sp]
	mov r0, #3
	str r0, [sp, #4]
	ldr r0, [r5]
	mov r2, #5
	str r0, [sp, #8]
	add r0, r1, #0
	sub r0, #0x14
	ldr r0, [r5, r0]
	sub r1, #0x4d
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x55
	lsl r1, r1, #2
	str r0, [r5, r1]
	sub r1, #0xc
	ldr r0, [r5, r1]
	bl SpriteTransfer_CreateCharTransferTask_AllocAtEnd
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl SpriteTransfer_CreateExtPlttTransferTask
	mov r0, #2
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r5]
	mov r1, #0x5d
	str r0, [sp, #8]
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r2, #9
	mov r3, #0
	bl AddCharResObjFromNarc
	mov r1, #0x16
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, [r5]
	sub r1, #0x2c
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	mov r1, #0x5d
	mov r2, #6
	mov r3, #0
	bl AddPlttResObjFromNarc
	mov r1, #0x59
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r5]
	sub r1, #0x2c
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	mov r1, #0x5d
	mov r2, #0xa
	mov r3, #0
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x5a
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	ldr r0, [r5]
	sub r1, #0x2c
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	mov r1, #0x5d
	mov r2, #0xa
	mov r3, #0
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x5b
	lsl r1, r1, #2
	str r0, [r5, r1]
	sub r1, #0xc
	ldr r0, [r5, r1]
	bl SpriteTransfer_CreateCharTransferTask_AllocAtEnd
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl SpriteTransfer_CreateExtPlttTransferTask
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F09B4

	thumb_func_start ov112_021F0B28
ov112_021F0B28: ; 0x021F0B28
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	mov r7, #0x67
	add r5, r0, #0
	mov r4, #0
	mov r6, #0x90
	lsl r7, r7, #2
_021F0B36:
	lsl r0, r4, #3
	add r0, #0x18
	str r0, [sp]
	str r6, [sp, #4]
	lsl r0, r4, #1
	str r0, [sp, #8]
	mov r0, #0
	mov r1, #1
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r2, r1, #0
	mov r3, #0
	bl ov112_021F0B9C
	lsl r1, r4, #2
	add r1, r5, r1
	str r0, [r1, r7]
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #6
	blo _021F0B36
	mov r0, #0x30
	str r0, [sp]
	mov r0, #0x58
	str r0, [sp, #4]
	mov r2, #0
	str r2, [sp, #8]
	add r0, r5, #0
	mov r1, #2
	add r3, r2, #0
	str r2, [sp, #0xc]
	bl ov112_021F0B9C
	mov r1, #0x6d
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r1, #0x32
	ldr r0, [r5]
	lsl r1, r1, #6
	bl Heap_Alloc
	mov r1, #0x6e
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r5, #0
	bl ov112_021F0C50
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F0B28

	thumb_func_start ov112_021F0B9C
ov112_021F0B9C: ; 0x021F0B9C
	push {r3, r4, r5, lr}
	sub sp, #0x80
	add r4, r0, #0
	mov r0, #0
	str r1, [sp]
	mvn r0, r0
	str r0, [sp, #4]
	add r5, r2, #0
	str r0, [sp, #8]
	mov r2, #0
	mov r0, #0x13
	str r2, [sp, #0xc]
	lsl r0, r0, #4
	str r3, [sp, #0x10]
	ldr r3, [r4, r0]
	str r3, [sp, #0x14]
	add r3, r0, #4
	ldr r3, [r4, r3]
	str r3, [sp, #0x18]
	add r3, r0, #0
	add r3, #8
	ldr r3, [r4, r3]
	add r0, #0xc
	str r3, [sp, #0x1c]
	ldr r0, [r4, r0]
	add r3, r1, #0
	str r0, [sp, #0x20]
	str r2, [sp, #0x24]
	str r2, [sp, #0x28]
	add r0, sp, #0x2c
	add r2, r1, #0
	bl CreateSpriteResourcesHeader
	ldr r0, [r4]
	add r2, sp, #0x2c
	str r0, [sp]
	ldr r1, [r4, #4]
	add r0, sp, #0x50
	mov r3, #2
	bl ov112_021F0C30
	ldr r0, [sp, #0x90]
	str r5, [sp, #0x74]
	lsl r0, r0, #0xc
	str r0, [sp, #0x58]
	ldr r0, [sp, #0x94]
	lsl r1, r0, #0xc
	mov r0, #1
	lsl r0, r0, #0x14
	add r0, r1, r0
	str r0, [sp, #0x5c]
	add r0, sp, #0x50
	bl Sprite_CreateAffine
	mov r1, #1
	add r4, r0, #0
	bl Sprite_SetAnimActiveFlag
	ldr r1, [sp, #0x98]
	add r0, r4, #0
	bl Sprite_SetAnimCtrlSeq
	add r0, r4, #0
	mov r1, #1
	bl Sprite_SetPriority
	ldr r1, [sp, #0x9c]
	add r0, r4, #0
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	add sp, #0x80
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov112_021F0B9C

	thumb_func_start ov112_021F0C30
ov112_021F0C30: ; 0x021F0C30
	str r1, [r0]
	str r2, [r0, #4]
	mov r2, #0
	mov r1, #1
	str r2, [r0, #0x10]
	lsl r1, r1, #0xc
	str r1, [r0, #0x14]
	str r1, [r0, #0x18]
	str r1, [r0, #0x1c]
	strh r2, [r0, #0x20]
	str r2, [r0, #0x24]
	ldr r1, [sp]
	str r3, [r0, #0x28]
	str r1, [r0, #0x2c]
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021F0C30

	thumb_func_start ov112_021F0C50
ov112_021F0C50: ; 0x021F0C50
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x59
	lsl r0, r0, #2
	ldr r4, [r5, r0]
	sub r0, r0, #4
	ldr r0, [r5, r0]
	bl SpriteTransfer_GetCharProxy
	add r6, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	bl SpriteTransfer_GetPaletteProxy
	add r4, r0, #0
	add r0, r6, #0
	mov r1, #2
	bl NNS_G2dGetImageLocation
	mov r1, #0x77
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r4, #0
	mov r1, #2
	bl NNS_G2dGetImagePaletteLocation
	mov r1, #0x1e
	lsl r1, r1, #4
	str r0, [r5, r1]
	pop {r4, r5, r6, pc}
	thumb_func_end ov112_021F0C50

	thumb_func_start ov112_021F0C8C
ov112_021F0C8C: ; 0x021F0C8C
	push {r4, r5, lr}
	sub sp, #0x24
	add r5, r1, #0
	add r4, r0, #0
	ldrb r0, [r5, #6]
	mov r3, #2
	str r0, [sp]
	ldrb r0, [r5, #7]
	str r0, [sp, #4]
	ldr r0, [r5]
	str r0, [sp, #8]
	ldrh r1, [r5, #4]
	ldrb r2, [r5, #8]
	add r0, sp, #0x14
	bl GetMonSpriteCharAndPlttNarcIdsEx
	ldr r0, [r5]
	mov r3, #0x6e
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	ldrh r0, [r5, #4]
	add r1, sp, #0x10
	lsl r3, r3, #2
	str r0, [sp, #0xc]
	ldrh r0, [r1, #4]
	ldrh r1, [r1, #6]
	ldr r2, [r4]
	ldr r3, [r4, r3]
	bl sub_02014540
	add r1, sp, #0x10
	ldrh r0, [r1, #4]
	ldrh r1, [r1, #8]
	ldr r2, [r4]
	bl AllocAndReadWholeNarcMemberByIdPair
	add r1, sp, #0x10
	add r5, r0, #0
	bl NNS_G2dGetUnpackedPaletteData
	cmp r0, #1
	beq _021F0CEA
	bl GF_AssertFail
_021F0CEA:
	ldr r0, [sp, #0x10]
	mov r1, #0x6f
	lsl r1, r1, #2
	ldr r0, [r0, #0xc]
	add r1, r4, r1
	mov r2, #0x20
	bl MIi_CpuCopy16
	add r0, r5, #0
	bl Heap_Free
	add sp, #0x24
	pop {r4, r5, pc}
	thumb_func_end ov112_021F0C8C

	thumb_func_start ov112_021F0D04
ov112_021F0D04: ; 0x021F0D04
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x6e
	lsl r0, r0, #2
	mov r1, #0x32
	ldr r0, [r4, r0]
	lsl r1, r1, #6
	bl DC_FlushRange
	mov r1, #0x6e
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	add r1, #0x24
	mov r2, #0x32
	ldr r1, [r4, r1]
	lsl r2, r2, #6
	bl GXS_LoadOBJ
	mov r0, #0x6f
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0x20
	bl DC_FlushRange
	mov r1, #0x6f
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, #0x24
	ldr r1, [r4, r1]
	mov r2, #0x20
	bl GXS_LoadOBJPltt
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F0D04

	thumb_func_start ov112_021F0D48
ov112_021F0D48: ; 0x021F0D48
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, _021F0DB8 ; =ov112_021FF2CC
	mov r7, #0
	str r0, [sp]
	add r0, r5, #0
	str r0, [sp, #8]
	add r0, #0x40
	ldr r4, _021F0DBC ; =ov112_021FF244
	str r7, [sp, #4]
	str r0, [sp, #8]
_021F0D60:
	ldr r0, [sp]
	strh r7, [r5]
	ldrb r2, [r0]
	mov r6, #0
	add r0, r6, #0
	strb r2, [r5, #2]
	ldr r1, [r4]
	lsr r2, r2, #1
	beq _021F0D8A
_021F0D72:
	ldrb r3, [r1]
	add r0, r0, #1
	add r3, r6, r3
	lsl r3, r3, #0x18
	lsr r6, r3, #0x18
	ldrb r3, [r1, #1]
	add r1, r1, #2
	add r3, r6, r3
	lsl r3, r3, #0x18
	lsr r6, r3, #0x18
	cmp r0, r2
	blo _021F0D72
_021F0D8A:
	strb r6, [r5, #3]
	ldr r1, [sp, #8]
	ldrb r2, [r5, #2]
	ldr r0, [r4]
	add r1, r1, r7
	bl MI_CpuCopy8
	ldrb r0, [r5, #2]
	add r5, r5, #4
	add r4, r4, #4
	add r0, r7, r0
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldr r0, [sp]
	add r0, r0, #1
	str r0, [sp]
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #0x10
	blt _021F0D60
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0DB8: .word ov112_021FF2CC
_021F0DBC: .word ov112_021FF244
	thumb_func_end ov112_021F0D48

	thumb_func_start ov112_021F0DC0
ov112_021F0DC0: ; 0x021F0DC0
	push {r3, lr}
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _021F0DEC ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _021F0DF0 ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	pop {r3, pc}
	.balign 4, 0
_021F0DEC: .word 0xFFFFE0FF
_021F0DF0: .word 0x04001000
	thumb_func_end ov112_021F0DC0

	thumb_func_start ov112_021F0DF4
ov112_021F0DF4: ; 0x021F0DF4
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _021F0E10 ; =ov112_021FF370
	add r3, sp, #0
	mov r2, #5
_021F0DFE:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F0DFE
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_021F0E10: .word ov112_021FF370
	thumb_func_end ov112_021F0DF4

	thumb_func_start ov112_021F0E14
ov112_021F0E14: ; 0x021F0E14
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	add r7, r2, #0
	cmp r5, #0
	ble _021F0E26
	ldr r1, _021F0E58 ; =0x000001ED
	cmp r5, r1
	ble _021F0E2A
_021F0E26:
	mov r4, #1
	b _021F0E52
_021F0E2A:
	bl SpeciesToOverworldModelIndexOffset
	ldr r1, _021F0E5C ; =0x00000129
	add r4, r0, r1
	add r0, r5, #0
	bl OverworldModelLookupHasFemaleForm
	cmp r0, #0
	beq _021F0E44
	cmp r7, #1
	bne _021F0E52
	add r4, r4, #1
	b _021F0E52
_021F0E44:
	add r0, r5, #0
	bl OverworldModelLookupFormCount
	cmp r6, r0
	ble _021F0E50
	mov r6, #0
_021F0E50:
	add r4, r4, r6
_021F0E52:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F0E58: .word 0x000001ED
_021F0E5C: .word 0x00000129
	thumb_func_end ov112_021F0E14

	thumb_func_start ov112_021F0E60
ov112_021F0E60: ; 0x021F0E60
	push {r3, r4, lr}
	sub sp, #4
	ldr r2, _021F0EA8 ; =ov112_021FF2DC
	add r4, r0, #0
	ldrb r3, [r2, #0xb]
	add r1, sp, #0
	add r0, sp, #0
	strb r3, [r1]
	ldrb r3, [r2, #0xc]
	strb r3, [r1, #1]
	ldrb r3, [r2, #0xd]
	ldrb r2, [r2, #0xe]
	strb r3, [r1, #2]
	strb r2, [r1, #3]
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	bne _021F0E8E
	ldr r0, _021F0EAC ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #2
	tst r0, r1
	beq _021F0EA0
_021F0E8E:
	ldr r0, _021F0EB0 ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x78]
	bl ManagedSprite_ResetSpriteAnimCtrlState
	add sp, #4
	mov r0, #1
	pop {r3, r4, pc}
_021F0EA0:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	nop
_021F0EA8: .word ov112_021FF2DC
_021F0EAC: .word gSystem
_021F0EB0: .word 0x000005DC
	thumb_func_end ov112_021F0E60

	thumb_func_start ov112_021F0EB4
ov112_021F0EB4: ; 0x021F0EB4
	push {r3, lr}
	ldr r1, _021F0EF0 ; =0x0000013D
	ldrb r0, [r0, r1]
	cmp r0, #0
	beq _021F0EEA
	ldr r2, _021F0EF4 ; =ov112_021FF2DC
	add r1, sp, #0
	ldrb r3, [r2, #3]
	add r0, sp, #0
	strb r3, [r1]
	ldrb r3, [r2, #4]
	strb r3, [r1, #1]
	ldrb r3, [r2, #5]
	ldrb r2, [r2, #6]
	strb r3, [r1, #2]
	strb r2, [r1, #3]
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	bne _021F0EE6
	ldr r0, _021F0EF8 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _021F0EEA
_021F0EE6:
	mov r0, #1
	pop {r3, pc}
_021F0EEA:
	mov r0, #0
	pop {r3, pc}
	nop
_021F0EF0: .word 0x0000013D
_021F0EF4: .word ov112_021FF2DC
_021F0EF8: .word gSystem
	thumb_func_end ov112_021F0EB4

	thumb_func_start ov112_021F0EFC
ov112_021F0EFC: ; 0x021F0EFC
	push {r3, lr}
	ldr r1, _021F0F3C ; =0x0000013D
	ldrb r2, [r0, r1]
	add r1, r1, #1
	ldrb r0, [r0, r1]
	sub r0, r0, #1
	cmp r2, r0
	bge _021F0F38
	ldr r2, _021F0F40 ; =ov112_021FF2DC
	add r1, sp, #0
	ldrb r3, [r2, #7]
	add r0, sp, #0
	strb r3, [r1]
	ldrb r3, [r2, #8]
	strb r3, [r1, #1]
	ldrb r3, [r2, #9]
	ldrb r2, [r2, #0xa]
	strb r3, [r1, #2]
	strb r2, [r1, #3]
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	bne _021F0F34
	ldr r0, _021F0F44 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x10
	tst r0, r1
	beq _021F0F38
_021F0F34:
	mov r0, #1
	pop {r3, pc}
_021F0F38:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021F0F3C: .word 0x0000013D
_021F0F40: .word ov112_021FF2DC
_021F0F44: .word gSystem
	thumb_func_end ov112_021F0EFC

	thumb_func_start ov112_021F0F48
ov112_021F0F48: ; 0x021F0F48
	cmp r1, #0
	beq _021F0F56
	add r0, #0x85
	ldrb r0, [r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bx lr
_021F0F56:
	add r0, #0x86
	ldrb r0, [r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bx lr
	thumb_func_end ov112_021F0F48

	thumb_func_start ov112_021F0F60
ov112_021F0F60: ; 0x021F0F60
	add r0, #0x76
	ldrb r0, [r0]
	cmp r0, #8
	blo _021F0F6A
	mov r0, #0
_021F0F6A:
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bx lr
	thumb_func_end ov112_021F0F60

	thumb_func_start ov112_021F0F70
ov112_021F0F70: ; 0x021F0F70
	ldr r1, [r1]
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r0, [r0]
	cmp r0, r1
	bne _021F0F80
	mov r0, #0
	bx lr
_021F0F80:
	cmp r0, r1
	bls _021F0F88
	mov r0, #1
	bx lr
_021F0F88:
	mov r0, #0
	mvn r0, r0
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021F0F70

	thumb_func_start ov112_021F0F90
ov112_021F0F90: ; 0x021F0F90
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0xc8
	add r5, r0, #0
	mov r0, #0
	add r6, sp, #8
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	mov r4, #6
_021F0FA2:
	stmia r6!, {r0, r1, r2, r3}
	stmia r6!, {r0, r1, r2, r3}
	sub r4, r4, #1
	bne _021F0FA2
	mov r0, #0
	mvn r0, r0
	str r0, [sp, #4]
	cmp r5, #0
	bne _021F0FB8
	bl GF_AssertFail
_021F0FB8:
	ldr r0, [r5]
	cmp r0, #0
	bne _021F0FC2
	bl GF_AssertFail
_021F0FC2:
	ldr r0, [r5]
	ldr r0, [r0]
	bl Save_Pokewalker_Get
	ldr r0, [r5]
	ldr r0, [r0]
	bl Save_PlayerData_GetProfile
	add r4, r0, #0
	bl PlayerProfile_GetTrainerGender
	str r0, [r5, #0xc]
	add r0, r4, #0
	bl PlayerProfile_GetNamePtr
	mov r6, #0
	str r0, [r5, #8]
	add r7, r6, #0
_021F0FE6:
	ldr r0, [r5]
	ldr r0, [r0, #4]
	add r4, r0, r7
	ldrh r1, [r4, #8]
	ldr r0, _021F1268 ; =0x0000FFF9
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r0, #1
	bhi _021F100A
	ldrh r1, [r4, #0xa]
	ldr r0, _021F126C ; =0x000001ED
	cmp r1, r0
	bhi _021F1008
	ldrh r1, [r4, #0xc]
	cmp r1, r0
	bls _021F100A
_021F1008:
	b _021F1122
_021F100A:
	add r0, r4, #0
	add r0, #0x84
	ldrb r0, [r0]
	cmp r0, #0x1c
	bgt _021F1026
	bge _021F1040
	cmp r0, #0xe
	bgt _021F1052
	cmp r0, #0xc
	blt _021F1052
	beq _021F102C
	cmp r0, #0xe
	beq _021F1036
	b _021F1052
_021F1026:
	cmp r0, #0x1d
	beq _021F104A
	b _021F1052
_021F102C:
	add r1, r4, #0
	add r1, #0x84
	mov r0, #0xb
	strb r0, [r1]
	b _021F1052
_021F1036:
	add r1, r4, #0
	add r1, #0x84
	mov r0, #0xd
	strb r0, [r1]
	b _021F1052
_021F1040:
	add r1, r4, #0
	add r1, #0x84
	mov r0, #0xc
	strb r0, [r1]
	b _021F1052
_021F104A:
	add r1, r4, #0
	add r1, #0x84
	mov r0, #0xe
	strb r0, [r1]
_021F1052:
	add r0, r4, #0
	add r0, #0x84
	ldrb r0, [r0]
	cmp r0, #0x1c
	blt _021F1060
	mov r0, #0
	b _021F10E6
_021F1060:
	cmp r0, #1
	blt _021F1074
	cmp r0, #0xa
	bgt _021F1074
	ldr r1, _021F1270 ; =0x00000143
	ldrb r1, [r5, r1]
	add r2, r1, #1
	ldr r1, _021F1270 ; =0x00000143
	strb r2, [r5, r1]
	b _021F10E6
_021F1074:
	cmp r0, #0xc
	bne _021F108A
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	add r1, #0xbc
	orr r2, r1
	mov r1, #0x51
	lsl r1, r1, #2
	str r2, [r5, r1]
	b _021F10E6
_021F108A:
	cmp r0, #0xe
	bne _021F10A0
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	sub r1, #0x44
	orr r2, r1
	mov r1, #0x51
	lsl r1, r1, #2
	str r2, [r5, r1]
	b _021F10E6
_021F10A0:
	cmp r0, #0xb
	bne _021F10C2
	ldr r1, _021F1274 ; =0x0000013F
	ldrb r1, [r5, r1]
	cmp r1, #0
	bne _021F10E6
	ldr r1, _021F1278 ; =0x00000141
	ldrb r1, [r5, r1]
	add r2, r1, #1
	ldr r1, _021F1278 ; =0x00000141
	strb r2, [r5, r1]
	ldrb r1, [r5, r1]
	cmp r1, #4
	blo _021F10E6
	ldr r1, _021F1274 ; =0x0000013F
	strb r6, [r5, r1]
	b _021F10E6
_021F10C2:
	cmp r0, #0xd
	bne _021F10E6
	mov r1, #5
	lsl r1, r1, #6
	ldrb r1, [r5, r1]
	cmp r1, #0
	bne _021F10E6
	ldr r1, _021F127C ; =0x00000142
	ldrb r1, [r5, r1]
	add r2, r1, #1
	ldr r1, _021F127C ; =0x00000142
	strb r2, [r5, r1]
	ldrb r1, [r5, r1]
	cmp r1, #4
	blo _021F10E6
	mov r1, #5
	lsl r1, r1, #6
	strb r6, [r5, r1]
_021F10E6:
	cmp r0, #0
	beq _021F1122
	add r0, r4, #0
	add r0, #0x84
	ldrb r0, [r0]
	cmp r0, #0
	bne _021F10F8
	bl GF_AssertFail
_021F10F8:
	ldr r1, [r4]
	ldr r0, [sp, #4]
	cmp r0, r1
	bls _021F1102
	str r1, [sp, #4]
_021F1102:
	ldr r0, _021F1280 ; =0x0000013E
	ldrb r0, [r5, r0]
	lsl r1, r0, #3
	add r0, sp, #8
	str r4, [r0, r1]
	ldr r0, _021F1280 ; =0x0000013E
	ldrb r0, [r5, r0]
	lsl r1, r0, #3
	add r0, sp, #8
	add r0, r0, r1
	str r6, [r0, #4]
	ldr r0, _021F1280 ; =0x0000013E
	ldrb r0, [r5, r0]
	add r1, r0, #1
	ldr r0, _021F1280 ; =0x0000013E
	strb r1, [r5, r0]
_021F1122:
	add r6, r6, #1
	add r7, #0x88
	cmp r6, #0x18
	bge _021F112C
	b _021F0FE6
_021F112C:
	ldr r1, _021F1280 ; =0x0000013E
	mov r0, #0
	ldrb r3, [r5, r1]
	cmp r3, #0
	ble _021F116A
	add r2, sp, #8
_021F1138:
	ldr r1, [r2]
	add r1, #0x84
	ldrb r1, [r1]
	cmp r1, #0x19
	bne _021F1162
	add r6, sp, #8
	lsl r4, r0, #3
	ldr r0, [r6, r4]
	ldr r1, [r0]
	ldr r0, [sp, #4]
	cmp r1, r0
	bls _021F116A
	cmp r0, #0
	bne _021F1158
	bl GF_AssertFail
_021F1158:
	ldr r0, [sp, #4]
	sub r1, r0, #1
	ldr r0, [r6, r4]
	str r1, [r0]
	b _021F116A
_021F1162:
	add r0, r0, #1
	add r2, #8
	cmp r0, r3
	blt _021F1138
_021F116A:
	mov r0, #0
	str r0, [sp]
	ldr r1, _021F1280 ; =0x0000013E
	ldr r3, _021F1284 ; =ov112_021F0F70
	ldrb r1, [r5, r1]
	add r0, sp, #8
	mov r2, #8
	bl MATH_QSort
	ldr r0, _021F1280 ; =0x0000013E
	ldrb r4, [r5, r0]
	cmp r4, #2
	bhs _021F11A6
	sub r0, r4, #1
	lsl r1, r0, #3
	add r0, sp, #8
	ldr r0, [r0, r1]
	mov r2, #0
	add r0, #0x76
	strb r2, [r0]
	bl GF_RTC_DateTimeToSec
	ldr r1, _021F1280 ; =0x0000013E
	ldrb r1, [r5, r1]
	sub r1, r1, #1
	lsl r2, r1, #3
	add r1, sp, #8
	ldr r1, [r1, r2]
	str r0, [r1]
	b _021F11EA
_021F11A6:
	sub r1, r4, #2
	lsl r1, r1, #3
	add r3, sp, #8
	ldr r2, [r3, r1]
	sub r4, r4, #1
	add r1, r2, #0
	add r1, #0x76
	lsl r4, r4, #3
	ldr r4, [r3, r4]
	ldrb r1, [r1]
	add r4, #0x76
	strb r1, [r4]
	add r1, r2, #0
	add r1, #0x84
	ldrb r1, [r1]
	cmp r1, #0x1b
	bne _021F11DC
	ldrb r0, [r5, r0]
	mov r1, #0xe1
	ldr r2, [r2]
	sub r0, r0, #1
	lsl r0, r0, #3
	lsl r1, r1, #4
	ldr r0, [r3, r0]
	add r1, r2, r1
	str r1, [r0]
	b _021F11EA
_021F11DC:
	ldrb r0, [r5, r0]
	ldr r1, [r2]
	sub r0, r0, #1
	lsl r0, r0, #3
	ldr r0, [r3, r0]
	add r1, r1, #5
	str r1, [r0]
_021F11EA:
	ldr r0, _021F1280 ; =0x0000013E
	mov r1, #0
	ldrb r0, [r5, r0]
	add r2, r1, #0
	add r7, r1, #0
	cmp r0, #0
	ble _021F1232
	add r6, sp, #8
_021F11FA:
	ldr r0, [r6]
	add r3, r0, #0
	add r3, #0x84
	ldrb r3, [r3]
	add r4, r0, #0
	add r4, #0x78
	ldrh r4, [r4]
	cmp r3, #0x1b
	bne _021F1222
	cmp r1, #0x1b
	bne _021F1222
	mov r1, #0x4b
	lsl r1, r1, #2
	cmp r4, r1
	bge _021F1222
	cmp r2, r1
	bge _021F1222
	add r0, #0x84
	mov r1, #0
	strb r1, [r0]
_021F1222:
	ldr r0, _021F1280 ; =0x0000013E
	add r7, r7, #1
	ldrb r0, [r5, r0]
	add r1, r3, #0
	add r2, r4, #0
	add r6, #8
	cmp r7, r0
	blt _021F11FA
_021F1232:
	mov r1, #0
	add r4, r1, #0
	cmp r0, #0
	ble _021F1260
	ldr r6, _021F1280 ; =0x0000013E
	add r2, sp, #8
	add r3, r5, #0
_021F1240:
	ldr r0, [r2]
	add r7, r0, #0
	add r7, #0x84
	ldrb r7, [r7]
	cmp r7, #0
	beq _021F1256
	add r7, r3, #0
	add r7, #0xc0
	str r0, [r7]
	add r3, r3, #4
	add r1, r1, #1
_021F1256:
	ldrb r0, [r5, r6]
	add r4, r4, #1
	add r2, #8
	cmp r4, r0
	blt _021F1240
_021F1260:
	ldr r0, _021F1280 ; =0x0000013E
	strb r1, [r5, r0]
	add sp, #0xc8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F1268: .word 0x0000FFF9
_021F126C: .word 0x000001ED
_021F1270: .word 0x00000143
_021F1274: .word 0x0000013F
_021F1278: .word 0x00000141
_021F127C: .word 0x00000142
_021F1280: .word 0x0000013E
_021F1284: .word ov112_021F0F70
	thumb_func_end ov112_021F0F90

	thumb_func_start ov112_021F1288
ov112_021F1288: ; 0x021F1288
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	bne _021F1292
	bl GF_AssertFail
_021F1292:
	ldr r0, [r5, #0x14]
	cmp r0, #0
	bne _021F129C
	bl GF_AssertFail
_021F129C:
	mov r1, #0x1b
	add r2, r1, #0
	ldr r3, [r5, #4]
	mov r0, #1
	add r2, #0xf8
	bl NewMsgDataFromNarc
	str r0, [r5, #0x5c]
	ldr r3, [r5, #4]
	mov r0, #1
	mov r1, #0x1b
	mov r2, #0xed
	bl NewMsgDataFromNarc
	str r0, [r5, #0x60]
	ldr r3, [r5, #4]
	mov r0, #1
	mov r1, #0x1b
	mov r2, #0xde
	bl NewMsgDataFromNarc
	str r0, [r5, #0x64]
	ldr r2, [r5, #4]
	mov r0, #0xd
	mov r1, #0x20
	bl MessageFormat_New_Custom
	add r4, r5, #0
	ldr r6, _021F1320 ; =ov112_021FF350
	str r0, [r5, #0x58]
	mov r7, #0
	add r4, #0x18
_021F12DC:
	ldr r0, [r5, #0x14]
	add r1, r4, #0
	add r2, r6, #0
	bl AddWindow
	add r7, r7, #1
	add r6, #8
	add r4, #0x10
	cmp r7, #4
	blt _021F12DC
	mov r2, #0
	str r2, [sp]
	ldr r0, [r5, #0x14]
	mov r1, #2
	mov r3, #1
	bl BG_FillCharDataRange
	mov r1, #7
	ldr r2, [r5, #4]
	mov r0, #0
	lsl r1, r1, #6
	bl LoadFontPal1
	mov r1, #7
	ldr r2, [r5, #4]
	mov r0, #4
	lsl r1, r1, #6
	bl LoadFontPal1
	ldr r1, [r5, #4]
	mov r0, #4
	bl FontID_Alloc
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F1320: .word ov112_021FF350
	thumb_func_end ov112_021F1288

	thumb_func_start ov112_021F1324
ov112_021F1324: ; 0x021F1324
	push {r4, r5, r6, lr}
	add r6, r0, #0
	add r5, r6, #0
	mov r4, #0
	add r5, #0x18
_021F132E:
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #4
	blt _021F132E
	ldr r0, [r6, #0x58]
	bl MessageFormat_Delete
	ldr r0, [r6, #0x5c]
	bl DestroyMsgData
	ldr r0, [r6, #0x60]
	bl DestroyMsgData
	ldr r0, [r6, #0x64]
	bl DestroyMsgData
	mov r0, #4
	bl FontID_Release
	pop {r4, r5, r6, pc}
	thumb_func_end ov112_021F1324

	thumb_func_start ov112_021F135C
ov112_021F135C: ; 0x021F135C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r1, #0
	add r5, r0, #0
	add r7, r2, #0
	str r3, [sp, #0x10]
	cmp r6, #4
	blo _021F1370
	bl GF_AssertFail
_021F1370:
	add r4, r5, #0
	add r4, #0x18
	lsl r6, r6, #4
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x58]
	ldr r1, [r5, #0x5c]
	ldr r3, [r5, #4]
	add r2, r7, #0
	bl ReadMsgData_ExpandPlaceholders
	add r5, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F13B8 ; =0x00010200
	add r2, r5, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r1, [sp, #0x28]
	ldr r3, [sp, #0x10]
	add r0, r4, r6
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	add r0, r4, r6
	bl CopyWindowToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021F13B8: .word 0x00010200
	thumb_func_end ov112_021F135C

	thumb_func_start ov112_021F13BC
ov112_021F13BC: ; 0x021F13BC
	push {r3, r4, lr}
	sub sp, #4
	mov r4, #1
	str r4, [sp]
	bl ov112_021F135C
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov112_021F13BC

	thumb_func_start ov112_021F13CC
ov112_021F13CC: ; 0x021F13CC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r1, #0
	add r5, r0, #0
	str r0, [sp, #0x10]
	add r0, #0x38
	mov r1, #0
	add r4, r2, #0
	str r0, [sp, #0x10]
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x58]
	ldr r1, [r5, #0x5c]
	ldr r3, [r5, #4]
	add r2, r6, #0
	bl ReadMsgData_ExpandPlaceholders
	add r6, r0, #0
	cmp r4, #0
	beq _021F145A
	ldr r0, [r5, #0x58]
	ldr r1, [r5, #0x5c]
	ldr r3, [r5, #4]
	add r2, r4, #0
	bl ReadMsgData_ExpandPlaceholders
	add r7, r0, #0
	add r0, r6, #0
	bl String_GetLength
	add r4, r0, #0
	add r0, r7, #0
	bl String_GetLength
	add r0, r4, r0
	ldr r1, [r5, #4]
	add r0, r0, #2
	bl String_New
	add r1, r6, #0
	add r4, r0, #0
	bl String_Copy
	mov r1, #0xe
	add r0, r4, #0
	lsl r1, r1, #0xc
	bl String_AddChar
	add r0, r4, #0
	add r1, r7, #0
	bl String_Cat
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F1484 ; =0x00010200
	mov r1, #1
	str r0, [sp, #8]
	ldr r0, [sp, #0x10]
	add r2, r4, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	b _021F1472
_021F145A:
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F1484 ; =0x00010200
	mov r1, #1
	str r0, [sp, #8]
	ldr r0, [sp, #0x10]
	add r2, r6, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_021F1472:
	add r0, r6, #0
	bl String_Delete
	ldr r0, [sp, #0x10]
	bl CopyWindowToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021F1484: .word 0x00010200
	thumb_func_end ov112_021F13CC

	thumb_func_start ov112_021F1488
ov112_021F1488: ; 0x021F1488
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #1
	str r2, [sp, #8]
	add r6, r1, #0
	add r4, r3, #0
	str r0, [sp, #0xc]
	ldr r1, [r5, #4]
	add r0, r4, #0
	bl String_New
	add r7, r0, #0
	ldrh r0, [r6]
	cmp r0, #0
	beq _021F14C6
	mov r2, #0
	cmp r4, #0
	ble _021F14C6
	ldr r0, _021F14FC ; =0x0000FFFF
	add r3, r6, #0
_021F14B2:
	ldrh r1, [r3]
	cmp r1, r0
	bne _021F14BE
	mov r0, #0
	str r0, [sp, #0xc]
	b _021F14C6
_021F14BE:
	add r2, r2, #1
	add r3, r3, #2
	cmp r2, r4
	blt _021F14B2
_021F14C6:
	ldr r0, [sp, #0xc]
	cmp r0, #0
	beq _021F14D6
	ldr r1, _021F1500 ; =ov112_021FF2EC
	add r0, r7, #0
	bl CopyU16ArrayToString
	b _021F14DE
_021F14D6:
	add r0, r7, #0
	add r1, r6, #0
	bl CopyU16ArrayToString
_021F14DE:
	mov r0, #1
	str r0, [sp]
	mov r3, #2
	str r3, [sp, #4]
	ldr r0, [r5, #0x58]
	ldr r1, [sp, #8]
	add r2, r7, #0
	bl BufferString
	add r0, r7, #0
	bl String_Delete
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F14FC: .word 0x0000FFFF
_021F1500: .word ov112_021FF2EC
	thumb_func_end ov112_021F1488

	thumb_func_start ov112_021F1504
ov112_021F1504: ; 0x021F1504
	push {r4, r5, r6, lr}
	sub sp, #0x28
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #2
	cmp r1, r0
	bls _021F1514
	add r1, r0, #0
_021F1514:
	ldr r0, [r5, #0x64]
	bl NewString_ReadMsgData
	add r6, r0, #0
	bl String_GetLength
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	add r0, r6, #0
	add r1, sp, #0
	mov r2, #0x13
	bl CopyStringToU16Array
	add r0, r5, #0
	add r1, sp, #0
	mov r2, #4
	add r3, r4, #0
	bl ov112_021F1488
	add r0, r6, #0
	bl String_Delete
	add sp, #0x28
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1504

	thumb_func_start ov112_021F1548
ov112_021F1548: ; 0x021F1548
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r0, [r5, #0x60]
	add r6, r1, #0
	add r1, r2, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	bl String_GetLength
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	add r0, r4, #0
	add r1, sp, #0
	add r2, r7, #0
	bl CopyStringToU16Array
	add r0, r5, #0
	add r1, sp, #0
	add r2, r6, #0
	add r3, r7, #0
	bl ov112_021F1488
	add r0, r4, #0
	bl String_Delete
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov112_021F1548

	thumb_func_start ov112_021F1584
ov112_021F1584: ; 0x021F1584
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldrh r0, [r1]
	add r7, r2, #0
	mov r4, #1
	mov ip, r3
	cmp r0, #0
	beq _021F15AC
	ldr r0, _021F15C8 ; =0x0000FFFF
	mov r3, #0
	add r5, r1, #0
_021F159A:
	ldrh r2, [r5]
	cmp r2, r0
	bne _021F15A4
	mov r4, #0
	b _021F15AC
_021F15A4:
	add r3, r3, #1
	add r5, r5, #2
	cmp r3, #0xb
	blt _021F159A
_021F15AC:
	cmp r4, #0
	beq _021F15BC
	add r0, r6, #0
	add r1, r7, #0
	mov r2, ip
	bl ov112_021F1548
	pop {r3, r4, r5, r6, r7, pc}
_021F15BC:
	add r0, r6, #0
	add r2, r7, #0
	mov r3, #0xb
	bl ov112_021F1488
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F15C8: .word 0x0000FFFF
	thumb_func_end ov112_021F1584

	thumb_func_start ov112_021F15CC
ov112_021F15CC: ; 0x021F15CC
	push {r4, lr}
	sub sp, #8
	ldr r4, [sp, #0x10]
	str r4, [sp]
	mov r4, #1
	str r4, [sp, #4]
	ldr r0, [r0, #0x58]
	bl BufferIntegerAsString
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F15CC

	thumb_func_start ov112_021F15E4
ov112_021F15E4: ; 0x021F15E4
	push {r3, r4, lr}
	sub sp, #0x1c
	ldr r4, _021F1620 ; =0x0000013D
	add r1, r0, #0
	ldrb r0, [r1, r4]
	mov r3, #0
	lsl r0, r0, #2
	add r0, r1, r0
	add r0, #0xc0
	ldr r2, [r0]
	add r0, sp, #0xc
	str r3, [r0]
	str r3, [r0, #4]
	str r3, [r0, #8]
	str r3, [r0, #0xc]
	add r0, sp, #0
	str r3, [r0]
	str r3, [r0, #4]
	str r3, [r0, #8]
	add r0, r4, #0
	sub r0, #0x1d
	sub r4, #0xd
	add r0, r1, r0
	ldr r2, [r2]
	add r1, r1, r4
	bl RTC_ConvertSecondToDateTime
	add sp, #0x1c
	pop {r3, r4, pc}
	nop
_021F1620: .word 0x0000013D
	thumb_func_end ov112_021F15E4

	thumb_func_start ov112_021F1624
ov112_021F1624: ; 0x021F1624
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, _021F1788 ; =0x0000013D
	str r1, [sp, #4]
	ldrb r1, [r5, r0]
	str r2, [sp, #8]
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r6, [r1]
	add r1, r0, #0
	sub r1, #0x19
	ldr r1, [r5, r1]
	str r1, [sp, #0x10]
	add r1, r0, #0
	sub r1, #0x15
	sub r0, #0xd
	ldr r1, [r5, r1]
	ldr r4, [r5, r0]
	str r1, [sp, #0xc]
	cmp r4, #0xc
	bge _021F165C
	mov r7, #0x57
	cmp r4, #0
	bne _021F1664
	mov r4, #0xc
	b _021F1664
_021F165C:
	mov r7, #0x58
	sub r4, #0xc
	bne _021F1664
	mov r4, #0xc
_021F1664:
	ldr r1, [r5, #8]
	add r0, r5, #0
	mov r2, #0
	mov r3, #9
	bl ov112_021F1488
	add r1, r6, #0
	ldrh r3, [r6, #0xa]
	add r0, r5, #0
	add r1, #0x20
	mov r2, #1
	bl ov112_021F1584
	add r1, r6, #0
	add r0, r5, #0
	add r1, #0x10
	mov r2, #2
	mov r3, #9
	bl ov112_021F1488
	add r1, r6, #0
	ldrh r3, [r6, #0xc]
	add r0, r5, #0
	add r1, #0x36
	mov r2, #3
	bl ov112_021F1584
	ldrh r1, [r6, #0xe]
	add r0, r5, #0
	bl ov112_021F1504
	add r1, r6, #0
	ldrh r3, [r6, #0xc]
	add r0, r5, #0
	add r1, #0x36
	mov r2, #5
	bl ov112_021F1584
	mov r0, #0
	str r0, [sp]
	add r0, r5, #0
	mov r1, #6
	add r2, r4, #0
	mov r3, #2
	bl ov112_021F15CC
	mov r0, #0
	add r2, r6, #0
	str r0, [sp]
	add r2, #0x78
	ldrh r2, [r2]
	add r0, r5, #0
	mov r1, #7
	mov r3, #5
	bl ov112_021F15CC
	add r6, #0x4c
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #8
	mov r3, #0x15
	bl ov112_021F1488
	mov r0, #0
	str r0, [sp]
	ldr r2, [sp, #0x10]
	add r0, r5, #0
	mov r1, #9
	mov r3, #2
	bl ov112_021F15CC
	mov r0, #0
	str r0, [sp]
	ldr r2, [sp, #0xc]
	add r0, r5, #0
	mov r1, #0xa
	mov r3, #2
	bl ov112_021F15CC
	ldr r1, [sp, #4]
	ldr r2, [sp, #8]
	add r0, r5, #0
	bl ov112_021F13CC
	mov r0, #1
	str r0, [sp]
	ldr r2, [sp, #0x10]
	add r0, r5, #0
	mov r1, #9
	mov r3, #2
	bl ov112_021F15CC
	mov r0, #1
	str r0, [sp]
	ldr r2, [sp, #0xc]
	add r0, r5, #0
	mov r1, #0xa
	mov r3, #2
	bl ov112_021F15CC
	mov r1, #0
	add r0, r5, #0
	mov r2, #0x56
	add r3, r1, #0
	bl ov112_021F13BC
	mov r0, #1
	str r0, [sp]
	add r0, r5, #0
	mov r1, #6
	add r2, r4, #0
	mov r3, #2
	bl ov112_021F15CC
	ldr r0, [r5, #0x58]
	ldr r1, [r5, #0x5c]
	ldr r3, [r5, #4]
	add r2, r7, #0
	bl ReadMsgData_ExpandPlaceholders
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x28
	bl GetWindowWidth
	add r3, r0, #0
	mov r0, #1
	add r1, r4, #0
	mov r2, #0
	lsl r3, r3, #3
	bl FontID_String_GetCenterAlignmentX
	add r6, r0, #0
	add r0, r4, #0
	bl String_Delete
	lsl r3, r6, #0x18
	add r0, r5, #0
	mov r1, #1
	add r2, r7, #0
	lsr r3, r3, #0x18
	bl ov112_021F13BC
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021F1788: .word 0x0000013D
	thumb_func_end ov112_021F1624

	thumb_func_start ov112_021F178C
ov112_021F178C: ; 0x021F178C
	push {r3, lr}
	mov r3, #4
	mov r1, #3
	mov r2, #0x59
	str r3, [sp]
	bl ov112_021F135C
	pop {r3, pc}
	thumb_func_end ov112_021F178C

	thumb_func_start ov112_021F179C
ov112_021F179C: ; 0x021F179C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0xa0
	add r5, r0, #0
	ldr r0, [r5, #4]
	bl BgConfig_Alloc
	add r3, sp, #4
	ldr r4, _021F1808 ; =ov112_021FF2F4
	str r0, [r5, #0x14]
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r4, _021F180C ; =ov112_021FF434
	add r3, sp, #0x14
	mov r2, #0x11
_021F17C4:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F17C4
	ldr r0, [r4]
	ldr r4, _021F1810 ; =ov112_021FF4C0
	str r0, [r3]
	mov r7, #0
	add r6, sp, #0x14
_021F17D6:
	ldrb r1, [r4]
	ldr r0, [r5, #0x14]
	add r2, r6, #0
	mov r3, #0
	bl InitBgFromTemplate
	ldrb r1, [r4]
	ldr r0, [r5, #0x14]
	bl BgClearTilemapBufferAndCommit
	mov r0, #0
	str r0, [sp]
	ldrb r1, [r4]
	ldr r0, [r5, #0x14]
	mov r2, #0
	mov r3, #1
	bl BG_FillCharDataRange
	add r7, r7, #1
	add r6, #0x1c
	add r4, r4, #1
	cmp r7, #5
	blt _021F17D6
	add sp, #0xa0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F1808: .word ov112_021FF2F4
_021F180C: .word ov112_021FF434
_021F1810: .word ov112_021FF4C0
	thumb_func_end ov112_021F179C

	thumb_func_start ov112_021F1814
ov112_021F1814: ; 0x021F1814
	push {r4, r5, r6, lr}
	ldr r5, _021F1834 ; =ov112_021FF4C0
	add r6, r0, #0
	mov r4, #0
_021F181C:
	ldrb r1, [r5]
	ldr r0, [r6, #0x14]
	bl FreeBgTilemapBuffer
	add r4, r4, #1
	add r5, r5, #1
	cmp r4, #5
	blt _021F181C
	ldr r0, [r6, #0x14]
	bl Heap_Free
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F1834: .word ov112_021FF4C0
	thumb_func_end ov112_021F1814

	thumb_func_start ov112_021F1838
ov112_021F1838: ; 0x021F1838
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, [r4, #0x14]
	cmp r0, #0
	bne _021F1848
	bl GF_AssertFail
_021F1848:
	mov r1, #0
	str r1, [sp]
	ldr r0, [r4, #4]
	add r2, r1, #0
	str r0, [sp, #4]
	ldr r0, [r4, #0x10]
	add r3, r1, #0
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r3, #0
	str r3, [sp]
	str r3, [sp, #4]
	mov r1, #1
	str r1, [sp, #8]
	ldr r0, [r4, #4]
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0x14]
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r3, #0
	str r3, [sp]
	str r3, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	mov r1, #2
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0x14]
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r1, #1
	str r0, [sp, #4]
	str r1, [sp, #8]
	ldr r0, [r4, #4]
	add r3, r1, #0
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0x14]
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r3, #1
	str r3, [sp, #8]
	ldr r0, [r4, #4]
	mov r1, #3
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0x14]
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r3, #0
	str r3, [sp]
	ldr r0, [r4, #4]
	mov r1, #9
	str r0, [sp, #4]
	ldr r0, [r4, #0x10]
	mov r2, #4
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	mov r1, #0xa
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0x14]
	mov r3, #4
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	mov r1, #0xb
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0x14]
	mov r3, #4
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1838

	thumb_func_start ov112_021F1904
ov112_021F1904: ; 0x021F1904
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	cmp r1, #6
	blo _021F1916
	cmp r1, #0x10
	bhs _021F1916
	mov r1, #0
	b _021F1924
_021F1916:
	cmp r1, #0x10
	blo _021F1922
	cmp r1, #0x13
	bhs _021F1922
	mov r1, #1
	b _021F1924
_021F1922:
	mov r1, #2
_021F1924:
	cmp r2, #5
	bne _021F192E
	add r0, r1, #3
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
_021F192E:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r3, #1
	str r3, [sp, #8]
	ldr r0, [r4, #4]
	add r1, r1, #3
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	ldr r2, [r4, #0x14]
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1904

	thumb_func_start ov112_021F194C
ov112_021F194C: ; 0x021F194C
	push {r4, lr}
	add r4, r1, #0
	cmp r4, #8
	blo _021F1958
	bl GF_AssertFail
_021F1958:
	ldr r0, _021F1968 ; =ov112_021FF9B8
	lsl r1, r4, #2
	ldr r0, [r0, r1]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl PlayBGM
	pop {r4, pc}
	.balign 4, 0
_021F1968: .word ov112_021FF9B8
	thumb_func_end ov112_021F194C

	thumb_func_start ov112_021F196C
ov112_021F196C: ; 0x021F196C
	push {r3, r4, r5, r6, lr}
	sub sp, #0x4c
	add r5, r0, #0
	ldr r0, [r5, #4]
	bl SpriteSystem_Alloc
	str r0, [r5, #0x68]
	bl SpriteManager_New
	add r2, sp, #0x2c
	ldr r3, _021F19FC ; =ov112_021FF330
	str r0, [r5, #0x6c]
	ldmia r3!, {r0, r1}
	add r4, r2, #0
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	ldr r6, _021F1A00 ; =ov112_021FF304
	stmia r2!, {r0, r1}
	add r3, sp, #0x18
	ldmia r6!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r6]
	add r1, r4, #0
	str r0, [r3]
	mov r3, #0x20
	str r3, [sp, #0x18]
	ldr r0, [r5, #0x68]
	bl SpriteSystem_Init
	ldr r0, [r5, #0x68]
	ldr r1, [r5, #0x6c]
	mov r2, #0x20
	bl SpriteSystem_InitSprites
	ldr r4, _021F1A04 ; =ov112_021FF318
	add r3, sp, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5, #0x68]
	ldr r1, [r5, #0x6c]
	bl SpriteSystem_InitManagerWithCapacities
	ldr r0, [r5, #0x68]
	bl SpriteSystem_GetRenderer
	mov r2, #0x83
	mov r1, #0
	lsl r2, r2, #0xe
	bl G2dRenderer_SetSubSurfaceCoords
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add sp, #0x4c
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021F19FC: .word ov112_021FF330
_021F1A00: .word ov112_021FF304
_021F1A04: .word ov112_021FF318
	thumb_func_end ov112_021F196C

	thumb_func_start ov112_021F1A08
ov112_021F1A08: ; 0x021F1A08
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r6, [r5, #0x68]
	ldr r7, [r5, #0x6c]
	bl ov112_021F1FD0
	mov r4, #0
_021F1A16:
	ldr r0, [r5, #0x70]
	cmp r0, #0
	bne _021F1A20
	bl GF_AssertFail
_021F1A20:
	ldr r0, [r5, #0x70]
	bl Sprite_DeleteAndFreeResources
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0xa
	blt _021F1A16
	add r0, r6, #0
	add r1, r7, #0
	bl SpriteSystem_FreeResourcesAndManager
	add r0, r6, #0
	bl SpriteSystem_Free
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1A08

	thumb_func_start ov112_021F1A40
ov112_021F1A40: ; 0x021F1A40
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r6, [r5, #0x68]
	ldr r4, [r5, #0x6c]
	mov r1, #0
	str r1, [sp]
	mov r3, #0xc
	str r3, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	mov r3, #0xd
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	mov r3, #0xf
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	mov r3, #0xe
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	mov r3, #0x10
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	mov r3, #0x11
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	mov r3, #0x13
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r2, [r5, #0x10]
	add r0, r6, #0
	add r1, r4, #0
	mov r3, #0x12
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x10
	pop {r4, r5, r6, pc}
	thumb_func_end ov112_021F1A40

	thumb_func_start ov112_021F1AF4
ov112_021F1AF4: ; 0x021F1AF4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	ldr r4, _021F1B40 ; =ov112_021FF398
	add r6, r2, #0
	add r5, r3, #0
	add r7, r0, #0
	mov ip, r1
	add r3, sp, #0
	mov r2, #6
_021F1B06:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F1B06
	ldr r0, [r4]
	add r1, sp, #0
	str r0, [r3]
	strh r6, [r1]
	strh r5, [r1, #2]
	add r0, sp, #0x38
	ldrb r2, [r0, #0x14]
	mov r3, #0x83
	lsl r3, r3, #0xe
	str r2, [sp, #8]
	ldrb r0, [r0, #0x10]
	add r2, sp, #0
	strh r0, [r1, #6]
	add r0, r7, #0
	mov r1, ip
	bl SpriteSystem_NewSpriteWithYOffset
	mov r1, #1
	add r4, r0, #0
	bl ManagedSprite_SetAnimateFlag
	add r0, r4, #0
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_021F1B40: .word ov112_021FF398
	thumb_func_end ov112_021F1AF4

	thumb_func_start ov112_021F1B44
ov112_021F1B44: ; 0x021F1B44
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	ldr r4, _021F1B90 ; =ov112_021FF3CC
	add r6, r2, #0
	add r5, r3, #0
	add r7, r0, #0
	mov ip, r1
	add r3, sp, #0
	mov r2, #6
_021F1B56:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F1B56
	ldr r0, [r4]
	add r1, sp, #0
	str r0, [r3]
	strh r6, [r1]
	strh r5, [r1, #2]
	add r0, sp, #0x38
	ldrb r2, [r0, #0x14]
	mov r3, #0x83
	lsl r3, r3, #0xe
	str r2, [sp, #8]
	ldrb r0, [r0, #0x10]
	add r2, sp, #0
	strh r0, [r1, #6]
	add r0, r7, #0
	mov r1, ip
	bl SpriteSystem_NewSpriteWithYOffset
	mov r1, #1
	add r4, r0, #0
	bl ManagedSprite_SetAnimateFlag
	add r0, r4, #0
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_021F1B90: .word ov112_021FF3CC
	thumb_func_end ov112_021F1B44

	thumb_func_start ov112_021F1B94
ov112_021F1B94: ; 0x021F1B94
	push {r4, lr}
	sub sp, #8
	add r4, r0, #0
	mov r0, #8
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x20
	mov r3, #0xb0
	bl ov112_021F1AF4
	str r0, [r4, #0x70]
	mov r0, #9
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x50
	mov r3, #0xb0
	bl ov112_021F1AF4
	str r0, [r4, #0x74]
	mov r0, #0xa
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0xd8
	mov r3, #0xb0
	bl ov112_021F1AF4
	str r0, [r4, #0x78]
	mov r0, #0
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x80
	mov r3, #0x44
	bl ov112_021F1AF4
	str r0, [r4, #0x7c]
	mov r0, #0xc
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x68
	mov r3, #0x38
	bl ov112_021F1AF4
	add r1, r4, #0
	add r1, #0x80
	str r0, [r1]
	mov r0, #0xc
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x98
	mov r3, #0x38
	bl ov112_021F1AF4
	add r1, r4, #0
	add r1, #0x84
	str r0, [r1]
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x68
	mov r3, #0x28
	bl ov112_021F1AF4
	add r1, r4, #0
	add r1, #0x94
	str r0, [r1]
	mov r0, #8
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x68
	mov r3, #0x28
	bl ov112_021F1B44
	add r1, r4, #0
	add r1, #0x88
	str r0, [r1]
	mov r0, #8
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x98
	mov r3, #0x28
	bl ov112_021F1B44
	add r1, r4, #0
	add r1, #0x8c
	str r0, [r1]
	mov r0, #8
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r4, #0x68]
	ldr r1, [r4, #0x6c]
	mov r2, #0x80
	mov r3, #0x28
	bl ov112_021F1B44
	add r1, r4, #0
	add r1, #0x90
	str r0, [r1]
	add r0, r4, #0
	bl ov112_021F1F80
	add r0, r4, #0
	mov r1, #0
	bl ov112_021F1CC8
	ldr r0, [r4, #0x70]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F1CC4 ; =0x0000013D
	ldrb r1, [r4, r0]
	add r0, r0, #1
	ldrb r0, [r4, r0]
	sub r0, r0, #1
	cmp r1, r0
	bge _021F1CB6
	mov r1, #1
	b _021F1CB8
_021F1CB6:
	mov r1, #0
_021F1CB8:
	ldr r0, [r4, #0x74]
	bl ManagedSprite_SetDrawFlag
	add sp, #8
	pop {r4, pc}
	nop
_021F1CC4: .word 0x0000013D
	thumb_func_end ov112_021F1B94

	thumb_func_start ov112_021F1CC8
ov112_021F1CC8: ; 0x021F1CC8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x98
	add r4, r1, #0
	bl ov112_021F1EFC
	add r0, r5, #0
	add r0, #0xac
	add r1, r4, #0
	bl ov112_021F1EFC
	add r0, r5, #0
	add r0, #0x80
	ldr r0, [r0]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r0, #0x84
	ldr r0, [r0]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r0, #0x88
	ldr r0, [r0]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r0, #0x94
	ldr r0, [r0]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r0, #0x8c
	ldr r0, [r0]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	add r5, #0x90
	ldr r0, [r5]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1CC8

	thumb_func_start ov112_021F1D28
ov112_021F1D28: ; 0x021F1D28
	push {r3, r4, r5, lr}
	add r4, r0, #0
	lsl r5, r1, #2
	add r4, #0x70
	ldr r0, [r4, r5]
	bl ManagedSprite_GetDrawFlag
	cmp r0, #0
	beq _021F1D56
	ldr r0, [r4, r5]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _021F1D56
	ldr r0, [r4, r5]
	bl ManagedSprite_GetActiveAnim
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	ldr r0, [r4, r5]
	bl ManagedSprite_SetAnim
_021F1D56:
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021F1D28

	thumb_func_start ov112_021F1D58
ov112_021F1D58: ; 0x021F1D58
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #8
	blo _021F1D66
	bl GF_AssertFail
_021F1D66:
	ldr r0, [r5, #0x7c]
	add r1, r4, #0
	bl ManagedSprite_SetAnimNoRestart
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021F1D58

	thumb_func_start ov112_021F1D70
ov112_021F1D70: ; 0x021F1D70
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r7, r1, #0
	str r2, [sp]
	add r5, r3, #0
	bl Sprite_GetVramType
	add r4, r0, #0
	add r0, r6, #0
	bl Sprite_GetImageProxy
	add r1, r4, #0
	bl NNS_G2dGetImageLocation
	add r6, r0, #0
	ldr r1, [sp]
	add r0, r7, #0
	bl DC_FlushRange
	cmp r4, #1
	beq _021F1DA0
	cmp r4, #2
	beq _021F1DAC
	b _021F1DB8
_021F1DA0:
	ldr r2, [sp]
	add r0, r7, #0
	add r1, r6, r5
	bl GX_LoadOBJ
	pop {r3, r4, r5, r6, r7, pc}
_021F1DAC:
	ldr r2, [sp]
	add r0, r7, #0
	add r1, r6, r5
	bl GXS_LoadOBJ
	pop {r3, r4, r5, r6, r7, pc}
_021F1DB8:
	bl GF_AssertFail
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1D70

	thumb_func_start ov112_021F1DC0
ov112_021F1DC0: ; 0x021F1DC0
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x4f
	lsl r0, r0, #2
	ldrb r0, [r4, r0]
	ldr r6, [r4, #0x68]
	ldr r5, [r4, #0x6c]
	cmp r0, #3
	bls _021F1DD6
	b _021F1EF0
_021F1DD6:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F1DE2: ; jump table
	.short _021F1DEA - _021F1DE2 - 2 ; case 0
	.short _021F1E2A - _021F1DE2 - 2 ; case 1
	.short _021F1E8A - _021F1DE2 - 2 ; case 2
	.short _021F1EEA - _021F1DE2 - 2 ; case 3
_021F1DEA:
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0xc
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #3
	str r0, [sp, #0xc]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0xc
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r0, #0x4f
	lsl r0, r0, #2
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021F1EF4
_021F1E2A:
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x14
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x14
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x15
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x16
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #0x4f
	lsl r0, r0, #2
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021F1EF4
_021F1E8A:
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x17
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #5
	str r0, [sp, #8]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x17
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x18
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	ldr r2, [r4, #0x10]
	add r0, r6, #0
	add r1, r5, #0
	mov r3, #0x19
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #0x4f
	lsl r0, r0, #2
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021F1EF4
_021F1EEA:
	add sp, #0x10
	mov r0, #1
	pop {r4, r5, r6, pc}
_021F1EF0:
	bl GF_AssertFail
_021F1EF4:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1DC0

	thumb_func_start ov112_021F1EFC
ov112_021F1EFC: ; 0x021F1EFC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bne _021F1F14
	ldr r0, [r5, #0xc]
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	b _021F1F28
_021F1F14:
	ldr r0, [r5]
	cmp r0, #0
	beq _021F1F22
	ldr r0, [r5, #0xc]
	bl ManagedSprite_SetDrawFlag
	b _021F1F28
_021F1F22:
	ldr r0, [r5, #8]
	bl ManagedSprite_SetDrawFlag
_021F1F28:
	ldr r0, [r5, #4]
	sub r0, #0x32
	cmp r0, #1
	bhi _021F1F32
	mov r4, #0
_021F1F32:
	ldr r0, [r5, #0x10]
	add r1, r4, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021F1EFC

	thumb_func_start ov112_021F1F3C
ov112_021F1F3C: ; 0x021F1F3C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	add r4, r1, #0
	bl ManagedSprite_SetAnimNoRestart
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl ManagedSprite_SetAnimNoRestart
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1F3C

	thumb_func_start ov112_021F1F54
ov112_021F1F54: ; 0x021F1F54
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	add r4, r1, #0
	add r6, r2, #0
	add r7, r3, #0
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #8]
	add r1, r4, #0
	add r2, r6, #0
	bl ManagedSprite_SetPositionXY
	cmp r7, #0
	bne _021F1F7C
	ldr r0, [r5, #0x10]
	add r1, r4, #0
	add r2, r6, #0
	bl ManagedSprite_SetPositionXY
_021F1F7C:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F1F54

	thumb_func_start ov112_021F1F80
ov112_021F1F80: ; 0x021F1F80
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	add r0, r4, #0
	ldr r1, [r4, #0x68]
	ldr r2, [r4, #0x6c]
	add r0, #0x98
	mov r3, #0x68
	bl ov112_021F2000
	add r0, r4, #0
	add r0, #0x98
	mov r1, #3
	bl ov112_021F1F3C
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	add r0, r4, #0
	ldr r1, [r4, #0x68]
	ldr r2, [r4, #0x6c]
	add r0, #0xac
	mov r3, #0x98
	bl ov112_021F2000
	add r4, #0xac
	add r0, r4, #0
	mov r1, #1
	bl ov112_021F1F3C
	add sp, #0xc
	pop {r3, r4, pc}
	thumb_func_end ov112_021F1F80

	thumb_func_start ov112_021F1FD0
ov112_021F1FD0: ; 0x021F1FD0
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r7, #0
_021F1FD6:
	mov r4, #0
	add r5, r6, #0
_021F1FDA:
	add r0, r5, #0
	add r0, #0xa0
	ldr r0, [r0]
	bl Sprite_DeleteAndFreeResources
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #2
	blt _021F1FDA
	add r0, r6, #0
	add r0, #0xa8
	ldr r0, [r0]
	bl Sprite_DeleteAndFreeResources
	add r7, r7, #1
	add r6, #0x14
	cmp r7, #2
	blt _021F1FD6
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov112_021F1FD0

	thumb_func_start ov112_021F2000
ov112_021F2000: ; 0x021F2000
	push {r4, r5, r6, r7, lr}
	sub sp, #0x54
	str r3, [sp, #0x14]
	str r2, [sp, #0x10]
	ldr r7, [sp, #0x68]
	ldr r2, [sp, #0x70]
	ldr r5, _021F2094 ; =ov112_021FF400
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r4, sp, #0x20
	mov r3, #6
_021F2016:
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	sub r3, r3, #1
	bne _021F2016
	ldr r0, [r5]
	ldr r5, [sp, #8]
	str r0, [r4]
	add r0, sp, #0x58
	ldrb r0, [r0, #0x14]
	add r4, r2, #2
	mov r6, #0
	str r0, [sp, #0x18]
	str r4, [sp, #0x1c]
_021F2030:
	ldr r1, [sp, #0x14]
	add r0, sp, #0x20
	strh r1, [r0]
	strh r7, [r0, #2]
	mov r0, #3
	str r0, [sp, #0x28]
	ldr r1, [sp, #0x18]
	add r0, sp, #0x20
	strh r1, [r0, #6]
	ldr r0, [sp, #0x1c]
	mov r3, #0x83
	str r0, [sp, #0x38]
	add r0, r6, #2
	str r0, [sp, #0x3c]
	str r0, [sp, #0x40]
	ldr r0, [sp, #0xc]
	ldr r1, [sp, #0x10]
	str r4, [sp, #0x34]
	add r2, sp, #0x20
	lsl r3, r3, #0xe
	bl SpriteSystem_NewSpriteWithYOffset
	str r0, [r5, #8]
	mov r1, #1
	bl ManagedSprite_SetAnimateFlag
	ldr r0, [r5, #8]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r6, r6, #1
	add r4, r4, #2
	add r5, r5, #4
	cmp r6, #2
	blt _021F2030
	mov r0, #0x17
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, [sp, #0xc]
	ldr r1, [sp, #0x10]
	ldr r2, [sp, #0x14]
	add r3, r7, #0
	bl ov112_021F1AF4
	ldr r1, [sp, #8]
	str r0, [r1, #0x10]
	add sp, #0x54
	pop {r4, r5, r6, r7, pc}
	nop
_021F2094: .word ov112_021FF400
	thumb_func_end ov112_021F2000

	thumb_func_start ov112_021F2098
ov112_021F2098: ; 0x021F2098
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	add r4, r1, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	add r6, r2, #0
	str r3, [sp, #0x10]
	bl SpeciesToOverworldModelIndexOffset
	add r2, r0, #0
	add r0, sp, #0x30
	mov r1, #0x8d
	bl ReadWholeNarcMemberByIdPair
	add r0, sp, #0x2c
	ldrb r0, [r0, #5]
	add r2, sp, #0x2c
	cmp r0, #0
	beq _021F20F2
	ldr r0, [sp, #0xc]
	mov r5, #2
	ldr r0, [r0, #0xc]
	mov r1, #1
	ldr r0, [r0]
	lsl r5, r5, #0xa
	str r0, [sp, #0x1c]
	mov r0, #8
	str r0, [sp, #0x14]
	ldr r0, [sp, #0xc]
	str r1, [r0]
	add r1, sp, #0x2c
	ldr r0, [r0, #0xc]
	add r1, #2
	bl ManagedSprite_GetPositionXY
	ldr r0, [sp, #0xc]
	add r2, sp, #0x2c
	mov r1, #2
	mov r3, #0
	ldrsh r1, [r2, r1]
	ldrsh r2, [r2, r3]
	ldr r0, [r0, #0x10]
	bl ManagedSprite_SetPositionXY
	b _021F2124
_021F20F2:
	ldr r0, [sp, #0xc]
	mov r5, #2
	ldr r0, [r0, #8]
	mov r1, #0
	ldr r0, [r0]
	lsl r5, r5, #8
	str r0, [sp, #0x1c]
	mov r0, #4
	str r0, [sp, #0x14]
	ldr r0, [sp, #0xc]
	str r1, [r0]
	add r1, sp, #0x2c
	ldr r0, [r0, #8]
	add r1, #2
	bl ManagedSprite_GetPositionXY
	ldr r0, [sp, #0xc]
	add r2, sp, #0x2c
	mov r1, #2
	mov r3, #0
	ldrsh r1, [r2, r1]
	ldrsh r2, [r2, r3]
	ldr r0, [r0, #0x10]
	bl ManagedSprite_SetPositionXY
_021F2124:
	ldr r0, [sp, #0xc]
	ldr r7, [sp, #0x4c]
	str r4, [r0, #4]
	mov r0, #0x51
	add r1, r7, #0
	bl NARC_New
	str r0, [sp, #0x28]
	add r0, r4, #0
	add r1, r6, #0
	bl sub_02070438
	cmp r0, #0
	bne _021F2142
	mov r6, #0
_021F2142:
	ldr r2, [sp, #0x10]
	add r0, r4, #0
	add r1, r6, #0
	bl ov112_021F0E14
	add r1, r0, #0
	ldr r0, [sp, #0x28]
	add r2, r7, #0
	bl NARC_AllocAndReadWholeMember
	str r0, [sp, #0x24]
	bl NNS_G3dGetTex
	ldr r1, [r0, #0x14]
	str r0, [sp, #0x20]
	add r0, r0, r1
	str r0, [sp, #0x18]
	add r0, r7, #0
	add r1, r5, #0
	bl Heap_AllocAtEnd
	mov r7, #0
	add r6, r0, #0
	add r4, r7, #0
_021F2172:
	ldr r0, [sp, #0x14]
	mov r2, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [sp, #0x18]
	ldr r1, [sp, #0x14]
	add r0, r0, r4
	add r3, r2, #0
	str r6, [sp, #8]
	bl sub_020145B4
	ldr r0, [sp, #0x1c]
	add r1, r6, #0
	add r2, r5, #0
	add r3, r4, #0
	bl ov112_021F1D70
	add r7, r7, #1
	add r4, r4, r5
	cmp r7, #8
	blt _021F2172
	add r0, r6, #0
	bl Heap_Free
	ldr r0, [sp, #0x1c]
	bl Sprite_GetVramType
	ldr r0, [sp, #0x20]
	ldr r1, [r0, #0x38]
	add r4, r0, r1
	add r0, sp, #0x38
	ldrb r0, [r0, #0x10]
	cmp r0, #0
	beq _021F21B8
	add r4, #0x20
_021F21B8:
	add r0, r4, #0
	mov r1, #0x20
	bl DC_FlushRange
	ldr r0, [sp, #0x1c]
	bl Sprite_GetPaletteProxy
	mov r1, #1
	bl NNS_G2dGetImagePaletteLocation
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0x20
	bl GX_LoadOBJPltt
	ldr r0, [sp, #0x24]
	bl Heap_Free
	ldr r0, [sp, #0x28]
	bl NARC_Delete
	ldr r0, [sp, #0x1c]
	mov r1, #1
	bl thunk_Sprite_SetDrawFlag
	ldr r0, [sp, #0xc]
	mov r1, #1
	ldr r0, [r0, #4]
	sub r0, #0x32
	cmp r0, #1
	bhi _021F21F8
	mov r1, #0
_021F21F8:
	ldr r0, [sp, #0xc]
	ldr r0, [r0, #0x10]
	bl ManagedSprite_SetDrawFlag
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov112_021F2098

	thumb_func_start ov112_021F2204
ov112_021F2204: ; 0x021F2204
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, _021F22AC ; =0x0000013D
	add r6, r1, #0
	ldrb r0, [r5, r0]
	add r7, r2, #0
	lsl r0, r0, #2
	add r0, r5, r0
	add r0, #0xc0
	ldr r4, [r0]
	cmp r6, #0
	bne _021F2238
	add r0, r5, #0
	add r0, #0x98
	mov r1, #0x68
	mov r2, #0x48
	mov r3, #0
	bl ov112_021F1F54
	add r0, r5, #0
	add r0, #0x98
	mov r1, #3
	bl ov112_021F1F3C
	b _021F2250
_021F2238:
	add r0, r5, #0
	add r0, #0xac
	mov r1, #0x98
	mov r2, #0x48
	mov r3, #0
	bl ov112_021F1F54
	add r0, r5, #0
	add r0, #0xac
	mov r1, #1
	bl ov112_021F1F3C
_021F2250:
	cmp r7, #0
	beq _021F2280
	add r0, r4, #0
	mov r1, #1
	bl ov112_021F0F48
	str r0, [sp]
	ldr r0, [r5, #4]
	add r5, #0x98
	str r0, [sp, #4]
	ldrh r1, [r4, #0xa]
	add r4, #0x85
	ldrb r3, [r4]
	mov r0, #0x14
	mul r0, r6
	lsl r2, r3, #0x1b
	lsl r3, r3, #0x19
	add r0, r5, r0
	lsr r2, r2, #0x1b
	lsr r3, r3, #0x1e
	bl ov112_021F2098
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_021F2280:
	add r0, r4, #0
	mov r1, #0
	bl ov112_021F0F48
	str r0, [sp]
	ldr r0, [r5, #4]
	add r5, #0x98
	str r0, [sp, #4]
	ldrh r1, [r4, #0xc]
	add r4, #0x86
	ldrb r3, [r4]
	mov r0, #0x14
	mul r0, r6
	lsl r2, r3, #0x1b
	lsl r3, r3, #0x19
	add r0, r5, r0
	lsr r2, r2, #0x1b
	lsr r3, r3, #0x1e
	bl ov112_021F2098
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F22AC: .word 0x0000013D
	thumb_func_end ov112_021F2204

	thumb_func_start ov112_021F22B0
ov112_021F22B0: ; 0x021F22B0
	push {r3, r4, r5, lr}
	add r4, r2, #0
	add r5, r0, #0
	add r4, #0xf
	cmp r1, #1
	bne _021F22BE
	add r4, r4, #4
_021F22BE:
	add r0, r5, #0
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r1, r4, #0
	bl ManagedSprite_SetAnim
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021F22B0

	thumb_func_start ov112_021F22D0
ov112_021F22D0: ; 0x021F22D0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r0, #0
	add r4, r6, #0
	lsl r5, r2, #2
	add r4, #0x70
	add r7, r1, #0
	add r1, sp, #4
	ldr r0, [r4, r5]
	add r1, #2
	add r2, sp, #4
	str r3, [sp]
	bl ManagedSprite_GetPositionXY
	mov r0, #0x14
	mul r0, r7
	add r0, r6, r0
	add r0, #0x98
	ldr r0, [r0]
	cmp r0, #0
	beq _021F22FE
	mov r0, #0x18
	b _021F2300
_021F22FE:
	mov r0, #0x28
_021F2300:
	add r3, sp, #4
	strh r0, [r3]
	mov r1, #2
	mov r2, #0
	ldrsh r1, [r3, r1]
	ldrsh r2, [r3, r2]
	ldr r0, [r4, r5]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r4, r5]
	ldr r1, [sp]
	bl ManagedSprite_SetAnim
	ldr r0, [r4, r5]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021F22D0

	thumb_func_start ov112_021F2328
ov112_021F2328: ; 0x021F2328
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021F235C
	add r0, r4, #0
	bl ov112_021F24D8
	pop {r4, pc}
	thumb_func_end ov112_021F2328

	thumb_func_start ov112_021F2338
ov112_021F2338: ; 0x021F2338
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021F238C
	add r0, r4, #0
	bl ov112_021F24F8
	pop {r4, pc}
	thumb_func_end ov112_021F2338

	thumb_func_start ov112_021F2348
ov112_021F2348: ; 0x021F2348
	mov r2, #0x52
	lsl r2, r2, #2
	ldr r3, [r0, r2]
	mov r1, #1
	bic r3, r1
	mov r1, #1
	orr r1, r3
	str r1, [r0, r2]
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021F2348

	thumb_func_start ov112_021F235C
ov112_021F235C: ; 0x021F235C
	mov r2, #0x52
	lsl r2, r2, #2
	ldr r3, [r0, r2]
	mov r1, #1
	bic r3, r1
	str r3, [r0, r2]
	ldr r1, [r0, r2]
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	str r1, [r0, r2]
	ldr r3, [r0, r2]
	ldr r1, _021F2384 ; =0xFFFFFE01
	and r1, r3
	str r1, [r0, r2]
	ldr r3, [r0, r2]
	ldr r1, _021F2388 ; =0xFFFF01FF
	and r1, r3
	str r1, [r0, r2]
	bx lr
	nop
_021F2384: .word 0xFFFFFE01
_021F2388: .word 0xFFFF01FF
	thumb_func_end ov112_021F235C

	thumb_func_start ov112_021F238C
ov112_021F238C: ; 0x021F238C
	push {r3, r4, r5, lr}
	mov r3, #0x52
	add r5, r0, #0
	lsl r3, r3, #2
	ldr r2, [r5, r3]
	lsl r0, r2, #0x1f
	lsr r0, r0, #0x1f
	beq _021F23AA
	lsl r0, r2, #0x17
	lsr r0, r0, #0x18
	beq _021F23AE
	cmp r0, #1
	beq _021F2438
	cmp r0, #2
	bne _021F23AC
_021F23AA:
	b _021F24B4
_021F23AC:
	b _021F24B0
_021F23AE:
	lsr r3, r2, #0x10
	ldr r2, _021F24B8 ; =ov112_021FF4C8
	add r0, r5, #0
	ldrsb r3, [r2, r3]
	mov r2, #0x48
	add r0, #0xac
	sub r2, r2, r3
	lsl r2, r2, #0x10
	mov r1, #0x98
	asr r2, r2, #0x10
	mov r3, #1
	bl ov112_021F1F54
	mov r1, #0x52
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	lsl r0, r2, #0x10
	lsr r3, r0, #0x10
	lsr r0, r2, #0x10
	add r0, r0, #1
	lsl r0, r0, #0x10
	orr r0, r3
	str r0, [r5, r1]
	ldr r2, [r5, r1]
	ldr r0, _021F24B8 ; =ov112_021FF4C8
	lsr r3, r2, #0x10
	ldrsb r0, [r0, r3]
	cmp r0, #0x6f
	bne _021F24B4
	lsl r0, r2, #0x10
	lsr r0, r0, #0x10
	str r0, [r5, r1]
	ldr r2, [r5, r1]
	ldr r0, _021F24BC ; =0xFFFF01FF
	and r0, r2
	lsl r2, r2, #0x10
	lsr r2, r2, #0x19
	add r2, r2, #1
	lsl r2, r2, #0x19
	lsr r2, r2, #0x10
	orr r0, r2
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x19
	cmp r0, #2
	blo _021F24B4
	add r0, r5, #0
	add r0, #0xac
	mov r1, #3
	bl ov112_021F1F3C
	mov r1, #0x52
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	ldr r0, _021F24BC ; =0xFFFF01FF
	and r0, r2
	str r0, [r5, r1]
	ldr r2, [r5, r1]
	ldr r0, _021F24C0 ; =0xFFFFFE01
	and r0, r2
	lsl r2, r2, #0x17
	lsr r2, r2, #0x18
	add r2, r2, #1
	lsl r2, r2, #0x18
	lsr r2, r2, #0x17
	orr r0, r2
	str r0, [r5, r1]
	pop {r3, r4, r5, pc}
_021F2438:
	lsr r0, r2, #0x10
	lsl r1, r0, #3
	add r1, #0x98
	lsl r1, r1, #0x10
	asr r4, r1, #0x10
	lsl r1, r2, #0x10
	add r0, r0, #1
	lsr r1, r1, #0x10
	lsl r0, r0, #0x10
	orr r0, r1
	str r0, [r5, r3]
	ldr r0, [r5, r3]
	lsr r0, r0, #0x10
	cmp r0, #5
	blo _021F2468
	mov r1, #1
	and r0, r1
	cmp r0, #1
	beq _021F2460
	mov r1, #0
_021F2460:
	add r0, r5, #0
	add r0, #0xac
	bl ov112_021F1EFC
_021F2468:
	mov r0, #0x52
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	lsr r0, r0, #0x10
	cmp r0, #7
	blo _021F24A0
	add r0, r5, #0
	add r0, #0xac
	mov r1, #0
	bl ov112_021F1EFC
	mov r1, #0x52
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [r5, r1]
	ldr r2, [r5, r1]
	ldr r0, _021F24C0 ; =0xFFFFFE01
	and r0, r2
	lsl r2, r2, #0x17
	lsr r2, r2, #0x18
	add r2, r2, #1
	lsl r2, r2, #0x18
	lsr r2, r2, #0x17
	orr r0, r2
	str r0, [r5, r1]
	pop {r3, r4, r5, pc}
_021F24A0:
	add r5, #0xac
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x48
	mov r3, #0
	bl ov112_021F1F54
	pop {r3, r4, r5, pc}
_021F24B0:
	bl GF_AssertFail
_021F24B4:
	pop {r3, r4, r5, pc}
	nop
_021F24B8: .word ov112_021FF4C8
_021F24BC: .word 0xFFFF01FF
_021F24C0: .word 0xFFFFFE01
	thumb_func_end ov112_021F238C

	thumb_func_start ov112_021F24C4
ov112_021F24C4: ; 0x021F24C4
	mov r2, #0x53
	lsl r2, r2, #2
	ldr r3, [r0, r2]
	mov r1, #1
	bic r3, r1
	mov r1, #1
	orr r1, r3
	str r1, [r0, r2]
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021F24C4

	thumb_func_start ov112_021F24D8
ov112_021F24D8: ; 0x021F24D8
	mov r2, #0x53
	lsl r2, r2, #2
	ldr r3, [r0, r2]
	mov r1, #1
	bic r3, r1
	str r3, [r0, r2]
	ldr r1, [r0, r2]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	str r1, [r0, r2]
	ldr r3, [r0, r2]
	mov r1, #0xfe
	bic r3, r1
	str r3, [r0, r2]
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021F24D8

	thumb_func_start ov112_021F24F8
ov112_021F24F8: ; 0x021F24F8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r3, [r4, r0]
	lsl r1, r3, #0x1f
	lsr r1, r1, #0x1f
	beq _021F257A
	lsl r2, r3, #0x18
	lsr r1, r2, #0x19
	beq _021F2518
	cmp r1, #1
	beq _021F254C
	cmp r1, #2
	beq _021F257A
	b _021F2576
_021F2518:
	add r0, r4, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #0x18
	bl ManagedSprite_SetAnim
	mov r2, #0x53
	lsl r2, r2, #2
	ldr r3, [r4, r2]
	mov r1, #0xfe
	add r0, r3, #0
	bic r0, r1
	lsl r1, r3, #0x18
	lsr r1, r1, #0x19
	add r1, r1, #1
	lsl r1, r1, #0x19
	lsr r1, r1, #0x18
	orr r0, r1
	str r0, [r4, r2]
	pop {r4, pc}
_021F254C:
	lsr r1, r3, #8
	cmp r1, #0x19
	blo _021F256A
	add r0, r4, #0
	add r0, #0xac
	mov r1, #0
	bl ov112_021F1EFC
	mov r1, #0x53
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [r4, r1]
	pop {r4, pc}
_021F256A:
	add r1, r1, #1
	lsr r2, r2, #0x18
	lsl r1, r1, #8
	orr r1, r2
	str r1, [r4, r0]
	pop {r4, pc}
_021F2576:
	bl GF_AssertFail
_021F257A:
	pop {r4, pc}
	thumb_func_end ov112_021F24F8

	thumb_func_start ov112_021F257C
ov112_021F257C: ; 0x021F257C
	push {r4, r5, r6, lr}
	ldr r1, _021F25F8 ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r4, [r1]
	add r1, r4, #0
	add r1, #0x84
	ldrb r1, [r1]
	sub r2, r1, #1
	lsr r1, r2, #0x1f
	add r1, r2, r1
	asr r2, r1, #1
	lsl r1, r2, #2
	add r6, r2, r1
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov112_021F2204
	add r0, r4, #0
	add r0, #0x78
	ldrh r1, [r0]
	add r0, r4, #0
	add r0, #0x7a
	ldrh r0, [r0]
	sub r0, r1, r0
	bpl _021F25C2
	neg r0, r0
_021F25C2:
	add r4, #0x84
	ldrb r1, [r4]
	lsr r3, r1, #0x1f
	lsl r2, r1, #0x1f
	sub r2, r2, r3
	mov r1, #0x1f
	ror r2, r1
	add r1, r3, r2
	cmp r1, #1
	bne _021F25E2
	cmp r0, #0x64
	blt _021F25DE
	mov r2, #1
	b _021F25EC
_021F25DE:
	mov r2, #2
	b _021F25EC
_021F25E2:
	cmp r0, #0x64
	blt _021F25EA
	mov r2, #4
	b _021F25EC
_021F25EA:
	mov r2, #3
_021F25EC:
	add r0, r5, #0
	add r1, r6, #0
	add r2, r6, r2
	bl ov112_021F1624
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F25F8: .word 0x0000013D
	thumb_func_end ov112_021F257C

	thumb_func_start ov112_021F25FC
ov112_021F25FC: ; 0x021F25FC
	push {r3, r4, r5, lr}
	ldr r1, _021F267C ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	mov r2, #1
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r4, [r1]
	mov r1, #0
	bl ov112_021F2204
	add r0, r5, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #0xb
	bl ManagedSprite_SetAnim
	ldr r0, _021F2680 ; =0x0000013F
	ldrb r1, [r5, r0]
	cmp r1, #0
	beq _021F2640
	sub r0, r0, #2
	ldrb r0, [r5, r0]
	cmp r1, r0
	bhi _021F2640
	mov r2, #0x1b
	b _021F2670
_021F2640:
	add r4, #0x78
	ldrh r2, [r4]
	mov r1, #0xfa
	lsl r1, r1, #4
	cmp r2, r1
	blo _021F2650
	mov r2, #0x1c
	b _021F2670
_021F2650:
	ldr r0, _021F2684 ; =0x00000BB8
	cmp r2, r0
	blo _021F265A
	mov r2, #0x1d
	b _021F2670
_021F265A:
	lsr r0, r1, #1
	cmp r2, r0
	blo _021F2664
	mov r2, #0x1e
	b _021F2670
_021F2664:
	lsr r0, r1, #2
	cmp r2, r0
	blo _021F266E
	mov r2, #0x1f
	b _021F2670
_021F266E:
	mov r2, #0x20
_021F2670:
	add r0, r5, #0
	mov r1, #0x1a
	bl ov112_021F1624
	pop {r3, r4, r5, pc}
	nop
_021F267C: .word 0x0000013D
_021F2680: .word 0x0000013F
_021F2684: .word 0x00000BB8
	thumb_func_end ov112_021F25FC

	thumb_func_start ov112_021F2688
ov112_021F2688: ; 0x021F2688
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _021F26E4 ; =0x0000013D
	mov r1, #1
	ldrb r0, [r4, r0]
	lsl r0, r0, #2
	add r0, r4, r0
	add r0, #0xc0
	ldr r5, [r0]
	add r0, r4, #0
	add r0, #0x84
	ldr r0, [r0]
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #0xd
	bl ManagedSprite_SetAnim
	ldrh r0, [r5, #0xa]
	cmp r0, #0
	beq _021F26C4
	add r0, r4, #0
	mov r1, #0
	mov r2, #1
	mov r5, #0x21
	bl ov112_021F2204
	b _021F26D8
_021F26C4:
	add r0, r4, #0
	ldr r1, [r4, #0xc]
	add r0, #0x80
	lsl r1, r1, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #3
	mov r5, #0x22
	bl ov112_021F22B0
_021F26D8:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0
	bl ov112_021F1624
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F26E4: .word 0x0000013D
	thumb_func_end ov112_021F2688

	thumb_func_start ov112_021F26E8
ov112_021F26E8: ; 0x021F26E8
	push {r3, r4, r5, lr}
	ldr r1, _021F2760 ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	mov r2, #1
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r4, [r1]
	mov r1, #0
	bl ov112_021F2204
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov112_021F2204
	mov r0, #5
	lsl r0, r0, #6
	ldrb r1, [r5, r0]
	cmp r1, #0
	beq _021F2720
	sub r0, r0, #3
	ldrb r0, [r5, r0]
	cmp r1, r0
	bhi _021F2720
	mov r2, #0x24
	b _021F2750
_021F2720:
	add r4, #0x78
	ldrh r2, [r4]
	mov r1, #0xfa
	lsl r1, r1, #4
	cmp r2, r1
	blo _021F2730
	mov r2, #0x25
	b _021F2750
_021F2730:
	ldr r0, _021F2764 ; =0x00000BB8
	cmp r2, r0
	blo _021F273A
	mov r2, #0x26
	b _021F2750
_021F273A:
	lsr r0, r1, #1
	cmp r2, r0
	blo _021F2744
	mov r2, #0x27
	b _021F2750
_021F2744:
	lsr r0, r1, #2
	cmp r2, r0
	blo _021F274E
	mov r2, #0x28
	b _021F2750
_021F274E:
	mov r2, #0x29
_021F2750:
	add r0, r5, #0
	mov r1, #0x23
	bl ov112_021F1624
	add r0, r5, #0
	bl ov112_021F24C4
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F2760: .word 0x0000013D
_021F2764: .word 0x00000BB8
	thumb_func_end ov112_021F26E8

	thumb_func_start ov112_021F2768
ov112_021F2768: ; 0x021F2768
	push {r3, r4, r5, lr}
	ldr r1, _021F27B4 ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r1, [r1]
	ldrh r1, [r1, #0xa]
	cmp r1, #0
	beq _021F278A
	mov r1, #0
	mov r2, #1
	mov r4, #0x2a
	bl ov112_021F2204
	b _021F279C
_021F278A:
	ldr r1, [r5, #0xc]
	add r0, #0x80
	lsl r1, r1, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #3
	mov r4, #0x2b
	bl ov112_021F22B0
_021F279C:
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov112_021F2204
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov112_021F1624
	pop {r3, r4, r5, pc}
	nop
_021F27B4: .word 0x0000013D
	thumb_func_end ov112_021F2768

	thumb_func_start ov112_021F27B8
ov112_021F27B8: ; 0x021F27B8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov112_021F2204
	add r0, r4, #0
	bl ov112_021F2348
	add r0, r4, #0
	mov r1, #0x2c
	mov r2, #0
	bl ov112_021F1624
	pop {r4, pc}
	thumb_func_end ov112_021F27B8

	thumb_func_start ov112_021F27E0
ov112_021F27E0: ; 0x021F27E0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov112_021F2204
	add r0, r4, #0
	mov r1, #0
	mov r2, #9
	mov r3, #0x1a
	bl ov112_021F22D0
	add r0, r4, #0
	mov r1, #0x2d
	mov r2, #0
	bl ov112_021F1624
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F27E0

	thumb_func_start ov112_021F2810
ov112_021F2810: ; 0x021F2810
	push {r4, r5, r6, lr}
	ldr r1, _021F2870 ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	mov r4, #0
	mov r2, #1
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r6, [r1]
	add r1, r4, #0
	bl ov112_021F2204
	add r0, r5, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #0xc
	bl ManagedSprite_SetAnim
	add r6, #0x77
	ldrb r0, [r6]
	cmp r0, #0xfa
	blo _021F284E
	mov r4, #0x2f
	b _021F2864
_021F284E:
	cmp r0, #0xc8
	blo _021F2856
	mov r4, #0x30
	b _021F2864
_021F2856:
	cmp r0, #0x96
	blo _021F285E
	mov r4, #0x31
	b _021F2864
_021F285E:
	cmp r0, #0x5a
	blo _021F2864
	mov r4, #0x32
_021F2864:
	add r0, r5, #0
	mov r1, #0x2e
	add r2, r4, #0
	bl ov112_021F1624
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F2870: .word 0x0000013D
	thumb_func_end ov112_021F2810

	thumb_func_start ov112_021F2874
ov112_021F2874: ; 0x021F2874
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F28D8 ; =0x0000013D
	ldrb r0, [r5, r0]
	lsl r0, r0, #2
	add r0, r5, r0
	add r0, #0xc0
	ldr r1, [r0]
	add r0, r1, #0
	add r1, #0x84
	ldrb r1, [r1]
	add r0, #0x77
	ldrb r2, [r0]
	sub r1, #0x12
	lsl r0, r1, #1
	add r4, r1, r0
	add r4, #0x33
	cmp r2, #0xc8
	bge _021F28A8
	cmp r2, #0x3c
	blt _021F28A2
	add r4, r4, #1
	b _021F28A8
_021F28A2:
	cmp r2, #0
	blt _021F28A8
	add r4, r4, #2
_021F28A8:
	cmp r4, #0x35
	bne _021F28AE
	mov r4, #0x34
_021F28AE:
	add r0, r5, #0
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r5, #0
	ldr r1, [r5, #0xc]
	add r0, #0x84
	lsl r1, r1, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #1
	bl ov112_021F22B0
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov112_021F1624
	pop {r3, r4, r5, pc}
	nop
_021F28D8: .word 0x0000013D
	thumb_func_end ov112_021F2874

	thumb_func_start ov112_021F28DC
ov112_021F28DC: ; 0x021F28DC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r4, #0
	ldr r1, [r4, #0xc]
	add r0, #0x84
	lsl r1, r1, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #3
	bl ov112_021F22B0
	add r0, r4, #0
	add r0, #0x8c
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0x8c
	ldr r0, [r0]
	mov r1, #8
	bl ManagedSprite_SetAnim
	add r0, r4, #0
	mov r1, #0x42
	mov r2, #0
	bl ov112_021F1624
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F28DC

	thumb_func_start ov112_021F2920
ov112_021F2920: ; 0x021F2920
	push {r4, lr}
	mov r1, #1
	add r4, r0, #0
	add r2, r1, #0
	bl ov112_021F2204
	add r0, r4, #0
	add r0, #0xac
	mov r1, #3
	bl ov112_021F1F3C
	add r0, r4, #0
	mov r1, #0x43
	mov r2, #0
	bl ov112_021F1624
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021F2920

	thumb_func_start ov112_021F2944
ov112_021F2944: ; 0x021F2944
	push {r3, r4, r5, lr}
	ldr r1, _021F2988 ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r1, [r1]
	ldrh r1, [r1, #0xa]
	cmp r1, #0
	bne _021F295E
	mov r4, #0x46
	b _021F2968
_021F295E:
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	mov r4, #0x45
_021F2968:
	add r0, r5, #0
	ldr r1, [r5, #0xc]
	add r0, #0x84
	lsl r1, r1, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #3
	bl ov112_021F22B0
	add r0, r5, #0
	mov r1, #0x44
	add r2, r4, #0
	bl ov112_021F1624
	pop {r3, r4, r5, pc}
	nop
_021F2988: .word 0x0000013D
	thumb_func_end ov112_021F2944

	thumb_func_start ov112_021F298C
ov112_021F298C: ; 0x021F298C
	push {r4, r5, r6, lr}
	ldr r1, _021F2A64 ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	mov r4, #0
	mov r2, #1
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r6, [r1]
	add r1, r4, #0
	bl ov112_021F2204
	add r0, r5, #0
	ldr r1, [r5, #0xc]
	add r0, #0x84
	lsl r1, r1, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #3
	bl ov112_021F22B0
	ldr r0, [r6, #0x7c]
	mov r1, #0x64
	bl _u32_div_f
	ldr r1, _021F2A68 ; =0x0000028F
	cmp r0, r1
	ble _021F29C8
	add r0, r1, #0
_021F29C8:
	add r4, r4, r0
	ldr r0, _021F2A6C ; =0x00000142
	ldrb r1, [r5, r0]
	mov r0, #0xa
	mul r0, r1
	cmp r0, #0x28
	ble _021F29D8
	mov r0, #0x28
_021F29D8:
	add r4, r4, r0
	ldr r0, _021F2A70 ; =0x00000141
	ldrb r1, [r5, r0]
	mov r0, #0xa
	mul r0, r1
	cmp r0, #0x28
	ble _021F29E8
	mov r0, #0x28
_021F29E8:
	add r4, r4, r0
	ldr r0, _021F2A74 ; =0x00000143
	ldrb r1, [r5, r0]
	mov r0, #0xf
	mul r0, r1
	cmp r0, #0x96
	ble _021F29F8
	mov r0, #0x96
_021F29F8:
	mov r2, #0x51
	lsl r2, r2, #2
	ldr r3, [r5, r2]
	add r0, r4, r0
	lsl r1, r3, #0x17
	lsr r4, r1, #0x1f
	lsl r3, r3, #0x16
	mov r1, #0xfa
	add r6, r4, #0
	lsr r3, r3, #0x1f
	mul r6, r1
	add r4, r3, #0
	add r0, r0, r6
	mul r4, r1
	add r0, r0, r4
	add r2, #0xe2
	cmp r0, r2
	blo _021F2A20
	mov r2, #0x48
	b _021F2A4C
_021F2A20:
	add r1, #0x32
	cmp r0, r1
	blo _021F2A2A
	mov r2, #0x49
	b _021F2A4C
_021F2A2A:
	cmp r0, #0xc8
	blo _021F2A32
	mov r2, #0x4a
	b _021F2A4C
_021F2A32:
	cmp r0, #0x96
	blo _021F2A3A
	mov r2, #0x4b
	b _021F2A4C
_021F2A3A:
	cmp r0, #0x64
	blo _021F2A42
	mov r2, #0x4c
	b _021F2A4C
_021F2A42:
	cmp r0, #0x1e
	blo _021F2A4A
	mov r2, #0x4d
	b _021F2A4C
_021F2A4A:
	mov r2, #0x4e
_021F2A4C:
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	cmp r0, #0xc
	bge _021F2A5A
	mov r1, #0x47
	b _021F2A5C
_021F2A5A:
	mov r1, #0x5a
_021F2A5C:
	add r0, r5, #0
	bl ov112_021F1624
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F2A64: .word 0x0000013D
_021F2A68: .word 0x0000028F
_021F2A6C: .word 0x00000142
_021F2A70: .word 0x00000141
_021F2A74: .word 0x00000143
	thumb_func_end ov112_021F298C

	thumb_func_start ov112_021F2A78
ov112_021F2A78: ; 0x021F2A78
	push {r4, r5, r6, lr}
	ldr r2, _021F2B28 ; =0x0000013D
	add r5, r0, #0
	add r4, r1, #0
	ldrb r1, [r5, r2]
	sub r2, #0x11
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r1, [r1]
	add r1, #0x78
	ldrh r6, [r1]
	cmp r6, r2
	blo _021F2AD2
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r5, #0
	ldr r1, [r5, #0xc]
	add r0, #0x84
	lsl r1, r1, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #3
	bl ov112_021F22B0
	mov r1, #0xfa
	lsl r1, r1, #4
	cmp r6, r1
	blo _021F2ABA
	mov r1, #0x4f
	b _021F2B1C
_021F2ABA:
	lsr r0, r1, #1
	cmp r6, r0
	blo _021F2AC4
	mov r1, #0x50
	b _021F2B1C
_021F2AC4:
	lsr r0, r1, #2
	cmp r6, r0
	blo _021F2ACE
	mov r1, #0x51
	b _021F2B1C
_021F2ACE:
	mov r1, #0x52
	b _021F2B1C
_021F2AD2:
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r5, #0
	add r0, #0x98
	mov r1, #0x80
	mov r2, #0x48
	mov r3, #0
	bl ov112_021F1F54
	add r0, r5, #0
	add r0, #0x98
	mov r1, #0
	bl ov112_021F1F3C
	add r0, r5, #0
	mov r1, #0
	mov r2, #8
	mov r3, #0xa
	bl ov112_021F22D0
	cmp r4, #0x14
	blo _021F2B06
	cmp r4, #0x18
	bls _021F2B0A
_021F2B06:
	cmp r4, #7
	bhi _021F2B0E
_021F2B0A:
	mov r1, #0x53
	b _021F2B1C
_021F2B0E:
	cmp r4, #0xc
	blo _021F2B1A
	cmp r4, #0x10
	bhi _021F2B1A
	mov r1, #0x54
	b _021F2B1C
_021F2B1A:
	mov r1, #0x55
_021F2B1C:
	add r0, r5, #0
	mov r2, #0
	bl ov112_021F1624
	pop {r4, r5, r6, pc}
	nop
_021F2B28: .word 0x0000013D
	thumb_func_end ov112_021F2A78

	thumb_func_start ov112_021F2B2C
ov112_021F2B2C: ; 0x021F2B2C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	mov r2, #1
	bl ov112_021F2204
	add r0, r4, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0x84
	ldr r0, [r0]
	mov r1, #0x1b
	bl ManagedSprite_SetAnim
	add r0, r4, #0
	add r0, #0xbc
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0x8c
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0x8c
	ldr r0, [r0]
	mov r1, #7
	bl ManagedSprite_SetAnim
	add r0, r4, #0
	mov r1, #0x19
	mov r2, #0
	bl ov112_021F1624
	pop {r4, pc}
	thumb_func_end ov112_021F2B2C

	thumb_func_start ov112_021F2B80
ov112_021F2B80: ; 0x021F2B80
	push {r4, r5, r6, lr}
	ldr r1, _021F2CBC ; =0x0000013D
	add r5, r0, #0
	ldrb r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r5, r1
	add r1, #0xc0
	ldr r4, [r1]
	bl ov112_021F15E4
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r6, [r5, r0]
	add r0, r4, #0
	bl ov112_021F0F60
	add r2, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	bl ov112_021F1904
	add r0, r4, #0
	bl ov112_021F0F60
	add r1, r0, #0
	add r0, r5, #0
	bl ov112_021F1D58
	mov r0, #0x51
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	add r0, r4, #0
	add r0, #0x76
	ldrb r0, [r0]
	cmp r1, r0
	beq _021F2BDA
	add r0, r4, #0
	bl ov112_021F0F60
	add r1, r0, #0
	add r0, r5, #0
	bl ov112_021F194C
_021F2BDA:
	mov r2, #0x51
	lsl r2, r2, #2
	ldr r0, [r5, r2]
	mov r1, #0xff
	bic r0, r1
	add r1, r4, #0
	add r1, #0x76
	ldrb r1, [r1]
	orr r0, r1
	str r0, [r5, r2]
	add r0, r4, #0
	add r0, #0x84
	ldrb r0, [r0]
	cmp r0, #1
	blo _021F2C1A
	cmp r0, #0xa
	bhi _021F2C1A
	ldrh r1, [r4, #8]
	ldr r0, _021F2CC0 ; =0x0000FFF9
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r0, #1
	bhi _021F2C12
	add r0, r5, #0
	bl ov112_021F257C
	pop {r4, r5, r6, pc}
_021F2C12:
	add r0, r5, #0
	bl ov112_021F2B2C
	pop {r4, r5, r6, pc}
_021F2C1A:
	cmp r0, #0xb
	bne _021F2C26
	add r0, r5, #0
	bl ov112_021F25FC
	pop {r4, r5, r6, pc}
_021F2C26:
	cmp r0, #0xc
	bne _021F2C32
	add r0, r5, #0
	bl ov112_021F2688
	pop {r4, r5, r6, pc}
_021F2C32:
	cmp r0, #0xd
	bne _021F2C3E
	add r0, r5, #0
	bl ov112_021F26E8
	pop {r4, r5, r6, pc}
_021F2C3E:
	cmp r0, #0xe
	bne _021F2C4A
	add r0, r5, #0
	bl ov112_021F2768
	pop {r4, r5, r6, pc}
_021F2C4A:
	cmp r0, #0xf
	bne _021F2C56
	add r0, r5, #0
	bl ov112_021F27B8
	pop {r4, r5, r6, pc}
_021F2C56:
	cmp r0, #0x10
	bne _021F2C62
	add r0, r5, #0
	bl ov112_021F27E0
	pop {r4, r5, r6, pc}
_021F2C62:
	cmp r0, #0x11
	bne _021F2C6E
	add r0, r5, #0
	bl ov112_021F2810
	pop {r4, r5, r6, pc}
_021F2C6E:
	cmp r0, #0x12
	blo _021F2C7E
	cmp r0, #0x16
	bhi _021F2C7E
	add r0, r5, #0
	bl ov112_021F2874
	pop {r4, r5, r6, pc}
_021F2C7E:
	cmp r0, #0x17
	bne _021F2C8A
	add r0, r5, #0
	bl ov112_021F28DC
	pop {r4, r5, r6, pc}
_021F2C8A:
	cmp r0, #0x18
	bne _021F2C96
	add r0, r5, #0
	bl ov112_021F2920
	pop {r4, r5, r6, pc}
_021F2C96:
	cmp r0, #0x19
	bne _021F2CA2
	add r0, r5, #0
	bl ov112_021F2944
	pop {r4, r5, r6, pc}
_021F2CA2:
	cmp r0, #0x1a
	bne _021F2CAE
	add r0, r5, #0
	bl ov112_021F298C
	pop {r4, r5, r6, pc}
_021F2CAE:
	cmp r0, #0x1b
	bne _021F2CBA
	add r0, r5, #0
	add r1, r6, #0
	bl ov112_021F2A78
_021F2CBA:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F2CBC: .word 0x0000013D
_021F2CC0: .word 0x0000FFF9
	thumb_func_end ov112_021F2B80

	thumb_func_start ov112_021F2CC4
ov112_021F2CC4: ; 0x021F2CC4
	mov r2, #0x51
	lsl r2, r2, #2
	mov r1, #1
	ldr r3, [r0, r2]
	lsl r1, r1, #0xa
	orr r1, r3
	str r1, [r0, r2]
	bx lr
	thumb_func_end ov112_021F2CC4

	thumb_func_start ov112_021F2CD4
ov112_021F2CD4: ; 0x021F2CD4
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x51
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	lsl r1, r0, #0x15
	lsr r1, r1, #0x1f
	bne _021F2CEC
	add sp, #0xc
	mov r0, #1
	pop {r3, r4, pc}
_021F2CEC:
	lsl r0, r0, #0x11
	lsr r0, r0, #0x1c
	beq _021F2CFC
	cmp r0, #1
	beq _021F2D2E
	cmp r0, #2
	beq _021F2DA8
	b _021F2DCA
_021F2CFC:
	mov r0, #2
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, [r4, #4]
	mov r1, #0
	str r0, [sp, #8]
	ldr r3, _021F2DD4 ; =0x00007FFF
	mov r0, #3
	add r2, r1, #0
	bl BeginNormalPaletteFade
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	ldr r0, _021F2DD8 ; =0xFFFF87FF
	and r0, r2
	lsl r2, r2, #0x11
	lsr r2, r2, #0x1c
	add r2, r2, #1
	lsl r2, r2, #0x1c
	lsr r2, r2, #0x11
	orr r0, r2
	str r0, [r4, r1]
	b _021F2DCE
_021F2D2E:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021F2DCE
	ldr r0, _021F2DDC ; =0x0000013D
	ldrb r0, [r4, r0]
	cmp r0, #0
	beq _021F2D42
	mov r1, #1
	b _021F2D44
_021F2D42:
	mov r1, #0
_021F2D44:
	ldr r0, [r4, #0x70]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F2DDC ; =0x0000013D
	ldrb r1, [r4, r0]
	add r0, r0, #1
	ldrb r0, [r4, r0]
	sub r0, r0, #1
	cmp r1, r0
	bge _021F2D5C
	mov r1, #1
	b _021F2D5E
_021F2D5C:
	mov r1, #0
_021F2D5E:
	ldr r0, [r4, #0x74]
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #0
	bl ov112_021F1CC8
	add r0, r4, #0
	bl ov112_021F2328
	add r0, r4, #0
	bl ov112_021F2B80
	mov r0, #2
	mov r1, #1
	str r0, [sp]
	str r1, [sp, #4]
	ldr r0, [r4, #4]
	ldr r3, _021F2DD4 ; =0x00007FFF
	str r0, [sp, #8]
	mov r0, #3
	add r2, r1, #0
	bl BeginNormalPaletteFade
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	ldr r0, _021F2DD8 ; =0xFFFF87FF
	and r0, r2
	lsl r2, r2, #0x11
	lsr r2, r2, #0x1c
	add r2, r2, #1
	lsl r2, r2, #0x1c
	lsr r2, r2, #0x11
	orr r0, r2
	str r0, [r4, r1]
	b _021F2DCE
_021F2DA8:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021F2DCE
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	ldr r0, _021F2DD8 ; =0xFFFF87FF
	add sp, #0xc
	and r0, r2
	str r0, [r4, r1]
	ldr r2, [r4, r1]
	ldr r0, _021F2DE0 ; =0xFFFFFBFF
	and r0, r2
	str r0, [r4, r1]
	mov r0, #1
	pop {r3, r4, pc}
_021F2DCA:
	bl GF_AssertFail
_021F2DCE:
	mov r0, #0
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F2DD4: .word 0x00007FFF
_021F2DD8: .word 0xFFFF87FF
_021F2DDC: .word 0x0000013D
_021F2DE0: .word 0xFFFFFBFF
	thumb_func_end ov112_021F2CD4

	thumb_func_start ov112_021F2DE4
ov112_021F2DE4: ; 0x021F2DE4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl OverlayManager_GetArgs
	add r5, r0, #0
	bne _021F2DF4
	bl GF_AssertFail
_021F2DF4:
	mov r0, #3
	mov r1, #0x9b
	lsl r2, r0, #0x11
	bl Heap_Create
	mov r1, #0x15
	add r0, r4, #0
	lsl r1, r1, #4
	mov r2, #0x9b
	bl OverlayManager_CreateAndGetData
	mov r2, #0x15
	mov r1, #0
	lsl r2, r2, #4
	add r4, r0, #0
	bl MI_CpuFill8
	mov r0, #0x9b
	str r0, [r4, #4]
	add r0, r4, #0
	str r5, [r4]
	bl ov112_021F0F90
	bl ov112_021F0DC0
	bl ov112_021F0DF4
	ldr r0, _021F2E68 ; =gSystem + 0x60
	mov r1, #1
	strb r1, [r0, #9]
	bl GfGfx_SwapDisplay
	ldr r1, [r4, #4]
	mov r0, #0xfb
	bl NARC_New
	str r0, [r4, #0x10]
	add r0, r4, #0
	bl ov112_021F179C
	add r0, r4, #0
	bl ov112_021F1288
	add r0, r4, #0
	bl ov112_021F196C
	mov r0, #0
	bl ResetVisibleHardwareWindows
	mov r0, #1
	bl ResetVisibleHardwareWindows
	ldr r0, _021F2E6C ; =ov112_021F2EB0
	add r1, r4, #0
	bl Main_SetVBlankIntrCB
	pop {r3, r4, r5, pc}
	nop
_021F2E68: .word gSystem + 0x60
_021F2E6C: .word ov112_021F2EB0
	thumb_func_end ov112_021F2DE4

	thumb_func_start ov112_021F2E70
ov112_021F2E70: ; 0x021F2E70
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl OverlayManager_GetData
	add r5, r0, #0
	bl ov112_021F1324
	add r0, r5, #0
	bl ov112_021F1814
	add r0, r5, #0
	bl ov112_021F1A08
	ldr r0, [r5, #0x10]
	bl NARC_Delete
	ldr r0, _021F2EAC ; =gSystem + 0x60
	mov r1, #0
	strb r1, [r0, #9]
	bl GfGfx_SwapDisplay
	bl ov112_021F0DC0
	add r0, r4, #0
	bl OverlayManager_FreeData
	mov r0, #0x9b
	bl Heap_Destroy
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F2EAC: .word gSystem + 0x60
	thumb_func_end ov112_021F2E70

	thumb_func_start ov112_021F2EB0
ov112_021F2EB0: ; 0x021F2EB0
	push {r4, lr}
	add r4, r0, #0
	bne _021F2EBA
	bl GF_AssertFail
_021F2EBA:
	ldr r0, [r4, #0x6c]
	cmp r0, #0
	bne _021F2EC4
	bl GF_AssertFail
_021F2EC4:
	ldr r0, [r4, #0x14]
	cmp r0, #0
	bne _021F2ECE
	bl GF_AssertFail
_021F2ECE:
	ldr r0, [r4, #0x6c]
	bl SpriteSystem_DrawSprites
	bl SpriteSystem_TransferOam
	ldr r0, [r4, #0x14]
	bl DoScheduledBgGpuUpdates
	ldr r3, _021F2EEC ; =0x027E0000
	ldr r1, _021F2EF0 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r4, pc}
	.balign 4, 0
_021F2EEC: .word 0x027E0000
_021F2EF0: .word 0x00003FF8
	thumb_func_end ov112_021F2EB0

	thumb_func_start ov112_021F2EF4
ov112_021F2EF4: ; 0x021F2EF4
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r6, r0, #0
	bl OverlayManager_GetData
	ldr r1, [r4]
	add r5, r0, #0
	cmp r1, #4
	bhi _021F2F9C
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021F2F14: ; jump table
	.short _021F2F1E - _021F2F14 - 2 ; case 0
	.short _021F2F2C - _021F2F14 - 2 ; case 1
	.short _021F2F3E - _021F2F14 - 2 ; case 2
	.short _021F2F70 - _021F2F14 - 2 ; case 3
	.short _021F2F8E - _021F2F14 - 2 ; case 4
_021F2F1E:
	add r0, r6, #0
	bl ov112_021F2DE4
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _021F2FA0
_021F2F2C:
	bl ov112_021F1838
	add r0, r5, #0
	bl ov112_021F1A40
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _021F2FA0
_021F2F3E:
	bl ov112_021F1DC0
	cmp r0, #0
	beq _021F2FA0
	add r0, r5, #0
	bl ov112_021F1B94
	add r0, r5, #0
	bl ov112_021F178C
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	mov r0, #0xff
	bic r2, r0
	mov r0, #0xff
	orr r0, r2
	str r0, [r5, r1]
	add r0, r5, #0
	bl ov112_021F2B80
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _021F2FA0
_021F2F70:
	mov r0, #6
	mov r1, #1
	str r0, [sp]
	str r1, [sp, #4]
	ldr r0, [r5, #4]
	ldr r3, _021F2FA8 ; =0x00007FFF
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _021F2FA0
_021F2F8E:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021F2FA0
	add sp, #0xc
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_021F2F9C:
	bl GF_AssertFail
_021F2FA0:
	mov r0, #0
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	nop
_021F2FA8: .word 0x00007FFF
	thumb_func_end ov112_021F2EF4

	thumb_func_start ov112_021F2FAC
ov112_021F2FAC: ; 0x021F2FAC
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	bl OverlayManager_GetData
	ldr r1, [r4]
	cmp r1, #0
	beq _021F2FC8
	cmp r1, #1
	beq _021F2FDA
	cmp r1, #2
	beq _021F2FFA
	b _021F300E
_021F2FC8:
	ldr r0, [r0, #0x78]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _021F3012
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _021F3012
_021F2FDA:
	mov r1, #6
	str r1, [sp]
	mov r1, #1
	str r1, [sp, #4]
	ldr r0, [r0, #4]
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _021F3012
_021F2FFA:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021F3012
	add r0, r5, #0
	bl ov112_021F2E70
	add sp, #0xc
	mov r0, #1
	pop {r4, r5, pc}
_021F300E:
	bl GF_AssertFail
_021F3012:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov112_021F2FAC

	thumb_func_start ov112_021F3018
ov112_021F3018: ; 0x021F3018
	push {r4, lr}
	bl OverlayManager_GetData
	add r4, r0, #0
	bl ov112_021F2CD4
	cmp r0, #0
	bne _021F302C
	mov r0, #0
	pop {r4, pc}
_021F302C:
	add r0, r4, #0
	bl ov112_021F0EB4
	cmp r0, #0
	beq _021F3050
	ldr r0, _021F30B4 ; =0x0000013D
	ldrb r1, [r4, r0]
	cmp r1, #0
	beq _021F3042
	sub r1, r1, #1
	strb r1, [r4, r0]
_021F3042:
	add r0, r4, #0
	bl ov112_021F2CC4
	ldr r0, _021F30B8 ; =0x000005DC
	bl PlaySE
	b _021F3088
_021F3050:
	add r0, r4, #0
	bl ov112_021F0EFC
	cmp r0, #0
	beq _021F307A
	ldr r1, _021F30B4 ; =0x0000013D
	ldrb r0, [r4, r1]
	add r1, r1, #1
	ldrb r1, [r4, r1]
	add r0, r0, #1
	bl _s32_div_f
	ldr r0, _021F30B4 ; =0x0000013D
	strb r1, [r4, r0]
	add r0, r4, #0
	bl ov112_021F2CC4
	ldr r0, _021F30B8 ; =0x000005DC
	bl PlaySE
	b _021F3088
_021F307A:
	add r0, r4, #0
	bl ov112_021F0E60
	cmp r0, #0
	beq _021F3088
	mov r0, #1
	pop {r4, pc}
_021F3088:
	add r0, r4, #0
	bl ov112_021F2338
	add r0, r4, #0
	mov r1, #5
	bl ov112_021F1D28
	add r0, r4, #0
	mov r1, #6
	bl ov112_021F1D28
	add r0, r4, #0
	mov r1, #7
	bl ov112_021F1D28
	add r0, r4, #0
	mov r1, #8
	bl ov112_021F1D28
	mov r0, #0
	pop {r4, pc}
	nop
_021F30B4: .word 0x0000013D
_021F30B8: .word 0x000005DC
	thumb_func_end ov112_021F3018

	thumb_func_start ov112_021F30BC
ov112_021F30BC: ; 0x021F30BC
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	mov r1, #0
	mov r2, #0x88
	bl MI_CpuFill8
	add r1, r5, #0
	ldr r0, [r4]
	add r1, #0x20
	mov r2, #0x16
	bl MI_CpuCopy8
	ldrh r0, [r4, #8]
	mov r1, #0x1f
	strh r0, [r5, #0xa]
	add r0, r5, #0
	add r0, #0x85
	ldrb r0, [r0]
	bic r0, r1
	ldrb r1, [r4, #0xa]
	lsl r1, r1, #0x1b
	lsr r2, r1, #0x1b
	mov r1, #0x1f
	and r1, r2
	orr r1, r0
	add r0, r5, #0
	add r0, #0x85
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x85
	ldrb r0, [r0]
	mov r1, #0x60
	bic r0, r1
	ldrb r1, [r4, #0xa]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1e
	lsl r1, r1, #0x1e
	lsr r1, r1, #0x19
	orr r1, r0
	add r0, r5, #0
	add r0, #0x85
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x85
	ldrb r0, [r0]
	mov r1, #0x80
	bic r0, r1
	ldrb r1, [r4, #0xa]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	lsl r1, r1, #0x1f
	lsr r1, r1, #0x18
	orr r1, r0
	add r0, r5, #0
	add r0, #0x85
	strb r1, [r0]
	ldr r0, [r4, #4]
	mov r1, #0x1a
	str r0, [r5, #0x7c]
	add r0, r5, #0
	add r0, #0x84
	strb r1, [r0]
	sub r1, #0x1b
	str r1, [r5]
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021F30BC

	thumb_func_start ov112_021F3140
ov112_021F3140: ; 0x021F3140
	push {r4, r5, r6, r7}
	add r6, r1, #0
	mov r1, #0x1f
	mov r5, #0
	mov ip, r1
	mov r7, #0x60
	mov r2, #0x80
_021F314E:
	add r1, r0, #0
	add r1, #0x84
	ldrb r1, [r1]
	cmp r1, #0x1d
	bne _021F31AE
	ldrh r1, [r6]
	strh r1, [r0, #0xc]
	add r1, r0, #0
	add r1, #0x86
	ldrb r4, [r1]
	mov r1, ip
	bic r4, r1
	ldrb r1, [r6, #2]
	lsl r1, r1, #0x1b
	lsr r3, r1, #0x1b
	mov r1, #0x1f
	and r1, r3
	add r3, r4, #0
	orr r3, r1
	add r1, r0, #0
	add r1, #0x86
	strb r3, [r1]
	ldrb r3, [r6, #2]
	add r1, r0, #0
	add r1, #0x86
	ldrb r1, [r1]
	lsl r3, r3, #0x19
	lsr r3, r3, #0x1e
	lsl r3, r3, #0x1e
	bic r1, r7
	lsr r3, r3, #0x19
	orr r3, r1
	add r1, r0, #0
	add r1, #0x86
	strb r3, [r1]
	ldrb r3, [r6, #2]
	add r1, r0, #0
	add r1, #0x86
	ldrb r1, [r1]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x1f
	lsl r3, r3, #0x1f
	bic r1, r2
	lsr r3, r3, #0x18
	orr r3, r1
	add r1, r0, #0
	add r1, #0x86
	strb r3, [r1]
_021F31AE:
	add r5, r5, #1
	add r0, #0x88
	cmp r5, #0x18
	blt _021F314E
	pop {r4, r5, r6, r7}
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021F3140

	thumb_func_start ov112_021F31BC
ov112_021F31BC: ; 0x021F31BC
	mov r2, #0
_021F31BE:
	add r1, r0, #0
	add r1, #0x84
	ldrb r1, [r1]
	cmp r1, #0x1d
	bne _021F31CC
	mov r0, #1
	bx lr
_021F31CC:
	add r2, r2, #1
	add r0, #0x88
	cmp r2, #0x18
	blt _021F31BE
	mov r0, #0
	bx lr
	thumb_func_end ov112_021F31BC

	thumb_func_start ov112_021F31D8
ov112_021F31D8: ; 0x021F31D8
	push {r3, r4, r5, r6}
	ldr r4, _021F323C ; =0x000001ED
	ldr r5, _021F3240 ; =0x0000FFF9
	mov r2, #0
	add r3, r4, #0
_021F31E2:
	add r1, r0, #0
	add r1, #0x84
	ldrb r1, [r1]
	cmp r1, #0
	beq _021F322E
	cmp r1, #0x1e
	blo _021F31F6
	mov r0, #1
	pop {r3, r4, r5, r6}
	bx lr
_021F31F6:
	ldrh r1, [r0, #0xa]
	cmp r1, #0
	bne _021F3202
	mov r0, #1
	pop {r3, r4, r5, r6}
	bx lr
_021F3202:
	ldrh r6, [r0, #8]
	add r6, r6, r5
	lsl r6, r6, #0x10
	lsr r6, r6, #0x10
	cmp r6, #1
	bhi _021F321E
	cmp r1, r4
	bhi _021F3218
	ldrh r1, [r0, #0xc]
	cmp r1, r3
	bls _021F321E
_021F3218:
	mov r0, #1
	pop {r3, r4, r5, r6}
	bx lr
_021F321E:
	add r1, r0, #0
	add r1, #0x76
	ldrb r1, [r1]
	cmp r1, #8
	blo _021F322E
	mov r0, #1
	pop {r3, r4, r5, r6}
	bx lr
_021F322E:
	add r2, r2, #1
	add r0, #0x88
	cmp r2, #0x18
	blt _021F31E2
	mov r0, #0
	pop {r3, r4, r5, r6}
	bx lr
	.balign 4, 0
_021F323C: .word 0x000001ED
_021F3240: .word 0x0000FFF9
	thumb_func_end ov112_021F31D8

	thumb_func_start ov112_021F3244
ov112_021F3244: ; 0x021F3244
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl Save_PlayerData_GetProfile
	add r0, r5, #0
	bl SaveArray_Party_Get
	mov r2, #0x7d
	add r6, r0, #0
	mov r0, #0
	add r1, r4, #0
	lsl r2, r2, #2
	bl MIi_CpuClearFast
	add r0, r4, #0
	bl TrainerHouseSet_SetZero
	add r0, r4, #0
	add r1, r5, #0
	bl ov112_021F336C
	add r0, r4, #0
	add r0, #0x30
	add r1, r6, #0
	bl ov112_021F33D8
	ldr r1, _021F3288 ; =0x000001F2
	add r0, r4, #0
	bl GF_CalcCRC16
	ldr r1, _021F3288 ; =0x000001F2
	strh r0, [r4, r1]
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F3288: .word 0x000001F2
	thumb_func_end ov112_021F3244

	thumb_func_start ov112_021F328C
ov112_021F328C: ; 0x021F328C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #0x10]
	str r1, [sp, #0x14]
	str r0, [sp]
	ldr r5, [sp, #0x10]
	bl Save_TrainerHouse_Get
	str r0, [sp, #8]
	ldr r0, [sp, #4]
	bl TrainerHouseSet_CheckHasData
	cmp r0, #0
	bne _021F32B6
	ldr r0, [sp, #8]
	bl ov112_021F35A4
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
_021F32B6:
	ldr r0, [sp, #4]
	ldr r1, _021F3368 ; =0x000001F2
	bl GF_CalcCRC16
	ldr r2, _021F3368 ; =0x000001F2
	ldr r1, [sp, #4]
	ldrh r1, [r1, r2]
	cmp r1, r0
	bne _021F3364
	ldr r0, [sp, #8]
	bl ov112_021F35A4
	str r0, [sp, #0xc]
	ldr r0, [sp]
	add r1, sp, #0x18
	bl ov112_021F3608
	ldr r0, [sp, #8]
	ldr r1, [sp, #4]
	add r2, sp, #0x14
	bl ov112_021F35C8
	add r4, r0, #0
	ldr r0, [sp, #0xc]
	cmp r0, #0xa
	bge _021F32F0
	ldr r0, [sp, #0x14]
	cmp r0, #0
	beq _021F32FE
_021F32F0:
	ldr r0, [sp, #0xc]
	mov r5, #1
	sub r0, r0, #1
	str r0, [sp, #0xc]
	add r0, sp, #0x18
	ldrb r0, [r0, r4]
	str r0, [sp, #0x10]
_021F32FE:
	cmp r5, #0
	beq _021F3342
	ldr r0, [sp, #0xc]
	cmp r4, r0
	bge _021F3342
	cmp r4, r0
	bge _021F3342
	mov r0, #6
	lsl r0, r0, #6
	add r1, r4, #0
	mul r1, r0
	ldr r0, [sp, #8]
	add r5, r0, r1
	add r0, sp, #0x18
	add r6, r0, r4
_021F331C:
	mov r0, #6
	lsl r0, r0, #6
	add r3, r5, r0
	add r7, r5, #0
	mov r2, #0x30
_021F3326:
	ldmia r3!, {r0, r1}
	stmia r7!, {r0, r1}
	sub r2, r2, #1
	bne _021F3326
	ldrb r0, [r6, #1]
	add r4, r4, #1
	strb r0, [r6]
	mov r0, #6
	lsl r0, r0, #6
	add r5, r5, r0
	ldr r0, [sp, #0xc]
	add r6, r6, #1
	cmp r4, r0
	blt _021F331C
_021F3342:
	ldr r1, [sp, #0xc]
	mov r2, #6
	add r3, r1, #0
	lsl r2, r2, #6
	ldr r1, [sp, #8]
	mul r3, r2
	ldr r0, [sp, #4]
	add r1, r1, r3
	bl MI_CpuCopy8
	ldr r2, [sp, #0x10]
	ldr r0, [sp, #0xc]
	add r1, sp, #0x18
	strb r2, [r1, r0]
	ldr r0, [sp]
	bl ov112_021F3630
_021F3364:
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F3368: .word 0x000001F2
	thumb_func_end ov112_021F328C

	thumb_func_start ov112_021F336C
ov112_021F336C: ; 0x021F336C
	push {r4, r5, r6, lr}
	add r6, r1, #0
	add r5, r0, #0
	add r0, r6, #0
	bl Save_PlayerData_GetProfile
	add r4, r0, #0
	bl PlayerProfile_GetTrainerID
	str r0, [r5]
	add r0, r4, #0
	bl PlayerProfile_GetTrainerGender
	strb r0, [r5, #7]
	add r0, r4, #0
	bl PlayerProfile_GetLanguage
	strb r0, [r5, #5]
	add r0, r4, #0
	bl PlayerProfile_GetVersion
	strb r0, [r5, #6]
	add r0, r4, #0
	bl PlayerProfile_GetAvatar
	strb r0, [r5, #4]
	add r0, r4, #0
	bl PlayerProfile_GetNamePtr
	add r1, r0, #0
	add r0, r5, #0
	add r0, #8
	mov r2, #7
	bl CopyU16StringArrayN
	mov r4, #0
	add r5, #0x18
_021F33B6:
	add r0, r6, #0
	add r1, r4, #0
	bl sub_0202D660
	add r0, r6, #0
	add r1, r4, #0
	bl sub_0202D660
	add r1, r0, #0
	add r0, r5, #0
	bl MailMsg_Copy
	add r4, r4, #1
	add r5, #8
	cmp r4, #3
	blt _021F33B6
	pop {r4, r5, r6, pc}
	thumb_func_end ov112_021F336C
