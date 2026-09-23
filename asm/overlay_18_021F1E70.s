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

	thumb_func_start ov18_021F209C
ov18_021F209C: ; 0x021F209C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r1, #0
	ldr r1, _021F21E4 ; =0x0000185C
	add r5, r0, #0
	ldrb r0, [r5, r1]
	add r4, r3, #0
	cmp r0, #2
	bne _021F20BE
	cmp r6, #0
	beq _021F20BE
	lsl r0, r2, #2
	add r2, r5, r0
	ldr r0, _021F21E8 ; =0x00001032
	ldrh r0, [r2, r0]
	cmp r0, #1
	bne _021F20F6
_021F20BE:
	lsl r4, r4, #2
	mov r0, #0x67
	add r1, r5, r4
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F21EC ; =0x00000674
	add r1, r5, r4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F21F0 ; =0x00000678
	add r1, r5, r4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F21F4 ; =0x0000067C
	add r1, r5, r4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_021F20F6:
	add r0, r1, #3
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1c
	bne _021F2120
	lsl r7, r4, #2
	mov r0, #0x67
	add r1, r5, r7
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F21EC ; =0x00000674
	add r1, r5, r7
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r4, r4, #2
	b _021F213A
_021F2120:
	lsl r7, r4, #2
	ldr r0, _021F21F0 ; =0x00000678
	add r1, r5, r7
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F21F4 ; =0x0000067C
	add r1, r5, r7
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
_021F213A:
	ldr r0, _021F21F8 ; =0x0000185F
	mov r2, #0xf0
	ldrb r3, [r5, r0]
	add r1, r3, #0
	bic r1, r2
	lsl r2, r3, #0x18
	lsr r3, r2, #0x1c
	mov r2, #1
	eor r2, r3
	lsl r2, r2, #0x18
	lsr r2, r2, #0x18
	lsl r2, r2, #0x1c
	lsr r2, r2, #0x18
	orr r1, r2
	strb r1, [r5, r0]
	ldr r0, [r5]
	add r1, r6, #0
	ldr r0, [r0]
	mov r2, #0
	bl Pokedex_GetSeenFormByIdx
	add r7, r0, #0
	cmp r6, #0xac
	bne _021F2174
	cmp r7, #2
	bne _021F2172
	mov r7, #1
	b _021F2174
_021F2172:
	mov r7, #0
_021F2174:
	add r0, r6, #0
	add r1, r7, #0
	mov r2, #6
	bl GetMonBaseStat_HandleAlternateForm
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #4]
	ldr r2, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F21FC
	lsl r0, r4, #2
	str r0, [sp]
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r6, #0
	add r1, r7, #0
	mov r2, #7
	bl GetMonBaseStat_HandleAlternateForm
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	beq _021F21B6
	ldr r0, [sp, #4]
	cmp r0, r2
	bne _021F21C8
_021F21B6:
	ldr r0, [sp]
	add r1, r5, r0
	ldr r0, _021F21EC ; =0x00000674
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_021F21C8:
	add r0, r5, #0
	add r1, r4, #1
	bl ov18_021F21FC
	ldr r0, [sp]
	add r1, r5, r0
	ldr r0, _021F21EC ; =0x00000674
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F21E4: .word 0x0000185C
_021F21E8: .word 0x00001032
_021F21EC: .word 0x00000674
_021F21F0: .word 0x00000678
_021F21F4: .word 0x0000067C
_021F21F8: .word 0x0000185F
	thumb_func_end ov18_021F209C

	thumb_func_start ov18_021F21FC
ov18_021F21FC: ; 0x021F21FC
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r2, #0
	add r4, r1, #0
	str r2, [sp, #4]
	bl ov18_021F967C
	add r1, r0, #0
	mov r0, #0x25
	str r0, [sp]
	ldr r0, _021F2264 ; =0x00000854
	mov r2, #1
	ldr r0, [r5, r0]
	add r3, sp, #8
	bl GfGfxLoader_GetCharDataFromOpenNarc
	add r7, r0, #0
	mov r0, #2
	str r0, [sp]
	ldr r2, [sp, #8]
	mov r3, #6
	ldr r2, [r2, #0x14]
	add r0, r5, #0
	add r1, r4, #0
	lsl r3, r3, #6
	bl ov18_021F111C
	ldr r0, _021F2268 ; =0x0000066C
	ldr r1, _021F226C ; =0x0000C558
	ldr r0, [r5, r0]
	mov r2, #2
	bl SpriteManager_FindPlttResourceOffset
	add r6, r0, #0
	ldr r0, [sp, #4]
	bl ov18_021F9688
	add r1, r0, #0
	lsl r0, r4, #2
	add r2, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	add r1, r6, r1
	bl ManagedSprite_SetPaletteOverride
	add r0, r7, #0
	bl Heap_Free
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F2264: .word 0x00000854
_021F2268: .word 0x0000066C
_021F226C: .word 0x0000C558
	thumb_func_end ov18_021F21FC

	thumb_func_start ov18_021F2270
ov18_021F2270: ; 0x021F2270
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F22F4 ; =0x0000C597
	ldr r1, _021F22F8 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F22FC ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x35
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F22FC ; =0x00000854
	ldr r3, _021F22F8 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x38
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, _021F2300 ; =0x0000C559
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F2304 ; =0x0000C556
	ldr r1, _021F22F8 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F22FC ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x36
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F2304 ; =0x0000C556
	ldr r1, _021F22F8 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F22FC ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x37
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_021F22F4: .word 0x0000C597
_021F22F8: .word 0x00000668
_021F22FC: .word 0x00000854
_021F2300: .word 0x0000C559
_021F2304: .word 0x0000C556
	thumb_func_end ov18_021F2270

	thumb_func_start ov18_021F2308
ov18_021F2308: ; 0x021F2308
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F2338 ; =0x0000066C
	ldr r1, _021F233C ; =0x0000C597
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F2338 ; =0x0000066C
	ldr r1, _021F2340 ; =0x0000C559
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F2338 ; =0x0000066C
	ldr r1, _021F2344 ; =0x0000C556
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F2338 ; =0x0000066C
	ldr r1, _021F2344 ; =0x0000C556
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	nop
_021F2338: .word 0x0000066C
_021F233C: .word 0x0000C597
_021F2340: .word 0x0000C559
_021F2344: .word 0x0000C556
	thumb_func_end ov18_021F2308

	thumb_func_start ov18_021F2348
ov18_021F2348: ; 0x021F2348
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F23D0 ; =0x0000C598
	ldr r1, _021F23D4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F23D8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x35
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F23D8 ; =0x00000854
	ldr r3, _021F23D4 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x38
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F23DC ; =0x0000C55A
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F23E0 ; =0x0000C557
	ldr r1, _021F23D4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F23D8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x36
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F23E0 ; =0x0000C557
	ldr r1, _021F23D4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F23D8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x37
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_021F23D0: .word 0x0000C598
_021F23D4: .word 0x00000668
_021F23D8: .word 0x00000854
_021F23DC: .word 0x0000C55A
_021F23E0: .word 0x0000C557
	thumb_func_end ov18_021F2348

	thumb_func_start ov18_021F23E4
ov18_021F23E4: ; 0x021F23E4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F2414 ; =0x0000066C
	ldr r1, _021F2418 ; =0x0000C598
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F2414 ; =0x0000066C
	ldr r1, _021F241C ; =0x0000C55A
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F2414 ; =0x0000066C
	ldr r1, _021F2420 ; =0x0000C557
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F2414 ; =0x0000066C
	ldr r1, _021F2420 ; =0x0000C557
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	nop
_021F2414: .word 0x0000066C
_021F2418: .word 0x0000C598
_021F241C: .word 0x0000C55A
_021F2420: .word 0x0000C557
	thumb_func_end ov18_021F23E4

	thumb_func_start ov18_021F2424
ov18_021F2424: ; 0x021F2424
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r2, #0x30]
	add r4, r1, #0
	cmp r0, #1
	ldr r1, _021F2464 ; =0x00000668
	bne _021F2448
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl SpriteSystem_NewSprite
	lsl r1, r4, #2
	add r2, r5, r1
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r2, r1]
	pop {r3, r4, r5, pc}
_021F2448:
	ldr r0, [r5, r1]
	add r1, r1, #4
	mov r3, #2
	ldr r1, [r5, r1]
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	lsl r1, r4, #2
	add r2, r5, r1
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r2, r1]
	pop {r3, r4, r5, pc}
	nop
_021F2464: .word 0x00000668
	thumb_func_end ov18_021F2424

	thumb_func_start ov18_021F2468
ov18_021F2468: ; 0x021F2468
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	ldr r4, _021F24D0 ; =ov18_021FA484
	add r7, r0, #0
	add r3, sp, #0
	mov r2, #6
_021F2474:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F2474
	ldr r0, [r4]
	mov r4, #0x1b
	add r5, r7, #0
	str r0, [r3]
	mov r6, #0x12
	lsl r4, r4, #4
	add r5, #0x48
_021F248A:
	mov r0, #0x4d
	lsl r0, r0, #2
	sub r1, r4, r0
	add r0, sp, #0
	strh r1, [r0]
	add r0, r7, #0
	add r1, r6, #0
	add r2, sp, #0
	bl ov18_021F2424
	ldr r0, _021F24D4 ; =0x0000066C
	ldr r1, _021F24D8 ; =0x0000C55A
	ldr r0, [r7, r0]
	mov r2, #2
	bl SpriteManager_FindPlttResourceOffset
	add r1, r0, #0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPaletteOverride
	add r6, r6, #1
	add r4, #0x18
	add r5, r5, #4
	cmp r6, #0x17
	bls _021F248A
	ldr r2, _021F24DC ; =ov18_021FAB24
	add r0, r7, #0
	mov r1, #8
	bl ov18_021F2424
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_021F24D0: .word ov18_021FA484
_021F24D4: .word 0x0000066C
_021F24D8: .word 0x0000C55A
_021F24DC: .word ov18_021FAB24
	thumb_func_end ov18_021F2468

	thumb_func_start ov18_021F24E0
ov18_021F24E0: ; 0x021F24E0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	cmp r1, #0
	beq _021F24F6
	ldr r0, [r5]
	ldr r0, [r0]
	bl Pokedex_GetInternationalViewFlag
	cmp r0, #0
	bne _021F2508
_021F24F6:
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_021F2508:
	ldr r0, _021F252C ; =0x0000185C
	ldrb r0, [r5, r0]
	bl LanguageToDexFlag
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F118C
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F252C: .word 0x0000185C
	thumb_func_end ov18_021F24E0

	thumb_func_start ov18_021F2530
ov18_021F2530: ; 0x021F2530
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	str r1, [sp]
	add r6, r0, #0
	ldr r0, [sp]
	str r2, [sp, #4]
	cmp r0, #0
	beq _021F254C
	ldr r0, [r6]
	ldr r0, [r0]
	bl Pokedex_GetInternationalViewFlag
	cmp r0, #0
	bne _021F257A
_021F254C:
	ldr r0, [sp, #4]
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	ldr r0, [sp, #4]
	add r7, r0, #6
	cmp r4, r7
	bhs _021F263E
	lsl r0, r4, #2
	add r5, r6, r0
	mov r6, #0x67
	lsl r6, r6, #4
_021F2562:
	ldr r0, [r5, r6]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #1
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	add r5, r5, #4
	cmp r4, r7
	blo _021F2562
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
_021F257A:
	ldr r0, [sp, #4]
	mov r7, #0
	add r0, r0, #5
	lsl r0, r0, #0x10
	asr r5, r0, #0x10
	ldr r0, [sp, #4]
	cmp r5, r0
	blo _021F263E
	lsl r0, r5, #2
	add r4, r6, r0
_021F258E:
	ldr r0, [sp, #4]
	sub r0, r5, r0
	str r0, [sp, #8]
	bl sub_020912AC
	bl sub_02091294
	str r0, [sp, #0xc]
	ldr r2, [sp, #0xc]
	ldr r1, [sp]
	lsl r2, r2, #0x10
	add r0, r6, #0
	lsr r2, r2, #0x10
	bl ov18_021E6D10
	cmp r0, #1
	beq _021F25B6
	ldr r0, [sp, #0xc]
	cmp r0, #2
	bne _021F2624
_021F25B6:
	ldr r0, _021F2644 ; =0x0000185C
	ldrb r0, [r6, r0]
	bl LanguageToDexFlag
	str r0, [sp, #0x10]
	ldr r0, [sp, #8]
	bl sub_020912AC
	add r2, r0, #0
	ldr r0, [sp, #0x10]
	cmp r2, r0
	bne _021F25D8
	add r0, r6, #0
	add r1, r5, #0
	bl ov18_021F118C
	b _021F25E2
_021F25D8:
	add r0, r6, #0
	add r1, r5, #0
	add r2, r2, #6
	bl ov18_021F118C
_021F25E2:
	mov r0, #0x67
	lsl r0, r0, #4
	add r1, sp, #0x14
	ldr r0, [r4, r0]
	add r1, #2
	add r2, sp, #0x14
	bl ManagedSprite_GetPositionXY
	mov r1, #5
	sub r2, r1, r7
	mov r1, #0x18
	mul r1, r2
	mov r0, #0x67
	lsl r0, r0, #4
	add r1, #0x7c
	lsl r1, r1, #0x10
	add r3, sp, #0x14
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r4, r0]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r7, #1
	lsl r0, r0, #0x10
	asr r7, r0, #0x10
	b _021F2630
_021F2624:
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
_021F2630:
	sub r0, r5, #1
	lsl r0, r0, #0x10
	asr r5, r0, #0x10
	ldr r0, [sp, #4]
	sub r4, r4, #4
	cmp r5, r0
	bhs _021F258E
_021F263E:
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F2644: .word 0x0000185C
	thumb_func_end ov18_021F2530

	thumb_func_start ov18_021F2648
ov18_021F2648: ; 0x021F2648
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F26D0 ; =0x0000C590
	ldr r1, _021F26D4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F26D8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0xc
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F26D8 ; =0x00000854
	ldr r3, _021F26D4 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0xf
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #5
	str r1, [sp, #0xc]
	mov r1, #1
	str r1, [sp, #0x10]
	ldr r1, _021F26DC ; =0x0000C556
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F26E0 ; =0x0000C552
	ldr r1, _021F26D4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F26D8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0xd
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F26E0 ; =0x0000C552
	ldr r1, _021F26D4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F26D8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0xe
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	nop
_021F26D0: .word 0x0000C590
_021F26D4: .word 0x00000668
_021F26D8: .word 0x00000854
_021F26DC: .word 0x0000C556
_021F26E0: .word 0x0000C552
	thumb_func_end ov18_021F2648

	thumb_func_start ov18_021F26E4
ov18_021F26E4: ; 0x021F26E4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F2714 ; =0x0000066C
	ldr r1, _021F2718 ; =0x0000C590
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F2714 ; =0x0000066C
	ldr r1, _021F271C ; =0x0000C556
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F2714 ; =0x0000066C
	ldr r1, _021F2720 ; =0x0000C552
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F2714 ; =0x0000066C
	ldr r1, _021F2720 ; =0x0000C552
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	nop
_021F2714: .word 0x0000066C
_021F2718: .word 0x0000C590
_021F271C: .word 0x0000C556
_021F2720: .word 0x0000C552
	thumb_func_end ov18_021F26E4

	thumb_func_start ov18_021F2724
ov18_021F2724: ; 0x021F2724
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F2800 ; =0x0000C591
	ldr r1, _021F2804 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F2808 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x1a
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F2808 ; =0x00000854
	ldr r3, _021F2804 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x20
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F280C ; =0x0000C557
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F2810 ; =0x0000C553
	ldr r1, _021F2804 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F2808 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x1b
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F2810 ; =0x0000C553
	ldr r1, _021F2804 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F2808 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x1c
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F2814 ; =0x0000C592
	ldr r1, _021F2804 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F2808 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x1d
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F2818 ; =0x0000C554
	ldr r1, _021F2804 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F2808 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x1e
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F2818 ; =0x0000C554
	ldr r1, _021F2804 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F2808 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x1f
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	nop
_021F2800: .word 0x0000C591
_021F2804: .word 0x00000668
_021F2808: .word 0x00000854
_021F280C: .word 0x0000C557
_021F2810: .word 0x0000C553
_021F2814: .word 0x0000C592
_021F2818: .word 0x0000C554
	thumb_func_end ov18_021F2724

	thumb_func_start ov18_021F281C
ov18_021F281C: ; 0x021F281C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F2868 ; =0x0000066C
	ldr r1, _021F286C ; =0x0000C591
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F2868 ; =0x0000066C
	ldr r1, _021F2870 ; =0x0000C557
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F2868 ; =0x0000066C
	ldr r1, _021F2874 ; =0x0000C553
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F2868 ; =0x0000066C
	ldr r1, _021F2874 ; =0x0000C553
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	ldr r0, _021F2868 ; =0x0000066C
	ldr r1, _021F2878 ; =0x0000C592
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F2868 ; =0x0000066C
	ldr r1, _021F287C ; =0x0000C554
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F2868 ; =0x0000066C
	ldr r1, _021F287C ; =0x0000C554
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	.balign 4, 0
_021F2868: .word 0x0000066C
_021F286C: .word 0x0000C591
_021F2870: .word 0x0000C557
_021F2874: .word 0x0000C553
_021F2878: .word 0x0000C592
_021F287C: .word 0x0000C554
	thumb_func_end ov18_021F281C

	thumb_func_start ov18_021F2880
ov18_021F2880: ; 0x021F2880
	push {r4, r5, r6, lr}
	add r5, r0, #0
	bl ov18_021F2964
	add r0, r5, #0
	mov r1, #0x18
	bl ov18_021F1424
	add r0, r5, #0
	mov r1, #0x18
	bl ov18_021F1620
	add r0, r5, #0
	bl ov18_021F299C
	ldr r0, _021F2960 ; =0x00001860
	ldr r0, [r5, r0]
	cmp r0, #0
	bne _021F28B4
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	b _021F28BC
_021F28B4:
	add r0, r5, #0
	mov r1, #0
	bl ov18_021F2AC0
_021F28BC:
	add r0, r5, #0
	mov r1, #5
	bl ov18_021F2BB0
	add r0, r5, #0
	mov r1, #2
	mov r2, #1
	bl ov18_021F2C10
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov18_021F2C5C
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov18_021F2E80
	add r0, r5, #0
	bl ov18_021F8838
	add r4, r0, #0
	add r0, r5, #0
	bl ov18_021F8824
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #0xb
	bl ov18_021F1A30
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0xb
	mov r3, #0xa
	bl ov18_021F1CAC
	add r0, r5, #0
	mov r1, #0xe
	bl ov18_021F1FDC
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0xe
	bl ov18_021F209C
	add r0, r5, #0
	mov r1, #0xd
	bl ov18_021F1D98
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	mov r3, #0xd
	bl ov18_021F1DE4
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #9
	bl ov18_021F2EC8
	add r0, r5, #0
	bl ov18_021F2468
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x12
	bl ov18_021F2530
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #8
	bl ov18_021F24E0
	mov r0, #0x69
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F2960: .word 0x00001860
	thumb_func_end ov18_021F2880

	thumb_func_start ov18_021F2964
ov18_021F2964: ; 0x021F2964
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x3c
	bl ov18_021F1324
	add r0, r4, #0
	bl ov18_021F2648
	add r0, r4, #0
	bl ov18_021F2270
	add r0, r4, #0
	bl ov18_021F17FC
	add r0, r4, #0
	bl ov18_021F1CB4
	add r0, r4, #0
	bl ov18_021F1E70
	add r0, r4, #0
	bl ov18_021F2724
	add r0, r4, #0
	bl ov18_021F2348
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F2964

	thumb_func_start ov18_021F299C
ov18_021F299C: ; 0x021F299C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r6, _021F2A0C ; =ov18_021FA984
	mov r7, #0
	add r4, r5, #0
_021F29A6:
	ldr r0, _021F2A10 ; =0x00000668
	ldr r1, _021F2A14 ; =0x0000066C
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r6, #0
	bl SpriteSystem_NewSprite
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r4, r1]
	add r7, r7, #1
	add r6, #0x34
	add r4, r4, #4
	cmp r7, #7
	bls _021F29A6
	add r0, r1, #0
	add r0, #0x18
	ldr r0, [r5, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F2A18 ; =0x0000068C
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r1, _021F2A10 ; =0x00000668
	mov r3, #2
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, _021F2A1C ; =ov18_021FAB58
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F2A20 ; =0x00000694
	mov r3, #2
	str r0, [r5, r1]
	add r0, r1, #0
	sub r0, #0x2c
	sub r1, #0x28
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	ldr r2, _021F2A24 ; =ov18_021FAB8C
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F2A28 ; =0x00000698
	str r0, [r5, r1]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F2A0C: .word ov18_021FA984
_021F2A10: .word 0x00000668
_021F2A14: .word 0x0000066C
_021F2A18: .word 0x0000068C
_021F2A1C: .word ov18_021FAB58
_021F2A20: .word 0x00000694
_021F2A24: .word ov18_021FAB8C
_021F2A28: .word 0x00000698
	thumb_func_end ov18_021F299C

	thumb_func_start ov18_021F2A2C
ov18_021F2A2C: ; 0x021F2A2C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r5, r1, #0
	cmp r2, #1
	bne _021F2A60
	ldr r0, [r4]
	ldr r0, [r0]
	bl Pokedex_GetInternationalViewFlag
	cmp r0, #1
	bne _021F2A60
	lsl r5, r5, #2
	mov r0, #0x67
	add r1, r4, r5
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F2A80 ; =0x00000674
	add r1, r4, r5
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_021F2A60:
	lsl r5, r5, #2
	mov r0, #0x67
	add r1, r4, r5
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, _021F2A80 ; =0x00000674
	add r1, r4, r5
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	nop
_021F2A80: .word 0x00000674
	thumb_func_end ov18_021F2A2C

	thumb_func_start ov18_021F2A84
ov18_021F2A84: ; 0x021F2A84
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	cmp r2, #1
	bne _021F2AAC
	ldr r0, [r5]
	ldr r0, [r0]
	bl Pokedex_GetInternationalViewFlag
	cmp r0, #1
	bne _021F2AAC
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_021F2AAC:
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F2A84

	thumb_func_start ov18_021F2AC0
ov18_021F2AC0: ; 0x021F2AC0
	push {r3, lr}
	ldr r2, _021F2AF4 ; =0x00001858
	ldrb r2, [r0, r2]
	cmp r2, #0
	bne _021F2ADE
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x90
	mov r2, #0x80
	bl ManagedSprite_SetPositionXY
	pop {r3, pc}
_021F2ADE:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x70
	mov r2, #0x80
	bl ManagedSprite_SetPositionXY
	pop {r3, pc}
	nop
_021F2AF4: .word 0x00001858
	thumb_func_end ov18_021F2AC0

	thumb_func_start ov18_021F2AF8
ov18_021F2AF8: ; 0x021F2AF8
	push {r3, r4, r5, lr}
	add r5, r1, #0
	mov r1, #0x67
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	add r1, sp, #0
	add r4, r2, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	add r1, sp, #0
	mov r0, #2
	ldrsh r2, [r1, r0]
	add r0, r2, #0
	sub r0, #0x10
	cmp r5, r0
	blo _021F2B38
	add r2, #0x10
	cmp r5, r2
	bhs _021F2B38
	mov r0, #0
	ldrsh r1, [r1, r0]
	add r0, r1, #0
	sub r0, #0x10
	cmp r4, r0
	blo _021F2B38
	add r1, #0x10
	cmp r4, r1
	bhs _021F2B38
	mov r0, #1
	pop {r3, r4, r5, pc}
_021F2B38:
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F2AF8

	thumb_func_start ov18_021F2B3C
ov18_021F2B3C: ; 0x021F2B3C
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
	mov r1, #2
	ldrsh r1, [r3, r1]
	mov r2, #0
	ldrsh r2, [r3, r2]
	add r1, r1, r6
	lsl r1, r1, #0x10
	ldr r0, [r5, r4]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov18_021F2B3C

	thumb_func_start ov18_021F2B70
ov18_021F2B70: ; 0x021F2B70
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
	ldr r0, [r5, r4]
	add r1, r6, #0
	bl ManagedSprite_SetPositionXY
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov18_021F2B70

	thumb_func_start ov18_021F2B9C
ov18_021F2B9C: ; 0x021F2B9C
	ldr r1, _021F2BAC ; =0x00001858
	ldrb r0, [r0, r1]
	cmp r0, #0
	bne _021F2BA8
	mov r0, #0x90
	bx lr
_021F2BA8:
	mov r0, #0x70
	bx lr
	.balign 4, 0
_021F2BAC: .word 0x00001858
	thumb_func_end ov18_021F2B9C

	thumb_func_start ov18_021F2BB0
ov18_021F2BB0: ; 0x021F2BB0
	push {r3, r4, r5, r6, r7, lr}
	ldr r2, _021F2BF8 ; =0x0000185A
	lsl r4, r1, #2
	ldrb r6, [r0, r2]
	mov r2, #0x67
	lsl r2, r2, #4
	add r5, r0, r2
	add r0, r6, #0
	mov r1, #5
	bl _s32_div_f
	add r7, r1, #0
	add r0, r6, #0
	mov r1, #5
	bl _s32_div_f
	add r3, r0, #0
	mov r2, #0x28
	add r1, r7, #0
	mul r1, r2
	mul r2, r3
	add r1, #0x30
	add r2, #0x18
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r5, r4]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, r4]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F2BF8: .word 0x0000185A
	thumb_func_end ov18_021F2BB0

	thumb_func_start ov18_021F2BFC
ov18_021F2BFC: ; 0x021F2BFC
	ldr r1, _021F2C08 ; =0x00000684
	ldr r3, _021F2C0C ; =ManagedSprite_SetDrawFlag
	ldr r0, [r0, r1]
	mov r1, #0
	bx r3
	nop
_021F2C08: .word 0x00000684
_021F2C0C: .word ManagedSprite_SetDrawFlag
	thumb_func_end ov18_021F2BFC

	thumb_func_start ov18_021F2C10
ov18_021F2C10: ; 0x021F2C10
	push {r4, r5, r6, lr}
	add r6, r2, #0
	ldr r2, _021F2C58 ; =0x00001859
	add r5, r0, #0
	ldrb r2, [r5, r2]
	add r4, r1, #0
	cmp r2, #0
	bne _021F2C28
	mov r2, #7
	bl ov18_021F118C
	b _021F2C2E
_021F2C28:
	mov r2, #5
	bl ov18_021F118C
_021F2C2E:
	add r0, r5, #0
	add r1, r6, #0
	bl ov18_021F8950
	ldr r1, _021F2C58 ; =0x00001859
	ldrb r1, [r5, r1]
	cmp r1, r0
	bne _021F2C4A
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #0xa
	bl ov18_021F118C
	pop {r4, r5, r6, pc}
_021F2C4A:
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #8
	bl ov18_021F118C
	pop {r4, r5, r6, pc}
	nop
_021F2C58: .word 0x00001859
	thumb_func_end ov18_021F2C10

	thumb_func_start ov18_021F2C5C
ov18_021F2C5C: ; 0x021F2C5C
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r1, r2, #0
	bl ov18_021F2C74
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F2C5C

	thumb_func_start ov18_021F2C74
ov18_021F2C74: ; 0x021F2C74
	push {r3, lr}
	bl ov18_021F891C
	ldr r3, _021F2C94 ; =ov18_021FA398
	mov r2, #0
_021F2C7E:
	ldrh r1, [r3]
	cmp r0, r1
	bls _021F2C8C
	add r2, r2, #1
	add r3, r3, #2
	cmp r2, #0xc
	blo _021F2C7E
_021F2C8C:
	add r2, #0xb
	add r0, r2, #0
	pop {r3, pc}
	nop
_021F2C94: .word ov18_021FA398
	thumb_func_end ov18_021F2C74

	thumb_func_start ov18_021F2C98
ov18_021F2C98: ; 0x021F2C98
	push {r3, lr}
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ManagedSprite_GetActiveAnim
	ldr r1, _021F2CB0 ; =ov18_021FA310 + 1
	ldrb r0, [r1, r0]
	pop {r3, pc}
	nop
_021F2CB0: .word ov18_021FA310 + 1
	thumb_func_end ov18_021F2C98

	thumb_func_start ov18_021F2CB4
ov18_021F2CB4: ; 0x021F2CB4
	push {r3, lr}
	bl ov18_021F2C98
	lsr r0, r0, #1
	add r0, #0x15
	pop {r3, pc}
	thumb_func_end ov18_021F2CB4

	thumb_func_start ov18_021F2CC0
ov18_021F2CC0: ; 0x021F2CC0
	push {r3, lr}
	bl ov18_021F2C98
	lsr r1, r0, #1
	mov r0, #0x83
	sub r0, r0, r1
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov18_021F2CC0

	thumb_func_start ov18_021F2CD0
ov18_021F2CD0: ; 0x021F2CD0
	push {r3, r4, r5, r6, r7, lr}
	add r7, r1, #0
	add r6, r0, #0
	lsl r0, r7, #2
	add r1, r6, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r5, r2, #0
	add r1, #2
	add r2, sp, #0
	add r4, r3, #0
	bl ManagedSprite_GetPositionXY
	add r0, r6, #0
	add r1, r7, #0
	bl ov18_021F2C98
	add r2, sp, #0
	mov r1, #2
	ldrsh r3, [r2, r1]
	add r1, r3, #0
	sub r1, #0xb
	cmp r5, r1
	blo _021F2D20
	add r3, #0xb
	cmp r5, r3
	bhi _021F2D20
	lsr r3, r0, #1
	mov r0, #0
	ldrsh r1, [r2, r0]
	sub r0, r1, r3
	cmp r4, r0
	blo _021F2D20
	add r0, r1, r3
	cmp r4, r0
	bhi _021F2D20
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021F2D20:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F2CD0

	thumb_func_start ov18_021F2D24
ov18_021F2D24: ; 0x021F2D24
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #0x67
	add r4, r1, #0
	lsl r0, r0, #4
	add r7, r5, r0
	lsl r0, r4, #2
	str r0, [sp, #4]
	add r1, sp, #8
	ldr r0, [r7, r0]
	add r1, #2
	add r2, sp, #8
	add r6, r3, #0
	bl ManagedSprite_GetPositionXY
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F2CB4
	cmp r6, r0
	bhs _021F2D52
	add r6, r0, #0
_021F2D52:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F2CC0
	cmp r6, r0
	bls _021F2D60
	add r6, r0, #0
_021F2D60:
	ldr r0, [sp, #4]
	add r2, sp, #8
	mov r1, #2
	ldrsh r1, [r2, r1]
	lsl r2, r6, #0x10
	ldr r0, [r7, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F2CB4
	add r7, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F2CC0
	sub r0, r0, r7
	str r0, [sp]
	ldr r1, [sp, #0x20]
	add r0, r5, #0
	bl ov18_021F8950
	add r4, r0, #0
	ldr r0, [sp]
	add r1, r4, #0
	lsl r0, r0, #8
	bl _u32_div_f
	sub r1, r6, r7
	mov r3, #0
	lsl r2, r1, #8
	add r6, r3, #0
	add r7, r3, #0
_021F2DA6:
	cmp r2, r6
	blo _021F2DC0
	add r1, r7, r0
	cmp r2, r1
	bhs _021F2DC0
	ldr r0, _021F2DD0 ; =0x00001859
	ldrb r1, [r5, r0]
	cmp r1, r3
	beq _021F2DCA
	add sp, #0xc
	strb r3, [r5, r0]
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_021F2DC0:
	add r3, r3, #1
	add r6, r6, r0
	add r7, r7, r0
	cmp r3, r4
	bls _021F2DA6
_021F2DCA:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F2DD0: .word 0x00001859
	thumb_func_end ov18_021F2D24

	thumb_func_start ov18_021F2DD4
ov18_021F2DD4: ; 0x021F2DD4
	push {r3, r4, r5, r6, r7, lr}
	add r4, r2, #0
	add r5, r1, #0
	add r7, r0, #0
	add r1, r4, #0
	str r3, [sp]
	bl ov18_021F2CB4
	add r6, r0, #0
	add r0, r7, #0
	add r1, r4, #0
	bl ov18_021F2CC0
	add r4, r0, #0
	ldr r1, [sp]
	add r0, r7, #0
	bl ov18_021F8950
	add r1, r0, #0
	cmp r5, r1
	beq _021F2E0E
	sub r0, r4, r6
	lsl r0, r0, #8
	bl _u32_div_f
	add r1, r0, #0
	mul r1, r5
	lsr r0, r1, #8
	add r4, r6, r0
_021F2E0E:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F2DD4

	thumb_func_start ov18_021F2E14
ov18_021F2E14: ; 0x021F2E14
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
	blo _021F2E42
	sub r0, r5, r0
	add r1, r4, #0
	bl _u32_div_f
	pop {r3, r4, r5, pc}
_021F2E42:
	sub r0, r0, r5
	add r1, r4, #0
	bl _u32_div_f
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F2E14

	thumb_func_start ov18_021F2E4C
ov18_021F2E4C: ; 0x021F2E4C
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
	thumb_func_end ov18_021F2E4C

	thumb_func_start ov18_021F2E80
ov18_021F2E80: ; 0x021F2E80
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #0x67
	lsl r0, r0, #4
	add r1, sp, #4
	str r2, [sp]
	add r6, r5, r0
	lsl r7, r4, #2
	ldr r0, [r6, r7]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	ldr r1, _021F2EC4 ; =0x00001859
	ldr r3, [sp]
	ldrb r1, [r5, r1]
	add r0, r5, #0
	add r2, r4, #0
	bl ov18_021F2DD4
	add r3, r0, #0
	add r2, sp, #4
	mov r1, #2
	ldrsh r1, [r2, r1]
	lsl r2, r3, #0x10
	ldr r0, [r6, r7]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F2EC4: .word 0x00001859
	thumb_func_end ov18_021F2E80

	thumb_func_start ov18_021F2EC8
ov18_021F2EC8: ; 0x021F2EC8
	push {r3, lr}
	lsl r1, r1, #2
	add r3, r0, r1
	ldr r1, _021F2EFC ; =0x00001032
	ldrh r1, [r3, r1]
	cmp r1, #2
	bne _021F2EE8
	lsl r1, r2, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
_021F2EE8:
	lsl r1, r2, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
	nop
_021F2EFC: .word 0x00001032
	thumb_func_end ov18_021F2EC8

	thumb_func_start ov18_021F2F00
ov18_021F2F00: ; 0x021F2F00
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F1104
	add r0, r4, #0
	mov r1, #0x3c
	bl ov18_021F13DC
	add r0, r4, #0
	bl ov18_021F26E4
	add r0, r4, #0
	bl ov18_021F2308
	add r0, r4, #0
	bl ov18_021F18E0
	add r0, r4, #0
	bl ov18_021F1D58
	add r0, r4, #0
	bl ov18_021F1F74
	add r0, r4, #0
	bl ov18_021F281C
	add r0, r4, #0
	bl ov18_021F23E4
	pop {r4, pc}
	thumb_func_end ov18_021F2F00

	thumb_func_start ov18_021F2F3C
ov18_021F2F3C: ; 0x021F2F3C
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F2F4C
	add r0, r4, #0
	bl ov18_021F32B8
	pop {r4, pc}
	thumb_func_end ov18_021F2F3C

	thumb_func_start ov18_021F2F4C
ov18_021F2F4C: ; 0x021F2F4C
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r1, #0x3c
	bl ov18_021F1324
	add r0, r4, #0
	bl ov18_021F2648
	add r0, r4, #0
	bl ov18_021F2270
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F30E0 ; =0x0000C5A0
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x48
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F30E8 ; =0x00000854
	ldr r3, _021F30E4 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x4b
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, _021F30EC ; =0x0000C561
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F30F0 ; =0x0000C55E
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x49
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F30F0 ; =0x0000C55E
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x4a
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F30F4 ; =0x0000C59F
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x48
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F30E8 ; =0x00000854
	ldr r3, _021F30E4 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x4b
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F30F8 ; =0x0000C560
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F30FC ; =0x0000C55D
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x49
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F30FC ; =0x0000C55D
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x4a
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F3100 ; =0x0000C59E
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x17
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F30E8 ; =0x00000854
	ldr r3, _021F30E4 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x20
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F3104 ; =0x0000C55F
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3108 ; =0x0000C55C
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x18
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3108 ; =0x0000C55C
	ldr r1, _021F30E4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F30E8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x19
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	nop
_021F30E0: .word 0x0000C5A0
_021F30E4: .word 0x00000668
_021F30E8: .word 0x00000854
_021F30EC: .word 0x0000C561
_021F30F0: .word 0x0000C55E
_021F30F4: .word 0x0000C59F
_021F30F8: .word 0x0000C560
_021F30FC: .word 0x0000C55D
_021F3100: .word 0x0000C59E
_021F3104: .word 0x0000C55F
_021F3108: .word 0x0000C55C
	thumb_func_end ov18_021F2F4C

	thumb_func_start ov18_021F310C
ov18_021F310C: ; 0x021F310C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x3c
	bl ov18_021F13DC
	add r0, r4, #0
	bl ov18_021F26E4
	add r0, r4, #0
	bl ov18_021F2308
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F3178 ; =0x0000C59F
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F317C ; =0x0000C560
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F3180 ; =0x0000C55D
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F3180 ; =0x0000C55D
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F3184 ; =0x0000C5A0
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F3188 ; =0x0000C561
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F318C ; =0x0000C55E
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F3174 ; =0x0000066C
	ldr r1, _021F318C ; =0x0000C55E
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	.balign 4, 0
_021F3174: .word 0x0000066C
_021F3178: .word 0x0000C59F
_021F317C: .word 0x0000C560
_021F3180: .word 0x0000C55D
_021F3184: .word 0x0000C5A0
_021F3188: .word 0x0000C561
_021F318C: .word 0x0000C55E
	thumb_func_end ov18_021F310C

	thumb_func_start ov18_021F3190
ov18_021F3190: ; 0x021F3190
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	add r5, r0, #0
	bl ov18_021F17FC
	add r0, r5, #0
	bl ov18_021F1CB4
	add r0, r5, #0
	bl ov18_021F1E70
	add r0, r5, #0
	bl ov18_021F2724
	add r0, r5, #0
	bl ov18_021F2348
	ldr r1, _021F3270 ; =0x00000668
	mov r3, #2
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, _021F3274 ; =ov18_021FAB58
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	mov r1, #0x72
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r1, #0
	sub r0, #0xb8
	sub r1, #0xb4
	mov r3, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	ldr r2, _021F3278 ; =ov18_021FAB8C
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F327C ; =0x00000724
	str r0, [r5, r1]
	add r0, r5, #0
	mov r1, #0x2e
	bl ov18_021F1A30
	add r0, r5, #0
	mov r1, #0x30
	bl ov18_021F1D98
	add r0, r5, #0
	mov r1, #0x31
	bl ov18_021F1FDC
	ldr r4, _021F3280 ; =ov18_021FA484
	add r3, sp, #0
	mov r2, #6
_021F3200:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F3200
	ldr r0, [r4]
	add r4, r5, #0
	ldr r6, _021F3284 ; =0x000004F8
	str r0, [r3]
	mov r7, #0x35
	add r4, #0xd4
_021F3214:
	ldr r0, _021F3288 ; =0x0000047C
	add r2, sp, #0
	sub r1, r6, r0
	add r0, sp, #0
	strh r1, [r0]
	add r0, r5, #0
	add r1, r7, #0
	bl ov18_021F2424
	ldr r0, _021F328C ; =0x0000066C
	ldr r1, _021F3290 ; =0x0000C55A
	ldr r0, [r5, r0]
	mov r2, #2
	bl SpriteManager_FindPlttResourceOffset
	add r1, r0, #0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl ManagedSprite_SetPaletteOverride
	add r7, r7, #1
	add r6, #0x18
	add r4, r4, #4
	cmp r7, #0x3a
	bls _021F3214
	mov r7, #0x67
	lsl r7, r7, #4
	mov r4, #0x2c
	add r5, #0xb0
	add r6, r7, #0
_021F3252:
	ldr r0, [r5, r7]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r5, r6]
	mov r1, #2
	bl ManagedSprite_SetPriority
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0x3a
	bls _021F3252
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_021F3270: .word 0x00000668
_021F3274: .word ov18_021FAB58
_021F3278: .word ov18_021FAB8C
_021F327C: .word 0x00000724
_021F3280: .word ov18_021FA484
_021F3284: .word 0x000004F8
_021F3288: .word 0x0000047C
_021F328C: .word 0x0000066C
_021F3290: .word 0x0000C55A
	thumb_func_end ov18_021F3190

	thumb_func_start ov18_021F3294
ov18_021F3294: ; 0x021F3294
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F18E0
	add r0, r4, #0
	bl ov18_021F1D58
	add r0, r4, #0
	bl ov18_021F1F74
	add r0, r4, #0
	bl ov18_021F281C
	add r0, r4, #0
	bl ov18_021F23E4
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F3294

	thumb_func_start ov18_021F32B8
ov18_021F32B8: ; 0x021F32B8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	mov r7, #0x67
	ldr r6, _021F340C ; =ov18_021FB004
	add r5, r0, #0
	mov r4, #0
	lsl r7, r7, #4
_021F32C6:
	ldr r0, _021F3410 ; =0x00000668
	ldr r1, _021F3414 ; =0x0000066C
	mov r2, #0x34
	mul r2, r4
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r6, r2
	bl SpriteSystem_NewSprite
	lsl r1, r4, #2
	add r1, r5, r1
	str r0, [r1, r7]
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x19
	bls _021F32C6
	ldr r1, _021F3410 ; =0x00000668
	mov r3, #2
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, _021F3418 ; =ov18_021FA520
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F341C ; =0x0000071C
	mov r2, #0
	str r0, [r5, r1]
	add r0, r5, #0
	mov r1, #0x2b
	bl ov18_021F11C0
	ldr r1, _021F3410 ; =0x00000668
	mov r3, #2
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, _021F3420 ; =ov18_021FB54C
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F3424 ; =0x000006D8
	mov r3, #2
	str r0, [r5, r1]
	add r0, r1, #0
	sub r0, #0x70
	sub r1, #0x6c
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	ldr r2, _021F3428 ; =ov18_021FB580
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F342C ; =0x000006DC
	mov r2, #0
	str r0, [r5, r1]
	add r0, r5, #0
	mov r1, #0x1b
	bl ov18_021F11C0
	ldr r4, _021F3430 ; =ov18_021FA4EC
	add r3, sp, #0
	mov r2, #6
_021F3350:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F3350
	ldr r0, [r4]
	mov r4, #0x1c
	str r0, [r3]
	add r7, sp, #0
_021F3360:
	cmp r4, #0x1c
	bne _021F33A2
	mov r0, #0xe0
	strh r0, [r7]
	mov r0, #0x48
	strh r0, [r7, #2]
	ldr r0, _021F3410 ; =0x00000668
	ldr r1, _021F3414 ; =0x0000066C
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, sp, #0
	bl SpriteSystem_NewSprite
	lsl r1, r4, #2
	add r2, r5, r1
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r2, r1]
	ldr r0, _021F3434 ; =0x0000188C
	ldr r2, [r5, r0]
	cmp r2, #0xe
	bne _021F3398
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	b _021F33F6
_021F3398:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F118C
	b _021F33F6
_021F33A2:
	add r0, r4, #0
	sub r0, #0x1d
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	add r0, r6, #0
	mov r1, #5
	bl _s32_div_f
	mov r0, #0x30
	mul r0, r1
	add r0, #0x20
	strh r0, [r7]
	add r0, r6, #0
	mov r1, #5
	bl _s32_div_f
	mov r1, #0x28
	mul r1, r0
	add r1, #0x38
	strh r1, [r7, #2]
	ldr r0, _021F3410 ; =0x00000668
	ldr r1, _021F3414 ; =0x0000066C
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, sp, #0
	bl SpriteSystem_NewSprite
	lsl r1, r4, #2
	add r2, r5, r1
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r2, r1]
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
_021F33F6:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x2a
	bls _021F3360
	add r0, r5, #0
	mov r1, #0x3b
	bl ov18_021F1424
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F340C: .word ov18_021FB004
_021F3410: .word 0x00000668
_021F3414: .word 0x0000066C
_021F3418: .word ov18_021FA520
_021F341C: .word 0x0000071C
_021F3420: .word ov18_021FB54C
_021F3424: .word 0x000006D8
_021F3428: .word ov18_021FB580
_021F342C: .word 0x000006DC
_021F3430: .word ov18_021FA4EC
_021F3434: .word 0x0000188C
	thumb_func_end ov18_021F32B8

	thumb_func_start ov18_021F3438
ov18_021F3438: ; 0x021F3438
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F1104
	add r0, r4, #0
	bl ov18_021F310C
	pop {r4, pc}
	thumb_func_end ov18_021F3438

	thumb_func_start ov18_021F3448
ov18_021F3448: ; 0x021F3448
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x1a
	bl ov18_021F10E8
	add r0, r4, #0
	mov r1, #0x1b
	bl ov18_021F10E8
	ldr r0, _021F3484 ; =0x0000066C
	ldr r1, _021F3488 ; =0x0000C59E
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F3484 ; =0x0000066C
	ldr r1, _021F348C ; =0x0000C55F
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F3484 ; =0x0000066C
	ldr r1, _021F3490 ; =0x0000C55C
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F3484 ; =0x0000066C
	ldr r1, _021F3490 ; =0x0000C55C
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	.balign 4, 0
_021F3484: .word 0x0000066C
_021F3488: .word 0x0000C59E
_021F348C: .word 0x0000C55F
_021F3490: .word 0x0000C55C
	thumb_func_end ov18_021F3448

	thumb_func_start ov18_021F3494
ov18_021F3494: ; 0x021F3494
	push {r4, lr}
	ldr r1, _021F34C0 ; =0x0000188C
	add r4, r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0xe
	bne _021F34AA
	mov r1, #0x1c
	mov r2, #0
	bl ov18_021F11C0
	pop {r4, pc}
_021F34AA:
	mov r1, #0x1c
	mov r2, #1
	bl ov18_021F11C0
	ldr r2, _021F34C0 ; =0x0000188C
	add r0, r4, #0
	ldr r2, [r4, r2]
	mov r1, #0x1c
	bl ov18_021F118C
	pop {r4, pc}
	.balign 4, 0
_021F34C0: .word 0x0000188C
	thumb_func_end ov18_021F3494

	thumb_func_start ov18_021F34C4
ov18_021F34C4: ; 0x021F34C4
	push {r4, r5, r6, lr}
	add r5, r0, #0
	cmp r1, #1
	bne _021F34D4
	mov r1, #0x1c
	mov r2, #0
	bl ov18_021F11C0
_021F34D4:
	mov r4, #0x1d
	mov r6, #0
_021F34D8:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F11C0
	add r4, r4, #1
	cmp r4, #0x2a
	bls _021F34D8
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F34C4

	thumb_func_start ov18_021F34EC
ov18_021F34EC: ; 0x021F34EC
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov18_021F3494
	cmp r4, #1
	bne _021F351E
	mov r0, #0x6e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xe0
	mov r2, #0x48
	bl ManagedSprite_SetPositionXY
	mov r4, #0x1d
	mov r6, #0
_021F350C:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F11C0
	add r4, r4, #1
	cmp r4, #0x2a
	bls _021F350C
	pop {r4, r5, r6, pc}
_021F351E:
	mov r0, #0x6e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x98
	mov r2, #0x14
	bl ManagedSprite_SetPositionXY
	mov r4, #0x1d
	mov r6, #1
_021F3530:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F11C0
	add r4, r4, #1
	cmp r4, #0x2a
	bls _021F3530
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F34EC

	thumb_func_start ov18_021F3544
ov18_021F3544: ; 0x021F3544
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r6, r1, #0
	mov r4, #1
_021F354C:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F11C0
	add r4, r4, #1
	cmp r4, #0x10
	bls _021F354C
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F3544

	thumb_func_start ov18_021F3560
ov18_021F3560: ; 0x021F3560
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	add r6, r2, #0
	cmp r3, #0
	bne _021F35B4
	add r1, r6, #0
	bl ov18_021F3AD0
	add r1, r0, #0
	add r0, r5, #0
	mov r2, #5
	mov r3, #1
	bl ov18_021F36D4
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F3AD0
	add r1, r0, #0
	add r0, r5, #0
	mov r2, #0xb
	mov r3, #0
	bl ov18_021F36D4
	ldr r2, _021F3614 ; =0x00001850
	add r0, r5, #0
	ldr r3, [r5, r2]
	lsl r2, r6, #2
	ldrh r2, [r3, r2]
	mov r1, #6
	bl ov18_021F38F0
	ldr r2, _021F3614 ; =0x00001850
	add r0, r5, #0
	ldr r3, [r5, r2]
	lsl r2, r4, #2
	ldrh r2, [r3, r2]
	mov r1, #0xc
	bl ov18_021F38F0
	b _021F35FE
_021F35B4:
	add r1, r6, #0
	bl ov18_021F3AD0
	add r1, r0, #0
	add r0, r5, #0
	mov r2, #5
	mov r3, #1
	bl ov18_021F37D4
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F3AD0
	add r1, r0, #0
	add r0, r5, #0
	mov r2, #0xb
	mov r3, #0
	bl ov18_021F37D4
	ldr r2, _021F3614 ; =0x00001850
	add r0, r5, #0
	ldr r3, [r5, r2]
	lsl r2, r6, #2
	add r2, r3, r2
	ldrh r2, [r2, #2]
	mov r1, #6
	bl ov18_021F39C4
	ldr r2, _021F3614 ; =0x00001850
	add r0, r5, #0
	ldr r3, [r5, r2]
	lsl r2, r4, #2
	add r2, r3, r2
	ldrh r2, [r2, #2]
	mov r1, #0xc
	bl ov18_021F39C4
_021F35FE:
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #1
	bl ov18_021F3A64
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #3
	bl ov18_021F3A64
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F3614: .word 0x00001850
	thumb_func_end ov18_021F3560

	thumb_func_start ov18_021F3618
ov18_021F3618: ; 0x021F3618
	push {r4, lr}
	add r4, r0, #0
	cmp r1, #3
	bhi _021F36BE
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
ov18_021F362C: ; jump table
	.short ov18_021F3634 - ov18_021F362C - 2 ; case 0
	.short ov18_021F3644 - ov18_021F362C - 2 ; case 1
	.short ov18_021F3654 - ov18_021F362C - 2 ; case 2
	.short ov18_021F3688 - ov18_021F362C - 2 ; case 3
ov18_021F3634:
	mov r1, #1
	bl ov18_021F34EC
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F3544
	pop {r4, pc}
ov18_021F3644:
	mov r1, #0
	bl ov18_021F34EC
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F3544
	pop {r4, pc}
ov18_021F3654:
	mov r1, #1
	bl ov18_021F34C4
	add r0, r4, #0
	mov r1, #1
	bl ov18_021F3544
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x43
	bl ov18_021F118C
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0x44
	bl ov18_021F118C
	ldr r2, _021F36D0 ; =0x00001878
	add r0, r4, #0
	ldr r1, [r4, r2]
	add r2, r2, #4
	ldr r2, [r4, r2]
	mov r3, #0
	bl ov18_021F3560
	pop {r4, pc}
ov18_021F3688:
	mov r1, #1
	bl ov18_021F34C4
	add r0, r4, #0
	mov r1, #1
	bl ov18_021F3544
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x29
	bl ov18_021F118C
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0x2a
	bl ov18_021F118C
	mov r2, #0x62
	lsl r2, r2, #6
	ldr r1, [r4, r2]
	add r2, r2, #4
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r3, #1
	bl ov18_021F3560
	pop {r4, pc}
_021F36BE:
	add r0, r4, #0
	mov r1, #1
	bl ov18_021F34C4
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F3544
	pop {r4, pc}
	.balign 4, 0
_021F36D0: .word 0x00001878
	thumb_func_end ov18_021F3618

	thumb_func_start ov18_021F36D4
ov18_021F36D4: ; 0x021F36D4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	lsl r6, r2, #2
	mov r0, #0x67
	add r4, r1, #0
	add r1, r5, r6
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r1, #2
	add r2, sp, #4
	str r3, [sp]
	bl ManagedSprite_GetPositionXY
	cmp r4, #0
	bne _021F36FE
	add r1, sp, #4
	mov r0, #2
	ldrsh r4, [r1, r0]
	b _021F370C
_021F36FE:
	cmp r4, #0x34
	bhs _021F3706
	mov r4, #0x34
	b _021F370C
_021F3706:
	cmp r4, #0xcc
	bls _021F370C
	mov r4, #0xcc
_021F370C:
	mov r0, #0x67
	lsl r0, r0, #4
	add r7, r5, r0
	add r1, sp, #4
	ldr r0, [r7, r6]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	lsl r1, r4, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r7, r6]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F37C8 ; =0x00000674
	add r1, sp, #4
	add r7, r5, r0
	ldr r0, [r7, r6]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	add r1, r4, #0
	sub r1, #0x14
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r7, r6]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F37CC ; =0x00000678
	add r1, r5, r6
	ldr r0, [r1, r0]
	add r1, r4, #0
	sub r1, #0xc
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F37D0 ; =0x0000067C
	add r1, r5, r6
	ldr r0, [r1, r0]
	add r1, r4, #4
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0x1a
	add r1, r5, r6
	lsl r0, r0, #6
	ldr r0, [r1, r0]
	add r1, r4, #0
	add r1, #0xc
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, [sp]
	cmp r0, #1
	bne _021F37C4
	mov r0, #0x67
	lsl r0, r0, #4
	add r1, sp, #4
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	mov r0, #0x67
	lsl r0, r0, #4
	lsl r1, r4, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r5, r0]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
_021F37C4:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F37C8: .word 0x00000674
_021F37CC: .word 0x00000678
_021F37D0: .word 0x0000067C
	thumb_func_end ov18_021F36D4

	thumb_func_start ov18_021F37D4
ov18_021F37D4: ; 0x021F37D4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	lsl r6, r2, #2
	mov r0, #0x67
	add r4, r1, #0
	add r1, r5, r6
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r1, #2
	add r2, sp, #4
	str r3, [sp]
	bl ManagedSprite_GetPositionXY
	cmp r4, #0
	bne _021F37FE
	add r1, sp, #4
	mov r0, #2
	ldrsh r4, [r1, r0]
	b _021F380C
_021F37FE:
	cmp r4, #0x34
	bhs _021F3806
	mov r4, #0x34
	b _021F380C
_021F3806:
	cmp r4, #0xcc
	bls _021F380C
	mov r4, #0xcc
_021F380C:
	mov r0, #0x67
	lsl r0, r0, #4
	add r7, r5, r0
	add r1, sp, #4
	ldr r0, [r7, r6]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	lsl r1, r4, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r7, r6]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F38E0 ; =0x00000674
	add r1, sp, #4
	add r7, r5, r0
	ldr r0, [r7, r6]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	add r1, r4, #0
	sub r1, #0x14
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r7, r6]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F38E4 ; =0x00000678
	add r1, r5, r6
	ldr r0, [r1, r0]
	add r1, r4, #0
	sub r1, #0xc
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F38E8 ; =0x0000067C
	add r1, r5, r6
	ldr r0, [r1, r0]
	sub r1, r4, #4
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0x1a
	add r1, r5, r6
	lsl r0, r0, #6
	ldr r0, [r1, r0]
	add r1, r4, #4
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F38EC ; =0x00000684
	add r1, r5, r6
	ldr r0, [r1, r0]
	add r1, r4, #0
	add r1, #0x14
	lsl r1, r1, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, [sp]
	cmp r0, #1
	bne _021F38DA
	mov r0, #0x67
	lsl r0, r0, #4
	add r1, sp, #4
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #4
	bl ManagedSprite_GetPositionXY
	mov r0, #0x67
	lsl r0, r0, #4
	lsl r1, r4, #0x10
	add r3, sp, #4
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r5, r0]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
_021F38DA:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F38E0: .word 0x00000674
_021F38E4: .word 0x00000678
_021F38E8: .word 0x0000067C
_021F38EC: .word 0x00000684
	thumb_func_end ov18_021F37D4

	thumb_func_start ov18_021F38F0
ov18_021F38F0: ; 0x021F38F0
	push {r3, r4, r5, r6, r7, lr}
	ldr r6, _021F39BC ; =0x000003E7
	add r5, r0, #0
	add r4, r1, #0
	cmp r2, r6
	bne _021F3900
	add r6, #0xbd
	b _021F3914
_021F3900:
	ldr r0, _021F39C0 ; =0x00002710
	mov r1, #0xfe
	mul r0, r2
	bl _u32_div_f
	add r0, r0, #5
	mov r1, #0xa
	bl _u32_div_f
	add r6, r0, #0
_021F3914:
	add r0, r6, #0
	mov r1, #0xc
	bl _u32_div_f
	add r7, r0, #0
	add r0, r6, #0
	mov r1, #0xc
	bl _u32_div_f
	add r6, r1, #0
	cmp r7, #0xa
	blo _021F394C
	add r0, r7, #0
	mov r1, #0xa
	bl _u32_div_f
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	add r2, #0x2b
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	b _021F3956
_021F394C:
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
_021F3956:
	add r0, r7, #0
	mov r1, #0xa
	bl _u32_div_f
	add r2, r1, #0
	add r0, r5, #0
	add r1, r4, #1
	add r2, #0x2b
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #1
	bl ov18_021F11C0
	add r0, r6, #0
	mov r1, #0xa
	bl _u32_div_f
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #2
	add r2, #0x2b
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #2
	mov r2, #1
	bl ov18_021F11C0
	add r0, r6, #0
	mov r1, #0xa
	bl _u32_div_f
	add r2, r1, #0
	add r0, r5, #0
	add r1, r4, #3
	add r2, #0x2b
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #3
	mov r2, #1
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #4
	mov r2, #0
	bl ov18_021F11C0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F39BC: .word 0x000003E7
_021F39C0: .word 0x00002710
	thumb_func_end ov18_021F38F0

	thumb_func_start ov18_021F39C4
ov18_021F39C4: ; 0x021F39C4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r1, #0
	add r7, r0, #0
	ldr r1, _021F3A50 ; =0x0000270F
	add r0, r2, #0
	str r2, [sp]
	cmp r0, r1
	bne _021F39DC
	ldr r0, _021F3A54 ; =0x00018696
	str r0, [sp]
	b _021F39EC
_021F39DC:
	ldr r1, _021F3A58 ; =0x00035D2E
	mul r2, r1
	ldr r1, _021F3A5C ; =0x0000C350
	add r0, r2, r1
	lsl r1, r1, #1
	bl _u32_div_f
	str r0, [sp]
_021F39EC:
	mov r0, #0
	ldr r5, _021F3A60 ; =0x00002710
	str r0, [sp, #4]
	add r4, r0, #0
_021F39F4:
	ldr r0, [sp]
	add r1, r5, #0
	bl _u32_div_f
	add r2, r0, #0
	bne _021F3A06
	ldr r0, [sp, #4]
	cmp r0, #1
	bne _021F3A20
_021F3A06:
	mov r0, #1
	str r0, [sp, #4]
	add r0, r7, #0
	add r1, r6, r4
	add r2, #0x2b
	bl ov18_021F118C
	add r0, r7, #0
	add r1, r6, r4
	mov r2, #1
	bl ov18_021F11C0
	b _021F3A2A
_021F3A20:
	add r0, r7, #0
	add r1, r6, r4
	mov r2, #0
	bl ov18_021F11C0
_021F3A2A:
	ldr r0, [sp]
	add r1, r5, #0
	bl _u32_div_f
	str r1, [sp]
	add r0, r5, #0
	mov r1, #0xa
	bl _u32_div_f
	add r5, r0, #0
	cmp r4, #2
	bne _021F3A46
	mov r0, #1
	str r0, [sp, #4]
_021F3A46:
	add r4, r4, #1
	cmp r4, #5
	blo _021F39F4
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F3A50: .word 0x0000270F
_021F3A54: .word 0x00018696
_021F3A58: .word 0x00035D2E
_021F3A5C: .word 0x0000C350
_021F3A60: .word 0x00002710
	thumb_func_end ov18_021F39C4

	thumb_func_start ov18_021F3A64
ov18_021F3A64: ; 0x021F3A64
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	cmp r1, #0
	bne _021F3A82
	add r1, r4, #0
	mov r2, #0x3a
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #0x35
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
_021F3A82:
	cmp r1, #0x98
	bne _021F3A9A
	add r1, r4, #0
	mov r2, #0x38
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #0x37
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
_021F3A9A:
	add r1, r4, #0
	mov r2, #0x38
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #0x35
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F3A64

	thumb_func_start ov18_021F3AB0
ov18_021F3AB0: ; 0x021F3AB0
	push {r3, lr}
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	add r1, sp, #0
	mov r0, #2
	ldrsh r0, [r1, r0]
	sub r0, #0x34
	pop {r3, pc}
	thumb_func_end ov18_021F3AB0

	thumb_func_start ov18_021F3AD0
ov18_021F3AD0: ; 0x021F3AD0
	add r1, #0x34
	add r0, r1, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov18_021F3AD0

	thumb_func_start ov18_021F3AD8
ov18_021F3AD8: ; 0x021F3AD8
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _021F3B24 ; =0x00001860
	add r4, r0, #0
	ldr r1, [r4, r1]
	cmp r1, #1
	bne _021F3B20
	mov r1, #0x11
	mov r2, #1
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0x11
	bl ov18_021F2AC0
	ldr r0, _021F3B28 ; =0x000006B4
	add r1, sp, #0
	ldr r0, [r4, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r0, _021F3B28 ; =0x000006B4
	add r3, sp, #0
	mov r1, #2
	ldrsh r2, [r3, r1]
	mov r1, #0x12
	lsl r1, r1, #4
	sub r1, r2, r1
	mov r2, #0
	lsl r1, r1, #0x10
	ldrsh r2, [r3, r2]
	ldr r0, [r4, r0]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
_021F3B20:
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021F3B24: .word 0x00001860
_021F3B28: .word 0x000006B4
	thumb_func_end ov18_021F3AD8

	thumb_func_start ov18_021F3B2C
ov18_021F3B2C: ; 0x021F3B2C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F3B5C ; =0x000006B4
	add r4, r1, #0
	add r1, sp, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r0, _021F3B5C ; =0x000006B4
	add r3, sp, #0
	mov r1, #2
	ldrsh r1, [r3, r1]
	mov r2, #0
	ldrsh r2, [r3, r2]
	add r1, r1, r4
	lsl r1, r1, #0x10
	ldr r0, [r5, r0]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, pc}
	nop
_021F3B5C: .word 0x000006B4
	thumb_func_end ov18_021F3B2C

	thumb_func_start ov18_021F3B60
ov18_021F3B60: ; 0x021F3B60
	push {r4, r5, r6, lr}
	add r5, r0, #0
	cmp r1, #1
	bne _021F3B88
	mov r4, #0x2c
	mov r6, #1
_021F3B6C:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F11C0
	add r4, r4, #1
	cmp r4, #0x3a
	bls _021F3B6C
	add r0, r5, #0
	mov r1, #0x2b
	mov r2, #0
	bl ov18_021F11C0
	pop {r4, r5, r6, pc}
_021F3B88:
	mov r4, #0x2c
	mov r6, #0
_021F3B8C:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F11C0
	add r4, r4, #1
	cmp r4, #0x3a
	bls _021F3B8C
	add r0, r5, #0
	bl ov18_021F3BA4
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021F3B60

	thumb_func_start ov18_021F3BA4
ov18_021F3BA4: ; 0x021F3BA4
	push {r4, lr}
	ldr r1, _021F3BD0 ; =0x0000188C
	add r4, r0, #0
	ldr r1, [r4, r1]
	cmp r1, #0xe
	bne _021F3BBA
	mov r1, #0x2b
	mov r2, #0
	bl ov18_021F11C0
	pop {r4, pc}
_021F3BBA:
	mov r1, #0x2b
	mov r2, #1
	bl ov18_021F11C0
	ldr r2, _021F3BD0 ; =0x0000188C
	add r0, r4, #0
	ldr r2, [r4, r2]
	mov r1, #0x2b
	bl ov18_021F118C
	pop {r4, pc}
	.balign 4, 0
_021F3BD0: .word 0x0000188C
	thumb_func_end ov18_021F3BA4

	thumb_func_start ov18_021F3BD4
ov18_021F3BD4: ; 0x021F3BD4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x6e
	lsl r0, r0, #4
	add r4, r1, #0
	add r1, sp, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0x6e
	lsl r0, r0, #4
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	mov r1, #2
	ldrsh r1, [r3, r1]
	add r2, r2, r4
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, _021F3C2C ; =0x0000071C
	add r1, sp, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r0, _021F3C2C ; =0x0000071C
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	mov r1, #2
	ldrsh r1, [r3, r1]
	add r2, r2, r4
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F3C2C: .word 0x0000071C
	thumb_func_end ov18_021F3BD4

	thumb_func_start ov18_021F3C30
ov18_021F3C30: ; 0x021F3C30
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F3C50 ; =0x000006D4
	mov r1, #0x30
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x90
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	mov r1, #0x19
	mov r2, #1
	bl ov18_021F11C0
	pop {r4, pc}
	nop
_021F3C50: .word 0x000006D4
	thumb_func_end ov18_021F3C30

	thumb_func_start ov18_021F3C54
ov18_021F3C54: ; 0x021F3C54
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F3C84 ; =0x000006D4
	add r4, r1, #0
	add r1, sp, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r0, _021F3C84 ; =0x000006D4
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	mov r1, #2
	ldrsh r1, [r3, r1]
	add r2, r2, r4
	lsl r2, r2, #0x10
	ldr r0, [r5, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, pc}
	nop
_021F3C84: .word 0x000006D4
	thumb_func_end ov18_021F3C54

	thumb_func_start ov18_021F3C88
ov18_021F3C88: ; 0x021F3C88
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F3CA4 ; =0x000006D4
	mov r1, #0x30
	ldr r0, [r4, r0]
	mov r2, #0x18
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	mov r1, #0x19
	mov r2, #1
	bl ov18_021F11C0
	pop {r4, pc}
	.balign 4, 0
_021F3CA4: .word 0x000006D4
	thumb_func_end ov18_021F3C88

	thumb_func_start ov18_021F3CA8
ov18_021F3CA8: ; 0x021F3CA8
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	add r0, r2, #0
	ldr r2, _021F3D30 ; =0x000018A4
	add r5, r3, #0
	add r6, r4, r2
	ldrb r3, [r6, r1]
	mov r7, #0x80
	add r2, r3, #0
	tst r2, r7
	beq _021F3D0C
	ldr r1, _021F3D30 ; =0x000018A4
	sub r1, r1, #2
	ldrh r1, [r4, r1]
	cmp r1, #0xac
	bne _021F3CF2
	add r1, r3, #0
	eor r1, r7
	beq _021F3CD8
	cmp r1, #1
	beq _021F3CE0
	cmp r1, #2
	beq _021F3CEA
	pop {r3, r4, r5, r6, r7, pc}
_021F3CD8:
	mov r1, #0
	strb r1, [r0]
	strb r1, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_021F3CE0:
	mov r1, #0
	strb r1, [r0]
	mov r0, #1
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_021F3CEA:
	mov r1, #1
	strb r1, [r0]
	strb r1, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_021F3CF2:
	add r1, r3, #0
	eor r1, r7
	strb r1, [r0]
	ldr r1, _021F3D30 ; =0x000018A4
	ldr r0, [r4]
	sub r1, r1, #2
	ldrh r1, [r4, r1]
	ldr r0, [r0]
	mov r2, #0
	bl Pokedex_SpeciesGetLastSeenGender
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_021F3D0C:
	mov r2, #0
	strb r2, [r0]
	ldrb r0, [r6, r1]
	cmp r0, #1
	beq _021F3D1E
	cmp r0, #2
	beq _021F3D22
	cmp r0, #3
	b _021F3D28
_021F3D1E:
	strb r2, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_021F3D22:
	mov r0, #1
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_021F3D28:
	mov r0, #2
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F3D30: .word 0x000018A4
	thumb_func_end ov18_021F3CA8

	thumb_func_start ov18_021F3D34
ov18_021F3D34: ; 0x021F3D34
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F2648
	ldr r1, _021F3D64 ; =0x00000668
	ldr r2, _021F3D68 ; =ov18_021FA554
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	bl SpriteSystem_NewSprite
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	mov r1, #4
	bl ManagedSprite_SetPaletteOverride
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov18_021F11C0
	pop {r4, pc}
	.balign 4, 0
_021F3D64: .word 0x00000668
_021F3D68: .word ov18_021FA554
	thumb_func_end ov18_021F3D34

	thumb_func_start ov18_021F3D6C
ov18_021F3D6C: ; 0x021F3D6C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov18_021F10E8
	add r0, r4, #0
	bl ov18_021F26E4
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F3D6C

	thumb_func_start ov18_021F3D80
ov18_021F3D80: ; 0x021F3D80
	push {r3, lr}
	add r2, r1, #0
	lsl r2, r2, #6
	add r2, #0x20
	lsl r2, r2, #0x10
	mov r1, #0
	asr r2, r2, #0x10
	mov r3, #0xb0
	str r1, [sp]
	bl ov18_021F1294
	pop {r3, pc}
	thumb_func_end ov18_021F3D80

	thumb_func_start ov18_021F3D98
ov18_021F3D98: ; 0x021F3D98
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	bl ov18_021F3E24
	mov r6, #1
	mov r4, #0x34
	add r5, r7, #4
_021F3DA6:
	add r2, r4, #0
	ldr r1, _021F3E00 ; =ov18_021FA610
	sub r2, #0x34
	add r0, r7, #0
	add r1, r1, r2
	bl ov18_021F11EC
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r6, r6, #1
	add r4, #0x34
	add r5, r5, #4
	cmp r6, #8
	bls _021F3DA6
	add r0, r7, #0
	mov r1, #1
	bl ov18_021F69C0
	add r2, sp, #0
	add r0, r7, #0
	mov r1, #0
	add r2, #1
	add r3, sp, #0
	bl ov18_021F3CA8
	ldr r1, _021F3E04 ; =0x000018A2
	add r2, sp, #0
	ldrh r1, [r7, r1]
	ldrb r2, [r2, #1]
	add r0, r7, #0
	mov r3, #1
	bl ov18_021F1534
	add r0, r7, #0
	bl ov18_021F40E4
	add r0, r7, #0
	bl ov18_021F40A0
	add r0, r7, #0
	bl ov18_021F4188
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F3E00: .word ov18_021FA610
_021F3E04: .word 0x000018A2
	thumb_func_end ov18_021F3D98

	thumb_func_start ov18_021F3E08
ov18_021F3E08: ; 0x021F3E08
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #1
_021F3E0E:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F10E8
	add r4, r4, #1
	cmp r4, #0x3b
	blo _021F3E0E
	add r0, r5, #0
	bl ov18_021F3FDC
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F3E08

	thumb_func_start ov18_021F3E24
ov18_021F3E24: ; 0x021F3E24
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F3FB0 ; =0x0000C550
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F3FB8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	bl sub_02074490
	ldr r2, _021F3FBC ; =0x00000858
	ldr r3, _021F3FB4 ; =0x00000668
	ldr r1, [r4, r2]
	sub r2, #8
	str r1, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r1, #3
	str r1, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F3FC0 ; =0x0000C551
	str r0, [sp, #0x14]
	ldr r0, [r4, r2]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r3, [r4, r3]
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	bl sub_0207449C
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F3FB0 ; =0x0000C550
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F3FBC ; =0x00000858
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	bl sub_020744A8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F3FB0 ; =0x0000C550
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F3FBC ; =0x00000858
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F3FC4 ; =0x0000C59C
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F3FB8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x73
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F3FB8 ; =0x00000854
	ldr r3, _021F3FB4 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x76
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F3FC8 ; =0x0000C55E
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3FCC ; =0x0000C55A
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F3FB8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x74
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3FCC ; =0x0000C55A
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F3FB8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x75
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F3FD0 ; =0x0000C59A
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F3FB8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x77
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F3FB8 ; =0x00000854
	ldr r3, _021F3FB4 ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x7a
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #2
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, _021F3FD4 ; =0x0000C55C
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3FD8 ; =0x0000C559
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F3FB8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x78
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3FD8 ; =0x0000C559
	ldr r1, _021F3FB4 ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F3FB8 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x79
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	nop
_021F3FB0: .word 0x0000C550
_021F3FB4: .word 0x00000668
_021F3FB8: .word 0x00000854
_021F3FBC: .word 0x00000858
_021F3FC0: .word 0x0000C551
_021F3FC4: .word 0x0000C59C
_021F3FC8: .word 0x0000C55E
_021F3FCC: .word 0x0000C55A
_021F3FD0: .word 0x0000C59A
_021F3FD4: .word 0x0000C55C
_021F3FD8: .word 0x0000C559
	thumb_func_end ov18_021F3E24

	thumb_func_start ov18_021F3FDC
ov18_021F3FDC: ; 0x021F3FDC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4060 ; =0x0000C550
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4064 ; =0x0000C551
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4060 ; =0x0000C550
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4060 ; =0x0000C550
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4068 ; =0x0000C59C
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F406C ; =0x0000C55E
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4070 ; =0x0000C55A
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4070 ; =0x0000C55A
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4074 ; =0x0000C59A
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F4078 ; =0x0000C55C
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F407C ; =0x0000C559
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F405C ; =0x0000066C
	ldr r1, _021F407C ; =0x0000C559
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	nop
_021F405C: .word 0x0000066C
_021F4060: .word 0x0000C550
_021F4064: .word 0x0000C551
_021F4068: .word 0x0000C59C
_021F406C: .word 0x0000C55E
_021F4070: .word 0x0000C55A
_021F4074: .word 0x0000C59A
_021F4078: .word 0x0000C55C
_021F407C: .word 0x0000C559
	thumb_func_end ov18_021F3FDC

	thumb_func_start ov18_021F4080
ov18_021F4080: ; 0x021F4080
	push {r3, lr}
	mov r1, #1
	str r1, [sp]
	ldr r3, _021F409C ; =0x000018C9
	mov r1, #4
	ldrsb r3, [r0, r3]
	mov r2, #0x20
	lsl r3, r3, #5
	add r3, #0x4c
	lsl r3, r3, #0x10
	asr r3, r3, #0x10
	bl ov18_021F1294
	pop {r3, pc}
	.balign 4, 0
_021F409C: .word 0x000018C9
	thumb_func_end ov18_021F4080

	thumb_func_start ov18_021F40A0
ov18_021F40A0: ; 0x021F40A0
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #9
	mov r2, #0x19
	str r1, [sp]
	add r4, r0, #0
	lsl r2, r2, #8
	ldr r2, [r4, r2]
	ldr r3, _021F40DC ; =ov18_021FA35A
	lsl r2, r2, #0x18
	mov r1, #5
	asr r2, r2, #0x18
	bl ov18_021F61DC
	add r0, r4, #0
	bl ov18_021F65EC
	ldr r2, _021F40E0 ; =0x000018CA
	add r0, r4, #0
	ldrsb r1, [r4, r2]
	add r2, #0x36
	ldr r2, [r4, r2]
	mov r3, #6
	lsl r2, r2, #0x18
	asr r2, r2, #0x18
	bl ov18_021F619C
	add sp, #4
	pop {r3, r4, pc}
	nop
_021F40DC: .word ov18_021FA35A
_021F40E0: .word 0x000018CA
	thumb_func_end ov18_021F40A0

	thumb_func_start ov18_021F40E4
ov18_021F40E4: ; 0x021F40E4
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r3, [r4]
	ldr r1, [r3, #0x10]
	asr r0, r1, #4
	lsr r0, r0, #0x1b
	add r0, r1, r0
	lsl r0, r0, #0xb
	ldr r1, [r3, #0x14]
	lsr r2, r0, #0x10
	asr r0, r1, #4
	lsr r0, r0, #0x1b
	add r0, r1, r0
	lsl r0, r0, #0xb
	lsr r3, r0, #0x10
	cmp r2, #0x17
	blo _021F410E
	sub r2, #0x16
	lsl r0, r2, #0x10
	lsr r2, r0, #0x10
_021F410E:
	lsl r2, r2, #3
	lsl r3, r3, #3
	add r2, #0x44
	add r3, #0x2c
	lsl r2, r2, #0x10
	lsl r3, r3, #0x10
	mov r1, #2
	add r0, r4, #0
	asr r2, r2, #0x10
	asr r3, r3, #0x10
	str r1, [sp]
	bl ov18_021F1294
	add r0, r4, #0
	bl ov18_021F4134
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F40E4

	thumb_func_start ov18_021F4134
ov18_021F4134: ; 0x021F4134
	push {r3, lr}
	ldr r1, _021F4184 ; =0x000018C8
	ldrsb r1, [r0, r1]
	cmp r1, #0
	ldr r1, [r0]
	bne _021F4162
	ldr r2, [r1, #0x10]
	asr r1, r2, #4
	lsr r1, r1, #0x1b
	add r1, r2, r1
	asr r1, r1, #5
	cmp r1, #0x17
	blt _021F4158
	mov r1, #2
	mov r2, #0
	bl ov18_021F11C0
	pop {r3, pc}
_021F4158:
	mov r1, #2
	mov r2, #1
	bl ov18_021F11C0
	pop {r3, pc}
_021F4162:
	ldr r2, [r1, #0x10]
	asr r1, r2, #4
	lsr r1, r1, #0x1b
	add r1, r2, r1
	asr r1, r1, #5
	cmp r1, #0x17
	blt _021F417A
	mov r1, #2
	mov r2, #1
	bl ov18_021F11C0
	pop {r3, pc}
_021F417A:
	mov r1, #2
	mov r2, #0
	bl ov18_021F11C0
	pop {r3, pc}
	.balign 4, 0
_021F4184: .word 0x000018C8
	thumb_func_end ov18_021F4134

	thumb_func_start ov18_021F4188
ov18_021F4188: ; 0x021F4188
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r5, #0
	mov r7, #0x67
	mov r4, #9
	add r6, #0x24
	lsl r7, r7, #4
_021F4196:
	ldr r1, _021F41C0 ; =ov18_021FA4B8
	add r0, r5, #0
	bl ov18_021F11EC
	str r0, [r6, r7]
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F1160
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	add r4, r4, #1
	add r6, r6, #4
	cmp r4, #0x3b
	blo _021F4196
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F41C0: .word ov18_021FA4B8
	thumb_func_end ov18_021F4188

	thumb_func_start ov18_021F41C4
ov18_021F41C4: ; 0x021F41C4
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r0, r5, #0
	add r7, r2, #0
	str r3, [sp]
	ldr r4, [sp, #0x18]
	bl ov18_021E8B24
	cmp r0, #1
	bne _021F41E4
	mov r0, #0x20
	mov r1, #4
	mov r2, #1
	mov r3, #3
	b _021F422C
_021F41E4:
	add r0, r5, #0
	bl ov18_021E8B0C
	cmp r0, #0x12
	bne _021F4204
	mov r0, #0x24
	add r1, r5, #0
	mul r1, r0
	ldr r0, _021F42DC ; =0x0000190C
	mov r3, #2
	ldr r2, [r6, r0]
	ldrb r0, [r2, r1]
	add r1, r2, r1
	ldrb r1, [r1, #1]
	mov r2, #1
	b _021F422C
_021F4204:
	add r0, r5, #0
	bl ov18_021E8B5C
	cmp r0, #1
	bne _021F4218
	mov r0, #0x23
	mov r1, #8
	mov r2, #2
	mov r3, #1
	b _021F422C
_021F4218:
	mov r0, #0x24
	add r1, r5, #0
	mul r1, r0
	ldr r0, _021F42DC ; =0x0000190C
	ldr r2, [r6, r0]
	add r3, r2, r1
	ldrb r0, [r2, r1]
	ldrb r1, [r3, #1]
	ldrb r2, [r3, #2]
	ldrb r3, [r3, #3]
_021F422C:
	cmp r2, #1
	bne _021F4262
	cmp r3, #1
	bne _021F423A
	mov r5, #0
	strb r5, [r4]
	b _021F42AC
_021F423A:
	cmp r3, #2
	bne _021F4244
	mov r5, #6
	strb r5, [r4]
	b _021F42AC
_021F4244:
	cmp r3, #3
	bne _021F424E
	mov r5, #7
	strb r5, [r4]
	b _021F42AC
_021F424E:
	cmp r3, #4
	bne _021F4258
	mov r5, #8
	strb r5, [r4]
	b _021F42AC
_021F4258:
	cmp r3, #5
	bne _021F42AC
	mov r5, #9
	strb r5, [r4]
	b _021F42AC
_021F4262:
	cmp r2, #2
	bne _021F4276
	cmp r3, #1
	bne _021F4270
	mov r5, #1
	strb r5, [r4]
	b _021F42AC
_021F4270:
	mov r5, #0xa
	strb r5, [r4]
	b _021F42AC
_021F4276:
	cmp r2, #3
	bne _021F428A
	cmp r3, #1
	bne _021F4284
	mov r5, #2
	strb r5, [r4]
	b _021F42AC
_021F4284:
	mov r5, #0xb
	strb r5, [r4]
	b _021F42AC
_021F428A:
	cmp r2, #4
	bne _021F4294
	mov r5, #3
	strb r5, [r4]
	b _021F42AC
_021F4294:
	cmp r2, #5
	bne _021F429E
	mov r5, #4
	strb r5, [r4]
	b _021F42AC
_021F429E:
	cmp r2, #6
	bne _021F42A8
	mov r5, #5
	strb r5, [r4]
	b _021F42AC
_021F42A8:
	mov r5, #0
	strb r5, [r4]
_021F42AC:
	lsl r4, r2, #3
	lsr r2, r4, #0x1f
	add r2, r4, r2
	ldr r4, _021F42E0 ; =0x000018C8
	asr r2, r2, #1
	ldrsb r5, [r6, r4]
	mov r4, #0x16
	mul r4, r5
	sub r0, r0, r4
	lsl r0, r0, #3
	add r0, r2, r0
	add r0, #0x40
	lsl r2, r1, #3
	lsl r1, r3, #3
	strh r0, [r7]
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	add r1, r2, r0
	ldr r0, [sp]
	add r1, #0x28
	strh r1, [r0]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F42DC: .word 0x0000190C
_021F42E0: .word 0x000018C8
	thumb_func_end ov18_021F41C4

	thumb_func_start ov18_021F42E4
ov18_021F42E4: ; 0x021F42E4
	push {r3, r4, r5, r6, r7, lr}
	add r6, r2, #0
	ldr r2, _021F437C ; =0x00001908
	mov ip, r1
	ldr r2, [r0, r2]
	lsl r1, r1, #2
	ldrb r7, [r2, r1]
	ldr r2, _021F437C ; =0x00001908
	add r4, r3, #0
	sub r2, #0x40
	ldrsb r3, [r0, r2]
	mov r2, #0x16
	ldr r5, [sp, #0x18]
	mul r2, r3
	sub r2, r7, r2
	lsl r2, r2, #3
	add r2, #0x44
	strh r2, [r6]
	ldr r2, _021F437C ; =0x00001908
	ldr r0, [r0, r2]
	add r0, r0, r1
	ldrb r0, [r0, #1]
	lsl r0, r0, #3
	add r0, #0x2c
	strh r0, [r4]
	mov r0, ip
	bl ov18_021E8B18
	cmp r0, #0x7c
	beq _021F4328
	add r1, r0, #0
	sub r1, #0xb2
	cmp r1, #1
	bhi _021F4336
_021F4328:
	mov r0, #6
	strb r0, [r5]
	mov r0, #0
	ldrsh r0, [r4, r0]
	add r0, r0, #4
	strh r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_021F4336:
	cmp r0, #0x60
	beq _021F4340
	ldr r2, _021F4380 ; =0x000001E7
	cmp r0, r2
	bne _021F4352
_021F4340:
	mov r1, #0
	strb r1, [r5]
	ldrsh r0, [r6, r1]
	add r0, r0, #4
	strh r0, [r6]
	ldrsh r0, [r4, r1]
	add r0, r0, #4
	strh r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_021F4352:
	cmp r0, #0x71
	beq _021F4366
	add r1, r2, #0
	sub r1, #0xac
	cmp r0, r1
	beq _021F4366
	add r1, r2, #3
	sub r0, r0, r1
	cmp r0, #2
	bhi _021F4374
_021F4366:
	mov r0, #6
	strb r0, [r5]
	mov r0, #0
	ldrsh r0, [r4, r0]
	add r0, r0, #4
	strh r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_021F4374:
	mov r0, #0
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F437C: .word 0x00001908
_021F4380: .word 0x000001E7
	thumb_func_end ov18_021F42E4

	thumb_func_start ov18_021F4384
ov18_021F4384: ; 0x021F4384
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	mov r1, #0
	add r3, sp, #0xc
	str r1, [sp, #4]
	mov r1, #2
	add r2, sp, #0x10
	add r3, #2
	add r5, r0, #0
	str r1, [sp]
	bl ov18_021F12C8
	mov r0, #0
	str r0, [sp, #0x14]
	ldr r0, _021F4610 ; =0x000018CA
	ldrsb r1, [r5, r0]
	cmp r1, #0
	bne _021F44A8
	add r0, #0x36
	ldr r0, [r5, r0]
	mov r4, #1
	cmp r0, #1
	ble ov18_021F4478
	add r6, sp, #8
_021F43B4:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021E8AB0
	cmp r0, #0
	add r0, sp, #8
	bne _021F43DA
	ldr r1, _021F4614 ; =0x000018FC
	str r0, [sp]
	ldr r2, [r5, r1]
	lsl r1, r4, #2
	ldr r1, [r2, r1]
	add r3, sp, #8
	add r0, r5, #0
	add r2, sp, #0xc
	add r3, #2
	bl ov18_021F41C4
	b _021F4400
_021F43DA:
	ldr r1, _021F4614 ; =0x000018FC
	str r0, [sp]
	ldr r1, [r5, r1]
	lsl r7, r4, #2
	add r3, sp, #8
	ldr r1, [r1, r7]
	add r0, r5, #0
	add r2, sp, #0xc
	add r3, #2
	bl ov18_021F42E4
	ldr r0, _021F4614 ; =0x000018FC
	ldr r0, [r5, r0]
	ldr r0, [r0, r7]
	bl ov18_021E8B18
	add r1, sp, #0x14
	bl ov18_021F47C0
_021F4400:
	mov r0, #2
	str r0, [sp]
	mov r2, #4
	mov r3, #2
	add r7, r4, #0
	add r7, #8
	ldrsh r2, [r6, r2]
	ldrsh r3, [r6, r3]
	add r0, r5, #0
	add r1, r7, #0
	bl ov18_021F1294
	ldrb r2, [r6]
	add r0, r5, #0
	add r1, r7, #0
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r7, #0
	mov r2, #1
	bl ov18_021F11C0
	ldrb r0, [r6]
	lsl r1, r0, #1
	ldr r0, _021F4618 ; =ov18_021FA3B0
	add r3, r0, r1
	ldrb r0, [r0, r1]
	lsr r2, r0, #1
	mov r0, #4
	ldrsh r1, [r6, r0]
	mov r0, #8
	ldrsh r7, [r6, r0]
	sub r0, r1, r2
	cmp r7, r0
	blt _021F4468
	add r0, r1, r2
	cmp r7, r0
	bge _021F4468
	ldrb r0, [r3, #1]
	lsr r2, r0, #1
	mov r0, #2
	ldrsh r1, [r6, r0]
	mov r0, #6
	ldrsh r0, [r6, r0]
	sub r3, r1, r2
	cmp r0, r3
	blt _021F4468
	add r1, r1, r2
	cmp r0, r1
	bge _021F4468
	mov r0, #1
	str r0, [sp, #4]
_021F4468:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	mov r0, #0x19
	lsl r0, r0, #8
	ldr r0, [r5, r0]
	cmp r4, r0
	blt _021F43B4
ov18_021F4478:
	add r4, #8
	ldr r1, [sp, #0x14]
	add r0, r5, #0
	add r2, r4, #0
	bl ov18_021F47F8
	ldr r0, [sp, #4]
	cmp r0, #0
	bne _021F4490
	ldr r0, [sp, #0x14]
	cmp r0, #0
	bne _021F4492
_021F4490:
	b _021F4602
_021F4492:
	add r1, r4, #0
	add r4, sp, #8
	mov r2, #8
	mov r3, #6
	ldrsh r2, [r4, r2]
	ldrsh r3, [r4, r3]
	add r0, r5, #0
	bl ov18_021F4974
	str r0, [sp, #4]
	b _021F4602
_021F44A8:
	add r0, r5, #0
	bl ov18_021F4620
	ldr r1, _021F4610 ; =0x000018CA
	add r0, r5, #0
	ldrsb r1, [r5, r1]
	bl ov18_021E8AB0
	cmp r0, #0
	add r0, sp, #8
	ldr r1, _021F4614 ; =0x000018FC
	bne _021F4542
	str r0, [sp]
	ldr r2, [r5, r1]
	sub r1, #0x32
	ldrsb r1, [r5, r1]
	add r3, sp, #8
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	add r2, sp, #0xc
	add r3, #2
	bl ov18_021F41C4
	mov r4, #2
	str r4, [sp]
	add r3, sp, #8
	mov r2, #4
	ldrsh r2, [r3, r2]
	ldrsh r3, [r3, r4]
	add r0, r5, #0
	mov r1, #9
	bl ov18_021F1294
	add r2, sp, #8
	ldrb r2, [r2]
	add r0, r5, #0
	mov r1, #9
	bl ov18_021F118C
	add r0, r5, #0
	mov r1, #9
	mov r2, #1
	bl ov18_021F11C0
	add r0, sp, #8
	ldrb r1, [r0]
	lsl r4, r1, #1
	ldr r1, _021F4618 ; =ov18_021FA3B0
	ldrb r1, [r1, r4]
	lsr r3, r1, #1
	mov r1, #4
	ldrsh r2, [r0, r1]
	mov r1, #8
	ldrsh r1, [r0, r1]
	sub r6, r2, r3
	cmp r1, r6
	blt _021F4602
	add r2, r2, r3
	cmp r1, r2
	bge _021F4602
	ldr r1, _021F461C ; =ov18_021FA3B0 + 1
	mov r2, #2
	ldrb r1, [r1, r4]
	ldrsh r3, [r0, r2]
	mov r2, #6
	ldrsh r2, [r0, r2]
	lsr r1, r1, #1
	sub r0, r3, r1
	cmp r2, r0
	blt _021F4602
	add r0, r3, r1
	cmp r2, r0
	bge _021F4602
	mov r0, #1
	str r0, [sp, #4]
	b _021F4602
_021F4542:
	str r0, [sp]
	ldr r2, [r5, r1]
	sub r1, #0x32
	ldrsb r1, [r5, r1]
	add r3, sp, #8
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	add r2, sp, #0xc
	add r3, #2
	bl ov18_021F42E4
	ldr r0, _021F4614 ; =0x000018FC
	ldr r1, [r5, r0]
	sub r0, #0x32
	ldrsb r0, [r5, r0]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl ov18_021E8B18
	add r1, sp, #0x14
	bl ov18_021F47C0
	mov r4, #2
	str r4, [sp]
	add r3, sp, #8
	mov r2, #4
	ldrsh r2, [r3, r2]
	ldrsh r3, [r3, r4]
	add r0, r5, #0
	mov r1, #9
	bl ov18_021F1294
	add r2, sp, #8
	ldrb r2, [r2]
	add r0, r5, #0
	mov r1, #9
	bl ov18_021F118C
	add r0, r5, #0
	mov r1, #9
	mov r2, #1
	bl ov18_021F11C0
	add r0, sp, #8
	ldrb r1, [r0]
	lsl r4, r1, #1
	ldr r1, _021F4618 ; =ov18_021FA3B0
	ldrb r1, [r1, r4]
	lsr r3, r1, #1
	mov r1, #4
	ldrsh r2, [r0, r1]
	mov r1, #8
	ldrsh r1, [r0, r1]
	sub r6, r2, r3
	cmp r1, r6
	blt _021F45D8
	add r2, r2, r3
	cmp r1, r2
	bge _021F45D8
	ldr r1, _021F461C ; =ov18_021FA3B0 + 1
	mov r2, #2
	ldrb r1, [r1, r4]
	ldrsh r3, [r0, r2]
	mov r2, #6
	ldrsh r2, [r0, r2]
	lsr r1, r1, #1
	sub r0, r3, r1
	cmp r2, r0
	blt _021F45D8
	add r0, r3, r1
	cmp r2, r0
	bge _021F45D8
	mov r0, #1
	str r0, [sp, #4]
_021F45D8:
	ldr r1, [sp, #0x14]
	add r0, r5, #0
	mov r2, #0xa
	bl ov18_021F47F8
	ldr r0, [sp, #4]
	cmp r0, #0
	bne _021F4602
	ldr r0, [sp, #0x14]
	cmp r0, #0
	beq _021F4602
	add r4, sp, #8
	mov r2, #8
	mov r3, #6
	ldrsh r2, [r4, r2]
	ldrsh r3, [r4, r3]
	add r0, r5, #0
	mov r1, #0xa
	bl ov18_021F4974
	str r0, [sp, #4]
_021F4602:
	ldr r1, [sp, #4]
	add r0, r5, #0
	bl ov18_021F69C0
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F4610: .word 0x000018CA
_021F4614: .word 0x000018FC
_021F4618: .word ov18_021FA3B0
_021F461C: .word ov18_021FA3B0 + 1
	thumb_func_end ov18_021F4384

	thumb_func_start ov18_021F4620
ov18_021F4620: ; 0x021F4620
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r4, #9
	mov r6, #0
_021F4628:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov18_021F11C0
	add r4, r4, #1
	cmp r4, #0x3b
	blo _021F4628
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F4620

	thumb_func_start ov18_021F463C
ov18_021F463C: ; 0x021F463C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	mov r1, #0
	str r1, [sp, #8]
	str r1, [sp, #4]
	ldr r1, _021F47B0 ; =0x000018CA
	add r5, r0, #0
	ldrsb r2, [r5, r1]
	cmp r2, #0
	bne _021F470A
	add r1, #0x36
	ldr r0, [r5, r1]
	mov r4, #1
	cmp r0, #1
	ble ov18_021F46EC
	ldr r7, _021F47B4 ; =0x000018CB
	add r6, r7, #0
_021F465E:
	ldrb r2, [r5, r6]
	add r0, r5, #0
	add r1, r4, #0
	lsl r2, r2, #0x19
	lsr r2, r2, #0x1f
	bl ov18_021E8ACC
	cmp r0, #0
	beq _021F4694
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x69
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldrb r1, [r5, r7]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1f
	add r1, r1, #4
	bl ManagedSprite_SetPaletteOverride
	add r1, r4, #0
	add r0, r5, #0
	add r1, #8
	mov r2, #1
	bl ov18_021F11C0
	b _021F46BE
_021F4694:
	add r1, r4, #0
	add r0, r5, #0
	add r1, #8
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021E8AB0
	cmp r0, #0
	beq _021F46BE
	ldr r0, _021F47B8 ; =0x000018FC
	ldr r1, [r5, r0]
	lsl r0, r4, #2
	ldr r0, [r1, r0]
	bl ov18_021E8B18
	add r1, sp, #4
	bl ov18_021F47C0
_021F46BE:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021E8AB0
	cmp r0, #0
	beq _021F46DC
	ldr r0, _021F47B8 ; =0x000018FC
	ldr r1, [r5, r0]
	lsl r0, r4, #2
	ldr r0, [r1, r0]
	bl ov18_021E8B18
	add r1, sp, #8
	bl ov18_021F47C0
_021F46DC:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	mov r0, #0x19
	lsl r0, r0, #8
	ldr r0, [r5, r0]
	cmp r4, r0
	blt _021F465E
ov18_021F46EC:
	ldr r0, _021F47B4 ; =0x000018CB
	add r4, #8
	ldrb r0, [r5, r0]
	add r3, r4, #0
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1f
	add r0, r0, #4
	str r0, [sp]
	ldr r1, [sp, #8]
	ldr r2, [sp, #4]
	add r0, r5, #0
	bl ov18_021F48AC
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021F470A:
	bl ov18_021F4620
	ldr r2, _021F47B0 ; =0x000018CA
	add r0, r5, #0
	ldrsb r1, [r5, r2]
	add r2, r2, #1
	ldrb r2, [r5, r2]
	lsl r2, r2, #0x19
	lsr r2, r2, #0x1f
	bl ov18_021E8ACC
	cmp r0, #0
	beq _021F4742
	ldr r1, _021F47B4 ; =0x000018CB
	ldr r0, _021F47BC ; =0x00000694
	ldrb r1, [r5, r1]
	ldr r0, [r5, r0]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1f
	add r1, r1, #4
	bl ManagedSprite_SetPaletteOverride
	add r0, r5, #0
	mov r1, #9
	mov r2, #1
	bl ov18_021F11C0
	b _021F4770
_021F4742:
	add r0, r5, #0
	mov r1, #9
	mov r2, #0
	bl ov18_021F11C0
	ldr r1, _021F47B0 ; =0x000018CA
	add r0, r5, #0
	ldrsb r1, [r5, r1]
	bl ov18_021E8AB0
	cmp r0, #0
	beq _021F4770
	ldr r0, _021F47B8 ; =0x000018FC
	ldr r1, [r5, r0]
	sub r0, #0x32
	ldrsb r0, [r5, r0]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl ov18_021E8B18
	add r1, sp, #4
	bl ov18_021F47C0
_021F4770:
	ldr r1, _021F47B0 ; =0x000018CA
	add r0, r5, #0
	ldrsb r1, [r5, r1]
	bl ov18_021E8AB0
	cmp r0, #0
	beq _021F4794
	ldr r0, _021F47B8 ; =0x000018FC
	ldr r1, [r5, r0]
	sub r0, #0x32
	ldrsb r0, [r5, r0]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl ov18_021E8B18
	add r1, sp, #8
	bl ov18_021F47C0
_021F4794:
	ldr r0, _021F47B4 ; =0x000018CB
	mov r3, #0xa
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1f
	add r0, r0, #4
	str r0, [sp]
	ldr r1, [sp, #8]
	ldr r2, [sp, #4]
	add r0, r5, #0
	bl ov18_021F48AC
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F47B0: .word 0x000018CA
_021F47B4: .word 0x000018CB
_021F47B8: .word 0x000018FC
_021F47BC: .word 0x00000694
	thumb_func_end ov18_021F463C

	thumb_func_start ov18_021F47C0
ov18_021F47C0: ; 0x021F47C0
	cmp r0, #0x6a
	bne _021F47CE
	ldr r2, [r1]
	mov r0, #1
	orr r0, r2
	str r0, [r1]
	bx lr
_021F47CE:
	cmp r0, #0x78
	beq _021F47DA
	add r2, r0, #0
	sub r2, #0xed
	cmp r2, #2
	bhi _021F47E4
_021F47DA:
	ldr r2, [r1]
	mov r0, #2
	orr r0, r2
	str r0, [r1]
	bx lr
_021F47E4:
	cmp r0, #0x7b
	beq _021F47EC
	cmp r0, #0xb0
	bne _021F47F4
_021F47EC:
	ldr r2, [r1]
	mov r0, #4
	orr r0, r2
	str r0, [r1]
_021F47F4:
	bx lr
	.balign 4, 0
	thumb_func_end ov18_021F47C0

	thumb_func_start ov18_021F47F8
ov18_021F47F8: ; 0x021F47F8
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r6, r1, #0
	mov r1, #1
	add r5, r0, #0
	add r4, r2, #0
	tst r1, r6
	beq _021F482C
	mov r1, #2
	str r1, [sp]
	add r1, r4, #0
	mov r2, #0x94
	mov r3, #0x4c
	bl ov18_021F1294
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	add r4, r4, #1
_021F482C:
	mov r0, #2
	add r1, r6, #0
	tst r1, r0
	beq _021F4858
	str r0, [sp]
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0xec
	mov r3, #0x4c
	bl ov18_021F1294
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	add r4, r4, #1
_021F4858:
	mov r0, #4
	tst r0, r6
	beq _021F48A6
	mov r0, #2
	str r0, [sp]
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0xe4
	mov r3, #0x5c
	bl ov18_021F1294
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	mov r0, #2
	str r0, [sp]
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #0xdc
	mov r3, #0x7c
	bl ov18_021F1294
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #0
	bl ov18_021F118C
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #1
	bl ov18_021F11C0
_021F48A6:
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F47F8

	thumb_func_start ov18_021F48AC
ov18_021F48AC: ; 0x021F48AC
	push {r3, r4, r5, r6, r7, lr}
	add r7, r2, #0
	mov r2, #1
	add r5, r0, #0
	add r6, r1, #0
	add r4, r3, #0
	tst r1, r2
	beq _021F48E4
	add r1, r7, #0
	tst r1, r2
	beq _021F48CC
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	b _021F48E2
_021F48CC:
	add r1, r4, #0
	bl ov18_021F11C0
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r1, [sp, #0x18]
	bl ManagedSprite_SetPaletteOverride
_021F48E2:
	add r4, r4, #1
_021F48E4:
	mov r0, #2
	add r1, r6, #0
	tst r1, r0
	beq _021F4918
	tst r0, r7
	beq _021F48FC
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	b _021F4916
_021F48FC:
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r1, [sp, #0x18]
	bl ManagedSprite_SetPaletteOverride
_021F4916:
	add r4, r4, #1
_021F4918:
	mov r0, #4
	add r1, r6, #0
	tst r1, r0
	beq _021F496C
	tst r0, r7
	beq _021F493A
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #0
	bl ov18_021F11C0
	pop {r3, r4, r5, r6, r7, pc}
_021F493A:
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #1
	mov r2, #1
	bl ov18_021F11C0
	lsl r4, r4, #2
	mov r0, #0x67
	ldr r6, [sp, #0x18]
	add r1, r5, r4
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r6, #0
	bl ManagedSprite_SetPaletteOverride
	ldr r0, _021F4970 ; =0x00000674
	add r1, r5, r4
	ldr r0, [r1, r0]
	add r1, r6, #0
	bl ManagedSprite_SetPaletteOverride
_021F496C:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F4970: .word 0x00000674
	thumb_func_end ov18_021F48AC

	thumb_func_start ov18_021F4974
ov18_021F4974: ; 0x021F4974
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r1, #0
	str r0, [sp, #4]
	add r0, r5, #4
	add r6, r2, #0
	add r7, r3, #0
	str r0, [sp, #8]
	cmp r5, r0
	bhs _021F49EE
	ldr r0, [sp, #4]
	lsl r1, r5, #2
	add r4, r0, r1
_021F498E:
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl ManagedSprite_GetDrawFlag
	cmp r0, #0
	beq _021F49E4
	mov r0, #2
	str r0, [sp]
	add r2, sp, #0xc
	ldr r0, [sp, #4]
	add r1, r5, #0
	add r2, #2
	add r3, sp, #0xc
	bl ov18_021F12C8
	ldr r0, _021F49F4 ; =ov18_021FA3B0
	add r2, sp, #0xc
	ldrb r0, [r0]
	mov r1, #2
	ldrsh r2, [r2, r1]
	lsr r0, r0, #1
	sub r1, r2, r0
	cmp r6, r1
	blt _021F49E4
	add r0, r2, r0
	cmp r6, r0
	bge _021F49E4
	ldr r0, _021F49F4 ; =ov18_021FA3B0
	add r2, sp, #0xc
	ldrb r0, [r0, #1]
	mov r1, #0
	ldrsh r2, [r2, r1]
	lsr r0, r0, #1
	sub r1, r2, r0
	cmp r7, r1
	blt _021F49E4
	add r0, r2, r0
	cmp r7, r0
	bge _021F49E4
	add sp, #0x10
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021F49E4:
	ldr r0, [sp, #8]
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, r0
	blo _021F498E
_021F49EE:
	mov r0, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F49F4: .word ov18_021FA3B0
	thumb_func_end ov18_021F4974

	thumb_func_start ov18_021F49F8
ov18_021F49F8: ; 0x021F49F8
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	bl ov18_021F4A6C
	mov r6, #1
	mov r4, #0x34
	add r5, r7, #4
_021F4A06:
	add r2, r4, #0
	ldr r1, _021F4A4C ; =ov18_021FA7B0
	sub r2, #0x34
	add r0, r7, #0
	add r1, r1, r2
	bl ov18_021F11EC
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r6, r6, #1
	add r4, #0x34
	add r5, r5, #4
	cmp r6, #0xa
	blo _021F4A06
	add r0, r7, #0
	bl ov18_021F4D64
	add r0, r7, #0
	bl ov18_021F4DDC
	add r0, r7, #0
	bl ov18_021F4E28
	add r0, r7, #0
	mov r1, #3
	mov r2, #0
	bl ov18_021F11C0
	add r0, r7, #0
	mov r1, #5
	mov r2, #0
	bl ov18_021F11C0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F4A4C: .word ov18_021FA7B0
	thumb_func_end ov18_021F49F8

	thumb_func_start ov18_021F4A50
ov18_021F4A50: ; 0x021F4A50
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #1
_021F4A56:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F10E8
	add r4, r4, #1
	cmp r4, #0xa
	blo _021F4A56
	add r0, r5, #0
	bl ov18_021F4CC4
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F4A50

	thumb_func_start ov18_021F4A6C
ov18_021F4A6C: ; 0x021F4A6C
	push {r4, lr}
	sub sp, #0x18
	mov r1, #1
	add r4, r0, #0
	bl ov18_021F1324
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F4C98 ; =0x0000C551
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	bl sub_02074490
	ldr r2, _021F4CA4 ; =0x00000858
	ldr r3, _021F4C9C ; =0x00000668
	ldr r1, [r4, r2]
	sub r2, #8
	str r1, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r1, #3
	str r1, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F4C98 ; =0x0000C551
	str r0, [sp, #0x14]
	ldr r0, [r4, r2]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r3, [r4, r3]
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F4CA8 ; =0x0000C55A
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x6a
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F4CA8 ; =0x0000C55A
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x6b
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F4CAC ; =0x0000C55B
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x70
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F4CAC ; =0x0000C55B
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x71
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	ldr r0, [r4]
	ldr r0, [r0, #4]
	bl PlayerProfile_GetTrainerGender
	cmp r0, #0
	ldr r1, _021F4C9C ; =0x00000668
	bne _021F4BE8
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F4CB0 ; =0x0000C59B
	ldr r2, _021F4CA0 ; =0x00000854
	str r0, [sp, #8]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x69
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F4CB4 ; =0x0000C59C
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x69
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F4CB8 ; =0x0000C59D
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x6f
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F4CA0 ; =0x00000854
	ldr r3, _021F4C9C ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x6c
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, _021F4CBC ; =0x0000C55D
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	ldr r0, _021F4CA0 ; =0x00000854
	ldr r3, _021F4C9C ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x6c
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F4CC0 ; =0x0000C55E
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
_021F4BE8:
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F4CB0 ; =0x0000C59B
	ldr r2, _021F4CA0 ; =0x00000854
	str r0, [sp, #8]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x6d
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F4CB4 ; =0x0000C59C
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x6d
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F4CB8 ; =0x0000C59D
	ldr r1, _021F4C9C ; =0x00000668
	str r0, [sp, #8]
	ldr r2, _021F4CA0 ; =0x00000854
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, [r4, r2]
	mov r3, #0x72
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	ldr r0, _021F4CA0 ; =0x00000854
	ldr r3, _021F4C9C ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x6e
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	ldr r1, _021F4CBC ; =0x0000C55D
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	ldr r0, _021F4CA0 ; =0x00000854
	ldr r3, _021F4C9C ; =0x00000668
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp]
	mov r1, #0x6e
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #1
	str r1, [sp, #0xc]
	mov r1, #2
	str r1, [sp, #0x10]
	ldr r1, _021F4CC0 ; =0x0000C55E
	str r1, [sp, #0x14]
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_021F4C98: .word 0x0000C551
_021F4C9C: .word 0x00000668
_021F4CA0: .word 0x00000854
_021F4CA4: .word 0x00000858
_021F4CA8: .word 0x0000C55A
_021F4CAC: .word 0x0000C55B
_021F4CB0: .word 0x0000C59B
_021F4CB4: .word 0x0000C59C
_021F4CB8: .word 0x0000C59D
_021F4CBC: .word 0x0000C55D
_021F4CC0: .word 0x0000C55E
	thumb_func_end ov18_021F4A6C

	thumb_func_start ov18_021F4CC4
ov18_021F4CC4: ; 0x021F4CC4
	push {r4, lr}
	mov r1, #1
	add r4, r0, #0
	bl ov18_021F13DC
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D44 ; =0x0000C551
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D44 ; =0x0000C551
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D48 ; =0x0000C55A
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D48 ; =0x0000C55A
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D4C ; =0x0000C55B
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D4C ; =0x0000C55B
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D50 ; =0x0000C59B
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D54 ; =0x0000C59C
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D58 ; =0x0000C59D
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D5C ; =0x0000C55D
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F4D40 ; =0x0000066C
	ldr r1, _021F4D60 ; =0x0000C55E
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	pop {r4, pc}
	nop
_021F4D40: .word 0x0000066C
_021F4D44: .word 0x0000C551
_021F4D48: .word 0x0000C55A
_021F4D4C: .word 0x0000C55B
_021F4D50: .word 0x0000C59B
_021F4D54: .word 0x0000C59C
_021F4D58: .word 0x0000C59D
_021F4D5C: .word 0x0000C55D
_021F4D60: .word 0x0000C55E
	thumb_func_end ov18_021F4CC4

	thumb_func_start ov18_021F4D64
ov18_021F4D64: ; 0x021F4D64
	push {r3, r4, r5, lr}
	ldr r1, _021F4DD0 ; =0x000018A4
	add r5, r0, #0
	ldrb r3, [r5, r1]
	mov r0, #0x80
	add r2, r3, #0
	tst r2, r0
	beq _021F4D8E
	eor r0, r3
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	sub r0, r1, #2
	ldrh r0, [r5, r0]
	cmp r0, #0xac
	bne _021F4D90
	cmp r4, #2
	bne _021F4D8A
	mov r4, #1
	b _021F4D90
_021F4D8A:
	mov r4, #0
	b _021F4D90
_021F4D8E:
	mov r4, #0
_021F4D90:
	ldr r1, _021F4DD4 ; =0x000018A2
	add r0, r5, #0
	ldrh r1, [r5, r1]
	add r2, r4, #0
	mov r3, #2
	bl ov18_021F14FC
	ldr r1, _021F4DD4 ; =0x000018A2
	add r0, r5, #0
	ldrh r1, [r5, r1]
	add r2, r4, #0
	mov r3, #3
	bl ov18_021F1534
	ldr r0, _021F4DD8 ; =0x0000068C
	mov r1, #2
	ldr r0, [r5, r0]
	bl ManagedSprite_SetAffineOverwriteMode
	ldr r0, _021F4DD8 ; =0x0000068C
	mov r1, #0
	ldr r0, [r5, r0]
	bl ManagedSprite_SetAffineZRotation
	ldr r0, _021F4DD8 ; =0x0000068C
	mov r1, #0
	ldr r0, [r5, r0]
	sub r2, r1, #4
	bl ManagedSprite_SetAffineTranslation
	pop {r3, r4, r5, pc}
	nop
_021F4DD0: .word 0x000018A4
_021F4DD4: .word 0x000018A2
_021F4DD8: .word 0x0000068C
	thumb_func_end ov18_021F4D64

	thumb_func_start ov18_021F4DDC
ov18_021F4DDC: ; 0x021F4DDC
	push {r3, r4, r5, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #0
	add r2, #1
	add r3, sp, #4
	add r5, r0, #0
	bl ov18_021F3CA8
	ldr r1, _021F4E20 ; =0x000018CC
	mov r0, #2
	add r4, r5, r1
	str r0, [sp]
	sub r1, #0x2a
	add r3, sp, #4
	ldrb r2, [r3, #1]
	ldrh r1, [r5, r1]
	ldrb r3, [r3]
	add r0, r5, #0
	bl ov18_021F69E8
	ldr r0, _021F4E24 ; =0x000018A2
	ldr r1, [r4, #8]
	ldrh r0, [r5, r0]
	ldr r2, [r4, #0xc]
	lsl r3, r0, #1
	ldrsh r1, [r1, r3]
	ldrsh r2, [r2, r3]
	add r0, r5, #0
	bl ov18_021F6AB0
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_021F4E20: .word 0x000018CC
_021F4E24: .word 0x000018A2
	thumb_func_end ov18_021F4DDC

	thumb_func_start ov18_021F4E28
ov18_021F4E28: ; 0x021F4E28
	push {r4, r5, r6, lr}
	sub sp, #8
	ldr r1, _021F4EA4 ; =0x000018CC
	add r4, r0, #0
	add r2, r4, r1
	sub r1, #0x2a
	ldrh r1, [r4, r1]
	ldr r2, [r2, #4]
	mov r0, #1
	lsl r1, r1, #1
	ldrsh r1, [r2, r1]
	lsl r0, r0, #0x14
	lsl r1, r1, #0xc
	bl FX_Div
	bl _fflt
	ldr r1, _021F4EA8 ; =0x45800000
	bl _fdiv
	add r5, r0, #0
	ldr r0, _021F4EAC ; =0x00000674
	mov r1, #2
	ldr r0, [r4, r0]
	bl ManagedSprite_SetAffineOverwriteMode
	ldr r0, _021F4EAC ; =0x00000674
	add r1, r5, #0
	ldr r0, [r4, r0]
	add r2, r5, #0
	bl ManagedSprite_SetAffineScale
	mov r0, #2
	add r2, sp, #4
	str r0, [sp]
	add r0, r4, #0
	mov r1, #1
	add r2, #2
	add r3, sp, #4
	bl ov18_021F12C8
	mov r2, #2
	ldr r6, _021F4EA4 ; =0x000018CC
	str r2, [sp]
	add r5, sp, #4
	mov r3, #0
	ldrsh r2, [r5, r2]
	ldrsh r5, [r5, r3]
	ldr r3, [r4, r6]
	sub r6, #0x2a
	add r0, r4, #0
	ldrh r4, [r4, r6]
	mov r1, #1
	lsl r4, r4, #1
	ldrsh r3, [r3, r4]
	add r3, r5, r3
	lsl r3, r3, #0x10
	asr r3, r3, #0x10
	bl ov18_021F1294
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F4EA4: .word 0x000018CC
_021F4EA8: .word 0x45800000
_021F4EAC: .word 0x00000674
	thumb_func_end ov18_021F4E28

	thumb_func_start ov18_021F4EB0
ov18_021F4EB0: ; 0x021F4EB0
	push {r3, r4, r5, r6, r7, lr}
	asr r0, r0, #4
	lsl r6, r0, #1
	add r5, r1, #0
	ldr r0, _021F4F90 ; =FX_SinCosTable_
	lsl r1, r6, #1
	ldrsh r7, [r0, r1]
	add r4, r2, #0
	add r0, r7, #0
	bl _fflt
	ldr r1, _021F4F94 ; =0x45800000
	bl _fdiv
	mov r1, #0
	bl _fgr
	bls _021F4EF4
	add r0, r7, #0
	bl _fflt
	ldr r1, _021F4F94 ; =0x45800000
	bl _fdiv
	add r1, r0, #0
	ldr r0, _021F4F94 ; =0x45800000
	bl _fmul
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _021F4F10
_021F4EF4:
	add r0, r7, #0
	bl _fflt
	ldr r1, _021F4F94 ; =0x45800000
	bl _fdiv
	add r1, r0, #0
	ldr r0, _021F4F94 ; =0x45800000
	bl _fmul
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_021F4F10:
	bl _ffix
	add r7, r0, #0
	add r0, r6, #1
	lsl r1, r0, #1
	ldr r0, _021F4F90 ; =FX_SinCosTable_
	ldrsh r6, [r0, r1]
	add r0, r6, #0
	bl _fflt
	ldr r1, _021F4F94 ; =0x45800000
	bl _fdiv
	mov r1, #0
	bl _fgr
	bls _021F4F52
	add r0, r6, #0
	bl _fflt
	ldr r1, _021F4F94 ; =0x45800000
	bl _fdiv
	add r1, r0, #0
	ldr r0, _021F4F94 ; =0x45800000
	bl _fmul
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _021F4F6E
_021F4F52:
	add r0, r6, #0
	bl _fflt
	ldr r1, _021F4F94 ; =0x45800000
	bl _fdiv
	add r1, r0, #0
	ldr r0, _021F4F94 ; =0x45800000
	bl _fmul
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_021F4F6E:
	bl _ffix
	mov r2, #0
	ldrsh r1, [r5, r2]
	mov r3, #0x38
	add r6, r7, #0
	mul r6, r3
	asr r6, r6, #0xc
	add r1, r1, r6
	strh r1, [r5]
	add r1, r0, #0
	mul r1, r3
	ldrsh r2, [r4, r2]
	asr r0, r1, #0xc
	add r0, r2, r0
	strh r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F4F90: .word FX_SinCosTable_
_021F4F94: .word 0x45800000
	thumb_func_end ov18_021F4EB0

	thumb_func_start ov18_021F4F98
ov18_021F4F98: ; 0x021F4F98
	push {r0, r1, r2, r3}
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	add r0, r2, #0
	add r1, sp, #0x1c
	add r2, sp, #0x20
	bl ov18_021F4EB0
	mov r0, #1
	str r0, [sp]
	add r1, r4, #0
	add r4, sp, #0x10
	mov r2, #0xc
	mov r3, #0x10
	ldrsh r2, [r4, r2]
	ldrsh r3, [r4, r3]
	add r0, r5, #0
	bl ov18_021F1294
	pop {r3, r4, r5}
	pop {r3}
	add sp, #0x10
	bx r3
	thumb_func_end ov18_021F4F98

	thumb_func_start ov18_021F4FC8
ov18_021F4FC8: ; 0x021F4FC8
	push {r4, r5, r6, lr}
	sub sp, #8
	add r4, r1, #0
	mov r1, #1
	str r1, [sp]
	add r1, r2, #0
	add r2, sp, #4
	add r2, #2
	add r3, sp, #4
	add r5, r0, #0
	bl ov18_021F12C8
	add r6, sp, #4
	mov r3, #0
	ldrsh r0, [r6, r3]
	mov r2, #2
	add r1, r4, #0
	sub r0, #0x10
	strh r0, [r6]
	mov r0, #1
	str r0, [sp]
	ldrsh r2, [r6, r2]
	ldrsh r3, [r6, r3]
	add r0, r5, #0
	bl ov18_021F1294
	add sp, #8
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021F4FC8

	thumb_func_start ov18_021F5000
ov18_021F5000: ; 0x021F5000
	push {r3, r4, r5, lr}
	ldr r2, _021F5048 ; =0xFFFFC000
	add r4, r1, #0
	sub r2, r2, r4
	mov r1, #0x68
	lsl r2, r2, #0x10
	str r1, [sp]
	mov r1, #8
	lsr r2, r2, #0x10
	mov r3, #0x80
	add r5, r0, #0
	bl ov18_021F4F98
	mov r2, #1
	lsl r2, r2, #0xe
	sub r2, r2, r4
	mov r0, #0x68
	lsl r2, r2, #0x10
	str r0, [sp]
	add r0, r5, #0
	mov r1, #9
	lsr r2, r2, #0x10
	mov r3, #0x80
	bl ov18_021F4F98
	add r0, r5, #0
	mov r1, #2
	mov r2, #8
	bl ov18_021F4FC8
	add r0, r5, #0
	mov r1, #4
	mov r2, #9
	bl ov18_021F4FC8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F5048: .word 0xFFFFC000
	thumb_func_end ov18_021F5000

	thumb_func_start ov18_021F504C
ov18_021F504C: ; 0x021F504C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	str r5, [r4]
	mov r0, #0
	str r0, [r4, #4]
	strb r0, [r4, #0xb]
	ldr r0, [r5]
	ldr r0, [r0, #4]
	bl PlayerProfile_GetTrainerGender
	cmp r0, #0
	bne _021F506C
	mov r0, #0x19
	lsl r0, r0, #4
	b _021F506E
_021F506C:
	ldr r0, _021F50B4 ; =0x0000019A
_021F506E:
	ldr r1, _021F50B8 ; =0x0000184C
	ldr r2, [r5, r1]
	add r1, #0x56
	ldrh r1, [r5, r1]
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	cmp r1, r0
	blo _021F5086
	add r2, r0, #0
	add r0, r1, #0
	mov r1, #0
	b _021F508A
_021F5086:
	add r2, r1, #0
	mov r1, #1
_021F508A:
	strb r1, [r4, #0xa]
	sub r0, r0, r2
	mov r1, #0xa
	bl _u32_div_f
	ldr r3, _021F50BC ; =ov18_021FA5CC
	mov r2, #0
_021F5098:
	ldrh r1, [r3]
	cmp r0, r1
	blo _021F50A8
	ldrh r1, [r3, #2]
	cmp r0, r1
	bhi _021F50A8
	strh r2, [r4, #8]
	pop {r3, r4, r5, pc}
_021F50A8:
	add r2, r2, #1
	add r3, r3, #4
	cmp r2, #0x11
	blo _021F5098
	pop {r3, r4, r5, pc}
	nop
_021F50B4: .word 0x0000019A
_021F50B8: .word 0x0000184C
_021F50BC: .word ov18_021FA5CC
	thumb_func_end ov18_021F504C

	thumb_func_start ov18_021F50C0
ov18_021F50C0: ; 0x021F50C0
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	add r2, sp, #8
	ldr r0, [r4]
	mov r1, #2
	add r2, #2
	add r3, sp, #8
	bl ov18_021F12C8
	mov r0, #1
	str r0, [sp]
	add r2, sp, #4
	ldr r0, [r4]
	mov r1, #4
	add r2, #2
	add r3, sp, #4
	bl ov18_021F12C8
	mov r0, #1
	ldr r1, [r4, #4]
	lsl r0, r0, #0xa
	add r0, r1, r0
	str r0, [r4, #4]
	add r2, sp, #4
	mov r1, #4
	ldrsh r3, [r2, r1]
	asr r0, r0, #0xc
	add r0, r3, r0
	strh r0, [r2, #4]
	mov r0, #0
	ldrsh r3, [r2, r0]
	ldr r0, [r4, #4]
	asr r0, r0, #0xc
	add r0, r3, r0
	strh r0, [r2]
	ldrsh r3, [r2, r1]
	cmp r3, #0x58
	blt _021F513E
	mov r0, #1
	str r0, [sp]
	mov r3, #6
	ldrsh r2, [r2, r3]
	ldr r0, [r4]
	mov r1, #2
	mov r3, #0x58
	bl ov18_021F1294
	mov r0, #1
	str r0, [sp]
	add r3, sp, #4
	mov r2, #2
	ldrsh r2, [r3, r2]
	ldr r0, [r4]
	mov r1, #4
	mov r3, #0x58
	bl ov18_021F1294
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_021F513E:
	mov r0, #1
	str r0, [sp]
	mov r5, #6
	ldrsh r2, [r2, r5]
	ldr r0, [r4]
	mov r1, #2
	bl ov18_021F1294
	mov r0, #1
	str r0, [sp]
	ldr r0, [r4]
	add r4, sp, #4
	mov r2, #2
	mov r3, #0
	ldrsh r2, [r4, r2]
	ldrsh r3, [r4, r3]
	mov r1, #4
	bl ov18_021F1294
	mov r0, #1
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F50C0

	thumb_func_start ov18_021F516C
ov18_021F516C: ; 0x021F516C
	push {r3, lr}
	ldrh r1, [r0, #8]
	lsl r2, r1, #2
	ldr r1, _021F517C ; =ov18_021FA588
	ldr r1, [r1, r2]
	blx r1
	pop {r3, pc}
	nop
_021F517C: .word ov18_021FA588
	thumb_func_end ov18_021F516C

	thumb_func_start ov18_021F5180
ov18_021F5180: ; 0x021F5180
	ldrb r3, [r0, #0xa]
	cmp r3, #0
	bne _021F518E
	neg r1, r1
	str r1, [r0, #0xc]
	str r2, [r0, #0x10]
	bx lr
_021F518E:
	str r1, [r0, #0xc]
	neg r1, r2
	str r1, [r0, #0x10]
	bx lr
	.balign 4, 0
	thumb_func_end ov18_021F5180

	thumb_func_start ov18_021F5198
ov18_021F5198: ; 0x021F5198
	push {r3, r4}
	ldrb r4, [r0, #0xa]
	cmp r4, #0
	bne _021F51B0
	neg r1, r1
	str r1, [r0, #0xc]
	neg r1, r2
	str r1, [r0, #0x10]
	neg r1, r3
	str r1, [r0, #0x14]
	pop {r3, r4}
	bx lr
_021F51B0:
	str r1, [r0, #0xc]
	str r2, [r0, #0x10]
	str r3, [r0, #0x14]
	pop {r3, r4}
	bx lr
	.balign 4, 0
	thumb_func_end ov18_021F5198

	thumb_func_start ov18_021F51BC
ov18_021F51BC: ; 0x021F51BC
	push {r3, lr}
	ldr r0, _021F51C8 ; =0x000008EB
	bl PlaySE
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021F51C8: .word 0x000008EB
	thumb_func_end ov18_021F51BC

	thumb_func_start ov18_021F51CC
ov18_021F51CC: ; 0x021F51CC
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #0
	beq _021F51DC
	cmp r0, #1
	beq _021F51FA
	b _021F522A
_021F51DC:
	ldr r0, _021F5230 ; =0x000008EB
	bl PlaySE
	mov r2, #0x1f
	mvn r2, r2
	mov r1, #1
	add r3, r2, #0
	add r0, r4, #0
	lsl r1, r1, #8
	sub r3, #0xc0
	bl ov18_021F5198
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F51FA:
	ldr r1, [r4]
	ldr r0, _021F5234 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5234 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r1, r0, #0
	ldr r0, [r4]
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r1, r1, r0
	str r1, [r4, #0xc]
	ldr r0, [r4, #0x14]
	cmp r1, r0
	bne _021F522A
	mov r0, #0
	pop {r4, pc}
_021F522A:
	mov r0, #1
	pop {r4, pc}
	nop
_021F5230: .word 0x000008EB
_021F5234: .word 0x0000068C
	thumb_func_end ov18_021F51CC

	thumb_func_start ov18_021F5238
ov18_021F5238: ; 0x021F5238
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #0
	beq _021F5248
	cmp r0, #1
	beq _021F5266
	b _021F5296
_021F5248:
	ldr r0, _021F529C ; =0x000008EB
	bl PlaySE
	mov r2, #0x1f
	mvn r2, r2
	mov r1, #0x12
	add r3, r2, #0
	add r0, r4, #0
	lsl r1, r1, #4
	sub r3, #0xe0
	bl ov18_021F5198
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5266:
	ldr r1, [r4]
	ldr r0, _021F52A0 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F52A0 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r1, r0, #0
	ldr r0, [r4]
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r1, r1, r0
	str r1, [r4, #0xc]
	ldr r0, [r4, #0x14]
	cmp r1, r0
	bne _021F5296
	mov r0, #0
	pop {r4, pc}
_021F5296:
	mov r0, #1
	pop {r4, pc}
	nop
_021F529C: .word 0x000008EB
_021F52A0: .word 0x0000068C
	thumb_func_end ov18_021F5238

	thumb_func_start ov18_021F52A4
ov18_021F52A4: ; 0x021F52A4
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #0
	beq _021F52B4
	cmp r0, #1
	beq _021F52D0
	b _021F5300
_021F52B4:
	ldr r0, _021F5304 ; =0x000008EB
	bl PlaySE
	mov r1, #5
	mov r2, #0x1f
	ldr r3, _021F5308 ; =0xFFFFFEE0
	add r0, r4, #0
	lsl r1, r1, #6
	mvn r2, r2
	bl ov18_021F5198
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F52D0:
	ldr r1, [r4]
	ldr r0, _021F530C ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F530C ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r1, r0, #0
	ldr r0, [r4]
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r1, r1, r0
	str r1, [r4, #0xc]
	ldr r0, [r4, #0x14]
	cmp r1, r0
	bne _021F5300
	mov r0, #0
	pop {r4, pc}
_021F5300:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021F5304: .word 0x000008EB
_021F5308: .word 0xFFFFFEE0
_021F530C: .word 0x0000068C
	thumb_func_end ov18_021F52A4

	thumb_func_start ov18_021F5310
ov18_021F5310: ; 0x021F5310
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #0
	beq _021F5320
	cmp r0, #1
	beq _021F533C
	b _021F536C
_021F5320:
	ldr r0, _021F5370 ; =0x000008EB
	bl PlaySE
	mov r1, #0x16
	mov r2, #0x1f
	ldr r3, _021F5374 ; =0xFFFFFEC0
	add r0, r4, #0
	lsl r1, r1, #4
	mvn r2, r2
	bl ov18_021F5198
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F533C:
	ldr r1, [r4]
	ldr r0, _021F5378 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5378 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r1, r0, #0
	ldr r0, [r4]
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r1, r1, r0
	str r1, [r4, #0xc]
	ldr r0, [r4, #0x14]
	cmp r1, r0
	bne _021F536C
	mov r0, #0
	pop {r4, pc}
_021F536C:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021F5370: .word 0x000008EB
_021F5374: .word 0xFFFFFEC0
_021F5378: .word 0x0000068C
	thumb_func_end ov18_021F5310

	thumb_func_start ov18_021F537C
ov18_021F537C: ; 0x021F537C
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #0
	beq _021F538C
	cmp r0, #1
	beq _021F53A8
	b _021F53D8
_021F538C:
	ldr r0, _021F53DC ; =0x000008EB
	bl PlaySE
	mov r1, #6
	mov r2, #0x1f
	ldr r3, _021F53E0 ; =0xFFFFFEA0
	add r0, r4, #0
	lsl r1, r1, #6
	mvn r2, r2
	bl ov18_021F5198
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F53A8:
	ldr r1, [r4]
	ldr r0, _021F53E4 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F53E4 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r1, r0, #0
	ldr r0, [r4]
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r1, r1, r0
	str r1, [r4, #0xc]
	ldr r0, [r4, #0x14]
	cmp r1, r0
	bne _021F53D8
	mov r0, #0
	pop {r4, pc}
_021F53D8:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021F53DC: .word 0x000008EB
_021F53E0: .word 0xFFFFFEA0
_021F53E4: .word 0x0000068C
	thumb_func_end ov18_021F537C

	thumb_func_start ov18_021F53E8
ov18_021F53E8: ; 0x021F53E8
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #0
	beq _021F53F8
	cmp r0, #1
	beq _021F5414
	b _021F5444
_021F53F8:
	ldr r0, _021F5448 ; =0x000008EB
	bl PlaySE
	mov r1, #7
	mov r2, #0x3f
	ldr r3, _021F544C ; =0xFFFFFEC0
	add r0, r4, #0
	lsl r1, r1, #6
	mvn r2, r2
	bl ov18_021F5198
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5414:
	ldr r1, [r4]
	ldr r0, _021F5450 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5450 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r1, r0, #0
	ldr r0, [r4]
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r1, r1, r0
	str r1, [r4, #0xc]
	ldr r0, [r4, #0x14]
	cmp r1, r0
	bne _021F5444
	mov r0, #0
	pop {r4, pc}
_021F5444:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021F5448: .word 0x000008EB
_021F544C: .word 0xFFFFFEC0
_021F5450: .word 0x0000068C
	thumb_func_end ov18_021F53E8

	thumb_func_start ov18_021F5454
ov18_021F5454: ; 0x021F5454
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #0
	beq _021F5464
	cmp r0, #1
	beq _021F5480
	b _021F54B0
_021F5464:
	ldr r0, _021F54B4 ; =0x000008EB
	bl PlaySE
	mov r1, #2
	mov r2, #0x3f
	ldr r3, _021F54B8 ; =0xFFFFFE80
	add r0, r4, #0
	lsl r1, r1, #8
	mvn r2, r2
	bl ov18_021F5198
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5480:
	ldr r1, [r4]
	ldr r0, _021F54BC ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F54BC ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r1, r0, #0
	ldr r0, [r4]
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r1, r1, r0
	str r1, [r4, #0xc]
	ldr r0, [r4, #0x14]
	cmp r1, r0
	bne _021F54B0
	mov r0, #0
	pop {r4, pc}
_021F54B0:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_021F54B4: .word 0x000008EB
_021F54B8: .word 0xFFFFFE80
_021F54BC: .word 0x0000068C
	thumb_func_end ov18_021F5454

	thumb_func_start ov18_021F54C0
ov18_021F54C0: ; 0x021F54C0
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	strh r1, [r4, #0x18]
	strh r2, [r4, #0x1a]
	mov r0, #1
	str r0, [sp]
	add r2, sp, #8
	ldr r0, [r4]
	mov r1, #2
	add r2, #2
	add r3, sp, #8
	bl ov18_021F12C8
	mov r0, #1
	str r0, [sp]
	add r2, sp, #4
	ldr r0, [r4]
	mov r1, #4
	add r2, #2
	add r3, sp, #4
	bl ov18_021F12C8
	add r1, sp, #4
	mov r2, #4
	mov r0, #0
	ldrsh r3, [r1, r2]
	ldrsh r0, [r1, r0]
	cmp r3, r0
	bge _021F552E
	mov r0, #2
	strh r0, [r4, #0x1c]
	mov r0, #8
	strh r0, [r4, #0x1e]
	ldr r0, [r4]
	mov r1, #3
	mov r2, #1
	bl ov18_021F11C0
	mov r0, #2
	str r0, [sp]
	ldr r0, [r4]
	add r4, sp, #4
	mov r3, #4
	ldrsh r3, [r4, r3]
	mov r2, #6
	ldrsh r2, [r4, r2]
	add r3, #0xc0
	lsl r3, r3, #0x10
	mov r1, #3
	asr r3, r3, #0x10
	bl ov18_021F1294
	add sp, #0xc
	pop {r3, r4, pc}
_021F552E:
	strh r2, [r4, #0x1c]
	mov r0, #9
	strh r0, [r4, #0x1e]
	ldr r0, [r4]
	mov r1, #5
	mov r2, #1
	bl ov18_021F11C0
	mov r2, #2
	str r2, [sp]
	ldr r0, [r4]
	add r4, sp, #4
	mov r3, #0
	ldrsh r3, [r4, r3]
	ldrsh r2, [r4, r2]
	mov r1, #5
	add r3, #0xc0
	lsl r3, r3, #0x10
	asr r3, r3, #0x10
	bl ov18_021F1294
	add sp, #0xc
	pop {r3, r4, pc}
	thumb_func_end ov18_021F54C0

	thumb_func_start ov18_021F555C
ov18_021F555C: ; 0x021F555C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	add r2, sp, #4
	ldrh r1, [r4, #0x1c]
	ldr r0, [r4]
	add r2, #2
	add r3, sp, #4
	bl ov18_021F12C8
	mov r0, #0x18
	add r5, sp, #4
	mov r3, #0
	ldrsh r1, [r5, r3]
	ldrsh r0, [r4, r0]
	mov r2, #2
	add r0, r1, r0
	strh r0, [r5]
	mov r0, #1
	str r0, [sp]
	ldrh r1, [r4, #0x1c]
	ldrsh r2, [r5, r2]
	ldrsh r3, [r5, r3]
	ldr r0, [r4]
	bl ov18_021F1294
	mov r0, #2
	str r0, [sp]
	ldrh r1, [r4, #0x1c]
	add r2, sp, #4
	ldr r0, [r4]
	add r1, r1, #1
	add r2, #2
	add r3, sp, #4
	bl ov18_021F12C8
	mov r3, #0
	mov r0, #0x18
	ldrsh r1, [r5, r3]
	ldrsh r0, [r4, r0]
	mov r2, #2
	add r0, r1, r0
	strh r0, [r5]
	str r2, [sp]
	ldrh r1, [r4, #0x1c]
	ldrsh r2, [r5, r2]
	ldrsh r3, [r5, r3]
	ldr r0, [r4]
	add r1, r1, #1
	bl ov18_021F1294
	mov r0, #0x18
	ldrsh r1, [r4, r0]
	mov r0, #0x1a
	ldrsh r0, [r4, r0]
	add r0, r1, r0
	strh r0, [r4, #0x18]
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F555C

	thumb_func_start ov18_021F55D8
ov18_021F55D8: ; 0x021F55D8
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	bl ov18_021F555C
	mov r0, #1
	str r0, [sp]
	add r2, sp, #8
	ldrh r1, [r4, #0x1c]
	ldr r0, [r4]
	add r2, #2
	add r3, sp, #8
	bl ov18_021F12C8
	mov r0, #1
	str r0, [sp]
	add r2, sp, #4
	ldrh r1, [r4, #0x1e]
	ldr r0, [r4]
	add r2, #2
	add r3, sp, #4
	bl ov18_021F12C8
	add r2, sp, #4
	mov r0, #0
	ldrsh r3, [r2, r0]
	mov r0, #4
	ldrsh r0, [r2, r0]
	sub r3, #0x10
	cmp r0, r3
	blt _021F5630
	mov r0, #1
	str r0, [sp]
	ldr r0, [r4]
	ldrh r1, [r4, #0x1c]
	mov r4, #2
	lsl r3, r3, #0x10
	ldrsh r2, [r2, r4]
	asr r3, r3, #0x10
	bl ov18_021F1294
	add sp, #0xc
	mov r0, #0
	pop {r3, r4, pc}
_021F5630:
	mov r0, #1
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F55D8

	thumb_func_start ov18_021F5638
ov18_021F5638: ; 0x021F5638
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldrb r0, [r5, #0xb]
	cmp r0, #0
	beq _021F5648
	cmp r0, #1
	beq _021F5660
	b _021F56CE
_021F5648:
	ldr r0, _021F56D4 ; =0x000008EB
	bl PlaySE
	mov r1, #3
	add r0, r5, #0
	lsl r1, r1, #8
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r5, #0xb]
	add r0, r0, #1
	strb r0, [r5, #0xb]
_021F5660:
	ldr r1, [r5]
	ldr r0, _021F56D8 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r5, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r5]
	ldr r0, _021F56D8 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r4, r0, #0
	ldr r0, [r5]
	add r1, r4, #0
	bl ov18_021F5000
	ldr r1, [r5, #0xc]
	ldr r0, [r5, #0x10]
	add r0, r1, r0
	str r0, [r5, #0xc]
	ldrb r0, [r5, #0xa]
	cmp r0, #0
	bne _021F56AE
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r4, r1
	bhi _021F56CE
	ldr r2, [r5]
	ldr r0, _021F56D8 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r5]
	lsl r1, r1, #8
	bl ov18_021F5000
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F56AE:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r4, r1
	blo _021F56CE
	ldr r2, [r5]
	ldr r0, _021F56D8 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r5]
	lsl r1, r1, #8
	bl ov18_021F5000
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F56CE:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F56D4: .word 0x000008EB
_021F56D8: .word 0x0000068C
	thumb_func_end ov18_021F5638

	thumb_func_start ov18_021F56DC
ov18_021F56DC: ; 0x021F56DC
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F57A6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F56F2: ; jump table
	.short ov18_021F56FA - ov18_021F56F2 - 2 ; case 0
	.short ov18_021F5712 - ov18_021F56F2 - 2 ; case 1
	.short _021F5786 - ov18_021F56F2 - 2 ; case 2
	.short ov18_021F5798 - ov18_021F56F2 - 2 ; case 3
ov18_021F56FA:
	ldr r0, _021F57AC ; =0x000008EC
	bl PlaySE
	mov r1, #3
	add r0, r4, #0
	lsl r1, r1, #8
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5712:
	ldr r1, [r4]
	ldr r0, _021F57B0 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F57B0 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F5764
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F57A6
	ldr r2, [r4]
	ldr r0, _021F57B0 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F5786
_021F5764:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F57A6
	ldr r2, [r4]
	ldr r0, _021F57B0 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5786:
	mov r1, #3
	add r0, r4, #0
	mvn r1, r1
	mov r2, #1
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5798:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F57A6
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F57A6:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F57AC: .word 0x000008EC
_021F57B0: .word 0x0000068C
	thumb_func_end ov18_021F56DC

	thumb_func_start ov18_021F57B4
ov18_021F57B4: ; 0x021F57B4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F587E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F57CA: ; jump table
	.short ov18_021F57D2 - ov18_021F57CA - 2 ; case 0
	.short ov18_021F57EA - ov18_021F57CA - 2 ; case 1
	.short _021F585E - ov18_021F57CA - 2 ; case 2
	.short ov18_021F5870 - ov18_021F57CA - 2 ; case 3
ov18_021F57D2:
	ldr r0, _021F5884 ; =0x000008EC
	bl PlaySE
	mov r1, #1
	add r0, r4, #0
	lsl r1, r1, #0xa
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F57EA:
	ldr r1, [r4]
	ldr r0, _021F5888 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5888 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F583C
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F587E
	ldr r2, [r4]
	ldr r0, _021F5888 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F585E
_021F583C:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F587E
	ldr r2, [r4]
	ldr r0, _021F5888 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F585E:
	mov r1, #7
	add r0, r4, #0
	mvn r1, r1
	mov r2, #1
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5870:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F587E
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F587E:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F5884: .word 0x000008EC
_021F5888: .word 0x0000068C
	thumb_func_end ov18_021F57B4

	thumb_func_start ov18_021F588C
ov18_021F588C: ; 0x021F588C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F5956
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F58A2: ; jump table
	.short ov18_021F58AA - ov18_021F58A2 - 2 ; case 0
	.short ov18_021F58C2 - ov18_021F58A2 - 2 ; case 1
	.short _021F5936 - ov18_021F58A2 - 2 ; case 2
	.short ov18_021F5948 - ov18_021F58A2 - 2 ; case 3
ov18_021F58AA:
	ldr r0, _021F595C ; =0x000008EC
	bl PlaySE
	mov r1, #1
	add r0, r4, #0
	lsl r1, r1, #0xa
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F58C2:
	ldr r1, [r4]
	ldr r0, _021F5960 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5960 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F5914
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F5956
	ldr r2, [r4]
	ldr r0, _021F5960 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F5936
_021F5914:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F5956
	ldr r2, [r4]
	ldr r0, _021F5960 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5936:
	mov r1, #0xb
	add r0, r4, #0
	mvn r1, r1
	mov r2, #1
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5948:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F5956
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F5956:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F595C: .word 0x000008EC
_021F5960: .word 0x0000068C
	thumb_func_end ov18_021F588C

	thumb_func_start ov18_021F5964
ov18_021F5964: ; 0x021F5964
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F5A2E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F597A: ; jump table
	.short ov18_021F5982 - ov18_021F597A - 2 ; case 0
	.short ov18_021F599A - ov18_021F597A - 2 ; case 1
	.short _021F5A0E - ov18_021F597A - 2 ; case 2
	.short ov18_021F5A20 - ov18_021F597A - 2 ; case 3
ov18_021F5982:
	ldr r0, _021F5A34 ; =0x000008ED
	bl PlaySE
	mov r1, #5
	add r0, r4, #0
	lsl r1, r1, #8
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F599A:
	ldr r1, [r4]
	ldr r0, _021F5A38 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5A38 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F59EC
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F5A2E
	ldr r2, [r4]
	ldr r0, _021F5A38 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F5A0E
_021F59EC:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F5A2E
	ldr r2, [r4]
	ldr r0, _021F5A38 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5A0E:
	mov r1, #0xd
	add r0, r4, #0
	mvn r1, r1
	mov r2, #1
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5A20:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F5A2E
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F5A2E:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F5A34: .word 0x000008ED
_021F5A38: .word 0x0000068C
	thumb_func_end ov18_021F5964

	thumb_func_start ov18_021F5A3C
ov18_021F5A3C: ; 0x021F5A3C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F5B06
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F5A52: ; jump table
	.short ov18_021F5A5A - ov18_021F5A52 - 2 ; case 0
	.short ov18_021F5A72 - ov18_021F5A52 - 2 ; case 1
	.short _021F5AE6 - ov18_021F5A52 - 2 ; case 2
	.short ov18_021F5AF8 - ov18_021F5A52 - 2 ; case 3
ov18_021F5A5A:
	ldr r0, _021F5B0C ; =0x000008ED
	bl PlaySE
	mov r1, #5
	add r0, r4, #0
	lsl r1, r1, #8
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5A72:
	ldr r1, [r4]
	ldr r0, _021F5B10 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5B10 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F5AC4
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F5B06
	ldr r2, [r4]
	ldr r0, _021F5B10 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F5AE6
_021F5AC4:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F5B06
	ldr r2, [r4]
	ldr r0, _021F5B10 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5AE6:
	mov r1, #0x11
	add r0, r4, #0
	mvn r1, r1
	mov r2, #1
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5AF8:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F5B06
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F5B06:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F5B0C: .word 0x000008ED
_021F5B10: .word 0x0000068C
	thumb_func_end ov18_021F5A3C

	thumb_func_start ov18_021F5B14
ov18_021F5B14: ; 0x021F5B14
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F5BDE
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F5B2A: ; jump table
	.short ov18_021F5B32 - ov18_021F5B2A - 2 ; case 0
	.short ov18_021F5B4A - ov18_021F5B2A - 2 ; case 1
	.short _021F5BBE - ov18_021F5B2A - 2 ; case 2
	.short ov18_021F5BD0 - ov18_021F5B2A - 2 ; case 3
ov18_021F5B32:
	ldr r0, _021F5BE4 ; =0x000008ED
	bl PlaySE
	mov r1, #6
	add r0, r4, #0
	lsl r1, r1, #8
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5B4A:
	ldr r1, [r4]
	ldr r0, _021F5BE8 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5BE8 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F5B9C
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F5BDE
	ldr r2, [r4]
	ldr r0, _021F5BE8 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F5BBE
_021F5B9C:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F5BDE
	ldr r2, [r4]
	ldr r0, _021F5BE8 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5BBE:
	mov r1, #0x14
	add r0, r4, #0
	mvn r1, r1
	mov r2, #1
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5BD0:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F5BDE
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F5BDE:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F5BE4: .word 0x000008ED
_021F5BE8: .word 0x0000068C
	thumb_func_end ov18_021F5B14

	thumb_func_start ov18_021F5BEC
ov18_021F5BEC: ; 0x021F5BEC
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F5CB6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F5C02: ; jump table
	.short ov18_021F5C0A - ov18_021F5C02 - 2 ; case 0
	.short ov18_021F5C22 - ov18_021F5C02 - 2 ; case 1
	.short _021F5C96 - ov18_021F5C02 - 2 ; case 2
	.short ov18_021F5CA8 - ov18_021F5C02 - 2 ; case 3
ov18_021F5C0A:
	ldr r0, _021F5CBC ; =0x000008ED
	bl PlaySE
	mov r1, #7
	add r0, r4, #0
	lsl r1, r1, #8
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5C22:
	ldr r1, [r4]
	ldr r0, _021F5CC0 ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5CC0 ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F5C74
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F5CB6
	ldr r2, [r4]
	ldr r0, _021F5CC0 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F5C96
_021F5C74:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F5CB6
	ldr r2, [r4]
	ldr r0, _021F5CC0 ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5C96:
	mov r1, #0x17
	add r0, r4, #0
	mvn r1, r1
	mov r2, #1
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5CA8:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F5CB6
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F5CB6:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021F5CBC: .word 0x000008ED
_021F5CC0: .word 0x0000068C
	thumb_func_end ov18_021F5BEC

	thumb_func_start ov18_021F5CC4
ov18_021F5CC4: ; 0x021F5CC4
	push {r3, r4, r5, lr}
	sub sp, #8
	add r4, r0, #0
	ldrb r0, [r4, #0xb]
	cmp r0, #3
	bhi _021F5DB2
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F5CDC: ; jump table
	.short ov18_021F5CE4 - ov18_021F5CDC - 2 ; case 0
	.short ov18_021F5CFC - ov18_021F5CDC - 2 ; case 1
	.short _021F5D70 - ov18_021F5CDC - 2 ; case 2
	.short ov18_021F5D82 - ov18_021F5CDC - 2 ; case 3
ov18_021F5CE4:
	ldr r0, _021F5DB8 ; =0x000008EE
	bl PlaySE
	mov r1, #2
	add r0, r4, #0
	lsl r1, r1, #0xa
	mov r2, #0
	bl ov18_021F5180
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5CFC:
	ldr r1, [r4]
	ldr r0, _021F5DBC ; =0x0000068C
	ldr r0, [r1, r0]
	ldr r1, [r4, #0xc]
	bl ManagedSprite_OffsetAffineZRotation
	ldr r1, [r4]
	ldr r0, _021F5DBC ; =0x0000068C
	ldr r0, [r1, r0]
	bl ManagedSprite_GetRotation
	add r5, r0, #0
	ldr r0, [r4]
	add r1, r5, #0
	bl ov18_021F5000
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	str r0, [r4, #0xc]
	ldrb r0, [r4, #0xa]
	cmp r0, #0
	bne _021F5D4E
	mov r1, #0xf6
	lsl r1, r1, #8
	cmp r5, r1
	bhi _021F5DB2
	ldr r2, [r4]
	ldr r0, _021F5DBC ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xf6
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
	b _021F5D70
_021F5D4E:
	mov r1, #0xa
	lsl r1, r1, #8
	cmp r5, r1
	blo _021F5DB2
	ldr r2, [r4]
	ldr r0, _021F5DBC ; =0x0000068C
	ldr r0, [r2, r0]
	bl ManagedSprite_SetAffineZRotation
	mov r1, #0xa
	ldr r0, [r4]
	lsl r1, r1, #8
	bl ov18_021F5000
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
_021F5D70:
	mov r1, #0x17
	add r0, r4, #0
	mvn r1, r1
	mov r2, #0
	bl ov18_021F54C0
	ldrb r0, [r4, #0xb]
	add r0, r0, #1
	strb r0, [r4, #0xb]
ov18_021F5D82:
	add r0, r4, #0
	bl ov18_021F55D8
	cmp r0, #0
	bne _021F5D92
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F5D92:
	mov r0, #1
	str r0, [sp]
	ldrh r1, [r4, #0x1c]
	add r2, sp, #4
	ldr r0, [r4]
	add r2, #2
	add r3, sp, #4
	bl ov18_021F12C8
	add r1, sp, #4
	mov r0, #0
	ldrsh r2, [r1, r0]
	mov r1, #0xff
	mvn r1, r1
	cmp r2, r1
	ble ov18_021F5DB4
_021F5DB2:
	mov r0, #1
ov18_021F5DB4:
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F5DB8: .word 0x000008EE
_021F5DBC: .word 0x0000068C
	thumb_func_end ov18_021F5CC4

	thumb_func_start ov18_021F5DC0
ov18_021F5DC0: ; 0x021F5DC0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #6
	bl ov18_021F1324
	add r0, r4, #0
	bl ov18_021F17FC
	add r0, r4, #0
	bl ov18_021F193C
	add r0, r4, #0
	bl ov18_021F5E0C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F5DC0

	thumb_func_start ov18_021F5DE0
ov18_021F5DE0: ; 0x021F5DE0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #1
_021F5DE6:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F10E8
	add r4, r4, #1
	cmp r4, #0x14
	blo _021F5DE6
	add r0, r5, #0
	mov r1, #6
	bl ov18_021F13DC
	add r0, r5, #0
	bl ov18_021F18E0
	add r0, r5, #0
	bl ov18_021F19EC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F5DE0

	thumb_func_start ov18_021F5E0C
ov18_021F5E0C: ; 0x021F5E0C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r7, #1
	mov r6, #0x34
	add r4, r5, #4
_021F5E16:
	ldr r0, _021F5ED8 ; =0x00000668
	ldr r1, _021F5EDC ; =0x0000066C
	add r3, r6, #0
	ldr r2, _021F5EE0 ; =ov18_021FAC28
	sub r3, #0x34
	add r2, r2, r3
	mov r3, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r4, r1]
	add r7, r7, #1
	add r6, #0x34
	add r4, r4, #4
	cmp r7, #4
	bls _021F5E16
	mov r7, #5
	add r6, r7, #0
	add r4, r5, #0
	add r6, #0xff
	add r4, #0x14
_021F5E48:
	ldr r0, _021F5ED8 ; =0x00000668
	ldr r1, _021F5EDC ; =0x0000066C
	add r3, r6, #0
	ldr r2, _021F5EE0 ; =ov18_021FAC28
	sub r3, #0x34
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	add r2, r2, r3
	bl SpriteSystem_NewSprite
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r4, r1]
	add r7, r7, #1
	add r6, #0x34
	add r4, r4, #4
	cmp r7, #0x14
	blo _021F5E48
	add r0, r5, #0
	mov r1, #9
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #0xa
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #0xb
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #0xc
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #0xd
	mov r2, #0
	bl ov18_021F11C0
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	bl ov18_021F5EFC
	add r0, r5, #0
	bl ov18_021F6038
	mov r0, #9
	str r0, [sp]
	ldr r2, _021F5EE4 ; =0x000018C4
	ldr r3, _021F5EE8 ; =ov18_021FA348
	ldrsb r2, [r5, r2]
	add r0, r5, #0
	mov r1, #5
	bl ov18_021F61DC
	add r0, r5, #0
	bl ov18_021F65AC
	ldr r2, _021F5EEC ; =0x000018C5
	add r0, r5, #0
	ldrsb r1, [r5, r2]
	sub r2, r2, #1
	ldrsb r2, [r5, r2]
	mov r3, #6
	bl ov18_021F619C
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F5ED8: .word 0x00000668
_021F5EDC: .word 0x0000066C
_021F5EE0: .word ov18_021FAC28
_021F5EE4: .word 0x000018C4
_021F5EE8: .word ov18_021FA348
_021F5EEC: .word 0x000018C5
	thumb_func_end ov18_021F5E0C

	thumb_func_start ov18_021F5EF0
ov18_021F5EF0: ; 0x021F5EF0
	ldr r3, _021F5EF8 ; =ov18_021F5EFC
	mov r2, #0
	bx r3
	nop
_021F5EF8: .word ov18_021F5EFC
	thumb_func_end ov18_021F5EF0

	thumb_func_start ov18_021F5EFC
ov18_021F5EFC: ; 0x021F5EFC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r3, sp, #0xc
	add r7, r2, #0
	add r2, sp, #0xc
	add r3, #1
	add r5, r0, #0
	bl ov18_021F3CA8
	ldr r0, _021F5FF4 ; =0x000018C7
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1f
	bne _021F5F32
	add r0, r5, #0
	mov r1, #3
	mov r2, #0
	mov r6, #1
	mov r4, #2
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #4
	mov r2, #0
	bl ov18_021F11C0
	b _021F5F4A
_021F5F32:
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	mov r6, #3
	mov r4, #4
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #2
	mov r2, #0
	bl ov18_021F11C0
_021F5F4A:
	ldr r1, _021F5FF4 ; =0x000018C7
	mov r2, #0x20
	ldrb r3, [r5, r1]
	add r0, r3, #0
	bic r0, r2
	lsl r2, r3, #0x1a
	lsr r3, r2, #0x1f
	mov r2, #1
	eor r2, r3
	lsl r2, r2, #0x18
	lsr r2, r2, #0x18
	lsl r2, r2, #0x1f
	lsr r2, r2, #0x1a
	orr r0, r2
	strb r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	str r6, [sp, #4]
	str r7, [sp, #8]
	sub r1, #0x25
	add r3, sp, #0xc
	ldrb r2, [r3]
	ldrh r1, [r5, r1]
	ldrb r3, [r3, #1]
	add r0, r5, #0
	bl ov18_021F1A7C
	lsl r0, r6, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x40
	mov r2, #0x78
	lsl r3, r1, #0xf
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	mov r0, #0
	str r0, [sp]
	str r4, [sp, #4]
	ldr r1, _021F5FF8 ; =0x000018A2
	str r7, [sp, #8]
	add r3, sp, #0xc
	ldrb r2, [r3]
	ldrh r1, [r5, r1]
	ldrb r3, [r3, #1]
	add r0, r5, #0
	bl ov18_021F1A7C
	mov r2, #0
	ldr r0, _021F5FF8 ; =0x000018A2
	str r2, [sp]
	add r3, sp, #0xc
	ldrb r1, [r3, #1]
	ldrh r0, [r5, r0]
	ldrb r3, [r3]
	bl GetMonPicHeightBySpeciesGenderForm
	add r2, r0, #0
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	add r2, #0x78
	ldr r0, [r1, r0]
	lsl r2, r2, #0x10
	mov r3, #2
	mov r1, #0xc0
	asr r2, r2, #0x10
	lsl r3, r3, #0x14
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #1
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F5FF4: .word 0x000018C7
_021F5FF8: .word 0x000018A2
	thumb_func_end ov18_021F5EFC

	thumb_func_start ov18_021F5FFC
ov18_021F5FFC: ; 0x021F5FFC
	push {r3, r4, r5, lr}
	add r3, r1, #0
	ldr r1, _021F6030 ; =0x000018A4
	add r2, r0, r2
	ldrb r5, [r2, r1]
	mov r2, #0x80
	add r4, r5, #0
	tst r4, r2
	beq _021F6024
	sub r1, r1, #2
	ldrh r1, [r0, r1]
	eor r2, r5
	cmp r1, #0xac
	bne _021F6026
	cmp r2, #2
	bne _021F6020
	mov r2, #1
	b _021F6026
_021F6020:
	mov r2, #0
	b _021F6026
_021F6024:
	mov r2, #0
_021F6026:
	ldr r1, _021F6034 ; =0x000018A2
	ldrh r1, [r0, r1]
	bl ov18_021F14FC
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F6030: .word 0x000018A4
_021F6034: .word 0x000018A2
	thumb_func_end ov18_021F5FFC

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

	thumb_func_start ov18_021F6844
ov18_021F6844: ; 0x021F6844
	ldr r3, _021F6848 ; =ov18_021F5FFC
	bx r3
	.balign 4, 0
_021F6848: .word ov18_021F5FFC
	thumb_func_end ov18_021F6844

	thumb_func_start ov18_021F684C
ov18_021F684C: ; 0x021F684C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	str r3, [sp, #0xc]
	add r3, sp, #0x14
	add r4, r1, #0
	add r1, r2, #0
	add r2, sp, #0x14
	add r3, #1
	add r5, r0, #0
	bl ov18_021F3CA8
	ldr r0, _021F697C ; =0x000018C7
	ldrb r1, [r5, r0]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	bne _021F6872
	mov r6, #2
	mov r0, #0
	b _021F6886
_021F6872:
	mov r6, #0
	str r6, [sp]
	sub r0, #0x25
	add r3, sp, #0x14
	ldrb r1, [r3, #1]
	ldrh r0, [r5, r0]
	ldrb r3, [r3]
	add r2, r6, #0
	bl GetMonPicHeightBySpeciesGenderForm
_021F6886:
	cmp r4, #1
	bne _021F68EC
	add r0, #0x78
	lsl r0, r0, #0x18
	mov r1, #0x40
	lsr r7, r0, #0x18
	ldr r0, _021F697C ; =0x000018C7
	str r1, [sp, #0x10]
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _021F68B8
	mov r4, #3
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	b _021F68CC
_021F68B8:
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #3
	mov r2, #0
	bl ov18_021F11C0
_021F68CC:
	ldr r3, _021F697C ; =0x000018C7
	mov r1, #0x20
	ldrb r2, [r5, r3]
	add r0, r2, #0
	bic r0, r1
	lsl r1, r2, #0x1a
	lsr r2, r1, #0x1f
	mov r1, #1
	eor r1, r2
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	lsl r1, r1, #0x1f
	lsr r1, r1, #0x1a
	orr r0, r1
	strb r0, [r5, r3]
	b _021F6950
_021F68EC:
	cmp r4, #2
	bne _021F6950
	add r0, #0x78
	lsl r0, r0, #0x18
	mov r1, #0xc0
	lsr r7, r0, #0x18
	ldr r0, _021F697C ; =0x000018C7
	str r1, [sp, #0x10]
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _021F691E
	mov r4, #4
	add r0, r5, #0
	mov r1, #2
	mov r2, #0
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #1
	bl ov18_021F11C0
	b _021F6932
_021F691E:
	add r0, r5, #0
	mov r1, #2
	mov r2, #1
	bl ov18_021F11C0
	add r0, r5, #0
	mov r1, #4
	mov r2, #0
	bl ov18_021F11C0
_021F6932:
	ldr r3, _021F697C ; =0x000018C7
	mov r1, #0x40
	ldrb r2, [r5, r3]
	add r0, r2, #0
	bic r0, r1
	lsl r1, r2, #0x19
	lsr r2, r1, #0x1f
	mov r1, #1
	eor r1, r2
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	lsl r1, r1, #0x1f
	lsr r1, r1, #0x19
	orr r0, r1
	strb r0, [r5, r3]
_021F6950:
	str r6, [sp]
	ldr r0, [sp, #0xc]
	str r4, [sp, #4]
	str r0, [sp, #8]
	ldr r1, _021F6980 ; =0x000018A2
	add r3, sp, #0x14
	ldrb r2, [r3]
	ldrh r1, [r5, r1]
	ldrb r3, [r3, #1]
	add r0, r5, #0
	bl ov18_021F1A7C
	mov r0, #1
	str r0, [sp]
	ldr r2, [sp, #0x10]
	add r0, r5, #0
	add r1, r4, #0
	add r3, r7, #0
	bl ov18_021F1294
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F697C: .word 0x000018C7
_021F6980: .word 0x000018A2
	thumb_func_end ov18_021F684C

	thumb_func_start ov18_021F6984
ov18_021F6984: ; 0x021F6984
	push {r3, lr}
	mov r3, #0
	bl ov18_021F684C
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov18_021F6984

	thumb_func_start ov18_021F6990
ov18_021F6990: ; 0x021F6990
	push {r3, lr}
	ldr r1, _021F69BC ; =0x000018C7
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1b
	bne _021F69AC
	mov r1, #0
	str r1, [sp]
	mov r1, #0xd
	mov r2, #0x40
	mov r3, #0x58
	bl ov18_021F1294
	pop {r3, pc}
_021F69AC:
	mov r1, #0
	str r1, [sp]
	mov r1, #0xd
	mov r2, #0xc0
	mov r3, #0x58
	bl ov18_021F1294
	pop {r3, pc}
	.balign 4, 0
_021F69BC: .word 0x000018C7
	thumb_func_end ov18_021F6990

	thumb_func_start ov18_021F69C0
ov18_021F69C0: ; 0x021F69C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r4, r1, #0
	ldr r0, [r0, #4]
	bl PlayerProfile_GetTrainerGender
	cmp r0, #0
	bne _021F69D6
	mov r2, #0
	b _021F69D8
_021F69D6:
	mov r2, #1
_021F69D8:
	cmp r4, #1
	bne _021F69DE
	add r2, r2, #2
_021F69DE:
	add r0, r5, #0
	mov r1, #2
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	thumb_func_end ov18_021F69C0

	thumb_func_start ov18_021F69E8
ov18_021F69E8: ; 0x021F69E8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x3c
	str r2, [sp, #0x14]
	str r3, [sp, #0x18]
	ldr r3, _021F6AA4 ; =ov18_021FA338
	add r2, sp, #0x1c
	add r5, r0, #0
	add r4, r1, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	mov r1, #0x32
	mov r0, #0x25
	lsl r1, r1, #6
	bl Heap_AllocAtEnd
	add r7, r0, #0
	ldr r0, _021F6AA8 ; =0x00000147
	cmp r4, r0
	bne _021F6A20
	ldr r0, [r5]
	mov r1, #0
	ldr r0, [r0]
	bl Pokedex_GetSeenSpindaPersonality
	add r6, r0, #0
	b _021F6A22
_021F6A20:
	mov r6, #0
_021F6A22:
	mov r0, #0
	str r0, [sp]
	ldr r0, [sp, #0x14]
	add r3, sp, #0x40
	str r0, [sp, #4]
	str r6, [sp, #8]
	ldrb r3, [r3, #0x10]
	ldr r2, [sp, #0x18]
	add r0, sp, #0x2c
	add r1, r4, #0
	bl GetMonSpriteCharAndPlttNarcIdsEx
	str r7, [sp]
	str r6, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	str r4, [sp, #0x10]
	add r1, sp, #0x1c
	ldrh r0, [r1, #0x10]
	ldrh r1, [r1, #0x12]
	mov r2, #0x25
	add r3, sp, #0x1c
	bl sub_02014510
	mov r1, #0x32
	add r0, r7, #0
	lsl r1, r1, #6
	mov r2, #0xf
	mov r3, #0x25
	bl Convert4bppTo8bpp
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r3, #0x19
	ldr r0, [r5, #4]
	mov r1, #7
	add r2, r4, #0
	lsl r3, r3, #8
	bl BG_LoadCharTilesData
	add r0, r4, #0
	bl Heap_Free
	add r0, r7, #0
	bl Heap_Free
	mov r3, #0xb
	str r3, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5, #4]
	ldr r2, _021F6AAC ; =ov18_021FB5B4
	mov r1, #7
	bl LoadRectToBgTilemapRect
	ldr r0, [r5, #4]
	mov r1, #7
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x3c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F6AA4: .word ov18_021FA338
_021F6AA8: .word 0x00000147
_021F6AAC: .word ov18_021FB5B4
	thumb_func_end ov18_021F69E8

	thumb_func_start ov18_021F6AB0
ov18_021F6AB0: ; 0x021F6AB0
	push {r4, r5, lr}
	sub sp, #0x1c
	add r5, r0, #0
	mov r0, #1
	add r4, r1, #0
	lsl r0, r0, #0x14
	lsl r1, r2, #0xc
	bl FX_Div
	bl FX_Inv
	mov r2, #0
	str r0, [sp, #0xc]
	str r0, [sp, #0x18]
	str r2, [sp, #0x10]
	str r2, [sp, #0x14]
	add r0, sp, #0xc
	str r0, [sp]
	mov r0, #0x80
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5, #4]
	mov r1, #7
	mov r3, #0x38
	bl Bg_SetTextDimAndAffineParams
	add r0, sp, #0xc
	str r0, [sp]
	mov r0, #0x80
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r3, #0x10
	ldr r0, [r5, #4]
	mov r1, #7
	mov r2, #3
	sub r3, r3, r4
	bl Bg_SetTextDimAndAffineParams
	add sp, #0x1c
	pop {r4, r5, pc}
	thumb_func_end ov18_021F6AB0

	thumb_func_start ov18_021F6B00
ov18_021F6B00: ; 0x021F6B00
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F6BA8 ; =0x00000864
	mov r1, #0
	str r1, [r4, r0]
	bl System_GetTouchNew
	cmp r0, #1
	bne _021F6B3A
	ldr r0, _021F6BAC ; =ov18_021FB72C
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F6B24
	add r0, r1, #0
	pop {r4, pc}
_021F6B24:
	lsl r1, r0, #2
	ldr r0, _021F6BB0 ; =ov18_021FB6F0
	ldr r0, [r0, r1]
	cmp r0, #6
	bne _021F6BA4
	ldr r1, _021F6BB4 ; =0x00001860
	ldr r1, [r4, r1]
	cmp r1, #0
	bne _021F6BA4
	mov r0, #5
	pop {r4, pc}
_021F6B3A:
	ldr r0, _021F6BA8 ; =0x00000864
	mov r1, #1
	str r1, [r4, r0]
	ldr r1, _021F6BB4 ; =0x00001860
	ldr r0, [r4, r1]
	cmp r0, #1
	bne _021F6B7C
	ldr r0, _021F6BB8 ; =gSystem
	ldr r3, [r0, #0x48]
	mov r0, #0x20
	add r2, r3, #0
	tst r2, r0
	beq _021F6B64
	sub r1, #8
	ldrb r1, [r4, r1]
	cmp r1, #0
	bne _021F6B60
	mov r0, #3
	pop {r4, pc}
_021F6B60:
	sub r0, #0x21
	pop {r4, pc}
_021F6B64:
	mov r0, #0x10
	add r2, r3, #0
	tst r2, r0
	beq _021F6B7C
	sub r1, #8
	ldrb r1, [r4, r1]
	cmp r1, #1
	bne _021F6B78
	mov r0, #4
	pop {r4, pc}
_021F6B78:
	sub r0, #0x11
	pop {r4, pc}
_021F6B7C:
	ldr r0, _021F6BB8 ; =gSystem
	mov r1, #1
	ldr r3, [r0, #0x48]
	add r0, r3, #0
	tst r0, r1
	bne _021F6B8E
	mov r0, #8
	tst r0, r3
	beq _021F6B92
_021F6B8E:
	mov r0, #0
	pop {r4, pc}
_021F6B92:
	mov r0, #2
	add r2, r3, #0
	tst r2, r0
	bne _021F6BA4
	lsl r2, r0, #0xa
	tst r2, r3
	bne _021F6BA2
	sub r1, r0, #3
_021F6BA2:
	add r0, r1, #0
_021F6BA4:
	pop {r4, pc}
	nop
_021F6BA8: .word 0x00000864
_021F6BAC: .word ov18_021FB72C
_021F6BB0: .word ov18_021FB6F0
_021F6BB4: .word 0x00001860
_021F6BB8: .word gSystem
	thumb_func_end ov18_021F6B00

	thumb_func_start ov18_021F6BBC
ov18_021F6BBC: ; 0x021F6BBC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r1, #0
	ldr r0, _021F6DBC ; =0x00000864
	mov r1, #0
	str r1, [r5, r0]
	add r0, sp, #4
	add r1, sp, #0
	bl System_GetTouchNewCoords
	cmp r0, #1
	bne _021F6C5C
	ldr r0, _021F6DC0 ; =ov18_021FB8A4
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F6BEA
	add sp, #8
	add r0, r1, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6BEA:
	lsl r1, r0, #2
	ldr r0, _021F6DC4 ; =ov18_021FB84C
	ldr r4, [r0, r1]
	cmp r4, #0
	bne _021F6C32
	ldr r1, [sp]
	ldr r0, [sp, #4]
	sub r1, r1, #4
	sub r0, #0x1b
	str r1, [sp]
	mov r1, #0x28
	str r0, [sp, #4]
	bl _u32_div_f
	add r6, r0, #0
	ldr r0, [sp]
	mov r1, #0x28
	bl _u32_div_f
	lsl r1, r0, #2
	add r0, r0, r1
	add r0, r6, r0
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	ldr r0, _021F6DC8 ; =0x0000185A
	ldrb r1, [r5, r0]
	cmp r2, r1
	bne _021F6C28
	add sp, #8
	mov r0, #4
	pop {r3, r4, r5, r6, r7, pc}
_021F6C28:
	strb r2, [r5, r0]
	ldr r0, _021F6DCC ; =0x000008E9
	bl PlaySE
	b _021F6C56
_021F6C32:
	cmp r4, #0xe
	bne _021F6C3E
	ldr r0, _021F6DD0 ; =0x000008F2
	bl PlaySE
	b _021F6C56
_021F6C3E:
	cmp r4, #2
	bne _021F6C4A
	ldr r0, _021F6DCC ; =0x000008E9
	bl PlaySE
	b _021F6C56
_021F6C4A:
	cmp r4, #5
	bne _021F6C56
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
_021F6C56:
	add sp, #8
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6C5C:
	ldr r2, _021F6DBC ; =0x00000864
	mov r6, #1
	ldr r7, _021F6DD4 ; =gSystem
	str r6, [r5, r2]
	ldr r3, [r7, #0x4c]
	mov r0, #0x40
	tst r0, r3
	beq _021F6C8C
	ldr r0, _021F6DC8 ; =0x0000185A
	ldrb r1, [r5, r0]
	cmp r1, #5
	bhs _021F6C7A
	add sp, #8
	mov r0, #0xa
	pop {r3, r4, r5, r6, r7, pc}
_021F6C7A:
	sub r1, r1, #5
	add r2, #0x84
	strb r1, [r5, r0]
	add r0, r2, #0
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6C8C:
	mov r0, #0x80
	tst r0, r3
	beq _021F6CB8
	ldr r0, _021F6DC8 ; =0x0000185A
	ldrb r0, [r5, r0]
	cmp r0, #0xa
	blo _021F6CA4
	cmp r0, #0xf
	bhs _021F6CA4
	add sp, #8
	mov r0, #0xc
	pop {r3, r4, r5, r6, r7, pc}
_021F6CA4:
	ldr r0, _021F6DC8 ; =0x0000185A
	ldrb r1, [r5, r0]
	add r1, r1, #5
	strb r1, [r5, r0]
	ldr r0, _021F6DD8 ; =0x000008E8
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6CB8:
	mov r0, #0x20
	add r1, r3, #0
	tst r1, r0
	beq _021F6CF2
	ldr r3, _021F6DC8 ; =0x0000185A
	ldrb r1, [r5, r3]
	cmp r1, #0
	beq _021F6CDA
	sub r0, r1, #1
	add r2, #0x84
	strb r0, [r5, r3]
	add r0, r2, #0
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6CDA:
	sub r1, r3, #1
	ldrb r1, [r5, r1]
	cmp r1, #0
	beq _021F6CEC
	mov r0, #0xe
	strb r0, [r5, r3]
	add sp, #8
	mov r0, #9
	pop {r3, r4, r5, r6, r7, pc}
_021F6CEC:
	add sp, #8
	sub r0, #0x21
	pop {r3, r4, r5, r6, r7, pc}
_021F6CF2:
	mov r0, #0x10
	tst r0, r3
	beq _021F6D36
	ldr r0, _021F6DC8 ; =0x0000185A
	ldrb r1, [r5, r0]
	add r1, r1, #1
	cmp r1, #0xf
	beq _021F6D12
	add r2, #0x84
	strb r1, [r5, r0]
	add r0, r2, #0
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6D12:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F8950
	ldr r1, _021F6DDC ; =0x00001859
	ldrb r2, [r5, r1]
	add r2, r2, #1
	cmp r2, r0
	bhi _021F6D30
	mov r2, #0
	add r0, r1, #1
	strb r2, [r5, r0]
	add sp, #8
	mov r0, #0xb
	pop {r3, r4, r5, r6, r7, pc}
_021F6D30:
	add sp, #8
	sub r0, r6, #2
	pop {r3, r4, r5, r6, r7, pc}
_021F6D36:
	ldr r1, [r7, #0x48]
	add r0, r1, #0
	tst r0, r6
	beq _021F6D44
	add sp, #8
	mov r0, #4
	pop {r3, r4, r5, r6, r7, pc}
_021F6D44:
	mov r4, #2
	add r0, r1, #0
	tst r0, r4
	beq _021F6D5A
	add r2, #0xdc
	add r0, r2, #0
	bl PlaySE
	add sp, #8
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021F6D5A:
	lsl r0, r4, #9
	tst r0, r1
	beq _021F6D66
	add sp, #8
	mov r0, #3
	pop {r3, r4, r5, r6, r7, pc}
_021F6D66:
	lsl r0, r4, #0xa
	tst r0, r1
	beq _021F6D7A
	add r2, #0x85
	add r0, r2, #0
	bl PlaySE
	add sp, #8
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6D7A:
	lsl r0, r4, #8
	tst r0, r3
	beq _021F6D86
	add sp, #8
	mov r0, #9
	pop {r3, r4, r5, r6, r7, pc}
_021F6D86:
	add r4, #0xfe
	add r0, r3, #0
	tst r0, r4
	beq _021F6D94
	add sp, #8
	mov r0, #0xb
	pop {r3, r4, r5, r6, r7, pc}
_021F6D94:
	mov r0, #4
	tst r0, r1
	beq _021F6DA0
	add sp, #8
	mov r0, #8
	pop {r3, r4, r5, r6, r7, pc}
_021F6DA0:
	mov r0, #8
	tst r1, r0
	beq _021F6DB4
	add r2, #0x8e
	add r0, r2, #0
	bl PlaySE
	add sp, #8
	add r0, r6, #0
	pop {r3, r4, r5, r6, r7, pc}
_021F6DB4:
	sub r0, #9
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F6DBC: .word 0x00000864
_021F6DC0: .word ov18_021FB8A4
_021F6DC4: .word ov18_021FB84C
_021F6DC8: .word 0x0000185A
_021F6DCC: .word 0x000008E9
_021F6DD0: .word 0x000008F2
_021F6DD4: .word gSystem
_021F6DD8: .word 0x000008E8
_021F6DDC: .word 0x00001859
	thumb_func_end ov18_021F6BBC

	thumb_func_start ov18_021F6DE0
ov18_021F6DE0: ; 0x021F6DE0
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #1
	str r0, [sp]
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F6E1C ; =ov18_021FB878
	ldr r1, _021F6E20 ; =ov18_021FB9F0
	ldr r2, _021F6E24 ; =ov18_021FB688
	add r3, r5, #0
	bl GridInputHandler_Create
	ldr r1, _021F6E28 ; =0x00001864
	mov r2, #1
	str r0, [r5, r1]
	add r0, r5, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F6E58
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_021F6E1C: .word ov18_021FB878
_021F6E20: .word ov18_021FB9F0
_021F6E24: .word ov18_021FB688
_021F6E28: .word 0x00001864
	thumb_func_end ov18_021F6DE0

	thumb_func_start ov18_021F6E2C
ov18_021F6E2C: ; 0x021F6E2C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F6E50 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #8
	tst r1, r0
	bne _021F6E4C
	ldr r0, _021F6E54 ; =0x00001864
	ldr r0, [r4, r0]
	bl GridInputHandler_HandleInput_AllowHold
_021F6E4C:
	pop {r4, pc}
	nop
_021F6E50: .word gSystem
_021F6E54: .word 0x00001864
	thumb_func_end ov18_021F6E2C

	thumb_func_start ov18_021F6E58
ov18_021F6E58: ; 0x021F6E58
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F6E90 ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	ldr r2, _021F6E94 ; =ov18_021FBD1C
	add r0, r5, #0
	ldrb r2, [r2, r4]
	mov r1, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	nop
_021F6E90: .word 0x00001864
_021F6E94: .word ov18_021FBD1C
	thumb_func_end ov18_021F6E58

	thumb_func_start ov18_021F6E98
ov18_021F6E98: ; 0x021F6E98
	push {r3, lr}
	bl ov18_021F6E58
	ldr r0, _021F6EA8 ; =0x000008E8
	bl PlaySE
	pop {r3, pc}
	nop
_021F6EA8: .word 0x000008E8
	thumb_func_end ov18_021F6E98

	thumb_func_start ov18_021F6EAC
ov18_021F6EAC: ; 0x021F6EAC
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F6E58
	ldr r0, [r4]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	pop {r4, pc}
	thumb_func_end ov18_021F6EAC

	thumb_func_start ov18_021F6EC0
ov18_021F6EC0: ; 0x021F6EC0
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F6EF8 ; =ov18_021FB828
	ldr r1, _021F6EFC ; =ov18_021FB968
	ldr r2, _021F6F00 ; =ov18_021FB668
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, _021F6F04 ; =0x00001864
	mov r2, #1
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F6F38
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F6EF8: .word ov18_021FB828
_021F6EFC: .word ov18_021FB968
_021F6F00: .word ov18_021FB668
_021F6F04: .word 0x00001864
	thumb_func_end ov18_021F6EC0

	thumb_func_start ov18_021F6F08
ov18_021F6F08: ; 0x021F6F08
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F6F30 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #8
	tst r0, r1
	beq _021F6F24
	mov r0, #6
	pop {r4, pc}
_021F6F24:
	ldr r0, _021F6F34 ; =0x00001864
	ldr r0, [r4, r0]
	bl GridInputHandler_HandleInput_AllowHold
	pop {r4, pc}
	nop
_021F6F30: .word gSystem
_021F6F34: .word 0x00001864
	thumb_func_end ov18_021F6F08

	thumb_func_start ov18_021F6F38
ov18_021F6F38: ; 0x021F6F38
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F6F70 ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	ldr r2, _021F6F74 ; =ov18_021FB628
	add r0, r5, #0
	ldrb r2, [r2, r4]
	mov r1, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	nop
_021F6F70: .word 0x00001864
_021F6F74: .word ov18_021FB628
	thumb_func_end ov18_021F6F38

	thumb_func_start ov18_021F6F78
ov18_021F6F78: ; 0x021F6F78
	push {r3, lr}
	bl ov18_021F6F38
	ldr r0, _021F6F88 ; =0x000008E8
	bl PlaySE
	pop {r3, pc}
	nop
_021F6F88: .word 0x000008E8
	thumb_func_end ov18_021F6F78

	thumb_func_start ov18_021F6F8C
ov18_021F6F8C: ; 0x021F6F8C
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F6F38
	ldr r0, [r4]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	pop {r4, pc}
	thumb_func_end ov18_021F6F8C

	thumb_func_start ov18_021F6FA0
ov18_021F6FA0: ; 0x021F6FA0
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F6FD8 ; =ov18_021FBA94
	ldr r1, _021F6FDC ; =ov18_021FBC34
	ldr r2, _021F6FE0 ; =ov18_021FB6A8
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, _021F6FE4 ; =0x00001864
	mov r2, #1
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F7018
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F6FD8: .word ov18_021FBA94
_021F6FDC: .word ov18_021FBC34
_021F6FE0: .word ov18_021FB6A8
_021F6FE4: .word 0x00001864
	thumb_func_end ov18_021F6FA0

	thumb_func_start ov18_021F6FE8
ov18_021F6FE8: ; 0x021F6FE8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F7010 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #8
	tst r0, r1
	beq _021F7004
	mov r0, #0x1b
	pop {r4, pc}
_021F7004:
	ldr r0, _021F7014 ; =0x00001864
	ldr r0, [r4, r0]
	bl GridInputHandler_HandleInput_AllowHold
	pop {r4, pc}
	nop
_021F7010: .word gSystem
_021F7014: .word 0x00001864
	thumb_func_end ov18_021F6FE8

	thumb_func_start ov18_021F7018
ov18_021F7018: ; 0x021F7018
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F705C ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	cmp r4, #0x1b
	blt _021F7050
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x23
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
_021F7050:
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x28
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F705C: .word 0x00001864
	thumb_func_end ov18_021F7018

	thumb_func_start ov18_021F7060
ov18_021F7060: ; 0x021F7060
	push {r4, r5, r6, lr}
	add r6, r2, #0
	add r5, r0, #0
	add r0, r6, #0
	sub r0, #0x1b
	add r4, r1, #0
	cmp r0, #1
	bhi _021F70DA
	ldr r0, _021F70F0 ; =0x0000189C
	ldr r0, [r5, r0]
	lsl r1, r0, #3
	ldr r0, _021F70F4 ; =ov18_021FBC34
	cmp r4, #0
	ldrb r0, [r0, r1]
	beq _021F7082
	cmp r4, #6
	bne _021F70AC
_021F7082:
	ldr r3, _021F70F4 ; =ov18_021FBC34
	mov r1, #0
ov18_021F7086:
	ldrb r2, [r3]
	cmp r0, r2
	bne _021F70A2
	ldr r0, _021F70F8 ; =0x00001864
	lsl r2, r6, #0x18
	add r4, r1, #0
	lsl r1, r1, #0x18
	lsr r2, r2, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F70DA
_021F70A2:
	add r1, r1, #1
	add r3, #8
	cmp r1, #0x1a
	ble ov18_021F7086
	b _021F70DA
_021F70AC:
	cmp r4, #0x15
	beq _021F70B4
	cmp r4, #0x1a
	bne _021F70DA
_021F70B4:
	ldr r3, _021F70FC ; =ov18_021FBC34 + 0xD0
	mov r1, #0x1a
_021F70B8:
	ldrb r2, [r3]
	cmp r0, r2
	bne _021F70D4
	ldr r0, _021F70F8 ; =0x00001864
	lsl r2, r6, #0x18
	add r4, r1, #0
	lsl r1, r1, #0x18
	lsr r2, r2, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F70DA
_021F70D4:
	sub r3, #8
	sub r1, r1, #1
	bpl _021F70B8
_021F70DA:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F7018
	ldr r0, _021F70F0 ; =0x0000189C
	str r6, [r5, r0]
	ldr r0, _021F7100 ; =0x000008E8
	bl PlaySE
	pop {r4, r5, r6, pc}
	nop
_021F70F0: .word 0x0000189C
_021F70F4: .word ov18_021FBC34
_021F70F8: .word 0x00001864
_021F70FC: .word ov18_021FBC34 + 0xD0
_021F7100: .word 0x000008E8
	thumb_func_end ov18_021F7060

	thumb_func_start ov18_021F7104
ov18_021F7104: ; 0x021F7104
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	bl ov18_021F7018
	ldr r0, [r5]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F7120 ; =0x0000189C
	str r4, [r5, r0]
	pop {r3, r4, r5, pc}
	nop
_021F7120: .word 0x0000189C
	thumb_func_end ov18_021F7104

	thumb_func_start ov18_021F7124
ov18_021F7124: ; 0x021F7124
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F715C ; =ov18_021FBA40
	ldr r1, _021F7160 ; =ov18_021FBB94
	ldr r2, _021F7164 ; =ov18_021FB638
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, _021F7168 ; =0x00001864
	mov r2, #1
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F719C
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F715C: .word ov18_021FBA40
_021F7160: .word ov18_021FBB94
_021F7164: .word ov18_021FB638
_021F7168: .word 0x00001864
	thumb_func_end ov18_021F7124

	thumb_func_start ov18_021F716C
ov18_021F716C: ; 0x021F716C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F7194 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #8
	tst r0, r1
	beq _021F7188
	mov r0, #0x12
	pop {r4, pc}
_021F7188:
	ldr r0, _021F7198 ; =0x00001864
	ldr r0, [r4, r0]
	bl GridInputHandler_HandleInput_AllowHold
	pop {r4, pc}
	nop
_021F7194: .word gSystem
_021F7198: .word 0x00001864
	thumb_func_end ov18_021F716C

	thumb_func_start ov18_021F719C
ov18_021F719C: ; 0x021F719C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F71D4 ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	ldr r2, _021F71D8 ; =ov18_021FBD3C
	add r0, r5, #0
	ldrb r2, [r2, r4]
	mov r1, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	nop
_021F71D4: .word 0x00001864
_021F71D8: .word ov18_021FBD3C
	thumb_func_end ov18_021F719C

	thumb_func_start ov18_021F71DC
ov18_021F71DC: ; 0x021F71DC
	push {r4, r5, r6, lr}
	add r6, r2, #0
	add r5, r0, #0
	add r4, r1, #0
	cmp r6, #0x12
	bne _021F727C
	cmp r4, #0
	bne _021F7236
	ldr r0, _021F7328 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #0x10
	blt _021F7218
	cmp r1, #0x11
	bgt _021F7218
	lsr r3, r1, #0x1f
	lsl r2, r1, #0x1e
	sub r2, r2, r3
	mov r1, #0x1e
	ror r2, r1
	add r4, r3, r2
	sub r0, #0x38
	lsl r1, r4, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x12
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7312
_021F7218:
	cmp r1, #0
	blt _021F7312
	cmp r1, #1
	bgt _021F7312
	ldr r0, _021F732C ; =0x00001864
	add r4, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x12
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7312
_021F7236:
	cmp r4, #0x10
	bne _021F7312
	ldr r0, _021F7328 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #0
	blt _021F725E
	cmp r1, #1
	bgt _021F725E
	add r4, r1, #0
	add r4, #0x10
	sub r0, #0x38
	lsl r1, r4, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x12
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7312
_021F725E:
	cmp r1, #0x10
	blt _021F7312
	cmp r1, #0x11
	bgt _021F7312
	ldr r0, _021F732C ; =0x00001864
	add r4, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x12
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7312
_021F727C:
	cmp r6, #0x13
	bne _021F7312
	cmp r4, #3
	bne _021F72CE
	ldr r0, _021F7328 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #0xe
	blt _021F72B0
	cmp r1, #0xf
	bgt _021F72B0
	lsr r3, r1, #0x1f
	lsl r2, r1, #0x1e
	sub r2, r2, r3
	mov r1, #0x1e
	ror r2, r1
	add r4, r3, r2
	sub r0, #0x38
	lsl r1, r4, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x13
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7312
_021F72B0:
	cmp r1, #2
	blt _021F7312
	cmp r1, #3
	bgt _021F7312
	ldr r0, _021F732C ; =0x00001864
	add r4, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x13
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7312
_021F72CE:
	cmp r4, #0xf
	bne _021F7312
	ldr r0, _021F7328 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #2
	blt _021F72F6
	cmp r1, #3
	bgt _021F72F6
	add r4, r1, #0
	add r4, #0xc
	sub r0, #0x38
	lsl r1, r4, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x13
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7312
_021F72F6:
	cmp r1, #0xe
	blt _021F7312
	cmp r1, #0xf
	bgt _021F7312
	ldr r0, _021F732C ; =0x00001864
	add r4, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r6, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x13
	bl GridInputHandler_SetNextLastUnk0FInputs
_021F7312:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F719C
	ldr r0, _021F7328 ; =0x0000189C
	str r6, [r5, r0]
	ldr r0, _021F7330 ; =0x000008E8
	bl PlaySE
	pop {r4, r5, r6, pc}
	nop
_021F7328: .word 0x0000189C
_021F732C: .word 0x00001864
_021F7330: .word 0x000008E8
	thumb_func_end ov18_021F71DC

	thumb_func_start ov18_021F7334
ov18_021F7334: ; 0x021F7334
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	bl ov18_021F719C
	ldr r0, [r5]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F7350 ; =0x0000189C
	str r4, [r5, r0]
	pop {r3, r4, r5, pc}
	nop
_021F7350: .word 0x0000189C
	thumb_func_end ov18_021F7334

	thumb_func_start ov18_021F7354
ov18_021F7354: ; 0x021F7354
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F738C ; =ov18_021FB6C8
	ldr r1, _021F7390 ; =ov18_021FB780
	ldr r2, _021F7394 ; =ov18_021FB648
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, _021F7398 ; =0x00001864
	mov r2, #1
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F7444
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F738C: .word ov18_021FB6C8
_021F7390: .word ov18_021FB780
_021F7394: .word ov18_021FB648
_021F7398: .word 0x00001864
	thumb_func_end ov18_021F7354

	thumb_func_start ov18_021F739C
ov18_021F739C: ; 0x021F739C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, _021F7438 ; =0x00001864
	ldr r0, [r5, r0]
	bl GridInputHandler_GetNextInput
	add r4, r0, #0
	ldr r0, [r5]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r1, _021F743C ; =gSystem
	mov r0, #8
	ldr r2, [r1, #0x48]
	tst r0, r2
	beq _021F73C2
	mov r0, #2
	pop {r4, r5, r6, pc}
_021F73C2:
	cmp r4, #0
	bne _021F73DC
	ldr r1, [r1, #0x4c]
	mov r0, #0x20
	tst r0, r1
	beq _021F73D2
	mov r0, #5
	pop {r4, r5, r6, pc}
_021F73D2:
	mov r0, #0x10
	tst r0, r1
	beq _021F73DC
	mov r0, #4
	pop {r4, r5, r6, pc}
_021F73DC:
	cmp r4, #1
	bne _021F73F8
	ldr r0, _021F743C ; =gSystem
	ldr r1, [r0, #0x4c]
	mov r0, #0x20
	tst r0, r1
	beq _021F73EE
	mov r0, #7
	pop {r4, r5, r6, pc}
_021F73EE:
	mov r0, #0x10
	tst r0, r1
	beq _021F73F8
	mov r0, #6
	pop {r4, r5, r6, pc}
_021F73F8:
	ldr r0, _021F7440 ; =ov18_021FB718
	bl TouchscreenHitbox_FindRectAtTouchHeld
	add r6, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r6, r0
	beq _021F742C
	ldr r0, [r5]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F7438 ; =0x00001864
	lsr r4, r6, #1
	lsl r1, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F7444
	add r0, r6, #4
	pop {r4, r5, r6, pc}
_021F742C:
	ldr r0, _021F7438 ; =0x00001864
	ldr r0, [r5, r0]
	bl GridInputHandler_HandleInput_AllowHold
	pop {r4, r5, r6, pc}
	nop
_021F7438: .word 0x00001864
_021F743C: .word gSystem
_021F7440: .word ov18_021FB718
	thumb_func_end ov18_021F739C

	thumb_func_start ov18_021F7444
ov18_021F7444: ; 0x021F7444
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F74A0 ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	cmp r4, #0
	bne _021F7470
	ldr r1, _021F74A4 ; =0x0000187C
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov18_021F3AD0
	add r1, sp, #0
	strb r0, [r1, #1]
	b _021F7482
_021F7470:
	cmp r4, #1
	bne _021F7482
	ldr r1, _021F74A8 ; =0x00001878
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov18_021F3AD0
	add r1, sp, #0
	strb r0, [r1, #1]
_021F7482:
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	ldr r2, _021F74AC ; =ov18_021FB618
	add r0, r5, #0
	ldrb r2, [r2, r4]
	mov r1, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F74A0: .word 0x00001864
_021F74A4: .word 0x0000187C
_021F74A8: .word 0x00001878
_021F74AC: .word ov18_021FB618
	thumb_func_end ov18_021F7444

	thumb_func_start ov18_021F74B0
ov18_021F74B0: ; 0x021F74B0
	push {r3, lr}
	bl ov18_021F7444
	ldr r0, _021F74C0 ; =0x000008E8
	bl PlaySE
	pop {r3, pc}
	nop
_021F74C0: .word 0x000008E8
	thumb_func_end ov18_021F74B0

	thumb_func_start ov18_021F74C4
ov18_021F74C4: ; 0x021F74C4
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F7444
	ldr r0, [r4]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	pop {r4, pc}
	thumb_func_end ov18_021F74C4

	thumb_func_start ov18_021F74D8
ov18_021F74D8: ; 0x021F74D8
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F7510 ; =ov18_021FB6DC
	ldr r1, _021F7514 ; =ov18_021FB7A0
	ldr r2, _021F7518 ; =ov18_021FB678
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, _021F751C ; =0x00001864
	mov r2, #1
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F75C8
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F7510: .word ov18_021FB6DC
_021F7514: .word ov18_021FB7A0
_021F7518: .word ov18_021FB678
_021F751C: .word 0x00001864
	thumb_func_end ov18_021F74D8

	thumb_func_start ov18_021F7520
ov18_021F7520: ; 0x021F7520
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, _021F75BC ; =0x00001864
	ldr r0, [r5, r0]
	bl GridInputHandler_GetNextInput
	add r4, r0, #0
	ldr r0, [r5]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r1, _021F75C0 ; =gSystem
	mov r0, #8
	ldr r2, [r1, #0x48]
	tst r0, r2
	beq _021F7546
	mov r0, #2
	pop {r4, r5, r6, pc}
_021F7546:
	cmp r4, #0
	bne _021F7560
	ldr r1, [r1, #0x4c]
	mov r0, #0x20
	tst r0, r1
	beq _021F7556
	mov r0, #5
	pop {r4, r5, r6, pc}
_021F7556:
	mov r0, #0x10
	tst r0, r1
	beq _021F7560
	mov r0, #4
	pop {r4, r5, r6, pc}
_021F7560:
	cmp r4, #1
	bne _021F757C
	ldr r0, _021F75C0 ; =gSystem
	ldr r1, [r0, #0x4c]
	mov r0, #0x20
	tst r0, r1
	beq _021F7572
	mov r0, #7
	pop {r4, r5, r6, pc}
_021F7572:
	mov r0, #0x10
	tst r0, r1
	beq _021F757C
	mov r0, #6
	pop {r4, r5, r6, pc}
_021F757C:
	ldr r0, _021F75C4 ; =ov18_021FB718
	bl TouchscreenHitbox_FindRectAtTouchHeld
	add r6, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r6, r0
	beq _021F75B0
	ldr r0, [r5]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F75BC ; =0x00001864
	lsr r4, r6, #1
	lsl r1, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F75C8
	add r0, r6, #4
	pop {r4, r5, r6, pc}
_021F75B0:
	ldr r0, _021F75BC ; =0x00001864
	ldr r0, [r5, r0]
	bl GridInputHandler_HandleInput_AllowHold
	pop {r4, r5, r6, pc}
	nop
_021F75BC: .word 0x00001864
_021F75C0: .word gSystem
_021F75C4: .word ov18_021FB718
	thumb_func_end ov18_021F7520

	thumb_func_start ov18_021F75C8
ov18_021F75C8: ; 0x021F75C8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F7628 ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	cmp r4, #0
	bne _021F75F4
	ldr r1, _021F762C ; =0x00001884
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov18_021F3AD0
	add r1, sp, #0
	strb r0, [r1, #1]
	b _021F7608
_021F75F4:
	cmp r4, #1
	bne _021F7608
	mov r1, #0x62
	lsl r1, r1, #6
	ldr r1, [r5, r1]
	add r0, r5, #0
	bl ov18_021F3AD0
	add r1, sp, #0
	strb r0, [r1, #1]
_021F7608:
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	ldr r2, _021F7630 ; =ov18_021FB61C
	add r0, r5, #0
	ldrb r2, [r2, r4]
	mov r1, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	nop
_021F7628: .word 0x00001864
_021F762C: .word 0x00001884
_021F7630: .word ov18_021FB61C
	thumb_func_end ov18_021F75C8

	thumb_func_start ov18_021F7634
ov18_021F7634: ; 0x021F7634
	push {r3, lr}
	bl ov18_021F75C8
	ldr r0, _021F7644 ; =0x000008E8
	bl PlaySE
	pop {r3, pc}
	nop
_021F7644: .word 0x000008E8
	thumb_func_end ov18_021F7634

	thumb_func_start ov18_021F7648
ov18_021F7648: ; 0x021F7648
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F75C8
	ldr r0, [r4]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	pop {r4, pc}
	thumb_func_end ov18_021F7648

	thumb_func_start ov18_021F765C
ov18_021F765C: ; 0x021F765C
	push {r3, lr}
	add r1, sp, #0
	bl System_GetTouchHeldCoords
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov18_021F765C

	thumb_func_start ov18_021F7668
ov18_021F7668: ; 0x021F7668
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F76A0 ; =ov18_021FB744
	ldr r1, _021F76A4 ; =ov18_021FB8D4
	ldr r2, _021F76A8 ; =ov18_021FB6B8
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, _021F76AC ; =0x00001864
	mov r2, #1
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F76E0
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F76A0: .word ov18_021FB744
_021F76A4: .word ov18_021FB8D4
_021F76A8: .word ov18_021FB6B8
_021F76AC: .word 0x00001864
	thumb_func_end ov18_021F7668

	thumb_func_start ov18_021F76B0
ov18_021F76B0: ; 0x021F76B0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F76D8 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #8
	tst r0, r1
	beq _021F76CC
	mov r0, #4
	pop {r4, pc}
_021F76CC:
	ldr r0, _021F76DC ; =0x00001864
	ldr r0, [r4, r0]
	bl GridInputHandler_HandleInput_AllowHold
	pop {r4, pc}
	nop
_021F76D8: .word gSystem
_021F76DC: .word 0x00001864
	thumb_func_end ov18_021F76B0

	thumb_func_start ov18_021F76E0
ov18_021F76E0: ; 0x021F76E0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F7718 ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	ldr r2, _021F771C ; =ov18_021FB620
	add r0, r5, #0
	ldrb r2, [r2, r4]
	mov r1, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	nop
_021F7718: .word 0x00001864
_021F771C: .word ov18_021FB620
	thumb_func_end ov18_021F76E0

	thumb_func_start ov18_021F7720
ov18_021F7720: ; 0x021F7720
	push {r3, lr}
	bl ov18_021F76E0
	ldr r0, _021F7730 ; =0x000008E8
	bl PlaySE
	pop {r3, pc}
	nop
_021F7730: .word 0x000008E8
	thumb_func_end ov18_021F7720

	thumb_func_start ov18_021F7734
ov18_021F7734: ; 0x021F7734
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F76E0
	ldr r0, [r4]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	pop {r4, pc}
	thumb_func_end ov18_021F7734

	thumb_func_start ov18_021F7748
ov18_021F7748: ; 0x021F7748
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x25
	str r0, [sp, #8]
	ldr r0, _021F7780 ; =ov18_021FB9A8
	ldr r1, _021F7784 ; =ov18_021FBB0C
	ldr r2, _021F7788 ; =ov18_021FB658
	add r3, r4, #0
	bl GridInputHandler_Create
	ldr r1, _021F778C ; =0x00001864
	mov r2, #1
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F11C0
	add r0, r4, #0
	mov r1, #0
	bl ov18_021F77C0
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F7780: .word ov18_021FB9A8
_021F7784: .word ov18_021FBB0C
_021F7788: .word ov18_021FB658
_021F778C: .word 0x00001864
	thumb_func_end ov18_021F7748

	thumb_func_start ov18_021F7790
ov18_021F7790: ; 0x021F7790
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #0
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F77B8 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #8
	tst r0, r1
	beq _021F77AC
	mov r0, #0xf
	pop {r4, pc}
_021F77AC:
	ldr r0, _021F77BC ; =0x00001864
	ldr r0, [r4, r0]
	bl GridInputHandler_HandleInput_AllowHold
	pop {r4, pc}
	nop
_021F77B8: .word gSystem
_021F77BC: .word 0x00001864
	thumb_func_end ov18_021F7790

	thumb_func_start ov18_021F77C0
ov18_021F77C0: ; 0x021F77C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021F77F8 ; =0x00001864
	add r4, r1, #0
	ldr r0, [r5, r0]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x67
	add r2, sp, #0
	lsl r0, r0, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	ldr r0, [r5, r0]
	bl ManagedSprite_SetPositionXY
	ldr r2, _021F77FC ; =ov18_021FBD28
	add r0, r5, #0
	ldrb r2, [r2, r4]
	mov r1, #0
	bl ov18_021F118C
	pop {r3, r4, r5, pc}
	nop
_021F77F8: .word 0x00001864
_021F77FC: .word ov18_021FBD28
	thumb_func_end ov18_021F77C0

	thumb_func_start ov18_021F7800
ov18_021F7800: ; 0x021F7800
	push {r4, r5, r6, lr}
	add r4, r2, #0
	add r5, r0, #0
	add r6, r1, #0
	cmp r4, #0xf
	bne _021F789E
	cmp r6, #0
	bne _021F7858
	ldr r0, _021F7948 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #0
	blt _021F7832
	cmp r1, #2
	bgt _021F7832
	sub r0, #0x38
	add r6, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0xf
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7932
_021F7832:
	cmp r1, #0xa
	blt _021F7932
	cmp r1, #0xc
	bgt _021F7932
	add r0, r1, #0
	mov r1, #5
	bl _s32_div_f
	ldr r0, _021F794C ; =0x00001864
	add r6, r1, #0
	lsl r1, r6, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0xf
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7932
_021F7858:
	cmp r6, #0xa
	bne _021F7932
	ldr r0, _021F7948 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #0
	blt _021F7880
	cmp r1, #2
	bgt _021F7880
	add r6, r1, #0
	add r6, #0xa
	sub r0, #0x38
	lsl r1, r6, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0xf
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7932
_021F7880:
	cmp r1, #0xa
	blt _021F7932
	cmp r1, #0xc
	bgt _021F7932
	ldr r0, _021F794C ; =0x00001864
	add r6, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0xf
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7932
_021F789E:
	cmp r4, #0x10
	bne _021F7932
	cmp r6, #4
	bne _021F78EE
	ldr r0, _021F7948 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #3
	blt _021F78C8
	cmp r1, #4
	bgt _021F78C8
	sub r0, #0x38
	add r6, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x10
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7932
_021F78C8:
	cmp r1, #0xd
	blt _021F7932
	cmp r1, #0xe
	bgt _021F7932
	add r0, r1, #0
	mov r1, #5
	bl _s32_div_f
	ldr r0, _021F794C ; =0x00001864
	add r6, r1, #0
	lsl r1, r6, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x10
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7932
_021F78EE:
	cmp r6, #0xe
	bne _021F7932
	ldr r0, _021F7948 ; =0x0000189C
	ldr r1, [r5, r0]
	cmp r1, #3
	blt _021F7916
	cmp r1, #4
	bgt _021F7916
	add r6, r1, #0
	add r6, #0xa
	sub r0, #0x38
	lsl r1, r6, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x10
	bl GridInputHandler_SetNextLastUnk0FInputs
	b _021F7932
_021F7916:
	cmp r1, #0xd
	blt _021F7932
	cmp r1, #0xe
	bgt _021F7932
	ldr r0, _021F794C ; =0x00001864
	add r6, r1, #0
	lsl r1, r1, #0x18
	lsl r2, r4, #0x18
	ldr r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	mov r3, #0x10
	bl GridInputHandler_SetNextLastUnk0FInputs
_021F7932:
	add r0, r5, #0
	add r1, r6, #0
	bl ov18_021F77C0
	ldr r0, _021F7948 ; =0x0000189C
	str r4, [r5, r0]
	ldr r0, _021F7950 ; =0x000008E8
	bl PlaySE
	pop {r4, r5, r6, pc}
	nop
_021F7948: .word 0x0000189C
_021F794C: .word 0x00001864
_021F7950: .word 0x000008E8
	thumb_func_end ov18_021F7800

	thumb_func_start ov18_021F7954
ov18_021F7954: ; 0x021F7954
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	bl ov18_021F77C0
	ldr r0, [r5]
	mov r1, #1
	ldr r0, [r0, #0xc]
	bl MenuInputStateMgr_SetState
	ldr r0, _021F7970 ; =0x0000189C
	str r4, [r5, r0]
	pop {r3, r4, r5, pc}
	nop
_021F7970: .word 0x0000189C
	thumb_func_end ov18_021F7954

	thumb_func_start ov18_021F7974
ov18_021F7974: ; 0x021F7974
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r1, #0
	add r0, sp, #4
	add r1, sp, #0
	bl System_GetTouchNewCoords
	cmp r0, #1
	bne _021F7A1A
	ldr r0, _021F7B58 ; =ov18_021FB8A4
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F799C
	add sp, #8
	add r0, r1, #0
	pop {r4, r5, r6, pc}
_021F799C:
	lsl r1, r0, #2
	ldr r0, _021F7B5C ; =ov18_021FB84C
	ldr r4, [r0, r1]
	cmp r4, #0
	bne _021F79FC
	ldr r1, [sp]
	ldr r0, [sp, #4]
	sub r1, r1, #4
	sub r0, #0x1b
	str r1, [sp]
	mov r1, #0x28
	str r0, [sp, #4]
	bl _u32_div_f
	add r6, r0, #0
	ldr r0, [sp]
	mov r1, #0x28
	bl _u32_div_f
	lsl r1, r0, #2
	add r0, r0, r1
	add r0, r6, r0
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	ldr r0, _021F7B60 ; =0x0000185A
	ldrb r1, [r5, r0]
	cmp r2, r1
	bne _021F79F2
	cmp r1, #0
	bne _021F79EC
	sub r0, r0, #1
	ldrb r0, [r5, r0]
	cmp r0, #0
	bne _021F79EC
	ldr r0, _021F7B64 ; =0x000008E9
	bl PlaySE
	add sp, #8
	mov r0, #2
	pop {r4, r5, r6, pc}
_021F79EC:
	add sp, #8
	mov r0, #4
	pop {r4, r5, r6, pc}
_021F79F2:
	strb r2, [r5, r0]
	ldr r0, _021F7B64 ; =0x000008E9
	bl PlaySE
	b _021F7A14
_021F79FC:
	cmp r4, #2
	bne _021F7A08
	ldr r0, _021F7B64 ; =0x000008E9
	bl PlaySE
	b _021F7A14
_021F7A08:
	cmp r4, #5
	bne _021F7A14
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
_021F7A14:
	add sp, #8
	add r0, r4, #0
	pop {r4, r5, r6, pc}
_021F7A1A:
	ldr r1, _021F7B68 ; =gSystem
	mov r0, #0x40
	ldr r2, [r1, #0x4c]
	tst r0, r2
	beq _021F7A42
	ldr r0, _021F7B60 ; =0x0000185A
	ldrb r1, [r5, r0]
	cmp r1, #5
	bhs _021F7A32
	add sp, #8
	mov r0, #0xa
	pop {r4, r5, r6, pc}
_021F7A32:
	sub r1, r1, #5
	strb r1, [r5, r0]
	ldr r0, _021F7B6C ; =0x000008E8
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_021F7A42:
	mov r0, #0x80
	tst r0, r2
	beq _021F7A6E
	ldr r0, _021F7B60 ; =0x0000185A
	ldrb r0, [r5, r0]
	cmp r0, #0xa
	blo _021F7A5A
	cmp r0, #0xf
	bhs _021F7A5A
	add sp, #8
	mov r0, #0xc
	pop {r4, r5, r6, pc}
_021F7A5A:
	ldr r0, _021F7B60 ; =0x0000185A
	ldrb r1, [r5, r0]
	add r1, r1, #5
	strb r1, [r5, r0]
	ldr r0, _021F7B6C ; =0x000008E8
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_021F7A6E:
	mov r0, #0x20
	add r3, r2, #0
	tst r3, r0
	beq _021F7AA6
	ldr r2, _021F7B60 ; =0x0000185A
	ldrb r1, [r5, r2]
	cmp r1, #0
	beq _021F7A8E
	sub r0, r1, #1
	strb r0, [r5, r2]
	ldr r0, _021F7B6C ; =0x000008E8
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_021F7A8E:
	sub r1, r2, #1
	ldrb r1, [r5, r1]
	cmp r1, #0
	beq _021F7AA0
	mov r0, #0xe
	strb r0, [r5, r2]
	add sp, #8
	mov r0, #9
	pop {r4, r5, r6, pc}
_021F7AA0:
	add sp, #8
	sub r0, #0x21
	pop {r4, r5, r6, pc}
_021F7AA6:
	mov r0, #0x10
	tst r0, r2
	beq _021F7AEA
	ldr r0, _021F7B60 ; =0x0000185A
	ldrb r1, [r5, r0]
	add r1, r1, #1
	cmp r1, #0xf
	beq _021F7AC4
	strb r1, [r5, r0]
	ldr r0, _021F7B6C ; =0x000008E8
	bl PlaySE
	add sp, #8
	mov r0, #0
	pop {r4, r5, r6, pc}
_021F7AC4:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F8950
	ldr r1, _021F7B70 ; =0x00001859
	ldrb r2, [r5, r1]
	add r2, r2, #1
	cmp r2, r0
	bhi _021F7AE2
	mov r2, #0
	add r0, r1, #1
	strb r2, [r5, r0]
	add sp, #8
	mov r0, #0xb
	pop {r4, r5, r6, pc}
_021F7AE2:
	mov r0, #0
	add sp, #8
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F7AEA:
	ldr r0, [r1, #0x48]
	mov r1, #1
	tst r1, r0
	beq _021F7AF8
	add sp, #8
	mov r0, #4
	pop {r4, r5, r6, pc}
_021F7AF8:
	mov r3, #2
	add r1, r0, #0
	tst r1, r3
	beq _021F7B0E
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add sp, #8
	mov r0, #6
	pop {r4, r5, r6, pc}
_021F7B0E:
	lsl r1, r3, #9
	tst r1, r0
	beq _021F7B1A
	add sp, #8
	mov r0, #3
	pop {r4, r5, r6, pc}
_021F7B1A:
	lsl r1, r3, #0xa
	tst r1, r0
	beq _021F7B2C
	ldr r0, _021F7B64 ; =0x000008E9
	bl PlaySE
	add sp, #8
	mov r0, #2
	pop {r4, r5, r6, pc}
_021F7B2C:
	lsl r1, r3, #8
	tst r1, r2
	beq _021F7B38
	add sp, #8
	mov r0, #9
	pop {r4, r5, r6, pc}
_021F7B38:
	add r3, #0xfe
	add r1, r2, #0
	tst r1, r3
	beq _021F7B46
	add sp, #8
	mov r0, #0xb
	pop {r4, r5, r6, pc}
_021F7B46:
	mov r1, #4
	tst r0, r1
	beq _021F7B52
	add sp, #8
	mov r0, #8
	pop {r4, r5, r6, pc}
_021F7B52:
	sub r0, r1, #5
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021F7B58: .word ov18_021FB8A4
_021F7B5C: .word ov18_021FB84C
_021F7B60: .word 0x0000185A
_021F7B64: .word 0x000008E9
_021F7B68: .word gSystem
_021F7B6C: .word 0x000008E8
_021F7B70: .word 0x00001859
	thumb_func_end ov18_021F7974

	thumb_func_start ov18_021F7B74
ov18_021F7B74: ; 0x021F7B74
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F7B8C ; =0x00001864
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021F7B8A
	bl GridInputHandler_Free
	ldr r0, _021F7B8C ; =0x00001864
	mov r1, #0
	str r1, [r4, r0]
_021F7B8A:
	pop {r4, pc}
	.balign 4, 0
_021F7B8C: .word 0x00001864
	thumb_func_end ov18_021F7B74

	thumb_func_start ov18_021F7B90
ov18_021F7B90: ; 0x021F7B90
	bx lr
	.balign 4, 0
	thumb_func_end ov18_021F7B90

	thumb_func_start ov18_021F7B94
ov18_021F7B94: ; 0x021F7B94
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	add r4, r1, #0
	bl System_GetTouchNew
	cmp r0, #1
	bne _021F7BE8
	ldr r0, _021F7C04 ; =ov18_021FB704
	bl TouchscreenHitbox_FindRectAtTouchNew
	add r6, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r6, r0
	beq _021F7BFE
	add r0, sp, #4
	add r1, sp, #0
	bl System_GetTouchNewCoords
	ldr r0, _021F7C08 ; =ov18_021FB698
	lsl r1, r6, #2
	ldr r6, [r0, r1]
	cmp r6, #1
	bne _021F7BDE
	ldr r1, _021F7C0C ; =0x000018A2
	ldr r0, [r5]
	ldrh r1, [r5, r1]
	ldr r0, [r0]
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	bne _021F7BDE
	mov r0, #0
	add sp, #8
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F7BDE:
	mov r0, #1
	str r0, [r4]
	add sp, #8
	add r0, r6, #0
	pop {r4, r5, r6, pc}
_021F7BE8:
	ldr r0, _021F7C10 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #2
	tst r1, r0
	beq _021F7BFC
	mov r0, #0
	str r0, [r4]
	add sp, #8
	mov r0, #3
	pop {r4, r5, r6, pc}
_021F7BFC:
	sub r0, r0, #3
_021F7BFE:
	add sp, #8
	pop {r4, r5, r6, pc}
	nop
_021F7C04: .word ov18_021FB704
_021F7C08: .word ov18_021FB698
_021F7C0C: .word 0x000018A2
_021F7C10: .word gSystem
	thumb_func_end ov18_021F7B94

	thumb_func_start ov18_021F7C14
ov18_021F7C14: ; 0x021F7C14
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r5, r1, #0
	bl ov18_021F7B94
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F7CE6
	bl System_GetTouchNew
	cmp r0, #1
	bne _021F7C4C
	ldr r0, _021F7CE8 ; =ov18_021FB934
	bl TouchscreenHitbox_FindHitboxAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F7C40
	add r0, r1, #0
	pop {r3, r4, r5, pc}
_021F7C40:
	mov r1, #1
	str r1, [r5]
	lsl r1, r0, #2
	ldr r0, _021F7CEC ; =ov18_021FB904
	ldr r0, [r0, r1]
	pop {r3, r4, r5, pc}
_021F7C4C:
	mov r0, #0
	str r0, [r5]
	ldr r2, _021F7CF0 ; =gSystem
	mov r0, #0x40
	ldr r1, [r2, #0x4c]
	tst r0, r1
	beq _021F7C5E
	mov r0, #5
	pop {r3, r4, r5, pc}
_021F7C5E:
	mov r0, #0x80
	tst r0, r1
	beq _021F7C68
	mov r0, #7
	pop {r3, r4, r5, pc}
_021F7C68:
	ldr r0, [r2, #0x48]
	mov r2, #1
	tst r2, r0
	beq _021F7C88
	ldr r0, _021F7CF4 ; =0x000018C9
	ldrsb r0, [r4, r0]
	cmp r0, #0
	bne _021F7C7C
	mov r0, #0xe
	pop {r3, r4, r5, pc}
_021F7C7C:
	cmp r0, #1
	bne _021F7C84
	mov r0, #0xf
	pop {r3, r4, r5, pc}
_021F7C84:
	mov r0, #0xd
	pop {r3, r4, r5, pc}
_021F7C88:
	mov r3, #4
	add r2, r0, #0
	tst r2, r3
	beq _021F7CA0
	ldr r0, _021F7CF8 ; =0x000018C8
	ldrsb r0, [r4, r0]
	cmp r0, #0
	bne _021F7C9C
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_021F7C9C:
	mov r0, #0xb
	pop {r3, r4, r5, pc}
_021F7CA0:
	ldr r2, _021F7CF8 ; =0x000018C8
	ldrsb r2, [r4, r2]
	cmp r2, #0
	bne _021F7CB2
	add r3, #0xfc
	tst r0, r3
	beq _021F7CBC
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_021F7CB2:
	lsl r2, r3, #7
	tst r0, r2
	beq _021F7CBC
	mov r0, #0xb
	pop {r3, r4, r5, pc}
_021F7CBC:
	mov r0, #0x20
	tst r0, r1
	beq _021F7CC6
	mov r0, #0x10
	pop {r3, r4, r5, pc}
_021F7CC6:
	mov r0, #0x10
	tst r1, r0
	beq _021F7CE4
	ldr r1, _021F7CFC ; =0x000018A2
	ldr r0, [r4]
	ldrh r1, [r4, r1]
	ldr r0, [r0]
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F7CE0
	mov r0, #1
	pop {r3, r4, r5, pc}
_021F7CE0:
	mov r0, #2
	pop {r3, r4, r5, pc}
_021F7CE4:
	sub r0, #0x11
_021F7CE6:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F7CE8: .word ov18_021FB934
_021F7CEC: .word ov18_021FB904
_021F7CF0: .word gSystem
_021F7CF4: .word 0x000018C9
_021F7CF8: .word 0x000018C8
_021F7CFC: .word 0x000018A2
	thumb_func_end ov18_021F7C14

	thumb_func_start ov18_021F7D00
ov18_021F7D00: ; 0x021F7D00
	push {r4, lr}
	add r4, r1, #0
	bl ov18_021F7B94
	mov r3, #0
	mvn r3, r3
	cmp r0, r3
	bne _021F7D28
	mov r0, #0
	ldr r1, _021F7D2C ; =gSystem
	str r0, [r4]
	ldr r2, [r1, #0x4c]
	mov r1, #0x20
	tst r1, r2
	bne _021F7D28
	mov r0, #0x10
	tst r0, r2
	beq _021F7D26
	mov r3, #2
_021F7D26:
	add r0, r3, #0
_021F7D28:
	pop {r4, pc}
	nop
_021F7D2C: .word gSystem
	thumb_func_end ov18_021F7D00

	thumb_func_start ov18_021F7D30
ov18_021F7D30: ; 0x021F7D30
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r5, r1, #0
	bl ov18_021F7B94
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F7DBA
	bl System_GetTouchNew
	cmp r0, #1
	bne _021F7D68
	ldr r0, _021F7DBC ; =ov18_021FB804
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F7D5C
	add r0, r1, #0
	pop {r3, r4, r5, pc}
_021F7D5C:
	mov r1, #1
	str r1, [r5]
	lsl r1, r0, #2
	ldr r0, _021F7DC0 ; =ov18_021FB760
	ldr r0, [r0, r1]
	pop {r3, r4, r5, pc}
_021F7D68:
	ldr r2, _021F7DC4 ; =gSystem
	mov r0, #0
	str r0, [r5]
	ldr r0, [r2, #0x4c]
	mov r1, #0x40
	tst r1, r0
	beq _021F7D7A
	mov r0, #5
	pop {r3, r4, r5, pc}
_021F7D7A:
	mov r1, #0x80
	tst r1, r0
	beq _021F7D84
	mov r0, #7
	pop {r3, r4, r5, pc}
_021F7D84:
	mov r1, #0x20
	tst r1, r0
	beq _021F7DA2
	ldr r1, _021F7DC8 ; =0x000018A2
	ldr r0, [r4]
	ldrh r1, [r4, r1]
	ldr r0, [r0]
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F7D9E
	mov r0, #1
	pop {r3, r4, r5, pc}
_021F7D9E:
	mov r0, #0
	pop {r3, r4, r5, pc}
_021F7DA2:
	mov r1, #0x10
	tst r0, r1
	beq _021F7DAC
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_021F7DAC:
	ldr r1, [r2, #0x48]
	mov r0, #1
	tst r1, r0
	beq _021F7DB8
	mov r0, #0xb
	pop {r3, r4, r5, pc}
_021F7DB8:
	sub r0, r0, #2
_021F7DBA:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F7DBC: .word ov18_021FB804
_021F7DC0: .word ov18_021FB760
_021F7DC4: .word gSystem
_021F7DC8: .word 0x000018A2
	thumb_func_end ov18_021F7D30

	thumb_func_start ov18_021F7DCC
ov18_021F7DCC: ; 0x021F7DCC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl System_GetTouchNew
	cmp r0, #1
	bne _021F7DF8
	ldr r0, _021F7E60 ; =ov18_021FB7E0
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F7DEC
	add r0, r1, #0
	pop {r3, r4, r5, pc}
_021F7DEC:
	mov r1, #1
	str r1, [r4]
	lsl r1, r0, #2
	ldr r0, _021F7E64 ; =ov18_021FB7C0
	ldr r0, [r0, r1]
	pop {r3, r4, r5, pc}
_021F7DF8:
	mov r0, #0
	ldr r2, _021F7E68 ; =gSystem
	str r0, [r4]
	ldr r3, [r2, #0x4c]
	mov r1, #0x40
	tst r1, r3
	beq _021F7E14
	ldr r1, _021F7E6C ; =0x000018C7
	ldrb r1, [r5, r1]
	lsl r1, r1, #0x1b
	lsr r1, r1, #0x1b
	beq _021F7E5C
	mov r0, #2
	pop {r3, r4, r5, pc}
_021F7E14:
	mov r0, #0x80
	tst r0, r3
	beq _021F7E2C
	ldr r0, _021F7E6C ; =0x000018C7
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x1b
	bne _021F7E28
	mov r0, #1
	pop {r3, r4, r5, pc}
_021F7E28:
	mov r0, #3
	pop {r3, r4, r5, pc}
_021F7E2C:
	ldr r2, [r2, #0x48]
	mov r0, #0x20
	tst r0, r2
	beq _021F7E38
	mov r0, #6
	pop {r3, r4, r5, pc}
_021F7E38:
	mov r0, #0x10
	add r1, r2, #0
	tst r1, r0
	beq _021F7E44
	mov r0, #7
	pop {r3, r4, r5, pc}
_021F7E44:
	lsl r0, r0, #6
	tst r0, r2
	beq _021F7E4E
	mov r0, #4
	pop {r3, r4, r5, pc}
_021F7E4E:
	mov r0, #3
	add r1, r2, #0
	tst r1, r0
	beq _021F7E5A
	mov r0, #5
	pop {r3, r4, r5, pc}
_021F7E5A:
	sub r0, r0, #4
_021F7E5C:
	pop {r3, r4, r5, pc}
	nop
_021F7E60: .word ov18_021FB7E0
_021F7E64: .word ov18_021FB7C0
_021F7E68: .word gSystem
_021F7E6C: .word 0x000018C7
	thumb_func_end ov18_021F7DCC

	thumb_func_start ov18_021F7E70
ov18_021F7E70: ; 0x021F7E70
	push {r4, lr}
	add r4, r1, #0
	bl ov18_021F7B94
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F7EC8
	bl System_GetTouchNew
	cmp r0, #1
	bne _021F7EA2
	ldr r0, _021F7ECC ; =ov18_021FB630
	bl TouchscreenHitbox_FindHitboxAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _021F7E9A
	add r0, r1, #0
	pop {r4, pc}
_021F7E9A:
	mov r0, #1
	str r0, [r4]
	mov r0, #4
	pop {r4, pc}
_021F7EA2:
	mov r0, #0
	ldr r2, _021F7ED0 ; =gSystem
	str r0, [r4]
	ldr r3, [r2, #0x4c]
	mov r1, #0x20
	tst r1, r3
	beq _021F7EB4
	mov r0, #2
	pop {r4, pc}
_021F7EB4:
	mov r1, #0x10
	tst r1, r3
	bne _021F7EC8
	ldr r1, [r2, #0x48]
	mov r0, #1
	tst r1, r0
	beq _021F7EC6
	mov r0, #3
	pop {r4, pc}
_021F7EC6:
	sub r0, r0, #2
_021F7EC8:
	pop {r4, pc}
	nop
_021F7ECC: .word ov18_021FB630
_021F7ED0: .word gSystem
	thumb_func_end ov18_021F7E70

	thumb_func_start ov18_021F7ED4
ov18_021F7ED4: ; 0x021F7ED4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	str r2, [sp, #0x10]
	add r5, r0, #0
	ldr r2, _021F815C ; =0x00000878
	add r7, r1, #0
	add r1, r5, r2
	mov r0, #0
	sub r2, #0xc0
	str r3, [sp, #0x14]
	bl MIi_CpuClear32
	ldr r1, _021F8160 ; =0x000003DA
	mov r0, #0x25
	bl Heap_AllocAtEnd
	add r6, r0, #0
	bne _021F7EFC
	bl GF_AssertFail
_021F7EFC:
	ldr r2, _021F8160 ; =0x000003DA
	add r0, r6, #0
	mov r1, #0
	bl memset
	mov r0, #0
	str r0, [sp, #0x1c]
	ldr r1, _021F8160 ; =0x000003DA
	mov r0, #0x25
	bl Heap_AllocAtEnd
	add r4, r0, #0
	bne _021F7F1A
	bl GF_AssertFail
_021F7F1A:
	ldr r2, _021F8160 ; =0x000003DA
	add r0, r4, #0
	mov r1, #0
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	cmp r7, #0
	add r1, sp, #0x20
	bne _021F7F36
	mov r0, #1
	bl ov18_021F8168
	b _021F7F3A
_021F7F36:
	bl ov18_021F8168
_021F7F3A:
	add r7, r0, #0
	ldr r0, [sp, #0x20]
	add r1, sp, #0x1c
	str r0, [sp]
	ldr r2, [r5]
	add r0, r6, #0
	ldr r2, [r2]
	add r3, r7, #0
	bl ov18_021F8198
	ldr r0, [sp, #0x1c]
	add r1, r4, #0
	str r0, [sp]
	ldr r0, [r5]
	add r2, sp, #0x18
	ldr r0, [r0]
	add r3, r6, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x10]
	bl ov18_021F822C
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r2, [sp, #0x18]
	add r0, r4, #0
	str r2, [sp, #0x1c]
	mov r1, #0
	lsl r2, r2, #1
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x1c]
	add r1, r4, #0
	str r0, [sp]
	ldr r0, [r5]
	add r2, sp, #0x18
	ldr r0, [r0]
	add r3, r6, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x14]
	bl ov18_021F82CC
	ldr r2, [sp, #0x18]
	cmp r2, #0
	beq _021F8090
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r2, [sp, #0x18]
	add r0, r4, #0
	str r2, [sp, #0x1c]
	mov r1, #0
	lsl r2, r2, #1
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x1c]
	add r1, r4, #0
	str r0, [sp]
	ldr r0, [r5]
	add r2, sp, #0x18
	ldr r0, [r0]
	add r3, r6, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x38]
	bl ov18_021F831C
	ldr r2, [sp, #0x18]
	cmp r2, #0
	beq _021F8090
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r2, [sp, #0x18]
	add r0, r4, #0
	str r2, [sp, #0x1c]
	mov r1, #0
	lsl r2, r2, #1
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x1c]
	add r1, r4, #0
	str r0, [sp]
	ldr r0, [r5]
	add r2, sp, #0x18
	ldr r0, [r0]
	add r3, r6, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x3c]
	bl ov18_021F831C
	ldr r2, [sp, #0x18]
	cmp r2, #0
	beq _021F8090
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r2, [sp, #0x18]
	add r0, r4, #0
	str r2, [sp, #0x1c]
	mov r1, #0
	lsl r2, r2, #1
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x1c]
	add r1, r4, #0
	str r0, [sp]
	ldr r0, [r5]
	add r2, sp, #0x18
	ldr r0, [r0]
	add r3, r6, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x54]
	bl ov18_021F8468
	ldr r2, [sp, #0x18]
	cmp r2, #0
	beq _021F8142
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r2, [sp, #0x18]
	add r0, r4, #0
	str r2, [sp, #0x1c]
	mov r1, #0
	lsl r2, r2, #1
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	ldr r0, _021F8164 ; =0x00001860
	ldr r0, [r5, r0]
	cmp r0, #0
	bne _021F8092
	ldr r1, [sp, #0x50]
	mov r0, #4
	tst r0, r1
	beq _021F8092
	str r6, [sp]
	ldr r0, [sp, #0x1c]
	mov r1, #6
	str r0, [sp, #4]
	ldr r0, [r5]
	add r2, r4, #0
	ldr r0, [r0]
	add r3, sp, #0x18
	str r0, [sp, #8]
	add r0, r5, #0
	bl ov18_021F8584
	ldr r2, [sp, #0x18]
	cmp r2, #0
	bne _021F80B0
_021F8090:
	b _021F8142
_021F8092:
	str r6, [sp]
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x50]
	str r0, [sp, #4]
	ldr r0, [r5]
	add r2, r4, #0
	ldr r0, [r0]
	add r3, sp, #0x18
	str r0, [sp, #8]
	add r0, r5, #0
	bl ov18_021F8584
	ldr r2, [sp, #0x18]
	cmp r2, #0
	beq _021F8142
_021F80B0:
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r2, [sp, #0x18]
	add r0, r4, #0
	str r2, [sp, #0x1c]
	mov r1, #0
	lsl r2, r2, #1
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	add r0, sp, #0x18
	str r0, [sp]
	str r6, [sp, #4]
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x40]
	str r0, [sp, #8]
	ldr r0, [r5]
	ldr r2, [sp, #0x44]
	ldr r0, [r0]
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	str r0, [sp, #0xc]
	add r0, r5, #0
	lsr r1, r1, #0x10
	lsr r2, r2, #0x10
	add r3, r4, #0
	bl ov18_021F8640
	ldr r2, [sp, #0x18]
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r2, [sp, #0x18]
	add r0, r4, #0
	str r2, [sp, #0x1c]
	mov r1, #0
	lsl r2, r2, #1
	bl memset
	mov r0, #0
	str r0, [sp, #0x18]
	add r0, sp, #0x18
	str r0, [sp]
	str r6, [sp, #4]
	ldr r0, [sp, #0x1c]
	ldr r1, [sp, #0x48]
	str r0, [sp, #8]
	ldr r0, [r5]
	ldr r2, [sp, #0x4c]
	ldr r0, [r0]
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	str r0, [sp, #0xc]
	add r0, r5, #0
	lsr r1, r1, #0x10
	lsr r2, r2, #0x10
	add r3, r4, #0
	bl ov18_021F86D0
	ldr r1, [r5]
	ldr r0, _021F815C ; =0x00000878
	ldr r1, [r1]
	ldr r3, [sp, #0x18]
	add r0, r5, r0
	add r2, r4, #0
	bl ov18_021F81D8
_021F8142:
	add r0, r7, #0
	bl Heap_Free
	add r0, r4, #0
	bl Heap_Free
	add r0, r6, #0
	bl Heap_Free
	mov r0, #1
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	nop
_021F815C: .word 0x00000878
_021F8160: .word 0x000003DA
_021F8164: .word 0x00001860
	thumb_func_end ov18_021F7ED4

	thumb_func_start ov18_021F8168
ov18_021F8168: ; 0x021F8168
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r1, #0
	; u32 size;
	; void * ret;
	; GF_ASSERT(a < 82);
	cmp r5, #0x52
	blo _021F8178
	bl GF_AssertFail
_021F8178:
	; ret = GfGfxLoader_LoadFromNarc_GetSizeOut(GetPokedexDataNarcID(), a0 + 11, FALSE, HEAP_ID_POKEDEX_APP, FALSE, &size);
	bl GetPokedexDataNarcID
	mov r2, #0
	str r2, [sp]
	add r1, sp, #8
	add r5, #0xb
	str r1, [sp, #4]
	add r1, r5, #0
	mov r3, #0x25
	bl GfGfxLoader_LoadFromNarc_GetSizeOut
	; *a1 = size / 2;
	ldr r1, [sp, #8]
	lsr r1, r1, #1
	str r1, [r4]
	; return ret;
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov18_021F8168

	thumb_func_start ov18_021F8198
ov18_021F8198: ; 0x021F8198
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	ldr r7, [sp, #0x20]
	add r5, r1, #0
	mov r6, #0
	add r4, r3, #0
	str r0, [sp]
	str r2, [sp, #4]
	str r6, [r5]
	cmp r7, #0
	bls _021F81D2
_021F81AE:
	ldrh r1, [r4]
	ldr r0, [sp, #4]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _021F81CA
	ldr r1, [r5]
	ldrh r0, [r4]
	lsl r2, r1, #1
	ldr r1, [sp]
	strh r0, [r1, r2]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_021F81CA:
	add r6, r6, #1
	add r4, r4, #2
	cmp r6, r7
	blo _021F81AE
_021F81D2:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8198

	thumb_func_start ov18_021F81D8
ov18_021F81D8: ; 0x021F81D8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	str r1, [sp]
	add r5, r0, #0
	ldr r1, _021F8228 ; =0x000007B4
	add r0, r3, #0
	strh r0, [r5, r1]
	mov r7, #0
	add r0, r1, #2
	add r4, r2, #0
	strh r7, [r5, r0]
	str r3, [sp, #4]
	add r0, r3, #0
	beq _021F8224
	add r0, r1, #2
	add r6, r5, r0
_021F81F8:
	ldrh r0, [r4]
	strh r0, [r5]
	ldrh r1, [r4]
	ldr r0, [sp]
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F8214
	mov r0, #2
	strh r0, [r5, #2]
	ldrh r0, [r6]
	add r0, r0, #1
	strh r0, [r6]
	b _021F8218
_021F8214:
	mov r0, #1
	strh r0, [r5, #2]
_021F8218:
	ldr r0, [sp, #4]
	add r7, r7, #1
	add r4, r4, #2
	add r5, r5, #4
	cmp r7, r0
	blo _021F81F8
_021F8224:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F8228: .word 0x000007B4
	thumb_func_end ov18_021F81D8

	thumb_func_start ov18_021F822C
ov18_021F822C: ; 0x021F822C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r7, r1, #0
	add r5, r2, #0
	mov r4, #0
	str r3, [sp, #0x10]
	cmp r0, #5
	bhi _021F82A6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F8248: ; jump table
	.short ov18_021F8254 - ov18_021F8248 - 2 ; case 0
	.short ov18_021F8268 - ov18_021F8248 - 2 ; case 1
	.short ov18_021F8276 - ov18_021F8248 - 2 ; case 2
	.short ov18_021F8282 - ov18_021F8248 - 2 ; case 3
	.short ov18_021F828E - ov18_021F8248 - 2 ; case 4
	.short ov18_021F829A - ov18_021F8248 - 2 ; case 5
ov18_021F8254:
	ldr r2, [sp, #0x30]
	add r0, r7, #0
	add r1, r3, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x30]
	add sp, #0x18
	str r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
ov18_021F8268:
	mov r0, #2
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	mov r4, #1
	b _021F82AA
ov18_021F8276:
	mov r0, #3
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
ov18_021F8282:
	mov r0, #4
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
ov18_021F828E:
	mov r0, #5
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
ov18_021F829A:
	mov r0, #6
	add r1, sp, #0x14
	bl ov18_021F8168
	add r6, r0, #0
	b _021F82AA
_021F82A6:
	bl GF_AssertFail
_021F82AA:
	str r6, [sp]
	ldr r0, [sp, #0x14]
	ldr r2, [sp, #0x10]
	str r0, [sp, #4]
	ldr r0, [sp, #0x34]
	str r4, [sp, #8]
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x30]
	add r0, r7, #0
	add r1, r5, #0
	bl ov18_021F8764
	add r0, r6, #0
	bl Heap_Free
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F822C

	thumb_func_start ov18_021F82CC
ov18_021F82CC: ; 0x021F82CC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r1, #0
	add r5, r2, #0
	add r4, r3, #0
	cmp r0, #0x1a
	bne _021F82EE
	ldr r2, [sp, #0x28]
	add r0, r6, #0
	add r1, r4, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0x14
	str r0, [r5]
	pop {r4, r5, r6, r7, pc}
_021F82EE:
	add r0, r0, #7
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	ldr r0, [sp, #0x28]
	str r4, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [sp, #0x2c]
	add r1, r5, #0
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x10]
	add r0, r6, #0
	add r2, r7, #0
	bl ov18_021F8764
	add r0, r7, #0
	bl Heap_Free
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F82CC

	thumb_func_start ov18_021F831C
ov18_021F831C: ; 0x021F831C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r1, #0
	add r4, r2, #0
	add r6, r3, #0
	bl ov18_021F8970
	cmp r0, #0x11
	bls _021F8330
	b _021F843E
_021F8330:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F833C: ; jump table
	.short ov18_021F8372 - ov18_021F833C - 2 ; case 0
	.short ov18_021F837E - ov18_021F833C - 2 ; case 1
	.short ov18_021F838A - ov18_021F833C - 2 ; case 2
	.short ov18_021F8396 - ov18_021F833C - 2 ; case 3
	.short ov18_021F83A2 - ov18_021F833C - 2 ; case 4
	.short ov18_021F83AE - ov18_021F833C - 2 ; case 5
	.short ov18_021F83BA - ov18_021F833C - 2 ; case 6
	.short ov18_021F83C6 - ov18_021F833C - 2 ; case 7
	.short ov18_021F83D2 - ov18_021F833C - 2 ; case 8
	.short ov18_021F83DE - ov18_021F833C - 2 ; case 9
	.short ov18_021F83EA - ov18_021F833C - 2 ; case 10
	.short ov18_021F83F6 - ov18_021F833C - 2 ; case 11
	.short ov18_021F8402 - ov18_021F833C - 2 ; case 12
	.short ov18_021F840E - ov18_021F833C - 2 ; case 13
	.short ov18_021F841A - ov18_021F833C - 2 ; case 14
	.short ov18_021F8426 - ov18_021F833C - 2 ; case 15
	.short ov18_021F8432 - ov18_021F833C - 2 ; case 16
	.short ov18_021F8360 - ov18_021F833C - 2 ; case 17
ov18_021F8360:
	ldr r5, [sp, #0x28]
	add r0, r7, #0
	add r1, r6, #0
	lsl r2, r5, #1
	bl memcpy
	add sp, #0x14
	str r5, [r4]
	pop {r4, r5, r6, r7, pc}
ov18_021F8372:
	mov r0, #0x33
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F837E:
	mov r0, #0x34
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F838A:
	mov r0, #0x35
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F8396:
	mov r0, #0x36
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83A2:
	mov r0, #0x37
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83AE:
	mov r0, #0x38
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83BA:
	mov r0, #0x39
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83C6:
	mov r0, #0x3a
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83D2:
	mov r0, #0x3b
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83DE:
	mov r0, #0x3c
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83EA:
	mov r0, #0x3d
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F83F6:
	mov r0, #0x3e
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F8402:
	mov r0, #0x3f
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F840E:
	mov r0, #0x40
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F841A:
	mov r0, #0x41
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F8426:
	mov r0, #0x42
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
ov18_021F8432:
	mov r0, #0x43
	add r1, sp, #0x10
	bl ov18_021F8168
	add r5, r0, #0
	b _021F8442
_021F843E:
	bl GF_AssertFail
_021F8442:
	ldr r0, [sp, #0x28]
	str r6, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	ldr r0, [sp, #0x2c]
	add r1, r4, #0
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x10]
	add r0, r7, #0
	add r2, r5, #0
	bl ov18_021F8764
	add r0, r5, #0
	bl Heap_Free
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F831C

	thumb_func_start ov18_021F8468
ov18_021F8468: ; 0x021F8468
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r1, #0
	add r4, r2, #0
	add r5, r3, #0
	cmp r0, #0xe
	bhi _021F855C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F8482: ; jump table
	.short ov18_021F8544 - ov18_021F8482 - 2 ; case 0
	.short ov18_021F8514 - ov18_021F8482 - 2 ; case 1
	.short ov18_021F8520 - ov18_021F8482 - 2 ; case 2
	.short ov18_021F852C - ov18_021F8482 - 2 ; case 3
	.short ov18_021F84E4 - ov18_021F8482 - 2 ; case 4
	.short ov18_021F84D8 - ov18_021F8482 - 2 ; case 5
	.short ov18_021F8508 - ov18_021F8482 - 2 ; case 6
	.short ov18_021F84B4 - ov18_021F8482 - 2 ; case 7
	.short ov18_021F8550 - ov18_021F8482 - 2 ; case 8
	.short ov18_021F84FC - ov18_021F8482 - 2 ; case 9
	.short ov18_021F8538 - ov18_021F8482 - 2 ; case 10
	.short ov18_021F84CC - ov18_021F8482 - 2 ; case 11
	.short ov18_021F84F0 - ov18_021F8482 - 2 ; case 12
	.short ov18_021F84C0 - ov18_021F8482 - 2 ; case 13
	.short ov18_021F84A0 - ov18_021F8482 - 2 ; case 14
ov18_021F84A0:
	ldr r2, [sp, #0x28]
	add r0, r6, #0
	add r1, r5, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0x14
	str r0, [r4]
	pop {r4, r5, r6, r7, pc}
ov18_021F84B4:
	mov r0, #0x44
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84C0:
	mov r0, #0x45
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84CC:
	mov r0, #0x46
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84D8:
	mov r0, #0x47
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84E4:
	mov r0, #0x48
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84F0:
	mov r0, #0x49
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F84FC:
	mov r0, #0x4a
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8508:
	mov r0, #0x4b
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8514:
	mov r0, #0x4c
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8520:
	mov r0, #0x4d
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F852C:
	mov r0, #0x4e
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8538:
	mov r0, #0x4f
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8544:
	mov r0, #0x50
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
ov18_021F8550:
	mov r0, #0x51
	add r1, sp, #0x10
	bl ov18_021F8168
	add r7, r0, #0
	b _021F8560
_021F855C:
	bl GF_AssertFail
_021F8560:
	ldr r0, [sp, #0x28]
	str r5, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [sp, #0x2c]
	add r1, r4, #0
	str r0, [sp, #0xc]
	ldr r3, [sp, #0x10]
	add r0, r6, #0
	add r2, r7, #0
	bl ov18_021F8764
	add r0, r7, #0
	bl Heap_Free
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F8468

	thumb_func_start ov18_021F8584
ov18_021F8584: ; 0x021F8584
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r0, [sp]
	ldr r0, [sp, #0x30]
	add r7, r1, #0
	str r0, [sp, #0x30]
	mov r0, #8
	add r4, r3, #0
	str r2, [sp, #4]
	ldr r6, [sp, #0x2c]
	tst r0, r7
	beq _021F85AC
	ldr r1, [sp, #0x28]
	add r0, r2, #0
	lsl r2, r6, #1
	bl memcpy
	add sp, #0x10
	str r6, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_021F85AC:
	cmp r7, #6
	bne _021F85FA
	mov r0, #0
	str r0, [sp, #0xc]
	cmp r6, #0
	bls _021F8638
	ldr r5, [sp, #0x28]
_021F85BA:
	ldr r2, [sp]
	ldr r0, _021F863C ; =0x00001854
	ldrh r1, [r5]
	ldr r0, [r2, r0]
	add r2, r7, #0
	ldrb r0, [r0, r1]
	tst r2, r0
	beq _021F85EA
	mov r2, #1
	tst r0, r2
	bne _021F85EA
	ldr r0, [sp, #0x30]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _021F85EA
	ldr r1, [r4]
	ldrh r0, [r5]
	lsl r2, r1, #1
	ldr r1, [sp, #4]
	strh r0, [r1, r2]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_021F85EA:
	ldr r0, [sp, #0xc]
	add r5, r5, #2
	add r0, r0, #1
	str r0, [sp, #0xc]
	cmp r0, r6
	blo _021F85BA
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
_021F85FA:
	mov r0, #0
	str r0, [sp, #8]
	cmp r6, #0
	bls _021F8638
	ldr r5, [sp, #0x28]
_021F8604:
	ldr r2, [sp]
	ldr r0, _021F863C ; =0x00001854
	ldrh r1, [r5]
	ldr r0, [r2, r0]
	ldrb r0, [r0, r1]
	tst r0, r7
	beq _021F862C
	ldr r0, [sp, #0x30]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _021F862C
	ldr r1, [r4]
	ldrh r0, [r5]
	lsl r2, r1, #1
	ldr r1, [sp, #4]
	strh r0, [r1, r2]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_021F862C:
	ldr r0, [sp, #8]
	add r5, r5, #2
	add r0, r0, #1
	str r0, [sp, #8]
	cmp r0, r6
	blo _021F8604
_021F8638:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F863C: .word 0x00001854
	thumb_func_end ov18_021F8584

	thumb_func_start ov18_021F8640
ov18_021F8640: ; 0x021F8640
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r0, #0
	ldr r0, [sp, #0x28]
	str r3, [sp]
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	ldr r5, [sp, #0x20]
	str r0, [sp, #0x2c]
	cmp r1, #0
	bne _021F866E
	cmp r2, #0x98
	bne _021F866E
	ldr r2, [sp, #0x28]
	ldr r1, [sp, #0x24]
	add r0, r3, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0xc
	str r0, [r5]
	pop {r4, r5, r6, r7, pc}
_021F866E:
	ldr r0, [sp, #0x28]
	mov r7, #0
	cmp r0, #0
	bls _021F86C4
	lsl r0, r1, #2
	str r0, [sp, #8]
	lsl r0, r2, #2
	ldr r4, [sp, #0x24]
	str r0, [sp, #4]
_021F8680:
	ldr r0, _021F86C8 ; =0x00001848
	ldrh r2, [r4]
	ldr r1, [r6, r0]
	ldr r3, [sp, #8]
	lsl r0, r2, #2
	ldr r1, [r1, r0]
	ldr r0, _021F86CC ; =0x00001850
	ldr r0, [r6, r0]
	ldrh r3, [r3, r0]
	cmp r1, r3
	blt _021F86BA
	ldr r3, [sp, #4]
	ldrh r0, [r3, r0]
	cmp r1, r0
	bgt _021F86BA
	ldr r0, [sp, #0x2c]
	add r1, r2, #0
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F86BA
	ldr r1, [r5]
	ldrh r0, [r4]
	lsl r2, r1, #1
	ldr r1, [sp]
	strh r0, [r1, r2]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_021F86BA:
	ldr r0, [sp, #0x28]
	add r7, r7, #1
	add r4, r4, #2
	cmp r7, r0
	blo _021F8680
_021F86C4:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F86C8: .word 0x00001848
_021F86CC: .word 0x00001850
	thumb_func_end ov18_021F8640

	thumb_func_start ov18_021F86D0
ov18_021F86D0: ; 0x021F86D0
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r0, #0
	ldr r0, [sp, #0x28]
	str r3, [sp]
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	ldr r5, [sp, #0x20]
	str r0, [sp, #0x2c]
	cmp r1, #0
	bne _021F86FE
	cmp r2, #0x98
	bne _021F86FE
	ldr r2, [sp, #0x28]
	ldr r1, [sp, #0x24]
	add r0, r3, #0
	lsl r2, r2, #1
	bl memcpy
	ldr r0, [sp, #0x28]
	add sp, #0xc
	str r0, [r5]
	pop {r4, r5, r6, r7, pc}
_021F86FE:
	ldr r0, [sp, #0x28]
	mov r7, #0
	cmp r0, #0
	bls _021F8758
	lsl r0, r1, #2
	str r0, [sp, #8]
	lsl r0, r2, #2
	ldr r4, [sp, #0x24]
	str r0, [sp, #4]
_021F8710:
	ldr r0, _021F875C ; =0x0000184C
	ldrh r2, [r4]
	ldr r1, [r6, r0]
	ldr r3, [sp, #8]
	lsl r0, r2, #2
	ldr r1, [r1, r0]
	ldr r0, _021F8760 ; =0x00001850
	ldr r0, [r6, r0]
	add r3, r3, r0
	ldrh r3, [r3, #2]
	cmp r1, r3
	blt _021F874E
	ldr r3, [sp, #4]
	add r0, r3, r0
	ldrh r0, [r0, #2]
	cmp r1, r0
	bgt _021F874E
	ldr r0, [sp, #0x2c]
	add r1, r2, #0
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F874E
	ldr r1, [r5]
	ldrh r0, [r4]
	lsl r2, r1, #1
	ldr r1, [sp]
	strh r0, [r1, r2]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_021F874E:
	ldr r0, [sp, #0x28]
	add r7, r7, #1
	add r4, r4, #2
	cmp r7, r0
	blo _021F8710
_021F8758:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F875C: .word 0x0000184C
_021F8760: .word 0x00001850
	thumb_func_end ov18_021F86D0

	thumb_func_start ov18_021F8764
ov18_021F8764: ; 0x021F8764
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	str r1, [sp, #4]
	str r0, [sp, #0x2c]
	ldr r0, [sp, #0x34]
	mov r1, #0
	str r0, [sp, #0x34]
	ldr r0, [sp, #4]
	str r2, [sp, #8]
	str r1, [r0]
	ldr r0, [sp, #0x30]
	add r5, r3, #0
	str r1, [sp, #0xc]
	cmp r0, #1
	bne _021F87D0
	ldr r0, [sp, #0x2c]
	cmp r0, #0
	bls _021F8820
	ldr r1, [sp, #0x28]
	mov r0, #0
_021F8790:
	add r4, r0, #0
	cmp r5, #0
	bls _021F87BE
	ldrh r2, [r1]
	ldr r6, [sp, #8]
_021F879A:
	ldrh r3, [r6]
	cmp r2, r3
	bne _021F87B6
	ldr r3, [sp, #4]
	ldr r3, [r3]
	lsl r4, r3, #1
	ldr r3, [sp]
	strh r2, [r3, r4]
	ldr r2, [sp, #4]
	ldr r2, [r2]
	add r3, r2, #1
	ldr r2, [sp, #4]
	str r3, [r2]
	b _021F87BE
_021F87B6:
	add r4, r4, #1
	add r6, r6, #2
	cmp r4, r5
	blo _021F879A
_021F87BE:
	ldr r2, [sp, #0xc]
	add r1, r1, #2
	add r3, r2, #1
	ldr r2, [sp, #0x2c]
	str r3, [sp, #0xc]
	cmp r3, r2
	blo _021F8790
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
_021F87D0:
	ldr r0, [sp, #0x2c]
	cmp r0, #0
	bls _021F8820
	ldr r7, [sp, #0x28]
_021F87D8:
	mov r6, #0
	cmp r5, #0
	bls _021F8812
	ldr r4, [sp, #8]
_021F87E0:
	ldrh r1, [r7]
	ldrh r0, [r4]
	cmp r1, r0
	bne _021F880A
	ldr r0, [sp, #0x34]
	bl Pokedex_CheckMonCaughtFlag
	cmp r0, #0
	beq _021F880A
	ldr r0, [sp, #4]
	ldrh r2, [r7]
	ldr r0, [r0]
	lsl r1, r0, #1
	ldr r0, [sp]
	strh r2, [r0, r1]
	ldr r0, [sp, #4]
	ldr r0, [r0]
	add r1, r0, #1
	ldr r0, [sp, #4]
	str r1, [r0]
	b _021F8812
_021F880A:
	add r6, r6, #1
	add r4, r4, #2
	cmp r6, r5
	blo _021F87E0
_021F8812:
	ldr r0, [sp, #0xc]
	add r7, r7, #2
	add r1, r0, #1
	ldr r0, [sp, #0x2c]
	str r1, [sp, #0xc]
	cmp r1, r0
	blo _021F87D8
_021F8820:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F8764

	thumb_func_start ov18_021F8824
ov18_021F8824: ; 0x021F8824
	ldr r1, _021F8834 ; =0x0000185A
	ldrb r2, [r0, r1]
	sub r1, r1, #1
	ldrb r1, [r0, r1]
	mov r0, #0xf
	mul r0, r1
	add r0, r2, r0
	bx lr
	.balign 4, 0
_021F8834: .word 0x0000185A
	thumb_func_end ov18_021F8824

	thumb_func_start ov18_021F8838
ov18_021F8838: ; 0x021F8838
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F8824
	lsl r0, r0, #2
	add r1, r4, r0
	ldr r0, _021F884C ; =0x00001030
	ldrh r0, [r1, r0]
	pop {r4, pc}
	nop
_021F884C: .word 0x00001030
	thumb_func_end ov18_021F8838

	thumb_func_start ov18_021F8850
ov18_021F8850: ; 0x021F8850
	push {r4, r5}
	ldr r2, _021F8880 ; =0x000007B4
	mov r4, #0
	ldrh r5, [r0, r2]
	add r3, r4, #0
	cmp r5, #0
	bls _021F8878
_021F885E:
	cmp r4, #0
	bne _021F8864
	ldrh r4, [r0]
_021F8864:
	ldrh r2, [r0]
	cmp r1, r2
	bne _021F8870
	add r0, r1, #0
	pop {r4, r5}
	bx lr
_021F8870:
	add r3, r3, #1
	add r0, r0, #4
	cmp r3, r5
	blo _021F885E
_021F8878:
	add r0, r4, #0
	pop {r4, r5}
	bx lr
	nop
_021F8880: .word 0x000007B4
	thumb_func_end ov18_021F8850

	thumb_func_start ov18_021F8884
ov18_021F8884: ; 0x021F8884
	push {r3, r4, r5, r6, r7, lr}
	ldr r2, _021F8900 ; =0x00001030
	add r5, r0, #0
	add r4, r1, #0
	add r1, r5, r2
	mov r0, #0
	lsr r2, r2, #1
	bl MIi_CpuClear32
	cmp r4, #1
	ldr r0, _021F8904 ; =0x0000102C
	bne _021F88D6
	ldrh r0, [r5, r0]
	mov r6, #0
	cmp r0, #0
	bls _021F88FE
	ldr r7, _021F8904 ; =0x0000102C
	add r4, r5, #0
_021F88A8:
	ldr r0, _021F8908 ; =0x00001858
	ldr r1, _021F890C ; =0x00000878
	ldrb r0, [r5, r0]
	ldrh r1, [r4, r1]
	bl Pokedex_ConvertToCurrentDexNo
	ldr r1, _021F890C ; =0x00000878
	sub r0, r0, #1
	ldrh r2, [r4, r1]
	lsl r0, r0, #2
	ldr r1, _021F8900 ; =0x00001030
	add r0, r5, r0
	strh r2, [r0, r1]
	ldr r1, _021F8910 ; =0x0000087A
	add r6, r6, #1
	ldrh r2, [r4, r1]
	ldr r1, _021F8914 ; =0x00001032
	add r4, r4, #4
	strh r2, [r0, r1]
	ldrh r0, [r5, r7]
	cmp r6, r0
	blo _021F88A8
	pop {r3, r4, r5, r6, r7, pc}
_021F88D6:
	ldrh r0, [r5, r0]
	mov r1, #0
	cmp r0, #0
	bls _021F88FE
	ldr r3, _021F8918 ; =0x00001034
	ldr r4, _021F8910 ; =0x0000087A
	add r7, r3, #0
	add r0, r5, #0
	add r6, r3, #2
	sub r7, #8
_021F88EA:
	ldr r2, _021F890C ; =0x00000878
	add r1, r1, #1
	ldrh r2, [r0, r2]
	strh r2, [r0, r3]
	ldrh r2, [r0, r4]
	strh r2, [r0, r6]
	ldrh r2, [r5, r7]
	add r0, r0, #4
	cmp r1, r2
	blo _021F88EA
_021F88FE:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F8900: .word 0x00001030
_021F8904: .word 0x0000102C
_021F8908: .word 0x00001858
_021F890C: .word 0x00000878
_021F8910: .word 0x0000087A
_021F8914: .word 0x00001032
_021F8918: .word 0x00001034
	thumb_func_end ov18_021F8884

	thumb_func_start ov18_021F891C
ov18_021F891C: ; 0x021F891C
	push {r3, lr}
	add r2, r0, #0
	cmp r1, #0
	bne _021F892A
	ldr r0, _021F8944 ; =0x0000102C
	ldrh r0, [r2, r0]
	pop {r3, pc}
_021F892A:
	ldr r1, _021F8944 ; =0x0000102C
	ldr r0, _021F8948 ; =0x00001858
	ldrh r1, [r2, r1]
	ldrb r0, [r2, r0]
	sub r1, r1, #1
	lsl r1, r1, #2
	add r2, r2, r1
	ldr r1, _021F894C ; =0x00000878
	ldrh r1, [r2, r1]
	bl Pokedex_ConvertToCurrentDexNo
	pop {r3, pc}
	nop
_021F8944: .word 0x0000102C
_021F8948: .word 0x00001858
_021F894C: .word 0x00000878
	thumb_func_end ov18_021F891C

	thumb_func_start ov18_021F8950
ov18_021F8950: ; 0x021F8950
	push {r3, lr}
	cmp r1, #0
	bne _021F8962
	bl ov18_021F891C
	mov r1, #0xf
	bl _u32_div_f
	pop {r3, pc}
_021F8962:
	bl ov18_021F891C
	sub r0, r0, #1
	mov r1, #0xf
	bl _u32_div_f
	pop {r3, pc}
	thumb_func_end ov18_021F8950

	thumb_func_start ov18_021F8970
ov18_021F8970: ; 0x021F8970
	bx lr
	.balign 4, 0
	thumb_func_end ov18_021F8970

	thumb_func_start ov18_021F8974
ov18_021F8974: ; 0x021F8974
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r1, #0x96
	ldr r0, [r5, #0x14]
	lsl r1, r1, #2
	bl Heap_Alloc
	mov r2, #0x96
	mov r1, #0
	lsl r2, r2, #2
	add r4, r0, #0
	bl memset
	add r2, r4, #0
	mov r1, #0x18
_021F8992:
	ldrb r0, [r5]
	add r5, r5, #1
	strb r0, [r2]
	add r2, r2, #1
	sub r1, r1, #1
	bne _021F8992
	ldr r1, [r4, #0x14]
	mov r0, #0x44
	bl NARC_New
	str r0, [r4, #0x1c]
	mov r0, #9
	mov r2, #0
	lsl r0, r0, #6
	strh r2, [r4, r0]
	add r0, #0x14
	str r2, [r4, r0]
	ldr r0, _021F89C4 ; =ov18_021F89F8
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	str r0, [r4, #0x18]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	nop
_021F89C4: .word ov18_021F89F8
	thumb_func_end ov18_021F8974

	thumb_func_start ov18_021F89C8
ov18_021F89C8: ; 0x021F89C8
	mov r1, #0x95
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bx lr
	thumb_func_end ov18_021F89C8

	thumb_func_start ov18_021F89D0
ov18_021F89D0: ; 0x021F89D0
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F91F0
	add r0, r4, #0
	bl ov18_021F8F10
	add r0, r4, #0
	bl ov18_021F8BEC
	ldr r0, [r4, #0x1c]
	bl NARC_Delete
	ldr r0, [r4, #0x18]
	bl SysTask_Destroy
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov18_021F89D0

	thumb_func_start ov18_021F89F8
ov18_021F89F8: ; 0x021F89F8
	push {r4, lr}
	sub sp, #8
	add r4, r1, #0
	mov r1, #9
	lsl r1, r1, #6
	ldrh r0, [r4, r1]
	cmp r0, #4
	bhi _021F8AA0
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F8A14: ; jump table
	.short ov18_021F8A1E - ov18_021F8A14 - 2 ; case 0
	.short ov18_021F8A52 - ov18_021F8A14 - 2 ; case 1
	.short ov18_021F8A66 - ov18_021F8A14 - 2 ; case 2
	.short ov18_021F8A8A - ov18_021F8A14 - 2 ; case 3
	.short _021F8AA0 - ov18_021F8A14 - 2 ; case 4
ov18_021F8A1E:
	ldr r0, _021F8AB4 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	add r0, r4, #0
	bl ov18_021F8AB8
	add r0, r4, #0
	bl ov18_021F8B10
	add r0, r4, #0
	bl ov18_021F8CCC
	add r0, r4, #0
	bl ov18_021F8FA0
	add r0, r4, #0
	bl ov18_021F95CC
	add r0, r4, #0
	bl ov18_021F8C0C
	mov r0, #9
	mov r1, #1
	lsl r0, r0, #6
	strh r1, [r4, r0]
	b _021F8AA0
ov18_021F8A52:
	add r0, r4, #0
	bl ov18_021F8C48
	cmp r0, #1
	bne _021F8AA0
	mov r0, #9
	mov r1, #2
	lsl r0, r0, #6
	strh r1, [r4, r0]
	b _021F8AA0
ov18_021F8A66:
	add r2, r1, #0
	sub r2, #0x41
	str r2, [sp]
	mov r0, #0
	str r0, [sp, #4]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r0, #0xe
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	add r3, r2, #0
	bl PlayCryEx
	mov r0, #9
	mov r1, #3
	lsl r0, r0, #6
	strh r1, [r4, r0]
	b _021F8AA0
ov18_021F8A8A:
	bl IsCryFinished
	cmp r0, #0
	bne _021F8AA0
	mov r0, #0x95
	mov r1, #1
	lsl r0, r0, #2
	str r1, [r4, r0]
	mov r1, #4
	sub r0, #0x14
	strh r1, [r4, r0]
_021F8AA0:
	add r0, r4, #0
	add r0, #0xb4
	ldr r0, [r0]
	bl SpriteList_RenderAndAnimateSprites
	add r0, r4, #0
	bl ov18_021F8C68
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
_021F8AB4: .word 0x04000050
	thumb_func_end ov18_021F89F8

	thumb_func_start ov18_021F8AB8
ov18_021F8AB8: ; 0x021F8AB8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	bl AcquireMonLock
	add r4, r0, #0
	ldr r0, [r5, #0xc]
	mov r1, #5
	mov r2, #0
	bl GetMonData
	mov r1, #0x91
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	mov r1, #0x92
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	mov r1, #0xb1
	mov r2, #0
	bl GetMonData
	mov r1, #0x93
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	mov r1, #0xb2
	mov r2, #0
	bl GetMonData
	mov r1, #0x25
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	add r1, r4, #0
	bl ReleaseMonLock
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8AB8

	thumb_func_start ov18_021F8B10
ov18_021F8B10: ; 0x021F8B10
	push {r4, r5, lr}
	sub sp, #0x64
	add r4, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl SetBgPriority
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	ldr r5, _021F8BE0 ; =ov18_021FBD7C
	add r3, sp, #0x48
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #1
	str r0, [r3]
	ldr r0, [r4]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r3, [r4, #0x14]
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	bl BG_ClearCharDataRange
	ldr r5, _021F8BE4 ; =ov18_021FBD60
	add r3, sp, #0x2c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #2
	str r0, [r3]
	ldr r0, [r4]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r5, _021F8BE8 ; =ov18_021FBD98
	add r3, sp, #0x10
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #3
	str r0, [r3]
	ldr r0, [r4]
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r4, #0x14]
	mov r1, #0x13
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x1c]
	ldr r2, [r4]
	mov r3, #2
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r4, #0x14]
	mov r1, #0x14
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x1c]
	ldr r2, [r4]
	mov r3, #2
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	ldr r1, [r4, #0x1c]
	ldr r3, [r4, #0x14]
	mov r2, #0x12
	bl PaletteData_LoadOpenNarc
	add sp, #0x64
	pop {r4, r5, pc}
	nop
_021F8BE0: .word ov18_021FBD7C
_021F8BE4: .word ov18_021FBD60
_021F8BE8: .word ov18_021FBD98
	thumb_func_end ov18_021F8B10

	thumb_func_start ov18_021F8BEC
ov18_021F8BEC: ; 0x021F8BEC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #3
	bl FreeBgTilemapBuffer
	ldr r0, [r4]
	mov r1, #2
	bl FreeBgTilemapBuffer
	ldr r0, [r4]
	mov r1, #1
	bl FreeBgTilemapBuffer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8BEC

	thumb_func_start ov18_021F8C0C
ov18_021F8C0C: ; 0x021F8C0C
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	ldr r2, _021F8C44 ; =0x0000FFFF
	mov r1, #5
	mov r3, #1
	bl PaletteData_BeginPaletteFade
	mov r2, #0
	str r2, [sp]
	ldr r0, [r4, #0x20]
	mov r1, #0x10
	add r3, r2, #0
	bl Pokepic_StartPaletteFade
	ldr r0, [r4, #4]
	mov r1, #0
	bl PaletteData_SetAutoTransparent
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_021F8C44: .word 0x0000FFFF
	thumb_func_end ov18_021F8C0C

	thumb_func_start ov18_021F8C48
ov18_021F8C48: ; 0x021F8C48
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #4]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	bne _021F8C64
	ldr r0, [r4, #0x20]
	bl Pokepic_ResumePaletteFade
	cmp r0, #0
	bne _021F8C64
	mov r0, #1
	pop {r4, pc}
_021F8C64:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov18_021F8C48

	thumb_func_start ov18_021F8C68
ov18_021F8C68: ; 0x021F8C68
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, _021F8CC8 ; =0x00000242
	ldrh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	ldrh r0, [r4, r0]
	cmp r0, #0x10
	bne _021F8C9E
	mov r0, #0x20
	str r0, [sp]
	mov r1, #2
	mov r2, #0
	str r1, [sp, #4]
	mov r0, #7
	str r0, [sp, #8]
	ldr r0, [r4]
	add r3, r2, #0
	bl BgTilemapRectChangePalette
	ldr r0, [r4]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0xc
	pop {r3, r4, pc}
_021F8C9E:
	cmp r0, #0x20
	bne _021F8CC4
	mov r0, #0x20
	str r0, [sp]
	mov r1, #2
	mov r2, #0
	str r1, [sp, #4]
	str r2, [sp, #8]
	ldr r0, [r4]
	add r3, r2, #0
	bl BgTilemapRectChangePalette
	ldr r0, [r4]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, _021F8CC8 ; =0x00000242
	mov r1, #0
	strh r1, [r4, r0]
_021F8CC4:
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F8CC8: .word 0x00000242
	thumb_func_end ov18_021F8C68
