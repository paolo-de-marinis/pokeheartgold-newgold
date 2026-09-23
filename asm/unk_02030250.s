	.include "asm/macros.inc"
	.include "unk_0202FBCC.inc"
	.include "global.inc"

.public _021D2AF8

	.text

	thumb_func_start sub_02030250
sub_02030250: ; 0x02030250
	ldr r3, _02030254 ; =_MonEncryptSegment
	bx r3
	.balign 4, 0
_02030254: .word _MonEncryptSegment
	thumb_func_end sub_02030250

	thumb_func_start sub_02030258
sub_02030258: ; 0x02030258
	ldr r3, _0203025C ; =_MonDecryptSegment
	bx r3
	.balign 4, 0
_0203025C: .word _MonDecryptSegment
	thumb_func_end sub_02030258

	thumb_func_start sub_02030260
sub_02030260: ; 0x02030260
	ldr r3, _02030278 ; =_021D2AF8
	ldr r3, [r3]
	cmp r3, #0
	beq _02030274
	lsl r0, r0, #0xa
	add r0, r3, r0
	add r1, r0, r1
	mov r0, #0x8e
	lsl r0, r0, #2
	strb r2, [r1, r0]
_02030274:
	bx lr
	nop
_02030278: .word _021D2AF8
	thumb_func_end sub_02030260

	thumb_func_start sub_0203027C
sub_0203027C: ; 0x0203027C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _020302A0 ; =_021D2AF8
	add r4, r1, #0
	ldr r0, [r0]
	cmp r0, #0
	bne _0203028E
	bl GF_AssertFail
_0203028E:
	ldr r0, _020302A0 ; =_021D2AF8
	ldr r1, [r0]
	lsl r0, r5, #0xa
	add r0, r1, r0
	add r1, r0, r4
	mov r0, #0x8e
	lsl r0, r0, #2
	ldrb r0, [r1, r0]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_020302A0: .word _021D2AF8
	thumb_func_end sub_0203027C

	thumb_func_start sub_020302A4
sub_020302A4: ; 0x020302A4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r0, [sp]
	ldr r0, _0203048C ; =_021D2AF8
	ldr r1, [r0]
	cmp r1, #0
	bne _020302B4
	b _02030488
_020302B4:
	ldr r0, [sp]
	add r7, r1, #0
	ldr r0, [r0]
	add r1, #0xe8
	str r0, [r1]
	ldr r0, [sp]
	add r7, #0xe8
	ldr r0, [r0, #0x14]
	ldr r1, [sp]
	str r0, [r7, #4]
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r2, [r1, r0]
	add r1, r7, #0
	add r1, #0xe8
	str r2, [r1]
	ldr r1, [sp]
	add r2, r0, #4
	ldr r2, [r1, r2]
	add r1, r7, #0
	add r1, #0xec
	str r2, [r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #8
	ldr r2, [r1, r2]
	add r1, r7, #0
	add r1, #0xf0
	str r2, [r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0xc
	ldr r2, [r1, r2]
	add r1, r7, #0
	add r1, #0xf4
	str r2, [r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x10
	ldr r2, [r1, r2]
	add r1, r7, #0
	add r1, #0xf8
	str r2, [r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x14
	ldr r2, [r1, r2]
	add r1, r7, #0
	add r1, #0xfc
	str r2, [r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x18
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x4c
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x1c
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x48
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x24
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x44
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x28
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x40
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x2c
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x3c
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x40
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x28
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x44
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x24
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x48
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x20
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x50
	ldr r2, [r1, r2]
	add r1, r0, #0
	sub r1, #0x1c
	str r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x64
	ldrh r2, [r1, r2]
	add r1, r0, #0
	sub r1, #8
	strh r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x67
	ldrb r2, [r1, r2]
	sub r1, r0, #6
	ldr r4, [sp]
	strh r2, [r7, r1]
	add r2, r0, #0
	ldr r1, [sp]
	add r2, #0x68
	ldr r1, [r1, r2]
	sub r0, r0, #4
	str r1, [r7, r0]
	add r0, r4, #0
	mov r3, #0
	add r5, r7, #0
	str r0, [sp, #8]
	str r7, [sp, #4]
_020303C8:
	ldr r0, [r4, #0x18]
	ldr r2, [sp, #8]
	ldr r6, [sp, #4]
	str r0, [r5, #8]
	mov r0, #6
	add r2, #0x28
	add r6, #0x18
	mov ip, r0
_020303D8:
	ldmia r2!, {r0, r1}
	stmia r6!, {r0, r1}
	mov r0, ip
	sub r0, r0, #1
	mov ip, r0
	bne _020303D8
	ldr r0, [r2]
	mov r1, #0x5f
	lsl r1, r1, #2
	str r0, [r6]
	ldr r0, [r4, r1]
	cmp r0, #0
	bne _020303FA
	mov r0, #5
	sub r1, #0x68
	lsl r0, r0, #6
	b _020303FC
_020303FA:
	sub r1, #0x68
_020303FC:
	str r0, [r5, r1]
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r2, [r4, r0]
	add r1, r0, #0
	sub r1, #0x6c
	str r2, [r5, r1]
	ldr r1, [sp]
	add r4, r4, #4
	add r2, r1, r3
	add r1, r0, #0
	add r1, #0x1c
	ldrb r2, [r2, r1]
	add r1, r7, r3
	sub r0, #0x54
	strb r2, [r1, r0]
	ldr r0, [sp, #8]
	add r3, r3, #1
	add r0, #0x34
	str r0, [sp, #8]
	ldr r0, [sp, #4]
	add r5, r5, #4
	add r0, #0x34
	str r0, [sp, #4]
	cmp r3, #4
	blt _020303C8
	ldr r0, _02030490 ; =0x00001150
	ldr r4, [sp]
	add r0, r7, r0
	str r0, [sp, #0xc]
	ldr r0, _02030494 ; =0x00001BE0
	mov r5, #0
	add r6, r7, r0
_0203043E:
	ldr r0, [r4, #4]
	ldr r1, [sp, #0xc]
	bl sub_020306DC
	add r0, r4, #0
	add r0, #0xf8
	ldr r0, [r0]
	add r1, r6, #0
	bl PlayerProfile_Copy
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl sub_02006EFC
	mov r1, #0x53
	add r2, r7, r5
	lsl r1, r1, #2
	strb r0, [r2, r1]
	mov r0, #0xa9
	ldr r1, [sp, #0xc]
	lsl r0, r0, #2
	add r0, r1, r0
	add r5, r5, #1
	str r0, [sp, #0xc]
	add r4, r4, #4
	add r6, #0x20
	cmp r5, #4
	blt _0203043E
	mov r1, #0x13
	ldr r0, [sp]
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	ldr r1, _02030498 ; =0x00001C60
	add r1, r7, r1
	bl Options_Copy
_02030488:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0203048C: .word _021D2AF8
_02030490: .word 0x00001150
_02030494: .word 0x00001BE0
_02030498: .word 0x00001C60
	thumb_func_end sub_020302A4

	thumb_func_start sub_0203049C
sub_0203049C: ; 0x0203049C
	ldr r2, _020304B0 ; =_021D2AF8
	ldr r2, [r2]
	cmp r2, #0
	beq _020304AE
	lsl r0, r0, #2
	add r2, r2, r0
	mov r0, #0x7f
	lsl r0, r0, #2
	str r1, [r2, r0]
_020304AE:
	bx lr
	.balign 4, 0
_020304B0: .word _021D2AF8
	thumb_func_end sub_0203049C

	thumb_func_start sub_020304B4
sub_020304B4: ; 0x020304B4
	push {r3, r4}
	ldr r0, _020304EC ; =_021D2AF8
	ldr r4, [r0]
	cmp r4, #0
	bne _020304C4
	mov r0, #1
	pop {r3, r4}
	bx lr
_020304C4:
	mov r0, #0x45
	lsl r0, r0, #2
	add r1, r0, #0
	mov r3, #0
	add r4, #0xe8
	add r1, #0x2c
_020304D0:
	ldr r2, [r4, r0]
	cmp r2, r1
	bls _020304DC
	mov r0, #0
	pop {r3, r4}
	bx lr
_020304DC:
	add r3, r3, #1
	add r4, r4, #4
	cmp r3, #4
	blt _020304D0
	mov r0, #1
	pop {r3, r4}
	bx lr
	nop
_020304EC: .word _021D2AF8
	thumb_func_end sub_020304B4

	thumb_func_start sub_020304F0
sub_020304F0: ; 0x020304F0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r6, r0, #0
	ldr r0, _020306C8 ; =_021D2AF8
	str r1, [sp]
	ldr r1, [r0]
	add r0, r1, #0
	str r0, [sp, #0x14]
	add r0, #0xe8
	add r1, #0xe8
	str r0, [sp, #0x14]
	ldr r0, [r1]
	str r0, [r6]
	ldr r0, [sp, #0x14]
	add r0, #0xe8
	ldr r1, [r0]
	mov r0, #0x53
	lsl r0, r0, #2
	str r1, [r6, r0]
	ldr r1, [sp, #0x14]
	add r1, #0xec
	ldr r2, [r1]
	add r1, r0, #4
	str r2, [r6, r1]
	ldr r1, [sp, #0x14]
	add r1, #0xf0
	ldr r2, [r1]
	add r1, r0, #0
	add r1, #8
	str r2, [r6, r1]
	ldr r1, [sp, #0x14]
	add r1, #0xf4
	ldr r2, [r1]
	add r1, r0, #0
	add r1, #0xc
	str r2, [r6, r1]
	ldr r1, [sp, #0x14]
	add r1, #0xf8
	ldr r2, [r1]
	add r1, r0, #0
	add r1, #0x10
	str r2, [r6, r1]
	ldr r1, [sp, #0x14]
	add r1, #0xfc
	ldr r2, [r1]
	add r1, r0, #0
	add r1, #0x14
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x4c
	ldr r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x18
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x48
	ldr r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x1c
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x44
	ldr r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x24
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x40
	ldr r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x28
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x28
	ldr r2, [r1, r2]
	mov r1, #0x10
	orr r2, r1
	add r1, r0, #0
	add r1, #0x40
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x24
	ldr r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x44
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x20
	ldr r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x48
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #0x1c
	ldr r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x50
	str r2, [r6, r1]
	add r2, r0, #0
	ldr r1, [sp, #0x14]
	sub r2, #8
	ldrh r2, [r1, r2]
	add r1, r0, #0
	add r1, #0x64
	strh r2, [r6, r1]
	mov r1, #0
	str r1, [r6, #0x14]
	add r0, #0x2c
	str r1, [r6, r0]
	ldr r0, [sp]
	bl Save_Pokedex_Get
	mov r1, #0x11
	lsl r1, r1, #4
	ldr r1, [r6, r1]
	bl Pokedex_Copy
	ldr r5, [sp, #0x14]
	ldr r1, _020306CC ; =0x00001150
	add r0, r5, #0
	str r0, [sp, #0x10]
	add r0, r0, r1
	str r0, [sp, #8]
	ldr r1, _020306D0 ; =0x00001BE0
	add r0, r5, #0
	add r0, r0, r1
	mov r7, #0
	add r4, r6, #0
	str r6, [sp, #0xc]
	str r0, [sp, #4]
_02030604:
	ldr r0, [r5, #8]
	ldr r3, [sp, #0x10]
	ldr r2, [sp, #0xc]
	str r0, [r4, #0x18]
	mov r0, #6
	add r3, #0x18
	add r2, #0x28
	mov ip, r0
_02030614:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	mov r0, ip
	sub r0, r0, #1
	mov ip, r0
	bne _02030614
	ldr r0, [r3]
	mov r1, #0x45
	lsl r1, r1, #2
	str r0, [r2]
	add r0, r1, #0
	ldr r2, [r5, r1]
	add r0, #0x68
	str r2, [r4, r0]
	add r0, r1, #0
	add r0, #0x20
	ldr r0, [r5, r0]
	add r1, #0x8c
	str r0, [r4, r1]
	ldr r0, [sp, #8]
	ldr r1, [r4, #4]
	bl sub_02030724
	add r1, r4, #0
	add r1, #0xf8
	ldr r0, [sp, #4]
	ldr r1, [r1]
	bl PlayerProfile_Copy
	ldr r0, [sp, #0x14]
	add r5, r5, #4
	add r1, r0, r7
	mov r0, #0x53
	lsl r0, r0, #2
	ldrb r2, [r1, r0]
	add r1, r6, r7
	add r0, #0x70
	strb r2, [r1, r0]
	ldr r0, [sp, #0x10]
	mov r1, #0xa9
	add r0, #0x34
	str r0, [sp, #0x10]
	ldr r0, [sp, #0xc]
	lsl r1, r1, #2
	add r0, #0x34
	str r0, [sp, #0xc]
	ldr r0, [sp, #8]
	add r7, r7, #1
	add r0, r0, r1
	str r0, [sp, #8]
	ldr r0, [sp, #4]
	add r4, r4, #4
	add r0, #0x20
	str r0, [sp, #4]
	cmp r7, #4
	blt _02030604
	ldr r0, [sp]
	bl Save_PlayerData_GetOptionsAddr
	mov r1, #0x13
	lsl r1, r1, #4
	ldr r1, [r6, r1]
	bl Options_Copy
	mov r5, #0x13
	lsl r5, r5, #4
	ldr r1, [r6, r5]
	ldr r4, _020306D4 ; =0x00001C60
	ldr r2, [sp, #0x14]
	ldrh r0, [r1]
	ldrh r2, [r2, r4]
	ldr r3, _020306D8 ; =0xFFFF83FF
	lsl r2, r2, #0x11
	lsr r2, r2, #0x1b
	lsl r2, r2, #0x1b
	and r0, r3
	lsr r2, r2, #0x11
	orr r0, r2
	strh r0, [r1]
	ldr r2, [r6, r5]
	ldrh r0, [r2]
	lsl r1, r0, #0x11
	lsr r1, r1, #0x1b
	cmp r1, #0x14
	blo _020306C2
	and r0, r3
	strh r0, [r2]
_020306C2:
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_020306C8: .word _021D2AF8
_020306CC: .word 0x00001150
_020306D0: .word 0x00001BE0
_020306D4: .word 0x00001C60
_020306D8: .word 0xFFFF83FF
	thumb_func_end sub_020304F0

	thumb_func_start sub_020306DC
sub_020306DC: ; 0x020306DC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r1, #0
	mov r2, #0xa9
	add r7, r0, #0
	add r0, r6, #0
	mov r1, #0
	lsl r2, r2, #2
	bl MI_CpuFill8
	add r0, r7, #0
	bl Party_GetMaxCount
	strh r0, [r6]
	add r0, r7, #0
	bl Party_GetCount
	strh r0, [r6, #2]
	ldrh r0, [r6, #2]
	mov r4, #0
	cmp r0, #0
	ble _02030720
	add r5, r6, #4
_02030708:
	add r0, r7, #0
	add r1, r4, #0
	bl Party_GetMonByIndex
	add r1, r5, #0
	bl sub_02072A98
	ldrh r0, [r6, #2]
	add r4, r4, #1
	add r5, #0x70
	cmp r4, r0
	blt _02030708
_02030720:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end sub_020306DC

	thumb_func_start sub_02030724
sub_02030724: ; 0x02030724
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r7, r0, #0
	str r1, [sp]
	mov r1, #0
	add r0, sp, #4
	strb r1, [r0]
	mov r0, #0xb
	bl AllocMonZeroed
	add r4, r0, #0
	ldrh r1, [r7]
	ldr r0, [sp]
	bl Party_InitWithMaxSize
	ldrh r0, [r7, #2]
	mov r6, #0
	cmp r0, #0
	ble _02030770
	add r5, r7, #4
_0203074C:
	add r0, r5, #0
	add r1, r4, #0
	bl sub_02072D64
	add r0, r4, #0
	mov r1, #0xa2
	add r2, sp, #4
	bl SetMonData
	ldr r0, [sp]
	add r1, r4, #0
	bl Party_AddMon
	ldrh r0, [r7, #2]
	add r6, r6, #1
	add r5, #0x70
	cmp r6, r0
	blt _0203074C
_02030770:
	add r0, r4, #0
	bl Heap_Free
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end sub_02030724

	thumb_func_start sub_0203077C
sub_0203077C: ; 0x0203077C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _020307A8 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _0203078C
	bl GF_AssertFail
_0203078C:
	add r0, r4, #0
	mov r1, #0x64
	bl Heap_Alloc
	add r4, r0, #0
	ldr r0, _020307A8 ; =_021D2AF8
	add r1, r4, #0
	ldr r0, [r0]
	mov r2, #0x64
	add r0, #0x84
	bl MIi_CpuCopy32
	add r0, r4, #0
	pop {r4, pc}
	.balign 4, 0
_020307A8: .word _021D2AF8
	thumb_func_end sub_0203077C

	thumb_func_start sub_020307AC
sub_020307AC: ; 0x020307AC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _020307D8 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _020307BC
	bl GF_AssertFail
_020307BC:
	add r0, r4, #0
	mov r1, #0x80
	bl Heap_Alloc
	add r4, r0, #0
	ldr r0, _020307D8 ; =_021D2AF8
	add r1, r4, #0
	ldr r0, [r0]
	mov r2, #0x80
	add r0, r0, #4
	bl MIi_CpuCopy32
	add r0, r4, #0
	pop {r4, pc}
	.balign 4, 0
_020307D8: .word _021D2AF8
	thumb_func_end sub_020307AC

	thumb_func_start sub_020307DC
sub_020307DC: ; 0x020307DC
	push {r3, lr}
	ldr r0, _020307F4 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _020307EA
	bl GF_AssertFail
_020307EA:
	ldr r0, _020307F4 ; =_021D2AF8
	ldr r0, [r0]
	add r0, r0, #4
	pop {r3, pc}
	nop
_020307F4: .word _021D2AF8
	thumb_func_end sub_020307DC

	thumb_func_start sub_020307F8
sub_020307F8: ; 0x020307F8
	push {r3, lr}
	ldr r0, _02030810 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _02030806
	bl GF_AssertFail
_02030806:
	ldr r0, _02030810 ; =_021D2AF8
	ldr r0, [r0]
	add r0, #0x84
	pop {r3, pc}
	nop
_02030810: .word _021D2AF8
	thumb_func_end sub_020307F8

	thumb_func_start sub_02030814
sub_02030814: ; 0x02030814
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _0203087C ; =_021D2AF8
	add r6, r1, #0
	ldr r0, [r0]
	add r7, r2, #0
	add r4, r3, #0
	cmp r0, #0
	bne _0203082A
	bl GF_AssertFail
_0203082A:
	ldr r1, _0203087C ; =_021D2AF8
	add r0, r6, #0
	ldr r1, [r1]
	mov r2, #0x64
	add r1, #0x84
	bl MI_CpuCopy8
	ldr r1, _0203087C ; =_021D2AF8
	ldr r2, _02030880 ; =0x00001C68
	ldr r1, [r1]
	add r0, r7, #0
	add r1, #0xe8
	bl MI_CpuCopy8
	ldr r1, _0203087C ; =_021D2AF8
	add r0, r5, #0
	ldr r1, [r1]
	mov r2, #0x80
	add r1, r1, #4
	bl MI_CpuCopy8
	ldr r0, _0203087C ; =_021D2AF8
	ldr r1, _02030884 ; =0x00001D4C
	ldr r0, [r0]
	ldr r2, _02030888 ; =0x0000FFFF
	ldrh r3, [r0, r1]
	add r0, #0xe8
	sub r1, #0xe8
	eor r2, r3
	lsl r2, r2, #0x10
	add r2, r3, r2
	bl sub_02030258
	cmp r4, #0
	beq _02030878
	ldr r1, [sp, #0x18]
	add r0, r4, #0
	bl sub_020304F0
_02030878:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0203087C: .word _021D2AF8
_02030880: .word 0x00001C68
_02030884: .word 0x00001D4C
_02030888: .word 0x0000FFFF
	thumb_func_end sub_02030814
