	.include "asm/macros.inc"
	.include "overlay_75.inc"
	.include "global.inc"
	.public gApplication_TitleScreen

	.text

	thumb_func_start ov75_02246960
ov75_02246960: ; 0x02246960
	push {r3, r4, r5, lr}
	mov r2, #0xa
	add r5, r0, #0
	mov r0, #3
	mov r1, #0x73
	lsl r2, r2, #0xe
	bl Heap_Create
	mov r2, #0x57
	mov r0, #0
	mov r1, #0x59
	lsl r2, r2, #4
	bl Heap_Create
	mov r1, #0x47
	add r0, r5, #0
	lsl r1, r1, #2
	mov r2, #0x73
	bl OverlayManager_CreateAndGetData
	mov r2, #0x47
	mov r1, #0
	lsl r2, r2, #2
	add r4, r0, #0
	bl MI_CpuFill8
	add r0, r5, #0
	bl OverlayManager_GetArgs
	ldr r0, [r0, #8]
	str r0, [r4, #4]
	bl Save_PlayerData_GetOptionsAddr
	str r0, [r4, #8]
	mov r0, #0x64
	mov r1, #0x73
	bl String_New
	mov r1, #0x11
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #0x64
	mov r1, #0x73
	bl String_New
	mov r1, #0x45
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r1, _022469D4 ; =0x0000047D
	mov r0, #0x11
	mov r2, #1
	bl Sound_SetSceneAndPlayBGM
	mov r0, #0
	add r4, #0x88
	str r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022469D4: .word 0x0000047D
	thumb_func_end ov75_02246960

	thumb_func_start ov75_022469D8
ov75_022469D8: ; 0x022469D8
	push {r3, r4, r5, lr}
	add r5, r1, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	ldr r0, [r4, #0x7c]
	cmp r0, #1
	bne _022469FC
	bl ov00_021ECB40
	bl ov70_022378DC
	bl ov00_021EC9D4
	mov r1, #3
	sub r0, r1, r0
	bl sub_0203A930
_022469FC:
	ldr r0, [r5]
	cmp r0, #4
	bhi _02246ADE
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02246A0E: ; jump table
	.short _02246A18 - _02246A0E - 2 ; case 0
	.short _02246A24 - _02246A0E - 2 ; case 1
	.short _02246A44 - _02246A0E - 2 ; case 2
	.short _02246A82 - _02246A0E - 2 ; case 3
	.short _02246ADA - _02246A0E - 2 ; case 4
_02246A18:
	add r0, r4, #0
	bl ov75_02246B48
	mov r0, #1
	str r0, [r5]
	b _02246ADE
_02246A24:
	bl sub_02034DB8
	cmp r0, #0
	beq _02246ADE
	ldr r1, [r4, #0x10]
	ldr r0, _02246AE4 ; =_02249BE0
	str r1, [r0]
	ldr r0, _02246AE8 ; =ov75_02246BF0
	ldr r1, _02246AEC ; =ov75_02246C18
	bl ov00_021EC294
	mov r0, #1
	str r0, [r4, #0x7c]
	mov r0, #2
	str r0, [r5]
	b _02246ADE
_02246A44:
	add r1, r4, #0
	add r1, #0x88
	ldr r1, [r1]
	add r0, r4, #0
	lsl r2, r1, #4
	ldr r1, _02246AF0 ; =ov75_02249904
	ldr r1, [r1, r2]
	blx r1
	add r1, r0, #0
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	lsl r2, r0, #4
	ldr r0, _02246AF4 ; =ov75_02249904 + 8
	ldr r0, [r0, r2]
	mov r2, #0x73
	bl OverlayManager_New
	str r0, [r4]
	add r0, r4, #0
	add r0, #0x88
	ldr r1, [r0]
	add r0, r4, #0
	add r0, #0x80
	str r1, [r0]
	mov r0, #6
	add r4, #0x88
	str r0, [r4]
	mov r0, #3
	str r0, [r5]
	b _02246ADE
_02246A82:
	ldr r0, [r4]
	bl OverlayManager_Run
	cmp r0, #1
	bne _02246ADE
	add r1, r4, #0
	add r1, #0x80
	ldr r1, [r1]
	add r0, r4, #0
	lsl r2, r1, #4
	ldr r1, _02246AF8 ; =ov75_02249904 + 4
	ldr r1, [r1, r2]
	blx r1
	ldr r0, [r4]
	bl OverlayManager_Delete
	add r0, r4, #0
	add r0, #0x88
	ldr r0, [r0]
	cmp r0, #6
	bne _02246AB2
	mov r0, #4
	str r0, [r5]
	b _02246ADE
_02246AB2:
	lsl r1, r0, #4
	ldr r0, _02246AFC ; =ov75_02249904 + 12
	ldr r0, [r0, r1]
	cmp r0, #1
	bne _02246AC8
	add r0, r4, #0
	bl ov75_02246B98
	mov r0, #2
	str r0, [r5]
	b _02246ADE
_02246AC8:
	ldr r0, [r4, #0x7c]
	cmp r0, #1
	bne _02246AD4
	mov r0, #2
	str r0, [r5]
	b _02246ADE
_02246AD4:
	mov r0, #0
	str r0, [r5]
	b _02246ADE
_02246ADA:
	mov r0, #1
	pop {r3, r4, r5, pc}
_02246ADE:
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_02246AE4: .word _02249BE0
_02246AE8: .word ov75_02246BF0
_02246AEC: .word ov75_02246C18
_02246AF0: .word ov75_02249904
_02246AF4: .word ov75_02249904 + 8
_02246AF8: .word ov75_02249904 + 4
_02246AFC: .word ov75_02249904 + 12
	thumb_func_end ov75_022469D8

	thumb_func_start ov75_02246B00
ov75_02246B00: ; 0x02246B00
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl OverlayManager_GetData
	add r4, r0, #0
	bl ov75_02246B98
	mov r0, #0x45
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl String_Delete
	mov r0, #0x11
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl String_Delete
	add r0, r5, #0
	bl OverlayManager_FreeData
	mov r0, #0x73
	bl Heap_Destroy
	mov r0, #0x59
	bl Heap_Destroy
	ldr r0, _02246B40 ; =FS_OVERLAY_ID(intro_title)
	ldr r1, _02246B44 ; =gApplication_TitleScreen
	bl RegisterMainOverlay
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02246B40: .word FS_OVERLAY_ID(intro_title)
_02246B44: .word gApplication_TitleScreen
	thumb_func_end ov75_02246B00

	thumb_func_start ov75_02246B48
ov75_02246B48: ; 0x02246B48
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x7c]
	cmp r0, #0
	bne _02246B8E
	ldr r0, _02246B90 ; =FS_OVERLAY_ID(OVY_70)
	mov r1, #2
	bl HandleLoadOverlay
	bl LoadDwcOverlay
	bl LoadOVY38
	mov r0, #0x73
	bl sub_02039FD8
	ldr r1, _02246B94 ; =0x00020020
	mov r0, #0x73
	bl Heap_Alloc
	str r0, [r4, #0xc]
	add r0, #0x1f
	mov r1, #0x1f
	bic r0, r1
	mov r1, #2
	lsl r1, r1, #0x10
	mov r2, #0
	bl NNS_FndCreateExpHeapEx
	str r0, [r4, #0x10]
	bl sub_02034D8C
	mov r0, #4
	bl Sys_ClearSleepDisableFlag
_02246B8E:
	pop {r4, pc}
	.balign 4, 0
_02246B90: .word FS_OVERLAY_ID(OVY_70)
_02246B94: .word 0x00020020
	thumb_func_end ov75_02246B48

	thumb_func_start ov75_02246B98
ov75_02246B98: ; 0x02246B98
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x7c]
	cmp r0, #1
	bne _02246BC4
	ldr r0, [r4, #0x10]
	bl NNS_FndDestroyExpHeap
	ldr r0, [r4, #0xc]
	bl Heap_Free
	bl UnloadOVY38
	bl UnloadDwcOverlay
	bl sub_02034DE0
	ldr r0, _02246BC8 ; =FS_OVERLAY_ID(OVY_70)
	bl UnloadOverlayByID
	mov r0, #0
	str r0, [r4, #0x7c]
_02246BC4:
	pop {r4, pc}
	nop
_02246BC8: .word FS_OVERLAY_ID(OVY_70)
	thumb_func_end ov75_02246B98

	thumb_func_start ov75_02246BCC
ov75_02246BCC: ; 0x02246BCC
	add r3, r0, #0
	add r3, #0x88
	str r1, [r3]
	add r0, #0x8c
	str r2, [r0]
	bx lr
	thumb_func_end ov75_02246BCC

	thumb_func_start ov75_02246BD8
ov75_02246BD8: ; 0x02246BD8
	mov r1, #6
	add r0, #0x88
	str r1, [r0]
	bx lr
	thumb_func_end ov75_02246BD8

	thumb_func_start ov75_02246BE0
ov75_02246BE0: ; 0x02246BE0
	add r0, #0x7a
	strb r1, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov75_02246BE0

	thumb_func_start ov75_02246BE8
ov75_02246BE8: ; 0x02246BE8
	add r0, #0x7a
	ldrb r0, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov75_02246BE8

	thumb_func_start ov75_02246BF0
ov75_02246BF0: ; 0x02246BF0
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r2, #0
	bl OS_DisableInterrupts
	add r6, r0, #0
	ldr r0, _02246C14 ; =_02249BE0
	add r1, r5, #0
	ldr r0, [r0]
	add r2, r4, #0
	bl NNS_FndAllocFromExpHeapEx
	add r4, r0, #0
	add r0, r6, #0
	bl OS_RestoreInterrupts
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02246C14: .word _02249BE0
	thumb_func_end ov75_02246BF0

	thumb_func_start ov75_02246C18
ov75_02246C18: ; 0x02246C18
	push {r3, r4, r5, lr}
	add r5, r1, #0
	beq _02246C34
	bl OS_DisableInterrupts
	add r4, r0, #0
	ldr r0, _02246C38 ; =_02249BE0
	add r1, r5, #0
	ldr r0, [r0]
	bl NNS_FndFreeToExpHeap
	add r0, r4, #0
	bl OS_RestoreInterrupts
_02246C34:
	pop {r3, r4, r5, pc}
	nop
_02246C38: .word _02249BE0
	thumb_func_end ov75_02246C18

	thumb_func_start ov75_02246C3C
ov75_02246C3C: ; 0x02246C3C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x73
	mov r1, #0x64
	bl Heap_Alloc
	add r4, r0, #0
	mov r0, #0x11
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	add r1, r4, #0
	mov r2, #0x73
	bl ov75_02249780
	ldr r0, [r5, #4]
	add r1, r4, #0
	bl sub_0203175C
	add r0, r4, #0
	bl Heap_Free
	pop {r3, r4, r5, pc}
	thumb_func_end ov75_02246C3C

	thumb_func_start ov75_02246C68
ov75_02246C68: ; 0x02246C68
	push {r4, lr}
	add r4, r0, #0
	add r2, r4, #0
	add r2, #0x78
	ldrh r2, [r2]
	ldr r0, [r4, #4]
	mov r1, #1
	bl sub_02031780
	mov r2, #0x42
	lsl r2, r2, #2
	ldr r0, [r4, #4]
	ldr r2, [r4, r2]
	mov r1, #2
	bl sub_02031780
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02246C68

	thumb_func_start ov75_02246C8C
ov75_02246C8C: ; 0x02246C8C
	mov r2, #0x41
	add r3, r0, #0
	lsl r2, r2, #2
	ldr r0, [r3, #4]
	ldr r2, [r3, r2]
	ldr r3, _02246C9C ; =sub_02031780
	mov r1, #3
	bx r3
	.balign 4, 0
_02246C9C: .word sub_02031780
	thumb_func_end ov75_02246C8C

	thumb_func_start ov75_02246CA0
ov75_02246CA0: ; 0x02246CA0
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	ldr r0, [r4, #4]
	add r1, #0x98
	bl sub_0203186C
	add r1, r0, #0
	add r0, r4, #0
	bl ov75_02246CD8
	pop {r4, pc}
	thumb_func_end ov75_02246CA0

	thumb_func_start ov75_02246CB8
ov75_02246CB8: ; 0x02246CB8
	add r1, r0, #0
	mov r0, #0x11
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r3, _02246CC8 ; =ov75_02249780
	add r1, #0xbc
	mov r2, #0x73
	bx r3
	.balign 4, 0
_02246CC8: .word ov75_02249780
	thumb_func_end ov75_02246CB8

	thumb_func_start ov75_02246CCC
ov75_02246CCC: ; 0x02246CCC
	mov r1, #0x42
	lsl r1, r1, #2
	ldr r1, [r0, r1]
	add r0, #0xfa
	strh r1, [r0]
	bx lr
	thumb_func_end ov75_02246CCC

	thumb_func_start ov75_02246CD8
ov75_02246CD8: ; 0x02246CD8
	add r0, #0x78
	strh r1, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov75_02246CD8

	thumb_func_start ov75_02246CE0
ov75_02246CE0: ; 0x02246CE0
	mov r1, #0x42
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bx lr
	thumb_func_end ov75_02246CE0

	thumb_func_start ov75_02246CE8
ov75_02246CE8: ; 0x02246CE8
	mov r1, #0x41
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bx lr
	thumb_func_end ov75_02246CE8

	thumb_func_start ov75_02246CF0
ov75_02246CF0: ; 0x02246CF0
	mov r2, #0x43
	lsl r2, r2, #2
	strb r1, [r0, r2]
	bx lr
	thumb_func_end ov75_02246CF0

	thumb_func_start ov75_02246CF8
ov75_02246CF8: ; 0x02246CF8
	mov r1, #0x43
	lsl r1, r1, #2
	ldrb r0, [r0, r1]
	bx lr
	thumb_func_end ov75_02246CF8

	thumb_func_start ov75_02246D00
ov75_02246D00: ; 0x02246D00
	bx lr
	.balign 4, 0
	thumb_func_end ov75_02246D00

	thumb_func_start ov75_02246D04
ov75_02246D04: ; 0x02246D04
	bx lr
	.balign 4, 0
	thumb_func_end ov75_02246D04

	thumb_func_start ov75_02246D08
ov75_02246D08: ; 0x02246D08
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #4
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	ldr r0, [r4, #4]
	bl Save_PlayerData_GetOptionsAddr
	add r3, r0, #0
	mov r0, #4
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x73
	mov r1, #0x10
	add r2, sp, #8
	bl sub_02085400
	add r1, r4, #0
	add r1, #0x94
	add r4, #0x94
	str r0, [r1]
	ldr r0, [r4]
	add sp, #0x18
	pop {r4, pc}
	thumb_func_end ov75_02246D08

	thumb_func_start ov75_02246D40
ov75_02246D40: ; 0x02246D40
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x94
	ldr r4, [r0]
	mov r1, #0x73
	ldr r0, [r4, #0x1c]
	bl ov75_02249838
	cmp r0, #0
	beq _02246D5E
	add r0, r5, #0
	mov r1, #1
	bl ov75_02246CF0
	b _02246DA0
_02246D5E:
	add r0, r5, #0
	bl ov75_02246CF8
	cmp r0, #2
	bne _02246D8C
	mov r0, #0x11
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r1, [r4, #0x1c]
	bl String_Compare
	cmp r0, #0
	beq _02246D82
	add r0, r5, #0
	mov r1, #3
	bl ov75_02246CF0
	b _02246DA0
_02246D82:
	add r0, r5, #0
	mov r1, #0
	bl ov75_02246CF0
	b _02246DA0
_02246D8C:
	mov r0, #0x11
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r1, [r4, #0x1c]
	bl String_Copy
	add r0, r5, #0
	mov r1, #2
	bl ov75_02246CF0
_02246DA0:
	add r0, r4, #0
	bl sub_02085438
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	bl ov75_02246BCC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov75_02246D40

	thumb_func_start ov75_02246DB4
ov75_02246DB4: ; 0x02246DB4
	push {r4, lr}
	sub sp, #0x20
	add r4, r0, #0
	mov r0, #3
	str r0, [sp, #0x10]
	mov r0, #4
	str r0, [sp, #0x14]
	mov r0, #0
	str r0, [sp, #0x18]
	str r0, [sp, #0x1c]
	ldr r0, [r4, #4]
	bl Save_PlayerData_GetOptionsAddr
	add r3, r0, #0
	mov r0, #5
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	add r0, r4, #0
	add r0, #0x78
	ldrh r0, [r0]
	mov r1, #7
	add r2, sp, #0x10
	str r0, [sp, #0xc]
	mov r0, #0x73
	bl sub_0208541C
	add r1, r4, #0
	add r1, #0x94
	add r4, #0x94
	str r0, [r1]
	ldr r0, [r4]
	add sp, #0x20
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02246DB4

	thumb_func_start ov75_02246DFC
ov75_02246DFC: ; 0x02246DFC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x94
	ldr r4, [r0]
	add r1, sp, #0
	ldr r0, [r4, #0x1c]
	bl String_atoi
	ldr r2, _02246E38 ; =0x00002710
	mov r3, #0
	bl _ull_mod
	mov r1, #0x42
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [sp]
	cmp r0, #0
	bne _02246E24
	bl GF_AssertFail
_02246E24:
	add r0, r4, #0
	bl sub_02085438
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	bl ov75_02246BCC
	pop {r3, r4, r5, pc}
	nop
_02246E38: .word 0x00002710
	thumb_func_end ov75_02246DFC

	thumb_func_start ov75_02246E3C
ov75_02246E3C: ; 0x02246E3C
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	str r0, [sp, #0x14]
	ldr r0, [r4, #4]
	bl Save_PlayerData_GetOptionsAddr
	add r3, r0, #0
	mov r0, #6
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #0x73
	mov r1, #4
	add r2, sp, #8
	bl sub_02085400
	add r1, r4, #0
	add r1, #0x94
	add r4, #0x94
	str r0, [r1]
	ldr r0, [r4]
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02246E3C

	thumb_func_start ov75_02246E78
ov75_02246E78: ; 0x02246E78
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x94
	ldr r4, [r0]
	add r1, sp, #0
	ldr r0, [r4, #0x1c]
	bl String_atoi
	mov r1, #0x41
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [sp]
	cmp r0, #0
	bne _02246E98
	bl GF_AssertFail
_02246E98:
	add r0, r4, #0
	bl sub_02085438
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	bl ov75_02246BCC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov75_02246E78

	thumb_func_start ov75_02246EAC
ov75_02246EAC: ; 0x02246EAC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x73
	mov r1, #0xc
	bl Heap_Alloc
	mov r1, #0
	mov r2, #0xc
	add r4, r0, #0
	bl MI_CpuFill8
	ldr r0, [r5, #4]
	str r0, [r4]
	mov r0, #1
	str r0, [r4, #4]
	mov r0, #0
	str r0, [r5, #0x7c]
	add r0, r5, #0
	add r0, #0x94
	add r5, #0x94
	str r4, [r0]
	ldr r0, [r5]
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov75_02246EAC

	thumb_func_start ov75_02246EDC
ov75_02246EDC: ; 0x02246EDC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #4]
	bl sub_0203A05C
	cmp r0, #0
	beq _02246EF4
	ldr r0, [r4, #4]
	bl Save_VarsFlags_Get
	bl SetFlag970
_02246EF4:
	add r0, r4, #0
	add r0, #0x94
	ldr r0, [r0]
	bl Heap_Free
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov75_02246BCC
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov75_02246EDC

	.rodata

ov75_022498E4:
	.word ov44_0222A4B4, ov44_0222A60C, ov44_0222A758, FS_OVERLAY_ID(OVY_44)
ov75_022498F4:
	.word ov75_02246F0C, ov75_02247118, ov75_02247180, 0xFFFFFFFF

ov75_02249904: ; 0x02249904
	.word ov75_02246D00, ov75_02246D04, ov75_022498F4, 0
	.word ov75_02246D08, ov75_02246D40, _02102620, 0
	.word ov75_02246DB4, ov75_02246DFC, _02102620, 0
	.word ov75_02246E3C, ov75_02246E78, _02102620, 0
	.word ov75_02246E3C, ov75_02246E78, _02102620, 0
	.word ov75_02246EAC, ov75_02246EDC, ov75_022498E4, 1

	.public ov75_App_MainMenu_SelectOption_WiiMessageSettings
ov75_App_MainMenu_SelectOption_WiiMessageSettings:
	.word ov75_02246960, ov75_022469D8, ov75_02246B00, 0xFFFFFFFF
ov75_02249974:
	.byte 0x0B, 0x07, 0x14, 0x08

ov75_02249978: ; 0x02249978
	.byte 0x0B, 0x0D, 0x14, 0x04

ov75_0224997C: ; 0x0224997C
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov75_0224998C: ; 0x0224998C
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x1D, 0x00, 0x00, 0x00

ov75_0224999C: ; 0x0224999C
	.byte 0x00, 0x00, 0x00, 0x00
	.word ov75_0224976C
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00
	.byte 0x00, 0x08, 0x00, 0x10, 0x2F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov75_022499BC: ; 0x022499BC
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x1D, 0x00, 0x00, 0x00

ov75_022499DC: ; 0x022499DC
	.byte 0x00, 0x00, 0x00, 0x00
	.word ov75_02249758
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x04, 0x00
	.byte 0x00, 0x08, 0x00, 0x10, 0x2F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov75_022499FC: ; 0x022499FC
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x60, 0x00, 0x00, 0x00

ov75_02249A24: ; 0x02249A24
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1B, 0x02, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov75_02249A5C: ; 0x02249A5C
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1F, 0x00
	.byte 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1E, 0x02, 0x00, 0x03, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x1D, 0x04, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x1C, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

ov75_02249ACC: ; 0x02249ACC
	.byte 0x77, 0x00, 0x00, 0x00

	.balign 4, 0
ov75_02249AD0: ; 0x02249AD0
	.asciz "@wii.com"

	.balign 4, 0
ov75_02249ADC: ; 0x02249ADC
	.byte 0x21, 0x01, 0x30, 0x00
	.byte 0x22, 0x01, 0x31, 0x00, 0x23, 0x01, 0x32, 0x00, 0x24, 0x01, 0x33, 0x00, 0x25, 0x01, 0x34, 0x00
	.byte 0x26, 0x01, 0x35, 0x00, 0x27, 0x01, 0x36, 0x00, 0x28, 0x01, 0x37, 0x00, 0x29, 0x01, 0x38, 0x00
	.byte 0x2A, 0x01, 0x39, 0x00

	.data

_02249B20:
	.byte 0x04, 0x00, 0x00, 0x00

ov75_02249B24: ; 0x02249B24
	.byte 0x08, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00

ov75_02249B30: ; 0x02249B30
	.word ov75_022478E0
	.word ov75_02247A78
	.word ov75_02247A98
	.word ov75_02247B98
	.word ov75_022483EC
	.word ov75_0224852C
	.word ov75_0224854C
	.word ov75_02248584
	.word ov75_02248684
	.word ov75_022486EC
	.word ov75_02248714
	.word ov75_0224874C
	.word ov75_02248774
	.word ov75_02248800
	.word ov75_022488AC
	.word ov75_022488BC
	.word ov75_02248994
	.word ov75_022489F8
	.word ov75_02248A20
	.word ov75_02248B8C
	.word ov75_02248C64
	.word ov75_02248C84
	.word ov75_02248D2C
	.word ov75_02248F18
	.word ov75_02248F7C
	.word ov75_02248FE8
	.word ov75_022490D8
	.word ov75_022491CC
	.word ov75_022491F0
	.word ov75_0224921C
	.word ov75_0224921C
	.word ov75_02249258
	.word ov75_02249278
	.word ov75_0224937C
	.word ov75_02249460
	.word ov75_02249478
	.word ov75_022494A4
	.word ov75_02249550
	.word ov75_022495B0

	.bss

_02249BE0:
	.space 0x20
