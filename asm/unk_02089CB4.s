#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
#include "constants/ribbon.h"
#include "constants/field_move_response.h"
#include "msgdata/msg/msg_0300.h"
	.include "asm/macros.inc"
	.include "unk_02088288.inc"
	.include "global.inc"

	.public gOverlayTemplate_Battle
	.public gNatureStatMods

	.text

	thumb_func_start sub_02089CB4
sub_02089CB4: ; 0x02089CB4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #0
	beq _02089CCE
	cmp r0, #1
	beq _02089CCE
	cmp r0, #2
	beq _02089CD6
	b _02089CDC
_02089CCE:
	ldr r0, _02089D3C ; =0x000007BC
	mov r1, #0
	strb r1, [r4, r0]
	b _02089CDC
_02089CD6:
	ldr r0, _02089D3C ; =0x000007BC
	mov r1, #1
	strb r1, [r4, r0]
_02089CDC:
	add r0, r4, #0
	bl sub_0208B448
	add r0, r4, #0
	bl sub_0208B5A8
	add r0, r4, #0
	bl sub_0208C2A0
	add r0, r4, #0
	bl sub_0208BD38
	add r0, r4, #0
	bl sub_0208BCD4
	add r0, r4, #0
	bl sub_0208C42C
	add r0, r4, #0
	bl sub_0208CBD4
	add r0, r4, #0
	bl sub_02089F98
	add r0, r4, #0
	bl sub_0208B9C8
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #2
	bne _02089D26
	add r0, r4, #0
	bl sub_0208A8F4
	pop {r4, pc}
_02089D26:
	add r0, r4, #0
	bl sub_0208B400
	add r0, r4, #0
	bl sub_0208BF9C
	add r0, r4, #0
	bl sub_0208BFD0
	pop {r4, pc}
	nop
_02089D3C: .word 0x000007BC
	thumb_func_end sub_02089CB4

	thumb_func_start sub_02089D40
sub_02089D40: ; 0x02089D40
	push {r3, r4, r5, r6}
	mov r6, #0
	strb r6, [r0, #0x15]
	add r0, #0x15
	mov r3, #1
_02089D4A:
	ldrb r5, [r1, r6]
	cmp r5, #4
	beq _02089D64
	add r2, r3, #0
	ldrb r4, [r0]
	lsl r2, r5
	orr r2, r4
	strb r2, [r0]
	add r2, r6, #1
	lsl r2, r2, #0x18
	lsr r6, r2, #0x18
	cmp r6, #4
	blo _02089D4A
_02089D64:
	pop {r3, r4, r5, r6}
	bx lr
	thumb_func_end sub_02089D40

	thumb_func_start sub_02089D68
sub_02089D68: ; 0x02089D68
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r1, #0
	ldr r1, _02089E10 ; =0x000007BC
	add r5, r0, #0
	ldrsb r1, [r5, r1]
	cmp r1, r4
	beq _02089E0C
	bl sub_0208C4E0
	ldr r0, _02089E10 ; =0x000007BC
	strb r4, [r5, r0]
	add r0, r5, #0
	bl sub_0208B448
	add r0, r5, #0
	bl sub_0208B5A8
	add r0, r5, #0
	bl sub_0208B89C
	add r0, r5, #0
	bl sub_0208B9C8
	add r0, r5, #0
	bl sub_0208C2A0
	add r0, r5, #0
	bl sub_0208BCD4
	add r0, r5, #0
	bl sub_0208C42C
	mov r0, #3
	str r0, [sp]
	mov r0, #0x12
	str r0, [sp, #4]
	mov r0, #0x14
	mov r2, #0
	str r0, [sp, #8]
	str r2, [sp, #0xc]
	ldr r0, [r5]
	mov r1, #1
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r5]
	mov r1, #1
	bl BgCommitTilemapBufferToVram
	mov r0, #3
	str r0, [sp]
	mov r0, #0x12
	str r0, [sp, #4]
	mov r0, #0x14
	mov r2, #0
	str r0, [sp, #8]
	str r2, [sp, #0xc]
	ldr r0, [r5]
	mov r1, #4
	add r3, r2, #0
	bl FillBgTilemapRect
	ldr r0, [r5]
	mov r1, #4
	bl BgCommitTilemapBufferToVram
	add r0, r5, #0
	bl sub_0208CBD4
	add r0, r5, #0
	bl sub_02089F98
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #2
	bne _02089E0C
	add r0, r5, #0
	bl sub_0208A950
_02089E0C:
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02089E10: .word 0x000007BC
	thumb_func_end sub_02089D68

	thumb_func_start sub_02089E14
sub_02089E14: ; 0x02089E14
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _02089E2C ; =0x000005E1
	add r4, r1, #0
	bl PlaySE
	lsl r1, r4, #0x18
	add r0, r5, #0
	lsr r1, r1, #0x18
	bl sub_02089D68
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02089E2C: .word 0x000005E1
	thumb_func_end sub_02089E14

	thumb_func_start sub_02089E30
sub_02089E30: ; 0x02089E30
	push {r3, r4, r5, r6, r7, lr}
	add r3, r0, #0
	ldr r0, _02089E7C ; =0x000007BC
	add r2, r1, #0
	ldrsb r1, [r3, r0]
	mov r0, #0xa
	lsl r0, r0, #6
	ldr r4, [r3, r0]
	mov ip, r1
	lsl r4, r4, #3
	lsr r4, r4, #0x1f
	bne _02089E7A
	sub r0, #0x54
	ldr r0, [r3, r0]
	mov r7, #0
	ldrb r0, [r0, #0x15]
	mov r6, #2
	mov r4, #1
_02089E54:
	add r1, r1, r2
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bpl _02089E60
	add r1, r6, #0
	b _02089E66
_02089E60:
	cmp r1, #2
	ble _02089E66
	add r1, r7, #0
_02089E66:
	add r5, r4, #0
	lsl r5, r1
	tst r5, r0
	beq _02089E54
	mov r0, ip
	cmp r1, r0
	beq _02089E7A
	add r0, r3, #0
	bl sub_02089E14
_02089E7A:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02089E7C: .word 0x000007BC
	thumb_func_end sub_02089E30

	thumb_func_start sub_02089E80
sub_02089E80: ; 0x02089E80
	mov r2, #0x8b
	lsl r2, r2, #2
	ldr r0, [r0, r2]
	ldrb r3, [r0, #0x15]
	mov r0, #1
	add r2, r0, #0
	lsl r2, r1
	add r1, r3, #0
	tst r1, r2
	bne _02089E96
	mov r0, #0
_02089E96:
	bx lr
	thumb_func_end sub_02089E80

	thumb_func_start sub_02089E98
sub_02089E98: ; 0x02089E98
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl sub_0208E544
	add r5, r0, #0
	cmp r5, #0xff
	bne _02089EAA
	mov r0, #2
	pop {r3, r4, r5, pc}
_02089EAA:
	cmp r5, #9
	bhi _02089F4C
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02089EBA: ; jump table
	.short _02089ECE - _02089EBA - 2 ; case 0
	.short _02089EE6 - _02089EBA - 2 ; case 1
	.short _02089EE6 - _02089EBA - 2 ; case 2
	.short _02089F0A - _02089EBA - 2 ; case 3
	.short _02089F24 - _02089EBA - 2 ; case 4
	.short _02089F24 - _02089EBA - 2 ; case 5
	.short _02089F24 - _02089EBA - 2 ; case 6
	.short _02089F24 - _02089EBA - 2 ; case 7
	.short _02089F24 - _02089EBA - 2 ; case 8
	.short _02089F24 - _02089EBA - 2 ; case 9
_02089ECE:
	add r0, r4, #0
	add r1, r5, #0
	bl sub_02089E80
	cmp r0, #0
	beq _02089F4C
	lsl r1, r5, #0x18
	add r0, r4, #0
	asr r1, r1, #0x18
	bl sub_02089E14
	b _02089F4C
_02089EE6:
	mov r0, #0xa
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	lsl r0, r0, #3
	lsr r0, r0, #0x1f
	bne _02089F4C
	add r0, r4, #0
	add r1, r5, #0
	bl sub_02089E80
	cmp r0, #0
	beq _02089F4C
	lsl r1, r5, #0x18
	add r0, r4, #0
	asr r1, r1, #0x18
	bl sub_02089E14
	b _02089F4C
_02089F0A:
	add r0, r4, #0
	mov r1, #1
	bl sub_0208ADB8
	mov r0, #0x25
	lsl r0, r0, #6
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x15
	bl sub_0208B044
	pop {r3, r4, r5, pc}
_02089F24:
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	sub r5, r5, #4
	ldrb r0, [r0, #0x14]
	cmp r0, r5
	beq _02089F4C
	add r0, r4, #0
	add r1, r5, #0
	bl sub_0208A310
	cmp r0, #0
	beq _02089F4C
	lsl r1, r5, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl sub_0208A234
	mov r0, #0x13
	pop {r3, r4, r5, pc}
_02089F4C:
	mov r0, #2
	pop {r3, r4, r5, pc}
	thumb_func_end sub_02089E98

	thumb_func_start sub_02089F50
sub_02089F50: ; 0x02089F50
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r6, r1, #0
	add r1, r2, #0
	mov r0, #0xa2
	mov r2, #0x13
	add r4, r3, #0
	bl AllocAndReadWholeNarcMemberByIdPair
	add r1, sp, #0xc
	add r7, r0, #0
	bl NNS_G2dGetUnpackedScreenData
	mov r3, #0
	lsl r1, r4, #0x18
	str r3, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r2, [sp, #0xc]
	ldr r0, [r5]
	lsr r1, r1, #0x18
	add r2, #0xc
	bl LoadRectToBgTilemapRect
	lsl r1, r4, #0x18
	add r0, r6, #0
	lsr r1, r1, #0x18
	bl ScheduleBgTilemapBufferTransfer
	add r0, r7, #0
	bl Heap_Free
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end sub_02089F50

	thumb_func_start sub_02089F98
sub_02089F98: ; 0x02089F98
	push {r3, r4, r5, lr}
	mov r1, #0x8b
	add r4, r0, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	ldr r1, [r1, #0x34]
	cmp r1, #0
	bne _02089FBC
	ldr r1, _0208A0DC ; =0x000007BC
	ldrsb r1, [r4, r1]
	cmp r1, #2
	bne _02089FBC
	ldr r1, [r4]
	mov r2, #0xb
	mov r3, #3
	bl sub_02089F50
	b _02089FD4
_02089FBC:
	ldr r2, _0208A0DC ; =0x000007BC
	ldr r1, [r4]
	ldrsb r3, [r4, r2]
	mov r2, #0xc
	add r0, r4, #0
	add r5, r3, #0
	mul r5, r2
	ldr r2, _0208A0E0 ; =_021039B8
	mov r3, #3
	ldr r2, [r2, r5]
	bl sub_02089F50
_02089FD4:
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	ldrb r1, [r1, #0x12]
	cmp r1, #2
	bne _0208A024
	ldr r2, _0208A0DC ; =0x000007BC
	ldr r1, [r4]
	ldrsb r3, [r4, r2]
	mov r2, #0xc
	add r0, r4, #0
	add r5, r3, #0
	mul r5, r2
	ldr r2, _0208A0E4 ; =_021039B8 + 8
	mov r3, #6
	ldr r2, [r2, r5]
	bl sub_02089F50
	ldr r0, [r4]
	mov r1, #5
	mov r2, #0
	mov r3, #0x80
	bl ScheduleSetBgPosText
	ldr r0, [r4]
	mov r1, #5
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrh r0, [r0, #0x18]
	cmp r0, #0
	bne _0208A090
	add r0, r4, #0
	bl sub_0208AF70
	b _0208A090
_0208A024:
	add r0, #0x54
	ldr r0, [r4, r0]
	lsl r0, r0, #3
	lsr r0, r0, #0x1f
	beq _0208A048
	ldr r2, _0208A0DC ; =0x000007BC
	ldr r1, [r4]
	ldrsb r3, [r4, r2]
	mov r2, #0xc
	add r0, r4, #0
	add r5, r3, #0
	mul r5, r2
	ldr r2, _0208A0E4 ; =_021039B8 + 8
	mov r3, #6
	ldr r2, [r2, r5]
	bl sub_02089F50
	b _0208A090
_0208A048:
	add r0, r4, #0
	mov r1, #2
	bl sub_02089E80
	cmp r0, #0
	beq _0208A06E
	ldr r2, _0208A0DC ; =0x000007BC
	ldr r1, [r4]
	ldrsb r3, [r4, r2]
	mov r2, #0xc
	add r0, r4, #0
	add r5, r3, #0
	mul r5, r2
	ldr r2, _0208A0E8 ; =_021039B8 + 4
	mov r3, #6
	ldr r2, [r2, r5]
	bl sub_02089F50
	b _0208A090
_0208A06E:
	ldr r0, _0208A0DC ; =0x000007BC
	ldrsb r0, [r4, r0]
	cmp r0, #0
	bne _0208A084
	ldr r1, [r4]
	add r0, r4, #0
	mov r2, #0x4d
	mov r3, #6
	bl sub_02089F50
	b _0208A090
_0208A084:
	ldr r1, [r4]
	add r0, r4, #0
	mov r2, #0x4e
	mov r3, #6
	bl sub_02089F50
_0208A090:
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x11]
	cmp r0, #2
	bne _0208A0B2
	mov r0, #0x7d
	lsl r0, r0, #4
	mov r1, #4
	ldr r0, [r4, r0]
	mov r2, #0x14
	add r3, r1, #0
	bl sub_020196E8
	add r0, r4, #0
	bl sub_0208B118
_0208A0B2:
	mov r0, #0xa
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	lsl r0, r0, #3
	lsr r0, r0, #0x1f
	bne _0208A0D8
	ldr r0, _0208A0DC ; =0x000007BC
	ldrsb r0, [r4, r0]
	cmp r0, #0
	bne _0208A0CE
	add r0, r4, #0
	bl sub_0208A1A0
	pop {r3, r4, r5, pc}
_0208A0CE:
	cmp r0, #1
	bne _0208A0D8
	add r0, r4, #0
	bl sub_0208A0EC
_0208A0D8:
	pop {r3, r4, r5, pc}
	nop
_0208A0DC: .word 0x000007BC
_0208A0E0: .word _021039B8
_0208A0E4: .word _021039B8 + 8
_0208A0E8: .word _021039B8 + 4
	thumb_func_end sub_02089F98

	thumb_func_start sub_0208A0EC
sub_0208A0EC: ; 0x0208A0EC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	mov r1, #0x95
	add r6, r0, #0
	lsl r1, r1, #2
	ldrh r0, [r6, r1]
	add r1, r1, #2
	ldrh r1, [r6, r1]
	mov r2, #0x30
	bl CalculateHpBarColor
	cmp r0, #4
	bhi _0208A126
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0208A112: ; jump table
	.short _0208A11C - _0208A112 - 2 ; case 0
	.short _0208A124 - _0208A112 - 2 ; case 1
	.short _0208A120 - _0208A112 - 2 ; case 2
	.short _0208A11C - _0208A112 - 2 ; case 3
	.short _0208A11C - _0208A112 - 2 ; case 4
_0208A11C:
	ldr r7, _0208A194 ; =0x0000F097
	b _0208A126
_0208A120:
	ldr r7, _0208A198 ; =0x0000F0B7
	b _0208A126
_0208A124:
	ldr r7, _0208A19C ; =0x0000F0D7
_0208A126:
	mov r1, #0x95
	lsl r1, r1, #2
	ldrh r0, [r6, r1]
	add r1, r1, #2
	ldrh r1, [r6, r1]
	mov r2, #0x30
	bl CalculateHpBarPixelsLength
	add r4, r0, #0
	add r0, r7, #0
	add r0, #8
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	mov r5, #0
	str r0, [sp, #0x10]
_0208A144:
	cmp r4, #8
	blo _0208A14C
	ldr r2, [sp, #0x10]
	b _0208A152
_0208A14C:
	add r0, r7, r4
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
_0208A152:
	mov r0, #5
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	add r3, r5, #0
	str r0, [sp, #8]
	mov r0, #0x11
	add r3, #0xa
	str r0, [sp, #0xc]
	lsl r3, r3, #0x18
	ldr r0, [r6]
	mov r1, #3
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	cmp r4, #8
	bhs _0208A178
	mov r4, #0
	b _0208A17E
_0208A178:
	sub r4, #8
	lsl r0, r4, #0x18
	lsr r4, r0, #0x18
_0208A17E:
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	cmp r5, #6
	blo _0208A144
	ldr r0, [r6]
	mov r1, #3
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0208A194: .word 0x0000F097
_0208A198: .word 0x0000F0B7
_0208A19C: .word 0x0000F0D7
	thumb_func_end sub_0208A0EC

	thumb_func_start sub_0208A1A0
sub_0208A1A0: ; 0x0208A1A0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	ldr r2, _0208A228 ; =0x00000242
	add r6, r0, #0
	ldrb r0, [r6, r2]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x19
	cmp r0, #0x64
	bhs _0208A1C8
	add r0, r2, #0
	add r1, r2, #0
	add r0, #0xa
	add r1, #0xe
	add r2, r2, #6
	ldr r0, [r6, r0]
	ldr r1, [r6, r1]
	ldr r2, [r6, r2]
	sub r1, r1, r0
	sub r0, r2, r0
	b _0208A1CC
_0208A1C8:
	mov r1, #0
	add r0, r1, #0
_0208A1CC:
	mov r2, #0x38
	bl CalculateHpBarPixelsLength
	add r4, r0, #0
	mov r5, #0
	mov r7, #0x13
_0208A1D8:
	cmp r4, #8
	blo _0208A1E0
	ldr r2, _0208A22C ; =0x0000E03F
	b _0208A1E8
_0208A1E0:
	ldr r0, _0208A230 ; =0x0000E037
	add r0, r4, r0
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
_0208A1E8:
	str r7, [sp]
	mov r0, #1
	str r0, [sp, #4]
	add r3, r5, #0
	str r0, [sp, #8]
	mov r0, #0x11
	add r3, #9
	str r0, [sp, #0xc]
	lsl r3, r3, #0x18
	ldr r0, [r6]
	mov r1, #6
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	cmp r4, #8
	bhs _0208A20C
	mov r4, #0
	b _0208A212
_0208A20C:
	sub r4, #8
	lsl r0, r4, #0x18
	lsr r4, r0, #0x18
_0208A212:
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	cmp r5, #7
	blo _0208A1D8
	ldr r0, [r6]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0208A228: .word 0x00000242
_0208A22C: .word 0x0000E03F
_0208A230: .word 0x0000E037
	thumb_func_end sub_0208A1A0

	thumb_func_start sub_0208A234
sub_0208A234: ; 0x0208A234
	push {r4, lr}
	mov r2, #0x8b
	add r4, r0, #0
	lsl r2, r2, #2
	ldr r2, [r4, r2]
	strb r1, [r2, #0x14]
	bl sub_020897C0
	add r0, r4, #0
	bl sub_02089C50
	add r0, r4, #0
	bl sub_0208C57C
	add r0, r4, #0
	bl sub_0208C614
	add r0, r4, #0
	bl sub_0208C6B4
	add r0, r4, #0
	bl sub_02089F98
	add r0, r4, #0
	bl sub_0208E4B4
	add r0, r4, #0
	bl sub_0208B448
	add r0, r4, #0
	bl sub_0208BA60
	add r0, r4, #0
	bl sub_0208B5A8
	add r0, r4, #0
	bl sub_0208B89C
	add r0, r4, #0
	bl sub_0208B9C8
	add r0, r4, #0
	bl sub_0208C2A0
	add r0, r4, #0
	bl sub_0208BE70
	add r0, r4, #0
	bl sub_0208B48C
	add r0, r4, #0
	bl sub_0208B4EC
	add r0, r4, #0
	bl sub_0208BCD4
	add r0, r4, #0
	bl sub_0208BD38
	add r0, r4, #0
	bl sub_0208CBD4
	add r0, r4, #0
	bl sub_0208B400
	add r0, r4, #0
	bl sub_0208BFD0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_0208A234

	thumb_func_start sub_0208A2C0
sub_0208A2C0: ; 0x0208A2C0
	push {r4, lr}
	add r4, r0, #0
	bl sub_0208A2E0
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _0208A2DC
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl sub_0208A234
_0208A2DC:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_0208A2C0

	thumb_func_start sub_0208A2E0
sub_0208A2E0: ; 0x0208A2E0
	push {r3, lr}
	mov r2, #0x8b
	lsl r2, r2, #2
	ldr r2, [r0, r2]
	ldrb r2, [r2, #0x11]
	cmp r2, #0
	beq _0208A2F8
	cmp r2, #1
	beq _0208A2FE
	cmp r2, #2
	beq _0208A304
	b _0208A30A
_0208A2F8:
	bl sub_0208A3F4
	pop {r3, pc}
_0208A2FE:
	bl sub_0208A45C
	pop {r3, pc}
_0208A304:
	bl sub_0208A4B8
	pop {r3, pc}
_0208A30A:
	mov r0, #0
	mvn r0, r0
	pop {r3, pc}
	thumb_func_end sub_0208A2E0

	thumb_func_start sub_0208A310
sub_0208A310: ; 0x0208A310
	push {r4, r5, r6, lr}
	add r4, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r2, [r4, r0]
	add r5, r1, #0
	ldrb r0, [r2, #0x11]
	cmp r0, #0
	beq _0208A32C
	cmp r0, #1
	beq _0208A35C
	cmp r0, #2
	beq _0208A396
	b _0208A3C6
_0208A32C:
	bl sub_02070D90
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	add r6, r5, #0
	ldr r4, [r1]
	mul r6, r0
	add r0, r4, r6
	mov r1, #5
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A3C6
	add r0, r4, r6
	mov r1, #0x4c
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A3C6
	mov r0, #1
	pop {r4, r5, r6, pc}
_0208A35C:
	ldrb r0, [r2, #0x13]
	cmp r5, r0
	bge _0208A3C6
	ldr r0, [r2]
	bl Party_GetMonByIndex
	mov r1, #5
	mov r2, #0
	add r5, r0, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A3C6
	add r0, r5, #0
	mov r1, #0x4c
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A392
	add r0, r4, #0
	bl sub_0208A3CC
	cmp r0, #1
	bne _0208A3C6
	mov r0, #1
	pop {r4, r5, r6, pc}
_0208A392:
	mov r0, #1
	pop {r4, r5, r6, pc}
_0208A396:
	bl sub_02070D94
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	add r6, r5, #0
	ldr r4, [r1]
	mul r6, r0
	add r0, r4, r6
	mov r1, #5
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _0208A3C6
	add r0, r4, r6
	mov r1, #0x4c
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _0208A3C6
	mov r0, #1
	pop {r4, r5, r6, pc}
_0208A3C6:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end sub_0208A310

	thumb_func_start sub_0208A3CC
sub_0208A3CC: ; 0x0208A3CC
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r0, r1]
	ldrb r1, [r1, #0x12]
	cmp r1, #3
	bne _0208A3DC
	mov r0, #0
	bx lr
_0208A3DC:
	ldr r1, _0208A3F0 ; =0x000007BC
	ldrsb r0, [r0, r1]
	cmp r0, #0
	beq _0208A3EC
	cmp r0, #3
	beq _0208A3EC
	mov r0, #0
	bx lr
_0208A3EC:
	mov r0, #1
	bx lr
	.balign 4, 0
_0208A3F0: .word 0x000007BC
	thumb_func_end sub_0208A3CC

	thumb_func_start sub_0208A3F4
sub_0208A3F4: ; 0x0208A3F4
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	str r1, [sp]
	ldr r1, [r5, r0]
	mov r0, #0x14
	ldrsb r4, [r1, r0]
_0208A404:
	ldr r0, [sp]
	add r0, r4, r0
	lsl r0, r0, #0x18
	asr r4, r0, #0x18
	bmi _0208A41A
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldrb r0, [r0, #0x13]
	cmp r4, r0
	blt _0208A420
_0208A41A:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0208A420:
	bl sub_02070D90
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	add r7, r4, #0
	ldr r6, [r1]
	mul r7, r0
	add r0, r6, r7
	mov r1, #5
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A404
	add r0, r6, r7
	mov r1, #0x4c
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A456
	add r0, r5, #0
	bl sub_0208A3CC
	cmp r0, #1
	bne _0208A404
_0208A456:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end sub_0208A3F4

	thumb_func_start sub_0208A45C
sub_0208A45C: ; 0x0208A45C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	add r7, r1, #0
	ldr r1, [r5, r0]
	mov r0, #0x14
	ldrsb r4, [r1, r0]
_0208A46C:
	add r0, r4, r7
	lsl r0, r0, #0x18
	asr r4, r0, #0x18
	bmi _0208A480
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	ldrb r0, [r1, #0x13]
	cmp r4, r0
	blt _0208A486
_0208A480:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0208A486:
	ldr r0, [r1]
	add r1, r4, #0
	bl Party_GetMonByIndex
	mov r1, #5
	mov r2, #0
	add r6, r0, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A46C
	add r0, r6, #0
	mov r1, #0x4c
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _0208A4B4
	add r0, r5, #0
	bl sub_0208A3CC
	cmp r0, #1
	bne _0208A46C
_0208A4B4:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end sub_0208A45C

	thumb_func_start sub_0208A4B8
sub_0208A4B8: ; 0x0208A4B8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	str r1, [sp]
	ldr r1, [r5, r0]
	mov r0, #0x14
	ldrsb r4, [r1, r0]
_0208A4C8:
	ldr r0, [sp]
	add r0, r4, r0
	lsl r0, r0, #0x18
	asr r4, r0, #0x18
	bmi _0208A4DE
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldrb r0, [r0, #0x13]
	cmp r4, r0
	blt _0208A4E4
_0208A4DE:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0208A4E4:
	bl sub_02070D94
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	add r7, r4, #0
	ldr r6, [r1]
	mul r7, r0
	add r0, r6, r7
	mov r1, #5
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _0208A4C8
	add r0, r6, r7
	mov r1, #0x4c
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _0208A51A
	add r0, r5, #0
	bl sub_0208A3CC
	cmp r0, #1
	bne _0208A4C8
_0208A51A:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end sub_0208A4B8

	thumb_func_start sub_0208A520
sub_0208A520: ; 0x0208A520
	push {r4, lr}
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r4, [r0, r1]
	ldrb r0, [r4, #0x11]
	cmp r0, #0
	beq _0208A538
	cmp r0, #1
	beq _0208A546
	cmp r0, #2
	beq _0208A550
	b _0208A55E
_0208A538:
	bl sub_02070D90
	ldrb r1, [r4, #0x14]
	ldr r2, [r4]
	mul r0, r1
	add r0, r2, r0
	pop {r4, pc}
_0208A546:
	ldrb r1, [r4, #0x14]
	ldr r0, [r4]
	bl Party_GetMonByIndex
	pop {r4, pc}
_0208A550:
	bl sub_02070D94
	ldrb r1, [r4, #0x14]
	ldr r2, [r4]
	mul r0, r1
	add r0, r2, r0
	pop {r4, pc}
_0208A55E:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_0208A520

	thumb_func_start sub_0208A564
sub_0208A564: ; 0x0208A564
	push {r4, lr}
	ldr r1, _0208A630 ; =0x000007BE
	add r4, r0, #0
	ldrb r1, [r4, r1]
	cmp r1, #0
	beq _0208A57A
	cmp r1, #1
	beq _0208A5B6
	cmp r1, #2
	beq _0208A5E2
	b _0208A62A
_0208A57A:
	ldr r0, _0208A634 ; =0x00000428
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _0208A634 ; =0x00000428
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetAnimCtrlSeq
	mov r2, #0
	ldr r0, [r4]
	mov r1, #5
	add r3, r2, #0
	bl ScheduleSetBgPosText
	ldr r0, [r4]
	mov r1, #5
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	add r0, r4, #0
	add r0, #0x44
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _0208A630 ; =0x000007BE
	mov r1, #1
	strb r1, [r4, r0]
	b _0208A62A
_0208A5B6:
	ldr r0, [r4]
	mov r1, #5
	bl Bg_GetXpos
	cmp r0, #0x80
	ldr r0, [r4]
	blt _0208A5D6
	mov r1, #5
	mov r2, #0
	mov r3, #0x80
	bl ScheduleSetBgPosText
	ldr r0, _0208A630 ; =0x000007BE
	mov r1, #2
	strb r1, [r4, r0]
	b _0208A62A
_0208A5D6:
	mov r1, #5
	mov r2, #1
	mov r3, #0x40
	bl ScheduleSetBgPosText
	b _0208A62A
_0208A5E2:
	bl sub_0208DB1C
	add r0, r4, #0
	bl sub_0208A79C
	mov r0, #0x43
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl thunk_Sprite_SetDrawFlag
	add r0, r4, #0
	bl sub_0208C068
	mov r0, #9
	lsl r0, r0, #6
	ldrb r1, [r4, r0]
	add r0, r0, #1
	ldrb r0, [r4, r0]
	cmp r1, r0
	beq _0208A616
	ldr r0, _0208A638 ; =0x00000434
	mov r1, #1
	ldr r0, [r4, r0]
	bl thunk_Sprite_SetDrawFlag
_0208A616:
	ldr r0, _0208A634 ; =0x00000428
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _0208A630 ; =0x000007BE
	mov r1, #0
	strb r1, [r4, r0]
	mov r0, #1
	pop {r4, pc}
_0208A62A:
	mov r0, #0
	pop {r4, pc}
	nop
_0208A630: .word 0x000007BE
_0208A634: .word 0x00000428
_0208A638: .word 0x00000434
	thumb_func_end sub_0208A564

	thumb_func_start sub_0208A63C
sub_0208A63C: ; 0x0208A63C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0208A70C ; =0x000007BE
	ldrb r0, [r4, r0]
	cmp r0, #0
	beq _0208A652
	cmp r0, #1
	beq _0208A69C
	cmp r0, #2
	beq _0208A6C8
	b _0208A706
_0208A652:
	mov r0, #0x43
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl thunk_Sprite_SetDrawFlag
	ldr r0, _0208A710 ; =0x00000434
	mov r1, #0
	ldr r0, [r4, r0]
	bl thunk_Sprite_SetDrawFlag
	ldr r0, _0208A714 ; =0x0000044C
	mov r1, #0
	ldr r0, [r4, r0]
	bl thunk_Sprite_SetDrawFlag
	mov r0, #0x45
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl thunk_Sprite_SetDrawFlag
	ldr r0, _0208A718 ; =0x00000428
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	bl sub_0208DB58
	add r0, r4, #0
	bl sub_0208DAD4
	ldr r0, _0208A70C ; =0x000007BE
	mov r1, #1
	strb r1, [r4, r0]
	b _0208A706
_0208A69C:
	ldr r0, [r4]
	mov r1, #5
	bl Bg_GetXpos
	cmp r0, #0x80
	ldr r0, [r4]
	bgt _0208A6BC
	mov r2, #0
	mov r1, #5
	add r3, r2, #0
	bl ScheduleSetBgPosText
	ldr r0, _0208A70C ; =0x000007BE
	mov r1, #2
	strb r1, [r4, r0]
	b _0208A706
_0208A6BC:
	mov r1, #5
	mov r2, #2
	mov r3, #0x40
	bl ScheduleSetBgPosText
	b _0208A706
_0208A6C8:
	mov r0, #0x81
	lsl r0, r0, #2
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	add r0, #0x64
	bl ScheduleWindowCopyToVram
	mov r0, #0x7d
	lsl r0, r0, #2
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	add r0, r4, #0
	add r0, #0x44
	bl ScheduleWindowCopyToVram
	ldr r0, _0208A718 ; =0x00000428
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	bl sub_0208B400
	ldr r0, _0208A70C ; =0x000007BE
	mov r1, #0
	strb r1, [r4, r0]
	mov r0, #1
	pop {r4, pc}
_0208A706:
	mov r0, #0
	pop {r4, pc}
	nop
_0208A70C: .word 0x000007BE
_0208A710: .word 0x00000434
_0208A714: .word 0x0000044C
_0208A718: .word 0x00000428
	thumb_func_end sub_0208A63C

	thumb_func_start sub_0208A71C
sub_0208A71C: ; 0x0208A71C
	push {r4, r5, r6, r7}
	add r5, r0, #0
	ldr r0, _0208A798 ; =0x000007BD
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1c
	lsr r4, r0, #0x1c
	lsl r0, r4, #0x18
	asr r2, r0, #0x18
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r3, [r5, r0]
	ldrb r0, [r3, #0x12]
	cmp r0, #2
	bne _0208A746
	ldrh r0, [r3, #0x18]
	cmp r0, #0
	beq _0208A742
	mov r3, #4
	b _0208A748
_0208A742:
	mov r3, #3
	b _0208A748
_0208A746:
	mov r3, #3
_0208A748:
	mov r6, #0x99
	mov r0, #0
	lsl r6, r6, #2
_0208A74E:
	add r2, r2, r1
	lsl r2, r2, #0x18
	asr r2, r2, #0x18
	bpl _0208A75A
	add r2, r3, #0
	b _0208A760
_0208A75A:
	cmp r2, r3
	ble _0208A760
	add r2, r0, #0
_0208A760:
	cmp r2, #4
	beq _0208A772
	lsl r7, r2, #1
	add r7, r5, r7
	ldrh r7, [r7, r6]
	cmp r7, #0
	bne _0208A772
	cmp r2, r4
	bne _0208A74E
_0208A772:
	cmp r2, r4
	beq _0208A790
	ldr r3, _0208A798 ; =0x000007BD
	mov r1, #0xf
	ldrb r0, [r5, r3]
	bic r0, r1
	lsl r1, r2, #0x18
	lsr r2, r1, #0x18
	mov r1, #0xf
	and r1, r2
	orr r0, r1
	strb r0, [r5, r3]
	mov r0, #1
	pop {r4, r5, r6, r7}
	bx lr
_0208A790:
	mov r0, #0
	pop {r4, r5, r6, r7}
	bx lr
	nop
_0208A798: .word 0x000007BD
	thumb_func_end sub_0208A71C

	thumb_func_start sub_0208A79C
sub_0208A79C: ; 0x0208A79C
	push {r4, lr}
	add r4, r0, #0
	bl sub_0208BBDC
	ldr r0, _0208A7F4 ; =0x000007BD
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1c
	lsr r1, r0, #0x1c
	cmp r1, #4
	bne _0208A7D0
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrh r1, [r0, #0x18]
	cmp r1, #0
	beq _0208A7C4
	add r0, r4, #0
	bl sub_0208A7F8
	pop {r4, pc}
_0208A7C4:
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl sub_0208A7F8
	pop {r4, pc}
_0208A7D0:
	cmp r1, #5
	bne _0208A7E0
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl sub_0208A7F8
	pop {r4, pc}
_0208A7E0:
	lsl r1, r1, #1
	add r2, r4, r1
	mov r1, #0x99
	lsl r1, r1, #2
	ldrh r1, [r2, r1]
	add r0, r4, #0
	bl sub_0208A7F8
	pop {r4, pc}
	nop
_0208A7F4: .word 0x000007BD
	thumb_func_end sub_0208A79C

	thumb_func_start sub_0208A7F8
sub_0208A7F8: ; 0x0208A7F8
	push {r3, r4, r5, lr}
	mov r2, #0
	add r4, r1, #0
	mvn r2, r2
	add r5, r0, #0
	cmp r4, r2
	bne _0208A816
	bl sub_0208DAD4
	ldr r0, _0208A830 ; =0x0000044C
	mov r1, #0
	ldr r0, [r5, r0]
	bl thunk_Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_0208A816:
	bl sub_0208D9A0
	add r0, r5, #0
	add r1, r4, #0
	bl sub_0208BB8C
	ldr r0, _0208A830 ; =0x0000044C
	mov r1, #1
	ldr r0, [r5, r0]
	bl thunk_Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	nop
_0208A830: .word 0x0000044C
	thumb_func_end sub_0208A7F8

	thumb_func_start sub_0208A834
sub_0208A834: ; 0x0208A834
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	bl sub_0208A520
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	ldrb r1, [r1, #0x11]
	cmp r1, #2
	ldr r1, _0208A8F0 ; =0x000007BD
	bne _0208A85A
	ldrb r2, [r4, r1]
	lsl r1, r2, #0x1c
	lsl r2, r2, #0x18
	lsr r1, r1, #0x1c
	lsr r2, r2, #0x1c
	bl BoxMonSwapMoves
	b _0208A868
_0208A85A:
	ldrb r2, [r4, r1]
	lsl r1, r2, #0x1c
	lsl r2, r2, #0x18
	lsr r1, r1, #0x1c
	lsr r2, r2, #0x1c
	bl MonSwapMoves
_0208A868:
	ldr r0, _0208A8F0 ; =0x000007BD
	mov r1, #0x99
	ldrb r6, [r4, r0]
	lsl r1, r1, #2
	add r5, r4, r1
	lsl r2, r6, #0x1c
	lsl r6, r6, #0x18
	lsr r6, r6, #0x1c
	lsl r6, r6, #1
	lsr r3, r2, #0x1b
	add r6, r4, r6
	ldrh r2, [r5, r3]
	ldrh r6, [r6, r1]
	strh r6, [r5, r3]
	ldrb r3, [r4, r0]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x1c
	lsl r3, r3, #1
	add r3, r4, r3
	strh r2, [r3, r1]
	add r2, r1, #0
	add r2, #8
	ldrb r6, [r4, r0]
	add r5, r4, r2
	lsl r2, r6, #0x1c
	lsl r6, r6, #0x18
	lsr r6, r6, #0x1c
	add r7, r4, r6
	add r6, r1, #0
	lsr r3, r2, #0x1c
	add r6, #8
	ldrb r2, [r5, r3]
	ldrb r6, [r7, r6]
	strb r6, [r5, r3]
	ldrb r3, [r4, r0]
	lsl r3, r3, #0x18
	lsr r3, r3, #0x1c
	add r5, r4, r3
	add r3, r1, #0
	add r3, #8
	strb r2, [r5, r3]
	add r2, r1, #0
	add r2, #0xc
	ldrb r6, [r4, r0]
	add r5, r4, r2
	lsl r2, r6, #0x1c
	lsl r6, r6, #0x18
	lsr r6, r6, #0x1c
	add r7, r4, r6
	add r6, r1, #0
	lsr r3, r2, #0x1c
	add r6, #0xc
	ldrb r2, [r5, r3]
	ldrb r6, [r7, r6]
	strb r6, [r5, r3]
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1c
	add r3, r4, r0
	add r0, r1, #0
	add r0, #0xc
	strb r2, [r3, r0]
	sub r1, #0x38
	ldr r0, [r4, r1]
	mov r2, #1
	str r2, [r0, #0x38]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0208A8F0: .word 0x000007BD
	thumb_func_end sub_0208A834

	thumb_func_start sub_0208A8F4
sub_0208A8F4: ; 0x0208A8F4
	push {r4, lr}
	add r4, r0, #0
	mov r2, #0
	ldr r0, [r4]
	mov r1, #2
	add r3, r2, #0
	bl ScheduleSetBgPosText
	add r0, r4, #0
	bl sub_0208DB1C
	add r0, r4, #0
	bl sub_0208A79C
	mov r0, #0x43
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl thunk_Sprite_SetDrawFlag
	add r0, r4, #0
	bl sub_0208C068
	mov r0, #9
	lsl r0, r0, #6
	ldrb r1, [r4, r0]
	add r0, r0, #1
	ldrb r0, [r4, r0]
	cmp r1, r0
	beq _0208A93A
	ldr r0, _0208A948 ; =0x00000434
	mov r1, #1
	ldr r0, [r4, r0]
	bl thunk_Sprite_SetDrawFlag
_0208A93A:
	ldr r0, _0208A94C ; =0x00000428
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	pop {r4, pc}
	nop
_0208A948: .word 0x00000434
_0208A94C: .word 0x00000428
	thumb_func_end sub_0208A8F4

	thumb_func_start sub_0208A950
sub_0208A950: ; 0x0208A950
	push {r4, lr}
	add r4, r0, #0
	bl sub_0208DB1C
	add r0, r4, #0
	bl sub_0208A79C
	add r0, r4, #0
	bl sub_0208C068
	ldr r0, _0208A9BC ; =0x000007BC
	ldrsb r0, [r4, r0]
	cmp r0, #1
	bne _0208A9A4
	add r0, r4, #0
	bl sub_0208C208
	mov r0, #0x43
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl thunk_Sprite_SetDrawFlag
	mov r0, #9
	lsl r0, r0, #6
	ldrb r1, [r4, r0]
	add r0, r0, #1
	ldrb r0, [r4, r0]
	cmp r1, r0
	beq _0208A996
	ldr r0, _0208A9C0 ; =0x00000434
	mov r1, #1
	ldr r0, [r4, r0]
	bl thunk_Sprite_SetDrawFlag
_0208A996:
	ldr r0, [r4]
	mov r1, #2
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	pop {r4, pc}
_0208A9A4:
	add r0, r4, #0
	bl sub_0208C0E8
	mov r2, #3
	add r3, r2, #0
	ldr r0, [r4]
	mov r1, #2
	add r3, #0xfd
	bl ScheduleSetBgPosText
	pop {r4, pc}
	nop
_0208A9BC: .word 0x000007BC
_0208A9C0: .word 0x00000434
	thumb_func_end sub_0208A950

	thumb_func_start sub_0208A9C4
sub_0208A9C4: ; 0x0208A9C4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0208AA8C ; =0x000007BE
	ldrb r0, [r4, r0]
	cmp r0, #0
	beq _0208A9DA
	cmp r0, #1
	beq _0208AA32
	cmp r0, #2
	beq _0208AA5E
	b _0208AA86
_0208A9DA:
	mov r2, #0
	ldr r0, [r4]
	mov r1, #5
	add r3, r2, #0
	bl ScheduleSetBgPosText
	ldr r0, [r4]
	mov r1, #5
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	ldr r0, _0208AA90 ; =0x00000428
	mov r1, #3
	ldr r0, [r4, r0]
	bl Sprite_SetPriority
	ldr r0, _0208AA90 ; =0x00000428
	mov r1, #0
	ldr r0, [r4, r0]
	bl thunk_Sprite_SetPaletteOverride
	mov r0, #0x75
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x5d
	lsl r0, r0, #2
	add r0, r4, r0
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ClearWindowTilemapAndScheduleTransfer
	ldr r0, _0208AA94 ; =0x000007C5
	mov r1, #0
	strb r1, [r4, r0]
	mov r1, #1
	sub r0, r0, #7
	strb r1, [r4, r0]
	b _0208AA86
_0208AA32:
	ldr r0, [r4]
	mov r1, #5
	bl Bg_GetYpos
	cmp r0, #0x48
	ldr r0, [r4]
	blt _0208AA52
	mov r1, #5
	mov r2, #3
	mov r3, #0x48
	bl ScheduleSetBgPosText
	ldr r0, _0208AA8C ; =0x000007BE
	mov r1, #2
	strb r1, [r4, r0]
	b _0208AA86
_0208AA52:
	mov r1, #5
	mov r2, #4
	mov r3, #0x24
	bl ScheduleSetBgPosText
	b _0208AA86
_0208AA5E:
	mov r0, #5
	lsl r0, r0, #8
	ldr r0, [r4, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, _0208AA98 ; =0x0000050C
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #0
	bl sub_0208AB58
	ldr r0, _0208AA8C ; =0x000007BE
	mov r1, #0
	strb r1, [r4, r0]
	mov r0, #1
	pop {r4, pc}
_0208AA86:
	mov r0, #0
	pop {r4, pc}
	nop
_0208AA8C: .word 0x000007BE
_0208AA90: .word 0x00000428
_0208AA94: .word 0x000007C5
_0208AA98: .word 0x0000050C
	thumb_func_end sub_0208A9C4

	thumb_func_start sub_0208AA9C
sub_0208AA9C: ; 0x0208AA9C
	push {r4, lr}
	ldr r1, _0208AB50 ; =0x000007BE
	add r4, r0, #0
	ldrb r0, [r4, r1]
	cmp r0, #0
	beq _0208AAB2
	cmp r0, #1
	beq _0208AAE2
	cmp r0, #2
	beq _0208AB0E
	b _0208AB4A
_0208AAB2:
	mov r2, #0
	add r0, r1, #6
	strb r2, [r4, r0]
	add r0, r1, #7
	strb r2, [r4, r0]
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r0, #0x10
	bl ClearWindowTilemapAndScheduleTransfer
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r0, #0x20
	bl ClearWindowTilemapAndScheduleTransfer
	add r0, r4, #0
	bl sub_0208C2A0
	ldr r0, _0208AB50 ; =0x000007BE
	mov r1, #1
	strb r1, [r4, r0]
	b _0208AB4A
_0208AAE2:
	ldr r0, [r4]
	mov r1, #5
	bl Bg_GetYpos
	cmp r0, #0
	ldr r0, [r4]
	bgt _0208AB02
	mov r1, #5
	mov r2, #3
	mov r3, #0
	bl ScheduleSetBgPosText
	ldr r0, _0208AB50 ; =0x000007BE
	mov r1, #2
	strb r1, [r4, r0]
	b _0208AB4A
_0208AB02:
	mov r1, #5
	add r2, r1, #0
	mov r3, #0x24
	bl ScheduleSetBgPosText
	b _0208AB4A
_0208AB0E:
	mov r0, #0x75
	lsl r0, r0, #2
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	mov r0, #0x5d
	lsl r0, r0, #2
	add r0, r4, r0
	bl ScheduleWindowCopyToVram
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ScheduleWindowCopyToVram
	ldr r0, _0208AB54 ; =0x00000428
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetPriority
	ldr r0, _0208AB54 ; =0x00000428
	mov r1, #2
	ldr r0, [r4, r0]
	bl thunk_Sprite_SetPaletteOverride
	ldr r0, _0208AB50 ; =0x000007BE
	mov r1, #0
	strb r1, [r4, r0]
	mov r0, #1
	pop {r4, pc}
_0208AB4A:
	mov r0, #0
	pop {r4, pc}
	nop
_0208AB50: .word 0x000007BE
_0208AB54: .word 0x00000428
	thumb_func_end sub_0208AA9C

	thumb_func_start sub_0208AB58
sub_0208AB58: ; 0x0208AB58
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _0208ACC4 ; =0x000007C4
	add r4, r1, #0
	add r1, r0, #1
	ldrb r7, [r5, r0]
	ldrb r6, [r5, r1]
	cmp r4, #1
	bne _0208AB80
	add r0, r7, #0
	mov r1, #3
	bl _s32_div_f
	cmp r1, #2
	beq _0208AB94
	ldr r0, _0208ACC4 ; =0x000007C4
	ldrb r1, [r5, r0]
	add r1, r1, #1
	strb r1, [r5, r0]
	b _0208AC34
_0208AB80:
	mov r2, #0
	mvn r2, r2
	cmp r4, r2
	bne _0208ABA0
	add r0, r7, #0
	mov r1, #3
	bl _s32_div_f
	cmp r1, #0
	bne _0208AB96
_0208AB94:
	b _0208ACC0
_0208AB96:
	ldr r0, _0208ACC4 ; =0x000007C4
	ldrb r1, [r5, r0]
	sub r1, r1, #1
	strb r1, [r5, r0]
	b _0208AC34
_0208ABA0:
	cmp r4, #3
	bne _0208ABD4
	cmp r7, #6
	blo _0208ABCE
	add r2, r6, #1
	lsl r1, r2, #3
	add r1, r2, r1
	add r2, r0, #2
	ldrb r2, [r5, r2]
	cmp r1, r2
	bge _0208AC34
	add r1, r0, #1
	ldrb r1, [r5, r1]
	add r2, r1, #1
	add r1, r0, #1
	strb r2, [r5, r1]
	ldrb r0, [r5, r0]
	mov r1, #3
	bl _s32_div_f
	ldr r0, _0208ACC4 ; =0x000007C4
	strb r1, [r5, r0]
	b _0208AC34
_0208ABCE:
	add r1, r7, #3
	strb r1, [r5, r0]
	b _0208AC34
_0208ABD4:
	sub r1, r2, #2
	cmp r4, r1
	bne _0208AC02
	cmp r7, #2
	bhi _0208ABFC
	cmp r6, #0
	beq _0208AC34
	add r1, r0, #1
	ldrb r1, [r5, r1]
	sub r2, r1, #1
	add r1, r0, #1
	strb r2, [r5, r1]
	ldrb r0, [r5, r0]
	mov r1, #3
	bl _s32_div_f
	ldr r0, _0208ACC4 ; =0x000007C4
	add r1, r1, #6
	strb r1, [r5, r0]
	b _0208AC34
_0208ABFC:
	sub r1, r7, #3
	strb r1, [r5, r0]
	b _0208AC34
_0208AC02:
	cmp r4, #9
	bne _0208AC20
	add r2, r6, #1
	lsl r1, r2, #3
	add r1, r2, r1
	add r2, r0, #2
	ldrb r2, [r5, r2]
	cmp r1, r2
	bge _0208AC34
	add r1, r0, #1
	ldrb r1, [r5, r1]
	add r0, r0, #1
	add r1, r1, #1
	strb r1, [r5, r0]
	b _0208AC34
_0208AC20:
	sub r2, #8
	cmp r4, r2
	bne _0208AC34
	cmp r6, #0
	beq _0208AC34
	add r1, r0, #1
	ldrb r1, [r5, r1]
	add r0, r0, #1
	sub r1, r1, #1
	strb r1, [r5, r0]
_0208AC34:
	ldr r0, _0208ACC4 ; =0x000007C4
	ldrb r1, [r5, r0]
	cmp r7, r1
	bne _0208AC44
	add r0, r0, #1
	ldrb r0, [r5, r0]
	cmp r6, r0
	beq _0208AC56
_0208AC44:
	cmp r4, #9
	beq _0208AC56
	mov r0, #8
	mvn r0, r0
	cmp r4, r0
	beq _0208AC56
	ldr r0, _0208ACC8 ; =0x000005DC
	bl PlaySE
_0208AC56:
	ldr r1, _0208ACC4 ; =0x000007C4
	add r0, r5, #0
	ldrb r1, [r5, r1]
	bl sub_0208ACDC
	ldr r1, _0208ACCC ; =0x000007C7
	strb r0, [r5, r1]
	add r0, r5, #0
	bl sub_0208C380
	ldr r0, _0208ACD0 ; =0x000007C5
	ldrb r0, [r5, r0]
	cmp r6, r0
	beq _0208AC78
	add r0, r5, #0
	bl sub_0208C320
_0208AC78:
	add r0, r5, #0
	bl sub_0208D7C4
	ldr r0, _0208ACD0 ; =0x000007C5
	ldrb r0, [r5, r0]
	cmp r0, #0
	ldr r0, _0208ACD4 ; =0x00000504
	beq _0208AC92
	ldr r0, [r5, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	b _0208AC9A
_0208AC92:
	ldr r0, [r5, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
_0208AC9A:
	ldr r0, _0208ACD0 ; =0x000007C5
	ldrb r1, [r5, r0]
	add r0, r0, #1
	ldrb r0, [r5, r0]
	add r2, r1, #1
	lsl r1, r2, #3
	add r1, r2, r1
	cmp r1, r0
	ldr r0, _0208ACD8 ; =0x00000508
	bge _0208ACB8
	ldr r0, [r5, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, r6, r7, pc}
_0208ACB8:
	ldr r0, [r5, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
_0208ACC0:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0208ACC4: .word 0x000007C4
_0208ACC8: .word 0x000005DC
_0208ACCC: .word 0x000007C7
_0208ACD0: .word 0x000007C5
_0208ACD4: .word 0x00000504
_0208ACD8: .word 0x00000508
	thumb_func_end sub_0208AB58

	thumb_func_start sub_0208ACDC
sub_0208ACDC: ; 0x0208ACDC
	push {r4, r5, r6, r7}
	ldr r2, _0208AD30 ; =0x000007C5
	mov r6, #0
	ldrb r3, [r0, r2]
	add r4, r6, #0
	lsl r2, r3, #3
	add r2, r3, r2
	add r1, r1, r2
	lsl r1, r1, #0x18
	lsr r5, r1, #0x18
	mov r1, #0xa1
	mov r2, #1
	lsl r1, r1, #2
_0208ACF6:
	mov r3, #0x1f
	add r7, r4, #0
	and r7, r3
	add r3, r2, #0
	lsl r3, r7
	lsr r7, r4, #5
	lsl r7, r7, #2
	add r7, r0, r7
	ldr r7, [r7, r1]
	tst r3, r7
	beq _0208AD1E
	cmp r5, r6
	bne _0208AD18
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	pop {r4, r5, r6, r7}
	bx lr
_0208AD18:
	add r3, r6, #1
	lsl r3, r3, #0x18
	lsr r6, r3, #0x18
_0208AD1E:
	add r3, r4, #1
	lsl r3, r3, #0x10
	lsr r4, r3, #0x10
	cmp r4, #0x50
	blo _0208ACF6
	mov r0, #0
	pop {r4, r5, r6, r7}
	bx lr
	nop
_0208AD30: .word 0x000007C5
	thumb_func_end sub_0208ACDC

	thumb_func_start sub_0208AD34
sub_0208AD34: ; 0x0208AD34
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	bl PlayerProfile_GetNamePtr
	str r0, [r5, #8]
	add r0, r4, #0
	bl PlayerProfile_GetTrainerID
	str r0, [r5, #0xc]
	add r0, r4, #0
	bl PlayerProfile_GetTrainerGender
	strb r0, [r5, #0x10]
	pop {r3, r4, r5, pc}
	thumb_func_end sub_0208AD34

	thumb_func_start sub_0208AD54
sub_0208AD54: ; 0x0208AD54
	mov r0, #0x40
	bx lr
	thumb_func_end sub_0208AD54

	thumb_func_start sub_0208AD58
sub_0208AD58: ; 0x0208AD58
	mov r0, #0x41
	bx lr
	thumb_func_end sub_0208AD58

	thumb_func_start sub_0208AD5C
sub_0208AD5C: ; 0x0208AD5C
	mov r0, #0x3f
	bx lr
	thumb_func_end sub_0208AD5C

	thumb_func_start sub_0208AD60
sub_0208AD60: ; 0x0208AD60
	mov r0, #0x3e
	bx lr
	thumb_func_end sub_0208AD60

	thumb_func_start Pokemon_GetStatusIconId
Pokemon_GetStatusIconId: ; 0x0208AD64
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r1, #MON_DATA_STATUS
	mov r2, #0
	bl GetMonData
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #MON_DATA_HP
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	bne _0208AD84
	mov r0, #6
	pop {r3, r4, r5, pc}
_0208AD84:
	mov r0, #MON_STATUS_PSN_MASK|MON_STATUS_TOX_MASK
	tst r0, r4
	beq _0208AD8E
	mov r0, #4
	pop {r3, r4, r5, pc}
_0208AD8E:
	mov r0, #MON_STATUS_SLP_MASK
	add r1, r4, #0
	tst r1, r0
	beq _0208AD9A
	mov r0, #3
	pop {r3, r4, r5, pc}
_0208AD9A:
	mov r1, #MON_STATUS_BRN_MASK
	tst r1, r4
	beq _0208ADA4
	mov r0, #5
	pop {r3, r4, r5, pc}
_0208ADA4:
	mov r1, #MON_STATUS_FRZ_MASK
	tst r1, r4
	beq _0208ADAE
	mov r0, #2
	pop {r3, r4, r5, pc}
_0208ADAE:
	mov r1, #MON_STATUS_PRZ_MASK
	tst r1, r4
	beq _0208ADB6
	mov r0, #1
_0208ADB6:
	pop {r3, r4, r5, pc}
	thumb_func_end Pokemon_GetStatusIconId

	thumb_func_start sub_0208ADB8
sub_0208ADB8: ; 0x0208ADB8
	push {r3, lr}
	mov r2, #0x8b
	lsl r2, r2, #2
	ldr r0, [r0, r2]
	ldr r0, [r0, #0x30]
	cmp r0, #0
	beq _0208ADCA
	bl MenuInputStateMgr_SetState
_0208ADCA:
	pop {r3, pc}
	thumb_func_end sub_0208ADB8

	thumb_func_start sub_0208ADCC
sub_0208ADCC: ; 0x0208ADCC
	ldr r3, _0208ADD4 ; =TouchscreenHitbox_FindRectAtTouchNew
	ldr r0, _0208ADD8 ; =_021038D4
	bx r3
	nop
_0208ADD4: .word TouchscreenHitbox_FindRectAtTouchNew
_0208ADD8: .word _021038D4
	thumb_func_end sub_0208ADCC

	thumb_func_start sub_0208ADDC
sub_0208ADDC: ; 0x0208ADDC
	push {r3, lr}
	ldr r0, _0208AE00 ; =_021038D4
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _0208ADFE
	ldr r0, _0208AE04 ; =_021038AC
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _0208ADFA
	mov r0, #4
	pop {r3, pc}
_0208ADFA:
	mov r0, #0
	mvn r0, r0
_0208ADFE:
	pop {r3, pc}
	.balign 4, 0
_0208AE00: .word _021038D4
_0208AE04: .word _021038AC
	thumb_func_end sub_0208ADDC

	thumb_func_start sub_0208AE08
sub_0208AE08: ; 0x0208AE08
	push {r3, lr}
	ldr r0, _0208AE3C ; =_021038D4
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _0208AE38
	ldr r0, _0208AE40 ; =_021038B0
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _0208AE26
	mov r0, #4
	pop {r3, pc}
_0208AE26:
	ldr r0, _0208AE44 ; =_021038AC
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _0208AE34
	mov r0, #5
	pop {r3, pc}
_0208AE34:
	mov r0, #0
	mvn r0, r0
_0208AE38:
	pop {r3, pc}
	nop
_0208AE3C: .word _021038D4
_0208AE40: .word _021038B0
_0208AE44: .word _021038AC
	thumb_func_end sub_0208AE08

	thumb_func_start sub_0208AE48
sub_0208AE48: ; 0x0208AE48
	push {r3, lr}
	ldr r0, _0208AE7C ; =_021038D4
	bl TouchscreenHitbox_FindRectAtTouchNew
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	bne _0208AE78
	ldr r0, _0208AE80 ; =_021038B4
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _0208AE66
	mov r0, #4
	pop {r3, pc}
_0208AE66:
	ldr r0, _0208AE84 ; =_021038AC
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _0208AE74
	mov r0, #5
	pop {r3, pc}
_0208AE74:
	mov r0, #0
	mvn r0, r0
_0208AE78:
	pop {r3, pc}
	nop
_0208AE7C: .word _021038D4
_0208AE80: .word _021038B4
_0208AE84: .word _021038AC
	thumb_func_end sub_0208AE48

	thumb_func_start sub_0208AE88
sub_0208AE88: ; 0x0208AE88
	push {r3, lr}
	ldr r0, _0208AEAC ; =_021038B4
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _0208AE98
	mov r0, #0
	pop {r3, pc}
_0208AE98:
	ldr r0, _0208AEB0 ; =_021038AC
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #1
	bne _0208AEA6
	mov r0, #1
	pop {r3, pc}
_0208AEA6:
	mov r0, #0
	mvn r0, r0
	pop {r3, pc}
	.balign 4, 0
_0208AEAC: .word _021038B4
_0208AEB0: .word _021038AC
	thumb_func_end sub_0208AE88

	thumb_func_start sub_0208AEB4
sub_0208AEB4: ; 0x0208AEB4
	ldr r3, _0208AEBC ; =TouchscreenHitbox_FindRectAtTouchNew
	ldr r0, _0208AEC0 ; =_021038B8
	bx r3
	nop
_0208AEBC: .word TouchscreenHitbox_FindRectAtTouchNew
_0208AEC0: .word _021038B8
	thumb_func_end sub_0208AEB4

	thumb_func_start sub_0208AEC4
sub_0208AEC4: ; 0x0208AEC4
	ldr r3, _0208AECC ; =TouchscreenHitbox_FindRectAtTouchNew
	ldr r0, _0208AED0 ; =_021039E8
	bx r3
	nop
_0208AECC: .word TouchscreenHitbox_FindRectAtTouchNew
_0208AED0: .word _021039E8
	thumb_func_end sub_0208AEC4

	thumb_func_start sub_0208AED4
sub_0208AED4: ; 0x0208AED4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0208AF00 ; =0x00000428
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetAnimCtrlSeq
	ldr r0, _0208AF04 ; =0x0000042C
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	bl sub_0208BCB4
	add r0, r4, #0
	mov r1, #1
	bl sub_0208AF08
	mov r0, #9
	pop {r4, pc}
	nop
_0208AF00: .word 0x00000428
_0208AF04: .word 0x0000042C
	thumb_func_end sub_0208AED4

	thumb_func_start sub_0208AF08
sub_0208AF08: ; 0x0208AF08
	push {r4, lr}
	add r4, r0, #0
	cmp r1, #1
	bne _0208AF34
	mov r0, #0x7d
	lsl r0, r0, #4
	mov r1, #0
	ldr r0, [r4, r0]
	add r2, r1, #0
	mov r3, #0x12
	bl sub_020196E8
	ldr r0, _0208AF6C ; =0x00000448
	mov r1, #0
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #1
	bl sub_0208DC68
	pop {r4, pc}
_0208AF34:
	mov r1, #0x8b
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	ldrh r1, [r1, #0x18]
	cmp r1, #0
	beq _0208AF5C
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	mov r2, #0
	mov r3, #0x12
	bl sub_020196E8
	ldr r0, _0208AF6C ; =0x00000448
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	b _0208AF60
_0208AF5C:
	bl sub_0208AF70
_0208AF60:
	add r0, r4, #0
	mov r1, #0
	bl sub_0208DC68
	pop {r4, pc}
	nop
_0208AF6C: .word 0x00000448
	thumb_func_end sub_0208AF08

	thumb_func_start sub_0208AF70
sub_0208AF70: ; 0x0208AF70
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x12
	str r0, [sp]
	mov r0, #0x11
	str r0, [sp, #4]
	mov r1, #6
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	ldr r0, [r4]
	ldr r2, _0208AF9C ; =0x00003006
	mov r3, #0
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x10
	pop {r4, pc}
	nop
_0208AF9C: .word 0x00003006
	thumb_func_end sub_0208AF70

	thumb_func_start sub_0208AFA0
sub_0208AFA0: ; 0x0208AFA0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x8b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0x12]
	cmp r0, #1
	beq _0208AFE6
	cmp r1, #1
	bne _0208AFCE
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #2
	mov r2, #1
	mov r3, #0x10
	bl sub_020196E8
	add r0, r4, #0
	mov r1, #1
	bl sub_0208DD20
	pop {r4, pc}
_0208AFCE:
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #3
	mov r2, #1
	mov r3, #0x10
	bl sub_020196E8
	add r0, r4, #0
	mov r1, #0
	bl sub_0208DD20
_0208AFE6:
	pop {r4, pc}
	thumb_func_end sub_0208AFA0

	thumb_func_start sub_0208AFE8
sub_0208AFE8: ; 0x0208AFE8
	push {r3, r4, r5, r6}
	ldr r5, _0208B040 ; =0x000007C8
	add r4, r0, #0
	strb r2, [r4, r5]
	add r0, r5, #1
	strb r3, [r4, r0]
	add r2, sp, #0
	ldrb r3, [r2, #0x10]
	add r0, r5, #2
	strb r3, [r4, r0]
	ldrb r3, [r2, #0x14]
	add r0, r5, #3
	strb r3, [r4, r0]
	add r0, r5, #4
	ldrb r3, [r4, r0]
	mov r0, #0xf
	ldrb r6, [r2, #0x18]
	bic r3, r0
	mov r0, #0xf
	and r6, r0
	orr r6, r3
	add r3, r5, #4
	strb r6, [r4, r3]
	ldrb r2, [r2, #0x1c]
	ldrb r3, [r4, r3]
	mov r6, #0xf0
	lsl r2, r2, #0x1c
	bic r3, r6
	lsr r2, r2, #0x18
	orr r3, r2
	add r2, r5, #4
	strb r3, [r4, r2]
	add r2, r5, #5
	strb r1, [r4, r2]
	mov r2, #0
	add r1, r5, #6
	strb r2, [r4, r1]
	add r1, sp, #0x20
	ldrb r2, [r1]
	add r1, r5, #7
	strb r2, [r4, r1]
	pop {r3, r4, r5, r6}
	bx lr
	nop
_0208B040: .word 0x000007C8
	thumb_func_end sub_0208AFE8

	thumb_func_start sub_0208B044
sub_0208B044: ; 0x0208B044
	push {lr}
	sub sp, #0x14
	mov r2, #9
	str r2, [sp]
	mov r2, #4
	str r2, [sp, #4]
	mov r2, #1
	str r2, [sp, #8]
	mov r2, #0
	str r2, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #6
	mov r2, #0x17
	mov r3, #0x14
	bl sub_0208AFE8
	add sp, #0x14
	pop {pc}
	thumb_func_end sub_0208B044

	thumb_func_start sub_0208B068
sub_0208B068: ; 0x0208B068
	push {lr}
	sub sp, #0x14
	mov r2, #0xf
	str r2, [sp]
	mov r2, #4
	str r2, [sp, #4]
	mov r2, #1
	str r2, [sp, #8]
	mov r3, #0
	str r3, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #6
	mov r3, #0x13
	bl sub_0208AFE8
	add sp, #0x14
	pop {pc}
	.balign 4, 0
	thumb_func_end sub_0208B068

	thumb_func_start sub_0208B08C
sub_0208B08C: ; 0x0208B08C
	push {lr}
	sub sp, #0x14
	mov r2, #0xa
	str r2, [sp]
	mov r2, #2
	str r2, [sp, #4]
	mov r2, #1
	str r2, [sp, #8]
	mov r3, #0
	str r3, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #6
	mov r3, #0x11
	bl sub_0208AFE8
	add sp, #0x14
	pop {pc}
	.balign 4, 0
	thumb_func_end sub_0208B08C

	thumb_func_start sub_0208B0B0
sub_0208B0B0: ; 0x0208B0B0
	push {lr}
	sub sp, #0x14
	cmp r1, #0
	bne _0208B0D6
	mov r1, #6
	str r1, [sp]
	mov r3, #3
	str r3, [sp, #4]
	mov r3, #1
	str r3, [sp, #8]
	mov r3, #0
	str r3, [sp, #0xc]
	str r2, [sp, #0x10]
	mov r2, #0x18
	mov r3, #5
	bl sub_0208AFE8
	add sp, #0x14
	pop {pc}
_0208B0D6:
	mov r1, #6
	str r1, [sp]
	mov r3, #3
	str r3, [sp, #4]
	mov r3, #1
	str r3, [sp, #8]
	mov r3, #0
	str r3, [sp, #0xc]
	str r2, [sp, #0x10]
	mov r2, #0x18
	mov r3, #0xd
	bl sub_0208AFE8
	add sp, #0x14
	pop {pc}
	thumb_func_end sub_0208B0B0

	thumb_func_start sub_0208B0F4
sub_0208B0F4: ; 0x0208B0F4
	push {lr}
	sub sp, #0x14
	mov r2, #6
	str r2, [sp]
	mov r2, #4
	str r2, [sp, #4]
	mov r2, #1
	str r2, [sp, #8]
	mov r2, #0
	str r2, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #5
	mov r2, #0x1a
	mov r3, #0x1d
	bl sub_0208AFE8
	add sp, #0x14
	pop {pc}
	thumb_func_end sub_0208B0F4

	thumb_func_start sub_0208B118
sub_0208B118: ; 0x0208B118
	push {r4, lr}
	sub sp, #0x10
	mov r1, #0
	mvn r1, r1
	add r4, r0, #0
	bl sub_0208A2E0
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _0208B140
	mov r0, #0x7d
	lsl r0, r0, #4
	mov r1, #5
	ldr r0, [r4, r0]
	mov r2, #0x18
	add r3, r1, #0
	bl sub_020196E8
	b _0208B162
_0208B140:
	mov r0, #5
	str r0, [sp]
	mov r1, #6
	str r1, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r2, #1
	mov r3, #0x18
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
_0208B162:
	add r0, r4, #0
	mov r1, #1
	bl sub_0208A2E0
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _0208B186
	mov r0, #0x7d
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #6
	mov r2, #0x18
	mov r3, #0xd
	bl sub_020196E8
	add sp, #0x10
	pop {r4, pc}
_0208B186:
	mov r0, #0xd
	str r0, [sp]
	mov r1, #6
	str r1, [sp, #4]
	mov r0, #3
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r2, #1
	mov r3, #0x18
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x10
	pop {r4, pc}
	thumb_func_end sub_0208B118

	.rodata

_021038AC:
	.byte 0xA5, 0xBC, 0xBE, 0xF9
_021038B0:
	.byte 0x88, 0x97, 0x08, 0x57
_021038B4:
	.byte 0x98, 0xB7, 0x08, 0x7F
_021038B8:
	.byte 0x28, 0x3F, 0xC0, 0xEF, 0x68, 0x7F, 0xC0, 0xEF
	.byte 0xFF, 0x00, 0x00, 0x00
_021038C4:
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00
_021038D4:
	.byte 0x08, 0x27, 0x08, 0x7F, 0x28, 0x47, 0x08, 0x7F, 0x48, 0x67, 0x08, 0x7F
	.byte 0x68, 0x87, 0x08, 0x7F, 0xFF, 0x00, 0x00, 0x00
_021038E8:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x04, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
_02103904:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x1B, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02103920:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1A, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_0210393C:
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x04
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02103958:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x1B, 0x02, 0x00, 0x02, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
_02103974:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1A, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02103990:
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00
_021039B8:
	.word 13, 12, 14
	.word 19, 17, 18
	.word 10, 9, 9
	.word 13, 12, 12
_021039E8:
	.byte 0x08, 0x27, 0x10, 0x2F, 0x08, 0x27, 0x30, 0x4F
	.byte 0x08, 0x27, 0x50, 0x70, 0x30, 0x4F, 0x10, 0x2F, 0x30, 0x4F, 0x30, 0x4F, 0x30, 0x4F, 0x50, 0x70
	.byte 0x58, 0x77, 0x10, 0x2F, 0x58, 0x77, 0x30, 0x4F, 0x58, 0x77, 0x50, 0x70, 0x0C, 0x33, 0x74, 0x8B
	.byte 0x4C, 0x73, 0x74, 0x8B, 0xB0, 0xBF, 0xD0, 0xFF, 0xFF, 0x00, 0x00, 0x00

	; File boundary

	.public gOverlayTemplate_PokemonSummary
gOverlayTemplate_PokemonSummary:
	.word PokemonSummary_Init, PokemonSummary_Main, PokemonSummary_Exit, 0xFFFFFFFF
