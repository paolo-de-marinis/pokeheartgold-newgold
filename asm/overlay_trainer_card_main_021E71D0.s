#include "constants/sndseq.h"
	.include "asm/macros.inc"
	.include "overlay_trainer_card_main.inc"
	.include "global.inc"

.public _021E7DB8
.public ov51_021E7DBC
.public ov51_021E7DC0
.public ov51_021E7DC8
.public ov51_021E7DD8
.public ov51_021E7DF0
.public ov51_021E7E08
.public ov51_021E7E20
.public ov51_021E7E38
.public ov51_021E7E54
.public ov51_021E7E70
.public ov51_021E7E8C
.public ov51_021E7EA8
.public ov51_021E7ED0
.public ov51_021E7F08
.public ov51_021E7F48

	.text

	thumb_func_start ov51_021E71D0
ov51_021E71D0: ; 0x021E71D0
	push {r3, r4, r5, lr}
	add r4, r1, #0
	ldr r1, _021E7204 ; =0x000030F4
	ldr r0, [r0, r1]
	cmp r0, #0
	beq _021E71F0
	mov r5, #7
	add r4, #0x70
_021E71E0:
	add r0, r4, #0
	bl CopyWindowToVram
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #0xb
	blt _021E71E0
	pop {r3, r4, r5, pc}
_021E71F0:
	mov r5, #0
_021E71F2:
	add r0, r4, #0
	bl CopyWindowToVram
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #7
	blt _021E71F2
	pop {r3, r4, r5, pc}
	nop
_021E7204: .word 0x000030F4
	thumb_func_end ov51_021E71D0

	thumb_func_start ov51_021E7208
ov51_021E7208: ; 0x021E7208
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r1, #0
	ldr r1, _021E74C4 ; =0x000033C4
	str r0, [sp, #0x14]
	ldr r0, [r0, r1]
	str r2, [sp, #0x18]
	str r0, [sp, #0x1c]
	mov r4, #7
	mov r6, #0
_021E721C:
	lsl r7, r4, #4
	add r0, r5, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	str r6, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E74C8 ; =0x00010200
	ldr r2, [sp, #0x14]
	str r0, [sp, #8]
	lsl r3, r4, #2
	add r3, r2, r3
	ldr r2, _021E74CC ; =0x000033EC
	str r6, [sp, #0xc]
	ldr r2, [r3, r2]
	add r0, r5, r7
	add r1, r6, #0
	add r3, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0xb
	blo _021E721C
	mov r0, #0x20
	mov r1, #0x19
	bl String_New
	add r7, r0, #0
	ldr r1, _021E74D0 ; =0x000033D0
	ldr r0, [sp, #0x14]
	mov r2, #0x19
	ldr r4, [r0, r1]
	mov r0, #6
	mov r1, #0x20
	bl MessageFormat_New_Custom
	ldr r1, [sp, #0x18]
	add r6, r0, #0
	add r1, #0x33
	ldrb r1, [r1]
	cmp r1, #0
	beq _021E72EC
	mov r1, #2
	str r1, [sp]
	mov r2, #1
	str r2, [sp, #4]
	ldr r2, [sp, #0x18]
	add r3, r1, #0
	add r2, #0x32
	ldrb r2, [r2]
	bl BufferIntegerAsString
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	add r2, #0x33
	ldrb r2, [r2]
	mov r1, #3
	bl BufferMonthNameAbbr
	mov r3, #2
	ldr r2, [sp, #0x18]
	str r3, [sp]
	mov r0, #1
	str r0, [sp, #4]
	add r2, #0x34
	ldrb r2, [r2]
	add r0, r6, #0
	mov r1, #4
	bl BufferIntegerAsString
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	ldrh r2, [r2, #0x2c]
	mov r1, #0
	mov r3, #3
	bl BufferIntegerAsString
	mov r3, #2
	ldr r2, [sp, #0x18]
	str r3, [sp]
	mov r1, #1
	str r1, [sp, #4]
	add r2, #0x35
	ldrb r2, [r2]
	add r0, r6, #0
	bl BufferIntegerAsString
	ldr r0, [sp, #0x1c]
	mov r1, #0x16
	add r2, r7, #0
	bl ReadMsgDataIntoString
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	b _021E7324
_021E72EC:
	ldr r0, [sp, #0x1c]
	mov r1, #0xc
	add r2, r7, #0
	bl ReadMsgDataIntoString
	mov r1, #0
	str r1, [sp]
	mov r0, #2
	str r0, [sp, #4]
	add r0, r6, #0
	add r2, r7, #0
	add r3, r1, #0
	bl BufferString
	mov r3, #0
	str r3, [sp]
	mov r0, #2
	str r0, [sp, #4]
	add r0, r6, #0
	mov r1, #1
	add r2, r7, #0
	bl BufferString
	ldr r0, [sp, #0x1c]
	mov r1, #0x19
	add r2, r4, #0
	bl ReadMsgDataIntoString
_021E7324:
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r1, #0xe0
	sub r3, r1, r0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E74C8 ; =0x00010200
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x70
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x1c]
	mov r1, #0x14
	add r2, r7, #0
	bl ReadMsgDataIntoString
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r1, #0xe0
	sub r3, r1, r0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E74C8 ; =0x00010200
	mov r1, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x70
	add r2, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	ldr r2, [r2, #0x38]
	mov r1, #5
	mov r3, #6
	bl BufferIntegerAsString
	ldr r0, [sp, #0x1c]
	mov r1, #0x1b
	add r2, r7, #0
	bl ReadMsgDataIntoString
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r1, #0xe0
	sub r3, r1, r0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E74C8 ; =0x00010200
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x80
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x1c]
	mov r1, #0x17
	add r2, r4, #0
	bl ReadMsgDataIntoString
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E74C8 ; =0x00010200
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x90
	mov r3, #0x70
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	mov r2, #0
	ldr r0, [sp, #0x18]
	str r4, [sp]
	ldr r0, [r0, #0x40]
	mov r1, #0xe0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #0xff
	str r0, [sp, #0x10]
	add r0, r5, #0
	add r0, #0x90
	add r3, r2, #0
	bl ov51_021E74F4
	ldr r0, [sp, #0x1c]
	mov r1, #0x18
	add r2, r4, #0
	bl ReadMsgDataIntoString
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E74C8 ; =0x00010200
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x90
	mov r3, #0xb0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x18]
	str r4, [sp]
	ldr r0, [r0, #0x3c]
	mov r1, #0xe0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #0xff
	str r0, [sp, #0x10]
	add r0, r5, #0
	add r0, #0x90
	mov r2, #0x40
	mov r3, #0
	bl ov51_021E74F4
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	ldr r2, [r2, #0x44]
	mov r1, #5
	mov r3, #6
	bl BufferIntegerAsString
	ldr r0, [sp, #0x1c]
	mov r1, #0x1b
	add r2, r7, #0
	bl ReadMsgDataIntoString
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r1, #0xe0
	sub r3, r1, r0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E74C8 ; =0x00010200
	add r5, #0xa0
	str r0, [sp, #8]
	add r0, r5, #0
	add r2, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r6, #0
	bl MessageFormat_Delete
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E74C4: .word 0x000033C4
_021E74C8: .word 0x00010200
_021E74CC: .word 0x000033EC
_021E74D0: .word 0x000033D0
	thumb_func_end ov51_021E7208

	thumb_func_start ov51_021E74D4
ov51_021E74D4: ; 0x021E74D4
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r6, r2, #0
	add r5, r0, #0
	cmp r4, r6
	bhi _021E74F2
_021E74E0:
	lsl r0, r4, #4
	add r0, r5, r0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, r6
	bls _021E74E0
_021E74F2:
	pop {r4, r5, r6, pc}
	thumb_func_end ov51_021E74D4

	thumb_func_start ov51_021E74F4
ov51_021E74F4: ; 0x021E74F4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r7, r0, #0
	mov r0, #1
	add r4, r2, #0
	str r0, [sp]
	add r2, sp, #0x18
	add r5, r1, #0
	add r6, r3, #0
	ldrb r2, [r2, #0x18]
	ldr r0, [sp, #0x28]
	ldr r1, [sp, #0x2c]
	ldr r3, [sp, #0x34]
	bl String16_FormatInteger
	mov r0, #0
	ldr r1, [sp, #0x28]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r3, r0, #0
	add r3, r3, r4
	str r6, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E753C ; =0x00010200
	ldr r2, [sp, #0x28]
	str r0, [sp, #8]
	mov r1, #0
	add r0, r7, #0
	sub r3, r5, r3
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E753C: .word 0x00010200
	thumb_func_end ov51_021E74F4

	thumb_func_start ov51_021E7540
ov51_021E7540: ; 0x021E7540
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r7, r0, #0
	add r5, r1, #0
	mov r0, #0
	add r4, r2, #0
	ldr r1, [sp, #0x28]
	add r6, r3, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r3, r0, #0
	add r3, r3, r4
	str r6, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E7578 ; =0x00010200
	ldr r2, [sp, #0x28]
	str r0, [sp, #8]
	mov r1, #0
	add r0, r7, #0
	sub r3, r5, r3
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E7578: .word 0x00010200
	thumb_func_end ov51_021E7540

	thumb_func_start ov51_021E757C
ov51_021E757C: ; 0x021E757C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r1, #0
	add r7, r0, #0
	ldr r0, [r5, #0x18]
	cmp r0, #0
	bne _021E758E
	bl GF_AssertFail
_021E758E:
	ldr r0, [r5, #0x18]
	bl GetIGTHours
	mov r0, #0x28
	str r0, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	add r0, r7, #0
	mov r1, #0
	add r0, #0x50
	mov r2, #0xb8
	add r3, r1, #0
	bl FillWindowPixelRect
	ldr r2, _021E765C ; =0x000002D7
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x19
	bl NewMsgDataFromNarc
	str r0, [sp, #0x10]
	mov r0, #0x20
	mov r1, #0x19
	bl String_New
	add r4, r0, #0
	mov r0, #0x20
	mov r1, #0x19
	bl String_New
	str r0, [sp, #0x14]
	mov r0, #2
	mov r1, #0x20
	mov r2, #0x19
	bl MessageFormat_New_Custom
	add r6, r0, #0
	ldr r0, [r5, #0x18]
	bl GetIGTHours
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	add r0, r6, #0
	mov r1, #0
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, [r5, #0x18]
	bl GetIGTMinutes
	mov r3, #2
	add r2, r0, #0
	str r3, [sp]
	mov r1, #1
	add r0, r6, #0
	str r1, [sp, #4]
	bl BufferIntegerAsString
	ldr r0, [sp, #0x10]
	ldr r2, [sp, #0x14]
	mov r1, #0x15
	bl ReadMsgDataIntoString
	ldr r2, [sp, #0x14]
	add r0, r6, #0
	add r1, r4, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r1, #0xe0
	sub r3, r1, r0
	mov r1, #0
	str r1, [sp]
	ldr r0, _021E7660 ; =0x00010200
	str r1, [sp, #4]
	str r0, [sp, #8]
	add r7, #0x50
	add r0, r7, #0
	add r2, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl DestroyMsgData
	add r0, r4, #0
	bl String_Delete
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r6, #0
	bl MessageFormat_Delete
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E765C: .word 0x000002D7
_021E7660: .word 0x00010200
	thumb_func_end ov51_021E757C

	thumb_func_start ov51_021E7664
ov51_021E7664: ; 0x021E7664
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	cmp r1, #0
	beq _021E7684
	mov r1, #0
	str r1, [sp]
	ldr r3, _021E76A0 ; =0x00010200
	str r1, [sp, #4]
	str r3, [sp, #8]
	mov r3, #0xcd
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r4, pc}
_021E7684:
	mov r1, #5
	str r1, [sp]
	mov r1, #0x10
	str r1, [sp, #4]
	mov r1, #0
	mov r2, #0xcd
	add r3, r1, #0
	bl FillWindowPixelRect
	add r0, r4, #0
	bl CopyWindowToVram
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021E76A0: .word 0x00010200
	thumb_func_end ov51_021E7664

	thumb_func_start ov51_021E76A4
ov51_021E76A4: ; 0x021E76A4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	ldr r1, _021E76E4 ; =0x000033D8
	add r5, r0, #0
	ldr r1, [r5, r1]
	mov r0, #4
	mov r2, #0
	bl FontID_String_GetWidth
	mov r1, #0x30
	sub r4, r1, r0
	add r0, r5, #0
	add r0, #0xd4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #4
	str r1, [sp]
	mov r2, #0
	ldr r0, _021E76E8 ; =0x00050400
	str r2, [sp, #4]
	str r0, [sp, #8]
	str r2, [sp, #0xc]
	ldr r2, _021E76E4 ; =0x000033D8
	add r0, r5, #0
	ldr r2, [r5, r2]
	add r0, #0xd4
	lsr r3, r4, #1
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E76E4: .word 0x000033D8
_021E76E8: .word 0x00050400
	thumb_func_end ov51_021E76A4

	thumb_func_start ov51_021E76EC
ov51_021E76EC: ; 0x021E76EC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r4, r5, #0
	add r4, #0xc4
	cmp r1, #0
	bne _021E7706
	ldr r0, _021E778C ; =0x0000343A
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	beq _021E7706
	mov r1, #1
_021E7706:
	cmp r1, #0
	beq _021E7712
	cmp r1, #1
	beq _021E7756
	add sp, #0x10
	pop {r3, r4, r5, pc}
_021E7712:
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, _021E7790 ; =0x000033E0
	mov r0, #4
	ldr r1, [r5, r1]
	mov r2, #0
	bl FontID_String_GetWidth
	mov r1, #0x60
	sub r3, r1, r0
	mov r1, #4
	str r1, [sp]
	mov r2, #0
	ldr r0, _021E7794 ; =0x00050400
	str r2, [sp, #4]
	str r0, [sp, #8]
	str r2, [sp, #0xc]
	ldr r2, _021E7790 ; =0x000033E0
	add r0, r4, #0
	ldr r2, [r5, r2]
	lsr r3, r3, #1
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _021E7798 ; =0x0000311C
	mov r1, #1
	add r0, r5, r0
	mov r2, #2
	add r3, r1, #0
	bl ov51_021E7D44
	add sp, #0x10
	pop {r3, r4, r5, pc}
_021E7756:
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #4
	str r0, [sp]
	mov r1, #0
	ldr r0, _021E7794 ; =0x00050400
	str r1, [sp, #4]
	str r0, [sp, #8]
	ldr r2, _021E779C ; =0x000033DC
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r0, r4, #0
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _021E7798 ; =0x0000311C
	mov r1, #1
	add r0, r5, r0
	mov r2, #4
	add r3, r1, #0
	bl ov51_021E7D44
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021E778C: .word 0x0000343A
_021E7790: .word 0x000033E0
_021E7794: .word 0x00050400
_021E7798: .word 0x0000311C
_021E779C: .word 0x000033DC
	thumb_func_end ov51_021E76EC

	thumb_func_start ov51_021E77A0
ov51_021E77A0: ; 0x021E77A0
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r4, r1, #0
	bne _021E77B6
	ldr r2, _021E77F4 ; =0x000003E1
	add r0, #0xb4
	mov r1, #1
	mov r3, #0xd
	bl DrawFrameAndWindow2
_021E77B6:
	add r0, r5, #0
	add r0, #0xb4
	mov r1, #0xf
	bl FillWindowPixelBuffer
	mov r3, #0
	ldr r2, _021E77F8 ; =0x0000343E
	str r3, [sp]
	ldrb r0, [r5, r2]
	lsl r4, r4, #2
	add r4, r5, r4
	str r0, [sp, #4]
	ldr r0, _021E77FC ; =0x0001020F
	sub r2, #0x5a
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r2, [r4, r2]
	add r0, #0xb4
	mov r1, #1
	bl AddTextPrinterParameterizedWithColor
	ldr r1, _021E7800 ; =0x0000343C
	strb r0, [r5, r1]
	ldr r0, [r5]
	mov r1, #4
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021E77F4: .word 0x000003E1
_021E77F8: .word 0x0000343E
_021E77FC: .word 0x0001020F
_021E7800: .word 0x0000343C
	thumb_func_end ov51_021E77A0

	thumb_func_start ov51_021E7804
ov51_021E7804: ; 0x021E7804
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r0, sp, #0
	mov r1, #0
	mov r2, #0x14
	bl MI_CpuFill8
	ldr r0, [r4]
	mov r1, #0x1a
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021E7864 ; =0x000003A5
	mov r2, #0xf
	str r0, [sp, #8]
	mov r0, #0xb
	str r0, [sp, #0xc]
	add r0, sp, #0
	strb r1, [r0, #0x10]
	mov r1, #6
	strb r1, [r0, #0x11]
	ldrb r1, [r0, #0x12]
	bic r1, r2
	ldr r2, _021E7868 ; =0x0000310C
	ldr r2, [r4, r2]
	lsl r2, r2, #0x18
	lsr r3, r2, #0x18
	mov r2, #0xf
	and r2, r3
	orr r1, r2
	strb r1, [r0, #0x12]
	ldrb r2, [r0, #0x12]
	mov r1, #0xf0
	bic r2, r1
	strb r2, [r0, #0x12]
	mov r0, #0xcf
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	add r1, sp, #0
	bl YesNoPrompt_InitFromTemplate
	ldr r0, [r4]
	mov r1, #4
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x14
	pop {r3, r4, pc}
	.balign 4, 0
_021E7864: .word 0x000003A5
_021E7868: .word 0x0000310C
	thumb_func_end ov51_021E7804

	thumb_func_start ov51_021E786C
ov51_021E786C: ; 0x021E786C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0xcf
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	add r6, r1, #0
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _021E7886
	cmp r0, #2
	beq _021E788A
	b _021E788E
_021E7886:
	mov r4, #1
	b _021E7894
_021E788A:
	mov r4, #0
	b _021E7894
_021E788E:
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021E7894:
	mov r0, #0xcf
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	bl YesNoPrompt_IsInTouchMode
	ldr r1, _021E78CC ; =0x0000310C
	str r0, [r5, r1]
	mov r0, #0xcf
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	bl YesNoPrompt_Reset
	cmp r4, #0
	beq _021E78B4
	cmp r6, #0
	beq _021E78C6
_021E78B4:
	add r0, r5, #0
	add r0, #0xb4
	mov r1, #0
	bl ClearFrameAndWindow2
	ldr r0, [r5]
	mov r1, #4
	bl ScheduleBgTilemapBufferTransfer
_021E78C6:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	nop
_021E78CC: .word 0x0000310C
	thumb_func_end ov51_021E786C

	thumb_func_start ov51_021E78D0
ov51_021E78D0: ; 0x021E78D0
	push {r4, lr}
	add r4, r0, #0
	cmp r1, #1
	bne _021E78E8
	add r0, #0xd4
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, #0xc4
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
_021E78E8:
	add r0, #0xd4
	bl ScheduleWindowCopyToVram
	add r4, #0xc4
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	pop {r4, pc}
	thumb_func_end ov51_021E78D0

	thumb_func_start ov51_021E78F8
ov51_021E78F8: ; 0x021E78F8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x6c
	mov r2, #1
	lsl r2, r2, #0x1a
	str r0, [sp, #0x14]
	ldr r0, [r2]
	ldr r1, _021E7AD8 ; =0xFFCFFFEF
	add r3, r0, #0
	ldr r0, _021E7ADC ; =0x00200010
	and r3, r1
	orr r0, r3
	str r0, [r2]
	ldr r2, _021E7AE0 ; =0x04001000
	ldr r0, [r2]
	and r1, r0
	mov r0, #0x10
	orr r0, r1
	str r0, [r2]
	bl ov51_021E7D68
	bl NNS_G2dInitOamManagerModule
	mov r0, #0
	str r0, [sp]
	mov r1, #0x80
	str r1, [sp, #4]
	str r0, [sp, #8]
	mov r3, #0x20
	str r3, [sp, #0xc]
	mov r2, #0x19
	str r2, [sp, #0x10]
	add r2, r0, #0
	bl OamManager_Create
	ldr r1, [sp, #0x14]
	mov r0, #0x21
	add r1, r1, #4
	mov r2, #0x19
	bl G2dRenderer_Init
	ldr r1, [sp, #0x14]
	mov r2, #0xe
	str r0, [r1]
	add r0, r1, #0
	add r0, r0, #4
	mov r1, #0
	lsl r2, r2, #0x10
	bl G2dRenderer_SetSubSurfaceCoords
	mov r7, #0x4f
	ldr r4, _021E7AE4 ; =ov51_021E7FB8
	ldr r5, [sp, #0x14]
	mov r6, #0
	lsl r7, r7, #2
_021E7964:
	ldrb r0, [r4]
	add r1, r6, #0
	mov r2, #0x19
	bl Create2DGfxResObjMan
	mov r1, #0x4b
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldrb r0, [r4]
	add r1, r6, #0
	mov r2, #0x19
	bl Create2DGfxResObjMan
	str r0, [r5, r7]
	add r6, r6, #1
	add r4, r4, #1
	add r5, r5, #4
	cmp r6, #4
	blt _021E7964
	ldr r0, _021E7AE8 ; =ov51_021E7FBC
	ldr r3, _021E7AEC ; =ov51_021E7FC4
	ldr r1, [r0]
	ldr r0, [r0, #4]
	str r1, [sp, #0x24]
	mov r5, #0
	str r0, [sp, #0x28]
	add r2, sp, #0x1c
	mov r1, #8
_021E799C:
	ldrb r0, [r3]
	add r3, r3, #1
	strb r0, [r2]
	add r2, r2, #1
	sub r1, r1, #1
	bne _021E799C
	ldr r4, [sp, #0x14]
	add r7, sp, #0x24
	add r6, sp, #0x1c
_021E79AE:
	str r5, [sp]
	ldr r0, [r7]
	mov r1, #0x31
	str r0, [sp, #4]
	mov r0, #0x19
	str r0, [sp, #8]
	mov r0, #0x4b
	lsl r0, r0, #2
	ldrb r2, [r6]
	ldr r0, [r4, r0]
	mov r3, #0
	bl AddCharResObjFromNarc
	mov r1, #0x53
	lsl r1, r1, #2
	str r0, [r4, r1]
	str r5, [sp]
	ldr r0, [r7]
	mov r3, #0
	str r0, [sp, #4]
	mov r0, #0x10
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	add r0, r1, #0
	sub r0, #0x1c
	ldrb r2, [r6, #1]
	ldr r0, [r4, r0]
	mov r1, #0x31
	bl AddPlttResObjFromNarc
	mov r1, #0x15
	lsl r1, r1, #4
	str r0, [r4, r1]
	str r5, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x19
	str r0, [sp, #8]
	add r0, r1, #0
	sub r0, #0x1c
	ldrb r2, [r6, #2]
	ldr r0, [r4, r0]
	mov r1, #0x31
	mov r3, #0
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x55
	lsl r1, r1, #2
	str r0, [r4, r1]
	str r5, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x19
	str r0, [sp, #8]
	add r0, r1, #0
	sub r0, #0x1c
	ldrb r2, [r6, #3]
	ldr r0, [r4, r0]
	mov r1, #0x31
	mov r3, #0
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x56
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0xc
	ldr r0, [r4, r0]
	bl SpriteTransfer_CreateCharTransferTask
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl SpriteTransfer_CreateExtPlttTransferTask
	add r5, r5, #1
	add r7, r7, #4
	add r6, r6, #4
	add r4, #0x10
	cmp r5, #2
	blt _021E79AE
	ldr r4, _021E7AF0 ; =ov51_021E7FDC
	add r3, sp, #0x2c
	mov r2, #8
_021E7A58:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021E7A58
	mov r0, #0x31
	mov r1, #0x19
	bl NARC_New
	str r0, [sp, #0x18]
	mov r1, #0x8e
	ldr r0, [sp, #0x14]
	lsl r1, r1, #2
	mov r4, #0
	add r7, r0, r1
_021E7A74:
	ldr r0, [sp, #0x14]
	lsl r6, r4, #2
	add r1, sp, #0x2c
	add r5, r0, r6
	ldr r0, [sp, #0x18]
	ldr r1, [r1, r6]
	mov r2, #0x19
	bl NARC_AllocAndReadWholeMember
	mov r1, #0x7e
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _021E7AAE
	add r1, r7, r6
	bl NNS_G2dGetUnpackedPaletteData
	cmp r0, #0
	bne _021E7AB2
	mov r0, #0x8e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Heap_Free
	bl GF_AssertFail
	b _021E7AB2
_021E7AAE:
	bl GF_AssertFail
_021E7AB2:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0x10
	blo _021E7A74
	ldr r0, [sp, #0x18]
	bl NARC_Delete
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add sp, #0x6c
	pop {r4, r5, r6, r7, pc}
	nop
_021E7AD8: .word 0xFFCFFFEF
_021E7ADC: .word 0x00200010
_021E7AE0: .word 0x04001000
_021E7AE4: .word ov51_021E7FB8
_021E7AE8: .word ov51_021E7FBC
_021E7AEC: .word ov51_021E7FC4
_021E7AF0: .word ov51_021E7FDC
	thumb_func_end ov51_021E78F8

	thumb_func_start ov51_021E7AF4
ov51_021E7AF4: ; 0x021E7AF4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x88
	str r1, [sp, #0x2c]
	mov r1, #0
	add r5, r0, #0
	str r2, [sp, #0x30]
	mov r2, #0x4b
	str r1, [sp]
	sub r0, r1, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	mov r0, #1
	lsl r2, r2, #2
	str r0, [sp, #0x10]
	ldr r0, [r5, r2]
	add r3, r1, #0
	str r0, [sp, #0x14]
	add r0, r2, #4
	ldr r0, [r5, r0]
	str r0, [sp, #0x18]
	add r0, r2, #0
	add r0, #8
	ldr r0, [r5, r0]
	add r2, #0xc
	str r0, [sp, #0x1c]
	ldr r0, [r5, r2]
	add r2, r1, #0
	str r0, [sp, #0x20]
	str r1, [sp, #0x24]
	str r1, [sp, #0x28]
	add r0, sp, #0x64
	bl CreateSpriteResourcesHeader
	ldr r0, [r5]
	mov r7, #0
	str r0, [sp, #0x34]
	add r0, sp, #0x64
	str r0, [sp, #0x38]
	mov r0, #1
	lsl r0, r0, #0xc
	str r7, [sp, #0x3c]
	str r7, [sp, #0x40]
	str r7, [sp, #0x44]
	str r0, [sp, #0x48]
	str r0, [sp, #0x4c]
	str r0, [sp, #0x50]
	add r0, sp, #0x34
	strh r7, [r0, #0x20]
	mov r0, #2
	str r0, [sp, #0x58]
	mov r0, #1
	str r0, [sp, #0x5c]
	mov r0, #0x19
	str r0, [sp, #0x60]
	ldr r0, [sp, #0x30]
	cmp r0, #0
	bne _021E7B6A
	mov r7, #0x28
_021E7B6A:
	ldr r6, _021E7BCC ; =ov51_021E801C
	mov r4, #0
_021E7B6E:
	ldr r0, [r6]
	lsl r0, r0, #0xc
	str r0, [sp, #0x3c]
	ldr r0, [r6, #4]
	add r0, r7, r0
	lsl r0, r0, #0xc
	str r0, [sp, #0x40]
	add r0, sp, #0x34
	bl Sprite_CreateAffine
	mov r1, #0x5b
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	mov r0, #0x5b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [sp, #0x2c]
	ldrb r0, [r0, r4]
	cmp r0, #0
	beq _021E7BB0
	ldr r0, [sp, #0x30]
	cmp r0, #0
	bne _021E7BBC
	cmp r4, #7
	ble _021E7BBC
_021E7BB0:
	mov r0, #0x5b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
_021E7BBC:
	add r4, r4, #1
	add r6, #8
	add r5, r5, #4
	cmp r4, #0x10
	blt _021E7B6E
	add sp, #0x88
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E7BCC: .word ov51_021E801C
	thumb_func_end ov51_021E7AF4

	thumb_func_start ov51_021E7BD0
ov51_021E7BD0: ; 0x021E7BD0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x80
	mov r1, #1
	add r5, r0, #0
	str r1, [sp]
	sub r0, r1, #2
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r3, #0x4f
	str r1, [sp, #0x10]
	lsl r3, r3, #2
	ldr r2, [r5, r3]
	str r2, [sp, #0x14]
	add r2, r3, #4
	ldr r2, [r5, r2]
	str r2, [sp, #0x18]
	add r2, r3, #0
	add r2, #8
	ldr r2, [r5, r2]
	add r3, #0xc
	str r2, [sp, #0x1c]
	ldr r2, [r5, r3]
	add r3, r1, #0
	str r2, [sp, #0x20]
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
	add r0, sp, #0x5c
	add r2, r1, #0
	bl CreateSpriteResourcesHeader
	ldr r0, [r5]
	mov r6, #0
	str r0, [sp, #0x2c]
	add r0, sp, #0x5c
	str r0, [sp, #0x30]
	mov r0, #1
	lsl r0, r0, #0xc
	str r6, [sp, #0x34]
	str r6, [sp, #0x38]
	str r6, [sp, #0x3c]
	str r0, [sp, #0x40]
	str r0, [sp, #0x44]
	str r0, [sp, #0x48]
	add r0, sp, #0x2c
	strh r6, [r0, #0x20]
	mov r0, #2
	str r0, [sp, #0x54]
	mov r0, #0x19
	ldr r4, _021E7C9C ; =ov51_021E80A4
	ldr r7, _021E7CA0 ; =_021E80A0
	str r6, [sp, #0x50]
	str r0, [sp, #0x58]
_021E7C3C:
	ldrb r0, [r4]
	lsl r0, r0, #0xc
	str r0, [sp, #0x34]
	ldrb r0, [r4, #1]
	lsl r1, r0, #0xc
	mov r0, #0xe
	lsl r0, r0, #0x10
	add r0, r1, r0
	str r0, [sp, #0x38]
	add r0, sp, #0x2c
	bl Sprite_CreateAffine
	mov r1, #0x1f
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	mov r0, #0x1f
	lsl r0, r0, #4
	ldrb r1, [r7]
	ldr r0, [r5, r0]
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x1f
	lsl r0, r0, #4
	mov r1, #2
	ldr r0, [r5, r0]
	sub r1, r1, r6
	bl Sprite_SetDrawPriority
	mov r0, #0x1f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
	add r6, r6, #1
	add r4, r4, #2
	add r5, r5, #4
	add r7, r7, #1
	cmp r6, #2
	blt _021E7C3C
	add sp, #0x80
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E7C9C: .word ov51_021E80A4
_021E7CA0: .word _021E80A0
	thumb_func_end ov51_021E7BD0

	thumb_func_start ov51_021E7CA4
ov51_021E7CA4: ; 0x021E7CA4
	push {r3, r4, r5, r6, r7, lr}
	mov r6, #0x7e
	add r5, r0, #0
	mov r4, #0
	lsl r6, r6, #2
_021E7CAE:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl Heap_Free
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0x10
	blo _021E7CAE
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl SpriteTransfer_DeleteCharTransferTask
	mov r0, #0x57
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl SpriteTransfer_DeleteCharTransferTask
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl SpriteTransfer_DeletePlttTransferTask
	mov r0, #0x16
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl SpriteTransfer_DeletePlttTransferTask
	mov r7, #0x4f
	mov r4, #0
	lsl r7, r7, #2
_021E7CF0:
	lsl r0, r4, #2
	add r6, r5, r0
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl Destroy2DGfxResObjMan
	ldr r0, [r6, r7]
	bl Destroy2DGfxResObjMan
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _021E7CF0
	mov r2, #3
	add r0, r5, #4
	mov r1, #0
	lsl r2, r2, #0x12
	bl G2dRenderer_SetSubSurfaceCoords
	ldr r0, [r5]
	bl SpriteList_Delete
	bl OamManager_Free
	bl ObjCharTransfer_Destroy
	bl ObjPlttTransfer_Destroy
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _021E7D40 ; =0xFFCFFFEF
	and r1, r0
	mov r0, #0x10
	orr r0, r1
	str r0, [r2]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E7D40: .word 0xFFCFFFEF
	thumb_func_end ov51_021E7CA4

	thumb_func_start ov51_021E7D44
ov51_021E7D44: ; 0x021E7D44
	push {r4, r5, r6, lr}
	add r6, r3, #0
	mov r3, #0x1f
	lsl r3, r3, #4
	lsl r4, r1, #2
	add r5, r0, r3
	ldr r0, [r5, r4]
	add r1, r2, #0
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r5, r4]
	bl Sprite_ResetAnimCtrlState
	ldr r0, [r5, r4]
	add r1, r6, #0
	bl Sprite_SetDrawFlag
	pop {r4, r5, r6, pc}
	thumb_func_end ov51_021E7D44

	thumb_func_start ov51_021E7D68
ov51_021E7D68: ; 0x021E7D68
	push {r4, lr}
	sub sp, #0x10
	ldr r4, _021E7DA0 ; =ov51_021E7FCC
	add r3, sp, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl ObjCharTransfer_Init
	mov r0, #2
	mov r1, #0x19
	bl ObjPlttTransfer_Init
	bl ObjCharTransfer_ClearBuffers
	bl ObjPlttTransfer_Reset
	mov r0, #0x19
	bl thunk_ClearMainOAM
	mov r0, #0x19
	bl thunk_ClearSubOAM
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021E7DA0: .word ov51_021E7FCC
	thumb_func_end ov51_021E7D68

	thumb_func_start ov51_021E7DA4
ov51_021E7DA4: ; 0x021E7DA4
	mov r2, #0
	mov r1, #0xff
_021E7DA8:
	strb r2, [r0]
	strb r1, [r0, #1]
	add r2, r2, #1
	add r0, r0, #2
	cmp r2, #4
	blt _021E7DA8
	bx lr
	.balign 4, 0
	thumb_func_end ov51_021E7DA4

	.rodata

_021E7DB8:
	.byte 0xA8, 0xBF, 0xBF, 0xFF

ov51_021E7DBC: ; 0x021E7DBC
	.byte 0xA8, 0xBF, 0x00, 0x70

ov51_021E7DC0: ; 0x021E7DC0
	.byte 0x00, 0xA8, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov51_021E7DC8: ; 0x021E7DC8
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov51_021E7DD8: ; 0x021E7DD8
	.byte 0x13, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00
	.byte 0x15, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x17, 0x00, 0x00, 0x00, 0x18, 0x00, 0x00, 0x00

ov51_021E7DF0: ; 0x021E7DF0
	.byte 0x07, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00
	.byte 0x0B, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00

ov51_021E7E08: ; 0x021E7E08
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00

ov51_021E7E20: ; 0x021E7E20
	.byte 0x0D, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00
	.byte 0x11, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00

ov51_021E7E38: ; 0x021E7E38
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1C, 0x00, 0x00, 0x02, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov51_021E7E54: ; 0x021E7E54
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1D, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov51_021E7E70: ; 0x021E7E70
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x01, 0x1D, 0x04, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov51_021E7E8C: ; 0x021E7E8C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x1E, 0x06
	.byte 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov51_021E7EA8: ; 0x021E7EA8
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov51_021E7ED0: ; 0x021E7ED0
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1C, 0x00
	.byte 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov51_021E7F08: ; 0x021E7F08
	.byte 0x4C, 0x00, 0x00, 0x00, 0x49, 0x00, 0x00, 0x00
	.byte 0x40, 0x00, 0x00, 0x00, 0x43, 0x00, 0x00, 0x00, 0x45, 0x00, 0x00, 0x00, 0x46, 0x00, 0x00, 0x00
	.byte 0x4A, 0x00, 0x00, 0x00, 0x42, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00, 0x00, 0x3E, 0x00, 0x00, 0x00
	.byte 0x4D, 0x00, 0x00, 0x00, 0x41, 0x00, 0x00, 0x00, 0x44, 0x00, 0x00, 0x00, 0x47, 0x00, 0x00, 0x00
	.byte 0x3F, 0x00, 0x00, 0x00, 0x4B, 0x00, 0x00, 0x00

ov51_021E7F48: ; 0x021E7F48
	.byte 0x07, 0x02, 0x03, 0x0C, 0x02, 0x0F, 0x81, 0x00
	.byte 0x07, 0x11, 0x03, 0x0D, 0x02, 0x0F, 0x99, 0x00, 0x07, 0x02, 0x06, 0x11, 0x02, 0x0F, 0xB3, 0x00
	.byte 0x07, 0x02, 0x09, 0x11, 0x02, 0x0F, 0xD5, 0x00, 0x07, 0x02, 0x0D, 0x11, 0x02, 0x0F, 0xF7, 0x00
	.byte 0x07, 0x02, 0x10, 0x1C, 0x02, 0x0F, 0x19, 0x01, 0x07, 0x02, 0x12, 0x1C, 0x02, 0x0F, 0x51, 0x01
	.byte 0x07, 0x02, 0x01, 0x1C, 0x04, 0x0F, 0xC1, 0x00, 0x07, 0x02, 0x06, 0x1C, 0x02, 0x0F, 0x31, 0x01
	.byte 0x07, 0x02, 0x08, 0x1C, 0x02, 0x0F, 0x69, 0x01, 0x07, 0x02, 0x0A, 0x1C, 0x02, 0x0F, 0xA1, 0x01
	.byte 0x04, 0x02, 0x01, 0x1B, 0x04, 0x0E, 0x39, 0x03, 0x04, 0x01, 0x15, 0x10, 0x03, 0x0F, 0x09, 0x03
	.byte 0x04, 0x19, 0x15, 0x06, 0x03, 0x0F, 0xF7, 0x02

ov51_021E7FB8: ; 0x021E7FB8
	.byte 0x01, 0x02, 0x01, 0x01

ov51_021E7FBC: ; 0x021E7FBC
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00

ov51_021E7FC4: ; 0x021E7FC4
	.byte 0x2E, 0x1E, 0x3A, 0x3B, 0x2D, 0x1D, 0x38, 0x39

ov51_021E7FCC: ; 0x021E7FCC
	.byte 0x02, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x19, 0x00, 0x00, 0x00

ov51_021E7FDC: ; 0x021E7FDC
	.byte 0x20, 0x00, 0x00, 0x00
	.byte 0x21, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00, 0x23, 0x00, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00
	.byte 0x25, 0x00, 0x00, 0x00, 0x26, 0x00, 0x00, 0x00, 0x27, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov51_021E801C: ; 0x021E801C
	.byte 0x60, 0x00, 0x00, 0x00
	.byte 0x30, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00
	.byte 0x30, 0x00, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00
	.byte 0x58, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00
	.byte 0x58, 0x00, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00, 0x58, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00
	.byte 0x88, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00, 0x88, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00
	.byte 0x88, 0x00, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00, 0x88, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00
	.byte 0xB0, 0x00, 0x00, 0x00, 0x90, 0x00, 0x00, 0x00, 0xB0, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00
	.byte 0xB0, 0x00, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00, 0xB0, 0x00, 0x00, 0x00

	.data

_021E80A0:
	.byte 0x00, 0x04, 0x00, 0x00

ov51_021E80A4: ; 0x021E80A4
	.byte 0xC0, 0xA8, 0x00, 0xA8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	; 0x021E80C0
