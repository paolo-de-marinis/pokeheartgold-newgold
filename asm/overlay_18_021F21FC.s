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
.public ov18_021F1E70
.public ov18_021F1F74
.public ov18_021F1FDC
.public ov18_021F209C
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

.public ov18_021F2EC8
.public ov18_021F8824
.public ov18_021F8838
.public ov18_021F891C
.public ov18_021F8950

	.text

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
