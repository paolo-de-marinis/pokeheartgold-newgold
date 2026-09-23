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

.public sub_0208D0A4

	thumb_func_start sub_0208CFB4
sub_0208CFB4: ; 0x0208CFB4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r0, r1, #0
	add r1, r2, #0
	mov r2, #0x13
	bl sub_0208E600
	add r4, r0, #0
	ldr r2, [r4, #0x18]
	cmp r2, #0
	beq _0208CFE8
	ldr r0, [r4, #0x14]
	mov r1, #0
	sub r0, r0, #1
	lsl r0, r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208D074 ; =0x00010200
	mov r3, #6
	str r0, [sp, #8]
	add r0, r5, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0208CFE8:
	ldr r2, [r4, #0x20]
	cmp r2, #0
	beq _0208D00A
	ldr r0, [r4, #0x1c]
	mov r1, #0
	sub r0, r0, #1
	lsl r0, r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208D074 ; =0x00010200
	mov r3, #6
	str r0, [sp, #8]
	add r0, r5, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0208D00A:
	ldr r2, [r4, #0x28]
	cmp r2, #0
	beq _0208D02C
	ldr r0, [r4, #0x24]
	mov r1, #0
	sub r0, r0, #1
	lsl r0, r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208D074 ; =0x00010200
	mov r3, #6
	str r0, [sp, #8]
	add r0, r5, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0208D02C:
	ldr r2, [r4, #0x38]
	cmp r2, #0
	beq _0208D04E
	ldr r0, [r4, #0x34]
	mov r1, #0
	sub r0, r0, #1
	lsl r0, r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208D074 ; =0x00010200
	mov r3, #6
	str r0, [sp, #8]
	add r0, r5, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0208D04E:
	mov r0, #5
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x12
	str r0, [sp, #8]
	mov r2, #0
	str r2, [sp, #0xc]
	ldr r0, [r5]
	mov r1, #1
	mov r3, #0x10
	bl FillBgTilemapRect
	add r0, r4, #0
	bl sub_0208E994
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_0208D074: .word 0x00010200
	thumb_func_end sub_0208CFB4

	thumb_func_start sub_0208D078
sub_0208D078: ; 0x0208D078
	push {r3, r4, r5, r6}
	ldr r6, _0208D0A0 ; =0x00000299
	sub r1, r6, #1
	ldrb r4, [r0, r1]
	sub r1, r6, #2
	ldrb r3, [r0, r1]
	sub r1, r6, #3
	ldrb r2, [r0, r1]
	sub r1, r6, #5
	ldrb r5, [r0, r6]
	sub r6, r6, #4
	ldrb r1, [r0, r1]
	ldrb r0, [r0, r6]
	add r0, r1, r0
	add r0, r2, r0
	add r0, r3, r0
	add r0, r4, r0
	add r0, r5, r0
	pop {r3, r4, r5, r6}
	bx lr
	.balign 4, 0
_0208D0A0: .word 0x00000299
	thumb_func_end sub_0208D078

	thumb_func_start sub_0208D0A4
sub_0208D0A4: ; 0x0208D0A4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r0, #0x14
	bl ScheduleWindowCopyToVram
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	add r0, #0x60
	bl FillWindowPixelBuffer
	add r0, r5, #0
	bl sub_0208A520
	add r6, r0, #0
	add r0, r5, #0
	bl sub_0208C73C
	add r7, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	ldrb r1, [r1, #0x11]
	cmp r1, #2
	bne _0208D102
	mov r0, #0x13
	bl AllocMonZeroed
	add r4, r0, #0
	add r0, r6, #0
	add r1, r4, #0
	bl CopyBoxPokemonToPokemon
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	add r0, #0x60
	add r2, r7, #0
	bl sub_0208CFB4
	add r0, r4, #0
	bl Heap_Free
	b _0208D110
_0208D102:
	sub r0, #8
	ldr r0, [r5, r0]
	add r1, r6, #0
	add r0, #0x60
	add r2, r7, #0
	bl sub_0208CFB4
_0208D110:
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r0, #0x60
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	bl sub_0208D078
	cmp r0, #0
	beq _0208D170
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	add r0, #0x70
	bl FillWindowPixelBuffer
	mov r0, #0x7a
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xc0
	bl NewString_ReadMsgData
	mov r1, #0
	add r4, r0, #0
	str r1, [sp]
	ldr r0, _0208D174 ; =0x00010200
	str r1, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x89
	str r1, [sp, #0xc]
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r2, r4, #0
	add r0, #0x70
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r0, #0x70
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
_0208D170:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0208D174: .word 0x00010200
	thumb_func_end sub_0208D0A4
