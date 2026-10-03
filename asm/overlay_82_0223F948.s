	.include "asm/macros.inc"
	.include "overlay_82.inc"
	.include "global.inc"

	.text

	thumb_func_start ov82_0223F948
ov82_0223F948: ; 0x0223F948
	ldr r3, _0223F954 ; =G2x_SetBlendBrightness_
	add r2, r0, #0
	ldr r0, _0223F958 ; =0x04000050
	mov r1, #0x1e
	bx r3
	nop
_0223F954: .word G2x_SetBlendBrightness_
_0223F958: .word 0x04000050
	thumb_func_end ov82_0223F948

	thumb_func_start ov82_0223F95C
ov82_0223F95C: ; 0x0223F95C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	str r1, [sp, #0x14]
	bl ov82_0223FC14
	bl NNS_G2dInitOamManagerModule
	mov r0, #0
	str r0, [sp]
	mov r1, #0x80
	str r1, [sp, #4]
	str r0, [sp, #8]
	mov r3, #0x20
	str r3, [sp, #0xc]
	mov r2, #0x69
	str r2, [sp, #0x10]
	add r2, r0, #0
	bl OamManager_Create
	mov r0, #2
	add r1, r5, #4
	mov r2, #0x69
	bl G2dRenderer_Init
	ldr r4, _0223FB04 ; =ov82_0223FEEC
	str r0, [r5]
	mov r7, #0
	add r6, r5, #0
_0223F996:
	ldrb r0, [r4]
	add r1, r7, #0
	mov r2, #0x69
	bl Create2DGfxResObjMan
	mov r1, #0x4b
	lsl r1, r1, #2
	str r0, [r6, r1]
	add r7, r7, #1
	add r4, r4, #1
	add r6, r6, #4
	cmp r7, #4
	blt _0223F996
	mov r0, #0
	str r0, [sp]
	mov r3, #1
	str r3, [sp, #4]
	mov r0, #0x69
	str r0, [sp, #8]
	add r0, #0xc3
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0xc
	bl AddCharResObjFromNarc
	mov r1, #0x4f
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r3, #0
	str r3, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x69
	str r0, [sp, #0xc]
	add r0, #0xc7
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0x36
	bl AddPlttResObjFromNarc
	mov r1, #5
	lsl r1, r1, #6
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x69
	str r0, [sp, #8]
	add r0, #0xcb
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0xe
	mov r3, #1
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x51
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x69
	str r0, [sp, #8]
	add r0, #0xcf
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0xd
	mov r3, #1
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x52
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0x14
	mov r1, #0x69
	bl NARC_New
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x14]
	bl Pokemon_GetIconNaix
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x69
	str r0, [sp, #8]
	add r0, #0xc3
	ldr r0, [r5, r0]
	ldr r1, [sp, #0x18]
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	mov r1, #0x53
	lsl r1, r1, #2
	str r0, [r5, r1]
	bl sub_02074490
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	mov r0, #0x69
	str r0, [sp, #0xc]
	add r0, #0xc7
	ldr r0, [r5, r0]
	mov r1, #0x14
	mov r3, #0
	bl AddPlttResObjFromNarc
	mov r1, #0x15
	lsl r1, r1, #4
	str r0, [r5, r1]
	bl sub_02074498
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x69
	str r0, [sp, #8]
	add r0, #0xcb
	ldr r0, [r5, r0]
	ldr r1, [sp, #0x18]
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x55
	lsl r1, r1, #2
	str r0, [r5, r1]
	bl sub_020744A4
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x69
	str r0, [sp, #8]
	add r0, #0xcf
	ldr r0, [r5, r0]
	ldr r1, [sp, #0x18]
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x56
	lsl r1, r1, #2
	add r7, r1, #0
	add r6, r1, #0
	str r0, [r5, r1]
	mov r4, #0
	sub r7, #0x1c
	sub r6, #0x18
_0223FAD4:
	ldr r0, [r5, r7]
	bl SpriteTransfer_CreateCharTransferTask
	ldr r0, [r5, r6]
	bl SpriteTransfer_CreateExtPlttTransferTask
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #2
	blt _0223FAD4
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	ldr r0, [sp, #0x18]
	bl NARC_Delete
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_0223FB04: .word ov82_0223FEEC
	thumb_func_end ov82_0223F95C

	thumb_func_start ov82_0223FB08
ov82_0223FB08: ; 0x0223FB08
	push {r4, r5, r6, lr}
	sub sp, #0x80
	add r5, r0, #0
	mov r0, #0
	str r1, [sp]
	mvn r0, r0
	str r0, [sp, #4]
	add r4, r3, #0
	str r0, [sp, #8]
	mov r3, #0
	str r3, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	mov r0, #0x4b
	lsl r0, r0, #2
	add r6, r2, #0
	ldr r2, [r5, r0]
	str r2, [sp, #0x14]
	add r2, r0, #4
	ldr r2, [r5, r2]
	str r2, [sp, #0x18]
	add r2, r0, #0
	add r2, #8
	ldr r2, [r5, r2]
	add r0, #0xc
	str r2, [sp, #0x1c]
	ldr r0, [r5, r0]
	add r2, r1, #0
	str r0, [sp, #0x20]
	str r3, [sp, #0x24]
	str r3, [sp, #0x28]
	add r0, sp, #0x5c
	add r3, r1, #0
	bl CreateSpriteResourcesHeader
	ldr r0, [r5]
	mov r1, #0
	str r0, [sp, #0x2c]
	add r0, sp, #0x5c
	str r0, [sp, #0x30]
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [sp, #0x34]
	str r1, [sp, #0x38]
	str r1, [sp, #0x3c]
	str r0, [sp, #0x40]
	str r0, [sp, #0x44]
	str r0, [sp, #0x48]
	add r0, sp, #0x2c
	strh r1, [r0, #0x20]
	str r4, [sp, #0x50]
	add r0, sp, #0x80
	ldrb r0, [r0, #0x10]
	cmp r0, #0
	bne _0223FB7C
	mov r0, #1
	str r0, [sp, #0x54]
	b _0223FB80
_0223FB7C:
	mov r0, #2
	str r0, [sp, #0x54]
_0223FB80:
	mov r0, #0x69
	str r0, [sp, #0x58]
	add r0, sp, #0x80
	ldrb r0, [r0, #0x10]
	cmp r0, #1
	bne _0223FB96
	mov r0, #3
	ldr r1, [sp, #0x38]
	lsl r0, r0, #0x12
	add r0, r1, r0
	str r0, [sp, #0x38]
_0223FB96:
	add r0, sp, #0x2c
	bl Sprite_CreateAffine
	mov r1, #1
	add r4, r0, #0
	bl Sprite_SetAnimActiveFlag
	mov r1, #1
	add r0, r4, #0
	lsl r1, r1, #0xc
	bl Sprite_SetAnimSpeed
	add r0, r4, #0
	add r1, r6, #0
	bl Sprite_SetAnimCtrlSeq
	add r0, r4, #0
	add sp, #0x80
	pop {r4, r5, r6, pc}
	thumb_func_end ov82_0223FB08

	thumb_func_start ov82_0223FBBC
ov82_0223FBBC: ; 0x0223FBBC
	push {r3, r4, r5, r6, r7, lr}
	mov r7, #5
	add r5, r0, #0
	mov r4, #0
	lsl r7, r7, #6
_0223FBC6:
	lsl r0, r4, #4
	add r6, r5, r0
	mov r0, #0x4f
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl SpriteTransfer_DeleteCharTransferTask
	ldr r0, [r6, r7]
	bl SpriteTransfer_DeletePlttTransferTask
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #2
	blo _0223FBC6
	mov r6, #0x4b
	mov r4, #0
	lsl r6, r6, #2
_0223FBEA:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl Destroy2DGfxResObjMan
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _0223FBEA
	ldr r0, [r5]
	bl SpriteList_Delete
	bl OamManager_Free
	bl ObjCharTransfer_Destroy
	bl ObjPlttTransfer_Destroy
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov82_0223FBBC

	thumb_func_start ov82_0223FC14
ov82_0223FC14: ; 0x0223FC14
	push {r4, lr}
	sub sp, #0x10
	ldr r4, _0223FC44 ; =ov82_0223FEF0
	add r3, sp, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	mov r1, #0x10
	add r0, r2, #0
	add r2, r1, #0
	bl ObjCharTransfer_InitEx
	mov r0, #4
	mov r1, #0x69
	bl ObjPlttTransfer_Init
	bl ObjCharTransfer_ClearBuffers
	bl ObjPlttTransfer_Reset
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_0223FC44: .word ov82_0223FEF0
	thumb_func_end ov82_0223FC14

	thumb_func_start ov82_0223FC48
ov82_0223FC48: ; 0x0223FC48
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r0, #0
	add r7, r1, #0
	mov r0, #0x69
	mov r1, #0x14
	str r2, [sp, #4]
	add r5, r3, #0
	bl Heap_Alloc
	add r4, r0, #0
	add r2, r4, #0
	mov r1, #0x14
	mov r0, #0
_0223FC64:
	strb r0, [r2]
	add r2, r2, #1
	sub r1, r1, #1
	bne _0223FC64
	ldr r0, [sp, #0x2c]
	mov r3, #0
	str r0, [r4, #0xc]
	ldr r2, [sp, #4]
	str r3, [sp]
	add r0, r6, #0
	add r1, r7, #0
	bl ov82_0223FB08
	str r0, [r4, #0x10]
	lsl r0, r5, #0xc
	str r0, [sp, #8]
	add r0, sp, #0x18
	ldrh r0, [r0, #0x10]
	add r1, sp, #8
	lsl r0, r0, #0xc
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x10]
	bl Sprite_SetMatrix
	add r0, r4, #0
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov82_0223FC48

	thumb_func_start ov82_0223FC9C
ov82_0223FC9C: ; 0x0223FC9C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x10]
	bl Sprite_Delete
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov82_0223FC9C

	thumb_func_start ov82_0223FCB0
ov82_0223FCB0: ; 0x0223FCB0
	ldr r3, _0223FCB8 ; =Sprite_SetDrawFlag
	ldr r0, [r0, #0x10]
	bx r3
	nop
_0223FCB8: .word Sprite_SetDrawFlag
	thumb_func_end ov82_0223FCB0

	thumb_func_start ov82_0223FCBC
ov82_0223FCBC: ; 0x0223FCBC
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r1, #0
	ldr r1, [r5, #0xc]
	add r6, r2, #0
	cmp r1, #0
	beq _0223FCD4
	ldrb r1, [r1]
	ldr r0, [r5, #0x10]
	bl Sprite_TryChangeAnimSeq
_0223FCD4:
	ldr r0, [r5, #0x10]
	bl Sprite_GetMatrixPtr
	add r3, r0, #0
	add r2, sp, #0
	ldmia r3!, {r0, r1}
	add r7, r2, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	add r1, r7, #0
	str r0, [r2]
	lsl r0, r4, #0xc
	str r0, [sp]
	lsl r0, r6, #0xc
	str r0, [sp, #4]
	ldr r0, [r5, #0x10]
	bl Sprite_SetMatrix
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov82_0223FCBC

	thumb_func_start ov82_0223FCFC
ov82_0223FCFC: ; 0x0223FCFC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r1, #1
	ldr r0, [r5, #0x10]
	lsl r1, r1, #0xc
	bl Sprite_SetAnimSpeed
	ldr r0, [r5, #0x10]
	add r1, r4, #0
	bl Sprite_TryChangeAnimSeq
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov82_0223FCFC

	thumb_func_start ov82_0223FD18
ov82_0223FD18: ; 0x0223FD18
	push {r4, lr}
	add r4, r0, #0
	add r0, r1, #0
	bl Pokemon_GetIconPalette
	add r1, r0, #0
	ldr r0, [r4, #0x10]
	bl Sprite_SetPalOffsetRespectVramOffset
	pop {r4, pc}
	thumb_func_end ov82_0223FD18

	thumb_func_start ov82_0223FD2C
ov82_0223FD2C: ; 0x0223FD2C
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r5, r1, #0
	mov r4, #0
_0223FD34:
	ldr r2, _0223FD58 ; =ov82_0223FF00
	lsl r6, r4, #4
	lsl r3, r4, #3
	add r0, r7, #0
	add r1, r5, r6
	add r2, r2, r3
	bl AddWindow
	add r0, r5, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _0223FD34
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0223FD58: .word ov82_0223FF00
	thumb_func_end ov82_0223FD2C

	thumb_func_start ov82_0223FD5C
ov82_0223FD5C: ; 0x0223FD5C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
_0223FD62:
	lsl r0, r4, #4
	add r0, r5, r0
	bl RemoveWindow
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #4
	blo _0223FD62
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov82_0223FD5C

	thumb_func_start ov82_0223FD78
ov82_0223FD78: ; 0x0223FD78
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r1, #0
	add r4, r0, #0
	bl GetWindowBgId
	add r1, r0, #0
	lsl r0, r5, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x69
	str r0, [sp, #4]
	ldr r0, [r4]
	ldr r2, _0223FDB4 ; =0x000003D9
	mov r3, #0xa
	bl LoadUserFrameGfx2
	add r0, r4, #0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r2, _0223FDB4 ; =0x000003D9
	add r0, r4, #0
	mov r1, #0
	mov r3, #0xa
	bl DrawFrameAndWindow2
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_0223FDB4: .word 0x000003D9
	thumb_func_end ov82_0223FD78

	thumb_func_start ov82_0223FDB8
ov82_0223FDB8: ; 0x0223FDB8
	ldr r3, _0223FDBC ; =YesNoPrompt_Create
	bx r3
	.balign 4, 0
_0223FDBC: .word YesNoPrompt_Create
	thumb_func_end ov82_0223FDB8

	thumb_func_start ov82_0223FDC0
ov82_0223FDC0: ; 0x0223FDC0
	ldr r3, _0223FDC4 ; =YesNoPrompt_Destroy
	bx r3
	.balign 4, 0
_0223FDC4: .word YesNoPrompt_Destroy
	thumb_func_end ov82_0223FDC0

	thumb_func_start ov82_0223FDC8
ov82_0223FDC8: ; 0x0223FDC8
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r6, r0, #0
	add r5, r1, #0
	add r4, r2, #0
	add r0, sp, #0
	mov r1, #0
	mov r2, #0x14
	bl MI_CpuFill8
	mov r0, #0x6d
	mov r2, #0
	str r0, [sp, #8]
	mov r0, #0xe
	str r0, [sp, #0xc]
	str r5, [sp]
	str r2, [sp, #4]
	mov r1, #0x18
	add r0, sp, #0
	strb r1, [r0, #0x10]
	mov r1, #0xa
	strb r1, [r0, #0x11]
	ldrb r1, [r0, #0x12]
	mov r3, #0xf
	bic r1, r3
	mov r3, #0xf
	and r3, r4
	orr r1, r3
	strb r1, [r0, #0x12]
	ldrb r3, [r0, #0x12]
	mov r1, #0xf0
	bic r3, r1
	strb r3, [r0, #0x12]
	strb r2, [r0, #0x13]
	add r0, r6, #0
	add r1, sp, #0
	bl YesNoPrompt_InitFromTemplate
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov82_0223FDC8

	thumb_func_start ov82_0223FE18
ov82_0223FE18: ; 0x0223FE18
	ldr r3, _0223FE1C ; =YesNoPrompt_HandleInput
	bx r3
	.balign 4, 0
_0223FE1C: .word YesNoPrompt_HandleInput
	thumb_func_end ov82_0223FE18
