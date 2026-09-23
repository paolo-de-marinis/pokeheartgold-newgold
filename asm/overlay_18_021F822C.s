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
.public ov18_021F8CCC
.public ov18_021F8F10
.public ov18_021F8FA0
.public ov18_021F91F0
.public ov18_021F95CC
.public ov18_021FBD60
.public ov18_021FBD7C
.public ov18_021FBD98

.public ov18_021F8970

.public ov18_021F8764

	.text

	thumb_func_start ov18_021F822C
ov18_021F822C: ; 0x021F822C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r7, r1, #0
	add r5, r2, #0
	mov r4, #0
	str r3, [sp, #0x10]
	cmp r0, #5
	bhi _021F82A6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F8248: ; jump table
	.short ov18_021F8254 - ov18_021F8248 - 2 ; case 0
	.short ov18_021F8268 - ov18_021F8248 - 2 ; case 1
	.short ov18_021F8276 - ov18_021F8248 - 2 ; case 2
	.short ov18_021F8282 - ov18_021F8248 - 2 ; case 3
	.short ov18_021F828E - ov18_021F8248 - 2 ; case 4
	.short ov18_021F829A - ov18_021F8248 - 2 ; case 5
ov18_021F8254:
	ldr r2, [sp, #0x30]
	add r0, r7, #0
	add r1, r3, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x30]
	add sp, #0x18
	str r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
ov18_021F8268:
	mov r0, #2
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	mov r4, #1
	b _021F82AA
ov18_021F8276:
	mov r0, #3
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
ov18_021F8282:
	mov r0, #4
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
ov18_021F828E:
	mov r0, #5
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
ov18_021F829A:
	mov r0, #6
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
_021F82A6:
	bl GF_AssertFail
_021F82AA:
	str r6, [sp]
	ldr r0, [sp, #0x14]
	ldr r2, [sp, #0x10]
	str r0, [sp, #4]
	ldr r0, [sp, #0x34]
	str r4, [sp, #8]
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x30]
	add r0, r7, #0
	add r1, r5, #0
	bl ov18_021F8764
	add r0, r6, #0
	bl Heap_Free
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F822C

	thumb_func_start ov18_021F82CC
ov18_021F82CC: ; 0x021F82CC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r1, #0
	add r5, r2, #0
	add r4, r3, #0
	cmp r0, #0x1a
	bne _021F82EE
	ldr r2, [sp, #0x28]
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0x14
	str r0, [r5]
	pop {r4, r5, r6, r7, pc}
_021F82EE:
	add r0, r0, #7
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	ldr r0, [sp, #0x28]
	str r4, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [sp, #0x2c]
	add r1, r5, #0
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x10]
	add r0, r6, #0
	add r2, r7, #0
	bl ov18_021F8764
	add r0, r7, #0
	bl Heap_Free
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F82CC
