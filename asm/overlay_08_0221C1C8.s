#include "constants/moves.h"
	.include "asm/macros.inc"
	.include "overlay_08.inc"
	.include "global.inc"

	.text

	thumb_func_start ov08_0221C1C8
ov08_0221C1C8: ; 0x0221C1C8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5]
	ldrb r1, [r4, #0x11]
	cmp r1, #0
	bne _0221C1DA
	ldr r0, [r4, #0x18]
	cmp r0, #0
	bne _0221C1E4
_0221C1DA:
	cmp r1, #1
	bne _0221C200
	ldr r0, [r4, #0x1c]
	cmp r0, #0
	beq _0221C200
_0221C1E4:
	add r0, r5, #0
	bl ov08_0222057C
	add r0, r5, #0
	bl ov08_022201C0
	ldr r0, [r5]
	mov r1, #6
	strb r1, [r0, #0x11]
	ldr r0, _0221C30C ; =0x00002079
	mov r1, #0x19
	strb r1, [r5, r0]
	mov r0, #0x11
	pop {r3, r4, r5, pc}
_0221C200:
	ldrh r0, [r4, #0x22]
	ldr r2, [r4, #0xc]
	mov r1, #0x24
	bl GetItemAttr
	cmp r0, #0
	beq _0221C236
	ldrh r0, [r4, #0x22]
	ldr r2, [r4, #0xc]
	mov r1, #0x25
	bl GetItemAttr
	cmp r0, #0
	bne _0221C236
	ldrb r1, [r4, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r0, r5, r0
	ldrb r0, [r0, #0x1b]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _0221C236
	ldr r0, _0221C30C ; =0x00002079
	mov r1, #0xd
	strb r1, [r5, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C236:
	ldrh r0, [r4, #0x22]
	mov r3, #0
	str r0, [sp]
	ldrb r2, [r4, #0x11]
	ldr r0, [r4, #8]
	ldr r1, [r4, #0x28]
	add r2, r4, r2
	add r2, #0x2c
	ldrb r2, [r2]
	bl BattleSystem_RecoverStatus
	cmp r0, #1
	bne _0221C2E6
	ldrh r0, [r4, #0x22]
	ldr r2, [r4, #0xc]
	mov r1, #0x25
	bl GetItemAttr
	cmp r0, #0
	beq _0221C266
	ldr r0, _0221C30C ; =0x00002079
	mov r1, #0xd
	strb r1, [r5, r0]
	b _0221C2DC
_0221C266:
	ldrb r1, [r4, #0x11]
	add r0, r5, #0
	bl ov08_0221D5DC
	cmp r0, #1
	bne _0221C2D6
	ldrh r0, [r4, #0x22]
	ldr r2, [r4, #0xc]
	mov r1, #0x17
	bl GetItemAttr
	cmp r0, #0
	bne _0221C2D6
	add r2, r4, #0
	add r2, #0x33
	ldrh r1, [r4, #0x22]
	ldrb r2, [r2]
	ldr r0, [r4, #8]
	ldr r3, [r4, #0xc]
	bl ov08_0221DBCC
	ldrb r2, [r4, #0x11]
	ldr r0, [r4, #8]
	ldr r1, [r4, #0x28]
	add r2, r4, r2
	add r2, #0x2c
	ldrb r2, [r2]
	bl BattleSystem_GetPartyMon
	ldrb r2, [r4, #0x11]
	mov r1, #0x50
	add r3, r2, #0
	mul r3, r1
	add r2, r5, r3
	str r0, [r2, #4]
	ldrb r0, [r4, #0x11]
	mov r2, #0
	mul r1, r0
	add r0, r5, r1
	ldr r0, [r0, #4]
	mov r1, #0xa3
	bl GetMonData
	strh r0, [r4, #0x20]
	ldrb r1, [r4, #0x11]
	mov r0, #0x50
	ldrh r2, [r4, #0x20]
	mul r0, r1
	add r0, r5, r0
	ldrh r0, [r0, #0x14]
	mov r1, #0x19
	sub r0, r2, r0
	strh r0, [r4, #0x20]
	ldr r0, _0221C30C ; =0x00002079
	strb r1, [r5, r0]
	b _0221C2DC
_0221C2D6:
	ldr r0, _0221C30C ; =0x00002079
	mov r1, #0x17
	strb r1, [r5, r0]
_0221C2DC:
	ldr r0, _0221C310 ; =0x0000207C
	mov r1, #0
	strb r1, [r5, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C2E6:
	ldr r2, _0221C314 ; =0x00001FA8
	mov r1, #0x51
	ldr r0, [r5, r2]
	add r2, #8
	ldr r2, [r5, r2]
	bl ReadMsgDataIntoString
	add r0, r5, #0
	bl ov08_022201C0
	ldr r0, [r5]
	mov r1, #6
	strb r1, [r0, #0x11]
	ldr r0, _0221C30C ; =0x00002079
	mov r1, #0x19
	strb r1, [r5, r0]
	mov r0, #0x11
	pop {r3, r4, r5, pc}
	nop
_0221C30C: .word 0x00002079
_0221C310: .word 0x0000207C
_0221C314: .word 0x00001FA8
	thumb_func_end ov08_0221C1C8

	thumb_func_start ov08_0221C318
ov08_0221C318: ; 0x0221C318
	push {r4, lr}
	add r4, r0, #0
	bl ov08_0221D4B0
	cmp r0, #3
	bhi _0221C3BA
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221C330: ; jump table
	.short _0221C338 - _0221C330 - 2 ; case 0
	.short _0221C35E - _0221C330 - 2 ; case 1
	.short _0221C380 - _0221C330 - 2 ; case 2
	.short _0221C3A2 - _0221C330 - 2 ; case 3
_0221C338:
	ldr r0, _0221C3C0 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	bl ov08_022220AC
	add r0, r4, #0
	bl ov08_0221D91C
	cmp r0, #1
	bne _0221C354
	mov r0, #0x19
	pop {r4, pc}
_0221C354:
	ldr r0, _0221C3C4 ; =0x00002079
	mov r1, #0xf
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C35E:
	add r0, r4, #0
	bl ov08_0221DAC4
	cmp r0, #1
	beq _0221C3BA
	ldr r0, _0221C3C0 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #8
	bl ov08_022220AC
	ldr r0, _0221C3C4 ; =0x00002079
	mov r1, #8
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C380:
	add r0, r4, #0
	bl ov08_0221DAC4
	cmp r0, #1
	beq _0221C3BA
	ldr r0, _0221C3C0 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	bl ov08_022220AC
	ldr r0, _0221C3C4 ; =0x00002079
	mov r1, #9
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C3A2:
	ldr r0, _0221C3C0 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	bl ov08_022220AC
	ldr r0, _0221C3C4 ; =0x00002079
	mov r1, #6
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C3BA:
	mov r0, #2
	pop {r4, pc}
	nop
_0221C3C0: .word 0x000005DD
_0221C3C4: .word 0x00002079
	thumb_func_end ov08_0221C318

	thumb_func_start ov08_0221C3C8
ov08_0221C3C8: ; 0x0221C3C8
	push {r4, lr}
	add r4, r0, #0
	bl ov08_0221D4F8
	cmp r0, #3
	bhi _0221C478
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221C3E0: ; jump table
	.short _0221C3E8 - _0221C3E0 - 2 ; case 0
	.short _0221C416 - _0221C3E0 - 2 ; case 1
	.short _0221C442 - _0221C3E0 - 2 ; case 2
	.short _0221C45A - _0221C3E0 - 2 ; case 3
_0221C3E8:
	ldr r1, [r4]
	mov r2, #0
	ldrb r1, [r1, #0x11]
	add r0, r4, #0
	mvn r2, r2
	bl ov08_0221D614
	cmp r0, #0xff
	beq _0221C478
	ldr r1, [r4]
	strb r0, [r1, #0x11]
	ldr r0, _0221C47C ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xc
	bl ov08_022220AC
	ldr r0, _0221C480 ; =0x00002079
	mov r1, #0xe
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C416:
	ldr r1, [r4]
	add r0, r4, #0
	ldrb r1, [r1, #0x11]
	mov r2, #1
	bl ov08_0221D614
	cmp r0, #0xff
	beq _0221C478
	ldr r1, [r4]
	strb r0, [r1, #0x11]
	ldr r0, _0221C47C ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xd
	bl ov08_022220AC
	ldr r0, _0221C480 ; =0x00002079
	mov r1, #0xe
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C442:
	ldr r0, _0221C47C ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xb
	bl ov08_022220AC
	ldr r0, _0221C480 ; =0x00002079
	mov r1, #9
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C45A:
	ldr r0, _0221C47C ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	bl ov08_022220AC
	ldr r0, _0221C484 ; =0x0000208C
	mov r1, #1
	strb r1, [r4, r0]
	mov r1, #7
	sub r0, #0x13
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r4, pc}
_0221C478:
	mov r0, #3
	pop {r4, pc}
	.balign 4, 0
_0221C47C: .word 0x000005DD
_0221C480: .word 0x00002079
_0221C484: .word 0x0000208C
	thumb_func_end ov08_0221C3C8

	thumb_func_start ov08_0221C488
ov08_0221C488: ; 0x0221C488
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov08_0221D540
	add r5, r0, #0
	cmp r5, #7
	bhi _0221C57A
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221C4A2: ; jump table
	.short _0221C4B2 - _0221C4A2 - 2 ; case 0
	.short _0221C4B2 - _0221C4A2 - 2 ; case 1
	.short _0221C4B2 - _0221C4A2 - 2 ; case 2
	.short _0221C4B2 - _0221C4A2 - 2 ; case 3
	.short _0221C4EA - _0221C4A2 - 2 ; case 4
	.short _0221C518 - _0221C4A2 - 2 ; case 5
	.short _0221C544 - _0221C4A2 - 2 ; case 6
	.short _0221C55C - _0221C4A2 - 2 ; case 7
_0221C4B2:
	ldr r0, [r4]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r1, r4, r0
	lsl r0, r5, #3
	add r0, r1, r0
	ldrh r0, [r0, #0x34]
	cmp r0, #0
	beq _0221C57A
	ldr r0, _0221C580 ; =0x000005DD
	bl PlaySE
	add r1, r5, #0
	add r1, #0xe
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov08_022220AC
	ldr r0, [r4]
	mov r1, #0xa
	add r0, #0x34
	strb r5, [r0]
	ldr r0, _0221C584 ; =0x00002079
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C4EA:
	ldr r1, [r4]
	mov r2, #0
	ldrb r1, [r1, #0x11]
	add r0, r4, #0
	mvn r2, r2
	bl ov08_0221D614
	cmp r0, #0xff
	beq _0221C57A
	ldr r1, [r4]
	strb r0, [r1, #0x11]
	ldr r0, _0221C580 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xc
	bl ov08_022220AC
	ldr r0, _0221C584 ; =0x00002079
	mov r1, #0xe
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C518:
	ldr r1, [r4]
	add r0, r4, #0
	ldrb r1, [r1, #0x11]
	mov r2, #1
	bl ov08_0221D614
	cmp r0, #0xff
	beq _0221C57A
	ldr r1, [r4]
	strb r0, [r1, #0x11]
	ldr r0, _0221C580 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xd
	bl ov08_022220AC
	ldr r0, _0221C584 ; =0x00002079
	mov r1, #0xe
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C544:
	ldr r0, _0221C580 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #9
	bl ov08_022220AC
	ldr r0, _0221C584 ; =0x00002079
	mov r1, #8
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C55C:
	ldr r0, _0221C580 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	bl ov08_022220AC
	ldr r0, _0221C588 ; =0x0000208C
	mov r1, #2
	strb r1, [r4, r0]
	mov r1, #7
	sub r0, #0x13
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C57A:
	mov r0, #4
	pop {r3, r4, r5, pc}
	nop
_0221C580: .word 0x000005DD
_0221C584: .word 0x00002079
_0221C588: .word 0x0000208C
	thumb_func_end ov08_0221C488

	thumb_func_start ov08_0221C58C
ov08_0221C58C: ; 0x0221C58C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov08_0221D588
	add r5, r0, #0
	cmp r5, #4
	bhi _0221C5F6
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221C5A6: ; jump table
	.short _0221C5B0 - _0221C5A6 - 2 ; case 0
	.short _0221C5B0 - _0221C5A6 - 2 ; case 1
	.short _0221C5B0 - _0221C5A6 - 2 ; case 2
	.short _0221C5B0 - _0221C5A6 - 2 ; case 3
	.short _0221C5DE - _0221C5A6 - 2 ; case 4
_0221C5B0:
	ldr r1, [r4]
	add r0, r1, #0
	add r0, #0x34
	ldrb r0, [r0]
	cmp r0, r5
	beq _0221C5CE
	ldrb r1, [r1, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r1, r4, r0
	lsl r0, r5, #3
	add r0, r1, r0
	ldrh r0, [r0, #0x34]
	cmp r0, #0
	beq _0221C5F6
_0221C5CE:
	ldr r0, _0221C5FC ; =0x000005DD
	bl PlaySE
	ldr r0, [r4]
	add r0, #0x34
	strb r5, [r0]
	mov r0, #0xa
	pop {r3, r4, r5, pc}
_0221C5DE:
	ldr r0, _0221C5FC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	bl ov08_022220AC
	ldr r0, _0221C600 ; =0x00002079
	mov r1, #9
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C5F6:
	mov r0, #5
	pop {r3, r4, r5, pc}
	nop
_0221C5FC: .word 0x000005DD
_0221C600: .word 0x00002079
	thumb_func_end ov08_0221C58C

	thumb_func_start ov08_0221C604
ov08_0221C604: ; 0x0221C604
	push {r3, r4, r5, lr}
	ldr r1, _0221C6E0 ; =ov08_02224F3C
	add r4, r0, #0
	bl ov08_0221D5D0
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	bne _0221C62E
	ldr r0, _0221C6E4 ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224C94
	add r5, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	bne _0221C634
	mov r5, #6
	b _0221C634
_0221C62E:
	add r0, r4, #0
	bl ov08_022217C8
_0221C634:
	cmp r5, #6
	bhi _0221C6DC
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221C644: ; jump table
	.short _0221C652 - _0221C644 - 2 ; case 0
	.short _0221C652 - _0221C644 - 2 ; case 1
	.short _0221C652 - _0221C644 - 2 ; case 2
	.short _0221C652 - _0221C644 - 2 ; case 3
	.short _0221C652 - _0221C644 - 2 ; case 4
	.short _0221C67C - _0221C644 - 2 ; case 5
	.short _0221C6BC - _0221C644 - 2 ; case 6
_0221C652:
	lsl r0, r5, #0x18
	lsr r1, r0, #0x18
	ldr r0, [r4]
	add r0, #0x34
	strb r1, [r0]
	ldr r0, _0221C6E8 ; =0x0000208D
	strb r1, [r4, r0]
	ldr r0, _0221C6EC ; =0x000005DD
	bl PlaySE
	add r5, #0x17
	lsl r1, r5, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov08_022220AC
	ldr r0, _0221C6F0 ; =0x00002079
	mov r1, #0xc
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C67C:
	ldr r0, _0221C6F4 ; =0x00002077
	ldrb r3, [r4, r0]
	lsl r1, r3, #0x18
	lsr r1, r1, #0x1c
	beq _0221C6DC
	mov r2, #0xf
	add r1, r3, #0
	bic r1, r2
	lsl r2, r3, #0x1c
	lsr r3, r2, #0x1c
	mov r2, #1
	eor r2, r3
	lsl r2, r2, #0x18
	lsr r3, r2, #0x18
	mov r2, #0xf
	and r2, r3
	orr r1, r2
	strb r1, [r4, r0]
	add r0, #0x16
	strb r5, [r4, r0]
	ldr r0, _0221C6EC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x12
	bl ov08_022220AC
	ldr r0, _0221C6F0 ; =0x00002079
	mov r1, #0xb
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C6BC:
	ldr r0, [r4]
	mov r1, #4
	add r0, #0x34
	strb r1, [r0]
	ldr r0, _0221C6EC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	bl ov08_022220AC
	ldr r0, _0221C6F0 ; =0x00002079
	mov r1, #0x19
	strb r1, [r4, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C6DC:
	mov r0, #0x13
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221C6E0: .word ov08_02224F3C
_0221C6E4: .word 0x00002088
_0221C6E8: .word 0x0000208D
_0221C6EC: .word 0x000005DD
_0221C6F0: .word 0x00002079
_0221C6F4: .word 0x00002077
	thumb_func_end ov08_0221C604

	thumb_func_start ov08_0221C6F8
ov08_0221C6F8: ; 0x0221C6F8
	push {r3, r4, r5, lr}
	ldr r1, _0221C7FC ; =ov08_02224E44
	add r5, r0, #0
	bl ov08_0221D5D0
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	bne _0221C722
	ldr r0, _0221C800 ; =0x00002088
	ldr r0, [r5, r0]
	bl ov08_02224C94
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _0221C728
	mov r4, #2
	b _0221C728
_0221C722:
	add r0, r5, #0
	bl ov08_022217C8
_0221C728:
	cmp r4, #0
	beq _0221C736
	cmp r4, #1
	beq _0221C792
	cmp r4, #2
	beq _0221C7D8
	b _0221C7F6
_0221C736:
	ldr r0, _0221C804 ; =0x000005DD
	bl PlaySE
	ldr r0, _0221C808 ; =0x00002077
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	bne _0221C750
	add r0, r5, #0
	mov r1, #0x1c
	bl ov08_022220AC
	b _0221C758
_0221C750:
	add r0, r5, #0
	mov r1, #0x1d
	bl ov08_022220AC
_0221C758:
	add r0, r5, #0
	bl ov08_0221DB54
	cmp r0, #1
	bne _0221C788
	add r0, r5, #0
	bl ov08_0221F220
	ldr r0, _0221C808 ; =0x00002077
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	bne _0221C77A
	add r0, r5, #0
	bl ov08_0221DB7C
	b _0221C780
_0221C77A:
	add r0, r5, #0
	bl ov08_0221DBB4
_0221C780:
	ldr r0, _0221C80C ; =0x00002079
	mov r1, #0x14
	strb r1, [r5, r0]
	b _0221C78E
_0221C788:
	ldr r0, _0221C80C ; =0x00002079
	mov r1, #0x19
	strb r1, [r5, r0]
_0221C78E:
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C792:
	ldr r0, _0221C808 ; =0x00002077
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1c
	beq _0221C7F6
	ldr r0, _0221C804 ; =0x000005DD
	bl PlaySE
	add r0, r5, #0
	mov r1, #0x12
	bl ov08_022220AC
	ldr r2, _0221C808 ; =0x00002077
	mov r1, #0xf
	ldrb r3, [r5, r2]
	add r0, r3, #0
	bic r0, r1
	lsl r1, r3, #0x1c
	lsr r3, r1, #0x1c
	mov r1, #1
	eor r1, r3
	lsl r1, r1, #0x18
	lsr r3, r1, #0x18
	mov r1, #0xf
	and r1, r3
	orr r0, r1
	strb r0, [r5, r2]
	add r0, r2, #0
	add r0, #0x17
	strb r4, [r5, r0]
	mov r1, #0xc
	add r0, r2, #2
	strb r1, [r5, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C7D8:
	ldr r0, _0221C804 ; =0x000005DD
	bl PlaySE
	add r0, r5, #0
	mov r1, #6
	bl ov08_022220AC
	ldr r0, _0221C810 ; =0x0000208E
	mov r1, #0
	strb r1, [r5, r0]
	mov r1, #0xb
	sub r0, #0x15
	strb r1, [r5, r0]
	mov r0, #0x16
	pop {r3, r4, r5, pc}
_0221C7F6:
	mov r0, #0x14
	pop {r3, r4, r5, pc}
	nop
_0221C7FC: .word ov08_02224E44
_0221C800: .word 0x00002088
_0221C804: .word 0x000005DD
_0221C808: .word 0x00002077
_0221C80C: .word 0x00002079
_0221C810: .word 0x0000208E
	thumb_func_end ov08_0221C6F8

	thumb_func_start ov08_0221C814
ov08_0221C814: ; 0x0221C814
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	ldr r1, _0221C900 ; =ov08_02224E94
	add r4, r0, #0
	ldr r6, [r4]
	bl ov08_0221D5D0
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	bne _0221C842
	ldr r0, _0221C904 ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224C94
	add r5, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	bne _0221C848
	mov r5, #4
	b _0221C848
_0221C842:
	add r0, r4, #0
	bl ov08_022217C8
_0221C848:
	cmp r5, #4
	bhi _0221C8FA
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221C858: ; jump table
	.short _0221C862 - _0221C858 - 2 ; case 0
	.short _0221C862 - _0221C858 - 2 ; case 1
	.short _0221C862 - _0221C858 - 2 ; case 2
	.short _0221C862 - _0221C858 - 2 ; case 3
	.short _0221C8E0 - _0221C858 - 2 ; case 4
_0221C862:
	ldrb r1, [r6, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r1, r4, r0
	lsl r0, r5, #3
	add r0, r1, r0
	ldrh r0, [r0, #0x34]
	cmp r0, #0
	beq _0221C8FA
	ldr r0, [r4]
	add r0, #0x34
	strb r5, [r0]
	ldr r0, _0221C908 ; =0x000005DD
	bl PlaySE
	add r1, r5, #0
	add r1, #0x13
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl ov08_022220AC
	ldrh r0, [r6, #0x22]
	add r3, r5, #0
	str r0, [sp]
	ldrb r2, [r6, #0x11]
	ldr r0, [r6, #8]
	ldr r1, [r6, #0x28]
	add r2, r6, r2
	add r2, #0x2c
	ldrb r2, [r2]
	bl BattleSystem_RecoverStatus
	cmp r0, #1
	bne _0221C8BA
	ldr r0, _0221C90C ; =0x0000207C
	mov r1, #0
	strb r1, [r4, r0]
	mov r1, #0x17
	sub r0, r0, #3
	strb r1, [r4, r0]
	add sp, #4
	mov r0, #0x16
	pop {r3, r4, r5, r6, pc}
_0221C8BA:
	ldr r2, _0221C910 ; =0x00001FA8
	mov r1, #0x51
	ldr r0, [r4, r2]
	add r2, #8
	ldr r2, [r4, r2]
	bl ReadMsgDataIntoString
	add r0, r4, #0
	bl ov08_022201C0
	ldr r0, [r4]
	mov r1, #6
	strb r1, [r0, #0x11]
	ldr r0, _0221C914 ; =0x00002079
	mov r1, #0x19
	strb r1, [r4, r0]
	add sp, #4
	mov r0, #0x11
	pop {r3, r4, r5, r6, pc}
_0221C8E0:
	ldr r0, _0221C908 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	bl ov08_022220AC
	ldr r0, _0221C914 ; =0x00002079
	mov r1, #6
	strb r1, [r4, r0]
	add sp, #4
	mov r0, #0x16
	pop {r3, r4, r5, r6, pc}
_0221C8FA:
	mov r0, #0x15
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_0221C900: .word ov08_02224E94
_0221C904: .word 0x00002088
_0221C908: .word 0x000005DD
_0221C90C: .word 0x0000207C
_0221C910: .word 0x00001FA8
_0221C914: .word 0x00002079
	thumb_func_end ov08_0221C814

	thumb_func_start ov08_0221C918
ov08_0221C918: ; 0x0221C918
	push {r3, lr}
	mov r1, #0
	bl ov08_0221D840
	mov r0, #1
	pop {r3, pc}
	thumb_func_end ov08_0221C918

	thumb_func_start ov08_0221C924
ov08_0221C924: ; 0x0221C924
	push {r3, lr}
	mov r1, #1
	bl ov08_0221D840
	mov r0, #2
	pop {r3, pc}
	thumb_func_end ov08_0221C924

	thumb_func_start ov08_0221C930
ov08_0221C930: ; 0x0221C930
	push {r3, lr}
	mov r1, #2
	bl ov08_0221D840
	mov r0, #3
	pop {r3, pc}
	thumb_func_end ov08_0221C930

	thumb_func_start ov08_0221C93C
ov08_0221C93C: ; 0x0221C93C
	push {r3, lr}
	mov r1, #3
	bl ov08_0221D840
	mov r0, #4
	pop {r3, pc}
	thumb_func_end ov08_0221C93C

	thumb_func_start ov08_0221C948
ov08_0221C948: ; 0x0221C948
	push {r3, lr}
	mov r1, #4
	bl ov08_0221D840
	mov r0, #5
	pop {r3, pc}
	thumb_func_end ov08_0221C948

	thumb_func_start ov08_0221C954
ov08_0221C954: ; 0x0221C954
	push {r3, lr}
	ldr r1, _0221C974 ; =0x00002077
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	bne _0221C968
	mov r1, #6
	bl ov08_0221D840
	b _0221C96E
_0221C968:
	mov r1, #8
	bl ov08_0221D840
_0221C96E:
	mov r0, #0x13
	pop {r3, pc}
	nop
_0221C974: .word 0x00002077
	thumb_func_end ov08_0221C954

	thumb_func_start ov08_0221C978
ov08_0221C978: ; 0x0221C978
	push {r4, lr}
	add r4, r0, #0
	bl ov08_022213C8
	ldr r0, _0221C9A0 ; =0x00002077
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	bne _0221C994
	add r0, r4, #0
	mov r1, #7
	bl ov08_0221D840
	b _0221C99C
_0221C994:
	add r0, r4, #0
	mov r1, #9
	bl ov08_0221D840
_0221C99C:
	mov r0, #0x14
	pop {r4, pc}
	.balign 4, 0
_0221C9A0: .word 0x00002077
	thumb_func_end ov08_0221C978

	thumb_func_start ov08_0221C9A4
ov08_0221C9A4: ; 0x0221C9A4
	push {r4, lr}
	add r4, r0, #0
	mov r1, #5
	bl ov08_0221D840
	ldr r2, [r4]
	mov r1, #0x25
	ldrh r0, [r2, #0x22]
	ldr r2, [r2, #0xc]
	bl GetItemAttr
	cmp r0, #0
	beq _0221C9C2
	mov r0, #0x18
	pop {r4, pc}
_0221C9C2:
	mov r0, #0x15
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_0221C9A4

	thumb_func_start ov08_0221C9C8
ov08_0221C9C8: ; 0x0221C9C8
	push {r4, lr}
	ldr r1, _0221CA04 ; =0x0000207A
	add r4, r0, #0
	ldrb r1, [r4, r1]
	bl ov08_02220C5C
	ldr r1, _0221CA04 ; =0x0000207A
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_0221DD70
	ldr r1, _0221CA04 ; =0x0000207A
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_022221CC
	ldr r1, _0221CA04 ; =0x0000207A
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_0221D6CC
	ldr r0, _0221CA04 ; =0x0000207A
	ldrb r0, [r4, r0]
	cmp r0, #2
	bne _0221C9FE
	mov r0, #3
	pop {r4, pc}
_0221C9FE:
	mov r0, #4
	pop {r4, pc}
	nop
_0221CA04: .word 0x0000207A
	thumb_func_end ov08_0221C9C8

	thumb_func_start ov08_0221CA08
ov08_0221CA08: ; 0x0221CA08
	push {r4, lr}
	add r4, r0, #0
	bl ov08_022201C0
	ldr r0, _0221CA1C ; =0x00002079
	mov r1, #0x10
	strb r1, [r4, r0]
	mov r0, #0x11
	pop {r4, pc}
	nop
_0221CA1C: .word 0x00002079
	thumb_func_end ov08_0221CA08

	thumb_func_start ov08_0221CA20
ov08_0221CA20: ; 0x0221CA20
	push {r3, lr}
	ldr r1, _0221CA30 ; =0x00002060
	add r0, r0, r1
	mov r1, #0
	bl ClearFrameAndWindow2
	mov r0, #2
	pop {r3, pc}
	.balign 4, 0
_0221CA30: .word 0x00002060
	thumb_func_end ov08_0221CA20

	thumb_func_start ov08_0221CA34
ov08_0221CA34: ; 0x0221CA34
	push {r3, lr}
	ldr r1, _0221CA4C ; =0x0000207B
	ldrb r0, [r0, r1]
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _0221CA46
	mov r0, #0x12
	pop {r3, pc}
_0221CA46:
	mov r0, #0x11
	pop {r3, pc}
	nop
_0221CA4C: .word 0x0000207B
	thumb_func_end ov08_0221CA34

	thumb_func_start ov08_0221CA50
ov08_0221CA50: ; 0x0221CA50
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0221CA70 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	bne _0221CA66
	bl System_GetTouchNew
	cmp r0, #1
	bne _0221CA6C
_0221CA66:
	ldr r0, _0221CA74 ; =0x00002079
	ldrb r0, [r4, r0]
	pop {r4, pc}
_0221CA6C:
	mov r0, #0x12
	pop {r4, pc}
	.balign 4, 0
_0221CA70: .word gSystem
_0221CA74: .word 0x00002079
	thumb_func_end ov08_0221CA50

	thumb_func_start ov08_0221CA78
ov08_0221CA78: ; 0x0221CA78
	ldr r1, _0221CA8C ; =0x00001FA3
	ldrb r2, [r0, r1]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x1f
	bne _0221CA88
	add r1, #0xd6
	ldrb r0, [r0, r1]
	bx lr
_0221CA88:
	mov r0, #0x16
	bx lr
	.balign 4, 0
_0221CA8C: .word 0x00001FA3
	thumb_func_end ov08_0221CA78

	thumb_func_start ov08_0221CA90
ov08_0221CA90: ; 0x0221CA90
	push {r3, r4, r5, r6, r7, lr}
	ldr r7, _0221CC28 ; =0x0000207C
	add r4, r0, #0
	ldrb r1, [r4, r7]
	ldr r5, [r4]
	cmp r1, #4
	bls _0221CAA0
	b _0221CC24
_0221CAA0:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221CAAC: ; jump table
	.short _0221CAB6 - _0221CAAC - 2 ; case 0
	.short _0221CB7A - _0221CAAC - 2 ; case 1
	.short _0221CBA2 - _0221CAAC - 2 ; case 2
	.short _0221CBDA - _0221CAAC - 2 ; case 3
	.short _0221CBFA - _0221CAAC - 2 ; case 4
_0221CAB6:
	ldrb r2, [r5, #0x11]
	ldr r0, [r5, #8]
	ldr r1, [r5, #0x28]
	add r2, r5, r2
	add r2, #0x2c
	ldrb r2, [r2]
	bl BattleSystem_GetPartyMon
	ldrb r2, [r5, #0x11]
	mov r1, #0x50
	mul r1, r2
	add r1, r4, r1
	str r0, [r1, #4]
	add r0, r4, #0
	bl ov08_02220224
	sub r0, r7, #2
	ldrb r0, [r4, r0]
	ldrb r1, [r5, #0x11]
	cmp r0, #5
	bne _0221CB00
	mov r0, #0x50
	mul r0, r1
	add r5, #0x34
	ldrb r1, [r5]
	add r0, r4, r0
	ldr r0, [r0, #4]
	add r1, #0x3a
	mov r2, #0
	bl GetMonData
	add r1, r7, #4
	strh r0, [r4, r1]
	mov r2, #2
	sub r0, r1, #4
	strb r2, [r4, r0]
	b _0221CB72
_0221CB00:
	mov r0, #0x50
	mul r0, r1
	add r0, r4, r0
	ldr r0, [r0, #4]
	bl Pokemon_GetStatusIconId
	add r6, r0, #0
	ldrb r0, [r5, #0x11]
	add r3, r4, #0
	mov r7, #0x50
	add r2, r0, #0
	add r3, #0x1b
	mul r2, r7
	ldrb r1, [r3, r2]
	mov r0, #0x78
	bic r1, r0
	lsl r0, r6, #0x18
	lsr r0, r0, #0x18
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x19
	orr r0, r1
	strb r0, [r3, r2]
	ldrb r0, [r5, #0x11]
	add r1, r0, #0
	mul r1, r7
	add r1, r4, r1
	ldrb r1, [r1, #0x1b]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1c
	cmp r1, #7
	bne _0221CB56
	add r0, #0xd
	lsl r0, r0, #2
	add r1, r4, r0
	ldr r0, _0221CC2C ; =0x00001FB8
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldrb r1, [r5, #0x11]
	add r0, r4, #0
	bl ov08_0221F5B0
_0221CB56:
	ldrb r1, [r5, #0x11]
	mov r0, #0x50
	mov r2, #0
	mul r0, r1
	add r0, r4, r0
	ldr r0, [r0, #4]
	mov r1, #0xa3
	bl GetMonData
	ldr r1, _0221CC30 ; =0x0000207E
	mov r2, #4
	strh r0, [r4, r1]
	sub r0, r1, #2
	strb r2, [r4, r0]
_0221CB72:
	ldr r0, _0221CC34 ; =0x000005EC
	bl PlaySE
	b _0221CC24
_0221CB7A:
	ldrb r1, [r5, #0x11]
	add r6, r4, #0
	mov r2, #0x50
	add r3, r1, #0
	add r6, #0x14
	mul r3, r2
	add r1, r7, #2
	ldrh r2, [r4, r1]
	ldrh r1, [r6, r3]
	cmp r2, r1
	beq _0221CB9C
	add r1, r1, #1
	strh r1, [r6, r3]
	ldrb r1, [r5, #0x11]
	bl ov08_0221F550
	b _0221CC24
_0221CB9C:
	mov r0, #3
	strb r0, [r4, r7]
	b _0221CC24
_0221CBA2:
	ldrb r3, [r5, #0x11]
	add r1, r4, #0
	mov r2, #0x50
	add r1, #0x36
	mul r2, r3
	add r6, r1, r2
	add r1, r5, #0
	add r1, #0x34
	ldrb r1, [r1]
	lsl r3, r1, #3
	add r1, r7, #4
	ldrh r2, [r4, r1]
	ldrb r1, [r6, r3]
	cmp r2, r1
	beq _0221CBD4
	add r1, r1, #1
	strb r1, [r6, r3]
	add r5, #0x34
	ldrb r2, [r5]
	add r1, r2, #1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	bl ov08_02220064
	b _0221CC24
_0221CBD4:
	mov r0, #3
	strb r0, [r4, r7]
	b _0221CC24
_0221CBDA:
	add r2, r5, #0
	add r2, #0x33
	ldrh r1, [r5, #0x22]
	ldrb r2, [r2]
	ldr r0, [r5, #8]
	ldr r3, [r5, #0xc]
	bl ov08_0221DBCC
	add r0, r4, #0
	bl ov08_022201C0
	mov r1, #0x19
	sub r0, r7, #3
	strb r1, [r4, r0]
	mov r0, #0x11
	pop {r3, r4, r5, r6, r7, pc}
_0221CBFA:
	ldrb r1, [r5, #0x11]
	add r3, r4, #0
	mov r2, #0x50
	mul r2, r1
	add r1, r7, #2
	add r3, #0x14
	ldrh r6, [r4, r1]
	ldrh r1, [r3, r2]
	cmp r6, r1
	beq _0221CC1E
	add r1, r1, #1
	strh r1, [r3, r2]
	ldrb r1, [r5, #0x11]
	bl ov08_0221F550
	add r0, r4, #0
	bl ov08_022225A4
_0221CC1E:
	ldr r0, _0221CC28 ; =0x0000207C
	mov r1, #1
	strb r1, [r4, r0]
_0221CC24:
	mov r0, #0x17
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221CC28: .word 0x0000207C
_0221CC2C: .word 0x00001FB8
_0221CC30: .word 0x0000207E
_0221CC34: .word 0x000005EC
	thumb_func_end ov08_0221CA90

	thumb_func_start ov08_0221CC38
ov08_0221CC38: ; 0x0221CC38
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, [r5]
	str r0, [sp, #4]
	ldr r0, _0221CD58 ; =0x0000207C
	ldrb r0, [r5, r0]
	cmp r0, #0
	beq _0221CC54
	cmp r0, #1
	beq _0221CCBE
	cmp r0, #2
	beq _0221CD28
	b _0221CD50
_0221CC54:
	ldr r2, [sp, #4]
	ldr r0, [sp, #4]
	ldrb r3, [r2, #0x11]
	ldr r1, [sp, #4]
	ldr r0, [r0, #8]
	add r2, r2, r3
	add r2, #0x2c
	ldrb r2, [r2]
	ldr r1, [r1, #0x28]
	bl BattleSystem_GetPartyMon
	ldr r1, [sp, #4]
	mov r7, #0
	ldrb r2, [r1, #0x11]
	mov r1, #0x50
	add r6, r7, #0
	mul r1, r2
	add r1, r5, r1
	str r0, [r1, #4]
	add r4, r5, #0
_0221CC7C:
	ldr r0, [sp, #4]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r1, r5, r0
	add r0, r1, r6
	ldrh r0, [r0, #0x34]
	cmp r0, #0
	beq _0221CCA0
	ldr r0, [r1, #4]
	add r1, r7, #0
	add r1, #0x3a
	mov r2, #0
	bl GetMonData
	mov r1, #0x82
	lsl r1, r1, #6
	strh r0, [r4, r1]
_0221CCA0:
	add r7, r7, #1
	add r6, #8
	add r4, r4, #2
	cmp r7, #4
	blo _0221CC7C
	add r0, r5, #0
	bl ov08_02220224
	ldr r0, _0221CD5C ; =0x000005EC
	bl PlaySE
	ldr r0, _0221CD58 ; =0x0000207C
	mov r1, #1
	strb r1, [r5, r0]
	b _0221CD50
_0221CCBE:
	mov r6, #0
	add r4, r6, #0
	str r6, [sp]
	add r7, r5, #0
_0221CCC6:
	ldr r0, [sp, #4]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r1, r5, r0
	ldr r0, [sp]
	add r1, r1, r0
	ldrh r0, [r1, #0x34]
	cmp r0, #0
	bne _0221CCDE
	add r6, r6, #1
	b _0221CD0E
_0221CCDE:
	mov r0, #0x82
	add r2, r1, #0
	lsl r0, r0, #6
	add r2, #0x36
	ldrh r0, [r7, r0]
	ldrb r2, [r2]
	cmp r0, r2
	beq _0221CD0C
	add r0, r1, #0
	add r0, #0x36
	ldrb r0, [r0]
	lsl r2, r4, #0x10
	add r1, #0x36
	add r0, r0, #1
	strb r0, [r1]
	add r1, r4, #1
	lsl r1, r1, #0x10
	add r0, r5, #0
	lsr r1, r1, #0x10
	lsr r2, r2, #0x10
	bl ov08_02220064
	b _0221CD0E
_0221CD0C:
	add r6, r6, #1
_0221CD0E:
	ldr r0, [sp]
	add r4, r4, #1
	add r0, #8
	add r7, r7, #2
	str r0, [sp]
	cmp r4, #4
	blo _0221CCC6
	cmp r6, #4
	bne _0221CD50
	ldr r0, _0221CD58 ; =0x0000207C
	mov r1, #2
	strb r1, [r5, r0]
	b _0221CD50
_0221CD28:
	ldr r2, [sp, #4]
	ldr r1, [sp, #4]
	ldr r0, [sp, #4]
	add r2, #0x33
	ldr r3, [sp, #4]
	ldrh r1, [r1, #0x22]
	ldrb r2, [r2]
	ldr r0, [r0, #8]
	ldr r3, [r3, #0xc]
	bl ov08_0221DBCC
	add r0, r5, #0
	bl ov08_022201C0
	ldr r0, _0221CD60 ; =0x00002079
	mov r1, #0x19
	strb r1, [r5, r0]
	add sp, #8
	mov r0, #0x11
	pop {r3, r4, r5, r6, r7, pc}
_0221CD50:
	mov r0, #0x18
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CD58: .word 0x0000207C
_0221CD5C: .word 0x000005EC
_0221CD60: .word 0x00002079
	thumb_func_end ov08_0221CC38

	thumb_func_start ov08_0221CD64
ov08_0221CD64: ; 0x0221CD64
	push {lr}
	sub sp, #0xc
	mov r2, #0
	str r2, [sp]
	mov r1, #0x10
	str r1, [sp, #4]
	mov r1, #0x7a
	str r2, [sp, #8]
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	mov r1, #0xa
	add r3, r1, #0
	ldr r2, _0221CD8C ; =0x0000FFFF
	sub r3, #0x12
	bl PaletteData_BeginPaletteFade
	mov r0, #0x1a
	add sp, #0xc
	pop {pc}
	nop
_0221CD8C: .word 0x0000FFFF
	thumb_func_end ov08_0221CD64

	thumb_func_start ov08_0221CD90
ov08_0221CD90: ; 0x0221CD90
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x7a
	add r4, r1, #0
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	beq _0221CDA8
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221CDA8:
	add r0, r4, #0
	bl ov08_0221D14C
	add r0, r4, #0
	bl ov08_02220A50
	add r0, r4, #0
	bl ov08_0221DD40
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ov08_0221CF08
	ldr r0, _0221CDF4 ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224B8C
	ldr r1, [r4]
	add r1, #0x32
	strb r0, [r1]
	ldr r0, _0221CDF4 ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224B7C
	mov r0, #4
	bl FontID_Release
	ldr r0, [r4]
	mov r1, #1
	add r0, #0x36
	strb r1, [r0]
	add r0, r5, #0
	bl DestroySysTaskAndEnvironment
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_0221CDF4: .word 0x00002088
	thumb_func_end ov08_0221CD90

	thumb_func_start ov08_0221CDF8
ov08_0221CDF8: ; 0x0221CDF8
	push {r3, r4, r5, lr}
	sub sp, #0x80
	ldr r5, _0221CEF4 ; =ov08_02224E34
	add r3, sp, #0x70
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	mov r1, #1
	bl SetScreenModeAndDisable
	ldr r5, _0221CEF8 ; =ov08_02224EAC
	add r3, sp, #0x54
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #7
	str r0, [r3]
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r5, _0221CEFC ; =ov08_02224EE4
	add r3, sp, #0x38
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #6
	str r0, [r3]
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r5, _0221CF00 ; =ov08_02224F00
	add r3, sp, #0x1c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #5
	str r0, [r3]
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r5, _0221CF04 ; =ov08_02224EC8
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #4
	str r0, [r3]
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r3, [r4]
	mov r0, #5
	ldr r3, [r3, #0xc]
	mov r1, #0x20
	mov r2, #0
	bl BG_ClearCharDataRange
	ldr r3, [r4]
	mov r0, #4
	ldr r3, [r3, #0xc]
	mov r1, #0x20
	mov r2, #0
	bl BG_ClearCharDataRange
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #5
	bl ScheduleBgTilemapBufferTransfer
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #4
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x80
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221CEF4: .word ov08_02224E34
_0221CEF8: .word ov08_02224EAC
_0221CEFC: .word ov08_02224EE4
_0221CF00: .word ov08_02224F00
_0221CF04: .word ov08_02224EC8
	thumb_func_end ov08_0221CDF8

	thumb_func_start ov08_0221CF08
ov08_0221CF08: ; 0x0221CF08
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #6
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #7
	bl FreeBgTilemapBuffer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_0221CF08

	thumb_func_start ov08_0221CF38
ov08_0221CF38: ; 0x0221CF38
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r1, [r5]
	mov r0, #0x47
	ldr r1, [r1, #0xc]
	bl NARC_New
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	str r1, [sp, #8]
	ldr r1, [r5]
	mov r2, #0x79
	ldr r1, [r1, #0xc]
	lsl r2, r2, #2
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	mov r1, #0x16
	mov r3, #7
	add r4, r0, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	ldr r2, [r5]
	add r0, r4, #0
	ldr r2, [r2, #0xc]
	mov r1, #0x14
	bl NARC_AllocAndReadWholeMember
	add r1, sp, #0x10
	add r6, r0, #0
	bl NNS_G2dGetUnpackedScreenData
	ldr r1, [sp, #0x10]
	add r0, r5, #0
	add r1, #0xc
	bl ov08_022217F0
	add r0, r6, #0
	bl Heap_Free
	ldr r2, [r5]
	add r0, r4, #0
	ldr r2, [r2, #0xc]
	mov r1, #0x15
	bl NARC_AllocAndReadWholeMember
	add r1, sp, #0x10
	add r6, r0, #0
	bl NNS_G2dGetUnpackedScreenData
	ldr r1, [sp, #0x10]
	add r0, r5, #0
	add r1, #0xc
	bl ov08_02221B1C
	add r0, r6, #0
	bl Heap_Free
	mov r0, #1
	str r0, [sp]
	lsl r0, r0, #9
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #0x7a
	ldr r3, [r5]
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [r3, #0xc]
	mov r1, #0x47
	mov r2, #0x17
	bl PaletteData_LoadNarc
	add r0, r4, #0
	bl NARC_Delete
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl PaletteData_GetUnfadedBuf
	add r2, r0, #0
	ldr r0, _0221D0F0 ; =0x00001F60
	mov r1, #6
	lsl r1, r1, #6
	add r1, r2, r1
	add r0, r5, r0
	mov r2, #0x40
	bl memcpy
	mov r0, #1
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xd0
	str r0, [sp, #8]
	mov r0, #0x7a
	ldr r3, [r5]
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [r3, #0xc]
	mov r1, #0x10
	mov r2, #7
	bl PaletteData_LoadNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xf0
	str r0, [sp, #8]
	ldr r3, [r5]
	add r0, #0xf8
	ldr r0, [r5, r0]
	ldr r3, [r3, #0xc]
	mov r1, #0x10
	mov r2, #8
	bl PaletteData_LoadNarc
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl BattleSystem_GetFrame
	add r4, r0, #0
	bl sub_0200E63C
	add r1, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5]
	mov r2, #0x79
	ldr r0, [r0, #0xc]
	lsl r2, r2, #2
	str r0, [sp, #0xc]
	ldr r2, [r5, r2]
	mov r0, #0x26
	mov r3, #4
	bl GfGfxLoader_LoadCharData
	add r0, r4, #0
	bl sub_0200E640
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xe0
	str r0, [sp, #8]
	mov r0, #0x7a
	ldr r3, [r5]
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [r3, #0xc]
	mov r1, #0x26
	bl PaletteData_LoadNarc
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl PaletteData_GetUnfadedBuf
	add r6, r0, #0
	ldr r0, [r5]
	mov r1, #0x20
	ldr r0, [r0, #0xc]
	bl Heap_Alloc
	mov r1, #0x1a
	lsl r1, r1, #4
	add r1, r6, r1
	mov r2, #0x20
	add r4, r0, #0
	bl memcpy
	mov r0, #0x4d
	lsl r0, r0, #2
	add r1, r6, r0
	ldrb r3, [r1]
	add r2, r4, #0
	add r2, #0xe
	strb r3, [r4, #0xe]
	ldrb r3, [r1, #1]
	strb r3, [r2, #1]
	ldrb r3, [r1, #2]
	strb r3, [r2, #2]
	ldrb r1, [r1, #3]
	mov r3, #0xd0
	strb r1, [r2, #3]
	add r2, r0, #4
	add r1, r0, #4
	ldrb r2, [r6, r2]
	add r1, r6, r1
	add r0, #0xb4
	strb r2, [r4, #6]
	ldrb r2, [r1, #1]
	strb r2, [r4, #7]
	ldrb r2, [r1, #2]
	strb r2, [r4, #8]
	ldrb r1, [r1, #3]
	mov r2, #1
	strb r1, [r4, #9]
	mov r1, #0x20
	str r1, [sp]
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl PaletteData_LoadPalette
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	nop
_0221D0F0: .word 0x00001F60
	thumb_func_end ov08_0221CF38

	thumb_func_start ov08_0221D0F4
ov08_0221D0F4: ; 0x0221D0F4
	push {r4, lr}
	add r4, r0, #0
	ldr r3, [r4]
	mov r0, #0
	ldr r3, [r3, #0xc]
	mov r1, #0x1b
	mov r2, #6
	bl NewMsgDataFromNarc
	ldr r1, _0221D13C ; =0x00001FA8
	mov r2, #0
	str r0, [r4, r1]
	ldr r3, [r4]
	mov r0, #0xf
	ldr r3, [r3, #0xc]
	mov r1, #0xe
	bl MessagePrinter_New
	ldr r1, _0221D140 ; =0x00001FA4
	str r0, [r4, r1]
	ldr r0, [r4]
	ldr r0, [r0, #0xc]
	bl MessageFormat_New
	ldr r1, _0221D144 ; =0x00001FAC
	str r0, [r4, r1]
	ldr r1, [r4]
	mov r0, #2
	ldr r1, [r1, #0xc]
	lsl r0, r0, #8
	bl String_New
	ldr r1, _0221D148 ; =0x00001FB0
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_0221D13C: .word 0x00001FA8
_0221D140: .word 0x00001FA4
_0221D144: .word 0x00001FAC
_0221D148: .word 0x00001FB0
	thumb_func_end ov08_0221D0F4

	thumb_func_start ov08_0221D14C
ov08_0221D14C: ; 0x0221D14C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0221D174 ; =0x00001FA8
	ldr r0, [r4, r0]
	bl DestroyMsgData
	ldr r0, _0221D178 ; =0x00001FA4
	ldr r0, [r4, r0]
	bl MessagePrinter_Delete
	ldr r0, _0221D17C ; =0x00001FAC
	ldr r0, [r4, r0]
	bl MessageFormat_Delete
	ldr r0, _0221D180 ; =0x00001FB0
	ldr r0, [r4, r0]
	bl String_Delete
	pop {r4, pc}
	nop
_0221D174: .word 0x00001FA8
_0221D178: .word 0x00001FA4
_0221D17C: .word 0x00001FAC
_0221D180: .word 0x00001FB0
	thumb_func_end ov08_0221D14C

	thumb_func_start ov08_0221D184
ov08_0221D184: ; 0x0221D184
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #8]
	ldr r0, [sp]
	ldr r0, [r0]
	ldr r0, [r0]
	bl Party_GetCount
	cmp r0, #0
	bgt _0221D19E
	b _0221D432
_0221D19E:
	ldr r0, [sp, #8]
	mov r1, #0x50
	mul r1, r0
	ldr r0, [sp]
	str r1, [sp, #4]
	add r4, r0, r1
	ldr r0, [r0]
	ldr r1, [sp, #8]
	ldr r0, [r0]
	bl Party_GetMonByIndex
	str r0, [r4, #4]
	mov r1, #5
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #8]
	ldrh r0, [r4, #8]
	cmp r0, #0
	bne _0221D1C8
	b _0221D416
_0221D1C8:
	ldr r0, [sp, #8]
	mov r1, #0x50
	add r5, r0, #0
	mul r5, r1
	ldr r0, [sp]
	mov r1, #0xa5
	add r4, r0, r5
	ldr r0, [r4, #4]
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0xa]
	ldr r0, [r4, #4]
	mov r1, #0xa6
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0xc]
	ldr r0, [r4, #4]
	mov r1, #0xa7
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0xe]
	ldr r0, [r4, #4]
	mov r1, #0xa8
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0x10]
	ldr r0, [r4, #4]
	mov r1, #0xa9
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0x12]
	ldr r0, [r4, #4]
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0x14]
	ldr r0, [r4, #4]
	mov r1, #0xa4
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0x16]
	ldr r0, [r4, #4]
	mov r1, #0xb1
	mov r2, #0
	bl GetMonData
	strb r0, [r4, #0x18]
	ldr r0, [r4, #4]
	mov r1, #0xb2
	mov r2, #0
	bl GetMonData
	ldr r6, [sp]
	strb r0, [r4, #0x19]
	ldr r0, [r4, #4]
	add r6, #0x1a
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	ldrb r1, [r6, r5]
	mov r2, #0x7f
	lsl r0, r0, #0x18
	bic r1, r2
	lsr r2, r0, #0x18
	mov r0, #0x7f
	and r0, r2
	orr r0, r1
	strb r0, [r6, r5]
	ldr r0, [r4, #4]
	mov r1, #0xb0
	mov r2, #0
	bl GetMonData
	cmp r0, #1
	ldrb r1, [r6, r5]
	bne _0221D278
	mov r0, #0x80
	bic r1, r0
	strb r1, [r6, r5]
	b _0221D27E
_0221D278:
	mov r0, #0x80
	orr r0, r1
	strb r0, [r6, r5]
_0221D27E:
	ldr r0, [sp]
	add r4, r0, r5
	add r6, r0, #0
	ldr r0, [r4, #4]
	add r6, #0x1b
	bl GetMonGender
	ldrb r1, [r6, r5]
	mov r2, #7
	bic r1, r2
	mov r2, #7
	and r0, r2
	orr r0, r1
	strb r0, [r6, r5]
	ldr r0, [r4, #4]
	bl Pokemon_GetStatusIconId
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	lsl r0, r0, #0x1c
	ldrb r1, [r6, r5]
	mov r2, #0x78
	lsr r0, r0, #0x19
	bic r1, r2
	orr r0, r1
	strb r0, [r6, r5]
	ldr r0, [r4, #4]
	mov r1, #0x4c
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	lsl r0, r0, #0x1f
	ldrb r1, [r6, r5]
	mov r2, #0x80
	lsr r0, r0, #0x18
	bic r1, r2
	orr r0, r1
	strb r0, [r6, r5]
	ldr r0, [r4, #4]
	mov r1, #0xa
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0x1c]
	ldr r0, [r4, #4]
	mov r1, #6
	mov r2, #0
	bl GetMonData
	strh r0, [r4, #0x1e]
	ldr r0, [r4, #4]
	mov r1, #8
	mov r2, #0
	bl GetMonData
	ldr r6, [sp]
	str r0, [r4, #0x20]
	add r6, #0x1a
	ldrb r1, [r6, r5]
	ldrh r0, [r4, #8]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x19
	bl GetMonExpBySpeciesAndLevel
	str r0, [r4, #0x24]
	ldrb r0, [r6, r5]
	lsl r0, r0, #0x19
	lsr r1, r0, #0x19
	cmp r1, #0x64
	bne _0221D316
	ldr r0, [sp]
	add r4, r0, r5
	ldr r0, [r4, #0x24]
	b _0221D322
_0221D316:
	ldr r0, [sp]
	add r1, r1, #1
	add r4, r0, r5
	ldrh r0, [r4, #8]
	bl GetMonExpBySpeciesAndLevel
_0221D322:
	str r0, [r4, #0x28]
	ldr r0, [r4, #4]
	mov r1, #0x13
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r1, #0x2c
	strb r0, [r1]
	ldr r0, [r4, #4]
	mov r1, #0x14
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r1, #0x2d
	strb r0, [r1]
	ldr r0, [r4, #4]
	mov r1, #0x15
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r1, #0x2e
	strb r0, [r1]
	ldr r0, [r4, #4]
	mov r1, #0x16
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r1, #0x2f
	strb r0, [r1]
	ldr r0, [r4, #4]
	mov r1, #0x17
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r1, #0x30
	strb r0, [r1]
	ldr r0, [r4, #4]
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r1, #0x31
	strb r0, [r1]
	ldr r0, [r4, #4]
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r4, #0x32
	strb r0, [r4]
	ldr r1, [sp]
	ldr r0, [sp, #4]
	add r1, #0x34
	add r7, r1, r0
	ldr r1, [sp]
	mov r4, #0
	add r6, r1, r0
_0221D3A0:
	lsl r0, r4, #3
	add r1, r4, #0
	str r0, [sp, #0xc]
	add r5, r7, r0
	ldr r0, [r6, #4]
	add r1, #0x36
	mov r2, #0
	bl GetMonData
	ldr r1, [sp, #0xc]
	strh r0, [r7, r1]
	add r0, r1, #0
	ldrh r0, [r7, r0]
	cmp r0, #0
	beq _0221D40C
	add r1, r4, #0
	ldr r0, [r6, #4]
	add r1, #0x3a
	mov r2, #0
	bl GetMonData
	strb r0, [r5, #2]
	add r1, r4, #0
	ldr r0, [r6, #4]
	add r1, #0x3e
	mov r2, #0
	bl GetMonData
	strb r0, [r5, #3]
	ldrh r0, [r5]
	ldrb r1, [r5, #3]
	bl GetMoveMaxPP
	strb r0, [r5, #3]
	ldrh r0, [r5]
	mov r1, #3
	bl GetMoveAttr
	strb r0, [r5, #4]
	ldrh r0, [r5]
	mov r1, #1
	bl GetMoveAttr
	strb r0, [r5, #5]
	ldrh r0, [r5]
	mov r1, #4
	bl GetMoveAttr
	strb r0, [r5, #6]
	ldrh r0, [r5]
	mov r1, #2
	bl GetMoveAttr
	strb r0, [r5, #7]
_0221D40C:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #4
	blo _0221D3A0
_0221D416:
	ldr r0, [sp, #8]
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	ldr r0, [sp]
	ldr r0, [r0]
	ldr r0, [r0]
	bl Party_GetCount
	ldr r1, [sp, #8]
	cmp r1, r0
	bge _0221D432
	b _0221D19E
_0221D432:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_0221D184

	thumb_func_start ov08_0221D438
ov08_0221D438: ; 0x0221D438
	push {r3, r4, r5, lr}
	ldr r1, _0221D4A8 ; =ov08_02224F1C
	add r4, r0, #0
	bl ov08_0221D5D0
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	bne _0221D484
	ldr r0, _0221D4AC ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224C94
	add r5, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	bne _0221D462
	mov r5, #6
	b _0221D46C
_0221D462:
	add r0, r0, #1
	cmp r5, r0
	bne _0221D46C
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221D46C:
	cmp r5, #6
	beq _0221D47C
	add r0, r4, #0
	add r1, r5, #0
	bl ov08_0221D5DC
	cmp r0, #0
	beq _0221D4A2
_0221D47C:
	ldr r0, [r4]
	strb r5, [r0, #0x11]
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221D484:
	cmp r5, #6
	beq _0221D494
	add r0, r4, #0
	add r1, r5, #0
	bl ov08_0221D5DC
	cmp r0, #0
	beq _0221D4A2
_0221D494:
	ldr r0, [r4]
	strb r5, [r0, #0x11]
	add r0, r4, #0
	bl ov08_022217C8
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221D4A2:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0221D4A8: .word ov08_02224F1C
_0221D4AC: .word 0x00002088
	thumb_func_end ov08_0221D438

	thumb_func_start ov08_0221D4B0
ov08_0221D4B0: ; 0x0221D4B0
	push {r3, r4, r5, lr}
	ldr r1, _0221D4F0 ; =ov08_02224E54
	add r5, r0, #0
	bl ov08_0221D5D0
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	bne _0221D4E4
	ldr r0, _0221D4F4 ; =0x00002088
	ldr r0, [r5, r0]
	bl ov08_02224C94
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _0221D4DA
	mov r4, #3
	b _0221D4EA
_0221D4DA:
	add r0, r0, #1
	cmp r4, r0
	bne _0221D4EA
	mov r0, #0xff
	pop {r3, r4, r5, pc}
_0221D4E4:
	add r0, r5, #0
	bl ov08_022217C8
_0221D4EA:
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D4F0: .word ov08_02224E54
_0221D4F4: .word 0x00002088
	thumb_func_end ov08_0221D4B0

	thumb_func_start ov08_0221D4F8
ov08_0221D4F8: ; 0x0221D4F8
	push {r3, r4, r5, lr}
	ldr r1, _0221D538 ; =ov08_02224E68
	add r5, r0, #0
	bl ov08_0221D5D0
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	bne _0221D52C
	ldr r0, _0221D53C ; =0x00002088
	ldr r0, [r5, r0]
	bl ov08_02224C94
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _0221D522
	mov r4, #3
	b _0221D532
_0221D522:
	add r0, r0, #1
	cmp r4, r0
	bne _0221D532
	mov r0, #0xff
	pop {r3, r4, r5, pc}
_0221D52C:
	add r0, r5, #0
	bl ov08_022217C8
_0221D532:
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D538: .word ov08_02224E68
_0221D53C: .word 0x00002088
	thumb_func_end ov08_0221D4F8

	thumb_func_start ov08_0221D540
ov08_0221D540: ; 0x0221D540
	push {r3, r4, r5, lr}
	ldr r1, _0221D580 ; =ov08_02224F5C
	add r5, r0, #0
	bl ov08_0221D5D0
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	bne _0221D574
	ldr r0, _0221D584 ; =0x00002088
	ldr r0, [r5, r0]
	bl ov08_02224C94
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _0221D56A
	mov r4, #7
	b _0221D57A
_0221D56A:
	add r0, r0, #1
	cmp r4, r0
	bne _0221D57A
	mov r0, #0xff
	pop {r3, r4, r5, pc}
_0221D574:
	add r0, r5, #0
	bl ov08_022217C8
_0221D57A:
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D580: .word ov08_02224F5C
_0221D584: .word 0x00002088
	thumb_func_end ov08_0221D540

	thumb_func_start ov08_0221D588
ov08_0221D588: ; 0x0221D588
	push {r3, r4, r5, lr}
	ldr r1, _0221D5C8 ; =ov08_02224E7C
	add r5, r0, #0
	bl ov08_0221D5D0
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	bne _0221D5BC
	ldr r0, _0221D5CC ; =0x00002088
	ldr r0, [r5, r0]
	bl ov08_02224C94
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _0221D5B2
	mov r4, #4
	b _0221D5C2
_0221D5B2:
	add r0, r0, #1
	cmp r4, r0
	bne _0221D5C2
	mov r0, #0xff
	pop {r3, r4, r5, pc}
_0221D5BC:
	add r0, r5, #0
	bl ov08_022217C8
_0221D5C2:
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D5C8: .word ov08_02224E7C
_0221D5CC: .word 0x00002088
	thumb_func_end ov08_0221D588

	thumb_func_start ov08_0221D5D0
ov08_0221D5D0: ; 0x0221D5D0
	ldr r3, _0221D5D8 ; =TouchscreenHitbox_FindRectAtTouchNew
	add r0, r1, #0
	bx r3
	nop
_0221D5D8: .word TouchscreenHitbox_FindRectAtTouchNew
	thumb_func_end ov08_0221D5D0

	thumb_func_start ov08_0221D5DC
ov08_0221D5DC: ; 0x0221D5DC
	push {r3, r4, r5, lr}
	add r4, r1, #0
	mov r1, #0x50
	add r5, r0, #0
	mul r1, r4
	add r1, r5, r1
	ldrh r1, [r1, #8]
	cmp r1, #0
	bne _0221D5F2
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221D5F2:
	cmp r4, #0
	beq _0221D60C
	bl ov08_0221DAE4
	cmp r0, #0
	bne _0221D608
	add r0, r5, #0
	bl ov08_0221DB04
	cmp r0, #0
	beq _0221D610
_0221D608:
	cmp r4, #1
	bne _0221D610
_0221D60C:
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221D610:
	mov r0, #2
	pop {r3, r4, r5, pc}
	thumb_func_end ov08_0221D5DC

	thumb_func_start ov08_0221D614
ov08_0221D614: ; 0x0221D614
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r4, r1, #0
	add r5, r0, #0
	add r7, r2, #0
	add r6, r4, #0
	bl ov08_0221DB04
	cmp r0, #1
	bne _0221D68C
	ldr r2, _0221D6C8 ; =ov08_02224E2C
	add r1, sp, #0
	ldrb r3, [r2]
	add r0, sp, #0
	mov r4, #0
	strb r3, [r1]
	ldrb r3, [r2, #1]
	strb r3, [r1, #1]
	ldrb r3, [r2, #2]
	strb r3, [r1, #2]
	ldrb r3, [r2, #3]
	strb r3, [r1, #3]
	ldrb r3, [r2, #4]
	ldrb r2, [r2, #5]
	strb r3, [r1, #4]
	strb r2, [r1, #5]
_0221D648:
	ldrb r1, [r0]
	cmp r6, r1
	beq _0221D656
	add r4, r4, #1
	add r0, r0, #1
	cmp r4, #6
	blt _0221D648
_0221D656:
	add r4, r4, r7
	bpl _0221D65E
	mov r4, #5
	b _0221D664
_0221D65E:
	cmp r4, #6
	blt _0221D664
	mov r4, #0
_0221D664:
	add r0, sp, #0
	ldrb r1, [r0, r4]
	cmp r6, r1
	beq _0221D6C0
	add r0, r5, #0
	bl ov08_0221D5DC
	cmp r0, #0
	beq _0221D656
	add r0, sp, #0
	ldrb r0, [r0, r4]
	mov r1, #0x50
	mul r1, r0
	add r1, r5, r1
	ldrb r1, [r1, #0x1b]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	bne _0221D656
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_0221D68C:
	add r4, r4, r7
	bpl _0221D694
	mov r4, #5
	b _0221D69A
_0221D694:
	cmp r4, #6
	blt _0221D69A
	mov r4, #0
_0221D69A:
	cmp r6, r4
	beq _0221D6C0
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_0221D5DC
	cmp r0, #0
	beq _0221D68C
	mov r0, #0x50
	mul r0, r4
	add r0, r5, r0
	ldrb r0, [r0, #0x1b]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _0221D68C
	lsl r0, r4, #0x18
	add sp, #8
	lsr r0, r0, #0x18
	pop {r3, r4, r5, r6, r7, pc}
_0221D6C0:
	mov r0, #0xff
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221D6C8: .word ov08_02224E2C
	thumb_func_end ov08_0221D614

	thumb_func_start ov08_0221D6CC
ov08_0221D6CC: ; 0x0221D6CC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	cmp r1, #2
	bne _0221D74A
	ldr r0, [r6]
	add r2, r6, #4
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r0, r2, r0
	ldrb r1, [r0, #0x16]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x19
	cmp r1, #0x64
	bhs _0221D6F6
	ldr r2, [r0, #0x20]
	ldr r1, [r0, #0x24]
	ldr r0, [r0, #0x1c]
	sub r1, r1, r2
	sub r0, r0, r2
	b _0221D6FA
_0221D6F6:
	mov r1, #0
	add r0, r1, #0
_0221D6FA:
	mov r2, #0x40
	bl CalculateHpBarPixelsLength
	add r4, r0, #0
	mov r5, #0
	mov r7, #0x1e
_0221D706:
	cmp r4, #8
	blo _0221D70E
	add r1, r7, #0
	b _0221D716
_0221D70E:
	add r0, r4, #0
	add r0, #0x16
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
_0221D716:
	add r2, r5, #0
	add r2, #0xa
	lsl r2, r2, #0x10
	add r0, r6, #0
	lsr r2, r2, #0x10
	mov r3, #8
	bl ov08_0221D74C
	cmp r4, #8
	bhs _0221D72E
	mov r4, #0
	b _0221D734
_0221D72E:
	sub r4, #8
	lsl r0, r4, #0x18
	lsr r4, r0, #0x18
_0221D734:
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	cmp r5, #8
	blo _0221D706
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r1, #7
	bl ScheduleBgTilemapBufferTransfer
_0221D74A:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov08_0221D6CC

	thumb_func_start ov08_0221D74C
ov08_0221D74C: ; 0x0221D74C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r1, #0
	lsl r1, r3, #0x18
	lsr r1, r1, #0x18
	str r1, [sp]
	mov r1, #1
	str r1, [sp, #4]
	add r4, r2, #0
	str r1, [sp, #8]
	mov r1, #0x10
	str r1, [sp, #0xc]
	mov r1, #0x79
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	lsl r3, r4, #0x18
	mov r1, #7
	add r2, r5, #0
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov08_0221D74C

	thumb_func_start ov08_0221D77C
ov08_0221D77C: ; 0x0221D77C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0xe
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	lsl r6, r2, #1
	add r4, r1, #0
	str r0, [sp, #0xc]
	mov r0, #0x79
	add r7, r6, #2
	lsl r0, r0, #2
	lsl r3, r7, #0x18
	ldr r0, [r5, r0]
	mov r1, #7
	add r2, r4, #0
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	mov r0, #0xe
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	mov r0, #0x79
	add r6, r6, #3
	lsl r0, r0, #2
	add r2, r4, #1
	lsl r2, r2, #0x10
	lsl r3, r6, #0x18
	ldr r0, [r5, r0]
	mov r1, #7
	lsr r2, r2, #0x10
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	mov r0, #0xf
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	mov r0, #0x79
	add r2, r4, #0
	lsl r0, r0, #2
	add r2, #0x20
	lsl r2, r2, #0x10
	lsl r3, r7, #0x18
	ldr r0, [r5, r0]
	mov r1, #7
	lsr r2, r2, #0x10
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	mov r0, #0xf
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	mov r0, #0x79
	lsl r0, r0, #2
	add r4, #0x21
	lsl r2, r4, #0x10
	lsl r3, r6, #0x18
	ldr r0, [r5, r0]
	mov r1, #7
	lsr r2, r2, #0x10
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov08_0221D77C

	thumb_func_start ov08_0221D81C
ov08_0221D81C: ; 0x0221D81C
	push {r4, r5, r6, lr}
	ldr r6, _0221D83C ; =0x00000125
	add r5, r0, #0
	mov r4, #0
_0221D824:
	lsl r2, r4, #0x18
	add r0, r5, #0
	add r1, r6, #0
	lsr r2, r2, #0x18
	bl ov08_0221D77C
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #6
	blo _0221D824
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221D83C: .word 0x00000125
	thumb_func_end ov08_0221D81C

	thumb_func_start ov08_0221D840
ov08_0221D840: ; 0x0221D840
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov08_0221D8B0
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #4
	mov r2, #0
	bl BgFillTilemapBufferAndSchedule
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #5
	mov r2, #0
	bl BgFillTilemapBufferAndSchedule
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02220C5C
	add r0, r5, #0
	bl ov08_0221DD28
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_0221DC3C
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_0221DD70
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_0221D6CC
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_0222171C
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_022221CC
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02222524
	ldr r0, _0221D8AC ; =0x0000207A
	strb r4, [r5, r0]
	pop {r3, r4, r5, pc}
	nop
_0221D8AC: .word 0x0000207A
	thumb_func_end ov08_0221D840

	thumb_func_start ov08_0221D8B0
ov08_0221D8B0: ; 0x0221D8B0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	ldr r2, _0221D918 ; =ov08_02224F80
	add r5, r0, #0
	lsl r0, r1, #3
	mov r4, #0
	add r6, r2, r0
_0221D8BE:
	ldr r2, [r5]
	ldr r1, [r6]
	ldr r2, [r2, #0xc]
	mov r0, #0x47
	bl AllocAndReadWholeNarcMemberByIdPair
	add r1, sp, #0xc
	add r7, r0, #0
	bl NNS_G2dGetUnpackedScreenData
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x79
	lsl r0, r0, #2
	add r1, r4, #6
	ldr r2, [sp, #0xc]
	lsl r1, r1, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	add r2, #0xc
	mov r3, #0
	bl LoadRectToBgTilemapRect
	mov r0, #0x79
	lsl r0, r0, #2
	add r1, r4, #6
	lsl r1, r1, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	bl ScheduleBgTilemapBufferTransfer
	add r0, r7, #0
	bl Heap_Free
	add r4, r4, #1
	add r6, r6, #4
	cmp r4, #2
	blo _0221D8BE
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221D918: .word ov08_02224F80
	thumb_func_end ov08_0221D8B0
