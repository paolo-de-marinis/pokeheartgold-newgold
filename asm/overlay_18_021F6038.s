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

.public ov18_021F10E8
.public ov18_021F1104
.public ov18_021F1160
.public ov18_021F118C
.public ov18_021F11C0
.public ov18_021F11EC
.public ov18_021F121C
.public ov18_021F1294
.public ov18_021F12C8
.public ov18_021F1324
.public ov18_021F13DC
.public ov18_021F1424
.public ov18_021F14FC
.public ov18_021F1534
.public ov18_021F17FC
.public ov18_021F18E0
.public ov18_021F193C
.public ov18_021F19EC
.public ov18_021F1A30
.public ov18_021F1A7C
.public ov18_021F1CB4
.public ov18_021F1D58
.public ov18_021F1D98
.public ov18_021F1E70
.public ov18_021F1F74
.public ov18_021F1FDC
.public ov18_021F2270
.public ov18_021F2308
.public ov18_021F2348
.public ov18_021F23E4
.public ov18_021F2424
.public ov18_021F2648
.public ov18_021F26E4
.public ov18_021F2724
.public ov18_021F281C
.public ov18_021F2AC0
.public ov18_021F8CCC
.public ov18_021F8F10
.public ov18_021F8FA0
.public ov18_021F91F0
.public ov18_021F95CC
.public ov18_021FA304
.public ov18_021FA310
.public ov18_021FA338
.public ov18_021FA348
.public ov18_021FA35A
.public ov18_021FA3B0
.public ov18_021FA484
.public ov18_021FA4B8
.public ov18_021FA4EC
.public ov18_021FA520
.public ov18_021FA554
.public ov18_021FA588
.public ov18_021FA5CC
.public ov18_021FA610
.public ov18_021FA7B0
.public ov18_021FAB58
.public ov18_021FAB8C
.public ov18_021FAC28
.public ov18_021FB004
.public ov18_021FB54C
.public ov18_021FB580
.public ov18_021FB5B4
.public ov18_021FB618
.public ov18_021FB61C
.public ov18_021FB620
.public ov18_021FB628
.public ov18_021FB630
.public ov18_021FB638
.public ov18_021FB648
.public ov18_021FB658
.public ov18_021FB668
.public ov18_021FB678
.public ov18_021FB688
.public ov18_021FB698
.public ov18_021FB6A8
.public ov18_021FB6B8
.public ov18_021FB6C8
.public ov18_021FB6DC
.public ov18_021FB6F0
.public ov18_021FB704
.public ov18_021FB718
.public ov18_021FB72C
.public ov18_021FB744
.public ov18_021FB760
.public ov18_021FB780
.public ov18_021FB7A0
.public ov18_021FB7C0
.public ov18_021FB7E0
.public ov18_021FB804
.public ov18_021FB828
.public ov18_021FB84C
.public ov18_021FB878
.public ov18_021FB8A4
.public ov18_021FB8D4
.public ov18_021FB904
.public ov18_021FB934
.public ov18_021FB968
.public ov18_021FB9A8
.public ov18_021FB9F0
.public ov18_021FBA40
.public ov18_021FBA94
.public ov18_021FBB0C
.public ov18_021FBB94
.public ov18_021FBC34
.public ov18_021FBD1C
.public ov18_021FBD28
.public ov18_021FBD3C
.public ov18_021FBD60
.public ov18_021FBD7C
.public ov18_021FBD98

.public ov18_021F8950

	.text

	thumb_func_start ov18_021F6038
ov18_021F6038: ; 0x021F6038
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r4, #0
	mov r6, #0xe
_021F6040:
	ldr r0, _021F6094 ; =0x000018C5
	ldrsb r0, [r5, r0]
	add r0, r0, r4
	sub r7, r0, #2
	ldr r0, _021F6098 ; =0x000018C4
	ldrsb r0, [r5, r0]
	cmp r7, r0
	blo _021F605E
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0xe
	mov r2, #0
	bl ov18_021F11C0
	b _021F6076
_021F605E:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0xe
	mov r2, #1
	bl ov18_021F11C0
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0xe
	add r2, r7, #0
	bl ov18_021F5FFC
_021F6076:
	mov r0, #0
	add r1, r4, #0
	lsl r3, r6, #0x10
	str r0, [sp]
	add r0, r5, #0
	add r1, #0xe
	mov r2, #0x30
	asr r3, r3, #0x10
	bl ov18_021F1294
	add r4, r4, #1
	add r6, #0x18
	cmp r4, #6
	blo _021F6040
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F6094: .word 0x000018C5
_021F6098: .word 0x000018C4
	thumb_func_end ov18_021F6038

	thumb_func_start ov18_021F609C
ov18_021F609C: ; 0x021F609C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	mov r4, #0
	add r5, r0, #0
	str r1, [sp, #4]
	add r6, r4, #0
	add r7, sp, #8
_021F60AA:
	add r1, r4, #0
	add r2, sp, #8
	add r0, r5, #0
	add r1, #0xe
	add r2, #2
	add r3, sp, #8
	str r6, [sp]
	bl ov18_021F12C8
	mov r0, #0
	ldrsh r1, [r7, r0]
	sub r0, #0xa
	cmp r1, r0
	beq _021F60D0
	cmp r1, #0x86
	beq _021F60D0
	add r4, r4, #1
	cmp r4, #6
	blo _021F60AA
_021F60D0:
	ldr r0, [sp, #4]
	cmp r0, #0
	bge _021F6126
	mov r0, #0
	add r1, r4, #0
	str r0, [sp]
	add r0, r5, #0
	add r1, #0xe
	mov r2, #0x30
	mov r3, #0x86
	bl ov18_021F1294
	ldr r0, _021F6174 ; =0x000018C5
	ldrsb r1, [r5, r0]
	sub r0, r0, #1
	ldrsb r0, [r5, r0]
	add r1, r1, #2
	cmp r1, r0
	blt _021F6106
	add r4, #0xe
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021F6106:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0xe
	mov r2, #1
	bl ov18_021F11C0
	ldr r2, _021F6174 ; =0x000018C5
	add r4, #0xe
	ldrsb r2, [r5, r2]
	add r0, r5, #0
	add r1, r4, #0
	add r2, r2, #2
	bl ov18_021F5FFC
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021F6126:
	mov r2, #0x30
	mov r0, #0
	add r1, r4, #0
	add r3, r2, #0
	str r0, [sp]
	add r0, r5, #0
	add r1, #0xe
	sub r3, #0x3a
	bl ov18_021F1294
	ldr r0, _021F6174 ; =0x000018C5
	ldrsb r0, [r5, r0]
	sub r0, r0, #2
	bpl _021F6152
	add r4, #0xe
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021F6152:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0xe
	mov r2, #1
	bl ov18_021F11C0
	ldr r2, _021F6174 ; =0x000018C5
	add r4, #0xe
	ldrsb r2, [r5, r2]
	add r0, r5, #0
	add r1, r4, #0
	sub r2, r2, #2
	bl ov18_021F5FFC
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021F6174: .word 0x000018C5
	thumb_func_end ov18_021F609C

	thumb_func_start ov18_021F6178
ov18_021F6178: ; 0x021F6178
	push {r3, r4, r5, r6, r7, lr}
	mov r4, #0
	add r5, r0, #0
	add r6, r1, #0
	add r7, r4, #0
_021F6182:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #0xe
	add r2, r7, #0
	add r3, r6, #0
	str r7, [sp]
	bl ov18_021F121C
	add r4, r4, #1
	cmp r4, #6
	blo _021F6182
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F6178

	thumb_func_start ov18_021F619C
ov18_021F619C: ; 0x021F619C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r7, r2, #0
	add r4, r3, #0
	cmp r5, #0
	bne _021F61B4
	add r1, r4, #0
	mov r2, #7
	bl ov18_021F118C
	b _021F61BC
_021F61B4:
	add r1, r4, #0
	mov r2, #5
	bl ov18_021F118C
_021F61BC:
	sub r0, r7, #1
	cmp r5, r0
	bne _021F61CE
	add r0, r6, #0
	add r1, r4, #1
	mov r2, #0xa
	bl ov18_021F118C
	pop {r3, r4, r5, r6, r7, pc}
_021F61CE:
	add r0, r6, #0
	add r1, r4, #1
	mov r2, #8
	bl ov18_021F118C
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F619C

	thumb_func_start ov18_021F61DC
ov18_021F61DC: ; 0x021F61DC
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r1, r2, #0
	add r2, r3, #0
	ldr r3, [sp, #0x10]
	add r5, r0, #0
	bl ov18_021F61F8
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F61DC

	thumb_func_start ov18_021F61F8
ov18_021F61F8: ; 0x021F61F8
	push {r3, r4}
	mov r0, #0
	cmp r3, #0
	bls _021F620E
_021F6200:
	ldrh r4, [r2]
	cmp r1, r4
	ble _021F620E
	add r0, r0, #1
	add r2, r2, #2
	cmp r0, r3
	blo _021F6200
_021F620E:
	add r0, #0xe
	pop {r3, r4}
	bx lr
	thumb_func_end ov18_021F61F8

	thumb_func_start ov18_021F6214
ov18_021F6214: ; 0x021F6214
	push {r4, lr}
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r4, r2, #0
	bl ManagedSprite_GetActiveAnim
	add r0, r4, r0
	sub r0, #0xe
	ldrb r0, [r0]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F6214

	thumb_func_start ov18_021F6230
ov18_021F6230: ; 0x021F6230
	push {r4, lr}
	add r4, r3, #0
	bl ov18_021F6214
	lsr r1, r0, #1
	ldr r0, [sp, #8]
	lsr r0, r0, #1
	sub r0, r4, r0
	add r0, r1, r0
	pop {r4, pc}
	thumb_func_end ov18_021F6230

	thumb_func_start ov18_021F6244
ov18_021F6244: ; 0x021F6244
	push {r4, lr}
	add r4, r3, #0
	bl ov18_021F6214
	ldr r1, [sp, #8]
	lsr r0, r0, #1
	lsr r1, r1, #1
	add r1, r4, r1
	sub r0, r1, r0
	pop {r4, pc}
	thumb_func_end ov18_021F6244

	thumb_func_start ov18_021F6258
ov18_021F6258: ; 0x021F6258
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r6, r0, #0
	ldr r0, _021F62AC ; =0x00000684
	add r5, r1, #0
	add r1, sp, #0
	add r4, r2, #0
	ldr r0, [r6, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r2, _021F62B0 ; =ov18_021FA310
	add r0, r6, #0
	mov r1, #5
	bl ov18_021F6214
	add r2, sp, #0
	mov r1, #2
	ldrsh r3, [r2, r1]
	add r1, r3, #0
	sub r1, #0xb
	cmp r5, r1
	blo _021F62A6
	add r3, #0xb
	cmp r5, r3
	bhi _021F62A6
	lsr r3, r0, #1
	mov r0, #0
	ldrsh r1, [r2, r0]
	sub r0, r1, r3
	cmp r4, r0
	blo _021F62A6
	add r0, r1, r3
	cmp r4, r0
	bhi _021F62A6
	add sp, #4
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_021F62A6:
	mov r0, #0
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021F62AC: .word 0x00000684
_021F62B0: .word ov18_021FA310
	thumb_func_end ov18_021F6258

	thumb_func_start ov18_021F62B4
ov18_021F62B4: ; 0x021F62B4
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r6, r0, #0
	ldr r0, _021F6308 ; =0x00000684
	add r5, r1, #0
	add r1, sp, #0
	add r4, r2, #0
	ldr r0, [r6, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r2, _021F630C ; =ov18_021FA304
	add r0, r6, #0
	mov r1, #5
	bl ov18_021F6214
	add r2, sp, #0
	mov r1, #2
	ldrsh r3, [r2, r1]
	add r1, r3, #0
	sub r1, #0xb
	cmp r5, r1
	blo _021F6302
	add r3, #0xb
	cmp r5, r3
	bhi _021F6302
	lsr r3, r0, #1
	mov r0, #0
	ldrsh r1, [r2, r0]
	sub r0, r1, r3
	cmp r4, r0
	blo _021F6302
	add r0, r1, r3
	cmp r4, r0
	bhi _021F6302
	add sp, #4
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_021F6302:
	mov r0, #0
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021F6308: .word 0x00000684
_021F630C: .word ov18_021FA304
	thumb_func_end ov18_021F62B4

	thumb_func_start ov18_021F6310
ov18_021F6310: ; 0x021F6310
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, _021F63CC ; =0x00000684
	add r1, sp, #4
	add r6, r2, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F63D0 ; =ov18_021FA310
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x40
	bl ov18_021F6230
	cmp r6, r0
	bhs _021F633C
	add r6, r0, #0
_021F633C:
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F63D0 ; =ov18_021FA310
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x40
	bl ov18_021F6244
	cmp r6, r0
	bls _021F6352
	add r6, r0, #0
_021F6352:
	ldr r0, _021F63CC ; =0x00000684
	add r2, sp, #4
	mov r1, #2
	ldrsh r1, [r2, r1]
	lsl r2, r6, #0x10
	ldr r0, [r5, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F63D0 ; =ov18_021FA310
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x40
	bl ov18_021F6230
	add r7, r0, #0
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F63D0 ; =ov18_021FA310
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x40
	bl ov18_021F6244
	sub r1, r0, r7
	ldr r0, _021F63D4 ; =0x000018C4
	ldrsb r0, [r5, r0]
	sub r4, r0, #1
	lsl r0, r1, #8
	add r1, r4, #0
	bl _u32_div_f
	sub r1, r6, r7
	mov r3, #0
	lsl r2, r1, #8
	add r6, r3, #0
	add r7, r3, #0
_021F63A0:
	cmp r2, r6
	blo _021F63BA
	add r1, r7, r0
	cmp r2, r1
	bhs _021F63BA
	ldr r0, _021F63D8 ; =0x000018C5
	ldrsb r1, [r5, r0]
	cmp r1, r3
	beq _021F63C4
	add sp, #8
	strb r3, [r5, r0]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021F63BA:
	add r3, r3, #1
	add r6, r6, r0
	add r7, r7, r0
	cmp r3, r4
	bls _021F63A0
_021F63C4:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F63CC: .word 0x00000684
_021F63D0: .word ov18_021FA310
_021F63D4: .word 0x000018C4
_021F63D8: .word 0x000018C5
	thumb_func_end ov18_021F6310

	thumb_func_start ov18_021F63DC
ov18_021F63DC: ; 0x021F63DC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, _021F6498 ; =0x00000684
	add r1, sp, #4
	add r6, r2, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F649C ; =ov18_021FA304
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x60
	bl ov18_021F6230
	cmp r6, r0
	bhs _021F6408
	add r6, r0, #0
_021F6408:
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F649C ; =ov18_021FA304
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x60
	bl ov18_021F6244
	cmp r6, r0
	bls _021F641E
	add r6, r0, #0
_021F641E:
	ldr r0, _021F6498 ; =0x00000684
	add r2, sp, #4
	mov r1, #2
	ldrsh r1, [r2, r1]
	lsl r2, r6, #0x10
	ldr r0, [r5, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F649C ; =ov18_021FA304
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x60
	bl ov18_021F6230
	add r7, r0, #0
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F649C ; =ov18_021FA304
	add r0, r5, #0
	mov r1, #5
	mov r3, #0x60
	bl ov18_021F6244
	sub r1, r0, r7
	mov r0, #0x19
	lsl r0, r0, #8
	ldr r0, [r5, r0]
	sub r4, r0, #1
	lsl r0, r1, #8
	add r1, r4, #0
	bl _u32_div_f
	sub r1, r6, r7
	mov r3, #0
	lsl r2, r1, #8
	add r6, r3, #0
	add r7, r3, #0
_021F646E:
	cmp r2, r6
	blo _021F6488
	add r1, r7, r0
	cmp r2, r1
	bhs _021F6488
	ldr r0, _021F64A0 ; =0x000018CA
	ldrsb r1, [r5, r0]
	cmp r1, r3
	beq _021F6492
	add sp, #8
	strb r3, [r5, r0]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021F6488:
	add r3, r3, #1
	add r6, r6, r0
	add r7, r7, r0
	cmp r3, r4
	bls _021F646E
_021F6492:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F6498: .word 0x00000684
_021F649C: .word ov18_021FA304
_021F64A0: .word 0x000018CA
	thumb_func_end ov18_021F63DC

	thumb_func_start ov18_021F64A4
ov18_021F64A4: ; 0x021F64A4
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r1, #0
	mov r1, #0x56
	str r1, [sp]
	ldr r2, _021F64EC ; =ov18_021FA310
	mov r1, #5
	mov r3, #0x40
	add r6, r0, #0
	bl ov18_021F6230
	add r4, r0, #0
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F64EC ; =ov18_021FA310
	add r0, r6, #0
	mov r1, #5
	mov r3, #0x40
	bl ov18_021F6244
	ldr r1, _021F64F0 ; =0x000018C4
	ldrsb r1, [r6, r1]
	sub r1, r1, #1
	cmp r5, r1
	beq _021F64E6
	sub r0, r0, r4
	lsl r0, r0, #8
	bl _u32_div_f
	add r1, r0, #0
	mul r1, r5
	lsr r0, r1, #8
	add r0, r4, r0
_021F64E6:
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	nop
_021F64EC: .word ov18_021FA310
_021F64F0: .word 0x000018C4
	thumb_func_end ov18_021F64A4

	thumb_func_start ov18_021F64F4
ov18_021F64F4: ; 0x021F64F4
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r1, #0
	mov r1, #0x56
	str r1, [sp]
	ldr r2, _021F653C ; =ov18_021FA304
	mov r1, #5
	mov r3, #0x60
	add r6, r0, #0
	bl ov18_021F6230
	add r4, r0, #0
	mov r0, #0x56
	str r0, [sp]
	ldr r2, _021F653C ; =ov18_021FA304
	add r0, r6, #0
	mov r1, #5
	mov r3, #0x60
	bl ov18_021F6244
	mov r1, #0x19
	lsl r1, r1, #8
	ldr r1, [r6, r1]
	sub r1, r1, #1
	cmp r5, r1
	beq _021F6538
	sub r0, r0, r4
	lsl r0, r0, #8
	bl _u32_div_f
	add r1, r0, #0
	mul r1, r5
	lsr r0, r1, #8
	add r0, r4, r0
_021F6538:
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021F653C: .word ov18_021FA304
	thumb_func_end ov18_021F64F4

	thumb_func_start ov18_021F6540
ov18_021F6540: ; 0x021F6540
	push {r3, r4, r5, lr}
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r5, r2, #0
	add r1, #2
	add r2, sp, #0
	add r4, r3, #0
	bl ManagedSprite_GetPositionXY
	add r1, sp, #0
	mov r0, #0
	ldrsh r0, [r1, r0]
	cmp r5, r0
	blo _021F656E
	sub r0, r5, r0
	add r1, r4, #0
	bl _u32_div_f
	pop {r3, r4, r5, pc}
_021F656E:
	sub r0, r0, r5
	add r1, r4, #0
	bl _u32_div_f
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F6540

	thumb_func_start ov18_021F6578
ov18_021F6578: ; 0x021F6578
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r6, r2, #0
	mov r2, #0x67
	lsl r2, r2, #4
	add r5, r0, r2
	lsl r4, r1, #2
	add r1, sp, #0
	ldr r0, [r5, r4]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	mov r1, #2
	ldrsh r1, [r3, r1]
	add r2, r2, r6
	lsl r2, r2, #0x10
	ldr r0, [r5, r4]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov18_021F6578

	thumb_func_start ov18_021F65AC
ov18_021F65AC: ; 0x021F65AC
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _021F65E4 ; =0x00000684
	add r1, sp, #0
	ldr r0, [r4, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r1, _021F65E8 ; =0x000018C5
	add r0, r4, #0
	ldrsb r1, [r4, r1]
	bl ov18_021F64A4
	add r3, r0, #0
	ldr r0, _021F65E4 ; =0x00000684
	add r2, sp, #0
	mov r1, #2
	ldrsh r1, [r2, r1]
	lsl r2, r3, #0x10
	ldr r0, [r4, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add sp, #4
	pop {r3, r4, pc}
	nop
_021F65E4: .word 0x00000684
_021F65E8: .word 0x000018C5
	thumb_func_end ov18_021F65AC

	thumb_func_start ov18_021F65EC
ov18_021F65EC: ; 0x021F65EC
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _021F6624 ; =0x00000684
	add r1, sp, #0
	ldr r0, [r4, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r1, _021F6628 ; =0x000018CA
	add r0, r4, #0
	ldrsb r1, [r4, r1]
	bl ov18_021F64F4
	add r3, r0, #0
	ldr r0, _021F6624 ; =0x00000684
	add r2, sp, #0
	mov r1, #2
	ldrsh r1, [r2, r1]
	lsl r2, r3, #0x10
	ldr r0, [r4, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add sp, #4
	pop {r3, r4, pc}
	nop
_021F6624: .word 0x00000684
_021F6628: .word 0x000018CA
	thumb_func_end ov18_021F65EC

	thumb_func_start ov18_021F662C
ov18_021F662C: ; 0x021F662C
	push {r4, lr}
	ldr r1, _021F6680 ; =0x000018C5
	add r4, r0, #0
	ldrsb r1, [r4, r1]
	mov r2, #1
	bl ov18_021F5EFC
	add r0, r4, #0
	bl ov18_021F6038
	add r0, r4, #0
	bl ov18_021F65AC
	ldr r2, _021F6680 ; =0x000018C5
	add r0, r4, #0
	ldrsb r1, [r4, r2]
	sub r2, r2, #1
	ldrsb r2, [r4, r2]
	mov r3, #6
	bl ov18_021F619C
	add r0, r4, #0
	mov r1, #5
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #6
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #7
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #8
	mov r2, #1
	bl ov18_021F11C0
	pop {r4, pc}
	.balign 4, 0
_021F6680: .word 0x000018C5
	thumb_func_end ov18_021F662C

	thumb_func_start ov18_021F6684
ov18_021F6684: ; 0x021F6684
	push {r4, lr}
	add r4, r0, #0
	mov r1, #5
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #6
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #7
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #8
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0x10
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0x11
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0x12
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0x13
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #3
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #4
	mov r2, #0
	bl ov18_021F11C0
	pop {r4, pc}
	thumb_func_end ov18_021F6684

	thumb_func_start ov18_021F6714
ov18_021F6714: ; 0x021F6714
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _021F67C4 ; =0x000018C4
	add r4, r0, #0
	ldrsb r1, [r4, r1]
	cmp r1, #3
	blt _021F6752
	mov r1, #9
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xd
	mov r2, #1
	bl ov18_021F11C0
_021F6752:
	ldr r2, _021F67C8 ; =0x000018C5
	add r0, r4, #0
	ldrsb r2, [r4, r2]
	mov r1, #0xe
	bl ov18_021F6844
	ldr r2, _021F67CC ; =0x000018C6
	add r0, r4, #0
	ldrsb r2, [r4, r2]
	mov r1, #0xf
	bl ov18_021F6844
	mov r0, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0x40
	mov r3, #0x50
	bl ov18_021F1294
	mov r0, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0xc0
	mov r3, #0x50
	bl ov18_021F1294
	ldr r2, _021F67C8 ; =0x000018C5
	mov r1, #1
	ldrsb r2, [r4, r2]
	add r0, r4, #0
	add r3, r1, #0
	bl ov18_021F684C
	ldr r2, _021F67CC ; =0x000018C6
	add r0, r4, #0
	ldrsb r2, [r4, r2]
	mov r1, #2
	mov r3, #1
	bl ov18_021F684C
	add r0, r4, #0
	bl ov18_021F6990
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #1
	bl ov18_021F11C0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021F67C4: .word 0x000018C4
_021F67C8: .word 0x000018C5
_021F67CC: .word 0x000018C6
	thumb_func_end ov18_021F6714

	thumb_func_start ov18_021F67D0
ov18_021F67D0: ; 0x021F67D0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #9
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xd
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #3
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #4
	mov r2, #0
	bl ov18_021F11C0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F67D0
