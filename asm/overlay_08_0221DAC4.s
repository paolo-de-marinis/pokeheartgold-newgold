#include "constants/moves.h"
	.include "asm/macros.inc"
	.include "overlay_08.inc"
	.include "global.inc"

	.text

	thumb_func_start ov08_0221DAC4
ov08_0221DAC4: ; 0x0221DAC4
	ldr r1, [r0]
	ldrb r2, [r1, #0x11]
	mov r1, #0x50
	mul r1, r2
	add r0, r0, r1
	ldrb r0, [r0, #0x1b]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	beq _0221DADA
	mov r0, #1
	b _0221DADC
_0221DADA:
	mov r0, #0
_0221DADC:
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bx lr
	.balign 4, 0
	thumb_func_end ov08_0221DAC4

	thumb_func_start ov08_0221DAE4
ov08_0221DAE4: ; 0x0221DAE4
	push {r3, lr}
	ldr r0, [r0]
	ldr r0, [r0, #8]
	bl BattleSystem_GetBattleType
	cmp r0, #0x4a
	beq _0221DB00
	cmp r0, #0x4b
	beq _0221DB00
	mov r1, #0x12
	tst r0, r1
	beq _0221DB00
	mov r0, #1
	pop {r3, pc}
_0221DB00:
	mov r0, #0
	pop {r3, pc}
	thumb_func_end ov08_0221DAE4

	thumb_func_start ov08_0221DB04
ov08_0221DB04: ; 0x0221DB04
	push {r3, lr}
	ldr r0, [r0]
	ldr r0, [r0, #8]
	bl BattleSystem_GetBattleType
	cmp r0, #0x4a
	beq _0221DB20
	cmp r0, #0x4b
	beq _0221DB20
	mov r1, #8
	tst r0, r1
	beq _0221DB20
	mov r0, #1
	pop {r3, pc}
_0221DB20:
	mov r0, #0
	pop {r3, pc}
	thumb_func_end ov08_0221DB04

	thumb_func_start ov08_0221DB24
ov08_0221DB24: ; 0x0221DB24
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ov08_0221DB04
	cmp r0, #1
	bne _0221DB4C
	ldr r0, _0221DB50 ; =0x0000208F
	ldrb r0, [r5, r0]
	cmp r0, #2
	bne _0221DB44
	mov r0, #1
	add r1, r4, #0
	tst r1, r0
	beq _0221DB4C
	pop {r3, r4, r5, pc}
_0221DB44:
	mov r0, #1
	add r1, r4, #0
	tst r1, r0
	beq _0221DB4E
_0221DB4C:
	mov r0, #0
_0221DB4E:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221DB50: .word 0x0000208F
	thumb_func_end ov08_0221DB24

	thumb_func_start ov08_0221DB54
ov08_0221DB54: ; 0x0221DB54
	ldr r2, [r0]
	add r1, r2, #0
	add r1, #0x34
	ldrb r3, [r1]
	cmp r3, #4
	bne _0221DB64
	ldrh r0, [r2, #0x24]
	b _0221DB72
_0221DB64:
	ldrb r2, [r2, #0x11]
	mov r1, #0x50
	mul r1, r2
	add r1, r0, r1
	lsl r0, r3, #3
	add r0, r1, r0
	ldrh r0, [r0, #0x34]
_0221DB72:
	ldr r3, _0221DB78 ; =MoveIsHM
	bx r3
	nop
_0221DB78: .word MoveIsHM
	thumb_func_end ov08_0221DB54

	thumb_func_start ov08_0221DB7C
ov08_0221DB7C: ; 0x0221DB7C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0221DBAC ; =0x00002020
	mov r1, #0
	ldr r0, [r4, r0]
	bl ManagedSprite_SetDrawFlag
	ldr r0, _0221DBB0 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, #0xa0
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _0221DBB0 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, #0x60
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _0221DBB0 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, #0x70
	bl ClearWindowTilemapAndScheduleTransfer
	pop {r4, pc}
	nop
_0221DBAC: .word 0x00002020
_0221DBB0: .word 0x00002070
	thumb_func_end ov08_0221DB7C

	thumb_func_start ov08_0221DBB4
ov08_0221DBB4: ; 0x0221DBB4
	push {r4, lr}
	add r4, r0, #0
	bl ov08_0221D81C
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #7
	bl ScheduleBgTilemapBufferTransfer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov08_0221DBB4

	thumb_func_start ov08_0221DBCC
ov08_0221DBCC: ; 0x0221DBCC
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r6, r2, #0
	add r7, r3, #0
	cmp r4, #0x41
	beq _0221DBF0
	cmp r4, #0x43
	beq _0221DBF0
	cmp r4, #0x42
	beq _0221DBF0
	bl BattleSystem_GetBag
	add r1, r4, #0
	mov r2, #1
	add r3, r7, #0
	bl Bag_TakeItem
_0221DBF0:
	add r0, r5, #0
	bl BattleSystem_GetBagCursor
	add r1, r4, #0
	add r2, r6, #0
	bl BagCursor_Battle_SetLastUsedItem
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov08_0221DBCC

	thumb_func_start ov08_0221DC00
ov08_0221DC00: ; 0x0221DC00
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	ldr r0, _0221DC30 ; =0x00002050
	ldr r4, _0221DC34 ; =ov08_02224FD0
	mov r6, #0
	add r5, r7, r0
_0221DC0C:
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	add r1, r5, #0
	add r2, r4, #0
	bl AddWindow
	add r6, r6, #1
	add r4, #8
	add r5, #0x10
	cmp r6, #2
	blo _0221DC0C
	ldr r1, _0221DC38 ; =0x0000207A
	add r0, r7, #0
	ldrb r1, [r7, r1]
	bl ov08_0221DC3C
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221DC30: .word 0x00002050
_0221DC34: .word ov08_02224FD0
_0221DC38: .word 0x0000207A
	thumb_func_end ov08_0221DC00

	thumb_func_start ov08_0221DC3C
ov08_0221DC3C: ; 0x0221DC3C
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	cmp r1, #9
	bhi _0221DCBC
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221DC50: ; jump table
	.short _0221DC64 - _0221DC50 - 2 ; case 0
	.short _0221DC6E - _0221DC50 - 2 ; case 1
	.short _0221DC78 - _0221DC50 - 2 ; case 2
	.short _0221DC82 - _0221DC50 - 2 ; case 3
	.short _0221DC8C - _0221DC50 - 2 ; case 4
	.short _0221DC96 - _0221DC50 - 2 ; case 5
	.short _0221DCA0 - _0221DC50 - 2 ; case 6
	.short _0221DCAA - _0221DC50 - 2 ; case 7
	.short _0221DCA0 - _0221DC50 - 2 ; case 8
	.short _0221DCB4 - _0221DC50 - 2 ; case 9
_0221DC64:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #6
	ldr r6, _0221DD00 ; =ov08_02225084
	strb r1, [r4, r0]
	b _0221DCBC
_0221DC6E:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #4
	ldr r6, _0221DD04 ; =ov08_0222500C
	strb r1, [r4, r0]
	b _0221DCBC
_0221DC78:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #0x23
	ldr r6, _0221DD08 ; =ov08_0222522C
	strb r1, [r4, r0]
	b _0221DCBC
_0221DC82:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #0xb
	ldr r6, _0221DD0C ; =ov08_022250EC
	strb r1, [r4, r0]
	b _0221DCBC
_0221DC8C:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #0x11
	ldr r6, _0221DD10 ; =ov08_022251A4
	strb r1, [r4, r0]
	b _0221DCBC
_0221DC96:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #5
	ldr r6, _0221DD14 ; =ov08_0222502C
	strb r1, [r4, r0]
	b _0221DCBC
_0221DCA0:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #6
	ldr r6, _0221DD18 ; =ov08_02225054
	strb r1, [r4, r0]
	b _0221DCBC
_0221DCAA:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #0xc
	ldr r6, _0221DD1C ; =ov08_02225144
	strb r1, [r4, r0]
	b _0221DCBC
_0221DCB4:
	ldr r0, _0221DCFC ; =0x00002074
	mov r1, #7
	ldr r6, _0221DD20 ; =ov08_022250B4
	strb r1, [r4, r0]
_0221DCBC:
	ldr r1, _0221DCFC ; =0x00002074
	ldr r0, [r4]
	ldrb r1, [r4, r1]
	ldr r0, [r0, #0xc]
	bl AllocWindows
	ldr r1, _0221DD24 ; =0x00002070
	mov r5, #0
	str r0, [r4, r1]
	add r0, r1, #4
	ldrb r0, [r4, r0]
	cmp r0, #0
	bls _0221DCFA
	add r7, r1, #4
_0221DCD8:
	ldr r1, _0221DD24 ; =0x00002070
	mov r0, #0x79
	ldr r2, [r4, r1]
	lsl r0, r0, #2
	lsl r1, r5, #4
	add r1, r2, r1
	lsl r2, r5, #3
	ldr r0, [r4, r0]
	add r2, r6, r2
	bl AddWindow
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldrb r0, [r4, r7]
	cmp r5, r0
	blo _0221DCD8
_0221DCFA:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221DCFC: .word 0x00002074
_0221DD00: .word ov08_02225084
_0221DD04: .word ov08_0222500C
_0221DD08: .word ov08_0222522C
_0221DD0C: .word ov08_022250EC
_0221DD10: .word ov08_022251A4
_0221DD14: .word ov08_0222502C
_0221DD18: .word ov08_02225054
_0221DD1C: .word ov08_02225144
_0221DD20: .word ov08_022250B4
_0221DD24: .word 0x00002070
	thumb_func_end ov08_0221DC3C

	thumb_func_start ov08_0221DD28
ov08_0221DD28: ; 0x0221DD28
	ldr r1, _0221DD38 ; =0x00002070
	add r2, r0, #0
	ldr r0, [r2, r1]
	add r1, r1, #4
	ldr r3, _0221DD3C ; =WindowArray_Delete
	ldrb r1, [r2, r1]
	bx r3
	nop
_0221DD38: .word 0x00002070
_0221DD3C: .word WindowArray_Delete
	thumb_func_end ov08_0221DD28

	thumb_func_start ov08_0221DD40
ov08_0221DD40: ; 0x0221DD40
	push {r3, r4, r5, lr}
	ldr r1, _0221DD68 ; =0x00002070
	add r5, r0, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldrb r1, [r5, r1]
	bl WindowArray_Delete
	ldr r0, _0221DD6C ; =0x00002050
	mov r4, #0
	add r5, r5, r0
_0221DD56:
	add r0, r5, #0
	bl RemoveWindow
	add r4, r4, #1
	add r5, #0x10
	cmp r4, #2
	blo _0221DD56
	pop {r3, r4, r5, pc}
	nop
_0221DD68: .word 0x00002070
_0221DD6C: .word 0x00002050
	thumb_func_end ov08_0221DD40

	thumb_func_start ov08_0221DD70
ov08_0221DD70: ; 0x0221DD70
	push {r3, lr}
	cmp r1, #9
	bhi _0221DDCA
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221DD82: ; jump table
	.short _0221DD96 - _0221DD82 - 2 ; case 0
	.short _0221DD9C - _0221DD82 - 2 ; case 1
	.short _0221DDA2 - _0221DD82 - 2 ; case 2
	.short _0221DDA8 - _0221DD82 - 2 ; case 3
	.short _0221DDAE - _0221DD82 - 2 ; case 4
	.short _0221DDB4 - _0221DD82 - 2 ; case 5
	.short _0221DDBA - _0221DD82 - 2 ; case 6
	.short _0221DDC0 - _0221DD82 - 2 ; case 7
	.short _0221DDBA - _0221DD82 - 2 ; case 8
	.short _0221DDC6 - _0221DD82 - 2 ; case 9
_0221DD96:
	bl ov08_0221F4A4
	pop {r3, pc}
_0221DD9C:
	bl ov08_0221F5D0
	pop {r3, pc}
_0221DDA2:
	bl ov08_0221F900
	pop {r3, pc}
_0221DDA8:
	bl ov08_0221F7C0
	pop {r3, pc}
_0221DDAE:
	bl ov08_0221FB18
	pop {r3, pc}
_0221DDB4:
	bl ov08_0221FF70
	pop {r3, pc}
_0221DDBA:
	bl ov08_0221FC7C
	pop {r3, pc}
_0221DDC0:
	bl ov08_0221FDA4
	pop {r3, pc}
_0221DDC6:
	bl ov08_02220084
_0221DDCA:
	pop {r3, pc}
	thumb_func_end ov08_0221DD70

	thumb_func_start ov08_0221DDCC
ov08_0221DDCC: ; 0x0221DDCC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	add r6, r0, #0
	ldr r0, _0221DF5C ; =0x00002070
	str r3, [sp, #0x14]
	ldr r5, [r6, r0]
	lsl r4, r1, #4
	ldr r0, [sp, #0x14]
	mov r1, #0x50
	mul r1, r0
	add r7, r6, #4
	add r0, r7, r1
	str r1, [sp, #0x24]
	ldr r1, [r6]
	str r0, [sp, #0x20]
	ldr r1, [r1, #0xc]
	mov r0, #0xc
	str r2, [sp, #0x10]
	bl String_New
	ldr r1, [sp, #0x14]
	str r0, [sp, #0x1c]
	ldr r0, _0221DF60 ; =0x00001FA8
	lsl r2, r1, #2
	ldr r1, _0221DF64 ; =ov08_02224FF4
	ldr r0, [r6, r0]
	ldr r1, [r1, r2]
	bl NewString_ReadMsgData
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x24]
	ldr r0, [r7, r0]
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _0221DF68 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r6, r0]
	bl BufferBoxMonNickname
	ldr r0, _0221DF68 ; =0x00001FAC
	ldr r1, [sp, #0x1c]
	ldr r0, [r6, r0]
	ldr r2, [sp, #0x18]
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x10]
	add r3, sp, #0x38
	cmp r0, #0
	bne _0221DE4E
	ldrb r7, [r3, #0x14]
	mov r0, #0xff
	ldr r1, [sp, #0x10]
	str r7, [sp]
	str r0, [sp, #4]
	ldr r0, _0221DF6C ; =0x000F0E00
	ldr r2, [sp, #0x1c]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldrb r3, [r3, #0x10]
	add r0, r5, r4
	bl AddTextPrinterParameterizedWithColor
	b _0221DE6A
_0221DE4E:
	ldrb r7, [r3, #0x14]
	mov r0, #0xff
	ldr r1, [sp, #0x10]
	str r7, [sp]
	str r0, [sp, #4]
	ldr r0, _0221DF70 ; =0x00070809
	ldr r2, [sp, #0x1c]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldrb r3, [r3, #0x10]
	add r0, r5, r4
	bl AddTextPrinterParameterizedWithColor
_0221DE6A:
	ldr r0, [sp, #0x18]
	bl String_Delete
	ldr r0, [sp, #0x1c]
	bl String_Delete
	ldr r0, [sp, #0x20]
	ldrb r0, [r0, #0x16]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _0221DF50
	ldr r0, [sp, #0x20]
	ldrb r0, [r0, #0x17]
	lsl r1, r0, #0x18
	lsr r1, r1, #0x1f
	bne _0221DF50
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	bne _0221DEEE
	ldr r0, _0221DF60 ; =0x00001FA8
	mov r1, #0x10
	ldr r0, [r6, r0]
	bl NewString_ReadMsgData
	add r6, r0, #0
	add r0, r5, r4
	bl GetWindowWidth
	str r0, [sp, #0x28]
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	ldr r1, [sp, #0x28]
	str r7, [sp]
	lsl r1, r1, #3
	sub r3, r1, r0
	ldr r0, [sp, #0x10]
	cmp r0, #0
	bne _0221DED2
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221DF74 ; =0x00070800
	mov r1, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r2, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	b _0221DEE6
_0221DED2:
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221DF78 ; =0x000A0B00
	mov r1, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r2, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0221DEE6:
	add r0, r6, #0
	bl String_Delete
	b _0221DF50
_0221DEEE:
	cmp r0, #1
	bne _0221DF50
	ldr r0, _0221DF60 ; =0x00001FA8
	mov r1, #0x11
	ldr r0, [r6, r0]
	bl NewString_ReadMsgData
	add r6, r0, #0
	add r0, r5, r4
	bl GetWindowWidth
	str r0, [sp, #0x2c]
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	ldr r1, [sp, #0x2c]
	str r7, [sp]
	lsl r1, r1, #3
	sub r3, r1, r0
	ldr r0, [sp, #0x10]
	cmp r0, #0
	bne _0221DF36
	mov r0, #0xff
	str r0, [sp, #4]
	mov r0, #0xc1
	lsl r0, r0, #0xa
	str r0, [sp, #8]
	mov r1, #0
	add r0, r5, r4
	add r2, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	b _0221DF4A
_0221DF36:
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221DF7C ; =0x000C0D00
	mov r1, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r2, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0221DF4A:
	add r0, r6, #0
	bl String_Delete
_0221DF50:
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DF5C: .word 0x00002070
_0221DF60: .word 0x00001FA8
_0221DF64: .word ov08_02224FF4
_0221DF68: .word 0x00001FAC
_0221DF6C: .word 0x000F0E00
_0221DF70: .word 0x00070809
_0221DF74: .word 0x00070800
_0221DF78: .word 0x000A0B00
_0221DF7C: .word 0x000C0D00
	thumb_func_end ov08_0221DDCC

	thumb_func_start ov08_0221DF80
ov08_0221DF80: ; 0x0221DF80
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _0221DFC4 ; =0x00002070
	lsl r4, r1, #4
	ldr r1, [r5, r0]
	add r3, #8
	add r1, r1, r4
	str r1, [sp, #4]
	str r3, [sp, #8]
	add r1, sp, #0x10
	ldrb r1, [r1, #0x10]
	mov r3, #0x50
	mul r3, r2
	str r1, [sp, #0xc]
	add r2, r5, r3
	ldrb r2, [r2, #0x1a]
	sub r0, #0xcc
	ldr r0, [r5, r0]
	lsl r2, r2, #0x19
	mov r1, #1
	lsr r2, r2, #0x19
	mov r3, #3
	bl sub_0200CE7C
	ldr r0, _0221DFC4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221DFC4: .word 0x00002070
	thumb_func_end ov08_0221DF80

	thumb_func_start ov08_0221DFC8
ov08_0221DFC8: ; 0x0221DFC8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x50
	add r7, r3, #0
	mul r0, r2
	add r3, r5, #4
	add r0, r3, r0
	str r0, [sp, #0xc]
	add r0, sp, #0x18
	ldrb r6, [r0, #0x10]
	ldr r0, _0221E040 ; =0x00002070
	lsl r4, r1, #4
	ldr r1, [r5, r0]
	sub r0, #0xcc
	add r1, r1, r4
	str r1, [sp]
	str r7, [sp, #4]
	str r6, [sp, #8]
	ldr r1, [sp, #0xc]
	ldr r0, [r5, r0]
	ldrh r1, [r1, #0x10]
	mov r2, #3
	mov r3, #1
	bl PrintUIntOnWindow
	add r3, r7, #0
	ldr r2, _0221E044 ; =0x00001FA4
	str r6, [sp]
	ldr r0, [r5, r2]
	add r2, #0xcc
	ldr r2, [r5, r2]
	mov r1, #0
	add r2, r2, r4
	add r3, #0x18
	bl sub_0200CDAC
	ldr r0, _0221E040 ; =0x00002070
	add r7, #0x20
	ldr r1, [r5, r0]
	sub r0, #0xcc
	add r1, r1, r4
	str r1, [sp]
	str r7, [sp, #4]
	str r6, [sp, #8]
	ldr r1, [sp, #0xc]
	ldr r0, [r5, r0]
	ldrh r1, [r1, #0x12]
	mov r2, #3
	mov r3, #0
	bl PrintUIntOnWindow
	ldr r0, _0221E040 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221E040: .word 0x00002070
_0221E044: .word 0x00001FA4
	thumb_func_end ov08_0221DFC8

	thumb_func_start ov08_0221E048
ov08_0221E048: ; 0x0221E048
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #0x50
	str r1, [sp, #8]
	mul r0, r2
	add r1, r4, #4
	str r3, [sp, #0xc]
	add r5, r1, r0
	ldrh r0, [r5, #0x10]
	ldrh r1, [r5, #0x12]
	mov r2, #0x30
	mov r7, #1
	bl CalculateHpBarPixelsLength
	str r0, [sp, #0x14]
	ldrh r0, [r5, #0x10]
	ldrh r1, [r5, #0x12]
	mov r2, #0x30
	bl CalculateHpBarColor
	cmp r0, #4
	bhi _0221E0A6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221E082: ; jump table
	.short _0221E08C - _0221E082 - 2 ; case 0
	.short _0221E0A4 - _0221E082 - 2 ; case 1
	.short _0221E0A0 - _0221E082 - 2 ; case 2
	.short _0221E09E - _0221E082 - 2 ; case 3
	.short _0221E09E - _0221E082 - 2 ; case 4
_0221E08C:
	ldr r0, _0221E11C ; =0x00002070
	ldr r1, [r4, r0]
	ldr r0, [sp, #8]
	lsl r0, r0, #4
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
_0221E09E:
	b _0221E0A6
_0221E0A0:
	mov r7, #3
	b _0221E0A6
_0221E0A4:
	mov r7, #5
_0221E0A6:
	add r0, sp, #0x20
	ldrb r6, [r0, #0x10]
	add r0, r7, #1
	str r0, [sp, #0x10]
	ldr r0, [sp, #8]
	ldr r1, [sp, #0x10]
	lsl r5, r0, #4
	ldr r0, [sp, #0x14]
	add r3, r6, #1
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221E11C ; =0x00002070
	lsl r1, r1, #0x18
	ldr r0, [r4, r0]
	lsl r3, r3, #0x10
	ldr r2, [sp, #0xc]
	add r0, r0, r5
	lsr r1, r1, #0x18
	lsr r3, r3, #0x10
	bl FillWindowPixelRect
	ldr r0, [sp, #0x14]
	add r3, r6, #2
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _0221E11C ; =0x00002070
	lsl r3, r3, #0x10
	ldr r0, [r4, r0]
	ldr r2, [sp, #0xc]
	add r0, r0, r5
	add r1, r7, #0
	lsr r3, r3, #0x10
	bl FillWindowPixelRect
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x10]
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221E11C ; =0x00002070
	add r3, r6, #4
	ldr r0, [r4, r0]
	lsl r1, r1, #0x18
	lsl r3, r3, #0x10
	ldr r2, [sp, #0xc]
	add r0, r0, r5
	lsr r1, r1, #0x18
	lsr r3, r3, #0x10
	bl FillWindowPixelRect
	ldr r0, _0221E11C ; =0x00002070
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E11C: .word 0x00002070
	thumb_func_end ov08_0221E048

	thumb_func_start ov08_0221E120
ov08_0221E120: ; 0x0221E120
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	add r4, r1, #0
	ldr r1, [r5]
	mov r0, #0x10
	ldr r1, [r1, #0xc]
	add r7, r2, #0
	bl String_New
	add r6, r0, #0
	ldr r0, _0221E198 ; =0x00001FA8
	mov r1, #8
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	mov r2, #0x50
	mul r2, r7
	str r0, [sp, #0x10]
	ldr r0, _0221E19C ; =0x00001FAC
	add r2, r5, r2
	ldrh r2, [r2, #0x1c]
	ldr r0, [r5, r0]
	mov r1, #0
	bl BufferAbilityName
	ldr r0, _0221E19C ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	add r1, r6, #0
	bl StringExpandPlaceholders
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E1A0 ; =0x000F0E00
	lsl r4, r4, #4
	str r0, [sp, #8]
	ldr r0, _0221E1A4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r2, r6, #0
	add r0, r0, r4
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E1A4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E198: .word 0x00001FA8
_0221E19C: .word 0x00001FAC
_0221E1A0: .word 0x000F0E00
_0221E1A4: .word 0x00002070
	thumb_func_end ov08_0221E120

	thumb_func_start ov08_0221E1A8
ov08_0221E1A8: ; 0x0221E1A8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r4, r0, #0
	mov r0, #0x50
	add r7, r1, #0
	add r1, r4, #4
	mul r0, r2
	add r5, r1, r0
	ldrh r0, [r5, #0x1a]
	cmp r0, #0
	bne _0221E1CC
	ldr r0, _0221E234 ; =0x00001FA8
	mov r1, #0x14
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	add r6, r0, #0
	b _0221E202
_0221E1CC:
	ldr r1, [r4]
	mov r0, #0x12
	ldr r1, [r1, #0xc]
	bl String_New
	add r6, r0, #0
	ldr r0, _0221E234 ; =0x00001FA8
	mov r1, #9
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	ldr r0, _0221E238 ; =0x00001FAC
	ldrh r2, [r5, #0x1a]
	ldr r0, [r4, r0]
	mov r1, #0
	bl BufferItemName
	ldr r0, _0221E238 ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r4, r0]
	add r1, r6, #0
	bl StringExpandPlaceholders
	ldr r0, [sp, #0x10]
	bl String_Delete
_0221E202:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E23C ; =0x000F0E00
	lsl r5, r7, #4
	str r0, [sp, #8]
	ldr r0, _0221E240 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r4, r0]
	add r2, r6, #0
	add r0, r0, r5
	add r3, r1, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E240 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E234: .word 0x00001FA8
_0221E238: .word 0x00001FAC
_0221E23C: .word 0x000F0E00
_0221E240: .word 0x00002070
	thumb_func_end ov08_0221E1A8

	thumb_func_start ov08_0221E244
ov08_0221E244: ; 0x0221E244
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	str r1, [sp, #0x10]
	ldr r1, [r5]
	ldr r0, _0221E2DC ; =0x00002070
	ldr r1, [r1, #0xc]
	ldr r4, [r5, r0]
	mov r0, #0x10
	str r3, [sp, #0x14]
	lsl r6, r2, #4
	bl String_New
	add r7, r0, #0
	ldr r0, _0221E2E0 ; =0x00001FA8
	ldr r1, [sp, #0x14]
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	str r0, [sp, #0x18]
	ldr r0, _0221E2E4 ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	mov r1, #0
	bl BufferMoveName
	ldr r0, _0221E2E4 ; =0x00001FAC
	ldr r2, [sp, #0x18]
	ldr r0, [r5, r0]
	add r1, r7, #0
	bl StringExpandPlaceholders
	add r0, sp, #0x20
	ldrh r0, [r0, #0x10]
	cmp r0, #4
	bne _0221E2A8
	add r0, r4, r6
	bl GetWindowWidth
	add r5, r0, #0
	add r0, sp, #0x20
	ldrh r0, [r0, #0x10]
	add r1, r7, #0
	mov r2, #0
	bl FontID_String_GetWidth
	lsl r1, r5, #3
	sub r0, r1, r0
	lsr r3, r0, #1
	b _0221E2AA
_0221E2A8:
	mov r3, #0
_0221E2AA:
	add r1, sp, #0x20
	ldrh r0, [r1, #0x14]
	add r2, r7, #0
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, [sp, #0x38]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldrh r1, [r1, #0x10]
	add r0, r4, r6
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x18]
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E2DC: .word 0x00002070
_0221E2E0: .word 0x00001FA8
_0221E2E4: .word 0x00001FAC
	thumb_func_end ov08_0221E244

	thumb_func_start ov08_0221E2E8
ov08_0221E2E8: ; 0x0221E2E8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r4, r0, #0
	ldr r0, _0221E334 ; =0x00001FA8
	str r2, [sp, #0x10]
	add r5, r1, #0
	ldr r0, [r4, r0]
	add r6, r3, #0
	mov r1, #0xe
	bl NewString_ReadMsgData
	add r7, r0, #0
	str r6, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E338 ; =0x000F0E00
	mov r1, #0
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	ldr r0, _0221E33C ; =0x00002070
	lsl r5, r5, #4
	ldr r0, [r4, r0]
	ldr r3, [sp, #0x10]
	add r0, r0, r5
	add r2, r7, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	ldr r0, _0221E33C ; =0x00002070
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0221E334: .word 0x00001FA8
_0221E338: .word 0x000F0E00
_0221E33C: .word 0x00002070
	thumb_func_end ov08_0221E2E8

	thumb_func_start ov08_0221E340
ov08_0221E340: ; 0x0221E340
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, _0221E398 ; =0x00002050
	add r5, r1, #0
	mov r1, #1
	add r0, r4, r0
	add r2, r1, #0
	mov r3, #0xe
	bl DrawFrameAndWindow2
	ldr r0, _0221E398 ; =0x00002050
	mov r1, #0xf
	add r0, r4, r0
	bl FillWindowPixelBuffer
	ldr r0, _0221E39C ; =0x00001FA8
	add r1, r5, #0
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	add r5, r0, #0
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E3A0 ; =0x00010200
	mov r1, #1
	str r0, [sp, #8]
	ldr r0, _0221E398 ; =0x00002050
	add r2, r5, #0
	add r0, r4, r0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl String_Delete
	ldr r0, _0221E398 ; =0x00002050
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221E398: .word 0x00002050
_0221E39C: .word 0x00001FA8
_0221E3A0: .word 0x00010200
	thumb_func_end ov08_0221E340

	thumb_func_start ov08_0221E3A4
ov08_0221E3A4: ; 0x0221E3A4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	ldr r3, _0221E400 ; =0x00002070
	lsl r4, r1, #4
	ldr r5, [r0, r3]
	sub r3, #0xc8
	ldr r0, [r0, r3]
	add r1, r2, #0
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #4
	add r1, r7, #0
	mov r2, #0
	bl FontID_String_GetWidth
	add r6, r0, #0
	add r0, r5, r4
	bl GetWindowWidth
	add r3, r0, #0
	mov r0, #5
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E404 ; =0x00070809
	lsl r3, r3, #3
	str r0, [sp, #8]
	mov r0, #0
	sub r3, r3, r6
	str r0, [sp, #0xc]
	add r0, r5, r4
	mov r1, #4
	add r2, r7, #0
	lsr r3, r3, #1
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221E400: .word 0x00002070
_0221E404: .word 0x00070809
	thumb_func_end ov08_0221E3A4

	thumb_func_start ov08_0221E408
ov08_0221E408: ; 0x0221E408
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	add r5, r0, #0
	mov r0, #0x50
	mul r0, r1
	add r2, r5, #4
	add r4, r2, r0
	ldr r1, _0221E5C4 ; =0x00002075
	mov r0, #0x16
	ldrb r2, [r5, r1]
	sub r1, #0xcd
	mul r0, r2
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	ldr r0, [r5, r1]
	mov r1, #0x17
	bl NewString_ReadMsgData
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r2, _0221E5C8 ; =0x000F0E00
	add r0, #0x31
	str r2, [sp, #8]
	ldr r2, _0221E5CC ; =0x00002070
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r3, r1, #0
	add r0, r2, r0
	add r2, r7, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	ldr r0, _0221E5D0 ; =0x00001FA8
	mov r1, #0x18
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x18]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	str r0, [sp, #0x1c]
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldrb r2, [r4, #0x16]
	ldr r0, _0221E5D4 ; =0x00001FAC
	mov r3, #3
	lsl r2, r2, #0x19
	ldr r0, [r5, r0]
	lsr r2, r2, #0x19
	bl BufferIntegerAsString
	ldr r0, _0221E5D4 ; =0x00001FAC
	ldr r1, [sp, #0x1c]
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x18]
	bl StringExpandPlaceholders
	mov r1, #0
	add r0, r6, #0
	add r0, #0xb
	lsl r7, r0, #4
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E5C8 ; =0x000F0E00
	ldr r2, [sp, #0x1c]
	str r0, [sp, #8]
	ldr r0, _0221E5CC ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r1, #0
	add r0, r0, r7
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x18]
	bl String_Delete
	ldr r0, [sp, #0x1c]
	bl String_Delete
	ldr r0, _0221E5D0 ; =0x00001FA8
	mov r1, #0x19
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	mov r1, #0
	str r0, [sp, #0x20]
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r2, _0221E5C8 ; =0x000F0E00
	add r0, #0x41
	str r2, [sp, #8]
	ldr r2, _0221E5CC ; =0x00002070
	str r1, [sp, #0xc]
	ldr r2, [r5, r2]
	add r3, r1, #0
	add r0, r2, r0
	ldr r2, [sp, #0x20]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x20]
	bl String_Delete
	ldr r0, _0221E5D0 ; =0x00001FA8
	mov r1, #0x1a
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x14]
	ldr r1, [r1, #0xc]
	mov r0, #0xe
	bl String_New
	str r0, [sp, #0x10]
	ldrb r0, [r4, #0x16]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x19
	cmp r0, #0x64
	bhs _0221E528
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221E5D4 ; =0x00001FAC
	ldr r2, [r4, #0x24]
	ldr r3, [r4, #0x1c]
	ldr r0, [r5, r0]
	sub r2, r2, r3
	mov r1, #0
	mov r3, #6
	bl BufferIntegerAsString
	b _0221E53C
_0221E528:
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221E5D4 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	add r2, r1, #0
	mov r3, #6
	bl BufferIntegerAsString
_0221E53C:
	ldr r0, _0221E5D4 ; =0x00001FAC
	ldr r1, [sp, #0x10]
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x14]
	bl StringExpandPlaceholders
	ldr r0, _0221E5CC ; =0x00002070
	add r6, #0xc
	ldr r0, [r5, r0]
	lsl r4, r6, #4
	add r0, r0, r4
	bl GetWindowWidth
	add r6, r0, #0
	mov r0, #0
	ldr r1, [sp, #0x10]
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r1, r6, #3
	sub r0, r1, r0
	lsl r0, r0, #0x10
	mov r1, #0
	lsr r3, r0, #0x10
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E5D8 ; =0x00010200
	ldr r2, [sp, #0x10]
	str r0, [sp, #8]
	ldr r0, _0221E5CC ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x14]
	bl String_Delete
	ldr r0, [sp, #0x10]
	bl String_Delete
	ldr r0, _0221E5CC ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #0x13
	lsl r0, r0, #4
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221E5CC ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r7
	bl ScheduleWindowCopyToVram
	ldr r0, _0221E5CC ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #5
	lsl r0, r0, #6
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221E5CC ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E5C4: .word 0x00002075
_0221E5C8: .word 0x000F0E00
_0221E5CC: .word 0x00002070
_0221E5D0: .word 0x00001FA8
_0221E5D4: .word 0x00001FAC
_0221E5D8: .word 0x00010200
	thumb_func_end ov08_0221E408

	thumb_func_start ov08_0221E5DC
ov08_0221E5DC: ; 0x0221E5DC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r1, #0
	add r5, r0, #0
	ldr r1, _0221E6C0 ; =0x00002075
	mov r0, #0x16
	ldrb r2, [r5, r1]
	sub r1, #0xcd
	mul r0, r2
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldr r0, [r5, r1]
	mov r1, #0x20
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E6C4 ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221E6C8 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r1, #0
	add r0, #0xe0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E6CC ; =0x00001FA8
	mov r1, #0x21
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x10]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	mov r2, #0x50
	add r6, r0, #0
	mul r2, r7
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221E6D0 ; =0x00001FAC
	add r2, r5, r2
	ldrh r2, [r2, #0xa]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221E6D0 ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	add r1, r6, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	add r0, r4, #5
	lsl r4, r0, #4
	ldr r0, _0221E6C8 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsl r0, r0, #0x18
	mov r1, #0
	lsr r3, r0, #0x18
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E6D4 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221E6C8 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E6C8 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0xe0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221E6C8 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0221E6C0: .word 0x00002075
_0221E6C4: .word 0x000F0E00
_0221E6C8: .word 0x00002070
_0221E6CC: .word 0x00001FA8
_0221E6D0: .word 0x00001FAC
_0221E6D4: .word 0x00010200
	thumb_func_end ov08_0221E5DC

	thumb_func_start ov08_0221E6D8
ov08_0221E6D8: ; 0x0221E6D8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r1, #0
	add r5, r0, #0
	ldr r1, _0221E7BC ; =0x00002075
	mov r0, #0x16
	ldrb r2, [r5, r1]
	sub r1, #0xcd
	mul r0, r2
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldr r0, [r5, r1]
	mov r1, #0x22
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E7C0 ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221E7C4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r1, #0
	add r0, #0xf0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E7C8 ; =0x00001FA8
	mov r1, #0x23
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x10]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	mov r2, #0x50
	add r6, r0, #0
	mul r2, r7
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221E7CC ; =0x00001FAC
	add r2, r5, r2
	ldrh r2, [r2, #0xc]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221E7CC ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	add r1, r6, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	add r0, r4, #6
	lsl r4, r0, #4
	ldr r0, _0221E7C4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsl r0, r0, #0x18
	mov r1, #0
	lsr r3, r0, #0x18
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E7D0 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221E7C4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E7C4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0xf0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221E7C4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0221E7BC: .word 0x00002075
_0221E7C0: .word 0x000F0E00
_0221E7C4: .word 0x00002070
_0221E7C8: .word 0x00001FA8
_0221E7CC: .word 0x00001FAC
_0221E7D0: .word 0x00010200
	thumb_func_end ov08_0221E6D8

	thumb_func_start ov08_0221E7D4
ov08_0221E7D4: ; 0x0221E7D4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r1, #0
	add r5, r0, #0
	ldr r1, _0221E8BC ; =0x00002075
	mov r0, #0x16
	ldrb r2, [r5, r1]
	sub r1, #0xcd
	mul r0, r2
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldr r0, [r5, r1]
	mov r1, #0x28
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r2, #0xff
	str r2, [sp, #4]
	ldr r0, _0221E8C0 ; =0x000F0E00
	add r2, r2, #1
	str r0, [sp, #8]
	ldr r0, _0221E8C4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r1, #0
	add r0, r0, r2
	add r2, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E8C8 ; =0x00001FA8
	mov r1, #0x29
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x10]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	mov r2, #0x50
	add r6, r0, #0
	mul r2, r7
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221E8CC ; =0x00001FAC
	add r2, r5, r2
	ldrh r2, [r2, #0xe]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221E8CC ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	add r1, r6, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	add r0, r4, #7
	lsl r4, r0, #4
	ldr r0, _0221E8C4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsl r0, r0, #0x18
	mov r1, #0
	lsr r3, r0, #0x18
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E8D0 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221E8C4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E8C4 ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #1
	lsl r0, r0, #8
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221E8C4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E8BC: .word 0x00002075
_0221E8C0: .word 0x000F0E00
_0221E8C4: .word 0x00002070
_0221E8C8: .word 0x00001FA8
_0221E8CC: .word 0x00001FAC
_0221E8D0: .word 0x00010200
	thumb_func_end ov08_0221E7D4

	thumb_func_start ov08_0221E8D4
ov08_0221E8D4: ; 0x0221E8D4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r1, #0
	add r4, r0, #0
	ldr r1, _0221E9BC ; =0x00002075
	mov r0, #0x16
	ldrb r2, [r4, r1]
	sub r1, #0xcd
	mul r0, r2
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	ldr r0, [r4, r1]
	mov r1, #0x24
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r2, _0221E9C0 ; =0x000F0E00
	add r0, #0x11
	str r2, [sp, #8]
	ldr r2, _0221E9C4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r2, [r4, r2]
	add r3, r1, #0
	add r0, r2, r0
	add r2, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E9C8 ; =0x00001FA8
	mov r1, #0x25
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	ldr r1, [r4]
	str r0, [sp, #0x10]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	mov r2, #0x50
	add r6, r0, #0
	mul r2, r7
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221E9CC ; =0x00001FAC
	add r2, r4, r2
	ldrh r2, [r2, #0x10]
	ldr r0, [r4, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221E9CC ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r4, r0]
	add r1, r6, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, _0221E9C4 ; =0x00002070
	add r5, #8
	ldr r0, [r4, r0]
	lsl r5, r5, #4
	add r0, r0, r5
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsl r0, r0, #0x18
	mov r1, #0
	lsr r3, r0, #0x18
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221E9D0 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221E9C4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221E9C4 ; =0x00002070
	ldr r1, [r4, r0]
	mov r0, #0x11
	lsl r0, r0, #4
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221E9C4 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E9BC: .word 0x00002075
_0221E9C0: .word 0x000F0E00
_0221E9C4: .word 0x00002070
_0221E9C8: .word 0x00001FA8
_0221E9CC: .word 0x00001FAC
_0221E9D0: .word 0x00010200
	thumb_func_end ov08_0221E8D4

	thumb_func_start ov08_0221E9D4
ov08_0221E9D4: ; 0x0221E9D4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r1, #0
	add r4, r0, #0
	ldr r1, _0221EABC ; =0x00002075
	mov r0, #0x16
	ldrb r2, [r4, r1]
	sub r1, #0xcd
	mul r0, r2
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	ldr r0, [r4, r1]
	mov r1, #0x26
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r2, _0221EAC0 ; =0x000F0E00
	add r0, #0x21
	str r2, [sp, #8]
	ldr r2, _0221EAC4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r2, [r4, r2]
	add r3, r1, #0
	add r0, r2, r0
	add r2, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221EAC8 ; =0x00001FA8
	mov r1, #0x27
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	ldr r1, [r4]
	str r0, [sp, #0x10]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	mov r2, #0x50
	add r6, r0, #0
	mul r2, r7
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221EACC ; =0x00001FAC
	add r2, r4, r2
	ldrh r2, [r2, #0x12]
	ldr r0, [r4, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221EACC ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r4, r0]
	add r1, r6, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r6, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, _0221EAC4 ; =0x00002070
	add r5, #9
	ldr r0, [r4, r0]
	lsl r5, r5, #4
	add r0, r0, r5
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r7
	lsl r0, r0, #0x18
	mov r1, #0
	lsr r3, r0, #0x18
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EAD0 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221EAC4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221EAC4 ; =0x00002070
	ldr r1, [r4, r0]
	mov r0, #0x12
	lsl r0, r0, #4
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221EAC4 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, r0, r5
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221EABC: .word 0x00002075
_0221EAC0: .word 0x000F0E00
_0221EAC4: .word 0x00002070
_0221EAC8: .word 0x00001FA8
_0221EACC: .word 0x00001FAC
_0221EAD0: .word 0x00010200
	thumb_func_end ov08_0221E9D4

	thumb_func_start ov08_0221EAD4
ov08_0221EAD4: ; 0x0221EAD4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r0, #0
	mov r0, #0x50
	mul r0, r1
	add r2, r5, #4
	add r7, r2, r0
	ldr r1, _0221EC54 ; =0x00002075
	mov r0, #0x16
	ldrb r2, [r5, r1]
	sub r1, #0xcd
	mul r0, r2
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldr r0, [r5, r1]
	mov r1, #0x1c
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EC58 ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221EC5C ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r1, #0
	add r0, #0xd0
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	ldr r0, _0221EC60 ; =0x00001FA8
	mov r1, #0x1f
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	str r0, [sp, #0x10]
	mov r0, #0
	ldr r1, [sp, #0x10]
	add r2, r0, #0
	bl FontID_String_GetWidth
	str r0, [sp, #0x14]
	ldr r0, _0221EC5C ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x40
	bl GetWindowWidth
	lsl r1, r0, #3
	ldr r0, [sp, #0x14]
	ldr r2, [sp, #0x10]
	sub r0, r1, r0
	lsl r0, r0, #0xf
	lsr r6, r0, #0x10
	add r0, r4, #4
	mov r1, #0
	lsl r4, r0, #4
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EC64 ; =0x00010200
	add r3, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221EC5C ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	ldr r0, _0221EC60 ; =0x00001FA8
	mov r1, #0x1d
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x18]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	str r0, [sp, #0x1c]
	mov r1, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221EC68 ; =0x00001FAC
	ldrh r2, [r7, #0x10]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221EC68 ; =0x00001FAC
	ldr r1, [sp, #0x1c]
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x18]
	bl StringExpandPlaceholders
	mov r0, #0
	ldr r1, [sp, #0x1c]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r3, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EC64 ; =0x00010200
	ldr r2, [sp, #0x1c]
	str r0, [sp, #8]
	ldr r0, _0221EC5C ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	sub r3, r6, r3
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x18]
	bl String_Delete
	ldr r0, [sp, #0x1c]
	bl String_Delete
	ldr r0, _0221EC60 ; =0x00001FA8
	mov r1, #0x1e
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x20]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	str r0, [sp, #0x24]
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221EC68 ; =0x00001FAC
	ldrh r2, [r7, #0x12]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221EC68 ; =0x00001FAC
	ldr r1, [sp, #0x24]
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x20]
	bl StringExpandPlaceholders
	mov r1, #0
	ldr r3, [sp, #0x14]
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EC64 ; =0x00010200
	ldr r2, [sp, #0x24]
	str r0, [sp, #8]
	ldr r0, _0221EC5C ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r6, r3
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x20]
	bl String_Delete
	ldr r0, [sp, #0x24]
	bl String_Delete
	ldr r0, _0221EC5C ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0xd0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221EC5C ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221EC54: .word 0x00002075
_0221EC58: .word 0x000F0E00
_0221EC5C: .word 0x00002070
_0221EC60: .word 0x00001FA8
_0221EC64: .word 0x00010200
_0221EC68: .word 0x00001FAC
	thumb_func_end ov08_0221EAD4

	thumb_func_start ov08_0221EC6C
ov08_0221EC6C: ; 0x0221EC6C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, _0221ECD8 ; =0x00002075
	add r6, r1, #0
	ldrb r1, [r5, r0]
	ldr r3, [r5]
	mov r0, #0x16
	add r4, r1, #0
	mul r4, r0
	ldr r2, _0221ECDC ; =0x000002D2
	ldr r3, [r3, #0xc]
	mov r0, #1
	mov r1, #0x1b
	bl NewMsgDataFromNarc
	mov r1, #0x50
	mul r1, r6
	add r1, r5, r1
	ldrh r1, [r1, #0x1c]
	add r7, r0, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	mov r1, #0
	add r0, r4, #2
	lsl r4, r0, #4
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221ECE0 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	ldr r0, _0221ECE4 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r1, #0
	add r0, r0, r4
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl DestroyMsgData
	ldr r0, _0221ECE4 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, r0, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221ECD8: .word 0x00002075
_0221ECDC: .word 0x000002D2
_0221ECE0: .word 0x00010200
_0221ECE4: .word 0x00002070
	thumb_func_end ov08_0221EC6C

	thumb_func_start ov08_0221ECE8
ov08_0221ECE8: ; 0x0221ECE8
	push {r4, r5, r6, lr}
	sub sp, #0x10
	ldr r2, _0221ED28 ; =0x00002070
	lsl r4, r1, #4
	ldr r5, [r0, r2]
	sub r2, #0xc8
	ldr r0, [r0, r2]
	mov r1, #0x33
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221ED2C ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0221ED28: .word 0x00002070
_0221ED2C: .word 0x000F0E00
	thumb_func_end ov08_0221ECE8

	thumb_func_start ov08_0221ED30
ov08_0221ED30: ; 0x0221ED30
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	str r2, [sp, #0x10]
	add r5, r0, #0
	ldr r2, _0221EE0C ; =0x00002070
	ldr r0, [sp, #0x10]
	lsl r6, r1, #4
	ldr r4, [r5, r2]
	cmp r0, #0
	bne _0221ED8A
	sub r2, #0xc8
	ldr r0, [r5, r2]
	mov r1, #0x32
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #0
	add r1, r7, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	add r0, r4, r6
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r5
	lsl r0, r0, #0x10
	mov r1, #0
	lsr r3, r0, #0x10
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EE10 ; =0x00010200
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	b _0221EE00
_0221ED8A:
	sub r2, #0xc8
	ldr r0, [r5, r2]
	mov r1, #0x34
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x14]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221EE14 ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221EE14 ; =0x00001FAC
	ldr r2, [sp, #0x14]
	ldr r0, [r5, r0]
	add r1, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r7, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	add r0, r4, r6
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r5
	lsl r0, r0, #0x10
	mov r1, #0
	lsr r3, r0, #0x10
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EE10 ; =0x00010200
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
_0221EE00:
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221EE0C: .word 0x00002070
_0221EE10: .word 0x00010200
_0221EE14: .word 0x00001FAC
	thumb_func_end ov08_0221ED30

	thumb_func_start ov08_0221EE18
ov08_0221EE18: ; 0x0221EE18
	push {r4, r5, r6, lr}
	sub sp, #0x10
	ldr r2, _0221EE58 ; =0x00002070
	lsl r4, r1, #4
	ldr r5, [r0, r2]
	sub r2, #0xc8
	ldr r0, [r0, r2]
	mov r1, #0x30
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EE5C ; =0x000F0E00
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0221EE58: .word 0x00002070
_0221EE5C: .word 0x000F0E00
	thumb_func_end ov08_0221EE18

	thumb_func_start ov08_0221EE60
ov08_0221EE60: ; 0x0221EE60
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	str r2, [sp, #0x10]
	add r5, r0, #0
	ldr r2, _0221EF3C ; =0x00002070
	ldr r0, [sp, #0x10]
	lsl r6, r1, #4
	ldr r4, [r5, r2]
	cmp r0, #1
	bhi _0221EEBA
	sub r2, #0xc8
	ldr r0, [r5, r2]
	mov r1, #0x32
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #0
	add r1, r7, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	add r0, r4, r6
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r5
	lsl r0, r0, #0x10
	mov r1, #0
	lsr r3, r0, #0x10
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EF40 ; =0x00010200
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	b _0221EF30
_0221EEBA:
	sub r2, #0xc8
	ldr r0, [r5, r2]
	mov r1, #0x31
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x14]
	ldr r1, [r1, #0xc]
	mov r0, #8
	bl String_New
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221EF44 ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221EF44 ; =0x00001FAC
	ldr r2, [sp, #0x14]
	ldr r0, [r5, r0]
	add r1, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r7, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	add r0, r4, r6
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r5
	lsl r0, r0, #0x10
	mov r1, #0
	lsr r3, r0, #0x10
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EF40 ; =0x00010200
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
_0221EF30:
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221EF3C: .word 0x00002070
_0221EF40: .word 0x00010200
_0221EF44: .word 0x00001FAC
	thumb_func_end ov08_0221EE60

	thumb_func_start ov08_0221EF48
ov08_0221EF48: ; 0x0221EF48
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r3, r0, #0
	ldr r0, _0221EF9C ; =0x00002070
	add r6, r2, #0
	ldr r5, [r3, r0]
	ldr r3, [r3]
	lsl r4, r1, #4
	ldr r2, _0221EFA0 ; =0x000002ED
	ldr r3, [r3, #0xc]
	mov r0, #1
	mov r1, #0x1b
	bl NewMsgDataFromNarc
	add r1, r6, #0
	add r7, r0, #0
	bl NewString_ReadMsgData
	mov r1, #0
	add r6, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221EFA4 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r7, #0
	bl DestroyMsgData
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221EF9C: .word 0x00002070
_0221EFA0: .word 0x000002ED
_0221EFA4: .word 0x00010200
	thumb_func_end ov08_0221EF48

	thumb_func_start ov08_0221EFA8
ov08_0221EFA8: ; 0x0221EFA8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	ldr r2, _0221F004 ; =0x00002070
	lsl r4, r1, #4
	ldr r5, [r0, r2]
	sub r2, #0xc8
	ldr r0, [r0, r2]
	mov r1, #0x35
	bl NewString_ReadMsgData
	add r7, r0, #0
	mov r0, #0
	add r1, r7, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	add r0, r5, r4
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r1, r0, r6
	lsr r0, r1, #0x1f
	add r0, r1, r0
	lsl r0, r0, #0xf
	mov r1, #0
	lsr r3, r0, #0x10
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F008 ; =0x000F0E00
	add r2, r7, #0
	str r0, [sp, #8]
	add r0, r5, r4
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F004: .word 0x00002070
_0221F008: .word 0x000F0E00
	thumb_func_end ov08_0221EFA8

	thumb_func_start ov08_0221F00C
ov08_0221F00C: ; 0x0221F00C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	ldr r3, _0221F074 ; =0x00002070
	lsl r4, r1, #4
	ldr r5, [r0, r3]
	cmp r2, #0
	beq _0221F024
	cmp r2, #1
	beq _0221F032
	cmp r2, #2
	beq _0221F040
	b _0221F04C
_0221F024:
	sub r3, #0xc8
	ldr r0, [r0, r3]
	mov r1, #0x36
	bl NewString_ReadMsgData
	add r6, r0, #0
	b _0221F04C
_0221F032:
	sub r3, #0xc8
	ldr r0, [r0, r3]
	mov r1, #0x38
	bl NewString_ReadMsgData
	add r6, r0, #0
	b _0221F04C
_0221F040:
	sub r3, #0xc8
	ldr r0, [r0, r3]
	mov r1, #0x37
	bl NewString_ReadMsgData
	add r6, r0, #0
_0221F04C:
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F078 ; =0x00010200
	add r2, r6, #0
	str r0, [sp, #8]
	add r0, r5, r4
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221F074: .word 0x00002070
_0221F078: .word 0x00010200
	thumb_func_end ov08_0221F00C

	thumb_func_start ov08_0221F07C
ov08_0221F07C: ; 0x0221F07C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	add r5, r0, #0
	ldr r0, _0221F1A0 ; =0x00002070
	lsl r6, r1, #4
	ldr r4, [r5, r0]
	sub r0, #0xc8
	ldr r0, [r5, r0]
	mov r1, #0x2e
	str r2, [sp, #0x10]
	str r3, [sp, #0x14]
	bl NewString_ReadMsgData
	str r0, [sp, #0x18]
	mov r0, #0
	ldr r1, [sp, #0x18]
	add r2, r0, #0
	bl FontID_String_GetWidth
	str r0, [sp, #0x1c]
	add r0, r4, r6
	bl GetWindowWidth
	lsl r1, r0, #3
	ldr r0, [sp, #0x1c]
	ldr r2, [sp, #0x18]
	sub r0, r1, r0
	lsr r7, r0, #1
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F1A4 ; =0x000F0E00
	add r3, r7, #0
	str r0, [sp, #8]
	add r0, r4, r6
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x18]
	bl String_Delete
	ldr r0, _0221F1A8 ; =0x00001FA8
	mov r1, #0x2c
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x20]
	ldr r1, [r1, #0xc]
	mov r0, #6
	bl String_New
	mov r1, #0
	str r0, [sp, #0x24]
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221F1AC ; =0x00001FAC
	ldr r2, [sp, #0x10]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221F1AC ; =0x00001FAC
	ldr r1, [sp, #0x24]
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x20]
	bl StringExpandPlaceholders
	mov r0, #0
	ldr r1, [sp, #0x24]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r3, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F1A4 ; =0x000F0E00
	ldr r2, [sp, #0x24]
	str r0, [sp, #8]
	add r0, r4, r6
	sub r3, r7, r3
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x20]
	bl String_Delete
	ldr r0, [sp, #0x24]
	bl String_Delete
	ldr r0, _0221F1A8 ; =0x00001FA8
	mov r1, #0x2d
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	ldr r1, [r5]
	str r0, [sp, #0x28]
	ldr r1, [r1, #0xc]
	mov r0, #6
	bl String_New
	mov r1, #0
	str r0, [sp, #0x2c]
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _0221F1AC ; =0x00001FAC
	ldr r2, [sp, #0x14]
	ldr r0, [r5, r0]
	mov r3, #3
	bl BufferIntegerAsString
	ldr r0, _0221F1AC ; =0x00001FAC
	ldr r1, [sp, #0x2c]
	ldr r0, [r5, r0]
	ldr r2, [sp, #0x28]
	bl StringExpandPlaceholders
	mov r1, #0
	ldr r3, [sp, #0x1c]
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F1A4 ; =0x000F0E00
	ldr r2, [sp, #0x2c]
	str r0, [sp, #8]
	add r0, r4, r6
	add r3, r7, r3
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x28]
	bl String_Delete
	ldr r0, [sp, #0x2c]
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F1A0: .word 0x00002070
_0221F1A4: .word 0x000F0E00
_0221F1A8: .word 0x00001FA8
_0221F1AC: .word 0x00001FAC
	thumb_func_end ov08_0221F07C

	thumb_func_start ov08_0221F1B0
ov08_0221F1B0: ; 0x0221F1B0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	lsl r4, r1, #4
	ldr r1, [r0]
	ldr r2, _0221F218 ; =0x00002070
	add r1, #0x34
	ldrb r1, [r1]
	ldr r5, [r0, r2]
	cmp r1, #4
	bne _0221F1D0
	sub r2, #0xc8
	ldr r0, [r0, r2]
	mov r1, #0x3b
	bl NewString_ReadMsgData
	b _0221F1DA
_0221F1D0:
	sub r2, #0xc8
	ldr r0, [r0, r2]
	mov r1, #0x3a
	bl NewString_ReadMsgData
_0221F1DA:
	add r6, r0, #0
	mov r0, #4
	add r1, r6, #0
	mov r2, #0
	bl FontID_String_GetWidth
	add r7, r0, #0
	mov r0, #5
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F21C ; =0x00070809
	mov r3, #0x60
	str r0, [sp, #8]
	mov r0, #0
	sub r3, r3, r7
	str r0, [sp, #0xc]
	add r0, r5, r4
	mov r1, #4
	add r2, r6, #0
	lsr r3, r3, #1
	bl AddTextPrinterParameterizedWithColor
	add r0, r6, #0
	bl String_Delete
	add r0, r5, r4
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F218: .word 0x00002070
_0221F21C: .word 0x00070809
	thumb_func_end ov08_0221F1B0

	thumb_func_start ov08_0221F220
ov08_0221F220: ; 0x0221F220
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, _0221F278 ; =0x0000207A
	ldrb r1, [r4, r0]
	cmp r1, #7
	bne _0221F236
	sub r0, #0xa
	ldr r5, [r4, r0]
	add r5, #0x80
	b _0221F23C
_0221F236:
	sub r0, #0xa
	ldr r5, [r4, r0]
	add r5, #0x50
_0221F23C:
	add r0, r5, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221F27C ; =0x00001FA8
	mov r1, #0x3c
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	mov r1, #0
	add r4, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F280 ; =0x00010200
	add r2, r4, #0
	str r0, [sp, #8]
	add r0, r5, #0
	add r3, r1, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	add r0, r5, #0
	bl ScheduleWindowCopyToVram
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221F278: .word 0x0000207A
_0221F27C: .word 0x00001FA8
_0221F280: .word 0x00010200
	thumb_func_end ov08_0221F220

	thumb_func_start ov08_0221F284
ov08_0221F284: ; 0x0221F284
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r0, #0
	str r1, [sp, #0x10]
	ldr r1, [r5]
	ldr r0, _0221F3C0 ; =0x00002070
	ldr r1, [r1, #0xc]
	ldr r4, [r5, r0]
	mov r0, #6
	lsl r6, r2, #4
	bl String_New
	add r7, r0, #0
	ldr r0, _0221F3C4 ; =0x00001FA8
	mov r1, #0x2b
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	str r0, [sp, #0x14]
	mov r0, #0x18
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F3C8 ; =0x000F0E00
	ldr r2, [sp, #0x14]
	str r0, [sp, #8]
	mov r1, #0
	add r0, r4, r6
	mov r3, #0x28
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x14]
	bl String_Delete
	ldr r0, _0221F3C4 ; =0x00001FA8
	mov r1, #0x2e
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	str r0, [sp, #0x18]
	mov r0, #0
	ldr r1, [sp, #0x18]
	add r2, r0, #0
	bl FontID_String_GetWidth
	str r0, [sp, #0x1c]
	mov r0, #0x18
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F3C8 ; =0x000F0E00
	ldr r2, [sp, #0x18]
	str r0, [sp, #8]
	mov r1, #0
	add r0, r4, r6
	mov r3, #0x50
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x18]
	bl String_Delete
	ldr r0, _0221F3C4 ; =0x00001FA8
	mov r1, #0x2d
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	mov r1, #0
	str r0, [sp, #0x20]
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, [sp, #0x10]
	ldr r0, _0221F3CC ; =0x00001FAC
	ldrb r2, [r2, #3]
	ldr r0, [r5, r0]
	mov r3, #2
	bl BufferIntegerAsString
	ldr r0, _0221F3CC ; =0x00001FAC
	ldr r2, [sp, #0x20]
	ldr r0, [r5, r0]
	add r1, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0x18
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F3C8 ; =0x000F0E00
	ldr r3, [sp, #0x1c]
	str r0, [sp, #8]
	mov r1, #0
	add r3, #0x50
	add r0, r4, r6
	add r2, r7, #0
	str r1, [sp, #0xc]
	str r3, [sp, #0x1c]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x20]
	bl String_Delete
	ldr r0, _0221F3C4 ; =0x00001FA8
	mov r1, #0x2c
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	mov r1, #0
	str r0, [sp, #0x24]
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, [sp, #0x10]
	ldr r0, _0221F3CC ; =0x00001FAC
	ldrb r2, [r2, #2]
	ldr r0, [r5, r0]
	mov r3, #2
	bl BufferIntegerAsString
	ldr r0, _0221F3CC ; =0x00001FAC
	ldr r2, [sp, #0x24]
	ldr r0, [r5, r0]
	add r1, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	add r1, r7, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r5, r0, #0
	mov r0, #0x18
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F3C8 ; =0x000F0E00
	mov r3, #0x50
	str r0, [sp, #8]
	mov r1, #0
	add r0, r4, r6
	add r2, r7, #0
	sub r3, r3, r5
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x24]
	bl String_Delete
	add r0, r7, #0
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F3C0: .word 0x00002070
_0221F3C4: .word 0x00001FA8
_0221F3C8: .word 0x000F0E00
_0221F3CC: .word 0x00001FAC
	thumb_func_end ov08_0221F284

	thumb_func_start ov08_0221F3D0
ov08_0221F3D0: ; 0x0221F3D0
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	str r1, [sp, #0x10]
	ldr r1, [r5]
	ldr r0, _0221F494 ; =0x00002070
	ldr r1, [r1, #0xc]
	ldr r4, [r5, r0]
	mov r0, #6
	lsl r6, r2, #4
	bl String_New
	str r0, [sp, #0x14]
	ldr r0, _0221F498 ; =0x00001FA8
	mov r1, #0x2b
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	str r0, [sp, #0x18]
	mov r0, #0
	ldr r1, [sp, #0x18]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r7, r0, #0
	ldr r0, [sp, #0x18]
	bl String_Delete
	add r7, #0x28
	mov r0, #0x50
	sub r0, r0, r7
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	mov r0, #0x10
	lsl r2, r7, #0x10
	str r0, [sp, #4]
	add r0, r4, r6
	mov r1, #0
	lsr r2, r2, #0x10
	mov r3, #0x18
	bl FillWindowPixelRect
	ldr r0, _0221F498 ; =0x00001FA8
	mov r1, #0x2c
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	mov r1, #0
	add r7, r0, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r2, [sp, #0x10]
	ldr r0, _0221F49C ; =0x00001FAC
	ldrb r2, [r2, #2]
	ldr r0, [r5, r0]
	mov r3, #2
	bl BufferIntegerAsString
	ldr r0, _0221F49C ; =0x00001FAC
	ldr r1, [sp, #0x14]
	ldr r0, [r5, r0]
	add r2, r7, #0
	bl StringExpandPlaceholders
	mov r0, #0
	ldr r1, [sp, #0x14]
	add r2, r0, #0
	bl FontID_String_GetWidth
	add r5, r0, #0
	mov r0, #0x18
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F4A0 ; =0x000F0E00
	mov r3, #0x50
	str r0, [sp, #8]
	mov r1, #0
	ldr r2, [sp, #0x14]
	add r0, r4, r6
	sub r3, r3, r5
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r7, #0
	bl String_Delete
	ldr r0, [sp, #0x14]
	bl String_Delete
	add r0, r4, r6
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_0221F494: .word 0x00002070
_0221F498: .word 0x00001FA8
_0221F49C: .word 0x00001FAC
_0221F4A0: .word 0x000F0E00
	thumb_func_end ov08_0221F3D0

	thumb_func_start ov08_0221F4A4
ov08_0221F4A4: ; 0x0221F4A4
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [r5]
	mov r4, #0
	ldr r0, [r0]
	bl Party_GetCount
	cmp r0, #0
	ble _0221F52A
	add r0, r4, #0
	add r7, r5, #0
	str r0, [sp, #8]
	add r6, r5, #0
	add r7, #0x1b
_0221F4C2:
	ldr r0, _0221F54C ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #8]
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldrh r0, [r6, #8]
	cmp r0, #0
	beq _0221F512
	mov r0, #0x20
	str r0, [sp]
	mov r0, #7
	lsl r3, r4, #0x10
	str r0, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #4
	lsr r3, r3, #0x10
	bl ov08_0221DDCC
	ldrb r0, [r7]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _0221F4FE
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov08_0221F550
_0221F4FE:
	ldr r0, [r6, #4]
	bl Pokemon_GetStatusIconId
	cmp r0, #7
	bne _0221F512
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl ov08_0221F5B0
_0221F512:
	ldr r0, [sp, #8]
	add r6, #0x50
	add r0, #0x10
	str r0, [sp, #8]
	ldr r0, [r5]
	add r7, #0x50
	ldr r0, [r0]
	add r4, r4, #1
	bl Party_GetCount
	cmp r4, r0
	blt _0221F4C2
_0221F52A:
	ldr r0, [r5]
	add r0, #0x35
	ldrb r0, [r0]
	cmp r0, #2
	bne _0221F540
	add r0, r5, #0
	mov r1, #7
	bl ov08_0221E340
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_0221F540:
	add r0, r5, #0
	mov r1, #6
	bl ov08_0221E340
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F54C: .word 0x00002070
	thumb_func_end ov08_0221F4A4

	thumb_func_start ov08_0221F550
ov08_0221F550: ; 0x0221F550
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x18
	str r0, [sp]
	mov r0, #8
	add r6, r1, #0
	str r0, [sp, #4]
	ldr r0, _0221F5AC ; =0x00002070
	lsl r4, r6, #4
	ldr r0, [r5, r0]
	mov r1, #0
	add r0, r0, r4
	mov r2, #0x38
	mov r3, #0x20
	bl FillWindowPixelRect
	mov r2, #0x40
	str r2, [sp]
	mov r0, #8
	str r0, [sp, #4]
	ldr r0, _0221F5AC ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	mov r3, #0x18
	add r0, r0, r4
	bl FillWindowPixelRect
	mov r0, #0x20
	str r0, [sp]
	add r0, r5, #0
	add r1, r6, #0
	add r2, r6, #0
	mov r3, #0x38
	bl ov08_0221DFC8
	mov r0, #0x18
	str r0, [sp]
	add r0, r5, #0
	add r1, r6, #0
	add r2, r6, #0
	mov r3, #0x40
	bl ov08_0221E048
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221F5AC: .word 0x00002070
	thumb_func_end ov08_0221F550

	thumb_func_start ov08_0221F5B0
ov08_0221F5B0: ; 0x0221F5B0
	push {r3, lr}
	mov r2, #0x50
	mul r2, r1
	add r2, r0, r2
	ldrb r2, [r2, #0x1b]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x1f
	bne _0221F5CC
	mov r2, #0x20
	str r2, [sp]
	add r2, r1, #0
	mov r3, #0
	bl ov08_0221DF80
_0221F5CC:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov08_0221F5B0
