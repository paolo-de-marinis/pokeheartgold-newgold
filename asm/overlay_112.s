#include "config.h"
	.include "asm/macros.inc"
	.include "overlay_112.inc"
	.include "global.inc"
	.public gApplication_TitleScreen

	.text

	thumb_func_start ov112_021E5900
ov112_021E5900: ; 0x021E5900
	push {r3, r4, r5, r6}
	mov r5, #2
	mov r6, #0
	cmp r1, #0
	bls _021E5924
	mov r2, #1
_021E590C:
	add r3, r6, #0
	ldrb r4, [r0]
	add r0, r0, #1
	tst r3, r2
	beq _021E591A
	add r5, r5, r4
	b _021E591E
_021E591A:
	lsl r3, r4, #8
	add r5, r5, r3
_021E591E:
	add r6, r6, #1
	cmp r6, r1
	blo _021E590C
_021E5924:
	lsl r0, r5, #0x10
	lsr r1, r5, #0x10
	lsr r0, r0, #0x10
	add r1, r1, r0
	lsr r0, r1, #0x10
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	pop {r3, r4, r5, r6}
	bx lr
	thumb_func_end ov112_021E5900

	thumb_func_start ov112_021E5938
ov112_021E5938: ; 0x021E5938
	ldr r0, _021E5948 ; =_021FF9E0
	mov r1, #1
	str r1, [r0, #0x18]
	ldr r1, [r0, #0x10]
	add r1, r1, #1
	str r1, [r0, #0x10]
	bx lr
	nop
_021E5948: .word _021FF9E0
	thumb_func_end ov112_021E5938

	thumb_func_start ov112_021E594C
ov112_021E594C: ; 0x021E594C
	ldr r0, _021E5960 ; =_021FF9E0
	mov r1, #0
	strb r1, [r0]
	str r1, [r0, #0x28]
	str r1, [r0, #0x2c]
	str r1, [r0, #0x18]
	str r1, [r0, #0x24]
	str r1, [r0, #8]
	str r1, [r0, #0x10]
	bx lr
	.balign 4, 0
_021E5960: .word _021FF9E0
	thumb_func_end ov112_021E594C

	thumb_func_start ov112_021E5964
ov112_021E5964: ; 0x021E5964
	push {r3, lr}
	bl CARD_SpiWaitInit
	mov r0, #0x32
	bl CARD_SetSpiWriteWaitCycles
	mov r0, #0x32
	bl CARD_SetSpiReadWaitCycles
	ldr r0, _021E599C ; =ov112_021FFA18
	bl CARD_SpiWaitReadRange
	bl ov112_021E594C
	ldr r0, _021E59A0 ; =_021FF500
	mov r1, #0xff
	strb r1, [r0]
	strb r1, [r0, #1]
	bl OS_GetTick
	ldr r1, _021E59A4 ; =_021FF9E0
	str r0, [r1, #0x20]
	str r0, [r1, #4]
	mov r0, #0
	str r0, [r1, #0xc]
	str r0, [r1, #0x1c]
	pop {r3, pc}
	nop
_021E599C: .word ov112_021FFA18
_021E59A0: .word _021FF500
_021E59A4: .word _021FF9E0
	thumb_func_end ov112_021E5964

	thumb_func_start ov112_021E59A8
ov112_021E59A8: ; 0x021E59A8
	ldr r0, _021E59B0 ; =_021FF9E0
	ldr r0, [r0, #0x2c]
	bx lr
	nop
_021E59B0: .word _021FF9E0
	thumb_func_end ov112_021E59A8

	thumb_func_start ov112_021E59B4
ov112_021E59B4: ; 0x021E59B4
	push {r3, r4, r5, lr}
	ldr r4, _021E5A0C ; =ov112_021FFA18
	add r5, r1, #0
	strb r2, [r4]
	strb r3, [r4, #1]
	ldr r1, [sp, #0x10]
	ldr r3, _021E5A10 ; =ov112_021FFA20
	str r1, [r4, #4]
	mov r1, #0
	strb r1, [r4, #2]
	strb r1, [r4, #3]
	b _021E59D6
_021E59CC:
	ldrb r2, [r0]
	add r0, r0, #1
	add r1, r1, #1
	strb r2, [r3]
	add r3, r3, #1
_021E59D6:
	cmp r1, r5
	blt _021E59CC
	add r5, #8
	lsl r0, r5, #0x18
	lsr r5, r0, #0x18
	ldr r0, _021E5A0C ; =ov112_021FFA18
	add r1, r5, #0
	bl ov112_021E5900
	strb r0, [r4, #2]
	asr r0, r0, #8
	strb r0, [r4, #3]
	mov r1, #0
	ldr r3, _021E5A0C ; =ov112_021FFA18
	mov r0, #0xaa
	b _021E59FE
_021E59F6:
	ldrb r2, [r3, r1]
	eor r2, r0
	strb r2, [r3, r1]
	add r1, r1, #1
_021E59FE:
	cmp r1, r5
	blt _021E59F6
	ldr r0, _021E5A0C ; =ov112_021FFA18
	add r1, r5, #0
	bl CARD_SpiWaitWriteRange
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E5A0C: .word ov112_021FFA18
_021E5A10: .word ov112_021FFA20
	thumb_func_end ov112_021E59B4

	thumb_func_start ov112_021E5A14
ov112_021E5A14: ; 0x021E5A14
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _021E5A54 ; =_021FF9E0
	ldr r1, [r0, #0x2c]
	cmp r1, #0
	beq _021E5A3E
	ldr r1, [r0, #8]
	cmp r1, #0
	bne _021E5A3E
	cmp r4, #0
	bne _021E5A3E
	ldr r0, [r0, #4]
	ldr r3, _021E5A58 ; =_021FF500
	str r0, [sp]
	ldrb r3, [r3]
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xf4
	bl ov112_021E59B4
_021E5A3E:
	ldr r0, _021E5A54 ; =_021FF9E0
	ldr r1, [r0, #0x14]
	cmp r1, #0
	beq _021E5A4A
	add r0, r4, #0
	blx r1
_021E5A4A:
	bl ov112_021E594C
	add sp, #4
	pop {r3, r4, pc}
	nop
_021E5A54: .word _021FF9E0
_021E5A58: .word _021FF500
	thumb_func_end ov112_021E5A14

	thumb_func_start ov112_021E5A5C
ov112_021E5A5C: ; 0x021E5A5C
	ldr r3, _021E5A64 ; =ov112_021E5A14
	mov r0, #0
	bx r3
	nop
_021E5A64: .word ov112_021E5A14
	thumb_func_end ov112_021E5A5C

	thumb_func_start ov112_021E5A68
ov112_021E5A68: ; 0x021E5A68
	push {r3, r4, r5, lr}
	ldr r4, _021E5A7C ; =_021FF9E0
	ldr r5, [r4, #0x2c]
	cmp r5, #0
	beq _021E5A7A
	ldr r4, [r4, #4]
	str r4, [sp]
	bl ov112_021E59B4
_021E5A7A:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E5A7C: .word _021FF9E0
	thumb_func_end ov112_021E5A68

	thumb_func_start ov112_021E5A80
ov112_021E5A80: ; 0x021E5A80
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021E5A80

	thumb_func_start ov112_021E5A84
ov112_021E5A84: ; 0x021E5A84
	cmp r0, #1
	bne _021E5AA4
	ldr r0, _021E5AC8 ; =_021FF9E0
	ldr r0, [r0, #0x2c]
	cmp r0, #0
	beq _021E5A94
	mov r0, #1
	bx lr
_021E5A94:
	ldr r0, _021E5ACC ; =ov112_021FFA18
	ldrb r0, [r0]
	cmp r0, #0xfc
	beq _021E5AA0
	mov r0, #1
	bx lr
_021E5AA0:
	mov r0, #0
	bx lr
_021E5AA4:
	cmp r0, #2
	beq _021E5AAC
	cmp r0, #3
	bne _021E5AC4
_021E5AAC:
	mov r1, #0
	b _021E5AB2
_021E5AB0:
	add r1, r1, #1
_021E5AB2:
	cmp r1, #4
	blo _021E5AB0
	mov r1, #0
	b _021E5ABC
_021E5ABA:
	add r1, r1, #1
_021E5ABC:
	cmp r1, r0
	blo _021E5ABA
	mov r0, #1
	bx lr
_021E5AC4:
	mov r0, #0
	bx lr
	.balign 4, 0
_021E5AC8: .word _021FF9E0
_021E5ACC: .word ov112_021FFA18
	thumb_func_end ov112_021E5A84

	thumb_func_start ov112_021E5AD0
ov112_021E5AD0: ; 0x021E5AD0
	push {r3, lr}
	ldr r0, _021E5B20 ; =_021FF9E0
	ldr r1, [r0, #0x2c]
	cmp r1, #0
	bne _021E5AE4
	ldr r0, [r0, #0x24]
	cmp r0, #0
	bne _021E5AE4
	mov r0, #0
	pop {r3, pc}
_021E5AE4:
	bl OS_GetTick
	ldr r2, _021E5B20 ; =_021FF9E0
	ldr r3, [r2, #0x30]
	ldr r2, [r2, #0x34]
	sub r3, r0, r3
	sbc r1, r2
	lsr r0, r3, #0x1a
	lsl r1, r1, #6
	orr r1, r0
	lsl r0, r3, #6
	ldr r2, _021E5B24 ; =0x000082EA
	mov r3, #0
	bl _ll_udiv
	mov r3, #0
	mov r2, #0x64
	sub r0, r0, r2
	sbc r1, r3
	bhs _021E5B10
	mov r0, #0
	pop {r3, pc}
_021E5B10:
	mov r0, #1
	bl ov112_021E5A14
	ldr r0, _021E5B20 ; =_021FF9E0
	mov r1, #0
	str r1, [r0, #0x24]
	mov r0, #1
	pop {r3, pc}
	.balign 4, 0
_021E5B20: .word _021FF9E0
_021E5B24: .word 0x000082EA
	thumb_func_end ov112_021E5AD0

	thumb_func_start ov112_021E5B28
ov112_021E5B28: ; 0x021E5B28
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r6, _021E5B90 ; =ov112_021FFA18
	cmp r5, #1
	bne _021E5B40
	ldrb r0, [r6]
	cmp r0, #0xfc
	bne _021E5B3C
	mov r0, #1
	pop {r4, r5, r6, pc}
_021E5B3C:
	mov r0, #0
	pop {r4, r5, r6, pc}
_021E5B40:
	cmp r5, #4
	bhs _021E5B48
	mov r0, #0
	pop {r4, r5, r6, pc}
_021E5B48:
	ldrb r0, [r6, #3]
	ldrb r1, [r6, #2]
	lsl r0, r0, #8
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	mov r0, #0
	strb r0, [r6, #2]
	strb r0, [r6, #3]
	add r0, r6, #0
	add r1, r5, #0
	bl ov112_021E5900
	strb r4, [r6, #2]
	asr r1, r4, #8
	strb r1, [r6, #3]
	cmp r4, r0
	bne _021E5B76
	ldr r0, _021E5B94 ; =_021FF9E0
	mov r1, #0
	strb r1, [r0]
	mov r0, #1
	pop {r4, r5, r6, pc}
_021E5B76:
	ldr r0, _021E5B94 ; =_021FF9E0
	ldr r0, [r0, #0x2c]
	cmp r0, #0
	beq _021E5B8C
	mov r0, #0
	b _021E5B84
_021E5B82:
	add r0, r0, #1
_021E5B84:
	cmp r0, r5
	blo _021E5B82
	bl ov112_021E5938
_021E5B8C:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021E5B90: .word ov112_021FFA18
_021E5B94: .word _021FF9E0
	thumb_func_end ov112_021E5B28

	thumb_func_start ov112_021E5B98
ov112_021E5B98: ; 0x021E5B98
	push {r3, r4, r5, lr}
	ldr r0, _021E5D28 ; =ov112_021FFA18
	bl CARD_SpiWaitReadRange
	add r4, r0, #0
	bl ov112_021E5A84
	cmp r0, #0
	beq _021E5BAC
	mov r4, #0
_021E5BAC:
	cmp r4, #0
	bne _021E5BC0
	bl ov112_021E5AD0
	cmp r0, #0
	beq _021E5BBC
	mov r0, #1
	pop {r3, r4, r5, pc}
_021E5BBC:
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E5BC0:
	add r0, r4, #0
	bl ov112_021E5B28
	cmp r0, #0
	bne _021E5BCE
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E5BCE:
	bl OS_GetTick
	ldr r2, _021E5D2C ; =_021FF9E0
	str r0, [r2, #0x30]
	str r1, [r2, #0x34]
	ldr r1, _021E5D28 ; =ov112_021FFA18
	ldrb r0, [r1]
	cmp r0, #0xf0
	bhs _021E5BF6
	ldr r0, [r2, #0x2c]
	cmp r0, #0
	bne _021E5BEA
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E5BEA:
	ldr r3, [r1, #4]
	ldr r0, [r2, #4]
	cmp r3, r0
	beq _021E5BF6
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E5BF6:
	ldrb r0, [r1]
	sub r0, #0xf6
	cmp r0, #6
	bls _021E5C00
	b _021E5D04
_021E5C00:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E5C0C: ; jump table
	.short _021E5CFE - _021E5C0C - 2 ; case 0
	.short _021E5D04 - _021E5C0C - 2 ; case 1
	.short _021E5CD0 - _021E5C0C - 2 ; case 2
	.short _021E5D04 - _021E5C0C - 2 ; case 3
	.short _021E5C92 - _021E5C0C - 2 ; case 4
	.short _021E5D04 - _021E5C0C - 2 ; case 5
	.short _021E5C1A - _021E5C0C - 2 ; case 6
_021E5C1A:
	ldr r1, _021E5D2C ; =_021FF9E0
	ldr r0, [r1, #0x28]
	cmp r0, #4
	bhi _021E5C4E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E5C2E: ; jump table
	.short _021E5C4E - _021E5C2E - 2 ; case 0
	.short _021E5C38 - _021E5C2E - 2 ; case 1
	.short _021E5C4E - _021E5C2E - 2 ; case 2
	.short _021E5C4E - _021E5C2E - 2 ; case 3
	.short _021E5C4E - _021E5C2E - 2 ; case 4
_021E5C38:
	mov r0, #2
	str r0, [r1, #0x28]
	ldr r0, [r1, #0x20]
	ldr r3, _021E5D30 ; =_021FF500
	str r0, [sp]
	mov r0, #0
	ldrb r3, [r3]
	add r1, r0, #0
	mov r2, #0xfa
	bl ov112_021E59B4
_021E5C4E:
	ldr r0, _021E5D2C ; =_021FF9E0
	ldr r1, [r0, #0x24]
	cmp r1, #0
	bne _021E5D24
	mov r1, #1
	str r1, [r0, #0x24]
	mov r1, #2
	str r1, [r0, #0x28]
	mov r1, #0
	str r1, [r0, #8]
	cmp r4, #1
	bls _021E5C6C
	ldr r0, [r0, #0x2c]
	cmp r0, #0
	beq _021E5D24
_021E5C6C:
	ldr r0, _021E5D2C ; =_021FF9E0
	ldr r3, _021E5D30 ; =_021FF500
	ldr r0, [r0, #0x20]
	mov r2, #0xfa
	str r0, [sp]
	ldrb r3, [r3]
	mov r0, #0
	add r1, r0, #0
	bl ov112_021E59B4
	ldr r0, _021E5D2C ; =_021FF9E0
	ldr r0, [r0, #0x2c]
	cmp r0, #0
	beq _021E5C8C
	bl ov112_021E5938
_021E5C8C:
	bl ov112_021E5A80
	b _021E5D24
_021E5C92:
	ldr r0, _021E5D2C ; =_021FF9E0
	ldr r2, [r0, #0x28]
	cmp r2, #1
	bne _021E5D24
	mov r2, #3
	str r2, [r0, #0x28]
	mov r2, #1
	str r2, [r0, #8]
	ldrb r2, [r1, #1]
	ldr r3, _021E5D30 ; =_021FF500
	strb r2, [r3, #1]
	cmp r2, #1
	bne _021E5D24
	ldr r2, [r1, #4]
	ldr r1, [r0, #0x20]
	eor r2, r1
	str r2, [r0, #4]
	str r1, [sp]
	mov r0, #0
	ldrb r3, [r3]
	add r1, r0, #0
	mov r2, #0xf8
	bl ov112_021E59B4
	ldr r0, _021E5D2C ; =_021FF9E0
	mov r1, #1
	str r1, [r0, #0x2c]
	mov r1, #0
	str r1, [r0, #0x18]
	str r1, [r0, #0x24]
	b _021E5D24
_021E5CD0:
	ldr r3, _021E5D2C ; =_021FF9E0
	ldr r0, [r3, #0x28]
	cmp r0, #2
	bne _021E5D24
	mov r0, #4
	str r0, [r3, #0x28]
	ldrb r0, [r1, #1]
	ldr r2, _021E5D30 ; =_021FF500
	strb r0, [r2, #1]
	ldr r2, [r1, #4]
	ldr r1, [r3, #0x20]
	eor r1, r2
	str r1, [r3, #4]
	mov r1, #1
	str r1, [r3, #0x2c]
	mov r1, #0
	str r1, [r3, #0x18]
	str r1, [r3, #0x24]
	ldr r2, [r3, #0xc]
	cmp r2, #0
	beq _021E5D24
	blx r2
	b _021E5D24
_021E5CFE:
	bl ov112_021E5938
	b _021E5D24
_021E5D04:
	ldr r5, _021E5D2C ; =_021FF9E0
	ldr r0, [r5, #0x18]
	cmp r0, #1
	beq _021E5D24
	ldr r0, [r5, #0x2c]
	cmp r0, #0
	beq _021E5D24
	ldr r3, _021E5D28 ; =ov112_021FFA18
	sub r4, #8
	ldrb r2, [r3]
	lsl r1, r4, #0x18
	ldrb r3, [r3, #1]
	ldr r0, _021E5D34 ; =ov112_021FFA20
	ldr r4, [r5, #0x1c]
	lsr r1, r1, #0x18
	blx r4
_021E5D24:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E5D28: .word ov112_021FFA18
_021E5D2C: .word _021FF9E0
_021E5D30: .word _021FF500
_021E5D34: .word ov112_021FFA20
	thumb_func_end ov112_021E5B98

	thumb_func_start ov112_021E5D38
ov112_021E5D38: ; 0x021E5D38
	ldr r1, _021E5D40 ; =_021FF9E0
	str r0, [r1, #0xc]
	bx lr
	nop
_021E5D40: .word _021FF9E0
	thumb_func_end ov112_021E5D38

	thumb_func_start ov112_021E5D44
ov112_021E5D44: ; 0x021E5D44
	ldr r1, _021E5D4C ; =_021FF9E0
	str r0, [r1, #0x1c]
	bx lr
	nop
_021E5D4C: .word _021FF9E0
	thumb_func_end ov112_021E5D44

	thumb_func_start ov112_021E5D50
ov112_021E5D50: ; 0x021E5D50
	ldr r1, _021E5D58 ; =_021FF9E0
	str r0, [r1, #0x14]
	bx lr
	nop
_021E5D58: .word _021FF9E0
	thumb_func_end ov112_021E5D50

	thumb_func_start ov112_021E5D5C
ov112_021E5D5C: ; 0x021E5D5C
	ldr r1, _021E5D64 ; =_021FF500
	strb r0, [r1]
	bx lr
	nop
_021E5D64: .word _021FF500
	thumb_func_end ov112_021E5D5C

	thumb_func_start ov112_021E5D68
ov112_021E5D68: ; 0x021E5D68
	push {r4, lr}
	add r4, r0, #0
	mov r0, #3
	tst r0, r4
	beq _021E5D76
	bl OS_Halt
_021E5D76:
	ldr r1, _021E5D84 ; =ov112_021FFAA4
	ldr r0, _021E5D88 ; =0x0000CD80
	str r4, [r1, #0x48]
	add r0, r4, r0
	str r0, [r1, #0x44]
	pop {r4, pc}
	nop
_021E5D84: .word ov112_021FFAA4
_021E5D88: .word 0x0000CD80
	thumb_func_end ov112_021E5D68

	thumb_func_start ov112_021E5D8C
ov112_021E5D8C: ; 0x021E5D8C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	str r2, [sp]
	add r7, r1, #0
	ldr r1, [sp]
	add r6, r0, #0
	mov r0, #0
	add r1, #0x7f
	str r0, [sp, #8]
	asr r0, r1, #6
	lsr r0, r0, #0x19
	add r0, r1, r0
	lsl r0, r0, #9
	lsr r0, r0, #0x10
	add r5, r3, #0
	str r0, [sp, #4]
	cmp r0, #0
	ble _021E5E12
_021E5DB0:
	ldr r4, [sp]
	add r0, r4, #0
	cmp r0, #0x80
	bls _021E5DBA
	mov r4, #0x80
_021E5DBA:
	cmp r4, #0x80
	beq _021E5DD0
	add r0, r6, #0
	add r1, r7, #0
	add r2, r4, #0
	bl MI_CpuCopy8
	mov r0, #0x80
	strb r0, [r5]
	add r5, r5, #1
	b _021E5DF8
_021E5DD0:
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	mov r3, #0
	bl MI_CompressLZImpl
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bne _021E5DF4
	add r0, r6, #0
	add r1, r7, #0
	add r2, r4, #0
	bl MI_CpuCopy8
	mov r0, #0x80
	strb r0, [r5]
	add r5, r5, #1
	b _021E5DF8
_021E5DF4:
	strb r0, [r5]
	add r5, r5, #1
_021E5DF8:
	ldr r0, [sp]
	add r6, #0x80
	sub r0, r0, r4
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [sp, #8]
	add r7, #0x80
	add r1, r0, #1
	ldr r0, [sp, #4]
	str r1, [sp, #8]
	cmp r1, r0
	blt _021E5DB0
_021E5E12:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021E5D8C

	thumb_func_start ov112_021E5E18
ov112_021E5E18: ; 0x021E5E18
	ldr r1, _021E5E24 ; =ov112_021FFAA4
	ldr r2, [r1, #0x14]
	cmp r2, #0
	bne _021E5E22
	str r0, [r1, #0x14]
_021E5E22:
	bx lr
	.balign 4, 0
_021E5E24: .word ov112_021FFAA4
	thumb_func_end ov112_021E5E18

	thumb_func_start ov112_021E5E28
ov112_021E5E28: ; 0x021E5E28
	push {r3, r4, r5, lr}
	ldr r0, _021E5E44 ; =ov112_021FFAA4
	ldr r4, [r0, #0x20]
	add r5, r4, #0
	add r5, #0x10
	bl OS_GetOwnerRtcOffset
	str r0, [r4, #0x10]
	str r1, [r5, #4]
	add r5, #8
	add r0, r5, #0
	bl OS_GetLowEntropyData
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E5E44: .word ov112_021FFAA4
	thumb_func_end ov112_021E5E28

	thumb_func_start ov112_021E5E48
ov112_021E5E48: ; 0x021E5E48
	push {r4, r5, lr}
	sub sp, #0x1c
	add r0, sp, #0x10
	bl RTC_GetTime
	cmp r0, #0
	bne _021E5EB0
	add r0, sp, #0
	bl RTC_GetDate
	cmp r0, #0
	bne _021E5EB0
	add r0, sp, #0
	add r1, sp, #0x10
	bl RTC_ConvertDateTimeToSecond
	mov r2, #0
	mov r3, #0
	mvn r2, r2
	sub r2, r2, r0
	sbc r3, r1
	bge _021E5E7A
	mov r0, #0
	mvn r0, r0
	mov r1, #0
_021E5E7A:
	mov r3, #0
	mov r2, #0
	sub r2, r0, r2
	sbc r1, r3
	bge _021E5E86
	mov r0, #0
_021E5E86:
	mov r3, #0xff
	lsl r1, r0, #0x18
	lsl r3, r3, #0x18
	add r2, r1, #0
	lsl r4, r0, #8
	lsr r1, r3, #8
	and r1, r4
	lsr r4, r0, #0x18
	lsl r4, r4, #0x18
	lsr r5, r4, #0x18
	lsr r4, r0, #8
	lsr r0, r3, #0x10
	and r0, r4
	orr r0, r5
	and r2, r3
	orr r0, r1
	add r1, r2, #0
	orr r1, r0
	ldr r0, _021E5EB4 ; =ov112_021FFAA4
	ldr r0, [r0, #0x20]
	str r1, [r0, #0x60]
_021E5EB0:
	add sp, #0x1c
	pop {r4, r5, pc}
	.balign 4, 0
_021E5EB4: .word ov112_021FFAA4
	thumb_func_end ov112_021E5E48

	thumb_func_start ov112_021E5EB8
ov112_021E5EB8: ; 0x021E5EB8
	ldr r2, _021E5EC0 ; =ov112_021FFAA4
	str r0, [r2, #0x20]
	str r1, [r2, #0x24]
	bx lr
	.balign 4, 0
_021E5EC0: .word ov112_021FFAA4
	thumb_func_end ov112_021E5EB8

	thumb_func_start ov112_021E5EC4
ov112_021E5EC4: ; 0x021E5EC4
	ldr r3, _021E5EE8 ; =ov112_021FFB24
	str r0, [r3, #0x20]
	str r0, [r3, #0x24]
	str r1, [r3, #0x28]
	str r1, [r3, #0x2c]
	strh r2, [r3, #0x30]
	ldrh r0, [r3, #0x30]
	add r2, #0x7f
	strh r0, [r3, #0x32]
	mov r0, #0
	strh r0, [r3, #0x36]
	asr r0, r2, #6
	lsr r0, r0, #0x19
	add r0, r2, r0
	asr r0, r0, #7
	strh r0, [r3, #0x34]
	bx lr
	nop
_021E5EE8: .word ov112_021FFB24
	thumb_func_end ov112_021E5EC4

	thumb_func_start ov112_021E5EEC
ov112_021E5EEC: ; 0x021E5EEC
	push {r4, r5, r6, lr}
	sub sp, #0x80
	ldr r1, _021E5FF4 ; =ov112_021FFB24
	ldr r0, [r1, #0x28]
	ldrh r5, [r1, #0x30]
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r5, #0x80
	bls _021E5F00
	mov r5, #0x80
_021E5F00:
	ldr r1, _021E5FF4 ; =ov112_021FFB24
	mov r0, #0
	ldrb r1, [r1, #0x1d]
	cmp r1, #0x3a
	beq _021E5F10
	cmp r1, #0x3c
	beq _021E5F1C
	b _021E5F26
_021E5F10:
	ldr r1, _021E5FF8 ; =ov112_021FFAA4
	ldr r1, [r1, #0x50]
	cmp r1, #0
	beq _021E5F26
	ldr r0, _021E5FFC ; =ov112_021FFAF0
	b _021E5F26
_021E5F1C:
	ldr r1, _021E5FF8 ; =ov112_021FFAA4
	ldr r1, [r1, #0x58]
	cmp r1, #0
	beq _021E5F26
	ldr r0, _021E6000 ; =ov112_021FFAF8
_021E5F26:
	cmp r0, #0
	bne _021E5F84
	mov r0, #0x7f
	add r1, r4, #0
	and r1, r0
	beq _021E5F62
	mov r0, #0x80
	sub r0, r0, r1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	add r0, sp, #0
	strb r4, [r0]
	ldr r0, _021E5FF4 ; =ov112_021FFB24
	add r1, sp, #0
	ldr r0, [r0, #0x20]
	add r1, #1
	add r2, r5, #0
	bl MI_CpuCopy8
	add r1, r5, #1
	asr r3, r4, #8
	lsl r1, r1, #0x18
	lsl r3, r3, #0x18
	add r0, sp, #0
	lsr r1, r1, #0x18
	mov r2, #0xa
	lsr r3, r3, #0x18
	bl ov112_021E5A68
	b _021E5FCE
_021E5F62:
	mov r2, #0x80
	add r3, r4, #0
	ldr r0, _021E5FF4 ; =ov112_021FFB24
	and r3, r2
	mov r2, #2
	orr r2, r3
	asr r3, r4, #8
	lsl r1, r5, #0x18
	lsl r2, r2, #0x18
	lsl r3, r3, #0x18
	ldr r0, [r0, #0x20]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl ov112_021E5A68
	b _021E5FCE
_021E5F84:
	ldr r1, [r0]
	ldr r0, _021E5FF4 ; =ov112_021FFB24
	ldrh r0, [r0, #0x36]
	ldrb r6, [r1, r0]
	cmp r6, #0x80
	bls _021E5F94
	bl OS_Halt
_021E5F94:
	cmp r6, #0x80
	bne _021E5FB6
	mov r1, #0x80
	add r3, r4, #0
	ldr r0, _021E5FF4 ; =ov112_021FFB24
	and r3, r1
	mov r2, #2
	orr r2, r3
	asr r3, r4, #8
	lsl r2, r2, #0x18
	lsl r3, r3, #0x18
	ldr r0, [r0, #0x20]
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl ov112_021E5A68
	b _021E5FCE
_021E5FB6:
	ldr r0, _021E5FF4 ; =ov112_021FFB24
	mov r2, #0x80
	and r2, r4
	asr r3, r4, #8
	lsl r2, r2, #0x18
	lsl r3, r3, #0x18
	ldr r0, [r0, #0x20]
	add r1, r6, #0
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl ov112_021E5A68
_021E5FCE:
	ldr r0, _021E5FF4 ; =ov112_021FFB24
	ldr r1, [r0, #0x20]
	add r1, r1, r5
	str r1, [r0, #0x20]
	ldr r1, [r0, #0x28]
	add r1, r1, r5
	str r1, [r0, #0x28]
	ldrh r1, [r0, #0x30]
	sub r1, r1, r5
	strh r1, [r0, #0x30]
	ldrh r1, [r0, #0x36]
	add r1, r1, #1
	strh r1, [r0, #0x36]
	ldrh r1, [r0, #0x3a]
	add r1, r1, #1
	strh r1, [r0, #0x3a]
	add sp, #0x80
	pop {r4, r5, r6, pc}
	nop
_021E5FF4: .word ov112_021FFB24
_021E5FF8: .word ov112_021FFAA4
_021E5FFC: .word ov112_021FFAF0
_021E6000: .word ov112_021FFAF8
	thumb_func_end ov112_021E5EEC

	thumb_func_start ov112_021E6004
ov112_021E6004: ; 0x021E6004
	push {r3, lr}
	bl OS_GetTick
	ldr r2, _021E6114 ; =ov112_021FFAA4
	ldr r3, [r2, #0x3c]
	ldr r2, [r2, #0x40]
	sub r3, r0, r3
	sbc r1, r2
	lsr r0, r3, #0x1a
	lsl r1, r1, #6
	orr r1, r0
	lsl r0, r3, #6
	ldr r2, _021E6118 ; =0x000082EA
	mov r3, #0
	bl _ll_udiv
	bl _f_ulltof
	ldr r1, _021E611C ; =0x447A0000
	bl _fdiv
	ldr r0, _021E6120 ; =ov112_021FFB24
	ldrb r1, [r0, #0x1d]
	cmp r1, #0xb0
	bgt _021E604C
	bge _021E60F8
	cmp r1, #0x3e
	bgt _021E6106
	cmp r1, #0x3a
	blt _021E6106
	beq _021E607C
	cmp r1, #0x3c
	beq _021E60A6
	cmp r1, #0x3e
	beq _021E60CE
	b _021E6106
_021E604C:
	cmp r1, #0xb2
	bgt _021E6054
	beq _021E60F8
	b _021E6106
_021E6054:
	sub r1, #0xb4
	cmp r1, #0xa
	bhi _021E6106
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E6066: ; jump table
	.short _021E60F8 - _021E6066 - 2 ; case 0
	.short _021E6106 - _021E6066 - 2 ; case 1
	.short _021E60F8 - _021E6066 - 2 ; case 2
	.short _021E6106 - _021E6066 - 2 ; case 3
	.short _021E60F8 - _021E6066 - 2 ; case 4
	.short _021E6106 - _021E6066 - 2 ; case 5
	.short _021E60F8 - _021E6066 - 2 ; case 6
	.short _021E6106 - _021E6066 - 2 ; case 7
	.short _021E60F8 - _021E6066 - 2 ; case 8
	.short _021E6106 - _021E6066 - 2 ; case 9
	.short _021E60F8 - _021E6066 - 2 ; case 10
_021E607C:
	ldr r0, _021E6120 ; =ov112_021FFB24
	mov r1, #0x3c
	strb r1, [r0, #0x1d]
	ldr r1, _021E6114 ; =ov112_021FFAA4
	ldr r2, _021E6124 ; =0x000028BE
	ldr r0, [r1, #0x58]
	cmp r0, #0
	beq _021E6096
	mov r1, #0xd7
	lsl r1, r1, #8
	bl ov112_021E5EC4
	b _021E60A0
_021E6096:
	ldr r0, [r1, #0x2c]
	mov r1, #0xd7
	lsl r1, r1, #8
	bl ov112_021E5EC4
_021E60A0:
	bl ov112_021E5EEC
	pop {r3, pc}
_021E60A6:
	mov r1, #0x3e
	strb r1, [r0, #0x1d]
	ldr r1, _021E6114 ; =ov112_021FFAA4
	mov r2, #0x28
	ldr r0, [r1, #0x24]
	ldr r1, [r1, #0x30]
	add r0, #0x10
	add r1, #8
	bl MI_CpuCopy8
	ldr r0, _021E6114 ; =ov112_021FFAA4
	mov r2, #0x89
	ldr r0, [r0, #0x30]
	ldr r1, _021E6128 ; =0x0000D480
	lsl r2, r2, #2
	bl ov112_021E5EC4
	bl ov112_021E5EEC
	pop {r3, pc}
_021E60CE:
	ldrb r1, [r0, #0x1c]
	cmp r1, #0x52
	bne _021E60EA
	mov r1, #0x48
	strb r1, [r0, #0x1d]
	ldr r1, _021E6114 ; =ov112_021FFAA4
	ldr r0, _021E612C ; =0x0000CE80
	ldr r1, [r1, #0x38]
	ldr r2, _021E6130 ; =0x00000D4C
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r3, pc}
_021E60EA:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x24
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, pc}
_021E60F8:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x24
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, pc}
_021E6106:
	mov r0, #0xc
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r3, pc}
	nop
_021E6114: .word ov112_021FFAA4
_021E6118: .word 0x000082EA
_021E611C: .word 0x447A0000
_021E6120: .word ov112_021FFB24
_021E6124: .word 0x000028BE
_021E6128: .word 0x0000D480
_021E612C: .word 0x0000CE80
_021E6130: .word 0x00000D4C
	thumb_func_end ov112_021E6004

	thumb_func_start ov112_021E6134
ov112_021E6134: ; 0x021E6134
	push {r3, lr}
	ldr r0, _021E6160 ; =ov112_021FFB24
	ldrh r3, [r0, #0x30]
	cmp r3, #0x80
	bls _021E6140
	mov r3, #0x80
_021E6140:
	ldr r0, _021E6160 ; =ov112_021FFB24
	ldr r0, [r0, #0x20]
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	asr r1, r2, #8
	add r0, sp, #0
	strb r1, [r0]
	strb r2, [r0, #1]
	strb r3, [r0, #2]
	add r0, sp, #0
	mov r1, #3
	mov r2, #0xc
	mov r3, #2
	bl ov112_021E5A68
	pop {r3, pc}
	.balign 4, 0
_021E6160: .word ov112_021FFB24
	thumb_func_end ov112_021E6134

	thumb_func_start ov112_021E6164
ov112_021E6164: ; 0x021E6164
	push {r3, r4, r5, r6, r7, lr}
	bl OS_GetTick
	ldr r2, _021E64C8 ; =ov112_021FFAA4
	ldr r3, [r2, #0x3c]
	ldr r2, [r2, #0x40]
	sub r3, r0, r3
	sbc r1, r2
	lsr r0, r3, #0x1a
	lsl r1, r1, #6
	orr r1, r0
	lsl r0, r3, #6
	ldr r2, _021E64CC ; =0x000082EA
	mov r3, #0
	bl _ll_udiv
	bl _f_ulltof
	ldr r1, _021E64D0 ; =0x447A0000
	bl _fdiv
	ldr r1, _021E64D4 ; =ov112_021FFB24
	ldrb r0, [r1, #0x1d]
	sub r0, #0x46
	cmp r0, #6
	bls _021E619C
	bl _021E6A50
_021E619C:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E61A8: ; jump table
	.short _021E61B6 - _021E61A8 - 2 ; case 0
	.short _021E6A50 - _021E61A8 - 2 ; case 1
	.short _021E61CC - _021E61A8 - 2 ; case 2
	.short _021E6A50 - _021E61A8 - 2 ; case 3
	.short _021E63C2 - _021E61A8 - 2 ; case 4
	.short _021E6A50 - _021E61A8 - 2 ; case 5
	.short _021E6A44 - _021E61A8 - 2 ; case 6
_021E61B6:
	mov r0, #0x48
	strb r0, [r1, #0x1d]
	ldr r1, _021E64C8 ; =ov112_021FFAA4
	ldr r0, _021E64D8 ; =0x0000CE80
	ldr r1, [r1, #0x38]
	ldr r2, _021E64DC ; =0x00000D4C
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r3, r4, r5, r6, r7, pc}
_021E61CC:
	ldr r0, _021E64C8 ; =ov112_021FFAA4
	mov r4, #0
	ldr r0, [r0, #0x38]
	add r5, r4, #0
	ldrh r2, [r0, #0xa]
	asr r1, r2, #8
	lsl r1, r1, #0x18
	lsr r3, r1, #0x18
	mov r1, #0xff
	lsl r2, r2, #8
	lsl r1, r1, #8
	and r1, r2
	orr r1, r3
	strh r1, [r0, #0xa]
_021E61E8:
	ldr r0, _021E64C8 ; =ov112_021FFAA4
	mov r1, #0xff
	ldr r0, [r0, #0x38]
	lsl r1, r1, #0x18
	add r3, r0, r5
	ldr r0, [r3, #0x70]
	add r4, r4, #1
	lsl r2, r0, #0x18
	add r7, r2, #0
	and r7, r1
	lsl r2, r0, #8
	lsr r1, r1, #8
	and r2, r1
	lsr r1, r0, #0x18
	lsl r1, r1, #0x18
	lsr r6, r1, #0x18
	lsr r1, r0, #8
	mov r0, #0xff
	lsl r0, r0, #8
	and r0, r1
	orr r0, r6
	orr r0, r2
	orr r0, r7
	add r5, r5, #4
	str r0, [r3, #0x70]
	cmp r4, #7
	blt _021E61E8
	ldr r7, _021E64C8 ; =ov112_021FFAA4
	mov r1, #0xff
	ldr r5, [r7, #0x38]
	lsl r1, r1, #0x18
	ldr r0, [r5]
	lsl r2, r0, #0x18
	add r4, r2, #0
	lsl r3, r0, #8
	lsr r2, r1, #8
	and r3, r2
	lsr r2, r0, #0x18
	lsl r2, r2, #0x18
	lsr r6, r2, #0x18
	lsr r2, r0, #8
	lsr r0, r1, #0x10
	and r0, r2
	orr r0, r6
	and r4, r1
	orr r0, r3
	orr r0, r4
	str r0, [r5]
	ldr r0, [r7, #0x38]
	mov r6, #0
	ldr r2, [r0, #4]
	lsl r3, r2, #0x18
	add r5, r3, #0
	lsl r4, r2, #8
	lsr r3, r1, #8
	and r4, r3
	lsr r3, r2, #0x18
	and r5, r1
	lsl r3, r3, #0x18
	lsr r2, r2, #8
	lsr r1, r1, #0x10
	lsr r3, r3, #0x18
	and r1, r2
	orr r1, r3
	orr r1, r4
	orr r1, r5
	str r1, [r0, #4]
	ldr r0, [r7, #0x38]
	mov r7, #0xff
	add r0, #0x8c
	lsl r7, r7, #8
_021E6276:
	ldr r1, [r0]
	mov r2, #0xff
	lsl r3, r1, #0x18
	add r5, r3, #0
	lsl r2, r2, #0x18
	lsl r3, r1, #8
	and r5, r2
	lsr r2, r2, #8
	add r4, r3, #0
	and r4, r2
	lsr r2, r1, #0x18
	lsl r2, r2, #0x18
	lsr r3, r2, #0x18
	lsr r2, r1, #8
	mov r1, #0xff
	lsl r1, r1, #8
	and r1, r2
	orr r1, r3
	orr r1, r4
	orr r1, r5
	str r1, [r0]
	add r1, r0, #0
	add r1, #0x78
	ldrh r2, [r1]
	add r6, r6, #1
	asr r1, r2, #8
	lsl r3, r2, #8
	mov r2, #0xff
	lsl r1, r1, #0x18
	lsl r2, r2, #8
	lsr r1, r1, #0x18
	and r2, r3
	orr r2, r1
	add r1, r0, #0
	add r1, #0x78
	strh r2, [r1]
	add r1, r0, #0
	add r1, #0x7a
	ldrh r2, [r1]
	asr r1, r2, #8
	lsl r3, r2, #8
	mov r2, #0xff
	lsl r1, r1, #0x18
	lsl r2, r2, #8
	lsr r1, r1, #0x18
	and r2, r3
	orr r2, r1
	add r1, r0, #0
	add r1, #0x7a
	strh r2, [r1]
	ldr r1, [r0, #0x7c]
	mov r2, #0xff
	lsl r3, r1, #0x18
	add r5, r3, #0
	lsl r2, r2, #0x18
	lsl r3, r1, #8
	and r5, r2
	lsr r2, r2, #8
	add r4, r3, #0
	and r4, r2
	lsr r2, r1, #0x18
	lsl r2, r2, #0x18
	lsr r3, r2, #0x18
	lsr r2, r1, #8
	mov r1, #0xff
	lsl r1, r1, #8
	and r1, r2
	orr r1, r3
	orr r1, r4
	orr r1, r5
	str r1, [r0, #0x7c]
	add r1, r0, #0
	add r1, #0x80
	ldr r4, [r1]
	mov r1, #0xff
	lsl r2, r4, #0x18
	add r3, r2, #0
	lsl r1, r1, #0x18
	and r3, r1
	lsl r2, r4, #8
	lsr r1, r1, #8
	and r2, r1
	lsr r1, r4, #0x18
	lsl r1, r1, #0x18
	lsr r4, r4, #8
	lsr r1, r1, #0x18
	and r4, r7
	orr r1, r4
	orr r1, r2
	add r2, r3, #0
	orr r2, r1
	add r1, r0, #0
	add r1, #0x80
	add r0, #0x88
	str r2, [r1]
	cmp r6, #0x18
	blt _021E6276
	ldr r1, _021E64D4 ; =ov112_021FFB24
	ldrb r0, [r1, #0x1c]
	cmp r0, #0x60
	bgt _021E6344
	beq _021E638C
	b _021E63A8
_021E6344:
	sub r0, #0xb0
	cmp r0, #0xe
	bhi _021E63A8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E6356: ; jump table
	.short _021E6374 - _021E6356 - 2 ; case 0
	.short _021E63A8 - _021E6356 - 2 ; case 1
	.short _021E6374 - _021E6356 - 2 ; case 2
	.short _021E63A8 - _021E6356 - 2 ; case 3
	.short _021E6374 - _021E6356 - 2 ; case 4
	.short _021E63A8 - _021E6356 - 2 ; case 5
	.short _021E6374 - _021E6356 - 2 ; case 6
	.short _021E63A8 - _021E6356 - 2 ; case 7
	.short _021E6374 - _021E6356 - 2 ; case 8
	.short _021E63A8 - _021E6356 - 2 ; case 9
	.short _021E6374 - _021E6356 - 2 ; case 10
	.short _021E63A8 - _021E6356 - 2 ; case 11
	.short _021E6374 - _021E6356 - 2 ; case 12
	.short _021E63A8 - _021E6356 - 2 ; case 13
	.short _021E6374 - _021E6356 - 2 ; case 14
_021E6374:
	mov r0, #0x4a
	strb r0, [r1, #0x1d]
	ldr r1, _021E64C8 ; =ov112_021FFAA4
	mov r0, #0x2e
	ldr r1, [r1, #0x34]
	lsl r0, r0, #0xa
	mov r2, #4
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r3, r4, r5, r6, r7, pc}
_021E638C:
	mov r0, #0x4c
	strb r0, [r1, #0x1d]
	ldr r1, _021E64C8 ; =ov112_021FFAA4
	ldr r0, _021E64E0 ; =0x0000DE24
	ldr r2, [r1, #0x30]
	mov r1, #0x89
	lsl r1, r1, #2
	add r1, r2, r1
	ldr r2, _021E64E4 ; =0x00001568
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r3, r4, r5, r6, r7, pc}
_021E63A8:
	ldr r0, _021E64D4 ; =ov112_021FFB24
	mov r1, #0x4a
	strb r1, [r0, #0x1d]
	ldr r1, _021E64C8 ; =ov112_021FFAA4
	mov r0, #0x2e
	ldr r1, [r1, #0x34]
	ldr r2, _021E64E8 ; =0x000006C8
	lsl r0, r0, #0xa
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r3, r4, r5, r6, r7, pc}
_021E63C2:
	ldrb r0, [r1, #0x1c]
	cmp r0, #0x52
	bgt _021E63D0
	bge _021E6404
	cmp r0, #0x40
	beq _021E6412
	b _021E6A3E
_021E63D0:
	add r2, r0, #0
	sub r2, #0xb0
	cmp r2, #0xe
	bls _021E63DA
	b _021E6A3E
_021E63DA:
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_021E63E6: ; jump table
	.short _021E642E - _021E63E6 - 2 ; case 0
	.short _021E6A3E - _021E63E6 - 2 ; case 1
	.short _021E645E - _021E63E6 - 2 ; case 2
	.short _021E6A3E - _021E63E6 - 2 ; case 3
	.short _021E6490 - _021E63E6 - 2 ; case 4
	.short _021E6A3E - _021E63E6 - 2 ; case 5
	.short _021E64C2 - _021E63E6 - 2 ; case 6
	.short _021E6A3E - _021E63E6 - 2 ; case 7
	.short _021E6526 - _021E63E6 - 2 ; case 8
	.short _021E6A3E - _021E63E6 - 2 ; case 9
	.short _021E6664 - _021E63E6 - 2 ; case 10
	.short _021E6A3E - _021E63E6 - 2 ; case 11
	.short _021E67A4 - _021E63E6 - 2 ; case 12
	.short _021E6A3E - _021E63E6 - 2 ; case 13
	.short _021E68FE - _021E63E6 - 2 ; case 14
_021E6404:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x24
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6412:
	mov r0, #0x4c
	strb r0, [r1, #0x1d]
	ldr r1, _021E64C8 ; =ov112_021FFAA4
	ldr r0, _021E64E0 ; =0x0000DE24
	ldr r2, [r1, #0x30]
	mov r1, #0x89
	lsl r1, r1, #2
	add r1, r2, r1
	ldr r2, _021E64E4 ; =0x00001568
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r3, r4, r5, r6, r7, pc}
_021E642E:
	ldr r0, _021E64C8 ; =ov112_021FFAA4
	ldr r2, [r0, #0x34]
	ldrb r0, [r2]
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x1f
	beq _021E6448
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6448:
	mov r0, #0xb0
	strb r0, [r1, #0x1d]
	add r0, r2, #4
	mov r2, #9
	ldr r1, _021E64EC ; =0x0000B804
	lsl r2, r2, #6
	bl ov112_021E5EC4
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E645E:
	ldr r0, _021E64C8 ; =ov112_021FFAA4
	ldr r3, [r0, #0x34]
	ldrb r0, [r3]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1f
	beq _021E6478
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6478:
	mov r0, #0xb2
	mov r2, #0x91
	strb r0, [r1, #0x1d]
	lsl r2, r2, #2
	add r0, r3, r2
	ldr r1, _021E64F0 ; =0x0000BA44
	add r2, #0xb8
	bl ov112_021E5EC4
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E6490:
	ldr r0, _021E64C8 ; =ov112_021FFAA4
	ldr r3, [r0, #0x34]
	ldrb r0, [r3]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1f
	beq _021E64AA
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E64AA:
	mov r2, #0xb4
	strb r2, [r1, #0x1d]
	mov r0, #0x15
	lsl r0, r0, #6
	ldr r1, _021E64F4 ; =0x0000BD40
	add r0, r3, r0
	add r2, #0xd4
	bl ov112_021E5EC4
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E64C2:
	ldr r0, _021E64C8 ; =ov112_021FFAA4
	b _021E64F8
	nop
_021E64C8: .word ov112_021FFAA4
_021E64CC: .word 0x000082EA
_021E64D0: .word 0x447A0000
_021E64D4: .word ov112_021FFB24
_021E64D8: .word 0x0000CE80
_021E64DC: .word 0x00000D4C
_021E64E0: .word 0x0000DE24
_021E64E4: .word 0x00001568
_021E64E8: .word 0x000006C8
_021E64EC: .word 0x0000B804
_021E64F0: .word 0x0000BA44
_021E64F4: .word 0x0000BD40
_021E64F8:
	ldr r2, [r0, #0x34]
	ldrb r2, [r2]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x1f
	beq _021E6510
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6510:
	mov r2, #0xb6
	strb r2, [r1, #0x1d]
	mov r1, #0xbf
	ldr r0, [r0, #0xc]
	ldr r2, _021E6824 ; =0x00000CBC
	lsl r1, r1, #8
	bl ov112_021E5EC4
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E6526:
	ldr r2, _021E6828 ; =ov112_021FFAA4
	ldr r1, [r2, #4]
	cmp r1, #3
	bhi _021E65A2
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E653A: ; jump table
	.short _021E6542 - _021E653A - 2 ; case 0
	.short _021E655A - _021E653A - 2 ; case 1
	.short _021E6572 - _021E653A - 2 ; case 2
	.short _021E658A - _021E653A - 2 ; case 3
_021E6542:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1f
	beq _021E65A2
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E655A:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1a
	lsr r1, r1, #0x1f
	beq _021E65A2
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6572:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1f
	beq _021E65A2
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E658A:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	beq _021E65A2
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E65A2:
	ldr r1, _021E6828 ; =ov112_021FFAA4
	mov r5, #0xe
	ldr r3, [r1, #0x34]
	ldrb r2, [r3]
	lsl r4, r2, #0x1c
	lsr r4, r4, #0x1c
	and r5, r4
	cmp r5, #0xe
	bne _021E6640
	mov r0, #0xf
	bic r2, r0
	mov r0, #1
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	mov r0, #0xf
	and r0, r4
	orr r0, r2
	strb r0, [r3]
	ldr r0, [r1, #4]
	cmp r0, #3
	bhi _021E663A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E65DA: ; jump table
	.short _021E65E2 - _021E65DA - 2 ; case 0
	.short _021E65F8 - _021E65DA - 2 ; case 1
	.short _021E6610 - _021E65DA - 2 ; case 2
	.short _021E6628 - _021E65DA - 2 ; case 3
_021E65E2:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb0
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #9
	ldr r1, _021E6830 ; =0x0000B804
	add r0, r0, #4
	lsl r2, r2, #6
	bl ov112_021E5EC4
	b _021E663A
_021E65F8:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb2
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #0x91
	lsl r2, r2, #2
	add r0, r0, r2
	ldr r1, _021E6834 ; =0x0000BA44
	add r2, #0xb8
	bl ov112_021E5EC4
	b _021E663A
_021E6610:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb4
	strb r2, [r0, #0x1d]
	mov r0, #0x15
	ldr r1, [r1, #0x34]
	lsl r0, r0, #6
	add r0, r1, r0
	ldr r1, _021E6838 ; =0x0000BD40
	add r2, #0xd4
	bl ov112_021E5EC4
	b _021E663A
_021E6628:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb6
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0xc]
	mov r1, #0xbf
	ldr r2, _021E6824 ; =0x00000CBC
	lsl r1, r1, #8
	bl ov112_021E5EC4
_021E663A:
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E6640:
	mov r3, #1
	add r1, r4, #0
	tst r1, r3
	beq _021E6654
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9e
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6654:
	ldr r1, _021E682C ; =ov112_021FFB24
	mov r2, #0x24
	strb r0, [r1, #0x1d]
	mov r0, #0
	add r1, r0, #0
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6664:
	ldr r2, _021E6828 ; =ov112_021FFAA4
	ldr r1, [r2, #4]
	cmp r1, #3
	bhi _021E66E0
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E6678: ; jump table
	.short _021E6680 - _021E6678 - 2 ; case 0
	.short _021E6698 - _021E6678 - 2 ; case 1
	.short _021E66B0 - _021E6678 - 2 ; case 2
	.short _021E66C8 - _021E6678 - 2 ; case 3
_021E6680:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1f
	beq _021E66E0
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6698:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1a
	lsr r1, r1, #0x1f
	beq _021E66E0
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E66B0:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1f
	beq _021E66E0
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E66C8:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	beq _021E66E0
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E66E0:
	ldr r1, _021E6828 ; =ov112_021FFAA4
	mov r5, #0xd
	ldr r4, [r1, #0x34]
	ldrb r2, [r4]
	lsl r3, r2, #0x1c
	lsr r3, r3, #0x1c
	and r5, r3
	cmp r5, #0xd
	bne _021E677E
	mov r0, #0xf
	bic r2, r0
	mov r0, #2
	orr r0, r3
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	mov r0, #0xf
	and r0, r3
	orr r0, r2
	strb r0, [r4]
	ldr r0, [r1, #4]
	cmp r0, #3
	bhi _021E6778
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E6718: ; jump table
	.short _021E6720 - _021E6718 - 2 ; case 0
	.short _021E6736 - _021E6718 - 2 ; case 1
	.short _021E674E - _021E6718 - 2 ; case 2
	.short _021E6766 - _021E6718 - 2 ; case 3
_021E6720:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb0
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #9
	ldr r1, _021E6830 ; =0x0000B804
	add r0, r0, #4
	lsl r2, r2, #6
	bl ov112_021E5EC4
	b _021E6778
_021E6736:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb2
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #0x91
	lsl r2, r2, #2
	add r0, r0, r2
	ldr r1, _021E6834 ; =0x0000BA44
	add r2, #0xb8
	bl ov112_021E5EC4
	b _021E6778
_021E674E:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb4
	strb r2, [r0, #0x1d]
	mov r0, #0x15
	ldr r1, [r1, #0x34]
	lsl r0, r0, #6
	add r0, r1, r0
	ldr r1, _021E6838 ; =0x0000BD40
	add r2, #0xd4
	bl ov112_021E5EC4
	b _021E6778
_021E6766:
	ldr r0, _021E682C ; =ov112_021FFB24
	mov r2, #0xb6
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0xc]
	mov r1, #0xbf
	ldr r2, _021E6824 ; =0x00000CBC
	lsl r1, r1, #8
	bl ov112_021E5EC4
_021E6778:
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E677E:
	mov r1, #2
	tst r1, r3
	beq _021E6792
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9e
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6792:
	ldr r1, _021E682C ; =ov112_021FFB24
	mov r2, #0x24
	strb r0, [r1, #0x1d]
	mov r0, #0
	add r1, r0, #0
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E67A4:
	ldr r2, _021E6828 ; =ov112_021FFAA4
	ldr r1, [r2, #4]
	cmp r1, #3
	bhi _021E6820
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E67B8: ; jump table
	.short _021E67C0 - _021E67B8 - 2 ; case 0
	.short _021E67D8 - _021E67B8 - 2 ; case 1
	.short _021E67F0 - _021E67B8 - 2 ; case 2
	.short _021E6808 - _021E67B8 - 2 ; case 3
_021E67C0:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1f
	beq _021E6820
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E67D8:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1a
	lsr r1, r1, #0x1f
	beq _021E6820
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E67F0:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1f
	beq _021E6820
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6808:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	beq _021E6820
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6820:
	ldr r1, _021E6828 ; =ov112_021FFAA4
	b _021E683C
	.balign 4, 0
_021E6824: .word 0x00000CBC
_021E6828: .word ov112_021FFAA4
_021E682C: .word ov112_021FFB24
_021E6830: .word 0x0000B804
_021E6834: .word 0x0000BA44
_021E6838: .word 0x0000BD40
_021E683C:
	mov r5, #0xb
	ldr r4, [r1, #0x34]
	ldrb r2, [r4]
	lsl r3, r2, #0x1c
	lsr r3, r3, #0x1c
	and r5, r3
	cmp r5, #0xb
	bne _021E68D8
	mov r0, #0xf
	bic r2, r0
	mov r0, #4
	orr r0, r3
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	mov r0, #0xf
	and r0, r3
	orr r0, r2
	strb r0, [r4]
	ldr r0, [r1, #4]
	cmp r0, #3
	bhi _021E68D2
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E6872: ; jump table
	.short _021E687A - _021E6872 - 2 ; case 0
	.short _021E6890 - _021E6872 - 2 ; case 1
	.short _021E68A8 - _021E6872 - 2 ; case 2
	.short _021E68C0 - _021E6872 - 2 ; case 3
_021E687A:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb0
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #9
	ldr r1, _021E6A58 ; =0x0000B804
	add r0, r0, #4
	lsl r2, r2, #6
	bl ov112_021E5EC4
	b _021E68D2
_021E6890:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb2
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #0x91
	lsl r2, r2, #2
	add r0, r0, r2
	ldr r1, _021E6A5C ; =0x0000BA44
	add r2, #0xb8
	bl ov112_021E5EC4
	b _021E68D2
_021E68A8:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb4
	strb r2, [r0, #0x1d]
	mov r0, #0x15
	ldr r1, [r1, #0x34]
	lsl r0, r0, #6
	add r0, r1, r0
	ldr r1, _021E6A60 ; =0x0000BD40
	add r2, #0xd4
	bl ov112_021E5EC4
	b _021E68D2
_021E68C0:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb6
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0xc]
	mov r1, #0xbf
	ldr r2, _021E6A64 ; =0x00000CBC
	lsl r1, r1, #8
	bl ov112_021E5EC4
_021E68D2:
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E68D8:
	mov r1, #4
	tst r1, r3
	beq _021E68EC
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9e
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E68EC:
	ldr r1, _021E6A54 ; =ov112_021FFB24
	mov r2, #0x24
	strb r0, [r1, #0x1d]
	mov r0, #0
	add r1, r0, #0
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E68FE:
	ldr r2, _021E6A68 ; =ov112_021FFAA4
	ldr r1, [r2, #4]
	cmp r1, #3
	bhi _021E697A
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E6912: ; jump table
	.short _021E691A - _021E6912 - 2 ; case 0
	.short _021E6932 - _021E6912 - 2 ; case 1
	.short _021E694A - _021E6912 - 2 ; case 2
	.short _021E6962 - _021E6912 - 2 ; case 3
_021E691A:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1f
	beq _021E697A
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6932:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1a
	lsr r1, r1, #0x1f
	beq _021E697A
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E694A:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1f
	beq _021E697A
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6962:
	ldr r1, [r2, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	beq _021E697A
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9c
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E697A:
	ldr r1, _021E6A68 ; =ov112_021FFAA4
	mov r5, #7
	ldr r4, [r1, #0x34]
	ldrb r2, [r4]
	lsl r3, r2, #0x1c
	lsr r3, r3, #0x1c
	and r5, r3
	cmp r5, #7
	bne _021E6A18
	mov r0, #0xf
	bic r2, r0
	mov r0, #8
	orr r0, r3
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	mov r0, #0xf
	and r0, r3
	orr r0, r2
	strb r0, [r4]
	ldr r0, [r1, #4]
	cmp r0, #3
	bhi _021E6A12
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E69B2: ; jump table
	.short _021E69BA - _021E69B2 - 2 ; case 0
	.short _021E69D0 - _021E69B2 - 2 ; case 1
	.short _021E69E8 - _021E69B2 - 2 ; case 2
	.short _021E6A00 - _021E69B2 - 2 ; case 3
_021E69BA:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb0
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #9
	ldr r1, _021E6A58 ; =0x0000B804
	add r0, r0, #4
	lsl r2, r2, #6
	bl ov112_021E5EC4
	b _021E6A12
_021E69D0:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb2
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0x34]
	mov r2, #0x91
	lsl r2, r2, #2
	add r0, r0, r2
	ldr r1, _021E6A5C ; =0x0000BA44
	add r2, #0xb8
	bl ov112_021E5EC4
	b _021E6A12
_021E69E8:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb4
	strb r2, [r0, #0x1d]
	mov r0, #0x15
	ldr r1, [r1, #0x34]
	lsl r0, r0, #6
	add r0, r1, r0
	ldr r1, _021E6A60 ; =0x0000BD40
	add r2, #0xd4
	bl ov112_021E5EC4
	b _021E6A12
_021E6A00:
	ldr r0, _021E6A54 ; =ov112_021FFB24
	mov r2, #0xb6
	strb r2, [r0, #0x1d]
	ldr r0, [r1, #0xc]
	mov r1, #0xbf
	ldr r2, _021E6A64 ; =0x00000CBC
	lsl r1, r1, #8
	bl ov112_021E5EC4
_021E6A12:
	bl ov112_021E5EEC
	pop {r3, r4, r5, r6, r7, pc}
_021E6A18:
	mov r1, #8
	tst r1, r3
	beq _021E6A2C
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x9e
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6A2C:
	ldr r1, _021E6A54 ; =ov112_021FFB24
	mov r2, #0x24
	strb r0, [r1, #0x1d]
	mov r0, #0
	add r1, r0, #0
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, r4, r5, r6, r7, pc}
_021E6A3E:
	bl OS_Halt
	pop {r3, r4, r5, r6, r7, pc}
_021E6A44:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x24
	mov r3, #1
	bl ov112_021E5A68
_021E6A50:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E6A54: .word ov112_021FFB24
_021E6A58: .word 0x0000B804
_021E6A5C: .word 0x0000BA44
_021E6A60: .word 0x0000BD40
_021E6A64: .word 0x00000CBC
_021E6A68: .word ov112_021FFAA4
	thumb_func_end ov112_021E6164

	thumb_func_start ov112_021E6A6C
ov112_021E6A6C: ; 0x021E6A6C
	push {r3, lr}
	ldr r1, _021E6BD0 ; =ov112_021FFAA4
	mov r2, #0
	str r2, [r1, #0x14]
	cmp r0, #0
	bne _021E6A84
	mov r0, #0xc
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r3, pc}
_021E6A84:
	cmp r0, #2
	bls _021E6A94
	mov r0, #0xc
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r3, pc}
_021E6A94:
	bl OS_GetTick
	ldr r2, _021E6BD0 ; =ov112_021FFAA4
	str r0, [r2, #0x3c]
	ldr r0, _021E6BD4 ; =ov112_021FFB24
	str r1, [r2, #0x40]
	ldrb r0, [r0, #0x1c]
	cmp r0, #0x60
	bgt _021E6AC4
	blt _021E6AAA
	b _021E6BBC
_021E6AAA:
	cmp r0, #0x32
	bgt _021E6AB6
	bge _021E6BAA
	cmp r0, #0x2a
	beq _021E6B88
	pop {r3, pc}
_021E6AB6:
	cmp r0, #0x40
	bgt _021E6ABE
	beq _021E6BAA
	pop {r3, pc}
_021E6ABE:
	cmp r0, #0x52
	beq _021E6BAA
	pop {r3, pc}
_021E6AC4:
	cmp r0, #0xe2
	bgt _021E6B04
	bge _021E6B4A
	cmp r0, #0xbe
	bgt _021E6AFE
	add r1, r0, #0
	sub r1, #0xb0
	bmi _021E6BCE
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E6AE0: ; jump table
	.short _021E6BBC - _021E6AE0 - 2 ; case 0
	.short _021E6BCE - _021E6AE0 - 2 ; case 1
	.short _021E6BBC - _021E6AE0 - 2 ; case 2
	.short _021E6BCE - _021E6AE0 - 2 ; case 3
	.short _021E6BBC - _021E6AE0 - 2 ; case 4
	.short _021E6BCE - _021E6AE0 - 2 ; case 5
	.short _021E6BBC - _021E6AE0 - 2 ; case 6
	.short _021E6BCE - _021E6AE0 - 2 ; case 7
	.short _021E6BBC - _021E6AE0 - 2 ; case 8
	.short _021E6BCE - _021E6AE0 - 2 ; case 9
	.short _021E6BBC - _021E6AE0 - 2 ; case 10
	.short _021E6BCE - _021E6AE0 - 2 ; case 11
	.short _021E6BBC - _021E6AE0 - 2 ; case 12
	.short _021E6BCE - _021E6AE0 - 2 ; case 13
	.short _021E6BBC - _021E6AE0 - 2 ; case 14
_021E6AFE:
	cmp r0, #0xe0
	beq _021E6B70
	pop {r3, pc}
_021E6B04:
	cmp r0, #0xf0
	bgt _021E6B0C
	beq _021E6B12
	pop {r3, pc}
_021E6B0C:
	cmp r0, #0xfe
	beq _021E6B34
	pop {r3, pc}
_021E6B12:
	bl ov112_021E5E28
	ldr r0, _021E6BD0 ; =ov112_021FFAA4
	ldr r1, _021E6BD8 ; =ov112_021FFB64
	ldr r0, [r0, #0x20]
	mov r2, #0x28
	add r0, #0x10
	bl MI_CpuCopy8
	ldr r2, _021E6BD4 ; =ov112_021FFB24
	ldr r0, _021E6BD8 ; =ov112_021FFB64
	ldrb r2, [r2, #0x1c]
	mov r1, #0x74
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, pc}
_021E6B34:
	bl ov112_021E5E28
	ldr r2, _021E6BD4 ; =ov112_021FFB24
	ldr r0, _021E6BD0 ; =ov112_021FFAA4
	ldrb r2, [r2, #0x1c]
	ldr r0, [r0, #0x28]
	mov r1, #8
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, pc}
_021E6B4A:
	mov r1, #0x80
	add r0, sp, #0
	strb r1, [r0]
	ldrh r2, [r2]
	mov r3, #0
	asr r1, r2, #8
	strb r1, [r0, #1]
	strb r2, [r0, #2]
	ldrb r1, [r0, #1]
	add r2, r1, #1
	ldrb r1, [r0, #2]
	add r1, r2, r1
	strb r1, [r0, #3]
	add r0, sp, #0
	mov r1, #4
	mov r2, #0xa
	bl ov112_021E5A68
	pop {r3, pc}
_021E6B70:
	bl ov112_021E5E28
	ldr r0, _021E6BD0 ; =ov112_021FFAA4
	ldr r2, _021E6BD4 ; =ov112_021FFB24
	ldr r0, [r0, #0x20]
	ldrb r2, [r2, #0x1c]
	add r0, #0x10
	mov r1, #0x28
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, pc}
_021E6B88:
	bl ov112_021E5E28
	ldr r0, _021E6BD0 ; =ov112_021FFAA4
	ldr r2, _021E6BD4 ; =ov112_021FFB24
	ldr r0, [r0, #0x20]
	ldrb r2, [r2, #0x1d]
	add r0, #0x10
	mov r1, #0x28
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r3, pc}
_021E6BAA:
	bl ov112_021E5E48
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x20
	mov r3, #1
	bl ov112_021E5A68
	pop {r3, pc}
_021E6BBC:
	ldr r1, _021E6BD0 ; =ov112_021FFAA4
	mov r0, #0
	ldr r1, [r1, #0x20]
	mov r2, #0x20
	str r0, [r1, #0x60]
	add r1, r0, #0
	mov r3, #1
	bl ov112_021E5A68
_021E6BCE:
	pop {r3, pc}
	.balign 4, 0
_021E6BD0: .word ov112_021FFAA4
_021E6BD4: .word ov112_021FFB24
_021E6BD8: .word ov112_021FFB64
	thumb_func_end ov112_021E6A6C

	thumb_func_start ov112_021E6BDC
ov112_021E6BDC: ; 0x021E6BDC
	ldr r0, _021E6BF4 ; =ov112_021FFB24
	ldr r1, [r0, #0x24]
	str r1, [r0, #0x20]
	ldr r1, [r0, #0x2c]
	str r1, [r0, #0x28]
	ldrh r1, [r0, #0x32]
	strh r1, [r0, #0x30]
	mov r1, #0
	strh r1, [r0, #0x36]
	strh r1, [r0, #0x3a]
	bx lr
	nop
_021E6BF4: .word ov112_021FFB24
	thumb_func_end ov112_021E6BDC

	thumb_func_start ov112_021E6BF8
ov112_021E6BF8: ; 0x021E6BF8
	push {r4, lr}
	ldr r0, _021E6EA8 ; =ov112_021FFB24
	ldrb r2, [r0, #0x1c]
	cmp r2, #0x52
	bgt _021E6C14
	blt _021E6C06
	b _021E6D6C
_021E6C06:
	cmp r2, #0x32
	bgt _021E6C0E
	beq _021E6C52
	b _021E6F52
_021E6C0E:
	cmp r2, #0x40
	beq _021E6C8E
	b _021E6F52
_021E6C14:
	cmp r2, #0x60
	bgt _021E6C1E
	bne _021E6C1C
	b _021E6E4C
_021E6C1C:
	b _021E6F52
_021E6C1E:
	add r0, r2, #0
	sub r0, #0xb0
	cmp r0, #0xe
	bls _021E6C28
	b _021E6F52
_021E6C28:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E6C34: ; jump table
	.short _021E6EA4 - _021E6C34 - 2 ; case 0
	.short _021E6F52 - _021E6C34 - 2 ; case 1
	.short _021E6EA4 - _021E6C34 - 2 ; case 2
	.short _021E6F52 - _021E6C34 - 2 ; case 3
	.short _021E6EA4 - _021E6C34 - 2 ; case 4
	.short _021E6F52 - _021E6C34 - 2 ; case 5
	.short _021E6EA4 - _021E6C34 - 2 ; case 6
	.short _021E6F52 - _021E6C34 - 2 ; case 7
	.short _021E6EA4 - _021E6C34 - 2 ; case 8
	.short _021E6F52 - _021E6C34 - 2 ; case 9
	.short _021E6EA4 - _021E6C34 - 2 ; case 10
	.short _021E6F52 - _021E6C34 - 2 ; case 11
	.short _021E6EA4 - _021E6C34 - 2 ; case 12
	.short _021E6F52 - _021E6C34 - 2 ; case 13
	.short _021E6EA4 - _021E6C34 - 2 ; case 14
_021E6C52:
	ldr r0, _021E6EAC ; =ov112_021FFAA4
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq _021E6C7E
	ldr r0, [r0, #0x24]
	add r0, #0x5b
	ldrb r0, [r0]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	beq _021E6C7E
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x36
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #4
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6C7E:
	ldr r0, _021E6EAC ; =ov112_021FFAA4
	mov r1, #0x68
	ldr r0, [r0, #0x20]
	mov r2, #0x32
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, pc}
_021E6C8E:
	ldr r2, _021E6EAC ; =ov112_021FFAA4
	ldr r1, [r2, #0x24]
	add r0, r1, #0
	add r0, #0x5b
	ldrb r0, [r0]
	lsl r3, r0, #0x1f
	lsr r3, r3, #0x1f
	bne _021E6CB6
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x44
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #5
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6CB6:
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	bne _021E6CD4
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x44
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #6
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6CD4:
	ldr r0, [r2, #0x20]
	ldr r3, [r1, #0xc]
	ldr r2, [r0, #0xc]
	cmp r3, r2
	beq _021E6CF6
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x44
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xb
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6CF6:
	ldr r3, [r1, #4]
	ldr r2, [r0, #4]
	cmp r3, r2
	beq _021E6D16
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x44
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #8
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6D16:
	ldrh r2, [r1, #0xa]
	lsr r3, r2, #2
	ldrh r2, [r0, #0xa]
	lsr r2, r2, #2
	cmp r3, r2
	beq _021E6D3A
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x44
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #9
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6D3A:
	add r1, #0x5d
	ldrb r2, [r1]
	add r1, r0, #0
	add r1, #0x5d
	ldrb r1, [r1]
	cmp r2, r1
	bls _021E6D60
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x44
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xa
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6D60:
	mov r1, #0x68
	mov r2, #0x40
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, pc}
_021E6D6C:
	ldr r2, _021E6EAC ; =ov112_021FFAA4
	ldr r1, [r2, #0x24]
	add r0, r1, #0
	add r0, #0x5b
	ldrb r0, [r0]
	lsl r3, r0, #0x1f
	lsr r3, r3, #0x1f
	bne _021E6D94
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x56
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #5
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6D94:
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _021E6DB4
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x56
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #7
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6DB4:
	ldr r0, [r2, #0x20]
	ldr r3, [r1]
	ldr r2, [r0]
	cmp r3, r2
	beq _021E6DD6
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x56
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #8
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6DD6:
	ldrh r2, [r1, #8]
	lsr r3, r2, #2
	ldrh r2, [r0, #8]
	lsr r2, r2, #2
	cmp r3, r2
	beq _021E6DFA
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x56
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #9
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6DFA:
	ldr r3, [r1, #0xc]
	ldr r2, [r0, #0xc]
	cmp r3, r2
	beq _021E6E1A
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x56
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xb
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6E1A:
	add r1, #0x5d
	ldrb r2, [r1]
	add r1, r0, #0
	add r1, #0x5d
	ldrb r1, [r1]
	cmp r2, r1
	bls _021E6E40
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x56
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xa
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6E40:
	mov r1, #0x68
	mov r2, #0x52
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, pc}
_021E6E4C:
	ldr r1, _021E6EAC ; =ov112_021FFAA4
	ldr r2, [r1, #0x24]
	add r0, r2, #0
	add r0, #0x5b
	ldrb r0, [r0]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	ldr r0, [r1, #0x20]
	bne _021E6E74
	mov r1, #0x68
	mov r2, #0x64
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #5
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6E74:
	add r1, r0, #0
	add r2, #0x5d
	add r1, #0x5d
	ldrb r2, [r2]
	ldrb r1, [r1]
	cmp r2, r1
	bls _021E6E98
	mov r1, #0x68
	mov r2, #0x64
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xa
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6E98:
	mov r1, #0x68
	mov r2, #0x60
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, pc}
_021E6EA4:
	ldr r3, _021E6EAC ; =ov112_021FFAA4
	b _021E6EB0
	.balign 4, 0
_021E6EA8: .word ov112_021FFB24
_021E6EAC: .word ov112_021FFAA4
_021E6EB0:
	ldr r1, [r3, #0x24]
	add r0, r1, #0
	add r0, #0x5b
	ldrb r0, [r0]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	bne _021E6ED6
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd8
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #5
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6ED6:
	ldr r0, [r3, #0x20]
	ldr r4, [r1]
	ldr r3, [r0]
	cmp r4, r3
	beq _021E6EF8
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd8
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #8
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6EF8:
	ldrh r3, [r1, #8]
	lsr r4, r3, #2
	ldrh r3, [r0, #8]
	lsr r3, r3, #2
	cmp r4, r3
	beq _021E6F1C
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd8
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #9
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6F1C:
	add r1, #0x5d
	ldrb r3, [r1]
	add r1, r0, #0
	add r1, #0x5d
	ldrb r1, [r1]
	cmp r3, r1
	bls _021E6F42
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd8
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xa
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
_021E6F42:
	sub r2, #0x10
	lsl r2, r2, #0x18
	mov r1, #0x68
	lsr r2, r2, #0x18
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, pc}
_021E6F52:
	mov r0, #0xc
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021E6BF8

	thumb_func_start ov112_021E6F60
ov112_021E6F60: ; 0x021E6F60
	push {r4, r5, r6, lr}
	add r4, r1, #0
	cmp r2, #0x9e
	bgt _021E6FE8
	blt _021E6F6C
	b _021E71F4
_021E6F6C:
	cmp r2, #0x44
	bgt _021E6FB6
	blt _021E6F74
	b _021E7268
_021E6F74:
	cmp r2, #0x28
	bgt _021E6F9E
	cmp r2, #0x22
	blt _021E6F8C
	beq _021E7076
	cmp r2, #0x26
	bne _021E6F84
	b _021E70B0
_021E6F84:
	cmp r2, #0x28
	bne _021E6F8A
	b _021E720C
_021E6F8A:
	pop {r4, r5, r6, pc}
_021E6F8C:
	cmp r2, #4
	bgt _021E6F96
	bne _021E6F94
	b _021E732E
_021E6F94:
	pop {r4, r5, r6, pc}
_021E6F96:
	cmp r2, #0xe
	bne _021E6F9C
	b _021E7342
_021E6F9C:
	pop {r4, r5, r6, pc}
_021E6F9E:
	cmp r2, #0x38
	bgt _021E6FAE
	blt _021E6FA6
	b _021E7242
_021E6FA6:
	cmp r2, #0x34
	bne _021E6FAC
	b _021E7218
_021E6FAC:
	pop {r4, r5, r6, pc}
_021E6FAE:
	cmp r2, #0x42
	bne _021E6FB4
	b _021E724E
_021E6FB4:
	pop {r4, r5, r6, pc}
_021E6FB6:
	cmp r2, #0x5e
	bgt _021E6FD0
	blt _021E6FBE
	b _021E72AA
_021E6FBE:
	cmp r2, #0x54
	bgt _021E6FC8
	bne _021E6FC6
	b _021E7274
_021E6FC6:
	pop {r4, r5, r6, pc}
_021E6FC8:
	cmp r2, #0x5a
	bne _021E6FCE
	b _021E729E
_021E6FCE:
	pop {r4, r5, r6, pc}
_021E6FD0:
	cmp r2, #0x64
	bgt _021E6FE0
	blt _021E6FD8
	b _021E72CE
_021E6FD8:
	cmp r2, #0x62
	bne _021E6FDE
	b _021E72B6
_021E6FDE:
	pop {r4, r5, r6, pc}
_021E6FE0:
	cmp r2, #0x9c
	bne _021E6FE6
	b _021E7200
_021E6FE6:
	pop {r4, r5, r6, pc}
_021E6FE8:
	cmp r2, #0xca
	bgt _021E7040
	bge _021E7052
	cmp r2, #0xc2
	bgt _021E702E
	bge _021E7052
	cmp r2, #0xae
	bgt _021E7028
	add r0, r2, #0
	sub r0, #0xa0
	bmi _021E7064
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E700A: ; jump table
	.short _021E72DA - _021E700A - 2 ; case 0
	.short _021E737C - _021E700A - 2 ; case 1
	.short _021E72DA - _021E700A - 2 ; case 2
	.short _021E737C - _021E700A - 2 ; case 3
	.short _021E72DA - _021E700A - 2 ; case 4
	.short _021E737C - _021E700A - 2 ; case 5
	.short _021E72DA - _021E700A - 2 ; case 6
	.short _021E737C - _021E700A - 2 ; case 7
	.short _021E72DA - _021E700A - 2 ; case 8
	.short _021E737C - _021E700A - 2 ; case 9
	.short _021E72DA - _021E700A - 2 ; case 10
	.short _021E737C - _021E700A - 2 ; case 11
	.short _021E72DA - _021E700A - 2 ; case 12
	.short _021E737C - _021E700A - 2 ; case 13
	.short _021E72DA - _021E700A - 2 ; case 14
_021E7028:
	cmp r2, #0xc0
	beq _021E7052
	pop {r4, r5, r6, pc}
_021E702E:
	cmp r2, #0xc6
	bgt _021E703A
	bge _021E7052
	cmp r2, #0xc4
	beq _021E7052
	pop {r4, r5, r6, pc}
_021E703A:
	cmp r2, #0xc8
	beq _021E7052
	pop {r4, r5, r6, pc}
_021E7040:
	cmp r2, #0xe2
	bgt _021E705E
	blt _021E7048
	b _021E7316
_021E7048:
	cmp r2, #0xce
	bgt _021E7056
	bge _021E7052
	cmp r2, #0xcc
	bne _021E7054
_021E7052:
	b _021E72F2
_021E7054:
	pop {r4, r5, r6, pc}
_021E7056:
	cmp r2, #0xe0
	bne _021E705C
	b _021E7322
_021E705C:
	pop {r4, r5, r6, pc}
_021E705E:
	cmp r2, #0xf4
	bgt _021E706E
	blt _021E7066
_021E7064:
	b _021E737C
_021E7066:
	cmp r2, #0xf0
	bne _021E706C
	b _021E72FE
_021E706C:
	pop {r4, r5, r6, pc}
_021E706E:
	cmp r2, #0xfe
	bne _021E7074
	b _021E730A
_021E7074:
	pop {r4, r5, r6, pc}
_021E7076:
	ldr r1, _021E7380 ; =ov112_021FFAA4
	mov r2, #0x68
	ldr r1, [r1, #0x24]
	bl MI_CpuCopy8
	ldr r0, _021E7380 ; =ov112_021FFAA4
	mov r5, #0xff
	ldr r4, [r0, #0x24]
	lsl r5, r5, #0x18
	ldr r3, [r4, #0x64]
	lsl r0, r3, #0x18
	add r2, r0, #0
	lsl r1, r3, #8
	lsr r0, r5, #8
	and r1, r0
	lsr r0, r3, #0x18
	lsl r0, r0, #0x18
	lsr r6, r3, #8
	lsr r3, r5, #0x10
	lsr r0, r0, #0x18
	and r3, r6
	orr r0, r3
	and r2, r5
	orr r0, r1
	orr r0, r2
	str r0, [r4, #0x64]
	bl ov112_021E6BF8
	pop {r4, r5, r6, pc}
_021E70B0:
	ldr r0, _021E7384 ; =ov112_021FFB24
	ldrb r2, [r0, #0x1c]
	cmp r2, #0x52
	bgt _021E70C8
	bge _021E7128
	cmp r2, #0x32
	bgt _021E70C2
	beq _021E7102
	pop {r4, r5, r6, pc}
_021E70C2:
	cmp r2, #0x40
	beq _021E7110
	pop {r4, r5, r6, pc}
_021E70C8:
	cmp r2, #0x60
	bgt _021E70D0
	beq _021E7136
	pop {r4, r5, r6, pc}
_021E70D0:
	add r0, r2, #0
	sub r0, #0xb0
	cmp r0, #0xe
	bhi _021E719A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E70E4: ; jump table
	.short _021E714E - _021E70E4 - 2 ; case 0
	.short _021E737C - _021E70E4 - 2 ; case 1
	.short _021E715C - _021E70E4 - 2 ; case 2
	.short _021E737C - _021E70E4 - 2 ; case 3
	.short _021E716A - _021E70E4 - 2 ; case 4
	.short _021E737C - _021E70E4 - 2 ; case 5
	.short _021E7178 - _021E70E4 - 2 ; case 6
	.short _021E737C - _021E70E4 - 2 ; case 7
	.short _021E7186 - _021E70E4 - 2 ; case 8
	.short _021E737C - _021E70E4 - 2 ; case 9
	.short _021E7186 - _021E70E4 - 2 ; case 10
	.short _021E737C - _021E70E4 - 2 ; case 11
	.short _021E7186 - _021E70E4 - 2 ; case 12
	.short _021E737C - _021E70E4 - 2 ; case 13
	.short _021E7186 - _021E70E4 - 2 ; case 14
_021E7102:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x38
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E7110:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x4e
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E7128:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x5a
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E7136:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x66
	mov r3, #1
	bl ov112_021E5A68
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E714E:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xc0
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E715C:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xc2
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E716A:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xc4
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E7178:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xc6
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E7186:
	ldr r0, _021E7380 ; =ov112_021FFAA4
	ldr r1, [r0, #0x34]
	ldrb r1, [r1]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	cmp r1, #0xf
	bne _021E71E8
	ldr r0, [r0, #4]
	cmp r0, #3
	bls _021E719C
_021E719A:
	b _021E737C
_021E719C:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E71A8: ; jump table
	.short _021E71B0 - _021E71A8 - 2 ; case 0
	.short _021E71BE - _021E71A8 - 2 ; case 1
	.short _021E71CC - _021E71A8 - 2 ; case 2
	.short _021E71DA - _021E71A8 - 2 ; case 3
_021E71B0:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd0
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E71BE:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd2
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E71CC:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd4
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E71DA:
	mov r0, #0
	add r1, r0, #0
	mov r2, #0xd6
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E71E8:
	mov r0, #0
	add r1, r0, #0
	mov r3, #1
	bl ov112_021E5A68
	pop {r4, r5, r6, pc}
_021E71F4:
	mov r0, #0xc
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E7200:
	mov r0, #0xc
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E720C:
	mov r0, #3
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E7218:
	ldr r0, _021E7384 ; =ov112_021FFB24
	mov r1, #0x3a
	strb r1, [r0, #0x1d]
	ldr r1, _021E7380 ; =ov112_021FFAA4
	ldr r2, _021E7388 ; =0x00008C50
	ldr r0, [r1, #0x50]
	cmp r0, #0
	beq _021E7232
	mov r1, #0xa
	lsl r1, r1, #6
	bl ov112_021E5EC4
	b _021E723C
_021E7232:
	ldr r0, [r1, #0x10]
	mov r1, #0xa
	lsl r1, r1, #6
	bl ov112_021E5EC4
_021E723C:
	bl ov112_021E5EEC
	pop {r4, r5, r6, pc}
_021E7242:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E724E:
	ldr r0, _021E7384 ; =ov112_021FFB24
	mov r1, #0x46
	strb r1, [r0, #0x1d]
	ldr r1, _021E7380 ; =ov112_021FFAA4
	mov r0, #0x8f
	ldr r1, [r1, #8]
	lsl r0, r0, #8
	mov r2, #0x2a
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r4, r5, r6, pc}
_021E7268:
	mov r0, #0xe
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E7274:
	ldr r0, _021E7384 ; =ov112_021FFB24
	mov r1, #0x3c
	strb r1, [r0, #0x1d]
	ldr r1, _021E7380 ; =ov112_021FFAA4
	ldr r2, _021E738C ; =0x000028BE
	ldr r0, [r1, #0x58]
	cmp r0, #0
	beq _021E728E
	mov r1, #0xd7
	lsl r1, r1, #8
	bl ov112_021E5EC4
	b _021E7298
_021E728E:
	ldr r0, [r1, #0x2c]
	mov r1, #0xd7
	lsl r1, r1, #8
	bl ov112_021E5EC4
_021E7298:
	bl ov112_021E5EEC
	pop {r4, r5, r6, pc}
_021E729E:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E72AA:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E72B6:
	ldr r0, _021E7384 ; =ov112_021FFB24
	mov r1, #0x48
	strb r1, [r0, #0x1d]
	ldr r1, _021E7380 ; =ov112_021FFAA4
	ldr r0, _021E7390 ; =0x0000CE80
	ldr r1, [r1, #0x38]
	ldr r2, _021E7394 ; =0x00000D4C
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r4, r5, r6, pc}
_021E72CE:
	mov r0, #0xe
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E72DA:
	ldr r0, _021E7384 ; =ov112_021FFB24
	mov r1, #0x48
	strb r1, [r0, #0x1d]
	ldr r1, _021E7380 ; =ov112_021FFAA4
	ldr r0, _021E7390 ; =0x0000CE80
	ldr r1, [r1, #0x38]
	ldr r2, _021E7394 ; =0x00000D4C
	bl ov112_021E5EC4
	bl ov112_021E6134
	pop {r4, r5, r6, pc}
_021E72F2:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E72FE:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E730A:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E7316:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E7322:
	mov r0, #0xf
	bl ov112_021E5E18
	bl ov112_021E5A5C
	pop {r4, r5, r6, pc}
_021E732E:
	ldr r0, _021E7384 ; =ov112_021FFB24
	ldrh r0, [r0, #0x30]
	cmp r0, #0
	bne _021E733C
	bl ov112_021E6004
	pop {r4, r5, r6, pc}
_021E733C:
	bl ov112_021E5EEC
	pop {r4, r5, r6, pc}
_021E7342:
	ldr r1, _021E7384 ; =ov112_021FFB24
	add r2, r4, #0
	ldr r1, [r1, #0x28]
	bl MI_CpuCopy8
	ldr r0, _021E7384 ; =ov112_021FFB24
	ldr r1, [r0, #0x20]
	add r1, r1, r4
	str r1, [r0, #0x20]
	ldr r1, [r0, #0x28]
	add r1, r1, r4
	str r1, [r0, #0x28]
	ldrh r1, [r0, #0x30]
	sub r1, r1, r4
	strh r1, [r0, #0x30]
	ldrh r1, [r0, #0x36]
	add r1, r1, #1
	strh r1, [r0, #0x36]
	ldrh r1, [r0, #0x3a]
	add r1, r1, #1
	strh r1, [r0, #0x3a]
	ldrh r0, [r0, #0x30]
	cmp r0, #0
	bne _021E7378
	bl ov112_021E6164
	pop {r4, r5, r6, pc}
_021E7378:
	bl ov112_021E6134
_021E737C:
	pop {r4, r5, r6, pc}
	nop
_021E7380: .word ov112_021FFAA4
_021E7384: .word ov112_021FFB24
_021E7388: .word 0x00008C50
_021E738C: .word 0x000028BE
_021E7390: .word 0x0000CE80
_021E7394: .word 0x00000D4C
	thumb_func_end ov112_021E6F60

	thumb_func_start ov112_021E7398
ov112_021E7398: ; 0x021E7398
	push {r4, r5, r6, lr}
	ldr r5, _021E73C4 ; =ov112_021FFB08
	mov r4, #2
	mov r6, #4
_021E73A0:
	add r0, r5, #0
	bl OS_LockMutex
	bl ov112_021E5B98
	cmp r0, #1
	bne _021E73B4
	add r0, r4, #0
	bl ov112_021E5E18
_021E73B4:
	add r0, r5, #0
	bl OS_UnlockMutex
	add r0, r6, #0
	bl OS_Sleep
	b _021E73A0
	nop
_021E73C4: .word ov112_021FFB08
	thumb_func_end ov112_021E7398

	thumb_func_start ov112_021E73C8
ov112_021E73C8: ; 0x021E73C8
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r1, #0
	ldr r0, _021E7440 ; =ov112_021FFAA4
	mov r1, #1
	str r1, [r0, #0x18]
	str r1, [r0, #0x14]
	mov r1, #0
	str r1, [r0, #0x44]
	add r6, r2, #0
	str r1, [r0, #0x48]
	bl ov112_021E5964
	mov r0, #1
	bl ov112_021E5D5C
	ldr r0, _021E7444 ; =ov112_021E6A6C
	bl ov112_021E5D38
	ldr r0, _021E7448 ; =ov112_021E6F60
	bl ov112_021E5D44
	ldr r0, _021E744C ; =ov112_021E6BDC
	bl ov112_021E5D50
	bl CARD_SpiWaitGetStatus
	bl CARD_SpiWaitGetStatus
	cmp r0, #0xaa
	bne _021E7414
	mov r0, #0
	bl CARD_SetSpiWriteWaitCycles
	mov r0, #0
	bl CARD_SetSpiReadWaitCycles
_021E7414:
	ldr r0, _021E7450 ; =ov112_021FFB08
	bl OS_InitMutex
	ldr r0, _021E7454 ; =ov112_021FFB20
	ldr r1, _021E7458 ; =ov112_021FFAC0
	mov r2, #1
	bl OS_InitMessageQueue
	str r4, [sp]
	ldr r0, _021E745C ; =ov112_021FFBD8
	ldr r1, _021E7460 ; =ov112_021E7398
	mov r2, #0
	add r3, r5, r4
	str r6, [sp, #4]
	bl OS_CreateThread
	ldr r0, _021E745C ; =ov112_021FFBD8
	bl OS_WakeupThreadDirect
	add sp, #8
	pop {r4, r5, r6, pc}
	nop
_021E7440: .word ov112_021FFAA4
_021E7444: .word ov112_021E6A6C
_021E7448: .word ov112_021E6F60
_021E744C: .word ov112_021E6BDC
_021E7450: .word ov112_021FFB08
_021E7454: .word ov112_021FFB20
_021E7458: .word ov112_021FFAC0
_021E745C: .word ov112_021FFBD8
_021E7460: .word ov112_021E7398
	thumb_func_end ov112_021E73C8

	thumb_func_start ov112_021E7464
ov112_021E7464: ; 0x021E7464
	push {r3, lr}
	ldr r0, _021E747C ; =ov112_021FFB08
	bl OS_LockMutex
	ldr r0, _021E7480 ; =ov112_021FFBD8
	mov r1, #0
	bl OS_KillThread
	ldr r0, _021E747C ; =ov112_021FFB08
	bl OS_UnlockMutex
	pop {r3, pc}
	.balign 4, 0
_021E747C: .word ov112_021FFB08
_021E7480: .word ov112_021FFBD8
	thumb_func_end ov112_021E7464

	thumb_func_start ov112_021E7484
ov112_021E7484: ; 0x021E7484
	ldr r1, _021E74A0 ; =ov112_021FFB24
	mov r2, #0x2a
	strb r2, [r1, #0x1c]
	cmp r0, #0
	beq _021E7492
	strb r2, [r1, #0x1d]
	b _021E7496
_021E7492:
	mov r0, #0x2c
	strb r0, [r1, #0x1d]
_021E7496:
	ldr r3, _021E74A4 ; =ov112_021E5EC4
	mov r0, #0
	add r1, r0, #0
	mov r2, #0x28
	bx r3
	.balign 4, 0
_021E74A0: .word ov112_021FFB24
_021E74A4: .word ov112_021E5EC4
	thumb_func_end ov112_021E7484

	thumb_func_start ov112_021E74A8
ov112_021E74A8: ; 0x021E74A8
	push {r3, lr}
	ldr r3, _021E752C ; =ov112_021FFAA4
	str r0, [r3, #0x10]
	str r1, [r3, #0x2c]
	str r2, [r3, #0x30]
	ldr r0, _021E7530 ; =ov112_021FFB24
	mov r1, #0x32
	strb r1, [r0, #0x1c]
	mov r1, #0x20
	strb r1, [r0, #0x1d]
	mov r0, #0
	ldr r2, _021E7534 ; =0x00000D4C
	add r1, r0, #0
	bl ov112_021E5EC4
	ldr r0, _021E7538 ; =0x0000B732
	ldr r1, _021E7530 ; =ov112_021FFB24
	strh r0, [r1, #0x3c]
	mov r0, #0
	strh r0, [r1, #0x3a]
	ldrh r2, [r1, #0x3c]
	add r2, #0x7f
	asr r0, r2, #6
	lsr r0, r0, #0x19
	add r0, r2, r0
	asr r0, r0, #7
	strh r0, [r1, #0x38]
	ldr r0, _021E752C ; =ov112_021FFAA4
	ldr r1, [r0, #0x48]
	cmp r1, #0
	beq _021E752A
	ldr r3, [r0, #0x44]
	ldr r2, _021E753C ; =0x00008C50
	str r3, [r0, #0x4c]
	str r1, [r0, #0x50]
	ldr r0, [r0, #0x10]
	bl ov112_021E5D8C
	ldr r2, _021E752C ; =ov112_021FFAA4
	ldr r0, _021E7540 ; =0x00000119
	ldr r1, [r2, #0x44]
	add r3, r1, r0
	str r3, [r2, #0x54]
	ldr r1, [r2, #0x48]
	lsl r0, r0, #7
	add r1, r1, r0
	str r1, [r2, #0x58]
	ldr r0, [r2, #0x2c]
	ldr r2, _021E7544 ; =0x000028BE
	bl ov112_021E5D8C
	ldr r2, _021E752C ; =ov112_021FFAA4
	mov r0, #0x29
	ldr r3, [r2, #0x54]
	lsl r0, r0, #8
	add r3, #0x52
	str r3, [r2, #0x5c]
	ldr r1, [r2, #0x58]
	add r1, r1, r0
	str r1, [r2, #0x60]
	ldr r0, [r2, #0x30]
	mov r2, #0x89
	lsl r2, r2, #2
	bl ov112_021E5D8C
_021E752A:
	pop {r3, pc}
	.balign 4, 0
_021E752C: .word ov112_021FFAA4
_021E7530: .word ov112_021FFB24
_021E7534: .word 0x00000D4C
_021E7538: .word 0x0000B732
_021E753C: .word 0x00008C50
_021E7540: .word 0x00000119
_021E7544: .word 0x000028BE
	thumb_func_end ov112_021E74A8

	thumb_func_start ov112_021E7548
ov112_021E7548: ; 0x021E7548
	push {r4, lr}
	ldr r4, _021E7584 ; =ov112_021FFAA4
	str r0, [r4, #8]
	str r1, [r4, #0x38]
	str r2, [r4, #0x34]
	ldr r0, _021E7588 ; =ov112_021FFB24
	str r3, [r4, #0x30]
	mov r1, #0x40
	strb r1, [r0, #0x1c]
	mov r1, #0x20
	strb r1, [r0, #0x1d]
	mov r0, #0
	ldr r2, _021E758C ; =0x00000D4C
	add r1, r0, #0
	bl ov112_021E5EC4
	ldr r0, _021E7590 ; =0x00002BCA
	ldr r1, _021E7588 ; =ov112_021FFB24
	strh r0, [r1, #0x3c]
	mov r0, #0
	strh r0, [r1, #0x3a]
	ldrh r2, [r1, #0x3c]
	add r2, #0x7f
	asr r0, r2, #6
	lsr r0, r0, #0x19
	add r0, r2, r0
	asr r0, r0, #7
	strh r0, [r1, #0x38]
	pop {r4, pc}
	nop
_021E7584: .word ov112_021FFAA4
_021E7588: .word ov112_021FFB24
_021E758C: .word 0x00000D4C
_021E7590: .word 0x00002BCA
	thumb_func_end ov112_021E7548

	thumb_func_start ov112_021E7594
ov112_021E7594: ; 0x021E7594
	push {r4, lr}
	ldr r4, _021E7608 ; =ov112_021FFAA4
	str r0, [r4, #0x2c]
	str r1, [r4, #0x30]
	str r2, [r4, #0x38]
	ldr r0, _021E760C ; =ov112_021FFB24
	str r3, [r4, #0x34]
	mov r1, #0x52
	strb r1, [r0, #0x1c]
	mov r1, #0x20
	strb r1, [r0, #0x1d]
	mov r0, #0
	ldr r2, _021E7610 ; =0x00000D4C
	add r1, r0, #0
	bl ov112_021E5EC4
	ldr r0, _021E7614 ; =0x0000382E
	ldr r1, _021E760C ; =ov112_021FFB24
	strh r0, [r1, #0x3c]
	mov r0, #0
	strh r0, [r1, #0x3a]
	ldrh r2, [r1, #0x3c]
	add r2, #0x7f
	asr r0, r2, #6
	lsr r0, r0, #0x19
	add r0, r2, r0
	add r2, r4, #0
	asr r0, r0, #7
	ldr r4, [r2, #0x48]
	strh r0, [r1, #0x38]
	cmp r4, #0
	beq _021E7606
	ldr r1, [r2, #0x44]
	ldr r0, _021E7618 ; =0x00000119
	add r3, r1, r0
	lsl r0, r0, #7
	str r3, [r2, #0x54]
	add r1, r4, r0
	str r1, [r2, #0x58]
	ldr r0, [r2, #0x2c]
	ldr r2, _021E761C ; =0x000028BE
	bl ov112_021E5D8C
	ldr r2, _021E7608 ; =ov112_021FFAA4
	mov r0, #0x29
	ldr r3, [r2, #0x54]
	lsl r0, r0, #8
	add r3, #0x52
	str r3, [r2, #0x5c]
	ldr r1, [r2, #0x58]
	add r1, r1, r0
	str r1, [r2, #0x60]
	ldr r0, [r2, #0x30]
	mov r2, #0x89
	lsl r2, r2, #2
	bl ov112_021E5D8C
_021E7606:
	pop {r4, pc}
	.balign 4, 0
_021E7608: .word ov112_021FFAA4
_021E760C: .word ov112_021FFB24
_021E7610: .word 0x00000D4C
_021E7614: .word 0x0000382E
_021E7618: .word 0x00000119
_021E761C: .word 0x000028BE
	thumb_func_end ov112_021E7594

	thumb_func_start ov112_021E7620
ov112_021E7620: ; 0x021E7620
	push {r3, lr}
	ldr r2, _021E7658 ; =ov112_021FFAA4
	str r0, [r2, #0x38]
	str r1, [r2, #0x30]
	ldr r0, _021E765C ; =ov112_021FFB24
	mov r1, #0x60
	strb r1, [r0, #0x1c]
	mov r1, #0x20
	strb r1, [r0, #0x1d]
	mov r0, #0
	ldr r2, _021E7660 ; =0x00000D4C
	add r1, r0, #0
	bl ov112_021E5EC4
	ldr r0, _021E7664 ; =0x000024D8
	ldr r1, _021E765C ; =ov112_021FFB24
	strh r0, [r1, #0x3c]
	mov r0, #0
	strh r0, [r1, #0x3a]
	ldrh r2, [r1, #0x3c]
	add r2, #0x7f
	asr r0, r2, #6
	lsr r0, r0, #0x19
	add r0, r2, r0
	asr r0, r0, #7
	strh r0, [r1, #0x38]
	pop {r3, pc}
	nop
_021E7658: .word ov112_021FFAA4
_021E765C: .word ov112_021FFB24
_021E7660: .word 0x00000D4C
_021E7664: .word 0x000024D8
	thumb_func_end ov112_021E7620

	thumb_func_start ov112_021E7668
ov112_021E7668: ; 0x021E7668
	ldr r3, _021E766C ; =ov112_021E59A8
	bx r3
	.balign 4, 0
_021E766C: .word ov112_021E59A8
	thumb_func_end ov112_021E7668

	thumb_func_start ov112_021E7670
ov112_021E7670: ; 0x021E7670
	push {r3, lr}
	ldr r1, _021E7688 ; =ov112_021FFB24
	mov r0, #0xff
	ldrh r2, [r1, #0x36]
	ldrh r1, [r1, #0x34]
	mul r0, r2
	bl _s32_div_f
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r3, pc}
	nop
_021E7688: .word ov112_021FFB24
	thumb_func_end ov112_021E7670

	thumb_func_start ov112_021E768C
ov112_021E768C: ; 0x021E768C
	push {r3, lr}
	ldr r1, _021E76A4 ; =ov112_021FFB24
	mov r0, #0xff
	ldrh r2, [r1, #0x3a]
	ldrh r1, [r1, #0x38]
	mul r0, r2
	bl _s32_div_f
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r3, pc}
	nop
_021E76A4: .word ov112_021FFB24
	thumb_func_end ov112_021E768C

	thumb_func_start ov112_021E76A8
ov112_021E76A8: ; 0x021E76A8
	push {r4, lr}
	ldr r0, _021E76C8 ; =ov112_021FFAA4
	ldr r4, [r0, #0x14]
	bl ov112_021E59A8
	cmp r0, #0
	beq _021E76BC
	mov r1, #0
	ldr r0, _021E76C8 ; =ov112_021FFAA4
	b _021E76C0
_021E76BC:
	ldr r0, _021E76C8 ; =ov112_021FFAA4
	mov r1, #1
_021E76C0:
	str r1, [r0, #0x14]
	add r0, r4, #0
	pop {r4, pc}
	nop
_021E76C8: .word ov112_021FFAA4
	thumb_func_end ov112_021E76A8

	thumb_func_start ov112_021E76CC
ov112_021E76CC: ; 0x021E76CC
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r0, #1
	lsl r0, r0, #0x1a
	ldr r2, [r0]
	ldr r1, _021E775C ; =0xFFFFE0FF
	ldr r3, _021E7760 ; =0x04001000
	and r2, r1
	str r2, [r0]
	ldr r2, [r3]
	add r0, #0x50
	and r1, r2
	str r1, [r3]
	mov r1, #0
	strh r1, [r0]
	add r3, #0x50
	mov r0, #0x10
	strh r1, [r3]
	bl sub_0201A728
	mov r2, #7
	mov r0, #3
	mov r1, #0x9a
	lsl r2, r2, #0x10
	bl Heap_Create
	ldr r1, _021E7764 ; =0x0001F378
	add r0, r4, #0
	mov r2, #0x9a
	bl OverlayManager_CreateAndGetData
	ldr r2, _021E7764 ; =0x0001F378
	mov r1, #0
	add r5, r0, #0
	bl memset
	add r0, r4, #0
	bl OverlayManager_GetArgs
	ldr r0, [r0, #8]
	str r0, [r5, #0x20]
	add r0, r5, #0
	bl ov112_021E795C
	mov r0, #3
	mov r1, #8
	bl SetKeyRepeatTimers
	bl sub_020210BC
	mov r0, #4
	bl sub_02021148
	add r0, r5, #0
	bl ov112_021E7768
	mov r0, #1
	bl TextFlags_SetCanABSpeedUpPrint
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021E775C: .word 0xFFFFE0FF
_021E7760: .word 0x04001000
_021E7764: .word 0x0001F378
	thumb_func_end ov112_021E76CC

	thumb_func_start ov112_021E7768
ov112_021E7768: ; 0x021E7768
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x9a
	bl BgConfig_Alloc
	str r0, [r4, #0x18]
	mov r0, #4
	mov r1, #0x9a
	bl FontID_Alloc
	add r0, r4, #0
	bl ov112_021E7C18
	bl ov112_021E79D0
	ldr r0, [r4, #0x18]
	bl ov112_021E79F0
	add r0, r4, #0
	bl ov112_021E7B18
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E9A78
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	add r0, r4, #0
	bl ov112_021EA1AC
	add r0, r4, #0
	bl ov112_021EA4F4
	mov r0, #1
	bl TextFlags_SetCanTouchSpeedUpPrint
	add r0, r4, #0
	bl ov112_021E9C98
	ldr r0, _021E77D8 ; =ov112_021E79A8
	add r1, r4, #0
	bl Main_SetVBlankIntrCB
	ldr r2, _021E77DC ; =0x04000304
	ldr r0, _021E77E0 ; =0xFFFF7FFF
	ldrh r1, [r2]
	and r0, r1
	strh r0, [r2]
	mov r0, #4
	mov r1, #1
	bl ToggleBgLayer
	pop {r4, pc}
	nop
_021E77D8: .word ov112_021E79A8
_021E77DC: .word 0x04000304
_021E77E0: .word 0xFFFF7FFF
	thumb_func_end ov112_021E7768

	thumb_func_start ov112_021E77E4
ov112_021E77E4: ; 0x021E77E4
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021EA1F8
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E9C10
	ldr r0, [r4, #0x18]
	bl ov112_021E7AC8
	bl sub_02021238
	bl GF_DestroyVramTransferManager
	add r0, r4, #0
	bl ov112_021E9E30
	add r0, r4, #0
	bl ov112_021E7C6C
	mov r0, #4
	bl FontID_Release
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	ldr r0, _021E782C ; =0x0001E52C
	mov r1, #0
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_021E782C: .word 0x0001E52C
	thumb_func_end ov112_021E77E4

	thumb_func_start ov112_021E7830
ov112_021E7830: ; 0x021E7830
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r1, #0
	bl OverlayManager_GetData
	ldr r1, [r5]
	add r4, r0, #0
	cmp r1, #4
	bhi _021E78E4
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E784E: ; jump table
	.short _021E7858 - _021E784E - 2 ; case 0
	.short _021E7866 - _021E784E - 2 ; case 1
	.short _021E7878 - _021E784E - 2 ; case 2
	.short _021E7898 - _021E784E - 2 ; case 3
	.short _021E78D6 - _021E784E - 2 ; case 4
_021E7858:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021E78E4
	mov r0, #1
	str r0, [r5]
	b _021E78E4
_021E7866:
	ldr r2, [r4]
	mov r1, #0xc
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021E78F8 ; =ov112_021FF54C
	ldr r1, [r1, r3]
	blx r1
	str r0, [r5]
	b _021E78E4
_021E7878:
	ldr r2, [r4]
	mov r1, #0xc
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021E78FC ; =ov112_021FF550
	ldr r1, [r1, r3]
	blx r1
	str r0, [r5]
	ldr r3, _021E7900 ; =0x0001F2E0
	ldr r0, [r4, #0x18]
	ldrh r3, [r4, r3]
	mov r1, #5
	mov r2, #0
	bl BgSetPosTextAndCommit
	b _021E78E4
_021E7898:
	ldr r2, [r4]
	mov r1, #0xc
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021E7904 ; =ov112_021FF554
	ldr r1, [r1, r3]
	blx r1
	str r0, [r5]
	ldr r0, [r4, #4]
	cmp r0, #0xb
	bne _021E78CC
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	ldr r3, _021E7908 ; =0x00007FFF
	add r1, r0, #0
	add r2, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #4
	str r0, [r5]
	b _021E78E4
_021E78CC:
	str r0, [r4]
	add r0, r4, #0
	bl ov112_021E9C94
	b _021E78E4
_021E78D6:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021E78E4
	add sp, #0xc
	mov r0, #1
	pop {r4, r5, pc}
_021E78E4:
	ldr r0, _021E790C ; =0x0001E52C
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E78F0
	bl SpriteSystem_DrawSprites
_021E78F0:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_021E78F8: .word ov112_021FF54C
_021E78FC: .word ov112_021FF550
_021E7900: .word 0x0001F2E0
_021E7904: .word ov112_021FF554
_021E7908: .word 0x00007FFF
_021E790C: .word 0x0001E52C
	thumb_func_end ov112_021E7830

	thumb_func_start ov112_021E7910
ov112_021E7910: ; 0x021E7910
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	mov r0, #0
	bl TextFlags_SetCanABSpeedUpPrint
	mov r0, #0
	bl TextFlags_SetCanTouchSpeedUpPrint
	add r0, r4, #0
	bl ov112_021E77E4
	add r0, r5, #0
	bl OverlayManager_FreeData
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	mov r0, #0x9a
	bl Heap_Destroy
	mov r0, #0x10
	bl sub_0201A738
	ldr r0, _021E7954 ; =FS_OVERLAY_ID(intro_title)
	ldr r1, _021E7958 ; =gApplication_TitleScreen
	bl RegisterMainOverlay
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021E7954: .word FS_OVERLAY_ID(intro_title)
_021E7958: .word gApplication_TitleScreen
	thumb_func_end ov112_021E7910

	thumb_func_start ov112_021E795C
ov112_021E795C: ; 0x021E795C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x20]
	bl Save_Bag_Get
	ldr r1, _021E7994 ; =0x0001E434
	str r0, [r4, r1]
	ldr r0, [r4, #0x20]
	bl Save_PlayerData_GetProfile
	ldr r1, _021E7998 ; =0x0001E438
	str r0, [r4, r1]
	ldr r0, [r4, #0x20]
	bl Save_PlayerData_GetOptionsAddr
	ldr r1, _021E799C ; =0x0001E43C
	str r0, [r4, r1]
	ldr r0, [r4, #0x20]
	bl Save_Pokewalker_Get
	ldr r1, _021E79A0 ; =0x0001E440
	str r0, [r4, r1]
	ldr r0, [r4, #0x20]
	bl Save_Pokedex_Get
	ldr r1, _021E79A4 ; =0x0001E444
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021E7994: .word 0x0001E434
_021E7998: .word 0x0001E438
_021E799C: .word 0x0001E43C
_021E79A0: .word 0x0001E440
_021E79A4: .word 0x0001E444
	thumb_func_end ov112_021E795C

	thumb_func_start ov112_021E79A8
ov112_021E79A8: ; 0x021E79A8
	push {r3, lr}
	ldr r0, [r0, #0x18]
	bl DoScheduledBgGpuUpdates
	bl GF_RunVramTransferTasks
	bl SpriteSystem_TransferOam
	ldr r3, _021E79C8 ; =0x027E0000
	ldr r1, _021E79CC ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r3, pc}
	nop
_021E79C8: .word 0x027E0000
_021E79CC: .word 0x00003FF8
	thumb_func_end ov112_021E79A8

	thumb_func_start ov112_021E79D0
ov112_021E79D0: ; 0x021E79D0
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _021E79EC ; =ov112_021F36DC
	add r3, sp, #0
	mov r2, #5
_021E79DA:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021E79DA
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_021E79EC: .word ov112_021F36DC
	thumb_func_end ov112_021E79D0

	thumb_func_start ov112_021E79F0
ov112_021E79F0: ; 0x021E79F0
	push {r3, r4, r5, lr}
	sub sp, #0x10
	ldr r5, _021E7AAC ; =ov112_021F3684
	add r3, sp, #0
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r2, _021E7AB0 ; =ov112_021F3704
	add r0, r4, #0
	mov r1, #1
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021E7AB4 ; =ov112_021F3720
	add r0, r4, #0
	mov r1, #2
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021E7AB8 ; =ov112_021F373C
	add r0, r4, #0
	mov r1, #3
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r2, _021E7ABC ; =ov112_021F3758
	add r0, r4, #0
	mov r1, #4
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021E7AC0 ; =ov112_021F3774
	add r0, r4, #0
	mov r1, #5
	mov r3, #0
	bl InitBgFromTemplate
	ldr r2, _021E7AC4 ; =ov112_021F3790
	add r0, r4, #0
	mov r1, #6
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x9a
	bl BG_ClearCharDataRange
	mov r0, #5
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x9a
	bl BG_ClearCharDataRange
	mov r0, #6
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x9a
	bl BG_ClearCharDataRange
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021E7AAC: .word ov112_021F3684
_021E7AB0: .word ov112_021F3704
_021E7AB4: .word ov112_021F3720
_021E7AB8: .word ov112_021F373C
_021E7ABC: .word ov112_021F3758
_021E7AC0: .word ov112_021F3774
_021E7AC4: .word ov112_021F3790
	thumb_func_end ov112_021E79F0

	thumb_func_start ov112_021E7AC8
ov112_021E7AC8: ; 0x021E7AC8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x1b
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #6
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #3
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #2
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #1
	bl FreeBgTilemapBuffer
	mov r0, #0x9a
	add r1, r4, #0
	bl Heap_FreeExplicit
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021E7AC8

	thumb_func_start ov112_021E7B18
ov112_021E7B18: ; 0x021E7B18
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0xf9
	mov r1, #0x9a
	bl NARC_New
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	mov r1, #1
	str r1, [sp, #8]
	mov r1, #0x9a
	str r1, [sp, #0xc]
	ldr r2, [r5, #0x18]
	mov r1, #4
	mov r3, #3
	add r4, r0, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x9a
	str r0, [sp, #0xc]
	ldr r2, [r5, #0x18]
	add r0, r4, #0
	mov r1, #8
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r1, #0
	str r1, [sp]
	mov r0, #0x9a
	str r0, [sp, #4]
	add r0, r4, #0
	add r2, r1, #0
	add r3, r1, #0
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r1, #7
	mov r0, #0
	lsl r1, r1, #6
	mov r2, #0x9a
	bl LoadFontPal1
	ldr r0, _021E7C10 ; =0x0001E43C
	ldr r0, [r5, r0]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x9a
	str r0, [sp, #4]
	ldr r0, [r5, #0x18]
	ldr r2, _021E7C14 ; =0x000003E2
	mov r1, #1
	mov r3, #0xd
	bl LoadUserFrameGfx2
	mov r3, #0
	str r3, [sp]
	mov r0, #0x9a
	str r0, [sp, #4]
	add r0, r4, #0
	mov r1, #1
	mov r2, #4
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r1, #7
	mov r0, #4
	lsl r1, r1, #6
	mov r2, #0x9a
	bl LoadFontPal1
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x9a
	str r0, [sp, #0xc]
	ldr r2, [r5, #0x18]
	add r0, r4, #0
	mov r1, #5
	mov r3, #6
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x9a
	str r0, [sp, #0xc]
	ldr r2, [r5, #0x18]
	add r0, r4, #0
	mov r1, #9
	mov r3, #6
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, _021E7C10 ; =0x0001E43C
	ldr r0, [r5, r0]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x9a
	str r0, [sp, #4]
	ldr r0, [r5, #0x18]
	ldr r2, _021E7C14 ; =0x000003E2
	mov r1, #4
	mov r3, #0xd
	bl LoadUserFrameGfx2
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E7C10: .word 0x0001E43C
_021E7C14: .word 0x000003E2
	thumb_func_end ov112_021E7B18

	thumb_func_start ov112_021E7C18
ov112_021E7C18: ; 0x021E7C18
	push {r4, lr}
	mov r1, #0x1b
	add r2, r1, #0
	add r4, r0, #0
	mov r0, #0
	add r2, #0xf7
	mov r3, #0x9a
	bl NewMsgDataFromNarc
	ldr r1, _021E7C5C ; =0x0001E44C
	mov r2, #0xde
	str r0, [r4, r1]
	mov r0, #1
	mov r1, #0x1b
	mov r3, #0x9a
	bl NewMsgDataFromNarc
	ldr r1, _021E7C60 ; =0x0001E450
	mov r2, #0x9a
	str r0, [r4, r1]
	mov r0, #0x10
	mov r1, #0x20
	bl MessageFormat_New_Custom
	ldr r1, _021E7C64 ; =0x0001E448
	str r0, [r4, r1]
	mov r0, #0x19
	lsl r0, r0, #4
	mov r1, #0x9a
	bl String_New
	ldr r1, _021E7C68 ; =0x0001E454
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021E7C5C: .word 0x0001E44C
_021E7C60: .word 0x0001E450
_021E7C64: .word 0x0001E448
_021E7C68: .word 0x0001E454
	thumb_func_end ov112_021E7C18

	thumb_func_start ov112_021E7C6C
ov112_021E7C6C: ; 0x021E7C6C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E7C94 ; =0x0001E454
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E7C98 ; =0x0001E450
	ldr r0, [r4, r0]
	bl DestroyMsgData
	ldr r0, _021E7C9C ; =0x0001E44C
	ldr r0, [r4, r0]
	bl DestroyMsgData
	ldr r0, _021E7CA0 ; =0x0001E448
	ldr r0, [r4, r0]
	bl MessageFormat_Delete
	pop {r4, pc}
	nop
_021E7C94: .word 0x0001E454
_021E7C98: .word 0x0001E450
_021E7C9C: .word 0x0001E44C
_021E7CA0: .word 0x0001E448
	thumb_func_end ov112_021E7C6C

	thumb_func_start ov112_021E7CA4
ov112_021E7CA4: ; 0x021E7CA4
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x9a
	str r0, [sp, #0xc]
	add r3, r1, #0
	add r1, r2, #0
	ldr r2, [r4, #0x18]
	mov r0, #0xf9
	bl GfGfxLoader_LoadScrnData
	add sp, #0x10
	pop {r4, pc}
	thumb_func_end ov112_021E7CA4

	thumb_func_start ov112_021E7CC8
ov112_021E7CC8: ; 0x021E7CC8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x20]
	bl Save_PlayerData_GetProfile
	mov r1, #0x9a
	bl PlayerProfile_GetPlayerName_NewString
	add r4, r0, #0
	ldr r1, _021E7D60 ; =0x00001024
	mov r0, #1
	str r0, [r5, r1]
	add r0, r1, #0
	mov r2, #GAME_VERSION
	add r0, #8
	strh r2, [r5, r0]
	add r0, r1, #0
	add r0, #0x5b
	ldrb r2, [r5, r0]
	mov r0, #1
	bic r2, r0
	add r0, r1, #0
	add r0, #0x5b
	strb r2, [r5, r0]
	mov r0, #0
	add r1, #0x5a
	strb r0, [r5, r1]
	ldr r0, _021E7D64 ; =0x0001E438
	ldr r0, [r5, r0]
	bl PlayerProfile_GetTrainerID
	ldr r1, _021E7D68 ; =0x00001030
	mov r2, #8
	str r0, [r5, r1]
	add r1, #0x3c
	add r0, r4, #0
	add r1, r5, r1
	bl CopyStringToU16Array
	ldr r0, _021E7D6C ; =0x00001028
	mov r1, #1
	str r1, [r5, r0]
	mov r1, #GAME_VERSION
	add r0, r0, #6
	strh r1, [r5, r0]
	ldr r0, _021E7D70 ; =0x0001E440
	ldr r0, [r5, r0]
	bl sub_02032728
	ldr r1, _021E7D74 ; =0x00001034
	mov r2, #0x28
	add r1, r5, r1
	bl MIi_CpuCopyFast
	add r0, r5, #0
	mov r1, #1
	add r0, #0x24
	lsl r1, r1, #0xc
	mov r2, #0xf
	bl ov112_021E73C8
	ldr r1, _021E7D60 ; =0x00001024
	add r0, r5, r1
	add r1, #0x68
	add r1, r5, r1
	bl ov112_021E5EB8
	ldr r0, _021E7D78 ; =0x00010834
	add r0, r5, r0
	bl ov112_021E5D68
	add r0, r4, #0
	bl String_Delete
	pop {r3, r4, r5, pc}
	nop
_021E7D60: .word 0x00001024
_021E7D64: .word 0x0001E438
_021E7D68: .word 0x00001030
_021E7D6C: .word 0x00001028
_021E7D70: .word 0x0001E440
_021E7D74: .word 0x00001034
_021E7D78: .word 0x00010834
	thumb_func_end ov112_021E7CC8

	thumb_func_start ov112_021E7D7C
ov112_021E7D7C: ; 0x021E7D7C
	push {r4, lr}
	ldr r1, _021E7D9C ; =0x000010F4
	add r4, r0, #0
	add r1, r4, r1
	bl ov112_021E7DFC
	ldr r0, _021E7DA0 ; =0x0000C910
	add r1, r4, #0
	add r0, r4, r0
	bl ov112_021E8CB8
	add r0, r4, #0
	bl ov112_021E7DC0
	pop {r4, pc}
	nop
_021E7D9C: .word 0x000010F4
_021E7DA0: .word 0x0000C910
	thumb_func_end ov112_021E7D7C

	thumb_func_start ov112_021E7DA4
ov112_021E7DA4: ; 0x021E7DA4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E7DBC ; =0x0000C910
	add r1, r4, #0
	add r0, r4, r0
	bl ov112_021E8CB8
	add r0, r4, #0
	bl ov112_021E7DC0
	pop {r4, pc}
	nop
_021E7DBC: .word 0x0000C910
	thumb_func_end ov112_021E7DA4

	thumb_func_start ov112_021E7DC0
ov112_021E7DC0: ; 0x021E7DC0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0xf2
	lsl r1, r1, #8
	ldr r0, [r4, #0x20]
	add r1, r4, r1
	bl ov112_021F3244
	ldr r0, _021E7DF0 ; =0x0000F1D0
	mov r1, #1
	str r1, [r4, r0]
	mov r1, #GAME_VERSION
	add r0, r0, #4
	strh r1, [r4, r0]
	ldr r0, _021E7DF4 ; =0x0001E440
	ldr r0, [r4, r0]
	bl sub_02032728
	ldr r1, _021E7DF8 ; =0x0000F1D8
	mov r2, #0x28
	add r1, r4, r1
	bl MIi_CpuCopyFast
	pop {r4, pc}
	.balign 4, 0
_021E7DF0: .word 0x0000F1D0
_021E7DF4: .word 0x0001E440
_021E7DF8: .word 0x0000F1D8
	thumb_func_end ov112_021E7DC0

	thumb_func_start ov112_021E7DFC
ov112_021E7DFC: ; 0x021E7DFC
	push {r3, r4, r5, r6, lr}
	sub sp, #0x24
	add r5, r0, #0
	mov r0, #0x9a
	add r4, r1, #0
	add r1, r0, #0
	add r1, #0xe6
	bl Heap_Alloc
	mov r3, #0
	add r6, r0, #0
	str r3, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	str r3, [sp, #0x10]
	ldr r0, [r5, #0x18]
	add r1, sp, #0x14
	mov r2, #1
	bl AddWindowParameterized
	add r0, sp, #0x14
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _021E81D4 ; =ov112_021F5758
	add r1, r4, #0
	mov r2, #0x20
	bl MI_CpuCopy8
	add r1, r4, #0
	ldr r0, _021E81D8 ; =ov112_021F5858
	add r1, #0x20
	mov r2, #0x20
	bl MI_CpuCopy8
	add r1, r4, #0
	ldr r0, _021E81DC ; =ov112_021F5778
	add r1, #0x40
	mov r2, #0x20
	bl MI_CpuCopy8
	add r1, r4, #0
	ldr r0, _021E81E0 ; =ov112_021F5918
	add r1, #0x60
	mov r2, #0x20
	bl MI_CpuCopy8
	add r1, r4, #0
	ldr r0, _021E81E4 ; =ov112_021F5838
	add r1, #0x80
	mov r2, #0x20
	bl MI_CpuCopy8
	add r1, r4, #0
	ldr r0, _021E81E8 ; =ov112_021F5978
	add r1, #0xa0
	mov r2, #0x20
	bl MI_CpuCopy8
	add r1, r4, #0
	ldr r0, _021E81EC ; =ov112_021F5798
	add r1, #0xc0
	mov r2, #0x20
	bl MI_CpuCopy8
	add r1, r4, #0
	ldr r0, _021E81F0 ; =ov112_021F5878
	add r1, #0xe0
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #1
	lsl r1, r1, #8
	ldr r0, _021E81F4 ; =ov112_021F57B8
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r0, _021E81F8 ; =ov112_021F58B8
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #5
	lsl r1, r1, #6
	ldr r0, _021E81FC ; =ov112_021F5818
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #0x16
	lsl r1, r1, #4
	ldr r0, _021E8200 ; =ov112_021F5938
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #6
	lsl r1, r1, #6
	ldr r0, _021E8204 ; =ov112_021F57F8
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #0x1a
	lsl r1, r1, #4
	ldr r0, _021E8208 ; =ov112_021F5998
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	mov r1, #0x9e
	lsl r1, r1, #2
	ldr r0, _021E820C ; =ov112_021F56C8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xa2
	lsl r1, r1, #2
	ldr r0, _021E8210 ; =ov112_021F5718
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xa6
	lsl r1, r1, #2
	ldr r0, _021E8214 ; =ov112_021F55F8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xaa
	lsl r1, r1, #2
	ldr r0, _021E8218 ; =ov112_021F5698
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xae
	lsl r1, r1, #2
	ldr r0, _021E821C ; =ov112_021F5598
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xb2
	lsl r1, r1, #2
	ldr r0, _021E8220 ; =ov112_021F55E8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xb6
	lsl r1, r1, #2
	ldr r0, _021E8224 ; =ov112_021F55D8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xba
	lsl r1, r1, #2
	ldr r0, _021E8228 ; =ov112_021F5688
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xbe
	lsl r1, r1, #2
	ldr r0, _021E822C ; =ov112_021F55C8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xc2
	lsl r1, r1, #2
	ldr r0, _021E8230 ; =ov112_021F56B8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xc6
	lsl r1, r1, #2
	ldr r0, _021E8234 ; =ov112_021F5588
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xca
	lsl r1, r1, #2
	ldr r0, _021E8238 ; =ov112_021F55A8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xce
	lsl r1, r1, #2
	ldr r0, _021E823C ; =ov112_021F5898
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #0xd6
	lsl r1, r1, #2
	ldr r0, _021E8240 ; =ov112_021F58D8
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #0xde
	lsl r1, r1, #2
	ldr r0, _021E8244 ; =ov112_021F58F8
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	mov r1, #0xee
	lsl r1, r1, #2
	ldr r0, _021E8248 ; =ov112_021F5668
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xf2
	lsl r1, r1, #2
	ldr r0, _021E824C ; =ov112_021F5638
	add r1, r4, r1
	mov r2, #8
	bl MI_CpuCopy8
	mov r1, #0x1e
	lsl r1, r1, #4
	ldr r0, _021E8250 ; =ov112_021F56F8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x1f
	lsl r1, r1, #4
	ldr r0, _021E8254 ; =ov112_021F5628
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x82
	lsl r1, r1, #2
	ldr r0, _021E8258 ; =ov112_021F5648
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x86
	lsl r1, r1, #2
	ldr r0, _021E825C ; =ov112_021F5748
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x8a
	lsl r1, r1, #2
	ldr r0, _021E8260 ; =ov112_021F5678
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x8e
	lsl r1, r1, #2
	ldr r0, _021E8264 ; =ov112_021F56D8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x92
	lsl r1, r1, #2
	ldr r0, _021E8268 ; =ov112_021F55B8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x96
	lsl r1, r1, #2
	ldr r0, _021E826C ; =ov112_021F5608
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x9a
	lsl r1, r1, #2
	ldr r0, _021E8270 ; =ov112_021F56E8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x3d
	lsl r1, r1, #4
	ldr r0, _021E8274 ; =ov112_021F5618
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x3e
	lsl r1, r1, #4
	ldr r0, _021E8278 ; =ov112_021F56A8
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0xe1
	lsl r1, r1, #4
	ldr r0, _021E827C ; =ov112_021F5B98
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	mov r1, #0xe5
	lsl r1, r1, #4
	ldr r0, _021E8280 ; =ov112_021F5CD8
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	mov r1, #0xe9
	lsl r1, r1, #4
	ldr r0, _021E8284 ; =ov112_021F5BD8
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	mov r1, #0xed
	lsl r1, r1, #4
	ldr r0, _021E8288 ; =ov112_021F5A18
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	mov r1, #0xf1
	lsl r1, r1, #4
	ldr r0, _021E828C ; =ov112_021F5C98
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	mov r1, #0xf5
	lsl r1, r1, #4
	ldr r0, _021E8290 ; =ov112_021F5AD8
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	mov r1, #0x69
	lsl r1, r1, #4
	mov r2, #5
	ldr r0, _021E8294 ; =ov112_021F7418
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r1, #0x7d
	lsl r1, r1, #4
	mov r2, #5
	ldr r0, _021E8298 ; =ov112_021F7558
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r1, #0x91
	lsl r1, r1, #4
	mov r2, #5
	ldr r0, _021E829C ; =ov112_021F7698
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r1, #0xa5
	lsl r1, r1, #4
	mov r2, #5
	ldr r0, _021E82A0 ; =ov112_021F77D8
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r1, #0xb9
	lsl r1, r1, #4
	mov r2, #5
	ldr r0, _021E82A4 ; =ov112_021F7918
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r1, #0xcd
	lsl r1, r1, #4
	mov r2, #5
	ldr r0, _021E82A8 ; =ov112_021F7A58
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E82AC ; =0x000018D0
	ldr r0, _021E82B0 ; =ov112_021F5C58
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E82B4 ; =0x00001910
	ldr r0, _021E82B8 ; =ov112_021F59D8
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E82BC ; =0x00001950
	ldr r0, _021E82C0 ; =ov112_021F6178
	add r1, r4, r1
	mov r2, #0x80
	bl MI_CpuCopy8
	ldr r1, _021E82C4 ; =0x000019D0
	ldr r0, _021E82C8 ; =ov112_021F5E18
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	ldr r1, _021E82CC ; =0x00001A30
	ldr r0, _021E82D0 ; =ov112_021F6DD8
	add r1, r4, r1
	mov r2, #0xc0
	bl MI_CpuCopy8
	ldr r1, _021E82D4 ; =0x00001AF0
	ldr r0, _021E82D8 ; =ov112_021F5A58
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E82DC ; =0x00001B30
	ldr r0, _021E82E0 ; =ov112_021F5A98
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E82E4 ; =0x00001B70
	ldr r0, _021E82E8 ; =ov112_021F5B18
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E82EC ; =0x00001BB0
	ldr r0, _021E82F0 ; =ov112_021F5B58
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E82F4 ; =0x00001BF0
	ldr r0, _021E82F8 ; =ov112_021F62F8
	add r1, r4, r1
	mov r2, #0x80
	bl MI_CpuCopy8
	ldr r1, _021E82FC ; =0x00001C70
	ldr r0, _021E8300 ; =ov112_021F6378
	add r1, r4, r1
	mov r2, #0x80
	bl MI_CpuCopy8
	ldr r1, _021E8304 ; =0x00001CF0
	ldr r0, _021E8308 ; =ov112_021F6718
	add r1, r4, r1
	mov r2, #0xc0
	bl MI_CpuCopy8
	ldr r1, _021E830C ; =0x00001DB0
	ldr r0, _021E8310 ; =ov112_021F5738
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	mov r1, #0x77
	lsl r1, r1, #6
	ldr r0, _021E8314 ; =ov112_021F5708
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	ldr r1, _021E8318 ; =0x00001DD0
	mov r2, #3
	ldr r0, _021E831C ; =ov112_021FE198
	b _021E8320
	nop
_021E81D4: .word ov112_021F5758
_021E81D8: .word ov112_021F5858
_021E81DC: .word ov112_021F5778
_021E81E0: .word ov112_021F5918
_021E81E4: .word ov112_021F5838
_021E81E8: .word ov112_021F5978
_021E81EC: .word ov112_021F5798
_021E81F0: .word ov112_021F5878
_021E81F4: .word ov112_021F57B8
_021E81F8: .word ov112_021F58B8
_021E81FC: .word ov112_021F5818
_021E8200: .word ov112_021F5938
_021E8204: .word ov112_021F57F8
_021E8208: .word ov112_021F5998
_021E820C: .word ov112_021F56C8
_021E8210: .word ov112_021F5718
_021E8214: .word ov112_021F55F8
_021E8218: .word ov112_021F5698
_021E821C: .word ov112_021F5598
_021E8220: .word ov112_021F55E8
_021E8224: .word ov112_021F55D8
_021E8228: .word ov112_021F5688
_021E822C: .word ov112_021F55C8
_021E8230: .word ov112_021F56B8
_021E8234: .word ov112_021F5588
_021E8238: .word ov112_021F55A8
_021E823C: .word ov112_021F5898
_021E8240: .word ov112_021F58D8
_021E8244: .word ov112_021F58F8
_021E8248: .word ov112_021F5668
_021E824C: .word ov112_021F5638
_021E8250: .word ov112_021F56F8
_021E8254: .word ov112_021F5628
_021E8258: .word ov112_021F5648
_021E825C: .word ov112_021F5748
_021E8260: .word ov112_021F5678
_021E8264: .word ov112_021F56D8
_021E8268: .word ov112_021F55B8
_021E826C: .word ov112_021F5608
_021E8270: .word ov112_021F56E8
_021E8274: .word ov112_021F5618
_021E8278: .word ov112_021F56A8
_021E827C: .word ov112_021F5B98
_021E8280: .word ov112_021F5CD8
_021E8284: .word ov112_021F5BD8
_021E8288: .word ov112_021F5A18
_021E828C: .word ov112_021F5C98
_021E8290: .word ov112_021F5AD8
_021E8294: .word ov112_021F7418
_021E8298: .word ov112_021F7558
_021E829C: .word ov112_021F7698
_021E82A0: .word ov112_021F77D8
_021E82A4: .word ov112_021F7918
_021E82A8: .word ov112_021F7A58
_021E82AC: .word 0x000018D0
_021E82B0: .word ov112_021F5C58
_021E82B4: .word 0x00001910
_021E82B8: .word ov112_021F59D8
_021E82BC: .word 0x00001950
_021E82C0: .word ov112_021F6178
_021E82C4: .word 0x000019D0
_021E82C8: .word ov112_021F5E18
_021E82CC: .word 0x00001A30
_021E82D0: .word ov112_021F6DD8
_021E82D4: .word 0x00001AF0
_021E82D8: .word ov112_021F5A58
_021E82DC: .word 0x00001B30
_021E82E0: .word ov112_021F5A98
_021E82E4: .word 0x00001B70
_021E82E8: .word ov112_021F5B18
_021E82EC: .word 0x00001BB0
_021E82F0: .word ov112_021F5B58
_021E82F4: .word 0x00001BF0
_021E82F8: .word ov112_021F62F8
_021E82FC: .word 0x00001C70
_021E8300: .word ov112_021F6378
_021E8304: .word 0x00001CF0
_021E8308: .word ov112_021F6718
_021E830C: .word 0x00001DB0
_021E8310: .word ov112_021F5738
_021E8314: .word ov112_021F5708
_021E8318: .word 0x00001DD0
_021E831C: .word ov112_021FE198
_021E8320:
	add r1, r4, r1
	lsl r2, r2, #8
	bl MI_CpuCopy8
	mov r1, #0xf9
	lsl r1, r1, #4
	ldr r0, _021E86D0 ; =ov112_021F5D18
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E86D4 ; =0x00001110
	ldr r0, _021E86D8 ; =ov112_021F5C18
	add r1, r4, r1
	mov r2, #0x40
	bl MI_CpuCopy8
	ldr r1, _021E86DC ; =0x00001150
	ldr r0, _021E86E0 ; =ov112_021F65D8
	add r1, r4, r1
	mov r2, #0xa0
	bl MI_CpuCopy8
	ldr r1, _021E86E4 ; =0x000011F0
	ldr r0, _021E86E8 ; =ov112_021F61F8
	add r1, r4, r1
	mov r2, #0x80
	bl MI_CpuCopy8
	ldr r1, _021E86EC ; =0x00001270
	ldr r0, _021E86F0 ; =ov112_021F6278
	add r1, r4, r1
	mov r2, #0x80
	bl MI_CpuCopy8
	ldr r1, _021E86EC ; =0x00001270
	ldr r0, _021E86F4 ; =ov112_021F6538
	add r1, r4, r1
	mov r2, #0xa0
	bl MI_CpuCopy8
	ldr r1, _021E86F8 ; =0x00001310
	mov r2, #1
	ldr r0, _021E86FC ; =ov112_021F70D8
	add r1, r4, r1
	lsl r2, r2, #8
	bl MI_CpuCopy8
	add r0, sp, #0x14
	add r1, r5, #0
	bl ov112_021E90FC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x50
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x20]
	mov r1, #0xa
	mov r2, #2
	add r3, r6, #0
	bl ov112_021E93BC
	mov r1, #0xfd
	lsl r1, r1, #4
	mov r2, #5
	add r0, r6, #0
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8700 ; =0x00001690
	ldr r0, _021E8704 ; =ov112_021F67D8
	add r1, r4, r1
	mov r2, #0xc0
	bl MI_CpuCopy8
	ldr r1, _021E8708 ; =0x00001750
	ldr r0, _021E870C ; =ov112_021F6898
	add r1, r4, r1
	mov r2, #0xc0
	bl MI_CpuCopy8
	ldr r1, _021E8710 ; =0x00001810
	ldr r0, _021E8714 ; =ov112_021F7018
	add r1, r4, r1
	mov r2, #0xc0
	bl MI_CpuCopy8
	ldr r1, _021E8718 ; =0x00001410
	ldr r0, _021E871C ; =ov112_021F6498
	add r1, r4, r1
	mov r2, #0xa0
	bl MI_CpuCopy8
	ldr r1, _021E8720 ; =0x000014B0
	ldr r0, _021E8724 ; =ov112_021F63F8
	add r1, r4, r1
	mov r2, #0xa0
	bl MI_CpuCopy8
	ldr r1, _021E8728 ; =0x00001670
	ldr r0, _021E872C ; =ov112_021F57D8
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	ldr r1, _021E8730 ; =0x000015B0
	ldr r0, _021E8734 ; =ov112_021F5DB8
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	ldr r1, _021E8738 ; =0x00001610
	ldr r0, _021E873C ; =ov112_021F6058
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	ldr r1, _021E8740 ; =0x00001550
	ldr r0, _021E8744 ; =ov112_021F5D58
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	ldr r1, _021E8748 ; =0x000020D0
	mov r2, #1
	ldr r0, _021E874C ; =ov112_021F71D8
	add r1, r4, r1
	lsl r2, r2, #8
	bl MI_CpuCopy8
	ldr r1, _021E8750 ; =0x000021D0
	ldr r0, _021E8754 ; =ov112_021F5958
	add r1, r4, r1
	mov r2, #0x20
	bl MI_CpuCopy8
	ldr r1, _021E8758 ; =0x000021F0
	ldr r0, _021E875C ; =ov112_021F5658
	add r1, r4, r1
	mov r2, #0x10
	bl MI_CpuCopy8
	ldr r1, _021E8760 ; =0x000022B0
	mov r2, #6
	ldr r0, _021E8764 ; =ov112_021FCF98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8768 ; =0x00002430
	mov r2, #6
	ldr r0, _021E876C ; =ov112_021F8198
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8770 ; =0x000025B0
	mov r2, #6
	ldr r0, _021E8774 ; =ov112_021F8318
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8778 ; =0x00002730
	mov r2, #6
	ldr r0, _021E877C ; =ov112_021F8498
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8780 ; =0x000028B0
	mov r2, #6
	ldr r0, _021E8784 ; =ov112_021FC998
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8788 ; =0x00002A30
	mov r2, #6
	ldr r0, _021E878C ; =ov112_021F8618
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8790 ; =0x00002BB0
	mov r2, #6
	ldr r0, _021E8794 ; =ov112_021F8798
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8798 ; =0x00002D30
	mov r2, #6
	ldr r0, _021E879C ; =ov112_021F8918
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87A0 ; =0x00002EB0
	mov r2, #6
	ldr r0, _021E87A4 ; =ov112_021FC398
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87A8 ; =0x00003030
	mov r2, #6
	ldr r0, _021E87AC ; =ov112_021F8A98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87B0 ; =0x000031B0
	mov r2, #6
	ldr r0, _021E87B4 ; =ov112_021F8C18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87B8 ; =0x00003330
	mov r2, #6
	ldr r0, _021E87BC ; =ov112_021F8D98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87C0 ; =0x000034B0
	mov r2, #6
	ldr r0, _021E87C4 ; =ov112_021F8F18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87C8 ; =0x00003630
	mov r2, #6
	ldr r0, _021E87CC ; =ov112_021F9098
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87D0 ; =0x000037B0
	mov r2, #6
	ldr r0, _021E87D4 ; =ov112_021F9218
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87D8 ; =0x00003930
	mov r2, #6
	ldr r0, _021E87DC ; =ov112_021F9398
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87E0 ; =0x00003AB0
	mov r2, #6
	ldr r0, _021E87E4 ; =ov112_021FB798
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87E8 ; =0x00003C30
	mov r2, #6
	ldr r0, _021E87EC ; =ov112_021F9518
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87F0 ; =0x00003DB0
	mov r2, #6
	ldr r0, _021E87F4 ; =ov112_021F9698
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E87F8 ; =0x00003F30
	mov r2, #6
	ldr r0, _021E87FC ; =ov112_021F9818
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8800 ; =0x000040B0
	mov r2, #6
	ldr r0, _021E8804 ; =ov112_021FB198
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8808 ; =0x00004230
	mov r2, #6
	ldr r0, _021E880C ; =ov112_021F9998
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8810 ; =0x000043B0
	mov r2, #6
	ldr r0, _021E8814 ; =ov112_021F9B18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8818 ; =0x00004530
	mov r2, #6
	ldr r0, _021E881C ; =ov112_021F9C98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8820 ; =0x000046B0
	mov r2, #6
	ldr r0, _021E8824 ; =ov112_021FAB98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8828 ; =0x00004830
	mov r2, #6
	ldr r0, _021E882C ; =ov112_021F9E18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8830 ; =0x000049B0
	mov r2, #6
	ldr r0, _021E8834 ; =ov112_021F9F98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8838 ; =0x00004B30
	mov r2, #6
	ldr r0, _021E883C ; =ov112_021FA118
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8840 ; =0x00004CB0
	mov r2, #6
	ldr r0, _021E8844 ; =ov112_021FA298
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8848 ; =0x00004E30
	mov r2, #6
	ldr r0, _021E884C ; =ov112_021FA418
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8850 ; =0x00004FB0
	mov r2, #6
	ldr r0, _021E8854 ; =ov112_021FA598
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8858 ; =0x00005130
	mov r2, #6
	ldr r0, _021E885C ; =ov112_021FA718
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8860 ; =0x000052B0
	mov r2, #6
	ldr r0, _021E8864 ; =ov112_021FA898
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8868 ; =0x00005430
	mov r2, #6
	ldr r0, _021E886C ; =ov112_021FAA18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8870 ; =0x000055B0
	mov r2, #6
	ldr r0, _021E8874 ; =ov112_021FAD18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8878 ; =0x00005730
	mov r2, #6
	ldr r0, _021E887C ; =ov112_021FAE98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8880 ; =0x000058B0
	mov r2, #6
	ldr r0, _021E8884 ; =ov112_021FB018
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8888 ; =0x00005A30
	mov r2, #6
	ldr r0, _021E888C ; =ov112_021FB318
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8890 ; =0x00005BB0
	mov r2, #6
	ldr r0, _021E8894 ; =ov112_021FB498
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8898 ; =0x00005D30
	mov r2, #6
	ldr r0, _021E889C ; =ov112_021FB618
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E88A0 ; =0x00005EB0
	mov r2, #6
	ldr r0, _021E88A4 ; =ov112_021FB918
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r2, _021E88A8 ; =0x00006030
	ldr r0, _021E88AC ; =ov112_021FBA98
	add r1, r4, r2
	lsr r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E88B0 ; =0x000061B0
	mov r2, #6
	ldr r0, _021E88B4 ; =ov112_021FBC18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E88B8 ; =0x00006330
	mov r2, #6
	ldr r0, _021E88BC ; =ov112_021FBD98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E88C0 ; =0x000064B0
	mov r2, #6
	ldr r0, _021E88C4 ; =ov112_021FBF18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E88C8 ; =0x00006630
	mov r2, #6
	ldr r0, _021E88CC ; =ov112_021FC098
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E88D0 ; =0x000067B0
	mov r2, #6
	ldr r0, _021E88D4 ; =ov112_021FC218
	b _021E88D8
	nop
_021E86D0: .word ov112_021F5D18
_021E86D4: .word 0x00001110
_021E86D8: .word ov112_021F5C18
_021E86DC: .word 0x00001150
_021E86E0: .word ov112_021F65D8
_021E86E4: .word 0x000011F0
_021E86E8: .word ov112_021F61F8
_021E86EC: .word 0x00001270
_021E86F0: .word ov112_021F6278
_021E86F4: .word ov112_021F6538
_021E86F8: .word 0x00001310
_021E86FC: .word ov112_021F70D8
_021E8700: .word 0x00001690
_021E8704: .word ov112_021F67D8
_021E8708: .word 0x00001750
_021E870C: .word ov112_021F6898
_021E8710: .word 0x00001810
_021E8714: .word ov112_021F7018
_021E8718: .word 0x00001410
_021E871C: .word ov112_021F6498
_021E8720: .word 0x000014B0
_021E8724: .word ov112_021F63F8
_021E8728: .word 0x00001670
_021E872C: .word ov112_021F57D8
_021E8730: .word 0x000015B0
_021E8734: .word ov112_021F5DB8
_021E8738: .word 0x00001610
_021E873C: .word ov112_021F6058
_021E8740: .word 0x00001550
_021E8744: .word ov112_021F5D58
_021E8748: .word 0x000020D0
_021E874C: .word ov112_021F71D8
_021E8750: .word 0x000021D0
_021E8754: .word ov112_021F5958
_021E8758: .word 0x000021F0
_021E875C: .word ov112_021F5658
_021E8760: .word 0x000022B0
_021E8764: .word ov112_021FCF98
_021E8768: .word 0x00002430
_021E876C: .word ov112_021F8198
_021E8770: .word 0x000025B0
_021E8774: .word ov112_021F8318
_021E8778: .word 0x00002730
_021E877C: .word ov112_021F8498
_021E8780: .word 0x000028B0
_021E8784: .word ov112_021FC998
_021E8788: .word 0x00002A30
_021E878C: .word ov112_021F8618
_021E8790: .word 0x00002BB0
_021E8794: .word ov112_021F8798
_021E8798: .word 0x00002D30
_021E879C: .word ov112_021F8918
_021E87A0: .word 0x00002EB0
_021E87A4: .word ov112_021FC398
_021E87A8: .word 0x00003030
_021E87AC: .word ov112_021F8A98
_021E87B0: .word 0x000031B0
_021E87B4: .word ov112_021F8C18
_021E87B8: .word 0x00003330
_021E87BC: .word ov112_021F8D98
_021E87C0: .word 0x000034B0
_021E87C4: .word ov112_021F8F18
_021E87C8: .word 0x00003630
_021E87CC: .word ov112_021F9098
_021E87D0: .word 0x000037B0
_021E87D4: .word ov112_021F9218
_021E87D8: .word 0x00003930
_021E87DC: .word ov112_021F9398
_021E87E0: .word 0x00003AB0
_021E87E4: .word ov112_021FB798
_021E87E8: .word 0x00003C30
_021E87EC: .word ov112_021F9518
_021E87F0: .word 0x00003DB0
_021E87F4: .word ov112_021F9698
_021E87F8: .word 0x00003F30
_021E87FC: .word ov112_021F9818
_021E8800: .word 0x000040B0
_021E8804: .word ov112_021FB198
_021E8808: .word 0x00004230
_021E880C: .word ov112_021F9998
_021E8810: .word 0x000043B0
_021E8814: .word ov112_021F9B18
_021E8818: .word 0x00004530
_021E881C: .word ov112_021F9C98
_021E8820: .word 0x000046B0
_021E8824: .word ov112_021FAB98
_021E8828: .word 0x00004830
_021E882C: .word ov112_021F9E18
_021E8830: .word 0x000049B0
_021E8834: .word ov112_021F9F98
_021E8838: .word 0x00004B30
_021E883C: .word ov112_021FA118
_021E8840: .word 0x00004CB0
_021E8844: .word ov112_021FA298
_021E8848: .word 0x00004E30
_021E884C: .word ov112_021FA418
_021E8850: .word 0x00004FB0
_021E8854: .word ov112_021FA598
_021E8858: .word 0x00005130
_021E885C: .word ov112_021FA718
_021E8860: .word 0x000052B0
_021E8864: .word ov112_021FA898
_021E8868: .word 0x00005430
_021E886C: .word ov112_021FAA18
_021E8870: .word 0x000055B0
_021E8874: .word ov112_021FAD18
_021E8878: .word 0x00005730
_021E887C: .word ov112_021FAE98
_021E8880: .word 0x000058B0
_021E8884: .word ov112_021FB018
_021E8888: .word 0x00005A30
_021E888C: .word ov112_021FB318
_021E8890: .word 0x00005BB0
_021E8894: .word ov112_021FB498
_021E8898: .word 0x00005D30
_021E889C: .word ov112_021FB618
_021E88A0: .word 0x00005EB0
_021E88A4: .word ov112_021FB918
_021E88A8: .word 0x00006030
_021E88AC: .word ov112_021FBA98
_021E88B0: .word 0x000061B0
_021E88B4: .word ov112_021FBC18
_021E88B8: .word 0x00006330
_021E88BC: .word ov112_021FBD98
_021E88C0: .word 0x000064B0
_021E88C4: .word ov112_021FBF18
_021E88C8: .word 0x00006630
_021E88CC: .word ov112_021FC098
_021E88D0: .word 0x000067B0
_021E88D4: .word ov112_021FC218
_021E88D8:
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8A9C ; =0x00006930
	mov r2, #6
	ldr r0, _021E8AA0 ; =ov112_021FC518
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AA4 ; =0x00006AB0
	mov r2, #6
	ldr r0, _021E8AA8 ; =ov112_021FC698
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AAC ; =0x00006C30
	mov r2, #6
	ldr r0, _021E8AB0 ; =ov112_021FC818
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AB4 ; =0x00006DB0
	mov r2, #6
	ldr r0, _021E8AB8 ; =ov112_021FCB18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8ABC ; =0x00006F30
	mov r2, #6
	ldr r0, _021E8AC0 ; =ov112_021FCC98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AC4 ; =0x000070B0
	mov r2, #6
	ldr r0, _021E8AC8 ; =ov112_021FCE18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8ACC ; =0x00007230
	mov r2, #6
	ldr r0, _021E8AD0 ; =ov112_021FD118
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AD4 ; =0x000073B0
	mov r2, #6
	ldr r0, _021E8AD8 ; =ov112_021FD298
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8ADC ; =0x00007530
	mov r2, #6
	ldr r0, _021E8AE0 ; =ov112_021FD418
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AE4 ; =0x000076B0
	mov r2, #6
	ldr r0, _021E8AE8 ; =ov112_021FD598
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AEC ; =0x00007830
	mov r2, #6
	ldr r0, _021E8AF0 ; =ov112_021FD718
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AF4 ; =0x000079B0
	mov r2, #6
	ldr r0, _021E8AF8 ; =ov112_021FD898
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8AFC ; =0x00007B30
	mov r2, #6
	ldr r0, _021E8B00 ; =ov112_021FDA18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B04 ; =0x00007CB0
	mov r2, #6
	ldr r0, _021E8B08 ; =ov112_021FDB98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B0C ; =0x00007E30
	mov r2, #6
	ldr r0, _021E8B10 ; =ov112_021FDD18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B14 ; =0x00007FB0
	mov r2, #6
	ldr r0, _021E8B18 ; =ov112_021FDE98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B1C ; =0x00008130
	mov r2, #6
	ldr r0, _021E8B20 ; =ov112_021FE018
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B24 ; =0x000082B0
	mov r2, #6
	ldr r0, _021E8B28 ; =ov112_021F7B98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B2C ; =0x00008430
	mov r2, #6
	ldr r0, _021E8B30 ; =ov112_021F7D18
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B34 ; =0x000085B0
	mov r2, #6
	ldr r0, _021E8B38 ; =ov112_021F7E98
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B3C ; =0x00008730
	mov r2, #6
	ldr r0, _021E8B40 ; =ov112_021F8018
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B44 ; =0x000088B0
	mov r2, #6
	ldr r0, _021E8B48 ; =ov112_021F72D8
	add r1, r4, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r1, _021E8B4C ; =0x00002210
	ldr r0, _021E8B50 ; =ov112_021F6678
	add r1, r4, r1
	mov r2, #0xa0
	bl MI_CpuCopy8
	mov r1, #0x3f
	lsl r1, r1, #4
	ldr r0, _021E8B54 ; =ov112_021F5E78
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	mov r1, #0x45
	lsl r1, r1, #4
	ldr r0, _021E8B58 ; =ov112_021F5ED8
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	mov r1, #0x4b
	lsl r1, r1, #4
	ldr r0, _021E8B5C ; =ov112_021F5F38
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	mov r1, #0x51
	lsl r1, r1, #4
	ldr r0, _021E8B60 ; =ov112_021F5F98
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	mov r1, #0x57
	lsl r1, r1, #4
	ldr r0, _021E8B64 ; =ov112_021F5FF8
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	mov r1, #0x5d
	lsl r1, r1, #4
	ldr r0, _021E8B68 ; =ov112_021F6118
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	mov r1, #0x63
	lsl r1, r1, #4
	ldr r0, _021E8B6C ; =ov112_021F60B8
	add r1, r4, r1
	mov r2, #0x60
	bl MI_CpuCopy8
	ldr r0, _021E8B70 ; =0x00008A30
	add r0, r4, r0
	bl ov112_021F0D48
	add r0, r6, #0
	bl Heap_Free
	add r0, sp, #0x14
	bl RemoveWindow
	add sp, #0x24
	pop {r3, r4, r5, r6, pc}
	nop
_021E8A9C: .word 0x00006930
_021E8AA0: .word ov112_021FC518
_021E8AA4: .word 0x00006AB0
_021E8AA8: .word ov112_021FC698
_021E8AAC: .word 0x00006C30
_021E8AB0: .word ov112_021FC818
_021E8AB4: .word 0x00006DB0
_021E8AB8: .word ov112_021FCB18
_021E8ABC: .word 0x00006F30
_021E8AC0: .word ov112_021FCC98
_021E8AC4: .word 0x000070B0
_021E8AC8: .word ov112_021FCE18
_021E8ACC: .word 0x00007230
_021E8AD0: .word ov112_021FD118
_021E8AD4: .word 0x000073B0
_021E8AD8: .word ov112_021FD298
_021E8ADC: .word 0x00007530
_021E8AE0: .word ov112_021FD418
_021E8AE4: .word 0x000076B0
_021E8AE8: .word ov112_021FD598
_021E8AEC: .word 0x00007830
_021E8AF0: .word ov112_021FD718
_021E8AF4: .word 0x000079B0
_021E8AF8: .word ov112_021FD898
_021E8AFC: .word 0x00007B30
_021E8B00: .word ov112_021FDA18
_021E8B04: .word 0x00007CB0
_021E8B08: .word ov112_021FDB98
_021E8B0C: .word 0x00007E30
_021E8B10: .word ov112_021FDD18
_021E8B14: .word 0x00007FB0
_021E8B18: .word ov112_021FDE98
_021E8B1C: .word 0x00008130
_021E8B20: .word ov112_021FE018
_021E8B24: .word 0x000082B0
_021E8B28: .word ov112_021F7B98
_021E8B2C: .word 0x00008430
_021E8B30: .word ov112_021F7D18
_021E8B34: .word 0x000085B0
_021E8B38: .word ov112_021F7E98
_021E8B3C: .word 0x00008730
_021E8B40: .word ov112_021F8018
_021E8B44: .word 0x000088B0
_021E8B48: .word ov112_021F72D8
_021E8B4C: .word 0x00002210
_021E8B50: .word ov112_021F6678
_021E8B54: .word ov112_021F5E78
_021E8B58: .word ov112_021F5ED8
_021E8B5C: .word ov112_021F5F38
_021E8B60: .word ov112_021F5F98
_021E8B64: .word ov112_021F5FF8
_021E8B68: .word ov112_021F6118
_021E8B6C: .word ov112_021F60B8
_021E8B70: .word 0x00008A30
	thumb_func_end ov112_021E7DFC

	thumb_func_start ov112_021E8B74
ov112_021E8B74: ; 0x021E8B74
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r0, [sp, #0x30]
	str r1, [sp]
	str r0, [sp, #0x30]
	mov r0, #0xc0
	mul r0, r3
	str r2, [sp, #4]
	str r0, [sp, #0x10]
	bl GF_RTC_TimeToSec
	bl SetLCRNGSeed
	mov r7, #0
	str r7, [sp, #8]
_021E8B94:
	bl LCRandom
	lsr r2, r0, #0x1f
	lsl r1, r0, #0x1f
	sub r1, r1, r2
	mov r0, #0x1f
	ror r1, r0
	add r1, r2, r1
	ldr r0, [sp, #8]
	ldr r2, _021E8C58 ; =ov112_021F4138
	add r0, r0, r1
	ldr r1, [sp, #0x10]
	add r6, r2, r1
	mov r1, #0x14
	mul r1, r0
	add r6, #8
	str r1, [sp, #0x14]
	add r4, r6, r1
	ldr r1, [sp, #0x30]
	mov r2, #0x9a
	strb r0, [r1, r7]
	ldr r0, [sp, #0x14]
	ldrb r1, [r4, #6]
	ldrh r0, [r6, r0]
	bl AllocAndLoadMonPersonal_HandleAlternateForm
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x14]
	mov r1, #0
	ldrh r0, [r6, r0]
	add r2, r4, #0
	add r3, r5, #0
	strh r0, [r5]
	ldrh r0, [r4, #4]
	strh r0, [r5, #2]
_021E8BDA:
	ldrh r0, [r2, #8]
	add r1, r1, #1
	add r2, r2, #2
	strh r0, [r3, #4]
	add r3, r3, #2
	cmp r1, #4
	blt _021E8BDA
	ldrh r0, [r4, #2]
	mov r1, #0x1f
	strb r0, [r5, #0xc]
	ldrb r0, [r5, #0xd]
	ldrb r2, [r4, #6]
	bic r0, r1
	mov r1, #0x1f
	and r1, r2
	orr r0, r1
	strb r0, [r5, #0xd]
	ldrb r0, [r5, #0xd]
	mov r1, #0x60
	bic r0, r1
	ldrb r1, [r4, #7]
	lsl r1, r1, #0x1e
	lsr r1, r1, #0x19
	orr r0, r1
	strb r0, [r5, #0xd]
	ldrb r1, [r5, #0xd]
	mov r0, #0x80
	bic r1, r0
	strb r1, [r5, #0xd]
	ldr r0, [sp, #0xc]
	mov r1, #0x1c
	bl GetPersonalAttr
	ldrb r1, [r5, #0xe]
	mov r2, #1
	lsl r0, r0, #0x18
	bic r1, r2
	lsr r2, r0, #0x18
	mov r0, #1
	and r0, r2
	orr r0, r1
	strb r0, [r5, #0xe]
	ldrh r1, [r4, #0x10]
	ldr r0, [sp]
	strh r1, [r0]
	ldrh r1, [r4, #0x12]
	ldr r0, [sp, #4]
	strb r1, [r0, r7]
	ldr r0, [sp, #0xc]
	bl FreeMonPersonal
	ldr r0, [sp, #8]
	add r7, r7, #1
	add r0, r0, #2
	str r0, [sp, #8]
	ldr r0, [sp]
	add r5, #0x10
	add r0, r0, #2
	str r0, [sp]
	cmp r7, #3
	blt _021E8B94
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E8C58: .word ov112_021F4138
	thumb_func_end ov112_021E8B74

	thumb_func_start ov112_021E8C5C
ov112_021E8C5C: ; 0x021E8C5C
	push {r3, r4, r5, r6, r7, lr}
	add r7, r1, #0
	add r5, r0, #0
	add r4, r2, #0
	add r0, r7, #0
	mov r1, #0xb1
	mov r2, #0
	bl GetBoxMonData
	add r6, r0, #0
	add r0, r7, #0
	mov r1, #0xb2
	mov r2, #0
	bl GetBoxMonData
	mov r3, #0
	add r1, r0, #0
	add r2, r3, #0
	mov r7, #1
_021E8C82:
	ldrb r0, [r5, r2]
	cmp r6, r0
	beq _021E8C8C
	cmp r1, r0
	bne _021E8C8E
_021E8C8C:
	add r3, r7, #0
_021E8C8E:
	add r2, r2, #1
	cmp r2, #3
	blt _021E8C82
	cmp r3, #0
	beq _021E8CB4
	mov r5, #0
	mov r7, #0x64
	mov r6, #0x4b
_021E8C9E:
	ldrh r1, [r4]
	add r0, r1, #0
	mul r0, r6
	add r1, r7, #0
	bl _s32_div_f
	strh r0, [r4]
	add r5, r5, #1
	add r4, r4, #2
	cmp r5, #3
	blt _021E8C9E
_021E8CB4:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021E8C5C

	thumb_func_start ov112_021E8CB8
ov112_021E8CB8: ; 0x021E8CB8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x130
	add r7, r0, #0
	ldr r0, _021E901C ; =0x0001D798
	add r5, r1, #0
	ldr r0, [r5, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x28]
	mov r0, #0x9a
	add r1, r0, #0
	add r1, #0xe6
	bl Heap_Alloc
	str r0, [sp, #0x24]
	mov r0, #0
	ldr r6, _021E9020 ; =ov112_021F5578
	str r0, [sp, #0x2c]
	add r4, sp, #0x40
_021E8CDE:
	mov r0, #0
	str r0, [sp]
	ldrb r0, [r6]
	add r1, r4, #0
	mov r2, #1
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x18]
	mov r3, #0
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x2c]
	add r6, r6, #1
	add r0, r0, #1
	add r4, #0x10
	str r0, [sp, #0x2c]
	cmp r0, #0xf
	blo _021E8CDE
	ldr r0, _021E9024 ; =0x0001D77C
	ldrh r0, [r5, r0]
	strh r0, [r7]
	ldr r0, _021E9028 ; =0x0001E430
	ldr r0, [r5, r0]
	bl AcquireBoxMonLock
	mov r4, #0
	add r6, r7, #0
_021E8D24:
	ldr r0, _021E9028 ; =0x0001E430
	add r1, r4, #0
	ldr r0, [r5, r0]
	add r1, #0x36
	mov r2, #0
	bl GetBoxMonData
	strh r0, [r6, #4]
	add r4, r4, #1
	add r6, r6, #2
	cmp r4, #4
	blt _021E8D24
	ldr r0, _021E9028 ; =0x0001E430
	mov r1, #0xa1
	ldr r0, [r5, r0]
	mov r2, #0
	bl GetBoxMonData
	strb r0, [r7, #0xc]
	ldr r0, _021E9028 ; =0x0001E430
	mov r1, #0x70
	ldr r0, [r5, r0]
	mov r2, #0
	bl GetBoxMonData
	ldrb r1, [r7, #0xd]
	mov r2, #0x1f
	lsl r0, r0, #0x18
	bic r1, r2
	lsr r2, r0, #0x18
	mov r0, #0x1f
	and r0, r2
	orr r0, r1
	strb r0, [r7, #0xd]
	ldrb r1, [r7, #0xd]
	mov r0, #0x80
	bic r1, r0
	ldr r0, _021E9028 ; =0x0001E430
	strb r1, [r7, #0xd]
	ldr r0, [r5, r0]
	bl BoxMonIsShiny
	lsl r0, r0, #0x1f
	ldrb r2, [r7, #0xe]
	mov r1, #2
	lsr r0, r0, #0x1e
	bic r2, r1
	orr r0, r2
	strb r0, [r7, #0xe]
	ldr r0, _021E9028 ; =0x0001E430
	mov r1, #9
	ldr r0, [r5, r0]
	mov r2, #0
	bl GetBoxMonData
	add r1, r7, #0
	add r1, #0x26
	strb r0, [r1]
	ldr r0, _021E9028 ; =0x0001E430
	add r2, r7, #0
	ldr r0, [r5, r0]
	mov r1, #0x75
	add r2, #0x10
	bl GetBoxMonData
	ldr r0, _021E9028 ; =0x0001E430
	mov r1, #1
	ldr r0, [r5, r0]
	bl ReleaseBoxMonLock
	ldrh r0, [r7]
	mov r1, #0x9a
	bl AllocAndLoadMonPersonal
	mov r1, #0x1c
	add r4, r0, #0
	bl GetPersonalAttr
	ldrb r1, [r7, #0xe]
	mov r2, #1
	lsl r0, r0, #0x18
	bic r1, r2
	lsr r2, r0, #0x18
	mov r0, #1
	and r0, r2
	orr r0, r1
	strb r0, [r7, #0xe]
	add r0, r4, #0
	bl FreeMonPersonal
	ldr r0, _021E9028 ; =0x0001E430
	ldr r0, [r5, r0]
	bl GetBoxMonGender
	ldrb r2, [r7, #0xd]
	mov r1, #0x60
	lsl r0, r0, #0x1e
	bic r2, r1
	lsr r0, r0, #0x19
	orr r0, r2
	strb r0, [r7, #0xd]
	ldr r0, [sp, #0x28]
	mov r1, #0xc0
	mul r1, r0
	str r1, [sp, #0x20]
	ldr r1, _021E902C ; =ov112_021F413C
	ldr r0, [sp, #0x20]
	ldr r0, [r1, r0]
	str r0, [sp, #0x1c]
	sub r1, r0, #1
	add r0, r7, #0
	add r0, #0x27
	strb r1, [r0]
	ldr r1, _021E901C ; =0x0001D798
	ldr r0, _021E9030 ; =0x0001E44C
	ldr r1, [r5, r1]
	ldr r0, [r5, r0]
	add r1, #0x5b
	bl NewString_ReadMsgData
	add r1, r7, #0
	add r4, r0, #0
	add r1, #0x28
	mov r2, #0x15
	bl CopyStringToU16Array
	add r0, r4, #0
	bl String_Delete
	add r0, sp, #0x3c
	str r0, [sp]
	add r0, r7, #0
	add r1, r7, #0
	add r2, r7, #0
	ldr r3, [sp, #0x28]
	add r0, #0x52
	add r1, #0x82
	add r2, #0x88
	bl ov112_021E8B74
	ldr r1, _021E9028 ; =0x0001E430
	add r2, r7, #0
	ldr r4, _021E9034 ; =ov112_021F4138
	ldr r0, [sp, #0x20]
	ldr r1, [r5, r1]
	add r0, r4, r0
	add r0, #0xbc
	add r2, #0x82
	bl ov112_021E8C5C
	ldr r2, [sp, #0x20]
	add r0, sp, #0x40
	add r1, r5, #0
	add r2, r4, r2
	add r3, sp, #0x3c
	bl ov112_021E9148
	mov r0, #0
	str r0, [sp, #0x14]
	add r4, r0, #0
	ldr r0, _021E9038 ; =0x00000B7E
	add r6, r7, #0
	add r0, r7, r0
	str r0, [sp, #0x34]
_021E8E6C:
	add r0, r6, #0
	add r0, #0x52
	ldrh r0, [r0]
	bl ov112_021E9470
	add r1, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0xfa
	mov r2, #1
	mov r3, #0x9a
	bl GfGfxLoader_LoadFromNarc
	ldr r1, [sp, #0x34]
	mov r2, #6
	str r0, [sp, #0x30]
	add r1, r1, r4
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r0, [sp, #0x30]
	bl Heap_Free
	mov r0, #6
	lsl r0, r0, #6
	add r4, r4, r0
	ldr r0, [sp, #0x14]
	add r6, #0x10
	add r0, r0, #1
	str r0, [sp, #0x14]
	cmp r0, #3
	blt _021E8E6C
	add r1, r7, #0
	add r1, #0x7f
	add r0, r7, #0
	ldrb r1, [r1]
	add r0, #0x72
	ldrh r0, [r0]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1e
	mov r2, #0
	bl ov112_021E9480
	add r1, r0, #0
	mov r2, #1
	ldr r0, _021E903C ; =0x00000102
	mov r3, #0x9a
	str r2, [sp]
	bl GfGfxLoader_LoadFromNarc
	ldr r1, _021E9040 ; =0x00000FFE
	mov r2, #6
	add r4, r0, #0
	add r1, r7, r1
	lsl r2, r2, #8
	bl MI_CpuCopy8
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	str r0, [sp, #0x18]
	add r4, r0, #0
	ldr r0, _021E9044 ; =0x000015FE
	add r6, sp, #0x40
	add r0, r7, r0
	str r0, [sp, #0x38]
_021E8EF2:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x50
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	add r0, r6, #0
	add r0, #0xac
	ldr r0, [r0]
	ldr r3, [sp, #0x24]
	mov r1, #0xa
	mov r2, #2
	bl ov112_021E93BC
	ldr r1, [sp, #0x38]
	mov r2, #5
	ldr r0, [sp, #0x24]
	add r1, r1, r4
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r0, #5
	lsl r0, r0, #6
	add r4, r4, r0
	ldr r0, [sp, #0x18]
	add r6, #0x10
	add r0, r0, #1
	str r0, [sp, #0x18]
	cmp r0, #3
	blt _021E8EF2
	ldr r1, _021E9034 ; =ov112_021F4138
	ldr r0, [sp, #0x20]
	mov r2, #0
	add r0, r1, r0
	add r1, r7, #0
_021E8F3A:
	add r3, r0, #0
	add r3, #0x80
	ldrh r4, [r3]
	add r3, r1, #0
	add r3, #0x8c
	strh r4, [r3]
	add r3, r0, #0
	add r3, #0x82
	ldrh r4, [r3]
	add r3, r1, #0
	add r3, #0xa0
	strh r4, [r3]
	add r3, r0, #0
	add r3, #0x84
	ldrh r4, [r3]
	add r3, r7, r2
	add r3, #0xb4
	add r2, r2, #1
	strb r4, [r3]
	add r0, r0, #6
	add r1, r1, #2
	cmp r2, #0xa
	blt _021E8F3A
	ldr r0, [sp, #0x1c]
	mov r2, #0xc0
	lsl r1, r0, #2
	ldr r0, _021E9048 ; =ov112_021FF528
	ldr r0, [r0, r1]
	add r1, r7, #0
	add r1, #0xbe
	bl MI_CpuCopy8
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x50
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x11c]
	ldr r3, [sp, #0x24]
	mov r1, #0xa
	mov r2, #2
	bl ov112_021E93BC
	ldr r2, _021E904C ; =0x0000017E
	ldr r0, [sp, #0x24]
	add r1, r7, r2
	sub r2, #0x3e
	bl MI_CpuCopy8
	ldr r0, _021E9028 ; =0x0001E430
	ldr r0, [r5, r0]
	bl ov112_021E9464
	add r1, r0, #0
	mov r2, #1
	mov r0, #0xfa
	mov r3, #0x9a
	str r2, [sp]
	bl GfGfxLoader_LoadFromNarc
	ldr r1, _021E9050 ; =0x000002BE
	mov r2, #6
	add r4, r0, #0
	add r1, r7, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	add r0, r4, #0
	bl Heap_Free
	ldr r0, _021E9024 ; =0x0001D77C
	ldrh r0, [r5, r0]
	cmp r0, #0
	bne _021E8FD6
	bl GF_AssertFail
_021E8FD6:
	ldr r2, _021E9024 ; =0x0001D77C
	add r1, r2, #0
	ldrh r0, [r5, r2]
	add r1, #0x1a
	add r2, #0x18
	ldrb r1, [r5, r1]
	ldrb r2, [r5, r2]
	bl ov112_021E9480
	add r1, r0, #0
	mov r2, #1
	ldr r0, _021E903C ; =0x00000102
	mov r3, #0x9a
	str r2, [sp]
	bl GfGfxLoader_LoadFromNarc
	add r4, r0, #0
	ldr r0, _021E9024 ; =0x0001D77C
	ldrh r1, [r5, r0]
	ldr r0, _021E9054 ; =0x00000147
	cmp r1, r0
	bne _021E9018
	ldr r0, _021E9028 ; =0x0001E430
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl GetBoxMonData
	add r2, r0, #0
	ldr r1, _021E9058 ; =ov112_021FE498
	add r0, r4, #0
	bl ov112_021E9A30
_021E9018:
	ldr r1, _021E905C ; =0x0000043E
	b _021E9060
	.balign 4, 0
_021E901C: .word 0x0001D798
_021E9020: .word ov112_021F5578
_021E9024: .word 0x0001D77C
_021E9028: .word 0x0001E430
_021E902C: .word ov112_021F413C
_021E9030: .word 0x0001E44C
_021E9034: .word ov112_021F4138
_021E9038: .word 0x00000B7E
_021E903C: .word 0x00000102
_021E9040: .word 0x00000FFE
_021E9044: .word 0x000015FE
_021E9048: .word ov112_021FF528
_021E904C: .word 0x0000017E
_021E9050: .word 0x000002BE
_021E9054: .word 0x00000147
_021E9058: .word ov112_021FE498
_021E905C: .word 0x0000043E
_021E9060:
	mov r2, #6
	add r0, r4, #0
	add r1, r7, r1
	lsl r2, r2, #8
	bl MI_CpuCopy8
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x50
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x12c]
	ldr r3, [sp, #0x24]
	mov r1, #0xa
	mov r2, #2
	bl ov112_021E93BC
	ldr r1, _021E90F4 ; =0x00000A3E
	mov r2, #5
	ldr r0, [sp, #0x24]
	add r1, r7, r1
	lsl r2, r2, #6
	bl MI_CpuCopy8
	ldr r0, _021E90F8 ; =0x000019BE
	mov r6, #0
	add r4, sp, #0x40
	add r5, r6, #0
	add r7, r7, r0
_021E90A4:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x60
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0xc]
	ldr r3, [sp, #0x24]
	mov r1, #0xc
	mov r2, #2
	bl ov112_021E93BC
	mov r2, #6
	ldr r0, [sp, #0x24]
	add r1, r7, r5
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r0, #6
	lsl r0, r0, #6
	add r6, r6, #1
	add r4, #0x10
	add r5, r5, r0
	cmp r6, #0xa
	blt _021E90A4
	mov r5, #0
	add r4, sp, #0x40
_021E90DC:
	add r0, r4, #0
	bl RemoveWindow
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #0xf
	blo _021E90DC
	ldr r0, [sp, #0x24]
	bl Heap_Free
	add sp, #0x130
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E90F4: .word 0x00000A3E
_021E90F8: .word 0x000019BE
	thumb_func_end ov112_021E8CB8

	thumb_func_start ov112_021E90FC
ov112_021E90FC: ; 0x021E90FC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, [r1, #0x20]
	bl Save_PlayerData_GetProfile
	mov r1, #0x9a
	bl PlayerProfile_GetPlayerName_NewString
	add r4, r0, #0
	mov r0, #5
	mov r1, #0x9a
	bl FontID_Alloc
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E9144 ; =0x00030100
	add r2, r4, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r0, r5, #0
	mov r1, #5
	mov r3, #2
	bl AddTextPrinterParameterizedWithColor
	mov r0, #5
	bl FontID_Release
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021E9144: .word 0x00030100
	thumb_func_end ov112_021E90FC

	thumb_func_start ov112_021E9148
ov112_021E9148: ; 0x021E9148
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	str r0, [sp, #0x10]
	str r1, [sp, #0x14]
	str r2, [sp, #0x18]
	str r3, [sp, #0x1c]
	mov r0, #1
	mov r1, #0x1b
	mov r2, #0xed
	mov r3, #0x9a
	bl NewMsgDataFromNarc
	str r0, [sp, #0x20]
	mov r0, #5
	mov r1, #0x9a
	bl FontID_Alloc
	ldr r4, [sp, #0x18]
	ldr r5, [sp, #0x10]
	mov r7, #0
_021E9170:
	ldr r1, [sp, #0x14]
	ldr r0, _021E927C ; =0x0001E450
	ldr r0, [r1, r0]
	add r1, r4, #0
	add r1, #0x80
	ldrh r1, [r1]
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E9280 ; =0x00030100
	mov r1, #5
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r2, r6, #0
	mov r3, #2
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r7, r7, #1
	add r4, r4, #6
	add r5, #0x10
	cmp r7, #0xa
	blt _021E9170
	mov r5, #0
	mov r6, #1
	mov r7, #0xff
_021E91B4:
	ldr r1, [sp, #0x1c]
	ldr r0, [sp, #0x20]
	ldrb r2, [r1, r5]
	mov r1, #0x14
	add r3, r2, #0
	mul r3, r1
	ldr r1, [sp, #0x18]
	add r1, r1, r3
	ldrh r1, [r1, #8]
	bl NewString_ReadMsgData
	add r4, r0, #0
	str r6, [sp]
	ldr r0, _021E9280 ; =0x00030100
	str r7, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r0, #0xa
	lsl r1, r0, #4
	ldr r0, [sp, #0x10]
	add r2, r4, #0
	add r0, r0, r1
	mov r1, #5
	mov r3, #2
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	add r5, r5, #1
	cmp r5, #3
	blt _021E91B4
	ldr r1, _021E9284 ; =0x0001E44C
	ldr r0, [sp, #0x14]
	ldr r2, _021E9288 ; =0x0001D798
	ldr r0, [r0, r1]
	ldr r1, [sp, #0x14]
	ldr r1, [r1, r2]
	add r1, #0x5b
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E9280 ; =0x00030100
	add r2, r4, #0
	str r0, [sp, #8]
	ldr r0, [sp, #0x10]
	str r1, [sp, #0xc]
	add r0, #0xd0
	mov r1, #5
	mov r3, #2
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	mov r0, #0xc
	mov r1, #0x9a
	bl String_New
	add r4, r0, #0
	ldr r1, _021E928C ; =0x0001E430
	ldr r0, [sp, #0x14]
	add r2, r4, #0
	ldr r0, [r0, r1]
	mov r1, #0x77
	bl GetBoxMonData
	mov r0, #1
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _021E9280 ; =0x00030100
	mov r1, #5
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x10]
	add r2, r4, #0
	add r0, #0xe0
	mov r3, #2
	str r0, [sp, #0x10]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	mov r0, #5
	bl FontID_Release
	ldr r0, [sp, #0x20]
	bl DestroyMsgData
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021E927C: .word 0x0001E450
_021E9280: .word 0x00030100
_021E9284: .word 0x0001E44C
_021E9288: .word 0x0001D798
_021E928C: .word 0x0001E430
	thumb_func_end ov112_021E9148

	thumb_func_start ov112_021E9290
ov112_021E9290: ; 0x021E9290
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	add r4, r2, #0
	add r6, r0, #0
	add r5, r1, #0
	str r3, [sp, #0x20]
	add r0, r4, #0
	add r1, r6, #0
	mov r2, #2
	mov r3, #0
	bl GetBoxmonSpriteCharAndPlttNarcIds
	mov r1, #0
	add r0, r6, #0
	add r2, r1, #0
	bl GetBoxMonData
	add r7, r0, #0
	add r0, r6, #0
	mov r1, #5
	mov r2, #0
	bl GetBoxMonData
	mov r3, #0
	str r3, [sp]
	mov r1, #0xa
	str r1, [sp, #4]
	str r1, [sp, #8]
	str r5, [sp, #0xc]
	str r7, [sp, #0x10]
	str r3, [sp, #0x14]
	mov r1, #2
	str r1, [sp, #0x18]
	str r0, [sp, #0x1c]
	ldrh r0, [r4]
	ldrh r1, [r4, #2]
	mov r2, #0x9a
	bl sub_02014494
	mov r1, #0x32
	add r0, r5, #0
	lsl r1, r1, #6
	bl DC_FlushRange
	ldr r0, [sp, #0x20]
	cmp r0, #0
	bne _021E9312
	mov r1, #0x2e
	mov r2, #0x32
	add r0, r5, #0
	lsl r1, r1, #6
	lsl r2, r2, #6
	bl GX_LoadOBJ
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0x9a
	str r0, [sp, #4]
	ldrh r0, [r4]
	ldrh r1, [r4, #4]
	mov r2, #1
	mov r3, #0x80
	bl GfGfxLoader_GXLoadPal
	b _021E9332
_021E9312:
	mov r1, #0x31
	lsl r1, r1, #6
	add r2, r1, #0
	add r0, r5, #0
	add r2, #0x40
	bl GXS_LoadOBJ
	mov r3, #0x20
	str r3, [sp]
	mov r0, #0x9a
	str r0, [sp, #4]
	ldrh r0, [r4]
	ldrh r1, [r4, #4]
	mov r2, #5
	bl GfGfxLoader_GXLoadPal
_021E9332:
	mov r0, #0
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov112_021E9290

	thumb_func_start ov112_021E9338
ov112_021E9338: ; 0x021E9338
	push {r3, lr}
	ldr r1, _021E9358 ; =0x0001E440
	add r2, sp, #0
	ldr r0, [r0, r1]
	add r1, sp, #0
	add r1, #2
	bl sub_02032688
	add r0, sp, #0
	ldrh r0, [r0, #2]
	cmp r0, #0
	beq _021E9354
	mov r0, #1
	pop {r3, pc}
_021E9354:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021E9358: .word 0x0001E440
	thumb_func_end ov112_021E9338

	thumb_func_start ov112_021E935C
ov112_021E935C: ; 0x021E935C
	push {r4, r5}
	asr r5, r3, #2
	asr r4, r2, #2
	lsr r5, r5, #0x1d
	lsr r4, r4, #0x1d
	add r5, r3, r5
	add r4, r2, r4
	asr r5, r5, #3
	mul r1, r5
	asr r4, r4, #3
	add r4, r4, r1
	lsr r5, r2, #0x1f
	lsl r1, r2, #0x1d
	sub r1, r1, r5
	mov r2, #0x1d
	ror r1, r2
	add r1, r5, r1
	lsr r5, r3, #0x1f
	lsl r3, r3, #0x1d
	sub r3, r3, r5
	ror r3, r2
	add r2, r5, r3
	lsl r2, r2, #3
	add r2, r1, r2
	mov r1, #1
	and r1, r2
	cmp r1, #1
	bne _021E93A6
	lsr r1, r2, #0x1f
	add r1, r2, r1
	asr r2, r1, #1
	lsl r1, r4, #5
	add r1, r2, r1
	ldrb r0, [r0, r1]
	asr r0, r0, #4
	pop {r4, r5}
	bx lr
_021E93A6:
	lsr r1, r2, #0x1f
	add r1, r2, r1
	asr r2, r1, #1
	lsl r1, r4, #5
	add r1, r2, r1
	ldrb r1, [r0, r1]
	mov r0, #0xf
	and r0, r1
	pop {r4, r5}
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021E935C

	thumb_func_start ov112_021E93BC
ov112_021E93BC: ; 0x021E93BC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	str r0, [sp]
	ldr r0, [sp, #0x30]
	str r1, [sp, #4]
	str r0, [sp, #0x30]
	ldr r0, [sp, #0x34]
	str r3, [sp, #8]
	str r0, [sp, #0x34]
	ldr r0, [sp, #0x38]
	add r1, r3, #0
	str r0, [sp, #0x38]
	ldr r3, [sp, #0x3c]
	ldr r2, [sp, #0x38]
	mov r0, #0
	mul r3, r2
	asr r2, r3, #2
	lsr r2, r2, #0x1d
	add r2, r3, r2
	asr r2, r2, #3
	lsl r2, r2, #1
	str r0, [sp, #0x10]
	bl MIi_CpuClearFast
	mov r0, #0
	ldr r1, [sp, #0x3c]
	str r0, [sp, #0x14]
	asr r0, r1, #2
	lsr r0, r0, #0x1d
	add r0, r1, r0
	asr r0, r0, #3
	str r0, [sp, #0xc]
	cmp r0, #0
	ble _021E945C
	ldr r7, [sp, #0x14]
_021E9402:
	ldr r0, [sp, #0x38]
	mov r6, #0
	cmp r0, #0
	ble _021E944E
_021E940A:
	ldr r1, [sp, #8]
	ldr r0, [sp, #0x10]
	mov r4, #0
	add r5, r1, r0
_021E9412:
	ldr r3, [sp, #0x34]
	ldr r2, [sp, #0x30]
	add r3, r3, r4
	ldr r0, [sp]
	ldr r1, [sp, #4]
	add r2, r6, r2
	add r3, r3, r7
	bl ov112_021E935C
	asr r2, r0, #1
	ldrb r1, [r5]
	lsl r2, r4
	orr r1, r2
	mov r2, #1
	strb r1, [r5]
	and r0, r2
	lsl r0, r4
	ldrb r1, [r5, #1]
	add r4, r4, #1
	orr r0, r1
	strb r0, [r5, #1]
	cmp r4, #8
	blt _021E9412
	ldr r0, [sp, #0x10]
	add r6, r6, #1
	add r0, r0, #2
	str r0, [sp, #0x10]
	ldr r0, [sp, #0x38]
	cmp r6, r0
	blt _021E940A
_021E944E:
	ldr r0, [sp, #0x14]
	add r7, #8
	add r1, r0, #1
	ldr r0, [sp, #0xc]
	str r1, [sp, #0x14]
	cmp r1, r0
	blt _021E9402
_021E945C:
	ldr r0, [sp, #0x10]
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov112_021E93BC

	thumb_func_start ov112_021E9464
ov112_021E9464: ; 0x021E9464
	push {r3, lr}
	bl Boxmon_GetIconNaix
	sub r0, r0, #7
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021E9464

	thumb_func_start ov112_021E9470
ov112_021E9470: ; 0x021E9470
	push {r3, lr}
	mov r1, #0
	add r2, r1, #0
	bl GetMonIconNaixEx
	sub r0, r0, #7
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021E9470

	thumb_func_start ov112_021E9480
ov112_021E9480: ; 0x021E9480
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	lsl r0, r5, #0x10
	lsl r1, r2, #0x18
	lsr r0, r0, #0x10
	lsr r1, r1, #0x18
	bl sub_02070438
	ldr r1, _021E9598 ; =0x000001A5
	cmp r5, r1
	bgt _021E94EC
	bge _021E9550
	add r2, r1, #0
	sub r2, #0x46
	cmp r5, r2
	bgt _021E94B8
	add r2, r1, #0
	sub r2, #0x46
	cmp r5, r2
	bge _021E955C
	cmp r5, #0xac
	bgt _021E94B2
	beq _021E9580
	b _021E9586
_021E94B2:
	cmp r5, #0xc9
	beq _021E9568
	b _021E9586
_021E94B8:
	add r2, r1, #0
	sub r2, #0x23
	cmp r5, r2
	bgt _021E94CA
	add r2, r1, #0
	sub r2, #0x23
	cmp r5, r2
	beq _021E9562
	b _021E9586
_021E94CA:
	add r2, r1, #0
	sub r2, #8
	cmp r5, r2
	bgt _021E9586
	add r2, r1, #0
	sub r2, #9
	cmp r5, r2
	blt _021E9586
	add r2, r1, #0
	sub r2, #9
	cmp r5, r2
	beq _021E9538
	add r2, r1, #0
	sub r2, #8
	cmp r5, r2
	beq _021E953E
	b _021E9586
_021E94EC:
	add r2, r1, #0
	add r2, #0x42
	cmp r5, r2
	bgt _021E951C
	add r2, r1, #0
	add r2, #0x42
	cmp r5, r2
	bge _021E957A
	add r2, r1, #2
	cmp r5, r2
	bgt _021E9512
	add r2, r1, #1
	cmp r5, r2
	blt _021E9586
	beq _021E9544
	add r2, r1, #2
	cmp r5, r2
	beq _021E954A
	b _021E9586
_021E9512:
	add r2, r1, #0
	add r2, #0x3a
	cmp r5, r2
	beq _021E9574
	b _021E9586
_021E951C:
	add r2, r1, #0
	add r2, #0x47
	cmp r5, r2
	bgt _021E952E
	add r2, r1, #0
	add r2, #0x47
	cmp r5, r2
	beq _021E956E
	b _021E9586
_021E952E:
	add r2, r1, #0
	add r2, #0x48
	cmp r5, r2
	beq _021E9556
	b _021E9586
_021E9538:
	add r1, #0xc9
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E953E:
	add r1, #0xcc
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9544:
	add r1, #0xcf
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E954A:
	add r1, #0xd1
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9550:
	add r1, #0xd3
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9556:
	add r1, #0xd5
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E955C:
	add r1, #0xc5
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9562:
	add r1, #0xa5
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9568:
	add r1, #0xa9
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E956E:
	add r1, #0xe7
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9574:
	add r1, #0xe9
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E957A:
	add r1, #0xef
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9580:
	add r1, #0xf1
	add r0, r0, r1
	pop {r3, r4, r5, pc}
_021E9586:
	cmp r4, #1
	beq _021E958C
	mov r4, #0
_021E958C:
	ldr r0, _021E959C ; =ov112_021F397E
	lsl r2, r5, #2
	lsl r1, r4, #1
	add r0, r0, r2
	ldrh r0, [r1, r0]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E9598: .word 0x000001A5
_021E959C: .word ov112_021F397E
	thumb_func_end ov112_021E9480

	thumb_func_start ov112_021E95A0
ov112_021E95A0: ; 0x021E95A0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r0, #0
	ldr r0, _021E9604 ; =0x0001E440
	add r1, sp, #4
	ldr r0, [r6, r0]
	add r2, sp, #0
	bl sub_02032674
	ldr r0, [r6, #0x20]
	bl Save_Pokedex_Get
	bl Pokedex_GetNatDexFlag
	cmp r0, #0
	beq _021E95C4
	mov r7, #0x14
	b _021E95C6
_021E95C4:
	mov r7, #8
_021E95C6:
	mov r4, #0
	cmp r7, #0
	bls _021E95FE
	ldr r5, _021E9608 ; =ov112_021F4138
_021E95CE:
	ldr r1, [r5]
	ldr r0, [sp]
	cmp r1, r0
	bhi _021E95F6
	ldr r0, _021E9604 ; =0x0001E440
	add r1, r4, #0
	ldr r0, [r6, r0]
	bl Pokewalker_CourseIsUnlocked
	cmp r0, #0
	bne _021E95F6
	ldr r0, _021E9604 ; =0x0001E440
	add r1, r4, #0
	ldr r0, [r6, r0]
	bl Pokewalker_UnlockCourse
	ldr r0, _021E960C ; =0x0001EC78
	add sp, #8
	str r4, [r6, r0]
	pop {r3, r4, r5, r6, r7, pc}
_021E95F6:
	add r4, r4, #1
	add r5, #0xc0
	cmp r4, r7
	blo _021E95CE
_021E95FE:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9604: .word 0x0001E440
_021E9608: .word ov112_021F4138
_021E960C: .word 0x0001EC78
	thumb_func_end ov112_021E95A0

	thumb_func_start ov112_021E9610
ov112_021E9610: ; 0x021E9610
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r0, [r6, #0x20]
	str r1, [sp]
	bl Save_Pokedex_Get
	bl Pokedex_GetNatDexFlag
	cmp r0, #0
	beq _021E9628
	mov r5, #0x14
	b _021E962A
_021E9628:
	mov r5, #8
_021E962A:
	mov r4, #0
	cmp r5, #0
	ble _021E965C
	ldr r7, _021E9664 ; =0x0001E440
_021E9632:
	ldr r0, [r6, r7]
	add r1, r4, #0
	bl Pokewalker_CourseIsUnlocked
	cmp r0, #0
	bne _021E9656
	mov r0, #0xc0
	add r1, r4, #0
	mul r1, r0
	ldr r0, _021E9668 ; =ov112_021F4138
	ldr r1, [r0, r1]
	ldr r0, [sp]
	cmp r1, r0
	bls _021E9652
	sub r0, r1, r0
	pop {r3, r4, r5, r6, r7, pc}
_021E9652:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E9656:
	add r4, r4, #1
	cmp r4, r5
	blt _021E9632
_021E965C:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9664: .word 0x0001E440
_021E9668: .word ov112_021F4138
	thumb_func_end ov112_021E9610

	thumb_func_start ov112_021E966C
ov112_021E966C: ; 0x021E966C
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	mov r1, #2
	mov r2, #0xd
	bl ov112_021E7CA4
	add r0, r5, #0
	mov r1, #0
	bl ov112_021EA51C
	ldr r0, _021E96BC ; =0x000F0100
	ldr r2, _021E96C0 ; =0x0001E514
	str r0, [sp]
	ldr r2, [r5, r2]
	add r0, r5, #0
	mov r1, #3
	mov r3, #4
	bl ov112_021E9FA4
	ldr r0, _021E96BC ; =0x000F0100
	mov r1, #4
	str r0, [sp]
	ldr r2, _021E96C4 ; =0x0001E518
	add r0, r5, #0
	ldr r2, [r5, r2]
	add r3, r1, #0
	bl ov112_021E9FA4
	add r0, r5, #0
	add r1, r4, #0
	bl ov112_021EA51C
	ldr r0, _021E96C8 ; =0x0001EC50
	mov r1, #0
	str r4, [r5, r0]
	ldr r0, _021E96CC ; =0x0001F2E2
	strh r1, [r5, r0]
	pop {r3, r4, r5, pc}
	nop
_021E96BC: .word 0x000F0100
_021E96C0: .word 0x0001E514
_021E96C4: .word 0x0001E518
_021E96C8: .word 0x0001EC50
_021E96CC: .word 0x0001F2E2
	thumb_func_end ov112_021E966C

	thumb_func_start ov112_021E96D0
ov112_021E96D0: ; 0x021E96D0
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _021E9740 ; =0x0001E44C
	add r4, r1, #0
	ldr r0, [r5, r0]
	mov r1, #0x96
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r0, _021E9740 ; =0x0001E44C
	mov r1, #0x97
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r0, r5, #0
	mov r1, #2
	mov r2, #0xd
	bl ov112_021E7CA4
	add r0, r5, #0
	mov r1, #0
	bl ov112_021EA51C
	ldr r0, _021E9744 ; =0x000F0100
	mov r1, #3
	str r0, [sp]
	add r0, r5, #0
	add r2, r6, #0
	mov r3, #4
	bl ov112_021E9FA4
	ldr r0, _021E9744 ; =0x000F0100
	mov r1, #4
	str r0, [sp]
	add r0, r5, #0
	add r2, r7, #0
	add r3, r1, #0
	bl ov112_021E9FA4
	add r0, r5, #0
	add r1, r4, #0
	bl ov112_021EA51C
	ldr r0, _021E9748 ; =0x0001EC50
	mov r1, #0
	str r4, [r5, r0]
	ldr r0, _021E974C ; =0x0001F2E2
	strh r1, [r5, r0]
	add r0, r7, #0
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E9740: .word 0x0001E44C
_021E9744: .word 0x000F0100
_021E9748: .word 0x0001EC50
_021E974C: .word 0x0001F2E2
	thumb_func_end ov112_021E96D0

	thumb_func_start ov112_021E9750
ov112_021E9750: ; 0x021E9750
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E9870 ; =0x0001F2E2
	ldrh r0, [r4, r0]
	cmp r0, #0
	bne _021E9840
	mov r0, #0
	bl ov112_021E9888
	cmp r0, #0
	beq _021E9774
	cmp r0, #1
	beq _021E9794
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _021E97B6
	b _021E986C
_021E9774:
	ldr r0, _021E9874 ; =0x0001EC50
	mov r1, #0
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov112_021EA51C
	add r0, r4, #0
	bl ov112_021EA584
	ldr r0, _021E9878 ; =0x000005DD
	bl PlaySE
	ldr r0, _021E9870 ; =0x0001F2E2
	mov r1, #1
	strh r1, [r4, r0]
	b _021E986C
_021E9794:
	ldr r0, _021E9874 ; =0x0001EC50
	mov r1, #2
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #1
	bl ov112_021EA51C
	add r0, r4, #0
	bl ov112_021EA584
	ldr r0, _021E9878 ; =0x000005DD
	bl PlaySE
	ldr r0, _021E9870 ; =0x0001F2E2
	mov r1, #1
	strh r1, [r4, r0]
	b _021E986C
_021E97B6:
	ldr r0, _021E987C ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _021E97DE
	ldr r0, _021E9874 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E97CE
	ldr r0, _021E9880 ; =0x000005DC
	bl PlaySE
_021E97CE:
	add r0, r4, #0
	mov r1, #0
	bl ov112_021EA51C
	ldr r0, _021E9874 ; =0x0001EC50
	mov r1, #0
	str r1, [r4, r0]
	b _021E986C
_021E97DE:
	mov r1, #0x80
	tst r1, r0
	beq _021E9802
	ldr r0, _021E9874 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #1
	beq _021E97F2
	ldr r0, _021E9880 ; =0x000005DC
	bl PlaySE
_021E97F2:
	add r0, r4, #0
	mov r1, #1
	bl ov112_021EA51C
	ldr r0, _021E9874 ; =0x0001EC50
	mov r1, #1
	str r1, [r4, r0]
	b _021E986C
_021E9802:
	mov r1, #1
	add r2, r0, #0
	tst r2, r1
	beq _021E981C
	ldr r0, _021E9870 ; =0x0001F2E2
	strh r1, [r4, r0]
	add r0, r4, #0
	bl ov112_021EA584
	ldr r0, _021E9878 ; =0x000005DD
	bl PlaySE
	b _021E986C
_021E981C:
	mov r2, #2
	tst r0, r2
	beq _021E986C
	add r0, r4, #0
	bl ov112_021EA51C
	add r0, r4, #0
	bl ov112_021EA584
	ldr r0, _021E9874 ; =0x0001EC50
	mov r1, #1
	str r1, [r4, r0]
	ldr r0, _021E9870 ; =0x0001F2E2
	strh r1, [r4, r0]
	ldr r0, _021E9880 ; =0x000005DC
	bl PlaySE
	b _021E986C
_021E9840:
	cmp r0, #1
	bne _021E9858
	ldr r0, _021E9884 ; =0x0001E530
	ldr r0, [r4, r0]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _021E986C
	ldr r0, _021E9870 ; =0x0001F2E2
	mov r1, #2
	strh r1, [r4, r0]
	b _021E986C
_021E9858:
	cmp r0, #2
	bne _021E986C
	ldr r0, _021E9874 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E9868
	mov r0, #1
	pop {r4, pc}
_021E9868:
	mov r0, #0
	pop {r4, pc}
_021E986C:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021E9870: .word 0x0001F2E2
_021E9874: .word 0x0001EC50
_021E9878: .word 0x000005DD
_021E987C: .word gSystem
_021E9880: .word 0x000005DC
_021E9884: .word 0x0001E530
	thumb_func_end ov112_021E9750

	thumb_func_start ov112_021E9888
ov112_021E9888: ; 0x021E9888
	push {r4, lr}
	add r4, r0, #0
	cmp r4, #6
	blt _021E9894
	bl GF_AssertFail
_021E9894:
	ldr r0, _021E98A0 ; =ov112_021FF514
	lsl r1, r4, #2
	ldr r0, [r0, r1]
	bl TouchscreenHitbox_FindRectAtTouchNew
	pop {r4, pc}
	.balign 4, 0
_021E98A0: .word ov112_021FF514
	thumb_func_end ov112_021E9888

	thumb_func_start ov112_021E98A4
ov112_021E98A4: ; 0x021E98A4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0xf9
	mov r1, #0x9a
	bl NARC_New
	add r4, r0, #0
	mov r0, #5
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x9a
	str r0, [sp, #0xc]
	ldr r2, [r5, #0x18]
	add r0, r4, #0
	mov r1, #0x12
	mov r3, #5
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #5
	mov r1, #1
	bl ToggleBgLayer
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov112_021E98A4

	thumb_func_start ov112_021E98E8
ov112_021E98E8: ; 0x021E98E8
	ldr r3, _021E98F4 ; =ToggleBgLayer
	lsl r1, r1, #0x18
	mov r0, #5
	lsr r1, r1, #0x18
	bx r3
	nop
_021E98F4: .word ToggleBgLayer
	thumb_func_end ov112_021E98E8

	thumb_func_start ov112_021E98F8
ov112_021E98F8: ; 0x021E98F8
	push {r4, r5}
	lsr r5, r2, #0x1f
	lsl r4, r2, #0x1d
	sub r4, r4, r5
	mov r3, #0x1d
	ror r4, r3
	add r3, r5, r4
	lsl r4, r1, #1
	asr r1, r2, #2
	lsr r1, r1, #0x1d
	add r1, r2, r1
	asr r1, r1, #3
	lsl r1, r1, #7
	add r4, r4, r1
	add r1, r4, #1
	ldrb r1, [r0, r1]
	ldrb r0, [r0, r4]
	asr r1, r3
	lsl r1, r1, #0x1f
	lsr r2, r1, #0x1e
	add r1, r0, #0
	asr r1, r3
	mov r0, #1
	and r0, r1
	orr r0, r2
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r4, r5}
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021E98F8

	thumb_func_start ov112_021E9934
ov112_021E9934: ; 0x021E9934
	push {r3, r4, r5, r6}
	asr r4, r2, #2
	lsr r4, r4, #0x1d
	add r4, r2, r4
	lsr r6, r2, #0x1f
	lsl r5, r2, #0x1d
	sub r5, r5, r6
	mov r2, #0x1d
	ror r5, r2
	add r2, r6, r5
	mov r5, #2
	mov r6, #1
	asr r4, r4, #3
	and r5, r3
	tst r3, r6
	beq _021E9964
	add r3, r6, #0
	lsl r3, r2
	lsl r2, r1, #1
	lsl r1, r4, #7
	add r1, r2, r1
	ldrb r2, [r0, r1]
	orr r2, r3
	b _021E9976
_021E9964:
	add r3, r6, #0
	lsl r3, r2
	lsl r2, r1, #1
	lsl r1, r4, #7
	add r1, r2, r1
	mov r2, #0xff
	ldrb r4, [r0, r1]
	eor r2, r3
	and r2, r4
_021E9976:
	strb r2, [r0, r1]
	cmp r5, #0
	beq _021E9988
	add r2, r1, #1
	ldrb r1, [r0, r2]
	orr r1, r3
	strb r1, [r0, r2]
	pop {r3, r4, r5, r6}
	bx lr
_021E9988:
	add r4, r1, #1
	ldrb r2, [r0, r4]
	mov r1, #0xff
	eor r1, r3
	and r1, r2
	strb r1, [r0, r4]
	pop {r3, r4, r5, r6}
	bx lr
	thumb_func_end ov112_021E9934

	thumb_func_start ov112_021E9998
ov112_021E9998: ; 0x021E9998
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	str r0, [sp]
	ldr r0, [sp, #0x38]
	str r1, [sp, #4]
	str r0, [sp, #0x38]
	mov r0, #0
	str r0, [sp, #0x1c]
	ldr r0, _021E9A2C ; =ov112_021FF504
	str r2, [sp, #8]
	str r3, [sp, #0xc]
	str r0, [sp, #0x14]
_021E99B0:
	ldr r0, [sp, #0x14]
	mov r5, #0
	ldr r7, [r0]
	ldrb r0, [r7]
	cmp r0, #0xff
	beq _021E9A10
	ldr r0, [sp, #8]
	mov r1, #0xf
	add r6, r0, #0
	and r6, r1
	mov r1, #0xf0
	and r0, r1
	lsr r0, r0, #4
	sub r6, #8
	str r0, [sp, #0x10]
_021E99CE:
	lsl r1, r5, #1
	ldrb r2, [r7, r1]
	add r0, r7, r1
	ldr r1, [sp, #0xc]
	add r4, r1, r2
	ldrb r1, [r0, #1]
	ldr r0, [sp, #0x38]
	add r1, r0, r1
	ldr r0, [sp, #0x10]
	add r0, r0, r1
	str r0, [sp, #0x18]
	sub r0, #8
	str r0, [sp, #0x18]
	ldr r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r1, r6, r4
	bl ov112_021E98F8
	cmp r0, #2
	bne _021E9A02
	ldr r0, [sp]
	ldr r2, [sp, #0x18]
	add r1, r6, r4
	mov r3, #1
	bl ov112_021E9934
_021E9A02:
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	lsl r0, r5, #1
	ldrb r0, [r7, r0]
	cmp r0, #0xff
	bne _021E99CE
_021E9A10:
	ldr r0, [sp, #8]
	lsr r0, r0, #8
	str r0, [sp, #8]
	ldr r0, [sp, #0x14]
	add r0, r0, #4
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x1c]
	add r0, r0, #1
	str r0, [sp, #0x1c]
	cmp r0, #4
	blt _021E99B0
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9A2C: .word ov112_021FF504
	thumb_func_end ov112_021E9998

	thumb_func_start ov112_021E9A30
ov112_021E9A30: ; 0x021E9A30
	push {r3, r4, r5, r6, r7, lr}
	mov r3, #0xd
	mvn r3, r3
	str r3, [sp]
	add r3, r3, #6
	add r6, r0, #0
	add r4, r1, #0
	add r5, r2, #0
	bl ov112_021E9998
	mov r3, #0xd
	mov r1, #3
	mvn r3, r3
	lsl r1, r1, #8
	str r3, [sp]
	add r0, r6, r1
	add r1, r4, r1
	add r2, r5, #0
	sub r3, #8
	bl ov112_021E9998
	mov r4, #0
	add r7, r4, #0
_021E9A5E:
	add r5, r7, #0
_021E9A60:
	add r0, r6, #0
	add r1, r5, #0
	add r2, r4, #0
	bl ov112_021E98F8
	add r5, r5, #1
	cmp r5, #0x40
	blt _021E9A60
	add r4, r4, #1
	cmp r4, #0x30
	blt _021E9A5E
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov112_021E9A30

	thumb_func_start ov112_021E9A78
ov112_021E9A78: ; 0x021E9A78
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	str r1, [sp]
	cmp r1, #8
	blt _021E9A86
	bl GF_AssertFail
_021E9A86:
	ldr r0, [sp]
	cmp r0, #7
	bls _021E9A8E
	b _021E9BC8
_021E9A8E:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E9A9A: ; jump table
	.short _021E9AAA - _021E9A9A - 2 ; case 0
	.short _021E9ACE - _021E9A9A - 2 ; case 1
	.short _021E9AF2 - _021E9A9A - 2 ; case 2
	.short _021E9B16 - _021E9A9A - 2 ; case 3
	.short _021E9B3A - _021E9A9A - 2 ; case 4
	.short _021E9B5E - _021E9A9A - 2 ; case 5
	.short _021E9B82 - _021E9A9A - 2 ; case 6
	.short _021E9BA6 - _021E9A9A - 2 ; case 7
_021E9AAA:
	ldr r0, _021E9BD8 ; =0x0001EBA8
	ldr r6, _021E9BDC ; =ov112_021FF608
	mov r4, #0
	add r7, r5, r0
_021E9AB2:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #7
	blo _021E9AB2
	ldr r1, _021E9BE0 ; =0x0001EC4B
	ldr r0, [sp]
	strb r0, [r5, r1]
	b _021E9BC8
_021E9ACE:
	ldr r0, _021E9BE4 ; =0x0001EA68
	ldr r6, _021E9BE8 ; =ov112_021FF5D8
	mov r4, #0
	add r7, r5, r0
_021E9AD6:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #6
	blo _021E9AD6
	ldr r1, _021E9BEC ; =0x0001EC4A
	ldr r0, [sp]
	strb r0, [r5, r1]
	b _021E9BC8
_021E9AF2:
	ldr r0, _021E9BD8 ; =0x0001EBA8
	ldr r6, _021E9BF0 ; =ov112_021FF5D0
	mov r4, #0
	add r7, r5, r0
_021E9AFA:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #2
	blo _021E9AFA
	ldr r1, _021E9BE0 ; =0x0001EC4B
	ldr r0, [sp]
	strb r0, [r5, r1]
	b _021E9BC8
_021E9B16:
	ldr r0, _021E9BE4 ; =0x0001EA68
	ldr r6, _021E9BF4 ; =ov112_021FF640
	mov r4, #0
	add r7, r5, r0
_021E9B1E:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #8
	blo _021E9B1E
	ldr r1, _021E9BEC ; =0x0001EC4A
	ldr r0, [sp]
	strb r0, [r5, r1]
	b _021E9BC8
_021E9B3A:
	ldr r0, _021E9BE4 ; =0x0001EA68
	ldr r6, _021E9BF8 ; =ov112_021FF660
	mov r4, #0
	add r7, r5, r0
_021E9B42:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #9
	blo _021E9B42
	ldr r1, _021E9BEC ; =0x0001EC4A
	ldr r0, [sp]
	strb r0, [r5, r1]
	b _021E9BC8
_021E9B5E:
	ldr r0, _021E9BE4 ; =0x0001EA68
	ldr r6, _021E9BFC ; =ov112_021FF624
	mov r4, #0
	add r7, r5, r0
_021E9B66:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #7
	blo _021E9B66
	ldr r1, _021E9BEC ; =0x0001EC4A
	ldr r0, [sp]
	strb r0, [r5, r1]
	b _021E9BC8
_021E9B82:
	ldr r0, _021E9BE4 ; =0x0001EA68
	ldr r6, _021E9C00 ; =ov112_021FF684
	mov r4, #0
	add r7, r5, r0
_021E9B8A:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #0x10
	blo _021E9B8A
	ldr r1, _021E9BEC ; =0x0001EC4A
	ldr r0, [sp]
	strb r0, [r5, r1]
	b _021E9BC8
_021E9BA6:
	ldr r0, _021E9BE4 ; =0x0001EA68
	ldr r6, _021E9C04 ; =ov112_021FF5F0
	mov r4, #0
	add r7, r5, r0
_021E9BAE:
	ldr r0, [r5, #0x18]
	ldr r2, [r6]
	add r1, r7, #0
	bl AddWindow
	add r4, r4, #1
	add r6, r6, #4
	add r7, #0x10
	cmp r4, #6
	blo _021E9BAE
	ldr r1, _021E9BE0 ; =0x0001EC4B
	ldr r0, [sp]
	strb r0, [r5, r1]
_021E9BC8:
	ldr r1, _021E9C08 ; =ov112_021FEC80
	ldr r0, [sp]
	ldrb r0, [r1, r0]
	add r1, r5, r0
	ldr r0, _021E9C0C ; =0x0001EC48
	strb r4, [r1, r0]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9BD8: .word 0x0001EBA8
_021E9BDC: .word ov112_021FF608
_021E9BE0: .word 0x0001EC4B
_021E9BE4: .word 0x0001EA68
_021E9BE8: .word ov112_021FF5D8
_021E9BEC: .word 0x0001EC4A
_021E9BF0: .word ov112_021FF5D0
_021E9BF4: .word ov112_021FF640
_021E9BF8: .word ov112_021FF660
_021E9BFC: .word ov112_021FF624
_021E9C00: .word ov112_021FF684
_021E9C04: .word ov112_021FF5F0
_021E9C08: .word ov112_021FEC80
_021E9C0C: .word 0x0001EC48
	thumb_func_end ov112_021E9A78

	thumb_func_start ov112_021E9C10
ov112_021E9C10: ; 0x021E9C10
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _021E9C78 ; =ov112_021FEC80
	ldrb r0, [r0, r1]
	cmp r0, #0
	bne _021E9C48
	ldr r0, _021E9C7C ; =0x0001EC48
	mov r4, #0
	ldrb r0, [r5, r0]
	cmp r0, #0
	ble _021E9C40
	ldr r0, _021E9C80 ; =0x0001EA68
	ldr r7, _021E9C7C ; =0x0001EC48
	add r6, r5, r0
_021E9C2C:
	lsl r0, r4, #4
	add r0, r6, r0
	bl RemoveWindow
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldrb r0, [r5, r7]
	cmp r4, r0
	blt _021E9C2C
_021E9C40:
	ldr r0, _021E9C84 ; =0x0001EC4A
	mov r1, #0xff
	strb r1, [r5, r0]
	pop {r3, r4, r5, r6, r7, pc}
_021E9C48:
	ldr r0, _021E9C88 ; =0x0001EC49
	mov r4, #0
	ldrb r0, [r5, r0]
	cmp r0, #0
	ble _021E9C6E
	ldr r0, _021E9C8C ; =0x0001EBA8
	add r7, r0, #0
	add r6, r5, r0
	add r7, #0xa1
_021E9C5A:
	lsl r0, r4, #4
	add r0, r6, r0
	bl RemoveWindow
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldrb r0, [r5, r7]
	cmp r4, r0
	blt _021E9C5A
_021E9C6E:
	ldr r0, _021E9C90 ; =0x0001EC4B
	mov r1, #0xff
	strb r1, [r5, r0]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9C78: .word ov112_021FEC80
_021E9C7C: .word 0x0001EC48
_021E9C80: .word 0x0001EA68
_021E9C84: .word 0x0001EC4A
_021E9C88: .word 0x0001EC49
_021E9C8C: .word 0x0001EBA8
_021E9C90: .word 0x0001EC4B
	thumb_func_end ov112_021E9C10

	thumb_func_start ov112_021E9C94
ov112_021E9C94: ; 0x021E9C94
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021E9C94

	thumb_func_start ov112_021E9C98
ov112_021E9C98: ; 0x021E9C98
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E9DD4 ; =0x0001E44C
	mov r1, #0x4c
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	ldr r1, _021E9DD8 ; =0x0001E458
	str r0, [r4, r1]
	sub r1, #0xc
	ldr r0, [r4, r1]
	mov r1, #0x49
	bl NewString_ReadMsgData
	ldr r1, _021E9DDC ; =0x0001E45C
	str r0, [r4, r1]
	sub r1, #0x10
	ldr r0, [r4, r1]
	mov r1, #0x4a
	bl NewString_ReadMsgData
	ldr r1, _021E9DE0 ; =0x0001E460
	str r0, [r4, r1]
	sub r1, #0x14
	ldr r0, [r4, r1]
	mov r1, #0x4b
	bl NewString_ReadMsgData
	ldr r1, _021E9DE4 ; =0x0001E464
	str r0, [r4, r1]
	sub r1, #0x18
	ldr r0, [r4, r1]
	mov r1, #0x4e
	bl NewString_ReadMsgData
	ldr r1, _021E9DE8 ; =0x0001E468
	str r0, [r4, r1]
	sub r1, #0x1c
	ldr r0, [r4, r1]
	mov r1, #0x4d
	bl NewString_ReadMsgData
	ldr r1, _021E9DEC ; =0x0001E46C
	str r0, [r4, r1]
	sub r1, #0x20
	ldr r0, [r4, r1]
	mov r1, #0x50
	bl NewString_ReadMsgData
	ldr r1, _021E9DF0 ; =0x0001E470
	str r0, [r4, r1]
	sub r1, #0x24
	ldr r0, [r4, r1]
	mov r1, #0x4f
	bl NewString_ReadMsgData
	ldr r1, _021E9DF4 ; =0x0001E474
	str r0, [r4, r1]
	sub r1, #0x28
	ldr r0, [r4, r1]
	mov r1, #0x3f
	bl NewString_ReadMsgData
	ldr r1, _021E9DF8 ; =0x0001E494
	str r0, [r4, r1]
	sub r1, #0x48
	ldr r0, [r4, r1]
	mov r1, #0x40
	bl NewString_ReadMsgData
	ldr r1, _021E9DFC ; =0x0001E498
	str r0, [r4, r1]
	sub r1, #0x4c
	ldr r0, [r4, r1]
	mov r1, #0x41
	bl NewString_ReadMsgData
	ldr r1, _021E9E00 ; =0x0001E49C
	str r0, [r4, r1]
	sub r1, #0x50
	ldr r0, [r4, r1]
	mov r1, #0x42
	bl NewString_ReadMsgData
	ldr r1, _021E9E04 ; =0x0001E4A0
	str r0, [r4, r1]
	sub r1, #0x54
	ldr r0, [r4, r1]
	mov r1, #0x47
	bl NewString_ReadMsgData
	ldr r1, _021E9E08 ; =0x0001E4A4
	str r0, [r4, r1]
	sub r1, #0x58
	ldr r0, [r4, r1]
	mov r1, #0x3f
	bl NewString_ReadMsgData
	ldr r1, _021E9E0C ; =0x0001E4A8
	str r0, [r4, r1]
	sub r1, #0x5c
	ldr r0, [r4, r1]
	mov r1, #0x47
	bl NewString_ReadMsgData
	ldr r1, _021E9E10 ; =0x0001E4AC
	str r0, [r4, r1]
	sub r1, #0x60
	ldr r0, [r4, r1]
	mov r1, #0x4f
	bl NewString_ReadMsgData
	ldr r1, _021E9E14 ; =0x0001E4B0
	str r0, [r4, r1]
	sub r1, #0x64
	ldr r0, [r4, r1]
	mov r1, #0x3b
	bl NewString_ReadMsgData
	ldr r1, _021E9E18 ; =0x0001E4B4
	str r0, [r4, r1]
	sub r1, #0x68
	ldr r0, [r4, r1]
	mov r1, #0x3d
	bl NewString_ReadMsgData
	ldr r1, _021E9E1C ; =0x0001E4BC
	str r0, [r4, r1]
	sub r1, #0x70
	ldr r0, [r4, r1]
	mov r1, #0x52
	bl NewString_ReadMsgData
	ldr r1, _021E9E20 ; =0x0001E50C
	str r0, [r4, r1]
	sub r1, #0xc0
	ldr r0, [r4, r1]
	mov r1, #0x55
	bl NewString_ReadMsgData
	ldr r1, _021E9E24 ; =0x0001E510
	str r0, [r4, r1]
	sub r1, #0xc4
	ldr r0, [r4, r1]
	mov r1, #0x94
	bl NewString_ReadMsgData
	ldr r1, _021E9E28 ; =0x0001E514
	str r0, [r4, r1]
	sub r1, #0xc8
	ldr r0, [r4, r1]
	mov r1, #0x95
	bl NewString_ReadMsgData
	ldr r1, _021E9E2C ; =0x0001E518
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_021E9DD4: .word 0x0001E44C
_021E9DD8: .word 0x0001E458
_021E9DDC: .word 0x0001E45C
_021E9DE0: .word 0x0001E460
_021E9DE4: .word 0x0001E464
_021E9DE8: .word 0x0001E468
_021E9DEC: .word 0x0001E46C
_021E9DF0: .word 0x0001E470
_021E9DF4: .word 0x0001E474
_021E9DF8: .word 0x0001E494
_021E9DFC: .word 0x0001E498
_021E9E00: .word 0x0001E49C
_021E9E04: .word 0x0001E4A0
_021E9E08: .word 0x0001E4A4
_021E9E0C: .word 0x0001E4A8
_021E9E10: .word 0x0001E4AC
_021E9E14: .word 0x0001E4B0
_021E9E18: .word 0x0001E4B4
_021E9E1C: .word 0x0001E4BC
_021E9E20: .word 0x0001E50C
_021E9E24: .word 0x0001E510
_021E9E28: .word 0x0001E514
_021E9E2C: .word 0x0001E518
	thumb_func_end ov112_021E9C98

	thumb_func_start ov112_021E9E30
ov112_021E9E30: ; 0x021E9E30
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E9EE8 ; =0x0001E458
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9EEC ; =0x0001E45C
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9EF0 ; =0x0001E460
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9EF4 ; =0x0001E464
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9EF8 ; =0x0001E468
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9EFC ; =0x0001E46C
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F00 ; =0x0001E470
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F04 ; =0x0001E474
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F08 ; =0x0001E494
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F0C ; =0x0001E49C
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F10 ; =0x0001E498
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F14 ; =0x0001E4A0
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F18 ; =0x0001E4A4
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F1C ; =0x0001E4A8
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F20 ; =0x0001E4AC
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F24 ; =0x0001E4B0
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F28 ; =0x0001E4B4
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F2C ; =0x0001E4BC
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F30 ; =0x0001E50C
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F34 ; =0x0001E510
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F38 ; =0x0001E514
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _021E9F3C ; =0x0001E518
	ldr r0, [r4, r0]
	bl String_Delete
	pop {r4, pc}
	nop
_021E9EE8: .word 0x0001E458
_021E9EEC: .word 0x0001E45C
_021E9EF0: .word 0x0001E460
_021E9EF4: .word 0x0001E464
_021E9EF8: .word 0x0001E468
_021E9EFC: .word 0x0001E46C
_021E9F00: .word 0x0001E470
_021E9F04: .word 0x0001E474
_021E9F08: .word 0x0001E494
_021E9F0C: .word 0x0001E49C
_021E9F10: .word 0x0001E498
_021E9F14: .word 0x0001E4A0
_021E9F18: .word 0x0001E4A4
_021E9F1C: .word 0x0001E4A8
_021E9F20: .word 0x0001E4AC
_021E9F24: .word 0x0001E4B0
_021E9F28: .word 0x0001E4B4
_021E9F2C: .word 0x0001E4BC
_021E9F30: .word 0x0001E50C
_021E9F34: .word 0x0001E510
_021E9F38: .word 0x0001E514
_021E9F3C: .word 0x0001E518
	thumb_func_end ov112_021E9E30

	thumb_func_start ov112_021E9F40
ov112_021E9F40: ; 0x021E9F40
	push {r3, lr}
	ldr r2, _021E9F54 ; =0x000F0100
	mov r3, #4
	str r2, [sp]
	ldr r2, _021E9F58 ; =0x0001E474
	ldr r2, [r0, r2]
	bl ov112_021E9FA4
	pop {r3, pc}
	nop
_021E9F54: .word 0x000F0100
_021E9F58: .word 0x0001E474
	thumb_func_end ov112_021E9F40

	thumb_func_start ov112_021E9F5C
ov112_021E9F5C: ; 0x021E9F5C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _021E9F98 ; =0x0001E44C
	add r7, r1, #0
	ldr r0, [r5, r0]
	add r1, r2, #0
	add r4, r3, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r1, _021E9F9C ; =0x0001E448
	add r2, r6, #0
	ldr r0, [r5, r1]
	add r1, #0xc
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	ldr r2, _021E9FA0 ; =0x0001E454
	str r4, [sp]
	ldr r2, [r5, r2]
	add r0, r5, #0
	add r1, r7, #0
	mov r3, #0
	bl ov112_021E9FA4
	add r0, r6, #0
	bl String_Delete
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9F98: .word 0x0001E44C
_021E9F9C: .word 0x0001E448
_021E9FA0: .word 0x0001E454
	thumb_func_end ov112_021E9F5C

	thumb_func_start ov112_021E9FA4
ov112_021E9FA4: ; 0x021E9FA4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r6, r2, #0
	ldr r2, _021E9FD4 ; =0x0001EA68
	lsl r4, r1, #4
	add r5, r0, r2
	add r0, r5, r4
	mov r1, #0
	add r7, r3, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	ldr r0, [sp, #0x28]
	str r3, [sp, #4]
	str r0, [sp, #8]
	add r0, r5, r4
	add r1, r7, #0
	add r2, r6, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E9FD4: .word 0x0001EA68
	thumb_func_end ov112_021E9FA4

	thumb_func_start ov112_021E9FD8
ov112_021E9FD8: ; 0x021E9FD8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r6, r2, #0
	ldr r2, _021EA008 ; =0x0001EA68
	lsl r4, r1, #4
	add r5, r0, r2
	add r0, r5, r4
	mov r1, #0
	add r7, r3, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	ldr r0, _021EA00C ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	add r0, r5, r4
	add r1, r7, #0
	add r2, r6, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EA008: .word 0x0001EA68
_021EA00C: .word 0x00010200
	thumb_func_end ov112_021E9FD8

	thumb_func_start ov112_021EA010
ov112_021EA010: ; 0x021EA010
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r6, r2, #0
	ldr r2, _021EA040 ; =0x0001EBA8
	lsl r4, r1, #4
	add r5, r0, r2
	add r0, r5, r4
	mov r1, #0
	add r7, r3, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	ldr r0, [sp, #0x28]
	str r3, [sp, #4]
	str r0, [sp, #8]
	add r0, r5, r4
	add r1, r7, #0
	add r2, r6, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EA040: .word 0x0001EBA8
	thumb_func_end ov112_021EA010

	thumb_func_start ov112_021EA044
ov112_021EA044: ; 0x021EA044
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _021EA080 ; =0x0001E44C
	add r7, r1, #0
	ldr r0, [r5, r0]
	add r1, r2, #0
	add r4, r3, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r1, _021EA084 ; =0x0001E448
	add r2, r6, #0
	ldr r0, [r5, r1]
	add r1, #0xc
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	ldr r2, _021EA088 ; =0x0001E454
	str r4, [sp]
	ldr r2, [r5, r2]
	add r0, r5, #0
	add r1, r7, #0
	mov r3, #0
	bl ov112_021EA010
	add r0, r6, #0
	bl String_Delete
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EA080: .word 0x0001E44C
_021EA084: .word 0x0001E448
_021EA088: .word 0x0001E454
	thumb_func_end ov112_021EA044

	thumb_func_start ov112_021EA08C
ov112_021EA08C: ; 0x021EA08C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, _021EA0F4 ; =0x0001E44C
	add r6, r1, #0
	ldr r0, [r5, r0]
	add r1, r2, #0
	bl NewString_ReadMsgData
	add r7, r0, #0
	ldr r0, _021EA0F8 ; =0x0001EA68
	lsl r6, r6, #4
	add r4, r5, r0
	ldr r2, _021EA0FC ; =0x000003E2
	add r0, r4, r6
	mov r1, #1
	mov r3, #0xd
	bl DrawFrameAndWindow2
	add r0, r4, r6
	mov r1, #0xff
	bl FillWindowPixelBuffer
	ldr r1, _021EA100 ; =0x0001E448
	add r2, r7, #0
	ldr r0, [r5, r1]
	add r1, #0xc
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	ldr r0, _021EA104 ; =0x0001E43C
	ldr r0, [r5, r0]
	bl Options_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	ldr r2, _021EA108 ; =0x0001E454
	str r3, [sp, #8]
	ldr r2, [r5, r2]
	add r0, r4, r6
	mov r1, #1
	bl AddTextPrinterParameterized
	add r4, r0, #0
	add r0, r7, #0
	bl String_Delete
	add r0, r4, #0
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021EA0F4: .word 0x0001E44C
_021EA0F8: .word 0x0001EA68
_021EA0FC: .word 0x000003E2
_021EA100: .word 0x0001E448
_021EA104: .word 0x0001E43C
_021EA108: .word 0x0001E454
	thumb_func_end ov112_021EA08C

	thumb_func_start ov112_021EA10C
ov112_021EA10C: ; 0x021EA10C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, _021EA168 ; =0x0001E44C
	add r6, r1, #0
	ldr r0, [r5, r0]
	add r1, r2, #0
	bl NewString_ReadMsgData
	add r7, r0, #0
	ldr r0, _021EA16C ; =0x0001EA68
	lsl r6, r6, #4
	add r4, r5, r0
	ldr r2, _021EA170 ; =0x000003E2
	add r0, r4, r6
	mov r1, #1
	mov r3, #0xd
	bl DrawFrameAndWindow2
	add r0, r4, r6
	mov r1, #0xff
	bl FillWindowPixelBuffer
	ldr r1, _021EA174 ; =0x0001E448
	add r2, r7, #0
	ldr r0, [r5, r1]
	add r1, #0xc
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	mov r3, #0
	str r3, [sp]
	str r3, [sp, #4]
	ldr r2, _021EA178 ; =0x0001E454
	str r3, [sp, #8]
	ldr r2, [r5, r2]
	add r0, r4, r6
	mov r1, #1
	bl AddTextPrinterParameterized
	add r0, r7, #0
	bl String_Delete
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021EA168: .word 0x0001E44C
_021EA16C: .word 0x0001EA68
_021EA170: .word 0x000003E2
_021EA174: .word 0x0001E448
_021EA178: .word 0x0001E454
	thumb_func_end ov112_021EA10C

	thumb_func_start ov112_021EA17C
ov112_021EA17C: ; 0x021EA17C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EA190 ; =0x0001EA88
	ldr r1, _021EA194 ; =0x000003E2
	add r0, r4, r0
	bl WaitingIcon_New
	ldr r1, _021EA198 ; =0x0001EC4C
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021EA190: .word 0x0001EA88
_021EA194: .word 0x000003E2
_021EA198: .word 0x0001EC4C
	thumb_func_end ov112_021EA17C

	thumb_func_start ov112_021EA19C
ov112_021EA19C: ; 0x021EA19C
	ldr r1, _021EA1A4 ; =0x0001EC4C
	ldr r3, _021EA1A8 ; =sub_0200F450
	ldr r0, [r0, r1]
	bx r3
	.balign 4, 0
_021EA1A4: .word 0x0001EC4C
_021EA1A8: .word sub_0200F450
	thumb_func_end ov112_021EA19C

	thumb_func_start ov112_021EA1AC
ov112_021EA1AC: ; 0x021EA1AC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0x40
	mov r1, #0x9a
	bl GF_CreateVramTransferManager
	add r0, r4, #0
	bl ov112_021EA230
	add r0, r4, #0
	bl ov112_021EA2C4
	add r0, r4, #0
	bl ov112_021EA3C0
	ldr r0, _021EA1F4 ; =0x0001E528
	ldr r0, [r4, r0]
	bl SpriteSystem_GetRenderer
	mov r2, #1
	mov r1, #0
	lsl r2, r2, #0x14
	bl G2dRenderer_SetSubSurfaceCoords
	bl ov112_021EAB58
	pop {r4, pc}
	nop
_021EA1F4: .word 0x0001E528
	thumb_func_end ov112_021EA1AC

	thumb_func_start ov112_021EA1F8
ov112_021EA1F8: ; 0x021EA1F8
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	ldr r6, _021EA228 ; =0x0001E530
	mov r4, #0
	add r5, r7, #0
_021EA202:
	ldr r0, [r5, r6]
	bl Sprite_DeleteAndFreeResources
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0xd9
	blo _021EA202
	ldr r1, _021EA22C ; =0x0001E528
	ldr r0, [r7, r1]
	add r1, r1, #4
	ldr r1, [r7, r1]
	bl SpriteSystem_FreeResourcesAndManager
	ldr r0, _021EA22C ; =0x0001E528
	ldr r0, [r7, r0]
	bl SpriteSystem_Free
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EA228: .word 0x0001E530
_021EA22C: .word 0x0001E528
	thumb_func_end ov112_021EA1F8

	thumb_func_start ov112_021EA230
ov112_021EA230: ; 0x021EA230
	push {r4, r5, r6, r7, lr}
	sub sp, #0x4c
	ldr r3, _021EA2B0 ; =ov112_021FECAC
	add r2, sp, #0x34
	add r4, r0, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	mov r0, #0x9a
	bl SpriteSystem_Alloc
	ldr r1, _021EA2B4 ; =0x0001E528
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	bl SpriteManager_New
	ldr r7, _021EA2B8 ; =0x0001E52C
	add r2, sp, #0x14
	ldr r3, _021EA2BC ; =ov112_021FECC4
	str r0, [r4, r7]
	ldmia r3!, {r0, r1}
	add r6, r2, #0
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	ldr r5, _021EA2C0 ; =ov112_021FEC98
	stmia r2!, {r0, r1}
	add r3, sp, #0
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
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0xd9
	bl SpriteSystem_InitSprites
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	add r2, sp, #0x34
	bl SpriteSystem_InitManagerWithCapacities
	add sp, #0x4c
	pop {r4, r5, r6, r7, pc}
	nop
_021EA2B0: .word ov112_021FECAC
_021EA2B4: .word 0x0001E528
_021EA2B8: .word 0x0001E52C
_021EA2BC: .word ov112_021FECC4
_021EA2C0: .word ov112_021FEC98
	thumb_func_end ov112_021EA230

	thumb_func_start ov112_021EA2C4
ov112_021EA2C4: ; 0x021EA2C4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0xf9
	mov r1, #0x9a
	bl NARC_New
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021EA3B4 ; =0x0000C226
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #7
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021EA3B4 ; =0x0000C226
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #3
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _021EA3B4 ; =0x0000C226
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #0x14
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _021EA3B4 ; =0x0000C226
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #0x16
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021EA3BC ; =0x0000C227
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #6
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, _021EA3BC ; =0x0000C227
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #2
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _021EA3BC ; =0x0000C227
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #0x13
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _021EA3BC ; =0x0000C227
	ldr r1, _021EA3B8 ; =0x0001E528
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r4, #0
	mov r3, #0x15
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021EA3B4: .word 0x0000C226
_021EA3B8: .word 0x0001E528
_021EA3BC: .word 0x0000C227
	thumb_func_end ov112_021EA2C4

	thumb_func_start ov112_021EA3C0
ov112_021EA3C0: ; 0x021EA3C0
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	ldr r0, _021EA4C8 ; =ov112_021FED1C
	ldr r7, _021EA4CC ; =ov112_021FEC88
	mov r6, #0
	str r0, [sp]
	add r5, r4, #0
_021EA3CE:
	ldr r0, _021EA4D0 ; =0x0001E528
	ldr r1, _021EA4D4 ; =0x0001E52C
	mov r3, #1
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, [sp]
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021EA4D8 ; =0x0001E530
	str r0, [r5, r1]
	add r0, r1, #0
	ldrb r1, [r7]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPaletteOverride
	ldr r0, _021EA4D8 ; =0x0001E530
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, [sp]
	add r6, r6, #1
	add r0, #0x34
	str r0, [sp]
	add r5, r5, #4
	add r7, r7, #1
	cmp r6, #0x11
	blo _021EA3CE
	ldr r0, _021EA4DC ; =0x0001E534
	mov r1, #2
	ldr r0, [r4, r0]
	bl ManagedSprite_SetPriority
	cmp r6, #0x75
	bhs _021EA452
	lsl r0, r6, #2
	ldr r7, _021EA4D8 ; =0x0001E530
	add r5, r4, r0
_021EA41C:
	ldr r0, _021EA4D0 ; =0x0001E528
	ldr r1, _021EA4D4 ; =0x0001E52C
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021EA4E0 ; =ov112_021FF028
	bl SpriteSystem_NewSprite
	ldr r1, _021EA4D8 ; =0x0001E530
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetPaletteOverride
	ldr r0, _021EA4D8 ; =0x0001E530
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r5, r7]
	mov r1, #2
	bl ManagedSprite_SetPriority
	add r6, r6, #1
	add r5, r5, #4
	cmp r6, #0x75
	blo _021EA41C
_021EA452:
	cmp r6, #0xd9
	bhs _021EA496
	lsl r0, r6, #2
	ldr r7, _021EA4D8 ; =0x0001E530
	add r5, r4, r0
_021EA45C:
	ldr r0, _021EA4D0 ; =0x0001E528
	ldr r1, _021EA4D4 ; =0x0001E52C
	mov r3, #1
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021EA4E4 ; =ov112_021FF05C
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021EA4D8 ; =0x0001E530
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetPaletteOverride
	ldr r0, _021EA4D8 ; =0x0001E530
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r5, r7]
	mov r1, #2
	bl ManagedSprite_SetPriority
	add r6, r6, #1
	add r5, r5, #4
	cmp r6, #0xd9
	blo _021EA45C
_021EA496:
	add r0, r4, #0
	bl ov112_021EA984
	ldr r0, _021EA4E8 ; =0x0001E550
	mov r1, #2
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawPriority
	ldr r0, _021EA4E8 ; =0x0001E550
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAffineOverwriteMode
	ldr r0, _021EA4EC ; =0x0001E53C
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimateFlag
	ldr r0, _021EA4F0 ; =0x0001E540
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimateFlag
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EA4C8: .word ov112_021FED1C
_021EA4CC: .word ov112_021FEC88
_021EA4D0: .word 0x0001E528
_021EA4D4: .word 0x0001E52C
_021EA4D8: .word 0x0001E530
_021EA4DC: .word 0x0001E534
_021EA4E0: .word ov112_021FF028
_021EA4E4: .word ov112_021FF05C
_021EA4E8: .word 0x0001E550
_021EA4EC: .word 0x0001E53C
_021EA4F0: .word 0x0001E540
	thumb_func_end ov112_021EA3C0

	thumb_func_start ov112_021EA4F4
ov112_021EA4F4: ; 0x021EA4F4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EA518 ; =0x0001E530
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimateFlag
	ldr r0, _021EA518 ; =0x0001E530
	mov r1, #8
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
	ldr r0, _021EA518 ; =0x0001E530
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	pop {r4, pc}
	.balign 4, 0
_021EA518: .word 0x0001E530
	thumb_func_end ov112_021EA4F4

	thumb_func_start ov112_021EA51C
ov112_021EA51C: ; 0x021EA51C
	push {r3, r4, r5, lr}
	lsl r4, r1, #2
	ldr r1, _021EA55C ; =ov112_021FECE4
	ldr r2, _021EA560 ; =ov112_021FECE5
	add r5, r0, #0
	ldr r0, _021EA564 ; =0x0001E530
	mov r3, #1
	ldrb r1, [r1, r4]
	ldrb r2, [r2, r4]
	ldr r0, [r5, r0]
	lsl r3, r3, #0x14
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	ldr r1, _021EA568 ; =ov112_021FECE6
	ldr r0, _021EA564 ; =0x0001E530
	ldrb r1, [r1, r4]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetAnim
	ldr r1, _021EA56C ; =ov112_021FECE7
	ldr r0, _021EA564 ; =0x0001E530
	ldrb r1, [r1, r4]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPaletteOverride
	ldr r0, _021EA564 ; =0x0001E530
	mov r1, #1
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	nop
_021EA55C: .word ov112_021FECE4
_021EA560: .word ov112_021FECE5
_021EA564: .word 0x0001E530
_021EA568: .word ov112_021FECE6
_021EA56C: .word ov112_021FECE7
	thumb_func_end ov112_021EA51C

	thumb_func_start ov112_021EA570
ov112_021EA570: ; 0x021EA570
	ldr r1, _021EA57C ; =0x0001E530
	ldr r3, _021EA580 ; =ManagedSprite_SetDrawFlag
	ldr r0, [r0, r1]
	mov r1, #0
	bx r3
	nop
_021EA57C: .word 0x0001E530
_021EA580: .word ManagedSprite_SetDrawFlag
	thumb_func_end ov112_021EA570

	thumb_func_start ov112_021EA584
ov112_021EA584: ; 0x021EA584
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EA5A0 ; =0x0001E530
	ldr r0, [r4, r0]
	bl ManagedSprite_GetActiveAnim
	add r1, r0, #0
	ldr r0, _021EA5A0 ; =0x0001E530
	add r1, r1, #3
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
	pop {r4, pc}
	nop
_021EA5A0: .word 0x0001E530
	thumb_func_end ov112_021EA584

	thumb_func_start ov112_021EA5A4
ov112_021EA5A4: ; 0x021EA5A4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021EA604 ; =0x0001E534
	add r4, r1, #0
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, _021EA604 ; =0x0001E534
	mov r1, #1
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	cmp r4, #0
	bne _021EA5CE
	ldr r0, _021EA608 ; =0x0001E538
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_021EA5CE:
	ble _021EA602
	ldr r0, _021EA604 ; =0x0001E534
	mov r1, #2
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawPriority
	ldr r0, _021EA608 ; =0x0001E538
	mov r1, #1
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawPriority
	ldr r0, _021EA608 ; =0x0001E538
	mov r1, #1
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021EA608 ; =0x0001E538
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetAnim
	ldr r0, _021EA608 ; =0x0001E538
	mov r1, #1
	ldr r0, [r5, r0]
	bl ManagedSprite_SetAnimateFlag
_021EA602:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EA604: .word 0x0001E534
_021EA608: .word 0x0001E538
	thumb_func_end ov112_021EA5A4

	thumb_func_start ov112_021EA60C
ov112_021EA60C: ; 0x021EA60C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _021EA648 ; =0x0001E538
	ldr r5, [r4, r0]
	bl ov112_021E7668
	cmp r0, #0
	beq _021EA632
	add r0, r5, #0
	bl ManagedSprite_GetActiveAnim
	cmp r0, #2
	bne _021EA646
	ldr r0, _021EA648 ; =0x0001E538
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
	pop {r3, r4, r5, pc}
_021EA632:
	add r0, r5, #0
	bl ManagedSprite_GetActiveAnim
	cmp r0, #1
	bne _021EA646
	ldr r0, _021EA648 ; =0x0001E538
	mov r1, #2
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
_021EA646:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EA648: .word 0x0001E538
	thumb_func_end ov112_021EA60C

	thumb_func_start ov112_021EA64C
ov112_021EA64C: ; 0x021EA64C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EA668 ; =0x0001E534
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021EA66C ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	pop {r4, pc}
	nop
_021EA668: .word 0x0001E534
_021EA66C: .word 0x0001E538
	thumb_func_end ov112_021EA64C

	thumb_func_start ov112_021EA670
ov112_021EA670: ; 0x021EA670
	lsl r1, r1, #2
	add r1, r0, r1
	ldr r0, _021EA680 ; =0x0001E530
	ldr r3, _021EA684 ; =ManagedSprite_SetDrawFlag
	ldr r0, [r1, r0]
	mov r1, #1
	bx r3
	nop
_021EA680: .word 0x0001E530
_021EA684: .word ManagedSprite_SetDrawFlag
	thumb_func_end ov112_021EA670

	thumb_func_start ov112_021EA688
ov112_021EA688: ; 0x021EA688
	lsl r1, r1, #2
	add r1, r0, r1
	ldr r0, _021EA698 ; =0x0001E530
	ldr r3, _021EA69C ; =ManagedSprite_SetDrawFlag
	ldr r0, [r1, r0]
	mov r1, #0
	bx r3
	nop
_021EA698: .word 0x0001E530
_021EA69C: .word ManagedSprite_SetDrawFlag
	thumb_func_end ov112_021EA688

	thumb_func_start ov112_021EA6A0
ov112_021EA6A0: ; 0x021EA6A0
	lsl r1, r1, #2
	add r1, r0, r1
	ldr r0, _021EA6B0 ; =0x0001E530
	ldr r3, _021EA6B4 ; =ManagedSprite_SetAnim
	ldr r0, [r1, r0]
	add r1, r2, #0
	bx r3
	nop
_021EA6B0: .word 0x0001E530
_021EA6B4: .word ManagedSprite_SetAnim
	thumb_func_end ov112_021EA6A0

	thumb_func_start ov112_021EA6B8
ov112_021EA6B8: ; 0x021EA6B8
	push {r3, lr}
	lsl r1, r1, #2
	add r1, r0, r1
	ldr r0, _021EA6D4 ; =0x0001E530
	ldr r0, [r1, r0]
	lsl r1, r2, #0x10
	lsl r2, r3, #0x10
	mov r3, #1
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	lsl r3, r3, #0x14
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	pop {r3, pc}
	.balign 4, 0
_021EA6D4: .word 0x0001E530
	thumb_func_end ov112_021EA6B8

	thumb_func_start ov112_021EA6D8
ov112_021EA6D8: ; 0x021EA6D8
	push {r3, r4, r5, r6, r7, lr}
	str r2, [sp]
	ldr r2, [sp, #0x18]
	add r5, r0, #0
	add r4, r1, #0
	add r1, r3, #0
	cmp r2, #0
	ldr r0, _021EA768 ; =0x0001E530
	bge _021EA72A
	add r6, r5, r0
	add r0, r4, #0
	add r0, #0x75
	lsl r7, r0, #2
	add r2, #0xd0
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	mov r3, #1
	ldr r0, [r6, r7]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	lsl r3, r3, #0x14
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	ldr r1, [sp]
	ldr r0, [r6, r7]
	add r1, r1, #4
	bl ManagedSprite_SetAnim
	ldr r0, [r6, r7]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r4, #0x11
	lsl r0, r4, #2
	add r1, r5, r0
	ldr r0, _021EA768 ; =0x0001E530
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, r6, r7, pc}
_021EA72A:
	add r6, r5, r0
	add r0, r4, #0
	add r0, #0x11
	lsl r7, r0, #2
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r6, r7]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r1, [sp]
	ldr r0, [r6, r7]
	add r1, #0x13
	str r1, [sp]
	bl ManagedSprite_SetAnim
	add r4, #0x75
	lsl r0, r4, #2
	add r1, r5, r0
	ldr r0, _021EA768 ; =0x0001E530
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r6, r7]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EA768: .word 0x0001E530
	thumb_func_end ov112_021EA6D8

	thumb_func_start ov112_021EA76C
ov112_021EA76C: ; 0x021EA76C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EA7CC ; =0x0001EC80
	add r0, r4, r0
	bl ov112_021EA9A0
	cmp r0, #0
	blt _021EA7C8
	ldr r1, _021EA7CC ; =0x0001EC80
	add r2, r4, r1
	lsl r1, r0, #4
	mov r0, #1
	add r4, r2, r1
	strb r0, [r2, r1]
	bl MTRandom
	mov r1, #6
	bl _u32_div_f
	add r0, r1, #2
	strb r0, [r4, #3]
	bl MTRandom
	mov r1, #0x4b
	lsl r1, r1, #2
	bl _u32_div_f
	strh r1, [r4, #0xc]
	mov r0, #0x80
	strh r0, [r4, #4]
	mov r0, #0x74
	strh r0, [r4, #6]
	bl MTRandom
	mov r1, #0x28
	bl _u32_div_f
	add r1, #0x28
	strb r1, [r4, #2]
	bl MTRandom
	mov r1, #0x3c
	bl _u32_div_f
	add r1, #0x78
	strh r1, [r4, #0xe]
_021EA7C8:
	pop {r4, pc}
	nop
_021EA7CC: .word 0x0001EC80
	thumb_func_end ov112_021EA76C

	thumb_func_start ov112_021EA7D0
ov112_021EA7D0: ; 0x021EA7D0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EA834 ; =0x0001EC80
	add r0, r4, r0
	bl ov112_021EA9A0
	cmp r0, #0
	blt _021EA832
	ldr r1, _021EA834 ; =0x0001EC80
	add r2, r4, r1
	lsl r1, r0, #4
	mov r0, #1
	add r4, r2, r1
	strb r0, [r2, r1]
	bl MTRandom
	mov r1, #5
	bl _u32_div_f
	mov r0, #0
	add r1, r1, #5
	mvn r0, r0
	mul r0, r1
	strb r0, [r4, #3]
	bl MTRandom
	mov r1, #0x4b
	lsl r1, r1, #2
	bl _u32_div_f
	strh r1, [r4, #0xc]
	mov r0, #0x80
	strh r0, [r4, #4]
	sub r0, #0xed
	strh r0, [r4, #6]
	bl MTRandom
	mov r1, #0x28
	bl _u32_div_f
	add r1, #0x28
	strb r1, [r4, #2]
	bl MTRandom
	mov r1, #0x3c
	bl _u32_div_f
	add r1, #0x78
	strh r1, [r4, #0xe]
_021EA832:
	pop {r4, pc}
	.balign 4, 0
_021EA834: .word 0x0001EC80
	thumb_func_end ov112_021EA7D0

	thumb_func_start ov112_021EA838
ov112_021EA838: ; 0x021EA838
	push {r3, r4}
	ldr r1, _021EA860 ; =0x0001EC80
	mov r3, #0
	add r4, r0, r1
	add r2, r3, #0
	mov r0, #0xe
_021EA844:
	ldrb r1, [r4]
	cmp r1, #0
	beq _021EA852
	ldrsh r1, [r4, r0]
	add r3, r3, #1
	sub r1, #0x14
	strh r1, [r4, #0xe]
_021EA852:
	add r2, r2, #1
	add r4, #0x10
	cmp r2, #0x64
	blt _021EA844
	add r0, r3, #0
	pop {r3, r4}
	bx lr
	.balign 4, 0
_021EA860: .word 0x0001EC80
	thumb_func_end ov112_021EA838

	thumb_func_start ov112_021EA864
ov112_021EA864: ; 0x021EA864
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	ldr r1, _021EA978 ; =0x0001EC80
	str r0, [sp, #4]
	mov r6, #0
	add r4, r0, r1
	add r5, r0, #0
_021EA872:
	mov r0, #2
	ldrsb r1, [r4, r0]
	mov r0, #6
	ldrsh r0, [r4, r0]
	add r0, #0xb4
	mul r0, r1
	mov r1, #5
	lsl r1, r1, #6
	bl _s32_div_f
	add r7, r0, #0
	ldrb r0, [r4]
	cmp r0, #0
	beq _021EA968
	ldrh r0, [r4, #0xc]
	bl GF_SinDeg
	mov r1, #0x5a
	lsl r1, r1, #2
	bl _s32_div_f
	strh r0, [r4, #0xa]
	ldrh r0, [r4, #0xc]
	bl GF_CosDeg
	add r1, r7, #0
	mul r1, r0
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r0, r0, #0xc
	strh r0, [r4, #8]
	ldrh r0, [r4, #0xc]
	mov r1, #0x5a
	lsl r1, r1, #2
	add r0, #0xa
	strh r0, [r4, #0xc]
	ldrh r0, [r4, #0xc]
	bl _s32_div_f
	add r0, r1, #0
	mov r1, #0x49
	bl _s32_div_f
	add r2, r0, #0
	mov r0, #6
	ldrsh r1, [r4, r0]
	mov r0, #0xa
	ldrsh r0, [r4, r0]
	mov r3, #4
	add r0, r1, r0
	str r0, [sp]
	ldrsh r7, [r4, r3]
	mov r3, #8
	ldrsh r3, [r4, r3]
	ldr r0, [sp, #4]
	add r1, r6, #0
	add r3, r7, r3
	bl ov112_021EA6D8
	mov r0, #6
	ldrsh r1, [r4, r0]
	mov r0, #3
	ldrsb r0, [r4, r0]
	sub r0, r1, r0
	strh r0, [r4, #6]
	mov r0, #0xe
	ldrsh r0, [r4, r0]
	sub r0, r0, #1
	strh r0, [r4, #0xe]
	mov r0, #6
	ldrsh r1, [r4, r0]
	sub r0, #0x74
	cmp r1, r0
	blt _021EA914
	mov r0, #0xe
	ldrsh r0, [r4, r0]
	cmp r0, #0
	blt _021EA914
	cmp r1, #0xa0
	ble _021EA92C
_021EA914:
	mov r0, #0
	strb r0, [r4]
	ldr r0, _021EA97C ; =0x0001E704
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021EA980 ; =0x0001E574
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
_021EA92C:
	ldrh r0, [r4, #0xc]
	mov r1, #0x5a
	lsl r1, r1, #2
	bl _s32_div_f
	cmp r1, #0
	blt _021EA954
	cmp r1, #0xb4
	bgt _021EA954
	ldr r0, _021EA97C ; =0x0001E704
	mov r1, #1
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawPriority
	ldr r0, _021EA980 ; =0x0001E574
	mov r1, #1
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawPriority
	b _021EA968
_021EA954:
	ldr r0, _021EA97C ; =0x0001E704
	mov r1, #3
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawPriority
	ldr r0, _021EA980 ; =0x0001E574
	mov r1, #3
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawPriority
_021EA968:
	add r6, r6, #1
	add r4, #0x10
	add r5, r5, #4
	cmp r6, #0x64
	bge _021EA974
	b _021EA872
_021EA974:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EA978: .word 0x0001EC80
_021EA97C: .word 0x0001E704
_021EA980: .word 0x0001E574
	thumb_func_end ov112_021EA864

	thumb_func_start ov112_021EA984
ov112_021EA984: ; 0x021EA984
	ldr r1, _021EA99C ; =0x0001EC80
	mov r2, #0
	add r1, r0, r1
	add r0, r2, #0
_021EA98C:
	strb r0, [r1]
	strh r0, [r1, #0xe]
	add r2, r2, #1
	add r1, #0x10
	cmp r2, #0x64
	blt _021EA98C
	bx lr
	nop
_021EA99C: .word 0x0001EC80
	thumb_func_end ov112_021EA984

	thumb_func_start ov112_021EA9A0
ov112_021EA9A0: ; 0x021EA9A0
	mov r2, #0
_021EA9A2:
	ldrb r1, [r0]
	cmp r1, #0
	bne _021EA9AC
	add r0, r2, #0
	bx lr
_021EA9AC:
	add r2, r2, #1
	add r0, #0x10
	cmp r2, #0x64
	blt _021EA9A2
	mov r0, #0
	mvn r0, r0
	bx lr
	.balign 4, 0
	thumb_func_end ov112_021EA9A0

	thumb_func_start ov112_021EA9BC
ov112_021EA9BC: ; 0x021EA9BC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #6
	ldrsh r0, [r1, r0]
	cmp r0, #0
	bge _021EA9D4
	ldr r0, _021EAA08 ; =0x0001E568
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	b _021EA9DE
_021EA9D4:
	ldr r0, _021EAA0C ; =0x0001E564
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
_021EA9DE:
	ldr r0, _021EAA08 ; =0x0001E568
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimateFlag
	ldr r0, _021EAA0C ; =0x0001E564
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimateFlag
	ldr r0, _021EAA08 ; =0x0001E568
	mov r1, #0xa
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
	ldr r0, _021EAA0C ; =0x0001E564
	mov r1, #0x18
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
	pop {r4, pc}
	.balign 4, 0
_021EAA08: .word 0x0001E568
_021EAA0C: .word 0x0001E564
	thumb_func_end ov112_021EA9BC

	thumb_func_start ov112_021EAA10
ov112_021EAA10: ; 0x021EAA10
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EAA2C ; =0x0001E568
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021EAA30 ; =0x0001E564
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	pop {r4, pc}
	nop
_021EAA2C: .word 0x0001E568
_021EAA30: .word 0x0001E564
	thumb_func_end ov112_021EAA10

	thumb_func_start ov112_021EAA34
ov112_021EAA34: ; 0x021EAA34
	push {r4, lr}
	add r4, r0, #0
	cmp r2, #0
	bge _021EAA68
	ldr r0, _021EAA90 ; =0x0001E568
	add r2, #0xd0
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	mov r3, #1
	ldr r0, [r4, r0]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	lsl r3, r3, #0x14
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	ldr r0, _021EAA90 ; =0x0001E568
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021EAA94 ; =0x0001E564
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	pop {r4, pc}
_021EAA68:
	ldr r0, _021EAA94 ; =0x0001E564
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r4, r0]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021EAA94 ; =0x0001E564
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021EAA90 ; =0x0001E568
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	pop {r4, pc}
	nop
_021EAA90: .word 0x0001E568
_021EAA94: .word 0x0001E564
	thumb_func_end ov112_021EAA34

	thumb_func_start ov112_021EAA98
ov112_021EAA98: ; 0x021EAA98
	cmp r2, #0
	bne _021EAAAE
	mov r2, #0x80
	strh r2, [r1, #4]
	mov r2, #0x82
	strh r2, [r1, #6]
	sub r2, #0x8c
	strb r2, [r1, #2]
	mov r2, #0
	strh r2, [r1, #0xe]
	b _021EAAD6
_021EAAAE:
	cmp r2, #1
	bne _021EAAC4
	mov r2, #0x80
	strh r2, [r1, #4]
	sub r2, #0xee
	strh r2, [r1, #6]
	mov r2, #0xa
	strb r2, [r1, #2]
	mov r2, #0
	strh r2, [r1, #0xe]
	b _021EAAD6
_021EAAC4:
	cmp r2, #2
	bne _021EAAD6
	mov r2, #0x80
	strh r2, [r1, #4]
	mov r2, #0x82
	strh r2, [r1, #6]
	mov r2, #0
	strb r2, [r1, #2]
	strh r2, [r1, #0xe]
_021EAAD6:
	mov r2, #0
	strh r2, [r1, #8]
	ldr r3, _021EAAE0 ; =ov112_021EA9BC
	strh r2, [r1, #0xa]
	bx r3
	.balign 4, 0
_021EAAE0: .word ov112_021EA9BC
	thumb_func_end ov112_021EAA98

	thumb_func_start ov112_021EAAE4
ov112_021EAAE4: ; 0x021EAAE4
	push {r4, lr}
	add r2, r1, #0
	mov r1, #2
	ldrsb r4, [r2, r1]
	cmp r4, #0
	bge _021EAB14
	mov r1, #6
	ldrsh r3, [r2, r1]
	add r3, r3, r4
	strh r3, [r2, #6]
	ldrsh r3, [r2, r1]
	sub r1, #0x74
	cmp r3, r1
	bge _021EAB04
	mov r1, #0
	strb r1, [r2, #2]
_021EAB04:
	mov r1, #4
	mov r3, #6
	ldrsh r1, [r2, r1]
	ldrsh r2, [r2, r3]
	bl ov112_021EAA34
	mov r0, #0
	pop {r4, pc}
_021EAB14:
	ble _021EAB3C
	cmp r4, #0x64
	bgt _021EAB3C
	mov r1, #6
	ldrsh r3, [r2, r1]
	add r3, r3, r4
	strh r3, [r2, #6]
	ldrsh r1, [r2, r1]
	cmp r1, #0x6c
	ble _021EAB2C
	mov r1, #0x65
	strb r1, [r2, #2]
_021EAB2C:
	mov r1, #4
	mov r3, #6
	ldrsh r1, [r2, r1]
	ldrsh r2, [r2, r3]
	bl ov112_021EAA34
	mov r0, #0
	pop {r4, pc}
_021EAB3C:
	cmp r4, #0
	beq _021EAB50
	mov r1, #4
	mov r3, #6
	ldrsh r1, [r2, r1]
	ldrsh r2, [r2, r3]
	bl ov112_021EAA34
	mov r0, #0
	pop {r4, pc}
_021EAB50:
	bl ov112_021EAA10
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov112_021EAAE4

	thumb_func_start ov112_021EAB58
ov112_021EAB58: ; 0x021EAB58
	push {r3, lr}
	sub sp, #8
	bl sub_02074490
	add r1, r0, #0
	mov r0, #0x60
	str r0, [sp]
	mov r0, #0x9a
	str r0, [sp, #4]
	mov r0, #0x14
	mov r2, #1
	mov r3, #0xa0
	bl GfGfxLoader_GXLoadPal
	add sp, #8
	pop {r3, pc}
	thumb_func_end ov112_021EAB58

	thumb_func_start ov112_021EAB78
ov112_021EAB78: ; 0x021EAB78
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r2, #0
	add r7, r3, #0
	add r5, r0, #0
	add r4, r1, #0
	add r0, r6, #0
	mov r1, #0
	add r2, r7, #0
	bl GetMonIconNaixEx
	ldr r3, _021EABDC ; =0x0001EA64
	add r1, r0, #0
	mov r0, #0x9a
	str r0, [sp]
	mov r0, #0x14
	mov r2, #0
	add r3, r5, r3
	bl GfGfxLoader_GetCharData
	ldr r1, _021EABE0 ; =0x0001EA60
	str r0, [r5, r1]
	add r0, r1, #4
	ldr r0, [r5, r0]
	mov r1, #1
	ldr r0, [r0, #0x14]
	lsl r1, r1, #0xa
	bl DC_FlushRange
	str r4, [sp]
	add r4, #9
	lsl r0, r4, #2
	add r1, r5, r0
	ldr r0, _021EABE4 ; =0x0001E530
	add r2, r7, #0
	ldr r0, [r1, r0]
	add r1, r6, #0
	str r0, [sp, #4]
	ldr r0, _021EABDC ; =0x0001EA64
	mov r3, #0
	ldr r0, [r5, r0]
	bl ov112_021EABE8
	ldr r0, _021EABE0 ; =0x0001EA60
	ldr r0, [r5, r0]
	bl Heap_Free
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EABDC: .word 0x0001EA64
_021EABE0: .word 0x0001EA60
_021EABE4: .word 0x0001E530
	thumb_func_end ov112_021EAB78

	thumb_func_start ov112_021EABE8
ov112_021EABE8: ; 0x021EABE8
	push {r4, r5, r6, lr}
	add r5, r1, #0
	ldr r1, [sp, #0x10]
	add r4, r2, #0
	lsl r1, r1, #5
	add r1, #0xc0
	mov r2, #1
	ldr r0, [r0, #0x14]
	add r6, r3, #0
	lsl r1, r1, #5
	lsl r2, r2, #0xa
	bl GX_LoadOBJ
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl GetMonIconPaletteEx
	add r1, r0, #0
	ldr r0, [sp, #0x14]
	add r1, r1, #5
	bl ManagedSprite_SetPaletteOverride
	pop {r4, r5, r6, pc}
	thumb_func_end ov112_021EABE8

	thumb_func_start ov112_021EAC18
ov112_021EAC18: ; 0x021EAC18
	push {r3, lr}
	ldr r1, _021EAC30 ; =0x00000497
	mov r0, #0x49
	mov r2, #0
	bl Sound_SetSceneAndPlayBGM
	ldr r0, _021EAC30 ; =0x00000497
	bl PlayBGM
	mov r0, #2
	pop {r3, pc}
	nop
_021EAC30: .word 0x00000497
	thumb_func_end ov112_021EAC18

	thumb_func_start ov112_021EAC34
ov112_021EAC34: ; 0x021EAC34
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	lsl r2, r1, #2
	ldr r1, _021EAC54 ; =ov112_021FF6C4
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4, #8]
	cmp r0, #0x1b
	bne _021EAC50
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #3
	pop {r4, pc}
_021EAC50:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EAC54: .word ov112_021FF6C4
	thumb_func_end ov112_021EAC34

	thumb_func_start ov112_021EAC58
ov112_021EAC58: ; 0x021EAC58
	mov r0, #1
	bx lr
	thumb_func_end ov112_021EAC58

	thumb_func_start ov112_021EAC5C
ov112_021EAC5C: ; 0x021EAC5C
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [r5, #0x20]
	bl SaveArray_PCStorage_Get
	add r4, r0, #0
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	add r0, r4, #0
	bl PCStorage_CountEmptySpotsInAllBoxes
	cmp r0, #5
	bge _021EACA0
	add r0, r5, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #1
	bl ov112_021E9A78
	add sp, #0x14
	mov r0, #0x14
	pop {r4, r5, pc}
_021EACA0:
	add r0, r4, #0
	bl PCStorage_CountMonsInAllBoxes
	cmp r0, #0
	bne _021EACCC
	ldr r0, _021EADC8 ; =0x0001E440
	ldr r0, [r5, r0]
	bl sub_0203263C
	cmp r0, #0
	bne _021EACCC
	add r0, r5, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #1
	bl ov112_021E9A78
	add sp, #0x14
	mov r0, #0x17
	pop {r4, r5, pc}
_021EACCC:
	ldr r0, _021EADC8 ; =0x0001E440
	add r1, sp, #0x10
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0x10
	bl sub_02032688
	add r0, sp, #0x10
	ldrh r0, [r0, #2]
	cmp r0, #0
	beq _021EACEC
	cmp r0, #1
	beq _021EAD3A
	cmp r0, #2
	beq _021EAD82
	b _021EADC2
_021EACEC:
	mov r1, #3
	ldr r0, _021EADCC ; =0x0001D77C
	str r1, [r5, #4]
	mov r2, #0
	strh r2, [r5, r0]
	add r0, r5, #0
	str r2, [r5, #0x10]
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r5, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	ldr r0, _021EADC8 ; =0x0001E440
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_020326A4
	add sp, #0x14
	mov r0, #4
	pop {r4, r5, pc}
_021EAD3A:
	ldr r0, _021EADCC ; =0x0001D77C
	mov r1, #0
	strh r1, [r5, r0]
	str r1, [r5, #0x10]
	add r0, r5, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #7
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r5, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add r0, r5, #0
	mov r1, #0
	bl ov112_021EADD0
	add sp, #0x14
	mov r0, #0xf
	pop {r4, r5, pc}
_021EAD82:
	add r0, r5, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r5, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add r0, r5, #0
	mov r1, #1
	bl ov112_021EADD0
	add sp, #0x14
	mov r0, #0xa
	pop {r4, r5, pc}
_021EADC2:
	mov r0, #1
	add sp, #0x14
	pop {r4, r5, pc}
	.balign 4, 0
_021EADC8: .word 0x0001E440
_021EADCC: .word 0x0001D77C
	thumb_func_end ov112_021EAC5C

	thumb_func_start ov112_021EADD0
ov112_021EADD0: ; 0x021EADD0
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, _021EAF28 ; =0x0001E440
	add r6, r1, #0
	ldr r0, [r5, r0]
	add r1, sp, #0xc
	add r2, sp, #8
	bl sub_02032674
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021EAF2C ; =0x0001E448
	mov r1, #7
	ldr r0, [r5, r0]
	ldr r2, [sp, #8]
	add r3, r1, #0
	bl BufferIntegerAsString
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021EAF2C ; =0x0001E448
	ldr r2, [sp, #0xc]
	ldr r0, [r5, r0]
	mov r1, #6
	mov r3, #7
	bl BufferIntegerAsString
	ldr r1, [sp, #8]
	add r0, r5, #0
	bl ov112_021E9610
	add r4, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _021EAF2C ; =0x0001E448
	mov r1, #0xc
	ldr r0, [r5, r0]
	add r2, r4, #0
	mov r3, #7
	bl BufferIntegerAsString
	add r0, r5, #0
	mov r1, #5
	mov r2, #0x10
	bl ov112_021E7CA4
	add r0, r5, #0
	mov r1, #1
	bl ov112_021E98E8
	ldr r0, _021EAF30 ; =0x0001F2E0
	mov r3, #0
	strh r3, [r5, r0]
	ldr r0, _021EAF34 ; =0x00010200
	ldr r2, _021EAF38 ; =0x0001E50C
	str r0, [sp]
	ldr r2, [r5, r2]
	add r0, r5, #0
	mov r1, #1
	bl ov112_021EA010
	ldr r3, _021EAF34 ; =0x00010200
	add r0, r5, #0
	mov r1, #2
	mov r2, #0x53
	bl ov112_021EA044
	ldr r0, _021EAF34 ; =0x00010200
	ldr r2, _021EAF3C ; =0x0001E510
	str r0, [sp]
	ldr r2, [r5, r2]
	add r0, r5, #0
	mov r1, #3
	mov r3, #0
	bl ov112_021EA010
	ldr r3, _021EAF34 ; =0x00010200
	add r0, r5, #0
	mov r1, #4
	mov r2, #0x54
	bl ov112_021EA044
	cmp r4, #0
	ldr r3, _021EAF34 ; =0x00010200
	bge _021EAE94
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x58
	bl ov112_021EA044
	b _021EAEAE
_021EAE94:
	cmp r4, #0
	bne _021EAEA4
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x57
	bl ov112_021EA044
	b _021EAEAE
_021EAEA4:
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x56
	bl ov112_021EA044
_021EAEAE:
	cmp r6, #0
	beq _021EAF04
	mov r0, #0x9a
	bl AllocMonZeroed
	add r6, r0, #0
	bl Mon_GetBoxMon
	add r4, r0, #0
	ldr r0, _021EAF28 ; =0x0001E440
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl Pokewalker_TryGetBoxMon
	ldr r0, _021EAF2C ; =0x0001E448
	mov r1, #0xd
	ldr r0, [r5, r0]
	add r2, r4, #0
	bl BufferBoxMonNickname
	mov r3, #0xc1
	add r0, r5, #0
	mov r1, #5
	mov r2, #0x59
	lsl r3, r3, #0xa
	bl ov112_021EA044
	ldr r2, _021EAF40 ; =0x0001D7AC
	add r0, r4, #0
	add r1, r5, r2
	sub r2, #0x10
	add r2, r5, r2
	mov r3, #1
	bl ov112_021E9290
	add r0, r5, #0
	mov r1, #7
	bl ov112_021EA670
	add r0, r6, #0
	bl Heap_Free
	b _021EAF1E
_021EAF04:
	add r0, r5, #0
	mov r1, #7
	bl ov112_021EA688
	ldr r0, _021EAF44 ; =0x0001EBF8
	mov r1, #0
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EAF44 ; =0x0001EBF8
	add r0, r5, r0
	bl CopyWindowToVram
_021EAF1E:
	add r0, r5, #0
	bl ov112_021EA64C
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EAF28: .word 0x0001E440
_021EAF2C: .word 0x0001E448
_021EAF30: .word 0x0001F2E0
_021EAF34: .word 0x00010200
_021EAF38: .word 0x0001E50C
_021EAF3C: .word 0x0001E510
_021EAF40: .word 0x0001D7AC
_021EAF44: .word 0x0001EBF8
	thumb_func_end ov112_021EADD0

	thumb_func_start ov112_021EAF48
ov112_021EAF48: ; 0x021EAF48
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EAF56
	mov r0, #4
	pop {r3, pc}
_021EAF56:
	mov r0, #2
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EAF48

	thumb_func_start ov112_021EAF5C
ov112_021EAF5C: ; 0x021EAF5C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r1, #1
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #3
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	add r0, r5, #0
	mov r1, #5
	mov r2, #0x11
	bl ov112_021E7CA4
	add r0, r5, #0
	mov r1, #2
	mov r2, #0x17
	bl ov112_021E7CA4
	ldr r7, _021EAFEC ; =0x000F0100
	mov r4, #0
_021EAFA2:
	ldr r0, _021EAFF0 ; =0x0001E44C
	add r1, r4, #0
	ldr r0, [r5, r0]
	add r1, #0x98
	bl NewString_ReadMsgData
	add r6, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #4
	str r7, [sp]
	bl ov112_021E9FA4
	add r0, r6, #0
	bl String_Delete
	add r4, r4, #1
	cmp r4, #4
	blt _021EAFA2
	add r0, r5, #0
	mov r1, #6
	bl ov112_021E9F40
	ldr r1, _021EAFF4 ; =0x0001EC50
	mov r0, #0
	str r0, [r5, r1]
	ldr r1, [r5, r1]
	add r0, r5, #0
	lsl r2, r1, #2
	ldr r1, _021EAFF8 ; =ov112_021FF0AC
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	mov r0, #3
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EAFEC: .word 0x000F0100
_021EAFF0: .word 0x0001E44C
_021EAFF4: .word 0x0001EC50
_021EAFF8: .word ov112_021FF0AC
	thumb_func_end ov112_021EAF5C

	thumb_func_start ov112_021EAFFC
ov112_021EAFFC: ; 0x021EAFFC
	push {r4, lr}
	sub sp, #0x10
	ldr r1, _021EB1C4 ; =gSystem
	add r4, r0, #0
	ldr r2, [r1, #0x48]
	mov r1, #0x40
	tst r1, r2
	beq _021EB02A
	ldr r0, _021EB1C8 ; =0x0001EC50
	ldr r1, [r4, r0]
	cmp r1, #0
	ble _021EB018
	sub r1, r1, #1
	str r1, [r4, r0]
_021EB018:
	ldr r1, _021EB1C8 ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021EB1CC ; =ov112_021FF0AC
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	b _021EB1BE
_021EB02A:
	mov r1, #0x80
	tst r1, r2
	beq _021EB04E
	ldr r0, _021EB1C8 ; =0x0001EC50
	ldr r1, [r4, r0]
	cmp r1, #5
	bge _021EB03C
	add r1, r1, #1
	str r1, [r4, r0]
_021EB03C:
	ldr r1, _021EB1C8 ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021EB1CC ; =ov112_021FF0AC
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	b _021EB1BE
_021EB04E:
	mov r1, #1
	tst r2, r1
	beq _021EB05C
	ldr r2, _021EB1C8 ; =0x0001EC50
	ldr r2, [r4, r2]
	cmp r2, #4
	bls _021EB05E
_021EB05C:
	b _021EB1BE
_021EB05E:
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_021EB06A: ; jump table
	.short _021EB074 - _021EB06A - 2 ; case 0
	.short _021EB0BC - _021EB06A - 2 ; case 1
	.short _021EB108 - _021EB06A - 2 ; case 2
	.short _021EB152 - _021EB06A - 2 ; case 3
	.short _021EB188 - _021EB06A - 2 ; case 4
_021EB074:
	mov r0, #2
	str r0, [r4, #4]
	ldr r0, _021EB1D0 ; =0x0001E440
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_020326A4
	add r0, r4, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add sp, #0x10
	mov r0, #0x1a
	pop {r4, pc}
_021EB0BC:
	mov r1, #3
	ldr r2, _021EB1D4 ; =0x0001D77C
	str r1, [r4, #4]
	mov r3, #0
	strh r3, [r4, r2]
	str r3, [r4, #0x10]
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	ldr r0, _021EB1D0 ; =0x0001E440
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_020326A4
	add sp, #0x10
	mov r0, #4
	pop {r4, pc}
_021EB108:
	ldr r0, _021EB1D0 ; =0x0001E440
	add r2, r1, #0
	ldr r0, [r4, r0]
	bl sub_020326A4
	ldr r0, _021EB1D4 ; =0x0001D77C
	mov r1, #0
	strh r1, [r4, r0]
	str r1, [r4, #0x10]
	add r0, r4, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #7
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add sp, #0x10
	mov r0, #0xf
	pop {r4, pc}
_021EB152:
	mov r1, #3
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add sp, #0x10
	mov r0, #0xa
	pop {r4, pc}
_021EB188:
	mov r1, #3
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add sp, #0x10
	mov r0, #0xf
	pop {r4, pc}
_021EB1BE:
	mov r0, #3
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EB1C4: .word gSystem
_021EB1C8: .word 0x0001EC50
_021EB1CC: .word ov112_021FF0AC
_021EB1D0: .word 0x0001E440
_021EB1D4: .word 0x0001D77C
	thumb_func_end ov112_021EAFFC

	thumb_func_start ov112_021EB1D8
ov112_021EB1D8: ; 0x021EB1D8
	push {r3, lr}
	mov r1, #2
	mov r2, #0
	mov r3, #6
	bl ov112_021EC460
	mov r0, #0x18
	pop {r3, pc}
	thumb_func_end ov112_021EB1D8

	thumb_func_start ov112_021EB1E8
ov112_021EB1E8: ; 0x021EB1E8
	push {r3, lr}
	ldr r1, _021EB204 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EB1FE
	mov r0, #7
	pop {r3, pc}
_021EB1FE:
	mov r0, #5
	pop {r3, pc}
	nop
_021EB204: .word 0x0001E524
	thumb_func_end ov112_021EB1E8

	thumb_func_start ov112_021EB208
ov112_021EB208: ; 0x021EB208
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #0
	mov r2, #8
	mov r3, #7
	bl ov112_021EC460
	mov r0, #0x18
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EB208

	thumb_func_start ov112_021EB244
ov112_021EB244: ; 0x021EB244
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #2
	mov r2, #0xa
	add r4, r0, #0
	bl ov112_021E7CA4
	ldr r0, _021EB280 ; =0x000F0100
	ldr r2, _021EB284 ; =0x0001E46C
	str r0, [sp]
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r1, #5
	mov r3, #4
	bl ov112_021E9FA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	ldr r0, _021EB288 ; =0x0001EC50
	mov r1, #0
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA51C
	mov r0, #8
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021EB280: .word 0x000F0100
_021EB284: .word 0x0001E46C
_021EB288: .word 0x0001EC50
	thumb_func_end ov112_021EB244

	thumb_func_start ov112_021EB28C
ov112_021EB28C: ; 0x021EB28C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	bl ov112_021E9888
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _021EB2B4
	add r0, r4, #0
	add r2, r1, #2
	mov r3, #9
	bl ov112_021EC440
	ldr r0, _021EB378 ; =0x000005DD
	bl PlaySE
	mov r0, #0x19
	pop {r4, pc}
_021EB2B4:
	ldr r0, _021EB37C ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _021EB2DC
	ldr r0, _021EB380 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021EB2CC
	ldr r0, _021EB384 ; =0x000005DC
	bl PlaySE
_021EB2CC:
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA51C
	ldr r0, _021EB380 ; =0x0001EC50
	mov r1, #0
	str r1, [r4, r0]
	b _021EB372
_021EB2DC:
	mov r1, #0x80
	tst r1, r0
	beq _021EB300
	ldr r0, _021EB380 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #1
	beq _021EB2F0
	ldr r0, _021EB384 ; =0x000005DC
	bl PlaySE
_021EB2F0:
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA51C
	ldr r0, _021EB380 ; =0x0001EC50
	mov r1, #1
	str r1, [r4, r0]
	b _021EB372
_021EB300:
	mov r1, #1
	tst r1, r0
	beq _021EB31E
	ldr r0, _021EB378 ; =0x000005DD
	bl PlaySE
	ldr r0, _021EB380 ; =0x0001EC50
	mov r3, #9
	ldr r1, [r4, r0]
	add r0, r4, #0
	add r2, r1, #2
	bl ov112_021EC440
	mov r0, #0x19
	pop {r4, pc}
_021EB31E:
	mov r1, #2
	tst r0, r1
	beq _021EB33A
	ldr r0, _021EB378 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #3
	mov r3, #9
	bl ov112_021EC440
	mov r0, #0x19
	pop {r4, pc}
_021EB33A:
	bl ov112_021EB9C0
	cmp r0, #0
	beq _021EB354
	ldr r0, _021EB384 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EB90C
	mov r0, #0x1a
	pop {r4, pc}
_021EB354:
	bl ov112_021EB9E4
	cmp r0, #0
	beq _021EB372
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EB950
	cmp r0, #0
	beq _021EB372
	ldr r0, _021EB384 ; =0x000005DC
	bl PlaySE
	mov r0, #0x1a
	pop {r4, pc}
_021EB372:
	mov r0, #8
	pop {r4, pc}
	nop
_021EB378: .word 0x000005DD
_021EB37C: .word gSystem
_021EB380: .word 0x0001EC50
_021EB384: .word 0x000005DC
	thumb_func_end ov112_021EB28C

	thumb_func_start ov112_021EB388
ov112_021EB388: ; 0x021EB388
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021EA570
	ldr r0, _021EB3A4 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _021EB39C
	mov r0, #3
	b _021EB39E
_021EB39C:
	mov r0, #0xb
_021EB39E:
	str r0, [r4, #4]
	mov r0, #0x1a
	pop {r4, pc}
	.balign 4, 0
_021EB3A4: .word 0x0001EC50
	thumb_func_end ov112_021EB388

	thumb_func_start ov112_021EB3A8
ov112_021EB3A8: ; 0x021EB3A8
	push {r3, lr}
	mov r1, #0
	mov r2, #2
	mov r3, #0xc
	bl ov112_021EC460
	mov r0, #0x18
	pop {r3, pc}
	thumb_func_end ov112_021EB3A8

	thumb_func_start ov112_021EB3B8
ov112_021EB3B8: ; 0x021EB3B8
	push {r3, lr}
	ldr r1, _021EB3D4 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EB3CE
	mov r0, #0xc
	pop {r3, pc}
_021EB3CE:
	mov r0, #0xb
	pop {r3, pc}
	nop
_021EB3D4: .word 0x0001E524
	thumb_func_end ov112_021EB3B8

	thumb_func_start ov112_021EB3D8
ov112_021EB3D8: ; 0x021EB3D8
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r1, #2
	mov r2, #0xb
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x10
	bl ov112_021E7CA4
	ldr r0, _021EB438 ; =0x000F0100
	ldr r2, _021EB43C ; =0x0001E464
	str r0, [sp]
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r1, #3
	mov r3, #4
	bl ov112_021E9FA4
	ldr r0, _021EB438 ; =0x000F0100
	mov r1, #4
	str r0, [sp]
	ldr r2, _021EB440 ; =0x0001E460
	add r0, r4, #0
	ldr r2, [r4, r2]
	add r3, r1, #0
	bl ov112_021E9FA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	ldr r1, _021EB444 ; =0x0001EC50
	mov r0, #0
	str r0, [r4, r1]
	ldr r1, [r4, r1]
	add r0, r4, #0
	lsl r2, r1, #2
	ldr r1, _021EB448 ; =ov112_021FF090
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	mov r0, #0xd
	add sp, #4
	pop {r3, r4, pc}
	nop
_021EB438: .word 0x000F0100
_021EB43C: .word 0x0001E464
_021EB440: .word 0x0001E460
_021EB444: .word 0x0001EC50
_021EB448: .word ov112_021FF090
	thumb_func_end ov112_021EB3D8

	thumb_func_start ov112_021EB44C
ov112_021EB44C: ; 0x021EB44C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #2
	bl ov112_021E9888
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _021EB478
	ldr r2, _021EB554 ; =ov112_021FF090
	lsl r3, r1, #2
	ldr r2, [r2, r3]
	add r0, r4, #0
	mov r3, #0xe
	bl ov112_021EC440
	ldr r0, _021EB558 ; =0x000005DD
	bl PlaySE
	mov r0, #0x19
	pop {r4, pc}
_021EB478:
	ldr r0, _021EB55C ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _021EB4AA
	ldr r0, _021EB560 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021EB498
	ldr r0, _021EB564 ; =0x000005DC
	bl PlaySE
	ldr r0, _021EB560 ; =0x0001EC50
	ldr r1, [r4, r0]
	sub r1, r1, #1
	str r1, [r4, r0]
_021EB498:
	ldr r1, _021EB560 ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021EB554 ; =ov112_021FF090
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	b _021EB54E
_021EB4AA:
	mov r1, #0x80
	tst r1, r0
	beq _021EB4D8
	ldr r0, _021EB560 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #2
	bge _021EB4C6
	ldr r0, _021EB564 ; =0x000005DC
	bl PlaySE
	ldr r0, _021EB560 ; =0x0001EC50
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
_021EB4C6:
	ldr r1, _021EB560 ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021EB554 ; =ov112_021FF090
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	b _021EB54E
_021EB4D8:
	mov r1, #1
	tst r1, r0
	beq _021EB4FA
	ldr r0, _021EB558 ; =0x000005DD
	bl PlaySE
	ldr r0, _021EB560 ; =0x0001EC50
	ldr r2, _021EB554 ; =ov112_021FF090
	ldr r1, [r4, r0]
	add r0, r4, #0
	lsl r3, r1, #2
	ldr r2, [r2, r3]
	mov r3, #0xe
	bl ov112_021EC440
	mov r0, #0x19
	pop {r4, pc}
_021EB4FA:
	mov r1, #2
	tst r0, r1
	beq _021EB516
	ldr r0, _021EB564 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #2
	mov r2, #3
	mov r3, #0xe
	bl ov112_021EC440
	mov r0, #0x19
	pop {r4, pc}
_021EB516:
	bl ov112_021EB9C0
	cmp r0, #0
	beq _021EB530
	ldr r0, _021EB564 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EB90C
	mov r0, #0x1a
	pop {r4, pc}
_021EB530:
	bl ov112_021EB9E4
	cmp r0, #0
	beq _021EB54E
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EB950
	cmp r0, #0
	beq _021EB54E
	ldr r0, _021EB564 ; =0x000005DC
	bl PlaySE
	mov r0, #0x1a
	pop {r4, pc}
_021EB54E:
	mov r0, #0xd
	pop {r4, pc}
	nop
_021EB554: .word ov112_021FF090
_021EB558: .word 0x000005DD
_021EB55C: .word gSystem
_021EB560: .word 0x0001EC50
_021EB564: .word 0x000005DC
	thumb_func_end ov112_021EB44C

	thumb_func_start ov112_021EB568
ov112_021EB568: ; 0x021EB568
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021EA570
	ldr r0, _021EB5A8 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021EB582
	cmp r0, #1
	beq _021EB58C
	cmp r0, #2
	beq _021EB596
	b _021EB59C
_021EB582:
	mov r0, #3
	str r0, [r4, #4]
	mov r0, #1
	str r0, [r4, #0x10]
	b _021EB5A4
_021EB58C:
	mov r0, #3
	str r0, [r4, #4]
	mov r0, #2
	str r0, [r4, #0x10]
	b _021EB5A4
_021EB596:
	mov r0, #0xb
	str r0, [r4, #4]
	b _021EB5A4
_021EB59C:
	cmp r0, #3
	blt _021EB5A4
	bl GF_AssertFail
_021EB5A4:
	mov r0, #0x1a
	pop {r4, pc}
	.balign 4, 0
_021EB5A8: .word 0x0001EC50
	thumb_func_end ov112_021EB568

	thumb_func_start ov112_021EB5AC
ov112_021EB5AC: ; 0x021EB5AC
	push {r3, lr}
	mov r1, #0
	mov r2, #8
	mov r3, #0x11
	bl ov112_021EC460
	mov r0, #0x18
	pop {r3, pc}
	thumb_func_end ov112_021EB5AC

	thumb_func_start ov112_021EB5BC
ov112_021EB5BC: ; 0x021EB5BC
	push {r3, lr}
	ldr r1, _021EB5D8 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EB5D2
	mov r0, #0x11
	pop {r3, pc}
_021EB5D2:
	mov r0, #0x10
	pop {r3, pc}
	nop
_021EB5D8: .word 0x0001E524
	thumb_func_end ov112_021EB5BC

	thumb_func_start ov112_021EB5DC
ov112_021EB5DC: ; 0x021EB5DC
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r1, #2
	mov r2, #0xc
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x10
	bl ov112_021E7CA4
	ldr r0, _021EB64C ; =0x000F0100
	ldr r2, _021EB650 ; =0x0001E45C
	str r0, [sp]
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r1, #3
	mov r3, #4
	bl ov112_021E9FA4
	ldr r0, _021EB64C ; =0x000F0100
	mov r1, #4
	str r0, [sp]
	ldr r2, _021EB654 ; =0x0001E460
	add r0, r4, #0
	ldr r2, [r4, r2]
	add r3, r1, #0
	bl ov112_021E9FA4
	ldr r0, _021EB64C ; =0x000F0100
	ldr r2, _021EB658 ; =0x0001E464
	str r0, [sp]
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r1, #5
	mov r3, #4
	bl ov112_021E9FA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	ldr r1, _021EB65C ; =0x0001EC50
	mov r0, #0
	str r0, [r4, r1]
	ldr r1, [r4, r1]
	add r0, r4, #0
	lsl r2, r1, #2
	ldr r1, _021EB660 ; =ov112_021FF09C
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	mov r0, #0x12
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021EB64C: .word 0x000F0100
_021EB650: .word 0x0001E45C
_021EB654: .word 0x0001E460
_021EB658: .word 0x0001E464
_021EB65C: .word 0x0001EC50
_021EB660: .word ov112_021FF09C
	thumb_func_end ov112_021EB5DC

	thumb_func_start ov112_021EB664
ov112_021EB664: ; 0x021EB664
	push {r4, lr}
	add r4, r0, #0
	mov r0, #3
	bl ov112_021E9888
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _021EB690
	ldr r2, _021EB76C ; =ov112_021FF09C
	lsl r3, r1, #2
	ldr r2, [r2, r3]
	add r0, r4, #0
	mov r3, #0x13
	bl ov112_021EC440
	ldr r0, _021EB770 ; =0x000005DD
	bl PlaySE
	mov r0, #0x19
	pop {r4, pc}
_021EB690:
	ldr r0, _021EB774 ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _021EB6C2
	ldr r0, _021EB778 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021EB6B0
	ldr r0, _021EB77C ; =0x000005DC
	bl PlaySE
	ldr r0, _021EB778 ; =0x0001EC50
	ldr r1, [r4, r0]
	sub r1, r1, #1
	str r1, [r4, r0]
_021EB6B0:
	ldr r1, _021EB778 ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021EB76C ; =ov112_021FF09C
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	b _021EB766
_021EB6C2:
	mov r1, #0x80
	tst r1, r0
	beq _021EB6F0
	ldr r0, _021EB778 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #3
	bge _021EB6DE
	ldr r0, _021EB77C ; =0x000005DC
	bl PlaySE
	ldr r0, _021EB778 ; =0x0001EC50
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
_021EB6DE:
	ldr r1, _021EB778 ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021EB76C ; =ov112_021FF09C
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	b _021EB766
_021EB6F0:
	mov r1, #1
	tst r1, r0
	beq _021EB712
	ldr r0, _021EB770 ; =0x000005DD
	bl PlaySE
	ldr r0, _021EB778 ; =0x0001EC50
	ldr r2, _021EB76C ; =ov112_021FF09C
	ldr r1, [r4, r0]
	add r0, r4, #0
	lsl r3, r1, #2
	ldr r2, [r2, r3]
	mov r3, #0x13
	bl ov112_021EC440
	mov r0, #0x19
	pop {r4, pc}
_021EB712:
	mov r1, #2
	tst r0, r1
	beq _021EB72E
	ldr r0, _021EB77C ; =0x000005DC
	bl PlaySE
	mov r1, #3
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x13
	bl ov112_021EC440
	mov r0, #0x19
	pop {r4, pc}
_021EB72E:
	bl ov112_021EB9C0
	cmp r0, #0
	beq _021EB748
	ldr r0, _021EB77C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	bl ov112_021EB90C
	mov r0, #0x1a
	pop {r4, pc}
_021EB748:
	bl ov112_021EB9E4
	cmp r0, #0
	beq _021EB766
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EB950
	cmp r0, #0
	beq _021EB766
	ldr r0, _021EB77C ; =0x000005DC
	bl PlaySE
	mov r0, #0x1a
	pop {r4, pc}
_021EB766:
	mov r0, #0x12
	pop {r4, pc}
	nop
_021EB76C: .word ov112_021FF09C
_021EB770: .word 0x000005DD
_021EB774: .word gSystem
_021EB778: .word 0x0001EC50
_021EB77C: .word 0x000005DC
	thumb_func_end ov112_021EB664

	thumb_func_start ov112_021EB780
ov112_021EB780: ; 0x021EB780
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021EA570
	ldr r0, _021EB7D4 ; =0x0001EC50
	ldr r1, [r4, r0]
	cmp r1, #3
	bhi _021EB7C8
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EB79C: ; jump table
	.short _021EB7A4 - _021EB79C - 2 ; case 0
	.short _021EB7AE - _021EB79C - 2 ; case 1
	.short _021EB7B8 - _021EB79C - 2 ; case 2
	.short _021EB7C2 - _021EB79C - 2 ; case 3
_021EB7A4:
	mov r0, #3
	str r0, [r4, #4]
	mov r0, #0
	str r0, [r4, #0x10]
	b _021EB7D0
_021EB7AE:
	mov r0, #3
	str r0, [r4, #4]
	mov r0, #1
	str r0, [r4, #0x10]
	b _021EB7D0
_021EB7B8:
	mov r0, #3
	str r0, [r4, #4]
	mov r0, #2
	str r0, [r4, #0x10]
	b _021EB7D0
_021EB7C2:
	mov r0, #0xb
	str r0, [r4, #4]
	b _021EB7D0
_021EB7C8:
	cmp r1, #4
	blt _021EB7D0
	bl GF_AssertFail
_021EB7D0:
	mov r0, #0x1a
	pop {r4, pc}
	.balign 4, 0
_021EB7D4: .word 0x0001EC50
	thumb_func_end ov112_021EB780

	thumb_func_start ov112_021EB7D8
ov112_021EB7D8: ; 0x021EB7D8
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021EA570
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xf
	mov r3, #0x16
	bl ov112_021EC460
	mov r0, #0x18
	add sp, #0x10
	pop {r4, pc}
	thumb_func_end ov112_021EB7D8

	thumb_func_start ov112_021EB838
ov112_021EB838: ; 0x021EB838
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EB858 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EB854
	mov r0, #0xb
	str r0, [r4, #4]
	mov r0, #0x1a
	pop {r4, pc}
_021EB854:
	mov r0, #0x15
	pop {r4, pc}
	.balign 4, 0
_021EB858: .word 0x0001E524
	thumb_func_end ov112_021EB838

	thumb_func_start ov112_021EB85C
ov112_021EB85C: ; 0x021EB85C
	mov r1, #0xb
	str r1, [r0, #4]
	mov r0, #0x1a
	bx lr
	thumb_func_end ov112_021EB85C

	thumb_func_start ov112_021EB864
ov112_021EB864: ; 0x021EB864
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021EA570
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	mov r2, #0x16
	add r0, r4, #0
	mov r1, #2
	add r3, r2, #0
	bl ov112_021EC460
	mov r0, #0x18
	add sp, #0x10
	pop {r4, pc}
	thumb_func_end ov112_021EB864

	thumb_func_start ov112_021EB8C4
ov112_021EB8C4: ; 0x021EB8C4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EB8E4 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EB8DE
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	pop {r4, pc}
_021EB8DE:
	mov r0, #0x18
	pop {r4, pc}
	nop
_021EB8E4: .word 0x0001E524
	thumb_func_end ov112_021EB8C4

	thumb_func_start ov112_021EB8E8
ov112_021EB8E8: ; 0x021EB8E8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EB904 ; =0x0001E530
	ldr r0, [r4, r0]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _021EB8FE
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	pop {r4, pc}
_021EB8FE:
	mov r0, #0x19
	pop {r4, pc}
	nop
_021EB904: .word 0x0001E530
	thumb_func_end ov112_021EB8E8

	thumb_func_start ov112_021EB908
ov112_021EB908: ; 0x021EB908
	mov r0, #0x1b
	bx lr
	thumb_func_end ov112_021EB908

	thumb_func_start ov112_021EB90C
ov112_021EB90C: ; 0x021EB90C
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r2, #2
	str r2, [r4, #4]
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	bl ov112_021EA570
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EB90C

	thumb_func_start ov112_021EB950
ov112_021EB950: ; 0x021EB950
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, _021EB9BC ; =0x0001E440
	add r4, r1, #0
	add r1, sp, #0x10
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0x10
	bl sub_02032688
	add r0, sp, #0x10
	ldrh r0, [r0, #2]
	cmp r0, #2
	beq _021EB974
	add sp, #0x14
	mov r0, #0
	pop {r4, r5, pc}
_021EB974:
	mov r0, #3
	str r0, [r5, #4]
	mov r0, #4
	str r0, [r5, #0x10]
	add r0, r5, #0
	add r1, r4, #0
	bl ov112_021E9C10
	add r0, r5, #0
	mov r1, #1
	bl ov112_021E9A78
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r5, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	add r0, r5, #0
	bl ov112_021EA570
	mov r0, #1
	add sp, #0x14
	pop {r4, r5, pc}
	nop
_021EB9BC: .word 0x0001E440
	thumb_func_end ov112_021EB950

	thumb_func_start ov112_021EB9C0
ov112_021EB9C0: ; 0x021EB9C0
	ldr r0, _021EB9E0 ; =gSystem
	mov r1, #0x80
	ldr r2, [r0, #0x44]
	add r0, r2, #0
	tst r0, r1
	beq _021EB9DC
	lsl r0, r1, #3
	tst r0, r2
	beq _021EB9DC
	lsl r0, r1, #2
	tst r0, r2
	beq _021EB9DC
	mov r0, #1
	bx lr
_021EB9DC:
	mov r0, #0
	bx lr
	.balign 4, 0
_021EB9E0: .word gSystem
	thumb_func_end ov112_021EB9C0

	thumb_func_start ov112_021EB9E4
ov112_021EB9E4: ; 0x021EB9E4
	ldr r0, _021EBA04 ; =gSystem
	ldr r2, [r0, #0x44]
	mov r0, #0x40
	tst r0, r2
	beq _021EBA00
	mov r0, #4
	add r1, r2, #0
	tst r1, r0
	beq _021EBA00
	add r0, #0xfc
	tst r0, r2
	beq _021EBA00
	mov r0, #1
	bx lr
_021EBA00:
	mov r0, #0
	bx lr
	.balign 4, 0
_021EBA04: .word gSystem
	thumb_func_end ov112_021EB9E4

	thumb_func_start ov112_021EBA08
ov112_021EBA08: ; 0x021EBA08
	push {lr}
	sub sp, #0xc
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #2
	add sp, #0xc
	pop {pc}
	thumb_func_end ov112_021EBA08

	thumb_func_start ov112_021EBA28
ov112_021EBA28: ; 0x021EBA28
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	lsl r2, r1, #2
	ldr r1, _021EBA4C ; =ov112_021FF730
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4, #8]
	cmp r0, #4
	bne _021EBA48
	mov r0, #0xb
	str r0, [r4, #4]
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #3
	pop {r4, pc}
_021EBA48:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EBA4C: .word ov112_021FF730
	thumb_func_end ov112_021EBA28

	thumb_func_start ov112_021EBA50
ov112_021EBA50: ; 0x021EBA50
	mov r0, #1
	bx lr
	thumb_func_end ov112_021EBA50

	thumb_func_start ov112_021EBA54
ov112_021EBA54: ; 0x021EBA54
	push {r4, lr}
	mov r1, #2
	mov r2, #0x93
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EBA68 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021EBA68: .word 0x0001E524
	thumb_func_end ov112_021EBA54

	thumb_func_start ov112_021EBA6C
ov112_021EBA6C: ; 0x021EBA6C
	push {r3, lr}
	ldr r1, _021EBA88 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EBA82
	mov r0, #2
	pop {r3, pc}
_021EBA82:
	mov r0, #1
	pop {r3, pc}
	nop
_021EBA88: .word 0x0001E524
	thumb_func_end ov112_021EBA6C

	thumb_func_start ov112_021EBA8C
ov112_021EBA8C: ; 0x021EBA8C
	ldr r0, _021EBAA8 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _021EBA9E
	ldr r0, _021EBAAC ; =gSystem + 0x40
	ldrh r0, [r0, #0x24]
	cmp r0, #0
	beq _021EBAA2
_021EBA9E:
	mov r0, #3
	bx lr
_021EBAA2:
	mov r0, #2
	bx lr
	nop
_021EBAA8: .word gSystem
_021EBAAC: .word gSystem + 0x40
	thumb_func_end ov112_021EBA8C

	thumb_func_start ov112_021EBAB0
ov112_021EBAB0: ; 0x021EBAB0
	mov r0, #4
	bx lr
	thumb_func_end ov112_021EBAB0

	thumb_func_start ov112_021EBAB4
ov112_021EBAB4: ; 0x021EBAB4
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #4
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #5
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	add r0, r4, #0
	bl ov112_021EA64C
	add r0, r4, #0
	mov r1, #7
	bl ov112_021EA688
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	mov r0, #2
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EBAB4

	thumb_func_start ov112_021EBB58
ov112_021EBB58: ; 0x021EBB58
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	lsl r2, r1, #2
	ldr r1, _021EBB80 ; =ov112_021FF740
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4, #8]
	cmp r0, #0x23
	bne _021EBB74
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #3
	pop {r4, pc}
_021EBB74:
	add r0, r4, #0
	bl ov112_021EA864
	mov r0, #2
	pop {r4, pc}
	nop
_021EBB80: .word ov112_021FF740
	thumb_func_end ov112_021EBB58

	thumb_func_start ov112_021EBB84
ov112_021EBB84: ; 0x021EBB84
	push {r4, lr}
	add r4, r0, #0
	mov r1, #8
	bl ov112_021EA688
	add r0, r4, #0
	bl ov112_021EA64C
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov112_021EBB84

	thumb_func_start ov112_021EBB98
ov112_021EBB98: ; 0x021EBB98
	push {r4, lr}
	mov r1, #2
	mov r2, #3
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EBBAC ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021EBBAC: .word 0x0001E524
	thumb_func_end ov112_021EBB98

	thumb_func_start ov112_021EBBB0
ov112_021EBBB0: ; 0x021EBBB0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EBBD4 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EBBD0
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E966C
	mov r0, #2
	pop {r4, pc}
_021EBBD0:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021EBBD4: .word 0x0001E524
	thumb_func_end ov112_021EBBB0

	thumb_func_start ov112_021EBBD8
ov112_021EBBD8: ; 0x021EBBD8
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021E9750
	cmp r0, #0
	beq _021EBBEC
	cmp r0, #1
	beq _021EBC22
	b _021EBC2C
_021EBBEC:
	add r0, r4, #0
	bl ov112_021EA570
	mov r1, #0x10
	mov r2, #0
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EBC34 ; =0x0001EA98
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _021EBC38 ; =0x0001EAA8
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	add sp, #0x10
	mov r0, #3
	pop {r4, pc}
_021EBC22:
	mov r0, #0xb
	str r0, [r4, #4]
	add sp, #0x10
	mov r0, #0x22
	pop {r4, pc}
_021EBC2C:
	mov r0, #2
	add sp, #0x10
	pop {r4, pc}
	nop
_021EBC34: .word 0x0001EA98
_021EBC38: .word 0x0001EAA8
	thumb_func_end ov112_021EBBD8

	thumb_func_start ov112_021EBC3C
ov112_021EBC3C: ; 0x021EBC3C
	push {r4, lr}
	sub sp, #0x10
	mov r1, #0
	mov r2, #4
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EBC78 ; =0x0001E524
	mov r2, #0
	str r0, [r4, r1]
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	mov r0, #4
	add sp, #0x10
	pop {r4, pc}
	nop
_021EBC78: .word 0x0001E524
	thumb_func_end ov112_021EBC3C

	thumb_func_start ov112_021EBC7C
ov112_021EBC7C: ; 0x021EBC7C
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _021EBCCC ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EBCC4
	ldr r0, _021EBCD0 ; =0x000F0100
	ldr r2, _021EBCD4 ; =0x0001E458
	str r0, [sp]
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r1, #5
	mov r3, #4
	bl ov112_021E9FA4
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xa
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA51C
	add sp, #4
	mov r0, #5
	pop {r3, r4, pc}
_021EBCC4:
	mov r0, #4
	add sp, #4
	pop {r3, r4, pc}
	nop
_021EBCCC: .word 0x0001E524
_021EBCD0: .word 0x000F0100
_021EBCD4: .word 0x0001E458
	thumb_func_end ov112_021EBC7C

	thumb_func_start ov112_021EBCD8
ov112_021EBCD8: ; 0x021EBCD8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	bl ov112_021E9888
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _021EBD00
	add r0, r4, #0
	add r2, r1, #2
	mov r3, #6
	bl ov112_021EC440
	ldr r0, _021EBD8C ; =0x000005DD
	bl PlaySE
	mov r0, #0x21
	pop {r4, pc}
_021EBD00:
	ldr r0, _021EBD90 ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _021EBD28
	ldr r0, _021EBD94 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021EBD18
	ldr r0, _021EBD98 ; =0x000005DC
	bl PlaySE
_021EBD18:
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA51C
	ldr r0, _021EBD94 ; =0x0001EC50
	mov r1, #0
	str r1, [r4, r0]
	b _021EBD86
_021EBD28:
	mov r1, #0x80
	tst r1, r0
	beq _021EBD4C
	ldr r0, _021EBD94 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #1
	beq _021EBD3C
	ldr r0, _021EBD98 ; =0x000005DC
	bl PlaySE
_021EBD3C:
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA51C
	ldr r0, _021EBD94 ; =0x0001EC50
	mov r1, #1
	str r1, [r4, r0]
	b _021EBD86
_021EBD4C:
	mov r1, #1
	tst r1, r0
	beq _021EBD6A
	ldr r0, _021EBD8C ; =0x000005DD
	bl PlaySE
	ldr r0, _021EBD94 ; =0x0001EC50
	mov r3, #6
	ldr r1, [r4, r0]
	add r0, r4, #0
	add r2, r1, #2
	bl ov112_021EC440
	mov r0, #0x21
	pop {r4, pc}
_021EBD6A:
	mov r1, #2
	tst r0, r1
	beq _021EBD86
	ldr r0, _021EBD98 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #3
	mov r3, #6
	bl ov112_021EC440
	mov r0, #0x21
	pop {r4, pc}
_021EBD86:
	mov r0, #5
	pop {r4, pc}
	nop
_021EBD8C: .word 0x000005DD
_021EBD90: .word gSystem
_021EBD94: .word 0x0001EC50
_021EBD98: .word 0x000005DC
	thumb_func_end ov112_021EBCD8

	thumb_func_start ov112_021EBD9C
ov112_021EBD9C: ; 0x021EBD9C
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021EA570
	ldr r0, _021EBDE0 ; =0x0001EAB8
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	mov r1, #0x10
	mov r2, #0
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EBDE4 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _021EBDD6
	add sp, #0x10
	mov r0, #0xb
	pop {r4, pc}
_021EBDD6:
	mov r0, #0xb
	str r0, [r4, #4]
	mov r0, #0x22
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EBDE0: .word 0x0001EAB8
_021EBDE4: .word 0x0001EC50
	thumb_func_end ov112_021EBD9C

	thumb_func_start ov112_021EBDE8
ov112_021EBDE8: ; 0x021EBDE8
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #2
	mov r2, #9
	bl ov112_021EA08C
	ldr r1, _021EBE48 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #8
	add sp, #0x10
	pop {r4, pc}
	nop
_021EBE48: .word 0x0001E524
	thumb_func_end ov112_021EBDE8

	thumb_func_start ov112_021EBE4C
ov112_021EBE4C: ; 0x021EBE4C
	push {r3, lr}
	ldr r1, _021EBE68 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EBE62
	mov r0, #9
	pop {r3, pc}
_021EBE62:
	mov r0, #8
	pop {r3, pc}
	nop
_021EBE68: .word 0x0001E524
	thumb_func_end ov112_021EBE4C

	thumb_func_start ov112_021EBE6C
ov112_021EBE6C: ; 0x021EBE6C
	push {r3, lr}
	mov r1, #1
	bl ov112_021E96D0
	mov r0, #0xa
	pop {r3, pc}
	thumb_func_end ov112_021EBE6C

	thumb_func_start ov112_021EBE78
ov112_021EBE78: ; 0x021EBE78
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021E9750
	cmp r0, #0
	beq _021EBE8C
	cmp r0, #1
	beq _021EBEC8
	b _021EBF04
_021EBE8C:
	add r0, r4, #0
	bl ov112_021EA570
	mov r1, #0x10
	mov r2, #0
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EBF0C ; =0x0001EA98
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _021EBF10 ; =0x0001EAA8
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _021EBF14 ; =0x0001F2E4
	mov r1, #0
	strh r1, [r4, r0]
	add sp, #0x10
	mov r0, #0xb
	pop {r4, pc}
_021EBEC8:
	mov r1, #0x10
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	mov r2, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EBF0C ; =0x0001EA98
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _021EBF10 ; =0x0001EAA8
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r4, #0
	bl ov112_021EA570
	ldr r0, _021EBF14 ; =0x0001F2E4
	mov r1, #1
	strh r1, [r4, r0]
	add sp, #0x10
	mov r0, #0xb
	pop {r4, pc}
_021EBF04:
	mov r0, #0xa
	add sp, #0x10
	pop {r4, pc}
	nop
_021EBF0C: .word 0x0001EA98
_021EBF10: .word 0x0001EAA8
_021EBF14: .word 0x0001F2E4
	thumb_func_end ov112_021EBE78

	thumb_func_start ov112_021EBF18
ov112_021EBF18: ; 0x021EBF18
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x10
	mov r3, #0xd
	bl ov112_021EC460
	mov r0, #0xc
	pop {r4, pc}
	thumb_func_end ov112_021EBF18

	thumb_func_start ov112_021EBF4C
ov112_021EBF4C: ; 0x021EBF4C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EBF6C ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EBF66
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	pop {r4, pc}
_021EBF66:
	mov r0, #0xc
	pop {r4, pc}
	nop
_021EBF6C: .word 0x0001E524
	thumb_func_end ov112_021EBF4C

	thumb_func_start ov112_021EBF70
ov112_021EBF70: ; 0x021EBF70
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xe
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	add r0, r4, #0
	bl ov112_021ED2F4
	add r0, r4, #0
	mov r1, #0
	mov r2, #5
	bl ov112_021EA08C
	ldr r1, _021EBFC4 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0xe
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EBFC4: .word 0x0001E524
	thumb_func_end ov112_021EBF70

	thumb_func_start ov112_021EBFC8
ov112_021EBFC8: ; 0x021EBFC8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EBFF8 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EBFF4
	ldr r0, _021EBFFC ; =0x0001F2E0
	ldrh r1, [r4, r0]
	mov r0, #1
	lsl r0, r0, #8
	cmp r1, r0
	bne _021EBFF4
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA5A4
	mov r0, #0xf
	pop {r4, pc}
_021EBFF4:
	mov r0, #0xe
	pop {r4, pc}
	.balign 4, 0
_021EBFF8: .word 0x0001E524
_021EBFFC: .word 0x0001F2E0
	thumb_func_end ov112_021EBFC8

	thumb_func_start ov112_021EC000
ov112_021EC000: ; 0x021EC000
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	bl ov112_021E7484
	ldr r1, _021EC028 ; =0x0000AABC
	ldr r2, _021EC02C ; =0x000006C8
	mov r0, #0
	add r1, r4, r1
	bl MIi_CpuClearFast
	ldr r1, _021EC030 ; =0x00009D70
	ldr r2, _021EC034 ; =0x00000D4C
	mov r0, #0
	add r1, r4, r1
	bl MIi_CpuClearFast
	mov r0, #0x10
	pop {r4, pc}
	nop
_021EC028: .word 0x0000AABC
_021EC02C: .word 0x000006C8
_021EC030: .word 0x00009D70
_021EC034: .word 0x00000D4C
	thumb_func_end ov112_021EC000

	thumb_func_start ov112_021EC038
ov112_021EC038: ; 0x021EC038
	push {r3, lr}
	bl ov112_021E7CC8
	mov r0, #0x11
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EC038

	thumb_func_start ov112_021EC044
ov112_021EC044: ; 0x021EC044
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r5, #0x11
	bl ov112_021E76A8
	cmp r0, #0xf
	bhi _021EC0C8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EC05E: ; jump table
	.short _021EC0C8 - _021EC05E - 2 ; case 0
	.short _021EC0C8 - _021EC05E - 2 ; case 1
	.short _021EC07E - _021EC05E - 2 ; case 2
	.short _021EC0C8 - _021EC05E - 2 ; case 3
	.short _021EC082 - _021EC05E - 2 ; case 4
	.short _021EC086 - _021EC05E - 2 ; case 5
	.short _021EC0C8 - _021EC05E - 2 ; case 6
	.short _021EC08A - _021EC05E - 2 ; case 7
	.short _021EC08E - _021EC05E - 2 ; case 8
	.short _021EC092 - _021EC05E - 2 ; case 9
	.short _021EC0C8 - _021EC05E - 2 ; case 10
	.short _021EC096 - _021EC05E - 2 ; case 11
	.short _021EC09A - _021EC05E - 2 ; case 12
	.short _021EC0C8 - _021EC05E - 2 ; case 13
	.short _021EC0C8 - _021EC05E - 2 ; case 14
	.short _021EC09E - _021EC05E - 2 ; case 15
_021EC07E:
	mov r5, #0x12
	b _021EC0C8
_021EC082:
	mov r5, #0x12
	b _021EC0C8
_021EC086:
	mov r5, #0x12
	b _021EC0C8
_021EC08A:
	mov r5, #0x12
	b _021EC0C8
_021EC08E:
	mov r5, #0x12
	b _021EC0C8
_021EC092:
	mov r5, #0x12
	b _021EC0C8
_021EC096:
	mov r5, #0x12
	b _021EC0C8
_021EC09A:
	mov r5, #0x12
	b _021EC0C8
_021EC09E:
	ldr r0, _021EC120 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	bl ov112_021EC134
	ldr r0, _021EC124 ; =0x0001E440
	ldr r0, [r4, r0]
	bl sub_02032624
	ldr r0, _021EC128 ; =0x0001D758
	mov r1, #0
	str r1, [r4, r0]
	add r0, r0, #4
	str r1, [r4, r0]
	bl ov112_021E7464
	mov r0, #0x14
	pop {r3, r4, r5, pc}
_021EC0C8:
	cmp r5, #0x11
	beq _021EC0D0
	bl ov112_021E7464
_021EC0D0:
	bl ov112_021E7668
	cmp r0, #0
	bne _021EC114
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E98E8
	mov r0, #5
	bl ov112_021E9888
	cmp r0, #0
	beq _021EC0FA
	ldr r0, _021EC12C ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _021EC0FA
	mov r0, #2
	tst r0, r1
	beq _021EC11C
_021EC0FA:
	bl ov112_021E7464
	add r0, r4, #0
	mov r1, #1
	mov r2, #3
	mov r3, #0x12
	bl ov112_021EC440
	ldr r0, _021EC130 ; =0x000005DC
	bl PlaySE
	mov r0, #0x21
	pop {r3, r4, r5, pc}
_021EC114:
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E98E8
_021EC11C:
	add r0, r5, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EC120: .word 0x0001E538
_021EC124: .word 0x0001E440
_021EC128: .word 0x0001D758
_021EC12C: .word gSystem
_021EC130: .word 0x000005DC
	thumb_func_end ov112_021EC044

	thumb_func_start ov112_021EC134
ov112_021EC134: ; 0x021EC134
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, [r5, #0x20]
	bl SaveArray_PCStorage_Get
	add r4, r0, #0
	ldr r0, _021EC1A0 ; =0x0001E440
	add r1, sp, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0
	ldr r6, _021EC1A4 ; =0x0001F2E8
	bl sub_02032688
	ldr r0, _021EC1A0 ; =0x0001E440
	add r1, r5, r6
	ldr r0, [r5, r0]
	bl Pokewalker_TryGetBoxMon
	cmp r0, #0
	beq _021EC192
	add r0, sp, #0
	ldrh r0, [r0]
	add r1, sp, #8
	add r2, sp, #4
	str r0, [sp, #8]
	add r0, r4, #0
	bl PCStorage_FindFirstEmptySlot
	ldr r1, [sp, #8]
	ldr r2, [sp, #4]
	add r0, r4, #0
	add r3, r5, r6
	bl PCStorage_PlaceMonInBoxByIndexPair
	ldr r1, [sp, #8]
	add r0, r6, #0
	add r0, #0x88
	add sp, #0xc
	strh r1, [r5, r0]
	pop {r3, r4, r5, r6, pc}
_021EC192:
	mov r1, #0
	mvn r1, r1
	add r0, r6, #0
	add r0, #0x88
	strh r1, [r5, r0]
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EC1A0: .word 0x0001E440
_021EC1A4: .word 0x0001F2E8
	thumb_func_end ov112_021EC134

	thumb_func_start ov112_021EC1A8
ov112_021EC1A8: ; 0x021EC1A8
	push {r4, lr}
	sub sp, #0x10
	mov r1, #0
	mov r2, #0x21
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EC1E0 ; =0x0001E524
	str r0, [r4, r1]
	add r0, r4, #0
	bl ov112_021EA570
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r0, #0x13
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EC1E0: .word 0x0001E524
	thumb_func_end ov112_021EC1A8

	thumb_func_start ov112_021EC1E4
ov112_021EC1E4: ; 0x021EC1E4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EC204 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EC200
	mov r0, #0xb
	str r0, [r4, #4]
	mov r0, #0x22
	pop {r4, pc}
_021EC200:
	mov r0, #0x13
	pop {r4, pc}
	.balign 4, 0
_021EC204: .word 0x0001E524
	thumb_func_end ov112_021EC1E4

	thumb_func_start ov112_021EC208
ov112_021EC208: ; 0x021EC208
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x40
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #5
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x1f
	bl ov112_021EA08C
	ldr r1, _021EC280 ; =0x0001E524
	mov r2, #0
	str r0, [r4, r1]
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r0, #0x15
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EC280: .word 0x0001E524
	thumb_func_end ov112_021EC208

	thumb_func_start ov112_021EC284
ov112_021EC284: ; 0x021EC284
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EC2A4 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EC2A0
	mov r0, #0
	str r0, [r4, #4]
	mov r0, #0x16
	pop {r4, pc}
_021EC2A0:
	mov r0, #0x15
	pop {r4, pc}
	.balign 4, 0
_021EC2A4: .word 0x0001E524
	thumb_func_end ov112_021EC284

	thumb_func_start ov112_021EC2A8
ov112_021EC2A8: ; 0x021EC2A8
	push {r4, lr}
	ldr r2, _021EC2D8 ; =0x0001F370
	add r4, r0, #0
	ldrsh r0, [r4, r2]
	cmp r0, #0
	blt _021EC2D4
	ldr r0, _021EC2DC ; =0x0001E448
	sub r2, #0x88
	ldr r0, [r4, r0]
	mov r1, #1
	add r2, r4, r2
	bl BufferBoxMonNickname
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x1a
	bl ov112_021EA08C
	ldr r1, _021EC2E0 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x17
	pop {r4, pc}
_021EC2D4:
	mov r0, #0x1d
	pop {r4, pc}
	.balign 4, 0
_021EC2D8: .word 0x0001F370
_021EC2DC: .word 0x0001E448
_021EC2E0: .word 0x0001E524
	thumb_func_end ov112_021EC2A8

	thumb_func_start ov112_021EC2E4
ov112_021EC2E4: ; 0x021EC2E4
	push {r3, lr}
	ldr r1, _021EC300 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EC2FA
	mov r0, #0x18
	pop {r3, pc}
_021EC2FA:
	mov r0, #0x17
	pop {r3, pc}
	nop
_021EC300: .word 0x0001E524
	thumb_func_end ov112_021EC2E4

	thumb_func_start ov112_021EC304
ov112_021EC304: ; 0x021EC304
	push {r4, lr}
	ldr r1, _021EC32C ; =0x0001F2D0
	add r4, r0, #0
	mov r2, #0
	str r2, [r4, r1]
	mov r1, #8
	bl ov112_021EA688
	ldr r2, _021EC330 ; =0x0001D7AC
	ldr r0, _021EC334 ; =0x0001F2E8
	add r1, r4, r2
	sub r2, #0x10
	add r0, r4, r0
	add r2, r4, r2
	mov r3, #0
	bl ov112_021E9290
	mov r0, #0x19
	pop {r4, pc}
	nop
_021EC32C: .word 0x0001F2D0
_021EC330: .word 0x0001D7AC
_021EC334: .word 0x0001F2E8
	thumb_func_end ov112_021EC304

	thumb_func_start ov112_021EC338
ov112_021EC338: ; 0x021EC338
	push {r4, lr}
	ldr r1, _021EC370 ; =0x0001F2D0
	add r4, r0, #0
	ldr r2, [r4, r1]
	add r2, r2, #1
	str r2, [r4, r1]
	ldr r1, [r4, r1]
	cmp r1, #0xb4
	ble _021EC354
	mov r1, #8
	bl ov112_021EA670
	mov r0, #0x1a
	pop {r4, pc}
_021EC354:
	bl MTRandom
	mov r1, #0xb4
	bl _u32_div_f
	ldr r0, _021EC370 ; =0x0001F2D0
	ldr r0, [r4, r0]
	cmp r0, r1
	bls _021EC36C
	add r0, r4, #0
	bl ov112_021EA7D0
_021EC36C:
	mov r0, #0x19
	pop {r4, pc}
	.balign 4, 0
_021EC370: .word 0x0001F2D0
	thumb_func_end ov112_021EC338

	thumb_func_start ov112_021EC374
ov112_021EC374: ; 0x021EC374
	mov r0, #0x1b
	bx lr
	thumb_func_end ov112_021EC374

	thumb_func_start ov112_021EC378
ov112_021EC378: ; 0x021EC378
	push {r4, lr}
	mov r1, #2
	mov r2, #0x1b
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EC38C ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x1c
	pop {r4, pc}
	.balign 4, 0
_021EC38C: .word 0x0001E524
	thumb_func_end ov112_021EC378

	thumb_func_start ov112_021EC390
ov112_021EC390: ; 0x021EC390
	push {r3, lr}
	ldr r1, _021EC3AC ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EC3A6
	mov r0, #0x1d
	pop {r3, pc}
_021EC3A6:
	mov r0, #0x1c
	pop {r3, pc}
	nop
_021EC3AC: .word 0x0001E524
	thumb_func_end ov112_021EC390

	thumb_func_start ov112_021EC3B0
ov112_021EC3B0: ; 0x021EC3B0
	push {r4, lr}
	mov r1, #2
	mov r2, #0xd
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EC3C4 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x1e
	pop {r4, pc}
	.balign 4, 0
_021EC3C4: .word 0x0001E524
	thumb_func_end ov112_021EC3B0

	thumb_func_start ov112_021EC3C8
ov112_021EC3C8: ; 0x021EC3C8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EC3EC ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EC3E6
	add r0, r4, #0
	bl ov112_021EA17C
	mov r0, #0x1f
	pop {r4, pc}
_021EC3E6:
	mov r0, #0x1e
	pop {r4, pc}
	nop
_021EC3EC: .word 0x0001E524
	thumb_func_end ov112_021EC3C8

	thumb_func_start ov112_021EC3F0
ov112_021EC3F0: ; 0x021EC3F0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x20]
	bl SaveGameNormal
	ldr r0, [r4, #0x20]
	bl Save_ClearStatusFlags
	mov r0, #0x20
	pop {r4, pc}
	thumb_func_end ov112_021EC3F0

	thumb_func_start ov112_021EC404
ov112_021EC404: ; 0x021EC404
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021EA19C
	mov r0, #0
	str r0, [r4, #4]
	mov r0, #0x22
	pop {r4, pc}
	thumb_func_end ov112_021EC404

	thumb_func_start ov112_021EC414
ov112_021EC414: ; 0x021EC414
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EC430 ; =0x0001E530
	ldr r0, [r4, r0]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _021EC42A
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	pop {r4, pc}
_021EC42A:
	mov r0, #0x21
	pop {r4, pc}
	nop
_021EC430: .word 0x0001E530
	thumb_func_end ov112_021EC414

	thumb_func_start ov112_021EC434
ov112_021EC434: ; 0x021EC434
	push {r3, lr}
	bl ov112_021EA570
	mov r0, #0x23
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EC434

	thumb_func_start ov112_021EC440
ov112_021EC440: ; 0x021EC440
	push {r3, r4, r5, lr}
	add r4, r3, #0
	ldr r3, _021EC45C ; =0x0001EC50
	add r5, r0, #0
	str r1, [r5, r3]
	add r1, r2, #0
	bl ov112_021EA51C
	add r0, r5, #0
	bl ov112_021EA584
	str r4, [r5, #0xc]
	pop {r3, r4, r5, pc}
	nop
_021EC45C: .word 0x0001EC50
	thumb_func_end ov112_021EC440

	thumb_func_start ov112_021EC460
ov112_021EC460: ; 0x021EC460
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r3, #0
	bl ov112_021EA08C
	ldr r1, _021EC474 ; =0x0001E524
	str r0, [r5, r1]
	str r4, [r5, #0xc]
	pop {r3, r4, r5, pc}
	nop
_021EC474: .word 0x0001E524
	thumb_func_end ov112_021EC460

	thumb_func_start ov112_021EC478
ov112_021EC478: ; 0x021EC478
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #4
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #5
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	add r0, r4, #0
	mov r1, #7
	bl ov112_021EA688
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	ldr r0, _021EC51C ; =0x0001F2E0
	mov r1, #0
	strh r1, [r4, r0]
	mov r0, #2
	add sp, #0x10
	pop {r4, pc}
	nop
_021EC51C: .word 0x0001F2E0
	thumb_func_end ov112_021EC478

	thumb_func_start ov112_021EC520
ov112_021EC520: ; 0x021EC520
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	lsl r2, r1, #2
	ldr r1, _021EC548 ; =ov112_021FF7CC
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4, #8]
	cmp r0, #0x43
	bne _021EC53C
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #3
	pop {r4, pc}
_021EC53C:
	add r0, r4, #0
	bl ov112_021EA864
	mov r0, #2
	pop {r4, pc}
	nop
_021EC548: .word ov112_021FF7CC
	thumb_func_end ov112_021EC520

	thumb_func_start ov112_021EC54C
ov112_021EC54C: ; 0x021EC54C
	ldr r1, _021EC558 ; =0x0001F2E0
	mov r2, #0
	strh r2, [r0, r1]
	mov r0, #1
	bx lr
	nop
_021EC558: .word 0x0001F2E0
	thumb_func_end ov112_021EC54C

	thumb_func_start ov112_021EC55C
ov112_021EC55C: ; 0x021EC55C
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, [r4, #0x10]
	cmp r0, #1
	bne _021EC572
	mov r0, #1
	str r0, [r4, #0xc]
	add sp, #0x10
	mov r0, #0x13
	pop {r4, pc}
_021EC572:
	cmp r0, #2
	bne _021EC580
	mov r0, #0x16
	str r0, [r4, #0xc]
	add sp, #0x10
	mov r0, #0x13
	pop {r4, pc}
_021EC580:
	cmp r0, #4
	bne _021EC58A
	add sp, #0x10
	mov r0, #0x2b
	pop {r4, pc}
_021EC58A:
	ldr r0, _021EC63C ; =0x0001D77C
	ldrh r0, [r4, r0]
	cmp r0, #0
	beq _021EC598
	add sp, #0x10
	mov r0, #5
	pop {r4, pc}
_021EC598:
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #4
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #5
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #4
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xb
	mov r3, #3
	bl ov112_021EC460
	mov r0, #0x40
	add sp, #0x10
	pop {r4, pc}
	nop
_021EC63C: .word 0x0001D77C
	thumb_func_end ov112_021EC55C

	thumb_func_start ov112_021EC640
ov112_021EC640: ; 0x021EC640
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xe
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	add r0, r4, #0
	mov r1, #0
	mov r2, #5
	bl ov112_021EA08C
	ldr r1, _021EC678 ; =0x0001E524
	str r0, [r4, r1]
	add r0, r4, #0
	bl ov112_021ED2F4
	mov r0, #2
	pop {r4, pc}
	nop
_021EC678: .word 0x0001E524
	thumb_func_end ov112_021EC640

	thumb_func_start ov112_021EC67C
ov112_021EC67C: ; 0x021EC67C
	push {r3, lr}
	ldr r1, _021EC698 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EC692
	mov r0, #0x1a
	pop {r3, pc}
_021EC692:
	mov r0, #2
	pop {r3, pc}
	nop
_021EC698: .word 0x0001E524
	thumb_func_end ov112_021EC67C

	thumb_func_start ov112_021EC69C
ov112_021EC69C: ; 0x021EC69C
	push {lr}
	sub sp, #0xc
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #4
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021EC69C

	thumb_func_start ov112_021EC6C0
ov112_021EC6C0: ; 0x021EC6C0
	push {r4, lr}
	add r4, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EC6D4
	mov r0, #7
	str r0, [r4, #4]
	mov r0, #0x42
	pop {r4, pc}
_021EC6D4:
	mov r0, #4
	pop {r4, pc}
	thumb_func_end ov112_021EC6C0

	thumb_func_start ov112_021EC6D8
ov112_021EC6D8: ; 0x021EC6D8
	push {lr}
	sub sp, #0xc
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #6
	add sp, #0xc
	pop {pc}
	thumb_func_end ov112_021EC6D8

	thumb_func_start ov112_021EC6F8
ov112_021EC6F8: ; 0x021EC6F8
	push {r3, lr}
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EC706
	mov r0, #7
	pop {r3, pc}
_021EC706:
	mov r0, #6
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EC6F8

	thumb_func_start ov112_021EC70C
ov112_021EC70C: ; 0x021EC70C
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #4
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #0
	mov r2, #0xc
	bl ov112_021EA08C
	ldr r1, _021EC774 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #8
	add sp, #0x10
	pop {r4, pc}
	nop
_021EC774: .word 0x0001E524
	thumb_func_end ov112_021EC70C

	thumb_func_start ov112_021EC778
ov112_021EC778: ; 0x021EC778
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EC7B4 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EC7B0
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #3
	bl ov112_021E9A78
	add r0, r4, #0
	mov r1, #2
	bl ov112_021E9A78
	mov r0, #9
	pop {r4, pc}
_021EC7B0:
	mov r0, #8
	pop {r4, pc}
	.balign 4, 0
_021EC7B4: .word 0x0001E524
	thumb_func_end ov112_021EC778

	thumb_func_start ov112_021EC7B8
ov112_021EC7B8: ; 0x021EC7B8
	push {r3, lr}
	ldr r1, _021EC7CC ; =0x0001EC76
	ldrh r0, [r0, r1]
	mov r1, #5
	sub r0, r0, #1
	bl _s32_div_f
	add r0, r0, #1
	pop {r3, pc}
	nop
_021EC7CC: .word 0x0001EC76
	thumb_func_end ov112_021EC7B8

	thumb_func_start ov112_021EC7D0
ov112_021EC7D0: ; 0x021EC7D0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	ldr r7, _021EC88C ; =0x000F0100
	add r5, r0, #0
	mov r4, #0
_021EC7DA:
	ldr r0, _021EC890 ; =0x0001EC54
	ldr r1, [r5, r0]
	lsl r0, r1, #2
	add r1, r1, r0
	add r0, r5, r4
	add r1, r1, r0
	ldr r0, _021EC894 ; =0x0001EC58
	ldrsb r1, [r1, r0]
	ldr r0, _021EC898 ; =0x0001E44C
	cmp r1, #0
	blt _021EC7FA
	ldr r0, [r5, r0]
	add r1, #0x5b
	bl NewString_ReadMsgData
	b _021EC802
_021EC7FA:
	ldr r0, [r5, r0]
	mov r1, #0x76
	bl NewString_ReadMsgData
_021EC802:
	add r6, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #4
	str r7, [sp]
	bl ov112_021E9FA4
	add r0, r6, #0
	bl String_Delete
	add r4, r4, #1
	cmp r4, #5
	blt _021EC7DA
	mov r0, #0
	str r0, [sp]
	mov r3, #1
	ldr r2, _021EC890 ; =0x0001EC54
	str r3, [sp, #4]
	ldr r0, _021EC89C ; =0x0001E448
	ldr r2, [r5, r2]
	ldr r0, [r5, r0]
	mov r1, #0xa
	add r2, r2, #1
	bl BufferIntegerAsString
	add r0, r5, #0
	bl ov112_021EC7B8
	add r2, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r3, #1
	ldr r0, _021EC89C ; =0x0001E448
	str r3, [sp, #4]
	ldr r0, [r5, r0]
	mov r1, #0xb
	bl BufferIntegerAsString
	ldr r1, _021EC89C ; =0x0001E448
	mov r2, #0x51
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r3, #0x9a
	bl ReadMsgData_ExpandPlaceholders
	add r4, r0, #0
	ldr r0, _021EC8A0 ; =0x00010E00
	mov r1, #7
	str r0, [sp]
	add r0, r5, #0
	add r2, r4, #0
	mov r3, #0
	bl ov112_021E9FA4
	add r0, r4, #0
	bl String_Delete
	ldr r2, _021EC890 ; =0x0001EC54
	add r0, r5, #0
	ldr r1, [r5, r2]
	sub r2, r2, #4
	ldr r2, [r5, r2]
	bl ov112_021EC8A4
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EC88C: .word 0x000F0100
_021EC890: .word 0x0001EC54
_021EC894: .word 0x0001EC58
_021EC898: .word 0x0001E44C
_021EC89C: .word 0x0001E448
_021EC8A0: .word 0x00010E00
	thumb_func_end ov112_021EC7D0

	thumb_func_start ov112_021EC8A4
ov112_021EC8A4: ; 0x021EC8A4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	cmp r2, #5
	beq _021EC8B8
	bl ov112_021ECA88
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021EC8EE
_021EC8B8:
	ldr r0, _021EC944 ; =0x0001E44C
	mov r1, #0x76
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r0, _021EC948 ; =0x00010200
	mov r1, #0
	str r0, [sp]
	add r0, r4, #0
	add r2, r5, #0
	add r3, r1, #0
	bl ov112_021EA010
	add r0, r5, #0
	bl String_Delete
	ldr r0, _021EC94C ; =0x0001EBB8
	mov r1, #0
	add r0, r4, r0
	bl FillWindowPixelBuffer
	ldr r0, _021EC94C ; =0x0001EBB8
	add r0, r4, r0
	bl CopyWindowToVram
	pop {r3, r4, r5, pc}
_021EC8EE:
	add r0, r4, #0
	bl ov112_021ECA88
	add r1, r0, #0
	ldr r0, _021EC944 ; =0x0001E44C
	add r1, #0x5b
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r0, _021EC948 ; =0x00010200
	mov r1, #0
	str r0, [sp]
	add r0, r4, #0
	add r2, r5, #0
	add r3, r1, #0
	bl ov112_021EA010
	add r0, r5, #0
	bl String_Delete
	add r0, r4, #0
	bl ov112_021ECA88
	add r1, r0, #0
	ldr r0, _021EC944 ; =0x0001E44C
	add r1, #0x77
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r0, _021EC948 ; =0x00010200
	mov r1, #1
	str r0, [sp]
	add r0, r4, #0
	add r2, r5, #0
	mov r3, #0
	bl ov112_021EA010
	add r0, r5, #0
	bl String_Delete
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EC944: .word 0x0001E44C
_021EC948: .word 0x00010200
_021EC94C: .word 0x0001EBB8
	thumb_func_end ov112_021EC8A4

	thumb_func_start ov112_021EC950
ov112_021EC950: ; 0x021EC950
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r0, _021EC990 ; =0x0001EC54
	mov r2, #0
	str r2, [r6, r0]
	sub r1, r0, #4
	str r2, [r6, r1]
	add r0, r0, #4
	add r0, r6, r0
	mov r1, #0xff
	mov r2, #0x1e
	bl MI_CpuFill8
	mov r5, #0
	ldr r7, _021EC994 ; =0x0001E440
	add r4, r5, #0
_021EC970:
	ldr r0, [r6, r7]
	add r1, r4, #0
	bl Pokewalker_CourseIsUnlocked
	cmp r0, #0
	beq _021EC984
	ldr r0, _021EC998 ; =0x0001EC58
	add r1, r6, r5
	strb r4, [r1, r0]
	add r5, r5, #1
_021EC984:
	add r4, r4, #1
	cmp r4, #0x1b
	blt _021EC970
	add r0, r5, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EC990: .word 0x0001EC54
_021EC994: .word 0x0001E440
_021EC998: .word 0x0001EC58
	thumb_func_end ov112_021EC950

	thumb_func_start ov112_021EC99C
ov112_021EC99C: ; 0x021EC99C
	push {r4, lr}
	sub sp, #0x10
	mov r1, #0x10
	add r4, r0, #0
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	mov r2, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x11
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x17
	bl ov112_021E7CA4
	add r0, r4, #0
	bl ov112_021EC950
	ldr r1, _021ECA08 ; =0x0001EC76
	strh r0, [r4, r1]
	add r0, r4, #0
	bl ov112_021EC7D0
	add r0, r4, #0
	mov r1, #6
	bl ov112_021E9F40
	ldr r1, _021ECA0C ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r1]
	bl ov112_021ECA18
	ldr r1, _021ECA10 ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021ECA14 ; =ov112_021FF0C4
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	mov r0, #0xa
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021ECA08: .word 0x0001EC76
_021ECA0C: .word 0x0001EC54
_021ECA10: .word 0x0001EC50
_021ECA14: .word ov112_021FF0C4
	thumb_func_end ov112_021EC99C

	thumb_func_start ov112_021ECA18
ov112_021ECA18: ; 0x021ECA18
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov112_021EC7B8
	ldr r1, _021ECA84 ; =0x0001EC76
	ldrh r1, [r5, r1]
	cmp r1, #5
	bls _021ECA72
	cmp r4, #0
	bne _021ECA40
	add r0, r5, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r5, #0
	mov r1, #4
	bl ov112_021EA670
	pop {r3, r4, r5, pc}
_021ECA40:
	ble _021ECA5A
	sub r1, r0, #1
	cmp r4, r1
	bge _021ECA5A
	add r0, r5, #0
	mov r1, #3
	bl ov112_021EA670
	add r0, r5, #0
	mov r1, #4
	bl ov112_021EA670
	pop {r3, r4, r5, pc}
_021ECA5A:
	sub r0, r0, #1
	cmp r4, r0
	bne _021ECA82
	add r0, r5, #0
	mov r1, #3
	bl ov112_021EA670
	add r0, r5, #0
	mov r1, #4
	bl ov112_021EA688
	pop {r3, r4, r5, pc}
_021ECA72:
	add r0, r5, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r5, #0
	mov r1, #4
	bl ov112_021EA688
_021ECA82:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021ECA84: .word 0x0001EC76
	thumb_func_end ov112_021ECA18

	thumb_func_start ov112_021ECA88
ov112_021ECA88: ; 0x021ECA88
	push {r3, r4}
	ldr r2, _021ECAA4 ; =0x0001EC50
	add r1, r2, #4
	ldr r3, [r0, r1]
	ldr r4, [r0, r2]
	lsl r1, r3, #2
	add r1, r3, r1
	add r1, r4, r1
	add r0, r0, r1
	add r2, #8
	ldrsb r0, [r0, r2]
	pop {r3, r4}
	bx lr
	nop
_021ECAA4: .word 0x0001EC50
	thumb_func_end ov112_021ECA88

	thumb_func_start ov112_021ECAA8
ov112_021ECAA8: ; 0x021ECAA8
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #4
	bl ov112_021E9888
	mov r1, #0
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	beq _021ECB7C
	cmp r5, #4
	bhi _021ECB1C
	ldr r0, _021ECCAC ; =0x0001EC50
	str r5, [r4, r0]
	add r0, r4, #0
	bl ov112_021ECA88
	cmp r0, #0
	blt _021ECAF6
	ldr r2, _021ECCB0 ; =ov112_021FF0C4
	lsl r3, r5, #2
	ldr r2, [r2, r3]
	add r0, r4, #0
	add r1, r5, #0
	mov r3, #0xb
	bl ov112_021EC440
	ldr r0, _021ECCB4 ; =0x000005DD
	bl PlaySE
	ldr r2, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r2]
	sub r2, r2, #4
	ldr r2, [r4, r2]
	bl ov112_021EC8A4
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021ECAF6:
	ldr r2, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r2]
	sub r2, r2, #4
	ldr r2, [r4, r2]
	bl ov112_021EC8A4
	ldr r0, _021ECCBC ; =0x000005DC
	bl PlaySE
	ldr r1, _021ECCAC ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021ECCB0 ; =ov112_021FF0C4
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	b _021ECB78
_021ECB1C:
	cmp r5, #6
	bne _021ECB3C
	add r0, r4, #0
	bl ov112_021ECDA0
	ldr r1, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r1]
	bl ov112_021ECA18
	add r0, r4, #0
	mov r1, #3
	mov r2, #2
	bl ov112_021EA6A0
	b _021ECB78
_021ECB3C:
	cmp r5, #7
	bne _021ECB5E
	add r0, r4, #0
	mov r1, #1
	bl ov112_021ECDA0
	ldr r1, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r1]
	bl ov112_021ECA18
	add r0, r4, #0
	mov r1, #4
	mov r2, #3
	bl ov112_021EA6A0
	b _021ECB78
_021ECB5E:
	ldr r2, _021ECCB0 ; =ov112_021FF0C4
	lsl r3, r5, #2
	ldr r2, [r2, r3]
	add r0, r4, #0
	add r1, r5, #0
	mov r3, #0xb
	bl ov112_021EC440
	ldr r0, _021ECCB4 ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021ECB78:
	mov r0, #0xa
	pop {r3, r4, r5, pc}
_021ECB7C:
	ldr r0, _021ECCC0 ; =gSystem
	mov r2, #0x40
	ldr r0, [r0, #0x48]
	tst r2, r0
	beq _021ECBB8
	ldr r0, _021ECCAC ; =0x0001EC50
	ldr r1, [r4, r0]
	cmp r1, #0
	ble _021ECB98
	sub r1, r1, #1
	str r1, [r4, r0]
	ldr r0, _021ECCBC ; =0x000005DC
	bl PlaySE
_021ECB98:
	ldr r1, _021ECCAC ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021ECCB0 ; =ov112_021FF0C4
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	ldr r2, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r2]
	sub r2, r2, #4
	ldr r2, [r4, r2]
	bl ov112_021EC8A4
	b _021ECCA6
_021ECBB8:
	mov r2, #0x80
	tst r2, r0
	beq _021ECBF0
	ldr r0, _021ECCAC ; =0x0001EC50
	ldr r1, [r4, r0]
	cmp r1, #5
	bge _021ECBD0
	add r1, r1, #1
	str r1, [r4, r0]
	ldr r0, _021ECCBC ; =0x000005DC
	bl PlaySE
_021ECBD0:
	ldr r1, _021ECCAC ; =0x0001EC50
	add r0, r4, #0
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _021ECCB0 ; =ov112_021FF0C4
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	ldr r2, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r2]
	sub r2, r2, #4
	ldr r2, [r4, r2]
	bl ov112_021EC8A4
	b _021ECCA6
_021ECBF0:
	mov r2, #0x20
	tst r2, r0
	beq _021ECC12
	add r0, r4, #0
	bl ov112_021ECDA0
	ldr r1, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r1]
	bl ov112_021ECA18
	add r0, r4, #0
	mov r1, #3
	mov r2, #2
	bl ov112_021EA6A0
	b _021ECCA6
_021ECC12:
	mov r1, #0x10
	tst r1, r0
	beq _021ECC36
	add r0, r4, #0
	mov r1, #1
	bl ov112_021ECDA0
	ldr r1, _021ECCB8 ; =0x0001EC54
	add r0, r4, #0
	ldr r1, [r4, r1]
	bl ov112_021ECA18
	add r0, r4, #0
	mov r1, #4
	mov r2, #3
	bl ov112_021EA6A0
	b _021ECCA6
_021ECC36:
	mov r1, #1
	tst r1, r0
	beq _021ECC8A
	ldr r0, _021ECCAC ; =0x0001EC50
	ldr r1, [r4, r0]
	cmp r1, #4
	ble _021ECC5C
	ldr r2, _021ECCB0 ; =ov112_021FF0C4
	lsl r3, r1, #2
	ldr r2, [r2, r3]
	add r0, r4, #0
	mov r3, #0xb
	bl ov112_021EC440
	ldr r0, _021ECCB4 ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021ECC5C:
	add r0, r4, #0
	bl ov112_021ECA88
	cmp r0, #0
	blt _021ECC82
	ldr r0, _021ECCAC ; =0x0001EC50
	ldr r2, _021ECCB0 ; =ov112_021FF0C4
	ldr r1, [r4, r0]
	add r0, r4, #0
	lsl r3, r1, #2
	ldr r2, [r2, r3]
	mov r3, #0xb
	bl ov112_021EC440
	ldr r0, _021ECCB4 ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021ECC82:
	ldr r0, _021ECCBC ; =0x000005DC
	bl PlaySE
	b _021ECCA6
_021ECC8A:
	mov r1, #2
	tst r0, r1
	beq _021ECCA6
	add r0, r4, #0
	mov r1, #5
	mov r2, #3
	mov r3, #0xb
	bl ov112_021EC440
	ldr r0, _021ECCBC ; =0x000005DC
	bl PlaySE
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021ECCA6:
	mov r0, #0xa
	pop {r3, r4, r5, pc}
	nop
_021ECCAC: .word 0x0001EC50
_021ECCB0: .word ov112_021FF0C4
_021ECCB4: .word 0x000005DD
_021ECCB8: .word 0x0001EC54
_021ECCBC: .word 0x000005DC
_021ECCC0: .word gSystem
	thumb_func_end ov112_021ECAA8

	thumb_func_start ov112_021ECCC4
ov112_021ECCC4: ; 0x021ECCC4
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021EA570
	ldr r0, _021ECD90 ; =0x0001EC50
	ldr r1, [r4, r0]
	cmp r1, #5
	bhi _021ECD80
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021ECCE2: ; jump table
	.short _021ECCEE - _021ECCE2 - 2 ; case 0
	.short _021ECCEE - _021ECCE2 - 2 ; case 1
	.short _021ECCEE - _021ECCE2 - 2 ; case 2
	.short _021ECCEE - _021ECCE2 - 2 ; case 3
	.short _021ECCEE - _021ECCE2 - 2 ; case 4
	.short _021ECD34 - _021ECCE2 - 2 ; case 5
_021ECCEE:
	lsl r2, r1, #2
	ldr r1, _021ECD94 ; =ov112_021FF0C4
	add r0, r4, #0
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	add r0, r4, #0
	bl ov112_021ECA88
	cmp r0, #0
	blt _021ECD88
	add r0, r4, #0
	bl ov112_021EA570
	mov r1, #0x10
	mov r2, #0
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	add r0, r4, #0
	bl ov112_021ECA88
	ldr r1, _021ECD98 ; =0x0001D798
	add sp, #0x10
	str r0, [r4, r1]
	mov r0, #0xc
	pop {r4, pc}
_021ECD34:
	add r0, r4, #0
	mov r1, #2
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E9A78
	ldr r0, _021ECD9C ; =0x0001D77C
	mov r1, #0
	strh r1, [r4, r0]
	add r0, r4, #0
	bl ov112_021EA570
	mov r1, #0x10
	mov r2, #0
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	add sp, #0x10
	mov r0, #0
	pop {r4, pc}
_021ECD80:
	cmp r1, #6
	blt _021ECD88
	bl GF_AssertFail
_021ECD88:
	mov r0, #0xa
	add sp, #0x10
	pop {r4, pc}
	nop
_021ECD90: .word 0x0001EC50
_021ECD94: .word ov112_021FF0C4
_021ECD98: .word 0x0001D798
_021ECD9C: .word 0x0001D77C
	thumb_func_end ov112_021ECCC4

	thumb_func_start ov112_021ECDA0
ov112_021ECDA0: ; 0x021ECDA0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	cmp r1, #0
	ldr r1, _021ECE18 ; =0x0001EC50
	bge _021ECDD2
	ldr r0, [r5, r1]
	cmp r0, #5
	beq _021ECDFE
	add r0, r1, #4
	ldr r0, [r5, r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	cmp r0, #0
	ble _021ECDFE
	add r0, r1, #4
	ldr r0, [r5, r0]
	sub r2, r0, #1
	add r0, r1, #4
	str r2, [r5, r0]
	mov r0, #0
	str r0, [r5, r1]
	ldr r0, _021ECE1C ; =0x000005DC
	bl PlaySE
	b _021ECDFE
_021ECDD2:
	ldr r2, [r5, r1]
	cmp r2, #5
	beq _021ECDFE
	add r1, r1, #4
	ldr r1, [r5, r1]
	lsl r1, r1, #0x18
	asr r4, r1, #0x18
	bl ov112_021EC7B8
	sub r0, r0, #1
	cmp r4, r0
	bge _021ECDFE
	ldr r0, _021ECE20 ; =0x0001EC54
	ldr r1, [r5, r0]
	add r1, r1, #1
	str r1, [r5, r0]
	mov r1, #0
	sub r0, r0, #4
	str r1, [r5, r0]
	ldr r0, _021ECE1C ; =0x000005DC
	bl PlaySE
_021ECDFE:
	ldr r1, _021ECE18 ; =0x0001EC50
	add r0, r5, #0
	ldr r1, [r5, r1]
	lsl r2, r1, #2
	ldr r1, _021ECE24 ; =ov112_021FF0C4
	ldr r1, [r1, r2]
	bl ov112_021EA51C
	add r0, r5, #0
	bl ov112_021EC7D0
	pop {r3, r4, r5, pc}
	nop
_021ECE18: .word 0x0001EC50
_021ECE1C: .word 0x000005DC
_021ECE20: .word 0x0001EC54
_021ECE24: .word ov112_021FF0C4
	thumb_func_end ov112_021ECDA0

	thumb_func_start ov112_021ECE28
ov112_021ECE28: ; 0x021ECE28
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #4
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #2
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E9A78
	ldr r2, _021ECEC0 ; =0x0001D798
	ldr r0, _021ECEC4 ; =0x0001E448
	ldr r2, [r4, r2]
	ldr r0, [r4, r0]
	lsl r2, r2, #0x18
	mov r1, #0
	lsr r2, r2, #0x18
	bl BufferPokewalkerCourseName
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x15
	bl ov112_021EA08C
	ldr r1, _021ECEC8 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0xd
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021ECEC0: .word 0x0001D798
_021ECEC4: .word 0x0001E448
_021ECEC8: .word 0x0001E524
	thumb_func_end ov112_021ECE28

	thumb_func_start ov112_021ECECC
ov112_021ECECC: ; 0x021ECECC
	push {r3, lr}
	ldr r1, _021ECEE8 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021ECEE2
	mov r0, #0xe
	pop {r3, pc}
_021ECEE2:
	mov r0, #0xd
	pop {r3, pc}
	nop
_021ECEE8: .word 0x0001E524
	thumb_func_end ov112_021ECECC

	thumb_func_start ov112_021ECEEC
ov112_021ECEEC: ; 0x021ECEEC
	push {r3, lr}
	mov r1, #0
	bl ov112_021E966C
	mov r0, #0xf
	pop {r3, pc}
	thumb_func_end ov112_021ECEEC

	thumb_func_start ov112_021ECEF8
ov112_021ECEF8: ; 0x021ECEF8
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021E9750
	cmp r0, #0
	beq _021ECF0A
	cmp r0, #1
	beq _021ECF2A
	b _021ECF34
_021ECF0A:
	add r0, r4, #0
	bl ov112_021EA570
	add r0, r4, #0
	bl ov112_021E9338
	cmp r0, #1
	bne _021ECF22
	mov r0, #0x14
	str r0, [r4, #0xc]
	mov r0, #0x12
	pop {r4, pc}
_021ECF22:
	mov r0, #0x10
	str r0, [r4, #0xc]
	mov r0, #0x12
	pop {r4, pc}
_021ECF2A:
	add r0, r4, #0
	bl ov112_021EA570
	mov r0, #7
	pop {r4, pc}
_021ECF34:
	mov r0, #0xf
	pop {r4, pc}
	thumb_func_end ov112_021ECEF8

	thumb_func_start ov112_021ECF38
ov112_021ECF38: ; 0x021ECF38
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #4
	bl ov112_021EA688
	add r0, r4, #0
	bl ov112_021ED2F4
	add r0, r4, #0
	mov r1, #0
	mov r2, #7
	bl ov112_021EA08C
	ldr r1, _021ECF84 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x11
	pop {r4, pc}
	.balign 4, 0
_021ECF84: .word 0x0001E524
	thumb_func_end ov112_021ECF38

	thumb_func_start ov112_021ECF88
ov112_021ECF88: ; 0x021ECF88
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021ECFCC ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021ECFC6
	ldr r0, _021ECFD0 ; =0x0001F2D6
	ldrh r1, [r4, r0]
	cmp r1, #0x1f
	bne _021ECFC6
	add r0, #0xa
	ldrh r1, [r4, r0]
	mov r0, #1
	lsl r0, r0, #8
	cmp r1, r0
	bne _021ECFC6
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xe
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	mov r0, #0x18
	pop {r4, pc}
_021ECFC6:
	mov r0, #0x11
	pop {r4, pc}
	nop
_021ECFCC: .word 0x0001E524
_021ECFD0: .word 0x0001F2D6
	thumb_func_end ov112_021ECF88

	thumb_func_start ov112_021ECFD4
ov112_021ECFD4: ; 0x021ECFD4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #4
	bl ov112_021EA688
	add r0, r4, #0
	bl ov112_021ED0D0
	ldr r3, [r4, #0xc]
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x10
	bl ov112_021EC460
	mov r0, #0x40
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021ECFD4

	thumb_func_start ov112_021ED020
ov112_021ED020: ; 0x021ED020
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r3, [r4, #0xc]
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x10
	bl ov112_021EC460
	mov r0, #0x40
	pop {r4, pc}
	thumb_func_end ov112_021ED020

	thumb_func_start ov112_021ED054
ov112_021ED054: ; 0x021ED054
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xe
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	add r0, r4, #0
	mov r1, #0
	mov r2, #5
	bl ov112_021EA08C
	ldr r1, _021ED08C ; =0x0001E524
	str r0, [r4, r1]
	add r0, r4, #0
	bl ov112_021ED2F4
	mov r0, #0x15
	pop {r4, pc}
	nop
_021ED08C: .word 0x0001E524
	thumb_func_end ov112_021ED054

	thumb_func_start ov112_021ED090
ov112_021ED090: ; 0x021ED090
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021ED0C0 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021ED0BC
	ldr r0, _021ED0C4 ; =0x0001F2D6
	ldrh r1, [r4, r0]
	cmp r1, #0x1f
	bne _021ED0BC
	add r0, #0xa
	ldrh r1, [r4, r0]
	mov r0, #1
	lsl r0, r0, #8
	cmp r1, r0
	bne _021ED0BC
	mov r0, #0x1e
	pop {r4, pc}
_021ED0BC:
	mov r0, #0x15
	pop {r4, pc}
	.balign 4, 0
_021ED0C0: .word 0x0001E524
_021ED0C4: .word 0x0001F2D6
	thumb_func_end ov112_021ED090

	thumb_func_start ov112_021ED0C8
ov112_021ED0C8: ; 0x021ED0C8
	ldr r3, _021ED0CC ; =ov112_021ED0D0
	bx r3
	.balign 4, 0
_021ED0CC: .word ov112_021ED0D0
	thumb_func_end ov112_021ED0C8

	thumb_func_start ov112_021ED0D0
ov112_021ED0D0: ; 0x021ED0D0
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _021ED120 ; =0x0001E430
	ldr r2, _021ED124 ; =0x0001D7AC
	ldr r0, [r4, r0]
	add r1, r4, r2
	sub r2, #0x10
	add r2, r4, r2
	mov r3, #0
	bl ov112_021E9290
	ldr r0, _021ED128 ; =0x0001E550
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetOamMode
	add r0, r4, #0
	mov r1, #8
	bl ov112_021EA670
	mov r1, #0
	ldr r0, _021ED12C ; =0x0001F2D6
	mov r2, #8
	strh r1, [r4, r0]
	mov r0, #0x1f
	str r0, [sp]
	ldr r0, _021ED130 ; =0x04000050
	add r3, r1, #0
	bl G2x_SetBlendAlpha_
	ldr r0, _021ED134 ; =ov112_021ED13C
	add r1, r4, #0
	mov r2, #2
	bl SysTask_CreateOnMainQueue
	ldr r1, _021ED138 ; =0x0001F2D8
	str r0, [r4, r1]
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021ED120: .word 0x0001E430
_021ED124: .word 0x0001D7AC
_021ED128: .word 0x0001E550
_021ED12C: .word 0x0001F2D6
_021ED130: .word 0x04000050
_021ED134: .word ov112_021ED13C
_021ED138: .word 0x0001F2D8
	thumb_func_end ov112_021ED0D0

	thumb_func_start ov112_021ED13C
ov112_021ED13C: ; 0x021ED13C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021ED178 ; =0x0001F2D6
	add r4, r1, #0
	ldrh r1, [r4, r0]
	add r1, r1, #2
	strh r1, [r4, r0]
	ldrh r1, [r4, r0]
	cmp r1, #0x1f
	blo _021ED154
	mov r1, #0x1f
	strh r1, [r4, r0]
_021ED154:
	ldr r0, _021ED178 ; =0x0001F2D6
	mov r1, #0
	ldrh r3, [r4, r0]
	mov r0, #0x1f
	mov r2, #8
	sub r0, r0, r3
	str r0, [sp]
	ldr r0, _021ED17C ; =0x04000050
	bl G2x_SetBlendAlpha_
	ldr r0, _021ED178 ; =0x0001F2D6
	ldrh r0, [r4, r0]
	cmp r0, #0x1f
	bne _021ED176
	add r0, r5, #0
	bl SysTask_Destroy
_021ED176:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021ED178: .word 0x0001F2D6
_021ED17C: .word 0x04000050
	thumb_func_end ov112_021ED13C

	thumb_func_start ov112_021ED180
ov112_021ED180: ; 0x021ED180
	push {r4, lr}
	ldr r2, _021ED19C ; =0x0001F2E0
	ldrh r3, [r1, r2]
	add r3, #0x10
	strh r3, [r1, r2]
	ldrh r4, [r1, r2]
	mov r3, #1
	lsl r3, r3, #8
	cmp r4, r3
	bls _021ED19A
	strh r3, [r1, r2]
	bl SysTask_Destroy
_021ED19A:
	pop {r4, pc}
	.balign 4, 0
_021ED19C: .word 0x0001F2E0
	thumb_func_end ov112_021ED180

	thumb_func_start ov112_021ED1A0
ov112_021ED1A0: ; 0x021ED1A0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #2
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #3
	bl ov112_021E9C10
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E9A78
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9A78
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xe
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #4
	bl ov112_021EA688
	add r0, r4, #0
	bl ov112_021ED2F4
	add r0, r4, #0
	mov r1, #0
	mov r2, #5
	bl ov112_021EA08C
	ldr r1, _021ED220 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x17
	pop {r4, pc}
	nop
_021ED220: .word 0x0001E524
	thumb_func_end ov112_021ED1A0

	thumb_func_start ov112_021ED224
ov112_021ED224: ; 0x021ED224
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021ED254 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021ED250
	ldr r0, _021ED258 ; =0x0001F2E0
	ldrh r1, [r4, r0]
	mov r0, #1
	lsl r0, r0, #8
	cmp r1, r0
	bne _021ED250
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA5A4
	mov r0, #0x1c
	pop {r4, pc}
_021ED250:
	mov r0, #0x17
	pop {r4, pc}
	.balign 4, 0
_021ED254: .word 0x0001E524
_021ED258: .word 0x0001F2E0
	thumb_func_end ov112_021ED224

	thumb_func_start ov112_021ED25C
ov112_021ED25C: ; 0x021ED25C
	mov r1, #0
	strh r1, [r0, #0x14]
	strh r1, [r0, #0x16]
	bx lr
	thumb_func_end ov112_021ED25C

	thumb_func_start ov112_021ED264
ov112_021ED264: ; 0x021ED264
	push {r4, lr}
	ldr r1, _021ED2D4 ; =0x0000AABC
	add r4, r0, #0
	ldr r2, _021ED2D8 ; =0x000006C8
	mov r0, #0
	add r1, r4, r1
	bl MIi_CpuClearFast
	ldr r1, _021ED2DC ; =0x00009D70
	ldr r2, _021ED2E0 ; =0x00000D4C
	mov r0, #0
	add r1, r4, r1
	bl MIi_CpuClearFast
	add r0, r4, #0
	mov r1, #2
	mov r2, #0xe
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	add r0, r4, #0
	bl ov112_021E7D7C
	ldr r0, _021ED2E4 ; =0x000010F4
	ldr r1, _021ED2E8 ; =0x0000C910
	ldr r2, _021ED2EC ; =0x0000F1D0
	add r0, r4, r0
	add r1, r4, r1
	add r2, r4, r2
	bl ov112_021E74A8
	add r0, r4, #0
	bl ov112_021E7CC8
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA5A4
	ldr r0, _021ED2F0 ; =0x0001E550
	mov r1, #0x19
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
	ldr r0, _021ED2F0 ; =0x0001E550
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimationFrame
	add r0, r4, #0
	bl ov112_021ED25C
	mov r0, #0x19
	pop {r4, pc}
	.balign 4, 0
_021ED2D4: .word 0x0000AABC
_021ED2D8: .word 0x000006C8
_021ED2DC: .word 0x00009D70
_021ED2E0: .word 0x00000D4C
_021ED2E4: .word 0x000010F4
_021ED2E8: .word 0x0000C910
_021ED2EC: .word 0x0000F1D0
_021ED2F0: .word 0x0001E550
	thumb_func_end ov112_021ED264

	thumb_func_start ov112_021ED2F4
ov112_021ED2F4: ; 0x021ED2F4
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021E98A4
	ldr r0, _021ED30C ; =ov112_021ED180
	add r1, r4, #0
	mov r2, #2
	bl SysTask_CreateOnMainQueue
	ldr r1, _021ED310 ; =0x0001F2DC
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_021ED30C: .word ov112_021ED180
_021ED310: .word 0x0001F2DC
	thumb_func_end ov112_021ED2F4

	thumb_func_start ov112_021ED314
ov112_021ED314: ; 0x021ED314
	push {r3, lr}
	cmp r0, #0
	beq _021ED32A
	ldr r0, _021ED32C ; =0x00000934
	bl IsSEPlaying
	cmp r0, #0
	bne _021ED32A
	ldr r0, _021ED32C ; =0x00000934
	bl PlaySE
_021ED32A:
	pop {r3, pc}
	.balign 4, 0
_021ED32C: .word 0x00000934
	thumb_func_end ov112_021ED314

	thumb_func_start ov112_021ED330
ov112_021ED330: ; 0x021ED330
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov112_021E7668
	cmp r0, #0
	ldr r0, _021ED358 ; =0x0001D760
	beq _021ED34E
	ldrh r1, [r5, r0]
	cmp r1, r4
	bge _021ED34A
	strh r4, [r5, r0]
	b _021ED352
_021ED34A:
	add r4, r1, #0
	b _021ED352
_021ED34E:
	mov r1, #0
	strh r1, [r5, r0]
_021ED352:
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	nop
_021ED358: .word 0x0001D760
	thumb_func_end ov112_021ED330

	thumb_func_start ov112_021ED35C
ov112_021ED35C: ; 0x021ED35C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov112_021E7670
	bl ov112_021E768C
	add r1, r0, #0
	add r0, r4, #0
	bl ov112_021ED330
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	bl MTRandom
	mov r1, #0xff
	bl _u32_div_f
	cmp r5, r1
	bls _021ED388
	add r0, r4, #0
	bl ov112_021EA76C
_021ED388:
	add r0, r4, #0
	bl ov112_021EA60C
	add r0, r5, #0
	bl ov112_021ED314
	add r0, r4, #0
	add r1, r5, #0
	bl ov112_021EDAF4
	cmp r5, #0xc8
	bls _021ED3BC
	ldr r1, _021ED4BC ; =0x0001F2D4
	ldrh r0, [r4, r1]
	cmp r0, #0
	bne _021ED3C8
	sub r1, #0x14
	add r0, r4, #0
	add r1, r4, r1
	mov r2, #2
	bl ov112_021EAA98
	ldr r0, _021ED4BC ; =0x0001F2D4
	mov r1, #1
	strh r1, [r4, r0]
	b _021ED3C8
_021ED3BC:
	add r0, r4, #0
	bl ov112_021EAA10
	ldr r0, _021ED4BC ; =0x0001F2D4
	mov r1, #0
	strh r1, [r4, r0]
_021ED3C8:
	bl ov112_021E76A8
	cmp r0, #0xf
	bhi _021ED436
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021ED3DC: ; jump table
	.short _021ED436 - _021ED3DC - 2 ; case 0
	.short _021ED436 - _021ED3DC - 2 ; case 1
	.short _021ED3FC - _021ED3DC - 2 ; case 2
	.short _021ED436 - _021ED3DC - 2 ; case 3
	.short _021ED408 - _021ED3DC - 2 ; case 4
	.short _021ED436 - _021ED3DC - 2 ; case 5
	.short _021ED436 - _021ED3DC - 2 ; case 6
	.short _021ED408 - _021ED3DC - 2 ; case 7
	.short _021ED408 - _021ED3DC - 2 ; case 8
	.short _021ED408 - _021ED3DC - 2 ; case 9
	.short _021ED436 - _021ED3DC - 2 ; case 10
	.short _021ED408 - _021ED3DC - 2 ; case 11
	.short _021ED408 - _021ED3DC - 2 ; case 12
	.short _021ED408 - _021ED3DC - 2 ; case 13
	.short _021ED436 - _021ED3DC - 2 ; case 14
	.short _021ED40C - _021ED3DC - 2 ; case 15
_021ED3FC:
	ldrh r0, [r4, #0x16]
	cmp r0, #1
	bne _021ED436
	mov r0, #0x2a
	strh r0, [r4, #0x14]
	b _021ED436
_021ED408:
	strh r0, [r4, #0x14]
	b _021ED436
_021ED40C:
	ldr r0, _021ED4C0 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021ED4C4 ; =0x0001E440
	ldr r0, [r4, r0]
	bl sub_02032644
	add r0, r4, #0
	mov r1, #8
	bl ov112_021EA688
	ldr r1, _021ED4C8 ; =0x0001F2C0
	add r0, r4, #0
	add r1, r4, r1
	mov r2, #0
	bl ov112_021EAA98
	mov r0, #0x23
	pop {r3, r4, r5, pc}
_021ED436:
	ldrh r0, [r4, #0x14]
	cmp r0, #0
	beq _021ED452
	ldr r0, _021ED4C0 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	mov r0, #0x3a
	str r0, [r4, #0xc]
	bl ov112_021E7464
	mov r0, #0x20
	pop {r3, r4, r5, pc}
_021ED452:
	bl ov112_021E7668
	cmp r0, #0
	bne _021ED49A
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E98E8
	mov r0, #5
	bl ov112_021E9888
	cmp r0, #0
	beq _021ED47C
	ldr r0, _021ED4CC ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _021ED47C
	mov r0, #2
	tst r0, r1
	beq _021ED4B6
_021ED47C:
	mov r0, #0x21
	strh r0, [r4, #0x14]
	bl ov112_021E7464
	mov r1, #3
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x21
	bl ov112_021EC440
	ldr r0, _021ED4D0 ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021ED49A:
	ldrh r0, [r4, #0x16]
	cmp r0, #0
	bne _021ED4AE
	add r0, r4, #0
	mov r1, #2
	mov r2, #6
	bl ov112_021EA10C
	mov r0, #1
	strh r0, [r4, #0x16]
_021ED4AE:
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E98E8
_021ED4B6:
	mov r0, #0x19
	pop {r3, r4, r5, pc}
	nop
_021ED4BC: .word 0x0001F2D4
_021ED4C0: .word 0x0001E538
_021ED4C4: .word 0x0001E440
_021ED4C8: .word 0x0001F2C0
_021ED4CC: .word gSystem
_021ED4D0: .word 0x000005DD
	thumb_func_end ov112_021ED35C

	thumb_func_start ov112_021ED4D4
ov112_021ED4D4: ; 0x021ED4D4
	push {r4, lr}
	ldr r1, _021ED51C ; =0x00009DFC
	add r4, r0, #0
	mov r2, #0x33
	mov r0, #0
	add r1, r4, r1
	lsl r2, r2, #6
	bl MIi_CpuClearFast
	ldr r1, _021ED520 ; =0x00009D44
	ldr r2, _021ED524 ; =0x0000AABC
	ldr r3, _021ED528 ; =0x0000B184
	add r0, r4, r1
	add r1, #0x2c
	add r1, r4, r1
	add r2, r4, r2
	add r3, r4, r3
	bl ov112_021E7548
	add r0, r4, #0
	bl ov112_021E7CC8
	add r0, r4, #0
	bl ov112_021ED25C
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA5A4
	ldr r0, _021ED52C ; =0x0001E550
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimationFrame
	mov r0, #0x1b
	pop {r4, pc}
	.balign 4, 0
_021ED51C: .word 0x00009DFC
_021ED520: .word 0x00009D44
_021ED524: .word 0x0000AABC
_021ED528: .word 0x0000B184
_021ED52C: .word 0x0001E550
	thumb_func_end ov112_021ED4D4

	thumb_func_start ov112_021ED530
ov112_021ED530: ; 0x021ED530
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r0, [r6, #0x20]
	bl Save_LocalFieldData_Get
	bl LocalFieldData_GetCurrentPosition
	ldr r1, [r0]
	ldr r0, _021ED57C ; =0x000001F3
	cmp r1, r0
	beq _021ED57A
	ldr r0, _021ED580 ; =0x00001344
	mov r4, #9
	add r5, r6, r0
	ldr r0, _021ED584 ; =0x0000B1B4
	add r7, r6, r0
_021ED550:
	ldr r0, _021ED588 ; =0x0000B3AC
	ldrh r1, [r5, r0]
	ldr r0, _021ED58C ; =0x0000FFF9
	add r0, r1, r0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	cmp r0, #1
	bhi _021ED570
	mov r1, #0x89
	add r2, r4, #1
	lsl r1, r1, #2
	mul r1, r2
	ldr r0, [r6, #0x20]
	add r1, r7, r1
	bl ov112_021F328C
_021ED570:
	mov r0, #0x89
	lsl r0, r0, #2
	sub r5, r5, r0
	sub r4, r4, #1
	bpl _021ED550
_021ED57A:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021ED57C: .word 0x000001F3
_021ED580: .word 0x00001344
_021ED584: .word 0x0000B1B4
_021ED588: .word 0x0000B3AC
_021ED58C: .word 0x0000FFF9
	thumb_func_end ov112_021ED530

	thumb_func_start ov112_021ED590
ov112_021ED590: ; 0x021ED590
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021ED5CC ; =0x0001E440
	ldr r2, _021ED5D0 ; =0x0001D758
	ldr r0, [r4, r0]
	add r1, r4, r2
	add r2, r2, #4
	add r2, r4, r2
	bl sub_02032674
	ldr r0, _021ED5D4 ; =0x000010F0
	ldr r2, [r4, r0]
	ldr r0, _021ED5D0 ; =0x0001D758
	ldr r1, [r4, r0]
	cmp r2, r1
	ldr r0, _021ED5CC ; =0x0001E440
	bhs _021ED5BE
	ldr r2, _021ED5D8 ; =0x00009D7A
	ldr r0, [r4, r0]
	ldrh r2, [r4, r2]
	bl sub_02032650
	pop {r4, pc}
_021ED5BE:
	add r1, r2, #0
	ldr r2, _021ED5D8 ; =0x00009D7A
	ldr r0, [r4, r0]
	ldrh r2, [r4, r2]
	bl sub_02032650
	pop {r4, pc}
	.balign 4, 0
_021ED5CC: .word 0x0001E440
_021ED5D0: .word 0x0001D758
_021ED5D4: .word 0x000010F0
_021ED5D8: .word 0x00009D7A
	thumb_func_end ov112_021ED590

	thumb_func_start ov112_021ED5DC
ov112_021ED5DC: ; 0x021ED5DC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021ED604 ; =0x0001E440
	ldr r2, _021ED608 ; =0x0001D758
	ldr r0, [r4, r0]
	add r1, r4, r2
	add r2, r2, #4
	add r2, r4, r2
	bl sub_02032674
	ldr r2, _021ED60C ; =0x00009D7A
	ldr r0, _021ED604 ; =0x0001E440
	ldr r1, _021ED608 ; =0x0001D758
	ldrh r2, [r4, r2]
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	bl sub_02032650
	pop {r4, pc}
	nop
_021ED604: .word 0x0001E440
_021ED608: .word 0x0001D758
_021ED60C: .word 0x00009D7A
	thumb_func_end ov112_021ED5DC

	thumb_func_start ov112_021ED610
ov112_021ED610: ; 0x021ED610
	ldr r1, _021ED634 ; =0x000010E7
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x1d
	lsr r1, r1, #0x1f
	cmp r1, #1
	bne _021ED62E
	ldr r1, _021ED638 ; =0x00009D44
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021ED62A
	ldr r0, _021ED63C ; =0x000001ED
	cmp r1, r0
	bls _021ED62E
_021ED62A:
	mov r0, #0
	bx lr
_021ED62E:
	mov r0, #1
	bx lr
	nop
_021ED634: .word 0x000010E7
_021ED638: .word 0x00009D44
_021ED63C: .word 0x000001ED
	thumb_func_end ov112_021ED610

	thumb_func_start ov112_021ED640
ov112_021ED640: ; 0x021ED640
	ldr r1, _021ED664 ; =0x0000AABC
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x1a
	lsr r1, r1, #0x1f
	cmp r1, #1
	bne _021ED660
	mov r1, #0xad
	lsl r1, r1, #8
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021ED65C
	ldr r0, _021ED668 ; =0x000001ED
	cmp r1, r0
	bls _021ED660
_021ED65C:
	mov r0, #0
	bx lr
_021ED660:
	mov r0, #1
	bx lr
	.balign 4, 0
_021ED664: .word 0x0000AABC
_021ED668: .word 0x000001ED
	thumb_func_end ov112_021ED640

	thumb_func_start ov112_021ED66C
ov112_021ED66C: ; 0x021ED66C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov112_021E7670
	bl ov112_021E768C
	add r5, r0, #0
	beq _021ED682
	add r0, r4, #0
	bl ov112_021EA7D0
_021ED682:
	add r0, r4, #0
	bl ov112_021EA60C
	add r0, r5, #0
	bl ov112_021ED314
	bl ov112_021E76A8
	cmp r0, #0xf
	bhi _021ED730
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021ED6A2: ; jump table
	.short _021ED730 - _021ED6A2 - 2 ; case 0
	.short _021ED730 - _021ED6A2 - 2 ; case 1
	.short _021ED6C2 - _021ED6A2 - 2 ; case 2
	.short _021ED730 - _021ED6A2 - 2 ; case 3
	.short _021ED6CE - _021ED6A2 - 2 ; case 4
	.short _021ED6CE - _021ED6A2 - 2 ; case 5
	.short _021ED6CE - _021ED6A2 - 2 ; case 6
	.short _021ED6CE - _021ED6A2 - 2 ; case 7
	.short _021ED6CE - _021ED6A2 - 2 ; case 8
	.short _021ED6CE - _021ED6A2 - 2 ; case 9
	.short _021ED730 - _021ED6A2 - 2 ; case 10
	.short _021ED6CE - _021ED6A2 - 2 ; case 11
	.short _021ED6CE - _021ED6A2 - 2 ; case 12
	.short _021ED6CE - _021ED6A2 - 2 ; case 13
	.short _021ED730 - _021ED6A2 - 2 ; case 14
	.short _021ED6D2 - _021ED6A2 - 2 ; case 15
_021ED6C2:
	ldrh r0, [r4, #0x16]
	cmp r0, #1
	bne _021ED730
	mov r0, #0x2a
	strh r0, [r4, #0x14]
	b _021ED730
_021ED6CE:
	strh r0, [r4, #0x14]
	b _021ED730
_021ED6D2:
	ldr r0, _021ED7B8 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #0
	bl ov112_021ED610
	cmp r0, #0
	beq _021ED700
	ldr r0, _021ED7BC ; =0x000010E7
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _021ED700
	ldr r2, _021ED7C0 ; =0x00009D44
	mov r1, #0x9a
	ldrh r0, [r4, r2]
	add r2, #0x10
	add r2, r4, r2
	bl GetSpeciesNameIntoArray
_021ED700:
	ldr r1, _021ED7C4 ; =0x0001F2C0
	add r0, r4, #0
	add r1, r4, r1
	mov r2, #1
	bl ov112_021EAA98
	add r0, r4, #0
	bl ov112_021ED530
	add r0, r4, #0
	bl ov112_021ED590
	add r0, r4, #0
	bl ov112_021ED7DC
	ldr r0, _021ED7C8 ; =0x000010F0
	ldr r1, [r4, r0]
	ldr r0, _021ED7CC ; =0x0001D758
	ldr r0, [r4, r0]
	sub r1, r1, r0
	ldr r0, _021ED7D0 ; =0x0001EC7C
	str r1, [r4, r0]
	mov r0, #0x25
	pop {r3, r4, r5, pc}
_021ED730:
	ldrh r0, [r4, #0x14]
	cmp r0, #0
	beq _021ED74C
	ldr r0, _021ED7B8 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	mov r0, #0x3c
	str r0, [r4, #0xc]
	bl ov112_021E7464
	mov r0, #0x20
	pop {r3, r4, r5, pc}
_021ED74C:
	bl ov112_021E7668
	cmp r0, #0
	bne _021ED798
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E98E8
	mov r0, #5
	bl ov112_021E9888
	cmp r0, #0
	beq _021ED776
	ldr r0, _021ED7D4 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _021ED776
	mov r0, #2
	tst r0, r1
	beq _021ED7B4
_021ED776:
	mov r0, #0x21
	strh r0, [r4, #0x14]
	mov r0, #0x42
	str r0, [r4, #0xc]
	bl ov112_021E7464
	mov r1, #3
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x21
	bl ov112_021EC440
	ldr r0, _021ED7D8 ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021ED798:
	ldrh r0, [r4, #0x16]
	cmp r0, #0
	bne _021ED7AC
	add r0, r4, #0
	mov r1, #2
	mov r2, #6
	bl ov112_021EA10C
	mov r0, #1
	strh r0, [r4, #0x16]
_021ED7AC:
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E98E8
_021ED7B4:
	mov r0, #0x1b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021ED7B8: .word 0x0001E538
_021ED7BC: .word 0x000010E7
_021ED7C0: .word 0x00009D44
_021ED7C4: .word 0x0001F2C0
_021ED7C8: .word 0x000010F0
_021ED7CC: .word 0x0001D758
_021ED7D0: .word 0x0001EC7C
_021ED7D4: .word gSystem
_021ED7D8: .word 0x000005DD
	thumb_func_end ov112_021ED66C

	thumb_func_start ov112_021ED7DC
ov112_021ED7DC: ; 0x021ED7DC
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r0, sp, #4
	mov r2, #0
	str r2, [r0]
	str r2, [r0, #4]
	ldr r3, _021ED8C8 ; =0x00009D54
	str r2, [r0, #8]
	add r0, r4, r3
	str r0, [sp, #4]
	add r0, r3, #0
	sub r0, #0x10
	ldrh r1, [r4, r0]
	add r0, sp, #0
	mov r5, #0x1f
	strh r1, [r0, #0xc]
	ldrb r1, [r0, #0xe]
	bic r1, r5
	sub r5, r3, #3
	ldrb r5, [r4, r5]
	lsl r5, r5, #0x1b
	lsr r6, r5, #0x1b
	mov r5, #0x1f
	and r5, r6
	orr r1, r5
	strb r1, [r0, #0xe]
	ldrb r1, [r0, #0xe]
	mov r5, #0x60
	bic r1, r5
	sub r5, r3, #3
	ldrb r5, [r4, r5]
	sub r3, r3, #2
	lsl r5, r5, #0x19
	lsr r5, r5, #0x1e
	lsl r5, r5, #0x1e
	lsr r5, r5, #0x19
	orr r1, r5
	strb r1, [r0, #0xe]
	ldrb r3, [r4, r3]
	ldrb r1, [r0, #0xe]
	mov r5, #0x80
	lsl r3, r3, #0x1e
	lsr r3, r3, #0x1f
	lsl r3, r3, #0x1f
	bic r1, r5
	lsr r3, r3, #0x18
	orr r1, r3
	strb r1, [r0, #0xe]
	ldr r0, _021ED8CC ; =0x000010F0
	ldr r1, [r4, r0]
	ldr r0, _021ED8D0 ; =0x0001D758
	ldr r0, [r4, r0]
	cmp r1, r0
	bhs _021ED84E
	str r2, [sp, #8]
	b _021ED852
_021ED84E:
	sub r0, r1, r0
	str r0, [sp, #8]
_021ED852:
	ldr r0, _021ED8D4 ; =0x0000AA34
	add r1, sp, #4
	add r0, r4, r0
	bl ov112_021F30BC
	ldr r0, _021ED8D8 ; =0x00009DFC
	add r0, r4, r0
	bl ov112_021F31BC
	cmp r0, #0
	beq _021ED8C2
	mov r0, #0xad
	lsl r0, r0, #8
	ldrh r2, [r4, r0]
	add r1, sp, #0
	mov r3, #0x1f
	strh r2, [r1]
	ldrb r2, [r1, #2]
	bic r2, r3
	add r3, r0, #0
	add r3, #0xd
	ldrb r3, [r4, r3]
	lsl r3, r3, #0x1b
	lsr r5, r3, #0x1b
	mov r3, #0x1f
	and r3, r5
	orr r2, r3
	strb r2, [r1, #2]
	ldrb r2, [r1, #2]
	mov r3, #0x60
	bic r2, r3
	add r3, r0, #0
	add r3, #0xd
	ldrb r3, [r4, r3]
	add r0, #0xe
	lsl r3, r3, #0x19
	lsr r3, r3, #0x1e
	lsl r3, r3, #0x1e
	lsr r3, r3, #0x19
	orr r2, r3
	strb r2, [r1, #2]
	ldrb r0, [r4, r0]
	ldrb r2, [r1, #2]
	mov r3, #0x80
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	lsl r0, r0, #0x1f
	bic r2, r3
	lsr r0, r0, #0x18
	orr r0, r2
	strb r0, [r1, #2]
	ldr r0, _021ED8D8 ; =0x00009DFC
	add r1, sp, #0
	add r0, r4, r0
	bl ov112_021F3140
_021ED8C2:
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_021ED8C8: .word 0x00009D54
_021ED8CC: .word 0x000010F0
_021ED8D0: .word 0x0001D758
_021ED8D4: .word 0x0000AA34
_021ED8D8: .word 0x00009DFC
	thumb_func_end ov112_021ED7DC

	thumb_func_start ov112_021ED8DC
ov112_021ED8DC: ; 0x021ED8DC
	push {r4, lr}
	ldr r1, _021ED908 ; =0x0000AABC
	add r4, r0, #0
	ldr r2, _021ED90C ; =0x000006C8
	mov r0, #0
	add r1, r4, r1
	bl MIi_CpuClearFast
	ldr r0, _021ED910 ; =0x00009D70
	ldr r1, _021ED914 ; =0x0000B184
	add r0, r4, r0
	add r1, r4, r1
	bl ov112_021E7620
	add r0, r4, #0
	bl ov112_021E7CC8
	add r0, r4, #0
	bl ov112_021ED25C
	mov r0, #0x1d
	pop {r4, pc}
	.balign 4, 0
_021ED908: .word 0x0000AABC
_021ED90C: .word 0x000006C8
_021ED910: .word 0x00009D70
_021ED914: .word 0x0000B184
	thumb_func_end ov112_021ED8DC

	thumb_func_start ov112_021ED918
ov112_021ED918: ; 0x021ED918
	push {r4, r5, lr}
	sub sp, #0x1c
	add r4, r0, #0
	bl ov112_021E7670
	bl ov112_021E768C
	add r5, r0, #0
	beq _021ED930
	add r0, r4, #0
	bl ov112_021EA7D0
_021ED930:
	add r0, r5, #0
	bl ov112_021ED314
	add r0, r4, #0
	bl ov112_021EA60C
	bl ov112_021E76A8
	cmp r0, #0xf
	bhi _021ED9B4
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021ED950: ; jump table
	.short _021ED9B4 - _021ED950 - 2 ; case 0
	.short _021ED9B4 - _021ED950 - 2 ; case 1
	.short _021ED970 - _021ED950 - 2 ; case 2
	.short _021ED9B4 - _021ED950 - 2 ; case 3
	.short _021ED97C - _021ED950 - 2 ; case 4
	.short _021ED97C - _021ED950 - 2 ; case 5
	.short _021ED9B4 - _021ED950 - 2 ; case 6
	.short _021ED97C - _021ED950 - 2 ; case 7
	.short _021ED97C - _021ED950 - 2 ; case 8
	.short _021ED97C - _021ED950 - 2 ; case 9
	.short _021ED9B4 - _021ED950 - 2 ; case 10
	.short _021ED97C - _021ED950 - 2 ; case 11
	.short _021ED97C - _021ED950 - 2 ; case 12
	.short _021ED97C - _021ED950 - 2 ; case 13
	.short _021ED9B4 - _021ED950 - 2 ; case 14
	.short _021ED980 - _021ED950 - 2 ; case 15
_021ED970:
	ldrh r0, [r4, #0x16]
	cmp r0, #1
	bne _021ED9B4
	mov r0, #0x2a
	strh r0, [r4, #0x14]
	b _021ED9B4
_021ED97C:
	strh r0, [r4, #0x14]
	b _021ED9B4
_021ED980:
	ldr r0, _021EDA40 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	add r0, sp, #0xc
	add r1, sp, #0
	bl RTC_GetDateTime
	add r0, sp, #0xc
	add r1, sp, #0
	bl RTC_ConvertDateTimeToSecond
	add r0, r4, #0
	bl ov112_021ED530
	add r0, r4, #0
	bl ov112_021ED5DC
	add r0, r4, #0
	mov r1, #6
	bl ov112_021EA670
	add sp, #0x1c
	mov r0, #0x29
	pop {r4, r5, pc}
_021ED9B4:
	ldrh r0, [r4, #0x14]
	cmp r0, #0
	beq _021ED9D2
	ldr r0, _021EDA40 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	mov r0, #0x3d
	str r0, [r4, #0xc]
	bl ov112_021E7464
	add sp, #0x1c
	mov r0, #0x20
	pop {r4, r5, pc}
_021ED9D2:
	bl ov112_021E7668
	cmp r0, #0
	bne _021EDA1E
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E98E8
	mov r0, #5
	bl ov112_021E9888
	cmp r0, #0
	beq _021ED9FC
	ldr r0, _021EDA44 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _021ED9FC
	mov r0, #2
	tst r0, r1
	beq _021EDA3A
_021ED9FC:
	bl ov112_021E7464
	mov r3, #0x21
	mov r1, #3
	strh r3, [r4, #0x14]
	mov r0, #0x42
	str r0, [r4, #0xc]
	add r0, r4, #0
	add r2, r1, #0
	bl ov112_021EC440
	ldr r0, _021EDA48 ; =0x000005DD
	bl PlaySE
	add sp, #0x1c
	mov r0, #0x41
	pop {r4, r5, pc}
_021EDA1E:
	ldrh r0, [r4, #0x16]
	cmp r0, #0
	bne _021EDA32
	add r0, r4, #0
	mov r1, #2
	mov r2, #6
	bl ov112_021EA10C
	mov r0, #1
	strh r0, [r4, #0x16]
_021EDA32:
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E98E8
_021EDA3A:
	mov r0, #0x1d
	add sp, #0x1c
	pop {r4, r5, pc}
	.balign 4, 0
_021EDA40: .word 0x0001E538
_021EDA44: .word gSystem
_021EDA48: .word 0x000005DD
	thumb_func_end ov112_021ED918

	thumb_func_start ov112_021EDA4C
ov112_021EDA4C: ; 0x021EDA4C
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021E7DA4
	ldr r0, _021EDAD4 ; =0x0000C910
	ldr r1, _021EDAD8 ; =0x0000F1D0
	ldr r2, _021EDADC ; =0x00009D70
	ldr r3, _021EDAE0 ; =0x0000AABC
	add r0, r4, r0
	add r1, r4, r1
	add r2, r4, r2
	add r3, r4, r3
	bl ov112_021E7594
	add r0, r4, #0
	bl ov112_021E7CC8
	ldr r1, _021EDAE4 ; =0x0001E42C
	ldr r2, _021EDAE8 ; =0x0001D7AC
	ldr r0, [r4, r1]
	cmp r0, #0
	beq _021EDA86
	add r1, r4, r2
	sub r2, #0x10
	add r2, r4, r2
	mov r3, #0
	bl ov112_021E9290
	b _021EDA96
_021EDA86:
	add r0, r1, #4
	add r1, r4, r2
	sub r2, #0x10
	ldr r0, [r4, r0]
	add r2, r4, r2
	mov r3, #0
	bl ov112_021E9290
_021EDA96:
	ldr r0, _021EDAEC ; =0x0001E550
	mov r1, #1
	ldr r0, [r4, r0]
	bl ManagedSprite_SetOamMode
	add r0, r4, #0
	mov r1, #8
	bl ov112_021EA670
	ldr r0, _021EDAEC ; =0x0001E550
	mov r1, #0x19
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
	ldr r0, _021EDAEC ; =0x0001E550
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnimationFrame
	ldr r0, _021EDAF0 ; =0x0001F2D4
	mov r1, #0
	strh r1, [r4, r0]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA5A4
	add r0, r4, #0
	bl ov112_021ED25C
	mov r0, #0x1f
	pop {r4, pc}
	.balign 4, 0
_021EDAD4: .word 0x0000C910
_021EDAD8: .word 0x0000F1D0
_021EDADC: .word 0x00009D70
_021EDAE0: .word 0x0000AABC
_021EDAE4: .word 0x0001E42C
_021EDAE8: .word 0x0001D7AC
_021EDAEC: .word 0x0001E550
_021EDAF0: .word 0x0001F2D4
	thumb_func_end ov112_021EDA4C

	thumb_func_start ov112_021EDAF4
ov112_021EDAF4: ; 0x021EDAF4
	push {r3, lr}
	cmp r1, #0
	bne _021EDB06
	ldr r1, _021EDB20 ; =0x0001E550
	ldr r0, [r0, r1]
	mov r1, #0
	bl ManagedSprite_SetAnimationFrame
	pop {r3, pc}
_021EDB06:
	cmp r1, #0x1e
	ble _021EDB1E
	ldr r2, _021EDB20 ; =0x0001E550
	sub r1, #0x1e
	ldr r0, [r0, r2]
	asr r2, r1, #1
	lsr r2, r2, #0x1e
	add r2, r1, r2
	lsl r1, r2, #0xe
	lsr r1, r1, #0x10
	bl ManagedSprite_SetAnimationFrame
_021EDB1E:
	pop {r3, pc}
	.balign 4, 0
_021EDB20: .word 0x0001E550
	thumb_func_end ov112_021EDAF4

	thumb_func_start ov112_021EDB24
ov112_021EDB24: ; 0x021EDB24
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov112_021E7670
	bl ov112_021E768C
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov112_021ED330
	add r5, r0, #0
	beq _021EDB46
	add r0, r4, #0
	bl ov112_021EA76C
_021EDB46:
	add r0, r4, #0
	bl ov112_021EA60C
	add r0, r5, #0
	bl ov112_021ED314
	add r0, r4, #0
	add r1, r5, #0
	bl ov112_021EDAF4
	cmp r5, #0xc8
	bls _021EDB7A
	ldr r1, _021EDC94 ; =0x0001F2D4
	ldrh r0, [r4, r1]
	cmp r0, #0
	bne _021EDB86
	sub r1, #0x14
	add r0, r4, #0
	add r1, r4, r1
	mov r2, #2
	bl ov112_021EAA98
	ldr r0, _021EDC94 ; =0x0001F2D4
	mov r1, #1
	strh r1, [r4, r0]
	b _021EDB86
_021EDB7A:
	add r0, r4, #0
	bl ov112_021EAA10
	ldr r0, _021EDC94 ; =0x0001F2D4
	mov r1, #0
	strh r1, [r4, r0]
_021EDB86:
	bl ov112_021E76A8
	cmp r0, #0xf
	bhi _021EDC0A
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021EDB9A: ; jump table
	.short _021EDC0A - _021EDB9A - 2 ; case 0
	.short _021EDC0A - _021EDB9A - 2 ; case 1
	.short _021EDBBA - _021EDB9A - 2 ; case 2
	.short _021EDC0A - _021EDB9A - 2 ; case 3
	.short _021EDBC6 - _021EDB9A - 2 ; case 4
	.short _021EDBC6 - _021EDB9A - 2 ; case 5
	.short _021EDC0A - _021EDB9A - 2 ; case 6
	.short _021EDBC6 - _021EDB9A - 2 ; case 7
	.short _021EDBC6 - _021EDB9A - 2 ; case 8
	.short _021EDBC6 - _021EDB9A - 2 ; case 9
	.short _021EDC0A - _021EDB9A - 2 ; case 10
	.short _021EDBC6 - _021EDB9A - 2 ; case 11
	.short _021EDBC6 - _021EDB9A - 2 ; case 12
	.short _021EDBC6 - _021EDB9A - 2 ; case 13
	.short _021EDC0A - _021EDB9A - 2 ; case 14
	.short _021EDBCA - _021EDB9A - 2 ; case 15
_021EDBBA:
	ldrh r0, [r4, #0x16]
	cmp r0, #1
	bne _021EDC0A
	mov r0, #0x2a
	strh r0, [r4, #0x14]
	b _021EDC0A
_021EDBC6:
	strh r0, [r4, #0x14]
	b _021EDC0A
_021EDBCA:
	ldr r0, _021EDC98 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021EDC9C ; =0x0001E440
	ldr r2, _021EDCA0 ; =0x0001D758
	ldr r0, [r4, r0]
	add r1, r4, r2
	add r2, r2, #4
	add r2, r4, r2
	bl sub_02032674
	add r0, r4, #0
	bl ov112_021ED590
	ldr r0, _021EDC9C ; =0x0001E440
	ldr r0, [r4, r0]
	bl sub_02032644
	add r0, r4, #0
	mov r1, #8
	bl ov112_021EA688
	ldr r1, _021EDCA4 ; =0x0001F2C0
	add r0, r4, #0
	add r1, r4, r1
	mov r2, #0
	bl ov112_021EAA98
	mov r0, #0x23
	pop {r3, r4, r5, pc}
_021EDC0A:
	ldrh r0, [r4, #0x14]
	cmp r0, #0
	beq _021EDC26
	ldr r0, _021EDC98 ; =0x0001E538
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	mov r0, #0x3b
	str r0, [r4, #0xc]
	bl ov112_021E7464
	mov r0, #0x20
	pop {r3, r4, r5, pc}
_021EDC26:
	bl ov112_021E7668
	cmp r0, #0
	bne _021EDC72
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E98E8
	mov r0, #5
	bl ov112_021E9888
	cmp r0, #0
	beq _021EDC50
	ldr r0, _021EDCA8 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _021EDC50
	mov r0, #2
	tst r0, r1
	beq _021EDC8E
_021EDC50:
	mov r0, #0x21
	strh r0, [r4, #0x14]
	mov r0, #0x42
	str r0, [r4, #0xc]
	bl ov112_021E7464
	mov r1, #3
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x21
	bl ov112_021EC440
	ldr r0, _021EDCAC ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r3, r4, r5, pc}
_021EDC72:
	ldrh r0, [r4, #0x16]
	cmp r0, #0
	bne _021EDC86
	add r0, r4, #0
	mov r1, #2
	mov r2, #6
	bl ov112_021EA10C
	mov r0, #1
	strh r0, [r4, #0x16]
_021EDC86:
	add r0, r4, #0
	mov r1, #0
	bl ov112_021E98E8
_021EDC8E:
	mov r0, #0x1f
	pop {r3, r4, r5, pc}
	nop
_021EDC94: .word 0x0001F2D4
_021EDC98: .word 0x0001E538
_021EDC9C: .word 0x0001E440
_021EDCA0: .word 0x0001D758
_021EDCA4: .word 0x0001F2C0
_021EDCA8: .word gSystem
_021EDCAC: .word 0x000005DD
	thumb_func_end ov112_021EDB24

	thumb_func_start ov112_021EDCB0
ov112_021EDCB0: ; 0x021EDCB0
	cmp r0, #0x21
	bgt _021EDCE4
	bge _021EDD06
	cmp r0, #0xe
	bhi _021EDD06
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021EDCC6: ; jump table
	.short _021EDD06 - _021EDCC6 - 2 ; case 0
	.short _021EDD06 - _021EDCC6 - 2 ; case 1
	.short _021EDD06 - _021EDCC6 - 2 ; case 2
	.short _021EDCFC - _021EDCC6 - 2 ; case 3
	.short _021EDCE8 - _021EDCC6 - 2 ; case 4
	.short _021EDCEC - _021EDCC6 - 2 ; case 5
	.short _021EDCF4 - _021EDCC6 - 2 ; case 6
	.short _021EDCF0 - _021EDCC6 - 2 ; case 7
	.short _021EDCF8 - _021EDCC6 - 2 ; case 8
	.short _021EDCF8 - _021EDCC6 - 2 ; case 9
	.short _021EDD06 - _021EDCC6 - 2 ; case 10
	.short _021EDCFC - _021EDCC6 - 2 ; case 11
	.short _021EDCFC - _021EDCC6 - 2 ; case 12
	.short _021EDD00 - _021EDCC6 - 2 ; case 13
	.short _021EDD04 - _021EDCC6 - 2 ; case 14
_021EDCE4:
	cmp r0, #0x2a
	bx lr
_021EDCE8:
	mov r0, #0x22
	bx lr
_021EDCEC:
	mov r0, #0x24
	bx lr
_021EDCF0:
	mov r0, #0x25
	bx lr
_021EDCF4:
	mov r0, #0x2b
	bx lr
_021EDCF8:
	mov r0, #0x26
	bx lr
_021EDCFC:
	mov r0, #0x27
	bx lr
_021EDD00:
	mov r0, #0x23
	bx lr
_021EDD04:
	mov r0, #0x2a
_021EDD06:
	bx lr
	thumb_func_end ov112_021EDCB0

	thumb_func_start ov112_021EDD08
ov112_021EDD08: ; 0x021EDD08
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021EA570
	ldrh r0, [r4, #0x14]
	bl ov112_021EDCB0
	strh r0, [r4, #0x14]
	ldrh r2, [r4, #0x14]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA08C
	ldr r1, _021EDD2C ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x22
	pop {r4, pc}
	nop
_021EDD2C: .word 0x0001E524
	thumb_func_end ov112_021EDD08

	thumb_func_start ov112_021EDD30
ov112_021EDD30: ; 0x021EDD30
	push {r4, lr}
	add r4, r0, #0
	bl ov112_021EA570
	ldrh r0, [r4, #0x14]
	bl ov112_021EDCB0
	strh r0, [r4, #0x14]
	ldrh r2, [r4, #0x14]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA08C
	ldr r1, _021EDD58 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x42
	str r0, [r4, #0xc]
	mov r0, #0x22
	pop {r4, pc}
	nop
_021EDD58: .word 0x0001E524
	thumb_func_end ov112_021EDD30

	thumb_func_start ov112_021EDD5C
ov112_021EDD5C: ; 0x021EDD5C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #0
	mov r2, #7
	bl ov112_021EA08C
	ldr r1, _021EDD7C ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x11
	pop {r4, pc}
	nop
_021EDD7C: .word 0x0001E524
	thumb_func_end ov112_021EDD5C

	thumb_func_start ov112_021EDD80
ov112_021EDD80: ; 0x021EDD80
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #0
	mov r2, #5
	bl ov112_021EA08C
	ldr r1, _021EDDB0 ; =0x0001E524
	mov r2, #0xe
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	mov r0, #0x15
	pop {r4, pc}
	.balign 4, 0
_021EDDB0: .word 0x0001E524
	thumb_func_end ov112_021EDD80

	thumb_func_start ov112_021EDDB4
ov112_021EDDB4: ; 0x021EDDB4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #0
	mov r2, #5
	bl ov112_021EA08C
	ldr r1, _021EDDE4 ; =0x0001E524
	mov r2, #0xe
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EDDE4: .word 0x0001E524
	thumb_func_end ov112_021EDDB4

	thumb_func_start ov112_021EDDE8
ov112_021EDDE8: ; 0x021EDDE8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #0
	mov r2, #5
	bl ov112_021EA08C
	ldr r1, _021EDE18 ; =0x0001E524
	mov r2, #0xe
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021E7CA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	mov r0, #0x17
	pop {r4, pc}
	.balign 4, 0
_021EDE18: .word 0x0001E524
	thumb_func_end ov112_021EDDE8

	thumb_func_start ov112_021EDE1C
ov112_021EDE1C: ; 0x021EDE1C
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, _021EDE64 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EDE5E
	mov r2, #0
	str r2, [r4, #4]
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	ldr r0, [r4, #0xc]
	add sp, #0x10
	str r0, [r4, #8]
	pop {r4, pc}
_021EDE5E:
	mov r0, #0x22
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EDE64: .word 0x0001E524
	thumb_func_end ov112_021EDE1C

	thumb_func_start ov112_021EDE68
ov112_021EDE68: ; 0x021EDE68
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021E7464
	add r0, r4, #0
	bl ov112_021ED640
	cmp r0, #0
	bne _021EDE96
	mov r1, #0xad
	lsl r1, r1, #8
	mov r2, #0xbf
	mov r0, #0
	add r1, r4, r1
	lsl r2, r2, #2
	bl MIi_CpuClearFast
	ldr r1, _021EDEF8 ; =0x0000AABC
	mov r0, #0x20
	ldrb r2, [r4, r1]
	bic r2, r0
	strb r2, [r4, r1]
_021EDE96:
	ldr r3, _021EDEFC ; =0x0001E42C
	ldr r2, [r4, r3]
	cmp r2, #0
	beq _021EDEAA
	add r3, #0x1c
	ldr r0, [r4, r3]
	mov r1, #1
	bl BufferBoxMonNickname
	b _021EDEBA
_021EDEAA:
	add r0, r3, #0
	add r0, #0x1c
	add r2, r3, #4
	ldr r0, [r4, r0]
	ldr r2, [r4, r2]
	mov r1, #1
	bl BufferBoxMonNickname
_021EDEBA:
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x18
	bl ov112_021EA08C
	ldr r1, _021EDF00 ; =0x0001E524
	str r0, [r4, r1]
	ldr r0, _021EDF04 ; =0x000004A2
	bl PlayFanfare
	mov r0, #0x24
	add sp, #0x10
	pop {r4, pc}
	nop
_021EDEF8: .word 0x0000AABC
_021EDEFC: .word 0x0001E42C
_021EDF00: .word 0x0001E524
_021EDF04: .word 0x000004A2
	thumb_func_end ov112_021EDE68

	thumb_func_start ov112_021EDF08
ov112_021EDF08: ; 0x021EDF08
	push {r4, lr}
	ldr r1, _021EDF44 ; =0x0001F2C0
	add r4, r0, #0
	add r1, r4, r1
	bl ov112_021EAAE4
	ldr r0, _021EDF48 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EDF3E
	add r0, r4, #0
	bl ov112_021EA838
	cmp r0, #0
	bne _021EDF3E
	bl IsFanfarePlaying
	cmp r0, #0
	bne _021EDF3E
	mov r0, #5
	str r0, [r4, #4]
	mov r0, #0x42
	pop {r4, pc}
_021EDF3E:
	mov r0, #0x24
	pop {r4, pc}
	nop
_021EDF44: .word 0x0001F2C0
_021EDF48: .word 0x0001E524
	thumb_func_end ov112_021EDF08

	thumb_func_start ov112_021EDF4C
ov112_021EDF4C: ; 0x021EDF4C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0xc
	mov r1, #0x9a
	bl String_New
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r5, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add r0, r5, #0
	bl ov112_021ED610
	cmp r0, #0
	beq _021EDFB8
	ldr r1, _021EDFD8 ; =0x00009D54
	add r0, r4, #0
	add r1, r5, r1
	mov r2, #0xc
	bl CopyU16ArrayToStringN
	mov r1, #1
	str r1, [sp]
	ldr r3, _021EDFDC ; =0x00009D51
	str r1, [sp, #4]
	ldrb r3, [r5, r3]
	ldr r0, _021EDFE0 ; =0x0001E448
	add r2, r4, #0
	lsl r3, r3, #0x19
	ldr r0, [r5, r0]
	lsr r3, r3, #0x1e
	bl BufferString
	add r0, r5, #0
	mov r1, #2
	mov r2, #0x1b
	bl ov112_021EA08C
	b _021EDFC2
_021EDFB8:
	add r0, r5, #0
	mov r1, #2
	mov r2, #0x20
	bl ov112_021EA08C
_021EDFC2:
	ldr r1, _021EDFE4 ; =0x0001E524
	str r0, [r5, r1]
	bl ov112_021E7464
	add r0, r4, #0
	bl String_Delete
	mov r0, #0x26
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021EDFD8: .word 0x00009D54
_021EDFDC: .word 0x00009D51
_021EDFE0: .word 0x0001E448
_021EDFE4: .word 0x0001E524
	thumb_func_end ov112_021EDF4C

	thumb_func_start ov112_021EDFE8
ov112_021EDFE8: ; 0x021EDFE8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x9a
	mov r6, #1
	bl AllocMonZeroed
	add r4, r0, #0
	ldr r0, _021EE03C ; =0x0001E440
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl Pokewalker_TryGetBoxMon
	cmp r0, #0
	bne _021EE006
	mov r6, #0
_021EE006:
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	add r7, r0, #0
	add r0, r4, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	ldr r1, _021EE040 ; =0x00009D44
	ldrh r2, [r5, r1]
	cmp r2, r7
	bne _021EE030
	add r1, #0xd
	ldrb r1, [r5, r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1b
	cmp r1, r0
	beq _021EE032
_021EE030:
	mov r6, #0
_021EE032:
	add r0, r4, #0
	bl Heap_Free
	add r0, r6, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EE03C: .word 0x0001E440
_021EE040: .word 0x00009D44
	thumb_func_end ov112_021EDFE8

	thumb_func_start ov112_021EE044
ov112_021EE044: ; 0x021EE044
	push {r4, lr}
	ldr r1, _021EE0E0 ; =0x0001F2C0
	add r4, r0, #0
	add r1, r4, r1
	bl ov112_021EAAE4
	ldr r0, _021EE0E4 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE0DC
	bl IsFanfarePlaying
	cmp r0, #0
	bne _021EE0DC
	add r0, r4, #0
	bl ov112_021ED610
	cmp r0, #0
	bne _021EE088
	ldr r1, _021EE0E8 ; =0x00009D44
	mov r0, #0
	add r1, r4, r1
	mov r2, #0x10
	bl MIi_CpuClearFast
	ldr r1, _021EE0EC ; =0x000010E7
	mov r0, #4
	ldrb r2, [r4, r1]
	bic r2, r0
	strb r2, [r4, r1]
_021EE088:
	add r0, r4, #0
	bl ov112_021ED640
	cmp r0, #0
	bne _021EE0AC
	mov r1, #0xad
	lsl r1, r1, #8
	mov r2, #0xbf
	mov r0, #0
	add r1, r4, r1
	lsl r2, r2, #2
	bl MIi_CpuClearFast
	ldr r1, _021EE0F0 ; =0x0000AABC
	mov r0, #0x20
	ldrb r2, [r4, r1]
	bic r2, r0
	strb r2, [r4, r1]
_021EE0AC:
	add r0, r4, #0
	bl ov112_021EDFE8
	cmp r0, #0
	bne _021EE0D0
	ldr r0, _021EE0F0 ; =0x0000AABC
	ldrb r0, [r4, r0]
	lsl r1, r0, #0x1a
	lsr r1, r1, #0x1f
	bne _021EE0D0
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1f
	bne _021EE0D0
	ldr r0, _021EE0EC ; =0x000010E7
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	beq _021EE0D8
_021EE0D0:
	mov r0, #6
	str r0, [r4, #4]
	mov r0, #0x42
	pop {r4, pc}
_021EE0D8:
	mov r0, #0x27
	pop {r4, pc}
_021EE0DC:
	mov r0, #0x26
	pop {r4, pc}
	.balign 4, 0
_021EE0E0: .word 0x0001F2C0
_021EE0E4: .word 0x0001E524
_021EE0E8: .word 0x00009D44
_021EE0EC: .word 0x000010E7
_021EE0F0: .word 0x0000AABC
	thumb_func_end ov112_021EE044

	thumb_func_start ov112_021EE0F4
ov112_021EE0F4: ; 0x021EE0F4
	push {r4, lr}
	mov r1, #2
	mov r2, #0x14
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EE108 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x28
	pop {r4, pc}
	.balign 4, 0
_021EE108: .word 0x0001E524
	thumb_func_end ov112_021EE0F4

	thumb_func_start ov112_021EE10C
ov112_021EE10C: ; 0x021EE10C
	push {r3, lr}
	ldr r1, _021EE128 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE122
	mov r0, #0x3e
	pop {r3, pc}
_021EE122:
	mov r0, #0x28
	pop {r3, pc}
	nop
_021EE128: .word 0x0001E524
	thumb_func_end ov112_021EE10C

	thumb_func_start ov112_021EE12C
ov112_021EE12C: ; 0x021EE12C
	push {r4, lr}
	sub sp, #0x10
	mov r1, #2
	mov r2, #0x1d
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EE170 ; =0x0001E524
	mov r2, #0
	str r0, [r4, r1]
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	bl ov112_021E7464
	ldr r0, _021EE174 ; =0x000004A1
	bl PlayFanfare
	mov r0, #0x2a
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EE170: .word 0x0001E524
_021EE174: .word 0x000004A1
	thumb_func_end ov112_021EE12C

	thumb_func_start ov112_021EE178
ov112_021EE178: ; 0x021EE178
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE1A0 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE19C
	bl IsFanfarePlaying
	cmp r0, #0
	bne _021EE19C
	mov r0, #6
	str r0, [r4, #4]
	mov r0, #0x42
	pop {r4, pc}
_021EE19C:
	mov r0, #0x2a
	pop {r4, pc}
	.balign 4, 0
_021EE1A0: .word 0x0001E524
	thumb_func_end ov112_021EE178

	thumb_func_start ov112_021EE1A4
ov112_021EE1A4: ; 0x021EE1A4
	push {r4, lr}
	mov r1, #2
	mov r2, #0x12
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EE1B8 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x2c
	pop {r4, pc}
	.balign 4, 0
_021EE1B8: .word 0x0001E524
	thumb_func_end ov112_021EE1A4

	thumb_func_start ov112_021EE1BC
ov112_021EE1BC: ; 0x021EE1BC
	push {r3, lr}
	ldr r1, _021EE1D8 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE1D2
	mov r0, #0x2d
	pop {r3, pc}
_021EE1D2:
	mov r0, #0x2c
	pop {r3, pc}
	nop
_021EE1D8: .word 0x0001E524
	thumb_func_end ov112_021EE1BC

	thumb_func_start ov112_021EE1DC
ov112_021EE1DC: ; 0x021EE1DC
	push {r3, lr}
	mov r1, #1
	bl ov112_021E966C
	mov r0, #0x2e
	pop {r3, pc}
	thumb_func_end ov112_021EE1DC

	thumb_func_start ov112_021EE1E8
ov112_021EE1E8: ; 0x021EE1E8
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021E9750
	cmp r0, #0
	beq _021EE1FC
	cmp r0, #1
	beq _021EE254
	b _021EE28E
_021EE1FC:
	add r0, r4, #0
	bl ov112_021EA570
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EE294 ; =0x0001EA98
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _021EE298 ; =0x0001EAA8
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add sp, #0x10
	mov r0, #0x2f
	pop {r4, pc}
_021EE254:
	mov r1, #0x10
	str r1, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #8
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	mov r2, #0
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EE294 ; =0x0001EA98
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _021EE298 ; =0x0001EAA8
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r4, #0
	bl ov112_021EA570
	mov r0, #0
	str r0, [r4, #4]
	add sp, #0x10
	mov r0, #0x42
	pop {r4, pc}
_021EE28E:
	mov r0, #0x2e
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EE294: .word 0x0001EA98
_021EE298: .word 0x0001EAA8
	thumb_func_end ov112_021EE1E8

	thumb_func_start ov112_021EE29C
ov112_021EE29C: ; 0x021EE29C
	push {r4, lr}
	mov r1, #0
	mov r2, #0x13
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EE2B0 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #0x30
	pop {r4, pc}
	.balign 4, 0
_021EE2B0: .word 0x0001E524
	thumb_func_end ov112_021EE29C

	thumb_func_start ov112_021EE2B4
ov112_021EE2B4: ; 0x021EE2B4
	push {r3, lr}
	ldr r1, _021EE2D0 ; =0x0001E524
	ldr r0, [r0, r1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE2CA
	mov r0, #0x31
	pop {r3, pc}
_021EE2CA:
	mov r0, #0x30
	pop {r3, pc}
	nop
_021EE2D0: .word 0x0001E524
	thumb_func_end ov112_021EE2B4

	thumb_func_start ov112_021EE2D4
ov112_021EE2D4: ; 0x021EE2D4
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #2
	mov r2, #0xa
	add r4, r0, #0
	bl ov112_021E7CA4
	ldr r0, _021EE310 ; =0x000F0100
	ldr r2, _021EE314 ; =0x0001E468
	str r0, [sp]
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r1, #5
	mov r3, #4
	bl ov112_021E9FA4
	add r0, r4, #0
	mov r1, #1
	bl ov112_021E9F40
	ldr r0, _021EE318 ; =0x0001EC50
	mov r1, #0
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA51C
	mov r0, #0x32
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021EE310: .word 0x000F0100
_021EE314: .word 0x0001E468
_021EE318: .word 0x0001EC50
	thumb_func_end ov112_021EE2D4

	thumb_func_start ov112_021EE31C
ov112_021EE31C: ; 0x021EE31C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	bl ov112_021E9888
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _021EE344
	add r0, r4, #0
	add r2, r1, #2
	mov r3, #0x33
	bl ov112_021EC440
	ldr r0, _021EE3D0 ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r4, pc}
_021EE344:
	ldr r0, _021EE3D4 ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _021EE36C
	add r0, r4, #0
	mov r1, #2
	bl ov112_021EA51C
	ldr r0, _021EE3D8 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021EE364
	ldr r0, _021EE3DC ; =0x000005DC
	bl PlaySE
_021EE364:
	ldr r0, _021EE3D8 ; =0x0001EC50
	mov r1, #0
	str r1, [r4, r0]
	b _021EE3CA
_021EE36C:
	mov r1, #0x80
	tst r1, r0
	beq _021EE390
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA51C
	ldr r0, _021EE3D8 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #1
	beq _021EE388
	ldr r0, _021EE3DC ; =0x000005DC
	bl PlaySE
_021EE388:
	ldr r0, _021EE3D8 ; =0x0001EC50
	mov r1, #1
	str r1, [r4, r0]
	b _021EE3CA
_021EE390:
	mov r1, #1
	add r2, r0, #0
	tst r2, r1
	beq _021EE3B0
	ldr r0, _021EE3D8 ; =0x0001EC50
	mov r3, #0x33
	ldr r1, [r4, r0]
	add r0, r4, #0
	add r2, r1, #2
	bl ov112_021EC440
	ldr r0, _021EE3D0 ; =0x000005DD
	bl PlaySE
	mov r0, #0x41
	pop {r4, pc}
_021EE3B0:
	mov r2, #2
	tst r0, r2
	beq _021EE3CA
	add r0, r4, #0
	mov r2, #3
	mov r3, #0x33
	bl ov112_021EC440
	ldr r0, _021EE3DC ; =0x000005DC
	bl PlaySE
	mov r0, #0x41
	pop {r4, pc}
_021EE3CA:
	mov r0, #0x32
	pop {r4, pc}
	nop
_021EE3D0: .word 0x000005DD
_021EE3D4: .word gSystem
_021EE3D8: .word 0x0001EC50
_021EE3DC: .word 0x000005DC
	thumb_func_end ov112_021EE31C

	thumb_func_start ov112_021EE3E0
ov112_021EE3E0: ; 0x021EE3E0
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021EA570
	ldr r0, _021EE454 ; =0x0001EC50
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _021EE44A
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #2
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, _021EE458 ; =0x0001EA98
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _021EE45C ; =0x0001EAA8
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, [r4, #0x18]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	ldr r0, _021EE460 ; =0x0001EC7C
	mov r1, #0
	str r1, [r4, r0]
	add sp, #0x10
	mov r0, #0x34
	pop {r4, pc}
_021EE44A:
	mov r0, #0xb
	str r0, [r4, #4]
	mov r0, #0x42
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021EE454: .word 0x0001EC50
_021EE458: .word 0x0001EA98
_021EE45C: .word 0x0001EAA8
_021EE460: .word 0x0001EC7C
	thumb_func_end ov112_021EE3E0

	thumb_func_start ov112_021EE464
ov112_021EE464: ; 0x021EE464
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _021EE4A8 ; =0x0001E440
	ldr r5, _021EE4AC ; =0x0001F2E8
	ldr r0, [r4, r0]
	add r1, r4, r5
	bl Pokewalker_TryGetBoxMon
	add r0, r4, #0
	mov r1, #0
	bl ov112_021EA5A4
	ldr r0, _021EE4B0 ; =0x0001E448
	mov r1, #1
	ldr r0, [r4, r0]
	add r2, r4, r5
	bl BufferBoxMonNickname
	ldr r2, _021EE4B4 ; =0x0001D7AC
	add r0, r4, r5
	add r1, r4, r2
	sub r2, #0x10
	add r2, r4, r2
	mov r3, #0
	bl ov112_021E9290
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x1a
	mov r3, #0x35
	bl ov112_021EC460
	mov r0, #0x40
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EE4A8: .word 0x0001E440
_021EE4AC: .word 0x0001F2E8
_021EE4B0: .word 0x0001E448
_021EE4B4: .word 0x0001D7AC
	thumb_func_end ov112_021EE464

	thumb_func_start ov112_021EE4B8
ov112_021EE4B8: ; 0x021EE4B8
	push {r3, lr}
	ldr r1, _021EE4CC ; =0x0001F2D0
	mov r2, #0
	str r2, [r0, r1]
	mov r1, #8
	bl ov112_021EA688
	mov r0, #0x36
	pop {r3, pc}
	nop
_021EE4CC: .word 0x0001F2D0
	thumb_func_end ov112_021EE4B8

	thumb_func_start ov112_021EE4D0
ov112_021EE4D0: ; 0x021EE4D0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE50C ; =0x0001F2D0
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	ldr r0, [r4, r0]
	cmp r0, #0xb4
	ble _021EE4E6
	mov r0, #0x37
	pop {r4, pc}
_021EE4E6:
	bl MTRandom
	mov r1, #0xb4
	bl _u32_div_f
	ldr r0, _021EE50C ; =0x0001F2D0
	ldr r0, [r4, r0]
	cmp r0, r1
	bls _021EE4FE
	add r0, r4, #0
	bl ov112_021EA7D0
_021EE4FE:
	ldr r0, _021EE50C ; =0x0001F2D0
	ldr r0, [r4, r0]
	bl ov112_021ED314
	mov r0, #0x36
	pop {r4, pc}
	nop
_021EE50C: .word 0x0001F2D0
	thumb_func_end ov112_021EE4D0

	thumb_func_start ov112_021EE510
ov112_021EE510: ; 0x021EE510
	mov r0, #0x38
	bx lr
	thumb_func_end ov112_021EE510

	thumb_func_start ov112_021EE514
ov112_021EE514: ; 0x021EE514
	push {r3, lr}
	mov r1, #2
	mov r2, #0x1b
	mov r3, #0x39
	bl ov112_021EC460
	mov r0, #0x40
	pop {r3, pc}
	thumb_func_end ov112_021EE514

	thumb_func_start ov112_021EE524
ov112_021EE524: ; 0x021EE524
	mov r1, #6
	str r1, [r0, #4]
	mov r0, #0x42
	bx lr
	thumb_func_end ov112_021EE524

	thumb_func_start ov112_021EE52C
ov112_021EE52C: ; 0x021EE52C
	push {lr}
	sub sp, #0xc
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x9a
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0x3f
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov112_021EE52C

	thumb_func_start ov112_021EE550
ov112_021EE550: ; 0x021EE550
	push {r4, lr}
	add r4, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EE56A
	add r0, r4, #0
	bl ov112_021EAA10
	mov r0, #0
	str r0, [r4, #4]
	mov r0, #0x42
	pop {r4, pc}
_021EE56A:
	mov r0, #0x3f
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EE550

	thumb_func_start ov112_021EE570
ov112_021EE570: ; 0x021EE570
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE590 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE58A
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	pop {r4, pc}
_021EE58A:
	mov r0, #0x40
	pop {r4, pc}
	nop
_021EE590: .word 0x0001E524
	thumb_func_end ov112_021EE570

	thumb_func_start ov112_021EE594
ov112_021EE594: ; 0x021EE594
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE5B4 ; =0x0001E530
	ldr r0, [r4, r0]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _021EE5B0
	add r0, r4, #0
	bl ov112_021EA570
	ldr r0, [r4, #0xc]
	str r0, [r4, #8]
	pop {r4, pc}
_021EE5B0:
	mov r0, #0x41
	pop {r4, pc}
	.balign 4, 0
_021EE5B4: .word 0x0001E530
	thumb_func_end ov112_021EE594

	thumb_func_start ov112_021EE5B8
ov112_021EE5B8: ; 0x021EE5B8
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	bl ov112_021EA64C
	add r0, r4, #0
	mov r1, #3
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #4
	bl ov112_021EA688
	add r0, r4, #0
	mov r1, #8
	bl ov112_021EA688
	mov r2, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	mov r0, #0x43
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EE5B8

	thumb_func_start ov112_021EE604
ov112_021EE604: ; 0x021EE604
	mov r0, #2
	bx lr
	thumb_func_end ov112_021EE604

	thumb_func_start ov112_021EE608
ov112_021EE608: ; 0x021EE608
	ldr r1, _021EE620 ; =gSystem
	ldr r2, [r1, #0x48]
	mov r1, #0x80
	tst r1, r2
	beq _021EE61A
	mov r1, #6
	str r1, [r0, #4]
	mov r0, #3
	bx lr
_021EE61A:
	mov r0, #2
	bx lr
	nop
_021EE620: .word gSystem
	thumb_func_end ov112_021EE608

	thumb_func_start ov112_021EE624
ov112_021EE624: ; 0x021EE624
	mov r0, #1
	bx lr
	thumb_func_end ov112_021EE624

	thumb_func_start ov112_021EE628
ov112_021EE628: ; 0x021EE628
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x20]
	bl SaveArray_PCStorage_Get
	add r7, r0, #0
	ldr r0, _021EE67C ; =0x0001D770
	mov r1, #2
	ldr r4, [r5, r0]
	add r0, r0, #4
	ldr r6, [r5, r0]
	ldr r0, _021EE680 ; =0x0001E440
	add r2, r4, #0
	ldr r0, [r5, r0]
	bl sub_020326A4
	ldr r0, _021EE680 ; =0x0001E440
	ldr r1, _021EE684 ; =0x0001D798
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	bl sub_02032720
	add r0, r7, #0
	add r1, r4, #0
	add r2, r6, #0
	bl PCStorage_GetMonByIndexPair
	add r1, r0, #0
	ldr r0, _021EE680 ; =0x0001E440
	ldr r0, [r5, r0]
	bl Pokewalker_SetBoxMon
	add r0, r7, #0
	add r1, r4, #0
	add r2, r6, #0
	bl PCStorage_DeleteBoxMonByIndexPair
	add r0, r5, #0
	bl ov112_021EECF0
	mov r0, #2
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EE67C: .word 0x0001D770
_021EE680: .word 0x0001E440
_021EE684: .word 0x0001D798
	thumb_func_end ov112_021EE628

	thumb_func_start ov112_021EE688
ov112_021EE688: ; 0x021EE688
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	lsl r2, r1, #2
	ldr r1, _021EE6A8 ; =ov112_021FF8D8
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4, #8]
	cmp r0, #8
	bne _021EE6A4
	mov r0, #0
	str r0, [r4, #8]
	mov r0, #3
	pop {r4, pc}
_021EE6A4:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021EE6A8: .word ov112_021FF8D8
	thumb_func_end ov112_021EE688

	thumb_func_start ov112_021EE6AC
ov112_021EE6AC: ; 0x021EE6AC
	mov r0, #1
	bx lr
	thumb_func_end ov112_021EE6AC

	thumb_func_start ov112_021EE6B0
ov112_021EE6B0: ; 0x021EE6B0
	push {r4, lr}
	mov r1, #2
	mov r2, #0xd
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EE6CC ; =0x0001E524
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov112_021EA5A4
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021EE6CC: .word 0x0001E524
	thumb_func_end ov112_021EE6B0

	thumb_func_start ov112_021EE6D0
ov112_021EE6D0: ; 0x021EE6D0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE6F4 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE6EE
	add r0, r4, #0
	bl ov112_021EA17C
	mov r0, #2
	pop {r4, pc}
_021EE6EE:
	mov r0, #1
	pop {r4, pc}
	nop
_021EE6F4: .word 0x0001E524
	thumb_func_end ov112_021EE6D0

	thumb_func_start ov112_021EE6F8
ov112_021EE6F8: ; 0x021EE6F8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x20]
	bl SaveGameNormal
	ldr r0, [r4, #0x20]
	bl Save_ClearStatusFlags
	mov r0, #3
	pop {r4, pc}
	thumb_func_end ov112_021EE6F8

	thumb_func_start ov112_021EE70C
ov112_021EE70C: ; 0x021EE70C
	push {r3, lr}
	bl ov112_021EA19C
	mov r0, #4
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov112_021EE70C

	thumb_func_start ov112_021EE718
ov112_021EE718: ; 0x021EE718
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE738 ; =0x0001E440
	ldr r0, [r4, r0]
	bl sub_0203263C
	cmp r0, #1
	bne _021EE72C
	mov r0, #5
	pop {r4, pc}
_021EE72C:
	mov r0, #0xa
	str r0, [r4, #4]
	mov r0, #3
	str r0, [r4, #0x10]
	mov r0, #7
	pop {r4, pc}
	.balign 4, 0
_021EE738: .word 0x0001E440
	thumb_func_end ov112_021EE718

	thumb_func_start ov112_021EE73C
ov112_021EE73C: ; 0x021EE73C
	push {r4, lr}
	mov r1, #2
	mov r2, #0x19
	add r4, r0, #0
	bl ov112_021EA08C
	ldr r1, _021EE750 ; =0x0001E524
	str r0, [r4, r1]
	mov r0, #6
	pop {r4, pc}
	.balign 4, 0
_021EE750: .word 0x0001E524
	thumb_func_end ov112_021EE73C

	thumb_func_start ov112_021EE754
ov112_021EE754: ; 0x021EE754
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE774 ; =0x0001E524
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _021EE770
	mov r0, #0xb
	str r0, [r4, #4]
	mov r0, #7
	pop {r4, pc}
_021EE770:
	mov r0, #6
	pop {r4, pc}
	.balign 4, 0
_021EE774: .word 0x0001E524
	thumb_func_end ov112_021EE754

	thumb_func_start ov112_021EE778
ov112_021EE778: ; 0x021EE778
	push {r4, lr}
	sub sp, #0x10
	mov r2, #0
	add r4, r0, #0
	str r2, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x18]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	mov r0, #8
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov112_021EE778

	thumb_func_start ov112_021EE7A8
ov112_021EE7A8: ; 0x021EE7A8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [r5, #0x20]
	bl SaveArray_PCStorage_Get
	str r0, [sp, #4]
	mov r0, #0x9a
	bl AllocMonZeroed
	add r4, r0, #0
	bl Mon_GetBoxMon
	add r6, r0, #0
	ldr r0, _021EE89C ; =0x0001E440
	add r2, sp, #8
	ldr r0, [r5, r0]
	add r1, sp, #8
	add r2, #2
	bl sub_02032688
	add r0, sp, #8
	ldrh r0, [r0, #2]
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, _021EE8A0 ; =0x000010E7
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	bne _021EE81E
	ldr r0, _021EE89C ; =0x0001E440
	add r1, r6, #0
	ldr r0, [r5, r0]
	bl Pokewalker_TryGetBoxMon
	add r7, r0, #0
	beq _021EE804
	ldr r2, _021EE8A4 ; =0x0001EC7C
	add r0, r6, #0
	ldr r2, [r5, r2]
	add r1, r4, #0
	bl ov112_021EE8BC
	ldr r1, _021EE8A8 ; =0x0001F374
	strh r0, [r5, r1]
_021EE804:
	ldr r1, _021EE8A4 ; =0x0001EC7C
	add r0, r6, #0
	ldr r1, [r5, r1]
	bl ov112_021EE970
	ldr r0, _021EE8A4 ; =0x0001EC7C
	mov r1, #0
	str r1, [r5, r0]
	ldr r0, _021EE89C ; =0x0001E440
	ldr r0, [r5, r0]
	bl Pokewalker_ClearBoxMon
	b _021EE854
_021EE81E:
	ldr r7, _021EE8AC ; =0x00009D44
	bl MTRandom
	mov r1, #0x18
	bl _u32_div_f
	add r3, r1, #0
	mov r0, #0
	str r0, [sp]
	ldr r1, _021EE8B0 ; =0x0001E438
	add r0, r4, #0
	ldr r1, [r5, r1]
	add r2, r5, r7
	bl ov112_021EE9A4
	add r0, r4, #0
	bl Mon_GetBoxMon
	mov r1, #0x9a
	str r1, [sp]
	ldr r1, _021EE8B0 ; =0x0001E438
	mov r2, #0
	ldr r1, [r5, r1]
	mov r3, #0xe9
	bl BoxMonSetTrainerMemo
	mov r7, #1
_021EE854:
	cmp r7, #0
	beq _021EE890
	ldr r0, [sp, #4]
	add r1, sp, #0x10
	add r2, sp, #0xc
	bl PCStorage_FindFirstEmptySlot
	ldr r0, [sp, #4]
	ldr r1, [sp, #0x10]
	ldr r2, [sp, #0xc]
	add r3, r6, #0
	bl PCStorage_PlaceMonInBoxByIndexPair
	ldr r0, [sp, #4]
	ldr r1, [sp, #0x10]
	ldr r2, [sp, #0xc]
	bl PCStorage_GetMonByIndexPair
	ldr r1, _021EE8B4 ; =0x0001E430
	str r0, [r5, r1]
	add r1, #0x14
	ldr r0, [r5, r1]
	add r1, r4, #0
	bl Pokedex_SetMonSeenFlag
	ldr r0, _021EE8B8 ; =0x0001E444
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl Pokedex_SetMonCaughtFlag
_021EE890:
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_021EE89C: .word 0x0001E440
_021EE8A0: .word 0x000010E7
_021EE8A4: .word 0x0001EC7C
_021EE8A8: .word 0x0001F374
_021EE8AC: .word 0x00009D44
_021EE8B0: .word 0x0001E438
_021EE8B4: .word 0x0001E430
_021EE8B8: .word 0x0001E444
	thumb_func_end ov112_021EE7A8

	thumb_func_start ov112_021EE8BC
ov112_021EE8BC: ; 0x021EE8BC
	push {r3, r4, r5, r6, r7, lr}
	mov r6, #0
	add r5, r1, #0
	add r4, r2, #0
	mov r1, #0xa1
	add r2, r6, #0
	add r7, r0, #0
	bl GetBoxMonData
	cmp r0, #0x64
	bhs _021EE91C
	cmp r4, #0
	bge _021EE8D8
	add r4, r6, #0
_021EE8D8:
	add r0, r7, #0
	bl CalcBoxMonExpToNextLevel
	cmp r4, r0
	blt _021EE8E6
	add r4, r0, #0
	mov r6, #1
_021EE8E6:
	add r0, r7, #0
	mov r1, #8
	mov r2, #0
	bl GetBoxMonData
	str r0, [sp]
	add r0, r0, r4
	str r0, [sp]
	add r0, r7, #0
	add r1, r5, #0
	bl CopyBoxPokemonToPokemon
	add r0, r5, #0
	mov r1, #8
	add r2, sp, #0
	bl SetMonData
	add r0, r5, #0
	bl CalcMonLevelAndStats
	cmp r6, #0
	beq _021EE91C
	add r0, r5, #0
	mov r1, #0
	mov r2, #8
	bl MonApplyFriendshipMod
_021EE91C:
	add r0, r6, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov112_021EE8BC

	thumb_func_start ov112_021EE920
ov112_021EE920: ; 0x021EE920
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EE960 ; =0x0001F376
	mov r1, #0
	strh r1, [r4, r0]
	ldr r0, _021EE964 ; =0x00009D78
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	beq _021EE95C
	ldr r0, _021EE968 ; =0x0001E440
	ldr r0, [r4, r0]
	bl sub_02032764
	cmp r0, #0
	bne _021EE95C
	ldr r0, _021EE968 ; =0x0001E440
	ldr r0, [r4, r0]
	bl sub_0203276C
	ldr r0, _021EE96C ; =0x0001E434
	mov r1, #0xcf
	ldr r0, [r4, r0]
	mov r2, #1
	mov r3, #0x9a
	bl Bag_AddItem
	ldr r0, _021EE960 ; =0x0001F376
	mov r1, #1
	strh r1, [r4, r0]
_021EE95C:
	pop {r4, pc}
	nop
_021EE960: .word 0x0001F376
_021EE964: .word 0x00009D78
_021EE968: .word 0x0001E440
_021EE96C: .word 0x0001E434
	thumb_func_end ov112_021EE920

	thumb_func_start ov112_021EE970
ov112_021EE970: ; 0x021EE970
	push {r3, r4, lr}
	sub sp, #4
	ldr r2, _021EE9A0 ; =0x00001388
	add r4, r0, #0
	cmp r1, r2
	blt _021EE99C
	mov r1, #9
	mov r2, #0
	bl GetBoxMonData
	add r1, sp, #0
	strb r0, [r1]
	ldrb r0, [r1]
	cmp r0, #0xff
	bhs _021EE99C
	add r0, r0, #1
	strb r0, [r1]
	add r0, r4, #0
	mov r1, #9
	add r2, sp, #0
	bl SetBoxMonData
_021EE99C:
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021EE9A0: .word 0x00001388
	thumb_func_end ov112_021EE970

	thumb_func_start ov112_021EE9A4
ov112_021EE9A4: ; 0x021EE9A4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #0x9a
	add r7, r2, #0
	str r3, [sp, #4]
	bl PlayerProfile_GetPlayerName_NewString
	add r6, r0, #0
	add r0, r4, #0
	bl PlayerProfile_GetTrainerID
	add r1, r0, #0
	ldr r0, [sp, #0x20]
	ldr r3, [sp, #4]
	str r0, [sp]
	add r0, r5, #0
	add r2, r7, #0
	bl ov112_021EE9E4
	add r0, r5, #0
	mov r1, #0x91
	add r2, r6, #0
	bl SetMonData
	add r0, r6, #0
	bl String_Delete
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov112_021EE9A4

	thumb_func_start ov112_021EE9E4
ov112_021EE9E4: ; 0x021EE9E4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r4, r2, #0
	add r5, r0, #0
	ldrb r0, [r4, #0xd]
	add r7, r1, #0
	mov r6, #0
	lsl r0, r0, #0x1b
	lsr r1, r0, #0x1b
	add r0, sp, #0x10
	strb r1, [r0]
	ldrb r0, [r4, #0xd]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1e
	cmp r0, #1
	bne _021EEA06
	mov r6, #0xfe
_021EEA06:
	mov r0, #1
	and r0, r3
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	ldr r0, [sp, #0x28]
	lsl r2, r3, #0x18
	str r0, [sp, #4]
	ldrh r1, [r4]
	add r0, r7, #0
	lsr r2, r2, #0x18
	add r3, r6, #0
	bl ChangePersonalityToNatureGenderAndAbility
	mov r1, #1
	str r1, [sp]
	str r0, [sp, #4]
	str r1, [sp, #8]
	str r7, [sp, #0xc]
	ldrh r1, [r4]
	ldrb r2, [r4, #0xc]
	add r0, r5, #0
	mov r3, #0x20
	bl CreateMon
	add r0, r5, #0
	mov r1, #6
	add r2, r4, #2
	bl SetMonData
	add r0, r5, #0
	mov r1, #0x36
	add r2, r4, #4
	bl SetMonData
	add r0, r5, #0
	mov r1, #0x37
	add r2, r4, #6
	bl SetMonData
	add r2, r4, #0
	add r0, r5, #0
	mov r1, #0x38
	add r2, #8
	bl SetMonData
	add r4, #0xa
	add r0, r5, #0
	mov r1, #0x39
	add r2, r4, #0
	bl SetMonData
	add r0, r5, #0
	mov r1, #0x70
	add r2, sp, #0x10
	bl SetMonData
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov112_021EE9E4

	thumb_func_start ov112_021EEA7C
ov112_021EEA7C: ; 0x021EEA7C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r7, _021EEADC ; =0x00009DAC
	mov r6, #0
	add r4, r5, #0
_021EEA86:
	ldrh r1, [r4, r7]
	cmp r1, #0
	beq _021EEA98
	ldr r0, _021EEAE0 ; =0x0001E434
	mov r2, #1
	ldr r0, [r5, r0]
	mov r3, #0x9a
	bl Bag_AddItem
_021EEA98:
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #3
	blt _021EEA86
	ldr r7, _021EEAE4 ; =0x00009DB8
	mov r6, #0
	add r4, r5, #0
_021EEAA6:
	ldrh r1, [r4, r7]
	cmp r1, #0
	beq _021EEAB8
	ldr r0, _021EEAE0 ; =0x0001E434
	mov r2, #1
	ldr r0, [r5, r0]
	mov r3, #0x9a
	bl Bag_AddItem
_021EEAB8:
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #0xa
	blt _021EEAA6
	ldr r0, _021EEAE8 ; =0x0000AABC
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1f
	beq _021EEADA
	ldr r1, _021EEAEC ; =0x0000B002
	ldr r0, _021EEAE0 ; =0x0001E434
	ldrh r1, [r5, r1]
	ldr r0, [r5, r0]
	mov r2, #1
	mov r3, #0x9a
	bl Bag_AddItem
_021EEADA:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EEADC: .word 0x00009DAC
_021EEAE0: .word 0x0001E434
_021EEAE4: .word 0x00009DB8
_021EEAE8: .word 0x0000AABC
_021EEAEC: .word 0x0000B002
	thumb_func_end ov112_021EEA7C
