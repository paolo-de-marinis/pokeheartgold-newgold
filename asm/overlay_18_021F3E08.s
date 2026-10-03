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
