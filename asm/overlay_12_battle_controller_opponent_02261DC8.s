#include "constants/pokemon.h"
#include "constants/sndseq.h"
	.include "asm/macros.inc"
	.include "overlay_12_battle_controller_opponent.inc"
	.include "global.inc"

.public ov12_02258800
.public ov12_02258BA0
.public ov12_02258EB0
.public ov12_02258EB4
.public ov12_02258EE0
.public ov12_02258EF4
.public ov12_02258F08
.public ov12_02258F1C
.public ov12_02258F30
.public ov12_02258F44
.public ov12_02258F68
.public ov12_02258F7C
.public ov12_02258F90
.public ov12_02258FA0
.public ov12_02258FB4
.public ov12_02258FC8
.public ov12_02258FD8
.public ov12_02259000
.public ov12_02259014
.public ov12_02259028
.public ov12_0225903C
.public ov12_02259050
.public ov12_02259064
.public ov12_02259078
.public ov12_0225908C
.public ov12_022590A0
.public ov12_022590D4
.public ov12_022590E8
.public ov12_022590FC
.public ov12_02259110
.public ov12_02259124
.public ov12_02259134
.public ov12_02259148
.public ov12_0225915C
.public ov12_02259170
.public ov12_02259184
.public ov12_02259198
.public ov12_022591A8
.public ov12_022591BC
.public ov12_022591CC
.public ov12_022591E0
.public ov12_022591F4
.public ov12_022592D0
.public ov12_02259328
.public ov12_02259358
.public ov12_022593D4
.public ov12_022593E8
.public ov12_022593FC
.public ov12_022594F4
.public ov12_02259514
.public ov12_022595B8
.public ov12_022595CC
.public ov12_022595E0
.public ov12_0225961C
.public ov12_02259658
.public ov12_02259694
.public ov12_022596B8
.public ov12_02259700
.public ov12_02259724
.public ov12_02259738
.public ov12_02259748
.public ov12_02259758
.public ov12_02259768
.public ov12_0225978C
.public ov12_022597B0
.public ov12_022597C4
.public ov12_022597D8
.public ov12_022597EC
.public ov12_022598F8
.public ov12_02259930
.public ov12_0225DAD4
.public ov12_0225E104
.public ov12_0225E134
.public ov12_0225E154
.public ov12_0225E1D4
.public ov12_0225E1FC
.public ov12_0225E250
.public ov12_0225E404
.public ov12_0225E4CC
.public ov12_0226D010
.public ov12_0226D120
.public ov12_0226D128
.public ov12_0226D140
.public ov12_0226D141
.public ov12_0226D15A
.public ov12_0226D1E8
.public ov12_0226D1EA
.public ov12_0225E568
.public ov12_0225E6FC
.public ov12_0225E740
.public ov12_0225E760
.public ov12_0225E830
.public ov12_0225F3A4
.public ov12_0225F3FC
.public ov12_0225F434
.public ov12_0225F4E0
.public ov12_0225F8AC

	.text

	thumb_func_start ov12_02261DC8
ov12_02261DC8: ; 0x02261DC8
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	mov r4, #0
	bl ManagedSprite_GetUserAttrForCurrentAnimFrame
	cmp r0, #1
	beq _02261DE0
	ldr r1, _02261E38 ; =0x00000FFF
	cmp r0, r1
	beq _02261E0A
	b _02261E0E
_02261DE0:
	ldrh r1, [r5, #0x16]
	lsl r0, r1, #0x1f
	lsr r0, r0, #0x1f
	bne _02261E34
	mov r0, #1
	bic r1, r0
	mov r0, #1
	orr r0, r1
	strh r0, [r5, #0x16]
	mov r0, #5
	mov r1, #8
	bl Heap_Alloc
	add r1, r0, #0
	add r2, r4, #0
	str r2, [r1]
	ldr r0, _02261E3C ; =ov12_02261E40
	str r2, [r1, #4]
	bl SysTask_CreateOnMainQueue
	b _02261E34
_02261E0A:
	mov r4, #1
	b _02261E34
_02261E0E:
	sub r1, #0xff
	add r2, r0, #0
	and r2, r1
	mov r1, #1
	lsl r1, r1, #8
	cmp r2, r1
	bne _02261E34
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	beq _02261E34
	ldr r0, [r5, #0xc]
	add r1, r4, #0
	bl ManagedSprite_SetAnimationFrame
	ldr r0, [r5, #0xc]
	sub r1, r6, #1
	bl ManagedSprite_SetAnim
	mov r4, #1
_02261E34:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
_02261E38: .word 0x00000FFF
_02261E3C: .word ov12_02261E40
	thumb_func_end ov12_02261DC8

	thumb_func_start ov12_02261E40
ov12_02261E40: ; 0x02261E40
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	ldr r0, [r4]
	cmp r0, #0
	beq _02261E56
	cmp r0, #1
	beq _02261E7E
	cmp r0, #2
	beq _02261EA0
	pop {r3, r4, r5, pc}
_02261E56:
	mov r0, #1
	bl IsBrightnessTransitionActive
	cmp r0, #0
	bne _02261E66
	mov r0, #2
	str r0, [r4]
	pop {r3, r4, r5, pc}
_02261E66:
	mov r0, #1
	str r0, [sp]
	mov r0, #4
	mov r1, #0x10
	mov r2, #0
	mov r3, #0x3d
	bl StartBrightnessTransition
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	pop {r3, r4, r5, pc}
_02261E7E:
	mov r0, #1
	bl IsBrightnessTransitionActive
	cmp r0, #1
	bne _02261EB6
	mov r0, #1
	str r0, [sp]
	mov r0, #4
	mov r1, #0
	mov r2, #0x10
	mov r3, #0x3d
	bl StartBrightnessTransition
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	pop {r3, r4, r5, pc}
_02261EA0:
	mov r0, #1
	bl IsBrightnessTransitionActive
	cmp r0, #1
	bne _02261EB6
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
_02261EB6:
	pop {r3, r4, r5, pc}
	thumb_func_end ov12_02261E40

	thumb_func_start ov12_02261EB8
ov12_02261EB8: ; 0x02261EB8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	bl ov12_0223BFFC
	add r0, r4, #0
	bl BattleSystem_GetBattleContext
	add r1, r0, #0
	add r0, r4, #0
	bl BattleController_TryEmitExitRecording
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov12_02261EB8

	thumb_func_start ov12_02261ED4
ov12_02261ED4: ; 0x02261ED4
	push {r4, lr}
	add r4, r0, #0
	mov r1, #2
	bl ov12_0223BFFC
	add r0, r4, #0
	bl BattleSystem_GetBattleContext
	add r1, r0, #0
	add r0, r4, #0
	bl BattleController_TryEmitExitRecording
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov12_02261ED4

	thumb_func_start ov12_02261EF0
ov12_02261EF0: ; 0x02261EF0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r6, r1, #0
	add r4, r2, #0
	bl BattleSystem_GetBattleType
	mov r1, #4
	tst r0, r1
	beq _02261F0A
	cmp r4, #0
	beq _02261F0E
	cmp r4, #1
	beq _02261F0E
_02261F0A:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
_02261F0E:
	add r0, r5, #0
	add r1, r6, #0
	bl BattleSystem_GetPlayerProfile
	bl PlayerProfile_GetVersion
	cmp r0, #0
	beq _02261F24
	cmp r0, #0xc
	beq _02261F2C
	b _02261F32
_02261F24:
	add r4, #0x7d
	lsl r0, r4, #0x18
	lsr r4, r0, #0x18
	b _02261F32
_02261F2C:
	add r4, #0x7f
	lsl r0, r4, #0x18
	lsr r4, r0, #0x18
_02261F32:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov12_02261EF0

	thumb_func_start ov12_02261F38
ov12_02261F38: ; 0x02261F38
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r1, #0
	add r4, r2, #0
	mov r2, #0
	add r1, sp, #0x14
	add r7, r0, #0
	add r6, r3, #0
	strb r2, [r1]
	bl BattleSystem_AreBattleAnimationsOn
	cmp r0, #1
	bne _02261F8C
	add r0, r6, #0
	mov r1, #1
	bl Pokepic_StartAnim
	add r0, r7, #0
	bl ov12_0223B750
	add r1, r0, #0
	ldr r0, [sp, #0x3c]
	ldr r3, [sp, #0x34]
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	lsl r3, r3, #0x10
	ldr r0, [sp, #0x30]
	add r2, r6, #0
	lsr r3, r3, #0x10
	str r5, [sp, #8]
	bl sub_0207294C
	ldr r2, [sp, #0x34]
	lsl r3, r4, #0x10
	lsl r2, r2, #0x10
	ldr r0, [sp, #0x30]
	add r1, sp, #0x14
	lsr r2, r2, #0x10
	lsr r3, r3, #0x10
	bl sub_020729A4
_02261F8C:
	ldr r0, [sp, #0x3c]
	cmp r0, #2
	bne _02261F96
	mov r4, #0x75
	b _02261F9A
_02261F96:
	mov r4, #0x74
	mvn r4, r4
_02261F9A:
	add r0, sp, #0x14
	ldrb r1, [r0]
	cmp r1, #0
	bne _02261FA6
	mov r1, #8
	strb r1, [r0]
_02261FA6:
	add r0, r7, #0
	add r1, r5, #0
	bl BattleSystem_GetChatotVoice
	ldr r2, [sp, #0x34]
	str r4, [sp]
	mov r1, #0x7f
	str r1, [sp, #4]
	mov r1, #0
	str r1, [sp, #8]
	mov r1, #5
	str r1, [sp, #0xc]
	add r1, sp, #0x14
	ldrb r1, [r1]
	lsl r2, r2, #0x10
	ldr r3, [sp, #0x38]
	str r1, [sp, #0x10]
	ldr r1, [sp, #0x40]
	lsr r2, r2, #0x10
	bl sub_0207204C
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov12_02261F38
