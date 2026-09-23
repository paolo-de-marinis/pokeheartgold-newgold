	.include "asm/macros.inc"
	.include "unk_0202FBCC.inc"
	.include "global.inc"

	.text

	thumb_func_start sub_02030920
sub_02030920: ; 0x02030920
	push {r4, lr}
	mov r1, #0x64
	bl Heap_Alloc
	mov r1, #0
	mov r2, #0x64
	add r4, r0, #0
	bl MI_CpuFill8
	add r0, r4, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_02030920

	thumb_func_start sub_02030938
sub_02030938: ; 0x02030938
	ldr r3, _0203093C ; =Heap_Free
	bx r3
	.balign 4, 0
_0203093C: .word Heap_Free
	thumb_func_end sub_02030938

	thumb_func_start sub_02030940
sub_02030940: ; 0x02030940
	ldr r3, _02030948 ; =MI_CpuFill8
	mov r1, #0
	mov r2, #0x58
	bx r3
	.balign 4, 0
_02030948: .word MI_CpuFill8
	thumb_func_end sub_02030940

	thumb_func_start sub_0203094C
sub_0203094C: ; 0x0203094C
	push {r3, lr}
	bl Save_Frontier_GetStatic
	mov r1, #0x8e
	lsl r1, r1, #4
	add r0, r0, r1
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end sub_0203094C

	thumb_func_start sub_0203095C
sub_0203095C: ; 0x0203095C
	ldrb r0, [r0]
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x1f
	bx lr
	thumb_func_end sub_0203095C

	thumb_func_start sub_02030964
sub_02030964: ; 0x02030964
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	lsl r1, r1, #0x1f
	ldrb r3, [r0]
	mov r2, #0x10
	lsr r1, r1, #0x1b
	bic r3, r2
	orr r1, r3
	strb r1, [r0]
	bx lr
	thumb_func_end sub_02030964

	thumb_func_start sub_02030978
sub_02030978: ; 0x02030978
	push {r3, r4}
	cmp r1, #9
	bhi _02030A1E
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0203098A: ; jump table
	.short _0203099E - _0203098A - 2 ; case 0
	.short _020309B2 - _0203098A - 2 ; case 1
	.short _020309C6 - _0203098A - 2 ; case 2
	.short _020309CE - _0203098A - 2 ; case 3
	.short _020309DA - _0203098A - 2 ; case 4
	.short _020309E6 - _0203098A - 2 ; case 5
	.short _020309F2 - _0203098A - 2 ; case 6
	.short _020309FE - _0203098A - 2 ; case 7
	.short _02030A0A - _0203098A - 2 ; case 8
	.short _02030A16 - _0203098A - 2 ; case 9
_0203099E:
	ldrb r4, [r0]
	ldrb r2, [r3]
	mov r1, #1
	bic r4, r1
	mov r1, #1
	and r1, r2
	orr r1, r4
	strb r1, [r0]
	pop {r3, r4}
	bx lr
_020309B2:
	ldrb r2, [r0]
	mov r1, #0xe
	bic r2, r1
	ldrb r1, [r3]
	lsl r1, r1, #0x1d
	lsr r1, r1, #0x1c
	orr r1, r2
	strb r1, [r0]
	pop {r3, r4}
	bx lr
_020309C6:
	ldrb r1, [r3]
	strb r1, [r0, #1]
	pop {r3, r4}
	bx lr
_020309CE:
	ldrh r3, [r3]
	lsl r1, r2, #1
	add r0, r0, r1
	strh r3, [r0, #4]
	pop {r3, r4}
	bx lr
_020309DA:
	ldrh r3, [r3]
	lsl r1, r2, #1
	add r0, r0, r1
	strh r3, [r0, #0x20]
	pop {r3, r4}
	bx lr
_020309E6:
	ldrb r1, [r3]
	add r0, r0, r2
	add r0, #0x28
	strb r1, [r0]
	pop {r3, r4}
	bx lr
_020309F2:
	lsl r1, r2, #2
	ldr r3, [r3]
	add r0, r0, r1
	str r3, [r0, #0x2c]
	pop {r3, r4}
	bx lr
_020309FE:
	ldrh r3, [r3]
	lsl r1, r2, #1
	add r0, r0, r1
	strh r3, [r0, #0x3c]
	pop {r3, r4}
	bx lr
_02030A0A:
	ldrb r1, [r3]
	add r0, r0, r2
	add r0, #0x44
	strb r1, [r0]
	pop {r3, r4}
	bx lr
_02030A16:
	lsl r1, r2, #2
	ldr r3, [r3]
	add r0, r0, r1
	str r3, [r0, #0x48]
_02030A1E:
	pop {r3, r4}
	bx lr
	.balign 4, 0
	thumb_func_end sub_02030978

	thumb_func_start sub_02030A24
sub_02030A24: ; 0x02030A24
	cmp r1, #9
	bhi _02030A94
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02030A34: ; jump table
	.short _02030A50 - _02030A34 - 2 ; case 0
	.short _02030A48 - _02030A34 - 2 ; case 1
	.short _02030A58 - _02030A34 - 2 ; case 2
	.short _02030A5C - _02030A34 - 2 ; case 3
	.short _02030A64 - _02030A34 - 2 ; case 4
	.short _02030A6C - _02030A34 - 2 ; case 5
	.short _02030A74 - _02030A34 - 2 ; case 6
	.short _02030A7C - _02030A34 - 2 ; case 7
	.short _02030A84 - _02030A34 - 2 ; case 8
	.short _02030A8C - _02030A34 - 2 ; case 9
_02030A48:
	ldrb r0, [r0]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1d
	bx lr
_02030A50:
	ldrb r0, [r0]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	bx lr
_02030A58:
	ldrb r0, [r0, #1]
	bx lr
_02030A5C:
	lsl r1, r2, #1
	add r0, r0, r1
	ldrh r0, [r0, #4]
	bx lr
_02030A64:
	lsl r1, r2, #1
	add r0, r0, r1
	ldrh r0, [r0, #0x20]
	bx lr
_02030A6C:
	add r0, r0, r2
	add r0, #0x28
	ldrb r0, [r0]
	bx lr
_02030A74:
	lsl r1, r2, #2
	add r0, r0, r1
	ldr r0, [r0, #0x2c]
	bx lr
_02030A7C:
	lsl r1, r2, #1
	add r0, r0, r1
	ldrh r0, [r0, #0x3c]
	bx lr
_02030A84:
	add r0, r0, r2
	add r0, #0x44
	ldrb r0, [r0]
	bx lr
_02030A8C:
	lsl r1, r2, #2
	add r0, r0, r1
	ldr r0, [r0, #0x48]
	bx lr
_02030A94:
	mov r0, #0
	bx lr
	thumb_func_end sub_02030A24
