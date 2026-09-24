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

	thumb_func_start ov08_02222524
ov08_02222524: ; 0x02222524
	push {r3, lr}
	add r2, r0, #0
	cmp r1, #3
	bne _02222546
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0x7a
	lsl r0, r0, #2
	mov r1, #0x7e
	lsl r1, r1, #6
	ldr r0, [r2, r0]
	add r1, r2, r1
	mov r2, #1
	mov r3, #0xc0
	bl PaletteData_LoadPalette
	pop {r3, pc}
_02222546:
	mov r0, #0x20
	str r0, [sp]
	mov r0, #0x7a
	lsl r0, r0, #2
	ldr r1, _02222560 ; =0x00001F60
	ldr r0, [r2, r0]
	add r1, r2, r1
	mov r2, #1
	mov r3, #0xc0
	bl PaletteData_LoadPalette
	pop {r3, pc}
	nop
_02222560: .word 0x00001F60
	thumb_func_end ov08_02222524

	thumb_func_start ov08_02222564
ov08_02222564: ; 0x02222564
	push {r4, r5}
	mov r2, #0
	add r1, r2, #0
	mov r3, #0x50
_0222256C:
	add r4, r1, #0
	mul r4, r3
	add r5, r0, r4
	ldrh r4, [r5, #8]
	cmp r4, #0
	beq _02222586
	ldrb r4, [r5, #0x1b]
	lsl r4, r4, #0x18
	lsr r4, r4, #0x1f
	bne _02222586
	add r2, r2, #1
	lsl r2, r2, #0x10
	lsr r2, r2, #0x10
_02222586:
	add r1, r1, #1
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	cmp r1, #6
	blo _0222256C
	cmp r2, #2
	blo _02222598
	mov r0, #1
	b _0222259A
_02222598:
	mov r0, #0
_0222259A:
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	pop {r4, r5}
	bx lr
	.balign 4, 0
	thumb_func_end ov08_02222564

	thumb_func_start ov08_022225A4
ov08_022225A4: ; 0x022225A4
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4]
	ldrb r1, [r1, #0x11]
	bl ov08_0221D5DC
	cmp r0, #2
	bne _022225C4
	ldr r1, [r4]
	add r0, r4, #0
	ldrb r1, [r1, #0x11]
	mov r2, #0
	mov r3, #1
	bl ov08_02221E6C
	pop {r4, pc}
_022225C4:
	ldr r1, [r4]
	mov r2, #0
	ldrb r1, [r1, #0x11]
	add r0, r4, #0
	add r3, r2, #0
	bl ov08_02221E6C
	pop {r4, pc}
	thumb_func_end ov08_022225A4

	thumb_func_start ov08_022225D4
ov08_022225D4: ; 0x022225D4
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, _02222664 ; =ov08_02222670
	ldr r1, _02222668 ; =0x0000115C
	ldr r3, [r5, #0xc]
	mov r2, #0x64
	bl CreateSysTaskAndEnvironment
	bl SysTask_GetData
	ldr r2, _02222668 ; =0x0000115C
	add r4, r0, #0
	mov r1, #0
	bl memset
	str r5, [r4]
	ldr r0, [r5]
	bl BattleSystem_GetBgConfig
	str r0, [r4, #4]
	ldr r0, [r5]
	bl BattleSystem_GetPaletteData
	str r0, [r4, #8]
	ldr r0, _0222266C ; =0x0000114A
	mov r1, #0
	strb r1, [r4, r0]
	ldr r0, [r5]
	bl BattleSystem_GetBagCursor
	add r6, r0, #0
	mov r5, #0
_02222614:
	ldr r3, [r4]
	add r0, r6, #0
	add r2, r3, #0
	add r2, #0x27
	add r3, #0x2c
	add r1, r5, #0
	add r2, r2, r5
	add r3, r3, r5
	bl BagCursor_Battle_PocketGetPosition
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	cmp r5, #5
	blo _02222614
	add r0, r6, #0
	bl BagCursor_Battle_GetLastUsedItem
	ldr r1, [r4]
	strh r0, [r1, #0x20]
	add r0, r6, #0
	bl BagCursor_Battle_GetLastUsedPocket
	ldr r1, [r4]
	strb r0, [r1, #0x1f]
	add r0, r4, #0
	bl ov08_02223B78
	ldr r0, [r4]
	ldr r0, [r0]
	bl BattleSystem_GetBattleType
	mov r1, #1
	lsl r1, r1, #0xa
	tst r0, r1
	beq _02222662
	ldr r0, [r4]
	mov r1, #1
	str r1, [r0, #0x14]
_02222662:
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02222664: .word ov08_02222670
_02222668: .word 0x0000115C
_0222266C: .word 0x0000114A
	thumb_func_end ov08_022225D4

	thumb_func_start ov08_02222670
ov08_02222670: ; 0x02222670
	push {r4, lr}
	ldr r2, _02222768 ; =0x0000114A
	add r4, r1, #0
	ldrb r2, [r4, r2]
	cmp r2, #0xe
	bhi _02222756
	add r2, r2, r2
	add r2, pc
	ldrh r2, [r2, #6]
	lsl r2, r2, #0x10
	asr r2, r2, #0x10
	add pc, r2
_02222688: ; jump table
	.short _022226A6 - _02222688 - 2 ; case 0
	.short _022226B2 - _02222688 - 2 ; case 1
	.short _022226BE - _02222688 - 2 ; case 2
	.short _022226CA - _02222688 - 2 ; case 3
	.short _022226D6 - _02222688 - 2 ; case 4
	.short _022226E2 - _02222688 - 2 ; case 5
	.short _022226EE - _02222688 - 2 ; case 6
	.short _022226FA - _02222688 - 2 ; case 7
	.short _02222706 - _02222688 - 2 ; case 8
	.short _02222712 - _02222688 - 2 ; case 9
	.short _0222271E - _02222688 - 2 ; case 10
	.short _0222272A - _02222688 - 2 ; case 11
	.short _02222736 - _02222688 - 2 ; case 12
	.short _02222742 - _02222688 - 2 ; case 13
	.short _0222274E - _02222688 - 2 ; case 14
_022226A6:
	add r0, r4, #0
	bl ov08_0222276C
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_022226B2:
	add r0, r4, #0
	bl ov08_02222840
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_022226BE:
	add r0, r4, #0
	bl ov08_02222918
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_022226CA:
	add r0, r4, #0
	bl ov08_02222AF0
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_022226D6:
	add r0, r4, #0
	bl ov08_02222D78
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_022226E2:
	add r0, r4, #0
	bl ov08_02222D84
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_022226EE:
	add r0, r4, #0
	bl ov08_02222D90
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_022226FA:
	add r0, r4, #0
	bl ov08_02222A78
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_02222706:
	add r0, r4, #0
	bl ov08_02222D9C
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_02222712:
	add r0, r4, #0
	bl ov08_02222DAC
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_0222271E:
	add r0, r4, #0
	bl ov08_02222DC4
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_0222272A:
	add r0, r4, #0
	bl ov08_02222DEC
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_02222736:
	add r0, r4, #0
	bl ov08_02222EC4
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_02222742:
	add r0, r4, #0
	bl ov08_02222E04
	ldr r1, _02222768 ; =0x0000114A
	strb r0, [r4, r1]
	b _02222756
_0222274E:
	bl ov08_02222E2C
	cmp r0, #1
	beq _02222766
_02222756:
	add r0, r4, #0
	bl ov08_02224974
	mov r0, #0xc3
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl SpriteSystem_DrawSprites
_02222766:
	pop {r4, pc}
	.balign 4, 0
_02222768: .word 0x0000114A
	thumb_func_end ov08_02222670

	thumb_func_start ov08_0222276C
ov08_0222276C: ; 0x0222276C
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, _02222830 ; =0x04001050
	mov r1, #0
	strh r1, [r0]
	ldr r0, [r4]
	ldr r0, [r0, #0xc]
	bl ov08_02224B64
	str r0, [r4, #0x34]
	add r0, r4, #0
	bl ov08_02223000
	add r0, r4, #0
	bl ov08_022230F4
	add r0, r4, #0
	bl ov08_022231E8
	ldr r1, [r4]
	mov r0, #4
	ldr r1, [r1, #0xc]
	bl FontID_Alloc
	ldr r0, [r4]
	ldr r0, [r0]
	bl BattleSystem_GetBagCursor
	bl BagCursor_Battle_GetPocket
	ldr r1, _02222834 ; =0x0000114D
	strb r0, [r4, r1]
	add r0, r4, #0
	bl ov08_02223BF4
	ldr r1, _02222838 ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_02224A50
	add r0, r4, #0
	bl ov08_022233B8
	ldr r1, _02222838 ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_02223480
	add r0, r4, #0
	bl ov08_02223D08
	ldr r1, _02222838 ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_02223F94
	ldr r0, [r4]
	add r0, #0x25
	ldrb r0, [r0]
	cmp r0, #0
	beq _022227F0
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov08_02224B90
_022227F0:
	ldr r1, _02222838 ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_02224134
	ldr r1, _02222838 ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_0222421C
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r1, #0xa
	str r0, [sp, #8]
	add r3, r1, #0
	ldr r0, [r4, #8]
	ldr r2, _0222283C ; =0x0000FFFF
	sub r3, #0x12
	bl PaletteData_BeginPaletteFade
	ldr r0, [r4]
	ldr r0, [r0, #0x14]
	cmp r0, #1
	bne _0222282A
	add sp, #0xc
	mov r0, #0xc
	pop {r3, r4, pc}
_0222282A:
	mov r0, #1
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_02222830: .word 0x04001050
_02222834: .word 0x0000114D
_02222838: .word 0x0000114C
_0222283C: .word 0x0000FFFF
	thumb_func_end ov08_0222276C

	thumb_func_start ov08_02222840
ov08_02222840: ; 0x02222840
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, [r4, #8]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	beq _02222852
	mov r0, #1
	pop {r3, r4, r5, pc}
_02222852:
	ldr r1, _0222290C ; =ov08_02225B4C
	add r0, r4, #0
	bl ov08_02223368
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	bne _02222878
	ldr r0, [r4, #0x34]
	bl ov08_02224C94
	add r5, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	bne _0222287E
	mov r5, #5
	b _0222287E
_02222878:
	add r0, r4, #0
	bl ov08_0222417C
_0222287E:
	cmp r5, #5
	bhi _02222908
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0222288E: ; jump table
	.short _0222289A - _0222288E - 2 ; case 0
	.short _0222289A - _0222288E - 2 ; case 1
	.short _0222289A - _0222288E - 2 ; case 2
	.short _0222289A - _0222288E - 2 ; case 3
	.short _022228BA - _0222288E - 2 ; case 4
	.short _022228EA - _0222288E - 2 ; case 5
_0222289A:
	ldr r0, _02222910 ; =0x000005DD
	bl PlaySE
	lsl r0, r5, #0x18
	lsr r1, r0, #0x18
	ldr r0, _02222914 ; =0x0000114D
	mov r2, #5
	strb r1, [r4, r0]
	sub r0, r0, #2
	strb r2, [r4, r0]
	add r0, r4, #0
	mov r2, #0
	bl ov08_02224938
	mov r0, #0xb
	pop {r3, r4, r5, pc}
_022228BA:
	ldr r0, [r4]
	ldrh r0, [r0, #0x20]
	cmp r0, #0
	beq _02222908
	ldr r0, _02222910 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4]
	ldrb r1, [r0, #0x1f]
	ldr r0, _02222914 ; =0x0000114D
	strb r1, [r4, r0]
	mov r1, #6
	sub r0, r0, #2
	strb r1, [r4, r0]
	add r0, r4, #0
	bl ov08_02223BA8
	add r0, r4, #0
	mov r1, #4
	mov r2, #0
	bl ov08_02224938
	mov r0, #0xb
	pop {r3, r4, r5, pc}
_022228EA:
	ldr r0, _02222910 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4]
	mov r2, #0
	strh r2, [r0, #0x1c]
	ldr r0, [r4]
	mov r1, #4
	strb r1, [r0, #0x1e]
	add r0, r4, #0
	mov r1, #5
	bl ov08_02224938
	mov r0, #0xd
	pop {r3, r4, r5, pc}
_02222908:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0222290C: .word ov08_02225B4C
_02222910: .word 0x000005DD
_02222914: .word 0x0000114D
	thumb_func_end ov08_02222840

	thumb_func_start ov08_02222918
ov08_02222918: ; 0x02222918
	push {r3, r4, r5, r6, r7, lr}
	ldr r1, _02222A64 ; =ov08_02225B68
	add r4, r0, #0
	bl ov08_02223368
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	bne _0222298C
	ldr r0, [r4, #0x34]
	bl ov08_02224B8C
	add r6, r0, #0
	ldr r0, [r4, #0x34]
	bl ov08_02224B88
	add r7, r0, #0
	ldr r0, [r4, #0x34]
	bl ov08_02224C94
	add r5, r0, #0
	ldr r0, [r4, #0x34]
	bl ov08_02224B88
	mov r1, #1
	mvn r1, r1
	cmp r5, r1
	bne _02222956
	mov r5, #6
	b _02222992
_02222956:
	cmp r6, #1
	bne _02222992
	cmp r7, r0
	bne _02222992
	ldr r1, _02222A68 ; =gSystem
	mov r2, #0x20
	ldr r1, [r1, #0x4c]
	tst r2, r1
	beq _02222976
	cmp r0, #0
	beq _02222974
	cmp r0, #2
	beq _02222974
	cmp r0, #4
	bne _02222976
_02222974:
	mov r5, #7
_02222976:
	mov r2, #0x10
	tst r1, r2
	beq _02222992
	cmp r0, #1
	beq _02222988
	cmp r0, #3
	beq _02222988
	cmp r0, #5
	bne _02222992
_02222988:
	mov r5, #8
	b _02222992
_0222298C:
	add r0, r4, #0
	bl ov08_0222417C
_02222992:
	cmp r5, #8
	bhi _02222A60
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022229A2: ; jump table
	.short _022229B4 - _022229A2 - 2 ; case 0
	.short _022229B4 - _022229A2 - 2 ; case 1
	.short _022229B4 - _022229A2 - 2 ; case 2
	.short _022229B4 - _022229A2 - 2 ; case 3
	.short _022229B4 - _022229A2 - 2 ; case 4
	.short _022229B4 - _022229A2 - 2 ; case 5
	.short _022229EA - _022229A2 - 2 ; case 6
	.short _02222A04 - _022229A2 - 2 ; case 7
	.short _02222A32 - _022229A2 - 2 ; case 8
_022229B4:
	add r0, r4, #0
	add r1, r5, #0
	bl ov08_02223CD4
	cmp r0, #0
	beq _02222A60
	ldr r0, _02222A6C ; =0x000005DD
	bl PlaySE
	ldr r0, _02222A70 ; =0x0000114D
	ldr r2, [r4]
	ldrb r1, [r4, r0]
	sub r0, r0, #2
	add r1, r2, r1
	add r1, #0x27
	strb r5, [r1]
	mov r1, #6
	strb r1, [r4, r0]
	add r1, r5, #6
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	mov r2, #0
	bl ov08_02224938
	mov r0, #0xb
	pop {r3, r4, r5, r6, r7, pc}
_022229EA:
	ldr r0, _02222A6C ; =0x000005DD
	bl PlaySE
	ldr r0, _02222A74 ; =0x0000114B
	mov r1, #4
	strb r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0
	bl ov08_02224938
	mov r0, #0xb
	pop {r3, r4, r5, r6, r7, pc}
_02222A04:
	ldr r0, _02222A70 ; =0x0000114D
	ldrb r1, [r4, r0]
	add r0, r0, #7
	add r1, r4, r1
	ldrb r0, [r1, r0]
	cmp r0, #0
	beq _02222A60
	ldr r0, _02222A6C ; =0x000005DD
	bl PlaySE
	ldr r0, _02222A74 ; =0x0000114B
	mov r1, #7
	strb r1, [r4, r0]
	sub r1, #8
	add r0, r0, #3
	strb r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0
	bl ov08_02224938
	mov r0, #0xb
	pop {r3, r4, r5, r6, r7, pc}
_02222A32:
	ldr r0, _02222A70 ; =0x0000114D
	ldrb r1, [r4, r0]
	add r0, r0, #7
	add r1, r4, r1
	ldrb r0, [r1, r0]
	cmp r0, #0
	beq _02222A60
	ldr r0, _02222A6C ; =0x000005DD
	bl PlaySE
	ldr r0, _02222A74 ; =0x0000114B
	mov r1, #7
	strb r1, [r4, r0]
	mov r1, #1
	add r0, r0, #3
	strb r1, [r4, r0]
	add r0, r4, #0
	mov r1, #0xd
	mov r2, #0
	bl ov08_02224938
	mov r0, #0xb
	pop {r3, r4, r5, r6, r7, pc}
_02222A60:
	mov r0, #2
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02222A64: .word ov08_02225B68
_02222A68: .word gSystem
_02222A6C: .word 0x000005DD
_02222A70: .word 0x0000114D
_02222A74: .word 0x0000114B
	thumb_func_end ov08_02222918

	thumb_func_start ov08_02222A78
ov08_02222A78: ; 0x02222A78
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _02222AE8 ; =0x0000114D
	ldr r1, [r4]
	ldrb r2, [r4, r0]
	mov r3, #0
	add r5, r1, r2
	mov r1, #0x2c
	ldrsb r2, [r5, r1]
	add r5, #0x27
	add r1, r0, #1
	strb r3, [r5]
	ldrsb r1, [r4, r1]
	add r1, r2, r1
	lsl r1, r1, #0x18
	asr r2, r1, #0x18
	ldrb r1, [r4, r0]
	add r0, r0, #7
	add r5, r4, r1
	ldrb r5, [r5, r0]
	cmp r2, r5
	ble _02222AAE
	ldr r0, [r4]
	add r0, r0, r1
	add r0, #0x2c
	strb r3, [r0]
	b _02222AC2
_02222AAE:
	cmp r2, #0
	ldr r0, [r4]
	bge _02222ABC
	add r0, r0, r1
	add r0, #0x2c
	strb r5, [r0]
	b _02222AC2
_02222ABC:
	add r0, r0, r1
	add r0, #0x2c
	strb r2, [r0]
_02222AC2:
	add r0, r4, #0
	bl ov08_0222377C
	add r0, r4, #0
	bl ov08_022237C4
	ldr r1, _02222AEC ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_02223F94
	ldr r1, _02222AEC ; =0x0000114C
	add r0, r4, #0
	ldrb r1, [r4, r1]
	bl ov08_02224A50
	mov r0, #2
	pop {r3, r4, r5, pc}
	nop
_02222AE8: .word 0x0000114D
_02222AEC: .word 0x0000114C
	thumb_func_end ov08_02222A78

	thumb_func_start ov08_02222AF0
ov08_02222AF0: ; 0x02222AF0
	push {r3, r4, r5, lr}
	ldr r1, _02222B7C ; =ov08_02225ADC
	add r5, r0, #0
	bl ov08_02223368
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	bne _02222B18
	ldr r0, [r5, #0x34]
	bl ov08_02224C94
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	bne _02222B1E
	mov r4, #1
	b _02222B1E
_02222B18:
	add r0, r5, #0
	bl ov08_0222417C
_02222B1E:
	cmp r4, #0
	beq _02222B28
	cmp r4, #1
	beq _02222B5E
	b _02222B78
_02222B28:
	ldr r0, _02222B80 ; =0x000005DD
	bl PlaySE
	ldr r1, _02222B84 ; =0x0000114D
	ldr r2, [r5]
	ldrb r1, [r5, r1]
	add r0, r5, #0
	add r1, r2, r1
	add r1, #0x27
	ldrb r1, [r1]
	bl ov08_02223CD4
	ldr r1, [r5]
	mov r2, #0
	strh r0, [r1, #0x1c]
	ldr r0, _02222B84 ; =0x0000114D
	ldrb r1, [r5, r0]
	ldr r0, [r5]
	strb r1, [r0, #0x1e]
	add r0, r5, #0
	mov r1, #0xf
	bl ov08_02224938
	add r0, r5, #0
	bl ov08_02222B8C
	pop {r3, r4, r5, pc}
_02222B5E:
	ldr r0, _02222B80 ; =0x000005DD
	bl PlaySE
	ldr r0, _02222B88 ; =0x0000114B
	mov r1, #5
	strb r1, [r5, r0]
	add r0, r5, #0
	mov r1, #0x10
	mov r2, #0
	bl ov08_02224938
	mov r0, #0xb
	pop {r3, r4, r5, pc}
_02222B78:
	mov r0, #3
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02222B7C: .word ov08_02225ADC
_02222B80: .word 0x000005DD
_02222B84: .word 0x0000114D
_02222B88: .word 0x0000114B
	thumb_func_end ov08_02222AF0
