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

	thumb_func_start ov08_0221F5D0
ov08_0221F5D0: ; 0x0221F5D0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0221F654 ; =0x00002070
	mov r1, #0
	ldr r0, [r4, r0]
	bl FillWindowPixelBuffer
	ldr r0, _0221F654 ; =0x00002070
	mov r1, #0
	ldr r0, [r4, r0]
	add r0, #0x10
	bl FillWindowPixelBuffer
	ldr r0, _0221F654 ; =0x00002070
	mov r1, #0
	ldr r0, [r4, r0]
	add r0, #0x20
	bl FillWindowPixelBuffer
	ldr r0, _0221F654 ; =0x00002070
	mov r1, #0
	ldr r0, [r4, r0]
	add r0, #0x30
	bl FillWindowPixelBuffer
	ldr r1, [r4]
	add r0, r4, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221F658
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xf
	bl ov08_0221E3A4
	ldr r0, [r4]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r0, r4, r0
	ldrb r0, [r0, #0x1b]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _0221F63E
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x12
	bl ov08_0221E3A4
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x13
	bl ov08_0221E3A4
	pop {r4, pc}
_0221F63E:
	ldr r0, _0221F654 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, #0x20
	bl ScheduleWindowCopyToVram
	ldr r0, _0221F654 ; =0x00002070
	ldr r0, [r4, r0]
	add r0, #0x30
	bl ScheduleWindowCopyToVram
	pop {r4, pc}
	.balign 4, 0
_0221F654: .word 0x00002070
	thumb_func_end ov08_0221F5D0

	thumb_func_start ov08_0221F658
ov08_0221F658: ; 0x0221F658
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r4, r0, #0
	ldr r0, _0221F7A4 ; =0x00002070
	add r6, r1, #0
	ldr r0, [r4, r0]
	ldr r1, [r4]
	str r0, [sp, #0x18]
	mov r0, #0x50
	add r7, r6, #0
	add r5, r4, #4
	mul r7, r0
	add r0, r5, r7
	str r0, [sp, #0x14]
	ldr r1, [r1, #0xc]
	mov r0, #0xc
	bl String_New
	str r0, [sp, #0x10]
	ldr r0, _0221F7A8 ; =0x00001FA8
	ldr r1, _0221F7AC ; =ov08_02224FF4
	lsl r2, r6, #2
	ldr r0, [r4, r0]
	ldr r1, [r1, r2]
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r0, [r5, r7]
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _0221F7B0 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r4, r0]
	bl BufferBoxMonNickname
	ldr r0, _0221F7B0 ; =0x00001FAC
	ldr r1, [sp, #0x10]
	ldr r0, [r4, r0]
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	ldr r0, [sp, #0x14]
	mov r5, #0
	ldrb r0, [r0, #0x16]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1f
	bne _0221F6EC
	ldr r0, [sp, #0x14]
	ldrb r0, [r0, #0x17]
	lsl r1, r0, #0x18
	lsr r1, r1, #0x1f
	bne _0221F6EC
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	bne _0221F6DC
	ldr r0, _0221F7A8 ; =0x00001FA8
	mov r1, #0x10
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	add r5, r0, #0
	b _0221F6EC
_0221F6DC:
	cmp r0, #1
	bne _0221F6EC
	ldr r0, _0221F7A8 ; =0x00001FA8
	mov r1, #0x11
	ldr r0, [r4, r0]
	bl NewString_ReadMsgData
	add r5, r0, #0
_0221F6EC:
	ldr r1, [sp, #0x10]
	mov r0, #4
	mov r2, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	cmp r5, #0
	bne _0221F704
	mov r7, #0
	add r4, r7, #0
	b _0221F714
_0221F704:
	mov r0, #0
	add r1, r5, #0
	add r2, r0, #0
	bl FontID_String_GetWidth
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	mov r4, #8
_0221F714:
	ldr r0, [sp, #0x18]
	bl GetWindowWidth
	lsl r0, r0, #3
	sub r0, r0, r6
	sub r0, r0, r7
	sub r1, r0, r4
	lsr r0, r1, #0x1f
	add r0, r1, r0
	lsl r0, r0, #0x17
	lsr r7, r0, #0x18
	mov r0, #7
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F7B4 ; =0x00070809
	ldr r2, [sp, #0x10]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x18]
	mov r1, #4
	add r3, r7, #0
	bl AddTextPrinterParameterizedWithColor
	ldr r0, [sp, #0x10]
	bl String_Delete
	cmp r5, #0
	beq _0221F79A
	ldr r0, [sp, #0x14]
	ldrb r0, [r0, #0x17]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1d
	bne _0221F778
	mov r0, #8
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F7B8 ; =0x000A0B00
	add r3, r7, r6
	str r0, [sp, #8]
	mov r1, #0
	ldr r0, [sp, #0x18]
	add r2, r5, #0
	add r3, r4, r3
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	b _0221F794
_0221F778:
	mov r0, #8
	str r0, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _0221F7BC ; =0x000C0D00
	add r3, r7, r6
	str r0, [sp, #8]
	mov r1, #0
	ldr r0, [sp, #0x18]
	add r2, r5, #0
	add r3, r4, r3
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
_0221F794:
	add r0, r5, #0
	bl String_Delete
_0221F79A:
	ldr r0, [sp, #0x18]
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F7A4: .word 0x00002070
_0221F7A8: .word 0x00001FA8
_0221F7AC: .word ov08_02224FF4
_0221F7B0: .word 0x00001FAC
_0221F7B4: .word 0x00070809
_0221F7B8: .word 0x000A0B00
_0221F7BC: .word 0x000C0D00
	thumb_func_end ov08_0221F658

	thumb_func_start ov08_0221F7C0
ov08_0221F7C0: ; 0x0221F7C0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r0, #0
	ldr r0, _0221F8F0 ; =0x00002075
	mov r1, #6
	ldrb r2, [r5, r0]
	sub r0, r0, #5
	mul r1, r2
	lsl r1, r1, #0x10
	lsr r6, r1, #0x10
	ldr r1, [r5, r0]
	lsl r0, r6, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #1
	lsl r0, r0, #4
	str r0, [sp, #0x18]
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0x18]
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #2
	lsl r0, r0, #4
	str r0, [sp, #0x14]
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0x14]
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #3
	lsl r0, r0, #4
	str r0, [sp, #0x10]
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0x10]
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	add r0, r6, #4
	lsl r0, r0, #4
	str r0, [sp, #0xc]
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0xc]
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221F8F4 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x50
	bl FillWindowPixelBuffer
	mov r2, #0
	str r2, [sp]
	str r2, [sp, #4]
	ldr r3, [r5]
	add r0, r5, #0
	ldrb r3, [r3, #0x11]
	add r1, r6, #0
	bl ov08_0221DDCC
	add r0, r5, #0
	str r0, [sp, #0x1c]
	add r0, #0x34
	mov r4, #0
	add r7, r6, #1
	str r0, [sp, #0x1c]
_0221F85A:
	ldr r0, [r5]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	add r2, r1, #0
	mul r2, r0
	ldr r0, [sp, #0x1c]
	lsl r1, r4, #3
	add r0, r0, r2
	str r1, [sp, #0x20]
	ldrh r1, [r0, r1]
	str r0, [sp, #0x24]
	cmp r1, #0
	beq _0221F89C
	mov r0, #4
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	ldr r0, _0221F8F8 ; =0x00070809
	ldr r3, _0221F8FC ; =ov08_02224FE0
	lsl r6, r4, #2
	str r0, [sp, #8]
	ldr r3, [r3, r6]
	add r0, r5, #0
	add r2, r7, r4
	bl ov08_0221E244
	ldr r2, [sp, #0x20]
	ldr r1, [sp, #0x24]
	add r0, r5, #0
	add r1, r1, r2
	add r2, r7, r4
	bl ov08_0221F284
_0221F89C:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #4
	blo _0221F85A
	add r0, r5, #0
	mov r1, #5
	mov r2, #0x12
	bl ov08_0221E3A4
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0x18]
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0x14]
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0x10]
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r0, _0221F8F4 ; =0x00002070
	ldr r1, [r5, r0]
	ldr r0, [sp, #0xc]
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	ldr r1, _0221F8F0 ; =0x00002075
	mov r0, #1
	ldrb r2, [r5, r1]
	eor r0, r2
	strb r0, [r5, r1]
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221F8F0: .word 0x00002075
_0221F8F4: .word 0x00002070
_0221F8F8: .word 0x00070809
_0221F8FC: .word ov08_02224FE0
	thumb_func_end ov08_0221F7C0

	thumb_func_start ov08_0221F900
ov08_0221F900: ; 0x0221F900
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, _0221FB10 ; =0x00002075
	mov r1, #0x16
	ldrb r2, [r5, r0]
	sub r0, r0, #5
	add r4, r2, #0
	mul r4, r1
	ldr r1, [r5, r0]
	mov r0, #0x13
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #5
	lsl r0, r0, #6
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0xe0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0xf0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #1
	lsl r0, r0, #8
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #0x11
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #0x12
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0xd0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	mov r0, #0x15
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	lsl r0, r4, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #0
	add r0, #0xa
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #0
	add r0, #0xb
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #0
	add r0, #0xc
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #5
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #6
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #7
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #0
	add r0, #8
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #0
	add r0, #9
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #4
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #1
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #2
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FB14 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #3
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r2, #0
	str r2, [sp]
	str r2, [sp, #4]
	ldr r3, [r5]
	add r0, r5, #0
	ldrb r3, [r3, #0x11]
	add r1, r4, #0
	bl ov08_0221DDCC
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221EAD4
	mov r3, #0
	str r3, [sp]
	ldr r2, [r5]
	add r1, r4, #0
	ldrb r2, [r2, #0x11]
	add r0, r5, #0
	add r1, #0xa
	bl ov08_0221E048
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221E408
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221E5DC
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221E6D8
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221E7D4
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221E8D4
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221E9D4
	ldr r2, [r5]
	add r0, r5, #0
	ldrb r2, [r2, #0x11]
	add r1, r4, #1
	bl ov08_0221E120
	ldr r2, [r5]
	add r0, r5, #0
	ldrb r2, [r2, #0x11]
	add r1, r4, #3
	bl ov08_0221E1A8
	ldr r1, [r5]
	add r0, r5, #0
	ldrb r1, [r1, #0x11]
	bl ov08_0221EC6C
	add r0, r5, #0
	mov r1, #0x15
	mov r2, #0x13
	bl ov08_0221E3A4
	ldr r1, _0221FB10 ; =0x00002075
	mov r0, #1
	ldrb r2, [r5, r1]
	eor r0, r2
	strb r0, [r5, r1]
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221FB10: .word 0x00002075
_0221FB14: .word 0x00002070
	thumb_func_end ov08_0221F900

	thumb_func_start ov08_0221FB18
ov08_0221FB18: ; 0x0221FB18
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, _0221FC6C ; =0x00002075
	mov r1, #0xb
	ldrb r2, [r5, r0]
	sub r0, r0, #5
	ldr r0, [r5, r0]
	add r4, r2, #0
	mul r4, r1
	add r0, #0x60
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x70
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x80
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x90
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0xa0
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #1
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	ldr r1, [r5, r0]
	lsl r0, r4, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #2
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #3
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #5
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, _0221FC70 ; =0x00002070
	ldr r1, [r5, r0]
	add r0, r4, #4
	lsl r0, r0, #4
	add r0, r1, r0
	mov r1, #0
	bl FillWindowPixelBuffer
	ldr r0, [r5]
	add r2, r5, #0
	ldrb r3, [r0, #0x11]
	add r0, #0x34
	ldrb r0, [r0]
	mov r1, #0x50
	add r2, #0x34
	mul r1, r3
	add r1, r2, r1
	lsl r0, r0, #3
	add r7, r1, r0
	mov r2, #0
	str r2, [sp]
	add r0, r5, #0
	mov r1, #6
	str r2, [sp, #4]
	bl ov08_0221DDCC
	mov r2, #0
	add r0, r5, #0
	mov r1, #7
	add r3, r2, #0
	bl ov08_0221E2E8
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221FC74 ; =0x000F0E00
	add r2, r4, #0
	str r0, [sp, #8]
	ldr r3, [r5]
	ldrh r1, [r7]
	add r3, #0x34
	ldrb r3, [r3]
	add r0, r5, #0
	lsl r6, r3, #2
	ldr r3, _0221FC78 ; =ov08_02224FE0
	ldr r3, [r3, r6]
	bl ov08_0221E244
	add r0, r5, #0
	mov r1, #8
	bl ov08_0221ECE8
	ldrb r2, [r7, #6]
	add r0, r5, #0
	add r1, r4, #2
	bl ov08_0221ED30
	add r0, r5, #0
	mov r1, #9
	bl ov08_0221EE18
	ldrb r2, [r7, #7]
	add r0, r5, #0
	add r1, r4, #3
	bl ov08_0221EE60
	ldrh r2, [r7]
	add r0, r5, #0
	add r1, r4, #4
	bl ov08_0221EF48
	add r0, r5, #0
	mov r1, #0xa
	bl ov08_0221EFA8
	ldrb r2, [r7, #5]
	add r0, r5, #0
	add r1, r4, #5
	bl ov08_0221F00C
	ldrb r2, [r7, #2]
	ldrb r3, [r7, #3]
	add r0, r5, #0
	add r1, r4, #1
	bl ov08_0221F07C
	ldr r1, _0221FC6C ; =0x00002075
	mov r0, #1
	ldrb r2, [r5, r1]
	eor r0, r2
	strb r0, [r5, r1]
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221FC6C: .word 0x00002075
_0221FC70: .word 0x00002070
_0221FC74: .word 0x000F0E00
_0221FC78: .word ov08_02224FE0
	thumb_func_end ov08_0221FB18

	thumb_func_start ov08_0221FC7C
ov08_0221FC7C: ; 0x0221FC7C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	ldr r0, _0221FD98 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	bl FillWindowPixelBuffer
	ldr r0, _0221FD98 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x10
	bl FillWindowPixelBuffer
	ldr r0, _0221FD98 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x20
	bl FillWindowPixelBuffer
	ldr r0, _0221FD98 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x30
	bl FillWindowPixelBuffer
	ldr r0, _0221FD98 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x40
	bl FillWindowPixelBuffer
	ldr r0, _0221FD98 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x50
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r3, [r5]
	add r0, r5, #0
	ldrb r3, [r3, #0x11]
	add r2, r1, #0
	bl ov08_0221DDCC
	add r0, r5, #0
	mov r6, #0
	str r0, [sp, #0x10]
	add r0, #0x34
	ldr r7, _0221FD9C ; =ov08_02224FE0
	add r4, r6, #0
	str r0, [sp, #0x10]
_0221FCE8:
	ldr r0, [r5]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	add r2, r1, #0
	mul r2, r0
	ldr r0, [sp, #0x10]
	add r0, r0, r2
	ldrh r1, [r0, r4]
	str r0, [sp, #0xc]
	cmp r1, #0
	beq _0221FD20
	mov r0, #4
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	ldr r0, _0221FDA0 ; =0x00070809
	add r2, r6, #1
	str r0, [sp, #8]
	ldr r3, [r7]
	add r0, r5, #0
	bl ov08_0221E244
	ldr r1, [sp, #0xc]
	add r0, r5, #0
	add r1, r1, r4
	add r2, r6, #1
	bl ov08_0221F284
_0221FD20:
	add r6, r6, #1
	add r4, #8
	add r7, r7, #4
	cmp r6, #4
	blo _0221FCE8
	mov r0, #4
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	ldr r0, _0221FDA0 ; =0x00070809
	mov r2, #5
	str r0, [sp, #8]
	ldr r1, [r5]
	add r0, r5, #0
	ldrh r1, [r1, #0x24]
	mov r3, #0x49
	bl ov08_0221E244
	ldr r0, [r5]
	mov r1, #5
	ldrh r0, [r0, #0x24]
	bl GetMoveAttr
	add r1, sp, #0x14
	strb r0, [r1, #2]
	ldrb r0, [r1, #2]
	mov r2, #5
	strb r0, [r1, #3]
	add r0, r5, #0
	add r1, sp, #0x14
	bl ov08_0221F284
	ldr r0, _0221FD98 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x10
	bl ScheduleWindowCopyToVram
	ldr r0, _0221FD98 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x20
	bl ScheduleWindowCopyToVram
	ldr r0, _0221FD98 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x30
	bl ScheduleWindowCopyToVram
	ldr r0, _0221FD98 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x40
	bl ScheduleWindowCopyToVram
	ldr r0, _0221FD98 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x50
	bl ScheduleWindowCopyToVram
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_0221FD98: .word 0x00002070
_0221FD9C: .word ov08_02224FE0
_0221FDA0: .word 0x00070809
	thumb_func_end ov08_0221FC7C

	thumb_func_start ov08_0221FDA4
ov08_0221FDA4: ; 0x0221FDA4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x20
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x30
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x10
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x40
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x60
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x50
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x70
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x90
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0xa0
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x80
	bl FillWindowPixelBuffer
	ldr r0, _0221FF64 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0xb0
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r3, [r5]
	add r0, r5, #0
	ldrb r3, [r3, #0x11]
	add r2, r1, #0
	bl ov08_0221DDCC
	mov r2, #0
	add r0, r5, #0
	mov r1, #2
	add r3, r2, #0
	bl ov08_0221E2E8
	add r0, r5, #0
	mov r1, #4
	bl ov08_0221ECE8
	add r0, r5, #0
	mov r1, #5
	bl ov08_0221EE18
	add r0, r5, #0
	mov r1, #9
	bl ov08_0221EFA8
	ldr r1, [r5]
	add r0, r1, #0
	add r0, #0x34
	ldrb r3, [r0]
	cmp r3, #4
	bhs _0221FEE0
	ldrb r1, [r1, #0x11]
	add r2, r5, #0
	mov r0, #0x50
	add r2, #0x34
	mul r0, r1
	add r7, r2, r0
	lsl r0, r3, #3
	str r0, [sp, #0xc]
	add r4, r7, r0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221FF68 ; =0x000F0E00
	lsl r6, r3, #2
	str r0, [sp, #8]
	ldr r1, [sp, #0xc]
	ldr r3, _0221FF6C ; =ov08_02224FE0
	ldrh r1, [r7, r1]
	ldr r3, [r3, r6]
	add r0, r5, #0
	mov r2, #1
	bl ov08_0221E244
	ldrb r2, [r4, #6]
	add r0, r5, #0
	mov r1, #6
	bl ov08_0221ED30
	ldrb r2, [r4, #7]
	add r0, r5, #0
	mov r1, #7
	bl ov08_0221EE60
	ldr r2, [sp, #0xc]
	add r0, r5, #0
	ldrh r2, [r7, r2]
	mov r1, #8
	bl ov08_0221EF48
	ldrb r2, [r4, #5]
	add r0, r5, #0
	mov r1, #0xa
	bl ov08_0221F00C
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	add r0, r5, #0
	mov r1, #3
	bl ov08_0221F07C
	b _0221FF56
_0221FEE0:
	ldrh r0, [r1, #0x24]
	mov r1, #5
	bl GetMoveAttr
	add r4, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221FF68 ; =0x000F0E00
	mov r2, #1
	str r0, [sp, #8]
	ldr r1, [r5]
	add r0, r5, #0
	ldrh r1, [r1, #0x24]
	mov r3, #0x49
	bl ov08_0221E244
	ldr r2, [r5]
	add r0, r5, #0
	ldrh r2, [r2, #0x24]
	mov r1, #8
	bl ov08_0221EF48
	ldr r0, [r5]
	mov r1, #4
	ldrh r0, [r0, #0x24]
	bl GetMoveAttr
	add r2, r0, #0
	add r0, r5, #0
	mov r1, #6
	bl ov08_0221ED30
	ldr r0, [r5]
	mov r1, #2
	ldrh r0, [r0, #0x24]
	bl GetMoveAttr
	add r2, r0, #0
	add r0, r5, #0
	mov r1, #7
	bl ov08_0221EE60
	ldr r0, [r5]
	mov r1, #1
	ldrh r0, [r0, #0x24]
	bl GetMoveAttr
	add r2, r0, #0
	add r0, r5, #0
	mov r1, #0xa
	bl ov08_0221F00C
	add r0, r5, #0
	mov r1, #3
	add r2, r4, #0
	add r3, r4, #0
	bl ov08_0221F07C
_0221FF56:
	add r0, r5, #0
	mov r1, #0xb
	bl ov08_0221F1B0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221FF64: .word 0x00002070
_0221FF68: .word 0x000F0E00
_0221FF6C: .word ov08_02224FE0
	thumb_func_end ov08_0221FDA4

	thumb_func_start ov08_0221FF70
ov08_0221FF70: ; 0x0221FF70
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, _02220058 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	bl FillWindowPixelBuffer
	ldr r0, _02220058 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x10
	bl FillWindowPixelBuffer
	ldr r0, _02220058 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x20
	bl FillWindowPixelBuffer
	ldr r0, _02220058 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x30
	bl FillWindowPixelBuffer
	ldr r0, _02220058 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x40
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r3, [r5]
	add r0, r5, #0
	ldrb r3, [r3, #0x11]
	add r2, r1, #0
	bl ov08_0221DDCC
	add r0, r5, #0
	mov r6, #0
	str r0, [sp, #0x10]
	add r0, #0x34
	ldr r7, _0222005C ; =ov08_02224FE0
	add r4, r6, #0
	str r0, [sp, #0x10]
_0221FFD0:
	ldr r0, [r5]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	add r2, r1, #0
	mul r2, r0
	ldr r0, [sp, #0x10]
	add r0, r0, r2
	ldrh r1, [r0, r4]
	str r0, [sp, #0xc]
	cmp r1, #0
	beq _02220008
	mov r0, #4
	str r0, [sp]
	mov r0, #7
	str r0, [sp, #4]
	ldr r0, _02220060 ; =0x00070809
	add r2, r6, #1
	str r0, [sp, #8]
	ldr r3, [r7]
	add r0, r5, #0
	bl ov08_0221E244
	ldr r1, [sp, #0xc]
	add r0, r5, #0
	add r1, r1, r4
	add r2, r6, #1
	bl ov08_0221F284
_02220008:
	add r6, r6, #1
	add r4, #8
	add r7, r7, #4
	cmp r6, #4
	blo _0221FFD0
	ldr r2, [r5]
	mov r1, #0x25
	ldrh r0, [r2, #0x22]
	ldr r2, [r2, #0xc]
	bl GetItemAttr
	cmp r0, #0
	bne _0222002A
	add r0, r5, #0
	mov r1, #0x5e
	bl ov08_0221E340
_0222002A:
	ldr r0, _02220058 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x10
	bl ScheduleWindowCopyToVram
	ldr r0, _02220058 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x20
	bl ScheduleWindowCopyToVram
	ldr r0, _02220058 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x30
	bl ScheduleWindowCopyToVram
	ldr r0, _02220058 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x40
	bl ScheduleWindowCopyToVram
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_02220058: .word 0x00002070
_0222005C: .word ov08_02224FE0
_02220060: .word 0x00070809
	thumb_func_end ov08_0221FF70

	thumb_func_start ov08_02220064
ov08_02220064: ; 0x02220064
	push {r3, r4, r5, lr}
	ldr r4, [r0]
	add r3, r1, #0
	ldrb r5, [r4, #0x11]
	add r1, r0, #0
	mov r4, #0x50
	add r1, #0x34
	mul r4, r5
	add r4, r1, r4
	lsl r1, r2, #3
	add r1, r4, r1
	add r2, r3, #0
	bl ov08_0221F3D0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov08_02220064

	thumb_func_start ov08_02220084
ov08_02220084: ; 0x02220084
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, _022201B0 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	bl FillWindowPixelBuffer
	ldr r0, _022201B0 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x20
	bl FillWindowPixelBuffer
	ldr r0, _022201B0 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x30
	bl FillWindowPixelBuffer
	ldr r0, _022201B0 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x10
	bl FillWindowPixelBuffer
	ldr r0, _022201B0 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x40
	bl FillWindowPixelBuffer
	ldr r0, _022201B0 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x50
	bl FillWindowPixelBuffer
	ldr r0, _022201B0 ; =0x00002070
	mov r1, #0
	ldr r0, [r5, r0]
	add r0, #0x60
	bl FillWindowPixelBuffer
	mov r1, #0
	str r1, [sp]
	str r1, [sp, #4]
	ldr r3, [r5]
	add r0, r5, #0
	ldrb r3, [r3, #0x11]
	add r2, r1, #0
	bl ov08_0221DDCC
	mov r2, #0
	add r0, r5, #0
	mov r1, #2
	add r3, r2, #0
	bl ov08_0221E2E8
	ldr r0, _022201B4 ; =0x00001FA8
	mov r1, #0x39
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	mov r1, #0
	add r4, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _022201B8 ; =0x000F0E00
	add r2, r4, #0
	str r0, [sp, #8]
	ldr r0, _022201B0 ; =0x00002070
	str r1, [sp, #0xc]
	ldr r0, [r5, r0]
	add r3, r1, #0
	add r0, #0x40
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl String_Delete
	ldr r0, _022201B0 ; =0x00002070
	ldr r0, [r5, r0]
	add r0, #0x40
	bl ScheduleWindowCopyToVram
	ldr r1, [r5]
	add r0, r1, #0
	add r0, #0x34
	ldrb r3, [r0]
	cmp r3, #4
	bhs _02220176
	ldrb r1, [r1, #0x11]
	add r2, r5, #0
	mov r0, #0x50
	mul r0, r1
	add r2, #0x34
	add r2, r2, r0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _022201B8 ; =0x000F0E00
	lsl r1, r3, #3
	str r0, [sp, #8]
	lsl r6, r3, #2
	ldr r3, _022201BC ; =ov08_02224FE0
	add r4, r2, r1
	ldrh r1, [r2, r1]
	ldr r3, [r3, r6]
	add r0, r5, #0
	mov r2, #1
	bl ov08_0221E244
	ldrb r2, [r4, #2]
	ldrb r3, [r4, #3]
	add r0, r5, #0
	mov r1, #3
	bl ov08_0221F07C
	b _022201A4
_02220176:
	ldrh r0, [r1, #0x24]
	mov r1, #5
	bl GetMoveAttr
	add r4, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _022201B8 ; =0x000F0E00
	mov r2, #1
	str r0, [sp, #8]
	ldr r1, [r5]
	add r0, r5, #0
	ldrh r1, [r1, #0x24]
	mov r3, #0x49
	bl ov08_0221E244
	add r0, r5, #0
	mov r1, #3
	add r2, r4, #0
	add r3, r4, #0
	bl ov08_0221F07C
_022201A4:
	add r0, r5, #0
	mov r1, #6
	bl ov08_0221F1B0
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_022201B0: .word 0x00002070
_022201B4: .word 0x00001FA8
_022201B8: .word 0x000F0E00
_022201BC: .word ov08_02224FE0
	thumb_func_end ov08_02220084

	thumb_func_start ov08_022201C0
ov08_022201C0: ; 0x022201C0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _022201E4 ; =0x00002060
	mov r1, #1
	add r0, r4, r0
	add r2, r1, #0
	mov r3, #0xe
	bl DrawFrameAndWindow2
	ldr r0, _022201E4 ; =0x00002060
	mov r1, #0xf
	add r0, r4, r0
	bl FillWindowPixelBuffer
	add r0, r4, #0
	bl ov08_022201E8
	pop {r4, pc}
	.balign 4, 0
_022201E4: .word 0x00002060
	thumb_func_end ov08_022201C0

	thumb_func_start ov08_022201E8
ov08_022201E8: ; 0x022201E8
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #1
	bl TextFlags_SetCanABSpeedUpPrint
	ldr r0, [r4]
	ldr r0, [r0, #8]
	bl BattleSystem_GetTextFrameDelay
	mov r3, #0
	str r3, [sp]
	str r0, [sp, #4]
	ldr r2, _0222021C ; =0x00002060
	str r3, [sp, #8]
	add r0, r4, r2
	sub r2, #0xb0
	ldr r2, [r4, r2]
	mov r1, #1
	bl AddTextPrinterParameterized
	ldr r1, _02220220 ; =0x0000207B
	strb r0, [r4, r1]
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_0222021C: .word 0x00002060
_02220220: .word 0x0000207B
	thumb_func_end ov08_022201E8

	thumb_func_start ov08_02220224
ov08_02220224: ; 0x02220224
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, [r5]
	mov r1, #0
	str r0, [sp, #0xc]
	ldr r2, [sp, #0xc]
	ldrh r0, [r0, #0x22]
	ldr r2, [r2, #0xc]
	bl LoadItemDataOrGfx
	ldr r2, [sp, #0xc]
	add r6, r0, #0
	ldrb r3, [r2, #0x11]
	ldr r0, [sp, #0xc]
	ldr r1, [sp, #0xc]
	add r2, r2, r3
	add r2, #0x2c
	ldrb r2, [r2]
	ldr r0, [r0, #8]
	ldr r1, [r1, #0x28]
	bl BattleSystem_GetPartyMon
	mov r1, #0xa3
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	add r0, r6, #0
	mov r1, #0xf
	mov r4, #0
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _02220278
	mov r0, #1
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_02220278:
	add r0, r6, #0
	mov r1, #0x10
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _0222028C
	mov r0, #2
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_0222028C:
	add r0, r6, #0
	mov r1, #0x11
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _022202A0
	mov r0, #4
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_022202A0:
	add r0, r6, #0
	mov r1, #0x12
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _022202B4
	mov r0, #8
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_022202B4:
	add r0, r6, #0
	mov r1, #0x13
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _022202C8
	mov r0, #0x10
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_022202C8:
	add r0, r6, #0
	mov r1, #0x14
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _022202DC
	mov r0, #0x20
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_022202DC:
	add r0, r6, #0
	mov r1, #0x15
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _022202F0
	mov r0, #0x40
	orr r0, r4
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
_022202F0:
	ldr r0, [sp, #0xc]
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	mul r0, r1
	add r0, r5, r0
	ldrh r1, [r0, #0x14]
	cmp r1, #0
	bne _0222033A
	ldr r0, [sp, #8]
	cmp r0, #0
	beq _0222033A
	ldr r0, _02220574 ; =0x00001FA8
	mov r1, #0x58
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_0222033A:
	ldr r0, [sp, #8]
	cmp r0, r1
	beq _02220396
	ldr r0, _02220574 ; =0x00001FA8
	mov r1, #0x52
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	mov r0, #0
	str r0, [sp]
	mov r1, #1
	ldr r2, [sp, #0xc]
	str r1, [sp, #4]
	ldrb r3, [r2, #0x11]
	mov r2, #0x50
	ldr r0, _02220578 ; =0x00001FAC
	mul r2, r3
	add r2, r5, r2
	ldrh r3, [r2, #0x14]
	ldr r2, [sp, #8]
	ldr r0, [r5, r0]
	sub r2, r2, r3
	mov r3, #3
	bl BufferIntegerAsString
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_02220396:
	add r0, r6, #0
	mov r1, #0x24
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	bne _022203AE
	add r0, r6, #0
	mov r1, #0x25
	bl GetItemAttr_PreloadedItemData
	cmp r0, #0
	beq _022203BE
_022203AE:
	ldr r2, _02220574 ; =0x00001FA8
	mov r1, #0x57
	ldr r0, [r5, r2]
	add r2, #8
	ldr r2, [r5, r2]
	bl ReadMsgDataIntoString
	b _0222056A
_022203BE:
	cmp r4, #1
	ldr r0, _02220574 ; =0x00001FA8
	bne _022203F6
	ldr r0, [r5, r0]
	mov r1, #0x5c
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_022203F6:
	cmp r4, #2
	bne _0222042C
	ldr r0, [r5, r0]
	mov r1, #0x53
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_0222042C:
	cmp r4, #4
	bne _02220462
	ldr r0, [r5, r0]
	mov r1, #0x55
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_02220462:
	cmp r4, #8
	bne _02220498
	ldr r0, [r5, r0]
	mov r1, #0x56
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_02220498:
	cmp r4, #0x10
	bne _022204CE
	ldr r0, [r5, r0]
	mov r1, #0x54
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_022204CE:
	cmp r4, #0x20
	bne _02220504
	ldr r0, [r5, r0]
	mov r1, #0x5a
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_02220504:
	cmp r4, #0x40
	bne _0222053A
	ldr r0, [r5, r0]
	mov r1, #0x5b
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	b _0222056A
_0222053A:
	ldr r0, [r5, r0]
	mov r1, #0x59
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r7, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _02220578 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r1, _02220578 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
_0222056A:
	add r0, r6, #0
	bl Heap_Free
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02220574: .word 0x00001FA8
_02220578: .word 0x00001FAC
	thumb_func_end ov08_02220224

	thumb_func_start ov08_0222057C
ov08_0222057C: ; 0x0222057C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r3, [r5]
	ldrb r2, [r3, #0x11]
	ldr r0, [r3, #8]
	ldr r1, [r3, #0x28]
	add r2, r3, r2
	add r2, #0x2c
	ldrb r2, [r2]
	bl BattleSystem_GetPartyMon
	add r6, r0, #0
	ldr r0, _022205D4 ; =0x00001FA8
	mov r1, #0x5f
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	add r4, r0, #0
	add r0, r6, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, _022205D8 ; =0x00001FAC
	mov r1, #0
	ldr r0, [r5, r0]
	bl BufferBoxMonNickname
	ldr r0, _022205D8 ; =0x00001FAC
	ldr r2, _022205DC ; =MOVE_EMBARGO
	ldr r0, [r5, r0]
	mov r1, #1
	bl BufferMoveName
	ldr r1, _022205D8 ; =0x00001FAC
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r4, #0
	bl String_Delete
	pop {r4, r5, r6, pc}
	.balign 4, 0
_022205D4: .word 0x00001FA8
_022205D8: .word 0x00001FAC
_022205DC: .word MOVE_EMBARGO
	thumb_func_end ov08_0222057C

	thumb_func_start ov08_022205E0
ov08_022205E0: ; 0x022205E0
	push {r4, lr}
	add r4, r0, #0
	bl ov08_0222061C
	add r0, r4, #0
	bl ov08_02220668
	add r0, r4, #0
	bl ov08_02220750
	add r0, r4, #0
	bl ov08_02220800
	add r0, r4, #0
	bl ov08_02220878
	add r0, r4, #0
	bl ov08_02220928
	add r0, r4, #0
	bl ov08_02220A28
	add r0, r4, #0
	bl ov08_0222162C
	mov r0, #0x10
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	pop {r4, pc}
	thumb_func_end ov08_022205E0

	thumb_func_start ov08_0222061C
ov08_0222061C: ; 0x0222061C
	push {r3, r4, r5, lr}
	sub sp, #0x18
	ldr r3, _02220660 ; =ov08_0222541C
	add r2, sp, #0
	add r5, r0, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	add r4, r0, #0
	bl SpriteManager_New
	ldr r1, _02220664 ; =0x00001FB4
	mov r2, #0x2b
	str r0, [r5, r1]
	ldr r1, [r5, r1]
	add r0, r4, #0
	bl SpriteSystem_InitSprites
	ldr r1, _02220664 ; =0x00001FB4
	add r0, r4, #0
	ldr r1, [r5, r1]
	add r2, sp, #0
	bl SpriteSystem_InitManagerWithCapacities
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_02220660: .word ov08_0222541C
_02220664: .word 0x00001FB4
	thumb_func_end ov08_0222061C

	thumb_func_start ov08_02220668
ov08_02220668: ; 0x02220668
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r6, r0, #0
	ldr r1, [r6]
	mov r0, #0x14
	ldr r1, [r1, #0xc]
	bl NARC_New
	add r7, r0, #0
	ldr r0, [r6]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	str r0, [sp, #0x18]
	bl sub_02074490
	str r7, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r1, #3
	str r1, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _02220748 ; =0x0000B007
	ldr r3, _0222074C ; =0x00001FB4
	str r0, [sp, #0x14]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	ldr r2, [sp, #0x18]
	ldr r3, [r6, r3]
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	bl sub_02074498
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _02220748 ; =0x0000B007
	ldr r1, _0222074C ; =0x00001FB4
	str r0, [sp, #4]
	ldr r0, [sp, #0x18]
	ldr r1, [r6, r1]
	add r2, r7, #0
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	bl sub_020744A4
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _02220748 ; =0x0000B007
	ldr r1, _0222074C ; =0x00001FB4
	str r0, [sp, #4]
	ldr r0, [sp, #0x18]
	ldr r1, [r6, r1]
	add r2, r7, #0
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	mov r4, #0
	add r5, r6, #0
_022206E4:
	ldrh r0, [r5, #8]
	cmp r0, #0
	beq _0222070E
	ldr r0, [r5, #4]
	bl Pokemon_GetIconNaix
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _02220748 ; =0x0000B007
	ldr r1, _0222074C ; =0x00001FB4
	add r0, r4, r0
	str r0, [sp, #8]
	ldr r0, [sp, #0x18]
	ldr r1, [r6, r1]
	add r2, r7, #0
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	b _02220734
_0222070E:
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	bl GetMonIconNaixEx
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _02220748 ; =0x0000B007
	ldr r1, _0222074C ; =0x00001FB4
	add r0, r4, r0
	str r0, [sp, #8]
	ldr r0, [sp, #0x18]
	ldr r1, [r6, r1]
	add r2, r7, #0
	bl SpriteSystem_LoadCharResObjFromOpenNarc
_02220734:
	add r4, r4, #1
	add r5, #0x50
	cmp r4, #6
	blo _022206E4
	add r0, r7, #0
	bl NARC_Delete
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_02220748: .word 0x0000B007
_0222074C: .word 0x00001FB4
	thumb_func_end ov08_02220668

	thumb_func_start ov08_02220750
ov08_02220750: ; 0x02220750
	push {r4, r5, r6, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	ldr r1, [r5]
	add r4, r0, #0
	ldr r1, [r1, #0xc]
	mov r0, #0x27
	bl NARC_New
	add r6, r0, #0
	bl sub_0208AD58
	str r6, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _022207F4 ; =0x0000B008
	ldr r3, _022207F8 ; =0x00001FB4
	str r0, [sp, #0x14]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [r5, r3]
	mov r1, #3
	add r2, r4, #0
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	bl sub_0208AD5C
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _022207F4 ; =0x0000B008
	ldr r1, _022207F8 ; =0x00001FB4
	str r0, [sp, #4]
	ldr r1, [r5, r1]
	add r0, r4, #0
	add r2, r6, #0
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	bl sub_0208AD60
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _022207F4 ; =0x0000B008
	ldr r1, _022207F8 ; =0x00001FB4
	str r0, [sp, #4]
	ldr r1, [r5, r1]
	add r0, r4, #0
	add r2, r6, #0
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	bl sub_0208AD54
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _022207FC ; =0x0000B00D
	ldr r1, _022207F8 ; =0x00001FB4
	str r0, [sp, #8]
	ldr r1, [r5, r1]
	add r0, r4, #0
	add r2, r6, #0
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	add r0, r6, #0
	bl NARC_Delete
	add sp, #0x18
	pop {r4, r5, r6, pc}
	nop
_022207F4: .word 0x0000B008
_022207F8: .word 0x00001FB4
_022207FC: .word 0x0000B00D
	thumb_func_end ov08_02220750

	thumb_func_start ov08_02220800
ov08_02220800: ; 0x02220800
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	add r6, r0, #0
	mov r0, #2
	str r0, [sp]
	ldr r0, _02220868 ; =0x0000B009
	ldr r3, _0222086C ; =0x00001FB4
	str r0, [sp, #4]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [r5, r3]
	mov r1, #3
	add r2, r6, #0
	bl sub_02077720
	ldr r1, _0222086C ; =0x00001FB4
	ldr r2, _02220868 ; =0x0000B009
	ldr r1, [r5, r1]
	add r0, r6, #0
	add r3, r2, #0
	bl sub_0207775C
	ldr r4, _02220870 ; =0x0000B00E
	add r7, r4, #6
_0222083C:
	ldr r1, _0222086C ; =0x00001FB4
	str r4, [sp]
	ldr r1, [r5, r1]
	add r0, r6, #0
	mov r2, #2
	mov r3, #0
	bl sub_020776B8
	add r4, r4, #1
	cmp r4, r7
	bls _0222083C
	ldr r0, _02220874 ; =0x0000B015
	ldr r1, _0222086C ; =0x00001FB4
	str r0, [sp]
	ldr r1, [r5, r1]
	add r0, r6, #0
	mov r2, #2
	mov r3, #0
	bl sub_02077834
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02220868: .word 0x0000B009
_0222086C: .word 0x00001FB4
_02220870: .word 0x0000B00E
_02220874: .word 0x0000B015
	thumb_func_end ov08_02220800

	thumb_func_start ov08_02220878
ov08_02220878: ; 0x02220878
	push {r4, r5, r6, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r1, [r5]
	mov r0, #0x15
	ldr r1, [r1, #0xc]
	bl NARC_New
	add r4, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	add r6, r0, #0
	bl sub_0207CAA0
	str r4, [sp]
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _0222091C ; =0x0000B00A
	ldr r3, _02220920 ; =0x00001FB4
	str r0, [sp, #0x14]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [r5, r3]
	mov r1, #3
	add r2, r6, #0
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	bl sub_0207CAA4
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _0222091C ; =0x0000B00A
	ldr r1, _02220920 ; =0x00001FB4
	str r0, [sp, #4]
	ldr r1, [r5, r1]
	add r0, r6, #0
	add r2, r4, #0
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	bl sub_0207CAA8
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, _0222091C ; =0x0000B00A
	ldr r1, _02220920 ; =0x00001FB4
	str r0, [sp, #4]
	ldr r1, [r5, r1]
	add r0, r6, #0
	add r2, r4, #0
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	bl sub_0207CA9C
	add r3, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _02220924 ; =0x0000B016
	ldr r1, _02220920 ; =0x00001FB4
	str r0, [sp, #8]
	ldr r1, [r5, r1]
	add r0, r6, #0
	add r2, r4, #0
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	add r0, r4, #0
	bl NARC_Delete
	add sp, #0x18
	pop {r4, r5, r6, pc}
	nop
_0222091C: .word 0x0000B00A
_02220920: .word 0x00001FB4
_02220924: .word 0x0000B016
	thumb_func_end ov08_02220878

	thumb_func_start ov08_02220928
ov08_02220928: ; 0x02220928
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	add r4, r0, #0
	mov r0, #0x47
	str r0, [sp]
	mov r0, #0x1b
	str r0, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #2
	str r0, [sp, #0x10]
	ldr r0, _022209AC ; =0x0000B00B
	ldr r3, _022209B0 ; =0x00001FB4
	str r0, [sp, #0x14]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r3, [r5, r3]
	mov r1, #3
	add r2, r4, #0
	bl SpriteSystem_LoadPaletteBuffer
	mov r0, #0
	str r0, [sp]
	ldr r0, _022209AC ; =0x0000B00B
	ldr r1, _022209B0 ; =0x00001FB4
	str r0, [sp, #4]
	ldr r1, [r5, r1]
	add r0, r4, #0
	mov r2, #0x47
	mov r3, #0x19
	bl SpriteSystem_LoadCellResObj
	mov r0, #0
	str r0, [sp]
	ldr r0, _022209AC ; =0x0000B00B
	ldr r1, _022209B0 ; =0x00001FB4
	str r0, [sp, #4]
	ldr r1, [r5, r1]
	add r0, r4, #0
	mov r2, #0x47
	mov r3, #0x18
	bl SpriteSystem_LoadAnimResObj
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _022209B4 ; =0x0000B017
	ldr r1, _022209B0 ; =0x00001FB4
	str r0, [sp, #8]
	ldr r1, [r5, r1]
	add r0, r4, #0
	mov r2, #0x47
	mov r3, #0x1a
	bl SpriteSystem_LoadCharResObj
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022209AC: .word 0x0000B00B
_022209B0: .word 0x00001FB4
_022209B4: .word 0x0000B017
	thumb_func_end ov08_02220928

	thumb_func_start ov08_022209B8
ov08_022209B8: ; 0x022209B8
	push {r4, r5, lr}
	sub sp, #0x34
	add r5, r0, #0
	ldr r0, [r5]
	add r4, r1, #0
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	mov r2, #0
	add r1, sp, #0
	strh r2, [r1]
	strh r2, [r1, #2]
	strh r2, [r1, #4]
	strh r2, [r1, #6]
	mov r1, #0x14
	ldr r3, _02220A10 ; =ov08_02225654
	mul r1, r4
	ldr r3, [r3, r1]
	str r2, [sp, #0xc]
	str r3, [sp, #8]
	mov r3, #2
	str r3, [sp, #0x10]
	ldr r3, _02220A14 ; =ov08_02225644
	str r2, [sp, #0x30]
	ldr r3, [r3, r1]
	add r2, sp, #0
	str r3, [sp, #0x14]
	ldr r3, _02220A18 ; =ov08_02225648
	ldr r3, [r3, r1]
	str r3, [sp, #0x18]
	ldr r3, _02220A1C ; =ov08_0222564C
	ldr r3, [r3, r1]
	str r3, [sp, #0x1c]
	ldr r3, _02220A20 ; =ov08_02225650
	ldr r1, [r3, r1]
	str r1, [sp, #0x20]
	mov r1, #1
	str r1, [sp, #0x2c]
	ldr r1, _02220A24 ; =0x00001FB4
	ldr r1, [r5, r1]
	bl SpriteSystem_NewSprite
	add sp, #0x34
	pop {r4, r5, pc}
	.balign 4, 0
_02220A10: .word ov08_02225654
_02220A14: .word ov08_02225644
_02220A18: .word ov08_02225648
_02220A1C: .word ov08_0222564C
_02220A20: .word ov08_02225650
_02220A24: .word 0x00001FB4
	thumb_func_end ov08_022209B8

	thumb_func_start ov08_02220A28
ov08_02220A28: ; 0x02220A28
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r7, _02220A4C ; =0x00001FB8
	mov r4, #0
	add r5, r6, #0
_02220A32:
	add r0, r6, #0
	add r1, r4, #0
	bl ov08_022209B8
	str r0, [r5, r7]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0x26
	blo _02220A32
	add r0, r6, #0
	bl ov08_02220AAC
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02220A4C: .word 0x00001FB8
	thumb_func_end ov08_02220A28

	thumb_func_start ov08_02220A50
ov08_02220A50: ; 0x02220A50
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	ldr r0, [r7]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	ldr r6, _02220A84 ; =0x00001FB8
	str r0, [sp]
	mov r4, #0
	add r5, r7, #0
_02220A64:
	ldr r0, [r5, r6]
	bl Sprite_DeleteAndFreeResources
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0x26
	blo _02220A64
	add r0, r7, #0
	bl ov08_02221698
	ldr r1, _02220A88 ; =0x00001FB4
	ldr r0, [sp]
	ldr r1, [r7, r1]
	bl SpriteSystem_FreeResourcesAndManager
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02220A84: .word 0x00001FB8
_02220A88: .word 0x00001FB4
	thumb_func_end ov08_02220A50

	thumb_func_start ov08_02220A8C
ov08_02220A8C: ; 0x02220A8C
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r2, #0
	mov r1, #1
	add r6, r0, #0
	bl ManagedSprite_SetDrawFlag
	lsl r1, r5, #0x10
	lsl r2, r4, #0x10
	add r0, r6, #0
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov08_02220A8C

	thumb_func_start ov08_02220AAC
ov08_02220AAC: ; 0x02220AAC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r4, r5, #0
	mov r7, #0
	add r4, #0x1b
	add r6, r5, #0
_02220AB8:
	ldrh r0, [r5, #8]
	cmp r0, #0
	beq _02220AD8
	add r1, r5, #0
	ldrb r2, [r4]
	add r1, #0x32
	ldrb r1, [r1]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x1f
	bl GetMonIconPaletteEx
	add r1, r0, #0
	ldr r0, _02220AE8 ; =0x00001FD4
	ldr r0, [r6, r0]
	bl ManagedSprite_SetPaletteOverride
_02220AD8:
	add r7, r7, #1
	add r5, #0x50
	add r4, #0x50
	add r6, r6, #4
	cmp r7, #6
	blt _02220AB8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02220AE8: .word 0x00001FD4
	thumb_func_end ov08_02220AAC

	thumb_func_start ov08_02220AEC
ov08_02220AEC: ; 0x02220AEC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, [r5]
	add r6, r3, #0
	ldr r0, [r0, #8]
	add r7, r1, #0
	add r4, r2, #0
	bl BattleSystem_GetSpriteSystem
	str r0, [sp, #8]
	bl sub_020776B4
	str r0, [sp, #0xc]
	add r0, r6, #0
	bl sub_02077678
	add r3, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r1, _02220B38 ; =0x00001FB4
	str r4, [sp, #4]
	ldr r0, [sp, #8]
	ldr r1, [r5, r1]
	ldr r2, [sp, #0xc]
	bl SpriteSystem_ReplaceCharResObj
	add r0, r6, #0
	bl sub_0207769C
	add r1, r0, #0
	add r0, r7, #0
	add r1, r1, #4
	bl ManagedSprite_SetPaletteOverride
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02220B38: .word 0x00001FB4
	thumb_func_end ov08_02220AEC

	thumb_func_start ov08_02220B3C
ov08_02220B3C: ; 0x02220B3C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [r5]
	add r4, r2, #0
	ldr r0, [r0, #8]
	add r6, r1, #0
	bl BattleSystem_GetSpriteSystem
	add r7, r0, #0
	bl sub_02077830
	str r0, [sp, #8]
	add r0, r4, #0
	bl sub_02077800
	add r3, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, _02220B88 ; =0x0000B015
	ldr r1, _02220B8C ; =0x00001FB4
	str r0, [sp, #4]
	ldr r1, [r5, r1]
	ldr r2, [sp, #8]
	add r0, r7, #0
	bl SpriteSystem_ReplaceCharResObj
	add r0, r4, #0
	bl sub_02077818
	add r1, r0, #0
	add r0, r6, #0
	add r1, r1, #4
	bl ManagedSprite_SetPaletteOverride
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_02220B88: .word 0x0000B015
_02220B8C: .word 0x00001FB4
	thumb_func_end ov08_02220B3C

	thumb_func_start ov08_02220B90
ov08_02220B90: ; 0x02220B90
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r5, r1, #0
	add r4, r2, #0
	add r7, r3, #0
	cmp r6, #7
	beq _02220BB0
	add r0, r5, #0
	add r1, r6, #0
	bl ManagedSprite_SetAnim
	add r0, r5, #0
	add r1, r4, #0
	add r2, r7, #0
	bl ov08_02220A8C
_02220BB0:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_02220B90

	thumb_func_start ov08_02220BB4
ov08_02220BB4: ; 0x02220BB4
	push {r4, r5, r6, lr}
	add r4, r1, #0
	ldr r1, _02220BF8 ; =0x00002004
	add r5, r0, #0
	add r6, r2, #0
	ldrb r3, [r4, #0x14]
	ldr r1, [r5, r1]
	ldr r2, _02220BFC ; =0x0000B00E
	bl ov08_02220AEC
	ldr r0, _02220BF8 ; =0x00002004
	ldr r1, [r6]
	ldr r0, [r5, r0]
	ldr r2, [r6, #4]
	bl ov08_02220A8C
	ldrb r3, [r4, #0x15]
	ldrb r0, [r4, #0x14]
	cmp r0, r3
	beq _02220BF4
	ldr r1, _02220C00 ; =0x00002008
	ldr r2, _02220C04 ; =0x0000B00F
	ldr r1, [r5, r1]
	add r0, r5, #0
	bl ov08_02220AEC
	ldr r0, _02220C00 ; =0x00002008
	ldr r1, [r6, #8]
	ldr r0, [r5, r0]
	ldr r2, [r6, #0xc]
	bl ov08_02220A8C
_02220BF4:
	pop {r4, r5, r6, pc}
	nop
_02220BF8: .word 0x00002004
_02220BFC: .word 0x0000B00E
_02220C00: .word 0x00002008
_02220C04: .word 0x0000B00F
	thumb_func_end ov08_02220BB4

	thumb_func_start ov08_02220C08
ov08_02220C08: ; 0x02220C08
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r2, #0
	add r6, r3, #0
	cmp r0, #0
	beq _02220C38
	bl ItemIdIsMail
	cmp r0, #1
	bne _02220C26
	add r0, r5, #0
	mov r1, #1
	bl ManagedSprite_SetAnim
	b _02220C2E
_02220C26:
	add r0, r5, #0
	mov r1, #0
	bl ManagedSprite_SetAnim
_02220C2E:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov08_02220A8C
_02220C38:
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov08_02220C08

	thumb_func_start ov08_02220C3C
ov08_02220C3C: ; 0x02220C3C
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r2, #0
	add r6, r3, #0
	cmp r0, #0
	beq _02220C5A
	add r0, r5, #0
	mov r1, #2
	bl ManagedSprite_SetAnim
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov08_02220A8C
_02220C5A:
	pop {r4, r5, r6, pc}
	thumb_func_end ov08_02220C3C

	thumb_func_start ov08_02220C5C
ov08_02220C5C: ; 0x02220C5C
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r7, _02220CF0 ; =0x00001FB8
	str r1, [sp]
	mov r5, #0
	add r4, r6, #0
_02220C68:
	ldr r0, [r4, r7]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #0x26
	blo _02220C68
	ldr r0, [sp]
	cmp r0, #9
	bhi _02220CEC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02220C8A: ; jump table
	.short _02220C9E - _02220C8A - 2 ; case 0
	.short _02220CA6 - _02220C8A - 2 ; case 1
	.short _02220CAE - _02220C8A - 2 ; case 2
	.short _02220CB6 - _02220C8A - 2 ; case 3
	.short _02220CBE - _02220C8A - 2 ; case 4
	.short _02220CC6 - _02220C8A - 2 ; case 5
	.short _02220CCE - _02220C8A - 2 ; case 6
	.short _02220CD6 - _02220C8A - 2 ; case 7
	.short _02220CDE - _02220C8A - 2 ; case 8
	.short _02220CE6 - _02220C8A - 2 ; case 9
_02220C9E:
	add r0, r6, #0
	bl ov08_02220CF4
	pop {r3, r4, r5, r6, r7, pc}
_02220CA6:
	add r0, r6, #0
	bl ov08_02220D90
	pop {r3, r4, r5, r6, r7, pc}
_02220CAE:
	add r0, r6, #0
	bl ov08_02220DE8
	pop {r3, r4, r5, r6, r7, pc}
_02220CB6:
	add r0, r6, #0
	bl ov08_02220E80
	pop {r3, r4, r5, r6, r7, pc}
_02220CBE:
	add r0, r6, #0
	bl ov08_02220F58
	pop {r3, r4, r5, r6, r7, pc}
_02220CC6:
	add r0, r6, #0
	bl ov08_0222114C
	pop {r3, r4, r5, r6, r7, pc}
_02220CCE:
	add r0, r6, #0
	bl ov08_0222101C
	pop {r3, r4, r5, r6, r7, pc}
_02220CD6:
	add r0, r6, #0
	bl ov08_02221088
	pop {r3, r4, r5, r6, r7, pc}
_02220CDE:
	add r0, r6, #0
	bl ov08_02221230
	pop {r3, r4, r5, r6, r7, pc}
_02220CE6:
	add r0, r6, #0
	bl ov08_022211B8
_02220CEC:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02220CF0: .word 0x00001FB8
	thumb_func_end ov08_02220C5C

	thumb_func_start ov08_02220CF4
ov08_02220CF4: ; 0x02220CF4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r0, #0
	mov r0, #0
	str r0, [sp, #4]
	add r0, r6, #0
	str r0, [sp]
	add r0, #0x1b
	ldr r4, _02220D78 ; =ov08_02225534
	ldr r7, _02220D7C ; =ov08_02225564
	add r5, r6, #0
	str r0, [sp]
_02220D0C:
	ldrh r0, [r6, #8]
	cmp r0, #0
	beq _02220D5A
	ldr r0, _02220D80 ; =0x00001FD4
	ldr r1, [r4]
	ldr r0, [r5, r0]
	ldr r2, [r4, #4]
	bl ov08_02220A8C
	ldr r0, [sp]
	ldr r1, _02220D84 ; =0x00001FEC
	ldrb r0, [r0]
	ldr r1, [r5, r1]
	ldr r2, [r7]
	lsl r0, r0, #0x19
	ldr r3, [r7, #4]
	lsr r0, r0, #0x1c
	bl ov08_02220B90
	ldr r1, _02220D88 ; =0x00001FB8
	ldr r2, [r4]
	ldr r3, [r4, #4]
	ldrh r0, [r6, #0x1e]
	ldr r1, [r5, r1]
	add r2, #8
	add r3, #8
	bl ov08_02220C08
	add r0, r6, #0
	add r0, #0x31
	ldr r1, _02220D8C ; =0x00002038
	ldr r2, [r4]
	ldr r3, [r4, #4]
	ldrb r0, [r0]
	ldr r1, [r5, r1]
	add r2, #0x10
	add r3, #8
	bl ov08_02220C3C
_02220D5A:
	ldr r0, [sp]
	add r6, #0x50
	add r0, #0x50
	str r0, [sp]
	ldr r0, [sp, #4]
	add r4, #8
	add r0, r0, #1
	add r5, r5, #4
	add r7, #8
	str r0, [sp, #4]
	cmp r0, #6
	blt _02220D0C
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02220D78: .word ov08_02225534
_02220D7C: .word ov08_02225564
_02220D80: .word 0x00001FD4
_02220D84: .word 0x00001FEC
_02220D88: .word 0x00001FB8
_02220D8C: .word 0x00002038
	thumb_func_end ov08_02220CF4

	thumb_func_start ov08_02220D90
ov08_02220D90: ; 0x02220D90
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02220DE4 ; =0x00001FB8
	mov r2, #0x48
	ldr r0, [r1, r0]
	mov r1, #0x80
	bl ov08_02220A8C
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x50
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02220DE4 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x88
	bl ov08_02220C08
	ldr r1, [r5]
	add r4, #0x2d
	ldrb r1, [r1, #0x11]
	ldrb r0, [r4]
	mov r3, #0x50
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02220DE4 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x90
	bl ov08_02220C3C
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02220DE4: .word 0x00001FB8
	thumb_func_end ov08_02220D90

	thumb_func_start ov08_02220DE8
ov08_02220DE8: ; 0x02220DE8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02220E74 ; =0x00001FB8
	mov r2, #0xc
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r1, [r5]
	ldrb r0, [r4, #0x17]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r0, r0, #0x19
	add r1, #0xd
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02220E74 ; =0x00001FB8
	lsr r0, r0, #0x1c
	ldr r1, [r2, r1]
	mov r2, #0xc6
	bl ov08_02220B90
	ldr r2, _02220E78 ; =ov08_022253F4
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02220BB4
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02220E74 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [r5]
	add r0, r4, #0
	ldrb r1, [r1, #0x11]
	add r0, #0x2d
	ldrb r0, [r0]
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02220E74 ; =0x00001FB8
	mov r3, #0x14
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	ldr r1, _02220E7C ; =0x00001FD0
	ldrh r0, [r4, #0x1a]
	ldr r1, [r5, r1]
	mov r2, #0x14
	mov r3, #0x84
	bl ov08_02220C08
	pop {r3, r4, r5, pc}
	nop
_02220E74: .word 0x00001FB8
_02220E78: .word ov08_022253F4
_02220E7C: .word 0x00001FD0
	thumb_func_end ov08_02220DE8

	thumb_func_start ov08_02220E80
ov08_02220E80: ; 0x02220E80
	push {r3, r4, r5, r6, r7, lr}
	str r0, [sp]
	ldr r0, [r0]
	ldrb r2, [r0, #0x11]
	ldr r0, [sp]
	add r1, r0, #4
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r1, r0, #2
	ldr r0, [sp]
	mov r2, #0xc
	add r1, r0, r1
	ldr r0, _02220F44 ; =0x00001FB8
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r1, [sp]
	ldrb r0, [r4, #0x17]
	ldr r1, [r1]
	mov r3, #0x14
	ldrb r1, [r1, #0x11]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1c
	add r1, #0xd
	lsl r2, r1, #2
	ldr r1, [sp]
	add r2, r1, r2
	ldr r1, _02220F44 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0xc6
	bl ov08_02220B90
	ldr r0, [sp]
	ldr r2, _02220F48 ; =ov08_022253D4
	add r1, r4, #0
	bl ov08_02220BB4
	ldr r1, [sp]
	ldrh r0, [r4, #0x1a]
	ldr r1, [r1]
	mov r3, #0x14
	ldrb r1, [r1, #0x11]
	lsl r2, r1, #2
	ldr r1, [sp]
	add r2, r1, r2
	ldr r1, _02220F44 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [sp]
	add r0, r4, #0
	ldr r1, [r1]
	add r0, #0x2d
	ldrb r1, [r1, #0x11]
	ldrb r0, [r0]
	mov r3, #0x14
	add r1, #0x20
	lsl r2, r1, #2
	ldr r1, [sp]
	add r2, r1, r2
	ldr r1, _02220F44 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	ldr r5, [sp]
	ldr r6, _02220F4C ; =ov08_02225454
	mov r7, #0
_02220F10:
	ldrh r0, [r4, #0x30]
	cmp r0, #0
	beq _02220F36
	add r3, r4, #0
	ldr r1, _02220F50 ; =0x0000200C
	add r3, #0x34
	ldr r2, _02220F54 ; =0x0000B010
	ldrb r3, [r3]
	ldr r0, [sp]
	ldr r1, [r5, r1]
	add r2, r7, r2
	bl ov08_02220AEC
	ldr r0, _02220F50 ; =0x0000200C
	ldr r1, [r6]
	ldr r0, [r5, r0]
	ldr r2, [r6, #4]
	bl ov08_02220A8C
_02220F36:
	add r7, r7, #1
	add r4, #8
	add r5, r5, #4
	add r6, #8
	cmp r7, #4
	blo _02220F10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02220F44: .word 0x00001FB8
_02220F48: .word ov08_022253D4
_02220F4C: .word ov08_02225454
_02220F50: .word 0x0000200C
_02220F54: .word 0x0000B010
	thumb_func_end ov08_02220E80

	thumb_func_start ov08_02220F58
ov08_02220F58: ; 0x02220F58
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02221010 ; =0x00001FB8
	mov r2, #0xc
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r1, [r5]
	ldrb r0, [r4, #0x17]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r0, r0, #0x19
	add r1, #0xd
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221010 ; =0x00001FB8
	lsr r0, r0, #0x1c
	ldr r1, [r2, r1]
	mov r2, #0xc6
	bl ov08_02220B90
	ldr r2, _02221014 ; =ov08_022253E4
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02220BB4
	ldr r0, [r5]
	mov r2, #0x30
	add r0, #0x34
	ldrb r0, [r0]
	add r0, #0x15
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02221010 ; =0x00001FB8
	ldr r0, [r1, r0]
	mov r1, #0x88
	bl ov08_02220A8C
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221010 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [r5]
	add r0, r4, #0
	ldrb r1, [r1, #0x11]
	add r0, #0x2d
	ldrb r0, [r0]
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221010 ; =0x00001FB8
	mov r3, #0x14
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	ldr r2, [r5]
	ldr r1, _02221018 ; =0x00002020
	add r2, #0x34
	ldrb r2, [r2]
	ldr r1, [r5, r1]
	add r0, r5, #0
	lsl r2, r2, #3
	add r2, r4, r2
	add r2, #0x35
	ldrb r2, [r2]
	bl ov08_02220B3C
	ldr r0, _02221018 ; =0x00002020
	mov r1, #0x18
	ldr r0, [r5, r0]
	mov r2, #0x58
	bl ov08_02220A8C
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02221010: .word 0x00001FB8
_02221014: .word ov08_022253E4
_02221018: .word 0x00002020
	thumb_func_end ov08_02220F58

	thumb_func_start ov08_0222101C
ov08_0222101C: ; 0x0222101C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02221080 ; =0x00001FB8
	mov r2, #0xc
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r2, _02221084 ; =ov08_022253C4
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02220BB4
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221080 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [r5]
	add r4, #0x2d
	ldrb r1, [r1, #0x11]
	ldrb r0, [r4]
	mov r3, #0x14
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221080 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	add r0, r5, #0
	bl ov08_022213C8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02221080: .word 0x00001FB8
_02221084: .word ov08_022253C4
	thumb_func_end ov08_0222101C

	thumb_func_start ov08_02221088
ov08_02221088: ; 0x02221088
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02221140 ; =0x00001FB8
	mov r2, #0xc
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r2, _02221144 ; =ov08_022253B4
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02220BB4
	ldr r0, [r5]
	mov r2, #0x30
	add r0, #0x34
	ldrb r0, [r0]
	add r0, #0x15
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02221140 ; =0x00001FB8
	ldr r0, [r1, r0]
	mov r1, #0x88
	bl ov08_02220A8C
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221140 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [r5]
	add r0, r4, #0
	ldrb r1, [r1, #0x11]
	add r0, #0x2d
	ldrb r0, [r0]
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221140 ; =0x00001FB8
	mov r3, #0x14
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	ldr r1, [r5]
	add r0, r1, #0
	add r0, #0x34
	ldrb r2, [r0]
	cmp r2, #4
	bhs _0222111E
	lsl r2, r2, #3
	add r2, r4, r2
	ldr r1, _02221148 ; =0x00002020
	add r2, #0x35
	ldrb r2, [r2]
	ldr r1, [r5, r1]
	add r0, r5, #0
	bl ov08_02220B3C
	b _02221132
_0222111E:
	ldrh r0, [r1, #0x24]
	mov r1, #1
	bl GetMoveAttr
	ldr r1, _02221148 ; =0x00002020
	add r2, r0, #0
	ldr r1, [r5, r1]
	add r0, r5, #0
	bl ov08_02220B3C
_02221132:
	ldr r0, _02221148 ; =0x00002020
	mov r1, #0x18
	ldr r0, [r5, r0]
	mov r2, #0x58
	bl ov08_02220A8C
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02221140: .word 0x00001FB8
_02221144: .word ov08_022253B4
_02221148: .word 0x00002020
	thumb_func_end ov08_02221088

	thumb_func_start ov08_0222114C
ov08_0222114C: ; 0x0222114C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _022211B0 ; =0x00001FB8
	mov r2, #0xc
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r2, _022211B4 ; =ov08_022253C4
	add r0, r5, #0
	add r1, r4, #0
	bl ov08_02220BB4
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _022211B0 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [r5]
	add r4, #0x2d
	ldrb r1, [r1, #0x11]
	ldrb r0, [r4]
	mov r3, #0x14
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _022211B0 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	add r0, r5, #0
	bl ov08_022213C8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022211B0: .word 0x00001FB8
_022211B4: .word ov08_022253C4
	thumb_func_end ov08_0222114C

	thumb_func_start ov08_022211B8
ov08_022211B8: ; 0x022211B8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _0222122C ; =0x00001FB8
	mov r2, #0xc
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r0, [r5]
	mov r2, #0x48
	add r0, #0x34
	ldrb r0, [r0]
	add r0, #0x15
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _0222122C ; =0x00001FB8
	ldr r0, [r1, r0]
	mov r1, #0x88
	bl ov08_02220A8C
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _0222122C ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [r5]
	add r4, #0x2d
	ldrb r1, [r1, #0x11]
	ldrb r0, [r4]
	mov r3, #0x14
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _0222122C ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	add r0, r5, #0
	bl ov08_02221500
	pop {r3, r4, r5, pc}
	nop
_0222122C: .word 0x00001FB8
	thumb_func_end ov08_022211B8

	thumb_func_start ov08_02221230
ov08_02221230: ; 0x02221230
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	add r1, r5, #4
	ldrb r2, [r0, #0x11]
	mov r0, #0x50
	mul r0, r2
	add r4, r1, r0
	add r0, r2, #7
	lsl r0, r0, #2
	add r1, r5, r0
	ldr r0, _02221290 ; =0x00001FB8
	mov r2, #0xc
	ldr r0, [r1, r0]
	mov r1, #0x18
	bl ov08_02220A8C
	ldr r1, [r5]
	ldrh r0, [r4, #0x1a]
	ldrb r1, [r1, #0x11]
	mov r3, #0x14
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221290 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x20
	bl ov08_02220C08
	ldr r1, [r5]
	add r4, #0x2d
	ldrb r1, [r1, #0x11]
	ldrb r0, [r4]
	mov r3, #0x14
	add r1, #0x20
	lsl r1, r1, #2
	add r2, r5, r1
	ldr r1, _02221290 ; =0x00001FB8
	ldr r1, [r2, r1]
	mov r2, #0x28
	bl ov08_02220C3C
	add r0, r5, #0
	bl ov08_022213C8
	add r0, r5, #0
	bl ov08_02221500
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02221290: .word 0x00001FB8
	thumb_func_end ov08_02221230

	thumb_func_start ov08_02221294
ov08_02221294: ; 0x02221294
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r0, [r6]
	add r2, r6, #4
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	mov r4, #0
	mul r0, r1
	add r0, r2, r0
	str r0, [sp]
_022212A8:
	ldr r0, [sp]
	lsl r5, r4, #3
	add r3, r0, r5
	ldrh r0, [r3, #0x30]
	cmp r0, #0
	beq _022212DC
	lsl r0, r4, #2
	add r3, #0x34
	add r7, r6, r0
	ldr r1, _02221314 ; =0x0000200C
	ldr r2, _02221318 ; =0x0000B010
	ldrb r3, [r3]
	ldr r1, [r7, r1]
	add r0, r6, #0
	add r2, r4, r2
	bl ov08_02220AEC
	ldr r0, _0222131C ; =ov08_0222550C
	ldr r1, _0222131C ; =ov08_0222550C
	add r2, r0, r5
	ldr r0, _02221314 ; =0x0000200C
	ldr r1, [r1, r5]
	ldr r0, [r7, r0]
	ldr r2, [r2, #4]
	bl ov08_02220A8C
_022212DC:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #4
	blo _022212A8
	ldr r0, [r6]
	ldrh r0, [r0, #0x24]
	cmp r0, #0
	beq _02221312
	mov r1, #3
	bl GetMoveAttr
	add r3, r0, #0
	ldr r1, _02221320 ; =0x0000201C
	lsl r3, r3, #0x18
	ldr r1, [r6, r1]
	ldr r2, _02221324 ; =0x0000B014
	add r0, r6, #0
	lsr r3, r3, #0x18
	bl ov08_02220AEC
	ldr r0, _02221320 ; =0x0000201C
	mov r1, #0x58
	ldr r0, [r6, r0]
	mov r2, #0xb0
	bl ov08_02220A8C
_02221312:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02221314: .word 0x0000200C
_02221318: .word 0x0000B010
_0222131C: .word ov08_0222550C
_02221320: .word 0x0000201C
_02221324: .word 0x0000B014
	thumb_func_end ov08_02221294
