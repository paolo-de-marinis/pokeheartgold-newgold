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

	thumb_func_start ov18_021F1620
ov18_021F1620: ; 0x021F1620
	push {r3, r4, r5, r6, r7, lr}
	mov r6, #0x67
	add r5, r0, #0
	add r7, r1, #0
	mov r4, #0
	lsl r6, r6, #4
_021F162C:
	ldr r1, _021F16BC ; =0x0000185E
	add r0, r7, r4
	ldrb r2, [r5, r1]
	mov r1, #1
	eor r2, r1
	mov r1, #0x1e
	mul r1, r2
	add r0, r0, r1
	lsl r0, r0, #0x10
	lsr r0, r0, #0xe
	add r0, r5, r0
	ldr r0, [r0, r6]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x1e
	blo _021F162C
	mov r4, #0
_021F1656:
	ldr r1, _021F16BC ; =0x0000185E
	add r0, r7, r4
	ldrb r2, [r5, r1]
	mov r1, #0x1e
	mul r1, r2
	add r0, r0, r1
	ldr r1, _021F16C0 ; =0x00001859
	lsl r0, r0, #0x10
	ldrb r2, [r5, r1]
	mov r1, #0xf
	lsr r6, r0, #0x10
	mul r1, r2
	add r0, r5, #0
	add r1, r4, r1
	add r2, r6, #0
	bl ov18_021F1598
	add r0, r4, #0
	mov r1, #5
	bl _s32_div_f
	str r1, [sp]
	add r0, r4, #0
	mov r1, #5
	bl _s32_div_f
	add r2, r0, #0
	lsl r0, r6, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r3, [sp]
	mov r1, #0x28
	mul r1, r3
	mov r3, #0x28
	mul r3, r2
	add r1, #0x30
	add r3, #0x18
	lsl r1, r1, #0x10
	lsl r2, r3, #0x10
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #0x1e
	blo _021F1656
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F16BC: .word 0x0000185E
_021F16C0: .word 0x00001859
	thumb_func_end ov18_021F1620

	thumb_func_start ov18_021F16C4
ov18_021F16C4: ; 0x021F16C4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	str r1, [sp]
	add r1, r3, #1
	add r5, r0, #0
	lsl r0, r1, #2
	mov r6, #0
	add r0, r1, r0
	str r2, [sp, #4]
	add r7, r6, #0
	str r0, [sp, #0xc]
	add r4, sp, #0x14
_021F16DC:
	ldr r1, _021F1758 ; =0x0000185E
	ldr r0, [sp]
	ldrb r2, [r5, r1]
	mov r1, #0x1e
	add r0, r0, r7
	mul r1, r2
	add r0, r0, r1
	str r0, [sp, #0x10]
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	str r1, [sp, #8]
	ldr r0, [r1, r0]
	add r1, sp, #0x14
	add r1, #2
	add r2, sp, #0x14
	bl ManagedSprite_GetPositionXY
	mov r0, #0
	ldrsh r0, [r4, r0]
	cmp r0, #0xe0
	bne _021F172C
	mov r0, #0xf
	mvn r0, r0
	strh r0, [r4]
	ldr r1, _021F175C ; =0x00001859
	mov r2, #0xf
	ldrb r1, [r5, r1]
	add r0, r5, #0
	mul r2, r1
	ldr r1, [sp, #0xc]
	sub r1, r2, r1
	ldr r2, [sp, #0x10]
	add r1, r6, r1
	bl ov18_021F1598
	add r0, r6, #1
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
_021F172C:
	mov r0, #0
	ldrsh r1, [r4, r0]
	ldr r0, [sp, #4]
	mov r2, #0
	add r0, r1, r0
	strh r0, [r4]
	mov r0, #0x67
	ldr r1, [sp, #8]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	ldrsh r1, [r4, r1]
	ldrsh r2, [r4, r2]
	bl ManagedSprite_SetPositionXY
	add r0, r7, #1
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	cmp r7, #0x1e
	blo _021F16DC
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F1758: .word 0x0000185E
_021F175C: .word 0x00001859
	thumb_func_end ov18_021F16C4

	thumb_func_start ov18_021F1760
ov18_021F1760: ; 0x021F1760
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	str r1, [sp]
	add r1, r3, #5
	add r5, r0, #0
	lsl r0, r1, #2
	mov r6, #0
	add r0, r1, r0
	str r2, [sp, #4]
	add r7, r6, #0
	str r0, [sp, #0xc]
	add r4, sp, #0x14
_021F1778:
	ldr r1, _021F17F4 ; =0x0000185E
	ldr r0, [sp]
	ldrb r2, [r5, r1]
	mov r1, #0x1e
	add r0, r0, r7
	mul r1, r2
	add r0, r0, r1
	str r0, [sp, #0x10]
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	str r1, [sp, #8]
	ldr r0, [r1, r0]
	add r1, sp, #0x14
	add r1, #2
	add r2, sp, #0x14
	bl ManagedSprite_GetPositionXY
	mov r0, #0
	ldrsh r1, [r4, r0]
	sub r0, #0x10
	cmp r1, r0
	bne _021F17C8
	mov r0, #0xe0
	strh r0, [r4]
	ldr r1, _021F17F8 ; =0x00001859
	mov r2, #0xf
	ldrb r1, [r5, r1]
	add r0, r5, #0
	mul r2, r1
	ldr r1, [sp, #0xc]
	add r1, r2, r1
	ldr r2, [sp, #0x10]
	add r1, r6, r1
	bl ov18_021F1598
	add r0, r6, #1
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
_021F17C8:
	mov r0, #0
	ldrsh r1, [r4, r0]
	ldr r0, [sp, #4]
	mov r2, #0
	add r0, r1, r0
	strh r0, [r4]
	mov r0, #0x67
	ldr r1, [sp, #8]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	ldrsh r1, [r4, r1]
	ldrsh r2, [r4, r2]
	bl ManagedSprite_SetPositionXY
	add r0, r7, #1
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	cmp r7, #0x1e
	blo _021F1778
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F17F4: .word 0x0000185E
_021F17F8: .word 0x00001859
	thumb_func_end ov18_021F1760

	thumb_func_start ov18_021F17FC
ov18_021F17FC: ; 0x021F17FC
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F18C8 ; =0x0000C58C
	ldr r1, _021F18CC ; =0x00000668
	str r0, [sp, #8]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #8
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObj
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F18D0 ; =0x0000C58D
	ldr r1, _021F18CC ; =0x00000668
	str r0, [sp, #8]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #8
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObj
	mov r0, #8
	str r0, [sp]
	mov r0, #0x4b
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F18D4 ; =0x0000C552
	ldr r3, _021F18CC ; =0x00000668
	str r0, [sp, #0x14]
	mov r0, #0x85
	lsl r0, r0, #4
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBuffer
	mov r0, #8
	str r0, [sp]
	mov r0, #0x4b
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F18D8 ; =0x0000C553
	ldr r3, _021F18CC ; =0x00000668
	str r0, [sp, #0x14]
	mov r0, #0x85
	lsl r0, r0, #4
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBuffer
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F18DC ; =0x0000C551
	ldr r1, _021F18CC ; =0x00000668
	str r0, [sp, #4]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #8
	mov r3, #0x4d
	bl SpriteSystem_LoadCellResObj
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F18DC ; =0x0000C551
	ldr r1, _021F18CC ; =0x00000668
	str r0, [sp, #4]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #8
	mov r3, #0x4e
	bl SpriteSystem_LoadAnimResObj
	add sp, #0x18
	pop {r4, pc}
	nop
_021F18C8: .word 0x0000C58C
_021F18CC: .word 0x00000668
_021F18D0: .word 0x0000C58D
_021F18D4: .word 0x0000C552
_021F18D8: .word 0x0000C553
_021F18DC: .word 0x0000C551
	thumb_func_end ov18_021F17FC

	thumb_func_start ov18_021F18E0
ov18_021F18E0: ; 0x021F18E0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F1924 ; =0x0000066C
	ldr r1, _021F1928 ; =0x0000C58C
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1924 ; =0x0000066C
	ldr r1, _021F192C ; =0x0000C58D
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1924 ; =0x0000066C
	ldr r1, _021F1930 ; =0x0000C552
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F1924 ; =0x0000066C
	ldr r1, _021F1934 ; =0x0000C553
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F1924 ; =0x0000066C
	ldr r1, _021F1938 ; =0x0000C551
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F1924 ; =0x0000066C
	ldr r1, _021F1938 ; =0x0000C551
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r4, pc}
	nop
_021F1924: .word 0x0000066C
_021F1928: .word 0x0000C58C
_021F192C: .word 0x0000C58D
_021F1930: .word 0x0000C552
_021F1934: .word 0x0000C553
_021F1938: .word 0x0000C551
	thumb_func_end ov18_021F18E0

	thumb_func_start ov18_021F193C
ov18_021F193C: ; 0x021F193C
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F19D8 ; =0x0000C58E
	ldr r1, _021F19DC ; =0x00000668
	str r0, [sp, #8]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #8
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObj
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _021F19E0 ; =0x0000C58F
	ldr r1, _021F19DC ; =0x00000668
	str r0, [sp, #8]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #8
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObj
	mov r0, #8
	str r0, [sp]
	mov r0, #0x4b
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F19E4 ; =0x0000C554
	ldr r3, _021F19DC ; =0x00000668
	str r0, [sp, #0x14]
	mov r0, #0x85
	lsl r0, r0, #4
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBuffer
	mov r0, #8
	str r0, [sp]
	mov r0, #0x4b
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _021F19E8 ; =0x0000C555
	ldr r3, _021F19DC ; =0x00000668
	str r0, [sp, #0x14]
	mov r0, #0x85
	lsl r0, r0, #4
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r0, [r4, r0]
	ldr r3, [r4, r3]
	mov r1, #3
	bl SpriteSystem_LoadPaletteBuffer
	add sp, #0x18
	pop {r4, pc}
	nop
_021F19D8: .word 0x0000C58E
_021F19DC: .word 0x00000668
_021F19E0: .word 0x0000C58F
_021F19E4: .word 0x0000C554
_021F19E8: .word 0x0000C555
	thumb_func_end ov18_021F193C

	thumb_func_start ov18_021F19EC
ov18_021F19EC: ; 0x021F19EC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F1A1C ; =0x0000066C
	ldr r1, _021F1A20 ; =0x0000C58E
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1A1C ; =0x0000066C
	ldr r1, _021F1A24 ; =0x0000C58F
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadCharObjById
	ldr r0, _021F1A1C ; =0x0000066C
	ldr r1, _021F1A28 ; =0x0000C554
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F1A1C ; =0x0000066C
	ldr r1, _021F1A2C ; =0x0000C555
	ldr r0, [r4, r0]
	bl SpriteManager_UnloadPlttObjById
	pop {r4, pc}
	nop
_021F1A1C: .word 0x0000066C
_021F1A20: .word 0x0000C58E
_021F1A24: .word 0x0000C58F
_021F1A28: .word 0x0000C554
_021F1A2C: .word 0x0000C555
	thumb_func_end ov18_021F19EC

	thumb_func_start ov18_021F1A30
ov18_021F1A30: ; 0x021F1A30
	push {r3, r4, r5, lr}
	lsl r4, r1, #2
	ldr r1, _021F1A6C ; =0x00000668
	add r5, r0, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	mov r3, #2
	ldr r1, [r5, r1]
	ldr r2, _021F1A70 ; =ov18_021FABC0
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	mov r1, #0x67
	mov r3, #2
	add r2, r5, r4
	lsl r1, r1, #4
	str r0, [r2, r1]
	add r0, r1, #0
	sub r0, #8
	sub r1, r1, #4
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	ldr r2, _021F1A74 ; =ov18_021FABF4
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	ldr r1, _021F1A78 ; =0x00000674
	add r2, r5, r4
	str r0, [r2, r1]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021F1A6C: .word 0x00000668
_021F1A70: .word ov18_021FABC0
_021F1A74: .word ov18_021FABF4
_021F1A78: .word 0x00000674
	thumb_func_end ov18_021F1A30

	thumb_func_start ov18_021F1A7C
ov18_021F1A7C: ; 0x021F1A7C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x40
	str r2, [sp, #0x14]
	str r3, [sp, #0x18]
	ldr r3, _021F1BC0 ; =ov18_021FA328
	add r2, sp, #0x20
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
	mov r0, #0
	add r1, sp, #0x30
	mov r2, #0x10
	bl MIi_CpuClearFast
	ldr r0, _021F1BC4 ; =0x00000147
	cmp r4, r0
	bne _021F1AC6
	add r0, sp, #0x48
	ldrb r0, [r0, #0x10]
	cmp r0, #2
	bne _021F1AC6
	ldr r0, [r5]
	mov r1, #0
	ldr r0, [r0]
	bl Pokedex_GetSeenSpindaPersonality
	add r6, r0, #0
	b _021F1AC8
_021F1AC6:
	mov r6, #0
_021F1AC8:
	mov r0, #0
	str r0, [sp]
	ldr r0, [sp, #0x14]
	add r3, sp, #0x48
	str r0, [sp, #4]
	str r6, [sp, #8]
	ldrb r3, [r3, #0x10]
	ldr r2, [sp, #0x18]
	add r0, sp, #0x30
	add r1, r4, #0
	bl GetMonSpriteCharAndPlttNarcIdsEx
	str r7, [sp]
	str r6, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	add r0, sp, #0x48
	ldrb r0, [r0, #0x10]
	add r1, sp, #0x20
	mov r2, #0x25
	str r0, [sp, #0xc]
	str r4, [sp, #0x10]
	ldrh r0, [r1, #0x10]
	ldrh r1, [r1, #0x12]
	add r3, sp, #0x20
	bl sub_02014510
	mov r0, #0x67
	lsl r0, r0, #4
	add r4, r5, r0
	ldr r0, [sp, #0x5c]
	lsl r6, r0, #2
	ldr r0, [r4, r6]
	ldr r0, [r0]
	bl Sprite_GetImageProxy
	mov r1, #2
	bl NNS_G2dGetImageLocation
	mov r1, #0x32
	str r0, [sp, #0x1c]
	add r0, r7, #0
	lsl r1, r1, #6
	bl DC_FlushRange
	mov r2, #0x32
	ldr r1, [sp, #0x1c]
	add r0, r7, #0
	lsl r2, r2, #6
	bl GXS_LoadOBJ
	ldr r0, [r4, r6]
	ldr r0, [r0]
	bl Sprite_GetPaletteProxy
	mov r1, #2
	bl NNS_G2dGetImagePaletteLocation
	add r4, r0, #0
	ldr r0, [sp, #0x60]
	cmp r0, #0
	bne _021F1B6E
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0x25
	str r0, [sp, #4]
	add r1, sp, #0x20
	ldrh r0, [r1, #0x10]
	ldrh r1, [r1, #0x14]
	mov r2, #5
	add r3, r4, #0
	bl GfGfxLoader_GXLoadPal
	mov r0, #0x85
	lsl r0, r0, #4
	lsl r2, r4, #0xf
	ldr r0, [r5, r0]
	mov r1, #3
	lsr r2, r2, #0x10
	mov r3, #0x20
	bl PaletteData_LoadPaletteSlotFromHardware
	b _021F1BB4
_021F1B6E:
	cmp r0, #1
	bne _021F1B94
	mov r0, #3
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	lsl r0, r4, #0xf
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #0x85
	add r2, sp, #0x20
	lsl r0, r0, #4
	ldrh r1, [r2, #0x10]
	ldrh r2, [r2, #0x14]
	ldr r0, [r5, r0]
	mov r3, #0x25
	bl PaletteData_LoadNarc
	b _021F1BB4
_021F1B94:
	lsr r1, r4, #1
	lsl r0, r1, #0x10
	lsr r0, r0, #0x10
	add r1, #0x10
	str r0, [sp]
	lsl r0, r1, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #4]
	mov r0, #0x85
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #3
	mov r2, #2
	mov r3, #0
	bl PaletteData_FillPaletteInBuffer
_021F1BB4:
	add r0, r7, #0
	bl Heap_Free
	add sp, #0x40
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F1BC0: .word ov18_021FA328
_021F1BC4: .word 0x00000147
	thumb_func_end ov18_021F1A7C

	thumb_func_start ov18_021F1BC8
ov18_021F1BC8: ; 0x021F1BC8
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, _021F1CA8 ; =0x0000185F
	add r4, r2, #0
	ldrb r0, [r5, r0]
	add r6, r1, #0
	add r7, r3, #0
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	add r0, r4, r0
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r3, _021F1CA8 ; =0x0000185F
	mov r1, #0xf
	ldrb r2, [r5, r3]
	add r0, r2, #0
	bic r0, r1
	lsl r1, r2, #0x1c
	lsr r2, r1, #0x1c
	mov r1, #1
	eor r1, r2
	lsl r1, r1, #0x18
	lsr r2, r1, #0x18
	mov r1, #0xf
	and r1, r2
	orr r0, r1
	strb r0, [r5, r3]
	ldrb r0, [r5, r3]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	add r4, r4, r0
	cmp r6, #0
	bne _021F1C3C
	lsl r0, r7, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_021F1C3C:
	lsl r0, r7, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r5]
	add r1, r6, #0
	ldr r0, [r0]
	mov r2, #0
	bl Pokedex_SpeciesGetLastSeenGender
	add r7, r0, #0
	ldr r0, [r5]
	add r1, r6, #0
	ldr r0, [r0]
	mov r2, #0
	bl Pokedex_GetSeenFormByIdx
	add r2, r0, #0
	cmp r6, #0xac
	bne _021F1C88
	cmp r2, #2
	bne _021F1C86
	mov r2, #1
	add r7, r2, #0
	b _021F1C88
_021F1C86:
	mov r2, #0
_021F1C88:
	mov r0, #2
	str r0, [sp]
	lsl r2, r2, #0x18
	lsl r3, r7, #0x18
	str r4, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r1, r6, #0
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl ov18_021F1A7C
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021F1CA8: .word 0x0000185F
	thumb_func_end ov18_021F1BC8

	thumb_func_start ov18_021F1CAC
ov18_021F1CAC: ; 0x021F1CAC
	push {r3, lr}
	bl ov18_021F1BC8
	pop {r3, pc}
	thumb_func_end ov18_021F1CAC

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
