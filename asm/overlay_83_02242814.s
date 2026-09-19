	.include "asm/macros.inc"
	.include "overlay_83.inc"
	.include "global.inc"

	.text

	thumb_func_start ov83_02242814
ov83_02242814: ; 0x02242814
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r5, r1, #0
	bl ov83_02241E18
	add r0, r4, #0
	add r1, r5, #0
	bl ov83_022421E0
	mov r3, #0x1e
	lsl r3, r3, #6
	add r2, r3, #0
	add r1, r3, #0
	add r2, #0x8c
	ldr r0, [r4, r3]
	add r1, #0x88
	add r3, #0x94
	ldrh r2, [r4, r2]
	ldr r1, [r4, r1]
	ldr r3, [r4, r3]
	bl ov83_02247668
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_02242814

	thumb_func_start ov83_02242844
ov83_02242844: ; 0x02242844
	push {r4, r5, r6, lr}
	add r6, r0, #0
	cmp r1, #1
	bne _02242870
	mov r0, #0x17
	lsl r0, r0, #4
	mov r4, #0x12
	add r5, r6, r0
_02242854:
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #0x2f
	bls _02242854
	mov r0, #0x1e
	lsl r0, r0, #6
	ldr r0, [r6, r0]
	mov r1, #1
	bl ov83_0224755C
	pop {r4, r5, r6, pc}
_02242870:
	mov r0, #0x17
	lsl r0, r0, #4
	mov r5, #0x12
	add r4, r6, r0
_02242878:
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	add r5, r5, #1
	add r4, #0x10
	cmp r5, #0x2f
	bls _02242878
	mov r0, #0x1e
	lsl r0, r0, #6
	ldr r0, [r6, r0]
	mov r1, #0
	bl ov83_0224755C
	pop {r4, r5, r6, pc}
	thumb_func_end ov83_02242844

	thumb_func_start ov83_02242894
ov83_02242894: ; 0x02242894
	lsl r3, r0, #0x1f
	lsr r3, r3, #0x18
	add r3, #0x14
	strh r3, [r1]
	lsr r1, r0, #1
	mov r0, #0x28
	mul r0, r1
	add r0, #0x38
	strh r0, [r2]
	bx lr
	thumb_func_end ov83_02242894

	thumb_func_start ov83_022428A8
ov83_022428A8: ; 0x022428A8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r6, r0, #0
	str r0, [sp, #0x14]
	add r0, #0x50
	add r7, r1, #0
	mov r4, #0
	add r5, r6, #0
	str r0, [sp, #0x14]
_022428BA:
	add r0, r4, #0
	add r0, #0x30
	lsl r1, r0, #4
	ldr r0, [sp, #0x14]
	add r0, r0, r1
	bl ClearWindowTilemapAndScheduleTransfer
	cmp r4, r7
	ldr r0, _022429CC ; =0x00000784
	beq _022428D8
	ldr r0, [r5, r0]
	mov r1, #0
	bl ov83_0224755C
	b _022428E2
_022428D8:
	ldr r0, [r5, r0]
	mov r1, #0x44
	mov r2, #0x4c
	bl ov83_02247568
_022428E2:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blo _022428BA
	ldr r0, _022429D0 ; =0x0000077C
	mov r1, #0
	ldr r0, [r6, r0]
	bl ov83_0224755C
	mov r0, #0x6b
	str r0, [sp]
	ldr r0, _022429D4 ; =0x000007A8
	mov r1, #0x27
	ldr r0, [r6, r0]
	mov r2, #1
	add r3, sp, #0x18
	bl GfGfxLoader_GetScrnDataFromOpenNarc
	mov r3, #0
	add r4, r0, #0
	str r3, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	ldr r2, [sp, #0x18]
	ldr r0, [r6, #0x4c]
	mov r1, #2
	add r2, #0xc
	bl LoadRectToBgTilemapRect
	ldr r0, [r6, #0x4c]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0x3b
	lsl r0, r0, #4
	add r0, r6, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0xf
	lsl r0, r0, #6
	add r0, r6, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _022429D8 ; =0x00000862
	ldr r2, _022429DC ; =0x000004DC
	ldrsh r1, [r6, r0]
	mov r0, #6
	mul r0, r1
	mov r1, #0
	add r0, r0, r7
	lsl r4, r0, #3
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022429E0 ; =0x00010200
	add r3, r1, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r2, [r6, r2]
	mov r0, #0x3b
	lsl r0, r0, #4
	ldr r2, [r2, r4]
	add r0, r6, r0
	bl AddTextPrinterParameterizedWithColor
	ldr r1, _022429DC ; =0x000004DC
	ldrb r2, [r6, #0x13]
	ldr r1, [r6, r1]
	add r0, r6, #0
	add r1, r1, r4
	ldr r1, [r1, #4]
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	bl ov83_02240EC4
	add r2, r0, #0
	mov r1, #0
	add r0, r6, #0
	mov r3, #2
	str r1, [sp]
	bl ov83_02240C48
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r0, _022429E0 ; =0x00010200
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #0xf
	lsl r1, r1, #6
	ldr r2, [r6, #0x20]
	add r0, r6, #0
	add r1, r6, r1
	mov r3, #0x68
	bl ov83_02241DD8
	mov r0, #0x3b
	lsl r0, r0, #4
	add r0, r6, r0
	bl ScheduleWindowCopyToVram
	mov r0, #0xf
	lsl r0, r0, #6
	add r0, r6, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_022429CC: .word 0x00000784
_022429D0: .word 0x0000077C
_022429D4: .word 0x000007A8
_022429D8: .word 0x00000862
_022429DC: .word 0x000004DC
_022429E0: .word 0x00010200
	thumb_func_end ov83_022428A8

	thumb_func_start ov83_022429E4
ov83_022429E4: ; 0x022429E4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r0, #0
	mov r0, #0x3b
	lsl r0, r0, #4
	add r0, r6, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0xf
	lsl r0, r0, #6
	add r0, r6, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x6b
	str r0, [sp]
	ldr r0, _02242AA0 ; =0x000007A8
	mov r1, #0x26
	ldr r0, [r6, r0]
	mov r2, #1
	add r3, sp, #0x10
	bl GfGfxLoader_GetScrnDataFromOpenNarc
	mov r3, #0
	add r4, r0, #0
	str r3, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x18
	str r0, [sp, #8]
	ldr r2, [sp, #0x10]
	ldr r0, [r6, #0x4c]
	mov r1, #2
	add r2, #0xc
	bl LoadRectToBgTilemapRect
	ldr r0, [r6, #0x4c]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	add r0, r4, #0
	bl Heap_Free
	ldr r0, _02242AA4 ; =0x00000862
	mov r4, #0
	ldrsh r1, [r6, r0]
	mov r0, #6
	add r5, r6, #0
	add r7, r1, #0
	mul r7, r0
_02242A46:
	add r1, sp, #0xc
	add r0, r4, #0
	add r1, #2
	add r2, sp, #0xc
	bl ov83_02242894
	ldr r0, _02242AA8 ; =0x00000784
	add r1, sp, #0xc
	add r2, sp, #0xc
	ldrh r1, [r1, #2]
	ldrh r2, [r2]
	ldr r0, [r5, r0]
	bl ov83_02247568
	ldr r0, _02242AAC ; =0x00000861
	add r1, r7, r4
	ldrb r0, [r6, r0]
	cmp r1, r0
	bhs _02242A76
	ldr r0, _02242AA8 ; =0x00000784
	mov r1, #1
	ldr r0, [r5, r0]
	bl ov83_0224755C
_02242A76:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blo _02242A46
	ldr r0, _02242AB0 ; =0x0000077C
	mov r1, #1
	ldr r0, [r6, r0]
	bl ov83_0224755C
	add r0, r6, #0
	bl ov83_02240664
	add r0, r6, #0
	bl ov83_022407FC
	add r0, r6, #0
	bl ov83_0224088C
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_02242AA0: .word 0x000007A8
_02242AA4: .word 0x00000862
_02242AA8: .word 0x00000784
_02242AAC: .word 0x00000861
_02242AB0: .word 0x0000077C
	thumb_func_end ov83_022429E4

	thumb_func_start ov83_02242AB4
ov83_02242AB4: ; 0x02242AB4
	ldr r3, _02242ABC ; =ov83_02240DB0
	strb r1, [r0, #0xd]
	strb r2, [r0, #0xc]
	bx r3
	.balign 4, 0
_02242ABC: .word ov83_02240DB0
	thumb_func_end ov83_02242AB4

	thumb_func_start ov83_02242AC0
ov83_02242AC0: ; 0x02242AC0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _02242ADC ; =0x0000077C
	add r4, r3, #0
	ldr r0, [r5, r0]
	bl ov83_02247568
	ldr r0, _02242ADC ; =0x0000077C
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl ov83_022475D4
	pop {r3, r4, r5, pc}
	nop
_02242ADC: .word 0x0000077C
	thumb_func_end ov83_02242AC0

	thumb_func_start ov83_02242AE0
ov83_02242AE0: ; 0x02242AE0
	ldr r3, _02242AE8 ; =ov83_022408E0
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	bx r3
	.balign 4, 0
_02242AE8: .word ov83_022408E0
	thumb_func_end ov83_02242AE0

	thumb_func_start ov83_02242AEC
ov83_02242AEC: ; 0x02242AEC
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
	ldr r0, _02242B9C ; =_02247D0C
	add r1, sp, #4
	ldrh r2, [r0, #0x1e]
	add r3, sp, #8
	strh r2, [r1, #0x1c]
	ldrh r2, [r0, #0x20]
	strh r2, [r1, #0x1e]
	ldrh r2, [r0, #0x22]
	strh r2, [r1, #0x20]
	ldrh r2, [r0, #0x24]
	strh r2, [r1, #0x22]
	ldrh r2, [r0, #0x26]
	ldrh r0, [r0, #0x28]
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
	ldr r0, _02242BA0 ; =0x00000844
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
	mov r1, #0x21
	lsl r1, r1, #6
	str r0, [r5, r1]
	ldrb r1, [r5, #0xe]
	mov r0, #0x10
	orr r0, r1
	strb r0, [r5, #0xe]
	ldrb r0, [r5, #9]
	mov r1, #1
	bl ov80_02237B24
	add r4, r0, #0
	ldr r0, _02242BA4 ; =0x0000073C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #1
	bl ov83_0224773C
	ldr r0, _02242BA8 ; =0x0000074C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #1
	bl ov83_0224773C
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	nop
_02242B9C: .word _02247D0C
_02242BA0: .word 0x00000844
_02242BA4: .word 0x0000073C
_02242BA8: .word 0x0000074C
	thumb_func_end ov83_02242AEC

	thumb_func_start ov83_02242BAC
ov83_02242BAC: ; 0x02242BAC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r0, #3
	mov r1, #0x6b
	bl ListMenuItems_New
	ldr r1, _02242BE8 ; =0x00000844
	ldr r5, _02242BEC ; =ov83_02247D6C
	str r0, [r6, r1]
	mov r4, #0
	add r7, r1, #0
_02242BC2:
	ldr r0, [r6, r7]
	ldr r1, [r6, #0x20]
	ldr r2, [r5]
	ldr r3, [r5, #4]
	bl ListMenuItems_AppendFromMsgData
	add r4, r4, #1
	add r5, #8
	cmp r4, #3
	blo _02242BC2
	mov r0, #0xd
	str r0, [sp]
	add r0, r6, #0
	mov r1, #3
	mov r2, #0x11
	mov r3, #8
	bl ov83_02242AEC
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02242BE8: .word 0x00000844
_02242BEC: .word ov83_02247D6C
	thumb_func_end ov83_02242BAC

	thumb_func_start ov83_02242BF0
ov83_02242BF0: ; 0x02242BF0
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	mov r0, #5
	mov r1, #0x6b
	bl ListMenuItems_New
	ldr r1, _02242C9C ; =0x00000844
	mov r2, #0
	str r0, [r4, r1]
	ldr r0, _02242CA0 ; =0x0000050C
	ldrb r1, [r4, #9]
	ldr r0, [r4, r0]
	bl ov83_0224777C
	mov r5, #0
	add r7, r0, #0
	add r6, r5, #0
_02242C12:
	mov r0, #0xc
	add r1, r6, #0
	mul r1, r0
	ldr r0, _02242CA4 ; =ov83_02247F4C
	add r2, r0, r1
	ldr r3, [r2, #8]
	cmp r3, #4
	bhi _02242C6A
	add r0, r3, r3
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02242C2E: ; jump table
	.short _02242C6A - _02242C2E - 2 ; case 0
	.short _02242C38 - _02242C2E - 2 ; case 1
	.short _02242C38 - _02242C2E - 2 ; case 2
	.short _02242C38 - _02242C2E - 2 ; case 3
	.short _02242C52 - _02242C2E - 2 ; case 4
_02242C38:
	ldr r0, [r2]
	cmp r7, r0
	blo _02242C7C
	ldr r0, _02242C9C ; =0x00000844
	ldr r1, [r4, #0x20]
	ldr r0, [r4, r0]
	ldr r2, [r2, #4]
	bl ListMenuItems_AppendFromMsgData
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	b _02242C7C
_02242C52:
	cmp r7, #3
	beq _02242C7C
	ldr r0, _02242C9C ; =0x00000844
	ldr r1, [r4, #0x20]
	ldr r0, [r4, r0]
	ldr r2, [r2, #4]
	bl ListMenuItems_AppendFromMsgData
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	b _02242C7C
_02242C6A:
	ldr r0, _02242C9C ; =0x00000844
	ldr r1, [r4, #0x20]
	ldr r0, [r4, r0]
	ldr r2, [r2, #4]
	bl ListMenuItems_AppendFromMsgData
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
_02242C7C:
	add r0, r6, #1
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	cmp r6, #5
	blo _02242C12
	ldr r3, _02242CA8 ; =ov83_02248008
	mov r0, #0xd
	ldrb r3, [r3, r5]
	str r0, [sp]
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0x11
	bl ov83_02242AEC
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02242C9C: .word 0x00000844
_02242CA0: .word 0x0000050C
_02242CA4: .word ov83_02247F4C
_02242CA8: .word ov83_02248008
	thumb_func_end ov83_02242BF0

	thumb_func_start ov83_02242CAC
ov83_02242CAC: ; 0x02242CAC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #4
	mov r1, #0x6b
	bl ListMenuItems_New
	ldr r1, _02242D4C ; =0x00000844
	mov r2, #1
	str r0, [r5, r1]
	ldr r0, _02242D50 ; =0x0000050C
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	bl ov83_0224777C
	mov r4, #0
	add r7, r0, #0
	add r6, r4, #0
_02242CCE:
	mov r0, #0xc
	add r1, r6, #0
	mul r1, r0
	ldr r0, _02242D54 ; =ov83_02247EB0
	add r2, r0, r1
	ldr r3, [r2, #8]
	cmp r3, #6
	beq _02242CE8
	cmp r3, #7
	beq _02242CE8
	cmp r3, #8
	beq _02242D02
	b _02242D1A
_02242CE8:
	ldr r0, [r2]
	cmp r7, r0
	blo _02242D2C
	ldr r0, _02242D4C ; =0x00000844
	ldr r1, [r5, #0x20]
	ldr r0, [r5, r0]
	ldr r2, [r2, #4]
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	b _02242D2C
_02242D02:
	cmp r7, #3
	beq _02242D2C
	ldr r0, _02242D4C ; =0x00000844
	ldr r1, [r5, #0x20]
	ldr r0, [r5, r0]
	ldr r2, [r2, #4]
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	b _02242D2C
_02242D1A:
	ldr r0, _02242D4C ; =0x00000844
	ldr r1, [r5, #0x20]
	ldr r0, [r5, r0]
	ldr r2, [r2, #4]
	bl ListMenuItems_AppendFromMsgData
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_02242D2C:
	add r0, r6, #1
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	cmp r6, #4
	blo _02242CCE
	ldr r3, _02242D58 ; =ov83_02248008
	mov r0, #0xd
	ldrb r3, [r3, r4]
	str r0, [sp]
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #0x11
	bl ov83_02242AEC
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02242D4C: .word 0x00000844
_02242D50: .word 0x0000050C
_02242D54: .word ov83_02247EB0
_02242D58: .word ov83_02248008
	thumb_func_end ov83_02242CAC

	thumb_func_start ov83_02242D5C
ov83_02242D5C: ; 0x02242D5C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldrb r0, [r5, #9]
	mov r1, #1
	bl ov80_02237B24
	add r4, r0, #0
	ldr r0, _02242DA0 ; =0x0000073C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	bl ov83_0224773C
	ldr r0, _02242DA4 ; =0x0000074C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	bl ov83_0224773C
	mov r0, #0x21
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	bl ov83_02247CE8
	ldr r0, _02242DA8 ; =0x00000844
	ldr r0, [r5, r0]
	bl ListMenuItems_Delete
	ldrb r1, [r5, #0xe]
	mov r0, #0x10
	bic r1, r0
	strb r1, [r5, #0xe]
	pop {r3, r4, r5, pc}
	nop
_02242DA0: .word 0x0000073C
_02242DA4: .word 0x0000074C
_02242DA8: .word 0x00000844
	thumb_func_end ov83_02242D5C

	thumb_func_start ov83_02242DAC
ov83_02242DAC: ; 0x02242DAC
	push {r3, r4, r5, lr}
	sub sp, #0x18
	mov r1, #0x21
	add r4, r0, #0
	lsl r1, r1, #6
	ldr r2, [r4, r1]
	add r1, #8
	add r2, #0x24
	ldrb r2, [r2]
	ldr r1, [r4, r1]
	cmp r1, r2
	beq _02242DF4
	mov r3, #1
	str r3, [sp]
	mov r1, #0xff
	str r1, [sp, #4]
	lsl r5, r2, #1
	ldr r2, _02242DF8 ; =ov83_02247D1E
	str r3, [sp, #8]
	mov r1, #2
	str r1, [sp, #0xc]
	mov r1, #0xf
	str r1, [sp, #0x10]
	add r1, r4, #0
	ldrh r2, [r2, r5]
	add r1, #0xb0
	str r3, [sp, #0x14]
	bl ov83_0223FC48
	mov r0, #0x21
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	add r0, #8
	add r1, #0x24
	ldrb r1, [r1]
	str r1, [r4, r0]
_02242DF4:
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02242DF8: .word ov83_02247D1E
	thumb_func_end ov83_02242DAC

	thumb_func_start ov83_02242DFC
ov83_02242DFC: ; 0x02242DFC
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #0x21
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	add r1, #0x24
	ldrb r2, [r1]
	add r1, r0, #0
	add r1, #8
	ldr r1, [r4, r1]
	cmp r1, r2
	beq _02242E80
	add r0, r0, #4
	ldr r1, [r4, r0]
	lsl r0, r2, #3
	add r0, r1, r0
	ldr r1, [r0, #4]
	cmp r1, #4
	beq _02242E2E
	mov r0, #1
	mvn r0, r0
	cmp r1, r0
	beq _02242E4E
	b _02242E52
_02242E2E:
	ldr r0, _02242E84 ; =0x0000050C
	ldrb r1, [r4, #9]
	ldr r0, [r4, r0]
	mov r2, #0
	bl ov83_0224777C
	cmp r0, #3
	bne _02242E42
	mov r2, #0x1b
	b _02242E54
_02242E42:
	cmp r0, #1
	bne _02242E4A
	mov r2, #0x19
	b _02242E54
_02242E4A:
	mov r2, #0x1a
	b _02242E54
_02242E4E:
	mov r2, #0x1c
	b _02242E54
_02242E52:
	mov r2, #0x18
_02242E54:
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
	add r1, #0xb0
	str r3, [sp, #0x14]
	bl ov83_0223FC48
	mov r0, #0x21
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	add r0, #8
	add r1, #0x24
	ldrb r1, [r1]
	str r1, [r4, r0]
_02242E80:
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_02242E84: .word 0x0000050C
	thumb_func_end ov83_02242DFC

	thumb_func_start ov83_02242E88
ov83_02242E88: ; 0x02242E88
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #0x21
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	add r1, #0x24
	ldrb r2, [r1]
	add r1, r0, #0
	add r1, #8
	ldr r1, [r4, r1]
	cmp r1, r2
	beq _02242F10
	add r0, r0, #4
	ldr r1, [r4, r0]
	lsl r0, r2, #3
	add r0, r1, r0
	ldr r0, [r0, #4]
	cmp r0, #6
	beq _02242EBA
	cmp r0, #7
	beq _02242EBE
	cmp r0, #8
	beq _02242EC2
	b _02242EE2
_02242EBA:
	mov r2, #0x30
	b _02242EE4
_02242EBE:
	mov r2, #0x31
	b _02242EE4
_02242EC2:
	ldr r0, _02242F14 ; =0x0000050C
	ldrb r1, [r4, #9]
	ldr r0, [r4, r0]
	mov r2, #1
	bl ov83_0224777C
	cmp r0, #3
	bne _02242ED6
	mov r2, #0x34
	b _02242EE4
_02242ED6:
	cmp r0, #1
	bne _02242EDE
	mov r2, #0x32
	b _02242EE4
_02242EDE:
	mov r2, #0x33
	b _02242EE4
_02242EE2:
	mov r2, #0x35
_02242EE4:
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
	add r1, #0xb0
	str r3, [sp, #0x14]
	bl ov83_0223FC48
	mov r0, #0x21
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	add r0, #8
	add r1, #0x24
	ldrb r1, [r1]
	str r1, [r4, r0]
_02242F10:
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_02242F14: .word 0x0000050C
	thumb_func_end ov83_02242E88

	thumb_func_start ov83_02242F18
ov83_02242F18: ; 0x02242F18
	ldr r2, _02242F28 ; =0x00000864
	mov r3, #0
	strh r1, [r0, r2]
	add r1, r2, #2
	strb r3, [r0, r1]
	add r1, r2, #3
	strb r3, [r0, r1]
	bx lr
	.balign 4, 0
_02242F28: .word 0x00000864
	thumb_func_end ov83_02242F18

	thumb_func_start ov83_02242F2C
ov83_02242F2C: ; 0x02242F2C
	push {r3, r4, lr}
	sub sp, #0xc
	ldr r1, _02242FD8 ; =0x00000864
	add r4, r0, #0
	ldrh r0, [r4, r1]
	ldr r2, _02242FDC ; =ov83_02247E64
	lsl r0, r0, #2
	add r3, r2, r0
	add r0, r1, #2
	ldrb r0, [r4, r0]
	cmp r0, #0
	beq _02242F4E
	cmp r0, #1
	beq _02242F78
	cmp r0, #2
	beq _02242FBA
	b _02242FD0
_02242F4E:
	ldrb r0, [r3, #2]
	mov r1, #2
	str r0, [sp]
	ldrb r0, [r3, #3]
	str r0, [sp, #4]
	mov r0, #6
	str r0, [sp, #8]
	ldrb r2, [r3]
	ldrb r3, [r3, #1]
	ldr r0, [r4, #0x4c]
	bl BgTilemapRectChangePalette
	ldr r0, [r4, #0x4c]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, _02242FE0 ; =0x00000866
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _02242FD0
_02242F78:
	add r0, r1, #3
	ldrb r0, [r4, r0]
	add r2, r0, #1
	add r0, r1, #3
	strb r2, [r4, r0]
	ldrb r0, [r4, r0]
	cmp r0, #4
	bne _02242FD0
	ldrb r0, [r3, #2]
	mov r1, #2
	str r0, [sp]
	ldrb r0, [r3, #3]
	str r0, [sp, #4]
	mov r0, #5
	str r0, [sp, #8]
	ldrb r2, [r3]
	ldrb r3, [r3, #1]
	ldr r0, [r4, #0x4c]
	bl BgTilemapRectChangePalette
	ldr r0, [r4, #0x4c]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, _02242FE4 ; =0x00000867
	mov r1, #0
	strb r1, [r4, r0]
	sub r1, r0, #1
	ldrb r1, [r4, r1]
	sub r0, r0, #1
	add r1, r1, #1
	strb r1, [r4, r0]
	b _02242FD0
_02242FBA:
	add r0, r1, #3
	ldrb r0, [r4, r0]
	add r2, r0, #1
	add r0, r1, #3
	strb r2, [r4, r0]
	ldrb r0, [r4, r0]
	cmp r0, #2
	bne _02242FD0
	add sp, #0xc
	mov r0, #0
	pop {r3, r4, pc}
_02242FD0:
	mov r0, #1
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_02242FD8: .word 0x00000864
_02242FDC: .word ov83_02247E64
_02242FE0: .word 0x00000866
_02242FE4: .word 0x00000867
	thumb_func_end ov83_02242F2C

	thumb_func_start ov83_02242FE8
ov83_02242FE8: ; 0x02242FE8
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _022430F0 ; =FS_OVERLAY_ID(OVY_80)
	mov r1, #2
	bl HandleLoadOverlay
	bl ov83_02243F9C
	mov r0, #3
	mov r1, #0x6b
	lsl r2, r0, #0x10
	bl Heap_Create
	ldr r1, _022430F4 ; =0x00000614
	add r0, r4, #0
	mov r2, #0x6b
	bl OverlayManager_CreateAndGetData
	ldr r2, _022430F4 ; =0x00000614
	mov r1, #0
	add r5, r0, #0
	bl memset
	mov r0, #0x6b
	bl BgConfig_Alloc
	str r0, [r5, #0x4c]
	add r0, r4, #0
	str r4, [r5]
	bl OverlayManager_GetArgs
	add r4, r0, #0
	mov r0, #0xaf
	ldr r1, [r4]
	lsl r0, r0, #2
	str r1, [r5, r0]
	ldr r0, [r5, r0]
	bl sub_02030CC8
	mov r1, #0xb
	lsl r1, r1, #6
	str r0, [r5, r1]
	sub r0, r1, #4
	ldr r0, [r5, r0]
	bl sub_02030E08
	mov r1, #0xb1
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldrb r0, [r4, #4]
	add r2, r4, #0
	add r2, #0x20
	strb r0, [r5, #9]
	ldr r0, _022430F8 ; =0x00000548
	sub r1, #8
	str r2, [r5, r0]
	ldr r0, [r5, r1]
	bl Save_PlayerData_GetOptionsAddr
	mov r1, #0xae
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r3, r4, #0
	ldr r2, [r4, #0x1c]
	ldr r0, _022430FC ; =0x0000055C
	add r3, #8
	str r2, [r5, r0]
	add r2, r0, #0
	sub r2, #0x10
	str r3, [r5, r2]
	add r3, r4, #0
	add r2, r0, #0
	add r3, #0xc
	sub r2, #0xc
	str r3, [r5, r2]
	add r3, r4, #0
	add r2, r0, #0
	add r3, #0x10
	sub r2, #8
	str r3, [r5, r2]
	add r3, r4, #0
	sub r2, r0, #4
	add r3, #0x14
	str r3, [r5, r2]
	mov r2, #0xff
	strb r2, [r5, #0x11]
	ldrh r2, [r4, #0x28]
	add r0, #0x5e
	strh r2, [r5, r0]
	add r0, r1, #4
	ldr r0, [r5, r0]
	bl Save_Frontier_GetStatic
	str r0, [r5, #4]
	ldr r0, _02243100 ; =0x000005B7
	mov r3, #0
	mov r2, #1
_022430AA:
	add r1, r5, r3
	add r3, r3, #1
	strb r2, [r1, r0]
	cmp r3, #3
	blt _022430AA
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _022430C2
	mov r0, #3
	b _022430C4
_022430C2:
	mov r0, #4
_022430C4:
	strb r0, [r5, #0x14]
	mov r0, #4
	strb r0, [r5, #0x15]
	ldrb r0, [r5, #0x15]
	mov r1, #0
	sub r0, r0, #1
	strb r0, [r5, #0xc]
	ldr r0, _02243104 ; =0x000005B4
	strb r1, [r5, r0]
	add r0, r5, #0
	bl ov83_02243FD4
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _022430EC
	add r0, r5, #0
	bl sub_02096910
_022430EC:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022430F0: .word FS_OVERLAY_ID(OVY_80)
_022430F4: .word 0x00000614
_022430F8: .word 0x00000548
_022430FC: .word 0x0000055C
_02243100: .word 0x000005B7
_02243104: .word 0x000005B4
	thumb_func_end ov83_02242FE8

	thumb_func_start ov83_02243108
ov83_02243108: ; 0x02243108
	push {r3, r4, r5, lr}
	add r5, r1, #0
	bl OverlayManager_GetData
	ldr r1, _02243260 ; =0x000005B6
	add r4, r0, #0
	ldrb r2, [r4, r1]
	cmp r2, #1
	bne _02243176
	ldr r2, [r5]
	cmp r2, #1
	bne _022431A2
	mov r2, #0
	strb r2, [r4, r1]
	bl ov83_02245074
	add r0, r4, #0
	bl ov83_022459A0
	ldr r0, _02243264 ; =0x00000504
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _02243142
	bl ov83_0224753C
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
_02243142:
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02247944
	ldr r0, [r4, #0x24]
	mov r1, #0
	bl ov80_0222A7CC
	add r0, r4, #0
	mov r1, #7
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #3
	bl ov83_02244CD4
	b _022431A2
_02243176:
	ldrb r0, [r4, #0x11]
	cmp r0, #0xff
	beq _022431A2
	ldr r0, [r5]
	cmp r0, #1
	beq _02243186
	cmp r0, #3
	bne _022431A2
_02243186:
	ldr r0, _02243260 ; =0x000005B6
	mov r1, #0
	strb r1, [r4, r0]
	add r0, r4, #0
	bl ov83_02245074
	add r0, r4, #0
	bl ov83_022459A0
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #2
	bl ov83_02244CD4
_022431A2:
	ldr r0, [r5]
	cmp r0, #4
	bhi _0224324C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022431B4: ; jump table
	.short _022431BE - _022431B4 - 2 ; case 0
	.short _022431D4 - _022431B4 - 2 ; case 1
	.short _02243212 - _022431B4 - 2 ; case 2
	.short _02243228 - _022431B4 - 2 ; case 3
	.short _0224323E - _022431B4 - 2 ; case 4
_022431BE:
	add r0, r4, #0
	bl ov83_022432B4
	cmp r0, #1
	bne _0224324C
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #1
	bl ov83_02244CD4
	b _0224324C
_022431D4:
	add r0, r4, #0
	bl ov83_022433F8
	cmp r0, #1
	bne _0224324C
	ldrb r0, [r4, #0x10]
	cmp r0, #1
	bne _022431F0
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #2
	bl ov83_02244CD4
	b _0224324C
_022431F0:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _02243206
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #3
	bl ov83_02244CD4
	b _0224324C
_02243206:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #4
	bl ov83_02244CD4
	b _0224324C
_02243212:
	add r0, r4, #0
	bl ov83_02243C88
	cmp r0, #1
	bne _0224324C
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #1
	bl ov83_02244CD4
	b _0224324C
_02243228:
	add r0, r4, #0
	bl ov83_02243D7C
	cmp r0, #1
	bne _0224324C
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #4
	bl ov83_02244CD4
	b _0224324C
_0224323E:
	add r0, r4, #0
	bl ov83_02243DE8
	cmp r0, #1
	bne _0224324C
	mov r0, #1
	pop {r3, r4, r5, pc}
_0224324C:
	add r0, r4, #0
	bl ov83_022459AC
	mov r0, #0xb2
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl SpriteList_RenderAndAnimateSprites
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02243260: .word 0x000005B6
_02243264: .word 0x00000504
	thumb_func_end ov83_02243108

	thumb_func_start ov83_02243268
ov83_02243268: ; 0x02243268
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	ldr r0, _022432A8 ; =0x00000548
	ldrb r1, [r4, #0xd]
	ldr r0, [r4, r0]
	strh r1, [r0]
	ldr r0, _022432AC ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	bl GF_DestroyVramTransferManager
	add r0, r4, #0
	bl ov83_02243E30
	add r0, r5, #0
	bl OverlayManager_FreeData
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	mov r0, #0x6b
	bl Heap_Destroy
	ldr r0, _022432B0 ; =FS_OVERLAY_ID(OVY_80)
	bl UnloadOverlayByID
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022432A8: .word 0x00000548
_022432AC: .word 0x04000050
_022432B0: .word FS_OVERLAY_ID(OVY_80)
	thumb_func_end ov83_02243268

	thumb_func_start ov83_022432B4
ov83_022432B4: ; 0x022432B4
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldrb r0, [r4, #8]
	cmp r0, #4
	bhi _022433B0
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022432CC: ; jump table
	.short _022432D6 - _022432CC - 2 ; case 0
	.short _022432F2 - _022432CC - 2 ; case 1
	.short _0224331A - _022432CC - 2 ; case 2
	.short _02243360 - _022432CC - 2 ; case 3
	.short _022433A2 - _022432CC - 2 ; case 4
_022432D6:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _022432EA
	bl sub_02037BEC
	mov r0, #0xd8
	bl sub_02037AC0
_022432EA:
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _022433B0
_022432F2:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _02243312
	mov r0, #0xd8
	bl sub_02037B38
	cmp r0, #1
	bne _022433B0
	bl sub_02037BEC
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _022433B0
_02243312:
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _022433B0
_0224331A:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _0224333A
	add r0, r4, #0
	mov r1, #0x14
	mov r2, #0
	bl ov83_022450A8
	cmp r0, #1
	bne _022433B0
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _022433B0
_0224333A:
	add r0, r4, #0
	bl ov83_022433B8
	mov r0, #6
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	mov r0, #0
	mov r1, #1
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _022433B0
_02243360:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _0224339A
	ldrb r0, [r4, #0x17]
	cmp r0, #2
	blo _022433B0
	mov r0, #0
	strb r0, [r4, #0x17]
	add r0, r4, #0
	bl ov83_022433B8
	mov r0, #6
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	mov r0, #0
	mov r1, #1
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _022433B0
_0224339A:
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _022433B0
_022433A2:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _022433B0
	add sp, #0xc
	mov r0, #1
	pop {r3, r4, pc}
_022433B0:
	mov r0, #0
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov83_022432B4

	thumb_func_start ov83_022433B8
ov83_022433B8: ; 0x022433B8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r5, #0
	add r4, #0x50
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r5, #0
	add r1, r4, #0
	bl ov83_02245584
	add r0, r5, #0
	add r1, r4, #0
	bl ov83_022453DC
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0x80
	bl ov83_022448E4
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0x70
	bl ov83_022449D4
	add r0, r5, #0
	bl ov83_02244BEC
	bl GfGfx_BothDispOn
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_022433B8

	thumb_func_start ov83_022433F8
ov83_022433F8: ; 0x022433F8
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldrb r1, [r4, #8]
	cmp r1, #0x12
	bhi _022434BA
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224340E: ; jump table
	.short _02243434 - _0224340E - 2 ; case 0
	.short _0224348E - _0224340E - 2 ; case 1
	.short _022434F6 - _0224340E - 2 ; case 2
	.short _0224361E - _0224340E - 2 ; case 3
	.short _022436D4 - _0224340E - 2 ; case 4
	.short _022437D8 - _0224340E - 2 ; case 5
	.short _022438AE - _0224340E - 2 ; case 6
	.short _02243A36 - _0224340E - 2 ; case 7
	.short _02243A76 - _0224340E - 2 ; case 8
	.short _02243AB6 - _0224340E - 2 ; case 9
	.short _02243B5A - _0224340E - 2 ; case 10
	.short _02243B86 - _0224340E - 2 ; case 11
	.short _02243B92 - _0224340E - 2 ; case 12
	.short _02243BBC - _0224340E - 2 ; case 13
	.short _02243BCE - _0224340E - 2 ; case 14
	.short _02243BE0 - _0224340E - 2 ; case 15
	.short _02243BFA - _0224340E - 2 ; case 16
	.short _02243C1C - _0224340E - 2 ; case 17
	.short _02243C4C - _0224340E - 2 ; case 18
_02243434:
	mov r0, #0
	strb r0, [r4, #0xb]
	mov r0, #1
	strb r0, [r4, #8]
	ldrb r0, [r4, #0xf]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1b
	cmp r0, #1
	bne _02243456
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244BEC
	b _02243484
_02243456:
	cmp r0, #2
	bne _0224347C
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244C9C
	mov r0, #0x15
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	mov r1, #0xc8
	mov r2, #0x69
	bl ov83_02247630
	mov r0, #6
	strb r0, [r4, #8]
	b _02243484
_0224347C:
	cmp r0, #3
	bne _02243484
	mov r0, #0xe
	strb r0, [r4, #8]
_02243484:
	ldrb r1, [r4, #0xf]
	mov r0, #0xf8
	bic r1, r0
	strb r1, [r4, #0xf]
	b _02243C7A
_0224348E:
	mov r0, #0x5f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl ov83_02247AD4
	cmp r0, #4
	bhi _022434B2
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022434A8: ; jump table
	.short _022434BC - _022434A8 - 2 ; case 0
	.short _022434BC - _022434A8 - 2 ; case 1
	.short _022434BC - _022434A8 - 2 ; case 2
	.short _022434BC - _022434A8 - 2 ; case 3
	.short _022434CE - _022434A8 - 2 ; case 4
_022434B2:
	mov r1, #1
	mvn r1, r1
	cmp r0, r1
	beq _022434D8
_022434BA:
	b _02243C7A
_022434BC:
	add r0, r4, #0
	bl ov83_02244C4C
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
	b _02243C7A
_022434CE:
	ldr r0, _022437F0 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	pop {r3, r4, r5, pc}
_022434D8:
	ldrb r1, [r4, #0xd]
	ldrb r0, [r4, #0x15]
	cmp r1, r0
	beq _0224351A
	mov r0, #0x5f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl ov83_02247B04
	ldrb r2, [r4, #0xd]
	add r0, r4, #0
	mov r1, #4
	bl ov83_022469D8
	b _02243C7A
_022434F6:
	ldr r0, _022437F4 ; =0x000005F8
	ldr r0, [r4, r0]
	bl TouchscreenListMenu_HandleInput
	ldr r1, _022437F0 ; =0x000005DC
	add r5, r0, #0
	bl ov83_022477B0
	add r0, r4, #0
	bl ov83_02246CC0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	bhi _02243536
	bhs _0224360C
	cmp r5, #6
	bls _0224351C
_0224351A:
	b _02243C7A
_0224351C:
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02243528: ; jump table
	.short _0224353E - _02243528 - 2 ; case 0
	.short _022435C6 - _02243528 - 2 ; case 1
	.short _022435FA - _02243528 - 2 ; case 2
	.short _02243C7A - _02243528 - 2 ; case 3
	.short _02243C7A - _02243528 - 2 ; case 4
	.short _02243C7A - _02243528 - 2 ; case 5
	.short _0224360C - _02243528 - 2 ; case 6
_02243536:
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	b _02243C7A
_0224353E:
	strb r5, [r4, #0x13]
	ldrb r0, [r4, #0x14]
	ldrb r1, [r4, #0xd]
	bl ov83_02247768
	ldr r1, _022437F8 ; =0x0000054C
	ldr r1, [r4, r1]
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _02243584
	add r0, r4, #0
	bl ov83_02244C88
	add r0, r4, #0
	bl ov83_022453C0
	mov r1, #0
	add r0, r4, #0
	mov r2, #1
	mov r3, #4
	str r1, [sp]
	bl ov83_02244A98
	add r0, r4, #0
	mov r1, #0x10
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	add r0, r4, #0
	bl ov83_02244A74
	mov r0, #3
	strb r0, [r4, #8]
	b _02243C7A
_02243584:
	add r0, r4, #0
	bl ov83_02244C88
	ldrb r0, [r4, #0x14]
	ldrb r1, [r4, #0xd]
	bl ov83_02247768
	add r1, r0, #0
	ldr r0, _022437FC ; =0x0000055C
	ldr r0, [r4, r0]
	bl Party_GetMonByIndex
	add r5, r0, #0
	add r0, r4, #0
	bl ov83_022453C0
	add r0, r5, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #0
	bl ov83_02244AB0
	add r0, r4, #0
	mov r1, #0x14
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	mov r0, #0x10
	strb r0, [r4, #8]
	b _02243C7A
_022435C6:
	add r0, r4, #0
	strb r5, [r4, #0x13]
	bl ov83_02244C88
	add r0, r4, #0
	bl ov83_022453C0
	mov r2, #0x17
	lsl r2, r2, #6
	ldr r2, [r4, r2]
	add r0, r4, #0
	mov r1, #0
	bl ov83_02244AB0
	add r0, r4, #0
	mov r1, #0x15
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	add r0, r4, #0
	bl ov83_02244A88
	mov r0, #4
	strb r0, [r4, #8]
	b _02243C7A
_022435FA:
	add r0, r4, #0
	bl ov83_02244C88
	add r0, r4, #0
	bl ov83_02244C9C
	mov r0, #6
	strb r0, [r4, #8]
	b _02243C7A
_0224360C:
	add r0, r4, #0
	bl ov83_02244C88
	add r0, r4, #0
	bl ov83_02244BEC
	mov r0, #0
	strb r0, [r4, #8]
	b _02243C7A
_0224361E:
	ldr r0, _02243800 ; =0x00000604
	ldr r0, [r4, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _02243630
	cmp r0, #2
	beq _022436B8
	b _02243C7A
_02243630:
	ldr r0, _02243800 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	add r5, r0, #0
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r1, r5, #0
	bl FrontierSave_GetStat
	cmp r0, #1
	bhs _02243678
	add r0, r4, #0
	bl ov83_022453C0
	add r0, r4, #0
	mov r1, #0x1c
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	mov r0, #0x10
	strb r0, [r4, #8]
	b _02243C7A
_02243678:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _022436B2
	ldrb r1, [r4, #9]
	ldr r0, [r4, #4]
	mov r2, #1
	bl ov80_02237FA4
	add r1, r4, #0
	add r0, r4, #0
	add r1, #0x50
	bl ov83_022453DC
	ldrb r1, [r4, #0xd]
	add r0, r4, #0
	bl ov83_02245748
	add r0, r4, #0
	bl ov83_02246988
	add r0, r4, #0
	mov r1, #0
	bl ov83_02246114
	mov r0, #0xb
	strb r0, [r4, #8]
	b _02243C7A
_022436B2:
	mov r0, #1
	strb r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_022436B8:
	ldr r0, _02243800 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
	b _02243C7A
_022436D4:
	ldr r0, _022437F4 ; =0x000005F8
	ldr r0, [r4, r0]
	bl TouchscreenListMenu_HandleInput
	ldr r1, _022437F0 ; =0x000005DC
	add r5, r0, #0
	bl ov83_022477B0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	bhi _02243700
	bhs _02243706
	cmp r5, #2
	bhi _022436FE
	cmp r5, #0
	beq _02243720
	cmp r5, #1
	beq _0224377C
	cmp r5, #2
	beq _02243706
_022436FE:
	b _02243C7A
_02243700:
	add r0, r0, #1
	cmp r5, r0
	b _02243C7A
_02243706:
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244A90
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
	b _02243C7A
_02243720:
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	add r5, r0, #0
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r1, r5, #0
	bl FrontierSave_GetStat
	add r0, r4, #0
	bl ov83_02244A90
	ldrb r0, [r4, #0x14]
	ldrb r1, [r4, #0xd]
	bl ov83_02247768
	mov r1, #0x55
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	ldrb r0, [r1, r0]
	cmp r0, #1
	bne _0224376E
	add r0, r4, #0
	bl ov83_022453C0
	add r0, r4, #0
	mov r1, #0x1d
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	mov r0, #0x10
	strb r0, [r4, #8]
	b _02243C7A
_0224376E:
	add r0, r4, #0
	mov r1, #1
	bl ov83_02245554
	mov r0, #5
	strb r0, [r4, #8]
	b _02243C7A
_0224377C:
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	add r5, r0, #0
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r1, r5, #0
	bl FrontierSave_GetStat
	add r0, r4, #0
	bl ov83_02244A90
	ldrb r0, [r4, #0x14]
	ldrb r1, [r4, #0xd]
	bl ov83_02247768
	mov r1, #0x55
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	ldrb r0, [r1, r0]
	cmp r0, #2
	bne _022437CA
	add r0, r4, #0
	bl ov83_022453C0
	add r0, r4, #0
	mov r1, #0x1e
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	mov r0, #0x10
	strb r0, [r4, #8]
	b _02243C7A
_022437CA:
	add r0, r4, #0
	mov r1, #2
	bl ov83_02245554
	mov r0, #5
	strb r0, [r4, #8]
	b _02243C7A
_022437D8:
	ldr r0, _02243800 ; =0x00000604
	ldr r0, [r4, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _022437EA
	cmp r0, #2
	beq _02243892
	b _02243C7A
_022437EA:
	ldr r0, _02243800 ; =0x00000604
	b _02243804
	nop
_022437F0: .word 0x000005DC
_022437F4: .word 0x000005F8
_022437F8: .word 0x0000054C
_022437FC: .word 0x0000055C
_02243800: .word 0x00000604
_02243804:
	add r0, r4, r0
	bl ov83_022478B4
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	add r5, r0, #0
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r1, r5, #0
	bl FrontierSave_GetStat
	add r5, r0, #0
	ldrb r0, [r4, #0xe]
	bl ov83_02245068
	cmp r5, r0
	bhs _0224384C
	add r0, r4, #0
	bl ov83_022453C0
	add r0, r4, #0
	mov r1, #0x1c
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	mov r0, #0x10
	strb r0, [r4, #8]
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224384C:
	ldrb r0, [r4, #0xe]
	strb r0, [r4, #0x12]
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _0224388C
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	ldrb r0, [r4, #0xe]
	bl ov83_02245068
	add r2, r0, #0
	ldrb r1, [r4, #9]
	ldr r0, [r4, #4]
	bl ov80_02237FA4
	add r1, r4, #0
	add r0, r4, #0
	add r1, #0x50
	bl ov83_022453DC
	ldrb r1, [r4, #0xd]
	ldrb r2, [r4, #0xe]
	add r0, r4, #0
	bl ov83_02245838
	mov r0, #0xc
	strb r0, [r4, #8]
	b _02243C7A
_0224388C:
	mov r0, #1
	strb r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_02243892:
	ldr r0, _02243BA8 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
	b _02243C7A
_022438AE:
	ldr r0, _02243BAC ; =0x000005F8
	ldr r0, [r4, r0]
	bl TouchscreenListMenu_HandleInput
	ldr r1, _02243BB0 ; =0x000005DC
	add r5, r0, #0
	bl ov83_022477B0
	add r0, r4, #0
	bl ov83_02246D40
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	bhi _022438E2
	bhs _022438E8
	cmp r5, #5
	bhi _022438E0
	cmp r5, #3
	blo _022438E0
	beq _02243902
	cmp r5, #4
	beq _0224394E
	cmp r5, #5
	beq _022439C0
_022438E0:
	b _02243C7A
_022438E2:
	add r0, r0, #1
	cmp r5, r0
	b _02243C7A
_022438E8:
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244CCC
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
	b _02243C7A
_02243902:
	strb r5, [r4, #0x13]
	add r0, r4, #0
	bl ov83_02244CCC
	ldrb r0, [r4, #0x14]
	ldrb r1, [r4, #0xd]
	bl ov83_02247768
	ldr r1, _02243BB4 ; =0x00000554
	ldr r1, [r4, r1]
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _02243948
	add r0, r4, #0
	bl ov83_022453C0
	mov r1, #0
	add r0, r4, #0
	mov r2, #2
	mov r3, #4
	str r1, [sp]
	bl ov83_02244A98
	add r0, r4, #0
	mov r1, #0x2b
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	add r0, r4, #0
	bl ov83_02244A74
	mov r0, #7
	strb r0, [r4, #8]
	b _02243C7A
_02243948:
	mov r0, #0x11
	strb r0, [r4, #8]
	b _02243C7A
_0224394E:
	add r0, r4, #0
	strb r5, [r4, #0x13]
	bl ov83_02244CCC
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r4, #9]
	ldr r0, [r4, r0]
	mov r2, #2
	bl ov83_0224777C
	cmp r0, #1
	bne _0224397C
	add r0, r4, #0
	mov r1, #0x2a
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	mov r0, #0xf
	strb r0, [r4, #8]
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224397C:
	ldrb r0, [r4, #0x14]
	ldrb r1, [r4, #0xd]
	bl ov83_02247768
	ldr r1, _02243BB8 ; =0x00000558
	ldr r1, [r4, r1]
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _022439BA
	add r0, r4, #0
	bl ov83_022453C0
	mov r1, #0
	add r0, r4, #0
	mov r2, #5
	mov r3, #4
	str r1, [sp]
	bl ov83_02244A98
	add r0, r4, #0
	mov r1, #0x4f
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	add r0, r4, #0
	bl ov83_02244A74
	mov r0, #8
	strb r0, [r4, #8]
	b _02243C7A
_022439BA:
	mov r0, #0x12
	strb r0, [r4, #8]
	b _02243C7A
_022439C0:
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r4, #9]
	ldr r0, [r4, r0]
	mov r2, #2
	bl ov83_0224777C
	cmp r0, #2
	bne _022439EC
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244CCC
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
	b _02243C7A
_022439EC:
	strb r5, [r4, #0x13]
	add r0, r4, #0
	bl ov83_02244CCC
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	add r5, r0, #0
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r1, r5, #0
	bl FrontierSave_GetStat
	mov r1, #0
	add r0, r4, #0
	mov r2, #0x32
	mov r3, #4
	str r1, [sp]
	bl ov83_02244A98
	add r0, r4, #0
	mov r1, #0x5b
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	add r0, r4, #0
	bl ov83_02244A74
	mov r0, #9
	strb r0, [r4, #8]
	b _02243C7A
_02243A36:
	ldr r0, _02243BA8 ; =0x00000604
	ldr r0, [r4, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _02243A48
	cmp r0, #2
	beq _02243A62
	b _02243C7A
_02243A48:
	ldr r0, _02243BA8 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x2e
	bl ov83_02245A40
	cmp r0, #1
	bne _02243A86
	mov r0, #1
	pop {r3, r4, r5, pc}
_02243A62:
	ldr r0, _02243BA8 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	bl ov83_02244C9C
	mov r0, #6
	strb r0, [r4, #8]
	b _02243C7A
_02243A76:
	ldr r0, _02243BA8 ; =0x00000604
	ldr r0, [r4, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _02243A88
	cmp r0, #2
	beq _02243AA2
_02243A86:
	b _02243C7A
_02243A88:
	ldr r0, _02243BA8 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x52
	bl ov83_02245A40
	cmp r0, #1
	bne _02243AC6
	mov r0, #1
	pop {r3, r4, r5, pc}
_02243AA2:
	ldr r0, _02243BA8 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	bl ov83_02244C9C
	mov r0, #6
	strb r0, [r4, #8]
	b _02243C7A
_02243AB6:
	ldr r0, _02243BA8 ; =0x00000604
	ldr r0, [r4, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _02243AC8
	cmp r0, #2
	beq _02243B46
_02243AC6:
	b _02243C7A
_02243AC8:
	ldr r0, _02243BA8 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	add r5, r0, #0
	ldrb r0, [r4, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r4, #4]
	add r1, r5, #0
	bl FrontierSave_GetStat
	add r5, r0, #0
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r4, #9]
	ldr r0, [r4, r0]
	mov r2, #2
	bl ov83_0224777C
	cmp r5, #0x32
	bhs _02243B26
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02247944
	add r0, r4, #0
	mov r1, #0x52
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r4, #0xa]
	mov r0, #0xf
	strb r0, [r4, #8]
	b _02243C7A
_02243B26:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02243B40
	ldrb r1, [r4, #0xd]
	add r0, r4, #0
	mov r2, #5
	bl ov83_02245ACC
	mov r0, #0xa
	strb r0, [r4, #8]
	b _02243C7A
_02243B40:
	mov r0, #1
	strb r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_02243B46:
	ldr r0, _02243BA8 ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	add r0, r4, #0
	bl ov83_02244C9C
	mov r0, #6
	strb r0, [r4, #8]
	b _02243C7A
_02243B5A:
	bl ov83_02247CF0
	cmp r0, #1
	beq _02243B64
	b _02243C7A
_02243B64:
	add r0, r4, #0
	bl ov83_02244C9C
	add r0, r4, #0
	mov r1, #0
	bl ov83_02246114
	mov r0, #0x15
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	mov r1, #0xc8
	mov r2, #0x69
	bl ov83_02247630
	mov r0, #6
	strb r0, [r4, #8]
	b _02243C7A
_02243B86:
	add r1, r4, #0
	add r1, #0x80
	bl ov83_022448E4
	mov r0, #0xc
	strb r0, [r4, #8]
_02243B92:
	ldrb r1, [r4, #0xd]
	ldrb r2, [r4, #0x13]
	add r0, r4, #0
	bl ov83_02244E24
	cmp r0, #1
	bne _02243C7A
	mov r0, #0x10
	strb r0, [r4, #8]
	b _02243C7A
	nop
_02243BA8: .word 0x00000604
_02243BAC: .word 0x000005F8
_02243BB0: .word 0x000005DC
_02243BB4: .word 0x00000554
_02243BB8: .word 0x00000558
_02243BBC:
	ldrb r1, [r4, #0xd]
	ldrb r2, [r4, #0x13]
	bl ov83_02244E24
	cmp r0, #1
	bne _02243C7A
	mov r0, #0xe
	strb r0, [r4, #8]
	b _02243C7A
_02243BCE:
	ldrb r0, [r4, #0x13]
	cmp r0, #3
	bne _02243BDA
	mov r0, #0x11
	strb r0, [r4, #8]
	b _02243C7A
_02243BDA:
	mov r0, #0x12
	strb r0, [r4, #8]
	b _02243C7A
_02243BE0:
	bl ov83_02247CF0
	cmp r0, #1
	bne _02243C7A
	ldr r0, _02243C80 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov83_02244C9C
	mov r0, #6
	strb r0, [r4, #8]
	b _02243C7A
_02243BFA:
	bl ov83_02247CF0
	cmp r0, #1
	bne _02243C7A
	ldr r0, _02243C80 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02244BEC
	mov r0, #0
	strb r0, [r4, #8]
	b _02243C7A
_02243C1C:
	ldr r0, _02243C84 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	bne _02243C7A
	mov r0, #0x10
	tst r0, r1
	bne _02243C7A
	bl ov83_02247CF0
	cmp r0, #1
	bne _02243C7A
	ldr r0, _02243C80 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov83_022459A0
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
	b _02243C7A
_02243C4C:
	ldr r0, _02243C84 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	bne _02243C7A
	mov r0, #0x10
	tst r0, r1
	bne _02243C7A
	bl ov83_02247CF0
	cmp r0, #1
	bne _02243C7A
	ldr r0, _02243C80 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov83_022459A0
	add r0, r4, #0
	bl ov83_02244C58
	mov r0, #2
	strb r0, [r4, #8]
_02243C7A:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_02243C80: .word 0x000005DC
_02243C84: .word gSystem
	thumb_func_end ov83_022433F8

	thumb_func_start ov83_02243C88
ov83_02243C88: ; 0x02243C88
	push {r4, lr}
	add r4, r0, #0
	ldrb r1, [r4, #8]
	cmp r1, #5
	bhi _02243D74
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02243C9E: ; jump table
	.short _02243CAA - _02243C9E - 2 ; case 0
	.short _02243CCE - _02243C9E - 2 ; case 1
	.short _02243CF4 - _02243C9E - 2 ; case 2
	.short _02243D16 - _02243C9E - 2 ; case 3
	.short _02243D34 - _02243C9E - 2 ; case 4
	.short _02243D46 - _02243C9E - 2 ; case 5
_02243CAA:
	ldrb r2, [r4, #0xf]
	mov r1, #0xf8
	bic r2, r1
	mov r1, #8
	orr r1, r2
	strb r1, [r4, #0xf]
	ldrb r2, [r4, #0xd]
	mov r1, #0x15
	bl ov83_022450A8
	cmp r0, #1
	bne _02243D74
	mov r0, #0
	strb r0, [r4, #0x10]
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243D74
_02243CCE:
	ldrb r1, [r4, #0x11]
	cmp r1, #0xff
	beq _02243D74
	mov r1, #0
	strb r1, [r4, #0x17]
	ldrb r2, [r4, #0x13]
	ldrb r1, [r4, #0x11]
	cmp r2, #5
	bne _02243CE8
	mov r2, #5
	bl ov83_02245ACC
	b _02243CEC
_02243CE8:
	bl ov83_0224563C
_02243CEC:
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243D74
_02243CF4:
	ldrb r0, [r4, #0x15]
	ldrb r1, [r4, #0x11]
	bl ov83_0224776C
	add r1, r0, #0
	ldrb r2, [r4, #0x13]
	add r0, r4, #0
	bl ov83_02244E24
	cmp r0, #1
	bne _02243D74
	mov r0, #0x1e
	strb r0, [r4, #0x16]
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243D74
_02243D16:
	ldrb r0, [r4, #0x16]
	sub r0, r0, #1
	strb r0, [r4, #0x16]
	ldrb r0, [r4, #0x16]
	cmp r0, #0
	bne _02243D74
	bl sub_02037BEC
	mov r0, #0x85
	bl sub_02037AC0
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243D74
_02243D34:
	mov r0, #0x85
	bl sub_02037B38
	cmp r0, #1
	bne _02243D74
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243D74
_02243D46:
	ldrb r0, [r4, #0x15]
	ldrb r1, [r4, #0x11]
	bl ov83_0224776C
	add r1, r0, #0
	ldrb r2, [r4, #0x13]
	add r0, r4, #0
	bl ov83_02244F60
	cmp r0, #1
	bne _02243D74
	bl sub_02037BEC
	mov r0, #0x6b
	bl sub_020379A0
	mov r0, #0xff
	strb r0, [r4, #0x11]
	ldr r0, _02243D78 ; =0x000005B6
	mov r1, #0
	strb r1, [r4, r0]
	mov r0, #1
	pop {r4, pc}
_02243D74:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_02243D78: .word 0x000005B6
	thumb_func_end ov83_02243C88

	thumb_func_start ov83_02243D7C
ov83_02243D7C: ; 0x02243D7C
	push {r4, lr}
	add r4, r0, #0
	ldrb r1, [r4, #8]
	cmp r1, #0
	beq _02243D90
	cmp r1, #1
	beq _02243DA8
	cmp r1, #2
	beq _02243DCA
	b _02243DE4
_02243D90:
	mov r1, #0x17
	mov r2, #0
	bl ov83_022450A8
	cmp r0, #1
	bne _02243DE4
	mov r0, #0x1e
	strb r0, [r4, #0x16]
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243DE4
_02243DA8:
	ldrb r0, [r4, #0x16]
	cmp r0, #0
	beq _02243DB2
	sub r0, r0, #1
	strb r0, [r4, #0x16]
_02243DB2:
	ldrb r0, [r4, #0x16]
	cmp r0, #0
	bne _02243DE4
	bl sub_02037BEC
	mov r0, #0x86
	bl sub_02037AC0
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243DE4
_02243DCA:
	mov r0, #0x86
	bl sub_02037B38
	cmp r0, #1
	bne _02243DE4
	bl sub_02037BEC
	add r4, #0xc0
	add r0, r4, #0
	bl ov83_02245094
	mov r0, #1
	pop {r4, pc}
_02243DE4:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov83_02243D7C

	thumb_func_start ov83_02243DE8
ov83_02243DE8: ; 0x02243DE8
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldrb r0, [r4, #8]
	cmp r0, #0
	beq _02243DFA
	cmp r0, #1
	beq _02243E1A
	b _02243E28
_02243DFA:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x6b
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldrb r0, [r4, #8]
	add r0, r0, #1
	strb r0, [r4, #8]
	b _02243E28
_02243E1A:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _02243E28
	add sp, #0xc
	mov r0, #1
	pop {r3, r4, pc}
_02243E28:
	mov r0, #0
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov83_02243DE8

	thumb_func_start ov83_02243E30
ov83_02243E30: ; 0x02243E30
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	ldr r1, _02243F80 ; =0x00000604
	str r0, [sp]
	add r0, r0, r1
	bl ov83_02247858
	ldr r1, _02243F84 ; =0x000005F4
	ldr r0, [sp]
	ldr r0, [r0, r1]
	bl ov83_02247CC4
	mov r1, #0x5f
	ldr r0, [sp]
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	bl ov83_02247A18
	ldr r1, _02243F88 ; =0x00000508
	ldr r0, [sp]
	ldr r0, [r0, r1]
	bl ov83_0224753C
	ldr r1, _02243F8C ; =0x0000050C
	ldr r0, [sp]
	ldr r0, [r0, r1]
	bl ov83_0224753C
	mov r1, #0x15
	ldr r0, [sp]
	lsl r1, r1, #6
	ldr r0, [r0, r1]
	bl ov83_0224753C
	ldr r1, _02243F90 ; =0x00000544
	ldr r0, [sp]
	ldr r0, [r0, r1]
	bl ov83_0224753C
	mov r0, #0
	mov r6, #0x52
	ldr r7, [sp]
	str r0, [sp, #4]
	lsl r6, r6, #4
_02243E88:
	mov r4, #0
	add r5, r7, #0
_02243E8C:
	ldr r0, [r5, r6]
	bl ov83_0224753C
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #2
	blt _02243E8C
	ldr r0, [sp, #4]
	add r7, #8
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #4
	blt _02243E88
	ldr r0, [sp]
	mov r1, #1
	ldrb r0, [r0, #9]
	bl ov80_02237B58
	add r6, r0, #0
	mov r5, #0
	cmp r6, #0
	ble _02243EDC
	mov r7, #0x51
	ldr r4, [sp]
	lsl r7, r7, #4
_02243EBE:
	ldr r0, _02243F94 ; =0x000004F4
	ldr r0, [r4, r0]
	bl ov83_0224753C
	ldr r0, _02243F98 ; =0x000004E4
	ldr r0, [r4, r0]
	bl ov83_0224753C
	ldr r0, [r4, r7]
	bl ov83_0224753C
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, r6
	blt _02243EBE
_02243EDC:
	bl sub_0203A914
	mov r1, #0x2b
	ldr r0, [sp]
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	mov r1, #2
	bl PaletteData_FreeBuffers
	mov r1, #0x2b
	ldr r0, [sp]
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	mov r1, #0
	bl PaletteData_FreeBuffers
	mov r1, #0x2b
	ldr r0, [sp]
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	bl PaletteData_Free
	mov r1, #0x2b
	ldr r0, [sp]
	mov r2, #0
	lsl r1, r1, #4
	str r2, [r0, r1]
	add r1, #0x18
	add r0, r0, r1
	bl ov83_022471FC
	ldr r0, [sp]
	ldr r0, [r0, #0x20]
	bl DestroyMsgData
	ldr r0, [sp]
	ldr r0, [r0, #0x24]
	bl MessageFormat_Delete
	ldr r0, [sp]
	ldr r0, [r0, #0x28]
	bl String_Delete
	ldr r0, [sp]
	ldr r0, [r0, #0x2c]
	bl String_Delete
	mov r1, #0xad
	ldr r0, [sp]
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bl MessagePrinter_Delete
	mov r0, #4
	bl FontID_Release
	ldr r4, [sp]
	mov r5, #0
_02243F50:
	ldr r0, [r4, #0x30]
	bl String_Delete
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #3
	blt _02243F50
	ldr r0, [sp]
	mov r1, #1
	add r0, #0x50
	bl ov83_0224791C
	ldr r0, [sp]
	ldr r0, [r0, #0x4c]
	bl ov83_0224442C
	mov r1, #0x56
	ldr r0, [sp]
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	bl NARC_Delete
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02243F80: .word 0x00000604
_02243F84: .word 0x000005F4
_02243F88: .word 0x00000508
_02243F8C: .word 0x0000050C
_02243F90: .word 0x00000544
_02243F94: .word 0x000004F4
_02243F98: .word 0x000004E4
	thumb_func_end ov83_02243E30

	thumb_func_start ov83_02243F9C
ov83_02243F9C: ; 0x02243F9C
	push {r3, lr}
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	mov r0, #0
	add r1, r0, #0
	bl Main_SetHBlankIntrCB
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _02243FCC ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _02243FD0 ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	pop {r3, pc}
	.balign 4, 0
_02243FCC: .word 0xFFFFE0FF
_02243FD0: .word 0x04001000
	thumb_func_end ov83_02243F9C

	thumb_func_start ov83_02243FD4
ov83_02243FD4: ; 0x02243FD4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x38
	add r5, r0, #0
	mov r0, #0xb7
	mov r1, #0x6b
	bl NARC_New
	mov r1, #0x56
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r5, #0
	bl ov83_02244394
	add r0, r5, #0
	bl ov83_02244408
	mov r0, #4
	mov r1, #0x6b
	bl FontID_Alloc
	mov r0, #1
	mov r1, #0x1b
	mov r2, #0x21
	mov r3, #0x6b
	bl NewMsgDataFromNarc
	str r0, [r5, #0x20]
	mov r0, #0x6b
	bl MessageFormat_New
	str r0, [r5, #0x24]
	mov r0, #0x96
	lsl r0, r0, #2
	mov r1, #0x6b
	bl String_New
	str r0, [r5, #0x28]
	mov r0, #0x96
	lsl r0, r0, #2
	mov r1, #0x6b
	bl String_New
	str r0, [r5, #0x2c]
	mov r6, #0
	add r4, r5, #0
	mov r7, #0x20
_02244030:
	add r0, r7, #0
	mov r1, #0x6b
	bl String_New
	str r0, [r4, #0x30]
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #3
	blt _02244030
	mov r1, #7
	mov r0, #0
	lsl r1, r1, #6
	mov r2, #0x6b
	bl LoadFontPal0
	mov r1, #0x1a
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #0x6b
	bl LoadFontPal1
	mov r0, #1
	mov r1, #2
	mov r2, #0
	mov r3, #0x6b
	bl MessagePrinter_New
	mov r1, #0xad
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r1, r5, #0
	ldr r0, [r5, #0x4c]
	add r1, #0x50
	mov r2, #1
	bl ov83_022478D4
	add r0, sp, #0x28
	add r1, sp, #0x2c
	add r3, sp, #0x28
	str r0, [sp]
	add r0, r5, #0
	add r1, #2
	add r2, sp, #0x2c
	add r3, #2
	bl ov83_02244DF4
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _0224409E
	mov r0, #0x3c
	mov r7, #0x40
	str r0, [sp, #0x1c]
	b _022440A4
_0224409E:
	mov r0, #0x1c
	mov r7, #0x20
	str r0, [sp, #0x1c]
_022440A4:
	ldrb r0, [r5, #9]
	mov r1, #1
	bl ov80_02237B58
	mov r6, #0
	str r0, [sp, #0x18]
	cmp r0, #0
	ble _022441AC
	add r4, r5, #0
_022440B6:
	mov r0, #7
	str r0, [sp]
	ldr r0, [sp, #0x1c]
	mov r1, #0
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #4]
	mov r0, #0x3e
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	mov r0, #0xb2
	lsl r0, r0, #2
	add r0, r5, r0
	add r2, r1, #0
	add r3, r1, #0
	bl ov83_02247454
	ldr r1, _02244370 ; =0x000004F4
	str r0, [r4, r1]
	mov r1, #0
	mov r0, #0xf
	str r0, [sp]
	lsl r0, r7, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #4]
	mov r0, #0x4e
	str r0, [sp, #8]
	mov r0, #3
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	mov r0, #0xb2
	lsl r0, r0, #2
	add r0, r5, r0
	add r2, r1, #0
	add r3, r1, #0
	bl ov83_02247454
	mov r1, #0x51
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #1
	str r0, [sp]
	lsl r0, r7, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #4]
	mov r0, #0x3a
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	mov r0, #0xb2
	lsl r0, r0, #2
	add r1, r6, #0
	add r0, r5, r0
	add r1, #0xa
	mov r2, #0xa
	mov r3, #5
	bl ov83_02247454
	ldr r1, _02244374 ; =0x000004E4
	str r0, [r4, r1]
	add r0, r1, #0
	add r0, #0x78
	ldr r0, [r5, r0]
	add r1, r6, #0
	bl Party_GetMonByIndex
	add r1, r0, #0
	ldr r0, _02244374 ; =0x000004E4
	ldr r0, [r4, r0]
	bl ov83_022475EC
	ldr r0, _02244378 ; =0x0000054C
	ldr r0, [r5, r0]
	ldrb r0, [r0, r6]
	cmp r0, #0
	ldr r0, _02244370 ; =0x000004F4
	bne _0224417C
	ldr r0, [r4, r0]
	mov r1, #1
	bl ov83_0224755C
	ldr r0, _02244374 ; =0x000004E4
	mov r1, #0
	ldr r0, [r4, r0]
	bl ov83_0224755C
	mov r0, #0x51
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl ov83_0224755C
	b _0224419A
_0224417C:
	ldr r0, [r4, r0]
	mov r1, #0
	bl ov83_0224755C
	ldr r0, _02244374 ; =0x000004E4
	mov r1, #1
	ldr r0, [r4, r0]
	bl ov83_0224755C
	mov r0, #0x51
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl ov83_0224755C
_0224419A:
	ldr r0, [sp, #0x1c]
	add r6, r6, #1
	add r0, #0x40
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x18]
	add r4, r4, #4
	add r7, #0x40
	cmp r6, r0
	blt _022440B6
_022441AC:
	add r0, r5, #0
	add r1, sp, #0x34
	add r2, sp, #0x30
	mov r3, #0
	bl ov83_02244DA0
	mov r0, #1
	str r0, [sp]
	ldr r0, [sp, #0x34]
	mov r1, #0
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	add r2, r1, #0
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xb2
	lsl r0, r0, #2
	add r0, r5, r0
	add r3, r1, #0
	str r1, [sp, #0x10]
	bl ov83_02247454
	ldr r1, _0224437C ; =0x00000508
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	ldr r1, [sp, #0x34]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	str r1, [sp, #4]
	ldr r1, [sp, #0x30]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	str r1, [sp, #8]
	mov r1, #0
	str r0, [sp, #0xc]
	mov r0, #0xb2
	lsl r0, r0, #2
	add r0, r5, r0
	add r2, r1, #0
	add r3, r1, #0
	str r1, [sp, #0x10]
	bl ov83_02247454
	ldr r1, _02244380 ; =0x0000050C
	str r0, [r5, r1]
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02244226
	ldr r0, _02244380 ; =0x0000050C
	mov r1, #0
	ldr r0, [r5, r0]
	bl ov83_0224755C
_02244226:
	mov r0, #0
	str r0, [sp, #0x14]
	str r0, [sp, #0x20]
	str r5, [sp, #0x24]
_0224422E:
	mov r7, #0
	ldr r4, [sp, #0x24]
	add r6, r7, #0
_02244234:
	add r0, r5, #0
	add r1, sp, #0x34
	add r2, sp, #0x30
	bl ov83_02245CE8
	mov r0, #0xc
	str r0, [sp]
	ldr r1, [sp, #0x34]
	ldr r0, [sp, #0x20]
	add r0, r1, r0
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #4]
	mov r1, #0
	ldr r0, [sp, #0x30]
	add r2, r1, #0
	add r0, r0, r6
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	mov r0, #0xb2
	lsl r0, r0, #2
	add r0, r5, r0
	add r3, r1, #0
	bl ov83_02247454
	mov r1, #0x52
	lsl r1, r1, #4
	str r0, [r4, r1]
	add r0, r1, #0
	ldr r0, [r4, r0]
	mov r1, #0
	bl ov83_0224755C
	add r7, r7, #1
	add r6, #0xc
	add r4, r4, #4
	cmp r7, #2
	blt _02244234
	ldr r0, [sp, #0x20]
	add r0, #0x40
	str r0, [sp, #0x20]
	ldr r0, [sp, #0x24]
	add r0, #8
	str r0, [sp, #0x24]
	ldr r0, [sp, #0x14]
	add r0, r0, #1
	str r0, [sp, #0x14]
	cmp r0, #4
	blt _0224422E
	add r0, r5, #0
	bl ov83_02245C80
	mov r1, #0
	mov r0, #0xb
	str r0, [sp]
	mov r0, #0x14
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0xb2
	lsl r0, r0, #2
	str r1, [sp, #0xc]
	add r0, r5, r0
	add r2, r1, #0
	add r3, r1, #0
	str r1, [sp, #0x10]
	bl ov83_02247454
	mov r1, #0x15
	lsl r1, r1, #6
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	mov r1, #0
	bl ov83_0224755C
	add r0, r5, #0
	bl ov83_02245D48
	add r0, r5, #0
	bl ov83_02245F24
	add r0, r5, #0
	mov r1, #1
	bl ov83_02246114
	mov r1, #0
	str r1, [sp]
	mov r0, #0x30
	str r0, [sp, #4]
	mov r0, #0x28
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	mov r0, #0xb2
	str r1, [sp, #0x10]
	mov r1, #2
	lsl r0, r0, #2
	add r0, r5, r0
	add r2, r1, #0
	add r3, r1, #0
	bl ov83_022474C4
	ldr r1, _02244384 ; =0x00000544
	str r0, [r5, r1]
	add r0, r5, #0
	bl ov83_02246988
	ldrb r2, [r5, #0x14]
	add r0, r5, #0
	mov r1, #1
	bl ov83_02247A7C
	mov r1, #0x5f
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r1, #0xb2
	lsl r1, r1, #2
	ldr r0, [r5, r1]
	sub r1, #0x18
	ldr r1, [r5, r1]
	bl ov83_02247CB8
	ldr r1, _02244388 ; =0x000005F4
	str r0, [r5, r1]
	add r1, #0x10
	add r0, r5, r1
	bl ov83_02247844
	bl sub_02037474
	cmp r0, #0
	beq _02244354
	mov r0, #1
	mov r1, #0x10
	bl G2dRenderer_SetObjCharTransferReservedRegion
	mov r0, #1
	bl G2dRenderer_SetPlttTransferReservedRegion
	bl sub_0203A880
_02244354:
	mov r0, #0xa
	str r0, [sp]
	ldr r0, _0224438C ; =0x04000050
	mov r1, #0
	mov r2, #0xe
	mov r3, #6
	bl G2x_SetBlendAlpha_
	ldr r0, _02244390 ; =ov83_02244488
	add r1, r5, #0
	bl Main_SetVBlankIntrCB
	add sp, #0x38
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02244370: .word 0x000004F4
_02244374: .word 0x000004E4
_02244378: .word 0x0000054C
_0224437C: .word 0x00000508
_02244380: .word 0x0000050C
_02244384: .word 0x00000544
_02244388: .word 0x000005F4
_0224438C: .word 0x04000050
_02244390: .word ov83_02244488
	thumb_func_end ov83_02243FD4

	thumb_func_start ov83_02244394
ov83_02244394: ; 0x02244394
	push {r4, lr}
	ldr r2, _02244400 ; =0x04000304
	add r4, r0, #0
	ldrh r1, [r2]
	ldr r0, _02244404 ; =0xFFFF7FFF
	and r0, r1
	strh r0, [r2]
	bl ov83_022444C0
	ldr r0, [r4, #0x4c]
	bl ov83_022444E0
	mov r0, #0x6b
	bl PaletteData_Init
	mov r1, #0x2b
	lsl r1, r1, #4
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	mov r1, #2
	lsl r2, r1, #8
	mov r3, #0x6b
	bl PaletteData_AllocBuffers
	mov r2, #0x2b
	lsl r2, r2, #4
	ldr r0, [r4, r2]
	mov r1, #0
	sub r2, #0xb0
	mov r3, #0x6b
	bl PaletteData_AllocBuffers
	add r0, r4, #0
	mov r1, #3
	bl ov83_0224465C
	bl ov83_022446D0
	add r0, r4, #0
	mov r1, #2
	bl ov83_02244704
	bl ov83_0224474C
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r4, #0
	mov r1, #4
	bl ov83_02244780
	pop {r4, pc}
	nop
_02244400: .word 0x04000304
_02244404: .word 0xFFFF7FFF
	thumb_func_end ov83_02244394

	thumb_func_start ov83_02244408
ov83_02244408: ; 0x02244408
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	add r2, r0, #0
	ldr r1, _02244428 ; =0x0000055C
	mov r0, #0xb2
	lsl r0, r0, #2
	lsl r2, r2, #0x18
	ldr r1, [r4, r1]
	add r0, r4, r0
	lsr r2, r2, #0x18
	bl ov83_02246E08
	pop {r4, pc}
	.balign 4, 0
_02244428: .word 0x0000055C
	thumb_func_end ov83_02244408

	thumb_func_start ov83_0224442C
ov83_0224442C: ; 0x0224442C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #3
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #2
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #0
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #1
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	bl Heap_Free
	ldr r2, _02244484 ; =0x04000304
	ldrh r1, [r2]
	lsr r0, r2, #0xb
	orr r0, r1
	strh r0, [r2]
	pop {r4, pc}
	nop
_02244484: .word 0x04000304
	thumb_func_end ov83_0224442C

	thumb_func_start ov83_02244488
ov83_02244488: ; 0x02244488
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2b
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0224449A
	bl PaletteData_PushTransparentBuffers
_0224449A:
	ldr r0, [r4, #0x4c]
	bl DoScheduledBgGpuUpdates
	bl GF_RunVramTransferTasks
	bl OamManager_ApplyAndResetBuffers
	ldr r3, _022444B8 ; =0x027E0000
	ldr r1, _022444BC ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r4, pc}
	nop
_022444B8: .word 0x027E0000
_022444BC: .word 0x00003FF8
	thumb_func_end ov83_02244488

	thumb_func_start ov83_022444C0
ov83_022444C0: ; 0x022444C0
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _022444DC ; =ov83_02248150
	add r3, sp, #0
	mov r2, #5
_022444CA:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _022444CA
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_022444DC: .word ov83_02248150
	thumb_func_end ov83_022444C0

	thumb_func_start ov83_022444E0
ov83_022444E0: ; 0x022444E0
	push {r3, r4, r5, lr}
	sub sp, #0xb8
	ldr r5, _0224463C ; =ov83_02248044
	add r3, sp, #0xa8
	add r4, r0, #0
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r5, _02244640 ; =ov83_02248068
	add r3, sp, #0x8c
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x6b
	bl BG_ClearCharDataRange
	add r0, r4, #0
	mov r1, #1
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02244644 ; =ov83_02248084
	add r3, sp, #0x70
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #0
	str r0, [r3]
	add r0, r4, #0
	add r3, r1, #0
	bl InitBgFromTemplate
	mov r0, #0
	mov r1, #0x20
	add r2, r0, #0
	mov r3, #0x6b
	bl BG_ClearCharDataRange
	add r0, r4, #0
	mov r1, #0
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02244648 ; =ov83_022480A0
	add r3, sp, #0x54
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #2
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x6b
	bl BG_ClearCharDataRange
	add r0, r4, #0
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r5, _0224464C ; =ov83_022480BC
	add r3, sp, #0x38
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
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #3
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x6b
	bl BG_ClearCharDataRange
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02244650 ; =ov83_022480D8
	add r3, sp, #0x1c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #4
	str r0, [r3]
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02244654 ; =ov83_022480F4
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #5
	str r0, [r3]
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #5
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x6b
	bl BG_ClearCharDataRange
	add r0, r4, #0
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r1, _02244658 ; =0x04000008
	mov r0, #3
	ldrh r2, [r1]
	bic r2, r0
	strh r2, [r1]
	mov r0, #2
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	add sp, #0xb8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224463C: .word ov83_02248044
_02244640: .word ov83_02248068
_02244644: .word ov83_02248084
_02244648: .word ov83_022480A0
_0224464C: .word ov83_022480BC
_02244650: .word ov83_022480D8
_02244654: .word ov83_022480F4
_02244658: .word 0x04000008
	thumb_func_end ov83_022444E0

	thumb_func_start ov83_0224465C
ov83_0224465C: ; 0x0224465C
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	add r4, r1, #0
	mov r0, #0x6b
	str r0, [sp, #0xc]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x4c]
	mov r1, #0x30
	add r3, r4, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _022446AE
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x4c]
	mov r1, #0x2c
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
_022446AE:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x4c]
	mov r1, #0x2d
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_0224465C

	thumb_func_start ov83_022446D0
ov83_022446D0: ; 0x022446D0
	push {r3, r4, lr}
	sub sp, #4
	mov r0, #0xb7
	mov r1, #0x9d
	add r2, sp, #0
	mov r3, #0x6b
	bl GfGfxLoader_GetPlttData
	add r4, r0, #0
	ldr r0, [sp]
	mov r1, #0x80
	ldr r0, [r0, #0xc]
	bl DC_FlushRange
	ldr r0, [sp]
	mov r1, #0
	ldr r0, [r0, #0xc]
	mov r2, #0x80
	bl GX_LoadBGPltt
	add r0, r4, #0
	bl Heap_Free
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov83_022446D0

	thumb_func_start ov83_02244704
ov83_02244704: ; 0x02244704
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	add r4, r1, #0
	mov r0, #0x6b
	str r0, [sp, #0xc]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x4c]
	mov r1, #0x30
	add r3, r4, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x4c]
	mov r1, #0x2e
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_02244704

	thumb_func_start ov83_0224474C
ov83_0224474C: ; 0x0224474C
	push {r3, r4, lr}
	sub sp, #4
	mov r0, #0xb7
	mov r1, #0x9d
	add r2, sp, #0
	mov r3, #0x6b
	bl GfGfxLoader_GetPlttData
	add r4, r0, #0
	ldr r0, [sp]
	mov r1, #0x80
	ldr r0, [r0, #0xc]
	bl DC_FlushRange
	ldr r0, [sp]
	mov r1, #0
	ldr r0, [r0, #0xc]
	mov r2, #0x80
	bl GX_LoadBGPltt
	add r0, r4, #0
	bl Heap_Free
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov83_0224474C

	thumb_func_start ov83_02244780
ov83_02244780: ; 0x02244780
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	add r4, r1, #0
	mov r0, #0x6b
	str r0, [sp, #0xc]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x4c]
	mov r1, #0x28
	add r3, r4, #0
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x6b
	str r0, [sp, #0xc]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r2, [r5, #0x4c]
	mov r1, #0x93
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r3, #0
	str r3, [sp]
	mov r0, #0x6b
	str r0, [sp, #4]
	mov r0, #0x56
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xbe
	mov r2, #4
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_02244780

	thumb_func_start ov83_022447E0
ov83_022447E0: ; 0x022447E0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r1, #0
	add r1, sp, #0x38
	ldrb r1, [r1]
	add r5, r0, #0
	add r0, r4, #0
	add r6, r2, #0
	add r7, r3, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5, #0x20]
	ldr r2, [r5, #0x2c]
	add r1, r6, #0
	bl ReadMsgDataIntoString
	ldr r0, [r5, #0x24]
	ldr r1, [r5, #0x28]
	ldr r2, [r5, #0x2c]
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x28]
	add r2, sp, #0x18
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	add r3, r7, #0
	str r0, [sp, #4]
	add r0, sp, #0x38
	ldrb r1, [r0]
	ldrb r0, [r2, #0x18]
	ldrb r2, [r2, #0x1c]
	lsl r0, r0, #0x18
	lsl r2, r2, #0x18
	lsr r0, r0, #8
	lsr r2, r2, #0x10
	orr r0, r2
	orr r0, r1
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r1, sp, #0x3c
	ldrb r1, [r1]
	ldr r2, [r5, #0x28]
	add r0, r4, #0
	bl AddTextPrinterParameterizedWithColor
	add r5, r0, #0
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov83_022447E0

	thumb_func_start ov83_0224484C
ov83_0224484C: ; 0x0224484C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r4, r1, #0
	add r1, r2, #0
	ldr r0, [r5, #0x20]
	ldr r2, [r5, #0x2c]
	add r6, r3, #0
	bl ReadMsgDataIntoString
	ldr r0, [r5, #0x24]
	ldr r1, [r5, #0x28]
	ldr r2, [r5, #0x2c]
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x20]
	add r2, sp, #0x10
	str r0, [sp]
	ldr r0, [sp, #0x24]
	add r3, r6, #0
	str r0, [sp, #4]
	add r0, sp, #0x30
	ldrb r1, [r0]
	ldrb r0, [r2, #0x18]
	ldrb r2, [r2, #0x1c]
	lsl r0, r0, #0x18
	lsl r2, r2, #0x18
	lsr r0, r0, #8
	lsr r2, r2, #0x10
	orr r0, r2
	orr r0, r1
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r1, sp, #0x34
	ldrb r1, [r1]
	ldr r2, [r5, #0x28]
	add r0, r4, #0
	bl AddTextPrinterParameterizedWithColor
	add r5, r0, #0
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add r0, r5, #0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov83_0224484C

	thumb_func_start ov83_022448AC
ov83_022448AC: ; 0x022448AC
	push {r3, r4, r5, lr}
	sub sp, #0x18
	mov r3, #1
	add r4, r1, #0
	str r3, [sp]
	mov r1, #0xff
	str r1, [sp, #4]
	str r3, [sp, #8]
	mov r1, #2
	str r1, [sp, #0xc]
	mov r1, #0xf
	str r1, [sp, #0x10]
	add r5, r0, #0
	add r1, r5, #0
	str r2, [sp, #0x14]
	add r1, #0xc0
	add r2, r4, #0
	bl ov83_022447E0
	add r5, #0xc0
	add r4, r0, #0
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_022448AC

	thumb_func_start ov83_022448E4
ov83_022448E4: ; 0x022448E4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02244902
	mov r6, #0x24
	b _02244904
_02244902:
	mov r6, #4
_02244904:
	ldrb r0, [r5, #9]
	mov r1, #1
	bl ov80_02237B58
	mov r7, #0
	str r0, [sp, #0xc]
	cmp r0, #0
	ble _022449C0
	add r0, r6, #0
	str r0, [sp, #0x14]
	add r0, #0x18
	str r0, [sp, #0x14]
	add r0, r6, #0
	str r0, [sp, #0x10]
	add r0, #0x20
	str r0, [sp, #0x10]
_02244924:
	ldr r0, _022449CC ; =0x0000054C
	ldr r0, [r5, r0]
	ldrb r0, [r0, r7]
	cmp r0, #0
	bne _02244946
	mov r0, #0x40
	str r0, [sp]
	mov r0, #0x10
	lsl r2, r6, #0x10
	str r0, [sp, #4]
	add r0, r4, #0
	mov r1, #0
	lsr r2, r2, #0x10
	mov r3, #1
	bl FillWindowPixelRect
	b _022449AA
_02244946:
	ldr r0, _022449D0 ; =0x0000055C
	add r1, r7, #0
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	mov r1, #0xa3
	mov r2, #0
	str r0, [sp, #0x18]
	bl GetMonData
	str r4, [sp]
	add r1, r0, #0
	str r6, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r2, #3
	mov r3, #1
	bl PrintUIntOnWindow
	mov r0, #1
	str r0, [sp]
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [sp, #0x14]
	mov r1, #0
	add r2, r4, #0
	bl sub_0200CDAC
	ldr r0, [sp, #0x18]
	mov r1, #0xa4
	mov r2, #0
	bl GetMonData
	add r1, r0, #0
	ldr r0, [sp, #0x10]
	str r4, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r2, #3
	mov r3, #0
	bl PrintUIntOnWindow
_022449AA:
	ldr r0, [sp, #0x14]
	add r7, r7, #1
	add r0, #0x40
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x10]
	add r6, #0x40
	add r0, #0x40
	str r0, [sp, #0x10]
	ldr r0, [sp, #0xc]
	cmp r7, r0
	blt _02244924
_022449C0:
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_022449CC: .word 0x0000054C
_022449D0: .word 0x0000055C
	thumb_func_end ov83_022448E4

	thumb_func_start ov83_022449D4
ov83_022449D4: ; 0x022449D4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	str r1, [sp, #0x10]
	add r0, r1, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _022449F4
	mov r4, #0x28
	mov r6, #0x50
	b _022449F8
_022449F4:
	mov r4, #8
	mov r6, #0x30
_022449F8:
	ldrb r0, [r5, #9]
	mov r1, #1
	bl ov80_02237B58
	mov r7, #0
	str r0, [sp, #0x14]
	cmp r0, #0
	ble _02244A66
_02244A08:
	ldr r0, _02244A70 ; =0x0000055C
	add r1, r7, #0
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	mov r1, #0xa1
	mov r2, #0
	str r0, [sp, #0x18]
	bl GetMonData
	add r2, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, [sp, #0x10]
	mov r1, #1
	str r0, [sp, #4]
	str r4, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #0xad
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r3, #3
	bl sub_0200CE7C
	ldr r0, [sp, #0x18]
	mov r1, #0x6f
	mov r2, #0
	bl GetMonData
	mov r1, #0
	lsl r0, r0, #0x18
	str r1, [sp]
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	ldr r1, [sp, #0x10]
	add r0, r5, #0
	add r2, r6, #0
	mov r3, #1
	bl ov83_02244BA8
	ldr r0, [sp, #0x14]
	add r7, r7, #1
	add r4, #0x40
	add r6, #0x40
	cmp r7, r0
	blt _02244A08
_02244A66:
	ldr r0, [sp, #0x10]
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02244A70: .word 0x0000055C
	thumb_func_end ov83_022449D4

	thumb_func_start ov83_02244A74
ov83_02244A74: ; 0x02244A74
	add r1, r0, #0
	ldr r0, _02244A80 ; =0x00000604
	ldr r3, _02244A84 ; =ov83_02247864
	add r0, r1, r0
	ldr r1, [r1, #0x4c]
	bx r3
	.balign 4, 0
_02244A80: .word 0x00000604
_02244A84: .word ov83_02247864
	thumb_func_end ov83_02244A74

	thumb_func_start ov83_02244A88
ov83_02244A88: ; 0x02244A88
	ldr r3, _02244A8C ; =ov83_02246C2C
	bx r3
	.balign 4, 0
_02244A8C: .word ov83_02246C2C
	thumb_func_end ov83_02244A88

	thumb_func_start ov83_02244A90
ov83_02244A90: ; 0x02244A90
	ldr r3, _02244A94 ; =ov83_02246C70
	bx r3
	.balign 4, 0
_02244A94: .word ov83_02246C70
	thumb_func_end ov83_02244A90

	thumb_func_start ov83_02244A98
ov83_02244A98: ; 0x02244A98
	push {r4, lr}
	sub sp, #8
	ldr r4, [sp, #0x10]
	str r4, [sp]
	mov r4, #1
	str r4, [sp, #4]
	ldr r0, [r0, #0x24]
	bl BufferIntegerAsString
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_02244A98

	thumb_func_start ov83_02244AB0
ov83_02244AB0: ; 0x02244AB0
	ldr r3, _02244AB8 ; =BufferBoxMonSpeciesName
	ldr r0, [r0, #0x24]
	bx r3
	nop
_02244AB8: .word BufferBoxMonSpeciesName
	thumb_func_end ov83_02244AB0

	thumb_func_start ov83_02244ABC
ov83_02244ABC: ; 0x02244ABC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0xaf
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r4, r1, #0
	bl Save_PlayerData_GetProfile
	add r2, r0, #0
	ldr r0, [r5, #0x24]
	add r1, r4, #0
	bl BufferPlayersName
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_02244ABC

	thumb_func_start ov83_02244AD8
ov83_02244AD8: ; 0x02244AD8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r1, #0
	mov r1, #0xaf
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	str r2, [sp, #0x10]
	add r5, r3, #0
	bl Save_PlayerData_GetProfile
	add r6, r0, #0
	mov r0, #8
	mov r1, #0x6b
	bl String_New
	add r4, r0, #0
	add r0, r6, #0
	bl PlayerProfile_GetNamePtr
	add r1, r0, #0
	add r0, r4, #0
	bl CopyU16ArrayToString
	add r0, r6, #0
	bl PlayerProfile_GetTrainerGender
	cmp r0, #0
	bne _02244B14
	ldr r1, _02244B3C ; =0x00070800
	b _02244B18
_02244B14:
	mov r1, #0xc1
	lsl r1, r1, #0xa
_02244B18:
	str r5, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	add r1, sp, #0x18
	ldrb r1, [r1, #0x10]
	ldr r3, [sp, #0x10]
	add r0, r7, #0
	add r2, r4, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02244B3C: .word 0x00070800
	thumb_func_end ov83_02244AD8

	thumb_func_start ov83_02244B40
ov83_02244B40: ; 0x02244B40
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	add r7, r1, #0
	str r2, [sp, #0x18]
	add r6, r3, #0
	bl sub_0203769C
	mov r1, #1
	eor r0, r1
	bl sub_02034818
	str r0, [sp, #0x1c]
	bl PlayerProfile_GetTrainerGender
	cmp r0, #0
	bne _02244B66
	ldr r4, _02244BA4 ; =0x00070800
	b _02244B6A
_02244B66:
	mov r4, #0xc1
	lsl r4, r4, #0xa
_02244B6A:
	ldr r0, [r5, #0x24]
	ldr r2, [sp, #0x1c]
	mov r1, #0
	bl BufferPlayersName
	str r6, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	lsr r0, r4, #0x10
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	lsr r0, r4, #8
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0xc]
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0x14]
	ldr r3, [sp, #0x18]
	add r0, r5, #0
	add r1, r7, #0
	mov r2, #1
	bl ov83_0224484C
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02244BA4: .word 0x00070800
	thumb_func_end ov83_02244B40

	thumb_func_start ov83_02244BA8
ov83_02244BA8: ; 0x02244BA8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r7, r2, #0
	add r2, r3, #0
	add r3, sp, #0x20
	ldrb r3, [r3, #0x14]
	cmp r3, #0
	bne _02244BC2
	mov r3, #0x40
	mov r4, #7
	mov r5, #8
	mov r6, #0
	b _02244BCE
_02244BC2:
	cmp r3, #1
	bne _02244BE8
	mov r3, #0x41
	mov r4, #3
	mov r5, #4
	mov r6, #0
_02244BCE:
	str r2, [sp]
	mov r2, #0xff
	str r2, [sp, #4]
	str r4, [sp, #8]
	str r5, [sp, #0xc]
	str r6, [sp, #0x10]
	add r2, sp, #0x20
	ldrb r2, [r2, #0x10]
	str r2, [sp, #0x14]
	add r2, r3, #0
	add r3, r7, #0
	bl ov83_0224484C
_02244BE8:
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov83_02244BA8

	thumb_func_start ov83_02244BEC
ov83_02244BEC: ; 0x02244BEC
	push {r4, lr}
	sub sp, #0x18
	mov r2, #5
	str r2, [sp]
	mov r1, #0xff
	str r1, [sp, #4]
	mov r1, #1
	str r1, [sp, #8]
	mov r1, #2
	add r4, r0, #0
	str r1, [sp, #0xc]
	mov r3, #0
	str r3, [sp, #0x10]
	add r1, r4, #0
	str r3, [sp, #0x14]
	add r1, #0x60
	bl ov83_022447E0
	strb r0, [r4, #0xa]
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r4, #0
	add r0, #0xd0
	bl ov83_02247944
	mov r3, #1
	add r1, r4, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	str r3, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #0xf
	str r0, [sp, #0x10]
	add r0, r4, #0
	add r1, #0xd0
	mov r2, #4
	str r3, [sp, #0x14]
	bl ov83_022447E0
	strb r0, [r4, #0xa]
	add sp, #0x18
	pop {r4, pc}
	thumb_func_end ov83_02244BEC

	thumb_func_start ov83_02244C4C
ov83_02244C4C: ; 0x02244C4C
	ldr r3, _02244C54 ; =ov83_02245094
	add r0, #0xd0
	bx r3
	nop
_02244C54: .word ov83_02245094
	thumb_func_end ov83_02244C4C

	thumb_func_start ov83_02244C58
ov83_02244C58: ; 0x02244C58
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02247944
	mov r1, #1
	mov r0, #6
	mvn r1, r1
	lsl r0, r0, #8
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov83_02246AA4
	add r0, r4, #0
	bl ov83_02246CC0
	pop {r4, pc}
	thumb_func_end ov83_02244C58

	thumb_func_start ov83_02244C88
ov83_02244C88: ; 0x02244C88
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xc0
	bl ov83_02245094
	add r0, r4, #0
	bl ov83_02246C70
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_02244C88

	thumb_func_start ov83_02244C9C
ov83_02244C9C: ; 0x02244C9C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02247944
	mov r1, #1
	mov r0, #6
	mvn r1, r1
	lsl r0, r0, #8
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov83_02246B6C
	add r0, r4, #0
	bl ov83_02246D40
	pop {r4, pc}
	thumb_func_end ov83_02244C9C

	thumb_func_start ov83_02244CCC
ov83_02244CCC: ; 0x02244CCC
	ldr r3, _02244CD0 ; =ov83_02246C70
	bx r3
	.balign 4, 0
_02244CD0: .word ov83_02246C70
	thumb_func_end ov83_02244CCC

	thumb_func_start ov83_02244CD4
ov83_02244CD4: ; 0x02244CD4
	mov r3, #0
	strb r3, [r0, #8]
	str r2, [r1]
	bx lr
	thumb_func_end ov83_02244CD4

	thumb_func_start ov83_02244CDC
ov83_02244CDC: ; 0x02244CDC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02244D08 ; =0x000005DC
	bl PlaySE
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _02244CFA
	ldrb r2, [r4, #0xd]
	add r0, r4, #0
	mov r1, #0x16
	bl ov83_022450A8
_02244CFA:
	ldrb r1, [r4, #0xd]
	add r0, r4, #0
	mov r2, #0
	bl ov83_02244D0C
	pop {r4, pc}
	nop
_02244D08: .word 0x000005DC
	thumb_func_end ov83_02244CDC

	thumb_func_start ov83_02244D0C
ov83_02244D0C: ; 0x02244D0C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	add r7, r1, #0
	add r6, r2, #0
	bne _02244D22
	ldr r0, _02244D98 ; =0x00000508
	mov r2, #1
	ldr r4, [r5, r0]
	mov r1, #0
	b _02244D2A
_02244D22:
	ldr r0, _02244D9C ; =0x0000050C
	mov r2, #2
	ldr r4, [r5, r0]
	mov r1, #0x11
_02244D2A:
	ldrb r0, [r5, #0x15]
	cmp r7, r0
	blo _02244D50
	add r0, r4, #0
	bl ov83_022475D4
	add r0, r4, #0
	mov r1, #0xe0
	mov r2, #0xa0
	bl ov83_02247568
	cmp r6, #0
	bne _02244D92
	add r0, r5, #0
	mov r1, #0
	bl ov83_02246938
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_02244D50:
	add r0, r4, #0
	add r1, r2, #0
	bl ov83_022475D4
	add r0, r5, #0
	add r1, sp, #4
	add r2, sp, #0
	add r3, r7, #0
	bl ov83_02244DA0
	ldr r1, [sp, #4]
	ldr r2, [sp]
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	add r0, r4, #0
	lsr r1, r1, #0x10
	lsr r2, r2, #0x10
	bl ov83_02247568
	cmp r6, #0
	bne _02244D92
	ldrb r1, [r5, #0xc]
	ldrb r0, [r5, #0x15]
	cmp r1, r0
	blo _02244D8A
	add r0, r5, #0
	mov r1, #1
	bl ov83_02246938
_02244D8A:
	add r0, r5, #0
	mov r1, #0
	bl ov83_0224691C
_02244D92:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02244D98: .word 0x00000508
_02244D9C: .word 0x0000050C
	thumb_func_end ov83_02244D0C

	thumb_func_start ov83_02244DA0
ov83_02244DA0: ; 0x02244DA0
	push {r4, r5, r6, lr}
	ldrb r0, [r0, #9]
	add r5, r1, #0
	add r6, r2, #0
	add r4, r3, #0
	bl ov80_02237D8C
	cmp r0, #1
	bne _02244DD6
	cmp r4, #0
	bne _02244DBC
	mov r0, #0x28
	str r0, [r5]
	b _02244DEE
_02244DBC:
	cmp r4, #1
	bne _02244DC6
	mov r0, #0x68
	str r0, [r5]
	b _02244DEE
_02244DC6:
	cmp r4, #2
	bne _02244DD0
	mov r0, #0xa8
	str r0, [r5]
	b _02244DEE
_02244DD0:
	mov r0, #0xe8
	str r0, [r5]
	b _02244DEE
_02244DD6:
	cmp r4, #0
	bne _02244DE0
	mov r0, #0x48
	str r0, [r5]
	b _02244DEE
_02244DE0:
	cmp r4, #1
	bne _02244DEA
	mov r0, #0x88
	str r0, [r5]
	b _02244DEE
_02244DEA:
	mov r0, #0xc8
	str r0, [r5]
_02244DEE:
	mov r0, #0x58
	str r0, [r6]
	pop {r4, r5, r6, pc}
	thumb_func_end ov83_02244DA0

	thumb_func_start ov83_02244DF4
ov83_02244DF4: ; 0x02244DF4
	push {r3, r4, r5, r6, r7, lr}
	ldrb r0, [r0, #9]
	add r5, r1, #0
	add r6, r2, #0
	add r7, r3, #0
	ldr r4, [sp, #0x18]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02244E16
	mov r0, #0x28
	strh r0, [r5]
	mov r0, #0
	strh r0, [r6]
	strh r0, [r7]
	strh r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_02244E16:
	mov r1, #0
	strh r1, [r5]
	strh r1, [r6]
	mov r0, #0x80
	strh r0, [r7]
	strh r1, [r4]
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov83_02244DF4

	thumb_func_start ov83_02244E24
ov83_02244E24: ; 0x02244E24
	push {r3, r4, r5, r6, lr}
	sub sp, #0x14
	add r4, r0, #0
	ldrb r0, [r4, #0x14]
	add r5, r2, #0
	bl ov83_02247768
	add r6, r0, #0
	ldr r0, _02244F58 ; =0x0000055C
	add r1, r6, #0
	ldr r0, [r4, r0]
	bl Party_GetMonByIndex
	cmp r5, #5
	bls _02244E44
	b _02244F52
_02244E44:
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02244E50: ; jump table
	.short _02244E5C - _02244E50 - 2 ; case 0
	.short _02244E6A - _02244E50 - 2 ; case 1
	.short _02244F52 - _02244E50 - 2 ; case 2
	.short _02244EE8 - _02244E50 - 2 ; case 3
	.short _02244F16 - _02244E50 - 2 ; case 4
	.short _02244F44 - _02244E50 - 2 ; case 5
_02244E5C:
	ldrb r1, [r4, #0xf]
	mov r0, #1
	add sp, #0x14
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_02244E6A:
	ldrb r1, [r4, #0xf]
	lsl r0, r1, #0x1f
	lsr r0, r0, #0x1f
	bne _02244EC0
	mov r0, #1
	bic r1, r0
	mov r0, #1
	orr r0, r1
	strb r0, [r4, #0xf]
	ldrb r0, [r4, #0x12]
	cmp r0, #1
	bne _02244E86
	mov r5, #9
	b _02244E88
_02244E86:
	mov r5, #0xa
_02244E88:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02244E96
	mov r1, #0x50
	b _02244E98
_02244E96:
	mov r1, #0x30
_02244E98:
	lsl r0, r6, #6
	add r0, r1, r0
	lsl r0, r0, #0x10
	str r5, [sp]
	asr r0, r0, #0x10
	str r0, [sp, #4]
	mov r1, #0
	mov r0, #0x32
	str r0, [sp, #8]
	mov r0, #0xb2
	lsl r0, r0, #2
	str r1, [sp, #0xc]
	add r0, r4, r0
	add r2, r1, #0
	add r3, r1, #0
	str r1, [sp, #0x10]
	bl ov83_02247454
	ldr r1, _02244F5C ; =0x00000504
	str r0, [r4, r1]
_02244EC0:
	ldr r0, _02244F5C ; =0x00000504
	ldr r0, [r4, r0]
	bl ov83_02247624
	cmp r0, #0
	bne _02244F52
	ldr r0, _02244F5C ; =0x00000504
	ldr r0, [r4, r0]
	bl ov83_0224753C
	ldr r0, _02244F5C ; =0x00000504
	mov r1, #0
	str r1, [r4, r0]
	ldrb r1, [r4, #0xf]
	mov r0, #1
	add sp, #0x14
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_02244EE8:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02244F08
	add r0, r4, #0
	mov r1, #0
	bl ov83_02246114
	ldrb r1, [r4, #0xf]
	mov r0, #1
	add sp, #0x14
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_02244F08:
	ldrb r1, [r4, #0xf]
	mov r0, #1
	add sp, #0x14
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_02244F16:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02244F36
	add r0, r4, #0
	mov r1, #0
	bl ov83_02246114
	ldrb r1, [r4, #0xf]
	mov r0, #1
	add sp, #0x14
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_02244F36:
	ldrb r1, [r4, #0xf]
	mov r0, #1
	add sp, #0x14
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_02244F44:
	ldrb r1, [r4, #0xf]
	mov r0, #1
	add sp, #0x14
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r3, r4, r5, r6, pc}
_02244F52:
	mov r0, #0
	add sp, #0x14
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_02244F58: .word 0x0000055C
_02244F5C: .word 0x00000504
	thumb_func_end ov83_02244E24

	thumb_func_start ov83_02244F60
ov83_02244F60: ; 0x02244F60
	push {r4, r5, r6, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0x14]
	add r6, r2, #0
	ldrb r5, [r4, #0x15]
	bl ov83_02247768
	add r1, r0, #0
	ldr r0, _02245064 ; =0x0000055C
	ldr r0, [r4, r0]
	bl Party_GetMonByIndex
	cmp r6, #5
	bhi _02245060
	add r0, r6, r6
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02244F88: ; jump table
	.short _02244F94 - _02244F88 - 2 ; case 0
	.short _02244F94 - _02244F88 - 2 ; case 1
	.short _02245060 - _02244F88 - 2 ; case 2
	.short _02244FBC - _02244F88 - 2 ; case 3
	.short _0224500E - _02244F88 - 2 ; case 4
	.short _02244FA0 - _02244F88 - 2 ; case 5
_02244F94:
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_02244FA0:
	ldrb r0, [r4, #0xf]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	bne _02244FB0
	add r0, r4, #0
	mov r1, #0
	bl ov83_02246114
_02244FB0:
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_02244FBC:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _02244FF0
	bl sub_0203769C
	cmp r0, #0
	ldrb r0, [r4, #0x11]
	bne _02244FE0
	cmp r0, r5
	blo _02244FF0
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_02244FE0:
	cmp r0, r5
	bhs _02244FF0
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_02244FF0:
	ldrb r1, [r4, #0xf]
	lsl r0, r1, #0x1f
	lsr r0, r0, #0x1f
	bne _02245060
	mov r0, #0xf8
	bic r1, r0
	mov r0, #0x18
	orr r0, r1
	strb r0, [r4, #0xf]
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_0224500E:
	ldrb r0, [r4, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _02245042
	bl sub_0203769C
	cmp r0, #0
	ldrb r0, [r4, #0x11]
	bne _02245032
	cmp r0, r5
	blo _02245042
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_02245032:
	cmp r0, r5
	bhs _02245042
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_02245042:
	ldrb r1, [r4, #0xf]
	lsl r0, r1, #0x1f
	lsr r0, r0, #0x1f
	bne _02245060
	mov r0, #0xf8
	bic r1, r0
	mov r0, #0x18
	orr r0, r1
	strb r0, [r4, #0xf]
	ldrb r1, [r4, #0xf]
	mov r0, #1
	bic r1, r0
	strb r1, [r4, #0xf]
	mov r0, #1
	pop {r4, r5, r6, pc}
_02245060:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02245064: .word 0x0000055C
	thumb_func_end ov83_02244F60

	thumb_func_start ov83_02245068
ov83_02245068: ; 0x02245068
	cmp r0, #1
	bne _02245070
	mov r0, #1
	bx lr
_02245070:
	mov r0, #0xf
	bx lr
	thumb_func_end ov83_02245068

	thumb_func_start ov83_02245074
ov83_02245074: ; 0x02245074
	push {r4, lr}
	add r4, r0, #0
	bl ov83_02245390
	add r0, r4, #0
	add r0, #0xc0
	bl ov83_02245094
	mov r0, #0x15
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	mov r1, #0
	bl ov83_0224755C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_02245074

	thumb_func_start ov83_02245094
ov83_02245094: ; 0x02245094
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	bl ClearFrameAndWindow2
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_02245094

	thumb_func_start ov83_022450A8
ov83_022450A8: ; 0x022450A8
	push {r3, r4, r5, lr}
	add r3, r1, #0
	sub r3, #0x14
	add r5, r0, #0
	cmp r3, #3
	bhi _022450E6
	add r3, r3, r3
	add r3, pc
	ldrh r3, [r3, #6]
	lsl r3, r3, #0x10
	asr r3, r3, #0x10
	add pc, r3
_022450C0: ; jump table
	.short _022450C8 - _022450C0 - 2 ; case 0
	.short _022450D0 - _022450C0 - 2 ; case 1
	.short _022450D8 - _022450C0 - 2 ; case 2
	.short _022450E0 - _022450C0 - 2 ; case 3
_022450C8:
	mov r4, #0x35
	bl ov83_02245104
	b _022450E6
_022450D0:
	mov r4, #0x36
	bl ov83_0224517C
	b _022450E6
_022450D8:
	mov r4, #0x37
	bl ov83_02245210
	b _022450E6
_022450E0:
	mov r4, #0x38
	bl ov83_02245248
_022450E6:
	ldr r1, _02245100 ; =0x00000564
	add r0, r4, #0
	add r1, r5, r1
	mov r2, #0x28
	bl sub_02037030
	cmp r0, #1
	bne _022450FA
	mov r0, #1
	pop {r3, r4, r5, pc}
_022450FA:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_02245100: .word 0x00000564
	thumb_func_end ov83_022450A8

	thumb_func_start ov83_02245104
ov83_02245104: ; 0x02245104
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r0, #0xaf
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	add r4, r1, #0
	bl Save_PlayerData_GetProfile
	ldr r1, _02245144 ; =0x00000564
	strh r4, [r6, r1]
	bl PlayerProfile_GetTrainerGender
	ldr r1, _02245148 ; =0x00000566
	mov r4, #0
	strh r0, [r6, r1]
	add r5, r6, #4
	sub r7, r1, #2
_02245126:
	mov r0, #0xaf
	lsl r0, r0, #2
	lsl r2, r4, #0x18
	ldrb r1, [r6, #9]
	ldr r0, [r6, r0]
	lsr r2, r2, #0x18
	bl ov83_0224777C
	strh r0, [r5, r7]
	add r4, r4, #1
	add r5, r5, #2
	cmp r4, #3
	blt _02245126
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02245144: .word 0x00000564
_02245148: .word 0x00000566
	thumb_func_end ov83_02245104

	thumb_func_start ov83_0224514C
ov83_0224514C: ; 0x0224514C
	push {r4, r5, r6, lr}
	add r4, r3, #0
	add r5, r0, #0
	ldrb r0, [r4, #0x17]
	add r6, r2, #0
	add r0, r0, #1
	strb r0, [r4, #0x17]
	bl sub_0203769C
	cmp r5, r0
	beq _02245176
	ldr r0, _02245178 ; =0x000005B7
	mov r3, #0
	add r5, r6, #4
_02245168:
	ldrh r2, [r5]
	add r1, r4, r3
	add r3, r3, #1
	add r5, r5, #2
	strb r2, [r1, r0]
	cmp r3, #3
	blt _02245168
_02245176:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02245178: .word 0x000005B7
	thumb_func_end ov83_0224514C

	thumb_func_start ov83_0224517C
ov83_0224517C: ; 0x0224517C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _022451B0 ; =0x00000564
	add r4, r2, #0
	strh r1, [r5, r0]
	add r0, r0, #2
	strh r4, [r5, r0]
	bl sub_0203769C
	cmp r0, #0
	bne _0224519A
	ldrb r0, [r5, #0x11]
	cmp r0, #0xff
	bne _0224519A
	strb r4, [r5, #0x11]
_0224519A:
	ldrb r1, [r5, #0x11]
	ldr r0, _022451B4 ; =0x00000568
	strh r1, [r5, r0]
	ldrb r2, [r5, #0x12]
	add r1, r0, #4
	add r0, r0, #6
	strh r2, [r5, r1]
	ldrb r1, [r5, #0x13]
	strh r1, [r5, r0]
	pop {r3, r4, r5, pc}
	nop
_022451B0: .word 0x00000564
_022451B4: .word 0x00000568
	thumb_func_end ov83_0224517C

	thumb_func_start ov83_022451B8
ov83_022451B8: ; 0x022451B8
	push {r4, r5, r6, lr}
	add r4, r3, #0
	add r6, r0, #0
	ldrb r0, [r4, #0x17]
	add r5, r2, #0
	add r0, r0, #1
	strb r0, [r4, #0x17]
	bl sub_0203769C
	cmp r6, r0
	beq _02245208
	ldrh r1, [r5, #2]
	ldr r0, _0224520C ; =0x000005B5
	strb r1, [r4, r0]
	bl sub_0203769C
	cmp r0, #0
	bne _022451FC
	ldrb r0, [r4, #0x11]
	cmp r0, #0xff
	ldr r0, _0224520C ; =0x000005B5
	beq _022451EA
	mov r1, #0
	strb r1, [r4, r0]
	pop {r4, r5, r6, pc}
_022451EA:
	ldrb r1, [r4, r0]
	ldrb r0, [r4, #0x15]
	add r0, r1, r0
	strb r0, [r4, #0x11]
	ldrh r0, [r5, #8]
	strb r0, [r4, #0x12]
	ldrh r0, [r5, #0xa]
	strb r0, [r4, #0x13]
	pop {r4, r5, r6, pc}
_022451FC:
	ldrh r0, [r5, #4]
	strb r0, [r4, #0x11]
	ldrh r0, [r5, #8]
	strb r0, [r4, #0x12]
	ldrh r0, [r5, #0xa]
	strb r0, [r4, #0x13]
_02245208:
	pop {r4, r5, r6, pc}
	nop
_0224520C: .word 0x000005B5
	thumb_func_end ov83_022451B8

	thumb_func_start ov83_02245210
ov83_02245210: ; 0x02245210
	ldr r2, _0224521C ; =0x00000564
	strh r1, [r0, r2]
	ldrb r3, [r0, #0xd]
	add r1, r2, #2
	strh r3, [r0, r1]
	bx lr
	.balign 4, 0
_0224521C: .word 0x00000564
	thumb_func_end ov83_02245210

	thumb_func_start ov83_02245220
ov83_02245220: ; 0x02245220
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r6, r2, #0
	add r4, r3, #0
	bl sub_0203769C
	cmp r5, r0
	beq _02245240
	ldrh r0, [r6, #2]
	ldr r1, _02245244 ; =0x000005B4
	mov r2, #1
	strb r0, [r4, r1]
	ldrb r1, [r4, r1]
	add r0, r4, #0
	bl ov83_02244D0C
_02245240:
	pop {r4, r5, r6, pc}
	nop
_02245244: .word 0x000005B4
	thumb_func_end ov83_02245220

	thumb_func_start ov83_02245248
ov83_02245248: ; 0x02245248
	ldr r1, _02245250 ; =0x00000564
	mov r2, #1
	strh r2, [r0, r1]
	bx lr
	.balign 4, 0
_02245250: .word 0x00000564
	thumb_func_end ov83_02245248

	thumb_func_start ov83_02245254
ov83_02245254: ; 0x02245254
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r2, #0
	add r6, r3, #0
	bl sub_0203769C
	cmp r5, r0
	beq _0224526A
	ldrh r1, [r4]
	ldr r0, _0224526C ; =0x000005B6
	strb r1, [r6, r0]
_0224526A:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224526C: .word 0x000005B6
	thumb_func_end ov83_02245254

	thumb_func_start ov83_02245270
ov83_02245270: ; 0x02245270
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0x14]
	bl ov83_02247768
	ldr r1, _02245284 ; =0x00000554
	mov r2, #1
	ldr r1, [r4, r1]
	strb r2, [r1, r0]
	pop {r4, pc}
	.balign 4, 0
_02245284: .word 0x00000554
	thumb_func_end ov83_02245270

	thumb_func_start ov83_02245288
ov83_02245288: ; 0x02245288
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r4, r1, #0
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	bl ov83_02247944
	ldrb r0, [r5, #0x14]
	add r1, r4, #0
	bl ov83_02247768
	add r1, r0, #0
	ldr r0, _022452F8 ; =0x0000055C
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r5, #0
	mov r1, #0
	bl ov83_02244AB0
	add r0, r5, #0
	mov r1, #0x2f
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	add r0, r5, #0
	add r1, r4, #0
	bl ov83_02245270
	add r0, r5, #0
	bl ov83_02245C80
	ldrb r0, [r5, #0xd]
	cmp r0, r4
	bne _022452F0
	add r0, r5, #0
	bl ov83_02245D48
	add r0, r5, #0
	mov r1, #0
	bl ov83_02246114
_022452F0:
	ldr r0, _022452FC ; =0x00000623
	bl PlaySE
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022452F8: .word 0x0000055C
_022452FC: .word 0x00000623
	thumb_func_end ov83_02245288

	thumb_func_start ov83_02245300
ov83_02245300: ; 0x02245300
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0x14]
	bl ov83_02247768
	ldr r1, _02245314 ; =0x00000558
	mov r2, #1
	ldr r1, [r4, r1]
	strb r2, [r1, r0]
	pop {r4, pc}
	.balign 4, 0
_02245314: .word 0x00000558
	thumb_func_end ov83_02245300

	thumb_func_start ov83_02245318
ov83_02245318: ; 0x02245318
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r4, r1, #0
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	bl ov83_02247944
	ldrb r0, [r5, #0x14]
	add r1, r4, #0
	bl ov83_02247768
	add r1, r0, #0
	ldr r0, _02245388 ; =0x0000055C
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r5, #0
	mov r1, #0
	bl ov83_02244AB0
	add r0, r5, #0
	mov r1, #0x53
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	add r0, r5, #0
	add r1, r4, #0
	bl ov83_02245300
	add r0, r5, #0
	bl ov83_02245C80
	ldrb r0, [r5, #0xd]
	cmp r0, r4
	bne _02245380
	add r0, r5, #0
	bl ov83_02245D48
	add r0, r5, #0
	mov r1, #0
	bl ov83_02246114
_02245380:
	ldr r0, _0224538C ; =0x00000623
	bl PlaySE
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02245388: .word 0x0000055C
_0224538C: .word 0x00000623
	thumb_func_end ov83_02245318

	thumb_func_start ov83_02245390
ov83_02245390: ; 0x02245390
	push {r4, lr}
	add r4, r0, #0
	ldrb r0, [r4, #0xf]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _022453AC
	ldr r0, _022453B8 ; =0x000005F8
	ldr r0, [r4, r0]
	bl TouchscreenListMenu_DestroyButtons
	add r0, r4, #0
	bl ov83_02246C70
_022453AC:
	ldr r0, _022453BC ; =0x00000604
	add r0, r4, r0
	bl ov83_022478B4
	pop {r4, pc}
	nop
_022453B8: .word 0x000005F8
_022453BC: .word 0x00000604
	thumb_func_end ov83_02245390

	thumb_func_start ov83_022453C0
ov83_022453C0: ; 0x022453C0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Options_GetFrame
	add r4, #0xc0
	add r1, r0, #0
	add r0, r4, #0
	bl ov83_02247944
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov83_022453C0

	thumb_func_start ov83_022453DC
ov83_022453DC: ; 0x022453DC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	add r4, r1, #0
	add r1, sp, #0x1c
	str r1, [sp]
	add r1, sp, #0x20
	add r3, sp, #0x1c
	add r5, r0, #0
	add r1, #2
	add r2, sp, #0x20
	add r3, #2
	bl ov83_02244DF4
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02245472
	add r1, sp, #0x1c
	ldrh r0, [r1, #6]
	add r0, #0x48
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldrh r0, [r1, #4]
	mov r1, #0
	add r2, r7, #0
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	mov r0, #0x30
	str r0, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	add r0, r4, #0
	add r3, r6, #0
	bl FillWindowPixelRect
	ldrb r0, [r5, #9]
	bl sub_0205C1F0
	str r0, [sp, #0x18]
	ldrb r0, [r5, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r5, #4]
	ldr r1, [sp, #0x18]
	bl FrontierSave_GetStat
	mov r1, #0
	add r2, r0, #0
	str r1, [sp]
	add r0, r5, #0
	mov r3, #4
	bl ov83_02244A98
	str r6, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r2, #2
	str r2, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	add r0, r5, #0
	add r1, r4, #0
	add r3, r7, #0
	bl ov83_0224484C
	strb r0, [r5, #0xa]
	b _02245540
_02245472:
	mov r0, #0x30
	str r0, [sp]
	mov r0, #0x10
	mov r1, #0
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0x40
	add r3, r1, #0
	bl FillWindowPixelRect
	mov r0, #0x30
	str r0, [sp]
	mov r0, #0x10
	mov r1, #0
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0xc0
	add r3, r1, #0
	bl FillWindowPixelRect
	bl sub_0203769C
	cmp r0, #0
	bne _022454C6
	ldrb r0, [r5, #9]
	bl sub_0205C1F0
	add r6, r0, #0
	ldrb r0, [r5, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r5, #4]
	add r1, r6, #0
	bl FrontierSave_GetStat
	add r6, r0, #0
	ldr r0, _0224554C ; =0x000005BA
	ldrh r7, [r5, r0]
	b _022454E8
_022454C6:
	ldr r0, _0224554C ; =0x000005BA
	ldrh r6, [r5, r0]
	ldrb r0, [r5, #9]
	bl sub_0205C1F0
	add r7, r0, #0
	ldrb r0, [r5, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r5, #4]
	add r1, r7, #0
	bl FrontierSave_GetStat
	add r7, r0, #0
_022454E8:
	mov r1, #0
	add r0, r5, #0
	add r2, r6, #0
	mov r3, #4
	str r1, [sp]
	bl ov83_02244A98
	mov r0, #0x70
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _02245550 ; =0x00010200
	add r1, r4, #0
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r2, [r5, #0x20]
	add r0, r5, #0
	mov r3, #2
	bl ov83_02245D08
	mov r1, #0
	add r0, r5, #0
	add r2, r7, #0
	mov r3, #4
	str r1, [sp]
	bl ov83_02244A98
	mov r0, #0xf0
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _02245550 ; =0x00010200
	add r1, r4, #0
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r2, [r5, #0x20]
	add r0, r5, #0
	mov r3, #3
	bl ov83_02245D08
_02245540:
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	nop
_0224554C: .word 0x000005BA
_02245550: .word 0x00010200
	thumb_func_end ov83_022453DC

	thumb_func_start ov83_02245554
ov83_02245554: ; 0x02245554
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	bl ov83_02245068
	add r2, r0, #0
	mov r1, #0
	add r0, r5, #0
	mov r3, #4
	str r1, [sp]
	bl ov83_02244A98
	add r0, r5, #0
	mov r1, #0x19
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	add r0, r5, #0
	bl ov83_02244A74
	strb r4, [r5, #0xe]
	pop {r3, r4, r5, pc}
	thumb_func_end ov83_02245554

	thumb_func_start ov83_02245584
ov83_02245584: ; 0x02245584
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r1, sp, #4
	str r1, [sp]
	add r1, sp, #8
	add r3, sp, #4
	add r5, r0, #0
	add r1, #2
	add r2, sp, #8
	add r3, #2
	bl ov83_02244DF4
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _022455C8
	mov r0, #0
	str r0, [sp]
	add r3, sp, #4
	ldrh r2, [r3, #6]
	ldrh r3, [r3, #4]
	add r0, r5, #0
	add r2, r2, #4
	add r3, r3, #1
	lsl r2, r2, #0x10
	lsl r3, r3, #0x10
	add r1, r4, #0
	lsr r2, r2, #0x10
	lsr r3, r3, #0x10
	bl ov83_02244AD8
	b _02245630
_022455C8:
	bl sub_0203769C
	cmp r0, #0
	add r2, sp, #4
	bne _02245602
	ldrh r0, [r2, #4]
	add r1, r4, #0
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r3, r0, #0x10
	mov r0, #0
	str r0, [sp]
	ldrh r2, [r2, #6]
	add r0, r5, #0
	bl ov83_02244AD8
	mov r0, #0
	str r0, [sp]
	add r3, sp, #4
	ldrh r2, [r3, #2]
	ldrh r3, [r3]
	add r0, r5, #0
	add r1, r4, #0
	add r3, r3, #1
	lsl r3, r3, #0x10
	lsr r3, r3, #0x10
	bl ov83_02244B40
	b _02245630
_02245602:
	ldrh r0, [r2, #4]
	add r1, r4, #0
	add r0, r0, #1
	lsl r0, r0, #0x10
	lsr r3, r0, #0x10
	mov r0, #0
	str r0, [sp]
	ldrh r2, [r2, #6]
	add r0, r5, #0
	bl ov83_02244B40
	mov r0, #0
	str r0, [sp]
	add r3, sp, #4
	ldrh r2, [r3, #2]
	ldrh r3, [r3]
	add r0, r5, #0
	add r1, r4, #0
	add r3, r3, #1
	lsl r3, r3, #0x10
	lsr r3, r3, #0x10
	bl ov83_02244AD8
_02245630:
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_02245584

	thumb_func_start ov83_0224563C
ov83_0224563C: ; 0x0224563C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r4, r0, #0
	ldr r0, _02245740 ; =0x000005E3
	add r7, r1, #0
	add r6, r2, #0
	bl PlaySE
	ldrb r0, [r4, #0x15]
	add r1, r7, #0
	str r0, [sp]
	bl ov83_0224776C
	str r0, [sp, #4]
	cmp r6, #4
	bhi _02245686
	add r0, r6, r6
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02245668: ; jump table
	.short _02245672 - _02245668 - 2 ; case 0
	.short _02245676 - _02245668 - 2 ; case 1
	.short _02245686 - _02245668 - 2 ; case 2
	.short _02245680 - _02245668 - 2 ; case 3
	.short _02245684 - _02245668 - 2 ; case 4
_02245672:
	mov r5, #1
	b _02245686
_02245676:
	ldrb r0, [r4, #0x12]
	bl ov83_02245068
	add r5, r0, #0
	b _02245686
_02245680:
	mov r5, #2
	b _02245686
_02245684:
	mov r5, #5
_02245686:
	bl sub_0203769C
	cmp r0, #0
	bne _022456BA
	ldr r0, [sp]
	cmp r7, r0
	bhs _022456A8
	add r0, r4, #0
	mov r1, #5
	bl ov83_02244ABC
	ldrb r1, [r4, #9]
	ldr r0, [r4, #4]
	add r2, r5, #0
	bl ov80_02237FA4
	b _022456E4
_022456A8:
	ldr r0, [r4, #0x24]
	mov r1, #5
	bl ov83_022477C4
	ldr r0, _02245744 ; =0x000005BA
	ldrh r1, [r4, r0]
	sub r1, r1, r5
	strh r1, [r4, r0]
	b _022456E4
_022456BA:
	ldr r0, [sp]
	cmp r7, r0
	bhs _022456D2
	ldr r0, [r4, #0x24]
	mov r1, #5
	bl ov83_022477C4
	ldr r0, _02245744 ; =0x000005BA
	ldrh r1, [r4, r0]
	sub r1, r1, r5
	strh r1, [r4, r0]
	b _022456E4
_022456D2:
	add r0, r4, #0
	mov r1, #5
	bl ov83_02244ABC
	ldrb r1, [r4, #9]
	ldr r0, [r4, #4]
	add r2, r5, #0
	bl ov80_02237FA4
_022456E4:
	add r1, r4, #0
	add r0, r4, #0
	add r1, #0x50
	bl ov83_022453DC
	add r0, r4, #0
	bl ov83_02245390
	cmp r6, #4
	bhi _0224573C
	add r0, r6, r6
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02245704: ; jump table
	.short _0224570E - _02245704 - 2 ; case 0
	.short _0224571A - _02245704 - 2 ; case 1
	.short _0224573C - _02245704 - 2 ; case 2
	.short _02245728 - _02245704 - 2 ; case 3
	.short _02245734 - _02245704 - 2 ; case 4
_0224570E:
	ldr r1, [sp, #4]
	add r0, r4, #0
	bl ov83_02245824
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_0224571A:
	ldrb r2, [r4, #0x12]
	ldr r1, [sp, #4]
	add r0, r4, #0
	bl ov83_02245838
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_02245728:
	ldr r1, [sp, #4]
	add r0, r4, #0
	bl ov83_02245288
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_02245734:
	ldr r1, [sp, #4]
	add r0, r4, #0
	bl ov83_02245318
_0224573C:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02245740: .word 0x000005E3
_02245744: .word 0x000005BA
	thumb_func_end ov83_0224563C

	thumb_func_start ov83_02245748
ov83_02245748: ; 0x02245748
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldrb r0, [r5, #0x14]
	add r4, r1, #0
	bl ov83_02247768
	add r1, r0, #0
	ldr r0, _02245810 ; =0x0000055C
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	add r6, r0, #0
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	bl ov83_02247944
	add r0, r6, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r5, #0
	mov r1, #0
	bl ov83_02244AB0
	add r0, r5, #0
	mov r1, #0x14
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	ldrb r0, [r5, #0x14]
	add r1, r4, #0
	bl ov83_02247768
	ldr r1, _02245814 ; =0x0000054C
	mov r2, #1
	ldr r1, [r5, r1]
	strb r2, [r1, r0]
	ldrb r0, [r5, #0x14]
	add r1, r4, #0
	bl ov83_02247768
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02245818 ; =0x000004F4
	ldr r0, [r1, r0]
	mov r1, #0
	bl ov83_0224755C
	ldrb r0, [r5, #0x14]
	add r1, r4, #0
	bl ov83_02247768
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _0224581C ; =0x000004E4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov83_0224755C
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0x70
	bl ov83_022449D4
	ldrb r0, [r5, #0xd]
	cmp r0, r4
	bne _022457F0
	add r0, r5, #0
	bl ov83_02245D48
	add r0, r5, #0
	mov r1, #0
	bl ov83_02246114
	add r0, r5, #0
	bl ov83_02246988
_022457F0:
	ldrb r0, [r5, #0x14]
	add r1, r4, #0
	bl ov83_02247768
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0x51
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov83_0224755C
	ldr r0, _02245820 ; =0x00000623
	bl PlaySE
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02245810: .word 0x0000055C
_02245814: .word 0x0000054C
_02245818: .word 0x000004F4
_0224581C: .word 0x000004E4
_02245820: .word 0x00000623
	thumb_func_end ov83_02245748

	thumb_func_start ov83_02245824
ov83_02245824: ; 0x02245824
	push {r4, lr}
	add r4, r0, #0
	bl ov83_02245748
	add r0, r4, #0
	add r4, #0x80
	add r1, r4, #0
	bl ov83_022448E4
	pop {r4, pc}
	thumb_func_end ov83_02245824

	thumb_func_start ov83_02245838
ov83_02245838: ; 0x02245838
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r6, r1, #0
	add r7, r2, #0
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	bl ov83_02247944
	ldrb r0, [r5, #0x14]
	add r1, r6, #0
	bl ov83_02247768
	add r1, r0, #0
	ldr r0, _02245994 ; =0x0000055C
	ldr r0, [r5, r0]
	bl Party_GetMonByIndex
	add r4, r0, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	add r0, r5, #0
	mov r1, #0
	bl ov83_02244AB0
	cmp r7, #1
	bne _0224588E
	add r0, r5, #0
	mov r1, #0x1f
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	ldr r0, _02245998 ; =0x00000632
	bl PlaySE
	b _022458A0
_0224588E:
	add r0, r5, #0
	mov r1, #0x20
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	ldr r0, _0224599C ; =0x00000633
	bl PlaySE
_022458A0:
	ldrb r0, [r5, #0x14]
	add r1, r6, #0
	bl ov83_02247768
	mov r1, #0x55
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	ldrb r0, [r1, r0]
	cmp r0, #0
	ldrb r0, [r5, #0x14]
	bne _022458C6
	add r1, r6, #0
	bl ov83_02247768
	mov r1, #0x55
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	strb r7, [r1, r0]
	b _022458D6
_022458C6:
	add r1, r6, #0
	bl ov83_02247768
	mov r1, #0x55
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0
	strb r2, [r1, r0]
_022458D6:
	ldrb r0, [r5, #0x14]
	add r1, r6, #0
	bl ov83_02247768
	mov r1, #0x55
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _0224590E
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	mov r1, #0x32
	bl GetMonExpBySpeciesAndLevel
	str r0, [sp]
	add r0, r4, #0
	mov r1, #8
	add r2, sp, #0
	bl SetMonData
	add r0, r4, #0
	bl CalcMonLevelAndStats
	b _02245968
_0224590E:
	ldrb r0, [r5, #0x14]
	add r1, r6, #0
	bl ov83_02247768
	mov r1, #0x55
	lsl r1, r1, #4
	ldr r1, [r5, r1]
	ldrb r0, [r1, r0]
	cmp r0, #1
	bne _02245946
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	mov r1, #0x37
	bl GetMonExpBySpeciesAndLevel
	str r0, [sp]
	add r0, r4, #0
	mov r1, #8
	add r2, sp, #0
	bl SetMonData
	add r0, r4, #0
	bl CalcMonLevelAndStats
	b _02245968
_02245946:
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	mov r1, #0x2d
	bl GetMonExpBySpeciesAndLevel
	str r0, [sp]
	add r0, r4, #0
	mov r1, #8
	add r2, sp, #0
	bl SetMonData
	add r0, r4, #0
	bl CalcMonLevelAndStats
_02245968:
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0x80
	bl ov83_022448E4
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0x70
	bl ov83_022449D4
	ldrb r0, [r5, #0xd]
	cmp r0, r6
	bne _02245990
	add r0, r5, #0
	bl ov83_02245D48
	add r0, r5, #0
	mov r1, #0
	bl ov83_02246114
_02245990:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02245994: .word 0x0000055C
_02245998: .word 0x00000632
_0224599C: .word 0x00000633
	thumb_func_end ov83_02245838

	thumb_func_start ov83_022459A0
ov83_022459A0: ; 0x022459A0
	ldr r3, _022459A8 ; =GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bx r3
	.balign 4, 0
_022459A8: .word GfGfx_EngineATogglePlanes
	thumb_func_end ov83_022459A0

	thumb_func_start ov83_022459AC
ov83_022459AC: ; 0x022459AC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r0, #0
	ldrb r0, [r6, #9]
	mov r1, #1
	bl ov80_02237B24
	mov r4, #0
	str r0, [sp]
	cmp r0, #0
	ble _02245A34
	add r5, r6, #0
_022459C4:
	ldr r0, _02245A38 ; =0x0000055C
	add r1, r4, #0
	ldr r0, [r6, r0]
	bl Party_GetMonByIndex
	str r0, [sp, #4]
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	add r7, r0, #0
	ldr r0, [sp, #4]
	mov r1, #0xa4
	mov r2, #0
	bl GetMonData
	add r1, r0, #0
	lsl r0, r7, #0x10
	lsl r1, r1, #0x10
	lsr r0, r0, #0x10
	lsr r1, r1, #0x10
	bl ov80_0222A43C
	add r1, r0, #0
	ldr r0, _02245A3C ; =0x000004E4
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _02245A2A
	bl ov83_02247600
	ldrb r0, [r6, #0x14]
	ldrb r1, [r6, #0xd]
	bl ov83_02247768
	cmp r4, r0
	bne _02245A14
	ldrb r1, [r6, #0xd]
	ldrb r0, [r6, #0x15]
	cmp r1, r0
	blo _02245A20
_02245A14:
	ldr r0, _02245A3C ; =0x000004E4
	mov r1, #0
	ldr r0, [r5, r0]
	bl ov83_0224760C
	b _02245A2A
_02245A20:
	ldr r0, _02245A3C ; =0x000004E4
	mov r1, #1
	ldr r0, [r5, r0]
	bl ov83_0224760C
_02245A2A:
	ldr r0, [sp]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, r0
	blt _022459C4
_02245A34:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02245A38: .word 0x0000055C
_02245A3C: .word 0x000004E4
	thumb_func_end ov83_022459AC

	thumb_func_start ov83_02245A40
ov83_02245A40: ; 0x02245A40
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldrb r0, [r5, #9]
	add r4, r1, #0
	add r6, r2, #0
	bl sub_0205C1F0
	add r7, r0, #0
	ldrb r0, [r5, #9]
	bl sub_0205C1F0
	bl sub_0205C268
	add r2, r0, #0
	ldr r0, [r5, #4]
	add r1, r7, #0
	bl FrontierSave_GetStat
	cmp r0, r4
	bhs _02245A82
	add r0, r5, #0
	bl ov83_022453C0
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	mov r0, #0x10
	strb r0, [r5, #8]
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_02245A82:
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #0
	bne _02245AC6
	add r0, r5, #0
	add r0, #0xc0
	bl ov83_02245094
	ldrb r1, [r5, #9]
	ldr r0, [r5, #4]
	add r2, r4, #0
	bl ov80_02237FA4
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0x50
	bl ov83_022453DC
	cmp r4, #2
	bne _02245AB6
	ldrb r1, [r5, #0xd]
	add r0, r5, #0
	bl ov83_02245288
	b _02245ABE
_02245AB6:
	ldrb r1, [r5, #0xd]
	add r0, r5, #0
	bl ov83_02245318
_02245ABE:
	mov r0, #0xd
	strb r0, [r5, #8]
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_02245AC6:
	mov r0, #1
	strb r0, [r5, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov83_02245A40

	thumb_func_start ov83_02245ACC
ov83_02245ACC: ; 0x02245ACC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldrb r0, [r5, #9]
	add r4, r1, #0
	mov r1, #0
	add r7, r2, #0
	bl ov80_02237B24
	cmp r7, #5
	bne _02245AE6
	mov r6, #2
	b _02245AEA
_02245AE6:
	bl GF_AssertFail
_02245AEA:
	ldrb r7, [r5, #0x15]
	add r1, r4, #0
	add r0, r7, #0
	bl ov83_0224776C
	bl sub_0203769C
	cmp r0, #0
	bne _02245B9A
	cmp r4, r7
	bhs _02245B7A
	add r0, r5, #0
	mov r1, #5
	bl ov83_02244ABC
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	add r2, r6, #0
	bl ov83_0224777C
	ldrb r1, [r5, #9]
	ldr r0, [r5, #4]
	mov r2, #0x32
	bl ov80_02237FA4
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	add r2, r6, #0
	bl ov83_0224777C
	add r4, r0, #0
	mov r0, #0xaf
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Save_Frontier_GetStatic
	add r7, r0, #0
	ldrb r0, [r5, #9]
	add r1, r6, #0
	bl sub_0205C174
	str r0, [sp]
	ldrb r0, [r5, #9]
	add r1, r6, #0
	bl sub_0205C174
	bl sub_0205C268
	add r3, r4, #1
	lsl r3, r3, #0x10
	add r2, r0, #0
	ldr r1, [sp]
	add r0, r7, #0
	lsr r3, r3, #0x10
	bl sub_02031108
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _02245C36
	ldrb r1, [r5, #0xf]
	mov r0, #0xf8
	bic r1, r0
	mov r0, #0x10
	orr r0, r1
	strb r0, [r5, #0xf]
	b _02245C36
_02245B7A:
	ldr r0, [r5, #0x24]
	mov r1, #5
	bl ov83_022477C4
	ldr r1, _02245C78 ; =0x000005B7
	add r2, r1, #3
	add r0, r5, r1
	ldrh r2, [r5, r2]
	ldrb r4, [r0, r6]
	add r1, r1, #3
	sub r2, #0x32
	strh r2, [r5, r1]
	ldrb r1, [r0, r6]
	add r1, r1, #1
	strb r1, [r0, r6]
	b _02245C36
_02245B9A:
	cmp r4, r7
	bhs _02245BBE
	ldr r0, [r5, #0x24]
	mov r1, #5
	bl ov83_022477C4
	ldr r1, _02245C78 ; =0x000005B7
	add r2, r1, #3
	add r0, r5, r1
	ldrh r2, [r5, r2]
	ldrb r4, [r0, r6]
	add r1, r1, #3
	sub r2, #0x32
	strh r2, [r5, r1]
	ldrb r1, [r0, r6]
	add r1, r1, #1
	strb r1, [r0, r6]
	b _02245C36
_02245BBE:
	add r0, r5, #0
	mov r1, #5
	bl ov83_02244ABC
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	add r2, r6, #0
	bl ov83_0224777C
	ldrb r1, [r5, #9]
	ldr r0, [r5, #4]
	mov r2, #0x32
	bl ov80_02237FA4
	mov r0, #0xaf
	lsl r0, r0, #2
	ldrb r1, [r5, #9]
	ldr r0, [r5, r0]
	add r2, r6, #0
	bl ov83_0224777C
	add r4, r0, #0
	mov r0, #0xaf
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Save_Frontier_GetStatic
	add r7, r0, #0
	ldrb r0, [r5, #9]
	add r1, r6, #0
	bl sub_0205C174
	str r0, [sp, #4]
	ldrb r0, [r5, #9]
	add r1, r6, #0
	bl sub_0205C174
	bl sub_0205C268
	add r3, r4, #1
	lsl r3, r3, #0x10
	add r2, r0, #0
	ldr r1, [sp, #4]
	add r0, r7, #0
	lsr r3, r3, #0x10
	bl sub_02031108
	ldrb r0, [r5, #9]
	bl ov80_02237D8C
	cmp r0, #1
	bne _02245C36
	ldrb r1, [r5, #0xf]
	mov r0, #0xf8
	bic r1, r0
	mov r0, #0x10
	orr r0, r1
	strb r0, [r5, #0xf]
_02245C36:
	add r0, r5, #0
	bl ov83_02245390
	add r1, r5, #0
	add r0, r5, #0
	add r1, #0x50
	bl ov83_022453DC
	mov r0, #0xae
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Options_GetFrame
	add r1, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	bl ov83_02247944
	mov r1, #6
	add r3, r6, #0
	mul r3, r1
	ldr r1, _02245C7C ; =ov83_02248054
	lsl r2, r4, #1
	add r1, r1, r3
	ldrh r1, [r2, r1]
	add r0, r5, #0
	mov r2, #1
	bl ov83_022448AC
	strb r0, [r5, #0xa]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02245C78: .word 0x000005B7
_02245C7C: .word ov83_02248054
	thumb_func_end ov83_02245ACC

	thumb_func_start ov83_02245C80
ov83_02245C80: ; 0x02245C80
	push {r4, r5, r6, lr}
	add r6, r0, #0
	ldrb r0, [r6, #9]
	mov r1, #1
	bl ov80_02237B58
	add r5, r0, #0
	mov r4, #0
	cmp r5, #0
	ble _02245CA4
_02245C94:
	lsl r1, r4, #0x18
	add r0, r6, #0
	lsr r1, r1, #0x18
	bl ov83_02245CA8
	add r4, r4, #1
	cmp r4, r5
	blt _02245C94
_02245CA4:
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov83_02245C80

	thumb_func_start ov83_02245CA8
ov83_02245CA8: ; 0x02245CA8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _02245CE0 ; =0x00000554
	add r4, r1, #0
	ldr r1, [r5, r0]
	ldrb r1, [r1, r4]
	cmp r1, #1
	bne _02245CC6
	lsl r1, r4, #3
	add r1, r5, r1
	sub r0, #0x34
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov83_0224755C
_02245CC6:
	ldr r0, _02245CE4 ; =0x00000558
	ldr r1, [r5, r0]
	ldrb r1, [r1, r4]
	cmp r1, #1
	bne _02245CDE
	lsl r1, r4, #3
	add r1, r5, r1
	sub r0, #0x34
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov83_0224755C
_02245CDE:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02245CE0: .word 0x00000554
_02245CE4: .word 0x00000558
	thumb_func_end ov83_02245CA8

	thumb_func_start ov83_02245CE8
ov83_02245CE8: ; 0x02245CE8
	push {r3, r4, r5, lr}
	ldrb r0, [r0, #9]
	add r5, r1, #0
	add r4, r2, #0
	bl ov80_02237D8C
	cmp r0, #1
	bne _02245CFC
	mov r0, #0x40
	b _02245CFE
_02245CFC:
	mov r0, #0x60
_02245CFE:
	str r0, [r5]
	mov r0, #0x3c
	str r0, [r4]
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov83_02245CE8

	thumb_func_start ov83_02245D08
ov83_02245D08: ; 0x02245D08
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r1, #0
	add r0, r2, #0
	add r1, r3, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r0, [r5, #0x24]
	ldr r1, [r5, #0x28]
	add r2, r6, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x28]
	ldr r2, [sp, #0x20]
	str r0, [sp]
	ldr r0, [sp, #0x2c]
	ldr r3, [sp, #0x24]
	str r0, [sp, #4]
	ldr r0, [sp, #0x30]
	str r0, [sp, #8]
	ldr r1, [r5, #0x28]
	add r0, r4, #0
	bl ov83_02247998
	add r0, r6, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov83_02245D08
