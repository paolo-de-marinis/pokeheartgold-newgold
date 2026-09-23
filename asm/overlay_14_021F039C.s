#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start ov14_021F039C
ov14_021F039C: ; 0x021F039C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F3190
	add r0, r4, #0
	bl ov14_021F3F6C
	add r0, r4, #0
	bl ov14_021F08BC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F03F2
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8234
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8294
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
_021F03F2:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	add r0, r4, #0
	mov r1, #0
	add r0, #0x22
	strb r1, [r0]
	ldr r1, _021F0414 ; =ov14_021E8BA4
	add r0, r4, #0
	mov r2, #0xd
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0414: .word ov14_021E8BA4
	thumb_func_end ov14_021F039C

	thumb_func_start ov14_021F0418
ov14_021F0418: ; 0x021F0418
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F3190
	add r0, r4, #0
	bl ov14_021F3F6C
	add r0, r4, #0
	bl ov14_021F3044
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #2
	mov r2, #1
	bl ov14_021F3488
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	ldr r0, [r4, #8]
	bl Party_GetCount
	cmp r0, #6
	beq _021F0482
	add r0, r4, #0
	mov r1, #0x28
	mov r2, #1
	bl ov14_021F6928
	b _021F048C
_021F0482:
	add r0, r4, #0
	mov r1, #0x28
	mov r2, #3
	bl ov14_021F6928
_021F048C:
	add r0, r4, #0
	bl ov14_021F08BC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F04BA
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
_021F04BA:
	add r0, r4, #0
	mov r1, #2
	add r0, #0x22
	strb r1, [r0]
	ldr r1, _021F04D0 ; =ov14_021E9C88
	add r0, r4, #0
	mov r2, #0x57
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F04D0: .word ov14_021E9C88
	thumb_func_end ov14_021F0418

	thumb_func_start ov14_021F04D4
ov14_021F04D4: ; 0x021F04D4
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #1
	bl ov14_021F3190
	add r0, r4, #0
	bl ov14_021F3F6C
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	ldr r1, _021F052C ; =ov14_021EA068
	add r0, r4, #0
	mov r2, #0x58
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F052C: .word ov14_021EA068
	thumb_func_end ov14_021F04D4

	thumb_func_start ov14_021F0530
ov14_021F0530: ; 0x021F0530
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #1
	bl ov14_021F3190
	add r0, r4, #0
	bl ov14_021F3F6C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8234
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8294
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	ldr r1, _021F0590 ; =ov14_021EA0B8
	add r0, r4, #0
	mov r2, #0x4a
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0590: .word ov14_021EA0B8
	thumb_func_end ov14_021F0530

	thumb_func_start ov14_021F0594
ov14_021F0594: ; 0x021F0594
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	add r0, #0x21
	add r1, r5, #0
	strb r4, [r0]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F3190
	add r0, r5, #0
	bl ov14_021F3F6C
	add r1, r4, #0
	ldr r0, [r5, #8]
	sub r1, #0x1e
	bl Party_GetMonByIndex
	sub r4, #0x1e
	add r6, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021F05E4
	ldrb r1, [r5, #0x1f]
	ldr r0, [r5, #4]
	bl PCStorage_CountMonsInBox
	cmp r0, #0
	bne _021F05E4
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #8
	bl ov14_021F6928
	b _021F062A
_021F05E4:
	add r0, r6, #0
	mov r1, #6
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021F0606
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #6
	bl ov14_021F6928
	b _021F062A
_021F0606:
	add r0, r6, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021F0620
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #7
	bl ov14_021F6928
	b _021F062A
_021F0620:
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #0
	bl ov14_021F6928
_021F062A:
	add r0, r5, #0
	bl ov14_021F08BC
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	add r0, r5, #0
	mov r1, #1
	add r0, #0x22
	strb r1, [r0]
	ldr r1, _021F065C ; =ov14_021E8D20
	add r0, r5, #0
	mov r2, #0x27
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F065C: .word ov14_021E8D20
	thumb_func_end ov14_021F0594

	thumb_func_start ov14_021F0660
ov14_021F0660: ; 0x021F0660
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	str r1, [sp]
	add r1, r5, #0
	ldr r0, [sp]
	add r1, #0x21
	strb r0, [r1]
	mov r4, #0x1e
	mov r7, #1
	mov r6, #0
_021F0674:
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r4, r0
	ldr r0, [r5, #0x34]
	bne _021F068A
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F3190
	b _021F0692
_021F068A:
	add r1, r4, #0
	add r2, r7, #0
	bl ov14_021F3190
_021F0692:
	add r4, r4, #1
	cmp r4, #0x24
	blo _021F0674
	add r0, r5, #0
	bl ov14_021F3F6C
	add r0, r5, #0
	mov r1, #2
	mov r2, #1
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	ldr r1, [sp]
	ldr r0, [r5, #8]
	sub r1, #0x1e
	bl Party_GetMonByIndex
	ldr r1, [sp]
	add r4, r0, #0
	sub r1, #0x1e
	add r0, r5, #0
	str r1, [sp]
	bl ov14_021E6480
	cmp r0, #0
	bne _021F06EE
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #8
	bl ov14_021F6928
	b _021F074C
_021F06EE:
	add r0, r4, #0
	mov r1, #6
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021F0710
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #6
	bl ov14_021F6928
	b _021F074C
_021F0710:
	add r0, r4, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021F072A
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #7
	bl ov14_021F6928
	b _021F074C
_021F072A:
	ldrb r1, [r5, #0x1f]
	ldr r0, [r5, #4]
	bl PCStorage_CountEmptySpotsInBox
	cmp r0, #0
	bne _021F0742
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #2
	bl ov14_021F6928
	b _021F074C
_021F0742:
	add r0, r5, #0
	mov r1, #0x28
	mov r2, #0
	bl ov14_021F6928
_021F074C:
	add r0, r5, #0
	bl ov14_021F08BC
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F077A
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
_021F077A:
	add r0, r5, #0
	mov r1, #1
	add r0, #0x22
	strb r1, [r0]
	ldr r1, _021F0790 ; =ov14_021E9A24
	add r0, r5, #0
	mov r2, #0x6e
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F0790: .word ov14_021E9A24
	thumb_func_end ov14_021F0660

	thumb_func_start ov14_021F0794
ov14_021F0794: ; 0x021F0794
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #1
	bl ov14_021F3190
	add r0, r4, #0
	bl ov14_021F3F6C
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	ldr r1, _021F07EC ; =ov14_021EA068
	add r0, r4, #0
	mov r2, #0x6f
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F07EC: .word ov14_021EA068
	thumb_func_end ov14_021F0794

	thumb_func_start ov14_021F07F0
ov14_021F07F0: ; 0x021F07F0
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #1
	bl ov14_021F3190
	add r0, r4, #0
	bl ov14_021F3F6C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	ldr r1, _021F0838 ; =ov14_021EA0B8
	add r0, r4, #0
	mov r2, #0x4c
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0838: .word ov14_021EA0B8
	thumb_func_end ov14_021F07F0

	thumb_func_start ov14_021F083C
ov14_021F083C: ; 0x021F083C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F3190
	add r0, r4, #0
	bl ov14_021F3F6C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	ldr r1, [r4, #0x34]
	bne _021F0876
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85D0
	b _021F0890
_021F0876:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021F0890
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
_021F0890:
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	add r0, r4, #0
	bl ov14_021F08BC
	add r0, r4, #0
	mov r1, #2
	add r0, #0x22
	strb r1, [r0]
	ldr r1, _021F08B8 ; =ov14_021E8FD4
	add r0, r4, #0
	mov r2, #0x2a
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021F08B8: .word ov14_021E8FD4
	thumb_func_end ov14_021F083C

	thumb_func_start ov14_021F08BC
ov14_021F08BC: ; 0x021F08BC
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #0xa
	mov r1, #0xf0
	bl Heap_Alloc
	str r0, [sp]
	mov r4, #0
	add r5, r0, #0
	mov r6, #0xa
_021F08D0:
	add r0, r6, #0
	bl AllocMonZeroed
	str r0, [r5]
	add r4, r4, #1
	add r5, #0x20
	cmp r4, #7
	blo _021F08D0
	ldr r0, [sp]
	mov r1, #0
	add r0, #0xe0
	str r1, [r0]
	ldr r1, [r7, #0x34]
	ldr r0, [sp]
	str r0, [r1, #0xc]
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021F08BC

	thumb_func_start ov14_021F08F0
ov14_021F08F0: ; 0x021F08F0
	push {r4, r5, r6, lr}
	ldr r0, [r0, #0x34]
	mov r4, #0
	ldr r6, [r0, #0xc]
	add r5, r6, #0
_021F08FA:
	ldr r0, [r5]
	bl Heap_Free
	add r4, r4, #1
	add r5, #0x20
	cmp r4, #7
	blo _021F08FA
	add r0, r6, #0
	bl Heap_Free
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F08F0

	thumb_func_start ov14_021F0910
ov14_021F0910: ; 0x021F0910
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	mov r2, #0x4c
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021F0948
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	ldr r1, _021F09B8 ; =ov14_021E9450
	add r0, r5, #0
	mov r2, #0x4f
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021F0948:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	mov r3, #0
	bl ov14_021E6070
	add r4, r0, #0
	bne _021F096A
	mov r0, #0x26
	str r0, [r5, #0x2c]
	add r0, r5, #0
	mov r1, #1
	bl ov14_021F027C
	pop {r3, r4, r5, pc}
_021F096A:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	lsl r0, r4, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	ldr r1, [r5, #0x34]
	bne _021F0998
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	ldr r1, _021F09B8 ; =ov14_021E9450
	add r0, r5, #0
	mov r2, #0x50
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021F0998:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E83F4
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x25
	bl ov14_021F6704
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F0254
	pop {r3, r4, r5, pc}
	nop
_021F09B8: .word ov14_021E9450
	thumb_func_end ov14_021F0910

	thumb_func_start ov14_021F09BC
ov14_021F09BC: ; 0x021F09BC
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4]
	ldr r1, [r1, #8]
	cmp r1, #0
	beq _021F09D0
	cmp r1, #1
	beq _021F09DA
	cmp r1, #2
	b _021F09E4
_021F09D0:
	mov r1, #0
	mov r2, #9
	bl ov14_021F6AC0
	b _021F0A04
_021F09DA:
	mov r1, #2
	mov r2, #0x24
	bl ov14_021F6AC0
	b _021F0A04
_021F09E4:
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021F09FA
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x27
	bl ov14_021F6AC0
	b _021F0A04
_021F09FA:
	add r0, r4, #0
	mov r1, #5
	mov r2, #0xb
	bl ov14_021F6AC0
_021F0A04:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x26
	bl ov14_021F6654
	add r0, r4, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021F0A26
	add r0, r4, #0
	bl ov14_021F57B8
_021F0A26:
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021F0A3A
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
_021F0A3A:
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7E64
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #2
	bne _021F0A6E
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021F0A6E
	ldr r1, _021F0A7C ; =ov14_021E94A8
	add r0, r4, #0
	mov r2, #0x17
	bl ov14_021F0234
	pop {r4, pc}
_021F0A6E:
	ldr r1, _021F0A7C ; =ov14_021E94A8
	add r0, r4, #0
	mov r2, #0xe
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0A7C: .word ov14_021E94A8
	thumb_func_end ov14_021F09BC

	thumb_func_start ov14_021F0A80
ov14_021F0A80: ; 0x021F0A80
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	ldr r1, _021F0AA8 ; =ov14_021E9434
	add r0, r4, #0
	mov r2, #0x13
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0AA8: .word ov14_021E9434
	thumb_func_end ov14_021F0A80

	thumb_func_start ov14_021F0AAC
ov14_021F0AAC: ; 0x021F0AAC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	ldr r1, _021F0AD4 ; =ov14_021E9450
	add r0, r4, #0
	mov r2, #0x19
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0AD4: .word ov14_021E9450
	thumb_func_end ov14_021F0AAC

	thumb_func_start ov14_021F0AD8
ov14_021F0AD8: ; 0x021F0AD8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	add r0, #0x23
	strb r1, [r0]
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8234
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8294
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r1, _021F0B30 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x22
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0B30: .word ov14_021E94BC
	thumb_func_end ov14_021F0AD8

	thumb_func_start ov14_021F0B34
ov14_021F0B34: ; 0x021F0B34
	push {r4, lr}
	add r4, r0, #0
	mov r2, #0
	add r0, #0x23
	strb r2, [r0]
	ldr r0, [r4, #0x34]
	mov r1, #9
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F0B5E
	add r0, r4, #0
	bl ov14_021EC710
	pop {r4, pc}
_021F0B5E:
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x25
	bl ov14_021F1100
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0B34

	thumb_func_start ov14_021F0B70
ov14_021F0B70: ; 0x021F0B70
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov14_021E81A8
	ldr r0, [r4, #0x34]
	bl ov14_021F63F0
	ldr r0, [r4, #0x34]
	bl ov14_021F63A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8368
	add r0, r4, #0
	bl ov14_021E82DC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7E78
	add r0, r4, #0
	bl ov14_021F30B0
	pop {r4, pc}
	thumb_func_end ov14_021F0B70

	thumb_func_start ov14_021F0BB4
ov14_021F0BB4: ; 0x021F0BB4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov14_021E81A8
	ldr r0, [r4, #0x34]
	bl ov14_021F63F0
	ldr r0, [r4, #0x34]
	bl ov14_021F63B8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8368
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7E88
	add r0, r4, #0
	bl ov14_021F311C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0BB4

	thumb_func_start ov14_021F0BF4
ov14_021F0BF4: ; 0x021F0BF4
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F30B0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7E78
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0BF4

	thumb_func_start ov14_021F0C0C
ov14_021F0C0C: ; 0x021F0C0C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8020
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021F0C48
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
_021F0C48:
	ldr r1, _021F0C54 ; =ov14_021E952C
	add r0, r4, #0
	mov r2, #0x2d
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021F0C54: .word ov14_021E952C
	thumb_func_end ov14_021F0C0C

	thumb_func_start ov14_021F0C58
ov14_021F0C58: ; 0x021F0C58
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	mov r2, #0xff
	add r1, #0x21
	strb r2, [r1]
	mov r1, #1
	add r2, r1, #0
	bl ov14_021F3488
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E805C
	ldr r1, _021F0C84 ; =ov14_021E954C
	add r0, r4, #0
	mov r2, #0x2e
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021F0C84: .word ov14_021E954C
	thumb_func_end ov14_021F0C58

	thumb_func_start ov14_021F0C88
ov14_021F0C88: ; 0x021F0C88
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	add r0, #0x24
	strb r1, [r0]
	add r0, r4, #0
	mov r2, #0
	add r0, #0x29
	strb r2, [r0]
	ldr r0, [r4, #0x34]
	mov r1, #9
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8234
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8294
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r1, _021F0CD4 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x2f
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0CD4: .word ov14_021E94BC
	thumb_func_end ov14_021F0C88

	thumb_func_start ov14_021F0CD8
ov14_021F0CD8: ; 0x021F0CD8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	add r0, #0x24
	strb r1, [r0]
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021F0D10
	add r0, r4, #0
	mov r1, #0x31
	bl ov14_021F0EE8
	pop {r4, pc}
_021F0D10:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021F0D2A
	add r0, r4, #0
	mov r1, #0x31
	bl ov14_021F0D34
	pop {r4, pc}
_021F0D2A:
	add r0, r4, #0
	mov r1, #0x32
	bl ov14_021F1090
	pop {r4, pc}
	thumb_func_end ov14_021F0CD8

	thumb_func_start ov14_021F0D34
ov14_021F0D34: ; 0x021F0D34
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
	ldr r1, _021F0D54 ; =ov14_021E9970
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021F0D54: .word ov14_021E9970
	thumb_func_end ov14_021F0D34

	thumb_func_start ov14_021F0D58
ov14_021F0D58: ; 0x021F0D58
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r6, r1, #0
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021F0D6A
	mov r4, #0x82
	b _021F0D6C
_021F0D6A:
	mov r4, #0x29
_021F0D6C:
	add r0, r5, #0
	add r0, #0x25
	ldrb r7, [r0]
	mov r1, #6
	add r0, r7, #0
	bl _s32_div_f
	mov r1, #6
	mul r1, r0
	add r1, r6, r1
	cmp r1, r7
	beq _021F0D96
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F57B8
_021F0D96:
	add r0, r5, #0
	add r0, #0x25
	ldrb r1, [r0]
	ldrb r0, [r5, #0x1f]
	cmp r1, r0
	bne _021F0E4E
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021F0DEA
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r5, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F0EE8
	pop {r3, r4, r5, r6, r7, pc}
_021F0DEA:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021F0E40
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r5, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
	ldr r1, _021F0EE0 ; =ov14_021E9970
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
_021F0E40:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F0E4E:
	ldr r0, [r5, #0x34]
	mov r1, #0x2d
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_IsButtonInputMode
	cmp r0, #1
	bne _021F0E9E
	ldr r0, [r5, #0x34]
	mov r1, #0x2d
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
_021F0E9E:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021F0EB2
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F0EB2:
	add r0, r5, #0
	bl ov14_021F604C
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021F0ED4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
_021F0ED4:
	ldr r1, _021F0EE4 ; =ov14_021E9920
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0EE0: .word ov14_021E9970
_021F0EE4: .word ov14_021E9920
	thumb_func_end ov14_021F0D58

	thumb_func_start ov14_021F0EE8
ov14_021F0EE8: ; 0x021F0EE8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85D0
	ldr r1, _021F0F08 ; =ov14_021E9970
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021F0F08: .word ov14_021E9970
	thumb_func_end ov14_021F0EE8

	thumb_func_start ov14_021F0F0C
ov14_021F0F0C: ; 0x021F0F0C
	push {r4, r5, r6, lr}
	add r4, r0, #0
	add r2, r4, #0
	add r2, #0x25
	add r5, r1, #0
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r2]
	strb r2, [r4, #0x1f]
	add r2, r4, #0
	add r2, #0x25
	ldrb r2, [r2]
	cmp r1, r2
	ldrb r1, [r4, #0x1f]
	bls _021F0F42
	bl ov14_021F2DE8
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021E7930
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0
	bl ov14_021E783C
	ldr r6, _021F0FFC ; =ov14_021E92AC
	b _021F0F5A
_021F0F42:
	bl ov14_021F2DE8
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021E7930
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #1
	bl ov14_021E783C
	ldr r6, _021F1000 ; =ov14_021E9370
_021F0F5A:
	cmp r5, #4
	bhi _021F0FF0
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F0F6A: ; jump table
	.short _021F0F74 - _021F0F6A - 2 ; case 0
	.short _021F0F90 - _021F0F6A - 2 ; case 1
	.short _021F0F9C - _021F0F6A - 2 ; case 2
	.short _021F0FA2 - _021F0F6A - 2 ; case 3
	.short _021F0FCA - _021F0F6A - 2 ; case 4
_021F0F74:
	add r0, r4, #0
	bl ov14_021F4848
	add r0, r4, #0
	add r0, #0x23
	ldrb r0, [r0]
	cmp r0, #0
	bne _021F0F8A
	mov r0, #0xc
	str r0, [r4, #0x30]
	b _021F0FF0
_021F0F8A:
	mov r0, #0x24
	str r0, [r4, #0x30]
	b _021F0FF0
_021F0F90:
	add r0, r4, #0
	bl ov14_021F4848
	mov r0, #0x3d
	str r0, [r4, #0x30]
	b _021F0FF0
_021F0F9C:
	mov r0, #0x47
	str r0, [r4, #0x30]
	b _021F0FF0
_021F0FA2:
	add r0, r4, #0
	bl ov14_021F4848
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021F0FC4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85D0
_021F0FC4:
	mov r0, #0x29
	str r0, [r4, #0x30]
	b _021F0FF0
_021F0FCA:
	add r0, r4, #0
	bl ov14_021F4848
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021F0FEC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85D0
_021F0FEC:
	mov r0, #0x82
	str r0, [r4, #0x30]
_021F0FF0:
	ldr r2, [r4, #0x30]
	add r0, r4, #0
	add r1, r6, #0
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F0FFC: .word ov14_021E92AC
_021F1000: .word ov14_021E9370
	thumb_func_end ov14_021F0F0C
