#include "constants/sndseq.h"
#include "constants/items.h"
#include "msgdata/msg/msg_0010.h"
	.include "asm/macros.inc"
	.include "overlay_15.inc"
	.include "global.inc"

	.text

	thumb_func_start ov15_021FE9F0
ov15_021FE9F0: ; 0x021FE9F0
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r1, #0
	add r1, sp, #0x18
	add r4, r2, #0
	add r6, r3, #0
	bl ov15_021FE990
	add r7, r0, #0
	cmp r6, #0
	bne _021FEA2C
	mov r0, #0x68
	str r0, [sp]
	mov r0, #0x10
	lsl r1, r4, #0x10
	str r0, [sp, #4]
	mov r3, #0
	str r3, [sp, #8]
	lsr r1, r1, #0x10
	str r1, [sp, #0xc]
	mov r1, #0x28
	str r1, [sp, #0x10]
	str r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	add r0, r5, #0
	ldr r1, [r1, #0x14]
	mov r2, #0x18
	bl BlitBitmapRectToWindow
	b _021FEA50
_021FEA2C:
	mov r0, #0x68
	str r0, [sp]
	mov r0, #0x10
	lsl r1, r4, #0x10
	str r0, [sp, #4]
	mov r3, #0
	str r3, [sp, #8]
	lsr r1, r1, #0x10
	str r1, [sp, #0xc]
	mov r1, #0x28
	str r1, [sp, #0x10]
	str r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	add r0, r5, #0
	ldr r1, [r1, #0x14]
	mov r2, #0x40
	bl BlitBitmapRectToWindow
_021FEA50:
	mov r0, #6
	add r1, r7, #0
	bl Heap_FreeExplicit
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov15_021FE9F0

	thumb_func_start ov15_021FEA5C
ov15_021FEA5C: ; 0x021FEA5C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl NewString_ReadMsgData
	mov r1, #3
	lsl r1, r1, #8
	str r0, [r4, r1]
	sub r1, #0x10
	ldr r0, [r4, r1]
	mov r1, #6
	bl NewString_ReadMsgData
	mov r1, #0xc1
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x14
	ldr r0, [r4, r1]
	mov r1, #0x10
	bl NewString_ReadMsgData
	mov r1, #0xc2
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x18
	ldr r0, [r4, r1]
	mov r1, #0x62
	bl NewString_ReadMsgData
	mov r1, #0xc3
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x1c
	ldr r0, [r4, r1]
	mov r1, #0x63
	bl NewString_ReadMsgData
	mov r1, #0x31
	lsl r1, r1, #4
	str r0, [r4, r1]
	sub r1, #0x20
	ldr r0, [r4, r1]
	mov r1, #1
	bl NewString_ReadMsgData
	mov r1, #0xc5
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x24
	ldr r0, [r4, r1]
	mov r1, #2
	bl NewString_ReadMsgData
	mov r1, #0xc6
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x28
	ldr r0, [r4, r1]
	mov r1, #0x12
	bl NewString_ReadMsgData
	mov r1, #0xc7
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x2c
	ldr r0, [r4, r1]
	mov r1, #3
	bl NewString_ReadMsgData
	mov r1, #0x32
	lsl r1, r1, #4
	str r0, [r4, r1]
	sub r1, #0x30
	ldr r0, [r4, r1]
	mov r1, #4
	bl NewString_ReadMsgData
	mov r1, #0xc9
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x34
	ldr r0, [r4, r1]
	mov r1, #5
	bl NewString_ReadMsgData
	mov r1, #0xca
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x38
	ldr r0, [r4, r1]
	mov r1, #8
	bl NewString_ReadMsgData
	mov r1, #0xcb
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x3c
	ldr r0, [r4, r1]
	mov r1, #0x4b
	bl NewString_ReadMsgData
	mov r1, #0x33
	lsl r1, r1, #4
	str r0, [r4, r1]
	sub r1, #0x40
	ldr r0, [r4, r1]
	mov r1, #0x56
	bl NewString_ReadMsgData
	mov r1, #0xcd
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x44
	ldr r0, [r4, r1]
	mov r1, #0
	bl NewString_ReadMsgData
	mov r1, #0xce
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x48
	ldr r0, [r4, r1]
	mov r1, #0x80
	bl NewString_ReadMsgData
	mov r1, #0xcf
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
	thumb_func_end ov15_021FEA5C

	thumb_func_start ov15_021FEB64
ov15_021FEB64: ; 0x021FEB64
	push {r4, r5, r6, lr}
	mov r6, #3
	add r5, r0, #0
	mov r4, #0
	lsl r6, r6, #8
_021FEB6E:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl String_Delete
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x10
	blo _021FEB6E
	pop {r4, r5, r6, pc}
	thumb_func_end ov15_021FEB64

	thumb_func_start ov15_021FEB84
ov15_021FEB84: ; 0x021FEB84
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r2, [r5, r0]
	add r0, r2, #0
	add r0, #0x64
	ldrb r1, [r0]
	mov r0, #0xc
	mul r0, r1
	add r0, r2, r0
	ldrb r0, [r0, #0xc]
	cmp r0, #3
	bne _021FEBDC
	add r0, r5, #0
	add r0, #0x14
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0x8d
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	add r0, r5, #0
	add r1, #0x66
	ldrh r1, [r1]
	bl ov15_021FE620
	add r0, r5, #4
	bl ScheduleWindowCopyToVram
	mov r1, #0x8d
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	add r0, r5, #0
	add r1, #0x66
	ldrh r1, [r1]
	mov r2, #1
	bl ov15_021FF97C
	add r0, r5, #0
	mov r1, #0
	bl ov15_021F9C78
_021FEBDC:
	add r0, r5, #0
	ldr r2, _021FEC98 ; =0x000003E2
	add r0, #0x24
	mov r1, #1
	mov r3, #0xc
	bl DrawFrameAndWindow2
	add r0, r5, #0
	add r0, #0x24
	mov r1, #0xf
	bl FillWindowPixelBuffer
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	add r0, r1, #0
	add r0, #0x64
	ldrb r2, [r0]
	mov r0, #0xc
	add r3, r1, #4
	mul r0, r2
	add r4, r3, r0
	add r0, r1, #0
	add r0, #0x65
	ldrb r0, [r0]
	cmp r0, #6
	bne _021FEC30
	add r1, #0x66
	ldrb r0, [r4, #8]
	ldrh r1, [r1]
	bl ov15_021FD3F0
	cmp r0, #0
	bne _021FEC30
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x6a
	bl NewString_ReadMsgData
	add r7, r0, #0
	b _021FEC3E
_021FEC30:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x2b
	bl NewString_ReadMsgData
	add r7, r0, #0
_021FEC3E:
	mov r0, #0x6c
	mov r1, #6
	bl String_New
	mov r1, #6
	ldrsh r2, [r4, r1]
	ldr r1, _021FEC9C ; =0x00000644
	add r6, r0, #0
	ldr r1, [r5, r1]
	add r0, r5, #0
	add r1, r2, r1
	sub r1, #8
	mov r2, #0
	bl ov15_021FE584
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r6, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	add r0, r5, #0
	add r0, #0x24
	mov r1, #1
	add r2, r6, #0
	str r3, [sp, #8]
	bl AddTextPrinterParameterized
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	add r5, #0x24
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021FEC98: .word 0x000003E2
_021FEC9C: .word 0x00000644
	thumb_func_end ov15_021FEB84

	thumb_func_start ov15_021FECA0
ov15_021FECA0: ; 0x021FECA0
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r4, r2, #0
	add r0, r5, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	lsl r1, r4, #0x10
	add r0, r6, #0
	lsr r1, r1, #0x10
	bl ov15_021FE5C4
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov15_021FECA0

	thumb_func_start ov15_021FECC4
ov15_021FECC4: ; 0x021FECC4
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	pop {r4, pc}
	thumb_func_end ov15_021FECC4

	thumb_func_start ov15_021FECD8
ov15_021FECD8: ; 0x021FECD8
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r1, #0
	mov r1, #0x2f
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	add r2, #0x78
	add r1, r2, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FED20 ; =0x000F0E00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	mov r3, #0x14
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021FED20: .word 0x000F0E00
	thumb_func_end ov15_021FECD8

	thumb_func_start ov15_021FED24
ov15_021FED24: ; 0x021FED24
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x24
	mov r1, #1
	bl ClearFrameAndWindow2
	add r4, #0x24
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov15_021FED24

	thumb_func_start ov15_021FED3C
ov15_021FED3C: ; 0x021FED3C
	push {r4, lr}
	add r4, r0, #0
	bl ov15_021FED24
	add r0, r4, #0
	bl ov15_021FE3E0
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov15_021FF97C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov15_021FED3C

	thumb_func_start ov15_021FED58
ov15_021FED58: ; 0x021FED58
	ldr r3, _021FED5C ; =ov15_021FE3E0
	bx r3
	.balign 4, 0
_021FED5C: .word ov15_021FE3E0
	thumb_func_end ov15_021FED58

	thumb_func_start ov15_021FED60
ov15_021FED60: ; 0x021FED60
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r0, #0x24
	mov r1, #0xff
	bl FillWindowPixelBuffer
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x2e
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r0, #0x82
	mov r1, #6
	bl String_New
	ldr r1, _021FEDE0 ; =0x00000672
	add r4, r0, #0
	ldrb r1, [r5, r1]
	add r0, r5, #0
	mov r2, #0
	bl ov15_021FE584
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r5, #0
	ldr r2, _021FEDE4 ; =0x000003E2
	add r0, #0x24
	mov r1, #1
	mov r3, #0xc
	bl DrawFrameAndWindow2
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FEDE8 ; =0x00010200
	mov r1, #1
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x24
	add r2, r4, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r5, #0x24
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021FEDE0: .word 0x00000672
_021FEDE4: .word 0x000003E2
_021FEDE8: .word 0x00010200
	thumb_func_end ov15_021FED60

	thumb_func_start ov15_021FEDEC
ov15_021FEDEC: ; 0x021FEDEC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	mov r0, #0x1a
	lsl r0, r0, #6
	str r1, [sp, #0x10]
	ldrsh r1, [r5, r0]
	mov r0, #0xfa
	lsl r0, r0, #2
	cmp r1, r0
	blt _021FEE06
	bl GF_AssertFail
_021FEE06:
	mov r0, #2
	mov r1, #6
	bl String_New
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x10]
	cmp r0, #2
	bne _021FEE1A
	mov r4, #0xa
	b _021FEE1C
_021FEE1A:
	mov r4, #0x64
_021FEE1C:
	mov r0, #0x1a
	lsl r0, r0, #6
	ldrsh r7, [r5, r0]
	ldr r0, [sp, #0x10]
	mov r6, #0
	cmp r0, #0
	bls _021FEE96
	add r5, #0xb4
_021FEE2C:
	add r0, r7, #0
	add r1, r4, #0
	bl _u32_div_f
	str r0, [sp, #0x18]
	mov r0, #1
	str r0, [sp]
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	mov r2, #1
	mov r3, #0
	bl String16_FormatInteger
	ldr r0, [sp, #0x18]
	add r1, r0, #0
	mul r1, r4
	sub r7, r7, r1
	add r0, r4, #0
	mov r1, #0xa
	bl _u32_div_f
	add r4, r0, #0
	add r0, r6, #0
	add r0, #0x11
	lsl r0, r0, #4
	str r0, [sp, #0x1c]
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FEEA0 ; =0x00010200
	mov r1, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x1c]
	ldr r2, [sp, #0x14]
	add r0, r5, r0
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x1c]
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x10]
	add r6, r6, #1
	cmp r6, r0
	blo _021FEE2C
_021FEE96:
	ldr r0, [sp, #0x14]
	bl String_Delete
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021FEEA0: .word 0x00010200
	thumb_func_end ov15_021FEDEC

	thumb_func_start ov15_021FEEA4
ov15_021FEEA4: ; 0x021FEEA4
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x37
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r3, #0x1a
	add r2, r0, #4
	add r0, #0x64
	ldrb r1, [r0]
	mov r0, #0xc
	lsl r3, r3, #6
	mul r0, r1
	add r1, r2, r0
	ldrsh r0, [r5, r3]
	cmp r0, #1
	ble _021FEEEA
	mov r2, #6
	ldrsh r2, [r1, r2]
	sub r3, #0x3c
	ldr r1, [r5, r3]
	add r0, r5, #0
	add r1, r2, r1
	sub r1, #8
	mov r2, #0
	bl ov15_021FE5A4
	b _021FEEFE
_021FEEEA:
	mov r2, #6
	ldrsh r2, [r1, r2]
	sub r3, #0x3c
	ldr r1, [r5, r3]
	add r0, r5, #0
	add r1, r2, r1
	sub r1, #8
	mov r2, #0
	bl ov15_021FE584
_021FEEFE:
	mov r0, #0
	str r0, [sp]
	mov r1, #1
	mov r2, #0x1a
	mov r0, #0xbd
	str r1, [sp, #4]
	lsl r2, r2, #6
	lsl r0, r0, #2
	ldrsh r2, [r5, r2]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	mov r0, #0xbd
	ldr r1, _021FEF40 ; =0x000005E4
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r4, #0
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	add r0, r5, #0
	mov r1, #0
	bl ov15_021FEF48
	ldr r1, _021FEF44 ; =0x00000616
	strb r0, [r5, r1]
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_021FEF40: .word 0x000005E4
_021FEF44: .word 0x00000616
	thumb_func_end ov15_021FEEA4

	thumb_func_start ov15_021FEF48
ov15_021FEF48: ; 0x021FEF48
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	cmp r1, #0
	bne _021FEF58
	add r4, r5, #0
	add r4, #0x34
	b _021FEF6C
_021FEF58:
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, #0
	bne _021FEF66
	bl GF_AssertFail
_021FEF66:
	mov r0, #0x81
	lsl r0, r0, #2
	add r4, r5, r0
_021FEF6C:
	add r0, r4, #0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r2, _021FEFB8 ; =0x000003E2
	add r0, r4, #0
	mov r1, #1
	mov r3, #0xc
	bl DrawFrameAndWindow2
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	mov r0, #1
	bl TextFlags_SetCanABSpeedUpPrint
	mov r0, #0
	bl TextFlags_SetAutoScrollParam
	mov r0, #9
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	ldr r0, _021FEFBC ; =ov15_021FEFC4
	ldr r2, _021FEFC0 ; =0x000005E4
	str r0, [sp, #8]
	ldr r2, [r5, r2]
	add r0, r4, #0
	mov r1, #1
	bl AddTextPrinterParameterized
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_021FEFB8: .word 0x000003E2
_021FEFBC: .word ov15_021FEFC4
_021FEFC0: .word 0x000005E4
	thumb_func_end ov15_021FEF48

	thumb_func_start ov15_021FEFC4
ov15_021FEFC4: ; 0x021FEFC4
	push {r3, lr}
	cmp r1, #4
	bhi _021FEFFC
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021FEFD6: ; jump table
	.short _021FEFFC - _021FEFD6 - 2 ; case 0
	.short _021FEFE0 - _021FEFD6 - 2 ; case 1
	.short _021FEFE6 - _021FEFD6 - 2 ; case 2
	.short _021FEFEC - _021FEFD6 - 2 ; case 3
	.short _021FEFF4 - _021FEFD6 - 2 ; case 4
_021FEFE0:
	bl GF_IsAnySEPlaying
	pop {r3, pc}
_021FEFE6:
	bl IsFanfarePlaying
	pop {r3, pc}
_021FEFEC:
	ldr r0, _021FF000 ; =SEQ_SE_DP_PC_LOGIN
	bl PlaySE
	b _021FEFFC
_021FEFF4:
	ldr r0, _021FF000 ; =SEQ_SE_DP_PC_LOGIN
	bl IsSEPlaying
	pop {r3, pc}
_021FEFFC:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021FF000: .word SEQ_SE_DP_PC_LOGIN
	thumb_func_end ov15_021FEFC4

	thumb_func_start ov15_021FF004
ov15_021FF004: ; 0x021FF004
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	ldr r0, [r4]
	add r2, sp, #0
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #0x81
	str r0, [sp, #8]
	mov r0, #9
	str r0, [sp, #0xc]
	mov r0, #0x19
	strb r0, [r2, #0x10]
	mov r0, #6
	strb r0, [r2, #0x11]
	ldrb r3, [r2, #0x12]
	mov r1, #0xf
	bic r3, r1
	strb r3, [r2, #0x12]
	ldrb r3, [r2, #0x12]
	mov r1, #0xf0
	bic r3, r1
	strb r3, [r2, #0x12]
	ldrb r3, [r2, #0x12]
	bic r3, r1
	strb r3, [r2, #0x12]
	mov r1, #0
	strb r1, [r2, #0x13]
	bl YesNoPrompt_Create
	ldr r1, _021FF054 ; =0x00000804
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	add r1, sp, #0
	bl YesNoPrompt_InitFromTemplate
	add sp, #0x14
	pop {r3, r4, pc}
	nop
_021FF054: .word 0x00000804
	thumb_func_end ov15_021FF004

	thumb_func_start ov15_021FF058
ov15_021FF058: ; 0x021FF058
	ldr r1, _021FF060 ; =0x00000804
	ldr r3, _021FF064 ; =YesNoPrompt_Destroy
	ldr r0, [r0, r1]
	bx r3
	.balign 4, 0
_021FF060: .word 0x00000804
_021FF064: .word YesNoPrompt_Destroy
	thumb_func_end ov15_021FF058

	thumb_func_start ov15_021FF068
ov15_021FF068: ; 0x021FF068
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r6, #0x89
	add r5, r0, #0
	lsl r6, r6, #2
	add r0, r5, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #0
	add r0, #0xcc
	ldr r0, [r5, r0]
	mov r1, #0x53
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r2, _021FF0F0 ; =0x00000684
	add r0, r6, #0
	ldr r3, [r5, r2]
	sub r2, r2, #4
	ldrsh r2, [r5, r2]
	add r0, #0xd0
	ldr r0, [r5, r0]
	mul r2, r3
	mov r1, #0
	mov r3, #6
	bl BufferIntegerAsString
	add r0, r6, #0
	ldr r1, _021FF0F4 ; =0x000005E4
	add r0, #0xd0
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r4, #0
	bl StringExpandPlaceholders
	ldr r1, _021FF0F4 ; =0x000005E4
	mov r0, #0
	ldr r1, [r5, r1]
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FF0F8 ; =0x00010200
	mov r1, #0
	str r0, [sp, #8]
	ldr r2, _021FF0F4 ; =0x000005E4
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r0, r5, r6
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, r6
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_021FF0F0: .word 0x00000684
_021FF0F4: .word 0x000005E4
_021FF0F8: .word 0x00010200
	thumb_func_end ov15_021FF068

	thumb_func_start ov15_021FF0FC
ov15_021FF0FC: ; 0x021FF0FC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #1
	add r7, r1, #0
	lsl r0, r0, #8
	mov r1, #6
	bl String_New
	mov r6, #0x85
	add r4, r0, #0
	lsl r6, r6, #2
	cmp r7, #0
	bne _021FF14E
	add r0, r5, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #0
	add r0, #0xdc
	ldr r0, [r5, r0]
	mov r1, #0x50
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FF1DC ; =0x00010200
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r5, r6
	mov r3, #4
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	b _021FF160
_021FF14E:
	mov r0, #0x48
	mov r1, #0
	str r0, [sp]
	mov r3, #0x10
	add r0, r5, r6
	add r2, r1, #0
	str r3, [sp, #4]
	bl FillWindowPixelRect
_021FF160:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x51
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	mov r0, #0x8f
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl PlayerProfile_GetMoney
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	mov r3, #6
	bl BufferIntegerAsString
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x10]
	add r1, r4, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r7, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FF1DC ; =0x00010200
	add r7, #8
	mov r3, #0x44
	str r0, [sp, #8]
	mov r1, #0
	add r0, r5, r6
	add r2, r4, #0
	sub r3, r3, r7
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, r6
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021FF1DC: .word 0x00010200
	thumb_func_end ov15_021FF0FC

	thumb_func_start ov15_021FF1E0
ov15_021FF1E0: ; 0x021FF1E0
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r5, #0
	add r4, #0x54
	add r0, r4, #0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r2, _021FF294 ; =0x000003F7
	add r0, r4, #0
	mov r1, #1
	mov r3, #0xe
	bl DrawFrameAndWindow1
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x73
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	add r0, r4, #0
	add r2, r6, #0
	add r3, r1, #0
	str r1, [sp, #8]
	bl AddTextPrinterParameterized
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x74
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0xbd
	lsl r0, r0, #2
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	mov r3, #3
	bl BufferIntegerAsString
	mov r0, #0xbd
	ldr r1, _021FF298 ; =0x000005E4
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	ldr r1, _021FF298 ; =0x000005E4
	mov r0, #0
	ldr r1, [r5, r1]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r3, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	mov r1, #0
	ldr r2, _021FF298 ; =0x000005E4
	str r1, [sp, #8]
	ldr r2, [r5, r2]
	mov r5, #0x58
	add r0, r4, #0
	sub r3, r5, r3
	bl AddTextPrinterParameterized
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	nop
_021FF294: .word 0x000003F7
_021FF298: .word 0x000005E4
	thumb_func_end ov15_021FF1E0

	thumb_func_start ov15_021FF29C
ov15_021FF29C: ; 0x021FF29C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x2f
	lsl r0, r0, #4
	add r6, r1, #0
	ldr r0, [r5, r0]
	mov r1, #8
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x74
	mov r1, #0
	bl FillWindowPixelBuffer
	cmp r6, #0
	bne _021FF2EE
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r1, #0
	add r3, r0, #0
	mov r6, #0x30
	sub r3, r6, r3
	lsr r3, r3, #1
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FF31C ; =0x000F0E00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x74
	add r3, #8
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	b _021FF308
_021FF2EE:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021FF31C ; =0x000F0E00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x74
	mov r3, #5
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_021FF308:
	add r5, #0x74
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_021FF31C: .word 0x000F0E00
	thumb_func_end ov15_021FF29C
