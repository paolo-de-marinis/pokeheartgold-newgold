#include "constants/moves.h"
	.include "asm/macros.inc"
	.include "overlay_08.inc"
	.include "global.inc"

	.text

	thumb_func_start ov08_0221BE20
ov08_0221BE20: ; 0x0221BE20
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldrb r0, [r5, #0x11]
	cmp r0, #5
	bls _0221BE2E
	mov r0, #0
	strb r0, [r5, #0x11]
_0221BE2E:
	ldr r0, _0221BE88 ; =ov08_0221BE98
	ldr r1, _0221BE8C ; =0x00002090
	ldr r3, [r5, #0xc]
	mov r2, #0
	bl CreateSysTaskAndEnvironment
	bl SysTask_GetData
	ldr r2, _0221BE8C ; =0x00002090
	add r4, r0, #0
	mov r1, #0
	bl memset
	str r5, [r4]
	ldr r0, [r5, #8]
	bl BattleSystem_GetBgConfig
	mov r1, #0x79
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r5, #8]
	bl BattleSystem_GetPaletteData
	mov r1, #0x7a
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, _0221BE90 ; =0x00002078
	mov r1, #0
	strb r1, [r4, r0]
	ldrb r2, [r5, #0x11]
	sub r1, r0, #2
	strb r2, [r4, r1]
	sub r1, r0, #1
	ldrb r2, [r4, r1]
	mov r1, #0xf0
	sub r0, r0, #1
	bic r2, r1
	strb r2, [r4, r0]
	ldr r0, [r5, #8]
	ldr r1, [r5, #0x28]
	bl ov12_0223AB0C
	ldr r1, _0221BE94 ; =0x0000208F
	strb r0, [r4, r1]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221BE88: .word ov08_0221BE98
_0221BE8C: .word 0x00002090
_0221BE90: .word 0x00002078
_0221BE94: .word 0x0000208F
	thumb_func_end ov08_0221BE20

	thumb_func_start ov08_0221BE98
ov08_0221BE98: ; 0x0221BE98
	push {r4, lr}
	ldr r2, _0221C040 ; =0x00002078
	add r4, r1, #0
	ldrb r2, [r4, r2]
	cmp r2, #0x1a
	bls _0221BEA6
	b _0221C028
_0221BEA6:
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_0221BEB2: ; jump table
	.short _0221BEE8 - _0221BEB2 - 2 ; case 0
	.short _0221BEF4 - _0221BEB2 - 2 ; case 1
	.short _0221BF00 - _0221BEB2 - 2 ; case 2
	.short _0221BF0C - _0221BEB2 - 2 ; case 3
	.short _0221BF18 - _0221BEB2 - 2 ; case 4
	.short _0221BF24 - _0221BEB2 - 2 ; case 5
	.short _0221BF30 - _0221BEB2 - 2 ; case 6
	.short _0221BF3C - _0221BEB2 - 2 ; case 7
	.short _0221BF48 - _0221BEB2 - 2 ; case 8
	.short _0221BF54 - _0221BEB2 - 2 ; case 9
	.short _0221BF60 - _0221BEB2 - 2 ; case 10
	.short _0221BF6C - _0221BEB2 - 2 ; case 11
	.short _0221BF78 - _0221BEB2 - 2 ; case 12
	.short _0221BF84 - _0221BEB2 - 2 ; case 13
	.short _0221BF90 - _0221BEB2 - 2 ; case 14
	.short _0221BF9C - _0221BEB2 - 2 ; case 15
	.short _0221BFA8 - _0221BEB2 - 2 ; case 16
	.short _0221BFB4 - _0221BEB2 - 2 ; case 17
	.short _0221BFC0 - _0221BEB2 - 2 ; case 18
	.short _0221BFCC - _0221BEB2 - 2 ; case 19
	.short _0221BFD8 - _0221BEB2 - 2 ; case 20
	.short _0221BFE4 - _0221BEB2 - 2 ; case 21
	.short _0221BFF0 - _0221BEB2 - 2 ; case 22
	.short _0221BFFC - _0221BEB2 - 2 ; case 23
	.short _0221C008 - _0221BEB2 - 2 ; case 24
	.short _0221C014 - _0221BEB2 - 2 ; case 25
	.short _0221C020 - _0221BEB2 - 2 ; case 26
_0221BEE8:
	add r0, r4, #0
	bl ov08_0221C048
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BEF4:
	add r0, r4, #0
	bl ov08_0221C14C
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF00:
	add r0, r4, #0
	bl ov08_0221C318
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF0C:
	add r0, r4, #0
	bl ov08_0221C3C8
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF18:
	add r0, r4, #0
	bl ov08_0221C488
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF24:
	add r0, r4, #0
	bl ov08_0221C58C
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF30:
	add r0, r4, #0
	bl ov08_0221C918
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF3C:
	add r0, r4, #0
	bl ov08_0221C924
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF48:
	add r0, r4, #0
	bl ov08_0221C930
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF54:
	add r0, r4, #0
	bl ov08_0221C93C
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF60:
	add r0, r4, #0
	bl ov08_0221C948
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF6C:
	add r0, r4, #0
	bl ov08_0221C954
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF78:
	add r0, r4, #0
	bl ov08_0221C978
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF84:
	add r0, r4, #0
	bl ov08_0221C9A4
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF90:
	add r0, r4, #0
	bl ov08_0221C9C8
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BF9C:
	add r0, r4, #0
	bl ov08_0221CA08
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFA8:
	add r0, r4, #0
	bl ov08_0221CA20
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFB4:
	add r0, r4, #0
	bl ov08_0221CA34
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFC0:
	add r0, r4, #0
	bl ov08_0221CA50
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFCC:
	add r0, r4, #0
	bl ov08_0221C604
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFD8:
	add r0, r4, #0
	bl ov08_0221C6F8
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFE4:
	add r0, r4, #0
	bl ov08_0221C814
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFF0:
	add r0, r4, #0
	bl ov08_0221CA78
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221BFFC:
	add r0, r4, #0
	bl ov08_0221CA90
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221C008:
	add r0, r4, #0
	bl ov08_0221CC38
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221C014:
	add r0, r4, #0
	bl ov08_0221CD64
	ldr r1, _0221C040 ; =0x00002078
	strb r0, [r4, r1]
	b _0221C028
_0221C020:
	bl ov08_0221CD90
	cmp r0, #1
	beq _0221C03C
_0221C028:
	add r0, r4, #0
	bl ov08_0222145C
	ldr r0, _0221C044 ; =0x00001FB4
	ldr r0, [r4, r0]
	bl SpriteSystem_DrawSprites
	add r0, r4, #0
	bl ov08_022220FC
_0221C03C:
	pop {r4, pc}
	nop
_0221C040: .word 0x00002078
_0221C044: .word 0x00001FB4
	thumb_func_end ov08_0221BE98

	thumb_func_start ov08_0221C048
ov08_0221C048: ; 0x0221C048
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, _0221C13C ; =0x04001050
	mov r1, #0
	strh r1, [r0]
	ldr r0, [r5]
	add r0, #0x35
	ldrb r0, [r0]
	cmp r0, #3
	ldr r0, _0221C140 ; =0x0000207A
	bne _0221C068
	mov r1, #6
	strb r1, [r5, r0]
	mov r4, #0x13
	b _0221C06C
_0221C068:
	strb r1, [r5, r0]
	mov r4, #1
_0221C06C:
	ldr r0, [r5]
	ldr r0, [r0, #0xc]
	bl ov08_02224B64
	ldr r1, _0221C144 ; =0x00002088
	str r0, [r5, r1]
	add r0, r5, #0
	bl ov08_0221D184
	add r0, r5, #0
	bl ov08_0221CDF8
	add r0, r5, #0
	bl ov08_0221CF38
	add r0, r5, #0
	bl ov08_0221D0F4
	ldr r1, [r5]
	mov r0, #4
	ldr r1, [r1, #0xc]
	bl FontID_Alloc
	ldr r1, _0221C140 ; =0x0000207A
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl ov08_0221D8B0
	ldr r1, _0221C140 ; =0x0000207A
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl ov08_022221CC
	ldr r1, _0221C140 ; =0x0000207A
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl ov08_02222524
	add r0, r5, #0
	bl ov08_022205E0
	ldr r1, _0221C140 ; =0x0000207A
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl ov08_02220C5C
	add r0, r5, #0
	bl ov08_0221DC00
	ldr r1, _0221C140 ; =0x0000207A
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl ov08_0221DD70
	ldr r0, [r5]
	add r0, #0x32
	ldrb r0, [r0]
	cmp r0, #0
	beq _0221C0EC
	ldr r0, _0221C144 ; =0x00002088
	mov r1, #1
	ldr r0, [r5, r0]
	bl ov08_02224B90
_0221C0EC:
	ldr r0, _0221C140 ; =0x0000207A
	ldrb r0, [r5, r0]
	cmp r0, #0
	bne _0221C106
	add r0, r5, #0
	mov r1, #0
	bl ov08_0221DB24
	cmp r0, #1
	bne _0221C106
	ldr r0, [r5]
	mov r1, #1
	strb r1, [r0, #0x11]
_0221C106:
	ldr r1, _0221C140 ; =0x0000207A
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl ov08_0222171C
	ldr r1, _0221C140 ; =0x0000207A
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl ov08_0221D6CC
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x7a
	lsl r0, r0, #2
	mov r1, #0xa
	add r3, r1, #0
	ldr r0, [r5, r0]
	ldr r2, _0221C148 ; =0x0000FFFF
	sub r3, #0x12
	bl PaletteData_BeginPaletteFade
	add r0, r4, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0221C13C: .word 0x04001050
_0221C140: .word 0x0000207A
_0221C144: .word 0x00002088
_0221C148: .word 0x0000FFFF
	thumb_func_end ov08_0221C048
