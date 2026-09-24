	.include "asm/macros.inc"
	.include "overlay_40.inc"
	.include "global.inc"


	.text

	thumb_func_start ov40_0223EDA8
ov40_0223EDA8: ; 0x0223EDA8
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	ldr r0, _0223EDD4 ; =0x000004D4
	ldr r0, [r4, r0]
	bl DestroyMsgData
	ldr r0, _0223EDD8 ; =0x000004DC
	ldr r0, [r4, r0]
	bl Heap_Free
	mov r0, #0x4d
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl Heap_Free
	ldr r0, _0223EDDC ; =0x000004D8
	mov r1, #0
	str r1, [r4, r0]
	pop {r4, pc}
	nop
_0223EDD4: .word 0x000004D4
_0223EDD8: .word 0x000004DC
_0223EDDC: .word 0x000004D8
	thumb_func_end ov40_0223EDA8

	thumb_func_start ov40_0223EDE0
ov40_0223EDE0: ; 0x0223EDE0
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #4
	bls _0223EDF2
	b _0223EF7C
_0223EDF2:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223EDFE: ; jump table
	.short _0223EE08 - _0223EDFE - 2 ; case 0
	.short _0223EE3E - _0223EDFE - 2 ; case 1
	.short _0223EEB6 - _0223EDFE - 2 ; case 2
	.short _0223EF1A - _0223EDFE - 2 ; case 3
	.short _0223EF3A - _0223EDFE - 2 ; case 4
_0223EE08:
	mov r1, #0x73
	bl ov40_0222DF60
	ldr r2, _0223EF88 ; =0x000004C3
	mov r1, #0xff
	strb r1, [r5, r2]
	add r0, r2, #1
	strb r1, [r5, r0]
	ldrb r1, [r5, r2]
	add r2, r2, #1
	ldrb r2, [r5, r2]
	add r0, r4, #0
	bl ov40_0223DDE8
	add r0, r4, #0
	mov r1, #1
	bl ov40_022420B4
	add r0, r4, #0
	mov r1, #0x39
	mov r2, #7
	bl ov40_022307DC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223EF84
_0223EE3E:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223EE9C
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223EF8C ; =0x0000047C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F9D4
	ldr r0, _0223EF90 ; =0x0000049C
	ldr r2, _0223EF94 ; =ov40_0224572C
	add r0, r4, r0
	add r1, r4, #0
	bl ov40_0222E8C4
	ldr r1, _0223EF8C ; =0x0000047C
	add r0, r4, r1
	add r1, #0x20
	add r1, r4, r1
	bl ov40_0222FA5C
	ldr r0, _0223EF90 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	mov r2, #2
	bl ov40_0222F740
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223EE9C:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223EF84
_0223EEB6:
	ldr r0, _0223EF8C ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA88
	ldr r1, _0223EF90 ; =0x0000049C
	add r0, r4, r1
	sub r1, #0x10
	ldrsh r1, [r4, r1]
	bl ov40_0222F6D0
	ldr r0, _0223EF90 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F38C
	cmp r0, #0
	beq _0223EF02
	ldr r0, _0223EF98 ; =0x0000088C
	ldr r0, [r4, r0]
	bl sub_02031620
	ldr r1, _0223EF88 ; =0x000004C3
	strb r0, [r5, r1]
	ldr r0, _0223EF98 ; =0x0000088C
	ldr r0, [r4, r0]
	bl sub_0203162C
	ldr r2, _0223EF9C ; =0x000004C4
	strb r0, [r5, r2]
	sub r1, r2, #1
	ldrb r1, [r5, r1]
	ldrb r2, [r5, r2]
	add r0, r4, #0
	bl ov40_0223DDE8
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223EF02:
	ldr r0, _0223EFA0 ; =ov40_02245650
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0223EF84
	add r0, r4, #0
	bl ov40_02230944
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223EF84
_0223EF1A:
	ldr r0, _0223EF8C ; =0x0000047C
	add r0, r4, r0
	bl ov40_0222FA24
	ldr r0, _0223EF90 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F720
	ldr r0, _0223EF90 ; =0x0000049C
	add r1, r4, #0
	add r0, r4, r0
	bl ov40_0222F920
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223EF3A:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223EF62
	add r0, r4, #0
	mov r1, #0
	bl ov40_022420B4
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223EF62:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223EF84
_0223EF7C:
	add r0, r4, #0
	mov r1, #0xb
	bl ov40_0222BF80
_0223EF84:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223EF88: .word 0x000004C3
_0223EF8C: .word 0x0000047C
_0223EF90: .word 0x0000049C
_0223EF94: .word ov40_0224572C
_0223EF98: .word 0x0000088C
_0223EF9C: .word 0x000004C4
_0223EFA0: .word ov40_02245650
	thumb_func_end ov40_0223EDE0

	thumb_func_start ov40_0223EFA4
ov40_0223EFA4: ; 0x0223EFA4
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223EFBA
	cmp r1, #1
	beq _0223EFD4
	b _0223F01E
_0223EFBA:
	mov r1, #0x38
	mov r2, #3
	bl ov40_022307DC
	add r0, r5, #0
	mov r1, #0x3b
	mov r2, #7
	bl ov40_022307DC
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223F024
_0223EFD4:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223F004
	add r0, r5, #0
	mov r1, #0x7c
	bl ov40_0222DF60
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223DF1C
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F004:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223F024
_0223F01E:
	mov r1, #3
	bl ov40_0222BF80
_0223F024:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_0223EFA4

	thumb_func_start ov40_0223F028
ov40_0223F028: ; 0x0223F028
	push {r4, r5, r6, lr}
	sub sp, #8
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	bl ov40_0223D5CC
	cmp r0, #0
	bne _0223F042
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_0223F042:
	ldr r0, [r4, #8]
	cmp r0, #3
	bhi _0223F126
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223F054: ; jump table
	.short _0223F05C - _0223F054 - 2 ; case 0
	.short _0223F072 - _0223F054 - 2 ; case 1
	.short _0223F0B2 - _0223F054 - 2 ; case 2
	.short _0223F0FC - _0223F054 - 2 ; case 3
_0223F05C:
	add r0, r4, #0
	mov r1, #0x75
	bl ov40_0222DF60
	ldr r0, _0223F150 ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F148
_0223F072:
	ldr r0, _0223F154 ; =0x000004C2
	ldrb r6, [r5, r0]
	cmp r6, #0xff
	bne _0223F08A
	add r0, r4, #0
	bl sub_02087E1C
	cmp r0, #1
	bne _0223F088
	mov r6, #0xff
	b _0223F08A
_0223F088:
	mov r6, #0xfe
_0223F08A:
	add r0, r4, #0
	bl ov40_0223D540
	ldr r3, _0223F158 ; =0x000004C4
	lsl r2, r6, #0x18
	ldrb r1, [r5, r3]
	lsr r2, r2, #0x18
	str r1, [sp]
	sub r1, r3, #4
	sub r3, r3, #1
	ldrh r1, [r5, r1]
	ldrb r3, [r5, r3]
	bl ov39_02227590
	cmp r0, #1
	bne _0223F148
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F148
_0223F0B2:
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _0223F150 ; =0x0000057D
	bne _0223F0E6
	mov r1, #0
	bl StopSE
	ldr r3, [sp, #4]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #7
	bl ov40_022309DC
	ldr r0, _0223F15C ; =0x00004138
	mov r1, #0
	str r1, [r4, r0]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F148
_0223F0E6:
	mov r1, #0
	bl StopSE
	mov r0, #0x51
	mov r1, #0x76
	lsl r0, r0, #4
	str r1, [r4, r0]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F148
_0223F0FC:
	ldr r0, _0223F15C ; =0x00004138
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0223F118
	mov r1, #0x51
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	bl ov40_0222DF60
	ldr r0, _0223F160 ; =0x0000057C
	bl PlaySE
	b _0223F11E
_0223F118:
	ldr r0, _0223F164 ; =0x00000577
	bl PlaySE
_0223F11E:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F148
_0223F126:
	ldr r0, _0223F168 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F734
	ldr r0, _0223F15C ; =0x00004138
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0223F140
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
	b _0223F148
_0223F140:
	add r0, r4, #0
	mov r1, #0xd
	bl ov40_0222BF80
_0223F148:
	mov r0, #0
	add sp, #8
	pop {r4, r5, r6, pc}
	nop
_0223F150: .word 0x0000057D
_0223F154: .word 0x000004C2
_0223F158: .word 0x000004C4
_0223F15C: .word 0x00004138
_0223F160: .word 0x0000057C
_0223F164: .word 0x00000577
_0223F168: .word 0x0000049C
	thumb_func_end ov40_0223F028

	thumb_func_start ov40_0223F16C
ov40_0223F16C: ; 0x0223F16C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223F182
	cmp r1, #1
	beq _0223F1AA
	b _0223F1EC
_0223F182:
	bl ov40_0223E024
	add r0, r5, #0
	bl ov40_0223E064
	add r0, r5, #0
	bl ov40_0222DFB0
	ldr r0, _0223F1F8 ; =0x00000608
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	ldr r0, _0223F1FC ; =0x0000060C
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223F1F2
_0223F1AA:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223F1D2
	add r0, r5, #0
	mov r1, #1
	bl ov40_022420B4
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F1D2:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223F1F2
_0223F1EC:
	mov r1, #0xe
	bl ov40_0222BF80
_0223F1F2:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223F1F8: .word 0x00000608
_0223F1FC: .word 0x0000060C
	thumb_func_end ov40_0223F16C

	thumb_func_start ov40_0223F200
ov40_0223F200: ; 0x0223F200
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223F21A
	cmp r1, #1
	bne _0223F218
	b _0223F31C
_0223F218:
	b _0223F3BC
_0223F21A:
	bl sub_0202FC48
	cmp r0, #0
	beq _0223F226
	bl sub_0202FC24
_0223F226:
	mov r0, #0x4e
	lsl r0, r0, #4
	ldr r3, _0223F3C8 ; =ov40_022457B0
	add r2, r4, r0
	mov r6, #5
_0223F230:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _0223F230
	ldr r0, [r3]
	mov r1, #0
	str r0, [r2]
	mov r0, #0x4e
	lsl r0, r0, #4
	str r1, [r4, r0]
	ldr r1, _0223F3CC ; =0x00004138
	add r0, r0, #4
	ldr r1, [r5, r1]
	str r1, [r4, r0]
	add r0, r5, #0
	bl ov40_0222FE00
	mov r0, #0x6d
	bl ov40_0222FE8C
	ldr r1, _0223F3D0 ; =0x0000050C
	mov r2, #3
	str r0, [r4, r1]
	add r0, r5, #0
	mov r1, #4
	bl ov40_022307DC
	mov r1, #7
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_022307DC
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r5, #0
	bl ov40_0223E0A4
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223F3D4 ; =0x0000047C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F9D4
	ldr r3, _0223F3D8 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r3
	add r3, #0x44
	mov r2, #0
	add r3, r4, r3
	bl ov40_0222E9B8
	ldr r1, _0223F3DC ; =0x000004E4
	mov r0, #1
	str r0, [r5, r1]
	add r0, r1, #0
	sub r0, #0x68
	sub r1, #0x48
	add r0, r5, r0
	add r1, r5, r1
	bl ov40_0222FA5C
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	ldr r0, _0223F3D8 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	mov r2, #1
	bl ov40_0222F740
	ldr r0, _0223F3D8 ; =0x0000049C
	mov r1, #0x40
	add r0, r5, r0
	mov r2, #0xb8
	bl ov40_0222F858
	ldr r0, _0223F3D8 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F488
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0223D68C
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223D830
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223F3C2
_0223F31C:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223F38A
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r5, #0
	mov r1, #1
	bl ov40_0223D830
	ldr r3, _0223F3E0 ; =0x000004D8
	mov r1, #0x6f
	ldr r6, [r5, r3]
	mov r3, #0x18
	mul r3, r6
	lsl r1, r1, #4
	add r3, #0x4c
	lsl r3, r3, #0x10
	ldr r1, [r5, r1]
	add r0, r5, #0
	mov r2, #0x10
	asr r3, r3, #0x10
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0xc
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F38A:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223F3C2
_0223F3BC:
	mov r1, #0xf
	bl ov40_0222BF80
_0223F3C2:
	mov r0, #0
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_0223F3C8: .word ov40_022457B0
_0223F3CC: .word 0x00004138
_0223F3D0: .word 0x0000050C
_0223F3D4: .word 0x0000047C
_0223F3D8: .word 0x0000049C
_0223F3DC: .word 0x000004E4
_0223F3E0: .word 0x000004D8
	thumb_func_end ov40_0223F200

	thumb_func_start ov40_0223F3E4
ov40_0223F3E4: ; 0x0223F3E4
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223F3FE
	cmp r1, #1
	beq _0223F474
	cmp r1, #2
	beq _0223F4EC
	b _0223F578
_0223F3FE:
	ldr r0, _0223F584 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA88
	ldr r1, _0223F588 ; =0x0000049C
	add r0, r5, r1
	sub r1, #0x10
	ldrsh r1, [r5, r1]
	bl ov40_0222F5EC
	ldr r0, _0223F588 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F488
	ldr r2, _0223F58C ; =0x000004D8
	mov r0, #0x6f
	ldr r3, [r5, r2]
	mov r2, #0x18
	mul r2, r3
	lsl r0, r0, #4
	add r2, #0x4c
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	mov r1, #0x10
	asr r2, r2, #0x10
	bl sub_020878EC
	add r0, r5, #0
	bl ov40_0223D8D4
	ldr r0, _0223F590 ; =ov40_0224564C
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0223F456
	add r0, r5, #0
	bl ov40_02230944
	mov r0, #0x11
	str r0, [r4, #0xc]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F456:
	ldr r0, _0223F594 ; =ov40_02245650
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	bne _0223F462
	b _0223F57E
_0223F462:
	add r0, r5, #0
	bl ov40_02230944
	mov r0, #0x10
	str r0, [r4, #0xc]
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223F57E
_0223F474:
	ldr r0, _0223F584 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA24
	ldr r0, _0223F588 ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F720
	ldr r0, _0223F588 ; =0x0000049C
	add r1, r5, #0
	add r0, r5, r0
	bl ov40_0222F920
	ldr r0, _0223F598 ; =0x0000050C
	ldr r0, [r4, r0]
	bl ov40_0222FE98
	add r0, r5, #0
	bl ov40_0223D874
	add r0, r5, #0
	bl ov40_0222FE68
	add r0, r5, #0
	bl ov40_0223E024
	add r0, r5, #0
	bl ov40_0223E064
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, [r4, #0xc]
	cmp r0, #0x10
	bne _0223F4E6
	ldr r0, _0223F584 ; =0x0000047C
	add r0, r5, r0
	bl ov40_0222FA18
	ldr r0, _0223F588 ; =0x0000049C
	add r0, r5, r0
	bl ov40_0222F734
	mov r0, #0x51
	mov r1, #0
	lsl r0, r0, #4
	str r1, [r4, r0]
_0223F4E6:
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F4EC:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223F546
	add r0, r5, #0
	mov r1, #0
	bl ov40_022420B4
	ldr r0, [r4, #0xc]
	cmp r0, #0x11
	bne _0223F540
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	ldr r0, [r4, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r4, #0x30]
	mov r1, #3
	bl ManagedSprite_SetAnim
_0223F540:
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F546:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223F57E
_0223F578:
	ldr r1, [r4, #0xc]
	bl ov40_0222BF80
_0223F57E:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223F584: .word 0x0000047C
_0223F588: .word 0x0000049C
_0223F58C: .word 0x000004D8
_0223F590: .word ov40_0224564C
_0223F594: .word ov40_02245650
_0223F598: .word 0x0000050C
	thumb_func_end ov40_0223F3E4

	thumb_func_start ov40_0223F59C
ov40_0223F59C: ; 0x0223F59C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223F5B2
	cmp r1, #1
	beq _0223F614
	b _0223F692
_0223F5B2:
	mov r1, #0x38
	mov r2, #3
	bl ov40_022307DC
	add r0, r5, #0
	mov r1, #0x3b
	mov r2, #7
	bl ov40_022307DC
	add r0, r5, #0
	mov r1, #0
	bl ov40_022420B4
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223F69C ; =ov40_022456C4
	ldr r2, _0223F6A0 ; =ov40_02241D10
	mov r1, #5
	add r3, r5, #0
	bl TouchHitboxController_Create
	ldr r1, _0223F6A4 ; =0x00000608
	ldr r2, _0223F6A8 ; =ov40_02241E14
	str r0, [r4, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223F6AC ; =ov40_02245708
	mov r1, #9
	add r3, r5, #0
	bl TouchHitboxController_Create
	ldr r1, _0223F6B0 ; =0x0000060C
	str r0, [r4, r1]
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223DF1C
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223F698
_0223F614:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223F678
	add r0, r5, #0
	mov r1, #0x7c
	bl ov40_0222DED0
	add r0, r5, #0
	mov r1, #0
	bl ov40_0223DBD4
	mov r1, #0x13
	lsl r1, r1, #6
	ldrh r1, [r4, r1]
	add r0, r5, #0
	bl ov40_0223DD68
	ldr r1, _0223F6B4 ; =0x000004C2
	add r0, r5, #0
	ldrb r1, [r4, r1]
	bl ov40_0223DCF0
	ldr r2, _0223F6B8 ; =0x000004C3
	add r0, r5, #0
	ldrb r1, [r4, r2]
	add r2, r2, #1
	ldrb r2, [r4, r2]
	bl ov40_0223DDE8
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F678:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223F698
_0223F692:
	mov r1, #3
	bl ov40_0222BF80
_0223F698:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223F69C: .word ov40_022456C4
_0223F6A0: .word ov40_02241D10
_0223F6A4: .word 0x00000608
_0223F6A8: .word ov40_02241E14
_0223F6AC: .word ov40_02245708
_0223F6B0: .word 0x0000060C
_0223F6B4: .word 0x000004C2
_0223F6B8: .word 0x000004C3
	thumb_func_end ov40_0223F59C

	thumb_func_start ov40_0223F6BC
ov40_0223F6BC: ; 0x0223F6BC
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _0223F6CE
	b _0223F802
_0223F6CE:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223F6DA: ; jump table
	.short _0223F6E2 - _0223F6DA - 2 ; case 0
	.short _0223F6F2 - _0223F6DA - 2 ; case 1
	.short _0223F73C - _0223F6DA - 2 ; case 2
	.short _0223F7A6 - _0223F6DA - 2 ; case 3
_0223F6E2:
	mov r1, #6
	mov r2, #7
	bl ov40_022307DC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F80A
_0223F6F2:
	bl ov40_022408AC
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223F810 ; =ov40_022456B4
	ldr r2, _0223F814 ; =ov40_02241E40
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _0223F818 ; =0x00000608
	ldr r2, _0223F81C ; =ov40_02241ED4
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223F820 ; =ov40_02245674
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _0223F824 ; =0x0000060C
	ldr r2, _0223F828 ; =ov40_02241F3C
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0223F82C ; =ov40_02245654
	mov r1, #2
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x61
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F80A
_0223F73C:
	mov r1, #0x73
	mov r2, #0
	lsl r1, r1, #2
	str r2, [r5, r1]
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223F80A
_0223F7A6:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223F7E8
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	add r0, r4, #0
	bl ov40_02241AB0
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223F7E8:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223F80A
_0223F802:
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
_0223F80A:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0223F810: .word ov40_022456B4
_0223F814: .word ov40_02241E40
_0223F818: .word 0x00000608
_0223F81C: .word ov40_02241ED4
_0223F820: .word ov40_02245674
_0223F824: .word 0x0000060C
_0223F828: .word ov40_02241F3C
_0223F82C: .word ov40_02245654
	thumb_func_end ov40_0223F6BC

	thumb_func_start ov40_0223F830
ov40_0223F830: ; 0x0223F830
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _0223F844 ; =0x00000608
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_0223F844: .word 0x00000608
	thumb_func_end ov40_0223F830

	thumb_func_start ov40_0223F848
ov40_0223F848: ; 0x0223F848
	push {r4, lr}
	add r4, r0, #0
	bl ov40_0224222C
	cmp r0, #0
	beq _0223F85C
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
_0223F85C:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_0223F848

	thumb_func_start ov40_0223F860
ov40_0223F860: ; 0x0223F860
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	bl ov40_02242CFC
	cmp r0, #0
	beq _0223F87A
	add r0, r4, #0
	bl Heap_Free
	mov r0, #1
	pop {r4, pc}
_0223F87A:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_0223F860

	thumb_func_start ov40_0223F880
ov40_0223F880: ; 0x0223F880
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0223F896
	cmp r1, #1
	beq _0223F904
	b _0223F972
_0223F896:
	ldr r0, _0223F97C ; =0x00000608
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	ldr r0, _0223F980 ; =0x0000060C
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x61
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	bl ov40_02240910
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	cmp r1, #0
	bne _0223F8E4
	sub r0, #0xc0
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0223064C
	b _0223F8EE
_0223F8E4:
	add r4, #0x80
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_0222E7B8
_0223F8EE:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02241A34
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0223F978
_0223F904:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223F958
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x6f
	bl ov40_0222D66C
	ldr r0, [r4, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r4, #0x30]
	mov r1, #1
	bl ManagedSprite_SetAnim
	add r0, r5, #0
	mov r1, #1
	bl ov40_022420B4
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0223F958:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223F978
_0223F972:
	mov r1, #0xe
	bl ov40_0222BF80
_0223F978:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0223F97C: .word 0x00000608
_0223F980: .word 0x0000060C
	thumb_func_end ov40_0223F880

	thumb_func_start ov40_0223F984
ov40_0223F984: ; 0x0223F984
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r5, [r4, r0]
	bl sub_020307F8
	mov r1, #4
	mov r2, #0
	bl sub_0203088C
	add r3, r0, #0
	add r2, r1, #0
	add r0, r4, #0
	add r1, r3, #0
	bl ov40_02230D94
	cmp r0, #0
	bne _0223F9AE
	b _0223FC7A
_0223F9AE:
	ldr r0, [r4, #8]
	cmp r0, #5
	bls _0223F9B6
	b _0223FC4C
_0223F9B6:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223F9C2: ; jump table
	.short _0223F9CE - _0223F9C2 - 2 ; case 0
	.short _0223FA1C - _0223F9C2 - 2 ; case 1
	.short _0223FA82 - _0223F9C2 - 2 ; case 2
	.short _0223FA92 - _0223F9C2 - 2 ; case 3
	.short _0223FAD0 - _0223F9C2 - 2 ; case 4
	.short _0223FBE2 - _0223F9C2 - 2 ; case 5
_0223F9CE:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _0223F9EC
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0223064C
	b _0223F9F6
_0223F9EC:
	add r5, #0x80
	add r0, r5, #0
	add r1, r4, #0
	bl ov40_0222E7B8
_0223F9F6:
	add r0, r4, #0
	bl ov40_02241A34
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223FC8C
_0223FA1C:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223FA68
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_022421FC
	add r0, r4, #0
	bl ov40_02241054
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223FA68:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223FC8C
_0223FA82:
	ldr r1, _0223FC94 ; =0x00000115
	add r0, r4, #0
	bl ov40_0222DED0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223FC8C
_0223FA92:
	bl System_GetTouchNew
	cmp r0, #0
	bne _0223FA9C
	b _0223FC8C
_0223FA9C:
	add r0, r4, #0
	bl ov40_02241114
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223FC8C
_0223FAD0:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02242110
	ldr r0, _0223FC98 ; =0x0000086C
	ldr r0, [r4, r0]
	cmp r0, #0xd2
	bne _0223FB12
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r5, #0x30]
	mov r1, #3
	bl ManagedSprite_SetAnim
_0223FB12:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02241AB0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _0223FB8E
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	b _0223FBBA
_0223FB8E:
	add r0, r5, #0
	add r0, #0x80
	add r1, r4, #0
	bl ov40_0222E79C
	add r5, #0x80
	add r0, r5, #0
	mov r1, #0
	bl ov40_0222E7DC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
_0223FBBA:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #6
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223FC8C
_0223FBE2:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223FC32
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _0223FC12
	sub r0, #0xc0
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	b _0223FC1C
_0223FC12:
	add r0, r5, #0
	add r0, #0x80
	mov r1, #1
	bl ov40_0222E7DC
_0223FC1C:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223FC32:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223FC8C
_0223FC4C:
	ldr r1, _0223FC9C ; =0x00004138
	mov r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0
	ble _0223FC70
	mov r1, #0x9a
	lsl r1, r1, #6
	add r5, r4, r1
	ldr r2, _0223FC9C ; =0x00004138
	add r6, r4, #0
	sub r1, #0x78
_0223FC62:
	str r5, [r6, r1]
	ldr r3, [r4, r2]
	add r0, r0, #1
	add r5, #0xe4
	add r6, r6, #4
	cmp r0, r3
	blt _0223FC62
_0223FC70:
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
	b _0223FC8C
_0223FC7A:
	add r0, r4, #0
	bl ov40_02242378
	cmp r0, #0
	beq _0223FC8C
	add r0, r4, #0
	mov r1, #0x17
	bl ov40_0222BF80
_0223FC8C:
	mov r0, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0223FC94: .word 0x00000115
_0223FC98: .word 0x0000086C
_0223FC9C: .word 0x00004138
	thumb_func_end ov40_0223F984

	thumb_func_start ov40_0223FCA0
ov40_0223FCA0: ; 0x0223FCA0
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _0223FCB4 ; =0x0000060C
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_0223FCB4: .word 0x0000060C
	thumb_func_end ov40_0223FCA0

	thumb_func_start ov40_0223FCB8
ov40_0223FCB8: ; 0x0223FCB8
	push {r4, r5, r6, lr}
	add r4, r0, #0
	bl ov40_02242AEC
	cmp r0, #0
	beq _0223FCF0
	ldr r1, _0223FCF4 ; =0x00004138
	mov r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0
	ble _0223FCE8
	mov r1, #0x9a
	lsl r1, r1, #6
	add r5, r4, r1
	ldr r2, _0223FCF4 ; =0x00004138
	add r6, r4, #0
	sub r1, #0x78
_0223FCDA:
	str r5, [r6, r1]
	ldr r3, [r4, r2]
	add r0, r0, #1
	add r5, #0xe4
	add r6, r6, #4
	cmp r0, r3
	blt _0223FCDA
_0223FCE8:
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
_0223FCF0:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0223FCF4: .word 0x00004138
	thumb_func_end ov40_0223FCB8

	thumb_func_start ov40_0223FCF8
ov40_0223FCF8: ; 0x0223FCF8
	push {r4, r5, r6, lr}
	add r4, r0, #0
	bl ov40_022428D4
	cmp r0, #0
	beq _0223FD30
	ldr r1, _0223FD34 ; =0x00004138
	mov r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0
	ble _0223FD28
	mov r1, #0x9a
	lsl r1, r1, #6
	add r5, r4, r1
	ldr r2, _0223FD34 ; =0x00004138
	add r6, r4, #0
	sub r1, #0x78
_0223FD1A:
	str r5, [r6, r1]
	ldr r3, [r4, r2]
	add r0, r0, #1
	add r5, #0xe4
	add r6, r6, #4
	cmp r0, r3
	blt _0223FD1A
_0223FD28:
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
_0223FD30:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0223FD34: .word 0x00004138
	thumb_func_end ov40_0223FCF8

	thumb_func_start ov40_0223FD38
ov40_0223FD38: ; 0x0223FD38
	push {r4, lr}
	add r4, r0, #0
	bl ov40_02242490
	cmp r0, #0
	beq _0223FD4C
	add r0, r4, #0
	mov r1, #0x1a
	bl ov40_0222BF80
_0223FD4C:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_0223FD38

	thumb_func_start ov40_0223FD50
ov40_0223FD50: ; 0x0223FD50
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x61
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223FD50

	thumb_func_start ov40_0223FD68
ov40_0223FD68: ; 0x0223FD68
	push {r4, lr}
	add r4, r0, #0
	bl ov40_0224253C
	cmp r0, #0
	beq _0223FD7C
	add r0, r4, #0
	mov r1, #0x17
	bl ov40_0222BF80
_0223FD7C:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_0223FD68

	thumb_func_start ov40_0223FD80
ov40_0223FD80: ; 0x0223FD80
	push {r3, lr}
	bl ov40_022425E8
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0223FD80

	thumb_func_start ov40_0223FD8C
ov40_0223FD8C: ; 0x0223FD8C
	push {r3, r4, r5, lr}
	sub sp, #8
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	bl ov40_0223D5CC
	cmp r0, #0
	bne _0223FDA6
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, pc}
_0223FDA6:
	ldr r0, [r4, #8]
	cmp r0, #4
	bls _0223FDAE
	b _0223FF34
_0223FDAE:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0223FDBA: ; jump table
	.short _0223FDC4 - _0223FDBA - 2 ; case 0
	.short _0223FDFA - _0223FDBA - 2 ; case 1
	.short _0223FE34 - _0223FDBA - 2 ; case 2
	.short _0223FE7A - _0223FDBA - 2 ; case 3
	.short _0223FEA6 - _0223FDBA - 2 ; case 4
_0223FDC4:
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _0223FDEA
	sub r0, #0xc0
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	b _0223FDF4
_0223FDEA:
	add r0, r5, #0
	add r0, #0x80
	mov r1, #0
	bl ov40_0222E7DC
_0223FDF4:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223FDFA:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0223FE1A
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0223FE1A:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0223FF68
_0223FE34:
	add r0, r4, #0
	mov r1, #0x75
	bl ov40_0222DED0
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, _0223FF70 ; =0x000004B8
	mov r1, #0
	str r1, [r5, r0]
	add r0, #0xc5
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223FF68
_0223FE7A:
	add r0, r4, #0
	bl ov40_0223D540
	ldr r1, _0223FF74 ; =0x000004D4
	ldr r1, [r4, r1]
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r1, _0223FF78 ; =0x00002608
	ldr r2, [r2, r1]
	add r1, r2, #0
	add r1, #0xd8
	add r2, #0xdc
	ldr r1, [r1]
	ldr r2, [r2]
	bl ov39_02227720
	cmp r0, #1
	bne _0223FF68
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0223FF68
_0223FEA6:
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _0223FF7C ; =0x0000057D
	bne _0223FEE0
	mov r1, #0
	bl StopSE
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r3, [sp, #4]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #8
	bl ov40_02230CDC
	ldr r0, [r4, #8]
	mov r1, #0
	add r0, r0, #1
	str r0, [r4, #8]
	ldr r0, _0223FF70 ; =0x000004B8
	str r1, [r5, r0]
	b _0223FF18
_0223FEE0:
	mov r1, #0
	bl StopSE
	mov r0, #0xff
	str r0, [r4, #8]
	ldr r0, _0223FF70 ; =0x000004B8
	mov r1, #1
	str r1, [r5, r0]
	ldr r1, _0223FF80 ; =0x0000413C
	add r2, r4, r1
	add r1, r0, #0
	add r1, #0x1c
	ldr r1, [r4, r1]
	add r2, r2, r1
	ldr r1, _0223FF84 ; =0x00000878
	str r2, [r4, r1]
	add r2, r1, #0
	add r2, #0x3c
	ldr r3, [r4, r2]
	add r2, r0, #4
	str r3, [r5, r2]
	add r0, r0, #4
	add r1, #0x40
	ldr r0, [r5, r0]
	ldr r2, _0223FF88 ; =0x00001D4C
	add r1, r4, r1
	bl MI_CpuCopy8
_0223FF18:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	b _0223FF68
_0223FF34:
	ldr r0, _0223FF70 ; =0x000004B8
	ldr r1, [r5, r0]
	cmp r1, #0
	beq _0223FF5A
	add r0, #0xbf
	bl PlaySE
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r1, [r5, #0xc]
	add r0, r4, #0
	bl ov40_0222BF80
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FC40
	b _0223FF68
_0223FF5A:
	add r0, r4, #0
	bl ov40_0222DFB0
	add r0, r4, #0
	mov r1, #0x1f
	bl ov40_0222BF80
_0223FF68:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_0223FF70: .word 0x000004B8
_0223FF74: .word 0x000004D4
_0223FF78: .word 0x00002608
_0223FF7C: .word 0x0000057D
_0223FF80: .word 0x0000413C
_0223FF84: .word 0x00000878
_0223FF88: .word 0x00001D4C
	thumb_func_end ov40_0223FD8C

	thumb_func_start ov40_0223FF8C
ov40_0223FF8C: ; 0x0223FF8C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #5
	bls _0223FFA0
	b _022401E4
_0223FFA0:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0223FFAC: ; jump table
	.short _0223FFB8 - _0223FFAC - 2 ; case 0
	.short _022400AE - _0223FFAC - 2 ; case 1
	.short _022400F8 - _0223FFAC - 2 ; case 2
	.short _0224015A - _0223FFAC - 2 ; case 3
	.short _022401B6 - _0223FFAC - 2 ; case 4
	.short _022401D4 - _0223FFAC - 2 ; case 5
_0223FFB8:
	bl ov40_02230738
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	bl ov40_0222D9E8
	ldr r0, _02240200 ; =0x00004138
	mov r2, #0
	ldr r0, [r4, r0]
	cmp r0, #0
	ble _0223FFEC
	mov r0, #0x9a
	lsl r0, r0, #6
	add r7, r0, #0
	add r3, r4, r0
	ldr r0, _02240200 ; =0x00004138
	add r6, r4, #0
	sub r7, #0x78
_0223FFDE:
	str r3, [r6, r7]
	ldr r1, [r4, r0]
	add r2, r2, #1
	add r3, #0xe4
	add r6, r6, #4
	cmp r2, r1
	blt _0223FFDE
_0223FFEC:
	ldr r0, _02240204 ; =0x000004D4
	mov r3, #3
	ldr r0, [r4, r0]
	add r1, r4, r0
	ldr r0, _02240208 ; =0x0000413C
	ldrb r1, [r1, r0]
	ldr r0, _0224020C ; =0x0000079C
	strb r1, [r5, r0]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #6
	mov r2, #7
	bl ov40_022307DC
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	bl ov40_02242110
	add r0, r4, #0
	mov r1, #0
	bl ov40_022420B4
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r5, #0x30]
	mov r1, #3
	bl ManagedSprite_SetAnim
	mov r1, #0x13
	ldr r0, _02240210 ; =0x0000FFFF
	lsl r1, r1, #6
	strh r0, [r5, r1]
	mov r2, #0xff
	add r0, r1, #2
	strb r2, [r5, r0]
	add r0, r1, #3
	strb r2, [r5, r0]
	add r0, r1, #4
	strb r2, [r5, r0]
	add r0, r1, #0
	add r2, #0xf5
	add r0, #0x54
	str r2, [r5, r0]
	add r0, r1, #0
	sub r0, #0x1c
	ldrsh r0, [r4, r0]
	add r1, #0x50
	str r0, [r5, r1]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022401FA
_022400AE:
	bl ov40_022408AC
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02240214 ; =ov40_022456B4
	ldr r2, _02240218 ; =ov40_02241E40
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _0224021C ; =0x00000608
	ldr r2, _02240220 ; =ov40_02241ED4
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02240224 ; =ov40_02245674
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _02240228 ; =0x0000060C
	ldr r2, _0224022C ; =ov40_02241F3C
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02240230 ; =ov40_02245654
	mov r1, #2
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x61
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022401FA
_022400F8:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022401FA
_0224015A:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0224019C
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	add r0, r4, #0
	bl ov40_02241AB0
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0224019C:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022401FA
_022401B6:
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x6d
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022401FA
_022401D4:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _022401FA
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022401FA
_022401E4:
	ldr r0, _02240234 ; =0x000006D8
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov40_0222C4B8
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
_022401FA:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02240200: .word 0x00004138
_02240204: .word 0x000004D4
_02240208: .word 0x0000413C
_0224020C: .word 0x0000079C
_02240210: .word 0x0000FFFF
_02240214: .word ov40_022456B4
_02240218: .word ov40_02241E40
_0224021C: .word 0x00000608
_02240220: .word ov40_02241ED4
_02240224: .word ov40_02245674
_02240228: .word 0x0000060C
_0224022C: .word ov40_02241F3C
_02240230: .word ov40_02245654
_02240234: .word 0x000006D8
	thumb_func_end ov40_0223FF8C

	thumb_func_start ov40_02240238
ov40_02240238: ; 0x02240238
	push {r3, r4, r5, lr}
	mov r1, #0x7a
	add r5, r0, #0
	mov r0, #0x6d
	lsl r1, r1, #4
	bl Heap_Alloc
	mov r2, #0x7a
	mov r1, #0
	lsl r2, r2, #4
	add r4, r0, #0
	bl memset
	mov r0, #0x86
	lsl r0, r0, #4
	str r4, [r5, r0]
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	bl ov40_0222D9E8
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222BF80
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02240238

	thumb_func_start ov40_02240290
ov40_02240290: ; 0x02240290
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r2, [r5, #8]
	ldr r4, [r5, r1]
	cmp r2, #0
	beq _022402A6
	cmp r2, #1
	beq _02240304
	b _02240360
_022402A6:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	cmp r0, #0
	beq _022402BA
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022402BA:
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02240414
_02240304:
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D874
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	add r1, r0, #0
	bl SetBgPriority
	mov r0, #1
	mov r1, #3
	bl SetBgPriority
	mov r0, #2
	mov r1, #0
	bl SetBgPriority
	mov r0, #3
	mov r1, #2
	bl SetBgPriority
	mov r0, #4
	mov r1, #0
	bl SetBgPriority
	mov r0, #5
	mov r1, #3
	bl SetBgPriority
	mov r0, #6
	mov r1, #1
	bl SetBgPriority
	mov r0, #7
	mov r1, #2
	bl SetBgPriority
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02240414
_02240360:
	add r1, #0xc
	ldr r1, [r5, r1]
	cmp r1, #0xc8
	beq _02240372
	cmp r1, #0xd2
	beq _022403A2
	cmp r1, #0xdc
	beq _022403D2
	b _022403FA
_02240372:
	mov r1, #0
	bl ov40_0222FB90
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	add r0, r5, #0
	bl ov40_0222C4DC
	cmp r0, #1
	bne _02240398
	add r0, r5, #0
	mov r1, #6
	bl ov40_0222BF80
	b _02240414
_02240398:
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222BF80
	b _02240414
_022403A2:
	mov r1, #0
	bl ov40_0222FB90
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	add r0, r5, #0
	bl ov40_0222C4DC
	cmp r0, #1
	bne _022403C8
	add r0, r5, #0
	mov r1, #0x1e
	bl ov40_0222BF80
	b _02240414
_022403C8:
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222BF80
	b _02240414
_022403D2:
	bl ov40_0222C4DC
	cmp r0, #1
	bne _022403E4
	add r0, r5, #0
	mov r1, #0x13
	bl ov40_0222BF80
	b _022403EC
_022403E4:
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222BF80
_022403EC:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	b _02240414
_022403FA:
	mov r1, #0
	bl ov40_0222FB90
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl sub_020879E0
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222BF80
_02240414:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_02240290

	thumb_func_start ov40_02240418
ov40_02240418: ; 0x02240418
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	mov r2, #0x75
	ldr r6, [r5, r1]
	lsl r2, r2, #2
	add r4, r6, r2
	ldr r2, [r5, #8]
	cmp r2, #0
	beq _0224043A
	cmp r2, #1
	beq _022404AA
	cmp r2, #2
	beq _022404CE
	b _02240510
_0224043A:
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #5
	sub r1, #0x30
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	ldr r0, [r5, r1]
	bl Save_PlayerData_GetOptionsAddr
	add r3, r0, #0
	mov r0, #0x6d
	mov r1, #0xc
	add r2, sp, #0xc
	bl ov40_02242FAC
	ldr r1, _0224051C ; =0x000004AC
	mov r2, #0x22
	str r0, [r6, r1]
	ldr r0, [r5, #0x14]
	lsl r2, r2, #4
	str r0, [r4, r2]
	ldr r3, [r5, #0x18]
	add r0, r2, #4
	str r3, [r4, r0]
	add r0, r2, #0
	ldr r3, [r5, #0x1c]
	add r0, #8
	str r3, [r4, r0]
	add r0, r2, #0
	ldr r3, [r5, #0x24]
	add r0, #0xc
	str r3, [r4, r0]
	add r0, r2, #0
	ldr r3, [r5, #0x28]
	add r0, #0x10
	str r3, [r4, r0]
	add r0, r2, #0
	add r0, #0x88
	ldr r3, [r6, r1]
	add r7, r4, r0
	ldmia r3!, {r0, r1}
	stmia r7!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r7!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r7!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r7!, {r0, r1}
	add r2, #0xb4
	str r5, [r4, r2]
	add r0, r5, #0
	bl ov40_02241FD0
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022404AA:
	mov r2, #8
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	add r0, r6, #0
	add r1, r6, #4
	bl ov40_0222D910
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02240516
_022404CE:
	add r0, r6, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r6, #0
	add r1, r6, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _022404F6
	add r0, r5, #0
	mov r1, #0x70
	bl ov40_0222DD9C
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022404F6:
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r6, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02240516
_02240510:
	mov r1, #3
	bl ov40_0222BF80
_02240516:
	mov r0, #0
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224051C: .word 0x000004AC
	thumb_func_end ov40_02240418

	thumb_func_start ov40_02240520
ov40_02240520: ; 0x02240520
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	mov r0, #0x75
	lsl r0, r0, #2
	add r0, r1, r0
	bl ov40_02243538
	cmp r0, #1
	bne _02240540
	add r0, r4, #0
	mov r1, #4
	bl ov40_0222BF80
_02240540:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_02240520

	thumb_func_start ov40_02240544
ov40_02240544: ; 0x02240544
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	mov r1, #0x75
	lsl r1, r1, #2
	ldr r2, [r5, #8]
	add r3, r4, r1
	cmp r2, #0
	beq _02240562
	cmp r2, #1
	beq _02240588
	b _022405D0
_02240562:
	bl ov40_0222DE40
	mov r2, #8
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	add r0, r4, #0
	add r1, r4, #4
	bl ov40_0222D980
	ldr r0, _022405EC ; =0x000004AC
	ldr r0, [r4, r0]
	bl ov40_02242FF8
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02240588:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _022405B6
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	bl ov40_02242084
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022405B6:
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022405E6
_022405D0:
	add r1, #0xf4
	ldr r1, [r3, r1]
	cmp r1, #0
	beq _022405E0
	mov r1, #6
	bl ov40_0222BF80
	b _022405E6
_022405E0:
	mov r1, #5
	bl ov40_0222BF80
_022405E6:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_022405EC: .word 0x000004AC
	thumb_func_end ov40_02240544

	thumb_func_start ov40_022405F0
ov40_022405F0: ; 0x022405F0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r5, #8]
	cmp r0, #0
	bne _02240626
	add r4, #8
	add r0, r4, #0
	bl ov40_0222DAA8
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D88C
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _022406C2
_02240626:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02240692
	add r0, r5, #0
	bl ov40_0222DD08
	add r0, r4, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	bl Heap_Free
	b _022406C2
_02240692:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_022406C2:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_022405F0

	thumb_func_start ov40_022406C8
ov40_022406C8: ; 0x022406C8
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	mov r1, #0x75
	lsl r1, r1, #2
	add r6, r5, r1
	ldr r1, [r4, #8]
	cmp r1, #4
	bls _022406E2
	b _0224081A
_022406E2:
	add r2, r1, r1
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_022406EE: ; jump table
	.short _022406F8 - _022406EE - 2 ; case 0
	.short _02240736 - _022406EE - 2 ; case 1
	.short _02240764 - _022406EE - 2 ; case 2
	.short _02240806 - _022406EE - 2 ; case 3
	.short _02240814 - _022406EE - 2 ; case 4
_022406F8:
	mov r1, #0x75
	bl ov40_0222DD9C
	ldr r1, _0224083C ; =0x000006F4
	add r0, r4, #0
	ldr r1, [r4, r1]
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	ldr r0, _0224083C ; =0x000006F4
	mov r1, #1
	ldr r0, [r4, r0]
	bl sub_020879E0
	ldr r0, _0224083C ; =0x000006F4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, _02240840 ; =0x000004B8
	mov r1, #0
	str r1, [r5, r0]
	add r0, #0xc5
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240834
_02240736:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02240744
	add sp, #4
	mov r0, #0
	pop {r3, r4, r5, r6, pc}
_02240744:
	add r0, r4, #0
	bl ov40_0223D540
	mov r2, #0xb3
	lsl r2, r2, #2
	ldr r1, [r6, r2]
	add r2, r2, #4
	ldr r2, [r6, r2]
	bl ov39_02227720
	cmp r0, #1
	bne _02240834
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240834
_02240764:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02240772
	add sp, #4
	mov r0, #0
	pop {r3, r4, r5, r6, pc}
_02240772:
	add r0, r4, #0
	bl ov40_0222DE40
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #0
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _02240844 ; =0x0000057D
	bne _022407BA
	mov r1, #0
	bl StopSE
	ldr r0, _02240848 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	ldr r3, [sp]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #8
	bl ov40_02230CDC
	add r0, r4, #0
	mov r1, #0
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	mov r1, #0
	add r0, r0, #1
	str r0, [r4, #8]
	ldr r0, _02240840 ; =0x000004B8
	str r1, [r5, r0]
	b _022407EE
_022407BA:
	mov r1, #0
	bl StopSE
	mov r0, #0xff
	str r0, [r4, #8]
	ldr r0, _02240840 ; =0x000004B8
	mov r1, #1
	str r1, [r5, r0]
	add r0, #0xbf
	bl PlaySE
	ldr r0, _0224084C ; =0x00002604
	ldr r1, _02240850 ; =0x00000878
	add r0, r4, r0
	str r0, [r4, r1]
	add r0, r1, #0
	add r0, #0x3c
	ldr r2, [r4, r0]
	ldr r0, _02240854 ; =0x000004BC
	add r1, #0x40
	str r2, [r5, r0]
	ldr r0, [r5, r0]
	ldr r2, _02240858 ; =0x00001D4C
	add r1, r4, r1
	bl MI_CpuCopy8
_022407EE:
	ldr r0, _0224083C ; =0x000006F4
	mov r1, #0
	ldr r0, [r4, r0]
	bl sub_020879E0
	ldr r0, _0224083C ; =0x000006F4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	b _02240834
_02240806:
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240834
_02240814:
	add r0, r1, #1
	str r0, [r4, #8]
	b _02240834
_0224081A:
	ldr r0, _02240840 ; =0x000004B8
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0224082C
	add r0, r4, #0
	mov r1, #7
	bl ov40_0222BF80
	b _02240834
_0224082C:
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
_02240834:
	mov r0, #0
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	nop
_0224083C: .word 0x000006F4
_02240840: .word 0x000004B8
_02240844: .word 0x0000057D
_02240848: .word 0x04000050
_0224084C: .word 0x00002604
_02240850: .word 0x00000878
_02240854: .word 0x000004BC
_02240858: .word 0x00001D4C
	thumb_func_end ov40_022406C8

	thumb_func_start ov40_0224085C
ov40_0224085C: ; 0x0224085C
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r0, #0x6d
	bl sub_020314A4
	add r1, r4, #0
	add r1, #0x80
	str r0, [r1]
	ldr r0, _022408A8 ; =0x000004BC
	add r1, r4, #0
	add r1, #0x80
	ldr r0, [r4, r0]
	ldr r1, [r1]
	bl ov39_022271C0
	add r0, r4, #0
	add r0, #0x80
	ldr r1, [r0]
	mov r0, #0x43
	lsl r0, r0, #2
	str r1, [r4, r0]
	mov r0, #0x6d
	bl sub_02030920
	mov r1, #0x11
	lsl r1, r1, #4
	str r0, [r4, r1]
	ldr r0, _022408A8 ; =0x000004BC
	ldr r1, [r4, r1]
	ldr r0, [r4, r0]
	mov r2, #0x64
	add r0, #0x80
	bl MI_CpuCopy8
	pop {r4, pc}
	nop
_022408A8: .word 0x000004BC
	thumb_func_end ov40_0224085C

	thumb_func_start ov40_022408AC
ov40_022408AC: ; 0x022408AC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	mov r0, #0x6d
	bl sub_020314A4
	add r1, r4, #0
	add r1, #0x80
	str r0, [r1]
	ldr r0, _02240908 ; =0x000004D4
	ldr r0, [r5, r0]
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _0224090C ; =0x00002608
	ldr r0, [r1, r0]
	add r1, r4, #0
	add r1, #0x80
	ldr r1, [r1]
	bl ov39_022271C0
	add r0, r4, #0
	add r0, #0x80
	ldr r1, [r0]
	mov r0, #0x43
	lsl r0, r0, #2
	str r1, [r4, r0]
	mov r0, #0x6d
	bl sub_02030920
	mov r1, #0x11
	lsl r1, r1, #4
	str r0, [r4, r1]
	ldr r0, _02240908 ; =0x000004D4
	ldr r1, [r4, r1]
	ldr r0, [r5, r0]
	lsl r0, r0, #2
	add r2, r5, r0
	ldr r0, _0224090C ; =0x00002608
	ldr r0, [r2, r0]
	mov r2, #0x64
	add r0, #0x80
	bl MI_CpuCopy8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02240908: .word 0x000004D4
_0224090C: .word 0x00002608
	thumb_func_end ov40_022408AC

	thumb_func_start ov40_02240910
ov40_02240910: ; 0x02240910
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	mov r0, #0x11
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl sub_02030938
	add r4, #0x80
	ldr r0, [r4]
	bl sub_020314BC
	pop {r4, pc}
	thumb_func_end ov40_02240910

	thumb_func_start ov40_0224092C
ov40_0224092C: ; 0x0224092C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _02240940
	b _02240B10
_02240940:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224094C: ; jump table
	.short _02240954 - _0224094C - 2 ; case 0
	.short _02240962 - _0224094C - 2 ; case 1
	.short _02240A4C - _0224094C - 2 ; case 2
	.short _02240AB4 - _0224094C - 2 ; case 3
_02240954:
	mov r1, #0
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240B18
_02240962:
	bl ov40_0222FBB4
	cmp r0, #0
	bne _0224096C
	b _02240B18
_0224096C:
	mov r2, #8
	str r2, [sp]
	mov r3, #0x12
	str r3, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r1, r5, #4
	bl ov40_0222D980
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #6
	mov r2, #7
	bl ov40_022307DC
	mov r0, #0
	mov r1, #1
	bl SetBgPriority
	mov r0, #1
	mov r1, #3
	bl SetBgPriority
	mov r0, #2
	mov r1, #0
	bl SetBgPriority
	mov r0, #3
	mov r1, #1
	bl SetBgPriority
	mov r0, #4
	mov r1, #1
	bl SetBgPriority
	mov r0, #5
	mov r1, #3
	bl SetBgPriority
	mov r0, #6
	mov r1, #0
	bl SetBgPriority
	mov r0, #7
	mov r1, #2
	bl SetBgPriority
	add r0, r4, #0
	bl ov40_0224085C
	add r0, r4, #0
	bl ov40_02242110
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02240B20 ; =ov40_022456B4
	ldr r2, _02240B24 ; =ov40_02241C10
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _02240B28 ; =0x00000608
	ldr r2, _02240B2C ; =ov40_02241C70
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02240B30 ; =ov40_02245674
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _02240B34 ; =0x0000060C
	ldr r2, _02240B38 ; =ov40_02241CD8
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02240B3C ; =ov40_02245654
	mov r1, #2
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x61
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240B18
_02240A4C:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r5, r0]
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240B18
_02240AB4:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02240AF6
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	add r0, r4, #0
	bl ov40_02241AB0
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02240AF6:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02240B18
_02240B10:
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
_02240B18:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_02240B20: .word ov40_022456B4
_02240B24: .word ov40_02241C10
_02240B28: .word 0x00000608
_02240B2C: .word ov40_02241C70
_02240B30: .word ov40_02245674
_02240B34: .word 0x0000060C
_02240B38: .word ov40_02241CD8
_02240B3C: .word ov40_02245654
	thumb_func_end ov40_0224092C

	thumb_func_start ov40_02240B40
ov40_02240B40: ; 0x02240B40
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _02240B54 ; =0x00000608
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_02240B54: .word 0x00000608
	thumb_func_end ov40_02240B40

	thumb_func_start ov40_02240B58
ov40_02240B58: ; 0x02240B58
	push {r4, lr}
	add r4, r0, #0
	bl ov40_0224222C
	cmp r0, #0
	beq _02240B6C
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
_02240B6C:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_02240B58

	thumb_func_start ov40_02240B70
ov40_02240B70: ; 0x02240B70
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	bl ov40_02242CFC
	cmp r0, #0
	beq _02240B8A
	add r0, r4, #0
	bl Heap_Free
	mov r0, #1
	pop {r4, pc}
_02240B8A:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02240B70

	thumb_func_start ov40_02240B90
ov40_02240B90: ; 0x02240B90
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _02240BA2
	b _02240D42
_02240BA2:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02240BAE: ; jump table
	.short _02240BB6 - _02240BAE - 2 ; case 0
	.short _02240C24 - _02240BAE - 2 ; case 1
	.short _02240C64 - _02240BAE - 2 ; case 2
	.short _02240C92 - _02240BAE - 2 ; case 3
_02240BB6:
	ldr r0, _02240D48 ; =0x00000608
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	ldr r0, _02240D4C ; =0x0000060C
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x61
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r4, #0
	bl ov40_02240910
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _02240C04
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0223064C
	b _02240C0E
_02240C04:
	add r5, #0x80
	add r0, r5, #0
	add r1, r4, #0
	bl ov40_0222E7B8
_02240C0E:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02241A34
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240D42
_02240C24:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02240C4A
	add r0, r4, #0
	bl ov40_022421FC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02240C4A:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02240D42
_02240C64:
	add r5, #8
	add r0, r5, #0
	bl ov40_0222DAA8
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_0222D88C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02240D42
_02240C92:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02240D42
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02240D12
	add r0, r4, #0
	bl ov40_0222DD08
	add r0, r5, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r4, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r4, #0x10]
	add r0, r4, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
	add r0, r5, #0
	bl Heap_Free
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	bl sub_0202FC48
	cmp r0, #1
	bne _02240D42
	bl sub_0202FC24
	b _02240D42
_02240D12:
	ldr r0, [r4, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02240D42:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_02240D48: .word 0x00000608
_02240D4C: .word 0x0000060C
	thumb_func_end ov40_02240B90

	thumb_func_start ov40_02240D50
ov40_02240D50: ; 0x02240D50
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r1, #0
	ldr r1, _02240E20 ; =0x0000088C
	lsl r6, r2, #2
	add r4, r5, r1
	ldr r1, [r4, r6]
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x48]
	cmp r1, #0
	bne _02240D70
	mov r1, #8
	bl NewString_ReadMsgData
	add r4, r0, #0
	b _02240DCE
_02240D70:
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	ldr r0, [r5, #0x48]
	mov r1, #7
	bl NewString_ReadMsgData
	str r0, [sp, #0x14]
	ldr r0, [r4, r6]
	mov r1, #0x6d
	bl sub_020315B8
	add r6, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	bl ov40_02230DCC
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	add r0, r7, #0
	add r2, r6, #0
	add r3, r1, #0
	bl BufferString
	ldr r2, [sp, #0x14]
	add r0, r7, #0
	add r1, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
_02240DCE:
	add r0, sp, #0x18
	bl InitWindow
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r5, #0x24]
	add r1, sp, #0x18
	mov r2, #0x14
	mov r3, #2
	bl AddTextWindowTopLeftCorner
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02240E24 ; =0x000E0D00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, sp, #0x18
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	ldr r1, [sp, #0x10]
	ldr r0, [r0, #8]
	ldr r1, [r1, #0xc]
	add r2, sp, #0x18
	mov r3, #0x6d
	bl TextOBJ_CopyFromBGWindow
	add r0, r4, #0
	bl String_Delete
	add r0, sp, #0x18
	bl RemoveWindow
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02240E20: .word 0x0000088C
_02240E24: .word 0x000E0D00
	thumb_func_end ov40_02240D50

	thumb_func_start ov40_02240E28
ov40_02240E28: ; 0x02240E28
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r4, r1, #0
	ldr r1, _02240F1C ; =0x000008A4
	add r5, r0, #0
	sub r1, #0x44
	ldr r6, [r5, r1]
	mov r1, #2
	bl ov40_0222C6C8
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, _02240F1C ; =0x000008A4
	add r0, r5, r0
	bl InitWindow
	mov r0, #0x13
	str r0, [sp]
	mov r0, #0x1e
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r1, _02240F1C ; =0x000008A4
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r5, r1
	mov r2, #2
	mov r3, #1
	bl AddWindowParameterized
	cmp r4, #0x64
	bne _02240EDA
	add r6, #0x80
	ldr r0, [r6]
	str r0, [sp, #0x14]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r6, r0, #0
	ldr r0, [sp, #0x14]
	mov r1, #0x6d
	bl sub_020315B8
	str r0, [sp, #0x18]
	ldr r1, [sp, #0x18]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r7, #0
	add r3, r1, #0
	bl BufferString
	add r0, r7, #0
	add r1, r6, #0
	add r2, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x18]
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
	b _02240EE4
_02240EDA:
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
_02240EE4:
	ldr r0, _02240F1C ; =0x000008A4
	mov r1, #0xcc
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02240F20 ; =0x000F0D0C
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _02240F1C ; =0x000008A4
	add r3, r1, #0
	add r0, r5, r0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _02240F1C ; =0x000008A4
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add r0, r6, #0
	bl String_Delete
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_02240F1C: .word 0x000008A4
_02240F20: .word 0x000F0D0C
	thumb_func_end ov40_02240E28

	thumb_func_start ov40_02240F24
ov40_02240F24: ; 0x02240F24
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	ldr r0, _0224104C ; =0x000008A4
	add r4, r1, #0
	sub r0, #0x44
	ldr r0, [r5, r0]
	cmp r4, #0x64
	bne _02240F9C
	add r0, #0x80
	ldr r0, [r0]
	str r0, [sp, #0x14]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r6, r0, #0
	ldr r0, [sp, #0x14]
	mov r1, #0x6d
	bl sub_020315B8
	str r0, [sp, #0x18]
	ldr r1, [sp, #0x18]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x18]
	add r0, r7, #0
	add r3, r1, #0
	bl BufferString
	add r0, r7, #0
	add r1, r6, #0
	add r2, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x18]
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
	b _02241014
_02240F9C:
	cmp r4, #0x66
	bne _0224100C
	lsl r0, r2, #2
	add r1, r5, r0
	ldr r0, _0224104C ; =0x000008A4
	sub r0, #0x18
	ldr r0, [r1, r0]
	str r0, [sp, #0x10]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r7, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r6, r0, #0
	ldr r0, [sp, #0x10]
	mov r1, #0x6d
	bl sub_020315B8
	str r0, [sp, #0x1c]
	ldr r1, [sp, #0x1c]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r5, #0x48]
	add r1, r4, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x1c]
	add r0, r7, #0
	add r3, r1, #0
	bl BufferString
	add r0, r7, #0
	add r1, r6, #0
	add r2, r4, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x1c]
	bl String_Delete
	add r0, r4, #0
	bl String_Delete
	add r0, r7, #0
	bl MessageFormat_Delete
	b _02241014
_0224100C:
	ldr r0, [r5, #0x48]
	bl NewString_ReadMsgData
	add r6, r0, #0
_02241014:
	ldr r0, _0224104C ; =0x000008A4
	mov r1, #0xcc
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02241050 ; =0x000F0D0C
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0224104C ; =0x000008A4
	add r3, r1, #0
	add r0, r5, r0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _0224104C ; =0x000008A4
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add r0, r6, #0
	bl String_Delete
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224104C: .word 0x000008A4
_02241050: .word 0x000F0D0C
	thumb_func_end ov40_02240F24

	thumb_func_start ov40_02241054
ov40_02241054: ; 0x02241054
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r3, _0224110C ; =ov40_02245684
	ldr r4, [r0, r1]
	str r0, [sp]
	add r2, sp, #0x20
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r3, _02241110 ; =ov40_02245694
	add r2, sp, #0x10
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [sp]
	mov r1, #2
	bl ov40_0222D78C
	add r0, sp, #0x20
	str r0, [sp, #8]
	mov r0, #0x69
	str r0, [sp, #4]
	ldr r0, [sp]
	add r5, r4, #0
	str r0, [sp, #0xc]
	add r0, #0x14
	mov r6, #0
	add r5, #0x10
	add r7, sp, #0x10
	str r0, [sp, #0xc]
_02241098:
	ldr r0, [sp]
	mov r1, #2
	bl ov40_0222D800
	str r0, [r4, #0x14]
	ldr r1, [sp, #0xc]
	add r0, r5, #0
	mov r2, #2
	bl ov40_0222D5AC
	ldr r2, [sp, #8]
	ldr r1, [sp, #0xc]
	ldr r2, [r2]
	add r0, r5, #0
	bl ov40_0222D66C
	cmp r6, #3
	beq _022410C6
	ldr r1, [sp]
	add r0, r5, #0
	add r2, r6, #1
	bl ov40_02240D50
_022410C6:
	ldr r2, [sp, #4]
	ldr r0, [r4, #0x14]
	lsl r2, r2, #0x10
	mov r1, #0x32
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, [r4, #0x14]
	ldr r1, [r7]
	bl ManagedSprite_SetAnim
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, #0x18]
	sub r2, #0x2c
	bl sub_020136B4
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [sp, #8]
	add r6, r6, #1
	add r0, r0, #4
	str r0, [sp, #8]
	ldr r0, [sp, #4]
	add r4, #0x1c
	add r0, #0x24
	add r5, #0x1c
	add r7, r7, #4
	str r0, [sp, #4]
	cmp r6, #4
	blt _02241098
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224110C: .word ov40_02245684
_02241110: .word ov40_02245694
	thumb_func_end ov40_02241054

	thumb_func_start ov40_02241114
ov40_02241114: ; 0x02241114
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r5, [r7, r0]
	mov r6, #0
	add r4, r5, #0
	add r4, #0x10
_02241124:
	add r0, r4, #0
	bl ov40_0222D6D0
	ldr r0, [r5, #0x14]
	bl Sprite_DeleteAndFreeResources
	add r6, r6, #1
	add r4, #0x1c
	add r5, #0x1c
	cmp r6, #4
	blt _02241124
	add r0, r7, #0
	bl ov40_0222D7DC
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov40_02241114

	thumb_func_start ov40_02241144
ov40_02241144: ; 0x02241144
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r5, [r4, r0]
	bl sub_020307F8
	mov r1, #4
	mov r2, #0
	bl sub_0203088C
	add r3, r0, #0
	add r2, r1, #0
	add r0, r4, #0
	add r1, r3, #0
	bl ov40_02230D94
	cmp r0, #0
	bne _0224116C
	b _022413CA
_0224116C:
	ldr r0, [r4, #8]
	cmp r0, #5
	bls _02241174
	b _02241316
_02241174:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02241180: ; jump table
	.short _0224118C - _02241180 - 2 ; case 0
	.short _022411DA - _02241180 - 2 ; case 1
	.short _02241240 - _02241180 - 2 ; case 2
	.short _02241250 - _02241180 - 2 ; case 3
	.short _02241288 - _02241180 - 2 ; case 4
	.short _022412C8 - _02241180 - 2 ; case 5
_0224118C:
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _022411AA
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0223064C
	b _022411B4
_022411AA:
	add r5, #0x80
	add r0, r5, #0
	add r1, r4, #0
	bl ov40_0222E7B8
_022411B4:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02241A34
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022413DC
_022411DA:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02241226
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_022421FC
	add r0, r4, #0
	bl ov40_02241054
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02241226:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022413DC
_02241240:
	ldr r1, _022413E0 ; =0x00000115
	add r0, r4, #0
	bl ov40_0222DED0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022413DC
_02241250:
	bl System_GetTouchNew
	cmp r0, #0
	bne _0224125A
	b _022413DC
_0224125A:
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022413DC
_02241288:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _022412AE
	add r0, r4, #0
	bl ov40_02241114
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_022412AE:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022413DC
_022412C8:
	ldr r0, _022413E4 ; =0x00000608
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	ldr r0, _022413E8 ; =0x0000060C
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x61
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	add r5, #8
	add r0, r5, #0
	bl ov40_0222DAA8
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02240910
	add r0, r4, #0
	bl ov40_0222D88C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022413DC
_02241316:
	add r0, r4, #0
	bl ov40_0222FBB4
	cmp r0, #0
	beq _022413DC
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02241398
	add r0, r4, #0
	bl ov40_0222DD08
	add r0, r5, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r4, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r4, #0x10]
	add r0, r4, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
	add r0, r5, #0
	bl Heap_Free
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	bl sub_0202FC48
	cmp r0, #1
	bne _022413DC
	bl sub_0202FC24
	b _022413DC
_02241398:
	ldr r0, [r4, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022413DC
_022413CA:
	add r0, r4, #0
	bl ov40_02242378
	cmp r0, #0
	beq _022413DC
	add r0, r4, #0
	mov r1, #0xd
	bl ov40_0222BF80
_022413DC:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022413E0: .word 0x00000115
_022413E4: .word 0x00000608
_022413E8: .word 0x0000060C
	thumb_func_end ov40_02241144

	thumb_func_start ov40_022413EC
ov40_022413EC: ; 0x022413EC
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	ldr r0, _02241400 ; =0x0000060C
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_02241400: .word 0x0000060C
	thumb_func_end ov40_022413EC

	thumb_func_start ov40_02241404
ov40_02241404: ; 0x02241404
	push {r4, lr}
	add r4, r0, #0
	bl ov40_02242AEC
	cmp r0, #0
	beq _02241418
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
_02241418:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_02241404

	thumb_func_start ov40_0224141C
ov40_0224141C: ; 0x0224141C
	push {r4, lr}
	add r4, r0, #0
	bl ov40_022428D4
	cmp r0, #0
	beq _02241430
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
_02241430:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_0224141C

	thumb_func_start ov40_02241434
ov40_02241434: ; 0x02241434
	push {r4, lr}
	add r4, r0, #0
	bl ov40_02242490
	cmp r0, #0
	beq _02241448
	add r0, r4, #0
	mov r1, #0x10
	bl ov40_0222BF80
_02241448:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_02241434

	thumb_func_start ov40_0224144C
ov40_0224144C: ; 0x0224144C
	push {r3, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r1, [r0, r1]
	mov r0, #0x61
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl TouchHitboxController_IsTriggered
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0224144C

	thumb_func_start ov40_02241464
ov40_02241464: ; 0x02241464
	push {r4, lr}
	add r4, r0, #0
	bl ov40_0224253C
	cmp r0, #0
	beq _02241478
	add r0, r4, #0
	mov r1, #0xd
	bl ov40_0222BF80
_02241478:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_02241464

	thumb_func_start ov40_0224147C
ov40_0224147C: ; 0x0224147C
	push {r3, lr}
	bl ov40_022425E8
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_0224147C

	thumb_func_start ov40_02241488
ov40_02241488: ; 0x02241488
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #5
	bls _0224149C
	b _02241754
_0224149C:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022414A8: ; jump table
	.short _022414B4 - _022414A8 - 2 ; case 0
	.short _02241548 - _022414A8 - 2 ; case 1
	.short _022415E8 - _022414A8 - 2 ; case 2
	.short _022416B4 - _022414A8 - 2 ; case 3
	.short _02241726 - _022414A8 - 2 ; case 4
	.short _02241744 - _022414A8 - 2 ; case 5
_022414B4:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02241560
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	bl ov40_0222D9E8
	ldr r0, _02241770 ; =0x00002604
	ldrb r1, [r4, r0]
	ldr r0, _02241774 ; =0x0000079C
	strb r1, [r5, r0]
	ldr r0, _02241778 ; =0x000008B8
	ldr r1, _0224177C ; =0x000004BC
	add r2, r4, r0
	str r2, [r5, r1]
	ldr r1, [r5, r1]
	sub r0, r0, #4
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov40_0222FB40
	add r0, r4, #0
	bl ov40_0224085C
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #0
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224176A
_02241548:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02241560
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	bne _02241562
_02241560:
	b _0224176A
_02241562:
	mov r0, #0
	mov r1, #1
	bl SetBgPriority
	mov r0, #1
	mov r1, #3
	bl SetBgPriority
	mov r0, #2
	mov r1, #0
	bl SetBgPriority
	mov r0, #3
	mov r1, #1
	bl SetBgPriority
	mov r0, #4
	mov r1, #1
	bl SetBgPriority
	mov r0, #5
	mov r1, #3
	bl SetBgPriority
	mov r0, #6
	mov r1, #0
	bl SetBgPriority
	mov r0, #7
	mov r1, #2
	bl SetBgPriority
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02241780 ; =ov40_022456B4
	ldr r2, _02241784 ; =ov40_02241C10
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _02241788 ; =0x00000608
	ldr r2, _0224178C ; =ov40_02241C70
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _02241790 ; =ov40_02245674
	mov r1, #4
	add r3, r4, #0
	bl TouchHitboxController_Create
	ldr r1, _02241794 ; =0x0000060C
	ldr r2, _02241798 ; =ov40_02241CD8
	str r0, [r5, r1]
	mov r0, #0x6d
	str r0, [sp]
	ldr r0, _0224179C ; =ov40_02245654
	mov r1, #2
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x61
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224176A
_022415E8:
	bl ov40_02242110
	add r0, r4, #0
	bl ov40_02241AB0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _02241660
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	b _0224168C
_02241660:
	add r0, r5, #0
	add r0, #0x80
	add r1, r4, #0
	bl ov40_0222E79C
	add r5, #0x80
	add r0, r5, #0
	mov r1, #0
	bl ov40_0222E7DC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
_0224168C:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #6
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224176A
_022416B4:
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	str r2, [r5, #8]
	bl ov40_0222DA00
	cmp r0, #0
	beq _0224170C
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _022416DC
	sub r0, #0xc0
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	b _022416E6
_022416DC:
	add r0, r5, #0
	add r0, #0x80
	mov r1, #1
	bl ov40_0222E7DC
_022416E6:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_0224170C:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0224176A
_02241726:
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x6d
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224176A
_02241744:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _0224176A
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224176A
_02241754:
	ldr r0, _022417A0 ; =0x000006D8
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov40_0222C4B8
	add r0, r4, #0
	mov r1, #8
	bl ov40_0222BF80
_0224176A:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02241770: .word 0x00002604
_02241774: .word 0x0000079C
_02241778: .word 0x000008B8
_0224177C: .word 0x000004BC
_02241780: .word ov40_022456B4
_02241784: .word ov40_02241C10
_02241788: .word 0x00000608
_0224178C: .word ov40_02241C70
_02241790: .word ov40_02245674
_02241794: .word 0x0000060C
_02241798: .word ov40_02241CD8
_0224179C: .word ov40_02245654
_022417A0: .word 0x000006D8
	thumb_func_end ov40_02241488

	thumb_func_start ov40_022417A4
ov40_022417A4: ; 0x022417A4
	push {r4, lr}
	mov r1, #0x6f
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov40_022417A4

	thumb_func_start ov40_022417DC
ov40_022417DC: ; 0x022417DC
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _022417F0
	b _02241910
_022417F0:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022417FC: ; jump table
	.short _02241804 - _022417FC - 2 ; case 0
	.short _02241818 - _022417FC - 2 ; case 1
	.short _02241876 - _022417FC - 2 ; case 2
	.short _022418FA - _022417FC - 2 ; case 3
_02241804:
	mov r1, #0x77
	bl ov40_0222DED0
	ldr r0, _02241940 ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224193A
_02241818:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02241826
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_02241826:
	mov r3, #0
	mov r0, #0x83
	str r3, [sp]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0x6d
	add r2, sp, #4
	bl sub_0202FC90
	mov r0, #0x6d
	bl sub_020314A4
	mov r1, #0x1d
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	mov r1, #0x83
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	bl sub_020314C4
	add r0, r4, #0
	bl ov40_0223D540
	mov r1, #0x1d
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	bl ov39_02227534
	cmp r0, #1
	bne _0224193A
	mov r0, #0x1d
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl sub_020314BC
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224193A
_02241876:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02241884
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_02241884:
	bl sub_0202FC24
	add r0, r4, #0
	bl ov40_0222DFB0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #8
	bl ov39_02227D44
	cmp r0, #1
	bne _022418D4
	ldr r0, _02241940 ; =0x0000057D
	mov r1, #0
	bl StopSE
	ldr r3, [sp, #8]
	add r0, r4, #0
	ldr r2, [r3, #0xc]
	ldr r3, [r3, #4]
	mov r1, #6
	bl ov40_02230CDC
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	mov r0, #0xff
	str r0, [r4, #8]
	b _0224193A
_022418D4:
	add r0, r4, #0
	mov r1, #0x77
	bl ov40_0222DED0
	add r0, r5, #0
	add r1, r4, #0
	bl ov40_02242E4C
	ldr r0, _02241940 ; =0x0000057D
	mov r1, #0
	bl StopSE
	ldr r0, _02241944 ; =0x00000577
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224193A
_022418FA:
	bl System_GetTouchNew
	cmp r0, #0
	beq _0224193A
	add r0, r4, #0
	bl ov40_0222DFB0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224193A
_02241910:
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r4, #0
	mov r1, #0x23 ; SCORE_EVENT_UPLOADED_BATTLE_VIDEO
	bl ov40_0222FB28
	add r0, r4, #0
	mov r1, #4
	bl ov40_0222BF80
_0224193A:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_02241940: .word 0x0000057D
_02241944: .word 0x00000577
	thumb_func_end ov40_022417DC

	thumb_func_start ov40_02241948
ov40_02241948: ; 0x02241948
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	bne _0224198C
	add r4, #8
	add r0, r4, #0
	bl ov40_0222DAA8
	add r0, r5, #0
	bl ov40_0222C480
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D88C
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02241A30
_0224198C:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _02241A30
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _02241A00
	add r0, r5, #0
	bl ov40_0222DD08
	add r0, r4, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	add r0, r4, #0
	bl Heap_Free
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	b _02241A30
_02241A00:
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_02241A30:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_02241948

	thumb_func_start ov40_02241A34
ov40_02241A34: ; 0x02241A34
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	ldr r0, _02241A50 ; =0x000006D4
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _02241A50 ; =0x000006D4
	add r0, r4, r0
	bl RemoveWindow
	pop {r4, pc}
	nop
_02241A50: .word 0x000006D4
	thumb_func_end ov40_02241A34

	thumb_func_start ov40_02241A54
ov40_02241A54: ; 0x02241A54
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r6, _02241AA8 ; =0x000006D4
	add r7, r1, #0
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	add r1, r7, #0
	bl NewString_ReadMsgData
	add r5, r0, #0
	add r0, r4, r6
	add r1, r5, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02241AAC ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02241AA8: .word 0x000006D4
_02241AAC: .word 0x000F0D00
	thumb_func_end ov40_02241A54

	thumb_func_start ov40_02241AB0
ov40_02241AB0: ; 0x02241AB0
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r6, _02241AF8 ; =0x000006D4
	add r0, r4, r6
	bl InitWindow
	mov r0, #3
	str r0, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, r6
	mov r2, #6
	mov r3, #8
	bl AddWindowParameterized
	mov r1, #0x73
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	add r0, r5, #0
	add r1, #0x79
	bl ov40_02241A54
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	nop
_02241AF8: .word 0x000006D4
	thumb_func_end ov40_02241AB0

	thumb_func_start ov40_02241AFC
ov40_02241AFC: ; 0x02241AFC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r6, _02241BD4 ; =0x000006D4
	add r0, r4, r6
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, r6
	mov r3, #4
	bl AddWindowParameterized
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x82
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r0, r4, r6
	add r1, r7, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02241BD8 ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add r6, #0x10
	add r0, r4, r6
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x15
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, r6
	mov r3, #0x12
	bl AddWindowParameterized
	add r0, r4, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x83
	bl NewString_ReadMsgData
	add r5, r0, #0
	add r0, r4, r6
	add r1, r5, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02241BD8 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02241BD4: .word 0x000006D4
_02241BD8: .word 0x000F0D00
	thumb_func_end ov40_02241AFC

	thumb_func_start ov40_02241BDC
ov40_02241BDC: ; 0x02241BDC
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	ldr r0, _02241C08 ; =0x000006D4
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _02241C08 ; =0x000006D4
	add r0, r4, r0
	bl RemoveWindow
	ldr r0, _02241C0C ; =0x000006E4
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _02241C0C ; =0x000006E4
	add r0, r4, r0
	bl RemoveWindow
	pop {r4, pc}
	nop
_02241C08: .word 0x000006D4
_02241C0C: .word 0x000006E4
	thumb_func_end ov40_02241BDC

	thumb_func_start ov40_02241C10
ov40_02241C10: ; 0x02241C10
	push {r4, lr}
	add r4, r2, #0
	cmp r1, #0
	bne _02241C6E
	cmp r0, #3
	bhi _02241C6E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02241C28: ; jump table
	.short _02241C30 - _02241C28 - 2 ; case 0
	.short _02241C40 - _02241C28 - 2 ; case 1
	.short _02241C50 - _02241C28 - 2 ; case 2
	.short _02241C60 - _02241C28 - 2 ; case 3
_02241C30:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #9
	bl ov40_0222BF80
	pop {r4, pc}
_02241C40:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0xa
	bl ov40_0222BF80
	pop {r4, pc}
_02241C50:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0xc
	bl ov40_0222BF80
	pop {r4, pc}
_02241C60:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0xb
	bl ov40_0222BF80
_02241C6E:
	pop {r4, pc}
	thumb_func_end ov40_02241C10

	thumb_func_start ov40_02241C70
ov40_02241C70: ; 0x02241C70
	push {r4, lr}
	add r4, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r3, [r4, r2]
	cmp r1, #0
	bne _02241CD4
	cmp r0, #3
	bhi _02241CD4
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02241C8E: ; jump table
	.short _02241C96 - _02241C8E - 2 ; case 0
	.short _02241C96 - _02241C8E - 2 ; case 1
	.short _02241C96 - _02241C8E - 2 ; case 2
	.short _02241CC6 - _02241C8E - 2 ; case 3
_02241C96:
	add r1, r0, #1
	mov r0, #0x72
	lsl r0, r0, #2
	str r1, [r3, r0]
	ldr r0, [r3, r0]
	add r2, #0x2c
	lsl r0, r0, #2
	add r0, r4, r0
	ldr r0, [r0, r2]
	cmp r0, #0
	beq _02241CB6
	add r0, r4, #0
	mov r1, #0xf
	bl ov40_0222BF80
	b _02241CBE
_02241CB6:
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
_02241CBE:
	add r0, r4, #0
	bl ov40_02230944
	pop {r4, pc}
_02241CC6:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0xe
	bl ov40_0222BF80
_02241CD4:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02241C70

	thumb_func_start ov40_02241CD8
ov40_02241CD8: ; 0x02241CD8
	push {r4, lr}
	add r4, r2, #0
	cmp r1, #0
	bne _02241D0E
	cmp r0, #0
	beq _02241CEA
	cmp r0, #1
	beq _02241D00
	pop {r4, pc}
_02241CEA:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	bl ov40_02241BDC
	add r0, r4, #0
	mov r1, #0x12
	bl ov40_0222BF80
	pop {r4, pc}
_02241D00:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0x11
	bl ov40_0222BF80
_02241D0E:
	pop {r4, pc}
	thumb_func_end ov40_02241CD8

	thumb_func_start ov40_02241D10
ov40_02241D10: ; 0x02241D10
	push {r4, r5, r6, lr}
	add r6, r0, #0
	mov r0, #0x86
	add r4, r2, #0
	lsl r0, r0, #4
	ldr r5, [r4, r0]
	cmp r1, #0
	bne _02241DFE
	cmp r6, #4
	bhi _02241DFE
	add r1, r6, r6
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02241D30: ; jump table
	.short _02241D3A - _02241D30 - 2 ; case 0
	.short _02241D4E - _02241D30 - 2 ; case 1
	.short _02241D62 - _02241D30 - 2 ; case 2
	.short _02241DC6 - _02241D30 - 2 ; case 3
	.short _02241DD6 - _02241D30 - 2 ; case 4
_02241D3A:
	add r0, r4, #0
	bl ov40_02230944
	ldr r0, _02241E00 ; =0x000004C5
	mov r1, #5
	strb r6, [r5, r0]
	add r0, r4, #0
	bl ov40_0222BF80
	pop {r4, r5, r6, pc}
_02241D4E:
	add r0, r4, #0
	bl ov40_02230944
	ldr r0, _02241E00 ; =0x000004C5
	mov r1, #5
	strb r6, [r5, r0]
	add r0, r4, #0
	bl ov40_0222BF80
	pop {r4, r5, r6, pc}
_02241D62:
	add r0, #0x2c
	ldr r0, [r4, r0]
	bl sub_02031620
	add r6, r0, #0
	add r0, r4, #0
	bl ov40_02230944
	cmp r6, #0
	bne _02241D86
	ldr r0, _02241E04 ; =0x0000057C
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x80
	bl ov40_0222DF60
	pop {r4, r5, r6, pc}
_02241D86:
	ldr r0, _02241E08 ; =0x000004C3
	ldrb r1, [r5, r0]
	cmp r1, #0xff
	bne _02241DA8
	ldr r0, _02241E0C ; =0x0000088C
	ldr r0, [r4, r0]
	bl sub_02031620
	ldr r1, _02241E08 ; =0x000004C3
	strb r0, [r5, r1]
	ldr r0, _02241E0C ; =0x0000088C
	ldr r0, [r4, r0]
	bl sub_0203162C
	ldr r1, _02241E10 ; =0x000004C4
	strb r0, [r5, r1]
	b _02241DB0
_02241DA8:
	mov r1, #0xff
	strb r1, [r5, r0]
	add r0, r0, #1
	strb r1, [r5, r0]
_02241DB0:
	ldr r2, _02241E08 ; =0x000004C3
	add r0, r4, #0
	ldrb r1, [r5, r2]
	add r2, r2, #1
	ldrb r2, [r5, r2]
	bl ov40_0223DDE8
	add r0, r4, #0
	bl ov40_0223DEB8
	pop {r4, r5, r6, pc}
_02241DC6:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #4
	bl ov40_0222BF80
	pop {r4, r5, r6, pc}
_02241DD6:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	bl ov40_0223DB94
	cmp r0, #0
	bne _02241DF6
	ldr r0, _02241E04 ; =0x0000057C
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x74
	bl ov40_0222DF60
	pop {r4, r5, r6, pc}
_02241DF6:
	add r0, r4, #0
	mov r1, #0xc
	bl ov40_0222BF80
_02241DFE:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02241E00: .word 0x000004C5
_02241E04: .word 0x0000057C
_02241E08: .word 0x000004C3
_02241E0C: .word 0x0000088C
_02241E10: .word 0x000004C4
	thumb_func_end ov40_02241D10

	thumb_func_start ov40_02241E14
ov40_02241E14: ; 0x02241E14
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	cmp r1, #0
	bne _02241E3A
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_0223EBB8
	cmp r0, #0
	bne _02241E32
	ldr r0, _02241E3C ; =0x0000057C
	bl PlaySE
	pop {r3, r4, r5, pc}
_02241E32:
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_0223EC40
_02241E3A:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02241E3C: .word 0x0000057C
	thumb_func_end ov40_02241E14

	thumb_func_start ov40_02241E40
ov40_02241E40: ; 0x02241E40
	push {r3, r4, r5, lr}
	add r4, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r5, [r4, r2]
	cmp r1, #0
	bne _02241ED0
	cmp r0, #3
	bhi _02241ED0
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02241E5E: ; jump table
	.short _02241E66 - _02241E5E - 2 ; case 0
	.short _02241E76 - _02241E5E - 2 ; case 1
	.short _02241E9C - _02241E5E - 2 ; case 2
	.short _02241EC2 - _02241E5E - 2 ; case 3
_02241E66:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0x13
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_02241E76:
	add r0, r4, #0
	bl ov40_02230944
	bl sub_0202FC48
	cmp r0, #0
	beq _02241E8E
	add r0, r4, #0
	mov r1, #0x14
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_02241E8E:
	mov r0, #0x14
	str r0, [r5, #0xc]
	add r0, r4, #0
	mov r1, #0x1d
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_02241E9C:
	add r0, r4, #0
	bl ov40_02230944
	bl sub_0202FC48
	cmp r0, #0
	beq _02241EB4
	add r0, r4, #0
	mov r1, #0x16
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_02241EB4:
	mov r0, #0x16
	str r0, [r5, #0xc]
	add r0, r4, #0
	mov r1, #0x1d
	bl ov40_0222BF80
	pop {r3, r4, r5, pc}
_02241EC2:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0x15
	bl ov40_0222BF80
_02241ED0:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02241E40

	thumb_func_start ov40_02241ED4
ov40_02241ED4: ; 0x02241ED4
	push {r4, lr}
	add r4, r2, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r3, [r4, r2]
	cmp r1, #0
	bne _02241F38
	cmp r0, #3
	bhi _02241F38
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02241EF2: ; jump table
	.short _02241EFA - _02241EF2 - 2 ; case 0
	.short _02241EFA - _02241EF2 - 2 ; case 1
	.short _02241EFA - _02241EF2 - 2 ; case 2
	.short _02241F2A - _02241EF2 - 2 ; case 3
_02241EFA:
	add r1, r0, #1
	mov r0, #0x72
	lsl r0, r0, #2
	str r1, [r3, r0]
	ldr r0, [r3, r0]
	add r2, #0x2c
	lsl r0, r0, #2
	add r0, r4, r0
	ldr r0, [r0, r2]
	cmp r0, #0
	beq _02241F1A
	add r0, r4, #0
	mov r1, #0x19
	bl ov40_0222BF80
	b _02241F22
_02241F1A:
	add r0, r4, #0
	mov r1, #0x1c
	bl ov40_0222BF80
_02241F22:
	add r0, r4, #0
	bl ov40_02230944
	pop {r4, pc}
_02241F2A:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0x18
	bl ov40_0222BF80
_02241F38:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02241ED4

	thumb_func_start ov40_02241F3C
ov40_02241F3C: ; 0x02241F3C
	push {r4, lr}
	add r4, r2, #0
	cmp r1, #0
	bne _02241F72
	cmp r0, #0
	beq _02241F4E
	cmp r0, #1
	beq _02241F64
	pop {r4, pc}
_02241F4E:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	bl ov40_02241BDC
	add r0, r4, #0
	mov r1, #0x1c
	bl ov40_0222BF80
	pop {r4, pc}
_02241F64:
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	mov r1, #0x1b
	bl ov40_0222BF80
_02241F72:
	pop {r4, pc}
	thumb_func_end ov40_02241F3C

	thumb_func_start ov40_02241F74
ov40_02241F74: ; 0x02241F74
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r0, r2]
	cmp r1, #0
	ldr r0, [r4, #0x14]
	bne _02241F9C
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [r4, #0x30]
	mov r1, #0x80
	mov r2, #0xa8
	bl ManagedSprite_SetPositionXY
	b _02241FB4
_02241F9C:
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r4, #0x18]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [r4, #0x30]
	mov r1, #0x50
	mov r2, #0xa8
	bl ManagedSprite_SetPositionXY
_02241FB4:
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, #0x18]
	sub r2, #0x2c
	bl sub_020136B4
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, #0x34]
	sub r2, #0x2c
	bl sub_020136B4
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02241F74

	thumb_func_start ov40_02241FD0
ov40_02241FD0: ; 0x02241FD0
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	mov r1, #1
	bl ov40_0222D6EC
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222D800
	str r0, [r5, #0x14]
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222D800
	str r0, [r5, #0x30]
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #1
	bl ov40_0222D5AC
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #1
	bl ov40_0222D5AC
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x6f
	bl ov40_0222D66C
	ldr r0, [r5, #0x14]
	mov r1, #0x20
	mov r2, #0xa8
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x30]
	mov r1, #0x80
	mov r2, #0xa8
	bl ManagedSprite_SetPositionXY
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r5, #0x18]
	sub r2, #0x2c
	bl sub_020136B4
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r5, #0x34]
	sub r2, #0x2c
	bl sub_020136B4
	ldr r0, [r5, #0x18]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r5, #0x30]
	mov r1, #1
	bl ManagedSprite_SetAnim
	add r0, r4, #0
	mov r1, #0
	bl ov40_02241F74
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02241FD0

	thumb_func_start ov40_02242084
ov40_02242084: ; 0x02242084
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r5, [r4, r0]
	add r0, r5, #0
	add r0, #0x10
	bl ov40_0222D6D0
	add r0, r5, #0
	add r0, #0x2c
	bl ov40_0222D6D0
	ldr r0, [r5, #0x14]
	bl Sprite_DeleteAndFreeResources
	ldr r0, [r5, #0x30]
	bl Sprite_DeleteAndFreeResources
	add r0, r4, #0
	bl ov40_0222D7DC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02242084

	thumb_func_start ov40_022420B4
ov40_022420B4: ; 0x022420B4
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r4, [r0, r2]
	cmp r1, #0
	ldr r0, [r4, #0x30]
	bne _022420DC
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [r4, #0x14]
	mov r1, #0x20
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	b _022420F4
_022420DC:
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [r4, #0x14]
	mov r1, #0x50
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
_022420F4:
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, #0x18]
	sub r2, #0x2c
	bl sub_020136B4
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, #0x34]
	sub r2, #0x2c
	bl sub_020136B4
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_022420B4

	thumb_func_start ov40_02242110
ov40_02242110: ; 0x02242110
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	mov r1, #2
	bl ov40_0222D6EC
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222D800
	str r0, [r4, #0x14]
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222D800
	str r0, [r4, #0x30]
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #2
	bl ov40_0222D5AC
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #2
	bl ov40_0222D5AC
	ldr r0, _022421F8 ; =0x0000086C
	ldr r0, [r5, r0]
	cmp r0, #0xd2
	bne _02242186
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x6f
	bl ov40_0222D66C
	ldr r0, [r4, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r4, #0x30]
	mov r1, #1
	bl ManagedSprite_SetAnim
	b _022421B2
_02242186:
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r4, #0
	add r1, r5, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	ldr r0, [r4, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r4, #0x30]
	mov r1, #3
	bl ManagedSprite_SetAnim
_022421B2:
	ldr r0, [r4, #0x14]
	mov r1, #0x20
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	ldr r0, [r4, #0x30]
	mov r1, #0x80
	mov r2, #0xe8
	bl ManagedSprite_SetPositionXY
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, #0x18]
	sub r2, #0x2c
	bl sub_020136B4
	mov r1, #0x24
	add r2, r1, #0
	ldr r0, [r4, #0x34]
	sub r2, #0x2c
	bl sub_020136B4
	ldr r0, [r4, #0x18]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	add r0, r5, #0
	mov r1, #0
	bl ov40_022420B4
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022421F8: .word 0x0000086C
	thumb_func_end ov40_02242110

	thumb_func_start ov40_022421FC
ov40_022421FC: ; 0x022421FC
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r5, [r4, r0]
	add r0, r5, #0
	add r0, #0x10
	bl ov40_0222D6D0
	add r0, r5, #0
	add r0, #0x2c
	bl ov40_0222D6D0
	ldr r0, [r5, #0x14]
	bl Sprite_DeleteAndFreeResources
	ldr r0, [r5, #0x30]
	bl Sprite_DeleteAndFreeResources
	add r0, r4, #0
	bl ov40_0222D7DC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_022421FC

	thumb_func_start ov40_0224222C
ov40_0224222C: ; 0x0224222C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #3
	bls _0224223E
	b _0224235A
_0224223E:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224224A: ; jump table
	.short _02242252 - _0224224A - 2 ; case 0
	.short _02242290 - _0224224A - 2 ; case 1
	.short _022422A8 - _0224224A - 2 ; case 2
	.short _02242312 - _0224224A - 2 ; case 3
_02242252:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	cmp r1, #0
	bne _0224226E
	sub r0, #0xc0
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0223064C
	b _02242278
_0224226E:
	add r4, #0x80
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_0222E7B8
_02242278:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242374
_02242290:
	mov r2, #1
	add r0, r4, #0
	add r1, r4, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242374
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242374
_022422A8:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	cmp r1, #0
	bne _022422D8
	add r0, r4, #0
	add r0, #0x80
	add r1, r5, #0
	bl ov40_0222E79C
	add r4, #0x80
	add r0, r4, #0
	mov r1, #0
	bl ov40_0222E7DC
	add r0, r5, #0
	mov r1, #0x50
	mov r2, #3
	bl ov40_022307DC
	b _02242302
_022422D8:
	sub r0, #0xc0
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r5, #0
	mov r2, #3
	bl ov40_022307DC
_02242302:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242374
_02242312:
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242374
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	cmp r1, #0
	bne _02242338
	add r4, #0x80
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222E7DC
	b _02242342
_02242338:
	sub r0, #0xc0
	add r0, r4, r0
	mov r1, #1
	bl ov40_022306A0
_02242342:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242374
_0224235A:
	mov r1, #0x73
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	mov r0, #1
	eor r0, r2
	str r0, [r4, r1]
	ldr r1, [r4, r1]
	add r0, r5, #0
	add r1, #0x79
	bl ov40_02241A54
	mov r0, #1
	pop {r3, r4, r5, pc}
_02242374:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_0224222C

	thumb_func_start ov40_02242378
ov40_02242378: ; 0x02242378
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02242392
	cmp r1, #1
	beq _022423DE
	cmp r1, #2
	beq _02242444
	b _02242488
_02242392:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	cmp r1, #0
	bne _022423AE
	sub r0, #0xc0
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0223064C
	b _022423B8
_022423AE:
	add r4, #0x80
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_0222E7B8
_022423B8:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02241A34
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0224248C
_022423DE:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _0224242A
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_022421FC
	add r0, r5, #0
	bl ov40_02241054
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0224242A:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0224248C
_02242444:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #1
	bl ov40_0222DA00
	cmp r0, #0
	beq _0224246E
	add r0, r5, #0
	mov r1, #0x64
	mov r2, #0
	bl ov40_02240E28
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_0224246E:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0224248C
_02242488:
	mov r0, #1
	pop {r3, r4, r5, pc}
_0224248C:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_02242378

	thumb_func_start ov40_02242490
ov40_02242490: ; 0x02242490
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _022424A8
	cmp r0, #1
	beq _02242508
	b _0224252E
_022424A8:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _022424EE
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x54
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r2, #0x72
	lsl r2, r2, #2
	ldr r2, [r4, r2]
	add r0, r5, #0
	mov r1, #0x66
	bl ov40_02240F24
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022424EE:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02242534
_02242508:
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242534
	add r0, r5, #0
	bl ov40_02241AFC
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242534
_0224252E:
	add sp, #0x10
	mov r0, #1
	pop {r3, r4, r5, pc}
_02242534:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02242490

	thumb_func_start ov40_0224253C
ov40_0224253C: ; 0x0224253C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _02242556
	cmp r0, #1
	beq _02242566
	cmp r0, #2
	beq _02242594
	b _022425E0
_02242556:
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _022425E4
_02242566:
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _022425E4
	add r0, r5, #0
	bl ov40_02241BDC
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _022425E4
_02242594:
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _022425C6
	add r0, r5, #0
	mov r1, #0x64
	mov r2, #0
	bl ov40_02240F24
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_022425C6:
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022425E4
_022425E0:
	mov r0, #1
	pop {r3, r4, r5, pc}
_022425E4:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_0224253C

	thumb_func_start ov40_022425E8
ov40_022425E8: ; 0x022425E8
	push {r4, r5, r6, lr}
	sub sp, #8
	add r4, r0, #0
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r1, [r4, #8]
	ldr r5, [r4, r2]
	cmp r1, #7
	bls _022425FC
	b _022427FC
_022425FC:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02242608: ; jump table
	.short _02242618 - _02242608 - 2 ; case 0
	.short _02242628 - _02242608 - 2 ; case 1
	.short _0224267A - _02242608 - 2 ; case 2
	.short _0224269A - _02242608 - 2 ; case 3
	.short _022426D0 - _02242608 - 2 ; case 4
	.short _02242714 - _02242608 - 2 ; case 5
	.short _0224275A - _02242608 - 2 ; case 6
	.short _022427A6 - _02242608 - 2 ; case 7
_02242618:
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022428AE
_02242628:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242660
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r1, _022428B4 ; =0x00000116
	add r0, r4, #0
	mov r2, #0
	bl ov40_02240F24
	add r0, r4, #0
	bl ov40_022306E0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02242660:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _022428AE
_0224267A:
	mov r1, #0x72
	sub r2, #0xc4
	lsl r1, r1, #2
	ldrb r2, [r5, r2]
	ldr r1, [r5, r1]
	bl ov40_0222FC14
	cmp r0, #0
	beq _02242762
	ldr r0, _022428B8 ; =0x0000079C
	mov r1, #0
	strb r1, [r5, r0]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022428AE
_0224269A:
	mov r1, #0x6f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x80
	mov r3, #0x60
	bl ov40_0223077C
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0x18
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	ldr r0, _022428BC ; =0x0000057D
	bl PlaySE
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022428AE
_022426D0:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _022426DE
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_022426DE:
	mov r1, #0x46
	add r0, r4, #0
	lsl r1, r1, #2
	mov r2, #0
	bl ov40_02240F24
	bl sub_020307F8
	mov r1, #4
	mov r2, #0
	bl sub_0203088C
	add r6, r0, #0
	add r5, r1, #0
	add r0, r4, #0
	bl ov40_0223D540
	add r1, r6, #0
	add r2, r5, #0
	bl ov39_0222774C
	cmp r0, #1
	bne _02242762
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022428AE
_02242714:
	bl ov40_0223D5CC
	cmp r0, #0
	bne _02242722
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_02242722:
	add r0, r4, #0
	bl ov40_0223D540
	add r1, sp, #4
	bl ov39_02227D44
	cmp r0, #1
	ldr r0, _022428BC ; =0x0000057D
	bne _0224273C
	mov r1, #0
	bl StopSE
	b _02242748
_0224273C:
	mov r1, #0
	bl StopSE
	ldr r0, _022428C0 ; =0x00000577
	bl PlaySE
_02242748:
	ldr r0, [r4, #8]
	ldr r1, _022428C4 ; =0x00000119
	add r0, r0, #1
	str r0, [r4, #8]
	add r0, r4, #0
	mov r2, #0
	bl ov40_02240F24
	b _022428AE
_0224275A:
	bl System_GetTouchNew
	cmp r0, #0
	bne _02242764
_02242762:
	b _022428AE
_02242764:
	add r0, r4, #0
	bl ov40_0222DEAC
	add r0, r4, #0
	bl ov40_02241114
	mov r0, #0x6f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl sub_020879E0
	mov r0, #0x6f
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	bl sub_02087A08
	add r0, r4, #0
	bl ov40_0222FDC4
	add r0, r4, #0
	bl ov40_0222FCCC
	ldr r0, _022428C8 ; =0x0000049C
	add r0, r4, r0
	bl ov40_0222F734
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022428AE
_022427A6:
	ldr r0, _022428CC ; =0x00000608
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	ldr r0, _022428D0 ; =0x0000060C
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x61
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl TouchHitboxController_Destroy
	add r5, #8
	add r0, r5, #0
	bl ov40_0222DAA8
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r4, #0
	bl ov40_02240910
	add r0, r4, #0
	bl ov40_0222D88C
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #1
	mov r1, #0x6d
	bl sub_0203A948
	add r0, r4, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _022428AE
_022427FC:
	add r0, r4, #0
	bl ov40_0222FBB4
	cmp r0, #0
	beq _022428AE
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _0224287E
	add r0, r4, #0
	bl ov40_0222DD08
	add r0, r5, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r4, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r4, #0x10]
	add r0, r4, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r4, #0
	mov r1, #5
	bl ov40_0222BF80
	add r0, r5, #0
	bl Heap_Free
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	bl sub_0202FC48
	cmp r0, #1
	bne _022428AE
	bl sub_0202FC24
	b _022428AE
_0224287E:
	ldr r0, [r4, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_022428AE:
	mov r0, #0
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_022428B4: .word 0x00000116
_022428B8: .word 0x0000079C
_022428BC: .word 0x0000057D
_022428C0: .word 0x00000577
_022428C4: .word 0x00000119
_022428C8: .word 0x0000049C
_022428CC: .word 0x00000608
_022428D0: .word 0x0000060C
	thumb_func_end ov40_022425E8

	thumb_func_start ov40_022428D4
ov40_022428D4: ; 0x022428D4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r1, [r4, #8]
	ldr r5, [r4, r0]
	cmp r1, #3
	bls _022428E8
	b _02242AE0
_022428E8:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022428F4: ; jump table
	.short _022428FC - _022428F4 - 2 ; case 0
	.short _02242924 - _022428F4 - 2 ; case 1
	.short _0224295E - _022428F4 - 2 ; case 2
	.short _02242A76 - _022428F4 - 2 ; case 3
_022428FC:
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02242AE6
_02242924:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242944
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02242944:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02242AE6
_0224295E:
	add r0, #0xc
	ldr r0, [r4, r0]
	cmp r0, #0xd2
	bne _02242992
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r5, #0x30]
	mov r1, #3
	bl ManagedSprite_SetAnim
_02242992:
	add r0, r4, #0
	bl ov40_02241A34
	add r0, r4, #0
	bl ov40_02241AB0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _02242A18
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_0223064C
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	b _02242A4E
_02242A18:
	add r0, r5, #0
	add r0, #0x80
	add r1, r4, #0
	bl ov40_0222E7B8
	add r0, r5, #0
	add r0, #0x80
	add r1, r4, #0
	bl ov40_0222E79C
	add r5, #0x80
	add r0, r5, #0
	mov r1, #0
	bl ov40_0222E7DC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
_02242A4E:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #6
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02242AE6
_02242A76:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242AC6
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _02242AA6
	sub r0, #0xc0
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	b _02242AB0
_02242AA6:
	add r0, r5, #0
	add r0, #0x80
	mov r1, #1
	bl ov40_0222E7DC
_02242AB0:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02242AC6:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02242AE6
_02242AE0:
	add sp, #0x10
	mov r0, #1
	pop {r3, r4, r5, pc}
_02242AE6:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_022428D4

	thumb_func_start ov40_02242AEC
ov40_02242AEC: ; 0x02242AEC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #3
	bls _02242B00
	b _02242CEA
_02242B00:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02242B0C: ; jump table
	.short _02242B14 - _02242B0C - 2 ; case 0
	.short _02242B40 - _02242B0C - 2 ; case 1
	.short _02242B80 - _02242B0C - 2 ; case 2
	.short _02242C80 - _02242B0C - 2 ; case 3
_02242B14:
	bl ov40_0222DEAC
	ldr r0, [r4, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r4, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02242CF0
_02242B40:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242B66
	add r0, r4, #0
	bl ov40_02241114
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02242B66:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02242CF0
_02242B80:
	bl ov40_02242110
	ldr r0, _02242CF8 ; =0x0000086C
	ldr r0, [r4, r0]
	cmp r0, #0xd2
	bne _02242BB8
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x10
	add r1, #0x14
	mov r2, #3
	bl ov40_0222D66C
	add r0, r5, #0
	add r1, r4, #0
	add r0, #0x2c
	add r1, #0x14
	mov r2, #0x5e
	bl ov40_0222D66C
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl ManagedSprite_SetAnim
	ldr r0, [r5, #0x30]
	mov r1, #3
	bl ManagedSprite_SetAnim
_02242BB8:
	add r0, r4, #0
	bl ov40_02241AB0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r4, #0
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _02242C2C
	sub r0, #0xc0
	add r0, r5, r0
	add r1, r4, #0
	bl ov40_02230638
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	mov r1, #0
	bl ov40_022306A0
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl ov40_02230410
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #3
	bl ov40_022307DC
	b _02242C58
_02242C2C:
	add r0, r5, #0
	add r0, #0x80
	add r1, r4, #0
	bl ov40_0222E79C
	add r5, #0x80
	add r0, r5, #0
	mov r1, #0
	bl ov40_0222E7DC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x50
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
_02242C58:
	add r0, r4, #0
	mov r1, #0
	bl ov40_02230964
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #6
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _02242CF0
_02242C80:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	mov r2, #0
	add r0, r5, #0
	add r1, r5, #4
	add r3, r2, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _02242CD0
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _02242CB0
	sub r0, #0xc0
	add r0, r5, r0
	mov r1, #1
	bl ov40_022306A0
	b _02242CBA
_02242CB0:
	add r0, r5, #0
	add r0, #0x80
	mov r1, #1
	bl ov40_0222E7DC
_02242CBA:
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_02242CD0:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02242CF0
_02242CEA:
	add sp, #0x10
	mov r0, #1
	pop {r3, r4, r5, pc}
_02242CF0:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_02242CF8: .word 0x0000086C
	thumb_func_end ov40_02242AEC

	thumb_func_start ov40_02242CFC
ov40_02242CFC: ; 0x02242CFC
	push {r4, r5, lr}
	sub sp, #0xc
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02242D18
	cmp r1, #1
	beq _02242D38
	cmp r1, #2
	beq _02242D48
	b _02242DD6
_02242D18:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x6d
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242DDC
_02242D38:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _02242DDC
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242DDC
_02242D48:
	mov r1, #1
	bl ov40_02230964
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	cmp r1, #0
	bne _02242D64
	sub r0, #0xc0
	add r0, r4, r0
	add r1, r5, #0
	bl ov40_0223064C
	b _02242D6E
_02242D64:
	add r0, r4, #0
	add r0, #0x80
	add r1, r5, #0
	bl ov40_0222E7B8
_02242D6E:
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, _02242DE4 ; =0x00000608
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	ldr r0, _02242DE8 ; =0x0000060C
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	mov r0, #0x61
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_02240910
	add r0, r5, #0
	bl ov40_02241A34
	add r0, r5, #0
	bl ov40_022421FC
	add r0, r5, #0
	bl ov40_0222D8C8
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r1, [r5, #0x10]
	add r0, r5, #0
	ldr r1, [r1]
	bl ov40_0222C4E8
	ldr r0, _02242DEC ; =0x00000868
	mov r1, #1
	ldr r0, [r5, r0]
	mov r2, #0
	bl sub_02087A84
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02242DDC
_02242DD6:
	add sp, #0xc
	mov r0, #1
	pop {r4, r5, pc}
_02242DDC:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_02242DE4: .word 0x00000608
_02242DE8: .word 0x0000060C
_02242DEC: .word 0x00000868
	thumb_func_end ov40_02242CFC

	thumb_func_start ov40_02242DF0
ov40_02242DF0: ; 0x02242DF0
	push {r4, lr}
	mov r2, #0x86
	lsl r2, r2, #4
	ldr r1, [r1]
	ldr r4, [r0, r2]
	cmp r1, #1
	beq _02242E10
	bl ov40_0223D540
	bl ov39_02227FEC
	mov r2, #0x4b
	lsl r2, r2, #4
	str r0, [r4, r2]
	add r0, r2, #4
	str r1, [r4, r0]
_02242E10:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02242DF0

	thumb_func_start ov40_02242E14
ov40_02242E14: ; 0x02242E14
	push {r4, lr}
	ldr r1, [r1]
	add r4, r0, #0
	cmp r1, #1
	beq _02242E3C
	bl ov40_0223D540
	ldr r1, _02242E40 ; =0x000008B4
	add r1, r4, r1
	bl ov39_022280D4
	add r0, r4, #0
	bl ov40_0222FB40
	ldr r0, _02242E40 ; =0x000008B4
	ldr r0, [r4, r0]
	add r0, #0xa7
	ldrb r1, [r0]
	ldr r0, _02242E44 ; =0x00002604
	strb r1, [r4, r0]
_02242E3C:
	pop {r4, pc}
	nop
_02242E40: .word 0x000008B4
_02242E44: .word 0x00002604
	thumb_func_end ov40_02242E14

	thumb_func_start ov40_02242E48
ov40_02242E48: ; 0x02242E48
	bx lr
	.balign 4, 0
	thumb_func_end ov40_02242E48

	thumb_func_start ov40_02242E4C
ov40_02242E4C: ; 0x02242E4C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	add r4, r0, #0
	mov r0, #0x6d
	add r5, r1, #0
	bl ov40_0222DAB0
	add r6, r0, #0
	mov r0, #0x4b
	lsl r0, r0, #4
	ldr r7, [r4, r0]
	add r0, r0, #4
	ldr r4, [r4, r0]
	mov r0, #0xff
	mov r1, #0x6d
	str r4, [sp, #0x14]
	bl String_New
	str r0, [sp, #0x18]
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x1c]
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x20]
	ldr r2, _02242F9C ; =0x000186A0
	add r0, r7, #0
	add r1, r4, #0
	mov r3, #0
	bl _ll_udiv
	str r0, [sp, #0x24]
	add r4, r1, #0
	ldr r0, [r5, #0x48]
	ldr r1, _02242FA0 ; =0x00000127
	bl NewString_ReadMsgData
	str r0, [sp, #0x28]
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	str r0, [sp, #0x2c]
	ldr r1, [sp, #0x14]
	ldr r2, _02242F9C ; =0x000186A0
	add r0, r7, #0
	mov r3, #0
	bl _ull_mod
	add r1, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [sp, #0x18]
	mov r2, #5
	mov r3, #2
	bl String16_FormatInteger
	ldr r0, [sp, #0x24]
	ldr r2, _02242F9C ; =0x000186A0
	add r1, r4, #0
	mov r3, #0
	bl _ull_mod
	add r1, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [sp, #0x1c]
	mov r2, #5
	mov r3, #2
	bl String16_FormatInteger
	ldr r0, [sp, #0x24]
	ldr r2, _02242F9C ; =0x000186A0
	add r1, r4, #0
	mov r3, #0
	bl _ll_udiv
	add r1, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r2, #2
	ldr r0, [sp, #0x20]
	add r3, r2, #0
	bl String16_FormatInteger
	mov r0, #1
	str r0, [sp]
	mov r1, #2
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	mov r3, #0
	str r1, [sp, #4]
	bl BufferString
	mov r1, #1
	str r1, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r2, [sp, #0x1c]
	add r0, r6, #0
	mov r3, #0
	bl BufferString
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x20]
	add r0, r6, #0
	add r3, r1, #0
	bl BufferString
	ldr r1, [sp, #0x2c]
	ldr r2, [sp, #0x28]
	add r0, r6, #0
	bl StringExpandPlaceholders
	ldr r0, _02242FA4 ; =0x000008A4
	mov r1, #0xcc
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02242FA8 ; =0x000F0D00
	ldr r2, [sp, #0x2c]
	str r0, [sp, #8]
	ldr r0, _02242FA4 ; =0x000008A4
	add r3, r1, #0
	add r0, r5, r0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _02242FA4 ; =0x000008A4
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	ldr r0, [sp, #0x18]
	bl String_Delete
	ldr r0, [sp, #0x1c]
	bl String_Delete
	ldr r0, [sp, #0x20]
	bl String_Delete
	ldr r0, [sp, #0x28]
	bl String_Delete
	ldr r0, [sp, #0x2c]
	bl String_Delete
	add r0, r6, #0
	bl MessageFormat_ResetBuffers
	add r0, r6, #0
	bl MessageFormat_Delete
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02242F9C: .word 0x000186A0
_02242FA0: .word 0x00000127
_02242FA4: .word 0x000008A4
_02242FA8: .word 0x000F0D00
	thumb_func_end ov40_02242E4C

	thumb_func_start ov40_02242FAC
ov40_02242FAC: ; 0x02242FAC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r1, #0
	mov r1, #0x20
	str r0, [sp]
	add r5, r2, #0
	add r7, r3, #0
	bl Heap_Alloc
	mov r1, #0
	mov r2, #0x20
	add r4, r0, #0
	bl MI_CpuFill8
	ldr r1, [sp]
	add r0, r6, #1
	str r6, [r4]
	bl String_New
	str r0, [r4, #0x18]
	str r7, [r4, #0x1c]
	mov r2, #0
	add r1, r5, #0
	add r3, r4, #0
_02242FDA:
	ldr r0, [r1]
	add r2, r2, #1
	str r0, [r3, #4]
	add r1, r1, #4
	add r3, r3, #4
	cmp r2, #3
	blt _02242FDA
	sub r0, r2, #1
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	lsl r0, r2, #2
	add r0, r4, r0
	str r1, [r0, #4]
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov40_02242FAC

	thumb_func_start ov40_02242FF8
ov40_02242FF8: ; 0x02242FF8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	cmp r0, #0
	bne _02243006
	bl GF_AssertFail
_02243006:
	cmp r4, #0
	bne _0224300E
	bl GF_AssertFail
_0224300E:
	ldr r0, [r4, #0x18]
	bl String_Delete
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov40_02242FF8

	thumb_func_start ov40_0224301C
ov40_0224301C: ; 0x0224301C
	push {r3, r4}
	mov r2, #0x82
	lsl r2, r2, #2
	ldr r4, [r0, r2]
	add r3, r2, #4
	str r4, [r0, r3]
	str r1, [r0, r2]
	add r1, r2, #0
	mov r3, #0
	add r1, #8
	str r3, [r0, r1]
	add r1, r2, #0
	add r1, #0xc
	str r3, [r0, r1]
	add r1, r2, #0
	add r1, #0x10
	str r3, [r0, r1]
	add r1, r2, #0
	add r1, #0x14
	str r3, [r0, r1]
	ldr r1, [r0, r2]
	cmp r1, #0
	beq _0224306E
	sub r1, r1, #1
	lsl r1, r1, #2
	add r3, r0, r1
	add r1, r2, #0
	sub r1, #0x24
	ldrh r3, [r3, r1]
	add r1, r2, #0
	add r1, #8
	str r3, [r0, r1]
	ldr r1, [r0, r2]
	sub r1, r1, #1
	lsl r1, r1, #2
	add r3, r0, r1
	add r1, r2, #0
	sub r1, #0x22
	ldrh r1, [r3, r1]
	add r2, #0xc
	str r1, [r0, r2]
_0224306E:
	mov r2, #0x83
	lsl r2, r2, #2
	ldr r1, [r0, r2]
	cmp r1, #0
	beq _0224309C
	sub r1, r1, #1
	lsl r1, r1, #2
	add r3, r0, r1
	add r1, r2, #0
	sub r1, #0x28
	ldrh r3, [r3, r1]
	add r1, r2, #0
	add r1, #0xc
	str r3, [r0, r1]
	ldr r1, [r0, r2]
	sub r1, r1, #1
	lsl r1, r1, #2
	add r3, r0, r1
	add r1, r2, #0
	sub r1, #0x26
	ldrh r1, [r3, r1]
	add r2, #0x10
	str r1, [r0, r2]
_0224309C:
	pop {r3, r4}
	bx lr
	thumb_func_end ov40_0224301C

	thumb_func_start ov40_022430A0
ov40_022430A0: ; 0x022430A0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	mov r2, #0xa6
	lsl r2, r2, #2
	add r4, r2, #0
	mov r1, #1
	add r3, r0, #0
	str r1, [r3, r2]
	mov r5, #0
	sub r4, #0xb4
	strh r5, [r3, r4]
	add r4, r2, #0
	add r4, #0x14
	ldr r5, [r3, r4]
	add r4, r2, #0
	sub r4, #0xb2
	strh r5, [r3, r4]
	add r4, r2, #0
	add r4, #0x14
	ldr r5, [r3, r4]
	add r4, r2, #0
	sub r4, #0xb0
	strh r5, [r3, r4]
	add r4, r2, #0
	add r4, #0x14
	ldr r5, [r3, r4]
	add r4, r2, #0
	add r4, #0x18
	ldr r3, [r3, r4]
	add r4, r2, #0
	add r5, r5, r3
	add r6, r2, #0
	sub r4, #0xae
	add r3, r0, #0
	strh r5, [r3, r4]
	add r4, r2, #0
	add r4, #0x14
	ldr r5, [r3, r4]
	add r4, r2, #0
	add r4, #0x18
	ldr r3, [r3, r4]
	add r4, r2, #0
	add r5, r5, r3
	sub r4, #0xac
	add r3, r0, #0
	strh r5, [r3, r4]
	add r4, r2, #0
	add r5, r2, #0
	add r4, #0x1c
	add r5, #0x14
	ldr r4, [r3, r4]
	ldr r3, [r3, r5]
	add r6, #0x18
	add r5, r0, #0
	ldr r5, [r5, r6]
	sub r2, #0xaa
	add r3, r3, r5
	add r4, r4, r3
	add r3, r0, #0
	str r0, [sp]
	strh r4, [r3, r2]
	bl ov40_0224301C
	mov r4, #0x81
	lsl r4, r4, #2
	add r3, r4, #0
	ldr r1, [sp]
	mov r0, #0
	add r3, #0xa8
_0224312A:
	ldr r2, [sp]
	add r0, r0, #1
	ldr r5, [r2, r4]
	ldr r2, [r1, r3]
	add r1, r1, #4
	add r5, r5, r2
	ldr r2, [sp]
	cmp r0, #3
	str r5, [r2, r4]
	blt _0224312A
	ldr r4, _02243208 ; =ov40_02245C28
	add r3, sp, #8
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	mov r1, #0xab
	ldr r0, [sp]
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	mov r2, #0
	cmp r0, #4
	beq _0224315E
	mov r2, #1
_0224315E:
	mov r0, #0xc
	mul r0, r2
	add r3, sp, #8
	add r0, r3, r0
	mov r2, #0x77
	ldr r5, [sp]
	mov r1, #0
	add r4, r0, #0
	lsl r2, r2, #2
_02243170:
	ldr r3, [r4]
	add r1, r1, #1
	strh r3, [r5, r2]
	add r4, r4, #4
	add r5, r5, #2
	cmp r1, #3
	blt _02243170
	sub r2, r1, #1
	lsl r2, r2, #2
	ldr r2, [r0, r2]
	ldr r0, [sp]
	lsl r1, r1, #1
	add r1, r0, r1
	mov r0, #0x77
	lsl r0, r0, #2
	strh r2, [r1, r0]
	ldr r1, [sp]
	mov r0, #0
	mov r4, #0xab
	mov r5, #0x15
	add r3, r0, #0
	add r2, r1, #0
	lsl r4, r4, #2
	lsl r5, r5, #4
_022431A0:
	ldr r6, [r1, r4]
	add r3, r3, #1
	add r0, r0, r6
	sub r6, r0, #1
	str r6, [r2, r5]
	add r1, r1, #4
	add r2, #0x1c
	cmp r3, #2
	blt _022431A0
	ldr r0, [sp]
	mov r5, #0
	mov r7, #0xab
	mov ip, r5
	str r0, [sp, #4]
	add r4, r0, #0
	lsl r7, r7, #2
_022431C0:
	mov r0, #0xab
	ldr r2, [sp, #4]
	lsl r0, r0, #2
	ldr r0, [r2, r0]
	mov r1, #0
	cmp r0, #0
	ble _022431EC
	mov r0, ip
	lsl r3, r0, #2
	ldr r0, [sp]
	add r2, r4, #0
	add r3, r0, r3
	mov r0, ip
	add r6, r0, #1
_022431DC:
	str r6, [r2, #4]
	ldr r0, [r3, r7]
	add r1, r1, #1
	add r2, #0x1c
	add r4, #0x1c
	add r5, r5, #1
	cmp r1, r0
	blt _022431DC
_022431EC:
	ldr r0, [sp, #4]
	ldr r1, [sp]
	add r0, r0, #4
	str r0, [sp, #4]
	mov r0, ip
	add r0, r0, #1
	mov ip, r0
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	cmp r5, r0
	blt _022431C0
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02243208: .word ov40_02245C28
	thumb_func_end ov40_022430A0

	thumb_func_start ov40_0224320C
ov40_0224320C: ; 0x0224320C
	mov r2, #0x7d
	lsl r2, r2, #2
	str r1, [r0, r2]
	mov r3, #0
	add r1, r2, #4
	str r3, [r0, r1]
	add r1, r2, #0
	add r1, #8
	str r3, [r0, r1]
	add r2, #0xc
	str r3, [r0, r2]
	bx lr
	thumb_func_end ov40_0224320C

	thumb_func_start ov40_02243224
ov40_02243224: ; 0x02243224
	push {r4, lr}
	add r4, r0, #0
	bl ov40_022430A0
	add r0, r4, #0
	bl ov40_022436D4
	add r0, r4, #0
	bl ov40_02243A28
	add r0, r4, #0
	bl ov40_02244060
	add r0, r4, #0
	bl ov40_02243C54
	add r0, r4, #0
	mov r1, #0
	bl ov40_022440A0
	add r0, r4, #0
	bl ov40_02243B48
	add r0, r4, #0
	bl ov40_02243D64
	add r0, r4, #0
	bl ov40_022441F8
	add r0, r4, #0
	mov r1, #1
	bl ov40_0224320C
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02243224

	thumb_func_start ov40_0224326C
ov40_0224326C: ; 0x0224326C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl TouchHitboxController_Destroy
	add r0, r4, #0
	bl ov40_02243B94
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov40_0224326C

	thumb_func_start ov40_02243284
ov40_02243284: ; 0x02243284
	push {r4, lr}
	mov r1, #0x7f
	add r4, r0, #0
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	cmp r2, #0
	bne _02243298
	add r0, r2, #1
	str r0, [r4, r1]
	b _022432A6
_02243298:
	bl ov40_0224395C
	mov r0, #0x8d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl TouchHitboxController_IsTriggered
_022432A6:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02243284

	thumb_func_start ov40_022432AC
ov40_022432AC: ; 0x022432AC
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x7f
	add r5, r0, #0
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	cmp r2, #0
	beq _022432C2
	cmp r2, #1
	bne _022432C0
	b _02243428
_022432C0:
	b _022434D0
_022432C2:
	mov r1, #0
	add r2, r1, #0
	bl ov40_02243E80
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r6, #0
	cmp r0, #0
	ble _02243364
	ldr r7, _0224352C ; =ov40_02245E74
	add r4, r5, #0
_022432DA:
	ldrb r0, [r4, #0x18]
	cmp r0, #0
	beq _02243356
	mov r1, #0x14
	mov r2, #0x16
	ldrsh r1, [r4, r1]
	ldrsh r2, [r4, r2]
	ldr r0, [r4, #0xc]
	bl ManagedSprite_OffsetPositionXY
	ldrb r0, [r4, #0x18]
	sub r0, r0, #1
	strb r0, [r4, #0x18]
	mov r0, #0x21
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	cmp r6, r0
	blt _02243324
	mov r0, #0x85
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r6, r0
	bge _02243324
	ldrb r0, [r4, #0x19]
	lsl r1, r0, #2
	ldr r1, [r7, r1]
	ldr r0, [r4, #0xc]
	add r2, r1, #0
	bl ManagedSprite_SetAffineScale
	ldrb r0, [r4, #0x19]
	mov r1, #2
	add r0, r0, #1
	strb r0, [r4, #0x19]
	ldr r0, [r4, #0xc]
	bl ManagedSprite_SetAffineOverwriteMode
_02243324:
	mov r0, #0x86
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r6, r0
	blt _02243356
	mov r0, #0x87
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r6, r0
	bge _02243356
	ldrb r0, [r4, #0x19]
	ldr r1, _02243530 ; =ov40_02245E58
	lsl r2, r0, #2
	ldr r1, [r1, r2]
	ldr r0, [r4, #0xc]
	add r2, r1, #0
	bl ManagedSprite_SetAffineScale
	ldrb r0, [r4, #0x19]
	mov r1, #2
	add r0, r0, #1
	strb r0, [r4, #0x19]
	ldr r0, [r4, #0xc]
	bl ManagedSprite_SetAffineOverwriteMode
_02243356:
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, r0
	blt _022432DA
_02243364:
	mov r7, #0x5a
	mov r6, #0
	add r4, r5, #0
	lsl r7, r7, #2
_0224336C:
	ldrb r0, [r4, r7]
	cmp r0, #0
	beq _02243394
	mov r1, #0x59
	ldr r2, _02243534 ; =0x00000166
	mov r0, #0x57
	lsl r1, r1, #2
	lsl r0, r0, #2
	ldrsh r1, [r4, r1]
	ldrsh r2, [r4, r2]
	ldr r0, [r4, r0]
	bl ManagedSprite_OffsetPositionXY
	mov r0, #0x5a
	lsl r0, r0, #2
	ldrb r0, [r4, r0]
	sub r1, r0, #1
	mov r0, #0x5a
	lsl r0, r0, #2
	strb r1, [r4, r0]
_02243394:
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, #2
	blt _0224336C
	ldrb r0, [r5, #0x18]
	cmp r0, #0
	bne _0224341C
	mov r0, #0x21
	lsl r0, r0, #4
	ldr r6, [r5, r0]
	add r0, r0, #4
	ldr r0, [r5, r0]
	cmp r6, r0
	bge _022433DA
	mov r0, #0x1c
	mul r0, r6
	mov r7, #0x85
	add r4, r5, r0
	lsl r7, r7, #2
_022433BA:
	ldr r0, [r4]
	ldr r1, [r4, #8]
	bl ov40_02244054
	add r1, r0, #0
	ldr r0, [r4, #0xc]
	bl ManagedSprite_SetAnim
	ldr r0, [r4, #0xc]
	bl ManagedSprite_TickFrame
	ldr r0, [r5, r7]
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, r0
	blt _022433BA
_022433DA:
	mov r0, #0x86
	lsl r0, r0, #2
	ldr r6, [r5, r0]
	add r0, r0, #4
	ldr r0, [r5, r0]
	cmp r6, r0
	bge _02243412
	mov r0, #0x1c
	mul r0, r6
	mov r7, #0x87
	add r4, r5, r0
	lsl r7, r7, #2
_022433F2:
	ldr r0, [r4]
	ldr r1, [r4, #8]
	bl ov40_02244054
	add r1, r0, #0
	ldr r0, [r4, #0xc]
	bl ManagedSprite_SetAnim
	ldr r0, [r4, #0xc]
	bl ManagedSprite_TickFrame
	ldr r0, [r5, r7]
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, r0
	blt _022433F2
_02243412:
	mov r0, #0x7f
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	add r1, r1, #1
	str r1, [r5, r0]
_0224341C:
	mov r0, #2
	lsl r0, r0, #8
	ldr r1, [r5, r0]
	add r1, r1, #1
	str r1, [r5, r0]
	b _02243526
_02243428:
	add r0, r1, #0
	add r0, #0x14
	add r1, #0x18
	ldr r6, [r5, r0]
	ldr r0, [r5, r1]
	cmp r6, r0
	bge _0224346E
	mov r0, #0x1c
	mul r0, r6
	ldr r7, _0224352C ; =ov40_02245E74
	add r4, r5, r0
_0224343E:
	ldrb r0, [r4, #0x19]
	cmp r0, #6
	bne _0224344E
	ldr r0, [r4, #0xc]
	mov r1, #1
	bl ManagedSprite_SetAffineOverwriteMode
	b _02243460
_0224344E:
	lsl r1, r0, #2
	ldr r1, [r7, r1]
	ldr r0, [r4, #0xc]
	add r2, r1, #0
	bl ManagedSprite_SetAffineScale
	ldrb r0, [r4, #0x19]
	add r0, r0, #1
	strb r0, [r4, #0x19]
_02243460:
	mov r0, #0x85
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, r0
	blt _0224343E
_0224346E:
	mov r0, #0x86
	lsl r0, r0, #2
	ldr r6, [r5, r0]
	add r0, r0, #4
	ldr r0, [r5, r0]
	cmp r6, r0
	bge _022434B4
	mov r0, #0x1c
	mul r0, r6
	ldr r7, _02243530 ; =ov40_02245E58
	add r4, r5, r0
_02243484:
	ldrb r0, [r4, #0x19]
	cmp r0, #6
	bne _02243494
	ldr r0, [r4, #0xc]
	mov r1, #1
	bl ManagedSprite_SetAffineOverwriteMode
	b _022434A6
_02243494:
	lsl r1, r0, #2
	ldr r1, [r7, r1]
	ldr r0, [r4, #0xc]
	add r2, r1, #0
	bl ManagedSprite_SetAffineScale
	ldrb r0, [r4, #0x19]
	add r0, r0, #1
	strb r0, [r4, #0x19]
_022434A6:
	mov r0, #0x87
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, r0
	blt _02243484
_022434B4:
	mov r1, #2
	lsl r1, r1, #8
	ldr r0, [r5, r1]
	add r0, r0, #1
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	cmp r0, #6
	bne _02243526
	sub r0, r1, #4
	ldr r0, [r5, r0]
	add r2, r0, #1
	sub r0, r1, #4
	str r2, [r5, r0]
	b _02243526
_022434D0:
	bl ov40_022441F8
	mov r1, #0xa9
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	cmp r0, #0
	bne _022434F2
	sub r1, r1, #4
	ldr r1, [r5, r1]
	add r0, r5, #0
	bl ov40_022439CC
	add r1, r0, #0
	add r0, r5, #0
	bl ov40_02243EB0
	b _02243504
_022434F2:
	sub r1, r1, #4
	ldr r1, [r5, r1]
	add r0, r5, #0
	bl ov40_022439F4
	add r1, r0, #0
	add r0, r5, #0
	bl ov40_02243EB0
_02243504:
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _02243518
	add r0, r5, #0
	mov r1, #0
	mov r2, #1
	bl ov40_02243E80
_02243518:
	add r0, r5, #0
	bl ov40_022439B8
	add r0, r5, #0
	mov r1, #1
	bl ov40_0224320C
_02243526:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224352C: .word ov40_02245E74
_02243530: .word ov40_02245E58
_02243534: .word 0x00000166
	thumb_func_end ov40_022432AC

	thumb_func_start ov40_02243538
ov40_02243538: ; 0x02243538
	push {r3, r4, r5, lr}
	mov r1, #0x7d
	add r4, r0, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	lsl r2, r1, #2
	ldr r1, _02243558 ; =ov40_02245C18
	ldr r1, [r1, r2]
	blx r1
	add r5, r0, #0
	bne _02243554
	add r0, r4, #0
	bl ov40_02243F88
_02243554:
	add r0, r5, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02243558: .word ov40_02245C18
	thumb_func_end ov40_02243538

	thumb_func_start ov40_0224355C
ov40_0224355C: ; 0x0224355C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r0, #0
	mov r0, #0x64
	mov r1, #0x6d
	bl String_New
	mov r1, #0xb2
	str r0, [sp, #4]
	mov r0, #1
	lsl r1, r1, #2
	str r0, [r7, r1]
	mov r6, #0
	add r0, r1, #4
	str r6, [r7, r0]
	add r0, r1, #0
	add r0, #8
	sub r1, #0xc4
	str r6, [r7, r0]
	ldr r0, [r7, r1]
	cmp r0, #0
	ble _022435FC
	mov r0, #0xb3
	lsl r0, r0, #2
	add r4, r7, #0
	add r5, r7, r0
_02243590:
	ldr r0, [r4]
	cmp r0, #0
	bne _022435A8
	mov r0, #1
	str r0, [r4]
	ldr r1, [r4, #8]
	bl ov40_02244054
	add r1, r0, #0
	ldr r0, [r4, #0xc]
	bl ManagedSprite_SetAnim
_022435A8:
	ldr r0, [r4]
	sub r0, r0, #1
	str r0, [sp, #8]
	cmp r6, #0
	beq _022435C2
	ldr r0, [r5]
	ldr r1, [r5, #4]
	mov r2, #0xa
	mov r3, #0
	bl _ll_mul
	str r0, [r5]
	str r1, [r5, #4]
_022435C2:
	ldr r2, [r5]
	ldr r1, [sp, #8]
	ldr r0, [r5, #4]
	add r2, r2, r1
	ldr r1, _02243610 ; =0x00000000
	str r2, [r5]
	adc r0, r1
	str r0, [r5, #4]
	mov r0, #1
	str r0, [sp]
	mov r2, #1
	ldr r0, [sp, #4]
	ldr r1, [sp, #8]
	add r3, r2, #0
	bl String16_FormatInteger
	mov r0, #0xb
	lsl r0, r0, #6
	ldr r0, [r7, r0]
	ldr r1, [sp, #4]
	bl String_Cat
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, r0
	blt _02243590
_022435FC:
	ldr r0, [sp, #4]
	bl String_Delete
	add r0, r7, #0
	mov r1, #3
	bl ov40_0224320C
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_02243610: .word 0x00000000
	thumb_func_end ov40_0224355C

	thumb_func_start ov40_02243614
ov40_02243614: ; 0x02243614
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	cmp r1, #0
	bne _02243650
	sub r1, r0, #4
	ldr r1, [r5, r1]
	sub r2, r1, #1
	add r1, r0, #0
	sub r1, #0x80
	str r2, [r5, r1]
	add r1, r0, #0
	sub r1, #0x80
	ldr r2, [r5, r1]
	mov r1, #0x1c
	mul r1, r2
	add r1, r5, r1
	ldr r3, [r1, #4]
	add r1, r0, #0
	mov r2, #1
	add r1, #0x94
	str r2, [r5, r1]
	add r1, r0, #0
	add r1, #0x98
	str r3, [r5, r1]
	add r0, #0x9c
	str r2, [r5, r0]
	pop {r3, r4, r5, r6, r7, pc}
_02243650:
	sub r0, #0x80
	ldr r6, [r5, r0]
	mov r0, #0x1c
	add r4, r6, #0
	mul r4, r0
	mov r0, #0
	str r0, [r5, r4]
	add r1, r5, r4
	ldr r0, [r5, r4]
	ldr r1, [r1, #8]
	bl ov40_02244054
	add r1, r0, #0
	add r0, r5, r4
	ldr r0, [r0, #0xc]
	bl ManagedSprite_SetAnim
	add r0, r5, r4
	ldr r7, [r0, #4]
	cmp r6, #0
	ble _022436C0
	sub r1, r6, #1
	mov r0, #0x1c
	add r4, r1, #0
	mul r4, r0
	add r1, r5, r4
	ldr r0, [r5, r4]
	ldr r1, [r1, #8]
	bl ov40_02244054
	add r1, r0, #0
	add r0, r5, r4
	ldr r0, [r0, #0xc]
	bl ManagedSprite_SetAnim
	add r0, r5, r4
	ldr r3, [r0, #4]
	cmp r7, r3
	beq _022436B0
	mov r1, #0xa7
	lsl r1, r1, #2
	mov r2, #1
	str r2, [r5, r1]
	add r0, r1, #4
	str r3, [r5, r0]
	add r1, #8
	str r2, [r5, r1]
	pop {r3, r4, r5, r6, r7, pc}
_022436B0:
	mov r0, #0xa7
	mov r1, #2
	lsl r0, r0, #2
	str r1, [r5, r0]
	sub r1, r6, #1
	add r0, r0, #4
	str r1, [r5, r0]
	pop {r3, r4, r5, r6, r7, pc}
_022436C0:
	mov r0, #0xb2
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r5, r0]
	add r0, r5, #0
	mov r1, #3
	bl ov40_0224320C
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov40_02243614

	thumb_func_start ov40_022436D4
ov40_022436D4: ; 0x022436D4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x64
	mov r1, #0x8e
	add r4, r0, #0
	lsl r1, r1, #2
	mov r0, #0
	add r1, r4, r1
	add r2, r4, #0
_022436E4:
	add r0, r0, #1
	str r1, [r2, #0x10]
	add r1, r1, #4
	add r2, #0x1c
	cmp r0, #0xc
	blt _022436E4
	ldr r5, _022437AC ; =ov40_02245C40
	add r3, sp, #4
	mov r2, #0x30
_022436F6:
	ldrh r1, [r5]
	add r5, r5, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _022436F6
	cmp r0, #0x18
	bge _02243764
	add r2, sp, #4
	lsl r1, r0, #3
	add r1, r2, r1
	lsl r2, r0, #2
	mov r7, #0x5b
	ldr r3, _022437B0 ; =0x0000023B
	add r2, r4, r2
	mvn r7, r7
_02243716:
	mov r5, #0x5d
	mov r6, #0x59
	mvn r5, r5
	mvn r6, r6
	ldrsh r5, [r1, r5]
	ldrsh r6, [r1, r6]
	add r0, r0, #1
	sub r6, r5, r6
	mov r5, #0x8e
	lsl r5, r5, #2
	strb r6, [r2, r5]
	mov r5, #0x5f
	mov r6, #0x5b
	mvn r5, r5
	mvn r6, r6
	ldrsh r5, [r1, r5]
	ldrsh r6, [r1, r6]
	sub r6, r5, r6
	ldr r5, _022437B4 ; =0x0000023A
	strb r6, [r2, r5]
	mov r5, #0x5d
	mov r6, #0x59
	mvn r5, r5
	mvn r6, r6
	ldrsh r5, [r1, r5]
	ldrsh r6, [r1, r6]
	add r6, r5, r6
	ldr r5, _022437B8 ; =0x00000239
	strb r6, [r2, r5]
	mov r5, #0x5f
	mvn r5, r5
	ldrsh r6, [r1, r5]
	ldrsh r5, [r1, r7]
	add r1, #8
	add r5, r6, r5
	strb r5, [r2, r3]
	add r2, r2, #4
	cmp r0, #0x18
	blt _02243716
_02243764:
	mov r0, #0x29
	lsl r0, r0, #4
	mov r3, #0x98
	strb r3, [r4, r0]
	mov r2, #0x20
	add r1, r0, #2
	strb r2, [r4, r1]
	mov r2, #0xb8
	add r1, r0, #1
	strb r2, [r4, r1]
	mov r1, #0x80
	add r5, r0, #3
	strb r1, [r4, r5]
	add r5, r0, #4
	strb r3, [r4, r5]
	add r3, r0, #6
	strb r1, [r4, r3]
	add r1, r0, #5
	strb r2, [r4, r1]
	add r1, r0, #7
	mov r2, #0xe0
	strb r2, [r4, r1]
	mov r1, #0x6d
	sub r0, #0x58
	str r1, [sp]
	ldr r2, _022437BC ; =ov40_022437C0
	add r0, r4, r0
	mov r1, #0x18
	add r3, r4, #0
	bl TouchHitboxController_Create
	mov r1, #0x8d
	lsl r1, r1, #2
	str r0, [r4, r1]
	add sp, #0x64
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_022437AC: .word ov40_02245C40
_022437B0: .word 0x0000023B
_022437B4: .word 0x0000023A
_022437B8: .word 0x00000239
_022437BC: .word ov40_022437C0
	thumb_func_end ov40_022436D4

	thumb_func_start ov40_022437C0
ov40_022437C0: ; 0x022437C0
	push {r3, r4, r5, r6, r7, lr}
	add r4, r2, #0
	mov r2, #0x7d
	lsl r2, r2, #2
	add r5, r0, #0
	ldr r0, [r4, r2]
	cmp r0, #1
	beq _022437D2
	b _02243950
_022437D2:
	add r0, r2, #0
	add r0, #0xa4
	ldr r0, [r4, r0]
	cmp r0, #1
	beq _022437E2
	mov r0, #1
	add r2, #0xa4
	str r0, [r4, r2]
_022437E2:
	cmp r1, #0
	beq _022437E8
	b _02243950
_022437E8:
	cmp r5, #0xb
	bhi _0224381C
	mov r0, #0x1c
	mul r0, r5
	add r2, r4, r0
	ldr r0, [r2, #8]
	cmp r0, #1
	bne _02243806
	mov r0, #0xa7
	mov r1, #2
	lsl r0, r0, #2
	str r1, [r4, r0]
	add r0, r0, #4
	str r5, [r4, r0]
	b _02243814
_02243806:
	mov r0, #0xa7
	mov r1, #1
	lsl r0, r0, #2
	str r1, [r4, r0]
	ldr r1, [r2, #4]
	add r0, r0, #4
	str r1, [r4, r0]
_02243814:
	ldr r0, _02243954 ; =0x0000057B
	bl PlaySE
	pop {r3, r4, r5, r6, r7, pc}
_0224381C:
	cmp r5, #0x16
	bne _02243830
	mov r0, #0x6e
	mov r1, #0
	lsl r0, r0, #2
	strh r1, [r4, r0]
	mov r1, #2
	add r0, r0, #2
	strh r1, [r4, r0]
	b _02243862
_02243830:
	cmp r5, #0x17
	bne _02243844
	mov r0, #0x6e
	mov r1, #3
	lsl r0, r0, #2
	strh r1, [r4, r0]
	mov r1, #2
	add r0, r0, #2
	strh r1, [r4, r0]
	b _02243862
_02243844:
	add r0, r5, #0
	sub r0, #0xc
	mov r1, #5
	bl _u32_div_f
	mov r0, #0x6e
	lsl r0, r0, #2
	strh r1, [r4, r0]
	add r0, r5, #0
	sub r0, #0xc
	mov r1, #5
	bl _u32_div_f
	ldr r1, _02243958 ; =0x000001BA
	strh r0, [r4, r1]
_02243862:
	cmp r5, #0xc
	blo _02243934
	cmp r5, #0x15
	bhi _02243934
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _02243950
	ldr r0, _02243954 ; =0x0000057B
	bl PlaySE
	mov r0, #0x62
	lsl r0, r0, #2
	ldr r7, [r4, r0]
	mov r0, #0x1c
	add r6, r7, #0
	mul r6, r0
	add r0, r5, #0
	sub r0, #0xb
	str r0, [r4, r6]
	add r1, r4, r6
	ldr r0, [r4, r6]
	ldr r1, [r1, #8]
	bl ov40_02244054
	add r1, r0, #0
	add r0, r4, r6
	ldr r0, [r0, #0xc]
	bl ManagedSprite_SetAnim
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov40_02243E80
	sub r5, #0xc
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_02243EEC
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov40_02243E80
	add r0, r4, #0
	mov r1, #2
	mov r2, #1
	bl ov40_02243E80
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #2
	bl ov40_02243F38
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
	add r0, r4, r6
	ldr r2, [r0, #4]
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r3, [r4, r0]
	add r1, r7, #1
	cmp r1, r3
	bne _02243904
	add r1, r0, #0
	mov r2, #1
	add r1, #0x98
	str r2, [r4, r1]
	add r1, r0, #0
	mov r2, #0
	add r1, #0x9c
	str r2, [r4, r1]
	add r0, #0xa0
	str r2, [r4, r0]
	pop {r3, r4, r5, r6, r7, pc}
_02243904:
	mov r3, #0x1c
	mul r3, r1
	add r3, r4, r3
	ldr r3, [r3, #4]
	cmp r2, r3
	beq _02243926
	add r1, r0, #0
	mov r2, #1
	add r1, #0x98
	str r2, [r4, r1]
	add r1, r0, #0
	add r1, #0x9c
	str r3, [r4, r1]
	mov r1, #0
	add r0, #0xa0
	str r1, [r4, r0]
	pop {r3, r4, r5, r6, r7, pc}
_02243926:
	add r2, r0, #0
	mov r3, #2
	add r2, #0x98
	str r3, [r4, r2]
	add r0, #0x9c
	str r1, [r4, r0]
	pop {r3, r4, r5, r6, r7, pc}
_02243934:
	cmp r5, #0x16
	ldr r0, _02243954 ; =0x0000057B
	bne _02243946
	bl PlaySE
	add r0, r4, #0
	bl ov40_02243614
	pop {r3, r4, r5, r6, r7, pc}
_02243946:
	bl PlaySE
	add r0, r4, #0
	bl ov40_0224355C
_02243950:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02243954: .word 0x0000057B
_02243958: .word 0x000001BA
	thumb_func_end ov40_022437C0

	thumb_func_start ov40_0224395C
ov40_0224395C: ; 0x0224395C
	push {r4, lr}
	mov r1, #0xa7
	add r4, r0, #0
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	cmp r2, #2
	bgt _0224397A
	cmp r2, #0
	blt _022439B4
	beq _022439B4
	cmp r2, #1
	beq _0224397E
	cmp r2, #2
	beq _022439A6
	pop {r4, pc}
_0224397A:
	cmp r2, #0xff
	pop {r4, pc}
_0224397E:
	add r1, r1, #4
	ldr r1, [r4, r1]
	bl ov40_0224301C
	add r0, r4, #0
	bl ov40_02244060
	add r0, r4, #0
	mov r1, #1
	bl ov40_022440A0
	add r0, r4, #0
	mov r1, #2
	bl ov40_0224320C
	mov r0, #0xa7
	mov r1, #0xff
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
_022439A6:
	add r1, r1, #4
	ldr r1, [r4, r1]
	bl ov40_02243EB0
	add r0, r4, #0
	bl ov40_022439B8
_022439B4:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_0224395C

	thumb_func_start ov40_022439B8
ov40_022439B8: ; 0x022439B8
	mov r2, #0xa7
	lsl r2, r2, #2
	mov r3, #0
	str r3, [r0, r2]
	add r1, r2, #4
	str r3, [r0, r1]
	add r2, #8
	str r3, [r0, r2]
	bx lr
	.balign 4, 0
	thumb_func_end ov40_022439B8

	thumb_func_start ov40_022439CC
ov40_022439CC: ; 0x022439CC
	push {r3, r4}
	mov r2, #0x81
	lsl r2, r2, #2
	ldr r4, [r0, r2]
	mov r3, #0
	cmp r4, #0
	ble _022439EE
_022439DA:
	ldr r2, [r0, #4]
	cmp r1, r2
	bne _022439E6
	add r0, r3, #0
	pop {r3, r4}
	bx lr
_022439E6:
	add r3, r3, #1
	add r0, #0x1c
	cmp r3, r4
	blt _022439DA
_022439EE:
	mov r0, #0
	pop {r3, r4}
	bx lr
	thumb_func_end ov40_022439CC

	thumb_func_start ov40_022439F4
ov40_022439F4: ; 0x022439F4
	push {r3, r4, r5, r6}
	mov r2, #0x81
	lsl r2, r2, #2
	ldr r6, [r0, r2]
	mov r5, #0
	add r4, r5, #0
	cmp r6, #0
	ble _02243A22
	mov r2, #1
_02243A06:
	ldr r3, [r0, #4]
	cmp r1, r3
	bne _02243A10
	add r5, r2, #0
	b _02243A1A
_02243A10:
	cmp r5, #1
	bne _02243A1A
	sub r0, r4, #1
	pop {r3, r4, r5, r6}
	bx lr
_02243A1A:
	add r4, r4, #1
	add r0, #0x1c
	cmp r4, r6
	blt _02243A06
_02243A22:
	sub r0, r6, #1
	pop {r3, r4, r5, r6}
	bx lr
	thumb_func_end ov40_022439F4

	thumb_func_start ov40_02243A28
ov40_02243A28: ; 0x02243A28
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	mov r2, #0x89
	lsl r2, r2, #2
	add r1, r2, #4
	ldr r5, [r0, r1]
	add r1, r2, #0
	add r1, #0xc
	ldr r1, [r0, r1]
	ldr r6, [r0, r2]
	str r1, [sp, #0x18]
	add r1, r2, #0
	add r1, #8
	ldr r7, [r0, r1]
	sub r1, r2, #4
	ldr r4, [r0, r1]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #0x36
	add r2, r7, #0
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	add r0, r4, #0
	mov r1, #0x2b
	add r2, r7, #0
	mov r3, #3
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	str r4, [sp]
	mov r0, #0x2c
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r0, #0xfa
	lsl r0, r0, #2
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x18]
	mov r1, #2
	add r2, r6, #0
	add r3, r5, #0
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0xfa
	lsl r0, r0, #2
	str r0, [sp, #8]
	add r0, r6, #0
	add r1, r5, #0
	add r2, r4, #0
	mov r3, #0x28
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #0xfa
	lsl r0, r0, #2
	str r0, [sp, #4]
	add r0, r6, #0
	add r1, r5, #0
	add r2, r4, #0
	mov r3, #0x29
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #0xfa
	lsl r0, r0, #2
	str r0, [sp, #4]
	add r0, r6, #0
	add r1, r5, #0
	add r2, r4, #0
	mov r3, #0x2a
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	str r4, [sp]
	mov r0, #0x58
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, _02243B44 ; =0x000003E9
	mov r1, #2
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x18]
	add r2, r6, #0
	add r3, r5, #0
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _02243B44 ; =0x000003E9
	add r1, r5, #0
	str r0, [sp, #8]
	add r0, r6, #0
	add r2, r4, #0
	mov r3, #0x57
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _02243B44 ; =0x000003E9
	add r1, r5, #0
	str r0, [sp, #4]
	add r0, r6, #0
	add r2, r4, #0
	mov r3, #0x55
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	ldr r0, _02243B44 ; =0x000003E9
	add r1, r5, #0
	str r0, [sp, #4]
	add r0, r6, #0
	add r2, r4, #0
	mov r3, #0x56
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02243B44: .word 0x000003E9
	thumb_func_end ov40_02243A28

	thumb_func_start ov40_02243B48
ov40_02243B48: ; 0x02243B48
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r6, #0
	cmp r0, #0
	ble _02243B74
	mov r7, #0x81
	add r4, r5, #0
	lsl r7, r7, #2
_02243B5E:
	ldr r0, [r4, #0xc]
	cmp r0, #0
	beq _02243B6A
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
_02243B6A:
	ldr r0, [r5, r7]
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, r0
	blt _02243B5E
_02243B74:
	mov r6, #0x57
	mov r4, #0
	mov r7, #1
	lsl r6, r6, #2
_02243B7C:
	ldr r0, [r5, r6]
	cmp r0, #0
	beq _02243B88
	add r1, r7, #0
	bl ManagedSprite_SetDrawFlag
_02243B88:
	add r4, r4, #1
	add r5, #0x1c
	cmp r4, #2
	blt _02243B7C
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov40_02243B48

	thumb_func_start ov40_02243B94
ov40_02243B94: ; 0x02243B94
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r4, #0
	cmp r0, #0
	ble _02243BBA
	mov r7, #0x81
	add r5, r6, #0
	lsl r7, r7, #2
_02243BAA:
	ldr r0, [r5, #0xc]
	bl Sprite_DeleteAndFreeResources
	ldr r0, [r6, r7]
	add r4, r4, #1
	add r5, #0x1c
	cmp r4, r0
	blt _02243BAA
_02243BBA:
	mov r7, #0x57
	mov r5, #0
	add r4, r6, #0
	lsl r7, r7, #2
_02243BC2:
	ldr r0, [r4, r7]
	bl Sprite_DeleteAndFreeResources
	add r5, r5, #1
	add r4, #0x1c
	cmp r5, #2
	blt _02243BC2
	mov r7, #0x65
	mov r5, #0
	add r4, r6, #0
	lsl r7, r7, #2
_02243BD8:
	ldr r0, [r4, r7]
	bl Sprite_DeleteAndFreeResources
	add r5, r5, #1
	add r4, #0x1c
	cmp r5, #3
	blt _02243BD8
	mov r0, #0x8a
	lsl r0, r0, #2
	mov r1, #0xfa
	ldr r0, [r6, r0]
	lsl r1, r1, #2
	bl SpriteManager_UnloadCharObjById
	mov r0, #0x8a
	lsl r0, r0, #2
	mov r1, #0xfa
	ldr r0, [r6, r0]
	lsl r1, r1, #2
	bl SpriteManager_UnloadPlttObjById
	mov r0, #0x8a
	lsl r0, r0, #2
	mov r1, #0xfa
	ldr r0, [r6, r0]
	lsl r1, r1, #2
	bl SpriteManager_UnloadCellObjById
	mov r0, #0x8a
	lsl r0, r0, #2
	mov r1, #0xfa
	ldr r0, [r6, r0]
	lsl r1, r1, #2
	bl SpriteManager_UnloadAnimObjById
	mov r0, #0x8a
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	ldr r1, _02243C50 ; =0x000003E9
	bl SpriteManager_UnloadCharObjById
	mov r0, #0x8a
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	ldr r1, _02243C50 ; =0x000003E9
	bl SpriteManager_UnloadPlttObjById
	mov r0, #0x8a
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	ldr r1, _02243C50 ; =0x000003E9
	bl SpriteManager_UnloadCellObjById
	mov r0, #0x8a
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	ldr r1, _02243C50 ; =0x000003E9
	bl SpriteManager_UnloadAnimObjById
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02243C50: .word 0x000003E9
	thumb_func_end ov40_02243B94

	thumb_func_start ov40_02243C54
ov40_02243C54: ; 0x02243C54
	push {r4, r5, r6, r7, lr}
	sub sp, #0x44
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #0xc]
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r1, [sp]
	add r2, r0, #4
	ldr r1, [r1, r0]
	ldr r7, [sp, #0xc]
	str r1, [sp, #8]
	ldr r1, [sp]
	ldr r1, [r1, r2]
	add r2, sp, #0x10
	str r1, [sp, #4]
	add r1, r0, #0
	sub r1, #0xf4
	strh r1, [r2]
	mov r1, #0xe0
	strh r1, [r2, #2]
	ldr r1, [sp, #0xc]
	sub r0, #0x20
	strh r1, [r2, #4]
	strh r1, [r2, #6]
	mov r1, #0xa
	str r1, [sp, #0x18]
	ldr r1, [sp, #0xc]
	mov r2, #1
	str r1, [sp, #0x3c]
	str r1, [sp, #0x40]
	str r1, [sp, #0x1c]
	mov r1, #0xfa
	lsl r1, r1, #2
	str r1, [sp, #0x24]
	str r1, [sp, #0x28]
	str r1, [sp, #0x2c]
	str r1, [sp, #0x30]
	sub r1, r2, #2
	str r1, [sp, #0x34]
	str r1, [sp, #0x38]
	ldr r1, [sp]
	str r2, [sp, #0x20]
	ldr r0, [r1, r0]
	add r0, r0, #2
	cmp r0, #0
	ble _02243D60
	add r4, r1, #0
	mov r6, #0x4c
	add r5, r1, #0
_02243CB8:
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, [sp, #0xc]
	add r0, r0, r1
	add r0, r0, #1
	cmp r7, r0
	add r2, sp, #0x10
	bne _02243D12
	ldr r0, [sp, #8]
	ldr r1, [sp, #4]
	bl SpriteSystem_NewSprite
	mov r1, #0x57
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #0
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	mov r0, #0x57
	lsl r0, r0, #2
	lsl r1, r6, #0x10
	ldr r0, [r4, r0]
	asr r1, r1, #0x10
	mov r2, #0x18
	bl ManagedSprite_SetPositionXY
	mov r0, #0x57
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0x16
	bl ManagedSprite_SetAnim
	mov r0, #0x57
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ManagedSprite_TickFrame
	ldr r0, [sp, #0xc]
	add r4, #0x1c
	add r0, r0, #1
	str r0, [sp, #0xc]
	b _02243D4E
_02243D12:
	ldr r0, [sp, #8]
	ldr r1, [sp, #4]
	bl SpriteSystem_NewSprite
	str r0, [r5, #0xc]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	lsl r1, r6, #0x10
	ldr r0, [r5, #0xc]
	asr r1, r1, #0x10
	mov r2, #0x18
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5]
	ldr r1, [r5, #8]
	bl ov40_02244054
	add r1, r0, #0
	ldr r0, [r5, #0xc]
	bl ManagedSprite_SetAnim
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl ManagedSprite_SetAffineOverwriteMode
	ldr r0, [r5, #0xc]
	bl ManagedSprite_TickFrame
	add r5, #0x1c
_02243D4E:
	mov r0, #0x81
	ldr r1, [sp]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r7, r7, #1
	add r0, r0, #2
	add r6, #8
	cmp r7, r0
	blt _02243CB8
_02243D60:
	add sp, #0x44
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov40_02243C54

	thumb_func_start ov40_02243D64
ov40_02243D64: ; 0x02243D64
	push {r3, r4, r5, r6, lr}
	sub sp, #0x34
	add r5, r0, #0
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r6, [r5, r0]
	add r0, r0, #4
	ldr r4, [r5, r0]
	mov r2, #0
	add r0, sp, #0
	strh r2, [r0]
	strh r2, [r0, #2]
	strh r2, [r0, #4]
	strh r2, [r0, #6]
	ldr r0, _02243E7C ; =0x000003E9
	mov r1, #1
	str r0, [sp, #0x14]
	str r0, [sp, #0x18]
	str r0, [sp, #0x1c]
	str r0, [sp, #0x20]
	sub r0, r1, #2
	str r1, [sp, #0x10]
	str r2, [sp, #8]
	str r2, [sp, #0x2c]
	str r2, [sp, #0x30]
	str r2, [sp, #0xc]
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
	add r0, r6, #0
	add r1, r4, #0
	add r2, sp, #0
	bl SpriteSystem_NewSprite
	mov r1, #0x65
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r6, #0
	add r1, r4, #0
	add r2, sp, #0
	bl SpriteSystem_NewSprite
	mov r1, #0x1b
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r6, #0
	add r1, r4, #0
	add r2, sp, #0
	bl SpriteSystem_NewSprite
	mov r1, #0x73
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r5, #0
	mov r1, #0
	bl ov40_02243EB0
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl ManagedSprite_TickFrame
	mov r2, #0x6e
	lsl r2, r2, #2
	mov r1, #0
	strh r1, [r5, r2]
	add r0, r2, #2
	strh r1, [r5, r0]
	mov r0, #1
	sub r2, #0x14
	str r0, [r5, r2]
	add r0, r5, #0
	bl ov40_02243EEC
	mov r1, #0x1b
	lsl r1, r1, #4
	ldr r0, [r5, r1]
	sub r1, #0xc
	ldr r1, [r5, r1]
	bl ManagedSprite_SetAnim
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ManagedSprite_TickFrame
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetOamMode
	mov r2, #0x75
	lsl r2, r2, #2
	mov r1, #0
	strh r1, [r5, r2]
	add r0, r2, #2
	strh r1, [r5, r0]
	mov r0, #1
	sub r2, #0x14
	str r0, [r5, r2]
	add r0, r5, #0
	bl ov40_02243EEC
	mov r1, #0x73
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	sub r1, #0xc
	ldr r1, [r5, r1]
	bl ManagedSprite_SetAnim
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl ManagedSprite_TickFrame
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetOamMode
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov40_02243E80
	add r0, r5, #0
	mov r1, #2
	mov r2, #0
	bl ov40_02243E80
	add sp, #0x34
	pop {r3, r4, r5, r6, pc}
	nop
_02243E7C: .word 0x000003E9
	thumb_func_end ov40_02243D64

	thumb_func_start ov40_02243E80
ov40_02243E80: ; 0x02243E80
	push {r3, lr}
	cmp r2, #1
	bne _02243E9A
	mov r2, #0x1c
	mul r2, r1
	add r1, r0, r2
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
_02243E9A:
	mov r2, #0x1c
	mul r2, r1
	add r1, r0, r2
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov40_02243E80

	thumb_func_start ov40_02243EB0
ov40_02243EB0: ; 0x02243EB0
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r0, #0x1c
	mul r0, r1
	add r0, r4, r0
	mov r2, #0x62
	ldr r0, [r0, #0xc]
	lsl r2, r2, #2
	str r1, [r4, r2]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0x65
	lsl r0, r0, #2
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	mov r1, #2
	ldrsh r1, [r3, r1]
	add r2, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r4, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov40_02243EB0

	thumb_func_start ov40_02243EEC
ov40_02243EEC: ; 0x02243EEC
	push {r4, lr}
	add r1, #0xc
	mov r2, #0x1b
	add r3, r0, #0
	lsl r2, r2, #4
	lsl r1, r1, #2
	ldr r0, [r3, r2]
	add r3, r3, r1
	add r1, r2, #0
	add r1, #0x8a
	ldrb r4, [r3, r1]
	add r1, r2, #0
	add r1, #0x8b
	ldrb r1, [r3, r1]
	add r4, r4, r1
	lsr r1, r4, #0x1f
	add r1, r4, r1
	add r4, r2, #0
	add r4, #0x88
	add r2, #0x89
	lsl r1, r1, #0xf
	asr r1, r1, #0x10
	lsl r1, r1, #0x10
	ldrb r4, [r3, r4]
	ldrb r2, [r3, r2]
	asr r1, r1, #0x10
	add r3, r4, r2
	lsr r2, r3, #0x1f
	add r2, r3, r2
	lsl r2, r2, #0xf
	asr r2, r2, #0x10
	sub r2, #8
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02243EEC

	thumb_func_start ov40_02243F38
ov40_02243F38: ; 0x02243F38
	push {r4, lr}
	add r3, r0, #0
	mov r0, #0x1c
	mul r0, r2
	add r1, #0xc
	mov r2, #0x65
	lsl r1, r1, #2
	add r0, r3, r0
	lsl r2, r2, #2
	add r3, r3, r1
	add r1, r2, #0
	add r1, #0xa6
	ldrb r4, [r3, r1]
	add r1, r2, #0
	add r1, #0xa7
	ldrb r1, [r3, r1]
	ldr r0, [r0, r2]
	add r4, r4, r1
	lsr r1, r4, #0x1f
	add r1, r4, r1
	add r4, r2, #0
	add r4, #0xa4
	add r2, #0xa5
	lsl r1, r1, #0xf
	asr r1, r1, #0x10
	lsl r1, r1, #0x10
	ldrb r4, [r3, r4]
	ldrb r2, [r3, r2]
	asr r1, r1, #0x10
	add r3, r4, r2
	lsr r2, r3, #0x1f
	add r2, r3, r2
	lsl r2, r2, #0xf
	asr r2, r2, #0x10
	sub r2, #8
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r4, pc}
	thumb_func_end ov40_02243F38

	thumb_func_start ov40_02243F88
ov40_02243F88: ; 0x02243F88
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl ManagedSprite_TickFrame
	mov r0, #0x1b
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ManagedSprite_TickFrame
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl ManagedSprite_TickFrame
	add r4, r5, #0
	mov r7, #0x65
	mov r6, #1
	add r4, #0x1c
	lsl r7, r7, #2
_02243FB4:
	ldr r0, [r4, r7]
	bl ManagedSprite_GetActiveAnim
	cmp r0, #3
	bne _02244008
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _0224404A
	mov r0, #0x65
	mov r1, #0x62
	lsl r0, r0, #2
	lsl r1, r1, #2
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	bl ManagedSprite_SetAnim
	mov r0, #0xa6
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, #1
	bne _02243FF2
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov40_02243E80
	b _02243FFC
_02243FF2:
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_02243E80
_02243FFC:
	add r0, r5, #0
	mov r1, #2
	mov r2, #0
	bl ov40_02243E80
	b _0224404A
_02244008:
	mov r1, #0x62
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	cmp r0, r1
	beq _0224401C
	mov r0, #0x65
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAnim
_0224401C:
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl ManagedSprite_GetActiveAnim
	cmp r0, #3
	beq _0224404A
	mov r0, #0xa6
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, #1
	bne _02244040
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov40_02243E80
	b _0224404A
_02244040:
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_02243E80
_0224404A:
	add r6, r6, #1
	add r4, #0x1c
	cmp r6, #3
	blt _02243FB4
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov40_02243F88

	thumb_func_start ov40_02244054
ov40_02244054: ; 0x02244054
	mov r2, #0
	cmp r1, #0
	bne _0224405C
	mov r2, #0xb
_0224405C:
	add r0, r2, r0
	bx lr
	thumb_func_end ov40_02244054

	thumb_func_start ov40_02244060
ov40_02244060: ; 0x02244060
	push {r4, r5, r6, r7}
	mov r1, #0x81
	lsl r1, r1, #2
	ldr r1, [r0, r1]
	mov r3, #0
	cmp r1, #0
	ble _0224409A
	mov r6, #0x85
	lsl r6, r6, #2
	add r4, r0, #0
	add r1, r3, #0
	mov r2, #1
	sub r7, r6, #4
_0224407A:
	ldr r5, [r0, r7]
	cmp r3, r5
	blt _0224408A
	ldr r5, [r0, r6]
	cmp r3, r5
	bge _0224408A
	str r2, [r4, #8]
	b _0224408C
_0224408A:
	str r1, [r4, #8]
_0224408C:
	mov r5, #0x81
	lsl r5, r5, #2
	ldr r5, [r0, r5]
	add r3, r3, #1
	add r4, #0x1c
	cmp r3, r5
	blt _0224407A
_0224409A:
	pop {r4, r5, r6, r7}
	bx lr
	.balign 4, 0
	thumb_func_end ov40_02244060

	thumb_func_start ov40_022440A0
ov40_022440A0: ; 0x022440A0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r1, [sp, #4]
	mov r1, #0x82
	lsl r1, r1, #2
	str r0, [sp]
	ldr r0, [r0, r1]
	mov r4, #0
	lsl r2, r0, #1
	ldr r0, [sp]
	str r4, [sp, #8]
	add r2, r0, r2
	add r0, r1, #0
	sub r0, #0x2c
	ldrsh r5, [r2, r0]
	ldr r0, [sp]
	sub r1, r1, #4
	ldr r0, [r0, r1]
	cmp r0, #0
	bgt _022440CA
	b _022441F2
_022440CA:
	ldr r7, [sp]
	add r6, r7, #0
_022440CE:
	mov r0, #0x21
	ldr r1, [sp]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	cmp r4, r0
	blt _022440FA
	add r2, r1, #0
	mov r1, #0x85
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	cmp r4, r1
	bge _022440FA
	cmp r4, r0
	bne _022440F2
	add r5, #0x14
	lsl r0, r5, #0x10
	asr r5, r0, #0x10
	b _0224410C
_022440F2:
	add r5, #0x20
	lsl r0, r5, #0x10
	asr r5, r0, #0x10
	b _0224410C
_022440FA:
	cmp r4, #0
	bne _02244106
	add r5, #0x14
	lsl r0, r5, #0x10
	asr r5, r0, #0x10
	b _0224410C
_02244106:
	add r5, #8
	lsl r0, r5, #0x10
	asr r5, r0, #0x10
_0224410C:
	add r1, sp, #0xc
	ldr r0, [r7, #0xc]
	add r1, #2
	add r2, sp, #0xc
	bl ManagedSprite_GetPositionXY
	ldr r0, [sp, #4]
	cmp r0, #0
	bne _0224412E
	add r3, sp, #0xc
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r7, #0xc]
	add r1, r5, #0
	bl ManagedSprite_SetPositionXY
	b _0224414A
_0224412E:
	add r1, sp, #0xc
	mov r0, #2
	ldrsh r0, [r1, r0]
	sub r1, r5, r0
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	strh r0, [r7, #0x14]
	mov r0, #0
	strh r0, [r7, #0x16]
	mov r0, #2
	strb r0, [r7, #0x18]
	mov r0, #0
	strb r0, [r7, #0x19]
_0224414A:
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	cmp r4, r0
	bne _022441E0
	ldr r0, [sp, #8]
	cmp r0, #2
	beq _022441E0
	mov r0, #0x57
	lsl r0, r0, #2
	add r1, sp, #0xc
	ldr r0, [r6, r0]
	add r1, #2
	add r2, sp, #0xc
	bl ManagedSprite_GetPositionXY
	ldr r1, [sp]
	mov r0, #0x85
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r2, r1, #0
	mov r1, #0x21
	lsl r1, r1, #4
	ldr r1, [r2, r1]
	cmp r1, r0
	bne _02244186
	add r5, #8
	lsl r0, r5, #0x10
	asr r5, r0, #0x10
	b _0224419C
_02244186:
	cmp r4, r1
	ble _02244196
	cmp r4, r0
	bge _02244196
	add r5, #0x14
	lsl r0, r5, #0x10
	asr r5, r0, #0x10
	b _0224419C
_02244196:
	add r5, #8
	lsl r0, r5, #0x10
	asr r5, r0, #0x10
_0224419C:
	ldr r0, [sp, #4]
	cmp r0, #0
	bne _022441B6
	mov r0, #0x57
	lsl r0, r0, #2
	add r3, sp, #0xc
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r6, r0]
	add r1, r5, #0
	bl ManagedSprite_SetPositionXY
	b _022441D8
_022441B6:
	add r1, sp, #0xc
	mov r0, #2
	ldrsh r0, [r1, r0]
	sub r1, r5, r0
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r1, r0, #1
	mov r0, #0x59
	lsl r0, r0, #2
	strh r1, [r6, r0]
	mov r1, #0
	add r0, r0, #2
	strh r1, [r6, r0]
	mov r0, #0x5a
	mov r1, #2
	lsl r0, r0, #2
	strb r1, [r6, r0]
_022441D8:
	ldr r0, [sp, #8]
	add r6, #0x1c
	add r0, r0, #1
	str r0, [sp, #8]
_022441E0:
	mov r0, #0x81
	ldr r1, [sp]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r4, r4, #1
	add r7, #0x1c
	cmp r4, r0
	bge _022441F2
	b _022440CE
_022441F2:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov40_022440A0

	thumb_func_start ov40_022441F8
ov40_022441F8: ; 0x022441F8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r0, #0
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r4, #0
	cmp r0, #0
	ble _02244288
	add r5, r6, #0
_0224420C:
	mov r0, #0x21
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	cmp r4, r0
	blt _02244228
	mov r0, #0x85
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	cmp r4, r0
	bge _02244228
	mov r0, #0x10
	str r0, [sp]
	add r7, r0, #0
	b _0224422E
_02244228:
	mov r0, #4
	str r0, [sp]
	mov r7, #8
_0224422E:
	add r2, sp, #4
	ldr r0, [r5, #0xc]
	add r1, sp, #4
	add r2, #2
	bl ManagedSprite_GetPositionXY
	add r1, sp, #4
	mov r0, #2
	ldrsh r0, [r1, r0]
	sub r1, r0, r7
	ldr r0, [r5, #0x10]
	strb r1, [r0]
	add r1, sp, #4
	mov r0, #0
	ldrsh r1, [r1, r0]
	ldr r0, [sp]
	sub r1, r1, r0
	ldr r0, [r5, #0x10]
	strb r1, [r0, #2]
	add r1, sp, #4
	mov r0, #2
	ldrsh r0, [r1, r0]
	add r1, r0, r7
	ldr r0, [r5, #0x10]
	strb r1, [r0, #1]
	add r1, sp, #4
	mov r0, #0
	ldrsh r1, [r1, r0]
	ldr r0, [sp]
	add r1, r1, r0
	ldr r0, [r5, #0x10]
	cmp r4, #0
	strb r1, [r0, #3]
	bne _0224427A
	ldr r1, [r5, #0x10]
	ldrb r0, [r1, #2]
	sub r0, r0, #4
	strb r0, [r1, #2]
_0224427A:
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	add r4, r4, #1
	add r5, #0x1c
	cmp r4, r0
	blt _0224420C
_02244288:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov40_022441F8

	thumb_func_start ov40_0224428C
ov40_0224428C: ; 0x0224428C
	push {r4, r5, lr}
	sub sp, #0x14
	ldr r5, _022442C8 ; =0x000008A4
	add r2, r1, #0
	add r4, r0, #0
	mov r1, #2
	bl ov40_0222C6C8
	add r0, r4, r5
	bl InitWindow
	mov r0, #0x13
	str r0, [sp]
	mov r0, #0x1e
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x4b
	lsl r0, r0, #2
	str r0, [sp, #0x10]
	ldr r0, [r4, #0x24]
	add r1, r4, r5
	mov r2, #2
	mov r3, #1
	bl AddWindowParameterized
	add sp, #0x14
	pop {r4, r5, pc}
	.balign 4, 0
_022442C8: .word 0x000008A4
	thumb_func_end ov40_0224428C

	thumb_func_start ov40_022442CC
ov40_022442CC: ; 0x022442CC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _022442EC ; =0x000008A4
	add r0, r4, r0
	bl ClearWindowTilemapAndCopyToVram
	ldr r0, _022442EC ; =0x000008A4
	add r0, r4, r0
	bl RemoveWindow
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	pop {r4, pc}
	nop
_022442EC: .word 0x000008A4
	thumb_func_end ov40_022442CC

	thumb_func_start ov40_022442F0
ov40_022442F0: ; 0x022442F0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	ldr r3, _022443A8 ; =0x0000011A
	add r5, r0, #0
	add r0, r1, #0
	str r1, [sp, #0x10]
	cmp r0, r3
	bne _0224436A
	lsl r0, r2, #2
	add r1, r5, r0
	ldr r0, _022443AC ; =0x000008A4
	sub r0, #0x18
	ldr r7, [r1, r0]
	mov r0, #0x6d
	bl ov40_0222DAB0
	add r6, r0, #0
	mov r0, #0xff
	mov r1, #0x6d
	bl String_New
	add r4, r0, #0
	add r0, r7, #0
	mov r1, #0x6d
	bl sub_020315B8
	str r0, [sp, #0x14]
	ldr r1, [sp, #0x14]
	add r0, r5, #0
	bl ov40_02230DCC
	ldr r0, [r5, #0x48]
	ldr r1, [sp, #0x10]
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	mov r1, #0
	str r0, [sp, #4]
	ldr r2, [sp, #0x14]
	add r0, r6, #0
	add r3, r1, #0
	bl BufferString
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	add r0, r6, #0
	bl MessageFormat_Delete
	b _02244372
_0224436A:
	ldr r0, [r5, #0x48]
	bl NewString_ReadMsgData
	add r4, r0, #0
_02244372:
	ldr r0, _022443AC ; =0x000008A4
	mov r1, #0xcc
	add r0, r5, r0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022443B0 ; =0x000F0D0C
	add r2, r4, #0
	str r0, [sp, #8]
	ldr r0, _022443AC ; =0x000008A4
	add r3, r1, #0
	add r0, r5, r0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, _022443AC ; =0x000008A4
	add r0, r5, r0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_022443A8: .word 0x0000011A
_022443AC: .word 0x000008A4
_022443B0: .word 0x000F0D0C
	thumb_func_end ov40_022442F0

	thumb_func_start ov40_022443B4
ov40_022443B4: ; 0x022443B4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r0, #0x86
	lsl r0, r0, #4
	ldr r4, [r5, r0]
	add r6, r4, #0
	add r6, #0x10
	add r0, r6, #0
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r6, #0
	mov r3, #4
	bl AddWindowParameterized
	add r0, r6, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x82
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r0, r6, #0
	add r1, r7, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02244490 ; =0x000F0D00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r6, #0
	bl ScheduleWindowCopyToVram
	add r4, #0x20
	add r0, r4, #0
	bl InitWindow
	mov r2, #6
	str r2, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	mov r0, #0x15
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x24]
	add r1, r4, #0
	mov r3, #0x12
	bl AddWindowParameterized
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x48]
	mov r1, #0x83
	bl NewString_ReadMsgData
	add r5, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	bl ov40_022306C0
	mov r1, #0
	add r3, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02244490 ; =0x000F0D00
	add r2, r5, #0
	str r0, [sp, #8]
	add r0, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_02244490: .word 0x000F0D00
	thumb_func_end ov40_022443B4

	thumb_func_start ov40_02244494
ov40_02244494: ; 0x02244494
	push {r4, lr}
	mov r1, #0x86
	lsl r1, r1, #4
	ldr r4, [r0, r1]
	add r0, r4, #0
	add r0, #0x10
	bl ClearWindowTilemapAndCopyToVram
	add r0, r4, #0
	add r0, #0x10
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0x20
	bl ClearWindowTilemapAndCopyToVram
	add r4, #0x20
	add r0, r4, #0
	bl RemoveWindow
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov40_02244494

	thumb_func_start ov40_022444C0
ov40_022444C0: ; 0x022444C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x6d
	mov r1, #0x30
	bl Heap_Alloc
	mov r1, #0
	mov r2, #0x30
	add r4, r0, #0
	bl memset
	mov r0, #0x86
	lsl r0, r0, #4
	str r4, [r5, r0]
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	add r1, r4, #4
	mov r2, #0
	bl ov40_0222D9E8
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222BF80
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_022444C0

	thumb_func_start ov40_02244514
ov40_02244514: ; 0x02244514
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _0224452C
	cmp r1, #1
	beq _0224458A
	b _02244618
_0224452C:
	add r0, r4, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	cmp r0, #0
	beq _02244540
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02244540:
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _02244626
_0224458A:
	mov r0, #0
	add r1, r0, #0
	bl SetBgPriority
	mov r0, #1
	mov r1, #3
	bl SetBgPriority
	mov r0, #2
	mov r1, #0
	bl SetBgPriority
	mov r0, #3
	mov r1, #2
	bl SetBgPriority
	mov r0, #4
	mov r1, #0
	bl SetBgPriority
	mov r0, #5
	mov r1, #3
	bl SetBgPriority
	mov r0, #6
	mov r1, #1
	bl SetBgPriority
	mov r0, #7
	mov r1, #2
	bl SetBgPriority
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #3
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x14]
	ldr r2, [r5, #0x24]
	mov r1, #0x3e
	mov r3, #7
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	add r0, r5, #0
	mov r1, #1
	bl ov40_02230964
	add r0, r5, #0
	bl ov40_0222D874
	add r0, r5, #0
	mov r1, #0
	bl ov40_02230964
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _02244626
_02244618:
	mov r1, #0
	bl ov40_0222FB90
	add r0, r5, #0
	mov r1, #2
	bl ov40_0222BF80
_02244626:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov40_02244514

	thumb_func_start ov40_0224462C
ov40_0224462C: ; 0x0224462C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r1, #0x86
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r5, [r4, r1]
	ldr r1, [r4, #8]
	cmp r1, #6
	bls _02244640
	b _02244808
_02244640:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224464C: ; jump table
	.short _0224465A - _0224464C - 2 ; case 0
	.short _022446A6 - _0224464C - 2 ; case 1
	.short _022446FC - _0224464C - 2 ; case 2
	.short _0224473E - _0224464C - 2 ; case 3
	.short _02244782 - _0224464C - 2 ; case 4
	.short _0224478E - _0224464C - 2 ; case 5
	.short _022447D8 - _0224464C - 2 ; case 6
_0224465A:
	bl ov40_022443B4
	add r0, r4, #0
	mov r1, #0
	bl ov40_0224428C
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6d
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0x24]
	mov r1, #0x54
	mov r3, #7
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224481E
_022446A6:
	add r0, r5, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #0
	mov r3, #2
	bl ov40_0222DA00
	cmp r0, #0
	beq _022446E2
	ldr r2, _02244824 ; =0x0000086C
	ldr r1, _02244828 ; =0x0000011A
	ldr r2, [r4, r2]
	add r0, r4, #0
	bl ov40_022442F0
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_022446E2:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0224481E
_022446FC:
	ldr r0, _0224482C ; =ov40_02245CA0
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0224471E
	add r0, r4, #0
	bl ov40_02230944
	ldr r1, _02244830 ; =0x0000011B
	add r0, r4, #0
	mov r2, #0
	bl ov40_022442F0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224481E
_0224471E:
	ldr r0, _02244834 ; =ov40_02245CA4
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0224481E
	add r0, r4, #0
	bl ov40_02230944
	mov r0, #1
	str r0, [r5, #0xc]
	add r0, r4, #0
	bl ov40_022442CC
	mov r0, #4
	str r0, [r4, #8]
	b _0224481E
_0224473E:
	ldr r0, _0224482C ; =ov40_02245CA0
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _02244760
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	bl ov40_022306E0
	mov r0, #0
	str r0, [r5, #0xc]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224481E
_02244760:
	ldr r0, _02244834 ; =ov40_02245CA4
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _0224481E
	add r0, r4, #0
	bl ov40_02230944
	add r0, r4, #0
	bl ov40_022442CC
	mov r0, #1
	str r0, [r5, #0xc]
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224481E
_02244782:
	bl ov40_02244494
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224481E
_0224478E:
	add r0, r5, #0
	add r0, #8
	mov r1, #1
	bl ov40_0222DA84
	add r0, r5, #0
	add r1, r5, #4
	mov r2, #1
	mov r3, #0
	bl ov40_0222DA00
	cmp r0, #0
	beq _022447BE
	ldr r0, [r5, #0xc]
	cmp r0, #1
	bne _022447B8
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
	b _022447BE
_022447B8:
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
_022447BE:
	ldr r0, [r4, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r5, #8]
	ldr r0, [r4, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	b _0224481E
_022447D8:
	bl ov40_022306F0
	cmp r0, #0
	beq _022447FE
	add r0, r4, #0
	bl ov40_0222FDC4
	add r0, r4, #0
	bl ov40_0222FCCC
	ldr r1, _02244838 ; =0x0000011D
	add r0, r4, #0
	mov r2, #0
	bl ov40_022442F0
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	b _0224481E
_022447FE:
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
	b _0224481E
_02244808:
	bl System_GetTouchNew
	cmp r0, #0
	beq _0224481E
	add r0, r4, #0
	bl ov40_022442CC
	add r0, r4, #0
	mov r1, #3
	bl ov40_0222BF80
_0224481E:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02244824: .word 0x0000086C
_02244828: .word 0x0000011A
_0224482C: .word ov40_02245CA0
_02244830: .word 0x0000011B
_02244834: .word ov40_02245CA4
_02244838: .word 0x0000011D
	thumb_func_end ov40_0224462C

	thumb_func_start ov40_0224483C
ov40_0224483C: ; 0x0224483C
	push {r3, r4, r5, lr}
	mov r1, #0x86
	add r5, r0, #0
	lsl r1, r1, #4
	ldr r4, [r5, r1]
	ldr r1, [r5, #8]
	cmp r1, #0
	beq _02244856
	cmp r1, #1
	beq _0224485A
	cmp r1, #2
	beq _02244860
	b _02244896
_02244856:
	add r0, r1, #1
	str r0, [r5, #8]
_0224485A:
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
_02244860:
	add r0, r5, #0
	bl ov40_0222D88C
	ldr r0, [r5, #0x24]
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r0, [r5, #0x24]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	mov r1, #1
	bl ov40_0222FB90
	ldr r0, [r5, #8]
	add r0, r0, #1
	str r0, [r5, #8]
	b _0224491A
_02244896:
	bl ov40_0222FBB4
	cmp r0, #0
	beq _0224491A
	add r0, r4, #0
	add r0, #8
	mov r1, #0
	bl ov40_0222DA84
	cmp r0, #0
	beq _022448EA
	add r0, r5, #0
	bl ov40_0222DD08
	add r0, r4, #0
	add r0, #8
	bl ov40_0222DAA8
	ldr r0, [r5, #0x58]
	mov r1, #2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r0, [r5, #0x28]
	mov r2, #0xc
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	mov r1, #1
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	add r2, r1, #0
	bl ov40_0222BF64
	add r0, r5, #0
	mov r1, #5
	bl ov40_0222BF80
	add r0, r4, #0
	bl Heap_Free
	b _0224491A
_022448EA:
	ldr r0, [r5, #0x58]
	mov r1, #1
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #2
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
	ldr r0, [r5, #0x58]
	mov r1, #3
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	ldr r3, [r4, #8]
	ldr r0, [r5, #0x28]
	lsl r3, r3, #0x18
	mov r2, #0xc
	lsr r3, r3, #0x18
	bl PaletteData_BlendPalettes
_0224491A:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_0224483C

	thumb_func_start ov40_02244920
ov40_02244920: ; 0x02244920
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	add r0, #0xaa
	ldrb r0, [r0]
	str r1, [sp]
	str r2, [sp, #4]
	add r1, sp, #0x28
	add r2, sp, #0x24
	bl sub_0202FEB8
	ldr r1, [sp, #4]
	mov r0, #0x40
	bl String_New
	add r4, r0, #0
	ldr r1, [sp, #4]
	mov r0, #0x40
	bl String_New
	str r0, [sp, #0x1c]
	ldr r0, [sp, #4]
	mov r1, #0x80
	bl Heap_Alloc
	add r5, r0, #0
	mov r0, #0
	ldr r1, [sp, #0x28]
	str r0, [sp, #0x20]
	cmp r1, #0
	ble _022449EA
	ldr r0, [sp]
	mov r7, #0
	mvn r7, r7
	str r0, [sp, #0x14]
	str r0, [sp, #0x10]
	add r0, #0x3c
	str r0, [sp, #0x10]
	str r0, [sp, #0xc]
	lsr r6, r7, #0x10
_0224496E:
	ldr r2, [sp, #0x14]
	mov r1, #7
	add r2, #0xe
_02244974:
	ldrh r0, [r2, #0x3c]
	cmp r0, r6
	beq _02244982
	sub r1, r1, #1
	sub r2, r2, #2
	cmp r1, r7
	bgt _02244974
_02244982:
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	bne _0224499E
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #4]
	bl ov40_02244A84
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x10]
	mov r2, #8
	bl CopyStringToU16Array
	b _022449CC
_0224499E:
	add r0, r4, #0
	bl String_SetEmpty
	ldr r1, [sp, #0xc]
	add r0, r4, #0
	bl CopyU16ArrayToString
	ldr r2, [sp, #0x1c]
	mov r0, #0
	add r1, r4, #0
	bl FontID_String_AllCharsValid
	cmp r0, #0
	bne _022449CC
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #4]
	bl ov40_02244A84
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x10]
	mov r2, #8
	bl CopyStringToU16Array
_022449CC:
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x28]
	add r0, #0x34
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x10]
	add r0, #0x34
	str r0, [sp, #0x10]
	ldr r0, [sp, #0xc]
	add r0, #0x34
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x20]
	add r0, r0, #1
	str r0, [sp, #0x20]
	cmp r0, r1
	blt _0224496E
_022449EA:
	mov r0, #0
	str r0, [sp, #8]
	cmp r1, #0
	ble _02244A6E
_022449F2:
	ldr r0, [sp]
	ldr r0, [r0, #4]
	bl Party_GetCount
	mov r6, #0
	str r0, [sp, #0x18]
	cmp r0, #0
	ble _02244A5C
_02244A02:
	ldr r0, [sp]
	add r1, r6, #0
	ldr r0, [r0, #4]
	bl Party_GetMonByIndex
	mov r1, #0xac
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	cmp r0, #0
	beq _02244A5C
	mov r0, #0
	add r1, r5, #0
	mov r2, #0x80
	bl MIi_CpuClear16
	add r0, r7, #0
	mov r1, #0x75
	add r2, r5, #0
	bl GetMonData
	add r0, r4, #0
	bl String_SetEmpty
	add r0, r4, #0
	add r1, r5, #0
	bl CopyU16ArrayToString
	ldr r2, [sp, #0x1c]
	mov r0, #0
	add r1, r4, #0
	bl FontID_String_AllCharsValid
	cmp r0, #0
	bne _02244A54
	add r0, r7, #0
	mov r1, #0xb3
	mov r2, #0
	bl SetMonData
_02244A54:
	ldr r0, [sp, #0x18]
	add r6, r6, #1
	cmp r6, r0
	blt _02244A02
_02244A5C:
	ldr r0, [sp]
	ldr r1, [sp, #0x28]
	add r0, r0, #4
	str r0, [sp]
	ldr r0, [sp, #8]
	add r0, r0, #1
	str r0, [sp, #8]
	cmp r0, r1
	blt _022449F2
_02244A6E:
	add r0, r4, #0
	bl String_Delete
	ldr r0, [sp, #0x1c]
	bl String_Delete
	add r0, r5, #0
	bl Heap_Free
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov40_02244920

	thumb_func_start ov40_02244A84
ov40_02244A84: ; 0x02244A84
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r4, r0, #0
	bl String_SetEmpty
	mov r0, #1
	mov r1, #0x1b
	mov r2, #0xd
	add r3, r5, #0
	bl NewMsgDataFromNarc
	mov r1, #0x53
	add r5, r0, #0
	lsl r1, r1, #2
	add r2, r4, #0
	bl ReadMsgDataIntoString
	add r0, r5, #0
	bl DestroyMsgData
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov40_02244A84

	thumb_func_start ov40_02244AB0
ov40_02244AB0: ; 0x02244AB0
	push {r3, r4, r5, r6, r7, lr}
	add r4, r3, #0
	add r6, r1, #0
	ldrh r1, [r4]
	add r7, r0, #0
	add r5, r2, #0
	cmp r1, #0
	beq _02244AC6
	cmp r1, #1
	beq _02244B1A
	b _02244B28
_02244AC6:
	ldr r0, _02244B2C ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _02244AD2
	bl GF_AssertFail
_02244AD2:
	cmp r5, #1
	bne _02244AFA
	ldr r1, _02244B2C ; =_021D2AF8
	ldr r2, _02244B30 ; =0x0000E281
	ldr r0, [r1]
	add r0, #0xab
	strb r5, [r0]
	ldr r0, [r1]
	add r0, #0xcc
	strh r2, [r0]
	ldr r1, [r1]
	add r0, r7, #0
	add r1, #0x84
	mov r2, #0x58
	bl SaveArray_CalcCRC16
	ldr r1, _02244B2C ; =_021D2AF8
	ldr r1, [r1]
	add r1, #0xe4
	strh r0, [r1]
_02244AFA:
	ldr r0, _02244B2C ; =_021D2AF8
	ldr r1, _02244B34 ; =0x00001D4C
	ldr r0, [r0]
	ldr r2, _02244B38 ; =0x0000FFFF
	ldrh r3, [r0, r1]
	add r0, #0xe8
	sub r1, #0xe8
	eor r2, r3
	lsl r2, r2, #0x10
	add r2, r3, r2
	bl sub_02030250
	ldrh r0, [r4]
	add r0, r0, #1
	strh r0, [r4]
	b _02244B28
_02244B1A:
	ldr r1, _02244B2C ; =_021D2AF8
	ldr r3, [sp, #0x18]
	ldr r1, [r1]
	add r2, r6, #0
	bl sub_0202FDA4
	pop {r3, r4, r5, r6, r7, pc}
_02244B28:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02244B2C: .word _021D2AF8
_02244B30: .word 0x0000E281
_02244B34: .word 0x00001D4C
_02244B38: .word 0x0000FFFF
	thumb_func_end ov40_02244AB0

	thumb_func_start ov40_02244B3C
ov40_02244B3C: ; 0x02244B3C
	push {r3, lr}
	ldr r0, _02244B64 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _02244B4A
	bl GF_AssertFail
_02244B4A:
	ldr r0, _02244B64 ; =_021D2AF8
	ldr r1, _02244B68 ; =0x00001D4C
	ldr r0, [r0]
	ldr r2, _02244B6C ; =0x0000FFFF
	ldrh r3, [r0, r1]
	add r0, #0xe8
	sub r1, #0xe8
	eor r2, r3
	lsl r2, r2, #0x10
	add r2, r3, r2
	bl sub_02030250
	pop {r3, pc}
	.balign 4, 0
_02244B64: .word _021D2AF8
_02244B68: .word 0x00001D4C
_02244B6C: .word 0x0000FFFF
	thumb_func_end ov40_02244B3C

	thumb_func_start ov40_02244B70
ov40_02244B70: ; 0x02244B70
	push {r4, r5, r6, lr}
	add r4, r3, #0
	add r5, r1, #0
	ldrh r1, [r4]
	add r6, r2, #0
	cmp r1, #0
	beq _02244B84
	cmp r1, #1
	beq _02244BA6
	b _02244BB4
_02244B84:
	ldr r0, _02244BB8 ; =_021D2AF8
	ldr r0, [r0]
	cmp r0, #0
	bne _02244B90
	bl GF_AssertFail
_02244B90:
	ldr r0, _02244BB8 ; =_021D2AF8
	ldr r1, [r0]
	add r0, r1, #0
	add r0, #0xdc
	str r5, [r0]
	add r1, #0xe0
	str r6, [r1]
	ldrh r0, [r4]
	add r0, r0, #1
	strh r0, [r4]
	b _02244BB4
_02244BA6:
	ldr r1, _02244BB8 ; =_021D2AF8
	ldr r3, [sp, #0x10]
	ldr r1, [r1]
	mov r2, #0
	bl sub_0202FDA4
	pop {r4, r5, r6, pc}
_02244BB4:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02244BB8: .word _021D2AF8
	thumb_func_end ov40_02244B70

	thumb_func_start ov40_02244BBC
ov40_02244BBC: ; 0x02244BBC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _02244C34 ; =_021D2AF8
	add r4, r1, #0
	ldr r0, [r0]
	cmp r0, #0
	bne _02244BCE
	bl GF_AssertFail
_02244BCE:
	ldr r1, _02244C34 ; =_021D2AF8
	mov r2, #1
	ldr r0, [r1]
	add r0, #0xab
	strb r2, [r0]
	ldr r0, [r1]
	ldr r2, _02244C38 ; =0x0000E281
	add r0, #0xcc
	strh r2, [r0]
	ldr r1, [r1]
	add r0, r5, #0
	add r1, #0x84
	mov r2, #0x58
	bl SaveArray_CalcCRC16
	ldr r1, _02244C34 ; =_021D2AF8
	ldr r3, _02244C3C ; =0x0000FFFF
	ldr r2, [r1]
	add r2, #0xe4
	strh r0, [r2]
	ldr r0, [r1]
	ldr r1, _02244C40 ; =0x00001D4C
	ldrh r2, [r0, r1]
	add r0, #0xe8
	sub r1, #0xe8
	eor r3, r2
	lsl r3, r3, #0x10
	add r2, r2, r3
	bl sub_02030250
	mov r0, #8
	bl sub_0201A728
	ldr r1, _02244C34 ; =_021D2AF8
	add r0, r5, #0
	ldr r1, [r1]
	add r2, r4, #0
	bl sub_02027134
	add r4, r0, #0
	cmp r4, #2
	bne _02244C2A
	add r0, r5, #0
	bl SaveGameNormal
	add r4, r0, #0
_02244C2A:
	mov r0, #8
	bl sub_0201A738
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02244C34: .word _021D2AF8
_02244C38: .word 0x0000E281
_02244C3C: .word 0x0000FFFF
_02244C40: .word 0x00001D4C
	thumb_func_end ov40_02244BBC
