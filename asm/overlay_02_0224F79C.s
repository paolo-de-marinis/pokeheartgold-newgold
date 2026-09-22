#include "constants/abilities.h"
#include "constants/species.h"
#include "constants/sndseq.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/std_script.h"
	.include "asm/macros.inc"
	.include "overlay_02.inc"
	.include "global.inc"

.public ov02_0224C05C
.public ov02_0224C0B0
.public ov02_0224C14C
.public ov02_0224C1B8
.public ov02_0224C234
.public ov02_0224C2A8
.public ov02_0224C2EC
.public ov02_0224C338
.public ov02_0224C4B4
.public ov02_0224C4D8
.public ov02_0224C680
.public ov02_0224C698
.public ov02_0224C6DC
.public ov02_0224C71C
.public ov02_0224C75C
.public ov02_0224C7D4
.public ov02_0224C840
.public ov02_0224C87C
.public ov02_0224C8D0
.public ov02_0224C93C
.public ov02_0224C9B8
.public ov02_0224CA38
.public ov02_0224D1E4
.public ov02_0224D22C
.public ov02_0224D278
.public ov02_0224D288
.public ov02_0224D2BC
.public ov02_0224D2C8
.public ov02_0224D2DC
.public ov02_0224D2F0
.public ov02_0224D2F8
.public ov02_0224D310
.public ov02_0224D358
.public ov02_0224D3A4
.public ov02_0224D3B4
.public ov02_0224D3E8
.public ov02_0224D3F4
.public ov02_0224D408
.public ov02_0224D41C
.public ov02_0224D424
.public ov02_0224D43C
.public ov02_0224D468
.public ov02_0224D488
.public ov02_0224D580
.public ov02_0224D5B4
.public ov02_0224D648
.public ov02_0224D658
.public ov02_0224D670
.public ov02_0224D880
.public ov02_0224D914
.public ov02_0224D950
.public ov02_0224D98C
.public ov02_0224D9C0
.public ov02_0224DAA4
.public ov02_0224DB8C
.public ov02_0224DB9C
.public ov02_0224DC58
.public ov02_0224DC64
.public ov02_0224DC78
.public ov02_0224DC8C
.public ov02_0224DC94
.public ov02_0224DCB0
.public ov02_0224DD38
.public ov02_0224DD4C
.public ov02_0224DD8C
.public ov02_0224DDC8
.public ov02_0224EF94
	.text


	thumb_func_start ov02_0224F79C
ov02_0224F79C: ; 0x0224F79C
	push {r3, lr}
	cmp r0, #0x11
	bhi _0224F816
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224F7AE: ; jump table
	.short _0224F7D2 - _0224F7AE - 2 ; case 0
	.short _0224F7D6 - _0224F7AE - 2 ; case 1
	.short _0224F7DA - _0224F7AE - 2 ; case 2
	.short _0224F7DE - _0224F7AE - 2 ; case 3
	.short _0224F7E2 - _0224F7AE - 2 ; case 4
	.short _0224F7E6 - _0224F7AE - 2 ; case 5
	.short _0224F7EA - _0224F7AE - 2 ; case 6
	.short _0224F7EE - _0224F7AE - 2 ; case 7
	.short _0224F7F2 - _0224F7AE - 2 ; case 8
	.short _0224F816 - _0224F7AE - 2 ; case 9
	.short _0224F7F6 - _0224F7AE - 2 ; case 10
	.short _0224F7FA - _0224F7AE - 2 ; case 11
	.short _0224F7FE - _0224F7AE - 2 ; case 12
	.short _0224F802 - _0224F7AE - 2 ; case 13
	.short _0224F806 - _0224F7AE - 2 ; case 14
	.short _0224F80A - _0224F7AE - 2 ; case 15
	.short _0224F80E - _0224F7AE - 2 ; case 16
	.short _0224F812 - _0224F7AE - 2 ; case 17
_0224F7D2:
	mov r0, #1
	pop {r3, pc}
_0224F7D6:
	mov r0, #7
	pop {r3, pc}
_0224F7DA:
	mov r0, #0xa
	pop {r3, pc}
_0224F7DE:
	mov r0, #8
	pop {r3, pc}
_0224F7E2:
	mov r0, #9
	pop {r3, pc}
_0224F7E6:
	mov r0, #0xd
	pop {r3, pc}
_0224F7EA:
	mov r0, #0xc
	pop {r3, pc}
_0224F7EE:
	mov r0, #0xe
	pop {r3, pc}
_0224F7F2:
	mov r0, #0x11
	pop {r3, pc}
_0224F7F6:
	mov r0, #2
	pop {r3, pc}
_0224F7FA:
	mov r0, #3
	pop {r3, pc}
_0224F7FE:
	mov r0, #5
	pop {r3, pc}
_0224F802:
	mov r0, #4
	pop {r3, pc}
_0224F806:
	mov r0, #0xb
	pop {r3, pc}
_0224F80A:
	mov r0, #6
	pop {r3, pc}
_0224F80E:
	mov r0, #0xf
	pop {r3, pc}
_0224F812:
	mov r0, #0x10
	pop {r3, pc}
_0224F816:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F79C

	thumb_func_start ov02_0224F820
ov02_0224F820: ; 0x0224F820
	push {r3, lr}
	cmp r0, #6
	bhi _0224F85C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224F832: ; jump table
	.short _0224F840 - _0224F832 - 2 ; case 0
	.short _0224F844 - _0224F832 - 2 ; case 1
	.short _0224F848 - _0224F832 - 2 ; case 2
	.short _0224F84C - _0224F832 - 2 ; case 3
	.short _0224F850 - _0224F832 - 2 ; case 4
	.short _0224F854 - _0224F832 - 2 ; case 5
	.short _0224F858 - _0224F832 - 2 ; case 6
_0224F840:
	mov r0, #4
	pop {r3, pc}
_0224F844:
	mov r0, #2
	pop {r3, pc}
_0224F848:
	mov r0, #1
	pop {r3, pc}
_0224F84C:
	mov r0, #7
	pop {r3, pc}
_0224F850:
	mov r0, #6
	pop {r3, pc}
_0224F854:
	mov r0, #5
	pop {r3, pc}
_0224F858:
	mov r0, #3
	pop {r3, pc}
_0224F85C:
	bl GF_AssertFail
	mov r0, #8
	pop {r3, pc}
	thumb_func_end ov02_0224F820

	thumb_func_start ov02_0224F864
ov02_0224F864: ; 0x0224F864
	push {r4, lr}
	ldr r1, _0224F87C ; =0x00000884
	bl Heap_Alloc
	ldr r2, _0224F87C ; =0x00000884
	mov r1, #0
	add r4, r0, #0
	bl MI_CpuFill8
	add r0, r4, #0
	pop {r4, pc}
	nop
_0224F87C: .word 0x00000884
	thumb_func_end ov02_0224F864

	thumb_func_start ov02_0224F880
ov02_0224F880: ; 0x0224F880
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r2, r1, #0
	ldr r0, _0224F8E4 ; =0x000007E4
	mov r1, #0xdf
	add r0, r4, r0
	sub r2, r2, #1
	bl ReadWholeNarcMemberByIdPair
	ldr r0, _0224F8E8 ; =0x00000868
	mov r1, #0
	strb r1, [r4, r0]
	add r2, r0, #1
	strb r1, [r4, r2]
	add r2, r0, #3
	strb r1, [r4, r2]
	add r2, r0, #4
	ldrb r3, [r4, r2]
	mov r2, #0xf
	add r5, r4, #0
	bic r3, r2
	add r2, r0, #4
	strb r3, [r4, r2]
	add r2, r0, #2
	strb r1, [r4, r2]
	add r2, r0, #5
	strb r1, [r4, r2]
	add r0, r0, #6
	strh r1, [r4, r0]
	ldr r0, _0224F8E4 ; =0x000007E4
	ldr r2, _0224F8EC ; =0x0000FFFF
_0224F8BE:
	ldrh r3, [r5, r0]
	cmp r3, r2
	beq _0224F8CC
	add r1, r1, #1
	add r5, #8
	cmp r1, #5
	blt _0224F8BE
_0224F8CC:
	ldr r3, _0224F8F0 ; =0x0000086C
	lsl r1, r1, #0x18
	ldrb r0, [r4, r3]
	lsr r1, r1, #0x18
	mov r2, #0xf0
	lsl r1, r1, #0x1c
	bic r0, r2
	lsr r1, r1, #0x18
	orr r0, r1
	strb r0, [r4, r3]
	pop {r3, r4, r5, pc}
	nop
_0224F8E4: .word 0x000007E4
_0224F8E8: .word 0x00000868
_0224F8EC: .word 0x0000FFFF
_0224F8F0: .word 0x0000086C
	thumb_func_end ov02_0224F880

	thumb_func_start ov02_0224F8F4
ov02_0224F8F4: ; 0x0224F8F4
	ldr r3, _0224F8F8 ; =Heap_Free
	bx r3
	.balign 4, 0
_0224F8F8: .word Heap_Free
	thumb_func_end ov02_0224F8F4

	thumb_func_start ov02_0224F8FC
ov02_0224F8FC: ; 0x0224F8FC
	push {r3, r4, r5, r6, r7, lr}
	ldr r2, _0224FB2C ; =0x0000086C
	add r4, r1, #0
	ldrb r3, [r4, r2]
	add r5, r0, #0
	lsl r2, r3, #0x1c
	lsr r2, r2, #0x1c
	mov ip, r2
	cmp r2, #5
	blo _0224F93E
	bl ov02_02250504
	ldr r1, _0224FB30 ; =0x0000080C
	ldr r0, [r4, r1]
	cmp r0, #0
	beq _0224F920
	mov r0, #2
	pop {r3, r4, r5, r6, r7, pc}
_0224F920:
	add r0, r1, #0
	add r0, #0xa
	ldrb r0, [r4, r0]
	cmp r0, #0
	beq _0224F92E
	mov r0, #3
	pop {r3, r4, r5, r6, r7, pc}
_0224F92E:
	add r1, #0xb
	ldrb r0, [r4, r1]
	cmp r0, #0
	beq _0224F93A
	mov r0, #4
	pop {r3, r4, r5, r6, r7, pc}
_0224F93A:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0224F93E:
	ldr r2, _0224FB2C ; =0x0000086C
	sub r2, #0x88
	add r7, r4, r2
	mov r2, ip
	lsl r2, r2, #3
	add r6, r7, r2
	ldrh r7, [r7, r2]
	ldr r2, _0224FB34 ; =0x0000FFFF
	cmp r7, r2
	bne _0224F980
	bl ov02_02250504
	ldr r1, _0224FB30 ; =0x0000080C
	ldr r0, [r4, r1]
	cmp r0, #0
	beq _0224F962
	mov r0, #2
	pop {r3, r4, r5, r6, r7, pc}
_0224F962:
	add r0, r1, #0
	add r0, #0xa
	ldrb r0, [r4, r0]
	cmp r0, #0
	beq _0224F970
	mov r0, #3
	pop {r3, r4, r5, r6, r7, pc}
_0224F970:
	add r1, #0xb
	ldrb r0, [r4, r1]
	cmp r0, #0
	beq _0224F97C
	mov r0, #4
	pop {r3, r4, r5, r6, r7, pc}
_0224F97C:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0224F980:
	ldr r2, _0224FB2C ; =0x0000086C
	sub r2, r2, #3
	ldrb r2, [r4, r2]
	cmp r2, #7
	bls _0224F98C
	b _0224FB28
_0224F98C:
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_0224F998: ; jump table
	.short _0224F9A8 - _0224F998 - 2 ; case 0
	.short _0224F9CA - _0224F998 - 2 ; case 1
	.short _0224F9E8 - _0224F998 - 2 ; case 2
	.short _0224FA06 - _0224F998 - 2 ; case 3
	.short _0224FA1A - _0224F998 - 2 ; case 4
	.short _0224FA3E - _0224F998 - 2 ; case 5
	.short _0224FA50 - _0224F998 - 2 ; case 6
	.short _0224FAEE - _0224F998 - 2 ; case 7
_0224F9A8:
	add r0, r4, #0
	add r1, r6, #0
	bl ov02_0224FB44
	cmp r0, #0
	beq _0224F9CA
	add r5, #0xe4
	ldr r0, [r5]
	bl MapObject_UnpauseMovement
	ldr r0, _0224FB38 ; =0x00000868
	mov r1, #0
	strb r1, [r4, r0]
	mov r1, #5
	add r0, r0, #1
	strb r1, [r4, r0]
	b _0224FB28
_0224F9CA:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov02_0224FB54
	cmp r0, #0
	beq _0224F9E8
	add r5, #0xe4
	ldr r0, [r5]
	bl MapObject_UnpauseMovement
	ldr r0, _0224FB3C ; =0x00000869
	mov r1, #2
	strb r1, [r4, r0]
	b _0224FB28
_0224F9E8:
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl FollowMon_TryPrintInteractionMessage
	cmp r0, #0
	beq _0224FA06
	add r5, #0xe4
	ldr r0, [r5]
	bl MapObject_PauseMovement
	ldr r0, _0224FB3C ; =0x00000869
	mov r1, #6
	strb r1, [r4, r0]
	b _0224FB28
_0224FA06:
	add r0, r4, #0
	add r1, r6, #0
	bl ov02_0224FC74
	cmp r0, #0
	beq _0224FA1A
	ldr r0, _0224FB3C ; =0x00000869
	mov r1, #7
	strb r1, [r4, r0]
	b _0224FB28
_0224FA1A:
	ldr r2, _0224FB2C ; =0x0000086C
	mov r1, #0xf
	ldrb r3, [r4, r2]
	add r0, r3, #0
	bic r0, r1
	lsl r1, r3, #0x1c
	lsr r1, r1, #0x1c
	add r1, r1, #1
	lsl r1, r1, #0x18
	lsr r3, r1, #0x18
	mov r1, #0xf
	and r1, r3
	orr r0, r1
	strb r0, [r4, r2]
	mov r1, #0
	sub r0, r2, #3
	strb r1, [r4, r0]
	b _0224FB28
_0224FA3E:
	add r2, r7, #0
	bl ov02_02250004
	cmp r0, #0
	beq _0224FB28
	ldr r0, _0224FB3C ; =0x00000869
	mov r1, #1
	strb r1, [r4, r0]
	b _0224FB28
_0224FA50:
	ldr r0, _0224FB2C ; =0x0000086C
	add r0, r0, #2
	ldrh r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl DialogBox_IsPrintFinished
	cmp r0, #1
	bne _0224FB28
	ldr r1, _0224FB2C ; =0x0000086C
	ldrb r2, [r4, r1]
	lsl r0, r2, #0x18
	lsl r2, r2, #0x1c
	lsr r2, r2, #0x1c
	lsr r0, r0, #0x1c
	add r2, r2, #1
	cmp r0, r2
	ble _0224FAA8
	ldr r0, _0224FB40 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _0224FB28
	add r0, r4, #0
	mov r1, #0
	bl ClearFrameAndWindow2
	add r0, r4, #0
	bl RemoveWindow
	ldr r0, [r4, #0x10]
	bl String_Delete
	add r0, r5, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x40
	add r5, #0xd2
	bic r1, r0
	strb r1, [r5]
	ldr r0, _0224FB3C ; =0x00000869
	mov r1, #3
	strb r1, [r4, r0]
	b _0224FB28
_0224FAA8:
	add r0, r1, #0
	sub r0, #0x60
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0224FABA
	mov r2, #3
	sub r0, r1, #3
	strb r2, [r4, r0]
	b _0224FB28
_0224FABA:
	ldr r0, _0224FB40 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _0224FB28
	add r0, r4, #0
	mov r1, #0
	bl ClearFrameAndWindow2
	add r0, r4, #0
	bl RemoveWindow
	ldr r0, [r4, #0x10]
	bl String_Delete
	add r0, r5, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x40
	add r5, #0xd2
	bic r1, r0
	strb r1, [r5]
	ldr r0, _0224FB3C ; =0x00000869
	mov r1, #3
	strb r1, [r4, r0]
	b _0224FB28
_0224FAEE:
	ldr r0, _0224FB2C ; =0x0000086C
	add r0, r0, #1
	ldrb r1, [r4, r0]
	ldrb r0, [r6, #7]
	cmp r1, r0
	blo _0224FB1A
	mov r0, #0xf
	bic r3, r0
	mov r0, ip
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	mov r0, #0xf
	and r0, r1
	add r1, r3, #0
	orr r1, r0
	ldr r0, _0224FB2C ; =0x0000086C
	strb r1, [r4, r0]
	mov r1, #0
	sub r0, r0, #3
	strb r1, [r4, r0]
	b _0224FB28
_0224FB1A:
	ldr r0, _0224FB2C ; =0x0000086C
	add r0, r0, #1
	ldrb r0, [r4, r0]
	add r1, r0, #1
	ldr r0, _0224FB2C ; =0x0000086C
	add r0, r0, #1
	strb r1, [r4, r0]
_0224FB28:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224FB2C: .word 0x0000086C
_0224FB30: .word 0x0000080C
_0224FB34: .word 0x0000FFFF
_0224FB38: .word 0x00000868
_0224FB3C: .word 0x00000869
_0224FB40: .word gSystem
	thumb_func_end ov02_0224F8FC

	thumb_func_start ov02_0224FB44
ov02_0224FB44: ; 0x0224FB44
	ldrh r0, [r1]
	cmp r0, #0
	beq _0224FB4E
	mov r0, #1
	bx lr
_0224FB4E:
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224FB44

	thumb_func_start ov02_0224FB54
ov02_0224FB54: ; 0x0224FB54
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r5, r0]
	ldr r0, _0224FB98 ; =0x00000882
	add r4, r2, #0
	ldrh r0, [r1, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl sub_0205BB04
	cmp r0, #0
	beq _0224FB74
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224FB74:
	ldrb r2, [r4, #6]
	cmp r2, #0
	beq _0224FB92
	cmp r2, #0xe
	bls _0224FB82
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224FB82:
	add r0, r5, #0
	add r5, #0xe4
	ldr r1, [r5]
	sub r2, r2, #1
	bl ov01_02203AB4
	mov r0, #1
	pop {r3, r4, r5, pc}
_0224FB92:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0224FB98: .word 0x00000882
	thumb_func_end ov02_0224FB54

	thumb_func_start FollowMon_TryPrintInteractionMessage
FollowMon_TryPrintInteractionMessage: ; 0x0224FB9C
	push {r4, r5, r6, lr}
	add r6, r2, #0
	add r5, r0, #0
	ldrh r0, [r6, #2]
	add r4, r1, #0
	cmp r0, #0
	beq _0224FC00
	mov r0, #1
	lsl r0, r0, #0xa
	mov r1, #0xb
	bl String_New
	str r0, [r4, #0x10]
	ldr r0, [r5, #8]
	add r1, r4, #0
	mov r2, #3
	bl DialogBox_AddWindowToLayer3
	ldrh r3, [r6, #2]
	ldr r1, [r4, #0x10]
	add r0, r5, #0
	mov r2, #0xb
	sub r3, r3, #1
	bl FollowMon_ExpandInteractionMessage
	ldr r0, [r5, #0xc]
	bl Save_PlayerData_GetOptionsAddr
	add r6, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	bl DialogBox_LoadFrame
	ldr r1, [r4, #0x10]
	add r0, r4, #0
	add r2, r6, #0
	mov r3, #1
	bl DialogBox_PrintMessage
	ldr r1, _0224FC04 ; =0x0000086E
	strh r0, [r4, r1]
	add r0, r5, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x40
	add r5, #0xd2
	orr r0, r1
	strb r0, [r5]
	mov r0, #1
	pop {r4, r5, r6, pc}
_0224FC00:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224FC04: .word 0x0000086E
	thumb_func_end FollowMon_TryPrintInteractionMessage

	thumb_func_start ov02_0224FC08
ov02_0224FC08: ; 0x0224FC08
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	mov r0, #1
	add r4, r1, #0
	lsl r0, r0, #0xa
	mov r1, #0xb
	add r6, r2, #0
	bl String_New
	str r0, [r4, #0x10]
	ldr r0, [r5, #8]
	add r1, r4, #0
	mov r2, #3
	bl DialogBox_AddWindowToLayer3
	ldr r0, _0224FC6C ; =0x00000816
	mov r2, #0xb
	ldrb r0, [r4, r0]
	add r3, r6, #0
	str r0, [sp]
	ldr r1, [r4, #0x10]
	add r0, r5, #0
	bl ov02_0224FCE0
	ldr r0, [r5, #0xc]
	bl Save_PlayerData_GetOptionsAddr
	add r6, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	bl DialogBox_LoadFrame
	ldr r1, [r4, #0x10]
	add r0, r4, #0
	add r2, r6, #0
	mov r3, #1
	bl DialogBox_PrintMessage
	ldr r1, _0224FC70 ; =0x0000086E
	strh r0, [r4, r1]
	add r0, r5, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x40
	add r5, #0xd2
	orr r0, r1
	strb r0, [r5]
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_0224FC6C: .word 0x00000816
_0224FC70: .word 0x0000086E
	thumb_func_end ov02_0224FC08

	thumb_func_start ov02_0224FC74
ov02_0224FC74: ; 0x0224FC74
	ldr r2, _0224FC88 ; =0x0000086D
	mov r3, #0
	strb r3, [r0, r2]
	ldrb r0, [r1, #7]
	cmp r0, #0
	beq _0224FC82
	mov r3, #1
_0224FC82:
	add r0, r3, #0
	bx lr
	nop
_0224FC88: .word 0x0000086D
	thumb_func_end ov02_0224FC74

	thumb_func_start FollowMon_ExpandInteractionMessage
FollowMon_ExpandInteractionMessage: ; 0x0224FC8C
	push {r3, r4, r5, r6, r7, lr}
	str r1, [sp]
	mov r1, #0x1b
	add r4, r2, #0
	add r2, r1, #0
	add r6, r0, #0
	add r7, r3, #0
	mov r0, #0
	add r2, #0xee
	add r3, r4, #0
	bl NewMsgDataFromNarc
	add r5, r0, #0
	add r0, r4, #0
	bl MessageFormat_New
	add r4, r0, #0
	add r0, r6, #0
	add r1, r4, #0
	bl FollowMon_PlaceholdersSet
	add r0, r5, #0
	add r1, r7, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r1, [sp]
	add r0, r4, #0
	add r2, r6, #0
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	add r0, r4, #0
	bl MessageFormat_Delete
	add r0, r5, #0
	bl DestroyMsgData
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end FollowMon_ExpandInteractionMessage

	thumb_func_start ov02_0224FCE0
ov02_0224FCE0: ; 0x0224FCE0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r4, r2, #0
	add r5, r0, #0
	str r1, [sp]
	add r6, r3, #0
	mov r0, #0
	mov r1, #0x1b
	mov r2, #0x28
	add r3, r4, #0
	bl NewMsgDataFromNarc
	add r7, r0, #0
	add r0, r4, #0
	bl MessageFormat_New
	add r4, r0, #0
	mov r0, #2
	tst r0, r6
	ldr r0, [r5, #0xc]
	beq _0224FD3E
	bl Save_PlayerData_GetProfile
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #0
	bl BufferPlayersName
	mov r1, #1
	add r0, r6, #0
	tst r0, r1
	add r2, sp, #0x10
	beq _0224FD30
	ldrb r2, [r2, #0x10]
	add r0, r4, #0
	sub r2, r2, #1
	bl BufferFashionName
	mov r1, #0x20
	b _0224FD72
_0224FD30:
	ldrb r2, [r2, #0x10]
	add r0, r4, #0
	sub r2, r2, #1
	bl BufferFashionNameWithArticle
	mov r1, #0x5f
	b _0224FD72
_0224FD3E:
	bl SaveArray_Party_Get
	bl GetFirstAliveMonInParty_CrashIfNone
	bl Mon_GetBoxMon
	str r0, [sp, #4]
	ldr r0, [r5, #0xc]
	bl Save_PlayerData_GetProfile
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #0
	bl BufferPlayersName
	ldr r2, [sp, #4]
	add r0, r4, #0
	mov r1, #1
	bl BufferBoxMonNickname
	mov r0, #1
	tst r0, r6
	beq _0224FD70
	mov r1, #0x61
	b _0224FD72
_0224FD70:
	mov r1, #0x62
_0224FD72:
	add r0, r7, #0
	bl NewString_ReadMsgData
	add r5, r0, #0
	ldr r1, [sp]
	add r0, r4, #0
	add r2, r5, #0
	bl StringExpandPlaceholders
	add r0, r5, #0
	bl String_Delete
	add r0, r4, #0
	bl MessageFormat_Delete
	add r0, r7, #0
	bl DestroyMsgData
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224FCE0

	thumb_func_start ov02_0224FD9C
ov02_0224FD9C: ; 0x0224FD9C
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	add r1, sp, #0
	bl MapObject_CopyPositionVector
	mov r0, #2
	ldrsb r0, [r5, r0]
	cmp r0, #0
	beq _0224FDBC
	ldr r1, [sp]
	lsl r0, r0, #0xc
	add r0, r1, r0
	str r0, [sp]
_0224FDBC:
	mov r0, #3
	ldrsb r0, [r5, r0]
	cmp r0, #0
	beq _0224FDDC
	add r0, r4, #0
	bl FollowMon_GetSpecies
	cmp r0, #0x32
	beq _0224FDDC
	cmp r0, #0x33
	beq _0224FDDC
	mov r1, #3
	ldrsb r1, [r5, r1]
	add r0, r4, #0
	bl ov01_021F8F74
_0224FDDC:
	mov r0, #4
	ldrsb r0, [r5, r0]
	cmp r0, #0
	beq _0224FDEC
	ldr r1, [sp, #8]
	lsl r0, r0, #0xc
	add r0, r1, r0
	str r0, [sp, #8]
_0224FDEC:
	add r0, r4, #0
	add r1, sp, #0
	bl MapObject_SetPositionVector
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov02_0224FD9C

	thumb_func_start ov02_0224FDF8
ov02_0224FDF8: ; 0x0224FDF8
	push {r4, lr}
	sub sp, #8
	ldrb r0, [r0, #5]
	cmp r0, #0
	beq _0224FE32
	cmp r1, #0
	beq _0224FE32
	ldr r0, _0224FE38 ; =SEQ_SE_END
	cmp r1, r0
	bls _0224FE2C
	add r0, r0, #1
	cmp r1, r0
	bne _0224FE16
	mov r0, #0
	b _0224FE18
_0224FE16:
	mov r0, #0xb
_0224FE18:
	ldr r4, _0224FE3C ; =0x000001FF
	add r1, r2, #0
	str r4, [sp]
	str r3, [sp, #4]
	add r2, r4, #0
	add r3, r4, #0
	bl PlayCryEx
	add sp, #8
	pop {r4, pc}
_0224FE2C:
	add r0, r1, #0
	bl PlaySE
_0224FE32:
	add sp, #8
	pop {r4, pc}
	nop
_0224FE38: .word SEQ_SE_END
_0224FE3C: .word 0x000001FF
	thumb_func_end ov02_0224FDF8

	thumb_func_start ov02_0224FE40
ov02_0224FE40: ; 0x0224FE40
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r7, r0, #0
	ldrb r0, [r5]
	add r4, r2, #0
	cmp r0, #0
	beq _0224FE6C
	add r0, r4, #0
	bl MapObject_GetFacingDirection
	ldrb r1, [r5]
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	add r0, r4, #0
	sub r1, r1, #1
	bl MapObject_SetFacingDirectionDirect
	add r0, r7, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov02_0224FE70
_0224FE6C:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224FE40

	thumb_func_start ov02_0224FE70
ov02_0224FE70: ; 0x0224FE70
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	add r6, r2, #0
	bl ov01_022055DC
	cmp r0, #0
	beq _0224FEFC
	add r0, r4, #0
	bl MapObject_GetFacingDirection
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r6, r0
	beq _0224FEFC
	ldr r0, _0224FF00 ; =0x0000087C
	ldrb r0, [r5, r0]
	cmp r0, #2
	beq _0224FE9E
	cmp r0, #3
	bne _0224FEFC
_0224FE9E:
	add r0, r4, #0
	bl MapObject_GetFieldSystem
	ldr r1, _0224FF00 ; =0x0000087C
	add r6, r0, #0
	ldrb r1, [r5, r1]
	add r0, r4, #0
	add r2, sp, #8
	add r3, sp, #4
	bl ov02_0224FF04
	ldr r1, [sp, #8]
	ldr r2, [sp, #4]
	add r0, r6, #0
	bl GetMetatileBehavior
	add r5, r0, #0
	lsl r0, r5, #0x18
	lsr r0, r0, #0x18
	bl MetatileBehavior_IsTallGrass
	cmp r0, #1
	bne _0224FEE0
	mov r0, #1
	str r0, [sp]
	ldr r2, [sp, #8]
	ldr r3, [sp, #4]
	add r0, r4, #0
	mov r1, #0
	bl ov01_021FF0E4
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
_0224FEE0:
	lsl r0, r5, #0x18
	lsr r0, r0, #0x18
	bl MetatileBehavior_IsVeryTallGrass
	cmp r0, #1
	bne _0224FEFC
	mov r0, #1
	str r0, [sp]
	ldr r2, [sp, #8]
	ldr r3, [sp, #4]
	add r0, r4, #0
	mov r1, #0
	bl ov01_021FF964
_0224FEFC:
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_0224FF00: .word 0x0000087C
	thumb_func_end ov02_0224FE70

	thumb_func_start ov02_0224FF04
ov02_0224FF04: ; 0x0224FF04
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r4, r2, #0
	add r6, r1, #0
	add r5, r3, #0
	bl MapObject_GetXCoord
	str r0, [r4]
	add r0, r7, #0
	bl MapObject_GetZCoord
	str r0, [r5]
	cmp r6, #3
	bhi _0224FF54
	add r0, r6, r6
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224FF2C: ; jump table
	.short _0224FF34 - _0224FF2C - 2 ; case 0
	.short _0224FF3C - _0224FF2C - 2 ; case 1
	.short _0224FF44 - _0224FF2C - 2 ; case 2
	.short _0224FF4C - _0224FF2C - 2 ; case 3
_0224FF34:
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_0224FF3C:
	ldr r0, [r5]
	sub r0, r0, #1
	str r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_0224FF44:
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_0224FF4C:
	ldr r0, [r4]
	sub r0, r0, #1
	str r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
_0224FF54:
	bl GF_AssertFail
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224FF04

	thumb_func_start ov02_0224FF5C
ov02_0224FF5C: ; 0x0224FF5C
	push {r4, r5, r6, lr}
	ldr r3, _0224FFCC ; =0x00000818
	add r5, r0, #0
	add r2, r3, #0
	add r2, #0x53
	ldrb r2, [r5, r2]
	add r0, r5, r3
	add r3, #0x52
	lsl r2, r2, #3
	add r4, r0, r2
	ldrb r0, [r5, r3]
	add r6, r1, #0
	cmp r0, #0
	bne _0224FFA8
	add r0, r4, #0
	bl ov02_0224FD9C
	ldr r3, _0224FFD0 ; =0x0000086C
	add r0, r4, #0
	ldrb r1, [r5, r3]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x19
	add r2, r5, r1
	add r1, r3, #0
	sub r1, #0x84
	ldrh r1, [r2, r1]
	add r2, r3, #0
	add r2, #0x12
	add r3, #0x11
	ldrh r2, [r5, r2]
	ldrb r3, [r5, r3]
	bl ov02_0224FDF8
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov02_0224FE40
_0224FFA8:
	ldr r1, _0224FFD4 ; =0x0000086A
	ldrb r0, [r5, r1]
	add r0, r0, #1
	strb r0, [r5, r1]
	ldrb r2, [r5, r1]
	ldrb r0, [r4, #1]
	cmp r2, r0
	blo _0224FFC6
	add r0, r1, #1
	ldrb r0, [r5, r0]
	add r2, r0, #1
	add r0, r1, #1
	strb r2, [r5, r0]
	mov r0, #1
	pop {r4, r5, r6, pc}
_0224FFC6:
	mov r0, #0
	pop {r4, r5, r6, pc}
	nop
_0224FFCC: .word 0x00000818
_0224FFD0: .word 0x0000086C
_0224FFD4: .word 0x0000086A
	thumb_func_end ov02_0224FF5C

	thumb_func_start ov02_0224FFD8
ov02_0224FFD8: ; 0x0224FFD8
	ldr r2, _02250000 ; =0x0000086B
	ldrb r1, [r0, r2]
	cmp r1, #0xa
	blo _0224FFE4
	mov r0, #0
	bx lr
_0224FFE4:
	lsl r1, r1, #3
	add r3, r0, r1
	add r1, r2, #0
	sub r1, #0x53
	ldrb r1, [r3, r1]
	cmp r1, #0xff
	bne _0224FFF6
	mov r0, #0
	bx lr
_0224FFF6:
	mov r3, #0
	sub r1, r2, #1
	strb r3, [r0, r1]
	mov r0, #1
	bx lr
	.balign 4, 0
_02250000: .word 0x0000086B
	thumb_func_end ov02_0224FFD8

	thumb_func_start ov02_02250004
ov02_02250004: ; 0x02250004
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	cmp r2, #0
	bne _02250016
	bl GF_AssertFail
	mov r0, #1
	pop {r4, r5, r6, pc}
_02250016:
	ldr r0, _02250108 ; =0x00000868
	ldrb r1, [r4, r0]
	cmp r1, #4
	bhi _02250102
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0225002A: ; jump table
	.short _02250034 - _0225002A - 2 ; case 0
	.short _02250040 - _0225002A - 2 ; case 1
	.short _02250082 - _0225002A - 2 ; case 2
	.short _02250098 - _0225002A - 2 ; case 3
	.short _022500AE - _0225002A - 2 ; case 4
_02250034:
	sub r0, #0x50
	add r0, r4, r0
	mov r1, #0xe0
	sub r2, r2, #1
	bl ReadWholeNarcMemberByIdPair
_02250040:
	add r0, r5, #0
	add r0, #0xe4
	mov r1, #0x87
	lsl r1, r1, #4
	ldr r0, [r0]
	add r1, r4, r1
	bl MapObject_CopyPositionVector
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	bl MapObject_GetFacingDirection
	ldr r1, _0225010C ; =0x0000087C
	strb r0, [r4, r1]
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	mov r1, #0
	bl ov01_021F8F68
	add r5, #0xe4
	ldr r0, [r5]
	mov r1, #1
	bl ov01_021F8F08
	ldr r0, _02250108 ; =0x00000868
	mov r1, #2
	strb r1, [r4, r0]
	mov r1, #0
	add r0, r0, #3
	strb r1, [r4, r0]
	b _02250102
_02250082:
	add r0, r4, #0
	bl ov02_0224FFD8
	cmp r0, #0
	ldr r0, _02250108 ; =0x00000868
	bne _02250094
	mov r1, #4
	strb r1, [r4, r0]
	b _02250102
_02250094:
	mov r1, #3
	strb r1, [r4, r0]
_02250098:
	add r5, #0xe4
	ldr r1, [r5]
	add r0, r4, #0
	bl ov02_0224FF5C
	cmp r0, #0
	beq _02250102
	ldr r0, _02250108 ; =0x00000868
	mov r1, #2
	strb r1, [r4, r0]
	b _02250102
_022500AE:
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	bl MapObject_GetFacingDirection
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	mov r1, #0
	bl ov01_021F8F68
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	mov r1, #0
	bl ov01_021F8F08
	add r0, r5, #0
	add r0, #0xe4
	mov r1, #0x87
	lsl r1, r1, #4
	ldr r0, [r0]
	add r1, r4, r1
	bl MapObject_SetPositionVector
	ldr r1, _0225010C ; =0x0000087C
	add r0, r5, #0
	add r0, #0xe4
	ldrb r1, [r4, r1]
	ldr r0, [r0]
	bl MapObject_SetFacingDirectionDirect
	add r5, #0xe4
	ldr r1, [r5]
	add r0, r4, #0
	add r2, r6, #0
	bl ov02_0224FE70
	mov r0, #1
	pop {r4, r5, r6, pc}
_02250102:
	mov r0, #0
	pop {r4, r5, r6, pc}
	nop
_02250108: .word 0x00000868
_0225010C: .word 0x0000087C
	thumb_func_end ov02_02250004

	thumb_func_start Task_FollowMonInteract
Task_FollowMonInteract: ; 0x02250110
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	bl TaskManager_GetFieldSystem
	add r4, r0, #0
	add r0, r5, #0
	bl TaskManager_GetStatePtr
	add r6, r0, #0
	ldr r0, [r6]
	cmp r0, #5
	bls _0225012A
	b _0225047E
_0225012A:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02250136: ; jump table
	.short _02250142 - _02250136 - 2 ; case 0
	.short _0225015C - _02250136 - 2 ; case 1
	.short _022501A2 - _02250136 - 2 ; case 2
	.short _02250314 - _02250136 - 2 ; case 3
	.short _02250378 - _02250136 - 2 ; case 4
	.short _02250418 - _02250136 - 2 ; case 5
_02250142:
	add r0, r4, #0
	bl ov02_0224EF94
	add r1, r0, #0
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl ov02_0224F880
	ldr r0, [r6]
	add r0, r0, #1
	str r0, [r6]
	b _0225047E
_0225015C:
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	bl ov02_0224F8FC
	cmp r0, #1
	bne _02250178
	add r4, #0xe4
	ldr r0, [r4]
	bl MapObject_PauseMovement
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_02250178:
	cmp r0, #2
	bne _0225018E
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _02250484 ; =0x00000869
	mov r2, #0xa
	strb r2, [r1, r0]
	mov r0, #2
	str r0, [r6]
	b _0225047E
_0225018E:
	cmp r0, #3
	bne _02250198
	mov r0, #3
	str r0, [r6]
	b _0225047E
_02250198:
	cmp r0, #4
	bne _02250270
	mov r0, #4
	str r0, [r6]
	b _0225047E
_022501A2:
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _02250484 ; =0x00000869
	ldrb r0, [r1, r0]
	sub r0, #0xa
	cmp r0, #3
	bhi _02250270
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022501BE: ; jump table
	.short _022501C6 - _022501BE - 2 ; case 0
	.short _022501DE - _022501BE - 2 ; case 1
	.short _02250218 - _022501BE - 2 ; case 2
	.short _02250246 - _022501BE - 2 ; case 3
_022501C6:
	add r0, r4, #0
	mov r1, #3
	mov r2, #0
	bl ov01_021F6A9C
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _02250484 ; =0x00000869
	mov r2, #0xb
	strb r2, [r1, r0]
	b _0225047E
_022501DE:
	add r0, r4, #0
	bl ov01_021F6B00
	add r5, r0, #0
	add r0, r4, #0
	bl ov01_021F6B10
	cmp r5, #3
	bne _02250270
	cmp r0, #1
	bne _02250270
	mov r3, #0x12
	lsl r3, r3, #4
	ldr r5, [r4, r3]
	mov r3, #0x22
	mov r1, #3
	lsl r3, r3, #6
	add r0, r4, #0
	add r2, r1, #0
	add r3, r5, r3
	bl ov01_021F6ABC
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _02250484 ; =0x00000869
	mov r2, #0xc
	strb r2, [r1, r0]
	b _0225047E
_02250218:
	add r0, r4, #0
	bl ov01_021F6B00
	add r5, r0, #0
	add r0, r4, #0
	bl ov01_021F6AEC
	cmp r5, #3
	bne _02250270
	cmp r0, #6
	bne _02250270
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov01_021F6A9C
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _02250484 ; =0x00000869
	mov r2, #0xd
	strb r2, [r1, r0]
	b _0225047E
_02250246:
	add r0, r4, #0
	bl ov01_021F6B00
	add r5, r0, #0
	add r0, r4, #0
	bl ov01_021F6B10
	cmp r5, #0
	bne _02250270
	cmp r0, #1
	bne _02250270
	mov r0, #0x12
	lsl r0, r0, #4
	mov r1, #0x22
	ldr r0, [r4, r0]
	lsl r1, r1, #6
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _02250272
	cmp r1, #1
	beq _022502C4
_02250270:
	b _0225047E
_02250272:
	mov r1, #0
	bl ClearFrameAndWindow2
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl RemoveWindow
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	ldr r0, [r0, #0x10]
	bl String_Delete
	add r0, r4, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x40
	bic r1, r0
	add r0, r4, #0
	add r0, #0xd2
	strb r1, [r0]
	mov r0, #0x12
	lsl r0, r0, #4
	mov r1, #0x81
	ldr r0, [r4, r0]
	lsl r1, r1, #4
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _022502BA
	add r4, #0xe4
	ldr r0, [r4]
	bl MapObject_PauseMovement
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_022502BA:
	bl ov02_0224F880
	mov r0, #1
	str r0, [r6]
	b _0225047E
_022502C4:
	mov r1, #0
	bl ClearFrameAndWindow2
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl RemoveWindow
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	ldr r0, [r0, #0x10]
	bl String_Delete
	add r0, r4, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x40
	bic r1, r0
	add r0, r4, #0
	add r0, #0xd2
	strb r1, [r0]
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	ldr r1, _02250488 ; =0x00000812
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _0225030A
	add r4, #0xe4
	ldr r0, [r4]
	bl MapObject_PauseMovement
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0225030A:
	bl ov02_0224F880
	mov r0, #1
	str r0, [r6]
	b _0225047E
_02250314:
	ldr r0, [r4, #0xc]
	bl Save_FashionData_Get
	bl Save_FashionData_GetFashionCase
	add r7, r0, #0
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _0225048C ; =0x00000816
	ldrb r0, [r1, r0]
	sub r5, r0, #1
	bmi _02250332
	cmp r5, #0x64
	blt _02250336
_02250332:
	bl GF_AssertFail
_02250336:
	add r0, r7, #0
	add r1, r5, #0
	mov r2, #1
	bl sub_0202BA2C
	cmp r0, #0
	beq _02250364
	add r0, r7, #0
	add r1, r5, #0
	mov r2, #1
	bl FashionCase_GiveFashionItem
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #3
	bl ov02_0224FC08
	ldr r0, _02250490 ; =SEQ_ME_ACCE
	bl PlayFanfare
	b _02250372
_02250364:
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #2
	bl ov02_0224FC08
_02250372:
	mov r0, #5
	str r0, [r6]
	b _0225047E
_02250378:
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _02250494 ; =0x00000817
	ldrb r0, [r1, r0]
	cmp r0, #5
	bhi _022503B2
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02250392: ; jump table
	.short _022503B2 - _02250392 - 2 ; case 0
	.short _0225039E - _02250392 - 2 ; case 1
	.short _022503A2 - _02250392 - 2 ; case 2
	.short _022503A6 - _02250392 - 2 ; case 3
	.short _022503AA - _02250392 - 2 ; case 4
	.short _022503AE - _02250392 - 2 ; case 5
_0225039E:
	mov r5, #MON_DATA_SHINY_LEAF_A
	b _022503BA
_022503A2:
	mov r5, #MON_DATA_SHINY_LEAF_B
	b _022503BA
_022503A6:
	mov r5, #MON_DATA_SHINY_LEAF_C
	b _022503BA
_022503AA:
	mov r5, #MON_DATA_SHINY_LEAF_D
	b _022503BA
_022503AE:
	mov r5, #MON_DATA_SHINY_LEAF_E
	b _022503BA
_022503B2:
	bl GF_AssertFail
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_022503BA:
	ldr r0, [r4, #0xc]
	bl SaveArray_Party_Get
	bl GetFirstAliveMonInParty_CrashIfNone
	add r1, r5, #0
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bne _02250404
	ldr r0, [r4, #0xc]
	bl Save_VarsFlags_Get
	bl SetFlag99C
	mov r1, #1
	add r0, sp, #0
	strb r1, [r0]
	add r0, r7, #0
	add r1, r5, #0
	add r2, sp, #0
	bl SetMonData
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #1
	bl ov02_0224FC08
	ldr r0, _02250490 ; =SEQ_ME_ACCE
	bl PlayFanfare
	b _02250412
_02250404:
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0
	bl ov02_0224FC08
_02250412:
	mov r0, #5
	str r0, [r6]
	b _0225047E
_02250418:
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _02250498 ; =0x0000086E
	ldrh r0, [r1, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl DialogBox_IsPrintFinished
	cmp r0, #1
	bne _0225047E
	bl IsFanfarePlaying
	cmp r0, #0
	bne _0225047E
	ldr r0, _0225049C ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _0225047E
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl ClearFrameAndWindow2
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl RemoveWindow
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	ldr r0, [r0, #0x10]
	bl String_Delete
	add r0, r4, #0
	add r0, #0xd2
	ldrb r1, [r0]
	mov r0, #0x40
	bic r1, r0
	add r0, r4, #0
	add r0, #0xd2
	add r4, #0xe4
	strb r1, [r0]
	ldr r0, [r4]
	bl MapObject_PauseMovement
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0225047E:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02250484: .word 0x00000869
_02250488: .word 0x00000812
_0225048C: .word 0x00000816
_02250490: .word SEQ_ME_ACCE
_02250494: .word 0x00000817
_02250498: .word 0x0000086E
_0225049C: .word gSystem
	thumb_func_end Task_FollowMonInteract

	thumb_func_start FollowMon_PlaceholdersSet
FollowMon_PlaceholdersSet: ; 0x022504A0
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	add r4, r1, #0
	bl SaveArray_Party_Get
	bl GetFirstAliveMonInParty_CrashIfNone
	add r6, r0, #0
	bl Mon_GetBoxMon
	add r7, r0, #0
	add r0, r4, #0
	mov r1, #0
	add r2, r7, #0
	bl BufferBoxMonNickname
	add r0, r4, #0
	mov r1, #1
	add r2, r7, #0
	bl BufferBoxMonSpeciesName
	ldr r0, [r5, #0xc]
	bl Save_PlayerData_GetProfile
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #2
	bl BufferPlayersName
	ldr r0, [r5, #0x20]
	ldr r0, [r0]
	bl MapHeader_GetMapSec
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #3
	bl BufferLocationName
	add r0, r6, #0
	mov r1, #6
	mov r2, #0
	bl GetMonData
	add r2, r0, #0
	add r0, r4, #0
	mov r1, #4
	bl BufferItemName
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end FollowMon_PlaceholdersSet

	thumb_func_start ov02_02250504
ov02_02250504: ; 0x02250504
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	bl SaveArray_Party_Get
	bl GetFirstAliveMonInParty_CrashIfNone
	add r4, r0, #0
	mov r0, #0x42
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl FieldSystem_UnkSub108_GetMonMood
	mov r1, #0x12
	str r0, [sp]
	lsl r1, r1, #4
	ldr r2, [r5, r1]
	ldr r1, _0225058C ; =0x00000815
	ldrsb r1, [r2, r1]
	add r1, r0, r1
	str r1, [sp]
	cmp r1, #0x7f
	ble _02250538
	mov r0, #0x7f
	str r0, [sp]
	b _02250542
_02250538:
	mov r0, #0x7e
	mvn r0, r0
	cmp r1, r0
	bge _02250542
	str r0, [sp]
_02250542:
	mov r0, #0x42
	ldr r1, [sp]
	lsl r0, r0, #2
	lsl r1, r1, #0x18
	ldr r0, [r5, r0]
	asr r1, r1, #0x18
	bl FieldSystem_UnkSub108_SetMonMood
	add r0, r4, #0
	mov r1, #9
	mov r2, #0
	bl GetMonData
	mov r1, #0x12
	str r0, [sp]
	lsl r1, r1, #4
	ldr r2, [r5, r1]
	ldr r1, _02250590 ; =0x00000814
	ldrsb r1, [r2, r1]
	add r0, r0, r1
	str r0, [sp]
	cmp r0, #0xff
	ble _02250576
	mov r0, #0xff
	str r0, [sp]
	b _0225057E
_02250576:
	cmp r0, #0
	bge _0225057E
	mov r0, #0
	str r0, [sp]
_0225057E:
	add r0, r4, #0
	mov r1, #9
	add r2, sp, #0
	bl SetMonData
	pop {r3, r4, r5, pc}
	nop
_0225058C: .word 0x00000815
_02250590: .word 0x00000814
	thumb_func_end ov02_02250504

	thumb_func_start ov02_02250594
ov02_02250594: ; 0x02250594
	cmp r0, #0xa
	bhi _02250622
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022505A4: ; jump table
	.short _02250622 - _022505A4 - 2 ; case 0
	.short _022505BA - _022505A4 - 2 ; case 1
	.short _022505C2 - _022505A4 - 2 ; case 2
	.short _022505CE - _022505A4 - 2 ; case 3
	.short _022505DA - _022505A4 - 2 ; case 4
	.short _022505E6 - _022505A4 - 2 ; case 5
	.short _022505F2 - _022505A4 - 2 ; case 6
	.short _022505FE - _022505A4 - 2 ; case 7
	.short _0225060A - _022505A4 - 2 ; case 8
	.short _02250612 - _022505A4 - 2 ; case 9
	.short _0225061A - _022505A4 - 2 ; case 10
_022505BA:
	cmp r1, #0xff
	bne _02250622
	mov r0, #1
	bx lr
_022505C2:
	cmp r1, #0xc8
	blt _02250622
	cmp r1, #0xff
	bge _02250622
	mov r0, #1
	bx lr
_022505CE:
	cmp r1, #0x96
	blt _02250622
	cmp r1, #0xc8
	bge _02250622
	mov r0, #1
	bx lr
_022505DA:
	cmp r1, #0x5a
	blt _02250622
	cmp r1, #0x96
	bge _02250622
	mov r0, #1
	bx lr
_022505E6:
	cmp r1, #0x3c
	blt _02250622
	cmp r1, #0x5a
	bge _02250622
	mov r0, #1
	bx lr
_022505F2:
	cmp r1, #0x1e
	blt _02250622
	cmp r1, #0x3c
	bge _02250622
	mov r0, #1
	bx lr
_022505FE:
	cmp r1, #1
	blt _02250622
	cmp r1, #0x1e
	bge _02250622
	mov r0, #1
	bx lr
_0225060A:
	cmp r1, #0
	bne _02250622
	mov r0, #1
	bx lr
_02250612:
	cmp r1, #0x5a
	blt _02250622
	mov r0, #1
	bx lr
_0225061A:
	cmp r1, #0x3c
	bge _02250622
	mov r0, #1
	bx lr
_02250622:
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov02_02250594

	thumb_func_start ov02_02250628
ov02_02250628: ; 0x02250628
	cmp r0, #0xa
	bhi _022506CE
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02250638: ; jump table
	.short _022506CE - _02250638 - 2 ; case 0
	.short _0225064E - _02250638 - 2 ; case 1
	.short _02250656 - _02250638 - 2 ; case 2
	.short _02250662 - _02250638 - 2 ; case 3
	.short _0225066E - _02250638 - 2 ; case 4
	.short _0225067A - _02250638 - 2 ; case 5
	.short _0225068A - _02250638 - 2 ; case 6
	.short _0225069C - _02250638 - 2 ; case 7
	.short _022506AE - _02250638 - 2 ; case 8
	.short _022506BA - _02250638 - 2 ; case 9
	.short _022506C2 - _02250638 - 2 ; case 10
_0225064E:
	cmp r1, #0x7f
	bne _022506CE
	mov r0, #1
	bx lr
_02250656:
	cmp r1, #0x64
	blt _022506CE
	cmp r1, #0x7f
	bge _022506CE
	mov r0, #1
	bx lr
_02250662:
	cmp r1, #0x32
	blt _022506CE
	cmp r1, #0x64
	bge _022506CE
	mov r0, #1
	bx lr
_0225066E:
	cmp r1, #0x1e
	blt _022506CE
	cmp r1, #0x32
	bge _022506CE
	mov r0, #1
	bx lr
_0225067A:
	mov r0, #0x1d
	mvn r0, r0
	cmp r1, r0
	ble _022506CE
	cmp r1, #0x1e
	bge _022506CE
	mov r0, #1
	bx lr
_0225068A:
	mov r0, #0x31
	mvn r0, r0
	cmp r1, r0
	ble _022506CE
	add r0, #0x14
	cmp r1, r0
	bgt _022506CE
	mov r0, #1
	bx lr
_0225069C:
	mov r0, #0x7e
	mvn r0, r0
	cmp r1, r0
	ble _022506CE
	add r0, #0x4d
	cmp r1, r0
	bgt _022506CE
	mov r0, #1
	bx lr
_022506AE:
	mov r0, #0x7e
	mvn r0, r0
	cmp r1, r0
	bne _022506CE
	mov r0, #1
	bx lr
_022506BA:
	cmp r1, #0
	blt _022506CE
	mov r0, #1
	bx lr
_022506C2:
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	bgt _022506CE
	mov r0, #1
	bx lr
_022506CE:
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov02_02250628

	thumb_func_start ov02_022506D4
ov02_022506D4: ; 0x022506D4
	push {r3, lr}
	cmp r0, #0xf9
	bhi _022506E2
	cmp r0, r1
	bne _02250732
	mov r0, #1
	pop {r3, pc}
_022506E2:
	sub r0, #0xfa
	cmp r0, #4
	bhi _0225072A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022506F4: ; jump table
	.short _022506FE - _022506F4 - 2 ; case 0
	.short _02250706 - _022506F4 - 2 ; case 1
	.short _0225070E - _022506F4 - 2 ; case 2
	.short _0225071A - _022506F4 - 2 ; case 3
	.short _02250722 - _022506F4 - 2 ; case 4
_022506FE:
	cmp r1, #0x13
	bhi _02250732
	mov r0, #1
	pop {r3, pc}
_02250706:
	cmp r1, #0x82
	bhi _02250732
	mov r0, #1
	pop {r3, pc}
_0225070E:
	cmp r1, #0x8c
	blo _02250732
	cmp r1, #0x95
	bhi _02250732
	mov r0, #1
	pop {r3, pc}
_0225071A:
	cmp r1, #0xa0
	blo _02250732
	mov r0, #1
	pop {r3, pc}
_02250722:
	cmp r1, #0xdc
	blo _02250732
	mov r0, #1
	pop {r3, pc}
_0225072A:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
_02250732:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_022506D4

	thumb_func_start ov02_02250738
ov02_02250738: ; 0x02250738
	push {r4, r5}
	sub sp, #8
	ldr r4, _0225077C ; =ov02_02253A54
	add r2, sp, #0
	ldrb r5, [r4]
	add r3, sp, #0
	add r0, r2, r0
	strb r5, [r3]
	ldrb r5, [r4, #1]
	sub r0, r0, #1
	strb r5, [r3, #1]
	ldrb r5, [r4, #2]
	strb r5, [r3, #2]
	ldrb r5, [r4, #3]
	ldrb r4, [r4, #4]
	strb r5, [r3, #3]
	strb r4, [r3, #4]
	ldrb r0, [r0]
	mov r3, #0
	and r0, r1
_02250760:
	cmp r0, #0
	bne _0225076C
	add sp, #8
	mov r0, #1
	pop {r4, r5}
	bx lr
_0225076C:
	add r3, r3, #1
	cmp r3, #5
	blt _02250760
	mov r0, #0
	add sp, #8
	pop {r4, r5}
	bx lr
	nop
_0225077C: .word ov02_02253A54
	thumb_func_end ov02_02250738

	thumb_func_start ov02_02250780
ov02_02250780: ; 0x02250780
	push {r4, r5, r6, lr}
	ldr r0, [r0, #0xc]
	add r5, r1, #0
	bl SaveArray_Party_Get
	bl GetFirstAliveMonInParty_CrashIfNone
	add r6, r0, #0
	mov r1, #0xb1
	mov r2, #0
	bl GetMonData
	add r4, r0, #0
	add r0, r6, #0
	mov r1, #0xb2
	mov r2, #0
	bl GetMonData
	cmp r4, r5
	beq _022507AC
	cmp r0, r5
	bne _022507B0
_022507AC:
	mov r0, #1
	pop {r4, r5, r6, pc}
_022507B0:
	mov r0, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_02250780

	thumb_func_start ov02_022507B4
ov02_022507B4: ; 0x022507B4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0xe4
	ldr r0, [r0]
	add r4, r1, #0
	bl FollowMon_GetSpecies
	sub r0, #0x32
	cmp r0, #1
	bls _022507E0
	mov r0, #0xb
	mov r1, #8
	bl Heap_AllocAtEnd
	add r2, r0, #0
	strh r4, [r2]
	mov r0, #0
	strh r0, [r2, #2]
	ldr r0, [r5, #0x10]
	ldr r1, _022507E4 ; =ov02_022507E8
	bl TaskManager_Call
_022507E0:
	pop {r3, r4, r5, pc}
	nop
_022507E4: .word ov02_022507E8
	thumb_func_end ov02_022507B4

	thumb_func_start ov02_022507E8
ov02_022507E8: ; 0x022507E8
	push {r4, r5, r6, lr}
	add r4, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r4, #0
	bl TaskManager_GetEnvironment
	add r5, r0, #0
	add r0, r4, #0
	bl TaskManager_GetStatePtr
	add r4, r0, #0
	ldr r0, [r4]
	cmp r0, #4
	bhi _022508AA
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02250814: ; jump table
	.short _0225081E - _02250814 - 2 ; case 0
	.short _0225082E - _02250814 - 2 ; case 1
	.short _0225084C - _02250814 - 2 ; case 2
	.short _02250874 - _02250814 - 2 ; case 3
	.short _022508A0 - _02250814 - 2 ; case 4
_0225081E:
	add r0, r6, #0
	add r0, #0xe4
	ldr r0, [r0]
	bl MapObject_UnpauseMovement
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_0225082E:
	add r0, r6, #0
	bl FollowMon_GetMapObject
	bl MapObject_AreBitsSetForMovementScriptInit
	cmp r0, #0
	beq _022508AA
	add r6, #0xe4
	ldr r0, [r6]
	bl MapObject_PauseMovement
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _022508AA
_0225084C:
	add r0, r6, #0
	add r0, #0xe4
	ldr r0, [r0]
	bl MapObject_GetFacingDirection
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	add r6, #0xe4
	mov r2, #0x14
	ldr r3, _022508B0 ; =ov02_02253A70
	mul r2, r1
	ldr r0, [r6]
	add r1, r3, r2
	bl EventObjectMovementMan_Create
	str r0, [r5, #4]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _022508AA
_02250874:
	ldr r0, [r5, #4]
	bl EventObjectMovementMan_IsFinish
	cmp r0, #1
	bne _022508AA
	ldr r0, [r5, #4]
	bl EventObjectMovementMan_Delete
	ldrh r0, [r5, #2]
	add r0, r0, #1
	strh r0, [r5, #2]
	ldrh r1, [r5, #2]
	ldrh r0, [r5]
	cmp r1, r0
	blo _0225089A
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _022508AA
_0225089A:
	mov r0, #0
	str r0, [r4]
	b _022508AA
_022508A0:
	add r0, r5, #0
	bl Heap_Free
	mov r0, #1
	pop {r4, r5, r6, pc}
_022508AA:
	mov r0, #0
	pop {r4, r5, r6, pc}
	nop
_022508B0: .word ov02_02253A70
	thumb_func_end ov02_022507E8

	thumb_func_start ov02_022508B4
ov02_022508B4: ; 0x022508B4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xb
	mov r1, #4
	bl Heap_AllocAtEnd
	add r2, r0, #0
	mov r0, #0
	strh r0, [r2]
	strh r0, [r2, #2]
	ldr r0, [r4, #0x10]
	ldr r1, _022508D4 ; =ov02_022508D8
	bl TaskManager_Call
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_022508D4: .word ov02_022508D8
	thumb_func_end ov02_022508B4

	thumb_func_start ov02_022508D8
ov02_022508D8: ; 0x022508D8
	push {r4, r5, r6, lr}
	sub sp, #0x18
	add r4, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r4, #0
	bl TaskManager_GetStatePtr
	add r5, r0, #0
	add r0, r4, #0
	bl TaskManager_GetEnvironment
	ldr r1, [r5]
	add r4, r0, #0
	cmp r1, #3
	bls _022508FC
	b _02250A44
_022508FC:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02250908: ; jump table
	.short _02250910 - _02250908 - 2 ; case 0
	.short _0225099A - _02250908 - 2 ; case 1
	.short _022509AE - _02250908 - 2 ; case 2
	.short _02250A3A - _02250908 - 2 ; case 3
_02250910:
	ldr r3, _02250A4C ; =ov02_02253B24
	add r2, sp, #0xc
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldrh r0, [r4, #2]
	add r0, r0, #1
	strh r0, [r4, #2]
	ldrh r0, [r4, #2]
	bl _dfltu
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A50 ; =0x40A00000
	mov r0, #0
	bl _dmul
	ldr r3, _02250A54 ; =0x40240000
	mov r2, #0
	bl _ddiv
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A58 ; =0x40B00000
	mov r0, #0
	bl _dadd
	bl _dfix
	str r0, [sp, #0xc]
	ldrh r0, [r4, #2]
	bl _dfltu
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A50 ; =0x40A00000
	mov r0, #0
	bl _dmul
	ldr r3, _02250A54 ; =0x40240000
	mov r2, #0
	bl _ddiv
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A58 ; =0x40B00000
	mov r0, #0
	bl _dadd
	bl _dfix
	str r0, [sp, #0x10]
	ldr r0, [r6, #0x3c]
	bl ov01_021F771C
	add r1, sp, #0xc
	bl sub_02023E78
	ldrh r0, [r4, #2]
	cmp r0, #0xa
	blo _02250A44
	mov r0, #0
	strh r0, [r4, #2]
	strh r0, [r4]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	b _02250A44
_0225099A:
	ldrh r0, [r4]
	add r0, r0, #1
	strh r0, [r4]
	ldrh r0, [r4]
	cmp r0, #0xa
	blo _02250A44
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	b _02250A44
_022509AE:
	ldr r3, _02250A5C ; =ov02_02253B30
	add r2, sp, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldrh r0, [r4, #2]
	add r0, r0, #1
	strh r0, [r4, #2]
	ldrh r1, [r4, #2]
	cmp r1, #0xa
	blo _022509CE
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	b _02250A2C
_022509CE:
	mov r0, #0xa
	sub r0, r0, r1
	bl _dflt
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A50 ; =0x40A00000
	mov r0, #0
	bl _dmul
	ldr r3, _02250A54 ; =0x40240000
	mov r2, #0
	bl _ddiv
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A58 ; =0x40B00000
	mov r0, #0
	bl _dadd
	bl _dfix
	str r0, [sp]
	ldrh r1, [r4, #2]
	mov r0, #0xa
	sub r0, r0, r1
	bl _dflt
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A50 ; =0x40A00000
	mov r0, #0
	bl _dmul
	ldr r3, _02250A54 ; =0x40240000
	mov r2, #0
	bl _ddiv
	add r3, r1, #0
	add r2, r0, #0
	ldr r1, _02250A58 ; =0x40B00000
	mov r0, #0
	bl _dadd
	bl _dfix
	str r0, [sp, #4]
_02250A2C:
	ldr r0, [r6, #0x3c]
	bl ov01_021F771C
	add r1, sp, #0
	bl sub_02023E78
	b _02250A44
_02250A3A:
	bl Heap_Free
	add sp, #0x18
	mov r0, #1
	pop {r4, r5, r6, pc}
_02250A44:
	mov r0, #0
	add sp, #0x18
	pop {r4, r5, r6, pc}
	nop
_02250A4C: .word ov02_02253B24
_02250A50: .word 0x40A00000
_02250A54: .word 0x40240000
_02250A58: .word 0x40B00000
_02250A5C: .word ov02_02253B30
	thumb_func_end ov02_022508D8

    .rodata

ov02_022532F8:
	.word ov02_02248E10

ov02_022532FC: ; 0x022532FC
	.byte 0x07, 0x00, 0x08, 0x00

ov02_02253300:
	.word ov02_0224AC28

ov02_02253304: ; 0x02253304
	.byte 0x11, 0x00, 0x14, 0x00, 0x17, 0x00

ov02_0225330A: ; 0x0225330A
	.byte 0x13, 0x00, 0x16, 0x00, 0x19, 0x00

ov02_02253310: ; 0x02253310
	.byte 0x12, 0x00, 0x15, 0x00, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00

ov02_02253320: ; 0x02253320
	.word ov02_022532F8, ov02_022534D0, 0x01, 0x0F

ov02_02253330:
	.word ov02_0224ACE0, ov02_0224ADEC, 0x00, 0x06
	.byte 0x01, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00

ov02_02253348: ; 0x02253348
	.byte 0x00, 0x00, 0x08, 0x00, 0x00, 0x40, 0x05, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov02_02253354: ; 0x02253354
	.byte 0x00, 0x00, 0x08, 0x00, 0x00, 0x80, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_02253360: ; 0x02253360
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_0225336C: ; 0x0225336C
	.byte 0x00, 0x14, 0x00, 0x00
	.byte 0x00, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_02253378: ; 0x02253378
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov02_02253384: ; 0x02253384
	.byte 0x00, 0x80, 0x12, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_02253390: ; 0x02253390
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_0225339C: ; 0x0225339C
	.byte 0x00, 0x00, 0x08, 0x00
	.byte 0x00, 0xF0, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_022533A8: ; 0x022533A8
	.byte 0x00, 0x20, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov02_022533B4: ; 0x022533B4
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_022533C0: ; 0x022533C0
	.word ov02_02253300
	.word ov02_02253330
	.word ov02_02253420

ov02_022533CC: ; 0x022533CC
	.byte 0x00, 0x20, 0x00, 0x00
	.byte 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_022533D8: ; 0x022533D8
	.byte 0x00, 0x80, 0x08, 0x00, 0x00, 0xF0, 0x04, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov02_022533E4: ; 0x022533E4
	.byte 0x00, 0x80, 0x08, 0x00, 0x00, 0x80, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_022533F0: ; 0x022533F0
	.byte 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_022533FC: ; 0x022533FC
	.byte 0x00, 0x00, 0x08, 0x00
	.byte 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_02253408: ; 0x02253408
	.byte 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x06, 0x00
	.byte 0x00, 0x00, 0x00, 0x00

ov02_02253414: ; 0x02253414
	.byte 0x00, 0x80, 0x12, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00

ov02_02253420:
	.word ov02_0224AF70, ov02_0224B0E0, ov02_0224B158, ov02_0224B294

ov02_02253430: ; 0x02253430
	.byte 0x00, 0xC0, 0xFF, 0xFF, 0x00, 0xA0, 0xFF, 0xFF, 0x00, 0x90, 0xFF, 0xFF, 0x00, 0x80, 0xFF, 0xFF

ov02_02253440: ; 0x02253440
	.byte 0x08, 0x00, 0x00, 0x00
	.word ov02_0224B6D0
	.word sub_02068DD4
	.word ov02_0224B6E4
	.word sub_02068DD0

ov02_02253454: ; 0x02253454
	.byte 0x74, 0x00, 0x00, 0x00
	.word ov02_02248D98
	.word ov02_02248DE4
	.word ov02_02248DF0
	.word sub_02068DD0

ov02_02253468: ; 0x02253468
	.byte 0x24, 0x00, 0x00, 0x00
	.word ov02_0224AA80
	.word ov02_0224AAC8
	.word ov02_0224AAD4
	.word ov02_0224AB54

ov02_0225347C: ; 0x0225347C
	.byte 0x68, 0x00, 0x00, 0x00
	.word ov02_0224ABCC
	.word ov02_0224ABF8
	.word ov02_0224AC04
	.word ov02_0224AC24

ov02_02253490: ; 0x02253490
	.byte 0x0C, 0x00, 0x00, 0x00
	.word ov02_0224B7CC
	.word ov02_0224B804
	.word ov02_0224B808
	.word ov02_0224B87C

ov02_022534A4: ; 0x022534A4
	.byte 0x24, 0x00, 0x00, 0x00
	.word ov02_0224B350
	.word sub_02068DD4
	.word ov02_0224B3FC
	.word sub_02068DD0

ov02_022534B8: ; 0x022534B8
	.word ov02_0224B494
	.word ov02_0224B4AC
	.word ov02_0224B5F0
	.word ov02_0224B638
	.word ov02_0224B664
	.word ov02_0224B68C

ov02_022534D0:
	.word ov02_02248F88
	.word ov02_02249088
	.word ov02_022490BC
	.word ov02_022491A8
	.word ov02_022491CC
	.word ov02_02249290
	.word ov02_0224939C
	.word ov02_022493EC

ov02_022534F0: ; 0x022534F0
	.word ov02_022495D0
	.word ov02_02249A5C
	.word ov02_0224B938
	.word ov02_0224B964
	.word ov02_02249AD8
	.word ov02_02249AF0
	.word ov02_02249B80
	.word ov02_02249BA8
	.word ov02_02249C74
	.word ov02_02249CD8
	.word ov02_02249954
	.word ov02_0224997C

ov02_02253520: ; 0x02253520
	.byte 0x00, 0x40, 0xFF, 0xFF, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0xC0, 0xFE, 0xFF, 0x00, 0x80, 0xFE, 0xFF
	.byte 0x00, 0x60, 0xFE, 0xFF, 0x00, 0x40, 0xFE, 0xFF, 0x00, 0x40, 0xFE, 0xFF, 0x00, 0x40, 0xFE, 0xFF
	.byte 0x00, 0x60, 0xFE, 0xFF, 0x00, 0x80, 0xFE, 0xFF, 0x00, 0xA0, 0xFE, 0xFF, 0x00, 0xC0, 0xFE, 0xFF

ov02_02253550: ; 0x02253550
	.word ov02_022495B8
	.word ov02_022495E8
	.word ov02_02249658
	.word ov02_02249690
	.word ov02_022496D0
	.word ov02_02249754
	.word ov02_02249774
	.word ov02_022497C0
	.word ov02_02249838
	.word ov02_02249858
	.word ov02_022498BC
	.word ov02_02249940
	.word ov02_02249968
	.word ov02_0224997C

ov02_02253588: ; 0x02253588
	.word ov02_022495B8
	.word ov02_022499EC
	.word ov02_02249658
	.word ov02_02249690
	.word ov02_022496D0
	.word ov02_02249754
	.word ov02_02249774
	.word ov02_022497C0
	.word ov02_02249838
	.word ov02_02249858
	.word ov02_02249AC4
	.word ov02_02249AD8
	.word ov02_02249AF0
	.word ov02_02249B10
	.word ov02_02249B38
	.word ov02_02249B60
	.word ov02_02249BA8
	.word ov02_02249BD8
	.word ov02_02249C74
	.word ov02_02249CD8
	.word ov02_02249940
	.word ov02_02249968
	.word ov02_0224997C

ov02_022535E4: ; 0x022535E4
	.byte 0x00, 0xF0, 0x00, 0x00, 0x00, 0xF0, 0x03, 0x00, 0x00, 0x00, 0x01, 0x00
	.byte 0x85, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0x04, 0x00, 0x00, 0x30, 0x04, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x85, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00
	.byte 0x00, 0xD0, 0x03, 0x00, 0x00, 0x80, 0x01, 0x00, 0x80, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x0F, 0x00, 0x00, 0x50, 0x04, 0x00, 0x00, 0x00, 0x01, 0x00, 0x85, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x02, 0x00, 0x00, 0xE0, 0x04, 0x00, 0x00, 0x80, 0x01, 0x00
	.byte 0x80, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x80, 0x04, 0x00, 0x00, 0xB0, 0x05, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x85, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0D, 0x00
	.byte 0x00, 0x60, 0x05, 0x00, 0x00, 0x80, 0x01, 0x00, 0x80, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x80, 0x03, 0x00, 0x00, 0x40, 0x07, 0x00, 0x00, 0x00, 0x01, 0x00, 0x85, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x05, 0x00, 0x00, 0xD0, 0x06, 0x00, 0x00, 0x80, 0x01, 0x00
	.byte 0x80, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x09, 0x00, 0x00, 0x40, 0x06, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x85, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x01, 0x00
	.byte 0x00, 0xE0, 0x07, 0x00, 0x00, 0x80, 0x01, 0x00, 0x80, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0xC0, 0x08, 0x00, 0x00, 0xD0, 0x07, 0x00, 0x00, 0x80, 0x01, 0x00, 0x80, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0xD0, 0x0D, 0x00, 0x00, 0xC0, 0x07, 0x00, 0x00, 0x80, 0x01, 0x00
	.byte 0x80, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00

	.global ov02_022536E8
ov02_022536E8: ; 0x022536E8
	.byte 0x21, 0x00, 0x00, 0x00, 0x8A, 0x00, 0x00, 0x00

	.global ov02_022536F0
ov02_022536F0: ; 0x022536F0
	.word ov02_0224C234
	.word ov02_0224C2A8
	.word ov02_0224C2EC
	.word ov02_0224C338

	.global ov02_02253700
ov02_02253700: ; 0x02253700
	.word ov02_0224C05C
	.word ov02_0224C0B0
	.word ov02_0224C14C
	.word ov02_0224C1B8

	.global ov02_02253710
ov02_02253710: ; 0x02253710
	.word ov02_0224C87C
	.word ov02_0224C8D0
	.word ov02_0224C93C
	.word ov02_0224C9B8
	.word ov02_0224CA38

	.global ov02_02253724
ov02_02253724: ; 0x02253724
	.word ov02_0224C4B4
	.word ov02_0224C4D8
	.word ov02_0224C71C
	.word ov02_0224C75C
	.word ov02_0224C7D4
	.word ov02_0224C840

	.global ov02_0225373C
ov02_0225373C: ; 0x0225373C
	.word ov02_0224C680
	.word ov02_0224C698
	.word ov02_0224C6DC
	.word ov02_0224C75C
	.word ov02_0224C7D4
	.word ov02_0224C840

	.global ov02_02253754
ov02_02253754: ; 0x02253754
	.word ov02_0224C4B4
	.word ov02_0224C4D8
	.word ov02_0224C87C
	.word ov02_0224C8D0
	.word ov02_0224C93C
	.word ov02_0224C9B8
	.word ov02_0224CA38

	.global ov02_02253770
ov02_02253770: ; 0x02253770
	.byte 0x01, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00, 0x02, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00, 0x03, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00
	.byte 0xFE, 0x00, 0x00, 0x00

	.global ov02_02253794
ov02_02253794: ; 0x02253794
	.byte 0x00, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x01, 0x00, 0x01, 0x00
	.byte 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x01, 0x00, 0x01, 0x00
	.byte 0x02, 0x00, 0x01, 0x00, 0xFE, 0x00, 0x00, 0x00

	.global ov02_022537B8
ov02_022537B8: ; 0x022537B8
	.byte 0x01, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x01, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0xFE, 0x00, 0x00, 0x00

	.global ov02_022537DC
ov02_022537DC: ; 0x022537DC
	.byte 0x01, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x02, 0x00, 0x02, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x02, 0x00, 0x03, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00, 0x01, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00, 0xFE, 0x00, 0x00, 0x00

	.global ov02_02253820
ov02_02253820: ; 0x02253820
	.byte 0x01, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00, 0x02, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00, 0x03, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00
	.byte 0x01, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00
	.byte 0x01, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00
	.byte 0x01, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00
	.byte 0xFE, 0x00, 0x00, 0x00

	.global ov02_02253884
ov02_02253884: ; 0x02253884
	.byte 0x01, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00
	.byte 0x03, 0x00, 0x01, 0x00, 0x01, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00
	.byte 0x03, 0x00, 0x01, 0x00, 0x01, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00, 0x02, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x01, 0x00, 0x03, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x01, 0x00, 0x01, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x02, 0x00, 0x02, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x03, 0x00, 0x00, 0x00, 0x01, 0x00, 0x3C, 0x00, 0x04, 0x00, 0x03, 0x00, 0x01, 0x00
	.byte 0x3C, 0x00, 0x05, 0x00, 0x01, 0x00, 0x01, 0x00, 0xFE, 0x00, 0x00, 0x00

	.global ov02_022538EC
ov02_022538EC: ; 0x022538EC
	.byte 0x10, 0x0F, 0x0E, 0x0B
	.byte 0x0C, 0x09, 0xB4, 0x00, 0x00, 0x00, 0x0E, 0x01, 0x5A, 0x00, 0x00, 0x00

	.global ov02_022538FC
ov02_022538FC: ; 0x022538FC
	.byte 0x00, 0x04, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00
	.word ov02_0224D310
	.word ov02_0224D3A4
	.word ov02_0224D3B4
	.word ov02_0224D3E8

	.global ov02_02253914
ov02_02253914: ; 0x02253914
	.byte 0x00, 0x04, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00
	.word ov02_0224D5B4
	.word ov02_0224D648
	.word ov02_0224D658
	.word ov02_0224D670

	.global ov02_0225392C
ov02_0225392C: ; 0x0225392C
	.byte 0x00, 0x04, 0x00, 0x00, 0x14, 0x01, 0x00, 0x00
	.word ov02_0224DAA4
	.word ov02_0224DB8C
	.word ov02_0224DB9C
	.word ov02_0224DC58

	.global ov02_02253944
ov02_02253944: ; 0x02253944
	.byte 0x00, 0x04, 0x00, 0x00, 0xCC, 0x01, 0x00, 0x00
	.word ov02_0224D43C
	.word ov02_0224D468
	.word ov02_0224D488
	.word ov02_0224D580

	.global ov02_0225395C
ov02_0225395C: ; 0x0225395C
	.byte 0x00, 0x04, 0x00, 0x00, 0x10, 0x0D, 0x00, 0x00
	.word ov02_0224D880
	.word ov02_0224D914
	.word ov02_0224D950
	.word ov02_0224D98C

	.global ov02_02253974
ov02_02253974: ; 0x02253974
	.byte 0x00, 0x04, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00
	.word ov02_0224D1E4
	.word ov02_0224D278
	.word ov02_0224D288
	.word ov02_0224D2BC

	.global ov02_0225398C
ov02_0225398C: ; 0x0225398C
	.byte 0x00, 0x04, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00
	.word ov02_0224D358
	.word ov02_0224D3A4
	.word ov02_0224D3B4
	.word ov02_0224D3E8

	.global ov02_022539A4
ov02_022539A4: ; 0x022539A4
	.byte 0x00, 0x04, 0x00, 0x00, 0x14, 0x01, 0x00, 0x00
	.word ov02_0224D9C0
	.word ov02_0224DB8C
	.word ov02_0224DB9C
	.word ov02_0224DC58

	.global ov02_022539BC
ov02_022539BC: ; 0x022539BC
	.byte 0x00, 0x04, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00
	.word ov02_0224D22C
	.word ov02_0224D278
	.word ov02_0224D288
	.word ov02_0224D2BC

	.global ov02_022539D4
ov02_022539D4: ; 0x022539D4
	.byte 0x00, 0x04, 0x00, 0x00, 0x9C, 0x0E, 0x00, 0x00
	.word ov02_0224DCB0
	.word ov02_0224DD4C
	.word ov02_0224DD8C
	.word ov02_0224DDC8

	.global ov02_022539EC
ov02_022539EC: ; 0x022539EC
	.byte 0x00, 0x04, 0x00, 0x00, 0x9C, 0x0E, 0x00, 0x00
	.word ov02_0224DD38
	.word ov02_0224DD4C
	.word ov02_0224DD8C
	.word ov02_0224DDC8

	.global ov02_02253A04
ov02_02253A04: ; 0x02253A04
	.word ov02_0224D2F0
	.word ov02_0224D41C
	.word ov02_0224D41C
	.word ov02_0224D2F0
	.word ov02_0224DC8C
	.word ov02_0224DC8C

	.global ov02_02253A1C
ov02_02253A1C: ; 0x02253A1C
	.word ov02_0224D2C8
	.word ov02_0224D3F4
	.word ov02_0224D408
	.word ov02_0224D2DC
	.word ov02_0224DC64
	.word ov02_0224DC78

	.global ov02_02253A34
ov02_02253A34: ; 0x02253A34
	.word ov02_0224D2F8
	.word ov02_0224D424
	.word ov02_0224D424
	.word ov02_0224D2F8
	.word ov02_0224DC94
	.word ov02_0224DC94

	.global ov02_02253A4C
ov02_02253A4C: ; 0x02253A4C
	.byte 0xFF, 0x01, 0xFF, 0x01
	.byte 0x01, 0xFF, 0x00, 0x00

ov02_02253A54: ; 0x02253A54
	.byte 0x01, 0x02, 0x04, 0x08, 0x10, 0x00, 0x00, 0x00

	.global ov02_02253A5C
ov02_02253A5C: ; 0x02253A5C
	.byte 0xB5, 0x00, 0x00, 0x00
	.byte 0xB6, 0x00, 0x00, 0x00, 0xB7, 0x00, 0x00, 0x00, 0xB8, 0x00, 0x00, 0x00, 0xB9, 0x00, 0x00, 0x00

ov02_02253A70: ; 0x02253A70
	.byte 0x49, 0x00, 0x01, 0x00, 0x30, 0x00, 0x01, 0x00, 0x3E, 0x00, 0x01, 0x00, 0x4A, 0x00, 0x01, 0x00
	.byte 0xFE, 0x00, 0x00, 0x00, 0x49, 0x00, 0x01, 0x00, 0x31, 0x00, 0x01, 0x00, 0x3E, 0x00, 0x01, 0x00
	.byte 0x4A, 0x00, 0x01, 0x00, 0xFE, 0x00, 0x00, 0x00, 0x49, 0x00, 0x01, 0x00, 0x32, 0x00, 0x01, 0x00
	.byte 0x3E, 0x00, 0x01, 0x00, 0x4A, 0x00, 0x01, 0x00, 0xFE, 0x00, 0x00, 0x00, 0x49, 0x00, 0x01, 0x00
	.byte 0x33, 0x00, 0x01, 0x00, 0x3E, 0x00, 0x01, 0x00, 0x4A, 0x00, 0x01, 0x00, 0xFE, 0x00, 0x00, 0x00

	.global ov02_02253AC0
ov02_02253AC0: ; 0x02253AC0
	.byte 0x04, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
	.byte 0x06, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
	.byte 0x06, 0x00, 0x00, 0x00

ov02_02253B24: ; 0x02253B24
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00

ov02_02253B30: ; 0x02253B30
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00

	.data

	.global ov02_02253D90
ov02_02253D90: ; 0x02253D90
	.byte 0x00, 0xB8, 0xFF, 0xFF

	.global ov02_02253D94
ov02_02253D94: ; 0x02253D94
	.byte 0x00, 0xC0, 0x00, 0x00

	.global ov02_02253D98
ov02_02253D98: ; 0x02253D98
	.byte 0x00, 0xB8, 0xFF, 0xFF, 0x00, 0x48, 0x00, 0x00
	.byte 0x00, 0xC0, 0x00, 0x00, 0x00, 0xB8, 0xFF, 0xFF, 0x00, 0xB8, 0xFF, 0xFF, 0x00, 0xC0, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0xB8, 0xFF, 0xFF, 0x00, 0xC0, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00
	.byte 0x00, 0xC0, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00

	.global ov02_02253DD8
ov02_02253DD8: ; 0x02253DD8
	.byte 0x00, 0xB8, 0xFF, 0xFF

	.global ov02_02253DDC
ov02_02253DDC: ; 0x02253DDC
	.byte 0x00, 0xC0, 0x00, 0x00

	.global ov02_02253DE0
ov02_02253DE0: ; 0x02253DE0
	.byte 0x00, 0xB8, 0xFF, 0xFF, 0x00, 0x48, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00, 0xB8, 0xFF, 0xFF
	.byte 0x00, 0xB8, 0xFF, 0xFF, 0x00, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00
	.byte 0x00, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xB8, 0xFF, 0xFF, 0x00, 0xC0, 0x00, 0x00
	.byte 0x00, 0x48, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00, 0x48, 0x00, 0x00
_02253E20:
