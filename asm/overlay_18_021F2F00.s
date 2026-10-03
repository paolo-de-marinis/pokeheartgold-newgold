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
.public ov18_021F17FC
.public ov18_021F18E0
.public ov18_021F193C
.public ov18_021F19EC
.public ov18_021F1A30
.public ov18_021F1A7C
.public ov18_021F1CB4
.public ov18_021F1D58
.public ov18_021F1D98
.public ov18_021F1E70
.public ov18_021F1F74
.public ov18_021F1FDC
.public ov18_021F2270
.public ov18_021F2308
.public ov18_021F2348
.public ov18_021F23E4
.public ov18_021F2424
.public ov18_021F2648
.public ov18_021F26E4
.public ov18_021F2724
.public ov18_021F281C
.public ov18_021F2AC0
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

.public ov18_021F8950

	.text

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
