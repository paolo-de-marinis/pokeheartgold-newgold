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

.public ov18_021EE520
.public ov18_021EE75C
.public ov18_021EE7DC
.public ov18_021EE834
.public ov18_021F95FC
.public ov18_021F9648

	.text

	thumb_func_start ov18_021EE5E4
ov18_021EE5E4: ; 0x021EE5E4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r5, r1, #0
	bl ov18_021EE520
	add r4, #0xc
	lsl r0, r5, #4
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021EE5E4

	thumb_func_start ov18_021EE5FC
ov18_021EE5FC: ; 0x021EE5FC
	push {r4, lr}
	ldr r1, _021EE62C ; =0x0000185D
	add r4, r0, #0
	ldr r2, _021EE630 ; =0x0000102C
	ldrb r1, [r4, r1]
	ldrh r2, [r4, r2]
	add r1, r1, #2
	bl ov18_021EE5E4
	ldr r1, _021EE62C ; =0x0000185D
	ldr r2, _021EE634 ; =0x0000102E
	ldrb r1, [r4, r1]
	ldrh r2, [r4, r2]
	add r0, r4, #0
	add r1, r1, #4
	bl ov18_021EE5E4
	ldr r1, _021EE62C ; =0x0000185D
	mov r0, #1
	ldrb r2, [r4, r1]
	eor r0, r2
	strb r0, [r4, r1]
	pop {r4, pc}
	nop
_021EE62C: .word 0x0000185D
_021EE630: .word 0x0000102C
_021EE634: .word 0x0000102E
	thumb_func_end ov18_021EE5FC

	thumb_func_start ov18_021EE638
ov18_021EE638: ; 0x021EE638
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r7, r1, #0
	beq _021EE6A6
	add r4, r5, #0
	add r4, #0xc
	lsl r6, r2, #4
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, _021EE6B4 ; =0x0000185C
	add r0, r7, #0
	ldrb r1, [r5, r1]
	mov r2, #0x25
	bl ov18_021E590C
	add r7, r0, #0
	ldr r0, [r5]
	ldr r0, [r0]
	bl Pokedex_GetInternationalViewFlag
	cmp r0, #1
	ldr r0, _021EE6B8 ; =0x00020100
	bne _021EE682
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, r4, r6
	add r1, r7, #0
	mov r2, #0x38
	bl ov18_021F95FC
	b _021EE696
_021EE682:
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, r4, r6
	add r1, r7, #0
	mov r2, #0x2c
	bl ov18_021F95FC
_021EE696:
	add r0, r7, #0
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021EE6A6:
	add r5, #0xc
	lsl r0, r2, #4
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021EE6B4: .word 0x0000185C
_021EE6B8: .word 0x00020100
	thumb_func_end ov18_021EE638

	thumb_func_start ov18_021EE6BC
ov18_021EE6BC: ; 0x021EE6BC
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	mov r1, #7
	add r6, r2, #0
	bl ov18_021EE71C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #8
	bl ov18_021EE75C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #9
	bl ov18_021EE7DC
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0xa
	bl ov18_021EE834
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021EE6BC

	thumb_func_start ov18_021EE6EC
ov18_021EE6EC: ; 0x021EE6EC
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	mov r1, #0x51
	add r6, r2, #0
	bl ov18_021EE71C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x52
	bl ov18_021EE75C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x53
	bl ov18_021EE7DC
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0x54
	bl ov18_021EE834
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021EE6EC

	thumb_func_start ov18_021EE71C
ov18_021EE71C: ; 0x021EE71C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EE754 ; =0x00020100
	ldr r1, _021EE758 ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #8
	bl ov18_021F9648
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EE754: .word 0x00020100
_021EE758: .word 0x0000065C
	thumb_func_end ov18_021EE71C
