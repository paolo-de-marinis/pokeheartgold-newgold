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


	thumb_func_start ov96_021E7938
ov96_021E7938: ; 0x021E7938
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0xd0
	str r0, [sp]
	mov r0, #0
	str r1, [sp, #4]
	str r0, [sp, #8]
_021E7944:
	ldr r0, [sp, #8]
	lsl r1, r0, #2
	ldr r0, [sp]
	add r1, r0, r1
	mov r0, #0xf6
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0x2c
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	add r2, r0, #0
	mul r2, r1
	ldr r1, [sp, #4]
	add r7, r1, r2
	ldr r2, [r7, #0x28]
	ldr r1, _021E7A20 ; =0x0098967F
	cmp r2, r1
	bhs _021E796C
	add r1, r2, #1
	str r1, [r7, #0x28]
_021E796C:
	ldr r1, _021E7A24 ; =_0221A7D8
	mov r3, #0
	ldrb r0, [r1, r0]
	add r2, sp, #0x30
	str r0, [sp, #0xc]
_021E7976:
	lsl r0, r3, #3
	add r5, r7, r0
	ldrh r0, [r7, r0]
	lsl r1, r3, #5
	add r6, r2, r1
	strh r0, [r2, r1]
	mov r4, #0
_021E7984:
	lsl r1, r4, #1
	add r0, r5, r1
	ldrh r0, [r0, #2]
	add r1, r6, r1
	strh r0, [r1, #2]
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #3
	blo _021E7984
	add r0, r3, #1
	lsl r0, r0, #0x18
	lsr r3, r0, #0x18
	cmp r3, #5
	blo _021E7976
	ldr r0, [sp]
	bl ov96_021E5F24
	lsl r0, r0, #0x18
	lsr r2, r0, #0x15
	ldr r0, [sp, #8]
	lsl r1, r0, #1
	ldr r0, [sp]
	add r0, r0, r2
	add r1, r1, r0
	ldr r0, _021E7A28 ; =0x000008D4
	ldrh r1, [r1, r0]
	add r0, sp, #0x10
	strh r1, [r0]
	ldr r0, [sp]
	bl ov96_021E5F24
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	mov r1, #0x3f
	ldr r0, [sp]
	lsl r1, r1, #4
	add r1, r0, r1
	mov r0, #0x7c
	mul r0, r2
	add r0, r1, r0
	mov r1, #0
	add r3, sp, #0x10
	mov r2, #0x28
_021E79DC:
	add r5, r1, #0
	mul r5, r2
	add r4, r0, r5
	ldrh r4, [r4, #2]
	ldrh r5, [r0, r5]
	lsl r4, r4, #0xa
	add r4, r4, r5
	lsl r5, r1, #1
	add r1, r1, #1
	lsl r1, r1, #0x18
	add r5, r3, r5
	lsr r1, r1, #0x18
	strh r4, [r5, #2]
	cmp r1, #3
	blo _021E79DC
	ldr r0, [sp, #0xc]
	add r1, r3, #0
	add r2, sp, #0x30
	bl ov96_021E7C04
	ldr r0, [sp]
	add r1, r7, #0
	add r2, sp, #0x30
	bl ov96_021E7C94
	ldr r0, [sp, #8]
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	cmp r0, #3
	blo _021E7944
	add sp, #0xd0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E7A20: .word 0x0098967F
_021E7A24: .word _0221A7D8
_021E7A28: .word 0x000008D4
	thumb_func_end ov96_021E7938

	thumb_func_start ov96_021E7A2C
ov96_021E7A2C: ; 0x021E7A2C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0xe0
	str r0, [sp]
	str r1, [sp, #4]
	bl ov96_021E5F24
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #8]
_021E7A42:
	ldr r0, [sp, #8]
	lsl r1, r0, #2
	ldr r0, [sp]
	add r1, r0, r1
	mov r0, #0xf6
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #0xa4
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	add r2, r0, #0
	mul r2, r1
	ldr r1, [sp, #4]
	add r1, r1, r2
	str r1, [sp, #0x14]
	ldr r2, [r1, #0x28]
	ldr r1, _021E7B9C ; =0x0098967F
	cmp r2, r1
	bhs _021E7A6E
	ldr r1, [sp, #0x14]
	add r2, r2, #1
	str r2, [r1, #0x28]
_021E7A6E:
	ldr r1, _021E7BA0 ; =_0221A7D8
	add r4, sp, #0x40
	ldrb r0, [r1, r0]
	mov r1, #0
	mov r7, #0x18
	str r0, [sp, #0x18]
_021E7A7A:
	ldr r2, [sp, #0x14]
	lsl r3, r1, #3
	add r6, r2, r3
	ldrh r2, [r2, r3]
	lsl r5, r1, #5
	add r0, r4, r5
	strh r2, [r4, r5]
	mov r5, #0
_021E7A8A:
	lsl r3, r5, #1
	add r2, r6, r3
	ldrh r2, [r2, #2]
	add r3, r0, r3
	strh r2, [r3, #2]
	add r2, r5, #1
	lsl r2, r2, #0x18
	lsr r5, r2, #0x18
	cmp r5, #3
	blo _021E7A8A
	add r3, r1, #0
	ldr r2, [sp, #0x14]
	mul r3, r7
	add r6, r2, r3
	ldr r2, [r6, #0x2c]
	mov r5, #0
	str r2, [r0, #8]
_021E7AAC:
	lsl r3, r5, #1
	add r2, r6, r3
	ldrh r2, [r2, #0x30]
	add r3, r0, r3
	strh r2, [r3, #0xc]
	add r2, r5, #1
	lsl r2, r2, #0x18
	lsr r5, r2, #0x18
	cmp r5, #8
	blo _021E7AAC
	add r6, #0x40
	ldrb r2, [r6]
	strb r2, [r0, #0x1c]
	add r0, r1, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	cmp r1, #5
	blo _021E7A7A
	ldr r0, [sp, #8]
	mov r7, #0
	lsl r1, r0, #1
	ldr r0, [sp]
	add r5, sp, #0x20
	add r0, r0, r1
	str r0, [sp, #0xc]
	mov r1, #0x3f
	ldr r0, [sp]
	lsl r1, r1, #4
	add r0, r0, r1
	str r0, [sp, #0x1c]
	mov r4, #0x28
_021E7AEA:
	ldr r0, [sp, #0x10]
	add r0, r0, r7
	lsr r2, r0, #0x1f
	lsl r1, r0, #0x1e
	sub r1, r1, r2
	mov r0, #0x1e
	ror r1, r0
	add r0, r2, r1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	ldr r0, [sp, #0xc]
	lsl r2, r1, #3
	add r2, r0, r2
	ldr r0, _021E7BA4 ; =0x000008D4
	ldrh r2, [r2, r0]
	add r0, sp, #0x20
	strh r2, [r0]
	mov r0, #0x7c
	add r2, r1, #0
	mul r2, r0
	ldr r0, [sp, #0x1c]
	add r0, r0, r2
	mov r2, #0
_021E7B18:
	add r6, r2, #0
	mul r6, r4
	add r3, r0, r6
	ldrh r3, [r3, #2]
	ldrh r6, [r0, r6]
	lsl r3, r3, #0xa
	add r3, r3, r6
	lsl r6, r2, #1
	add r2, r2, #1
	lsl r2, r2, #0x18
	add r6, r5, r6
	lsr r2, r2, #0x18
	strh r3, [r6, #2]
	cmp r2, #3
	blo _021E7B18
	ldr r0, [sp]
	bl PokeathlonCourse_GetPlayerProfileFromData
	add r6, r0, #0
	bl PlayerProfile_GetTrainerID
	str r0, [sp, #0x28]
	add r0, r6, #0
	bl PlayerProfile_GetNamePtr
	mov r1, #0
_021E7B4C:
	lsl r2, r1, #1
	ldrh r3, [r0, r2]
	add r1, r1, #1
	lsl r1, r1, #0x18
	add r2, r5, r2
	lsr r1, r1, #0x18
	strh r3, [r2, #0xc]
	cmp r1, #8
	blo _021E7B4C
	add r0, r6, #0
	bl PlayerProfile_GetLanguage
	add r1, sp, #0x20
	strb r0, [r1, #0x1c]
	ldr r0, [sp, #0x18]
	add r1, r5, #0
	add r2, sp, #0x40
	bl ov96_021E7C04
	add r0, r7, #1
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	cmp r7, #4
	blo _021E7AEA
	ldr r0, [sp]
	ldr r1, [sp, #0x14]
	add r2, sp, #0x40
	bl ov96_021E7CC8
	ldr r0, [sp, #8]
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	cmp r0, #4
	bhs _021E7B96
	b _021E7A42
_021E7B96:
	add sp, #0xe0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E7B9C: .word 0x0098967F
_021E7BA0: .word _0221A7D8
_021E7BA4: .word 0x000008D4
	thumb_func_end ov96_021E7A2C

	thumb_func_start ov96_021E7BA8
ov96_021E7BA8: ; 0x021E7BA8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r7, r0, #0
	str r1, [sp]
	str r2, [sp, #4]
	mov r4, #0
_021E7BB4:
	lsl r0, r4, #2
	add r1, r7, r0
	mov r0, #0xf6
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	ldr r2, _021E7BF8 ; =_0221A7D8
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	lsl r0, r4, #1
	add r6, r7, r0
	mov r0, #0x2c
	add r1, r5, #0
	mul r1, r0
	ldr r0, [sp]
	ldrb r2, [r2, r5]
	ldrh r0, [r0, r1]
	ldr r1, _021E7BFC ; =0x000008D4
	ldrh r1, [r6, r1]
	bl ov96_021E7D18
	cmp r0, #0
	beq _021E7BEA
	ldr r0, _021E7C00 ; =0x000008B4
	lsl r1, r5, #1
	ldrh r2, [r6, r0]
	ldr r0, [sp, #4]
	strh r2, [r0, r1]
_021E7BEA:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #3
	blo _021E7BB4
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E7BF8: .word _0221A7D8
_021E7BFC: .word 0x000008D4
_021E7C00: .word 0x000008B4
	thumb_func_end ov96_021E7BA8

	thumb_func_start ov96_021E7C04
ov96_021E7C04: ; 0x021E7C04
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r6, r2, #0
	add r7, r0, #0
	add r0, r6, #0
	add r4, r1, #0
	add r0, #0x80
	ldrh r0, [r0]
	ldrh r1, [r4]
	add r2, r7, #0
	bl ov96_021E7D18
	cmp r0, #0
	beq _021E7C90
	add r6, #0x80
	ldmia r4!, {r0, r1}
	add r5, r6, #0
	stmia r6!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r6!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r6!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r6!, {r0, r1}
	mov r4, #4
_021E7C36:
	add r0, r5, #0
	sub r0, #0x20
	ldrh r0, [r0]
	ldrh r1, [r5]
	add r2, r7, #0
	bl ov96_021E7D18
	cmp r0, #0
	beq _021E7C90
	add r3, r5, #0
	sub r3, #0x20
	add r2, sp, #0
	add r6, r2, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	add r2, r5, #0
	add r3, r5, #0
	sub r2, #0x20
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	add r2, r5, #0
	ldmia r6!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r6!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r6!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r6!, {r0, r1}
	sub r4, r4, #1
	sub r5, #0x20
	stmia r2!, {r0, r1}
	cmp r4, #0
	bgt _021E7C36
_021E7C90:
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E7C04

	thumb_func_start ov96_021E7C94
ov96_021E7C94: ; 0x021E7C94
	push {r3, r4, r5, r6, r7, lr}
	add r5, r1, #0
	add r4, r2, #0
	bl ov96_021E5F24
	mov r2, #0
	add r1, r2, #0
_021E7CA2:
	ldrh r0, [r4]
	add r3, r1, #0
	add r6, r4, #0
	strh r0, [r5]
	add r7, r5, #0
_021E7CAC:
	ldrh r0, [r6, #2]
	add r3, r3, #1
	add r6, r6, #2
	strh r0, [r7, #2]
	add r7, r7, #2
	cmp r3, #3
	blt _021E7CAC
	add r2, r2, #1
	add r4, #0x20
	add r5, #8
	cmp r2, #5
	blt _021E7CA2
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E7C94

	thumb_func_start ov96_021E7CC8
ov96_021E7CC8: ; 0x021E7CC8
	push {r4, r5, r6, r7}
	mov r0, #0
	add r3, r1, #0
_021E7CCE:
	ldrh r4, [r2]
	mov r5, #0
	add r6, r2, #0
	strh r4, [r1]
	add r7, r1, #0
_021E7CD8:
	ldrh r4, [r6, #2]
	add r5, r5, #1
	add r6, r6, #2
	strh r4, [r7, #2]
	add r7, r7, #2
	cmp r5, #3
	blt _021E7CD8
	ldr r4, [r2, #8]
	mov r5, #0
	str r4, [r3, #0x2c]
	add r6, r2, #0
	add r7, r3, #0
_021E7CF0:
	ldrh r4, [r6, #0xc]
	add r5, r5, #1
	add r6, r6, #2
	strh r4, [r7, #0x30]
	add r7, r7, #2
	cmp r5, #8
	blt _021E7CF0
	ldrb r5, [r2, #0x1c]
	add r4, r3, #0
	add r4, #0x40
	add r0, r0, #1
	strb r5, [r4]
	add r2, #0x20
	add r1, #8
	add r3, #0x18
	cmp r0, #5
	blt _021E7CCE
	pop {r4, r5, r6, r7}
	bx lr
	.balign 4, 0
	thumb_func_end ov96_021E7CC8

	thumb_func_start ov96_021E7D18
ov96_021E7D18: ; 0x021E7D18
	push {r3, lr}
	ldr r3, _021E7D2C ; =0x0000FFFF
	cmp r0, r3
	bne _021E7D24
	mov r0, #1
	pop {r3, pc}
_021E7D24:
	bl ov96_021E7D30
	pop {r3, pc}
	nop
_021E7D2C: .word 0x0000FFFF
	thumb_func_end ov96_021E7D18

	thumb_func_start ov96_021E7D30
ov96_021E7D30: ; 0x021E7D30
	push {r4, lr}
	mov r4, #0
	cmp r2, #0
	bne _021E7D4A
	ldr r2, _021E7D68 ; =0x0000FFFF
	cmp r0, r2
	bne _021E7D42
	mov r4, #1
	b _021E7D64
_021E7D42:
	cmp r0, r1
	bge _021E7D64
	mov r4, #1
	b _021E7D64
_021E7D4A:
	cmp r2, #1
	bne _021E7D60
	ldr r2, _021E7D68 ; =0x0000FFFF
	cmp r0, r2
	bne _021E7D58
	mov r4, #1
	b _021E7D64
_021E7D58:
	cmp r0, r1
	ble _021E7D64
	mov r4, #1
	b _021E7D64
_021E7D60:
	bl GF_AssertFail
_021E7D64:
	add r0, r4, #0
	pop {r4, pc}
	.balign 4, 0
_021E7D68: .word 0x0000FFFF
	thumb_func_end ov96_021E7D30

	thumb_func_start ov96_021E7D6C
ov96_021E7D6C: ; 0x021E7D6C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	str r1, [sp]
	ldr r1, _021E7F3C ; =0x0000072C
	add r5, r0, #0
	add r7, r5, r1
	bl ov96_021E5F24
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r1, _021E7F40 ; =0x0098967F
	ldr r0, [r0, #4]
	cmp r0, #1
	bne _021E7DCE
	ldr r2, [sp]
	mov r0, #1
	add r2, #0x38
	bl ov96_021E7F98
	mov r0, #0x1d
	lsl r0, r0, #4
	ldrh r0, [r7, r0]
	lsl r1, r0, #0x1f
	lsr r1, r1, #0x1f
	beq _021E7DBA
	ldr r2, [sp]
	ldr r1, _021E7F40 ; =0x0098967F
	mov r0, #1
	add r2, #0x3c
	bl ov96_021E7F98
	add r0, r5, #0
	bl ov96_021E7F48
	b _021E7E0A
_021E7DBA:
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	beq _021E7E0A
	ldr r2, [sp]
	ldr r1, _021E7F40 ; =0x0098967F
	mov r0, #1
	add r2, #0x40
	bl ov96_021E7F98
	b _021E7E0A
_021E7DCE:
	ldr r2, [sp]
	mov r0, #1
	add r2, r2, #4
	bl ov96_021E7F98
	mov r0, #0x1d
	lsl r0, r0, #4
	ldrh r0, [r7, r0]
	lsl r1, r0, #0x1f
	lsr r1, r1, #0x1f
	beq _021E7DF8
	ldr r2, [sp]
	ldr r1, _021E7F40 ; =0x0098967F
	mov r0, #1
	add r2, #8
	bl ov96_021E7F98
	add r0, r5, #0
	bl ov96_021E7F48
	b _021E7E0A
_021E7DF8:
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	beq _021E7E0A
	ldr r2, [sp]
	ldr r1, _021E7F40 ; =0x0098967F
	mov r0, #1
	add r2, #0xc
	bl ov96_021E7F98
_021E7E0A:
	ldr r0, _021E7F44 ; =0x0000072A
	mov r4, #0
	ldrb r0, [r5, r0]
	cmp r0, #0
	bls _021E7E68
	ldr r0, [sp]
	ldr r6, [sp]
	str r0, [sp, #0xc]
	add r0, #0x6c
	str r0, [sp, #0xc]
	add r6, #0x44
_021E7E20:
	mov r1, #0x72
	add r0, r7, r4
	lsl r1, r1, #2
	ldrb r1, [r0, r1]
	cmp r1, #0
	beq _021E7E46
	lsl r2, r4, #2
	add r3, r5, r2
	mov r2, #0xf6
	lsl r2, r2, #2
	ldr r2, [r3, r2]
	ldr r1, _021E7F40 ; =0x0098967F
	lsl r2, r2, #0x18
	lsr r2, r2, #0x16
	mov r0, #1
	add r2, r6, r2
	bl ov96_021E7F98
	b _021E7E5A
_021E7E46:
	mov r1, #0x73
	lsl r1, r1, #2
	ldrb r0, [r0, r1]
	cmp r0, #0
	beq _021E7E5A
	ldr r1, _021E7F40 ; =0x0098967F
	ldr r2, [sp, #0xc]
	mov r0, #1
	bl ov96_021E7F98
_021E7E5A:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	ldr r0, _021E7F44 ; =0x0000072A
	ldrb r0, [r5, r0]
	cmp r4, r0
	blo _021E7E20
_021E7E68:
	ldr r0, [sp, #8]
	mov r1, #0x60
	mul r1, r0
	add r0, r7, r1
	str r0, [sp, #4]
	ldr r0, [sp]
	ldr r4, _021E7F40 ; =0x0098967F
	str r0, [sp, #0x10]
	add r0, #0x18
	str r0, [sp, #0x10]
	ldr r0, [sp]
	mov r6, #0
	str r0, [sp, #0x14]
	add r0, #0x1c
	str r0, [sp, #0x14]
	ldr r0, [sp]
	str r0, [sp, #0x18]
	add r0, #0x20
	str r0, [sp, #0x18]
	ldr r0, [sp]
	str r0, [sp, #0x1c]
	add r0, #0x24
	str r0, [sp, #0x1c]
	ldr r0, [sp]
	str r0, [sp, #0x20]
	add r0, #0x28
	str r0, [sp, #0x20]
	ldr r0, [sp]
	str r0, [sp, #0x24]
	add r0, #0x2c
	str r0, [sp, #0x24]
	ldr r0, [sp]
	str r0, [sp, #0x28]
	add r0, #0x30
	str r0, [sp, #0x28]
	ldr r0, [sp]
	str r0, [sp, #0x2c]
	add r0, #0x34
	str r0, [sp, #0x2c]
_021E7EB6:
	ldr r0, [sp, #4]
	lsl r1, r6, #5
	add r5, r0, r1
	ldr r0, [r0, r1]
	ldr r2, [sp, #0x10]
	add r1, r4, #0
	bl ov96_021E7F98
	ldr r0, [r5, #4]
	ldr r2, [sp, #0x14]
	add r1, r4, #0
	bl ov96_021E7F98
	ldr r0, [r5, #8]
	ldr r2, [sp, #0x18]
	add r1, r4, #0
	bl ov96_021E7F98
	ldr r0, [r5, #0xc]
	ldr r2, [sp, #0x1c]
	add r1, r4, #0
	bl ov96_021E7F98
	ldr r0, [r5, #0x10]
	ldr r2, [sp, #0x20]
	add r1, r4, #0
	bl ov96_021E7F98
	ldr r0, [r5, #0x14]
	ldr r2, [sp, #0x24]
	add r1, r4, #0
	bl ov96_021E7F98
	ldr r0, [r5, #0x18]
	ldr r2, [sp, #0x28]
	add r1, r4, #0
	bl ov96_021E7F98
	ldr r0, [r5, #0x1c]
	ldr r2, [sp, #0x2c]
	add r1, r4, #0
	bl ov96_021E7F98
	add r0, r6, #1
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	cmp r6, #3
	blo _021E7EB6
	mov r0, #6
	lsl r0, r0, #6
	ldr r2, [sp]
	ldr r0, [r7, r0]
	ldr r1, _021E7F40 ; =0x0098967F
	add r2, #0x10
	bl ov96_021E7F98
	mov r0, #0x61
	lsl r0, r0, #2
	ldr r2, [sp]
	ldr r0, [r7, r0]
	add r2, #0x14
	ldr r1, _021E7F40 ; =0x0098967F
	str r2, [sp]
	bl ov96_021E7F98
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E7F3C: .word 0x0000072C
_021E7F40: .word 0x0098967F
_021E7F44: .word 0x0000072A
	thumb_func_end ov96_021E7D6C

	thumb_func_start ov96_021E7F48
ov96_021E7F48: ; 0x021E7F48
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_Pokeathlon_FriendshipRecords_Get
	add r4, r0, #0
	add r0, r5, #0
	bl ov96_021E5F24
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	mov r0, #0x3f
	lsl r0, r0, #4
	add r1, r5, r0
	mov r0, #0x7c
	mul r0, r2
	add r3, r1, r0
	mov r2, #0
	mov r5, #0x28
_021E7F74:
	add r6, r2, #0
	mul r6, r5
	add r1, r3, r6
	ldrh r6, [r3, r6]
	lsl r7, r2, #2
	add r0, r4, r7
	strh r6, [r4, r7]
	ldrh r6, [r1, #2]
	strb r6, [r0, #3]
	ldrb r1, [r1, #0x11]
	strb r1, [r0, #2]
	add r0, r2, #1
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	cmp r2, #3
	blo _021E7F74
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E7F48

	thumb_func_start ov96_021E7F98
ov96_021E7F98: ; 0x021E7F98
	ldr r3, [r2]
	add r0, r3, r0
	cmp r0, r1
	bls _021E7FA4
	str r1, [r2]
	bx lr
_021E7FA4:
	str r0, [r2]
	bx lr
	thumb_func_end ov96_021E7F98

	thumb_func_start ov96_021E7FA8
ov96_021E7FA8: ; 0x021E7FA8
	push {r3, lr}
	mov r1, #0x7e
	lsl r1, r1, #2
	ldr r1, [r0, r1]
	ldrb r1, [r1, #0xc]
	cmp r1, #9
	bhi _021E8024
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021E7FC2: ; jump table
	.short _021E7FD6 - _021E7FC2 - 2 ; case 0
	.short _021E7FDE - _021E7FC2 - 2 ; case 1
	.short _021E7FE6 - _021E7FC2 - 2 ; case 2
	.short _021E7FEE - _021E7FC2 - 2 ; case 3
	.short _021E7FF6 - _021E7FC2 - 2 ; case 4
	.short _021E7FFE - _021E7FC2 - 2 ; case 5
	.short _021E8006 - _021E7FC2 - 2 ; case 6
	.short _021E800E - _021E7FC2 - 2 ; case 7
	.short _021E8016 - _021E7FC2 - 2 ; case 8
	.short _021E801E - _021E7FC2 - 2 ; case 9
_021E7FD6:
	mov r1, #1
	bl ov96_021E8028
	pop {r3, pc}
_021E7FDE:
	mov r1, #2
	bl ov96_021E8028
	pop {r3, pc}
_021E7FE6:
	mov r1, #4
	bl ov96_021E8028
	pop {r3, pc}
_021E7FEE:
	mov r1, #8
	bl ov96_021E8028
	pop {r3, pc}
_021E7FF6:
	mov r1, #0x10
	bl ov96_021E8028
	pop {r3, pc}
_021E7FFE:
	mov r1, #0x11
	bl ov96_021E8028
	pop {r3, pc}
_021E8006:
	mov r1, #0x14
	bl ov96_021E8028
	pop {r3, pc}
_021E800E:
	mov r1, #6
	bl ov96_021E8028
	pop {r3, pc}
_021E8016:
	mov r1, #0xa
	bl ov96_021E8028
	pop {r3, pc}
_021E801E:
	mov r1, #9
	bl ov96_021E8028
_021E8024:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov96_021E7FA8

	thumb_func_start ov96_021E8028
ov96_021E8028: ; 0x021E8028
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r6, r1, #0
	ldr r0, [r0]
	bl Save_Pokeathlon_Get
	add r7, r0, #0
	mov r4, #0
_021E803E:
	mov r2, #0x28
	mul r2, r4
	add r3, r5, r2
	mov r2, #0x81
	lsl r2, r2, #2
	ldrh r2, [r3, r2]
	add r0, r7, #0
	add r1, r6, #0
	bl PokeathlonSave_SetUnkDC_AtIndex
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #3
	blo _021E803E
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8028

	thumb_func_start ov96_021E8060
ov96_021E8060: ; 0x021E8060
	mov r3, #0
	mov r2, #0x2c
_021E8064:
	add r1, r3, #0
	mul r1, r2
	add r1, r0, r1
	ldrh r1, [r1, #6]
	cmp r1, #0
	bne _021E8074
	mov r0, #0
	bx lr
_021E8074:
	add r1, r3, #1
	lsl r1, r1, #0x18
	lsr r3, r1, #0x18
	cmp r3, #5
	blo _021E8064
	mov r0, #1
	bx lr
	.balign 4, 0
	thumb_func_end ov96_021E8060

	thumb_func_start ov96_021E8084
ov96_021E8084: ; 0x021E8084
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	ldr r0, [r0]
	bl Save_Pokeathlon_Get
	add r7, r0, #0
	mov r4, #0
_021E8098:
	mov r0, #0x28
	mul r0, r4
	add r1, r6, r0
	mov r0, #0x81
	lsl r0, r0, #2
	ldrh r0, [r1, r0]
	sub r5, r0, #1
	add r0, r7, #0
	bl PokeathlonSave_GetUnkDC
	ldrb r0, [r0, r5]
	cmp r0, #0x1f
	bne _021E80B6
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021E80B6:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #3
	blo _021E8098
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E8084

	thumb_func_start ov96_021E80C4
ov96_021E80C4: ; 0x021E80C4
	push {r3, r4, r5, r6, r7, lr}
	mov r1, #0x7e
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	ldr r0, [r0]
	bl Save_Pokeathlon_Get
	bl PokeathlonSave_GetRecordsSolo2
	ldr r6, _021E8110 ; =ov96_0221A894
	ldr r7, _021E8114 ; =_0221A7D8
	add r5, r0, #0
	mov r4, #0
_021E80DE:
	mov r0, #0x2c
	mul r0, r4
	ldrh r1, [r5, r0]
	ldr r0, _021E8118 ; =0x0000FFFF
	cmp r1, r0
	bne _021E80EE
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E80EE:
	lsl r0, r4, #1
	ldrh r0, [r6, r0]
	ldrb r2, [r7, r4]
	bl ov96_021E7D30
	cmp r0, #0
	bne _021E8100
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E8100:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #0xa
	blo _021E80DE
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E8110: .word ov96_0221A894
_021E8114: .word _0221A7D8
_021E8118: .word 0x0000FFFF
	thumb_func_end ov96_021E80C4

	thumb_func_start ov96_021E811C
ov96_021E811C: ; 0x021E811C
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r5, r2, #0
	mov r1, #0xa
	strb r1, [r5]
	ldrb r6, [r0, #0xc]
	ldr r0, [r0, #4]
	mov r7, #0
	cmp r0, #1
	bne _021E8160
	cmp r6, #0xa
	bhi _021E815A
	add r0, r6, r6
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E8140: ; jump table
	.short _021E815A - _021E8140 - 2 ; case 0
	.short _021E815A - _021E8140 - 2 ; case 1
	.short _021E815A - _021E8140 - 2 ; case 2
	.short _021E815A - _021E8140 - 2 ; case 3
	.short _021E815A - _021E8140 - 2 ; case 4
	.short _021E8156 - _021E8140 - 2 ; case 5
	.short _021E8156 - _021E8140 - 2 ; case 6
	.short _021E8156 - _021E8140 - 2 ; case 7
	.short _021E8156 - _021E8140 - 2 ; case 8
	.short _021E8156 - _021E8140 - 2 ; case 9
	.short _021E8156 - _021E8140 - 2 ; case 10
_021E8156:
	mov r7, #1
	b _021E8182
_021E815A:
	bl GF_AssertFail
	b _021E8182
_021E8160:
	cmp r6, #4
	bhi _021E817E
	add r0, r6, r6
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E8170: ; jump table
	.short _021E817A - _021E8170 - 2 ; case 0
	.short _021E817A - _021E8170 - 2 ; case 1
	.short _021E817A - _021E8170 - 2 ; case 2
	.short _021E817A - _021E8170 - 2 ; case 3
	.short _021E817A - _021E8170 - 2 ; case 4
_021E817A:
	mov r7, #1
	b _021E8182
_021E817E:
	bl GF_AssertFail
_021E8182:
	cmp r7, #0
	beq _021E81CE
	cmp r6, #0xa
	bne _021E81B4
	bl LCRandom
	mov r1, #0xa
	bl _s32_div_f
	lsl r0, r1, #0x18
	lsr r0, r0, #0x18
	mov r2, #0
	cmp r4, #0
	bls _021E81CE
	ldr r1, _021E81D0 ; =ov96_0221A95C
	lsl r0, r0, #2
	add r1, r1, r0
_021E81A4:
	ldrb r0, [r1, r2]
	strb r0, [r5, r2]
	add r0, r2, #1
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	cmp r2, r4
	blo _021E81A4
	pop {r3, r4, r5, r6, r7, pc}
_021E81B4:
	mov r2, #0
	cmp r4, #0
	bls _021E81CE
	ldr r1, _021E81D4 ; =ov96_0221A934
	lsl r0, r6, #2
	add r1, r1, r0
_021E81C0:
	ldrb r0, [r1, r2]
	strb r0, [r5, r2]
	add r0, r2, #1
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	cmp r2, r4
	blo _021E81C0
_021E81CE:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E81D0: .word ov96_0221A95C
_021E81D4: .word ov96_0221A934
	thumb_func_end ov96_021E811C

	thumb_func_start ov96_021E81D8
ov96_021E81D8: ; 0x021E81D8
	push {r3, r4, lr}
	sub sp, #0x14
	add r4, r1, #0
	ldr r0, [r4, #4]
	add r1, sp, #4
	add r2, sp, #0
	bl ov96_021EAEC8
	ldr r0, [r4, #8]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0
	str r0, [sp, #0x10]
	ldr r0, [sp, #4]
	add r1, sp, #8
	lsl r0, r0, #0xc
	str r0, [sp, #8]
	ldr r0, [sp]
	lsl r0, r0, #0xc
	str r0, [sp, #0xc]
	ldr r0, [r4, #8]
	bl Sprite_SetMatrix
	ldr r0, [r4, #4]
	bl ov96_021EB120
	cmp r0, #0
	ldr r0, [r4, #8]
	beq _021E821E
	mov r1, #1
	bl Sprite_SetDrawFlag
	add sp, #0x14
	pop {r3, r4, pc}
_021E821E:
	mov r1, #0
	bl Sprite_SetDrawFlag
	add sp, #0x14
	pop {r3, r4, pc}
	thumb_func_end ov96_021E81D8

	thumb_func_start ov96_021E8228
ov96_021E8228: ; 0x021E8228
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r4, r1, #0
	add r7, r2, #0
	str r3, [sp]
	ldr r6, [sp, #0x18]
	add r1, r3, #0
	bne _021E825E
	bl ov96_021E5F24
	cmp r4, r0
	beq _021E8244
	bl GF_AssertFail
_021E8244:
	cmp r6, #1
	beq _021E824C
	bl GF_AssertFail
_021E824C:
	mov r0, #0x8b
	lsl r0, r0, #4
	ldr r2, [r5, r0]
	ldr r1, _021E830C ; =0x0000270F
	cmp r2, r1
	bhs _021E830A
	add r1, r2, #1
	str r1, [r5, r0]
	pop {r3, r4, r5, r6, r7, pc}
_021E825E:
	cmp r7, #3
	blo _021E8266
	bl GF_AssertFail
_021E8266:
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r0, [r0, #0x10]
	cmp r0, #0
	bne _021E829A
	add r0, r5, #0
	bl ov96_021E5F24
	cmp r0, #0
	beq _021E8280
	bl GF_AssertFail
_021E8280:
	ldr r2, _021E8310 ; =0x0000072C
	lsl r1, r6, #0x18
	add r3, r5, r2
	mov r2, #0x60
	mul r2, r4
	add r3, r3, r2
	lsl r2, r7, #5
	ldr r0, [sp]
	lsr r1, r1, #0x18
	add r2, r3, r2
	bl ov96_021E8340
	pop {r3, r4, r5, r6, r7, pc}
_021E829A:
	add r0, r5, #0
	bl ov96_021E5F24
	cmp r0, #0
	bne _021E82EA
	add r0, r5, #0
	bl PokeathlonCourse_GetParticipantCount
	cmp r4, r0
	blo _021E82C8
	ldr r2, _021E8310 ; =0x0000072C
	lsl r1, r6, #0x18
	add r3, r5, r2
	mov r2, #0x60
	mul r2, r4
	add r3, r3, r2
	lsl r2, r7, #5
	ldr r0, [sp]
	lsr r1, r1, #0x18
	add r2, r3, r2
	bl ov96_021E8340
	pop {r3, r4, r5, r6, r7, pc}
_021E82C8:
	add r0, r5, #0
	bl ov96_021E5F24
	cmp r4, r0
	beq _021E82D6
	bl GF_AssertFail
_021E82D6:
	ldr r2, _021E8314 ; =0x00000B44
	lsl r1, r6, #0x18
	add r3, r5, r2
	lsl r2, r7, #5
	ldr r0, [sp]
	lsr r1, r1, #0x18
	add r2, r3, r2
	bl ov96_021E8340
	pop {r3, r4, r5, r6, r7, pc}
_021E82EA:
	add r0, r5, #0
	bl ov96_021E5F24
	cmp r4, r0
	beq _021E82F8
	bl GF_AssertFail
_021E82F8:
	ldr r2, _021E8314 ; =0x00000B44
	lsl r1, r6, #0x18
	add r3, r5, r2
	lsl r2, r7, #5
	ldr r0, [sp]
	lsr r1, r1, #0x18
	add r2, r3, r2
	bl ov96_021E8340
_021E830A:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E830C: .word 0x0000270F
_021E8310: .word 0x0000072C
_021E8314: .word 0x00000B44
	thumb_func_end ov96_021E8228

	thumb_func_start ov96_021E8318
ov96_021E8318: ; 0x021E8318
	ldr r2, _021E8320 ; =0x00000D2A
	strh r1, [r0, r2]
	bx lr
	nop
_021E8320: .word 0x00000D2A
	thumb_func_end ov96_021E8318

	thumb_func_start ov96_021E8324
ov96_021E8324: ; 0x021E8324
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _021E833C ; =0x00000D6C
	add r4, r1, #0
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _021E8336
	bl GF_AssertFail
_021E8336:
	ldr r0, _021E833C ; =0x00000D6C
	str r4, [r5, r0]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E833C: .word 0x00000D6C
	thumb_func_end ov96_021E8324

	thumb_func_start ov96_021E8340
ov96_021E8340: ; 0x021E8340
	push {r3, lr}
	cmp r0, #8
	bhi _021E8382
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E8352: ; jump table
	.short _021E8382 - _021E8352 - 2 ; case 0
	.short _021E8364 - _021E8352 - 2 ; case 1
	.short _021E8366 - _021E8352 - 2 ; case 2
	.short _021E836A - _021E8352 - 2 ; case 3
	.short _021E836E - _021E8352 - 2 ; case 4
	.short _021E8372 - _021E8352 - 2 ; case 5
	.short _021E8376 - _021E8352 - 2 ; case 6
	.short _021E837A - _021E8352 - 2 ; case 7
	.short _021E837E - _021E8352 - 2 ; case 8
_021E8364:
	b _021E8388
_021E8366:
	add r2, r2, #4
	b _021E8388
_021E836A:
	add r2, #8
	b _021E8388
_021E836E:
	add r2, #0xc
	b _021E8388
_021E8372:
	add r2, #0x10
	b _021E8388
_021E8376:
	add r2, #0x14
	b _021E8388
_021E837A:
	add r2, #0x18
	b _021E8388
_021E837E:
	add r2, #0x1c
	b _021E8388
_021E8382:
	bl GF_AssertFail
	pop {r3, pc}
_021E8388:
	ldr r0, [r2]
	add r1, r0, r1
	ldr r0, _021E8398 ; =0x0000270F
	str r1, [r2]
	cmp r1, r0
	bls _021E8396
	str r0, [r2]
_021E8396:
	pop {r3, pc}
	.balign 4, 0
_021E8398: .word 0x0000270F
	thumb_func_end ov96_021E8340

	thumb_func_start ov96_021E839C
ov96_021E839C: ; 0x021E839C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0]
	bl Save_Pokeathlon_Get
	add r6, r0, #0
	ldr r0, _021E8418 ; =0x00000D2A
	ldrh r1, [r5, r0]
	ldr r0, _021E841C ; =0x0000FFFF
	cmp r1, r0
	bne _021E83C0
	bl GF_AssertFail
	mov r0, #0
	pop {r4, r5, r6, pc}
_021E83C0:
	add r0, r5, #0
	bl PokeathlonCourse_GetField3D8_ForCurrentParticipant
	add r4, r0, #0
	mov r0, #0x7e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0, #4]
	cmp r0, #1
	bne _021E83DE
	add r0, r6, #0
	bl PokeathlonSave_GetRecordsLink2
	mov r1, #0xa4
	b _021E83E6
_021E83DE:
	add r0, r6, #0
	bl PokeathlonSave_GetRecordsSolo2
	mov r1, #0x2c
_021E83E6:
	mul r1, r4
	add r0, r0, r1
	ldrh r0, [r0]
	ldr r1, _021E841C ; =0x0000FFFF
	cmp r0, r1
	bne _021E83F6
	mov r0, #1
	pop {r4, r5, r6, pc}
_021E83F6:
	ldr r1, _021E8420 ; =_0221A7D8
	ldrb r1, [r1, r4]
	cmp r1, #0
	ldr r1, _021E8418 ; =0x00000D2A
	bne _021E840A
	ldrh r1, [r5, r1]
	cmp r0, r1
	bhs _021E8414
	mov r0, #1
	pop {r4, r5, r6, pc}
_021E840A:
	ldrh r1, [r5, r1]
	cmp r0, r1
	bls _021E8414
	mov r0, #1
	pop {r4, r5, r6, pc}
_021E8414:
	mov r0, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021E8418: .word 0x00000D2A
_021E841C: .word 0x0000FFFF
_021E8420: .word _0221A7D8
	thumb_func_end ov96_021E839C

	thumb_func_start ov96_021E8424
ov96_021E8424: ; 0x021E8424
	push {r3, lr}
	cmp r0, #0
	beq _021E843A
	cmp r0, #0x64
	bhi _021E843A
	sub r0, r0, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x17
	ldr r0, _021E8444 ; =ov96_0221AA20
	ldrh r0, [r0, r1]
	pop {r3, pc}
_021E843A:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	nop
_021E8444: .word ov96_0221AA20
	thumb_func_end ov96_021E8424

	thumb_func_start ov96_021E8448
ov96_021E8448: ; 0x021E8448
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r1, #0
	beq _021E847A
	cmp r5, #0x64
	bhi _021E847A
	bl PokeathlonCourse_GetHeapID
	add r1, r0, #0
	mov r0, #0x41
	lsl r0, r0, #2
	bl NARC_New
	add r4, r0, #0
	sub r1, r5, #1
	add r2, sp, #0
	bl NARC_ReadWholeMember
	add r0, r4, #0
	bl NARC_Delete
	add r0, sp, #0
	add sp, #8
	ldrb r0, [r0, #7]
	pop {r3, r4, r5, pc}
_021E847A:
	bl GF_AssertFail
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, pc}
	thumb_func_end ov96_021E8448

	thumb_func_start ov96_021E8484
ov96_021E8484: ; 0x021E8484
	push {r4, r5, r6, r7, lr}
	sub sp, #0x44
	str r0, [sp]
	add r4, r1, #0
	bl PokeathlonCourse_GetHeapID
	add r3, r0, #0
	ldr r2, _021E8608 ; =0x00000136
	mov r0, #1
	mov r1, #0x1b
	bl NewMsgDataFromNarc
	str r0, [sp, #0x14]
	mov r0, #4
	sub r0, r0, r4
	str r0, [sp, #4]
	mov r1, #0x7e
	ldr r0, [sp]
	lsl r1, r1, #2
	ldr r2, [r0, r1]
	add r0, r4, #0
	ldrb r1, [r2, #0xc]
	ldrb r2, [r2, #0xf]
	add r3, sp, #0x2c
	bl ov96_021E860C
	ldr r0, [sp]
	bl PokeathlonCourse_GetHeapID
	add r1, r0, #0
	mov r0, #0xa9
	bl NARC_New
	str r0, [sp, #0x10]
	ldr r0, [sp]
	bl PokeathlonCourse_GetHeapID
	add r1, r0, #0
	mov r0, #0x41
	lsl r0, r0, #2
	bl NARC_New
	str r0, [sp, #0xc]
	mov r0, #0
	str r0, [sp, #0x1c]
	ldr r0, [sp, #4]
	cmp r0, #4
	bge _021E84E6
	blt _021E84E8
_021E84E6:
	b _021E85F0
_021E84E8:
	add r0, sp, #0x2c
	str r0, [sp, #8]
_021E84EC:
	ldr r0, [sp]
	ldr r1, [sp, #4]
	bl PokeathlonCourse_GetParticipantData
	add r5, r0, #0
	ldr r0, [sp, #8]
	ldrb r0, [r0]
	str r0, [r5]
	cmp r0, #0
	bne _021E8504
	bl GF_AssertFail
_021E8504:
	ldr r1, [r5]
	ldr r0, [sp, #0xc]
	sub r1, r1, #1
	add r2, sp, #0x24
	bl NARC_ReadWholeMember
	add r1, sp, #0x24
	ldrb r1, [r1, #6]
	ldr r0, [sp, #0x14]
	bl NewString_ReadMsgData
	add r4, r0, #0
	ldr r0, [sp]
	ldr r1, [sp, #4]
	bl PokeathlonCourse_GetPlayerProfileFromData
	add r6, r0, #0
	add r0, r4, #0
	bl String_cstr
	add r1, r0, #0
	add r0, r6, #0
	bl Save_Profile_PlayerName_Set
	add r0, r4, #0
	bl String_Delete
	mov r0, #0
	add r6, r5, #0
	str r0, [sp, #0x18]
	add r4, sp, #0x24
	add r6, #0x16
	add r7, sp, #0x24
_021E8546:
	ldrh r0, [r4]
	mov r1, #0x12
	strh r0, [r5, #4]
	mov r0, #0
	strh r0, [r5, #6]
	strb r0, [r5, #0x14]
	str r0, [r5, #8]
	ldrh r0, [r5, #4]
	bl GetMonBaseStat
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	beq _021E856A
	cmp r0, #0xfe
	beq _021E856E
	cmp r0, #0xff
	beq _021E8572
	b _021E8576
_021E856A:
	mov r0, #0
	b _021E8578
_021E856E:
	mov r0, #1
	b _021E8578
_021E8572:
	mov r0, #2
	b _021E8578
_021E8576:
	mov r0, #0
_021E8578:
	strb r0, [r5, #0x15]
	ldrh r0, [r5, #4]
	mov r1, #0
	bl ov96_021E679C
	add r1, r0, #0
	add r2, sp, #0x2c
	ldr r0, [sp, #0x10]
	add r2, #3
	bl NARC_ReadWholeMember
	ldrb r0, [r7, #0xb]
	strb r0, [r5, #0xc]
	ldrb r0, [r7, #0xc]
	strb r0, [r5, #0xd]
	ldrb r0, [r7, #0xd]
	strb r0, [r5, #0xe]
	ldrb r0, [r7, #0xe]
	strb r0, [r5, #0xf]
	ldrb r0, [r7, #0xf]
	strb r0, [r5, #0x10]
	ldr r0, [sp]
	bl PokeathlonCourse_GetHeapID
	add r1, r0, #0
	ldrh r0, [r4]
	bl GetSpeciesName
	str r0, [sp, #0x20]
	bl String_cstr
	add r1, r0, #0
	add r0, r6, #0
	mov r2, #0xb
	bl CopyU16StringArrayN
	ldr r0, [sp, #0x20]
	bl String_Delete
	ldr r0, [sp, #0x18]
	add r4, r4, #2
	add r0, r0, #1
	add r5, #0x28
	add r6, #0x28
	str r0, [sp, #0x18]
	cmp r0, #3
	blt _021E8546
	ldr r0, [sp, #4]
	add r0, r0, #1
	str r0, [sp, #4]
	ldr r0, [sp, #8]
	add r0, r0, #1
	str r0, [sp, #8]
	ldr r0, [sp, #0x1c]
	add r0, r0, #1
	str r0, [sp, #0x1c]
	ldr r0, [sp, #4]
	cmp r0, #4
	bge _021E85F0
	b _021E84EC
_021E85F0:
	ldr r0, [sp, #0xc]
	bl NARC_Delete
	ldr r0, [sp, #0x10]
	bl NARC_Delete
	ldr r0, [sp, #0x14]
	bl DestroyMsgData
	add sp, #0x44
	pop {r4, r5, r6, r7, pc}
	nop
_021E8608: .word 0x00000136
	thumb_func_end ov96_021E8484

	thumb_func_start ov96_021E860C
ov96_021E860C: ; 0x021E860C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #0
	str r2, [sp]
	add r4, r3, #0
	add r2, r1, #0
_021E861C:
	strb r2, [r4, r1]
	add r1, r1, #1
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	cmp r1, #3
	blo _021E861C
	cmp r0, #0xa
	bne _021E8678
	add r1, sp, #0xc
	mov r7, #0x19
	add r1, #1
_021E8632:
	add r0, r2, #1
	lsl r0, r0, #0x18
	strb r2, [r1, r2]
	lsr r2, r0, #0x18
	cmp r2, #0x19
	blo _021E8632
	mov r6, #0
	cmp r5, #0
	bls _021E86C4
_021E8644:
	bl LCRandom
	add r1, r7, #0
	bl _s32_div_f
	lsl r0, r1, #0x18
	add r1, sp, #0xc
	lsr r0, r0, #0x18
	add r1, #1
	ldrb r1, [r1, r0]
	strb r1, [r4, r6]
	add r1, #0x19
	strb r1, [r4, r6]
	sub r1, r7, #1
	lsl r1, r1, #0x18
	lsr r7, r1, #0x18
	add r1, sp, #0xc
	add r1, #1
	ldrb r2, [r1, r7]
	strb r2, [r1, r0]
	add r0, r6, #1
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	cmp r6, r5
	blo _021E8644
	b _021E86C4
_021E8678:
	mov r7, #5
	add r1, sp, #8
_021E867C:
	strb r2, [r1, r2]
	add r2, r2, #1
	lsl r2, r2, #0x18
	lsr r2, r2, #0x18
	cmp r2, #5
	blo _021E867C
	mov r6, #0
	cmp r5, #0
	bls _021E86C4
	lsl r1, r0, #2
	add r0, r0, r1
	str r0, [sp, #4]
_021E8694:
	bl LCRandom
	add r1, r7, #0
	bl _s32_div_f
	lsl r0, r1, #0x18
	lsr r0, r0, #0x18
	add r1, sp, #8
	ldrb r2, [r1, r0]
	ldr r1, [sp, #4]
	strb r2, [r4, r6]
	add r1, r2, r1
	strb r1, [r4, r6]
	sub r1, r7, #1
	lsl r1, r1, #0x18
	lsr r7, r1, #0x18
	add r1, sp, #8
	ldrb r2, [r1, r7]
	strb r2, [r1, r0]
	add r0, r6, #1
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	cmp r6, r5
	blo _021E8694
_021E86C4:
	ldr r0, [sp]
	cmp r0, #0
	beq _021E86E0
	mov r1, #0
	cmp r5, #0
	bls _021E86E0
_021E86D0:
	ldrb r0, [r4, r1]
	add r0, #0x32
	strb r0, [r4, r1]
	add r0, r1, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	cmp r1, r5
	blo _021E86D0
_021E86E0:
	mov r1, #0
	cmp r5, #0
	bls _021E86F6
_021E86E6:
	ldrb r0, [r4, r1]
	add r0, r0, #1
	strb r0, [r4, r1]
	add r0, r1, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	cmp r1, r5
	blo _021E86E6
_021E86F6:
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E860C

	thumb_func_start ov96_021E86FC
ov96_021E86FC: ; 0x021E86FC
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #4
	blo _021E870A
	bl GF_AssertFail
_021E870A:
	ldr r0, _021E8728 ; =0x00000D68
	ldr r0, [r5, r0]
	cmp r0, #0
	bne _021E8716
	bl GF_AssertFail
_021E8716:
	bl sub_02031B10
	ldr r1, _021E8728 ; =0x00000D68
	ldr r2, [r5, r1]
	add r1, r0, #0
	mul r1, r4
	add r0, r2, r1
	pop {r3, r4, r5, pc}
	nop
_021E8728: .word 0x00000D68
	thumb_func_end ov96_021E86FC

	thumb_func_start ov96_021E872C
ov96_021E872C: ; 0x021E872C
	push {lr}
	sub sp, #0x24
	lsl r0, r0, #0xc
	str r0, [sp, #0x18]
	lsl r0, r1, #0xc
	mov r1, #0
	str r0, [sp, #0x1c]
	lsl r0, r2, #0xc
	str r0, [sp, #0xc]
	lsl r0, r3, #0xc
	str r0, [sp, #0x10]
	str r1, [sp, #0x20]
	str r1, [sp, #0x14]
	add r0, sp, #0x18
	add r1, sp, #0xc
	add r2, sp, #0
	bl VEC_Subtract
	add r0, sp, #0
	bl VEC_Mag
	ldr r1, [sp, #0x2c]
	str r0, [r1]
	ldr r1, [sp, #0x28]
	lsl r1, r1, #0xc
	cmp r0, r1
	bge _021E8768
	add sp, #0x24
	mov r0, #1
	pop {pc}
_021E8768:
	mov r0, #0
	add sp, #0x24
	pop {pc}
	.balign 4, 0
	thumb_func_end ov96_021E872C

	thumb_func_start ov96_021E8770
ov96_021E8770: ; 0x021E8770
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r7, r1, #0
	ldr r0, [sp, #0x18]
	mov r1, #8
	str r2, [sp]
	add r5, r3, #0
	bl Heap_Alloc
	add r4, r0, #0
	mov r0, #0
	strh r5, [r4]
	strh r0, [r4, #2]
	str r0, [r4, #4]
	cmp r5, #1
	bne _021E879C
	ldr r2, [sp]
	add r0, r6, #0
	add r1, r7, #0
	bl sub_0203410C
	b _021E87AA
_021E879C:
	ldr r2, [sp]
	ldr r3, [sp, #0x18]
	add r0, r6, #0
	add r1, r7, #0
	bl ov96_021E883C
	str r0, [r4, #4]
_021E87AA:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8770

	thumb_func_start ov96_021E87B0
ov96_021E87B0: ; 0x021E87B0
	strh r1, [r0, #2]
	bx lr
	thumb_func_end ov96_021E87B0

	thumb_func_start ov96_021E87B4
ov96_021E87B4: ; 0x021E87B4
	push {r3, r4, r5, r6, r7, lr}
	add r4, r3, #0
	add r6, r0, #0
	ldrh r0, [r4, #2]
	add r7, r1, #0
	add r5, r2, #0
	cmp r0, #0
	beq _021E87CC
	cmp r5, #0x26
	ble _021E87CC
	bl GF_AssertFail
_021E87CC:
	ldrh r0, [r4]
	cmp r0, #1
	bne _021E87DE
	add r0, r6, #0
	add r1, r7, #0
	add r2, r5, #0
	bl sub_02037030
	pop {r3, r4, r5, r6, r7, pc}
_021E87DE:
	ldr r0, [r4, #4]
	add r1, r6, #0
	add r2, r7, #0
	add r3, r5, #0
	bl ov96_021E8914
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E87B4

	thumb_func_start ov96_021E87EC
ov96_021E87EC: ; 0x021E87EC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r3, #0
	ldrh r3, [r6]
	add r5, r0, #0
	add r4, r1, #0
	add r7, r2, #0
	cmp r3, #1
	bne _021E8802
	bl sub_02036FD8
	pop {r3, r4, r5, r6, r7, pc}
_021E8802:
	ldr r0, [r6, #4]
	add r1, r5, #0
	add r2, r4, #0
	add r3, r7, #0
	bl ov96_021E8988
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E87EC

	thumb_func_start ov96_021E8810
ov96_021E8810: ; 0x021E8810
	push {r4, lr}
	add r4, r0, #0
	ldrh r0, [r4]
	cmp r0, #0
	bne _021E8820
	ldr r0, [r4, #4]
	bl ov96_021E88FC
_021E8820:
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov96_021E8810

	thumb_func_start ov96_021E8828
ov96_021E8828: ; 0x021E8828
	push {r3, lr}
	ldrh r0, [r0]
	cmp r0, #1
	bne _021E8836
	bl sub_0203769C
	pop {r3, pc}
_021E8836:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8828

	thumb_func_start ov96_021E883C
ov96_021E883C: ; 0x021E883C
	push {r3, r4, r5, r6, r7, lr}
	add r6, r1, #0
	mov r1, #0x1d
	add r5, r0, #0
	add r0, r3, #0
	lsl r1, r1, #4
	add r7, r2, #0
	bl Heap_Alloc
	mov r2, #0x1d
	mov r1, #0
	lsl r2, r2, #4
	add r4, r0, #0
	bl memset
	mov r1, #7
	lsl r1, r1, #6
	str r5, [r4, r1]
	add r0, r1, #4
	str r6, [r4, r0]
	add r1, #8
	str r7, [r4, r1]
	ldr r0, _021E887C ; =ov96_021E8884
	ldr r2, _021E8880 ; =0x00001388
	add r1, r4, #0
	bl SysTask_CreateOnVWaitQueue
	mov r1, #0x73
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E887C: .word ov96_021E8884
_021E8880: .word 0x00001388
	thumb_func_end ov96_021E883C

	thumb_func_start ov96_021E8884
ov96_021E8884: ; 0x021E8884
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r1, #0
	mov r0, #0
	str r0, [sp]
	add r6, r7, #0
_021E8890:
	ldr r0, [r6]
	cmp r0, #1
	bne _021E88EA
	ldr r1, [r6, #0x30]
	cmp r1, #0x26
	bgt _021E88BE
	mov r4, #7
	lsl r4, r4, #6
	ldr r4, [r7, r4]
	mov r3, #0x72
	str r4, [sp, #4]
	ldr r4, [r6, #4]
	mov r5, #0xc
	mul r5, r4
	ldr r4, [sp, #4]
	lsl r3, r3, #2
	add r2, r6, #0
	ldr r3, [r7, r3]
	ldr r4, [r4, r5]
	mov r0, #0
	add r2, #8
	blx r4
	b _021E88E0
_021E88BE:
	mov r4, #7
	lsl r4, r4, #6
	ldr r4, [r7, r4]
	mov r3, #0x72
	mov ip, r4
	ldr r4, [r6, #4]
	mov r5, #0xc
	mul r5, r4
	str r5, [sp, #8]
	lsl r3, r3, #2
	ldr r4, [sp, #8]
	mov r5, ip
	ldr r2, [r6, #0x34]
	ldr r3, [r7, r3]
	ldr r4, [r5, r4]
	mov r0, #0
	blx r4
_021E88E0:
	add r0, r6, #0
	mov r1, #0
	mov r2, #0x38
	bl memset
_021E88EA:
	ldr r0, [sp]
	add r6, #0x38
	add r0, r0, #1
	str r0, [sp]
	cmp r0, #8
	blt _021E8890
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8884

	thumb_func_start ov96_021E88FC
ov96_021E88FC: ; 0x021E88FC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x73
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl SysTask_Destroy
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov96_021E88FC

	thumb_func_start ov96_021E8914
ov96_021E8914: ; 0x021E8914
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r4, #0
	str r2, [sp]
	add r7, r1, #0
	add r5, r3, #0
	add r0, r4, #0
	add r2, r6, #0
_021E8924:
	ldr r1, [r2]
	cmp r1, #0
	bne _021E8932
	mov r1, #0x38
	mul r1, r0
	add r4, r6, r1
	b _021E893A
_021E8932:
	add r0, r0, #1
	add r2, #0x38
	cmp r0, #8
	blt _021E8924
_021E893A:
	cmp r4, #0
	bne _021E8942
	bl GF_AssertFail
_021E8942:
	mov r0, #7
	lsl r0, r0, #6
	add r1, r7, #0
	ldr r2, [r6, r0]
	sub r1, #0x16
	mov r0, #0xc
	mul r0, r1
	add r0, r2, r0
	ldr r0, [r0, #4]
	cmp r0, #0
	beq _021E8962
	blx r0
	cmp r0, r5
	beq _021E8962
	bl GF_AssertFail
_021E8962:
	cmp r5, #0x26
	ble _021E896A
	bl GF_AssertFail
_021E896A:
	sub r7, #0x16
	str r7, [r4, #4]
	cmp r5, #0
	ble _021E897E
	add r0, r4, #0
	ldr r1, [sp]
	add r0, #8
	add r2, r5, #0
	bl memcpy
_021E897E:
	str r5, [r4, #0x30]
	mov r0, #1
	str r0, [r4]
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8914

	thumb_func_start ov96_021E8988
ov96_021E8988: ; 0x021E8988
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	str r2, [sp, #4]
	mov r4, #0
	str r1, [sp]
	add r6, r3, #0
	add r1, r4, #0
	add r2, r5, #0
_021E899A:
	ldr r0, [r2]
	cmp r0, #0
	bne _021E89A8
	mov r0, #0x38
	mul r0, r1
	add r4, r5, r0
	b _021E89B0
_021E89A8:
	add r1, r1, #1
	add r2, #0x38
	cmp r1, #8
	blt _021E899A
_021E89B0:
	cmp r4, #0
	bne _021E89B8
	bl GF_AssertFail
_021E89B8:
	ldr r1, [sp]
	mov r0, #0xc
	sub r1, #0x16
	add r7, r1, #0
	mul r7, r0
	mov r0, #7
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	add r0, r0, r7
	ldr r0, [r0, #4]
	blx r0
	ldr r1, _021E8A1C ; =0x0000FFFF
	cmp r0, r1
	beq _021E89DC
	cmp r0, r6
	beq _021E89DC
	bl GF_AssertFail
_021E89DC:
	mov r1, #7
	lsl r1, r1, #6
	ldr r0, [r5, r1]
	add r0, r0, r7
	ldr r3, [r0, #8]
	cmp r3, #0
	beq _021E8A06
	add r1, #8
	ldr r1, [r5, r1]
	mov r0, #0
	add r2, r6, #0
	blx r3
	add r5, r0, #0
	cmp r6, #0
	ble _021E8A02
	ldr r1, [sp, #4]
	add r2, r6, #0
	bl memcpy
_021E8A02:
	str r5, [r4, #0x34]
	b _021E8A0A
_021E8A06:
	ldr r0, [sp, #4]
	str r0, [r4, #0x34]
_021E8A0A:
	ldr r0, [sp]
	sub r0, #0x16
	str r0, [r4, #4]
	str r0, [sp]
	str r6, [r4, #0x30]
	mov r0, #1
	str r0, [r4]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E8A1C: .word 0x0000FFFF
	thumb_func_end ov96_021E8988

	thumb_func_start ov96_021E8A20
ov96_021E8A20: ; 0x021E8A20
	bx lr
	.balign 4, 0
	thumb_func_end ov96_021E8A20

	thumb_func_start ov96_021E8A24
ov96_021E8A24: ; 0x021E8A24
	ldr r0, _021E8A28 ; =ov96_0221AEC4
	bx lr
	.balign 4, 0
_021E8A28: .word ov96_0221AEC4
	thumb_func_end ov96_021E8A24

	thumb_func_start ov96_021E8A2C
ov96_021E8A2C: ; 0x021E8A2C
	mov r0, #0xc
	bx lr
	thumb_func_end ov96_021E8A2C

	thumb_func_start ov96_021E8A30
ov96_021E8A30: ; 0x021E8A30
	push {r4, lr}
	ldr r1, _021E8A40 ; =0x00000958
	add r4, r0, #0
	bl Heap_Alloc
	str r4, [r0]
	pop {r4, pc}
	nop
_021E8A40: .word 0x00000958
	thumb_func_end ov96_021E8A30

	thumb_func_start ov96_021E8A44
ov96_021E8A44: ; 0x021E8A44
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r6, r0, #0
	add r5, r2, #0
	cmp r4, #0x10
	bls _021E8A54
	bl GF_AssertFail
_021E8A54:
	strh r4, [r6, #4]
	mov r0, #0
	strh r0, [r6, #6]
	str r0, [r6, #0xc]
	str r0, [r6, #8]
	mov r1, #0x2c
	ldr r0, [r6]
	mul r1, r4
	bl Heap_Alloc
	mov r1, #0x55
	lsl r1, r1, #2
	str r0, [r6, r1]
	cmp r5, #0
	bne _021E8A86
	ldrh r0, [r6, #4]
	add r1, r6, #0
	ldr r2, [r6]
	add r1, #0x1c
	bl G2dRenderer_Init
	str r0, [r6, #0x14]
	str r0, [r6, #0x18]
	mov r0, #1
	b _021E8A8A
_021E8A86:
	str r5, [r6, #0x18]
	mov r0, #0
_021E8A8A:
	mov r7, #0x51
	str r0, [r6, #0x10]
	mov r4, #0
	add r5, r6, #0
	lsl r7, r7, #2
_021E8A94:
	ldrh r0, [r6, #4]
	ldr r2, [r6]
	add r1, r4, #0
	bl Create2DGfxResObjMan
	str r0, [r5, r7]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _021E8A94
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8A44

	thumb_func_start ov96_021E8AAC
ov96_021E8AAC: ; 0x021E8AAC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldrh r0, [r5, #4]
	mov r4, #0
	cmp r0, #0
	ble _021E8AE4
	mov r7, #0x55
	lsl r7, r7, #2
_021E8ABC:
	mov r0, #0x2c
	add r6, r4, #0
	mul r6, r0
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	ldr r0, [r0, r6]
	bl SpriteTransfer_DeleteCharTransferTask
	ldr r0, [r5, r7]
	add r0, r0, r6
	ldr r0, [r0, #4]
	bl SpriteTransfer_DeletePlttTransferTask
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	ldrh r0, [r5, #4]
	cmp r4, r0
	blt _021E8ABC
_021E8AE4:
	mov r6, #0x51
	mov r4, #0
	lsl r6, r6, #2
_021E8AEA:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r6]
	bl Destroy2DGfxResObjMan
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _021E8AEA
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Heap_Free
	ldr r0, [r5, #0x10]
	cmp r0, #0
	beq _021E8B14
	ldr r0, [r5, #0x14]
	bl SpriteList_Delete
_021E8B14:
	add r0, r5, #0
	bl Heap_Free
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E8AAC

	thumb_func_start ov96_021E8B1C
ov96_021E8B1C: ; 0x021E8B1C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r7, r1, #0
	mov r1, #0x55
	ldr r0, [r5]
	lsl r1, r1, #2
	add r6, r2, #0
	add r4, r3, #0
	bl Heap_AllocAtEnd
	strh r7, [r0]
	add r2, r0, #0
	mov ip, r0
	str r5, [r0, #0xc]
	add r2, #0x10
	mov r3, #8
_021E8B3C:
	ldmia r4!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r3, r3, #1
	bne _021E8B3C
	ldr r0, [r4]
	mov r4, #0
	str r0, [r2]
	mov r0, ip
	str r4, [r0, #8]
	ldr r1, [sp, #0x1c]
	mov r0, ip
	str r1, [r0, #4]
	mov r0, ip
	strh r4, [r0, #2]
	str r4, [r5, #0xc]
	cmp r7, #0
	ble _021E8B78
	mov r5, ip
_021E8B60:
	add r2, r5, #0
	add r3, r6, #0
	add r2, #0x54
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	add r4, r4, #1
	stmia r2!, {r0, r1}
	add r6, #0x10
	add r5, #0x10
	cmp r4, r7
	blt _021E8B60
_021E8B78:
	ldr r0, _021E8B84 ; =ov96_021E8FB4
	ldr r2, [sp, #0x18]
	mov r1, ip
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E8B84: .word ov96_021E8FB4
	thumb_func_end ov96_021E8B1C

	thumb_func_start ov96_021E8B88
ov96_021E8B88: ; 0x021E8B88
	ldr r0, [r0, #0xc]
	bx lr
	thumb_func_end ov96_021E8B88

	thumb_func_start ov96_021E8B8C
ov96_021E8B8C: ; 0x021E8B8C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldrh r0, [r5, #4]
	add r4, r1, #0
	cmp r4, r0
	blt _021E8B9C
	bl GF_AssertFail
_021E8B9C:
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	mov r0, #0x2c
	mul r0, r4
	add r0, r1, r0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8B8C

	thumb_func_start ov96_021E8BAC
ov96_021E8BAC: ; 0x021E8BAC
	ldr r0, [r0, #0x10]
	bx lr
	thumb_func_end ov96_021E8BAC

	thumb_func_start ov96_021E8BB0
ov96_021E8BB0: ; 0x021E8BB0
	add r0, #0x14
	bx lr
	thumb_func_end ov96_021E8BB0

	thumb_func_start ov96_021E8BB4
ov96_021E8BB4: ; 0x021E8BB4
	push {r4, r5, r6, lr}
	add r4, r0, #0
	add r5, r1, #0
	add r6, r2, #0
	ldrh r0, [r4]
	ldrh r1, [r4, #2]
	ldrb r2, [r4, #7]
	bl ov96_021E91B8
	add r1, r0, #0
	mov r0, #0x51
	add r2, r5, #0
	bl AllocAndReadWholeNarcMemberByIdPair
	add r5, r0, #0
	bl NNS_G3dGetTex
	ldr r1, [r0, #0x38]
	add r0, r0, r1
	ldrb r1, [r4, #6]
	cmp r1, #0
	beq _021E8BE2
	add r0, #0x20
_021E8BE2:
	add r1, r6, #0
	mov r2, #0x20
	bl MI_CpuCopy8
	add r0, r5, #0
	bl Heap_Free
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8BB4

	thumb_func_start ov96_021E8BF4
ov96_021E8BF4: ; 0x021E8BF4
	push {r3, r4, r5, r6, r7, lr}
	mov r4, #0
	add r6, r0, #0
	add r7, r3, #0
	str r4, [sp]
	cmp r2, #3
	bne _021E8C08
	mov r4, #1
	str r4, [sp]
	b _021E8C14
_021E8C08:
	cmp r2, #1
	bne _021E8C12
	mov r0, #1
	str r0, [sp]
	b _021E8C14
_021E8C12:
	mov r4, #1
_021E8C14:
	mov r0, #0x2c
	add r5, r1, #0
	mul r5, r0
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	ldr r0, [r0, r5]
	bl SpriteTransfer_GetCharProxy
	add r1, r0, #0
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	add r0, r0, r5
	ldr r0, [r0, #4]
	bl SpriteTransfer_GetPaletteProxy
	add r5, r0, #0
	add r0, r7, #0
	mov r1, #0x20
	bl DC_FlushRange
	ldr r0, [sp]
	cmp r0, #0
	beq _021E8C58
	add r0, r5, #0
	mov r1, #1
	bl NNS_G2dGetImagePaletteLocation
	add r1, r0, #0
	add r0, r7, #0
	mov r2, #0x20
	bl GX_LoadOBJPltt
_021E8C58:
	cmp r4, #0
	beq _021E8C6E
	add r0, r5, #0
	mov r1, #2
	bl NNS_G2dGetImagePaletteLocation
	add r1, r0, #0
	add r0, r7, #0
	mov r2, #0x20
	bl GXS_LoadOBJPltt
_021E8C6E:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E8BF4

	thumb_func_start ov96_021E8C70
ov96_021E8C70: ; 0x021E8C70
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x48
	add r5, r0, #0
	ldr r0, [sp, #0x64]
	add r4, r1, #0
	add r6, r3, #0
	str r2, [sp, #0x10]
	str r0, [sp, #0x64]
	cmp r0, #0
	beq _021E8CA4
	add r0, r2, #0
	ldrh r0, [r0, #4]
	cmp r0, #0
	beq _021E8C98
	mov r0, #0xa
	str r0, [sp, #0x44]
	mov r0, #9
	mov r2, #0xb
	str r0, [sp, #0x40]
	b _021E8CC2
_021E8C98:
	mov r0, #7
	str r0, [sp, #0x44]
	mov r0, #6
	mov r2, #8
	str r0, [sp, #0x40]
	b _021E8CC2
_021E8CA4:
	add r0, r2, #0
	ldrh r0, [r0, #4]
	cmp r0, #0
	beq _021E8CB8
	mov r0, #4
	str r0, [sp, #0x44]
	mov r0, #3
	mov r2, #5
	str r0, [sp, #0x40]
	b _021E8CC2
_021E8CB8:
	mov r0, #1
	str r0, [sp, #0x44]
	mov r0, #0
	mov r2, #2
	str r0, [sp, #0x40]
_021E8CC2:
	add r0, sp, #0x50
	ldrb r7, [r0, #0x10]
	mov r1, #0x95
	mov r3, #0
	str r7, [sp]
	str r6, [sp, #4]
	ldr r0, [r5]
	str r0, [sp, #8]
	mov r0, #0x51
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl AddCharResObjFromNarc
	str r0, [r4]
	str r7, [sp]
	str r6, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5]
	mov r1, #0x31
	str r0, [sp, #0xc]
	mov r0, #0x52
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r2, #0x1e
	mov r3, #0
	bl AddPlttResObjFromNarc
	str r0, [r4, #4]
	str r7, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, [r5]
	ldr r2, [sp, #0x44]
	str r0, [sp, #8]
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #0x95
	mov r3, #0
	bl AddCellOrAnimResObjFromNarc
	str r0, [r4, #8]
	str r7, [sp]
	mov r0, #3
	str r0, [sp, #4]
	ldr r0, [r5]
	ldr r2, [sp, #0x40]
	str r0, [sp, #8]
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0x95
	mov r3, #0
	bl AddCellOrAnimResObjFromNarc
	str r0, [r4, #0xc]
	ldr r0, [r4]
	bl SpriteTransfer_CreateCharTransferTask_AllocAtEnd
	ldr r0, [r4, #4]
	bl SpriteTransfer_CreateExtPlttTransferTask
	mov r0, #0
	str r0, [sp, #0x1c]
	str r0, [sp, #0x18]
	ldr r0, [r4]
	bl SpriteTransfer_GetCharProxy
	str r0, [sp, #0x24]
	ldr r0, [r4, #4]
	ldr r1, [sp, #0x24]
	bl SpriteTransfer_GetPaletteProxy
	str r0, [sp, #0x28]
	ldr r0, [r4]
	bl GF2DGfxResObj_GetCharDataPtr
	str r0, [sp, #0x20]
	cmp r6, #3
	bne _021E8D6C
	mov r0, #1
	str r0, [sp, #0x1c]
	str r0, [sp, #0x18]
	b _021E8D7A
_021E8D6C:
	cmp r6, #1
	bne _021E8D76
	mov r0, #1
	str r0, [sp, #0x1c]
	b _021E8D7A
_021E8D76:
	mov r0, #1
	str r0, [sp, #0x18]
_021E8D7A:
	ldr r0, [sp, #0x10]
	ldr r1, [sp, #0x10]
	ldr r2, [sp, #0x10]
	ldrh r0, [r0]
	ldrh r1, [r1, #2]
	ldrb r2, [r2, #7]
	bl ov96_021E91B8
	add r1, r0, #0
	ldr r2, [r5]
	mov r0, #0x51
	bl AllocAndReadWholeNarcMemberByIdPair
	str r0, [sp, #0x34]
	ldr r0, [sp, #0x10]
	ldrh r0, [r0, #4]
	cmp r0, #0
	beq _021E8DAA
	mov r0, #2
	lsl r0, r0, #0xa
	str r0, [sp, #0x14]
	mov r0, #8
	str r0, [sp, #0x3c]
	b _021E8DB4
_021E8DAA:
	mov r0, #2
	lsl r0, r0, #8
	str r0, [sp, #0x14]
	mov r0, #4
	str r0, [sp, #0x3c]
_021E8DB4:
	ldr r0, [sp, #0x34]
	bl NNS_G3dGetTex
	ldr r1, [r0, #0x14]
	str r0, [sp, #0x2c]
	add r0, r0, r1
	str r0, [sp, #0x30]
	ldr r0, [sp, #0x3c]
	mov r4, #0
	lsl r1, r0, #5
	mov r0, #2
	lsl r0, r0, #0xa
	str r4, [sp, #0x38]
	sub r7, r0, r1
	add r6, r5, r1
_021E8DD2:
	ldr r0, [sp, #0x3c]
	mov r2, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x56
	lsl r0, r0, #2
	add r0, r5, r0
	str r0, [sp, #8]
	ldr r0, [sp, #0x30]
	ldr r1, [sp, #0x3c]
	add r0, r0, r4
	add r3, r2, #0
	bl sub_020145B4
	ldr r0, [sp, #0x64]
	cmp r0, #0
	bne _021E8E72
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _021E8E2A
	ldr r0, [sp, #0x10]
	ldrh r0, [r0, #4]
	cmp r0, #0
	beq _021E8E2A
	mov r0, #0
_021E8E04:
	cmp r0, r7
	bge _021E8E16
	mov r1, #0x56
	add r2, r6, r0
	lsl r1, r1, #2
	ldrb r3, [r2, r1]
	add r2, r5, r0
	strb r3, [r2, r1]
	b _021E8E20
_021E8E16:
	mov r2, #0x56
	add r3, r5, r0
	lsl r2, r2, #2
	mov r1, #0
	strb r1, [r3, r2]
_021E8E20:
	mov r1, #2
	add r0, r0, #1
	lsl r1, r1, #0xa
	cmp r0, r1
	blt _021E8E04
_021E8E2A:
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r1, [sp, #0x14]
	add r0, r5, r0
	bl DC_FlushRange
	ldr r0, [sp, #0x1c]
	cmp r0, #0
	beq _021E8E54
	ldr r0, [sp, #0x24]
	mov r1, #1
	bl NNS_G2dGetImageLocation
	add r1, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r2, [sp, #0x14]
	add r0, r5, r0
	add r1, r1, r4
	bl GX_LoadOBJ
_021E8E54:
	ldr r0, [sp, #0x18]
	cmp r0, #0
	beq _021E8E72
	ldr r0, [sp, #0x24]
	mov r1, #2
	bl NNS_G2dGetImageLocation
	add r1, r0, #0
	mov r0, #0x56
	lsl r0, r0, #2
	ldr r2, [sp, #0x14]
	add r0, r5, r0
	add r1, r1, r4
	bl GXS_LoadOBJ
_021E8E72:
	ldr r1, [sp, #0x20]
	mov r0, #0x56
	ldr r1, [r1, #0x14]
	lsl r0, r0, #2
	ldr r2, [sp, #0x14]
	add r0, r5, r0
	add r1, r1, r4
	bl MIi_CpuCopyFast
	ldr r0, [sp, #0x14]
	add r4, r4, r0
	ldr r0, [sp, #0x38]
	add r0, r0, #1
	str r0, [sp, #0x38]
	cmp r0, #8
	blt _021E8DD2
	ldr r0, [sp, #0x2c]
	ldr r1, [r0, #0x38]
	add r4, r0, r1
	ldr r0, [sp, #0x10]
	ldrb r0, [r0, #6]
	cmp r0, #0
	beq _021E8EA2
	add r4, #0x20
_021E8EA2:
	add r0, r4, #0
	mov r1, #0x20
	bl DC_FlushRange
	ldr r0, [sp, #0x1c]
	cmp r0, #0
	beq _021E8EC2
	ldr r0, [sp, #0x28]
	mov r1, #1
	bl NNS_G2dGetImagePaletteLocation
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0x20
	bl GX_LoadOBJPltt
_021E8EC2:
	ldr r0, [sp, #0x18]
	cmp r0, #0
	beq _021E8EDA
	ldr r0, [sp, #0x28]
	mov r1, #2
	bl NNS_G2dGetImagePaletteLocation
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0x20
	bl GXS_LoadOBJPltt
_021E8EDA:
	ldr r0, [sp, #0x34]
	bl Heap_Free
	add sp, #0x48
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E8C70

	thumb_func_start ov96_021E8EE4
ov96_021E8EE4: ; 0x021E8EE4
	push {r3, r4, r5, lr}
	sub sp, #0x80
	add r4, r0, #0
	add r0, sp, #0x80
	add r5, r3, #0
	ldrb r3, [r0, #0x10]
	mov r0, #0
	mvn r0, r0
	str r3, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	str r2, [sp, #0xc]
	str r1, [sp, #0x10]
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r0, [r4, r1]
	add r2, r3, #0
	str r0, [sp, #0x14]
	add r0, r1, #4
	ldr r0, [r4, r0]
	str r0, [sp, #0x18]
	add r0, r1, #0
	add r0, #8
	ldr r0, [r4, r0]
	add r1, #0xc
	str r0, [sp, #0x1c]
	ldr r0, [r4, r1]
	add r1, r3, #0
	str r0, [sp, #0x20]
	mov r0, #0
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
	add r0, sp, #0x5c
	bl CreateSpriteResourcesHeader
	cmp r5, #3
	bne _021E8F30
	mov r5, #1
_021E8F30:
	ldr r0, [r4, #0x18]
	mov r1, #0
	str r0, [sp, #0x2c]
	add r0, sp, #0x5c
	str r0, [sp, #0x30]
	ldr r0, [r4]
	str r0, [sp, #0x58]
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [sp, #0x34]
	str r1, [sp, #0x38]
	str r1, [sp, #0x3c]
	str r0, [sp, #0x40]
	str r0, [sp, #0x44]
	str r0, [sp, #0x48]
	add r0, sp, #0x2c
	strh r1, [r0, #0x20]
	str r5, [sp, #0x54]
	add r0, sp, #0x80
	str r1, [sp, #0x50]
	ldrb r1, [r0, #0x14]
	mov r0, #0x2c
	add r5, r1, #0
	mul r5, r0
	add r0, sp, #0x2c
	bl Sprite_CreateAffine
	mov r1, #0x55
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	add r2, r2, r5
	str r0, [r2, #0x10]
	ldr r0, [r4, r1]
	add r0, r0, r5
	ldr r0, [r0, #0x10]
	cmp r0, #0
	bne _021E8F7E
	bl GF_AssertFail
_021E8F7E:
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	add r0, r0, r5
	ldr r0, [r0, #0x10]
	bl Sprite_SetAnimActiveFlag
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	add r0, r0, r5
	ldr r0, [r0, #0x10]
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x55
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	add r0, r0, r5
	ldr r0, [r0, #0x10]
	bl Sprite_SetDrawFlag
	add sp, #0x80
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8EE4

	thumb_func_start ov96_021E8FB4
ov96_021E8FB4: ; 0x021E8FB4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
_021E8FBA:
	add r0, r4, #0
	bl ov96_021E8FE0
	cmp r0, #0
	beq _021E8FD8
	ldr r0, [r4, #0xc]
	mov r1, #1
	str r1, [r0, #0xc]
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
	pop {r3, r4, r5, pc}
_021E8FD8:
	ldr r0, [r4, #0x10]
	cmp r0, #0
	bne _021E8FBA
	pop {r3, r4, r5, pc}
	thumb_func_end ov96_021E8FB4

	thumb_func_start ov96_021E8FE0
ov96_021E8FE0: ; 0x021E8FE0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r0, [r5, #8]
	cmp r0, #0
	beq _021E8FF2
	cmp r0, #1
	beq _021E90BE
	b _021E90F4
_021E8FF2:
	ldrh r0, [r5, #2]
	ldr r1, [r5, #4]
	add r2, r5, #0
	add r0, r1, r0
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	mov r0, #0x2c
	add r4, r7, #0
	mul r4, r0
	ldr r0, [r5, #0xc]
	lsl r6, r7, #4
	str r7, [sp]
	ldr r1, [r5, #0x18]
	add r2, #0x54
	str r1, [sp, #4]
	mov r1, #0x55
	lsl r1, r1, #2
	ldr r1, [r0, r1]
	ldr r3, [r5, #0x1c]
	add r1, r1, r4
	add r2, r2, r6
	bl ov96_021E8C70
	mov r0, #0x55
	add r3, r5, r6
	ldr r1, [r5, #0xc]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r3, #0x54
	add r2, r0, r4
	add r2, #0x14
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	mov r0, #0x55
	ldr r1, [r5, #0xc]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r0, r0, r4
	bl ov96_021E9104
	mov r1, #0x55
	ldr r2, [r5, #0xc]
	lsl r1, r1, #2
	ldr r1, [r2, r1]
	add r1, r1, r4
	str r0, [r1, #0x24]
	ldr r2, [r5, #0xc]
	mov r1, #0
	ldr r0, [r2, #8]
	cmp r0, #0
	beq _021E9068
	add r0, r5, r6
	add r0, #0x58
	ldrh r0, [r0]
	cmp r0, #0
	beq _021E9068
	mov r1, #1
_021E9068:
	mov r3, #0x55
	lsl r3, r3, #2
	mov r0, #0x2c
	ldr r2, [r2, r3]
	mul r0, r7
	add r2, r2, r0
	str r1, [r2, #0x28]
	ldr r1, [r5, #0xc]
	ldr r1, [r1, r3]
	add r0, r1, r0
	ldr r0, [r0, #0x28]
	cmp r0, #0
	beq _021E908A
	add r1, #0x24
	ldr r0, [r1, r4]
	add r0, #8
	str r0, [r1, r4]
_021E908A:
	ldr r0, [r5, #0x18]
	cmp r0, #0
	bne _021E90A6
	mov r0, #0x55
	ldr r1, [r5, #0xc]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r6, r0, r4
	ldr r0, [r0, r4]
	bl sub_0200A740
	ldr r0, [r6, #4]
	bl sub_0200A740
_021E90A6:
	ldrh r0, [r5, #2]
	add r0, r0, #1
	strh r0, [r5, #2]
	ldrh r1, [r5, #2]
	ldrh r0, [r5]
	cmp r1, r0
	blo _021E90F4
	mov r0, #0
	strh r0, [r5, #2]
	mov r0, #1
	str r0, [r5, #8]
	b _021E90F4
_021E90BE:
	ldrh r0, [r5, #2]
	ldr r1, [r5, #4]
	add r0, r1, r0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, [r5, #0xc]
	ldr r1, [r5, #0x14]
	ldr r2, [r5, #0x18]
	ldr r3, [r5, #0x20]
	bl ov96_021E8EE4
	ldrh r0, [r5, #2]
	add r0, r0, #1
	strh r0, [r5, #2]
	ldr r1, [r5, #0xc]
	ldrh r0, [r1, #6]
	add r0, r0, #1
	strh r0, [r1, #6]
	ldrh r1, [r5, #2]
	ldrh r0, [r5]
	cmp r1, r0
	blo _021E90F4
	add sp, #8
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021E90F4:
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E8FE0

	thumb_func_start ov96_021E90FC
ov96_021E90FC: ; 0x021E90FC
	ldr r0, [r0, #0x24]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bx lr
	thumb_func_end ov96_021E90FC

	thumb_func_start ov96_021E9104
ov96_021E9104: ; 0x021E9104
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, [r4]
	bl GF2DGfxResObj_GetCharDataPtr
	ldrh r1, [r4, #0x18]
	cmp r1, #0
	beq _021E911A
	mov r6, #8
	b _021E911C
_021E911A:
	mov r6, #4
_021E911C:
	mov r1, #0xff
	str r1, [sp, #8]
	ldr r0, [r0, #0x14]
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	cmp r6, #0
	ble _021E916E
	add r7, r0, #0
_021E912E:
	mov r4, #0xff
	mov r5, #0
	cmp r6, #0
	ble _021E9150
_021E9136:
	add r1, r5, r7
	ldr r0, [sp]
	lsl r1, r1, #5
	bl ov96_021E9180
	cmp r0, #0xff
	beq _021E914A
	cmp r4, r0
	bls _021E914A
	add r4, r0, #0
_021E914A:
	add r5, r5, #1
	cmp r5, r6
	blt _021E9136
_021E9150:
	cmp r4, #0xff
	beq _021E9162
	ldr r0, [sp, #4]
	lsl r0, r0, #3
	add r0, r4, r0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #8]
	b _021E916E
_021E9162:
	ldr r0, [sp, #4]
	add r7, r7, r6
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, r6
	blt _021E912E
_021E916E:
	ldr r0, [sp, #8]
	cmp r0, #0xff
	bne _021E9178
	bl GF_AssertFail
_021E9178:
	ldr r0, [sp, #8]
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov96_021E9104

	thumb_func_start ov96_021E9180
ov96_021E9180: ; 0x021E9180
	push {r4, r5}
	mov r4, #0
	mov r2, #0xff
	add r0, r0, r1
	add r3, r4, #0
_021E918A:
	add r5, r3, #0
_021E918C:
	ldrb r1, [r0]
	cmp r1, #0
	beq _021E9196
	add r2, r4, #0
	b _021E91A2
_021E9196:
	add r1, r5, #1
	lsl r1, r1, #0x18
	lsr r5, r1, #0x18
	add r0, r0, #1
	cmp r5, #4
	blo _021E918C
_021E91A2:
	cmp r5, #4
	bne _021E91B0
	add r1, r4, #1
	lsl r1, r1, #0x18
	lsr r4, r1, #0x18
	cmp r4, #8
	blo _021E918A
_021E91B0:
	add r0, r2, #0
	pop {r4, r5}
	bx lr
	.balign 4, 0
	thumb_func_end ov96_021E9180
