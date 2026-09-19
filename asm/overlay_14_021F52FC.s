#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start ov14_021F52FC
ov14_021F52FC: ; 0x021F52FC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r4, r5, #0
	add r0, r2, #0
	add r7, r1, #0
	add r4, #0x30
	lsl r6, r0, #4
	add r0, r4, r6
	mov r1, #0
	str r2, [sp, #0x14]
	bl FillWindowPixelBuffer
	ldrh r2, [r7, #6]
	cmp r2, #0
	beq _021F5340
	ldr r0, [r5, #0x24]
	mov r1, #0
	bl BufferItemName
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r0, _021F5364 ; =0x00010200
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, [r5, #0x20]
	ldr r2, [sp, #0x14]
	add r0, r5, #0
	mov r3, #0x56
	bl ov14_021F4FBC
	b _021F535A
_021F5340:
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r0, _021F5364 ; =0x00010200
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, [r5, #0x20]
	ldr r2, [sp, #0x14]
	add r0, r5, #0
	mov r3, #0x5c
	bl ov14_021F4F84
_021F535A:
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F5364: .word 0x00010200
	thumb_func_end ov14_021F52FC

	thumb_func_start ov14_021F5368
ov14_021F5368: ; 0x021F5368
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r2, #0
	add r4, r1, #0
	bl ov14_021F5000
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	mov r2, #1
	bl ov14_021F5054
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	mov r2, #2
	bl ov14_021F50A0
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	mov r2, #4
	bl ov14_021F5114
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #5
	bl ov14_021F5190
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	mov r2, #6
	bl ov14_021F521C
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	mov r2, #7
	bl ov14_021F528C
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	mov r2, #8
	bl ov14_021F52FC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5368

	thumb_func_start ov14_021F53C0
ov14_021F53C0: ; 0x021F53C0
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x30
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x40
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x50
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x70
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x80
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x90
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xa0
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, #0xb0
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	thumb_func_end ov14_021F53C0

	thumb_func_start ov14_021F5404
ov14_021F5404: ; 0x021F5404
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x40
	add r6, r0, #0
	ldr r3, [r6, #0x34]
	ldr r0, _021F5558 ; =0x0000044E
	str r1, [sp, #0x1c]
	ldrb r0, [r3, r0]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	bne _021F541E
	mov r0, #9
	str r0, [sp, #0x20]
	b _021F5422
_021F541E:
	mov r0, #0xd
	str r0, [sp, #0x20]
_021F5422:
	ldr r0, _021F5558 ; =0x0000044E
	mov r2, #0xf
	ldrb r4, [r3, r0]
	add r1, r4, #0
	bic r1, r2
	lsl r2, r4, #0x1c
	lsr r4, r2, #0x1c
	mov r2, #1
	eor r4, r2
	lsl r4, r4, #0x18
	lsr r5, r4, #0x18
	mov r4, #0xf
	and r4, r5
	orr r1, r4
	strb r1, [r3, r0]
	mov r0, #0xa
	str r0, [sp]
	mov r0, #0x13
	mov r1, #6
	add r3, sp, #0x3c
	bl GfGfxLoader_GetCharData
	str r0, [sp, #0x34]
	ldr r0, [sp, #0x3c]
	ldr r2, _021F555C ; =0x000002EE
	ldr r0, [r0, #0x14]
	mov r1, #0x1b
	str r0, [sp, #0x30]
	mov r0, #0
	mov r3, #0xa
	bl NewMsgDataFromNarc
	str r0, [sp, #0x2c]
	ldr r0, [sp, #0x1c]
	ldrb r0, [r0, #0x12]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _021F553A
	mov r0, #0
	str r0, [sp, #0x28]
_021F5472:
	ldr r1, [sp, #0x20]
	ldr r0, [sp, #0x28]
	mov r4, #0
	add r0, r1, r0
	str r0, [sp, #0x24]
	lsl r7, r0, #4
	ldr r0, [sp, #0x30]
	str r0, [sp, #0x38]
	add r0, #0x20
	str r0, [sp, #0x38]
_021F5486:
	mov r0, #8
	str r0, [sp]
	lsl r5, r4, #3
	str r0, [sp, #4]
	lsl r0, r5, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	ldr r0, [r6, #0x34]
	mov r1, #0x16
	add r0, #0x30
	ldr r2, [sp, #0x30]
	lsl r1, r1, #4
	add r1, r2, r1
	mov r2, #0
	add r0, r0, r7
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	lsl r0, r5, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #8
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	ldr r0, [r6, #0x34]
	mov r2, #0
	add r0, #0x30
	ldr r1, [sp, #0x38]
	add r0, r0, r7
	add r3, r2, #0
	bl BlitBitmapRect
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0xb
	blo _021F5486
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r0, _021F5560 ; =0x00010200
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r3, [sp, #0x28]
	ldr r0, [r6, #0x34]
	lsl r4, r3, #1
	ldr r3, [sp, #0x1c]
	ldr r1, [sp, #0x2c]
	add r3, r3, r4
	ldrh r3, [r3, #0x14]
	ldr r2, [sp, #0x24]
	bl ov14_021F4F84
	ldr r1, [r6, #0x34]
	ldr r0, [sp, #0x24]
	add r1, #0x30
	lsl r0, r0, #4
	add r0, r1, r0
	bl CopyWindowPixelsToVram_TextMode
	ldr r0, [sp, #0x28]
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x28]
	cmp r0, #4
	blo _021F5472
	ldr r3, [r6, #0x34]
	ldr r1, _021F5558 ; =0x0000044E
	mov r0, #0x70
	ldrb r2, [r3, r1]
	bic r2, r0
	mov r0, #0x10
	orr r0, r2
	strb r0, [r3, r1]
	b _021F5546
_021F553A:
	ldr r3, [r6, #0x34]
	ldr r1, _021F5558 ; =0x0000044E
	mov r0, #0x70
	ldrb r2, [r3, r1]
	bic r2, r0
	strb r2, [r3, r1]
_021F5546:
	ldr r0, [sp, #0x2c]
	bl DestroyMsgData
	ldr r0, [sp, #0x34]
	bl Heap_Free
	ldr r0, [sp, #0x20]
	add sp, #0x40
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F5558: .word 0x0000044E
_021F555C: .word 0x000002EE
_021F5560: .word 0x00010200
	thumb_func_end ov14_021F5404

	thumb_func_start ov14_021F5564
ov14_021F5564: ; 0x021F5564
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r1, [sp, #0xc]
	add r6, r0, #0
	ldr r0, [r6, #0x34]
	ldr r1, _021F5618 ; =0x0000044E
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	bne _021F557C
	mov r7, #0x14
	b _021F557E
_021F557C:
	mov r7, #0x16
_021F557E:
	ldr r1, _021F5618 ; =0x0000044E
	add r5, r0, #0
	ldrb r2, [r0, r1]
	mov r1, #0xf
	add r5, #0x30
	add r3, r2, #0
	bic r3, r1
	lsl r1, r2, #0x1c
	lsr r2, r1, #0x1c
	mov r1, #1
	eor r1, r2
	lsl r1, r1, #0x18
	lsr r2, r1, #0x18
	mov r1, #0xf
	and r1, r2
	add r2, r3, #0
	orr r2, r1
	ldr r1, _021F5618 ; =0x0000044E
	lsl r4, r7, #4
	strb r2, [r0, r1]
	add r0, r5, r4
	mov r1, #0xd
	bl FillWindowPixelBuffer
	add r0, r5, r4
	add r0, #0x10
	mov r1, #0xd
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0xc]
	cmp r0, #0
	beq _021F5612
	ldr r0, [r6, #0x34]
	ldr r1, [sp, #0xc]
	ldr r0, [r0, #0x28]
	mov r2, #0xa
	bl GetItemNameIntoString
	mov r2, #0
	ldr r0, _021F561C ; =0x00010200
	str r2, [sp]
	str r0, [sp, #4]
	str r2, [sp, #8]
	ldr r1, [r6, #0x34]
	add r0, r5, r4
	ldr r1, [r1, #0x28]
	add r3, r2, #0
	bl ov14_021F4F24
	add r0, r5, r4
	bl CopyWindowPixelsToVram_TextMode
	ldr r0, [r6, #0x34]
	ldr r1, [sp, #0xc]
	ldr r0, [r0, #0x28]
	mov r2, #0xa
	bl GetItemDescIntoString
	mov r2, #0
	ldr r0, _021F561C ; =0x00010200
	str r2, [sp]
	str r0, [sp, #4]
	str r2, [sp, #8]
	ldr r1, [r6, #0x34]
	add r0, r5, r4
	ldr r1, [r1, #0x28]
	add r0, #0x10
	add r3, r2, #0
	bl ov14_021F4F24
	add r0, r5, r4
	add r0, #0x10
	bl CopyWindowPixelsToVram_TextMode
_021F5612:
	add r0, r7, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F5618: .word 0x0000044E
_021F561C: .word 0x00010200
	thumb_func_end ov14_021F5564

	thumb_func_start ov14_021F5620
ov14_021F5620: ; 0x021F5620
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	bl ov14_021F6628
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0
	add r0, #0x60
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #8
	str r0, [sp, #4]
	ldr r0, _021F5668 ; =0x00010200
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r3, [r5]
	ldr r0, [r5, #0x34]
	ldr r3, [r3, #8]
	add r1, r4, #0
	mov r2, #3
	add r3, #0x32
	bl ov14_021F4F84
	add r0, r4, #0
	bl DestroyMsgData
	ldr r0, [r5, #0x34]
	add r0, #0x60
	bl CopyWindowToVram
	add sp, #0x14
	pop {r4, r5, pc}
	.balign 4, 0
_021F5668: .word 0x00010200
	thumb_func_end ov14_021F5620

	thumb_func_start ov14_021F566C
ov14_021F566C: ; 0x021F566C
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	mov r0, #5
	ldr r1, [r4, #0x34]
	lsl r0, r0, #6
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x15
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x16
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r4, #0x34]
	mov r2, #0
	str r2, [sp]
	str r2, [sp, #4]
	ldr r1, _021F5714 ; =0x00010200
	str r2, [sp, #8]
	str r1, [sp, #0xc]
	str r2, [sp, #0x10]
	ldr r1, [r0, #0x20]
	mov r2, #0x11
	mov r3, #0x57
	bl ov14_021F4F84
	ldr r0, [r4, #0x34]
	mov r2, #0
	str r2, [sp]
	str r2, [sp, #4]
	ldr r1, _021F5714 ; =0x00010200
	str r2, [sp, #8]
	str r1, [sp, #0xc]
	str r2, [sp, #0x10]
	ldr r1, [r0, #0x20]
	mov r2, #0x12
	mov r3, #0x58
	bl ov14_021F4F84
	ldr r0, [r4, #0x34]
	mov r2, #0
	str r2, [sp]
	str r2, [sp, #4]
	ldr r1, _021F5714 ; =0x00010200
	str r2, [sp, #8]
	str r1, [sp, #0xc]
	str r2, [sp, #0x10]
	ldr r1, [r0, #0x20]
	mov r2, #0x13
	mov r3, #0x59
	bl ov14_021F4F84
	mov r0, #5
	ldr r1, [r4, #0x34]
	lsl r0, r0, #6
	add r0, r1, r0
	bl CopyWindowToVram
	mov r0, #0x15
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	bl CopyWindowToVram
	mov r0, #0x16
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	bl CopyWindowToVram
	add sp, #0x14
	pop {r3, r4, pc}
	nop
_021F5714: .word 0x00010200
	thumb_func_end ov14_021F566C

	thumb_func_start ov14_021F5718
ov14_021F5718: ; 0x021F5718
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r6, r0, #0
	str r1, [sp, #0x14]
	add r5, r3, #0
	mov r0, #0xa
	mov r1, #0x10
	add r7, r2, #0
	bl Heap_AllocAtEnd
	add r4, r0, #0
	mov r3, #0
	lsl r0, r5, #0x18
	str r3, [sp]
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	lsl r0, r7, #0x10
	str r3, [sp, #0xc]
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [r6, #0x34]
	mov r2, #3
	ldr r0, [r0, #0x14]
	bl AddWindowParameterized
	ldr r2, [sp, #0x30]
	ldr r0, [sp, #0x14]
	mul r2, r5
	ldr r1, [r4, #0xc]
	lsl r2, r2, #5
	bl MIi_CpuCopy32
	mov r0, #0x14
	mov r1, #0xa
	bl String_New
	add r7, r0, #0
	ldrb r1, [r6, #0x1f]
	ldr r0, [r6, #4]
	add r2, r7, #0
	bl PCStorage_GetBoxName
	mov r0, #0
	ldr r3, [sp, #0x30]
	str r0, [sp]
	ldr r0, _021F57B4 ; =0x00020100
	lsl r3, r3, #3
	str r0, [sp, #4]
	mov r0, #2
	lsl r2, r5, #3
	lsr r3, r3, #1
	str r0, [sp, #8]
	add r0, r4, #0
	add r1, r7, #0
	lsr r2, r2, #1
	sub r3, #8
	bl ov14_021F4F24
	add r0, r7, #0
	bl String_Delete
	add r0, r4, #0
	bl CopyWindowPixelsToVram_TextMode
	add r0, r4, #0
	bl RemoveWindow
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F57B4: .word 0x00020100
	thumb_func_end ov14_021F5718

	thumb_func_start ov14_021F57B8
ov14_021F57B8: ; 0x021F57B8
	push {r4, r5, lr}
	sub sp, #0x1c
	add r4, r0, #0
	add r0, sp, #0xc
	bl InitWindow
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r4, #0x34]
	add r1, sp, #0xc
	ldr r0, [r0, #0x14]
	mov r2, #0xc
	mov r3, #2
	bl AddTextWindowTopLeftCorner
	mov r0, #0x14
	mov r1, #0xa
	bl String_New
	add r5, r0, #0
	add r1, r4, #0
	add r1, #0x25
	ldrb r1, [r1]
	ldr r0, [r4, #4]
	add r2, r5, #0
	bl PCStorage_GetBoxName
	mov r3, #0
	ldr r0, _021F58B4 ; =0x00010200
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, sp, #0xc
	add r1, r5, #0
	mov r2, #0x30
	bl ov14_021F4F24
	add r0, r5, #0
	bl String_Delete
	ldr r0, [r4, #0x34]
	add r1, sp, #0xc
	mov r2, #0
	bl ov14_021F4EA0
	add r0, sp, #0xc
	bl RemoveWindow
	add r0, sp, #0xc
	bl InitWindow
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r4, #0x34]
	add r1, sp, #0xc
	ldr r0, [r0, #0x14]
	mov r2, #5
	mov r3, #2
	bl AddTextWindowTopLeftCorner
	ldr r0, [r4, #0x34]
	mov r1, #0x18
	ldr r0, [r0, #0x20]
	bl NewString_ReadMsgData
	add r1, r4, #0
	add r1, #0x25
	add r5, r0, #0
	ldrb r1, [r1]
	ldr r0, [r4, #4]
	bl PCStorage_CountMonsAndEggsInBox
	mov r1, #0
	add r2, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, [r4, #0x34]
	mov r3, #2
	ldr r0, [r0, #0x24]
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	ldr r0, [r4, #0x34]
	mov r2, #0x1e
	ldr r0, [r0, #0x24]
	mov r3, #2
	bl BufferIntegerAsString
	ldr r1, [r4, #0x34]
	add r2, r5, #0
	ldr r0, [r1, #0x24]
	ldr r1, [r1, #0x28]
	bl StringExpandPlaceholders
	mov r3, #0
	ldr r0, _021F58B4 ; =0x00010200
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	ldr r1, [r4, #0x34]
	add r0, sp, #0xc
	ldr r1, [r1, #0x28]
	mov r2, #0x14
	bl ov14_021F4F24
	add r0, r5, #0
	bl String_Delete
	ldr r0, [r4, #0x34]
	add r1, sp, #0xc
	mov r2, #1
	bl ov14_021F4EA0
	add r0, sp, #0xc
	bl RemoveWindow
	add sp, #0x1c
	pop {r4, r5, pc}
	.balign 4, 0
_021F58B4: .word 0x00010200
	thumb_func_end ov14_021F57B8

	thumb_func_start ov14_021F58B8
ov14_021F58B8: ; 0x021F58B8
	push {r4, r5, lr}
	sub sp, #0x1c
	add r5, r0, #0
	add r0, sp, #0xc
	bl InitWindow
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r5, #0x34]
	add r1, sp, #0xc
	ldr r0, [r0, #0x14]
	mov r2, #0xc
	mov r3, #2
	bl AddTextWindowTopLeftCorner
	ldr r2, [r5, #0x34]
	ldr r0, _021F5948 ; =0x0000044D
	ldrb r1, [r2, r0]
	cmp r1, #0x10
	blo _021F590E
	ldr r0, [r5, #4]
	sub r1, #0x10
	bl PCStorage_IsBonusWallpaperUnlocked
	cmp r0, #0
	bne _021F58FC
	ldr r0, [r5, #0x34]
	mov r1, #0x3b
	ldr r0, [r0, #0x20]
	bl NewString_ReadMsgData
	add r4, r0, #0
	b _021F5918
_021F58FC:
	ldr r2, [r5, #0x34]
	ldr r1, _021F5948 ; =0x0000044D
	ldr r0, [r2, #0x20]
	ldrb r1, [r2, r1]
	add r1, #0x23
	bl NewString_ReadMsgData
	add r4, r0, #0
	b _021F5918
_021F590E:
	ldr r0, [r2, #0x20]
	add r1, #0x23
	bl NewString_ReadMsgData
	add r4, r0, #0
_021F5918:
	mov r3, #0
	ldr r0, _021F594C ; =0x00010200
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, sp, #0xc
	add r1, r4, #0
	mov r2, #0x30
	bl ov14_021F4F24
	add r0, r4, #0
	bl String_Delete
	ldr r0, [r5, #0x34]
	add r1, sp, #0xc
	mov r2, #0
	bl ov14_021F4EA0
	add r0, sp, #0xc
	bl RemoveWindow
	add sp, #0x1c
	pop {r4, r5, pc}
	.balign 4, 0
_021F5948: .word 0x0000044D
_021F594C: .word 0x00010200
	thumb_func_end ov14_021F58B8

	thumb_func_start ov14_021F5950
ov14_021F5950: ; 0x021F5950
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x70
	ldr r5, [r0, #0x34]
	lsl r4, r1, #4
	add r5, #0x30
	str r0, [sp, #0x1c]
	add r0, r5, r4
	str r2, [sp, #0x20]
	add r6, r3, #0
	bl GetWindowBgId
	add r0, r5, r4
	bl GetWindowX
	add r0, r5, r4
	bl GetWindowY
	add r0, r5, r4
	bl GetWindowWidth
	str r0, [sp, #0x30]
	add r0, r5, r4
	bl GetWindowHeight
	str r0, [sp, #0x3c]
	cmp r6, #1
	bne _021F599A
	add r0, r5, r4
	mov r1, #0xb
	bl FillWindowPixelBuffer
	ldr r0, _021F5BD4 ; =0x000E0F00
	str r0, [sp, #0x4c]
	mov r0, #6
	lsl r0, r0, #6
	str r0, [sp, #0x40]
	b _021F59AA
_021F599A:
	add r0, r5, r4
	mov r1, #4
	bl FillWindowPixelBuffer
	ldr r0, _021F5BD4 ; =0x000E0F00
	str r0, [sp, #0x4c]
	mov r0, #0
	str r0, [sp, #0x40]
_021F59AA:
	mov r0, #0xa
	str r0, [sp]
	mov r0, #0x13
	mov r1, #0x40
	mov r2, #1
	add r3, sp, #0x6c
	bl GfGfxLoader_GetCharData
	str r0, [sp, #0x50]
	ldr r0, [sp, #0x6c]
	mov r2, #0
	ldr r6, [r0, #0x14]
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	str r2, [sp, #8]
	str r2, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r1, [sp, #0x40]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x30]
	mov r2, #0
	sub r0, r0, #1
	lsl r7, r0, #3
	str r0, [sp, #0x2c]
	mov r0, #8
	str r0, [sp]
	lsl r1, r7, #0x10
	str r0, [sp, #4]
	lsr r1, r1, #0x10
	str r1, [sp, #8]
	str r2, [sp, #0xc]
	ldr r1, [sp, #0x40]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	add r1, #0x40
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x3c]
	mov r3, #0
	sub r0, r0, #1
	str r0, [sp, #0x38]
	lsl r0, r0, #3
	str r0, [sp, #0x34]
	mov r0, #8
	ldr r1, [sp, #0x34]
	str r0, [sp]
	str r0, [sp, #4]
	lsl r1, r1, #0x10
	str r3, [sp, #8]
	lsr r1, r1, #0x10
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r2, #0xff
	str r2, [sp, #0x18]
	ldr r1, [sp, #0x40]
	add r2, #0x21
	add r1, r1, r2
	add r0, r5, r4
	add r1, r6, r1
	add r2, r3, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	lsl r1, r7, #0x10
	str r0, [sp, #4]
	lsr r1, r1, #0x10
	str r1, [sp, #8]
	ldr r1, [sp, #0x34]
	mov r2, #0xff
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	str r2, [sp, #0x18]
	ldr r1, [sp, #0x40]
	add r2, #0x61
	add r1, r1, r2
	mov r2, #0
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x38]
	mov r7, #1
	cmp r0, #1
	ble _021F5AFE
	ldr r0, [sp, #0x40]
	ldr r1, [sp, #0x40]
	str r0, [sp, #0x54]
	add r0, #0x60
	str r0, [sp, #0x54]
	ldr r0, [sp, #0x30]
	str r1, [sp, #0x58]
	sub r0, r0, #1
	add r1, #0xa0
	lsl r0, r0, #3
	str r1, [sp, #0x58]
	ldr r1, [sp, #0x3c]
	lsl r0, r0, #0x10
	sub r1, r1, #1
	lsr r0, r0, #0x10
	str r1, [sp, #0x44]
	str r0, [sp, #0x5c]
_021F5A9A:
	lsl r0, r7, #3
	str r0, [sp, #0x28]
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	ldr r0, [sp, #0x28]
	ldr r1, [sp, #0x54]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [sp, #0x5c]
	ldr r1, [sp, #0x58]
	str r0, [sp, #8]
	ldr r0, [sp, #0x28]
	mov r2, #0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	add r0, r7, #1
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, [sp, #0x44]
	cmp r7, r0
	blt _021F5A9A
_021F5AFE:
	ldr r0, [sp, #0x2c]
	mov r7, #1
	cmp r0, #1
	ble _021F5B8E
	ldr r0, [sp, #0x40]
	mov r2, #5
	str r0, [sp, #0x60]
	add r0, #0x20
	str r0, [sp, #0x60]
	ldr r0, [sp, #0x3c]
	ldr r1, [sp, #0x40]
	lsl r2, r2, #6
	sub r0, r0, #1
	add r1, r1, r2
	lsl r0, r0, #3
	str r1, [sp, #0x64]
	ldr r1, [sp, #0x30]
	lsl r0, r0, #0x10
	sub r1, r1, #1
	lsr r0, r0, #0x10
	str r1, [sp, #0x48]
	str r0, [sp, #0x68]
_021F5B2A:
	lsl r0, r7, #3
	str r0, [sp, #0x24]
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [sp, #0x24]
	ldr r1, [sp, #0x60]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [sp, #0x24]
	ldr r1, [sp, #0x64]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	ldr r0, [sp, #0x68]
	mov r2, #0
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	add r0, r7, #1
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, [sp, #0x48]
	cmp r7, r0
	blt _021F5B2A
_021F5B8E:
	ldr r0, [sp, #0x50]
	bl Heap_Free
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x20]
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0x20]
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r2, [sp, #0x30]
	mov r7, #4
	lsl r3, r2, #3
	lsr r2, r3, #0x1f
	add r2, r3, r2
	ldr r0, [sp, #0x4c]
	str r7, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, r5, r4
	add r1, r6, #0
	asr r2, r2, #1
	add r3, r7, #0
	bl ov14_021F4F24
	add r0, r6, #0
	bl String_Delete
	add r0, r5, r4
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x70
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F5BD4: .word 0x000E0F00
	thumb_func_end ov14_021F5950

	thumb_func_start ov14_021F5BD8
ov14_021F5BD8: ; 0x021F5BD8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r0, #0
	ldr r5, [r7, #0x34]
	lsl r4, r1, #4
	add r5, #0x30
	add r0, r5, r4
	str r2, [sp, #0xc]
	add r6, r3, #0
	bl GetWindowBgId
	add r0, r5, r4
	bl GetWindowX
	add r0, r5, r4
	bl GetWindowY
	add r0, r5, r4
	bl GetWindowWidth
	str r0, [sp, #0x10]
	add r0, r5, r4
	bl GetWindowHeight
	cmp r6, #1
	bne _021F5C16
	add r0, r5, r4
	mov r1, #0xb
	bl FillWindowPixelBuffer
	b _021F5C1E
_021F5C16:
	add r0, r5, r4
	mov r1, #4
	bl FillWindowPixelBuffer
_021F5C1E:
	ldr r0, [r7, #0x34]
	ldr r1, [sp, #0xc]
	ldr r0, [r0, #0x20]
	ldr r6, _021F5C80 ; =0x000E0F00
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r0, sp, #0x18
	ldrb r0, [r0, #0x10]
	add r1, r0, #0
	add r1, #0xfe
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	cmp r1, #1
	bhi _021F5C5A
	mov r1, #4
	str r1, [sp]
	str r6, [sp, #4]
	str r0, [sp, #8]
	ldr r2, [sp, #0x10]
	add r0, r5, r4
	lsl r3, r2, #3
	lsr r2, r3, #0x1f
	add r2, r3, r2
	add r1, r7, #0
	asr r2, r2, #1
	mov r3, #0
	bl ov14_021F4F24
	b _021F5C6E
_021F5C5A:
	mov r1, #4
	str r1, [sp]
	str r6, [sp, #4]
	mov r2, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r1, r7, #0
	add r3, r2, #0
	bl ov14_021F4F24
_021F5C6E:
	add r0, r7, #0
	bl String_Delete
	add r0, r5, r4
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021F5C80: .word 0x000E0F00
	thumb_func_end ov14_021F5BD8

	thumb_func_start ov14_021F5C84
ov14_021F5C84: ; 0x021F5C84
	push {r3, lr}
	add r3, r1, #0
	mov r1, #0x18
	mov r2, #0x3c
	bl ov14_021F5950
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5C84

	thumb_func_start ov14_021F5C94
ov14_021F5C94: ; 0x021F5C94
	push {r4, r5, r6, r7, lr}
	sub sp, #0x3c
	ldr r5, [r0, #0x34]
	lsl r4, r1, #4
	add r5, #0x30
	str r0, [sp, #0x1c]
	add r0, r5, r4
	str r2, [sp, #0x20]
	bl GetWindowWidth
	str r0, [sp, #0x2c]
	mov r0, #0xa
	str r0, [sp]
	mov r0, #0x13
	mov r1, #0xe
	mov r2, #1
	add r3, sp, #0x38
	bl GfGfxLoader_GetCharData
	str r0, [sp, #0x34]
	ldr r0, [sp, #0x38]
	mov r2, #0
	ldr r6, [r0, #0x14]
	mov r1, #0x18
	str r1, [sp]
	mov r0, #8
	str r0, [sp, #4]
	str r2, [sp, #8]
	str r2, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #0xae
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #4
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r1, #0x18
	mov r2, #0
	str r1, [sp]
	mov r0, #8
	str r0, [sp, #4]
	str r2, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #0xb6
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #4
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r3, #0x18
	str r3, [sp]
	mov r1, #8
	str r1, [sp, #4]
	mov r2, #0
	str r2, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	str r3, [sp, #0x10]
	str r1, [sp, #0x14]
	mov r1, #0xb2
	mov r0, #0xff
	lsl r1, r1, #4
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x2c]
	sub r0, r0, #1
	str r0, [sp, #0x28]
	lsl r7, r0, #3
	mov r0, #8
	str r0, [sp]
	lsl r1, r7, #0x10
	mov r2, #0
	str r0, [sp, #4]
	lsr r1, r1, #0x10
	str r1, [sp, #8]
	str r2, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r1, #0xd6
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #4
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r1, #8
	str r1, [sp]
	lsl r0, r7, #0x10
	mov r2, #0
	str r1, [sp, #4]
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r1, [sp, #0x14]
	mov r1, #0xd2
	mov r0, #0xff
	lsl r1, r1, #4
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	lsl r1, r7, #0x10
	mov r2, #0
	str r0, [sp, #4]
	lsr r1, r1, #0x10
	str r1, [sp, #8]
	mov r1, #0x10
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r1, #0x35
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #6
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x28]
	mov r7, #1
	cmp r0, #1
	ble _021F5E4A
	ldr r0, [sp, #0x2c]
	sub r0, r0, #1
	str r0, [sp, #0x30]
_021F5DB8:
	lsl r0, r7, #3
	str r0, [sp, #0x24]
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [sp, #0x24]
	mov r1, #0xb
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #8
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [sp, #0x24]
	mov r1, #0x2e
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #8
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #6
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [sp, #0x24]
	mov r1, #0x2d
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #6
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r5, r4
	add r1, r6, r1
	add r3, r2, #0
	bl BlitBitmapRect
	add r0, r7, #1
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, [sp, #0x30]
	cmp r7, r0
	blt _021F5DB8
_021F5E4A:
	ldr r0, [sp, #0x34]
	bl Heap_Free
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x20]
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0x20]
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r2, [sp, #0x2c]
	mov r7, #4
	lsl r3, r2, #3
	lsr r2, r3, #0x1f
	add r2, r3, r2
	ldr r0, _021F5E90 ; =0x00090A00
	str r7, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, r5, r4
	add r1, r6, #0
	asr r2, r2, #1
	add r3, r7, #0
	bl ov14_021F4F24
	add r0, r6, #0
	bl String_Delete
	add r0, r5, r4
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x3c
	pop {r4, r5, r6, r7, pc}
	nop
_021F5E90: .word 0x00090A00
	thumb_func_end ov14_021F5C94

	thumb_func_start ov14_021F5E94
ov14_021F5E94: ; 0x021F5E94
	push {r3, lr}
	ldr r1, [r0]
	ldr r1, [r1, #8]
	cmp r1, #3
	bne _021F5EA8
	mov r1, #0x19
	mov r2, #0x40
	bl ov14_021F5C94
	pop {r3, pc}
_021F5EA8:
	mov r1, #0x19
	mov r2, #0x3d
	bl ov14_021F5C94
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5E94

	thumb_func_start ov14_021F5EB4
ov14_021F5EB4: ; 0x021F5EB4
	push {r3, lr}
	add r3, r1, #0
	mov r1, #0x1a
	mov r2, #0x3e
	bl ov14_021F5950
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5EB4

	thumb_func_start ov14_021F5EC4
ov14_021F5EC4: ; 0x021F5EC4
	push {r3, lr}
	add r3, r1, #0
	mov r1, #0x1b
	mov r2, #0x4c
	bl ov14_021F5950
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5EC4

	thumb_func_start ov14_021F5ED4
ov14_021F5ED4: ; 0x021F5ED4
	push {r3, lr}
	add r3, r1, #0
	mov r1, #0x1c
	mov r2, #0x47
	bl ov14_021F5950
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5ED4

	thumb_func_start ov14_021F5EE4
ov14_021F5EE4: ; 0x021F5EE4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	str r1, [sp, #0xc]
	mov r0, #0x2f
	add r6, r2, #0
	add r2, sp, #0x14
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #3
	add r2, #2
	add r3, sp, #0x14
	bl sub_02019B44
	mov r4, #0
	cmp r6, #0
	bls _021F5F90
	sub r0, r6, #1
	str r0, [sp, #0x10]
	add r7, sp, #0x14
_021F5F0E:
	ldr r0, [sp, #0x10]
	sub r0, r0, r4
	lsl r1, r0, #2
	ldr r0, [sp, #0xc]
	add r2, r0, r1
	ldrh r0, [r2, #2]
	cmp r0, #0
	bne _021F5F56
	ldrh r2, [r2]
	mov r1, #0x21
	add r0, r5, #0
	sub r1, r1, r4
	mov r3, #0
	bl ov14_021F5950
	ldrh r0, [r7, #2]
	mov r2, #0
	add r3, r2, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldrh r0, [r7]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0xc
	str r0, [sp, #8]
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #7
	sub r1, r1, r4
	bl sub_020199F4
	b _021F5F8A
_021F5F56:
	ldrh r2, [r2]
	mov r1, #0x21
	add r0, r5, #0
	sub r1, r1, r4
	bl ov14_021F5C94
	ldrh r0, [r7, #2]
	mov r2, #0
	add r3, r2, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldrh r0, [r7]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #7
	sub r1, r1, r4
	bl sub_020199F4
_021F5F8A:
	add r4, r4, #1
	cmp r4, r6
	blo _021F5F0E
_021F5F90:
	cmp r6, #5
	bhs _021F5FB6
	mov r7, #0x21
_021F5F96:
	sub r0, r7, r6
	lsl r4, r0, #4
	ldr r0, [r5, #0x34]
	mov r1, #0
	add r0, #0x30
	add r0, r0, r4
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x34]
	add r0, #0x30
	add r0, r0, r4
	bl CopyWindowPixelsToVram_TextMode
	add r6, r6, #1
	cmp r6, #5
	blo _021F5F96
_021F5FB6:
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5EE4

	thumb_func_start ov14_021F5FBC
ov14_021F5FBC: ; 0x021F5FBC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #2
	ldr r1, [r5, #0x34]
	lsl r0, r0, #8
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x21
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x22
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x23
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #2
	ldr r1, [r5, #0x34]
	lsl r0, r0, #8
	add r0, r1, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x21
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x22
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x23
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r0, r1, r0
	bl CopyWindowPixelsToVram_TextMode
	cmp r4, #0
	bne _021F603C
	add r0, r5, #0
	mov r1, #0x21
	mov r2, #0x51
	mov r3, #0
	bl ov14_021F5950
	pop {r3, r4, r5, pc}
_021F603C:
	add r0, r5, #0
	mov r1, #0x21
	mov r2, #0x50
	mov r3, #0
	bl ov14_021F5950
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F5FBC

	thumb_func_start ov14_021F604C
ov14_021F604C: ; 0x021F604C
	push {r3, lr}
	mov r1, #0x2a
	mov r2, #0x3f
	mov r3, #0
	bl ov14_021F5950
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F604C

	thumb_func_start ov14_021F605C
ov14_021F605C: ; 0x021F605C
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #0x29
	mov r2, #0x4d
	mov r3, #0
	bl ov14_021F5BD8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F605C

	thumb_func_start ov14_021F6070
ov14_021F6070: ; 0x021F6070
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F605C
	add r0, r4, #0
	mov r1, #0x20
	mov r2, #0x1a
	mov r3, #0
	bl ov14_021F5950
	add r0, r4, #0
	mov r1, #0x21
	mov r2, #0x1b
	mov r3, #0
	bl ov14_021F5950
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6070

	thumb_func_start ov14_021F6094
ov14_021F6094: ; 0x021F6094
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #0x29
	mov r2, #0x4e
	mov r3, #0
	bl ov14_021F5BD8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6094

	thumb_func_start ov14_021F60A8
ov14_021F60A8: ; 0x021F60A8
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #0x29
	mov r2, #0x4f
	mov r3, #0
	bl ov14_021F5BD8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F60A8

	thumb_func_start ov14_021F60BC
ov14_021F60BC: ; 0x021F60BC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r6, r1, #0
	add r4, r2, #0
	bl sub_02019B08
	add r2, sp, #0xc
	add r7, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	add r2, #2
	add r3, sp, #0xc
	bl sub_02019B44
	add r0, r4, #0
	bl GetWindowBaseTile
	add r2, r0, #0
	ldrb r0, [r4, #9]
	add r3, sp, #0xc
	lsl r0, r0, #0x1c
	lsr r5, r0, #0x10
	mov r0, #0xfa
	lsl r0, r0, #2
	add r1, r5, r0
	strh r1, [r7]
	ldrh r4, [r3, #2]
	add r1, r0, #2
	add r1, r5, r1
	sub r4, r4, #1
	lsl r4, r4, #1
	strh r1, [r7, r4]
	ldrh r4, [r3]
	add r1, r0, #0
	add r1, #9
	ldrh r6, [r3, #2]
	sub r4, r4, #1
	add r1, r5, r1
	mul r4, r6
	lsl r4, r4, #1
	strh r1, [r7, r4]
	add r1, r0, #0
	add r1, #0xb
	add r6, r5, r1
	ldrh r4, [r3, #2]
	ldrh r1, [r3]
	mul r1, r4
	sub r1, r1, #1
	lsl r1, r1, #1
	strh r6, [r7, r1]
	ldrh r4, [r3, #2]
	mov r1, #0
	sub r4, r4, #2
	cmp r4, #0
	ble _021F6164
	add r4, r0, #1
	add r0, #0xa
	add r0, r5, r0
	add r4, r5, r4
	lsl r0, r0, #0x10
	lsl r4, r4, #0x10
	lsr r0, r0, #0x10
	lsr r6, r4, #0x10
	str r0, [sp, #4]
_021F613E:
	lsl r0, r1, #1
	add r0, r7, r0
	strh r6, [r0, #2]
	ldrh r4, [r3]
	ldrh r0, [r3, #2]
	sub r4, r4, #1
	mul r4, r0
	add r0, r1, r4
	lsl r0, r0, #1
	add r4, r7, r0
	ldr r0, [sp, #4]
	strh r0, [r4, #2]
	add r0, r1, #1
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	ldrh r0, [r3, #2]
	sub r0, r0, #2
	cmp r1, r0
	blt _021F613E
_021F6164:
	add r6, sp, #0xc
	ldrh r1, [r6]
	mov r0, #0
	sub r1, r1, #2
	cmp r1, #0
	ble _021F61AE
	ldr r1, _021F6204 ; =0x000003EB
	add r3, r5, r1
	add r1, r1, #2
	add r1, r5, r1
	lsl r3, r3, #0x10
	lsl r1, r1, #0x10
	lsr r3, r3, #0x10
	lsr r1, r1, #0x10
	str r3, [sp, #8]
	mov ip, r1
_021F6184:
	ldrh r1, [r6, #2]
	add r4, r0, #1
	add r0, r0, #2
	add r3, r1, #0
	mul r3, r4
	ldr r1, [sp, #8]
	lsl r3, r3, #1
	strh r1, [r7, r3]
	ldrh r1, [r6, #2]
	mul r0, r1
	lsl r0, r0, #1
	add r0, r7, r0
	sub r1, r0, #2
	mov r0, ip
	strh r0, [r1]
	ldrh r1, [r6]
	lsl r0, r4, #0x10
	lsr r0, r0, #0x10
	sub r1, r1, #2
	cmp r0, r1
	blt _021F6184
_021F61AE:
	mov r0, #0
	str r0, [sp]
	cmp r1, #0
	ble _021F6200
_021F61B6:
	add r0, sp, #0xc
	ldrh r6, [r0, #2]
	mov r3, #0
	sub r0, r6, #2
	cmp r0, #0
	ble _021F61EA
	ldr r0, [sp]
	add r4, r0, #1
_021F61C6:
	add r0, r6, #0
	mul r0, r4
	add r0, r3, r0
	lsl r0, r0, #1
	add r1, r5, r2
	add r0, r7, r0
	strh r1, [r0, #2]
	add r0, r2, #1
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	add r0, r3, #1
	lsl r0, r0, #0x10
	lsr r3, r0, #0x10
	add r0, sp, #0xc
	ldrh r6, [r0, #2]
	sub r0, r6, #2
	cmp r3, r0
	blt _021F61C6
_021F61EA:
	ldr r0, [sp]
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	add r0, sp, #0xc
	ldrh r0, [r0]
	sub r1, r0, #2
	ldr r0, [sp]
	cmp r0, r1
	blt _021F61B6
_021F6200:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F6204: .word 0x000003EB
	thumb_func_end ov14_021F60BC

	thumb_func_start ov14_021F6208
ov14_021F6208: ; 0x021F6208
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r2, #0
	add r5, r0, #0
	add r0, r6, #0
	add r4, r1, #0
	bl GetWindowBgId
	add r7, r0, #0
	add r0, r6, #0
	bl GetWindowWidth
	str r0, [sp, #4]
	add r0, r6, #0
	bl GetWindowHeight
	str r0, [sp]
	ldr r3, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	add r2, r7, #0
	bl sub_020195F4
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl sub_02019A60
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021F6208

	thumb_func_start ov14_021F6244
ov14_021F6244: ; 0x021F6244
	push {r4, lr}
	mov r2, #0x2f
	add r4, r0, #0
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0xf0
	mov r1, #3
	add r2, r4, r2
	bl ov14_021F6208
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0xe0
	mov r1, #4
	add r2, r4, r2
	bl ov14_021F6208
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0xd0
	mov r1, #5
	add r2, r4, r2
	bl ov14_021F6208
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0xc0
	mov r1, #6
	add r2, r4, r2
	bl ov14_021F6208
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0xb0
	mov r1, #7
	add r2, r4, r2
	bl ov14_021F6208
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0x30
	mov r1, #0xc
	add r2, r4, r2
	bl ov14_021F60BC
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0x20
	mov r1, #0xe
	add r2, r4, r2
	bl ov14_021F6208
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0x10
	mov r1, #0xf
	add r2, r4, r2
	bl ov14_021F6208
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6244

	thumb_func_start ov14_021F62CC
ov14_021F62CC: ; 0x021F62CC
	add r3, r0, #0
	mov r0, #0x2f
	mov r2, #0x1b
	lsl r0, r0, #4
	lsl r2, r2, #4
	ldr r0, [r3, r0]
	add r2, r3, r2
	ldr r3, _021F62E0 ; =ov14_021F6208
	mov r1, #8
	bx r3
	.balign 4, 0
_021F62E0: .word ov14_021F6208
	thumb_func_end ov14_021F62CC

	thumb_func_start ov14_021F62E4
ov14_021F62E4: ; 0x021F62E4
	add r3, r0, #0
	mov r0, #0x2f
	mov r2, #7
	lsl r0, r0, #4
	lsl r2, r2, #6
	ldr r0, [r3, r0]
	add r2, r3, r2
	ldr r3, _021F62F8 ; =ov14_021F6208
	mov r1, #9
	bx r3
	.balign 4, 0
_021F62F8: .word ov14_021F6208
	thumb_func_end ov14_021F62E4

	thumb_func_start ov14_021F62FC
ov14_021F62FC: ; 0x021F62FC
	add r3, r0, #0
	mov r0, #0x2f
	mov r2, #0x1d
	lsl r0, r0, #4
	lsl r2, r2, #4
	ldr r0, [r3, r0]
	add r2, r3, r2
	ldr r3, _021F6310 ; =ov14_021F6208
	mov r1, #0xa
	bx r3
	.balign 4, 0
_021F6310: .word ov14_021F6208
	thumb_func_end ov14_021F62FC

	thumb_func_start ov14_021F6314
ov14_021F6314: ; 0x021F6314
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	mov r2, #0x1f
	ldr r3, [r4, #0x34]
	lsl r0, r0, #4
	lsl r2, r2, #4
	ldr r0, [r3, r0]
	mov r1, #0xb
	add r2, r3, r2
	bl ov14_021F6208
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5ED4
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6314

	thumb_func_start ov14_021F6338
ov14_021F6338: ; 0x021F6338
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r7, r0, #0
	add r6, r1, #0
	add r5, r7, #0
	add r5, #0x30
	lsl r4, r6, #4
	add r0, r5, r4
	mov r1, #0xd
	str r2, [sp, #0x14]
	bl FillWindowPixelBuffer
	add r0, r5, r4
	bl GetWindowWidth
	lsl r1, r0, #3
	lsr r0, r1, #0x1f
	add r0, r1, r0
	lsl r0, r0, #0x17
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, _021F6388 ; =0x00090A0D
	ldr r3, [sp, #0x14]
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, [r7, #0x20]
	add r0, r7, #0
	add r2, r6, #0
	bl ov14_021F4F84
	add r0, r5, r4
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F6388: .word 0x00090A0D
	thumb_func_end ov14_021F6338

	thumb_func_start ov14_021F638C
ov14_021F638C: ; 0x021F638C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x22
	mov r2, #0x48
	mov r3, #0
	bl ov14_021F6338
	add r0, r4, #0
	mov r1, #0x23
	mov r2, #0x49
	mov r3, #0
	bl ov14_021F6338
	pop {r4, pc}
	thumb_func_end ov14_021F638C

	thumb_func_start ov14_021F63A8
ov14_021F63A8: ; 0x021F63A8
	push {r3, lr}
	mov r1, #0x24
	mov r2, #0x4a
	mov r3, #0
	bl ov14_021F6338
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F63A8

	thumb_func_start ov14_021F63B8
ov14_021F63B8: ; 0x021F63B8
	push {r3, lr}
	mov r1, #0x24
	mov r2, #0x4b
	mov r3, #0
	bl ov14_021F6338
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F63B8

	thumb_func_start ov14_021F63C8
ov14_021F63C8: ; 0x021F63C8
	push {r4, lr}
	mov r2, #0x2f
	add r4, r0, #0
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0xa0
	mov r1, #2
	add r2, r4, r2
	bl sub_02019A60
	mov r2, #0x2f
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	sub r2, #0x90
	mov r1, #2
	add r2, r4, r2
	bl sub_02019A60
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F63C8

	thumb_func_start ov14_021F63F0
ov14_021F63F0: ; 0x021F63F0
	mov r2, #0x2f
	add r3, r0, #0
	lsl r2, r2, #4
	ldr r0, [r3, r2]
	sub r2, #0x80
	add r2, r3, r2
	ldr r3, _021F6404 ; =sub_02019A60
	mov r1, #1
	bx r3
	nop
_021F6404: .word sub_02019A60
	thumb_func_end ov14_021F63F0

	thumb_func_start ov14_021F6408
ov14_021F6408: ; 0x021F6408
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	str r0, [sp, #0x1c]
	ldr r4, [r0, #0x34]
	mov r0, #0x2e
	lsl r0, r0, #4
	add r0, r4, r0
	bl GetWindowWidth
	str r0, [sp, #0x20]
	mov r0, #0xa
	str r0, [sp]
	mov r0, #0x13
	mov r1, #0xe
	mov r2, #1
	add r3, sp, #0x30
	bl GfGfxLoader_GetCharData
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x30]
	mov r2, #0
	ldr r5, [r0, #0x14]
	mov r1, #0x18
	str r1, [sp]
	mov r0, #8
	str r0, [sp, #4]
	str r2, [sp, #8]
	str r2, [sp, #0xc]
	str r1, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0x7a
	lsl r0, r0, #4
	lsl r1, r1, #4
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r1, #0x18
	mov r2, #0
	str r1, [sp]
	mov r0, #8
	str r0, [sp, #4]
	str r2, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0xba
	lsl r0, r0, #4
	lsl r1, r1, #4
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r3, #0x18
	str r3, [sp]
	mov r1, #8
	str r1, [sp, #4]
	mov r2, #0
	str r2, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	str r3, [sp, #0x10]
	str r1, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0xfa
	lsl r0, r0, #4
	lsl r1, r1, #4
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x20]
	mov r1, #8
	sub r0, r0, #1
	str r1, [sp]
	mov r2, #0
	lsl r6, r0, #3
	str r0, [sp, #0x2c]
	lsl r0, r6, #0x10
	str r1, [sp, #4]
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	str r2, [sp, #0xc]
	str r1, [sp, #0x10]
	str r1, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0xd
	lsl r0, r0, #4
	lsl r1, r1, #8
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r1, #8
	str r1, [sp]
	lsl r0, r6, #0x10
	str r1, [sp, #4]
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r1, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0xce
	lsl r0, r0, #4
	lsl r1, r1, #4
	mov r2, #0
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r1, #8
	str r1, [sp]
	lsl r0, r6, #0x10
	mov r2, #0
	str r1, [sp, #4]
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	str r1, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0x33
	lsl r0, r0, #4
	lsl r1, r1, #6
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x2c]
	mov r7, #3
	cmp r0, #3
	ble _021F65D8
	ldr r0, [sp, #0x20]
	sub r0, r0, #1
	str r0, [sp, #0x24]
_021F6542:
	mov r0, #8
	str r0, [sp]
	lsl r6, r7, #3
	str r0, [sp, #4]
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0xc2
	lsl r0, r0, #4
	lsl r1, r1, #4
	mov r2, #0
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #8
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0xca
	lsl r0, r0, #4
	lsl r1, r1, #4
	mov r2, #0
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	mov r0, #0xff
	str r0, [sp, #0x18]
	mov r0, #0x2e
	mov r1, #0x32
	lsl r0, r0, #4
	lsl r1, r1, #6
	mov r2, #0
	add r0, r4, r0
	add r1, r5, r1
	add r3, r2, #0
	bl BlitBitmapRect
	add r0, r7, #1
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, [sp, #0x24]
	cmp r7, r0
	blt _021F6542
_021F65D8:
	ldr r0, [sp, #0x28]
	bl Heap_Free
	ldr r0, [sp, #0x1c]
	mov r1, #0x41
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0x20]
	bl NewString_ReadMsgData
	add r5, r0, #0
	mov r3, #4
	ldr r2, [sp, #0x20]
	ldr r0, _021F6624 ; =0x00090A00
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	lsl r6, r2, #3
	str r0, [sp, #8]
	mov r0, #0x2e
	lsr r2, r6, #0x1f
	lsl r0, r0, #4
	add r2, r6, r2
	add r0, r4, r0
	add r1, r5, #0
	asr r2, r2, #1
	bl ov14_021F4F24
	add r0, r5, #0
	bl String_Delete
	mov r0, #0x2e
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_021F6624: .word 0x00090A00
	thumb_func_end ov14_021F6408

	thumb_func_start ov14_021F6628
ov14_021F6628: ; 0x021F6628
	push {r3, lr}
	mov r0, #1
	mov r1, #0x1b
	mov r2, #0x19
	mov r3, #0xa
	bl NewMsgDataFromNarc
	pop {r3, pc}
	thumb_func_end ov14_021F6628

	thumb_func_start ov14_021F6638
ov14_021F6638: ; 0x021F6638
	push {r4, lr}
	mov r1, #0xf
	add r4, r0, #0
	bl FillWindowPixelBuffer
	ldr r1, _021F6650 ; =0x0000038E
	add r0, r4, #0
	mov r2, #0xa
	bl sub_0200E948
	pop {r4, pc}
	nop
_021F6650: .word 0x0000038E
	thumb_func_end ov14_021F6638

	thumb_func_start ov14_021F6654
ov14_021F6654: ; 0x021F6654
	push {r4, r5, r6, lr}
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0x30
	add r0, r5, r4
	mov r1, #1
	bl ClearFrameAndWindow2
	add r0, r5, r4
	bl GetWindowBgId
	add r1, r0, #0
	ldr r0, [r6, #0x14]
	bl ScheduleBgTilemapBufferTransfer
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6654

	thumb_func_start ov14_021F6678
ov14_021F6678: ; 0x021F6678
	ldr r3, _021F6684 ; =ClearFrameAndWindow2
	add r0, #0x30
	lsl r1, r1, #4
	add r0, r0, r1
	mov r1, #1
	bx r3
	.balign 4, 0
_021F6684: .word ClearFrameAndWindow2
	thumb_func_end ov14_021F6678

	thumb_func_start ov14_021F6688
ov14_021F6688: ; 0x021F6688
	ldr r3, _021F6694 ; =ClearFrameAndWindow2
	add r0, #0x30
	lsl r1, r1, #4
	add r0, r0, r1
	mov r1, #0
	bx r3
	.balign 4, 0
_021F6694: .word ClearFrameAndWindow2
	thumb_func_end ov14_021F6688

	thumb_func_start ov14_021F6698
ov14_021F6698: ; 0x021F6698
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	str r1, [sp, #0x14]
	add r4, r2, #0
	bl ov14_021F6628
	add r7, r0, #0
	ldr r0, [r5, #0x34]
	lsl r6, r4, #4
	add r0, #0x30
	add r0, r0, r6
	bl ov14_021F6638
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, _021F66E4 ; =0x0001020F
	ldr r3, [sp, #0x14]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r0, [r5, #0x34]
	add r1, r7, #0
	add r2, r4, #0
	bl ov14_021F4FBC
	ldr r0, [r5, #0x34]
	add r0, #0x30
	add r0, r0, r6
	bl ScheduleWindowCopyToVram
	add r0, r7, #0
	bl DestroyMsgData
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F66E4: .word 0x0001020F
	thumb_func_end ov14_021F6698

	thumb_func_start ov14_021F66E8
ov14_021F66E8: ; 0x021F66E8
	push {r3, lr}
	add r3, r1, #0
	cmp r2, #1
	bne _021F66FA
	mov r1, #0xb
	add r2, r3, #0
	bl ov14_021F6698
	pop {r3, pc}
_021F66FA:
	mov r1, #0xc
	add r2, r3, #0
	bl ov14_021F6698
	pop {r3, pc}
	thumb_func_end ov14_021F66E8

	thumb_func_start ov14_021F6704
ov14_021F6704: ; 0x021F6704
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r3, r1, #0
	ldr r0, [r0, #0x24]
	add r4, r2, #0
	mov r1, #0
	add r2, r3, #0
	bl BufferItemName
	add r0, r5, #0
	mov r1, #0x17
	add r2, r4, #0
	bl ov14_021F6698
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6704

	thumb_func_start ov14_021F6724
ov14_021F6724: ; 0x021F6724
	ldr r3, _021F672C ; =ov14_021F6698
	add r2, r1, #0
	mov r1, #0x18
	bx r3
	.balign 4, 0
_021F672C: .word ov14_021F6698
	thumb_func_end ov14_021F6724

	thumb_func_start ov14_021F6730
ov14_021F6730: ; 0x021F6730
	ldr r3, _021F6738 ; =ov14_021F6698
	add r2, r1, #0
	mov r1, #0x36
	bx r3
	.balign 4, 0
_021F6738: .word ov14_021F6698
	thumb_func_end ov14_021F6730

	thumb_func_start ov14_021F673C
ov14_021F673C: ; 0x021F673C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r3, r1, #0
	ldr r0, [r0, #0x24]
	add r4, r2, #0
	mov r1, #0
	add r2, r3, #0
	bl BufferItemName
	add r0, r5, #0
	mov r1, #0xf
	add r2, r4, #0
	bl ov14_021F6698
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F673C

	thumb_func_start ov14_021F675C
ov14_021F675C: ; 0x021F675C
	ldr r3, _021F6764 ; =ov14_021F6698
	add r2, r1, #0
	mov r1, #0xe
	bx r3
	.balign 4, 0
_021F6764: .word ov14_021F6698
	thumb_func_end ov14_021F675C

	thumb_func_start ov14_021F6768
ov14_021F6768: ; 0x021F6768
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r3, r1, #0
	add r4, r2, #0
	cmp r3, #0
	ldr r0, [r5, #0x34]
	bne _021F678C
	ldr r0, [r0, #0x24]
	mov r1, #0
	mov r2, #0x70
	bl BufferItemName
	add r0, r5, #0
	mov r1, #0x37
	add r2, r4, #0
	bl ov14_021F6698
	pop {r3, r4, r5, pc}
_021F678C:
	ldr r0, [r0, #0x24]
	mov r1, #0
	add r2, r3, #0
	bl BufferItemName
	add r0, r5, #0
	mov r1, #0x10
	add r2, r4, #0
	bl ov14_021F6698
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6768

	thumb_func_start ov14_021F67A4
ov14_021F67A4: ; 0x021F67A4
	ldr r3, _021F67AC ; =ov14_021F6698
	add r2, r1, #0
	mov r1, #0x23
	bx r3
	.balign 4, 0
_021F67AC: .word ov14_021F6698
	thumb_func_end ov14_021F67A4

	thumb_func_start ov14_021F67B0
ov14_021F67B0: ; 0x021F67B0
	push {r4, r5, r6, lr}
	add r4, r0, #0
	add r6, r2, #0
	cmp r1, #6
	bhi _021F6836
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021F67C6: ; jump table
	.short _021F67D4 - _021F67C6 - 2 ; case 0
	.short _021F67D8 - _021F67C6 - 2 ; case 1
	.short _021F67F4 - _021F67C6 - 2 ; case 2
	.short _021F6810 - _021F67C6 - 2 ; case 3
	.short _021F6814 - _021F67C6 - 2 ; case 4
	.short _021F6830 - _021F67C6 - 2 ; case 5
	.short _021F6834 - _021F67C6 - 2 ; case 6
_021F67D4:
	mov r5, #2
	b _021F6836
_021F67D8:
	add r2, r4, #0
	add r2, #0x21
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r2]
	mov r5, #3
	bl ov14_021E60C0
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x24]
	bl BufferBoxMonNickname
	b _021F6836
_021F67F4:
	add r2, r4, #0
	add r2, #0x21
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r2]
	mov r5, #4
	bl ov14_021E60C0
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x24]
	bl BufferBoxMonNickname
	b _021F6836
_021F6810:
	mov r5, #0x1f
	b _021F6836
_021F6814:
	add r2, r4, #0
	add r2, #0x21
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r2]
	mov r5, #0x20
	bl ov14_021E60C0
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x24]
	bl BufferBoxMonNickname
	b _021F6836
_021F6830:
	mov r5, #0x21
	b _021F6836
_021F6834:
	mov r5, #6
_021F6836:
	add r0, r4, #0
	add r1, r5, #0
	add r2, r6, #0
	bl ov14_021F6698
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021F67B0

	thumb_func_start ov14_021F6844
ov14_021F6844: ; 0x021F6844
	cmp r1, #0
	beq _021F684E
	cmp r1, #1
	beq _021F6852
	b _021F6854
_021F684E:
	mov r1, #7
	b _021F6854
_021F6852:
	mov r1, #0xa
_021F6854:
	ldr r3, _021F6858 ; =ov14_021F6698
	bx r3
	.balign 4, 0
_021F6858: .word ov14_021F6698
	thumb_func_end ov14_021F6844

	thumb_func_start ov14_021F685C
ov14_021F685C: ; 0x021F685C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r6, r3, #0
	cmp r2, #6
	bhi _021F68B2
	add r1, r2, r2
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021F6872: ; jump table
	.short _021F6880 - _021F6872 - 2 ; case 0
	.short _021F6884 - _021F6872 - 2 ; case 1
	.short _021F68A0 - _021F6872 - 2 ; case 2
	.short _021F68A4 - _021F6872 - 2 ; case 3
	.short _021F68A8 - _021F6872 - 2 ; case 4
	.short _021F68AC - _021F6872 - 2 ; case 5
	.short _021F68B0 - _021F6872 - 2 ; case 6
_021F6880:
	mov r4, #0x12
	b _021F68B2
_021F6884:
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	mov r4, #0
	bl ov14_021E60C0
	add r2, r0, #0
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x24]
	bl BufferBoxMonNickname
	b _021F68B2
_021F68A0:
	mov r4, #5
	b _021F68B2
_021F68A4:
	mov r4, #0x13
	b _021F68B2
_021F68A8:
	mov r4, #0xd
	b _021F68B2
_021F68AC:
	mov r4, #0x1d
	b _021F68B2
_021F68B0:
	mov r4, #0x1e
_021F68B2:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F6698
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021F685C

	thumb_func_start ov14_021F68C0
ov14_021F68C0: ; 0x021F68C0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r6, r2, #0
	cmp r1, #7
	bhi _021F6918
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F68D6: ; jump table
	.short _021F6918 - _021F68D6 - 2 ; case 0
	.short _021F6918 - _021F68D6 - 2 ; case 1
	.short _021F68E6 - _021F68D6 - 2 ; case 2
	.short _021F68F8 - _021F68D6 - 2 ; case 3
	.short _021F690A - _021F68D6 - 2 ; case 4
	.short _021F690E - _021F68D6 - 2 ; case 5
	.short _021F6912 - _021F68D6 - 2 ; case 6
	.short _021F6916 - _021F68D6 - 2 ; case 7
_021F68E6:
	ldr r3, [r5, #0x34]
	ldr r2, _021F6924 ; =0x000088C8
	ldr r0, [r3, #0x24]
	ldrh r2, [r3, r2]
	mov r1, #0
	mov r4, #0x1a
	bl BufferItemName
	b _021F6918
_021F68F8:
	ldr r3, [r5, #0x34]
	ldr r2, _021F6924 ; =0x000088C8
	ldr r0, [r3, #0x24]
	ldrh r2, [r3, r2]
	mov r1, #0
	mov r4, #0x1b
	bl BufferItemName
	b _021F6918
_021F690A:
	mov r4, #0x18
	b _021F6918
_021F690E:
	mov r4, #0x22
	b _021F6918
_021F6912:
	mov r4, #0xe
	b _021F6918
_021F6916:
	mov r4, #0x3b
_021F6918:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F6698
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F6924: .word 0x000088C8
	thumb_func_end ov14_021F68C0

	thumb_func_start ov14_021F6928
ov14_021F6928: ; 0x021F6928
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r6, r1, #0
	add r4, r2, #0
	bl ov14_021F6628
	add r7, r0, #0
	cmp r4, #0xa
	bhi _021F6996
	add r0, r4, r4
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F6948: ; jump table
	.short _021F695E - _021F6948 - 2 ; case 0
	.short _021F6962 - _021F6948 - 2 ; case 1
	.short _021F6966 - _021F6948 - 2 ; case 2
	.short _021F696A - _021F6948 - 2 ; case 3
	.short _021F696E - _021F6948 - 2 ; case 4
	.short _021F6972 - _021F6948 - 2 ; case 5
	.short _021F6984 - _021F6948 - 2 ; case 6
	.short _021F6988 - _021F6948 - 2 ; case 7
	.short _021F698C - _021F6948 - 2 ; case 8
	.short _021F6990 - _021F6948 - 2 ; case 9
	.short _021F6994 - _021F6948 - 2 ; case 10
_021F695E:
	mov r4, #0x24
	b _021F6996
_021F6962:
	mov r4, #0x25
	b _021F6996
_021F6966:
	mov r4, #0x26
	b _021F6996
_021F696A:
	mov r4, #0x27
	b _021F6996
_021F696E:
	mov r4, #0x1c
	b _021F6996
_021F6972:
	ldr r3, [r5, #0x34]
	ldr r2, _021F69E8 ; =0x000088C8
	ldr r0, [r3, #0x24]
	ldrh r2, [r3, r2]
	mov r1, #0
	mov r4, #0x19
	bl BufferItemName
	b _021F6996
_021F6984:
	mov r4, #0x38
	b _021F6996
_021F6988:
	mov r4, #0x39
	b _021F6996
_021F698C:
	mov r4, #0x3a
	b _021F6996
_021F6990:
	mov r4, #0x3b
	b _021F6996
_021F6994:
	mov r4, #0x3c
_021F6996:
	add r0, r7, #0
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	ldr r1, [r5, #0x34]
	add r2, r4, #0
	ldr r0, [r1, #0x24]
	ldr r1, [r1, #0x28]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	ldr r0, [r5, #0x34]
	lsl r4, r6, #4
	add r0, #0x30
	add r0, r0, r4
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r2, [r5, #0x34]
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021F69EC ; =0x0001020F
	mov r1, #1
	str r0, [sp, #8]
	add r0, r2, #0
	str r3, [sp, #0xc]
	add r0, #0x30
	ldr r2, [r2, #0x28]
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl DestroyMsgData
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F69E8: .word 0x000088C8
_021F69EC: .word 0x0001020F
	thumb_func_end ov14_021F6928

	thumb_func_start ov14_021F69F0
ov14_021F69F0: ; 0x021F69F0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	lsl r4, r1, #4
	add r0, #0x30
	ldr r1, _021F6A10 ; =0x0000038E
	add r0, r0, r4
	mov r2, #0xa
	bl sub_0200E948
	ldr r0, [r5, #0x34]
	add r0, #0x30
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F6A10: .word 0x0000038E
	thumb_func_end ov14_021F69F0

	thumb_func_start ov14_021F6A14
ov14_021F6A14: ; 0x021F6A14
	ldr r3, _021F6A1C ; =TouchscreenHitbox_FindRectAtTouchNew
	ldr r0, _021F6A20 ; =ov14_021F864C
	bx r3
	nop
_021F6A1C: .word TouchscreenHitbox_FindRectAtTouchNew
_021F6A20: .word ov14_021F864C
	thumb_func_end ov14_021F6A14

	thumb_func_start ov14_021F6A24
ov14_021F6A24: ; 0x021F6A24
	ldr r3, _021F6A2C ; =TouchscreenHitbox_FindRectAtTouchNew
	ldr r0, _021F6A30 ; =ov14_021F8614
	bx r3
	nop
_021F6A2C: .word TouchscreenHitbox_FindRectAtTouchNew
_021F6A30: .word ov14_021F8614
	thumb_func_end ov14_021F6A24

	thumb_func_start ov14_021F6A34
ov14_021F6A34: ; 0x021F6A34
	ldr r3, _021F6A3C ; =TouchscreenHitbox_FindRectAtTouchNew
	ldr r0, _021F6A40 ; =ov14_021F8630
	bx r3
	nop
_021F6A3C: .word TouchscreenHitbox_FindRectAtTouchNew
_021F6A40: .word ov14_021F8630
	thumb_func_end ov14_021F6A34

	thumb_func_start ov14_021F6A44
ov14_021F6A44: ; 0x021F6A44
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bhi _021F6A74
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F6A5E: ; jump table
	.short _021F6A66 - _021F6A5E - 2 ; case 0
	.short _021F6A6A - _021F6A5E - 2 ; case 1
	.short _021F6A6E - _021F6A5E - 2 ; case 2
	.short _021F6A72 - _021F6A5E - 2 ; case 3
_021F6A66:
	mov r5, #0
	b _021F6A74
_021F6A6A:
	mov r5, #2
	b _021F6A74
_021F6A6E:
	mov r5, #3
	b _021F6A74
_021F6A72:
	mov r5, #6
_021F6A74:
	add r0, r4, #0
	bl ov14_021F6B10
	mov r0, #0xc
	add r2, r5, #0
	mul r2, r0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r4, #0x2c]
	ldr r1, _021F6AB4 ; =ov14_021F8B10 + 4
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0xa
	str r0, [sp, #8]
	ldr r0, _021F6AB8 ; =ov14_021F8B10
	ldr r3, _021F6ABC ; =ov14_021F8B10 + 8
	ldr r0, [r0, r2]
	ldr r1, [r1, r2]
	ldr r2, [r3, r2]
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, [r4, #0x34]
	str r0, [r1, #0x2c]
	ldr r1, [r4, #0x2c]
	add r0, r4, #0
	bl ov14_021F6B28
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_021F6AB4: .word ov14_021F8B10 + 4
_021F6AB8: .word ov14_021F8B10
_021F6ABC: .word ov14_021F8B10 + 8
	thumb_func_end ov14_021F6A44

	thumb_func_start ov14_021F6AC0
ov14_021F6AC0: ; 0x021F6AC0
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r6, r1, #0
	add r5, r0, #0
	add r4, r2, #0
	bl ov14_021F6B10
	mov r0, #0xc
	add r2, r6, #0
	mul r2, r0
	mov r0, #1
	str r0, [sp]
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0xa
	str r0, [sp, #8]
	ldr r0, _021F6B04 ; =ov14_021F8B10
	ldr r1, _021F6B08 ; =ov14_021F8B10 + 4
	ldr r3, _021F6B0C ; =ov14_021F8B10 + 8
	ldr r0, [r0, r2]
	ldr r1, [r1, r2]
	ldr r2, [r3, r2]
	add r3, r5, #0
	bl GridInputHandler_Create
	ldr r1, [r5, #0x34]
	str r0, [r1, #0x2c]
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021F6B04: .word ov14_021F8B10
_021F6B08: .word ov14_021F8B10 + 4
_021F6B0C: .word ov14_021F8B10 + 8
	thumb_func_end ov14_021F6AC0

	thumb_func_start ov14_021F6B10
ov14_021F6B10: ; 0x021F6B10
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	cmp r0, #0
	beq _021F6B26
	bl GridInputHandler_Free
	ldr r0, [r4, #0x34]
	mov r1, #0
	str r1, [r0, #0x2c]
_021F6B26:
	pop {r4, pc}
	thumb_func_end ov14_021F6B10

	thumb_func_start ov14_021F6B28
ov14_021F6B28: ; 0x021F6B28
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r5, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	add r1, sp, #0
	add r0, r5, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6B28

	thumb_func_start ov14_021F6B60
ov14_021F6B60: ; 0x021F6B60
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6B60

	thumb_func_start ov14_021F6B7C
ov14_021F6B7C: ; 0x021F6B7C
	ldr r3, _021F6B88 ; =ov14_021F2A18
	ldr r0, [r0, #0x34]
	mov r1, #9
	mov r2, #0
	bx r3
	nop
_021F6B88: .word ov14_021F2A18
	thumb_func_end ov14_021F6B7C

	thumb_func_start ov14_021F6B8C
ov14_021F6B8C: ; 0x021F6B8C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	ldr r1, _021F6BA0 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, pc}
	.balign 4, 0
_021F6BA0: .word ov14_021E9F20
	thumb_func_end ov14_021F6B8C

	thumb_func_start ov14_021F6BA4
ov14_021F6BA4: ; 0x021F6BA4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6BA4

	thumb_func_start ov14_021F6BC0
ov14_021F6BC0: ; 0x021F6BC0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	cmp r4, #0xc
	ldr r1, [r5, #0x34]
	bhs _021F6C18
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6C0C
	cmp r4, #7
	blo _021F6C14
	cmp r4, #0xb
	bhi _021F6C14
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F6C0C:
	cmp r4, #6
	bne _021F6C14
	mov r0, #0xb
	pop {r4, r5, r6, pc}
_021F6C14:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
_021F6C18:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021F6C36
	cmp r4, #6
	beq _021F6C32
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F6C36
_021F6C32:
	mov r0, #0xb
	pop {r4, r5, r6, pc}
_021F6C36:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6BC0

	thumb_func_start ov14_021F6C3C
ov14_021F6C3C: ; 0x021F6C3C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F6C7E
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6C70
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0xff
	beq _021F6C6C
	cmp r4, #0x1e
	blo _021F6C6C
	sub r4, #0x1e
	b _021F6C7E
_021F6C6C:
	mov r4, #0
	b _021F6C7E
_021F6C70:
	cmp r4, #8
	beq _021F6C7E
	cmp r4, #9
	beq _021F6C7E
	cmp r4, #0xa
	beq _021F6C7E
	mov r4, #7
_021F6C7E:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6C3C

	thumb_func_start ov14_021F6C94
ov14_021F6C94: ; 0x021F6C94
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	sub r0, r4, #6
	cmp r0, #1
	bhi _021F6CB4
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r4, r1, #0
	ldr r1, [r5, #0x34]
	ldr r0, _021F6D10 ; =0x0000043C
	str r4, [r1, r0]
_021F6CB4:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	cmp r4, #0
	blt _021F6D04
	cmp r4, #5
	bgt _021F6D04
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
_021F6D04:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F6D10: .word 0x0000043C
	thumb_func_end ov14_021F6C94

	thumb_func_start ov14_021F6D14
ov14_021F6D14: ; 0x021F6D14
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r6, r2, #0
	cmp r4, #0
	blt _021F6D30
	cmp r4, #5
	bgt _021F6D30
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021F6D3A
_021F6D30:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021F6D3A:
	cmp r6, #8
	bne _021F6D56
	cmp r4, #0
	bne _021F6D56
	ldr r1, [r5, #0x34]
	ldr r0, _021F6E60 ; =0x0000043C
	mov r2, #8
	ldr r4, [r1, r0]
	ldr r0, [r1, #0x2c]
	lsl r1, r4, #0x18
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl GridInputHandler_SetNextLastUnk0FInputs
_021F6D56:
	cmp r4, #0
	blt _021F6D64
	cmp r4, #5
	bgt _021F6D64
	ldr r1, [r5, #0x34]
	ldr r0, _021F6E60 ; =0x0000043C
	str r4, [r1, r0]
_021F6D64:
	cmp r4, #0
	bne _021F6DC0
	cmp r6, #5
	bne _021F6DC0
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	add r0, r0, #1
	cmp r0, #0x12
	blt _021F6D7C
	mov r1, #0
	b _021F6D84
_021F6D7C:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	add r1, r0, #1
_021F6D84:
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F49E0
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F57B8
	ldr r0, [r5, #0x34]
	mov r1, #5
	mov r2, #4
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F6E64 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F6DC0:
	cmp r4, #5
	bne _021F6E1A
	cmp r6, #0
	bne _021F6E1A
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	sub r0, r0, #1
	bpl _021F6DD6
	mov r1, #0x11
	b _021F6DDE
_021F6DD6:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	sub r1, r0, #1
_021F6DDE:
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F49E0
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F57B8
	ldr r0, [r5, #0x34]
	mov r1, #4
	mov r2, #2
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F6E64 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F6E1A:
	cmp r4, #0
	blt _021F6E4A
	cmp r4, #5
	bgt _021F6E4A
	cmp r6, #8
	beq _021F6E4A
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	mov r1, #6
	mul r1, r0
	add r0, r5, #0
	add r1, r4, r1
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F57B8
_021F6E4A:
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F6E64 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
	nop
_021F6E60: .word 0x0000043C
_021F6E64: .word ov14_021E9F20
	thumb_func_end ov14_021F6D14

	thumb_func_start ov14_021F6E68
ov14_021F6E68: ; 0x021F6E68
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	cmp r4, #6
	beq _021F6E8A
	cmp r4, #7
	beq _021F6E8A
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F6E8A:
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6E68

	thumb_func_start ov14_021F6E8C
ov14_021F6E8C: ; 0x021F6E8C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	cmp r4, #0x27
	ldr r1, [r5, #0x34]
	bhs _021F6EE4
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6ED8
	cmp r4, #0x22
	blo _021F6EE0
	cmp r4, #0x26
	bhi _021F6EE0
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F6ED8:
	cmp r4, #0x21
	bne _021F6EE0
	mov r0, #0x26
	pop {r4, r5, r6, pc}
_021F6EE0:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
_021F6EE4:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021F6F02
	cmp r4, #0x21
	beq _021F6EFE
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F6F02
_021F6EFE:
	mov r0, #0x26
	pop {r4, r5, r6, pc}
_021F6F02:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6E8C

	thumb_func_start ov14_021F6F08
ov14_021F6F08: ; 0x021F6F08
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F6F5A
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6F4C
	add r0, r4, #0
	sub r0, #0x1f
	cmp r0, #1
	bhi _021F6F32
	mov r4, #0x1e
	b _021F6F5A
_021F6F32:
	cmp r4, #0x1e
	beq _021F6F5A
	cmp r4, #0x21
	beq _021F6F5A
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0xff
	beq _021F6F48
	cmp r4, #0x1e
	blo _021F6F5A
_021F6F48:
	mov r4, #0
	b _021F6F5A
_021F6F4C:
	cmp r4, #0x23
	beq _021F6F5A
	cmp r4, #0x24
	beq _021F6F5A
	cmp r4, #0x25
	beq _021F6F5A
	mov r4, #0x22
_021F6F5A:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6F08

	thumb_func_start ov14_021F6F70
ov14_021F6F70: ; 0x021F6F70
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	cmp r4, #0x1f
	beq _021F6F92
	cmp r4, #0x20
	beq _021F6F92
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F6F92:
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6F70

	thumb_func_start ov14_021F6F94
ov14_021F6F94: ; 0x021F6F94
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6FDC
	cmp r4, #0x24
	blo _021F700C
	cmp r4, #0x28
	bhi _021F700C
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F6FDC:
	add r0, r4, #0
	sub r0, #0x21
	cmp r0, #1
	bhi _021F6FFC
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F6FFC:
	cmp r4, #0x23
	beq _021F7008
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F700C
_021F7008:
	mov r0, #0x29
	pop {r4, r5, r6, pc}
_021F700C:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F6F94

	thumb_func_start ov14_021F7010
ov14_021F7010: ; 0x021F7010
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F7076
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7060
	add r0, r4, #0
	sub r0, #0x1e
	cmp r0, #5
	bhi _021F7052
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F7042: ; jump table
	.short _021F7076 - _021F7042 - 2 ; case 0
	.short _021F704E - _021F7042 - 2 ; case 1
	.short _021F704E - _021F7042 - 2 ; case 2
	.short _021F7076 - _021F7042 - 2 ; case 3
	.short _021F7076 - _021F7042 - 2 ; case 4
	.short _021F7076 - _021F7042 - 2 ; case 5
_021F704E:
	mov r4, #0x1e
	b _021F7076
_021F7052:
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F7076
	mov r4, #0
	b _021F7076
_021F7060:
	cmp r4, #0x24
	bne _021F7074
	cmp r4, #0x25
	bne _021F7074
	cmp r4, #0x26
	bne _021F7074
	cmp r4, #0x27
	bne _021F7074
	cmp r4, #0x28
	beq _021F7076
_021F7074:
	mov r4, #0x24
_021F7076:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7010

	thumb_func_start ov14_021F708C
ov14_021F708C: ; 0x021F708C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	ldr r1, _021F70A0 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, pc}
	.balign 4, 0
_021F70A0: .word ov14_021E9F20
	thumb_func_end ov14_021F708C

	thumb_func_start ov14_021F70A4
ov14_021F70A4: ; 0x021F70A4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F70A4

	thumb_func_start ov14_021F70C0
ov14_021F70C0: ; 0x021F70C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021F70DE
	ldr r0, [r5, #0x34]
	mov r1, #0x2d
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
_021F70DE:
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetAllEnabled
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F70C0

	thumb_func_start ov14_021F70F4
ov14_021F70F4: ; 0x021F70F4
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	sub r0, #0x2b
	cmp r0, #1
	bhi _021F7118
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r4, r1, #0
	ldr r1, [r5, #0x34]
	ldr r0, _021F717C ; =0x0000043C
	add r4, #0x25
	str r4, [r1, r0]
_021F7118:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	ldr r1, _021F7180 ; =0x0000044B
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021F7178
	cmp r4, #0x25
	blt _021F7170
	cmp r4, #0x2a
	bgt _021F7170
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
_021F7170:
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021F7178:
	pop {r3, r4, r5, pc}
	nop
_021F717C: .word 0x0000043C
_021F7180: .word 0x0000044B
	thumb_func_end ov14_021F70F4

	thumb_func_start ov14_021F7184
ov14_021F7184: ; 0x021F7184
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	ldr r0, [r5, #0x34]
	ldr r1, _021F72FC ; =0x0000044B
	add r6, r2, #0
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021F71B0
	cmp r4, #0x25
	blt _021F71A8
	cmp r4, #0x2a
	bgt _021F71A8
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021F71B0
_021F71A8:
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021F71B0:
	cmp r4, #0x25
	bne _021F71EE
	cmp r6, #0
	blt _021F71BC
	cmp r6, #5
	ble _021F71D0
_021F71BC:
	cmp r6, #0x18
	blt _021F71C4
	cmp r6, #0x1d
	ble _021F71D0
_021F71C4:
	cmp r6, #0x1e
	blt _021F71CC
	cmp r6, #0x1f
	ble _021F71D0
_021F71CC:
	cmp r6, #0x24
	bne _021F71EE
_021F71D0:
	ldr r1, [r5, #0x34]
	ldr r0, _021F7300 ; =0x0000043C
	ldr r4, [r1, r0]
	ldr r0, [r1, #0x2c]
	bl GridInputHandler_GetUnk0F
	add r3, r0, #0
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	bl GridInputHandler_SetNextLastUnk0FInputs
_021F71EE:
	cmp r4, #0x25
	blt _021F71FC
	cmp r4, #0x2a
	bgt _021F71FC
	ldr r1, [r5, #0x34]
	ldr r0, _021F7300 ; =0x0000043C
	str r4, [r1, r0]
_021F71FC:
	cmp r4, #0x25
	bne _021F7258
	cmp r6, #0x2a
	bne _021F7258
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	add r0, r0, #1
	cmp r0, #0x12
	blt _021F7214
	mov r1, #0
	b _021F721C
_021F7214:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	add r1, r0, #1
_021F721C:
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F49E0
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F57B8
	ldr r0, [r5, #0x34]
	mov r1, #5
	mov r2, #4
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7304 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F7258:
	cmp r4, #0x2a
	bne _021F72B2
	cmp r6, #0x25
	bne _021F72B2
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	sub r0, r0, #1
	bpl _021F726E
	mov r1, #0x11
	b _021F7276
_021F726E:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	sub r1, r0, #1
_021F7276:
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F49E0
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F57B8
	ldr r0, [r5, #0x34]
	mov r1, #4
	mov r2, #2
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7304 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F72B2:
	cmp r4, #0x25
	blt _021F72E8
	cmp r4, #0x2a
	bgt _021F72E8
	cmp r6, #0x25
	blt _021F72E8
	cmp r6, #0x2a
	bgt _021F72E8
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	mov r1, #6
	mul r1, r0
	add r1, r4, r1
	add r0, r5, #0
	sub r1, #0x25
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F57B8
_021F72E8:
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7304 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F72FC: .word 0x0000044B
_021F7300: .word 0x0000043C
_021F7304: .word ov14_021E9F20
	thumb_func_end ov14_021F7184

	thumb_func_start ov14_021F7308
ov14_021F7308: ; 0x021F7308
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #0x25
	blt _021F731C
	cmp r4, #0x2a
	bgt _021F731C
	ldr r1, [r5, #0x34]
	ldr r0, _021F733C ; =0x0000043C
	str r4, [r1, r0]
_021F731C:
	cmp r4, #0x2b
	beq _021F7338
	cmp r4, #0x2c
	beq _021F7338
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F7338:
	pop {r3, r4, r5, pc}
	nop
_021F733C: .word 0x0000043C
	thumb_func_end ov14_021F7308

	thumb_func_start ov14_021F7340
ov14_021F7340: ; 0x021F7340
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021F735E
	ldr r0, [r5, #0x34]
	mov r1, #0x2d
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
_021F735E:
	ldr r0, [r5, #0x34]
	mov r1, #0x2b
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x2c
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetAllEnabled
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7340

	thumb_func_start ov14_021F7388
ov14_021F7388: ; 0x021F7388
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F73D0
	cmp r4, #8
	blo _021F73E0
	cmp r4, #0xc
	bhi _021F73E0
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F73D0:
	cmp r4, #7
	beq _021F73DC
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F73E0
_021F73DC:
	mov r0, #0xd
	pop {r4, r5, r6, pc}
_021F73E0:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F7388

	thumb_func_start ov14_021F73E4
ov14_021F73E4: ; 0x021F73E4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F742E
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7418
	cmp r4, #8
	blt _021F742E
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F7414
	sub r4, #0x1e
	b _021F742E
_021F7414:
	mov r4, #0
	b _021F742E
_021F7418:
	cmp r4, #8
	bne _021F742C
	cmp r4, #9
	bne _021F742C
	cmp r4, #0xa
	bne _021F742C
	cmp r4, #0xb
	bne _021F742C
	cmp r4, #0xc
	beq _021F742E
_021F742C:
	mov r4, #8
_021F742E:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F73E4

	thumb_func_start ov14_021F7444
ov14_021F7444: ; 0x021F7444
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r6, r2, #0
	bl ov14_021E8544
	cmp r0, #1
	bne _021F747E
	cmp r4, #6
	bgt _021F7492
	cmp r6, #7
	blt _021F7492
	add r0, r5, #0
	bl ov14_021E76B8
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F74A8 ; =ov14_021EA180
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F747E:
	cmp r4, #0xc
	bne _021F7492
	cmp r6, #7
	bne _021F7492
	ldr r0, [r5, #0x34]
	mov r1, #7
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r4, #7
_021F7492:
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F74AC ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
	nop
_021F74A8: .word ov14_021EA180
_021F74AC: .word ov14_021E9F20
	thumb_func_end ov14_021F7444

	thumb_func_start ov14_021F74B0
ov14_021F74B0: ; 0x021F74B0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F74F4
	cmp r4, #0x24
	bne _021F7524
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F74F4:
	add r0, r4, #0
	sub r0, #0x21
	cmp r0, #1
	bhi _021F7514
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F7514:
	cmp r4, #0x23
	beq _021F7520
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F7524
_021F7520:
	mov r0, #0x25
	pop {r4, r5, r6, pc}
_021F7524:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F74B0

	thumb_func_start ov14_021F7528
ov14_021F7528: ; 0x021F7528
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F757E
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7578
	add r0, r4, #0
	sub r0, #0x1e
	cmp r0, #5
	bhi _021F756A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F755A: ; jump table
	.short _021F757E - _021F755A - 2 ; case 0
	.short _021F7566 - _021F755A - 2 ; case 1
	.short _021F7566 - _021F755A - 2 ; case 2
	.short _021F757E - _021F755A - 2 ; case 3
	.short _021F757E - _021F755A - 2 ; case 4
	.short _021F757E - _021F755A - 2 ; case 5
_021F7566:
	mov r4, #0x1e
	b _021F757E
_021F756A:
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F757E
	mov r4, #0
	b _021F757E
_021F7578:
	cmp r4, #0x24
	beq _021F757E
	mov r4, #0x24
_021F757E:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7528

	thumb_func_start ov14_021F7594
ov14_021F7594: ; 0x021F7594
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	ldr r1, _021F75A8 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, pc}
	.balign 4, 0
_021F75A8: .word ov14_021E9F20
	thumb_func_end ov14_021F7594

	thumb_func_start ov14_021F75AC
ov14_021F75AC: ; 0x021F75AC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F75AC

	thumb_func_start ov14_021F75C8
ov14_021F75C8: ; 0x021F75C8
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F760C
	cmp r4, #8
	bne _021F761C
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F760C:
	cmp r4, #7
	beq _021F7618
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F761C
_021F7618:
	mov r0, #9
	pop {r4, r5, r6, pc}
_021F761C:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F75C8

	thumb_func_start ov14_021F7620
ov14_021F7620: ; 0x021F7620
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F765A
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7654
	cmp r4, #8
	blt _021F765A
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F7650
	sub r4, #0x1e
	b _021F765A
_021F7650:
	mov r4, #0
	b _021F765A
_021F7654:
	cmp r4, #8
	beq _021F765A
	mov r4, #8
_021F765A:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7620

	thumb_func_start ov14_021F7670
ov14_021F7670: ; 0x021F7670
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	ldr r1, _021F7684 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, pc}
	.balign 4, 0
_021F7684: .word ov14_021E9F20
	thumb_func_end ov14_021F7670

	thumb_func_start ov14_021F7688
ov14_021F7688: ; 0x021F7688
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	sub r0, r4, #6
	cmp r0, #1
	bhi _021F76A8
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r4, r1, #0
	ldr r1, [r5, #0x34]
	ldr r0, _021F76FC ; =0x0000043C
	str r4, [r1, r0]
_021F76A8:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	cmp r4, #0
	blt _021F76EE
	cmp r4, #5
	bgt _021F76EE
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
_021F76EE:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
	nop
_021F76FC: .word 0x0000043C
	thumb_func_end ov14_021F7688

	thumb_func_start ov14_021F7700
ov14_021F7700: ; 0x021F7700
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r6, r2, #0
	cmp r4, #0
	blt _021F771C
	cmp r4, #5
	bgt _021F771C
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021F7726
_021F771C:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021F7726:
	cmp r6, #8
	bne _021F7742
	cmp r4, #0
	bne _021F7742
	ldr r1, [r5, #0x34]
	ldr r0, _021F784C ; =0x0000043C
	mov r2, #8
	ldr r4, [r1, r0]
	ldr r0, [r1, #0x2c]
	lsl r1, r4, #0x18
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl GridInputHandler_SetNextLastUnk0FInputs
_021F7742:
	cmp r4, #0
	blt _021F7750
	cmp r4, #5
	bgt _021F7750
	ldr r1, [r5, #0x34]
	ldr r0, _021F784C ; =0x0000043C
	str r4, [r1, r0]
_021F7750:
	cmp r4, #0
	bne _021F77AC
	cmp r6, #5
	bne _021F77AC
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	add r0, r0, #1
	cmp r0, #0x12
	blt _021F7768
	mov r1, #0
	b _021F7770
_021F7768:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	add r1, r0, #1
_021F7770:
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F49E0
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F57B8
	ldr r0, [r5, #0x34]
	mov r1, #5
	mov r2, #4
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7850 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F77AC:
	cmp r4, #5
	bne _021F7806
	cmp r6, #0
	bne _021F7806
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	sub r0, r0, #1
	bpl _021F77C2
	mov r1, #0x11
	b _021F77CA
_021F77C2:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	sub r1, r0, #1
_021F77CA:
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F49E0
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F57B8
	ldr r0, [r5, #0x34]
	mov r1, #4
	mov r2, #2
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7850 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F7806:
	cmp r4, #0
	blt _021F7836
	cmp r4, #5
	bgt _021F7836
	cmp r6, #8
	beq _021F7836
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	mov r1, #6
	mul r1, r0
	add r0, r5, #0
	add r1, r4, r1
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F57B8
_021F7836:
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7850 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
	nop
_021F784C: .word 0x0000043C
_021F7850: .word ov14_021E9F20
	thumb_func_end ov14_021F7700

	thumb_func_start ov14_021F7854
ov14_021F7854: ; 0x021F7854
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	cmp r4, #6
	beq _021F7876
	cmp r4, #7
	beq _021F7876
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F7876:
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7854

	thumb_func_start ov14_021F7878
ov14_021F7878: ; 0x021F7878
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r4, r1, #0
	add r5, r0, #0
	sub r0, r4, #4
	cmp r0, #1
	bhi _021F789C
	ldr r0, [r5, #0x34]
	ldr r6, _021F78F4 ; =0x0000044D
	ldrb r1, [r0, r6]
	sub r6, #0x11
	lsr r3, r1, #0x1f
	lsl r2, r1, #0x1e
	sub r2, r2, r3
	mov r1, #0x1e
	ror r2, r1
	add r4, r3, r2
	str r4, [r0, r6]
_021F789C:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	cmp r4, #0
	blt _021F78E4
	cmp r4, #3
	bgt _021F78E4
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	add sp, #4
	pop {r3, r4, r5, r6, pc}
_021F78E4:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	nop
_021F78F4: .word 0x0000044D
	thumb_func_end ov14_021F7878

	thumb_func_start ov14_021F78F8
ov14_021F78F8: ; 0x021F78F8
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r6, r2, #0
	cmp r4, #0
	blt _021F7914
	cmp r4, #3
	bgt _021F7914
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021F791E
_021F7914:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021F791E:
	cmp r6, #6
	bne _021F793A
	cmp r4, #0
	bne _021F793A
	ldr r1, [r5, #0x34]
	ldr r0, _021F7A20 ; =0x0000043C
	mov r2, #6
	ldr r4, [r1, r0]
	ldr r0, [r1, #0x2c]
	lsl r1, r4, #0x18
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl GridInputHandler_SetNextLastUnk0FInputs
_021F793A:
	cmp r4, #0
	blt _021F7948
	cmp r4, #3
	bgt _021F7948
	ldr r1, [r5, #0x34]
	ldr r0, _021F7A20 ; =0x0000043C
	str r4, [r1, r0]
_021F7948:
	cmp r4, #0
	bne _021F7998
	cmp r6, #3
	bne _021F7998
	ldr r0, [r5, #0x34]
	ldr r1, _021F7A24 ; =0x0000044D
	ldrb r2, [r0, r1]
	add r2, r2, #1
	cmp r2, #0x18
	blt _021F7960
	mov r2, #0
	b _021F7960
_021F7960:
	strb r2, [r0, r1]
	add r0, r5, #0
	bl ov14_021F462C
	add r0, r5, #0
	bl ov14_021F4530
	add r0, r5, #0
	bl ov14_021F459C
	add r0, r5, #0
	bl ov14_021F58B8
	ldr r0, [r5, #0x34]
	mov r1, #5
	mov r2, #4
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7A28 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F7998:
	cmp r4, #3
	bne _021F79E6
	cmp r6, #0
	bne _021F79E6
	ldr r0, [r5, #0x34]
	ldr r1, _021F7A24 ; =0x0000044D
	ldrb r2, [r0, r1]
	sub r2, r2, #1
	bpl _021F79AE
	mov r2, #0x17
	b _021F79AE
_021F79AE:
	strb r2, [r0, r1]
	add r0, r5, #0
	bl ov14_021F462C
	add r0, r5, #0
	bl ov14_021F4530
	add r0, r5, #0
	bl ov14_021F459C
	add r0, r5, #0
	bl ov14_021F58B8
	ldr r0, [r5, #0x34]
	mov r1, #4
	mov r2, #2
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7A28 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F79E6:
	cmp r4, #0
	blt _021F7A0C
	cmp r4, #3
	bgt _021F7A0C
	cmp r6, #6
	beq _021F7A0C
	ldr r0, [r5, #0x34]
	ldr r1, _021F7A24 ; =0x0000044D
	ldrb r2, [r0, r1]
	lsr r2, r2, #2
	lsl r2, r2, #2
	add r2, r4, r2
	strb r2, [r0, r1]
	add r0, r5, #0
	bl ov14_021F459C
	add r0, r5, #0
	bl ov14_021F58B8
_021F7A0C:
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F7A28 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F7A20: .word 0x0000043C
_021F7A24: .word 0x0000044D
_021F7A28: .word ov14_021E9F20
	thumb_func_end ov14_021F78F8

	thumb_func_start ov14_021F7A2C
ov14_021F7A2C: ; 0x021F7A2C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	cmp r4, #4
	beq _021F7A4E
	cmp r4, #5
	beq _021F7A4E
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F7A4E:
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7A2C

	thumb_func_start ov14_021F7A50
ov14_021F7A50: ; 0x021F7A50
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0x2b
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x2c
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x2d
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x25
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x26
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x27
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x28
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x29
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x2a
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetAllEnabled
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7A50

	thumb_func_start ov14_021F7AC4
ov14_021F7AC4: ; 0x021F7AC4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x2c]
	add r4, r2, #0
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r2, sp, #0
	add r1, #3
	add r2, #2
	bl DpadMenuBox_GetPosition
	ldr r0, [r5, #0x2c]
	add r1, r4, #0
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0xa
	mov r1, #8
	bl Heap_Alloc
	add r4, r0, #0
	ldr r1, [r4, #4]
	mov r0, #3
	and r1, r0
	mov r0, #0x10
	orr r0, r1
	str r0, [r4, #4]
	add r0, sp, #0
	ldrb r1, [r0, #3]
	strb r1, [r4]
	ldrb r1, [r0, #2]
	strb r1, [r4, #1]
	ldrb r1, [r0, #1]
	ldrb r0, [r0, #3]
	cmp r0, r1
	blo _021F7B24
	sub r0, r0, r1
	strb r0, [r4, #2]
	ldr r1, [r4, #4]
	mov r0, #1
	bic r1, r0
	str r1, [r4, #4]
	b _021F7B34
_021F7B24:
	sub r0, r1, r0
	strb r0, [r4, #2]
	ldr r1, [r4, #4]
	mov r0, #1
	bic r1, r0
	mov r0, #1
	orr r0, r1
	str r0, [r4, #4]
_021F7B34:
	add r0, sp, #0
	ldrb r1, [r0]
	ldrb r0, [r0, #2]
	cmp r0, r1
	blo _021F7B4C
	sub r0, r0, r1
	strb r0, [r4, #3]
	ldr r1, [r4, #4]
	mov r0, #2
	bic r1, r0
	str r1, [r4, #4]
	b _021F7B58
_021F7B4C:
	sub r0, r1, r0
	strb r0, [r4, #3]
	ldr r1, [r4, #4]
	mov r0, #2
	orr r0, r1
	str r0, [r4, #4]
_021F7B58:
	ldrb r0, [r4, #2]
	ldr r1, [r4, #4]
	lsl r0, r0, #8
	lsr r1, r1, #2
	bl _u32_div_f
	lsr r0, r0, #8
	strb r0, [r4, #2]
	ldrb r0, [r4, #3]
	ldr r1, [r4, #4]
	lsl r0, r0, #8
	lsr r1, r1, #2
	bl _u32_div_f
	lsr r0, r0, #8
	strb r0, [r4, #3]
	str r4, [r5, #0xc]
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7AC4

	thumb_func_start ov14_021F7B7C
ov14_021F7B7C: ; 0x021F7B7C
	push {r3, lr}
	ldr r1, [r0, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #0
	bne _021F7B92
	mov r0, #0
	pop {r3, pc}
_021F7B92:
	ldr r0, _021F7BB4 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #2
	lsl r0, r0, #0xa
	tst r0, r1
	beq _021F7BA2
	mov r0, #1
	pop {r3, pc}
_021F7BA2:
	ldr r0, _021F7BB8 ; =ov14_021F86C8
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _021F7BB0
	mov r0, #1
	pop {r3, pc}
_021F7BB0:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021F7BB4: .word gSystem
_021F7BB8: .word ov14_021F86C8
	thumb_func_end ov14_021F7B7C

	.rodata

_021F7BBC:
	.byte 0x08, 0x9F, 0x28, 0x9F

ov14_021F7BC0: ; 0x021F7BC0
	.byte 0x39, 0x00, 0xAF, 0x01, 0x7F, 0x00, 0x13, 0x00

ov14_021F7BC8: ; 0x021F7BC8
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F7BD8: ; 0x021F7BD8
	.byte 0x1F, 0x36, 0x0F, 0x26, 0x41, 0x58, 0x0F, 0x26
	.byte 0x63, 0x7A, 0x0F, 0x26, 0x85, 0x9C, 0x0F, 0x26, 0xA7, 0xBE, 0x0F, 0x26, 0xC9, 0xE0, 0x0F, 0x26

ov14_021F7BF0: ; 0x021F7BF0
	.byte 0x1A, 0x39, 0x3A, 0x51, 0x3E, 0x5D, 0x42, 0x59, 0x1A, 0x39, 0x5A, 0x71, 0x3E, 0x5D, 0x62, 0x79
	.byte 0x1A, 0x39, 0x7A, 0x91, 0x3E, 0x5D, 0x82, 0x99

ov14_021F7C08: ; 0x021F7C08
	.byte 0xB2, 0xD1, 0x3A, 0x51, 0xD6, 0xF5, 0x42, 0x59
	.byte 0xB2, 0xD1, 0x5A, 0x71, 0xD6, 0xF5, 0x62, 0x79, 0xB2, 0xD1, 0x7A, 0x91, 0xD6, 0xF5, 0x82, 0x99

ov14_021F7C20: ; 0x021F7C20
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1F, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F7C3C: ; 0x021F7C3C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x04
	.byte 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F7C58: ; 0x021F7C58
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x04, 0x00, 0x01, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov14_021F7C74: ; 0x021F7C74
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1D, 0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F7C90: ; 0x021F7C90
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x1B, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F7CAC: ; 0x021F7CAC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x00
	.byte 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F7CC8: ; 0x021F7CC8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1D, 0x06, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov14_021F7CE4: ; 0x021F7CE4
	.byte 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00

ov14_021F7D0C: ; 0x021F7D0C
	.byte 0x00, 0x01, 0x02, 0x03
	.byte 0x04, 0x00, 0x00, 0x00

ov14_021F7D14: ; 0x021F7D14
	.byte 0x00, 0x01, 0x02, 0x03, 0x04, 0x06, 0x07, 0xFF

ov14_021F7D1C: ; 0x021F7D1C
	.byte 0x46, 0x00, 0x00, 0x00
	.byte 0x41, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00

ov14_021F7D2C: ; 0x021F7D2C
	.byte 0x45, 0x00, 0x00, 0x00
	.byte 0x41, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00

ov14_021F7D3C: ; 0x021F7D3C
	.byte 0x3D, 0x00, 0x01, 0x00
	.byte 0x41, 0x00, 0x00, 0x00, 0x42, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00

ov14_021F7D50: ; 0x021F7D50
	.word ov14_021E89B8, ov14_021E8A7C, 0x0000000F
	.word ov14_021E8ACC, ov14_021E8B1C, 0x00000011
	.word ov14_021E8B3C, ov14_021E8B80, 0x00000010

ov14_021F7D74: ; 0x021F7D74
	.word ov14_021F2020

ov14_021F7D78: ; 0x021F7D78
	.word ov14_021EB7E4
	.word ov14_021F20C4
	.word ov14_021EC300
	.word ov14_021F20F4
	.word ov14_021EEDB8
	.word ov14_021F21B4
	.word ov14_021F21D0
	.word ov14_021F21D0
	.word ov14_021F21B4

ov14_021F7D9C: ; 0x021F7D9C
	.word ov14_021EAFAC
	.word ov14_021EB0E4
	.word ov14_021EB170
	.word ov14_021EB18C
	.word ov14_021EB1A4
	.word ov14_021EB1C0
	.word ov14_021EB1E0
	.word ov14_021EB218
	.word ov14_021EB27C
	.word ov14_021EB290
	.word ov14_021EB2A8
	.word ov14_021EB2EC
	.word ov14_021EB388
	.word ov14_021EB7B0
	.word ov14_021EB7E4
	.word ov14_021EB8C0
	.word ov14_021EBAEC
	.word ov14_021EBB3C
	.word ov14_021EBDCC
	.word ov14_021EBDE0
	.word ov14_021EBDE8
	.word ov14_021EBE2C
	.word ov14_021EBE68
	.word ov14_021EBF8C
	.word ov14_021EE820
	.word ov14_021EBF9C
	.word ov14_021EC0EC
	.word ov14_021EC128
	.word ov14_021EC13C
	.word ov14_021EC150
	.word ov14_021EC2A4
	.word ov14_021EC2EC
	.word ov14_021EC300
	.word ov14_021EC23C
	.word ov14_021EC354
	.word ov14_021EC3A8
	.word ov14_021EC3D8
	.word ov14_021EC710
	.word ov14_021EC730
	.word ov14_021EC7D4
	.word ov14_021EC854
	.word ov14_021EC8D0
	.word ov14_021ECDA8
	.word ov14_021ECF58
	.word ov14_021ED1AC
	.word ov14_021ED1E8
	.word ov14_021ED258
	.word ov14_021ED2C8
	.word ov14_021ED2DC
	.word ov14_021ED350
	.word ov14_021ED35C
	.word ov14_021ED38C
	.word ov14_021ED5B0
	.word ov14_021ED60C
	.word ov14_021ED620
	.word ov14_021ED62C
	.word ov14_021ED650
	.word ov14_021ED684
	.word ov14_021ED6A4
	.word ov14_021ED6C4
	.word ov14_021ED6D0
	.word ov14_021ED414
	.word ov14_021EE830
	.word ov14_021ED760
	.word ov14_021ED7B8
	.word ov14_021ED7DC
	.word ov14_021ED820
	.word ov14_021ED920
	.word ov14_021ED940
	.word ov14_021ED960
	.word ov14_021ED96C
	.word ov14_021ED9AC
	.word ov14_021ED9EC
	.word ov14_021EE840
	.word ov14_021EE7B4
	.word ov14_021EE7C4
	.word ov14_021EE7D4
	.word ov14_021EDA1C
	.word ov14_021EDA3C
	.word ov14_021F0198
	.word ov14_021F01B8
	.word ov14_021EDA4C
	.word ov14_021EDE20
	.word ov14_021EDE38
	.word ov14_021EDE70
	.word ov14_021EDE88
	.word ov14_021EDF08
	.word ov14_021EDF28
	.word ov14_021EE850
	.word ov14_021EE860
	.word ov14_021EDF90
	.word ov14_021EDFA0
	.word ov14_021EE26C
	.word ov14_021EE328
	.word ov14_021EE338
	.word ov14_021EE35C
	.word ov14_021EE380
	.word ov14_021EE3C8
	.word ov14_021EE4AC
	.word ov14_021EE4D8
	.word ov14_021EE4E4
	.word ov14_021EE4FC
	.word ov14_021EE538
	.word ov14_021EE578
	.word ov14_021EE5C8
	.word ov14_021EE5E8
	.word ov14_021EE664
	.word ov14_021EE684
	.word ov14_021EE6D0
	.word ov14_021EE6F8
	.word ov14_021EE728
	.word ov14_021EE7E4
	.word ov14_021EE7F4
	.word ov14_021EE810
	.word ov14_021EC344
	.word ov14_021F1F44
	.word ov14_021F2010
	.word ov14_021EE87C
	.word ov14_021EEC8C
	.word ov14_021EEBFC
	.word ov14_021EEC9C
	.word ov14_021EED28
	.word ov14_021EEDB8
	.word ov14_021EEE94
	.word ov14_021EEED4
	.word ov14_021EEF34
	.word ov14_021EEF8C
	.word ov14_021EF024
	.word ov14_021EF190
	.word ov14_021EF1EC
	.word ov14_021EF248
	.word ov14_021EF6D4
	.word ov14_021EF6E4
	.word ov14_021EF6FC
	.word ov14_021EF8AC
	.word ov14_021EF920
	.word ov14_021EF93C
	.word ov14_021EF9BC
	.word ov14_021EF9CC
	.word ov14_021EFB64
	.word ov14_021EFDE4
	.word ov14_021EFDF4
	.word ov14_021EFF00
	.word ov14_021F00A0
	.word ov14_021F00BC
	.word ov14_021F0120
	.word ov14_021F0164
	.word ov14_021F2574
	.word ov14_021F259C
	.word ov14_021F25C4
	.word ov14_021F25D4
	.word ov14_021F2610
	.word ov14_021F261C
	.word ov14_021F2624
	.word ov14_021F262C
	.word ov14_021F2634
	.word ov14_021F263C
	.word ov14_021F2690
	.word ov14_021F26B4
	.word ov14_021F26F0
	.word ov14_021F2700
	.word ov14_021F2718
	.word ov14_021F2728
	.word ov14_021F2734
	.word ov14_021F2760
	.word ov14_021F276C
	.word ov14_021F2778
	.word ov14_021F27CC
	.word ov14_021F27D4
	.word ov14_021F2810
	.word ov14_021F2818
	.word ov14_021F2858
	.word ov14_021F2874
	.word ov14_021F2890
	.word ov14_021F2898
	.word ov14_021F28FC
	.word ov14_021F2914
	.word ov14_021F2930
	.word ov14_021F25E4

ov14_021F8068: ; 0x021F8068
	.byte 0x50, 0x60, 0x70, 0x90, 0xA0, 0xB0, 0x00, 0x00

ov14_021F8070: ; 0x021F8070
	.byte 0x01, 0xFF, 0x00, 0x00, 0x01, 0x01, 0xFF, 0xFF

ov14_021F8078: ; 0x021F8078
	.byte 0x00, 0x00, 0x01, 0xFF, 0x01, 0xFF, 0x01, 0xFF

ov14_021F8080: ; 0x021F8080
	.byte 0x0E, 0x0F, 0x05, 0x02, 0x0D, 0x0C, 0x06, 0x0B, 0x0A, 0x09, 0x00, 0x00

ov14_021F808C: ; 0x021F808C
	.byte 0x18, 0x10, 0x40, 0x18
	.byte 0x18, 0x30, 0x40, 0x38, 0x18, 0x50, 0x40, 0x58

ov14_021F8098: ; 0x021F8098
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x0A, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00

ov14_021F80A8: ; 0x021F80A8
	.byte 0x45, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00
	.byte 0x00, 0x40, 0x00, 0x00, 0x10, 0x00, 0x10, 0x00, 0x10, 0x00, 0x10, 0x00

ov14_021F80BC: ; 0x021F80BC
	.byte 0x28, 0x00

ov14_021F80BE: ; 0x021F80BE
	.byte 0xD0, 0x00
	.byte 0x50, 0x00, 0xD8, 0x00, 0x28, 0x00, 0xF0, 0x00, 0x50, 0x00, 0xF8, 0x00, 0x28, 0x00, 0x10, 0x01
	.byte 0x50, 0x00, 0x18, 0x01

ov14_021F80D4: ; 0x021F80D4
	.byte 0x35, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00
	.byte 0x07, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F80EC: ; 0x021F80EC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00

ov14_021F810C: ; 0x021F810C
	.byte 0x18, 0x00, 0x30, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0xF9, 0xC0, 0x00, 0x00, 0xF9, 0xC0, 0x00, 0x00, 0xF9, 0xC0, 0x00, 0x00, 0xF9, 0xC0, 0x00, 0x00
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F8140: ; 0x021F8140
	.byte 0x2B, 0x00, 0xEB, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x23, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFD, 0xC0, 0x00, 0x00
	.byte 0xFD, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov14_021F8174: ; 0x021F8174
	.byte 0x3B, 0x00, 0xEB, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x29, 0xC1, 0x00, 0x00, 0x00, 0xC1, 0x00, 0x00
	.byte 0xFE, 0xC0, 0x00, 0x00, 0xFE, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F81A8: ; 0x021F81A8
	.byte 0x0C, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x01, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2D, 0xC1, 0x00, 0x00
	.byte 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F81DC: ; 0x021F81DC
	.byte 0x9C, 0x00, 0x1C, 0x00
	.byte 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x2D, 0xC1, 0x00, 0x00, 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F8210: ; 0x021F8210
	.byte 0x8C, 0x00, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x1D, 0xC1, 0x00, 0x00, 0xFA, 0xC0, 0x00, 0x00, 0xFA, 0xC0, 0x00, 0x00
	.byte 0xFA, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov14_021F8244: ; 0x021F8244
	.byte 0x8C, 0x00, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x1E, 0xC1, 0x00, 0x00, 0xFB, 0xC0, 0x00, 0x00
	.byte 0xFA, 0xC0, 0x00, 0x00, 0xFA, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F8278: ; 0x021F8278
	.byte 0x0C, 0x00, 0xEB, 0xFF, 0x00, 0x00, 0x01, 0x00
	.byte 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2D, 0xC1, 0x00, 0x00
	.byte 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F82AC: ; 0x021F82AC
	.byte 0xF4, 0x00, 0xEB, 0xFF
	.byte 0x00, 0x00, 0x03, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x2D, 0xC1, 0x00, 0x00, 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F82E0: ; 0x021F82E0
	.byte 0x2B, 0x00, 0xEB, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x2D, 0xC1, 0x00, 0x00, 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00
	.byte 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov14_021F8314: ; 0x021F8314
	.byte 0x80, 0x00, 0xD8, 0xFF, 0x00, 0x00, 0x05, 0x00, 0x05, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2D, 0xC1, 0x00, 0x00, 0x01, 0xC1, 0x00, 0x00
	.byte 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F8348: ; 0x021F8348
	.byte 0x80, 0x00, 0xE4, 0xFF, 0x00, 0x00, 0x06, 0x00
	.byte 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2D, 0xC1, 0x00, 0x00
	.byte 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F837C: ; 0x021F837C
	.byte 0x80, 0x00, 0x80, 0x00
	.byte 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x2D, 0xC1, 0x00, 0x00, 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F83B0: ; 0x021F83B0
	.byte 0x80, 0x00, 0xA0, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x2D, 0xC1, 0x00, 0x00, 0x01, 0xC1, 0x00, 0x00, 0xFF, 0xC0, 0x00, 0x00
	.byte 0xFF, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov14_021F83E4: ; 0x021F83E4
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x1F, 0xC1, 0x00, 0x00, 0xFC, 0xC0, 0x00, 0x00
	.byte 0xFB, 0xC0, 0x00, 0x00, 0xFB, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F8418: ; 0x021F8418
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x20, 0xC1, 0x00, 0x00
	.byte 0xFD, 0xC0, 0x00, 0x00, 0xFB, 0xC0, 0x00, 0x00, 0xFB, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F844C: ; 0x021F844C
	.byte 0xA0, 0x00, 0x30, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x21, 0xC1, 0x00, 0x00, 0xFE, 0xC0, 0x00, 0x00, 0xFC, 0xC0, 0x00, 0x00, 0xFC, 0xC0, 0x00, 0x00
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov14_021F8480: ; 0x021F8480
	.byte 0xC2, 0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x22, 0xC1, 0x00, 0x00, 0xFE, 0xC0, 0x00, 0x00, 0xFC, 0xC0, 0x00, 0x00
	.byte 0xFC, 0xC0, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov14_021F84B4: ; 0x021F84B4
	.byte 0x04, 0x08, 0x05, 0x08, 0x02, 0x0F, 0x69, 0x00, 0x04, 0x01, 0x07, 0x08
	.byte 0x02, 0x0F, 0x79, 0x00, 0x04, 0x04, 0x09, 0x06, 0x02, 0x0F, 0x89, 0x00, 0x04, 0x01, 0x00, 0x1E
	.byte 0x03, 0x0F, 0x0F, 0x00, 0x04, 0x10, 0x05, 0x02, 0x02, 0x0F, 0x95, 0x00, 0x04, 0x01, 0x05, 0x06
	.byte 0x02, 0x0F, 0x99, 0x00, 0x04, 0x01, 0x0D, 0x08, 0x02, 0x0F, 0xA5, 0x00, 0x04, 0x01, 0x11, 0x0B
	.byte 0x02, 0x0F, 0xB5, 0x00, 0x04, 0x01, 0x15, 0x0C, 0x02, 0x0F, 0xCB, 0x00, 0x06, 0x01, 0x01, 0x0B
	.byte 0x02, 0x01, 0xEA, 0x03, 0x06, 0x01, 0x03, 0x0B, 0x02, 0x01, 0xD4, 0x03, 0x06, 0x01, 0x05, 0x0B
	.byte 0x02, 0x01, 0xBE, 0x03, 0x06, 0x01, 0x07, 0x0B, 0x02, 0x01, 0xA8, 0x03, 0x06, 0x01, 0x01, 0x0B
	.byte 0x02, 0x01, 0x92, 0x03, 0x06, 0x01, 0x03, 0x0B, 0x02, 0x01, 0x7C, 0x03, 0x06, 0x01, 0x05, 0x0B
	.byte 0x02, 0x01, 0x66, 0x03, 0x06, 0x01, 0x07, 0x0B, 0x02, 0x01, 0x50, 0x03, 0x04, 0x01, 0x0B, 0x08
	.byte 0x02, 0x0F, 0xE3, 0x00, 0x04, 0x01, 0x0F, 0x0B, 0x02, 0x0F, 0xF3, 0x00, 0x04, 0x01, 0x13, 0x0C
	.byte 0x02, 0x0F, 0x09, 0x01, 0x06, 0x01, 0x01, 0x0C, 0x02, 0x01, 0xE8, 0x03, 0x06, 0x04, 0x03, 0x1B
	.byte 0x06, 0x01, 0x2E, 0x03, 0x06, 0x01, 0x01, 0x0C, 0x02, 0x01, 0xD0, 0x03, 0x06, 0x04, 0x03, 0x1B
	.byte 0x06, 0x01, 0x8C, 0x02, 0x01, 0x00, 0x00, 0x0B, 0x03, 0x0C, 0xC7, 0x03, 0x01, 0x00, 0x00, 0x0B
	.byte 0x03, 0x02, 0xA6, 0x03, 0x01, 0x00, 0x00, 0x08, 0x03, 0x0C, 0x8E, 0x03, 0x01, 0x00, 0x00, 0x08
	.byte 0x03, 0x0C, 0x8E, 0x03, 0x01, 0x00, 0x00, 0x08, 0x03, 0x0C, 0x76, 0x03, 0x00, 0x00, 0x00, 0x0B
	.byte 0x03, 0x0C, 0x6D, 0x03, 0x00, 0x00, 0x00, 0x0B, 0x03, 0x0C, 0x4C, 0x03, 0x00, 0x00, 0x00, 0x0B
	.byte 0x03, 0x0C, 0x2B, 0x03, 0x00, 0x00, 0x00, 0x0B, 0x03, 0x0C, 0x0A, 0x03, 0x00, 0x00, 0x00, 0x0B
	.byte 0x03, 0x0C, 0xE9, 0x02, 0x00, 0x02, 0x0B, 0x07, 0x02, 0x01, 0x80, 0x03, 0x00, 0x02, 0x0F, 0x07
	.byte 0x02, 0x01, 0x72, 0x03, 0x01, 0x02, 0x0F, 0x07, 0x02, 0x01, 0x68, 0x03, 0x00, 0x02, 0x15, 0x1B
	.byte 0x02, 0x0B, 0xB3, 0x02, 0x00, 0x02, 0x01, 0x1B, 0x02, 0x0B, 0xB3, 0x02, 0x00, 0x02, 0x15, 0x13
	.byte 0x02, 0x0B, 0xB3, 0x02, 0x00, 0x02, 0x15, 0x1B, 0x02, 0x0B, 0x7D, 0x02, 0x00, 0x16, 0x10, 0x09
	.byte 0x04, 0x0C, 0x59, 0x02, 0x01, 0x00, 0x00, 0x11, 0x03, 0x0C, 0x35, 0x03, 0x01, 0x00, 0x00, 0x11
	.byte 0x03, 0x02, 0x02, 0x03

ov14_021F8614: ; 0x021F8614
	.byte 0x38, 0x4F, 0x1E, 0x35, 0x40, 0x57, 0x42, 0x59, 0x58, 0x6F, 0x1E, 0x35
	.byte 0x60, 0x77, 0x42, 0x59, 0x78, 0x8F, 0x1E, 0x35, 0x80, 0x97, 0x42, 0x59, 0xFF, 0x00, 0x00, 0x00

ov14_021F8630: ; 0x021F8630
	.byte 0x38, 0x4F, 0xB6, 0xCD, 0x40, 0x57, 0xDA, 0xF1, 0x58, 0x6F, 0xB6, 0xCD, 0x60, 0x77, 0xDA, 0xF1
	.byte 0x78, 0x8F, 0xB6, 0xCD, 0x80, 0x97, 0xDA, 0xF1, 0xFF, 0x00, 0x00, 0x00

ov14_021F864C: ; 0x021F864C
	.byte 0x28, 0x3F, 0x0C, 0x23
	.byte 0x28, 0x3F, 0x24, 0x3B, 0x28, 0x3F, 0x3C, 0x53, 0x28, 0x3F, 0x54, 0x6B, 0x28, 0x3F, 0x6C, 0x83
	.byte 0x28, 0x3F, 0x84, 0x9B, 0x40, 0x57, 0x0C, 0x23, 0x40, 0x57, 0x24, 0x3B, 0x40, 0x57, 0x3C, 0x53
	.byte 0x40, 0x57, 0x54, 0x6B, 0x40, 0x57, 0x6C, 0x83, 0x40, 0x57, 0x84, 0x9B, 0x58, 0x6F, 0x0C, 0x23
	.byte 0x58, 0x6F, 0x24, 0x3B, 0x58, 0x6F, 0x3C, 0x53, 0x58, 0x6F, 0x54, 0x6B, 0x58, 0x6F, 0x6C, 0x83
	.byte 0x58, 0x6F, 0x84, 0x9B, 0x70, 0x87, 0x0C, 0x23, 0x70, 0x87, 0x24, 0x3B, 0x70, 0x87, 0x3C, 0x53
	.byte 0x70, 0x87, 0x54, 0x6B, 0x70, 0x87, 0x6C, 0x83, 0x70, 0x87, 0x84, 0x9B, 0x88, 0x9F, 0x0C, 0x23
	.byte 0x88, 0x9F, 0x24, 0x3B, 0x88, 0x9F, 0x3C, 0x53, 0x88, 0x9F, 0x54, 0x6B, 0x88, 0x9F, 0x6C, 0x83
	.byte 0x88, 0x9F, 0x84, 0x9B, 0xFF, 0x00, 0x00, 0x00

ov14_021F86C8: ; 0x021F86C8
	.byte 0xA8, 0xBF, 0x00, 0x87

ov14_021F86CC:
	.word ov14_021F7878
	.word ov14_021F6B7C
	.word ov14_021F78F8
	.word ov14_021F7A2C

ov14_021F86DC:
	.word ov14_021F6F08
	.word ov14_021F6B7C
	.word ov14_021F6B8C
	.word ov14_021F6F70

ov14_021F86EC:
	.word ov14_021F6C3C
	.word ov14_021F6B7C
	.word ov14_021F6B8C
	.word ov14_021F6BA4

ov14_021F86FC:
	.word ov14_021F6C94
	.word ov14_021F6B7C
	.word ov14_021F6D14
	.word ov14_021F6E68

ov14_021F870C:
	.word ov14_021F7688
	.word ov14_021F6B7C
	.word ov14_021F7700
	.word ov14_021F7854

ov14_021F871C:
	.word ov14_021F73E4
	.word ov14_021F6B7C
	.word ov14_021F7444
	.word ov14_021F6BA4

ov14_021F872C:
	.word ov14_021F70F4
	.word ov14_021F6B7C
	.word ov14_021F7184
	.word ov14_021F7308

ov14_021F873C:
	.word ov14_021F7010
	.word ov14_021F6B7C
	.word ov14_021F708C
	.word ov14_021F70A4

ov14_021F874C:
	.word ov14_021F6B60
	.word ov14_021F6B7C
	.word ov14_021F6B8C
	.word ov14_021F6BA4

ov14_021F875C:
	.word ov14_021F7620
	.word ov14_021F6B7C
	.word ov14_021F7670
	.word ov14_021F6BA4

ov14_021F876C:
	.word ov14_021F7528
	.word ov14_021F6B7C
	.word ov14_021F7594
	.word ov14_021F75AC

ov14_021F877C:
	.byte 0x3C, 0x4B, 0xBC, 0xCB
	.byte 0x3C, 0x4B, 0xDC, 0xEB, 0x54, 0x63, 0xBC, 0xCB, 0x54, 0x63, 0xDC, 0xEB, 0x6C, 0x7B, 0xBC, 0xCB
	.byte 0x6C, 0x7B, 0xDC, 0xEB, 0x82, 0x9D, 0xB2, 0xF5, 0xA2, 0xBD, 0xB2, 0xF5, 0xFF, 0x00, 0x00, 0x00

ov14_021F87A0:
	.byte 0x17, 0x2E, 0x2F, 0x46, 0x17, 0x2E, 0x5D, 0x74, 0x17, 0x2E, 0x8B, 0xA2, 0x17, 0x2E, 0xB9, 0xD0
	.byte 0x17, 0x2E, 0x02, 0x17, 0x17, 0x2E, 0xE8, 0xFD, 0x70, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF
	.byte 0xFF, 0x00, 0x00, 0x00

ov14_021F87C4:
	.byte 0x38, 0x4F, 0x1E, 0x35, 0x40, 0x57, 0x42, 0x59, 0x58, 0x6F, 0x1E, 0x35
	.byte 0x60, 0x77, 0x42, 0x59, 0x78, 0x8F, 0x1E, 0x35, 0x80, 0x97, 0x42, 0x59, 0xA2, 0xBD, 0x1A, 0x5D
	.byte 0xA8, 0xBF, 0xC0, 0xFF, 0x88, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov14_021F87F0:
	.byte 0x47, 0x5E, 0x1F, 0x36, 0x47, 0x5E, 0x41, 0x58, 0x47, 0x5E, 0x63, 0x7A, 0x47, 0x5E, 0x85, 0x9C
	.byte 0x47, 0x5E, 0xA7, 0xBE, 0x47, 0x5E, 0xC9, 0xE0, 0x47, 0x5E, 0x01, 0x16, 0x47, 0x5E, 0xE9, 0xFE
	.byte 0x70, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov14_021F881C:
	.byte 0x38, 0x4F, 0x1E, 0x35
	.byte 0x40, 0x57, 0x42, 0x59, 0x58, 0x6F, 0x1E, 0x35, 0x60, 0x77, 0x42, 0x59, 0x78, 0x8F, 0x1E, 0x35
	.byte 0x80, 0x97, 0x42, 0x59, 0xA8, 0xBF, 0xC0, 0xFF, 0x40, 0x57, 0xA8, 0xFF, 0x58, 0x6F, 0xA8, 0xFF
	.byte 0x70, 0x87, 0xA8, 0xFF, 0x88, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov14_021F8850:
	.byte 0x0F, 0x26, 0x1F, 0x36, 0x0F, 0x26, 0x41, 0x58, 0x0F, 0x26, 0x63, 0x7A, 0x0F, 0x26, 0x85, 0x9C
	.byte 0x0F, 0x26, 0xA7, 0xBE, 0x0F, 0x26, 0xC9, 0xE0, 0x0F, 0x26, 0x01, 0x16, 0x0F, 0x26, 0xE9, 0xFE
	.byte 0x40, 0x6F, 0xA8, 0xFF, 0x70, 0x87, 0xA8, 0xFF, 0x88, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF
	.byte 0xFF, 0x00, 0x00, 0x00

ov14_021F8884:
	.byte 0x38, 0x4F, 0x1E, 0x35, 0x40, 0x57, 0x42, 0x59, 0x58, 0x6F, 0x1E, 0x35
	.byte 0x60, 0x77, 0x42, 0x59, 0x78, 0x8F, 0x1E, 0x35, 0x80, 0x97, 0x42, 0x59, 0xA2, 0xBD, 0x1A, 0x5D
	.byte 0xA8, 0xBF, 0xC0, 0xFF, 0x28, 0x3F, 0xA8, 0xFF, 0x40, 0x57, 0xA8, 0xFF, 0x58, 0x6F, 0xA8, 0xFF
	.byte 0x70, 0x87, 0xA8, 0xFF, 0x88, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov14_021F88C0:
	.byte 0xCC, 0x38, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0xEC, 0x38, 0x00, 0x00, 0x01, 0x03, 0x00, 0x01
	.byte 0xCC, 0x50, 0x00, 0x00, 0x00, 0x04, 0x02, 0x03, 0xEC, 0x50, 0x00, 0x00, 0x01, 0x05, 0x02, 0x03
	.byte 0xCC, 0x68, 0x00, 0x00, 0x02, 0x06, 0x04, 0x05, 0xEC, 0x68, 0x00, 0x00, 0x03, 0x06, 0x04, 0x05
	.byte 0xD4, 0x82, 0x00, 0x00, 0x84, 0x07, 0x06, 0x06, 0xD4, 0xA2, 0x00, 0x00, 0x06, 0x07, 0x07, 0x07

ov14_021F8900:
	.byte 0x3B, 0x1F, 0x00, 0x00, 0x00, 0x06, 0x03, 0x01, 0x69, 0x1F, 0x00, 0x00, 0x01, 0x06, 0x00, 0x02
	.byte 0x97, 0x1F, 0x00, 0x00, 0x02, 0x06, 0x01, 0x03, 0xC5, 0x1F, 0x00, 0x00, 0x03, 0x06, 0x02, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x04, 0x04, 0x04, 0x04, 0x00, 0x00, 0x00, 0x00, 0x05, 0x05, 0x05, 0x05
	.byte 0xD4, 0x70, 0x00, 0x00, 0x00, 0x07, 0x06, 0x06, 0xE0, 0xA8, 0x00, 0x00, 0x06, 0x07, 0x07, 0x07

ov14_021F8940:
	.byte 0x2B, 0x53, 0x00, 0x00, 0x00, 0x08, 0x05, 0x01, 0x4D, 0x53, 0x00, 0x00, 0x01, 0x08, 0x00, 0x02
	.byte 0x6F, 0x53, 0x00, 0x00, 0x02, 0x08, 0x01, 0x03, 0x91, 0x53, 0x00, 0x00, 0x03, 0x08, 0x02, 0x04
	.byte 0xB3, 0x53, 0x00, 0x00, 0x04, 0x08, 0x03, 0x05, 0xD5, 0x53, 0x00, 0x00, 0x05, 0x08, 0x04, 0x00
	.byte 0x0C, 0x53, 0x00, 0x00, 0x06, 0x06, 0x06, 0x06, 0xF4, 0x53, 0x00, 0x00, 0x07, 0x07, 0x07, 0x07
	.byte 0xD4, 0x70, 0x00, 0x00, 0x00, 0x09, 0x08, 0x08, 0xE0, 0xA8, 0x00, 0x00, 0x08, 0x09, 0x09, 0x09

ov14_021F8990:
	.byte 0x28, 0x34, 0x00, 0x00, 0x04, 0x02, 0x00, 0x01, 0x50, 0x3C, 0x00, 0x00, 0x05, 0x03, 0x00, 0x02
	.byte 0x28, 0x54, 0x00, 0x00, 0x00, 0x04, 0x01, 0x03, 0x50, 0x5C, 0x00, 0x00, 0x01, 0x05, 0x02, 0x04
	.byte 0x28, 0x74, 0x00, 0x00, 0x02, 0x06, 0x03, 0x05, 0x50, 0x7C, 0x00, 0x00, 0x03, 0x06, 0x04, 0x06
	.byte 0x3C, 0xA2, 0x00, 0x00, 0x85, 0x07, 0x05, 0x07, 0xE0, 0xA8, 0x00, 0x00, 0x06, 0x07, 0x06, 0x07
	.byte 0xD4, 0x88, 0x00, 0x00, 0x09, 0x09, 0x08, 0x08, 0xE0, 0xA8, 0x00, 0x00, 0x08, 0x08, 0x09, 0x09

ov14_021F89E0:
	.byte 0x2B, 0x17, 0x00, 0x00, 0x00, 0x08, 0x05, 0x01, 0x4D, 0x17, 0x00, 0x00, 0x01, 0x08, 0x00, 0x02
	.byte 0x6F, 0x17, 0x00, 0x00, 0x02, 0x08, 0x01, 0x03, 0x91, 0x17, 0x00, 0x00, 0x03, 0x08, 0x02, 0x04
	.byte 0xB3, 0x17, 0x00, 0x00, 0x04, 0x08, 0x03, 0x05, 0xD5, 0x17, 0x00, 0x00, 0x05, 0x08, 0x04, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x06, 0x06, 0x06, 0x06, 0x00, 0x00, 0x00, 0x00, 0x07, 0x07, 0x07, 0x07
	.byte 0xD4, 0x40, 0x00, 0x00, 0x00, 0x09, 0x08, 0x08, 0xD4, 0x70, 0x00, 0x00, 0x08, 0x0A, 0x09, 0x09
	.byte 0xD4, 0x88, 0x00, 0x00, 0x09, 0x0B, 0x0A, 0x0A, 0xE0, 0xA8, 0x00, 0x00, 0x0A, 0x0B, 0x0B, 0x0B

ov14_021F8A40:
	.byte 0x28, 0x34, 0x00, 0x00, 0x06, 0x02, 0x00, 0x01, 0x50, 0x3C, 0x00, 0x00, 0x06, 0x03, 0x00, 0x02
	.byte 0x28, 0x54, 0x00, 0x00, 0x00, 0x04, 0x01, 0x03, 0x50, 0x5C, 0x00, 0x00, 0x01, 0x05, 0x02, 0x04
	.byte 0x28, 0x74, 0x00, 0x00, 0x02, 0x06, 0x03, 0x05, 0x50, 0x7C, 0x00, 0x00, 0x03, 0x06, 0x04, 0x06
	.byte 0xE0, 0xA8, 0x00, 0x00, 0x85, 0x00, 0x05, 0x06, 0xD4, 0x40, 0x00, 0x00, 0x0B, 0x08, 0x07, 0x07
	.byte 0xD4, 0x58, 0x00, 0x00, 0x07, 0x09, 0x08, 0x08, 0xD4, 0x70, 0x00, 0x00, 0x08, 0x0A, 0x09, 0x09
	.byte 0xD4, 0x88, 0x00, 0x00, 0x09, 0x0B, 0x0A, 0x0A, 0xE0, 0xA8, 0x00, 0x00, 0x0A, 0x07, 0x0B, 0x0B

ov14_021F8AA0:
	.byte 0x28, 0x34, 0x00, 0x00, 0x07, 0x02, 0x00, 0x01, 0x50, 0x3C, 0x00, 0x00, 0x07, 0x03, 0x00, 0x02
	.byte 0x28, 0x54, 0x00, 0x00, 0x00, 0x04, 0x01, 0x03, 0x50, 0x5C, 0x00, 0x00, 0x01, 0x05, 0x02, 0x04
	.byte 0x28, 0x74, 0x00, 0x00, 0x02, 0x06, 0x03, 0x05, 0x50, 0x7C, 0x00, 0x00, 0x03, 0x06, 0x04, 0x06
	.byte 0x3C, 0xA2, 0x00, 0x00, 0x85, 0x07, 0x05, 0x07, 0xE0, 0xA8, 0x00, 0x00, 0x06, 0x00, 0x06, 0x07
	.byte 0xD4, 0x28, 0x00, 0x00, 0x0D, 0x09, 0x08, 0x08, 0xD4, 0x40, 0x00, 0x00, 0x08, 0x0A, 0x09, 0x09
	.byte 0xD4, 0x58, 0x00, 0x00, 0x09, 0x0B, 0x0A, 0x0A, 0xD4, 0x70, 0x00, 0x00, 0x0A, 0x0C, 0x0B, 0x0B
	.byte 0xD4, 0x88, 0x00, 0x00, 0x0B, 0x0D, 0x0C, 0x0C, 0xE0, 0xA8, 0x00, 0x00, 0x0C, 0x08, 0x0D, 0x0D

ov14_021F8B10: ; 0x021F8B10
	.word ov14_021F881C, ov14_021F8A40, ov14_021F86EC
	.word ov14_021F87F0, ov14_021F8940, ov14_021F86FC
	.word ov14_021F8C30, ov14_021F8F68, ov14_021F86DC
	.word ov14_021F8CD0, ov14_021F90A0, ov14_021F873C
	.word ov14_021F8D7C, ov14_021F91F0, ov14_021F872C
	.word ov14_021F8884, ov14_021F8AA0, ov14_021F871C
	.word ov14_021F8B94, ov14_021F8E38, ov14_021F876C
	.word ov14_021F87C4, ov14_021F8990, ov14_021F875C
	.word ov14_021F877C, ov14_021F88C0, ov14_021F874C
	.word ov14_021F8850, ov14_021F89E0, ov14_021F870C
	.word ov14_021F87A0, ov14_021F8900, ov14_021F86CC

ov14_021F8B94:
	.byte 0x28, 0x3F, 0x0C, 0x23, 0x28, 0x3F, 0x24, 0x3B, 0x28, 0x3F, 0x3C, 0x53
	.byte 0x28, 0x3F, 0x54, 0x6B, 0x28, 0x3F, 0x6C, 0x83, 0x28, 0x3F, 0x84, 0x9B, 0x40, 0x57, 0x0C, 0x23
	.byte 0x40, 0x57, 0x24, 0x3B, 0x40, 0x57, 0x3C, 0x53, 0x40, 0x57, 0x54, 0x6B, 0x40, 0x57, 0x6C, 0x83
	.byte 0x40, 0x57, 0x84, 0x9B, 0x58, 0x6F, 0x0C, 0x23, 0x58, 0x6F, 0x24, 0x3B, 0x58, 0x6F, 0x3C, 0x53
	.byte 0x58, 0x6F, 0x54, 0x6B, 0x58, 0x6F, 0x6C, 0x83, 0x58, 0x6F, 0x84, 0x9B, 0x70, 0x87, 0x0C, 0x23
	.byte 0x70, 0x87, 0x24, 0x3B, 0x70, 0x87, 0x3C, 0x53, 0x70, 0x87, 0x54, 0x6B, 0x70, 0x87, 0x6C, 0x83
	.byte 0x70, 0x87, 0x84, 0x9B, 0x88, 0x9F, 0x0C, 0x23, 0x88, 0x9F, 0x24, 0x3B, 0x88, 0x9F, 0x3C, 0x53
	.byte 0x88, 0x9F, 0x54, 0x6B, 0x88, 0x9F, 0x6C, 0x83, 0x88, 0x9F, 0x84, 0x9B, 0x11, 0x27, 0x1A, 0x8D
	.byte 0x11, 0x26, 0x01, 0x16, 0x11, 0x26, 0x91, 0xA6, 0xA8, 0xBF, 0x00, 0x57, 0xA8, 0xBF, 0x60, 0xB7
	.byte 0xA8, 0xBF, 0xC0, 0xFF, 0x88, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov14_021F8C30:
	.byte 0x28, 0x3F, 0x0C, 0x23, 0x28, 0x3F, 0x24, 0x3B, 0x28, 0x3F, 0x3C, 0x53, 0x28, 0x3F, 0x54, 0x6B
	.byte 0x28, 0x3F, 0x6C, 0x83, 0x28, 0x3F, 0x84, 0x9B, 0x40, 0x57, 0x0C, 0x23, 0x40, 0x57, 0x24, 0x3B
	.byte 0x40, 0x57, 0x3C, 0x53, 0x40, 0x57, 0x54, 0x6B, 0x40, 0x57, 0x6C, 0x83, 0x40, 0x57, 0x84, 0x9B
	.byte 0x58, 0x6F, 0x0C, 0x23, 0x58, 0x6F, 0x24, 0x3B, 0x58, 0x6F, 0x3C, 0x53, 0x58, 0x6F, 0x54, 0x6B
	.byte 0x58, 0x6F, 0x6C, 0x83, 0x58, 0x6F, 0x84, 0x9B, 0x70, 0x87, 0x0C, 0x23, 0x70, 0x87, 0x24, 0x3B
	.byte 0x70, 0x87, 0x3C, 0x53, 0x70, 0x87, 0x54, 0x6B, 0x70, 0x87, 0x6C, 0x83, 0x70, 0x87, 0x84, 0x9B
	.byte 0x88, 0x9F, 0x0C, 0x23, 0x88, 0x9F, 0x24, 0x3B, 0x88, 0x9F, 0x3C, 0x53, 0x88, 0x9F, 0x54, 0x6B
	.byte 0x88, 0x9F, 0x6C, 0x83, 0x88, 0x9F, 0x84, 0x9B, 0x11, 0x27, 0x1A, 0x8D, 0x11, 0x26, 0x01, 0x16
	.byte 0x11, 0x26, 0x91, 0xA6, 0xA8, 0xBF, 0xC0, 0xFF, 0x40, 0x57, 0xA8, 0xFF, 0x58, 0x6F, 0xA8, 0xFF
	.byte 0x70, 0x87, 0xA8, 0xFF, 0x88, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov14_021F8CD0:
	.byte 0x28, 0x3F, 0x0C, 0x23, 0x28, 0x3F, 0x24, 0x3B, 0x28, 0x3F, 0x3C, 0x53, 0x28, 0x3F, 0x54, 0x6B
	.byte 0x28, 0x3F, 0x6C, 0x83, 0x28, 0x3F, 0x84, 0x9B, 0x40, 0x57, 0x0C, 0x23, 0x40, 0x57, 0x24, 0x3B
	.byte 0x40, 0x57, 0x3C, 0x53, 0x40, 0x57, 0x54, 0x6B, 0x40, 0x57, 0x6C, 0x83, 0x40, 0x57, 0x84, 0x9B
	.byte 0x58, 0x6F, 0x0C, 0x23, 0x58, 0x6F, 0x24, 0x3B, 0x58, 0x6F, 0x3C, 0x53, 0x58, 0x6F, 0x54, 0x6B
	.byte 0x58, 0x6F, 0x6C, 0x83, 0x58, 0x6F, 0x84, 0x9B, 0x70, 0x87, 0x0C, 0x23, 0x70, 0x87, 0x24, 0x3B
	.byte 0x70, 0x87, 0x3C, 0x53, 0x70, 0x87, 0x54, 0x6B, 0x70, 0x87, 0x6C, 0x83, 0x70, 0x87, 0x84, 0x9B
	.byte 0x88, 0x9F, 0x0C, 0x23, 0x88, 0x9F, 0x24, 0x3B, 0x88, 0x9F, 0x3C, 0x53, 0x88, 0x9F, 0x54, 0x6B
	.byte 0x88, 0x9F, 0x6C, 0x83, 0x88, 0x9F, 0x84, 0x9B, 0x11, 0x27, 0x1A, 0x8D, 0x11, 0x26, 0x01, 0x16
	.byte 0x11, 0x26, 0x91, 0xA6, 0xA8, 0xBF, 0x00, 0x57, 0xA8, 0xBF, 0x60, 0xB7, 0xA8, 0xBF, 0xC0, 0xFF
	.byte 0x28, 0x3F, 0xA8, 0xFF, 0x40, 0x57, 0xA8, 0xFF, 0x58, 0x6F, 0xA8, 0xFF, 0x70, 0x87, 0xA8, 0xFF
	.byte 0x88, 0x9F, 0xA8, 0xFF, 0xA8, 0xBF, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov14_021F8D7C:
	.byte 0x28, 0x3F, 0x0C, 0x23
	.byte 0x28, 0x3F, 0x24, 0x3B, 0x28, 0x3F, 0x3C, 0x53, 0x28, 0x3F, 0x54, 0x6B, 0x28, 0x3F, 0x6C, 0x83
	.byte 0x28, 0x3F, 0x84, 0x9B, 0x40, 0x57, 0x0C, 0x23, 0x40, 0x57, 0x24, 0x3B, 0x40, 0x57, 0x3C, 0x53
	.byte 0x40, 0x57, 0x54, 0x6B, 0x40, 0x57, 0x6C, 0x83, 0x40, 0x57, 0x84, 0x9B, 0x58, 0x6F, 0x0C, 0x23
	.byte 0x58, 0x6F, 0x24, 0x3B, 0x58, 0x6F, 0x3C, 0x53, 0x58, 0x6F, 0x54, 0x6B, 0x58, 0x6F, 0x6C, 0x83
	.byte 0x58, 0x6F, 0x84, 0x9B, 0x70, 0x87, 0x0C, 0x23, 0x70, 0x87, 0x24, 0x3B, 0x70, 0x87, 0x3C, 0x53
	.byte 0x70, 0x87, 0x54, 0x6B, 0x70, 0x87, 0x6C, 0x83, 0x70, 0x87, 0x84, 0x9B, 0x88, 0x9F, 0x0C, 0x23
	.byte 0x88, 0x9F, 0x24, 0x3B, 0x88, 0x9F, 0x3C, 0x53, 0x88, 0x9F, 0x54, 0x6B, 0x88, 0x9F, 0x6C, 0x83
	.byte 0x88, 0x9F, 0x84, 0x9B, 0x38, 0x4F, 0xB6, 0xCD, 0x40, 0x57, 0xDA, 0xF1, 0x58, 0x6F, 0xB6, 0xCD
	.byte 0x60, 0x77, 0xDA, 0xF1, 0x78, 0x8F, 0xB6, 0xCD, 0x80, 0x97, 0xDA, 0xF1, 0xA2, 0xBD, 0xB2, 0xF5
	.byte 0x0F, 0x26, 0x1F, 0x36, 0x0F, 0x26, 0x41, 0x58, 0x0F, 0x26, 0x63, 0x7A, 0x0F, 0x26, 0x85, 0x9C
	.byte 0x0F, 0x26, 0xA7, 0xBE, 0x0F, 0x26, 0xC9, 0xE0, 0x0F, 0x26, 0x01, 0x16, 0x0F, 0x26, 0xE9, 0xFE
	.byte 0xA8, 0xBF, 0x00, 0x87, 0xFF, 0x00, 0x00, 0x00

ov14_021F8E38:
	.byte 0x18, 0x24, 0x00, 0x00, 0x1E, 0x06, 0x05, 0x01
	.byte 0x30, 0x24, 0x00, 0x00, 0x1E, 0x07, 0x00, 0x02, 0x48, 0x24, 0x00, 0x00, 0x1E, 0x08, 0x01, 0x03
	.byte 0x60, 0x24, 0x00, 0x00, 0x1E, 0x09, 0x02, 0x04, 0x78, 0x24, 0x00, 0x00, 0x1E, 0x0A, 0x03, 0x05
	.byte 0x90, 0x24, 0x00, 0x00, 0x1E, 0x0B, 0x04, 0x00, 0x18, 0x3C, 0x00, 0x00, 0x00, 0x0C, 0x0B, 0x07
	.byte 0x30, 0x3C, 0x00, 0x00, 0x01, 0x0D, 0x06, 0x08, 0x48, 0x3C, 0x00, 0x00, 0x02, 0x0E, 0x07, 0x09
	.byte 0x60, 0x3C, 0x00, 0x00, 0x03, 0x0F, 0x08, 0x0A, 0x78, 0x3C, 0x00, 0x00, 0x04, 0x10, 0x09, 0x0B
	.byte 0x90, 0x3C, 0x00, 0x00, 0x05, 0x11, 0x0A, 0x06, 0x18, 0x54, 0x00, 0x00, 0x06, 0x12, 0x11, 0x0D
	.byte 0x30, 0x54, 0x00, 0x00, 0x07, 0x13, 0x0C, 0x0E, 0x48, 0x54, 0x00, 0x00, 0x08, 0x14, 0x0D, 0x0F
	.byte 0x60, 0x54, 0x00, 0x00, 0x09, 0x15, 0x0E, 0x10, 0x78, 0x54, 0x00, 0x00, 0x0A, 0x16, 0x0F, 0x11
	.byte 0x90, 0x54, 0x00, 0x00, 0x0B, 0x17, 0x10, 0x0C, 0x18, 0x6C, 0x00, 0x00, 0x0C, 0x18, 0x17, 0x13
	.byte 0x30, 0x6C, 0x00, 0x00, 0x0D, 0x19, 0x12, 0x14, 0x48, 0x6C, 0x00, 0x00, 0x0E, 0x1A, 0x13, 0x15
	.byte 0x60, 0x6C, 0x00, 0x00, 0x0F, 0x1B, 0x14, 0x16, 0x78, 0x6C, 0x00, 0x00, 0x10, 0x1C, 0x15, 0x17
	.byte 0x90, 0x6C, 0x00, 0x00, 0x11, 0x1D, 0x16, 0x12, 0x18, 0x84, 0x00, 0x00, 0x12, 0xA1, 0x1D, 0x19
	.byte 0x30, 0x84, 0x00, 0x00, 0x13, 0xA1, 0x18, 0x1A, 0x48, 0x84, 0x00, 0x00, 0x14, 0xA1, 0x19, 0x1B
	.byte 0x60, 0x84, 0x00, 0x00, 0x15, 0xA1, 0x1A, 0x1C, 0x78, 0x84, 0x00, 0x00, 0x16, 0xA1, 0x1B, 0x1D
	.byte 0x90, 0x84, 0x00, 0x00, 0x17, 0xA1, 0x1C, 0x18, 0x54, 0x10, 0x00, 0x00, 0x21, 0x80, 0x1E, 0x1E
	.byte 0x00, 0x00, 0x00, 0x00, 0x1F, 0x1F, 0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20
	.byte 0x2C, 0xA8, 0x00, 0x00, 0x98, 0x1E, 0x21, 0x22, 0x8C, 0xA8, 0x00, 0x00, 0x98, 0x1E, 0x21, 0x23
	.byte 0xE0, 0xA8, 0x00, 0x00, 0x98, 0x1E, 0x22, 0x23, 0xD4, 0x88, 0x00, 0x00, 0x25, 0x25, 0x24, 0x24
	.byte 0xE0, 0xA8, 0x00, 0x00, 0x24, 0x24, 0x25, 0x25

ov14_021F8F68:
	.byte 0x18, 0x24, 0x00, 0x00, 0x1E, 0x06, 0x05, 0x01
	.byte 0x30, 0x24, 0x00, 0x00, 0x1E, 0x07, 0x00, 0x02, 0x48, 0x24, 0x00, 0x00, 0x1E, 0x08, 0x01, 0x03
	.byte 0x60, 0x24, 0x00, 0x00, 0x1E, 0x09, 0x02, 0x04, 0x78, 0x24, 0x00, 0x00, 0x1E, 0x0A, 0x03, 0x05
	.byte 0x90, 0x24, 0x00, 0x00, 0x1E, 0x0B, 0x04, 0x00, 0x18, 0x3C, 0x00, 0x00, 0x00, 0x0C, 0x0B, 0x07
	.byte 0x30, 0x3C, 0x00, 0x00, 0x01, 0x0D, 0x06, 0x08, 0x48, 0x3C, 0x00, 0x00, 0x02, 0x0E, 0x07, 0x09
	.byte 0x60, 0x3C, 0x00, 0x00, 0x03, 0x0F, 0x08, 0x0A, 0x78, 0x3C, 0x00, 0x00, 0x04, 0x10, 0x09, 0x0B
	.byte 0x90, 0x3C, 0x00, 0x00, 0x05, 0x11, 0x0A, 0x06, 0x18, 0x54, 0x00, 0x00, 0x06, 0x12, 0x11, 0x0D
	.byte 0x30, 0x54, 0x00, 0x00, 0x07, 0x13, 0x0C, 0x0E, 0x48, 0x54, 0x00, 0x00, 0x08, 0x14, 0x0D, 0x0F
	.byte 0x60, 0x54, 0x00, 0x00, 0x09, 0x15, 0x0E, 0x10, 0x78, 0x54, 0x00, 0x00, 0x0A, 0x16, 0x0F, 0x11
	.byte 0x90, 0x54, 0x00, 0x00, 0x0B, 0x17, 0x10, 0x0C, 0x18, 0x6C, 0x00, 0x00, 0x0C, 0x18, 0x17, 0x13
	.byte 0x30, 0x6C, 0x00, 0x00, 0x0D, 0x19, 0x12, 0x14, 0x48, 0x6C, 0x00, 0x00, 0x0E, 0x1A, 0x13, 0x15
	.byte 0x60, 0x6C, 0x00, 0x00, 0x0F, 0x1B, 0x14, 0x16, 0x78, 0x6C, 0x00, 0x00, 0x10, 0x1C, 0x15, 0x17
	.byte 0x90, 0x6C, 0x00, 0x00, 0x11, 0x1D, 0x16, 0x12, 0x18, 0x84, 0x00, 0x00, 0x12, 0x21, 0x1D, 0x19
	.byte 0x30, 0x84, 0x00, 0x00, 0x13, 0x21, 0x18, 0x1A, 0x48, 0x84, 0x00, 0x00, 0x14, 0x21, 0x19, 0x1B
	.byte 0x60, 0x84, 0x00, 0x00, 0x15, 0x21, 0x1A, 0x1C, 0x78, 0x84, 0x00, 0x00, 0x16, 0x21, 0x1B, 0x1D
	.byte 0x90, 0x84, 0x00, 0x00, 0x17, 0x21, 0x1C, 0x18, 0x54, 0x10, 0x00, 0x00, 0x21, 0x80, 0x1E, 0x1E
	.byte 0x00, 0x00, 0x00, 0x00, 0x1F, 0x1F, 0x1F, 0x1F, 0x00, 0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20
	.byte 0xE0, 0xA8, 0x00, 0x00, 0x98, 0x1E, 0x21, 0x21, 0xD4, 0x40, 0x00, 0x00, 0x26, 0x23, 0x22, 0x22
	.byte 0xD4, 0x58, 0x00, 0x00, 0x22, 0x24, 0x23, 0x23, 0xD4, 0x70, 0x00, 0x00, 0x23, 0x25, 0x24, 0x24
	.byte 0xD4, 0x88, 0x00, 0x00, 0x24, 0x26, 0x25, 0x25, 0xE0, 0xA8, 0x00, 0x00, 0x25, 0x22, 0x26, 0x26

ov14_021F90A0:
	.byte 0x18, 0x24, 0x00, 0x00, 0x1E, 0x06, 0x05, 0x01, 0x30, 0x24, 0x00, 0x00, 0x1E, 0x07, 0x00, 0x02
	.byte 0x48, 0x24, 0x00, 0x00, 0x1E, 0x08, 0x01, 0x03, 0x60, 0x24, 0x00, 0x00, 0x1E, 0x09, 0x02, 0x04
	.byte 0x78, 0x24, 0x00, 0x00, 0x1E, 0x0A, 0x03, 0x05, 0x90, 0x24, 0x00, 0x00, 0x1E, 0x0B, 0x04, 0x00
	.byte 0x18, 0x3C, 0x00, 0x00, 0x00, 0x0C, 0x0B, 0x07, 0x30, 0x3C, 0x00, 0x00, 0x01, 0x0D, 0x06, 0x08
	.byte 0x48, 0x3C, 0x00, 0x00, 0x02, 0x0E, 0x07, 0x09, 0x60, 0x3C, 0x00, 0x00, 0x03, 0x0F, 0x08, 0x0A
	.byte 0x78, 0x3C, 0x00, 0x00, 0x04, 0x10, 0x09, 0x0B, 0x90, 0x3C, 0x00, 0x00, 0x05, 0x11, 0x0A, 0x06
	.byte 0x18, 0x54, 0x00, 0x00, 0x06, 0x12, 0x11, 0x0D, 0x30, 0x54, 0x00, 0x00, 0x07, 0x13, 0x0C, 0x0E
	.byte 0x48, 0x54, 0x00, 0x00, 0x08, 0x14, 0x0D, 0x0F, 0x60, 0x54, 0x00, 0x00, 0x09, 0x15, 0x0E, 0x10
	.byte 0x78, 0x54, 0x00, 0x00, 0x0A, 0x16, 0x0F, 0x11, 0x90, 0x54, 0x00, 0x00, 0x0B, 0x17, 0x10, 0x0C
	.byte 0x18, 0x6C, 0x00, 0x00, 0x0C, 0x18, 0x17, 0x13, 0x30, 0x6C, 0x00, 0x00, 0x0D, 0x19, 0x12, 0x14
	.byte 0x48, 0x6C, 0x00, 0x00, 0x0E, 0x1A, 0x13, 0x15, 0x60, 0x6C, 0x00, 0x00, 0x0F, 0x1B, 0x14, 0x16
	.byte 0x78, 0x6C, 0x00, 0x00, 0x10, 0x1C, 0x15, 0x17, 0x90, 0x6C, 0x00, 0x00, 0x11, 0x1D, 0x16, 0x12
	.byte 0x18, 0x84, 0x00, 0x00, 0x12, 0xA1, 0x1D, 0x19, 0x30, 0x84, 0x00, 0x00, 0x13, 0xA1, 0x18, 0x1A
	.byte 0x48, 0x84, 0x00, 0x00, 0x14, 0xA1, 0x19, 0x1B, 0x60, 0x84, 0x00, 0x00, 0x15, 0xA1, 0x1A, 0x1C
	.byte 0x78, 0x84, 0x00, 0x00, 0x16, 0xA1, 0x1B, 0x1D, 0x90, 0x84, 0x00, 0x00, 0x17, 0xA1, 0x1C, 0x18
	.byte 0x54, 0x10, 0x00, 0x00, 0x21, 0x80, 0x1E, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x1F, 0x1F, 0x1F, 0x1F
	.byte 0x00, 0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20, 0x2C, 0xA8, 0x00, 0x00, 0x98, 0x1E, 0x21, 0x22
	.byte 0x8C, 0xA8, 0x00, 0x00, 0x98, 0x1E, 0x21, 0x23, 0xE0, 0xA8, 0x00, 0x00, 0x98, 0x1E, 0x22, 0x23
	.byte 0xD4, 0x28, 0x00, 0x00, 0x29, 0x25, 0x24, 0x24, 0xD4, 0x40, 0x00, 0x00, 0x24, 0x26, 0x25, 0x25
	.byte 0xD4, 0x58, 0x00, 0x00, 0x25, 0x27, 0x26, 0x26, 0xD4, 0x70, 0x00, 0x00, 0x26, 0x28, 0x27, 0x27
	.byte 0xD4, 0x88, 0x00, 0x00, 0x27, 0x29, 0x28, 0x28, 0xE0, 0xA8, 0x00, 0x00, 0x28, 0x24, 0x29, 0x29
ov14_021F91F0:
	.byte 0x18, 0x24, 0x00, 0x00, 0x25, 0x06, 0x1F, 0x01, 0x30, 0x24, 0x00, 0x00, 0x25, 0x07, 0x00, 0x02
	.byte 0x48, 0x24, 0x00, 0x00, 0x25, 0x08, 0x01, 0x03, 0x60, 0x24, 0x00, 0x00, 0x25, 0x09, 0x02, 0x04
	.byte 0x78, 0x24, 0x00, 0x00, 0x25, 0x0A, 0x03, 0x05, 0x90, 0x24, 0x00, 0x00, 0x25, 0x0B, 0x04, 0x9E
	.byte 0x18, 0x3C, 0x00, 0x00, 0x00, 0x0C, 0x1F, 0x07, 0x30, 0x3C, 0x00, 0x00, 0x01, 0x0D, 0x06, 0x08
	.byte 0x48, 0x3C, 0x00, 0x00, 0x02, 0x0E, 0x07, 0x09, 0x60, 0x3C, 0x00, 0x00, 0x03, 0x0F, 0x08, 0x0A
	.byte 0x78, 0x3C, 0x00, 0x00, 0x04, 0x10, 0x09, 0x0B, 0x90, 0x3C, 0x00, 0x00, 0x05, 0x11, 0x0A, 0x9E
	.byte 0x18, 0x54, 0x00, 0x00, 0x06, 0x12, 0x21, 0x0D, 0x30, 0x54, 0x00, 0x00, 0x07, 0x13, 0x0C, 0x0E
	.byte 0x48, 0x54, 0x00, 0x00, 0x08, 0x14, 0x0D, 0x0F, 0x60, 0x54, 0x00, 0x00, 0x09, 0x15, 0x0E, 0x10
	.byte 0x78, 0x54, 0x00, 0x00, 0x0A, 0x16, 0x0F, 0x11, 0x90, 0x54, 0x00, 0x00, 0x0B, 0x17, 0x10, 0xA0
	.byte 0x18, 0x6C, 0x00, 0x00, 0x0C, 0x18, 0x21, 0x13, 0x30, 0x6C, 0x00, 0x00, 0x0D, 0x19, 0x12, 0x14
	.byte 0x48, 0x6C, 0x00, 0x00, 0x0E, 0x1A, 0x13, 0x15, 0x60, 0x6C, 0x00, 0x00, 0x0F, 0x1B, 0x14, 0x16
	.byte 0x78, 0x6C, 0x00, 0x00, 0x10, 0x1C, 0x15, 0x17, 0x90, 0x6C, 0x00, 0x00, 0x11, 0x1D, 0x16, 0xA2
	.byte 0x18, 0x84, 0x00, 0x00, 0x12, 0x25, 0x23, 0x19, 0x30, 0x84, 0x00, 0x00, 0x13, 0x25, 0x18, 0x1A
	.byte 0x48, 0x84, 0x00, 0x00, 0x14, 0x25, 0x19, 0x1B, 0x60, 0x84, 0x00, 0x00, 0x15, 0x25, 0x1A, 0x1C
	.byte 0x78, 0x84, 0x00, 0x00, 0x16, 0x25, 0x1B, 0x1D, 0x90, 0x84, 0x00, 0x00, 0x17, 0x25, 0x1C, 0xA2
	.byte 0xC0, 0x34, 0x00, 0x00, 0x25, 0x20, 0x85, 0x1F, 0xE8, 0x3C, 0x00, 0x00, 0x25, 0x21, 0x1E, 0x80
	.byte 0xC0, 0x54, 0x00, 0x00, 0x1E, 0x22, 0x91, 0x21, 0xE8, 0x5C, 0x00, 0x00, 0x1F, 0x23, 0x20, 0x8C
	.byte 0xC0, 0x74, 0x00, 0x00, 0x20, 0x24, 0x97, 0x23, 0xE8, 0x7C, 0x00, 0x00, 0x21, 0x24, 0x22, 0x98
	.byte 0xD4, 0xA2, 0x00, 0x00, 0xA3, 0x25, 0x24, 0x24, 0x2B, 0x17, 0x00, 0x00, 0x18, 0x80, 0x2A, 0x26
	.byte 0x4D, 0x17, 0x00, 0x00, 0x18, 0x80, 0x25, 0x27, 0x6F, 0x17, 0x00, 0x00, 0x18, 0x80, 0x26, 0x28
	.byte 0x91, 0x17, 0x00, 0x00, 0x18, 0x80, 0x27, 0x29, 0xB3, 0x17, 0x00, 0x00, 0x18, 0x80, 0x28, 0x2A
	.byte 0xD5, 0x17, 0x00, 0x00, 0x18, 0x80, 0x29, 0x25, 0x00, 0x00, 0x00, 0x00, 0x2B, 0x2B, 0x2B, 0x2B
	.byte 0x00, 0x00, 0x00, 0x00, 0x2C, 0x2C, 0x2C, 0x2C, 0x44, 0xA8, 0x00, 0x00, 0x2D, 0x2D, 0x2D, 0x2D
