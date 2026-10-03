	.include "asm/macros.inc"
	.include "overlay_82.inc"
	.include "global.inc"

	.text

	thumb_func_start ov82_0223F6C4
ov82_0223F6C4: ; 0x0223F6C4
	cmp r0, #0x11
	blo _0223F6CA
	mov r0, #0x11
_0223F6CA:
	bx lr
	thumb_func_end ov82_0223F6C4

	thumb_func_start ov82_0223F6CC
ov82_0223F6CC: ; 0x0223F6CC
	ldrb r1, [r0, #9]
	cmp r1, #0
	bne _0223F6E0
	ldrh r0, [r0, #0x1c]
	cmp r0, #0x32
	beq _0223F6DC
	cmp r0, #0xaa
	bne _0223F6E0
_0223F6DC:
	mov r0, #1
	bx lr
_0223F6E0:
	mov r0, #0
	bx lr
	thumb_func_end ov82_0223F6CC

	thumb_func_start ov82_0223F6E4
ov82_0223F6E4: ; 0x0223F6E4
	ldrb r0, [r0, #0x1e]
	bx lr
	thumb_func_end ov82_0223F6E4

	thumb_func_start ov82_0223F6E8
ov82_0223F6E8: ; 0x0223F6E8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldrb r0, [r5, #9]
	add r4, r1, #0
	add r7, r2, #0
	bl ov80_0223792C
	cmp r0, #0
	bne _0223F6FE
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0223F6FE:
	cmp r4, #4
	beq _0223F70C
	cmp r4, #5
	beq _0223F718
	cmp r4, #6
	beq _0223F726
	b _0223F732
_0223F70C:
	add r0, r5, #0
	add r1, r4, #0
	mov r6, #0x27
	bl ov82_0223F74C
	b _0223F732
_0223F718:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r7, #0
	mov r6, #0x28
	bl ov82_0223F770
	b _0223F732
_0223F726:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r7, #0
	mov r6, #0x29
	bl ov82_0223F808
_0223F732:
	mov r1, #0x89
	lsl r1, r1, #2
	add r0, r6, #0
	add r1, r5, r1
	mov r2, #0x2c
	bl sub_02037030
	cmp r0, #1
	bne _0223F748
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0223F748:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov82_0223F6E8

	thumb_func_start ov82_0223F74C
ov82_0223F74C: ; 0x0223F74C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0xa0
	ldr r0, [r0]
	add r4, r1, #0
	bl Save_PlayerData_GetProfile
	mov r0, #0x89
	lsl r0, r0, #2
	strh r4, [r5, r0]
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov82_0223F74C

	thumb_func_start ov82_0223F764
ov82_0223F764: ; 0x0223F764
	push {r4, lr}
	add r4, r0, #0
	bl sub_0203769C
	cmp r4, r0
	pop {r4, pc}
	thumb_func_end ov82_0223F764

	thumb_func_start ov82_0223F770
ov82_0223F770: ; 0x0223F770
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x89
	lsl r0, r0, #2
	strh r1, [r5, r0]
	add r4, r2, #0
	add r0, r0, #2
	strh r4, [r5, r0]
	bl sub_0203769C
	cmp r0, #0
	bne _0223F790
	ldrb r0, [r5, #0x18]
	cmp r0, #0xff
	bne _0223F790
	strb r4, [r5, #0x18]
_0223F790:
	ldrb r1, [r5, #0x18]
	mov r0, #0x8a
	lsl r0, r0, #2
	strh r1, [r5, r0]
	sub r0, #0x14
	ldr r0, [r5, r0]
	mov r1, #0
	bl Party_GetMonByIndex
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	ldr r1, _0223F7B0 ; =0x0000022A
	strh r0, [r5, r1]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223F7B0: .word 0x0000022A
	thumb_func_end ov82_0223F770

	thumb_func_start ov82_0223F7B4
ov82_0223F7B4: ; 0x0223F7B4
	push {r4, r5, r6, lr}
	add r4, r3, #0
	add r6, r0, #0
	ldrb r0, [r4, #0x16]
	add r5, r2, #0
	add r0, r0, #1
	strb r0, [r4, #0x16]
	bl sub_0203769C
	cmp r6, r0
	beq _0223F804
	ldrh r1, [r5, #2]
	mov r0, #0x9f
	lsl r0, r0, #2
	strb r1, [r4, r0]
	bl sub_0203769C
	cmp r0, #0
	bne _0223F7F6
	ldrb r0, [r4, #0x18]
	cmp r0, #0xff
	beq _0223F7EA
	mov r0, #0x9f
	mov r1, #0
	lsl r0, r0, #2
	strb r1, [r4, r0]
	b _0223F7FA
_0223F7EA:
	mov r0, #0x9f
	lsl r0, r0, #2
	ldrb r0, [r4, r0]
	add r0, #0x14
	strb r0, [r4, #0x18]
	b _0223F7FA
_0223F7F6:
	ldrh r0, [r5, #4]
	strb r0, [r4, #0x18]
_0223F7FA:
	mov r0, #0x87
	lsl r0, r0, #2
	ldrh r1, [r5, #6]
	ldr r0, [r4, r0]
	strh r1, [r0]
_0223F804:
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov82_0223F7B4

	thumb_func_start ov82_0223F808
ov82_0223F808: ; 0x0223F808
	mov r3, #0x89
	lsl r3, r3, #2
	strh r1, [r0, r3]
	add r1, r3, #2
	strh r2, [r0, r1]
	bx lr
	thumb_func_end ov82_0223F808

	thumb_func_start ov82_0223F814
ov82_0223F814: ; 0x0223F814
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r2, #0
	add r6, r3, #0
	bl sub_0203769C
	cmp r5, r0
	beq _0223F82E
	ldrh r1, [r4, #2]
	cmp r1, #0
	beq _0223F82E
	ldr r0, _0223F830 ; =0x0000027D
	strb r1, [r6, r0]
_0223F82E:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0223F830: .word 0x0000027D
	thumb_func_end ov82_0223F814

	thumb_func_start ov82_0223F834
ov82_0223F834: ; 0x0223F834
	push {r3, lr}
	ldrb r1, [r0, #0xf]
	cmp r1, #1
	bne _0223F848
	mov r1, #0
	strb r1, [r0, #0xf]
	add r0, #0x8c
	ldr r0, [r0]
	bl YesNoPrompt_Reset
_0223F848:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov82_0223F834

	thumb_func_start ov82_0223F84C
ov82_0223F84C: ; 0x0223F84C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ov82_0223FCB0
	add r0, r4, #0
	add r0, #0x9c
	ldr r0, [r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r4, #0
	add r0, #0x4c
	bl ov82_0223FD78
	ldrb r0, [r4, #0xd]
	bl ov80_02237920
	add r2, r0, #0
	ldr r0, [r4, #0x24]
	mov r1, #0
	bl BufferTypeName
	ldrb r0, [r4, #0xd]
	bl ov82_0223F6C4
	mov r1, #0x86
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	bl sub_02030BD0
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	cmp r2, #0xa
	bls _0223F89C
	mov r2, #0xa
_0223F89C:
	add r0, r4, #0
	mov r1, #1
	bl ov82_0223EFB4
	add r0, r4, #0
	bl ov82_0223F6E4
	cmp r0, #1
	bne _0223F8B2
	mov r1, #0x1f
	b _0223F8B4
_0223F8B2:
	mov r1, #0x18
_0223F8B4:
	add r0, r4, #0
	mov r2, #1
	bl ov82_0223EF7C
	strb r0, [r4, #0xa]
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ov82_0223FCFC
	add r2, r4, #0
	add r0, r4, #0
	add r2, #0x90
	add r0, #0x8c
	ldrb r2, [r2]
	ldr r0, [r0]
	ldr r1, [r4, #0x48]
	bl ov82_0223FDC8
	mov r0, #1
	strb r0, [r4, #0xf]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov82_0223F84C

	thumb_func_start ov82_0223F8E4
ov82_0223F8E4: ; 0x0223F8E4
	push {r4, lr}
	add r4, r0, #0
	bl ov82_0223F90C
	ldrb r1, [r4, #0xd]
	ldr r0, [r4, #0x48]
	mov r2, #0
	bl ov82_0223F5E0
	ldr r0, [r4, #0x48]
	mov r1, #3
	bl ScheduleBgTilemapBufferTransfer
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl ov82_0223FCFC
	pop {r4, pc}
	thumb_func_end ov82_0223F8E4
