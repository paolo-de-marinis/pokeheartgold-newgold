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

	thumb_func_start sub_0208C3E4
sub_0208C3E4: ; 0x0208C3E4
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r5, #0
	add r4, r7, #4
_0208C3EC:
	ldr r2, _0208C428 ; =_02104D94
	lsl r6, r5, #4
	lsl r3, r5, #3
	ldr r0, [r7]
	add r1, r4, r6
	add r2, r2, r3
	bl AddWindow
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #0x22
	blo _0208C3EC
	add r0, r7, #0
	bl sub_0208C9A4
	add r0, r7, #0
	bl sub_0208C57C
	add r0, r7, #0
	bl sub_0208C614
	add r0, r7, #0
	bl sub_0208C6B4
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0208C428: .word _02104D94
	thumb_func_end sub_0208C3E4

	thumb_func_start sub_0208C42C
sub_0208C42C: ; 0x0208C42C
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	ldr r0, _0208C4D0 ; =0x000007BC
	ldrsb r0, [r4, r0]
	cmp r0, #3
	bhi _0208C4CE
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0208C444: ; jump table
	.short _0208C44C - _0208C444 - 2 ; case 0
	.short _0208C458 - _0208C444 - 2 ; case 1
	.short _0208C464 - _0208C444 - 2 ; case 2
	.short _0208C470 - _0208C444 - 2 ; case 3
_0208C44C:
	mov r0, #0x8a
	mov r1, #8
	lsl r0, r0, #2
	ldr r7, _0208C4D4 ; =_02104CC4
	str r1, [r4, r0]
	b _0208C48C
_0208C458:
	mov r0, #0x8a
	mov r1, #0x12
	lsl r0, r0, #2
	ldr r7, _0208C4D8 ; =_02104D04
	str r1, [r4, r0]
	b _0208C48C
_0208C464:
	mov r0, #0x8a
	mov r1, #8
	lsl r0, r0, #2
	ldr r7, _0208C4DC ; =_02104C84
	str r1, [r4, r0]
	b _0208C48C
_0208C470:
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #3
	beq _0208C480
	cmp r0, #4
	bne _0208C4CE
_0208C480:
	mov r0, #0x8a
	mov r1, #3
	lsl r0, r0, #2
	str r1, [r4, r0]
	b _0208C48C
_0208C48A:
	pop {r3, r4, r5, r6, r7, pc}
_0208C48C:
	mov r1, #0x8a
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	mov r0, #0x13
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl AllocWindows
	mov r1, #0x89
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #4
	ldr r0, [r4, r0]
	mov r5, #0
	cmp r0, #0
	bls _0208C4CE
	add r6, r5, #0
_0208C4AE:
	mov r1, #0x89
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	ldr r0, [r4]
	add r1, r1, r6
	add r2, r7, #0
	bl AddWindow
	mov r0, #0x8a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r5, r5, #1
	add r7, #8
	add r6, #0x10
	cmp r5, r0
	blo _0208C4AE
_0208C4CE:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0208C4D0: .word 0x000007BC
_0208C4D4: .word _02104CC4
_0208C4D8: .word _02104D04
_0208C4DC: .word _02104C84
	thumb_func_end sub_0208C42C

	thumb_func_start sub_0208C4E0
sub_0208C4E0: ; 0x0208C4E0
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	ldr r0, _0208C55C ; =0x000007BC
	ldrsb r0, [r4, r0]
	cmp r0, #3
	bhi _0208C55A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0208C4F8: ; jump table
	.short _0208C500 - _0208C4F8 - 2 ; case 0
	.short _0208C500 - _0208C4F8 - 2 ; case 1
	.short _0208C52A - _0208C4F8 - 2 ; case 2
	.short _0208C536 - _0208C4F8 - 2 ; case 3
_0208C500:
	mov r0, #0x8a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r6, #0
	cmp r0, #0
	bls _0208C548
	mov r7, #0x8a
	add r5, r6, #0
	lsl r7, r7, #2
_0208C512:
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, [r4, r7]
	add r6, r6, #1
	add r5, #0x10
	cmp r6, r0
	blo _0208C512
	b _0208C548
_0208C52A:
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ClearWindowTilemapAndCopyToVram
	b _0208C548
_0208C536:
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #3
	beq _0208C548
	cmp r0, #4
	beq _0208C548
	pop {r3, r4, r5, r6, r7, pc}
_0208C548:
	mov r1, #0x89
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl WindowArray_Delete
_0208C55A:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0208C55C: .word 0x000007BC
	thumb_func_end sub_0208C4E0

	thumb_func_start sub_0208C560
sub_0208C560: ; 0x0208C560
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl sub_0208C4E0
	mov r4, #0
	add r5, r5, #4
_0208C56C:
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x22
	blo _0208C56C
	pop {r3, r4, r5, pc}
	thumb_func_end sub_0208C560

	thumb_func_start sub_0208C57C
sub_0208C57C: ; 0x0208C57C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r4, #0x85
	add r5, r0, #0
	lsl r4, r4, #2
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	add r2, r4, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0208C60C ; =0x000E0F00
	add r2, #0x20
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r0, r5, r4
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	add r0, #0x2e
	ldrb r1, [r5, r0]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	bne _0208C600
	add r0, r0, #1
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1e
	bne _0208C5E0
	mov r2, #0x7a
	lsl r2, r2, #4
	ldr r0, [r5, r2]
	add r2, #0xc
	ldr r2, [r5, r2]
	mov r1, #1
	bl ReadMsgDataIntoString
	mov r2, #0xc1
	add r0, r5, #0
	add r1, r5, r4
	lsl r2, r2, #0xa
	mov r3, #1
	bl sub_0208C778
	b _0208C600
_0208C5E0:
	cmp r0, #1
	bne _0208C600
	mov r2, #0x7a
	lsl r2, r2, #4
	ldr r0, [r5, r2]
	add r2, #0xc
	ldr r2, [r5, r2]
	mov r1, #2
	bl ReadMsgDataIntoString
	ldr r2, _0208C610 ; =0x00050600
	add r0, r5, #0
	add r1, r5, r4
	mov r3, #1
	bl sub_0208C778
_0208C600:
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_0208C60C: .word 0x000E0F00
_0208C610: .word 0x00050600
	thumb_func_end sub_0208C57C

	thumb_func_start sub_0208C614
sub_0208C614: ; 0x0208C614
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r6, #0x81
	add r5, r0, #0
	lsl r6, r6, #2
	add r0, r5, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #0
	add r0, #0x7c
	ldr r0, [r5, r0]
	lsl r0, r0, #3
	lsr r0, r0, #0x1f
	bne _0208C69C
	mov r0, #5
	str r0, [sp]
	ldr r0, _0208C6A8 ; =0x0000079C
	mov r1, #1
	ldr r0, [r5, r0]
	add r2, r5, r6
	mov r3, #0
	bl sub_0200CDAC
	mov r0, #0x7a
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #3
	bl NewString_ReadMsgData
	mov r1, #0
	add r4, r0, #0
	add r2, r6, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	add r2, #0x3e
	ldrb r2, [r5, r2]
	ldr r0, _0208C6AC ; =0x000007A8
	mov r3, #3
	lsl r2, r2, #0x19
	ldr r0, [r5, r0]
	lsr r2, r2, #0x19
	bl BufferIntegerAsString
	ldr r1, _0208C6AC ; =0x000007A8
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	lsl r0, r6, #7
	str r0, [sp, #8]
	ldr r2, _0208C6B0 ; =0x000007AC
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r0, r5, r6
	mov r3, #0x10
	bl AddTextPrinterParameterizedWithColor
_0208C69C:
	add r0, r5, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0208C6A8: .word 0x0000079C
_0208C6AC: .word 0x000007A8
_0208C6B0: .word 0x000007AC
	thumb_func_end sub_0208C614

	thumb_func_start sub_0208C6B4
sub_0208C6B4: ; 0x0208C6B4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x7d
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0208C730 ; =0x0000023E
	ldrh r2, [r5, r0]
	cmp r2, #0
	beq _0208C6FA
	ldr r0, _0208C734 ; =0x000007A8
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferItemName
	mov r0, #0x7a
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #5
	bl NewString_ReadMsgData
	add r4, r0, #0
	ldr r1, _0208C734 ; =0x000007A8
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0208C70A
_0208C6FA:
	mov r2, #0x7a
	lsl r2, r2, #4
	ldr r0, [r5, r2]
	add r2, #0xc
	ldr r2, [r5, r2]
	mov r1, #6
	bl ReadMsgDataIntoString
_0208C70A:
	mov r1, #0x7d
	lsl r1, r1, #2
	ldr r2, _0208C738 ; =0x00010200
	add r0, r5, #0
	add r1, r5, r1
	mov r3, #0
	bl sub_0208C778
	add r0, r5, #0
	add r0, #0x64
	bl ScheduleWindowCopyToVram
	mov r0, #0x7d
	lsl r0, r0, #2
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	pop {r3, r4, r5, pc}
	nop
_0208C730: .word 0x0000023E
_0208C734: .word 0x000007A8
_0208C738: .word 0x00010200
	thumb_func_end sub_0208C6B4

	thumb_func_start sub_0208C73C
sub_0208C73C: ; 0x0208C73C
	push {r4, lr}
	mov r3, #0x8b
	lsl r3, r3, #2
	add r1, r0, #0
	add r2, r3, #0
	add r2, #0x18
	ldr r0, [r1, r3]
	ldr r4, [r1, r2]
	ldr r2, [r0, #0xc]
	cmp r4, r2
	bne _0208C774
	add r2, r3, #0
	add r2, #0x48
	ldrb r2, [r1, r2]
	ldrb r0, [r0, #0x10]
	cmp r2, r0
	bne _0208C774
	mov r2, #0x7b
	add r3, #0xc
	lsl r2, r2, #4
	ldr r0, [r1, r3]
	ldr r1, [r1, r2]
	bl String_Compare
	cmp r0, #0
	bne _0208C774
	mov r0, #1
	pop {r4, pc}
_0208C774:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end sub_0208C73C

	thumb_func_start sub_0208C778
sub_0208C778: ; 0x0208C778
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r6, r1, #0
	add r7, r2, #0
	cmp r3, #0
	beq _0208C790
	cmp r3, #1
	beq _0208C794
	cmp r3, #2
	beq _0208C7B6
	b _0208C7DA
_0208C790:
	mov r3, #0
	b _0208C7DA
_0208C794:
	ldr r1, _0208C7F4 ; =0x000007AC
	mov r0, #0
	ldr r1, [r4, r1]
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	add r0, r6, #0
	bl GetWindowWidth
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x18
	sub r0, r0, r5
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	b _0208C7DA
_0208C7B6:
	ldr r1, _0208C7F4 ; =0x000007AC
	mov r0, #0
	ldr r1, [r4, r1]
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	add r0, r6, #0
	bl GetWindowWidth
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x18
	sub r1, r0, r5
	lsr r0, r1, #0x1f
	add r0, r1, r0
	lsl r0, r0, #0x17
	lsr r3, r0, #0x18
_0208C7DA:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	str r7, [sp, #8]
	ldr r2, _0208C7F4 ; =0x000007AC
	str r1, [sp, #0xc]
	ldr r2, [r4, r2]
	add r0, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0208C7F4: .word 0x000007AC
	thumb_func_end sub_0208C778
