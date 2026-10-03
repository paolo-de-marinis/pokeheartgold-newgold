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

.public ov18_021EE35C
.public ov18_021EE388
.public ov18_021EE3AC
.public ov18_021EE44C
.public ov18_021EE520
.public ov18_021EEA84
.public ov18_021EEB34
.public ov18_021EF1E4
.public ov18_021EF220
.public ov18_021EF25C
.public ov18_021EF298
.public ov18_021EF2D4
.public ov18_021EF310
.public ov18_021EF34C
.public ov18_021EF388
.public ov18_021F95FC
.public ov18_021F9648
.public ov18_021F9DB0
.public ov18_021F9DC0
.public ov18_021F9DE4
.public ov18_021F9E4C
.public ov18_021F9EBC
.public ov18_021FA36C
.public ov18_021FA380
.public ov18_021FA3C8
.public ov18_021FA3E8

	.text

	thumb_func_start ov18_021F0B70
ov18_021F0B70: ; 0x021F0B70
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	mov r4, #0
	add r5, r0, #0
	str r1, [sp, #0x14]
	add r6, sp, #0x18
	sub r7, r4, #2
_021F0B7E:
	add r1, r4, #0
	add r2, sp, #0x18
	ldr r0, [r5, #8]
	add r1, #0x11
	add r2, #1
	add r3, sp, #0x18
	bl sub_02019B1C
	mov r0, #0
	ldrsb r0, [r6, r0]
	cmp r0, r7
	beq _021F0BA0
	cmp r0, #0x10
	beq _021F0BA0
	add r4, r4, #1
	cmp r4, #6
	blo _021F0B7E
_021F0BA0:
	add r0, r4, #0
	add r6, r5, #0
	add r0, #0xa
	add r6, #0xc
	lsl r7, r0, #4
	add r0, r6, r7
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	cmp r0, #0
	ldr r0, [r5, #8]
	bge _021F0BFC
	add r1, r4, #0
	add r1, #0x11
	mov r2, #8
	mov r3, #0x10
	bl sub_020196E8
	ldr r0, _021F0C44 ; =0x000018C5
	ldrsb r1, [r5, r0]
	sub r0, r0, #1
	ldrsb r0, [r5, r0]
	add r1, r1, #2
	cmp r1, r0
	bge _021F0C38
	add r0, r5, #0
	bl ov18_021F09D8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	add r4, #0xa
	str r0, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	ldr r1, _021F0C48 ; =0x000F0C00
	add r2, r4, #0
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r1, _021F0C4C ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov18_021EE3AC
	b _021F0C38
_021F0BFC:
	mov r2, #8
	add r1, r4, #0
	add r3, r2, #0
	add r1, #0x11
	sub r3, #0xa
	bl sub_020196E8
	ldr r0, _021F0C44 ; =0x000018C5
	ldrsb r0, [r5, r0]
	sub r1, r0, #2
	bmi _021F0C38
	add r0, r5, #0
	bl ov18_021F09D8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	add r4, #0xa
	str r0, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	ldr r1, _021F0C48 ; =0x000F0C00
	add r2, r4, #0
	str r1, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r1, _021F0C4C ; =0x0000065C
	add r0, r5, #0
	ldr r1, [r5, r1]
	bl ov18_021EE3AC
_021F0C38:
	add r0, r6, r7
	bl CopyWindowPixelsToVram_TextMode
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_021F0C44: .word 0x000018C5
_021F0C48: .word 0x000F0C00
_021F0C4C: .word 0x0000065C
	thumb_func_end ov18_021F0B70

	thumb_func_start ov18_021F0C50
ov18_021F0C50: ; 0x021F0C50
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	add r0, #0xc
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x4c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x1c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F0D18 ; =0x00020100
	ldr r1, _021F0D1C ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xc
	mov r2, #0xaa
	bl ov18_021F9648
	ldr r0, _021F0D20 ; =0x000018C4
	ldrsb r0, [r5, r0]
	cmp r0, #1
	beq _021F0CB2
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F0D24 ; =0x000F0C00
	ldr r1, _021F0D1C ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x4c
	mov r2, #0xa8
	bl ov18_021F9648
_021F0CB2:
	ldr r0, _021F0D28 ; =0x000018A2
	mov r1, #2
	ldrh r0, [r5, r0]
	mov r2, #0x25
	bl ov18_021E590C
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r3, #2
	mov r0, #0x66
	str r3, [sp, #4]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	add r2, r4, #0
	bl BufferString
	add r0, r4, #0
	bl String_Delete
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0D18 ; =0x00020100
	mov r2, #1
	str r0, [sp, #0xc]
	ldr r1, _021F0D1C ; =0x0000065C
	str r2, [sp, #0x10]
	ldr r1, [r5, r1]
	add r0, r5, #0
	mov r3, #0xa7
	bl ov18_021EE3AC
	add r0, r5, #0
	add r0, #0xc
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x4c
	bl ScheduleWindowCopyToVram
	add r5, #0x1c
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, pc}
	nop
_021F0D18: .word 0x00020100
_021F0D1C: .word 0x0000065C
_021F0D20: .word 0x000018C4
_021F0D24: .word 0x000F0C00
_021F0D28: .word 0x000018A2
	thumb_func_end ov18_021F0C50

	thumb_func_start ov18_021F0D2C
ov18_021F0D2C: ; 0x021F0D2C
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r0, #0x2c
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, _021F0D70 ; =0x000018C5
	add r0, r4, #0
	ldrsb r1, [r4, r1]
	bl ov18_021F09D8
	add r3, r0, #0
	mov r0, #0x3c
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0D74 ; =0x00020100
	mov r2, #2
	str r0, [sp, #0xc]
	ldr r1, _021F0D78 ; =0x0000065C
	str r2, [sp, #0x10]
	ldr r1, [r4, r1]
	add r0, r4, #0
	bl ov18_021EE3AC
	add r4, #0x2c
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r3, r4, pc}
	nop
_021F0D70: .word 0x000018C5
_021F0D74: .word 0x00020100
_021F0D78: .word 0x0000065C
	thumb_func_end ov18_021F0D2C

	thumb_func_start ov18_021F0D7C
ov18_021F0D7C: ; 0x021F0D7C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x1c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x2c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x4c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xac
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xbc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xcc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xdc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0xec
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, #0xfc
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	thumb_func_end ov18_021F0D7C

	thumb_func_start ov18_021F0DD0
ov18_021F0DD0: ; 0x021F0DD0
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	bl ov18_021F0D7C
	add r0, r5, #0
	add r0, #0xc
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x3c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x5c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x8c
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r0, #0x9c
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _021F0F10 ; =0x00020100
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	str r3, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0xc
	mov r2, #0xaa
	bl ov18_021F9648
	ldr r0, _021F0F18 ; =0x000018A2
	mov r1, #2
	ldrh r0, [r5, r0]
	mov r2, #0x25
	bl ov18_021E590C
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r3, #2
	mov r0, #0x66
	str r3, [sp, #4]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0
	add r2, r4, #0
	bl BufferString
	add r0, r4, #0
	bl String_Delete
	mov r0, #0x48
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0F10 ; =0x00020100
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, [r5, r1]
	add r0, r5, #0
	mov r2, #3
	mov r3, #0xa9
	bl ov18_021EE3AC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0F1C ; =0x00050900
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x5c
	mov r2, #0xaa
	mov r3, #0x18
	bl ov18_021F9648
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0F20 ; =0x000F0C00
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x8c
	mov r2, #0xab
	mov r3, #0x30
	bl ov18_021F9648
	mov r0, #4
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F0F20 ; =0x000F0C00
	ldr r1, _021F0F14 ; =0x0000065C
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	add r0, r5, #0
	ldr r1, [r5, r1]
	add r0, #0x9c
	mov r2, #0xac
	mov r3, #0x30
	bl ov18_021F9648
	add r0, r5, #0
	add r0, #0xc
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x3c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x5c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x8c
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add r0, #0x9c
	bl ScheduleWindowCopyToVram
	ldr r2, _021F0F24 ; =0x000018C5
	add r0, r5, #0
	ldrsb r2, [r5, r2]
	mov r1, #6
	bl ov18_021F0F68
	ldr r2, _021F0F28 ; =0x000018C6
	add r0, r5, #0
	ldrsb r2, [r5, r2]
	mov r1, #7
	bl ov18_021F0F68
	add sp, #0x14
	pop {r4, r5, pc}
	.balign 4, 0
_021F0F10: .word 0x00020100
_021F0F14: .word 0x0000065C
_021F0F18: .word 0x000018A2
_021F0F1C: .word 0x00050900
_021F0F20: .word 0x000F0C00
_021F0F24: .word 0x000018C5
_021F0F28: .word 0x000018C6
	thumb_func_end ov18_021F0DD0

	thumb_func_start ov18_021F0F2C
ov18_021F0F2C: ; 0x021F0F2C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xc
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x3c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x5c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x8c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x9c
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	add r0, #0x6c
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, #0x7c
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	thumb_func_end ov18_021F0F2C

	thumb_func_start ov18_021F0F68
ov18_021F0F68: ; 0x021F0F68
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r6, r0, #0
	add r7, r1, #0
	add r5, r6, #0
	add r5, #0xc
	lsl r4, r7, #4
	str r2, [sp, #0x14]
	add r0, r5, r4
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r1, [sp, #0x14]
	add r0, r6, #0
	bl ov18_021F09D8
	str r0, [sp, #0x18]
	add r0, r5, r4
	bl GetWindowWidth
	lsl r1, r0, #3
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F0FC0 ; =0x00050900
	ldr r1, _021F0FC4 ; =0x0000065C
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r1, [r6, r1]
	ldr r3, [sp, #0x18]
	add r0, r6, #0
	add r2, r7, #0
	bl ov18_021EE3AC
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0FC0: .word 0x00050900
_021F0FC4: .word 0x0000065C
	thumb_func_end ov18_021F0F68

	thumb_func_start ov18_021F0FC8
ov18_021F0FC8: ; 0x021F0FC8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	bl ov18_021F12FC
	add r0, r4, #0
	bl ov18_021F1024
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F0FC8

	thumb_func_start ov18_021F0FEC
ov18_021F0FEC: ; 0x021F0FEC
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F1104
	add r0, r4, #0
	bl ov18_021F10C8
	add r0, r4, #0
	bl ov18_021F1314
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F0FEC

	thumb_func_start ov18_021F1004
ov18_021F1004: ; 0x021F1004
	push {r4, r5, r6, lr}
	mov r6, #0x67
	add r5, r0, #0
	mov r4, #0
	lsl r6, r6, #4
_021F100E:
	ldr r0, [r5, r6]
	cmp r0, #0
	beq _021F1018
	bl ManagedSprite_TickFrame
_021F1018:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0x78
	blo _021F100E
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F1004

	thumb_func_start ov18_021F1024
ov18_021F1024: ; 0x021F1024
	push {r4, r5, r6, r7, lr}
	sub sp, #0x4c
	add r4, r0, #0
	mov r0, #0x25
	bl SpriteSystem_Alloc
	ldr r1, _021F10B4 ; =0x00000668
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	bl SpriteManager_New
	ldr r7, _021F10B8 ; =0x0000066C
	add r2, sp, #0x2c
	ldr r3, _021F10BC ; =ov18_021FA3C8
	str r0, [r4, r7]
	ldmia r3!, {r0, r1}
	add r6, r2, #0
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	ldr r5, _021F10C0 ; =ov18_021FA36C
	stmia r2!, {r0, r1}
	add r3, sp, #0x18
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	add r1, r6, #0
	str r0, [r3]
	sub r0, r7, #4
	ldr r0, [r4, r0]
	mov r3, #0x20
	bl SpriteSystem_Init
	ldr r3, _021F10C4 ; =ov18_021FA380
	add r2, sp, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x78
	bl SpriteSystem_InitSprites
	sub r1, r7, #4
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	add r2, sp, #0
	bl SpriteSystem_InitManagerWithCapacities
	sub r0, r7, #4
	ldr r0, [r4, r0]
	bl SpriteSystem_GetRenderer
	mov r2, #2
	mov r1, #0
	lsl r2, r2, #0x14
	bl G2dRenderer_SetSubSurfaceCoords
	add sp, #0x4c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F10B4: .word 0x00000668
_021F10B8: .word 0x0000066C
_021F10BC: .word ov18_021FA3C8
_021F10C0: .word ov18_021FA36C
_021F10C4: .word ov18_021FA380
	thumb_func_end ov18_021F1024

	thumb_func_start ov18_021F10C8
ov18_021F10C8: ; 0x021F10C8
	push {r4, lr}
	ldr r1, _021F10E4 ; =0x00000668
	add r4, r0, #0
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	bl SpriteSystem_FreeResourcesAndManager
	ldr r0, _021F10E4 ; =0x00000668
	ldr r0, [r4, r0]
	bl SpriteSystem_Free
	pop {r4, pc}
	nop
_021F10E4: .word 0x00000668
	thumb_func_end ov18_021F10C8

	thumb_func_start ov18_021F10E8
ov18_021F10E8: ; 0x021F10E8
	push {r3, r4, r5, lr}
	lsl r5, r1, #2
	mov r1, #0x67
	lsl r1, r1, #4
	add r4, r0, r1
	ldr r0, [r4, r5]
	cmp r0, #0
	beq _021F1100
	bl Sprite_DeleteAndFreeResources
	mov r0, #0
	str r0, [r4, r5]
_021F1100:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F10E8

	thumb_func_start ov18_021F1104
ov18_021F1104: ; 0x021F1104
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
_021F110A:
	add r0, r5, #0
	add r1, r4, #0
	bl ov18_021F10E8
	add r4, r4, #1
	cmp r4, #0x78
	blo _021F110A
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F1104

	thumb_func_start ov18_021F111C
ov18_021F111C: ; 0x021F111C
	push {r4, r5, r6, lr}
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r5, r2, #0
	ldr r0, [r0]
	add r4, r3, #0
	bl Sprite_GetImageProxy
	ldr r1, [sp, #0x10]
	bl NNS_G2dGetImageLocation
	add r6, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl DC_FlushRange
	ldr r0, [sp, #0x10]
	cmp r0, #1
	bne _021F1154
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl GX_LoadOBJ
	pop {r4, r5, r6, pc}
_021F1154:
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl GXS_LoadOBJ
	pop {r4, r5, r6, pc}
	thumb_func_end ov18_021F111C

	thumb_func_start ov18_021F1160
ov18_021F1160: ; 0x021F1160
	push {r3, lr}
	cmp r2, #1
	bne _021F1178
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetOamMode
	pop {r3, pc}
_021F1178:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetOamMode
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov18_021F1160

	thumb_func_start ov18_021F118C
ov18_021F118C: ; 0x021F118C
	push {r4, r5, r6, lr}
	add r6, r2, #0
	mov r2, #0x67
	lsl r2, r2, #4
	lsl r4, r1, #2
	add r5, r0, r2
	ldr r0, [r5, r4]
	mov r1, #0
	bl ManagedSprite_SetAnimationFrame
	ldr r0, [r5, r4]
	add r1, r6, #0
	bl ManagedSprite_SetAnim
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov18_021F118C

	thumb_func_start ov18_021F11AC
ov18_021F11AC: ; 0x021F11AC
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r3, _021F11BC ; =ManagedSprite_IsAnimated
	ldr r0, [r1, r0]
	bx r3
	nop
_021F11BC: .word ManagedSprite_IsAnimated
	thumb_func_end ov18_021F11AC

	thumb_func_start ov18_021F11C0
ov18_021F11C0: ; 0x021F11C0
	push {r3, lr}
	cmp r2, #1
	bne _021F11D8
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
_021F11D8:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov18_021F11C0

	thumb_func_start ov18_021F11EC
ov18_021F11EC: ; 0x021F11EC
	push {r3, lr}
	add r2, r1, #0
	add r3, r0, #0
	ldr r0, [r2, #0x10]
	ldr r1, _021F1218 ; =0x00000668
	cmp r0, #1
	bne _021F1206
	ldr r0, [r3, r1]
	add r1, r1, #4
	ldr r1, [r3, r1]
	bl SpriteSystem_NewSprite
	pop {r3, pc}
_021F1206:
	ldr r0, [r3, r1]
	add r1, r1, #4
	ldr r1, [r3, r1]
	mov r3, #2
	lsl r3, r3, #0x14
	bl SpriteSystem_NewSpriteWithYOffset
	pop {r3, pc}
	nop
_021F1218: .word 0x00000668
	thumb_func_end ov18_021F11EC

	thumb_func_start ov18_021F121C
ov18_021F121C: ; 0x021F121C
	push {r3, r4, r5, r6, r7, lr}
	add r4, r2, #0
	ldr r2, [sp, #0x18]
	add r6, r3, #0
	cmp r2, #0
	bne _021F125A
	mov r2, #0x67
	lsl r2, r2, #4
	add r5, r0, r2
	lsl r7, r1, #2
	add r1, sp, #0
	ldr r0, [r5, r7]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	add r2, sp, #0
	mov r1, #2
	ldrsh r1, [r2, r1]
	mov r3, #0
	ldrsh r2, [r2, r3]
	add r1, r1, r4
	lsl r1, r1, #0x10
	add r2, r2, r6
	lsl r2, r2, #0x10
	ldr r0, [r5, r7]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, r6, r7, pc}
_021F125A:
	mov r2, #0x67
	lsl r2, r2, #4
	add r5, r0, r2
	lsl r7, r1, #2
	add r1, sp, #0
	mov r3, #2
	ldr r0, [r5, r7]
	add r1, #2
	add r2, sp, #0
	lsl r3, r3, #0x14
	bl ManagedSprite_GetPositionXYWithSubscreenOffset
	add r2, sp, #0
	mov r3, #2
	ldrsh r1, [r2, r3]
	ldr r0, [r5, r7]
	lsl r3, r3, #0x14
	add r1, r1, r4
	mov r4, #0
	ldrsh r2, [r2, r4]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add r2, r2, r6
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F121C

	thumb_func_start ov18_021F1294
ov18_021F1294: ; 0x021F1294
	push {r4, lr}
	ldr r4, [sp, #8]
	cmp r4, #0
	bne _021F12B0
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	bl ManagedSprite_SetPositionXY
	pop {r4, pc}
_021F12B0:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	mov r3, #2
	lsl r3, r3, #0x14
	bl ManagedSprite_SetPositionXYWithSubscreenOffset
	pop {r4, pc}
	thumb_func_end ov18_021F1294

	thumb_func_start ov18_021F12C8
ov18_021F12C8: ; 0x021F12C8
	push {r4, lr}
	ldr r4, [sp, #8]
	cmp r4, #0
	bne _021F12E4
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	bl ManagedSprite_GetPositionXY
	pop {r4, pc}
_021F12E4:
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	mov r3, #2
	lsl r3, r3, #0x14
	bl ManagedSprite_GetPositionXYWithSubscreenOffset
	pop {r4, pc}
	thumb_func_end ov18_021F12C8

	thumb_func_start ov18_021F12FC
ov18_021F12FC: ; 0x021F12FC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x14
	mov r1, #0x25
	bl NARC_New
	ldr r1, _021F1310 ; =0x00000858
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_021F1310: .word 0x00000858
	thumb_func_end ov18_021F12FC

	thumb_func_start ov18_021F1314
ov18_021F1314: ; 0x021F1314
	ldr r1, _021F131C ; =0x00000858
	ldr r3, _021F1320 ; =NARC_Delete
	ldr r0, [r0, r1]
	bx r3
	.balign 4, 0
_021F131C: .word 0x00000858
_021F1320: .word NARC_Delete
	thumb_func_end ov18_021F1314

	thumb_func_start ov18_021F1324
ov18_021F1324: ; 0x021F1324
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	add r6, r1, #0
	ldr r4, _021F13C4 ; =0x00000000
	beq _021F1354
	mov r7, #1
_021F1332:
	ldr r0, _021F13C8 ; =0x0000C550
	str r7, [sp]
	str r7, [sp, #4]
	add r0, r4, r0
	str r0, [sp, #8]
	ldr r0, _021F13CC ; =0x00000668
	ldr r1, _021F13D0 ; =0x0000066C
	ldr r2, _021F13D4 ; =0x00000854
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	add r4, r4, #1
	cmp r4, r6
	blo _021F1332
_021F1354:
	bl sub_02074490
	ldr r1, _021F13D8 ; =0x00000858
	ldr r3, _021F13CC ; =0x00000668
	ldr r2, [r5, r1]
	sub r1, #8
	str r2, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #3
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r0, _021F13C8 ; =0x0000C550
	str r0, [sp, #0x14]
	ldr r2, [r5, r3]
	add r3, r3, #4
	ldr r0, [r5, r1]
	ldr r3, [r5, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	bl sub_0207449C
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F13C8 ; =0x0000C550
	ldr r1, _021F13CC ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F13D8 ; =0x00000858
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	bl sub_020744A8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _021F13C8 ; =0x0000C550
	ldr r1, _021F13CC ; =0x00000668
	str r0, [sp, #4]
	ldr r2, _021F13D8 ; =0x00000858
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F13C4: .word 0x00000000
_021F13C8: .word 0x0000C550
_021F13CC: .word 0x00000668
_021F13D0: .word 0x0000066C
_021F13D4: .word 0x00000854
_021F13D8: .word 0x00000858
	thumb_func_end ov18_021F1324

	thumb_func_start ov18_021F13DC
ov18_021F13DC: ; 0x021F13DC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	ldr r4, _021F1418 ; =0x00000000
	beq _021F13F8
	ldr r7, _021F141C ; =0x0000C550
_021F13E8:
	ldr r0, _021F1420 ; =0x0000066C
	add r1, r4, r7
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadCharObjById
	add r4, r4, #1
	cmp r4, r6
	blo _021F13E8
_021F13F8:
	ldr r0, _021F1420 ; =0x0000066C
	ldr r1, _021F141C ; =0x0000C550
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadPlttObjById
	ldr r0, _021F1420 ; =0x0000066C
	ldr r1, _021F141C ; =0x0000C550
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadCellObjById
	ldr r0, _021F1420 ; =0x0000066C
	ldr r1, _021F141C ; =0x0000C550
	ldr r0, [r5, r0]
	bl SpriteManager_UnloadAnimObjById
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F1418: .word 0x00000000
_021F141C: .word 0x0000C550
_021F1420: .word 0x0000066C
	thumb_func_end ov18_021F13DC

	thumb_func_start ov18_021F1424
ov18_021F1424: ; 0x021F1424
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x68
	add r7, r0, #0
	lsl r0, r1, #2
	ldr r3, _021F147C ; =ov18_021FA3E8
	mov r4, #0
	add r5, r7, r0
	add r2, sp, #0
	mov r6, #6
_021F1436:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _021F1436
	ldr r0, [r3]
	str r0, [r2]
_021F1442:
	add r6, sp, #0
	add r3, sp, #0x34
	mov r2, #6
_021F1448:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F1448
	ldr r0, [r6]
	ldr r1, _021F1480 ; =0x0000066C
	str r0, [r3]
	ldr r0, _021F1484 ; =0x0000C550
	add r2, sp, #0x34
	add r0, r4, r0
	str r0, [sp, #0x48]
	ldr r0, _021F1488 ; =0x00000668
	ldr r1, [r7, r1]
	ldr r0, [r7, r0]
	bl SpriteSystem_NewSprite
	mov r1, #0x67
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0x3c
	blo _021F1442
	add sp, #0x68
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F147C: .word ov18_021FA3E8
_021F1480: .word 0x0000066C
_021F1484: .word 0x0000C550
_021F1488: .word 0x00000668
	thumb_func_end ov18_021F1424

	thumb_func_start ov18_021F148C
ov18_021F148C: ; 0x021F148C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #0
	add r4, r3, #0
	bl GetBattleMonIconNaixEx
	add r1, r0, #0
	mov r0, #0x25
	str r0, [sp]
	ldr r0, _021F14B0 ; =0x00000858
	mov r2, #0
	ldr r0, [r5, r0]
	add r3, r4, #0
	bl GfGfxLoader_GetCharDataFromOpenNarc
	pop {r3, r4, r5, pc}
	nop
_021F14B0: .word 0x00000858
	thumb_func_end ov18_021F148C

	thumb_func_start ov18_021F14B4
ov18_021F14B4: ; 0x021F14B4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, _021F14F4 ; =0x0000066C
	str r1, [sp, #4]
	add r4, r2, #0
	ldr r0, [r5, r0]
	ldr r1, _021F14F8 ; =0x0000C550
	mov r2, #1
	add r6, r3, #0
	bl SpriteManager_FindPlttResourceOffset
	mov r3, #1
	add r7, r0, #0
	str r3, [sp]
	ldr r2, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	lsl r3, r3, #9
	bl ov18_021F111C
	lsl r0, r4, #2
	add r1, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, r7, r6
	bl ManagedSprite_SetPaletteOverride
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F14F4: .word 0x0000066C
_021F14F8: .word 0x0000C550
	thumb_func_end ov18_021F14B4

	thumb_func_start ov18_021F14FC
ov18_021F14FC: ; 0x021F14FC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	str r3, [sp]
	add r4, r1, #0
	add r6, r2, #0
	add r3, sp, #4
	add r5, r0, #0
	bl ov18_021F148C
	add r7, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	mov r2, #0
	bl GetBattleMonIconPaletteEx
	ldr r1, [sp, #4]
	add r3, r0, #0
	ldr r1, [r1, #0x14]
	ldr r2, [sp]
	add r0, r5, #0
	bl ov18_021F14B4
	add r0, r7, #0
	bl Heap_Free
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F14FC

	thumb_func_start ov18_021F1534
ov18_021F1534: ; 0x021F1534
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r3, #0
	add r3, sp, #0xc
	add r5, r0, #0
	add r7, r1, #0
	str r2, [sp, #4]
	bl ov18_021F148C
	mov r3, #2
	str r3, [sp]
	ldr r2, [sp, #0xc]
	str r0, [sp, #8]
	ldr r2, [r2, #0x14]
	add r0, r5, #0
	add r1, r4, #0
	lsl r3, r3, #8
	bl ov18_021F111C
	ldr r0, _021F1590 ; =0x0000066C
	ldr r1, _021F1594 ; =0x0000C551
	ldr r0, [r5, r0]
	mov r2, #2
	bl SpriteManager_FindPlttResourceOffset
	add r6, r0, #0
	ldr r1, [sp, #4]
	add r0, r7, #0
	mov r2, #0
	bl GetBattleMonIconPaletteEx
	add r1, r0, #0
	lsl r0, r4, #2
	add r2, r5, r0
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	add r1, r6, r1
	bl ManagedSprite_SetPaletteOverride
	ldr r0, [sp, #8]
	bl Heap_Free
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F1590: .word 0x0000066C
_021F1594: .word 0x0000C551
	thumb_func_end ov18_021F1534
