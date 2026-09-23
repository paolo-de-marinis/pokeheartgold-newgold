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

.public ov18_021EEC34
.public ov18_021EECB0
.public ov18_021EED00
.public ov18_021F95FC
.public ov18_021F9648

.public ov18_021EE984
.public ov18_021EE9FC
.public ov18_021EEA40
.public ov18_021EEAE4
.public ov18_021EEB94
.public ov18_021EEBE4

	.text

	thumb_func_start ov18_021EE8B8
ov18_021EE8B8: ; 0x021EE8B8
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r0, #0xcc
	add r4, r1, #0
	add r6, r2, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r5, #0
	add r0, #0xec
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r5, #0
	add r0, #0xbc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r5, #0
	add r0, #0xdc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r5, #0
	add r0, #0xfc
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x47
	lsl r0, r0, #2
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x4b
	lsl r0, r0, #2
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x4f
	lsl r0, r0, #2
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	cmp r4, #0
	beq _021EE97C
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0xb
	bl ov18_021EE984
	ldr r0, _021EE980 ; =0x0000185C
	ldrb r0, [r5, r0]
	cmp r0, #2
	bne _021EE950
	add r0, r5, #0
	mov r1, #0xc
	bl ov18_021EE9FC
	add r0, r5, #0
	mov r1, #0xe
	bl ov18_021EEA40
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0xd
	bl ov18_021EEAE4
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0xf
	bl ov18_021EEB94
	pop {r4, r5, r6, pc}
_021EE950:
	add r0, r5, #0
	mov r1, #0x10
	bl ov18_021EEBE4
	ldr r3, _021EE980 ; =0x0000185C
	add r0, r5, #0
	ldrb r3, [r5, r3]
	add r1, r4, #0
	mov r2, #0x11
	bl ov18_021EEC34
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x12
	bl ov18_021EECB0
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0x13
	bl ov18_021EED00
_021EE97C:
	pop {r4, r5, r6, pc}
	nop
_021EE980: .word 0x0000185C
	thumb_func_end ov18_021EE8B8
