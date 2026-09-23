#include "constants/sndseq.h"
	.include "asm/macros.inc"
	.include "overlay_trainer_card_main.inc"
	.include "global.inc"

.public ov51_021E6F18
.public _021E7DB8
.public ov51_021E71D0
.public ov51_021E7208
.public ov51_021E74D4
.public ov51_021E757C
.public ov51_021E7664
.public ov51_021E76A4
.public ov51_021E76EC
.public ov51_021E77A0
.public ov51_021E7804
.public ov51_021E786C
.public ov51_021E78D0
.public ov51_021E78F8
.public ov51_021E7AF4
.public ov51_021E7BD0
.public ov51_021E7CA4
.public ov51_021E7D44
.public ov51_021E7DA4
.public ov51_021E7DBC
.public ov51_021E7DC0
.public ov51_021E7DC8
.public ov51_021E7DD8
.public ov51_021E7DF0
.public ov51_021E7E08
.public ov51_021E7E20
.public ov51_021E7E38
.public ov51_021E7E54
.public ov51_021E7E70
.public ov51_021E7E8C
.public ov51_021E7EA8
.public ov51_021E7ED0
.public ov51_021E7F08
.public ov51_021E7F48

	.text

	thumb_func_start TrainerCardMainApp_Init
TrainerCardMainApp_Init: ; 0x021E5AC0
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
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
	ldr r0, _021E5D44 ; =0xFFFFE0FF
	and r1, r0
	str r1, [r2]
	ldr r2, _021E5D48 ; =0x04001000
	ldr r1, [r2]
	and r0, r1
	str r0, [r2]
	mov r0, #0
	add r1, r0, #0
	bl sub_0200FBF4
	mov r0, #1
	mov r1, #0
	bl sub_0200FBF4
	mov r0, #0
	bl ResetVisibleHardwareWindows
	mov r0, #1
	bl ResetVisibleHardwareWindows
	mov r0, #4
	mov r1, #8
	bl SetKeyRepeatTimers
	mov r2, #5
	mov r0, #3
	mov r1, #0x19
	lsl r2, r2, #0x10
	bl Heap_Create
	ldr r1, _021E5D4C ; =0x00003444
	add r0, r5, #0
	mov r2, #0x19
	bl OverlayManager_CreateAndGetData
	ldr r2, _021E5D4C ; =0x00003444
	mov r1, #0
	add r4, r0, #0
	bl memset
	add r0, r5, #0
	bl OverlayManager_GetArgs
	add r1, r4, #0
	add r1, #0xe4
	str r0, [r1]
	add r0, r4, #0
	add r0, #0xe4
	ldr r1, [r0]
	add r0, r4, #0
	add r0, #0xe8
	str r1, [r0]
	add r0, r4, #0
	add r0, #0xe4
	ldr r1, [r0]
	ldr r0, _021E5D50 ; =0x0000066C
	ldr r0, [r1, r0]
	bl MenuInputStateMgr_GetState
	ldr r1, _021E5D54 ; =0x0000310C
	str r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xe4
	ldr r1, [r0]
	mov r0, #0x67
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl Save_PlayerData_GetOptionsAddr
	add r5, r0, #0
	bl Options_GetTextFrameDelay
	ldr r1, _021E5D58 ; =0x0000343E
	strb r0, [r4, r1]
	add r0, r5, #0
	bl Options_GetFrame
	ldr r1, _021E5D5C ; =0x0000343D
	strb r0, [r4, r1]
	bl sub_02037474
	cmp r0, #1
	bne _021E5B96
	ldr r1, _021E5D60 ; =0x0000343A
	mov r0, #2
	ldrb r2, [r4, r1]
	orr r0, r2
	strb r0, [r4, r1]
_021E5B96:
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldr r1, _021E5D60 ; =0x0000343A
	add r0, #0x33
	ldrb r0, [r0]
	cmp r0, #0
	beq _021E5BB4
	ldrb r2, [r4, r1]
	mov r0, #1
	bic r2, r0
	mov r0, #1
	orr r0, r2
	strb r0, [r4, r1]
	b _021E5BBC
_021E5BB4:
	ldrb r2, [r4, r1]
	mov r0, #1
	bic r2, r0
	strb r2, [r4, r1]
_021E5BBC:
	ldr r2, _021E5D60 ; =0x0000343A
	ldrb r0, [r4, r2]
	lsl r1, r0, #0x1e
	lsr r1, r1, #0x1f
	cmp r1, #1
	bne _021E5BDC
	add r1, r4, #0
	add r1, #0xe4
	ldr r3, [r1]
	ldr r1, _021E5D64 ; =0x00000678
	ldr r1, [r3, r1]
	cmp r1, #0
	bne _021E5BDC
	mov r1, #1
	bic r0, r1
	strb r0, [r4, r2]
_021E5BDC:
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldrb r0, [r0]
	add r0, #0xf9
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r0, #1
	bhi _021E5C1C
	ldr r7, _021E5D68 ; =0x00003424
	mov r3, #1
	mov r2, #0
	add r0, r2, #0
	add r1, r3, #0
	add r5, r7, #0
_021E5BFA:
	add r6, r4, #0
	add r6, #0xe8
	ldr r6, [r6]
	ldrh r6, [r6, #6]
	tst r6, r3
	beq _021E5C0C
	add r6, r4, r2
	strb r1, [r6, r5]
	b _021E5C10
_021E5C0C:
	add r6, r4, r2
	strb r0, [r6, r7]
_021E5C10:
	lsl r3, r3, #0x11
	add r2, r2, #1
	lsr r3, r3, #0x10
	cmp r2, #0x10
	blt _021E5BFA
	b _021E5C2C
_021E5C1C:
	mov r3, #0
	ldr r0, _021E5D68 ; =0x00003424
	add r2, r3, #0
_021E5C22:
	add r1, r4, r3
	add r3, r3, #1
	strb r2, [r1, r0]
	cmp r3, #0x10
	blt _021E5C22
_021E5C2C:
	mov r0, #0x19
	bl BgConfig_Alloc
	str r0, [r4]
	add r0, r4, #0
	bl ov51_021E5F64
	bl ov51_021E60D4
	ldr r0, [r4]
	bl ov51_021E6238
	add r0, r4, #0
	bl ov51_021E6354
	bl sub_020210BC
	mov r0, #4
	bl sub_02021148
	mov r0, #1
	bl TextFlags_SetCanTouchSpeedUpPrint
	mov r0, #1
	bl TextFlags_SetCanABSpeedUpPrint
	mov r1, #0
	mov r0, #0x38
	add r2, r1, #0
	bl Sound_SetSceneAndPlayBGM
	ldr r0, _021E5D6C ; =0x000033A0
	add r0, r4, r0
	bl ov51_021E7DA4
	ldr r0, _021E5D70 ; =SEQ_SE_DP_CARD3
	bl PlaySE
	ldr r0, _021E5D74 ; =0x0000311C
	add r0, r4, r0
	bl ov51_021E78F8
	ldr r2, _021E5D68 ; =0x00003424
	ldr r0, _021E5D74 ; =0x0000311C
	add r1, r4, r2
	add r2, #0x16
	ldrb r2, [r4, r2]
	add r0, r4, r0
	lsl r2, r2, #0x1f
	lsr r2, r2, #0x1f
	bl ov51_021E7AF4
	ldr r0, _021E5D74 ; =0x0000311C
	add r0, r4, r0
	bl ov51_021E7BD0
	add r0, r4, #0
	bl ov51_021E6E60
	ldr r2, _021E5D78 ; =0x000033CC
	add r0, r4, #0
	ldr r2, [r4, r2]
	add r0, #0x54
	mov r1, #1
	bl ov51_021E7664
	add r0, r4, #0
	add r0, #0xe4
	ldr r1, [r0]
	ldr r0, _021E5D7C ; =0x00000674
	ldr r0, [r1, r0]
	cmp r0, #0
	beq _021E5CC2
	mov r1, #1
	b _021E5CC4
_021E5CC2:
	mov r1, #0
_021E5CC4:
	ldr r0, _021E5D80 ; =0x000030F4
	str r1, [r4, r0]
	add r1, r4, #0
	add r1, #0xe4
	ldr r2, [r1]
	mov r0, #0
	ldr r1, _021E5D7C ; =0x00000674
	sub r3, r0, #1
	str r0, [r2, r1]
	ldr r1, _021E5D84 ; =0x00003434
	ldr r2, _021E5D88 ; =0x00003108
	strb r0, [r4, r1]
	str r3, [r4, r2]
	add r2, r1, #0
	sub r2, #0x98
	str r0, [r4, r2]
	add r1, r1, #4
	strb r0, [r4, r1]
	bl ov51_021E6C00
	add r0, r4, #0
	bl ov51_021E6734
	add r0, r4, #0
	mov r1, #0
	bl ov51_021E76A4
	ldr r0, _021E5D8C ; =ov51_021E6B88
	add r1, r4, #0
	bl Main_SetVBlankIntrCB
	bl sub_0203A964
	mov r0, #1
	mov r1, #0x2a
	bl GF_SndHandleSetPlayerVolume
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x19
	mov r1, #3
	str r0, [sp, #8]
	mov r0, #2
	add r2, r1, #0
	mov r3, #0
	bl BeginNormalPaletteFade
	add r4, #0xe8
	ldr r0, [r4]
	ldrb r0, [r0]
	cmp r0, #7
	beq _021E5D3C
	cmp r0, #8
	beq _021E5D3C
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
_021E5D3C:
	mov r0, #1
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021E5D44: .word 0xFFFFE0FF
_021E5D48: .word 0x04001000
_021E5D4C: .word 0x00003444
_021E5D50: .word 0x0000066C
_021E5D54: .word 0x0000310C
_021E5D58: .word 0x0000343E
_021E5D5C: .word 0x0000343D
_021E5D60: .word 0x0000343A
_021E5D64: .word 0x00000678
_021E5D68: .word 0x00003424
_021E5D6C: .word 0x000033A0
_021E5D70: .word SEQ_SE_DP_CARD3
_021E5D74: .word 0x0000311C
_021E5D78: .word 0x000033CC
_021E5D7C: .word 0x00000674
_021E5D80: .word 0x000030F4
_021E5D84: .word 0x00003434
_021E5D88: .word 0x00003108
_021E5D8C: .word ov51_021E6B88
	thumb_func_end TrainerCardMainApp_Init

	thumb_func_start TrainerCardMainApp_Main
TrainerCardMainApp_Main: ; 0x021E5D90
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r1, #0
	bl OverlayManager_GetData
	ldr r1, [r5]
	add r4, r0, #0
	cmp r1, #5
	bhi _021E5E96
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E5DAE: ; jump table
	.short _021E5DBA - _021E5DAE - 2 ; case 0
	.short _021E5DC8 - _021E5DAE - 2 ; case 1
	.short _021E5E3A - _021E5DAE - 2 ; case 2
	.short _021E5E48 - _021E5DAE - 2 ; case 3
	.short _021E5E56 - _021E5DAE - 2 ; case 4
	.short _021E5E70 - _021E5DAE - 2 ; case 5
_021E5DBA:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021E5E96
	mov r0, #1
	str r0, [r5]
	b _021E5E96
_021E5DC8:
	bl ov51_021E6B44
	cmp r0, #3
	bne _021E5DDC
	ldr r0, _021E5EB8 ; =0x00003436
	mov r1, #0
	strb r1, [r4, r0]
	mov r0, #3
	str r0, [r5]
	b _021E5E26
_021E5DDC:
	cmp r0, #4
	bne _021E5DFA
	ldr r0, _021E5EBC ; =0x0000311C
	mov r1, #1
	add r0, r4, r0
	mov r2, #3
	add r3, r1, #0
	bl ov51_021E7D44
	ldr r0, _021E5EB8 ; =0x00003436
	mov r1, #0
	strb r1, [r4, r0]
	mov r0, #4
	str r0, [r5]
	b _021E5E26
_021E5DFA:
	cmp r0, #5
	bne _021E5E26
	ldr r0, _021E5EBC ; =0x0000311C
	mov r2, #1
	add r0, r4, r0
	mov r1, #0
	add r3, r2, #0
	bl ov51_021E7D44
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r1, #0x19
	str r1, [sp, #8]
	mov r1, #4
	add r2, r1, #0
	mov r3, #0
	bl BeginNormalPaletteFade
	mov r0, #2
	str r0, [r5]
_021E5E26:
	add r1, r4, #0
	add r1, #0xe8
	ldr r1, [r1]
	add r0, r4, #0
	ldrb r1, [r1, #4]
	lsl r1, r1, #0x1e
	lsr r1, r1, #0x1f
	bl ov51_021E6DA8
	b _021E5E96
_021E5E3A:
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _021E5E96
	add sp, #0xc
	mov r0, #1
	pop {r4, r5, pc}
_021E5E48:
	bl ov51_021E6888
	cmp r0, #0
	beq _021E5E96
	mov r0, #1
	str r0, [r5]
	b _021E5E96
_021E5E56:
	bl ov51_021E67A4
	cmp r0, #1
	beq _021E5E64
	cmp r0, #2
	beq _021E5E6A
	b _021E5E96
_021E5E64:
	mov r0, #1
	str r0, [r5]
	b _021E5E96
_021E5E6A:
	mov r0, #5
	str r0, [r5]
	b _021E5E96
_021E5E70:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r1, #0x19
	str r1, [sp, #8]
	mov r1, #4
	add r2, r1, #0
	mov r3, #0
	bl BeginNormalPaletteFade
	add r0, r4, #0
	add r0, #0xe4
	ldr r1, [r0]
	ldr r0, _021E5EC0 ; =0x00000674
	mov r2, #1
	str r2, [r1, r0]
	mov r0, #2
	str r0, [r5]
_021E5E96:
	ldr r0, _021E5EC4 ; =0x0000343F
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	ldrb r1, [r4, r0]
	cmp r1, #0x80
	blo _021E5EA8
	mov r1, #0
	strb r1, [r4, r0]
_021E5EA8:
	ldr r0, _021E5EBC ; =0x0000311C
	ldr r0, [r4, r0]
	bl SpriteList_RenderAndAnimateSprites
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_021E5EB8: .word 0x00003436
_021E5EBC: .word 0x0000311C
_021E5EC0: .word 0x00000674
_021E5EC4: .word 0x0000343F
	thumb_func_end TrainerCardMainApp_Main

	thumb_func_start TrainerCardMainApp_Exit
TrainerCardMainApp_Exit: ; 0x021E5EC8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	bl ov51_021E6C00
	add r0, r4, #0
	bl ov51_021E6038
	ldr r0, _021E5F4C ; =0x0000311C
	add r0, r4, r0
	bl ov51_021E7CA4
	ldr r0, _021E5F50 ; =0x000030EC
	ldr r0, [r4, r0]
	bl Heap_Free
	ldr r0, _021E5F54 ; =0x000033B8
	ldr r0, [r4, r0]
	bl Heap_Free
	ldr r0, _021E5F58 ; =0x000033B0
	ldr r0, [r4, r0]
	bl Heap_Free
	add r0, r4, #0
	bl ov51_021E6EF0
	ldr r0, [r4]
	bl ov51_021E6644
	bl sub_02021238
	mov r0, #0
	bl TextFlags_SetCanTouchSpeedUpPrint
	mov r0, #0
	bl TextFlags_SetCanABSpeedUpPrint
	add r0, r4, #0
	add r0, #0xe4
	ldr r1, [r0]
	ldr r0, _021E5F5C ; =0x0000066C
	ldr r0, [r1, r0]
	ldr r1, _021E5F60 ; =0x0000310C
	ldr r1, [r4, r1]
	bl MenuInputStateMgr_SetState
	add r0, r5, #0
	bl OverlayManager_FreeData
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	mov r0, #0x19
	bl Heap_Destroy
	mov r0, #1
	mov r1, #0x7f
	bl GF_SndHandleSetPlayerVolume
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_021E5F4C: .word 0x0000311C
_021E5F50: .word 0x000030EC
_021E5F54: .word 0x000033B8
_021E5F58: .word 0x000033B0
_021E5F5C: .word 0x0000066C
_021E5F60: .word 0x0000310C
	thumb_func_end TrainerCardMainApp_Exit

	thumb_func_start ov51_021E5F64
ov51_021E5F64: ; 0x021E5F64
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #4
	mov r1, #0x19
	bl FontID_Alloc
	ldr r2, _021E6014 ; =0x000002D7
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x19
	bl NewMsgDataFromNarc
	ldr r1, _021E6018 ; =0x000033C4
	str r0, [r5, r1]
	mov r0, #4
	mov r1, #0x19
	bl String_New
	ldr r1, _021E601C ; =0x000033C8
	str r0, [r5, r1]
	mov r0, #0x20
	mov r1, #0x19
	bl String_New
	ldr r1, _021E6020 ; =0x000033D0
	str r0, [r5, r1]
	mov r0, #0xa
	mov r1, #0x19
	bl String_New
	ldr r1, _021E6024 ; =0x000033D4
	str r0, [r5, r1]
	mov r0, #5
	mov r1, #0x19
	bl String_New
	ldr r2, _021E6028 ; =0x000033CC
	mov r1, #0xb
	str r0, [r5, r2]
	add r0, r2, #0
	sub r0, #8
	ldr r0, [r5, r0]
	ldr r2, [r5, r2]
	bl ReadMsgDataIntoString
	ldr r7, _021E602C ; =0x000033D8
	mov r6, #0
	add r4, r5, #0
_021E5FC4:
	ldr r0, _021E6018 ; =0x000033C4
	add r1, r6, #0
	ldr r0, [r5, r0]
	add r1, #0xe
	bl NewString_ReadMsgData
	str r0, [r4, r7]
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #3
	blt _021E5FC4
	ldr r7, _021E6030 ; =0x000033E4
	mov r4, #0
	add r6, r5, #0
_021E5FE0:
	ldr r0, _021E6018 ; =0x000033C4
	add r1, r4, #0
	ldr r0, [r5, r0]
	add r1, #0x11
	bl NewString_ReadMsgData
	str r0, [r6, r7]
	add r4, r4, #1
	add r6, r6, #4
	cmp r4, #2
	blt _021E5FE0
	ldr r7, _021E6034 ; =0x000033EC
	mov r4, #0
	add r6, r5, #0
_021E5FFC:
	ldr r0, _021E6018 ; =0x000033C4
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl NewString_ReadMsgData
	str r0, [r6, r7]
	add r4, r4, #1
	add r6, r6, #4
	cmp r4, #0xe
	blt _021E5FFC
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E6014: .word 0x000002D7
_021E6018: .word 0x000033C4
_021E601C: .word 0x000033C8
_021E6020: .word 0x000033D0
_021E6024: .word 0x000033D4
_021E6028: .word 0x000033CC
_021E602C: .word 0x000033D8
_021E6030: .word 0x000033E4
_021E6034: .word 0x000033EC
	thumb_func_end ov51_021E5F64

	thumb_func_start ov51_021E6038
ov51_021E6038: ; 0x021E6038
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r7, _021E60A8 ; =0x000033EC
	mov r4, #0
	add r5, r6, #0
_021E6042:
	ldr r0, [r5, r7]
	bl String_Delete
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #0xe
	blt _021E6042
	ldr r0, _021E60AC ; =0x000033E8
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60B0 ; =0x000033E4
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60B4 ; =0x000033E0
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60B8 ; =0x000033DC
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60BC ; =0x000033D8
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60C0 ; =0x000033CC
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60C4 ; =0x000033D4
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60C8 ; =0x000033D0
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60CC ; =0x000033C8
	ldr r0, [r6, r0]
	bl String_Delete
	ldr r0, _021E60D0 ; =0x000033C4
	ldr r0, [r6, r0]
	bl DestroyMsgData
	mov r0, #4
	bl FontID_Release
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E60A8: .word 0x000033EC
_021E60AC: .word 0x000033E8
_021E60B0: .word 0x000033E4
_021E60B4: .word 0x000033E0
_021E60B8: .word 0x000033DC
_021E60BC: .word 0x000033D8
_021E60C0: .word 0x000033CC
_021E60C4: .word 0x000033D4
_021E60C8: .word 0x000033D0
_021E60CC: .word 0x000033C8
_021E60D0: .word 0x000033C4
	thumb_func_end ov51_021E6038

	thumb_func_start ov51_021E60D4
ov51_021E60D4: ; 0x021E60D4
	push {r4, lr}
	sub sp, #0x28
	ldr r4, _021E60F0 ; =ov51_021E7EA8
	add r3, sp, #0
	mov r2, #5
_021E60DE:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021E60DE
	add r0, sp, #0
	bl GfGfx_SetBanks
	add sp, #0x28
	pop {r4, pc}
	.balign 4, 0
_021E60F0: .word ov51_021E7EA8
	thumb_func_end ov51_021E60D4

	thumb_func_start ov51_021E60F4
ov51_021E60F4: ; 0x021E60F4
	push {r4, r5, lr}
	sub sp, #0x64
	add r3, r0, #0
	add r0, r2, #0
	add r0, #0xf9
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r0, #1
	bhi _021E6132
	cmp r1, #0
	beq _021E612E
	ldr r5, _021E61F0 ; =ov51_021E7E08
	add r4, sp, #0x4c
	add r2, r4, #0
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	cmp r3, #5
	bls _021E6128
	bl GF_AssertFail
	ldr r1, [sp, #0x4c]
	b _021E61B0
_021E6128:
	lsl r0, r3, #2
	ldr r1, [r2, r0]
	b _021E61B0
_021E612E:
	mov r1, #6
	b _021E61B0
_021E6132:
	cmp r2, #0xa
	bne _021E615A
	ldr r5, _021E61F4 ; =ov51_021E7DF0
	add r4, sp, #0x34
	add r2, r4, #0
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	cmp r3, #5
	bls _021E6154
	bl GF_AssertFail
	ldr r1, [sp, #0x34]
	b _021E61B0
_021E6154:
	lsl r0, r3, #2
	ldr r1, [r2, r0]
	b _021E61B0
_021E615A:
	cmp r2, #0xb
	bne _021E6182
	ldr r5, _021E61F8 ; =ov51_021E7E20
	add r4, sp, #0x1c
	add r2, r4, #0
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	cmp r3, #5
	bls _021E617C
	bl GF_AssertFail
	ldr r1, [sp, #0x1c]
	b _021E61B0
_021E617C:
	lsl r0, r3, #2
	ldr r1, [r2, r0]
	b _021E61B0
_021E6182:
	cmp r2, #0xc
	bne _021E61AA
	ldr r5, _021E61FC ; =ov51_021E7DD8
	add r4, sp, #4
	add r2, r4, #0
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r4!, {r0, r1}
	cmp r3, #5
	bls _021E61A4
	bl GF_AssertFail
	ldr r1, [sp, #4]
	b _021E61B0
_021E61A4:
	lsl r0, r3, #2
	ldr r1, [r2, r0]
	b _021E61B0
_021E61AA:
	bl GF_AssertFail
	mov r1, #0
_021E61B0:
	mov r0, #0x31
	add r2, sp, #0
	mov r3, #0x19
	bl GfGfxLoader_GetPlttData
	add r4, r0, #0
	ldr r0, [sp]
	mov r1, #2
	ldr r0, [r0, #0xc]
	lsl r1, r1, #8
	bl DC_FlushRange
	ldr r0, [sp]
	mov r1, #0x20
	ldr r5, [r0, #0xc]
	add r2, r1, #0
	add r0, r5, #0
	add r0, #0x20
	add r2, #0xe0
	bl GXS_LoadBGPltt
	mov r1, #0x1e
	lsl r1, r1, #4
	add r0, r5, r1
	mov r2, #0x20
	bl GXS_LoadBGPltt
	add r0, r4, #0
	bl Heap_Free
	add sp, #0x64
	pop {r4, r5, pc}
	.balign 4, 0
_021E61F0: .word ov51_021E7E08
_021E61F4: .word ov51_021E7DF0
_021E61F8: .word ov51_021E7E20
_021E61FC: .word ov51_021E7DD8
	thumb_func_end ov51_021E60F4

	thumb_func_start ov51_021E6200
ov51_021E6200: ; 0x021E6200
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r4, r0, #0
	mov r0, #0x31
	mov r1, #0x3c
	add r2, sp, #0
	mov r3, #0x19
	bl GfGfxLoader_GetPlttData
	add r6, r0, #0
	ldr r0, [sp]
	lsl r4, r4, #5
	ldr r5, [r0, #0xc]
	mov r1, #0x20
	add r0, r5, r4
	bl DC_FlushRange
	add r0, r5, r4
	mov r1, #0x80
	mov r2, #0x20
	bl GXS_LoadBGPltt
	add r0, r6, #0
	bl Heap_Free
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov51_021E6200

	thumb_func_start ov51_021E6238
ov51_021E6238: ; 0x021E6238
	push {r3, r4, r5, lr}
	sub sp, #0xb8
	ldr r2, _021E6338 ; =0x04000304
	add r4, r0, #0
	ldrh r1, [r2]
	lsr r0, r2, #0xb
	ldr r5, _021E633C ; =ov51_021E7DC8
	orr r0, r1
	strh r0, [r2]
	add r3, sp, #0xa8
	add r2, r3, #0
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r2, #0
	bl SetBothScreensModesAndDisable
	ldr r5, _021E6340 ; =ov51_021E7E8C
	add r3, sp, #0x8c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #7
	str r0, [r3]
	add r0, r4, #0
	mov r3, #2
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E6344 ; =ov51_021E7ED0
	add r3, sp, #0x54
	mov r2, #7
_021E628A:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021E628A
	add r0, r4, #0
	mov r1, #4
	add r2, sp, #0x54
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	add r0, r4, #0
	mov r1, #5
	add r2, sp, #0x70
	mov r3, #0
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #5
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E6348 ; =ov51_021E7E70
	add r3, sp, #0x38
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #6
	str r0, [r3]
	add r0, r4, #0
	mov r3, #2
	bl InitBgFromTemplate
	add r0, r4, #0
	mov r1, #6
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E634C ; =ov51_021E7E38
	add r3, sp, #0x1c
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
	add r0, r4, #0
	mov r1, #2
	bl BgClearTilemapBufferAndCommit
	ldr r5, _021E6350 ; =ov51_021E7E54
	add r3, sp, #0
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
	add r0, r4, #0
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	add sp, #0xb8
	pop {r3, r4, r5, pc}
	nop
_021E6338: .word 0x04000304
_021E633C: .word ov51_021E7DC8
_021E6340: .word ov51_021E7E8C
_021E6344: .word ov51_021E7ED0
_021E6348: .word ov51_021E7E70
_021E634C: .word ov51_021E7E38
_021E6350: .word ov51_021E7E54
	thumb_func_end ov51_021E6238

	thumb_func_start ov51_021E6354
ov51_021E6354: ; 0x021E6354
	push {r4, r5, lr}
	sub sp, #0x24
	add r4, r0, #0
	mov r0, #0x31
	mov r1, #0
	add r2, sp, #0x20
	mov r3, #0x19
	bl GfGfxLoader_GetPlttData
	add r5, r0, #0
	ldr r0, [sp, #0x20]
	mov r1, #2
	ldr r0, [r0, #0xc]
	lsl r1, r1, #8
	bl DC_FlushRange
	ldr r0, [sp, #0x20]
	mov r2, #2
	ldr r0, [r0, #0xc]
	mov r1, #0
	lsl r2, r2, #8
	bl GXS_LoadBGPltt
	add r0, r5, #0
	bl Heap_Free
	add r0, r4, #0
	add r0, #0xe8
	ldr r2, [r0]
	ldrb r1, [r2, #4]
	ldrb r0, [r2, #3]
	ldrb r2, [r2]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1f
	bl ov51_021E60F4
	mov r0, #0x31
	mov r1, #0x1c
	add r2, sp, #0x1c
	mov r3, #0x19
	bl GfGfxLoader_GetPlttData
	add r5, r0, #0
	ldr r0, [sp, #0x1c]
	mov r1, #2
	ldr r0, [r0, #0xc]
	lsl r1, r1, #8
	bl DC_FlushRange
	ldr r0, [sp, #0x1c]
	mov r2, #2
	ldr r0, [r0, #0xc]
	mov r1, #0
	lsl r2, r2, #8
	bl GX_LoadBGPltt
	add r0, r5, #0
	bl Heap_Free
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldrb r1, [r0, #5]
	cmp r1, #0xff
	bne _021E6442
	mov r2, #0
	mov r0, #0x31
	mov r1, #0x2c
	mov r3, #0x19
	str r2, [sp]
	bl GfGfxLoader_LoadFromNarc
	ldr r1, _021E6624 ; =0x000030EC
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	cmp r0, #0
	bne _021E63F2
	bl GF_AssertFail
_021E63F2:
	ldr r1, _021E6624 ; =0x000030EC
	ldr r0, [r4, r1]
	add r1, r1, #4
	add r1, r4, r1
	bl NNS_G2dGetUnpackedBGCharacterData
	cmp r0, #0
	bne _021E6406
	bl GF_AssertFail
_021E6406:
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldr r3, _021E6628 ; =0x000033B4
	ldrb r0, [r0, #4]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	bne _021E642C
	mov r0, #0x19
	str r0, [sp]
	mov r0, #0x31
	mov r1, #0x36
	mov r2, #0
	add r3, r4, r3
	bl GfGfxLoader_GetScrnData
	ldr r1, _021E662C ; =0x000033B0
	str r0, [r4, r1]
	b _021E6498
_021E642C:
	mov r0, #0x19
	str r0, [sp]
	mov r0, #0x31
	mov r1, #0x37
	mov r2, #0
	add r3, r4, r3
	bl GfGfxLoader_GetScrnData
	ldr r1, _021E662C ; =0x000033B0
	str r0, [r4, r1]
	b _021E6498
_021E6442:
	lsl r3, r1, #2
	ldr r1, _021E6630 ; =ov51_021E7F08
	mov r2, #0
	ldr r1, [r1, r3]
	mov r0, #0x31
	mov r3, #0x19
	str r2, [sp]
	bl GfGfxLoader_LoadFromNarc
	ldr r1, _021E6624 ; =0x000030EC
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	cmp r0, #0
	bne _021E6462
	bl GF_AssertFail
_021E6462:
	ldr r1, _021E6624 ; =0x000030EC
	ldr r0, [r4, r1]
	add r1, r1, #4
	add r1, r4, r1
	bl NNS_G2dGetUnpackedBGCharacterData
	cmp r0, #0
	bne _021E6476
	bl GF_AssertFail
_021E6476:
	ldr r3, _021E6628 ; =0x000033B4
	mov r0, #0x19
	str r0, [sp]
	mov r0, #0x31
	mov r1, #0x3d
	mov r2, #0
	add r3, r4, r3
	bl GfGfxLoader_GetScrnData
	ldr r1, _021E662C ; =0x000033B0
	str r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldrb r0, [r0, #5]
	bl ov51_021E6200
_021E6498:
	add r0, r4, #0
	bl ov51_021E6C6C
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x29
	mov r3, #6
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x2f
	mov r3, #6
	bl GfGfxLoader_LoadScrnData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x2a
	mov r3, #5
	bl GfGfxLoader_LoadCharData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	mov r0, #0x31
	ldr r2, [r4]
	add r1, r0, #0
	mov r3, #5
	bl GfGfxLoader_LoadScrnData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x2b
	mov r3, #2
	bl GfGfxLoader_LoadCharData
	ldr r3, _021E6634 ; =0x000033BC
	mov r0, #0x19
	str r0, [sp]
	mov r0, #0x31
	mov r1, #0x35
	mov r2, #0
	add r3, r4, r3
	bl GfGfxLoader_GetScrnData
	ldr r1, _021E6638 ; =0x000033B8
	str r0, [r4, r1]
	add r1, #0x82
	ldrb r0, [r4, r1]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	beq _021E6550
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x34
	mov r3, #2
	bl GfGfxLoader_LoadScrnData
	b _021E6568
_021E6550:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x33
	mov r3, #2
	bl GfGfxLoader_LoadScrnData
_021E6568:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x32
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
	ldr r1, _021E663C ; =0x0000343A
	ldrb r0, [r4, r1]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	bne _021E65C8
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldrh r0, [r0, #6]
	cmp r0, #0xff
	blo _021E65C8
	sub r1, #0x7e
	ldr r0, [r4, r1]
	mov r3, #7
	str r3, [sp]
	mov r1, #9
	str r1, [sp, #4]
	add r1, r0, #0
	add r1, #0xc
	str r1, [sp, #8]
	mov r2, #0
	str r2, [sp, #0xc]
	str r2, [sp, #0x10]
	ldrh r1, [r0]
	lsl r1, r1, #0x15
	lsr r1, r1, #0x18
	str r1, [sp, #0x14]
	ldrh r0, [r0, #2]
	mov r1, #2
	lsl r0, r0, #0x15
	lsr r0, r0, #0x18
	str r0, [sp, #0x18]
	ldr r0, [r4]
	bl CopyToBgTilemapRect
	b _021E6608
_021E65C8:
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldrh r1, [r0, #6]
	ldr r0, _021E6640 ; =0x0000FFFF
	cmp r1, r0
	bne _021E6608
	ldr r0, _021E6634 ; =0x000033BC
	mov r2, #7
	ldr r0, [r4, r0]
	mov r1, #9
	str r2, [sp]
	str r1, [sp, #4]
	add r1, r0, #0
	add r1, #0xc
	str r1, [sp, #8]
	str r2, [sp, #0xc]
	mov r2, #0
	str r2, [sp, #0x10]
	ldrh r1, [r0]
	mov r3, #0xe
	lsl r1, r1, #0x15
	lsr r1, r1, #0x18
	str r1, [sp, #0x14]
	ldrh r0, [r0, #2]
	mov r1, #2
	lsl r0, r0, #0x15
	lsr r0, r0, #0x18
	str r0, [sp, #0x18]
	ldr r0, [r4]
	bl CopyToBgTilemapRect
_021E6608:
	ldr r0, [r4]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	add r4, #0xec
	add r0, #0x68
	add r1, r4, #0
	bl ov51_021E6CF0
	add sp, #0x24
	pop {r4, r5, pc}
	.balign 4, 0
_021E6624: .word 0x000030EC
_021E6628: .word 0x000033B4
_021E662C: .word 0x000033B0
_021E6630: .word ov51_021E7F08
_021E6634: .word 0x000033BC
_021E6638: .word 0x000033B8
_021E663C: .word 0x0000343A
_021E6640: .word 0x0000FFFF
	thumb_func_end ov51_021E6354

	thumb_func_start ov51_021E6644
ov51_021E6644: ; 0x021E6644
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x1f
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r2, #0
	add r0, r4, #0
	mov r1, #5
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #5
	mov r2, #3
	mov r3, #0
	bl BgSetPosTextAndCommit
	mov r2, #0
	add r0, r4, #0
	mov r1, #3
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	mov r1, #3
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0
	bl BgSetPosTextAndCommit
	add r0, r4, #0
	mov r1, #7
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #6
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #2
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #3
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov51_021E6644

	thumb_func_start ov51_021E66C0
ov51_021E66C0: ; 0x021E66C0
	push {r4, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, _021E6730 ; =0x000030F4
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _021E66FC
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x2f
	mov r3, #6
	bl GfGfxLoader_LoadScrnData
	add r0, r4, #4
	mov r1, #7
	mov r2, #0xa
	bl ov51_021E74D4
	ldr r0, [r4]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add sp, #0x10
	pop {r4, pc}
_021E66FC:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x19
	str r0, [sp, #0xc]
	ldr r2, [r4]
	mov r0, #0x31
	mov r1, #0x30
	mov r3, #6
	bl GfGfxLoader_LoadScrnData
	add r0, r4, #4
	mov r1, #0
	mov r2, #6
	bl ov51_021E74D4
	add r0, r4, #0
	bl ov51_021E6CCC
	ldr r0, [r4]
	mov r1, #7
	bl BgClearTilemapBufferAndCommit
	add sp, #0x10
	pop {r4, pc}
	.balign 4, 0
_021E6730: .word 0x000030F4
	thumb_func_end ov51_021E66C0

	thumb_func_start ov51_021E6734
ov51_021E6734: ; 0x021E6734
	push {r4, lr}
	add r4, r0, #0
	bl ov51_021E66C0
	ldr r0, _021E679C ; =0x0000311C
	mov r1, #0
	add r0, r4, r0
	add r2, r1, #0
	mov r3, #1
	bl ov51_021E7D44
	ldr r0, _021E67A0 ; =0x000030F4
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _021E6762
	add r0, r4, #0
	bl ov51_021E6C6C
	add r0, r4, #0
	mov r1, #1
	bl ov51_021E76EC
	b _021E6776
_021E6762:
	add r2, r4, #0
	ldr r0, [r4]
	mov r1, #7
	add r2, #0xec
	bl ov51_021E6D44
	add r0, r4, #0
	mov r1, #0
	bl ov51_021E76EC
_021E6776:
	add r2, r4, #0
	add r2, #0xe8
	ldr r2, [r2]
	add r0, r4, #0
	add r1, r4, #4
	bl ov51_021E6F18
	add r2, r4, #0
	add r2, #0xe8
	ldr r2, [r2]
	add r0, r4, #0
	add r1, r4, #4
	bl ov51_021E7208
	add r0, r4, #0
	add r1, r4, #4
	bl ov51_021E71D0
	pop {r4, pc}
	.balign 4, 0
_021E679C: .word 0x0000311C
_021E67A0: .word 0x000030F4
	thumb_func_end ov51_021E6734

	thumb_func_start ov51_021E67A4
ov51_021E67A4: ; 0x021E67A4
	push {r4, lr}
	ldr r1, _021E6884 ; =0x00003436
	add r4, r0, #0
	ldrb r2, [r4, r1]
	cmp r2, #4
	bhi _021E6880
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_021E67BC: ; jump table
	.short _021E67C6 - _021E67BC - 2 ; case 0
	.short _021E67D6 - _021E67BC - 2 ; case 1
	.short _021E6800 - _021E67BC - 2 ; case 2
	.short _021E683E - _021E67BC - 2 ; case 3
	.short _021E6860 - _021E67BC - 2 ; case 4
_021E67C6:
	mov r1, #0
	bl ov51_021E77A0
	ldr r0, _021E6884 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E6880
_021E67D6:
	add r0, r1, #6
	ldrb r0, [r4, r0]
	bl TextPrinterCheckActive
	cmp r0, #0
	beq _021E67E6
	mov r0, #0
	pop {r4, pc}
_021E67E6:
	add r0, r4, #0
	mov r1, #0
	bl ov51_021E7804
	add r0, r4, #0
	mov r1, #1
	bl ov51_021E6E10
	ldr r0, _021E6884 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E6880
_021E6800:
	mov r1, #0
	bl ov51_021E786C
	cmp r0, #0
	blt _021E6880
	bne _021E6818
	add r0, r4, #0
	mov r1, #0
	bl ov51_021E6E10
	mov r0, #1
	pop {r4, pc}
_021E6818:
	add r0, r4, #0
	add r0, #0xe8
	ldr r0, [r0]
	ldrb r0, [r0, #4]
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x1f
	beq _021E6830
	add r0, r4, #0
	mov r1, #1
	bl ov51_021E77A0
	b _021E6834
_021E6830:
	mov r0, #2
	pop {r4, pc}
_021E6834:
	ldr r0, _021E6884 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E6880
_021E683E:
	add r0, r1, #6
	ldrb r0, [r4, r0]
	bl TextPrinterCheckActive
	cmp r0, #0
	beq _021E684E
	mov r0, #0
	pop {r4, pc}
_021E684E:
	add r0, r4, #0
	mov r1, #1
	bl ov51_021E7804
	ldr r0, _021E6884 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E6880
_021E6860:
	mov r1, #1
	bl ov51_021E786C
	cmp r0, #0
	beq _021E6870
	cmp r0, #1
	beq _021E687C
	b _021E6880
_021E6870:
	add r0, r4, #0
	mov r1, #0
	bl ov51_021E6E10
	mov r0, #1
	pop {r4, pc}
_021E687C:
	mov r0, #2
	pop {r4, pc}
_021E6880:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021E6884: .word 0x00003436
	thumb_func_end ov51_021E67A4

	thumb_func_start ov51_021E6888
ov51_021E6888: ; 0x021E6888
	push {r3, r4, r5, r6, r7, lr}
	ldr r1, _021E69D4 ; =0x00003436
	add r4, r0, #0
	ldrb r2, [r4, r1]
	mov r5, #0
	cmp r2, #5
	bls _021E6898
	b _021E69C4
_021E6898:
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_021E68A4: ; jump table
	.short _021E68B0 - _021E68A4 - 2 ; case 0
	.short _021E68DE - _021E68A4 - 2 ; case 1
	.short _021E6918 - _021E68A4 - 2 ; case 2
	.short _021E6930 - _021E68A4 - 2 ; case 3
	.short _021E696E - _021E68A4 - 2 ; case 4
	.short _021E697E - _021E68A4 - 2 ; case 5
_021E68B0:
	mov r0, #8
	sub r1, #0xa2
	str r0, [r4, r1]
	ldr r1, _021E69D8 ; =0x000030FC
	lsl r2, r0, #9
	str r2, [r4, r1]
	add r0, r1, #4
	str r2, [r4, r0]
	ldr r0, [r4, r1]
	add r0, #0x80
	str r0, [r4, r1]
	add r0, r1, #4
	ldr r2, [r4, r0]
	add r2, #0x80
	str r2, [r4, r0]
	ldr r0, _021E69DC ; =SEQ_SE_DP_CARD5
	bl PlaySE
	ldr r0, _021E69D4 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E69C4
_021E68DE:
	add r3, r1, #0
	sub r3, #0xa2
	ldr r7, [r4, r3]
	ldr r6, _021E69D8 ; =0x000030FC
	mov r3, #0xc
	mov r0, #2
	sub r3, r3, r7
	ldr r2, [r4, r6]
	lsl r0, r3
	sub r0, r2, r0
	str r0, [r4, r6]
	ldr r0, [r4, r6]
	cmp r0, #0
	bgt _021E6904
	mov r0, #0x24
	str r0, [r4, r6]
	ldrb r0, [r4, r1]
	add r0, r0, #1
	strb r0, [r4, r1]
_021E6904:
	ldr r0, _021E69E0 ; =0x00003394
	ldr r1, [r4, r0]
	sub r1, r1, #1
	str r1, [r4, r0]
	ldr r1, [r4, r0]
	cmp r1, #1
	bgt _021E69C4
	mov r1, #1
	str r1, [r4, r0]
	b _021E69C4
_021E6918:
	ldr r2, _021E69E4 ; =0x000030F4
	mov r1, #1
	ldr r3, [r4, r2]
	eor r1, r3
	str r1, [r4, r2]
	bl ov51_021E66C0
	ldr r0, _021E69D4 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E69C4
_021E6930:
	ldr r1, _021E69E4 ; =0x000030F4
	ldr r1, [r4, r1]
	cmp r1, #0
	bne _021E6946
	bl ov51_021E6C6C
	add r0, r4, #0
	mov r1, #1
	bl ov51_021E76EC
	b _021E6964
_021E6946:
	add r2, r4, #0
	ldr r0, [r4]
	mov r1, #7
	add r2, #0xec
	bl ov51_021E6D44
	ldr r0, _021E69E8 ; =0x0000343A
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	bne _021E6964
	add r0, r4, #0
	add r1, r5, #0
	bl ov51_021E76EC
_021E6964:
	ldr r0, _021E69D4 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E69C4
_021E696E:
	add r1, r4, #4
	bl ov51_021E71D0
	ldr r0, _021E69D4 ; =0x00003436
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _021E69C4
_021E697E:
	add r0, r1, #0
	sub r0, #0xa2
	ldr r0, [r4, r0]
	add r2, r0, #1
	add r0, r1, #0
	sub r0, #0xa2
	str r2, [r4, r0]
	add r0, r1, #0
	sub r0, #0xa2
	ldr r0, [r4, r0]
	cmp r0, #8
	ble _021E699C
	mov r0, #8
	sub r1, #0xa2
	str r0, [r4, r1]
_021E699C:
	ldr r2, _021E69E0 ; =0x00003394
	ldr r3, _021E69D8 ; =0x000030FC
	ldr r6, [r4, r2]
	mov r2, #0xc
	mov r0, #2
	sub r2, r2, r6
	add r6, r0, #0
	ldr r1, [r4, r3]
	lsl r6, r2
	add r1, r1, r6
	str r1, [r4, r3]
	ldr r2, [r4, r3]
	lsl r1, r0, #0xb
	cmp r2, r1
	blt _021E69C4
	str r1, [r4, r3]
	str r1, [r4, r3]
	add r0, r3, #4
	str r1, [r4, r0]
	mov r5, #1
_021E69C4:
	ldr r1, _021E69E8 ; =0x0000343A
	mov r0, #4
	ldrb r2, [r4, r1]
	orr r0, r2
	strb r0, [r4, r1]
	add r0, r5, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E69D4: .word 0x00003436
_021E69D8: .word 0x000030FC
_021E69DC: .word SEQ_SE_DP_CARD5
_021E69E0: .word 0x00003394
_021E69E4: .word 0x000030F4
_021E69E8: .word 0x0000343A
	thumb_func_end ov51_021E6888

	thumb_func_start ov51_021E69EC
ov51_021E69EC: ; 0x021E69EC
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	ldr r0, _021E6A44 ; =0x000030FC
	ldr r0, [r4, r0]
	bl FX_Inv
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r0, #0x31
	lsl r0, r0, #8
	ldr r0, [r4, r0]
	bl FX_Inv
	str r0, [sp, #0x14]
	bl OS_WaitVBlankIntr
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021E6A48 ; =0x04001020
	add r1, sp, #8
	mov r2, #0x80
	mov r3, #0x60
	bl G2x_SetBGyAffine_
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021E6A4C ; =0x04001030
	add r1, sp, #8
	mov r2, #0x80
	mov r3, #0x60
	bl G2x_SetBGyAffine_
	ldr r1, _021E6A50 ; =0x0000343A
	mov r0, #4
	ldrb r2, [r4, r1]
	bic r2, r0
	strb r2, [r4, r1]
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_021E6A44: .word 0x000030FC
_021E6A48: .word 0x04001020
_021E6A4C: .word 0x04001030
_021E6A50: .word 0x0000343A
	thumb_func_end ov51_021E69EC

	thumb_func_start ov51_021E6A54
ov51_021E6A54: ; 0x021E6A54
	push {r3, lr}
	ldr r1, _021E6A9C ; =gSystem
	mov r2, #1
	ldr r1, [r1, #0x48]
	tst r2, r1
	beq _021E6A7C
	ldr r2, _021E6AA0 ; =0x000030F4
	ldr r2, [r0, r2]
	cmp r2, #0
	beq _021E6A8E
	ldr r2, _021E6AA4 ; =0x0000343A
	ldrb r0, [r0, r2]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	bne _021E6A8E
	ldr r0, _021E6AA8 ; =SEQ_SE_DP_SELECT
	bl PlaySE
	mov r0, #4
	pop {r3, pc}
_021E6A7C:
	mov r0, #2
	tst r0, r1
	beq _021E6A8E
	mov r0, #SEQ_SE_GS_GEARCANCEL>>6
	lsl r0, r0, #6
	bl PlaySE
	mov r0, #5
	pop {r3, pc}
_021E6A8E:
	mov r0, #0x30
	tst r0, r1
	beq _021E6A98
	mov r0, #3
	pop {r3, pc}
_021E6A98:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021E6A9C: .word gSystem
_021E6AA0: .word 0x000030F4
_021E6AA4: .word 0x0000343A
_021E6AA8: .word SEQ_SE_DP_SELECT
	thumb_func_end ov51_021E6A54

	thumb_func_start ov51_021E6AAC
ov51_021E6AAC: ; 0x021E6AAC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl System_GetTouchNew
	cmp r0, #0
	bne _021E6ABE
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E6ABE:
	ldr r0, _021E6B28 ; =_021E7DB8
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _021E6AD8
	mov r0, #1
	str r0, [r4]
	mov r0, #SEQ_SE_GS_GEARCANCEL>>6
	lsl r0, r0, #6
	bl PlaySE
	mov r0, #5
	pop {r3, r4, r5, pc}
_021E6AD8:
	ldr r0, _021E6B2C ; =0x000030F4
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _021E6B02
	ldr r0, _021E6B30 ; =0x0000343A
	ldrb r0, [r5, r0]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	bne _021E6B02
	ldr r0, _021E6B34 ; =ov51_021E7DBC
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _021E6B02
	mov r0, #1
	str r0, [r4]
	ldr r0, _021E6B38 ; =SEQ_SE_DP_SELECT
	bl PlaySE
	mov r0, #4
	pop {r3, r4, r5, pc}
_021E6B02:
	ldr r0, _021E6B3C ; =ov51_021E7DC0
	bl TouchscreenHitbox_TouchNewIsIn
	cmp r0, #0
	beq _021E6B24
	ldr r1, _021E6B40 ; =gSystem + 0x40
	mov r0, #0xd1
	ldrh r2, [r1, #0x20]
	lsl r0, r0, #6
	strb r2, [r5, r0]
	ldrh r1, [r1, #0x22]
	add r0, r0, #1
	strb r1, [r5, r0]
	mov r0, #1
	str r0, [r4]
	mov r0, #3
	pop {r3, r4, r5, pc}
_021E6B24:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E6B28: .word _021E7DB8
_021E6B2C: .word 0x000030F4
_021E6B30: .word 0x0000343A
_021E6B34: .word ov51_021E7DBC
_021E6B38: .word SEQ_SE_DP_SELECT
_021E6B3C: .word ov51_021E7DC0
_021E6B40: .word gSystem + 0x40
	thumb_func_end ov51_021E6AAC

	thumb_func_start ov51_021E6B44
ov51_021E6B44: ; 0x021E6B44
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0
	str r1, [sp]
	sub r2, r1, #1
	ldr r1, _021E6B80 ; =0x00003108
	add r4, r0, #0
	str r2, [r4, r1]
	add r1, sp, #0
	bl ov51_021E6AAC
	ldr r1, [sp]
	cmp r1, #0
	beq _021E6B6A
	ldr r1, _021E6B84 ; =0x0000310C
	mov r2, #1
	add sp, #4
	str r2, [r4, r1]
	pop {r3, r4, pc}
_021E6B6A:
	add r0, r4, #0
	bl ov51_021E6A54
	cmp r0, #0
	beq _021E6B7A
	ldr r1, _021E6B84 ; =0x0000310C
	mov r2, #0
	str r2, [r4, r1]
_021E6B7A:
	add sp, #4
	pop {r3, r4, pc}
	nop
_021E6B80: .word 0x00003108
_021E6B84: .word 0x0000310C
	thumb_func_end ov51_021E6B44

	thumb_func_start ov51_021E6B88
ov51_021E6B88: ; 0x021E6B88
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _021E6BF0 ; =0x0000343F
	mov r1, #5
	ldrb r0, [r4, r0]
	mov r2, #0
	neg r5, r0
	ldr r0, [r4]
	add r3, r5, #0
	bl BgSetPosTextAndCommit
	ldr r0, [r4]
	mov r1, #5
	mov r2, #3
	add r3, r5, #0
	bl BgSetPosTextAndCommit
	ldr r0, [r4]
	mov r1, #3
	mov r2, #0
	add r3, r5, #0
	bl BgSetPosTextAndCommit
	mov r1, #3
	ldr r0, [r4]
	add r2, r1, #0
	add r3, r5, #0
	bl BgSetPosTextAndCommit
	ldr r0, _021E6BF4 ; =0x0000343A
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x1d
	lsr r0, r0, #0x1f
	beq _021E6BD2
	add r0, r4, #0
	bl ov51_021E69EC
_021E6BD2:
	ldr r0, [r4]
	bl DoScheduledBgGpuUpdates
	bl GF_RunVramTransferTasks
	bl OamManager_ApplyAndResetBuffers
	ldr r3, _021E6BF8 ; =0x027E0000
	ldr r1, _021E6BFC ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r3, r4, r5, pc}
	nop
_021E6BF0: .word 0x0000343F
_021E6BF4: .word 0x0000343A
_021E6BF8: .word 0x027E0000
_021E6BFC: .word 0x00003FF8
	thumb_func_end ov51_021E6B88

	thumb_func_start ov51_021E6C00
ov51_021E6C00: ; 0x021E6C00
	push {r4, lr}
	sub sp, #0x18
	mov r0, #1
	lsl r0, r0, #0xc
	bl FX_Inv
	add r4, r0, #0
	mov r0, #1
	lsl r0, r0, #0xc
	bl FX_Inv
	mov r1, #0
	str r4, [sp, #8]
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r0, [sp, #0x14]
	bl OS_WaitVBlankIntr
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021E6C60 ; =0x04001020
	add r1, sp, #8
	mov r2, #0x80
	mov r3, #0x60
	bl G2x_SetBGyAffine_
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _021E6C64 ; =0x04001030
	add r1, sp, #8
	mov r2, #0x80
	mov r3, #0x60
	bl G2x_SetBGyAffine_
	bl OS_WaitVBlankIntr
	mov r3, #0
	str r3, [sp]
	ldr r0, _021E6C68 ; =0x04000030
	add r1, sp, #8
	mov r2, #0x80
	str r3, [sp, #4]
	bl G2x_SetBGyAffine_
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_021E6C60: .word 0x04001020
_021E6C64: .word 0x04001030
_021E6C68: .word 0x04000030
	thumb_func_end ov51_021E6C00

	thumb_func_start ov51_021E6C6C
ov51_021E6C6C: ; 0x021E6C6C
	push {r3, r4, lr}
	sub sp, #0x1c
	add r4, r0, #0
	ldr r0, _021E6CC4 ; =0x000030F0
	mov r1, #7
	ldr r3, [r4, r0]
	mov r0, #0
	str r0, [sp]
	ldr r2, [r3, #0x14]
	ldr r0, [r4]
	ldr r3, [r3, #0x10]
	bl BG_LoadCharTilesData
	ldr r0, _021E6CC8 ; =0x000033B4
	mov r1, #0xa
	ldr r0, [r4, r0]
	mov r2, #0x15
	str r1, [sp]
	mov r1, #0xb
	str r1, [sp, #4]
	add r1, r0, #0
	add r1, #0xc
	str r1, [sp, #8]
	str r2, [sp, #0xc]
	mov r3, #5
	str r3, [sp, #0x10]
	ldrh r1, [r0]
	lsl r1, r1, #0x15
	lsr r1, r1, #0x18
	str r1, [sp, #0x14]
	ldrh r0, [r0, #2]
	mov r1, #7
	lsl r0, r0, #0x15
	lsr r0, r0, #0x18
	str r0, [sp, #0x18]
	ldr r0, [r4]
	bl CopyToBgTilemapRect
	ldr r0, [r4]
	mov r1, #7
	bl BgCommitTilemapBufferToVram
	add sp, #0x1c
	pop {r3, r4, pc}
	.balign 4, 0
_021E6CC4: .word 0x000030F0
_021E6CC8: .word 0x000033B4
	thumb_func_end ov51_021E6C6C

	thumb_func_start ov51_021E6CCC
ov51_021E6CCC: ; 0x021E6CCC
	push {r3, lr}
	sub sp, #0x10
	mov r1, #6
	str r1, [sp]
	str r1, [sp, #4]
	mov r1, #9
	str r1, [sp, #8]
	mov r1, #0x10
	str r1, [sp, #0xc]
	ldr r0, [r0]
	mov r1, #7
	mov r2, #0
	mov r3, #0x14
	bl FillBgTilemapRect
	add sp, #0x10
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov51_021E6CCC

	thumb_func_start ov51_021E6CF0
ov51_021E6CF0: ; 0x021E6CF0
	push {r4, r5, r6, r7}
	mov r2, #3
	mov r4, #0
	lsl r2, r2, #0xc
_021E6CF8:
	asr r3, r4, #2
	lsr r3, r3, #0x1d
	add r3, r4, r3
	asr r3, r3, #3
	lsr r6, r3, #0x1f
	lsl r5, r3, #0x1d
	sub r5, r5, r6
	mov r3, #0x1d
	ror r5, r3
	add r3, r6, r5
	asr r5, r4, #5
	lsr r5, r5, #0x1a
	lsl r3, r3, #0x18
	add r5, r4, r5
	lsr r3, r3, #0x18
	asr r5, r5, #6
	lsl r5, r5, #3
	add r3, r0, r3
	ldrb r3, [r5, r3]
	lsr r7, r4, #0x1f
	lsl r6, r4, #0x1d
	sub r6, r6, r7
	mov r5, #0x1d
	ror r6, r5
	add r5, r7, r6
	lsl r5, r5, #0x18
	add r6, r3, #0
	lsr r5, r5, #0x18
	asr r6, r5
	mov r3, #1
	and r3, r6
	strb r3, [r1, r4]
	add r4, r4, #1
	cmp r4, r2
	blt _021E6CF8
	pop {r4, r5, r6, r7}
	bx lr
	.balign 4, 0
	thumb_func_end ov51_021E6CF0

	thumb_func_start ov51_021E6D44
ov51_021E6D44: ; 0x021E6D44
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r7, r1, #0
	mov r1, #1
	str r1, [sp]
	lsl r1, r7, #0x18
	mov r3, #3
	str r0, [sp, #4]
	lsr r1, r1, #0x18
	lsl r3, r3, #0xc
	bl BG_LoadCharTilesData
	lsl r1, r7, #0x18
	ldr r0, [sp, #4]
	lsr r1, r1, #0x18
	bl GetBgTilemapBuffer
	mov r4, #0
	add r1, r0, #0
	add r3, r4, #0
	add r0, r4, #0
_021E6D6E:
	add r5, r3, #0
	add r5, #0xc
	lsl r5, r5, #6
	add r2, r0, #0
	add r5, r1, r5
_021E6D78:
	lsl r6, r2, #1
	add r4, r4, #1
	add r2, r2, #1
	lsl r4, r4, #0x10
	lsl r2, r2, #0x18
	lsr r4, r4, #0x10
	add r6, r5, r6
	lsr r2, r2, #0x18
	strh r4, [r6, #8]
	cmp r2, #0x18
	blo _021E6D78
	add r2, r3, #1
	lsl r2, r2, #0x18
	lsr r3, r2, #0x18
	cmp r3, #8
	blo _021E6D6E
	lsl r1, r7, #0x18
	ldr r0, [sp, #4]
	lsr r1, r1, #0x18
	bl ScheduleBgTilemapBufferTransfer
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov51_021E6D44

	thumb_func_start ov51_021E6DA8
ov51_021E6DA8: ; 0x021E6DA8
	push {r4, lr}
	add r4, r0, #0
	cmp r1, #0
	beq _021E6E02
	ldr r0, _021E6E04 ; =0x000030F4
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _021E6DF2
	ldr r2, _021E6E08 ; =0x00003439
	ldrb r0, [r4, r2]
	cmp r0, #0
	bne _021E6DE0
	add r1, r4, #0
	add r1, #0xe8
	sub r2, #0x71
	ldr r1, [r1]
	ldr r2, [r4, r2]
	add r0, r4, #4
	bl ov51_021E757C
	ldr r2, _021E6E0C ; =0x000033CC
	add r0, r4, #0
	ldr r2, [r4, r2]
	add r0, #0x54
	mov r1, #1
	bl ov51_021E7664
	b _021E6DF2
_021E6DE0:
	cmp r0, #0xf
	bne _021E6DF2
	sub r2, #0x6d
	add r0, r4, #0
	ldr r2, [r4, r2]
	add r0, #0x54
	mov r1, #0
	bl ov51_021E7664
_021E6DF2:
	ldr r0, _021E6E08 ; =0x00003439
	mov r1, #0x1e
	ldrb r0, [r4, r0]
	add r0, r0, #1
	bl _s32_div_f
	ldr r0, _021E6E08 ; =0x00003439
	strb r1, [r4, r0]
_021E6E02:
	pop {r4, pc}
	.balign 4, 0
_021E6E04: .word 0x000030F4
_021E6E08: .word 0x00003439
_021E6E0C: .word 0x000033CC
	thumb_func_end ov51_021E6DA8

	thumb_func_start ov51_021E6E10
ov51_021E6E10: ; 0x021E6E10
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #1
	ldr r0, _021E6E5C ; =0x0000311C
	bne _021E6E38
	add r0, r5, r0
	mov r1, #1
	mov r2, #2
	mov r3, #0
	bl ov51_021E7D44
	mov r1, #0
	ldr r0, _021E6E5C ; =0x0000311C
	add r2, r1, #0
	add r0, r5, r0
	add r3, r1, #0
	bl ov51_021E7D44
	b _021E6E52
_021E6E38:
	mov r1, #1
	add r0, r5, r0
	mov r2, #2
	add r3, r1, #0
	bl ov51_021E7D44
	ldr r0, _021E6E5C ; =0x0000311C
	mov r1, #0
	add r0, r5, r0
	add r2, r1, #0
	mov r3, #1
	bl ov51_021E7D44
_021E6E52:
	add r0, r5, #0
	add r1, r4, #0
	bl ov51_021E78D0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E6E5C: .word 0x0000311C
	thumb_func_end ov51_021E6E10

	thumb_func_start ov51_021E6E60
ov51_021E6E60: ; 0x021E6E60
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r7, _021E6EE4 ; =ov51_021E7F48
	mov r4, #0
	add r6, r5, #4
_021E6E6C:
	lsl r1, r4, #4
	lsl r2, r4, #3
	ldr r0, [r5]
	add r1, r6, r1
	add r2, r7, r2
	bl AddWindow
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0xe
	blo _021E6E6C
	mov r2, #0
	str r2, [sp]
	ldr r0, [r5]
	mov r1, #7
	mov r3, #1
	bl BG_FillCharDataRange
	mov r2, #0
	str r2, [sp]
	ldr r0, [r5]
	mov r1, #4
	mov r3, #1
	bl BG_FillCharDataRange
	ldr r0, _021E6EE8 ; =0x0000343D
	ldr r2, _021E6EEC ; =0x000003E1
	ldrb r0, [r5, r0]
	mov r1, #4
	mov r3, #0xd
	str r0, [sp]
	mov r0, #0x19
	str r0, [sp, #4]
	ldr r0, [r5]
	bl LoadUserFrameGfx2
	mov r1, #7
	mov r0, #4
	lsl r1, r1, #6
	mov r2, #0x19
	bl LoadFontPal0
	mov r0, #0x19
	bl YesNoPrompt_Create
	mov r1, #0xcf
	lsl r1, r1, #6
	str r0, [r5, r1]
	ldr r0, [r5]
	mov r1, #7
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, [r5]
	mov r1, #4
	bl ScheduleBgTilemapBufferTransfer
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E6EE4: .word ov51_021E7F48
_021E6EE8: .word 0x0000343D
_021E6EEC: .word 0x000003E1
	thumb_func_end ov51_021E6E60

	thumb_func_start ov51_021E6EF0
ov51_021E6EF0: ; 0x021E6EF0
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0xcf
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	mov r5, #0
	add r4, r4, #4
_021E6F02:
	lsl r0, r5, #4
	add r0, r4, r0
	bl RemoveWindow
	add r0, r5, #1
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	cmp r5, #0xe
	blo _021E6F02
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov51_021E6EF0
