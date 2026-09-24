	.include "asm/macros.inc"
	.include "overlay_18.inc"
	.include "global.inc"

.public ov18_021F9310

	.text

	thumb_func_start ov18_021F94A0
ov18_021F94A0: ; 0x021F94A0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_Delete
	mov r0, #0x86
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_Delete
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F94A0

	thumb_func_start ov18_021F94BC
ov18_021F94BC: ; 0x021F94BC
	push {r3, r4, lr}
	sub sp, #0x44
	mov r1, #0x7d
	add r4, r0, #0
	lsl r1, r1, #2
	add r0, r4, r1
	sub r1, #0x14
	add r1, r4, r1
	add r2, sp, #0
	mov r3, #1
	bl ov18_021F9310
	add r0, r4, #0
	add r0, #0xb4
	ldr r0, [r0]
	mov r1, #1
	str r0, [sp, #0x24]
	add r0, sp, #0
	str r0, [sp, #0x28]
	mov r0, #0
	str r1, [sp, #0x3c]
	str r0, [sp, #0x38]
	ldr r0, [r4, #0x14]
	str r0, [sp, #0x40]
	mov r0, #7
	lsl r0, r0, #0x10
	str r0, [sp, #0x2c]
	lsl r0, r1, #0x11
	str r0, [sp, #0x30]
	add r0, sp, #0x24
	bl Sprite_Create
	mov r1, #0x1f
	lsl r1, r1, #4
	str r0, [r4, r1]
	add sp, #0x44
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F94BC

	thumb_func_start ov18_021F9508
ov18_021F9508: ; 0x021F9508
	mov r1, #0x1f
	lsl r1, r1, #4
	ldr r3, _021F9514 ; =Sprite_Delete
	ldr r0, [r0, r1]
	bx r3
	nop
_021F9514: .word Sprite_Delete
	thumb_func_end ov18_021F9508

	thumb_func_start ov18_021F9518
ov18_021F9518: ; 0x021F9518
	push {r4, r5, lr}
	sub sp, #0x44
	mov r1, #0x23
	add r5, r0, #0
	lsl r1, r1, #4
	add r0, r5, r1
	sub r1, #0x50
	add r1, r5, r1
	add r2, sp, #0
	mov r3, #1
	bl ov18_021F9310
	add r0, r5, #0
	add r0, #0xb4
	ldr r0, [r0]
	str r0, [sp, #0x24]
	add r0, sp, #0
	str r0, [sp, #0x28]
	mov r0, #1
	str r0, [sp, #0x3c]
	mov r0, #0
	str r0, [sp, #0x38]
	ldr r0, [r5, #0x14]
	str r0, [sp, #0x40]
	mov r0, #0x1e
	lsl r0, r0, #0xe
	str r0, [sp, #0x2c]
	mov r0, #5
	lsl r0, r0, #0x10
	str r0, [sp, #0x30]
	add r0, sp, #0x24
	bl Sprite_Create
	mov r1, #0x8b
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r1, #0x18
	ldr r0, [r5, r1]
	ldr r1, [r5, #0x14]
	bl ov18_021F9694
	add r4, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Sprite_GetImageProxy
	mov r1, #1
	bl NNS_G2dGetImageLocation
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #0x80
	bl DC_FlushRange
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0x80
	bl GX_LoadOBJ
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x44
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F9518

	thumb_func_start ov18_021F959C
ov18_021F959C: ; 0x021F959C
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r3, _021F95A8 ; =Sprite_Delete
	ldr r0, [r0, r1]
	bx r3
	nop
_021F95A8: .word Sprite_Delete
	thumb_func_end ov18_021F959C

	thumb_func_start ov18_021F95AC
ov18_021F95AC: ; 0x021F95AC
	push {r3, r4, r5, r6, r7, lr}
	mov r4, #0
	mov r6, #0x1f
	add r5, r0, #0
	add r7, r4, #0
	lsl r6, r6, #4
_021F95B8:
	ldr r0, [r5, r6]
	add r1, r7, #0
	bl Sprite_SetDrawFlag
	add r4, r4, #1
	add r5, #0x14
	cmp r4, #4
	blo _021F95B8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F95AC

	thumb_func_start ov18_021F95CC
ov18_021F95CC: ; 0x021F95CC
	push {r4, lr}
	sub sp, #0x20
	add r4, r0, #0
	ldr r1, [r4, #0xc]
	add r0, sp, #0x10
	mov r2, #2
	bl GetPokemonSpriteCharAndPlttNarcIds
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	ldr r0, [r4, #8]
	add r1, sp, #0x10
	mov r2, #0x30
	mov r3, #0x48
	bl PokepicManager_CreatePokepic
	str r0, [r4, #0x20]
	add sp, #0x20
	pop {r4, pc}
	thumb_func_end ov18_021F95CC

	thumb_func_start ov18_021F95F8
ov18_021F95F8: ; 0x021F95F8
	ldr r0, [r0, #0x20]
	bx lr
	thumb_func_end ov18_021F95F8

	thumb_func_start ov18_021F95FC
ov18_021F95FC: ; 0x021F95FC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r6, r0, #0
	ldr r0, [sp, #0x30]
	add r7, r1, #0
	add r5, r2, #0
	add r4, r3, #0
	cmp r0, #1
	bne _021F961A
	ldr r0, [sp, #0x28]
	mov r2, #0
	bl FontID_String_GetWidth
	sub r5, r5, r0
	b _021F962A
_021F961A:
	cmp r0, #2
	bne _021F962A
	ldr r0, [sp, #0x28]
	mov r2, #0
	bl FontID_String_GetWidth
	lsr r0, r0, #1
	sub r5, r5, r0
_021F962A:
	str r4, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, [sp, #0x2c]
	ldr r1, [sp, #0x28]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r0, r6, #0
	add r2, r7, #0
	add r3, r5, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov18_021F95FC

	thumb_func_start ov18_021F9648
ov18_021F9648: ; 0x021F9648
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	add r1, r2, #0
	add r6, r3, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	ldr r0, [sp, #0x24]
	ldr r3, [sp, #0x20]
	str r0, [sp]
	ldr r0, [sp, #0x28]
	add r1, r4, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x2c]
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r5, #0
	bl ov18_021F95FC
	add r0, r4, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov18_021F9648
