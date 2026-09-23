#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start ov14_021EB0E4
ov14_021EB0E4: ; 0x021EB0E4
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E6048
	ldr r0, [r4, #0x34]
	ldr r0, [r0]
	bl SysTask_Destroy
	add r0, r4, #0
	bl ov14_021F6B10
	add r0, r4, #0
	bl ov14_021E5EE8
	ldr r0, [r4, #0x34]
	bl ov14_021E7D7C
	ldr r0, [r4, #0x34]
	bl ov14_021F29AC
	add r0, r4, #0
	bl ov14_021F4F00
	add r0, r4, #0
	bl ov14_021E5DB8
	add r0, r4, #0
	bl ov14_021E5E94
	add r0, r4, #0
	bl ov14_021E5C00
	ldr r1, [r4, #0x34]
	ldr r0, _021EB164 ; =0x00000454
	ldr r0, [r1, r0]
	bl NARC_Delete
	mov r0, #0x45
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl NARC_Delete
	bl sub_02021238
	ldr r1, _021EB168 ; =0x04000050
	mov r0, #0
	strh r0, [r1]
	ldr r1, _021EB16C ; =0x04001050
	strh r0, [r1]
	bl GfGfx_EngineASetPlanes
	mov r0, #0
	bl GfGfx_EngineBSetPlanes
	ldr r0, [r4, #0x34]
	bl Heap_Free
	mov r0, #0xa
	bl Heap_Destroy
	ldr r0, [r4, #0x30]
	pop {r4, pc}
	nop
_021EB164: .word 0x00000454
_021EB168: .word 0x04000050
_021EB16C: .word 0x04001050
	thumb_func_end ov14_021EB0E4

	thumb_func_start ov14_021EB170
ov14_021EB170: ; 0x021EB170
	push {r4, lr}
	add r4, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EB186
	mov r0, #0x11
	ldr r1, [r4, #0x34]
	lsl r0, r0, #6
	ldr r0, [r1, r0]
	pop {r4, pc}
_021EB186:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EB170

	thumb_func_start ov14_021EB18C
ov14_021EB18C: ; 0x021EB18C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x18]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	bne _021EB1A0
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB1A0:
	mov r0, #3
	pop {r4, pc}
	thumb_func_end ov14_021EB18C

	thumb_func_start ov14_021EB1A4
ov14_021EB1A4: ; 0x021EB1A4
	ldr r3, [r0, #0x34]
	ldr r1, _021EB1BC ; =0x00000444
	ldr r2, [r3, r1]
	cmp r2, #0
	bne _021EB1B2
	ldr r0, [r0, #0x30]
	bx lr
_021EB1B2:
	sub r0, r2, #1
	str r0, [r3, r1]
	mov r0, #4
	bx lr
	nop
_021EB1BC: .word 0x00000444
	thumb_func_end ov14_021EB1A4

	thumb_func_start ov14_021EB1C0
ov14_021EB1C0: ; 0x021EB1C0
	push {r3, lr}
	ldr r1, [r0, #0x34]
	ldr r1, [r1, #4]
	cmp r1, #0
	bne _021EB1D6
	ldr r1, [r0, #0x30]
	lsl r2, r1, #2
	ldr r1, _021EB1DC ; =ov14_021F7D9C
	ldr r1, [r1, r2]
	blx r1
	pop {r3, pc}
_021EB1D6:
	mov r0, #5
	pop {r3, pc}
	nop
_021EB1DC: .word ov14_021F7D9C
	thumb_func_end ov14_021EB1C0

	thumb_func_start ov14_021EB1E0
ov14_021EB1E0: ; 0x021EB1E0
	push {r4, lr}
	add r4, r0, #0
	bl System_GetTouchNew
	cmp r0, #1
	bne _021EB1F6
	ldr r0, _021EB210 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB1F6:
	ldr r0, _021EB214 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _021EB20A
	ldr r0, _021EB210 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB20A:
	mov r0, #6
	pop {r4, pc}
	nop
_021EB210: .word 0x000005DD
_021EB214: .word gSystem
	thumb_func_end ov14_021EB1E0

	thumb_func_start ov14_021EB218
ov14_021EB218: ; 0x021EB218
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x34]
	ldr r0, _021EB26C ; =0x00000434
	ldr r0, [r1, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _021EB230
	cmp r0, #2
	beq _021EB24C
	b _021EB268
_021EB230:
	ldr r1, [r4, #0x34]
	ldr r0, _021EB26C ; =0x00000434
	ldr r0, [r1, r0]
	bl YesNoPrompt_Reset
	ldr r2, [r4, #0x34]
	ldr r1, _021EB270 ; =0x00000438
	add r0, r4, #0
	ldrh r1, [r2, r1]
	lsl r2, r1, #3
	ldr r1, _021EB274 ; =ov14_021F7D74
	ldr r1, [r1, r2]
	blx r1
	pop {r4, pc}
_021EB24C:
	ldr r1, [r4, #0x34]
	ldr r0, _021EB26C ; =0x00000434
	ldr r0, [r1, r0]
	bl YesNoPrompt_Reset
	ldr r2, [r4, #0x34]
	ldr r1, _021EB270 ; =0x00000438
	add r0, r4, #0
	ldrh r1, [r2, r1]
	lsl r2, r1, #3
	ldr r1, _021EB278 ; =ov14_021F7D78
	ldr r1, [r1, r2]
	blx r1
	pop {r4, pc}
_021EB268:
	mov r0, #7
	pop {r4, pc}
	.balign 4, 0
_021EB26C: .word 0x00000434
_021EB270: .word 0x00000438
_021EB274: .word ov14_021F7D74
_021EB278: .word ov14_021F7D78
	thumb_func_end ov14_021EB218

	thumb_func_start ov14_021EB27C
ov14_021EB27C: ; 0x021EB27C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E5F4C
	cmp r0, #0
	bne _021EB28C
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB28C:
	mov r0, #8
	pop {r4, pc}
	thumb_func_end ov14_021EB27C

	thumb_func_start ov14_021EB290
ov14_021EB290: ; 0x021EB290
	push {r3, lr}
	ldrb r2, [r0, #0x1e]
	mov r1, #0xc
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021EB2A4 ; =ov14_021F7D50
	ldr r1, [r1, r3]
	blx r1
	mov r0, #0xa
	pop {r3, pc}
	.balign 4, 0
_021EB2A4: .word ov14_021F7D50
	thumb_func_end ov14_021EB290

	thumb_func_start ov14_021EB2A8
ov14_021EB2A8: ; 0x021EB2A8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x14]
	bl OverlayManager_Run
	cmp r0, #0
	bne _021EB2BA
	mov r0, #0xa
	pop {r4, pc}
_021EB2BA:
	ldr r0, [r4, #0x14]
	bl OverlayManager_Delete
	ldrb r2, [r4, #0x1e]
	mov r1, #0xc
	add r0, r4, #0
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021EB2E4 ; =ov14_021F7D50 + 4
	ldr r1, [r1, r3]
	blx r1
	ldrb r1, [r4, #0x1e]
	mov r0, #0xc
	add r2, r1, #0
	mul r2, r0
	ldr r0, _021EB2E8 ; =ov14_021F7D50 + 8
	ldr r0, [r0, r2]
	str r0, [r4, #0x30]
	mov r0, #0
	pop {r4, pc}
	nop
_021EB2E4: .word ov14_021F7D50 + 4
_021EB2E8: .word ov14_021F7D50 + 8
	thumb_func_end ov14_021EB2A8

	thumb_func_start ov14_021EB2EC
ov14_021EB2EC: ; 0x021EB2EC
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _021EB384 ; =0x0000060C
	bl PlaySE
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bhi _021EB37A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EB30A: ; jump table
	.short _021EB312 - _021EB30A - 2 ; case 0
	.short _021EB342 - _021EB30A - 2 ; case 1
	.short _021EB35A - _021EB30A - 2 ; case 2
	.short _021EB366 - _021EB30A - 2 ; case 3
_021EB312:
	add r0, r4, #0
	bl ov14_021F0BF4
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #0x1e
	bl ov14_021E7588
	mov r5, #0x5b
	b _021EB37A
_021EB342:
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7588
	mov r5, #0x51
	b _021EB37A
_021EB35A:
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7588
	mov r5, #0xc
	b _021EB37A
_021EB366:
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7588
	mov r5, #0x75
_021EB37A:
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F01D8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EB384: .word 0x0000060C
	thumb_func_end ov14_021EB2EC

	thumb_func_start ov14_021EB388
ov14_021EB388: ; 0x021EB388
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EB490
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EB3F4
	ldr r0, _021EB6E4 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EB6E8 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EB3D8
	ldr r1, _021EB6EC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
_021EB3D8:
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F039C
	pop {r3, r4, r5, pc}
_021EB3F4:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EB470
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EB6F0 ; =ov14_021EA180
	add r0, r4, #0
	mov r2, #0x4a
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EB470:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_021EB490:
	add r0, r4, #0
	bl ov14_021F6F94
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EB4DC
	blo _021EB4A4
	b _021EB684
_021EB4A4:
	cmp r5, #0x29
	bhi _021EB4D0
	sub r0, #0x1e
	bmi _021EB4DA
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EB4B8: ; jump table
	.short _021EB4F2 - _021EB4B8 - 2 ; case 0
	.short _021EB506 - _021EB4B8 - 2 ; case 1
	.short _021EB530 - _021EB4B8 - 2 ; case 2
	.short _021EB55A - _021EB4B8 - 2 ; case 3
	.short _021EB56C - _021EB4B8 - 2 ; case 4
	.short _021EB6C8 - _021EB4B8 - 2 ; case 5
	.short _021EB58C - _021EB4B8 - 2 ; case 6
	.short _021EB5BA - _021EB4B8 - 2 ; case 7
	.short _021EB5D0 - _021EB4B8 - 2 ; case 8
	.short _021EB5E2 - _021EB4B8 - 2 ; case 9
	.short _021EB5F4 - _021EB4B8 - 2 ; case 10
	.short _021EB606 - _021EB4B8 - 2 ; case 11
_021EB4D0:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EB4DA
	b _021EB714
_021EB4DA:
	b _021EB750
_021EB4DC:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EB4E8
	bne _021EB4E6
	b _021EB6E0
_021EB4E6:
	b _021EB750
_021EB4E8:
	add r0, r1, #2
	cmp r5, r0
	bne _021EB4F0
	b _021EB63A
_021EB4F0:
	b _021EB750
_021EB4F2:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	bl ov14_021F1128
	pop {r3, r4, r5, pc}
_021EB506:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EB530:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EB55A:
	ldr r0, _021EB6FC ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #8
	mov r2, #0x95
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB56C:
	ldr r0, _021EB6FC ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	add r0, #0x2a
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #9
	mov r2, #0x96
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EB58C:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	bl System_GetTouchNew
	cmp r0, #0
	bne _021EB5A2
	add r0, r4, #0
	mov r1, #1
	add r0, #0x2a
	strb r1, [r0]
_021EB5A2:
	add r0, r4, #0
	add r0, #0x21
	ldrb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #3
	mov r2, #0xb2
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EB5BA:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	mov r0, #0x25
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB5D0:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x98
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB5E2:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB5F4:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB606:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0x9c
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB63A:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	cmp r0, #0x1e
	bne _021EB66C
	ldr r0, _021EB700 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _021EB666
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EB666:
	mov r0, #0x10
	tst r0, r1
	bne _021EB66E
_021EB66C:
	b _021EB79E
_021EB66E:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EB684:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EB69A
	add r0, r4, #0
	bl ov14_021E7588
	b _021EB6B8
_021EB69A:
	cmp r1, #0x24
	beq _021EB6B8
	cmp r1, #0x25
	beq _021EB6B8
	cmp r1, #0x26
	beq _021EB6B8
	cmp r1, #0x27
	beq _021EB6B8
	cmp r1, #0x28
	beq _021EB6B8
	cmp r1, #0x29
	beq _021EB6B8
	add r0, r4, #0
	bl ov14_021E765C
_021EB6B8:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x4a
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EB6C8:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB6E0:
	ldr r0, _021EB6F4 ; =0x000005DD
	b _021EB704
	.balign 4, 0
_021EB6E4: .word 0x000005EB
_021EB6E8: .word 0x000040B8
_021EB6EC: .word ov14_021F7D3C
_021EB6F0: .word ov14_021EA180
_021EB6F4: .word 0x000005DD
_021EB6F8: .word 0x000005DC
_021EB6FC: .word 0x00000632
_021EB700: .word gSystem
_021EB704:
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB714:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EB72A
	add r0, r4, #0
	bl ov14_021E7588
	b _021EB748
_021EB72A:
	cmp r1, #0x24
	beq _021EB748
	cmp r1, #0x25
	beq _021EB748
	cmp r1, #0x26
	beq _021EB748
	cmp r1, #0x27
	beq _021EB748
	cmp r1, #0x28
	beq _021EB748
	cmp r1, #0x29
	beq _021EB748
	add r0, r4, #0
	bl ov14_021E765C
_021EB748:
	ldr r0, _021EB7A4 ; =0x000005DC
	bl PlaySE
	b _021EB79E
_021EB750:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EB79E
	ldr r0, _021EB7A8 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EB7AC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0530
	pop {r3, r4, r5, pc}
_021EB79E:
	mov r0, #0xc
	pop {r3, r4, r5, pc}
	nop
_021EB7A4: .word 0x000005DC
_021EB7A8: .word 0x000005DD
_021EB7AC: .word ov14_021F7D3C
	thumb_func_end ov14_021EB388

	thumb_func_start ov14_021EB7B0
ov14_021EB7B0: ; 0x021EB7B0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EB7E0 ; =0x000005EA
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E637C
	add r0, r4, #0
	bl ov14_021F08F0
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0xc
	pop {r4, pc}
	nop
_021EB7E0: .word 0x000005EA
	thumb_func_end ov14_021EB7B0

	thumb_func_start ov14_021EB7E4
ov14_021EB7E4: ; 0x021EB7E4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0x25
	bl ov14_021F6688
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021EB81E
	cmp r0, #1
	beq _021EB800
	cmp r0, #2
	b _021EB83C
_021EB800:
	ldr r1, _021EB8AC ; =ov14_021F7D2C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x5a
	b _021EB856
_021EB81E:
	ldr r1, _021EB8B0 ; =ov14_021F7D1C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x72
	b _021EB856
_021EB83C:
	ldr r1, _021EB8B4 ; =ov14_021F7D3C
	add r0, r5, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EB854
	mov r4, #0x4d
	b _021EB856
_021EB854:
	mov r4, #0x4e
_021EB856:
	ldr r0, [r5, #0x34]
	ldr r2, _021EB8B8 ; =0x0000044E
	ldrb r3, [r0, r2]
	lsl r1, r3, #0x18
	lsr r1, r1, #0x1f
	cmp r1, #1
	bne _021EB892
	mov r1, #0x80
	bic r3, r1
	strb r3, [r0, r2]
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EB880
	add r0, r5, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	b _021EB892
_021EB880:
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
_021EB892:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	ldr r1, _021EB8BC ; =ov14_021E9434
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EB8AC: .word ov14_021F7D2C
_021EB8B0: .word ov14_021F7D1C
_021EB8B4: .word ov14_021F7D3C
_021EB8B8: .word 0x0000044E
_021EB8BC: .word ov14_021E9434
	thumb_func_end ov14_021EB7E4

	thumb_func_start ov14_021EB8C0
ov14_021EB8C0: ; 0x021EB8C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	bl ov14_021E7588
	add r0, r5, #0
	add r0, #0x26
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EB9D4
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021EB8EC
	ldr r1, _021EBAD8 ; =ov14_021F7D2C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	b _021EB954
_021EB8EC:
	cmp r0, #0
	bne _021EB90E
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	ldr r1, _021EBADC ; =ov14_021F7D1C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	b _021EB954
_021EB90E:
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EB934
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EB944
	add r0, r5, #0
	bl ov14_021E8664
	b _021EB944
_021EB934:
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EB944
	add r0, r5, #0
	bl ov14_021E8664
_021EB944:
	ldr r1, _021EBAE0 ; =ov14_021F7D3C
	add r0, r5, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r5, #0
	bl ov14_021E87F4
_021EB954:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E83C4
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	ldr r0, [r5]
	cmp r1, #0x1e
	bhs _021EB984
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021EB980
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x51
	b _021EB9BE
_021EB980:
	mov r4, #0xc
	b _021EB9BE
_021EB984:
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _021EB9A4
	add r0, r5, #0
	bl ov14_021F0BF4
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x5b
	b _021EB9BE
_021EB9A4:
	add r0, r5, #0
	bl ov14_021F0B70
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	add r0, r5, #0
	mov r1, #5
	mov r2, #9
	bl ov14_021F6AC0
	mov r4, #0x24
_021EB9BE:
	add r0, r5, #0
	bl ov14_021F3F6C
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBACC
	ldr r0, [r5, #0x34]
	bl ov14_021E8874
	b _021EBACC
_021EB9D4:
	add r0, r5, #0
	bl ov14_021F0BB4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8610
	add r0, r5, #0
	bl ov14_021F4720
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F57B8
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E86E0
_021EBA0A:
	add r0, r5, #0
	bl ov14_021E9554
	cmp r0, #0
	bne _021EBA0A
	add r0, r5, #0
	add r0, #0x27
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EBA2E
	add r2, r5, #0
	add r2, #0x21
	ldrb r2, [r2]
	add r0, r5, #0
	mov r1, #4
	bl ov14_021F6AC0
	b _021EBA4A
_021EBA2E:
	add r2, r5, #0
	add r2, #0x28
	ldrb r2, [r2]
	add r0, r5, #0
	mov r1, #4
	bl ov14_021F6AC0
	ldr r1, [r5, #0x34]
	ldr r0, _021EBAE4 ; =0x0000044B
	mov r2, #1
	strb r2, [r1, r0]
	add r0, r5, #0
	bl ov14_021EA1F0
_021EBA4A:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r2, [r5, #0x34]
	ldr r0, _021EBAE8 ; =0x0000043C
	add r1, #0x25
	str r1, [r2, r0]
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBA7E
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	mov r4, #0x82
	b _021EBA8E
_021EBA7E:
	add r0, r5, #0
	add r0, #0x27
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EBA8C
	mov r4, #0x29
	b _021EBA8E
_021EBA8C:
	mov r4, #0x73
_021EBA8E:
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBAA6
	add r0, r5, #0
	add r0, #0x27
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EBAA6
	ldr r0, [r5, #0x34]
	bl ov14_021E8874
_021EBAA6:
	add r0, r5, #0
	add r0, #0x29
	ldrb r0, [r0]
	cmp r0, #1
	bne _021EBAB8
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
_021EBAB8:
	add r0, r5, #0
	mov r1, #0
	add r0, #0x26
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x28
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x27
	strb r1, [r0]
_021EBACC:
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F01D8
	pop {r3, r4, r5, pc}
	nop
_021EBAD8: .word ov14_021F7D2C
_021EBADC: .word ov14_021F7D1C
_021EBAE0: .word ov14_021F7D3C
_021EBAE4: .word 0x0000044B
_021EBAE8: .word 0x0000043C
	thumb_func_end ov14_021EB8C0

	thumb_func_start ov14_021EBAEC
ov14_021EBAEC: ; 0x021EBAEC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #9
	mov r2, #0xa
	bl ov14_021F6AC0
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r2, [r4, #0x34]
	ldr r0, _021EBB38 ; =0x0000043C
	str r1, [r2, r0]
	add r0, r4, #0
	bl ov14_021E8740
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x27
	bl ov14_021F6844
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBB2C
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
_021EBB2C:
	add r0, r4, #0
	mov r1, #0x3d
	bl ov14_021F01D8
	pop {r4, pc}
	nop
_021EBB38: .word 0x0000043C
	thumb_func_end ov14_021EBAEC

	thumb_func_start ov14_021EBB3C
ov14_021EBB3C: ; 0x021EBB3C
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	cmp r1, #0x1e
	blo _021EBB62
	bl ov14_021F0B70
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
_021EBB62:
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBB70
	add r0, r5, #0
	bl ov14_021F3F6C
_021EBB70:
	ldr r0, [r5]
	ldr r0, [r0, #8]
	sub r0, r0, #2
	cmp r0, #1
	bhi _021EBB8C
	add r0, r5, #0
	bl ov14_021E87F4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82FC
_021EBB8C:
	ldrh r0, [r5, #0x1c]
	cmp r0, #0
	bne _021EBC04
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBBD2
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5FBC
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EBBBA
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	mov r4, #0x75
	b _021EBBF6
_021EBBBA:
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	add r0, r5, #0
	mov r1, #7
	mov r2, #8
	bl ov14_021F6AC0
	mov r4, #0x8b
	b _021EBBF6
_021EBBD2:
	ldr r1, _021EBDBC ; =ov14_021F7D3C
	add r0, r5, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EBBEA
	mov r4, #0xc
	b _021EBBF6
_021EBBEA:
	add r0, r5, #0
	mov r1, #5
	mov r2, #0xa
	bl ov14_021F6AC0
	mov r4, #0x24
_021EBBF6:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E83C4
	b _021EBD82
_021EBC04:
	mov r4, #0
	cmp r0, #0x70
	bne _021EBC24
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #5
	add r3, r4, #0
	bl ov14_021E6070
	ldr r1, _021EBDC0 ; =0x000001E7
	cmp r0, r1
	beq _021EBC24
	mov r4, #1
	b _021EBC72
_021EBC24:
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	add r1, r5, #0
	add r1, #0x21
	add r3, r5, #0
	add r6, r0, #0
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, #0x1c
	bl ov14_021E6094
	add r0, r6, #0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EBC66
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EBDC4 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EBC66:
	ldrh r1, [r5, #0x1c]
	ldr r0, [r5, #0xc]
	mov r2, #1
	mov r3, #0xa
	bl Bag_TakeItem
_021EBC72:
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r0, [r5]
	cmp r2, #0x1e
	blo _021EBC9C
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBC90
	add r0, r5, #0
	mov r1, #7
	sub r2, #0x1e
	bl ov14_021F6AC0
	b _021EBCD6
_021EBC90:
	add r0, r5, #0
	mov r1, #5
	mov r2, #0xa
	bl ov14_021F6AC0
	b _021EBCD6
_021EBC9C:
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBCD6
	ldr r0, [r5, #0x34]
	add r1, r2, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
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
_021EBCD6:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBD78
	cmp r4, #0
	bne _021EBD50
	ldrh r2, [r5, #0x1c]
	ldr r0, [r5, #0x34]
	ldr r1, _021EBDC8 ; =0x000088C8
	strh r2, [r0, r1]
	ldr r0, [r5, #0x34]
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EBD2A
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #1
	bl ov14_021F396C
	b _021EBD42
_021EBD2A:
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F396C
_021EBD42:
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r0, [r5, #0x34]
	bl ov14_021F3B3C
	b _021EBD74
_021EBD50:
	mov r0, #0
	strh r0, [r5, #0x1c]
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EBD6A
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	b _021EBD74
_021EBD6A:
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
_021EBD74:
	mov r4, #0x7d
	b _021EBD82
_021EBD78:
	cmp r4, #1
	bne _021EBD80
	mov r0, #0
	strh r0, [r5, #0x1c]
_021EBD80:
	mov r4, #0x12
_021EBD82:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E7588
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBD9E
	ldr r0, [r5, #0x34]
	bl ov14_021E8874
	b _021EBDB0
_021EBD9E:
	ldrh r0, [r5, #0x1c]
	cmp r0, #0
	beq _021EBDB0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E892C
_021EBDB0:
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F01D8
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EBDBC: .word ov14_021F7D3C
_021EBDC0: .word 0x000001E7
_021EBDC4: .word 0x00004094
_021EBDC8: .word 0x000088C8
	thumb_func_end ov14_021EBB3C

	thumb_func_start ov14_021EBDCC
ov14_021EBDCC: ; 0x021EBDCC
	push {r4, lr}
	add r4, r0, #0
	ldrh r1, [r4, #0x1c]
	mov r2, #0x25
	bl ov14_021F6768
	mov r0, #0xe
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EBDCC

	thumb_func_start ov14_021EBDE0
ov14_021EBDE0: ; 0x021EBDE0
	ldr r3, _021EBDE4 ; =ov14_021EBDE8
	bx r3
	.balign 4, 0
_021EBDE4: .word ov14_021EBDE8
	thumb_func_end ov14_021EBDE0

	thumb_func_start ov14_021EBDE8
ov14_021EBDE8: ; 0x021EBDE8
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	mov r2, #0xb
	mov r3, #0
	bl ov14_021E6070
	ldr r2, [r4, #0x34]
	ldr r1, _021EBE24 ; =0x000040C0
	str r0, [r2, r1]
	add r0, r4, #0
	bl ov14_021E7DF8
	ldr r0, [r4, #0x34]
	bl ov14_021F638C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7E40
	ldr r1, _021EBE28 ; =ov14_021E94A8
	add r0, r4, #0
	mov r2, #0x15
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EBE24: .word 0x000040C0
_021EBE28: .word ov14_021E94A8
	thumb_func_end ov14_021EBDE8

	thumb_func_start ov14_021EBE2C
ov14_021EBE2C: ; 0x021EBE2C
	push {r4, lr}
	mov r1, #8
	mov r2, #0
	add r4, r0, #0
	bl ov14_021F6AC0
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
	add r0, r4, #0
	mov r1, #0x26
	bl ov14_021F67A4
	mov r0, #0x16
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EBE2C

	thumb_func_start ov14_021EBE68
ov14_021EBE68: ; 0x021EBE68
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #3
	mvn r1, r1
	cmp r0, r1
	bhi _021EBEA0
	bhs _021EBF72
	cmp r0, #7
	bhi _021EBF78
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021EBE90: ; jump table
	.short _021EBEB4 - _021EBE90 - 2 ; case 0
	.short _021EBEC4 - _021EBE90 - 2 ; case 1
	.short _021EBED4 - _021EBE90 - 2 ; case 2
	.short _021EBEE4 - _021EBE90 - 2 ; case 3
	.short _021EBEF4 - _021EBE90 - 2 ; case 4
	.short _021EBF04 - _021EBE90 - 2 ; case 5
	.short _021EBF14 - _021EBE90 - 2 ; case 6
	.short _021EBF4C - _021EBE90 - 2 ; case 7
_021EBEA0:
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021EBEAC
	beq _021EBF60
	b _021EBF78
_021EBEAC:
	add r1, r1, #1
	cmp r0, r1
	beq _021EBF4C
	b _021EBF78
_021EBEB4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7E10
	b _021EBF78
_021EBEC4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021E7E10
	b _021EBF78
_021EBED4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #2
	bl ov14_021E7E10
	b _021EBF78
_021EBEE4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov14_021E7E10
	b _021EBF78
_021EBEF4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #4
	bl ov14_021E7E10
	b _021EBF78
_021EBF04:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	bl ov14_021E7E10
	b _021EBF78
_021EBF14:
	ldr r1, [r4, #0x34]
	ldr r0, _021EBF84 ; =0x000040C0
	mov r2, #0xb
	ldr r1, [r1, r0]
	add r0, sp, #0
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	add r3, sp, #0
	bl ov14_021E6094
	add r1, sp, #0
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E895C
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x9a
	bl ov14_021F23F0
	add sp, #4
	pop {r3, r4, pc}
_021EBF4C:
	ldr r0, _021EBF88 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0x9a
	bl ov14_021F23F0
	add sp, #4
	pop {r3, r4, pc}
_021EBF60:
	ldr r0, _021EBF88 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x18
	bl ov14_021F0244
	add sp, #4
	pop {r3, r4, pc}
_021EBF72:
	ldr r0, _021EBF88 ; =0x000005DC
	bl PlaySE
_021EBF78:
	mov r0, #0x16
	add sp, #4
	pop {r3, r4, pc}
	nop
_021EBF80: .word 0x000005DD
_021EBF84: .word 0x000040C0
_021EBF88: .word 0x000005DC
	thumb_func_end ov14_021EBE68

	thumb_func_start ov14_021EBF8C
ov14_021EBF8C: ; 0x021EBF8C
	ldr r3, _021EBF94 ; =ov14_021F0234
	ldr r1, _021EBF98 ; =ov14_021E94BC
	mov r2, #0xe
	bx r3
	.balign 4, 0
_021EBF94: .word ov14_021F0234
_021EBF98: .word ov14_021E94BC
	thumb_func_end ov14_021EBF8C

	thumb_func_start ov14_021EBF9C
ov14_021EBF9C: ; 0x021EBF9C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	cmp r1, #0x1e
	blo _021EC070
	mov r1, #2
	mov r2, #1
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	add r0, r5, #0
	sub r4, #0x1e
	add r1, r4, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021EBFF8
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EBFF8:
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r4, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EC03C
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EC03C:
	add r0, r4, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021EC090
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EC070:
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
_021EC090:
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	mov r1, #0x4c
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _021EC0CE
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #3
	mov r2, #0x25
	bl ov14_021F67B0
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EC0CE:
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x25
	bl ov14_021F67B0
	add r0, r5, #0
	mov r1, #1
	bl ov14_021F0254
	pop {r3, r4, r5, pc}
	nop
_021EC0E4: .word 0x000005F3
_021EC0E8: .word 0x0000044E
	thumb_func_end ov14_021EBF9C

	thumb_func_start ov14_021EC0EC
ov14_021EC0EC: ; 0x021EC0EC
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E7278
	ldr r1, [r4, #0x34]
	ldr r0, _021EC124 ; =0x000088DC
	ldr r0, [r1, r0]
	bl ov14_021F3380
	cmp r0, #0
	bne _021EC120
	ldr r1, [r4, #0x34]
	ldr r0, _021EC124 ; =0x000088DC
	ldr r0, [r1, r0]
	ldrb r1, [r0, #6]
	cmp r1, #0
	beq _021EC112
	mov r0, #0x1e
	pop {r4, pc}
_021EC112:
	bl ov14_021F33E8
	add r0, r4, #0
	bl ov14_021E7264
	mov r0, #0x1b
	pop {r4, pc}
_021EC120:
	mov r0, #0x1a
	pop {r4, pc}
	.balign 4, 0
_021EC124: .word 0x000088DC
	thumb_func_end ov14_021EC0EC

	thumb_func_start ov14_021EC128
ov14_021EC128: ; 0x021EC128
	push {r4, lr}
	mov r1, #1
	mov r2, #0x25
	add r4, r0, #0
	bl ov14_021F67B0
	mov r0, #0x1c
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EC128

	thumb_func_start ov14_021EC13C
ov14_021EC13C: ; 0x021EC13C
	push {r4, lr}
	mov r1, #2
	mov r2, #0x25
	add r4, r0, #0
	bl ov14_021F67B0
	mov r0, #0x1d
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EC13C

	thumb_func_start ov14_021EC150
ov14_021EC150: ; 0x021EC150
	push {r4, lr}
	add r4, r0, #0
	add r2, r4, #0
	add r2, #0x21
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r2]
	bl ov14_021E6100
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EC200
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021F4958
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021F4A20
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021EC1A2
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x51
	str r0, [r4, #0x30]
	b _021EC1BE
_021EC1A2:
	mov r0, #0xc
	str r0, [r4, #0x30]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
_021EC1BE:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r1, r4, #0
	ldr r0, [r4, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	ldr r1, _021EC234 ; =ov14_021E9450
	b _021EC22A
_021EC200:
	add r0, r4, #0
	bl ov14_021F08BC
	add r0, r4, #0
	mov r1, #1
	add r0, #0x22
	strb r1, [r0]
	mov r0, #0x21
	str r0, [r4, #0x30]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	ldr r1, _021EC238 ; =ov14_021E9194
_021EC22A:
	ldr r2, [r4, #0x30]
	add r0, r4, #0
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EC234: .word ov14_021E9450
_021EC238: .word ov14_021E9194
	thumb_func_end ov14_021EC150

	thumb_func_start ov14_021EC23C
ov14_021EC23C: ; 0x021EC23C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F08F0
	add r0, r4, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EC254
	add r0, r4, #0
	bl ov14_021F57B8
_021EC254:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E7588
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _021EC29E
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x5b
	pop {r4, pc}
_021EC29E:
	mov r0, #0x24
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EC23C

	thumb_func_start ov14_021EC2A4
ov14_021EC2A4: ; 0x021EC2A4
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x34]
	ldr r0, _021EC2E8 ; =0x000088DC
	ldr r0, [r1, r0]
	bl ov14_021F33B0
	cmp r0, #0
	bne _021EC2E4
	ldr r1, [r4, #0x34]
	ldr r0, _021EC2E8 ; =0x000088DC
	ldr r0, [r1, r0]
	bl ov14_021F33FC
	add r0, r4, #0
	bl ov14_021E7264
	add r0, r4, #0
	bl ov14_021F3F6C
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x25
	bl ov14_021F67B0
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	mov r0, #0x1f
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
_021EC2E4:
	mov r0, #0x1e
	pop {r4, pc}
	.balign 4, 0
_021EC2E8: .word 0x000088DC
	thumb_func_end ov14_021EC2A4

	thumb_func_start ov14_021EC2EC
ov14_021EC2EC: ; 0x021EC2EC
	push {r4, lr}
	mov r1, #5
	mov r2, #0x25
	add r4, r0, #0
	bl ov14_021F67B0
	mov r0, #0x20
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EC2EC

	thumb_func_start ov14_021EC300
ov14_021EC300: ; 0x021EC300
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	bl ov14_021F40E8
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EC328
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
	b _021EC332
_021EC328:
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
_021EC332:
	ldr r1, _021EC340 ; =ov14_021E9450
	add r0, r4, #0
	mov r2, #0xe
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EC340: .word ov14_021E9450
	thumb_func_end ov14_021EC300

	thumb_func_start ov14_021EC344
ov14_021EC344: ; 0x021EC344
	push {r3, lr}
	ldr r0, [r0, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x5b
	pop {r3, pc}
	thumb_func_end ov14_021EC344

	thumb_func_start ov14_021EC354
ov14_021EC354: ; 0x021EC354
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov14_021E81A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EC0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	ldr r0, [r4, #0x34]
	bl ov14_021F63F0
	ldr r0, [r4, #0x34]
	bl ov14_021F63A8
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EC4
	add r0, r4, #0
	bl ov14_021F2FDC
	ldr r1, _021EC3A4 ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x23
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EC3A4: .word ov14_021E9518
	thumb_func_end ov14_021EC354

	thumb_func_start ov14_021EC3A8
ov14_021EC3A8: ; 0x021EC3A8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EC3C8
	add r0, r4, #0
	mov r1, #7
	mov r2, #0
	bl ov14_021F6AC0
	mov r0, #0x8b
	pop {r4, pc}
_021EC3C8:
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl ov14_021F6AC0
	mov r0, #0x24
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EC3A8

	thumb_func_start ov14_021EC3D8
ov14_021EC3D8: ; 0x021EC3D8
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A24
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EC4D4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC44A
	ldr r0, _021EC6F4 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EC6F8 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EC42A
	ldr r1, _021EC6FC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
_021EC42A:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0594
	pop {r3, r4, r5, pc}
_021EC44A:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EC4B4
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EC700 ; =ov14_021EA180
	add r0, r4, #0
	mov r2, #0x4c
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EC4B4:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x24
	pop {r3, r4, r5, pc}
_021EC4D4:
	add r0, r4, #0
	bl ov14_021F7388
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EC51E
	bhs _021EC5CA
	cmp r5, #0xd
	bhi _021EC512
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EC4F6: ; jump table
	.short _021EC69A - _021EC4F6 - 2 ; case 0
	.short _021EC69A - _021EC4F6 - 2 ; case 1
	.short _021EC69A - _021EC4F6 - 2 ; case 2
	.short _021EC69A - _021EC4F6 - 2 ; case 3
	.short _021EC69A - _021EC4F6 - 2 ; case 4
	.short _021EC69A - _021EC4F6 - 2 ; case 5
	.short _021EC532 - _021EC4F6 - 2 ; case 6
	.short _021EC610 - _021EC4F6 - 2 ; case 7
	.short _021EC550 - _021EC4F6 - 2 ; case 8
	.short _021EC57E - _021EC4F6 - 2 ; case 9
	.short _021EC594 - _021EC4F6 - 2 ; case 10
	.short _021EC5A6 - _021EC4F6 - 2 ; case 11
	.short _021EC5B8 - _021EC4F6 - 2 ; case 12
	.short _021EC622 - _021EC4F6 - 2 ; case 13
_021EC512:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EC51C
	b _021EC65C
_021EC51C:
	b _021EC69A
_021EC51E:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EC528
	beq _021EC610
	b _021EC69A
_021EC528:
	add r0, r1, #2
	cmp r5, r0
	bne _021EC530
	b _021EC6EE
_021EC530:
	b _021EC69A
_021EC532:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	add r0, #0x2a
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r2, #0x9d
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EC550:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	bl System_GetTouchNew
	cmp r0, #0
	bne _021EC566
	add r0, r4, #0
	mov r1, #2
	add r0, #0x2a
	strb r1, [r0]
_021EC566:
	add r0, r4, #0
	add r0, #0x21
	ldrb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x9d
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EC57E:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	mov r0, #9
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC594:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x98
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC5A6:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC5B8:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC5CA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EC5E2
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EC600
_021EC5E2:
	cmp r1, #8
	beq _021EC600
	cmp r1, #9
	beq _021EC600
	cmp r1, #0xa
	beq _021EC600
	cmp r1, #0xb
	beq _021EC600
	cmp r1, #0xc
	beq _021EC600
	cmp r1, #0xd
	beq _021EC600
	add r0, r4, #0
	bl ov14_021E765C
_021EC600:
	ldr r0, _021EC708 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x4c
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EC610:
	ldr r0, _021EC70C ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x9f
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC622:
	ldr r0, _021EC708 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0x9e
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC65C:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EC674
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EC692
_021EC674:
	cmp r1, #8
	beq _021EC692
	cmp r1, #9
	beq _021EC692
	cmp r1, #0xa
	beq _021EC692
	cmp r1, #0xb
	beq _021EC692
	cmp r1, #0xc
	beq _021EC692
	cmp r1, #0xd
	beq _021EC692
	add r0, r4, #0
	bl ov14_021E765C
_021EC692:
	ldr r0, _021EC708 ; =0x000005DC
	bl PlaySE
	b _021EC6EE
_021EC69A:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC6EE
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EC6FC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #8
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F07F0
	pop {r3, r4, r5, pc}
_021EC6EE:
	mov r0, #0x24
	pop {r3, r4, r5, pc}
	nop
_021EC6F4: .word 0x000005EB
_021EC6F8: .word 0x000040B8
_021EC6FC: .word ov14_021F7D3C
_021EC700: .word ov14_021EA180
_021EC704: .word 0x000005DD
_021EC708: .word 0x000005DC
_021EC70C: .word 0x00000633
	thumb_func_end ov14_021EC3D8

	thumb_func_start ov14_021EC710
ov14_021EC710: ; 0x021EC710
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
	ldr r1, _021EC72C ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x26
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EC72C: .word ov14_021E9518
	thumb_func_end ov14_021EC710

	thumb_func_start ov14_021EC730
ov14_021EC730: ; 0x021EC730
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E7E98
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5C84
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5E94
	add r0, r4, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EC762
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EB4
_021EC762:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EC7AE
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x21
	bl ov14_021F6AC0
	ldr r1, _021EC7D0 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x75
	bl ov14_021F0234
	pop {r4, pc}
_021EC7AE:
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x21
	bl ov14_021F6AC0
	ldr r1, _021EC7D0 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0xc
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EC7D0: .word ov14_021E94BC
	thumb_func_end ov14_021EC730

	thumb_func_start ov14_021EC7D4
ov14_021EC7D4: ; 0x021EC7D4
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	add r1, r4, #0
	add r1, #0xe4
	ldr r6, [r1]
	mov r1, #0x28
	bl ov14_021F6654
	ldr r0, _021EC850 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
	add r0, r5, #0
	bl ov14_021F08F0
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0xff
	ldr r0, [r5, #0x34]
	bne _021EC838
	add r1, r6, #0
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E7588
	b _021EC84A
_021EC838:
	ldr r0, [r0, #0x2c]
	mov r1, #8
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
_021EC84A:
	mov r0, #0x24
	pop {r4, r5, r6, pc}
	nop
_021EC850: .word 0x000005EA
	thumb_func_end ov14_021EC7D4

	thumb_func_start ov14_021EC854
ov14_021EC854: ; 0x021EC854
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r2, [r4, #0x34]
	ldr r0, _021EC8CC ; =0x0000043C
	add r1, #0x25
	str r1, [r2, r0]
	add r0, r4, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EC8A2
	add r2, r4, #0
	add r2, #0x2b
	ldrb r2, [r2]
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F6AC0
	add r0, r4, #0
	add r0, #0x2b
	ldrb r1, [r0]
	add r0, r4, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021F1580
	mov r1, #0
	add r4, #0x2a
	strb r1, [r4]
	pop {r4, pc}
_021EC8A2:
	add r2, r4, #0
	add r2, #0x2b
	ldrb r2, [r2]
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F6AC0
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E7588
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EC8C8
	mov r0, #0x82
	pop {r4, pc}
_021EC8C8:
	mov r0, #0x29
	pop {r4, pc}
	.balign 4, 0
_021EC8CC: .word 0x0000043C
	thumb_func_end ov14_021EC854

	thumb_func_start ov14_021EC8D0
ov14_021EC8D0: ; 0x021EC8D0
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A34
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EC97E
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC928
	ldr r0, _021ECC30 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021ECC34 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F083C
	pop {r3, r4, r5, pc}
_021EC928:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	add r5, #0x1e
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EC960
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EC960:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EC97A
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EC97A:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021EC97E:
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021ECA20
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC9CC
	ldr r0, _021ECC30 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021ECC34 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F083C
	pop {r3, r4, r5, pc}
_021EC9CC:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021ECA02
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECA02:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECA1C
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021ECA1C:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECA20:
	add r0, r4, #0
	bl ov14_021F7B7C
	cmp r0, #1
	bne _021ECA68
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r5, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ECA64
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	strb r5, [r0]
	add r0, r4, #0
	mov r1, #1
	add r0, #0x26
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0x97
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021ECA64:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECA68:
	add r0, r4, #0
	bl ov14_021F70C0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021ECAAE
	blo _021ECA7C
	b _021ECC6A
_021ECA7C:
	cmp r5, #0x2d
	bhi _021ECAA4
	sub r0, #0x24
	bmi _021ECAAC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021ECA90: ; jump table
	.short _021ECCFE - _021ECA90 - 2 ; case 0
	.short _021ECAC4 - _021ECA90 - 2 ; case 1
	.short _021ECADA - _021ECA90 - 2 ; case 2
	.short _021ECAF0 - _021ECA90 - 2 ; case 3
	.short _021ECB06 - _021ECA90 - 2 ; case 4
	.short _021ECB1C - _021ECA90 - 2 ; case 5
	.short _021ECB32 - _021ECA90 - 2 ; case 6
	.short _021ECB48 - _021ECA90 - 2 ; case 7
	.short _021ECBBA - _021ECA90 - 2 ; case 8
	.short _021ECC2A - _021ECA90 - 2 ; case 9
_021ECAA4:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021ECAC0
_021ECAAC:
	b _021ECD70
_021ECAAE:
	add r0, r1, #1
	cmp r5, r0
	bhi _021ECABA
	bne _021ECAB8
	b _021ECD1A
_021ECAB8:
	b _021ECD70
_021ECABA:
	add r0, r1, #2
	cmp r5, r0
	bne _021ECAC2
_021ECAC0:
	b _021ECD98
_021ECAC2:
	b _021ECD70
_021ECAC4:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECADA:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECAF0:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB06:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB1C:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB32:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB48:
	ldr r0, _021ECC3C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021ECB9C
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECB9C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECBB6
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021ECBB6:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECBBA:
	ldr r0, _021ECC3C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021ECC0C
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECC0C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECC26
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021ECC26:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECC2A:
	ldr r0, _021ECC3C ; =0x000005DC
	b _021ECC40
	nop
_021ECC30: .word 0x000005EB
_021ECC34: .word 0x000040B8
_021ECC38: .word 0x000005DD
_021ECC3C: .word 0x000005DC
_021ECC40:
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0xa0
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021ECC6A:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x25
	bhs _021ECCC4
	add r0, r4, #0
	bl ov14_021E7588
	cmp r0, #1
	ldr r1, [r4, #0x34]
	bne _021ECCA8
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #0
	bne _021ECCE6
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	b _021ECCE6
_021ECCA8:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECCE6
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
	b _021ECCE6
_021ECCC4:
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECCE6
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
_021ECCE6:
	ldr r0, _021ECD9C ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021ECD98
	add r0, r4, #0
	mov r1, #0x4b
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021ECCFE:
	ldr r0, _021ECDA0 ; =0x00000633
	bl PlaySE
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021ECD1A:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021ECD3C
	ldr r0, _021ECDA0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021ECD3C:
	ldr r0, _021ECD9C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECD70:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ECD98
	ldr r0, _021ECDA4 ; =0x000005EB
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1580
	pop {r3, r4, r5, pc}
_021ECD98:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021ECD9C: .word 0x000005DC
_021ECDA0: .word 0x00000633
_021ECDA4: .word 0x000005EB
	thumb_func_end ov14_021EC8D0

	thumb_func_start ov14_021ECDA8
ov14_021ECDA8: ; 0x021ECDA8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r7, [r0, #0xc]
	add r0, r7, #0
	add r0, #0xe8
	ldr r6, [r0]
	add r0, r7, #0
	add r0, #0xec
	ldr r4, [r0]
	ldr r0, _021ECF50 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	mov r0, #0x80
	and r0, r6
	str r0, [sp]
	bne _021ECDE0
	add r1, r7, #0
	add r1, #0xe4
	add r7, #0xe8
	ldr r1, [r1]
	ldr r2, [r7]
	add r0, r5, #0
	bl ov14_021E6548
_021ECDE0:
	add r0, r5, #0
	bl ov14_021F08F0
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ECE04
	add r0, r5, #0
	bl ov14_021F57B8
_021ECE04:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	bne _021ECE20
	add r0, r5, #0
	bl ov14_021E765C
	b _021ECF40
_021ECE20:
	cmp r6, #0xff
	beq _021ECE3A
	ldr r0, [sp]
	cmp r0, #0
	bne _021ECE2C
	b _021ECF40
_021ECE2C:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E7588
	b _021ECF40
_021ECE3A:
	add r0, r5, #0
	add r0, #0x21
	ldrb r6, [r0]
	cmp r6, #0x1e
	blo _021ECECE
	cmp r4, r6
	beq _021ECECE
	sub r6, #0x1e
	ldr r0, [r5, #8]
	add r1, r6, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021ECE82
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECE82:
	add r0, r7, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021ECEAA
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECEAA:
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021ECECE
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECECE:
	cmp r4, #0xff
	beq _021ECF40
	mov r0, #0x80
	tst r0, r4
	beq _021ECF40
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	mov r2, #0x80
	add r3, r4, #0
	eor r3, r2
	mov r2, #6
	mul r2, r0
	ldrb r1, [r5, #0x1f]
	add r0, r3, r2
	cmp r1, r0
	beq _021ECF40
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0x1e
	bhs _021ECF0E
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ECF32
_021ECF0E:
	add r0, r5, #0
	sub r1, #0x1e
	bl ov14_021E6480
	cmp r0, #1
	bne _021ECF28
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ECF32
_021ECF28:
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
_021ECF32:
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECF40:
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x29
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021ECF50: .word 0x000005EA
_021ECF54: .word 0x000005F3
	thumb_func_end ov14_021ECDA8

	thumb_func_start ov14_021ECF58
ov14_021ECF58: ; 0x021ECF58
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	add r0, r4, #0
	add r0, #0xe8
	ldr r6, [r0]
	ldr r0, _021ED1A0 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	mov r0, #0x80
	tst r0, r6
	bne _021ECF88
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
_021ECF88:
	add r0, r5, #0
	bl ov14_021F08F0
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ECF9E
	add r0, r5, #0
	bl ov14_021F57B8
_021ECF9E:
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r4, r0, #0
	ldr r1, [r5, #0x34]
	ldr r0, _021ED1A4 ; =0x000088CC
	ldr r0, [r1, r0]
	cmp r0, #0
	bne _021ECFC0
	cmp r6, #0xff
	bne _021ECFC0
	add r0, r5, #0
	add r0, #0x21
	ldrb r6, [r0]
	cmp r4, r6
	bne _021ECFC2
_021ECFC0:
	b _021ED15C
_021ECFC2:
	cmp r6, #0x1e
	blo _021ED0B2
	sub r6, #0x1e
	ldr r0, [r5, #8]
	add r1, r6, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021ED022
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED022:
	add r0, r7, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021ED06C
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED06C:
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021ED0B2
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED0B2:
	cmp r4, #0x25
	blo _021ED142
	cmp r4, #0x2a
	bhi _021ED142
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r3, r4, #0
	mov r2, #6
	ldrb r1, [r5, #0x1f]
	sub r3, #0x25
	mul r2, r0
	add r0, r3, r2
	cmp r1, r0
	beq _021ED142
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0x1e
	bhs _021ED0EE
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ED112
_021ED0EE:
	add r0, r5, #0
	sub r1, #0x1e
	bl ov14_021E6480
	cmp r0, #1
	bne _021ED108
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ED112
_021ED108:
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
_021ED112:
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED142:
	add r0, r5, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	bne _021ED15C
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	add r0, r5, #0
	bl ov14_021E7588
_021ED15C:
	add r0, r5, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ED17E
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	bl ov14_021E76B8
	add r0, r5, #0
	bl ov14_021F0CD8
	pop {r3, r4, r5, r6, r7, pc}
_021ED17E:
	cmp r4, #0x25
	blo _021ED192
	cmp r4, #0x2a
	bhi _021ED192
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021ED19C
_021ED192:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED19C:
	mov r0, #0x29
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021ED1A0: .word 0x000005EA
_021ED1A4: .word 0x000088CC
_021ED1A8: .word 0x000005F3
	thumb_func_end ov14_021ECF58

	thumb_func_start ov14_021ED1AC
ov14_021ED1AC: ; 0x021ED1AC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6688
	add r0, r4, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	ldr r0, [r4, #0x34]
	beq _021ED1DA
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	bl ov14_021F0CD8
	pop {r4, pc}
_021ED1DA:
	ldr r0, [r0, #0x2c]
	mov r1, #1
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x29
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021ED1AC

	thumb_func_start ov14_021ED1E8
ov14_021ED1E8: ; 0x021ED1E8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F63B8
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021ED206
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021ED210
_021ED206:
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
_021ED210:
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ED238
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
_021ED238:
	add r0, r4, #0
	mov r1, #1
	add r0, #0x24
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0x29
	strb r1, [r0]
	add r0, r4, #0
	ldrb r1, [r4, #0x1f]
	add r0, #0x25
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #0x28
	bl ov14_021F1058
	pop {r4, pc}
	thumb_func_end ov14_021ED1E8

	thumb_func_start ov14_021ED258
ov14_021ED258: ; 0x021ED258
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F63A8
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021ED28A
	add r0, r4, #0
	mov r1, #7
	mov r2, #0
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	mov r0, #0x8b
	pop {r4, pc}
_021ED28A:
	add r0, r4, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ED2A6
	add r2, r4, #0
	add r2, #0x2b
	ldrb r2, [r2]
	add r0, r4, #0
	mov r1, #5
	sub r2, #0x1e
	bl ov14_021F6AC0
	b _021ED2B0
_021ED2A6:
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl ov14_021F6AC0
_021ED2B0:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	mov r0, #0x24
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021ED258

	thumb_func_start ov14_021ED2C8
ov14_021ED2C8: ; 0x021ED2C8
	ldrb r2, [r0, #0x1f]
	add r1, r0, #0
	add r1, #0x25
	strb r2, [r1]
	ldr r3, _021ED2D8 ; =ov14_021F1058
	mov r1, #0x30
	bx r3
	nop
_021ED2D8: .word ov14_021F1058
	thumb_func_end ov14_021ED2C8

	thumb_func_start ov14_021ED2DC
ov14_021ED2DC: ; 0x021ED2DC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov14_021E81A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7ED0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	ldr r0, [r4, #0x34]
	bl ov14_021F63F0
	ldr r0, [r4, #0x34]
	bl ov14_021F63B8
	add r0, r4, #0
	bl ov14_021F3044
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ED340
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
_021ED340:
	ldr r1, _021ED34C ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x28
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED34C: .word ov14_021E9518
	thumb_func_end ov14_021ED2DC

	thumb_func_start ov14_021ED350
ov14_021ED350: ; 0x021ED350
	ldr r3, _021ED358 ; =ov14_021F1090
	mov r1, #0x32
	bx r3
	nop
_021ED358: .word ov14_021F1090
	thumb_func_end ov14_021ED350

	thumb_func_start ov14_021ED35C
ov14_021ED35C: ; 0x021ED35C
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x29
	ldrb r1, [r1]
	cmp r1, #1
	bne _021ED370
	bl ov14_021F0C58
	pop {r4, pc}
_021ED370:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
	ldr r1, _021ED388 ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x33
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED388: .word ov14_021E9518
	thumb_func_end ov14_021ED35C

	thumb_func_start ov14_021ED38C
ov14_021ED38C: ; 0x021ED38C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r1, [r5]
	ldr r1, [r1, #8]
	cmp r1, #3
	bne _021ED3A0
	mov r7, #6
	mov r6, #0x22
	mov r4, #0x75
	b _021ED3BC
_021ED3A0:
	add r1, r5, #0
	add r1, #0x2a
	ldrb r1, [r1]
	mov r7, #3
	mov r6, #0x22
	mov r4, #0xc
	cmp r1, #0
	beq _021ED3BC
	add r1, r5, #0
	add r1, #0x2b
	ldrb r6, [r1]
	add r1, r6, #0
	bl ov14_021E7588
_021ED3BC:
	add r0, r5, #0
	add r1, r7, #0
	add r2, r6, #0
	bl ov14_021F6AC0
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5C84
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5E94
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021ED410 ; =ov14_021E94BC
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021ED410: .word ov14_021E94BC
	thumb_func_end ov14_021ED38C

	thumb_func_start ov14_021ED414
ov14_021ED414: ; 0x021ED414
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #3
	mvn r1, r1
	cmp r0, r1
	bhi _021ED454
	blo _021ED42C
	b _021ED57C
_021ED42C:
	cmp r0, #0xb
	bhi _021ED45E
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021ED43C: ; jump table
	.short _021ED46A - _021ED43C - 2 ; case 0
	.short _021ED47A - _021ED43C - 2 ; case 1
	.short _021ED48A - _021ED43C - 2 ; case 2
	.short _021ED49A - _021ED43C - 2 ; case 3
	.short _021ED4AA - _021ED43C - 2 ; case 4
	.short _021ED4BA - _021ED43C - 2 ; case 5
	.short _021ED4CA - _021ED43C - 2 ; case 6
	.short _021ED4DC - _021ED43C - 2 ; case 7
	.short _021ED4EC - _021ED43C - 2 ; case 8
	.short _021ED526 - _021ED43C - 2 ; case 9
	.short _021ED542 - _021ED43C - 2 ; case 10
	.short _021ED584 - _021ED43C - 2 ; case 11
_021ED454:
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021ED460
	beq _021ED55E
_021ED45E:
	b _021ED5A0
_021ED460:
	add r1, r1, #1
	cmp r0, r1
	bne _021ED468
	b _021ED58E
_021ED468:
	b _021ED5A0
_021ED46A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F1170
	pop {r4, pc}
_021ED47A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1170
	pop {r4, pc}
_021ED48A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F1170
	pop {r4, pc}
_021ED49A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F1170
	pop {r4, pc}
_021ED4AA:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F1170
	pop {r4, pc}
_021ED4BA:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F1170
	pop {r4, pc}
_021ED4CA:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F11F8
	pop {r4, pc}
_021ED4DC:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F11F8
	pop {r4, pc}
_021ED4EC:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	add r0, #0x25
	ldrb r1, [r4, #0x1f]
	ldrb r0, [r0]
	cmp r1, r0
	bne _021ED514
	ldr r0, _021ED5AC ; =0x000005F3
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0x3d
	bl ov14_021F2270
	pop {r4, pc}
_021ED514:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0xa2
	bl ov14_021F2270
	pop {r4, pc}
_021ED526:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	mov r2, #0xa3
	bl ov14_021F2270
	pop {r4, pc}
_021ED542:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0xa4
	bl ov14_021F2270
	pop {r4, pc}
_021ED55E:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021ED5A0
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x3e
	bl ov14_021F0244
	pop {r4, pc}
_021ED57C:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	b _021ED5A0
_021ED584:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED58E:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x39
	bl ov14_021F2270
	pop {r4, pc}
_021ED5A0:
	mov r0, #0x3d
	pop {r4, pc}
	.balign 4, 0
_021ED5A4: .word 0x000005DD
_021ED5A8: .word 0x000005DC
_021ED5AC: .word 0x000005F3
	thumb_func_end ov14_021ED414

	thumb_func_start ov14_021ED5B0
ov14_021ED5B0: ; 0x021ED5B0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	ldr r1, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021ED5DA
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E834C
	cmp r0, #0
	bne _021ED5FC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	b _021ED5FC
_021ED5DA:
	mov r0, #0x2f
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
_021ED5FC:
	ldr r1, _021ED608 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x35
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED608: .word ov14_021E94BC
	thumb_func_end ov14_021ED5B0

	thumb_func_start ov14_021ED60C
ov14_021ED60C: ; 0x021ED60C
	ldrb r2, [r0, #0x1f]
	add r1, r0, #0
	add r1, #0x25
	strb r2, [r1]
	ldr r3, _021ED61C ; =ov14_021F1058
	mov r1, #0x36
	bx r3
	nop
_021ED61C: .word ov14_021F1058
	thumb_func_end ov14_021ED60C

	thumb_func_start ov14_021ED620
ov14_021ED620: ; 0x021ED620
	ldr r3, _021ED628 ; =ov14_021F10B4
	mov r1, #0x37
	bx r3
	nop
_021ED628: .word ov14_021F10B4
	thumb_func_end ov14_021ED620

	thumb_func_start ov14_021ED62C
ov14_021ED62C: ; 0x021ED62C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F6070
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E875C
	ldr r1, _021ED64C ; =ov14_021E9618
	add r0, r4, #0
	mov r2, #0x38
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED64C: .word ov14_021E9618
	thumb_func_end ov14_021ED62C

	thumb_func_start ov14_021ED650
ov14_021ED650: ; 0x021ED650
	push {r4, lr}
	add r4, r0, #0
	ldr r2, [r4, #0x2c]
	mov r1, #9
	bl ov14_021F6AC0
	ldr r0, [r4, #0x2c]
	cmp r0, #5
	ldr r0, [r4, #0x34]
	bhi _021ED66E
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021ED676
_021ED66E:
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED676:
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x27
	bl ov14_021F6844
	mov r0, #0x3d
	pop {r4, pc}
	thumb_func_end ov14_021ED650

	thumb_func_start ov14_021ED684
ov14_021ED684: ; 0x021ED684
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #0x3a
	bl ov14_021F10DC
	pop {r4, pc}
	thumb_func_end ov14_021ED684

	thumb_func_start ov14_021ED6A4
ov14_021ED6A4: ; 0x021ED6A4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E87BC
	ldr r1, _021ED6C0 ; =ov14_021E9618
	add r0, r4, #0
	mov r2, #0x3b
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED6C0: .word ov14_021E9618
	thumb_func_end ov14_021ED6A4

	thumb_func_start ov14_021ED6C4
ov14_021ED6C4: ; 0x021ED6C4
	ldr r3, _021ED6CC ; =ov14_021F1090
	mov r1, #0x3c
	bx r3
	nop
_021ED6CC: .word ov14_021F1090
	thumb_func_end ov14_021ED6C4

	thumb_func_start ov14_021ED6D0
ov14_021ED6D0: ; 0x021ED6D0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021ED71A
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x1e
	bl ov14_021F6AC0
	ldr r1, _021ED758 ; =ov14_021E95B4
	add r0, r4, #0
	mov r2, #0x52
	bl ov14_021F0234
	pop {r4, pc}
_021ED71A:
	cmp r0, #3
	bne _021ED72A
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x1e
	bl ov14_021F6AC0
	b _021ED734
_021ED72A:
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x1e
	bl ov14_021F6AC0
_021ED734:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	ldr r1, _021ED75C ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x4d
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED758: .word ov14_021E95B4
_021ED75C: .word ov14_021E94BC
	thumb_func_end ov14_021ED6D0

	thumb_func_start ov14_021ED760
ov14_021ED760: ; 0x021ED760
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x25
	ldrb r1, [r1]
	bl ov14_021E7930
	ldr r2, [r4, #0x34]
	ldr r1, _021ED7B0 ; =0x0000044D
	strb r0, [r2, r1]
	add r0, r4, #0
	bl ov14_021F4428
	add r0, r4, #0
	bl ov14_021F4530
	add r0, r4, #0
	bl ov14_021F459C
	add r0, r4, #0
	bl ov14_021F58B8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E87BC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E81B4
	ldr r1, _021ED7B4 ; =ov14_021E9660
	add r0, r4, #0
	mov r2, #0x40
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED7B0: .word 0x0000044D
_021ED7B4: .word ov14_021E9660
	thumb_func_end ov14_021ED760

	thumb_func_start ov14_021ED7B8
ov14_021ED7B8: ; 0x021ED7B8
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F6094
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8560
	ldr r1, _021ED7D8 ; =ov14_021E95C8
	add r0, r4, #0
	mov r2, #0x41
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED7D8: .word ov14_021E95C8
	thumb_func_end ov14_021ED7B8

	thumb_func_start ov14_021ED7DC
ov14_021ED7DC: ; 0x021ED7DC
	push {r4, r5, r6, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x34]
	ldr r2, _021ED81C ; =0x0000044D
	ldrb r3, [r1, r2]
	lsr r6, r3, #0x1f
	lsl r5, r3, #0x1e
	sub r5, r5, r6
	mov r3, #0x1e
	ror r5, r3
	add r3, r2, #0
	add r5, r6, r5
	sub r3, #0x11
	str r5, [r1, r3]
	ldr r3, [r4, #0x34]
	sub r2, #0x11
	ldr r2, [r3, r2]
	mov r1, #0xa
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0x27
	bl ov14_021F6844
	mov r0, #0x42
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021ED81C: .word 0x0000044D
	thumb_func_end ov14_021ED7DC

	thumb_func_start ov14_021ED820
ov14_021ED820: ; 0x021ED820
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021ED856
	bhs _021ED8E0
	cmp r0, #7
	bhi _021ED914
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021ED846: ; jump table
	.short _021ED860 - _021ED846 - 2 ; case 0
	.short _021ED872 - _021ED846 - 2 ; case 1
	.short _021ED884 - _021ED846 - 2 ; case 2
	.short _021ED896 - _021ED846 - 2 ; case 3
	.short _021ED8A8 - _021ED846 - 2 ; case 4
	.short _021ED8BC - _021ED846 - 2 ; case 5
	.short _021ED8CE - _021ED846 - 2 ; case 6
	.short _021ED8F8 - _021ED846 - 2 ; case 7
_021ED856:
	mov r1, #1
	mvn r1, r1
	cmp r0, r1
	beq _021ED902
	b _021ED914
_021ED860:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED872:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED884:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED896:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED8A8:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1228
	mov r0, #0x42
	pop {r4, pc}
_021ED8BC:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1228
	mov r0, #0x42
	pop {r4, pc}
_021ED8CE:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	bl ov14_021F131C
	pop {r4, pc}
_021ED8E0:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021ED914
	add r0, r4, #0
	mov r1, #0x49
	bl ov14_021F0244
	pop {r4, pc}
_021ED8F8:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED902:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0xa6
	bl ov14_021F2270
	pop {r4, pc}
_021ED914:
	mov r0, #0x42
	pop {r4, pc}
	.balign 4, 0
_021ED918: .word 0x000005DD
_021ED91C: .word 0x000005DC
	thumb_func_end ov14_021ED820

	thumb_func_start ov14_021ED920
ov14_021ED920: ; 0x021ED920
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8588
	ldr r1, _021ED93C ; =ov14_021E9604
	add r0, r4, #0
	mov r2, #0x44
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED93C: .word ov14_021E9604
	thumb_func_end ov14_021ED920

	thumb_func_start ov14_021ED940
ov14_021ED940: ; 0x021ED940
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E81D8
	ldr r1, _021ED95C ; =ov14_021E96A8
	add r0, r4, #0
	mov r2, #0x45
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED95C: .word ov14_021E96A8
	thumb_func_end ov14_021ED940

	thumb_func_start ov14_021ED960
ov14_021ED960: ; 0x021ED960
	ldr r3, _021ED968 ; =ov14_021F1058
	mov r1, #0x37
	bx r3
	nop
_021ED968: .word ov14_021F1058
	thumb_func_end ov14_021ED960

	thumb_func_start ov14_021ED96C
ov14_021ED96C: ; 0x021ED96C
	push {r4, lr}
	add r4, r0, #0
	ldr r2, [r4, #0x34]
	ldr r1, _021ED9A8 ; =0x0000044D
	ldrb r1, [r2, r1]
	bl ov14_021E78AC
	ldr r1, [r4, #0x34]
	ldr r0, _021ED9A8 ; =0x0000044D
	ldrb r2, [r1, r0]
	ldr r0, [r4, #4]
	cmp r2, #0x10
	bhs _021ED98E
	ldrb r1, [r4, #0x1f]
	bl PCStorage_SetBoxWallpaper
	b _021ED996
_021ED98E:
	ldrb r1, [r4, #0x1f]
	add r2, #0x10
	bl PCStorage_SetBoxWallpaper
_021ED996:
	add r0, r4, #0
	bl ov14_021F4530
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021F4958
	mov r0, #0x48
	pop {r4, pc}
	.balign 4, 0
_021ED9A8: .word 0x0000044D
	thumb_func_end ov14_021ED96C

	thumb_func_start ov14_021ED9AC
ov14_021ED9AC: ; 0x021ED9AC
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0
	mov r3, #2
	ldr r0, [r0, #0x18]
	add r2, r1, #0
	lsl r3, r3, #8
	bl PaletteData_LoadPaletteSlotFromHardware
	mov r3, #0
	mov r2, #3
	str r3, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	ldr r0, _021ED9E8 ; =0x00007FFF
	mov r1, #1
	str r0, [sp, #8]
	ldr r0, [r4, #0x34]
	lsl r2, r2, #0xe
	ldr r0, [r0, #0x18]
	bl PaletteData_BeginPaletteFade
	mov r0, #0x46
	str r0, [r4, #0x30]
	mov r0, #3
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_021ED9E8: .word 0x00007FFF
	thumb_func_end ov14_021ED9AC

	thumb_func_start ov14_021ED9EC
ov14_021ED9EC: ; 0x021ED9EC
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r3, #0
	ldr r0, _021EDA18 ; =0x00007FFF
	str r3, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #0x34]
	mov r2, #3
	ldr r0, [r0, #0x18]
	mov r1, #1
	lsl r2, r2, #0xe
	bl PaletteData_BeginPaletteFade
	mov r0, #0x42
	str r0, [r4, #0x30]
	mov r0, #3
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_021EDA18: .word 0x00007FFF
	thumb_func_end ov14_021ED9EC

	thumb_func_start ov14_021EDA1C
ov14_021EDA1C: ; 0x021EDA1C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EDA36
	mov r0, #0x75
	pop {r4, pc}
_021EDA36:
	mov r0, #0xc
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EDA1C

	thumb_func_start ov14_021EDA3C
ov14_021EDA3C: ; 0x021EDA3C
	push {r3, lr}
	ldr r0, [r0, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #0x24
	pop {r3, pc}
	thumb_func_end ov14_021EDA3C

	thumb_func_start ov14_021EDA4C
ov14_021EDA4C: ; 0x021EDA4C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EDB3C
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EDAB8
	ldr r2, [r4, #0x34]
	ldr r1, _021EDDA4 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EDA96
	ldr r1, _021EDDA8 ; =ov14_021F7D2C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
_021EDA96:
	ldr r0, _021EDDAC ; =0x000005EB
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0418
	pop {r3, r4, r5, pc}
_021EDAB8:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EDB1C
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EDDB0 ; =ov14_021EA130
	add r0, r4, #0
	mov r2, #0x59
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EDB1C:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x51
	pop {r3, r4, r5, pc}
_021EDB3C:
	add r0, r4, #0
	bl ov14_021F6E8C
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EDB82
	blo _021EDB50
	b _021EDCBA
_021EDB50:
	cmp r5, #0x26
	bhi _021EDB76
	sub r0, #0x1e
	bmi _021EDB80
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EDB64: ; jump table
	.short _021EDC32 - _021EDB64 - 2 ; case 0
	.short _021EDC4E - _021EDB64 - 2 ; case 1
	.short _021EDC84 - _021EDB64 - 2 ; case 2
	.short _021EDCFA - _021EDB64 - 2 ; case 3
	.short _021EDB98 - _021EDB64 - 2 ; case 4
	.short _021EDBBC - _021EDB64 - 2 ; case 5
	.short _021EDBD2 - _021EDB64 - 2 ; case 6
	.short _021EDBEC - _021EDB64 - 2 ; case 7
	.short _021EDBFE - _021EDB64 - 2 ; case 8
_021EDB76:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EDB80
	b _021EDD6C
_021EDB80:
	b _021EDDC4
_021EDB82:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EDB8E
	bne _021EDB8C
	b _021EDD12
_021EDB8C:
	b _021EDDC4
_021EDB8E:
	add r0, r1, #2
	cmp r5, r0
	bne _021EDB96
	b _021EDD24
_021EDB96:
	b _021EDDC4
_021EDB98:
	ldr r0, [r4, #8]
	bl Party_GetCount
	cmp r0, #6
	beq _021EDBAA
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	b _021EDBB0
_021EDBAA:
	ldr r0, _021EDDB8 ; =0x000005F3
	bl PlaySE
_021EDBB0:
	add r0, r4, #0
	mov r1, #4
	mov r2, #0xa7
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBBC:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	mov r0, #0x23
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBD2:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBEC:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBFE:
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xa8
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDC32:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	bl ov14_021F1128
	pop {r3, r4, r5, pc}
_021EDC4E:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EDC84:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EDCBA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EDCD0
	add r0, r4, #0
	bl ov14_021E7588
	b _021EDCEA
_021EDCD0:
	cmp r1, #0x22
	beq _021EDCEA
	cmp r1, #0x23
	beq _021EDCEA
	cmp r1, #0x24
	beq _021EDCEA
	cmp r1, #0x25
	beq _021EDCEA
	cmp r1, #0x26
	beq _021EDCEA
	add r0, r4, #0
	bl ov14_021E765C
_021EDCEA:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x58
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EDCFA:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDD12:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDD24:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	cmp r0, #0x1e
	bne _021EDE12
	ldr r0, _021EDDC0 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _021EDD50
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EDD50:
	mov r0, #0x10
	tst r0, r1
	beq _021EDE12
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EDD6C:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EDD82
	add r0, r4, #0
	bl ov14_021E7588
	b _021EDD9C
_021EDD82:
	cmp r1, #0x22
	beq _021EDD9C
	cmp r1, #0x23
	beq _021EDD9C
	cmp r1, #0x24
	beq _021EDD9C
	cmp r1, #0x25
	beq _021EDD9C
	cmp r1, #0x26
	beq _021EDD9C
	add r0, r4, #0
	bl ov14_021E765C
_021EDD9C:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	b _021EDE12
	.balign 4, 0
_021EDDA4: .word 0x000040B8
_021EDDA8: .word ov14_021F7D2C
_021EDDAC: .word 0x000005EB
_021EDDB0: .word ov14_021EA130
_021EDDB4: .word 0x000005DD
_021EDDB8: .word 0x000005F3
_021EDDBC: .word 0x000005DC
_021EDDC0: .word gSystem
_021EDDC4:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EDE12
	ldr r0, _021EDE18 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EDE1C ; =ov14_021F7D2C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x22
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #0x22
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F04D4
	pop {r3, r4, r5, pc}
_021EDE12:
	mov r0, #0x51
	pop {r3, r4, r5, pc}
	nop
_021EDE18: .word 0x000005DD
_021EDE1C: .word ov14_021F7D2C
	thumb_func_end ov14_021EDA4C

	thumb_func_start ov14_021EDE20
ov14_021EDE20: ; 0x021EDE20
	push {r4, lr}
	mov r1, #0
	add r4, r0, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	bl ov14_021EDF90
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EDE20

	thumb_func_start ov14_021EDE38
ov14_021EDE38: ; 0x021EDE38
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F3044
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7ED0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	add r0, r4, #0
	mov r1, #2
	add r0, #0x22
	strb r1, [r0]
	ldr r1, _021EDE6C ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x54
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EDE6C: .word ov14_021E9518
	thumb_func_end ov14_021EDE38

	thumb_func_start ov14_021EDE70
ov14_021EDE70: ; 0x021EDE70
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F08BC
	ldr r1, _021EDE84 ; =ov14_021E91E0
	add r0, r4, #0
	mov r2, #0x55
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EDE84: .word ov14_021E91E0
	thumb_func_end ov14_021EDE70

	thumb_func_start ov14_021EDE88
ov14_021EDE88: ; 0x021EDE88
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _021EDF00 ; =0x000005EA
	bl PlaySE
	add r1, r4, #0
	ldr r0, [r4, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r1, r4, #0
	ldr r0, [r4, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	add r0, r4, #0
	bl ov14_021E637C
	add r0, r4, #0
	bl ov14_021F08F0
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
	ldr r1, _021EDF04 ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x56
	bl ov14_021F0234
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021EDF00: .word 0x000005EA
_021EDF04: .word ov14_021E9518
	thumb_func_end ov14_021EDE88

	thumb_func_start ov14_021EDF08
ov14_021EDF08: ; 0x021EDF08
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021EDF24 ; =ov14_021E95B4
	add r0, r4, #0
	mov r2, #0x52
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EDF24: .word ov14_021E95B4
	thumb_func_end ov14_021EDF08

	thumb_func_start ov14_021EDF28
ov14_021EDF28: ; 0x021EDF28
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0xc]
	add r0, #0xe4
	ldr r4, [r0]
	ldr r0, _021EDF8C ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r0, r5, #0
	bl ov14_021F08F0
	ldr r0, [r5, #0x34]
	mov r1, #0x28
	bl ov14_021F6678
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0xff
	bne _021EDF66
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	b _021EDF72
_021EDF66:
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x22
_021EDF72:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x51
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EDF8C: .word 0x000005EA
	thumb_func_end ov14_021EDF28

	thumb_func_start ov14_021EDF90
ov14_021EDF90: ; 0x021EDF90
	push {r3, lr}
	ldr r0, [r0, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #0x51
	pop {r3, pc}
	thumb_func_end ov14_021EDF90

	thumb_func_start ov14_021EDFA0
ov14_021EDFA0: ; 0x021EDFA0
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A24
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EE0A4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EE012
	ldr r2, [r4, #0x34]
	ldr r1, _021EE254 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EDFEC
	ldr r1, _021EE258 ; =ov14_021F7D1C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
_021EDFEC:
	ldr r0, _021EE25C ; =0x000005EB
	bl PlaySE
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0660
	pop {r3, r4, r5, pc}
_021EE012:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EE084
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EE260 ; =ov14_021EA130
	add r0, r4, #0
	mov r2, #0x70
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EE084:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
_021EE0A4:
	add r0, r4, #0
	bl ov14_021F6BC0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EE0E8
	bhs _021EE1AA
	cmp r5, #0xb
	bhi _021EE0DE
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EE0C6: ; jump table
	.short _021EE1FA - _021EE0C6 - 2 ; case 0
	.short _021EE1FA - _021EE0C6 - 2 ; case 1
	.short _021EE1FA - _021EE0C6 - 2 ; case 2
	.short _021EE1FA - _021EE0C6 - 2 ; case 3
	.short _021EE1FA - _021EE0C6 - 2 ; case 4
	.short _021EE1FA - _021EE0C6 - 2 ; case 5
	.short _021EE1D0 - _021EE0C6 - 2 ; case 6
	.short _021EE0FC - _021EE0C6 - 2 ; case 7
	.short _021EE10E - _021EE0C6 - 2 ; case 8
	.short _021EE124 - _021EE0C6 - 2 ; case 9
	.short _021EE13E - _021EE0C6 - 2 ; case 10
	.short _021EE150 - _021EE0C6 - 2 ; case 11
_021EE0DE:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021EE18A
	b _021EE1FA
_021EE0E8:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EE0F2
	beq _021EE1E8
	b _021EE1FA
_021EE0F2:
	add r0, r1, #2
	cmp r5, r0
	bne _021EE0FA
	b _021EE24E
_021EE0FA:
	b _021EE1FA
_021EE0FC:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #4
	mov r2, #0xa9
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE10E:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	mov r0, #8
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE124:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE13E:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE150:
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, _021EE268 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xaa
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE18A:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #6
	bhi _021EE1A0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
_021EE1A0:
	ldr r0, _021EE268 ; =0x000005DC
	bl PlaySE
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
_021EE1AA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #6
	bhi _021EE1C0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
_021EE1C0:
	ldr r0, _021EE268 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x6f
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EE1D0:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE1E8:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE1FA:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EE24E
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EE258 ; =ov14_021F7D1C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #7
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #7
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0794
	pop {r3, r4, r5, pc}
_021EE24E:
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
	nop
_021EE254: .word 0x000040B8
_021EE258: .word ov14_021F7D1C
_021EE25C: .word 0x000005EB
_021EE260: .word ov14_021EA130
_021EE264: .word 0x000005DD
_021EE268: .word 0x000005DC
	thumb_func_end ov14_021EDFA0

	thumb_func_start ov14_021EE26C
ov14_021EE26C: ; 0x021EE26C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r4, [r1]
	sub r4, #0x1e
	add r1, r4, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021EE29A
	ldr r0, _021EE320 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	mov r0, #0x5d
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EE29A:
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r4, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EE2D2
	ldr r0, _021EE320 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x5d
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EE2D2:
	add r0, r4, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021EE2FA
	ldr r0, _021EE320 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x5d
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EE2FA:
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	mov r1, #2
	mov r2, #1
	bl ov14_021F3488
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r1, _021EE324 ; =ov14_021E96C8
	add r0, r5, #0
	mov r2, #0x5e
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EE320: .word 0x000005F3
_021EE324: .word ov14_021E96C8
	thumb_func_end ov14_021EE26C

	thumb_func_start ov14_021EE328
ov14_021EE328: ; 0x021EE328
	ldr r3, _021EE330 ; =ov14_021F0234
	ldr r1, _021EE334 ; =ov14_021E9450
	mov r2, #0xe
	bx r3
	.balign 4, 0
_021EE330: .word ov14_021F0234
_021EE334: .word ov14_021E9450
	thumb_func_end ov14_021EE328

	thumb_func_start ov14_021EE338
ov14_021EE338: ; 0x021EE338
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F4BC0
	add r0, r4, #0
	bl ov14_021F4848
	add r0, r4, #0
	bl ov14_021F48B4
	add r0, r4, #0
	bl ov14_021F57B8
	add r0, r4, #0
	mov r1, #0x5f
	bl ov14_021F10B4
	pop {r4, pc}
	thumb_func_end ov14_021EE338

	thumb_func_start ov14_021EE35C
ov14_021EE35C: ; 0x021EE35C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F60A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8560
	ldr r1, _021EE37C ; =ov14_021E95C8
	add r0, r4, #0
	mov r2, #0x60
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE37C: .word ov14_021E95C8
	thumb_func_end ov14_021EE35C

	thumb_func_start ov14_021EE380
ov14_021EE380: ; 0x021EE380
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	ldr r2, _021EE3C4 ; =0x0000043C
	str r1, [r0, r2]
	ldr r3, [r4, #0x34]
	add r0, r4, #0
	ldr r2, [r3, r2]
	mov r1, #1
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #0
	mov r2, #3
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x61
	pop {r4, pc}
	nop
_021EE3C4: .word 0x0000043C
	thumb_func_end ov14_021EE380

	thumb_func_start ov14_021EE3C8
ov14_021EE3C8: ; 0x021EE3C8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021EE402
	bhs _021EE472
	cmp r0, #9
	bhi _021EE4A4
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021EE3EE: ; jump table
	.short _021EE40C - _021EE3EE - 2 ; case 0
	.short _021EE416 - _021EE3EE - 2 ; case 1
	.short _021EE420 - _021EE3EE - 2 ; case 2
	.short _021EE42A - _021EE3EE - 2 ; case 3
	.short _021EE434 - _021EE3EE - 2 ; case 4
	.short _021EE43E - _021EE3EE - 2 ; case 5
	.short _021EE448 - _021EE3EE - 2 ; case 6
	.short _021EE45A - _021EE3EE - 2 ; case 7
	.short _021EE46A - _021EE3EE - 2 ; case 8
	.short _021EE48A - _021EE3EE - 2 ; case 9
_021EE402:
	mov r1, #1
	mvn r1, r1
	cmp r0, r1
	beq _021EE494
	b _021EE4A4
_021EE40C:
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F1448
	pop {r4, pc}
_021EE416:
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1448
	pop {r4, pc}
_021EE420:
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F1448
	pop {r4, pc}
_021EE42A:
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F1448
	pop {r4, pc}
_021EE434:
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F1448
	pop {r4, pc}
_021EE43E:
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F1448
	pop {r4, pc}
_021EE448:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1504
	pop {r4, pc}
_021EE45A:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1504
	pop {r4, pc}
_021EE46A:
	add r0, r4, #0
	bl ov14_021F1540
	pop {r4, pc}
_021EE472:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021EE4A4
	add r0, r4, #0
	mov r1, #0x71
	bl ov14_021F0244
	pop {r4, pc}
_021EE48A:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021EE494:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F1534
	pop {r4, pc}
_021EE4A4:
	mov r0, #0x61
	pop {r4, pc}
	.balign 4, 0
_021EE4A8: .word 0x000005DC
	thumb_func_end ov14_021EE3C8

	thumb_func_start ov14_021EE4AC
ov14_021EE4AC: ; 0x021EE4AC
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
	bl ov14_021E8588
	ldr r1, _021EE4D4 ; =ov14_021E9604
	add r0, r4, #0
	mov r2, #0x63
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EE4D4: .word ov14_021E9604
	thumb_func_end ov14_021EE4AC

	thumb_func_start ov14_021EE4D8
ov14_021EE4D8: ; 0x021EE4D8
	ldr r3, _021EE4E0 ; =ov14_021F10DC
	mov r1, #0x64
	bx r3
	nop
_021EE4E0: .word ov14_021F10DC
	thumb_func_end ov14_021EE4D8

	thumb_func_start ov14_021EE4E4
ov14_021EE4E4: ; 0x021EE4E4
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F4CA0
	ldr r1, _021EE4F8 ; =ov14_021E98AC
	add r0, r4, #0
	mov r2, #0x65
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE4F8: .word ov14_021E98AC
	thumb_func_end ov14_021EE4E4

	thumb_func_start ov14_021EE4FC
ov14_021EE4FC: ; 0x021EE4FC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	mov r2, #7
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	bl ov14_021F3F6C
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F40E8
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	mov r0, #0xe
	pop {r4, pc}
	thumb_func_end ov14_021EE4FC

	thumb_func_start ov14_021EE538
ov14_021EE538: ; 0x021EE538
	push {r4, lr}
	add r4, r0, #0
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
	bl ov14_021E8588
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r1, _021EE574 ; =ov14_021E99F0
	add r0, r4, #0
	mov r2, #0x67
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE574: .word ov14_021E99F0
	thumb_func_end ov14_021EE538

	thumb_func_start ov14_021EE578
ov14_021EE578: ; 0x021EE578
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x25
	ldrb r1, [r1]
	ldr r0, [r4, #4]
	bl PCStorage_CountMonsAndEggsInBox
	cmp r0, #0x1e
	bne _021EE5A0
	add r0, r4, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x5e
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
_021EE5A0:
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	bl ov14_021F4CA0
	ldr r1, _021EE5C4 ; =ov14_021E98AC
	add r0, r4, #0
	mov r2, #0x68
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE5C4: .word ov14_021E98AC
	thumb_func_end ov14_021EE578

	thumb_func_start ov14_021EE5C8
ov14_021EE5C8: ; 0x021EE5C8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8048
	ldr r1, _021EE5E4 ; =ov14_021E952C
	add r0, r4, #0
	mov r2, #0x69
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE5E4: .word ov14_021E952C
	thumb_func_end ov14_021EE5C8

	thumb_func_start ov14_021EE5E8
ov14_021EE5E8: ; 0x021EE5E8
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x25
	ldrb r2, [r4, #0x1f]
	ldrb r1, [r1]
	strb r1, [r4, #0x1f]
	add r1, r4, #0
	add r1, #0x25
	ldrb r1, [r1]
	cmp r2, r1
	bne _021EE604
	mov r0, #0x6a
	pop {r4, pc}
_021EE604:
	cmp r2, r1
	ldrb r1, [r4, #0x1f]
	bls _021EE62E
	bl ov14_021F2DE8
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021E7930
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0
	bl ov14_021E783C
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r1, _021EE65C ; =ov14_021E92AC
	b _021EE650
_021EE62E:
	bl ov14_021F2DE8
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021E7930
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #1
	bl ov14_021E783C
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r1, _021EE660 ; =ov14_021E9370
_021EE650:
	add r0, r4, #0
	mov r2, #0x6a
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EE65C: .word ov14_021E92AC
_021EE660: .word ov14_021E9370
	thumb_func_end ov14_021EE5E8

	thumb_func_start ov14_021EE664
ov14_021EE664: ; 0x021EE664
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	mov r2, #2
	add r1, #0x22
	strb r2, [r1]
	bl ov14_021F08BC
	ldr r1, _021EE680 ; =ov14_021E9234
	add r0, r4, #0
	mov r2, #0x6b
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE680: .word ov14_021E9234
	thumb_func_end ov14_021EE664

	thumb_func_start ov14_021EE684
ov14_021EE684: ; 0x021EE684
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	ldr r0, _021EE6C8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
	add r0, r5, #0
	bl ov14_021F08F0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8094
	ldr r1, _021EE6CC ; =ov14_021E954C
	add r0, r5, #0
	mov r2, #0x6c
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EE6C8: .word 0x000005EA
_021EE6CC: .word ov14_021E954C
	thumb_func_end ov14_021EE684

	thumb_func_start ov14_021EE6D0
ov14_021EE6D0: ; 0x021EE6D0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021EE6F4 ; =ov14_021E95B4
	add r0, r4, #0
	mov r2, #0x6d
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EE6F4: .word ov14_021E95B4
	thumb_func_end ov14_021EE6D0

	thumb_func_start ov14_021EE6F8
ov14_021EE6F8: ; 0x021EE6F8
	push {r4, lr}
	mov r1, #0
	add r2, r1, #0
	add r4, r0, #0
	bl ov14_021F6AC0
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	mov r0, #0x5b
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE6F8

	thumb_func_start ov14_021EE728
ov14_021EE728: ; 0x021EE728
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	ldr r0, _021EE7B0 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
	add r0, r5, #0
	bl ov14_021F08F0
	ldr r0, [r5, #0x34]
	mov r1, #0x28
	bl ov14_021F6678
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0xff
	bne _021EE78E
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	mov r1, #0x1e
	bl ov14_021E7588
	b _021EE7AC
_021EE78E:
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	ldr r0, [r5, #0x34]
	mov r1, #7
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
_021EE7AC:
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EE7B0: .word 0x000005EA
	thumb_func_end ov14_021EE728

	thumb_func_start ov14_021EE7B4
ov14_021EE7B4: ; 0x021EE7B4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0xc
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7B4

	thumb_func_start ov14_021EE7C4
ov14_021EE7C4: ; 0x021EE7C4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x29
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7C4

	thumb_func_start ov14_021EE7D4
ov14_021EE7D4: ; 0x021EE7D4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x24
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7D4

	thumb_func_start ov14_021EE7E4
ov14_021EE7E4: ; 0x021EE7E4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x5b
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7E4

	thumb_func_start ov14_021EE7F4
ov14_021EE7F4: ; 0x021EE7F4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x5b
	pop {r4, pc}
	thumb_func_end ov14_021EE7F4

	thumb_func_start ov14_021EE810
ov14_021EE810: ; 0x021EE810
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x61
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE810

	thumb_func_start ov14_021EE820
ov14_021EE820: ; 0x021EE820
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x16
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE820

	thumb_func_start ov14_021EE830
ov14_021EE830: ; 0x021EE830
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x3d
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE830

	thumb_func_start ov14_021EE840
ov14_021EE840: ; 0x021EE840
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x42
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE840

	thumb_func_start ov14_021EE850
ov14_021EE850: ; 0x021EE850
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x51
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE850

	thumb_func_start ov14_021EE860
ov14_021EE860: ; 0x021EE860
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x51
	pop {r4, pc}
	thumb_func_end ov14_021EE860

	thumb_func_start ov14_021EE87C
ov14_021EE87C: ; 0x021EE87C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EE976
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EE8CE
	ldr r0, _021EEBDC ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EEBE0 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F18B0
	pop {r3, r4, r5, pc}
_021EE8CE:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EE956
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r1, [r4, #0x34]
	ldr r0, _021EEBE4 ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EE94A
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EE94A:
	ldr r1, _021EEBE8 ; =ov14_021EA674
	add r0, r4, #0
	mov r2, #0x76
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EE956:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x75
	pop {r3, r4, r5, pc}
_021EE976:
	add r0, r4, #0
	bl ov14_021F74B0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EE9BA
	blo _021EE98A
	b _021EEB08
_021EE98A:
	cmp r5, #0x25
	bhi _021EE9AE
	sub r0, #0x1e
	bmi _021EE9B8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EE99E: ; jump table
	.short _021EE9CE - _021EE99E - 2 ; case 0
	.short _021EE9EC - _021EE99E - 2 ; case 1
	.short _021EEA20 - _021EE99E - 2 ; case 2
	.short _021EEA54 - _021EE99E - 2 ; case 3
	.short _021EEA66 - _021EE99E - 2 ; case 4
	.short _021EEB3C - _021EE99E - 2 ; case 5
	.short _021EEA78 - _021EE99E - 2 ; case 6
	.short _021EEA8A - _021EE99E - 2 ; case 7
_021EE9AE:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EE9B8
	b _021EEB66
_021EE9B8:
	b _021EEB92
_021EE9BA:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EE9C6
	bne _021EE9C4
	b _021EEB54
_021EE9C4:
	b _021EEB92
_021EE9C6:
	add r0, r1, #2
	cmp r5, r0
	beq _021EEABE
	b _021EEB92
_021EE9CE:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	bl ov14_021F1128
	pop {r3, r4, r5, pc}
_021EE9EC:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EEA20:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EEA54:
	ldr r0, _021EEBF4 ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #8
	mov r2, #0xab
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEA66:
	ldr r0, _021EEBF4 ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #9
	mov r2, #0xac
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EEA78:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0xad
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEA8A:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xae
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEABE:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	cmp r0, #0x1e
	beq _021EEACC
	b _021EEBD6
_021EEACC:
	ldr r0, _021EEBF8 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _021EEAEC
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EEAEC:
	mov r0, #0x10
	tst r0, r1
	beq _021EEBD6
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EEB08:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EEB1E
	add r0, r4, #0
	bl ov14_021E7588
	b _021EEB2C
_021EEB1E:
	cmp r1, #0x24
	beq _021EEB2C
	cmp r1, #0x25
	beq _021EEB2C
	add r0, r4, #0
	bl ov14_021E765C
_021EEB2C:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x76
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EEB3C:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEB54:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEB66:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EEB7C
	add r0, r4, #0
	bl ov14_021E7588
	b _021EEB8A
_021EEB7C:
	cmp r1, #0x24
	beq _021EEB8A
	cmp r1, #0x25
	beq _021EEB8A
	add r0, r4, #0
	bl ov14_021E765C
_021EEB8A:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	b _021EEBD6
_021EEB92:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EEBD6
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1808
	pop {r3, r4, r5, pc}
_021EEBD6:
	mov r0, #0x75
	pop {r3, r4, r5, pc}
	nop
_021EEBDC: .word 0x000005EB
_021EEBE0: .word 0x000040B8
_021EEBE4: .word 0x000088C8
_021EEBE8: .word ov14_021EA674
_021EEBEC: .word 0x000005DD
_021EEBF0: .word 0x000005DC
_021EEBF4: .word 0x00000632
_021EEBF8: .word gSystem
	thumb_func_end ov14_021EE87C

	thumb_func_start ov14_021EEBFC
ov14_021EEBFC: ; 0x021EEBFC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A44
	cmp r0, #1
	bne _021EEC30
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EEC30:
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EEC72
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021EEC7C
_021EEC72:
	add r0, r4, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
_021EEC7C:
	ldr r1, _021EEC88 ; =ov14_021E9450
	add r0, r4, #0
	mov r2, #0x7b
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EEC88: .word ov14_021E9450
	thumb_func_end ov14_021EEBFC

	thumb_func_start ov14_021EEC8C
ov14_021EEC8C: ; 0x021EEC8C
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x75
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EEC8C

	thumb_func_start ov14_021EEC9C
ov14_021EEC9C: ; 0x021EEC9C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EED0C
	ldr r1, [r5, #0x34]
	ldr r0, _021EED20 ; =0x000088C8
	ldrh r0, [r1, r0]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EED0C
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
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
	ldr r0, _021EED24 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #4
	mov r2, #0x25
	bl ov14_021F68C0
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EED0C:
	add r0, r5, #0
	mov r1, #2
	mov r2, #0x25
	bl ov14_021F68C0
	add r0, r5, #0
	mov r1, #2
	bl ov14_021F0254
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EED20: .word 0x000088C8
_021EED24: .word 0x000005F3
	thumb_func_end ov14_021EEC9C

	thumb_func_start ov14_021EED28
ov14_021EED28: ; 0x021EED28
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EEDAE
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021EED48
	sub r4, #0x1e
	lsl r0, r4, #0x10
	lsr r4, r0, #0x10
_021EED48:
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
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	add r0, r5, #0
	mov r1, #3
	mov r2, #0x25
	bl ov14_021F68C0
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5FBC
	ldr r1, [r5, #0x34]
	ldr r0, _021EEDB4 ; =0x000088C8
	mov r2, #0
	strh r2, [r1, r0]
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EEDAE:
	mov r0, #0x79
	pop {r3, r4, r5, pc}
	nop
_021EEDB4: .word 0x000088C8
	thumb_func_end ov14_021EED28

	thumb_func_start ov14_021EEDB8
ov14_021EEDB8: ; 0x021EEDB8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r4, [r1]
	cmp r4, #0x1e
	bhs _021EEDEA
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021EEDF8
_021EEDEA:
	sub r4, #0x1e
	lsl r1, r4, #0x10
	lsr r4, r1, #0x10
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
_021EEDF8:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
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
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
	ldr r0, [r5, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EEE78
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021EEE82
_021EEE78:
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
_021EEE82:
	ldr r1, _021EEE90 ; =ov14_021E9450
	add r0, r5, #0
	mov r2, #0x7b
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EEE90: .word ov14_021E9450
	thumb_func_end ov14_021EEDB8

	thumb_func_start ov14_021EEE94
ov14_021EEE94: ; 0x021EEE94
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EEEA8
	mov r0, #0x7b
	pop {r4, pc}
_021EEEA8:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	add r4, #0x21
	ldrb r0, [r4]
	cmp r0, #0x1e
	blo _021EEED0
	mov r0, #0x8b
	pop {r4, pc}
_021EEED0:
	mov r0, #0x75
	pop {r4, pc}
	thumb_func_end ov14_021EEE94

	thumb_func_start ov14_021EEED4
ov14_021EEED4: ; 0x021EEED4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021EEEE6
	sub r4, #0x1e
	lsl r0, r4, #0x10
	lsr r4, r0, #0x10
_021EEEE6:
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
	ldr r0, _021EEF30 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #5
	mov r2, #0x25
	bl ov14_021F68C0
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EEF30: .word 0x000005F3
	thumb_func_end ov14_021EEED4

	thumb_func_start ov14_021EEF34
ov14_021EEF34: ; 0x021EEF34
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021EEF46
	sub r4, #0x1e
	lsl r0, r4, #0x10
	lsr r4, r0, #0x10
_021EEF46:
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
	ldrh r1, [r5, #0x1c]
	add r0, r5, #0
	mov r2, #0x25
	bl ov14_021F6768
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021EEF34

	thumb_func_start ov14_021EEF8C
ov14_021EEF8C: ; 0x021EEF8C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r2, [r5, #0x34]
	add r0, #0x21
	ldr r4, [r2, #0xc]
	ldrb r0, [r0]
	ldrh r1, [r4]
	cmp r1, r0
	beq _021EEFA6
	ldr r0, _021EF01C ; =0x000088C8
	ldrh r0, [r2, r0]
	cmp r0, #0
	bne _021EEFE2
_021EEFA6:
	add r0, r5, #0
	bl ov14_021F1F38
	ldr r1, [r5, #0x34]
	ldr r0, _021EF01C ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EEFCA
	ldr r0, _021EF020 ; =0x000005EA
	bl PlaySE
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
_021EEFCA:
	ldr r0, [r5, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x75
	pop {r3, r4, r5, pc}
_021EEFE2:
	ldr r0, _021EF020 ; =0x000005EA
	bl PlaySE
	ldrh r1, [r4]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #1
	bl ov14_021F34C8
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x7f
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF01C: .word 0x000088C8
_021EF020: .word 0x000005EA
	thumb_func_end ov14_021EEF8C

	thumb_func_start ov14_021EF024
ov14_021EF024: ; 0x021EF024
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EF038
	mov r0, #0x7f
	pop {r3, r4, r5, r6, r7, pc}
_021EF038:
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r2, #6
	ldr r4, [r0, #0xc]
	add r0, r5, #0
	ldrh r1, [r4]
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldrh r1, [r4]
	ldr r6, [r5, #0x34]
	ldr r3, _021EF17C ; =0x000088C8
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	ldrb r1, [r5, #0x1f]
	ldrh r2, [r4]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF092
	ldrh r2, [r4]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF180 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF092:
	ldrh r1, [r4]
	add r0, r5, #0
	bl ov14_021E7588
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	ldr r3, _021EF17C ; =0x000088C8
	add r1, #0x21
	strh r7, [r0, r3]
	ldr r6, [r5, #0x34]
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF0DE
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF180 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF0DE:
	ldr r1, [r5, #0x34]
	ldr r0, _021EF17C ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	bne _021EF13E
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r1, _021EF184 ; =ov14_021E94BC
	add r0, r5, #0
	mov r2, #0x75
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
_021EF13E:
	ldr r0, _021EF188 ; =0x000005EB
	bl PlaySE
	ldr r0, [r5, #0x34]
	ldr r1, _021EF17C ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r1, _021EF18C ; =ov14_021EA728
	add r0, r5, #0
	mov r2, #0x80
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF17C: .word 0x000088C8
_021EF180: .word 0x00004094
_021EF184: .word ov14_021E94BC
_021EF188: .word 0x000005EB
_021EF18C: .word ov14_021EA728
	thumb_func_end ov14_021EF024

	thumb_func_start ov14_021EF190
ov14_021EF190: ; 0x021EF190
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r2, #0
	ldr r4, [r0, #0xc]
	ldrh r1, [r4]
	bl ov14_021F34C8
	ldr r0, _021EF1E8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	ldrh r1, [r4]
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	mov r0, #0x81
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF1E8: .word 0x000005EA
	thumb_func_end ov14_021EF190

	thumb_func_start ov14_021EF1EC
ov14_021EF1EC: ; 0x021EF1EC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EF200
	mov r0, #0x81
	pop {r4, pc}
_021EF200:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021EF244 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x75
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EF244: .word ov14_021E94BC
	thumb_func_end ov14_021EF1EC

	thumb_func_start ov14_021EF248
ov14_021EF248: ; 0x021EF248
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A34
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EF2E2
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF28C
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F19F0
	pop {r3, r4, r5, pc}
_021EF28C:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	add r5, #0x1e
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF2C4
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF2C4:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF2DE
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF2DE:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF2E2:
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EF370
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF31C
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F19F0
	pop {r3, r4, r5, pc}
_021EF31C:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF352
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF352:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF36C
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF36C:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF370:
	add r0, r4, #0
	bl ov14_021F7B7C
	cmp r0, #1
	bne _021EF3B8
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r5, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF3B4
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	strb r5, [r0]
	add r0, r4, #0
	mov r1, #1
	add r0, #0x26
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0x97
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EF3B4:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF3B8:
	add r0, r4, #0
	bl ov14_021F70C0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EF3FE
	blo _021EF3CC
	b _021EF5A6
_021EF3CC:
	cmp r5, #0x2d
	bhi _021EF3F4
	sub r0, #0x24
	bmi _021EF3FC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EF3E0: ; jump table
	.short _021EF63A - _021EF3E0 - 2 ; case 0
	.short _021EF414 - _021EF3E0 - 2 ; case 1
	.short _021EF42A - _021EF3E0 - 2 ; case 2
	.short _021EF440 - _021EF3E0 - 2 ; case 3
	.short _021EF456 - _021EF3E0 - 2 ; case 4
	.short _021EF46C - _021EF3E0 - 2 ; case 5
	.short _021EF482 - _021EF3E0 - 2 ; case 6
	.short _021EF498 - _021EF3E0 - 2 ; case 7
	.short _021EF50A - _021EF3E0 - 2 ; case 8
	.short _021EF57A - _021EF3E0 - 2 ; case 9
_021EF3F4:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021EF410
_021EF3FC:
	b _021EF6A2
_021EF3FE:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EF40A
	bne _021EF408
	b _021EF64C
_021EF408:
	b _021EF6A2
_021EF40A:
	add r0, r1, #2
	cmp r5, r0
	bne _021EF412
_021EF410:
	b _021EF6C4
_021EF412:
	b _021EF6A2
_021EF414:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF42A:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF440:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF456:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF46C:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF482:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF498:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF4EC
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF4EC:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF506
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF506:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF50A:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF55C
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF55C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF576
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF576:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF57A:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0xaf
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EF5A6:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x24
	bhs _021EF600
	add r0, r4, #0
	bl ov14_021E7588
	cmp r0, #1
	ldr r1, [r4, #0x34]
	bne _021EF5E4
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #0
	bne _021EF622
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	b _021EF622
_021EF5E4:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF622
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
	b _021EF622
_021EF600:
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF622
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
_021EF622:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021EF6C4
	add r0, r4, #0
	mov r1, #0x83
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EF63A:
	ldr r0, _021EF6D0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EF64C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021EF66E
	ldr r0, _021EF6D0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EF66E:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF6A2:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF6C4
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1B4C
	pop {r3, r4, r5, pc}
_021EF6C4:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF6C8: .word 0x000005DD
_021EF6CC: .word 0x000005DC
_021EF6D0: .word 0x00000633
	thumb_func_end ov14_021EF248

	thumb_func_start ov14_021EF6D4
ov14_021EF6D4: ; 0x021EF6D4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x82
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EF6D4

	thumb_func_start ov14_021EF6E4
ov14_021EF6E4: ; 0x021EF6E4
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F40DC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
	mov r0, #0x85
	pop {r4, pc}
	thumb_func_end ov14_021EF6E4

	thumb_func_start ov14_021EF6FC
ov14_021EF6FC: ; 0x021EF6FC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r1, [r5, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r4, [r1, #0xc]
	mov r1, #0x10
	bl sub_020199E4
	cmp r0, #0
	beq _021EF718
	mov r0, #0x85
	pop {r3, r4, r5, r6, r7, pc}
_021EF718:
	add r0, r5, #0
	add r0, #0x21
	ldrh r1, [r4]
	ldrb r0, [r0]
	cmp r1, r0
	bne _021EF784
	add r0, r5, #0
	ldrh r4, [r4, #2]
	bl ov14_021F1F38
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r1, [r5, #0x34]
	ldr r0, _021EF898 ; =0x000088C8
	ldrh r0, [r1, r0]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EF776
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r4, r0
	beq _021EF776
	ldr r0, _021EF89C ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0x25
	bl ov14_021F6730
	mov r0, #0x87
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021EF776:
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r3, r4, r5, r6, r7, pc}
_021EF784:
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #1
	bl ov14_021F34C8
	ldrh r1, [r4]
	add r0, r5, #0
	mov r2, #6
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldrh r1, [r4]
	ldr r6, [r5, #0x34]
	ldr r3, _021EF898 ; =0x000088C8
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	ldrb r1, [r5, #0x1f]
	ldrh r2, [r4]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF7DE
	ldrh r2, [r4]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF8A0 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF7DE:
	ldrh r1, [r4]
	add r0, r5, #0
	bl ov14_021E7588
	ldrh r1, [r4]
	ldr r0, [r5, #0x34]
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	ldr r3, _021EF898 ; =0x000088C8
	add r1, #0x21
	strh r7, [r0, r3]
	ldr r6, [r5, #0x34]
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF838
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF8A0 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF838:
	ldr r0, [r5, #0x34]
	ldr r1, _021EF898 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _021EF85E
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r3, r4, r5, r6, r7, pc}
_021EF85E:
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r0, _021EF8A4 ; =0x000005EB
	bl PlaySE
	ldr r1, _021EF8A8 ; =ov14_021EA928
	add r0, r5, #0
	mov r2, #0x86
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF898: .word 0x000088C8
_021EF89C: .word 0x000005F3
_021EF8A0: .word 0x00004094
_021EF8A4: .word 0x000005EB
_021EF8A8: .word ov14_021EA928
	thumb_func_end ov14_021EF6FC

	thumb_func_start ov14_021EF8AC
ov14_021EF8AC: ; 0x021EF8AC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r2, #0
	ldr r7, [r0, #0xc]
	ldrh r1, [r7]
	bl ov14_021F34C8
	add r0, r5, #0
	add r0, #0x21
	ldrb r6, [r0]
	add r0, r5, #0
	ldrh r4, [r7, #2]
	ldrh r1, [r7]
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	ldr r3, [r5, #0x34]
	ldr r1, _021EF918 ; =0x000088C8
	mov r2, #0
	ldrh r0, [r3, r1]
	strh r2, [r3, r1]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EF908
	cmp r4, r6
	beq _021EF908
	ldr r0, _021EF91C ; =0x000005F3
	bl PlaySE
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	mov r1, #0x25
	bl ov14_021F6730
	mov r0, #0x87
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021EF908:
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF918: .word 0x000088C8
_021EF91C: .word 0x000005F3
	thumb_func_end ov14_021EF8AC

	thumb_func_start ov14_021EF920
ov14_021EF920: ; 0x021EF920
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6688
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EF920

	thumb_func_start ov14_021EF93C
ov14_021EF93C: ; 0x021EF93C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov14_021F7A50
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_IsButtonInputMode
	cmp r0, #0
	bne _021EF956
	mov r4, #1
	mvn r4, r4
_021EF956:
	cmp r4, #0x24
	bhi _021EF95E
	beq _021EF990
	b _021EF9A0
_021EF95E:
	add r0, r4, #4
	cmp r0, #3
	bhi _021EF9A0
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EF970: ; jump table
	.short _021EF988 - _021EF970 - 2 ; case 0
	.short _021EF978 - _021EF970 - 2 ; case 1
	.short _021EF990 - _021EF970 - 2 ; case 2
	.short _021EF9B0 - _021EF970 - 2 ; case 3
_021EF978:
	ldr r0, _021EF9B4 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	mov r1, #0x89
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EF988:
	ldr r0, _021EF9B4 ; =0x000005DC
	bl PlaySE
	b _021EF9B0
_021EF990:
	ldr r0, _021EF9B8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	mov r1, #0xff
	bl ov14_021F1C4C
	pop {r3, r4, r5, pc}
_021EF9A0:
	ldr r0, _021EF9B8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F1C4C
	pop {r3, r4, r5, pc}
_021EF9B0:
	mov r0, #0x88
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF9B4: .word 0x000005DC
_021EF9B8: .word 0x000005EA
	thumb_func_end ov14_021EF93C

	thumb_func_start ov14_021EF9BC
ov14_021EF9BC: ; 0x021EF9BC
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x88
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EF9BC

	thumb_func_start ov14_021EF9CC
ov14_021EF9CC: ; 0x021EF9CC
	push {r4, r5, r6, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	mov r2, #0
	ldrb r1, [r0, r1]
	bl ov14_021F34C8
	ldr r0, [r4, #0x34]
	ldr r2, _021EFB48 ; =0x0000044C
	ldr r3, _021EFB4C ; =0x000088CA
	ldrb r1, [r0, r2]
	ldrh r5, [r0, r3]
	cmp r1, r5
	bne _021EFA12
	mov r5, #0
	sub r1, r3, #2
	strh r5, [r0, r1]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	ldrb r1, [r1, r2]
	bl ov14_021E7588
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	ldr r1, _021EFB50 ; =ov14_021E9970
	add r0, r4, #0
	mov r2, #0x82
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
_021EFA12:
	add r0, r4, #0
	mov r2, #6
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	ldr r3, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	ldr r6, _021EFB54 ; =0x000088C8
	ldrb r1, [r3, r1]
	add r0, r4, #0
	mov r2, #6
	add r3, r3, r6
	bl ov14_021E6094
	ldr r3, [r4, #0x34]
	ldr r2, _021EFB48 ; =0x0000044C
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r3, r2]
	add r0, r4, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFA5C
	ldr r3, [r4, #0x34]
	ldr r0, _021EFB48 ; =0x0000044C
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r3, r0]
	add r0, r4, #0
	add r6, r3, r2
	ldr r3, _021EFB58 ; =0x00004094
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EFA5C:
	ldr r2, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	add r0, r4, #0
	ldrb r1, [r2, r1]
	bl ov14_021E7588
	ldr r3, _021EFB54 ; =0x000088C8
	ldr r0, [r4, #0x34]
	add r1, r3, #2
	strh r5, [r0, r3]
	ldr r5, [r4, #0x34]
	add r0, r4, #0
	ldrh r1, [r5, r1]
	mov r2, #6
	add r3, r5, r3
	bl ov14_021E6094
	ldr r3, [r4, #0x34]
	ldr r2, _021EFB4C ; =0x000088CA
	ldrb r1, [r4, #0x1f]
	ldrh r2, [r3, r2]
	add r0, r4, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFAA8
	ldr r3, [r4, #0x34]
	ldr r0, _021EFB4C ; =0x000088CA
	ldrb r1, [r4, #0x1f]
	ldrh r2, [r3, r0]
	add r0, r4, #0
	add r5, r3, r2
	ldr r3, _021EFB58 ; =0x00004094
	ldrb r3, [r5, r3]
	bl ov14_021F2ED0
_021EFAA8:
	ldr r2, [r4, #0x34]
	ldr r0, _021EFB54 ; =0x000088C8
	ldrh r0, [r2, r0]
	cmp r0, #0
	bne _021EFAC8
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	bl ov14_021E8620
	ldr r1, _021EFB50 ; =ov14_021E9970
	add r0, r4, #0
	mov r2, #0x82
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
_021EFAC8:
	ldr r0, _021EFB5C ; =0x0000044B
	mov r1, #1
	strb r1, [r2, r0]
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	mov r2, #2
	ldrb r1, [r0, r1]
	bl ov14_021F39A0
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB54 ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r2, [r4, #0x34]
	ldr r1, _021EFB54 ; =0x000088C8
	add r0, r4, #0
	ldrh r1, [r2, r1]
	bl ov14_021F5564
	add r5, r0, #0
	mov r0, #0x2f
	ldr r3, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r3, r0]
	add r3, #0x30
	lsl r2, r5, #4
	mov r1, #0x10
	add r2, r3, r2
	bl sub_02019A60
	mov r0, #0x2f
	add r3, r5, #1
	ldr r2, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	add r2, #0x30
	lsl r3, r3, #4
	mov r1, #0x10
	add r2, r2, r3
	bl sub_02019A60
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB54 ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F38B0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88BC
	ldr r1, _021EFB60 ; =ov14_021EAA04
	add r0, r4, #0
	mov r2, #0x88
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EFB48: .word 0x0000044C
_021EFB4C: .word 0x000088CA
_021EFB50: .word ov14_021E9970
_021EFB54: .word 0x000088C8
_021EFB58: .word 0x00004094
_021EFB5C: .word 0x0000044B
_021EFB60: .word ov14_021EAA04
	thumb_func_end ov14_021EF9CC

	thumb_func_start ov14_021EFB64
ov14_021EFB64: ; 0x021EFB64
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A24
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EFC52
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EFBBC
	ldr r0, _021EFDC8 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EFDCC ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1D6C
	pop {r3, r4, r5, pc}
_021EFBBC:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EFC32
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r1, [r4, #0x34]
	ldr r0, _021EFDD0 ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EFC26
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EFC26:
	ldr r1, _021EFDD4 ; =ov14_021EA674
	add r0, r4, #0
	mov r2, #0x8c
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EFC32:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x8b
	pop {r3, r4, r5, pc}
_021EFC52:
	add r0, r4, #0
	bl ov14_021F75C8
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EFC92
	bhs _021EFCCA
	cmp r5, #9
	bhi _021EFC88
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EFC74: ; jump table
	.short _021EFD7A - _021EFC74 - 2 ; case 0
	.short _021EFD7A - _021EFC74 - 2 ; case 1
	.short _021EFD7A - _021EFC74 - 2 ; case 2
	.short _021EFD7A - _021EFC74 - 2 ; case 3
	.short _021EFD7A - _021EFC74 - 2 ; case 4
	.short _021EFD7A - _021EFC74 - 2 ; case 5
	.short _021EFCA6 - _021EFC74 - 2 ; case 6
	.short _021EFD00 - _021EFC74 - 2 ; case 7
	.short _021EFCB8 - _021EFC74 - 2 ; case 8
	.short _021EFD12 - _021EFC74 - 2 ; case 9
_021EFC88:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021EFD4C
	b _021EFD7A
_021EFC92:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EFC9C
	beq _021EFD00
	b _021EFD7A
_021EFC9C:
	add r0, r1, #2
	cmp r5, r0
	bne _021EFCA4
	b _021EFDC4
_021EFCA4:
	b _021EFD7A
_021EFCA6:
	ldr r0, _021EFDD8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	mov r2, #0xb0
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EFCB8:
	ldr r0, _021EFDD8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0xad
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EFCCA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EFCE2
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EFCF0
_021EFCE2:
	cmp r1, #8
	beq _021EFCF0
	cmp r1, #9
	beq _021EFCF0
	add r0, r4, #0
	bl ov14_021E765C
_021EFCF0:
	ldr r0, _021EFDDC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x8c
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EFD00:
	ldr r0, _021EFDE0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x9f
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EFD12:
	ldr r0, _021EFDDC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xb1
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EFD4C:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EFD64
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EFD72
_021EFD64:
	cmp r1, #8
	beq _021EFD72
	cmp r1, #9
	beq _021EFD72
	add r0, r4, #0
	bl ov14_021E765C
_021EFD72:
	ldr r0, _021EFDDC ; =0x000005DC
	bl PlaySE
	b _021EFDC4
_021EFD7A:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EFDC4
	ldr r0, _021EFDD8 ; =0x000005DD
	bl PlaySE
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #8
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1CDC
	pop {r3, r4, r5, pc}
_021EFDC4:
	mov r0, #0x8b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EFDC8: .word 0x000005EB
_021EFDCC: .word 0x000040B8
_021EFDD0: .word 0x000088C8
_021EFDD4: .word ov14_021EA674
_021EFDD8: .word 0x000005DD
_021EFDDC: .word 0x000005DC
_021EFDE0: .word 0x00000633
	thumb_func_end ov14_021EFB64

	thumb_func_start ov14_021EFDE4
ov14_021EFDE4: ; 0x021EFDE4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x8b
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EFDE4

	thumb_func_start ov14_021EFDF4
ov14_021EFDF4: ; 0x021EFDF4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r4, #0
	ldr r5, [r0, #0xc]
	add r1, #0x21
	ldrh r2, [r5]
	ldrb r1, [r1]
	cmp r2, r1
	beq _021EFE10
	ldr r1, _021EFEF0 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _021EFEB0
_021EFE10:
	add r0, r4, #0
	ldrh r5, [r5, #2]
	bl ov14_021F1F38
	ldr r0, [r4, #0x34]
	ldr r1, _021EFEF4 ; =0x0000044A
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021EFE6C
	ldr r1, _021EFEF0 ; =0x000088C8
	ldrh r0, [r0, r1]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EFE7A
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r5, r0
	beq _021EFE7A
	ldr r0, _021EFEF8 ; =0x000005F3
	bl PlaySE
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #7
	bl sub_0201980C
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x28
	bl ov14_021F68C0
	mov r0, #0x92
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EFE6C:
	mov r1, #0x28
	bl ov14_021F6654
	ldr r1, [r4, #0x34]
	ldr r0, _021EFEF4 ; =0x0000044A
	mov r2, #0
	strb r2, [r1, r0]
_021EFE7A:
	ldr r1, [r4, #0x34]
	ldr r0, _021EFEF0 ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EFE98
	ldr r0, _021EFEFC ; =0x000005EA
	bl PlaySE
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
_021EFE98:
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x8b
	pop {r3, r4, r5, pc}
_021EFEB0:
	mov r1, #0x28
	bl ov14_021F6654
	ldr r0, _021EFEFC ; =0x000005EA
	bl PlaySE
	ldrh r1, [r5]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #1
	bl ov14_021F34C8
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x8e
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EFEF0: .word 0x000088C8
_021EFEF4: .word 0x0000044A
_021EFEF8: .word 0x000005F3
_021EFEFC: .word 0x000005EA
	thumb_func_end ov14_021EFDF4

	thumb_func_start ov14_021EFF00
ov14_021EFF00: ; 0x021EFF00
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EFF14
	mov r0, #0x8e
	pop {r3, r4, r5, r6, r7, pc}
_021EFF14:
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r2, #6
	ldr r4, [r0, #0xc]
	add r0, r5, #0
	ldrh r1, [r4]
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldrh r1, [r4]
	ldr r6, [r5, #0x34]
	ldr r3, _021F0084 ; =0x000088C8
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	ldrb r1, [r5, #0x1f]
	ldrh r2, [r4]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFF6E
	ldrh r2, [r4]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021F0088 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EFF6E:
	ldrh r1, [r4]
	add r0, r5, #0
	bl ov14_021E7588
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	ldr r3, _021F0084 ; =0x000088C8
	add r1, #0x21
	strh r7, [r0, r3]
	ldr r6, [r5, #0x34]
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFFBA
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021F0088 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EFFBA:
	ldr r0, [r5, #0x34]
	ldr r1, _021F0084 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _021F0046
	ldr r1, _021F008C ; =0x0000044A
	ldrb r2, [r0, r1]
	cmp r2, #0
	bne _021F0006
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021F0090 ; =ov14_021E94BC
	add r0, r5, #0
	mov r2, #0x8f
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
_021F0006:
	mov r2, #0
	strb r2, [r0, r1]
	add r0, r5, #0
	bl ov14_021F1F38
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	ldr r1, _021F0094 ; =ov14_021E9518
	add r0, r5, #0
	mov r2, #0x8f
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
_021F0046:
	ldr r0, _021F0098 ; =0x000005EB
	bl PlaySE
	ldr r0, [r5, #0x34]
	ldr r1, _021F0084 ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r1, _021F009C ; =ov14_021EAF08
	add r0, r5, #0
	mov r2, #0x90
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0084: .word 0x000088C8
_021F0088: .word 0x00004094
_021F008C: .word 0x0000044A
_021F0090: .word ov14_021E94BC
_021F0094: .word ov14_021E9518
_021F0098: .word 0x000005EB
_021F009C: .word ov14_021EAF08
	thumb_func_end ov14_021EFF00

	thumb_func_start ov14_021F00A0
ov14_021F00A0: ; 0x021F00A0
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x8b
	pop {r4, pc}
	thumb_func_end ov14_021F00A0

	thumb_func_start ov14_021F00BC
ov14_021F00BC: ; 0x021F00BC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r2, #0
	ldr r4, [r0, #0xc]
	ldrh r1, [r4]
	bl ov14_021F34C8
	ldr r0, _021F011C ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021F00FC
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
_021F00FC:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	bl ov14_021F1F38
	mov r0, #0x91
	pop {r3, r4, r5, pc}
	nop
_021F011C: .word 0x000005EA
	thumb_func_end ov14_021F00BC

	thumb_func_start ov14_021F0120
ov14_021F0120: ; 0x021F0120
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021F0134
	mov r0, #0x91
	pop {r4, pc}
_021F0134:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021F0160 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x8f
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0160: .word ov14_021E94BC
	thumb_func_end ov14_021F0120

	thumb_func_start ov14_021F0164
ov14_021F0164: ; 0x021F0164
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x28
	bl ov14_021F6654
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #7
	bl sub_020197F4
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x8b
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0164

	thumb_func_start ov14_021F0198
ov14_021F0198: ; 0x021F0198
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F01B4 ; =0x000005F3
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x25
	bl ov14_021F68C0
	mov r0, #0xe
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	.balign 4, 0
_021F01B4: .word 0x000005F3
	thumb_func_end ov14_021F0198

	thumb_func_start ov14_021F01B8
ov14_021F01B8: ; 0x021F01B8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F01D4 ; =0x000005F3
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x25
	bl ov14_021F6724
	mov r0, #0xe
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	nop
_021F01D4: .word 0x000005F3
	thumb_func_end ov14_021F01B8

	thumb_func_start ov14_021F01D8
ov14_021F01D8: ; 0x021F01D8
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #6
	add r4, r1, #0
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0xa
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0x11
	ldr r1, [r5, #0x34]
	lsl r0, r0, #6
	str r4, [r1, r0]
	mov r0, #2
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov14_021F01D8

	thumb_func_start ov14_021F0204
ov14_021F0204: ; 0x021F0204
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0xa
	str r0, [sp, #8]
	mov r0, #0
	add r4, r1, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0x11
	ldr r1, [r5, #0x34]
	lsl r0, r0, #6
	str r4, [r1, r0]
	mov r0, #2
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0204

	thumb_func_start ov14_021F0234
ov14_021F0234: ; 0x021F0234
	push {r3, lr}
	str r2, [r0, #0x30]
	ldr r0, [r0, #0x34]
	bl ov14_021E5A44
	mov r0, #5
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0234

	thumb_func_start ov14_021F0244
ov14_021F0244: ; 0x021F0244
	push {r3, lr}
	str r1, [r0, #0x30]
	ldr r0, [r0, #0x34]
	bl ov14_021E5A54
	mov r0, #5
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0244

	thumb_func_start ov14_021F0254
ov14_021F0254: ; 0x021F0254
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #1
	bne _021F0266
	mov r1, #1
	bl ov14_021E5EFC
	b _021F026C
_021F0266:
	mov r1, #0
	bl ov14_021E5EFC
_021F026C:
	ldr r1, [r5, #0x34]
	ldr r0, _021F0278 ; =0x00000438
	strh r4, [r1, r0]
	mov r0, #7
	pop {r3, r4, r5, pc}
	nop
_021F0278: .word 0x00000438
	thumb_func_end ov14_021F0254

	thumb_func_start ov14_021F027C
ov14_021F027C: ; 0x021F027C
	ldr r3, _021F0288 ; =ov14_021F0204
	strb r1, [r0, #0x1e]
	mov r1, #9
	str r1, [r0, #0x30]
	mov r1, #1
	bx r3
	.balign 4, 0
_021F0288: .word ov14_021F0204
	thumb_func_end ov14_021F027C
