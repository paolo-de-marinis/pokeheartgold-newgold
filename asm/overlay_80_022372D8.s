	.include "asm/macros.inc"
	.include "overlay_80_022372D8.inc"
	.include "global.inc"

    .text

	thumb_func_start ov80_022372D8
ov80_022372D8: ; 0x022372D8
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r5, r3, #0
	add r0, r2, #0
	str r1, [sp]
	mov r4, #0
	bl ov80_022379C0
	lsl r1, r5, #0x19
	lsl r0, r0, #0x18
	ldr r2, [sp, #0x18]
	lsr r1, r1, #0x17
	add r5, r2, r1
	ldr r1, _0223732C ; =ov80_0223C698
	lsr r0, r0, #0x14
	add r7, r1, r0
	ldr r1, _02237330 ; =gBattleHallTypeTrainerClasses
	lsl r0, r6, #3
	add r6, r1, r0
_022372FE:
	bl LCRandom
	mov r1, #0xc
	bl _s32_div_f
	lsl r0, r1, #0x10
	lsr r0, r0, #0x10
	cmp r0, #8
	bhs _02237316
	lsl r0, r0, #1
	ldrh r0, [r7, r0]
	b _0223731E
_02237316:
	lsl r0, r0, #1
	add r0, r6, r0
	sub r0, #0x10
	ldrh r0, [r0]
_0223731E:
	strh r0, [r5]
	ldr r0, [sp]
	add r4, r4, #1
	add r5, r5, #2
	cmp r4, r0
	blt _022372FE
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223732C: .word ov80_0223C698
_02237330: .word gBattleHallTypeTrainerClasses
	thumb_func_end ov80_022372D8

	thumb_func_start ov80_02237334
ov80_02237334: ; 0x02237334
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	ldr r0, [sp, #0x34]
	str r1, [sp]
	str r0, [sp, #0x34]
	mov r0, #0
	str r0, [sp, #0x10]
	add r0, sp, #0x20
	ldrb r4, [r0, #0x10]
	add r6, r2, #0
	lsl r0, r4, #0x19
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	add r0, r3, #0
	bl ov80_022379C0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	cmp r5, #0
	bne _0223738E
	mov r0, #0xa
	add r1, r4, #1
	mul r0, r6
	add r0, r1, r0
	cmp r0, #0x32
	bne _0223737A
	ldr r0, [sp, #8]
	ldr r2, _0223743C ; =0x00000133
	lsl r1, r0, #1
	ldr r0, [sp, #0x34]
	add sp, #0x1c
	strh r2, [r0, r1]
	pop {r4, r5, r6, r7, pc}
_0223737A:
	cmp r0, #0xaa
	bne _0223738E
	ldr r0, [sp, #8]
	mov r2, #0x4d
	lsl r1, r0, #1
	ldr r0, [sp, #0x34]
	lsl r2, r2, #2
	strh r2, [r0, r1]
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
_0223738E:
	ldr r0, [sp, #8]
	lsl r1, r0, #1
	ldr r0, [sp, #0x34]
	add r0, r0, r1
	str r0, [sp, #0xc]
_02237398:
	bl LCRandom
	mov r1, #0x4b
	lsl r1, r1, #2
	bl _u32_div_f
	lsl r0, r1, #0x10
	lsr r4, r0, #0x10
	ldr r1, [sp, #8]
	ldr r0, [sp, #0x10]
	str r4, [sp, #0x14]
	add r5, r1, r0
	lsl r0, r5, #1
	str r0, [sp, #0x18]
	ldr r0, [sp, #4]
	lsl r1, r0, #4
	ldr r0, _02237440 ; =ov80_0223C698
	add r7, r0, r1
_022373BC:
	ldr r1, [sp, #0x34]
	ldr r0, [sp, #0x18]
	ldrh r6, [r1, r0]
	ldr r0, _02237444 ; =ov80_0223C738
	lsl r1, r4, #1
	ldrh r0, [r0, r1]
	cmp r6, r0
	bne _022373F6
	mov r1, #0
	cmp r5, #0
	ble _022373E2
	ldr r2, [sp, #0x34]
_022373D4:
	ldrh r0, [r2]
	cmp r4, r0
	beq _022373E2
	add r1, r1, #1
	add r2, r2, #2
	cmp r1, r5
	blt _022373D4
_022373E2:
	cmp r1, r5
	bne _022373F6
	ldr r0, [sp, #0xc]
	strh r4, [r0]
	add r0, r0, #2
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x10]
	add r0, r0, #1
	str r0, [sp, #0x10]
	b _0223742E
_022373F6:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	mov r0, #0x4b
	lsl r0, r0, #2
	cmp r4, r0
	blo _02237406
	mov r4, #0
_02237406:
	ldr r0, [sp, #0x14]
	cmp r4, r0
	bne _022373BC
_0223740C:
	bl LCRandom
	lsr r1, r0, #0x1f
	lsl r2, r0, #0x1d
	sub r2, r2, r1
	mov r0, #0x1d
	ror r2, r0
	add r0, r1, r2
	lsl r0, r0, #0x10
	lsr r0, r0, #0xf
	ldrh r2, [r7, r0]
	cmp r6, r2
	beq _0223740C
	ldr r1, [sp, #0x34]
	ldr r0, [sp, #0x18]
	strh r2, [r1, r0]
	b _022373BC
_0223742E:
	add r1, r0, #0
	ldr r0, [sp]
	cmp r1, r0
	blt _02237398
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_0223743C: .word 0x00000133
_02237440: .word ov80_0223C698
_02237444: .word ov80_0223C738
	thumb_func_end ov80_02237334
