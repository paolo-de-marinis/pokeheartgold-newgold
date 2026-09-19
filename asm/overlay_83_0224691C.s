	.include "asm/macros.inc"
	.include "overlay_83.inc"
	.include "global.inc"

	.text

	thumb_func_start ov83_0224691C
ov83_0224691C: ; 0x0224691C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov83_02245D48
	add r0, r5, #0
	add r1, r4, #0
	bl ov83_02246114
	add r0, r5, #0
	bl ov83_02246988
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_0224691C

	thumb_func_start ov83_02246938
ov83_02246938: ; 0x02246938
	push {r4, r5, r6, lr}
	add r6, r0, #0
	cmp r1, #1
	bne _02246962
	mov r0, #0x11
	lsl r0, r0, #4
	mov r4, #0xc
	add r5, r6, r0
_02246948:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x22
	bls _02246948
	ldr r0, _02246984 ; =0x00000544
	mov r1, #1
	ldr r0, [r6, r0]
	bl ov83_0224755C
	pop {r4, r5, r6, pc}
_02246962:
	mov r0, #0x11
	lsl r0, r0, #4
	mov r5, #0xc
	add r4, r6, r0
_0224696A:
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #0x22
	bls _0224696A
	ldr r0, _02246984 ; =0x00000544
	mov r1, #0
	ldr r0, [r6, r0]
	bl ov83_0224755C
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02246984: .word 0x00000544
	thumb_func_end ov83_02246938

	thumb_func_start ov83_02246988
ov83_02246988: ; 0x02246988
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0x14]
	ldrb r1, [r4, #0xd]
	bl ov83_02247768
	ldr r3, _022469D4 ; =0x0000054C
	ldr r1, [r4, r3]
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _022469B6
	add r0, r3, #0
	add r1, r3, #0
	sub r0, #8
	add r1, #0x74
	add r3, #0x80
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r3, [r4, r3]
	mov r2, #0
	bl ov83_02247668
	pop {r4, pc}
_022469B6:
	add r2, r3, #0
	add r0, r3, #0
	add r1, r3, #0
	add r2, #0x78
	sub r0, #8
	add r1, #0x74
	add r3, #0x80
	ldrh r2, [r4, r2]
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r3, [r4, r3]
	bl ov83_02247668
	pop {r4, pc}
	nop
_022469D4: .word 0x0000054C
	thumb_func_end ov83_02246988

	thumb_func_start ov83_022469D8
ov83_022469D8: ; 0x022469D8
	ldr r3, _022469E0 ; =ov83_02244CDC
	strb r1, [r0, #0xd]
	strb r2, [r0, #0xc]
	bx r3
	.balign 4, 0
_022469E0: .word ov83_02244CDC
	thumb_func_end ov83_022469D8

	thumb_func_start ov83_022469E4
ov83_022469E4: ; 0x022469E4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	add r5, r0, #0
	add r0, sp, #4
	add r4, r1, #0
	add r0, #2
	add r1, sp, #4
	add r6, r2, #0
	add r7, r3, #0
	bl ov83_02247988
	ldr r0, _02246A90 ; =ov83_02248018
	add r1, sp, #4
	ldrh r2, [r0]
	add r3, sp, #8
	strh r2, [r1, #0x1c]
	ldrh r2, [r0, #2]
	strh r2, [r1, #0x1e]
	ldrh r2, [r0, #4]
	strh r2, [r1, #0x20]
	ldrh r2, [r0, #6]
	strh r2, [r1, #0x22]
	ldrh r2, [r0, #8]
	ldrh r0, [r0, #0xa]
	strh r2, [r1, #0x24]
	strh r0, [r1, #0x26]
	ldrh r0, [r1, #2]
	strh r0, [r1, #0x22]
	ldrh r2, [r1]
	add r0, r0, r2
	sub r0, #0x1b
	strh r0, [r1, #0x24]
	strh r2, [r1, #0x26]
	ldrh r0, [r1, #0x1c]
	strh r0, [r1, #4]
	ldrh r0, [r1, #0x1e]
	strh r0, [r1, #6]
	ldrh r0, [r1, #0x20]
	strh r0, [r1, #8]
	ldrh r0, [r1, #0x22]
	strh r0, [r1, #0xa]
	ldrh r0, [r1, #0x24]
	strh r0, [r1, #0xc]
	ldrh r0, [r1, #0x26]
	strh r0, [r1, #0xe]
	ldr r0, _02246A94 ; =0x000005FC
	ldr r2, [r5, r0]
	sub r0, #8
	str r2, [sp, #0x14]
	ldr r2, [r5, #0x4c]
	str r2, [sp, #0x18]
	strb r4, [r1, #0x18]
	add r1, sp, #0x30
	ldrb r1, [r1, #0x10]
	add r2, r6, #0
	str r1, [sp]
	add r1, r3, #0
	ldr r0, [r5, r0]
	add r3, r7, #0
	bl ov83_02247CCC
	ldr r1, _02246A98 ; =0x000005F8
	str r0, [r5, r1]
	ldrb r1, [r5, #0xf]
	mov r0, #4
	orr r0, r1
	strb r0, [r5, #0xf]
	ldrb r0, [r5, #9]
	mov r1, #1
	bl ov80_02237B24
	add r4, r0, #0
	ldr r0, _02246A9C ; =0x000004E4
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #1
	bl ov83_0224773C
	ldr r0, _02246AA0 ; =0x000004F4
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #1
	bl ov83_0224773C
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02246A90: .word ov83_02248018
_02246A94: .word 0x000005FC
_02246A98: .word 0x000005F8
_02246A9C: .word 0x000004E4
_02246AA0: .word 0x000004F4
	thumb_func_end ov83_022469E4

	thumb_func_start ov83_02246AA4
ov83_02246AA4: ; 0x02246AA4
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #4
	mov r1, #0x6b
	mov r4, #0
	bl ListMenuItems_New
	ldr r1, _02246B5C ; =0x000005FC
	mov r2, #2
	str r0, [r5, r1]
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	bl ov83_0224777C
	add r7, r0, #0
	ldrb r0, [r5, #0x14]
	ldrb r1, [r5, #0xd]
	bl ov83_02247768
	add r6, r0, #0
	ldr r0, _02246B60 ; =0x0000054C
	ldr r1, [r5, r0]
	ldrb r1, [r1, r6]
	cmp r1, #0
	bne _02246AEE
	add r0, #0xb0
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x20]
	mov r2, #8
	add r3, r4, #0
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
_02246AEE:
	ldr r0, _02246B5C ; =0x000005FC
	ldr r1, [r5, #0x20]
	ldr r0, [r5, r0]
	mov r2, #9
	mov r3, #1
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldr r0, _02246B64 ; =0x00000554
	ldr r1, [r5, r0]
	ldrb r1, [r1, r6]
	cmp r1, #0
	beq _02246B1A
	add r0, r0, #4
	ldr r0, [r5, r0]
	ldrb r0, [r0, r6]
	cmp r0, #0
	beq _02246B1A
	cmp r7, #2
	beq _02246B2E
_02246B1A:
	ldr r0, _02246B5C ; =0x000005FC
	ldr r1, [r5, #0x20]
	ldr r0, [r5, r0]
	mov r2, #0xa
	mov r3, #2
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
_02246B2E:
	ldr r0, _02246B5C ; =0x000005FC
	mov r2, #0xb
	add r3, r2, #0
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x20]
	sub r3, #0xd
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r3, r0, #0x10
	lsl r1, r3, #0x18
	ldr r4, _02246B68 ; =ov83_02248010
	mov r0, #0xd
	str r0, [sp]
	ldrb r3, [r4, r3]
	add r0, r5, #0
	lsr r1, r1, #0x18
	mov r2, #0x11
	bl ov83_022469E4
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02246B5C: .word 0x000005FC
_02246B60: .word 0x0000054C
_02246B64: .word 0x00000554
_02246B68: .word ov83_02248010
	thumb_func_end ov83_02246AA4

	thumb_func_start ov83_02246B6C
ov83_02246B6C: ; 0x02246B6C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #4
	mov r1, #0x6b
	mov r4, #0
	bl ListMenuItems_New
	ldr r1, _02246C1C ; =0x000005FC
	mov r2, #2
	str r0, [r5, r1]
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	bl ov83_0224777C
	add r6, r0, #0
	ldrb r0, [r5, #0x14]
	ldrb r1, [r5, #0xd]
	bl ov83_02247768
	add r7, r0, #0
	ldr r0, _02246C20 ; =0x00000554
	ldr r1, [r5, r0]
	ldrb r1, [r1, r7]
	cmp r1, #0
	bne _02246BB6
	add r0, #0xa8
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x20]
	mov r2, #0x21
	mov r3, #3
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
_02246BB6:
	cmp r6, #1
	beq _02246BD8
	ldr r0, _02246C24 ; =0x00000558
	ldr r1, [r5, r0]
	ldrb r1, [r1, r7]
	cmp r1, #0
	bne _02246BD8
	add r0, #0xa4
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x20]
	mov r2, #0x22
	mov r3, #4
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
_02246BD8:
	cmp r6, #2
	beq _02246BF0
	ldr r0, _02246C1C ; =0x000005FC
	ldr r1, [r5, #0x20]
	ldr r0, [r5, r0]
	mov r2, #0x23
	mov r3, #5
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
_02246BF0:
	ldr r0, _02246C1C ; =0x000005FC
	mov r2, #0x24
	add r3, r2, #0
	ldr r0, [r5, r0]
	ldr r1, [r5, #0x20]
	sub r3, #0x26
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r3, r0, #0x10
	lsl r1, r3, #0x18
	ldr r4, _02246C28 ; =ov83_02248010
	mov r0, #0xd
	str r0, [sp]
	ldrb r3, [r4, r3]
	add r0, r5, #0
	lsr r1, r1, #0x18
	mov r2, #0x11
	bl ov83_022469E4
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02246C1C: .word 0x000005FC
_02246C20: .word 0x00000554
_02246C24: .word 0x00000558
_02246C28: .word ov83_02248010
	thumb_func_end ov83_02246B6C

	thumb_func_start ov83_02246C2C
ov83_02246C2C: ; 0x02246C2C
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	mov r0, #3
	mov r1, #0x6b
	bl ListMenuItems_New
	ldr r1, _02246C6C ; =0x000005FC
	mov r4, #0
	str r0, [r5, r1]
	add r6, r1, #0
_02246C42:
	add r2, r4, #0
	ldr r0, [r5, r6]
	ldr r1, [r5, #0x20]
	add r2, #0x16
	add r3, r4, #0
	bl ListMenuItems_AppendFromMsgData
	add r4, r4, #1
	cmp r4, #3
	blo _02246C42
	mov r0, #0xd
	str r0, [sp]
	add r0, r5, #0
	mov r1, #3
	mov r2, #0x11
	mov r3, #8
	bl ov83_022469E4
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	nop
_02246C6C: .word 0x000005FC
	thumb_func_end ov83_02246C2C

	thumb_func_start ov83_02246C70
ov83_02246C70: ; 0x02246C70
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldrb r0, [r5, #9]
	mov r1, #1
	bl ov80_02237B24
	add r4, r0, #0
	ldr r0, _02246CB0 ; =0x000004E4
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	bl ov83_0224773C
	ldr r0, _02246CB4 ; =0x000004F4
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	bl ov83_0224773C
	ldr r0, _02246CB8 ; =0x000005F8
	ldr r0, [r5, r0]
	bl ov83_02247CE8
	ldr r0, _02246CBC ; =0x000005FC
	ldr r0, [r5, r0]
	bl ListMenuItems_Delete
	ldrb r1, [r5, #0xf]
	mov r0, #4
	bic r1, r0
	strb r1, [r5, #0xf]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02246CB0: .word 0x000004E4
_02246CB4: .word 0x000004F4
_02246CB8: .word 0x000005F8
_02246CBC: .word 0x000005FC
	thumb_func_end ov83_02246C70

	thumb_func_start ov83_02246CC0
ov83_02246CC0: ; 0x02246CC0
	push {r4, lr}
	sub sp, #0x18
	ldr r1, _02246D3C ; =0x000005F8
	add r4, r0, #0
	ldr r0, [r4, r1]
	add r3, r1, #0
	add r0, #0x24
	add r3, #8
	ldrb r0, [r0]
	ldr r3, [r4, r3]
	cmp r3, r0
	beq _02246D36
	add r1, r1, #4
	ldr r1, [r4, r1]
	lsl r0, r0, #3
	add r0, r1, r0
	ldr r1, [r0, #4]
	cmp r1, #2
	bhi _02246CF4
	cmp r1, #0
	beq _02246CFE
	cmp r1, #1
	beq _02246D02
	cmp r1, #2
	beq _02246D06
	b _02246D0C
_02246CF4:
	mov r0, #1
	mvn r0, r0
	cmp r1, r0
	beq _02246D0A
	b _02246D0C
_02246CFE:
	mov r2, #0xc
	b _02246D0C
_02246D02:
	mov r2, #0xd
	b _02246D0C
_02246D06:
	mov r2, #0xe
	b _02246D0C
_02246D0A:
	mov r2, #0xf
_02246D0C:
	mov r3, #1
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	add r1, r4, #0
	str r3, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xf
	str r0, [sp, #0x10]
	add r0, r4, #0
	add r1, #0xc0
	str r3, [sp, #0x14]
	bl ov83_022447E0
	ldr r0, _02246D3C ; =0x000005F8
	ldr r1, [r4, r0]
	add r0, #8
	add r1, #0x24
	ldrb r1, [r1]
	str r1, [r4, r0]
_02246D36:
	add sp, #0x18
	pop {r4, pc}
	nop
_02246D3C: .word 0x000005F8
	thumb_func_end ov83_02246CC0

	thumb_func_start ov83_02246D40
ov83_02246D40: ; 0x02246D40
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r5, r0, #0
	mov r0, #6
	lsl r0, r0, #8
	ldr r1, [r5, r0]
	sub r0, #8
	ldr r0, [r5, r0]
	add r0, #0x24
	ldrb r0, [r0]
	cmp r1, r0
	beq _02246DEA
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	mov r2, #2
	bl ov83_0224777C
	cmp r0, #1
	beq _02246D6E
	mov r1, #1
	b _02246D70
_02246D6E:
	mov r1, #0
_02246D70:
	ldr r2, _02246DF0 ; =0x000005FC
	ldr r0, [r5, r2]
	sub r2, r2, #4
	ldr r2, [r5, r2]
	add r2, #0x24
	ldrb r2, [r2]
	lsl r2, r2, #3
	add r0, r0, r2
	ldr r2, [r0, #4]
	cmp r2, #5
	bhi _02246D96
	cmp r2, #3
	blo _02246DBE
	beq _02246DA0
	cmp r2, #4
	beq _02246DA8
	cmp r2, #5
	beq _02246DB0
	b _02246DBE
_02246D96:
	mov r0, #1
	mvn r0, r0
	cmp r2, r0
	beq _02246DB8
	b _02246DBE
_02246DA0:
	ldr r0, _02246DF4 ; =ov83_02248024
	lsl r1, r1, #1
	ldrh r4, [r0, r1]
	b _02246DBE
_02246DA8:
	ldr r0, _02246DF8 ; =ov83_02248028
	lsl r1, r1, #1
	ldrh r4, [r0, r1]
	b _02246DBE
_02246DB0:
	ldr r0, _02246DFC ; =ov83_0224802C
	lsl r1, r1, #1
	ldrh r4, [r0, r1]
	b _02246DBE
_02246DB8:
	ldr r0, _02246E00 ; =ov83_02248030
	lsl r1, r1, #1
	ldrh r4, [r0, r1]
_02246DBE:
	mov r3, #1
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	add r1, r5, #0
	str r3, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xf
	str r0, [sp, #0x10]
	add r0, r5, #0
	add r1, #0xc0
	add r2, r4, #0
	str r3, [sp, #0x14]
	bl ov83_022447E0
	ldr r0, _02246E04 ; =0x000005F8
	ldr r1, [r5, r0]
	add r0, #8
	add r1, #0x24
	ldrb r1, [r1]
	str r1, [r5, r0]
_02246DEA:
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_02246DF0: .word 0x000005FC
_02246DF4: .word ov83_02248024
_02246DF8: .word ov83_02248028
_02246DFC: .word ov83_0224802C
_02246E00: .word ov83_02248030
_02246E04: .word 0x000005F8
	thumb_func_end ov83_02246D40

	thumb_func_start ov83_02246E08
ov83_02246E08: ; 0x02246E08
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	str r1, [sp, #0x14]
	mov r0, #0x20
	mov r1, #0x6b
	str r2, [sp, #0x18]
	bl GF_CreateVramTransferManager
	bl ov83_022472DC
	bl NNS_G2dInitOamManagerModule
	mov r0, #0
	str r0, [sp]
	mov r1, #0x80
	str r1, [sp, #4]
	str r0, [sp, #8]
	mov r3, #0x20
	str r3, [sp, #0xc]
	mov r2, #0x6b
	str r2, [sp, #0x10]
	add r2, r0, #0
	bl OamManager_Create
	mov r0, #0x28
	add r1, r5, #4
	mov r2, #0x6b
	bl G2dRenderer_Init
	ldr r4, _02247148 ; =ov83_02248178
	str r0, [r5]
	mov r7, #0
	add r6, r5, #0
_02246E4C:
	ldrb r0, [r4]
	add r1, r7, #0
	mov r2, #0x6b
	bl Create2DGfxResObjMan
	mov r1, #0x4b
	lsl r1, r1, #2
	str r0, [r6, r1]
	add r7, r7, #1
	add r4, r4, #1
	add r6, r6, #4
	cmp r7, #4
	blt _02246E4C
	add r0, r5, #0
	bl ov83_022473BC
	mov r0, #0
	str r0, [sp]
	mov r3, #1
	str r3, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc1
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0xf
	bl AddCharResObjFromNarc
	mov r1, #0x4f
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r3, #0
	str r3, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	add r0, #0xc5
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0x37
	bl AddPlttResObjFromNarc
	mov r1, #5
	lsl r1, r1, #6
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc9
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0x11
	mov r3, #1
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x51
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xcd
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0x10
	mov r3, #1
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x52
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0x12
	mov r1, #0x6b
	bl NARC_New
	add r6, r5, #0
	add r7, r0, #0
	mov r4, #4
	add r6, #0x40
_02246EFC:
	mov r0, #0
	mov r1, #1
	bl GetItemIndexMapping
	add r2, r0, #0
	str r4, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc1
	ldr r0, [r5, r0]
	add r1, r7, #0
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	mov r1, #0x4f
	lsl r1, r1, #2
	str r0, [r6, r1]
	mov r0, #0
	mov r1, #2
	bl GetItemIndexMapping
	add r2, r0, #0
	str r4, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	add r0, #0xc5
	ldr r0, [r5, r0]
	mov r1, #0x12
	mov r3, #0
	bl AddPlttResObjFromNarc
	mov r1, #5
	lsl r1, r1, #6
	str r0, [r6, r1]
	add r4, r4, #1
	add r6, #0x10
	cmp r4, #9
	ble _02246EFC
	bl GetItemIconCell
	add r2, r0, #0
	mov r0, #4
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc9
	ldr r0, [r5, r0]
	add r1, r7, #0
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x61
	lsl r1, r1, #2
	str r0, [r5, r1]
	bl GetItemIconAnim
	add r2, r0, #0
	mov r0, #4
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xcd
	ldr r0, [r5, r0]
	add r1, r7, #0
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x62
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #0
	mov r1, #2
	bl GetItemIndexMapping
	add r2, r0, #0
	mov r0, #3
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	add r0, #0xc5
	ldr r0, [r5, r0]
	mov r1, #0x12
	mov r3, #0
	bl AddPlttResObjFromNarc
	mov r1, #0x17
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r7, #0
	bl NARC_Delete
	mov r0, #3
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc1
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0x24
	mov r3, #1
	bl AddCharResObjFromNarc
	mov r1, #0x5b
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #3
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc9
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0x26
	mov r3, #1
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x5d
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #3
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xcd
	ldr r0, [r5, r0]
	mov r1, #0xb8
	mov r2, #0x25
	mov r3, #1
	bl AddCellOrAnimResObjFromNarc
	mov r1, #0x5e
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r5, #0
	bl ov83_02247314
	mov r0, #0x14
	mov r1, #0x6b
	bl NARC_New
	add r7, r0, #0
	bl sub_02074490
	add r2, r0, #0
	mov r0, #0xa
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	add r0, #0xc5
	ldr r0, [r5, r0]
	mov r1, #0x14
	mov r3, #0
	bl AddPlttResObjFromNarc
	mov r1, #0x1e
	lsl r1, r1, #4
	str r0, [r5, r1]
	bl sub_02074498
	add r2, r0, #0
	mov r0, #5
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc9
	ldr r0, [r5, r0]
	add r1, r7, #0
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x79
	lsl r1, r1, #2
	str r0, [r5, r1]
	bl sub_020744A4
	add r2, r0, #0
	mov r0, #5
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xcd
	ldr r0, [r5, r0]
	add r1, r7, #0
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x7a
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r4, #0
	add r6, r5, #0
_022470AE:
	cmp r4, #3
	bne _022470CC
	ldr r0, [sp, #0x18]
	cmp r0, #0
	bne _022470C2
	ldr r0, [sp, #0x14]
	mov r1, #0
	bl Party_GetMonByIndex
	b _022470D4
_022470C2:
	ldr r0, [sp, #0x14]
	add r1, r4, #0
	bl Party_GetMonByIndex
	b _022470D4
_022470CC:
	ldr r0, [sp, #0x14]
	add r1, r4, #0
	bl Party_GetMonByIndex
_022470D4:
	bl Pokemon_GetIconNaix
	add r2, r0, #0
	add r0, r4, #0
	add r0, #0xa
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc1
	ldr r0, [r5, r0]
	add r1, r7, #0
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	mov r1, #0x77
	lsl r1, r1, #2
	str r0, [r6, r1]
	add r4, r4, #1
	add r6, #0x10
	cmp r4, #4
	blt _022470AE
	add r0, r7, #0
	bl NARC_Delete
	mov r7, #0x4f
	mov r6, #0
	add r4, r5, #0
	lsl r7, r7, #2
_02247110:
	ldr r0, [r4, r7]
	bl SpriteTransfer_CreateCharTransferTask
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #0xe
	blt _02247110
	mov r6, #5
	mov r4, #0
	lsl r6, r6, #6
_02247124:
	ldr r0, [r5, r6]
	bl SpriteTransfer_CreateExtPlttTransferTask
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0xb
	blt _02247124
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_02247148: .word ov83_02248178
	thumb_func_end ov83_02246E08

	thumb_func_start ov83_0224714C
ov83_0224714C: ; 0x0224714C
	push {r4, r5, r6, lr}
	sub sp, #0x80
	add r4, r0, #0
	mov r0, #0
	str r3, [sp]
	mvn r0, r0
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r5, #0
	ldr r0, [sp, #0x98]
	str r5, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r6, [r4, r0]
	str r6, [sp, #0x14]
	add r6, r0, #4
	ldr r6, [r4, r6]
	str r6, [sp, #0x18]
	add r6, r0, #0
	add r6, #8
	ldr r6, [r4, r6]
	add r0, #0xc
	str r6, [sp, #0x1c]
	ldr r0, [r4, r0]
	str r0, [sp, #0x20]
	str r5, [sp, #0x24]
	str r5, [sp, #0x28]
	add r0, sp, #0x5c
	bl CreateSpriteResourcesHeader
	ldr r0, [r4]
	add r1, r5, #0
	str r0, [sp, #0x2c]
	add r0, sp, #0x5c
	str r0, [sp, #0x30]
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [sp, #0x34]
	str r1, [sp, #0x38]
	str r1, [sp, #0x3c]
	str r0, [sp, #0x40]
	str r0, [sp, #0x44]
	str r0, [sp, #0x48]
	add r0, sp, #0x2c
	strh r1, [r0, #0x20]
	ldr r0, [sp, #0x94]
	str r0, [sp, #0x50]
	add r0, sp, #0x80
	ldrb r0, [r0, #0x1c]
	cmp r0, #0
	bne _022471BA
	mov r0, #1
	str r0, [sp, #0x54]
	b _022471BE
_022471BA:
	mov r0, #2
	str r0, [sp, #0x54]
_022471BE:
	mov r0, #0x6b
	str r0, [sp, #0x58]
	add r0, sp, #0x80
	ldrb r0, [r0, #0x1c]
	cmp r0, #1
	bne _022471D4
	mov r0, #3
	ldr r1, [sp, #0x38]
	lsl r0, r0, #0x12
	add r0, r1, r0
	str r0, [sp, #0x38]
_022471D4:
	add r0, sp, #0x2c
	bl Sprite_CreateAffine
	mov r1, #1
	add r4, r0, #0
	bl Sprite_SetAnimActiveFlag
	mov r1, #1
	add r0, r4, #0
	lsl r1, r1, #0xc
	bl Sprite_SetAnimSpeed
	ldr r1, [sp, #0x90]
	add r0, r4, #0
	bl Sprite_SetAnimCtrlSeq
	add r0, r4, #0
	add sp, #0x80
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov83_0224714C

	thumb_func_start ov83_022471FC
ov83_022471FC: ; 0x022471FC
	push {r4, r5, r6, lr}
	mov r6, #0x4f
	add r5, r0, #0
	mov r4, #0
	lsl r6, r6, #2
_02247206:
	lsl r0, r4, #4
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl SpriteTransfer_DeleteCharTransferTask
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0xe
	blo _02247206
	mov r6, #5
	mov r4, #0
	lsl r6, r6, #6
_02247220:
	lsl r0, r4, #4
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl SpriteTransfer_DeletePlttTransferTask
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0xb
	blo _02247220
	mov r6, #0x4b
	mov r4, #0
	lsl r6, r6, #2
_0224723A:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl Destroy2DGfxResObjMan
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _0224723A
	ldr r0, [r5]
	bl SpriteList_Delete
	bl OamManager_Free
	bl ObjCharTransfer_Destroy
	bl ObjPlttTransfer_Destroy
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov83_022471FC

	thumb_func_start ov83_02247264
ov83_02247264: ; 0x02247264
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x4b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r6, r2, #0
	bl SpriteResourceCollection_Find
	add r4, r0, #0
	add r0, r6, #0
	mov r1, #1
	bl GetItemIndexMapping
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0x6b
	str r0, [sp, #4]
	add r0, #0xc1
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r2, #0x12
	bl ReplaceCharResObjFromNarc
	add r0, r4, #0
	bl SpriteTransfer_ReplaceCharData
	add sp, #8
	pop {r4, r5, r6, pc}
	thumb_func_end ov83_02247264

	thumb_func_start ov83_022472A0
ov83_022472A0: ; 0x022472A0
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	add r6, r2, #0
	bl SpriteResourceCollection_Find
	add r4, r0, #0
	add r0, r6, #0
	mov r1, #2
	bl GetItemIndexMapping
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0x6b
	str r0, [sp, #4]
	add r0, #0xc5
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r2, #0x12
	bl ReplacePlttResObjFromNarc
	add r0, r4, #0
	bl SpriteTransfer_ReplacePlttData
	add sp, #8
	pop {r4, r5, r6, pc}
	thumb_func_end ov83_022472A0

	thumb_func_start ov83_022472DC
ov83_022472DC: ; 0x022472DC
	push {r4, lr}
	sub sp, #0x10
	ldr r4, _0224730C ; =ov83_0224817C
	add r3, sp, #0
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	ldr r2, _02247310 ; =0x00100010
	mov r1, #0x10
	bl ObjCharTransfer_InitEx
	mov r0, #0x20
	mov r1, #0x6b
	bl ObjPlttTransfer_Init
	bl ObjCharTransfer_ClearBuffers
	bl ObjPlttTransfer_Reset
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_0224730C: .word ov83_0224817C
_02247310: .word 0x00100010
	thumb_func_end ov83_022472DC

	thumb_func_start ov83_02247314
ov83_02247314: ; 0x02247314
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x15
	mov r1, #0x6b
	bl NARC_New
	add r4, r0, #0
	bl sub_0207CA9C
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc1
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	mov r1, #0x53
	lsl r1, r1, #2
	str r0, [r5, r1]
	bl sub_0207CAA0
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	add r0, #0xc5
	ldr r0, [r5, r0]
	mov r1, #0x15
	mov r3, #0
	bl AddPlttResObjFromNarc
	mov r1, #0x15
	lsl r1, r1, #4
	str r0, [r5, r1]
	bl sub_0207CAA4
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc9
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x55
	lsl r1, r1, #2
	str r0, [r5, r1]
	bl sub_0207CAA8
	add r2, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xcd
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x56
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_02247314

	thumb_func_start ov83_022473BC
ov83_022473BC: ; 0x022473BC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #8
	mov r1, #0x6b
	bl NARC_New
	add r4, r0, #0
	mov r0, #2
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc1
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r2, #0x4c
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	mov r1, #0x57
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	add r0, #0xc5
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r2, #0x4b
	mov r3, #0
	bl AddPlttResObjFromOpenNarc
	mov r1, #0x16
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xc9
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r2, #0x4d
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x59
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	add r0, #0xcd
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r2, #0x4e
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x5a
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_022473BC

	thumb_func_start ov83_02247454
ov83_02247454: ; 0x02247454
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	add r6, r1, #0
	mov r0, #0x6b
	mov r1, #8
	add r7, r2, #0
	str r3, [sp, #0x10]
	bl Heap_Alloc
	add r4, r0, #0
	mov r1, #0
	strb r1, [r4]
	strb r1, [r4, #1]
	strb r1, [r4, #2]
	strb r1, [r4, #3]
	strb r1, [r4, #4]
	strb r1, [r4, #5]
	strb r1, [r4, #6]
	strb r1, [r4, #7]
	add r0, sp, #0x28
	mov r2, #0x14
	ldrsh r2, [r0, r2]
	ldr r3, [sp, #0x10]
	strh r2, [r4]
	mov r2, #0x18
	ldrsh r0, [r0, r2]
	add r2, r7, #0
	strh r0, [r4, #2]
	ldr r0, [sp, #0x38]
	str r0, [sp]
	ldr r0, [sp, #0x44]
	str r1, [sp, #4]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r0, r5, #0
	add r1, r6, #0
	bl ov83_0224714C
	str r0, [r4, #4]
	add r1, sp, #0x28
	mov r0, #0x14
	ldrsh r0, [r1, r0]
	lsl r0, r0, #0xc
	str r0, [sp, #0x14]
	mov r0, #0x18
	ldrsh r0, [r1, r0]
	add r1, sp, #0x14
	lsl r0, r0, #0xc
	str r0, [sp, #0x18]
	ldr r0, [r4, #4]
	bl Sprite_SetMatrix
	add r0, r4, #0
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov83_02247454

	thumb_func_start ov83_022474C4
ov83_022474C4: ; 0x022474C4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	add r6, r1, #0
	mov r0, #0x6b
	mov r1, #8
	add r7, r2, #0
	str r3, [sp, #0x10]
	bl Heap_Alloc
	add r4, r0, #0
	mov r1, #0
	strb r1, [r4]
	strb r1, [r4, #1]
	strb r1, [r4, #2]
	strb r1, [r4, #3]
	strb r1, [r4, #4]
	strb r1, [r4, #5]
	strb r1, [r4, #6]
	strb r1, [r4, #7]
	add r0, sp, #0x28
	mov r2, #0x14
	ldrsh r2, [r0, r2]
	ldr r3, [sp, #0x10]
	strh r2, [r4]
	mov r2, #0x18
	ldrsh r0, [r0, r2]
	add r2, r7, #0
	strh r0, [r4, #2]
	ldr r0, [sp, #0x38]
	str r0, [sp]
	str r1, [sp, #4]
	ldr r0, [sp, #0x44]
	add r1, r6, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	add r0, r5, #0
	bl ov83_0224714C
	str r0, [r4, #4]
	add r1, sp, #0x28
	mov r0, #0x14
	ldrsh r0, [r1, r0]
	lsl r0, r0, #0xc
	str r0, [sp, #0x14]
	mov r0, #0x18
	ldrsh r1, [r1, r0]
	lsl r0, r0, #0xf
	lsl r1, r1, #0xc
	add r0, r1, r0
	str r0, [sp, #0x18]
	ldr r0, [r4, #4]
	add r1, sp, #0x14
	bl Sprite_SetMatrix
	add r0, r4, #0
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov83_022474C4

	thumb_func_start ov83_0224753C
ov83_0224753C: ; 0x0224753C
	push {r4, lr}
	add r4, r0, #0
	bne _0224754A
	bl GF_AssertFail
	mov r0, #0
	pop {r4, pc}
_0224754A:
	ldr r0, [r4, #4]
	bl Sprite_Delete
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_0224753C

	thumb_func_start ov83_0224755C
ov83_0224755C: ; 0x0224755C
	ldr r3, _02247564 ; =Sprite_SetDrawFlag
	ldr r0, [r0, #4]
	bx r3
	nop
_02247564: .word Sprite_SetDrawFlag
	thumb_func_end ov83_0224755C

	thumb_func_start ov83_02247568
ov83_02247568: ; 0x02247568
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [r5, #4]
	add r4, r1, #0
	add r6, r2, #0
	bl Sprite_GetMatrixPtr
	add r3, r0, #0
	add r2, sp, #0
	ldmia r3!, {r0, r1}
	add r7, r2, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	add r1, r7, #0
	str r0, [r2]
	lsl r0, r4, #0xc
	str r0, [sp]
	lsl r0, r6, #0xc
	str r0, [sp, #4]
	ldr r0, [r5, #4]
	bl Sprite_SetMatrix
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov83_02247568

	thumb_func_start ov83_0224759C
ov83_0224759C: ; 0x0224759C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [r5, #4]
	add r4, r1, #0
	add r6, r2, #0
	bl Sprite_GetMatrixPtr
	add r3, r0, #0
	add r2, sp, #0
	ldmia r3!, {r0, r1}
	add r7, r2, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	lsl r1, r6, #0xc
	str r0, [r2]
	lsl r0, r4, #0xc
	str r0, [sp]
	mov r0, #3
	lsl r0, r0, #0x12
	add r0, r1, r0
	str r0, [sp, #4]
	ldr r0, [r5, #4]
	add r1, r7, #0
	bl Sprite_SetMatrix
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov83_0224759C

	thumb_func_start ov83_022475D4
ov83_022475D4: ; 0x022475D4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #4]
	add r4, r1, #0
	mov r1, #0
	bl Sprite_SetAnimationFrame
	ldr r0, [r5, #4]
	add r1, r4, #0
	bl Sprite_SetAnimCtrlSeq
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_022475D4

	thumb_func_start ov83_022475EC
ov83_022475EC: ; 0x022475EC
	push {r4, lr}
	add r4, r0, #0
	add r0, r1, #0
	bl Pokemon_GetIconPalette
	add r1, r0, #0
	ldr r0, [r4, #4]
	bl Sprite_SetPalOffsetRespectVramOffset
	pop {r4, pc}
	thumb_func_end ov83_022475EC

	thumb_func_start ov83_02247600
ov83_02247600: ; 0x02247600
	ldr r3, _02247608 ; =ov80_0222A3D4
	ldr r0, [r0, #4]
	bx r3
	nop
_02247608: .word ov80_0222A3D4
	thumb_func_end ov83_02247600

	thumb_func_start ov83_0224760C
ov83_0224760C: ; 0x0224760C
	push {r4, lr}
	add r4, r0, #0
	add r3, r1, #0
	mov r1, #0
	mov r2, #2
	ldrsh r1, [r4, r1]
	ldrsh r2, [r4, r2]
	ldr r0, [r4, #4]
	bl ov80_0222A400
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_0224760C

	thumb_func_start ov83_02247624
ov83_02247624: ; 0x02247624
	ldr r3, _0224762C ; =Sprite_IsAnimated
	ldr r0, [r0, #4]
	bx r3
	nop
_0224762C: .word Sprite_IsAnimated
	thumb_func_end ov83_02247624

	thumb_func_start ov83_02247630
ov83_02247630: ; 0x02247630
	push {r4, r5, r6, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r6, r2, #0
	mov r1, #0xb
	bl ov83_022475D4
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov83_02247568
	add r0, r5, #0
	mov r1, #1
	bl ov83_0224755C
	ldr r0, _02247660 ; =0x000005E3
	bl PlaySE
	ldr r0, _02247664 ; =0x00000655
	bl PlaySE
	pop {r4, r5, r6, pc}
	nop
_02247660: .word 0x000005E3
_02247664: .word 0x00000655
	thumb_func_end ov83_02247630

	thumb_func_start ov83_02247668
ov83_02247668: ; 0x02247668
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x40
	add r7, r3, #0
	add r6, r2, #0
	ldr r3, _02247738 ; =ov83_0224818C
	add r2, sp, #0x20
	add r5, r0, #0
	str r1, [sp, #0x14]
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	mov r1, #0x32
	mov r0, #0x6b
	lsl r1, r1, #6
	bl Heap_AllocAtEnd
	add r4, r0, #0
	cmp r6, #0
	beq _022476C0
	ldr r1, [sp, #0x14]
	add r0, sp, #0x30
	mov r2, #2
	mov r3, #0
	bl GetBoxmonSpriteCharAndPlttNarcIds
	str r4, [sp]
	str r7, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	str r6, [sp, #0x10]
	add r1, sp, #0x1c
	ldrh r0, [r1, #0x14]
	ldrh r1, [r1, #0x16]
	mov r2, #0x6b
	add r3, sp, #0x20
	bl sub_02014510
	add r0, sp, #0x1c
	ldrh r7, [r0, #0x14]
	ldrh r6, [r0, #0x18]
	b _022476EA
_022476C0:
	mov r0, #0x6b
	str r0, [sp]
	mov r0, #0xb8
	mov r1, #0x27
	mov r2, #1
	add r3, sp, #0x1c
	bl GfGfxLoader_GetCharData
	add r6, r0, #0
	ldr r0, [sp, #0x1c]
	mov r2, #0x32
	ldr r0, [r0, #0x14]
	add r1, r4, #0
	lsl r2, r2, #6
	bl MIi_CpuCopy32
	add r0, r6, #0
	bl Heap_Free
	mov r7, #0xb8
	mov r6, #0x3d
_022476EA:
	ldr r0, [r5, #4]
	bl Sprite_GetImageProxy
	mov r1, #2
	bl NNS_G2dGetImageLocation
	mov r1, #0x32
	str r0, [sp, #0x18]
	add r0, r4, #0
	lsl r1, r1, #6
	bl DC_FlushRange
	mov r2, #0x32
	ldr r1, [sp, #0x18]
	add r0, r4, #0
	lsl r2, r2, #6
	bl GXS_LoadOBJ
	ldr r0, [r5, #4]
	bl Sprite_GetPaletteProxy
	mov r1, #2
	bl NNS_G2dGetImagePaletteLocation
	add r3, r0, #0
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0x6b
	str r0, [sp, #4]
	add r0, r7, #0
	add r1, r6, #0
	mov r2, #5
	bl GfGfxLoader_GXLoadPal
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x40
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02247738: .word ov83_0224818C
	thumb_func_end ov83_02247668

	thumb_func_start ov83_0224773C
ov83_0224773C: ; 0x0224773C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	cmp r2, #1
	bne _0224774A
	mov r7, #1
	b _0224774C
_0224774A:
	mov r7, #0
_0224774C:
	mov r4, #0
	cmp r6, #0
	bls _02247764
_02247752:
	ldr r0, [r5]
	add r1, r7, #0
	ldr r0, [r0, #4]
	bl Sprite_SetOamMode
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, r6
	blo _02247752
_02247764:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov83_0224773C

	thumb_func_start ov83_02247768
ov83_02247768: ; 0x02247768
	add r0, r1, #0
	bx lr
	thumb_func_end ov83_02247768

	thumb_func_start ov83_0224776C
ov83_0224776C: ; 0x0224776C
	cmp r1, r0
	blo _02247776
	sub r0, r1, r0
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
_02247776:
	add r0, r1, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov83_0224776C

	thumb_func_start ov83_0224777C
ov83_0224777C: ; 0x0224777C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r4, r2, #0
	bl Save_Frontier_GetStatic
	add r6, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl sub_0205C174
	add r7, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl sub_0205C174
	bl sub_0205C268
	add r2, r0, #0
	add r0, r6, #0
	add r1, r7, #0
	bl FrontierSave_GetStat
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov83_0224777C

	thumb_func_start ov83_022477B0
ov83_022477B0: ; 0x022477B0
	push {r3, lr}
	mov r2, #0
	mvn r2, r2
	cmp r0, r2
	beq _022477C0
	add r0, r1, #0
	bl PlaySE
_022477C0:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov83_022477B0

	thumb_func_start ov83_022477C4
ov83_022477C4: ; 0x022477C4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl sub_0203769C
	mov r1, #1
	eor r0, r1
	bl sub_02034818
	add r2, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl BufferPlayersName
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_022477C4

	thumb_func_start ov83_022477E4
ov83_022477E4: ; 0x022477E4
	mov r1, #0
	str r1, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov83_022477E4

	thumb_func_start ov83_022477EC
ov83_022477EC: ; 0x022477EC
	push {r4, r5}
	lsl r5, r0, #2
	add r0, r1, #1
	add r4, r0, #0
	mov r0, #0xf
	add r1, r0, #0
	lsl r1, r5
	sub r0, #0x10
	ldr r3, [r2]
	eor r0, r1
	lsl r4, r5
	and r0, r3
	orr r0, r4
	str r0, [r2]
	pop {r4, r5}
	bx lr
	thumb_func_end ov83_022477EC

	thumb_func_start ov83_0224780C
ov83_0224780C: ; 0x0224780C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r4, #0
	mov r6, #0xf
_02247814:
	ldr r1, [r5]
	lsl r0, r4, #2
	lsr r1, r0
	add r0, r1, #0
	and r0, r6
	lsl r0, r0, #0x10
	lsr r1, r0, #0x10
	beq _02247832
	sub r1, r1, #1
	lsl r0, r4, #0x18
	lsl r1, r1, #0x18
	lsr r0, r0, #0x18
	lsr r1, r1, #0x18
	bl ToggleBgLayer
_02247832:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #7
	bls _02247814
	add r0, r5, #0
	bl ov83_022477E4
	pop {r4, r5, r6, pc}
	thumb_func_end ov83_0224780C

	thumb_func_start ov83_02247844
ov83_02247844: ; 0x02247844
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x6b
	bl YesNoPrompt_Create
	str r0, [r4]
	mov r0, #0
	str r0, [r4, #4]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_02247844

	thumb_func_start ov83_02247858
ov83_02247858: ; 0x02247858
	ldr r3, _02247860 ; =YesNoPrompt_Destroy
	ldr r0, [r0]
	bx r3
	nop
_02247860: .word YesNoPrompt_Destroy
	thumb_func_end ov83_02247858

	thumb_func_start ov83_02247864
ov83_02247864: ; 0x02247864
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r4, r0, #0
	add r5, r1, #0
	add r0, sp, #0
	add r0, #2
	add r1, sp, #0
	str r5, [r4, #8]
	bl ov83_02247988
	mov r0, #0
	str r5, [sp, #4]
	str r0, [sp, #8]
	add r2, sp, #0
	ldrh r1, [r2, #2]
	str r1, [sp, #0xc]
	mov r1, #0xb
	str r1, [sp, #0x10]
	mov r1, #0x19
	strb r1, [r2, #0x14]
	mov r1, #0xa
	strb r1, [r2, #0x15]
	ldrb r3, [r2, #0x16]
	mov r1, #0xf
	bic r3, r1
	strb r3, [r2, #0x16]
	ldrb r3, [r2, #0x16]
	mov r1, #0xf0
	bic r3, r1
	strb r3, [r2, #0x16]
	strb r0, [r2, #0x17]
	ldr r0, [r4]
	add r1, sp, #4
	bl YesNoPrompt_InitFromTemplate
	mov r0, #1
	str r0, [r4, #4]
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_02247864

	thumb_func_start ov83_022478B4
ov83_022478B4: ; 0x022478B4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #4]
	cmp r0, #0
	beq _022478D0
	ldr r0, [r4]
	bl YesNoPrompt_Reset
	ldr r0, [r4, #8]
	mov r1, #0
	bl BgCommitTilemapBufferToVram
	mov r0, #0
	str r0, [r4, #4]
_022478D0:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_022478B4

	thumb_func_start ov83_022478D4
ov83_022478D4: ; 0x022478D4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	str r0, [sp]
	add r5, r1, #0
	ldr r0, _02247914 ; =ov83_0224819C
	lsl r1, r2, #3
	ldr r0, [r0, r1]
	mov r4, #0
	str r0, [sp, #4]
	ldr r0, _02247918 ; =ov83_0224819C + 4
	ldr r7, [r0, r1]
	cmp r7, #0
	bls _02247910
_022478EE:
	ldr r2, [sp, #4]
	lsl r6, r4, #4
	lsl r3, r4, #3
	ldr r0, [sp]
	add r1, r5, r6
	add r2, r2, r3
	bl AddWindow
	add r0, r5, r6
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, r7
	blo _022478EE
_02247910:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02247914: .word ov83_0224819C
_02247918: .word ov83_0224819C + 4
	thumb_func_end ov83_022478D4

	thumb_func_start ov83_0224791C
ov83_0224791C: ; 0x0224791C
	push {r4, r5, r6, lr}
	add r6, r0, #0
	ldr r0, _02247940 ; =ov83_0224819C + 4
	lsl r1, r1, #3
	ldr r5, [r0, r1]
	mov r4, #0
	cmp r5, #0
	bls _0224793E
_0224792C:
	lsl r0, r4, #4
	add r0, r6, r0
	bl RemoveWindow
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, r5
	blo _0224792C
_0224793E:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02247940: .word ov83_0224819C + 4
	thumb_func_end ov83_0224791C

	thumb_func_start ov83_02247944
ov83_02247944: ; 0x02247944
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r1, #0
	add r4, r0, #0
	bl GetWindowBgId
	add r1, r0, #0
	lsl r0, r5, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x6b
	str r0, [sp, #4]
	ldr r0, [r4]
	ldr r2, _02247984 ; =0x000003D9
	mov r3, #0xa
	bl LoadUserFrameGfx2
	add r0, r4, #0
	mov r1, #0xf
	bl FillWindowPixelBuffer
	ldr r2, _02247984 ; =0x000003D9
	add r0, r4, #0
	mov r1, #1
	mov r3, #0xa
	bl DrawFrameAndWindow2
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02247984: .word 0x000003D9
	thumb_func_end ov83_02247944

	thumb_func_start ov83_02247988
ov83_02247988: ; 0x02247988
	mov r2, #0xf0
	strh r2, [r1]
	ldr r1, _02247994 ; =0x000002E9
	strh r1, [r0]
	bx lr
	nop
_02247994: .word 0x000002E9
	thumb_func_end ov83_02247988

	thumb_func_start ov83_02247998
ov83_02247998: ; 0x02247998
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r6, r0, #0
	ldr r0, [sp, #0x30]
	add r7, r1, #0
	add r5, r2, #0
	add r4, r3, #0
	cmp r0, #1
	bne _022479B6
	ldr r0, [sp, #0x28]
	mov r2, #0
	bl FontID_String_GetWidth
	sub r5, r5, r0
	b _022479C6
_022479B6:
	cmp r0, #2
	bne _022479C6
	ldr r0, [sp, #0x28]
	mov r2, #0
	bl FontID_String_GetWidth
	lsr r0, r0, #1
	sub r5, r5, r0
_022479C6:
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
	thumb_func_end ov83_02247998

	thumb_func_start ov83_022479E4
ov83_022479E4: ; 0x022479E4
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
	bl ov83_02247998
	add r0, r4, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov83_022479E4

	thumb_func_start ov83_02247A18
ov83_02247A18: ; 0x02247A18
	ldr r3, _02247A1C ; =GridInputHandler_Free
	bx r3
	.balign 4, 0
_02247A1C: .word GridInputHandler_Free
	thumb_func_end ov83_02247A18

	thumb_func_start ov83_02247A20
ov83_02247A20: ; 0x02247A20
	bx lr
	.balign 4, 0
	thumb_func_end ov83_02247A20

	thumb_func_start ov83_02247A24
ov83_02247A24: ; 0x02247A24
	push {lr}
	sub sp, #0xc
	add r3, r0, #0
	cmp r2, #3
	bne _02247A4A
	mov r0, #1
	str r0, [sp]
	lsl r0, r1, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	ldr r0, _02247A68 ; =ov83_02248530
	ldr r1, _02247A6C ; =ov83_022485A8
	ldr r2, _02247A70 ; =ov83_02248500
	bl GridInputHandler_Create
	add sp, #0xc
	pop {pc}
_02247A4A:
	mov r0, #1
	str r0, [sp]
	lsl r0, r1, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	ldr r0, _02247A74 ; =ov83_02248558
	ldr r1, _02247A78 ; =ov83_022485E8
	ldr r2, _02247A70 ; =ov83_02248500
	bl GridInputHandler_Create
	add sp, #0xc
	pop {pc}
	nop
_02247A68: .word ov83_02248530
_02247A6C: .word ov83_022485A8
_02247A70: .word ov83_02248500
_02247A74: .word ov83_02248558
_02247A78: .word ov83_022485E8
	thumb_func_end ov83_02247A24

	thumb_func_start ov83_02247A7C
ov83_02247A7C: ; 0x02247A7C
	push {lr}
	sub sp, #0xc
	add r3, r0, #0
	cmp r2, #3
	bne _02247AA2
	mov r0, #1
	str r0, [sp]
	lsl r0, r1, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	ldr r0, _02247AC0 ; =ov83_02248530
	ldr r1, _02247AC4 ; =ov83_022485A8
	ldr r2, _02247AC8 ; =ov83_02248510
	bl GridInputHandler_Create
	add sp, #0xc
	pop {pc}
_02247AA2:
	mov r0, #1
	str r0, [sp]
	lsl r0, r1, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	ldr r0, _02247ACC ; =ov83_02248558
	ldr r1, _02247AD0 ; =ov83_022485E8
	ldr r2, _02247AC8 ; =ov83_02248510
	bl GridInputHandler_Create
	add sp, #0xc
	pop {pc}
	nop
_02247AC0: .word ov83_02248530
_02247AC4: .word ov83_022485A8
_02247AC8: .word ov83_02248510
_02247ACC: .word ov83_02248558
_02247AD0: .word ov83_022485E8
	thumb_func_end ov83_02247A7C

	thumb_func_start ov83_02247AD4
ov83_02247AD4: ; 0x02247AD4
	push {r3, lr}
	bl GridInputHandler_HandleInput_NoHold
	add r1, r0, #4
	cmp r1, #3
	bhi _02247AF6
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02247AEC: ; jump table
	.short _02247AF4 - _02247AEC - 2 ; case 0
	.short _02247AF4 - _02247AEC - 2 ; case 1
	.short _02247AF4 - _02247AEC - 2 ; case 2
	.short _02247AF4 - _02247AEC - 2 ; case 3
_02247AF4:
	pop {r3, pc}
_02247AF6:
	lsl r1, r0, #2
	ldr r0, _02247B00 ; =ov83_02248544
	ldr r0, [r0, r1]
	pop {r3, pc}
	nop
_02247B00: .word ov83_02248544
	thumb_func_end ov83_02247AD4

	thumb_func_start ov83_02247B04
ov83_02247B04: ; 0x02247B04
	push {r4, lr}
	add r4, r0, #0
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #0
	add r3, r2, #0
	bl GridInputHandler_SetNextLastUnk0FInputs
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_02247B04

	thumb_func_start ov83_02247B1C
ov83_02247B1C: ; 0x02247B1C
	ldr r3, _02247B2C ; =ov83_02248544
	lsl r1, r1, #2
	lsl r2, r2, #2
	ldr r1, [r3, r1]
	ldr r2, [r3, r2]
	ldr r3, _02247B30 ; =ov83_02242AB4
	bx r3
	nop
_02247B2C: .word ov83_02248544
_02247B30: .word ov83_02242AB4
	thumb_func_end ov83_02247B1C

	thumb_func_start ov83_02247B34
ov83_02247B34: ; 0x02247B34
	ldr r3, _02247B44 ; =ov83_02248544
	lsl r1, r1, #2
	lsl r2, r2, #2
	ldr r1, [r3, r1]
	ldr r2, [r3, r2]
	ldr r3, _02247B48 ; =ov83_02242AB4
	bx r3
	nop
_02247B44: .word ov83_02248544
_02247B48: .word ov83_02242AB4
	thumb_func_end ov83_02247B34

	thumb_func_start ov83_02247B4C
ov83_02247B4C: ; 0x02247B4C
	ldr r3, _02247B5C ; =ov83_02248544
	lsl r1, r1, #2
	lsl r2, r2, #2
	ldr r1, [r3, r1]
	ldr r2, [r3, r2]
	ldr r3, _02247B60 ; =ov83_022469D8
	bx r3
	nop
_02247B5C: .word ov83_02248544
_02247B60: .word ov83_022469D8
	thumb_func_end ov83_02247B4C

	thumb_func_start ov83_02247B64
ov83_02247B64: ; 0x02247B64
	ldr r3, _02247B74 ; =ov83_02248544
	lsl r1, r1, #2
	lsl r2, r2, #2
	ldr r1, [r3, r1]
	ldr r2, [r3, r2]
	ldr r3, _02247B78 ; =ov83_022469D8
	bx r3
	nop
_02247B74: .word ov83_02248544
_02247B78: .word ov83_022469D8
	thumb_func_end ov83_02247B64

	thumb_func_start ov83_02247B7C
ov83_02247B7C: ; 0x02247B7C
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	ldr r0, _02247BB8 ; =ov83_022485C8
	ldr r1, _02247BBC ; =ov83_02248610
	ldr r2, _02247BC0 ; =ov83_02248520
	add r3, r4, #0
	bl GridInputHandler_Create
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #0x40
	mov r2, #0x34
	mov r3, #3
	bl ov83_02242AC0
	add r0, r4, #0
	mov r1, #0
	bl ov83_02242AE0
	add r0, r5, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_02247BB8: .word ov83_022485C8
_02247BBC: .word ov83_02248610
_02247BC0: .word ov83_02248520
	thumb_func_end ov83_02247B7C

	thumb_func_start ov83_02247BC4
ov83_02247BC4: ; 0x02247BC4
	push {r4, lr}
	add r4, r0, #0
	bl GridInputHandler_HandleInput_NoHold
	add r1, r0, #4
	cmp r1, #3
	bhi _02247C28
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02247BDE: ; jump table
	.short _02247BE6 - _02247BDE - 2 ; case 0
	.short _02247BE6 - _02247BDE - 2 ; case 1
	.short _02247BE6 - _02247BDE - 2 ; case 2
	.short _02247BE8 - _02247BDE - 2 ; case 3
_02247BE6:
	pop {r4, pc}
_02247BE8:
	ldr r0, _02247C4C ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _02247C08
	add r0, r4, #0
	bl GridInputHandler_GetNextInput
	cmp r0, #0
	beq _02247C04
	cmp r0, #2
	beq _02247C04
	cmp r0, #4
	bne _02247C08
_02247C04:
	mov r0, #6
	pop {r4, pc}
_02247C08:
	ldr r0, _02247C4C ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x10
	tst r0, r1
	beq _02247C30
	add r0, r4, #0
	bl GridInputHandler_GetNextInput
	cmp r0, #1
	beq _02247C24
	cmp r0, #3
	beq _02247C24
	cmp r0, #5
	bne _02247C30
_02247C24:
	mov r0, #7
	pop {r4, pc}
_02247C28:
	lsl r1, r0, #2
	ldr r0, _02247C50 ; =ov83_0224858C
	ldr r0, [r0, r1]
	pop {r4, pc}
_02247C30:
	ldr r0, _02247C54 ; =ov83_022484F4
	bl TouchscreenHitbox_FindRectAtTouchNew
	cmp r0, #0
	bne _02247C3E
	mov r0, #6
	pop {r4, pc}
_02247C3E:
	cmp r0, #1
	bne _02247C46
	mov r0, #7
	pop {r4, pc}
_02247C46:
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	.balign 4, 0
_02247C4C: .word gSystem
_02247C50: .word ov83_0224858C
_02247C54: .word ov83_022484F4
	thumb_func_end ov83_02247BC4

	thumb_func_start ov83_02247C58
ov83_02247C58: ; 0x02247C58
	push {r4, r5, r6, lr}
	add r4, r1, #0
	ldr r1, _02247C7C ; =ov83_02248610
	lsl r3, r4, #3
	ldr r2, _02247C80 ; =ov83_02248611
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r3, _02247C84 ; =ov83_02248570
	lsl r6, r4, #2
	ldr r3, [r3, r6]
	add r5, r0, #0
	bl ov83_02242AC0
	add r0, r5, #0
	add r1, r4, #0
	bl ov83_02242AE0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02247C7C: .word ov83_02248610
_02247C80: .word ov83_02248611
_02247C84: .word ov83_02248570
	thumb_func_end ov83_02247C58

	thumb_func_start ov83_02247C88
ov83_02247C88: ; 0x02247C88
	push {r4, r5, r6, lr}
	add r4, r1, #0
	ldr r1, _02247CAC ; =ov83_02248610
	lsl r3, r4, #3
	ldr r2, _02247CB0 ; =ov83_02248611
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r3, _02247CB4 ; =ov83_02248570
	lsl r6, r4, #2
	ldr r3, [r3, r6]
	add r5, r0, #0
	bl ov83_02242AC0
	add r0, r5, #0
	add r1, r4, #0
	bl ov83_02242AE0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02247CAC: .word ov83_02248610
_02247CB0: .word ov83_02248611
_02247CB4: .word ov83_02248570
	thumb_func_end ov83_02247C88

	thumb_func_start ov83_02247CB8
ov83_02247CB8: ; 0x02247CB8
	ldr r3, _02247CC0 ; =TouchscreenListMenuSpawner_Create
	mov r0, #0x6b
	bx r3
	nop
_02247CC0: .word TouchscreenListMenuSpawner_Create
	thumb_func_end ov83_02247CB8

	thumb_func_start ov83_02247CC4
ov83_02247CC4: ; 0x02247CC4
	ldr r3, _02247CC8 ; =TouchscreenListMenuSpawner_Destroy
	bx r3
	.balign 4, 0
_02247CC8: .word TouchscreenListMenuSpawner_Destroy
	thumb_func_end ov83_02247CC4

	thumb_func_start ov83_02247CCC
ov83_02247CCC: ; 0x02247CCC
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r2, #0
	str r3, [sp]
	add r2, sp, #8
	ldrb r2, [r2, #0x10]
	add r3, r4, #0
	str r2, [sp, #4]
	mov r2, #0
	str r2, [sp, #8]
	bl TouchscreenListMenu_Create
	add sp, #0xc
	pop {r3, r4, pc}
	thumb_func_end ov83_02247CCC

	thumb_func_start ov83_02247CE8
ov83_02247CE8: ; 0x02247CE8
	ldr r3, _02247CEC ; =TouchscreenListMenu_Destroy
	bx r3
	.balign 4, 0
_02247CEC: .word TouchscreenListMenu_Destroy
	thumb_func_end ov83_02247CE8

	thumb_func_start ov83_02247CF0
ov83_02247CF0: ; 0x02247CF0
	push {r3, lr}
	ldr r0, _02247D08 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _02247D00
	mov r0, #1
	pop {r3, pc}
_02247D00:
	bl System_GetTouchNew
	pop {r3, pc}
	nop
_02247D08: .word gSystem
	thumb_func_end ov83_02247CF0

	.rodata

_02247D0C:
	.byte 0x22, 0x00, 0x23, 0x00
	.byte 0x24, 0x00

ov83_02247D12: ; 0x02247D12
	.byte 0x08, 0x00, 0x08, 0x00, 0x20, 0x00

ov83_02247D18: ; 0x02247D18
	.byte 0x0A, 0x00, 0x08, 0x00, 0x0C, 0x00

ov83_02247D1E: ; 0x02247D1E
	.byte 0x0E, 0x00
	.byte 0x0F, 0x00, 0x12, 0x00

ov83_02247D24: ; 0x02247D24
	.byte 0x0C, 0x00, 0x0C, 0x00, 0x1B, 0x00, 0x03, 0x00, 0x00, 0x0B, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247D38: ; 0x02247D38
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247D48: ; 0x02247D48
	.byte 0x00, 0x00, 0x64, 0x00, 0x64, 0x00

ov83_02247D4E: ; 0x02247D4E
	.byte 0x00, 0x00
	.byte 0x64, 0x00, 0x96, 0x00, 0x00, 0x00, 0x32, 0x00, 0x32, 0x00

ov83_02247D5A: ; 0x02247D5A
	.byte 0x00, 0x00, 0x2A, 0x00, 0x2B, 0x00
	.byte 0x00, 0x00, 0x44, 0x00, 0x45, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247D6C: ; 0x02247D6C
	.byte 0x09, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00
	.byte 0xFE, 0xFF, 0xFF, 0xFF

ov83_02247D84: ; 0x02247D84
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1D, 0x01, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247DA0: ; 0x02247DA0
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1F, 0x04, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247DBC: ; 0x02247DBC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x06
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247DD8: ; 0x02247DD8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1C, 0x06, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov83_02247DF4: ; 0x02247DF4
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1D, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247E10: ; 0x02247E10
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1C, 0x02, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247E2C: ; 0x02247E2C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x00
	.byte 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_02247E48: ; 0x02247E48
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x04, 0x00, 0x02, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov83_02247E64: ; 0x02247E64
	.byte 0x00, 0x04, 0x10, 0x05, 0x10, 0x04, 0x10, 0x05, 0x00, 0x09, 0x10, 0x05
	.byte 0x10, 0x09, 0x10, 0x05, 0x00, 0x0E, 0x10, 0x05, 0x10, 0x0E, 0x10, 0x05, 0x00, 0x14, 0x04, 0x04
	.byte 0x06, 0x14, 0x04, 0x04, 0x19, 0x14, 0x07, 0x04

ov83_02247E88: ; 0x02247E88
	.byte 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00

ov83_02247EB0: ; 0x02247EB0
	.byte 0x01, 0x00, 0x00, 0x00, 0x2C, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x2D, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2E, 0x00, 0x00, 0x00
	.byte 0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x2F, 0x00, 0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF

ov83_02247EE0: ; 0x02247EE0
	.byte 0xDD, 0x00, 0xD9, 0x00, 0x0F, 0x01, 0xFD, 0x00, 0x15, 0x01, 0x0D, 0x01, 0x1E, 0x01, 0x28, 0x01
	.byte 0x10, 0x01, 0x11, 0x01, 0xEC, 0x00, 0x02, 0x01, 0xD6, 0x00, 0xE6, 0x00, 0x13, 0x01, 0xEA, 0x00
	.byte 0xD5, 0x00, 0xE8, 0x00, 0x09, 0x01, 0x14, 0x01, 0xDC, 0x00, 0x29, 0x01, 0x1F, 0x01, 0x0A, 0x01
	.byte 0x0B, 0x01, 0x0C, 0x01, 0x0E, 0x01

ov83_02247F16: ; 0x02247F16
	.byte 0x0A, 0x00, 0x0F, 0x00, 0x05, 0x00, 0x0F, 0x00, 0x0A, 0x00
	.byte 0x0A, 0x00, 0x0A, 0x00, 0x0A, 0x00, 0x0A, 0x00, 0x0A, 0x00, 0x0F, 0x00, 0x0F, 0x00, 0x05, 0x00
	.byte 0x0F, 0x00, 0x0A, 0x00, 0x14, 0x00, 0x14, 0x00, 0x14, 0x00, 0x14, 0x00, 0x14, 0x00, 0x14, 0x00
	.byte 0x14, 0x00, 0x14, 0x00, 0x14, 0x00, 0x14, 0x00, 0x14, 0x00, 0x14, 0x00

ov83_02247F4C: ; 0x02247F4C
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0x13, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x15, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x17, 0x00, 0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF

ov83_02247F88: ; 0x02247F88
	.byte 0x95, 0x00, 0x96, 0x00, 0x97, 0x00, 0x98, 0x00
	.byte 0x99, 0x00, 0x9C, 0x00, 0x9D, 0x00, 0x9E, 0x00, 0xC9, 0x00, 0xCA, 0x00, 0xCB, 0x00, 0xCC, 0x00
	.byte 0xCD, 0x00, 0xCE, 0x00, 0xCF, 0x00, 0xB8, 0x00, 0xB9, 0x00, 0xBA, 0x00, 0xBB, 0x00, 0xBC, 0x00
	.byte 0xBD, 0x00, 0xBE, 0x00, 0xBF, 0x00, 0xC0, 0x00, 0xC1, 0x00, 0xC2, 0x00, 0xC3, 0x00, 0xC4, 0x00
	.byte 0xC5, 0x00, 0xC6, 0x00, 0xC7, 0x00, 0xC8, 0x00

ov83_02247FC8: ; 0x02247FC8
	.byte 0x02, 0x00, 0x02, 0x00, 0x02, 0x00, 0x02, 0x00
	.byte 0x02, 0x00, 0x02, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00
	.byte 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00
	.byte 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00
	.byte 0x05, 0x00, 0x05, 0x00, 0x05, 0x00, 0x05, 0x00

ov83_02248008: ; 0x02248008
	.byte 0x12, 0x0E, 0x0B, 0x08, 0x05, 0x02, 0x00, 0x00

ov83_02248010: ; 0x02248010
	.byte 0x12, 0x0E, 0x0B, 0x08, 0x05, 0x02, 0x00, 0x00

ov83_02248018: ; 0x02248018
	.byte 0x03, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov83_02248024: ; 0x02248024
	.byte 0x25, 0x00, 0x25, 0x00

ov83_02248028: ; 0x02248028
	.byte 0x26, 0x00, 0x26, 0x00

ov83_0224802C: ; 0x0224802C
	.byte 0x27, 0x00, 0x28, 0x00

ov83_02248030: ; 0x02248030
	.byte 0x29, 0x00, 0x29, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00
	.byte 0x0F, 0x00, 0x00, 0x00

ov83_02248044: ; 0x02248044
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov83_02248054: ; 0x02248054
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x5F, 0x00, 0x5F, 0x00, 0x00, 0x00

ov83_02248068: ; 0x02248068
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov83_02248084: ; 0x02248084
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_022480A0: ; 0x022480A0
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x02, 0x05, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_022480BC: ; 0x022480BC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x02
	.byte 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov83_022480D8: ; 0x022480D8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x00, 0x00, 0x03, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov83_022480F4: ; 0x022480F4
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x04, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x0A, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF
	.byte 0x21, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x23, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0xFE, 0xFF, 0xFF, 0xFF

ov83_02248150: ; 0x02248150
	.byte 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00

ov83_02248178: ; 0x02248178
	.byte 0x0E, 0x0E, 0x0E, 0x0E

ov83_0224817C: ; 0x0224817C
	.byte 0x20, 0x00, 0x00, 0x00
	.byte 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x6B, 0x00, 0x00, 0x00

ov83_0224818C: ; 0x0224818C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00

ov83_0224819C: ; 0x0224819C
	.word ov83_022482C4
	.byte 0x46, 0x00, 0x00, 0x00
	.word ov83_022481AC
	.byte 0x23, 0x00, 0x00, 0x00

ov83_022481AC:
	.byte 0x01, 0x01, 0x01, 0x1E
	.byte 0x02, 0x0E, 0x01, 0x00, 0x01, 0x1A, 0x13, 0x04, 0x03, 0x0E, 0x3D, 0x00, 0x01, 0x00, 0x04, 0x20
	.byte 0x02, 0x0E, 0x49, 0x00, 0x01, 0x00, 0x09, 0x20, 0x02, 0x0E, 0x89, 0x00, 0x00, 0x04, 0x0A, 0x1A
	.byte 0x0E, 0x0E, 0x01, 0x00, 0x00, 0x17, 0x0F, 0x08, 0x08, 0x0E, 0x01, 0x00, 0x00, 0x16, 0x09, 0x09
	.byte 0x08, 0x0E, 0x6D, 0x01, 0x00, 0x02, 0x13, 0x1B, 0x04, 0x0D, 0xB5, 0x01, 0x00, 0x02, 0x13, 0x14
	.byte 0x04, 0x0D, 0x21, 0x02, 0x00, 0x02, 0x13, 0x11, 0x04, 0x0D, 0x71, 0x02, 0x00, 0x18, 0x0D, 0x07
	.byte 0x04, 0x0E, 0xB5, 0x02, 0x00, 0x18, 0x0B, 0x07, 0x06, 0x0E, 0xD1, 0x02, 0x05, 0x0D, 0x01, 0x08
	.byte 0x02, 0x0F, 0xF0, 0x03, 0x05, 0x15, 0x01, 0x01, 0x02, 0x0F, 0xEE, 0x03, 0x05, 0x17, 0x01, 0x03
	.byte 0x02, 0x0F, 0xE8, 0x03, 0x05, 0x1A, 0x01, 0x03, 0x02, 0x0F, 0xE2, 0x03, 0x05, 0x0D, 0x04, 0x07
	.byte 0x02, 0x0F, 0xD4, 0x03, 0x05, 0x14, 0x04, 0x0B, 0x02, 0x0F, 0xBE, 0x03, 0x05, 0x0D, 0x07, 0x06
	.byte 0x02, 0x0F, 0xB2, 0x03, 0x05, 0x14, 0x07, 0x08, 0x02, 0x0F, 0xA2, 0x03, 0x05, 0x0D, 0x0A, 0x06
	.byte 0x02, 0x0F, 0x96, 0x03, 0x05, 0x13, 0x0A, 0x0C, 0x02, 0x0F, 0x7E, 0x03, 0x05, 0x01, 0x0B, 0x02
	.byte 0x02, 0x0F, 0x7A, 0x03, 0x05, 0x04, 0x0B, 0x07, 0x02, 0x0F, 0x6C, 0x03, 0x05, 0x01, 0x0D, 0x06
	.byte 0x02, 0x0F, 0x58, 0x03, 0x05, 0x08, 0x0D, 0x03, 0x02, 0x0F, 0x52, 0x03, 0x05, 0x01, 0x11, 0x07
	.byte 0x02, 0x0F, 0x44, 0x03, 0x05, 0x08, 0x11, 0x03, 0x02, 0x0F, 0x3E, 0x03, 0x05, 0x01, 0x0F, 0x06
	.byte 0x02, 0x0F, 0x32, 0x03, 0x05, 0x08, 0x0F, 0x03, 0x02, 0x0F, 0x2C, 0x03, 0x05, 0x01, 0x13, 0x07
	.byte 0x02, 0x0F, 0x1E, 0x03, 0x05, 0x08, 0x13, 0x03, 0x02, 0x0F, 0x18, 0x03, 0x05, 0x01, 0x15, 0x06
	.byte 0x02, 0x0F, 0x0C, 0x03, 0x05, 0x08, 0x15, 0x03, 0x02, 0x0F, 0x06, 0x03, 0x05, 0x0D, 0x0E, 0x12
	.byte 0x08, 0x0F, 0x76, 0x02

ov83_022482C4:
	.byte 0x01, 0x01, 0x01, 0x1E, 0x02, 0x0E, 0x01, 0x00, 0x01, 0x1A, 0x13, 0x04
	.byte 0x03, 0x0E, 0x3D, 0x00, 0x01, 0x00, 0x04, 0x20, 0x02, 0x0E, 0x49, 0x00, 0x01, 0x00, 0x09, 0x20
	.byte 0x02, 0x0E, 0x89, 0x00, 0x00, 0x05, 0x0A, 0x18, 0x0E, 0x0E, 0x01, 0x00, 0x00, 0x0C, 0x02, 0x13
	.byte 0x0C, 0x0E, 0x01, 0x00, 0x00, 0x02, 0x13, 0x1B, 0x04, 0x0D, 0xEF, 0x01, 0x00, 0x02, 0x13, 0x14
	.byte 0x04, 0x0D, 0x5B, 0x02, 0x00, 0x02, 0x13, 0x11, 0x04, 0x0D, 0xAB, 0x02, 0x00, 0x17, 0x11, 0x08
	.byte 0x06, 0x0E, 0xEF, 0x02, 0x00, 0x14, 0x07, 0x0B, 0x0A, 0x0E, 0x1F, 0x03, 0x00, 0x16, 0x09, 0x09
	.byte 0x08, 0x0E, 0x1F, 0x03, 0x00, 0x07, 0x11, 0x17, 0x06, 0x0D, 0x5B, 0x02, 0x00, 0x18, 0x0D, 0x07
	.byte 0x04, 0x0E, 0xE5, 0x02, 0x00, 0x18, 0x0B, 0x07, 0x06, 0x0E, 0x01, 0x03, 0x00, 0x01, 0x01, 0x08
	.byte 0x04, 0x0E, 0x2B, 0x03, 0x00, 0x01, 0x07, 0x0A, 0x02, 0x0E, 0x4B, 0x03, 0x00, 0x01, 0x0D, 0x0B
	.byte 0x02, 0x0E, 0x5F, 0x03, 0x05, 0x0D, 0x01, 0x08, 0x02, 0x0F, 0xF0, 0x03, 0x05, 0x15, 0x01, 0x01
	.byte 0x02, 0x0F, 0xEE, 0x03, 0x05, 0x17, 0x01, 0x03, 0x02, 0x0F, 0xE8, 0x03, 0x05, 0x1A, 0x01, 0x03
	.byte 0x02, 0x0F, 0xE2, 0x03, 0x05, 0x0D, 0x04, 0x07, 0x02, 0x0F, 0xD4, 0x03, 0x05, 0x14, 0x04, 0x0B
	.byte 0x02, 0x0F, 0xBE, 0x03, 0x05, 0x0D, 0x07, 0x06, 0x02, 0x0F, 0xB2, 0x03, 0x05, 0x14, 0x07, 0x08
	.byte 0x02, 0x0F, 0xA2, 0x03, 0x05, 0x0D, 0x0A, 0x06, 0x02, 0x0F, 0x96, 0x03, 0x05, 0x13, 0x0A, 0x0C
	.byte 0x02, 0x0F, 0x7E, 0x03, 0x05, 0x01, 0x0B, 0x02, 0x02, 0x0F, 0x7A, 0x03, 0x05, 0x04, 0x0B, 0x07
	.byte 0x02, 0x0F, 0x6C, 0x03, 0x05, 0x01, 0x0D, 0x06, 0x02, 0x0F, 0x58, 0x03, 0x05, 0x08, 0x0D, 0x03
	.byte 0x02, 0x0F, 0x52, 0x03, 0x05, 0x01, 0x11, 0x07, 0x02, 0x0F, 0x44, 0x03, 0x05, 0x08, 0x11, 0x03
	.byte 0x02, 0x0F, 0x3E, 0x03, 0x05, 0x01, 0x0F, 0x06, 0x02, 0x0F, 0x32, 0x03, 0x05, 0x08, 0x0F, 0x03
	.byte 0x02, 0x0F, 0x2C, 0x03, 0x05, 0x01, 0x13, 0x07, 0x02, 0x0F, 0x1E, 0x03, 0x05, 0x08, 0x13, 0x03
	.byte 0x02, 0x0F, 0x18, 0x03, 0x05, 0x01, 0x15, 0x07, 0x02, 0x0F, 0x0A, 0x03, 0x05, 0x08, 0x15, 0x03
	.byte 0x02, 0x0F, 0x04, 0x03, 0x05, 0x0D, 0x0E, 0x0B, 0x02, 0x0F, 0xEE, 0x02, 0x05, 0x0D, 0x10, 0x0B
	.byte 0x02, 0x0F, 0xD8, 0x02, 0x05, 0x0D, 0x12, 0x0B, 0x02, 0x0F, 0xC2, 0x02, 0x05, 0x0D, 0x14, 0x0B
	.byte 0x02, 0x0F, 0xAC, 0x02, 0x05, 0x1A, 0x0E, 0x05, 0x02, 0x0F, 0xA2, 0x02, 0x05, 0x1A, 0x10, 0x05
	.byte 0x02, 0x0F, 0x98, 0x02, 0x05, 0x1A, 0x12, 0x05, 0x02, 0x0F, 0x8E, 0x02, 0x05, 0x1A, 0x14, 0x05
	.byte 0x02, 0x0F, 0x84, 0x02, 0x00, 0x03, 0x04, 0x0D, 0x05, 0x0E, 0x01, 0x00, 0x00, 0x13, 0x04, 0x0D
	.byte 0x05, 0x0E, 0x42, 0x00, 0x00, 0x03, 0x09, 0x0D, 0x05, 0x0E, 0x83, 0x00, 0x00, 0x13, 0x09, 0x0D
	.byte 0x05, 0x0E, 0xC4, 0x00, 0x00, 0x03, 0x0E, 0x0D, 0x05, 0x0E, 0x05, 0x01, 0x00, 0x13, 0x0E, 0x0D
	.byte 0x05, 0x0E, 0x46, 0x01, 0x00, 0x0A, 0x08, 0x0C, 0x02, 0x0E, 0x87, 0x01, 0x00, 0x16, 0x08, 0x05
	.byte 0x02, 0x0E, 0x9F, 0x01, 0x00, 0x0E, 0x15, 0x04, 0x02, 0x0E, 0xA9, 0x01, 0x00, 0x1A, 0x15, 0x05
	.byte 0x02, 0x0E, 0xB1, 0x01, 0x00, 0x02, 0x01, 0x0C, 0x02, 0x0E, 0xBB, 0x01, 0x00, 0x10, 0x01, 0x08
	.byte 0x02, 0x0E, 0xD3, 0x01, 0x00, 0x18, 0x01, 0x06, 0x02, 0x0E, 0xE3, 0x01, 0x07, 0x04, 0x11, 0x1B
	.byte 0x06, 0x0F, 0x5E, 0x03, 0x07, 0x0D, 0x05, 0x08, 0x02, 0x0F, 0x4E, 0x03, 0x07, 0x15, 0x05, 0x01
	.byte 0x02, 0x0F, 0x4C, 0x03, 0x07, 0x17, 0x05, 0x03, 0x02, 0x0F, 0x46, 0x03, 0x07, 0x1A, 0x05, 0x03
	.byte 0x02, 0x0F, 0x40, 0x03, 0x07, 0x0D, 0x08, 0x02, 0x02, 0x0F, 0x3C, 0x03, 0x07, 0x10, 0x08, 0x08
	.byte 0x02, 0x0F, 0x2C, 0x03, 0x07, 0x0D, 0x0B, 0x06, 0x02, 0x0F, 0x20, 0x03, 0x07, 0x13, 0x0B, 0x0C
	.byte 0x02, 0x0F, 0x08, 0x03

ov83_022484F4: ; 0x022484F4
	.byte 0xA0, 0xBF, 0x00, 0x27, 0xA0, 0xBF, 0x28, 0x4F, 0xFF, 0x00, 0x00, 0x00

ov83_02248500: ; 0x02248500
	.word ov83_02247A20
	.word ov83_02247A20
	.word ov83_02247B1C
	.word ov83_02247B34

ov83_02248510: ; 0x02248510
	.word ov83_02247A20
	.word ov83_02247A20
	.word ov83_02247B4C
	.word ov83_02247B64

ov83_02248520: ; 0x02248520
	.word ov83_02247A20
	.word ov83_02247A20
	.word ov83_02247C58
	.word ov83_02247C88

ov83_02248530: ; 0x02248530
	.byte 0x98, 0xAF, 0xC8, 0xF7, 0x20, 0x4F, 0x20, 0x5F, 0x20, 0x4F, 0x60, 0x9F, 0x20, 0x4F, 0xA0, 0xDF
	.byte 0xFF, 0x00, 0x00, 0x00

ov83_02248544: ; 0x02248544
	.byte 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00

ov83_02248558: ; 0x02248558
	.byte 0x98, 0xAF, 0xC8, 0xF7, 0x20, 0x4F, 0x00, 0x3F
	.byte 0x20, 0x4F, 0x40, 0x7F, 0x20, 0x4F, 0x80, 0xBF, 0x20, 0x4F, 0xC0, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov83_02248570: ; 0x02248570
	.byte 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00

ov83_0224858C: ; 0x0224858C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x05, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00

ov83_022485A8: ; 0x022485A8
	.byte 0x00, 0x00, 0x00, 0x00, 0x81, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x03, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x03
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x02, 0x01

ov83_022485C8: ; 0x022485C8
	.byte 0x20, 0x47, 0x00, 0x7F, 0x20, 0x47, 0x80, 0xFF
	.byte 0x48, 0x6F, 0x00, 0x7F, 0x48, 0x6F, 0x80, 0xFF, 0x70, 0x97, 0x00, 0x7F, 0x70, 0x97, 0x80, 0xFF
	.byte 0xA0, 0xBF, 0xC8, 0xFF, 0xFF, 0x00, 0x00, 0x00

ov83_022485E8: ; 0x022485E8
	.byte 0x00, 0x00, 0x00, 0x00, 0x81, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x04, 0x02, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x03
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x02, 0x04, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x03, 0x01

ov83_02248610: ; 0x02248610
	.byte 0x40

ov83_02248611: ; 0x02248611
	.byte 0x34, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0xC0, 0x34, 0x00, 0x00, 0x01, 0x03, 0x00, 0x01
	.byte 0x40, 0x5C, 0x00, 0x00, 0x00, 0x04, 0x02, 0x03, 0xC0, 0x5C, 0x00, 0x00, 0x01, 0x05, 0x02, 0x03
	.byte 0x40, 0x84, 0x00, 0x00, 0x02, 0x06, 0x04, 0x05, 0xC0, 0x84, 0x00, 0x00, 0x03, 0x06, 0x04, 0x05
	.byte 0xE4, 0xB0, 0x00, 0x00, 0x85, 0x06, 0x06, 0x06
	; 0x02248648
