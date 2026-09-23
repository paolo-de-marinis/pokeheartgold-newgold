	.include "asm/macros.inc"
	.include "overlay_18.inc"
	.include "global.inc"
	.extern ov18_021E5900
	.extern ov18_021E5904
	.extern ov18_021E5908
	.extern ov18_021E590C
	.extern ov18_021E595C
	.extern ov18_021E59A8
	.extern ov18_021E613C
	.extern ov18_021E6D10
	.extern ov18_021E7698
	.extern ov18_021E8AB0
	.extern ov18_021E8ACC
	.extern ov18_021E8AE0
	.extern ov18_021E8B0C
	.extern ov18_021E8B18
	.extern ov18_021E8B24
	.extern ov18_021E8B5C

.public ov18_021EFBE8
.public ov18_021EFC3C
.public ov18_021EFC9C
.public ov18_021EFD00
.public ov18_021EFDB4
.public ov18_021EFE70
.public ov18_021F9648

	.text

	thumb_func_start ov18_021EF1E4
ov18_021EF1E4: ; 0x021EF1E4
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF218 ; =0x00020100
	ldr r1, _021EF21C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1a
	mov r3, #0x24
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF218: .word 0x00020100
_021EF21C: .word 0x0000065C
	thumb_func_end ov18_021EF1E4

	thumb_func_start ov18_021EF220
ov18_021EF220: ; 0x021EF220
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF254 ; =0x00020100
	ldr r1, _021EF258 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1b
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF254: .word 0x00020100
_021EF258: .word 0x0000065C
	thumb_func_end ov18_021EF220

	thumb_func_start ov18_021EF25C
ov18_021EF25C: ; 0x021EF25C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF290 ; =0x00020100
	ldr r1, _021EF294 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1c
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF290: .word 0x00020100
_021EF294: .word 0x0000065C
	thumb_func_end ov18_021EF25C

	thumb_func_start ov18_021EF298
ov18_021EF298: ; 0x021EF298
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF2CC ; =0x00020100
	ldr r1, _021EF2D0 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1d
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF2CC: .word 0x00020100
_021EF2D0: .word 0x0000065C
	thumb_func_end ov18_021EF298

	thumb_func_start ov18_021EF2D4
ov18_021EF2D4: ; 0x021EF2D4
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF308 ; =0x00020100
	ldr r1, _021EF30C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1e
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF308: .word 0x00020100
_021EF30C: .word 0x0000065C
	thumb_func_end ov18_021EF2D4

	thumb_func_start ov18_021EF310
ov18_021EF310: ; 0x021EF310
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF344 ; =0x00020100
	ldr r1, _021EF348 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1f
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF344: .word 0x00020100
_021EF348: .word 0x0000065C
	thumb_func_end ov18_021EF310

	thumb_func_start ov18_021EF34C
ov18_021EF34C: ; 0x021EF34C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF380 ; =0x00020100
	ldr r1, _021EF384 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x20
	mov r3, #0x18
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF380: .word 0x00020100
_021EF384: .word 0x0000065C
	thumb_func_end ov18_021EF34C

	thumb_func_start ov18_021EF388
ov18_021EF388: ; 0x021EF388
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	add r4, r0, #0
	str r0, [sp, #0x1c]
	mov r0, #0x25
	lsl r6, r1, #4
	str r0, [sp]
	str r2, [sp, #0x20]
	ldr r1, _021EF450 ; =0x00000854
	ldr r0, [sp, #0x1c]
	mov r2, #1
	ldr r0, [r0, r1]
	mov r1, #4
	add r3, sp, #0x2c
	add r4, #0xc
	bl GfGfxLoader_GetCharDataFromOpenNarc
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	mov r5, #0
	ldr r7, [r0, #0x14]
	str r5, [sp, #0x24]
_021EF3B4:
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	lsl r0, r5, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	mov r1, #0x31
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #6
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r4, r6
	add r1, r7, r1
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
	mov r1, #0xca
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #4
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r4, r6
	add r1, r7, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x24]
	add r5, #8
	add r0, r0, #1
	str r0, [sp, #0x24]
	cmp r0, #8
	blo _021EF3B4
	ldr r0, [sp, #0x28]
	bl Heap_Free
	add r0, r4, r6
	bl GetWindowWidth
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF454 ; =0x00020100
	lsl r5, r3, #3
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	lsr r3, r5, #0x1f
	add r3, r5, r3
	ldr r2, _021EF458 ; =0x0000065C
	ldr r1, [sp, #0x1c]
	add r0, r4, r6
	ldr r1, [r1, r2]
	ldr r2, [sp, #0x20]
	asr r3, r3, #1
	bl ov18_021F9648
	add r0, r4, r6
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF450: .word 0x00000854
_021EF454: .word 0x00020100
_021EF458: .word 0x0000065C
	thumb_func_end ov18_021EF388

	thumb_func_start ov18_021EF45C
ov18_021EF45C: ; 0x021EF45C
	push {r3, r4, r5, lr}
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	mov r0, #0x53
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x57
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x5b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x5f
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x63
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x67
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	mov r1, #0x14
	bl ov18_021EF1E4
	add r0, r5, #0
	mov r1, #0x15
	bl ov18_021EF220
	add r0, r5, #0
	mov r1, #0x16
	bl ov18_021EF25C
	add r0, r5, #0
	mov r1, #0x17
	bl ov18_021EF298
	add r0, r5, #0
	mov r1, #0x18
	bl ov18_021EF2D4
	add r0, r5, #0
	mov r1, #0x19
	bl ov18_021EF310
	add r0, r5, #0
	mov r1, #0x1a
	bl ov18_021EF34C
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x23
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x12
	mov r2, #0x24
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x25
	bl ov18_021EF388
	mov r0, #0x53
	lsl r0, r0, #2
	mov r4, #0x14
	add r5, r5, r0
_021EF518:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x1a
	bls _021EF518
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021EF45C

	thumb_func_start ov18_021EF528
ov18_021EF528: ; 0x021EF528
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r1, #0x1b
	bl ov18_021EFBE8
	add r0, r5, #0
	mov r1, #0x1c
	bl ov18_021EFC3C
	ldr r1, _021EF5CC ; =0x00001870
	mov r2, #0x1d
	ldr r1, [r5, r1]
	add r0, r5, #0
	add r3, r2, #0
	bl ov18_021EFC9C
	ldr r1, _021EF5D0 ; =0x00001874
	add r0, r5, #0
	ldr r1, [r5, r1]
	mov r2, #0x1e
	mov r3, #0x1d
	bl ov18_021EFC9C
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x28
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0x1f
	bl ov18_021EFD00
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x2c
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0x20
	bl ov18_021EFD00
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x30
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0x21
	bl ov18_021EFDB4
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x34
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0x22
	bl ov18_021EFDB4
	add r0, r5, #0
	mov r1, #0x23
	bl ov18_021EFE70
	mov r0, #0x6f
	lsl r0, r0, #2
	mov r4, #0x1b
	add r5, r5, r0
_021EF5BA:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x23
	bls _021EF5BA
	pop {r3, r4, r5, pc}
	nop
_021EF5CC: .word 0x00001870
_021EF5D0: .word 0x00001874
_021EF5D4: .word 0x00001850
	thumb_func_end ov18_021EF528

	thumb_func_start ov18_021EF5D8
ov18_021EF5D8: ; 0x021EF5D8
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	mov r0, #0x93
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x9b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x9f
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xa3
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xa7
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xab
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xaf
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0x93
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x1a
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0x9b
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x29
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0x9f
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2a
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xa3
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2b
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xa7
	lsl r0, r0, #2
	mov r2, #0x2c
	ldr r1, [r5, r1]
	add r0, r5, r0
	add r3, r2, #0
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xab
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2d
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xaf
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2e
	mov r3, #0x2c
	bl ov18_021F9648
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x25
	bl ov18_021EFBE8
	mov r0, #0x93
	lsl r0, r0, #2
	mov r4, #0x24
	add r5, r5, r0
_021EF748:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x2b
	bls _021EF748
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021EF75C: .word 0x00020100
_021EF760: .word 0x0000065C
	thumb_func_end ov18_021EF5D8

	thumb_func_start ov18_021EF764
ov18_021EF764: ; 0x021EF764
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	ldr r0, _021EF834 ; =0x0000041C
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EF838 ; =0x0000043C
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF83C ; =0x00020100
	ldr r1, _021EF840 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EF834 ; =0x0000041C
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x1b
	mov r3, #0x18
	bl ov18_021F9648
	mov r4, #0
_021EF7A4:
	add r0, r4, #0
	bl ov18_021E7698
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	cmp r4, #0x1a
	bne _021EF7B6
	mov r6, #0x71
	b _021EF7BA
_021EF7B6:
	add r6, r4, #0
	add r6, #0x45
_021EF7BA:
	add r0, r7, #0
	mov r1, #7
	bl _s32_div_f
	str r1, [sp, #0x10]
	add r0, r7, #0
	mov r1, #7
	bl _s32_div_f
	lsl r0, r0, #5
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF83C ; =0x00020100
	ldr r3, [sp, #0x10]
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, _021EF840 ; =0x0000065C
	ldr r0, _021EF838 ; =0x0000043C
	lsl r3, r3, #5
	ldr r1, [r5, r1]
	add r0, r5, r0
	add r2, r6, #0
	add r3, #0x18
	bl ov18_021F9648
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x1b
	blo _021EF7A4
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x42
	bl ov18_021EFC3C
	ldr r0, _021EF834 ; =0x0000041C
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _021EF838 ; =0x0000043C
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _021EF844 ; =0x0000042C
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021EF834: .word 0x0000041C
_021EF838: .word 0x0000043C
_021EF83C: .word 0x00020100
_021EF840: .word 0x0000065C
_021EF844: .word 0x0000042C
	thumb_func_end ov18_021EF764
