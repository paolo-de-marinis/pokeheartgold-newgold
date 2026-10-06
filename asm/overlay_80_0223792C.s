	.include "asm/macros.inc"
	.include "overlay_80_022372D8.inc"
	.include "global.inc"

	.text

	thumb_func_start ov80_0223792C
ov80_0223792C: ; 0x0223792C
	cmp r0, #2
	beq _02237934
	cmp r0, #3
	bne _02237938
_02237934:
	mov r0, #1
	bx lr
_02237938:
	mov r0, #0
	bx lr
	thumb_func_end ov80_0223792C

	thumb_func_start ov80_0223793C
ov80_0223793C: ; 0x0223793C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02237968 ; =0x000006FC
	ldr r0, [r4, r0]
	bl SaveArray_Party_Get
	mov r1, #0x26
	lsl r1, r1, #4
	ldrb r1, [r4, r1]
	bl Party_GetMonByIndex
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	mov r1, #0xa
	bl _s32_div_f
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r4, pc}
	nop
_02237968: .word 0x000006FC
	thumb_func_end ov80_0223793C
