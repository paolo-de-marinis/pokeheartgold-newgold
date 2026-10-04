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

	thumb_func_start ov80_0223796C
ov80_0223796C: ; 0x0223796C
	push {r3, lr}
	bl ov80_022379C0
	lsl r1, r0, #2
	ldr r0, _0223797C ; =gBattleHallRankIVs + 1
	ldrb r0, [r0, r1]
	pop {r3, pc}
	nop
_0223797C: .word gBattleHallRankIVs + 1 ; each row's second byte
	thumb_func_end ov80_0223796C

	thumb_func_start ov80_02237980
ov80_02237980: ; 0x02237980
	add r2, r2, #1
	cmp r2, #8
	blt _0223798A
	mov r2, #7
	b _02237994
_0223798A:
	cmp r2, #4
	blt _02237992
	mov r2, #1
	b _02237994
_02237992:
	mov r2, #0
_02237994:
	ldrb r3, [r0, #4]
	cmp r3, #0
	bne _022379B0
	lsl r1, r1, #0x19
	lsr r1, r1, #0x17
	add r0, r0, r1
	ldrh r1, [r0, #0x18]
	ldr r0, _022379BC ; =0x0000FECD
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r0, #1
	bhi _022379B0
	mov r2, #7
_022379B0:
	cmp r3, #2
	bne _022379B6
	mov r2, #7
_022379B6:
	add r0, r2, #0
	bx lr
	nop
_022379BC: .word 0x0000FECD
	thumb_func_end ov80_02237980

	thumb_func_start ov80_022379C0
ov80_022379C0: ; 0x022379C0
	cmp r0, #0xa
	blo _022379C6
	mov r0, #9
_022379C6:
	bx lr
	thumb_func_end ov80_022379C0

	thumb_func_start ov80_022379C8
ov80_022379C8: ; 0x022379C8
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, _02237A34 ; =0x000006FC
	ldr r0, [r5, r0]
	bl SaveArray_Party_Get
	mov r1, #0x26
	lsl r1, r1, #4
	ldrb r1, [r5, r1]
	add r6, r0, #0
	bl Party_GetMonByIndex
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldrb r0, [r5, #4]
	bl ov80_0223787C
	cmp r0, #2
	bne _02237A16
	ldr r1, _02237A38 ; =0x00000261
	add r0, r6, #0
	ldrb r1, [r5, r1]
	bl Party_GetMonByIndex
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r4, r0
	bhi _02237A12
	add r4, r0, #0
_02237A12:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
_02237A16:
	ldrb r0, [r5, #4]
	bl ov80_0223792C
	cmp r0, #1
	bne _02237A2E
	ldr r0, _02237A3C ; =0x00000D84
	ldrh r0, [r5, r0]
	cmp r4, r0
	bhi _02237A2A
	add r4, r0, #0
_02237A2A:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
_02237A2E:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	nop
_02237A34: .word 0x000006FC
_02237A38: .word 0x00000261
_02237A3C: .word 0x00000D84
	thumb_func_end ov80_022379C8

	thumb_func_start ov80_02237A40
ov80_02237A40: ; 0x02237A40
	push {r3, lr}
	cmp r0, #0
	beq _02237A58
	lsl r0, r0, #0xc
	bl _ffltu
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _02237A66
_02237A58:
	lsl r0, r0, #0xc
	bl _ffltu
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_02237A66:
	bl _ffix
	bl FX_Sqrt
	pop {r3, pc}
	thumb_func_end ov80_02237A40
