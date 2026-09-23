	.include "asm/macros.inc"
	.include "overlay_18.inc"
	.include "global.inc"

	.extern ov18_021E5900
	.extern ov18_021E5904

	.text

	thumb_func_start ov18_021F9694
ov18_021F9694: ; 0x021F9694
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r1, #0
	bl ov18_021E5900
	add r6, r0, #0
	add r0, r5, #0
	bl ov18_021E5904
	add r1, r0, #0
	str r4, [sp]
	add r0, r6, #0
	mov r2, #1
	add r3, sp, #4
	bl GfGfxLoader_GetCharData
	add r6, r0, #0
	ldr r0, [sp, #4]
	mov r1, #0x80
	ldr r5, [r0, #0x14]
	add r0, r4, #0
	bl Heap_AllocAtEnd
	mov r1, #0
	mov r2, #0x80
	add r4, r0, #0
	bl memset
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x80
	mov r2, #0x40
	bl memcpy
	add r0, r4, #0
	add r0, #0x40
	add r1, r5, #0
	mov r2, #0x40
	bl memcpy
	add r0, r6, #0
	bl Heap_Free
	add r0, r4, #0
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F9694
