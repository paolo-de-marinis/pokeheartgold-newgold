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

.public ov18_021F9648

	.text

	thumb_func_start ov18_021EEBE4
ov18_021EEBE4: ; 0x021EEBE4
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _021EEC28 ; =0x0000185C
	ldrb r0, [r6, r0]
	bl LanguageToDexFlag
	add r2, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EEC2C ; =0x00020100
	ldr r1, _021EEC30 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	add r2, #0x7a
	mov r3, #0x38
	bl ov18_021F9648
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EEC28: .word 0x0000185C
_021EEC2C: .word 0x00020100
_021EEC30: .word 0x0000065C
	thumb_func_end ov18_021EEBE4
