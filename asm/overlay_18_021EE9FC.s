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

.public ov18_021F95FC
.public ov18_021F9648

	.text

	thumb_func_start ov18_021EE9FC
ov18_021EE9FC: ; 0x021EE9FC
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EEA38 ; =0x00020100
	ldr r1, _021EEA3C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0xa
	mov r3, #0x14
	bl ov18_021F9648
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_021EEA38: .word 0x00020100
_021EEA3C: .word 0x0000065C
	thumb_func_end ov18_021EE9FC

	thumb_func_start ov18_021EEA40
ov18_021EEA40: ; 0x021EEA40
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EEA7C ; =0x00020100
	ldr r1, _021EEA80 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0xb
	mov r3, #0x14
	bl ov18_021F9648
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_021EEA7C: .word 0x00020100
_021EEA80: .word 0x0000065C
	thumb_func_end ov18_021EEA40

	thumb_func_start ov18_021EEA84
ov18_021EEA84: ; 0x021EEA84
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r7, r1, #0
	add r5, r2, #0
	add r6, r3, #0
	bl GetDexHeightMsgBank
	add r2, r0, #0
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x25
	bl NewMsgDataFromNarc
	str r0, [sp, #0xc]
	cmp r5, #2
	bne _021EEAAE
	add r1, r7, #0
	bl NewString_ReadMsgData
	b _021EEAB4
_021EEAAE:
	mov r1, #0
	bl NewString_ReadMsgData
_021EEAB4:
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, [sp, #0x30]
	add r4, #0xc
	str r0, [sp, #4]
	ldr r0, [sp, #0x34]
	ldr r2, [sp, #0x28]
	str r0, [sp, #8]
	lsl r0, r6, #4
	ldr r3, [sp, #0x2c]
	add r0, r4, r0
	add r1, r5, #0
	bl ov18_021F95FC
	add r0, r5, #0
	bl String_Delete
	ldr r0, [sp, #0xc]
	bl DestroyMsgData
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021EEA84

	thumb_func_start ov18_021EEAE4
ov18_021EEAE4: ; 0x021EEAE4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r4, r5, #0
	add r0, r3, #0
	str r1, [sp, #0x10]
	add r4, #0xc
	lsl r6, r0, #4
	add r0, r4, r6
	mov r1, #0
	add r7, r2, #0
	str r3, [sp, #0x14]
	bl FillWindowPixelBuffer
	mov r0, #4
	str r0, [sp]
	mov r1, #0
	lsl r2, r7, #2
	add r3, r5, r2
	ldr r0, _021EEB2C ; =0x00020100
	str r1, [sp, #4]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, _021EEB30 ; =0x00001032
	ldr r1, [sp, #0x10]
	ldrh r2, [r3, r2]
	ldr r3, [sp, #0x14]
	add r0, r5, #0
	bl ov18_021EEA84
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EEB2C: .word 0x00020100
_021EEB30: .word 0x00001032
	thumb_func_end ov18_021EEAE4

	thumb_func_start ov18_021EEB34
ov18_021EEB34: ; 0x021EEB34
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r7, r1, #0
	add r5, r2, #0
	add r6, r3, #0
	bl GetDexWeightMsgBank
	add r2, r0, #0
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x25
	bl NewMsgDataFromNarc
	str r0, [sp, #0xc]
	cmp r5, #2
	bne _021EEB5E
	add r1, r7, #0
	bl NewString_ReadMsgData
	b _021EEB64
_021EEB5E:
	mov r1, #0
	bl NewString_ReadMsgData
_021EEB64:
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, [sp, #0x30]
	add r4, #0xc
	str r0, [sp, #4]
	ldr r0, [sp, #0x34]
	ldr r2, [sp, #0x28]
	str r0, [sp, #8]
	lsl r0, r6, #4
	ldr r3, [sp, #0x2c]
	add r0, r4, r0
	add r1, r5, #0
	bl ov18_021F95FC
	add r0, r5, #0
	bl String_Delete
	ldr r0, [sp, #0xc]
	bl DestroyMsgData
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021EEB34

	thumb_func_start ov18_021EEB94
ov18_021EEB94: ; 0x021EEB94
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r4, r5, #0
	add r0, r3, #0
	str r1, [sp, #0x10]
	add r4, #0xc
	lsl r6, r0, #4
	add r0, r4, r6
	mov r1, #0
	add r7, r2, #0
	str r3, [sp, #0x14]
	bl FillWindowPixelBuffer
	mov r0, #4
	str r0, [sp]
	mov r1, #0
	lsl r2, r7, #2
	add r3, r5, r2
	ldr r0, _021EEBDC ; =0x00020100
	str r1, [sp, #4]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, _021EEBE0 ; =0x00001032
	ldr r1, [sp, #0x10]
	ldrh r2, [r3, r2]
	ldr r3, [sp, #0x14]
	add r0, r5, #0
	bl ov18_021EEB34
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EEBDC: .word 0x00020100
_021EEBE0: .word 0x00001032
	thumb_func_end ov18_021EEB94

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
