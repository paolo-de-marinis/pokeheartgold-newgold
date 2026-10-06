	.include "asm/macros.inc"
	.include "overlay_27.inc"
	.include "global.inc"

.public ov27_0225A320
.public ov27_0225A690
.public ov27_0225A714
.public ov27_0225A7FC
.public ov27_0225AC00
.public ov27_0225AD0C
.public ov27_0225B010
.public ov27_0225BB6C
.public ov27_0225BC84
.public ov27_0225BCE8
.public ov27_0225BD50
.public ov27_0225BDDC
.public ov27_0225C0E0
.public ov27_0225C10C
.public ov27_0225C1AC
.public ov27_0225C1EC
.public ov27_0225D000
.public ov27_0225D01C

	.text

	thumb_func_start ov27_02259F80
ov27_02259F80: ; 0x02259F80
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r2, #0
	add r6, r0, #0
	str r1, [sp, #0x10]
	ldr r2, _0225A170 ; =0x00018D00
	mov r0, #3
	mov r1, #8
	bl Heap_Create
	mov r0, #0
	bl GXS_SetGraphicsMode
	mov r0, #0x80
	bl GX_SetBankForSubBG
	mov r0, #1
	lsl r0, r0, #8
	bl GX_SetBankForSubOBJ
	ldr r2, _0225A174 ; =0x04001000
	ldr r0, _0225A178 ; =0xFFCFFFEF
	ldr r1, [r2]
	mov r3, #0
	and r1, r0
	mov r0, #0x10
	orr r0, r1
	str r0, [r2]
	ldr r2, _0225A17C ; =ov27_0225D000
	add r0, r6, #0
	mov r1, #4
	bl InitBgFromTemplate
	ldr r2, _0225A180 ; =ov27_0225D01C
	add r0, r6, #0
	mov r1, #5
	mov r3, #0
	bl InitBgFromTemplate
	mov r1, #0x15
	ldr r0, _0225A184 ; =ov27_0225A320
	lsl r1, r1, #6
	mov r2, #0xa
	mov r3, #8
	bl CreateSysTaskAndEnvironment
	add r7, r0, #0
	bl SysTask_GetData
	add r4, r0, #0
	str r7, [r4, #8]
	mov r0, #0
	str r0, [r4]
	ldr r0, [sp, #0x10]
	str r6, [r4, #4]
	str r0, [r4, #0xc]
	add r0, r5, #0
	str r5, [r4, #0x10]
	bl ov27_0225BD50
	ldr r3, _0225A188 ; =0x0000051C
	add r2, r0, #0
	ldr r1, [r4, r3]
	mov r0, #0x1e
	bic r1, r0
	lsl r0, r2, #0x1c
	lsr r0, r0, #0x1b
	orr r0, r1
	str r0, [r4, r3]
	ldr r1, [r4, r3]
	mov r0, #0x20
	bic r1, r0
	str r1, [r4, r3]
	mov r3, #0x3f
	lsl r3, r3, #4
	add r0, r4, r3
	str r0, [sp]
	add r2, r3, #0
	sub r2, #0x20
	sub r3, #0x10
	ldr r1, [r4]
	add r0, r6, #0
	add r2, r4, r2
	add r3, r4, r3
	bl ov27_0225AC00
	mov r0, #4
	mov r1, #8
	bl FontID_Alloc
	mov r0, #8
	bl MessageFormat_New
	ldr r1, _0225A18C ; =0x000004AC
	mov r2, #0xc4
	str r0, [r4, r1]
	mov r0, #0
	mov r1, #0x1b
	mov r3, #8
	bl NewMsgDataFromNarc
	ldr r1, _0225A190 ; =0x000004A8
	str r0, [r4, r1]
	add r0, r4, #0
	bl ov27_0225C10C
	add r1, r5, #0
	add r1, #0xd3
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov27_0225C1AC
	str r0, [r4, #0x14]
	add r0, r4, #0
	bl ov27_0225C1EC
	add r0, r4, #0
	bl ov27_0225AD0C
	add r0, r4, #0
	bl ov27_0225B010
	ldr r1, [r4, #0x10]
	add r0, r4, #0
	add r1, #0xd2
	ldrb r1, [r1]
	lsl r1, r1, #0x1a
	lsr r1, r1, #0x1a
	bl ov27_0225BB6C
	mov r3, #0
	str r3, [sp]
	mov r2, #0x3d
	ldr r0, _0225A194 ; =0x000F0100
	str r3, [sp, #4]
	str r0, [sp, #8]
	lsl r2, r2, #4
	add r0, r4, r2
	str r3, [sp, #0xc]
	add r2, #0xe4
	ldr r2, [r4, r2]
	mov r1, #4
	bl AddTextPrinterParameterizedWithColor
	mov r1, #0
	mov r2, #0x3e
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0225A194 ; =0x000F0100
	lsl r2, r2, #4
	str r0, [sp, #8]
	add r0, r4, r2
	str r1, [sp, #0xc]
	add r2, #0xe4
	ldr r2, [r4, r2]
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl ov27_0225BCE8
	add r0, r4, #0
	bl ov27_0225BC84
	add r0, r4, #0
	mov r1, #1
	bl ov27_0225A690
	add r0, r4, #0
	bl ov27_0225C0E0
	mov r0, #0x52
	lsl r0, r0, #4
	add r0, r4, r0
	add r1, r4, #0
	bl ov27_0225BDDC
	mov r0, #0x43
	lsl r0, r0, #2
	add r0, r5, r0
	bl MenuInputStateMgr_GetState
	cmp r0, #0
	bne _0225A102
	add r0, r5, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x80
	add r5, #0xd2
	bic r1, r0
	strb r1, [r5]
	b _0225A11A
_0225A102:
	add r0, r5, #0
	bl FieldSystem_TaskIsRunning
	cmp r0, #0
	bne _0225A11A
	add r0, r5, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x80
	add r5, #0xd2
	orr r0, r1
	strb r0, [r5]
_0225A11A:
	add r0, r4, #0
	bl ov27_0225A714
	cmp r0, #0
	bne _0225A12A
	add sp, #0x14
	add r0, r7, #0
	pop {r4, r5, r6, r7, pc}
_0225A12A:
	add r0, r4, #0
	bl ov27_0225A7FC
	ldr r0, [r4, #0x18]
	bl SpriteList_RenderAndAnimateSprites
	ldr r2, _0225A174 ; =0x04001000
	ldr r0, _0225A198 ; =0xFFFF1FFF
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #2
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r7, #0
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0225A170: .word 0x00018D00
_0225A174: .word 0x04001000
_0225A178: .word 0xFFCFFFEF
_0225A17C: .word ov27_0225D000
_0225A180: .word ov27_0225D01C
_0225A184: .word ov27_0225A320
_0225A188: .word 0x0000051C
_0225A18C: .word 0x000004AC
_0225A190: .word 0x000004A8
_0225A194: .word 0x000F0100
_0225A198: .word 0xFFFF1FFF
	thumb_func_end ov27_02259F80
