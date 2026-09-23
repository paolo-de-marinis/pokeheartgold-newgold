#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/ribbon.h"
#include "constants/field_move_response.h"
#include "msgdata/msg/msg_0300.h"
	.include "asm/macros.inc"
	.include "unk_0208C3E4.inc"
	.include "global.inc"

	.public gOverlayTemplate_Battle
	.public gNatureStatMods

	.text

.public sub_0208CC88
.public sub_0208D0A4
.public sub_0208C87C

	thumb_func_start sub_0208C850
sub_0208C850: ; 0x0208C850
	push {r4, r5, r6, lr}
	add r6, r3, #0
	mov r3, #0x7a
	add r5, r0, #0
	lsl r3, r3, #4
	ldr r0, [r5, r3]
	add r4, r1, #0
	add r3, #0xc
	add r1, r2, #0
	ldr r2, [r5, r3]
	bl ReadMsgDataIntoString
	add r2, r5, #4
	lsl r1, r4, #4
	add r1, r2, r1
	ldr r3, [sp, #0x10]
	add r0, r5, #0
	add r2, r6, #0
	bl sub_0208C778
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end sub_0208C850

	thumb_func_start sub_0208C87C
sub_0208C87C: ; 0x0208C87C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x7a
	lsl r0, r0, #4
	ldr r0, [r5, r0]
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
	ldr r0, _0208C8C4 ; =0x000007A8
	add r3, r7, #0
	ldr r0, [r5, r0]
	bl BufferIntegerAsString
	ldr r1, _0208C8C4 ; =0x000007A8
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0208C8C4: .word 0x000007A8
	thumb_func_end sub_0208C87C

	thumb_func_start sub_0208C8C8
sub_0208C8C8: ; 0x0208C8C8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r4, r0, #0
	str r3, [sp, #0x10]
	mov r0, #0x89
	mov r3, #0x7a
	lsl r0, r0, #2
	lsl r7, r1, #4
	lsl r3, r3, #4
	ldr r5, [r4, r0]
	ldr r0, [r4, r3]
	add r3, #0xc
	add r1, r2, #0
	ldr r2, [r4, r3]
	bl ReadMsgDataIntoString
	ldr r1, _0208C99C ; =0x000007AC
	mov r0, #0
	ldr r1, [r4, r1]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r1, sp, #0x48
	ldrb r2, [r1]
	lsr r1, r0, #1
	sub r1, r2, r1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	add r0, r1, r0
	str r1, [sp, #0x14]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x18]
	add r0, sp, #0x4c
	ldrb r0, [r0]
	mov r1, #0
	ldr r2, _0208C99C ; =0x000007AC
	str r0, [sp, #0x1c]
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208C9A0 ; =0x00010200
	ldr r3, [sp, #0x14]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, [r4, r2]
	add r0, r5, r7
	bl AddTextPrinterParameterizedWithColor
	mov r0, #0
	str r0, [sp]
	add r3, sp, #0x28
	ldrh r2, [r3, #0x14]
	ldrb r3, [r3, #0x1c]
	ldr r1, [sp, #0x10]
	add r0, r4, #0
	bl sub_0208C87C
	ldr r1, _0208C99C ; =0x000007AC
	mov r0, #0
	ldr r1, [r4, r1]
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov ip, r0
	ldr r0, [sp, #0x1c]
	mov r1, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208C9A0 ; =0x00010200
	ldr r2, _0208C99C ; =0x000007AC
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r3, [sp, #0x14]
	mov r6, ip
	ldr r2, [r4, r2]
	add r0, r5, r7
	sub r3, r3, r6
	bl AddTextPrinterParameterizedWithColor
	mov r0, #0
	str r0, [sp]
	add r3, sp, #0x28
	ldrh r2, [r3, #0x18]
	ldrb r3, [r3, #0x1c]
	ldr r1, [sp, #0x38]
	add r0, r4, #0
	bl sub_0208C87C
	ldr r0, [sp, #0x1c]
	mov r1, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208C9A0 ; =0x00010200
	ldr r2, _0208C99C ; =0x000007AC
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, [r4, r2]
	ldr r3, [sp, #0x18]
	add r0, r5, r7
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0208C99C: .word 0x000007AC
_0208C9A0: .word 0x00010200
	thumb_func_end sub_0208C8C8

	thumb_func_start sub_0208C9A4
sub_0208C9A4: ; 0x0208C9A4
	push {r4, lr}
	sub sp, #0x10
	ldr r3, _0208CBC8 ; =0x000E0F00
	mov r1, #0
	mov r2, #7
	add r4, r0, #0
	str r1, [sp]
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #1
	mov r2, #0x17
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x6d
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x7e
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x80
	bl sub_0208C850
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldr r0, [r0, #0x34]
	cmp r0, #0
	beq _0208CA14
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x9d
	bl sub_0208C850
	b _0208CA1E
_0208CA14:
	add r0, r4, #0
	add r0, #0x54
	mov r1, #0
	bl FillWindowPixelBuffer
_0208CA1E:
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #6
	mov r2, #4
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #7
	mov r2, #8
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #8
	mov r2, #0xa
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #9
	mov r2, #0xc
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0xd
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xf
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0x11
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0xd
	mov r2, #0x13
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0x6e
	bl sub_0208C850
	mov r3, #0
	add r0, r4, #0
	mov r1, #0x10
	mov r2, #0x6f
	str r3, [sp]
	bl sub_0208C7F8
	mov r0, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0x11
	mov r2, #0x70
	mov r3, #1
	bl sub_0208C7F8
	mov r0, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0x12
	mov r2, #0x71
	mov r3, #3
	bl sub_0208C7F8
	mov r0, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0x13
	mov r2, #0x72
	mov r3, #4
	bl sub_0208C7F8
	mov r0, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0x14
	mov r2, #0x73
	mov r3, #2
	bl sub_0208C7F8
	mov r2, #0x7a
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	add r2, #0xc
	ldr r2, [r4, r2]
	mov r1, #0x74
	bl ReadMsgDataIntoString
	mov r1, #0
	str r1, [sp]
	mov r2, #0xff
	str r2, [sp, #4]
	ldr r0, _0208CBC8 ; =0x000E0F00
	add r2, #0x55
	str r0, [sp, #8]
	add r0, r4, r2
	ldr r2, _0208CBCC ; =0x000007AC
	str r1, [sp, #0xc]
	ldr r2, [r4, r2]
	mov r3, #3
	bl AddTextPrinterParameterizedWithColor
	mov r2, #0x7a
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	add r2, #0xc
	ldr r2, [r4, r2]
	mov r1, #0x92
	bl ReadMsgDataIntoString
	mov r3, #0
	str r3, [sp]
	mov r1, #0xff
	str r1, [sp, #4]
	ldr r0, _0208CBC8 ; =0x000E0F00
	ldr r2, _0208CBCC ; =0x000007AC
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r1, #0x75
	add r0, r4, r1
	ldr r2, [r4, r2]
	mov r1, #4
	bl AddTextPrinterParameterizedWithColor
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0x18
	mov r2, #0x95
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0x19
	mov r2, #0x93
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0x1a
	mov r2, #0x94
	bl sub_0208C850
	mov r0, #2
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0x1b
	mov r2, #0xa2
	bl sub_0208C850
	mov r0, #2
	str r0, [sp]
	ldr r3, _0208CBD0 ; =0x00010200
	add r0, r4, #0
	mov r1, #0x1c
	mov r2, #0xa0
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBD0 ; =0x00010200
	add r0, r4, #0
	mov r1, #0x1d
	mov r2, #0xb6
	bl sub_0208C850
	mov r0, #0
	str r0, [sp]
	ldr r3, _0208CBC8 ; =0x000E0F00
	add r0, r4, #0
	mov r1, #0x1e
	mov r2, #0xb3
	bl sub_0208C850
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_0208CBC8: .word 0x000E0F00
_0208CBCC: .word 0x000007AC
_0208CBD0: .word 0x00010200
	thumb_func_end sub_0208C9A4

	thumb_func_start sub_0208CBD4
sub_0208CBD4: ; 0x0208CBD4
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r0, #2
	str r0, [sp]
	mov r0, #0x12
	str r0, [sp, #4]
	mov r0, #0x16
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	mov r2, #0
	ldr r0, [r4]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r0, #1
	str r0, [sp]
	mov r0, #0x12
	str r0, [sp, #4]
	mov r0, #0x17
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	mov r2, #0
	ldr r0, [r4]
	mov r1, #4
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _0208CC84 ; =0x000007BC
	ldrsb r0, [r4, r0]
	cmp r0, #3
	bhi _0208CC7E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0208CC40: ; jump table
	.short _0208CC48 - _0208CC40 - 2 ; case 0
	.short _0208CC58 - _0208CC40 - 2 ; case 1
	.short _0208CC68 - _0208CC40 - 2 ; case 2
	.short _0208CC78 - _0208CC40 - 2 ; case 3
_0208CC48:
	add r0, r4, #0
	bl sub_0208CC88
	add r0, r4, #0
	bl sub_0208D0A4
	add sp, #0x10
	pop {r4, pc}
_0208CC58:
	add r0, r4, #0
	bl sub_0208D178
	add r0, r4, #0
	bl sub_0208D474
	add sp, #0x10
	pop {r4, pc}
_0208CC68:
	add r0, r4, #0
	bl sub_0208D520
	add r0, r4, #0
	bl sub_0208D6B8
	add sp, #0x10
	pop {r4, pc}
_0208CC78:
	add r0, r4, #0
	bl sub_0208D728
_0208CC7E:
	add sp, #0x10
	pop {r4, pc}
	nop
_0208CC84: .word 0x000007BC
	thumb_func_end sub_0208CBD4
