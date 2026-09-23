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

.public ov18_021F8168

	.text

	thumb_func_start ov18_021F8468
ov18_021F8468: ; 0x021F8468
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r1, #0
	add r4, r2, #0
	add r5, r3, #0
	cmp r0, #0xe
	bhi _021F855C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F8482: ; jump table
	.short ov18_021F8544 - ov18_021F8482 - 2 ; case 0
	.short ov18_021F8514 - ov18_021F8482 - 2 ; case 1
	.short ov18_021F8520 - ov18_021F8482 - 2 ; case 2
	.short ov18_021F852C - ov18_021F8482 - 2 ; case 3
	.short ov18_021F84E4 - ov18_021F8482 - 2 ; case 4
	.short ov18_021F84D8 - ov18_021F8482 - 2 ; case 5
	.short ov18_021F8508 - ov18_021F8482 - 2 ; case 6
	.short ov18_021F84B4 - ov18_021F8482 - 2 ; case 7
	.short ov18_021F8550 - ov18_021F8482 - 2 ; case 8
	.short ov18_021F84FC - ov18_021F8482 - 2 ; case 9
	.short ov18_021F8538 - ov18_021F8482 - 2 ; case 10
	.short ov18_021F84CC - ov18_021F8482 - 2 ; case 11
	.short ov18_021F84F0 - ov18_021F8482 - 2 ; case 12
	.short ov18_021F84C0 - ov18_021F8482 - 2 ; case 13
	.short ov18_021F84A0 - ov18_021F8482 - 2 ; case 14
ov18_021F84A0:
	ldr r2, [sp, #0x28]
	add r0, r6, #0
	add r1, r5, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0x14
	str r0, [r4]
	pop {r4, r5, r6, r7, pc}
ov18_021F84B4:
	mov r0, #0x44
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84C0:
	mov r0, #0x45
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84CC:
	mov r0, #0x46
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84D8:
	mov r0, #0x47
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84E4:
	mov r0, #0x48
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84F0:
	mov r0, #0x49
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84FC:
	mov r0, #0x4a
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8508:
	mov r0, #0x4b
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8514:
	mov r0, #0x4c
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8520:
	mov r0, #0x4d
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F852C:
	mov r0, #0x4e
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8538:
	mov r0, #0x4f
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8544:
	mov r0, #0x50
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8550:
	mov r0, #0x51
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
_021F855C:
	bl GF_AssertFail
_021F8560:
	ldr r0, [sp, #0x28]
	str r5, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [sp, #0x2c]
	add r1, r4, #0
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x10]
	add r0, r6, #0
	add r2, r7, #0
	bl ov18_021F8764
	add r0, r7, #0
	bl Heap_Free
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F8468

	thumb_func_start ov18_021F8584
ov18_021F8584: ; 0x021F8584
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r0, [sp]
	ldr r0, [sp, #0x30]
	add r7, r1, #0
	str r0, [sp, #0x30]
	mov r0, #8
	add r4, r3, #0
	str r2, [sp, #4]
	ldr r6, [sp, #0x2c]
	tst r0, r7
	beq _021F85AC
	ldr r1, [sp, #0x28]
	add r0, r2, #0
	lsl r2, r6, #1
	bl memcpy
	add sp, #0x10
	str r6, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_021F85AC:
	cmp r7, #6
	bne _021F85FA
	mov r0, #0
	str r0, [sp, #0xc]
	cmp r6, #0
	bls _021F8638
	ldr r5, [sp, #0x28]
_021F85BA:
	ldr r2, [sp]
	ldr r0, _021F863C ; =0x00001854
	ldrh r1, [r5]
	ldr r0, [r2, r0]
	add r2, r7, #0
	ldrb r0, [r0, r1]
	tst r2, r0
	beq _021F85EA
	mov r2, #1
	tst r0, r2
	bne _021F85EA
	ldr r0, [sp, #0x30]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _021F85EA
	ldr r1, [r4]
	ldrh r0, [r5]
	lsl r2, r1, #1
	ldr r1, [sp, #4]
	strh r0, [r1, r2]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_021F85EA:
	ldr r0, [sp, #0xc]
	add r5, r5, #2
	add r0, r0, #1
	str r0, [sp, #0xc]
	cmp r0, r6
	blo _021F85BA
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
_021F85FA:
	mov r0, #0
	str r0, [sp, #8]
	cmp r6, #0
	bls _021F8638
	ldr r5, [sp, #0x28]
_021F8604:
	ldr r2, [sp]
	ldr r0, _021F863C ; =0x00001854
	ldrh r1, [r5]
	ldr r0, [r2, r0]
	ldrb r0, [r0, r1]
	tst r0, r7
	beq _021F862C
	ldr r0, [sp, #0x30]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _021F862C
	ldr r1, [r4]
	ldrh r0, [r5]
	lsl r2, r1, #1
	ldr r1, [sp, #4]
	strh r0, [r1, r2]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_021F862C:
	ldr r0, [sp, #8]
	add r5, r5, #2
	add r0, r0, #1
	str r0, [sp, #8]
	cmp r0, r6
	blo _021F8604
_021F8638:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F863C: .word 0x00001854
	thumb_func_end ov18_021F8584

	thumb_func_start ov18_021F8640
ov18_021F8640: ; 0x021F8640
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r0, #0
	ldr r0, [sp, #0x28]
	str r3, [sp]
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	ldr r5, [sp, #0x20]
	str r0, [sp, #0x2c]
	cmp r1, #0
	bne _021F866E
	cmp r2, #0x98
	bne _021F866E
	ldr r2, [sp, #0x28]
	ldr r1, [sp, #0x24]
	add r0, r3, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0xc
	str r0, [r5]
	pop {r4, r5, r6, r7, pc}
_021F866E:
	ldr r0, [sp, #0x28]
	mov r7, #0
	cmp r0, #0
	bls _021F86C4
	lsl r0, r1, #2
	str r0, [sp, #8]
	lsl r0, r2, #2
	ldr r4, [sp, #0x24]
	str r0, [sp, #4]
_021F8680:
	ldr r0, _021F86C8 ; =0x00001848
	ldrh r2, [r4]
	ldr r1, [r6, r0]
	ldr r3, [sp, #8]
	lsl r0, r2, #2
	ldr r1, [r1, r0]
	ldr r0, _021F86CC ; =0x00001850
	ldr r0, [r6, r0]
	ldrh r3, [r3, r0]
	cmp r1, r3
	blt _021F86BA
	ldr r3, [sp, #4]
	ldrh r0, [r3, r0]
	cmp r1, r0
	bgt _021F86BA
	ldr r0, [sp, #0x2c]
	add r1, r2, #0
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F86BA
	ldr r1, [r5]
	ldrh r0, [r4]
	lsl r2, r1, #1
	ldr r1, [sp]
	strh r0, [r1, r2]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_021F86BA:
	ldr r0, [sp, #0x28]
	add r7, r7, #1
	add r4, r4, #2
	cmp r7, r0
	blo _021F8680
_021F86C4:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F86C8: .word 0x00001848
_021F86CC: .word 0x00001850
	thumb_func_end ov18_021F8640

	thumb_func_start ov18_021F86D0
ov18_021F86D0: ; 0x021F86D0
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r0, #0
	ldr r0, [sp, #0x28]
	str r3, [sp]
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	ldr r5, [sp, #0x20]
	str r0, [sp, #0x2c]
	cmp r1, #0
	bne _021F86FE
	cmp r2, #0x98
	bne _021F86FE
	ldr r2, [sp, #0x28]
	ldr r1, [sp, #0x24]
	add r0, r3, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0xc
	str r0, [r5]
	pop {r4, r5, r6, r7, pc}
_021F86FE:
	ldr r0, [sp, #0x28]
	mov r7, #0
	cmp r0, #0
	bls _021F8758
	lsl r0, r1, #2
	str r0, [sp, #8]
	lsl r0, r2, #2
	ldr r4, [sp, #0x24]
	str r0, [sp, #4]
_021F8710:
	ldr r0, _021F875C ; =0x0000184C
	ldrh r2, [r4]
	ldr r1, [r6, r0]
	ldr r3, [sp, #8]
	lsl r0, r2, #2
	ldr r1, [r1, r0]
	ldr r0, _021F8760 ; =0x00001850
	ldr r0, [r6, r0]
	add r3, r3, r0
	ldrh r3, [r3, #2]
	cmp r1, r3
	blt _021F874E
	ldr r3, [sp, #4]
	add r0, r3, r0
	ldrh r0, [r0, #2]
	cmp r1, r0
	bgt _021F874E
	ldr r0, [sp, #0x2c]
	add r1, r2, #0
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F874E
	ldr r1, [r5]
	ldrh r0, [r4]
	lsl r2, r1, #1
	ldr r1, [sp]
	strh r0, [r1, r2]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_021F874E:
	ldr r0, [sp, #0x28]
	add r7, r7, #1
	add r4, r4, #2
	cmp r7, r0
	blo _021F8710
_021F8758:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F875C: .word 0x0000184C
_021F8760: .word 0x00001850
	thumb_func_end ov18_021F86D0

	thumb_func_start ov18_021F8764
ov18_021F8764: ; 0x021F8764
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	str r1, [sp, #4]
	str r0, [sp, #0x2c]
	ldr r0, [sp, #0x34]
	mov r1, #0
	str r0, [sp, #0x34]
	ldr r0, [sp, #4]
	str r2, [sp, #8]
	str r1, [r0]
	ldr r0, [sp, #0x30]
	add r5, r3, #0
	str r1, [sp, #0xc]
	cmp r0, #1
	bne _021F87D0
	ldr r0, [sp, #0x2c]
	cmp r0, #0
	bls _021F8820
	ldr r1, [sp, #0x28]
	mov r0, #0
_021F8790:
	add r4, r0, #0
	cmp r5, #0
	bls _021F87BE
	ldrh r2, [r1]
	ldr r6, [sp, #8]
_021F879A:
	ldrh r3, [r6]
	cmp r2, r3
	bne _021F87B6
	ldr r3, [sp, #4]
	ldr r3, [r3]
	lsl r4, r3, #1
	ldr r3, [sp]
	strh r2, [r3, r4]
	ldr r2, [sp, #4]
	ldr r2, [r2]
	add r3, r2, #1
	ldr r2, [sp, #4]
	str r3, [r2]
	b _021F87BE
_021F87B6:
	add r4, r4, #1
	add r6, r6, #2
	cmp r4, r5
	blo _021F879A
_021F87BE:
	ldr r2, [sp, #0xc]
	add r1, r1, #2
	add r3, r2, #1
	ldr r2, [sp, #0x2c]
	str r3, [sp, #0xc]
	cmp r3, r2
	blo _021F8790
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
_021F87D0:
	ldr r0, [sp, #0x2c]
	cmp r0, #0
	bls _021F8820
	ldr r7, [sp, #0x28]
_021F87D8:
	mov r6, #0
	cmp r5, #0
	bls _021F8812
	ldr r4, [sp, #8]
_021F87E0:
	ldrh r1, [r7]
	ldrh r0, [r4]
	cmp r1, r0
	bne _021F880A
	ldr r0, [sp, #0x34]
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F880A
	ldr r0, [sp, #4]
	ldrh r2, [r7]
	ldr r0, [r0]
	lsl r1, r0, #1
	ldr r0, [sp]
	strh r2, [r0, r1]
	ldr r0, [sp, #4]
	ldr r0, [r0]
	add r1, r0, #1
	ldr r0, [sp, #4]
	str r1, [r0]
	b _021F8812
_021F880A:
	add r6, r6, #1
	add r4, r4, #2
	cmp r6, r5
	blo _021F87E0
_021F8812:
	ldr r0, [sp, #0xc]
	add r7, r7, #2
	add r1, r0, #1
	ldr r0, [sp, #0x2c]
	str r1, [sp, #0xc]
	cmp r1, r0
	blo _021F87D8
_021F8820:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F8764

	thumb_func_start ov18_021F8824
ov18_021F8824: ; 0x021F8824
	ldr r1, _021F8834 ; =0x0000185A
	ldrb r2, [r0, r1]
	sub r1, r1, #1
	ldrb r1, [r0, r1]
	mov r0, #0xf
	mul r0, r1
	add r0, r2, r0
	bx lr
	.balign 4, 0
_021F8834: .word 0x0000185A
	thumb_func_end ov18_021F8824
