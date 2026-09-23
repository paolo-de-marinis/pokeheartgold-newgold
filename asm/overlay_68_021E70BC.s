	.include "asm/macros.inc"
	.include "overlay_68.inc"
	.include "global.inc"

.public ov68_021E5A58
.public ov68_021E5B14
.public ov68_021E66A0
.public ov68_021E67E0
.public ov68_021E68D4
.public ov68_021E6BEC
.public ov68_021E6C14
.public ov68_021E6CD8
.public ov68_021E6D00
.public ov68_021E6D20
.public ov68_021E6D40
.public ov68_021E6D4C
.public ov68_021E6D58
.public ov68_021E6D64
.public ov68_021E6D80
.public ov68_021E6D9C
.public ov68_021E6DB8
.public ov68_021E6DD0
.public ov68_021E6DDC
.public ov68_021E6EB8
.public ov68_021E7BF8
.public ov68_021E7C18
.public ov68_021E7C2C
.public ov68_021E7C44
.public ov68_021E7C60
.public ov68_021E7C7C
.public ov68_021E7C98
.public ov68_021E7CB4
.public ov68_021E7CD0
.public ov68_021E7D14
.public ov68_021E7D3C
.public ov68_021E7D40
.public ov68_021E7DA4
.public ov68_021E7DFC

	.text

	thumb_func_start ov68_021E70BC
ov68_021E70BC: ; 0x021E70BC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r4, #0
	mov r7, #0x28
	add r5, r6, #0
_021E70C6:
	mov r0, #0x4d
	lsl r0, r0, #2
	lsl r2, r7, #0x10
	ldr r0, [r5, r0]
	mov r1, #0x16
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, [r6]
	ldrh r0, [r0, #0x16]
	add r1, r0, r4
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r0, [r6, r0]
	cmp r1, r0
	blo _021E70F4
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	b _021E7116
_021E70F4:
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	ldr r2, [r6]
	add r0, r6, #0
	ldr r1, [r2, #0x10]
	ldrh r2, [r2, #0x16]
	add r2, r2, r4
	lsl r2, r2, #1
	ldrh r1, [r1, r2]
	lsl r2, r4, #0x10
	lsr r2, r2, #0x10
	bl ov68_021E7028
_021E7116:
	add r4, r4, #1
	add r7, #0x20
	add r5, r5, #4
	cmp r4, #4
	blo _021E70C6
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov68_021E70BC

	thumb_func_start ov68_021E7124
ov68_021E7124: ; 0x021E7124
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #1
	bl GetMoveAttr
	add r4, r0, #0
	bl sub_02077830
	add r6, r0, #0
	add r0, r4, #0
	bl sub_02077800
	add r3, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, _021E7174 ; =0x0000B8AA
	mov r1, #0x47
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	add r2, r6, #0
	bl SpriteSystem_ReplaceCharResObj
	add r0, r4, #0
	bl sub_02077818
	add r1, r0, #0
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	add r1, r1, #4
	bl ManagedSprite_SetPaletteOverride
	add sp, #8
	pop {r4, r5, r6, pc}
	nop
_021E7174: .word 0x0000B8AA
	thumb_func_end ov68_021E7124

	thumb_func_start ov68_021E7178
ov68_021E7178: ; 0x021E7178
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r4, r1, #0
	bl ov68_021E6DDC
	add r0, r6, #0
	add r1, r4, #0
	bl ov68_021E6EB8
	ldr r4, _021E71C0 ; =ov68_021E7E74
	mov r7, #0
	add r5, r6, #0
_021E7190:
	mov r0, #0x47
	mov r1, #0x12
	lsl r0, r0, #2
	lsl r1, r1, #4
	ldr r0, [r6, r0]
	ldr r1, [r6, r1]
	add r2, r4, #0
	bl SpriteSystem_NewSprite
	mov r1, #0x49
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r1, #0
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnimateFlag
	add r7, r7, #1
	add r4, #0x34
	add r5, r5, #4
	cmp r7, #0xc
	blo _021E7190
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E71C0: .word ov68_021E7E74
	thumb_func_end ov68_021E7178

	thumb_func_start ov68_021E71C4
ov68_021E71C4: ; 0x021E71C4
	push {r4, r5, lr}
	sub sp, #0x1c
	ldr r5, _021E721C ; =ov68_021E7BEC
	add r4, r0, #0
	add r2, r1, #0
	ldmia r5!, {r0, r1}
	add r3, sp, #0x10
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	add r1, sp, #8
	str r0, [r3]
	mov r0, #0
	strh r0, [r1]
	strh r0, [r1, #2]
	strh r0, [r1, #4]
	strh r0, [r1, #6]
	add r0, r2, #0
	bl Camera_New
	str r0, [r4]
	mov r1, #1
	str r1, [sp]
	ldr r0, [r4]
	ldr r3, _021E7220 ; =0x000005C1
	str r0, [sp, #4]
	add r0, sp, #0x10
	lsl r1, r1, #0x10
	add r2, sp, #8
	bl Camera_Init_FromPosDistanceAndAngle
	mov r1, #0x19
	ldr r2, [r4]
	mov r0, #0
	lsl r1, r1, #0xe
	bl Camera_SetPerspectiveClippingPlane
	ldr r0, [r4]
	bl Camera_ClearFixedTarget
	ldr r0, [r4]
	bl Camera_SetStaticPtr
	add sp, #0x1c
	pop {r4, r5, pc}
	.balign 4, 0
_021E721C: .word ov68_021E7BEC
_021E7220: .word 0x000005C1
	thumb_func_end ov68_021E71C4

	thumb_func_start ov68_021E7224
ov68_021E7224: ; 0x021E7224
	push {r4, r5, r6, lr}
	sub sp, #0x20
	add r5, r0, #0
	add r4, r1, #0
	add r0, r2, #0
	bl PokepicManager_Create
	str r0, [r5, #4]
	add r0, sp, #0x10
	add r1, r4, #0
	mov r2, #2
	bl GetPokemonSpriteCharAndPlttNarcIds
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	ldr r0, [r5, #4]
	add r1, sp, #0x10
	mov r2, #0x34
	mov r3, #0x80
	bl PokepicManager_CreatePokepic
	str r0, [r5, #0x18]
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	add r6, r0, #0
	add r0, r4, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r1, r0, #0
	add r0, r6, #0
	mov r2, #0x1c
	bl GetMonBaseStat_HandleAlternateForm
	add r3, r0, #0
	mov r2, #1
	ldr r0, [r5, #0x18]
	mov r1, #0x23
	eor r2, r3
	bl Pokepic_SetAttr
	add sp, #0x20
	pop {r4, r5, r6, pc}
	thumb_func_end ov68_021E7224

	thumb_func_start ov68_021E7288
ov68_021E7288: ; 0x021E7288
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl NNS_G3dInit
	bl G3X_Init
	bl G3X_InitMtxStack
	ldr r1, _021E7330 ; =0x04000060
	ldr r2, _021E7334 ; =0xFFFFCFFD
	ldrh r0, [r1]
	and r0, r2
	strh r0, [r1]
	ldrh r3, [r1]
	ldr r0, _021E7338 ; =0x0000CFFB
	and r3, r0
	strh r3, [r1]
	add r3, r2, #2
	ldrh r5, [r1]
	add r2, r2, #2
	sub r0, #0x1c
	and r5, r3
	mov r3, #8
	orr r3, r5
	strh r3, [r1]
	ldrh r3, [r1]
	and r3, r2
	mov r2, #0x10
	orr r2, r3
	strh r2, [r1]
	ldrh r2, [r1]
	and r0, r2
	strh r0, [r1]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl G3X_SetFog
	mov r0, #0
	ldr r2, _021E733C ; =0x00007FFF
	add r1, r0, #0
	mov r3, #0x3f
	str r0, [sp]
	bl G3X_SetClearColor
	ldr r1, _021E7340 ; =0x04000540
	mov r0, #2
	str r0, [r1]
	ldr r0, _021E7344 ; =0xBFFF0000
	mov r2, #0x1c
	str r0, [r1, #0x40]
	mov r0, #0x55
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0
	bl MI_CpuFill8
	mov r0, #0x55
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #0x42
	bl ov68_021E71C4
	ldr r1, [r4]
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r1, [r1]
	add r0, r4, r0
	mov r2, #0x42
	bl ov68_021E7224
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	ldr r1, _021E7348 ; =0x04000008
	mov r0, #3
	ldrh r2, [r1]
	bic r2, r0
	mov r0, #1
	orr r0, r2
	strh r0, [r1]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E7330: .word 0x04000060
_021E7334: .word 0xFFFFCFFD
_021E7338: .word 0x0000CFFB
_021E733C: .word 0x00007FFF
_021E7340: .word 0x04000540
_021E7344: .word 0xBFFF0000
_021E7348: .word 0x04000008
	thumb_func_end ov68_021E7288

	thumb_func_start ov68_021E734C
ov68_021E734C: ; 0x021E734C
	push {r4, lr}
	add r4, r0, #0
	bl Thunk_G3X_Reset
	bl Camera_PushLookAtToNNSGlb
	ldr r2, _021E7380 ; =0x04000440
	mov r3, #0
	add r1, r2, #0
	str r3, [r2]
	add r1, #0x14
	str r3, [r1]
	mov r0, #2
	str r0, [r2]
	str r3, [r1]
	bl NNS_G3dGlbFlushP
	bl NNS_G2dSetupSoftwareSpriteCamera
	ldr r0, [r4, #4]
	bl PokepicManager_DrawAll
	ldr r0, _021E7384 ; =0x04000540
	mov r1, #1
	str r1, [r0]
	pop {r4, pc}
	.balign 4, 0
_021E7380: .word 0x04000440
_021E7384: .word 0x04000540
	thumb_func_end ov68_021E734C

	thumb_func_start ov68_021E7388
ov68_021E7388: ; 0x021E7388
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	bl Camera_Delete
	ldr r0, [r4, #4]
	bl PokepicManager_Delete
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x1c
	bl MI_CpuFill8
	pop {r4, pc}
	thumb_func_end ov68_021E7388

	thumb_func_start ov68_021E73A4
ov68_021E73A4: ; 0x021E73A4
	push {r3, r4, r5, lr}
	add r3, r1, #0
	add r4, r0, #0
	add r5, r2, #0
	cmp r3, #4
	bhs _021E73D2
	mov r0, #0x4b
	lsl r2, r3, #5
	lsl r0, r0, #2
	add r2, #0x20
	lsl r2, r2, #0x10
	ldr r0, [r4, r0]
	mov r1, #0
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetAnimationFrame
	b _021E7414
_021E73D2:
	cmp r3, #6
	bhs _021E73FA
	mov r0, #0x4b
	lsl r0, r0, #2
	sub r2, r3, #4
	mov r1, #0x28
	mul r1, r2
	lsl r1, r1, #0x10
	ldr r0, [r4, r0]
	asr r1, r1, #0x10
	mov r2, #0xa8
	bl ManagedSprite_SetPositionXY
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl ManagedSprite_SetAnimationFrame
	b _021E7414
_021E73FA:
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0xc0
	mov r2, #0xa0
	bl ManagedSprite_SetPositionXY
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #2
	bl ManagedSprite_SetAnimationFrame
_021E7414:
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, r5, #0
	bl ManagedSprite_SetPaletteOverride
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov68_021E73A4

	thumb_func_start ov68_021E7424
ov68_021E7424: ; 0x021E7424
	push {r3, r4, r5, r6, r7, lr}
	add r6, r1, #0
	add r5, r0, #0
	add r7, r2, #0
	cmp r6, #0
	bne _021E7442
	cmp r7, #0
	beq _021E7442
	mov r0, #0x49
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r4, #1
	bl ManagedSprite_ResetSpriteAnimCtrlState
	b _021E7444
_021E7442:
	mov r4, #0
_021E7444:
	ldr r0, [r5]
	ldrh r0, [r0, #0x16]
	add r2, r0, #4
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r1, [r5, r0]
	cmp r2, r1
	bge _021E7460
	sub r0, #0x94
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl ManagedSprite_SetAnim
	b _021E746A
_021E7460:
	sub r0, #0x94
	ldr r0, [r5, r0]
	add r1, r4, #2
	bl ManagedSprite_SetAnim
_021E746A:
	mov r0, #0x49
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl ManagedSprite_SetAnimateFlag
	cmp r6, #1
	bne _021E748C
	cmp r7, #0
	beq _021E748C
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r4, #1
	bl ManagedSprite_ResetSpriteAnimCtrlState
	b _021E748E
_021E748C:
	mov r4, #0
_021E748E:
	ldr r0, [r5]
	ldrh r0, [r0, #0x16]
	cmp r0, #0
	beq _021E74A4
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #4
	bl ManagedSprite_SetAnim
	b _021E74B0
_021E74A4:
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #6
	bl ManagedSprite_SetAnim
_021E74B0:
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl ManagedSprite_SetAnimateFlag
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov68_021E7424

	thumb_func_start ov68_021E74C0
ov68_021E74C0: ; 0x021E74C0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #1
	mov r1, #0x42
	bl sub_020880CC
	mov r0, #0x1b
	mov r1, #0xb
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov68_021E74C0

	thumb_func_start ov68_021E74D8
ov68_021E74D8: ; 0x021E74D8
	push {r3, r4, lr}
	sub sp, #4
	ldr r2, _021E7560 ; =_021E7BE8
	add r1, sp, #0
	ldrb r3, [r2]
	ldrb r2, [r2, #1]
	add r4, r0, #0
	strb r3, [r1]
	strb r2, [r1, #1]
	bl ov68_021E5B14
	ldr r0, [r4]
	mov r1, #0x17
	ldr r0, [r0]
	lsl r1, r1, #4
	str r0, [r4, r1]
	ldr r0, [r4]
	ldr r2, [r0, #8]
	add r0, r1, #4
	str r2, [r4, r0]
	add r0, r1, #0
	mov r2, #0
	add r0, #0x11
	strb r2, [r4, r0]
	add r0, r1, #0
	add r0, #0x14
	strb r2, [r4, r0]
	mov r0, #1
	add r1, #0x13
	strb r0, [r4, r1]
	add r0, r4, #0
	bl ov68_021E6BEC
	mov r1, #0x62
	lsl r1, r1, #2
	strh r0, [r4, r1]
	mov r2, #2
	sub r0, r1, #6
	strb r2, [r4, r0]
	add r0, r1, #0
	mov r2, #1
	add r0, #0x14
	str r2, [r4, r0]
	add r0, r1, #0
	mov r2, #0
	add r0, #0x10
	str r2, [r4, r0]
	add r0, r1, #0
	add r0, #0x18
	sub r1, #0x18
	str r2, [r4, r0]
	add r0, r4, r1
	add r1, sp, #0
	bl sub_02089D40
	mov r1, #0x17
	lsl r1, r1, #4
	ldr r0, _021E7564 ; =gOverlayTemplate_PokemonSummary
	add r1, r4, r1
	mov r2, #0x42
	bl OverlayManager_New
	mov r1, #0x6b
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0xc
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021E7560: .word _021E7BE8
_021E7564: .word gOverlayTemplate_PokemonSummary
	thumb_func_end ov68_021E74D8

	thumb_func_start ov68_021E7568
ov68_021E7568: ; 0x021E7568
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x6b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl OverlayManager_Run
	cmp r0, #0
	beq _021E75B6
	mov r0, #0x6b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl OverlayManager_Delete
	add r0, r4, #0
	bl ov68_021E5A58
	ldr r1, [r4]
	add r0, r4, #0
	ldrh r1, [r1, #0x14]
	bl ov68_021E7A18
	ldr r1, [r4]
	add r0, r4, #0
	ldrh r1, [r1, #0x14]
	mov r2, #3
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl ov68_021E73A4
	ldr r0, _021E75BC ; =0x00000186
	ldr r1, [r4]
	ldrb r2, [r4, r0]
	add r0, #0x2a
	strb r2, [r1, #0x1b]
	mov r1, #7
	str r1, [r4, r0]
	mov r0, #0
	pop {r4, pc}
_021E75B6:
	mov r0, #0xc
	pop {r4, pc}
	nop
_021E75BC: .word 0x00000186
	thumb_func_end ov68_021E7568

	thumb_func_start ov68_021E75C0
ov68_021E75C0: ; 0x021E75C0
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x42
	str r0, [sp, #8]
	ldr r0, _021E75F8 ; =ov68_021E7CF0
	ldr r1, _021E75FC ; =ov68_021E7D64
	ldr r2, _021E7600 ; =ov68_021E7C08
	add r3, r4, #0
	bl GridInputHandler_Create
	mov r1, #0x72
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov68_021E7898
	add r0, r4, #0
	bl ov68_021E7910
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_021E75F8: .word ov68_021E7CF0
_021E75FC: .word ov68_021E7D64
_021E7600: .word ov68_021E7C08
	thumb_func_end ov68_021E75C0

	thumb_func_start ov68_021E7604
ov68_021E7604: ; 0x021E7604
	mov r1, #0x72
	lsl r1, r1, #2
	ldr r3, _021E7610 ; =GridInputHandler_Free
	ldr r0, [r0, r1]
	bx r3
	nop
_021E7610: .word GridInputHandler_Free
	thumb_func_end ov68_021E7604

	thumb_func_start ov68_021E7614
ov68_021E7614: ; 0x021E7614
	bx lr
	.balign 4, 0
	thumb_func_end ov68_021E7614

	thumb_func_start ov68_021E7618
ov68_021E7618: ; 0x021E7618
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	mov r1, #0
	add r6, r2, #0
	bl ov68_021E7898
	add r0, r5, #0
	mov r1, #5
	bl ov68_021E7A18
	cmp r4, #3
	bgt _021E766A
	ldr r0, _021E7738 ; =0x000005DD
	bl PlaySE
	ldr r0, [r5]
	strh r4, [r0, #0x14]
	ldr r0, [r5]
	ldrh r1, [r0, #0x16]
	ldrh r0, [r0, #0x14]
	add r1, r1, r0
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r0, [r5, r0]
	cmp r1, r0
	bge _021E765E
	add r0, r5, #0
	bl ov68_021E6BEC
	add r1, r0, #0
	add r0, r5, #0
	bl ov68_021E68D4
	b _021E7728
_021E765E:
	mov r1, #1
	add r0, r5, #0
	mvn r1, r1
	bl ov68_021E68D4
	b _021E7728
_021E766A:
	cmp r4, #6
	bne _021E7722
	cmp r6, #3
	bne _021E76C2
	ldr r0, [r5]
	ldrh r0, [r0, #0x16]
	add r1, r0, #4
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r0, [r5, r0]
	cmp r1, r0
	bge _021E76C2
	ldr r0, _021E7738 ; =0x000005DD
	bl PlaySE
	mov r0, #0x72
	lsl r0, r0, #2
	mov r4, #3
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl GridInputHandler_SetNextInput
	ldr r1, [r5]
	ldrh r0, [r1, #0x16]
	add r0, r0, #1
	strh r0, [r1, #0x16]
	add r0, r5, #0
	bl ov68_021E67E0
	add r0, r5, #0
	bl ov68_021E6BEC
	add r1, r0, #0
	add r0, r5, #0
	bl ov68_021E68D4
	add r0, r5, #0
	bl ov68_021E7910
	add r0, r5, #0
	mov r1, #1
	bl ov68_021E797C
	b _021E7728
_021E76C2:
	cmp r6, #0
	bne _021E7710
	ldr r0, [r5]
	ldrh r0, [r0, #0x16]
	cmp r0, #0
	beq _021E7700
	ldr r0, _021E7738 ; =0x000005DD
	bl PlaySE
	ldr r1, [r5]
	ldrh r0, [r1, #0x16]
	sub r0, r0, #1
	strh r0, [r1, #0x16]
	add r0, r5, #0
	bl ov68_021E67E0
	add r0, r5, #0
	bl ov68_021E6BEC
	add r1, r0, #0
	add r0, r5, #0
	bl ov68_021E68D4
	add r0, r5, #0
	bl ov68_021E7910
	mov r1, #0
	add r0, r5, #0
	mvn r1, r1
	bl ov68_021E797C
_021E7700:
	mov r0, #0x72
	lsl r0, r0, #2
	mov r4, #0
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl GridInputHandler_SetNextInput
	b _021E7728
_021E7710:
	ldr r0, _021E7738 ; =0x000005DD
	bl PlaySE
	mov r1, #1
	add r0, r5, #0
	mvn r1, r1
	bl ov68_021E68D4
	b _021E7728
_021E7722:
	ldr r0, _021E7738 ; =0x000005DD
	bl PlaySE
_021E7728:
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	mov r2, #3
	bl ov68_021E73A4
	pop {r4, r5, r6, pc}
	nop
_021E7738: .word 0x000005DD
	thumb_func_end ov68_021E7618

	thumb_func_start ov68_021E773C
ov68_021E773C: ; 0x021E773C
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #3
	bgt _021E7792
	ldr r1, [r5]
	strh r4, [r1, #0x14]
	ldr r2, [r5]
	ldrh r1, [r2, #0x16]
	ldrh r2, [r2, #0x14]
	add r3, r1, r2
	mov r2, #0x6e
	lsl r2, r2, #2
	ldrb r2, [r5, r2]
	cmp r3, r2
	bge _021E7778
	bl ov68_021E7A18
	add r0, r5, #0
	mov r1, #1
	bl ov68_021E7898
	add r0, r5, #0
	bl ov68_021E6BEC
	add r1, r0, #0
	add r0, r5, #0
	bl ov68_021E68D4
	b _021E7884
_021E7778:
	mov r1, #5
	bl ov68_021E7A18
	add r0, r5, #0
	mov r1, #0
	bl ov68_021E7898
	mov r1, #1
	add r0, r5, #0
	mvn r1, r1
	bl ov68_021E68D4
	b _021E7884
_021E7792:
	cmp r4, #4
	bne _021E77E8
	ldr r0, _021E7894 ; =0x000005DD
	bl PlaySE
	ldr r1, [r5]
	ldrh r0, [r1, #0x16]
	ldrh r4, [r1, #0x14]
	add r0, r0, #1
	strh r0, [r1, #0x16]
	add r0, r5, #0
	bl ov68_021E6BEC
	add r1, r0, #0
	add r0, r5, #0
	bl ov68_021E68D4
	add r0, r5, #0
	bl ov68_021E67E0
	add r0, r5, #0
	mov r1, #5
	bl ov68_021E7A18
	add r0, r5, #0
	mov r1, #0
	bl ov68_021E7898
	add r0, r5, #0
	bl ov68_021E7910
	add r0, r5, #0
	mov r1, #1
	bl ov68_021E797C
	mov r0, #0x72
	lsl r0, r0, #2
	lsl r1, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	b _021E7884
_021E77E8:
	cmp r4, #5
	bne _021E7840
	ldr r0, _021E7894 ; =0x000005DD
	bl PlaySE
	ldr r1, [r5]
	ldrh r0, [r1, #0x16]
	ldrh r4, [r1, #0x14]
	sub r0, r0, #1
	strh r0, [r1, #0x16]
	add r0, r5, #0
	bl ov68_021E6BEC
	add r1, r0, #0
	add r0, r5, #0
	bl ov68_021E68D4
	add r0, r5, #0
	bl ov68_021E67E0
	add r0, r5, #0
	mov r1, #5
	bl ov68_021E7A18
	add r0, r5, #0
	mov r1, #0
	bl ov68_021E7898
	add r0, r5, #0
	bl ov68_021E7910
	mov r1, #0
	add r0, r5, #0
	mvn r1, r1
	bl ov68_021E797C
	mov r0, #0x72
	lsl r0, r0, #2
	lsl r1, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	b _021E7884
_021E7840:
	cmp r4, #6
	bne _021E786E
	mov r1, #5
	bl ov68_021E7A18
	add r0, r5, #0
	mov r1, #0
	bl ov68_021E7898
	mov r0, #0x73
	lsl r0, r0, #2
	ldrh r1, [r5, r0]
	cmp r1, #6
	beq _021E7884
	ldr r1, [r5]
	sub r0, r0, #4
	ldrh r4, [r1, #0x14]
	ldr r0, [r5, r0]
	lsl r1, r4, #0x18
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	b _021E7884
_021E786E:
	cmp r4, #7
	bne _021E7884
	ldr r0, [r5]
	ldrh r4, [r0, #0x14]
	mov r0, #0x72
	lsl r0, r0, #2
	lsl r1, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
_021E7884:
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	mov r2, #3
	bl ov68_021E73A4
	pop {r3, r4, r5, pc}
	nop
_021E7894: .word 0x000005DD
	thumb_func_end ov68_021E773C

	thumb_func_start ov68_021E7898
ov68_021E7898: ; 0x021E7898
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	cmp r1, #1
	bne _021E78D6
	mov r0, #0x72
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #7
	bl GridInputHandler_SetEnabledFlag
	add r0, r4, #0
	add r0, #0x88
	bl ScheduleWindowCopyToVram
	mov r0, #4
	str r0, [sp]
	mov r3, #8
	str r3, [sp, #4]
	mov r0, #0xc
	str r0, [sp, #8]
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0x14
	bl ov68_021E66A0
	ldr r0, _021E790C ; =0x000001CE
	mov r1, #1
	add sp, #0xc
	strh r1, [r4, r0]
	pop {r3, r4, pc}
_021E78D6:
	mov r0, #0x72
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #7
	bl GridInputHandler_ClearEnabledFlag
	add r0, r4, #0
	add r0, #0x88
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #4
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0xc
	str r0, [sp, #8]
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0x14
	mov r3, #8
	bl ov68_021E66A0
	mov r1, #0
	ldr r0, _021E790C ; =0x000001CE
	strh r1, [r4, r0]
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021E790C: .word 0x000001CE
	thumb_func_end ov68_021E7898

	thumb_func_start ov68_021E7910
ov68_021E7910: ; 0x021E7910
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r1, [r4, r0]
	cmp r1, #4
	bhs _021E7936
	add r0, #0x10
	ldr r0, [r4, r0]
	mov r1, #4
	bl GridInputHandler_ClearEnabledFlag
	mov r0, #0x72
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #5
	bl GridInputHandler_ClearEnabledFlag
	pop {r4, pc}
_021E7936:
	ldr r1, [r4]
	ldrh r1, [r1, #0x16]
	cmp r1, #0
	bne _021E794A
	add r0, #0x10
	ldr r0, [r4, r0]
	mov r1, #5
	bl GridInputHandler_ClearEnabledFlag
	b _021E7954
_021E794A:
	add r0, #0x10
	ldr r0, [r4, r0]
	mov r1, #5
	bl GridInputHandler_SetEnabledFlag
_021E7954:
	ldr r0, [r4]
	ldrh r0, [r0, #0x16]
	add r2, r0, #4
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r1, [r4, r0]
	cmp r2, r1
	blt _021E7970
	add r0, #0x10
	ldr r0, [r4, r0]
	mov r1, #4
	bl GridInputHandler_ClearEnabledFlag
	pop {r4, pc}
_021E7970:
	add r0, #0x10
	ldr r0, [r4, r0]
	mov r1, #4
	bl GridInputHandler_SetEnabledFlag
	pop {r4, pc}
	thumb_func_end ov68_021E7910

	thumb_func_start ov68_021E797C
ov68_021E797C: ; 0x021E797C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x4a
	lsl r0, r0, #2
	add r4, r1, #0
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetAnimateFlag
	mov r0, #0x49
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetAnimateFlag
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnimationFrame
	mov r0, #0x49
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnimationFrame
	cmp r4, #0
	ldr r0, [r5]
	ble _021E79EA
	ldrh r0, [r0, #0x16]
	add r2, r0, #4
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r1, [r5, r0]
	cmp r2, r1
	bge _021E79D2
	sub r0, #0x94
	ldr r0, [r5, r0]
	mov r1, #1
	bl ManagedSprite_SetAnim
	b _021E79DC
_021E79D2:
	sub r0, #0x94
	ldr r0, [r5, r0]
	mov r1, #3
	bl ManagedSprite_SetAnim
_021E79DC:
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #4
	bl ManagedSprite_SetAnim
	pop {r3, r4, r5, pc}
_021E79EA:
	ldrh r0, [r0, #0x16]
	cmp r0, #0
	bne _021E79FE
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #7
	bl ManagedSprite_SetAnim
	b _021E7A0A
_021E79FE:
	mov r0, #0x4a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #5
	bl ManagedSprite_SetAnim
_021E7A0A:
	mov r0, #0x49
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetAnim
	pop {r3, r4, r5, pc}
	thumb_func_end ov68_021E797C

	thumb_func_start ov68_021E7A18
ov68_021E7A18: ; 0x021E7A18
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r7, r1, #0
	mov r6, #0
	mov r4, #4
_021E7A24:
	cmp r6, r7
	bne _021E7A44
	mov r0, #4
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #8
	lsl r2, r4, #0x18
	str r0, [sp, #8]
	add r0, r5, #0
	mov r1, #0
	lsr r2, r2, #0x18
	mov r3, #0x10
	bl ov68_021E66A0
	b _021E7A82
_021E7A44:
	mov r0, #0x6e
	lsl r0, r0, #2
	ldrb r0, [r5, r0]
	cmp r6, r0
	blo _021E7A6A
	mov r0, #4
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #4
	lsl r2, r4, #0x18
	str r0, [sp, #8]
	add r0, r5, #0
	mov r1, #0
	lsr r2, r2, #0x18
	mov r3, #0x10
	bl ov68_021E66A0
	b _021E7A82
_021E7A6A:
	mov r0, #4
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	lsl r2, r4, #0x18
	str r0, [sp, #8]
	add r0, r5, #0
	mov r1, #0
	lsr r2, r2, #0x18
	mov r3, #0x10
	bl ov68_021E66A0
_021E7A82:
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #4
	blo _021E7A24
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov68_021E7A18

	thumb_func_start ov68_021E7A90
ov68_021E7A90: ; 0x021E7A90
	mov r2, #0x1d
	lsl r2, r2, #4
	add r2, r0, r2
	mov r0, #0x18
	strb r0, [r2]
	mov r0, #0x14
	strb r0, [r2, #1]
	mov r0, #8
	strb r0, [r2, #2]
	mov r0, #4
	strb r0, [r2, #3]
	mov r0, #0
	strh r0, [r2, #4]
	strh r0, [r2, #6]
	str r1, [r2, #8]
	mov r0, #0xd
	bx lr
	.balign 4, 0
	thumb_func_end ov68_021E7A90

	thumb_func_start ov68_021E7AB4
ov68_021E7AB4: ; 0x021E7AB4
	mov r2, #0x1d
	lsl r2, r2, #4
	add r2, r0, r2
	mov r0, #0xf
	strb r0, [r2]
	mov r0, #0x14
	strb r0, [r2, #1]
	mov r0, #8
	strb r0, [r2, #2]
	mov r0, #4
	strb r0, [r2, #3]
	mov r0, #0
	strh r0, [r2, #4]
	strh r0, [r2, #6]
	str r1, [r2, #8]
	mov r0, #0xd
	bx lr
	.balign 4, 0
	thumb_func_end ov68_021E7AB4

	thumb_func_start ov68_021E7AD8
ov68_021E7AD8: ; 0x021E7AD8
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0x1d
	lsl r0, r0, #4
	add r4, r5, r0
	ldrh r0, [r4, #6]
	cmp r0, #0
	beq _021E7AF4
	cmp r0, #1
	beq _021E7B1A
	cmp r0, #2
	beq _021E7B52
	b _021E7B64
_021E7AF4:
	ldrb r0, [r4, #2]
	mov r1, #7
	str r0, [sp]
	ldrb r0, [r4, #3]
	str r0, [sp, #4]
	str r1, [sp, #8]
	ldrb r2, [r4]
	ldrb r3, [r4, #1]
	ldr r0, [r5, #4]
	bl BgTilemapRectChangePalette
	ldr r0, [r5, #4]
	mov r1, #7
	bl ScheduleBgTilemapBufferTransfer
	ldrh r0, [r4, #6]
	add r0, r0, #1
	strh r0, [r4, #6]
	b _021E7B64
_021E7B1A:
	ldrh r0, [r4, #4]
	add r0, r0, #1
	strh r0, [r4, #4]
	ldrh r0, [r4, #4]
	cmp r0, #4
	bne _021E7B64
	ldrb r0, [r4, #2]
	mov r1, #7
	str r0, [sp]
	ldrb r0, [r4, #3]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	ldrb r2, [r4]
	ldrb r3, [r4, #1]
	ldr r0, [r5, #4]
	bl BgTilemapRectChangePalette
	ldr r0, [r5, #4]
	mov r1, #7
	bl ScheduleBgTilemapBufferTransfer
	mov r0, #0
	strh r0, [r4, #4]
	ldrh r0, [r4, #6]
	add r0, r0, #1
	strh r0, [r4, #6]
	b _021E7B64
_021E7B52:
	ldrh r0, [r4, #4]
	add r0, r0, #1
	strh r0, [r4, #4]
	ldrh r0, [r4, #4]
	cmp r0, #2
	bne _021E7B64
	add sp, #0xc
	ldr r0, [r4, #8]
	pop {r4, r5, pc}
_021E7B64:
	mov r0, #0xd
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov68_021E7AD8

	thumb_func_start ov68_021E7B6C
ov68_021E7B6C: ; 0x021E7B6C
	push {r4, lr}
	mov r1, #2
	add r4, r0, #0
	bl ov68_021E6C14
	ldr r0, _021E7B88 ; =0x000001BA
	mov r1, #1
	strb r1, [r4, r0]
	mov r1, #3
	sub r0, #0xa
	str r1, [r4, r0]
	mov r0, #2
	pop {r4, pc}
	nop
_021E7B88: .word 0x000001BA
	thumb_func_end ov68_021E7B6C

	thumb_func_start ov68_021E7B8C
ov68_021E7B8C: ; 0x021E7B8C
	ldr r3, _021E7B90 ; =ov68_021E7B94
	bx r3
	.balign 4, 0
_021E7B90: .word ov68_021E7B94
	thumb_func_end ov68_021E7B8C

	thumb_func_start ov68_021E7B94
ov68_021E7B94: ; 0x021E7B94
	push {r4, lr}
	add r4, r0, #0
	bl ov68_021E6CD8
	cmp r0, #4
	bhs _021E7BAC
	add r0, r4, #0
	mov r1, #1
	bl ov68_021E6C14
	mov r1, #0
	b _021E7BB6
_021E7BAC:
	add r0, r4, #0
	mov r1, #4
	bl ov68_021E6C14
	mov r1, #2
_021E7BB6:
	ldr r0, _021E7BC4 ; =0x000001BA
	strb r1, [r4, r0]
	mov r1, #3
	sub r0, #0xa
	str r1, [r4, r0]
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
_021E7BC4: .word 0x000001BA
	thumb_func_end ov68_021E7B94

	thumb_func_start ov68_021E7BC8
ov68_021E7BC8: ; 0x021E7BC8
	push {r3, lr}
	cmp r0, #1
	ldr r0, _021E7BE4 ; =0x04001050
	bne _021E7BDC
	mov r1, #0x1e
	add r2, r1, #0
	sub r2, #0x26
	bl G2x_SetBlendBrightness_
	pop {r3, pc}
_021E7BDC:
	mov r1, #0
	strh r1, [r0]
	pop {r3, pc}
	nop
_021E7BE4: .word 0x04001050
	thumb_func_end ov68_021E7BC8

	.rodata

_021E7BE8:
	.byte 0x01, 0x04, 0x00, 0x00

ov68_021E7BEC: ; 0x021E7BEC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00

ov68_021E7BF8: ; 0x021E7BF8
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00

ov68_021E7C08: ; 0x021E7C08
	.word ov68_021E7614
	.word ov68_021E7614
	.word ov68_021E7618
	.word ov68_021E773C

ov68_021E7C18: ; 0x021E7C18
	.byte 0x0C, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00
	.byte 0x00, 0x40, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00

ov68_021E7C2C: ; 0x021E7C2C
	.byte 0x0B, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov68_021E7C44: ; 0x021E7C44
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x01, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov68_021E7C60: ; 0x021E7C60
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1F, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov68_021E7C7C: ; 0x021E7C7C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov68_021E7C98: ; 0x021E7C98
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x00, 0x00, 0x02, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov68_021E7CB4: ; 0x021E7CB4
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x1C, 0x04, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov68_021E7CD0: ; 0x021E7CD0
	.byte 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00

ov68_021E7CF0: ; 0x021E7CF0
	.byte 0x20, 0x3F, 0x00, 0x7F, 0x40, 0x5F, 0x00, 0x7F, 0x60, 0x7F, 0x00, 0x7F, 0x80, 0x9F, 0x00, 0x7F
	.byte 0xA8, 0xBF, 0x00, 0x27, 0xA8, 0xBF, 0x28, 0x4F, 0xA6, 0xBF, 0xC0, 0xFF, 0xA6, 0xBF, 0x78, 0xB7
	.byte 0xFF, 0x00, 0x00, 0x00

ov68_021E7D14: ; 0x021E7D14
	.byte 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00

ov68_021E7D3C: ; 0x021E7D3C
	.word ov68_021E6D00

ov68_021E7D40: ; 0x021E7D40
	.word ov68_021E6D20
	.word ov68_021E6D40
	.word ov68_021E6D4C
	.word ov68_021E6D58
	.word ov68_021E6D64
	.word ov68_021E6D80
	.word ov68_021E6D9C
	.word ov68_021E6DB8
	.word ov68_021E6DD0

ov68_021E7D64: ; 0x021E7D64
	.byte 0x28, 0x34, 0x00, 0x00, 0x06, 0x01, 0x00, 0x00, 0x50, 0x3C, 0x00, 0x00
	.byte 0x00, 0x02, 0x01, 0x01, 0x28, 0x54, 0x00, 0x00, 0x01, 0x03, 0x02, 0x02, 0x50, 0x5C, 0x00, 0x00
	.byte 0x02, 0x06, 0x03, 0x03, 0x28, 0x74, 0x00, 0x00, 0x04, 0x04, 0x04, 0x04, 0x50, 0x7C, 0x00, 0x00
	.byte 0x05, 0x05, 0x05, 0x05, 0xE0, 0xA8, 0x00, 0x00, 0x03, 0x06, 0x06, 0x06, 0xE0, 0xA8, 0x00, 0x00
	.byte 0x07, 0x07, 0x07, 0x07

ov68_021E7DA4: ; 0x021E7DA4
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00
	.byte 0x07, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00
	.byte 0x0B, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00
	.byte 0x0F, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00
	.byte 0x13, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x15, 0x00, 0x00, 0x00

ov68_021E7DFC: ; 0x021E7DFC
	.byte 0x06, 0x11, 0x04, 0x06
	.byte 0x02, 0x0F, 0x5B, 0x00, 0x06, 0x11, 0x06, 0x06, 0x02, 0x0F, 0x67, 0x00, 0x06, 0x11, 0x08, 0x08
	.byte 0x02, 0x0F, 0x73, 0x00, 0x06, 0x1C, 0x06, 0x03, 0x02, 0x0F, 0x83, 0x00, 0x06, 0x1C, 0x08, 0x03
	.byte 0x02, 0x0F, 0x89, 0x00, 0x06, 0x11, 0x0A, 0x0F, 0x0A, 0x0F, 0x8F, 0x00, 0x04, 0x02, 0x13, 0x1B
	.byte 0x04, 0x0E, 0x25, 0x01, 0x06, 0x01, 0x00, 0x1E, 0x03, 0x0F, 0x91, 0x01, 0x06, 0x0F, 0x15, 0x08
	.byte 0x03, 0x0F, 0xEB, 0x01, 0x06, 0x18, 0x15, 0x08, 0x03, 0x0F, 0x03, 0x02, 0x06, 0x05, 0x04, 0x0A
	.byte 0x10, 0x0F, 0x1B, 0x02, 0x04, 0x17, 0x0D, 0x07, 0x04, 0x0E, 0xBB, 0x02, 0x02, 0x01, 0x00, 0x14
	.byte 0x03, 0x0F, 0x01, 0x00, 0x02, 0x13, 0x05, 0x0A, 0x10, 0x0F, 0x3D, 0x00, 0x02, 0x02, 0x05, 0x09
	.byte 0x08, 0x0F, 0xDD, 0x00

ov68_021E7E74: ; 0x021E7E74
	.byte 0x00, 0x00, 0xA8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00
	.byte 0xA8, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x28, 0x00, 0xA8, 0x00, 0x00, 0x00, 0x04, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00
	.byte 0xA8, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00
	.byte 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0xA8, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0xEC, 0x00, 0x28, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0xA8, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00
	.byte 0xAA, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x16, 0x00, 0x28, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0xAB, 0xB8, 0x00, 0x00, 0xA9, 0xB8, 0x00, 0x00
	.byte 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0x00, 0x48, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0xAC, 0xB8, 0x00, 0x00
	.byte 0xA9, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x16, 0x00, 0x68, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0xAD, 0xB8, 0x00, 0x00, 0xA9, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x16, 0x00, 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0xAE, 0xB8, 0x00, 0x00, 0xA9, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00
	.byte 0xAA, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x86, 0x00, 0x30, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xAF, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00
	.byte 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86, 0x00, 0x50, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0xB0, 0xB8, 0x00, 0x00
	.byte 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86, 0x00, 0x70, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0xB1, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x86, 0x00, 0x90, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0xB2, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00, 0xAA, 0xB8, 0x00, 0x00
	.byte 0xAA, 0xB8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
	; 0x021E80E4
