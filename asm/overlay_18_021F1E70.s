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
.public ov18_021F1620
.public ov18_021F17FC
.public ov18_021F18E0
.public ov18_021F193C
.public ov18_021F19EC
.public ov18_021F1A30
.public ov18_021F1A7C
.public ov18_021F1CAC
.public ov18_021F1CB4
.public ov18_021F1D58
.public ov18_021F1D98
.public ov18_021F1DE4
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
.public ov18_021FA398
.public ov18_021FA3B0
.public ov18_021FA41C
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

	thumb_func_start ov18_021F1E70
ov18_021F1E70: ; 0x021F1E70
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F1F54 ; =0x0000C593
	ldr r1, _021F1F58 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F1F5C ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x24
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F1F60 ; =0x0000C594
	ldr r1, _021F1F58 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F1F5C ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x24
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F1F64 ; =0x0000C595
	ldr r1, _021F1F58 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F1F5C ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x24
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F1F68 ; =0x0000C596
	ldr r1, _021F1F58 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F1F5C ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x24
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F1F5C ; =0x00000854
	ldr r3, _021F1F58 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x23
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #4
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F1F6C ; =0x0000C558
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F1F70 ; =0x0000C555
	ldr r1, _021F1F58 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F1F5C ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x21
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F1F70 ; =0x0000C555
	ldr r1, _021F1F58 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F1F5C ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x22
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	nop
_021F1F54: .word 0x0000C593
_021F1F58: .word 0x00000668
_021F1F5C: .word 0x00000854
_021F1F60: .word 0x0000C594
_021F1F64: .word 0x0000C595
_021F1F68: .word 0x0000C596
_021F1F6C: .word 0x0000C558
_021F1F70: .word 0x0000C555
	thumb_func_end ov18_021F1E70

	thumb_func_start ov18_021F1F74
ov18_021F1F74: ; 0x021F1F74
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F1FC0 ; =0x0000066C
	ldr r1, _021F1FC4 ; =0x0000C593
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1FC0 ; =0x0000066C
	ldr r1, _021F1FC8 ; =0x0000C594
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1FC0 ; =0x0000066C
	ldr r1, _021F1FCC ; =0x0000C595
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1FC0 ; =0x0000066C
	ldr r1, _021F1FD0 ; =0x0000C596
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1FC0 ; =0x0000066C
	ldr r1, _021F1FD4 ; =0x0000C558
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F1FC0 ; =0x0000066C
	ldr r1, _021F1FD8 ; =0x0000C555
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F1FC0 ; =0x0000066C
	ldr r1, _021F1FD8 ; =0x0000C555
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	.balign 4, 0
_021F1FC0: .word 0x0000066C
_021F1FC4: .word 0x0000C593
_021F1FC8: .word 0x0000C594
_021F1FCC: .word 0x0000C595
_021F1FD0: .word 0x0000C596
_021F1FD4: .word 0x0000C558
_021F1FD8: .word 0x0000C555
	thumb_func_end ov18_021F1F74

	thumb_func_start ov18_021F1FDC
ov18_021F1FDC: ; 0x021F1FDC
	push {r3, r4, r5, r6, lr}
	sub sp, #0x34
	ldr r6, _021F207C ; =ov18_021FA41C
	add r4, r0, #0
	add r2, r1, #0
	add r5, sp, #0
	mov r3, #6
_021F1FEA:
	ldmia r6!, {r0, r1}
	stmia r5!, {r0, r1}
	sub r3, r3, #1
	bne _021F1FEA
	ldr r0, [r6]
	ldr r1, _021F2080 ; =0x00000668
	str r0, [r5]
	ldr r0, [r4, r1]
	add r1, r1, #4
	mov r3, #2
	lsl r5, r2, #2
	ldr r1, [r4, r1]
	add r2, sp, #0
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	mov r1, #0x67
	mov r3, #2
	add r2, r4, r5
	lsl r1, r1, #4
	str r0, [r2, r1]
	ldr r0, _021F2084 ; =0x0000C595
	add r2, sp, #0
	str r0, [sp, #0x14]
	add r0, r1, #0
	sub r0, #8
	sub r1, r1, #4
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	mov r3, #2
	ldr r1, _021F2088 ; =0x00000678
	add r2, r4, r5
	str r0, [r2, r1]
	add r2, sp, #0
	mov r0, #0
	ldrsh r0, [r2, r0]
	lsl r3, r3, #0x14
	add r0, #0x31
	strh r0, [r2]
	ldr r0, _021F208C ; =0x0000C594
	add r2, sp, #0
	str r0, [sp, #0x14]
	add r0, r1, #0
	sub r0, #0x10
	sub r1, #0xc
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	bl SpriteSystem_NewSpriteWithYOffset
	mov r3, #2
	ldr r1, _021F2090 ; =0x00000674
	add r2, r4, r5
	str r0, [r2, r1]
	ldr r0, _021F2094 ; =0x0000C596
	add r2, sp, #0
	str r0, [sp, #0x14]
	add r0, r1, #0
	sub r0, #0xc
	sub r1, #8
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F2098 ; =0x0000067C
	add r2, r4, r5
	str r0, [r2, r1]
	add sp, #0x34
	pop {r3, r4, r5, r6, pc}
	nop
_021F207C: .word ov18_021FA41C
_021F2080: .word 0x00000668
_021F2084: .word 0x0000C595
_021F2088: .word 0x00000678
_021F208C: .word 0x0000C594
_021F2090: .word 0x00000674
_021F2094: .word 0x0000C596
_021F2098: .word 0x0000067C
	thumb_func_end ov18_021F1FDC
