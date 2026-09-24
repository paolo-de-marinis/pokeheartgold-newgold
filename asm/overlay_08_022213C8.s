#include "constants/moves.h"
	.include "asm/macros.inc"
	.include "overlay_08.inc"
	.include "global.inc"

.public ov08_0221D5DC
.public ov08_0221DB24
.public ov08_02220A8C
.public ov08_02221294
.public ov08_02221328

	.text
	thumb_func_start ov08_022213C8
ov08_022213C8: ; 0x022213C8
	push {r3, lr}
	ldr r1, _022213E0 ; =0x00002077
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	bne _022213DA
	bl ov08_02221294
	pop {r3, pc}
_022213DA:
	bl ov08_02221328
	pop {r3, pc}
	.balign 4, 0
_022213E0: .word 0x00002077
	thumb_func_end ov08_022213C8

	thumb_func_start ov08_022213E4
ov08_022213E4: ; 0x022213E4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl ManagedSprite_GetActiveAnim
	cmp r4, r0
	beq _02221402
	add r0, r5, #0
	mov r1, #0
	bl ManagedSprite_SetAnimationFrame
	add r0, r5, #0
	add r1, r4, #0
	bl ManagedSprite_SetAnim
_02221402:
	pop {r3, r4, r5, pc}
	thumb_func_end ov08_022213E4

	thumb_func_start ov08_02221404
ov08_02221404: ; 0x02221404
	push {r3, lr}
	add r2, r0, #0
	ldrh r0, [r2, #0x10]
	cmp r0, #0
	bne _02221412
	mov r0, #0
	pop {r3, pc}
_02221412:
	ldrb r1, [r2, #0x17]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1c
	cmp r1, #7
	beq _02221424
	cmp r1, #6
	beq _02221424
	mov r0, #5
	pop {r3, pc}
_02221424:
	ldrh r1, [r2, #0x12]
	mov r2, #0x30
	bl CalculateHpBarColor
	cmp r0, #4
	bhi _02221456
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0222143C: ; jump table
	.short _02221456 - _0222143C - 2 ; case 0
	.short _02221452 - _0222143C - 2 ; case 1
	.short _0222144E - _0222143C - 2 ; case 2
	.short _0222144A - _0222143C - 2 ; case 3
	.short _02221446 - _0222143C - 2 ; case 4
_02221446:
	mov r0, #1
	pop {r3, pc}
_0222144A:
	mov r0, #2
	pop {r3, pc}
_0222144E:
	mov r0, #3
	pop {r3, pc}
_02221452:
	mov r0, #4
	pop {r3, pc}
_02221456:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov08_02221404

	thumb_func_start ov08_0222145C
ov08_0222145C: ; 0x0222145C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5]
	mov r4, #0
	ldr r0, [r0]
	bl Party_GetCount
	cmp r0, #0
	ble _022214B4
	add r7, r5, #4
_02221470:
	mov r0, #0x50
	add r1, r4, #0
	mul r1, r0
	add r0, r5, r1
	ldrh r0, [r0, #8]
	cmp r0, #0
	beq _022214A2
	add r0, r7, r1
	bl ov08_02221404
	add r1, r0, #0
	lsl r0, r4, #2
	add r6, r5, r0
	ldr r0, _022214B8 ; =0x00001FD4
	lsl r1, r1, #0x18
	ldr r0, [r6, r0]
	lsr r1, r1, #0x18
	bl ov08_022213E4
	ldr r0, _022214B8 ; =0x00001FD4
	mov r1, #1
	ldr r0, [r6, r0]
	lsl r1, r1, #0xc
	bl ManagedSprite_TickNFrames
_022214A2:
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldr r0, [r5]
	ldr r0, [r0]
	bl Party_GetCount
	cmp r4, r0
	blt _02221470
_022214B4:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_022214B8: .word 0x00001FD4
	thumb_func_end ov08_0222145C

	thumb_func_start ov08_022214BC
ov08_022214BC: ; 0x022214BC
	push {r4, lr}
	add r4, r2, #0
	cmp r4, r1
	ble _022214E2
	add r0, #0x2c
	sub r1, r4, r1
	mul r1, r0
	lsl r0, r1, #0x10
	mov r1, #0x4b
	lsl r1, r1, #2
	bl _u32_div_f
	lsr r0, r0, #0x10
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	sub r0, r4, r0
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	pop {r4, pc}
_022214E2:
	add r0, #0x2c
	sub r1, r1, r4
	mul r1, r0
	lsl r0, r1, #0x10
	mov r1, #0x4b
	lsl r1, r1, #2
	bl _u32_div_f
	lsr r0, r0, #0x10
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add r0, r4, r0
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	pop {r4, pc}
	thumb_func_end ov08_022214BC

	thumb_func_start ov08_02221500
ov08_02221500: ; 0x02221500
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	ldr r0, [r6]
	add r5, r6, #4
	ldrb r1, [r0, #0x11]
	mov r0, #0x50
	add r4, r1, #0
	mul r4, r0
	ldr r0, _02221618 ; =0x00002024
	mov r1, #0
	ldr r0, [r6, r0]
	bl ov08_022213E4
	ldr r0, _0222161C ; =0x00002028
	mov r1, #1
	ldr r0, [r6, r0]
	bl ov08_022213E4
	ldr r0, _02221620 ; =0x0000202C
	mov r1, #3
	ldr r0, [r6, r0]
	bl ov08_022213E4
	ldr r0, _02221624 ; =0x00002030
	mov r1, #4
	ldr r0, [r6, r0]
	bl ov08_022213E4
	ldr r0, _02221628 ; =0x00002034
	mov r1, #2
	ldr r0, [r6, r0]
	bl ov08_022213E4
	add r0, r5, r4
	add r0, #0x28
	mov r1, #0x90
	ldrb r0, [r0]
	add r2, r1, #0
	bl ov08_022214BC
	add r7, r0, #0
	add r0, r5, r4
	add r0, #0x28
	ldrb r0, [r0]
	mov r1, #2
	mov r2, #0x18
	bl ov08_022214BC
	add r2, r0, #0
	ldr r0, _02221618 ; =0x00002024
	add r1, r7, #0
	ldr r0, [r6, r0]
	bl ov08_02220A8C
	add r0, r5, r4
	add r0, #0x29
	ldrb r0, [r0]
	mov r1, #0xa4
	mov r2, #0x90
	bl ov08_022214BC
	add r7, r0, #0
	add r0, r5, r4
	add r0, #0x29
	ldrb r0, [r0]
	mov r1, #0x10
	mov r2, #0x18
	bl ov08_022214BC
	add r2, r0, #0
	ldr r0, _0222161C ; =0x00002028
	add r1, r7, #0
	ldr r0, [r6, r0]
	bl ov08_02220A8C
	add r0, r5, r4
	add r0, #0x2a
	ldrb r0, [r0]
	mov r1, #0x9c
	mov r2, #0x90
	bl ov08_022214BC
	add r7, r0, #0
	add r0, r5, r4
	add r0, #0x2a
	ldrb r0, [r0]
	mov r1, #0x29
	mov r2, #0x18
	bl ov08_022214BC
	add r2, r0, #0
	ldr r0, _02221620 ; =0x0000202C
	add r1, r7, #0
	ldr r0, [r6, r0]
	bl ov08_02220A8C
	add r0, r5, r4
	add r0, #0x2b
	ldrb r0, [r0]
	mov r1, #0x83
	mov r2, #0x8f
	bl ov08_022214BC
	add r7, r0, #0
	add r0, r5, r4
	add r0, #0x2b
	ldrb r0, [r0]
	mov r1, #0x29
	mov r2, #0x18
	bl ov08_022214BC
	add r2, r0, #0
	ldr r0, _02221624 ; =0x00002030
	add r1, r7, #0
	ldr r0, [r6, r0]
	bl ov08_02220A8C
	add r0, r5, r4
	add r0, #0x2c
	ldrb r0, [r0]
	mov r1, #0x7b
	mov r2, #0x8f
	bl ov08_022214BC
	add r7, r0, #0
	add r0, r5, r4
	add r0, #0x2c
	ldrb r0, [r0]
	mov r1, #0x10
	mov r2, #0x18
	bl ov08_022214BC
	add r2, r0, #0
	ldr r0, _02221628 ; =0x00002034
	add r1, r7, #0
	ldr r0, [r6, r0]
	bl ov08_02220A8C
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02221618: .word 0x00002024
_0222161C: .word 0x00002028
_02221620: .word 0x0000202C
_02221624: .word 0x00002030
_02221628: .word 0x00002034
	thumb_func_end ov08_02221500

	thumb_func_start ov08_0222162C
ov08_0222162C: ; 0x0222162C
	push {r4, r5, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #8]
	bl BattleSystem_GetSpriteSystem
	ldr r1, _02221688 ; =0x0000B018
	mov r2, #0x7a
	str r1, [sp]
	sub r1, #0xc
	str r1, [sp, #4]
	str r1, [sp, #8]
	str r1, [sp, #0xc]
	ldr r1, _0222168C ; =0x00001FB4
	ldr r3, [r5]
	lsl r2, r2, #2
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	ldr r3, [r3, #0xc]
	add r4, r0, #0
	bl BattleCursor_LoadResources
	ldr r3, _02221690 ; =0x0000B00C
	mov r0, #0
	str r3, [sp]
	str r3, [sp, #4]
	str r3, [sp, #8]
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	ldr r1, _0222168C ; =0x00001FB4
	ldr r2, [r5]
	ldr r1, [r5, r1]
	ldr r2, [r2, #0xc]
	add r0, r4, #0
	add r3, #0xc
	bl BattleCursor_New
	add r1, r0, #0
	ldr r0, _02221694 ; =0x00002088
	ldr r0, [r5, r0]
	bl ov08_02224B94
	add sp, #0x14
	pop {r4, r5, pc}
	.balign 4, 0
_02221688: .word 0x0000B018
_0222168C: .word 0x00001FB4
_02221690: .word 0x0000B00C
_02221694: .word 0x00002088
	thumb_func_end ov08_0222162C

	thumb_func_start ov08_02221698
ov08_02221698: ; 0x02221698
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _022216C0 ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224B84
	bl BattleCursor_Delete
	ldr r2, _022216C4 ; =0x0000B00C
	ldr r0, _022216C8 ; =0x00001FB4
	str r2, [sp]
	add r1, r2, #0
	ldr r0, [r4, r0]
	add r1, #0xc
	add r3, r2, #0
	bl BattleCursor_FreeResources
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022216C0: .word 0x00002088
_022216C4: .word 0x0000B00C
_022216C8: .word 0x00001FB4
	thumb_func_end ov08_02221698

	thumb_func_start ov08_022216CC
ov08_022216CC: ; 0x022216CC
	push {r3, lr}
	ldr r1, _022216F0 ; =0x00002077
	ldrb r2, [r0, r1]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x1c
	bne _022216E4
	add r1, #0x11
	ldr r0, [r0, r1]
	mov r1, #0x5f
	bl ov08_02224BF8
	pop {r3, pc}
_022216E4:
	add r1, #0x11
	ldr r0, [r0, r1]
	mov r1, #0x7f
	bl ov08_02224BF8
	pop {r3, pc}
	.balign 4, 0
_022216F0: .word 0x00002077
	thumb_func_end ov08_022216CC

	thumb_func_start ov08_022216F4
ov08_022216F4: ; 0x022216F4
	push {r3, lr}
	ldr r1, _02221718 ; =0x00002077
	ldrb r2, [r0, r1]
	lsl r2, r2, #0x18
	lsr r2, r2, #0x1c
	bne _0222170C
	add r1, #0x11
	ldr r0, [r0, r1]
	mov r1, #5
	bl ov08_02224BF8
	pop {r3, pc}
_0222170C:
	add r1, #0x11
	ldr r0, [r0, r1]
	mov r1, #7
	bl ov08_02224BF8
	pop {r3, pc}
	.balign 4, 0
_02221718: .word 0x00002077
	thumb_func_end ov08_022216F4

	thumb_func_start ov08_0222171C
ov08_0222171C: ; 0x0222171C
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r4, r0, #0
	ldr r0, _022217BC ; =0x00002088
	ldr r1, _022217C0 ; =ov08_022254BC
	lsl r2, r5, #2
	ldr r0, [r4, r0]
	ldr r1, [r1, r2]
	bl ov08_02224BCC
	cmp r5, #9
	bhi _022217BA
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02221740: ; jump table
	.short _02221754 - _02221740 - 2 ; case 0
	.short _0222176E - _02221740 - 2 ; case 1
	.short _022217BA - _02221740 - 2 ; case 2
	.short _02221784 - _02221740 - 2 ; case 3
	.short _02221784 - _02221740 - 2 ; case 4
	.short _022217BA - _02221740 - 2 ; case 5
	.short _02221794 - _02221740 - 2 ; case 6
	.short _022217A8 - _02221740 - 2 ; case 7
	.short _02221794 - _02221740 - 2 ; case 8
	.short _022217A8 - _02221740 - 2 ; case 9
_02221754:
	ldr r1, [r4]
	ldr r0, _022217BC ; =0x00002088
	ldrb r1, [r1, #0x11]
	ldr r0, [r4, r0]
	bl ov08_02224B98
	ldr r0, _022217C4 ; =0x0000208C
	mov r1, #0
	strb r1, [r4, r0]
	ldr r0, [r4]
	add r0, #0x34
	strb r1, [r0]
	pop {r3, r4, r5, pc}
_0222176E:
	ldr r1, _022217BC ; =0x00002088
	ldr r0, [r4, r1]
	add r1, r1, #4
	ldrb r1, [r4, r1]
	bl ov08_02224B98
	ldr r0, [r4]
	mov r1, #0
	add r0, #0x34
	strb r1, [r0]
	pop {r3, r4, r5, pc}
_02221784:
	ldr r1, [r4]
	ldr r0, _022217BC ; =0x00002088
	add r1, #0x34
	ldrb r1, [r1]
	ldr r0, [r4, r0]
	bl ov08_02224B98
	pop {r3, r4, r5, pc}
_02221794:
	add r0, r4, #0
	bl ov08_022216CC
	ldr r1, _022217BC ; =0x00002088
	ldr r0, [r4, r1]
	add r1, r1, #5
	ldrb r1, [r4, r1]
	bl ov08_02224B98
	pop {r3, r4, r5, pc}
_022217A8:
	add r0, r4, #0
	bl ov08_022216F4
	ldr r1, _022217BC ; =0x00002088
	ldr r0, [r4, r1]
	add r1, r1, #6
	ldrb r1, [r4, r1]
	bl ov08_02224B98
_022217BA:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022217BC: .word 0x00002088
_022217C0: .word ov08_022254BC
_022217C4: .word 0x0000208C
	thumb_func_end ov08_0222171C

	thumb_func_start ov08_022217C8
ov08_022217C8: ; 0x022217C8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _022217EC ; =0x00002088
	mov r1, #0
	ldr r0, [r4, r0]
	bl ov08_02224B90
	ldr r0, _022217EC ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224BC0
	ldr r0, _022217EC ; =0x00002088
	ldr r0, [r4, r0]
	bl ov08_02224B84
	bl BattleCursor_Disable
	pop {r4, pc}
	.balign 4, 0
_022217EC: .word 0x00002088
	thumb_func_end ov08_022217C8

	thumb_func_start ov08_022217F0
ov08_022217F0: ; 0x022217F0
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0x7b
	lsl r0, r0, #2
	mov r2, #0
	add r0, r5, r0
	add r3, r2, #0
	add r4, r1, #0
	bl ov08_02221BD0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0xab
	lsl r0, r0, #2
	mov r3, #6
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	str r3, [sp, #4]
	bl ov08_02221BD0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0xdb
	lsl r0, r0, #2
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	mov r3, #0xc
	bl ov08_02221BD0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, _02221AB0 ; =0x0000042C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x12
	bl ov08_02221BD0
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, _02221AB4 ; =0x000004EC
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0
	bl ov08_02221BD0
	ldr r0, _02221AB8 ; =0x000005AC
	mov r2, #0x10
	str r2, [sp]
	mov r3, #6
	add r0, r5, r0
	add r1, r4, #0
	str r3, [sp, #4]
	bl ov08_02221BD0
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, _02221ABC ; =0x0000066C
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0xc
	bl ov08_02221BD0
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	ldr r0, _02221AC0 ; =0x0000072C
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0x12
	bl ov08_02221BD0
	mov r0, #0xd
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _02221AC4 ; =0x000007EC
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x27
	bl ov08_02221BD0
	mov r0, #0xd
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _02221AC8 ; =0x0000086E
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x2c
	bl ov08_02221BD0
	mov r2, #0xd
	str r2, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #0x8f
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x27
	bl ov08_02221BD0
	mov r2, #0xd
	str r2, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _02221ACC ; =0x00000972
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0x2c
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AD0 ; =0x000009F4
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x31
	bl ov08_02221BD0
	ldr r0, _02221AD4 ; =0x00000A26
	mov r2, #5
	str r2, [sp]
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x31
	str r2, [sp, #4]
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AD8 ; =0x00000A58
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xa
	mov r3, #0x31
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221ADC ; =0x00000A8A
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xf
	mov r3, #0x31
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AE0 ; =0x00000ABC
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x36
	bl ov08_02221BD0
	ldr r0, _02221AE4 ; =0x00000AEE
	mov r2, #5
	str r2, [sp]
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x36
	str r2, [sp, #4]
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0xb2
	lsl r0, r0, #4
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0xa
	mov r3, #0x36
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AE8 ; =0x00000B52
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xf
	mov r3, #0x36
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AEC ; =0x00000B84
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1a
	mov r3, #0x18
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AF0 ; =0x00000BB6
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1a
	mov r3, #0x1d
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AF4 ; =0x00000BE8
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1a
	mov r3, #0x22
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _02221AF8 ; =0x00000C1A
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x1a
	mov r3, #0x27
	bl ov08_02221BD0
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #0x6d
	lsl r0, r0, #6
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	mov r3, #0x18
	bl ov08_02221BD0
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _02221AFC ; =0x00001C44
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x1d
	bl ov08_02221BD0
	mov r0, #0x1a
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	ldr r0, _02221B00 ; =0x00001D48
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x22
	bl ov08_02221BD0
	mov r0, #9
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _02221B04 ; =0x00001E4C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x14
	mov r3, #0x31
	bl ov08_02221BD0
	mov r0, #9
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _02221B08 ; =0x00001E94
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x14
	mov r3, #0x35
	bl ov08_02221BD0
	mov r0, #9
	str r0, [sp]
	mov r0, #4
	str r0, [sp, #4]
	ldr r0, _02221B0C ; =0x00001EDC
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0x14
	mov r3, #0x39
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _02221B10 ; =0x00001F24
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x3b
	bl ov08_02221BD0
	mov r2, #5
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _02221B14 ; =0x00001F38
	add r1, r4, #0
	add r0, r5, r0
	mov r3, #0x3b
	bl ov08_02221BD0
	mov r0, #5
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	ldr r0, _02221B18 ; =0x00001F4C
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0xa
	mov r3, #0x3b
	bl ov08_02221BD0
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_02221AB0: .word 0x0000042C
_02221AB4: .word 0x000004EC
_02221AB8: .word 0x000005AC
_02221ABC: .word 0x0000066C
_02221AC0: .word 0x0000072C
_02221AC4: .word 0x000007EC
_02221AC8: .word 0x0000086E
_02221ACC: .word 0x00000972
_02221AD0: .word 0x000009F4
_02221AD4: .word 0x00000A26
_02221AD8: .word 0x00000A58
_02221ADC: .word 0x00000A8A
_02221AE0: .word 0x00000ABC
_02221AE4: .word 0x00000AEE
_02221AE8: .word 0x00000B52
_02221AEC: .word 0x00000B84
_02221AF0: .word 0x00000BB6
_02221AF4: .word 0x00000BE8
_02221AF8: .word 0x00000C1A
_02221AFC: .word 0x00001C44
_02221B00: .word 0x00001D48
_02221B04: .word 0x00001E4C
_02221B08: .word 0x00001E94
_02221B0C: .word 0x00001EDC
_02221B10: .word 0x00001F24
_02221B14: .word 0x00001F38
_02221B18: .word 0x00001F4C
	thumb_func_end ov08_022217F0

	thumb_func_start ov08_02221B1C
ov08_02221B1C: ; 0x02221B1C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x1e
	str r0, [sp]
	mov r0, #0x11
	str r0, [sp, #4]
	ldr r0, _02221BC4 ; =0x00000C4C
	mov r2, #0
	add r0, r5, r0
	add r3, r2, #0
	add r4, r1, #0
	bl ov08_02221BD0
	mov r0, #0x1e
	str r0, [sp]
	ldr r0, _02221BC8 ; =0x00001048
	mov r3, #0x11
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	str r3, [sp, #4]
	bl ov08_02221BD0
	mov r0, #0x1e
	str r0, [sp]
	mov r0, #0x11
	str r0, [sp, #4]
	ldr r0, _02221BCC ; =0x00001444
	add r1, r4, #0
	add r0, r5, r0
	mov r2, #0
	mov r3, #0x22
	bl ov08_02221BD0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0x61
	lsl r0, r0, #6
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	mov r3, #0x33
	bl ov08_02221BD0
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0x19
	lsl r0, r0, #8
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x33
	bl ov08_02221BD0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0x67
	lsl r0, r0, #6
	add r0, r5, r0
	add r1, r4, #0
	mov r2, #0
	mov r3, #0x39
	bl ov08_02221BD0
	mov r2, #0x10
	str r2, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #0x6a
	lsl r0, r0, #6
	add r0, r5, r0
	add r1, r4, #0
	mov r3, #0x39
	bl ov08_02221BD0
	add sp, #8
	pop {r3, r4, r5, pc}
	nop
_02221BC4: .word 0x00000C4C
_02221BC8: .word 0x00001048
_02221BCC: .word 0x00001444
	thumb_func_end ov08_02221B1C

	thumb_func_start ov08_02221BD0
ov08_02221BD0: ; 0x02221BD0
	push {r3, r4, r5, r6, r7, lr}
	str r0, [sp]
	add r0, sp, #8
	mov lr, r3
	ldrb r3, [r0, #0x14]
	mov r6, #0
	mov ip, r3
	cmp r3, #0
	ble _02221C1C
	ldrb r3, [r0, #0x10]
	lsl r2, r2, #1
	add r7, r1, r2
_02221BE8:
	mov r2, #0
	cmp r3, #0
	ble _02221C10
	mov r0, lr
	add r0, r0, r6
	lsl r0, r0, #6
	add r5, r7, r0
	add r0, r6, #0
	mul r0, r3
	lsl r1, r0, #1
	ldr r0, [sp]
	add r4, r0, r1
_02221C00:
	lsl r1, r2, #1
	ldrh r0, [r5, r1]
	strh r0, [r4, r1]
	add r0, r2, #1
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	cmp r2, r3
	blt _02221C00
_02221C10:
	add r0, r6, #1
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	mov r0, ip
	cmp r6, r0
	blt _02221BE8
_02221C1C:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov08_02221BD0

	thumb_func_start ov08_02221C20
ov08_02221C20: ; 0x02221C20
	cmp r1, #0x21
	bhi _02221D06
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02221C30: ; jump table
	.short _02221C74 - _02221C30 - 2 ; case 0
	.short _02221C74 - _02221C30 - 2 ; case 1
	.short _02221C74 - _02221C30 - 2 ; case 2
	.short _02221C74 - _02221C30 - 2 ; case 3
	.short _02221C74 - _02221C30 - 2 ; case 4
	.short _02221C74 - _02221C30 - 2 ; case 5
	.short _02221C92 - _02221C30 - 2 ; case 6
	.short _02221C9E - _02221C30 - 2 ; case 7
	.short _02221CAC - _02221C30 - 2 ; case 8
	.short _02221CAC - _02221C30 - 2 ; case 9
	.short _02221CAC - _02221C30 - 2 ; case 10
	.short _02221CAC - _02221C30 - 2 ; case 11
	.short _02221CB8 - _02221C30 - 2 ; case 12
	.short _02221CC4 - _02221C30 - 2 ; case 13
	.short _02221CD0 - _02221C30 - 2 ; case 14
	.short _02221CD0 - _02221C30 - 2 ; case 15
	.short _02221CD0 - _02221C30 - 2 ; case 16
	.short _02221CD0 - _02221C30 - 2 ; case 17
	.short _02221CEE - _02221C30 - 2 ; case 18
	.short _02221CD0 - _02221C30 - 2 ; case 19
	.short _02221CD0 - _02221C30 - 2 ; case 20
	.short _02221CD0 - _02221C30 - 2 ; case 21
	.short _02221CD0 - _02221C30 - 2 ; case 22
	.short _02221CD0 - _02221C30 - 2 ; case 23
	.short _02221CD0 - _02221C30 - 2 ; case 24
	.short _02221CD0 - _02221C30 - 2 ; case 25
	.short _02221CD0 - _02221C30 - 2 ; case 26
	.short _02221CD0 - _02221C30 - 2 ; case 27
	.short _02221CDE - _02221C30 - 2 ; case 28
	.short _02221CDE - _02221C30 - 2 ; case 29
	.short _02221CFA - _02221C30 - 2 ; case 30
	.short _02221CFA - _02221C30 - 2 ; case 31
	.short _02221CFA - _02221C30 - 2 ; case 32
	.short _02221CFA - _02221C30 - 2 ; case 33
_02221C74:
	cmp r3, #0
	bne _02221C86
	mov r1, #0x7b
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xc0
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221C86:
	ldr r1, _02221D0C ; =0x000004EC
	add r1, r0, r1
	mov r0, #0xc0
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221C92:
	ldr r1, _02221D10 ; =0x00000B84
	add r1, r0, r1
	mov r0, #0x32
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221C9E:
	ldr r1, _02221D14 ; =0x00000C4C
	add r1, r0, r1
	mov r0, #0xff
	lsl r0, r0, #2
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221CAC:
	ldr r1, _02221D18 ; =0x000007EC
	add r1, r0, r1
	mov r0, #0x82
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221CB8:
	ldr r1, _02221D1C ; =0x000009F4
	add r1, r0, r1
	mov r0, #0x32
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221CC4:
	ldr r1, _02221D20 ; =0x00000ABC
	add r1, r0, r1
	mov r0, #0x32
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221CD0:
	mov r1, #0x61
	lsl r1, r1, #6
	add r1, r0, r1
	mov r0, #0xc0
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221CDE:
	mov r1, #0x6d
	lsl r1, r1, #6
	add r1, r0, r1
	lsl r0, r2, #6
	add r0, r2, r0
	lsl r0, r0, #2
	add r0, r1, r0
	bx lr
_02221CEE:
	ldr r1, _02221D24 ; =0x00001E4C
	add r1, r0, r1
	mov r0, #0x48
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221CFA:
	ldr r1, _02221D28 ; =0x00001F24
	add r1, r0, r1
	mov r0, #0x14
	mul r0, r2
	add r0, r1, r0
	bx lr
_02221D06:
	mov r0, #0
	bx lr
	nop
_02221D0C: .word 0x000004EC
_02221D10: .word 0x00000B84
_02221D14: .word 0x00000C4C
_02221D18: .word 0x000007EC
_02221D1C: .word 0x000009F4
_02221D20: .word 0x00000ABC
_02221D24: .word 0x00001E4C
_02221D28: .word 0x00001F24
	thumb_func_end ov08_02221C20

	thumb_func_start ov08_02221D2C
ov08_02221D2C: ; 0x02221D2C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r7, r2, #0
	add r2, r3, #0
	add r3, sp, #0x10
	add r4, r1, #0
	ldrb r3, [r3, #0x10]
	add r1, r7, #0
	str r0, [sp]
	bl ov08_02221C20
	add r1, r0, #0
	ldr r2, _02221E60 ; =ov08_02225A56
	lsl r0, r7, #2
	ldrb r6, [r2, r0]
	ldr r2, _02221E64 ; =ov08_02225A57
	ldrb r0, [r2, r0]
	add r5, r6, #0
	mul r5, r0
	add r0, r4, #0
	lsl r2, r5, #1
	bl memcpy
	cmp r7, #5
	bgt _02221D7A
	cmp r7, #0
	blt _02221E5C
	add r0, r7, r7
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02221D6E: ; jump table
	.short _02221D82 - _02221D6E - 2 ; case 0
	.short _02221D82 - _02221D6E - 2 ; case 1
	.short _02221D82 - _02221D6E - 2 ; case 2
	.short _02221D82 - _02221D6E - 2 ; case 3
	.short _02221D82 - _02221D6E - 2 ; case 4
	.short _02221D82 - _02221D6E - 2 ; case 5
_02221D7A:
	cmp r7, #0x1b
	beq _02221E3C
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_02221D82:
	mov r0, #0x50
	add r1, r7, #0
	mul r1, r0
	ldr r0, [sp]
	add r0, r0, r1
	ldrh r1, [r0, #8]
	cmp r1, #0
	beq _02221E5C
	ldrb r1, [r0, #0x1b]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x1f
	beq _02221DE2
	lsl r2, r6, #1
	add r0, r2, #5
	lsl r0, r0, #1
	ldrh r1, [r4, r0]
	add r0, sp, #4
	strh r1, [r0]
	add r1, r6, r2
	add r1, r1, #5
	lsl r1, r1, #1
	ldrh r1, [r4, r1]
	strh r1, [r0, #2]
	mov r1, #0
	add r0, sp, #4
_02221DB4:
	add r5, r1, #2
	lsl r3, r1, #1
	add r7, r5, #0
	mul r7, r6
	lsl r5, r7, #1
	ldrh r3, [r0, r3]
	mov r2, #0
	add r5, r4, r5
_02221DC4:
	lsl r7, r2, #1
	add r2, r2, #1
	lsl r2, r2, #0x18
	add r7, r5, r7
	lsr r2, r2, #0x18
	strh r3, [r7, #0xc]
	cmp r2, #9
	blo _02221DC4
	add r1, r1, #1
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	cmp r1, #2
	blo _02221DB4
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_02221DE2:
	ldrh r0, [r0, #0x14]
	cmp r0, #0
	bne _02221E0C
	mov r1, #0
	cmp r5, #0
	ble _02221E5C
	mov r3, #2
	ldr r2, _02221E68 ; =0x00000FFF
	lsl r3, r3, #0xc
_02221DF4:
	lsl r0, r1, #1
	ldrh r6, [r4, r0]
	and r6, r2
	orr r6, r3
	strh r6, [r4, r0]
	add r0, r1, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	cmp r1, r5
	blt _02221DF4
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_02221E0C:
	lsl r1, r7, #0x18
	ldr r0, [sp]
	lsr r1, r1, #0x18
	bl ov08_0221DB24
	cmp r0, #1
	bne _02221E5C
	mov r1, #0
	cmp r5, #0
	ble _02221E5C
	ldr r2, _02221E68 ; =0x00000FFF
	add r3, r2, #1
_02221E24:
	lsl r0, r1, #1
	ldrh r6, [r4, r0]
	and r6, r2
	orr r6, r3
	strh r6, [r4, r0]
	add r0, r1, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	cmp r1, r5
	blt _02221E24
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_02221E3C:
	mov r1, #0
	cmp r5, #0
	ble _02221E5C
	mov r3, #0xa
	ldr r2, _02221E68 ; =0x00000FFF
	lsl r3, r3, #0xc
_02221E48:
	lsl r0, r1, #1
	ldrh r6, [r4, r0]
	and r6, r2
	orr r6, r3
	strh r6, [r4, r0]
	add r0, r1, #1
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	cmp r1, r5
	blt _02221E48
_02221E5C:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02221E60: .word ov08_02225A56
_02221E64: .word ov08_02225A57
_02221E68: .word 0x00000FFF
	thumb_func_end ov08_02221D2C

	thumb_func_start ov08_02221E6C
ov08_02221E6C: ; 0x02221E6C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	str r1, [sp, #0xc]
	str r2, [sp, #0x10]
	str r3, [sp, #0x14]
	add r5, r0, #0
	ldr r0, [sp, #0xc]
	lsl r4, r0, #2
	ldr r0, _02221ED8 ; =ov08_02225A57
	ldrb r7, [r0, r4]
	ldr r0, _02221EDC ; =ov08_02225A56
	ldrb r6, [r0, r4]
	ldr r0, [r5]
	add r1, r6, #0
	mul r1, r7
	ldr r0, [r0, #0xc]
	lsl r1, r1, #1
	bl Heap_Alloc
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x14]
	ldr r1, [sp, #0x18]
	str r0, [sp]
	ldr r2, [sp, #0xc]
	ldr r3, [sp, #0x10]
	add r0, r5, #0
	bl ov08_02221D2C
	ldr r0, _02221EE0 ; =ov08_02225A55
	ldr r3, _02221EE4 ; =ov08_02225A54
	ldrb r0, [r0, r4]
	ldrb r3, [r3, r4]
	ldr r2, [sp, #0x18]
	str r0, [sp]
	str r6, [sp, #4]
	mov r0, #0x79
	str r7, [sp, #8]
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #6
	bl LoadRectToBgTilemapRect
	mov r0, #0x79
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	mov r1, #6
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, [sp, #0x18]
	bl Heap_Free
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_02221ED8: .word ov08_02225A57
_02221EDC: .word ov08_02225A56
_02221EE0: .word ov08_02225A55
_02221EE4: .word ov08_02225A54
	thumb_func_end ov08_02221E6C

	thumb_func_start ov08_02221EE8
ov08_02221EE8: ; 0x02221EE8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, _02221F88 ; =ov08_022259CC
	lsl r3, r1, #2
	ldr r6, [r0, r3]
	cmp r6, #0
	beq _02221F86
	cmp r1, #5
	bhi _02221F02
	ldr r0, _02221F8C ; =ov08_022259BC
	ldrb r0, [r0, r2]
	str r0, [sp]
	b _02221F08
_02221F02:
	ldr r0, _02221F90 ; =ov08_022259AC
	ldrb r0, [r0, r2]
	str r0, [sp]
_02221F08:
	cmp r2, #0
	beq _02221F16
	cmp r2, #1
	beq _02221F1A
	cmp r2, #2
	beq _02221F1E
	b _02221F20
_02221F16:
	mov r7, #1
	b _02221F20
_02221F1A:
	mov r7, #0
	b _02221F20
_02221F1E:
	mov r7, #1
_02221F20:
	cmp r1, #0xe
	blo _02221F54
	cmp r1, #0x11
	bhi _02221F54
	ldr r1, _02221F94 ; =0x00002070
	ldr r2, [sp]
	ldr r0, [r5, r1]
	add r1, r1, #5
	ldrb r1, [r5, r1]
	mov r3, #0
	ldrb r1, [r6, r1]
	lsl r1, r1, #4
	add r0, r0, r1
	add r1, r7, #0
	bl ScrollWindow
	ldr r1, _02221F94 ; =0x00002070
	ldr r0, [r5, r1]
	add r1, r1, #5
	ldrb r1, [r5, r1]
	ldrb r1, [r6, r1]
	lsl r1, r1, #4
	add r0, r0, r1
	bl ScheduleWindowCopyToVram
	pop {r3, r4, r5, r6, r7, pc}
_02221F54:
	mov r4, #0
_02221F56:
	ldrb r2, [r6, r4]
	cmp r2, #0xff
	beq _02221F86
	ldr r0, _02221F94 ; =0x00002070
	mov r3, #0
	ldr r1, [r5, r0]
	lsl r0, r2, #4
	add r0, r1, r0
	ldr r2, [sp]
	add r1, r7, #0
	bl ScrollWindow
	ldr r0, _02221F94 ; =0x00002070
	ldr r1, [r5, r0]
	ldrb r0, [r6, r4]
	lsl r0, r0, #4
	add r0, r1, r0
	bl ScheduleWindowCopyToVram
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #8
	blo _02221F56
_02221F86:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02221F88: .word ov08_022259CC
_02221F8C: .word ov08_022259BC
_02221F90: .word ov08_022259AC
_02221F94: .word 0x00002070
	thumb_func_end ov08_02221EE8

	thumb_func_start ov08_02221F98
ov08_02221F98: ; 0x02221F98
	push {r4, r5, r6, lr}
	add r5, r1, #0
	add r4, r0, #0
	cmp r5, #0x1b
	bhi _0222209C
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02221FAE: ; jump table
	.short _02221FE6 - _02221FAE - 2 ; case 0
	.short _02221FE6 - _02221FAE - 2 ; case 1
	.short _02221FE6 - _02221FAE - 2 ; case 2
	.short _02221FE6 - _02221FAE - 2 ; case 3
	.short _02221FE6 - _02221FAE - 2 ; case 4
	.short _02221FE6 - _02221FAE - 2 ; case 5
	.short _0222209C - _02221FAE - 2 ; case 6
	.short _02222024 - _02221FAE - 2 ; case 7
	.short _0222209C - _02221FAE - 2 ; case 8
	.short _0222209C - _02221FAE - 2 ; case 9
	.short _0222209C - _02221FAE - 2 ; case 10
	.short _0222209C - _02221FAE - 2 ; case 11
	.short _0222209C - _02221FAE - 2 ; case 12
	.short _0222209C - _02221FAE - 2 ; case 13
	.short _02222056 - _02221FAE - 2 ; case 14
	.short _02222056 - _02221FAE - 2 ; case 15
	.short _02222056 - _02221FAE - 2 ; case 16
	.short _02222056 - _02221FAE - 2 ; case 17
	.short _0222209C - _02221FAE - 2 ; case 18
	.short _0222206E - _02221FAE - 2 ; case 19
	.short _0222206E - _02221FAE - 2 ; case 20
	.short _0222206E - _02221FAE - 2 ; case 21
	.short _0222206E - _02221FAE - 2 ; case 22
	.short _02222086 - _02221FAE - 2 ; case 23
	.short _02222086 - _02221FAE - 2 ; case 24
	.short _02222086 - _02221FAE - 2 ; case 25
	.short _02222086 - _02221FAE - 2 ; case 26
	.short _02222086 - _02221FAE - 2 ; case 27
_02221FE6:
	ldr r0, _022220A0 ; =ov08_022259C6
	lsl r1, r2, #1
	ldrsh r6, [r0, r1]
	add r0, r5, #0
	add r0, #0xd
	lsl r0, r0, #2
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	add r2, r6, #0
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
	lsl r0, r5, #2
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	add r2, r6, #0
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
	add r0, r5, #7
	lsl r0, r0, #2
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	add r2, r6, #0
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
	pop {r4, r5, r6, pc}
_02222024:
	ldr r0, _022220A8 ; =ov08_022259C0
	lsl r1, r2, #1
	ldrsh r5, [r0, r1]
	ldr r0, [r4]
	ldrb r0, [r0, #0x11]
	add r2, r5, #0
	lsl r0, r0, #2
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
	ldr r0, [r4]
	add r2, r5, #0
	ldrb r0, [r0, #0x11]
	add r0, r0, #7
	lsl r0, r0, #2
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
	pop {r4, r5, r6, pc}
_02222056:
	add r0, r5, #7
	lsl r0, r0, #2
	lsl r3, r2, #1
	ldr r2, _022220A8 ; =ov08_022259C0
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	ldrsh r2, [r2, r3]
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
	pop {r4, r5, r6, pc}
_0222206E:
	add r0, r5, #2
	lsl r0, r0, #2
	lsl r3, r2, #1
	ldr r2, _022220A8 ; =ov08_022259C0
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	ldrsh r2, [r2, r3]
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
	pop {r4, r5, r6, pc}
_02222086:
	sub r0, r5, #2
	lsl r0, r0, #2
	lsl r3, r2, #1
	ldr r2, _022220A8 ; =ov08_022259C0
	add r1, r4, r0
	ldr r0, _022220A4 ; =0x00001FB8
	ldrsh r2, [r2, r3]
	ldr r0, [r1, r0]
	mov r1, #0
	bl ManagedSprite_OffsetPositionXY
_0222209C:
	pop {r4, r5, r6, pc}
	nop
_022220A0: .word ov08_022259C6
_022220A4: .word 0x00001FB8
_022220A8: .word ov08_022259C0
	thumb_func_end ov08_02221F98

	thumb_func_start ov08_022220AC
ov08_022220AC: ; 0x022220AC
	push {r4, r5, r6, lr}
	ldr r3, _022220F4 ; =0x00001FA3
	add r5, r0, #0
	ldrb r6, [r5, r3]
	mov r2, #0x70
	add r4, r1, #0
	bic r6, r2
	strb r6, [r5, r3]
	cmp r4, #5
	bhi _022220D6
	bl ov08_0221D5DC
	cmp r0, #2
	bne _022220D6
	ldr r1, _022220F4 ; =0x00001FA3
	mov r0, #0x70
	ldrb r2, [r5, r1]
	bic r2, r0
	mov r0, #0x10
	orr r0, r2
	strb r0, [r5, r1]
_022220D6:
	ldr r0, _022220F8 ; =0x00001FA0
	mov r2, #0
	strb r2, [r5, r0]
	add r1, r0, #1
	strb r2, [r5, r1]
	add r1, r0, #2
	strb r4, [r5, r1]
	add r1, r0, #3
	ldrb r2, [r5, r1]
	mov r1, #0x80
	add r0, r0, #3
	orr r1, r2
	strb r1, [r5, r0]
	pop {r4, r5, r6, pc}
	nop
_022220F4: .word 0x00001FA3
_022220F8: .word 0x00001FA0
	thumb_func_end ov08_022220AC

	thumb_func_start ov08_022220FC
ov08_022220FC: ; 0x022220FC
	push {r4, lr}
	ldr r2, _022221C0 ; =0x00001FA3
	add r4, r0, #0
	ldrb r3, [r4, r2]
	lsl r1, r3, #0x18
	lsr r1, r1, #0x1f
	beq _022221BC
	sub r1, r2, #3
	ldrb r1, [r4, r1]
	cmp r1, #0
	beq _0222211C
	cmp r1, #1
	beq _02222150
	cmp r1, #2
	beq _02222184
	pop {r4, pc}
_0222211C:
	sub r1, r2, #1
	ldrb r1, [r4, r1]
	lsl r3, r3, #0x19
	mov r2, #1
	lsr r3, r3, #0x1d
	bl ov08_02221E6C
	ldr r1, _022221C4 ; =0x00001FA2
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #1
	bl ov08_02221EE8
	ldr r1, _022221C4 ; =0x00001FA2
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #1
	bl ov08_02221F98
	ldr r0, _022221C8 ; =0x00001FA1
	mov r1, #0
	strb r1, [r4, r0]
	mov r1, #1
	sub r0, r0, #1
	strb r1, [r4, r0]
	pop {r4, pc}
_02222150:
	sub r1, r2, #1
	ldrb r1, [r4, r1]
	lsl r3, r3, #0x19
	mov r2, #2
	lsr r3, r3, #0x1d
	bl ov08_02221E6C
	ldr r1, _022221C4 ; =0x00001FA2
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #2
	bl ov08_02221EE8
	ldr r1, _022221C4 ; =0x00001FA2
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #2
	bl ov08_02221F98
	ldr r0, _022221C8 ; =0x00001FA1
	mov r1, #0
	strb r1, [r4, r0]
	mov r1, #2
	sub r0, r0, #1
	strb r1, [r4, r0]
	pop {r4, pc}
_02222184:
	sub r1, r2, #1
	ldrb r1, [r4, r1]
	lsl r3, r3, #0x19
	mov r2, #0
	lsr r3, r3, #0x1d
	bl ov08_02221E6C
	ldr r1, _022221C4 ; =0x00001FA2
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #0
	bl ov08_02221EE8
	ldr r1, _022221C4 ; =0x00001FA2
	add r0, r4, #0
	ldrb r1, [r4, r1]
	mov r2, #0
	bl ov08_02221F98
	ldr r0, _022221C8 ; =0x00001FA1
	mov r1, #0
	strb r1, [r4, r0]
	add r1, r0, #2
	ldrb r2, [r4, r1]
	mov r1, #0x80
	add r0, r0, #2
	bic r2, r1
	strb r2, [r4, r0]
_022221BC:
	pop {r4, pc}
	nop
_022221C0: .word 0x00001FA3
_022221C4: .word 0x00001FA2
_022221C8: .word 0x00001FA1
	thumb_func_end ov08_022220FC
