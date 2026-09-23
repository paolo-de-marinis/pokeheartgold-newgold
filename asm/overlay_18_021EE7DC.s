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

.public ov18_021EE8B8
.public ov18_021EE984
.public ov18_021EE9FC
.public ov18_021EEA40
.public ov18_021EEA84
.public ov18_021EEAE4
.public ov18_021EEB34
.public ov18_021EEB94
.public ov18_021EEBE4

	.text

	.balign 4, 0

.public ov18_021EE35C
.public ov18_021EE388
.public ov18_021EE3AC
.public ov18_021EE44C
.public ov18_021EE520
.public ov18_021EE7DC
.public ov18_021EE834
.public ov18_021EE8B8
.public ov18_021F8824
.public ov18_021F8838
.public ov18_021F95FC
.public ov18_021F9648
.public ov18_021F9F3C

.public ov18_021EEC34
.public ov18_021EECB0
.public ov18_021EED00
.public ov18_021F95FC
.public ov18_021F9648
.public ov18_021EE984
.public ov18_021EE9FC
.public ov18_021EEA40
.public ov18_021EEA84
.public ov18_021EEAE4
.public ov18_021EEB34
.public ov18_021EEB94
.public ov18_021EEBE4

	thumb_func_start ov18_021EE7DC
ov18_021EE7DC: ; 0x021EE7DC
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r4, r0, #0
	lsl r5, r2, #4
	add r4, #0xc
	add r6, r1, #0
	add r0, r4, r5
	mov r1, #0
	bl FillWindowPixelBuffer
	cmp r6, #0
	beq _021EE826
	add r0, r6, #0
	mov r1, #2
	mov r2, #0x25
	bl ov18_021E590C
	add r6, r0, #0
	mov r0, #4
	str r0, [sp]
	ldr r0, _021EE830 ; =0x00020100
	mov r2, #0
	str r0, [sp, #4]
	add r0, r4, r5
	add r1, r6, #0
	add r3, r2, #0
	str r2, [sp, #8]
	bl ov18_021F95FC
	add r0, r6, #0
	bl String_Delete
	add r0, r4, r5
	bl ScheduleWindowCopyToVram
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
_021EE826:
	add r0, r4, r5
	bl ClearWindowTilemapAndScheduleTransfer
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EE830: .word 0x00020100
	thumb_func_end ov18_021EE7DC
