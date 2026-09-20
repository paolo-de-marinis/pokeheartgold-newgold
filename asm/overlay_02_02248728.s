#include "constants/abilities.h"
#include "constants/species.h"
#include "constants/sndseq.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/std_script.h"
	.include "asm/macros.inc"
	.include "overlay_02.inc"
	.include "global.inc"

	.text

	thumb_func_start ov02_02248728
ov02_02248728: ; 0x02248728
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r2, #0
	ldr r0, [sp, #0x1c]
	add r7, r3, #0
	strb r6, [r5]
	ldr r4, [sp, #0x18]
	strb r7, [r5, #1]
	strb r4, [r5, #2]
	str r0, [sp, #0x1c]
	strb r0, [r5, #3]
	ldr r0, [sp, #0x20]
	mov r2, #4
	strb r0, [r5, #4]
	ldr r0, [sp, #0x24]
	strb r0, [r5, #5]
	ldr r0, [sp, #0x28]
	strb r0, [r5, #6]
	ldr r0, [sp, #0x2c]
	strb r0, [r5, #7]
	add r0, r1, #0
	add r1, r5, #0
	add r1, #0xc
	bl G2dRenderer_Init
	str r0, [r5, #8]
	add r0, r5, #0
	mov r2, #2
	add r0, #0xc
	mov r1, #0
	lsl r2, r2, #0x14
	bl G2dRenderer_SetSubSurfaceCoords
	add r0, r6, #0
	mov r1, #0
	mov r2, #4
	bl Create2DGfxResObjMan
	mov r1, #0x4d
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r7, #0
	mov r1, #1
	mov r2, #4
	bl Create2DGfxResObjMan
	mov r1, #0x4e
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r4, #0
	mov r1, #2
	mov r2, #4
	bl Create2DGfxResObjMan
	mov r1, #0x4f
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [sp, #0x1c]
	mov r1, #3
	mov r2, #4
	bl Create2DGfxResObjMan
	mov r1, #5
	lsl r1, r1, #6
	str r0, [r5, r1]
	mov r0, #4
	lsl r1, r6, #3
	bl ov02_0224B690
	mov r1, #0x51
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #4
	lsl r1, r7, #3
	bl ov02_0224B690
	mov r1, #0x52
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #4
	lsl r1, r4, #3
	bl ov02_0224B690
	mov r1, #0x53
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r1, [sp, #0x1c]
	mov r0, #4
	lsl r1, r1, #3
	bl ov02_0224B690
	mov r1, #0x15
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r1, #0
	cmp r6, #0
	ble _02248804
	ble _02248804
	ldr r0, [sp, #0x20]
	add r2, r1, #0
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
_022487F4:
	mov r3, #0x51
	lsl r3, r3, #2
	ldr r3, [r5, r3]
	add r1, r1, #1
	strh r0, [r3, r2]
	add r2, #8
	cmp r1, r6
	blt _022487F4
_02248804:
	mov r3, #0
	cmp r7, #0
	ble _02248824
	ble _02248824
	ldr r0, [sp, #0x24]
	mov r6, #0x52
	lsl r0, r0, #0x10
	add r2, r3, #0
	asr r1, r0, #0x10
	lsl r6, r6, #2
_02248818:
	ldr r0, [r5, r6]
	add r3, r3, #1
	strh r1, [r0, r2]
	add r2, #8
	cmp r3, r7
	blt _02248818
_02248824:
	mov r1, #0
	cmp r4, #0
	ble _02248844
	ble _02248844
	ldr r2, [sp, #0x28]
	add r0, r1, #0
	lsl r2, r2, #0x10
	asr r6, r2, #0x10
	mov r2, #0x53
	lsl r2, r2, #2
_02248838:
	ldr r3, [r5, r2]
	add r1, r1, #1
	strh r6, [r3, r0]
	add r0, #8
	cmp r1, r4
	blt _02248838
_02248844:
	ldr r0, [sp, #0x1c]
	mov r1, #0
	cmp r0, #0
	ble _02248868
	ble _02248868
	ldr r2, [sp, #0x2c]
	mov r3, #0x15
	lsl r2, r2, #0x10
	add r0, r1, #0
	asr r4, r2, #0x10
	lsl r3, r3, #4
_0224885A:
	ldr r2, [r5, r3]
	add r1, r1, #1
	strh r4, [r2, r0]
	ldr r2, [sp, #0x1c]
	add r0, #8
	cmp r1, r2
	blt _0224885A
_02248868:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_02248728

	thumb_func_start ov02_0224886C
ov02_0224886C: ; 0x0224886C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldrb r0, [r5]
	mov r6, #0
	cmp r0, #0
	ble _0224889C
	add r4, r6, #0
	mov r7, #4
_0224887C:
	mov r0, #0x51
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	ldrsb r2, [r5, r7]
	add r0, r1, r4
	ldrsh r1, [r1, r4]
	cmp r2, r1
	beq _02248892
	ldr r0, [r0, #4]
	bl SpriteTransfer_DeleteCharTransferTask
_02248892:
	ldrb r0, [r5]
	add r6, r6, #1
	add r4, #8
	cmp r6, r0
	blt _0224887C
_0224889C:
	ldrb r0, [r5, #1]
	mov r6, #0
	cmp r0, #0
	ble _022488C8
	add r4, r6, #0
	mov r7, #5
_022488A8:
	mov r0, #0x52
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	ldrsb r2, [r5, r7]
	add r0, r1, r4
	ldrsh r1, [r1, r4]
	cmp r2, r1
	beq _022488BE
	ldr r0, [r0, #4]
	bl SpriteTransfer_DeletePlttTransferTask
_022488BE:
	ldrb r0, [r5, #1]
	add r6, r6, #1
	add r4, #8
	cmp r6, r0
	blt _022488A8
_022488C8:
	ldrb r0, [r5, #2]
	mov r6, #0
	cmp r0, #0
	ble _022488F4
	add r4, r6, #0
	mov r7, #6
_022488D4:
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	ldrsb r2, [r5, r7]
	add r0, r1, r4
	ldrsh r1, [r1, r4]
	cmp r2, r1
	beq _022488EA
	ldr r0, [r0, #4]
	bl sub_0200A740
_022488EA:
	ldrb r0, [r5, #2]
	add r6, r6, #1
	add r4, #8
	cmp r6, r0
	blt _022488D4
_022488F4:
	ldrb r0, [r5, #3]
	mov r6, #0
	cmp r0, #0
	ble _02248920
	add r4, r6, #0
	mov r7, #7
_02248900:
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r1, [r5, r0]
	ldrsb r2, [r5, r7]
	add r0, r1, r4
	ldrsh r1, [r1, r4]
	cmp r2, r1
	beq _02248916
	ldr r0, [r0, #4]
	bl sub_0200A740
_02248916:
	ldrb r0, [r5, #3]
	add r6, r6, #1
	add r4, #8
	cmp r6, r0
	blt _02248900
_02248920:
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Destroy2DGfxResObjMan
	mov r0, #0x4e
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Destroy2DGfxResObjMan
	mov r0, #0x4f
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Destroy2DGfxResObjMan
	mov r0, #5
	lsl r0, r0, #6
	ldr r0, [r5, r0]
	bl Destroy2DGfxResObjMan
	mov r0, #0x51
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Heap_Free
	mov r0, #0x52
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Heap_Free
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl Heap_Free
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl Heap_Free
	ldr r0, [r5, #8]
	bl SpriteList_DeleteAllSprites
	ldr r0, [r5, #8]
	bl SpriteList_Delete
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224886C

	thumb_func_start ov02_02248980
ov02_02248980: ; 0x02248980
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r0, #0
	ldrb r5, [r6]
	str r2, [sp, #0x10]
	str r1, [sp, #0xc]
	add r7, r3, #0
	mov r2, #0
	cmp r5, #0
	ble _022489E6
	mov r0, #0x51
	lsl r0, r0, #2
	ldr r3, [r6, r0]
	mov r0, #4
	ldrsb r4, [r6, r0]
	mov ip, r3
	add r0, r2, #0
_022489A2:
	ldrsh r1, [r3, r0]
	cmp r4, r1
	bne _022489DE
	lsl r4, r2, #3
	mov r0, ip
	strh r7, [r0, r4]
	mov r0, #0x51
	lsl r0, r0, #2
	ldr r1, [r6, r0]
	mov r3, #0
	add r1, r1, r4
	strh r3, [r1, #2]
	str r7, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	sub r0, #0x10
	ldr r0, [r6, r0]
	ldr r1, [sp, #0xc]
	ldr r2, [sp, #0x10]
	bl AddCharResObjFromOpenNarc
	mov r1, #0x51
	lsl r1, r1, #2
	ldr r1, [r6, r1]
	add sp, #0x14
	add r1, r1, r4
	str r0, [r1, #4]
	pop {r4, r5, r6, r7, pc}
_022489DE:
	add r2, r2, #1
	add r3, #8
	cmp r2, r5
	blt _022489A2
_022489E6:
	bl GF_AssertFail
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_02248980

	thumb_func_start ov02_022489F0
ov02_022489F0: ; 0x022489F0
	push {r4, r5, r6, lr}
	ldrb r3, [r0]
	mov r2, #0
	cmp r3, #0
	ble _02248A1E
	mov r4, #0x51
	lsl r4, r4, #2
	ldr r0, [r0, r4]
	add r4, r2, #0
	add r6, r0, #0
_02248A04:
	ldrsh r5, [r6, r4]
	cmp r1, r5
	bne _02248A16
	lsl r1, r2, #3
	add r0, r0, r1
	ldr r0, [r0, #4]
	bl SpriteTransfer_CreateCharTransferTask_AllocAtEnd
	pop {r4, r5, r6, pc}
_02248A16:
	add r2, r2, #1
	add r6, #8
	cmp r2, r3
	blt _02248A04
_02248A1E:
	bl GF_AssertFail
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_022489F0

	thumb_func_start ov02_02248A24
ov02_02248A24: ; 0x02248A24
	push {r4, r5, r6, lr}
	ldrb r3, [r0]
	mov r2, #0
	cmp r3, #0
	ble _02248A52
	mov r4, #0x51
	lsl r4, r4, #2
	ldr r0, [r0, r4]
	add r4, r2, #0
	add r6, r0, #0
_02248A38:
	ldrsh r5, [r6, r4]
	cmp r1, r5
	bne _02248A4A
	lsl r1, r2, #3
	add r0, r0, r1
	ldr r0, [r0, #4]
	bl sub_0200A740
	pop {r4, r5, r6, pc}
_02248A4A:
	add r2, r2, #1
	add r6, #8
	cmp r2, r3
	blt _02248A38
_02248A52:
	bl GF_AssertFail
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_02248A24

	thumb_func_start ov02_02248A58
ov02_02248A58: ; 0x02248A58
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r6, r0, #0
	ldrb r5, [r6]
	str r2, [sp, #0x14]
	str r1, [sp, #0x10]
	add r7, r3, #0
	mov r2, #0
	cmp r5, #0
	ble _02248AC0
	mov r0, #0x52
	lsl r0, r0, #2
	ldr r3, [r6, r0]
	mov r0, #5
	ldrsb r4, [r6, r0]
	mov ip, r3
	add r0, r2, #0
_02248A7A:
	ldrsh r1, [r3, r0]
	cmp r4, r1
	bne _02248AB8
	lsl r4, r2, #3
	mov r0, ip
	strh r7, [r0, r4]
	mov r0, #0x52
	lsl r0, r0, #2
	ldr r1, [r6, r0]
	mov r3, #0
	add r1, r1, r4
	strh r3, [r1, #2]
	str r7, [sp]
	mov r1, #1
	str r1, [sp, #4]
	str r1, [sp, #8]
	mov r1, #4
	str r1, [sp, #0xc]
	sub r0, #0x10
	ldr r0, [r6, r0]
	ldr r1, [sp, #0x10]
	ldr r2, [sp, #0x14]
	bl AddPlttResObjFromOpenNarc
	mov r1, #0x52
	lsl r1, r1, #2
	ldr r1, [r6, r1]
	add sp, #0x18
	add r1, r1, r4
	str r0, [r1, #4]
	pop {r3, r4, r5, r6, r7, pc}
_02248AB8:
	add r2, r2, #1
	add r3, #8
	cmp r2, r5
	blt _02248A7A
_02248AC0:
	bl GF_AssertFail
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_02248A58

	thumb_func_start ov02_02248AC8
ov02_02248AC8: ; 0x02248AC8
	push {r4, r5, r6, lr}
	ldrb r3, [r0, #1]
	mov r2, #0
	cmp r3, #0
	ble _02248AF6
	mov r4, #0x52
	lsl r4, r4, #2
	ldr r0, [r0, r4]
	add r4, r2, #0
	add r6, r0, #0
_02248ADC:
	ldrsh r5, [r6, r4]
	cmp r1, r5
	bne _02248AEE
	lsl r1, r2, #3
	add r0, r0, r1
	ldr r0, [r0, #4]
	bl SpriteTransfer_CreatePlttTransferTask
	pop {r4, r5, r6, pc}
_02248AEE:
	add r2, r2, #1
	add r6, #8
	cmp r2, r3
	blt _02248ADC
_02248AF6:
	bl GF_AssertFail
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_02248AC8

	thumb_func_start ov02_02248AFC
ov02_02248AFC: ; 0x02248AFC
	push {r4, r5, r6, lr}
	ldrb r3, [r0, #1]
	mov r2, #0
	cmp r3, #0
	ble _02248B2A
	mov r4, #0x52
	lsl r4, r4, #2
	ldr r0, [r0, r4]
	add r4, r2, #0
	add r6, r0, #0
_02248B10:
	ldrsh r5, [r6, r4]
	cmp r1, r5
	bne _02248B22
	lsl r1, r2, #3
	add r0, r0, r1
	ldr r0, [r0, #4]
	bl sub_0200A740
	pop {r4, r5, r6, pc}
_02248B22:
	add r2, r2, #1
	add r6, #8
	cmp r2, r3
	blt _02248B10
_02248B2A:
	bl GF_AssertFail
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_02248AFC

	thumb_func_start ov02_02248B30
ov02_02248B30: ; 0x02248B30
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r0, #0
	ldrb r5, [r6]
	str r2, [sp, #0x10]
	str r1, [sp, #0xc]
	add r7, r3, #0
	mov r2, #0
	cmp r5, #0
	ble _02248B96
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r3, [r6, r0]
	mov r0, #6
	ldrsb r4, [r6, r0]
	mov ip, r3
	add r0, r2, #0
_02248B52:
	ldrsh r1, [r3, r0]
	cmp r4, r1
	bne _02248B8E
	lsl r4, r2, #3
	mov r0, ip
	strh r7, [r0, r4]
	mov r0, #0x53
	lsl r0, r0, #2
	ldr r1, [r6, r0]
	mov r3, #0
	add r1, r1, r4
	strh r3, [r1, #2]
	str r7, [sp]
	mov r1, #2
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	sub r0, #0x10
	ldr r0, [r6, r0]
	ldr r1, [sp, #0xc]
	ldr r2, [sp, #0x10]
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x53
	lsl r1, r1, #2
	ldr r1, [r6, r1]
	add sp, #0x14
	add r1, r1, r4
	str r0, [r1, #4]
	pop {r4, r5, r6, r7, pc}
_02248B8E:
	add r2, r2, #1
	add r3, #8
	cmp r2, r5
	blt _02248B52
_02248B96:
	bl GF_AssertFail
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_02248B30

	thumb_func_start ov02_02248BA0
ov02_02248BA0: ; 0x02248BA0
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r6, r0, #0
	ldrb r5, [r6]
	str r2, [sp, #0x10]
	str r1, [sp, #0xc]
	add r7, r3, #0
	mov r2, #0
	cmp r5, #0
	ble _02248C06
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r3, [r6, r0]
	mov r0, #7
	ldrsb r4, [r6, r0]
	mov ip, r3
	add r0, r2, #0
_02248BC2:
	ldrsh r1, [r3, r0]
	cmp r4, r1
	bne _02248BFE
	lsl r4, r2, #3
	mov r0, ip
	strh r7, [r0, r4]
	mov r0, #0x15
	lsl r0, r0, #4
	ldr r1, [r6, r0]
	mov r3, #0
	add r1, r1, r4
	strh r3, [r1, #2]
	str r7, [sp]
	mov r1, #3
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp, #8]
	sub r0, #0x10
	ldr r0, [r6, r0]
	ldr r1, [sp, #0xc]
	ldr r2, [sp, #0x10]
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x15
	lsl r1, r1, #4
	ldr r1, [r6, r1]
	add sp, #0x14
	add r1, r1, r4
	str r0, [r1, #4]
	pop {r4, r5, r6, r7, pc}
_02248BFE:
	add r2, r2, #1
	add r3, #8
	cmp r2, r5
	blt _02248BC2
_02248C06:
	bl GF_AssertFail
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_02248BA0

	thumb_func_start ov02_02248C10
ov02_02248C10: ; 0x02248C10
	push {r4, r5, r6, lr}
	sub sp, #0x70
	add r5, r0, #0
	add r4, r1, #0
	add r1, r2, #0
	mov r0, #7
	add r2, r3, #0
	ldrsb r3, [r5, r0]
	ldr r6, [sp, #0x84]
	cmp r6, r3
	bne _02248C2A
	sub r0, #8
	str r0, [sp, #0x84]
_02248C2A:
	ldr r0, [sp, #0x84]
	mov r3, #0
	str r0, [sp]
	mov r0, #0
	mvn r0, r0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [sp, #0x88]
	str r3, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r0, #0x4d
	lsl r0, r0, #2
	ldr r6, [r5, r0]
	str r6, [sp, #0x14]
	add r6, r0, #4
	ldr r6, [r5, r6]
	str r6, [sp, #0x18]
	add r6, r0, #0
	add r6, #8
	ldr r6, [r5, r6]
	add r0, #0xc
	str r6, [sp, #0x1c]
	ldr r0, [r5, r0]
	str r0, [sp, #0x20]
	str r3, [sp, #0x24]
	str r3, [sp, #0x28]
	ldr r3, [sp, #0x80]
	add r0, sp, #0x4c
	bl CreateSpriteResourcesHeader
	ldr r0, [r5, #8]
	add r2, sp, #0x34
	str r0, [sp, #0x2c]
	add r0, sp, #0x4c
	str r0, [sp, #0x30]
	ldmia r4!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r4]
	str r0, [r2]
	ldr r0, [sp, #0x8c]
	str r0, [sp, #0x40]
	mov r0, #1
	str r0, [sp, #0x44]
	mov r0, #4
	str r0, [sp, #0x48]
	add r0, sp, #0x2c
	bl Sprite_Create
	add r4, r0, #0
	bne _02248C92
	bl GF_AssertFail
_02248C92:
	add r0, r4, #0
	add sp, #0x70
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_02248C10

	thumb_func_start ov02_02248C98
ov02_02248C98: ; 0x02248C98
	push {r4, lr}
	add r4, r1, #0
	bl Sprite_GetMatrixPtr
	add r2, r0, #0
	ldmia r2!, {r0, r1}
	stmia r4!, {r0, r1}
	ldr r0, [r2]
	str r0, [r4]
	pop {r4, pc}
	thumb_func_end ov02_02248C98

	thumb_func_start ov02_02248CAC
ov02_02248CAC: ; 0x02248CAC
	push {r3, r4, r5, r6, lr}
	sub sp, #0x34
	add r4, r0, #0
	mov r2, #0
	add r0, sp, #0x1c
	str r2, [r0]
	str r2, [r0, #4]
	add r3, sp, #0x28
	str r2, [r3]
	str r2, [r3, #4]
	ldr r6, _02248D14 ; =ov02_02253360
	str r2, [r0, #8]
	ldmia r6!, {r0, r1}
	add r5, sp, #0x10
	stmia r5!, {r0, r1}
	ldr r0, [r6]
	str r2, [r3, #8]
	str r0, [r5]
	add r1, r3, #0
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r2, [sp, #8]
	mov r0, #0x84
	str r0, [sp, #0xc]
	add r0, r4, #0
	add r3, r2, #0
	bl ov02_02248C10
	add r4, r0, #0
	mov r1, #2
	bl Sprite_SetAffineOverwriteMode
	add r0, r4, #0
	add r1, sp, #0x1c
	bl Sprite_SetAffineMatrix
	add r0, r4, #0
	add r1, sp, #0x10
	bl Sprite_SetAffineScale
	mov r0, #0
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	add r0, r4, #0
	add sp, #0x34
	pop {r3, r4, r5, r6, pc}
	nop
_02248D14: .word ov02_02253360
	thumb_func_end ov02_02248CAC

	thumb_func_start ov02_02248D18
ov02_02248D18: ; 0x02248D18
	push {r3, r4, lr}
	sub sp, #0x1c
	mov r3, #0
	add r2, sp, #0x10
	str r3, [r2]
	str r3, [r2, #4]
	str r3, [r2, #8]
	cmp r1, #1
	bne _02248D2C
	mov r3, #1
_02248D2C:
	mov r2, #2
	str r2, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #0x83
	str r1, [sp, #0xc]
	add r1, sp, #0x10
	bl ov02_02248C10
	add r4, r0, #0
	mov r1, #0
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #6
	bl Sprite_SetAnimCtrlSeq
	add r0, r4, #0
	add sp, #0x1c
	pop {r3, r4, pc}
	thumb_func_end ov02_02248D18

	thumb_func_start ov02_02248D58
ov02_02248D58: ; 0x02248D58
	push {r4, r5, lr}
	sub sp, #0x24
	add r5, sp, #0x18
	mov r4, #0
	str r4, [r5]
	str r4, [r5, #4]
	str r0, [sp, #0xc]
	str r2, [sp, #0x14]
	str r3, [sp, #0x10]
	str r4, [r5, #8]
	str r1, [sp, #8]
	add r0, sp, #8
	str r0, [sp]
	mov r0, #0x82
	str r0, [sp, #4]
	add r0, r1, #0
	ldr r1, _02248D88 ; =ov02_02253454
	add r2, r5, #0
	add r3, r4, #0
	bl sub_02068B0C
	add sp, #0x24
	pop {r4, r5, pc}
	nop
_02248D88: .word ov02_02253454
	thumb_func_end ov02_02248D58

	thumb_func_start ov02_02248D8C
ov02_02248D8C: ; 0x02248D8C
	push {r3, lr}
	bl sub_02068D74
	ldrb r0, [r0, #2]
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_02248D8C

	thumb_func_start ov02_02248D98
ov02_02248D98: ; 0x02248D98
	push {r4, lr}
	add r4, r1, #0
	bl sub_02068D98
	add r2, r4, #0
	add r3, r0, #0
	add r2, #0x58
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r4, #0x64]
	bl ov02_02248CAC
	str r0, [r4, #0x68]
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02248D98

	thumb_func_start ov02_02248DBC
ov02_02248DBC: ; 0x02248DBC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl sub_02068D74
	add r4, r0, #0
	ldr r0, [r4, #0x6c]
	cmp r0, #0
	beq _02248DD0
	bl sub_02068B48
_02248DD0:
	ldr r0, [r4, #0x70]
	cmp r0, #0
	beq _02248DDA
	bl ov01_021FCD78
_02248DDA:
	add r0, r5, #0
	bl sub_02068B48
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_02248DBC

	thumb_func_start ov02_02248DE4
ov02_02248DE4: ; 0x02248DE4
	ldr r3, _02248DEC ; =Sprite_Delete
	ldr r0, [r1, #0x68]
	bx r3
	nop
_02248DEC: .word Sprite_Delete
	thumb_func_end ov02_02248DE4

	thumb_func_start ov02_02248DF0
ov02_02248DF0: ; 0x02248DF0
	push {r3, r4, r5, lr}
	add r5, r1, #0
	ldrb r0, [r5]
	lsl r1, r0, #2
	ldr r0, _02248E0C ; =ov02_02253320
	ldr r4, [r0, r1]
_02248DFC:
	ldrb r1, [r5, #1]
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	blx r1
	cmp r0, #1
	beq _02248DFC
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02248E0C: .word ov02_02253320
	thumb_func_end ov02_02248DF0

	thumb_func_start ov02_02248E10
ov02_02248E10: ; 0x02248E10
	push {r3, lr}
	mov r1, #0
	strb r1, [r0, #2]
	ldr r0, [r0, #0x68]
	bl Sprite_SetDrawFlag
	mov r0, #0
	pop {r3, pc}
	thumb_func_end ov02_02248E10

	thumb_func_start ov02_02248E20
ov02_02248E20: ; 0x02248E20
	push {r4, r5, r6, lr}
	sub sp, #0x30
	ldr r4, _02248F74 ; =ov02_0225339C
	add r2, r0, #0
	ldmia r4!, {r0, r1}
	add r3, sp, #0x24
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	ldr r4, _02248F78 ; =ov02_022533CC
	str r0, [r3]
	ldmia r4!, {r0, r1}
	add r3, sp, #0x18
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	str r0, [r3]
	add r0, r2, #0
	bl sub_02068D74
	add r4, r0, #0
	mov r3, #1
	add r5, r4, #0
	strb r3, [r4]
	mov r2, #0
	strb r2, [r4, #2]
	strb r2, [r4, #1]
	str r2, [r4, #4]
	add r6, sp, #0x24
	ldmia r6!, {r0, r1}
	add r5, #8
	stmia r5!, {r0, r1}
	ldr r0, [r6]
	str r0, [r5]
	str r2, [r4, #0x14]
	str r2, [r4, #0x18]
	str r2, [r4, #0x1c]
	ldr r0, _02248F7C ; =0x0015E000
	add r2, r4, #0
	add r5, sp, #0x18
	str r0, [r4, #0x38]
	ldmia r5!, {r0, r1}
	add r2, #0x2c
	stmia r2!, {r0, r1}
	ldr r0, [r5]
	str r0, [r2]
	lsl r0, r3, #0xa
	str r0, [r4, #0x50]
	mov r0, #0x2d
	lsl r0, r0, #0xc
	str r0, [r4, #0x40]
	mov r0, #3
	lsl r0, r0, #0x12
	str r0, [r4, #0x48]
	lsl r0, r3, #0x11
	str r0, [r4, #0x4c]
	mov r0, #0x2d
	bl GF_CosDeg
	ldr r2, [r4, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r4, #0x14]
	ldr r1, [r4, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_SinDeg
	ldr r2, [r4, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r4, #0x18]
	ldr r1, [r4, #8]
	ldr r0, [r4, #0x14]
	add r0, r1, r0
	str r0, [sp, #0x24]
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x18]
	add r0, r1, r0
	str r0, [sp, #0x28]
	ldr r0, [r4, #0x68]
	add r1, sp, #0x24
	bl Sprite_SetMatrix
	ldr r0, [r4, #0x68]
	add r1, sp, #0x18
	bl Sprite_SetAffineScale
	ldr r1, [r4, #0x38]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	ldr r0, [r4, #0x68]
	bl Sprite_SetAffineZRotation
	ldr r0, [r4, #0x68]
	mov r1, #0x84
	bl Sprite_SetDrawPriority
	ldr r0, [r4, #0x68]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x58]
	ldr r1, [r4, #0x60]
	bl ov02_0224B298
	str r0, [r4, #0x6c]
	ldr r0, [r4, #0x5c]
	mov r1, #4
	bl ov01_021FCD2C
	ldr r2, _02248F80 ; =0xFFF88000
	mov r1, #1
	mov r3, #0xc
	str r0, [r4, #0x70]
	bl ov01_021FCD8C
	add r1, sp, #0xc
	mov r0, #0
	str r0, [r1]
	str r0, [r1, #4]
	ldr r3, _02248F84 ; =ov02_022533A8
	str r0, [r1, #8]
	ldmia r3!, {r0, r1}
	add r2, sp, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	mov r1, #2
	str r0, [r2]
	ldr r4, [r4, #0x60]
	add r0, r4, #0
	bl Sprite_SetAffineOverwriteMode
	add r0, r4, #0
	add r1, sp, #0xc
	bl Sprite_SetAffineMatrix
	add r0, r4, #0
	add r1, sp, #0
	bl Sprite_SetAffineScale
	mov r0, #0
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	add r0, r4, #0
	mov r1, #2
	bl Sprite_SetAnimCtrlSeq
	bl ov02_022493FC
	add sp, #0x30
	pop {r4, r5, r6, pc}
	nop
_02248F74: .word ov02_0225339C
_02248F78: .word ov02_022533CC
_02248F7C: .word 0x0015E000
_02248F80: .word 0xFFF88000
_02248F84: .word ov02_022533A8
	thumb_func_end ov02_02248E20

	thumb_func_start ov02_02248F88
ov02_02248F88: ; 0x02248F88
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r1, [r5, #0x48]
	ldr r0, [r5, #0x4c]
	ldr r6, [r5, #0x68]
	ldr r4, [r5, #0x60]
	sub r0, r1, r0
	str r0, [r5, #0x48]
	bpl _02248FA0
	mov r0, #0
	str r0, [r5, #0x48]
_02248FA0:
	mov r0, #2
	ldr r1, [r5, #0x4c]
	lsl r0, r0, #0xa
	cmp r1, r0
	ble _02248FB2
	mov r0, #7
	lsl r0, r0, #0xa
	sub r0, r1, r0
	str r0, [r5, #0x4c]
_02248FB2:
	mov r0, #1
	ldr r1, [r5, #0x4c]
	lsl r0, r0, #0xc
	cmp r1, r0
	bge _02248FBE
	str r0, [r5, #0x4c]
_02248FBE:
	mov r0, #0x2d
	bl GF_CosDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x14]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_SinDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x18]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r0, r0, #0xc
	cmp r0, #0x5a
	bge _02249006
	mov r0, #1
	lsl r0, r0, #0xe
	add r0, r1, r0
	str r0, [r5, #0x40]
_02249006:
	ldr r1, [r5, #0x2c]
	ldr r0, [r5, #0x50]
	sub r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [r5, #0x2c]
	cmp r1, r0
	bge _02249018
	str r0, [r5, #0x2c]
_02249018:
	ldr r1, [r5, #0x30]
	ldr r0, [r5, #0x50]
	sub r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [r5, #0x30]
	cmp r1, r0
	bge _0224902A
	str r0, [r5, #0x30]
_0224902A:
	add r1, r5, #0
	add r0, r6, #0
	add r1, #0x2c
	bl Sprite_SetAffineScale
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x2c
	bl Sprite_SetAffineScale
	ldr r1, [r5, #8]
	ldr r0, [r5, #0x14]
	add r0, r1, r0
	str r0, [sp]
	ldr r1, [r5, #0xc]
	ldr r0, [r5, #0x18]
	add r0, r1, r0
	str r0, [sp, #4]
	add r0, r6, #0
	add r1, sp, #0
	bl Sprite_SetMatrix
	mov r0, #0x12
	ldr r1, [sp, #4]
	lsl r0, r0, #0xc
	sub r0, r1, r0
	str r0, [sp, #4]
	add r0, r4, #0
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r0, [r5, #0x48]
	cmp r0, #0
	bne _0224907A
	mov r0, #0
	str r0, [r5, #4]
	ldrb r0, [r5, #1]
	add r0, r0, #1
	strb r0, [r5, #1]
	b _02249080
_0224907A:
	ldr r0, [r5, #4]
	add r0, r0, #1
	str r0, [r5, #4]
_02249080:
	mov r0, #0
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_02248F88

	thumb_func_start ov02_02249088
ov02_02249088: ; 0x02249088
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x6c]
	bl ov02_0224B314
	ldr r0, [r4, #0x70]
	mov r1, #2
	mov r2, #0
	mov r3, #0xc
	bl ov01_021FCD8C
	mov r0, #1
	lsl r0, r0, #0xa
	str r0, [r4, #0x50]
	lsl r0, r0, #9
	str r0, [r4, #0x40]
	mov r0, #0
	str r0, [r4, #0x48]
	mov r0, #6
	lsl r0, r0, #0xa
	str r0, [r4, #0x4c]
	ldrb r0, [r4, #1]
	add r0, r0, #1
	strb r0, [r4, #1]
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov02_02249088

	thumb_func_start ov02_022490BC
ov02_022490BC: ; 0x022490BC
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r1, [r5, #0x48]
	ldr r0, [r5, #0x4c]
	ldr r4, [r5, #0x68]
	add r0, r1, r0
	str r0, [r5, #0x48]
	mov r0, #1
	ldr r1, [r5, #0x4c]
	lsl r0, r0, #0xc
	add r2, r1, r0
	lsl r1, r0, #4
	str r2, [r5, #0x4c]
	cmp r2, r1
	ble _022490E0
	lsl r0, r0, #4
	str r0, [r5, #0x4c]
_022490E0:
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_CosDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x14]
	mov r0, #0x80
	bl GF_SinDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x18]
	mov r0, #0xa
	ldr r1, [r5, #0x40]
	lsl r0, r0, #0x10
	cmp r1, r0
	bge _02249124
	mov r0, #1
	lsl r0, r0, #0xc
	add r0, r1, r0
	str r0, [r5, #0x40]
_02249124:
	mov r0, #2
	ldr r1, [r5, #0x38]
	lsl r0, r0, #0xc
	add r1, r1, r0
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	str r1, [r5, #0x38]
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	ldr r1, [r5, #0x2c]
	ldr r0, [r5, #0x50]
	add r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [r5, #0x2c]
	cmp r1, r0
	ble _02249156
	str r0, [r5, #0x2c]
_02249156:
	ldr r1, [r5, #0x30]
	ldr r0, [r5, #0x50]
	add r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [r5, #0x30]
	cmp r1, r0
	ble _02249168
	str r0, [r5, #0x30]
_02249168:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x2c
	bl Sprite_SetAffineScale
	ldr r1, [r5, #8]
	ldr r0, [r5, #0x14]
	add r0, r1, r0
	str r0, [sp]
	ldr r1, [r5, #0xc]
	ldr r0, [r5, #0x18]
	sub r0, r1, r0
	str r0, [sp, #4]
	add r0, r4, #0
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r1, [sp, #4]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r1, r0, #0xc
	mov r0, #0xf
	mvn r0, r0
	cmp r1, r0
	bgt _022491A2
	ldrb r0, [r5, #1]
	add r0, r0, #1
	strb r0, [r5, #1]
_022491A2:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov02_022490BC

	thumb_func_start ov02_022491A8
ov02_022491A8: ; 0x022491A8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x68]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x60]
	mov r1, #1
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0
	str r0, [r4, #4]
	ldrb r0, [r4, #1]
	add r0, r0, #1
	strb r0, [r4, #1]
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_022491A8

	thumb_func_start ov02_022491CC
ov02_022491CC: ; 0x022491CC
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r4, r0, #0
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
	cmp r0, #0x14
	bge _022491E2
	add sp, #0x18
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_022491E2:
	ldr r3, _02249284 ; =ov02_022533D8
	add r2, sp, #0xc
	ldmia r3!, {r0, r1}
	add r6, r2, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	ldr r3, _02249288 ; =ov02_022533B4
	str r0, [r2]
	add r2, sp, #0
	ldmia r3!, {r0, r1}
	add r5, r2, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	mov r7, #0
	str r0, [r2]
	add r2, r4, #0
	str r7, [r4, #4]
	add r3, r6, #0
	ldmia r3!, {r0, r1}
	add r2, #8
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	str r7, [r4, #0x14]
	str r7, [r4, #0x18]
	str r7, [r4, #0x1c]
	str r7, [r4, #0x38]
	add r2, r4, #0
	ldmia r5!, {r0, r1}
	add r2, #0x2c
	stmia r2!, {r0, r1}
	ldr r0, [r5]
	mov r1, #2
	str r0, [r2]
	lsl r1, r1, #8
	ldr r0, _0224928C ; =0x0013B000
	str r1, [r4, #0x50]
	str r0, [r4, #0x40]
	lsl r0, r1, #0xa
	str r0, [r4, #0x48]
	lsl r0, r1, #4
	str r0, [r4, #0x4c]
	ldr r0, [r4, #0x68]
	add r1, r6, #0
	bl Sprite_SetMatrix
	ldr r0, [r4, #0x68]
	add r1, sp, #0
	bl Sprite_SetAffineScale
	ldr r1, [r4, #0x38]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	ldr r0, [r4, #0x68]
	bl Sprite_SetAffineZRotation
	ldr r0, [r4, #0x68]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x60]
	mov r1, #6
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r4, #0x60]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	ldrb r0, [r4, #1]
	add r0, r0, #1
	strb r0, [r4, #1]
	mov r0, #1
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02249284: .word ov02_022533D8
_02249288: .word ov02_022533B4
_0224928C: .word 0x0013B000
	thumb_func_end ov02_022491CC

	thumb_func_start ov02_02249290
ov02_02249290: ; 0x02249290
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r1, [r5, #0x48]
	ldr r0, [r5, #0x4c]
	ldr r4, [r5, #0x68]
	sub r0, r1, r0
	str r0, [r5, #0x48]
	mov r0, #1
	ldr r1, [r5, #0x4c]
	lsl r0, r0, #0x10
	cmp r1, r0
	bge _022492B0
	lsr r0, r0, #3
	add r0, r1, r0
	str r0, [r5, #0x4c]
_022492B0:
	ldr r0, [r5, #0x48]
	cmp r0, #0
	bge _022492BA
	mov r0, #0
	str r0, [r5, #0x48]
_022492BA:
	ldr r0, _02249398 ; =0x0000013B
	bl GF_CosDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x14]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_SinDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x18]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r0, r0, #0xc
	cmp r0, #0xb4
	bge _02249302
	mov r0, #1
	lsl r0, r0, #0xe
	sub r0, r1, r0
	str r0, [r5, #0x40]
_02249302:
	ldr r1, [r5, #0x2c]
	ldr r0, [r5, #0x50]
	sub r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xa
	str r1, [r5, #0x2c]
	cmp r1, r0
	bge _02249314
	str r0, [r5, #0x2c]
_02249314:
	ldr r1, [r5, #0x30]
	ldr r0, [r5, #0x50]
	sub r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xa
	str r1, [r5, #0x30]
	cmp r1, r0
	bge _02249326
	str r0, [r5, #0x30]
_02249326:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x2c
	bl Sprite_SetAffineScale
	mov r0, #6
	ldr r1, [r5, #0x38]
	lsl r0, r0, #0xc
	add r1, r1, r0
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r0, r0, #0xc
	str r1, [r5, #0x38]
	cmp r0, #0x3c
	ble _0224934C
	mov r0, #0xf
	lsl r0, r0, #0xe
	str r0, [r5, #0x38]
_0224934C:
	ldr r1, [r5, #0x38]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	ldr r1, [r5, #8]
	ldr r0, [r5, #0x14]
	add r0, r1, r0
	str r0, [sp]
	ldr r1, [r5, #0xc]
	ldr r0, [r5, #0x18]
	add r0, r1, r0
	str r0, [sp, #4]
	add r0, r4, #0
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r0, [r5, #0x48]
	cmp r0, #0
	bgt _02249390
	add r0, r4, #0
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldrb r0, [r5, #1]
	add r0, r0, #1
	strb r0, [r5, #1]
_02249390:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_02249398: .word 0x0000013B
	thumb_func_end ov02_02249290

	thumb_func_start ov02_0224939C
ov02_0224939C: ; 0x0224939C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
	cmp r0, #8
	bne _022493BA
	ldr r0, [r4, #0x60]
	mov r1, #1
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r4, #0x5c]
	mov r1, #0
	bl ov02_02249444
_022493BA:
	ldr r0, [r4, #4]
	cmp r0, #0xa
	bne _022493C8
	ldr r0, [r4, #0x60]
	mov r1, #0
	bl Sprite_SetDrawFlag
_022493C8:
	ldr r0, [r4, #4]
	cmp r0, #0xf
	ble _022493E6
	ldr r0, [r4, #0x70]
	bl ov01_021FCD6C
	cmp r0, #1
	bne _022493E6
	mov r0, #0
	str r0, [r4, #4]
	ldrb r0, [r4, #1]
	add r0, r0, #1
	strb r0, [r4, #1]
	mov r0, #2
	strb r0, [r4, #2]
_022493E6:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224939C

	thumb_func_start ov02_022493EC
ov02_022493EC: ; 0x022493EC
	mov r0, #0
	bx lr
	thumb_func_end ov02_022493EC

	thumb_func_start ov02_022493F0
ov02_022493F0: ; 0x022493F0
	ldr r3, _022493F8 ; =NARC_New
	mov r0, #0x5d
	mov r1, #4
	bx r3
	.balign 4, 0
_022493F8: .word NARC_New
	thumb_func_end ov02_022493F0

	thumb_func_start ov02_022493FC
ov02_022493FC: ; 0x022493FC
	push {lr}
	sub sp, #0xc
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r3, _0224941C ; =0x00007FFF
	mov r0, #0
	add r2, r1, #0
	bl BeginNormalPaletteFade
	add sp, #0xc
	pop {pc}
	nop
_0224941C: .word 0x00007FFF
	thumb_func_end ov02_022493FC

	thumb_func_start ov02_02249420
ov02_02249420: ; 0x02249420
	push {lr}
	sub sp, #0xc
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0
	ldr r3, _02249440 ; =0x00007FFF
	add r1, r0, #0
	add r2, r0, #0
	bl BeginNormalPaletteFade
	add sp, #0xc
	pop {pc}
	.balign 4, 0
_02249440: .word 0x00007FFF
	thumb_func_end ov02_02249420

	thumb_func_start ov02_02249444
ov02_02249444: ; 0x02249444
	push {r4, lr}
	ldr r0, [r0, #0x40]
	add r4, r1, #0
	bl PlayerAvatar_GetMapObject
	add r1, r4, #0
	bl MapObject_SetVisible
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249444

	thumb_func_start ov02_02249458
ov02_02249458: ; 0x02249458
	push {r3, r4, r5, r6, r7, lr}
	str r0, [sp]
	add r5, r1, #0
	add r6, r2, #0
	add r7, r3, #0
	bl ov02_0224955C
	add r4, r0, #0
	str r6, [r4, #0x5c]
	strh r7, [r4, #0xc]
	ldrh r0, [r4, #0xc]
	strh r0, [r4, #0xe]
	str r5, [r4, #0x20]
	ldr r0, [r4, #0x60]
	ldr r0, [r0, #0x40]
	bl PlayerAvatar_GetMapObject
	mov r1, #0x82
	lsl r1, r1, #2
	str r0, [r4, r1]
	cmp r5, #0
	bne _02249490
	ldr r0, _022494B8 ; =ov02_02249584
	add r1, r4, #0
	mov r2, #0x86
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, r6, r7, pc}
_02249490:
	cmp r5, #2
	bne _022494AC
	ldr r0, [sp]
	bl FollowMon_GetMapObject
	mov r1, #0x83
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, _022494BC ; =ov02_022499B8
	add r1, r4, #0
	mov r2, #0x86
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, r6, r7, pc}
_022494AC:
	ldr r0, _022494C0 ; =ov02_02249984
	add r1, r4, #0
	mov r2, #0x86
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_022494B8: .word ov02_02249584
_022494BC: .word ov02_022499B8
_022494C0: .word ov02_02249984
	thumb_func_end ov02_02249458

	thumb_func_start ov02_022494C4
ov02_022494C4: ; 0x022494C4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r1, #0
	add r6, r2, #0
	add r7, r3, #0
	bl ov02_0224955C
	add r4, r0, #0
	str r5, [r4, #0x5c]
	mov r0, #0
	strh r0, [r4, #0xc]
	mov r0, #2
	strh r0, [r4, #0xe]
	mov r0, #3
	str r0, [r4, #0x20]
	mov r0, #0x82
	lsl r0, r0, #2
	str r6, [r4, r0]
	add r0, r0, #4
	str r7, [r4, r0]
	ldr r0, [r4, #0x60]
	ldr r0, [r0, #0x40]
	bl PlayerAvatar_GetMapObject
	add r1, sp, #0xc
	bl MapObject_CopyPositionVector
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, sp, #0
	bl MapObject_CopyPositionVector
	ldr r1, [sp]
	ldr r0, [sp, #0xc]
	sub r0, r1, r0
	mov r1, #2
	lsl r1, r1, #0xc
	bl FX_Div
	mov r1, #0xbb
	lsl r1, r1, #2
	ldr r2, [r4, r1]
	add r0, r2, r0
	str r0, [r4, r1]
	ldr r2, [sp, #8]
	ldr r0, [sp, #0x14]
	add r1, #8
	sub r0, r2, r0
	str r0, [r4, r1]
	ldr r0, _02249538 ; =ov02_022499B8
	add r1, r4, #0
	mov r2, #0x86
	bl SysTask_CreateOnMainQueue
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02249538: .word ov02_022499B8
	thumb_func_end ov02_022494C4

	thumb_func_start ov02_0224953C
ov02_0224953C: ; 0x0224953C
	push {r3, lr}
	bl SysTask_GetData
	ldr r0, [r0, #4]
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224953C

	thumb_func_start ov02_02249548
ov02_02249548: ; 0x02249548
	push {r4, lr}
	add r4, r0, #0
	bl SysTask_GetData
	bl ov02_0224957C
	add r0, r4, #0
	bl SysTask_Destroy
	pop {r4, pc}
	thumb_func_end ov02_02249548

	thumb_func_start ov02_0224955C
ov02_0224955C: ; 0x0224955C
	push {r3, r4, r5, lr}
	mov r1, #0xbe
	add r5, r0, #0
	mov r0, #4
	lsl r1, r1, #2
	bl Heap_AllocAtEnd
	mov r2, #0xbe
	mov r1, #0
	lsl r2, r2, #2
	add r4, r0, #0
	bl memset
	str r5, [r4, #0x60]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224955C

	thumb_func_start ov02_0224957C
ov02_0224957C: ; 0x0224957C
	ldr r3, _02249580 ; =Heap_Free
	bx r3
	.balign 4, 0
_02249580: .word Heap_Free
	thumb_func_end ov02_0224957C

	thumb_func_start ov02_02249584
ov02_02249584: ; 0x02249584
	push {r3, r4, r5, lr}
	ldr r4, _022495B4 ; =ov02_02253550
	add r5, r1, #0
_0224958A:
	ldr r1, [r5]
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	blx r1
	cmp r0, #1
	beq _0224958A
	ldr r0, [r5, #0x10]
	cmp r0, #1
	bne _022495B2
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _022495AC
	bl sub_02068BAC
_022495AC:
	add r0, r5, #0
	bl ov02_0224A32C
_022495B2:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022495B4: .word ov02_02253550
	thumb_func_end ov02_02249584

	thumb_func_start ov02_022495B8
ov02_022495B8: ; 0x022495B8
	push {r4, lr}
	add r4, r0, #0
	bl ov02_02249EC0
	add r0, r4, #0
	bl ov02_02249CF0
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov02_022495B8

	thumb_func_start ov02_022495D0
ov02_022495D0: ; 0x022495D0
	push {r4, lr}
	add r4, r0, #0
	bl ov02_02249F6C
	add r0, r4, #0
	bl ov02_02249CF0
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov02_022495D0

	thumb_func_start ov02_022495E8
ov02_022495E8: ; 0x022495E8
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #0x85
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _022495FE
	add sp, #0x18
	mov r0, #0
	pop {r3, r4, r5, pc}
_022495FE:
	ldr r5, _02249650 ; =ov02_02253408
	add r3, sp, #0xc
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	ldr r5, _02249654 ; =ov02_02253384
	str r0, [r3]
	ldmia r5!, {r0, r1}
	add r3, sp, #0
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	add r1, r2, #0
	str r0, [r3]
	add r0, r4, #0
	bl ov02_0224A418
	mov r1, #0x79
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	add r1, sp, #0
	bl ov02_0224A9B8
	mov r1, #0x7a
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #1
	bl ov02_0224A9D8
	add r0, r4, #0
	bl ov02_02249D40
	mov r0, #1
	str r0, [r4, #0x10]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02249650: .word ov02_02253408
_02249654: .word ov02_02253384
	thumb_func_end ov02_022495E8

	thumb_func_start ov02_02249658
ov02_02249658: ; 0x02249658
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224B72C
	mov r0, #0
	ldr r1, _0224968C ; =0xFFFC0000
	str r0, [r4, #0x2c]
	str r1, [r4, #0x54]
	mov r1, #0xfe
	lsl r1, r1, #0xc
	str r1, [r4, #0x44]
	mov r1, #0xff
	lsl r1, r1, #0xc
	str r1, [r4, #0x48]
	mov r1, #0x5f
	lsl r1, r1, #0xc
	str r1, [r4, #0x4c]
	mov r1, #0x61
	lsl r1, r1, #0xc
	str r1, [r4, #0x50]
	mov r1, #1
	str r1, [r4, #0x2c]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	pop {r4, pc}
	.balign 4, 0
_0224968C: .word 0xFFFC0000
	thumb_func_end ov02_02249658

	thumb_func_start ov02_02249690
ov02_02249690: ; 0x02249690
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r2, #0
	str r2, [r4, #0x2c]
	ldr r1, [r4, #0x44]
	ldr r0, [r4, #0x54]
	add r0, r1, r0
	str r0, [r4, #0x44]
	cmp r0, #0
	bgt _022496B4
	mov r0, #2
	str r2, [r4, #0x44]
	lsl r0, r0, #0xc
	str r0, [r4, #0x54]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_022496B4:
	ldr r0, [r4, #0x50]
	str r0, [sp]
	ldr r1, [r4, #0x44]
	ldr r2, [r4, #0x4c]
	ldr r3, [r4, #0x48]
	add r0, r4, #0
	bl ov02_0224A69C
	mov r0, #1
	str r0, [r4, #0x2c]
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249690

	thumb_func_start ov02_022496D0
ov02_022496D0: ; 0x022496D0
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r0, #0
	str r0, [r4, #0x2c]
	ldr r1, [r4, #0x4c]
	ldr r0, [r4, #0x54]
	sub r0, r1, r0
	str r0, [r4, #0x4c]
	ldr r1, [r4, #0x50]
	ldr r0, [r4, #0x54]
	add r0, r1, r0
	str r0, [r4, #0x50]
	mov r0, #2
	ldr r1, [r4, #0x54]
	lsl r0, r0, #0xc
	add r2, r1, r0
	lsl r1, r0, #4
	str r2, [r4, #0x54]
	cmp r2, r1
	ble _022496FE
	lsl r0, r0, #4
	str r0, [r4, #0x54]
_022496FE:
	mov r0, #0xe
	ldr r1, [r4, #0x4c]
	lsl r0, r0, #0xe
	cmp r1, r0
	bge _0224970A
	str r0, [r4, #0x4c]
_0224970A:
	mov r0, #0x22
	ldr r1, [r4, #0x50]
	lsl r0, r0, #0xe
	cmp r1, r0
	ble _02249716
	str r0, [r4, #0x50]
_02249716:
	ldr r0, [r4, #0x50]
	str r0, [sp]
	ldr r1, [r4, #0x44]
	ldr r2, [r4, #0x4c]
	ldr r3, [r4, #0x48]
	add r0, r4, #0
	bl ov02_0224A69C
	mov r0, #1
	str r0, [r4, #0x2c]
	mov r0, #0xe
	ldr r1, [r4, #0x4c]
	lsl r0, r0, #0xe
	cmp r1, r0
	bne _0224974E
	mov r0, #0x22
	ldr r1, [r4, #0x50]
	lsl r0, r0, #0xe
	cmp r1, r0
	bne _0224974E
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ov02_0224A450
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_0224974E:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov02_022496D0

	thumb_func_start ov02_02249754
ov02_02249754: ; 0x02249754
	ldr r1, [r0, #8]
	add r1, r1, #1
	str r1, [r0, #8]
	cmp r1, #0xf
	blt _0224976C
	mov r1, #0
	str r1, [r0, #8]
	ldr r1, _02249770 ; =0xFFFC0000
	str r1, [r0, #0x58]
	ldr r1, [r0]
	add r1, r1, #1
	str r1, [r0]
_0224976C:
	mov r0, #0
	bx lr
	.balign 4, 0
_02249770: .word 0xFFFC0000
	thumb_func_end ov02_02249754

	thumb_func_start ov02_02249774
ov02_02249774: ; 0x02249774
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_GetMatrixPtr
	add r3, r0, #0
	ldmia r3!, {r0, r1}
	add r2, sp, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r1, [sp]
	ldr r0, [r4, #0x58]
	add r1, r1, r0
	mov r0, #0xa
	lsl r0, r0, #0x10
	str r1, [sp]
	cmp r1, r0
	bgt _022497AC
	mov r0, #3
	lsl r0, r0, #0x12
	str r0, [sp]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_022497AC:
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, sp, #0
	bl Sprite_SetMatrix
	mov r0, #0
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249774

	thumb_func_start ov02_022497C0
ov02_022497C0: ; 0x022497C0
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r1, [r4, #0x58]
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r1, r0, #1
	ldr r0, _02249834 ; =0xFFFFE000
	str r1, [r4, #0x58]
	cmp r1, r0
	ble _02249802
	str r0, [r4, #0x58]
	ldr r0, [r4]
	mov r1, #5
	add r0, r0, #1
	str r0, [r4]
	ldr r0, [r4, #0x5c]
	mov r2, #0
	bl GetMonData
	add r5, r0, #0
	ldr r0, [r4, #0x5c]
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r1, r0, #0
	lsl r0, r5, #0x10
	lsl r1, r1, #0x18
	lsr r0, r0, #0x10
	lsr r1, r1, #0x18
	bl PlayCry
_02249802:
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_GetMatrixPtr
	add r5, r0, #0
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	str r0, [r3]
	ldr r1, [sp]
	ldr r0, [r4, #0x58]
	add r0, r1, r0
	str r0, [sp]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, r2, #0
	bl Sprite_SetMatrix
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_02249834: .word 0xFFFFE000
	thumb_func_end ov02_022497C0

	thumb_func_start ov02_02249838
ov02_02249838: ; 0x02249838
	ldr r1, [r0, #8]
	add r1, r1, #1
	str r1, [r0, #8]
	cmp r1, #8
	blt _02249850
	mov r1, #0
	str r1, [r0, #8]
	ldr r1, _02249854 ; =0xFFFFF000
	str r1, [r0, #0x58]
	ldr r1, [r0]
	add r1, r1, #1
	str r1, [r0]
_02249850:
	mov r0, #0
	bx lr
	.balign 4, 0
_02249854: .word 0xFFFFF000
	thumb_func_end ov02_02249838

	thumb_func_start ov02_02249858
ov02_02249858: ; 0x02249858
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, [r4, #0x58]
	lsl r1, r0, #1
	ldr r0, _022498B4 ; =0xFFFC0000
	str r1, [r4, #0x58]
	cmp r1, r0
	bge _0224986C
	str r0, [r4, #0x58]
_0224986C:
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Sprite_GetMatrixPtr
	add r5, r0, #0
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	str r0, [r3]
	ldr r1, [sp]
	ldr r0, [r4, #0x58]
	add r0, r1, r0
	str r0, [sp]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, r2, #0
	bl Sprite_SetMatrix
	ldr r1, [sp]
	ldr r0, _022498B8 ; =0xFFFD8000
	cmp r1, r0
	bgt _022498AC
	mov r0, #1
	lsl r0, r0, #0xc
	str r0, [r4, #0x54]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_022498AC:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_022498B4: .word 0xFFFC0000
_022498B8: .word 0xFFFD8000
	thumb_func_end ov02_02249858

	thumb_func_start ov02_022498BC
ov02_022498BC: ; 0x022498BC
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r0, #0
	str r0, [r4, #0x2c]
	ldr r1, [r4, #0x4c]
	ldr r0, [r4, #0x54]
	add r0, r1, r0
	str r0, [r4, #0x4c]
	ldr r1, [r4, #0x50]
	ldr r0, [r4, #0x54]
	sub r0, r1, r0
	str r0, [r4, #0x50]
	mov r0, #1
	ldr r1, [r4, #0x54]
	lsl r0, r0, #0xe
	add r2, r1, r0
	lsl r1, r0, #2
	str r2, [r4, #0x54]
	cmp r2, r1
	ble _022498EA
	lsl r0, r0, #2
	str r0, [r4, #0x54]
_022498EA:
	mov r0, #0x5f
	ldr r1, [r4, #0x4c]
	lsl r0, r0, #0xc
	cmp r1, r0
	blt _022498F6
	str r0, [r4, #0x4c]
_022498F6:
	mov r0, #0x61
	ldr r1, [r4, #0x50]
	lsl r0, r0, #0xc
	cmp r1, r0
	bgt _02249902
	str r0, [r4, #0x50]
_02249902:
	ldr r0, [r4, #0x50]
	str r0, [sp]
	ldr r1, [r4, #0x44]
	ldr r2, [r4, #0x4c]
	ldr r3, [r4, #0x48]
	add r0, r4, #0
	bl ov02_0224A69C
	mov r0, #1
	str r0, [r4, #0x2c]
	mov r0, #0x5f
	ldr r1, [r4, #0x4c]
	lsl r0, r0, #0xc
	cmp r1, r0
	bne _0224993A
	mov r0, #0x61
	ldr r1, [r4, #0x50]
	lsl r0, r0, #0xc
	cmp r1, r0
	bne _0224993A
	add r0, r4, #0
	bl ov02_0224B768
	mov r0, #0x11
	str r0, [r4, #0x34]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_0224993A:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov02_022498BC

	thumb_func_start ov02_02249940
ov02_02249940: ; 0x02249940
	push {r4, lr}
	add r4, r0, #0
	bl ov02_02249FD4
	mov r0, #0
	str r0, [r4, #0x10]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	pop {r4, pc}
	thumb_func_end ov02_02249940

	thumb_func_start ov02_02249954
ov02_02249954: ; 0x02249954
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224A028
	mov r0, #0
	str r0, [r4, #0x10]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	pop {r4, pc}
	thumb_func_end ov02_02249954

	thumb_func_start ov02_02249968
ov02_02249968: ; 0x02249968
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224A6D0
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249968

	thumb_func_start ov02_0224997C
ov02_0224997C: ; 0x0224997C
	mov r1, #1
	str r1, [r0, #4]
	mov r0, #0
	bx lr
	thumb_func_end ov02_0224997C

	thumb_func_start ov02_02249984
ov02_02249984: ; 0x02249984
	push {r3, r4, r5, lr}
	ldr r4, _022499B4 ; =ov02_02253588
	add r5, r1, #0
_0224998A:
	ldr r1, [r5]
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	blx r1
	cmp r0, #1
	beq _0224998A
	ldr r0, [r5, #0x10]
	cmp r0, #1
	bne _022499B2
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _022499AC
	bl sub_02068BAC
_022499AC:
	add r0, r5, #0
	bl ov02_0224A32C
_022499B2:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022499B4: .word ov02_02253588
	thumb_func_end ov02_02249984

	thumb_func_start ov02_022499B8
ov02_022499B8: ; 0x022499B8
	push {r3, r4, r5, lr}
	ldr r4, _022499E8 ; =ov02_022534F0
	add r5, r1, #0
_022499BE:
	ldr r1, [r5]
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	blx r1
	cmp r0, #1
	beq _022499BE
	ldr r0, [r5, #0x10]
	cmp r0, #1
	bne _022499E6
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _022499E0
	bl sub_02068BAC
_022499E0:
	add r0, r5, #0
	bl ov02_0224A32C
_022499E6:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022499E8: .word ov02_022534F0
	thumb_func_end ov02_022499B8

	thumb_func_start ov02_022499EC
ov02_022499EC: ; 0x022499EC
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #0x85
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _02249A02
	add sp, #0x18
	mov r0, #0
	pop {r3, r4, r5, pc}
_02249A02:
	ldr r5, _02249A54 ; =ov02_022533FC
	add r3, sp, #0xc
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	ldr r5, _02249A58 ; =ov02_02253414
	str r0, [r3]
	ldmia r5!, {r0, r1}
	add r3, sp, #0
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	add r1, r2, #0
	str r0, [r3]
	add r0, r4, #0
	bl ov02_0224A418
	mov r1, #0x79
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	add r1, sp, #0
	bl ov02_0224A9B8
	mov r1, #0x7a
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	mov r1, #1
	bl ov02_0224A9D8
	add r0, r4, #0
	bl ov02_02249D40
	mov r0, #1
	str r0, [r4, #0x10]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02249A54: .word ov02_022533FC
_02249A58: .word ov02_02253414
	thumb_func_end ov02_022499EC

	thumb_func_start ov02_02249A5C
ov02_02249A5C: ; 0x02249A5C
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	mov r3, #0x85
	add r4, r0, #0
	lsl r3, r3, #2
	ldr r0, [r4, r3]
	cmp r0, #0
	bne _02249A72
	add sp, #0xc
	mov r0, #0
	pop {r3, r4, r5, r6, pc}
_02249A72:
	ldr r6, _02249AC0 ; =ov02_02253348
	add r5, sp, #0
	ldmia r6!, {r0, r1}
	add r2, r5, #0
	stmia r5!, {r0, r1}
	ldr r0, [r6]
	str r0, [r5]
	add r0, r3, #0
	add r0, #0xd8
	ldr r1, [sp]
	ldr r0, [r4, r0]
	add r3, #0xe0
	add r0, r1, r0
	str r0, [sp]
	ldr r1, [sp, #4]
	ldr r0, [r4, r3]
	add r0, r1, r0
	str r0, [sp, #4]
	add r0, r4, #0
	add r1, r2, #0
	bl ov02_0224A418
	mov r1, #0x79
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	mov r1, #1
	bl Sprite_SetAnimCtrlSeq
	add r0, r4, #0
	bl ov02_02249D40
	mov r0, #1
	str r0, [r4, #0x10]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_02249AC0: .word ov02_02253348
	thumb_func_end ov02_02249A5C

	thumb_func_start ov02_02249AC4
ov02_02249AC4: ; 0x02249AC4
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224A8D4
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249AC4

	thumb_func_start ov02_02249AD8
ov02_02249AD8: ; 0x02249AD8
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224A4D0
	add r0, r4, #0
	bl ov02_02249D18
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov02_02249AD8

	thumb_func_start ov02_02249AF0
ov02_02249AF0: ; 0x02249AF0
	push {r4, lr}
	mov r1, #0x85
	add r4, r0, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	cmp r1, #0
	bne _02249B02
	mov r0, #0
	pop {r4, pc}
_02249B02:
	bl ov02_02249D40
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov02_02249AF0

	thumb_func_start ov02_02249B10
ov02_02249B10: ; 0x02249B10
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224AB58
	add r0, r4, #0
	bl ov02_0224AC38
	add r0, r4, #0
	bl ov02_0224A690
	add r0, r4, #0
	mov r1, #1
	bl ov02_0224B6B0
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249B10

	thumb_func_start ov02_02249B38
ov02_02249B38: ; 0x02249B38
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224AB8C
	cmp r0, #2
	beq _02249B48
	mov r0, #0
	pop {r4, pc}
_02249B48:
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249B38

	thumb_func_start ov02_02249B60
ov02_02249B60: ; 0x02249B60
	push {r3, lr}
	ldr r1, [r0, #8]
	add r1, r1, #1
	str r1, [r0, #8]
	cmp r1, #0x14
	blt _02249B7A
	mov r1, #0
	str r1, [r0, #8]
	ldr r1, [r0]
	add r1, r1, #1
	str r1, [r0]
	bl ov02_0224ADF0
_02249B7A:
	mov r0, #1
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_02249B60

	thumb_func_start ov02_02249B80
ov02_02249B80: ; 0x02249B80
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #8]
	add r1, r1, #1
	str r1, [r4, #8]
	cmp r1, #0x14
	blt _02249BA2
	mov r1, #0
	str r1, [r4, #8]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	bl ov02_0224AB58
	add r0, r4, #0
	bl ov02_0224ADF0
_02249BA2:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249B80

	thumb_func_start ov02_02249BA8
ov02_02249BA8: ; 0x02249BA8
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224AB8C
	cmp r0, #3
	beq _02249BB8
	mov r0, #0
	pop {r4, pc}
_02249BB8:
	ldr r0, _02249BD4 ; =SEQ_SE_DP_FW019
	bl PlaySE
	mov r0, #2
	lsl r0, r0, #0xa
	str r0, [r4, #0x54]
	mov r0, #2
	str r0, [r4, #0x14]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	pop {r4, pc}
	nop
_02249BD4: .word SEQ_SE_DP_FW019
	thumb_func_end ov02_02249BA8

	thumb_func_start ov02_02249BD8
ov02_02249BD8: ; 0x02249BD8
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r0, #0
	str r0, [r4, #0x2c]
	ldr r1, [r4, #0x4c]
	ldr r0, [r4, #0x54]
	add r0, r1, r0
	str r0, [r4, #0x4c]
	ldr r1, [r4, #0x50]
	ldr r0, [r4, #0x54]
	sub r0, r1, r0
	str r0, [r4, #0x50]
	mov r0, #2
	ldr r1, [r4, #0x54]
	lsl r0, r0, #0xa
	add r2, r1, r0
	lsl r1, r0, #5
	str r2, [r4, #0x54]
	cmp r2, r1
	ble _02249C06
	lsl r0, r0, #5
	str r0, [r4, #0x54]
_02249C06:
	mov r0, #0x5f
	ldr r1, [r4, #0x4c]
	lsl r0, r0, #0xc
	cmp r1, r0
	blt _02249C12
	str r0, [r4, #0x4c]
_02249C12:
	mov r0, #0x61
	ldr r1, [r4, #0x50]
	lsl r0, r0, #0xc
	cmp r1, r0
	bgt _02249C1E
	str r0, [r4, #0x50]
_02249C1E:
	ldr r0, [r4, #0x50]
	str r0, [sp]
	ldr r1, [r4, #0x44]
	ldr r2, [r4, #0x4c]
	ldr r3, [r4, #0x48]
	add r0, r4, #0
	bl ov02_0224A69C
	mov r0, #1
	str r0, [r4, #0x2c]
	ldr r0, [r4, #0x18]
	cmp r0, #0
	bne _02249C4A
	add r0, r4, #0
	bl ov02_0224AB8C
	cmp r0, #4
	bne _02249C4A
	mov r0, #1
	str r0, [r4, #0x18]
	bl ov02_02249420
_02249C4A:
	mov r0, #0x5f
	ldr r1, [r4, #0x4c]
	lsl r0, r0, #0xc
	cmp r1, r0
	bne _02249C6C
	mov r0, #0x61
	ldr r1, [r4, #0x50]
	lsl r0, r0, #0xc
	cmp r1, r0
	bne _02249C6C
	mov r0, #0x11
	str r0, [r4, #0x34]
	mov r0, #1
	str r0, [r4, #0x14]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_02249C6C:
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249BD8

	thumb_func_start ov02_02249C74
ov02_02249C74: ; 0x02249C74
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x20]
	cmp r1, #3
	bne _02249C96
	bl ov02_0224AB8C
	cmp r0, #2
	bne _02249C92
	add r0, r4, #0
	bl ov02_0224AB9C
	ldr r0, [r4]
	add r0, r0, #2
	str r0, [r4]
_02249C92:
	mov r0, #0
	pop {r4, pc}
_02249C96:
	ldr r1, [r4, #0x18]
	cmp r1, #0
	bne _02249CAC
	bl ov02_0224AB8C
	cmp r0, #4
	bne _02249CAC
	mov r0, #1
	str r0, [r4, #0x18]
	bl ov02_02249420
_02249CAC:
	add r0, r4, #0
	bl ov02_0224AB8C
	cmp r0, #2
	beq _02249CBA
	mov r0, #0
	pop {r4, pc}
_02249CBA:
	ldr r0, [r4, #0x18]
	cmp r0, #0
	bne _02249CC8
	mov r0, #1
	str r0, [r4, #0x18]
	bl ov02_02249420
_02249CC8:
	add r0, r4, #0
	bl ov02_0224AB9C
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov02_02249C74

	thumb_func_start ov02_02249CD8
ov02_02249CD8: ; 0x02249CD8
	push {r4, lr}
	add r4, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #0
	beq _02249CEA
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_02249CEA:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_02249CD8

	thumb_func_start ov02_02249CF0
ov02_02249CF0: ; 0x02249CF0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x21
	mov r1, #0
	lsl r0, r0, #4
	str r1, [r4, r0]
	add r0, r0, #4
	str r1, [r4, r0]
	ldr r0, _02249D14 ; =ov02_02249D5C
	add r1, r4, #0
	mov r2, #0x80
	bl SysTask_CreateOnVBlankQueue
	mov r1, #0x22
	lsl r1, r1, #4
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_02249D14: .word ov02_02249D5C
	thumb_func_end ov02_02249CF0

	thumb_func_start ov02_02249D18
ov02_02249D18: ; 0x02249D18
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x21
	mov r1, #0
	lsl r0, r0, #4
	str r1, [r4, r0]
	add r0, r0, #4
	str r1, [r4, r0]
	ldr r0, _02249D3C ; =ov02_02249E58
	add r1, r4, #0
	mov r2, #0x80
	bl SysTask_CreateOnVBlankQueue
	mov r1, #0x22
	lsl r1, r1, #4
	str r0, [r4, r1]
	pop {r4, pc}
	nop
_02249D3C: .word ov02_02249E58
	thumb_func_end ov02_02249D18

	thumb_func_start ov02_02249D40
ov02_02249D40: ; 0x02249D40
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x22
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _02249D5A
	bl SysTask_Destroy
	mov r0, #0x22
	mov r1, #0
	lsl r0, r0, #4
	str r1, [r4, r0]
_02249D5A:
	pop {r4, pc}
	thumb_func_end ov02_02249D40

	thumb_func_start ov02_02249D5C
ov02_02249D5C: ; 0x02249D5C
	push {r3, r4, r5, r6, r7, lr}
	mov r0, #0x21
	add r6, r1, #0
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	cmp r0, #0
	bne _02249DD2
	mov r7, #0x6b
	mov r4, #0
	add r5, r6, #0
	lsl r7, r7, #2
_02249D72:
	ldr r0, [r5, r7]
	cmp r0, #0
	beq _02249D7C
	bl SpriteTransfer_CreateCharTransferTask_AllocAtEnd
_02249D7C:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _02249D72
	mov r7, #0x6f
	mov r5, #0
	add r4, r6, #0
	lsl r7, r7, #2
_02249D8C:
	ldr r0, [r4, r7]
	cmp r0, #0
	beq _02249D96
	bl SpriteTransfer_CreatePlttTransferTask
_02249D96:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #3
	blt _02249D8C
	mov r0, #0x86
	lsl r0, r0, #2
	ldr r1, [r6, r0]
	cmp r1, #0
	beq _02249DAE
	add r0, r6, #0
	bl ov02_0224A834
_02249DAE:
	mov r0, #0x87
	lsl r0, r0, #2
	ldr r1, [r6, r0]
	cmp r1, #0
	beq _02249DBE
	add r0, r6, #0
	bl ov02_0224A88C
_02249DBE:
	mov r0, #0x21
	lsl r0, r0, #4
	ldr r1, [r6, r0]
	mov r2, #0x80
	add r1, r1, #1
	str r1, [r6, r0]
	ldr r0, _02249DD4 ; =ov02_02249DD8
	add r1, r6, #0
	bl SysTask_CreateOnVWaitQueue
_02249DD2:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02249DD4: .word ov02_02249DD8
	thumb_func_end ov02_02249D5C

	thumb_func_start ov02_02249DD8
ov02_02249DD8: ; 0x02249DD8
	push {r3, r4, r5, r6, r7, lr}
	str r0, [sp]
	mov r0, #0x21
	add r6, r1, #0
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	cmp r0, #1
	bne _02249E56
	mov r7, #0x6b
	mov r4, #0
	add r5, r6, #0
	lsl r7, r7, #2
_02249DF0:
	ldr r0, [r5, r7]
	cmp r0, #0
	beq _02249DFA
	bl sub_0200A740
_02249DFA:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _02249DF0
	mov r7, #0x6f
	mov r5, #0
	add r4, r6, #0
	lsl r7, r7, #2
_02249E0A:
	ldr r0, [r4, r7]
	cmp r0, #0
	beq _02249E14
	bl sub_0200A740
_02249E14:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #3
	blt _02249E0A
	mov r0, #0x86
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	cmp r0, #0
	beq _02249E32
	bl Heap_Free
	mov r0, #0x86
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r6, r0]
_02249E32:
	mov r0, #0x87
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	cmp r0, #0
	beq _02249E48
	bl Heap_Free
	mov r0, #0x87
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r6, r0]
_02249E48:
	mov r0, #0x85
	mov r1, #1
	lsl r0, r0, #2
	str r1, [r6, r0]
	ldr r0, [sp]
	bl SysTask_Destroy
_02249E56:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_02249DD8

	thumb_func_start ov02_02249E58
ov02_02249E58: ; 0x02249E58
	push {r4, lr}
	mov r0, #0x67
	add r4, r1, #0
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl SpriteResourceCollection_Find
	mov r1, #0x21
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	cmp r1, #0
	bne _02249E8A
	bl SpriteTransfer_CreateCharTransferTask_AllocAtEnd
	ldr r0, _02249E8C ; =ov02_02249E90
	add r1, r4, #0
	mov r2, #0x80
	bl SysTask_CreateOnVWaitQueue
	mov r0, #0x21
	lsl r0, r0, #4
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
_02249E8A:
	pop {r4, pc}
	.balign 4, 0
_02249E8C: .word ov02_02249E90
	thumb_func_end ov02_02249E58

	thumb_func_start ov02_02249E90
ov02_02249E90: ; 0x02249E90
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x67
	add r4, r1, #0
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #0
	bl SpriteResourceCollection_Find
	mov r1, #0x21
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	cmp r1, #1
	bne _02249EBE
	bl sub_0200A740
	mov r0, #0x85
	mov r1, #1
	lsl r0, r0, #2
	str r1, [r4, r0]
	add r0, r5, #0
	bl SysTask_Destroy
_02249EBE:
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_02249E90

	thumb_func_start ov02_02249EC0
ov02_02249EC0: ; 0x02249EC0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov02_0224A074
	mov r2, #3
	mov r3, #1
	add r4, r0, #0
	lsl r2, r2, #0x12
	add r0, r5, #0
	mov r1, #0
	lsl r3, r3, #0xc
	str r2, [sp]
	bl ov02_0224A69C
	add r0, r5, #0
	bl ov02_0224A648
	ldr r0, [r5, #0x60]
	mov r1, #0
	ldr r0, [r0, #8]
	bl GetBgPriority
	strh r0, [r5, #0x24]
	ldr r0, [r5, #0x60]
	mov r1, #3
	ldr r0, [r0, #8]
	bl GetBgPriority
	strh r0, [r5, #0x26]
	ldr r2, _02249F68 ; =0x0400000A
	mov r1, #3
	ldrh r3, [r2]
	mov r0, #1
	bic r3, r1
	orr r0, r3
	strh r0, [r2]
	ldrh r0, [r2, #4]
	bic r0, r1
	strh r0, [r2, #4]
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r2, r5, #0
	add r0, r4, #0
#ifdef HEARTGOLD
	mov r1, #2
#else
	mov r1, #5
#endif
	add r2, #0x6c
	bl ov02_0224A570
	ldr r0, [r5, #0x60]
	add r3, r5, #0
	ldr r0, [r0, #8]
	add r1, r4, #0
#ifdef HEARTGOLD
	mov r2, #0
#else
	mov r2, #3
#endif
	add r3, #0x68
	bl ov02_0224A598
	ldr r0, [r5, #0x60]
	add r3, r5, #0
	ldr r0, [r0, #8]
	add r1, r4, #0
#ifdef HEARTGOLD
	mov r2, #1
#else
	mov r2, #4
#endif
	add r3, #0x64
	bl ov02_0224A5D0
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224A080
	add r0, r4, #0
	bl NARC_Delete
	mov r0, #4
	mov r1, #0x20
	bl sub_020689C8
	mov r1, #0x1e
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02249F68: .word 0x0400000A
	thumb_func_end ov02_02249EC0

	thumb_func_start ov02_02249F6C
ov02_02249F6C: ; 0x02249F6C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov02_0224A074
	add r4, r0, #0
	ldr r0, [r5, #0x60]
	mov r1, #0
	ldr r0, [r0, #8]
	bl GetBgPriority
	strh r0, [r5, #0x24]
	ldr r0, [r5, #0x60]
	mov r1, #3
	ldr r0, [r0, #8]
	bl GetBgPriority
	strh r0, [r5, #0x26]
	ldr r2, _02249FD0 ; =0x0400000A
	mov r1, #3
	ldrh r3, [r2]
	mov r0, #1
	bic r3, r1
	orr r0, r3
	strh r0, [r2]
	ldrh r0, [r2, #4]
	bic r0, r1
	strh r0, [r2, #4]
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224A080
	add r0, r4, #0
	bl NARC_Delete
	mov r0, #4
	mov r1, #0x20
	bl sub_020689C8
	mov r1, #0x1e
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02249FD0: .word 0x0400000A
	thumb_func_end ov02_02249F6C

	thumb_func_start ov02_02249FD4
ov02_02249FD4: ; 0x02249FD4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl sub_020689F8
	ldr r0, [r4, #0x60]
	ldr r0, [r0, #8]
	bl ov02_0224A63C
	add r0, r4, #0
	bl ov02_0224A288
	ldr r2, _0224A024 ; =0x04000008
	ldrh r1, [r4, #0x24]
	ldrh r3, [r2]
	mov r0, #3
	bic r3, r0
	orr r1, r3
	strh r1, [r2]
	ldrh r1, [r2, #6]
	bic r1, r0
	ldrh r0, [r4, #0x26]
	orr r0, r1
	strh r0, [r2, #6]
	mov r0, #0
	mov r1, #1
	bl FieldMessage_LoadTextPalettes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	pop {r4, pc}
	nop
_0224A024: .word 0x04000008
	thumb_func_end ov02_02249FD4

	thumb_func_start ov02_0224A028
ov02_0224A028: ; 0x0224A028
	push {r4, lr}
	add r4, r0, #0
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl sub_020689F8
	add r0, r4, #0
	bl ov02_0224A288
	ldr r2, _0224A070 ; =0x04000008
	ldrh r1, [r4, #0x24]
	ldrh r3, [r2]
	mov r0, #3
	bic r3, r0
	orr r1, r3
	strh r1, [r2]
	ldrh r1, [r2, #6]
	bic r1, r0
	ldrh r0, [r4, #0x26]
	orr r0, r1
	strh r0, [r2, #6]
	mov r0, #0
	mov r1, #1
	bl FieldMessage_LoadTextPalettes
	mov r0, #8
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	pop {r4, pc}
	nop
_0224A070: .word 0x04000008
	thumb_func_end ov02_0224A028

	thumb_func_start ov02_0224A074
ov02_0224A074: ; 0x0224A074
	ldr r3, _0224A07C ; =NARC_New
	mov r0, #0x5d
	mov r1, #4
	bx r3
	.balign 4, 0
_0224A07C: .word NARC_New
	thumb_func_end ov02_0224A074

	thumb_func_start ov02_0224A080
ov02_0224A080: ; 0x0224A080
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r1, #0
	mov r1, #0x7e
	add r5, r0, #0
	lsl r1, r1, #2
	add r1, r5, r1
	bl ov02_0224A7A8
	add r1, r5, #0
	mov r0, #0x20
	add r1, #0x74
	mov r2, #4
	bl G2dRenderer_Init
	str r0, [r5, #0x70]
	add r0, r5, #0
	mov r2, #2
	add r0, #0x74
	mov r1, #0
	lsl r2, r2, #0x14
	bl G2dRenderer_SetSubSurfaceCoords
	mov r0, #4
	mov r1, #0
	add r2, r0, #0
	bl Create2DGfxResObjMan
	mov r1, #0x67
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #3
	mov r1, #1
	mov r2, #4
	bl Create2DGfxResObjMan
	mov r1, #0x1a
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r0, #4
	mov r1, #2
	add r2, r0, #0
	bl Create2DGfxResObjMan
	mov r1, #0x69
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #2
	mov r1, #3
	mov r2, #4
	bl Create2DGfxResObjMan
	mov r1, #0x6a
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #4
	sub r1, #0xc
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r6, #0
	mov r2, #0xe
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	mov r1, #0x6b
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldrh r2, [r5, #0xe]
	sub r1, #0x10
	ldr r0, [r5, r1]
	lsl r3, r2, #1
	ldr r2, _0224A278 ; =ov02_02253304
	add r1, r6, #0
	ldrh r2, [r2, r3]
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	mov r1, #0x1b
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r5, #0
	add r1, r6, #0
	bl ov02_0224A810
	mov r1, #0x6d
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r4, #0
	str r4, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #4
	sub r1, #0x14
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r6, #0
	mov r2, #6
	add r3, r4, #0
	bl AddPlttResObjFromOpenNarc
	mov r1, #0x6f
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldrh r2, [r5, #0xe]
	add r4, r4, #1
	cmp r2, #0
	beq _0224A196
	mov r0, #1
	sub r2, r2, #1
	str r0, [sp]
	lsl r3, r2, #1
	ldr r2, _0224A27C ; =ov02_022532FC
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #4
	ldrh r2, [r2, r3]
	sub r1, #0x1c
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r6, #0
	mov r3, #0
	bl AddPlttResObjFromOpenNarc
	lsl r1, r4, #2
	add r2, r5, r1
	mov r1, #0x6f
	lsl r1, r1, #2
	str r0, [r2, r1]
	add r4, r4, #1
_0224A196:
	add r0, r5, #0
	add r1, r6, #0
	bl ov02_0224A868
	lsl r1, r4, #2
	add r2, r5, r1
	mov r1, #0x6f
	lsl r1, r1, #2
	str r0, [r2, r1]
	mov r0, #1
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #4
	sub r1, #0x18
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r6, #0
	mov r2, #0xf
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x72
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #2
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldrh r2, [r5, #0xe]
	sub r1, #0x24
	ldr r0, [r5, r1]
	lsl r3, r2, #1
	ldr r2, _0224A280 ; =ov02_02253310
	add r1, r6, #0
	ldrh r2, [r2, r3]
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x73
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #3
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #4
	sub r1, #0x28
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r6, #0
	mov r2, #0xa
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x1d
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r3, #0
	str r3, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #4
	sub r1, #0x28
	str r0, [sp, #8]
	ldr r0, [r5, r1]
	add r1, r6, #0
	mov r2, #0x10
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x76
	lsl r1, r1, #2
	str r0, [r5, r1]
	mov r0, #1
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldrh r2, [r5, #0xe]
	sub r1, #0x30
	ldr r0, [r5, r1]
	lsl r3, r2, #1
	ldr r2, _0224A284 ; =ov02_0225330A
	add r1, r6, #0
	ldrh r2, [r2, r3]
	mov r3, #0
	bl AddCellOrAnimResObjFromOpenNarc
	mov r1, #0x77
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r1, #0x1c
	ldr r0, [r5, #0x5c]
	add r1, r5, r1
	mov r2, #4
	bl ov02_0224A7B8
	mov r1, #0x86
	lsl r1, r1, #2
	str r0, [r5, r1]
	sub r1, #0x20
	add r0, r5, r1
	mov r1, #4
	bl ov02_0224A800
	mov r1, #0x87
	lsl r1, r1, #2
	str r0, [r5, r1]
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0224A278: .word ov02_02253304
_0224A27C: .word ov02_022532FC
_0224A280: .word ov02_02253310
_0224A284: .word ov02_0225330A
	thumb_func_end ov02_0224A080

	thumb_func_start ov02_0224A288
ov02_0224A288: ; 0x0224A288
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r7, #0x6b
	mov r4, #0
	add r5, r6, #0
	lsl r7, r7, #2
_0224A294:
	ldr r0, [r5, r7]
	cmp r0, #0
	beq _0224A29E
	bl SpriteTransfer_DeleteCharTransferTask
_0224A29E:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _0224A294
	mov r7, #0x6f
	mov r5, #0
	add r4, r6, #0
	lsl r7, r7, #2
_0224A2AE:
	ldr r0, [r4, r7]
	cmp r0, #0
	beq _0224A2B8
	bl SpriteTransfer_DeletePlttTransferTask
_0224A2B8:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #3
	blt _0224A2AE
	mov r7, #0x72
	mov r5, #0
	add r4, r6, #0
	lsl r7, r7, #2
_0224A2C8:
	ldr r0, [r4, r7]
	cmp r0, #0
	beq _0224A2D2
	bl sub_0200A740
_0224A2D2:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #4
	blt _0224A2C8
	mov r7, #0x76
	mov r5, #0
	add r4, r6, #0
	lsl r7, r7, #2
_0224A2E2:
	ldr r0, [r4, r7]
	cmp r0, #0
	beq _0224A2EC
	bl sub_0200A740
_0224A2EC:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #2
	blt _0224A2E2
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl Destroy2DGfxResObjMan
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	bl Destroy2DGfxResObjMan
	mov r0, #0x69
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl Destroy2DGfxResObjMan
	mov r0, #0x6a
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	bl Destroy2DGfxResObjMan
	ldr r0, [r6, #0x70]
	bl SpriteList_DeleteAllSprites
	ldr r0, [r6, #0x70]
	bl SpriteList_Delete
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A288

	thumb_func_start ov02_0224A32C
ov02_0224A32C: ; 0x0224A32C
	push {r3, lr}
	ldr r0, [r0, #0x70]
	cmp r0, #0
	beq _0224A338
	bl SpriteList_RenderAndAnimateSprites
_0224A338:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A32C

	thumb_func_start ov02_0224A33C
ov02_0224A33C: ; 0x0224A33C
	push {r4, r5, r6, lr}
	sub sp, #0x70
	add r5, r0, #0
	ldr r0, [sp, #0x84]
	add r4, r1, #0
	add r1, r2, #0
	add r2, r3, #0
	cmp r0, #4
	bne _0224A384
	mov r0, #0
	mvn r0, r0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0
	mov r6, #0x67
	ldr r3, [sp, #0x88]
	str r0, [sp, #0xc]
	lsl r6, r6, #2
	str r3, [sp, #0x10]
	ldr r3, [r5, r6]
	str r3, [sp, #0x14]
	add r3, r6, #4
	ldr r3, [r5, r3]
	add r6, #8
	str r3, [sp, #0x18]
	ldr r3, [r5, r6]
	str r3, [sp, #0x1c]
	str r0, [sp, #0x20]
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
	ldr r3, [sp, #0x80]
	add r0, sp, #0x4c
	bl CreateSpriteResourcesHeader
	b _0224A3BE
_0224A384:
	str r0, [sp]
	mov r0, #0
	mvn r0, r0
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r3, #0
	ldr r0, [sp, #0x88]
	str r3, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r6, [r5, r0]
	str r6, [sp, #0x14]
	add r6, r0, #4
	ldr r6, [r5, r6]
	str r6, [sp, #0x18]
	add r6, r0, #0
	add r6, #8
	ldr r6, [r5, r6]
	add r0, #0xc
	str r6, [sp, #0x1c]
	ldr r0, [r5, r0]
	str r0, [sp, #0x20]
	str r3, [sp, #0x24]
	str r3, [sp, #0x28]
	ldr r3, [sp, #0x80]
	add r0, sp, #0x4c
	bl CreateSpriteResourcesHeader
_0224A3BE:
	ldr r0, [r5, #0x70]
	add r2, sp, #0x34
	str r0, [sp, #0x2c]
	add r0, sp, #0x4c
	str r0, [sp, #0x30]
	ldmia r4!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r4]
	str r0, [r2]
	ldr r0, [sp, #0x8c]
	str r0, [sp, #0x40]
	mov r0, #1
	str r0, [sp, #0x44]
	mov r0, #4
	str r0, [sp, #0x48]
	add r0, sp, #0x2c
	bl Sprite_Create
	add r4, r0, #0
	bne _0224A3EA
	bl GF_AssertFail
_0224A3EA:
	add r0, r4, #0
	add sp, #0x70
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_0224A33C

	thumb_func_start ov02_0224A3F0
ov02_0224A3F0: ; 0x0224A3F0
	push {r3, r4, r5, lr}
	sub sp, #0x10
	mov r5, #1
	add r4, r3, #0
	str r5, [sp]
	mov r3, #0
	str r3, [sp, #4]
	str r3, [sp, #8]
	str r2, [sp, #0xc]
	add r2, r5, #0
	bl ov02_0224A33C
	add r1, r4, #0
	add r5, r0, #0
	bl Sprite_SetAnimCtrlSeq
	add r0, r5, #0
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A3F0

	thumb_func_start ov02_0224A418
ov02_0224A418: ; 0x0224A418
	push {r4, lr}
	sub sp, #0x10
	ldrh r2, [r0, #0xe]
	mov r3, #0
	cmp r2, #0
	beq _0224A426
	mov r3, #1
_0224A426:
	mov r2, #2
	str r2, [sp]
	mov r4, #1
	str r4, [sp, #4]
	mov r4, #0
	str r4, [sp, #8]
	mov r4, #0x83
	str r4, [sp, #0xc]
	bl ov02_0224A33C
	add r4, r0, #0
	mov r1, #0
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #6
	bl Sprite_SetAnimCtrlSeq
	add r0, r4, #0
	add sp, #0x10
	pop {r4, pc}
	thumb_func_end ov02_0224A418

	thumb_func_start ov02_0224A450
ov02_0224A450: ; 0x0224A450
	push {r4, lr}
	mov r1, #1
	add r4, r0, #0
	bl Sprite_SetAnimActiveFlag
	mov r1, #1
	add r0, r4, #0
	lsl r1, r1, #0xc
	bl Sprite_SetAnimSpeed
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A450

	thumb_func_start ov02_0224A468
ov02_0224A468: ; 0x0224A468
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r4, r0, #0
	add r0, sp, #0x1c
	mov r7, #0
	str r7, [r0]
	str r7, [r0, #4]
	add r6, r2, #0
	ldr r5, _0224A4CC ; =ov02_02253390
	add r3, r1, #0
	str r7, [r0, #8]
	ldmia r5!, {r0, r1}
	add r2, sp, #0x10
	stmia r2!, {r0, r1}
	ldr r0, [r5]
	add r1, r3, #0
	str r0, [r2]
	str r7, [sp]
	sub r0, r7, #1
	str r0, [sp, #4]
	str r7, [sp, #8]
	add r0, r4, #0
	add r2, r7, #0
	add r3, r7, #0
	str r6, [sp, #0xc]
	bl ov02_0224A33C
	add r4, r0, #0
	mov r1, #2
	bl Sprite_SetAffineOverwriteMode
	add r0, r4, #0
	add r1, sp, #0x1c
	bl Sprite_SetAffineMatrix
	add r0, r4, #0
	add r1, sp, #0x10
	bl Sprite_SetAffineScale
	add r0, r7, #0
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	add r0, r4, #0
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224A4CC: .word ov02_02253390
	thumb_func_end ov02_0224A468

	thumb_func_start ov02_0224A4D0
ov02_0224A4D0: ; 0x0224A4D0
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r4, r0, #0
	bl ov02_0224A074
	add r6, r0, #0
	mov r0, #0x6b
	mov r5, #0
	add r2, r4, #0
	lsl r0, r0, #2
_0224A4E4:
	ldr r1, [r2, r0]
	cmp r1, #0
	bne _0224A510
	mov r3, #0
	str r3, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, r6, #0
	mov r2, #0xb
	bl AddCharResObjFromOpenNarc
	lsl r1, r5, #2
	add r2, r4, r1
	mov r1, #0x6b
	lsl r1, r1, #2
	str r0, [r2, r1]
	b _0224A518
_0224A510:
	add r5, r5, #1
	add r2, r2, #4
	cmp r5, #4
	blt _0224A4E4
_0224A518:
	cmp r5, #4
	blt _0224A520
	bl GF_AssertFail
_0224A520:
	mov r0, #0x72
	mov r5, #0
	add r2, r4, #0
	lsl r0, r0, #2
_0224A528:
	ldr r1, [r2, r0]
	cmp r1, #0
	bne _0224A554
	mov r3, #0
	str r3, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0x69
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, r6, #0
	mov r2, #0xc
	bl AddCellOrAnimResObjFromOpenNarc
	lsl r1, r5, #2
	add r2, r4, r1
	mov r1, #0x72
	lsl r1, r1, #2
	str r0, [r2, r1]
	b _0224A55C
_0224A554:
	add r5, r5, #1
	add r2, r2, #4
	cmp r5, #4
	blt _0224A528
_0224A55C:
	cmp r5, #4
	blt _0224A564
	bl GF_AssertFail
_0224A564:
	add r0, r6, #0
	bl NARC_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A4D0

	thumb_func_start ov02_0224A570
ov02_0224A570: ; 0x0224A570
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r2, #4
	bl NARC_AllocAndReadWholeMember
	add r1, r5, #0
	add r4, r0, #0
	bl NNS_G2dGetUnpackedPaletteData
	ldr r1, [r5]
	mov r0, #3
	ldr r1, [r1, #0xc]
	mov r2, #0x20
	lsl r3, r0, #7
	bl BG_LoadPlttData
	add r0, r4, #0
	bl Heap_Free
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224A570

	thumb_func_start ov02_0224A598
ov02_0224A598: ; 0x0224A598
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	add r0, r1, #0
	add r1, r2, #0
	add r4, r3, #0
	mov r2, #4
	bl NARC_AllocAndReadWholeMember
	add r1, r4, #0
	add r6, r0, #0
	bl NNS_G2dGetUnpackedCharacterData
	ldr r3, [r4]
	mov r0, #0
	str r0, [sp]
	ldr r2, [r3, #0x14]
	ldr r3, [r3, #0x10]
	add r0, r5, #0
	mov r1, #3
	bl BG_LoadCharTilesData
	add r0, r6, #0
	bl Heap_Free
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A598

	thumb_func_start ov02_0224A5D0
ov02_0224A5D0: ; 0x0224A5D0
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r2, #0
	add r6, r1, #0
	mov r2, #0
	add r4, r3, #0
	mov r1, #3
	add r3, r2, #0
	add r5, r0, #0
	bl BgSetPosTextAndCommit
	mov r1, #3
	add r0, r5, #0
	add r2, r1, #0
	mov r3, #0
	bl BgSetPosTextAndCommit
	add r0, r6, #0
	add r1, r7, #0
	mov r2, #4
	bl NARC_AllocAndReadWholeMember
	add r1, r4, #0
	add r6, r0, #0
	bl NNS_G2dGetUnpackedScreenData
	ldr r3, [r4]
	add r0, r5, #0
	add r2, r3, #0
	ldr r3, [r3, #8]
	mov r1, #3
	add r2, #0xc
	bl BG_LoadScreenTilemapData
	mov r0, #0x20
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0xc
	mov r2, #0
	str r0, [sp, #8]
	add r0, r5, #0
	mov r1, #3
	add r3, r2, #0
	bl BgTilemapRectChangePalette
	add r0, r5, #0
	mov r1, #3
	bl BgCommitTilemapBufferToVram
	add r0, r6, #0
	bl Heap_Free
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224A5D0

	thumb_func_start ov02_0224A63C
ov02_0224A63C: ; 0x0224A63C
	ldr r3, _0224A644 ; =BgClearTilemapBufferAndCommit
	mov r1, #3
	bx r3
	nop
_0224A644: .word BgClearTilemapBufferAndCommit
	thumb_func_end ov02_0224A63C

	thumb_func_start ov02_0224A648
ov02_0224A648: ; 0x0224A648
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224A6A8
	mov r0, #0
	str r0, [r4, #0x2c]
	add r0, r4, #0
	bl ov02_0224A674
	add r0, r4, #0
	bl ov02_0224A67C
	add r0, r4, #0
	bl ov02_0224A66C
	mov r0, #1
	str r0, [r4, #0x2c]
	pop {r4, pc}
	thumb_func_end ov02_0224A648

	thumb_func_start ov02_0224A66C
ov02_0224A66C: ; 0x0224A66C
	mov r1, #1
	str r1, [r0, #0x30]
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224A66C

	thumb_func_start ov02_0224A674
ov02_0224A674: ; 0x0224A674
	mov r1, #0
	str r1, [r0, #0x30]
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224A674

	thumb_func_start ov02_0224A67C
ov02_0224A67C: ; 0x0224A67C
	mov r1, #0x18
	str r1, [r0, #0x34]
	mov r1, #0
	str r1, [r0, #0x38]
	mov r1, #0x17
	str r1, [r0, #0x3c]
	mov r1, #1
	str r1, [r0, #0x40]
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224A67C

	thumb_func_start ov02_0224A690
ov02_0224A690: ; 0x0224A690
	mov r1, #0x17
	str r1, [r0, #0x3c]
	mov r1, #1
	str r1, [r0, #0x40]
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224A690

	thumb_func_start ov02_0224A69C
ov02_0224A69C: ; 0x0224A69C
	str r1, [r0, #0x44]
	str r3, [r0, #0x48]
	ldr r1, [sp]
	str r2, [r0, #0x4c]
	str r1, [r0, #0x50]
	bx lr
	thumb_func_end ov02_0224A69C

	thumb_func_start ov02_0224A6A8
ov02_0224A6A8: ; 0x0224A6A8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0224A6BA
	bl GF_AssertFail
_0224A6BA:
	ldr r0, _0224A6CC ; =ov02_0224A700
	add r1, r4, #0
	mov r2, #0x81
	bl SysTask_CreateOnVBlankQueue
	mov r1, #0x89
	lsl r1, r1, #2
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_0224A6CC: .word ov02_0224A700
	thumb_func_end ov02_0224A6A8

	thumb_func_start ov02_0224A6D0
ov02_0224A6D0: ; 0x0224A6D0
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	bne _0224A6E2
	bl GF_AssertFail
_0224A6E2:
	mov r0, #0x89
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl SysTask_Destroy
	mov r2, #1
	lsl r2, r2, #0x1a
	ldr r1, [r2]
	ldr r0, _0224A6FC ; =0xFFFF1FFF
	and r0, r1
	str r0, [r2]
	pop {r4, pc}
	nop
_0224A6FC: .word 0xFFFF1FFF
	thumb_func_end ov02_0224A6D0

	thumb_func_start ov02_0224A700
ov02_0224A700: ; 0x0224A700
	push {r3, r4, r5, r6}
	ldr r0, [r1, #0x2c]
	cmp r0, #0
	beq _0224A796
	mov r3, #1
	lsl r3, r3, #0x1a
	ldr r2, [r3]
	ldr r0, _0224A79C ; =0xFFFF1FFF
	and r2, r0
	ldr r0, [r1, #0x30]
	lsl r0, r0, #0xd
	orr r0, r2
	str r0, [r3]
	add r3, #0x48
	ldrh r2, [r3]
	mov r0, #0x3f
	bic r2, r0
	ldr r0, [r1, #0x34]
	orr r2, r0
	ldr r0, [r1, #0x38]
	cmp r0, #0
	beq _0224A730
	mov r0, #0x20
	orr r2, r0
_0224A730:
	ldr r0, _0224A7A0 ; =0x04000048
	strh r2, [r0]
	ldrh r2, [r0, #2]
	mov r0, #0x3f
	bic r2, r0
	ldr r0, [r1, #0x3c]
	orr r2, r0
	ldr r0, [r1, #0x40]
	cmp r0, #0
	beq _0224A748
	mov r0, #0x20
	orr r2, r0
_0224A748:
	ldr r5, _0224A7A4 ; =0x0400004A
	strh r2, [r5]
	ldr r2, [r1, #0x50]
	ldr r6, [r1, #0x48]
	asr r0, r2, #0xb
	lsr r0, r0, #0x14
	add r0, r2, r0
	ldr r2, [r1, #0x4c]
	asr r4, r0, #0xc
	asr r0, r2, #0xb
	lsr r0, r0, #0x14
	add r0, r2, r0
	ldr r2, [r1, #0x44]
	asr r3, r0, #0xc
	asr r0, r2, #0xb
	lsr r0, r0, #0x14
	asr r1, r6, #0xb
	add r0, r2, r0
	lsr r1, r1, #0x14
	asr r0, r0, #0xc
	add r1, r6, r1
	lsl r2, r0, #8
	mov r0, #0xff
	asr r1, r1, #0xc
	lsl r0, r0, #8
	lsl r1, r1, #0x18
	and r2, r0
	lsr r1, r1, #0x18
	orr r2, r1
	add r1, r5, #0
	sub r1, #0xa
	strh r2, [r1]
	lsl r1, r3, #8
	and r1, r0
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	orr r1, r0
	sub r0, r5, #6
	strh r1, [r0]
_0224A796:
	pop {r3, r4, r5, r6}
	bx lr
	nop
_0224A79C: .word 0xFFFF1FFF
_0224A7A0: .word 0x04000048
_0224A7A4: .word 0x0400004A
	thumb_func_end ov02_0224A700

	thumb_func_start ov02_0224A7A8
ov02_0224A7A8: ; 0x0224A7A8
	ldr r3, _0224A7B4 ; =GetPokemonSpriteCharAndPlttNarcIds
	add r2, r0, #0
	add r0, r1, #0
	ldr r1, [r2, #0x5c]
	mov r2, #2
	bx r3
	.balign 4, 0
_0224A7B4: .word GetPokemonSpriteCharAndPlttNarcIds
	thumb_func_end ov02_0224A7A8

	thumb_func_start ov02_0224A7B8
ov02_0224A7B8: ; 0x0224A7B8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r1, #0
	mov r1, #0x32
	add r6, r0, #0
	mov r0, #4
	lsl r1, r1, #6
	add r7, r2, #0
	bl Heap_Alloc
	add r4, r0, #0
	bne _0224A7D4
	bl GF_AssertFail
_0224A7D4:
	mov r1, #0
	add r0, r6, #0
	add r2, r1, #0
	bl GetMonData
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	ldrh r0, [r5, #6]
	add r2, r7, #0
	add r3, r4, #0
	str r0, [sp, #0xc]
	ldrh r0, [r5]
	ldrh r1, [r5, #2]
	bl sub_02014540
	add r0, r4, #0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A7B8

	thumb_func_start ov02_0224A800
ov02_0224A800: ; 0x0224A800
	add r3, r0, #0
	add r2, r1, #0
	ldrh r0, [r3]
	ldrh r1, [r3, #4]
	ldr r3, _0224A80C ; =sub_02014450
	bx r3
	.balign 4, 0
_0224A80C: .word sub_02014450
	thumb_func_end ov02_0224A800

	thumb_func_start ov02_0224A810
ov02_0224A810: ; 0x0224A810
	push {lr}
	sub sp, #0xc
	mov r2, #3
	str r2, [sp]
	mov r2, #1
	str r2, [sp, #4]
	mov r2, #4
	str r2, [sp, #8]
	mov r2, #0x67
	lsl r2, r2, #2
	ldr r0, [r0, r2]
	mov r2, #9
	mov r3, #0
	bl AddCharResObjFromOpenNarc
	add sp, #0xc
	pop {pc}
	.balign 4, 0
	thumb_func_end ov02_0224A810

	thumb_func_start ov02_0224A834
ov02_0224A834: ; 0x0224A834
	push {r3, r4, r5, lr}
	add r4, r1, #0
	mov r1, #0x67
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	mov r1, #3
	bl SpriteResourceCollection_Find
	bl SpriteTransfer_GetCharProxy
	mov r1, #1
	bl NNS_G2dGetImageLocation
	mov r1, #0x32
	add r5, r0, #0
	add r0, r4, #0
	lsl r1, r1, #6
	bl DC_FlushRange
	mov r2, #0x32
	add r0, r4, #0
	add r1, r5, #0
	lsl r2, r2, #6
	bl GX_LoadOBJ
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224A834

	thumb_func_start ov02_0224A868
ov02_0224A868: ; 0x0224A868
	push {r3, lr}
	sub sp, #0x10
	mov r2, #3
	str r2, [sp]
	mov r2, #1
	str r2, [sp, #4]
	str r2, [sp, #8]
	mov r2, #4
	str r2, [sp, #0xc]
	mov r2, #0x1a
	lsl r2, r2, #4
	ldr r0, [r0, r2]
	mov r2, #6
	mov r3, #0
	bl AddPlttResObjFromOpenNarc
	add sp, #0x10
	pop {r3, pc}
	thumb_func_end ov02_0224A868

	thumb_func_start ov02_0224A88C
ov02_0224A88C: ; 0x0224A88C
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x67
	lsl r0, r0, #2
	add r4, r1, #0
	ldr r0, [r5, r0]
	mov r1, #3
	bl SpriteResourceCollection_Find
	bl SpriteTransfer_GetCharProxy
	add r6, r0, #0
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #3
	bl SpriteResourceCollection_Find
	add r1, r6, #0
	bl SpriteTransfer_GetPaletteProxy
	mov r1, #1
	bl NNS_G2dGetImagePaletteLocation
	add r5, r0, #0
	add r0, r4, #0
	mov r1, #0x20
	bl DC_FlushRange
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0x20
	bl GX_LoadOBJPltt
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A88C

	thumb_func_start ov02_0224A8D4
ov02_0224A8D4: ; 0x0224A8D4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #3
	bl SpriteResourceCollection_Find
	add r4, r0, #0
	bl SpriteTransfer_DeleteCharTransferTask
	mov r0, #0x67
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl DestroySingle2DGfxResObj
	mov r1, #0x6b
	mov r0, #0
	add r3, r5, #0
	lsl r1, r1, #2
_0224A8FE:
	ldr r2, [r3, r1]
	cmp r2, r4
	bne _0224A912
	lsl r1, r0, #2
	add r2, r5, r1
	mov r1, #0x6b
	mov r3, #0
	lsl r1, r1, #2
	str r3, [r2, r1]
	b _0224A91A
_0224A912:
	add r0, r0, #1
	add r3, r3, #4
	cmp r0, #4
	blt _0224A8FE
_0224A91A:
	cmp r0, #4
	blt _0224A922
	bl GF_AssertFail
_0224A922:
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #3
	bl SpriteResourceCollection_Find
	add r4, r0, #0
	bl SpriteTransfer_DeletePlttTransferTask
	mov r0, #0x1a
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl DestroySingle2DGfxResObj
	mov r1, #0x6f
	mov r0, #0
	add r3, r5, #0
	lsl r1, r1, #2
_0224A948:
	ldr r2, [r3, r1]
	cmp r2, r4
	bne _0224A95C
	lsl r1, r0, #2
	add r2, r5, r1
	mov r1, #0x6f
	mov r3, #0
	lsl r1, r1, #2
	str r3, [r2, r1]
	b _0224A964
_0224A95C:
	add r0, r0, #1
	add r3, r3, #4
	cmp r0, #3
	blt _0224A948
_0224A964:
	cmp r0, #3
	blt _0224A96C
	bl GF_AssertFail
_0224A96C:
	mov r0, #0x69
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #3
	bl SpriteResourceCollection_Find
	add r4, r0, #0
	bl sub_0200A740
	mov r0, #0x69
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl DestroySingle2DGfxResObj
	mov r1, #0x72
	mov r0, #0
	add r3, r5, #0
	lsl r1, r1, #2
_0224A992:
	ldr r2, [r3, r1]
	cmp r2, r4
	bne _0224A9A6
	lsl r1, r0, #2
	add r2, r5, r1
	mov r1, #0x72
	mov r3, #0
	lsl r1, r1, #2
	str r3, [r2, r1]
	b _0224A9AE
_0224A9A6:
	add r0, r0, #1
	add r3, r3, #4
	cmp r0, #4
	blt _0224A992
_0224A9AE:
	cmp r0, #4
	blt _0224A9B6
	bl GF_AssertFail
_0224A9B6:
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224A8D4

	thumb_func_start ov02_0224A9B8
ov02_0224A9B8: ; 0x0224A9B8
	push {r3, lr}
	sub sp, #0x10
	mov r2, #3
	str r2, [sp]
	sub r3, r2, #4
	str r3, [sp, #4]
	mov r3, #0
	str r3, [sp, #8]
	mov r3, #0x81
	str r3, [sp, #0xc]
	add r3, r2, #0
	bl ov02_0224A33C
	add sp, #0x10
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224A9B8

	thumb_func_start ov02_0224A9D8
ov02_0224A9D8: ; 0x0224A9D8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r0, #0
	mov r0, #2
	ldr r4, _0224AA40 ; =ov02_022535E4
	add r6, r1, #0
	str r0, [r5, #0x14]
	mov r7, #0
_0224A9E8:
	ldr r0, [r4]
	add r1, sp, #0x1c
	str r0, [sp, #0x1c]
	ldr r0, [r4, #4]
	add r2, sp, #0x10
	str r0, [sp, #0x20]
	mov r0, #0
	str r0, [sp, #0x24]
	ldr r0, [r4, #8]
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0x14]
	str r0, [sp, #0x18]
	ldr r0, [r4, #0xc]
	str r0, [sp, #8]
	ldr r0, [r4, #0x10]
	ldr r3, [sp, #8]
	str r0, [sp]
	str r0, [sp, #0xc]
	str r6, [sp, #4]
	add r0, r5, #0
	bl ov02_0224AA44
	mov r0, #1
	ldr r1, [sp, #0x1c]
	lsl r0, r0, #0x14
	add r0, r1, r0
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0xc]
	ldr r3, [sp, #8]
	str r0, [sp]
	add r0, r5, #0
	add r1, sp, #0x1c
	add r2, sp, #0x10
	str r6, [sp, #4]
	bl ov02_0224AA44
	add r7, r7, #1
	add r4, #0x14
	cmp r7, #0xd
	blt _0224A9E8
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224AA40: .word ov02_022535E4
	thumb_func_end ov02_0224A9D8

	thumb_func_start ov02_0224AA44
ov02_0224AA44: ; 0x0224AA44
	push {r3, r4, r5, lr}
	sub sp, #0x20
	add r5, r0, #0
	ldr r0, [sp, #0x34]
	str r3, [sp, #8]
	str r5, [sp, #0x10]
	add r4, r1, #0
	str r0, [sp, #0xc]
	ldmia r2!, {r0, r1}
	add r3, sp, #0x14
	stmia r3!, {r0, r1}
	ldr r0, [r2]
	ldr r1, _0224AA7C ; =ov02_02253468
	str r0, [r3]
	add r0, sp, #8
	str r0, [sp]
	mov r0, #0x85
	str r0, [sp, #4]
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	ldr r3, [sp, #0x30]
	add r2, r4, #0
	bl sub_02068B0C
	add sp, #0x20
	pop {r3, r4, r5, pc}
	nop
_0224AA7C: .word ov02_02253468
	thumb_func_end ov02_0224AA44

	thumb_func_start ov02_0224AA80
ov02_0224AA80: ; 0x0224AA80
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r5, r0, #0
	bl sub_02068D98
	add r2, r4, #0
	add r3, r0, #0
	add r2, #0xc
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	add r0, r5, #0
	bl sub_02068D90
	str r0, [r4, #4]
	add r0, r5, #0
	add r1, sp, #0
	bl sub_02068DB8
	ldr r0, [r4, #0x14]
	ldr r2, [r4, #0xc]
	ldr r3, [r4, #4]
	add r1, sp, #0
	bl ov02_0224A3F0
	mov r1, #0
	str r0, [r4, #8]
	bl Sprite_SetDrawFlag
	mov r0, #1
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov02_0224AA80

	thumb_func_start ov02_0224AAC8
ov02_0224AAC8: ; 0x0224AAC8
	ldr r3, _0224AAD0 ; =Sprite_Delete
	ldr r0, [r1, #8]
	bx r3
	nop
_0224AAD0: .word Sprite_Delete
	thumb_func_end ov02_0224AAC8

	thumb_func_start ov02_0224AAD4
ov02_0224AAD4: ; 0x0224AAD4
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r1, sp, #0
	add r5, r0, #0
	bl sub_02068DB8
	ldr r1, [sp]
	ldr r0, [r4, #0x18]
	add r0, r1, r0
	lsr r2, r0, #0x1f
	lsl r1, r0, #0xb
	str r0, [sp]
	sub r1, r1, r2
	mov r0, #0xb
	ror r1, r0
	add r0, r2, r1
	str r0, [sp]
	add r0, r5, #0
	add r1, sp, #0
	bl sub_02068DA8
	ldr r0, [r4, #8]
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r0, [r4, #0x10]
	cmp r0, #1
	bne _0224AB4E
	ldr r3, [r4, #0x14]
	ldr r0, [r3, #0x14]
	cmp r0, #2
	bne _0224AB42
	ldr r2, [r3, #0x4c]
	ldr r0, [r3, #0x50]
	mov r3, #2
	ldr r6, [sp, #4]
	lsl r3, r3, #0xc
	sub r5, r6, r3
	mov r1, #0
	cmp r5, r2
	blt _0224AB38
	cmp r5, r0
	bgt _0224AB38
	add r3, r6, r3
	cmp r3, r2
	blt _0224AB38
	cmp r3, r0
	bgt _0224AB38
	mov r1, #1
_0224AB38:
	ldr r0, [r4, #8]
	bl Sprite_SetDrawFlag
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
_0224AB42:
	cmp r0, #1
	bne _0224AB4E
	ldr r0, [r4, #8]
	mov r1, #0
	bl Sprite_SetDrawFlag
_0224AB4E:
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224AAD4

	thumb_func_start ov02_0224AB54
ov02_0224AB54: ; 0x0224AB54
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224AB54

	thumb_func_start ov02_0224AB58
ov02_0224AB58: ; 0x0224AB58
	push {r4, lr}
	sub sp, #0x18
	add r2, sp, #0xc
	mov r3, #0
	add r4, r0, #0
	str r3, [r2]
	str r3, [r2, #4]
	str r3, [r2, #8]
	str r4, [sp, #8]
	add r0, sp, #8
	str r0, [sp]
	mov r0, #0x82
	str r0, [sp, #4]
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	ldr r1, _0224AB88 ; =ov02_0225347C
	bl sub_02068B0C
	mov r1, #0x7b
	lsl r1, r1, #2
	str r0, [r4, r1]
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_0224AB88: .word ov02_0225347C
	thumb_func_end ov02_0224AB58

	thumb_func_start ov02_0224AB8C
ov02_0224AB8C: ; 0x0224AB8C
	push {r3, lr}
	mov r1, #0x7b
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bl sub_02068D74
	ldrb r0, [r0, #2]
	pop {r3, pc}
	thumb_func_end ov02_0224AB8C

	thumb_func_start ov02_0224AB9C
ov02_0224AB9C: ; 0x0224AB9C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x7b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl sub_02068D74
	add r5, r0, #0
	ldr r0, [r5, #0x60]
	cmp r0, #0
	beq _0224ABB6
	bl sub_02068B48
_0224ABB6:
	ldr r0, [r5, #0x64]
	cmp r0, #0
	beq _0224ABC0
	bl ov01_021FCD78
_0224ABC0:
	mov r0, #0x7b
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl sub_02068B48
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224AB9C

	thumb_func_start ov02_0224ABCC
ov02_0224ABCC: ; 0x0224ABCC
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r1, #0
	bl sub_02068D98
	ldr r0, [r0]
	add r1, sp, #0
	str r0, [r4, #0x5c]
	add r0, r5, #0
	bl sub_02068DB8
	mov r2, #0
	ldr r0, [r4, #0x5c]
	add r1, sp, #0
	add r3, r2, #0
	bl ov02_0224A468
	str r0, [r4, #0x58]
	mov r0, #1
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov02_0224ABCC

	thumb_func_start ov02_0224ABF8
ov02_0224ABF8: ; 0x0224ABF8
	ldr r3, _0224AC00 ; =Sprite_Delete
	ldr r0, [r1, #0x58]
	bx r3
	nop
_0224AC00: .word Sprite_Delete
	thumb_func_end ov02_0224ABF8

	thumb_func_start ov02_0224AC04
ov02_0224AC04: ; 0x0224AC04
	push {r3, r4, r5, lr}
	add r5, r1, #0
	ldrb r0, [r5]
	lsl r1, r0, #2
	ldr r0, _0224AC20 ; =ov02_022533C0
	ldr r4, [r0, r1]
_0224AC10:
	ldrb r1, [r5, #1]
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	blx r1
	cmp r0, #1
	beq _0224AC10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224AC20: .word ov02_022533C0
	thumb_func_end ov02_0224AC04

	thumb_func_start ov02_0224AC24
ov02_0224AC24: ; 0x0224AC24
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224AC24

	thumb_func_start ov02_0224AC28
ov02_0224AC28: ; 0x0224AC28
	push {r3, lr}
	mov r1, #0
	strb r1, [r0, #2]
	ldr r0, [r0, #0x58]
	bl Sprite_SetDrawFlag
	mov r0, #0
	pop {r3, pc}
	thumb_func_end ov02_0224AC28

	thumb_func_start ov02_0224AC38
ov02_0224AC38: ; 0x0224AC38
	push {r4, r5, r6, lr}
	sub sp, #0x18
	ldr r4, _0224ACD8 ; =ov02_022533E4
	add r2, r0, #0
	ldmia r4!, {r0, r1}
	add r3, sp, #0xc
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	ldr r4, _0224ACDC ; =ov02_022533F0
	str r0, [r3]
	ldmia r4!, {r0, r1}
	add r3, sp, #0
	stmia r3!, {r0, r1}
	ldr r0, [r4]
	str r0, [r3]
	mov r0, #0x7b
	lsl r0, r0, #2
	ldr r0, [r2, r0]
	bl sub_02068D74
	add r4, r0, #0
	mov r3, #1
	add r5, r4, #0
	strb r3, [r4]
	mov r2, #0
	strb r2, [r4, #1]
	strb r2, [r4, #2]
	add r6, sp, #0xc
	ldmia r6!, {r0, r1}
	add r5, #8
	stmia r5!, {r0, r1}
	ldr r0, [r6]
	add r6, sp, #0
	str r0, [r5]
	str r2, [r4, #0x14]
	str r2, [r4, #0x18]
	mov r0, #0xf
	add r5, r4, #0
	str r2, [r4, #0x1c]
	lsl r0, r0, #0xe
	str r0, [r4, #0x38]
	ldmia r6!, {r0, r1}
	add r5, #0x2c
	stmia r5!, {r0, r1}
	ldr r0, [r6]
	add r1, sp, #0xc
	str r0, [r5]
	lsl r0, r3, #9
	str r0, [r4, #0x50]
	mov r0, #0x2d
	lsl r0, r0, #0xe
	str r0, [r4, #0x40]
	str r2, [r4, #0x48]
	lsl r0, r3, #0xd
	str r0, [r4, #0x4c]
	ldr r0, [r4, #0x58]
	bl Sprite_SetMatrix
	ldr r0, [r4, #0x58]
	add r1, sp, #0
	bl Sprite_SetAffineScale
	ldr r1, [r4, #0x38]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	ldr r0, [r4, #0x58]
	bl Sprite_SetAffineZRotation
	ldr r0, [r4, #0x58]
	mov r1, #1
	bl Sprite_SetDrawFlag
	add sp, #0x18
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224ACD8: .word ov02_022533E4
_0224ACDC: .word ov02_022533F0
	thumb_func_end ov02_0224AC38

	thumb_func_start ov02_0224ACE0
ov02_0224ACE0: ; 0x0224ACE0
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r1, [r5, #0x48]
	ldr r0, [r5, #0x4c]
	ldr r4, [r5, #0x58]
	add r0, r1, r0
	str r0, [r5, #0x48]
	mov r0, #1
	ldr r1, [r5, #0x4c]
	lsl r0, r0, #0x10
	cmp r1, r0
	bge _0224AD00
	lsr r0, r0, #2
	add r0, r1, r0
	str r0, [r5, #0x4c]
_0224AD00:
	ldr r0, _0224ADE0 ; =0x0000013B
	bl GF_CosDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x14]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_SinDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x18]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r2, r0, #0xc
	ldr r0, _0224ADE4 ; =0x0000010E
	cmp r2, r0
	bge _0224AD4A
	mov r0, #1
	lsl r0, r0, #0xe
	add r0, r1, r0
	str r0, [r5, #0x40]
_0224AD4A:
	ldr r1, [r5, #0x2c]
	ldr r0, [r5, #0x50]
	add r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [r5, #0x2c]
	cmp r1, r0
	ble _0224AD5C
	str r0, [r5, #0x2c]
_0224AD5C:
	ldr r1, [r5, #0x30]
	ldr r0, [r5, #0x50]
	add r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [r5, #0x30]
	cmp r1, r0
	ble _0224AD6E
	str r0, [r5, #0x30]
_0224AD6E:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x2c
	bl Sprite_SetAffineScale
	mov r0, #6
	ldr r1, [r5, #0x38]
	lsl r0, r0, #0xc
	sub r1, r1, r0
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	str r1, [r5, #0x38]
	asr r0, r0, #0xc
	bpl _0224AD90
	mov r0, #0
	str r0, [r5, #0x38]
_0224AD90:
	ldr r1, [r5, #0x38]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	ldr r1, [r5, #8]
	ldr r0, [r5, #0x14]
	add r0, r1, r0
	str r0, [sp]
	ldr r1, [r5, #0xc]
	ldr r0, [r5, #0x18]
	add r0, r1, r0
	str r0, [sp, #4]
	add r0, r4, #0
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r1, [sp, #4]
	ldr r0, _0224ADE8 ; =0xFFFC0000
	cmp r1, r0
	bge _0224ADDA
	add r0, r4, #0
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #2
	strb r0, [r5, #2]
	ldrb r0, [r5, #1]
	add r0, r0, #1
	strb r0, [r5, #1]
_0224ADDA:
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0224ADE0: .word 0x0000013B
_0224ADE4: .word 0x0000010E
_0224ADE8: .word 0xFFFC0000
	thumb_func_end ov02_0224ACE0

	thumb_func_start ov02_0224ADEC
ov02_0224ADEC: ; 0x0224ADEC
	mov r0, #0
	bx lr
	thumb_func_end ov02_0224ADEC

	thumb_func_start ov02_0224ADF0
ov02_0224ADF0: ; 0x0224ADF0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x30
	ldr r3, _0224AF5C ; =ov02_02253354
	add r5, r0, #0
	ldmia r3!, {r0, r1}
	add r2, sp, #0x24
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	ldr r3, _0224AF60 ; =ov02_0225336C
	str r0, [r2]
	ldmia r3!, {r0, r1}
	add r2, sp, #0x18
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	mov r0, #0x7b
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	bl sub_02068D74
	add r4, r0, #0
	mov r0, #2
	strb r0, [r4]
	mov r6, #0
	mov r0, #0xbb
	strb r6, [r4, #1]
	mov r7, #1
	strb r7, [r4, #2]
	str r6, [r4, #4]
	lsl r0, r0, #2
	ldr r1, [r5, r0]
	ldr r2, [sp, #0x24]
	add r0, #8
	add r1, r2, r1
	str r1, [sp, #0x24]
	add r2, r4, #0
	ldr r1, [sp, #0x28]
	ldr r0, [r5, r0]
	add r3, sp, #0x24
	add r0, r1, r0
	str r0, [sp, #0x28]
	ldmia r3!, {r0, r1}
	add r2, #8
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	add r3, sp, #0x18
	str r0, [r2]
	str r6, [r4, #0x14]
	str r6, [r4, #0x18]
	str r6, [r4, #0x1c]
	ldr r6, _0224AF64 ; =0x0013B000
	add r2, r4, #0
	str r6, [r4, #0x38]
	ldmia r3!, {r0, r1}
	add r2, #0x2c
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	add r0, r7, #0
	add r0, #0xff
	str r0, [r4, #0x50]
	mov r0, #0xe1
	lsl r0, r0, #0xc
	str r0, [r4, #0x40]
	mov r0, #3
	lsl r0, r0, #0x12
	str r0, [r4, #0x48]
	lsl r0, r7, #0x11
	str r0, [r4, #0x4c]
	lsr r0, r6, #0xc
	bl GF_CosDeg
	ldr r2, [r4, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r4, #0x14]
	ldr r1, [r4, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_SinDeg
	ldr r2, [r4, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r4, #0x18]
	ldr r1, [r4, #8]
	ldr r0, [r4, #0x14]
	add r0, r1, r0
	str r0, [sp, #0x24]
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x18]
	add r0, r1, r0
	str r0, [sp, #0x28]
	ldr r0, [r4, #0x58]
	add r1, sp, #0x24
	bl Sprite_SetMatrix
	ldr r0, [r4, #0x58]
	add r1, sp, #0x18
	bl Sprite_SetAffineScale
	ldr r1, [r4, #0x38]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	ldr r0, [r4, #0x58]
	bl Sprite_SetAffineZRotation
	ldr r0, [r4, #0x58]
	add r1, r7, #0
	bl Sprite_SetDrawFlag
	mov r1, #0x1e
	lsl r1, r1, #4
	ldr r0, [r5, r1]
	add r1, r1, #4
	ldr r1, [r5, r1]
	bl ov02_0224B298
	str r0, [r4, #0x60]
	add r0, r7, #0
	str r0, [r5, #0x1c]
	ldr r0, [r5, #0x60]
	mov r1, #4
	bl ov01_021FCD2C
	ldr r2, _0224AF68 ; =0xFFF88000
	add r1, r7, #0
	mov r3, #0xc
	str r0, [r4, #0x64]
	bl ov01_021FCD8C
	add r1, sp, #0xc
	mov r0, #0
	str r0, [r1]
	str r0, [r1, #4]
	ldr r3, _0224AF6C ; =ov02_02253378
	str r0, [r1, #8]
	ldmia r3!, {r0, r1}
	add r2, sp, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	mov r0, #0x79
	ldr r1, [r4, #0x5c]
	lsl r0, r0, #2
	ldr r4, [r1, r0]
	mov r1, #2
	add r0, r4, #0
	bl Sprite_SetAffineOverwriteMode
	add r0, r4, #0
	add r1, sp, #0xc
	bl Sprite_SetAffineMatrix
	add r0, r4, #0
	add r1, sp, #0
	bl Sprite_SetAffineScale
	mov r0, #0
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	add sp, #0x30
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224AF5C: .word ov02_02253354
_0224AF60: .word ov02_0225336C
_0224AF64: .word 0x0013B000
_0224AF68: .word 0xFFF88000
_0224AF6C: .word ov02_02253378
	thumb_func_end ov02_0224ADF0

	thumb_func_start ov02_0224AF70
ov02_0224AF70: ; 0x0224AF70
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r1, [r5, #0x48]
	ldr r0, [r5, #0x4c]
	ldr r4, [r5, #0x58]
	sub r0, r1, r0
	str r0, [r5, #0x48]
	bpl _0224AF86
	mov r0, #0
	str r0, [r5, #0x48]
_0224AF86:
	mov r0, #2
	ldr r1, [r5, #0x4c]
	lsl r0, r0, #0xa
	cmp r1, r0
	ble _0224AF98
	mov r0, #6
	lsl r0, r0, #0xa
	sub r0, r1, r0
	str r0, [r5, #0x4c]
_0224AF98:
	mov r0, #1
	ldr r1, [r5, #0x4c]
	lsl r0, r0, #0xc
	cmp r1, r0
	bge _0224AFA4
	str r0, [r5, #0x4c]
_0224AFA4:
	ldr r0, _0224B0D8 ; =0x0000013B
	bl GF_CosDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x14]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_SinDeg
	ldr r2, [r5, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r5, #0x18]
	ldr r1, [r5, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r2, r0, #0xc
	ldr r0, _0224B0DC ; =0x0000010E
	cmp r2, r0
	bge _0224AFEE
	mov r0, #1
	lsl r0, r0, #0xe
	add r0, r1, r0
	str r0, [r5, #0x40]
_0224AFEE:
	ldr r1, [r5, #0x2c]
	ldr r0, [r5, #0x50]
	add r1, r1, r0
	mov r0, #6
	lsl r0, r0, #0xa
	str r1, [r5, #0x2c]
	cmp r1, r0
	ble _0224B000
	str r0, [r5, #0x2c]
_0224B000:
	ldr r1, [r5, #0x30]
	ldr r0, [r5, #0x50]
	add r1, r1, r0
	mov r0, #6
	lsl r0, r0, #0xa
	str r1, [r5, #0x30]
	cmp r1, r0
	ble _0224B012
	str r0, [r5, #0x30]
_0224B012:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x2c
	bl Sprite_SetAffineScale
	mov r0, #2
	ldr r1, [r5, #0x38]
	lsl r0, r0, #0xe
	add r1, r1, r0
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	str r1, [r5, #0x38]
	asr r1, r0, #0xc
	mov r0, #0x5a
	lsl r0, r0, #2
	cmp r1, r0
	ble _0224B03A
	lsl r0, r0, #0xc
	str r0, [r5, #0x38]
_0224B03A:
	ldr r1, [r5, #0x38]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_DegreeToSinCosIdx
	add r1, r0, #0
	add r0, r4, #0
	bl Sprite_SetAffineZRotation
	ldr r1, [r5, #8]
	ldr r0, [r5, #0x14]
	add r0, r1, r0
	str r0, [sp, #0xc]
	ldr r1, [r5, #0xc]
	ldr r0, [r5, #0x18]
	add r0, r1, r0
	str r0, [sp, #0x10]
	add r0, r4, #0
	add r1, sp, #0xc
	bl Sprite_SetMatrix
	ldr r0, [r5, #0x48]
	cmp r0, #0
	bne _0224B07C
	mov r0, #0
	str r0, [r5, #4]
	ldrb r0, [r5, #1]
	add r0, r0, #1
	strb r0, [r5, #1]
	b _0224B082
_0224B07C:
	ldr r0, [r5, #4]
	add r0, r0, #1
	str r0, [r5, #4]
_0224B082:
	ldr r0, [r5, #4]
	cmp r0, #0xc
	bne _0224B08E
	ldr r0, [r5, #0x60]
	bl ov02_0224B2CC
_0224B08E:
	mov r0, #0x79
	ldr r1, [r5, #0x5c]
	lsl r0, r0, #2
	ldr r4, [r1, r0]
	add r0, r4, #0
	bl Sprite_GetScalePtr
	add r3, r0, #0
	ldmia r3!, {r0, r1}
	add r2, sp, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r1, [sp]
	mov r0, #5
	add r1, #0x80
	lsl r0, r0, #0xa
	str r1, [sp]
	cmp r1, r0
	ble _0224B0B8
	str r0, [sp]
_0224B0B8:
	ldr r1, [sp, #4]
	mov r0, #5
	add r1, #0x80
	lsl r0, r0, #0xa
	str r1, [sp, #4]
	cmp r1, r0
	ble _0224B0C8
	str r0, [sp, #4]
_0224B0C8:
	add r0, r4, #0
	add r1, sp, #0
	bl Sprite_SetAffineScale
	mov r0, #0
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_0224B0D8: .word 0x0000013B
_0224B0DC: .word 0x0000010E
	thumb_func_end ov02_0224AF70

	thumb_func_start ov02_0224B0E0
ov02_0224B0E0: ; 0x0224B0E0
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x79
	ldr r1, [r4, #0x5c]
	lsl r0, r0, #2
	ldr r5, [r1, r0]
	mov r1, #3
	add r0, r5, #0
	bl Sprite_SetAnimCtrlSeq
	add r0, r5, #0
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x5c]
	mov r1, #1
	bl ov02_0224B6B0
	mov r0, #0x82
	ldr r1, [r4, #0x5c]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	bl sub_0205F484
	add r0, r5, #0
	bl Sprite_GetMatrixPtr
	ldr r5, [r0, #4]
	ldr r0, [r4, #0x58]
	bl Sprite_GetMatrixPtr
	ldr r0, [r0, #4]
	sub r0, r5, r0
	str r0, [r4, #0x54]
	ldr r0, [r4, #0x60]
	bl ov02_0224B2C0
	ldr r0, [r4, #0x64]
	mov r1, #2
	mov r2, #0
	mov r3, #0xc
	bl ov01_021FCD8C
	mov r1, #1
	lsl r1, r1, #8
	str r1, [r4, #0x50]
	lsl r0, r1, #0xb
	str r0, [r4, #0x40]
	mov r0, #0
	str r0, [r4, #0x48]
	lsl r0, r1, #3
	str r0, [r4, #0x4c]
	mov r0, #3
	strb r0, [r4, #2]
	ldrb r0, [r4, #1]
	add r0, r0, #1
	strb r0, [r4, #1]
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B0E0

	thumb_func_start ov02_0224B158
ov02_0224B158: ; 0x0224B158
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	add r4, r0, #0
	ldr r1, [r4, #0x48]
	ldr r0, [r4, #0x4c]
	ldr r6, [r4, #0x58]
	add r0, r1, r0
	str r0, [r4, #0x48]
	mov r0, #1
	ldr r1, [r4, #0x4c]
	lsl r0, r0, #0xc
	add r2, r1, r0
	lsl r1, r0, #4
	str r2, [r4, #0x4c]
	cmp r2, r1
	ble _0224B17C
	lsl r0, r0, #4
	str r0, [r4, #0x4c]
_0224B17C:
	ldr r1, [r4, #0x40]
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	lsl r0, r0, #4
	lsr r0, r0, #0x10
	bl GF_CosDeg
	ldr r2, [r4, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r4, #0x14]
	mov r0, #0x80
	bl GF_SinDeg
	ldr r2, [r4, #0x48]
	asr r1, r2, #0xb
	lsr r1, r1, #0x14
	add r1, r2, r1
	asr r1, r1, #0xc
	mul r0, r1
	str r0, [r4, #0x18]
	mov r0, #0x87
	ldr r1, [r4, #0x40]
	lsl r0, r0, #0xc
	cmp r1, r0
	bge _0224B1C0
	mov r0, #1
	lsl r0, r0, #0xc
	add r0, r1, r0
	str r0, [r4, #0x40]
_0224B1C0:
	ldr r1, [r4, #0x2c]
	ldr r0, [r4, #0x50]
	add r1, r1, r0
	mov r0, #2
	lsl r0, r0, #0xc
	str r1, [r4, #0x2c]
	cmp r1, r0
	ble _0224B1D2
	str r0, [r4, #0x2c]
_0224B1D2:
	ldr r1, [r4, #0x30]
	ldr r0, [r4, #0x50]
	add r1, r1, r0
	mov r0, #2
	lsl r0, r0, #0xc
	str r1, [r4, #0x30]
	cmp r1, r0
	ble _0224B1E4
	str r0, [r4, #0x30]
_0224B1E4:
	ldr r1, [r4, #8]
	ldr r0, [r4, #0x14]
	add r0, r1, r0
	str r0, [sp, #0x18]
	ldr r1, [r4, #0xc]
	ldr r0, [r4, #0x18]
	add r1, r1, r0
	asr r0, r1, #0xb
	lsr r0, r0, #0x14
	add r0, r1, r0
	asr r0, r0, #0xc
	str r1, [sp, #0x1c]
	cmp r0, #0xe6
	blt _0224B20A
	mov r0, #2
	strb r0, [r4, #2]
	ldrb r0, [r4, #1]
	add r0, r0, #1
	strb r0, [r4, #1]
_0224B20A:
	mov r0, #0x79
	ldr r1, [r4, #0x5c]
	lsl r0, r0, #2
	ldr r7, [r1, r0]
	add r0, r7, #0
	bl Sprite_GetScalePtr
	add r2, sp, #0xc
	add r3, sp, #0x18
	add r5, r0, #0
	ldmia r3!, {r0, r1}
	mov ip, r2
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldmia r5!, {r0, r1}
	add r2, sp, #0
	stmia r2!, {r0, r1}
	ldr r0, [r5]
	str r0, [r2]
	mov r0, #1
	ldr r1, [r4, #0x54]
	lsl r0, r0, #0xc
	sub r1, r1, r0
	str r1, [r4, #0x54]
	ldr r0, [sp, #0x10]
	add r0, r0, r1
	str r0, [sp, #0x10]
	add r0, r7, #0
	mov r1, ip
	bl Sprite_SetMatrix
	mov r0, #1
	ldr r1, [sp]
	lsl r0, r0, #8
	add r2, r1, r0
	lsl r1, r0, #5
	str r2, [sp]
	cmp r2, r1
	ble _0224B25E
	lsl r0, r0, #5
	str r0, [sp]
_0224B25E:
	mov r0, #1
	ldr r1, [sp, #4]
	lsl r0, r0, #8
	add r2, r1, r0
	lsl r1, r0, #5
	str r2, [sp, #4]
	cmp r2, r1
	ble _0224B272
	lsl r0, r0, #5
	str r0, [sp, #4]
_0224B272:
	add r0, r7, #0
	add r1, sp, #0
	bl Sprite_SetAffineScale
	add r4, #0x2c
	add r0, r6, #0
	add r1, r4, #0
	bl Sprite_SetAffineScale
	add r0, r6, #0
	add r1, sp, #0x18
	bl Sprite_SetMatrix
	mov r0, #0
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B158

	thumb_func_start ov02_0224B294
ov02_0224B294: ; 0x0224B294
	mov r0, #0
	bx lr
	thumb_func_end ov02_0224B294

	thumb_func_start ov02_0224B298
ov02_0224B298: ; 0x0224B298
	push {lr}
	sub sp, #0x1c
	add r2, sp, #0x10
	mov r3, #0
	str r3, [r2]
	str r3, [r2, #4]
	str r1, [sp, #0xc]
	str r3, [r2, #8]
	add r1, sp, #8
	str r1, [sp]
	mov r1, #0x81
	str r1, [sp, #4]
	ldr r1, _0224B2BC ; =ov02_022534A4
	bl sub_02068B0C
	add sp, #0x1c
	pop {pc}
	nop
_0224B2BC: .word ov02_022534A4
	thumb_func_end ov02_0224B298

	thumb_func_start ov02_0224B2C0
ov02_0224B2C0: ; 0x0224B2C0
	push {r3, lr}
	bl sub_02068D74
	mov r1, #0
	str r1, [r0]
	pop {r3, pc}
	thumb_func_end ov02_0224B2C0

	thumb_func_start ov02_0224B2CC
ov02_0224B2CC: ; 0x0224B2CC
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	bl sub_02068D74
	add r4, r0, #0
	mov r0, #1
	str r0, [r4]
	mov r0, #0
	str r0, [r4, #4]
	str r0, [r4, #0xc]
	str r0, [r4, #8]
	str r0, [r4, #0x10]
	str r0, [r4, #0x14]
	str r0, [r4, #0x18]
	ldr r0, [r4, #0x20]
	bl Sprite_GetMatrixPtr
	add r6, r0, #0
	add r3, sp, #0
	ldmia r6!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldr r0, [r6]
	add r1, r2, #0
	str r0, [r3]
	add r0, r5, #0
	bl sub_02068DA8
	ldr r0, [r4, #0x20]
	mov r1, #5
	bl Sprite_SetAnimCtrlSeq
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B2CC

	thumb_func_start ov02_0224B314
ov02_0224B314: ; 0x0224B314
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	bl sub_02068D74
	add r4, r0, #0
	mov r0, #2
	str r0, [r4]
	mov r0, #0
	str r0, [r4, #4]
	str r0, [r4, #0xc]
	str r0, [r4, #8]
	str r0, [r4, #0x10]
	str r0, [r4, #0x14]
	str r0, [r4, #0x18]
	ldr r0, [r4, #0x20]
	add r1, sp, #0
	bl ov02_02248C98
	add r0, r5, #0
	add r1, sp, #0
	bl sub_02068DA8
	ldr r0, [r4, #0x20]
	mov r1, #4
	bl Sprite_SetAnimCtrlSeq
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B314

	thumb_func_start ov02_0224B350
ov02_0224B350: ; 0x0224B350
	push {r4, lr}
	add r4, r1, #0
	bl sub_02068D98
	ldr r1, [r0]
	str r1, [r4, #0x1c]
	ldr r0, [r0, #4]
	str r0, [r4, #0x20]
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov02_0224B350

	thumb_func_start ov02_0224B364
ov02_0224B364: ; 0x0224B364
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r1, #0
	ldr r1, [r4, #4]
	cmp r1, #0
	bne _0224B3A8
	ldr r1, [r4, #0xc]
	lsl r2, r1, #2
	ldr r1, _0224B3AC ; =ov02_02253520
	ldr r1, [r1, r2]
	str r1, [r4, #0x14]
	add r1, sp, #0
	bl sub_02068DB8
	ldr r1, [sp, #4]
	ldr r0, [r4, #0x14]
	add r0, r1, r0
	str r0, [sp, #4]
	ldr r0, [r4, #0x20]
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r0, [r4, #0xc]
	add r0, r0, #1
	str r0, [r4, #0xc]
	cmp r0, #0xc
	blt _0224B3A8
	mov r0, #0
	str r0, [r4, #0xc]
	mov r0, #1
	str r0, [r4, #8]
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
_0224B3A8:
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_0224B3AC: .word ov02_02253520
	thumb_func_end ov02_0224B364

	thumb_func_start ov02_0224B3B0
ov02_0224B3B0: ; 0x0224B3B0
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r1, #0
	ldr r1, [r4, #4]
	cmp r1, #0
	bne _0224B3F4
	ldr r1, [r4, #0xc]
	lsl r2, r1, #2
	ldr r1, _0224B3F8 ; =ov02_02253430
	ldr r1, [r1, r2]
	str r1, [r4, #0x14]
	add r1, sp, #0
	bl sub_02068DB8
	ldr r1, [sp, #4]
	ldr r0, [r4, #0x14]
	add r0, r1, r0
	str r0, [sp, #4]
	ldr r0, [r4, #0x20]
	add r1, sp, #0
	bl Sprite_SetMatrix
	ldr r0, [r4, #0xc]
	add r0, r0, #1
	str r0, [r4, #0xc]
	cmp r0, #4
	blt _0224B3F4
	mov r0, #0
	str r0, [r4, #0xc]
	mov r0, #1
	str r0, [r4, #8]
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
_0224B3F4:
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_0224B3F8: .word ov02_02253430
	thumb_func_end ov02_0224B3B0

	thumb_func_start ov02_0224B3FC
ov02_0224B3FC: ; 0x0224B3FC
	push {r3, lr}
	ldr r2, [r1]
	cmp r2, #1
	beq _0224B40A
	cmp r2, #2
	beq _0224B410
	pop {r3, pc}
_0224B40A:
	bl ov02_0224B364
	pop {r3, pc}
_0224B410:
	bl ov02_0224B3B0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B3FC

	thumb_func_start ov02_0224B418
ov02_0224B418: ; 0x0224B418
	push {r3, r4, r5, lr}
	add r4, r1, #0
	mov r1, #0x5f
	add r5, r0, #0
	mov r0, #4
	lsl r1, r1, #2
	bl ov02_0224B690
	add r1, r0, #0
	str r4, [r1, #0xc]
	ldr r0, _0224B438 ; =ov02_0224B45C
	mov r2, #0x86
	str r5, [r1, #0x14]
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224B438: .word ov02_0224B45C
	thumb_func_end ov02_0224B418

	thumb_func_start ov02_0224B43C
ov02_0224B43C: ; 0x0224B43C
	push {r3, lr}
	bl SysTask_GetData
	ldr r0, [r0, #4]
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B43C

	thumb_func_start ov02_0224B448
ov02_0224B448: ; 0x0224B448
	push {r4, lr}
	add r4, r0, #0
	bl SysTask_GetData
	bl Heap_Free
	add r0, r4, #0
	bl SysTask_Destroy
	pop {r4, pc}
	thumb_func_end ov02_0224B448

	thumb_func_start ov02_0224B45C
ov02_0224B45C: ; 0x0224B45C
	push {r3, r4, r5, lr}
	ldr r4, _0224B490 ; =ov02_022534B8
	add r5, r1, #0
_0224B462:
	ldr r1, [r5]
	add r0, r5, #0
	lsl r1, r1, #2
	ldr r1, [r4, r1]
	blx r1
	cmp r0, #1
	beq _0224B462
	ldr r0, [r5, #0x10]
	cmp r0, #0
	beq _0224B48E
	mov r0, #0x17
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0224B484
	bl sub_02068BAC
_0224B484:
	ldr r0, [r5, #0x20]
	cmp r0, #0
	beq _0224B48E
	bl SpriteList_RenderAndAnimateSprites
_0224B48E:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224B490: .word ov02_022534B8
	thumb_func_end ov02_0224B45C

	thumb_func_start ov02_0224B494
ov02_0224B494: ; 0x0224B494
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x14]
	mov r1, #1
	bl ov02_02249444
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B494

	thumb_func_start ov02_0224B4AC
ov02_0224B4AC: ; 0x0224B4AC
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r5, r0, #0
	mov r0, #4
	mov r1, #0x20
	bl sub_020689C8
	mov r1, #0x17
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r2, #2
	str r2, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	add r0, r5, #0
	add r0, #0x18
	mov r1, #0x20
	add r3, r2, #0
	str r2, [sp, #0x14]
	bl ov02_02248728
	bl ov02_022493F0
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0xb
	mov r3, #0
	bl ov02_02248980
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #6
	mov r3, #0
	bl ov02_02248A58
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0xc
	mov r3, #0
	bl ov02_02248B30
	add r0, r5, #0
	add r0, #0x18
	mov r1, #0
	bl ov02_022489F0
	add r0, r5, #0
	add r0, #0x18
	mov r1, #0
	bl ov02_02248AC8
	add r0, r5, #0
	add r0, #0x18
	mov r1, #0
	bl ov02_02248A24
	add r0, r5, #0
	add r0, #0x18
	mov r1, #0
	bl ov02_02248AFC
	ldr r0, [r5, #0xc]
	cmp r0, #0
	bne _0224B57C
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0x11
	mov r3, #2
	bl ov02_02248980
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0x12
	mov r3, #2
	bl ov02_02248B30
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0x13
	mov r3, #1
	bl ov02_02248BA0
	add r0, r5, #0
	add r0, #0x18
	mov r1, #2
	bl ov02_022489F0
	add r0, r5, #0
	add r0, #0x18
	mov r1, #2
	bl ov02_02248A24
	b _0224B5DC
_0224B57C:
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0x14
	mov r3, #2
	bl ov02_02248980
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #7
	mov r3, #1
	bl ov02_02248A58
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0x15
	mov r3, #2
	bl ov02_02248B30
	add r0, r5, #0
	add r0, #0x18
	add r1, r4, #0
	mov r2, #0x16
	mov r3, #1
	bl ov02_02248BA0
	add r0, r5, #0
	add r0, #0x18
	mov r1, #2
	bl ov02_022489F0
	add r0, r5, #0
	add r0, #0x18
	mov r1, #1
	bl ov02_02248AC8
	add r0, r5, #0
	add r0, #0x18
	mov r1, #2
	bl ov02_02248A24
	add r0, r5, #0
	add r0, #0x18
	mov r1, #1
	bl ov02_02248AFC
_0224B5DC:
	add r0, r4, #0
	bl NARC_Delete
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	mov r0, #0
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B4AC

	thumb_func_start ov02_0224B5F0
ov02_0224B5F0: ; 0x0224B5F0
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0xc]
	add r0, #0x18
	bl ov02_02248D18
	mov r1, #0x5b
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r3, #0x17
	lsl r3, r3, #4
	ldr r1, [r4, r3]
	sub r3, r3, #4
	add r2, r4, #0
	ldr r0, [r4, #0x14]
	ldr r3, [r4, r3]
	add r2, #0x18
	bl ov02_02248D58
	mov r1, #0x5d
	lsl r1, r1, #2
	str r0, [r4, r1]
	ldr r0, [r4, r1]
	bl ov02_02248E20
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	str r0, [r4, #0x10]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov02_0224B5F0

	thumb_func_start ov02_0224B638
ov02_0224B638: ; 0x0224B638
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x5d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ov02_02248D8C
	cmp r0, #2
	beq _0224B64E
	mov r0, #0
	pop {r4, pc}
_0224B64E:
	mov r0, #0x5d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl ov02_02248DBC
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B638

	thumb_func_start ov02_0224B664
ov02_0224B664: ; 0x0224B664
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x17
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl sub_020689F8
	add r0, r4, #0
	add r0, #0x18
	bl ov02_0224886C
	mov r0, #0
	str r0, [r4, #0x10]
	mov r1, #1
	str r1, [r4, #4]
	ldr r1, [r4]
	add r1, r1, #1
	str r1, [r4]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B664

	thumb_func_start ov02_0224B68C
ov02_0224B68C: ; 0x0224B68C
	mov r0, #0
	bx lr
	thumb_func_end ov02_0224B68C

	thumb_func_start ov02_0224B690
ov02_0224B690: ; 0x0224B690
	push {r3, r4, r5, lr}
	add r5, r1, #0
	bl Heap_AllocAtEnd
	add r4, r0, #0
	bne _0224B6A0
	bl GF_AssertFail
_0224B6A0:
	add r0, r4, #0
	mov r1, #0
	add r2, r5, #0
	bl memset
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B690

	thumb_func_start ov02_0224B6B0
ov02_0224B6B0: ; 0x0224B6B0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r4, r1, #0
	bl MapObject_UnpauseMovement
	mov r0, #0x82
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r1, r4, #0
	bl MapObject_SetVisible
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B6B0

	thumb_func_start ov02_0224B6D0
ov02_0224B6D0: ; 0x0224B6D0
	push {r4, lr}
	add r4, r1, #0
	bl sub_02068D98
	ldr r1, [r0]
	ldr r0, [r0, #4]
	str r1, [r4]
	str r0, [r4, #4]
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov02_0224B6D0

	thumb_func_start ov02_0224B6E4
ov02_0224B6E4: ; 0x0224B6E4
	push {r3, r4, r5, lr}
	add r4, r1, #0
	ldr r0, [r4]
	bl Sprite_GetMatrixPtr
	ldr r1, [r4, #4]
	ldr r0, [r0, #4]
	ldr r5, [r1, #0x4c]
	ldr r3, [r1, #0x50]
	ldr r1, [r1, #0x1c]
	cmp r1, #0
	bne _0224B720
	mov r1, #2
	lsl r1, r1, #0xe
	sub r2, r0, r1
	cmp r2, r5
	blt _0224B716
	add r0, r0, r1
	cmp r0, r3
	bgt _0224B716
	ldr r0, [r4]
	mov r1, #1
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_0224B716:
	ldr r0, [r4]
	mov r1, #0
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
_0224B720:
	ldr r0, [r4]
	mov r1, #1
	bl Sprite_SetDrawFlag
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B6E4

	thumb_func_start ov02_0224B72C
ov02_0224B72C: ; 0x0224B72C
	push {r3, r4, lr}
	sub sp, #0x1c
	add r2, sp, #0x10
	mov r3, #0
	str r3, [r2]
	add r4, r0, #0
	str r3, [r2, #4]
	mov r0, #0x79
	str r3, [r2, #8]
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	sub r0, r0, #4
	str r1, [sp, #8]
	str r4, [sp, #0xc]
	add r1, sp, #8
	str r1, [sp]
	mov r1, #0x87
	str r1, [sp, #4]
	ldr r0, [r4, r0]
	ldr r1, _0224B764 ; =ov02_02253440
	bl sub_02068B0C
	mov r1, #0x7d
	lsl r1, r1, #2
	str r0, [r4, r1]
	add sp, #0x1c
	pop {r3, r4, pc}
	nop
_0224B764: .word ov02_02253440
	thumb_func_end ov02_0224B72C

	thumb_func_start ov02_0224B768
ov02_0224B768: ; 0x0224B768
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x7d
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0224B782
	bl sub_02068B48
	mov r0, #0x7d
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
_0224B782:
	pop {r4, pc}
	thumb_func_end ov02_0224B768

	thumb_func_start ov02_0224B784
ov02_0224B784: ; 0x0224B784
	push {r4, lr}
	sub sp, #0x18
	add r2, sp, #0xc
	mov r1, #0
	str r1, [r2]
	add r4, r0, #0
	str r1, [r2, #4]
	str r1, [r2, #8]
	str r4, [sp, #8]
	bl ov02_0224B88C
	mov r0, #0x83
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	add r1, sp, #0xc
	bl MapObject_CopyPositionVector
	add r0, sp, #8
	str r0, [sp]
	mov r0, #0x83
	str r0, [sp, #4]
	mov r0, #0x1e
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	ldr r1, _0224B7C8 ; =ov02_02253490
	add r2, sp, #0xc
	mov r3, #0
	bl sub_02068B0C
	mov r1, #0x1f
	lsl r1, r1, #4
	str r0, [r4, r1]
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_0224B7C8: .word ov02_02253490
	thumb_func_end ov02_0224B784

	thumb_func_start ov02_0224B7CC
ov02_0224B7CC: ; 0x0224B7CC
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r1, #0
	bl sub_02068D98
	ldr r1, [r0]
	mov r6, #0x8a
	str r1, [r4]
	ldr r4, [r0]
	lsl r6, r6, #2
	add r0, r5, #0
	add r1, sp, #0
	bl sub_02068DB8
	add r0, r4, r6
	add r0, #0x24
	add r1, sp, #0
	bl Field3dObject_SetPos
	add r0, r4, r6
	add r0, #0x24
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	mov r0, #1
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov02_0224B7CC

	thumb_func_start ov02_0224B804
ov02_0224B804: ; 0x0224B804
	bx lr
	.balign 4, 0
	thumb_func_end ov02_0224B804

	thumb_func_start ov02_0224B808
ov02_0224B808: ; 0x0224B808
	push {r4, r5, r6, lr}
	add r5, r1, #0
	ldr r0, [r5, #4]
	mov r6, #0x8a
	lsl r6, r6, #2
	ldr r4, [r5]
	cmp r0, #3
	bhi _0224B878
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224B824: ; jump table
	.short _0224B82C - _0224B824 - 2 ; case 0
	.short _0224B832 - _0224B824 - 2 ; case 1
	.short _0224B854 - _0224B824 - 2 ; case 2
	.short _0224B878 - _0224B824 - 2 ; case 3
_0224B82C:
	mov r0, #1
	str r0, [r5, #4]
	pop {r4, r5, r6, pc}
_0224B832:
	add r0, r4, r6
	add r0, #0x24
	mov r1, #1
	bl Field3dObject_SetActiveFlag
	add r0, r4, r6
	add r0, #0x9c
	mov r1, #0
	bl Field3dModelAnimation_FrameSet
	add r0, r4, r6
	add r0, #0xb0
	mov r1, #0
	bl Field3dModelAnimation_FrameSet
	mov r0, #2
	str r0, [r5, #4]
_0224B854:
	add r0, r4, r6
	mov r1, #1
	add r0, #0x9c
	lsl r1, r1, #0xc
	bl Field3dModelAnimation_FrameAdvanceAndCheck
	add r0, r4, r6
	mov r1, #1
	add r0, #0xb0
	lsl r1, r1, #0xc
	bl Field3dModelAnimation_FrameAdvanceAndCheck
	cmp r0, #0
	beq _0224B878
	mov r0, #1
	str r0, [r5, #8]
	mov r0, #3
	str r0, [r5, #4]
_0224B878:
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B808

	thumb_func_start ov02_0224B87C
ov02_0224B87C: ; 0x0224B87C
	mov r0, #0x93
	ldr r1, [r1]
	lsl r0, r0, #2
	ldr r3, _0224B888 ; =Field3dObject_Draw
	add r0, r1, r0
	bx r3
	.balign 4, 0
_0224B888: .word Field3dObject_Draw
	thumb_func_end ov02_0224B87C

	thumb_func_start ov02_0224B88C
ov02_0224B88C: ; 0x0224B88C
	push {r4, lr}
	sub sp, #8
	mov r1, #0x8a
	lsl r1, r1, #2
	add r4, r0, r1
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	mov r0, #0x67
	mov r1, #0x83
	mov r2, #4
	bl AllocAtEndAndReadWholeNarcMemberByIdPair
	str r0, [r4, #0x10]
	add r0, r4, #0
	ldr r1, [r4, #0x10]
	add r0, #0x14
	bl ov01_021FBD38
	add r0, r4, #0
	add r1, r4, #0
	add r0, #0x24
	add r1, #0x14
	bl Field3dObject_InitFromModel
	mov r0, #4
	str r0, [sp]
	add r0, r4, #0
	add r1, r4, #0
	add r0, #0x9c
	add r1, #0x14
	mov r2, #0x67
	mov r3, #0xa7
	str r4, [sp, #4]
	bl Field3dModelAnimation_LoadFromFilesystem
	mov r0, #4
	str r0, [sp]
	add r0, r4, #0
	add r1, r4, #0
	add r0, #0xb0
	add r1, #0x14
	mov r2, #0x67
	mov r3, #0xa5
	str r4, [sp, #4]
	bl Field3dModelAnimation_LoadFromFilesystem
	add r0, r4, #0
	add r1, r4, #0
	add r0, #0x24
	add r1, #0x9c
	bl Field3dObject_AddAnimation
	add r0, r4, #0
	add r4, #0xb0
	add r0, #0x24
	add r1, r4, #0
	bl Field3dObject_AddAnimation
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B88C

	thumb_func_start ov02_0224B90C
ov02_0224B90C: ; 0x0224B90C
	push {r4, lr}
	mov r1, #0x8a
	lsl r1, r1, #2
	add r4, r0, r1
	add r0, r4, #0
	add r0, #0x14
	bl ov01_021FBDFC
	ldr r0, [r4, #0x10]
	bl ov01_021F1448
	add r0, r4, #0
	add r0, #0x9c
	add r1, r4, #0
	bl Field3dModelAnimation_Unload
	add r0, r4, #0
	add r0, #0xb0
	add r1, r4, #0
	bl Field3dModelAnimation_Unload
	pop {r4, pc}
	thumb_func_end ov02_0224B90C

	thumb_func_start ov02_0224B938
ov02_0224B938: ; 0x0224B938
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x83
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	mov r1, #1
	bl MapObject_SetVisible
	mov r0, #0x83
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl sub_0205F484
	add r0, r4, #0
	bl ov02_0224B784
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B938

	thumb_func_start ov02_0224B964
ov02_0224B964: ; 0x0224B964
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x1f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl sub_02068D74
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _0224B992
	mov r0, #0x1f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl sub_02068B48
	add r0, r4, #0
	bl ov02_0224B90C
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
_0224B992:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224B964

	thumb_func_start ov02_BattleExit_HandleRoamerAction
ov02_BattleExit_HandleRoamerAction: ; 0x0224B998
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [r1, #8]
	str r1, [sp]
	mov r1, #0
	bl Party_GetMonByIndex
	add r7, r0, #0
	ldr r0, [r5, #0xc]
	bl Save_Roamers_Get
	add r6, r0, #0
	add r0, r7, #0
	mov r1, #5
	mov r2, #0
	bl GetMonData
	add r4, r0, #0
	add r0, r6, #0
	add r1, r4, #0
	bl ov02_0224BAA8
	str r0, [sp, #8]
	cmp r0, #0
	beq _0224BA50
	lsl r0, r4, #0x10
	lsr r0, r0, #0x10
	bl SpeciesToRoamerIdx
	str r0, [sp, #4]
	add r0, r7, #0
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	add r0, r7, #0
	mov r1, #0xa0
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, [sp]
	ldr r0, [r0, #0x14]
	cmp r0, #1
	bne _0224BA14
	cmp r4, #0
	bne _0224BA14
	add r0, sp, #8
	bl RoamerMon_Init
	ldr r0, [r5, #0xc]
	bl Save_VarsFlags_Get
	ldr r1, [sp, #4]
	mov r2, #2
	bl sub_02066BE8
	b _0224BA42
_0224BA14:
	cmp r0, #4
	bne _0224BA2E
	add r0, sp, #8
	bl RoamerMon_Init
	ldr r0, [r5, #0xc]
	bl Save_VarsFlags_Get
	ldr r1, [sp, #4]
	mov r2, #1
	bl sub_02066BE8
	b _0224BA42
_0224BA2E:
	ldr r0, [sp, #8]
	mov r1, #5
	add r2, r4, #0
	bl SetRoamerData
	ldr r0, [sp, #8]
	mov r1, #7
	add r2, r7, #0
	bl SetRoamerData
_0224BA42:
	ldr r1, [r5, #0x20]
	add r0, r6, #0
	ldr r1, [r1]
	bl ov02_RepelActiveRoamersFromMapNo
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
_0224BA50:
	bl LCRandom
	mov r1, #0x64
	bl _s32_div_f
	lsl r0, r1, #0x10
	lsr r0, r0, #0x10
	cmp r0, #0x1e
	bhs _0224BA6C
	ldr r1, [r5, #0x20]
	add r0, r6, #0
	ldr r1, [r1]
	bl ov02_RepelActiveRoamersFromMapNo
_0224BA6C:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov02_BattleExit_HandleRoamerAction

	thumb_func_start ov02_RepelActiveRoamersFromMapNo
ov02_RepelActiveRoamersFromMapNo: ; 0x0224BA70
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r6, r1, #0
	mov r4, #0
_0224BA78:
	add r0, r5, #0
	add r1, r4, #0
	bl GetRoamerIsActiveByIndex
	cmp r0, #0
	beq _0224BA9C
	add r0, r5, #0
	add r1, r4, #0
	bl Roamer_GetLocation
	bl GetRoamMapByLocationIdx
	cmp r6, r0
	bne _0224BA9C
	add r0, r5, #0
	add r1, r4, #0
	bl RoamerLocationUpdateRand
_0224BA9C:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _0224BA78
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_RepelActiveRoamersFromMapNo

	thumb_func_start ov02_0224BAA8
ov02_0224BAA8: ; 0x0224BAA8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	mov r4, #0
_0224BAB0:
	add r0, r5, #0
	add r1, r4, #0
	bl GetRoamerIsActiveByIndex
	cmp r0, #0
	beq _0224BAD4
	add r0, r5, #0
	add r1, r4, #0
	bl Roamers_GetRoamMonStats
	mov r1, #4
	add r7, r0, #0
	bl GetRoamerData
	cmp r6, r0
	bne _0224BAD4
	add r0, r7, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224BAD4:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _0224BAB0
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224BAA8
