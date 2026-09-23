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
.public ov96_021E81D8
.public ov96_021E839C

	thumb_func_start ov96_021E604C
ov96_021E604C: ; 0x021E604C
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	str r0, [sp]
	mov r2, #0xa1
	ldr r1, [sp]
	lsl r2, r2, #2
	ldr r1, [r1, r2]
	mov r0, #0xa9
	bl NARC_New
	add r7, r0, #0
	mov r0, #0
	str r0, [sp, #8]
	ldr r1, _021E60B8 ; =0x00000618
	ldr r0, [sp]
	add r0, r0, r1
	str r0, [sp, #4]
_021E606E:
	ldr r4, [sp]
	ldr r5, [sp, #4]
	mov r6, #0
_021E6074:
	mov r0, #0x3f
	ldr r1, _021E60BC ; =0x000003F2
	lsl r0, r0, #4
	ldrh r0, [r4, r0]
	ldrh r1, [r4, r1]
	bl ov96_021E679C
	add r1, r0, #0
	add r0, r7, #0
	add r2, r5, #0
	bl NARC_ReadWholeMember
	add r6, r6, #1
	add r4, #0x28
	add r5, #0x14
	cmp r6, #3
	blt _021E6074
	ldr r0, [sp]
	add r0, #0x7c
	str r0, [sp]
	ldr r0, [sp, #4]
	add r0, #0x3c
	str r0, [sp, #4]
	ldr r0, [sp, #8]
	add r0, r0, #1
	str r0, [sp, #8]
	cmp r0, #4
	blt _021E606E
	add r0, r7, #0
	bl NARC_Delete
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021E60B8: .word 0x00000618
_021E60BC: .word 0x000003F2
	thumb_func_end ov96_021E604C

	thumb_func_start ov96_021E60C0
ov96_021E60C0: ; 0x021E60C0
	ldr r3, _021E60D4 ; =0x00000618
	add r3, r0, r3
	mov r0, #0x3c
	mul r0, r1
	add r1, r3, r0
	mov r0, #0x14
	mul r0, r2
	add r0, r1, r0
	bx lr
	nop
_021E60D4: .word 0x00000618
	thumb_func_end ov96_021E60C0

	thumb_func_start ov96_021E60D8
ov96_021E60D8: ; 0x021E60D8
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r6, r0, #0
	add r4, r2, #0
	cmp r5, #4
	blt _021E60E8
	bl GF_AssertFail
_021E60E8:
	cmp r4, #3
	blt _021E60F0
	bl GF_AssertFail
_021E60F0:
	mov r0, #0xfe
	lsl r0, r0, #2
	add r1, r6, r0
	mov r0, #0x7c
	mul r0, r5
	add r1, r1, r0
	mov r0, #0x28
	mul r0, r4
	add r0, r1, r0
	pop {r4, r5, r6, pc}
	thumb_func_end ov96_021E60D8

	thumb_func_start ov96_021E6104
ov96_021E6104: ; 0x021E6104
	mov r0, #0x50
	bx lr
	thumb_func_end ov96_021E6104

	thumb_func_start ov96_021E6108
ov96_021E6108: ; 0x021E6108
	push {r3, lr}
	cmp r0, #0
	bne _021E6112
	mov r0, #0
	pop {r3, pc}
_021E6112:
	ldrb r0, [r0, #8]
	cmp r0, #1
	beq _021E6122
	cmp r0, #2
	beq _021E6126
	cmp r0, #3
	beq _021E612A
	b _021E612E
_021E6122:
	mov r0, #1
	pop {r3, pc}
_021E6126:
	mov r0, #2
	pop {r3, pc}
_021E612A:
	mov r0, #3
	pop {r3, pc}
_021E612E:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov96_021E6108

	thumb_func_start ov96_021E6138
ov96_021E6138: ; 0x021E6138
	push {r3, lr}
	cmp r0, #0
	bne _021E6142
	mov r0, #0
	pop {r3, pc}
_021E6142:
	ldrb r0, [r0, #6]
	cmp r0, #1
	beq _021E6152
	cmp r0, #2
	beq _021E6156
	cmp r0, #3
	beq _021E615A
	b _021E615E
_021E6152:
	mov r0, #1
	pop {r3, pc}
_021E6156:
	mov r0, #2
	pop {r3, pc}
_021E615A:
	mov r0, #3
	pop {r3, pc}
_021E615E:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov96_021E6138

	thumb_func_start ov96_021E6168
ov96_021E6168: ; 0x021E6168
	push {r3, r4, r5, r6, r7, lr}
	add r5, r2, #0
	add r7, r0, #0
	add r6, r1, #0
	add r4, r3, #0
	cmp r5, #3
	blt _021E617A
	bl GF_AssertFail
_021E617A:
	add r0, r7, #0
	add r1, r6, #0
	bl PokeathlonCourse_GetParticipantUnk04
	mov r1, #0x28
	add r3, r5, #0
	mul r3, r1
	add r1, r0, r3
	ldrb r2, [r1, #0x10]
	strb r2, [r4, #6]
	ldrh r0, [r0, r3]
	strh r0, [r4]
	ldrh r0, [r1, #2]
	strh r0, [r4, #2]
	ldrb r0, [r1, #0x11]
	strb r0, [r4, #7]
	str r6, [r4, #8]
	ldr r0, [r1, #4]
	str r0, [r4, #0xc]
	ldrh r0, [r4]
	cmp r0, #0
	bne _021E61AA
	bl GF_AssertFail
_021E61AA:
	ldrh r0, [r4]
	cmp r0, #0
	bne _021E61B4
	mov r0, #1
	strh r0, [r4]
_021E61B4:
	ldrh r0, [r4]
	bl SpeciesToOverworldModelIndexOffset
	add r2, r0, #0
	add r0, sp, #0
	mov r1, #0x8d
	bl ReadWholeNarcMemberByIdPair
	add r0, sp, #0
	ldrb r0, [r0, #1]
	cmp r0, #0
	beq _021E61D2
	mov r0, #1
	strh r0, [r4, #4]
	pop {r3, r4, r5, r6, r7, pc}
_021E61D2:
	mov r0, #0
	strh r0, [r4, #4]
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov96_021E6168

	thumb_func_start ov96_021E61D8
ov96_021E61D8: ; 0x021E61D8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	mov r0, #0xa1
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r6, r2, #0
	add r7, r3, #0
	add r4, r1, #0
	str r0, [sp]
	add r0, r6, #0
	add r1, r7, #0
	mov r2, #0
	mov r3, #1
	bl ov96_021EA214
	ldr r1, _021E6280 ; =0x00000708
	mov r3, #0xa1
	str r0, [r5, r1]
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	add r0, r6, #0
	add r1, r7, #0
	mov r2, #0
	bl ov96_021EA4D4
	mov r1, #0x71
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r3, #0xa1
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	add r0, r6, #0
	add r1, r7, #0
	mov r2, #0
	bl ov96_021EA584
	ldr r1, _021E6284 ; =0x00000714
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp, #0x18]
	mov r0, #2
	lsl r0, r0, #0x12
	str r0, [sp, #0x10]
	add r0, r4, #0
	add r0, #0x60
	lsl r0, r0, #0xc
	sub r1, #0xc
	str r0, [sp, #0x14]
	ldr r0, [r5, r1]
	add r1, sp, #0x10
	bl Sprite_SetMatrix
	ldr r0, _021E6288 ; =0x0000070E
	mov r1, #0
	strh r4, [r5, r0]
	str r1, [sp, #0xc]
	mov r1, #2
	lsl r1, r1, #0x12
	str r1, [sp, #4]
	ldrh r1, [r5, r0]
	add r0, r0, #6
	add r1, #0x48
	lsl r1, r1, #0xc
	str r1, [sp, #8]
	ldr r0, [r5, r0]
	add r1, sp, #4
	bl Sprite_SetMatrix
	ldr r0, _021E628C ; =0x0000070D
	mov r1, #0
	strb r1, [r5, r0]
	add r4, #0x82
	lsl r1, r4, #0xc
	str r1, [sp, #0x14]
	add r0, r0, #3
	ldr r0, [r5, r0]
	add r1, sp, #0x10
	bl Sprite_SetMatrix
	ldr r0, _021E6280 ; =0x00000708
	add r0, r5, r0
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021E6280: .word 0x00000708
_021E6284: .word 0x00000714
_021E6288: .word 0x0000070E
_021E628C: .word 0x0000070D
	thumb_func_end ov96_021E61D8

	thumb_func_start ov96_021E6290
ov96_021E6290: ; 0x021E6290
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	add r6, r2, #0
	add r0, r3, #0
	bl ov96_021EB5E8
	add r3, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	add r2, r6, #0
	bl ov96_021E61D8
	pop {r4, r5, r6, pc}
	thumb_func_end ov96_021E6290

	thumb_func_start ov96_021E62AC
ov96_021E62AC: ; 0x021E62AC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r7, r0, #0
	ldr r0, [sp, #0x30]
	str r1, [sp, #4]
	str r0, [sp, #0x30]
	ldr r0, [sp, #0x34]
	ldr r1, _021E6340 ; =0x00000728
	str r0, [sp, #0x34]
	ldr r0, [sp, #0x38]
	str r2, [sp, #8]
	str r0, [sp, #0x38]
	ldr r0, [sp, #0x34]
	str r3, [sp, #0xc]
	strb r0, [r7, r1]
	ldr r0, [sp, #0x34]
	mov r4, #0
	cmp r0, #0
	bls _021E631E
_021E62D2:
	mov r0, #0xa1
	lsl r0, r0, #2
	ldr r0, [r7, r0]
	lsl r6, r4, #2
	str r0, [sp]
	ldr r0, [sp, #8]
	ldr r1, [sp, #0xc]
	ldr r2, [sp, #0x30]
	mov r3, #0
	add r5, r7, r6
	bl ov96_021EA6E4
	ldr r1, _021E6344 ; =0x0000071C
	str r0, [r5, r1]
	mov r0, #0
	str r0, [sp, #0x18]
	ldr r1, [sp, #0x38]
	ldr r0, [sp, #0x38]
	ldrh r1, [r1, r6]
	add r0, r0, r6
	lsl r1, r1, #0xc
	str r1, [sp, #0x10]
	ldrh r1, [r0, #2]
	ldr r0, [sp, #4]
	add r0, r0, r1
	lsl r0, r0, #0xc
	str r0, [sp, #0x14]
	ldr r0, _021E6344 ; =0x0000071C
	add r1, sp, #0x10
	ldr r0, [r5, r0]
	bl Sprite_SetMatrix
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	ldr r0, [sp, #0x34]
	cmp r4, r0
	blo _021E62D2
_021E631E:
	cmp r4, #3
	bhs _021E6336
	ldr r0, _021E6344 ; =0x0000071C
	mov r2, #0
_021E6326:
	lsl r1, r4, #2
	add r1, r7, r1
	str r2, [r1, r0]
	add r1, r4, #1
	lsl r1, r1, #0x18
	lsr r4, r1, #0x18
	cmp r4, #3
	blo _021E6326
_021E6336:
	ldr r0, _021E6348 ; =0x00000729
	mov r1, #0
	strb r1, [r7, r0]
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021E6340: .word 0x00000728
_021E6344: .word 0x0000071C
_021E6348: .word 0x00000729
	thumb_func_end ov96_021E62AC

	thumb_func_start ov96_021E634C
ov96_021E634C: ; 0x021E634C
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r3, #0
	add r4, r1, #0
	add r6, r2, #0
	bl ov96_021EB5E8
	add r3, r0, #0
	ldr r0, [sp, #0x20]
	add r1, r4, #0
	str r0, [sp]
	add r0, sp, #0x10
	ldrb r0, [r0, #0x14]
	add r2, r6, #0
	str r0, [sp, #4]
	ldr r0, [sp, #0x28]
	str r0, [sp, #8]
	add r0, r5, #0
	bl ov96_021E62AC
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov96_021E634C

	thumb_func_start ov96_021E637C
ov96_021E637C: ; 0x021E637C
	push {r3, r4, r5, lr}
	ldr r1, _021E643C ; =0x00000729
	add r5, r0, #0
	ldrb r2, [r5, r1]
	mov r4, #0
	cmp r2, #0
	beq _021E6394
	cmp r2, #1
	beq _021E63AA
	cmp r2, #2
	beq _021E63C4
	b _021E6438
_021E6394:
	ldr r0, _021E6440 ; =0x0000089A
	bl PlaySE
	add r0, r5, #0
	bl ov96_021E65D8
	ldr r0, _021E643C ; =0x00000729
	ldrb r1, [r5, r0]
	add r1, r1, #1
	strb r1, [r5, r0]
	b _021E6438
_021E63AA:
	bl ov96_021E661C
	cmp r0, #0
	beq _021E6438
	ldr r0, _021E643C ; =0x00000729
	ldrb r1, [r5, r0]
	add r1, r1, #1
	strb r1, [r5, r0]
	mov r0, #7
	add r1, r4, #0
	bl sub_020053A8
	b _021E6438
_021E63C4:
	sub r1, #0x1d
	ldrb r0, [r5, r1]
	cmp r0, #0
	bne _021E63E8
	ldr r0, _021E6444 ; =0x0000089D
	bl PlaySE
	ldr r0, _021E6448 ; =0x00000708
	mov r1, #1
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _021E6448 ; =0x00000708
	add r1, r4, #0
	ldr r0, [r5, r0]
	bl Sprite_SetAnimCtrlSeq
	b _021E6412
_021E63E8:
	cmp r0, #0x15
	bne _021E63FE
	ldr r0, _021E6444 ; =0x0000089D
	bl PlaySE
	ldr r0, _021E6448 ; =0x00000708
	mov r1, #1
	ldr r0, [r5, r0]
	bl Sprite_SetAnimCtrlSeq
	b _021E6412
_021E63FE:
	cmp r0, #0x2a
	bne _021E6412
	ldr r0, _021E6444 ; =0x0000089D
	bl PlaySE
	ldr r0, _021E6448 ; =0x00000708
	mov r1, #2
	ldr r0, [r5, r0]
	bl Sprite_SetAnimCtrlSeq
_021E6412:
	ldr r0, _021E644C ; =0x0000070C
	ldrb r1, [r5, r0]
	add r1, r1, #1
	strb r1, [r5, r0]
	ldrb r0, [r5, r0]
	cmp r0, #0x3f
	bls _021E6438
	ldr r0, _021E6450 ; =0x00000892
	bl PlaySE
	ldr r0, _021E6448 ; =0x00000708
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _021E644C ; =0x0000070C
	mov r1, #0
	strb r1, [r5, r0]
	mov r4, #1
_021E6438:
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E643C: .word 0x00000729
_021E6440: .word 0x0000089A
_021E6444: .word 0x0000089D
_021E6448: .word 0x00000708
_021E644C: .word 0x0000070C
_021E6450: .word 0x00000892
	thumb_func_end ov96_021E637C

	thumb_func_start ov96_021E6454
ov96_021E6454: ; 0x021E6454
	push {r3, r4, r5, lr}
	add r1, #0x1d
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #0x1e
	bl _s32_div_f
	add r4, r0, #0
	cmp r4, #0
	bgt _021E6474
	ldr r0, _021E64AC ; =0x00000714
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_021E6474:
	cmp r4, #3
	bgt _021E64A0
	ldr r0, _021E64B0 ; =0x0000072B
	ldrb r0, [r5, r0]
	cmp r0, r4
	beq _021E648A
	ldr r0, _021E64B4 ; =0x00000897
	bl PlaySE
	ldr r0, _021E64B0 ; =0x0000072B
	strb r4, [r5, r0]
_021E648A:
	ldr r0, _021E64AC ; =0x00000714
	mov r1, #1
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _021E64AC ; =0x00000714
	add r1, r4, #1
	ldr r0, [r5, r0]
	bl Sprite_SetAnimCtrlSeq
	pop {r3, r4, r5, pc}
_021E64A0:
	ldr r0, _021E64AC ; =0x00000714
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E64AC: .word 0x00000714
_021E64B0: .word 0x0000072B
_021E64B4: .word 0x00000897
	thumb_func_end ov96_021E6454

	thumb_func_start ov96_021E64B8
ov96_021E64B8: ; 0x021E64B8
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	mov r0, #0xd3
	mov r4, #0
	lsl r0, r0, #4
	str r4, [r7, r0]
	add r6, r4, #0
_021E64C6:
	lsl r0, r4, #4
	add r5, r7, r0
	ldr r0, _021E64F0 ; =0x00000D34
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _021E64D6
	bl GF_AssertFail
_021E64D6:
	ldr r0, _021E64F4 ; =0x00000D38
	str r6, [r5, r0]
	add r0, r0, #4
	str r6, [r5, r0]
	mov r0, #0x35
	lsl r0, r0, #6
	str r6, [r5, r0]
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #3
	blo _021E64C6
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E64F0: .word 0x00000D34
_021E64F4: .word 0x00000D38
	thumb_func_end ov96_021E64B8

	thumb_func_start ov96_021E64F8
ov96_021E64F8: ; 0x021E64F8
	push {r3, r4, r5, r6, r7, lr}
	add r7, r3, #0
	mov r3, #0xd3
	add r4, r0, #0
	lsl r3, r3, #4
	add r0, r2, #0
	ldr r2, [r4, r3]
	cmp r2, #3
	blo _021E6512
	bl GF_AssertFail
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E6512:
	add r3, r3, #4
	lsl r2, r2, #0x18
	add r6, r4, r3
	lsr r3, r2, #0x14
	mov r2, #1
	str r2, [r6, r3]
	add r5, r6, r3
	mov r3, #0xa1
	str r1, [r5, #4]
	lsl r3, r3, #2
	ldr r2, [sp, #0x18]
	ldr r3, [r4, r3]
	add r1, r7, #0
	bl ov96_021EA7A4
	str r0, [r5, #8]
	ldr r0, _021E654C ; =ov96_021E81D8
	add r1, r5, #0
	mov r2, #1
	bl SysTask_CreateOnMainQueue
	str r0, [r5, #0xc]
	mov r0, #0xd3
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	ldr r0, [r5, #8]
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E654C: .word ov96_021E81D8
	thumb_func_end ov96_021E64F8

	thumb_func_start ov96_021E6550
ov96_021E6550: ; 0x021E6550
	push {r3, r4, r5, r6, r7, lr}
	mov r4, #0
	add r7, r0, #0
	add r6, r4, #0
_021E6558:
	lsl r0, r4, #4
	add r5, r7, r0
	ldr r0, _021E6584 ; =0x00000D34
	str r6, [r5, r0]
	add r0, r0, #4
	str r6, [r5, r0]
	ldr r0, _021E6588 ; =0x00000D3C
	str r6, [r5, r0]
	add r0, r0, #4
	ldr r0, [r5, r0]
	bl SysTask_Destroy
	mov r0, #0x35
	mov r1, #0
	lsl r0, r0, #6
	str r1, [r5, r0]
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #3
	blo _021E6558
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E6584: .word 0x00000D34
_021E6588: .word 0x00000D3C
	thumb_func_end ov96_021E6550

	thumb_func_start ov96_021E658C
ov96_021E658C: ; 0x021E658C
	lsl r1, r1, #4
	add r1, r0, r1
	ldr r0, _021E659C ; =0x00000D3C
	ldr r3, _021E65A0 ; =Sprite_TryChangeAnimSeq
	ldr r0, [r1, r0]
	add r1, r2, #0
	bx r3
	nop
_021E659C: .word 0x00000D3C
_021E65A0: .word Sprite_TryChangeAnimSeq
	thumb_func_end ov96_021E658C

	thumb_func_start ov96_021E65A4
ov96_021E65A4: ; 0x021E65A4
	push {r3, r4, r5, r6, r7, lr}
	ldr r7, _021E65D0 ; =0x00000D34
	add r6, r0, #0
	mov r4, #0
_021E65AC:
	lsl r0, r4, #4
	add r5, r6, r0
	ldr r0, [r5, r7]
	cmp r0, #0
	bne _021E65BA
	bl GF_AssertFail
_021E65BA:
	ldr r0, _021E65D4 ; =0x00000D3C
	mov r1, #0
	ldr r0, [r5, r0]
	bl Sprite_SetAnimActiveFlag
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #3
	blo _021E65AC
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E65D0: .word 0x00000D34
_021E65D4: .word 0x00000D3C
	thumb_func_end ov96_021E65A4

	thumb_func_start ov96_021E65D8
ov96_021E65D8: ; 0x021E65D8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _021E6614 ; =0x00000728
	ldrb r0, [r5, r0]
	cmp r0, #0
	beq _021E6610
	mov r4, #0
	cmp r0, #0
	bls _021E6610
	ldr r7, _021E6614 ; =0x00000728
_021E65EC:
	lsl r0, r4, #2
	add r6, r5, r0
	ldr r0, _021E6618 ; =0x0000071C
	mov r1, #1
	ldr r0, [r6, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _021E6618 ; =0x0000071C
	mov r1, #0
	ldr r0, [r6, r0]
	bl Sprite_SetAnimCtrlSeq
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	ldrb r0, [r5, r7]
	cmp r4, r0
	blo _021E65EC
_021E6610:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E6614: .word 0x00000728
_021E6618: .word 0x0000071C
	thumb_func_end ov96_021E65D8

	thumb_func_start ov96_021E661C
ov96_021E661C: ; 0x021E661C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _021E6668 ; =0x00000728
	ldrb r1, [r5, r0]
	cmp r1, #0
	bne _021E662C
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021E662C:
	sub r0, #0xc
	ldr r0, [r5, r0]
	bl Sprite_IsAnimated
	cmp r0, #0
	bne _021E6664
	ldr r0, _021E6668 ; =0x00000728
	mov r4, #0
	ldrb r0, [r5, r0]
	cmp r0, #0
	bls _021E6660
	ldr r7, _021E666C ; =0x0000071C
	add r6, r7, #0
	add r6, #0xc
_021E6648:
	lsl r0, r4, #2
	add r0, r5, r0
	ldr r0, [r0, r7]
	mov r1, #0
	bl Sprite_SetDrawFlag
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	ldrb r0, [r5, r6]
	cmp r4, r0
	blo _021E6648
_021E6660:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_021E6664:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E6668: .word 0x00000728
_021E666C: .word 0x0000071C
	thumb_func_end ov96_021E661C

	thumb_func_start ov96_021E6670
ov96_021E6670: ; 0x021E6670
	ldr r2, _021E6678 ; =0x00000718
	str r1, [r0, r2]
	bx lr
	nop
_021E6678: .word 0x00000718
	thumb_func_end ov96_021E6670

	thumb_func_start ov96_021E667C
ov96_021E667C: ; 0x021E667C
	push {r3, r4, lr}
	sub sp, #0xc
	ldr r1, _021E6780 ; =0x0000070D
	add r4, r0, #0
	ldrb r2, [r4, r1]
	cmp r2, #4
	bhi _021E677A
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_021E6696: ; jump table
	.short _021E66A0 - _021E6696 - 2 ; case 0
	.short _021E66EA - _021E6696 - 2 ; case 1
	.short _021E6706 - _021E6696 - 2 ; case 2
	.short _021E6754 - _021E6696 - 2 ; case 3
	.short _021E6774 - _021E6696 - 2 ; case 4
_021E66A0:
	add r0, r1, #7
	ldr r0, [r4, r0]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, _021E6784 ; =0x00000899
	bl PlaySE
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #2
	lsl r0, r0, #0x12
	str r0, [sp]
	ldr r0, _021E6788 ; =0x0000070E
	ldrh r1, [r4, r0]
	sub r0, r0, #6
	add r1, #0x48
	lsl r1, r1, #0xc
	str r1, [sp, #4]
	ldr r0, [r4, r0]
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r0, _021E678C ; =0x00000708
	mov r1, #3
	ldr r0, [r4, r0]
	bl Sprite_SetAnimCtrlSeq
	ldr r0, _021E678C ; =0x00000708
	mov r1, #1
	ldr r0, [r4, r0]
	bl Sprite_SetDrawFlag
	ldr r0, _021E6780 ; =0x0000070D
	mov r1, #1
	strb r1, [r4, r0]
	b _021E677A
_021E66EA:
	sub r0, r1, #1
	ldrb r0, [r4, r0]
	add r2, r0, #1
	sub r0, r1, #1
	strb r2, [r4, r0]
	ldrb r0, [r4, r0]
	cmp r0, #0x3c
	bls _021E677A
	mov r2, #0
	sub r0, r1, #1
	strb r2, [r4, r0]
	mov r0, #2
	strb r0, [r4, r1]
	b _021E677A
_021E6706:
	ldr r1, _021E6790 ; =0x00000D6C
	ldr r1, [r4, r1]
	cmp r1, #0
	beq _021E6710
	blx r1
_021E6710:
	add r0, r4, #0
	bl ov96_021E839C
	cmp r0, #0
	beq _021E6738
	ldr r0, _021E6794 ; =0x00000898
	bl PlaySE
	mov r0, #0x71
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x71
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #1
	bl Sprite_SetDrawFlag
_021E6738:
	ldr r0, _021E6798 ; =0x00000718
	mov r1, #1
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl GfGfx_EngineATogglePlanes
	ldr r0, _021E6790 ; =0x00000D6C
	mov r1, #0
	str r1, [r4, r0]
	ldr r0, _021E6780 ; =0x0000070D
	mov r1, #3
	strb r1, [r4, r0]
	b _021E677A
_021E6754:
	sub r0, r1, #1
	ldrb r0, [r4, r0]
	add r2, r0, #1
	sub r0, r1, #1
	strb r2, [r4, r0]
	ldrb r0, [r4, r0]
	cmp r0, #0x78
	bls _021E677A
	mov r2, #0
	sub r0, r1, #1
	strb r2, [r4, r0]
	mov r0, #4
	strb r0, [r4, r1]
	add sp, #0xc
	mov r0, #1
	pop {r3, r4, pc}
_021E6774:
	add sp, #0xc
	mov r0, #1
	pop {r3, r4, pc}
_021E677A:
	mov r0, #0
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021E6780: .word 0x0000070D
_021E6784: .word 0x00000899
_021E6788: .word 0x0000070E
_021E678C: .word 0x00000708
_021E6790: .word 0x00000D6C
_021E6794: .word 0x00000898
_021E6798: .word 0x00000718
	thumb_func_end ov96_021E667C
