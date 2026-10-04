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
.public ov18_021F111C
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
.public ov18_021F1598
.public ov18_021F8CCC
.public ov18_021F8F10
.public ov18_021F8FA0
.public ov18_021F91F0
.public ov18_021F95CC
.public ov18_021FA304
.public ov18_021FA310
.public ov18_021FA328
.public ov18_021FA338
.public ov18_021FA348
.public ov18_021FA35A
.public ov18_021FA398
.public ov18_021FA3B0
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

	.text

	thumb_func_start ov18_021F1CB4
ov18_021F1CB4: ; 0x021F1CB4
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r5, r0, #0
	bl ov18_021E5900
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F1D44 ; =0x0000C599
	ldr r1, _021F1D48 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F1D4C ; =0x00000854
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	mov r3, #0x4d
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	bl ov18_021E5908
	str r4, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F1D50 ; =0x0000C55B
	ldr r3, _021F1D48 ; =0x00000668
	str r0, [sp, #0x14]
	mov r0, #0x85
	lsl r0, r0, #4
	ldr r2, [r5, r3]
	add r3, r3, #4
	ldr r0, [r5, r0]
	ldr r3, [r5, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBuffer
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F1D54 ; =0x0000C558
	ldr r1, _021F1D48 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F1D4C ; =0x00000854
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	mov r3, #0x4e
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F1D54 ; =0x0000C558
	ldr r1, _021F1D48 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F1D4C ; =0x00000854
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	mov r3, #0x4f
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_021F1D44: .word 0x0000C599
_021F1D48: .word 0x00000668
_021F1D4C: .word 0x00000854
_021F1D50: .word 0x0000C55B
_021F1D54: .word 0x0000C558
	thumb_func_end ov18_021F1CB4

	thumb_func_start ov18_021F1D58
ov18_021F1D58: ; 0x021F1D58
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F1D88 ; =0x0000066C
	ldr r1, _021F1D8C ; =0x0000C599
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1D88 ; =0x0000066C
	ldr r1, _021F1D90 ; =0x0000C55B
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F1D88 ; =0x0000066C
	ldr r1, _021F1D94 ; =0x0000C558
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F1D88 ; =0x0000066C
	ldr r1, _021F1D94 ; =0x0000C558
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	nop
_021F1D88: .word 0x0000066C
_021F1D8C: .word 0x0000C599
_021F1D90: .word 0x0000C55B
_021F1D94: .word 0x0000C558
	thumb_func_end ov18_021F1D58

	thumb_func_start ov18_021F1D98
ov18_021F1D98: ; 0x021F1D98
	push {r4, r5, r6, lr}
	mov r2, #0x67
	lsl r2, r2, #4
	add r6, r0, #0
	add r0, r2, #0
	lsl r4, r1, #2
	sub r0, #8
	sub r1, r2, #4
	add r5, r6, r2
	mov r3, #2
	ldr r0, [r6, r0]
	ldr r1, [r6, r1]
	ldr r2, _021F1DD8 ; =ov18_021FA450
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	str r0, [r5, r4]
	ldr r0, _021F1DDC ; =0x0000066C
	ldr r1, _021F1DE0 ; =0x0000C55B
	ldr r0, [r6, r0]
	mov r2, #2
	bl SpriteManager_FindPlttResourceOffset
	add r1, r0, #0
	ldr r0, [r5, r4]
	bl ManagedSprite_SetPaletteOverride
	ldr r0, [r5, r4]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F1DD8: .word ov18_021FA450
_021F1DDC: .word 0x0000066C
_021F1DE0: .word 0x0000C55B
	thumb_func_end ov18_021F1D98
