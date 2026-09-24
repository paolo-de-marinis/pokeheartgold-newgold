	.include "asm/macros.inc"
	.include "overlay_40.inc"
	.include "global.inc"


	.text

	thumb_func_start ov40_02235FA0
ov40_02235FA0: ; 0x02235FA0
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl DestroyMsgData
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Heap_Free
	mov r0, #0x77
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Heap_Free
	mov r0, #0x79
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	thumb_func_end ov40_02235FA0

	thumb_func_start ov40_02235FD0
ov40_02235FD0: ; 0x02235FD0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	cmp r1, #0
	bne _02235FF6
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_02235DAC
	cmp r0, #0
	bne _02235FEE
	ldr r0, _02235FF8 ; =0x0000057C
	bl PlaySE
	pop {r3, r4, r5, pc}
_02235FEE:
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_02235E34
_02235FF6:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02235FF8: .word 0x0000057C
	thumb_func_end ov40_02235FD0

	thumb_func_start ov40_02235FFC
ov40_02235FFC: ; 0x02235FFC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	str r0, [sp, #0x14]
	mov r0, #1
	str r0, [sp, #0x28]
	mov r1, #0x86
	ldr r0, [sp, #0x14]
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	ldr r5, _02236100 ; =ov40_02245708
	mov r7, #0
	add r4, #0xd0
_02236014:
	ldrb r0, [r5, #2]
	lsl r0, r0, #0x15
	lsr r0, r0, #0x18
	str r0, [sp, #0x24]
	ldrb r0, [r5]
	lsl r0, r0, #0x15
	lsr r0, r0, #0x18
	str r0, [sp, #0x20]
	ldrb r0, [r5, #3]
	lsr r1, r0, #3
	ldr r0, [sp, #0x24]
	sub r0, r1, r0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x1c]
	ldrb r0, [r5, #1]
	lsr r1, r0, #3
	ldr r0, [sp, #0x20]
	sub r0, r1, r0
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	add r0, r4, #0
	bl InitWindow
	ldr r0, [sp, #0x20]
	add r1, r4, #0
	str r0, [sp]
	ldr r0, [sp, #0x1c]
	mov r2, #6
	str r0, [sp, #4]
	str r6, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x28]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [sp, #0x24]
	ldr r0, [r0, #0x24]
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	add r1, r7, #0
	ldr r0, [r0, #0x48]
	add r1, #0x44
	bl NewString_ReadMsgData
	str r0, [sp, #0x2c]
	ldr r1, [sp, #0x2c]
	add r0, r4, #0
	bl ov40_022306C0
	lsl r1, r6, #3
	sub r1, #0x10
	str r0, [sp, #0x30]
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x14]
	add r1, r7, #0
	bl ov40_02235DAC
	cmp r0, #1
	bne _022360BE
	ldr r0, [sp, #0x18]
	ldr r2, [sp, #0x2c]
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02236104 ; =0x000F0D00
	ldr r3, [sp, #0x30]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #0
	bl AddTextPrinterParameterizedWithColor
	b _022360DA
_022360BE:
	ldr r0, [sp, #0x18]
	ldr r2, [sp, #0x2c]
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02236108 ; =0x000C0B00
	ldr r3, [sp, #0x30]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #0
	bl AddTextPrinterParameterizedWithColor
_022360DA:
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x2c]
	bl String_Delete
	ldr r0, [sp, #0x1c]
	add r7, r7, #1
	add r1, r0, #0
	ldr r0, [sp, #0x28]
	mul r1, r6
	add r0, r0, r1
	str r0, [sp, #0x28]
	add r4, #0x10
	add r5, r5, #4
	cmp r7, #9
	blo _02236014
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02236100: .word ov40_02245708
_02236104: .word 0x000F0D00
_02236108: .word 0x000C0B00
	thumb_func_end ov40_02235FFC

	thumb_func_start ov40_0223610C
ov40_0223610C: ; 0x0223610C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r5, [r0, r1]
	mov r4, #0
	add r5, #0xd0
_02236118:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #9
	blo _02236118
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_0223610C

	thumb_func_start ov40_02236130
ov40_02236130: ; 0x02236130
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	add r0, r4, #0
	add r0, #0x10
	bl WindowIsInUse
	cmp r0, #1
	bne _02236154
	add r0, r4, #0
	add r0, #0x10
	bl ClearWindowTilemapAndCopyToVram
	add r4, #0x10
	add r0, r4, #0
	bl RemoveWindow
_02236154:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02236130

	thumb_func_start ov40_02236158
ov40_02236158: ; 0x02236158
	bx lr
	.balign 4, 0
	thumb_func_end ov40_02236158

	thumb_func_start ov40_0223615C
ov40_0223615C: ; 0x0223615C
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r1, [r1]
	ldr r4, [r0, r2]
	cmp r1, #1
	beq _02236180
	bl ov40_0223D540
	mov r1, #0x8f
	lsl r1, r1, #2
	add r1, r4, r1
	mov r2, #5
	bl ov39_02227E8C
	mov r1, #0xb9
	lsl r1, r1, #2
	str r0, [r4, r1]
_02236180:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_0223615C

	thumb_func_start ov40_02236184
ov40_02236184: ; 0x02236184
	push {r3, r4, r5, lr}
	add r5, r1, #0
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r0, #0x6d
	bl sub_020314A4
	ldr r1, _022361AC ; =0x00002ED8
	str r0, [r4, r1]
	lsl r0, r5, #2
	add r2, r4, r0
	mov r0, #0xe3
	lsl r0, r0, #2
	ldr r0, [r2, r0]
	ldr r1, [r4, r1]
	bl ov39_022271C0
	pop {r3, r4, r5, pc}
	nop
_022361AC: .word 0x00002ED8
	thumb_func_end ov40_02236184

	thumb_func_start ov40_022361B0
ov40_022361B0: ; 0x022361B0
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _022361C0 ; =0x00002ED8
	ldr r3, _022361C4 ; =sub_020314BC
	ldr r0, [r1, r0]
	bx r3
	nop
_022361C0: .word 0x00002ED8
_022361C4: .word sub_020314BC
	thumb_func_end ov40_022361B0

	thumb_func_start ov40_022361C8
ov40_022361C8: ; 0x022361C8
	mov r2, #0
_022361CA:
	ldrh r1, [r0, #0x28]
	cmp r1, #0
	beq _022361D4
	mov r0, #1
	bx lr
_022361D4:
	add r2, r2, #1
	add r0, r0, #2
	cmp r2, #0x1e
	blt _022361CA
	mov r0, #0
	bx lr
	thumb_func_end ov40_022361C8

	thumb_func_start ov40_022361E0
ov40_022361E0: ; 0x022361E0
	push {r3, r4}
	mov r1, #0x1b
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	add r2, r4, #0
	cmp r4, #0x1e
	bge _0223620A
	lsl r1, r4, #1
	add r3, r0, r1
_022361F2:
	ldrh r1, [r3, #0x2c]
	cmp r1, #0
	beq _02236202
	mov r1, #0x1b
	lsl r1, r1, #4
	str r2, [r0, r1]
	pop {r3, r4}
	bx lr
_02236202:
	add r2, r2, #1
	add r3, r3, #2
	cmp r2, #0x1e
	blt _022361F2
_0223620A:
	mov r3, #0
	cmp r4, #0
	ble _0223622A
	add r2, r0, #0
_02236212:
	ldrh r1, [r2, #0x2c]
	cmp r1, #0
	beq _02236222
	mov r1, #0x1b
	lsl r1, r1, #4
	str r3, [r0, r1]
	pop {r3, r4}
	bx lr
_02236222:
	add r3, r3, #1
	add r2, r2, #2
	cmp r3, r4
	blt _02236212
_0223622A:
	pop {r3, r4}
	bx lr
	.balign 4, 0
	thumb_func_end ov40_022361E0

	thumb_func_start ov40_02236230
ov40_02236230: ; 0x02236230
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r5, r2]
	cmp r0, #3
	bhi _022362DE
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223624A: ; jump table
	.short _02236252 - _0223624A - 2 ; case 0
	.short _02236278 - _0223624A - 2 ; case 1
	.short _022362A4 - _0223624A - 2 ; case 2
	.short _022362B8 - _0223624A - 2 ; case 3
_02236252:
	cmp r1, #2
	bne _022362DE
	add r0, r5, #0
	bl ov40_02230944
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	cmp r1, #0
	ble _0223626A
	sub r1, r1, #1
	b _0223626C
_0223626A:
	mov r1, #0x11
_0223626C:
	str r1, [r4, r0]
	add r0, r5, #0
	mov r1, #4
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_02236278:
	cmp r1, #2
	bne _022362DE
	add r0, r5, #0
	bl ov40_02230944
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	ldr r0, [r4, r0]
	mov r1, #0x12
	bl _s32_div_f
	mov r0, #0x1a
	lsl r0, r0, #4
	str r1, [r4, r0]
	add r0, r5, #0
	mov r1, #4
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_022362A4:
	cmp r1, #0
	bne _022362DE
	add r0, r5, #0
	bl ov40_02230944
	add r0, r5, #0
	mov r1, #9
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_022362B8:
	cmp r1, #0
	bne _022362DE
	add r0, r5, #0
	bl ov40_02230944
	add r0, r4, #4
	bl ov40_022361C8
	cmp r0, #0
	beq _022362D6
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_022362D6:
	ldr r1, _022362E0 ; =0x0000010F
	add r0, r5, #0
	bl ov40_02237030
_022362DE:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022362E0: .word 0x0000010F
	thumb_func_end ov40_02236230

	thumb_func_start ov40_022362E4
ov40_022362E4: ; 0x022362E4
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x86
	add r4, r2, #0
	lsl r0, r0, #4
	ldr r6, [r4, r0]
	cmp r1, #0
	bne _0223631C
	cmp r5, #6
	beq _0223630E
	add r0, r4, #0
	bl ov40_02230944
	mov r0, #0xe
	lsl r0, r0, #6
	str r5, [r6, r0]
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
	pop {r4, r5, r6, pc}
_0223630E:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #7
	bl ov40_0222BF80
_0223631C:
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov40_022362E4

	thumb_func_start ov40_02236320
ov40_02236320: ; 0x02236320
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x86
	add r4, r2, #0
	lsl r0, r0, #4
	ldr r6, [r4, r0]
	cmp r1, #0
	bne _02236358
	cmp r5, #6
	beq _0223634A
	add r0, r4, #0
	bl ov40_02230944
	mov r0, #0xe
	lsl r0, r0, #6
	str r5, [r6, r0]
	add r0, r4, #0
	mov r1, #4
	bl ov40_0222BF80
	pop {r4, r5, r6, pc}
_0223634A:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0xc
	bl ov40_0222BF80
_02236358:
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov40_02236320

	thumb_func_start ov40_0223635C
ov40_0223635C: ; 0x0223635C
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r5, r2]
	cmp r1, #0
	bne _022363B6
	cmp r0, #0
	beq _02236376
	cmp r0, #1
	beq _02236398
	cmp r0, #2
	beq _022363A8
_02236376:
	add r0, r5, #0
	bl ov40_02230944
	ldr r0, _022363B8 ; =0x00002F64
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0223638E
	add r0, r5, #0
	mov r1, #7
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_0223638E:
	add r0, r5, #0
	mov r1, #8
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_02236398:
	add r0, r5, #0
	bl ov40_02230944
	add r0, r5, #0
	mov r1, #9
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_022363A8:
	add r0, r5, #0
	bl ov40_02230944
	add r0, r5, #0
	mov r1, #6
	bl ov40_0222BF80
_022363B6:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022363B8: .word 0x00002F64
	thumb_func_end ov40_0223635C

	thumb_func_start ov40_022363BC
ov40_022363BC: ; 0x022363BC
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r5, r2]
	cmp r1, #0
	bne _022364C4
	cmp r0, #0
	beq _022363D4
	cmp r0, #1
	beq _0223649C
	pop {r3, r4, r5, pc}
_022363D4:
	add r0, r5, #0
	bl ov40_02230944
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	ldr r0, [r4, r0]
	mov r1, #0x1e
	bl _s32_div_f
	mov r0, #0x1b
	lsl r0, r0, #4
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov40_022361E0
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, _022364C8 ; =0x00002F68
	str r1, [r4, r0]
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #6
	bl _s32_div_f
	ldr r2, _022364CC ; =0x00002F6C
	str r0, [r4, r2]
	sub r1, r2, #4
	ldr r3, [r4, r1]
	mov r1, #0x18
	mul r1, r3
	ldr r3, [r4, r2]
	mov r2, #0x16
	mov r0, #0x6f
	mul r2, r3
	lsl r0, r0, #4
	add r1, #0x6e
	add r2, #0x34
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl sub_020878B8
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02237564
	add r0, r5, #0
	bl ov40_02237474
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r1, #0x1b
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r5, #0
	bl ov40_022371E4
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r2, [r4, r0]
	lsl r1, r2, #1
	add r1, r4, r1
	ldrh r1, [r1, #0x2c]
	cmp r1, #0
	beq _022364C4
	sub r0, #0x58
	mov r1, #1
	ldr r0, [r4, r0]
	lsl r1, r2
	bl ov40_022371D4
	cmp r0, #1
	beq _022364C4
	mov r1, #0x1b
	lsl r1, r1, #4
	ldr r2, [r4, r1]
	sub r1, #0x54
	lsl r0, r2, #1
	add r0, r4, r0
	add r2, r4, r2
	ldrh r0, [r0, #0x2c]
	ldrb r1, [r2, r1]
	bl PlayCry
	pop {r3, r4, r5, pc}
_0223649C:
	add r0, r5, #0
	bl ov40_02230944
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r5, #0
	mov r1, #0xb
	bl ov40_0222BF80
_022364C4:
	pop {r3, r4, r5, pc}
	nop
_022364C8: .word 0x00002F68
_022364CC: .word 0x00002F6C
	thumb_func_end ov40_022363BC

	thumb_func_start ov40_022364D0
ov40_022364D0: ; 0x022364D0
	push {r3, r4, r5, lr}
	sub sp, #0x18
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	mov r1, #2
	bl ov40_0222D73C
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0xe8
	str r0, [sp, #4]
	mov r0, #0x24
	str r0, [sp, #8]
	sub r0, #0x2c
	str r0, [sp, #0xc]
	mov r0, #0
	mov r1, #0xd2
	str r0, [sp, #0x10]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #0x14]
	add r0, r5, #0
	add r1, r4, r1
	mov r2, #2
	mov r3, #3
	bl ov40_02230970
	mov r0, #0x80
	str r0, [sp]
	mov r0, #0xe8
	str r0, [sp, #4]
	mov r0, #0x24
	str r0, [sp, #8]
	sub r0, #0x2c
	str r0, [sp, #0xc]
	mov r0, #1
	mov r1, #0xd9
	str r0, [sp, #0x10]
	lsl r1, r1, #2
	str r0, [sp, #0x14]
	add r0, r5, #0
	add r1, r4, r1
	mov r2, #2
	mov r3, #0x35
	bl ov40_02230970
	add sp, #0x18
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_022364D0

	thumb_func_start ov40_02236534
ov40_02236534: ; 0x02236534
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	mov r0, #0xd2
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov40_022309CC
	mov r0, #0xd9
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov40_022309CC
	add r0, r5, #0
	bl ov40_0222D7DC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02236534

	thumb_func_start ov40_0223655C
ov40_0223655C: ; 0x0223655C
	mov r2, #0
	add r3, r0, #0
_02236560:
	ldrh r1, [r3, #0x2c]
	cmp r1, #0
	beq _0223656E
	mov r1, #0x1b
	lsl r1, r1, #4
	str r2, [r0, r1]
	bx lr
_0223656E:
	add r2, r2, #1
	add r3, r3, #2
	cmp r2, #0x1e
	blt _02236560
	bx lr
	thumb_func_end ov40_0223655C

	thumb_func_start ov40_02236578
ov40_02236578: ; 0x02236578
	push {r3, r4, r5, r6, r7, lr}
	add r6, r2, #0
	mov r2, #0x67
	add r4, r1, #0
	add r7, r3, #0
	add r5, r0, #0
	add r0, r7, #0
	mov r1, #0
	lsl r2, r2, #2
	bl memset
	mov r0, #0x6d
	str r0, [sp]
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	add r3, r7, #0
	bl ov39_02227088
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov40_02236578

	thumb_func_start ov40_022365A0
ov40_022365A0: ; 0x022365A0
	push {r3, r4, r5, lr}
	ldr r1, _022366A4 ; =0x00002F70
	add r5, r0, #0
	mov r0, #0x6d
	bl Heap_Alloc
	ldr r2, _022366A4 ; =0x00002F70
	mov r1, #0
	add r4, r0, #0
	bl memset
	mov r0, #0x86
	lsl r0, r0, #4
	str r4, [r5, r0]
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl SaveArray_PCStorage_Get
	str r0, [r4]
	mov r0, #0x83
	mov r2, #0x1a
	lsl r0, r0, #4
	lsl r2, r2, #4
	ldr r0, [r5, r0]
	ldr r1, [r4]
	ldr r2, [r4, r2]
	add r3, r4, #4
	bl ov40_02236578
	add r0, r4, #0
	bl ov40_0223655C
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #0
	bl ov40_0222D9E8
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _022366A8 ; =ov40_022452CC
	ldr r2, _022366AC ; =ov40_02236230
	mov r1, #4
	add r3, r5, #0
	bl TouchHitboxController_Create
	mov r1, #0x33
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _022366B0 ; =ov40_022452F4
	ldr r2, _022366B4 ; =ov40_022362E4
	mov r1, #7
	add r3, r5, #0
	bl TouchHitboxController_Create
	mov r1, #0xcd
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _022366B0 ; =ov40_022452F4
	ldr r2, _022366B8 ; =ov40_02236320
	mov r1, #7
	add r3, r5, #0
	bl TouchHitboxController_Create
	mov r1, #0xce
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _022366BC ; =ov40_02245284
	ldr r2, _022366C0 ; =ov40_0223635C
	mov r1, #3
	add r3, r5, #0
	bl TouchHitboxController_Create
	mov r1, #0xcf
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _022366C4 ; =ov40_0224526C
	ldr r2, _022366C8 ; =ov40_022363BC
	mov r1, #2
	add r3, r5, #0
	bl TouchHitboxController_Create
	mov r1, #0xd
	lsl r1, r1, #6
	str r0, [r4, r1]
	mov r0, #0x6d
	bl sub_020314A4
	mov r1, #0xe1
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	mov r1, #0x83
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	bl sub_020314C4
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222BF80
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022366A4: .word 0x00002F70
_022366A8: .word ov40_022452CC
_022366AC: .word ov40_02236230
_022366B0: .word ov40_022452F4
_022366B4: .word ov40_022362E4
_022366B8: .word ov40_02236320
_022366BC: .word ov40_02245284
_022366C0: .word ov40_0223635C
_022366C4: .word ov40_0224526C
_022366C8: .word ov40_022363BC
	thumb_func_end ov40_022365A0

	thumb_func_start ov40_022366CC
ov40_022366CC: ; 0x022366CC
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _022366E6
	cmp r1, #1
	beq _02236752
	cmp r1, #2
	beq _02236782
	b _022367AC
_022366E6:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #1
	bl ov40_0222DA84
	cmp r0, #0
	beq _022366FC
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022366FC:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #2
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #1
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022367B2
_02236752:
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D874
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #0
	bl ov40_0222FB90
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _022367B2
_02236782:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _022367B2
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_022364D0
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	bl ov40_02230738
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _022367B2
_022367AC:
	mov r1, #2
	bl ov40_0222BF80
_022367B2:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_022366CC

	thumb_func_start ov40_022367B8
ov40_022367B8: ; 0x022367B8
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _022367CC
	b _022368DC
_022367CC:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022367D8: ; jump table
	.short _022367E0 - _022367D8 - 2 ; case 0
	.short _02236822 - _022367D8 - 2 ; case 1
	.short _0223685A - _022367D8 - 2 ; case 2
	.short _02236886 - _022367D8 - 2 ; case 3
_022367E0:
	mov r2, #8
	mov r1, #0x69
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #8]
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	bl ov40_0222D980
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02237564
	add r0, r4, #0
	bl ov40_02237410
	add r0, r4, #0
	bl ov40_022371A0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02236822:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	mov r2, #1
	add r1, r5, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _022368DC
	mov r0, #0x83
	mov r2, #0x1a
	lsl r0, r0, #4
	lsl r2, r2, #4
	ldr r0, [r4, r0]
	ldr r1, [r5]
	ldr r2, [r5, r2]
	add r3, r5, #4
	bl ov40_02236578
	add r0, r5, #0
	bl ov40_0223655C
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022368DC
_0223685A:
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02237644
	add r0, r4, #0
	mov r1, #1
	bl ov40_02237548
	add r0, r4, #0
	mov r1, #0
	bl ov40_022373E4
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022368DC
_02236886:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _022368DC
	mov r1, #0x1b
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	add r0, r4, #0
	bl ov40_022371E4
	add r0, r4, #0
	bl ov40_02237144
	ldr r1, _022368E4 ; =0x0000010E
	add r0, r4, #0
	bl ov40_02237030
	add r0, r4, #0
	mov r1, #0
	bl ov40_02237548
	add r0, r4, #0
	mov r1, #1
	bl ov40_022373E4
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, _022368E8 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
_022368DC:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_022368E4: .word 0x0000010E
_022368E8: .word 0x04000050
	thumb_func_end ov40_022367B8

	thumb_func_start ov40_022368EC
ov40_022368EC: ; 0x022368EC
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r0, r2]
	cmp r1, #0
	bne _02236920
	mov r0, #0xda
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	mov r0, #0xdb
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	mov r0, #0xd3
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x20
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	b _02236946
_02236920:
	mov r0, #0xda
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	mov r0, #0xdb
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	mov r0, #0xd3
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x50
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
_02236946:
	mov r0, #0x35
	lsl r0, r0, #4
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x2c
	bl sub_020136B4
	mov r0, #0xdb
	lsl r0, r0, #2
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x2c
	bl sub_020136B4
	pop {r4, pc}
	thumb_func_end ov40_022368EC

	thumb_func_start ov40_02236968
ov40_02236968: ; 0x02236968
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _02236980
	cmp r0, #1
	beq _022369F6
	b _02236A4E
_02236980:
	ldr r0, _02236A54 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020879E0
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #1
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _022369D8
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x4f
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add r0, r5, #0
	bl ov40_02236F38
	add r0, r5, #0
	mov r1, #1
	bl ov40_022368EC
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022369D8:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02236A4E
_022369F6:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _02236A32
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r5, #0
	mov r1, #6
	bl ov40_0222BF80
	mov r1, #0x11
	add r0, r5, #0
	lsl r1, r1, #4
	bl ov40_02237030
_02236A32:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02236A4E:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02236A54: .word 0x000006F4
	thumb_func_end ov40_02236968

	thumb_func_start ov40_02236A58
ov40_02236A58: ; 0x02236A58
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0xcd
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_02236A58

	thumb_func_start ov40_02236A70
ov40_02236A70: ; 0x02236A70
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02236A8A
	add sp, #0x10
	mov r0, #0
	pop {r3, r4, r5, pc}
_02236A8A:
	ldr r0, [r4, #8]
	cmp r0, #7
	bls _02236A92
	b _02236C48
_02236A92:
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02236A9E: ; jump table
	.short _02236AAE - _02236A9E - 2 ; case 0
	.short _02236ACC - _02236A9E - 2 ; case 1
	.short _02236B18 - _02236A9E - 2 ; case 2
	.short _02236B5E - _02236A9E - 2 ; case 3
	.short _02236B62 - _02236A9E - 2 ; case 4
	.short _02236BA4 - _02236A9E - 2 ; case 5
	.short _02236BCE - _02236A9E - 2 ; case 6
	.short _02236C26 - _02236A9E - 2 ; case 7
_02236AAE:
	add r0, r4, #0
	bl ov40_02236FE0
	ldr r0, _02236C58 ; =0x000006F4
	mov r1, #0
	ldr r0, [r4, r0]
	bl sub_020879E0
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02236ACC:
	mov r2, #8
	mov r1, #0x69
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #8]
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	bl ov40_0222D980
	add r0, r4, #0
	bl ov40_02237564
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02237410
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_022371A0
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02236C50
_02236B18:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02236B40
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02236B40:
	ldr r0, [r4, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02236C50
_02236B5E:
	add r0, r0, #1
	str r0, [r4, #8]
_02236B62:
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r1, #0x12
	add r0, r4, #0
	lsl r1, r1, #4
	bl ov40_0222DED0
	ldr r0, _02236C5C ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02236C50
_02236BA4:
	add r0, r4, #0
	bl ov40_0223D540
	mov r1, #0x1a
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0xe
	str r1, [sp]
	lsl r2, r2, #6
	ldr r1, [r5, r2]
	add r2, r2, #4
	ldr r2, [r5, r2]
	ldr r3, [r5]
	bl ov39_02227420
	cmp r0, #1
	bne _02236C50
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02236C50
_02236BCE:
	add r0, r4, #0
	bl ov40_0222DFB0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #0xc
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _02236C5C ; =0x0000057D
	bne _02236C02
	mov r1, #0
	bl StopSE
	ldr r3, [sp, #0xc]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #2
	bl ov40_02230CDC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02236C50
_02236C02:
	mov r1, #0
	bl StopSE
	add r0, r4, #0
	mov r1, #0x25 ; SCORE_EVENT_UPLOADED_PC_BOX_RECORDS
	bl ov40_0222FB28
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222DD8C
	ldr r0, _02236C60 ; =0x00000577
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02236C50
_02236C26:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02236C50
_02236C48:
	add r0, r4, #0
	mov r1, #0xa
	bl ov40_0222BF80
_02236C50:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_02236C58: .word 0x000006F4
_02236C5C: .word 0x0000057D
_02236C60: .word 0x00000577
	thumb_func_end ov40_02236A70

	thumb_func_start ov40_02236C64
ov40_02236C64: ; 0x02236C64
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _02236C80
	cmp r0, #1
	beq _02236C9E
	cmp r0, #2
	beq _02236D04
	b _02236D52
_02236C80:
	ldr r0, _02236D58 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020879E0
	add r0, r5, #0
	bl ov40_02236FE0
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02236C9E:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #1
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _02236CE6
	add r0, r5, #0
	mov r1, #0
	bl ov40_022368EC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x4d
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02236CE6:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02236D52
_02236D04:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _02236D36
	ldr r1, _02236D5C ; =0x0000010E
	add r0, r5, #0
	bl ov40_02237030
	add r0, r5, #0
	mov r1, #3
	bl ov40_0222BF80
_02236D36:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02236D52:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02236D58: .word 0x000006F4
_02236D5C: .word 0x0000010E
	thumb_func_end ov40_02236C64

	thumb_func_start ov40_02236D60
ov40_02236D60: ; 0x02236D60
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02236D7C
	cmp r1, #1
	beq _02236DC6
	cmp r1, #2
	beq _02236E0C
	b _02236E12
_02236D7C:
	mov r2, #8
	mov r1, #0x69
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #8]
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	bl ov40_0222D980
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02237564
	add r0, r5, #0
	bl ov40_02237410
	add r0, r5, #0
	bl ov40_022371A0
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02236DC6:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #1
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02236DEE
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02236DEE:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02236E12
_02236E0C:
	mov r1, #0xa
	bl ov40_0222BF80
_02236E12:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov40_02236D60

	thumb_func_start ov40_02236E18
ov40_02236E18: ; 0x02236E18
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02236E34
	cmp r1, #1
	beq _02236E60
	cmp r1, #2
	beq _02236EA6
	b _02236EAC
_02236E34:
	bl ov40_02236FE0
	mov r2, #8
	mov r1, #0x69
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #8]
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	bl ov40_0222D980
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02236E60:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #1
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02236E88
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02236E88:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02236EAC
_02236EA6:
	mov r1, #0xd
	bl ov40_0222BF80
_02236EAC:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02236E18

	thumb_func_start ov40_02236EB4
ov40_02236EB4: ; 0x02236EB4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	str r0, [sp, #0x14]
	mov r0, #0
	str r0, [sp, #0x18]
	mov r1, #0x86
	ldr r6, _02236F2C ; =0x00000101
	ldr r0, [sp, #0x14]
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	add r0, r6, #0
	add r0, #0xb3
	ldr r5, _02236F30 ; =ov40_022452B4
	ldr r7, _02236F34 ; =ov40_02245290
	add r4, r1, r0
_02236ED2:
	add r0, r4, #0
	bl InitWindow
	ldrb r0, [r5, #1]
	add r1, r4, #0
	mov r2, #2
	str r0, [sp]
	ldrb r0, [r5, #2]
	str r0, [sp, #4]
	ldrb r0, [r5, #3]
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldrb r3, [r5]
	ldr r0, [r0, #0x24]
	bl AddWindowParameterized
	ldr r1, [r7]
	add r0, r4, #0
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FillWindowPixelBuffer
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	ldrb r1, [r5, #2]
	ldrb r0, [r5, #3]
	add r4, #0x10
	add r5, r5, #4
	mul r0, r1
	add r6, r6, r0
	ldr r0, [sp, #0x18]
	add r7, r7, #4
	add r0, r0, #1
	str r0, [sp, #0x18]
	cmp r0, #3
	blt _02236ED2
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_02236F2C: .word 0x00000101
_02236F30: .word ov40_022452B4
_02236F34: .word ov40_02245290
	thumb_func_end ov40_02236EB4

	thumb_func_start ov40_02236F38
ov40_02236F38: ; 0x02236F38
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #0x14]
	ldr r1, [r0, r1]
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r5, _02236FD8 ; =ov40_022452DC
	mov r6, #1
	mov r7, #0
	add r4, r1, r0
_02236F50:
	add r0, r4, #0
	bl InitWindow
	ldrb r0, [r5, #1]
	add r1, r4, #0
	mov r2, #6
	str r0, [sp]
	ldrb r0, [r5, #2]
	str r0, [sp, #4]
	ldrb r0, [r5, #3]
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldrb r3, [r5]
	ldr r0, [r0, #0x24]
	bl AddWindowParameterized
	ldr r0, [sp, #0x14]
	add r1, r7, #0
	ldr r0, [r0, #0x48]
	add r1, #0x3c
	bl NewString_ReadMsgData
	str r0, [sp, #0x18]
	ldr r1, [sp, #0x18]
	add r0, r4, #0
	bl ov40_022306C0
	str r0, [sp, #0x1c]
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02236FDC ; =0x000F0D00
	ldr r2, [sp, #0x18]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x1c]
	add r0, r4, #0
	mov r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x18]
	bl String_Delete
	ldrb r1, [r5, #2]
	ldrb r0, [r5, #3]
	add r7, r7, #1
	add r4, #0x10
	mul r0, r1
	add r6, r6, r0
	add r5, r5, #4
	cmp r7, #6
	blo _02236F50
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02236FD8: .word ov40_022452DC
_02236FDC: .word 0x000F0D00
	thumb_func_end ov40_02236F38

	thumb_func_start ov40_02236FE0
ov40_02236FE0: ; 0x02236FE0
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x8d
	lsl r0, r0, #2
	mov r4, #0
	add r5, r1, r0
_02236FF0:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #6
	blo _02236FF0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02236FE0

	thumb_func_start ov40_02237008
ov40_02237008: ; 0x02237008
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x6d
	lsl r0, r0, #2
	mov r4, #0
	add r5, r1, r0
_02237018:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #3
	blt _02237018
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02237008

	thumb_func_start ov40_02237030
ov40_02237030: ; 0x02237030
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r5, [r0, r2]
	mov r6, #0x75
	ldr r0, [r0, #0x48]
	lsl r6, r6, #2
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, r6
	mov r1, #0xcc
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02237078 ; =0x000F0D00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, r6
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, r6
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_02237078: .word 0x000F0D00
	thumb_func_end ov40_02237030

	thumb_func_start ov40_0223707C
ov40_0223707C: ; 0x0223707C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	mov r1, #0xe
	lsl r1, r1, #6
	ldr r1, [r4, r1]
	ldr r0, [r5, #0x48]
	add r1, #0x1c
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r6, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r7, r0, #0
	mov r0, #0x6d
	bl ov40_0222DAB0
	ldr r1, _0223713C ; =0x000004D4
	str r0, [sp, #0x14]
	ldr r1, [r5, r1]
	add r0, r6, #0
	lsl r1, r1, #2
	add r2, r4, r1
	mov r1, #0xe3
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	bl CopyU16ArrayToString
	add r0, r5, #0
	add r1, r6, #0
	bl ov40_02230DCC
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r1, #0
	ldr r0, [sp, #0x14]
	add r2, r6, #0
	add r3, r1, #0
	bl BufferString
	ldr r0, [sp, #0x14]
	ldr r2, [sp, #0x10]
	add r1, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0x75
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0xcc
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02237140 ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	mov r0, #0x75
	lsl r0, r0, #2
	add r0, r4, r0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	mov r0, #0x75
	lsl r0, r0, #2
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	ldr r0, [sp, #0x14]
	bl MessageFormat_Delete
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223713C: .word 0x000004D4
_02237140: .word 0x000F0D00
	thumb_func_end ov40_0223707C

	thumb_func_start ov40_02237144
ov40_02237144: ; 0x02237144
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r5, [r0, r1]
	mov r6, #0x71
	mov r0, #0xff
	mov r1, #0x6d
	lsl r6, r6, #2
	bl String_New
	add r1, r5, #4
	add r4, r0, #0
	bl CopyU16ArrayToString
	add r0, r5, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, r6
	add r1, r4, #0
	bl ov40_022306C0
	add r3, r0, #0
	mov r0, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223719C ; =0x000F0100
	mov r1, #0
	str r0, [sp, #8]
	add r0, r5, r6
	add r2, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, r6
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0223719C: .word 0x000F0100
	thumb_func_end ov40_02237144

	thumb_func_start ov40_022371A0
ov40_022371A0: ; 0x022371A0
	push {r4, r5, r6, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x6d
	lsl r0, r0, #2
	ldr r5, _022371D0 ; =ov40_02245290
	mov r6, #0
	add r4, r1, r0
_022371B2:
	ldr r1, [r5]
	add r0, r4, #0
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl FillWindowPixelBuffer
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add r6, r6, #1
	add r4, #0x10
	add r5, r5, #4
	cmp r6, #2
	blt _022371B2
	pop {r4, r5, r6, pc}
	.balign 4, 0
_022371D0: .word ov40_02245290
	thumb_func_end ov40_022371A0

	thumb_func_start ov40_022371D4
ov40_022371D4: ; 0x022371D4
	and r0, r1
	cmp r1, r0
	bne _022371DE
	mov r0, #1
	bx lr
_022371DE:
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov40_022371D4

	thumb_func_start ov40_022371E4
ov40_022371E4: ; 0x022371E4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x1fc
	sub sp, #0x14
	add r5, r1, #0
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r7, #0x6d
	lsl r7, r7, #2
	add r0, r4, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	lsl r0, r5, #1
	add r0, r4, r0
	ldrh r6, [r0, #0x2c]
	cmp r6, #0
	bne _02237214
	add r0, r4, r7
	bl ScheduleWindowCopyToVram
	add sp, #0x1fc
	add sp, #0x14
	pop {r3, r4, r5, r6, r7, pc}
_02237214:
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r2, r7, #0
	sub r2, #0x5c
	add r5, r0, #0
	ldr r0, [r4, r2]
	add r2, #0x58
	ldr r2, [r4, r2]
	mov r1, #1
	lsl r1, r2
	bl ov40_022371D4
	cmp r0, #1
	bne _02237238
	add r6, r7, #0
	add r6, #0x3a
_02237238:
	add r0, r6, #0
	mov r1, #0x6d
	add r2, sp, #0x10
	bl GetSpeciesNameIntoArray
	add r0, r5, #0
	add r1, sp, #0x10
	bl CopyU16ArrayToString
	add r0, r4, r7
	add r1, r5, #0
	bl ov40_022306C0
	add r3, r0, #0
	mov r0, #6
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02237280 ; =0x000F0D00
	mov r1, #0
	str r0, [sp, #8]
	add r0, r4, r7
	add r2, r5, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, r7
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	bl String_Delete
	add sp, #0x1fc
	add sp, #0x14
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02237280: .word 0x000F0D00
	thumb_func_end ov40_022371E4

	thumb_func_start ov40_02237284
ov40_02237284: ; 0x02237284
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x60
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r4, [r0, #0x28]
	str r1, [sp, #0x24]
	ldr r1, [r0, #0x18]
	str r1, [sp, #0x20]
	ldr r1, [r0, #0x1c]
	str r1, [sp, #0x1c]
	bl sub_02074490
	mov r1, #0x14
	str r1, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #3
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, _022373E0 ; =0x000186A0
	ldr r2, [sp, #0x20]
	str r0, [sp, #0x14]
	ldr r3, [sp, #0x1c]
	add r0, r4, #0
	mov r1, #2
	bl SpriteSystem_LoadPaletteBuffer
	bl sub_0207449C
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _022373E0 ; =0x000186A0
	ldr r1, [sp, #0x1c]
	str r0, [sp, #4]
	ldr r0, [sp, #0x20]
	mov r2, #0x14
	bl SpriteSystem_LoadCellResObj
	bl sub_020744A8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _022373E0 ; =0x000186A0
	ldr r1, [sp, #0x1c]
	str r0, [sp, #4]
	ldr r0, [sp, #0x20]
	mov r2, #0x14
	bl SpriteSystem_LoadAnimResObj
	ldr r7, [sp, #0x24]
	mov r4, #0
	add r5, r7, #0
_022372F6:
	ldr r0, [sp, #0x24]
	ldrh r6, [r7, #0x2c]
	add r1, r0, r4
	mov r0, #0x57
	lsl r0, r0, #2
	ldrb r0, [r1, r0]
	ldr r1, [sp, #0x24]
	str r0, [sp, #0x18]
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #1
	lsl r1, r4
	bl ov40_022371D4
	str r0, [sp, #0x28]
	cmp r6, #0
	beq _022373D2
	ldr r1, [sp, #0x28]
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	bl GetMonIconNaixEx
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _022373E0 ; =0x000186A0
	ldr r1, [sp, #0x1c]
	add r0, r4, r0
	str r0, [sp, #8]
	ldr r0, [sp, #0x20]
	mov r2, #0x14
	bl SpriteSystem_LoadCharResObjAtEndWithHardwareMappingType
	add r0, r4, #0
	mov r1, #6
	bl _s32_div_f
	add r2, r1, #0
	mov r0, #0x18
	mul r2, r0
	add r2, #0x6e
	add r0, sp, #0x2c
	strh r2, [r0]
	add r0, r4, #0
	mov r1, #6
	bl _s32_div_f
	mov r1, #0x16
	mul r1, r0
	add r1, #0x30
	add r0, sp, #0x2c
	strh r1, [r0, #2]
	mov r1, #0
	strh r1, [r0, #4]
	strh r1, [r0, #6]
	add r0, r1, #0
	str r0, [sp, #0x34]
	str r0, [sp, #0x38]
	mov r0, #1
	str r0, [sp, #0x3c]
	add r0, r1, #0
	str r0, [sp, #0x58]
	str r0, [sp, #0x5c]
	ldr r0, _022373E0 ; =0x000186A0
	add r2, sp, #0x2c
	add r0, r4, r0
	str r0, [sp, #0x40]
	ldr r0, _022373E0 ; =0x000186A0
	str r0, [sp, #0x44]
	str r0, [sp, #0x48]
	str r0, [sp, #0x4c]
	sub r0, r1, #1
	str r0, [sp, #0x50]
	sub r0, r1, #1
	str r0, [sp, #0x54]
	ldr r0, [sp, #0x20]
	ldr r1, [sp, #0x1c]
	bl SpriteSystem_NewSprite
	mov r1, #0xad
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r1, [sp, #0x18]
	ldr r2, [sp, #0x28]
	add r0, r6, #0
	bl GetMonIconPaletteEx
	add r1, r0, #0
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r1, #4
	bl ManagedSprite_SetPaletteOverrideOffset
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetAnim
	mov r0, #0xad
	lsl r0, r0, #2
	mov r1, #0x1e
	ldr r0, [r5, r0]
	sub r1, r1, r4
	bl ManagedSprite_SetDrawPriority
_022373D2:
	add r4, r4, #1
	add r7, r7, #2
	add r5, r5, #4
	cmp r4, #0x1e
	blt _022372F6
	add sp, #0x60
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_022373E0: .word 0x000186A0
	thumb_func_end ov40_02237284

	thumb_func_start ov40_022373E4
ov40_022373E4: ; 0x022373E4
	push {r3, r4, r5, r6, r7, lr}
	add r7, r1, #0
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r6, #0
	add r5, r4, #0
_022373F2:
	ldrh r0, [r4, #0x2c]
	cmp r0, #0
	beq _02237404
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r7, #0
	bl ManagedSprite_SetDrawFlag
_02237404:
	add r6, r6, #1
	add r4, r4, #2
	add r5, r5, #4
	cmp r6, #0x1e
	blt _022373F2
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov40_022373E4

	thumb_func_start ov40_02237410
ov40_02237410: ; 0x02237410
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r7, r0]
	ldr r0, [r7, #0x1c]
	ldr r1, _02237470 ; =0x000186A0
	bl SpriteManager_UnloadPlttObjById
	ldr r0, [r7, #0x1c]
	ldr r1, _02237470 ; =0x000186A0
	bl SpriteManager_UnloadCellObjById
	ldr r0, [r7, #0x1c]
	ldr r1, _02237470 ; =0x000186A0
	bl SpriteManager_UnloadAnimObjById
	mov r6, #0
	add r5, r4, #0
_02237436:
	ldrh r0, [r4, #0x2c]
	cmp r0, #0
	beq _02237462
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _02237462
	ldr r1, _02237470 ; =0x000186A0
	ldr r0, [r7, #0x1c]
	add r1, r6, r1
	bl SpriteManager_UnloadCharObjById
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Sprite_DeleteAndFreeResources
	mov r0, #0xad
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r5, r0]
_02237462:
	add r6, r6, #1
	add r4, r4, #2
	add r5, r5, #4
	cmp r6, #0x1e
	blt _02237436
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02237470: .word 0x000186A0
	thumb_func_end ov40_02237410

	thumb_func_start ov40_02237474
ov40_02237474: ; 0x02237474
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #0x10]
	ldr r4, [r0, r1]
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r2, [r4, r0]
	lsl r1, r2, #2
	add r1, r4, r1
	add r3, r1, #0
	add r3, #0xe0
	ldr r3, [r3]
	add r5, r4, r2
	str r3, [sp, #0x14]
	add r3, r0, #0
	sub r3, #0x54
	ldrb r7, [r5, r3]
	lsl r3, r2, #1
	add r3, r4, r3
	ldrh r5, [r3, #0x2c]
	ldr r6, [r1, #0x68]
	cmp r5, #0
	bne _022374B2
	mov r0, #0xcb
	mov r1, #0
	lsl r0, r0, #2
	add sp, #0x34
	str r1, [r4, r0]
	pop {r4, r5, r6, r7, pc}
_022374B2:
	sub r0, #0x58
	mov r1, #1
	ldr r0, [r4, r0]
	lsl r1, r2
	bl ov40_022371D4
	cmp r0, #1
	bne _022374D0
	ldr r0, _02237540 ; =0x000001EA
	cmp r5, r0
	bne _022374CC
	mov r7, #1
	b _022374CE
_022374CC:
	mov r7, #0
_022374CE:
	ldr r5, _02237544 ; =0x000001EE
_022374D0:
	add r0, r5, #0
	mov r1, #0x6d
	bl AllocAndLoadMonPersonal
	str r0, [sp, #0x18]
	add r0, r5, #0
	add r1, r6, #0
	bl GetGenderBySpeciesAndPersonality
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x14]
	add r1, r6, #0
	bl CalcShininessByOtIdAndPersonality
	lsl r3, r7, #0x18
	str r0, [sp, #0x20]
	ldr r1, [sp, #0x1c]
	add r0, r5, #0
	mov r2, #2
	lsr r3, r3, #0x18
	str r6, [sp]
	bl GetMonPicHeightBySpeciesGenderForm
	ldr r0, [sp, #0x20]
	ldr r2, [sp, #0x1c]
	str r0, [sp]
	lsl r0, r7, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	add r0, sp, #0x24
	add r1, r5, #0
	mov r3, #2
	str r6, [sp, #8]
	bl GetMonSpriteCharAndPlttNarcIdsEx
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x10]
	add r1, sp, #0x24
	ldr r0, [r0, #0x64]
	mov r2, #0x2a
	mov r3, #0x5b
	bl PokepicManager_CreatePokepic
	mov r1, #0xcb
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [sp, #0x18]
	bl FreeMonPersonal
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_02237540: .word 0x000001EA
_02237544: .word 0x000001EE
	thumb_func_end ov40_02237474

	thumb_func_start ov40_02237548
ov40_02237548: ; 0x02237548
	push {r3, lr}
	add r2, r1, #0
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0xcb
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r0, #0
	beq _02237562
	mov r1, #6
	bl Pokepic_SetAttr
_02237562:
	pop {r3, pc}
	thumb_func_end ov40_02237548

	thumb_func_start ov40_02237564
ov40_02237564: ; 0x02237564
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0xcb
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r0, #0
	beq _0223757A
	bl Pokepic_Delete
_0223757A:
	pop {r3, pc}
	thumb_func_end ov40_02237564

	thumb_func_start ov40_0223757C
ov40_0223757C: ; 0x0223757C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	sub r0, #0x30
	ldr r0, [r5, r0]
	bl SaveArray_PCStorage_Get
	ldr r0, _0223763C ; =0x0000017A
	ldrb r1, [r4, r0]
	cmp r1, #0x10
	blo _022375A0
	cmp r1, #0x18
	bhs _022375A0
	mov r1, #0
	strb r1, [r4, r0]
_022375A0:
	ldr r0, _0223763C ; =0x0000017A
	ldrb r1, [r4, r0]
	cmp r1, #0x28
	blo _022375AC
	mov r1, #0
	strb r1, [r4, r0]
_022375AC:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r1, _0223763C ; =0x0000017A
	ldr r0, [r5, #0x14]
	ldrb r2, [r4, r1]
	mov r3, #3
	lsl r1, r2, #1
	add r1, r2, r1
	ldr r2, [r5, #0x24]
	add r1, #0x8a
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r1, _0223763C ; =0x0000017A
	ldr r0, [r5, #0x14]
	ldrb r2, [r4, r1]
	mov r3, #3
	lsl r1, r2, #1
	add r1, r2, r1
	ldr r2, [r5, #0x24]
	add r1, #0x8c
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #0x40
	str r0, [sp, #4]
	mov r0, #0xc0
	mov r1, #0xbf
	str r0, [sp, #8]
	add r2, r1, #0
	str r0, [sp, #0xc]
	add r2, #0xbb
	ldrb r3, [r4, r2]
	ldr r0, [r5, #0x28]
	lsl r2, r3, #1
	add r2, r3, r2
	add r2, #0x8b
	mov r3, #0x6d
	bl PaletteData_LoadFromNarc
	add r0, r5, #0
	bl ov40_02237474
	add r0, r5, #0
	bl ov40_02237284
	mov r1, #0x1b
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r5, #0
	bl ov40_022371E4
	add r0, r5, #0
	bl ov40_02237144
	ldr r1, _02237640 ; =0x0000010E
	add r0, r5, #0
	bl ov40_02237030
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_0223763C: .word 0x0000017A
_02237640: .word 0x0000010E
	thumb_func_end ov40_0223757C

	thumb_func_start ov40_02237644
ov40_02237644: ; 0x02237644
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	sub r0, #0x30
	ldr r0, [r5, r0]
	bl SaveArray_PCStorage_Get
	ldr r1, _022376F8 ; =0x0000017A
	ldrb r2, [r4, r1]
	cmp r2, #0x10
	blo _02237668
	cmp r2, #0x18
	bhs _02237668
	mov r2, #0
	strb r2, [r4, r1]
_02237668:
	ldr r1, _022376F8 ; =0x0000017A
	ldrb r1, [r4, r1]
	cmp r1, #0x18
	blo _02237684
	cmp r1, #0x20
	bhs _02237684
	sub r1, #0x18
	bl PCStorage_IsBonusWallpaperUnlocked
	cmp r0, #0
	bne _02237684
	ldr r0, _022376F8 ; =0x0000017A
	mov r1, #0
	strb r1, [r4, r0]
_02237684:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r1, _022376F8 ; =0x0000017A
	ldr r0, [r5, #0x14]
	ldrb r2, [r4, r1]
	mov r3, #3
	lsl r1, r2, #1
	add r1, r2, r1
	ldr r2, [r5, #0x24]
	add r1, #0x8a
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r1, _022376F8 ; =0x0000017A
	ldr r0, [r5, #0x14]
	ldrb r2, [r4, r1]
	mov r3, #3
	lsl r1, r2, #1
	add r1, r2, r1
	ldr r2, [r5, #0x24]
	add r1, #0x8c
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #0x40
	str r0, [sp, #4]
	mov r0, #0xc0
	mov r1, #0xbf
	str r0, [sp, #8]
	add r2, r1, #0
	str r0, [sp, #0xc]
	add r2, #0xbb
	ldrb r3, [r4, r2]
	ldr r0, [r5, #0x28]
	lsl r2, r3, #1
	add r2, r3, r2
	add r2, #0x8b
	mov r3, #0x6d
	bl PaletteData_LoadFromNarc
	add r0, r5, #0
	bl ov40_02237474
	add r0, r5, #0
	bl ov40_02237284
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022376F8: .word 0x0000017A
	thumb_func_end ov40_02237644

	thumb_func_start ov40_022376FC
ov40_022376FC: ; 0x022376FC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02237718
	cmp r1, #1
	beq _02237792
	cmp r1, #2
	beq _022377D6
	b _02237814
_02237718:
	mov r1, #2
	bl ov40_0222C710
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02236EB4
	add r0, r5, #0
	bl ov40_0223757C
	add r0, r5, #0
	mov r1, #1
	bl ov40_02237548
	add r0, r5, #0
	mov r1, #0
	bl ov40_022373E4
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x4d
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02237814
_02237792:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	mov r2, #0
	add r1, r4, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02237814
	add r0, r5, #0
	mov r1, #0
	bl ov40_02237548
	add r0, r5, #0
	mov r1, #1
	bl ov40_022373E4
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, _0223781C ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02237814
_022377D6:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _022377F8
	mov r0, #0x33
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	add r0, #0x14
	str r1, [r4, r0]
	add r0, r5, #0
	mov r1, #3
	bl ov40_0222BF80
_022377F8:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02237814:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_0223781C: .word 0x04000050
	thumb_func_end ov40_022376FC

	thumb_func_start ov40_02237820
ov40_02237820: ; 0x02237820
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0xd1
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_02237820

	thumb_func_start ov40_02237838
ov40_02237838: ; 0x02237838
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r7, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223784E
	cmp r1, #1
	beq _02237888
	b _022378DE
_0223784E:
	bl ov40_02237410
	add r0, r5, #0
	bl ov40_02237564
	add r0, r5, #0
	bl ov40_02237008
	add r0, r5, #0
	bl ov40_02236534
	ldr r0, _02237974 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020878B0
	ldr r0, _02237974 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020879E0
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02237970
_02237888:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02237970
	mov r6, #0
	add r4, r7, #0
_02237894:
	mov r0, #0x33
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #5
	blt _02237894
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r7, r0
	bl ov40_0222DAA8
	add r0, r5, #0
	bl ov40_0222D88C
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02237970
_022378DE:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r7, r0
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02237938
	add r0, r5, #0
	bl ov40_0222DD08
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r7, r0
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	mov r0, #0xe1
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	bl sub_020314BC
	add r0, r7, #0
	bl Heap_Free
	b _02237970
_02237938:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r7, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #1
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r7, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02237970:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02237974: .word 0x000006F4
	thumb_func_end ov40_02237838

	thumb_func_start ov40_02237978
ov40_02237978: ; 0x02237978
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02237994
	cmp r1, #1
	beq _02237A1E
	cmp r1, #2
	beq _02237A5A
	b _02237A98
_02237994:
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222C710
	add r0, r5, #0
	bl ov40_02236EB4
	ldr r1, _02237AA0 ; =0x00000113
	add r0, r5, #0
	bl ov40_02237030
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x4f
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add r0, r5, #0
	bl ov40_02236F38
	add r0, r5, #0
	mov r1, #1
	bl ov40_022368EC
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02237A98
_02237A1E:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	mov r2, #0
	add r1, r4, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02237A98
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, _02237AA4 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02237A98
_02237A5A:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02237A7C
	mov r0, #0xce
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	add r0, #0xc
	str r1, [r4, r0]
	add r0, r5, #0
	mov r1, #3
	bl ov40_0222BF80
_02237A7C:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r4, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02237A98:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_02237AA0: .word 0x00000113
_02237AA4: .word 0x04000050
	thumb_func_end ov40_02237978

	thumb_func_start ov40_02237AA8
ov40_02237AA8: ; 0x02237AA8
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0xce
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_02237AA8

	thumb_func_start ov40_02237AC0
ov40_02237AC0: ; 0x02237AC0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #0x14]
	ldr r0, [r0, r1]
	ldr r1, _02237B70 ; =ov40_02245268
	ldr r5, _02237B74 ; =ov40_02245274
	ldr r2, [r1, #0x14]
	ldr r1, [r1, #0x18]
	mov r7, #1
	str r1, [sp, #0x24]
	mov r1, #0
	str r1, [sp, #0x18]
	mov r1, #0x8d
	lsl r1, r1, #2
	add r6, sp, #0x20
	str r2, [sp, #0x20]
	add r4, r0, r1
_02237AE6:
	add r0, r4, #0
	bl InitWindow
	ldrb r0, [r5, #1]
	add r1, r4, #0
	mov r2, #6
	str r0, [sp]
	ldrb r0, [r5, #2]
	str r0, [sp, #4]
	ldrb r0, [r5, #3]
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldrb r3, [r5]
	ldr r0, [r0, #0x24]
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	ldr r1, [r6]
	ldr r0, [r0, #0x48]
	bl NewString_ReadMsgData
	str r0, [sp, #0x1c]
	ldr r1, [sp, #0x1c]
	add r0, r4, #0
	bl ov40_022306C0
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02237B78 ; =0x000F0D00
	ldr r2, [sp, #0x1c]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	ldrb r1, [r5, #2]
	ldrb r0, [r5, #3]
	mul r0, r1
	add r7, r7, r0
	ldr r0, [sp, #0x1c]
	bl String_Delete
	ldr r0, [sp, #0x18]
	add r4, #0x10
	add r0, r0, #1
	add r5, r5, #4
	add r6, r6, #4
	str r0, [sp, #0x18]
	cmp r0, #2
	blt _02237AE6
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02237B70: .word ov40_02245268
_02237B74: .word ov40_02245274
_02237B78: .word 0x000F0D00
	thumb_func_end ov40_02237AC0

	thumb_func_start ov40_02237B7C
ov40_02237B7C: ; 0x02237B7C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	mov r6, #0x8d
	add r7, r1, #0
	ldr r4, [r5, r0]
	lsl r6, r6, #2
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	add r1, r7, #0
	bl NewString_ReadMsgData
	add r5, r0, #0
	add r0, r4, r6
	add r1, r5, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02237BD0 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02237BD0: .word 0x000F0D00
	thumb_func_end ov40_02237B7C

	thumb_func_start ov40_02237BD4
ov40_02237BD4: ; 0x02237BD4
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	mov r6, #0x8d
	ldr r4, [r5, r0]
	lsl r6, r6, #2
	add r0, r4, r6
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, r6
	mov r3, #0xc
	bl AddWindowParameterized
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x22
	bl NewString_ReadMsgData
	add r5, r0, #0
	mov r0, #0
	add r1, r5, #0
	add r2, r0, #0
	bl FontID_String_GetWidthMultiline
	mov r1, #0x40
	sub r0, r1, r0
	mov r1, #0
	lsr r3, r0, #1
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02237C50 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	bl String_Delete
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_02237C50: .word 0x000F0D00
	thumb_func_end ov40_02237BD4

	thumb_func_start ov40_02237C54
ov40_02237C54: ; 0x02237C54
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r0, #0x8d
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	mov r0, #0x8d
	lsl r0, r0, #2
	add r0, r4, r0
	bl RemoveWindow
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02237C54

	thumb_func_start ov40_02237C74
ov40_02237C74: ; 0x02237C74
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x8d
	lsl r0, r0, #2
	mov r4, #0
	add r5, r1, r0
_02237C84:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #2
	blt _02237C84
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02237C74

	thumb_func_start ov40_02237C9C
ov40_02237C9C: ; 0x02237C9C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #0x14]
	ldr r0, [r0, r1]
	mov r1, #0x6d
	str r0, [sp, #0x24]
	mov r0, #1
	str r0, [sp, #0x20]
	ldr r0, [sp, #0x24]
	lsl r1, r1, #2
	ldr r5, _02237D60 ; =ov40_02245268
	mov r7, #0
	add r4, r0, r1
_02237CBA:
	add r0, r4, #0
	bl InitWindow
	ldrb r0, [r5, #1]
	add r1, r4, #0
	mov r2, #2
	str r0, [sp]
	ldrb r0, [r5, #2]
	str r0, [sp, #4]
	ldrb r0, [r5, #3]
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x20]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldrb r3, [r5]
	ldr r0, [r0, #0x24]
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	cmp r7, #0
	bne _02237D16
	mov r1, #0xe
	ldr r0, [sp, #0x14]
	ldr r2, [sp, #0x24]
	lsl r1, r1, #6
	ldr r2, [r2, r1]
	ldr r1, _02237D64 ; =0x00000136
	ldr r0, [r0, #0x48]
	add r1, r2, r1
	bl NewString_ReadMsgData
	add r6, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	bl ov40_022306C0
	str r0, [sp, #0x1c]
	mov r0, #0
	str r0, [sp, #0x18]
_02237D16:
	cmp r6, #0
	beq _02237D3C
	ldr r0, [sp, #0x18]
	ldr r3, [sp, #0x1c]
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02237D68 ; =0x000F0D00
	mov r1, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	add r2, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
_02237D3C:
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	ldrb r1, [r5, #2]
	ldrb r0, [r5, #3]
	add r7, r7, #1
	add r2, r1, #0
	mul r2, r0
	ldr r0, [sp, #0x20]
	add r4, #0x10
	add r0, r0, r2
	add r5, r5, #4
	str r0, [sp, #0x20]
	cmp r7, #1
	blo _02237CBA
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02237D60: .word ov40_02245268
_02237D64: .word 0x00000136
_02237D68: .word 0x000F0D00
	thumb_func_end ov40_02237C9C

	thumb_func_start ov40_02237D6C
ov40_02237D6C: ; 0x02237D6C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x6d
	lsl r0, r0, #2
	mov r4, #0
	add r5, r1, r0
_02237D7C:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #1
	blo _02237D7C
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02237D6C

	thumb_func_start ov40_02237D94
ov40_02237D94: ; 0x02237D94
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02237DAE
	add sp, #0x14
	mov r0, #0
	pop {r3, r4, r5, r6, pc}
_02237DAE:
	ldr r0, [r4, #8]
	cmp r0, #8
	bls _02237DB6
	b _02238140
_02237DB6:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02237DC2: ; jump table
	.short _02237DD4 - _02237DC2 - 2 ; case 0
	.short _02237E1A - _02237DC2 - 2 ; case 1
	.short _02237EA8 - _02237DC2 - 2 ; case 2
	.short _02237EE8 - _02237DC2 - 2 ; case 3
	.short _02237F06 - _02237DC2 - 2 ; case 4
	.short _02237FAE - _02237DC2 - 2 ; case 5
	.short _02237FEC - _02237DC2 - 2 ; case 6
	.short _0223806C - _02237DC2 - 2 ; case 7
	.short _022380B4 - _02237DC2 - 2 ; case 8
_02237DD4:
	ldr r0, _02238124 ; =0x000006F4
	mov r1, #0
	ldr r0, [r4, r0]
	bl sub_020879E0
	add r0, r4, #0
	bl ov40_02237008
	add r0, r4, #0
	bl ov40_02236FE0
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	mov r2, #8
	mov r1, #0x69
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #8]
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	bl ov40_0222D980
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02237E1A:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02237E8A
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	mov r1, #3
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	add r3, r1, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x4e
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02237E8A:
	ldr r0, [r4, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02238272
_02237EA8:
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r1, _02238128 ; =0x00000121
	add r0, r4, #0
	bl ov40_0222DED0
	ldr r0, _0223812C ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02238272
_02237EE8:
	add r0, r4, #0
	bl ov40_0223D540
	mov r1, #0xe
	lsl r1, r1, #6
	ldr r1, [r5, r1]
	bl ov39_0222748C
	cmp r0, #1
	beq _02237EFE
	b _02238272
_02237EFE:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02238272
_02237F06:
	add r0, r4, #0
	bl ov40_0222DFB0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #0x10
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _0223812C ; =0x0000057D
	bne _02237F9A
	mov r1, #0
	bl StopSE
	ldr r3, [sp, #0x10]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #3
	bl ov40_02230CDC
	mov r0, #0xe2
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r5, r0]
	ldr r0, _02238130 ; =0x00002F64
	str r1, [r5, r0]
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02236EB4
	ldr r0, _02238124 ; =0x000006F4
	mov r1, #0
	ldr r0, [r4, r0]
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020878B0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #7
	str r0, [r4, #8]
	b _02238272
_02237F9A:
	mov r1, #0
	bl StopSE
	ldr r0, _02238134 ; =0x00000577
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02238272
_02237FAE:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r0, #0xe2
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, #0
	bne _02237FE6
	ldr r0, [r4, #8]
	ldr r1, _02238138 ; =0x00000126
	add r0, r0, #1
	str r0, [r4, #8]
	mov r0, #0
	str r0, [r4, #0xc]
	add r0, r4, #0
	bl ov40_0222DED0
	b _02238272
_02237FE6:
	mov r0, #0xff
	str r0, [r4, #8]
	b _02238272
_02237FEC:
	ldr r0, [r4, #0xc]
	add r0, r0, #1
	str r0, [r4, #0xc]
	cmp r0, #0x3c
	bge _02237FFE
	bl System_GetTouchNew
	cmp r0, #1
	bne _02238082
_02237FFE:
	mov r0, #0
	str r0, [r4, #0xc]
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r0, _02238130 ; =0x00002F64
	mov r1, #0
	str r1, [r5, r0]
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02236EB4
	ldr r0, _02238124 ; =0x000006F4
	mov r1, #0
	ldr r0, [r4, r0]
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020878B0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02238272
_0223806C:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	bne _02238084
_02238082:
	b _02238272
_02238084:
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x4f
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02238272
_022380B4:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _02238104
	add r0, r4, #0
	mov r1, #2
	bl ov40_0222C710
	ldr r1, _0223813C ; =0x00000113
	add r0, r4, #0
	bl ov40_02237030
	add r0, r4, #0
	bl ov40_02236F38
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
_02238104:
	ldr r0, [r4, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02238272
	nop
_02238124: .word 0x000006F4
_02238128: .word 0x00000121
_0223812C: .word 0x0000057D
_02238130: .word 0x00002F64
_02238134: .word 0x00000577
_02238138: .word 0x00000126
_0223813C: .word 0x00000113
_02238140:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_0222DA84
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	mov r2, #0
	add r1, r5, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223823A
	add r0, r4, #0
	bl ov40_02237C9C
	add r0, r4, #0
	bl ov40_02238290
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238278 ; =0x00002EAC
	ldr r3, _0223827C ; =ov40_02245310
	add r2, r5, r0
	mov r6, #5
_0223817E:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _0223817E
	ldr r0, [r3]
	mov r1, #0xe2
	str r0, [r2]
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	ldr r0, _02238280 ; =0x00002EB0
	add r1, #0xf4
	str r2, [r5, r0]
	add r0, r4, r1
	add r1, r4, #0
	mov r2, #2
	bl ov40_0222F9E0
	ldr r0, _02238284 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F734
	ldr r3, _02238278 ; =0x00002EAC
	ldr r0, _02238284 ; =0x0000049C
	add r2, r5, r3
	sub r3, #0xa0
	add r0, r4, r0
	add r1, r4, #0
	add r3, r5, r3
	bl ov40_0222EED0
	ldr r1, _02238288 ; =0x0000047C
	add r0, r4, r1
	add r1, #0x20
	add r1, r4, r1
	bl ov40_0222FA5C
	ldr r0, _02238284 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	mov r2, #1
	bl ov40_0222F740
	ldr r0, _02238284 ; =0x0000049C
	mov r1, #0x38
	add r0, r4, r0
	mov r2, #0xb0
	bl ov40_0222F858
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02237AC0
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r3, _0223828C ; =0x000004D8
	mov r1, #0x6f
	ldr r6, [r4, r3]
	mov r3, #0x18
	mul r3, r6
	lsl r1, r1, #4
	add r3, #0x44
	lsl r3, r3, #0x10
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x10
	asr r3, r3, #0x10
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0xc
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
_0223823A:
	ldr r0, [r4, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r4, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r1, #2
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02238272:
	mov r0, #0
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_02238278: .word 0x00002EAC
_0223827C: .word ov40_02245310
_02238280: .word 0x00002EB0
_02238284: .word 0x0000049C
_02238288: .word 0x0000047C
_0223828C: .word 0x000004D8
	thumb_func_end ov40_02237D94

	thumb_func_start ov40_02238290
ov40_02238290: ; 0x02238290
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp]
	ldr r7, [r0, r1]
	mov r0, #0xe2
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	mov r6, #0
	cmp r0, #0
	ble _022382FA
	add r4, r7, #0
	add r5, r7, #0
_022382AA:
	mov r0, #0x14
	mov r1, #0x6d
	bl String_New
	ldr r1, _022382FC ; =0x00002E10
	str r0, [r4, r1]
	add r0, r1, #0
	mov r1, #0xe3
	lsl r1, r1, #2
	ldr r0, [r4, r0]
	ldr r1, [r5, r1]
	bl CopyU16ArrayToString
	ldr r1, _022382FC ; =0x00002E10
	ldr r0, [sp]
	ldr r1, [r4, r1]
	bl ov40_02230DCC
	mov r0, #0x1e
	mov r1, #0x6d
	bl String_New
	ldr r1, _02238300 ; =0x00002E0C
	str r0, [r4, r1]
	add r0, r1, #0
	mov r1, #0xe3
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	ldr r0, [r4, r0]
	add r1, #0x80
	bl CopyU16ArrayToString
	mov r0, #0xe2
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	add r6, r6, #1
	add r4, #8
	add r5, r5, #4
	cmp r6, r0
	blt _022382AA
_022382FA:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_022382FC: .word 0x00002E10
_02238300: .word 0x00002E0C
	thumb_func_end ov40_02238290

	thumb_func_start ov40_02238304
ov40_02238304: ; 0x02238304
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r6, [r0, r1]
	mov r0, #0xe2
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r4, #0
	cmp r0, #0
	ble _0223834C
	add r5, r6, #0
	add r7, r4, #0
_0223831C:
	ldr r0, _02238350 ; =0x00002E0C
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0223832C
	bl String_Delete
	ldr r0, _02238350 ; =0x00002E0C
	str r7, [r5, r0]
_0223832C:
	ldr r0, _02238354 ; =0x00002E10
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0223833E
	bl String_Delete
	ldr r0, _02238354 ; =0x00002E10
	mov r1, #0
	str r1, [r5, r0]
_0223833E:
	mov r0, #0xe2
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	add r4, r4, #1
	add r5, #8
	cmp r4, r0
	blt _0223831C
_0223834C:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02238350: .word 0x00002E0C
_02238354: .word 0x00002E10
	thumb_func_end ov40_02238304

	thumb_func_start ov40_02238358
ov40_02238358: ; 0x02238358
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, _022383B4 ; =0x00002F64
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _022383A6
	ldr r0, _022383B8 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA88
	ldr r1, _022383BC ; =0x0000049C
	add r0, r5, r1
	sub r1, #0x10
	ldrsh r1, [r5, r1]
	bl ov40_0222F5EC
	ldr r0, _022383BC ; =0x0000049C
	ldr r2, _022383C0 ; =0x00002E0C
	add r0, r5, r0
	add r1, r5, #0
	add r2, r4, r2
	bl ov40_0222EFD8
	ldr r2, _022383C4 ; =0x000004D8
	mov r0, #0x6f
	ldr r3, [r5, r2]
	mov r2, #0x18
	mul r2, r3
	lsl r0, r0, #4
	add r2, #0x44
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	mov r1, #0x10
	asr r2, r2, #0x10
	bl sub_020878EC
_022383A6:
	mov r0, #0xcf
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022383B4: .word 0x00002F64
_022383B8: .word 0x0000047C
_022383BC: .word 0x0000049C
_022383C0: .word 0x00002E0C
_022383C4: .word 0x000004D8
	thumb_func_end ov40_02238358

	thumb_func_start ov40_022383C8
ov40_022383C8: ; 0x022383C8
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _022383E6
	cmp r1, #1
	beq _022384B4
	cmp r1, #2
	bne _022383E4
	b _022384EA
_022383E4:
	b _0223852E
_022383E6:
	bl ov40_02238304
	add r0, r5, #0
	bl ov40_02237C74
	ldr r0, _02238534 ; =0x00002F64
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0223842A
	add r0, r5, #0
	bl ov40_02237D6C
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238538 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA24
	ldr r0, _0223853C ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F720
	ldr r0, _0223853C ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F920
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	b _0223844A
_0223842A:
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238540 ; =0x00002ED8
	add r1, r5, #0
	add r0, r4, r0
	bl ov40_0222E7B8
	add r0, r5, #0
	bl ov40_022361B0
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
_0223844A:
	ldr r0, _02238534 ; =0x00002F64
	mov r1, #0
	str r1, [r4, r0]
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02236EB4
	add r0, r5, #0
	mov r1, #0xff
	bl ov40_0223707C
	ldr r0, _02238544 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020878B0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022384B4:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223852E
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x4f
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223852E
_022384EA:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223852E
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222C710
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r1, _02238548 ; =0x00000113
	add r0, r5, #0
	bl ov40_02237030
	add r0, r5, #0
	bl ov40_02236F38
	add r0, r5, #0
	mov r1, #3
	bl ov40_0222BF80
_0223852E:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02238534: .word 0x00002F64
_02238538: .word 0x0000047C
_0223853C: .word 0x0000049C
_02238540: .word 0x00002ED8
_02238544: .word 0x000006F4
_02238548: .word 0x00000113
	thumb_func_end ov40_022383C8

	thumb_func_start ov40_0223854C
ov40_0223854C: ; 0x0223854C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _02238560
	b _0223871A
_02238560:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223856C: ; jump table
	.short _02238574 - _0223856C - 2 ; case 0
	.short _02238610 - _0223856C - 2 ; case 1
	.short _0223862E - _0223856C - 2 ; case 2
	.short _022386C6 - _0223856C - 2 ; case 3
_02238574:
	bl ov40_02237C74
	ldr r0, _022387FC ; =0x00002F64
	ldr r0, [r5, r0]
	cmp r0, #0
	bne _022385B2
	add r0, r4, #0
	bl ov40_02237D6C
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238800 ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA24
	ldr r0, _02238804 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F720
	ldr r0, _02238804 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F920
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	b _022385D2
_022385B2:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238808 ; =0x00002ED8
	add r1, r4, #0
	add r0, r5, r0
	bl ov40_0222E7B8
	add r0, r4, #0
	bl ov40_022361B0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
_022385D2:
	ldr r0, _0223880C ; =0x000006F4
	mov r1, #0
	ldr r0, [r4, r0]
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020878B0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02238610:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	add r1, r5, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _022386DC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022387F4
_0223862E:
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238810 ; =0x000004D4
	add r3, r5, #4
	ldr r0, [r4, r0]
	mov r2, #0x33
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0xe3
	lsl r0, r0, #2
	ldr r6, [r1, r0]
	add r6, #0x80
_02238648:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _02238648
	ldr r0, [r6]
	str r0, [r3]
	add r0, r5, #0
	bl ov40_0223655C
	add r0, r4, #0
	mov r1, #2
	bl ov40_0222C710
	add r0, r4, #0
	bl ov40_02236EB4
	add r0, r4, #0
	bl ov40_0223757C
	add r0, r4, #0
	mov r1, #0xff
	bl ov40_0223707C
	add r0, r4, #0
	mov r1, #1
	bl ov40_02237548
	add r0, r4, #0
	mov r1, #0
	bl ov40_022373E4
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x4b
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022387F4
_022386C6:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r5, r1
	add r1, r1, #4
	mov r2, #0
	add r1, r5, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	bne _022386DE
_022386DC:
	b _022387F4
_022386DE:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02237548
	add r0, r4, #0
	mov r1, #1
	bl ov40_022373E4
	add r0, r4, #0
	bl ov40_02237BD4
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, _02238814 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022387F4
_0223871A:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _022387D8
	mov r0, #0x33
	lsl r0, r0, #4
	ldr r1, [r5, r0]
	add r0, #0x14
	str r1, [r5, r0]
	add r0, r5, #0
	bl ov40_0223655C
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, _02238818 ; =0x00002F68
	str r1, [r5, r0]
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #6
	bl _s32_div_f
	ldr r3, _0223881C ; =0x00002F6C
	mov r1, #0x6f
	str r0, [r5, r3]
	sub r2, r3, #4
	ldr r6, [r5, r2]
	mov r2, #0x18
	mul r2, r6
	ldr r6, [r5, r3]
	mov r3, #0x16
	mul r3, r6
	lsl r1, r1, #4
	add r2, #0x6e
	add r3, #0x34
	lsl r2, r2, #0x10
	lsl r3, r3, #0x10
	ldr r1, [r4, r1]
	add r0, r4, #0
	asr r2, r2, #0x10
	asr r3, r3, #0x10
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0xc
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r2, [r5, r0]
	lsl r1, r2, #1
	add r1, r5, r1
	ldrh r1, [r1, #0x2c]
	cmp r1, #0
	beq _022387D0
	sub r0, #0x58
	mov r1, #1
	ldr r0, [r5, r0]
	lsl r1, r2
	bl ov40_022371D4
	cmp r0, #1
	beq _022387D0
	mov r1, #0x1b
	lsl r1, r1, #4
	ldr r2, [r5, r1]
	sub r1, #0x54
	lsl r0, r2, #1
	add r0, r5, r0
	add r2, r5, r2
	ldrh r0, [r0, #0x2c]
	ldrb r1, [r2, r1]
	bl PlayCry
_022387D0:
	add r0, r4, #0
	mov r1, #0xa
	bl ov40_0222BF80
_022387D8:
	ldr r0, [r4, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_022387F4:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_022387FC: .word 0x00002F64
_02238800: .word 0x0000047C
_02238804: .word 0x0000049C
_02238808: .word 0x00002ED8
_0223880C: .word 0x000006F4
_02238810: .word 0x000004D4
_02238814: .word 0x04000050
_02238818: .word 0x00002F68
_0223881C: .word 0x00002F6C
	thumb_func_end ov40_0223854C

	thumb_func_start ov40_02238820
ov40_02238820: ; 0x02238820
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0xd
	lsl r0, r0, #6
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_02238820

	thumb_func_start ov40_02238838
ov40_02238838: ; 0x02238838
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _02238854
	cmp r0, #1
	beq _0223889A
	cmp r0, #2
	beq _022388A6
	b _0223891E
_02238854:
	mov r2, #8
	mov r1, #0x69
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #8]
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	bl ov40_0222D980
	add r0, r5, #0
	bl ov40_02237564
	add r0, r5, #0
	bl ov40_02237410
	add r0, r5, #0
	bl ov40_022371A0
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	bl ov40_02237008
	add r0, r5, #0
	bl ov40_02237C54
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223889A:
	ldr r0, _02238A38 ; =0x00002F64
	mov r1, #0
	str r1, [r4, r0]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022388A6:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	bne _022388BE
	b _02238A30
_022388BE:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	mov r1, #3
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	add r3, r1, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x4e
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02238A30
_0223891E:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	mov r2, #0
	add r1, r4, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02238A30
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl sub_020879E0
	add r0, r5, #0
	bl ov40_02237C9C
	add r0, r5, #0
	bl ov40_02237AC0
	ldr r0, _02238A3C ; =0x0000047C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #2
	bl ov40_0222F9E0
	ldr r3, _02238A40 ; =0x00002EAC
	ldr r0, _02238A44 ; =0x0000049C
	add r2, r4, r3
	sub r3, #0xa0
	add r0, r5, r0
	add r1, r5, #0
	add r3, r4, r3
	bl ov40_0222EED0
	ldr r1, _02238A3C ; =0x0000047C
	add r0, r5, r1
	add r1, #0x20
	add r1, r5, r1
	bl ov40_0222FA5C
	ldr r0, _02238A44 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #1
	bl ov40_0222F740
	ldr r0, _02238A44 ; =0x0000049C
	mov r1, #0x38
	add r0, r5, r0
	mov r2, #0xb0
	bl ov40_0222F858
	ldr r3, _02238A48 ; =0x000004D8
	mov r1, #0x6f
	ldr r6, [r5, r3]
	mov r3, #0x18
	mul r3, r6
	lsl r1, r1, #4
	add r3, #0x44
	lsl r3, r3, #0x10
	ldr r1, [r5, r1]
	add r0, r5, #0
	mov r2, #0x10
	asr r3, r3, #0x10
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0xc
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, _02238A38 ; =0x00002F64
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _02238A10
	ldr r0, _02238A3C ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA88
	ldr r1, _02238A44 ; =0x0000049C
	add r0, r5, r1
	sub r1, #0x10
	ldrsh r1, [r5, r1]
	bl ov40_0222F5EC
	ldr r0, _02238A44 ; =0x0000049C
	ldr r2, _02238A4C ; =0x00002E0C
	add r0, r5, r0
	add r1, r5, #0
	add r2, r4, r2
	bl ov40_0222EFD8
	ldr r2, _02238A48 ; =0x000004D8
	mov r0, #0x6f
	ldr r3, [r5, r2]
	mov r2, #0x18
	mul r2, r3
	lsl r0, r0, #4
	add r2, #0x44
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	mov r1, #0x10
	asr r2, r2, #0x10
	bl sub_020878EC
_02238A10:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
_02238A30:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_02238A38: .word 0x00002F64
_02238A3C: .word 0x0000047C
_02238A40: .word 0x00002EAC
_02238A44: .word 0x0000049C
_02238A48: .word 0x000004D8
_02238A4C: .word 0x00002E0C
	thumb_func_end ov40_02238838

	thumb_func_start ov40_02238A50
ov40_02238A50: ; 0x02238A50
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _02238A6C
	cmp r0, #1
	beq _02238AD6
	cmp r0, #2
	beq _02238B52
	b _02238B96
_02238A6C:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	ldr r0, _02238B9C ; =0x00002F64
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _02238A86
	add r0, r5, #0
	bl ov40_02237D6C
_02238A86:
	ldr r0, _02238BA0 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA24
	ldr r0, _02238BA4 ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F720
	ldr r0, _02238BA4 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F920
	ldr r0, _02238B9C ; =0x00002F64
	mov r1, #1
	str r1, [r4, r0]
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	mov r2, #8
	mov r1, #0x69
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [sp, #8]
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	bl ov40_0222D980
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02238AD6:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	mov r2, #1
	add r1, r4, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02238B96
	ldr r1, _02238BA8 ; =0x000004D4
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov40_02236184
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238BAC ; =0x00002ED8
	add r1, r5, #0
	add r0, r4, r0
	bl ov40_0222E79C
	ldr r0, _02238BAC ; =0x00002ED8
	mov r1, #0
	add r0, r4, r0
	bl ov40_0222E7DC
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02238B96
_02238B52:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _02238B96
	ldr r0, _02238BAC ; =0x00002ED8
	mov r1, #1
	add r0, r4, r0
	bl ov40_0222E7DC
	ldr r1, _02238B9C ; =0x00002F64
	add r0, r5, #0
	ldr r1, [r4, r1]
	add r1, #0x79
	bl ov40_02237B7C
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
_02238B96:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02238B9C: .word 0x00002F64
_02238BA0: .word 0x0000047C
_02238BA4: .word 0x0000049C
_02238BA8: .word 0x000004D4
_02238BAC: .word 0x00002ED8
	thumb_func_end ov40_02238A50

	thumb_func_start ov40_02238BB0
ov40_02238BB0: ; 0x02238BB0
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02238BCC
	cmp r1, #1
	beq _02238BDA
	cmp r1, #2
	beq _02238BFE
	b _02238C5E
_02238BCC:
	ldr r0, _02238D40 ; =0x00002F64
	mov r1, #0
	str r1, [r4, r0]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02238D38
_02238BDA:
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238D44 ; =0x00002ED8
	add r1, r5, #0
	add r0, r4, r0
	bl ov40_0222E7B8
	add r0, r5, #0
	bl ov40_022361B0
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02238BFE:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	mov r2, #1
	add r1, r4, r1
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	bne _02238C16
	b _02238D38
_02238C16:
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	mov r1, #3
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	add r3, r1, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02238D38
_02238C5E:
	mov r1, #0x69
	lsl r1, r1, #2
	add r0, r4, r1
	add r1, r1, #4
	add r1, r4, r1
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _02238D38
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r1, _02238D40 ; =0x00002F64
	add r0, r5, #0
	ldr r1, [r4, r1]
	add r1, #0x79
	bl ov40_02237B7C
	add r0, r5, #0
	bl ov40_02237C9C
	ldr r0, _02238D48 ; =0x0000047C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #2
	bl ov40_0222F9E0
	ldr r3, _02238D4C ; =0x00002EAC
	ldr r0, _02238D50 ; =0x0000049C
	add r2, r4, r3
	sub r3, #0xa0
	add r0, r5, r0
	add r1, r5, #0
	add r3, r4, r3
	bl ov40_0222EED0
	ldr r1, _02238D48 ; =0x0000047C
	add r0, r5, r1
	add r1, #0x20
	add r1, r5, r1
	bl ov40_0222FA5C
	ldr r0, _02238D50 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #1
	bl ov40_0222F740
	ldr r0, _02238D50 ; =0x0000049C
	mov r1, #0x38
	add r0, r5, r0
	mov r2, #0xb0
	bl ov40_0222F858
	ldr r0, _02238D40 ; =0x00002F64
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _02238D14
	ldr r0, _02238D48 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA88
	ldr r1, _02238D50 ; =0x0000049C
	add r0, r5, r1
	sub r1, #0x10
	ldrsh r1, [r5, r1]
	bl ov40_0222F5EC
	ldr r0, _02238D50 ; =0x0000049C
	ldr r2, _02238D54 ; =0x00002E0C
	add r0, r5, r0
	add r1, r5, #0
	add r2, r4, r2
	bl ov40_0222EFD8
	ldr r2, _02238D58 ; =0x000004D8
	mov r0, #0x6f
	ldr r3, [r5, r2]
	mov r2, #0x18
	mul r2, r3
	lsl r0, r0, #4
	add r2, #0x44
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	mov r1, #0x10
	asr r2, r2, #0x10
	bl sub_020878EC
_02238D14:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
_02238D38:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_02238D40: .word 0x00002F64
_02238D44: .word 0x00002ED8
_02238D48: .word 0x0000047C
_02238D4C: .word 0x00002EAC
_02238D50: .word 0x0000049C
_02238D54: .word 0x00002E0C
_02238D58: .word 0x000004D8
	thumb_func_end ov40_02238BB0

	thumb_func_start ov40_02238D5C
ov40_02238D5C: ; 0x02238D5C
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r7, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02238D72
	cmp r1, #1
	beq _02238DC8
	b _02238E1E
_02238D72:
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02237008
	add r0, r5, #0
	bl ov40_02236534
	ldr r0, _02238EB4 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020878B0
	ldr r0, _02238EB4 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl sub_020878B0
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02238EB0
_02238DC8:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02238EB0
	mov r6, #0
	add r4, r7, #0
_02238DD4:
	mov r0, #0x33
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #5
	blt _02238DD4
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r7, r0
	bl ov40_0222DAA8
	add r0, r5, #0
	bl ov40_0222D88C
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02238EB0
_02238E1E:
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r7, r0
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02238E78
	add r0, r5, #0
	bl ov40_0222DD08
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r7, r0
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	mov r0, #0xe1
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	bl sub_020314BC
	add r0, r7, #0
	bl Heap_Free
	b _02238EB0
_02238E78:
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r7, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #1
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r3, #0x6b
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #2
	ldr r3, [r7, r3]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r1, #3
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02238EB0:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02238EB4: .word 0x000006F4
	thumb_func_end ov40_02238D5C

	thumb_func_start ov40_02238EB8
ov40_02238EB8: ; 0x02238EB8
	bx lr
	.balign 4, 0
	thumb_func_end ov40_02238EB8

	thumb_func_start ov40_02238EBC
ov40_02238EBC: ; 0x02238EBC
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r1, [r1]
	ldr r4, [r0, r2]
	cmp r1, #1
	bne _02238ED4
	mov r0, #0xe2
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
_02238ED4:
	bl ov40_0223D540
	mov r1, #0xe3
	lsl r1, r1, #2
	add r1, r4, r1
	mov r2, #0x14
	bl ov39_02227F14
	mov r1, #0xe2
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #4
	add r1, #0x54
	ldr r2, _02238EFC ; =0x00002A30
	add r0, r4, r0
	add r1, r4, r1
	bl MI_CpuCopy8
	pop {r4, pc}
	nop
_02238EFC: .word 0x00002A30
	thumb_func_end ov40_02238EBC

	thumb_func_start ov40_02238F00
ov40_02238F00: ; 0x02238F00
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r4, #0x1c]
	cmp r0, #0
	ldr r0, _02238FD4 ; =0x00000B0C
	bne _02238F2E
	ldr r3, _02238FD8 ; =ov40_02245418
	add r2, r4, r0
	mov r6, #5
_02238F1A:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _02238F1A
	ldr r0, [r3]
	mov r1, #0
	str r0, [r2]
	ldr r0, _02238FDC ; =0x00000748
	str r1, [r4, r0]
	b _02238F5A
_02238F2E:
	ldr r3, _02238FE0 ; =ov40_02245444
	add r2, r4, r0
	mov r6, #5
_02238F34:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _02238F34
	ldr r0, [r3]
	ldr r1, _02238FE4 ; =0x00000714
	str r0, [r2]
	ldr r3, [r4, r1]
	mov r1, #0x72
	ldr r2, [r4, #0xc]
	lsl r1, r1, #2
	mul r1, r2
	ldrb r1, [r3, r1]
	ldr r0, [r5, #0x4c]
	add r1, #0x5e
	bl NewString_ReadMsgData
	ldr r1, _02238FDC ; =0x00000748
	str r0, [r4, r1]
_02238F5A:
	mov r1, #0xb1
	ldr r0, [r4, #0x20]
	lsl r1, r1, #4
	str r0, [r4, r1]
	ldr r3, [r4, #0xc]
	ldr r0, _02238FE8 ; =0x0000074C
	lsl r2, r3, #2
	add r2, r3, r2
	add r0, r4, r0
	lsl r2, r2, #6
	add r2, r0, r2
	sub r0, r1, #4
	str r2, [r4, r0]
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _02238FEC ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F734
	ldr r0, [r4, #0xc]
	ldr r3, _02238FD4 ; =0x00000B0C
	str r0, [sp]
	ldr r0, [r4, #0x14]
	ldr r2, _02238FDC ; =0x00000748
	str r0, [sp, #4]
	ldr r0, [r4, r2]
	sub r2, r2, #4
	str r0, [sp, #8]
	ldr r0, _02238FEC ; =0x0000049C
	ldr r2, [r4, r2]
	add r0, r5, r0
	add r1, r5, #0
	add r3, r4, r3
	bl ov40_0222EB9C
	ldr r1, _02238FF0 ; =0x0000047C
	add r0, r5, r1
	add r1, #0x20
	add r1, r5, r1
	bl ov40_0222FA5C
	ldr r0, _02238FEC ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #1
	bl ov40_0222F740
	ldr r0, _02238FEC ; =0x0000049C
	mov r1, #0x70
	add r0, r5, r0
	mov r2, #0xb8
	bl ov40_0222F858
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_02238FD4: .word 0x00000B0C
_02238FD8: .word ov40_02245418
_02238FDC: .word 0x00000748
_02238FE0: .word ov40_02245444
_02238FE4: .word 0x00000714
_02238FE8: .word 0x0000074C
_02238FEC: .word 0x0000049C
_02238FF0: .word 0x0000047C
	thumb_func_end ov40_02238F00

	thumb_func_start ov40_02238FF4
ov40_02238FF4: ; 0x02238FF4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	ldr r0, _02239314 ; =0x00000714
	add r1, r4, #0
	add r1, #0xe0
	str r1, [r4, r0]
	add r1, r0, #0
	sub r1, #0xdc
	add r1, r4, r1
	add r0, r0, #4
	str r1, [r4, r0]
	ldr r0, [r4, #0x14]
	cmp r0, #0
	beq _02239026
	cmp r0, #1
	bne _0223901C
	b _02239120
_0223901C:
	cmp r0, #2
	bne _02239022
	b _0223920C
_02239022:
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02239026:
	mov r6, #0
	add r5, r6, #0
	str r6, [sp]
_0223902C:
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0xc]
	cmp r0, #0
	bne _02239084
	lsl r0, r1, #2
	add r0, r1, r0
	lsl r0, r0, #6
	add r0, r4, r0
	add r2, r5, r0
	ldr r1, _02239318 ; =0x00002710
	ldr r0, _0223931C ; =0x0000074C
	str r1, [r2, r0]
	sub r0, #0x34
	ldr r2, [r4, r0]
	ldr r1, [r4, #0xc]
	mov r0, #0x48
	mul r0, r1
	add r0, r2, r0
	add r0, r6, r0
	ldrb r0, [r0, #4]
	mov r1, #4
	bl ov40_0222E658
	ldr r2, [r4, #0xc]
	lsl r1, r2, #2
	add r1, r2, r1
	lsl r1, r1, #6
	add r1, r4, r1
	add r2, r5, r1
	mov r1, #0x75
	lsl r1, r1, #4
	str r0, [r2, r1]
	ldr r2, [r4, #0xc]
	asr r0, r6, #0x1f
	lsl r1, r2, #2
	add r1, r2, r1
	lsl r1, r1, #6
	add r1, r4, r1
	add r2, r5, r1
	ldr r1, _02239320 ; =0x00000754
	str r6, [r2, r1]
	add r1, r1, #4
	str r0, [r2, r1]
	b _0223910E
_02239084:
	lsl r0, r1, #2
	add r0, r1, r0
	lsl r0, r0, #6
	add r0, r4, r0
	add r2, r5, r0
	ldr r1, _02239324 ; =0x00004E20
	ldr r0, _0223931C ; =0x0000074C
	str r1, [r2, r0]
	sub r0, #0x38
	ldr r2, [r4, r0]
	mov r0, #0x72
	ldr r1, [r4, #0xc]
	lsl r0, r0, #2
	mul r0, r1
	add r0, r2, r0
	add r0, r6, r0
	ldrb r0, [r0, #4]
	mov r1, #4
	bl ov40_0222E658
	ldr r2, [r4, #0xc]
	lsl r1, r2, #2
	add r1, r2, r1
	lsl r1, r1, #6
	add r1, r4, r1
	add r2, r5, r1
	mov r1, #0x75
	lsl r1, r1, #4
	str r0, [r2, r1]
	sub r1, #0x3c
	ldr r2, [r4, r1]
	mov r1, #0x72
	ldr r0, [r4, #0xc]
	lsl r1, r1, #2
	mul r1, r0
	add r2, r2, r1
	ldr r1, [sp]
	add r1, r1, r2
	add r1, #0x14
	ldmia r1!, {r2, r3}
	lsl r1, r0, #2
	add r0, r0, r1
	lsl r0, r0, #6
	add r0, r4, r0
	add r1, r5, r0
	ldr r0, _02239320 ; =0x00000754
	add r0, r1, r0
	stmia r0!, {r2, r3}
	ldr r1, [r4, #0xc]
	lsl r0, r1, #2
	add r0, r1, r0
	lsl r0, r0, #6
	add r0, r4, r0
	add r3, r0, r5
	ldr r0, _02239320 ; =0x00000754
	ldr r2, [r3, r0]
	add r0, r0, #4
	ldr r1, [r3, r0]
	ldr r7, _02239328 ; =0x8AC72304
	ldr r0, _0223932C ; =0x89E7FFFF
	sub r0, r2, r0
	sbc r1, r7
	blo _0223910E
	ldr r1, _0223932C ; =0x89E7FFFF
	ldr r0, _02239320 ; =0x00000754
	str r1, [r3, r0]
	ldr r1, _02239328 ; =0x8AC72304
	add r0, r0, #4
	str r1, [r3, r0]
_0223910E:
	ldr r0, [sp]
	add r6, r6, #1
	add r0, #8
	add r5, #0x10
	str r0, [sp]
	cmp r6, #0x10
	blt _0223902C
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02239120:
	mov r1, #0
	add r0, r1, #0
	add r7, r1, #0
_02239126:
	ldr r2, [r4, #0x1c]
	ldr r3, [r4, #0xc]
	cmp r2, #0
	bne _02239176
	lsl r2, r3, #2
	add r2, r3, r2
	lsl r2, r2, #6
	add r2, r4, r2
	add r5, r0, r2
	ldr r3, _02239330 ; =0x00007530
	ldr r2, _0223931C ; =0x0000074C
	str r3, [r5, r2]
	sub r2, #0x34
	ldr r3, [r4, #0xc]
	mov r5, #0x48
	ldr r2, [r4, r2]
	mul r5, r3
	add r2, r2, r5
	lsl r5, r3, #2
	add r3, r3, r5
	add r2, r1, r2
	lsl r3, r3, #6
	add r3, r4, r3
	add r5, r0, r3
	mov r3, #0x75
	ldrb r2, [r2, #0x14]
	lsl r3, r3, #4
	str r2, [r5, r3]
	ldr r5, [r4, #0xc]
	asr r3, r1, #0x1f
	lsl r2, r5, #2
	add r2, r5, r2
	lsl r2, r2, #6
	add r2, r4, r2
	ldr r5, _02239320 ; =0x00000754
	add r2, r0, r2
	str r1, [r2, r5]
	add r5, r5, #4
	str r3, [r2, r5]
	b _022391FE
_02239176:
	lsl r2, r3, #2
	add r2, r3, r2
	lsl r2, r2, #6
	add r2, r4, r2
	add r5, r0, r2
	ldr r3, _02239334 ; =0x00009C40
	ldr r2, _0223931C ; =0x0000074C
	str r3, [r5, r2]
	sub r2, #0x38
	mov r5, #0x72
	ldr r3, [r4, #0xc]
	lsl r5, r5, #2
	ldr r2, [r4, r2]
	mul r5, r3
	add r2, r2, r5
	lsl r5, r3, #2
	add r2, r1, r2
	add r3, r3, r5
	add r2, #0x94
	lsl r3, r3, #6
	add r3, r4, r3
	add r5, r0, r3
	mov r3, #0x75
	ldrb r2, [r2]
	lsl r3, r3, #4
	str r2, [r5, r3]
	add r2, r3, #0
	sub r2, #0x3c
	mov r3, #0x72
	ldr r5, [r4, #0xc]
	lsl r3, r3, #2
	ldr r2, [r4, r2]
	mul r3, r5
	add r2, r2, r3
	add r6, r7, r2
	add r6, #0xa0
	ldmia r6!, {r2, r3}
	lsl r6, r5, #2
	add r5, r5, r6
	lsl r5, r5, #6
	add r5, r4, r5
	add r6, r0, r5
	ldr r5, _02239320 ; =0x00000754
	add r5, r6, r5
	stmia r5!, {r2, r3}
	ldr r3, [r4, #0xc]
	lsl r2, r3, #2
	add r2, r3, r2
	lsl r2, r2, #6
	add r2, r4, r2
	add r5, r2, r0
	ldr r2, _02239320 ; =0x00000754
	ldr r3, [r5, r2]
	add r2, r2, #4
	ldr r2, [r5, r2]
	ldr r6, _02239328 ; =0x8AC72304
	str r6, [sp, #0xc]
	ldr r6, _0223932C ; =0x89E7FFFF
	sub r3, r3, r6
	ldr r3, [sp, #0xc]
	sbc r2, r3
	blo _022391FE
	ldr r3, _0223932C ; =0x89E7FFFF
	ldr r2, _02239320 ; =0x00000754
	str r3, [r5, r2]
	ldr r3, _02239328 ; =0x8AC72304
	add r2, r2, #4
	str r3, [r5, r2]
_022391FE:
	add r1, r1, #1
	add r0, #0x10
	add r7, #8
	cmp r1, #0xc
	blt _02239126
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_0223920C:
	mov r7, #0
	add r0, r7, #0
	add r1, r7, #0
	str r7, [sp, #0x10]
_02239214:
	ldr r2, [r4, #0x1c]
	ldr r3, [r4, #0xc]
	cmp r2, #0
	bne _02239264
	lsl r2, r3, #2
	add r2, r3, r2
	lsl r2, r2, #6
	add r2, r4, r2
	add r5, r0, r2
	ldr r3, _02239338 ; =0x0000C350
	ldr r2, _0223931C ; =0x0000074C
	str r3, [r5, r2]
	sub r2, #0x34
	ldr r3, [r4, #0xc]
	mov r5, #0x48
	ldr r2, [r4, r2]
	mul r5, r3
	add r2, r2, r5
	lsl r5, r3, #2
	add r3, r3, r5
	add r2, r1, r2
	lsl r3, r3, #6
	add r3, r4, r3
	add r5, r0, r3
	mov r3, #0x75
	ldrh r2, [r2, #0x20]
	lsl r3, r3, #4
	str r2, [r5, r3]
	ldr r5, [r4, #0xc]
	asr r3, r7, #0x1f
	lsl r2, r5, #2
	add r2, r5, r2
	lsl r2, r2, #6
	add r2, r4, r2
	ldr r5, _02239320 ; =0x00000754
	add r2, r0, r2
	str r7, [r2, r5]
	add r5, r5, #4
	str r3, [r2, r5]
	b _022392FE
_02239264:
	lsl r2, r3, #2
	add r2, r3, r2
	lsl r2, r2, #6
	add r2, r4, r2
	add r5, r0, r2
	ldr r3, _0223933C ; =0x0000EA60
	ldr r2, _0223931C ; =0x0000074C
	str r3, [r5, r2]
	sub r2, #0x38
	mov r5, #0x72
	ldr r3, [r4, #0xc]
	lsl r5, r5, #2
	ldr r2, [r4, r2]
	mul r5, r3
	add r2, r2, r5
	add r5, r1, r2
	mov r2, #1
	lsl r2, r2, #8
	ldrh r2, [r5, r2]
	lsl r5, r3, #2
	add r3, r3, r5
	lsl r3, r3, #6
	add r3, r4, r3
	add r5, r0, r3
	mov r3, #0x75
	lsl r3, r3, #4
	str r2, [r5, r3]
	ldr r2, [r4, #0xc]
	str r2, [sp, #4]
	add r2, r3, #0
	sub r2, #0x3c
	mov r3, #0x72
	ldr r5, [sp, #4]
	lsl r3, r3, #2
	ldr r2, [r4, r2]
	mul r3, r5
	add r3, r2, r3
	ldr r2, [sp, #0x10]
	add r3, r2, r3
	mov r2, #0x4a
	lsl r2, r2, #2
	add r5, r3, r2
	ldmia r5!, {r2, r3}
	ldr r5, [sp, #4]
	lsl r6, r5, #2
	add r5, r5, r6
	lsl r5, r5, #6
	add r5, r4, r5
	add r6, r0, r5
	ldr r5, _02239320 ; =0x00000754
	add r5, r6, r5
	stmia r5!, {r2, r3}
	ldr r3, [r4, #0xc]
	lsl r2, r3, #2
	add r2, r3, r2
	lsl r2, r2, #6
	add r2, r4, r2
	add r3, r2, r0
	ldr r2, _02239320 ; =0x00000754
	str r3, [sp, #8]
	ldr r5, [r3, r2]
	add r2, r2, #4
	ldr r3, [r3, r2]
	ldr r2, _02239328 ; =0x8AC72304
	mov ip, r2
	ldr r2, _0223932C ; =0x89E7FFFF
	sub r2, r5, r2
	mov r2, ip
	sbc r3, r2
	blo _022392FE
	ldr r5, _0223932C ; =0x89E7FFFF
	ldr r3, [sp, #8]
	ldr r2, _02239320 ; =0x00000754
	str r5, [r3, r2]
	ldr r5, _02239328 ; =0x8AC72304
	add r2, r2, #4
	str r5, [r3, r2]
_022392FE:
	ldr r2, [sp, #0x10]
	add r7, r7, #1
	add r2, #8
	add r0, #0x10
	add r1, r1, #2
	str r2, [sp, #0x10]
	cmp r7, #0x14
	blt _02239214
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_02239314: .word 0x00000714
_02239318: .word 0x00002710
_0223931C: .word 0x0000074C
_02239320: .word 0x00000754
_02239324: .word 0x00004E20
_02239328: .word 0x8AC72304
_0223932C: .word 0x89E7FFFF
_02239330: .word 0x00007530
_02239334: .word 0x00009C40
_02239338: .word 0x0000C350
_0223933C: .word 0x0000EA60
	thumb_func_end ov40_02238FF4

	thumb_func_start ov40_02239340
ov40_02239340: ; 0x02239340
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	str r0, [sp, #0x14]
	mov r0, #0
	str r0, [sp, #0x18]
	mov r1, #0x86
	ldr r0, [sp, #0x14]
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	ldr r5, _022393EC ; =ov40_022453B8
	mov r6, #1
	add r4, #0x84
_02239358:
	ldr r0, [r5, #4]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldr r0, [r5, #8]
	mov r2, #6
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	ldr r0, [r5, #0xc]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [r5]
	ldr r0, [r0, #0x24]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x18
	bl AddWindowParameterized
	ldr r1, [r5, #8]
	ldr r0, [r5, #0xc]
	mul r0, r1
	add r6, r6, r0
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	ldr r0, [r0, #0x48]
	add r1, #0x50
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r0, r4, #0
	add r1, r7, #0
	bl ov40_022306C0
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022393F0 ; =0x000F0D00
	mov r1, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	add r2, r7, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add r0, r7, #0
	bl String_Delete
	ldr r0, [sp, #0x18]
	add r4, #0x10
	add r0, r0, #1
	add r5, #0x10
	str r0, [sp, #0x18]
	cmp r0, #2
	blt _02239358
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_022393EC: .word ov40_022453B8
_022393F0: .word 0x000F0D00
	thumb_func_end ov40_02239340

	thumb_func_start ov40_022393F4
ov40_022393F4: ; 0x022393F4
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r5, [r0, r1]
	mov r4, #0
	add r5, #0x84
_02239400:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #2
	blt _02239400
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_022393F4

	thumb_func_start ov40_02239418
ov40_02239418: ; 0x02239418
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #0x14]
	ldr r0, [r0, r1]
	ldr r6, _02239508 ; =ov40_022453D8
	str r0, [sp, #0x1c]
	ldr r4, [sp, #0x1c]
	mov r0, #0
	ldr r5, _0223950C ; =ov40_022453F8
	mov r7, #1
	str r0, [sp, #0x18]
	add r4, #0x24
_02239434:
	add r0, r4, #0
	bl InitWindow
	ldr r0, [sp, #0x1c]
	ldr r0, [r0, #0x1c]
	cmp r0, #0
	bne _0223947C
	ldr r0, [r6, #4]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldr r0, [r6, #8]
	mov r2, #2
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	ldr r0, [r6, #0xc]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [r6]
	ldr r0, [r0, #0x24]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x18
	bl AddWindowParameterized
	ldr r1, [r6, #8]
	ldr r0, [r6, #0xc]
	b _022394B4
_0223947C:
	ldr r0, [r5, #4]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldr r0, [r5, #8]
	mov r2, #2
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	ldr r0, [r5, #0xc]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [r5]
	ldr r0, [r0, #0x24]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x18
	bl AddWindowParameterized
	ldr r1, [r5, #8]
	ldr r0, [r5, #0xc]
_022394B4:
	mul r0, r1
	add r7, r7, r0
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	mov r1, #0x43
	ldr r0, [r0, #0x48]
	bl NewString_ReadMsgData
	str r0, [sp, #0x20]
	mov r0, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02239510 ; =0x000F0D00
	mov r1, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r2, [sp, #0x20]
	add r0, r4, #0
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x20]
	bl String_Delete
	ldr r0, [sp, #0x18]
	add r4, #0x10
	add r0, r0, #1
	add r6, #0x10
	add r5, #0x10
	str r0, [sp, #0x18]
	cmp r0, #2
	blt _02239434
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02239508: .word ov40_022453D8
_0223950C: .word ov40_022453F8
_02239510: .word 0x000F0D00
	thumb_func_end ov40_02239418

	thumb_func_start ov40_02239514
ov40_02239514: ; 0x02239514
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r5, [r0, r1]
	mov r4, #0
	add r5, #0x24
_02239520:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #2
	blt _02239520
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02239514

	thumb_func_start ov40_02239538
ov40_02239538: ; 0x02239538
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r0, #0
	cmp r5, #0x57
	blt _02239548
	mov r5, #0
	bl GF_AssertFail
_02239548:
	ldr r6, _0223956C ; =ov40_02245CE8
	lsl r5, r5, #2
	ldr r1, [r6, r5]
	ldr r0, _02239570 ; =0x0000FFFF
	cmp r1, r0
	bne _02239558
	bl GF_AssertFail
_02239558:
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl Save_GameStats_Get
	ldr r1, [r6, r5]
	bl GameStats_GetCapped
	pop {r4, r5, r6, pc}
	nop
_0223956C: .word ov40_02245CE8
_02239570: .word 0x0000FFFF
	thumb_func_end ov40_02239538

	thumb_func_start ov40_02239574
ov40_02239574: ; 0x02239574
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1fc
	sub sp, #0x30
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x14]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r6, r0, #0
	add r0, r4, #0
	add r0, #0x24
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r4, #0x1c]
	cmp r0, #0
	ldr r0, [r5, #0x4c]
	bne _022395BA
	ldr r1, _022397A4 ; =0x00000718
	ldr r3, [r4, #0xc]
	mov r2, #0x48
	ldr r1, [r4, r1]
	mul r2, r3
	ldrb r1, [r1, r2]
	sub r1, r1, #1
	bl NewString_ReadMsgData
	b _022395CE
_022395BA:
	ldr r1, _022397A8 ; =0x00000714
	mov r2, #0x72
	ldr r3, [r4, #0xc]
	lsl r2, r2, #2
	ldr r1, [r4, r1]
	mul r2, r3
	ldrb r1, [r1, r2]
	sub r1, r1, #1
	bl NewString_ReadMsgData
_022395CE:
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022397AC ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, #0
	add r0, #0x24
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	add r0, #0x24
	bl ScheduleWindowCopyToVram
	add r0, r7, #0
	bl String_Delete
	add r0, r4, #0
	add r0, #0x34
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r4, #0x1c]
	cmp r0, #0
	ldr r0, [r5, #0x48]
	bne _02239614
	ldr r1, [r4, #0x14]
	add r1, #0x52
	bl NewString_ReadMsgData
	b _0223961A
_02239614:
	mov r1, #0x5b
	bl NewString_ReadMsgData
_0223961A:
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022397AC ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, #0
	add r0, #0x34
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	add r0, #0x34
	bl ScheduleWindowCopyToVram
	add r0, r7, #0
	bl String_Delete
	ldr r0, _022397B0 ; =0x0000088C
	mov r1, #0x6d
	ldr r0, [r5, r0]
	bl sub_020315B8
	str r0, [sp, #0x18]
	ldr r1, [sp, #0x18]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r4, #0x14]
	cmp r0, #0
	beq _02239668
	cmp r0, #1
	beq _022396A6
	cmp r0, #2
	beq _022396D0
	b _0223973A
_02239668:
	ldr r0, _022397B0 ; =0x0000088C
	ldr r0, [r5, r0]
	bl sub_02031700
	str r0, [sp, #0x20]
	ldr r0, [r5, #0x48]
	mov r1, #0x55
	bl NewString_ReadMsgData
	add r7, r0, #0
	ldr r0, [sp, #0x20]
	mov r1, #4
	bl ov40_0222E658
	add r1, r0, #0
	ldr r0, _022397B4 ; =0x00000744
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	str r0, [sp, #0x1c]
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x1c]
	add r0, r6, #0
	add r3, r1, #0
	bl BufferString
	b _0223973A
_022396A6:
	ldr r0, _022397B0 ; =0x0000088C
	ldr r0, [r5, r0]
	bl sub_020316F0
	str r0, [sp, #0x24]
	ldr r0, [r5, #0x48]
	mov r1, #0x56
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x1c]
	ldr r2, [sp, #0x24]
	add r0, r6, #0
	mov r1, #0
	bl BufferMonthNameAbbr
	b _0223973A
_022396D0:
	ldr r0, _022397B0 ; =0x0000088C
	ldr r0, [r5, r0]
	bl sub_020315E0
	str r0, [sp, #0x10]
	ldr r0, _022397B0 ; =0x0000088C
	ldr r0, [r5, r0]
	bl sub_02031610
	str r0, [sp, #0x28]
	ldr r0, [r5, #0x48]
	mov r1, #0x57
	bl NewString_ReadMsgData
	add r7, r0, #0
	ldr r0, [sp, #0x28]
	cmp r0, #0
	beq _022396F8
	ldr r0, _022397B8 ; =0x000001EE
	str r0, [sp, #0x10]
_022396F8:
	ldr r0, [sp, #0x10]
	cmp r0, #0
	beq _0223971C
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x10]
	mov r1, #0x6d
	add r2, sp, #0x2c
	bl GetSpeciesNameIntoArray
	ldr r0, [sp, #0x1c]
	add r1, sp, #0x2c
	bl CopyU16ArrayToString
	b _02239726
_0223971C:
	ldr r0, [r5, #0x48]
	mov r1, #0x15
	bl NewString_ReadMsgData
	str r0, [sp, #0x1c]
_02239726:
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x1c]
	add r0, r6, #0
	add r3, r1, #0
	bl BufferString
_0223973A:
	mov r1, #1
	str r1, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	mov r3, #0
	bl BufferString
	ldr r1, [sp, #0x14]
	add r0, r6, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022397AC ; =0x000F0D00
	mov r1, #0
	str r0, [sp, #8]
	add r0, r4, #0
	ldr r2, [sp, #0x14]
	add r0, #0x34
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r4, #0x34
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add r0, r7, #0
	bl String_Delete
	ldr r0, [sp, #0x1c]
	bl String_Delete
	ldr r0, [sp, #0x14]
	bl String_Delete
	ldr r0, [sp, #0x18]
	bl String_Delete
	add r0, r6, #0
	bl MessageFormat_ResetBuffers
	add r0, r6, #0
	bl MessageFormat_Delete
	add sp, #0x1fc
	add sp, #0x30
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_022397A4: .word 0x00000718
_022397A8: .word 0x00000714
_022397AC: .word 0x000F0D00
_022397B0: .word 0x0000088C
_022397B4: .word 0x00000744
_022397B8: .word 0x000001EE
	thumb_func_end ov40_02239574

	thumb_func_start ov40_022397BC
ov40_022397BC: ; 0x022397BC
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r0, r2]
	cmp r1, #0
	bne _022397F0
	add r0, r4, #0
	add r0, #0xa8
	ldr r0, [r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0xac
	ldr r0, [r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	add r0, r4, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #0x80
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	b _02239816
_022397F0:
	add r0, r4, #0
	add r0, #0xa8
	ldr r0, [r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	add r0, #0xac
	ldr r0, [r0]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	add r0, r4, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #0x50
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
_02239816:
	add r0, r4, #0
	add r0, #0xac
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r0]
	sub r2, #0x2c
	bl sub_020136B4
	add r4, #0xc8
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4]
	sub r2, #0x2c
	bl sub_020136B4
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_022397BC

	thumb_func_start ov40_02239838
ov40_02239838: ; 0x02239838
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	mov r1, #2
	bl ov40_0222D73C
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222D800
	add r1, r4, #0
	add r1, #0xa8
	str r0, [r1]
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222D800
	add r1, r4, #0
	add r1, #0xc4
	str r0, [r1]
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0xa4
	add r1, #0x14
	mov r2, #2
	bl ov40_0222D5AC
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0xc0
	add r1, #0x14
	mov r2, #2
	bl ov40_0222D5AC
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0xa4
	add r1, #0x14
	mov r2, #0x35
	bl ov40_0222D66C
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0xc0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r4, #0
	add r0, #0xa8
	ldr r0, [r0]
	mov r1, #0x20
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #0x80
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	add r0, #0xac
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r0]
	sub r2, #0x2c
	bl sub_020136B4
	add r0, r4, #0
	add r0, #0xc8
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r0]
	sub r2, #0x2c
	bl sub_020136B4
	add r0, r4, #0
	add r0, #0xac
	ldr r0, [r0]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	add r4, #0xc8
	ldr r0, [r4]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	add r0, r5, #0
	mov r1, #1
	bl ov40_022397BC
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_02239838

	thumb_func_start ov40_022398F8
ov40_022398F8: ; 0x022398F8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	add r0, r4, #0
	add r0, #0xa4
	bl ov40_0222D6D0
	add r0, r4, #0
	add r0, #0xc0
	bl ov40_0222D6D0
	add r0, r4, #0
	add r0, #0xa8
	ldr r0, [r0]
	bl Sprite_DeleteAndFreeResources
	add r4, #0xc4
	ldr r0, [r4]
	bl Sprite_DeleteAndFreeResources
	add r0, r5, #0
	bl ov40_0222D7DC
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_022398F8

	thumb_func_start ov40_0223992C
ov40_0223992C: ; 0x0223992C
	push {r3, r4, r5}
	sub sp, #0xc
	ldr r5, _02239950 ; =ov40_022453A0
	add r2, r0, #0
	ldmia r5!, {r0, r1}
	add r4, sp, #0
	add r3, r4, #0
	stmia r4!, {r0, r1}
	ldr r0, [r5]
	str r0, [r4]
	ldr r0, [r2, #0x14]
	lsl r0, r0, #2
	ldr r0, [r3, r0]
	str r0, [r2, #0x20]
	add sp, #0xc
	pop {r3, r4, r5}
	bx lr
	nop
_02239950: .word ov40_022453A0
	thumb_func_end ov40_0223992C

	thumb_func_start ov40_02239954
ov40_02239954: ; 0x02239954
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r5, r2]
	cmp r1, #0
	bne _022399B6
	cmp r0, #0
	beq _0223996C
	cmp r0, #1
	beq _0223998A
	b _022399A8
_0223996C:
	add r0, r5, #0
	bl ov40_02230944
	ldr r0, [r4, #0xc]
	add r0, r0, #1
	str r0, [r4, #0xc]
	ldr r1, [r4, #0x10]
	bl _s32_div_f
	str r1, [r4, #0xc]
	add r0, r5, #0
	mov r1, #4
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_0223998A:
	add r0, r5, #0
	bl ov40_02230944
	ldr r0, [r4, #0x14]
	add r0, r0, #1
	str r0, [r4, #0x14]
	ldr r1, [r4, #0x18]
	bl _s32_div_f
	str r1, [r4, #0x14]
	add r0, r5, #0
	mov r1, #4
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_022399A8:
	add r0, r5, #0
	bl ov40_02230944
	add r0, r5, #0
	mov r1, #7
	bl ov40_0222BF80
_022399B6:
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_02239954

	thumb_func_start ov40_022399B8
ov40_022399B8: ; 0x022399B8
	push {r3, r4, r5, lr}
	ldr r1, _02239A48 ; =0x00000B38
	add r5, r0, #0
	mov r0, #0x6d
	bl Heap_Alloc
	ldr r2, _02239A48 ; =0x00000B38
	mov r1, #0
	add r4, r0, #0
	bl memset
	mov r0, #0x86
	lsl r0, r0, #4
	str r4, [r5, r0]
	add r0, #0xc
	ldr r0, [r5, r0]
	str r0, [r4, #0x1c]
	mov r0, #3
	str r0, [r4, #0x10]
	add r0, r5, #0
	bl sub_02087E1C
	cmp r0, #0
	bne _022399EE
	ldr r0, [r4, #0x10]
	sub r0, r0, #1
	str r0, [r4, #0x10]
_022399EE:
	mov r0, #3
	str r0, [r4, #0x18]
	add r0, r4, #0
	bl ov40_0223992C
	ldr r1, [r5, #0x48]
	ldr r0, _02239A4C ; =0x00000744
	str r1, [r4, r0]
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	bl ov40_0222D9E8
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02239A50 ; =ov40_022453AC
	ldr r2, _02239A54 ; =ov40_02239954
	mov r1, #3
	add r3, r5, #0
	bl TouchHitboxController_Create
	add r4, #0xdc
	str r0, [r4]
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222BF80
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02239A48: .word 0x00000B38
_02239A4C: .word 0x00000744
_02239A50: .word ov40_022453AC
_02239A54: .word ov40_02239954
	thumb_func_end ov40_022399B8

	thumb_func_start ov40_02239A58
ov40_02239A58: ; 0x02239A58
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02239A6E
	cmp r1, #1
	beq _02239ACC
	b _02239B42
_02239A6E:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	cmp r0, #0
	beq _02239A82
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02239A82:
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02239B52
_02239ACC:
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D874
	add r0, r5, #0
	bl ov40_02239838
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	mov r1, #1
	bl SetBgPriority
	mov r0, #1
	mov r1, #3
	bl SetBgPriority
	mov r0, #2
	mov r1, #0
	bl SetBgPriority
	mov r0, #3
	mov r1, #1
	bl SetBgPriority
	mov r0, #4
	mov r1, #1
	bl SetBgPriority
	mov r0, #5
	mov r1, #3
	bl SetBgPriority
	mov r0, #6
	mov r1, #0
	bl SetBgPriority
	mov r0, #7
	mov r1, #2
	bl SetBgPriority
	add r0, r5, #0
	mov r1, #0
	bl ov40_0222FB90
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02239B52
_02239B42:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02239B52
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222BF80
_02239B52:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02239A58

	thumb_func_start ov40_02239B58
ov40_02239B58: ; 0x02239B58
	push {r3, r4, r5, lr}
	sub sp, #8
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02239B72
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, pc}
_02239B72:
	ldr r0, [r4, #8]
	cmp r0, #6
	bls _02239B7A
	b _02239EA0
_02239B7A:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02239B86: ; jump table
	.short _02239B94 - _02239B86 - 2 ; case 0
	.short _02239BD4 - _02239B86 - 2 ; case 1
	.short _02239BEC - _02239B86 - 2 ; case 2
	.short _02239CD6 - _02239B86 - 2 ; case 3
	.short _02239CF6 - _02239B86 - 2 ; case 4
	.short _02239DBA - _02239B86 - 2 ; case 5
	.short _02239E18 - _02239B86 - 2 ; case 6
_02239B94:
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r1, _02239ED0 ; =0x00000117
	add r0, r4, #0
	bl ov40_0222DED0
	ldr r0, _02239ED4 ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02239EC8
_02239BD4:
	add r0, r4, #0
	bl ov40_0223D540
	bl ov39_022274B4
	cmp r0, #1
	beq _02239BE4
	b _02239EC8
_02239BE4:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02239EC8
_02239BEC:
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	bne _02239C2A
	ldr r0, _02239ED4 ; =0x0000057D
	mov r1, #0
	bl StopSE
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r3, [sp, #4]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #4
	bl ov40_02230CDC
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #5
	str r0, [r4, #8]
	b _02239EC8
_02239C2A:
	mov r0, #0x71
	lsl r0, r0, #4
	add r1, r5, r0
	add r0, #0xc
	str r1, [r5, r0]
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl Save_PlayerData_GetIGTAddr
	bl GetIGTHours
	ldr r1, _02239ED8 ; =0x00000728
	strh r0, [r5, r1]
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl Save_PlayerData_GetIGTAddr
	bl GetIGTMinutes
	ldr r1, _02239EDC ; =0x0000072A
	strb r0, [r5, r1]
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl Save_PlayerData_GetIGTAddr
	bl GetIGTSeconds
	ldr r1, _02239EE0 ; =0x0000072B
	strb r0, [r5, r1]
	add r0, r1, #0
	sub r0, #0xf
	ldr r0, [r5, r0]
	ldrb r2, [r0]
	add r0, r1, #1
	strb r2, [r5, r0]
	add r0, r1, #0
	sub r0, #0xf
	ldr r0, [r5, r0]
	ldrb r2, [r0, #1]
	add r0, r1, #0
	add r0, #9
	strb r2, [r5, r0]
	add r0, r1, #0
	sub r0, #0xf
	ldr r0, [r5, r0]
	ldrb r2, [r0, #2]
	add r0, r1, #0
	add r0, #0x11
	strb r2, [r5, r0]
	add r1, r1, #1
	ldrb r1, [r5, r1]
	add r0, r4, #0
	sub r1, r1, #1
	bl ov40_02239538
	mov r1, #0x73
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r1, r1, #4
	ldrb r1, [r5, r1]
	add r0, r4, #0
	sub r1, r1, #1
	bl ov40_02239538
	ldr r1, _02239EE4 ; =0x00000738
	str r0, [r5, r1]
	add r1, r1, #4
	ldrb r1, [r5, r1]
	add r0, r4, #0
	sub r1, r1, #1
	bl ov40_02239538
	mov r1, #0x1d
	lsl r1, r1, #6
	str r0, [r5, r1]
	ldr r0, _02239ED4 ; =0x0000057D
	mov r1, #0
	bl StopSE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02239EC8
_02239CD6:
	add r0, r4, #0
	bl ov40_0223D540
	ldr r1, _02239EE8 ; =0x0000088C
	ldr r2, _02239EEC ; =0x0000072C
	ldr r1, [r4, r1]
	add r2, r5, r2
	bl ov39_022274D4
	cmp r0, #1
	beq _02239CEE
	b _02239EC8
_02239CEE:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02239EC8
_02239CF6:
	add r0, r4, #0
	bl ov40_0222DFB0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	bne _02239D34
	ldr r0, _02239ED4 ; =0x0000057D
	mov r1, #0
	bl StopSE
	ldr r3, [sp, #4]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #5
	bl ov40_02230CDC
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #5
	str r0, [r4, #8]
	b _02239EC8
_02239D34:
	ldr r1, [r5, #0x1c]
	mov r0, #0
	cmp r1, #0
	bne _02239D5C
	ldr r1, _02239EF0 ; =0x00000718
	ldr r2, [r5, r1]
	ldrb r1, [r2]
	cmp r1, #0
	beq _02239D58
	add r1, r2, #0
	add r1, #0x48
	ldrb r1, [r1]
	cmp r1, #0
	beq _02239D58
	add r2, #0x90
	ldrb r1, [r2]
	cmp r1, #0
	bne _02239D7A
_02239D58:
	mov r0, #1
	b _02239D7A
_02239D5C:
	ldr r1, _02239EF4 ; =0x00000714
	ldr r3, [r5, r1]
	ldrb r1, [r3]
	cmp r1, #0
	beq _02239D78
	mov r1, #0x72
	lsl r1, r1, #2
	ldrb r2, [r3, r1]
	cmp r2, #0
	beq _02239D78
	lsl r1, r1, #1
	ldrb r1, [r3, r1]
	cmp r1, #0
	bne _02239D7A
_02239D78:
	mov r0, #1
_02239D7A:
	cmp r0, #0
	beq _02239DA6
	mov r2, #0
	add r0, r4, #0
	mov r1, #5
	add r3, r2, #0
	bl ov40_02230CDC
	mov r1, #0x4b
	mov r0, #0x51
	lsl r1, r1, #2
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #5
	str r0, [r4, #8]
	b _02239EC8
_02239DA6:
	ldr r0, _02239ED4 ; =0x0000057D
	mov r1, #0
	bl StopSE
	ldr r0, _02239EF8 ; =0x00000577
	bl PlaySE
	mov r0, #0xff
	str r0, [r4, #8]
	b _02239EC8
_02239DBA:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_022398F8
	add r0, r5, #0
	add r0, #0xdc
	ldr r0, [r0]
	bl TouchHitboxController_Destroy
	add r5, #8
	add r0, r5, #0
	bl ov40_0222DAA8
	add r0, r4, #0
	bl ov40_0222D88C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02239EC8
_02239E18:
	add r0, r4, #0
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02239EC8
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02239E6E
	add r0, r4, #0
	bl ov40_0222DD08
	add r0, r5, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r4, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r4, #0x10]
	add r0, r4, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
	add r0, r5, #0
	bl Heap_Free
	b _02239EC8
_02239E6E:
	ldr r0, [r4, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02239EC8
_02239EA0:
	add r0, r4, #0
	bl ov40_02238FF4
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
_02239EC8:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_02239ED0: .word 0x00000117
_02239ED4: .word 0x0000057D
_02239ED8: .word 0x00000728
_02239EDC: .word 0x0000072A
_02239EE0: .word 0x0000072B
_02239EE4: .word 0x00000738
_02239EE8: .word 0x0000088C
_02239EEC: .word 0x0000072C
_02239EF0: .word 0x00000718
_02239EF4: .word 0x00000714
_02239EF8: .word 0x00000577
	thumb_func_end ov40_02239B58

	thumb_func_start ov40_02239EFC
ov40_02239EFC: ; 0x02239EFC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02239F14
	cmp r1, #1
	beq _02239FC0
	b _0223A022
_02239F14:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x21
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x22
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add r0, r5, #0
	bl ov40_02239418
	add r0, r5, #0
	bl ov40_02239574
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223A030 ; =0x0000047C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #2
	bl ov40_0222F9E0
	add r0, r5, #0
	bl ov40_02238F00
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02239340
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A028
_02239FC0:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02239FF0
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02239FF0:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223A028
_0223A022:
	mov r1, #6
	bl ov40_0222BF80
_0223A028:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_0223A030: .word 0x0000047C
	thumb_func_end ov40_02239EFC

	thumb_func_start ov40_0223A034
ov40_0223A034: ; 0x0223A034
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, _0223A074 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA88
	ldr r1, _0223A078 ; =0x0000049C
	add r0, r5, r1
	sub r1, #0x10
	ldrsh r1, [r5, r1]
	bl ov40_0222F6D0
	ldr r0, _0223A07C ; =0x00000748
	add r1, r5, #0
	ldr r0, [r4, r0]
	str r0, [sp]
	ldr r0, _0223A078 ; =0x0000049C
	ldr r2, [r4, #0xc]
	ldr r3, [r4, #0x14]
	add r0, r5, r0
	bl ov40_0222F09C
	add r4, #0xdc
	ldr r0, [r4]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223A074: .word 0x0000047C
_0223A078: .word 0x0000049C
_0223A07C: .word 0x00000748
	thumb_func_end ov40_0223A034

	thumb_func_start ov40_0223A080
ov40_0223A080: ; 0x0223A080
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223A096
	cmp r1, #1
	beq _0223A0EC
	b _0223A13E
_0223A096:
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223A148 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA24
	ldr r0, _0223A14C ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F720
	ldr r0, _0223A150 ; =0x00000748
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0223A0B8
	bl String_Delete
_0223A0B8:
	ldr r0, _0223A14C ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F920
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, _0223A154 ; =0x000006F4
	mov r1, #0
	ldr r0, [r5, r0]
	bl sub_020879E0
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A144
_0223A0EC:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223A10C
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223A10C:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223A144
_0223A13E:
	mov r1, #8
	bl ov40_0222BF80
_0223A144:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223A148: .word 0x0000047C
_0223A14C: .word 0x0000049C
_0223A150: .word 0x00000748
_0223A154: .word 0x000006F4
	thumb_func_end ov40_0223A080

	thumb_func_start ov40_0223A158
ov40_0223A158: ; 0x0223A158
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223A16E
	cmp r1, #1
	beq _0223A19E
	b _0223A1EA
_0223A16E:
	bl ov40_022393F4
	add r0, r5, #0
	bl ov40_02239514
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_022398F8
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r4, #0xdc
	ldr r0, [r4]
	bl TouchHitboxController_Destroy
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A26E
_0223A19E:
	mov r1, #1
	bl ov40_02230964
	add r4, #8
	add r0, r4, #0
	bl ov40_0222DAA8
	add r0, r5, #0
	bl ov40_0222D88C
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A26E
_0223A1EA:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _0223A26E
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _0223A23E
	add r0, r5, #0
	bl ov40_0222DD08
	add r0, r4, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	add r0, r4, #0
	bl Heap_Free
	b _0223A26E
_0223A23E:
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_0223A26E:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_0223A158

	thumb_func_start ov40_0223A274
ov40_0223A274: ; 0x0223A274
	push {r3, lr}
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223A274

	thumb_func_start ov40_0223A280
ov40_0223A280: ; 0x0223A280
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223A29A
	cmp r1, #1
	beq _0223A2D0
	cmp r1, #2
	beq _0223A2E8
	b _0223A312
_0223A29A:
	bl ov40_02238FF4
	add r0, r4, #0
	bl ov40_0223992C
	add r0, r5, #0
	bl ov40_02239514
	ldr r0, _0223A31C ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F720
	ldr r0, _0223A320 ; =0x00000748
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0223A2BE
	bl String_Delete
_0223A2BE:
	ldr r0, _0223A31C ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F920
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A318
_0223A2D0:
	mov r2, #1
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223A318
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A318
_0223A2E8:
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223A318
	add r0, r5, #0
	bl ov40_02239418
	add r0, r5, #0
	bl ov40_02239574
	add r0, r5, #0
	bl ov40_02238F00
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A318
_0223A312:
	mov r1, #6
	bl ov40_0222BF80
_0223A318:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223A31C: .word 0x0000049C
_0223A320: .word 0x00000748
	thumb_func_end ov40_0223A280

	thumb_func_start ov40_0223A324
ov40_0223A324: ; 0x0223A324
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r1, [r1]
	ldr r4, [r0, r2]
	cmp r1, #1
	bne _0223A33E
	mov r0, #0x71
	lsl r0, r0, #4
	add r1, r4, r0
	add r0, #0xc
	str r1, [r4, r0]
	pop {r4, pc}
_0223A33E:
	bl ov40_0223D540
	ldr r1, _0223A35C ; =0x0000071C
	add r1, r4, r1
	bl ov39_02227F74
	ldr r1, _0223A35C ; =0x0000071C
	mov r2, #4
	ldr r0, [r4, r1]
	sub r1, #0xc
	add r1, r4, r1
	bl MI_CpuCopy8
	pop {r4, pc}
	nop
_0223A35C: .word 0x0000071C
	thumb_func_end ov40_0223A324

	thumb_func_start ov40_0223A360
ov40_0223A360: ; 0x0223A360
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r1, [r1]
	ldr r4, [r0, r2]
	cmp r1, #1
	bne _0223A382
	add r1, r4, #0
	ldr r0, _0223A3B0 ; =0x00000714
	add r1, #0xe0
	str r1, [r4, r0]
	add r1, r0, #0
	sub r1, #0xdc
	add r1, r4, r1
	add r0, r0, #4
	str r1, [r4, r0]
	pop {r4, pc}
_0223A382:
	bl ov40_0223D540
	ldr r2, _0223A3B0 ; =0x00000714
	add r1, r4, r2
	add r2, r2, #4
	add r2, r4, r2
	bl ov39_02227FA8
	ldr r0, _0223A3B0 ; =0x00000714
	add r1, r4, #0
	ldr r0, [r4, r0]
	ldr r2, _0223A3B4 ; =0x00000558
	add r1, #0xe0
	bl MI_CpuCopy8
	ldr r1, _0223A3B8 ; =0x00000718
	mov r2, #0xd8
	ldr r0, [r4, r1]
	sub r1, #0xe0
	add r1, r4, r1
	bl MI_CpuCopy8
	pop {r4, pc}
	.balign 4, 0
_0223A3B0: .word 0x00000714
_0223A3B4: .word 0x00000558
_0223A3B8: .word 0x00000718
	thumb_func_end ov40_0223A360

	thumb_func_start ov40_0223A3BC
ov40_0223A3BC: ; 0x0223A3BC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x84
	ldr r4, _0223A428 ; =ov40_0224557C
	add r3, sp, #0xc
	mov r2, #0x3c
_0223A3C6:
	ldrh r1, [r4]
	add r4, r4, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _0223A3C6
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	ldr r7, _0223A42C ; =0x00002090
	str r0, [sp, #4]
	ldr r0, [sp, #8]
	str r0, [sp]
_0223A3E4:
	ldr r0, [sp]
	ldr r4, [sp, #4]
	lsl r1, r0, #2
	add r0, sp, #0xc
	mov r6, #0
	add r5, r0, r1
_0223A3F0:
	ldr r0, [r4, r7]
	cmp r0, #0
	beq _0223A402
	mov r1, #0
	mov r2, #2
	ldrsh r1, [r5, r1]
	ldrsh r2, [r5, r2]
	bl ManagedSprite_SetPositionXY
_0223A402:
	add r6, r6, #1
	add r4, #8
	add r5, r5, #4
	cmp r6, #6
	blt _0223A3F0
	ldr r0, [sp, #4]
	add r0, #0x30
	str r0, [sp, #4]
	ldr r0, [sp]
	add r0, r0, #6
	str r0, [sp]
	ldr r0, [sp, #8]
	add r0, r0, #1
	str r0, [sp, #8]
	cmp r0, #5
	blt _0223A3E4
	add sp, #0x84
	pop {r4, r5, r6, r7, pc}
	nop
_0223A428: .word ov40_0224557C
_0223A42C: .word 0x00002090
	thumb_func_end ov40_0223A3BC

	thumb_func_start ov40_0223A430
ov40_0223A430: ; 0x0223A430
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	mov r1, #2
	bl ov40_0222D6EC
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222D800
	mov r1, #0x46
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222D800
	mov r1, #0x4d
	lsl r1, r1, #2
	str r0, [r4, r1]
	sub r1, #0x20
	add r0, r4, r1
	add r1, r5, #0
	add r1, #0x14
	mov r2, #2
	bl ov40_0222D5AC
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r5, #0
	add r0, r4, r0
	add r1, #0x14
	mov r2, #2
	bl ov40_0222D5AC
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r5, #0
	add r0, r4, r0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r5, #0
	add r0, r4, r0
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x20
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x80
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	mov r0, #0x47
	lsl r0, r0, #2
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x2c
	bl sub_020136B4
	mov r0, #0x4e
	lsl r0, r0, #2
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x2c
	bl sub_020136B4
	mov r0, #0x47
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	mov r0, #0x4e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223B4BC
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_0223A430

	thumb_func_start ov40_0223A510
ov40_0223A510: ; 0x0223A510
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	ldr r0, _0223A638 ; =0x000008A4
	add r4, r1, #0
	sub r0, #0x44
	ldr r3, [r5, r0]
	cmp r4, #0x64
	bne _0223A58A
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r3, r0]
	str r0, [sp, #0x14]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r6, r0, #0
	ldr r0, [sp, #0x14]
	mov r1, #0x6d
	bl sub_020315B8
	str r0, [sp, #0x18]
	ldr r1, [sp, #0x18]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r7, #0
	add r3, r1, #0
	bl BufferString
	add r0, r7, #0
	add r1, r6, #0
	add r2, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x18]
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
	b _0223A602
_0223A58A:
	cmp r4, #0x66
	bne _0223A5FA
	lsl r0, r2, #2
	add r1, r5, r0
	ldr r0, _0223A638 ; =0x000008A4
	sub r0, #0x18
	ldr r0, [r1, r0]
	str r0, [sp, #0x10]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r6, r0, #0
	ldr r0, [sp, #0x10]
	mov r1, #0x6d
	bl sub_020315B8
	str r0, [sp, #0x1c]
	ldr r1, [sp, #0x1c]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x1c]
	add r0, r7, #0
	add r3, r1, #0
	bl BufferString
	add r0, r7, #0
	add r1, r6, #0
	add r2, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x1c]
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
	b _0223A602
_0223A5FA:
	ldr r0, [r5, #0x48]
	bl NewString_ReadMsgData
	add r6, r0, #0
_0223A602:
	ldr r0, _0223A638 ; =0x000008A4
	mov r1, #0xcc
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223A63C ; =0x000F0D0C
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0223A638 ; =0x000008A4
	add r3, r1, #0
	add r0, r5, r0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _0223A638 ; =0x000008A4
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add r0, r6, #0
	bl String_Delete
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223A638: .word 0x000008A4
_0223A63C: .word 0x000F0D0C
	thumb_func_end ov40_0223A510

	thumb_func_start ov40_0223A640
ov40_0223A640: ; 0x0223A640
	push {r3, r4, r5, lr}
	sub sp, #8
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	bl ov40_0223D5CC
	cmp r0, #0
	bne _0223A65A
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, pc}
_0223A65A:
	ldr r0, [r4, #8]
	cmp r0, #4
	bls _0223A662
	b _0223A7E8
_0223A662:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223A66E: ; jump table
	.short _0223A678 - _0223A66E - 2 ; case 0
	.short _0223A6AE - _0223A66E - 2 ; case 1
	.short _0223A6E8 - _0223A66E - 2 ; case 2
	.short _0223A72E - _0223A66E - 2 ; case 3
	.short _0223A75A - _0223A66E - 2 ; case 4
_0223A678:
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223A69C
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	b _0223A6A8
_0223A69C:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_0222E7DC
_0223A6A8:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223A6AE:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223A6CE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223A6CE:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223A812
_0223A6E8:
	add r0, r4, #0
	mov r1, #0x75
	bl ov40_0222DED0
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, _0223A818 ; =0x00002038
	mov r1, #0
	str r1, [r5, r0]
	ldr r0, _0223A81C ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223A812
_0223A72E:
	add r0, r4, #0
	bl ov40_0223D540
	ldr r1, _0223A820 ; =0x000004D4
	ldr r1, [r4, r1]
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r1, _0223A824 ; =0x00002608
	ldr r2, [r2, r1]
	add r1, r2, #0
	add r1, #0xd8
	add r2, #0xdc
	ldr r1, [r1]
	ldr r2, [r2]
	bl ov39_02227720
	cmp r0, #1
	bne _0223A812
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223A812
_0223A75A:
	add r0, r4, #0
	bl ov40_0222DFB0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _0223A81C ; =0x0000057D
	bne _0223A794
	mov r1, #0
	bl StopSE
	ldr r3, [sp, #4]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #8
	bl ov40_02230CDC
	ldr r0, [r4, #8]
	mov r1, #0
	add r0, r0, #1
	str r0, [r4, #8]
	ldr r0, _0223A818 ; =0x00002038
	str r1, [r5, r0]
	b _0223A7CC
_0223A794:
	mov r1, #0
	bl StopSE
	mov r0, #0xff
	ldr r1, _0223A818 ; =0x00002038
	str r0, [r4, #8]
	mov r2, #1
	str r2, [r5, r1]
	ldr r1, _0223A828 ; =0x0000413C
	add r2, r4, r1
	ldr r1, _0223A820 ; =0x000004D4
	ldr r1, [r4, r1]
	add r1, r2, r1
	ldr r2, _0223A82C ; =0x00000878
	str r1, [r4, r2]
	add r1, r2, #0
	add r1, #0x3c
	ldr r3, [r4, r1]
	add r1, r0, #0
	add r1, #0x85
	str r3, [r5, r1]
	add r0, #0x85
	add r2, #0x40
	add r1, r4, r2
	ldr r0, [r5, r0]
	ldr r2, _0223A830 ; =0x00001D4C
	bl MI_CpuCopy8
_0223A7CC:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	b _0223A812
_0223A7E8:
	ldr r0, _0223A818 ; =0x00002038
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0223A80A
	ldr r0, _0223A834 ; =0x00000577
	bl PlaySE
	ldr r1, _0223A838 ; =0x00002034
	add r0, r4, #0
	ldr r1, [r5, r1]
	bl ov40_0222BF80
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FC40
	b _0223A812
_0223A80A:
	add r0, r4, #0
	mov r1, #0x14
	bl ov40_0222BF80
_0223A812:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223A818: .word 0x00002038
_0223A81C: .word 0x0000057D
_0223A820: .word 0x000004D4
_0223A824: .word 0x00002608
_0223A828: .word 0x0000413C
_0223A82C: .word 0x00000878
_0223A830: .word 0x00001D4C
_0223A834: .word 0x00000577
_0223A838: .word 0x00002034
	thumb_func_end ov40_0223A640

	thumb_func_start ov40_0223A83C
ov40_0223A83C: ; 0x0223A83C
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl sub_02030938
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl sub_020314BC
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_0223A83C

	thumb_func_start ov40_0223A85C
ov40_0223A85C: ; 0x0223A85C
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223A85C

	thumb_func_start ov40_0223A874
ov40_0223A874: ; 0x0223A874
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223A88E
	cmp r1, #1
	beq _0223A89E
	cmp r1, #2
	beq _0223A8CC
	b _0223A918
_0223A88E:
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A91E
_0223A89E:
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223A91E
	add r0, r5, #0
	bl ov40_0223CE38
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223A91E
_0223A8CC:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223A8FE
	add r0, r5, #0
	mov r1, #0x64
	mov r2, #0
	bl ov40_0223A510
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223A8FE:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223A91E
_0223A918:
	mov r1, #0xc
	bl ov40_0222BF80
_0223A91E:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_0223A874

	thumb_func_start ov40_0223A924
ov40_0223A924: ; 0x0223A924
	push {r4, r5, r6, lr}
	sub sp, #8
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #7
	bls _0223A938
	b _0223AB4A
_0223A938:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223A944: ; jump table
	.short _0223A954 - _0223A944 - 2 ; case 0
	.short _0223A964 - _0223A944 - 2 ; case 1
	.short _0223A9B6 - _0223A944 - 2 ; case 2
	.short _0223A9D4 - _0223A944 - 2 ; case 3
	.short _0223AA0A - _0223A944 - 2 ; case 4
	.short _0223AA4E - _0223A944 - 2 ; case 5
	.short _0223AA94 - _0223A944 - 2 ; case 6
	.short _0223AAF0 - _0223A944 - 2 ; case 7
_0223A954:
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223ABFC
_0223A964:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223A99C
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r1, _0223AC04 ; =0x00000116
	add r0, r4, #0
	mov r2, #0
	bl ov40_0223A510
	add r0, r4, #0
	bl ov40_022306E0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223A99C:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223ABFC
_0223A9B6:
	ldr r2, _0223AC08 ; =0x000004D4
	ldr r1, _0223AC0C ; =0x00002028
	ldr r2, [r4, r2]
	ldr r1, [r5, r1]
	add r3, r4, r2
	ldr r2, _0223AC10 ; =0x0000413C
	ldrb r2, [r3, r2]
	bl ov40_0222FC14
	cmp r0, #0
	beq _0223AA9C
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223ABFC
_0223A9D4:
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	ldr r0, _0223AC14 ; =0x0000057D
	bl PlaySE
	b _0223ABFC
_0223AA0A:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _0223AA18
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_0223AA18:
	mov r1, #0x46
	add r0, r4, #0
	lsl r1, r1, #2
	mov r2, #0
	bl ov40_0223A510
	bl sub_020307F8
	mov r1, #4
	mov r2, #0
	bl sub_0203088C
	add r6, r0, #0
	add r5, r1, #0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, r6, #0
	add r2, r5, #0
	bl ov39_0222774C
	cmp r0, #1
	bne _0223AA9C
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223ABFC
_0223AA4E:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _0223AA5C
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_0223AA5C:
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _0223AC14 ; =0x0000057D
	bne _0223AA76
	mov r1, #0
	bl StopSE
	b _0223AA82
_0223AA76:
	mov r1, #0
	bl StopSE
	ldr r0, _0223AC18 ; =0x00000577
	bl PlaySE
_0223AA82:
	ldr r0, [r4, #8]
	ldr r1, _0223AC1C ; =0x00000119
	add r0, r0, #1
	str r0, [r4, #8]
	add r0, r4, #0
	mov r2, #0
	bl ov40_0223A510
	b _0223ABFC
_0223AA94:
	bl System_GetTouchNew
	cmp r0, #0
	bne _0223AA9E
_0223AA9C:
	b _0223ABFC
_0223AA9E:
	add r0, r4, #0
	bl ov40_0222DEAC
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223B44C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r4, #0
	bl ov40_0222FDC4
	add r0, r4, #0
	bl ov40_0222FCCC
	ldr r0, _0223AC20 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F734
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223ABFC
_0223AAF0:
	mov r0, #0x62
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x63
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	add r0, r4, #0
	bl ov40_0223A83C
	add r5, #8
	add r0, r5, #0
	bl ov40_0222DAA8
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0222D88C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #1
	mov r1, #0x6d
	bl sub_0203A948
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223ABFC
_0223AB4A:
	add r0, r4, #0
	bl ov40_0222FBB4
	cmp r0, #0
	beq _0223ABFC
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _0223ABCC
	add r0, r4, #0
	bl ov40_0222DD08
	add r0, r5, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r4, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r4, #0x10]
	add r0, r4, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	bl Heap_Free
	bl sub_0202FC48
	cmp r0, #1
	bne _0223ABFC
	bl sub_0202FC24
	b _0223ABFC
_0223ABCC:
	ldr r0, [r4, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_0223ABFC:
	mov r0, #0
	add sp, #8
	pop {r4, r5, r6, pc}
	nop
_0223AC04: .word 0x00000116
_0223AC08: .word 0x000004D4
_0223AC0C: .word 0x00002028
_0223AC10: .word 0x0000413C
_0223AC14: .word 0x0000057D
_0223AC18: .word 0x00000577
_0223AC1C: .word 0x00000119
_0223AC20: .word 0x0000049C
	thumb_func_end ov40_0223A924

	thumb_func_start ov40_0223AC24
ov40_0223AC24: ; 0x0223AC24
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223AC3C
	cmp r1, #1
	beq _0223AC9A
	b _0223ACC0
_0223AC3C:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223AC80
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x54
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r2, _0223ACCC ; =0x00002028
	add r0, r5, #0
	ldr r2, [r4, r2]
	mov r1, #0x66
	bl ov40_0223A510
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223AC80:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223ACC6
_0223AC9A:
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223ACC6
	add r0, r5, #0
	bl ov40_0223CD58
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223ACC6
_0223ACC0:
	mov r1, #0xf
	bl ov40_0222BF80
_0223ACC6:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223ACCC: .word 0x00002028
	thumb_func_end ov40_0223AC24

	thumb_func_start ov40_0223ACD0
ov40_0223ACD0: ; 0x0223ACD0
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r1, [r4, #8]
	ldr r5, [r4, r0]
	cmp r1, #3
	bls _0223ACE4
	b _0223AEEC
_0223ACE4:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223ACF0: ; jump table
	.short _0223ACF8 - _0223ACF0 - 2 ; case 0
	.short _0223AD20 - _0223ACF0 - 2 ; case 1
	.short _0223AD5A - _0223ACF0 - 2 ; case 2
	.short _0223AE82 - _0223ACF0 - 2 ; case 3
_0223ACF8:
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223AF18
_0223AD20:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223AD40
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223AD40:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223AF18
_0223AD5A:
	add r0, #0xc
	ldr r0, [r4, r0]
	cmp r0, #0xd2
	bne _0223AD9A
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
_0223AD9A:
	add r0, r4, #0
	bl ov40_0223CCA0
	add r0, r4, #0
	bl ov40_0223CD14
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223AE1E
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0223064C
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	b _0223AE5A
_0223AE1E:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0222E7B8
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0222E79C
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_0222E7DC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
_0223AE5A:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #6
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223AF18
_0223AE82:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223AED2
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223AEB0
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	b _0223AEBC
_0223AEB0:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_0222E7DC
_0223AEBC:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223AED2:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223AF18
_0223AEEC:
	ldr r1, _0223AF20 ; =0x00004138
	mov r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0
	ble _0223AF10
	mov r1, #0x9a
	lsl r1, r1, #6
	add r5, r4, r1
	ldr r2, _0223AF20 ; =0x00004138
	add r6, r4, #0
	sub r1, #0x78
_0223AF02:
	str r5, [r6, r1]
	ldr r3, [r4, r2]
	add r0, r0, #1
	add r5, #0xe4
	add r6, r6, #4
	cmp r0, r3
	blt _0223AF02
_0223AF10:
	add r0, r4, #0
	mov r1, #7
	bl ov40_0222BF80
_0223AF18:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0223AF20: .word 0x00004138
	thumb_func_end ov40_0223ACD0

	thumb_func_start ov40_0223AF24
ov40_0223AF24: ; 0x0223AF24
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x63
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223AF24

	thumb_func_start ov40_0223AF3C
ov40_0223AF3C: ; 0x0223AF3C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _0223AF50
	b _0223B154
_0223AF50:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223AF5C: ; jump table
	.short _0223AF64 - _0223AF5C - 2 ; case 0
	.short _0223AF8C - _0223AF5C - 2 ; case 1
	.short _0223AFDC - _0223AF5C - 2 ; case 2
	.short _0223B0EA - _0223AF5C - 2 ; case 3
_0223AF64:
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223B180
_0223AF8C:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223AFC2
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223B44C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223AFC2:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223B180
_0223AFDC:
	bl ov40_0223A430
	ldr r0, _0223B188 ; =0x0000086C
	ldr r0, [r4, r0]
	cmp r0, #0xd2
	bne _0223B020
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
_0223B020:
	add r0, r4, #0
	bl ov40_0223CD14
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223B092
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	b _0223B0C2
_0223B092:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0222E79C
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_0222E7DC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
_0223B0C2:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #6
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223B180
_0223B0EA:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223B13A
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223B118
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	b _0223B124
_0223B118:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_0222E7DC
_0223B124:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223B13A:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223B180
_0223B154:
	ldr r1, _0223B18C ; =0x00004138
	mov r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0
	ble _0223B178
	mov r1, #0x9a
	lsl r1, r1, #6
	add r5, r4, r1
	ldr r2, _0223B18C ; =0x00004138
	add r6, r4, #0
	sub r1, #0x78
_0223B16A:
	str r5, [r6, r1]
	ldr r3, [r4, r2]
	add r0, r0, #1
	add r5, #0xe4
	add r6, r6, #4
	cmp r0, r3
	blt _0223B16A
_0223B178:
	add r0, r4, #0
	mov r1, #7
	bl ov40_0222BF80
_0223B180:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0223B188: .word 0x0000086C
_0223B18C: .word 0x00004138
	thumb_func_end ov40_0223AF3C

	thumb_func_start ov40_0223B190
ov40_0223B190: ; 0x0223B190
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223B1A6
	cmp r1, #1
	beq _0223B218
	b _0223B292
_0223B1A6:
	mov r0, #0x62
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x63
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	bl ov40_0223A83C
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r4, #0x10]
	cmp r0, #0
	bne _0223B1F6
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0223064C
	b _0223B202
_0223B1F6:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0222E7B8
_0223B202:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0223CCA0
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223B298
_0223B218:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223B278
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r5, #0
	add r0, r4, r0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r5, #0
	add r0, r4, r0
	add r1, #0x14
	mov r2, #0x6f
	bl ov40_0222D66C
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl ManagedSprite_SetAnim
	add r0, r5, #0
	mov r1, #1
	bl ov40_0223B4BC
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223B278:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223B298
_0223B292:
	mov r1, #3
	bl ov40_0222BF80
_0223B298:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_0223B190

	thumb_func_start ov40_0223B29C
ov40_0223B29C: ; 0x0223B29C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r1, #0
	ldr r1, _0223B36C ; =0x0000088C
	lsl r6, r2, #2
	add r4, r5, r1
	ldr r1, [r4, r6]
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x48]
	cmp r1, #0
	bne _0223B2BC
	mov r1, #8
	bl NewString_ReadMsgData
	add r4, r0, #0
	b _0223B31A
_0223B2BC:
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	ldr r0, [r5, #0x48]
	mov r1, #7
	bl NewString_ReadMsgData
	str r0, [sp, #0x14]
	ldr r0, [r4, r6]
	mov r1, #0x6d
	bl sub_020315B8
	add r6, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	bl ov40_02230DCC
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	add r0, r7, #0
	add r2, r6, #0
	add r3, r1, #0
	bl BufferString
	ldr r2, [sp, #0x14]
	add r0, r7, #0
	add r1, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
_0223B31A:
	add r0, sp, #0x18
	bl InitWindow
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r5, #0x24]
	add r1, sp, #0x18
	mov r2, #0x14
	mov r3, #2
	bl AddTextWindowTopLeftCorner
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223B370 ; =0x000E0D00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, sp, #0x18
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	ldr r1, [sp, #0x10]
	ldr r0, [r0, #8]
	ldr r1, [r1, #0xc]
	add r2, sp, #0x18
	mov r3, #0x6d
	bl TextOBJ_CopyFromBGWindow
	add r0, r4, #0
	bl String_Delete
	add r0, sp, #0x18
	bl RemoveWindow
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223B36C: .word 0x0000088C
_0223B370: .word 0x000E0D00
	thumb_func_end ov40_0223B29C

	thumb_func_start ov40_0223B374
ov40_0223B374: ; 0x0223B374
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r3, _0223B444 ; =ov40_022454C0
	ldr r4, [r0, r1]
	str r0, [sp]
	add r2, sp, #0x20
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r3, _0223B448 ; =ov40_022454D0
	add r2, sp, #0x10
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [sp]
	mov r1, #2
	bl ov40_0222D78C
	mov r0, #0x45
	lsl r0, r0, #2
	add r5, r4, r0
	add r0, sp, #0x20
	str r0, [sp, #8]
	mov r0, #0x69
	str r0, [sp, #4]
	ldr r0, [sp]
	mov r6, #0
	str r0, [sp, #0xc]
	add r0, #0x14
	add r7, sp, #0x10
	str r0, [sp, #0xc]
_0223B3BA:
	ldr r0, [sp]
	mov r1, #2
	bl ov40_0222D800
	mov r1, #0x46
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r1, [sp, #0xc]
	add r0, r5, #0
	mov r2, #2
	bl ov40_0222D5AC
	ldr r2, [sp, #8]
	ldr r1, [sp, #0xc]
	ldr r2, [r2]
	add r0, r5, #0
	bl ov40_0222D66C
	cmp r6, #3
	beq _0223B3EC
	ldr r1, [sp]
	add r0, r5, #0
	add r2, r6, #1
	bl ov40_0223B29C
_0223B3EC:
	mov r0, #0x46
	ldr r2, [sp, #4]
	lsl r0, r0, #2
	lsl r2, r2, #0x10
	ldr r0, [r4, r0]
	mov r1, #0x32
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldr r1, [r7]
	bl ManagedSprite_SetAnim
	mov r0, #0x47
	lsl r0, r0, #2
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x2c
	bl sub_020136B4
	mov r0, #0x47
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [sp, #8]
	add r6, r6, #1
	add r0, r0, #4
	str r0, [sp, #8]
	ldr r0, [sp, #4]
	add r4, #0x1c
	add r0, #0x24
	add r5, #0x1c
	add r7, r7, #4
	str r0, [sp, #4]
	cmp r6, #4
	blt _0223B3BA
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223B444: .word ov40_022454C0
_0223B448: .word ov40_022454D0
	thumb_func_end ov40_0223B374

	thumb_func_start ov40_0223B44C
ov40_0223B44C: ; 0x0223B44C
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp]
	ldr r5, [r0, r1]
	mov r0, #0x45
	lsl r0, r0, #2
	mov r6, #0
	add r4, r5, r0
	add r7, r0, #4
_0223B460:
	add r0, r4, #0
	bl ov40_0222D6D0
	ldr r0, [r5, r7]
	bl Sprite_DeleteAndFreeResources
	add r6, r6, #1
	add r4, #0x1c
	add r5, #0x1c
	cmp r6, #4
	blt _0223B460
	ldr r0, [sp]
	bl ov40_0222D7DC
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov40_0223B44C

	thumb_func_start ov40_0223B480
ov40_0223B480: ; 0x0223B480
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov40_0222D6D0
	mov r0, #0x13
	lsl r0, r0, #4
	add r0, r4, r0
	bl ov40_0222D6D0
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_DeleteAndFreeResources
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_DeleteAndFreeResources
	add r0, r5, #0
	bl ov40_0222D7DC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_0223B480

	thumb_func_start ov40_0223B4BC
ov40_0223B4BC: ; 0x0223B4BC
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r0, r2]
	cmp r1, #0
	bne _0223B4F0
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	mov r0, #0x4e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x20
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	b _0223B516
_0223B4F0:
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	mov r0, #0x4e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x50
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
_0223B516:
	mov r0, #0x47
	lsl r0, r0, #2
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x2c
	bl sub_020136B4
	mov r0, #0x4e
	lsl r0, r0, #2
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x2c
	bl sub_020136B4
	pop {r4, pc}
	thumb_func_end ov40_0223B4BC

	thumb_func_start ov40_0223B538
ov40_0223B538: ; 0x0223B538
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r6, [r0, r1]
	ldr r0, _0223B570 ; =0x00002030
	mov r4, #0
	ldr r0, [r6, r0]
	cmp r0, #0
	ble _0223B566
	add r5, r6, #0
	ldr r7, _0223B570 ; =0x00002030
	add r5, #0x14
_0223B550:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	ldr r0, [r6, r7]
	add r4, r4, #1
	add r5, #0x10
	cmp r4, r0
	blt _0223B550
_0223B566:
	ldr r0, _0223B570 ; =0x00002030
	mov r1, #0
	str r1, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223B570: .word 0x00002030
	thumb_func_end ov40_0223B538

	thumb_func_start ov40_0223B574
ov40_0223B574: ; 0x0223B574
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r6, [r0, r1]
	ldr r0, _0223B5AC ; =0x0000202C
	mov r4, #0
	ldr r0, [r6, r0]
	cmp r0, #0
	ble _0223B5A2
	add r5, r6, #0
	ldr r7, _0223B5AC ; =0x0000202C
	add r5, #0x94
_0223B58C:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	ldr r0, [r6, r7]
	add r4, r4, #1
	add r5, #0x10
	cmp r4, r0
	blt _0223B58C
_0223B5A2:
	ldr r0, _0223B5AC ; =0x0000202C
	mov r1, #0
	str r1, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223B5AC: .word 0x0000202C
	thumb_func_end ov40_0223B574

	thumb_func_start ov40_0223B5B0
ov40_0223B5B0: ; 0x0223B5B0
	push {r3, r4, r5, lr}
	ldr r1, _0223B628 ; =0x0000217C
	add r5, r0, #0
	mov r0, #0x6d
	bl Heap_Alloc
	ldr r2, _0223B628 ; =0x0000217C
	mov r1, #0
	add r4, r0, #0
	bl memset
	mov r0, #0x86
	lsl r0, r0, #4
	str r4, [r5, r0]
	add r0, #0xc
	ldr r1, [r5, r0]
	mov r0, #0x4b
	lsl r0, r0, #2
	cmp r1, r0
	bne _0223B5DE
	mov r0, #0
	str r0, [r4, #0xc]
	b _0223B5F2
_0223B5DE:
	add r0, r0, #1
	cmp r1, r0
	bne _0223B5EA
	mov r0, #1
	str r0, [r4, #0xc]
	b _0223B5F2
_0223B5EA:
	cmp r1, #0xc8
	bne _0223B5F2
	mov r0, #2
	str r0, [r4, #0xc]
_0223B5F2:
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	bl ov40_0222D9E8
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222BF80
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223B628: .word 0x0000217C
	thumb_func_end ov40_0223B5B0

	thumb_func_start ov40_0223B62C
ov40_0223B62C: ; 0x0223B62C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223B646
	cmp r1, #1
	beq _0223B6A4
	cmp r1, #2
	beq _0223B700
	b _0223B73C
_0223B646:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	cmp r0, #0
	beq _0223B65A
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223B65A:
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223B756
_0223B6A4:
	mov r0, #0
	mov r1, #1
	bl SetBgPriority
	mov r0, #1
	mov r1, #3
	bl SetBgPriority
	mov r0, #2
	mov r1, #0
	bl SetBgPriority
	mov r0, #3
	mov r1, #1
	bl SetBgPriority
	mov r0, #4
	mov r1, #1
	bl SetBgPriority
	mov r0, #5
	mov r1, #3
	bl SetBgPriority
	mov r0, #6
	mov r1, #0
	bl SetBgPriority
	mov r0, #7
	mov r1, #2
	bl SetBgPriority
	add r0, r5, #0
	mov r1, #0
	bl ov40_0222FB90
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223B756
_0223B700:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _0223B756
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D874
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0223A430
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223B756
_0223B73C:
	bl ov40_0222C4DC
	cmp r0, #1
	bne _0223B74E
	add r0, r5, #0
	mov r1, #0x13
	bl ov40_0222BF80
	b _0223B756
_0223B74E:
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222BF80
_0223B756:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_0223B62C

	thumb_func_start ov40_0223B75C
ov40_0223B75C: ; 0x0223B75C
	push {r3, r4, r5, lr}
	sub sp, #8
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	bl ov40_0223D5CC
	cmp r0, #0
	bne _0223B776
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, pc}
_0223B776:
	ldr r0, [r4, #8]
	cmp r0, #6
	bls _0223B77E
	b _0223BA36
_0223B77E:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223B78A: ; jump table
	.short _0223B798 - _0223B78A - 2 ; case 0
	.short _0223B7F0 - _0223B78A - 2 ; case 1
	.short _0223B87C - _0223B78A - 2 ; case 2
	.short _0223B8FE - _0223B78A - 2 ; case 3
	.short _0223B920 - _0223B78A - 2 ; case 4
	.short _0223B95A - _0223B78A - 2 ; case 5
	.short _0223B98E - _0223B78A - 2 ; case 6
_0223B798:
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, _0223BA60 ; =0x0000086C
	mov r1, #0x4b
	ldr r0, [r4, r0]
	lsl r1, r1, #2
	sub r0, r0, r1
	cmp r0, #1
	bhi _0223B7DA
	add r0, r4, #0
	sub r1, #0x15
	bl ov40_0222DED0
	b _0223B7E2
_0223B7DA:
	add r0, r4, #0
	sub r1, #8
	bl ov40_0222DED0
_0223B7E2:
	ldr r0, _0223BA64 ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B7F0:
	ldr r0, _0223BA60 ; =0x0000086C
	ldr r1, [r4, r0]
	mov r0, #0x4b
	lsl r0, r0, #2
	cmp r1, r0
	bne _0223B816
	mov r0, #0
	str r0, [r5, #0xc]
	add r0, r4, #0
	bl ov40_0223D540
	bl ov39_022276A4
	cmp r0, #1
	bne _0223B86C
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B816:
	add r0, r0, #1
	cmp r1, r0
	bne _0223B836
	mov r0, #1
	str r0, [r5, #0xc]
	add r0, r4, #0
	bl ov40_0223D540
	bl ov39_022276E0
	cmp r0, #1
	bne _0223B86C
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B836:
	cmp r1, #0xc8
	bne _0223B876
	mov r0, #2
	str r0, [r5, #0xc]
	add r0, r4, #0
	bl sub_02087E1C
	cmp r0, #1
	bne _0223B85E
	add r0, r4, #0
	bl ov40_0223D540
	bl ov39_02227648
	cmp r0, #1
	bne _0223B86C
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B85E:
	add r0, r4, #0
	bl ov40_0223D540
	bl ov39_022275E8
	cmp r0, #1
	beq _0223B86E
_0223B86C:
	b _0223BA58
_0223B86E:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B876:
	bl GF_AssertFail
	b _0223BA58
_0223B87C:
	add r0, r4, #0
	bl ov40_0222DFB0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _0223BA64 ; =0x0000057D
	bne _0223B8B0
	mov r1, #0
	bl StopSE
	ldr r3, [sp, #4]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #7
	bl ov40_02230CDC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B8B0:
	mov r1, #0
	bl StopSE
	ldr r0, _0223BA68 ; =0x00000577
	bl PlaySE
	ldr r0, _0223BA6C ; =0x00004138
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0223B8F8
	mov r2, #0
	add r0, r4, #0
	mov r1, #5
	add r3, r2, #0
	bl ov40_02230CDC
	ldr r0, [r5, #0xc]
	cmp r0, #2
	bne _0223B8DA
	mov r1, #0x76
	b _0223B8DE
_0223B8DA:
	mov r1, #0x4b
	lsl r1, r1, #2
_0223B8DE:
	mov r0, #0x51
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B8F8:
	mov r0, #0xff
	str r0, [r4, #8]
	b _0223BA58
_0223B8FE:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B920:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223B940
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223B940:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223BA58
_0223B95A:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223B480
	add r0, r4, #0
	bl ov40_0222D88C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #1
	mov r1, #0x6d
	bl sub_0203A948
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223BA58
_0223B98E:
	add r0, r4, #0
	bl ov40_0222FBB4
	cmp r0, #0
	beq _0223BA58
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _0223BA04
	add r0, r4, #0
	bl ov40_0222DD08
	add r0, r5, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r4, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r4, #0x10]
	add r0, r4, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	bl Heap_Free
	b _0223BA58
_0223BA04:
	ldr r0, [r4, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223BA58
_0223BA36:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
_0223BA58:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_0223BA60: .word 0x0000086C
_0223BA64: .word 0x0000057D
_0223BA68: .word 0x00000577
_0223BA6C: .word 0x00004138
	thumb_func_end ov40_0223B75C

	thumb_func_start ov40_0223BA70
ov40_0223BA70: ; 0x0223BA70
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r3, _0223BB68 ; =ov40_022454A4
	add r6, r4, #0
	ldmia r3!, {r0, r1}
	add r2, sp, #0x14
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	add r6, #0x14
	str r0, [r2]
	add r0, r6, #0
	bl InitWindow
	mov r3, #3
	str r3, [sp]
	mov r0, #0x14
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x20
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r6, #0
	mov r2, #2
	bl AddWindowParameterized
	add r0, r6, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, [r4, #0xc]
	ldr r0, [r5, #0x48]
	lsl r2, r1, #2
	add r1, sp, #0x14
	ldr r1, [r1, r2]
	bl NewString_ReadMsgData
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223BB6C ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r6, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl ScheduleWindowCopyToVram
	add r0, r7, #0
	bl String_Delete
	add r6, r4, #0
	add r6, #0x94
	add r0, r6, #0
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	add r0, #0xf2
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r6, #0
	mov r3, #0xb
	bl AddWindowParameterized
	add r0, r6, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x5f
	bl NewString_ReadMsgData
	add r5, r0, #0
	mov r0, #0
	add r1, r5, #0
	add r2, r0, #0
	bl FontID_String_GetWidthMultiline
	mov r1, #0x50
	sub r0, r1, r0
	mov r1, #0
	lsr r3, r0, #1
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223BB6C ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	bl String_Delete
	ldr r0, _0223BB70 ; =0x0000202C
	mov r1, #1
	str r1, [r4, r0]
	add r0, r0, #4
	str r1, [r4, r0]
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223BB68: .word ov40_022454A4
_0223BB6C: .word 0x000F0D00
_0223BB70: .word 0x0000202C
	thumb_func_end ov40_0223BA70

	thumb_func_start ov40_0223BB74
ov40_0223BB74: ; 0x0223BB74
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223BB8E
	cmp r1, #1
	bne _0223BB8C
	b _0223BCCE
_0223BB8C:
	b _0223BD6E
_0223BB8E:
	bl sub_0202FC48
	cmp r0, #0
	beq _0223BB9A
	bl sub_0202FC24
_0223BB9A:
	ldr r0, _0223BD7C ; =0x00002054
	ldr r3, _0223BD80 ; =ov40_022454F0
	add r2, r4, r0
	mov r6, #5
_0223BBA2:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _0223BBA2
	ldr r0, [r3]
	mov r1, #0
	str r0, [r2]
	ldr r0, _0223BD7C ; =0x00002054
	str r1, [r4, r0]
	ldr r1, _0223BD84 ; =0x00004138
	add r0, r0, #4
	ldr r1, [r5, r1]
	str r1, [r4, r0]
	add r0, r5, #0
	bl ov40_0222FE00
	mov r0, #0x6d
	bl ov40_0222FE8C
	mov r1, #0x82
	lsl r1, r1, #6
	str r0, [r4, r1]
	mov r0, #0x7d
	lsl r0, r0, #2
	add r1, #8
	str r0, [r4, r1]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r5, #0
	mov r1, #4
	mov r2, #3
	bl ov40_022307DC
	mov r1, #7
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_022307DC
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r5, #0
	mov r1, #1
	bl ov40_0223B4BC
	add r0, r5, #0
	bl ov40_0223BA70
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223BD88 ; =0x0000047C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F9D4
	ldr r0, _0223BD8C ; =0x0000049C
	ldr r3, _0223BD7C ; =0x00002054
	add r0, r5, r0
	add r1, r5, #0
	mov r2, #0
	add r3, r4, r3
	bl ov40_0222E9B8
	ldr r1, _0223BD90 ; =0x000004E4
	mov r0, #1
	str r0, [r5, r1]
	add r0, r1, #0
	sub r0, #0x68
	sub r1, #0x48
	add r0, r5, r0
	add r1, r5, r1
	bl ov40_0222FA5C
	ldr r0, _0223BD8C ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #1
	bl ov40_0222F740
	ldr r0, _0223BD8C ; =0x0000049C
	mov r1, #0x40
	add r0, r5, r0
	mov r2, #0xb8
	bl ov40_0222F858
	ldr r0, _0223BD8C ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F488
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0223D008
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223D1AC
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223BD74
_0223BCCE:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223BD3C
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r5, #0
	mov r1, #1
	bl ov40_0223D1AC
	ldr r3, _0223BD94 ; =0x000004D8
	mov r1, #0x6f
	ldr r6, [r5, r3]
	mov r3, #0x18
	mul r3, r6
	lsl r1, r1, #4
	add r3, #0x4c
	lsl r3, r3, #0x10
	ldr r1, [r5, r1]
	add r0, r5, #0
	mov r2, #0x10
	asr r3, r3, #0x10
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0xc
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223BD3C:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223BD74
_0223BD6E:
	mov r1, #4
	bl ov40_0222BF80
_0223BD74:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0223BD7C: .word 0x00002054
_0223BD80: .word ov40_022454F0
_0223BD84: .word 0x00004138
_0223BD88: .word 0x0000047C
_0223BD8C: .word 0x0000049C
_0223BD90: .word 0x000004E4
_0223BD94: .word 0x000004D8
	thumb_func_end ov40_0223BB74

	thumb_func_start ov40_0223BD98
ov40_0223BD98: ; 0x0223BD98
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223BDB4
	cmp r1, #1
	beq _0223BE42
	cmp r1, #2
	bne _0223BDB2
	b _0223BEBC
_0223BDB2:
	b _0223BF56
_0223BDB4:
	ldr r0, _0223BF64 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA88
	ldr r1, _0223BF68 ; =0x0000049C
	add r0, r5, r1
	sub r1, #0x10
	ldrsh r1, [r5, r1]
	bl ov40_0222F5EC
	ldr r0, _0223BF68 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F488
	ldr r2, _0223BF6C ; =0x000004D8
	mov r0, #0x6f
	ldr r3, [r5, r2]
	mov r2, #0x18
	mul r2, r3
	lsl r0, r0, #4
	add r2, #0x4c
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	mov r1, #0x10
	asr r2, r2, #0x10
	bl sub_020878EC
	add r0, r5, #0
	bl ov40_0223D244
	ldr r0, _0223BF70 ; =ov40_02245494
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0223BE22
	add r0, r5, #0
	bl ov40_02230944
	ldr r0, _0223BF74 ; =0x000004D4
	ldr r0, [r5, r0]
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _0223BF78 ; =0x00002608
	ldr r0, [r1, r0]
	cmp r0, #0
	beq _0223BE22
	ldr r0, _0223BF7C ; =0x00002034
	mov r1, #6
	str r1, [r4, r0]
	mov r0, #0
	str r0, [r4, #0x10]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223BE22:
	ldr r0, _0223BF80 ; =ov40_02245498
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	bne _0223BE2E
	b _0223BF5E
_0223BE2E:
	add r0, r5, #0
	bl ov40_02230944
	ldr r0, _0223BF7C ; =0x00002034
	mov r1, #5
	str r1, [r4, r0]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223BF5E
_0223BE42:
	ldr r0, _0223BF64 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA24
	ldr r0, _0223BF68 ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F720
	ldr r0, _0223BF68 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F920
	mov r0, #0x82
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl ov40_0222FE98
	add r0, r5, #0
	bl ov40_0223D1F0
	add r0, r5, #0
	bl ov40_0222FE68
	add r0, r5, #0
	bl ov40_0223B538
	add r0, r5, #0
	bl ov40_0223B574
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, _0223BF7C ; =0x00002034
	ldr r0, [r4, r0]
	cmp r0, #5
	bne _0223BEB6
	ldr r0, _0223BF64 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA18
	ldr r0, _0223BF68 ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F734
	ldr r0, _0223BF84 ; =0x00002084
	mov r1, #0
	str r1, [r4, r0]
_0223BEB6:
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223BEBC:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223BF24
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223B4BC
	ldr r0, _0223BF7C ; =0x00002034
	ldr r0, [r4, r0]
	cmp r0, #6
	bne _0223BF1E
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r5, #0
	add r0, r4, r0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r5, #0
	add r0, r4, r0
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
_0223BF1E:
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223BF24:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223BF5E
_0223BF56:
	ldr r1, _0223BF7C ; =0x00002034
	ldr r1, [r4, r1]
	bl ov40_0222BF80
_0223BF5E:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223BF64: .word 0x0000047C
_0223BF68: .word 0x0000049C
_0223BF6C: .word 0x000004D8
_0223BF70: .word ov40_02245494
_0223BF74: .word 0x000004D4
_0223BF78: .word 0x00002608
_0223BF7C: .word 0x00002034
_0223BF80: .word ov40_02245498
_0223BF84: .word 0x00002084
	thumb_func_end ov40_0223BD98

	thumb_func_start ov40_0223BF88
ov40_0223BF88: ; 0x0223BF88
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223BFA2
	cmp r1, #1
	beq _0223BFBA
	cmp r1, #2
	beq _0223C00A
	b _0223C030
_0223BFA2:
	bl ov40_0223B538
	add r0, r5, #0
	bl ov40_0223B574
	add r0, r5, #0
	bl ov40_0222DFB0
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C0D4
_0223BFBA:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223BFF0
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0223B480
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223BFF0:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223C0D4
_0223C00A:
	add r4, #8
	add r0, r4, #0
	bl ov40_0222DAA8
	add r0, r5, #0
	bl ov40_0222D88C
	mov r0, #1
	mov r1, #0x6d
	bl sub_0203A948
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C0D4
_0223C030:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _0223C0D4
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _0223C0A4
	add r0, r5, #0
	bl ov40_0222DD08
	add r0, r4, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	bl Heap_Free
	b _0223C0D4
_0223C0A4:
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_0223C0D4:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_0223BF88

	thumb_func_start ov40_0223C0D8
ov40_0223C0D8: ; 0x0223C0D8
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _0223C0EA
	b _0223C21A
_0223C0EA:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223C0F6: ; jump table
	.short _0223C0FE - _0223C0F6 - 2 ; case 0
	.short _0223C10E - _0223C0F6 - 2 ; case 1
	.short _0223C15C - _0223C0F6 - 2 ; case 2
	.short _0223C1BE - _0223C0F6 - 2 ; case 3
_0223C0FE:
	mov r1, #6
	mov r2, #7
	bl ov40_022307DC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C222
_0223C10E:
	bl ov40_0223CFA8
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223C228 ; =ov40_022454E0
	ldr r2, _0223C22C ; =ov40_0223CE64
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x62
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223C230 ; =ov40_022454B0
	ldr r2, _0223C234 ; =ov40_0223CF00
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x63
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223C238 ; =ov40_0224549C
	ldr r2, _0223C23C ; =ov40_0223CF70
	mov r1, #2
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C222
_0223C15C:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C222
_0223C1BE:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223C200
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	add r0, r4, #0
	bl ov40_0223CD14
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223C200:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223C222
_0223C21A:
	add r0, r4, #0
	mov r1, #7
	bl ov40_0222BF80
_0223C222:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223C228: .word ov40_022454E0
_0223C22C: .word ov40_0223CE64
_0223C230: .word ov40_022454B0
_0223C234: .word ov40_0223CF00
_0223C238: .word ov40_0224549C
_0223C23C: .word ov40_0223CF70
	thumb_func_end ov40_0223C0D8

	thumb_func_start ov40_0223C240
ov40_0223C240: ; 0x0223C240
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x62
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223C240

	thumb_func_start ov40_0223C258
ov40_0223C258: ; 0x0223C258
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #3
	bls _0223C26A
	b _0223C388
_0223C26A:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223C276: ; jump table
	.short _0223C27E - _0223C276 - 2 ; case 0
	.short _0223C2BC - _0223C276 - 2 ; case 1
	.short _0223C2D4 - _0223C276 - 2 ; case 2
	.short _0223C340 - _0223C276 - 2 ; case 3
_0223C27E:
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r4, #0x10]
	cmp r0, #0
	bne _0223C298
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0223064C
	b _0223C2A4
_0223C298:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0222E7B8
_0223C2A4:
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C3A0
_0223C2BC:
	mov r2, #1
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223C3A0
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C3A0
_0223C2D4:
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r4, #0x10]
	cmp r0, #0
	bne _0223C304
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0222E79C
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl ov40_0222E7DC
	add r0, r5, #0
	mov r1, #0x50
	mov r2, #3
	bl ov40_022307DC
	b _0223C330
_0223C304:
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_02230638
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r4, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r5, #0
	mov r2, #3
	bl ov40_022307DC
_0223C330:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C3A0
_0223C340:
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223C3A0
	ldr r0, [r4, #0x10]
	cmp r0, #0
	bne _0223C364
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #1
	bl ov40_0222E7DC
	b _0223C370
_0223C364:
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r4, r0
	mov r1, #1
	bl ov40_022306A0
_0223C370:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C3A0
_0223C388:
	ldr r1, [r4, #0x10]
	mov r0, #1
	eor r1, r0
	str r1, [r4, #0x10]
	add r0, r5, #0
	add r1, #0x79
	bl ov40_0223CCBC
	add r0, r5, #0
	mov r1, #7
	bl ov40_0222BF80
_0223C3A0:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_0223C258

	thumb_func_start ov40_0223C3A4
ov40_0223C3A4: ; 0x0223C3A4
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223C3C0
	cmp r1, #1
	beq _0223C3E0
	cmp r1, #2
	beq _0223C3F0
	b _0223C482
_0223C3C0:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x6d
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C48E
_0223C3E0:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _0223C48E
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C48E
_0223C3F0:
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r4, #0x10]
	cmp r0, #0
	bne _0223C40A
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0223064C
	b _0223C416
_0223C40A:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0222E7B8
_0223C416:
	mov r0, #0x62
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x63
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x19
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	add r0, r5, #0
	bl ov40_0223A83C
	add r0, r5, #0
	bl ov40_0223CCA0
	add r0, r5, #0
	bl ov40_0223D504
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D8C8
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r1, [r5, #0x10]
	add r0, r5, #0
	ldr r1, [r1]
	bl ov40_0222C4E8
	ldr r0, _0223C494 ; =0x00000868
	mov r1, #1
	ldr r0, [r5, r0]
	mov r2, #0
	bl sub_02087A84
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223C48E
_0223C482:
	add r0, r4, #0
	bl Heap_Free
	add sp, #0xc
	mov r0, #1
	pop {r4, r5, pc}
_0223C48E:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0223C494: .word 0x00000868
	thumb_func_end ov40_0223C3A4

	thumb_func_start ov40_0223C498
ov40_0223C498: ; 0x0223C498
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #5
	bls _0223C4AC
	b _0223C6CC
_0223C4AC:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223C4B8: ; jump table
	.short _0223C4C4 - _0223C4B8 - 2 ; case 0
	.short _0223C592 - _0223C4B8 - 2 ; case 1
	.short _0223C5E0 - _0223C4B8 - 2 ; case 2
	.short _0223C642 - _0223C4B8 - 2 ; case 3
	.short _0223C69E - _0223C4B8 - 2 ; case 4
	.short _0223C6BC - _0223C4B8 - 2 ; case 5
_0223C4C4:
	bl ov40_02230738
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	bl ov40_0222D9E8
	ldr r0, _0223C6E8 ; =0x00004138
	mov r2, #0
	ldr r0, [r4, r0]
	cmp r0, #0
	ble _0223C4F8
	mov r0, #0x9a
	lsl r0, r0, #6
	add r7, r0, #0
	add r3, r4, r0
	ldr r0, _0223C6E8 ; =0x00004138
	add r6, r4, #0
	sub r7, #0x78
_0223C4EA:
	str r3, [r6, r7]
	ldr r1, [r4, r0]
	add r2, r2, #1
	add r3, #0xe4
	add r6, r6, #4
	cmp r2, r1
	blt _0223C4EA
_0223C4F8:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #6
	mov r2, #7
	bl ov40_022307DC
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
	mov r1, #0x7d
	ldr r0, _0223C6EC ; =0x00002088
	lsl r1, r1, #2
	str r1, [r5, r0]
	ldr r1, _0223C6F0 ; =0x000004A4
	sub r0, r0, #4
	ldrsh r1, [r4, r1]
	str r1, [r5, r0]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C6E2
_0223C592:
	bl ov40_0223CFA8
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223C6F4 ; =ov40_022454E0
	ldr r2, _0223C6F8 ; =ov40_0223CE64
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x62
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223C6FC ; =ov40_022454B0
	ldr r2, _0223C700 ; =ov40_0223CF00
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x63
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223C704 ; =ov40_0224549C
	ldr r2, _0223C708 ; =ov40_0223CF70
	mov r1, #2
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C6E2
_0223C5E0:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C6E2
_0223C642:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223C684
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	add r0, r4, #0
	bl ov40_0223CD14
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223C684:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223C6E2
_0223C69E:
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x6d
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C6E2
_0223C6BC:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _0223C6E2
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223C6E2
_0223C6CC:
	ldr r0, _0223C70C ; =0x000006D8
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov40_0222C4B8
	add r0, r4, #0
	mov r1, #7
	bl ov40_0222BF80
_0223C6E2:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223C6E8: .word 0x00004138
_0223C6EC: .word 0x00002088
_0223C6F0: .word 0x000004A4
_0223C6F4: .word ov40_022454E0
_0223C6F8: .word ov40_0223CE64
_0223C6FC: .word ov40_022454B0
_0223C700: .word ov40_0223CF00
_0223C704: .word ov40_0224549C
_0223C708: .word ov40_0223CF70
_0223C70C: .word 0x000006D8
	thumb_func_end ov40_0223C498

	thumb_func_start ov40_0223C710
ov40_0223C710: ; 0x0223C710
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r4, r1, #0
	ldr r1, _0223C804 ; =0x000008A4
	add r5, r0, #0
	sub r1, #0x44
	ldr r6, [r5, r1]
	mov r1, #2
	bl ov40_0222C6C8
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, _0223C804 ; =0x000008A4
	add r0, r5, r0
	bl InitWindow
	mov r0, #0x13
	str r0, [sp]
	mov r0, #0x1e
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r1, _0223C804 ; =0x000008A4
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r5, r1
	mov r2, #2
	mov r3, #1
	bl AddWindowParameterized
	cmp r4, #0x64
	bne _0223C7C4
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	str r0, [sp, #0x14]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r6, r0, #0
	ldr r0, [sp, #0x14]
	mov r1, #0x6d
	bl sub_020315B8
	str r0, [sp, #0x18]
	ldr r1, [sp, #0x18]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r7, #0
	add r3, r1, #0
	bl BufferString
	add r0, r7, #0
	add r1, r6, #0
	add r2, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x18]
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
	b _0223C7CE
_0223C7C4:
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
_0223C7CE:
	ldr r0, _0223C804 ; =0x000008A4
	mov r1, #0xcc
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223C808 ; =0x000F0D0C
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0223C804 ; =0x000008A4
	add r3, r1, #0
	add r0, r5, r0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _0223C804 ; =0x000008A4
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add r0, r6, #0
	bl String_Delete
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0223C804: .word 0x000008A4
_0223C808: .word 0x000F0D0C
	thumb_func_end ov40_0223C710

	thumb_func_start ov40_0223C80C
ov40_0223C80C: ; 0x0223C80C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r5, [r4, r0]
	bl sub_020307F8
	mov r1, #4
	mov r2, #0
	bl sub_0203088C
	add r3, r0, #0
	add r2, r1, #0
	add r0, r4, #0
	add r1, r3, #0
	bl ov40_02230D94
	cmp r0, #0
	ldr r0, [r4, #8]
	bne _0223C838
	b _0223CB6C
_0223C838:
	cmp r0, #6
	bls _0223C83E
	b _0223CB3E
_0223C83E:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223C84A: ; jump table
	.short _0223C858 - _0223C84A - 2 ; case 0
	.short _0223C8BC - _0223C84A - 2 ; case 1
	.short _0223C91C - _0223C84A - 2 ; case 2
	.short _0223C92C - _0223C84A - 2 ; case 3
	.short _0223C964 - _0223C84A - 2 ; case 4
	.short _0223C9B4 - _0223C84A - 2 ; case 5
	.short _0223CAD4 - _0223C84A - 2 ; case 6
_0223C858:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223C874
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0223064C
	b _0223C880
_0223C874:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0222E7B8
_0223C880:
	add r0, r4, #0
	bl ov40_0223CCA0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223D504
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223CC98
_0223C8BC:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223C902
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223B374
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223C902:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223CC98
_0223C91C:
	ldr r1, _0223CC40 ; =0x00000115
	add r0, r4, #0
	bl ov40_0222DED0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223CC98
_0223C92C:
	bl System_GetTouchNew
	cmp r0, #0
	bne _0223C936
	b _0223CC98
_0223C936:
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223CC98
_0223C964:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223C99A
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223B44C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223C99A:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223CC98
_0223C9B4:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223A430
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, _0223CC44 ; =0x0000086C
	ldr r0, [r4, r0]
	cmp r0, #0xd2
	bne _0223CA0A
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	mov r0, #0x13
	lsl r0, r0, #4
	add r1, r4, #0
	add r0, r5, r0
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
_0223CA0A:
	add r0, r4, #0
	bl ov40_0223CD14
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223CA7C
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	b _0223CAAC
_0223CA7C:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0222E79C
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_0222E7DC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
_0223CAAC:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #6
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223CC98
_0223CAD4:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223CB24
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223CB02
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	b _0223CB0E
_0223CB02:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_0222E7DC
_0223CB0E:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223CB24:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223CC98
_0223CB3E:
	ldr r1, _0223CC48 ; =0x00004138
	mov r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0
	ble _0223CB62
	mov r1, #0x9a
	lsl r1, r1, #6
	add r5, r4, r1
	ldr r2, _0223CC48 ; =0x00004138
	add r6, r4, #0
	sub r1, #0x78
_0223CB54:
	str r5, [r6, r1]
	ldr r3, [r4, r2]
	add r0, r0, #1
	add r5, #0xe4
	add r6, r6, #4
	cmp r0, r3
	blt _0223CB54
_0223CB62:
	add r0, r4, #0
	mov r1, #7
	bl ov40_0222BF80
	b _0223CC98
_0223CB6C:
	cmp r0, #0
	beq _0223CB7A
	cmp r0, #1
	beq _0223CBDE
	cmp r0, #2
	beq _0223CC4C
	b _0223CC90
_0223CB7A:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, [r5, #0x10]
	cmp r0, #0
	bne _0223CB96
	mov r0, #0x22
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0223064C
	b _0223CBA2
_0223CB96:
	mov r0, #0x65
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0222E7B8
_0223CBA2:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223D504
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223CCA0
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223CC98
_0223CBDE:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223CC24
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0223B374
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223CC24:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223CC98
	nop
_0223CC40: .word 0x00000115
_0223CC44: .word 0x0000086C
_0223CC48: .word 0x00004138
_0223CC4C:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223CC76
	add r0, r4, #0
	mov r1, #0x64
	mov r2, #0
	bl ov40_0223C710
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223CC76:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223CC98
_0223CC90:
	add r0, r4, #0
	mov r1, #0xc
	bl ov40_0222BF80
_0223CC98:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov40_0223C80C

	thumb_func_start ov40_0223CCA0
ov40_0223CCA0: ; 0x0223CCA0
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	add r0, r4, #0
	add r0, #0x94
	bl ClearWindowTilemapAndCopyToVram
	add r4, #0x94
	add r0, r4, #0
	bl RemoveWindow
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_0223CCA0

	thumb_func_start ov40_0223CCBC
ov40_0223CCBC: ; 0x0223CCBC
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	add r6, r1, #0
	add r4, #0x94
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	add r1, r6, #0
	bl NewString_ReadMsgData
	add r5, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223CD10 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0223CD10: .word 0x000F0D00
	thumb_func_end ov40_0223CCBC

	thumb_func_start ov40_0223CD14
ov40_0223CD14: ; 0x0223CD14
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	add r6, r4, #0
	add r6, #0x94
	add r0, r6, #0
	bl InitWindow
	mov r0, #3
	str r0, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r6, #0
	mov r2, #6
	mov r3, #8
	bl AddWindowParameterized
	ldr r1, [r4, #0x10]
	add r0, r5, #0
	add r1, #0x79
	bl ov40_0223CCBC
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov40_0223CD14

	thumb_func_start ov40_0223CD58
ov40_0223CD58: ; 0x0223CD58
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	add r6, r4, #0
	add r6, #0x94
	add r0, r6, #0
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r6, #0
	mov r3, #4
	bl AddWindowParameterized
	add r0, r6, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x82
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r0, r6, #0
	add r1, r7, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223CE34 ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r6, #0
	bl ScheduleWindowCopyToVram
	add r4, #0xa4
	add r0, r4, #0
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x15
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, #0
	mov r3, #0x12
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x83
	bl NewString_ReadMsgData
	add r5, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223CE34 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0223CE34: .word 0x000F0D00
	thumb_func_end ov40_0223CD58

	thumb_func_start ov40_0223CE38
ov40_0223CE38: ; 0x0223CE38
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	add r0, r4, #0
	add r0, #0x94
	bl ClearWindowTilemapAndCopyToVram
	add r0, r4, #0
	add r0, #0x94
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0xa4
	bl ClearWindowTilemapAndCopyToVram
	add r4, #0xa4
	add r0, r4, #0
	bl RemoveWindow
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_0223CE38

	thumb_func_start ov40_0223CE64
ov40_0223CE64: ; 0x0223CE64
	push {r3, r4, r5, lr}
	add r4, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r5, [r4, r2]
	cmp r1, #0
	bne _0223CEF8
	cmp r0, #3
	bhi _0223CEF8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223CE82: ; jump table
	.short _0223CE8A - _0223CE82 - 2 ; case 0
	.short _0223CE9A - _0223CE82 - 2 ; case 1
	.short _0223CEC2 - _0223CE82 - 2 ; case 2
	.short _0223CEEA - _0223CE82 - 2 ; case 3
_0223CE8A:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_0223CE9A:
	add r0, r4, #0
	bl ov40_02230944
	bl sub_0202FC48
	cmp r0, #0
	beq _0223CEB2
	add r0, r4, #0
	mov r1, #9
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_0223CEB2:
	ldr r0, _0223CEFC ; =0x00002034
	mov r1, #9
	str r1, [r5, r0]
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_0223CEC2:
	add r0, r4, #0
	bl ov40_02230944
	bl sub_0202FC48
	cmp r0, #0
	beq _0223CEDA
	add r0, r4, #0
	mov r1, #0xb
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_0223CEDA:
	ldr r0, _0223CEFC ; =0x00002034
	mov r1, #0xb
	str r1, [r5, r0]
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_0223CEEA:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0xa
	bl ov40_0222BF80
_0223CEF8:
	pop {r3, r4, r5, pc}
	nop
_0223CEFC: .word 0x00002034
	thumb_func_end ov40_0223CE64

	thumb_func_start ov40_0223CF00
ov40_0223CF00: ; 0x0223CF00
	push {r4, lr}
	add r4, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r3, [r4, r2]
	cmp r1, #0
	bne _0223CF68
	cmp r0, #3
	bhi _0223CF68
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223CF1E: ; jump table
	.short _0223CF26 - _0223CF1E - 2 ; case 0
	.short _0223CF26 - _0223CF1E - 2 ; case 1
	.short _0223CF26 - _0223CF1E - 2 ; case 2
	.short _0223CF54 - _0223CF1E - 2 ; case 3
_0223CF26:
	add r1, r0, #1
	ldr r0, _0223CF6C ; =0x00002028
	add r2, #0x2c
	str r1, [r3, r0]
	ldr r0, [r3, r0]
	lsl r0, r0, #2
	add r0, r4, r0
	ldr r0, [r0, r2]
	cmp r0, #0
	beq _0223CF44
	add r0, r4, #0
	mov r1, #0xe
	bl ov40_0222BF80
	b _0223CF4C
_0223CF44:
	add r0, r4, #0
	mov r1, #0x11
	bl ov40_0222BF80
_0223CF4C:
	add r0, r4, #0
	bl ov40_02230944
	pop {r4, pc}
_0223CF54:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	bl ov40_0222DEAC
	add r0, r4, #0
	mov r1, #0xd
	bl ov40_0222BF80
_0223CF68:
	pop {r4, pc}
	nop
_0223CF6C: .word 0x00002028
	thumb_func_end ov40_0223CF00

	thumb_func_start ov40_0223CF70
ov40_0223CF70: ; 0x0223CF70
	push {r4, lr}
	add r4, r2, #0
	cmp r1, #0
	bne _0223CFA6
	cmp r0, #0
	beq _0223CF82
	cmp r0, #1
	beq _0223CF98
	pop {r4, pc}
_0223CF82:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	bl ov40_0223CE38
	add r0, r4, #0
	mov r1, #0x11
	bl ov40_0222BF80
	pop {r4, pc}
_0223CF98:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0x10
	bl ov40_0222BF80
_0223CFA6:
	pop {r4, pc}
	thumb_func_end ov40_0223CF70

	thumb_func_start ov40_0223CFA8
ov40_0223CFA8: ; 0x0223CFA8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	mov r0, #0x6d
	bl sub_020314A4
	mov r1, #0x65
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, _0223D000 ; =0x000004D4
	ldr r1, [r4, r1]
	ldr r0, [r5, r0]
	lsl r0, r0, #2
	add r2, r5, r0
	ldr r0, _0223D004 ; =0x00002608
	ldr r0, [r2, r0]
	bl ov39_022271C0
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	add r0, #0x8c
	str r1, [r4, r0]
	mov r0, #0x6d
	bl sub_02030920
	mov r1, #0x89
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, _0223D000 ; =0x000004D4
	ldr r1, [r4, r1]
	ldr r0, [r5, r0]
	lsl r0, r0, #2
	add r2, r5, r0
	ldr r0, _0223D004 ; =0x00002608
	ldr r0, [r2, r0]
	mov r2, #0x64
	add r0, #0x80
	bl MI_CpuCopy8
	pop {r3, r4, r5, pc}
	nop
_0223D000: .word 0x000004D4
_0223D004: .word 0x00002608
	thumb_func_end ov40_0223CFA8

	thumb_func_start ov40_0223D008
ov40_0223D008: ; 0x0223D008
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x80
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #8]
	ldr r0, [r0, r1]
	ldr r1, _0223D194 ; =0x000004A4
	str r0, [sp, #0x14]
	ldr r0, [sp, #8]
	ldr r5, _0223D198 ; =ov40_0224554C
	ldrsh r2, [r0, r1]
	add r4, sp, #0x50
	mov r3, #6
_0223D022:
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	sub r3, r3, #1
	bne _0223D022
	mov r1, #0
	add r0, sp, #0x38
	str r1, [r0]
	str r1, [r0, #4]
	str r1, [r0, #8]
	str r1, [r0, #0xc]
	str r1, [r0, #0x10]
	str r1, [r0, #0x14]
	add r0, sp, #0x20
	str r1, [r0]
	str r1, [r0, #4]
	str r1, [r0, #8]
	str r1, [r0, #0xc]
	str r1, [r0, #0x10]
	str r1, [r0, #0x14]
	str r1, [sp, #0x18]
	ldr r0, [sp, #8]
	lsl r1, r2, #2
	add r0, r0, r1
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	str r0, [sp, #0xc]
_0223D056:
	ldr r1, _0223D19C ; =0x00002608
	ldr r0, [sp, #0x10]
	ldr r0, [r0, r1]
	cmp r0, #0
	bne _0223D062
	b _0223D170
_0223D062:
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223D070
	mov r0, #1
	b _0223D072
_0223D070:
	mov r0, #0
_0223D072:
	mov r7, #0
	add r1, r7, #0
	add r2, sp, #0x38
	add r4, sp, #0x20
	add r3, r7, #0
_0223D07C:
	stmia r2!, {r3}
	add r1, r1, #1
	stmia r4!, {r3}
	cmp r1, #6
	blt _0223D07C
	mov r1, #0x18
	mul r1, r0
	add r0, sp, #0x50
	str r1, [sp, #0x1c]
	add r0, r0, r1
	add r1, sp, #0x38
	add r2, sp, #0x20
_0223D094:
	ldr r5, [sp, #0x10]
	ldr r4, _0223D19C ; =0x00002608
	ldr r6, [r0]
	ldr r5, [r5, r4]
	lsl r4, r6, #1
	add r4, r5, r4
	add r4, #0x80
	ldrh r4, [r4]
	cmp r4, #0
	beq _0223D0BA
	stmia r1!, {r4}
	ldr r5, [sp, #0x10]
	ldr r4, _0223D19C ; =0x00002608
	add r7, r7, #1
	ldr r4, [r5, r4]
	add r4, r4, r6
	add r4, #0x98
	ldrb r4, [r4]
	stmia r2!, {r4}
_0223D0BA:
	add r3, r3, #1
	add r0, r0, #4
	cmp r3, #3
	blt _0223D094
	ldr r1, _0223D19C ; =0x00002608
	ldr r0, [sp, #0x10]
	ldr r0, [r0, r1]
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223D0D4
	mov r7, #3
_0223D0D4:
	ldr r0, [sp, #0x1c]
	add r1, sp, #0x50
	add r0, r1, r0
	lsl r4, r7, #2
	add r1, sp, #0x38
	add r2, sp, #0x20
	mov r3, #3
	add r0, #0xc
	add r1, r1, r4
	add r2, r2, r4
_0223D0E8:
	ldr r5, [sp, #0x10]
	ldr r4, _0223D19C ; =0x00002608
	ldr r6, [r0]
	ldr r5, [r5, r4]
	lsl r4, r6, #1
	add r4, r5, r4
	add r4, #0x80
	ldrh r4, [r4]
	cmp r4, #0
	beq _0223D10E
	stmia r1!, {r4}
	ldr r5, [sp, #0x10]
	ldr r4, _0223D19C ; =0x00002608
	add r7, r7, #1
	ldr r4, [r5, r4]
	add r4, r4, r6
	add r4, #0x98
	ldrb r4, [r4]
	stmia r2!, {r4}
_0223D10E:
	add r3, r3, #1
	add r0, r0, #4
	cmp r3, #6
	blt _0223D0E8
	ldr r5, [sp, #0xc]
	mov r7, #0
	add r6, sp, #0x38
	add r4, sp, #0x20
_0223D11E:
	ldr r2, [sp, #0x14]
	ldr r1, _0223D1A0 ; =0x00002088
	ldr r3, [r6]
	ldr r2, [r2, r1]
	ldr r0, [r4]
	add r1, r1, #4
	str r2, [r5, r1]
	str r0, [sp]
	mov r0, #0
	mov r1, #0x82
	str r0, [sp, #4]
	ldr r2, [sp, #0x14]
	lsl r1, r1, #6
	ldr r1, [r2, r1]
	ldr r2, _0223D1A4 ; =0x0000208C
	ldr r0, [sp, #8]
	ldr r2, [r5, r2]
	bl ov40_0222FEA0
	ldr r1, _0223D1A8 ; =0x00002090
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0223D158
	mov r1, #6
	sub r1, r1, r7
	bl ManagedSprite_SetDrawPriority
_0223D158:
	ldr r1, [sp, #0x14]
	ldr r0, _0223D1A0 ; =0x00002088
	add r7, r7, #1
	ldr r0, [r1, r0]
	add r6, r6, #4
	add r2, r0, #1
	ldr r0, _0223D1A0 ; =0x00002088
	add r4, r4, #4
	add r5, #8
	str r2, [r1, r0]
	cmp r7, #6
	blt _0223D11E
_0223D170:
	ldr r0, [sp, #0x10]
	add r0, r0, #4
	str r0, [sp, #0x10]
	ldr r0, [sp, #0xc]
	add r0, #0x30
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x18]
	add r0, r0, #1
	str r0, [sp, #0x18]
	cmp r0, #5
	bge _0223D188
	b _0223D056
_0223D188:
	ldr r0, [sp, #8]
	bl ov40_0223A3BC
	add sp, #0x80
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223D194: .word 0x000004A4
_0223D198: .word ov40_0224554C
_0223D19C: .word 0x00002608
_0223D1A0: .word 0x00002088
_0223D1A4: .word 0x0000208C
_0223D1A8: .word 0x00002090
	thumb_func_end ov40_0223D008

	thumb_func_start ov40_0223D1AC
ov40_0223D1AC: ; 0x0223D1AC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r1, #0
	mov r1, #0
	str r1, [sp, #4]
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	ldr r7, _0223D1EC ; =0x00002090
	str r0, [sp]
_0223D1C0:
	ldr r5, [sp]
	mov r4, #0
_0223D1C4:
	ldr r0, [r5, r7]
	cmp r0, #0
	beq _0223D1D0
	add r1, r6, #0
	bl ManagedSprite_SetDrawFlag
_0223D1D0:
	add r4, r4, #1
	add r5, #8
	cmp r4, #6
	blt _0223D1C4
	ldr r0, [sp]
	add r0, #0x30
	str r0, [sp]
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #5
	blt _0223D1C0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223D1EC: .word 0x00002090
	thumb_func_end ov40_0223D1AC

	thumb_func_start ov40_0223D1F0
ov40_0223D1F0: ; 0x0223D1F0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r0, #0
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	mov r7, #0
	str r0, [sp]
_0223D204:
	ldr r5, [sp]
	mov r4, #0
_0223D208:
	ldr r0, _0223D23C ; =0x00002090
	ldr r2, [r5, r0]
	cmp r2, #0
	beq _0223D21E
	ldr r1, _0223D240 ; =0x0000208C
	add r0, r6, #0
	ldr r1, [r5, r1]
	bl ov40_0222FF48
	ldr r0, _0223D23C ; =0x00002090
	str r7, [r5, r0]
_0223D21E:
	add r4, r4, #1
	add r5, #8
	cmp r4, #6
	blt _0223D208
	ldr r0, [sp]
	add r0, #0x30
	str r0, [sp]
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #5
	blt _0223D204
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223D23C: .word 0x00002090
_0223D240: .word 0x0000208C
	thumb_func_end ov40_0223D1F0

	thumb_func_start ov40_0223D244
ov40_0223D244: ; 0x0223D244
	push {r4, r5, r6, r7, lr}
	sub sp, #0xa4
	mov r1, #0
	str r1, [sp, #0x20]
	ldr r2, [sp, #0x20]
	add r1, sp, #0x8c
	str r2, [r1]
	str r2, [r1, #4]
	str r2, [r1, #8]
	str r2, [r1, #0xc]
	str r2, [r1, #0x10]
	str r2, [r1, #0x14]
	mov r2, #0x86
	lsl r2, r2, #4
	add r1, r0, #0
	ldr r1, [r1, r2]
	ldr r2, _0223D4E0 ; =0x00002084
	str r1, [sp, #0x1c]
	ldr r3, [r1, r2]
	ldr r2, _0223D4E4 ; =0x000004A4
	add r1, r0, #0
	ldrsh r1, [r1, r2]
	str r0, [sp, #8]
	cmp r3, r1
	bne _0223D278
	b _0223D4DA
_0223D278:
	mov r1, #1
	bl ov40_02230964
	ldr r1, _0223D4E0 ; =0x00002084
	ldr r0, [sp, #0x1c]
	ldr r2, [r0, r1]
	ldr r1, _0223D4E4 ; =0x000004A4
	ldr r0, [sp, #8]
	ldrsh r0, [r0, r1]
	cmp r2, r0
	ble _0223D292
	mov r0, #4
	str r0, [sp, #0x20]
_0223D292:
	ldr r0, [sp, #0x20]
	mov r1, #0x30
	mul r1, r0
	ldr r0, [sp, #0x1c]
	mov r6, #0
	add r4, r0, r1
	add r5, sp, #0x8c
	add r7, r6, #0
_0223D2A2:
	ldr r0, _0223D4E8 ; =0x00002090
	ldr r2, [r4, r0]
	cmp r2, #0
	beq _0223D2BE
	ldr r1, _0223D4EC ; =0x0000208C
	ldr r0, [sp, #8]
	ldr r1, [r4, r1]
	bl ov40_0222FF64
	ldr r0, _0223D4EC ; =0x0000208C
	ldr r0, [r4, r0]
	str r0, [r5]
	ldr r0, _0223D4E8 ; =0x00002090
	str r7, [r4, r0]
_0223D2BE:
	add r6, r6, #1
	add r4, #8
	add r5, r5, #4
	cmp r6, #6
	blt _0223D2A2
	ldr r0, [sp, #0x20]
	cmp r0, #0
	beq _0223D308
	ldr r2, _0223D4F0 ; =0x00002060
	ldr r7, [sp, #0x1c]
	mov r0, #4
	add r3, r2, #0
	add r5, r2, #0
	str r0, [sp, #0xc]
	add r7, #0xc0
	add r3, #0x30
	sub r4, r2, #4
	add r5, #0x2c
_0223D2E2:
	mov r0, #0
	add r1, r7, #0
_0223D2E6:
	ldr r6, [r1, r2]
	add r0, r0, #1
	str r6, [r1, r3]
	ldr r6, [r1, r4]
	str r6, [r1, r5]
	add r1, #8
	cmp r0, #6
	blt _0223D2E6
	ldr r0, [sp, #0xc]
	sub r7, #0x30
	sub r0, r0, #1
	str r0, [sp, #0xc]
	cmp r0, #1
	bge _0223D2E2
	mov r0, #0
	str r0, [sp, #0x10]
	b _0223D340
_0223D308:
	ldr r6, _0223D4E8 ; =0x00002090
	ldr r7, [sp, #0x1c]
	mov r0, #1
	add r2, r6, #0
	add r4, r6, #0
	mov ip, r0
	add r7, #0x30
	sub r2, #0x30
	sub r3, r6, #4
	sub r4, #0x34
_0223D31C:
	mov r1, #0
	add r0, r7, #0
_0223D320:
	ldr r5, [r0, r6]
	add r1, r1, #1
	str r5, [r0, r2]
	ldr r5, [r0, r3]
	str r5, [r0, r4]
	add r0, #8
	cmp r1, #6
	blt _0223D320
	mov r0, ip
	add r0, r0, #1
	add r7, #0x30
	mov ip, r0
	cmp r0, #5
	blt _0223D31C
	mov r0, #4
	str r0, [sp, #0x10]
_0223D340:
	ldr r1, _0223D4E4 ; =0x000004A4
	ldr r0, [sp, #8]
	ldr r5, _0223D4F4 ; =ov40_0224551C
	ldrsh r1, [r0, r1]
	ldr r0, [sp, #0x10]
	add r4, sp, #0x5c
	add r2, r1, r0
	mov r3, #6
_0223D350:
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	sub r3, r3, #1
	bne _0223D350
	add r0, sp, #0x44
	mov r4, #0
	str r4, [r0]
	str r4, [r0, #4]
	str r4, [r0, #8]
	str r4, [r0, #0xc]
	str r4, [r0, #0x10]
	str r4, [r0, #0x14]
	add r0, sp, #0x2c
	str r4, [r0]
	str r4, [r0, #4]
	str r4, [r0, #8]
	str r4, [r0, #0xc]
	str r4, [r0, #0x10]
	str r4, [r0, #0x14]
	lsl r0, r2, #2
	str r0, [sp, #0x14]
	ldr r1, _0223D4F8 ; =0x00002608
	ldr r0, [sp, #8]
	add r1, r0, r1
	ldr r0, [sp, #0x14]
	str r1, [sp, #0x24]
	ldr r0, [r1, r0]
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223D392
	mov r4, #1
_0223D392:
	mov r0, #0
	str r0, [sp, #0x18]
	add r1, sp, #0x44
	add r2, sp, #0x2c
	add r6, r0, #0
_0223D39C:
	stmia r1!, {r6}
	add r0, r0, #1
	stmia r2!, {r6}
	cmp r0, #6
	blt _0223D39C
	mov r0, #0x18
	mul r0, r4
	add r1, sp, #0x5c
	add r2, r1, r0
	str r0, [sp, #0x28]
	ldr r1, [sp, #8]
	ldr r0, [sp, #0x14]
	add r3, sp, #0x44
	add r5, sp, #0x2c
	add r4, r1, r0
_0223D3BA:
	ldr r0, _0223D4F8 ; =0x00002608
	ldr r7, [r2]
	ldr r1, [r4, r0]
	lsl r0, r7, #1
	add r0, r1, r0
	add r0, #0x80
	ldrh r0, [r0]
	cmp r0, #0
	beq _0223D3E0
	stmia r3!, {r0}
	ldr r0, _0223D4F8 ; =0x00002608
	ldr r0, [r4, r0]
	add r0, r0, r7
	add r0, #0x98
	ldrb r0, [r0]
	stmia r5!, {r0}
	ldr r0, [sp, #0x18]
	add r0, r0, #1
	str r0, [sp, #0x18]
_0223D3E0:
	add r6, r6, #1
	add r2, r2, #4
	cmp r6, #3
	blt _0223D3BA
	ldr r1, [sp, #0x24]
	ldr r0, [sp, #0x14]
	ldr r0, [r1, r0]
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223D3FC
	mov r0, #3
	str r0, [sp, #0x18]
_0223D3FC:
	ldr r0, [sp, #0x28]
	add r1, sp, #0x5c
	add r2, r1, r0
	ldr r0, [sp, #0x18]
	mov r6, #3
	lsl r1, r0, #2
	add r0, sp, #0x44
	add r3, r0, r1
	add r0, sp, #0x2c
	add r2, #0xc
	add r5, r0, r1
_0223D412:
	ldr r0, _0223D4F8 ; =0x00002608
	ldr r7, [r2]
	ldr r1, [r4, r0]
	lsl r0, r7, #1
	add r0, r1, r0
	add r0, #0x80
	ldrh r0, [r0]
	cmp r0, #0
	beq _0223D438
	stmia r3!, {r0}
	ldr r0, _0223D4F8 ; =0x00002608
	ldr r0, [r4, r0]
	add r0, r0, r7
	add r0, #0x98
	ldrb r0, [r0]
	stmia r5!, {r0}
	ldr r0, [sp, #0x18]
	add r0, r0, #1
	str r0, [sp, #0x18]
_0223D438:
	add r6, r6, #1
	add r2, r2, #4
	cmp r6, #6
	blt _0223D412
	ldr r0, [sp, #0x10]
	mov r1, #0x30
	mul r1, r0
	ldr r0, [sp, #0x1c]
	mov r5, #0
	add r7, sp, #0x44
	add r6, sp, #0x2c
	add r4, r0, r1
_0223D450:
	ldr r2, [sp, #0x1c]
	ldr r1, _0223D4FC ; =0x00002088
	ldr r3, [r7]
	ldr r2, [r2, r1]
	ldr r0, [r6]
	add r1, r1, #4
	str r2, [r4, r1]
	str r0, [sp]
	mov r0, #0
	mov r1, #0x82
	str r0, [sp, #4]
	ldr r2, [sp, #0x1c]
	lsl r1, r1, #6
	ldr r1, [r2, r1]
	ldr r2, _0223D4EC ; =0x0000208C
	ldr r0, [sp, #8]
	ldr r2, [r4, r2]
	bl ov40_0222FEA0
	ldr r1, _0223D4E8 ; =0x00002090
	str r0, [r4, r1]
	add r0, r1, #0
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0223D48A
	mov r1, #6
	sub r1, r1, r5
	bl ManagedSprite_SetDrawPriority
_0223D48A:
	ldr r1, [sp, #0x1c]
	ldr r0, _0223D4FC ; =0x00002088
	add r5, r5, #1
	ldr r0, [r1, r0]
	add r7, r7, #4
	add r2, r0, #1
	ldr r0, _0223D4FC ; =0x00002088
	add r6, r6, #4
	add r4, #8
	str r2, [r1, r0]
	cmp r5, #6
	blt _0223D450
	ldr r0, [sp, #8]
	bl ov40_0223A3BC
	ldr r1, _0223D4E4 ; =0x000004A4
	ldr r0, [sp, #8]
	ldr r6, _0223D500 ; =0x000186A0
	ldrsh r2, [r0, r1]
	ldr r1, _0223D4E0 ; =0x00002084
	ldr r0, [sp, #0x1c]
	mov r5, #0
	str r2, [r0, r1]
	add r4, sp, #0x8c
_0223D4BA:
	ldr r1, [r4]
	cmp r1, #0
	beq _0223D4CA
	ldr r0, [sp, #8]
	add r1, r1, r6
	ldr r0, [r0, #0x1c]
	bl SpriteManager_UnloadCharObjById
_0223D4CA:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #6
	blt _0223D4BA
	ldr r0, [sp, #8]
	mov r1, #0
	bl ov40_02230964
_0223D4DA:
	add sp, #0xa4
	pop {r4, r5, r6, r7, pc}
	nop
_0223D4E0: .word 0x00002084
_0223D4E4: .word 0x000004A4
_0223D4E8: .word 0x00002090
_0223D4EC: .word 0x0000208C
_0223D4F0: .word 0x00002060
_0223D4F4: .word ov40_0224551C
_0223D4F8: .word 0x00002608
_0223D4FC: .word 0x00002088
_0223D500: .word 0x000186A0
	thumb_func_end ov40_0223D244

	thumb_func_start ov40_0223D504
ov40_0223D504: ; 0x0223D504
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov40_0222D6D0
	mov r0, #0x13
	lsl r0, r0, #4
	add r0, r4, r0
	bl ov40_0222D6D0
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_DeleteAndFreeResources
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_DeleteAndFreeResources
	add r0, r5, #0
	bl ov40_0222D7DC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_0223D504

	thumb_func_start ov40_0223D540
ov40_0223D540: ; 0x0223D540
	add r0, #0x68
	bx lr
	thumb_func_end ov40_0223D540

	thumb_func_start ov40_0223D544
ov40_0223D544: ; 0x0223D544
	push {r4, lr}
	sub sp, #0x40
	add r4, r0, #0
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl Save_SysInfo_Get
	bl Save_SysInfo_GetDwcProfileId
	str r0, [sp]
	mov r0, #0x6d
	str r0, [sp, #4]
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	add r1, sp, #0
	str r0, [sp, #8]
	ldr r0, _0223D5A4 ; =ov40_02236158
	str r4, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, _0223D5A8 ; =ov40_0223615C
	str r4, [sp, #0x3c]
	str r0, [sp, #0x14]
	ldr r0, _0223D5AC ; =ov40_02238EB8
	add r4, #0x68
	str r0, [sp, #0x18]
	ldr r0, _0223D5B0 ; =ov40_02238EBC
	str r0, [sp, #0x1c]
	ldr r0, _0223D5B4 ; =ov40_0223A324
	str r0, [sp, #0x20]
	ldr r0, _0223D5B8 ; =ov40_0223A360
	str r0, [sp, #0x24]
	ldr r0, _0223D5BC ; =ov40_02242DF0
	str r0, [sp, #0x28]
	ldr r0, _0223D5C0 ; =ov40_0222FC4C
	str r0, [sp, #0x2c]
	ldr r0, _0223D5C4 ; =ov40_02242E14
	str r0, [sp, #0x30]
	ldr r0, _0223D5C8 ; =ov40_02242E48
	str r0, [sp, #0x34]
	mov r0, #0
	str r0, [sp, #0x38]
	add r0, r4, #0
	bl ov39_02227208
	add sp, #0x40
	pop {r4, pc}
	.balign 4, 0
_0223D5A4: .word ov40_02236158
_0223D5A8: .word ov40_0223615C
_0223D5AC: .word ov40_02238EB8
_0223D5B0: .word ov40_02238EBC
_0223D5B4: .word ov40_0223A324
_0223D5B8: .word ov40_0223A360
_0223D5BC: .word ov40_02242DF0
_0223D5C0: .word ov40_0222FC4C
_0223D5C4: .word ov40_02242E14
_0223D5C8: .word ov40_02242E48
	thumb_func_end ov40_0223D544

	thumb_func_start ov40_0223D5CC
ov40_0223D5CC: ; 0x0223D5CC
	push {r3, lr}
	mov r1, #0x42
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	cmp r1, #0
	bne _0223D5DC
	mov r0, #0
	pop {r3, pc}
_0223D5DC:
	bl ov40_0223D540
	bl ov39_02227DB8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223D5CC

	thumb_func_start ov40_0223D5E8
ov40_0223D5E8: ; 0x0223D5E8
	push {r3, lr}
	mov r1, #0x42
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	cmp r1, #0
	beq _0223D5FC
	bl ov40_0223D540
	bl ov39_02227778
_0223D5FC:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223D5E8

	thumb_func_start ov40_0223D600
ov40_0223D600: ; 0x0223D600
	push {r3, lr}
	mov r1, #0x42
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	cmp r1, #0
	beq _0223D614
	bl ov40_0223D540
	bl ov39_022272EC
_0223D614:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223D600

	thumb_func_start ov40_0223D618
ov40_0223D618: ; 0x0223D618
	push {r4, r5, r6, r7, lr}
	sub sp, #0x84
	ldr r4, _0223D684 ; =ov40_02245948
	add r3, sp, #0xc
	mov r2, #0x3c
_0223D622:
	ldrh r1, [r4]
	add r4, r4, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _0223D622
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	ldr r7, _0223D688 ; =0x0000051C
	str r0, [sp, #4]
	ldr r0, [sp, #8]
	str r0, [sp]
_0223D640:
	ldr r0, [sp]
	ldr r4, [sp, #4]
	lsl r1, r0, #2
	add r0, sp, #0xc
	mov r6, #0
	add r5, r0, r1
_0223D64C:
	ldr r0, [r4, r7]
	cmp r0, #0
	beq _0223D65E
	mov r1, #0
	mov r2, #2
	ldrsh r1, [r5, r1]
	ldrsh r2, [r5, r2]
	bl ManagedSprite_SetPositionXY
_0223D65E:
	add r6, r6, #1
	add r4, #8
	add r5, r5, #4
	cmp r6, #6
	blt _0223D64C
	ldr r0, [sp, #4]
	add r0, #0x30
	str r0, [sp, #4]
	ldr r0, [sp]
	add r0, r0, #6
	str r0, [sp]
	ldr r0, [sp, #8]
	add r0, r0, #1
	str r0, [sp, #8]
	cmp r0, #5
	blt _0223D640
	add sp, #0x84
	pop {r4, r5, r6, r7, pc}
	nop
_0223D684: .word ov40_02245948
_0223D688: .word 0x0000051C
	thumb_func_end ov40_0223D618

	thumb_func_start ov40_0223D68C
ov40_0223D68C: ; 0x0223D68C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x80
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #8]
	ldr r0, [r0, r1]
	ldr r4, _0223D814 ; =ov40_02245808
	str r0, [sp, #0x14]
	add r3, sp, #0x50
	mov r2, #6
_0223D6A0:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0223D6A0
	mov r0, #0
	add r1, sp, #0x38
	str r0, [r1]
	str r0, [r1, #4]
	str r0, [r1, #8]
	str r0, [r1, #0xc]
	str r0, [r1, #0x10]
	str r0, [r1, #0x14]
	add r1, sp, #0x20
	str r0, [r1]
	str r0, [r1, #4]
	str r0, [r1, #8]
	str r0, [r1, #0xc]
	str r0, [r1, #0x10]
	str r0, [r1, #0x14]
	str r0, [sp, #0x18]
	ldr r1, _0223D818 ; =0x000004A4
	ldr r0, [sp, #8]
	ldrsh r0, [r0, r1]
	lsl r1, r0, #2
	ldr r0, [sp, #8]
	add r0, r0, r1
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	str r0, [sp, #0xc]
_0223D6DA:
	ldr r1, _0223D81C ; =0x00002608
	ldr r0, [sp, #0x10]
	ldr r0, [r0, r1]
	cmp r0, #0
	bne _0223D6E6
	b _0223D7F2
_0223D6E6:
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223D6F4
	mov r0, #1
	b _0223D6F6
_0223D6F4:
	mov r0, #0
_0223D6F6:
	mov r7, #0
	add r1, r7, #0
	add r2, sp, #0x38
	add r4, sp, #0x20
	add r3, r7, #0
_0223D700:
	stmia r2!, {r3}
	add r1, r1, #1
	stmia r4!, {r3}
	cmp r1, #6
	blt _0223D700
	mov r1, #0x18
	mul r1, r0
	add r0, sp, #0x50
	str r1, [sp, #0x1c]
	add r0, r0, r1
	add r1, sp, #0x38
	add r2, sp, #0x20
_0223D718:
	ldr r5, [sp, #0x10]
	ldr r4, _0223D81C ; =0x00002608
	ldr r6, [r0]
	ldr r5, [r5, r4]
	lsl r4, r6, #1
	add r4, r5, r4
	add r4, #0x80
	ldrh r4, [r4]
	cmp r4, #0
	beq _0223D73E
	stmia r1!, {r4}
	ldr r5, [sp, #0x10]
	ldr r4, _0223D81C ; =0x00002608
	add r7, r7, #1
	ldr r4, [r5, r4]
	add r4, r4, r6
	add r4, #0x98
	ldrb r4, [r4]
	stmia r2!, {r4}
_0223D73E:
	add r3, r3, #1
	add r0, r0, #4
	cmp r3, #3
	blt _0223D718
	ldr r1, _0223D81C ; =0x00002608
	ldr r0, [sp, #0x10]
	ldr r0, [r0, r1]
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223D758
	mov r7, #3
_0223D758:
	ldr r0, [sp, #0x1c]
	add r1, sp, #0x50
	add r0, r1, r0
	lsl r4, r7, #2
	add r1, sp, #0x38
	add r2, sp, #0x20
	mov r3, #3
	add r0, #0xc
	add r1, r1, r4
	add r2, r2, r4
_0223D76C:
	ldr r5, [sp, #0x10]
	ldr r4, _0223D81C ; =0x00002608
	ldr r6, [r0]
	ldr r5, [r5, r4]
	lsl r4, r6, #1
	add r4, r5, r4
	add r4, #0x80
	ldrh r4, [r4]
	cmp r4, #0
	beq _0223D792
	stmia r1!, {r4}
	ldr r5, [sp, #0x10]
	ldr r4, _0223D81C ; =0x00002608
	add r7, r7, #1
	ldr r4, [r5, r4]
	add r4, r4, r6
	add r4, #0x98
	ldrb r4, [r4]
	stmia r2!, {r4}
_0223D792:
	add r3, r3, #1
	add r0, r0, #4
	cmp r3, #6
	blt _0223D76C
	ldr r5, [sp, #0xc]
	mov r7, #0
	add r6, sp, #0x38
	add r4, sp, #0x20
_0223D7A2:
	ldr r2, [sp, #0x14]
	ldr r1, _0223D820 ; =0x00000514
	ldr r3, [r6]
	ldr r2, [r2, r1]
	ldr r0, [r4]
	add r1, r1, #4
	str r2, [r5, r1]
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x14]
	ldr r1, _0223D824 ; =0x0000050C
	ldr r0, [sp, #8]
	ldr r1, [r2, r1]
	ldr r2, _0223D828 ; =0x00000518
	ldr r2, [r5, r2]
	bl ov40_0222FEA0
	ldr r1, _0223D82C ; =0x0000051C
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0223D7DA
	mov r1, #6
	sub r1, r1, r7
	bl ManagedSprite_SetDrawPriority
_0223D7DA:
	ldr r1, [sp, #0x14]
	ldr r0, _0223D820 ; =0x00000514
	add r7, r7, #1
	ldr r0, [r1, r0]
	add r6, r6, #4
	add r2, r0, #1
	ldr r0, _0223D820 ; =0x00000514
	add r4, r4, #4
	add r5, #8
	str r2, [r1, r0]
	cmp r7, #6
	blt _0223D7A2
_0223D7F2:
	ldr r0, [sp, #0x10]
	add r0, r0, #4
	str r0, [sp, #0x10]
	ldr r0, [sp, #0xc]
	add r0, #0x30
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x18]
	add r0, r0, #1
	str r0, [sp, #0x18]
	cmp r0, #5
	bge _0223D80A
	b _0223D6DA
_0223D80A:
	ldr r0, [sp, #8]
	bl ov40_0223D618
	add sp, #0x80
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223D814: .word ov40_02245808
_0223D818: .word 0x000004A4
_0223D81C: .word 0x00002608
_0223D820: .word 0x00000514
_0223D824: .word 0x0000050C
_0223D828: .word 0x00000518
_0223D82C: .word 0x0000051C
	thumb_func_end ov40_0223D68C

	thumb_func_start ov40_0223D830
ov40_0223D830: ; 0x0223D830
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r1, #0
	mov r1, #0
	str r1, [sp, #4]
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	ldr r7, _0223D870 ; =0x0000051C
	str r0, [sp]
_0223D844:
	ldr r5, [sp]
	mov r4, #0
_0223D848:
	ldr r0, [r5, r7]
	cmp r0, #0
	beq _0223D854
	add r1, r6, #0
	bl ManagedSprite_SetDrawFlag
_0223D854:
	add r4, r4, #1
	add r5, #8
	cmp r4, #6
	blt _0223D848
	ldr r0, [sp]
	add r0, #0x30
	str r0, [sp]
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #5
	blt _0223D844
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223D870: .word 0x0000051C
	thumb_func_end ov40_0223D830

	thumb_func_start ov40_0223D874
ov40_0223D874: ; 0x0223D874
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	mov r1, #0x86
	add r6, r0, #0
	lsl r1, r1, #4
	ldr r1, [r6, r1]
	str r1, [sp]
	mov r1, #1
	bl ov40_02230964
	mov r0, #0
	str r0, [sp, #4]
	add r7, r0, #0
_0223D88E:
	ldr r5, [sp]
	mov r4, #0
_0223D892:
	ldr r0, _0223D8CC ; =0x0000051C
	ldr r2, [r5, r0]
	cmp r2, #0
	beq _0223D8A8
	ldr r1, _0223D8D0 ; =0x00000518
	add r0, r6, #0
	ldr r1, [r5, r1]
	bl ov40_0222FF48
	ldr r0, _0223D8CC ; =0x0000051C
	str r7, [r5, r0]
_0223D8A8:
	add r4, r4, #1
	add r5, #8
	cmp r4, #6
	blt _0223D892
	ldr r0, [sp]
	add r0, #0x30
	str r0, [sp]
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #5
	blt _0223D88E
	add r0, r6, #0
	mov r1, #0
	bl ov40_02230964
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223D8CC: .word 0x0000051C
_0223D8D0: .word 0x00000518
	thumb_func_end ov40_0223D874

	thumb_func_start ov40_0223D8D4
ov40_0223D8D4: ; 0x0223D8D4
	push {r4, r5, r6, r7, lr}
	sub sp, #0xa4
	mov r1, #0
	str r1, [sp, #0x20]
	ldr r2, [sp, #0x20]
	add r1, sp, #0x8c
	str r2, [r1]
	str r2, [r1, #4]
	str r2, [r1, #8]
	str r2, [r1, #0xc]
	str r2, [r1, #0x10]
	str r2, [r1, #0x14]
	mov r2, #0x86
	lsl r2, r2, #4
	add r1, r0, #0
	ldr r1, [r1, r2]
	mov r2, #0x51
	lsl r2, r2, #4
	ldr r3, [r1, r2]
	str r1, [sp, #0x1c]
	sub r2, #0x6c
	add r1, r0, #0
	ldrsh r1, [r1, r2]
	str r0, [sp, #8]
	cmp r3, r1
	bne _0223D90A
	b _0223DB6C
_0223D90A:
	mov r1, #1
	bl ov40_02230964
	mov r1, #0x51
	ldr r0, [sp, #0x1c]
	lsl r1, r1, #4
	ldr r2, [r0, r1]
	ldr r0, [sp, #8]
	sub r1, #0x6c
	ldrsh r0, [r0, r1]
	cmp r2, r0
	ble _0223D926
	mov r0, #4
	str r0, [sp, #0x20]
_0223D926:
	ldr r0, [sp, #0x20]
	mov r1, #0x30
	mul r1, r0
	ldr r0, [sp, #0x1c]
	mov r6, #0
	add r4, r0, r1
	add r5, sp, #0x8c
	add r7, r6, #0
_0223D936:
	ldr r0, _0223DB70 ; =0x0000051C
	ldr r2, [r4, r0]
	cmp r2, #0
	beq _0223D952
	ldr r1, _0223DB74 ; =0x00000518
	ldr r0, [sp, #8]
	ldr r1, [r4, r1]
	bl ov40_0222FF64
	ldr r0, _0223DB74 ; =0x00000518
	ldr r0, [r4, r0]
	str r0, [r5]
	ldr r0, _0223DB70 ; =0x0000051C
	str r7, [r4, r0]
_0223D952:
	add r6, r6, #1
	add r4, #8
	add r5, r5, #4
	cmp r6, #6
	blt _0223D936
	ldr r0, [sp, #0x20]
	cmp r0, #0
	beq _0223D99C
	ldr r2, _0223DB78 ; =0x000004EC
	ldr r7, [sp, #0x1c]
	mov r0, #4
	add r3, r2, #0
	add r5, r2, #0
	str r0, [sp, #0xc]
	add r7, #0xc0
	add r3, #0x30
	sub r4, r2, #4
	add r5, #0x2c
_0223D976:
	mov r0, #0
	add r1, r7, #0
_0223D97A:
	ldr r6, [r1, r2]
	add r0, r0, #1
	str r6, [r1, r3]
	ldr r6, [r1, r4]
	str r6, [r1, r5]
	add r1, #8
	cmp r0, #6
	blt _0223D97A
	ldr r0, [sp, #0xc]
	sub r7, #0x30
	sub r0, r0, #1
	str r0, [sp, #0xc]
	cmp r0, #1
	bge _0223D976
	mov r0, #0
	str r0, [sp, #0x10]
	b _0223D9D4
_0223D99C:
	ldr r6, _0223DB70 ; =0x0000051C
	ldr r7, [sp, #0x1c]
	mov r0, #1
	add r2, r6, #0
	add r4, r6, #0
	mov ip, r0
	add r7, #0x30
	sub r2, #0x30
	sub r3, r6, #4
	sub r4, #0x34
_0223D9B0:
	mov r1, #0
	add r0, r7, #0
_0223D9B4:
	ldr r5, [r0, r6]
	add r1, r1, #1
	str r5, [r0, r2]
	ldr r5, [r0, r3]
	str r5, [r0, r4]
	add r0, #8
	cmp r1, #6
	blt _0223D9B4
	mov r0, ip
	add r0, r0, #1
	add r7, #0x30
	mov ip, r0
	cmp r0, #5
	blt _0223D9B0
	mov r0, #4
	str r0, [sp, #0x10]
_0223D9D4:
	ldr r1, _0223DB7C ; =0x000004A4
	ldr r0, [sp, #8]
	ldr r5, _0223DB80 ; =ov40_02245838
	ldrsh r1, [r0, r1]
	ldr r0, [sp, #0x10]
	add r4, sp, #0x5c
	add r2, r1, r0
	mov r3, #6
_0223D9E4:
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	sub r3, r3, #1
	bne _0223D9E4
	add r0, sp, #0x44
	mov r4, #0
	str r4, [r0]
	str r4, [r0, #4]
	str r4, [r0, #8]
	str r4, [r0, #0xc]
	str r4, [r0, #0x10]
	str r4, [r0, #0x14]
	add r0, sp, #0x2c
	str r4, [r0]
	str r4, [r0, #4]
	str r4, [r0, #8]
	str r4, [r0, #0xc]
	str r4, [r0, #0x10]
	str r4, [r0, #0x14]
	lsl r0, r2, #2
	str r0, [sp, #0x14]
	ldr r1, _0223DB84 ; =0x00002608
	ldr r0, [sp, #8]
	add r1, r0, r1
	ldr r0, [sp, #0x14]
	str r1, [sp, #0x24]
	ldr r0, [r1, r0]
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223DA26
	mov r4, #1
_0223DA26:
	mov r0, #0
	str r0, [sp, #0x18]
	add r1, sp, #0x44
	add r2, sp, #0x2c
	add r6, r0, #0
_0223DA30:
	stmia r1!, {r6}
	add r0, r0, #1
	stmia r2!, {r6}
	cmp r0, #6
	blt _0223DA30
	mov r0, #0x18
	mul r0, r4
	add r1, sp, #0x5c
	add r2, r1, r0
	str r0, [sp, #0x28]
	ldr r1, [sp, #8]
	ldr r0, [sp, #0x14]
	add r3, sp, #0x44
	add r5, sp, #0x2c
	add r4, r1, r0
_0223DA4E:
	ldr r0, _0223DB84 ; =0x00002608
	ldr r7, [r2]
	ldr r1, [r4, r0]
	lsl r0, r7, #1
	add r0, r1, r0
	add r0, #0x80
	ldrh r0, [r0]
	cmp r0, #0
	beq _0223DA74
	stmia r3!, {r0}
	ldr r0, _0223DB84 ; =0x00002608
	ldr r0, [r4, r0]
	add r0, r0, r7
	add r0, #0x98
	ldrb r0, [r0]
	stmia r5!, {r0}
	ldr r0, [sp, #0x18]
	add r0, r0, #1
	str r0, [sp, #0x18]
_0223DA74:
	add r6, r6, #1
	add r2, r2, #4
	cmp r6, #3
	blt _0223DA4E
	ldr r1, [sp, #0x24]
	ldr r0, [sp, #0x14]
	ldr r0, [r1, r0]
	add r0, #0x80
	bl ov40_022303B8
	cmp r0, #0
	beq _0223DA90
	mov r0, #3
	str r0, [sp, #0x18]
_0223DA90:
	ldr r0, [sp, #0x28]
	add r1, sp, #0x5c
	add r2, r1, r0
	ldr r0, [sp, #0x18]
	mov r6, #3
	lsl r1, r0, #2
	add r0, sp, #0x44
	add r3, r0, r1
	add r0, sp, #0x2c
	add r2, #0xc
	add r5, r0, r1
_0223DAA6:
	ldr r0, _0223DB84 ; =0x00002608
	ldr r7, [r2]
	ldr r1, [r4, r0]
	lsl r0, r7, #1
	add r0, r1, r0
	add r0, #0x80
	ldrh r0, [r0]
	cmp r0, #0
	beq _0223DACC
	stmia r3!, {r0}
	ldr r0, _0223DB84 ; =0x00002608
	ldr r0, [r4, r0]
	add r0, r0, r7
	add r0, #0x98
	ldrb r0, [r0]
	stmia r5!, {r0}
	ldr r0, [sp, #0x18]
	add r0, r0, #1
	str r0, [sp, #0x18]
_0223DACC:
	add r6, r6, #1
	add r2, r2, #4
	cmp r6, #6
	blt _0223DAA6
	ldr r0, [sp, #0x10]
	mov r1, #0x30
	mul r1, r0
	ldr r0, [sp, #0x1c]
	mov r5, #0
	add r7, sp, #0x44
	add r6, sp, #0x2c
	add r4, r0, r1
_0223DAE4:
	ldr r2, [sp, #0x1c]
	ldr r1, _0223DB88 ; =0x00000514
	ldr r3, [r7]
	ldr r2, [r2, r1]
	ldr r0, [r6]
	add r1, r1, #4
	str r2, [r4, r1]
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x1c]
	ldr r1, _0223DB8C ; =0x0000050C
	ldr r0, [sp, #8]
	ldr r1, [r2, r1]
	ldr r2, _0223DB74 ; =0x00000518
	ldr r2, [r4, r2]
	bl ov40_0222FEA0
	ldr r1, _0223DB70 ; =0x0000051C
	str r0, [r4, r1]
	add r0, r1, #0
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0223DB1C
	mov r1, #6
	sub r1, r1, r5
	bl ManagedSprite_SetDrawPriority
_0223DB1C:
	ldr r1, [sp, #0x1c]
	ldr r0, _0223DB88 ; =0x00000514
	add r5, r5, #1
	ldr r0, [r1, r0]
	add r7, r7, #4
	add r2, r0, #1
	ldr r0, _0223DB88 ; =0x00000514
	add r6, r6, #4
	add r4, #8
	str r2, [r1, r0]
	cmp r5, #6
	blt _0223DAE4
	ldr r0, [sp, #8]
	bl ov40_0223D618
	ldr r1, _0223DB7C ; =0x000004A4
	ldr r0, [sp, #8]
	ldr r6, _0223DB90 ; =0x000186A0
	ldrsh r2, [r0, r1]
	ldr r0, [sp, #0x1c]
	add r1, #0x6c
	str r2, [r0, r1]
	mov r5, #0
	add r4, sp, #0x8c
_0223DB4C:
	ldr r1, [r4]
	cmp r1, #0
	beq _0223DB5C
	ldr r0, [sp, #8]
	add r1, r1, r6
	ldr r0, [r0, #0x1c]
	bl SpriteManager_UnloadCharObjById
_0223DB5C:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #6
	blt _0223DB4C
	ldr r0, [sp, #8]
	mov r1, #0
	bl ov40_02230964
_0223DB6C:
	add sp, #0xa4
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0223DB70: .word 0x0000051C
_0223DB74: .word 0x00000518
_0223DB78: .word 0x000004EC
_0223DB7C: .word 0x000004A4
_0223DB80: .word ov40_02245838
_0223DB84: .word 0x00002608
_0223DB88: .word 0x00000514
_0223DB8C: .word 0x0000050C
_0223DB90: .word 0x000186A0
	thumb_func_end ov40_0223D8D4

	thumb_func_start ov40_0223DB94
ov40_0223DB94: ; 0x0223DB94
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	mov r2, #0x13
	lsl r2, r2, #6
	ldrh r3, [r0, r2]
	ldr r1, _0223DBD0 ; =0x0000FFFF
	cmp r3, r1
	beq _0223DBAA
	mov r0, #1
	bx lr
_0223DBAA:
	add r1, r2, #2
	ldrb r1, [r0, r1]
	cmp r1, #0xff
	beq _0223DBB6
	mov r0, #1
	bx lr
_0223DBB6:
	add r1, r2, #3
	ldrb r1, [r0, r1]
	cmp r1, #0xff
	bne _0223DBC6
	add r1, r2, #4
	ldrb r0, [r0, r1]
	cmp r0, #0xff
	beq _0223DBCA
_0223DBC6:
	mov r0, #1
	bx lr
_0223DBCA:
	mov r0, #0
	bx lr
	nop
_0223DBD0: .word 0x0000FFFF
	thumb_func_end ov40_0223DB94

	thumb_func_start ov40_0223DBD4
ov40_0223DBD4: ; 0x0223DBD4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x9c
	add r3, r1, #0
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #0x14]
	ldr r0, [r0, r1]
	ldr r6, _0223DCDC ; =ov40_022458E8
	str r0, [sp, #0x20]
	add r4, sp, #0x3c
	mov r2, #0xc
_0223DBEA:
	ldmia r6!, {r0, r1}
	stmia r4!, {r0, r1}
	sub r2, r2, #1
	bne _0223DBEA
	ldr r6, _0223DCE0 ; =ov40_022456F0
	add r4, sp, #0x24
	add r2, r4, #0
	ldmia r6!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r6!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r6!, {r0, r1}
	stmia r4!, {r0, r1}
	cmp r3, #0
	beq _0223DC0C
	cmp r3, #1
	b _0223DC18
_0223DC0C:
	ldr r1, _0223DCE4 ; =0x00000794
	ldr r0, [sp, #0x20]
	mov r3, #6
	str r3, [r0, r1]
	add r5, sp, #0x3c
	str r2, [sp, #0x18]
_0223DC18:
	mov r0, #0
	str r0, [sp, #0x1c]
	ldr r1, _0223DCE4 ; =0x00000794
	ldr r0, [sp, #0x20]
	mov r7, #1
	ldr r0, [r0, r1]
	lsl r7, r7, #8
	cmp r0, #0
	ble _0223DCD8
	ldr r1, _0223DCE8 ; =0x00000614
	ldr r0, [sp, #0x20]
	add r4, r0, r1
_0223DC30:
	add r0, r4, #0
	bl InitWindow
	ldr r0, [r5, #4]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldr r0, [r5, #8]
	mov r2, #2
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	ldr r0, [r5, #0xc]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [r5]
	ldr r0, [r0, #0x24]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x18
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	ldr r0, [r0, #0x48]
	ldr r1, [r1]
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r1, [r5, #8]
	ldr r0, [r5, #0xc]
	mul r0, r1
	add r7, r7, r0
	mov r0, #0
	beq _0223DC94
	add r0, r4, #0
	add r1, r6, #0
	bl ov40_022306C0
_0223DC94:
	mov r0, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223DCEC ; =0x000F0D00
	mov r1, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	add r2, r6, #0
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add r0, r6, #0
	bl String_Delete
	ldr r0, [sp, #0x18]
	ldr r1, [sp, #0x20]
	add r0, r0, #4
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x1c]
	add r4, #0x10
	add r0, r0, #1
	str r0, [sp, #0x1c]
	ldr r0, _0223DCE4 ; =0x00000794
	add r5, #0x10
	ldr r1, [r1, r0]
	ldr r0, [sp, #0x1c]
	cmp r0, r1
	blt _0223DC30
_0223DCD8:
	add sp, #0x9c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0223DCDC: .word ov40_022458E8
_0223DCE0: .word ov40_022456F0
_0223DCE4: .word 0x00000794
_0223DCE8: .word 0x00000614
_0223DCEC: .word 0x000F0D00
	thumb_func_end ov40_0223DBD4

	thumb_func_start ov40_0223DCF0
ov40_0223DCF0: ; 0x0223DCF0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r6, [r5, r0]
	ldr r7, _0223DD60 ; =0x00000644
	add r4, r1, #0
	add r0, r6, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	cmp r4, #0xff
	bne _0223DD18
	ldr r0, [r5, #0x48]
	mov r1, #0x7d
	bl NewString_ReadMsgData
	add r4, r0, #0
	b _0223DD38
_0223DD18:
	add r0, r4, #0
	sub r0, #0xfa
	cmp r0, #3
	ldr r0, [r5, #0x48]
	bhi _0223DD2E
	sub r4, #0x55
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	b _0223DD38
_0223DD2E:
	add r4, #0x84
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
_0223DD38:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223DD64 ; =0x000F0D00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r6, r7
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, r7
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223DD60: .word 0x00000644
_0223DD64: .word 0x000F0D00
	thumb_func_end ov40_0223DCF0

	thumb_func_start ov40_0223DD68
ov40_0223DD68: ; 0x0223DD68
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x1fc
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r7, _0223DDDC ; =0x00000654
	add r6, r1, #0
	add r0, r4, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0223DDE0 ; =0x0000FFFF
	cmp r6, r0
	bne _0223DD94
	ldr r0, [r5, #0x48]
	mov r1, #0x7d
	bl NewString_ReadMsgData
	add r5, r0, #0
	b _0223DDB0
_0223DD94:
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r5, r0, #0
	add r0, r6, #0
	mov r1, #0x6d
	add r2, sp, #0x10
	bl GetSpeciesNameIntoArray
	add r0, r5, #0
	add r1, sp, #0x10
	bl CopyU16ArrayToString
_0223DDB0:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223DDE4 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, r7
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, r7
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	bl String_Delete
	add sp, #0x1fc
	add sp, #0x14
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223DDDC: .word 0x00000654
_0223DDE0: .word 0x0000FFFF
_0223DDE4: .word 0x000F0D00
	thumb_func_end ov40_0223DD68

	thumb_func_start ov40_0223DDE8
ov40_0223DDE8: ; 0x0223DDE8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r7, [r5, r0]
	ldr r0, _0223DEB0 ; =0x00000664
	str r1, [sp, #0x10]
	add r0, r7, r0
	mov r1, #0
	add r4, r2, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x10]
	cmp r0, #0xff
	bne _0223DE18
	cmp r4, #0xff
	bne _0223DE18
	ldr r0, [r5, #0x48]
	mov r1, #0x7d
	bl NewString_ReadMsgData
	str r0, [sp, #0x14]
	b _0223DE84
_0223DE18:
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r6, r0, #0
	cmp r4, #0
	beq _0223DE50
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x14]
	ldr r0, [r5, #0x48]
	mov r1, #0x17
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r2, [sp, #0x10]
	add r0, r6, #0
	mov r1, #0
	add r3, r4, #0
	bl BufferCityName
	ldr r1, [sp, #0x14]
	add r0, r6, #0
	add r2, r5, #0
	bl StringExpandPlaceholders
	b _0223DE78
_0223DE50:
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x14]
	ldr r0, [r5, #0x48]
	mov r1, #0x16
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r2, [sp, #0x10]
	add r0, r6, #0
	mov r1, #0
	bl BufferCountryName
	ldr r1, [sp, #0x14]
	add r0, r6, #0
	add r2, r5, #0
	bl StringExpandPlaceholders
_0223DE78:
	add r0, r5, #0
	bl String_Delete
	add r0, r6, #0
	bl MessageFormat_Delete
_0223DE84:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223DEB4 ; =0x000F0D00
	ldr r2, [sp, #0x14]
	str r0, [sp, #8]
	ldr r0, _0223DEB0 ; =0x00000664
	add r3, r1, #0
	add r0, r7, r0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _0223DEB0 ; =0x00000664
	add r0, r7, r0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x14]
	bl String_Delete
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223DEB0: .word 0x00000664
_0223DEB4: .word 0x000F0D00
	thumb_func_end ov40_0223DDE8

	thumb_func_start ov40_0223DEB8
ov40_0223DEB8: ; 0x0223DEB8
	push {r4, r5, r6, lr}
	sub sp, #0x10
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r5, [r0, r1]
	ldr r1, _0223DF0C ; =0x000004C3
	ldr r6, _0223DF10 ; =0x000006F4
	ldrb r1, [r5, r1]
	cmp r1, #0xff
	bne _0223DED0
	mov r1, #0x32
	b _0223DED2
_0223DED0:
	ldr r1, _0223DF14 ; =0x0000014D
_0223DED2:
	ldr r0, [r0, #0x48]
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223DF18 ; =0x000F0D00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, r6
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, r6
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0223DF0C: .word 0x000004C3
_0223DF10: .word 0x000006F4
_0223DF14: .word 0x0000014D
_0223DF18: .word 0x000F0D00
	thumb_func_end ov40_0223DEB8

	thumb_func_start ov40_0223DF1C
ov40_0223DF1C: ; 0x0223DF1C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x5c
	add r2, r1, #0
	mov r1, #0x86
	lsl r1, r1, #4
	str r0, [sp, #0x14]
	ldr r0, [r0, r1]
	ldr r5, _0223E010 ; =ov40_02245868
	str r0, [sp, #0x1c]
	add r4, sp, #0x2c
	mov r3, #6
_0223DF32:
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	sub r3, r3, #1
	bne _0223DF32
	ldr r4, _0223E014 ; =ov40_0224565C
	add r3, sp, #0x20
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	cmp r2, #0
	str r0, [r3]
	beq _0223DF4E
	bl GF_AssertFail
_0223DF4E:
	ldr r1, _0223E018 ; =0x00000798
	ldr r0, [sp, #0x1c]
	mov r6, #3
	str r6, [r0, r1]
	mov r0, #0
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x1c]
	sub r1, #0xc4
	add r7, sp, #0x20
	add r6, #0xfd
	add r4, r0, r1
	add r5, sp, #0x2c
_0223DF66:
	add r0, r4, #0
	bl InitWindow
	ldr r0, [r5, #4]
	add r1, r4, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldr r0, [r5, #8]
	mov r2, #6
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	ldr r0, [r5, #0xc]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	lsl r0, r6, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [r5]
	ldr r0, [r0, #0x24]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x18
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, [r5, #8]
	ldr r0, [r5, #0xc]
	add r4, #0x10
	mul r0, r1
	add r6, r6, r0
	ldr r0, [sp, #0x18]
	add r5, #0x10
	add r0, r0, #1
	str r0, [sp, #0x18]
	cmp r0, #3
	blt _0223DF66
	ldr r1, _0223E01C ; =0x000006D4
	ldr r0, [sp, #0x1c]
	mov r6, #0
	add r5, r0, r1
_0223DFC6:
	ldr r0, [sp, #0x14]
	ldr r1, [r7]
	ldr r0, [r0, #0x48]
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223E020 ; =0x000F0D00
	mov r1, #0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r2, r4, #0
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add r6, r6, #1
	add r5, #0x10
	add r7, r7, #4
	cmp r6, #2
	blt _0223DFC6
	ldr r0, [sp, #0x14]
	bl ov40_0223DEB8
	add sp, #0x5c
	pop {r4, r5, r6, r7, pc}
	nop
_0223E010: .word ov40_02245868
_0223E014: .word ov40_0224565C
_0223E018: .word 0x00000798
_0223E01C: .word 0x000006D4
_0223E020: .word 0x000F0D00
	thumb_func_end ov40_0223DF1C

	thumb_func_start ov40_0223E024
ov40_0223E024: ; 0x0223E024
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r6, [r0, r1]
	sub r1, #0xcc
	ldr r0, [r6, r1]
	mov r4, #0
	cmp r0, #0
	ble _0223E052
	ldr r0, _0223E05C ; =0x00000614
	ldr r7, _0223E060 ; =0x00000794
	add r5, r6, r0
_0223E03C:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	ldr r0, [r6, r7]
	add r4, r4, #1
	add r5, #0x10
	cmp r4, r0
	blt _0223E03C
_0223E052:
	ldr r0, _0223E060 ; =0x00000794
	mov r1, #0
	str r1, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223E05C: .word 0x00000614
_0223E060: .word 0x00000794
	thumb_func_end ov40_0223E024

	thumb_func_start ov40_0223E064
ov40_0223E064: ; 0x0223E064
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r6, [r0, r1]
	sub r1, #0xc8
	ldr r0, [r6, r1]
	mov r4, #0
	cmp r0, #0
	ble _0223E094
	ldr r0, _0223E09C ; =0x000006D4
	add r7, r0, #0
	add r5, r6, r0
	add r7, #0xc4
_0223E07E:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	ldr r0, [r6, r7]
	add r4, r4, #1
	add r5, #0x10
	cmp r4, r0
	blt _0223E07E
_0223E094:
	ldr r0, _0223E0A0 ; =0x00000798
	mov r1, #0
	str r1, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223E09C: .word 0x000006D4
_0223E0A0: .word 0x00000798
	thumb_func_end ov40_0223E064

	thumb_func_start ov40_0223E0A4
ov40_0223E0A4: ; 0x0223E0A4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r6, _0223E184 ; =0x00000614
	add r0, r4, r6
	bl InitWindow
	mov r3, #3
	str r3, [sp]
	mov r0, #0x14
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x20
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, r6
	mov r2, #2
	bl AddWindowParameterized
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x7e
	bl NewString_ReadMsgData
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223E188 ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, r6
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add r0, r7, #0
	bl String_Delete
	add r6, #0xc0
	add r0, r4, r6
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	add r0, #0xf2
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, r6
	mov r3, #0xb
	bl AddWindowParameterized
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x5f
	bl NewString_ReadMsgData
	add r5, r0, #0
	mov r0, #0
	add r1, r5, #0
	add r2, r0, #0
	bl FontID_String_GetWidthMultiline
	mov r1, #0x50
	sub r0, r1, r0
	mov r1, #0
	lsr r3, r0, #1
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223E188 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	bl String_Delete
	ldr r0, _0223E18C ; =0x00000798
	mov r1, #1
	str r1, [r4, r0]
	sub r0, r0, #4
	str r1, [r4, r0]
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0223E184: .word 0x00000614
_0223E188: .word 0x000F0D00
_0223E18C: .word 0x00000798
	thumb_func_end ov40_0223E0A4

	thumb_func_start ov40_0223E190
ov40_0223E190: ; 0x0223E190
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223E1A8
	cmp r1, #1
	beq _0223E252
	b _0223E2EE
_0223E1A8:
	bl ov40_02230738
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	bl ov40_0222D9E8
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r5, #0
	mov r1, #0x38
	mov r2, #3
	bl ov40_022307DC
	add r0, r5, #0
	mov r1, #0x3b
	mov r2, #7
	bl ov40_022307DC
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r5, #0
	bl ov40_02242110
	add r0, r5, #0
	mov r1, #0
	bl ov40_022420B4
	mov r1, #0x7d
	ldr r0, _0223E2FC ; =0x00000514
	lsl r1, r1, #2
	str r1, [r4, r0]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223E300 ; =ov40_022456C4
	ldr r2, _0223E304 ; =ov40_02241D10
	mov r1, #5
	add r3, r5, #0
	bl TouchHitboxController_Create
	ldr r1, _0223E308 ; =0x00000608
	ldr r2, _0223E30C ; =ov40_02241E14
	str r0, [r4, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223E310 ; =ov40_02245708
	mov r1, #9
	add r3, r5, #0
	bl TouchHitboxController_Create
	ldr r1, _0223E314 ; =0x0000060C
	add r5, #8
	str r0, [r4, r1]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	b _0223E2F4
_0223E252:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E2D4
	add r0, r5, #0
	mov r1, #0x7c
	bl ov40_0222DED0
	mov r0, #0x13
	ldr r1, _0223E318 ; =0x0000FFFF
	lsl r0, r0, #6
	strh r1, [r4, r0]
	mov r2, #0xff
	add r1, r0, #2
	strb r2, [r4, r1]
	add r1, r0, #3
	strb r2, [r4, r1]
	add r0, r0, #4
	strb r2, [r4, r0]
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223DBD4
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223DF1C
	mov r1, #0x13
	lsl r1, r1, #6
	ldrh r1, [r4, r1]
	add r0, r5, #0
	bl ov40_0223DD68
	ldr r1, _0223E31C ; =0x000004C2
	add r0, r5, #0
	ldrb r1, [r4, r1]
	bl ov40_0223DCF0
	ldr r2, _0223E320 ; =0x000004C3
	add r0, r5, #0
	ldrb r1, [r4, r2]
	add r2, r2, #1
	ldrb r2, [r4, r2]
	bl ov40_0223DDE8
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223E2D4:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223E2F4
_0223E2EE:
	mov r1, #3
	bl ov40_0222BF80
_0223E2F4:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_0223E2FC: .word 0x00000514
_0223E300: .word ov40_022456C4
_0223E304: .word ov40_02241D10
_0223E308: .word 0x00000608
_0223E30C: .word ov40_02241E14
_0223E310: .word ov40_02245708
_0223E314: .word 0x0000060C
_0223E318: .word 0x0000FFFF
_0223E31C: .word 0x000004C2
_0223E320: .word 0x000004C3
	thumb_func_end ov40_0223E190

	thumb_func_start ov40_0223E324
ov40_0223E324: ; 0x0223E324
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _0223E338 ; =0x00000608
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_0223E338: .word 0x00000608
	thumb_func_end ov40_0223E324

	thumb_func_start ov40_0223E33C
ov40_0223E33C: ; 0x0223E33C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223E356
	cmp r1, #1
	beq _0223E37E
	cmp r1, #2
	beq _0223E3B8
	b _0223E3E2
_0223E356:
	bl ov40_0223E024
	add r0, r5, #0
	bl ov40_0223E064
	add r0, r5, #0
	bl ov40_0222DFB0
	ldr r0, _0223E48C ; =0x00000608
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	ldr r0, _0223E490 ; =0x0000060C
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223E486
_0223E37E:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E39E
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223E39E:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223E486
_0223E3B8:
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_022421FC
	add r0, r5, #0
	bl ov40_0222D88C
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223E486
_0223E3E2:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _0223E486
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _0223E456
	add r0, r5, #0
	bl ov40_0222DD08
	add r0, r4, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	bl Heap_Free
	b _0223E486
_0223E456:
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_0223E486:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223E48C: .word 0x00000608
_0223E490: .word 0x0000060C
	thumb_func_end ov40_0223E33C

	thumb_func_start ov40_0223E494
ov40_0223E494: ; 0x0223E494
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223E4AA
	cmp r1, #1
	beq _0223E4B4
	b _0223E4EE
_0223E4AA:
	bl ov40_0223E064
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223E4B4:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E4D4
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223E4D4:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223E516
_0223E4EE:
	ldr r1, _0223E51C ; =0x000004C5
	ldrb r1, [r4, r1]
	cmp r1, #0
	beq _0223E500
	cmp r1, #1
	beq _0223E508
	cmp r1, #2
	beq _0223E510
	b _0223E516
_0223E500:
	mov r1, #6
	bl ov40_0222BF80
	b _0223E516
_0223E508:
	mov r1, #7
	bl ov40_0222BF80
	b _0223E516
_0223E510:
	mov r1, #0xa
	bl ov40_0222BF80
_0223E516:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223E51C: .word 0x000004C5
	thumb_func_end ov40_0223E494

	thumb_func_start ov40_0223E520
ov40_0223E520: ; 0x0223E520
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #4
	bls _0223E532
	b _0223E6C8
_0223E532:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223E53E: ; jump table
	.short _0223E548 - _0223E53E - 2 ; case 0
	.short _0223E576 - _0223E53E - 2 ; case 1
	.short _0223E60C - _0223E53E - 2 ; case 2
	.short _0223E656 - _0223E53E - 2 ; case 3
	.short _0223E686 - _0223E53E - 2 ; case 4
_0223E548:
	mov r1, #0x71
	bl ov40_0222DF60
	ldr r1, _0223E6D4 ; =0x000004C2
	mov r0, #0xff
	strb r0, [r5, r1]
	ldrb r1, [r5, r1]
	add r0, r4, #0
	bl ov40_0223DCF0
	add r0, r4, #0
	mov r1, #1
	bl ov40_022420B4
	add r0, r4, #0
	mov r1, #0x3d
	mov r2, #7
	bl ov40_022307DC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223E6D0
_0223E576:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E5F2
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223E6D8 ; =0x0000047C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F9D4
	ldr r0, _0223E6DC ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F734
	add r0, r4, #0
	bl sub_02087E1C
	cmp r0, #1
	ldr r0, _0223E6DC ; =0x0000049C
	bne _0223E5C2
	ldr r2, _0223E6E0 ; =ov40_02245784
	add r0, r4, r0
	add r1, r4, #0
	bl ov40_0222E8C4
	b _0223E5CC
_0223E5C2:
	ldr r2, _0223E6E4 ; =ov40_02245758
	add r0, r4, r0
	add r1, r4, #0
	bl ov40_0222E8C4
_0223E5CC:
	ldr r1, _0223E6D8 ; =0x0000047C
	add r0, r4, r1
	add r1, #0x20
	add r1, r4, r1
	bl ov40_0222FA5C
	ldr r0, _0223E6DC ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	mov r2, #2
	bl ov40_0222F740
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223E5F2:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223E6D0
_0223E60C:
	ldr r0, _0223E6D8 ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA88
	ldr r1, _0223E6DC ; =0x0000049C
	add r0, r4, r1
	sub r1, #0x10
	ldrsh r1, [r4, r1]
	bl ov40_0222F6D0
	ldr r0, _0223E6DC ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F38C
	add r1, r0, #0
	beq _0223E63E
	ldr r0, _0223E6D4 ; =0x000004C2
	strb r1, [r5, r0]
	add r0, r4, #0
	bl ov40_0223DCF0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223E63E:
	ldr r0, _0223E6E8 ; =ov40_02245650
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0223E6D0
	add r0, r4, #0
	bl ov40_02230944
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223E6D0
_0223E656:
	ldr r0, _0223E6D8 ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA24
	ldr r0, _0223E6DC ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F720
	ldr r0, _0223E6DC ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F920
	ldr r0, _0223E6D8 ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA18
	ldr r0, _0223E6DC ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F734
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223E686:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E6AE
	add r0, r4, #0
	mov r1, #0
	bl ov40_022420B4
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223E6AE:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223E6D0
_0223E6C8:
	add r0, r4, #0
	mov r1, #0xb
	bl ov40_0222BF80
_0223E6D0:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223E6D4: .word 0x000004C2
_0223E6D8: .word 0x0000047C
_0223E6DC: .word 0x0000049C
_0223E6E0: .word ov40_02245784
_0223E6E4: .word ov40_02245758
_0223E6E8: .word ov40_02245650
	thumb_func_end ov40_0223E520

	thumb_func_start ov40_0223E6EC
ov40_0223E6EC: ; 0x0223E6EC
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	bne _0223E720
	mov r1, #0x72
	bl ov40_0222DF60
	mov r1, #0x13
	ldr r0, _0223E72C ; =0x0000FFFF
	lsl r1, r1, #6
	strh r0, [r4, r1]
	ldrh r1, [r4, r1]
	add r0, r5, #0
	bl ov40_0223DD68
	add r0, r5, #0
	mov r1, #1
	bl ov40_022420B4
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223E720:
	add r0, r5, #0
	mov r1, #8
	bl ov40_0222BF80
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223E72C: .word 0x0000FFFF
	thumb_func_end ov40_0223E6EC

	thumb_func_start ov40_0223E730
ov40_0223E730: ; 0x0223E730
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	str r0, [sp, #0x14]
	mov r0, #1
	str r0, [sp, #0x28]
	mov r1, #0x86
	ldr r0, [sp, #0x14]
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _0223E838 ; =0x000006D4
	ldr r5, _0223E83C ; =ov40_02245708
	mov r7, #0
	add r4, r1, r0
_0223E74A:
	ldrb r0, [r5, #2]
	lsl r0, r0, #0x15
	lsr r0, r0, #0x18
	str r0, [sp, #0x24]
	ldrb r0, [r5]
	lsl r0, r0, #0x15
	lsr r0, r0, #0x18
	str r0, [sp, #0x20]
	ldrb r0, [r5, #3]
	lsr r1, r0, #3
	ldr r0, [sp, #0x24]
	sub r0, r1, r0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x1c]
	ldrb r0, [r5, #1]
	lsr r1, r0, #3
	ldr r0, [sp, #0x20]
	sub r0, r1, r0
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	add r0, r4, #0
	bl InitWindow
	ldr r0, [sp, #0x20]
	add r1, r4, #0
	str r0, [sp]
	ldr r0, [sp, #0x1c]
	mov r2, #6
	str r0, [sp, #4]
	str r6, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x28]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x14]
	ldr r3, [sp, #0x24]
	ldr r0, [r0, #0x24]
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	add r1, r7, #0
	ldr r0, [r0, #0x48]
	add r1, #0x44
	bl NewString_ReadMsgData
	str r0, [sp, #0x2c]
	ldr r1, [sp, #0x2c]
	add r0, r4, #0
	bl ov40_022306C0
	lsl r1, r6, #3
	sub r1, #0x10
	str r0, [sp, #0x30]
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x14]
	add r1, r7, #0
	bl ov40_0223EBB8
	cmp r0, #1
	bne _0223E7F4
	ldr r0, [sp, #0x18]
	ldr r2, [sp, #0x2c]
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223E840 ; =0x000F0D00
	ldr r3, [sp, #0x30]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #0
	bl AddTextPrinterParameterizedWithColor
	b _0223E810
_0223E7F4:
	ldr r0, [sp, #0x18]
	ldr r2, [sp, #0x2c]
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0223E844 ; =0x000C0B00
	ldr r3, [sp, #0x30]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #0
	bl AddTextPrinterParameterizedWithColor
_0223E810:
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x2c]
	bl String_Delete
	ldr r0, [sp, #0x1c]
	add r7, r7, #1
	add r1, r0, #0
	ldr r0, [sp, #0x28]
	mul r1, r6
	add r0, r0, r1
	str r0, [sp, #0x28]
	add r4, #0x10
	add r5, r5, #4
	cmp r7, #9
	blo _0223E74A
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_0223E838: .word 0x000006D4
_0223E83C: .word ov40_02245708
_0223E840: .word 0x000F0D00
_0223E844: .word 0x000C0B00
	thumb_func_end ov40_0223E730

	thumb_func_start ov40_0223E848
ov40_0223E848: ; 0x0223E848
	push {r3, r4, r5, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _0223E86C ; =0x000006D4
	mov r4, #0
	add r5, r1, r0
_0223E856:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #9
	blo _0223E856
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223E86C: .word 0x000006D4
	thumb_func_end ov40_0223E848

	thumb_func_start ov40_0223E870
ov40_0223E870: ; 0x0223E870
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #4
	bhi _0223E97A
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223E88C: ; jump table
	.short _0223E896 - _0223E88C - 2 ; case 0
	.short _0223E8A6 - _0223E88C - 2 ; case 1
	.short _0223E8E6 - _0223E88C - 2 ; case 2
	.short _0223E90E - _0223E88C - 2 ; case 3
	.short _0223E918 - _0223E88C - 2 ; case 4
_0223E896:
	mov r1, #0x3c
	mov r2, #7
	bl ov40_022307DC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223E994
_0223E8A6:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E8CC
	add r0, r4, #0
	bl ov40_0223E730
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223E8CC:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223E994
_0223E8E6:
	ldr r0, _0223E998 ; =0x0000060C
	ldr r0, [r5, r0]
	bl TouchHitboxController_IsTriggered
	ldr r0, _0223E99C ; =ov40_02245650
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	bne _0223E900
	ldr r0, _0223E9A0 ; =0x000004D8
	ldr r0, [r5, r0]
	cmp r0, #1
	bne _0223E994
_0223E900:
	add r0, r4, #0
	bl ov40_02230944
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223E994
_0223E90E:
	bl ov40_0223E848
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223E918:
	ldr r0, _0223E9A0 ; =0x000004D8
	ldr r0, [r5, r0]
	cmp r0, #1
	bne _0223E938
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E994
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223E994
_0223E938:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223E960
	add r0, r4, #0
	mov r1, #0
	bl ov40_022420B4
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223E960:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223E994
_0223E97A:
	ldr r0, _0223E9A0 ; =0x000004D8
	ldr r0, [r5, r0]
	cmp r0, #1
	bne _0223E98C
	add r0, r4, #0
	mov r1, #9
	bl ov40_0222BF80
	b _0223E994
_0223E98C:
	add r0, r4, #0
	mov r1, #0xb
	bl ov40_0222BF80
_0223E994:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223E998: .word 0x0000060C
_0223E99C: .word ov40_02245650
_0223E9A0: .word 0x000004D8
	thumb_func_end ov40_0223E870

	thumb_func_start ov40_0223E9A4
ov40_0223E9A4: ; 0x0223E9A4
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #4
	bls _0223E9B8
	b _0223EB72
_0223E9B8:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223E9C4: ; jump table
	.short _0223E9CE - _0223E9C4 - 2 ; case 0
	.short _0223E9EE - _0223E9C4 - 2 ; case 1
	.short _0223EA88 - _0223E9C4 - 2 ; case 2
	.short _0223EADC - _0223E9C4 - 2 ; case 3
	.short _0223EB0C - _0223E9C4 - 2 ; case 4
_0223E9CE:
	mov r1, #0x72
	bl ov40_0222DF60
	add r0, r4, #0
	mov r1, #1
	bl ov40_022420B4
	add r0, r4, #0
	mov r1, #0x3a
	mov r2, #7
	bl ov40_022307DC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223EB96
_0223E9EE:
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	bne _0223EA00
	b _0223EB96
_0223EA00:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223EB9C ; =0x0000047C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F9D4
	mov r0, #0x4e
	lsl r0, r0, #4
	ldr r3, _0223EBA0 ; =ov40_022457DC
	add r2, r5, r0
	mov r6, #5
_0223EA1C:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _0223EA1C
	ldr r0, [r3]
	ldr r1, _0223EBA4 ; =0x000004DC
	str r0, [r2]
	ldr r2, [r5, r1]
	add r0, r1, #4
	str r2, [r5, r0]
	add r0, r1, #0
	sub r0, #0x14
	ldr r2, [r5, r0]
	add r0, r1, #0
	add r0, #8
	sub r1, #0x40
	str r2, [r5, r0]
	add r0, r4, r1
	bl ov40_0222F734
	ldr r3, _0223EBA8 ; =0x0000049C
	add r1, r4, #0
	add r2, r3, #0
	add r2, #0x38
	add r0, r4, r3
	add r3, #0x44
	ldr r2, [r5, r2]
	add r3, r5, r3
	bl ov40_0222E9B8
	ldr r1, _0223EBAC ; =0x000004E4
	mov r0, #0
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x68
	sub r1, #0x48
	add r0, r4, r0
	add r1, r4, r1
	bl ov40_0222FA5C
	ldr r0, _0223EBA8 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	mov r2, #2
	bl ov40_0222F740
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223EB96
_0223EA88:
	ldr r0, _0223EB9C ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA88
	ldr r1, _0223EBA8 ; =0x0000049C
	add r0, r4, r1
	sub r1, #0x10
	ldrsh r1, [r4, r1]
	bl ov40_0222F6D0
	ldr r0, _0223EBA8 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F38C
	add r1, r0, #0
	beq _0223EABC
	mov r0, #0x13
	lsl r0, r0, #6
	strh r1, [r5, r0]
	add r0, r4, #0
	bl ov40_0223DD68
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223EABC:
	ldr r0, _0223EBB0 ; =ov40_02245650
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0223EB96
	mov r0, #0x13
	ldr r1, _0223EBB4 ; =0x0000FFFF
	lsl r0, r0, #6
	strh r1, [r5, r0]
	add r0, r4, #0
	bl ov40_02230944
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223EB96
_0223EADC:
	ldr r0, _0223EB9C ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA24
	ldr r0, _0223EBA8 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F720
	ldr r0, _0223EBA8 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F920
	ldr r0, _0223EB9C ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA18
	ldr r0, _0223EBA8 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F734
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223EB0C:
	mov r0, #0x13
	lsl r0, r0, #6
	ldrh r1, [r5, r0]
	ldr r0, _0223EBB4 ; =0x0000FFFF
	cmp r1, r0
	beq _0223EB5A
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223EB40
	add r0, r4, #0
	mov r1, #0
	bl ov40_022420B4
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223EB40:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223EB96
_0223EB5A:
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223EB96
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223EB96
_0223EB72:
	add r0, r4, #0
	bl ov40_0223EDA8
	mov r0, #0x13
	lsl r0, r0, #6
	ldrh r1, [r5, r0]
	ldr r0, _0223EBB4 ; =0x0000FFFF
	cmp r1, r0
	beq _0223EB8E
	add r0, r4, #0
	mov r1, #0xb
	bl ov40_0222BF80
	b _0223EB96
_0223EB8E:
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
_0223EB96:
	mov r0, #0
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_0223EB9C: .word 0x0000047C
_0223EBA0: .word ov40_022457DC
_0223EBA4: .word 0x000004DC
_0223EBA8: .word 0x0000049C
_0223EBAC: .word 0x000004E4
_0223EBB0: .word ov40_02245650
_0223EBB4: .word 0x0000FFFF
	thumb_func_end ov40_0223E9A4

	thumb_func_start ov40_0223EBB8
ov40_0223EBB8: ; 0x0223EBB8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	str r0, [sp, #8]
	add r0, r1, #1
	ldr r2, _0223EC38 ; =ov40_02245E44
	lsl r0, r0, #1
	ldrh r4, [r2, r0]
	lsl r0, r1, #1
	ldrh r6, [r2, r0]
	ldr r1, [sp, #8]
	mov r0, #0x6d
	add r2, sp, #0xc
	bl ov40_0222DD68
	str r0, [sp, #4]
	mov r0, #0x83
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl Save_Pokedex_Get
	str r0, [sp]
	add r7, r6, #0
	cmp r6, r4
	bge _0223EC0A
	ldr r0, [sp, #4]
	lsl r1, r6, #1
	add r5, r0, r1
_0223EBF2:
	ldrh r1, [r5]
	ldr r0, [sp]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	bne _0223EC02
	ldr r0, _0223EC3C ; =0x0000FFFF
	strh r0, [r5]
_0223EC02:
	add r7, r7, #1
	add r5, r5, #2
	cmp r7, r4
	blt _0223EBF2
_0223EC0A:
	cmp r6, r4
	bge _0223EC2A
	ldr r0, [sp, #4]
	lsl r1, r6, #1
	add r2, r0, r1
	ldr r0, _0223EC3C ; =0x0000FFFF
_0223EC16:
	ldrh r1, [r2]
	cmp r1, r0
	beq _0223EC22
	mov r0, #1
	str r0, [sp, #8]
	b _0223EC2A
_0223EC22:
	add r6, r6, #1
	add r2, r2, #2
	cmp r6, r4
	blt _0223EC16
_0223EC2A:
	ldr r0, [sp, #4]
	bl Heap_Free
	ldr r0, [sp, #8]
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0223EC38: .word ov40_02245E44
_0223EC3C: .word 0x0000FFFF
	thumb_func_end ov40_0223EBB8
