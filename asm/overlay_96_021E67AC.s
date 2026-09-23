	.include "asm/macros.inc"
	.include "overlay_96.inc"
	.include "global.inc"

	.text

.public ov96_021E91B8
.public ov96_021E9370
.public ov96_021E94EC
.public ov96_021E99F4
.public ov96_021E99F8
.public ov96_021E99FC
.public ov96_021E9A04
.public ov96_021E9A10
.public ov96_021E9A14
.public ov96_021E9A18
.public ov96_021E9A1C
.public ov96_021EA214
.public ov96_021EA4D4
.public ov96_021EA584
.public ov96_021EA6E4
.public ov96_021EA7A4
.public ov96_021EAEC8
.public ov96_021EB120
.public ov96_021EB5E8
.public _0221A7D8
.public ov96_0221A808
.public ov96_0221A844
.public ov96_0221A86C
.public ov96_0221A894
.public ov96_0221A8BC
.public ov96_0221A8E4
.public ov96_0221A934
.public ov96_0221A95C
.public ov96_0221AA20
.public ov96_0221AAE8
.public ov96_0221AEC4
.public _0221DA00
.public ov96_0221DA28
.public ov96_0221DA50
.public ov96_0221DA5C
.public ov96_0221DA68
.public ov96_0221DA6C
.public ov96_0221DC24

	.extern PokeathlonCourse_RunSubStateLoop
	.extern PokeathlonCourse_InitStateInfo
	.extern PokeathlonCourse_InitPlayerProfiles
	.extern PokeathlonCourse_GetPlayerProfile
	.extern PokeathlonCourse_GetParticipantCount
	.extern PokeathlonCourse_GetParticipantData
	.extern PokeathlonCourse_GetParticipantUnk04
	.extern PokeathlonCourse_GetSaveData
	.extern PokeathlonCourse_GetFieldData
	.extern PokeathlonCourse_GetFieldData_AtIndex
	.extern PokeathlonCourse_GetFieldBA4
	.extern PokeathlonCourse_AllocPtr4FromHeap
	.extern PokeathlonCourse_FreePtr4HeapAlloc
	.extern PokeathlonCourse_GetHeapAllocPtr4
	.extern PokeathlonCourse_GetHeapID
	.extern PokeathlonCourse_GetField1ED
	.extern PokeathlonCourse_SetField1ED
	.extern PokeathlonCourse_IncrementField1ED
	.extern PokeathlonCourse_SetField1F4
	.extern ov96_021E5E04
	.extern PokeathlonCourse_GetField3D8_ForCurrentParticipant
	.extern PokeathlonCourse_GetField3D8_AtIndex
	.extern ov96_021E5E7C
	.extern PokeathlonCourse_GetCurrentParticipantIndex
	.extern PokeathlonCourse_GetMode
	.extern PokeathlonCourse_GetField1EF
	.extern PokeathlonCourse_IncrementField1EF
	.extern PokeathlonCourse_ResetField1EF
	.extern PokeathlonCourse_GetSystem
	.extern ov96_021E5F24
	.extern PokeathlonCourse_GetPlayerProfileFromData
	.extern PokeathlonCourse_GetField974_AtIndex
	.extern PokeathlonCourse_GetDataCopyArea
	.extern PokeathlonCourse_ResetDataCopyArea
	.extern PokeathlonCourse_SetField3A4
	.extern PokeathlonCourse_ResetField3A4
	.extern PokeathlonCourse_GetField3A4
	.extern PokeathlonCourse_GetUnkConstant4
	.extern PokeathlonCourse_SetField5E0_AtIndex
	.extern PokeathlonCourse_GetField5F0_AtIndex
	.extern PokeathlonCourse_SetStateField07
	.extern PokeathlonCourse_SetStateField07_IfDifferent
	.extern PokeathlonCourse_SetStateTransitionType
	.extern PokeathlonCourse_SetVBlankIntrCB
	.extern PokeathlonCourse_GetGraphicsSystem

.public ov96_021E679C

.public ov96_021E786C
.public ov96_021E7938
.public ov96_021E7A2C
.public ov96_021E7BA8
.public ov96_021E7D6C
.public ov96_021E7FA8
.public ov96_021E8060
.public ov96_021E8084
.public ov96_021E80C4
.public ov96_021E811C
.public ov96_021E87B0
.public ov96_021E87B4
.public ov96_021E87EC
.public ov96_021E8A20

	thumb_func_start ov96_021E67AC
ov96_021E67AC: ; 0x021E67AC
	push {r3, lr}
	mov r2, #0x7d
	lsl r2, r2, #2
	ldr r1, [r0, r2]
	cmp r1, #0
	beq _021E67C2
	sub r2, #0x14
	ldr r2, [r0, r2]
	mov r1, #0
	ldr r2, [r2, #4]
	blx r2
_021E67C2:
	pop {r3, pc}
	thumb_func_end ov96_021E67AC

	thumb_func_start ov96_021E67C4
ov96_021E67C4: ; 0x021E67C4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r5, #1
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E67FC
	ldr r1, _021E6810 ; =0x0000072A
	mov r2, #0x7e
	lsl r2, r2, #2
	ldr r0, [r4, r2]
	sub r2, #0x10
	ldrb r1, [r4, r1]
	add r2, r4, r2
	bl ov96_021E811C
	bl ov96_021E99F4
	mov r3, #0x7a
	lsl r3, r3, #2
	add r1, r4, r3
	add r3, #0xa0
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x16
	bl ov96_021E87B4
	add r5, r0, #0
_021E67FC:
	cmp r5, #0
	beq _021E680A
	add r0, r4, #0
	mov r1, #0x26
	mov r2, #1
	bl PokeathlonCourse_SetStateField07_IfDifferent
_021E680A:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_021E6810: .word 0x0000072A
	thumb_func_end ov96_021E67C4

	thumb_func_start ov96_021E6814
ov96_021E6814: ; 0x021E6814
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xa
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl OverlayManager_Run
	cmp r0, #0
	beq _021E686C
	mov r0, #0xa
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl OverlayManager_Delete
	mov r1, #0x7e
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	ldr r2, [r0, #4]
	cmp r2, #0
	bne _021E6860
	add r1, r1, #4
	ldr r1, [r4, r1]
	cmp r1, #0
	beq _021E6852
	mov r1, #1
	strb r1, [r0, #0xe]
	add r0, r4, #0
	mov r1, #0x25
	bl PokeathlonCourse_SetStateField07
	b _021E686C
_021E6852:
	mov r1, #0
	strb r1, [r0, #0xe]
	add r0, r4, #0
	mov r1, #3
	bl PokeathlonCourse_SetStateField07
	b _021E686C
_021E6860:
	mov r1, #0
	strb r1, [r0, #0xe]
	add r0, r4, #0
	mov r1, #2
	bl PokeathlonCourse_SetStateField07
_021E686C:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov96_021E6814

	thumb_func_start ov96_021E6870
ov96_021E6870: ; 0x021E6870
	push {r3, r4, r5, lr}
	add r5, r1, #0
	ldrb r2, [r5]
	add r4, r0, #0
	cmp r2, #3
	bhi _021E694C
	add r1, r2, r2
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E6888: ; jump table
	.short _021E6890 - _021E6888 - 2 ; case 0
	.short _021E68B2 - _021E6888 - 2 ; case 1
	.short _021E68C2 - _021E6888 - 2 ; case 2
	.short _021E692A - _021E6888 - 2 ; case 3
_021E6890:
	mov r0, #0x1e
	ldr r1, _021E6950 ; =ov96_0221A8BC
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0
	add r0, #0xd
	strb r1, [r4, r0]
	mov r1, #0xf3
	lsl r1, r1, #2
	ldr r0, _021E6954 ; =ov96_0221DA68
	add r1, r4, r1
	bl PokeathlonCourse_InitStateInfo
	ldrb r0, [r5]
	add r0, r0, #1
	strb r0, [r5]
	b _021E694C
_021E68B2:
	bl PokeathlonCourse_RunSubStateLoop
	cmp r0, #0
	beq _021E694C
	ldrb r0, [r5]
	add r0, r0, #1
	strb r0, [r5]
	b _021E694C
_021E68C2:
	mov r0, #0xf3
	lsl r0, r0, #2
	add r1, r4, r0
	ldr r3, [r1]
	cmp r3, #0
	bne _021E68D4
	add r0, r2, #1
	strb r0, [r5]
	b _021E694C
_021E68D4:
	add r2, r0, #0
	sub r2, #0x18
	ldr r3, [r4, r2]
	add r2, r0, #0
	sub r2, #8
	add r2, r4, r2
	cmp r3, r2
	bne _021E68F0
	add r2, r0, #0
	sub r2, #0x18
	str r1, [r4, r2]
	mov r1, #0
	sub r0, #0xc
	str r1, [r4, r0]
_021E68F0:
	ldr r3, _021E6958 ; =0x000003D1
	add r0, r4, #0
	sub r2, r3, #5
	add r1, r4, r3
	add r3, r3, #1
	ldrb r3, [r4, r3]
	ldr r2, [r4, r2]
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	blx r2
	cmp r0, #0
	beq _021E694C
	add r0, r4, #0
	mov r1, #0
	bl PokeathlonCourse_SetField1F4
	mov r0, #0xf1
	lsl r0, r0, #2
	add r1, r0, #0
	add r2, r4, r0
	sub r1, #0x10
	str r2, [r4, r1]
	mov r1, #0
	sub r0, r0, #4
	str r1, [r4, r0]
	ldrb r0, [r5]
	add r0, r0, #1
	strb r0, [r5]
	b _021E694C
_021E692A:
	mov r2, #0x1e
	lsl r2, r2, #4
	ldr r2, [r4, r2]
	mov r1, #0
	ldr r2, [r2, #0xc]
	blx r2
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E6944
	bl GF_AssertFail
_021E6944:
	add r0, r4, #0
	mov r1, #3
	bl PokeathlonCourse_SetStateField07
_021E694C:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E6950: .word ov96_0221A8BC
_021E6954: .word ov96_0221DA68
_021E6958: .word 0x000003D1
	thumb_func_end ov96_021E6870

	thumb_func_start ov96_021E695C
ov96_021E695C: ; 0x021E695C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #2
	mov r1, #0
	lsl r0, r0, #8
	str r1, [r4, r0]
	bl ov96_021E99F8
	mov r3, #2
	lsl r3, r3, #8
	add r1, r4, r3
	add r3, #0x88
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x17
	bl ov96_021E87EC
	cmp r0, #0
	beq _021E698A
	add r0, r4, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E698A:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov96_021E695C

	thumb_func_start ov96_021E6990
ov96_021E6990: ; 0x021E6990
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r1, #0
	bl PokeathlonCourse_GetParticipantData
	add r4, r0, #0
	bl ov96_021E99FC
	add r6, r0, #0
	add r0, r5, #0
	bl PokeathlonCourse_GetSystem
	add r3, r0, #0
	mov r0, #0x18
	add r1, r4, #0
	add r2, r6, #0
	bl ov96_021E87EC
	cmp r0, #0
	beq _021E69C0
	add r0, r5, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E69C0:
	mov r0, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov96_021E6990

	thumb_func_start ov96_021E69C4
ov96_021E69C4: ; 0x021E69C4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r5, #1
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E69EA
	bl ov96_021E9A04
	ldr r1, _021E69FC ; =0x000005DC
	mov r3, #0xa2
	lsl r3, r3, #2
	add r2, r0, #0
	ldr r1, [r4, r1]
	ldr r3, [r4, r3]
	mov r0, #0x19
	bl ov96_021E87EC
	add r5, r0, #0
_021E69EA:
	cmp r5, #0
	beq _021E69F8
	add r0, r4, #0
	mov r1, #0x26
	mov r2, #6
	bl PokeathlonCourse_SetStateField07_IfDifferent
_021E69F8:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E69FC: .word 0x000005DC
	thumb_func_end ov96_021E69C4

	thumb_func_start ov96_021E6A00
ov96_021E6A00: ; 0x021E6A00
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldr r0, [r0]
	bl Save_Pokeathlon_Get
	bl PokeathlonSave_GetAgainUnkB00
	add r5, r0, #0
	mov r0, #9
	lsl r0, r0, #8
	add r3, r4, r0
	mov r2, #0xe
_021E6A1E:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _021E6A1E
	ldr r0, [r5]
	str r0, [r3]
	bl ov96_021E9A10
	mov r3, #0xa2
	mov r1, #9
	lsl r3, r3, #2
	lsl r1, r1, #8
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1a
	add r1, r4, r1
	bl ov96_021E87EC
	cmp r0, #0
	beq _021E6A4E
	add r0, r4, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E6A4E:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov96_021E6A00

	thumb_func_start ov96_021E6A54
ov96_021E6A54: ; 0x021E6A54
	push {r4, lr}
	ldr r1, _021E6A88 ; =0x00000D2C
	add r4, r0, #0
	mov r2, #1
	str r2, [r4, r1]
	bl PokeathlonCourse_ResetDataCopyArea
	mov r0, #0x1e
	ldr r1, _021E6A8C ; =ov96_0221A808
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0
	add r0, #0xd
	strb r1, [r4, r0]
	mov r1, #0xf3
	lsl r1, r1, #2
	ldr r0, _021E6A90 ; =ov96_0221DA50
	add r1, r4, r1
	bl PokeathlonCourse_InitStateInfo
	add r0, r4, #0
	mov r1, #8
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021E6A88: .word 0x00000D2C
_021E6A8C: .word ov96_0221A808
_021E6A90: .word ov96_0221DA50
	thumb_func_end ov96_021E6A54

	thumb_func_start ov96_021E6A94
ov96_021E6A94: ; 0x021E6A94
	push {r4, lr}
	add r4, r0, #0
	bl PokeathlonCourse_RunSubStateLoop
	cmp r0, #0
	beq _021E6AE0
	add r0, r4, #0
	bl PokeathlonCourse_GetDataCopyArea
	add r1, r0, #0
	mov r2, #0
	add r1, #0x24
	strb r2, [r1]
	mov r1, #1
	add r0, #0x4c
	strb r1, [r0]
	add r0, r4, #0
	bl PokeathlonCourse_GetSystem
	mov r1, #1
	bl ov96_021E87B0
	add r0, r4, #0
	mov r1, #6
	bl PokeathlonCourse_SetStateTransitionType
	add r0, r4, #0
	mov r1, #9
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	bl Sound_SetScene
	ldr r1, _021E6AE4 ; =0x0000046F
	mov r0, #0x19
	mov r2, #0
	bl Sound_SetSceneAndPlayBGM
_021E6AE0:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021E6AE4: .word 0x0000046F
	thumb_func_end ov96_021E6A94

	thumb_func_start ov96_021E6AE8
ov96_021E6AE8: ; 0x021E6AE8
	push {r3, r4, r5, lr}
	mov r1, #0xf3
	add r4, r0, #0
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r3, [r2]
	cmp r3, #0
	bne _021E6B02
	mov r1, #0xa
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E6B02:
	add r0, r1, #0
	sub r0, #0x18
	ldr r3, [r4, r0]
	add r0, r1, #0
	sub r0, #8
	add r0, r4, r0
	cmp r3, r0
	bne _021E6B1E
	add r0, r1, #0
	sub r0, #0x18
	str r2, [r4, r0]
	mov r0, #0
	sub r1, #0xc
	str r0, [r4, r1]
_021E6B1E:
	ldr r3, _021E6BBC ; =0x000003D1
	add r0, r4, #0
	sub r2, r3, #5
	add r1, r4, r3
	add r3, r3, #1
	ldrb r3, [r4, r3]
	ldr r2, [r4, r2]
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	blx r2
	cmp r0, #0
	beq _021E6B5A
	add r0, r4, #0
	mov r1, #0
	bl PokeathlonCourse_SetField1F4
	mov r0, #0xf1
	lsl r0, r0, #2
	add r1, r0, #0
	add r2, r4, r0
	sub r1, #0x10
	str r2, [r4, r1]
	mov r1, #0
	sub r0, r0, #4
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0xa
	bl PokeathlonCourse_SetStateField07
	b _021E6BB6
_021E6B5A:
	add r0, r4, #0
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E6BA0
	bl ov96_021E9A14
	mov r3, #0xad
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, #0x2c
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
	mov r0, #0xb7
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	add r5, r0, #0
	mov r0, #0xa3
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	mov r2, #0x28
_021E6B92:
	ldrb r1, [r0]
	add r0, r0, #1
	strb r1, [r5]
	add r5, r5, #1
	sub r2, r2, #1
	bne _021E6B92
	b _021E6BB6
_021E6BA0:
	bl ov96_021E9A14
	mov r3, #0xa3
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, r3, #4
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
_021E6BB6:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_021E6BBC: .word 0x000003D1
	thumb_func_end ov96_021E6AE8

	thumb_func_start ov96_021E6BC0
ov96_021E6BC0: ; 0x021E6BC0
	push {r4, lr}
	mov r2, #0x1e
	add r4, r0, #0
	lsl r2, r2, #4
	ldr r2, [r4, r2]
	mov r1, #0
	ldr r2, [r2, #0xc]
	blx r2
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E6BDE
	bl GF_AssertFail
_021E6BDE:
	add r0, r4, #0
	mov r1, #0xb
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov96_021E6BC0

	thumb_func_start ov96_021E6BEC
ov96_021E6BEC: ; 0x021E6BEC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1e
	ldr r1, _021E6C18 ; =ov96_0221A8E4
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0
	add r0, #0xd
	strb r1, [r4, r0]
	mov r1, #0xf3
	lsl r1, r1, #2
	ldr r0, _021E6C1C ; =ov96_0221DA6C
	add r1, r4, r1
	bl PokeathlonCourse_InitStateInfo
	add r0, r4, #0
	mov r1, #0xc
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	nop
_021E6C18: .word ov96_0221A8E4
_021E6C1C: .word ov96_0221DA6C
	thumb_func_end ov96_021E6BEC

	thumb_func_start ov96_021E6C20
ov96_021E6C20: ; 0x021E6C20
	push {r4, lr}
	add r4, r0, #0
	bl PokeathlonCourse_RunSubStateLoop
	cmp r0, #0
	beq _021E6C3C
	add r0, r4, #0
	mov r1, #7
	bl PokeathlonCourse_SetStateTransitionType
	add r0, r4, #0
	mov r1, #0xd
	bl PokeathlonCourse_SetStateField07
_021E6C3C:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov96_021E6C20

	thumb_func_start ov96_021E6C40
ov96_021E6C40: ; 0x021E6C40
	push {r4, lr}
	mov r1, #0xf3
	add r4, r0, #0
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r3, [r2]
	cmp r3, #0
	bne _021E6C5A
	mov r1, #0xe
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
_021E6C5A:
	add r0, r1, #0
	sub r0, #0x18
	ldr r3, [r4, r0]
	add r0, r1, #0
	sub r0, #8
	add r0, r4, r0
	cmp r3, r0
	bne _021E6C76
	add r0, r1, #0
	sub r0, #0x18
	str r2, [r4, r0]
	mov r0, #0
	sub r1, #0xc
	str r0, [r4, r1]
_021E6C76:
	ldr r3, _021E6CB4 ; =0x000003D1
	add r0, r4, #0
	sub r2, r3, #5
	add r1, r4, r3
	add r3, r3, #1
	ldrb r3, [r4, r3]
	ldr r2, [r4, r2]
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	blx r2
	cmp r0, #0
	beq _021E6CB0
	add r0, r4, #0
	mov r1, #0
	bl PokeathlonCourse_SetField1F4
	mov r0, #0xf1
	lsl r0, r0, #2
	add r1, r0, #0
	add r2, r4, r0
	sub r1, #0x10
	str r2, [r4, r1]
	mov r1, #0
	sub r0, r0, #4
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0xe
	bl PokeathlonCourse_SetStateField07
_021E6CB0:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021E6CB4: .word 0x000003D1
	thumb_func_end ov96_021E6C40

	thumb_func_start ov96_021E6CB8
ov96_021E6CB8: ; 0x021E6CB8
	push {r4, lr}
	mov r2, #0x1e
	add r4, r0, #0
	lsl r2, r2, #4
	ldr r2, [r4, r2]
	mov r1, #0
	ldr r2, [r2, #0xc]
	blx r2
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E6CD6
	bl GF_AssertFail
_021E6CD6:
	add r0, r4, #0
	mov r1, #0xf
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov96_021E6CB8

	thumb_func_start ov96_021E6CE4
ov96_021E6CE4: ; 0x021E6CE4
	push {r4, r5, r6, lr}
	mov r1, #0x1f
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	ldr r6, _021E6D40 ; =0x0000FFFF
	lsl r1, r1, #2
	add r2, r4, r1
	mov r1, #0xf6
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	ldr r2, _021E6D44 ; =0x00000728
	lsl r5, r1, #0x18
	mov r1, #0
	strb r1, [r4, r2]
	ldr r3, _021E6D48 ; =0x00000D2A
	add r2, r2, #3
	strh r6, [r4, r3]
	strb r1, [r4, r2]
	add r3, #0x42
	str r1, [r4, r3]
	bl PokeathlonCourse_ResetDataCopyArea
	ldr r0, _021E6D4C ; =ov96_0221DA28
	lsr r2, r5, #0x16
	ldr r1, [r0, r2]
	mov r0, #0x1e
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0
	add r0, #0xd
	strb r1, [r4, r0]
	ldr r0, _021E6D50 ; =_0221DA00
	mov r1, #0xf3
	lsl r1, r1, #2
	ldr r0, [r0, r2]
	add r1, r4, r1
	bl PokeathlonCourse_InitStateInfo
	add r0, r4, #0
	mov r1, #0x10
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, r5, r6, pc}
	nop
_021E6D40: .word 0x0000FFFF
_021E6D44: .word 0x00000728
_021E6D48: .word 0x00000D2A
_021E6D4C: .word ov96_0221DA28
_021E6D50: .word _0221DA00
	thumb_func_end ov96_021E6CE4

	thumb_func_start ov96_021E6D54
ov96_021E6D54: ; 0x021E6D54
	push {r4, lr}
	add r4, r0, #0
	bl PokeathlonCourse_RunSubStateLoop
	cmp r0, #0
	beq _021E6DD8
	add r0, r4, #0
	bl PokeathlonCourse_GetDataCopyArea
	add r1, r0, #0
	mov r2, #0
	add r1, #0x24
	strb r2, [r1]
	mov r1, #1
	add r0, #0x4c
	strb r1, [r0]
	add r0, r4, #0
	bl PokeathlonCourse_GetSystem
	mov r1, #1
	bl ov96_021E87B0
	add r0, r4, #0
	mov r1, #8
	bl PokeathlonCourse_SetStateTransitionType
	mov r0, #0x1f
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	ldr r0, _021E6DDC ; =0x0000072A
	ldrb r0, [r4, r0]
	sub r0, r0, #1
	cmp r1, r0
	bne _021E6DAA
	mov r0, #0
	bl Sound_SetScene
	ldr r1, _021E6DE0 ; =0x00000472
	mov r0, #0x18
	mov r2, #0
	bl Sound_SetSceneAndPlayBGM
	b _021E6DBA
_021E6DAA:
	mov r0, #0
	bl Sound_SetScene
	ldr r1, _021E6DE4 ; =0x00000471
	mov r0, #0x18
	mov r2, #0
	bl Sound_SetSceneAndPlayBGM
_021E6DBA:
	mov r0, #7
	mov r1, #1
	bl sub_020053A8
	add r0, r4, #0
	mov r1, #0x11
	bl PokeathlonCourse_SetStateField07
	mov r0, #0x5c
	bl GF_heap_c_dummy_return_true
	cmp r0, #0
	bne _021E6DD8
	bl GF_AssertFail
_021E6DD8:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021E6DDC: .word 0x0000072A
_021E6DE0: .word 0x00000472
_021E6DE4: .word 0x00000471
	thumb_func_end ov96_021E6D54

	thumb_func_start ov96_021E6DE8
ov96_021E6DE8: ; 0x021E6DE8
	push {r4, lr}
	mov r1, #0x3b
	add r4, r0, #0
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	cmp r1, #0
	beq _021E6E2C
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E6E22
	mov r2, #0xe9
	lsl r2, r2, #2
	mov r3, #0xa2
	ldr r1, [r4, r2]
	add r2, #8
	lsl r3, r3, #2
	ldr r2, [r4, r2]
	ldr r3, [r4, r3]
	mov r0, #0x1c
	bl ov96_021E87EC
	cmp r0, #0
	beq _021E6E32
	add r0, r4, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
	b _021E6E32
_021E6E22:
	add r0, r4, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
	b _021E6E32
_021E6E2C:
	mov r1, #0x12
	bl PokeathlonCourse_SetStateField07
_021E6E32:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov96_021E6DE8

	thumb_func_start ov96_021E6E38
ov96_021E6E38: ; 0x021E6E38
	push {r3, r4, r5, lr}
	mov r1, #0xf3
	add r4, r0, #0
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r3, [r2]
	cmp r3, #0
	bne _021E6E52
	mov r1, #0x18
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E6E52:
	add r0, r1, #0
	sub r0, #0x18
	ldr r3, [r4, r0]
	add r0, r1, #0
	sub r0, #8
	add r0, r4, r0
	cmp r3, r0
	bne _021E6E6E
	add r0, r1, #0
	sub r0, #0x18
	str r2, [r4, r0]
	mov r0, #0
	sub r1, #0xc
	str r0, [r4, r1]
_021E6E6E:
	ldr r3, _021E6F14 ; =0x000003D1
	add r0, r4, #0
	sub r2, r3, #5
	add r1, r4, r3
	add r3, r3, #1
	ldrb r3, [r4, r3]
	ldr r2, [r4, r2]
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	blx r2
	cmp r0, #0
	beq _021E6EB2
	add r0, r4, #0
	mov r1, #0
	bl PokeathlonCourse_SetField1F4
	mov r0, #0xf1
	lsl r0, r0, #2
	add r1, r0, #0
	add r2, r4, r0
	sub r1, #0x10
	str r2, [r4, r1]
	mov r1, #0
	sub r0, r0, #4
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0x10
	bl PokeathlonCourse_SetStateTransitionType
	add r0, r4, #0
	mov r1, #0x13
	bl PokeathlonCourse_SetStateField07
	b _021E6F0E
_021E6EB2:
	add r0, r4, #0
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E6EF8
	bl ov96_021E9A14
	mov r3, #0xad
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, #0x2c
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
	mov r0, #0xb7
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	add r5, r0, #0
	mov r0, #0xa3
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	mov r2, #0x28
_021E6EEA:
	ldrb r1, [r0]
	add r0, r0, #1
	strb r1, [r5]
	add r5, r5, #1
	sub r2, r2, #1
	bne _021E6EEA
	b _021E6F0E
_021E6EF8:
	bl ov96_021E9A14
	mov r3, #0xa3
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, r3, #4
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
_021E6F0E:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_021E6F14: .word 0x000003D1
	thumb_func_end ov96_021E6E38

	thumb_func_start ov96_021E6F18
ov96_021E6F18: ; 0x021E6F18
	push {r4, lr}
	add r4, r0, #0
	bl PokeathlonCourse_ResetDataCopyArea
	add r0, r4, #0
	mov r1, #0x14
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov96_021E6F18

	thumb_func_start ov96_021E6F2C
ov96_021E6F2C: ; 0x021E6F2C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	mov r1, #0x1e
	add r7, r0, #0
	lsl r1, r1, #4
	ldr r2, [r7, r1]
	ldr r2, [r2, #0x10]
	cmp r2, #0
	beq _021E6FD0
	add r1, #0xac
	add r0, r7, r1
	bl ov96_021E8A20
	add r4, r0, #0
	add r0, r7, #0
	bl ov96_021E5F24
	lsl r0, r0, #2
	add r2, r7, r0
	mov r0, #0x5e
	lsl r0, r0, #4
	ldrh r1, [r2, r0]
	add r0, r0, #2
	strh r1, [r4]
	ldrh r0, [r2, r0]
	strh r0, [r4, #2]
	bl ov96_021E9A14
	mov r3, #0xa3
	lsl r3, r3, #2
	add r1, r7, r3
	sub r3, r3, #4
	add r2, r0, #0
	ldr r3, [r7, r3]
	mov r0, #0x1d
	bl ov96_021E87B4
	str r0, [sp, #4]
	cmp r0, #0
	beq _021E6FE6
	add r0, r7, #0
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E6FE6
	add r0, r7, #0
	bl PokeathlonCourse_GetUnkConstant4
	add r6, r0, #0
	add r0, r7, #0
	bl PokeathlonCourse_GetParticipantCount
	str r0, [sp]
	cmp r0, #4
	bge _021E6FE6
	mov r0, #0x5e
	lsl r0, r0, #4
	add r1, r7, r0
	ldr r0, [sp]
	lsl r0, r0, #2
	add r4, r1, r0
	ldr r0, [sp]
	add r5, r0, #0
	mul r5, r6
_021E6FAC:
	mov r0, #0xad
	lsl r0, r0, #2
	add r0, r7, r0
	bl ov96_021E8A20
	add r0, r0, r5
	add r1, r4, #0
	add r2, r6, #0
	bl memcpy
	ldr r0, [sp]
	add r4, r4, #4
	add r0, r0, #1
	add r5, r5, r6
	str r0, [sp]
	cmp r0, #4
	blt _021E6FAC
	b _021E6FE6
_021E6FD0:
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E6FE2
	add r0, r7, #0
	bl ov96_021E75E4
	str r0, [sp, #4]
	b _021E6FE6
_021E6FE2:
	mov r0, #1
	str r0, [sp, #4]
_021E6FE6:
	ldr r0, [sp, #4]
	cmp r0, #0
	beq _021E6FF4
	add r0, r7, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E6FF4:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E6F2C

	thumb_func_start ov96_021E6FFC
ov96_021E6FFC: ; 0x021E6FFC
	push {r4, r5, r6, lr}
	add r5, r0, #0
	bl PokeathlonCourse_GetDataCopyArea
	add r4, r0, #0
	bl ov96_021E9A14
	add r6, r0, #0
	add r0, r5, #0
	bl PokeathlonCourse_GetSystem
	add r4, #0x28
	add r3, r0, #0
	mov r0, #0x1e
	add r1, r4, #0
	add r2, r6, #0
	bl ov96_021E87B4
	cmp r0, #0
	beq _021E702C
	add r0, r5, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E702C:
	mov r0, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov96_021E6FFC

	thumb_func_start ov96_021E7030
ov96_021E7030: ; 0x021E7030
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xdf
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	mov r1, #0x5f
	lsl r1, r1, #4
	add r3, r4, r1
	mov r2, #0x12
_021E7046:
	ldrh r1, [r0]
	add r0, r0, #2
	strh r1, [r3]
	add r3, r3, #2
	sub r2, r2, #1
	bne _021E7046
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	ldr r2, [r0, #8]
	cmp r2, #0
	beq _021E7064
	add r0, r4, #0
	mov r1, #0
	blx r2
_021E7064:
	mov r1, #0x1f
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	bl ov96_021E7658
	add r0, r4, #0
	mov r1, #0x17
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov96_021E7030

	thumb_func_start ov96_021E7080
ov96_021E7080: ; 0x021E7080
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x5c
	bl GF_heap_c_dummy_return_true
	cmp r0, #0
	bne _021E7092
	bl GF_AssertFail
_021E7092:
	mov r2, #0x1e
	lsl r2, r2, #4
	ldr r2, [r4, r2]
	add r0, r4, #0
	ldr r2, [r2, #0xc]
	mov r1, #0
	blx r2
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E70AE
	bl GF_AssertFail
_021E70AE:
	ldr r1, _021E70EC ; =0x0000072A
	mov r0, #0x1f
	lsl r0, r0, #4
	ldrb r1, [r4, r1]
	ldr r2, [r4, r0]
	cmp r2, r1
	bge _021E70DA
	sub r0, #0x10
	ldr r0, [r4, r0]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021E70D0
	add r0, r4, #0
	mov r1, #0x19
	bl PokeathlonCourse_SetStateField07
	b _021E70E6
_021E70D0:
	add r0, r4, #0
	mov r1, #0x18
	bl PokeathlonCourse_SetStateField07
	b _021E70E6
_021E70DA:
	add r1, r2, #1
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0x1d
	bl PokeathlonCourse_SetStateField07
_021E70E6:
	mov r0, #0
	pop {r4, pc}
	nop
_021E70EC: .word 0x0000072A
	thumb_func_end ov96_021E7080

	thumb_func_start ov96_021E70F0
ov96_021E70F0: ; 0x021E70F0
	push {r3, lr}
	mov r1, #0x1f
	lsl r1, r1, #4
	ldr r2, [r0, r1]
	add r2, r2, #1
	str r2, [r0, r1]
	ldr r2, [r0, r1]
	ldr r1, _021E7118 ; =0x0000072A
	ldrb r1, [r0, r1]
	cmp r2, r1
	blt _021E710E
	mov r1, #0x1d
	bl PokeathlonCourse_SetStateField07
	b _021E7114
_021E710E:
	mov r1, #0xb
	bl PokeathlonCourse_SetStateField07
_021E7114:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
_021E7118: .word 0x0000072A
	thumb_func_end ov96_021E70F0

	thumb_func_start ov96_021E711C
ov96_021E711C: ; 0x021E711C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1e
	ldr r1, _021E7148 ; =ov96_0221A86C
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0
	add r0, #0xd
	strb r1, [r4, r0]
	mov r1, #0xf3
	lsl r1, r1, #2
	ldr r0, _021E714C ; =ov96_0221DC24
	add r1, r4, r1
	bl PokeathlonCourse_InitStateInfo
	add r0, r4, #0
	mov r1, #0x1a
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	nop
_021E7148: .word ov96_0221A86C
_021E714C: .word ov96_0221DC24
	thumb_func_end ov96_021E711C

	thumb_func_start ov96_021E7150
ov96_021E7150: ; 0x021E7150
	push {r4, lr}
	add r4, r0, #0
	bl PokeathlonCourse_RunSubStateLoop
	cmp r0, #0
	beq _021E718C
	add r0, r4, #0
	bl PokeathlonCourse_GetDataCopyArea
	add r1, r0, #0
	mov r2, #0
	add r1, #0x24
	strb r2, [r1]
	mov r1, #1
	add r0, #0x4c
	strb r1, [r0]
	add r0, r4, #0
	bl PokeathlonCourse_GetSystem
	mov r1, #1
	bl ov96_021E87B0
	add r0, r4, #0
	mov r1, #0xb
	bl PokeathlonCourse_SetStateTransitionType
	add r0, r4, #0
	mov r1, #0x1b
	bl PokeathlonCourse_SetStateField07
_021E718C:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov96_021E7150

	thumb_func_start ov96_021E7190
ov96_021E7190: ; 0x021E7190
	push {r3, r4, r5, lr}
	mov r1, #0xf3
	add r4, r0, #0
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r3, [r2]
	cmp r3, #0
	bne _021E71AA
	mov r1, #0x1c
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E71AA:
	add r0, r1, #0
	sub r0, #0x18
	ldr r3, [r4, r0]
	add r0, r1, #0
	sub r0, #8
	add r0, r4, r0
	cmp r3, r0
	bne _021E71C6
	add r0, r1, #0
	sub r0, #0x18
	str r2, [r4, r0]
	mov r0, #0
	sub r1, #0xc
	str r0, [r4, r1]
_021E71C6:
	ldr r3, _021E7264 ; =0x000003D1
	add r0, r4, #0
	sub r2, r3, #5
	add r1, r4, r3
	add r3, r3, #1
	ldrb r3, [r4, r3]
	ldr r2, [r4, r2]
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	blx r2
	cmp r0, #0
	beq _021E7202
	add r0, r4, #0
	mov r1, #0
	bl PokeathlonCourse_SetField1F4
	mov r0, #0xf1
	lsl r0, r0, #2
	add r1, r0, #0
	add r2, r4, r0
	sub r1, #0x10
	str r2, [r4, r1]
	mov r1, #0
	sub r0, r0, #4
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0x1c
	bl PokeathlonCourse_SetStateField07
	b _021E725E
_021E7202:
	add r0, r4, #0
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E7248
	bl ov96_021E9A14
	mov r3, #0xad
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, #0x2c
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
	mov r0, #0xb7
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	add r5, r0, #0
	mov r0, #0xa3
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	mov r2, #0x28
_021E723A:
	ldrb r1, [r0]
	add r0, r0, #1
	strb r1, [r5]
	add r5, r5, #1
	sub r2, r2, #1
	bne _021E723A
	b _021E725E
_021E7248:
	bl ov96_021E9A14
	mov r3, #0xa3
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, r3, #4
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
_021E725E:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_021E7264: .word 0x000003D1
	thumb_func_end ov96_021E7190

	thumb_func_start ov96_021E7268
ov96_021E7268: ; 0x021E7268
	push {r4, lr}
	mov r2, #0x1e
	add r4, r0, #0
	lsl r2, r2, #4
	ldr r2, [r4, r2]
	mov r1, #0
	ldr r2, [r2, #0xc]
	blx r2
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _021E7286
	bl GF_AssertFail
_021E7286:
	add r0, r4, #0
	mov r1, #0x18
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov96_021E7268

	thumb_func_start ov96_021E7294
ov96_021E7294: ; 0x021E7294
	push {r4, lr}
	add r4, r0, #0
	bl PokeathlonCourse_ResetDataCopyArea
	mov r0, #0x1e
	ldr r1, _021E72C4 ; =ov96_0221A844
	lsl r0, r0, #4
	str r1, [r4, r0]
	mov r1, #0
	add r0, #0xd
	strb r1, [r4, r0]
	mov r1, #0xf3
	lsl r1, r1, #2
	ldr r0, _021E72C8 ; =ov96_0221DA5C
	add r1, r4, r1
	bl PokeathlonCourse_InitStateInfo
	add r0, r4, #0
	mov r1, #0x20
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, pc}
	nop
_021E72C4: .word ov96_0221A844
_021E72C8: .word ov96_0221DA5C
	thumb_func_end ov96_021E7294

	thumb_func_start ov96_021E72CC
ov96_021E72CC: ; 0x021E72CC
	push {r4, lr}
	add r4, r0, #0
	bl PokeathlonCourse_RunSubStateLoop
	cmp r0, #0
	beq _021E7318
	add r0, r4, #0
	bl PokeathlonCourse_GetDataCopyArea
	add r1, r0, #0
	mov r2, #0
	add r1, #0x24
	strb r2, [r1]
	mov r1, #1
	add r0, #0x4c
	strb r1, [r0]
	add r0, r4, #0
	bl PokeathlonCourse_GetSystem
	mov r1, #1
	bl ov96_021E87B0
	add r0, r4, #0
	mov r1, #0xc
	bl PokeathlonCourse_SetStateTransitionType
	add r0, r4, #0
	mov r1, #0x21
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	bl Sound_SetScene
	ldr r1, _021E731C ; =0x00000474
	mov r0, #0x19
	mov r2, #0
	bl Sound_SetSceneAndPlayBGM
_021E7318:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021E731C: .word 0x00000474
	thumb_func_end ov96_021E72CC

	thumb_func_start ov96_021E7320
ov96_021E7320: ; 0x021E7320
	push {r3, r4, r5, lr}
	mov r1, #0xf3
	add r4, r0, #0
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r3, [r2]
	cmp r3, #0
	bne _021E733A
	mov r1, #0x22
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E733A:
	add r0, r1, #0
	sub r0, #0x18
	ldr r3, [r4, r0]
	add r0, r1, #0
	sub r0, #8
	add r0, r4, r0
	cmp r3, r0
	bne _021E7356
	add r0, r1, #0
	sub r0, #0x18
	str r2, [r4, r0]
	mov r0, #0
	sub r1, #0xc
	str r0, [r4, r1]
_021E7356:
	ldr r3, _021E73F4 ; =0x000003D1
	add r0, r4, #0
	sub r2, r3, #5
	add r1, r4, r3
	add r3, r3, #1
	ldrb r3, [r4, r3]
	ldr r2, [r4, r2]
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	blx r2
	cmp r0, #0
	beq _021E7392
	add r0, r4, #0
	mov r1, #0
	bl PokeathlonCourse_SetField1F4
	mov r0, #0xf1
	lsl r0, r0, #2
	add r1, r0, #0
	add r2, r4, r0
	sub r1, #0x10
	str r2, [r4, r1]
	mov r1, #0
	sub r0, r0, #4
	str r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0x22
	bl PokeathlonCourse_SetStateField07
	b _021E73EE
_021E7392:
	add r0, r4, #0
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E73D8
	bl ov96_021E9A14
	mov r3, #0xad
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, #0x2c
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
	mov r0, #0xb7
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	add r5, r0, #0
	mov r0, #0xa3
	lsl r0, r0, #2
	add r0, r4, r0
	bl ov96_021E8A20
	mov r2, #0x28
_021E73CA:
	ldrb r1, [r0]
	add r0, r0, #1
	strb r1, [r5]
	add r5, r5, #1
	sub r2, r2, #1
	bne _021E73CA
	b _021E73EE
_021E73D8:
	bl ov96_021E9A14
	mov r3, #0xa3
	lsl r3, r3, #2
	add r1, r4, r3
	sub r3, r3, #4
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1b
	bl ov96_021E87B4
_021E73EE:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_021E73F4: .word 0x000003D1
	thumb_func_end ov96_021E7320

	thumb_func_start ov96_021E73F8
ov96_021E73F8: ; 0x021E73F8
	push {r3, r4, r5, r6, r7, lr}
	mov r2, #0x1e
	add r5, r0, #0
	lsl r2, r2, #4
	ldr r2, [r5, r2]
	mov r1, #0
	ldr r2, [r2, #0xc]
	blx r2
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _021E7416
	bl GF_AssertFail
_021E7416:
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_ApricornBox_Get
	add r7, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_PlayerData_GetProfile
	str r0, [sp]
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_Pokeathlon_Get
	bl PokeathlonSave_GetUnkB00
	add r6, r0, #0
	bl sub_02031B10
	lsl r4, r0, #2
	mov r0, #0xa1
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl Heap_AllocAtEnd
	ldr r1, _021E74A4 ; =0x00000D68
	add r2, r4, #0
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	mov r1, #0
	bl memset
	mov r3, #0xa1
	lsl r3, r3, #2
	ldr r1, [sp]
	ldr r2, [r6, #0x70]
	ldr r3, [r5, r3]
	add r0, r7, #0
	bl sub_020320E0
	ldr r1, _021E74A8 ; =0x00000D64
	str r0, [r5, r1]
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0, #4]
	cmp r0, #1
	bne _021E7496
	add r0, r5, #0
	mov r1, #0xe
	bl PokeathlonCourse_SetStateTransitionType
	add r0, r5, #0
	mov r1, #0x23
	bl PokeathlonCourse_SetStateField07
	b _021E749E
_021E7496:
	add r0, r5, #0
	mov r1, #0x25
	bl PokeathlonCourse_SetStateField07
_021E749E:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E74A4: .word 0x00000D68
_021E74A8: .word 0x00000D64
	thumb_func_end ov96_021E73F8

	thumb_func_start ov96_021E74AC
ov96_021E74AC: ; 0x021E74AC
	push {r4, lr}
	add r4, r0, #0
	bl ov96_021E5F24
	bl ov96_021E9A18
	mov r3, #0xa2
	ldr r1, _021E74DC ; =0x00000B44
	lsl r3, r3, #2
	add r2, r0, #0
	ldr r3, [r4, r3]
	mov r0, #0x1f
	add r1, r4, r1
	bl ov96_021E87EC
	cmp r0, #0
	beq _021E74D6
	add r0, r4, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E74D6:
	mov r0, #0
	pop {r4, pc}
	nop
_021E74DC: .word 0x00000B44
	thumb_func_end ov96_021E74AC

	thumb_func_start ov96_021E74E0
ov96_021E74E0: ; 0x021E74E0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r1, #0
	bl PokeathlonCourse_GetFieldData_AtIndex
	add r4, r0, #0
	bl ov96_021E9A1C
	add r6, r0, #0
	add r0, r5, #0
	bl PokeathlonCourse_GetSystem
	add r3, r0, #0
	mov r0, #0x20
	add r1, r4, #0
	add r2, r6, #0
	bl ov96_021E87EC
	cmp r0, #0
	beq _021E7510
	add r0, r5, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E7510:
	mov r0, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov96_021E74E0

	thumb_func_start ov96_021E7514
ov96_021E7514: ; 0x021E7514
	push {r4, lr}
	add r4, r0, #0
	bl sub_02031B10
	ldr r1, _021E7540 ; =0x00000D64
	mov r3, #0xa2
	lsl r3, r3, #2
	add r2, r0, #0
	ldr r1, [r4, r1]
	ldr r3, [r4, r3]
	mov r0, #0x21
	bl ov96_021E87EC
	cmp r0, #0
	beq _021E753A
	add r0, r4, #0
	mov r1, #0x26
	bl PokeathlonCourse_SetStateField07
_021E753A:
	mov r0, #0
	pop {r4, pc}
	nop
_021E7540: .word 0x00000D64
	thumb_func_end ov96_021E7514

	thumb_func_start ov96_021E7544
ov96_021E7544: ; 0x021E7544
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_ApricornBox_Get
	add r4, r0, #0
	add r0, r5, #0
	bl PokeathlonCourse_GetParticipantCount
	add r6, r0, #0
	bl sub_0203769C
	ldr r1, _021E758C ; =0x00000D68
	add r3, r0, #0
	ldr r1, [r5, r1]
	add r0, r4, #0
	add r2, r6, #0
	bl sub_020321A0
	mov r0, #0x5c
	bl GF_heap_c_dummy_return_true
	cmp r0, #0
	bne _021E757E
	bl GF_AssertFail
_021E757E:
	add r0, r5, #0
	mov r1, #0x25
	bl PokeathlonCourse_SetStateField07
	mov r0, #0
	pop {r4, r5, r6, pc}
	nop
_021E758C: .word 0x00000D68
	thumb_func_end ov96_021E7544

	thumb_func_start ov96_021E7590
ov96_021E7590: ; 0x021E7590
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x5c
	bl GF_heap_c_dummy_return_true
	cmp r0, #0
	bne _021E75A2
	bl GF_AssertFail
_021E75A2:
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	ldrb r0, [r0, #0xe]
	cmp r0, #0
	bne _021E75B4
	add r0, r4, #0
	bl ov96_021E7718
_021E75B4:
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov96_021E7590

	thumb_func_start ov96_021E75B8
ov96_021E75B8: ; 0x021E75B8
	mov r0, #0
	bx lr
	thumb_func_end ov96_021E75B8

	thumb_func_start ov96_021E75BC
ov96_021E75BC: ; 0x021E75BC
	push {r4, lr}
	add r4, r0, #0
	bl OamManager_ApplyAndResetBuffers
	add r0, r4, #0
	bl DoScheduledBgGpuUpdates
	bl GF_RunVramTransferTasks
	ldr r3, _021E75DC ; =0x027E0000
	ldr r1, _021E75E0 ; =0x00003FF8
	mov r0, #1
	ldr r2, [r3, r1]
	orr r0, r2
	str r0, [r3, r1]
	pop {r4, pc}
	.balign 4, 0
_021E75DC: .word 0x027E0000
_021E75E0: .word 0x00003FF8
	thumb_func_end ov96_021E75BC

	thumb_func_start ov96_021E75E4
ov96_021E75E4: ; 0x021E75E4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r7, r0, #0
	bl PokeathlonCourse_GetDataCopyArea
	str r0, [sp]
	add r0, r7, #0
	bl ov96_021E5F24
	cmp r0, #0
	beq _021E7604
	bl GF_AssertFail
	add sp, #8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E7604:
	mov r0, #0x5e
	lsl r0, r0, #4
	add r5, r7, r0
	ldr r0, [sp]
	mov r4, #0
	str r0, [sp, #4]
	add r0, #0x28
	str r0, [sp, #4]
_021E7614:
	add r0, r7, #0
	bl PokeathlonCourse_GetUnkConstant4
	add r6, r0, #0
	ldr r0, [sp, #4]
	bl ov96_021E8A20
	add r1, r4, #0
	mul r1, r6
	add r0, r0, r1
	add r1, r5, #0
	add r2, r6, #0
	bl memcpy
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _021E7614
	bl ov96_021E9A14
	add r4, r0, #0
	add r0, r7, #0
	bl PokeathlonCourse_GetSystem
	ldr r1, [sp]
	add r3, r0, #0
	add r1, #0x28
	mov r0, #0x1e
	add r2, r4, #0
	str r1, [sp]
	bl ov96_021E87B4
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E75E4

	thumb_func_start ov96_021E7658
ov96_021E7658: ; 0x021E7658
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	str r1, [sp]
	bl ov96_021E5F24
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, [sp]
	mov r4, #0
	lsl r0, r0, #1
	add r6, r5, r0
_021E766E:
	ldr r0, _021E7708 ; =0x00000614
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl ov96_021E9370
	add r3, r0, #0
	lsl r0, r4, #3
	add r2, r6, r0
	ldrh r1, [r3, #0xa]
	ldr r0, _021E770C ; =0x000008B4
	strh r1, [r2, r0]
	ldr r1, [r3, #0xc]
	add r0, #0x20
	strh r1, [r2, r0]
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _021E766E
	mov r4, #0
_021E7696:
	ldr r0, _021E7708 ; =0x00000614
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl ov96_021E94EC
	add r6, r0, #0
	ldr r0, [r6]
	cmp r0, r7
	beq _021E76B2
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _021E7696
_021E76B2:
	cmp r4, #4
	bne _021E76BC
	bl GF_AssertFail
	pop {r3, r4, r5, r6, r7, pc}
_021E76BC:
	ldrb r0, [r6, #9]
	cmp r0, #0
	bne _021E76D4
	ldr r0, [sp]
	mov r1, #1
	add r2, r5, r0
	ldr r0, _021E7710 ; =0x000008F4
	strb r1, [r2, r0]
	mov r1, #0
	add r0, r0, #4
	strb r1, [r2, r0]
	pop {r3, r4, r5, r6, r7, pc}
_021E76D4:
	ldr r0, [sp]
	mov r2, #0
	add r1, r5, r0
	ldr r0, _021E7710 ; =0x000008F4
	strb r2, [r1, r0]
	ldr r0, _021E7708 ; =0x00000614
	mov r1, #3
	ldr r0, [r5, r0]
	bl ov96_021E94EC
	ldrb r1, [r0, #9]
	ldrb r0, [r6, #9]
	cmp r1, r0
	bne _021E76FC
	ldr r0, [sp]
	mov r2, #1
	add r1, r5, r0
	ldr r0, _021E7714 ; =0x000008F8
	strb r2, [r1, r0]
	pop {r3, r4, r5, r6, r7, pc}
_021E76FC:
	ldr r0, [sp]
	mov r2, #0
	add r1, r5, r0
	ldr r0, _021E7714 ; =0x000008F8
	strb r2, [r1, r0]
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E7708: .word 0x00000614
_021E770C: .word 0x000008B4
_021E7710: .word 0x000008F4
_021E7714: .word 0x000008F8
	thumb_func_end ov96_021E7658

	thumb_func_start ov96_021E7718
ov96_021E7718: ; 0x021E7718
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_Pokeathlon_Get
	add r6, r0, #0
	add r0, r5, #0
	bl PokeathlonCourse_GetFieldData
	add r4, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_VarsFlags_Get
	str r0, [sp]
	mov r0, #0x1d
	lsl r0, r0, #4
	ldrh r0, [r4, r0]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	beq _021E7772
	add r0, r5, #0
	bl ov96_021E7FA8
	ldr r0, [sp]
	mov r1, #0xf0
	bl Save_VarsFlags_CheckFlagInArray
	cmp r0, #0
	bne _021E7772
	add r0, r5, #0
	bl ov96_021E8084
	cmp r0, #0
	beq _021E7772
	ldr r0, [sp]
	mov r1, #0xf0
	bl Save_VarsFlags_SetFlagInArray
_021E7772:
	ldr r0, _021E7868 ; =0x000001D2
	ldrh r7, [r4, r0]
	add r0, #0x26
	ldr r0, [r5, r0]
	ldrb r0, [r0, #0xc]
	cmp r0, #0xa
	bne _021E7784
	lsl r0, r7, #0x11
	lsr r7, r0, #0x10
_021E7784:
	add r0, r6, #0
	add r1, r7, #0
	bl PokeathlonSave_AddAthletePoints
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0, #4]
	cmp r0, #1
	bne _021E77A8
	add r0, r6, #0
	bl PokeathlonSave_GetRecordsLink2
	add r1, r0, #0
	add r0, r5, #0
	bl ov96_021E7A2C
	b _021E780A
_021E77A8:
	add r0, r6, #0
	bl PokeathlonSave_GetRecordsSolo
	str r0, [sp, #4]
	add r0, r6, #0
	bl PokeathlonSave_GetUnkAEC
	add r2, r0, #0
	ldr r1, [sp, #4]
	add r0, r5, #0
	bl ov96_021E7BA8
	mov r0, #0x1d
	lsl r0, r0, #4
	ldrh r0, [r4, r0]
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	beq _021E77FC
	add r0, r6, #0
	bl PokeathlonSave_dummy2
	add r1, r0, #0
	add r0, r5, #0
	bl ov96_021E786C
	ldr r0, [sp]
	mov r1, #0xef
	bl Save_VarsFlags_CheckFlagInArray
	cmp r0, #0
	bne _021E77FC
	add r0, r6, #0
	bl PokeathlonSave_dummy2
	bl ov96_021E8060
	cmp r0, #0
	beq _021E77FC
	ldr r0, [sp]
	mov r1, #0xef
	bl Save_VarsFlags_SetFlagInArray
_021E77FC:
	add r0, r6, #0
	bl PokeathlonSave_GetRecordsSolo2
	add r1, r0, #0
	add r0, r5, #0
	bl ov96_021E7938
_021E780A:
	add r0, r6, #0
	bl PokeathlonSave_GetAgainUnkB00
	add r1, r0, #0
	add r0, r5, #0
	bl ov96_021E7D6C
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0, #4]
	cmp r0, #0
	bne _021E7842
	ldr r0, [sp]
	mov r1, #0xf1
	bl Save_VarsFlags_CheckFlagInArray
	cmp r0, #0
	bne _021E7842
	add r0, r5, #0
	bl ov96_021E80C4
	cmp r0, #0
	beq _021E7842
	ldr r0, [sp]
	mov r1, #0xf1
	bl Save_VarsFlags_SetFlagInArray
_021E7842:
	ldr r1, _021E7868 ; =0x000001D2
	add r0, r1, #0
	add r0, #0x26
	ldrh r2, [r4, r1]
	ldr r0, [r5, r0]
	strh r2, [r0, #0xa]
	add r0, r1, #0
	add r0, #0x26
	ldr r0, [r5, r0]
	strh r7, [r0, #8]
	sub r0, r1, #2
	ldrh r0, [r4, r0]
	add r1, #0x26
	lsl r0, r0, #0x1c
	lsr r2, r0, #0x1e
	ldr r0, [r5, r1]
	strb r2, [r0, #0xd]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E7868: .word 0x000001D2
	thumb_func_end ov96_021E7718
