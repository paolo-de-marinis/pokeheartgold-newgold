	.include "asm/macros.inc"
	.include "overlay_12_battle_controller.inc"
	.include "global.inc"

	.text

	thumb_func_start BattleController_EmitRecallPokemon
BattleController_EmitRecallPokemon: ; 0x02262734
	push {r4, r5, r6, r7, lr}
	sub sp, #0x3c
	add r4, r1, #0
	lsl r1, r2, #2
	str r0, [sp, #4]
	add r0, r0, r1
	ldr r1, [r0, #0x34]
	ldr r0, _02262880 ; =0x00000195
	str r2, [sp, #8]
	ldrb r1, [r1, r0]
	mov r0, #1
	tst r0, r1
	beq _02262752
	mov r2, #2
	b _02262754
_02262752:
	mov r2, #0
_02262754:
	ldr r1, [sp, #8]
	mov r0, #0xc0
	mul r0, r1
	ldr r1, [sp, #4]
	mov r6, #5
	ldr r1, [r1, #0x30]
	add r5, sp, #0xc
	add r3, r1, r0
	ldr r1, _02262884 ; =0x00002D66
	ldrb r3, [r3, r1]
	strb r6, [r5]
	ldr r5, [sp, #4]
	lsl r3, r3, #0x1b
	ldr r5, [r5, #0x30]
	lsr r3, r3, #0x1b
	add r5, r5, r0
	add r0, r1, #0
	add r0, #0x4a
	ldr r6, [r5, r0]
	mov r0, #2
	lsl r0, r0, #0x14
	tst r0, r6
	beq _022627A6
	add r0, r1, #0
	add r0, #0x7e
	ldr r0, [r5, r0]
	lsl r2, r2, #0x18
	str r0, [sp]
	add r0, r1, #0
	add r1, #0x94
	ldrh r1, [r5, r1]
	sub r0, #0x26
	lsl r3, r3, #0x18
	lsl r1, r1, #0x18
	ldrh r0, [r5, r0]
	lsr r1, r1, #0x18
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl GetMonPicHeightBySpeciesGenderForm
	b _022627C8
_022627A6:
	add r0, r1, #0
	add r0, #0x42
	ldr r0, [r5, r0]
	lsl r2, r2, #0x18
	str r0, [sp]
	add r0, r1, #0
	add r1, #0x58
	ldrb r1, [r5, r1]
	sub r0, #0x26
	lsl r3, r3, #0x18
	lsl r1, r1, #0x1c
	ldrh r0, [r5, r0]
	lsr r1, r1, #0x1c
	lsr r2, r2, #0x18
	lsr r3, r3, #0x18
	bl GetMonPicHeightBySpeciesGenderForm
_022627C8:
	add r1, sp, #0xc
	strb r0, [r1, #1]
	ldr r1, [sp, #8]
	mov r0, #0xc0
	mul r0, r1
	ldr r1, [sp, #4]
	ldr r2, _02262888 ; =0x00002DBF
	ldr r1, [r1, #0x30]
	add r1, r1, r0
	ldrb r3, [r1, r2]
	add r1, sp, #0xc
	sub r2, #0xf
	strh r3, [r1, #2]
	ldr r1, [sp, #4]
	ldr r1, [r1, #0x30]
	add r0, r1, r0
	ldr r1, [r0, r2]
	mov r0, #1
	lsl r0, r0, #0x18
	tst r0, r1
	beq _022627F6
	mov r0, #1
	b _022627F8
_022627F6:
	mov r0, #0
_022627F8:
	str r0, [sp, #0x10]
	ldr r0, [sp, #4]
	add r7, sp, #0xc
	ldr r1, [r0, #0x30]
	ldr r0, [sp, #8]
	add r3, r7, #0
	add r1, r1, r0
	ldr r0, _0226288C ; =0x0000219C
	add r5, r7, #0
	ldrb r0, [r1, r0]
	str r0, [sp, #0x38]
	mov r0, #0
	mov ip, r0
	ldr r0, _02262884 ; =0x00002D66
	add r2, r4, r0
	add r0, #0x58
	add r6, r4, r0
_0226281A:
	mov r0, #0xb5
	lsl r0, r0, #6
	ldrh r0, [r4, r0]
	strh r0, [r7, #8]
	ldrb r0, [r2]
	lsl r0, r0, #0x1a
	lsr r0, r0, #0x1f
	strb r0, [r3, #0x14]
	ldrb r0, [r2]
	lsl r0, r0, #0x1b
	lsr r0, r0, #0x1b
	strb r0, [r3, #0x18]
	ldr r0, _02262890 ; =0x00002DB0
	ldr r1, [r4, r0]
	mov r0, #2
	lsl r0, r0, #0x14
	tst r0, r1
	beq _02262848
	ldr r0, _02262894 ; =0x00002DFA
	ldrh r0, [r4, r0]
	strb r0, [r3, #0x10]
	ldr r0, _02262898 ; =0x00002DE4
	b _02262852
_02262848:
	ldrb r0, [r6]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	strb r0, [r3, #0x10]
	ldr r0, _0226289C ; =0x00002DA8
_02262852:
	ldr r0, [r4, r0]
	add r4, #0xc0
	str r0, [r5, #0x1c]
	mov r0, ip
	add r0, r0, #1
	add r7, r7, #2
	add r2, #0xc0
	add r3, r3, #1
	add r5, r5, #4
	add r6, #0xc0
	mov ip, r0
	cmp r0, #4
	blt _0226281A
	mov r0, #0x30
	str r0, [sp]
	ldr r0, [sp, #4]
	ldr r2, [sp, #8]
	mov r1, #1
	add r3, sp, #0xc
	bl ov12_02262240
	add sp, #0x3c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02262880: .word 0x00000195
_02262884: .word 0x00002D66
_02262888: .word 0x00002DBF
_0226288C: .word 0x0000219C
_02262890: .word 0x00002DB0
_02262894: .word 0x00002DFA
_02262898: .word 0x00002DE4
_0226289C: .word 0x00002DA8
	thumb_func_end BattleController_EmitRecallPokemon

	thumb_func_start ov12_022628A0
ov12_022628A0: ; 0x022628A0
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r1, #0
	add r4, r0, #0
	lsl r0, r7, #2
	add r0, r4, r0
	ldr r1, [r0, #0x34]
	ldr r0, _02262950 ; =0x00000195
	str r2, [sp, #4]
	ldrb r1, [r1, r0]
	mov r0, #1
	tst r0, r1
	beq _022628BE
	mov r2, #2
	b _022628C0
_022628BE:
	mov r2, #0
_022628C0:
	mov r0, #0xc0
	add r6, r7, #0
	mul r6, r0
	ldr r0, [r4, #0x30]
	ldr r5, _02262954 ; =0x00002D66
	add r0, r0, r6
	ldrb r0, [r0, r5]
	mov r1, #6
	lsl r0, r0, #0x1b
	lsr r3, r0, #0x1b
	add r0, sp, #8
	strb r1, [r0]
	ldr r0, [r4, #0x30]
	add r1, r0, r6
	add r0, r5, #0
	add r0, #0x4a
	ldr r6, [r1, r0]
	mov r0, #2
	lsl r0, r0, #0x14
	tst r0, r6
	beq _0226290E
	add r0, r5, #0
	add r0, #0x7e
	ldr r0, [r1, r0]
	lsl r2, r2, #0x18
	str r0, [sp]
	add r0, r5, #0
	sub r0, #0x26
	add r5, #0x94
	ldrh r0, [r1, r0]
	ldrh r1, [r1, r5]
	lsl r3, r3, #0x18
	lsr r2, r2, #0x18
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	lsr r3, r3, #0x18
	bl GetMonPicHeightBySpeciesGenderForm
	b _02262930
_0226290E:
	add r0, r5, #0
	add r0, #0x42
	ldr r0, [r1, r0]
	lsl r2, r2, #0x18
	str r0, [sp]
	add r0, r5, #0
	sub r0, #0x26
	add r5, #0x58
	ldrh r0, [r1, r0]
	ldrb r1, [r1, r5]
	lsl r3, r3, #0x18
	lsr r2, r2, #0x18
	lsl r1, r1, #0x1c
	lsr r1, r1, #0x1c
	lsr r3, r3, #0x18
	bl GetMonPicHeightBySpeciesGenderForm
_02262930:
	add r1, sp, #8
	strb r0, [r1, #1]
	ldr r0, [sp, #4]
	add r1, sp, #8
	strh r0, [r1, #2]
	mov r0, #4
	str r0, [sp]
	add r0, r4, #0
	mov r1, #1
	add r2, r7, #0
	add r3, sp, #8
	bl ov12_02262240
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_02262950: .word 0x00000195
_02262954: .word 0x00002D66
	thumb_func_end ov12_022628A0

	thumb_func_start BattleController_EmitDeletePokemon
BattleController_EmitDeletePokemon: ; 0x02262958
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #7
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitDeletePokemon

	thumb_func_start BattleController_EmitTrainerEncounter
BattleController_EmitTrainerEncounter: ; 0x02262974
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #8
	add r3, sp, #4
	strb r1, [r3]
	mov r1, #0x34
	mul r1, r2
	add r1, r0, r1
	add r1, #0xad
	ldrb r1, [r1]
	strh r1, [r3, #2]
	add r1, r0, r2
	add r1, #0xa8
	ldrb r1, [r1]
	strb r1, [r3, #1]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	thumb_func_end BattleController_EmitTrainerEncounter

	thumb_func_start BattleController_EmitThrowPokeball
BattleController_EmitThrowPokeball: ; 0x022629A4
	push {r4, r5, r6, lr}
	sub sp, #8
	mov r6, #9
	add r3, sp, #4
	strb r6, [r3]
	add r5, r0, #0
	strb r2, [r3, #1]
	add r4, r1, #0
	bl BattleSystem_GetBattlerIdPartner
	ldr r1, [r5, #0x30]
	add r2, r4, #0
	add r1, r1, r0
	ldr r0, _022629D8 ; =0x0000219C
	add r3, sp, #4
	ldrb r1, [r1, r0]
	add r0, sp, #4
	strh r1, [r0, #2]
	mov r0, #4
	str r0, [sp]
	add r0, r5, #0
	mov r1, #1
	bl ov12_02262240
	add sp, #8
	pop {r4, r5, r6, pc}
	.balign 4, 0
_022629D8: .word 0x0000219C
	thumb_func_end BattleController_EmitThrowPokeball

	thumb_func_start BattleController_EmitTrainerSlideOut
BattleController_EmitTrainerSlideOut: ; 0x022629DC
	push {r3, lr}
	sub sp, #8
	add r2, r1, #0
	mov r1, #0xa
	str r1, [sp, #4]
	mov r1, #4
	str r1, [sp]
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end BattleController_EmitTrainerSlideOut

	thumb_func_start BattleController_EmitTrainerSlideIn
BattleController_EmitTrainerSlideIn: ; 0x022629F8
	push {r3, r4, lr}
	sub sp, #0xc
	add r3, r1, #0
	mov r1, #0xb
	add r4, sp, #4
	strb r1, [r4]
	mov r1, #0x34
	mul r1, r3
	add r1, r0, r1
	add r1, #0xad
	ldrb r1, [r1]
	strh r1, [r4, #2]
	add r1, r0, r3
	add r1, #0xa8
	ldrb r1, [r1]
	strb r1, [r4, #1]
	str r2, [sp, #8]
	mov r1, #8
	str r1, [sp]
	add r2, r3, #0
	mov r1, #1
	add r3, sp, #4
	bl ov12_02262240
	add sp, #0xc
	pop {r3, r4, pc}
	thumb_func_end BattleController_EmitTrainerSlideIn
