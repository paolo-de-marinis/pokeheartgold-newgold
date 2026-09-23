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

.public ov18_021EE5FC
.public ov18_021EE6BC

	.text

	.balign 4, 0

.public ov18_021EE75C
.public ov18_021EE7DC
.public ov18_021EE834
.public ov18_021EE8B8
.public ov18_021F8824
.public ov18_021F8838
.public ov18_021F95FC
.public ov18_021F9648
.public ov18_021F9F3C
.public ov18_021EE35C
.public ov18_021EE388
.public ov18_021EE3AC
.public ov18_021EE44C
.public ov18_021EE520

	thumb_func_start ov18_021EE35C
ov18_021EE35C: ; 0x021EE35C
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r5, r1, #0
	mov r6, #0
	str r2, [sp]
	add r0, r2, #0
	beq _021EE384
	add r4, r7, #0
	add r4, #0xc
_021EE36E:
	ldr r0, [r7, #4]
	add r1, r4, #0
	add r2, r5, #0
	bl AddWindow
	ldr r0, [sp]
	add r6, r6, #1
	add r5, #8
	add r4, #0x10
	cmp r6, r0
	blo _021EE36E
_021EE384:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021EE35C

	thumb_func_start ov18_021EE388
ov18_021EE388: ; 0x021EE388
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r5, #0
	mov r6, #0
	add r4, #0xc
_021EE392:
	ldr r0, [r5, #0x18]
	cmp r0, #0
	beq _021EE39E
	add r0, r4, #0
	bl RemoveWindow
_021EE39E:
	add r6, r6, #1
	add r5, #0x10
	add r4, #0x10
	cmp r6, #0x65
	blo _021EE392
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021EE388

	thumb_func_start ov18_021EE3AC
ov18_021EE3AC: ; 0x021EE3AC
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	add r1, r3, #0
	add r4, r2, #0
	bl NewString_ReadMsgData
	mov r1, #0x66
	add r6, r0, #0
	lsl r1, r1, #4
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x28]
	add r1, r5, #0
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	add r1, #0xc
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	ldr r2, [sp, #0x20]
	str r0, [sp, #8]
	lsl r0, r4, #4
	add r0, r1, r0
	ldr r1, _021EE3F8 ; =0x00000664
	ldr r3, [sp, #0x24]
	ldr r1, [r5, r1]
	bl ov18_021F95FC
	add r0, r6, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EE3F8: .word 0x00000664
	thumb_func_end ov18_021EE3AC

	thumb_func_start ov18_021EE3FC
ov18_021EE3FC: ; 0x021EE3FC
	push {r4, r5, r6, lr}
	ldr r1, _021EE448 ; =ov18_021F9F3C
	mov r2, #0x14
	add r5, r0, #0
	bl ov18_021EE35C
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	bl ov18_021EE508
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov18_021EE508
	add r0, r5, #0
	bl ov18_021EE5FC
	add r0, r5, #0
	bl ov18_021F8824
	add r4, r0, #0
	add r0, r5, #0
	bl ov18_021F8838
	add r6, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl ov18_021EE6BC
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl ov18_021EE8B8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EE448: .word ov18_021F9F3C
	thumb_func_end ov18_021EE3FC

	thumb_func_start ov18_021EE44C
ov18_021EE44C: ; 0x021EE44C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	str r0, [sp, #0x1c]
	mov r0, #0x25
	add r4, r1, #0
	str r0, [sp]
	ldr r1, _021EE4FC ; =0x00000854
	ldr r0, [sp, #0x1c]
	str r2, [sp, #0x20]
	ldr r0, [r0, r1]
	mov r1, #1
	add r2, r1, #0
	add r3, sp, #0x2c
	bl GfGfxLoader_GetCharDataFromOpenNarc
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	lsl r6, r4, #4
	ldr r7, [r0, #0x14]
	ldr r4, [sp, #0x1c]
	mov r5, #0
	str r5, [sp, #0x24]
	add r4, #0xc
	add r7, #0x20
_021EE47C:
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
	str r0, [sp, #0x14]
	mov r0, #0xff
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r4, r6
	add r1, r7, #0
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
	str r0, [sp, #0x14]
	mov r0, #0xff
	mov r2, #0
	str r0, [sp, #0x18]
	add r0, r4, r6
	add r1, r7, #0
	add r3, r2, #0
	bl BlitBitmapRect
	ldr r0, [sp, #0x24]
	add r5, #8
	add r0, r0, #1
	str r0, [sp, #0x24]
	cmp r0, #0xc
	blo _021EE47C
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EE500 ; =0x000F0800
	ldr r2, _021EE504 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	ldr r1, [sp, #0x1c]
	add r0, r4, r6
	ldr r1, [r1, r2]
	ldr r2, [sp, #0x20]
	mov r3, #0x60
	bl ov18_021F9648
	ldr r0, [sp, #0x28]
	bl Heap_Free
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EE4FC: .word 0x00000854
_021EE500: .word 0x000F0800
_021EE504: .word 0x0000065C
	thumb_func_end ov18_021EE44C

	thumb_func_start ov18_021EE508
ov18_021EE508: ; 0x021EE508
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r5, r1, #0
	bl ov18_021EE44C
	add r4, #0xc
	lsl r0, r5, #4
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021EE508
