	.include "asm/macros.inc"
	.include "overlay_31.inc"
	.include "global.inc"

.public _0225EE40
.public _0225EF40
.public ov31_0225DE84
.public ov31_0225DF98
.public ov31_0225E0E4
.public ov31_0225E12C
.public ov31_0225E184
.public ov31_0225E20C
.public ov31_0225E2D4
.public ov31_0225E474
.public ov31_0225E54C
.public ov31_0225E5FC
.public ov31_0225E700
.public ov31_0225E774
.public ov31_0225E7D4
.public ov31_0225EA08
.public ov31_0225EA9C
.public ov31_0225EB30
.public ov31_0225EBC4
.public ov31_0225EC58
.public ov31_0225EDA0
.public ov31_0225EE88
.public ov31_0225EED0
.public ov31_0225EEEC
.public ov31_0225EF08

	.text

	thumb_func_start ov31_0225D520
ov31_0225D520: ; 0x0225D520
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r0, #0
	add r7, r1, #0
	mov r0, #3
	str r2, [sp]
	mov r1, #8
	lsl r2, r0, #0xf
	str r3, [sp, #4]
	bl Heap_Create
	mov r1, #0x19
	ldr r0, _0225D5FC ; =ov31_0225D7A0
	lsl r1, r1, #4
	mov r2, #0xa
	mov r3, #8
	bl CreateSysTaskAndEnvironment
	add r5, r0, #0
	bl SysTask_GetData
	add r4, r0, #0
	str r5, [r4, #8]
	mov r1, #0
	str r1, [r4]
	str r6, [r4, #4]
	ldr r0, [sp]
	str r7, [r4, #0x18]
	str r0, [r4, #0x1c]
	str r1, [r4, #0x30]
	ldr r0, [r4, #0x1c]
	ldr r0, [r0, #0xc]
	bl Save_PlayerData_GetOptionsAddr
	mov r1, #0x59
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r4, #0x1c]
	ldr r0, [r0, #0xc]
	bl Save_PlayerData_GetProfile
	mov r1, #0x5a
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r4, #0x1c]
	ldr r0, [r0, #0xc]
	bl Save_Pokeathlon_Get
	mov r1, #0x5b
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0
	str r0, [r4, #0xc]
	ldr r0, [sp, #4]
	str r0, [r4, #0x14]
	add r0, r4, #0
	bl ov31_0225DAC4
	add r0, r4, #0
	bl ov31_0225DB38
	add r0, r4, #0
	bl ov31_0225D60C
	add r0, r4, #0
	mov r1, #0
	bl ov31_0225D684
	add r0, r4, #0
	bl ov31_0225DE84
	add r0, r4, #0
	bl ov31_0225DF98
	add r0, r4, #0
	bl ov31_0225DD14
	ldr r0, [r4, #0x14]
	bl ov03_022581BC
	ldr r2, _0225D600 ; =0x04001000
	ldr r0, _0225D604 ; =0xFFFF1FFF
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #2
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #1
	bl TextFlags_SetCanTouchSpeedUpPrint
	ldr r0, _0225D608 ; =_0225EE40
	bl TextFlags_SetFastForwardTouchButtonHitbox
	add r0, r5, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0225D5FC: .word ov31_0225D7A0
_0225D600: .word 0x04001000
_0225D604: .word 0xFFFF1FFF
_0225D608: .word _0225EE40
	thumb_func_end ov31_0225D520

	thumb_func_start ov31_0225D60C
ov31_0225D60C: ; 0x0225D60C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #8
	mov r1, #0x40
	add r2, r0, #0
	bl MessageFormat_New_Custom
	mov r2, #0x55
	lsl r2, r2, #2
	str r0, [r4, r2]
	mov r0, #0
	mov r1, #0x1b
	add r2, #0x5f
	mov r3, #8
	bl NewMsgDataFromNarc
	mov r1, #0x56
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0
	mov r1, #0x1b
	mov r2, #0xde
	mov r3, #8
	bl NewMsgDataFromNarc
	mov r1, #0x57
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x90
	mov r1, #8
	bl String_New
	mov r1, #0x62
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
	thumb_func_end ov31_0225D60C

	thumb_func_start ov31_0225D654
ov31_0225D654: ; 0x0225D654
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x62
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	mov r0, #0x57
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl DestroyMsgData
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl DestroyMsgData
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl MessageFormat_Delete
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov31_0225D654

	thumb_func_start ov31_0225D684
ov31_0225D684: ; 0x0225D684
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	add r6, r1, #0
	ldr r0, [r5, r0]
	mov r1, #0x11
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x64
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	add r0, #0x64
	mov r1, #0
	bl FillWindowPixelBuffer
	cmp r6, #0
	bne _0225D6DE
	mov r0, #0
	add r1, r4, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	mov r1, #0
	add r3, r0, #0
	mov r6, #0x30
	sub r3, r6, r3
	lsr r3, r3, #1
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0225D70C ; =0x000F0E00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x64
	add r3, #8
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	b _0225D6F8
_0225D6DE:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0225D70C ; =0x000F0E00
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0x64
	mov r3, #5
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0225D6F8:
	add r5, #0x64
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0225D70C: .word 0x000F0E00
	thumb_func_end ov31_0225D684

	thumb_func_start ov31_0225D710
ov31_0225D710: ; 0x0225D710
	push {r4, r5, r6, lr}
	add r6, r1, #0
	add r5, r0, #0
	add r0, r6, #0
	bl SysTask_GetData
	add r4, r0, #0
	mov r0, #0
	bl TextFlags_SetCanTouchSpeedUpPrint
	add r0, r4, #0
	bl ov31_0225DBA0
	add r0, r4, #0
	bl ov31_0225D654
	add r0, r6, #0
	bl DestroySysTaskAndEnvironment
	add r0, r5, #0
	mov r1, #6
	bl FreeBgTilemapBuffer
	add r0, r5, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r5, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	mov r0, #8
	bl Heap_Destroy
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov31_0225D710

	thumb_func_start ov31_0225D758
ov31_0225D758: ; 0x0225D758
	mov r0, #1
	bx lr
	thumb_func_end ov31_0225D758

	thumb_func_start ov31_0225D75C
ov31_0225D75C: ; 0x0225D75C
	cmp r1, #8
	bhi _0225D796
	add r2, r1, r1
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_0225D76C: ; jump table
	.short _0225D77E - _0225D76C - 2 ; case 0
	.short _0225D77E - _0225D76C - 2 ; case 1
	.short _0225D77E - _0225D76C - 2 ; case 2
	.short _0225D77E - _0225D76C - 2 ; case 3
	.short _0225D77E - _0225D76C - 2 ; case 4
	.short _0225D77E - _0225D76C - 2 ; case 5
	.short _0225D792 - _0225D76C - 2 ; case 6
	.short _0225D792 - _0225D76C - 2 ; case 7
	.short _0225D792 - _0225D76C - 2 ; case 8
_0225D77E:
	ldr r3, [r0, #0x14]
	ldr r0, _0225D79C ; =0x00000271
	ldrb r2, [r3, r0]
	sub r0, r0, #1
	ldrb r0, [r3, r0]
	add r1, r1, r2
	cmp r1, r0
	bhs _0225D796
	mov r0, #1
	bx lr
_0225D792:
	mov r0, #1
	bx lr
_0225D796:
	mov r0, #0
	bx lr
	nop
_0225D79C: .word 0x00000271
	thumb_func_end ov31_0225D75C

	thumb_func_start ov31_0225D7A0
ov31_0225D7A0: ; 0x0225D7A0
	push {r3, r4, r5, lr}
	add r5, r1, #0
	ldr r0, [r5, #0xc]
	cmp r0, #0
	beq _0225D7B0
	cmp r0, #1
	beq _0225D7BE
	pop {r3, r4, r5, pc}
_0225D7B0:
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _0225D836
	mov r0, #1
	str r0, [r5, #0xc]
	pop {r3, r4, r5, pc}
_0225D7BE:
	ldr r1, [r5, #0x14]
	ldr r0, _0225D838 ; =0x00000272
	ldrb r0, [r1, r0]
	cmp r0, #3
	beq _0225D7D2
	cmp r0, #7
	beq _0225D7FA
	cmp r0, #0xb
	beq _0225D814
	b _0225D81A
_0225D7D2:
	add r0, r5, #0
	mov r1, #0
	bl ov31_0225DAA4
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	beq _0225D81A
	add r0, r5, #0
	add r1, r4, #0
	bl ov31_0225D75C
	cmp r0, #0
	beq _0225D81A
	mov r0, #0xa5
	ldr r1, [r5, #0x14]
	lsl r0, r0, #2
	str r4, [r1, r0]
	b _0225D81A
_0225D7FA:
	add r0, r5, #0
	mov r1, #1
	bl ov31_0225DAA4
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _0225D81A
	mov r1, #0xa5
	ldr r2, [r5, #0x14]
	lsl r1, r1, #2
	str r0, [r2, r1]
	b _0225D81A
_0225D814:
	add r0, r5, #0
	bl ov31_0225E774
_0225D81A:
	mov r0, #0xa6
	ldr r1, [r5, #0x14]
	lsl r0, r0, #2
	ldr r1, [r1, r0]
	cmp r1, #0
	beq _0225D836
	add r0, r5, #0
	bl ov31_0225D83C
	mov r0, #0xa6
	ldr r1, [r5, #0x14]
	mov r2, #0
	lsl r0, r0, #2
	str r2, [r1, r0]
_0225D836:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0225D838: .word 0x00000272
	thumb_func_end ov31_0225D7A0

	thumb_func_start ov31_0225D83C
ov31_0225D83C: ; 0x0225D83C
	push {r4, lr}
	add r4, r0, #0
	cmp r1, #0xd
	bls _0225D846
	b _0225D9CC
_0225D846:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0225D852: ; jump table
	.short _0225D9CC - _0225D852 - 2 ; case 0
	.short _0225D86E - _0225D852 - 2 ; case 1
	.short _0225D882 - _0225D852 - 2 ; case 2
	.short _0225D8D2 - _0225D852 - 2 ; case 3
	.short _0225D910 - _0225D852 - 2 ; case 4
	.short _0225D950 - _0225D852 - 2 ; case 5
	.short _0225D974 - _0225D852 - 2 ; case 6
	.short _0225D980 - _0225D852 - 2 ; case 7
	.short _0225D998 - _0225D852 - 2 ; case 8
	.short _0225D99E - _0225D852 - 2 ; case 9
	.short _0225D9A4 - _0225D852 - 2 ; case 10
	.short _0225D9AA - _0225D852 - 2 ; case 11
	.short _0225D9C2 - _0225D852 - 2 ; case 12
	.short _0225D9C8 - _0225D852 - 2 ; case 13
_0225D86E:
	bl ov31_0225DD14
	add r0, r4, #0
	bl ov31_0225DF98
	add r0, r4, #0
	mov r1, #0
	bl ov31_0225D684
	pop {r4, pc}
_0225D882:
	mov r1, #1
	bl ov31_0225D9D4
	add r0, r4, #0
	bl ov31_0225DCF4
	add r0, r4, #0
	add r0, #0x54
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	bl ov31_0225EC58
	add r0, r4, #0
	bl ov31_0225E184
	mov r1, #0xa1
	ldr r2, [r4, #0x14]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	add r0, r4, #0
	bl ov31_0225E20C
	ldr r2, [r4, #0x14]
	ldr r1, _0225D9D0 ; =0x00000286
	add r0, r4, #0
	ldrsh r1, [r2, r1]
	bl ov31_0225E2D4
	add r0, r4, #0
	bl ov31_0225E474
	add r0, r4, #0
	mov r1, #1
	bl ov31_0225D684
	add r0, r4, #0
	bl ov31_0225E54C
	pop {r4, pc}
_0225D8D2:
	mov r1, #2
	bl ov31_0225D9D4
	add r0, r4, #0
	bl ov31_0225DCF4
	add r0, r4, #0
	bl ov31_0225EC58
	add r0, r4, #0
	bl ov31_0225E184
	mov r1, #0xa1
	ldr r2, [r4, #0x14]
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	add r0, r4, #0
	bl ov31_0225E20C
	add r0, r4, #0
	bl ov31_0225E5FC
	add r0, r4, #0
	add r0, #0x54
	bl ClearWindowTilemapAndScheduleTransfer
	add r4, #0x64
	add r0, r4, #0
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
_0225D910:
	mov r1, #0
	bl ov31_0225D9D4
	add r0, r4, #0
	bl ov31_0225EDA0
	add r0, r4, #0
	bl ov31_0225DF98
	add r0, r4, #0
	mov r1, #0
	bl ov31_0225D684
	add r0, r4, #0
	bl ov31_0225DCA8
	add r0, r4, #0
	add r0, #0x44
	mov r1, #1
	bl ClearFrameAndWindow2
	add r0, r4, #0
	bl ov31_0225DD14
	add r0, r4, #0
	bl ov31_0225DE84
	add r4, #0x64
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	pop {r4, pc}
_0225D950:
	mov r1, #0
	bl ov31_0225D9D4
	add r0, r4, #0
	bl ov31_0225DF98
	add r0, r4, #0
	add r0, #0x44
	mov r1, #0
	bl ClearFrameAndWindow2
	add r0, r4, #0
	bl ov31_0225DD14
	add r0, r4, #0
	bl ov31_0225DE84
	pop {r4, pc}
_0225D974:
	ldr r2, [r4, #0x14]
	ldr r1, _0225D9D0 ; =0x00000286
	ldrsh r1, [r2, r1]
	bl ov31_0225E2D4
	pop {r4, pc}
_0225D980:
	add r0, #0x64
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	bl ov31_0225E5FC
	pop {r4, pc}
_0225D998:
	bl ov31_0225E700
	pop {r4, pc}
_0225D99E:
	bl ov31_0225E7D4
	pop {r4, pc}
_0225D9A4:
	bl ov31_0225EA08
	pop {r4, pc}
_0225D9AA:
	add r0, #0x64
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	bl ov31_0225EA9C
	pop {r4, pc}
_0225D9C2:
	bl ov31_0225EB30
	pop {r4, pc}
_0225D9C8:
	bl ov31_0225EBC4
_0225D9CC:
	pop {r4, pc}
	nop
_0225D9D0: .word 0x00000286
	thumb_func_end ov31_0225D83C

	thumb_func_start ov31_0225D9D4
ov31_0225D9D4: ; 0x0225D9D4
	push {r3, r4, r5, lr}
	sub sp, #8
	add r4, r0, #0
	cmp r1, #0
	beq _0225D9EA
	cmp r1, #1
	beq _0225DA26
	cmp r1, #2
	beq _0225DA64
	add sp, #8
	pop {r3, r4, r5, pc}
_0225D9EA:
	mov r0, #8
	str r0, [sp]
	mov r0, #0x3c
	mov r1, #0x11
	mov r2, #0
	add r3, sp, #4
	bl GfGfxLoader_GetScrnData
	ldr r3, [sp, #4]
	add r5, r0, #0
	add r2, r3, #0
	ldr r0, [r4, #4]
	ldr r3, [r3, #8]
	mov r1, #6
	add r2, #0xc
	bl BG_LoadScreenTilemapData
	ldr r0, [r4, #4]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	add r0, r5, #0
	bl Heap_Free
	mov r0, #2
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	add sp, #8
	pop {r3, r4, r5, pc}
_0225DA26:
	ldr r0, [r4, #4]
	mov r1, #5
	mov r2, #0
	bl BgFillTilemapBufferAndSchedule
	mov r0, #8
	str r0, [sp]
	mov r0, #0x3c
	mov r1, #0x13
	mov r2, #0
	add r3, sp, #4
	bl GfGfxLoader_GetScrnData
	ldr r3, [sp, #4]
	add r5, r0, #0
	add r2, r3, #0
	ldr r0, [r4, #4]
	ldr r3, [r3, #8]
	mov r1, #6
	add r2, #0xc
	bl BG_LoadScreenTilemapData
	ldr r0, [r4, #4]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	add r0, r5, #0
	bl Heap_Free
	add sp, #8
	pop {r3, r4, r5, pc}
_0225DA64:
	ldr r0, [r4, #4]
	mov r1, #5
	mov r2, #0
	bl BgFillTilemapBufferAndSchedule
	mov r0, #8
	str r0, [sp]
	mov r0, #0x3c
	mov r1, #0x14
	mov r2, #0
	add r3, sp, #4
	bl GfGfxLoader_GetScrnData
	ldr r3, [sp, #4]
	add r5, r0, #0
	add r2, r3, #0
	ldr r0, [r4, #4]
	ldr r3, [r3, #8]
	mov r1, #6
	add r2, #0xc
	bl BG_LoadScreenTilemapData
	ldr r0, [r4, #4]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	add r0, r5, #0
	bl Heap_Free
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov31_0225D9D4

	thumb_func_start ov31_0225DAA4
ov31_0225DAA4: ; 0x0225DAA4
	push {r4, lr}
	add r4, r1, #0
	beq _0225DAB2
	cmp r4, #1
	beq _0225DAB2
	bl GF_AssertFail
_0225DAB2:
	ldr r0, _0225DAC0 ; =_0225EF40
	lsl r1, r4, #2
	ldr r0, [r0, r1]
	bl TouchscreenHitbox_FindRectAtTouchNew
	pop {r4, pc}
	nop
_0225DAC0: .word _0225EF40
	thumb_func_end ov31_0225DAA4

	thumb_func_start ov31_0225DAC4
ov31_0225DAC4: ; 0x0225DAC4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0
	bl GXS_SetGraphicsMode
	mov r0, #0x80
	bl GX_SetBankForSubBG
	mov r0, #1
	lsl r0, r0, #8
	bl GX_SetBankForSubOBJ
	ldr r2, _0225DB24 ; =0x04001000
	ldr r0, _0225DB28 ; =0xFFCFFFEF
	ldr r1, [r2]
	mov r3, #0
	and r1, r0
	mov r0, #0x10
	orr r0, r1
	str r0, [r2]
	ldr r0, [r4, #4]
	ldr r2, _0225DB2C ; =ov31_0225EED0
	mov r1, #4
	bl InitBgFromTemplate
	ldr r0, [r4, #4]
	ldr r2, _0225DB30 ; =ov31_0225EEEC
	mov r1, #5
	mov r3, #0
	bl InitBgFromTemplate
	ldr r0, [r4, #4]
	ldr r2, _0225DB34 ; =ov31_0225EF08
	mov r1, #6
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #6
	mov r1, #0x20
	mov r2, #0
	mov r3, #4
	bl BG_ClearCharDataRange
	ldr r0, [r4, #4]
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	pop {r4, pc}
	.balign 4, 0
_0225DB24: .word 0x04001000
_0225DB28: .word 0xFFCFFFEF
_0225DB2C: .word ov31_0225EED0
_0225DB30: .word ov31_0225EEEC
_0225DB34: .word ov31_0225EF08
	thumb_func_end ov31_0225DAC4

	thumb_func_start ov31_0225DB38
ov31_0225DB38: ; 0x0225DB38
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, _0225DB9C ; =0x04001050
	mov r3, #0
	strh r3, [r0]
	str r3, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #0x3c
	mov r1, #0xf
	mov r2, #4
	bl GfGfxLoader_GXLoadPal
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #8
	str r0, [sp, #0xc]
	ldr r2, [r4, #4]
	mov r0, #0x3c
	mov r1, #0x10
	mov r3, #5
	bl GfGfxLoader_LoadCharData
	add r0, r4, #0
	mov r1, #0
	bl ov31_0225D9D4
	mov r1, #0x16
	mov r0, #4
	lsl r1, r1, #4
	mov r2, #8
	bl LoadFontPal1
	mov r1, #6
	mov r0, #4
	lsl r1, r1, #6
	mov r2, #8
	bl LoadFontPal0
	add r0, r4, #0
	bl ov31_0225DBD4
	add r0, r4, #0
	bl ov31_0225DCA8
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_0225DB9C: .word 0x04001050
	thumb_func_end ov31_0225DB38

	thumb_func_start ov31_0225DBA0
ov31_0225DBA0: ; 0x0225DBA0
	push {r4, lr}
	add r4, r0, #0
	bl ov31_0225DCF4
	add r0, r4, #0
	add r0, #0x34
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0x44
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0x74
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0x54
	bl RemoveWindow
	add r4, #0x64
	add r0, r4, #0
	bl RemoveWindow
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov31_0225DBA0

	thumb_func_start ov31_0225DBD4
ov31_0225DBD4: ; 0x0225DBD4
	push {r3, r4, lr}
	sub sp, #0x14
	mov r1, #1
	add r4, r0, #0
	str r1, [sp]
	mov r0, #0x1b
	str r0, [sp, #4]
	mov r3, #2
	str r3, [sp, #8]
	mov r0, #0xb
	str r0, [sp, #0xc]
	str r1, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x34
	mov r2, #4
	bl AddWindowParameterized
	mov r0, #1
	str r0, [sp]
	mov r0, #0x1b
	str r0, [sp, #4]
	mov r2, #4
	add r1, r4, #0
	str r2, [sp, #8]
	mov r0, #0xb
	str r0, [sp, #0xc]
	mov r0, #0x1d
	str r0, [sp, #0x10]
	ldr r0, [r4, #4]
	add r1, #0x44
	mov r3, #2
	bl AddWindowParameterized
	mov r0, #0
	str r0, [sp]
	mov r0, #9
	str r0, [sp, #4]
	mov r2, #4
	add r1, r4, #0
	str r2, [sp, #8]
	mov r0, #0xb
	str r0, [sp, #0xc]
	mov r0, #0x89
	str r0, [sp, #0x10]
	ldr r0, [r4, #4]
	add r1, #0x74
	mov r3, #1
	bl AddWindowParameterized
	mov r0, #0x15
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xc
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x54
	mov r2, #4
	mov r3, #0xa
	bl AddWindowParameterized
	add r0, r4, #0
	add r0, #0x54
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r0, #0x15
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xc
	str r0, [sp, #0xc]
	mov r0, #0xf
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x64
	mov r2, #4
	mov r3, #0x18
	bl AddWindowParameterized
	add r0, r4, #0
	add r0, #0x64
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r2, #0
	add r1, r2, #0
_0225DC94:
	add r0, r4, #0
	add r0, #0x84
	add r2, r2, #1
	add r4, #0x10
	str r1, [r0]
	cmp r2, #0xd
	blt _0225DC94
	add sp, #0x14
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov31_0225DBD4

	thumb_func_start ov31_0225DCA8
ov31_0225DCA8: ; 0x0225DCA8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r0, #0
	add r5, r7, #0
	ldr r4, _0225DCF0 ; =ov31_0225EE88
	mov r6, #0
	add r5, #0x84
_0225DCB6:
	ldr r0, [r4, #4]
	add r1, r5, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0xb
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xc
	str r0, [sp, #0xc]
	ldr r0, [r4, #8]
	mov r2, #4
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r3, [r4]
	ldr r0, [r7, #4]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x18
	bl AddWindowParameterized
	add r6, r6, #1
	add r4, #0xc
	add r5, #0x10
	cmp r6, #6
	blt _0225DCB6
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0225DCF0: .word ov31_0225EE88
	thumb_func_end ov31_0225DCA8

	thumb_func_start ov31_0225DCF4
ov31_0225DCF4: ; 0x0225DCF4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
	add r5, #0x84
_0225DCFC:
	add r0, r5, #0
	bl ClearWindowTilemapAndCopyToVram
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #6
	blt _0225DCFC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov31_0225DCF4

	thumb_func_start ov31_0225DD14
ov31_0225DD14: ; 0x0225DD14
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	mov r6, #0
	add r4, r5, #0
	add r4, #0x84
	add r7, r6, #0
_0225DD22:
	add r0, r4, #0
	add r1, r7, #0
	bl FillWindowPixelBuffer
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #6
	blt _0225DD22
	mov r0, #0x27
	ldr r2, [r5, #0x14]
	lsl r0, r0, #4
	ldrb r1, [r2, r0]
	add r0, r0, #1
	ldrb r0, [r2, r0]
	sub r0, r1, r0
	str r0, [sp, #4]
	cmp r0, #6
	ble _0225DD4C
	mov r0, #6
	str r0, [sp, #4]
	b _0225DD54
_0225DD4C:
	cmp r0, #0
	bge _0225DD54
	mov r0, #0
	str r0, [sp, #4]
_0225DD54:
	ldr r0, [sp, #4]
	mov r4, #0
	cmp r0, #0
	ble _0225DDD6
	add r6, r5, #0
	add r6, #0x84
_0225DD60:
	ldr r0, [r5, #0x14]
	ldr r1, _0225DDF8 ; =0x00000271
	ldrb r1, [r0, r1]
	add r1, r4, r1
	str r1, [sp, #0xc]
	mov r1, #0x9a
	lsl r1, r1, #2
	ldr r1, [r0, r1]
	ldr r0, [sp, #0xc]
	lsl r0, r0, #1
	ldrh r7, [r1, r0]
	mov r0, #0x57
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r7, #0
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	ldr r2, [sp, #0x10]
	add r0, r5, #0
	add r1, r6, #0
	add r3, r4, #0
	bl ov31_0225DE00
	ldr r0, [sp, #0x10]
	bl String_Delete
	ldr r0, [r5, #0x14]
	ldr r1, [sp, #0xc]
	add r2, r7, #0
	bl ov31_0225E12C
	cmp r0, #0
	beq _0225DDCC
	ldr r0, [r5, #0x14]
	lsl r1, r7, #0x10
	str r0, [sp, #8]
	lsr r1, r1, #0x10
	bl ov03_02258120
	add r3, r0, #0
	ldr r1, [sp, #8]
	ldr r0, _0225DDFC ; =0x00000283
	add r2, r6, #0
	ldrb r0, [r1, r0]
	mov r1, #0x56
	lsl r1, r1, #2
	str r0, [sp]
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	bl ov31_0225DE24
_0225DDCC:
	ldr r0, [sp, #4]
	add r4, r4, #1
	add r6, #0x10
	cmp r4, r0
	blt _0225DD60
_0225DDD6:
	add r4, r5, #0
	mov r6, #0
	add r4, #0x84
_0225DDDC:
	add r0, r4, #0
	bl ScheduleWindowCopyToVram
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #6
	blt _0225DDDC
	ldr r1, [sp, #4]
	add r0, r5, #0
	bl ov31_0225E0E4
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0225DDF8: .word 0x00000271
_0225DDFC: .word 0x00000283
	thumb_func_end ov31_0225DD14

	thumb_func_start ov31_0225DE00
ov31_0225DE00: ; 0x0225DE00
	push {r3, lr}
	sub sp, #0x10
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0225DE20 ; =0x00010200
	str r0, [sp, #8]
	add r0, r1, #0
	add r1, r3, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r3, pc}
	nop
_0225DE20: .word 0x00010200
	thumb_func_end ov31_0225DE00
