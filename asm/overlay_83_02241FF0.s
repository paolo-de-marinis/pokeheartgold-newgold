	.include "asm/macros.inc"
	.include "overlay_83.inc"
	.include "global.inc"

	.text

	thumb_func_start ov83_02241FF0
ov83_02241FF0: ; 0x02241FF0
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
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
	mov r0, #0x27
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x29
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x2b
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x58
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x4a
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x1d
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x48
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x1f
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x46
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x21
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x59
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x23
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x4c
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x25
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x50
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x27
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x4e
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x29
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x52
	bl ov83_022479E4
	mov r3, #0
	str r3, [sp]
	ldr r0, _022421DC ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	mov r0, #0x2b
	lsl r0, r0, #4
	ldr r1, [r4, #0x20]
	add r0, r4, r0
	mov r2, #0x54
	bl ov83_022479E4
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
	mov r0, #0x27
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x29
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	mov r0, #0x2b
	lsl r0, r0, #4
	add r0, r4, r0
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x10
	pop {r4, pc}
	nop
_022421DC: .word 0x00010200
	thumb_func_end ov83_02241FF0
