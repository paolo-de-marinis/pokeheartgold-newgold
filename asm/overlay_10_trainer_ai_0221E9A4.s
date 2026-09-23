	.include "asm/macros.inc"
	.include "overlay_10.inc"
	.include "global.inc"

	.text

	thumb_func_start ov10_0221E9A4
ov10_0221E9A4: ; 0x0221E9A4
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	cmp r4, #1
	bne _0221E9C8
	bl GF_AssertFail
_0221E9C8:
	cmp r4, #0
	bne _0221E9D0
	bl GF_AssertFail
_0221E9D0:
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	bl MaskOfFlagNo
	ldr r1, _0221E9F0 ; =0x00003108
	ldrb r1, [r5, r1]
	tst r0, r1
	beq _0221E9EE
	add r0, r5, #0
	add r1, r6, #0
	bl ov10_0221EF24
_0221E9EE:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221E9F0: .word 0x00003108
	thumb_func_end ov10_0221E9A4

	thumb_func_start ov10_0221E9F4
ov10_0221E9F4: ; 0x0221E9F4
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r5, #0
	bl ov10_0221EEF0
	add r4, r0, #0
	add r0, r5, #0
	bl ov10_0221EEF0
	add r6, r0, #0
	cmp r4, #1
	bne _0221EA18
	bl GF_AssertFail
_0221EA18:
	cmp r4, #0
	bne _0221EA20
	bl GF_AssertFail
_0221EA20:
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	bl MaskOfFlagNo
	ldr r1, _0221EA40 ; =0x00003108
	ldrb r1, [r5, r1]
	tst r0, r1
	bne _0221EA3E
	add r0, r5, #0
	add r1, r6, #0
	bl ov10_0221EF24
_0221EA3E:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221EA40: .word 0x00003108
	thumb_func_end ov10_0221E9F4

	thumb_func_start ov10_0221EA44
ov10_0221EA44: ; 0x0221EA44
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221EA78 ; =0x00002DBE
	add r1, r4, r1
	ldrb r0, [r1, r0]
	lsl r0, r0, #0x1c
	lsr r1, r0, #0x1c
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221EA78: .word 0x00002DBE
	thumb_func_end ov10_0221EA44

	thumb_func_start ov10_0221EA7C
ov10_0221EA7C: ; 0x0221EA7C
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	add r2, r0, #0
	mov r1, #0xc0
	mul r2, r1
	ldr r0, _0221EAC4 ; =0x00002DD4
	add r2, r4, r2
	add r1, #0x90
	ldr r2, [r2, r0]
	ldr r0, [r4, r1]
	cmp r2, r0
	bge _0221EAB8
	mov r0, #0xd7
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
_0221EAB8:
	mov r1, #1
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0221EAC4: .word 0x00002DD4
	thumb_func_end ov10_0221EA7C

	thumb_func_start ov10_0221EAC8
ov10_0221EAC8: ; 0x0221EAC8
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	mov r1, #0xc0
	mul r1, r0
	ldr r0, _0221EAFC ; =0x00002DC8
	add r1, r4, r1
	ldr r0, [r1, r0]
	lsl r0, r0, #8
	lsr r1, r0, #0x1d
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0221EAFC: .word 0x00002DC8
	thumb_func_end ov10_0221EAC8

	thumb_func_start ov10_0221EB00
ov10_0221EB00: ; 0x0221EB00
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	mov r0, #0xd7
	ldr r1, [r5, #0x2c]
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r3, r4, r5, pc}
	thumb_func_end ov10_0221EB00

	thumb_func_start ov10_0221EB18
ov10_0221EB18: ; 0x0221EB18
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	mov r1, #1
	bl ov10_0221EF24
	add r0, r4, #0
	bl ov10_0221EEF0
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov10_0221EF34
	lsl r0, r0, #1
	add r1, r4, r0
	ldr r0, _0221EB48 ; =0x00003124
	ldrh r1, [r1, r0]
	mov r0, #0xd7
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0221EB48: .word 0x00003124
	thumb_func_end ov10_0221EB18
