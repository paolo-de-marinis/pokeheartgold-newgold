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

.public ov18_021F9370
.public ov18_021F94A0
.public ov18_021F94BC
.public ov18_021F9508
.public ov18_021F9518
.public ov18_021F959C

.public ov18_021FBD50

	.text

	.balign 4, 0

.public ov18_021EE35C
.public ov18_021EE388
.public ov18_021EE3AC
.public ov18_021EE44C
.public ov18_021EE520
.public ov18_021EE7DC
.public ov18_021EE834
.public ov18_021EE8B8
.public ov18_021F8824
.public ov18_021F8838
.public ov18_021F95FC
.public ov18_021F9648
.public ov18_021F9F3C

.public ov18_021EE984
.public ov18_021EE9FC
.public ov18_021EEA40
.public ov18_021EEA84
.public ov18_021EEAE4
.public ov18_021EEB34
.public ov18_021EEB94
.public ov18_021EEBE4
.public ov18_021EEC34
.public ov18_021EECB0
.public ov18_021EED00

.public ov18_021F51BC
.public ov18_021F51CC
.public ov18_021F5238
.public ov18_021F52A4
.public ov18_021F5310
.public ov18_021F537C
.public ov18_021F53E8
.public ov18_021F5454
.public ov18_021F5638
.public ov18_021F56DC
.public ov18_021F57B4
.public ov18_021F588C
.public ov18_021F5964
.public ov18_021F5A3C
.public ov18_021F5B14
.public ov18_021F5BEC
.public ov18_021F5CC4
.public ov18_021F6E98
.public ov18_021F6EAC
.public ov18_021F6F78
.public ov18_021F6F8C
.public ov18_021F7060
.public ov18_021F7104
.public ov18_021F71DC
.public ov18_021F7334
.public ov18_021F74B0
.public ov18_021F74C4
.public ov18_021F7634
.public ov18_021F7648
.public ov18_021F7720
.public ov18_021F7734
.public ov18_021F7800
.public ov18_021F7954
.public ov18_021F7B90
.public ov18_021F8F10
.public ov18_021F8FA0
.public ov18_021F91F0
.public ov18_021F95CC
.public ov18_021F9DB0
.public ov18_021F9DC0
.public ov18_021F9DE4
.public ov18_021F9E4C
.public ov18_021F9EBC
.public ov18_021F9FDC
.public ov18_021FA304
.public ov18_021FA310
.public ov18_021FA328
.public ov18_021FA338
.public ov18_021FA348
.public ov18_021FA35A
.public ov18_021FA36C
.public ov18_021FA380
.public ov18_021FA398
.public ov18_021FA3B0
.public ov18_021FA3C8
.public ov18_021FA3E8
.public ov18_021FA41C
.public ov18_021FA450
.public ov18_021FA484
.public ov18_021FA4B8
.public ov18_021FA4EC
.public ov18_021FA520
.public ov18_021FA554
.public ov18_021FA588
.public ov18_021FA5CC
.public ov18_021FA610
.public ov18_021FA7B0
.public ov18_021FA984
.public ov18_021FAB24
.public ov18_021FAB58
.public ov18_021FAB8C
.public ov18_021FABC0
.public ov18_021FABF4
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
.public ov18_021FBDB4

	thumb_func_start ov18_021F8F10
ov18_021F8F10: ; 0x021F8F10
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
	add r5, #0x24
_021F8F18:
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #9
	blo _021F8F18
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F8F10

	thumb_func_start ov18_021F8F28
ov18_021F8F28: ; 0x021F8F28
	push {r3, r4, r5, lr}
	sub sp, #0x10
	ldr r4, _021F8F50 ; =ov18_021FBD50
	add r3, sp, #0
	add r5, r0, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5, #0x14]
	ldr r1, _021F8F54 ; =0x00100010
	str r0, [sp, #0xc]
	add r0, r2, #0
	mov r2, #0x10
	bl ObjCharTransfer_InitEx
	add sp, #0x10
	pop {r3, r4, r5, pc}
	nop
_021F8F50: .word ov18_021FBD50
_021F8F54: .word 0x00100010
	thumb_func_end ov18_021F8F28

	thumb_func_start ov18_021F8F58
ov18_021F8F58: ; 0x021F8F58
	ldr r3, _021F8F5C ; =ObjCharTransfer_Destroy
	bx r3
	.balign 4, 0
_021F8F5C: .word ObjCharTransfer_Destroy
	thumb_func_end ov18_021F8F58

	thumb_func_start ov18_021F8F60
ov18_021F8F60: ; 0x021F8F60
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r7, #0x1e
	mov r4, #0
	add r5, r6, #0
	lsl r7, r7, #4
_021F8F6C:
	ldr r2, [r6, #0x14]
	mov r0, #8
	add r1, r4, #0
	bl Create2DGfxResObjMan
	str r0, [r5, r7]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _021F8F6C
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8F60

	thumb_func_start ov18_021F8F84
ov18_021F8F84: ; 0x021F8F84
	push {r4, r5, r6, lr}
	mov r6, #0x1e
	add r5, r0, #0
	mov r4, #0
	lsl r6, r6, #4
_021F8F8E:
	ldr r0, [r5, r6]
	bl Destroy2DGfxResObjMan
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _021F8F8E
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8F84

	thumb_func_start ov18_021F8FA0
ov18_021F8FA0: ; 0x021F8FA0
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	ldr r2, [r4, #0x14]
	mov r0, #0x20
	add r1, #0xb8
	bl G2dRenderer_Init
	add r1, r4, #0
	add r1, #0xb4
	str r0, [r1]
	ldr r0, [r4, #0x14]
	bl ClearMainOAM
	add r0, r4, #0
	bl ov18_021F8F28
	add r0, r4, #0
	bl ov18_021F8F60
	add r0, r4, #0
	bl ov18_021F8FF8
	add r0, r4, #0
	bl ov18_021F9068
	add r0, r4, #0
	bl ov18_021F9150
	add r0, r4, #0
	bl ov18_021F94BC
	add r0, r4, #0
	bl ov18_021F9370
	add r0, r4, #0
	bl ov18_021F9518
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8FA0

	thumb_func_start ov18_021F8FF8
ov18_021F8FF8: ; 0x021F8FF8
	push {r3, r4, lr}
	sub sp, #0x24
	add r4, r0, #0
	mov r0, #0x1d
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x1e
	str r0, [sp, #8]
	mov r0, #0x1f
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F9050 ; =0x0000C618
	mov r1, #0x7d
	str r0, [sp, #0x14]
	str r0, [sp, #0x18]
	str r0, [sp, #0x1c]
	str r0, [sp, #0x20]
	lsl r1, r1, #2
	add r0, r4, r1
	sub r1, #0x14
	ldr r2, [r4, #0x14]
	ldr r3, [r4, #0x1c]
	add r1, r4, r1
	bl ov18_021F922C
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl SpriteTransfer_GetPlttOffset
	add r2, r0, #0
	lsl r2, r2, #0x14
	ldr r0, [r4, #4]
	mov r1, #2
	lsr r2, r2, #0x10
	mov r3, #0x40
	bl PaletteData_LoadPaletteSlotFromHardware
	add sp, #0x24
	pop {r3, r4, pc}
	nop
_021F9050: .word 0x0000C618
	thumb_func_end ov18_021F8FF8

	thumb_func_start ov18_021F9054
ov18_021F9054: ; 0x021F9054
	mov r1, #0x7d
	add r2, r0, #0
	lsl r1, r1, #2
	add r0, r2, r1
	sub r1, #0x14
	ldr r3, _021F9064 ; =ov18_021F92DC
	add r1, r2, r1
	bx r3
	.balign 4, 0
_021F9064: .word ov18_021F92DC
	thumb_func_end ov18_021F9054

	thumb_func_start ov18_021F9068
ov18_021F9068: ; 0x021F9068
	push {r3, r4, lr}
	sub sp, #0x24
	add r4, r0, #0
	mov r0, #0x93
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ov18_021F967C
	str r0, [sp]
	mov r0, #0x23
	str r0, [sp, #4]
	mov r0, #0x21
	str r0, [sp, #8]
	mov r0, #0x22
	str r0, [sp, #0xc]
	mov r0, #4
	str r0, [sp, #0x10]
	ldr r0, _021F9100 ; =0x0000C619
	mov r1, #0x82
	str r0, [sp, #0x14]
	str r0, [sp, #0x18]
	str r0, [sp, #0x1c]
	str r0, [sp, #0x20]
	lsl r1, r1, #2
	add r0, r4, r1
	sub r1, #0x28
	ldr r2, [r4, #0x14]
	ldr r3, [r4, #0x1c]
	add r1, r4, r1
	bl ov18_021F922C
	mov r0, #0x25
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl ov18_021F967C
	str r0, [sp]
	mov r0, #0
	mvn r0, r0
	str r0, [sp, #4]
	mov r0, #0x21
	str r0, [sp, #8]
	mov r0, #0x22
	str r0, [sp, #0xc]
	mov r0, #4
	str r0, [sp, #0x10]
	ldr r0, _021F9104 ; =0x0000C61A
	mov r1, #0x87
	str r0, [sp, #0x14]
	str r0, [sp, #0x18]
	str r0, [sp, #0x1c]
	str r0, [sp, #0x20]
	lsl r1, r1, #2
	add r0, r4, r1
	sub r1, #0x3c
	ldr r2, [r4, #0x14]
	ldr r3, [r4, #0x1c]
	add r1, r4, r1
	bl ov18_021F922C
	mov r0, #0x83
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl SpriteTransfer_GetPlttOffset
	add r2, r0, #0
	lsl r2, r2, #0x14
	ldr r0, [r4, #4]
	mov r1, #2
	lsr r2, r2, #0x10
	mov r3, #0x80
	bl PaletteData_LoadPaletteSlotFromHardware
	add sp, #0x24
	pop {r3, r4, pc}
	.balign 4, 0
_021F9100: .word 0x0000C619
_021F9104: .word 0x0000C61A
	thumb_func_end ov18_021F9068

	thumb_func_start ov18_021F9108
ov18_021F9108: ; 0x021F9108
	push {r4, lr}
	mov r1, #0x82
	add r4, r0, #0
	lsl r1, r1, #2
	add r0, r4, r1
	sub r1, #0x28
	add r1, r4, r1
	bl ov18_021F92DC
	mov r0, #0x87
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl SpriteTransfer_DeleteCharTransferTask
	mov r1, #0x1e
	lsl r1, r1, #4
	ldr r0, [r4, r1]
	add r1, #0x3c
	ldr r1, [r4, r1]
	bl DestroySingle2DGfxResObj
	mov r1, #0x7a
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	add r1, #0x3c
	ldr r1, [r4, r1]
	bl DestroySingle2DGfxResObj
	mov r1, #0x7b
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	add r1, #0x3c
	ldr r1, [r4, r1]
	bl DestroySingle2DGfxResObj
	pop {r4, pc}
	thumb_func_end ov18_021F9108

	thumb_func_start ov18_021F9150
ov18_021F9150: ; 0x021F9150
	push {r4, r5, lr}
	sub sp, #0x24
	add r5, r0, #0
	bl ov18_021E5900
	ldr r1, [r5, #0x14]
	bl NARC_New
	add r4, r0, #0
	mov r0, #0x4d
	str r0, [sp]
	sub r0, #0x4e
	str r0, [sp, #4]
	mov r0, #0x4e
	str r0, [sp, #8]
	mov r0, #0x4f
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, _021F91D8 ; =0x0000C61B
	mov r1, #0x23
	str r0, [sp, #0x14]
	str r0, [sp, #0x18]
	str r0, [sp, #0x1c]
	str r0, [sp, #0x20]
	lsl r1, r1, #4
	add r0, r5, r1
	sub r1, #0x50
	ldr r2, [r5, #0x14]
	ldr r3, [r5, #0x1c]
	add r1, r5, r1
	bl ov18_021F922C
	bl ov18_021E5908
	add r3, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F91D8 ; =0x0000C61B
	add r2, r4, #0
	str r0, [sp, #4]
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x14]
	bl ov18_021F92AC
	mov r1, #0x8d
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	mov r1, #1
	bl SpriteTransfer_GetPlttOffset
	add r2, r0, #0
	lsl r2, r2, #0x14
	ldr r0, [r5, #4]
	mov r1, #2
	lsr r2, r2, #0x10
	mov r3, #0x20
	bl PaletteData_LoadPaletteSlotFromHardware
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x24
	pop {r4, r5, pc}
	nop
_021F91D8: .word 0x0000C61B
	thumb_func_end ov18_021F9150

	thumb_func_start ov18_021F91DC
ov18_021F91DC: ; 0x021F91DC
	mov r1, #0x23
	add r2, r0, #0
	lsl r1, r1, #4
	add r0, r2, r1
	sub r1, #0x50
	ldr r3, _021F91EC ; =ov18_021F92DC
	add r1, r2, r1
	bx r3
	.balign 4, 0
_021F91EC: .word ov18_021F92DC
	thumb_func_end ov18_021F91DC

	thumb_func_start ov18_021F91F0
ov18_021F91F0: ; 0x021F91F0
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F959C
	add r0, r4, #0
	bl ov18_021F94A0
	add r0, r4, #0
	bl ov18_021F9508
	add r0, r4, #0
	bl ov18_021F91DC
	add r0, r4, #0
	bl ov18_021F9108
	add r0, r4, #0
	bl ov18_021F9054
	add r0, r4, #0
	bl ov18_021F8F84
	bl ov18_021F8F58
	add r4, #0xb4
	ldr r0, [r4]
	bl SpriteList_Delete
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F91F0

	thumb_func_start ov18_021F922C
ov18_021F922C: ; 0x021F922C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [sp, #0x34]
	add r7, r3, #0
	add r6, r2, #0
	add r4, r1, #0
	str r0, [sp]
	mov r3, #1
	str r3, [sp, #4]
	str r6, [sp, #8]
	ldr r0, [r4]
	ldr r2, [sp, #0x20]
	add r1, r7, #0
	bl AddCharResObjFromOpenNarc
	str r0, [r5]
	bl SpriteTransfer_CreateCharTransferTask_AllocAtEnd
	ldr r0, [r5]
	bl sub_0200A740
	mov r0, #0
	ldr r3, [sp, #0x24]
	mvn r0, r0
	cmp r3, r0
	beq _021F9276
	ldr r0, [sp, #0x30]
	add r1, r6, #0
	str r0, [sp]
	ldr r0, [sp, #0x38]
	add r2, r7, #0
	str r0, [sp, #4]
	ldr r0, [r4, #4]
	bl ov18_021F92AC
	str r0, [r5, #4]
_021F9276:
	ldr r0, [sp, #0x3c]
	ldr r2, [sp, #0x28]
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r6, [sp, #8]
	ldr r0, [r4, #8]
	add r1, r7, #0
	mov r3, #1
	bl AddCellOrAnimResObjFromOpenNarc
	str r0, [r5, #8]
	ldr r0, [sp, #0x40]
	ldr r2, [sp, #0x2c]
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	str r6, [sp, #8]
	ldr r0, [r4, #0xc]
	add r1, r7, #0
	mov r3, #1
	bl AddCellOrAnimResObjFromOpenNarc
	str r0, [r5, #0xc]
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F922C

	thumb_func_start ov18_021F92AC
ov18_021F92AC: ; 0x021F92AC
	push {r4, lr}
	sub sp, #0x10
	ldr r4, [sp, #0x1c]
	str r4, [sp]
	mov r4, #1
	str r4, [sp, #4]
	ldr r4, [sp, #0x18]
	str r4, [sp, #8]
	str r1, [sp, #0xc]
	add r1, r2, #0
	add r2, r3, #0
	mov r3, #0
	bl AddPlttResObjFromOpenNarc
	add r4, r0, #0
	bl SpriteTransfer_CreatePlttTransferTask
	add r0, r4, #0
	bl sub_0200A740
	add r0, r4, #0
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F92AC

	thumb_func_start ov18_021F92DC
ov18_021F92DC: ; 0x021F92DC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r4, r1, #0
	bl SpriteTransfer_DeleteCharTransferTask
	ldr r0, [r5, #4]
	bl SpriteTransfer_DeletePlttTransferTask
	ldr r0, [r4]
	ldr r1, [r5]
	bl DestroySingle2DGfxResObj
	ldr r0, [r4, #4]
	ldr r1, [r5, #4]
	bl DestroySingle2DGfxResObj
	ldr r0, [r4, #8]
	ldr r1, [r5, #8]
	bl DestroySingle2DGfxResObj
	ldr r0, [r4, #0xc]
	ldr r1, [r5, #0xc]
	bl DestroySingle2DGfxResObj
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F92DC

	thumb_func_start ov18_021F9310
ov18_021F9310: ; 0x021F9310
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x38
	add r5, r0, #0
	ldr r0, [r5]
	add r4, r1, #0
	add r7, r2, #0
	add r6, r3, #0
	bl GF2DGfxResObj_GetResID
	str r0, [sp, #0x2c]
	ldr r0, [r5, #4]
	bl GF2DGfxResObj_GetResID
	str r0, [sp, #0x30]
	ldr r0, [r5, #8]
	bl GF2DGfxResObj_GetResID
	str r0, [sp, #0x34]
	ldr r0, [r5, #0xc]
	bl GF2DGfxResObj_GetResID
	str r0, [sp]
	mov r0, #0
	mvn r0, r0
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	str r6, [sp, #0x10]
	ldr r1, [r4]
	ldr r2, [sp, #0x30]
	str r1, [sp, #0x14]
	ldr r1, [r4, #4]
	ldr r3, [sp, #0x34]
	str r1, [sp, #0x18]
	ldr r1, [r4, #8]
	str r1, [sp, #0x1c]
	ldr r1, [r4, #0xc]
	str r1, [sp, #0x20]
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
	ldr r1, [sp, #0x2c]
	add r0, r7, #0
	bl CreateSpriteResourcesHeader
	add sp, #0x38
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F9310


	.rodata
	.balign 4, 0

	; file boundary
	.balign 4, 0

	.global ov18_021F9DB0
	.balign 2, 0
ov18_021F9DB0:
	.byte 0x05, 0x02, 0x00, 0x09, 0x02, 0x02
	.short 0x03EE
	.byte 0x01, 0x0A, 0x0A, 0x0F, 0x02, 0x01
	.short 0x01E2
	.size ov18_021F9DB0,.-ov18_021F9DB0
