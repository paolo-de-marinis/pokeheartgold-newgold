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
.public ov18_021F51BC
.public ov18_021F51CC
.public ov18_021F5238
.public ov18_021F52A4
.public ov18_021F5310
.public ov18_021F537C
.public ov18_021F53E8
.public ov18_021F5454
.public ov18_021F5638
.public ov18_021F56DC
.public ov18_021F57B4
.public ov18_021F588C
.public ov18_021F5964
.public ov18_021F5A3C
.public ov18_021F5B14
.public ov18_021F5BEC
.public ov18_021F5CC4
.public ov18_021F6E98
.public ov18_021F6EAC
.public ov18_021F6F78
.public ov18_021F6F8C
.public ov18_021F7060
.public ov18_021F7104
.public ov18_021F71DC
.public ov18_021F7334
.public ov18_021F74B0
.public ov18_021F74C4
.public ov18_021F7634
.public ov18_021F7648
.public ov18_021F7720
.public ov18_021F7734
.public ov18_021F7800
.public ov18_021F7954
.public ov18_021F7B90

	thumb_func_start ov18_021EECB0
ov18_021EECB0: ; 0x021EECB0
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r0, #0
	add r5, r6, #0
	add r5, #0xc
	lsl r4, r2, #4
	add r7, r1, #0
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, _021EECF8 ; =0x0000185C
	add r0, r7, #0
	ldrb r1, [r6, r1]
	mov r2, #0x25
	bl ov18_021E590C
	add r6, r0, #0
	mov r2, #0
	ldr r0, _021EECFC ; =0x00020100
	str r2, [sp]
	str r0, [sp, #4]
	add r0, r5, r4
	add r1, r6, #0
	add r3, r2, #0
	str r2, [sp, #8]
	bl ov18_021F95FC
	add r0, r6, #0
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021EECF8: .word 0x0000185C
_021EECFC: .word 0x00020100
	thumb_func_end ov18_021EECB0
