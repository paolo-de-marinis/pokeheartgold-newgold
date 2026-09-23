#include "constants/sndseq.h"
#include "constants/items.h"
#include "msgdata/msg/msg_0010.h"
	.include "asm/macros.inc"
	.include "overlay_15.inc"
	.include "global.inc"

	.text

	thumb_func_start ov15_021FE620
ov15_021FE620: ; 0x021FE620
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	add r4, r5, #0
	add r0, r1, #0
	add r4, #0x14
	bl TMHMGetMove
	str r0, [sp, #0x10]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x65
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r4, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x59
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	mov r1, #0
	str r0, [sp, #8]
	add r0, r4, #0
	add r2, r6, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x5c
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r4, #0
	mov r3, #0x48
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x5a
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r4, #0
	mov r3, #0xa8
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x5b
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	mov r1, #0
	str r0, [sp, #8]
	add r0, r4, #0
	add r2, r6, #0
	mov r3, #0xa8
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, [sp, #0x10]
	mov r1, #0
	bl GetMoveMaxPP
	add r7, r0, #0
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x5d
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	add r2, r7, #0
	mov r3, #2
	bl BufferIntegerAsString
	mov r0, #0xbd
	ldr r1, _021FE864 ; =0x000005E4
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	mov r1, #0
	str r0, [sp, #8]
	ldr r2, _021FE864 ; =0x000005E4
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r0, r4, #0
	mov r3, #0x30
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	mov r1, #2
	bl GetMoveAttr
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	cmp r7, #1
	bhi _021FE790
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x19
	bl NewString_ReadMsgData
	b _021FE79C
_021FE790:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x5e
	bl NewString_ReadMsgData
_021FE79C:
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r2, r7, #0
	mov r3, #3
	bl BufferIntegerAsString
	mov r0, #0xbd
	ldr r1, _021FE864 ; =0x000005E4
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	ldr r2, _021FE864 ; =0x000005E4
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r0, r4, #0
	mov r3, #0xe8
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	mov r1, #4
	bl GetMoveAttr
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	bne _021FE800
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x19
	bl NewString_ReadMsgData
	b _021FE80C
_021FE800:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x5e
	bl NewString_ReadMsgData
_021FE80C:
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r2, r7, #0
	mov r3, #3
	bl BufferIntegerAsString
	mov r0, #0xbd
	ldr r1, _021FE864 ; =0x000005E4
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FE860 ; =0x000F0E00
	mov r1, #0
	str r0, [sp, #8]
	ldr r2, _021FE864 ; =0x000005E4
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r0, r4, #0
	mov r3, #0xe8
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021FE860: .word 0x000F0E00
_021FE864: .word 0x000005E4
	thumb_func_end ov15_021FE620

	thumb_func_start ov15_021FE868
ov15_021FE868: ; 0x021FE868
	ldr r3, _021FE870 ; =ClearWindowTilemapAndScheduleTransfer
	add r0, #0x14
	bx r3
	nop
_021FE870: .word ClearWindowTilemapAndScheduleTransfer
	thumb_func_end ov15_021FE868

	thumb_func_start ov15_021FE874
ov15_021FE874: ; 0x021FE874
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0x27
	bl NewString_ReadMsgData
	ldr r1, _021FE89C ; =0x000005E8
	str r0, [r4, r1]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0x26
	bl NewString_ReadMsgData
	ldr r1, _021FE8A0 ; =0x000005EC
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_021FE89C: .word 0x000005E8
_021FE8A0: .word 0x000005EC
	thumb_func_end ov15_021FE874

	thumb_func_start ov15_021FE8A4
ov15_021FE8A4: ; 0x021FE8A4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021FE8BC ; =0x000005E8
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021FE8C0 ; =0x000005EC
	ldr r0, [r4, r0]
	bl String_Delete
	pop {r4, pc}
	nop
_021FE8BC: .word 0x000005E8
_021FE8C0: .word 0x000005EC
	thumb_func_end ov15_021FE8A4

	thumb_func_start ov15_021FE8C4
ov15_021FE8C4: ; 0x021FE8C4
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r6, r1, #0
	mov r0, #0xa
	mov r1, #6
	bl String_New
	mov r1, #0
	add r4, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r2, r6, #0
	mov r3, #3
	bl BufferIntegerAsString
	mov r0, #0xbd
	ldr r2, _021FE910 ; =0x000005EC
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r2, [r5, r2]
	add r1, r4, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r0, r4, #0
	bl String_Delete
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021FE910: .word 0x000005EC
	thumb_func_end ov15_021FE8C4
