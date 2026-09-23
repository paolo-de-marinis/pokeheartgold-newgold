	.include "asm/macros.inc"
	.include "overlay_98.inc"
	.include "global.inc"

.public _0221F194
.public ov98_0221F19C
.public ov98_0221F1AC
.public ov98_0221F1C0

	.text

	thumb_func_start ov98_0221EE84
ov98_0221EE84: ; 0x0221EE84
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov98_0221EF14
	ldr r1, [r5, #4]
	lsl r0, r4, #4
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov98_0221EE84

	thumb_func_start ov98_0221EE9C
ov98_0221EE9C: ; 0x0221EE9C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r5, r1, #0
	add r6, r2, #0
	add r7, r3, #0
	bl ov98_0221EF14
	add r0, sp, #0x18
	ldrb r0, [r0, #0x10]
	mov r1, #0
	lsl r5, r5, #4
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EED8 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r0, [r4, #4]
	add r3, r7, #0
	add r0, r0, r5
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221EED8: .word 0x00010200
	thumb_func_end ov98_0221EE9C

	thumb_func_start ov98_0221EEDC
ov98_0221EEDC: ; 0x0221EEDC
	ldr r2, [r0, #4]
	lsl r0, r1, #4
	ldr r3, _0221EEE8 ; =ClearWindowTilemapAndScheduleTransfer
	add r0, r2, r0
	bx r3
	nop
_0221EEE8: .word ClearWindowTilemapAndScheduleTransfer
	thumb_func_end ov98_0221EEDC

	thumb_func_start ov98_0221EEEC
ov98_0221EEEC: ; 0x0221EEEC
	ldr r3, [r0, #4]
	lsl r0, r1, #4
	add r0, r3, r0
	ldr r3, _0221EEF8 ; =SetWindowY
	add r1, r2, #0
	bx r3
	.balign 4, 0
_0221EEF8: .word SetWindowY
	thumb_func_end ov98_0221EEEC

	thumb_func_start ov98_0221EEFC
ov98_0221EEFC: ; 0x0221EEFC
	push {r4, lr}
	add r4, r0, #0
	bne _0221EF06
	bl GF_AssertFail
_0221EF06:
	ldr r0, [r4, #0x10]
	cmp r0, #0
	bne _0221EF10
	bl GF_AssertFail
_0221EF10:
	ldr r0, [r4, #0x10]
	pop {r4, pc}
	thumb_func_end ov98_0221EEFC

	thumb_func_start ov98_0221EF14
ov98_0221EF14: ; 0x0221EF14
	ldr r2, [r0, #4]
	lsl r0, r1, #4
	ldr r3, _0221EF20 ; =FillWindowPixelBuffer
	add r0, r2, r0
	mov r1, #0
	bx r3
	.balign 4, 0
_0221EF20: .word FillWindowPixelBuffer
	thumb_func_end ov98_0221EF14

	thumb_func_start ov98_0221EF24
ov98_0221EF24: ; 0x0221EF24
	push {r3, r4, lr}
	sub sp, #4
	ldr r2, _0221EF5C ; =ov98_0221F1E0
	add r1, sp, #0
	ldrb r3, [r2]
	add r0, sp, #0
	mov r4, #0
	strb r3, [r1]
	ldrb r3, [r2, #1]
	strb r3, [r1, #1]
	ldrb r3, [r2, #2]
	ldrb r2, [r2, #3]
	strb r3, [r1, #2]
	strb r2, [r1, #3]
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	bne _0221EF52
	ldr r0, _0221EF60 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #2
	tst r0, r1
	beq _0221EF54
_0221EF52:
	mov r4, #1
_0221EF54:
	add r0, r4, #0
	add sp, #4
	pop {r3, r4, pc}
	nop
_0221EF5C: .word ov98_0221F1E0
_0221EF60: .word gSystem
	thumb_func_end ov98_0221EF24

	thumb_func_start ov98_0221EF64
ov98_0221EF64: ; 0x0221EF64
	ldr r1, _0221EF7C ; =0x000001C2
	cmp r0, r1
	blo _0221EF6E
	mov r0, #2
	bx lr
_0221EF6E:
	sub r1, #0x1e
	cmp r0, r1
	blo _0221EF78
	mov r0, #1
	bx lr
_0221EF78:
	mov r0, #0
	bx lr
	.balign 4, 0
_0221EF7C: .word 0x000001C2
	thumb_func_end ov98_0221EF64

	thumb_func_start ov98_0221EF80
ov98_0221EF80: ; 0x0221EF80
	ldr r2, _0221EFA0 ; =ov98_0221F220
	mov r3, #0
_0221EF84:
	lsl r1, r3, #2
	ldr r1, [r2, r1]
	cmp r1, r0
	ble _0221EF96
	add r1, r3, #1
	lsl r1, r1, #0x18
	lsr r3, r1, #0x18
	cmp r3, #0xa
	blo _0221EF84
_0221EF96:
	mov r0, #0xa
	sub r0, r0, r3
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bx lr
	.balign 4, 0
_0221EFA0: .word ov98_0221F220
	thumb_func_end ov98_0221EF80

	thumb_func_start ov98_0221EFA4
ov98_0221EFA4: ; 0x0221EFA4
	lsl r2, r0, #2
	ldr r0, _0221EFB0 ; =ov98_0221F1F8
	lsl r1, r1, #1
	add r0, r0, r2
	ldrh r0, [r1, r0]
	bx lr
	.balign 4, 0
_0221EFB0: .word ov98_0221F1F8
	thumb_func_end ov98_0221EFA4

	thumb_func_start ov98_0221EFB4
ov98_0221EFB4: ; 0x0221EFB4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	bl ov98_0221EFA4
	ldr r1, _0221EFE4 ; =0x0000FFFF
	cmp r4, r1
	bne _0221EFC8
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221EFC8:
	cmp r5, #0
	bne _0221EFD8
	cmp r4, r0
	bhs _0221EFD4
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221EFD4:
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221EFD8:
	cmp r4, r0
	bls _0221EFE0
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221EFE0:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221EFE4: .word 0x0000FFFF
	thumb_func_end ov98_0221EFB4

	thumb_func_start ov98_0221EFE8
ov98_0221EFE8: ; 0x0221EFE8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r2, #0
	bl ov98_0221EFA4
	ldr r1, _0221F018 ; =0x0000FFFF
	cmp r4, r1
	bne _0221EFFC
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221EFFC:
	cmp r5, #0
	bne _0221F00C
	cmp r4, r0
	bhi _0221F008
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221F008:
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221F00C:
	cmp r4, r0
	blo _0221F014
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221F014:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221F018: .word 0x0000FFFF
	thumb_func_end ov98_0221EFE8

	thumb_func_start ov98_0221F01C
ov98_0221F01C: ; 0x0221F01C
	lsl r1, r1, #3
	ldrh r0, [r0, r1]
	bx lr
	.balign 4, 0
	thumb_func_end ov98_0221F01C

	thumb_func_start ov98_0221F024
ov98_0221F024: ; 0x0221F024
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r5, _0221F050 ; =0x00000000
	bne _0221F030
	bl GF_AssertFail
_0221F030:
	ldr r7, _0221F054 ; =0x000001ED
	mov r4, #0
_0221F034:
	ldrb r0, [r6, r4]
	bl MATH_CountPopulation
	cmp r0, #5
	bne _0221F044
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
_0221F044:
	add r4, r4, #1
	cmp r4, r7
	blt _0221F034
	add r0, r5, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221F050: .word 0x00000000
_0221F054: .word 0x000001ED
	thumb_func_end ov98_0221F024

	thumb_func_start ov98_0221F058
ov98_0221F058: ; 0x0221F058
	push {r3, r4, r5, r6, r7, lr}
	mov r5, #0
	add r6, r0, #0
	add r4, r5, #0
	mov r7, #0x2c
_0221F062:
	add r0, r4, #0
	mul r0, r7
	add r0, r6, r0
	mov r1, #0
	bl ov98_0221F01C
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #1
	bl ov98_0221EFE8
	cmp r0, #0
	beq _0221F082
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
_0221F082:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0xa
	blo _0221F062
	add r0, r5, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov98_0221F058

	thumb_func_start ov98_0221F090
ov98_0221F090: ; 0x0221F090
	push {r3, lr}
	mov r0, #0
	add r1, r0, #0
	bl sub_0200FBF4
	mov r0, #1
	mov r1, #0
	bl sub_0200FBF4
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _0221F0DC ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _0221F0E0 ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	ldr r2, _0221F0E4 ; =0x04000304
	ldr r0, _0221F0E8 ; =0xFFFF7FFF
	ldrh r1, [r2]
	and r0, r1
	strh r0, [r2]
	bl ov98_0221F174
	pop {r3, pc}
	nop
_0221F0DC: .word 0xFFFFE0FF
_0221F0E0: .word 0x04001000
_0221F0E4: .word 0x04000304
_0221F0E8: .word 0xFFFF7FFF
	thumb_func_end ov98_0221F090

	thumb_func_start ov98_0221F0EC
ov98_0221F0EC: ; 0x0221F0EC
	push {r3, lr}
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	bl GfGfx_DisableEngineAPlanes
	bl GfGfx_DisableEngineBPlanes
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _0221F118 ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _0221F11C ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	pop {r3, pc}
	.balign 4, 0
_0221F118: .word 0xFFFFE0FF
_0221F11C: .word 0x04001000
	thumb_func_end ov98_0221F0EC

	thumb_func_start ov98_0221F120
ov98_0221F120: ; 0x0221F120
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	beq _0221F12C
	cmp r4, #5
	blo _0221F130
_0221F12C:
	bl GF_AssertFail
_0221F130:
	ldr r1, _0221F14C ; =ov98_0221F1E4
	lsl r2, r4, #2
	ldr r1, [r1, r2]
	add r0, r5, #0
	bl _u32_div_f
	add r0, r1, #0
	sub r1, r4, #1
	lsl r2, r1, #2
	ldr r1, _0221F14C ; =ov98_0221F1E4
	ldr r1, [r1, r2]
	bl _u32_div_f
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221F14C: .word ov98_0221F1E4
	thumb_func_end ov98_0221F120

	thumb_func_start ov98_0221F150
ov98_0221F150: ; 0x0221F150
	push {r3, r4, r5, lr}
	mov r5, #0
	cmp r0, #0
	bne _0221F15C
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221F15C:
	mov r4, #0xa
_0221F15E:
	cmp r0, #0
	beq _0221F170
	add r1, r4, #0
	bl _s32_div_f
	add r1, r5, #1
	lsl r1, r1, #0x18
	lsr r5, r1, #0x18
	b _0221F15E
_0221F170:
	add r0, r5, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov98_0221F150

	thumb_func_start ov98_0221F174
ov98_0221F174: ; 0x0221F174
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _0221F190 ; =ov98_0221F248
	add r3, sp, #0
	mov r2, #5
_0221F17E:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0221F17E
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_0221F190: .word ov98_0221F248
	thumb_func_end ov98_0221F174

	.rodata

_0221F194:
	.byte 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00

ov98_0221F19C: ; 0x0221F19C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00

ov98_0221F1AC: ; 0x0221F1AC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x02, 0x00, 0x00, 0x40, 0x00, 0x00, 0x10, 0x00, 0x10, 0x00, 0x10, 0x00, 0x10, 0x00

ov98_0221F1C0: ; 0x0221F1C0
	.byte 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00

ov98_0221F1E0: ; 0x0221F1E0
	.byte 0xA0, 0xC0, 0xC0, 0x00

ov98_0221F1E4: ; 0x0221F1E4
	.byte 0x01, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x64, 0x00, 0x00, 0x00
	.byte 0xE8, 0x03, 0x00, 0x00, 0x10, 0x27, 0x00, 0x00

ov98_0221F1F8: ; 0x0221F1F8
	.byte 0xB8, 0x0B, 0x60, 0x09, 0x23, 0x00, 0x32, 0x00
	.byte 0x28, 0x00, 0x3C, 0x00, 0x50, 0x00, 0x82, 0x00, 0x28, 0x00, 0x46, 0x00, 0x5E, 0x01, 0xF4, 0x01
	.byte 0x00, 0x30, 0x00, 0x40, 0x46, 0x00, 0x64, 0x00, 0x1E, 0x00, 0x37, 0x00, 0x03, 0x00, 0x09, 0x00

ov98_0221F220: ; 0x0221F220
	.byte 0xC8, 0x00, 0x00, 0x00, 0x96, 0x00, 0x00, 0x00, 0x64, 0x00, 0x00, 0x00, 0x4B, 0x00, 0x00, 0x00
	.byte 0x32, 0x00, 0x00, 0x00, 0x19, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00

ov98_0221F248: ; 0x0221F248
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	; 0x0221F270
