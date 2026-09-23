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

.public ov18_021EE35C
.public ov18_021EE388
.public ov18_021EE3AC
.public ov18_021EE44C
.public ov18_021EE520
.public ov18_021EE984
.public ov18_021EE9FC
.public ov18_021EEA40
.public ov18_021EEA84
.public ov18_021EEAE4
.public ov18_021EEB34
.public ov18_021EEB94
.public ov18_021EEBE4
.public ov18_021EEC34
.public ov18_021EECB0
.public ov18_021EED00
.public ov18_021F8CCC
.public ov18_021F8F10
.public ov18_021F8FA0
.public ov18_021F91F0
.public ov18_021F95CC
.public ov18_021F95FC
.public ov18_021F9648
.public ov18_021F9DB0
.public ov18_021F9DC0
.public ov18_021F9DE4
.public ov18_021F9E4C
.public ov18_021F9EBC
.public ov18_021F9FDC
.public ov18_021FA304
.public ov18_021FA310
.public ov18_021FA328
.public ov18_021FA338
.public ov18_021FA348
.public ov18_021FA35A
.public ov18_021FA36C
.public ov18_021FA380
.public ov18_021FA398
.public ov18_021FA3B0
.public ov18_021FA3C8
.public ov18_021FA3E8
.public ov18_021FA41C
.public ov18_021FA450
.public ov18_021FA484
.public ov18_021FA4B8
.public ov18_021FA4EC
.public ov18_021FA520
.public ov18_021FA554
.public ov18_021FA588
.public ov18_021FA5CC
.public ov18_021FA610
.public ov18_021FA7B0
.public ov18_021FA984
.public ov18_021FAB24
.public ov18_021FAB58
.public ov18_021FAB8C
.public ov18_021FABC0
.public ov18_021FABF4
.public ov18_021FAC28
.public ov18_021FB004
.public ov18_021FB54C
.public ov18_021FB580
.public ov18_021FB5B4
.public ov18_021FB618
.public ov18_021FB61C
.public ov18_021FB620
.public ov18_021FB628
.public ov18_021FB630
.public ov18_021FB638
.public ov18_021FB648
.public ov18_021FB658
.public ov18_021FB668
.public ov18_021FB678
.public ov18_021FB688
.public ov18_021FB698
.public ov18_021FB6A8
.public ov18_021FB6B8
.public ov18_021FB6C8
.public ov18_021FB6DC
.public ov18_021FB6F0
.public ov18_021FB704
.public ov18_021FB718
.public ov18_021FB72C
.public ov18_021FB744
.public ov18_021FB760
.public ov18_021FB780
.public ov18_021FB7A0
.public ov18_021FB7C0
.public ov18_021FB7E0
.public ov18_021FB804
.public ov18_021FB828
.public ov18_021FB84C
.public ov18_021FB878
.public ov18_021FB8A4
.public ov18_021FB8D4
.public ov18_021FB904
.public ov18_021FB934
.public ov18_021FB968
.public ov18_021FB9A8
.public ov18_021FB9F0
.public ov18_021FBA40
.public ov18_021FBA94
.public ov18_021FBB0C
.public ov18_021FBB94
.public ov18_021FBC34
.public ov18_021FBD1C
.public ov18_021FBD28
.public ov18_021FBD3C
.public ov18_021FBD60
.public ov18_021FBD7C
.public ov18_021FBD98

.public ov18_021EFBE8
.public ov18_021EFC3C
.public ov18_021EFC9C
.public ov18_021EFD00
.public ov18_021EFDB4
.public ov18_021EFE70

	.text

	thumb_func_start ov18_021EED70
ov18_021EED70: ; 0x021EED70
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, _021EEE30 ; =0x0000056C
	add r4, r1, #0
	add r0, r5, r0
	add r6, r2, #0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE34 ; =0x0000058C
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE38 ; =0x0000055C
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE3C ; =0x0000057C
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE40 ; =0x0000059C
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE44 ; =0x000005AC
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE48 ; =0x000005BC
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE4C ; =0x000005CC
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _021EEE50 ; =0x000005DC
	add r0, r5, r0
	bl ClearWindowTilemapAndScheduleTransfer
	cmp r4, #0
	beq _021EEE2E
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0x55
	bl ov18_021EE984
	ldr r0, _021EEE54 ; =0x0000185C
	ldrb r0, [r5, r0]
	cmp r0, #2
	bne _021EEE02
	add r0, r5, #0
	mov r1, #0x56
	bl ov18_021EE9FC
	add r0, r5, #0
	mov r1, #0x58
	bl ov18_021EEA40
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0x57
	bl ov18_021EEAE4
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0x59
	bl ov18_021EEB94
	pop {r4, r5, r6, pc}
_021EEE02:
	add r0, r5, #0
	mov r1, #0x5a
	bl ov18_021EEBE4
	ldr r3, _021EEE54 ; =0x0000185C
	add r0, r5, #0
	ldrb r3, [r5, r3]
	add r1, r4, #0
	mov r2, #0x5b
	bl ov18_021EEC34
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x5c
	bl ov18_021EECB0
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0x5d
	bl ov18_021EED00
_021EEE2E:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EEE30: .word 0x0000056C
_021EEE34: .word 0x0000058C
_021EEE38: .word 0x0000055C
_021EEE3C: .word 0x0000057C
_021EEE40: .word 0x0000059C
_021EEE44: .word 0x000005AC
_021EEE48: .word 0x000005BC
_021EEE4C: .word 0x000005CC
_021EEE50: .word 0x000005DC
_021EEE54: .word 0x0000185C
	thumb_func_end ov18_021EED70

	thumb_func_start ov18_021EEE58
ov18_021EEE58: ; 0x021EEE58
	push {r4, lr}
	ldr r1, _021EEE80 ; =ov18_021F9FDC
	add r4, r0, #0
	mov r2, #0x65
	bl ov18_021EE35C
	add r0, r4, #0
	mov r1, #0
	bl ov18_021EEED0
	add r0, r4, #0
	bl ov18_021EF45C
	add r0, r4, #0
	bl ov18_021EF528
	add r0, r4, #0
	bl ov18_021EEE84
	pop {r4, pc}
	.balign 4, 0
_021EEE80: .word ov18_021F9FDC
	thumb_func_end ov18_021EEE58

	thumb_func_start ov18_021EEE84
ov18_021EEE84: ; 0x021EEE84
	push {r4, lr}
	add r4, r0, #0
	mov r2, #0x47
	lsl r2, r2, #2
	ldr r0, [r4, #8]
	mov r1, #6
	add r2, r4, r2
	bl sub_02019A60
	mov r2, #0x4b
	lsl r2, r2, #2
	ldr r0, [r4, #8]
	mov r1, #6
	add r2, r4, r2
	bl sub_02019A60
	mov r2, #0x4f
	lsl r2, r2, #2
	ldr r0, [r4, #8]
	mov r1, #6
	add r2, r4, r2
	bl sub_02019A60
	mov r2, #0x47
	lsl r2, r2, #2
	ldr r0, [r4, #8]
	mov r1, #7
	add r2, r4, r2
	bl sub_02019A60
	mov r2, #0x4f
	lsl r2, r2, #2
	ldr r0, [r4, #8]
	mov r1, #7
	add r2, r4, r2
	bl sub_02019A60
	pop {r4, pc}
	thumb_func_end ov18_021EEE84

	thumb_func_start ov18_021EEED0
ov18_021EEED0: ; 0x021EEED0
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r5, r4, #0
	add r5, #0xc
	add r6, r1, #0
	add r0, r5, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	cmp r6, #0xa
	bls _021EEEEA
	b _021EF1CE
_021EEEEA:
	add r0, r6, r6
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EEEF6: ; jump table
	.short _021EEF0C - _021EEEF6 - 2 ; case 0
	.short _021EEF4A - _021EEEF6 - 2 ; case 1
	.short _021EEFA4 - _021EEEF6 - 2 ; case 2
	.short _021EEFE2 - _021EEEF6 - 2 ; case 3
	.short _021EF020 - _021EEEF6 - 2 ; case 4
	.short _021EF05E - _021EEEF6 - 2 ; case 5
	.short _021EF09C - _021EEEF6 - 2 ; case 6
	.short _021EF0DA - _021EEEF6 - 2 ; case 7
	.short _021EF116 - _021EEEF6 - 2 ; case 8
	.short _021EF154 - _021EEEF6 - 2 ; case 9
	.short _021EF192 - _021EEEF6 - 2 ; case 10
_021EEF0C:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xd
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EEF4A:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xe
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #2
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, _021EF1E0 ; =0x0000102C
	mov r0, #0x66
	lsl r0, r0, #4
	ldrh r2, [r4, r2]
	ldr r0, [r4, r0]
	mov r1, #0
	mov r3, #3
	bl BufferIntegerAsString
	mov r0, #0x70
	str r0, [sp]
	mov r0, #0x16
	str r0, [sp, #4]
	mov r2, #0
	ldr r0, _021EF1D8 ; =0x00020100
	str r2, [sp, #8]
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, _021EF1DC ; =0x0000065C
	add r0, r4, #0
	ldr r1, [r4, r1]
	mov r3, #0xf
	bl ov18_021EE3AC
	b _021EF1CE
_021EEFA4:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x10
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EEFE2:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x11
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EF020:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x12
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EF05E:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x14
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EF09C:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x13
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EF0DA:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r2, #0x16
	str r2, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EF116:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x15
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EF154:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0xc
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x19
	mov r3, #0x70
	bl ov18_021F9648
	b _021EF1CE
_021EF192:
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x17
	mov r3, #0x70
	bl ov18_021F9648
	mov r0, #0x16
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021EF1D8 ; =0x00020100
	ldr r1, _021EF1DC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r4, r1]
	add r0, r5, #0
	mov r2, #0x18
	mov r3, #0x70
	bl ov18_021F9648
_021EF1CE:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EF1D8: .word 0x00020100
_021EF1DC: .word 0x0000065C
_021EF1E0: .word 0x0000102C
	thumb_func_end ov18_021EEED0

	thumb_func_start ov18_021EF1E4
ov18_021EF1E4: ; 0x021EF1E4
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
	ldr r0, _021EF218 ; =0x00020100
	ldr r1, _021EF21C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1a
	mov r3, #0x24
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF218: .word 0x00020100
_021EF21C: .word 0x0000065C
	thumb_func_end ov18_021EF1E4

	thumb_func_start ov18_021EF220
ov18_021EF220: ; 0x021EF220
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
	ldr r0, _021EF254 ; =0x00020100
	ldr r1, _021EF258 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1b
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF254: .word 0x00020100
_021EF258: .word 0x0000065C
	thumb_func_end ov18_021EF220

	thumb_func_start ov18_021EF25C
ov18_021EF25C: ; 0x021EF25C
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
	ldr r0, _021EF290 ; =0x00020100
	ldr r1, _021EF294 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1c
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF290: .word 0x00020100
_021EF294: .word 0x0000065C
	thumb_func_end ov18_021EF25C

	thumb_func_start ov18_021EF298
ov18_021EF298: ; 0x021EF298
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
	ldr r0, _021EF2CC ; =0x00020100
	ldr r1, _021EF2D0 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1d
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF2CC: .word 0x00020100
_021EF2D0: .word 0x0000065C
	thumb_func_end ov18_021EF298

	thumb_func_start ov18_021EF2D4
ov18_021EF2D4: ; 0x021EF2D4
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
	ldr r0, _021EF308 ; =0x00020100
	ldr r1, _021EF30C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1e
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF308: .word 0x00020100
_021EF30C: .word 0x0000065C
	thumb_func_end ov18_021EF2D4

	thumb_func_start ov18_021EF310
ov18_021EF310: ; 0x021EF310
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
	ldr r0, _021EF344 ; =0x00020100
	ldr r1, _021EF348 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x1f
	mov r3, #0x14
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF344: .word 0x00020100
_021EF348: .word 0x0000065C
	thumb_func_end ov18_021EF310

	thumb_func_start ov18_021EF34C
ov18_021EF34C: ; 0x021EF34C
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
	ldr r0, _021EF380 ; =0x00020100
	ldr r1, _021EF384 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, [r6, r1]
	add r0, r5, r4
	mov r2, #0x20
	mov r3, #0x18
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EF380: .word 0x00020100
_021EF384: .word 0x0000065C
	thumb_func_end ov18_021EF34C

	thumb_func_start ov18_021EF388
ov18_021EF388: ; 0x021EF388
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	add r4, r0, #0
	str r0, [sp, #0x1c]
	mov r0, #0x25
	lsl r6, r1, #4
	str r0, [sp]
	str r2, [sp, #0x20]
	ldr r1, _021EF450 ; =0x00000854
	ldr r0, [sp, #0x1c]
	mov r2, #1
	ldr r0, [r0, r1]
	mov r1, #4
	add r3, sp, #0x2c
	add r4, #0xc
	bl GfGfxLoader_GetCharDataFromOpenNarc
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	mov r5, #0
	ldr r7, [r0, #0x14]
	str r5, [sp, #0x24]
_021EF3B4:
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	lsl r0, r5, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #8
	str r0, [sp, #0x10]
	mov r1, #0x31
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #6
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r4, r6
	add r1, r7, r1
	add r3, r2, #0
	bl BlitBitmapRect
	mov r0, #8
	str r0, [sp]
	str r0, [sp, #4]
	lsl r0, r5, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #8
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r1, #0xca
	str r0, [sp, #0x14]
	mov r0, #0xff
	lsl r1, r1, #4
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r4, r6
	add r1, r7, r1
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x24]
	add r5, #8
	add r0, r0, #1
	str r0, [sp, #0x24]
	cmp r0, #8
	blo _021EF3B4
	ldr r0, [sp, #0x28]
	bl Heap_Free
	add r0, r4, r6
	bl GetWindowWidth
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF454 ; =0x00020100
	lsl r5, r3, #3
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	lsr r3, r5, #0x1f
	add r3, r5, r3
	ldr r2, _021EF458 ; =0x0000065C
	ldr r1, [sp, #0x1c]
	add r0, r4, r6
	ldr r1, [r1, r2]
	ldr r2, [sp, #0x20]
	asr r3, r3, #1
	bl ov18_021F9648
	add r0, r4, r6
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF450: .word 0x00000854
_021EF454: .word 0x00020100
_021EF458: .word 0x0000065C
	thumb_func_end ov18_021EF388

	thumb_func_start ov18_021EF45C
ov18_021EF45C: ; 0x021EF45C
	push {r3, r4, r5, lr}
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	mov r0, #0x53
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x57
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x5b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x5f
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x63
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x67
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x6b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	mov r1, #0x14
	bl ov18_021EF1E4
	add r0, r5, #0
	mov r1, #0x15
	bl ov18_021EF220
	add r0, r5, #0
	mov r1, #0x16
	bl ov18_021EF25C
	add r0, r5, #0
	mov r1, #0x17
	bl ov18_021EF298
	add r0, r5, #0
	mov r1, #0x18
	bl ov18_021EF2D4
	add r0, r5, #0
	mov r1, #0x19
	bl ov18_021EF310
	add r0, r5, #0
	mov r1, #0x1a
	bl ov18_021EF34C
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x23
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x12
	mov r2, #0x24
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x25
	bl ov18_021EF388
	mov r0, #0x53
	lsl r0, r0, #2
	mov r4, #0x14
	add r5, r5, r0
_021EF518:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x1a
	bls _021EF518
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021EF45C

	thumb_func_start ov18_021EF528
ov18_021EF528: ; 0x021EF528
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r1, #0x1b
	bl ov18_021EFBE8
	add r0, r5, #0
	mov r1, #0x1c
	bl ov18_021EFC3C
	ldr r1, _021EF5CC ; =0x00001870
	mov r2, #0x1d
	ldr r1, [r5, r1]
	add r0, r5, #0
	add r3, r2, #0
	bl ov18_021EFC9C
	ldr r1, _021EF5D0 ; =0x00001874
	add r0, r5, #0
	ldr r1, [r5, r1]
	mov r2, #0x1e
	mov r3, #0x1d
	bl ov18_021EFC9C
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x28
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0x1f
	bl ov18_021EFD00
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x2c
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0x20
	bl ov18_021EFD00
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x30
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0x21
	bl ov18_021EFDB4
	ldr r1, _021EF5D4 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x34
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0x22
	bl ov18_021EFDB4
	add r0, r5, #0
	mov r1, #0x23
	bl ov18_021EFE70
	mov r0, #0x6f
	lsl r0, r0, #2
	mov r4, #0x1b
	add r5, r5, r0
_021EF5BA:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x23
	bls _021EF5BA
	pop {r3, r4, r5, pc}
	nop
_021EF5CC: .word 0x00001870
_021EF5D0: .word 0x00001874
_021EF5D4: .word 0x00001850
	thumb_func_end ov18_021EF528

	thumb_func_start ov18_021EF5D8
ov18_021EF5D8: ; 0x021EF5D8
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	mov r0, #0x93
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x9b
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x9f
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xa3
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xa7
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xab
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xaf
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0x93
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x1a
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0x9b
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x29
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0x9f
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2a
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xa3
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2b
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xa7
	lsl r0, r0, #2
	mov r2, #0x2c
	ldr r1, [r5, r1]
	add r0, r5, r0
	add r3, r2, #0
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xab
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2d
	mov r3, #0x2c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF75C ; =0x00020100
	ldr r1, _021EF760 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xaf
	lsl r0, r0, #2
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x2e
	mov r3, #0x2c
	bl ov18_021F9648
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x25
	bl ov18_021EFBE8
	mov r0, #0x93
	lsl r0, r0, #2
	mov r4, #0x24
	add r5, r5, r0
_021EF748:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x2b
	bls _021EF748
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021EF75C: .word 0x00020100
_021EF760: .word 0x0000065C
	thumb_func_end ov18_021EF5D8

	thumb_func_start ov18_021EF764
ov18_021EF764: ; 0x021EF764
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	ldr r0, _021EF834 ; =0x0000041C
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EF838 ; =0x0000043C
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF83C ; =0x00020100
	ldr r1, _021EF840 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EF834 ; =0x0000041C
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x1b
	mov r3, #0x18
	bl ov18_021F9648
	mov r4, #0
_021EF7A4:
	add r0, r4, #0
	bl ov18_021E7698
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	cmp r4, #0x1a
	bne _021EF7B6
	mov r6, #0x71
	b _021EF7BA
_021EF7B6:
	add r6, r4, #0
	add r6, #0x45
_021EF7BA:
	add r0, r7, #0
	mov r1, #7
	bl _s32_div_f
	str r1, [sp, #0x10]
	add r0, r7, #0
	mov r1, #7
	bl _s32_div_f
	lsl r0, r0, #5
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF83C ; =0x00020100
	ldr r3, [sp, #0x10]
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, _021EF840 ; =0x0000065C
	ldr r0, _021EF838 ; =0x0000043C
	lsl r3, r3, #5
	ldr r1, [r5, r1]
	add r0, r5, r0
	add r2, r6, #0
	add r3, #0x18
	bl ov18_021F9648
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x1b
	blo _021EF7A4
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x42
	bl ov18_021EFC3C
	ldr r0, _021EF834 ; =0x0000041C
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _021EF838 ; =0x0000043C
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _021EF844 ; =0x0000042C
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021EF834: .word 0x0000041C
_021EF838: .word 0x0000043C
_021EF83C: .word 0x00020100
_021EF840: .word 0x0000065C
_021EF844: .word 0x0000042C
	thumb_func_end ov18_021EF764
