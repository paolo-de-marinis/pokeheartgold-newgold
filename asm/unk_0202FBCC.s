	.include "asm/macros.inc"
	.include "unk_0202FBCC.inc"
	.include "global.inc"

.public sub_02030250
.public sub_02030258
.public sub_020304F0

	.bss

	.public _021D2AF8
_021D2AF8:
	.space 0x4

	.rodata

_020F68C4:
	.byte 0x00, 0x02, 0x01, 0x03
_020F68C8:
	.byte 0x00, 0x02, 0x03, 0x01, 0x03, 0x01, 0x00, 0x02

	.text

	thumb_func_start sub_0202FBCC
sub_0202FBCC: ; 0x0202FBCC
	ldr r0, _0202FBD0 ; =0x00001D50
	bx lr
	.balign 4, 0
_0202FBD0: .word 0x00001D50
	thumb_func_end sub_0202FBCC

	thumb_func_start sub_0202FBD4
sub_0202FBD4: ; 0x0202FBD4
	push {r4, lr}
	add r4, r0, #0
	ldr r2, _0202FBEC ; =0x00001D50
	mov r0, #0
	add r1, r4, #0
	bl MIi_CpuClear32
	mov r0, #0
	mvn r0, r0
	str r0, [r4]
	pop {r4, pc}
	nop
_0202FBEC: .word 0x00001D50
	thumb_func_end sub_0202FBD4

	thumb_func_start sub_0202FBF0
sub_0202FBF0: ; 0x0202FBF0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, _0202FC20 ; =_021D2AF8
	add r4, r1, #0
	ldr r0, [r0]
	add r6, r2, #0
	cmp r0, #0
	beq _0202FC0A
	bl Heap_Free
	ldr r0, _0202FC20 ; =_021D2AF8
	mov r1, #0
	str r1, [r0]
_0202FC0A:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0
	bl sub_0202711C
	ldr r1, _0202FC20 ; =_021D2AF8
	str r0, [r1]
	bl sub_0202FBD4
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0202FC20: .word _021D2AF8
	thumb_func_end sub_0202FBF0

	thumb_func_start sub_0202FC24
sub_0202FC24: ; 0x0202FC24
	push {r3, lr}
	ldr r0, _0202FC44 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _0202FC32
	bl GF_AssertFail
_0202FC32:
	ldr r0, _0202FC44 ; =_021D2AF8
	ldr r0, [r0]
	bl Heap_Free
	ldr r0, _0202FC44 ; =_021D2AF8
	mov r1, #0
	str r1, [r0]
	pop {r3, pc}
	nop
_0202FC44: .word _021D2AF8
	thumb_func_end sub_0202FC24

	thumb_func_start sub_0202FC48
sub_0202FC48: ; 0x0202FC48
	ldr r0, _0202FC58 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	beq _0202FC54
	mov r0, #1
	bx lr
_0202FC54:
	mov r0, #0
	bx lr
	.balign 4, 0
_0202FC58: .word _021D2AF8
	thumb_func_end sub_0202FC48

	thumb_func_start sub_0202FC5C
sub_0202FC5C: ; 0x0202FC5C
	push {r3, lr}
	ldr r0, _0202FC70 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _0202FC6A
	bl GF_AssertFail
_0202FC6A:
	ldr r0, _0202FC70 ; =_021D2AF8
	ldr r0, [r0]
	pop {r3, pc}
	.balign 4, 0
_0202FC70: .word _021D2AF8
	thumb_func_end sub_0202FC5C

	thumb_func_start sub_0202FC74
sub_0202FC74: ; 0x0202FC74
	push {r3, lr}
	ldr r0, _0202FC8C ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _0202FC82
	bl GF_AssertFail
_0202FC82:
	ldr r0, _0202FC8C ; =_021D2AF8
	ldr r0, [r0]
	add r0, r0, #4
	pop {r3, pc}
	nop
_0202FC8C: .word _021D2AF8
	thumb_func_end sub_0202FC74

	thumb_func_start sub_0202FC90
sub_0202FC90: ; 0x0202FC90
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _0202FD1C ; =_021D2AF8
	add r7, r1, #0
	ldr r0, [r0]
	add r4, r2, #0
	add r6, r3, #0
	cmp r0, #0
	beq _0202FCAC
	bl Heap_Free
	ldr r0, _0202FD1C ; =_021D2AF8
	mov r1, #0
	str r1, [r0]
_0202FCAC:
	ldr r3, [sp, #0x18]
	add r0, r5, #0
	add r1, r7, #0
	add r2, r4, #0
	bl sub_0202711C
	ldr r1, _0202FD1C ; =_021D2AF8
	str r0, [r1]
	ldr r1, [r4]
	cmp r1, #1
	beq _0202FCCA
	mov r0, #3
	str r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0202FCCA:
	ldr r1, _0202FD20 ; =0x00001C64
	add r0, #0xe8
	ldrh r2, [r0, r1]
	ldr r3, _0202FD24 ; =0x0000FFFF
	eor r3, r2
	lsl r3, r3, #0x10
	add r2, r2, r3
	bl sub_02030258
	ldr r1, _0202FD1C ; =_021D2AF8
	add r0, r5, #0
	ldr r1, [r1]
	bl sub_02030154
	cmp r0, #1
	bne _0202FCF2
	mov r0, #0
	str r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0202FCF2:
	ldr r1, _0202FD1C ; =_021D2AF8
	add r0, r5, #0
	ldr r1, [r1]
	bl sub_0203018C
	cmp r0, #0
	bne _0202FD08
	mov r0, #2
	str r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0202FD08:
	cmp r6, #0
	beq _0202FD14
	add r0, r6, #0
	add r1, r5, #0
	bl sub_020304F0
_0202FD14:
	mov r0, #1
	str r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0202FD1C: .word _021D2AF8
_0202FD20: .word 0x00001C64
_0202FD24: .word 0x0000FFFF
	thumb_func_end sub_0202FC90

	thumb_func_start sub_0202FD28
sub_0202FD28: ; 0x0202FD28
	push {r4, r5, r6, lr}
	add r5, r2, #0
	add r6, r0, #0
	bl sub_0202711C
	ldr r1, [r5]
	add r4, r0, #0
	cmp r1, #1
	beq _0202FD46
	mov r1, #3
	str r1, [r5]
	bl Heap_Free
	mov r0, #0
	pop {r4, r5, r6, pc}
_0202FD46:
	ldr r1, _0202FD9C ; =0x00001C64
	add r0, #0xe8
	ldrh r2, [r0, r1]
	ldr r3, _0202FDA0 ; =0x0000FFFF
	eor r3, r2
	lsl r3, r3, #0x10
	add r2, r2, r3
	bl sub_02030258
	add r0, r6, #0
	add r1, r4, #0
	bl sub_02030154
	cmp r0, #1
	bne _0202FD72
	mov r0, #0
	str r0, [r5]
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	pop {r4, r5, r6, pc}
_0202FD72:
	add r0, r6, #0
	add r1, r4, #0
	bl sub_0203018C
	cmp r0, #0
	bne _0202FD8C
	mov r0, #2
	str r0, [r5]
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	pop {r4, r5, r6, pc}
_0202FD8C:
	mov r0, #1
	str r0, [r5]
	add r0, r4, #0
	bl Heap_Free
	mov r0, #1
	pop {r4, r5, r6, pc}
	nop
_0202FD9C: .word 0x00001C64
_0202FDA0: .word 0x0000FFFF
	thumb_func_end sub_0202FD28

	thumb_func_start sub_0202FDA4
sub_0202FDA4: ; 0x0202FDA4
	push {r3, r4, r5, r6, r7, lr}
	add r4, r3, #0
	add r6, r1, #0
	ldrh r1, [r4]
	add r5, r0, #0
	add r7, r2, #0
	cmp r1, #0
	beq _0202FDBA
	cmp r1, #1
	beq _0202FDF2
	b _0202FE10
_0202FDBA:
	mov r0, #8
	bl sub_0201A728
	mov r0, #0xb
	bl sub_0201A748
	add r0, r5, #0
	add r1, r6, #0
	add r2, r7, #0
	bl sub_02027134
	add r6, r0, #0
	cmp r6, #2
	bne _0202FDE8
	add r0, r5, #0
	mov r1, #2
	bl Save_PrepareForAsyncWrite
	ldrh r0, [r4]
	add r0, r0, #1
	strh r0, [r4]
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0202FDE8:
	mov r0, #8
	bl sub_0201A738
	add r0, r6, #0
	pop {r3, r4, r5, r6, r7, pc}
_0202FDF2:
	bl Save_WriteFileAsync
	add r5, r0, #0
	sub r0, r5, #2
	cmp r0, #1
	bhi _0202FE0C
	mov r0, #0
	strh r0, [r4]
	bl sub_0201A774
	mov r0, #8
	bl sub_0201A738
_0202FE0C:
	add r0, r5, #0
	pop {r3, r4, r5, r6, r7, pc}
_0202FE10:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end sub_0202FDA4

	thumb_func_start sub_0202FE14
sub_0202FE14: ; 0x0202FE14
	push {r3, r4, r5, r6, r7, lr}
	ldr r6, [sp, #0x18]
	mov ip, r1
	add r1, r2, #0
	ldrh r2, [r6]
	add r7, r0, #0
	cmp r2, #0
	beq _0202FE2A
	cmp r2, #1
	beq _0202FE90
	b _0202FE9E
_0202FE2A:
	ldr r2, _0202FEA4 ; =_021D2AF8
	ldr r4, [r2]
	cmp r4, #0
	bne _0202FE36
	mov r0, #3
	pop {r3, r4, r5, r6, r7, pc}
_0202FE36:
	add r5, r4, #0
	add r4, #0xe8
	add r5, #0x84
	str r1, [sp]
	add r1, r5, #0
	add r2, r4, #0
	mov r3, ip
	bl sub_0202FF08
	add r0, r5, #0
	ldr r1, _0202FEA8 ; =0x0000E281
	add r0, #0x48
	strh r1, [r0]
	add r0, r7, #0
	add r1, r5, #0
	mov r2, #0x58
	bl SaveArray_CalcCRC16
	add r5, #0x60
	strh r0, [r5]
	ldr r0, _0202FEA8 ; =0x0000E281
	ldr r2, _0202FEAC ; =0x00001C62
	add r1, r4, #0
	strh r0, [r4, r2]
	add r0, r7, #0
	add r2, r2, #2
	bl SaveArray_CalcCRC16
	ldr r1, _0202FEB0 ; =0x00001C64
	ldr r3, _0202FEB4 ; =0x0000FFFF
	strh r0, [r4, r1]
	ldrh r2, [r4, r1]
	add r0, r4, #0
	eor r3, r2
	lsl r3, r3, #0x10
	add r2, r2, r3
	bl sub_02030250
	ldr r0, [sp, #0x1c]
	mov r1, #0
	strh r1, [r0]
	ldrh r0, [r6]
	add r0, r0, #1
	strh r0, [r6]
	b _0202FE9E
_0202FE90:
	ldr r1, _0202FEA4 ; =_021D2AF8
	add r2, r3, #0
	ldr r1, [r1]
	ldr r3, [sp, #0x1c]
	bl sub_0202FDA4
	pop {r3, r4, r5, r6, r7, pc}
_0202FE9E:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0202FEA4: .word _021D2AF8
_0202FEA8: .word 0x0000E281
_0202FEAC: .word 0x00001C62
_0202FEB0: .word 0x00001C64
_0202FEB4: .word 0x0000FFFF
	thumb_func_end sub_0202FE14

	thumb_func_start sub_0202FEB8
sub_0202FEB8: ; 0x0202FEB8
	cmp r0, #0x1a
	bgt _0202FEE6
	bge _0202FEF2
	add r3, r0, #0
	sub r3, #0xe
	cmp r3, #9
	bhi _0202FEFC
	add r3, r3, r3
	add r3, pc
	ldrh r3, [r3, #6]
	lsl r3, r3, #0x10
	asr r3, r3, #0x10
	add pc, r3
_0202FED2: ; jump table
	.short _0202FEF2 - _0202FED2 - 2 ; case 0
	.short _0202FEFC - _0202FED2 - 2 ; case 1
	.short _0202FEFC - _0202FED2 - 2 ; case 2
	.short _0202FEF2 - _0202FED2 - 2 ; case 3
	.short _0202FEFC - _0202FED2 - 2 ; case 4
	.short _0202FEFC - _0202FED2 - 2 ; case 5
	.short _0202FEF2 - _0202FED2 - 2 ; case 6
	.short _0202FEFC - _0202FED2 - 2 ; case 7
	.short _0202FEFC - _0202FED2 - 2 ; case 8
	.short _0202FEF2 - _0202FED2 - 2 ; case 9
_0202FEE6:
	cmp r0, #0x1d
	bgt _0202FEEE
	beq _0202FEF2
	b _0202FEFC
_0202FEEE:
	cmp r0, #0x20
	bne _0202FEFC
_0202FEF2:
	mov r0, #4
	str r0, [r1]
	mov r0, #3
	str r0, [r2]
	bx lr
_0202FEFC:
	mov r0, #2
	str r0, [r1]
	mov r0, #6
	str r0, [r2]
	bx lr
	.balign 4, 0
	thumb_func_end sub_0202FEB8

	thumb_func_start sub_0202FF08
sub_0202FF08: ; 0x0202FF08
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	str r3, [sp, #8]
	add r7, r1, #0
	str r2, [sp, #4]
	ldr r3, _02030148 ; =_020F68C8
	str r0, [sp]
	add r2, sp, #0x1c
	mov r1, #8
_0202FF1A:
	ldrb r0, [r3]
	add r3, r3, #1
	strb r0, [r2]
	add r2, r2, #1
	sub r1, r1, #1
	bne _0202FF1A
	ldr r1, _0203014C ; =_020F68C4
	add r0, sp, #0x18
	ldrb r2, [r1]
	strb r2, [r0]
	ldrb r2, [r1, #1]
	strb r2, [r0, #1]
	ldrb r2, [r1, #2]
	ldrb r1, [r1, #3]
	strb r2, [r0, #2]
	strb r1, [r0, #3]
	add r0, r7, #0
	mov r1, #0
	mov r2, #0x64
	bl MI_CpuFill8
	ldr r0, [sp, #8]
	add r1, sp, #0x28
	add r2, sp, #0x24
	bl sub_0202FEB8
	ldr r0, [sp, #4]
	mov r2, #0
	ldr r3, [r0]
	mov r0, #4
	tst r0, r3
	beq _0202FF74
	mov r1, #0x80
	add r0, r3, #0
	tst r0, r1
	beq _0202FF6C
	ldr r0, [sp, #4]
	add r1, #0xc4
	ldrh r0, [r0, r1]
	lsl r4, r0, #1
	b _0202FF76
_0202FF6C:
	ldr r0, [sp, #4]
	add r1, #0xc4
	ldrh r4, [r0, r1]
	b _0202FF76
_0202FF74:
	add r4, r2, #0
_0202FF76:
	ldr r5, [sp, #0x28]
	mov r0, #0
	mov ip, r0
	cmp r5, #0
	ble _0203004E
	add r0, sp, #0x18
	str r0, [sp, #0x14]
	ldr r0, [sp, #4]
	lsl r1, r4, #2
	add r0, r0, r1
	str r0, [sp, #0x10]
	mov r0, #1
	and r0, r4
	add r3, r7, #0
	str r0, [sp, #0xc]
_0202FF94:
	ldr r0, [sp, #4]
	mov r1, #8
	ldr r0, [r0]
	add r6, r0, #0
	and r6, r1
	beq _0202FFD6
	mov r4, #0x80
	add r1, r0, #0
	tst r1, r4
	bne _0202FFD6
	mov r6, #0
	cmp r5, #0
	ble _0202FFF6
	ldr r1, [sp, #0x10]
	add r4, #0xb4
	ldr r1, [r1, r4]
	ldr r0, [sp, #4]
	lsl r1, r1, #0x1f
	lsr r4, r1, #0x1d
	add r1, sp, #0x1c
	add r4, r1, r4
	mov r1, ip
	ldrb r1, [r1, r4]
_0202FFC2:
	mov r4, #0x4d
	lsl r4, r4, #2
	ldr r4, [r0, r4]
	cmp r4, r1
	beq _0202FFF6
	add r6, r6, #1
	add r0, r0, #4
	cmp r6, r5
	blt _0202FFC2
	b _0202FFF6
_0202FFD6:
	cmp r6, #0
	beq _0202FFE6
	mov r1, #0x80
	tst r0, r1
	beq _0202FFE6
	ldr r0, [sp, #0x14]
	ldrb r6, [r0]
	b _0202FFF6
_0202FFE6:
	ldr r0, [sp, #0xc]
	mov r6, ip
	cmp r0, #0
	beq _0202FFF6
	mov r0, ip
	mov r1, #1
	add r6, r0, #0
	eor r6, r1
_0202FFF6:
	ldr r0, [sp, #0x24]
	mov r5, #0
	cmp r0, #0
	ble _0203003C
	ldr r1, _02030150 ; =0x00001154
	ldr r0, [sp, #4]
	add r1, r0, r1
	mov r0, #0xa9
	lsl r0, r0, #2
	mul r0, r6
	add r4, r1, r0
_0203000C:
	ldr r0, [r4, #0x2c]
	lsl r0, r0, #1
	lsr r0, r0, #0x1f
	bne _0203002E
	ldrh r0, [r4, #4]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	bne _0203002E
	ldrh r0, [r4, #6]
	strh r0, [r3]
	add r0, r4, #0
	add r0, #0x30
	ldrb r0, [r0]
	lsl r0, r0, #0x18
	lsr r1, r0, #0x1b
	add r0, r7, r2
	strb r1, [r0, #0x18]
_0203002E:
	ldr r0, [sp, #0x24]
	add r5, r5, #1
	add r3, r3, #2
	add r2, r2, #1
	add r4, #0x70
	cmp r5, r0
	blt _0203000C
_0203003C:
	ldr r0, [sp, #0x14]
	ldr r5, [sp, #0x28]
	add r0, r0, #1
	str r0, [sp, #0x14]
	mov r0, ip
	add r0, r0, #1
	mov ip, r0
	cmp r0, r5
	blt _0202FF94
_0203004E:
	ldr r0, [sp, #8]
	cmp r0, #0xd
	bhi _02030124
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02030060: ; jump table
	.short _02030124 - _02030060 - 2 ; case 0
	.short _0203007C - _02030060 - 2 ; case 1
	.short _02030098 - _02030060 - 2 ; case 2
	.short _020300B4 - _02030060 - 2 ; case 3
	.short _020300D0 - _02030060 - 2 ; case 4
	.short _020300EC - _02030060 - 2 ; case 5
	.short _02030108 - _02030060 - 2 ; case 6
	.short _02030124 - _02030060 - 2 ; case 7
	.short _0203007C - _02030060 - 2 ; case 8
	.short _02030098 - _02030060 - 2 ; case 9
	.short _020300B4 - _02030060 - 2 ; case 10
	.short _020300D0 - _02030060 - 2 ; case 11
	.short _020300EC - _02030060 - 2 ; case 12
	.short _02030108 - _02030060 - 2 ; case 13
_0203007C:
	ldr r0, [sp]
	mov r1, #0
	bl sub_020291E8
	add r3, r7, #0
	add r3, #0x28
	mov r2, #0x10
_0203008A:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _0203008A
	b _0203013A
_02030098:
	ldr r0, [sp]
	mov r1, #1
	bl sub_020291E8
	add r3, r7, #0
	add r3, #0x28
	mov r2, #0x10
_020300A6:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _020300A6
	b _0203013A
_020300B4:
	ldr r0, [sp]
	mov r1, #2
	bl sub_020291E8
	add r3, r7, #0
	add r3, #0x28
	mov r2, #0x10
_020300C2:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _020300C2
	b _0203013A
_020300D0:
	ldr r0, [sp]
	mov r1, #3
	bl sub_020291E8
	add r3, r7, #0
	add r3, #0x28
	mov r2, #0x10
_020300DE:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _020300DE
	b _0203013A
_020300EC:
	ldr r0, [sp]
	mov r1, #4
	bl sub_020291E8
	add r3, r7, #0
	add r3, #0x28
	mov r2, #0x10
_020300FA:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _020300FA
	b _0203013A
_02030108:
	ldr r0, [sp]
	mov r1, #5
	bl sub_020291E8
	add r3, r7, #0
	add r3, #0x28
	mov r2, #0x10
_02030116:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _02030116
	b _0203013A
_02030124:
	bl sub_0202925C
	add r3, r7, #0
	add r3, #0x28
	mov r2, #0x10
_0203012E:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _0203012E
_0203013A:
	ldr r0, [sp, #0x40]
	strh r0, [r7, #0x24]
	ldr r0, [sp, #8]
	add r7, #0x26
	strb r0, [r7]
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02030148: .word _020F68C8
_0203014C: .word _020F68C4
_02030150: .word 0x00001154
	thumb_func_end sub_0202FF08

	thumb_func_start sub_02030154
sub_02030154: ; 0x02030154
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r1, #0
	add r4, #0xe8
	add r5, #0x84
	bl Save_CheckExtraChunksExist
	cmp r0, #0
	bne _0203016A
	mov r0, #1
	pop {r3, r4, r5, pc}
_0203016A:
	ldr r0, _02030184 ; =0x00001C62
	ldrh r1, [r4, r0]
	ldr r0, _02030188 ; =0x0000E281
	cmp r1, r0
	bne _0203017C
	add r5, #0x48
	ldrh r1, [r5]
	cmp r1, r0
	beq _02030180
_0203017C:
	mov r0, #1
	pop {r3, r4, r5, pc}
_02030180:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02030184: .word 0x00001C62
_02030188: .word 0x0000E281
	thumb_func_end sub_02030154
