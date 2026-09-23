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
