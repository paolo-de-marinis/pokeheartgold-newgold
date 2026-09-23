#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start ov14_021F7308
ov14_021F7308: ; 0x021F7308
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #0x25
	blt _021F731C
	cmp r4, #0x2a
	bgt _021F731C
	ldr r1, [r5, #0x34]
	ldr r0, _021F733C ; =0x0000043C
	str r4, [r1, r0]
_021F731C:
	cmp r4, #0x2b
	beq _021F7338
	cmp r4, #0x2c
	beq _021F7338
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F7338:
	pop {r3, r4, r5, pc}
	nop
_021F733C: .word 0x0000043C
	thumb_func_end ov14_021F7308

	thumb_func_start ov14_021F7340
ov14_021F7340: ; 0x021F7340
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021F735E
	ldr r0, [r5, #0x34]
	mov r1, #0x2d
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
_021F735E:
	ldr r0, [r5, #0x34]
	mov r1, #0x2b
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	mov r1, #0x2c
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetAllEnabled
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7340

	thumb_func_start ov14_021F7388
ov14_021F7388: ; 0x021F7388
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F73D0
	cmp r4, #8
	blo _021F73E0
	cmp r4, #0xc
	bhi _021F73E0
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F73D0:
	cmp r4, #7
	beq _021F73DC
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F73E0
_021F73DC:
	mov r0, #0xd
	pop {r4, r5, r6, pc}
_021F73E0:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F7388

	thumb_func_start ov14_021F73E4
ov14_021F73E4: ; 0x021F73E4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F742E
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7418
	cmp r4, #8
	blt _021F742E
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F7414
	sub r4, #0x1e
	b _021F742E
_021F7414:
	mov r4, #0
	b _021F742E
_021F7418:
	cmp r4, #8
	bne _021F742C
	cmp r4, #9
	bne _021F742C
	cmp r4, #0xa
	bne _021F742C
	cmp r4, #0xb
	bne _021F742C
	cmp r4, #0xc
	beq _021F742E
_021F742C:
	mov r4, #8
_021F742E:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F73E4

	thumb_func_start ov14_021F7444
ov14_021F7444: ; 0x021F7444
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r6, r2, #0
	bl ov14_021E8544
	cmp r0, #1
	bne _021F747E
	cmp r4, #6
	bgt _021F7492
	cmp r6, #7
	blt _021F7492
	add r0, r5, #0
	bl ov14_021E76B8
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F74A8 ; =ov14_021EA180
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
_021F747E:
	cmp r4, #0xc
	bne _021F7492
	cmp r6, #7
	bne _021F7492
	ldr r0, [r5, #0x34]
	mov r1, #7
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r4, #7
_021F7492:
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	add r2, r6, #0
	bl ov14_021F7AC4
	ldr r0, [r5, #0x34]
	ldr r1, _021F74AC ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, r5, r6, pc}
	nop
_021F74A8: .word ov14_021EA180
_021F74AC: .word ov14_021E9F20
	thumb_func_end ov14_021F7444

	thumb_func_start ov14_021F74B0
ov14_021F74B0: ; 0x021F74B0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F74F4
	cmp r4, #0x24
	bne _021F7524
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F74F4:
	add r0, r4, #0
	sub r0, #0x21
	cmp r0, #1
	bhi _021F7514
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F7514:
	cmp r4, #0x23
	beq _021F7520
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F7524
_021F7520:
	mov r0, #0x25
	pop {r4, r5, r6, pc}
_021F7524:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F74B0

	thumb_func_start ov14_021F7528
ov14_021F7528: ; 0x021F7528
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F757E
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7578
	add r0, r4, #0
	sub r0, #0x1e
	cmp r0, #5
	bhi _021F756A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F755A: ; jump table
	.short _021F757E - _021F755A - 2 ; case 0
	.short _021F7566 - _021F755A - 2 ; case 1
	.short _021F7566 - _021F755A - 2 ; case 2
	.short _021F757E - _021F755A - 2 ; case 3
	.short _021F757E - _021F755A - 2 ; case 4
	.short _021F757E - _021F755A - 2 ; case 5
_021F7566:
	mov r4, #0x1e
	b _021F757E
_021F756A:
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F757E
	mov r4, #0
	b _021F757E
_021F7578:
	cmp r4, #0x24
	beq _021F757E
	mov r4, #0x24
_021F757E:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7528

	thumb_func_start ov14_021F7594
ov14_021F7594: ; 0x021F7594
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	ldr r1, _021F75A8 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, pc}
	.balign 4, 0
_021F75A8: .word ov14_021E9F20
	thumb_func_end ov14_021F7594

	thumb_func_start ov14_021F75AC
ov14_021F75AC: ; 0x021F75AC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F75AC

	thumb_func_start ov14_021F75C8
ov14_021F75C8: ; 0x021F75C8
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F760C
	cmp r4, #8
	bne _021F761C
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F760C:
	cmp r4, #7
	beq _021F7618
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F761C
_021F7618:
	mov r0, #9
	pop {r4, r5, r6, pc}
_021F761C:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F75C8

	thumb_func_start ov14_021F7620
ov14_021F7620: ; 0x021F7620
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F765A
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7654
	cmp r4, #8
	blt _021F765A
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F7650
	sub r4, #0x1e
	b _021F765A
_021F7650:
	mov r4, #0
	b _021F765A
_021F7654:
	cmp r4, #8
	beq _021F765A
	mov r4, #8
_021F765A:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7620

	thumb_func_start ov14_021F7670
ov14_021F7670: ; 0x021F7670
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	ldr r1, _021F7684 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, pc}
	.balign 4, 0
_021F7684: .word ov14_021E9F20
	thumb_func_end ov14_021F7670

	thumb_func_start ov14_021F7688
ov14_021F7688: ; 0x021F7688
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	sub r0, r4, #6
	cmp r0, #1
	bhi _021F76A8
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r4, r1, #0
	ldr r1, [r5, #0x34]
	ldr r0, _021F76FC ; =0x0000043C
	str r4, [r1, r0]
_021F76A8:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
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
	cmp r4, #0
	blt _021F76EE
	cmp r4, #5
	bgt _021F76EE
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
_021F76EE:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
	nop
_021F76FC: .word 0x0000043C
	thumb_func_end ov14_021F7688
