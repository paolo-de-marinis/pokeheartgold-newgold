#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

.public ov14_021F29E4
.public ov14_021F2A18
.public ov14_021F2A74
.public ov14_021F2C1C

	.text

	thumb_func_start ov14_021F3DE8
ov14_021F3DE8: ; 0x021F3DE8
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021F3E64 ; =0x0000C12D
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #8]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x13
	mov r3, #0x42
	bl SpriteSystem_LoadCharResObj
	mov r0, #0
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, _021F3E68 ; =0x0000C101
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #0xc]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x13
	mov r3, #0x45
	bl SpriteSystem_LoadPlttResObj
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3E6C ; =0x0000C0FF
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x13
	mov r3, #0x43
	bl SpriteSystem_LoadCellResObj
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F3E6C ; =0x0000C0FF
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #0x13
	mov r3, #0x44
	bl SpriteSystem_LoadAnimResObj
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021F3E64: .word 0x0000C12D
_021F3E68: .word 0x0000C101
_021F3E6C: .word 0x0000C0FF
	thumb_func_end ov14_021F3DE8

	thumb_func_start ov14_021F3E70
ov14_021F3E70: ; 0x021F3E70
	push {r4, lr}
	mov r1, #0xbd
	add r4, r0, #0
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldr r1, [r4, r1]
	ldr r2, _021F3F48 ; =ov14_021F81A8
	bl SpriteSystem_NewSprite
	mov r1, #0xbf
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #8
	sub r1, r1, #4
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F4C ; =ov14_021F81DC
	bl SpriteSystem_NewSprite
	mov r1, #3
	lsl r1, r1, #8
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0xc
	sub r1, #8
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F50 ; =ov14_021F8278
	bl SpriteSystem_NewSprite
	mov r1, #0xc3
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x18
	sub r1, #0x14
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F54 ; =ov14_021F82AC
	bl SpriteSystem_NewSprite
	mov r1, #0x31
	lsl r1, r1, #4
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x1c
	sub r1, #0x18
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F58 ; =ov14_021F82E0
	bl SpriteSystem_NewSprite
	mov r1, #0xc5
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x20
	sub r1, #0x1c
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F5C ; =ov14_021F8314
	bl SpriteSystem_NewSprite
	mov r1, #0xc6
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x24
	sub r1, #0x20
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F60 ; =ov14_021F8348
	bl SpriteSystem_NewSprite
	mov r1, #0xc7
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x28
	sub r1, #0x24
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F64 ; =ov14_021F837C
	bl SpriteSystem_NewSprite
	mov r1, #0x32
	lsl r1, r1, #4
	str r0, [r4, r1]
	add r0, r1, #0
	sub r0, #0x2c
	sub r1, #0x28
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	ldr r2, _021F3F68 ; =ov14_021F83B0
	bl SpriteSystem_NewSprite
	mov r1, #0xc9
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0
	bl ov14_021F2A18
	pop {r4, pc}
	nop
_021F3F48: .word ov14_021F81A8
_021F3F4C: .word ov14_021F81DC
_021F3F50: .word ov14_021F8278
_021F3F54: .word ov14_021F82AC
_021F3F58: .word ov14_021F82E0
_021F3F5C: .word ov14_021F8314
_021F3F60: .word ov14_021F8348
_021F3F64: .word ov14_021F837C
_021F3F68: .word ov14_021F83B0
	thumb_func_end ov14_021F3E70

	thumb_func_start ov14_021F3F6C
ov14_021F3F6C: ; 0x021F3F6C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x4c
	add r6, r0, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0xff
	bne _021F3F7C
	b _021F40C0
_021F3F7C:
	ldr r4, [r6, #0x34]
	add r2, sp, #0x14
	add r1, r4, r0
	ldr r0, _021F40C4 ; =0x00004094
	ldrb r0, [r1, r0]
	add r1, sp, #0x14
	add r1, #2
	str r0, [sp, #0xc]
	lsl r5, r0, #2
	mov r0, #0xbf
	lsl r0, r0, #2
	add r7, r4, r0
	ldr r0, [r7, r5]
	bl ManagedSprite_GetPositionXY
	mov r0, #0x3f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _021F402C
	ldr r3, _021F40C8 ; =ov14_021F810C
	add r2, sp, #0x18
	mov r6, #6
_021F3FAA:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _021F3FAA
	ldr r0, [r3]
	str r0, [r2]
	ldr r0, [r7, r5]
	bl ManagedSprite_GetDrawPriority
	add r0, r0, #1
	str r0, [sp, #0x20]
	ldr r0, [r7, r5]
	bl ManagedSprite_GetPriority
	str r0, [sp, #0x44]
	ldr r1, _021F40CC ; =0x0000C0E0
	ldr r0, [sp, #0xc]
	mov r5, #0
	add r0, r0, r1
	str r0, [sp, #0x2c]
	ldr r0, _021F40D0 ; =0x000088D2
	mov r1, #1
	strh r1, [r4, r0]
	add r7, sp, #0x14
_021F3FDA:
	mov r0, #2
	ldrsh r1, [r7, r0]
	ldr r0, _021F40D4 ; =ov14_021F8070
	add r2, sp, #0x18
	ldrsb r0, [r0, r5]
	add r0, r1, r0
	strh r0, [r7, #4]
	mov r0, #0
	ldrsh r1, [r7, r0]
	ldr r0, _021F40D8 ; =ov14_021F8078
	ldrsb r0, [r0, r5]
	add r0, r1, r0
	strh r0, [r7, #6]
	lsl r0, r5, #2
	add r6, r4, r0
	mov r0, #0xbd
	mov r1, #0xbe
	lsl r0, r0, #2
	lsl r1, r1, #2
	ldr r0, [r4, r0]
	ldr r1, [r4, r1]
	bl SpriteSystem_NewSprite
	mov r1, #0x3f
	lsl r1, r1, #4
	str r0, [r6, r1]
	add r0, r1, #0
	ldr r0, [r6, r0]
	mov r1, #8
	bl ManagedSprite_SetPaletteOverride
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #8
	blo _021F3FDA
	ldr r0, _021F40D0 ; =0x000088D2
	mov r1, #0
	add sp, #0x4c
	strh r1, [r4, r0]
	pop {r4, r5, r6, r7, pc}
_021F402C:
	ldr r0, [r7, r5]
	ldr r0, [r0]
	bl Sprite_GetImageProxy
	str r0, [sp, #8]
	ldr r0, [r7, r5]
	bl ManagedSprite_GetDrawPriority
	str r0, [sp, #0x10]
	ldr r0, [r7, r5]
	bl ManagedSprite_GetPriority
	str r0, [sp, #4]
	mov r5, #0
_021F4048:
	lsl r7, r5, #2
	mov r0, #0x3f
	add r1, r4, r7
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	str r1, [sp]
	ldr r0, [r0]
	ldr r1, [sp, #8]
	bl Sprite_SetImageProxy
	mov r0, #0x3f
	ldr r1, [sp]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r2, sp, #0x14
	mov r1, #2
	ldrsh r1, [r2, r1]
	ldr r2, _021F40D4 ; =ov14_021F8070
	add r3, sp, #0x14
	ldrsb r2, [r2, r5]
	add r1, r1, r2
	mov r2, #0
	ldrsh r3, [r3, r2]
	ldr r2, _021F40D8 ; =ov14_021F8078
	lsl r1, r1, #0x10
	ldrsb r2, [r2, r5]
	asr r1, r1, #0x10
	add r2, r3, r2
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r2, [sp, #0x10]
	add r1, r5, #0
	ldr r0, [r6, #0x34]
	add r1, #0x3d
	add r2, r2, #1
	bl ov14_021F2A74
	ldr r0, [r6, #0x34]
	add r1, r0, r7
	mov r0, #0x3f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r1, [sp, #4]
	bl ManagedSprite_SetPriority
	ldr r0, [r6, #0x34]
	add r1, r0, r7
	mov r0, #0x3f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #8
	blo _021F4048
_021F40C0:
	add sp, #0x4c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F40C4: .word 0x00004094
_021F40C8: .word ov14_021F810C
_021F40CC: .word 0x0000C0E0
_021F40D0: .word 0x000088D2
_021F40D4: .word ov14_021F8070
_021F40D8: .word ov14_021F8078
	thumb_func_end ov14_021F3F6C

	thumb_func_start ov14_021F40DC
ov14_021F40DC: ; 0x021F40DC
	ldr r3, _021F40E4 ; =ov14_021F40E8
	mov r1, #0
	bx r3
	nop
_021F40E4: .word ov14_021F40E8
	thumb_func_end ov14_021F40DC

	thumb_func_start ov14_021F40E8
ov14_021F40E8: ; 0x021F40E8
	push {r3, r4, r5, r6, r7, lr}
	add r7, r1, #0
	add r5, r0, #0
	cmp r7, #1
	bne _021F40F6
	mov r7, #1
	b _021F40F8
_021F40F6:
	mov r7, #0
_021F40F8:
	mov r6, #0
	add r4, r6, #0
_021F40FC:
	ldr r0, [r5, #0x34]
	add r1, r0, r4
	mov r0, #0x3f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	cmp r0, #0
	beq _021F4164
	add r1, r7, #0
	bl ManagedSprite_SetDrawFlag
	cmp r7, #1
	bne _021F4164
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0xff
	beq _021F4164
	ldr r0, [r5, #0x34]
	add r2, r0, r1
	ldr r1, _021F4170 ; =0x00004094
	ldrb r1, [r2, r1]
	lsl r1, r1, #2
	str r1, [sp]
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl ManagedSprite_GetDrawPriority
	add r2, r0, #0
	add r1, r6, #0
	ldr r0, [r5, #0x34]
	add r1, #0x3d
	add r2, r2, #1
	bl ov14_021F2A74
	ldr r1, [r5, #0x34]
	ldr r0, [sp]
	add r1, r1, r0
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl ManagedSprite_GetPriority
	add r1, r0, #0
	ldr r0, [r5, #0x34]
	add r2, r0, r4
	mov r0, #0x3f
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	bl ManagedSprite_SetPriority
_021F4164:
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #8
	blo _021F40FC
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F4170: .word 0x00004094
	thumb_func_end ov14_021F40E8

	thumb_func_start ov14_021F4174
ov14_021F4174: ; 0x021F4174
	push {r3, r4, r5, r6, r7, lr}
	add r1, r0, #0
	add r1, #0x21
	ldrb r1, [r1]
	cmp r1, #0xff
	beq _021F41D4
	ldr r4, [r0, #0x34]
	ldr r0, _021F41D8 ; =0x00004094
	add r1, r4, r1
	ldrb r0, [r1, r0]
	add r2, sp, #0
	lsl r0, r0, #2
	add r1, r4, r0
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	bl ManagedSprite_GetPositionXY
	ldr r7, _021F41DC ; =ov14_021F8070
	mov r5, #0
	add r6, sp, #0
_021F41A2:
	lsl r0, r5, #2
	add r1, r4, r0
	mov r0, #0x3f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	ldrsh r2, [r6, r1]
	ldrsb r1, [r7, r5]
	ldr r3, _021F41E0 ; =ov14_021F8078
	add r1, r2, r1
	mov r2, #0
	lsl r1, r1, #0x10
	ldrsh r2, [r6, r2]
	ldrsb r3, [r3, r5]
	asr r1, r1, #0x10
	add r2, r2, r3
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #8
	blo _021F41A2
_021F41D4:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021F41D8: .word 0x00004094
_021F41DC: .word ov14_021F8070
_021F41E0: .word ov14_021F8078
	thumb_func_end ov14_021F4174

	thumb_func_start ov14_021F41E4
ov14_021F41E4: ; 0x021F41E4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	mov r4, #0
	add r5, r0, #0
	add r6, r4, #0
	mov r7, #1
_021F41F0:
	ldr r0, _021F426C ; =0x0000C123
	str r6, [sp]
	str r7, [sp, #4]
	add r0, r4, r0
	str r0, [sp, #8]
	mov r0, #0xbd
	mov r1, #0xbe
	lsl r0, r0, #2
	lsl r1, r1, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x46
	bl SpriteSystem_LoadCharResObj
	add r4, r4, #1
	cmp r4, #6
	blo _021F41F0
	mov r0, #0
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, _021F4270 ; =0x0000C0FF
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x47
	bl SpriteSystem_LoadPlttResObj
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F4274 ; =0x0000C0FD
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x48
	bl SpriteSystem_LoadCellResObj
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F4274 ; =0x0000C0FD
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x49
	bl SpriteSystem_LoadAnimResObj
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F426C: .word 0x0000C123
_021F4270: .word 0x0000C0FF
_021F4274: .word 0x0000C0FD
	thumb_func_end ov14_021F41E4

	thumb_func_start ov14_021F4278
ov14_021F4278: ; 0x021F4278
	push {r4, r5, r6, r7, lr}
	sub sp, #0x6c
	mov r7, #0
	ldr r3, _021F42E4 ; =ov14_021F8140
	str r0, [sp]
	add r4, r7, #0
	add r5, r0, #0
	add r2, sp, #4
	mov r6, #6
_021F428A:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _021F428A
	ldr r0, [r3]
	str r0, [r2]
_021F4296:
	add r6, sp, #4
	add r3, sp, #0x38
	mov r2, #6
_021F429C:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F429C
	ldr r0, [r6]
	add r1, sp, #4
	str r0, [r3]
	mov r0, #0x34
	ldrsh r0, [r1, r0]
	add r1, r0, r4
	add r0, sp, #4
	strh r1, [r0, #0x34]
	ldr r0, _021F42E8 ; =0x0000C123
	ldr r1, [sp]
	add r0, r7, r0
	str r0, [sp, #0x4c]
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r2, r1, #0
	mov r1, #0xbe
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	add r2, sp, #0x38
	bl SpriteSystem_NewSprite
	mov r1, #0xce
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r7, r7, #1
	add r4, #0x22
	add r5, r5, #4
	cmp r7, #6
	blo _021F4296
	add sp, #0x6c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F42E4: .word ov14_021F8140
_021F42E8: .word 0x0000C123
	thumb_func_end ov14_021F4278

	thumb_func_start ov14_021F42EC
ov14_021F42EC: ; 0x021F42EC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	mov r4, #0
	add r5, r0, #0
	add r6, r4, #0
	mov r7, #1
_021F42F8:
	ldr r0, _021F4378 ; =0x0000C129
	str r6, [sp]
	str r7, [sp, #4]
	add r0, r4, r0
	str r0, [sp, #8]
	mov r0, #0xbd
	mov r1, #0xbe
	lsl r0, r0, #2
	lsl r1, r1, #2
	ldr r0, [r5, r0]
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x4a
	bl SpriteSystem_LoadCharResObj
	add r4, r4, #1
	cmp r4, #4
	blo _021F42F8
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0xc1
	mov r1, #0xbd
	lsl r0, r0, #8
	lsl r1, r1, #2
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x4b
	bl SpriteSystem_LoadPlttResObj
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F437C ; =0x0000C0FE
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x4c
	bl SpriteSystem_LoadCellResObj
	mov r0, #1
	str r0, [sp]
	ldr r0, _021F437C ; =0x0000C0FE
	mov r1, #0xbd
	lsl r1, r1, #2
	str r0, [sp, #4]
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	mov r2, #0x13
	mov r3, #0x4d
	bl SpriteSystem_LoadAnimResObj
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F4378: .word 0x0000C129
_021F437C: .word 0x0000C0FE
	thumb_func_end ov14_021F42EC

	thumb_func_start ov14_021F4380
ov14_021F4380: ; 0x021F4380
	push {r4, r5, r6, r7, lr}
	sub sp, #0x6c
	mov r7, #0
	ldr r3, _021F43EC ; =ov14_021F8174
	str r0, [sp]
	add r4, r7, #0
	add r5, r0, #0
	add r2, sp, #4
	mov r6, #6
_021F4392:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _021F4392
	ldr r0, [r3]
	str r0, [r2]
_021F439E:
	add r6, sp, #4
	add r3, sp, #0x38
	mov r2, #6
_021F43A4:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021F43A4
	ldr r0, [r6]
	add r1, sp, #4
	str r0, [r3]
	mov r0, #0x34
	ldrsh r0, [r1, r0]
	add r1, r0, r4
	add r0, sp, #4
	strh r1, [r0, #0x34]
	ldr r0, _021F43F0 ; =0x0000C129
	ldr r1, [sp]
	add r0, r7, r0
	str r0, [sp, #0x4c]
	mov r0, #0xbd
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r2, r1, #0
	mov r1, #0xbe
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	add r2, sp, #0x38
	bl SpriteSystem_NewSprite
	mov r1, #0x35
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r7, r7, #1
	add r4, #0x2e
	add r5, r5, #4
	cmp r7, #4
	blo _021F439E
	add sp, #0x6c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021F43EC: .word ov14_021F8174
_021F43F0: .word 0x0000C129
	thumb_func_end ov14_021F4380

	thumb_func_start ov14_021F43F4
ov14_021F43F4: ; 0x021F43F4
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	mov r1, #0
	add r2, r4, #0
	bl ov14_021F2A18
	add r0, r5, #0
	mov r1, #1
	add r2, r4, #0
	bl ov14_021F2A18
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F43F4

	thumb_func_start ov14_021F4410
ov14_021F4410: ; 0x021F4410
	ldr r1, _021F4420 ; =0x00000414
	ldr r3, _021F4424 ; =sub_020136B4
	ldr r0, [r0, r1]
	mov r1, #0x2f
	mvn r1, r1
	add r2, r1, #0
	add r2, #0x28
	bx r3
	.balign 4, 0
_021F4420: .word 0x00000414
_021F4424: .word sub_020136B4
	thumb_func_end ov14_021F4410

	thumb_func_start ov14_021F4428
ov14_021F4428: ; 0x021F4428
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0xc3
	mov r1, #0xc
	add r2, r1, #0
	ldr r4, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	sub r2, #0x21
	bl ManagedSprite_SetPositionXY
	mov r0, #0x31
	lsl r0, r0, #4
	mov r2, #0x14
	ldr r0, [r4, r0]
	mov r1, #0xf4
	mvn r2, r2
	bl ManagedSprite_SetPositionXY
	mov r0, #0xc5
	lsl r0, r0, #2
	mov r1, #0x2b
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x40
	bl ManagedSprite_SetPositionXY
	mov r0, #0xc6
	lsl r0, r0, #2
	mov r1, #0x80
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0xa8
	bl ManagedSprite_SetPositionXY
	mov r0, #0xc7
	lsl r0, r0, #2
	mov r1, #0x80
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x9c
	bl ManagedSprite_SetPositionXY
	add r0, r5, #0
	bl ov14_021F462C
	mov r1, #7
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F29E4
	add r0, r4, #0
	bl ov14_021F4410
	ldr r0, _021F44AC ; =0x00000414
	mov r1, #1
	ldr r0, [r4, r0]
	bl TextOBJ_SetSpritesDrawFlag
	ldr r0, _021F44B0 ; =0x00000424
	mov r1, #0
	ldr r0, [r4, r0]
	bl TextOBJ_SetSpritesDrawFlag
	pop {r3, r4, r5, pc}
	nop
_021F44AC: .word 0x00000414
_021F44B0: .word 0x00000424
	thumb_func_end ov14_021F4428

	thumb_func_start ov14_021F44B4
ov14_021F44B4: ; 0x021F44B4
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r4, r5, #0
	add r6, r1, #0
	mov r7, #4
	add r4, #0x10
_021F44C0:
	mov r0, #0xbf
	lsl r0, r0, #2
	add r1, sp, #0
	ldr r0, [r4, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	add r2, sp, #0
	mov r1, #2
	mov r0, #0xbf
	lsl r0, r0, #2
	ldrsh r1, [r2, r1]
	add r3, r2, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r0, [r4, r0]
	add r2, r2, r6
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r7, r7, #1
	add r4, r4, #4
	cmp r7, #8
	bls _021F44C0
	add r0, r5, #0
	bl ov14_021F4410
	mov r4, #0
	add r7, sp, #0
_021F44FE:
	mov r0, #0x35
	lsl r0, r0, #4
	add r1, sp, #0
	ldr r0, [r5, r0]
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r2, #0
	ldrsh r2, [r7, r2]
	mov r0, #0x35
	mov r1, #2
	lsl r0, r0, #4
	add r2, r2, r6
	lsl r2, r2, #0x10
	ldrsh r1, [r7, r1]
	ldr r0, [r5, r0]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blo _021F44FE
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021F44B4

	thumb_func_start ov14_021F4530
ov14_021F4530: ; 0x021F4530
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x25
	ldrb r1, [r1]
	bl ov14_021E7930
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r1, _021F4598 ; =0x0000044D
	ldrb r1, [r0, r1]
	lsr r2, r1, #2
	lsr r1, r4, #2
	cmp r2, r1
	bne _021F4558
	mov r1, #6
	mov r2, #1
	bl ov14_021F2A18
	b _021F4560
_021F4558:
	mov r1, #6
	mov r2, #0
	bl ov14_021F2A18
_021F4560:
	mov r0, #0xc5
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc5
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #3
	add r2, r4, #0
	and r2, r1
	mov r1, #0x2e
	mul r1, r2
	add r1, #0x3b
	lsl r1, r1, #0x10
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, pc}
	nop
_021F4598: .word 0x0000044D
	thumb_func_end ov14_021F4530

	thumb_func_start ov14_021F459C
ov14_021F459C: ; 0x021F459C
	push {r4, lr}
	sub sp, #8
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r1, _021F4628 ; =0x0000044D
	ldrb r1, [r0, r1]
	lsr r3, r1, #0x1f
	lsl r2, r1, #0x1e
	sub r2, r2, r3
	mov r1, #0x1e
	ror r2, r1
	add r1, r3, r2
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	add r1, #0x15
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r2, sp, #0
	add r1, sp, #0
	add r2, #2
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc6
	add r2, sp, #0
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r2, #2
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc6
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r3, sp, #0
	mov r1, #0
	mov r2, #2
	ldrsh r1, [r3, r1]
	ldrsh r2, [r3, r2]
	bl ManagedSprite_SetPositionXY
	mov r0, #0xc7
	add r2, sp, #0
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r2, #2
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc7
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r3, sp, #0
	mov r1, #0
	mov r2, #2
	ldrsh r1, [r3, r1]
	ldrsh r2, [r3, r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r4, #0x34]
	bl ov14_021F4410
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
_021F4628: .word 0x0000044D
	thumb_func_end ov14_021F459C

	thumb_func_start ov14_021F462C
ov14_021F462C: ; 0x021F462C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r7, r0, #0
	ldr r1, [r7, #0x34]
	ldr r0, _021F46AC ; =0x0000044D
	mov r6, #0x15
	ldrb r0, [r1, r0]
	mov r1, #9
	lsl r1, r1, #6
	lsr r0, r0, #2
	lsl r5, r0, #2
	mov r0, #0xa
	bl Heap_AllocAtEnd
	add r4, r0, #0
	mov r0, #0x13
	mov r1, #0x4a
	mov r2, #0xa
	bl AllocAtEndAndReadWholeNarcMemberByIdPair
	add r1, sp, #0xc
	str r0, [sp, #8]
	bl NNS_G2dGetUnpackedCharacterData
	mov r0, #0
	str r0, [sp, #4]
_021F4660:
	ldr r0, [sp, #0xc]
	mov r2, #9
	ldr r0, [r0, #0x14]
	add r1, r4, #0
	lsl r2, r2, #6
	bl MI_CpuCopy8
	mov r0, #9
	lsl r0, r0, #6
	str r0, [sp]
	add r0, r7, #0
	add r1, r4, #0
	add r2, r5, #0
	mov r3, #0x1e
	bl ov14_021F46B0
	mov r3, #9
	ldr r0, [r7, #0x34]
	add r1, r6, #0
	add r2, r4, #0
	lsl r3, r3, #6
	bl ov14_021F2C1C
	ldr r0, [sp, #4]
	add r6, r6, #1
	add r0, r0, #1
	add r5, r5, #1
	str r0, [sp, #4]
	cmp r0, #4
	blo _021F4660
	ldr r0, [sp, #8]
	bl Heap_Free
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F46AC: .word 0x0000044D
	thumb_func_end ov14_021F462C

	thumb_func_start ov14_021F46B0
ov14_021F46B0: ; 0x021F46B0
	push {r3, r4, r5, r6, r7, lr}
	add r7, r2, #0
	add r5, r1, #0
	add r6, r3, #0
	ldr r4, [sp, #0x18]
	cmp r7, #0x10
	blo _021F46D8
	add r1, r7, #0
	ldr r0, [r0, #4]
	sub r1, #0x10
	bl PCStorage_IsBonusWallpaperUnlocked
	cmp r0, #0
	bne _021F46D0
	mov r2, #0x28
	b _021F46DE
_021F46D0:
	add r7, #0x10
	lsl r0, r7, #0x18
	lsr r2, r0, #0x18
	b _021F46DE
_021F46D8:
	add r7, #0x10
	lsl r0, r7, #0x18
	lsr r2, r0, #0x18
_021F46DE:
	mov r1, #0
	cmp r4, #0
	bls _021F46F2
_021F46E4:
	ldrb r0, [r5, r1]
	cmp r6, r0
	bne _021F46EC
	strb r2, [r5, r1]
_021F46EC:
	add r1, r1, #1
	cmp r1, r4
	blo _021F46E4
_021F46F2:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021F46B0

	thumb_func_start ov14_021F46F4
ov14_021F46F4: ; 0x021F46F4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F4718 ; =0x00000414
	mov r1, #0x47
	mvn r1, r1
	add r2, r1, #0
	ldr r0, [r4, r0]
	add r2, #0x40
	bl sub_020136B4
	ldr r0, _021F471C ; =0x00000424
	mov r1, #0x20
	add r2, r1, #0
	ldr r0, [r4, r0]
	sub r2, #0x28
	bl sub_020136B4
	pop {r4, pc}
	.balign 4, 0
_021F4718: .word 0x00000414
_021F471C: .word 0x00000424
	thumb_func_end ov14_021F46F4

	thumb_func_start ov14_021F4720
ov14_021F4720: ; 0x021F4720
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xc3
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0xc
	add r2, r1, #0
	sub r2, #0x21
	bl ManagedSprite_SetPositionXY
	mov r0, #0x31
	mov r2, #0x14
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xf4
	mvn r2, r2
	bl ManagedSprite_SetPositionXY
	mov r0, #0xc5
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0x2b
	add r2, r1, #0
	sub r2, #0x40
	bl ManagedSprite_SetPositionXY
	mov r0, #0xc6
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0x80
	add r2, r1, #0
	sub r2, #0xa8
	bl ManagedSprite_SetPositionXY
	mov r0, #0xc7
	ldr r1, [r4, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0x80
	add r2, r1, #0
	sub r2, #0x9c
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	bl ov14_021F49E0
	ldr r0, [r4, #0x34]
	mov r1, #7
	mov r2, #5
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	bl ov14_021F46F4
	ldr r1, [r4, #0x34]
	ldr r0, _021F47B0 ; =0x00000414
	ldr r0, [r1, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	ldr r1, [r4, #0x34]
	ldr r0, _021F47B4 ; =0x00000424
	ldr r0, [r1, r0]
	mov r1, #1
	bl TextOBJ_SetSpritesDrawFlag
	pop {r4, pc}
	nop
_021F47B0: .word 0x00000414
_021F47B4: .word 0x00000424
	thumb_func_end ov14_021F4720

	thumb_func_start ov14_021F47B8
ov14_021F47B8: ; 0x021F47B8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r7, r1, #0
	mov r6, #4
	mov r4, #0x10
_021F47C2:
	ldr r0, [r5, #0x34]
	add r2, sp, #0
	add r1, r0, r4
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	bl ManagedSprite_GetPositionXY
	ldr r0, [r5, #0x34]
	add r2, sp, #0
	add r1, r0, r4
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	ldrsh r1, [r2, r1]
	add r3, r2, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	add r2, r2, r7
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #8
	bls _021F47C2
	ldr r0, [r5, #0x34]
	bl ov14_021F46F4
	mov r6, #0
	add r4, r6, #0
_021F4808:
	ldr r0, [r5, #0x34]
	add r2, sp, #0
	add r1, r0, r4
	mov r0, #0xce
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	bl ManagedSprite_GetPositionXY
	ldr r0, [r5, #0x34]
	add r2, sp, #0
	add r1, r0, r4
	mov r0, #0xce
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	ldrsh r1, [r2, r1]
	add r3, r2, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	add r2, r2, r7
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #6
	blo _021F4808
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021F47B8

	thumb_func_start ov14_021F4848
ov14_021F4848: ; 0x021F4848
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r4, r0, #0
	ldrb r0, [r5, #0x1f]
	mov r1, #6
	bl _s32_div_f
	cmp r4, r0
	ldr r0, [r5, #0x34]
	bne _021F4870
	mov r1, #6
	mov r2, #1
	bl ov14_021F2A18
	b _021F4878
_021F4870:
	mov r1, #6
	mov r2, #0
	bl ov14_021F2A18
_021F4878:
	ldrb r0, [r5, #0x1f]
	mov r1, #6
	bl _s32_div_f
	add r4, r1, #0
	mov r0, #0xc5
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc5
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0x22
	mul r1, r4
	add r1, #0x2b
	lsl r1, r1, #0x10
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	asr r1, r1, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F4848

	thumb_func_start ov14_021F48B4
ov14_021F48B4: ; 0x021F48B4
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	lsl r0, r1, #0x10
	lsr r4, r0, #0x10
	mov r0, #0xc6
	add r2, sp, #0
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r2, #2
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc6
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	ldr r1, _021F493C ; =ov14_021F8068
	add r3, sp, #0
	mov r2, #2
	ldrb r1, [r1, r4]
	ldrsh r2, [r3, r2]
	bl ManagedSprite_SetPositionXY
	add r4, #0xf
	add r2, sp, #0
	ldr r1, [r5, #0x34]
	lsl r0, r4, #2
	add r1, r1, r0
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r2, #2
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc7
	add r2, sp, #0
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r2, #2
	bl ManagedSprite_GetPositionXY
	mov r0, #0xc7
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r3, sp, #0
	mov r1, #0
	mov r2, #2
	ldrsh r1, [r3, r1]
	ldrsh r2, [r3, r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	bl ov14_021F46F4
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_021F493C: .word ov14_021F8068
	thumb_func_end ov14_021F48B4

	thumb_func_start ov14_021F4940
ov14_021F4940: ; 0x021F4940
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xce
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, r2, #0
	add r2, r3, #0
	ldr r3, _021F4954 ; =ManagedSprite_GetPositionXY
	bx r3
	nop
_021F4954: .word ManagedSprite_GetPositionXY
	thumb_func_end ov14_021F4940
