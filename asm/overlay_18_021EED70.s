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

	thumb_func_start ov18_021EF848
ov18_021EF848: ; 0x021EF848
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	mov r1, #0
	add r6, r0, #0
	bl ov18_021E613C
	mov r0, #0xb3
	lsl r0, r0, #2
	add r0, r6, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF908 ; =0x00020100
	mov r2, #0x1c
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, _021EF90C ; =0x0000065C
	mov r0, #0xb3
	lsl r0, r0, #2
	ldr r1, [r6, r1]
	add r0, r6, r0
	add r3, r2, #0
	bl ov18_021F9648
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r5, _021EF910 ; =ov18_021F9DE4 + 7 * 8 + 2
	mov r7, #0x2f
	add r4, r6, r0
_021EF88A:
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EF908 ; =0x00020100
	add r2, r5, #0
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, _021EF90C ; =0x0000065C
	sub r2, #0x5e
	ldrh r2, [r2]
	ldr r1, [r6, r1]
	add r0, r4, #0
	mov r3, #0x20
	bl ov18_021F9648
	add r7, r7, #1
	add r4, #0x10
	add r5, r5, #2
	cmp r7, #0x40
	bls _021EF88A
	add r0, r6, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r6, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	ldr r1, _021EF914 ; =0x00001870
	add r0, r6, #0
	ldr r1, [r6, r1]
	mov r2, #0x2d
	mov r3, #0x1d
	bl ov18_021EFC9C
	ldr r1, _021EF918 ; =0x00001874
	add r0, r6, #0
	ldr r1, [r6, r1]
	mov r2, #0x2e
	mov r3, #0x23
	bl ov18_021EFC9C
	mov r0, #0xb3
	lsl r0, r0, #2
	mov r4, #0x2c
	add r5, r6, r0
_021EF8F6:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x40
	bls _021EF8F6
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF908: .word 0x00020100
_021EF90C: .word 0x0000065C
_021EF910: .word ov18_021F9DE4 + 7 * 8 + 2
_021EF914: .word 0x00001870
_021EF918: .word 0x00001874
	thumb_func_end ov18_021EF848

	thumb_func_start ov18_021EF91C
ov18_021EF91C: ; 0x021EF91C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	ldr r0, _021EF9A4 ; =0x0000044C
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EF9A8 ; =0x00020100
	ldr r1, _021EF9AC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EF9A4 ; =0x0000044C
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x1d
	mov r3, #0x14
	bl ov18_021F9648
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	ldr r1, _021EF9B0 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x28
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0x45
	bl ov18_021EFD00
	ldr r1, _021EF9B0 ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x2c
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0x46
	bl ov18_021EFD00
	ldr r0, _021EF9A4 ; =0x0000044C
	mov r4, #0x44
	add r5, r5, r0
_021EF992:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x46
	bls _021EF992
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF9A4: .word 0x0000044C
_021EF9A8: .word 0x00020100
_021EF9AC: .word 0x0000065C
_021EF9B0: .word 0x00001850
	thumb_func_end ov18_021EF91C

	thumb_func_start ov18_021EF9B4
ov18_021EF9B4: ; 0x021EF9B4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	ldr r0, _021EFA40 ; =0x0000047C
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EFA44 ; =0x00020100
	ldr r1, _021EFA48 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EFA40 ; =0x0000047C
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x1e
	mov r3, #0x18
	bl ov18_021F9648
	add r0, r5, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r5, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	ldr r1, _021EFA4C ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x30
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0x48
	bl ov18_021EFDB4
	ldr r1, _021EFA4C ; =0x00001850
	add r0, r5, #0
	ldr r2, [r5, r1]
	add r1, #0x34
	ldr r1, [r5, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0x49
	bl ov18_021EFDB4
	ldr r0, _021EFA40 ; =0x0000047C
	mov r4, #0x47
	add r5, r5, r0
_021EFA2E:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x49
	bls _021EFA2E
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EFA40: .word 0x0000047C
_021EFA44: .word 0x00020100
_021EFA48: .word 0x0000065C
_021EFA4C: .word 0x00001850
	thumb_func_end ov18_021EF9B4

	thumb_func_start ov18_021EFA50
ov18_021EFA50: ; 0x021EFA50
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0
	add r5, r0, #0
	bl ov18_021E613C
	ldr r0, _021EFB68 ; =0x000004AC
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EFB6C ; =0x000004CC
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EFB70 ; =0x000004DC
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EFB74 ; =0x000004EC
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EFB78 ; =0x000004FC
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EFB7C ; =0x00020100
	ldr r1, _021EFB80 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EFB68 ; =0x000004AC
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x1f
	mov r3, #0x18
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EFB7C ; =0x00020100
	ldr r1, _021EFB80 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EFB6C ; =0x000004CC
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x41
	mov r3, #0x1c
	bl ov18_021F9648
	ldr r0, _021EFB84 ; =0x00001860
	ldr r0, [r5, r0]
	cmp r0, #1
	bne _021EFAF4
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EFB7C ; =0x00020100
	ldr r1, _021EFB80 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EFB70 ; =0x000004DC
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x42
	mov r3, #0x1c
	bl ov18_021F9648
_021EFAF4:
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EFB7C ; =0x00020100
	ldr r1, _021EFB80 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EFB74 ; =0x000004EC
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x43
	mov r3, #0x1c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EFB7C ; =0x00020100
	ldr r1, _021EFB80 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EFB78 ; =0x000004FC
	ldr r1, [r5, r1]
	add r0, r5, r0
	mov r2, #0x44
	mov r3, #0x1c
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
	mov r1, #0x4b
	bl ov18_021EFE70
	ldr r0, _021EFB68 ; =0x000004AC
	mov r4, #0x4a
	add r5, r5, r0
_021EFB56:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x4f
	bls _021EFB56
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EFB68: .word 0x000004AC
_021EFB6C: .word 0x000004CC
_021EFB70: .word 0x000004DC
_021EFB74: .word 0x000004EC
_021EFB78: .word 0x000004FC
_021EFB7C: .word 0x00020100
_021EFB80: .word 0x0000065C
_021EFB84: .word 0x00001860
	thumb_func_end ov18_021EFA50

	thumb_func_start ov18_021EFB88
ov18_021EFB88: ; 0x021EFB88
	push {r4, lr}
	sub sp, #0x10
	mov r1, #0
	add r4, r0, #0
	bl ov18_021E613C
	ldr r0, _021EFBDC ; =0x0000050C
	mov r1, #0
	add r0, r4, r0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EFBE0 ; =0x00020100
	ldr r1, _021EFBE4 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r0, _021EFBDC ; =0x0000050C
	ldr r1, [r4, r1]
	add r0, r4, r0
	mov r2, #0x20
	mov r3, #0x18
	bl ov18_021F9648
	add r0, r4, #0
	mov r1, #0x11
	mov r2, #0x27
	bl ov18_021EF388
	add r0, r4, #0
	mov r1, #0x13
	mov r2, #0x28
	bl ov18_021EF388
	ldr r0, _021EFBDC ; =0x0000050C
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EFBDC: .word 0x0000050C
_021EFBE0: .word 0x00020100
_021EFBE4: .word 0x0000065C
	thumb_func_end ov18_021EFB88

	thumb_func_start ov18_021EFBE8
ov18_021EFBE8: ; 0x021EFBE8
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, r4
	bl GetWindowWidth
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EFC30 ; =0x00020100
	ldr r2, _021EFC34 ; =0x00001868
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, r4
	ldr r1, _021EFC38 ; =0x0000065C
	lsl r4, r3, #3
	ldr r2, [r6, r2]
	lsr r3, r4, #0x1f
	add r3, r4, r3
	ldr r1, [r6, r1]
	add r2, #0x29
	asr r3, r3, #1
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EFC30: .word 0x00020100
_021EFC34: .word 0x00001868
_021EFC38: .word 0x0000065C
	thumb_func_end ov18_021EFBE8

	thumb_func_start ov18_021EFC3C
ov18_021EFC3C: ; 0x021EFC3C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r7, r5, #0
	lsl r6, r1, #4
	add r7, #0xc
	add r0, r7, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _021EFC90 ; =0x0000186C
	ldr r4, [r5, r0]
	cmp r4, #0x1a
	bne _021EFC5C
	mov r4, #0x71
	b _021EFC5E
_021EFC5C:
	add r4, #0x45
_021EFC5E:
	add r0, r7, r6
	bl GetWindowWidth
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EFC94 ; =0x00020100
	add r2, r4, #0
	str r0, [sp, #8]
	mov r0, #2
	lsl r4, r3, #3
	str r0, [sp, #0xc]
	ldr r1, _021EFC98 ; =0x0000065C
	lsr r3, r4, #0x1f
	add r3, r4, r3
	ldr r1, [r5, r1]
	add r0, r7, r6
	asr r3, r3, #1
	bl ov18_021F9648
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EFC90: .word 0x0000186C
_021EFC94: .word 0x00020100
_021EFC98: .word 0x0000065C
	thumb_func_end ov18_021EFC3C

	thumb_func_start ov18_021EFC9C
ov18_021EFC9C: ; 0x021EFC9C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r0, #0
	add r5, r7, #0
	add r5, #0xc
	lsl r4, r2, #4
	str r1, [sp, #0x10]
	add r0, r5, r4
	mov r1, #0
	add r6, r3, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	mvn r0, r0
	cmp r6, r0
	bne _021EFCCA
	add r0, r5, r4
	bl GetWindowWidth
	lsl r1, r0, #3
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r6, r0, #1
_021EFCCA:
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	ldr r2, [sp, #0x10]
	str r0, [sp, #4]
	ldr r0, _021EFCF4 ; =0x00020100
	lsl r3, r2, #1
	ldr r2, _021EFCF8 ; =ov18_021F9DC0
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, _021EFCFC ; =0x0000065C
	ldrh r2, [r2, r3]
	ldr r1, [r7, r1]
	add r0, r5, r4
	add r3, r6, #0
	bl ov18_021F9648
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021EFCF4: .word 0x00020100
_021EFCF8: .word ov18_021F9DC0
_021EFCFC: .word 0x0000065C
	thumb_func_end ov18_021EFC9C

	thumb_func_start ov18_021EFD00
ov18_021EFD00: ; 0x021EFD00
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	ldr r4, _021EFDA4 ; =0x000003E7
	add r5, r0, #0
	add r6, r2, #0
	cmp r1, r4
	bne _021EFD12
	add r4, #0xbd
	b _021EFD26
_021EFD12:
	ldr r0, _021EFDA8 ; =0x00002710
	mul r0, r1
	mov r1, #0xfe
	bl _u32_div_f
	add r0, r0, #5
	mov r1, #0xa
	bl _u32_div_f
	add r4, r0, #0
_021EFD26:
	add r7, r5, #0
	lsl r0, r6, #4
	add r7, #0xc
	str r0, [sp, #0x14]
	add r0, r7, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	mov r1, #0xc
	bl _u32_div_f
	mov r1, #0
	add r2, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x66
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	add r0, r4, #0
	mov r1, #0xc
	bl _u32_div_f
	mov r3, #2
	add r2, r1, #0
	mov r0, #0x66
	str r3, [sp]
	mov r1, #1
	str r1, [sp, #4]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl BufferIntegerAsString
	ldr r0, [sp, #0x14]
	add r0, r7, r0
	bl GetWindowWidth
	lsl r1, r0, #3
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, _021EFDAC ; =0x00020100
	ldr r1, _021EFDB0 ; =0x0000065C
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, [r5, r1]
	add r0, r5, #0
	add r2, r6, #0
	mov r3, #0xaf
	bl ov18_021EE3AC
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EFDA4: .word 0x000003E7
_021EFDA8: .word 0x00002710
_021EFDAC: .word 0x00020100
_021EFDB0: .word 0x0000065C
	thumb_func_end ov18_021EFD00

	thumb_func_start ov18_021EFDB4
ov18_021EFDB4: ; 0x021EFDB4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r0, _021EFE58 ; =0x0000270F
	add r4, r2, #0
	cmp r1, r0
	bne _021EFDC6
	ldr r6, _021EFE5C ; =0x00018696
	b _021EFDD6
_021EFDC6:
	ldr r0, _021EFE60 ; =0x00035D2E
	mul r0, r1
	ldr r1, _021EFE64 ; =0x0000C350
	add r0, r0, r1
	lsl r1, r1, #1
	bl _u32_div_f
	add r6, r0, #0
_021EFDD6:
	add r7, r5, #0
	lsl r0, r4, #4
	add r7, #0xc
	str r0, [sp, #0x14]
	add r0, r7, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #0
	mov r1, #0xa
	bl _u32_div_f
	mov r1, #0
	add r2, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x66
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r3, #4
	bl BufferIntegerAsString
	add r0, r6, #0
	mov r1, #0xa
	bl _u32_div_f
	mov r0, #2
	add r2, r1, #0
	str r0, [sp]
	mov r1, #1
	mov r0, #0x66
	str r1, [sp, #4]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	add r3, r1, #0
	bl BufferIntegerAsString
	ldr r0, [sp, #0x14]
	add r0, r7, r0
	bl GetWindowWidth
	lsl r1, r0, #3
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, _021EFE68 ; =0x00020100
	ldr r1, _021EFE6C ; =0x0000065C
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, [r5, r1]
	add r0, r5, #0
	add r2, r4, #0
	mov r3, #0x26
	bl ov18_021EE3AC
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EFE58: .word 0x0000270F
_021EFE5C: .word 0x00018696
_021EFE60: .word 0x00035D2E
_021EFE64: .word 0x0000C350
_021EFE68: .word 0x00020100
_021EFE6C: .word 0x0000065C
	thumb_func_end ov18_021EFDB4

	thumb_func_start ov18_021EFE70
ov18_021EFE70: ; 0x021EFE70
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r5, r6, #0
	lsl r4, r1, #4
	add r5, #0xc
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, r4
	bl GetWindowWidth
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021EFEB8 ; =0x00020100
	ldr r2, _021EFEBC ; =0x00001888
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, r4
	ldr r1, _021EFEC0 ; =0x0000065C
	lsl r4, r3, #3
	ldr r2, [r6, r2]
	lsr r3, r4, #0x1f
	add r3, r4, r3
	ldr r1, [r6, r1]
	add r2, #0x41
	asr r3, r3, #1
	bl ov18_021F9648
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EFEB8: .word 0x00020100
_021EFEBC: .word 0x00001888
_021EFEC0: .word 0x0000065C
	thumb_func_end ov18_021EFE70

	thumb_func_start ov18_021EFEC4
ov18_021EFEC4: ; 0x021EFEC4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r0, #0x1c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0x2c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0x3c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0x4c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0x5c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0x6c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	add r0, #0x7c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	mov r1, #1
	bl ov18_021EF1E4
	add r0, r4, #0
	mov r1, #2
	bl ov18_021EF220
	add r0, r4, #0
	mov r1, #3
	bl ov18_021EF25C
	add r0, r4, #0
	mov r1, #4
	bl ov18_021EF298
	add r0, r4, #0
	mov r1, #5
	bl ov18_021EF2D4
	add r0, r4, #0
	mov r1, #6
	bl ov18_021EF310
	add r0, r4, #0
	mov r1, #7
	bl ov18_021EF34C
	add r0, r4, #0
	mov r1, #8
	bl ov18_021EFBE8
	add r0, r4, #0
	mov r1, #9
	bl ov18_021EFC3C
	ldr r1, _021EFFE0 ; =0x00001870
	add r0, r4, #0
	ldr r1, [r4, r1]
	mov r2, #0xa
	mov r3, #0x1d
	bl ov18_021EFC9C
	ldr r1, _021EFFE4 ; =0x00001874
	add r0, r4, #0
	ldr r1, [r4, r1]
	mov r2, #0xb
	mov r3, #0x1d
	bl ov18_021EFC9C
	ldr r1, _021EFFE8 ; =0x00001850
	add r0, r4, #0
	ldr r2, [r4, r1]
	add r1, #0x28
	ldr r1, [r4, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0xc
	bl ov18_021EFD00
	ldr r1, _021EFFE8 ; =0x00001850
	add r0, r4, #0
	ldr r2, [r4, r1]
	add r1, #0x2c
	ldr r1, [r4, r1]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	mov r2, #0xd
	bl ov18_021EFD00
	ldr r1, _021EFFE8 ; =0x00001850
	add r0, r4, #0
	ldr r2, [r4, r1]
	add r1, #0x30
	ldr r1, [r4, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0xe
	bl ov18_021EFDB4
	ldr r1, _021EFFE8 ; =0x00001850
	add r0, r4, #0
	ldr r2, [r4, r1]
	add r1, #0x34
	ldr r1, [r4, r1]
	lsl r1, r1, #2
	add r1, r2, r1
	ldrh r1, [r1, #2]
	mov r2, #0xf
	bl ov18_021EFDB4
	add r0, r4, #0
	mov r1, #0x10
	bl ov18_021EFE70
	mov r5, #1
	add r4, #0x1c
_021EFFD0:
	add r0, r4, #0
	bl CopyWindowPixelsToVram_TextMode
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #0x10
	bls _021EFFD0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EFFE0: .word 0x00001870
_021EFFE4: .word 0x00001874
_021EFFE8: .word 0x00001850
	thumb_func_end ov18_021EFEC4

	thumb_func_start ov18_021EFFEC
ov18_021EFFEC: ; 0x021EFFEC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #8]
	mov r1, #0xf
	bl sub_02019B08
	add r0, r4, #0
	mov r1, #0x5f
	mov r2, #0
	bl ov18_021EE44C
	add r0, r4, #0
	mov r1, #0x60
	mov r2, #1
	bl ov18_021EE44C
	ldr r1, _021F0060 ; =0x0000185D
	ldr r2, _021F0064 ; =0x0000102C
	ldrb r1, [r4, r1]
	ldrh r2, [r4, r2]
	add r0, r4, #0
	add r1, #0x61
	bl ov18_021EE520
	ldr r1, _021F0060 ; =0x0000185D
	ldr r2, _021F0068 ; =0x0000102E
	ldrb r1, [r4, r1]
	ldrh r2, [r4, r2]
	add r0, r4, #0
	add r1, #0x63
	bl ov18_021EE520
	add r0, r4, #0
	mov r1, #0x5f
	bl ov18_021F006C
	add r0, r4, #0
	mov r1, #0x60
	bl ov18_021F006C
	ldr r1, _021F0060 ; =0x0000185D
	add r0, r4, #0
	ldrb r1, [r4, r1]
	add r1, #0x61
	bl ov18_021F006C
	ldr r1, _021F0060 ; =0x0000185D
	add r0, r4, #0
	ldrb r1, [r4, r1]
	add r1, #0x63
	bl ov18_021F006C
	ldr r1, _021F0060 ; =0x0000185D
	mov r0, #1
	ldrb r2, [r4, r1]
	eor r0, r2
	strb r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021F0060: .word 0x0000185D
_021F0064: .word 0x0000102C
_021F0068: .word 0x0000102E
	thumb_func_end ov18_021EFFEC

	thumb_func_start ov18_021F006C
ov18_021F006C: ; 0x021F006C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	str r0, [sp]
	add r4, r1, #0
	ldr r0, [r0, #8]
	mov r1, #0xf
	bl sub_02019B08
	str r0, [sp, #0xc]
	ldr r0, [sp]
	add r0, #0xc
	str r0, [sp]
	lsl r0, r4, #4
	ldr r1, [sp]
	str r0, [sp, #0x10]
	add r0, r1, r0
	bl GetWindowBaseTile
	add r5, r0, #0
	ldr r1, [sp]
	ldr r0, [sp, #0x10]
	add r0, r1, r0
	bl GetWindowX
	add r6, r0, #0
	ldr r1, [sp]
	ldr r0, [sp, #0x10]
	add r0, r1, r0
	bl GetWindowY
	add r7, r0, #0
	ldr r1, [sp]
	ldr r0, [sp, #0x10]
	add r0, r1, r0
	bl GetWindowWidth
	add r4, r0, #0
	ldr r1, [sp]
	ldr r0, [sp, #0x10]
	add r0, r1, r0
	bl GetWindowHeight
	str r0, [sp, #4]
	mov r0, #0
	mov ip, r0
	ldr r0, [sp, #4]
	cmp r0, #0
	bls _021F010A
	ldr r0, [sp, #0xc]
	lsl r2, r6, #1
	add r0, r0, r2
	mov r6, #0xf
	mov r1, ip
	str r0, [sp, #8]
	lsl r6, r6, #0xc
_021F00DA:
	mov r0, #0
	cmp r4, #0
	bls _021F00FA
	ldr r2, [sp, #8]
	lsl r3, r7, #6
	add r2, r2, r3
_021F00E6:
	ldrh r3, [r2]
	and r3, r6
	add r3, r5, r3
	add r3, r1, r3
	add r3, r0, r3
	strh r3, [r2]
	add r0, r0, #1
	add r2, r2, #2
	cmp r0, r4
	blo _021F00E6
_021F00FA:
	mov r0, ip
	add r2, r0, #1
	ldr r0, [sp, #4]
	add r7, r7, #1
	add r1, r1, r4
	mov ip, r2
	cmp r2, r0
	blo _021F00DA
_021F010A:
	ldr r1, [sp]
	ldr r0, [sp, #0x10]
	add r0, r1, r0
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F006C

	thumb_func_start ov18_021F0118
ov18_021F0118: ; 0x021F0118
	push {r3, r4, r5, lr}
	cmp r1, #1
	bne _021F0134
	add r5, r0, #0
	mov r4, #0
	add r5, #0xc
_021F0124:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x10
	bls _021F0124
	pop {r3, r4, r5, pc}
_021F0134:
	add r4, r0, #0
	mov r5, #0
	add r4, #0xc
_021F013A:
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #0x10
	bls _021F013A
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F0118

	thumb_func_start ov18_021F014C
ov18_021F014C: ; 0x021F014C
	push {r3, r4, r5, lr}
	ldr r1, _021F0164 ; =0x0000051C
	mov r4, #0x51
	add r5, r0, r1
_021F0154:
	add r0, r5, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x5d
	bls _021F0154
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F0164: .word 0x0000051C
	thumb_func_end ov18_021F014C

	thumb_func_start ov18_021F0168
ov18_021F0168: ; 0x021F0168
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r4, #0
	mov r6, #2
	mov r7, #0x12
_021F0172:
	str r6, [sp]
	add r1, r4, #0
	ldr r0, [r5, #8]
	add r1, #0x11
	add r2, r6, #0
	add r3, r7, #0
	bl sub_020195F4
	add r4, r4, #1
	cmp r4, #6
	blo _021F0172
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F0168

	thumb_func_start ov18_021F018C
ov18_021F018C: ; 0x021F018C
	push {r3, r4, r5, r6, r7, lr}
	mov r5, #1
	add r7, r0, #0
	mov r4, #0
	lsl r5, r5, #0xc
_021F0196:
	add r1, r4, #0
	ldr r0, [r7, #8]
	add r1, #0x11
	bl sub_02019B08
	add r2, r0, #0
	ldr r0, _021F01D0 ; =ov18_021F9E4C
	lsl r1, r4, #3
	add r0, r0, r1
	add r0, #0x46
	ldrh r6, [r0]
	mov r3, #0
_021F01AE:
	add r0, r6, r3
	add r1, r0, #0
	orr r1, r5
	lsl r0, r3, #1
	strh r1, [r2, r0]
	add r0, r3, #1
	lsl r0, r0, #0x10
	lsr r3, r0, #0x10
	cmp r3, #0x24
	blo _021F01AE
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #6
	blo _021F0196
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F01D0: .word ov18_021F9E4C
	thumb_func_end ov18_021F018C

	thumb_func_start ov18_021F01D4
ov18_021F01D4: ; 0x021F01D4
	push {r3, r4, r5, r6, r7, lr}
	mov r5, #1
	add r7, r0, #0
	mov r4, #0
	lsl r5, r5, #0xc
_021F01DE:
	add r1, r4, #0
	ldr r0, [r7, #8]
	add r1, #0x11
	bl sub_02019B08
	add r2, r0, #0
	ldr r0, _021F0218 ; =ov18_021F9EBC
	lsl r1, r4, #3
	add r0, r0, r1
	add r0, #0x56
	ldrh r6, [r0]
	mov r3, #0
_021F01F6:
	add r0, r6, r3
	add r1, r0, #0
	orr r1, r5
	lsl r0, r3, #1
	strh r1, [r2, r0]
	add r0, r3, #1
	lsl r0, r0, #0x10
	lsr r3, r0, #0x10
	cmp r3, #0x24
	blo _021F01F6
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #6
	blo _021F01DE
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F0218: .word ov18_021F9EBC
	thumb_func_end ov18_021F01D4

	thumb_func_start ov18_021F021C
ov18_021F021C: ; 0x021F021C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	ldr r1, _021F03A4 ; =ov18_021F9E4C
	add r5, r0, #0
	mov r2, #0xe
	bl ov18_021EE35C
	add r0, r5, #0
	add r0, #0xc
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x2c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x4c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F03A8 ; =0x00020100
	ldr r1, _021F03AC ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xc
	mov r2, #0x8e
	bl ov18_021F9648
	ldr r0, _021F03B0 ; =0x000018A2
	mov r1, #2
	ldrh r0, [r5, r0]
	mov r2, #0x25
	bl ov18_021E590C
	add r4, r0, #0
	mov r3, #0
	ldr r0, _021F03A8 ; =0x00020100
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x2c
	add r1, r4, #0
	mov r2, #0x24
	bl ov18_021F95FC
	add r0, r4, #0
	bl String_Delete
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F03B4 ; =0x00050900
	ldr r1, _021F03AC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x4c
	mov r2, #0x84
	mov r3, #0x18
	bl ov18_021F9648
	add r0, r5, #0
	add r0, #0xc
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x2c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x4c
	bl ScheduleWindowCopyToVram
	ldr r0, _021F03B8 ; =0x00001860
	ldr r0, [r5, r0]
	cmp r0, #1
	bne _021F0334
	add r0, r5, #0
	add r0, #0x5c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x7c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F03BC ; =0x000F0C00
	ldr r1, _021F03AC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x5c
	mov r2, #0x41
	mov r3, #0x1c
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F03BC ; =0x000F0C00
	ldr r1, _021F03AC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x7c
	mov r2, #0x42
	mov r3, #0x1c
	bl ov18_021F9648
	add r0, r5, #0
	add r0, #0x5c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x7c
	bl ScheduleWindowCopyToVram
	b _021F0364
_021F0334:
	add r0, r5, #0
	add r0, #0x6c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F03B4 ; =0x00050900
	ldr r1, _021F03AC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x6c
	mov r2, #0x41
	mov r3, #0x1c
	bl ov18_021F9648
	add r0, r5, #0
	add r0, #0x6c
	bl ScheduleWindowCopyToVram
_021F0364:
	add r0, r5, #0
	add r0, #0x3c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F03A8 ; =0x00020100
	ldr r1, _021F03AC ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x3c
	mov r2, #0x80
	mov r3, #0x38
	bl ov18_021F9648
	add r0, r5, #0
	add r0, #0x3c
	bl CopyWindowPixelsToVram_TextMode
	add r0, r5, #0
	bl ov18_021F03E0
	add r0, r5, #0
	bl ov18_021F0428
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F03A4: .word ov18_021F9E4C
_021F03A8: .word 0x00020100
_021F03AC: .word 0x0000065C
_021F03B0: .word 0x000018A2
_021F03B4: .word 0x00050900
_021F03B8: .word 0x00001860
_021F03BC: .word 0x000F0C00
	thumb_func_end ov18_021F021C

	thumb_func_start ov18_021F03C0
ov18_021F03C0: ; 0x021F03C0
	push {r4, r5, r6, lr}
	add r6, r0, #0
	add r5, r6, #0
	mov r4, #0
	add r5, #0xc
_021F03CA:
	add r0, r5, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0xe
	blo _021F03CA
	add r0, r6, #0
	bl ov18_021EE388
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021F03C0

	thumb_func_start ov18_021F03E0
ov18_021F03E0: ; 0x021F03E0
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r0, #0x1c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F041C ; =0x00020100
	ldr r2, _021F0420 ; =0x000018C9
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldr r1, _021F0424 ; =0x0000065C
	ldrsb r2, [r4, r2]
	add r0, r4, #0
	ldr r1, [r4, r1]
	add r0, #0x1c
	add r2, #0x81
	mov r3, #0x1c
	bl ov18_021F9648
	add r4, #0x1c
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021F041C: .word 0x00020100
_021F0420: .word 0x000018C9
_021F0424: .word 0x0000065C
	thumb_func_end ov18_021F03E0

	thumb_func_start ov18_021F0428
ov18_021F0428: ; 0x021F0428
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r6, r5, #0
	mov r4, #0
	add r6, #0xc
_021F0434:
	add r0, r4, #0
	add r0, #8
	lsl r7, r0, #4
	add r0, r6, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _021F04B4 ; =0x000018CA
	ldrsb r0, [r5, r0]
	add r0, r0, r4
	sub r1, r0, #2
	bmi _021F0480
	mov r0, #0x19
	lsl r0, r0, #8
	ldr r0, [r5, r0]
	cmp r1, r0
	bge _021F0480
	add r0, r5, #0
	bl ov18_021F04C0
	add r3, r0, #0
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, _021F04B8 ; =0x000F0C00
	add r2, r4, #0
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, _021F04BC ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r2, #8
	bl ov18_021EE3AC
_021F0480:
	add r0, r6, r7
	bl CopyWindowPixelsToVram_TextMode
	add r0, r6, r7
	bl GetWindowX
	str r0, [sp, #0x14]
	add r0, r6, r7
	bl GetWindowY
	add r3, r0, #0
	ldr r2, [sp, #0x14]
	add r1, r4, #0
	lsl r2, r2, #0x18
	lsl r3, r3, #0x18
	ldr r0, [r5, #8]
	add r1, #0x11
	asr r2, r2, #0x18
	asr r3, r3, #0x18
	bl sub_020196E8
	add r4, r4, #1
	cmp r4, #6
	blo _021F0434
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F04B4: .word 0x000018CA
_021F04B8: .word 0x000F0C00
_021F04BC: .word 0x0000065C
	thumb_func_end ov18_021F0428

	thumb_func_start ov18_021F04C0
ov18_021F04C0: ; 0x021F04C0
	push {r3, r4, r5, lr}
	ldr r2, _021F0500 ; =0x000018FC
	add r4, r0, #0
	ldr r5, [r4, r2]
	lsl r3, r1, #2
	ldr r5, [r5, r3]
	mov r3, #1
	mvn r3, r3
	cmp r5, r3
	bne _021F04E4
	sub r2, #0x34
	ldrsb r0, [r4, r2]
	cmp r0, #0
	bne _021F04E0
	mov r0, #0x86
	pop {r3, r4, r5, pc}
_021F04E0:
	mov r0, #0x87
	pop {r3, r4, r5, pc}
_021F04E4:
	bl ov18_021E8AE0
	bl MapHeader_GetMapSec
	add r2, r0, #0
	mov r0, #0x66
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl BufferLandmarkName
	mov r0, #0x85
	pop {r3, r4, r5, pc}
	nop
_021F0500: .word 0x000018FC
	thumb_func_end ov18_021F04C0

	thumb_func_start ov18_021F0504
ov18_021F0504: ; 0x021F0504
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	mov r4, #0
	add r5, r0, #0
	str r1, [sp, #0x14]
	add r6, sp, #0x18
	add r7, r4, #0
_021F0512:
	add r1, r4, #0
	add r2, sp, #0x18
	ldr r0, [r5, #8]
	add r1, #0x11
	add r2, #1
	add r3, sp, #0x18
	bl sub_02019B1C
	ldrsb r0, [r6, r7]
	cmp r0, #2
	beq _021F0532
	cmp r0, #0x14
	beq _021F0532
	add r4, r4, #1
	cmp r4, #6
	blo _021F0512
_021F0532:
	add r0, r4, #0
	add r6, r5, #0
	add r0, #8
	add r6, #0xc
	lsl r7, r0, #4
	add r0, r6, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	cmp r0, #0
	ldr r0, [r5, #8]
	bge _021F0592
	add r1, r4, #0
	add r1, #0x11
	mov r2, #0xa
	mov r3, #0x14
	bl sub_020196E8
	ldr r0, _021F05DC ; =0x000018CA
	ldrsb r1, [r5, r0]
	add r0, #0x36
	ldr r0, [r5, r0]
	add r1, r1, #2
	cmp r1, r0
	bge _021F05D0
	add r0, r5, #0
	bl ov18_021F04C0
	add r3, r0, #0
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, _021F05E0 ; =0x000F0C00
	add r4, #8
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, _021F05E4 ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r2, r4, #0
	bl ov18_021EE3AC
	b _021F05D0
_021F0592:
	add r1, r4, #0
	add r1, #0x11
	mov r2, #0xa
	mov r3, #2
	bl sub_020196E8
	ldr r0, _021F05DC ; =0x000018CA
	ldrsb r0, [r5, r0]
	sub r1, r0, #2
	bmi _021F05D0
	add r0, r5, #0
	bl ov18_021F04C0
	add r3, r0, #0
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, _021F05E0 ; =0x000F0C00
	add r4, #8
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, _021F05E4 ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r2, r4, #0
	bl ov18_021EE3AC
_021F05D0:
	add r0, r6, r7
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_021F05DC: .word 0x000018CA
_021F05E0: .word 0x000F0C00
_021F05E4: .word 0x0000065C
	thumb_func_end ov18_021F0504

	thumb_func_start ov18_021F05E8
ov18_021F05E8: ; 0x021F05E8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	ldr r1, _021F0820 ; =ov18_021F9DE4
	mov r2, #0xd
	add r5, r0, #0
	bl ov18_021EE35C
	mov r6, #0
	add r4, r5, #0
	add r4, #0xc
	add r7, r6, #0
_021F05FE:
	add r0, r4, #0
	add r1, r7, #0
	bl FillWindowPixelBuffer
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #0xd
	blo _021F05FE
	ldr r1, _021F0824 ; =0x000018A2
	ldr r0, [r5]
	ldrh r1, [r5, r1]
	ldr r0, [r0]
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F0622
	mov r4, #2
	b _021F0624
_021F0622:
	mov r4, #1
_021F0624:
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F0828 ; =0x00020100
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xc
	mov r2, #0x8f
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0828 ; =0x00020100
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x3c
	mov r2, #0x88
	mov r3, #0x30
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0828 ; =0x00020100
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x4c
	mov r2, #0xa
	mov r3, #0x10
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0828 ; =0x00020100
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x6c
	mov r2, #0xa
	mov r3, #0x10
	bl ov18_021F9648
	ldr r0, _021F0824 ; =0x000018A2
	mov r1, #2
	ldrh r0, [r5, r0]
	mov r2, #0x25
	bl ov18_021E590C
	add r6, r0, #0
	mov r3, #0
	ldr r0, _021F0828 ; =0x00020100
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x1c
	add r1, r6, #0
	mov r2, #0x20
	bl ov18_021F95FC
	add r0, r6, #0
	bl String_Delete
	ldr r0, [r5]
	mov r1, #0x25
	ldr r0, [r0, #4]
	bl PlayerProfile_GetPlayerName_NewString
	add r6, r0, #0
	mov r3, #0
	ldr r0, _021F0828 ; =0x00020100
	str r3, [sp]
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x2c
	add r1, r6, #0
	mov r2, #0x20
	bl ov18_021F95FC
	add r0, r6, #0
	bl String_Delete
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021F0828 ; =0x00020100
	ldr r1, _021F0824 ; =0x000018A2
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldrh r1, [r5, r1]
	add r0, r5, #0
	add r2, r4, #0
	mov r3, #5
	bl ov18_021EEA84
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0830 ; =0x00050900
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x8c
	mov r2, #0x89
	mov r3, #0x30
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0834 ; =0x000F0500
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x9c
	mov r2, #0xb
	mov r3, #0x10
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0834 ; =0x000F0500
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xbc
	mov r2, #0xb
	mov r3, #0x10
	bl ov18_021F9648
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _021F0834 ; =0x000F0500
	ldr r1, _021F0824 ; =0x000018A2
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldrh r1, [r5, r1]
	add r0, r5, #0
	add r2, r4, #0
	mov r3, #0xa
	bl ov18_021EEB34
	ldr r0, [r5]
	ldr r0, [r0, #4]
	bl PlayerProfile_GetTrainerGender
	cmp r0, #0
	ldr r1, _021F082C ; =0x0000065C
	bne _021F07D0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0828 ; =0x00020100
	mov r2, #0x8a
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x7c
	mov r3, #0x20
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0834 ; =0x000F0500
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xcc
	mov r2, #0x8c
	mov r3, #0x20
	bl ov18_021F9648
	b _021F080A
_021F07D0:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0828 ; =0x00020100
	mov r2, #0x8b
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x7c
	mov r3, #0x20
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0834 ; =0x000F0500
	ldr r1, _021F082C ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xcc
	mov r2, #0x8d
	mov r3, #0x20
	bl ov18_021F9648
_021F080A:
	mov r4, #0
	add r5, #0xc
_021F080E:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0xd
	blo _021F080E
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0820: .word ov18_021F9DE4
_021F0824: .word 0x000018A2
_021F0828: .word 0x00020100
_021F082C: .word 0x0000065C
_021F0830: .word 0x00050900
_021F0834: .word 0x000F0500
	thumb_func_end ov18_021F05E8

	thumb_func_start ov18_021F0838
ov18_021F0838: ; 0x021F0838
	push {r4, r5, r6, lr}
	add r6, r0, #0
	add r5, r6, #0
	mov r4, #0
	add r5, #0xc
_021F0842:
	add r0, r5, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0xd
	blo _021F0842
	add r0, r6, #0
	bl ov18_021EE388
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021F0838

	thumb_func_start ov18_021F0858
ov18_021F0858: ; 0x021F0858
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	ldr r1, _021F08D0 ; =ov18_021F9DB0
	mov r2, #2
	add r5, r0, #0
	bl ov18_021EE35C
	mov r6, #0
	add r4, r5, #0
	add r4, #0xc
	add r7, r6, #0
_021F086E:
	add r0, r4, #0
	add r1, r7, #0
	bl FillWindowPixelBuffer
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #2
	blo _021F086E
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F08D4 ; =0x00020100
	ldr r1, _021F08D8 ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xc
	mov r2, #0xad
	bl ov18_021F9648
	mov r0, #0
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F08DC ; =0x000F0C00
	ldr r1, _021F08D8 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x1c
	mov r2, #0xae
	mov r3, #0x3c
	bl ov18_021F9648
	mov r4, #0
	add r5, #0xc
_021F08BE:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #2
	blo _021F08BE
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F08D0: .word ov18_021F9DB0
_021F08D4: .word 0x00020100
_021F08D8: .word 0x0000065C
_021F08DC: .word 0x000F0C00
	thumb_func_end ov18_021F0858

	thumb_func_start ov18_021F08E0
ov18_021F08E0: ; 0x021F08E0
	push {r4, r5, r6, lr}
	add r6, r0, #0
	add r5, r6, #0
	mov r4, #0
	add r5, #0xc
_021F08EA:
	add r0, r5, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #2
	blo _021F08EA
	add r0, r6, #0
	bl ov18_021EE388
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021F08E0

	thumb_func_start ov18_021F0900
ov18_021F0900: ; 0x021F0900
	push {r4, lr}
	ldr r1, _021F0914 ; =ov18_021F9EBC
	add r4, r0, #0
	mov r2, #0x10
	bl ov18_021EE35C
	add r0, r4, #0
	bl ov18_021F0928
	pop {r4, pc}
	.balign 4, 0
_021F0914: .word ov18_021F9EBC
	thumb_func_end ov18_021F0900

	thumb_func_start ov18_021F0918
ov18_021F0918: ; 0x021F0918
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F0D7C
	add r0, r4, #0
	bl ov18_021EE388
	pop {r4, pc}
	thumb_func_end ov18_021F0918

	thumb_func_start ov18_021F0928
ov18_021F0928: ; 0x021F0928
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F0940
	add r0, r4, #0
	bl ov18_021F0C50
	add r0, r4, #0
	bl ov18_021F0D2C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F0928

	thumb_func_start ov18_021F0940
ov18_021F0940: ; 0x021F0940
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r6, r5, #0
	mov r4, #0
	add r6, #0xc
_021F094C:
	add r0, r4, #0
	add r0, #0xa
	lsl r7, r0, #4
	add r0, r6, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _021F09C8 ; =0x000018C5
	ldrsb r0, [r5, r0]
	add r0, r0, r4
	sub r1, r0, #2
	bmi _021F0994
	ldr r0, _021F09CC ; =0x000018C4
	ldrsb r0, [r5, r0]
	cmp r1, r0
	bge _021F0994
	add r0, r5, #0
	bl ov18_021F09D8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r0, _021F09D0 ; =0x000F0C00
	add r2, r4, #0
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	ldr r1, _021F09D4 ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r2, #0xa
	bl ov18_021EE3AC
_021F0994:
	add r0, r6, r7
	bl CopyWindowPixelsToVram_TextMode
	add r0, r6, r7
	bl GetWindowX
	str r0, [sp, #0x14]
	add r0, r6, r7
	bl GetWindowY
	add r3, r0, #0
	ldr r2, [sp, #0x14]
	add r1, r4, #0
	lsl r2, r2, #0x18
	lsl r3, r3, #0x18
	ldr r0, [r5, #8]
	add r1, #0x11
	asr r2, r2, #0x18
	asr r3, r3, #0x18
	bl sub_020196E8
	add r4, r4, #1
	cmp r4, #6
	blo _021F094C
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F09C8: .word 0x000018C5
_021F09CC: .word 0x000018C4
_021F09D0: .word 0x000F0C00
_021F09D4: .word 0x0000065C
	thumb_func_end ov18_021F0940

	thumb_func_start ov18_021F09D8
ov18_021F09D8: ; 0x021F09D8
	push {r3, r4, r5, lr}
	sub sp, #8
	ldr r2, _021F0B64 ; =0x000018A2
	add r4, r0, #0
	ldrh r0, [r4, r2]
	ldr r3, _021F0B68 ; =0x0000019D
	cmp r0, r3
	bgt ov18_021F0A1E
	sub r5, r3, #1
	cmp r0, r5
	blt _021F09FA
	add r2, r5, #0
	cmp r0, r2
	beq _021F0A8C
	cmp r0, r3
	beq _021F0A8C
	b _021F0B1E
_021F09FA:
	cmp r0, #0xc9
	bgt ov18_021F0A06
	bge _021F0A76
	cmp r0, #0xac
	beq _021F0AFC
	b _021F0B1E
ov18_021F0A06:
	add r5, r3, #0
	sub r5, #0x3e
	cmp r0, r5
	bgt ov18_021F0A16
	sub r3, #0x3e
	cmp r0, r3
	beq _021F0ADC
	b _021F0B1E
ov18_021F0A16:
	sub r3, #0x1b
	cmp r0, r3
	beq _021F0A9C
	b _021F0B1E
ov18_021F0A1E:
	add r5, r3, #0
	add r5, #0x42
	cmp r0, r5
	bgt ov18_021F0A5E
	add r5, r3, #0
	add r5, #0x42
	cmp r0, r5
	bge _021F0ACC
	add r5, r3, #0
	add r5, #8
	cmp r0, r5
	bgt ov18_021F0A3E
	add r3, #8
	cmp r0, r3
	beq _021F0AEC
	b _021F0B1E
ov18_021F0A3E:
	add r2, r3, #0
	add r2, #0xa
	cmp r0, r2
	bgt _021F0B1E
	add r2, r3, #0
	add r2, #9
	cmp r0, r2
	blt _021F0B1E
	add r2, r3, #0
	add r2, #9
	cmp r0, r2
	beq _021F0A7C
	add r3, #0xa
	cmp r0, r3
	beq _021F0A7C
	b _021F0B1E
ov18_021F0A5E:
	add r5, r3, #0
	add r5, #0x4a
	cmp r0, r5
	bgt ov18_021F0A6E
	add r3, #0x4a
	cmp r0, r3
	beq _021F0ABC
	b _021F0B1E
ov18_021F0A6E:
	add r3, #0x4f
	cmp r0, r3
	beq _021F0AAC
	b _021F0B1E
_021F0A76:
	add sp, #8
	mov r0, #0x79
	pop {r3, r4, r5, pc}
_021F0A7C:
	ldr r0, _021F0B6C ; =0x000018A4
	add r1, r4, r1
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0x74
	pop {r3, r4, r5, pc}
_021F0A8C:
	ldr r0, _021F0B6C ; =0x000018A4
	add r1, r4, r1
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0x76
	pop {r3, r4, r5, pc}
_021F0A9C:
	add r1, r4, r1
	add r0, r2, #2
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0x91
	pop {r3, r4, r5, pc}
_021F0AAC:
	add r1, r4, r1
	add r0, r2, #2
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0x95
	pop {r3, r4, r5, pc}
_021F0ABC:
	add r1, r4, r1
	add r0, r2, #2
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0x97
	pop {r3, r4, r5, pc}
_021F0ACC:
	add r1, r4, r1
	add r0, r2, #2
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0x99
	pop {r3, r4, r5, pc}
_021F0ADC:
	add r1, r4, r1
	add r0, r2, #2
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0xa0
	pop {r3, r4, r5, pc}
_021F0AEC:
	add r1, r4, r1
	add r0, r2, #2
	ldrb r1, [r1, r0]
	mov r0, #0x80
	add sp, #8
	eor r0, r1
	add r0, #0xa4
	pop {r3, r4, r5, pc}
_021F0AFC:
	add r1, r4, r1
	add r0, r2, #2
	ldrb r1, [r1, r0]
	mov r0, #0x80
	eor r0, r1
	bne _021F0B0E
	add sp, #8
	mov r0, #0x72
	pop {r3, r4, r5, pc}
_021F0B0E:
	cmp r0, #1
	bne _021F0B18
	add sp, #8
	mov r0, #0x73
	pop {r3, r4, r5, pc}
_021F0B18:
	add sp, #8
	mov r0, #0xa6
	pop {r3, r4, r5, pc}
_021F0B1E:
	add r2, r4, r1
	ldr r1, _021F0B6C ; =0x000018A4
	ldrb r1, [r2, r1]
	cmp r1, #1
	bne _021F0B2E
	add sp, #8
	mov r0, #0x72
	pop {r3, r4, r5, pc}
_021F0B2E:
	cmp r1, #2
	bne _021F0B38
	add sp, #8
	mov r0, #0x73
	pop {r3, r4, r5, pc}
_021F0B38:
	mov r1, #2
	mov r2, #0x25
	bl ov18_021E590C
	add r5, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r3, #2
	mov r0, #0x66
	str r3, [sp, #4]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	add r2, r5, #0
	bl BufferString
	add r0, r5, #0
	bl String_Delete
	mov r0, #0x9f
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F0B64: .word 0x000018A2
_021F0B68: .word 0x0000019D
_021F0B6C: .word 0x000018A4
	thumb_func_end ov18_021F09D8

	thumb_func_start ov18_021F0B70
ov18_021F0B70: ; 0x021F0B70
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	mov r4, #0
	add r5, r0, #0
	str r1, [sp, #0x14]
	add r6, sp, #0x18
	sub r7, r4, #2
_021F0B7E:
	add r1, r4, #0
	add r2, sp, #0x18
	ldr r0, [r5, #8]
	add r1, #0x11
	add r2, #1
	add r3, sp, #0x18
	bl sub_02019B1C
	mov r0, #0
	ldrsb r0, [r6, r0]
	cmp r0, r7
	beq _021F0BA0
	cmp r0, #0x10
	beq _021F0BA0
	add r4, r4, #1
	cmp r4, #6
	blo _021F0B7E
_021F0BA0:
	add r0, r4, #0
	add r6, r5, #0
	add r0, #0xa
	add r6, #0xc
	lsl r7, r0, #4
	add r0, r6, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	cmp r0, #0
	ldr r0, [r5, #8]
	bge _021F0BFC
	add r1, r4, #0
	add r1, #0x11
	mov r2, #8
	mov r3, #0x10
	bl sub_020196E8
	ldr r0, _021F0C44 ; =0x000018C5
	ldrsb r1, [r5, r0]
	sub r0, r0, #1
	ldrsb r0, [r5, r0]
	add r1, r1, #2
	cmp r1, r0
	bge _021F0C38
	add r0, r5, #0
	bl ov18_021F09D8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	add r4, #0xa
	str r0, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	ldr r1, _021F0C48 ; =0x000F0C00
	add r2, r4, #0
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r1, _021F0C4C ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov18_021EE3AC
	b _021F0C38
_021F0BFC:
	mov r2, #8
	add r1, r4, #0
	add r3, r2, #0
	add r1, #0x11
	sub r3, #0xa
	bl sub_020196E8
	ldr r0, _021F0C44 ; =0x000018C5
	ldrsb r0, [r5, r0]
	sub r1, r0, #2
	bmi _021F0C38
	add r0, r5, #0
	bl ov18_021F09D8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	add r4, #0xa
	str r0, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	ldr r1, _021F0C48 ; =0x000F0C00
	add r2, r4, #0
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r1, _021F0C4C ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov18_021EE3AC
_021F0C38:
	add r0, r6, r7
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_021F0C44: .word 0x000018C5
_021F0C48: .word 0x000F0C00
_021F0C4C: .word 0x0000065C
	thumb_func_end ov18_021F0B70

	thumb_func_start ov18_021F0C50
ov18_021F0C50: ; 0x021F0C50
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	add r0, #0xc
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x4c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x1c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F0D18 ; =0x00020100
	ldr r1, _021F0D1C ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xc
	mov r2, #0xaa
	bl ov18_021F9648
	ldr r0, _021F0D20 ; =0x000018C4
	ldrsb r0, [r5, r0]
	cmp r0, #1
	beq _021F0CB2
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F0D24 ; =0x000F0C00
	ldr r1, _021F0D1C ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x4c
	mov r2, #0xa8
	bl ov18_021F9648
_021F0CB2:
	ldr r0, _021F0D28 ; =0x000018A2
	mov r1, #2
	ldrh r0, [r5, r0]
	mov r2, #0x25
	bl ov18_021E590C
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r3, #2
	mov r0, #0x66
	str r3, [sp, #4]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	add r2, r4, #0
	bl BufferString
	add r0, r4, #0
	bl String_Delete
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0D18 ; =0x00020100
	mov r2, #1
	str r0, [sp, #0xc]
	ldr r1, _021F0D1C ; =0x0000065C
	str r2, [sp, #0x10]
	ldr r1, [r5, r1]
	add r0, r5, #0
	mov r3, #0xa7
	bl ov18_021EE3AC
	add r0, r5, #0
	add r0, #0xc
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x4c
	bl ScheduleWindowCopyToVram
	add r5, #0x1c
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, pc}
	nop
_021F0D18: .word 0x00020100
_021F0D1C: .word 0x0000065C
_021F0D20: .word 0x000018C4
_021F0D24: .word 0x000F0C00
_021F0D28: .word 0x000018A2
	thumb_func_end ov18_021F0C50

	thumb_func_start ov18_021F0D2C
ov18_021F0D2C: ; 0x021F0D2C
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r0, #0x2c
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, _021F0D70 ; =0x000018C5
	add r0, r4, #0
	ldrsb r1, [r4, r1]
	bl ov18_021F09D8
	add r3, r0, #0
	mov r0, #0x3c
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0D74 ; =0x00020100
	mov r2, #2
	str r0, [sp, #0xc]
	ldr r1, _021F0D78 ; =0x0000065C
	str r2, [sp, #0x10]
	ldr r1, [r4, r1]
	add r0, r4, #0
	bl ov18_021EE3AC
	add r4, #0x2c
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r3, r4, pc}
	nop
_021F0D70: .word 0x000018C5
_021F0D74: .word 0x00020100
_021F0D78: .word 0x0000065C
	thumb_func_end ov18_021F0D2C

	thumb_func_start ov18_021F0D7C
ov18_021F0D7C: ; 0x021F0D7C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x1c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x2c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x4c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xac
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xbc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xcc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xdc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xec
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, #0xfc
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	thumb_func_end ov18_021F0D7C

	thumb_func_start ov18_021F0DD0
ov18_021F0DD0: ; 0x021F0DD0
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	bl ov18_021F0D7C
	add r0, r5, #0
	add r0, #0xc
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x3c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x5c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x8c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x9c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F0F10 ; =0x00020100
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xc
	mov r2, #0xaa
	bl ov18_021F9648
	ldr r0, _021F0F18 ; =0x000018A2
	mov r1, #2
	ldrh r0, [r5, r0]
	mov r2, #0x25
	bl ov18_021E590C
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r3, #2
	mov r0, #0x66
	str r3, [sp, #4]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	add r2, r4, #0
	bl BufferString
	add r0, r4, #0
	bl String_Delete
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0F10 ; =0x00020100
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, [r5, r1]
	add r0, r5, #0
	mov r2, #3
	mov r3, #0xa9
	bl ov18_021EE3AC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0F1C ; =0x00050900
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x5c
	mov r2, #0xaa
	mov r3, #0x18
	bl ov18_021F9648
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0F20 ; =0x000F0C00
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x8c
	mov r2, #0xab
	mov r3, #0x30
	bl ov18_021F9648
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0F20 ; =0x000F0C00
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x9c
	mov r2, #0xac
	mov r3, #0x30
	bl ov18_021F9648
	add r0, r5, #0
	add r0, #0xc
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x3c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x5c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x8c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x9c
	bl ScheduleWindowCopyToVram
	ldr r2, _021F0F24 ; =0x000018C5
	add r0, r5, #0
	ldrsb r2, [r5, r2]
	mov r1, #6
	bl ov18_021F0F68
	ldr r2, _021F0F28 ; =0x000018C6
	add r0, r5, #0
	ldrsb r2, [r5, r2]
	mov r1, #7
	bl ov18_021F0F68
	add sp, #0x14
	pop {r4, r5, pc}
	.balign 4, 0
_021F0F10: .word 0x00020100
_021F0F14: .word 0x0000065C
_021F0F18: .word 0x000018A2
_021F0F1C: .word 0x00050900
_021F0F20: .word 0x000F0C00
_021F0F24: .word 0x000018C5
_021F0F28: .word 0x000018C6
	thumb_func_end ov18_021F0DD0

	thumb_func_start ov18_021F0F2C
ov18_021F0F2C: ; 0x021F0F2C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x3c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x5c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x8c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x9c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x6c
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, #0x7c
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	thumb_func_end ov18_021F0F2C

	thumb_func_start ov18_021F0F68
ov18_021F0F68: ; 0x021F0F68
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r6, r0, #0
	add r7, r1, #0
	add r5, r6, #0
	add r5, #0xc
	lsl r4, r7, #4
	str r2, [sp, #0x14]
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, [sp, #0x14]
	add r0, r6, #0
	bl ov18_021F09D8
	str r0, [sp, #0x18]
	add r0, r5, r4
	bl GetWindowWidth
	lsl r1, r0, #3
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0FC0 ; =0x00050900
	ldr r1, _021F0FC4 ; =0x0000065C
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, [r6, r1]
	ldr r3, [sp, #0x18]
	add r0, r6, #0
	add r2, r7, #0
	bl ov18_021EE3AC
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0FC0: .word 0x00050900
_021F0FC4: .word 0x0000065C
	thumb_func_end ov18_021F0F68

	thumb_func_start ov18_021F0FC8
ov18_021F0FC8: ; 0x021F0FC8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	bl ov18_021F12FC
	add r0, r4, #0
	bl ov18_021F1024
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F0FC8

	thumb_func_start ov18_021F0FEC
ov18_021F0FEC: ; 0x021F0FEC
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F1104
	add r0, r4, #0
	bl ov18_021F10C8
	add r0, r4, #0
	bl ov18_021F1314
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F0FEC

	thumb_func_start ov18_021F1004
ov18_021F1004: ; 0x021F1004
	push {r4, r5, r6, lr}
	mov r6, #0x67
	add r5, r0, #0
	mov r4, #0
	lsl r6, r6, #4
_021F100E:
	ldr r0, [r5, r6]
	cmp r0, #0
	beq _021F1018
	bl ManagedSprite_TickFrame
_021F1018:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0x78
	blo _021F100E
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F1004

	thumb_func_start ov18_021F1024
ov18_021F1024: ; 0x021F1024
	push {r4, r5, r6, r7, lr}
	sub sp, #0x4c
	add r4, r0, #0
	mov r0, #0x25
	bl SpriteSystem_Alloc
	ldr r1, _021F10B4 ; =0x00000668
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	bl SpriteManager_New
	ldr r7, _021F10B8 ; =0x0000066C
	add r2, sp, #0x2c
	ldr r3, _021F10BC ; =ov18_021FA3C8
	str r0, [r4, r7]
	ldmia r3!, {r0, r1}
	add r6, r2, #0
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	ldr r5, _021F10C0 ; =ov18_021FA36C
	stmia r2!, {r0, r1}
	add r3, sp, #0x18
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	add r1, r6, #0
	str r0, [r3]
	sub r0, r7, #4
	ldr r0, [r4, r0]
	mov r3, #0x20
	bl SpriteSystem_Init
	ldr r3, _021F10C4 ; =ov18_021FA380
	add r2, sp, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x78
	bl SpriteSystem_InitSprites
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	add r2, sp, #0
	bl SpriteSystem_InitManagerWithCapacities
	sub r0, r7, #4
	ldr r0, [r4, r0]
	bl SpriteSystem_GetRenderer
	mov r2, #2
	mov r1, #0
	lsl r2, r2, #0x14
	bl G2dRenderer_SetSubSurfaceCoords
	add sp, #0x4c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F10B4: .word 0x00000668
_021F10B8: .word 0x0000066C
_021F10BC: .word ov18_021FA3C8
_021F10C0: .word ov18_021FA36C
_021F10C4: .word ov18_021FA380
	thumb_func_end ov18_021F1024

	thumb_func_start ov18_021F10C8
ov18_021F10C8: ; 0x021F10C8
	push {r4, lr}
	ldr r1, _021F10E4 ; =0x00000668
	add r4, r0, #0
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	bl SpriteSystem_FreeResourcesAndManager
	ldr r0, _021F10E4 ; =0x00000668
	ldr r0, [r4, r0]
	bl SpriteSystem_Free
	pop {r4, pc}
	nop
_021F10E4: .word 0x00000668
	thumb_func_end ov18_021F10C8

	thumb_func_start ov18_021F10E8
ov18_021F10E8: ; 0x021F10E8
	push {r3, r4, r5, lr}
	lsl r5, r1, #2
	mov r1, #0x67
	lsl r1, r1, #4
	add r4, r0, r1
	ldr r0, [r4, r5]
	cmp r0, #0
	beq _021F1100
	bl Sprite_DeleteAndFreeResources
	mov r0, #0
	str r0, [r4, r5]
_021F1100:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F10E8

	thumb_func_start ov18_021F1104
ov18_021F1104: ; 0x021F1104
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
_021F110A:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F10E8
	add r4, r4, #1
	cmp r4, #0x78
	blo _021F110A
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F1104

	thumb_func_start ov18_021F111C
ov18_021F111C: ; 0x021F111C
	push {r4, r5, r6, lr}
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r5, r2, #0
	ldr r0, [r0]
	add r4, r3, #0
	bl Sprite_GetImageProxy
	ldr r1, [sp, #0x10]
	bl NNS_G2dGetImageLocation
	add r6, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl DC_FlushRange
	ldr r0, [sp, #0x10]
	cmp r0, #1
	bne _021F1154
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl GX_LoadOBJ
	pop {r4, r5, r6, pc}
_021F1154:
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl GXS_LoadOBJ
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021F111C

	thumb_func_start ov18_021F1160
ov18_021F1160: ; 0x021F1160
	push {r3, lr}
	cmp r2, #1
	bne _021F1178
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetOamMode
	pop {r3, pc}
_021F1178:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetOamMode
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov18_021F1160

	thumb_func_start ov18_021F118C
ov18_021F118C: ; 0x021F118C
	push {r4, r5, r6, lr}
	add r6, r2, #0
	mov r2, #0x67
	lsl r2, r2, #4
	lsl r4, r1, #2
	add r5, r0, r2
	ldr r0, [r5, r4]
	mov r1, #0
	bl ManagedSprite_SetAnimationFrame
	ldr r0, [r5, r4]
	add r1, r6, #0
	bl ManagedSprite_SetAnim
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F118C

	thumb_func_start ov18_021F11AC
ov18_021F11AC: ; 0x021F11AC
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r3, _021F11BC ; =ManagedSprite_IsAnimated
	ldr r0, [r1, r0]
	bx r3
	nop
_021F11BC: .word ManagedSprite_IsAnimated
	thumb_func_end ov18_021F11AC

	thumb_func_start ov18_021F11C0
ov18_021F11C0: ; 0x021F11C0
	push {r3, lr}
	cmp r2, #1
	bne _021F11D8
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
_021F11D8:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov18_021F11C0

	thumb_func_start ov18_021F11EC
ov18_021F11EC: ; 0x021F11EC
	push {r3, lr}
	add r2, r1, #0
	add r3, r0, #0
	ldr r0, [r2, #0x10]
	ldr r1, _021F1218 ; =0x00000668
	cmp r0, #1
	bne _021F1206
	ldr r0, [r3, r1]
	add r1, r1, #4
	ldr r1, [r3, r1]
	bl SpriteSystem_NewSprite
	pop {r3, pc}
_021F1206:
	ldr r0, [r3, r1]
	add r1, r1, #4
	ldr r1, [r3, r1]
	mov r3, #2
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	pop {r3, pc}
	nop
_021F1218: .word 0x00000668
	thumb_func_end ov18_021F11EC

	thumb_func_start ov18_021F121C
ov18_021F121C: ; 0x021F121C
	push {r3, r4, r5, r6, r7, lr}
	add r4, r2, #0
	ldr r2, [sp, #0x18]
	add r6, r3, #0
	cmp r2, #0
	bne _021F125A
	mov r2, #0x67
	lsl r2, r2, #4
	add r5, r0, r2
	lsl r7, r1, #2
	add r1, sp, #0
	ldr r0, [r5, r7]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	add r2, sp, #0
	mov r1, #2
	ldrsh r1, [r2, r1]
	mov r3, #0
	ldrsh r2, [r2, r3]
	add r1, r1, r4
	lsl r1, r1, #0x10
	add r2, r2, r6
	lsl r2, r2, #0x10
	ldr r0, [r5, r7]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, r6, r7, pc}
_021F125A:
	mov r2, #0x67
	lsl r2, r2, #4
	add r5, r0, r2
	lsl r7, r1, #2
	add r1, sp, #0
	mov r3, #2
	ldr r0, [r5, r7]
	add r1, #2
	add r2, sp, #0
	lsl r3, r3, #0x14
	bl ManagedSprite_GetPositionXYWithSubscreenOffset
	add r2, sp, #0
	mov r3, #2
	ldrsh r1, [r2, r3]
	ldr r0, [r5, r7]
	lsl r3, r3, #0x14
	add r1, r1, r4
	mov r4, #0
	ldrsh r2, [r2, r4]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add r2, r2, r6
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F121C

	thumb_func_start ov18_021F1294
ov18_021F1294: ; 0x021F1294
	push {r4, lr}
	ldr r4, [sp, #8]
	cmp r4, #0
	bne _021F12B0
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	bl ManagedSprite_SetPositionXY
	pop {r4, pc}
_021F12B0:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	mov r3, #2
	lsl r3, r3, #0x14
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	pop {r4, pc}
	thumb_func_end ov18_021F1294

	thumb_func_start ov18_021F12C8
ov18_021F12C8: ; 0x021F12C8
	push {r4, lr}
	ldr r4, [sp, #8]
	cmp r4, #0
	bne _021F12E4
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	bl ManagedSprite_GetPositionXY
	pop {r4, pc}
_021F12E4:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	mov r3, #2
	lsl r3, r3, #0x14
	bl ManagedSprite_GetPositionXYWithSubscreenOffset
	pop {r4, pc}
	thumb_func_end ov18_021F12C8

	thumb_func_start ov18_021F12FC
ov18_021F12FC: ; 0x021F12FC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x14
	mov r1, #0x25
	bl NARC_New
	ldr r1, _021F1310 ; =0x00000858
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_021F1310: .word 0x00000858
	thumb_func_end ov18_021F12FC

	thumb_func_start ov18_021F1314
ov18_021F1314: ; 0x021F1314
	ldr r1, _021F131C ; =0x00000858
	ldr r3, _021F1320 ; =NARC_Delete
	ldr r0, [r0, r1]
	bx r3
	.balign 4, 0
_021F131C: .word 0x00000858
_021F1320: .word NARC_Delete
	thumb_func_end ov18_021F1314

	thumb_func_start ov18_021F1324
ov18_021F1324: ; 0x021F1324
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r6, r1, #0
	ldr r4, _021F13C4 ; =0x00000000
	beq _021F1354
	mov r7, #1
_021F1332:
	ldr r0, _021F13C8 ; =0x0000C550
	str r7, [sp]
	str r7, [sp, #4]
	add r0, r4, r0
	str r0, [sp, #8]
	ldr r0, _021F13CC ; =0x00000668
	ldr r1, _021F13D0 ; =0x0000066C
	ldr r2, _021F13D4 ; =0x00000854
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	add r4, r4, #1
	cmp r4, r6
	blo _021F1332
_021F1354:
	bl sub_02074490
	ldr r1, _021F13D8 ; =0x00000858
	ldr r3, _021F13CC ; =0x00000668
	ldr r2, [r5, r1]
	sub r1, #8
	str r2, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #3
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, _021F13C8 ; =0x0000C550
	str r0, [sp, #0x14]
	ldr r2, [r5, r3]
	add r3, r3, #4
	ldr r0, [r5, r1]
	ldr r3, [r5, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	bl sub_0207449C
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F13C8 ; =0x0000C550
	ldr r1, _021F13CC ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F13D8 ; =0x00000858
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	bl sub_020744A8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F13C8 ; =0x0000C550
	ldr r1, _021F13CC ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F13D8 ; =0x00000858
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F13C4: .word 0x00000000
_021F13C8: .word 0x0000C550
_021F13CC: .word 0x00000668
_021F13D0: .word 0x0000066C
_021F13D4: .word 0x00000854
_021F13D8: .word 0x00000858
	thumb_func_end ov18_021F1324

	thumb_func_start ov18_021F13DC
ov18_021F13DC: ; 0x021F13DC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	ldr r4, _021F1418 ; =0x00000000
	beq _021F13F8
	ldr r7, _021F141C ; =0x0000C550
_021F13E8:
	ldr r0, _021F1420 ; =0x0000066C
	add r1, r4, r7
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadCharObjById
	add r4, r4, #1
	cmp r4, r6
	blo _021F13E8
_021F13F8:
	ldr r0, _021F1420 ; =0x0000066C
	ldr r1, _021F141C ; =0x0000C550
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F1420 ; =0x0000066C
	ldr r1, _021F141C ; =0x0000C550
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F1420 ; =0x0000066C
	ldr r1, _021F141C ; =0x0000C550
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F1418: .word 0x00000000
_021F141C: .word 0x0000C550
_021F1420: .word 0x0000066C
	thumb_func_end ov18_021F13DC

	thumb_func_start ov18_021F1424
ov18_021F1424: ; 0x021F1424
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x68
	add r7, r0, #0
	lsl r0, r1, #2
	ldr r3, _021F147C ; =ov18_021FA3E8
	mov r4, #0
	add r5, r7, r0
	add r2, sp, #0
	mov r6, #6
_021F1436:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _021F1436
	ldr r0, [r3]
	str r0, [r2]
_021F1442:
	add r6, sp, #0
	add r3, sp, #0x34
	mov r2, #6
_021F1448:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F1448
	ldr r0, [r6]
	ldr r1, _021F1480 ; =0x0000066C
	str r0, [r3]
	ldr r0, _021F1484 ; =0x0000C550
	add r2, sp, #0x34
	add r0, r4, r0
	str r0, [sp, #0x48]
	ldr r0, _021F1488 ; =0x00000668
	ldr r1, [r7, r1]
	ldr r0, [r7, r0]
	bl SpriteSystem_NewSprite
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0x3c
	blo _021F1442
	add sp, #0x68
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F147C: .word ov18_021FA3E8
_021F1480: .word 0x0000066C
_021F1484: .word 0x0000C550
_021F1488: .word 0x00000668
	thumb_func_end ov18_021F1424

	thumb_func_start ov18_021F148C
ov18_021F148C: ; 0x021F148C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #0
	add r4, r3, #0
	bl GetBattleMonIconNaixEx
	add r1, r0, #0
	mov r0, #0x25
	str r0, [sp]
	ldr r0, _021F14B0 ; =0x00000858
	mov r2, #0
	ldr r0, [r5, r0]
	add r3, r4, #0
	bl GfGfxLoader_GetCharDataFromOpenNarc
	pop {r3, r4, r5, pc}
	nop
_021F14B0: .word 0x00000858
	thumb_func_end ov18_021F148C

	thumb_func_start ov18_021F14B4
ov18_021F14B4: ; 0x021F14B4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, _021F14F4 ; =0x0000066C
	str r1, [sp, #4]
	add r4, r2, #0
	ldr r0, [r5, r0]
	ldr r1, _021F14F8 ; =0x0000C550
	mov r2, #1
	add r6, r3, #0
	bl SpriteManager_FindPlttResourceOffset
	mov r3, #1
	add r7, r0, #0
	str r3, [sp]
	ldr r2, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	lsl r3, r3, #9
	bl ov18_021F111C
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r7, r6
	bl ManagedSprite_SetPaletteOverride
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F14F4: .word 0x0000066C
_021F14F8: .word 0x0000C550
	thumb_func_end ov18_021F14B4

	thumb_func_start ov18_021F14FC
ov18_021F14FC: ; 0x021F14FC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	str r3, [sp]
	add r4, r1, #0
	add r6, r2, #0
	add r3, sp, #4
	add r5, r0, #0
	bl ov18_021F148C
	add r7, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	mov r2, #0
	bl GetBattleMonIconPaletteEx
	ldr r1, [sp, #4]
	add r3, r0, #0
	ldr r1, [r1, #0x14]
	ldr r2, [sp]
	add r0, r5, #0
	bl ov18_021F14B4
	add r0, r7, #0
	bl Heap_Free
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F14FC

	thumb_func_start ov18_021F1534
ov18_021F1534: ; 0x021F1534
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r3, #0
	add r3, sp, #0xc
	add r5, r0, #0
	add r7, r1, #0
	str r2, [sp, #4]
	bl ov18_021F148C
	mov r3, #2
	str r3, [sp]
	ldr r2, [sp, #0xc]
	str r0, [sp, #8]
	ldr r2, [r2, #0x14]
	add r0, r5, #0
	add r1, r4, #0
	lsl r3, r3, #8
	bl ov18_021F111C
	ldr r0, _021F1590 ; =0x0000066C
	ldr r1, _021F1594 ; =0x0000C551
	ldr r0, [r5, r0]
	mov r2, #2
	bl SpriteManager_FindPlttResourceOffset
	add r6, r0, #0
	ldr r1, [sp, #4]
	add r0, r7, #0
	mov r2, #0
	bl GetBattleMonIconPaletteEx
	add r1, r0, #0
	lsl r0, r4, #2
	add r2, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	add r1, r6, r1
	bl ManagedSprite_SetPaletteOverride
	ldr r0, [sp, #8]
	bl Heap_Free
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F1590: .word 0x0000066C
_021F1594: .word 0x0000C551
	thumb_func_end ov18_021F1534
