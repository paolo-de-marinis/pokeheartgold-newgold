#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start ov14_021F6E68
ov14_021F6E68: ; 0x021F6E68
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	cmp r4, #6
	beq _021F6E8A
	cmp r4, #7
	beq _021F6E8A
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F6E8A:
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6E68

	thumb_func_start ov14_021F6E8C
ov14_021F6E8C: ; 0x021F6E8C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	cmp r4, #0x27
	ldr r1, [r5, #0x34]
	bhs _021F6EE4
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6ED8
	cmp r4, #0x22
	blo _021F6EE0
	cmp r4, #0x26
	bhi _021F6EE0
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F6ED8:
	cmp r4, #0x21
	bne _021F6EE0
	mov r0, #0x26
	pop {r4, r5, r6, pc}
_021F6EE0:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
_021F6EE4:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021F6F02
	cmp r4, #0x21
	beq _021F6EFE
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F6F02
_021F6EFE:
	mov r0, #0x26
	pop {r4, r5, r6, pc}
_021F6F02:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021F6E8C

	thumb_func_start ov14_021F6F08
ov14_021F6F08: ; 0x021F6F08
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F6F5A
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6F4C
	add r0, r4, #0
	sub r0, #0x1f
	cmp r0, #1
	bhi _021F6F32
	mov r4, #0x1e
	b _021F6F5A
_021F6F32:
	cmp r4, #0x1e
	beq _021F6F5A
	cmp r4, #0x21
	beq _021F6F5A
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0xff
	beq _021F6F48
	cmp r4, #0x1e
	blo _021F6F5A
_021F6F48:
	mov r4, #0
	b _021F6F5A
_021F6F4C:
	cmp r4, #0x23
	beq _021F6F5A
	cmp r4, #0x24
	beq _021F6F5A
	cmp r4, #0x25
	beq _021F6F5A
	mov r4, #0x22
_021F6F5A:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6F08

	thumb_func_start ov14_021F6F70
ov14_021F6F70: ; 0x021F6F70
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	cmp r4, #0x1f
	beq _021F6F92
	cmp r4, #0x20
	beq _021F6F92
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
_021F6F92:
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F6F70

	thumb_func_start ov14_021F6F94
ov14_021F6F94: ; 0x021F6F94
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r6, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F6FDC
	cmp r4, #0x24
	blo _021F700C
	cmp r4, #0x28
	bhi _021F700C
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F6FDC:
	add r0, r4, #0
	sub r0, #0x21
	cmp r0, #1
	bhi _021F6FFC
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F6B28
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
_021F6FFC:
	cmp r4, #0x23
	beq _021F7008
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _021F700C
_021F7008:
	mov r0, #0x29
	pop {r4, r5, r6, pc}
_021F700C:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021F6F94

	thumb_func_start ov14_021F7010
ov14_021F7010: ; 0x021F7010
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	add r4, r1, #0
	cmp r2, r0
	beq _021F7076
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021F7060
	add r0, r4, #0
	sub r0, #0x1e
	cmp r0, #5
	bhi _021F7052
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021F7042: ; jump table
	.short _021F7076 - _021F7042 - 2 ; case 0
	.short _021F704E - _021F7042 - 2 ; case 1
	.short _021F704E - _021F7042 - 2 ; case 2
	.short _021F7076 - _021F7042 - 2 ; case 3
	.short _021F7076 - _021F7042 - 2 ; case 4
	.short _021F7076 - _021F7042 - 2 ; case 5
_021F704E:
	mov r4, #0x1e
	b _021F7076
_021F7052:
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021F7076
	mov r4, #0
	b _021F7076
_021F7060:
	cmp r4, #0x24
	bne _021F7074
	cmp r4, #0x25
	bne _021F7074
	cmp r4, #0x26
	bne _021F7074
	cmp r4, #0x27
	bne _021F7074
	cmp r4, #0x28
	beq _021F7076
_021F7074:
	mov r4, #0x24
_021F7076:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F7010

	thumb_func_start ov14_021F708C
ov14_021F708C: ; 0x021F708C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	ldr r1, _021F70A0 ; =ov14_021E9F20
	bl ov14_021E5A50
	pop {r4, pc}
	.balign 4, 0
_021F70A0: .word ov14_021E9F20
	thumb_func_end ov14_021F708C

	thumb_func_start ov14_021F70A4
ov14_021F70A4: ; 0x021F70A4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	add r4, r1, #0
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F6B28
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F70A4

	thumb_func_start ov14_021F70C0
ov14_021F70C0: ; 0x021F70C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021F70DE
	ldr r0, [r5, #0x34]
	mov r1, #0x2d
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_ClearEnabledFlag
_021F70DE:
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetAllEnabled
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021F70C0

	thumb_func_start ov14_021F70F4
ov14_021F70F4: ; 0x021F70F4
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	sub r0, #0x2b
	cmp r0, #1
	bhi _021F7118
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r4, r1, #0
	ldr r1, [r5, #0x34]
	ldr r0, _021F717C ; =0x0000043C
	add r4, #0x25
	str r4, [r1, r0]
_021F7118:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	ldr r1, _021F7180 ; =0x0000044B
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021F7178
	cmp r4, #0x25
	blt _021F7170
	cmp r4, #0x2a
	bgt _021F7170
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	pop {r3, r4, r5, pc}
_021F7170:
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021F7178:
	pop {r3, r4, r5, pc}
	nop
_021F717C: .word 0x0000043C
_021F7180: .word 0x0000044B
	thumb_func_end ov14_021F70F4
