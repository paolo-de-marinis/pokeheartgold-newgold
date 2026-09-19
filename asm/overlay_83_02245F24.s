	.include "asm/macros.inc"
	.include "overlay_83.inc"
	.include "global.inc"

	.text

	thumb_func_start ov83_02245F24
ov83_02245F24: ; 0x02245F24
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x13
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x15
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x17
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x19
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x1b
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x1d
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x1f
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x21
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x23
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x25
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x42
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x34
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x17
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x32
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x30
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x43
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x1d
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x36
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x1f
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x3a
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x21
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x38
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x23
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x3c
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _02246110 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x25
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x3e
	bl ov83_022479E4
	mov r0, #0x13
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x15
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x17
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x19
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x1b
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x1d
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x1f
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x21
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x23
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x25
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x10
	pop {r4, pc}
	nop
_02246110: .word 0x00010200
	thumb_func_end ov83_02245F24
