#include "config.h"
#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_70.inc"
	.include "global.inc"

.public ov70_022378C0
.public ov70_02237F38
.public ov70_02237F58
.public ov70_022382C0
.public ov70_02238304
.public ov70_02238C14
.public ov70_02238C8C
.public ov70_02238D84
.public ov70_02238E44
.public ov70_02238E50
.public ov70_02238E58
.public ov70_02238F64
.public ov70_02238F80
.public ov70_02238F9C
.public ov70_0223F658
.public ov70_0223F7E4
.public ov70_0223F8D0
.public ov70_0223F904
.public ov70_02245D60
.public ov70_02245D66
.public ov70_02245D67
.public ov70_02245D6E
.public ov70_02245D76
.public ov70_02245D77
.public ov70_02245D80
.public ov70_02245D81
.public ov70_02245D8A
.public ov70_02245D8B
.public ov70_02245D96
.public ov70_02245DA2
.public ov70_02245DB0
.public ov70_02245DC0
.public ov70_02245DC1
.public ov70_02245DC2
.public ov70_02245DC3
.public ov70_02245DD0
.public ov70_02245DE4
.public ov70_02245DF8
.public ov70_02245DF9
.public ov70_02245E0E
.public ov70_02245E10
.public ov70_02245E26
.public ov70_02245E27
.public ov70_02245E3E
.public ov70_02245E5E
.public ov70_02245E84
.public ov70_02245EA8
.public ov70_02245EA9
.public ov70_02245EAA
.public ov70_02245EAB
.public ov70_02245ED0
.public ov70_02245EFC
.public ov70_02245EFD
.public ov70_02245EFE
.public ov70_02245EFF
.public ov70_02245F28
.public ov70_02245F58
.public ov70_02245F5C
.public ov70_02245FA0
.public ov70_0224600C
.public ov70_02246020
.public ov70_0224603C
.public ov70_02246058
.public ov70_02246074
.public ov70_022466F8
.public ov70_02246780

	.text

	thumb_func_start ov70_02241808
ov70_02241808: ; 0x02241808
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02241828 ; =0x000011F0
	ldr r0, [r4, r0]
	bl Heap_Free
	mov r0, #0x13
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl Heap_Free
	add r0, r4, #0
	bl ov70_02238E58
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_02241828: .word 0x000011F0
	thumb_func_end ov70_02241808

	thumb_func_start ov70_0224182C
ov70_0224182C: ; 0x0224182C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x3d
	bl PlayerProfile_New
	add r4, r0, #0
	bl PlayerProfile_Init
	mov r1, #0x43
	lsl r1, r1, #2
	add r0, r4, #0
	add r1, r5, r1
	bl Save_Profile_PlayerName_Set
	ldr r1, _02241860 ; =0x00000122
	add r0, r4, #0
	ldrb r1, [r5, r1]
	bl PlayerProfile_SetVersion
	ldr r1, _02241864 ; =0x00000123
	add r0, r4, #0
	ldrb r1, [r5, r1]
	bl PlayerProfile_SetLanguage
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02241860: .word 0x00000122
_02241864: .word 0x00000123
	thumb_func_end ov70_0224182C

	thumb_func_start ov70_02241868
ov70_02241868: ; 0x02241868
	push {r3, lr}
	cmp r1, #9
	bne _02241882
	mov r1, #0x26
	lsl r1, r1, #4
	add r2, r0, r1
	mov r1, #0x4b
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	sub r1, #8
	mul r1, r0
	add r0, r2, r1
	pop {r3, pc}
_02241882:
	cmp r1, #0xa
	bne _0224188E
	mov r1, #0x4f
	lsl r1, r1, #2
	add r0, r0, r1
	pop {r3, pc}
_0224188E:
	cmp r1, #8
	bne _0224189A
	mov r1, #0x4f
	lsl r1, r1, #2
	add r0, r0, r1
	pop {r3, pc}
_0224189A:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov70_02241868

	thumb_func_start ov70_022418A4
ov70_022418A4: ; 0x022418A4
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r1, [r5, #0x24]
	bl ov70_02241868
	mov r2, #0x4d
	lsl r2, r2, #2
	add r4, r0, #0
	ldr r0, [r5, r2]
	cmp r0, #0x12
	bne _022418D4
	ldr r0, [r5]
	add r1, r2, #4
	ldr r0, [r0, #8]
	ldr r1, [r5, r1]
	bl Party_GetMonByIndex
	add r1, r0, #0
	add r0, r4, #0
	bl CopyPokemonToPokemon
	add sp, #8
	pop {r3, r4, r5, pc}
_022418D4:
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp]
	ldr r0, [r5]
	ldr r1, [r5, r2]
	add r2, r2, #4
	ldr r0, [r0, #0xc]
	ldr r2, [r5, r2]
	bl PCStorage_DeleteBoxMonByIndexPair
	ldr r0, [r5]
	add r1, sp, #4
	ldr r0, [r0, #0xc]
	add r2, sp, #0
	bl PCStorage_FindFirstEmptySlot
	add r0, r4, #0
	bl Mon_GetBoxMon
	add r2, r0, #0
	ldr r0, [r5]
	ldr r1, [sp, #4]
	ldr r0, [r0, #0xc]
	bl PCStorage_PlaceMonInBoxFirstEmptySlot
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov70_022418A4

	thumb_func_start ov70_0224190C
ov70_0224190C: ; 0x0224190C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	add r4, r0, #0
	cmp r1, #6
	bls _02241918
	b _02241DAA
_02241918:
	add r0, r1, r1
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02241924: ; jump table
	.short _02241A58 - _02241924 - 2 ; case 0
	.short _02241C60 - _02241924 - 2 ; case 1
	.short _02241D00 - _02241924 - 2 ; case 2
	.short _02241BB2 - _02241924 - 2 ; case 3
	.short _02241932 - _02241924 - 2 ; case 4
	.short _022419B2 - _02241924 - 2 ; case 5
	.short _02241B06 - _02241924 - 2 ; case 6
_02241932:
	mov r0, #0
	ldr r6, _02241C68 ; =ov70_02245E0E
	str r0, [sp, #0x28]
	mov r7, #0x30
	add r5, r0, #0
_0224193C:
	ldrb r0, [r6, #1]
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldrb r3, [r6]
	ldr r0, [r4]
	add r1, r1, r5
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x28]
	add r7, r7, #6
	add r0, r0, #1
	add r6, r6, #2
	add r5, #0x10
	str r0, [sp, #0x28]
	cmp r0, #9
	blt _0224193C
	mov r0, #0x11
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	ldr r0, _02241C6C ; =0x0000012F
	mov r3, #9
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xe0
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xe0
	bl FillWindowPixelBuffer
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
_022419B2:
	mov r1, #2
	str r1, [sp]
	mov r0, #3
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r3, #1
	str r3, [sp, #0xc]
	mov r0, #0x30
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r0, [r4]
	lsl r2, r2, #0x18
	ldr r1, [r4, #4]
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	bl FillWindowPixelBuffer
	ldr r6, _02241C70 ; =ov70_02245E10
	mov r7, #1
	mov r5, #0x10
_022419E0:
	sub r0, r6, #1
	ldrb r0, [r0]
	sub r3, r6, #2
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	sub r0, r7, #1
	lsl r0, r0, #2
	add r0, #0x36
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldrb r3, [r3]
	ldr r0, [r4]
	add r1, r1, r5
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, r0, r5
	bl FillWindowPixelBuffer
	add r7, r7, #1
	add r6, r6, #2
	add r5, #0x10
	cmp r7, #4
	blt _022419E0
	mov r0, #0x11
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	ldr r0, _02241C6C ; =0x0000012F
	mov r3, #9
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xe0
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xe0
	bl FillWindowPixelBuffer
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
_02241A58:
	mov r0, #0
	ldr r6, _02241C74 ; =ov70_02245DA2
	str r0, [sp, #0x14]
	mov r7, #0x30
	add r5, r0, #0
_02241A62:
	ldrb r0, [r6, #1]
	str r0, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldrb r3, [r6]
	ldr r0, [r4]
	add r1, r1, r5
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x14]
	add r7, #0x10
	add r0, r0, #1
	add r6, r6, #3
	add r5, #0x10
	str r0, [sp, #0x14]
	cmp r0, #4
	blt _02241A62
	mov r0, #0xe
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	mov r0, #0x70
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0x40
	lsr r2, r2, #0x18
	mov r3, #6
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0x40
	bl FillWindowPixelBuffer
	mov r0, #0x11
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	ldr r0, _02241C6C ; =0x0000012F
	mov r3, #9
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xe0
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xe0
	bl FillWindowPixelBuffer
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
_02241B06:
	mov r0, #0
	ldr r6, _02241C68 ; =ov70_02245E0E
	str r0, [sp, #0x18]
	mov r7, #0x30
	add r5, r0, #0
_02241B10:
	ldrb r0, [r6, #1]
	str r0, [sp]
	mov r0, #3
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldrb r3, [r6]
	ldr r0, [r4]
	add r1, r1, r5
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x18]
	add r7, r7, #6
	add r0, r0, #1
	add r6, r6, #2
	add r5, #0x10
	str r0, [sp, #0x18]
	cmp r0, #9
	blt _02241B10
	mov r0, #0x11
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	ldr r0, _02241C6C ; =0x0000012F
	mov r3, #9
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xe0
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xe0
	bl FillWindowPixelBuffer
	mov r3, #2
	str r3, [sp]
	mov r0, #9
	str r0, [sp, #4]
	str r3, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #0x66
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xf0
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xf0
	bl FillWindowPixelBuffer
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
_02241BB2:
	mov r0, #0
	ldr r6, _02241C78 ; =ov70_02245D96
	str r0, [sp, #0x1c]
	mov r7, #0x30
	add r5, r0, #0
_02241BBC:
	ldrb r0, [r6, #1]
	str r0, [sp]
	mov r0, #0x17
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldrb r3, [r6]
	ldr r0, [r4]
	add r1, r1, r5
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x1c]
	add r7, #0x2e
	add r0, r0, #1
	add r6, r6, #2
	add r5, #0x10
	str r0, [sp, #0x1c]
	cmp r0, #5
	blt _02241BBC
	mov r0, #0x10
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	ldr r0, _02241C7C ; =0x00000116
	mov r3, #0xd
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0x50
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0x50
	bl FillWindowPixelBuffer
	mov r0, #0x11
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	ldr r0, _02241C6C ; =0x0000012F
	mov r3, #0x18
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xe0
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xe0
	bl FillWindowPixelBuffer
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
_02241C60:
	mov r0, #0
	ldr r6, _02241C80 ; =ov70_02245D60
	b _02241C84
	nop
_02241C68: .word ov70_02245E0E
_02241C6C: .word 0x0000012F
_02241C70: .word ov70_02245E10
_02241C74: .word ov70_02245DA2
_02241C78: .word ov70_02245D96
_02241C7C: .word 0x00000116
_02241C80: .word ov70_02245D60
_02241C84:
	str r0, [sp, #0x20]
	mov r7, #0x30
	add r5, r0, #0
_02241C8A:
	ldrb r0, [r6, #1]
	str r0, [sp]
	mov r0, #8
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldrb r3, [r6]
	ldr r0, [r4]
	add r1, r1, r5
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x20]
	add r7, #0x10
	add r0, r0, #1
	add r6, r6, #2
	add r5, #0x10
	str r0, [sp, #0x20]
	cmp r0, #3
	blt _02241C8A
	mov r0, #0x11
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #0x60
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xe0
	lsr r2, r2, #0x18
	mov r3, #9
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xe0
	bl FillWindowPixelBuffer
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
_02241D00:
	mov r0, #0
	ldr r6, _02241DB0 ; =ov70_02245D6E
	str r0, [sp, #0x24]
	mov r7, #0x30
	add r5, r0, #0
_02241D0A:
	ldrb r0, [r6, #1]
	str r0, [sp]
	mov r0, #0xb
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	lsl r0, r7, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldrb r3, [r6]
	ldr r0, [r4]
	add r1, r1, r5
	lsr r2, r2, #0x18
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [sp, #0x24]
	add r7, #0x16
	add r0, r0, #1
	add r6, r6, #2
	add r5, #0x10
	str r0, [sp, #0x24]
	cmp r0, #4
	blt _02241D0A
	mov r0, #0xe
	str r0, [sp]
	mov r0, #5
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	str r0, [sp, #0xc]
	mov r0, #0x88
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0x40
	lsr r2, r2, #0x18
	mov r3, #6
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0x40
	bl FillWindowPixelBuffer
	mov r0, #0x11
	str r0, [sp]
	mov r0, #6
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	mov r0, #0xa1
	str r0, [sp, #0x10]
	ldr r2, [r4, #0x54]
	ldr r1, [r4, #4]
	lsl r2, r2, #0x18
	ldr r0, [r4]
	add r1, #0xe0
	lsr r2, r2, #0x18
	mov r3, #9
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0x22
	add r0, #0xe0
	bl FillWindowPixelBuffer
_02241DAA:
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	nop
_02241DB0: .word ov70_02245D6E
	thumb_func_end ov70_0224190C

	thumb_func_start ov70_02241DB4
ov70_02241DB4: ; 0x02241DB4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r2, sp, #0x10
	add r5, r1, #0
	ldr r0, [r4, #0x1c]
	mov r1, #0
	add r2, #1
	add r3, sp, #0x10
	bl sub_02019B1C
	cmp r5, #6
	bls _02241DD0
	b _02242010
_02241DD0:
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02241DDC: ; jump table
	.short _02241EA6 - _02241DDC - 2 ; case 0
	.short _02241FD4 - _02241DDC - 2 ; case 1
	.short _02241FF4 - _02241DDC - 2 ; case 2
	.short _02241F6A - _02241DDC - 2 ; case 3
	.short _02241DEA - _02241DDC - 2 ; case 4
	.short _02241E48 - _02241DDC - 2 ; case 5
	.short _02241F04 - _02241DDC - 2 ; case 6
_02241DEA:
	mov r6, #0
	add r5, r6, #0
	mov r7, #0x22
_02241DF0:
	ldr r0, [r4, #4]
	add r1, r7, #0
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl CopyWindowPixelsToVram_TextMode
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl RemoveWindow
	add r6, r6, #1
	add r5, #0x10
	cmp r6, #9
	blt _02241DF0
	add r0, sp, #0x10
	mov r1, #1
	ldrsb r0, [r0, r1]
	cmp r0, #0x10
	bne _02241E3C
	str r1, [sp]
	mov r0, #0xf
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r1, #2
	mov r2, #5
	mov r3, #0x11
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
_02241E3C:
	ldr r0, [r4, #4]
	add r0, #0xe0
	bl RemoveWindow
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02241E48:
	mov r6, #0
	add r5, r6, #0
	mov r7, #0x22
_02241E4E:
	ldr r0, [r4, #4]
	add r1, r7, #0
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl CopyWindowPixelsToVram_TextMode
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl RemoveWindow
	add r6, r6, #1
	add r5, #0x10
	cmp r6, #4
	blt _02241E4E
	add r0, sp, #0x10
	mov r1, #1
	ldrsb r0, [r0, r1]
	cmp r0, #0x10
	bne _02241E9A
	str r1, [sp]
	mov r0, #0xf
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r1, #2
	mov r2, #5
	mov r3, #0x11
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
_02241E9A:
	ldr r0, [r4, #4]
	add r0, #0xe0
	bl RemoveWindow
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02241EA6:
	mov r6, #0
	add r5, r6, #0
	mov r7, #0x22
_02241EAC:
	ldr r0, [r4, #4]
	add r1, r7, #0
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl CopyWindowPixelsToVram_TextMode
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl RemoveWindow
	add r6, r6, #1
	add r5, #0x10
	cmp r6, #5
	blt _02241EAC
	add r0, sp, #0x10
	mov r1, #1
	ldrsb r0, [r0, r1]
	cmp r0, #0x10
	bne _02241EF8
	str r1, [sp]
	mov r0, #0xf
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r1, #2
	mov r2, #5
	mov r3, #0x11
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
_02241EF8:
	ldr r0, [r4, #4]
	add r0, #0xe0
	bl RemoveWindow
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02241F04:
	mov r6, #0
	add r5, r6, #0
	mov r7, #0x22
_02241F0A:
	ldr r0, [r4, #4]
	add r1, r7, #0
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl CopyWindowPixelsToVram_TextMode
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl RemoveWindow
	add r6, r6, #1
	add r5, #0x10
	cmp r6, #9
	blt _02241F0A
	add r0, sp, #0x10
	mov r1, #1
	ldrsb r0, [r0, r1]
	cmp r0, #0x10
	bne _02241F56
	str r1, [sp]
	mov r0, #0xf
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r1, #2
	mov r2, #5
	mov r3, #0x11
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
_02241F56:
	ldr r0, [r4, #4]
	add r0, #0xe0
	bl RemoveWindow
	ldr r0, [r4, #4]
	add r0, #0xf0
	bl RemoveWindow
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02241F6A:
	mov r6, #0
	add r5, r6, #0
	mov r7, #0x22
_02241F70:
	ldr r0, [r4, #4]
	add r1, r7, #0
	add r0, r0, r5
	bl FillWindowPixelBuffer
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl CopyWindowPixelsToVram_TextMode
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl RemoveWindow
	add r6, r6, #1
	add r5, #0x10
	cmp r6, #6
	blt _02241F70
	add r0, sp, #0x10
	mov r1, #1
	ldrsb r0, [r0, r1]
	sub r0, #0x10
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r0, #1
	bhi _02241FC8
	str r1, [sp]
	mov r0, #0xe
	str r0, [sp, #4]
	mov r0, #0xf
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4]
	mov r1, #2
	mov r2, #5
	mov r3, #0x12
	bl FillBgTilemapRect
	ldr r0, [r4]
	mov r1, #2
	bl BgCommitTilemapBufferToVram
_02241FC8:
	ldr r0, [r4, #4]
	add r0, #0xe0
	bl RemoveWindow
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02241FD4:
	mov r6, #0
	add r5, r6, #0
_02241FD8:
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl RemoveWindow
	add r6, r6, #1
	add r5, #0x10
	cmp r6, #3
	blt _02241FD8
	ldr r0, [r4, #4]
	add r0, #0xe0
	bl RemoveWindow
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
_02241FF4:
	mov r6, #0
	add r5, r6, #0
_02241FF8:
	ldr r0, [r4, #4]
	add r0, r0, r5
	bl RemoveWindow
	add r6, r6, #1
	add r5, #0x10
	cmp r6, #5
	blt _02241FF8
	ldr r0, [r4, #4]
	add r0, #0xe0
	bl RemoveWindow
_02242010:
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov70_02241DB4

	thumb_func_start ov70_02242014
ov70_02242014: ; 0x02242014
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	mov r0, #0x3d
	mov r1, #0x80
	add r7, r2, #0
	bl Heap_Alloc
	add r4, r0, #0
	ldr r0, [r5]
	mov r1, #0
	str r0, [r4]
	ldr r0, [r5, #4]
	mov r2, #1
	str r0, [r4, #4]
	ldr r0, [r5, #8]
	mov r3, #0x3d
	str r0, [r4, #8]
	ldr r0, [r5, #0xc]
	str r0, [r4, #0xc]
	ldr r0, [r5, #0x10]
	str r0, [r4, #0x10]
	ldr r0, [r5, #0x14]
	str r0, [r4, #0x14]
	ldr r0, [r5, #0x18]
	str r0, [r4, #0x18]
	ldr r0, [r5, #0x1c]
	str r0, [r4, #0x24]
	ldr r0, [r5, #0x20]
	str r0, [r4, #0x28]
	ldr r0, [r5, #0x24]
	str r0, [r4, #0x2c]
	ldr r0, [r5, #0x28]
	str r0, [r4, #0x20]
	ldr r0, [r5, #0x2c]
	str r0, [r4, #0x30]
	str r6, [r4, #0x54]
	str r7, [r4, #0x60]
	strh r1, [r4, #0x3c]
	add r0, r4, #0
	strh r1, [r4, #0x3e]
	add r0, #0x40
	strh r1, [r0]
	add r0, r4, #0
	add r0, #0x42
	strh r1, [r0]
	add r0, r4, #0
	add r0, #0x44
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0x45
	strb r1, [r0]
	add r0, r4, #0
	str r1, [r4, #0x48]
	add r0, #0x7e
	strb r1, [r0]
	str r1, [r4, #0x4c]
	ldr r0, [r4]
	mov r1, #2
	bl sub_0201956C
	str r0, [r4, #0x1c]
	mov r0, #0x14
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	mov r1, #0
	mov r2, #2
	mov r3, #0x20
	bl sub_020195F4
	ldr r0, [r4, #0xc]
	mov r1, #0x88
	mov r2, #0x28
	bl ov70_02238F9C
	ldr r0, [r4, #0xc]
	mov r1, #0x2f
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0xf
	mov r1, #0xe
	mov r2, #2
	mov r3, #0x3d
	bl MessagePrinter_New
	str r0, [r4, #0x38]
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov70_02242014

	thumb_func_start ov70_022420C4
ov70_022420C4: ; 0x022420C4
	add r2, r0, #0
	add r2, #0x58
	strh r1, [r2]
	cmp r1, #3
	bhi _02242128
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022420DA: ; jump table
	.short _022420E2 - _022420DA - 2 ; case 0
	.short _0224210A - _022420DA - 2 ; case 1
	.short _0224211A - _022420DA - 2 ; case 2
	.short _022420F6 - _022420DA - 2 ; case 3
_022420E2:
	mov r2, #0
	add r1, r0, #0
	str r2, [r0, #0x48]
	add r1, #0x7e
	strb r2, [r1]
	strh r2, [r0, #0x3c]
	strh r2, [r0, #0x3e]
	mov r1, #4
	str r1, [r0, #0x4c]
	bx lr
_022420F6:
	mov r2, #0
	add r1, r0, #0
	str r2, [r0, #0x48]
	add r1, #0x7e
	strb r2, [r1]
	strh r2, [r0, #0x3c]
	strh r2, [r0, #0x3e]
	mov r1, #0x10
	str r1, [r0, #0x4c]
	bx lr
_0224210A:
	mov r2, #0
	add r1, r0, #0
	str r2, [r0, #0x48]
	add r1, #0x7e
	strb r2, [r1]
	mov r1, #0x1c
	str r1, [r0, #0x4c]
	bx lr
_0224211A:
	mov r2, #0
	add r1, r0, #0
	str r2, [r0, #0x48]
	add r1, #0x7e
	strb r2, [r1]
	mov r1, #0x1f
	str r1, [r0, #0x4c]
_02242128:
	bx lr
	.balign 4, 0
	thumb_func_end ov70_022420C4

	thumb_func_start ov70_0224212C
ov70_0224212C: ; 0x0224212C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x38]
	bl MessagePrinter_Delete
	ldr r0, [r4, #0x1c]
	bl sub_020195C0
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov70_0224212C

	thumb_func_start ov70_02242144
ov70_02242144: ; 0x02242144
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x4c]
	lsl r2, r1, #2
	ldr r1, _02242160 ; =ov70_022466F8
	ldr r1, [r1, r2]
	blx r1
	add r5, r0, #0
	ldr r0, [r4, #0x1c]
	bl sub_02019934
	add r0, r5, #0
	pop {r3, r4, r5, pc}
	nop
_02242160: .word ov70_022466F8
	thumb_func_end ov70_02242144

	thumb_func_start ov70_02242164
ov70_02242164: ; 0x02242164
	push {r3, lr}
	cmp r1, #7
	bhi _022421B4
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02242176: ; jump table
	.short _02242196 - _02242176 - 2 ; case 0
	.short _0224219E - _02242176 - 2 ; case 1
	.short _02242196 - _02242176 - 2 ; case 2
	.short _022421A6 - _02242176 - 2 ; case 3
	.short _02242186 - _02242176 - 2 ; case 4
	.short _022421AE - _02242176 - 2 ; case 5
	.short _0224218E - _02242176 - 2 ; case 6
	.short _022421AE - _02242176 - 2 ; case 7
_02242186:
	ldr r0, _022421B8 ; =ov70_02245ED0
	bl TouchscreenHitbox_FindRectAtTouchNew
	pop {r3, pc}
_0224218E:
	ldr r0, _022421BC ; =ov70_02245F28
	bl TouchscreenHitbox_FindRectAtTouchNew
	pop {r3, pc}
_02242196:
	ldr r0, _022421C0 ; =ov70_02245E3E
	bl TouchscreenHitbox_FindRectAtTouchNew
	pop {r3, pc}
_0224219E:
	ldr r0, _022421C4 ; =ov70_02245DD0
	bl TouchscreenHitbox_FindRectAtTouchNew
	pop {r3, pc}
_022421A6:
	ldr r0, _022421C8 ; =ov70_02245E5E
	bl TouchscreenHitbox_FindRectAtTouchNew
	pop {r3, pc}
_022421AE:
	ldr r0, _022421CC ; =ov70_02245DE4
	bl TouchscreenHitbox_FindRectAtTouchNew
_022421B4:
	pop {r3, pc}
	nop
_022421B8: .word ov70_02245ED0
_022421BC: .word ov70_02245F28
_022421C0: .word ov70_02245E3E
_022421C4: .word ov70_02245DD0
_022421C8: .word ov70_02245E5E
_022421CC: .word ov70_02245DE4
	thumb_func_end ov70_02242164

	thumb_func_start ov70_022421D0
ov70_022421D0: ; 0x022421D0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	ldr r1, [r5, #0x48]
	cmp r1, #9
	bge _022421E0
	add r0, #0x7e
	strb r1, [r0]
_022421E0:
	ldr r0, _02242344 ; =gSystem
	mov r2, #0x40
	ldr r0, [r0, #0x4c]
	tst r2, r0
	beq _022421F6
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _02242348 ; =ov70_02245EA8
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _0224222A
_022421F6:
	mov r2, #0x80
	tst r2, r0
	beq _02242208
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _0224234C ; =ov70_02245EA9
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _0224222A
_02242208:
	mov r2, #0x20
	tst r2, r0
	beq _0224221A
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _02242350 ; =ov70_02245EAA
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _0224222A
_0224221A:
	mov r2, #0x10
	tst r0, r2
	beq _0224222A
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _02242354 ; =ov70_02245EAB
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
_0224222A:
	cmp r1, #9
	blt _02242282
	ldr r0, [r5, #0x48]
	cmp r0, #9
	bge _02242282
	ldr r0, _02242344 ; =gSystem
	ldr r2, [r0, #0x4c]
	mov r0, #0x40
	tst r0, r2
	beq _02242260
	add r0, r5, #0
	add r0, #0x7e
	ldrb r0, [r0]
	str r0, [r5, #0x48]
	add r0, r0, #4
	cmp r0, #9
	bge _02242282
	add r0, r5, #0
	add r0, #0x48
_02242250:
	ldr r2, [r0]
	add r2, r2, #4
	str r2, [r0]
	ldr r2, [r5, #0x48]
	add r2, r2, #4
	cmp r2, #9
	blt _02242250
	b _02242282
_02242260:
	mov r0, #0x80
	tst r0, r2
	beq _02242282
	add r0, r5, #0
	add r0, #0x7e
	ldrb r0, [r0]
	str r0, [r5, #0x48]
	sub r0, r0, #4
	bmi _02242282
	add r0, r5, #0
	add r0, #0x48
_02242276:
	ldr r2, [r0]
	sub r2, r2, #4
	str r2, [r0]
	ldr r2, [r5, #0x48]
	sub r2, r2, #4
	bpl _02242276
_02242282:
	ldr r0, [r5, #0x48]
	cmp r1, r0
	beq _022422BC
	ldr r0, _02242358 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	ldr r1, _0224235C ; =ov70_02245E26
	lsl r2, r0, #1
	ldrb r1, [r1, r2]
	ldr r3, _02242360 ; =ov70_02245E27
	ldr r0, [r5, #0xc]
	ldrb r2, [r3, r2]
	add r1, #0x10
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	ldr r0, [r5, #0x48]
	cmp r0, #9
	ldr r0, [r5, #0xc]
	bne _022422B6
	mov r1, #0x30
	bl Sprite_SetAnimCtrlSeq
	b _022422BC
_022422B6:
	mov r1, #0x3d
	bl Sprite_SetAnimCtrlSeq
_022422BC:
	add r0, r5, #0
	mov r1, #4
	bl ov70_02242164
	add r6, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r6, r0
	beq _022422F8
	cmp r6, #9
	bne _022422DE
	ldr r0, _02242358 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
	pop {r4, r5, r6, pc}
_022422DE:
	blo _022422E4
	bl GF_AssertFail
_022422E4:
	cmp r4, #0
	beq _022422EE
	ldrb r0, [r4, r6]
	cmp r0, #0
	beq _0224233C
_022422EE:
	ldr r0, _02242358 ; =0x000005DC
	bl PlaySE
	add r0, r6, #0
	pop {r4, r5, r6, pc}
_022422F8:
	ldr r0, _02242344 ; =gSystem
	ldr r2, [r0, #0x48]
	mov r0, #1
	add r1, r2, #0
	tst r1, r0
	beq _0224232A
	ldr r1, [r5, #0x48]
	cmp r1, #9
	bne _0224230E
	sub r0, r0, #3
	pop {r4, r5, r6, pc}
_0224230E:
	blt _02242314
	bl GF_AssertFail
_02242314:
	cmp r4, #0
	beq _02242320
	ldr r0, [r5, #0x48]
	ldrb r0, [r4, r0]
	cmp r0, #0
	beq _0224233C
_02242320:
	ldr r0, _02242358 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	pop {r4, r5, r6, pc}
_0224232A:
	mov r0, #2
	tst r0, r2
	beq _0224233C
	ldr r0, _02242358 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
	pop {r4, r5, r6, pc}
_0224233C:
	mov r0, #0
	mvn r0, r0
	pop {r4, r5, r6, pc}
	nop
_02242344: .word gSystem
_02242348: .word ov70_02245EA8
_0224234C: .word ov70_02245EA9
_02242350: .word ov70_02245EAA
_02242354: .word ov70_02245EAB
_02242358: .word 0x000005DC
_0224235C: .word ov70_02245E26
_02242360: .word ov70_02245E27
	thumb_func_end ov70_022421D0

	thumb_func_start ov70_02242364
ov70_02242364: ; 0x02242364
	cmp r1, #3
	beq _02242386
	mov r2, #0x3c
	ldrsh r0, [r0, r2]
	cmp r0, #8
	bgt _02242382
	lsl r3, r0, #3
	ldr r0, _0224238C ; =ov70_02245F5C
	ldr r0, [r0, r3]
	cmp r1, r0
	blt _0224237E
	add r1, r2, #0
	sub r1, #0x3d
_0224237E:
	add r0, r1, #0
	bx lr
_02242382:
	add r0, r1, #0
	bx lr
_02242386:
	mov r0, #1
	mvn r0, r0
	bx lr
	.balign 4, 0
_0224238C: .word ov70_02245F5C
	thumb_func_end ov70_02242364

	thumb_func_start ov70_02242390
ov70_02242390: ; 0x02242390
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	ldr r1, [r5, #0x48]
	cmp r1, #3
	bge _022423A0
	add r0, #0x7e
	strb r1, [r0]
_022423A0:
	ldr r0, _022424E4 ; =gSystem
	mov r2, #0x40
	ldr r0, [r0, #0x4c]
	tst r2, r0
	beq _022423B6
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _022424E8 ; =ov70_02245DC0
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _022423EA
_022423B6:
	mov r2, #0x80
	tst r2, r0
	beq _022423C8
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _022424EC ; =ov70_02245DC1
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _022423EA
_022423C8:
	mov r2, #0x20
	tst r2, r0
	beq _022423DA
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _022424F0 ; =ov70_02245DC2
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _022423EA
_022423DA:
	mov r2, #0x10
	tst r0, r2
	beq _022423EA
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _022424F4 ; =ov70_02245DC3
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
_022423EA:
	cmp r1, #3
	bne _022423FC
	ldr r0, [r5, #0x48]
	cmp r0, #3
	bge _022423FC
	add r0, r5, #0
	add r0, #0x7e
	ldrb r0, [r0]
	str r0, [r5, #0x48]
_022423FC:
	ldr r0, [r5, #0x48]
	cmp r1, r0
	beq _02242440
	ldr r0, _022424F8 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	cmp r0, #3
	bne _02242422
	ldr r0, [r5, #0xc]
	mov r1, #0xc0
	mov r2, #0x88
	bl ov70_02238F9C
	ldr r0, [r5, #0xc]
	mov r1, #0x30
	bl Sprite_SetAnimCtrlSeq
	b _02242440
_02242422:
	ldr r1, _022424FC ; =ov70_02245E26
	lsl r2, r0, #1
	ldrb r1, [r1, r2]
	ldr r3, _02242500 ; =ov70_02245E27
	ldr r0, [r5, #0xc]
	ldrb r2, [r3, r2]
	add r1, #0x10
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	ldr r0, [r5, #0xc]
	mov r1, #0x2f
	bl Sprite_SetAnimCtrlSeq
_02242440:
	add r0, r5, #0
	mov r1, #5
	bl ov70_02242164
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _02242488
	add r0, r5, #0
	bl ov70_02242364
	mov r1, #0
	add r6, r0, #0
	mvn r1, r1
	cmp r6, r1
	beq _022424E0
	sub r0, r1, #1
	cmp r6, r0
	beq _0224247E
	cmp r4, #0
	beq _0224247E
	mov r0, #0x3c
	ldrsh r0, [r5, r0]
	lsl r1, r0, #2
	ldr r0, _02242504 ; =ov70_02245E84
	ldr r1, [r0, r1]
	add r0, r4, r6
	ldrb r0, [r1, r0]
	cmp r0, #0
	beq _022424DC
_0224247E:
	ldr r0, _022424F8 ; =0x000005DC
	bl PlaySE
	add r0, r6, #0
	pop {r4, r5, r6, pc}
_02242488:
	ldr r0, _022424E4 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	beq _022424CA
	ldr r1, [r5, #0x48]
	add r0, r5, #0
	bl ov70_02242364
	mov r1, #0
	add r6, r0, #0
	mvn r1, r1
	cmp r6, r1
	beq _022424E0
	sub r0, r1, #1
	cmp r6, r0
	beq _022424C0
	cmp r4, #0
	beq _022424C0
	mov r0, #0x3c
	ldrsh r0, [r5, r0]
	lsl r1, r0, #2
	ldr r0, _02242504 ; =ov70_02245E84
	ldr r1, [r0, r1]
	add r0, r4, r6
	ldrb r0, [r1, r0]
	cmp r0, #0
	beq _022424DC
_022424C0:
	ldr r0, _022424F8 ; =0x000005DC
	bl PlaySE
	add r0, r6, #0
	pop {r4, r5, r6, pc}
_022424CA:
	mov r0, #2
	tst r0, r1
	beq _022424DC
	ldr r0, _022424F8 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
	pop {r4, r5, r6, pc}
_022424DC:
	mov r0, #0
	mvn r0, r0
_022424E0:
	pop {r4, r5, r6, pc}
	nop
_022424E4: .word gSystem
_022424E8: .word ov70_02245DC0
_022424EC: .word ov70_02245DC1
_022424F0: .word ov70_02245DC2
_022424F4: .word ov70_02245DC3
_022424F8: .word 0x000005DC
_022424FC: .word ov70_02245E26
_02242500: .word ov70_02245E27
_02242504: .word ov70_02245E84
	thumb_func_end ov70_02242390

	thumb_func_start ov70_02242508
ov70_02242508: ; 0x02242508
	push {r3, lr}
	cmp r0, #0
	bne _02242512
	mov r0, #1
	pop {r3, pc}
_02242512:
	sub r2, r1, #1
	add r0, r0, r2
	bl _s32_div_f
	pop {r3, pc}
	thumb_func_end ov70_02242508

	thumb_func_start ov70_0224251C
ov70_0224251C: ; 0x0224251C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	cmp r1, #4
	beq _0224252E
	cmp r1, #5
	beq _02242534
	cmp r1, #6
	beq _02242542
	b _0224254E
_0224252E:
	mov r0, #1
	mvn r0, r0
	pop {r3, r4, r5, pc}
_02242534:
	mov r1, #0
	mvn r1, r1
	bl ov70_02242574
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
_02242542:
	mov r1, #1
	bl ov70_02242574
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
_0224254E:
	mov r0, #0x5a
	ldrsh r2, [r5, r0]
	lsl r2, r2, #2
	add r4, r1, r2
	ldr r1, [r5, #0x5c]
	cmp r4, r1
	bge _0224256C
	ldr r0, _02242570 ; =0x000005DC
	bl PlaySE
	ldr r1, [r5, #0x34]
	lsl r0, r4, #3
	add r0, r1, r0
	ldr r0, [r0, #4]
	pop {r3, r4, r5, pc}
_0224256C:
	sub r0, #0x5b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02242570: .word 0x000005DC
	thumb_func_end ov70_0224251C

	thumb_func_start ov70_02242574
ov70_02242574: ; 0x02242574
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	ldr r0, [r5, #0x5c]
	add r6, r1, #0
	mov r1, #4
	bl ov70_02242508
	sub r4, r0, #1
	beq _02242616
	cmp r6, #0
	bge _022425BE
	mov r0, #0x5e
	lsl r0, r0, #4
	bl PlaySE
	ldr r0, [r5, #0x14]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	ldr r0, [r5, #0x14]
	mov r1, #0x27
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x5a
	ldrsh r0, [r5, r0]
	cmp r0, #0
	beq _022425B6
	sub r1, r0, #1
	add r0, r5, #0
	add r0, #0x5a
	strh r1, [r0]
	b _022425F0
_022425B6:
	add r0, r5, #0
	add r0, #0x5a
	strh r4, [r0]
	b _022425F0
_022425BE:
	mov r0, #0x5e
	lsl r0, r0, #4
	bl PlaySE
	ldr r0, [r5, #0x10]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	ldr r0, [r5, #0x10]
	mov r1, #0x26
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x5a
	ldrsh r0, [r5, r0]
	cmp r0, r4
	bge _022425E8
	add r1, r0, #1
	add r0, r5, #0
	add r0, #0x5a
	strh r1, [r0]
	b _022425F0
_022425E8:
	add r0, r5, #0
	mov r1, #0
	add r0, #0x5a
	strh r1, [r0]
_022425F0:
	mov r1, #0x5a
	ldrsh r1, [r5, r1]
	ldr r2, [r5, #0x5c]
	add r0, r5, #0
	bl ov70_022434C0
	ldr r0, [r5, #0x5c]
	mov r1, #4
	bl ov70_02242508
	str r0, [sp]
	mov r3, #0x5a
	ldr r2, [r5, #4]
	ldrsh r3, [r5, r3]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x38]
	add r2, #0x40
	bl ov70_02243F00
_02242616:
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov70_02242574

	thumb_func_start ov70_0224261C
ov70_0224261C: ; 0x0224261C
	push {r3, r4, r5, lr}
	ldr r1, _022426E4 ; =gSystem
	add r5, r0, #0
	ldr r2, [r1, #0x4c]
	mov r1, #0x40
	ldr r4, [r5, #0x48]
	tst r1, r2
	beq _0224263C
	cmp r4, #0
	beq _02242636
	sub r0, r4, #1
	str r0, [r5, #0x48]
	b _0224266E
_02242636:
	mov r0, #4
	str r0, [r5, #0x48]
	b _0224266E
_0224263C:
	mov r1, #0x80
	tst r1, r2
	beq _02242652
	cmp r4, #4
	beq _0224264C
	add r0, r4, #1
	str r0, [r5, #0x48]
	b _0224266E
_0224264C:
	mov r0, #0
	str r0, [r5, #0x48]
	b _0224266E
_02242652:
	mov r1, #0x20
	add r3, r2, #0
	tst r3, r1
	beq _02242662
	sub r1, #0x21
	bl ov70_02242574
	b _0224266E
_02242662:
	mov r1, #0x10
	tst r1, r2
	beq _0224266E
	mov r1, #1
	bl ov70_02242574
_0224266E:
	ldr r0, [r5, #0x48]
	cmp r4, r0
	beq _022426A2
	ldr r0, _022426E8 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	ldr r1, _022426EC ; =ov70_02245D76
	lsl r3, r0, #1
	ldr r2, _022426F0 ; =ov70_02245D77
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r5, #0xc]
	bl ov70_02238F9C
	ldr r0, [r5, #0x48]
	cmp r0, #4
	ldr r0, [r5, #0xc]
	bne _0224269C
	mov r1, #0x30
	bl Sprite_SetAnimCtrlSeq
	b _022426A2
_0224269C:
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
_022426A2:
	add r0, r5, #0
	mov r1, #0
	bl ov70_02242164
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _022426BC
	add r0, r5, #0
	bl ov70_0224251C
	pop {r3, r4, r5, pc}
_022426BC:
	ldr r1, _022426E4 ; =gSystem
	ldr r2, [r1, #0x48]
	mov r1, #1
	tst r1, r2
	beq _022426D0
	ldr r1, [r5, #0x48]
	add r0, r5, #0
	bl ov70_0224251C
	pop {r3, r4, r5, pc}
_022426D0:
	mov r1, #2
	tst r1, r2
	beq _022426E0
	ldr r0, _022426E8 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
_022426E0:
	pop {r3, r4, r5, pc}
	nop
_022426E4: .word gSystem
_022426E8: .word 0x000005DC
_022426EC: .word ov70_02245D76
_022426F0: .word ov70_02245D77
	thumb_func_end ov70_0224261C

	thumb_func_start ov70_022426F4
ov70_022426F4: ; 0x022426F4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _022427B0 ; =gSystem
	ldr r4, [r5, #0x48]
	ldr r1, [r0, #0x4c]
	mov r0, #0x40
	tst r0, r1
	beq _0224271C
	ldr r0, _022427B4 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	cmp r0, #0
	beq _02242716
	sub r0, r0, #1
	str r0, [r5, #0x48]
	b _02242738
_02242716:
	mov r0, #3
	str r0, [r5, #0x48]
	b _02242738
_0224271C:
	mov r0, #0x80
	tst r0, r1
	beq _02242738
	ldr r0, _022427B4 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	cmp r0, #3
	beq _02242734
	add r0, r0, #1
	str r0, [r5, #0x48]
	b _02242738
_02242734:
	mov r0, #0
	str r0, [r5, #0x48]
_02242738:
	ldr r0, [r5, #0x48]
	cmp r4, r0
	beq _02242764
	ldr r1, _022427B8 ; =ov70_02245D66
	lsl r3, r0, #1
	ldr r2, _022427BC ; =ov70_02245D67
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r5, #0xc]
	bl ov70_02238F9C
	ldr r0, [r5, #0x48]
	cmp r0, #3
	ldr r0, [r5, #0xc]
	bne _0224275E
	mov r1, #0x30
	bl Sprite_SetAnimCtrlSeq
	b _02242764
_0224275E:
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
_02242764:
	add r0, r5, #0
	mov r1, #1
	bl ov70_02242164
	add r4, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r4, r0
	beq _02242784
	ldr r0, _022427B4 ; =0x000005DC
	bl PlaySE
	ldr r0, _022427C0 ; =ov70_02245DB0
	lsl r1, r4, #2
	ldr r0, [r0, r1]
	pop {r3, r4, r5, pc}
_02242784:
	ldr r1, _022427B0 ; =gSystem
	ldr r2, [r1, #0x48]
	mov r1, #1
	tst r1, r2
	beq _0224279E
	ldr r0, _022427B4 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	lsl r1, r0, #2
	ldr r0, _022427C0 ; =ov70_02245DB0
	ldr r0, [r0, r1]
	pop {r3, r4, r5, pc}
_0224279E:
	mov r1, #2
	tst r1, r2
	beq _022427AE
	ldr r0, _022427B4 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
_022427AE:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022427B0: .word gSystem
_022427B4: .word 0x000005DC
_022427B8: .word ov70_02245D66
_022427BC: .word ov70_02245D67
_022427C0: .word ov70_02245DB0
	thumb_func_end ov70_022426F4

	thumb_func_start ov70_022427C4
ov70_022427C4: ; 0x022427C4
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	cmp r1, #0
	bge _02242802
	mov r0, #0x5e
	lsl r0, r0, #4
	bl PlaySE
	ldr r0, [r4, #0x14]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	ldr r0, [r4, #0x14]
	mov r1, #0x27
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x5a
	ldrsh r0, [r4, r0]
	cmp r0, #0
	beq _022427F8
	sub r1, r0, #1
	add r0, r4, #0
	add r0, #0x5a
	strh r1, [r0]
	b _02242834
_022427F8:
	add r0, r4, #0
	mov r1, #2
	add r0, #0x5a
	strh r1, [r0]
	b _02242834
_02242802:
	mov r0, #0x5e
	lsl r0, r0, #4
	bl PlaySE
	ldr r0, [r4, #0x10]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	ldr r0, [r4, #0x10]
	mov r1, #0x26
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x5a
	ldrsh r0, [r4, r0]
	cmp r0, #2
	bge _0224282C
	add r1, r0, #1
	add r0, r4, #0
	add r0, #0x5a
	strh r1, [r0]
	b _02242834
_0224282C:
	add r0, r4, #0
	mov r1, #0
	add r0, #0x5a
	strh r1, [r0]
_02242834:
	mov r1, #0x5a
	ldrsh r1, [r4, r1]
	ldr r2, [r4, #0x5c]
	add r0, r4, #0
	bl ov70_022434C0
	ldr r0, [r4, #0x5c]
	mov r1, #4
	bl ov70_02242508
	str r0, [sp]
	mov r3, #0x5a
	ldr r2, [r4, #4]
	ldrsh r3, [r4, r3]
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0x38]
	add r2, #0x40
	bl ov70_02243F00
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov70_022427C4

	thumb_func_start ov70_02242860
ov70_02242860: ; 0x02242860
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #4
	beq _02242874
	cmp r4, #5
	beq _02242880
	cmp r4, #6
	beq _0224288E
	b _0224289A
_02242874:
	ldr r0, _022428BC ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
	pop {r3, r4, r5, pc}
_02242880:
	mov r1, #0
	mvn r1, r1
	bl ov70_022427C4
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
_0224288E:
	mov r1, #1
	bl ov70_022427C4
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
_0224289A:
	mov r0, #0x5a
	ldrsh r1, [r5, r0]
	lsl r1, r1, #2
	add r2, r4, r1
	ldr r1, [r5, #0x5c]
	cmp r2, r1
	bge _022428B8
	ldr r0, _022428BC ; =0x000005DC
	bl PlaySE
	ldr r1, [r5, #0x34]
	lsl r0, r4, #3
	add r0, r1, r0
	ldr r0, [r0, #4]
	pop {r3, r4, r5, pc}
_022428B8:
	sub r0, #0x5b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022428BC: .word 0x000005DC
	thumb_func_end ov70_02242860

	thumb_func_start ov70_022428C0
ov70_022428C0: ; 0x022428C0
	push {r3, r4, r5, lr}
	ldr r1, _02242990 ; =gSystem
	add r5, r0, #0
	ldr r2, [r1, #0x4c]
	mov r1, #0x40
	ldr r4, [r5, #0x48]
	tst r1, r2
	beq _022428E8
	ldr r0, _02242994 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	cmp r0, #0
	beq _022428E2
	sub r0, r0, #1
	str r0, [r5, #0x48]
	b _02242922
_022428E2:
	mov r0, #4
	str r0, [r5, #0x48]
	b _02242922
_022428E8:
	mov r1, #0x80
	tst r1, r2
	beq _02242906
	ldr r0, _02242994 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	cmp r0, #4
	beq _02242900
	add r0, r0, #1
	str r0, [r5, #0x48]
	b _02242922
_02242900:
	mov r0, #0
	str r0, [r5, #0x48]
	b _02242922
_02242906:
	mov r1, #0x20
	add r3, r2, #0
	tst r3, r1
	beq _02242916
	sub r1, #0x21
	bl ov70_022427C4
	b _02242922
_02242916:
	mov r1, #0x10
	tst r1, r2
	beq _02242922
	mov r1, #1
	bl ov70_022427C4
_02242922:
	ldr r0, [r5, #0x48]
	cmp r4, r0
	beq _0224294E
	ldr r1, _02242998 ; =ov70_02245D80
	lsl r3, r0, #1
	ldr r2, _0224299C ; =ov70_02245D81
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r5, #0xc]
	bl ov70_02238F9C
	ldr r0, [r5, #0x48]
	cmp r0, #4
	ldr r0, [r5, #0xc]
	bne _02242948
	mov r1, #0x30
	bl Sprite_SetAnimCtrlSeq
	b _0224294E
_02242948:
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
_0224294E:
	add r0, r5, #0
	mov r1, #2
	bl ov70_02242164
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _02242968
	add r0, r5, #0
	bl ov70_02242860
	pop {r3, r4, r5, pc}
_02242968:
	ldr r1, _02242990 ; =gSystem
	ldr r2, [r1, #0x48]
	mov r1, #1
	tst r1, r2
	beq _0224297C
	ldr r1, [r5, #0x48]
	add r0, r5, #0
	bl ov70_02242860
	pop {r3, r4, r5, pc}
_0224297C:
	mov r1, #2
	tst r1, r2
	beq _0224298C
	ldr r0, _02242994 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
_0224298C:
	pop {r3, r4, r5, pc}
	nop
_02242990: .word gSystem
_02242994: .word 0x000005DC
_02242998: .word ov70_02245D80
_0224299C: .word ov70_02245D81
	thumb_func_end ov70_022428C0

	thumb_func_start ov70_022429A0
ov70_022429A0: ; 0x022429A0
	cmp r1, #9
	beq _022429AA
	cmp r1, #0xa
	beq _022429B0
	b _022429B4
_022429AA:
	mov r0, #1
	mvn r0, r0
	bx lr
_022429B0:
	mov r0, #0xa
	bx lr
_022429B4:
	add r0, r1, #0
	bx lr
	thumb_func_end ov70_022429A0

	thumb_func_start ov70_022429B8
ov70_022429B8: ; 0x022429B8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	ldr r1, [r5, #0x48]
	cmp r1, #9
	bge _022429C8
	add r0, #0x7e
	strb r1, [r0]
_022429C8:
	ldr r0, _02242B3C ; =gSystem
	mov r2, #0x40
	ldr r0, [r0, #0x4c]
	tst r2, r0
	beq _022429DE
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _02242B40 ; =ov70_02245EFC
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _02242A12
_022429DE:
	mov r2, #0x80
	tst r2, r0
	beq _022429F0
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _02242B44 ; =ov70_02245EFD
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _02242A12
_022429F0:
	mov r2, #0x20
	tst r2, r0
	beq _02242A02
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _02242B48 ; =ov70_02245EFE
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
	b _02242A12
_02242A02:
	mov r2, #0x10
	tst r0, r2
	beq _02242A12
	ldr r0, [r5, #0x48]
	lsl r2, r0, #2
	ldr r0, _02242B4C ; =ov70_02245EFF
	ldrb r0, [r0, r2]
	str r0, [r5, #0x48]
_02242A12:
	cmp r1, #9
	blt _02242A6A
	ldr r0, [r5, #0x48]
	cmp r0, #9
	bge _02242A6A
	ldr r0, _02242B3C ; =gSystem
	ldr r2, [r0, #0x4c]
	mov r0, #0x40
	tst r0, r2
	beq _02242A48
	add r0, r5, #0
	add r0, #0x7e
	ldrb r0, [r0]
	str r0, [r5, #0x48]
	add r0, r0, #4
	cmp r0, #9
	bge _02242A6A
	add r0, r5, #0
	add r0, #0x48
_02242A38:
	ldr r2, [r0]
	add r2, r2, #4
	str r2, [r0]
	ldr r2, [r5, #0x48]
	add r2, r2, #4
	cmp r2, #9
	blt _02242A38
	b _02242A6A
_02242A48:
	mov r0, #0x80
	tst r0, r2
	beq _02242A6A
	add r0, r5, #0
	add r0, #0x7e
	ldrb r0, [r0]
	str r0, [r5, #0x48]
	sub r0, r0, #4
	bmi _02242A6A
	add r0, r5, #0
	add r0, #0x48
_02242A5E:
	ldr r2, [r0]
	sub r2, r2, #4
	str r2, [r0]
	ldr r2, [r5, #0x48]
	sub r2, r2, #4
	bpl _02242A5E
_02242A6A:
	ldr r0, [r5, #0x48]
	cmp r1, r0
	beq _02242AB6
	ldr r0, _02242B50 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	ldr r1, _02242B54 ; =ov70_02245DF8
	lsl r2, r0, #1
	ldrb r1, [r1, r2]
	ldr r3, _02242B58 ; =ov70_02245DF9
	ldr r0, [r5, #0xc]
	ldrb r2, [r3, r2]
	add r1, #0x10
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	ldr r0, [r5, #0x48]
	cmp r0, #9
	beq _02242A9A
	cmp r0, #0xa
	beq _02242AA4
	b _02242AAE
_02242A9A:
	ldr r0, [r5, #0xc]
	mov r1, #0x30
	bl Sprite_SetAnimCtrlSeq
	b _02242AB6
_02242AA4:
	ldr r0, [r5, #0xc]
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
	b _02242AB6
_02242AAE:
	ldr r0, [r5, #0xc]
	mov r1, #0x3d
	bl Sprite_SetAnimCtrlSeq
_02242AB6:
	add r0, r5, #0
	mov r1, #6
	bl ov70_02242164
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _02242AF0
	add r0, r5, #0
	bl ov70_022429A0
	add r5, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	beq _02242AE6
	cmp r5, #0xb
	beq _02242AE6
	cmp r4, #0
	beq _02242AE6
	ldrb r0, [r4, r5]
	cmp r0, #0
	beq _02242B36
_02242AE6:
	ldr r0, _02242B50 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	pop {r3, r4, r5, pc}
_02242AF0:
	ldr r0, _02242B3C ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	beq _02242B24
	ldr r1, [r5, #0x48]
	add r0, r5, #0
	bl ov70_022429A0
	add r5, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	beq _02242B1A
	cmp r5, #0xb
	beq _02242B1A
	cmp r4, #0
	beq _02242B1A
	ldrb r0, [r4, r5]
	cmp r0, #0
	beq _02242B36
_02242B1A:
	ldr r0, _02242B50 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	pop {r3, r4, r5, pc}
_02242B24:
	mov r0, #2
	tst r0, r1
	beq _02242B36
	ldr r0, _02242B50 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
	pop {r3, r4, r5, pc}
_02242B36:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02242B3C: .word gSystem
_02242B40: .word ov70_02245EFC
_02242B44: .word ov70_02245EFD
_02242B48: .word ov70_02245EFE
_02242B4C: .word ov70_02245EFF
_02242B50: .word 0x000005DC
_02242B54: .word ov70_02245DF8
_02242B58: .word ov70_02245DF9
	thumb_func_end ov70_022429B8

	thumb_func_start ov70_02242B5C
ov70_02242B5C: ; 0x02242B5C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	cmp r1, #5
	beq _02242B6E
	cmp r1, #6
	beq _02242B7A
	cmp r1, #7
	beq _02242B88
	b _02242B94
_02242B6E:
	ldr r0, _02242BB8 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
	pop {r3, r4, r5, pc}
_02242B7A:
	mov r1, #0
	mvn r1, r1
	bl ov70_02242BBC
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
_02242B88:
	mov r1, #1
	bl ov70_02242BBC
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
_02242B94:
	mov r0, #0x5a
	ldrsh r3, [r5, r0]
	lsl r2, r3, #2
	add r2, r3, r2
	add r4, r1, r2
	ldr r1, [r5, #0x5c]
	cmp r4, r1
	bge _02242BB4
	ldr r0, _02242BB8 ; =0x000005DC
	bl PlaySE
	ldr r1, [r5, #0x34]
	lsl r0, r4, #3
	add r0, r1, r0
	ldr r0, [r0, #4]
	pop {r3, r4, r5, pc}
_02242BB4:
	sub r0, #0x5b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02242BB8: .word 0x000005DC
	thumb_func_end ov70_02242B5C

	thumb_func_start ov70_02242BBC
ov70_02242BBC: ; 0x02242BBC
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	ldr r0, [r5, #0x5c]
	add r6, r1, #0
	mov r1, #5
	bl ov70_02242508
	sub r4, r0, #1
	beq _02242C5E
	cmp r6, #0
	bge _02242C06
	mov r0, #0x5e
	lsl r0, r0, #4
	bl PlaySE
	ldr r0, [r5, #0x14]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	ldr r0, [r5, #0x14]
	mov r1, #0x27
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x5a
	ldrsh r0, [r5, r0]
	cmp r0, #0
	beq _02242BFE
	sub r1, r0, #1
	add r0, r5, #0
	add r0, #0x5a
	strh r1, [r0]
	b _02242C38
_02242BFE:
	add r0, r5, #0
	add r0, #0x5a
	strh r4, [r0]
	b _02242C38
_02242C06:
	mov r0, #0x5e
	lsl r0, r0, #4
	bl PlaySE
	ldr r0, [r5, #0x10]
	mov r1, #1
	bl Sprite_SetAnimActiveFlag
	ldr r0, [r5, #0x10]
	mov r1, #0x26
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x5a
	ldrsh r0, [r5, r0]
	cmp r0, r4
	bge _02242C30
	add r1, r0, #1
	add r0, r5, #0
	add r0, #0x5a
	strh r1, [r0]
	b _02242C38
_02242C30:
	add r0, r5, #0
	mov r1, #0
	add r0, #0x5a
	strh r1, [r0]
_02242C38:
	mov r1, #0x5a
	ldrsh r1, [r5, r1]
	ldr r2, [r5, #0x5c]
	add r0, r5, #0
	bl ov70_0224352C
	ldr r0, [r5, #0x5c]
	mov r1, #5
	bl ov70_02242508
	str r0, [sp]
	mov r3, #0x5a
	ldr r2, [r5, #4]
	ldrsh r3, [r5, r3]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x38]
	add r2, #0x50
	bl ov70_02243F00
_02242C5E:
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov70_02242BBC

	thumb_func_start ov70_02242C64
ov70_02242C64: ; 0x02242C64
	push {r3, r4, r5, lr}
	ldr r1, _02242D34 ; =gSystem
	add r5, r0, #0
	ldr r2, [r1, #0x4c]
	mov r1, #0x40
	ldr r4, [r5, #0x48]
	tst r1, r2
	beq _02242C8C
	ldr r0, _02242D38 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	cmp r0, #0
	beq _02242C86
	sub r0, r0, #1
	str r0, [r5, #0x48]
	b _02242CC6
_02242C86:
	mov r0, #5
	str r0, [r5, #0x48]
	b _02242CC6
_02242C8C:
	mov r1, #0x80
	tst r1, r2
	beq _02242CAA
	ldr r0, _02242D38 ; =0x000005DC
	bl PlaySE
	ldr r0, [r5, #0x48]
	cmp r0, #5
	beq _02242CA4
	add r0, r0, #1
	str r0, [r5, #0x48]
	b _02242CC6
_02242CA4:
	mov r0, #0
	str r0, [r5, #0x48]
	b _02242CC6
_02242CAA:
	mov r1, #0x20
	add r3, r2, #0
	tst r3, r1
	beq _02242CBA
	sub r1, #0x21
	bl ov70_02242BBC
	b _02242CC6
_02242CBA:
	mov r1, #0x10
	tst r1, r2
	beq _02242CC6
	mov r1, #1
	bl ov70_02242BBC
_02242CC6:
	ldr r0, [r5, #0x48]
	cmp r4, r0
	beq _02242CF2
	ldr r1, _02242D3C ; =ov70_02245D8A
	lsl r3, r0, #1
	ldr r2, _02242D40 ; =ov70_02245D8B
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r5, #0xc]
	bl ov70_02238F9C
	ldr r0, [r5, #0x48]
	cmp r0, #5
	ldr r0, [r5, #0xc]
	bne _02242CEC
	mov r1, #0x30
	bl Sprite_SetAnimCtrlSeq
	b _02242CF2
_02242CEC:
	mov r1, #0x32
	bl Sprite_SetAnimCtrlSeq
_02242CF2:
	add r0, r5, #0
	mov r1, #3
	bl ov70_02242164
	add r1, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r1, r0
	beq _02242D0C
	add r0, r5, #0
	bl ov70_02242B5C
	pop {r3, r4, r5, pc}
_02242D0C:
	ldr r1, _02242D34 ; =gSystem
	ldr r2, [r1, #0x48]
	mov r1, #1
	tst r1, r2
	beq _02242D20
	ldr r1, [r5, #0x48]
	add r0, r5, #0
	bl ov70_02242B5C
	pop {r3, r4, r5, pc}
_02242D20:
	mov r1, #2
	tst r1, r2
	beq _02242D30
	ldr r0, _02242D38 ; =0x000005DC
	bl PlaySE
	mov r0, #1
	mvn r0, r0
_02242D30:
	pop {r3, r4, r5, pc}
	nop
_02242D34: .word gSystem
_02242D38: .word 0x000005DC
_02242D3C: .word ov70_02245D8A
_02242D40: .word ov70_02245D8B
	thumb_func_end ov70_02242C64

	thumb_func_start ov70_02242D44
ov70_02242D44: ; 0x02242D44
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	str r1, [sp, #4]
	str r2, [sp, #8]
	cmp r0, #6
	bne _02242D58
	mov r3, #0x21
	b _02242D5A
_02242D58:
	mov r3, #0x22
_02242D5A:
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x1c]
	mov r1, #0
	mov r2, #0x64
	bl sub_02019688
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_02019B08
	ldr r1, [sp, #4]
	add r0, r5, #0
	bl ov70_0224190C
	add r0, r5, #0
	add r0, #0x64
	mov r1, #1
	mov r2, #0x1a
	bl MI_CpuFill8
	mov r4, #0
	add r6, r4, #0
_02242D88:
	add r1, r4, #0
	ldr r0, [r5, #0x24]
	add r1, #0x6e
	bl NewString_ReadMsgData
	add r7, r0, #0
	ldr r0, [sp, #4]
	cmp r0, #4
	bne _02242DBE
	add r0, r5, #0
	add r1, r4, #0
	bl ov70_02243F7C
	cmp r0, #1
	bne _02242DB2
	add r2, r5, r4
	add r2, #0x64
	mov r1, #1
	ldr r0, _02242E50 ; =0x000F0E02
	strb r1, [r2]
	b _02242DE0
_02242DB2:
	add r2, r5, r4
	add r2, #0x64
	mov r1, #0
	ldr r0, _02242E54 ; =0x00080902
	strb r1, [r2]
	b _02242DE0
_02242DBE:
	add r0, r5, #0
	add r1, r4, #0
	bl ov70_02243FE0
	cmp r0, #1
	bne _02242DD6
	add r2, r5, r4
	add r2, #0x64
	mov r1, #1
	ldr r0, _02242E50 ; =0x000F0E02
	strb r1, [r2]
	b _02242DE0
_02242DD6:
	add r2, r5, r4
	ldr r0, _02242E54 ; =0x00080902
	add r2, #0x64
	mov r1, #0
	strb r1, [r2]
_02242DE0:
	str r0, [sp]
	ldr r1, [r5, #4]
	ldr r0, [r5, #0x1c]
	add r1, r1, r6
	add r2, r7, #0
	mov r3, #2
	bl ov70_02242FC4
	add r0, r7, #0
	bl String_Delete
	add r4, r4, #1
	add r6, #0x10
	cmp r4, #9
	blt _02242D88
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	ldr r0, [sp, #4]
	cmp r0, #6
	bne _02242E34
	ldr r0, [r5, #0x24]
	mov r1, #0xae
	bl NewString_ReadMsgData
	add r4, r0, #0
	ldr r0, _02242E50 ; =0x000F0E02
	add r2, r4, #0
	str r0, [sp]
	ldr r1, [r5, #4]
	ldr r0, [r5, #0x1c]
	add r1, #0xf0
	mov r3, #2
	bl ov70_02242FC4
	add r0, r4, #0
	bl String_Delete
_02242E34:
	ldr r2, [sp, #8]
	mov r1, #0
	lsl r2, r2, #0x18
	ldr r0, [r5, #0x1c]
	asr r2, r2, #0x18
	add r3, r1, #0
	bl sub_020196E8
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_020197F4
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02242E50: .word 0x000F0E02
_02242E54: .word 0x00080902
	thumb_func_end ov70_02242D44

	thumb_func_start ov70_02242E58
ov70_02242E58: ; 0x02242E58
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x1c]
	mov r1, #0
	mov r2, #0x64
	mov r3, #0x1f
	bl sub_02019688
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_02019B08
	add r0, r5, #0
	mov r1, #1
	bl ov70_0224190C
	mov r6, #0
	add r4, r6, #0
_02242E80:
	add r1, r6, #0
	ldr r0, [r5, #0x24]
	add r1, #0x7c
	bl NewString_ReadMsgData
	add r7, r0, #0
	ldr r0, _02242EE0 ; =0x000F0E02
	add r2, r7, #0
	str r0, [sp]
	ldr r1, [r5, #4]
	ldr r0, [r5, #0x1c]
	add r1, r1, r4
	mov r3, #2
	bl ov70_02242FC4
	add r0, r7, #0
	bl String_Delete
	add r6, r6, #1
	add r4, #0x10
	cmp r6, #3
	blt _02242E80
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	mov r1, #0
	ldr r0, [r5, #0x1c]
	mov r2, #0x20
	add r3, r1, #0
	bl sub_020196E8
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_020197F4
	mov r1, #0
	mov r0, #4
	str r0, [sp]
	ldr r0, [r5, #0x1c]
	sub r2, r1, #4
	add r3, r1, #0
	bl sub_020198FC
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02242EE0: .word 0x000F0E02
	thumb_func_end ov70_02242E58

	thumb_func_start ov70_02242EE4
ov70_02242EE4: ; 0x02242EE4
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	mov r1, #0
	mov r2, #0x64
	mov r3, #0x23
	bl sub_02019688
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_02019B08
	add r0, r4, #0
	mov r1, #2
	bl ov70_0224190C
	ldr r0, [r4, #0x60]
	cmp r0, #1
	bne _02242F20
	add r0, r4, #0
	ldr r1, [r4, #0x24]
	add r0, #0x34
	mov r2, #1
	bl ov70_0223F7E4
	str r0, [r4, #0x5c]
	b _02242F32
_02242F20:
	cmp r0, #0
	bne _02242F32
	add r0, r4, #0
	ldr r1, [r4, #0x24]
	add r0, #0x34
	mov r2, #0
	bl ov70_0223F7E4
	str r0, [r4, #0x5c]
_02242F32:
	ldr r2, [r4, #0x5c]
	add r0, r4, #0
	mov r1, #0
	bl ov70_022434C0
	add r0, r4, #0
	mov r1, #0
	add r0, #0x5a
	strh r1, [r0]
	ldr r0, [r4, #0x5c]
	mov r1, #4
	bl ov70_02242508
	str r0, [sp]
	mov r3, #0x5a
	ldr r2, [r4, #4]
	ldrsh r3, [r4, r3]
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0x38]
	add r2, #0x40
	bl ov70_02243F00
	ldr r2, [r4, #4]
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	mov r1, #0
	ldr r0, [r4, #0x1c]
	mov r2, #0x20
	add r3, r1, #0
	bl sub_020196E8
	ldr r0, [r4, #0xc]
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
	mov r1, #0
	add r0, r4, #0
	str r1, [r4, #0x48]
	add r0, #0x7e
	strb r1, [r0]
	ldr r0, [r4, #0x48]
	ldr r1, _02242FBC ; =ov70_02245D76
	lsl r3, r0, #1
	ldr r2, _02242FC0 ; =ov70_02245D77
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r4, #0xc]
	bl ov70_02238F9C
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_020197F4
	mov r1, #0
	mov r0, #4
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	sub r2, r1, #4
	add r3, r1, #0
	bl sub_020198FC
	mov r0, #0x20
	str r0, [r4, #0x4c]
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02242FBC: .word ov70_02245D76
_02242FC0: .word ov70_02245D77
	thumb_func_end ov70_02242EE4

	thumb_func_start ov70_02242FC4
ov70_02242FC4: ; 0x02242FC4
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r1, #0
	mov r1, #0
	add r5, r0, #0
	str r1, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, [sp, #0x20]
	str r0, [sp, #8]
	add r0, r4, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r4, #0
	bl CopyWindowPixelsToVram_TextMode
	add r0, r5, #0
	mov r1, #0
	add r2, r4, #0
	bl sub_02019A60
	add sp, #0x10
	pop {r3, r4, r5, pc}
	thumb_func_end ov70_02242FC4

	thumb_func_start ov70_02242FF4
ov70_02242FF4: ; 0x02242FF4
	mov r0, #0
	mvn r0, r0
	bx lr
	.balign 4, 0
	thumb_func_end ov70_02242FF4

	thumb_func_start ov70_02242FFC
ov70_02242FFC: ; 0x02242FFC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_020199E4
	cmp r0, #0
	bne _02243044
	ldr r0, [r4, #0xc]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0x58
	ldrsh r0, [r4, r0]
	cmp r0, #2
	bne _02243040
	ldr r0, [r4, #0x10]
	mov r1, #0xe4
	mov r2, #0x78
	bl ov70_02238F9C
	ldr r0, [r4, #0x14]
	mov r1, #0x9a
	mov r2, #0x78
	bl ov70_02238F9C
	ldr r0, [r4, #0x10]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x14]
	mov r1, #1
	bl Sprite_SetDrawFlag
_02243040:
	ldr r0, [r4, #0x50]
	str r0, [r4, #0x4c]
_02243044:
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02242FFC

	thumb_func_start ov70_0224304C
ov70_0224304C: ; 0x0224304C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_020199E4
	cmp r0, #0
	bne _02243060
	ldr r0, [r4, #0x50]
	str r0, [r4, #0x4c]
_02243060:
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_0224304C

	thumb_func_start ov70_02243068
ov70_02243068: ; 0x02243068
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_020199E4
	cmp r0, #0
	bne _02243084
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_0201980C
	ldr r0, [r4, #0x50]
	str r0, [r4, #0x4c]
_02243084:
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02243068

	thumb_func_start ov70_0224308C
ov70_0224308C: ; 0x0224308C
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r1, #4
	mov r2, #0x20
	bl ov70_02242D44
	ldr r0, [r4, #0xc]
	mov r1, #0x3d
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r4, #0xc]
	mov r1, #0x88
	mov r2, #0x28
	bl ov70_02238F9C
	mov r1, #0
	mov r0, #4
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	sub r2, r1, #4
	add r3, r1, #0
	bl sub_020198FC
	mov r0, #1
	str r0, [r4, #0x4c]
	mov r0, #5
	str r0, [r4, #0x50]
	sub r0, r0, #6
	strh r0, [r4, #0x3c]
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov70_0224308C

	thumb_func_start ov70_022430CC
ov70_022430CC: ; 0x022430CC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x64
	bl ov70_022421D0
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _022430F6
	cmp r4, #8
	bhi _02243118
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #6
	str r0, [r5, #0x4c]
	strh r4, [r5, #0x3c]
	b _02243118
_022430F6:
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #6
	str r0, [r5, #0x50]
	sub r0, r0, #7
	strh r0, [r5, #0x3c]
_02243118:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov70_022430CC

	thumb_func_start ov70_02243120
ov70_02243120: ; 0x02243120
	push {r4, lr}
	add r4, r0, #0
	mov r1, #4
	bl ov70_02241DB4
	ldr r0, [r4, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #0x3c
	ldrsh r1, [r4, r0]
	cmp r1, #0
	blt _0224315C
	cmp r1, #8
	ble _02243142
	bl GF_AssertFail
_02243142:
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	lsl r1, r0, #3
	ldr r0, _02243168 ; =ov70_02245F5C
	ldr r0, [r0, r1]
	cmp r0, #1
	bne _02243158
	mov r0, #0
	strh r0, [r4, #0x3e]
	mov r0, #0xc
	b _02243160
_02243158:
	mov r0, #8
	b _02243160
_0224315C:
	sub r0, #0x3e
	pop {r4, pc}
_02243160:
	str r0, [r4, #0x4c]
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	.balign 4, 0
_02243168: .word ov70_02245F5C
	thumb_func_end ov70_02243120

	thumb_func_start ov70_0224316C
ov70_0224316C: ; 0x0224316C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x1c]
	mov r1, #0
	mov r2, #0x64
	mov r3, #0x22
	bl sub_02019688
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_02019B08
	add r0, r5, #0
	mov r1, #4
	bl ov70_0224190C
	add r0, r5, #0
	add r0, #0x64
	mov r1, #1
	mov r2, #0x1a
	bl MI_CpuFill8
	mov r4, #0
	add r6, r4, #0
_022431A0:
	add r1, r4, #0
	ldr r0, [r5, #0x24]
	add r1, #0x6e
	bl NewString_ReadMsgData
	add r7, r0, #0
	add r0, r5, #0
	add r1, r4, #0
	bl ov70_02243F7C
	cmp r0, #1
	bne _022431C2
	add r2, r5, r4
	ldr r0, _02243244 ; =0x000F0E02
	add r2, #0x64
	mov r1, #1
	b _022431CA
_022431C2:
	add r2, r5, r4
	ldr r0, _02243248 ; =0x00080902
	add r2, #0x64
	mov r1, #0
_022431CA:
	strb r1, [r2]
	str r0, [sp]
	ldr r1, [r5, #4]
	ldr r0, [r5, #0x1c]
	add r1, r1, r6
	add r2, r7, #0
	mov r3, #2
	bl ov70_02242FC4
	add r0, r7, #0
	bl String_Delete
	add r4, r4, #1
	add r6, #0x10
	cmp r4, #9
	blt _022431A0
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	mov r1, #0
	ldr r0, [r5, #0x1c]
	mov r2, #0x10
	add r3, r1, #0
	bl sub_020196E8
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_020197F4
	ldr r0, [r5, #0xc]
	mov r1, #0x3d
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x3c
	ldrsh r0, [r5, r0]
	ldr r1, _0224324C ; =ov70_02245E26
	ldr r2, _02243250 ; =ov70_02245E27
	lsl r3, r0, #1
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r5, #0xc]
	add r1, #0x10
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	mov r0, #0x3c
	ldrsh r0, [r5, r0]
	mov r1, #1
	str r0, [r5, #0x48]
	ldr r0, [r5, #0xc]
	bl Sprite_SetDrawFlag
	mov r0, #5
	str r0, [r5, #0x4c]
	sub r0, r0, #6
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02243244: .word 0x000F0E02
_02243248: .word 0x00080902
_0224324C: .word ov70_02245E26
_02243250: .word ov70_02245E27
	thumb_func_end ov70_0224316C

	thumb_func_start ov70_02243254
ov70_02243254: ; 0x02243254
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x1c]
	mov r1, #0
	mov r2, #0x64
	mov r3, #0x20
	bl sub_02019688
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_02019B08
	add r0, r5, #0
	mov r1, #5
	bl ov70_0224190C
	add r0, r5, #0
	add r0, #0x64
	mov r1, #1
	mov r2, #0x1a
	bl MI_CpuFill8
	mov r0, #2
	str r0, [sp]
	ldr r0, _02243388 ; =0x000F0E02
	mov r3, #0x3c
	str r0, [sp, #4]
	ldrsh r3, [r5, r3]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	ldr r2, [r5, #4]
	add r3, #0x6e
	bl ov70_02243E8C
	mov r0, #0x3c
	ldrsh r1, [r5, r0]
	ldr r0, _0224338C ; =ov70_02245F5C
	mov r4, #1
	lsl r2, r1, #3
	ldr r0, [r0, r2]
	cmp r0, #1
	blt _0224332C
	mov r7, #0x10
_022432B0:
	lsl r2, r1, #2
	ldr r1, _02243390 ; =ov70_02245E84
	add r0, r5, #0
	ldr r1, [r1, r2]
	add r1, r4, r1
	sub r1, r1, #1
	bl ov70_02243F54
	cmp r0, #0
	ble _022432DA
	mov r1, #0x3c
	ldrsh r1, [r5, r1]
	ldr r0, _02243388 ; =0x000F0E02
	lsl r2, r1, #2
	ldr r1, _02243390 ; =ov70_02245E84
	ldr r2, [r1, r2]
	add r1, r5, r4
	add r2, r2, r1
	add r2, #0x63
	mov r1, #1
	b _022432EE
_022432DA:
	mov r1, #0x3c
	ldrsh r1, [r5, r1]
	ldr r0, _02243394 ; =0x00080902
	lsl r2, r1, #2
	ldr r1, _02243390 ; =ov70_02245E84
	ldr r2, [r1, r2]
	add r1, r5, r4
	add r2, r2, r1
	add r2, #0x63
	mov r1, #0
_022432EE:
	strb r1, [r2]
	mov r1, #5
	str r1, [sp]
	str r0, [sp, #4]
	mov r3, #0x3c
	ldrsh r3, [r5, r3]
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	lsl r6, r3, #3
	ldr r3, _02243398 ; =ov70_02245F58
	ldr r1, [r5, #0x24]
	ldr r3, [r3, r6]
	add r2, r2, r7
	add r3, r4, r3
	lsl r6, r3, #2
	ldr r3, _0224339C ; =ov70_02245FA0
	add r3, r3, r6
	sub r3, r3, #4
	ldr r3, [r3]
	bl ov70_02243E8C
	mov r0, #0x3c
	ldrsh r1, [r5, r0]
	ldr r0, _02243398 ; =ov70_02245F58
	add r4, r4, #1
	lsl r2, r1, #3
	add r0, r0, r2
	ldr r0, [r0, #4]
	add r7, #0x10
	cmp r4, r0
	ble _022432B0
_0224332C:
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	mov r1, #0
	ldr r0, [r5, #0x1c]
	mov r2, #0x10
	add r3, r1, #0
	bl sub_020196E8
	ldr r0, [r5, #0xc]
	mov r1, #0x2f
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x3e
	ldrsh r0, [r5, r0]
	cmp r0, #0
	bge _0224335A
	mov r0, #0
	b _0224335A
_0224335A:
	str r0, [r5, #0x48]
	ldr r0, [r5, #0x48]
	ldr r1, _022433A0 ; =ov70_02245E26
	lsl r3, r0, #1
	ldr r2, _022433A4 ; =ov70_02245E27
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r5, #0xc]
	add r1, #0x10
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	ldr r0, [r5, #0xc]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #9
	str r0, [r5, #0x4c]
	sub r0, #0xa
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02243388: .word 0x000F0E02
_0224338C: .word ov70_02245F5C
_02243390: .word ov70_02245E84
_02243394: .word 0x00080902
_02243398: .word ov70_02245F58
_0224339C: .word ov70_02245FA0
_022433A0: .word ov70_02245E26
_022433A4: .word ov70_02245E27
	thumb_func_end ov70_02243254

	thumb_func_start ov70_022433A8
ov70_022433A8: ; 0x022433A8
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x64
	bl ov70_02242390
	add r5, r0, #0
	cmp r5, #4
	bhi _022433D0
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022433C6: ; jump table
	.short _022433DA - _022433C6 - 2 ; case 0
	.short _022433DA - _022433C6 - 2 ; case 1
	.short _022433DA - _022433C6 - 2 ; case 2
	.short _022433DA - _022433C6 - 2 ; case 3
	.short _022433DA - _022433C6 - 2 ; case 4
_022433D0:
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	beq _022433EA
	b _022433FA
_022433DA:
	ldr r0, [r4, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #0xa
	str r0, [r4, #0x4c]
	strh r5, [r4, #0x3e]
	b _022433FA
_022433EA:
	ldr r0, [r4, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #0xa
	str r0, [r4, #0x4c]
	sub r0, #0xb
	strh r0, [r4, #0x3e]
_022433FA:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	thumb_func_end ov70_022433A8

	thumb_func_start ov70_02243400
ov70_02243400: ; 0x02243400
	push {r4, lr}
	mov r1, #5
	add r4, r0, #0
	bl ov70_02241DB4
	mov r0, #0x3e
	ldrsh r0, [r4, r0]
	cmp r0, #0
	blt _02243416
	mov r0, #0xc
	b _02243418
_02243416:
	mov r0, #7
_02243418:
	str r0, [r4, #0x4c]
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	thumb_func_end ov70_02243400

	thumb_func_start ov70_02243420
ov70_02243420: ; 0x02243420
	mov r1, #8
	str r1, [r0, #0x4c]
	sub r1, #9
	add r0, r1, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov70_02243420

	thumb_func_start ov70_0224342C
ov70_0224342C: ; 0x0224342C
	push {r3, r4, r5, r6, r7, lr}
	mov r6, #0
	add r7, r2, #0
	str r1, [sp]
	add r5, r3, #0
	add r4, r6, #0
	cmp r7, #0
	ble _02243452
_0224343C:
	ldrh r1, [r5]
	ldr r0, [sp]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _0224344A
	add r4, r4, #1
_0224344A:
	add r6, r6, #1
	add r5, r5, #2
	cmp r6, r7
	blt _0224343C
_02243452:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov70_0224342C

	thumb_func_start ov70_02243458
ov70_02243458: ; 0x02243458
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	str r1, [sp]
	add r6, r0, #0
	ldr r1, [sp, #0x28]
	mov r0, #0x3d
	add r2, sp, #0xc
	add r4, r3, #0
	ldr r7, [sp, #0x2c]
	bl ov70_0223F658
	str r0, [sp, #4]
	ldr r2, [sp, #0xc]
	ldr r3, [sp, #4]
	add r0, r4, #0
	add r1, r7, #0
	bl ov70_0224342C
	str r0, [sp, #8]
	add r0, r0, #1
	mov r1, #0x3d
	bl ListMenuItems_New
	str r0, [r6]
	ldr r0, [sp, #0xc]
	mov r4, #0
	cmp r0, #0
	ble _022434B4
	ldr r5, [sp, #4]
_02243492:
	ldrh r1, [r5]
	add r0, r7, #0
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _022434AA
	ldrh r2, [r5]
	ldr r0, [r6]
	ldr r1, [sp]
	add r3, r2, #0
	bl ListMenuItems_AppendFromMsgData
_022434AA:
	ldr r0, [sp, #0xc]
	add r4, r4, #1
	add r5, r5, #2
	cmp r4, r0
	blt _02243492
_022434B4:
	ldr r0, [sp, #4]
	bl Heap_Free
	ldr r0, [sp, #8]
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov70_02243458

	thumb_func_start ov70_022434C0
ov70_022434C0: ; 0x022434C0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	lsl r7, r1, #2
	mov r4, #0
	add r5, r0, #0
	lsl r0, r7, #3
	str r2, [sp, #4]
	str r4, [sp, #0xc]
	add r6, r4, #0
	str r0, [sp, #8]
_022434D4:
	ldr r0, [r5, #4]
	mov r1, #0x22
	add r0, r0, r4
	bl FillWindowPixelBuffer
	ldr r0, [sp, #4]
	cmp r7, r0
	bge _022434FE
	ldr r0, _02243528 ; =0x000F0E02
	ldr r2, [sp, #8]
	str r0, [sp]
	ldr r3, [r5, #0x34]
	ldr r1, [r5, #4]
	add r2, r2, r3
	ldr r0, [r5, #0x1c]
	ldr r2, [r6, r2]
	add r1, r1, r4
	mov r3, #0
	bl ov70_02242FC4
	b _02243512
_022434FE:
	ldr r0, [r5, #4]
	add r0, r0, r4
	bl CopyWindowPixelsToVram_TextMode
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	mov r1, #0
	add r2, r2, r4
	bl sub_02019A60
_02243512:
	ldr r0, [sp, #0xc]
	add r4, #0x10
	add r0, r0, #1
	add r7, r7, #1
	add r6, #8
	str r0, [sp, #0xc]
	cmp r0, #4
	blt _022434D4
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02243528: .word 0x000F0E02
	thumb_func_end ov70_022434C0

	thumb_func_start ov70_0224352C
ov70_0224352C: ; 0x0224352C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	lsl r0, r1, #2
	mov r4, #0
	add r7, r1, r0
	lsl r0, r7, #3
	str r2, [sp, #4]
	str r4, [sp, #0xc]
	add r6, r4, #0
	str r0, [sp, #8]
_02243542:
	ldr r0, [r5, #4]
	mov r1, #0x22
	add r0, r0, r4
	bl FillWindowPixelBuffer
	ldr r0, [sp, #4]
	cmp r7, r0
	bge _0224356C
	ldr r0, _02243594 ; =0x000F0E02
	ldr r2, [sp, #8]
	str r0, [sp]
	ldr r3, [r5, #0x34]
	ldr r1, [r5, #4]
	add r2, r2, r3
	ldr r0, [r5, #0x1c]
	ldr r2, [r6, r2]
	add r1, r1, r4
	mov r3, #0
	bl ov70_02242FC4
	b _02243580
_0224356C:
	ldr r0, [r5, #4]
	add r0, r0, r4
	bl CopyWindowPixelsToVram_TextMode
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	mov r1, #0
	add r2, r2, r4
	bl sub_02019A60
_02243580:
	ldr r0, [sp, #0xc]
	add r4, #0x10
	add r0, r0, #1
	add r7, r7, #1
	add r6, #8
	str r0, [sp, #0xc]
	cmp r0, #5
	blt _02243542
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02243594: .word 0x000F0E02
	thumb_func_end ov70_0224352C

	thumb_func_start ov70_02243598
ov70_02243598: ; 0x02243598
	push {r4, lr}
	sub sp, #8
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	mov r1, #0
	mov r2, #0x64
	mov r3, #0x23
	bl sub_02019688
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_02019B08
	add r0, r4, #0
	mov r1, #0
	bl ov70_0224190C
	mov r0, #0x3e
	ldrsh r2, [r4, r0]
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	lsl r1, r0, #2
	ldr r0, _0224367C ; =ov70_02245E84
	ldr r0, [r0, r1]
	add r0, r2, r0
	str r0, [sp]
	ldr r0, [r4, #0x20]
	str r0, [sp, #4]
	add r0, r4, #0
	ldr r1, [r4, #0x28]
	ldr r2, [r4, #0x24]
	ldr r3, [r4, #0x30]
	add r0, #0x34
	bl ov70_02243458
	str r0, [r4, #0x5c]
	add r0, r4, #0
	mov r1, #0
	add r0, #0x5a
	strh r1, [r0]
	ldr r2, [r4, #0x5c]
	add r0, r4, #0
	bl ov70_022434C0
	ldr r0, [r4, #0x5c]
	mov r1, #4
	bl ov70_02242508
	str r0, [sp]
	mov r3, #0x5a
	ldr r2, [r4, #4]
	ldrsh r3, [r4, r3]
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0x38]
	add r2, #0x40
	bl ov70_02243F00
	ldr r2, [r4, #4]
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	mov r1, #0
	ldr r0, [r4, #0x1c]
	mov r2, #0x10
	add r3, r1, #0
	bl sub_020196E8
	ldr r0, [r4, #0xc]
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0
	ldr r1, _02243680 ; =ov70_02245D76
	lsl r3, r0, #1
	ldr r2, _02243684 ; =ov70_02245D77
	str r0, [r4, #0x48]
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r4, #0xc]
	bl ov70_02238F9C
	ldr r0, [r4, #0x10]
	mov r1, #0xe4
	mov r2, #0x78
	bl ov70_02238F9C
	ldr r0, [r4, #0x14]
	mov r1, #0x9a
	mov r2, #0x78
	bl ov70_02238F9C
	ldr r0, [r4, #0xc]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x10]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x14]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0xd
	str r0, [r4, #0x4c]
	sub r0, #0xe
	add sp, #8
	pop {r4, pc}
	nop
_0224367C: .word ov70_02245E84
_02243680: .word ov70_02245D76
_02243684: .word ov70_02245D77
	thumb_func_end ov70_02243598

	thumb_func_start ov70_02243688
ov70_02243688: ; 0x02243688
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov70_0224261C
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _022436A2
	add r0, r0, #1
	cmp r4, r0
	beq _022436F6
	b _022436C4
_022436A2:
	ldr r0, [r5, #0x10]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, _022436FC ; =0x000005DC
	bl PlaySE
	mov r0, #0xe
	str r0, [r5, #0x4c]
	sub r0, #0xf
	add r5, #0x40
	strh r0, [r5]
	b _022436F6
_022436C4:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x10]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0xf
	str r0, [r5, #0x50]
	add r5, #0x40
	strh r4, [r5]
_022436F6:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022436FC: .word 0x000005DC
	thumb_func_end ov70_02243688

	thumb_func_start ov70_02243700
ov70_02243700: ; 0x02243700
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x10]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x14]
	mov r1, #0
	bl Sprite_SetDrawFlag
	add r0, r4, #0
	mov r1, #0
	bl ov70_02241DB4
	ldr r0, [r4, #0x34]
	bl ListMenuItems_Delete
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	cmp r0, #8
	ble _0224372E
	bl GF_AssertFail
_0224372E:
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	lsl r1, r0, #3
	ldr r0, _0224374C ; =ov70_02245F5C
	ldr r0, [r0, r1]
	cmp r0, #1
	bne _02243740
	mov r0, #7
	b _02243742
_02243740:
	mov r0, #0xb
_02243742:
	str r0, [r4, #0x4c]
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	nop
_0224374C: .word ov70_02245F5C
	thumb_func_end ov70_02243700

	thumb_func_start ov70_02243750
ov70_02243750: ; 0x02243750
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov70_02241DB4
	ldr r0, [r4, #0x34]
	bl ListMenuItems_Delete
	mov r0, #0x40
	ldrsh r0, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02243750

	thumb_func_start ov70_02243768
ov70_02243768: ; 0x02243768
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #6
	mov r2, #0x20
	add r4, r0, #0
	bl ov70_02242D44
	mov r1, #0
	mov r0, #4
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	sub r2, r1, #4
	add r3, r1, #0
	bl sub_020198FC
	mov r0, #1
	str r0, [r4, #0x4c]
	mov r0, #0x11
	str r0, [r4, #0x50]
	mov r0, #0xa
	str r0, [r4, #0x48]
	sub r0, #0xb
	strh r0, [r4, #0x3c]
	ldr r0, [r4, #0x48]
	ldr r1, _022437C0 ; =ov70_02245DF8
	lsl r3, r0, #1
	ldr r2, _022437C4 ; =ov70_02245DF9
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r4, #0xc]
	add r1, #0x10
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	ldr r0, [r4, #0xc]
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0
	mvn r0, r0
	add sp, #4
	pop {r3, r4, pc}
	nop
_022437C0: .word ov70_02245DF8
_022437C4: .word ov70_02245DF9
	thumb_func_end ov70_02243768

	thumb_func_start ov70_022437C8
ov70_022437C8: ; 0x022437C8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x64
	bl ov70_022429B8
	add r4, r0, #0
	cmp r4, #0xa
	beq _0224380E
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _022437EA
	add r0, r0, #1
	cmp r4, r0
	beq _02243840
	b _02243832
_022437EA:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0x12
	str r0, [r5, #0x50]
	sub r0, #0x13
	strh r0, [r5, #0x3c]
	b _02243840
_0224380E:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0x12
	str r0, [r5, #0x50]
	sub r0, #0x14
	strh r0, [r5, #0x3c]
	b _02243840
_02243832:
	cmp r4, #8
	bls _0224383A
	bl GF_AssertFail
_0224383A:
	strh r4, [r5, #0x3c]
	mov r0, #0x12
	str r0, [r5, #0x4c]
_02243840:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov70_022437C8

	thumb_func_start ov70_02243848
ov70_02243848: ; 0x02243848
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r1, #6
	bl ov70_02241DB4
	ldr r0, [r4, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #0x3c
	ldrsh r2, [r4, r0]
	cmp r2, #0
	bge _0224387E
	add r1, r0, #0
	sub r1, #0x3d
	cmp r2, r1
	bne _02243872
	add sp, #4
	sub r0, #0x3e
	pop {r3, r4, pc}
_02243872:
	sub r0, #0x3e
	cmp r2, r0
	bne _022438C8
	add sp, #4
	mov r0, #0
	pop {r3, r4, pc}
_0224387E:
	cmp r2, #8
	ble _02243886
	bl GF_AssertFail
_02243886:
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	lsl r1, r0, #3
	ldr r0, _022438D0 ; =ov70_02245F5C
	ldr r0, [r0, r1]
	cmp r0, #1
	bne _022438C4
	mov r1, #0
	strh r1, [r4, #0x3e]
	mov r2, #3
	str r2, [sp]
	ldr r0, [r4, #0x1c]
	sub r2, r2, #7
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r4, #0x18]
	cmp r0, #0
	beq _022438B2
	mov r1, #0
	bl Sprite_SetDrawFlag
_022438B2:
	ldr r0, [r4, #0xc]
	mov r1, #0x32
	bl Sprite_SetAnimCtrlSeq
	mov r0, #2
	str r0, [r4, #0x4c]
	mov r0, #0x18
	str r0, [r4, #0x50]
	b _022438C8
_022438C4:
	mov r0, #0x14
	str r0, [r4, #0x4c]
_022438C8:
	mov r0, #0
	mvn r0, r0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022438D0: .word ov70_02245F5C
	thumb_func_end ov70_02243848

	thumb_func_start ov70_022438D4
ov70_022438D4: ; 0x022438D4
	push {r4, lr}
	add r4, r0, #0
	mov r1, #6
	mov r2, #0x10
	bl ov70_02242D44
	ldr r0, [r4, #0xc]
	mov r1, #0x3d
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r4, #0xc]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	ldr r1, _02243920 ; =ov70_02245DF8
	ldr r2, _02243924 ; =ov70_02245DF9
	lsl r3, r0, #1
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	str r0, [r4, #0x48]
	add r1, #0x10
	ldr r0, [r4, #0xc]
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	ldr r0, [r4, #0x18]
	cmp r0, #0
	beq _02243918
	mov r1, #1
	bl Sprite_SetDrawFlag
_02243918:
	mov r0, #0x11
	str r0, [r4, #0x4c]
	sub r0, #0x12
	pop {r4, pc}
	.balign 4, 0
_02243920: .word ov70_02245DF8
_02243924: .word ov70_02245DF9
	thumb_func_end ov70_022438D4

	thumb_func_start ov70_02243928
ov70_02243928: ; 0x02243928
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r5, #0x1c]
	mov r1, #0
	mov r2, #0x64
	mov r3, #0x20
	bl sub_02019688
	ldr r0, [r5, #0x1c]
	mov r1, #0
	bl sub_02019B08
	add r0, r5, #0
	mov r1, #5
	bl ov70_0224190C
	add r0, r5, #0
	add r0, #0x64
	mov r1, #1
	mov r2, #0x1a
	bl MI_CpuFill8
	mov r0, #2
	str r0, [sp]
	ldr r0, _02243A50 ; =0x000F0E02
	mov r3, #0x3c
	str r0, [sp, #4]
	ldrsh r3, [r5, r3]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	ldr r2, [r5, #4]
	add r3, #0x6e
	bl ov70_02243E8C
	mov r4, #1
	mov r7, #0x10
_02243976:
	mov r1, #0x3c
	ldrsh r1, [r5, r1]
	add r0, r5, #0
	lsl r2, r1, #2
	ldr r1, _02243A54 ; =ov70_02245E84
	ldr r1, [r1, r2]
	add r1, r4, r1
	sub r1, r1, #1
	bl ov70_02243FD4
	cmp r0, #0
	ble _022439A4
	mov r1, #0x3c
	ldrsh r1, [r5, r1]
	ldr r0, _02243A50 ; =0x000F0E02
	lsl r2, r1, #2
	ldr r1, _02243A54 ; =ov70_02245E84
	ldr r2, [r1, r2]
	add r1, r5, r4
	add r2, r2, r1
	add r2, #0x63
	mov r1, #1
	b _022439B8
_022439A4:
	mov r1, #0x3c
	ldrsh r1, [r5, r1]
	ldr r0, _02243A58 ; =0x00080902
	lsl r2, r1, #2
	ldr r1, _02243A54 ; =ov70_02245E84
	ldr r2, [r1, r2]
	add r1, r5, r4
	add r2, r2, r1
	add r2, #0x63
	mov r1, #0
_022439B8:
	strb r1, [r2]
	mov r1, #5
	str r1, [sp]
	str r0, [sp, #4]
	mov r3, #0x3c
	ldrsh r3, [r5, r3]
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	lsl r6, r3, #3
	ldr r3, _02243A5C ; =ov70_02245F58
	ldr r1, [r5, #0x24]
	ldr r3, [r3, r6]
	add r2, r2, r7
	add r3, r4, r3
	lsl r6, r3, #2
	ldr r3, _02243A60 ; =ov70_02245FA0
	add r3, r3, r6
	sub r3, r3, #4
	ldr r3, [r3]
	bl ov70_02243E8C
	add r4, r4, #1
	add r7, #0x10
	cmp r4, #4
	blt _02243976
	ldr r2, [r5, #4]
	ldr r0, [r5, #0x1c]
	ldr r1, [r5, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	mov r1, #0
	ldr r0, [r5, #0x1c]
	mov r2, #0x10
	add r3, r1, #0
	bl sub_020196E8
	ldr r0, [r5, #0xc]
	mov r1, #0x2f
	bl Sprite_SetAnimCtrlSeq
	mov r0, #0x3e
	ldrsh r0, [r5, r0]
	cmp r0, #0
	bge _02243A18
	mov r0, #0
	b _02243A18
_02243A18:
	str r0, [r5, #0x48]
	ldr r0, [r5, #0x48]
	ldr r1, _02243A64 ; =ov70_02245E26
	lsl r3, r0, #1
	ldr r2, _02243A68 ; =ov70_02245E27
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r5, #0xc]
	add r1, #0x10
	lsl r1, r1, #3
	lsl r2, r2, #3
	bl ov70_02238F9C
	ldr r0, [r5, #0xc]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x18]
	cmp r0, #0
	beq _02243A46
	mov r1, #1
	bl Sprite_SetDrawFlag
_02243A46:
	mov r0, #0x15
	str r0, [r5, #0x4c]
	sub r0, #0x16
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_02243A50: .word 0x000F0E02
_02243A54: .word ov70_02245E84
_02243A58: .word 0x00080902
_02243A5C: .word ov70_02245F58
_02243A60: .word ov70_02245FA0
_02243A64: .word ov70_02245E26
_02243A68: .word ov70_02245E27
	thumb_func_end ov70_02243928

	thumb_func_start ov70_02243A6C
ov70_02243A6C: ; 0x02243A6C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x64
	bl ov70_02242390
	add r5, r0, #0
	cmp r5, #4
	bhi _02243A94
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02243A8A: ; jump table
	.short _02243A9E - _02243A8A - 2 ; case 0
	.short _02243A9E - _02243A8A - 2 ; case 1
	.short _02243A9E - _02243A8A - 2 ; case 2
	.short _02243A9E - _02243A8A - 2 ; case 3
	.short _02243A9E - _02243A8A - 2 ; case 4
_02243A94:
	mov r0, #1
	mvn r0, r0
	cmp r5, r0
	beq _02243AAE
	b _02243ABE
_02243A9E:
	ldr r0, [r4, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #0x16
	str r0, [r4, #0x4c]
	strh r5, [r4, #0x3e]
	b _02243ABE
_02243AAE:
	ldr r0, [r4, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #0x16
	str r0, [r4, #0x4c]
	sub r0, #0x17
	strh r0, [r4, #0x3e]
_02243ABE:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	thumb_func_end ov70_02243A6C

	thumb_func_start ov70_02243AC4
ov70_02243AC4: ; 0x02243AC4
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r1, #5
	bl ov70_02241DB4
	ldr r0, [r4, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #0x3e
	ldrsh r0, [r4, r0]
	cmp r0, #0
	bge _02243AE6
	mov r0, #0x13
	str r0, [r4, #0x4c]
	b _02243B12
_02243AE6:
	mov r0, #3
	mov r1, #0
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	sub r2, r1, #4
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r4, #0x18]
	cmp r0, #0
	beq _02243B02
	mov r1, #0
	bl Sprite_SetDrawFlag
_02243B02:
	ldr r0, [r4, #0xc]
	mov r1, #0x32
	bl Sprite_SetAnimCtrlSeq
	mov r0, #2
	str r0, [r4, #0x4c]
	mov r0, #0x18
	str r0, [r4, #0x50]
_02243B12:
	mov r0, #0
	mvn r0, r0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02243AC4

	thumb_func_start ov70_02243B1C
ov70_02243B1C: ; 0x02243B1C
	mov r1, #0x14
	str r1, [r0, #0x4c]
	mov r1, #0x3e
	ldrsh r2, [r0, r1]
	sub r1, #0x3f
	str r2, [r0, #0x48]
	add r0, r1, #0
	bx lr
	thumb_func_end ov70_02243B1C

	thumb_func_start ov70_02243B2C
ov70_02243B2C: ; 0x02243B2C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #1
	str r0, [sp]
	ldr r0, [r4, #0x1c]
	mov r1, #0
	mov r2, #0x64
	mov r3, #0x1e
	bl sub_02019688
	ldr r0, [r4, #0x1c]
	mov r1, #0
	bl sub_02019B08
	add r0, r4, #0
	mov r1, #3
	bl ov70_0224190C
	mov r3, #0x3c
	ldrsh r3, [r4, r3]
	mov r2, #0x3e
	add r0, r4, #0
	lsl r5, r3, #2
	ldr r3, _02243BFC ; =ov70_02245E84
	ldrsh r2, [r4, r2]
	ldr r3, [r3, r5]
	ldr r1, [r4, #0x2c]
	add r0, #0x34
	add r2, r2, r3
	bl ov70_0223F904
	str r0, [r4, #0x5c]
	ldr r2, [r4, #0x5c]
	add r0, r4, #0
	mov r1, #0
	bl ov70_0224352C
	add r0, r4, #0
	mov r1, #0
	add r0, #0x5a
	strh r1, [r0]
	ldr r0, [r4, #0x5c]
	mov r1, #5
	bl ov70_02242508
	str r0, [sp]
	mov r3, #0x5a
	ldr r2, [r4, #4]
	ldrsh r3, [r4, r3]
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0x38]
	add r2, #0x50
	bl ov70_02243F00
	ldr r2, [r4, #4]
	ldr r0, [r4, #0x1c]
	ldr r1, [r4, #0x24]
	add r2, #0xe0
	mov r3, #0x44
	bl ov70_02243EB8
	mov r1, #0
	ldr r0, [r4, #0x1c]
	mov r2, #1
	add r3, r1, #0
	bl sub_020196E8
	mov r0, #0
	ldr r1, _02243C00 ; =ov70_02245D8A
	lsl r3, r0, #1
	ldr r2, _02243C04 ; =ov70_02245D8B
	str r0, [r4, #0x48]
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r4, #0xc]
	bl ov70_02238F9C
	ldr r0, [r4, #0x10]
	mov r1, #0xb0
	mov r2, #0x88
	bl ov70_02238F9C
	ldr r0, [r4, #0x14]
	mov r1, #0x58
	mov r2, #0x88
	bl ov70_02238F9C
	ldr r0, [r4, #0xc]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x10]
	mov r1, #1
	bl Sprite_SetDrawFlag
	ldr r0, [r4, #0x14]
	mov r1, #1
	bl Sprite_SetDrawFlag
	mov r0, #0x19
	str r0, [r4, #0x4c]
	sub r0, #0x1a
	pop {r3, r4, r5, pc}
	nop
_02243BFC: .word ov70_02245E84
_02243C00: .word ov70_02245D8A
_02243C04: .word ov70_02245D8B
	thumb_func_end ov70_02243B2C

	thumb_func_start ov70_02243C08
ov70_02243C08: ; 0x02243C08
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov70_02242C64
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _02243C22
	add r0, r0, #1
	cmp r4, r0
	beq _02243C84
	b _02243C52
_02243C22:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x10]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #2
	str r0, [r5, #0x4c]
	mov r0, #0x1a
	str r0, [r5, #0x50]
	b _02243C84
_02243C52:
	mov r2, #6
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x10]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0x1b
	str r0, [r5, #0x50]
	add r5, #0x42
	strh r4, [r5]
_02243C84:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov70_02243C08

	thumb_func_start ov70_02243C8C
ov70_02243C8C: ; 0x02243C8C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #3
	bl ov70_02241DB4
	ldr r0, [r4, #0x34]
	bl ListMenuItems_Delete
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	cmp r0, #8
	ble _02243CA8
	bl GF_AssertFail
_02243CA8:
	mov r0, #0x3c
	ldrsh r0, [r4, r0]
	lsl r1, r0, #3
	ldr r0, _02243CC4 ; =ov70_02245F5C
	ldr r0, [r0, r1]
	cmp r0, #1
	bne _02243CBA
	mov r0, #0x13
	b _02243CBC
_02243CBA:
	mov r0, #0x17
_02243CBC:
	str r0, [r4, #0x4c]
	mov r0, #0
	mvn r0, r0
	pop {r4, pc}
	.balign 4, 0
_02243CC4: .word ov70_02245F5C
	thumb_func_end ov70_02243C8C

	thumb_func_start ov70_02243CC8
ov70_02243CC8: ; 0x02243CC8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #3
	bl ov70_02241DB4
	ldr r0, [r4, #0x18]
	cmp r0, #0
	beq _02243CDE
	mov r1, #1
	bl Sprite_SetDrawFlag
_02243CDE:
	ldr r0, [r4, #0x34]
	bl ListMenuItems_Delete
	mov r0, #0x42
	ldrsh r0, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02243CC8

	thumb_func_start ov70_02243CEC
ov70_02243CEC: ; 0x02243CEC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	str r1, [r4, #0x48]
	bl ov70_02242E58
	ldr r0, [r4, #0xc]
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r4, #0x48]
	ldr r1, _02243D20 ; =ov70_02245D66
	lsl r3, r0, #1
	ldr r2, _02243D24 ; =ov70_02245D67
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r4, #0xc]
	bl ov70_02238F9C
	mov r0, #1
	str r0, [r4, #0x4c]
	mov r0, #0x1d
	str r0, [r4, #0x50]
	sub r0, #0x1e
	pop {r4, pc}
	nop
_02243D20: .word ov70_02245D66
_02243D24: .word ov70_02245D67
	thumb_func_end ov70_02243CEC

	thumb_func_start ov70_02243D28
ov70_02243D28: ; 0x02243D28
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov70_022426F4
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _02243D42
	add r0, r0, #1
	cmp r4, r0
	beq _02243D8A
	b _02243D68
_02243D42:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0x1e
	str r0, [r5, #0x50]
	sub r0, #0x20
	add r5, #0x44
	strb r0, [r5]
	b _02243D8A
_02243D68:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0x1e
	str r0, [r5, #0x50]
	add r5, #0x44
	strb r4, [r5]
_02243D8A:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	thumb_func_end ov70_02243D28

	thumb_func_start ov70_02243D90
ov70_02243D90: ; 0x02243D90
	push {r4, lr}
	mov r1, #1
	add r4, r0, #0
	bl ov70_02241DB4
	mov r0, #0x44
	ldrsb r0, [r4, r0]
	pop {r4, pc}
	thumb_func_end ov70_02243D90

	thumb_func_start ov70_02243DA0
ov70_02243DA0: ; 0x02243DA0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	str r1, [r4, #0x48]
	bl ov70_02242EE4
	ldr r0, [r4, #0xc]
	mov r1, #0x31
	bl Sprite_SetAnimCtrlSeq
	ldr r0, [r4, #0x48]
	ldr r1, _02243DD4 ; =ov70_02245D80
	lsl r3, r0, #1
	ldr r2, _02243DD8 ; =ov70_02245D81
	ldrb r1, [r1, r3]
	ldrb r2, [r2, r3]
	ldr r0, [r4, #0xc]
	bl ov70_02238F9C
	mov r0, #1
	str r0, [r4, #0x4c]
	mov r0, #0x20
	str r0, [r4, #0x50]
	sub r0, #0x21
	pop {r4, pc}
	nop
_02243DD4: .word ov70_02245D80
_02243DD8: .word ov70_02245D81
	thumb_func_end ov70_02243DA0

	thumb_func_start ov70_02243DDC
ov70_02243DDC: ; 0x02243DDC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov70_022428C0
	add r4, r0, #0
	mov r0, #1
	mvn r0, r0
	cmp r4, r0
	beq _02243DF6
	add r0, r0, #1
	cmp r4, r0
	beq _02243E6E
	b _02243E2C
_02243DF6:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x10]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0x21
	str r0, [r5, #0x50]
	sub r0, #0x23
	add r5, #0x45
	strb r0, [r5]
	b _02243E6E
_02243E2C:
	mov r2, #4
	str r2, [sp]
	mov r1, #0
	ldr r0, [r5, #0x1c]
	add r3, r1, #0
	bl sub_020198FC
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x10]
	mov r1, #0
	bl Sprite_SetDrawFlag
	ldr r0, [r5, #0x14]
	mov r1, #0
	bl Sprite_SetDrawFlag
	mov r0, #3
	str r0, [r5, #0x4c]
	mov r0, #0x21
	str r0, [r5, #0x50]
	mov r0, #0x5a
	ldrsh r0, [r5, r0]
	ldr r1, [r5, #0x34]
	add r5, #0x45
	lsl r0, r0, #2
	add r0, r4, r0
	lsl r0, r0, #3
	add r0, r1, r0
	ldr r0, [r0, #4]
	strb r0, [r5]
_02243E6E:
	mov r0, #0
	mvn r0, r0
	pop {r3, r4, r5, pc}
	thumb_func_end ov70_02243DDC

	thumb_func_start ov70_02243E74
ov70_02243E74: ; 0x02243E74
	push {r4, lr}
	add r4, r0, #0
	mov r1, #2
	bl ov70_02241DB4
	ldr r0, [r4, #0x34]
	bl ListMenuItems_Delete
	mov r0, #0x45
	ldrsb r0, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02243E74

	thumb_func_start ov70_02243E8C
ov70_02243E8C: ; 0x02243E8C
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	add r0, r1, #0
	add r1, r3, #0
	add r6, r2, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	ldr r0, [sp, #0x1c]
	ldr r3, [sp, #0x18]
	str r0, [sp]
	add r0, r5, #0
	add r1, r6, #0
	add r2, r4, #0
	bl ov70_02242FC4
	add r0, r4, #0
	bl String_Delete
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov70_02243E8C

	thumb_func_start ov70_02243EB8
ov70_02243EB8: ; 0x02243EB8
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r0, #0
	add r0, r1, #0
	add r1, r3, #0
	add r5, r2, #0
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r3, #0
	str r3, [sp]
	mov r0, #0xff
	str r0, [sp, #4]
	ldr r0, _02243EFC ; =0x000F0E02
	mov r1, #4
	str r0, [sp, #8]
	add r0, r5, #0
	add r2, r4, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl CopyWindowPixelsToVram_TextMode
	add r0, r6, #0
	mov r1, #0
	add r2, r5, #0
	bl sub_02019A60
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02243EFC: .word 0x000F0E02
	thumb_func_end ov70_02243EB8

	thumb_func_start ov70_02243F00
ov70_02243F00: ; 0x02243F00
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r4, r2, #0
	add r6, r0, #0
	add r5, r1, #0
	add r1, r3, #1
	str r4, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	add r0, r5, #0
	mov r2, #2
	mov r3, #1
	bl PrintUIntOnWindow
	mov r1, #0
	str r1, [sp]
	add r0, r5, #0
	add r2, r4, #0
	mov r3, #0x10
	bl sub_0200CDAC
	str r4, [sp]
	mov r0, #0x18
	str r0, [sp, #4]
	mov r3, #0
	ldr r1, [sp, #0x20]
	add r0, r5, #0
	mov r2, #2
	str r3, [sp, #8]
	bl PrintUIntOnWindow
	add r0, r4, #0
	bl CopyWindowPixelsToVram_TextMode
	add r0, r6, #0
	mov r1, #0
	add r2, r4, #0
	bl sub_02019A60
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov70_02243F00

	thumb_func_start ov70_02243F54
ov70_02243F54: ; 0x02243F54
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x3d
	add r2, sp, #0
	bl ov70_0223F658
	add r5, r0, #0
	ldr r0, [r4, #0x30]
	ldr r1, [r4, #0x20]
	ldr r2, [sp]
	add r3, r5, #0
	bl ov70_0224342C
	add r4, r0, #0
	add r0, r5, #0
	bl Heap_Free
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov70_02243F54

	thumb_func_start ov70_02243F7C
ov70_02243F7C: ; 0x02243F7C
	push {r3, r4, r5, r6, r7, lr}
	ldr r2, _02243FC8 ; =ov70_02245E84
	lsl r3, r1, #2
	ldr r4, [r2, r3]
	ldr r2, _02243FCC ; =ov70_02245F5C
	lsl r1, r1, #3
	ldr r2, [r2, r1]
	add r7, r0, #0
	cmp r2, #0
	ble _02243FB4
	mov r5, #0
	cmp r2, #0
	ble _02243FC2
	ldr r0, _02243FD0 ; =ov70_02245F58
	add r6, r0, r1
_02243F9A:
	add r0, r7, #0
	add r1, r4, r5
	bl ov70_02243F54
	cmp r0, #0
	ble _02243FAA
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_02243FAA:
	ldr r0, [r6, #4]
	add r5, r5, #1
	cmp r5, r0
	blt _02243F9A
	b _02243FC2
_02243FB4:
	add r1, r4, #0
	bl ov70_02243F54
	cmp r0, #0
	ble _02243FC2
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_02243FC2:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_02243FC8: .word ov70_02245E84
_02243FCC: .word ov70_02245F5C
_02243FD0: .word ov70_02245F58
	thumb_func_end ov70_02243F7C

	thumb_func_start ov70_02243FD4
ov70_02243FD4: ; 0x02243FD4
	push {r3, lr}
	add r0, r1, #0
	add r1, sp, #0
	bl ov70_0223F8D0
	pop {r3, pc}
	thumb_func_end ov70_02243FD4

	thumb_func_start ov70_02243FE0
ov70_02243FE0: ; 0x02243FE0
	push {r3, r4, r5, r6, r7, lr}
	ldr r2, _0224402C ; =ov70_02245E84
	lsl r3, r1, #2
	ldr r4, [r2, r3]
	ldr r2, _02244030 ; =ov70_02245F5C
	lsl r1, r1, #3
	ldr r2, [r2, r1]
	add r7, r0, #0
	cmp r2, #0
	ble _02244018
	mov r5, #0
	cmp r2, #0
	ble _02244026
	ldr r0, _02244034 ; =ov70_02245F58
	add r6, r0, r1
_02243FFE:
	add r0, r7, #0
	add r1, r4, r5
	bl ov70_02243FD4
	cmp r0, #0
	ble _0224400E
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0224400E:
	ldr r0, [r6, #4]
	add r5, r5, #1
	cmp r5, r0
	blt _02243FFE
	b _02244026
_02244018:
	add r1, r4, #0
	bl ov70_02243FD4
	cmp r0, #0
	ble _02244026
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_02244026:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224402C: .word ov70_02245E84
_02244030: .word ov70_02245F5C
_02244034: .word ov70_02245F58
	thumb_func_end ov70_02243FE0

	thumb_func_start ov70_02244038
ov70_02244038: ; 0x02244038
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	bl ov70_02244670
	ldr r2, _02244114 ; =0x04000304
	ldr r0, _02244118 ; =0xFFFF7FFF
	ldrh r1, [r2]
	and r0, r1
	strh r0, [r2]
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0x3d
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4, #4]
	bl ov70_022441A4
	add r0, r4, #0
	bl ov70_022442B4
	add r0, r4, #0
	bl ov70_0224458C
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #2
	mov r1, #1
	bl GfGfx_EngineATogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #2
	mov r1, #1
	bl GfGfx_EngineBTogglePlanes
	mov r0, #4
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #8
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	bl ov00_021EC5B4
	cmp r0, #0
	bne _022440FA
	ldr r1, [r4]
	ldr r0, [r1, #0x3c]
	cmp r0, #0
	beq _022440EE
	ldr r0, [r1, #0x20]
	bl sub_02039418
	ldr r0, _0224411C ; =0x00000F0F
	mov r2, #1
	str r0, [sp]
	ldr r1, _02244120 ; =0x00000BA8
	add r0, r4, #0
	ldr r1, [r4, r1]
	add r3, r2, #0
	bl ov70_02244FA4
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #2
	bl ov70_02238D84
	add r0, r4, #0
	bl ov70_02238F64
	b _0224410C
_022440EE:
	mov r0, #4
	bl Sys_ClearSleepDisableFlag
	mov r0, #0
	str r0, [r4, #0x2c]
	b _0224410C
_022440FA:
	ldr r0, [r4]
	ldr r0, [r0, #0x20]
	bl sub_02039418
	add r0, r4, #0
	bl ov70_02245124
	mov r0, #0x11
	str r0, [r4, #0x2c]
_0224410C:
	mov r0, #2
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_02244114: .word 0x04000304
_02244118: .word 0xFFFF7FFF
_0224411C: .word 0x00000F0F
_02244120: .word 0x00000BA8
	thumb_func_end ov70_02244038

	thumb_func_start ov70_02244124
ov70_02244124: ; 0x02244124
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov70_02238E44
	bl sub_0203A930
	ldr r4, [r5, #0x2c]
	ldr r1, _02244150 ; =ov70_02246780
	lsl r2, r4, #2
	ldr r1, [r1, r2]
	add r0, r5, #0
	blx r1
	ldr r1, [r5, #0x2c]
	cmp r4, r1
	beq _0224414E
	mov r1, #0x16
	mov r2, #0
	lsl r1, r1, #8
	strh r2, [r5, r1]
	add r1, r1, #2
	strh r2, [r5, r1]
_0224414E:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02244150: .word ov70_02246780
	thumb_func_end ov70_02244124

	thumb_func_start ov70_02244154
ov70_02244154: ; 0x02244154
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _0224419C ; =0x000012D0
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0224416E
	bl SysTask_Destroy
	ldr r0, _0224419C ; =0x000012D0
	mov r1, #0
	str r1, [r4, r0]
	add r0, r0, #4
	str r1, [r4, r0]
_0224416E:
	add r0, r4, #0
	bl ov70_022446A8
	add r0, r4, #0
	bl ov70_02244644
	ldr r0, [r4, #4]
	bl ov70_02244290
	ldr r0, _022441A0 ; =0x000012D4
	mov r1, #0
	str r1, [r4, r0]
	add r0, r4, #0
	bl ov70_02238E58
	ldr r0, [r4, #0x14]
	cmp r0, #0
	bne _02244196
	mov r0, #5
	pop {r4, pc}
_02244196:
	mov r0, #1
	pop {r4, pc}
	nop
_0224419C: .word 0x000012D0
_022441A0: .word 0x000012D4
	thumb_func_end ov70_02244154

	thumb_func_start ov70_022441A4
ov70_022441A4: ; 0x022441A4
	push {r3, r4, r5, lr}
	sub sp, #0x70
	ldr r5, _02244280 ; =ov70_02246058
	add r4, r0, #0
	ldmia r5!, {r0, r1}
	add r3, sp, #0x54
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #0
	str r0, [r3]
	add r0, r4, #0
	add r3, r1, #0
	bl InitBgFromTemplate
	mov r0, #1
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	add r0, r4, #0
	mov r1, #0
	bl BgClearTilemapBufferAndCommit
	ldr r5, _02244284 ; =ov70_0224603C
	add r3, sp, #0x38
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #1
	str r0, [r3]
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #2
	mov r1, #0
	bl GfGfx_EngineATogglePlanes
	ldr r5, _02244288 ; =ov70_02246020
	add r3, sp, #0x1c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #4
	str r0, [r3]
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #1
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add r0, r4, #0
	mov r1, #4
	bl BgClearTilemapBufferAndCommit
	ldr r5, _0224428C ; =ov70_02246074
	add r3, sp, #0
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #5
	str r0, [r3]
	add r0, r4, #0
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #2
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	mov r0, #0
	mov r1, #0x20
	add r2, r0, #0
	mov r3, #0x3d
	bl BG_ClearCharDataRange
	mov r0, #4
	mov r1, #0x20
	mov r2, #0
	mov r3, #0x3d
	bl BG_ClearCharDataRange
	mov r0, #0x10
	mov r1, #0
	bl GfGfx_EngineBTogglePlanes
	add sp, #0x70
	pop {r3, r4, r5, pc}
	nop
_02244280: .word ov70_02246058
_02244284: .word ov70_0224603C
_02244288: .word ov70_02246020
_0224428C: .word ov70_02246074
	thumb_func_end ov70_022441A4

	thumb_func_start ov70_02244290
ov70_02244290: ; 0x02244290
	push {r4, lr}
	add r4, r0, #0
	mov r1, #5
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #4
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #1
	bl FreeBgTilemapBuffer
	add r0, r4, #0
	mov r1, #0
	bl FreeBgTilemapBuffer
	pop {r4, pc}
	thumb_func_end ov70_02244290

	thumb_func_start ov70_022442B4
ov70_022442B4: ; 0x022442B4
	push {r4, r5, r6, r7, lr}
	sub sp, #0x3c
	str r0, [sp, #0x10]
	ldr r4, [r0, #4]
	mov r0, #0x58
	mov r1, #0x3d
	bl NARC_New
	mov r2, #0
	str r2, [sp]
	mov r1, #0x3d
	str r1, [sp, #4]
	mov r1, #3
	add r3, r2, #0
	str r0, [sp, #0x2c]
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r3, #0
	str r3, [sp]
	mov r0, #0x3d
	str r0, [sp, #4]
	ldr r0, [sp, #0x2c]
	mov r1, #3
	mov r2, #4
	bl GfGfxLoader_GXLoadPalFromOpenNarc
	mov r1, #0x1a
	mov r0, #0
	lsl r1, r1, #4
	mov r2, #0x3d
	bl LoadFontPal1
	mov r1, #0x1a
	mov r0, #4
	lsl r1, r1, #4
	mov r2, #0x3d
	bl LoadFontPal1
	ldr r0, [sp, #0x10]
	ldr r0, [r0]
	ldr r0, [r0, #0x24]
	bl Options_GetFrame
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x3d
	str r0, [sp, #4]
	add r0, r4, #0
	mov r1, #0
	mov r2, #1
	mov r3, #0xe
	bl LoadUserFrameGfx2
	mov r1, #0
	str r1, [sp]
	mov r0, #0x3d
	str r0, [sp, #4]
	add r0, r4, #0
	mov r2, #0x1f
	mov r3, #0xb
	bl LoadUserFrameGfx1
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x3d
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	mov r1, #2
	add r2, r4, #0
	mov r3, #1
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r1, #0
	mov r0, #6
	str r1, [sp]
	lsl r0, r0, #8
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0x3d
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	mov r1, #6
	add r2, r4, #0
	mov r3, #1
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0x3d
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	mov r1, #0xb
	add r2, r4, #0
	mov r3, #5
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r1, #0
	mov r0, #6
	str r1, [sp]
	lsl r0, r0, #8
	str r0, [sp, #4]
	str r1, [sp, #8]
	mov r0, #0x3d
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x2c]
	mov r1, #0xc
	add r2, r4, #0
	mov r3, #5
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	add r1, r0, #0
	bl BG_SetMaskColor
	mov r0, #4
	mov r1, #0
	bl BG_SetMaskColor
	mov r2, #0x33
	ldr r1, _022444CC ; =0x000012D0
	ldr r0, [sp, #0x10]
	lsl r2, r2, #4
	add r0, r0, r1
	mov r1, #0
	bl MI_CpuFill8
	ldr r0, [sp, #0x2c]
	mov r1, #5
	add r2, sp, #0x38
	mov r3, #0x3d
	bl GfGfxLoader_GetPlttDataFromOpenNarc
	add r4, r0, #0
	ldr r0, [sp, #0x38]
	ldr r2, _022444D0 ; =0x000012D8
	ldr r1, [sp, #0x10]
	ldr r0, [r0, #0xc]
	add r1, r1, r2
	mov r2, #0x80
	bl MIi_CpuCopy16
	ldr r0, [sp, #0x38]
	ldr r2, _022444D4 ; =0x00001358
	ldr r1, [sp, #0x10]
	ldr r0, [r0, #0xc]
	add r1, r1, r2
	mov r2, #0x80
	bl MIi_CpuCopy16
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	str r0, [sp, #0x24]
	str r0, [sp, #0x28]
	ldr r1, _022444D4 ; =0x00001358
	ldr r0, [sp, #0x10]
	add r0, r0, r1
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x10]
	sub r1, #0x80
	add r0, r0, r1
	str r0, [sp, #0x14]
_02244404:
	mov r0, #0
	str r0, [sp, #0x20]
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x28]
	add r0, r0, #1
	lsl r1, r0, #5
	ldr r0, [sp, #0x10]
	add r0, r0, r1
	str r0, [sp, #0x30]
_02244416:
	ldr r0, [sp, #0x24]
	cmp r0, #0x15
	blt _02244420
	bl GF_AssertFail
_02244420:
	ldr r0, [sp, #0x30]
	mov r7, #1
	add r4, r0, #2
	ldr r0, [sp, #0x18]
	add r6, r0, #2
	ldr r0, [sp, #0x14]
	add r5, r0, #2
	ldr r0, [sp, #0x20]
	asr r0, r0, #8
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x34]
_02244438:
	ldr r0, _022444D0 ; =0x000012D8
	ldr r3, [sp, #0x34]
	ldrh r0, [r4, r0]
	add r1, r6, #0
	mov r2, #1
	str r0, [sp]
	add r0, r5, #0
	bl BlendPalette
	add r7, r7, #1
	add r4, r4, #2
	add r6, r6, #2
	add r5, r5, #2
	cmp r7, #0x10
	blt _02244438
	ldr r0, [sp, #0x18]
	add r0, #0x20
	str r0, [sp, #0x18]
	ldr r0, [sp, #0x24]
	add r0, r0, #1
	str r0, [sp, #0x24]
	ldr r0, [sp, #0x1c]
	cmp r0, #1
	beq _02244482
	mov r0, #3
	ldr r1, [sp, #0x20]
	lsl r0, r0, #8
	add r1, r1, r0
	mov r0, #1
	lsl r0, r0, #0xc
	str r1, [sp, #0x20]
	cmp r1, r0
	blt _02244416
	str r0, [sp, #0x20]
	mov r0, #1
	str r0, [sp, #0x1c]
	b _02244416
_02244482:
	ldr r0, [sp, #0x14]
	add r0, #0x20
	str r0, [sp, #0x14]
	ldr r0, [sp, #0x28]
	add r0, r0, #1
	str r0, [sp, #0x28]
	cmp r0, #3
	blt _02244404
	ldr r1, _022444D4 ; =0x00001358
	ldr r0, [sp, #0x10]
	add r0, r0, r1
	mov r1, #0x2a
	lsl r1, r1, #4
	bl DC_FlushRange
	ldr r1, _022444D8 ; =0x000012D4
	ldr r0, [sp, #0x10]
	mov r2, #1
	str r2, [r0, r1]
	ldr r2, _022444DC ; =0x000015FC
	mov r3, #0
	str r3, [r0, r2]
	sub r2, r1, #4
	ldr r1, [sp, #0x10]
	ldr r0, _022444E0 ; =ov70_022444E4
	add r1, r1, r2
	mov r2, #0x14
	bl SysTask_CreateOnVBlankQueue
	ldr r2, _022444CC ; =0x000012D0
	ldr r1, [sp, #0x10]
	str r0, [r1, r2]
	ldr r0, [sp, #0x2c]
	bl NARC_Delete
	add sp, #0x3c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_022444CC: .word 0x000012D0
_022444D0: .word 0x000012D8
_022444D4: .word 0x00001358
_022444D8: .word 0x000012D4
_022444DC: .word 0x000015FC
_022444E0: .word ov70_022444E4
	thumb_func_end ov70_022442B4

	thumb_func_start ov70_022444E4
ov70_022444E4: ; 0x022444E4
	push {r4, lr}
	add r4, r1, #0
	ldr r0, [r4, #4]
	cmp r0, #0
	beq _02244582
	ldr r1, _02244584 ; =0x0000032B
	mov r0, #1
	ldrb r2, [r4, r1]
	eor r2, r0
	strb r2, [r4, r1]
	ldrb r2, [r4, r1]
	tst r0, r2
	bne _02244582
	add r0, r1, #1
	ldr r0, [r4, r0]
	cmp r0, #1
	bhi _0224451A
	sub r0, r1, #3
	ldrsh r0, [r4, r0]
	add r2, r4, #0
	add r2, #0x88
	lsl r0, r0, #5
	add r0, r2, r0
	mov r1, #0
	mov r2, #0x20
	bl GX_LoadBGPltt
_0224451A:
	mov r0, #0xcb
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _02244528
	cmp r0, #2
	bne _0224453E
_02244528:
	mov r0, #0xca
	lsl r0, r0, #2
	ldrsh r0, [r4, r0]
	add r1, r4, #0
	add r1, #0x88
	lsl r0, r0, #5
	add r0, r1, r0
	mov r1, #0
	mov r2, #0x20
	bl GXS_LoadBGPltt
_0224453E:
	ldr r0, _02244588 ; =0x0000032A
	ldrsb r1, [r4, r0]
	cmp r1, #0
	bne _02244566
	sub r1, r0, #2
	ldrsh r1, [r4, r1]
	add r2, r1, #1
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsh r1, [r4, r1]
	cmp r1, #0x15
	blt _02244582
	mov r2, #0x13
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsb r2, [r4, r0]
	mov r1, #1
	eor r1, r2
	strb r1, [r4, r0]
	pop {r4, pc}
_02244566:
	sub r1, r0, #2
	ldrsh r1, [r4, r1]
	sub r2, r1, #1
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsh r1, [r4, r1]
	cmp r1, #0
	bge _02244582
	mov r2, #1
	sub r1, r0, #2
	strh r2, [r4, r1]
	ldrsb r1, [r4, r0]
	eor r1, r2
	strb r1, [r4, r0]
_02244582:
	pop {r4, pc}
	.balign 4, 0
_02244584: .word 0x0000032B
_02244588: .word 0x0000032A
	thumb_func_end ov70_022444E4

	thumb_func_start ov70_0224458C
ov70_0224458C: ; 0x0224458C
	push {r3, r4, lr}
	sub sp, #0x14
	mov r3, #4
	add r4, r0, #0
	str r3, [sp]
	mov r0, #0x17
	str r0, [sp, #4]
	mov r0, #0x10
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x94
	ldr r1, _02244634 ; =0x00000F48
	str r0, [sp, #0x10]
	ldr r0, [r4, #4]
	add r1, r4, r1
	mov r2, #0
	bl AddWindowParameterized
	ldr r0, _02244634 ; =0x00000F48
	mov r1, #0
	add r0, r4, r0
	bl FillWindowPixelBuffer
	mov r0, #1
	str r0, [sp]
	mov r0, #0x18
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x81
	lsl r0, r0, #2
	ldr r1, _02244638 ; =0x00000F38
	str r0, [sp, #0x10]
	ldr r0, [r4, #4]
	add r1, r4, r1
	mov r2, #0
	mov r3, #4
	bl AddWindowParameterized
	ldr r0, _02244638 ; =0x00000F38
	mov r1, #0
	add r0, r4, r0
	bl FillWindowPixelBuffer
	mov r3, #1
	mov r1, #0x2f
	ldr r0, _0224463C ; =0x000F0E00
	str r3, [sp]
	str r0, [sp, #4]
	ldr r0, _02244638 ; =0x00000F38
	lsl r1, r1, #6
	ldr r1, [r4, r1]
	add r0, r4, r0
	mov r2, #0
	bl ov70_02245050
	mov r0, #0x13
	str r0, [sp]
	mov r0, #0x1b
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xd
	str r0, [sp, #0xc]
	mov r0, #0x28
	ldr r1, _02244640 ; =0x00000F18
	str r0, [sp, #0x10]
	ldr r0, [r4, #4]
	add r1, r4, r1
	mov r2, #0
	mov r3, #2
	bl AddWindowParameterized
	ldr r0, _02244640 ; =0x00000F18
	mov r1, #0
	add r0, r4, r0
	bl FillWindowPixelBuffer
	add sp, #0x14
	pop {r3, r4, pc}
	nop
_02244634: .word 0x00000F48
_02244638: .word 0x00000F38
_0224463C: .word 0x000F0E00
_02244640: .word 0x00000F18
	thumb_func_end ov70_0224458C

	thumb_func_start ov70_02244644
ov70_02244644: ; 0x02244644
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02244664 ; =0x00000F18
	add r0, r4, r0
	bl RemoveWindow
	ldr r0, _02244668 ; =0x00000F38
	add r0, r4, r0
	bl RemoveWindow
	ldr r0, _0224466C ; =0x00000F48
	add r0, r4, r0
	bl RemoveWindow
	pop {r4, pc}
	nop
_02244664: .word 0x00000F18
_02244668: .word 0x00000F38
_0224466C: .word 0x00000F48
	thumb_func_end ov70_02244644

	thumb_func_start ov70_02244670
ov70_02244670: ; 0x02244670
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xb4
	mov r1, #0x3d
	bl String_New
	ldr r1, _022446A0 ; =0x00000BBC
	str r0, [r4, r1]
	mov r0, #1
	lsl r0, r0, #8
	mov r1, #0x3d
	bl String_New
	ldr r1, _022446A4 ; =0x00000BEC
	str r0, [r4, r1]
	sub r1, #0x4c
	ldr r0, [r4, r1]
	mov r1, #0x1f
	bl NewString_ReadMsgData
	mov r1, #0x2f
	lsl r1, r1, #6
	str r0, [r4, r1]
	pop {r4, pc}
	.balign 4, 0
_022446A0: .word 0x00000BBC
_022446A4: .word 0x00000BEC
	thumb_func_end ov70_02244670

	thumb_func_start ov70_022446A8
ov70_022446A8: ; 0x022446A8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _022446C8 ; =0x00000BEC
	ldr r0, [r4, r0]
	bl String_Delete
	ldr r0, _022446CC ; =0x00000BBC
	ldr r0, [r4, r0]
	bl String_Delete
	pop {r4, pc}
	.balign 4, 0
_022446C8: .word 0x00000BEC
_022446CC: .word 0x00000BBC
	thumb_func_end ov70_022446A8

	thumb_func_start ov70_022446D0
ov70_022446D0: ; 0x022446D0
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _022446FC ; =0x00000F0F
	add r4, r0, #0
	str r1, [sp]
	ldr r1, _02244700 ; =0x00000BAC
	mov r2, #0x11
	ldr r1, [r4, r1]
	mov r3, #1
	bl ov70_02244FA4
	add r0, r4, #0
	mov r1, #0xd
	mov r2, #1
	bl ov70_02238D84
	ldr r0, _02244704 ; =0x000011FA
	mov r1, #1
	strh r1, [r4, r0]
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_022446FC: .word 0x00000F0F
_02244700: .word 0x00000BAC
_02244704: .word 0x000011FA
	thumb_func_end ov70_022446D0

	thumb_func_start ov70_02244708
ov70_02244708: ; 0x02244708
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	bl ov70_02238C8C
	cmp r0, #1
	bne _02244742
	ldr r0, _02244768 ; =0x000011C8
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	ldr r0, _0224476C ; =0x00000F0F
	mov r2, #1
	str r0, [sp]
	ldr r1, _02244770 ; =0x00000BA8
	add r0, r4, #0
	ldr r1, [r4, r1]
	add r3, r2, #0
	bl ov70_02244FA4
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #2
	bl ov70_02238D84
	add r0, r4, #0
	bl ov70_02238F64
	b _02244760
_02244742:
	cmp r0, #2
	bne _02244760
	ldr r0, _02244768 ; =0x000011C8
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	bl sub_0203946C
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov70_02238E50
	mov r0, #0xb
	str r0, [r4, #0x2c]
_02244760:
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	nop
_02244768: .word 0x000011C8
_0224476C: .word 0x00000F0F
_02244770: .word 0x00000BA8
	thumb_func_end ov70_02244708

	thumb_func_start ov70_02244774
ov70_02244774: ; 0x02244774
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _0224479C ; =0x00000F0F
	add r4, r0, #0
	str r1, [sp]
	mov r1, #0xba
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	mov r2, #7
	mov r3, #1
	bl ov70_02244FA4
	add r0, r4, #0
	mov r1, #0xd
	mov r2, #0x10
	bl ov70_02238D84
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_0224479C: .word 0x00000F0F
	thumb_func_end ov70_02244774

	thumb_func_start ov70_022447A0
ov70_022447A0: ; 0x022447A0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02244800 ; =0x000011B0
	mov r1, #0x3d
	ldr r0, [r4, r0]
	bl Handle2dMenuInput_DeleteOnFinish
	mov r1, #0
	mvn r1, r1
	cmp r0, r1
	beq _022447FC
	sub r1, r1, #1
	cmp r0, r1
	bne _022447DE
	bl ov00_021EC5B4
	cmp r0, #0
	bne _022447CA
	mov r0, #0
	str r0, [r4, #0x2c]
	b _022447FC
_022447CA:
	add r0, r4, #0
	mov r1, #7
	mov r2, #0xb
	bl ov70_02238E50
	mov r0, #1
	str r0, [r4, #0x1c]
	mov r0, #0xb
	str r0, [r4, #0x2c]
	b _022447FC
_022447DE:
	bl ov00_021EC5B4
	cmp r0, #0
	beq _022447EA
	bl ov00_021EC8D8
_022447EA:
	bl sub_0203946C
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov70_02238E50
	mov r0, #0xb
	str r0, [r4, #0x2c]
_022447FC:
	mov r0, #3
	pop {r4, pc}
	.balign 4, 0
_02244800: .word 0x000011B0
	thumb_func_end ov70_022447A0

	thumb_func_start ov70_02244804
ov70_02244804: ; 0x02244804
	push {r3, r4, lr}
	sub sp, #4
	ldr r1, _0224482C ; =0x00000F0F
	add r4, r0, #0
	str r1, [sp]
	ldr r1, _02244830 ; =0x00000BAC
	mov r2, #0x1a
	ldr r1, [r4, r1]
	mov r3, #1
	bl ov70_02244FA4
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0x12
	bl ov70_02238D84
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	nop
_0224482C: .word 0x00000F0F
_02244830: .word 0x00000BAC
	thumb_func_end ov70_02244804

	thumb_func_start ov70_02244834
ov70_02244834: ; 0x02244834
	push {r4, lr}
	add r4, r0, #0
	bl sub_0203946C
	bl ov00_021EC8D8
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov70_02238E50
	mov r0, #0x13
	str r0, [r4, #0x2c]
	mov r0, #3
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02244834

	thumb_func_start ov70_02244854
ov70_02244854: ; 0x02244854
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	bl sub_0203A914
	ldr r0, _02244880 ; =0x00000F0F
	ldr r1, _02244884 ; =0x00000BAC
	str r0, [sp]
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r2, #0x1b
	mov r3, #1
	bl ov70_02244FA4
	add r0, r4, #0
	mov r1, #0x14
	mov r2, #0xb
	bl ov70_02238D84
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02244880: .word 0x00000F0F
_02244884: .word 0x00000BAC
	thumb_func_end ov70_02244854

	thumb_func_start ov70_02244888
ov70_02244888: ; 0x02244888
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	ldr r0, [r0, #0x20]
	bl sub_02039418
	mov r0, #4
	bl Sys_SetSleepDisableFlag
	add r0, r4, #0
	bl ov70_02245124
	add r0, r4, #0
	add r0, #0x54
	mov r1, #2
	mov r2, #1
	mov r3, #0x14
	bl ov00_021EC3F0
	mov r0, #2
	bl ov00_021EC454
	bl ov00_021EC4A4
	mov r0, #3
	str r0, [r4, #0x2c]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02244888

	thumb_func_start ov70_022448C0
ov70_022448C0: ; 0x022448C0
	push {r4, lr}
	sub sp, #0x48
	add r4, r0, #0
	bl ov00_021EC60C
	bl ov00_021EC5B4
	cmp r0, #0
	beq _0224493E
	bl ov00_021EC724
	cmp r0, #8
	bhi _0224491E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_022448E6: ; jump table
	.short _0224491E - _022448E6 - 2 ; case 0
	.short _0224491E - _022448E6 - 2 ; case 1
	.short _0224491E - _022448E6 - 2 ; case 2
	.short _0224491E - _022448E6 - 2 ; case 3
	.short _02244934 - _022448E6 - 2 ; case 4
	.short _0224491E - _022448E6 - 2 ; case 5
	.short _0224491E - _022448E6 - 2 ; case 6
	.short _022448F8 - _022448E6 - 2 ; case 7
	.short _0224491E - _022448E6 - 2 ; case 8
_022448F8:
	add r0, sp, #8
	add r1, sp, #4
	bl ov00_021EC11C
	str r0, [r4, #0x40]
	ldr r0, [sp, #8]
	str r0, [r4, #0x44]
	ldr r0, [sp, #4]
	str r0, [r4, #0x48]
	bl ov00_021EC210
	bl ov00_021EC8D8
	add r0, r4, #0
	bl ov70_02238F80
	mov r0, #0x17
	str r0, [r4, #0x2c]
	b _0224493E
_0224491E:
	add r0, sp, #0
	bl ov00_021EC0FC
	add r0, r4, #0
	bl ov70_02238F80
	mov r0, #0x15
	str r0, [r4, #0x2c]
	sub r0, #0x17
	str r0, [r4, #0x3c]
	b _0224493E
_02244934:
	add r0, sp, #0xc
	bl ov00_021EC9E0
	mov r0, #4
	str r0, [r4, #0x2c]
_0224493E:
	mov r0, #3
	add sp, #0x48
	pop {r4, pc}
	thumb_func_end ov70_022448C0

	thumb_func_start ov70_02244944
ov70_02244944: ; 0x02244944
	push {r4, lr}
	add r4, r0, #0
	bl ov00_021ECD04
	mov r0, #5
	str r0, [r4, #0x2c]
	mov r0, #3
	pop {r4, pc}
	thumb_func_end ov70_02244944

	thumb_func_start ov70_02244954
ov70_02244954: ; 0x02244954
	push {r4, lr}
	sub sp, #8
	add r4, r0, #0
	bl ov00_021ECDC8
	cmp r0, #5
	bhi _022449F4
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224496E: ; jump table
	.short _02244980 - _0224496E - 2 ; case 0
	.short _022449F4 - _0224496E - 2 ; case 1
	.short _022449F4 - _0224496E - 2 ; case 2
	.short _0224497A - _0224496E - 2 ; case 3
	.short _02244980 - _0224496E - 2 ; case 4
	.short _02244980 - _0224496E - 2 ; case 5
_0224497A:
	mov r0, #6
	str r0, [r4, #0x2c]
	b _022449F4
_02244980:
	add r0, r4, #0
	bl ov70_02238F80
	add r0, sp, #4
	add r1, sp, #0
	bl ov00_021EC11C
	str r0, [r4, #0x40]
	ldr r0, [sp, #4]
	str r0, [r4, #0x44]
	bl ov00_021EC210
	bl ov00_021EC8D8
	mov r0, #0x17
	str r0, [r4, #0x2c]
	ldr r1, [sp]
	cmp r1, #7
	bhi _022449E2
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_022449B2: ; jump table
	.short _022449E2 - _022449B2 - 2 ; case 0
	.short _022449C2 - _022449B2 - 2 ; case 1
	.short _022449C2 - _022449B2 - 2 ; case 2
	.short _022449D4 - _022449B2 - 2 ; case 3
	.short _022449C6 - _022449B2 - 2 ; case 4
	.short _022449DE - _022449B2 - 2 ; case 5
	.short _022449D0 - _022449B2 - 2 ; case 6
	.short _022449DE - _022449B2 - 2 ; case 7
_022449C2:
	str r0, [r4, #0x2c]
	b _022449E2
_022449C6:
	bl ov00_021FA0D8
	mov r0, #0x17
	str r0, [r4, #0x2c]
	b _022449E2
_022449D0:
	str r0, [r4, #0x2c]
	b _022449E2
_022449D4:
	bl ov00_021ED9B4
	mov r0, #0x17
	str r0, [r4, #0x2c]
	b _022449E2
_022449DE:
	bl sub_020399EC
_022449E2:
	ldr r1, [sp, #4]
	ldr r0, _022449FC ; =0xFFFFB1E0
	cmp r1, r0
	bge _022449F4
	ldr r0, _02244A00 ; =0xFFFF8AD1
	cmp r1, r0
	blt _022449F4
	mov r0, #0x17
	str r0, [r4, #0x2c]
_022449F4:
	mov r0, #3
	add sp, #8
	pop {r4, pc}
	nop
_022449FC: .word 0xFFFFB1E0
_02244A00: .word 0xFFFF8AD1
	thumb_func_end ov70_02244954

	thumb_func_start ov70_02244A04
ov70_02244A04: ; 0x02244A04
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #0x14]
	bl sub_0202C08C
	add r4, r0, #0
	ldr r0, [r5]
	ldr r0, [r0, #4]
	bl Save_SysInfo_GetDwcProfileId
	cmp r0, #0
	bne _02244A28
	ldr r1, [r5]
	ldr r0, [r1, #4]
	ldr r1, [r1, #0x34]
	bl Save_SysInfo_SetDwcProfileId
_02244A28:
	ldr r0, [r5]
	ldr r0, [r0, #4]
	bl Save_SysInfo_GetDwcProfileId
	add r6, r0, #0
	add r0, r4, #0
	bl DWC_CreateFriendKey
	add r3, r0, #0
	add r2, r1, #0
	add r0, r6, #0
	add r1, r3, #0
	bl ov70_022378C0
	mov r0, #7
	str r0, [r5, #0x2c]
	mov r0, #3
	pop {r4, r5, r6, pc}
	thumb_func_end ov70_02244A04

	thumb_func_start ov70_02244A4C
ov70_02244A4C: ; 0x02244A4C
	push {r4, lr}
	add r4, r0, #0
	bl ov70_022382C0
	mov r0, #8
	str r0, [r4, #0x2c]
	ldr r0, _02244A64 ; =0x00001604
	mov r1, #0
	str r1, [r4, r0]
	mov r0, #3
	pop {r4, pc}
	nop
_02244A64: .word 0x00001604
	thumb_func_end ov70_02244A4C

	thumb_func_start ov70_02244A68
ov70_02244A68: ; 0x02244A68
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov70_02237F38
	cmp r0, #0
	beq _02244B02
	bl ov70_02237F58
	add r5, r0, #0
	ldr r0, _02244B1C ; =0x00001604
	mov r1, #0
	str r1, [r4, r0]
	add r0, r5, #0
	add r0, #0xf
	cmp r0, #0x11
	bhi _02244AF6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02244A94: ; jump table
	.short _02244ADA - _02244A94 - 2 ; case 0
	.short _02244AE8 - _02244A94 - 2 ; case 1
	.short _02244AF6 - _02244A94 - 2 ; case 2
	.short _02244ADA - _02244A94 - 2 ; case 3
	.short _02244AF6 - _02244A94 - 2 ; case 4
	.short _02244AF6 - _02244A94 - 2 ; case 5
	.short _02244AF6 - _02244A94 - 2 ; case 6
	.short _02244AF6 - _02244A94 - 2 ; case 7
	.short _02244AF6 - _02244A94 - 2 ; case 8
	.short _02244AF6 - _02244A94 - 2 ; case 9
	.short _02244AF6 - _02244A94 - 2 ; case 10
	.short _02244AF6 - _02244A94 - 2 ; case 11
	.short _02244AF6 - _02244A94 - 2 ; case 12
	.short _02244AE8 - _02244A94 - 2 ; case 13
	.short _02244ACC - _02244A94 - 2 ; case 14
	.short _02244AB8 - _02244A94 - 2 ; case 15
	.short _02244ABE - _02244A94 - 2 ; case 16
	.short _02244ACC - _02244A94 - 2 ; case 17
_02244AB8:
	mov r0, #9
	str r0, [r4, #0x2c]
	b _02244B18
_02244ABE:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244B18
_02244ACC:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244B18
_02244ADA:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244B18
_02244AE8:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244B18
_02244AF6:
	add r0, r4, #0
	bl ov70_02238F80
	bl sub_020399EC
	b _02244B18
_02244B02:
	ldr r0, _02244B1C ; =0x00001604
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	ldr r1, [r4, r0]
	mov r0, #0xe1
	lsl r0, r0, #4
	cmp r1, r0
	bne _02244B18
	bl sub_020399EC
_02244B18:
	mov r0, #3
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02244B1C: .word 0x00001604
	thumb_func_end ov70_02244A68

	thumb_func_start ov70_02244B20
ov70_02244B20: ; 0x02244B20
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	ldr r1, _02244B4C ; =0x00001260
	ldr r0, [r0, #0x20]
	add r1, r4, r1
	bl sub_0203189C
	ldr r1, _02244B4C ; =0x00001260
	add r0, r4, r1
	add r1, #0x64
	add r1, r4, r1
	bl ov70_02238304
	mov r0, #0xa
	str r0, [r4, #0x2c]
	ldr r0, _02244B50 ; =0x00001604
	mov r1, #0
	str r1, [r4, r0]
	mov r0, #3
	pop {r4, pc}
	nop
_02244B4C: .word 0x00001260
_02244B50: .word 0x00001604
	thumb_func_end ov70_02244B20

	thumb_func_start ov70_02244B54
ov70_02244B54: ; 0x02244B54
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov70_02237F38
	cmp r0, #0
	bne _02244B62
	b _02244C72
_02244B62:
	bl ov70_02237F58
	add r5, r0, #0
	ldr r0, _02244C8C ; =0x00001604
	mov r1, #0
	str r1, [r4, r0]
	add r0, r5, #0
	add r0, #0xf
	cmp r0, #0x11
	bhi _02244C66
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02244B82: ; jump table
	.short _02244C4A - _02244B82 - 2 ; case 0
	.short _02244C58 - _02244B82 - 2 ; case 1
	.short _02244C66 - _02244B82 - 2 ; case 2
	.short _02244C4A - _02244B82 - 2 ; case 3
	.short _02244C66 - _02244B82 - 2 ; case 4
	.short _02244C66 - _02244B82 - 2 ; case 5
	.short _02244C66 - _02244B82 - 2 ; case 6
	.short _02244C66 - _02244B82 - 2 ; case 7
	.short _02244C66 - _02244B82 - 2 ; case 8
	.short _02244C66 - _02244B82 - 2 ; case 9
	.short _02244C66 - _02244B82 - 2 ; case 10
	.short _02244C66 - _02244B82 - 2 ; case 11
	.short _02244C66 - _02244B82 - 2 ; case 12
	.short _02244C58 - _02244B82 - 2 ; case 13
	.short _02244C3C - _02244B82 - 2 ; case 14
	.short _02244BA6 - _02244B82 - 2 ; case 15
	.short _02244C2E - _02244B82 - 2 ; case 16
	.short _02244C3C - _02244B82 - 2 ; case 17
_02244BA6:
	add r0, r4, #0
	bl ov70_02238F80
	ldr r0, _02244C90 ; =0x000012C4
	ldr r1, [r4, r0]
	cmp r1, #0
	beq _02244BBE
	cmp r1, #1
	beq _02244C0E
	cmp r1, #2
	beq _02244C18
	b _02244C22
_02244BBE:
	add r0, r0, #4
	ldr r0, [r4, r0]
	cmp r0, #3
	bhi _02244C08
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02244BD2: ; jump table
	.short _02244BDA - _02244BD2 - 2 ; case 0
	.short _02244BF4 - _02244BD2 - 2 ; case 1
	.short _02244BFE - _02244BD2 - 2 ; case 2
	.short _02244BEA - _02244BD2 - 2 ; case 3
_02244BDA:
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov70_02238E50
	mov r0, #0xb
	str r0, [r4, #0x2c]
	b _02244C88
_02244BEA:
	ldr r0, _02244C94 ; =0xFFFFEC75
	str r0, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244BF4:
	ldr r0, _02244C98 ; =0xFFFFEC78
	str r0, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244BFE:
	ldr r0, _02244C9C ; =0xFFFFEC77
	str r0, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244C08:
	bl sub_020399EC
	b _02244C88
_02244C0E:
	ldr r0, _02244CA0 ; =0xFFFFEC74
	str r0, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244C18:
	ldr r0, _02244CA4 ; =0xFFFFEC73
	str r0, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244C22:
	add r0, r4, #0
	bl ov70_02238F80
	bl sub_020399EC
	b _02244C88
_02244C2E:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244C3C:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244C4A:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244C58:
	add r0, r4, #0
	bl ov70_02238F80
	str r5, [r4, #0x3c]
	mov r0, #0x15
	str r0, [r4, #0x2c]
	b _02244C88
_02244C66:
	add r0, r4, #0
	bl ov70_02238F80
	bl sub_020399EC
	b _02244C88
_02244C72:
	ldr r0, _02244C8C ; =0x00001604
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
	ldr r1, [r4, r0]
	mov r0, #0xe1
	lsl r0, r0, #4
	cmp r1, r0
	bne _02244C88
	bl sub_020399EC
_02244C88:
	mov r0, #3
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02244C8C: .word 0x00001604
_02244C90: .word 0x000012C4
_02244C94: .word 0xFFFFEC75
_02244C98: .word 0xFFFFEC78
_02244C9C: .word 0xFFFFEC77
_02244CA0: .word 0xFFFFEC74
_02244CA4: .word 0xFFFFEC73
	thumb_func_end ov70_02244B54

	thumb_func_start ov70_02244CA8
ov70_02244CA8: ; 0x02244CA8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x44]
	ldr r1, [r4, #0x48]
	neg r0, r0
	bl ov00_021E6A70
	ldr r2, [r4, #0x44]
	add r1, r0, #0
	add r0, r4, #0
	neg r2, r2
	bl ov70_022451A8
	mov r0, #0x18
	str r0, [r4, #0x2c]
	mov r0, #3
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02244CA8

	thumb_func_start ov70_02244CCC
ov70_02244CCC: ; 0x02244CCC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _02244CFC ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #1
	tst r0, r1
	bne _02244CE8
	mov r0, #2
	tst r0, r1
	bne _02244CE8
	ldr r0, _02244D00 ; =gSystem + 0x40
	ldrh r0, [r0, #0x24]
	cmp r0, #0
	beq _02244CF6
_02244CE8:
	ldr r0, _02244D04 ; =0x00000F48
	mov r1, #0
	add r0, r4, r0
	bl sub_0200E5D4
	mov r0, #0
	str r0, [r4, #0x2c]
_02244CF6:
	mov r0, #3
	pop {r4, pc}
	nop
_02244CFC: .word gSystem
_02244D00: .word gSystem + 0x40
_02244D04: .word 0x00000F48
	thumb_func_end ov70_02244CCC

	thumb_func_start ov70_02244D08
ov70_02244D08: ; 0x02244D08
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	bl sub_0203A914
	add r0, r4, #0
	bl ov70_02238F80
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0x3d
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0
	str r0, [r4, #0x2c]
	ldr r0, _02244D40 ; =0x000011FC
	mov r1, #1
	str r1, [r4, r0]
	mov r0, #4
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_02244D40: .word 0x000011FC
	thumb_func_end ov70_02244D08

	thumb_func_start ov70_02244D44
ov70_02244D44: ; 0x02244D44
	push {r4, lr}
	add r4, r0, #0
	bl ov70_02238C8C
	cmp r0, #1
	bne _02244D68
	ldr r0, _02244D7C ; =0x000011C8
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov70_02238E50
	mov r0, #0xb
	str r0, [r4, #0x2c]
	b _02244D78
_02244D68:
	cmp r0, #2
	bne _02244D78
	ldr r0, _02244D7C ; =0x000011C8
	ldr r0, [r4, r0]
	bl YesNoPrompt_Destroy
	mov r0, #0
	str r0, [r4, #0x2c]
_02244D78:
	mov r0, #3
	pop {r4, pc}
	.balign 4, 0
_02244D7C: .word 0x000011C8
	thumb_func_end ov70_02244D44

	thumb_func_start ov70_02244D80
ov70_02244D80: ; 0x02244D80
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r2, #0xd
	ldr r0, [r4, #0x3c]
	mvn r2, r2
	cmp r0, r2
	bgt _02244DBE
	bge _02244DFA
	ldr r1, _02244E38 ; =0xFFFFEC78
	cmp r0, r1
	bgt _02244DB6
	ldr r1, _02244E3C ; =0x0000138D
	add r1, r0, r1
	bmi _02244DFE
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02244DAA: ; jump table
	.short _02244E12 - _02244DAA - 2 ; case 0
	.short _02244E0E - _02244DAA - 2 ; case 1
	.short _02244E02 - _02244DAA - 2 ; case 2
	.short _02244DFE - _02244DAA - 2 ; case 3
	.short _02244E0A - _02244DAA - 2 ; case 4
	.short _02244E06 - _02244DAA - 2 ; case 5
_02244DB6:
	mov r1, #0xe
	mvn r1, r1
	cmp r0, r1
	b _02244DFE
_02244DBE:
	add r1, r2, #0
	add r1, #9
	cmp r0, r1
	bgt _02244DD4
	add r1, r2, #0
	add r1, #9
	cmp r0, r1
	bge _02244DFE
	add r1, r2, #2
	cmp r0, r1
	b _02244DFE
_02244DD4:
	add r0, r0, #3
	cmp r0, #5
	bhi _02244DFE
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_02244DE6: ; jump table
	.short _02244DFE - _02244DE6 - 2 ; case 0
	.short _02244DFA - _02244DE6 - 2 ; case 1
	.short _02244DF6 - _02244DE6 - 2 ; case 2
	.short _02244DFE - _02244DE6 - 2 ; case 3
	.short _02244DF2 - _02244DE6 - 2 ; case 4
	.short _02244DF6 - _02244DE6 - 2 ; case 5
_02244DF2:
	mov r2, #0x96
	b _02244E14
_02244DF6:
	mov r2, #0x97
	b _02244E14
_02244DFA:
	mov r2, #0x9c
	b _02244E14
_02244DFE:
	mov r2, #0x9b
	b _02244E14
_02244E02:
	mov r2, #0xb9
	b _02244E14
_02244E06:
	mov r2, #0xb6
	b _02244E14
_02244E0A:
	mov r2, #0xb6
	b _02244E14
_02244E0E:
	mov r2, #0xb7
	b _02244E14
_02244E12:
	mov r2, #0xb8
_02244E14:
	ldr r0, _02244E40 ; =0x00000F0F
	mov r1, #0xba
	str r0, [sp]
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	add r0, r4, #0
	mov r3, #1
	bl ov70_02244FA4
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0x16
	bl ov70_02238D84
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	nop
_02244E38: .word 0xFFFFEC78
_02244E3C: .word 0x0000138D
_02244E40: .word 0x00000F0F
	thumb_func_end ov70_02244D80

	thumb_func_start ov70_02244E44
ov70_02244E44: ; 0x02244E44
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0x16
	add r4, r0, #0
	lsl r1, r1, #8
	ldrsh r1, [r4, r1]
	cmp r1, #3
	bhi _02244EE8
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_02244E60: ; jump table
	.short _02244E68 - _02244E60 - 2 ; case 0
	.short _02244E86 - _02244E60 - 2 ; case 1
	.short _02244EAC - _02244E60 - 2 ; case 2
	.short _02244ECA - _02244E60 - 2 ; case 3
_02244E68:
	ldr r1, _02244F0C ; =0x00000F0F
	mov r2, #0xba
	str r1, [sp]
	mov r1, #0xba
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	mov r3, #1
	bl ov70_02244FA4
	mov r0, #0x16
	lsl r0, r0, #8
	ldrsh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	b _02244F04
_02244E86:
	mov r0, #0xbf
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _02244F04
	bl sub_0203946C
	bl ov00_021EC8D8
	mov r0, #0x16
	lsl r0, r0, #8
	ldrsh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	b _02244F04
_02244EAC:
	ldr r1, _02244F0C ; =0x00000F0F
	mov r2, #0xbb
	str r1, [sp]
	mov r1, #0xba
	lsl r1, r1, #4
	ldr r1, [r4, r1]
	mov r3, #1
	bl ov70_02244FA4
	mov r0, #0x16
	lsl r0, r0, #8
	ldrsh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	b _02244F04
_02244ECA:
	mov r0, #0xbf
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _02244F04
	mov r0, #0x16
	lsl r0, r0, #8
	ldrsh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	b _02244F04
_02244EE8:
	ldr r0, _02244F10 ; =0x00001602
	ldrsh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	ldrsh r0, [r4, r0]
	cmp r0, #0x1e
	ble _02244F04
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	bl ov70_02238E50
	mov r0, #0xb
	str r0, [r4, #0x2c]
_02244F04:
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	nop
_02244F0C: .word 0x00000F0F
_02244F10: .word 0x00001602
	thumb_func_end ov70_02244E44

	thumb_func_start ov70_02244F14
ov70_02244F14: ; 0x02244F14
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xbf
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _02244F2E
	ldr r0, [r4, #0x30]
	str r0, [r4, #0x2c]
_02244F2E:
	mov r0, #3
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02244F14

	thumb_func_start ov70_02244F34
ov70_02244F34: ; 0x02244F34
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0xbf
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _02244F62
	mov r0, #0x47
	lsl r0, r0, #6
	ldr r0, [r4, r0]
	cmp r0, #0x1e
	ble _02244F58
	ldr r0, [r4, #0x30]
	str r0, [r4, #0x2c]
_02244F58:
	mov r0, #0x47
	lsl r0, r0, #6
	ldr r1, [r4, r0]
	add r1, r1, #1
	str r1, [r4, r0]
_02244F62:
	mov r0, #3
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02244F34

	thumb_func_start ov70_02244F68
ov70_02244F68: ; 0x02244F68
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r0, #0xbf
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl TextPrinterCheckActive
	cmp r0, #0
	bne _02244F9A
	mov r0, #0
	str r0, [sp]
	mov r2, #0x8d
	ldr r0, [r4, #4]
	mov r1, #0xa
	lsl r2, r2, #2
	mov r3, #8
	bl ov70_02238C14
	ldr r1, _02244FA0 ; =0x000011C8
	str r0, [r4, r1]
	ldr r0, [r4, #0x30]
	str r0, [r4, #0x2c]
_02244F9A:
	mov r0, #3
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_02244FA0: .word 0x000011C8
	thumb_func_end ov70_02244F68

	thumb_func_start ov70_02244FA4
ov70_02244FA4: ; 0x02244FA4
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r0, r1, #0
	add r1, r2, #0
	add r4, r3, #0
	bl NewString_ReadMsgData
	add r6, r0, #0
	ldr r1, _0224500C ; =0x00000B9C
	add r2, r6, #0
	ldr r0, [r5, r1]
	add r1, #0x20
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	add r0, r6, #0
	bl String_Delete
	ldr r0, _02245010 ; =0x00000F18
	mov r1, #0xf
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _02245010 ; =0x00000F18
	mov r1, #0
	add r0, r5, r0
	mov r2, #1
	mov r3, #0xe
	bl DrawFrameAndWindow2
	mov r3, #0
	str r3, [sp]
	str r4, [sp, #4]
	ldr r0, _02245010 ; =0x00000F18
	ldr r2, _02245014 ; =0x00000BBC
	str r3, [sp, #8]
	ldr r2, [r5, r2]
	add r0, r5, r0
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xbf
	lsl r1, r1, #4
	str r0, [r5, r1]
	mov r0, #0x47
	mov r1, #0
	lsl r0, r0, #6
	str r1, [r5, r0]
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	nop
_0224500C: .word 0x00000B9C
_02245010: .word 0x00000F18
_02245014: .word 0x00000BBC
	thumb_func_end ov70_02244FA4

	thumb_func_start ov70_02245018
ov70_02245018: ; 0x02245018
	push {r4, lr}
	add r4, r0, #0
	cmp r3, #1
	beq _02245026
	cmp r3, #2
	beq _0224503C
	b _0224504A
_02245026:
	ldr r0, [sp, #0xc]
	mov r2, #0
	bl FontID_String_GetWidth
	ldrb r1, [r4, #7]
	lsl r1, r1, #3
	sub r1, r1, r0
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r2, r0, #1
	b _0224504A
_0224503C:
	ldr r0, [sp, #0xc]
	mov r2, #0
	bl FontID_String_GetWidth
	ldrb r1, [r4, #7]
	lsl r1, r1, #3
	sub r2, r1, r0
_0224504A:
	add r0, r2, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov70_02245018

	thumb_func_start ov70_02245050
ov70_02245050: ; 0x02245050
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r3, #0
	ldr r3, [sp, #0x24]
	add r5, r0, #0
	str r3, [sp]
	mov r3, #1
	str r3, [sp, #4]
	ldr r3, [sp, #0x20]
	add r6, r1, #0
	bl ov70_02245018
	add r3, r0, #0
	str r4, [sp]
	mov r1, #0
	ldr r0, [sp, #0x24]
	str r1, [sp, #4]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r0, r5, #0
	mov r1, #1
	add r2, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r4, r5, r6, pc}
	thumb_func_end ov70_02245050

	thumb_func_start ov70_02245084
ov70_02245084: ; 0x02245084
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r3, #0
	ldr r3, [sp, #0x24]
	add r5, r0, #0
	str r3, [sp]
	mov r3, #0
	str r3, [sp, #4]
	ldr r3, [sp, #0x20]
	add r6, r1, #0
	bl ov70_02245018
	add r3, r0, #0
	str r4, [sp]
	mov r1, #0
	ldr r0, [sp, #0x24]
	str r1, [sp, #4]
	str r0, [sp, #8]
	add r0, r5, #0
	add r2, r6, #0
	str r1, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov70_02245084

	thumb_func_start ov70_022450B8
ov70_022450B8: ; 0x022450B8
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r3, #0
	ldr r3, [sp, #0x24]
	add r5, r0, #0
	str r3, [sp]
	mov r3, #0
	str r3, [sp, #4]
	ldr r3, [sp, #0x20]
	add r6, r1, #0
	bl ov70_02245018
	add r3, r0, #0
	str r4, [sp]
	mov r1, #0
	ldr r0, [sp, #0x24]
	str r1, [sp, #4]
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r0, r5, #0
	mov r1, #4
	add r2, r6, #0
	bl AddTextPrinterParameterizedWithColor
	add sp, #0x10
	pop {r4, r5, r6, pc}
	thumb_func_end ov70_022450B8

	thumb_func_start ov70_022450EC
ov70_022450EC: ; 0x022450EC
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	add r0, r1, #0
	ldr r1, _0224511C ; =ov70_0224600C
	lsl r2, r2, #2
	ldr r1, [r1, r2]
	bl NewString_ReadMsgData
	add r4, r0, #0
	mov r2, #0
	ldr r0, _02245120 ; =0x00010200
	str r2, [sp]
	str r0, [sp, #4]
	add r0, r5, #0
	add r1, r4, #0
	add r3, r2, #0
	bl ov70_02245084
	add r0, r4, #0
	bl String_Delete
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224511C: .word ov70_0224600C
_02245120: .word 0x00010200
	thumb_func_end ov70_022450EC

	thumb_func_start ov70_02245124
ov70_02245124: ; 0x02245124
	ldr r3, _02245128 ; =sub_0203A880
	bx r3
	.balign 4, 0
_02245128: .word sub_0203A880
	thumb_func_end ov70_02245124

	thumb_func_start ov70_0224512C
ov70_0224512C: ; 0x0224512C
	push {r3, r4, r5, r6, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #1
	add r6, r1, #0
	lsl r0, r0, #8
	mov r1, #0x3d
	bl String_New
	add r4, r0, #0
	ldr r0, _02245198 ; =0x00000BAC
	add r1, r6, #0
	ldr r0, [r5, r0]
	add r2, r4, #0
	bl ReadMsgDataIntoString
	ldr r1, _0224519C ; =0x00000B9C
	add r2, r4, #0
	ldr r0, [r5, r1]
	add r1, #0x50
	ldr r1, [r5, r1]
	bl StringExpandPlaceholders
	ldr r0, _022451A0 ; =0x00000F48
	mov r1, #0xf
	add r0, r5, r0
	bl FillWindowPixelBuffer
	ldr r0, _022451A0 ; =0x00000F48
	mov r1, #1
	add r0, r5, r0
	mov r2, #0x1f
	mov r3, #0xb
	bl DrawFrameAndWindow1
	mov r3, #0
	str r3, [sp]
	str r3, [sp, #4]
	ldr r0, _022451A0 ; =0x00000F48
	ldr r2, _022451A4 ; =0x00000BEC
	str r3, [sp, #8]
	ldr r2, [r5, r2]
	add r0, r5, r0
	mov r1, #1
	bl AddTextPrinterParameterized
	mov r1, #0xbf
	lsl r1, r1, #4
	str r0, [r5, r1]
	add r0, r4, #0
	bl String_Delete
	add sp, #0xc
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_02245198: .word 0x00000BAC
_0224519C: .word 0x00000B9C
_022451A0: .word 0x00000F48
_022451A4: .word 0x00000BEC
	thumb_func_end ov70_0224512C

	thumb_func_start ov70_022451A8
ov70_022451A8: ; 0x022451A8
	push {r3, r4, r5, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0
	add r4, r1, #0
	mvn r0, r0
	cmp r4, r0
	bne _022451BA
	mov r4, #0xb
_022451BA:
	mov r0, #2
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	ldr r0, _022451E4 ; =0x00000B9C
	mov r1, #0
	ldr r0, [r5, r0]
	mov r3, #5
	bl BufferIntegerAsString
	ldr r0, _022451E8 ; =0x00000F18
	mov r1, #1
	add r0, r5, r0
	bl ClearFrameAndWindow2
	add r0, r5, #0
	add r1, r4, #0
	bl ov70_0224512C
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_022451E4: .word 0x00000B9C
_022451E8: .word 0x00000F18
	thumb_func_end ov70_022451A8
