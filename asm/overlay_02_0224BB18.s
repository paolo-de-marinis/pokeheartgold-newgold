#include "constants/abilities.h"
#include "constants/species.h"
#include "constants/sndseq.h"
#include "constants/items.h"
#include "constants/pokemon.h"
#include "constants/std_script.h"
	.include "asm/macros.inc"
	.include "overlay_02.inc"
	.include "global.inc"

.public ov02_0224F79C
.public ov02_0224F820
.public ov02_02250594
.public ov02_02250628
.public ov02_022506D4
.public ov02_02250738
.public ov02_022536E8
.public ov02_022536F0
.public ov02_02253700
.public ov02_02253710
.public ov02_02253724
.public ov02_0225373C
.public ov02_02253754
.public ov02_02253770
.public ov02_02253794
.public ov02_022537B8
.public ov02_022537DC
.public ov02_02253820
.public ov02_02253884
.public ov02_022538EC
.public ov02_022538FC
.public ov02_02253914
.public ov02_0225392C
.public ov02_02253944
.public ov02_0225395C
.public ov02_02253974
.public ov02_0225398C
.public ov02_022539A4
.public ov02_022539BC
.public ov02_022539D4
.public ov02_022539EC
.public ov02_02253A04
.public ov02_02253A1C
.public ov02_02253A34
.public ov02_02253A4C
.public ov02_02253A5C
.public ov02_02253AC0
.public ov02_02253D90
.public ov02_02253D94
.public ov02_02253D98
.public ov02_02253DD8
.public ov02_02253DDC
.public ov02_02253DE0
.public Task_FollowMonInteract
	.text

	thumb_func_start PokecenterAnimCreate
PokecenterAnimCreate: ; 0x0224BB18
	push {r4, r5, r6, lr}
	sub sp, #0x20
	add r6, r1, #0
	mov r1, #0x24
	add r2, sp, #4
	add r3, sp, #0
	add r5, r0, #0
	bl sub_02054C20
	cmp r0, #0
	beq _0224BB84
	mov r0, #4
	mov r1, #0x18
	bl Heap_AllocAtEnd
	add r4, r0, #0
	strb r6, [r4, #0xc]
	mov r0, #0
	strb r0, [r4, #0xd]
	strb r0, [r4, #0xe]
	strb r0, [r4, #0xf]
	ldr r0, [r5, #0x30]
	bl MapMatrix_GetWidth
	add r1, r0, #0
	ldr r0, [sp]
	add r2, sp, #0x14
	bl sub_02054DC8
	ldr r1, [sp, #4]
	add r0, sp, #8
	bl MapProp_GetTranslation
	add r3, sp, #8
	ldmia r3!, {r0, r1}
	add r2, r4, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r1, [r4]
	ldr r0, [sp, #0x14]
	add r2, r4, #0
	add r0, r1, r0
	str r0, [r4]
	ldr r1, [r4, #8]
	ldr r0, [sp, #0x1c]
	add r0, r1, r0
	str r0, [r4, #8]
	ldr r0, [r5, #0x10]
	ldr r1, _0224BB8C ; =PokecenterAnimRun
	bl TaskManager_Call
	add sp, #0x20
	pop {r4, r5, r6, pc}
_0224BB84:
	bl GF_AssertFail
	add sp, #0x20
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224BB8C: .word PokecenterAnimRun
	thumb_func_end PokecenterAnimCreate

	thumb_func_start PokecenterAnimRun
PokecenterAnimRun: ; 0x0224BB90
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	add r4, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r4, #0
	bl TaskManager_GetEnvironment
	add r4, r0, #0
	ldrb r1, [r4, #0xf]
	cmp r1, #5
	bls _0224BBAC
	b _0224BDCC
_0224BBAC:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224BBB8: ; jump table
	.short _0224BBC4 - _0224BBB8 - 2 ; case 0
	.short _0224BC98 - _0224BBB8 - 2 ; case 1
	.short _0224BCFA - _0224BBB8 - 2 ; case 2
	.short _0224BD42 - _0224BBB8 - 2 ; case 3
	.short _0224BD64 - _0224BBB8 - 2 ; case 4
	.short _0224BDC2 - _0224BBB8 - 2 ; case 5
_0224BBC4:
	ldr r1, [r6, #0x34]
	mov r0, #0x6b
	bl ov01_021FB90C
	add r5, r0, #0
	ldr r1, [r6, #0x34]
	mov r0, #0x25
	bl ov01_021FB90C
	add r7, r0, #0
	ldr r0, [r5]
	bl NNS_G3dGetMdlSet
	cmp r0, #0
	beq _0224BC02
	add r2, r0, #0
	add r2, #8
	beq _0224BBF6
	ldrb r1, [r0, #9]
	cmp r1, #0
	bls _0224BBF6
	ldrh r1, [r0, #0xe]
	add r1, r2, r1
	add r1, r1, #4
	b _0224BBF8
_0224BBF6:
	mov r1, #0
_0224BBF8:
	cmp r1, #0
	beq _0224BC02
	ldr r1, [r1]
	add r5, r0, r1
	b _0224BC04
_0224BC02:
	mov r5, #0
_0224BC04:
	ldr r0, [r7]
	bl NNS_G3dGetMdlSet
	cmp r0, #0
	beq _0224BC2E
	add r2, r0, #0
	add r2, #8
	beq _0224BC22
	ldrb r1, [r0, #9]
	cmp r1, #0
	bls _0224BC22
	ldrh r1, [r0, #0xe]
	add r1, r2, r1
	add r1, r1, #4
	b _0224BC24
_0224BC22:
	mov r1, #0
_0224BC24:
	cmp r1, #0
	beq _0224BC2E
	ldr r1, [r1]
	add r7, r0, r1
	b _0224BC30
_0224BC2E:
	mov r7, #0
_0224BC30:
	ldr r0, [r6, #0x34]
	bl ov01_021FB9E0
	mov r1, #0
	str r1, [sp]
	str r5, [sp, #4]
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	str r1, [sp, #0x14]
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	mov r2, #0x10
	mov r3, #0x6b
	bl MapPropOneShotAnimationManager_LoadPropAnimations
	add r0, r6, #0
	mov r1, #0x25
	add r2, sp, #0x18
	mov r3, #0
	bl sub_02054C20
	cmp r0, #0
	bne _0224BC66
	bl GF_AssertFail
_0224BC66:
	ldr r0, [sp, #0x18]
	bl MapProp_GetRenderSurface
	add r5, r0, #0
	ldr r0, [r6, #0x34]
	bl ov01_021FB9E0
	str r5, [sp]
	str r7, [sp, #4]
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0x14]
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	mov r2, #0x20
	mov r3, #0x25
	bl MapPropOneShotAnimationManager_LoadPropAnimations
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224BDCC
_0224BC98:
	add r1, sp, #0x1c
	mov r0, #0
	str r0, [r1]
	str r0, [r1, #4]
	str r0, [r1, #8]
	ldrb r2, [r4, #0xd]
	mov r1, #0xc
	ldr r0, [r4]
	add r3, r2, #0
	ldr r2, _0224BDD4 ; =ov02_02253D90
	mul r3, r1
	ldr r2, [r2, r3]
	add r0, r0, r2
	str r0, [sp, #0x28]
	ldrb r2, [r4, #0xd]
	ldr r0, [r4, #4]
	add r3, r2, #0
	ldr r2, _0224BDD8 ; =ov02_02253D94
	mul r3, r1
	ldr r2, [r2, r3]
	add r0, r0, r2
	str r0, [sp, #0x2c]
	ldrb r2, [r4, #0xd]
	ldr r0, [r4, #8]
	add r3, r2, #0
	mul r3, r1
	ldr r1, _0224BDDC ; =ov02_02253D98
	ldr r1, [r1, r3]
	add r0, r0, r1
	str r0, [sp, #0x30]
	ldr r0, _0224BDE0 ; =SEQ_SE_DP_BOWA
	bl PlaySE
	ldr r0, [r6, #0x54]
	add r6, #0x9c
	str r0, [sp]
	ldr r0, [r6]
	mov r1, #0x6b
	add r2, sp, #0x28
	add r3, sp, #0x1c
	bl MapPropManager_LoadOne
	ldrb r1, [r4, #0xd]
	add r1, r4, r1
	strb r0, [r1, #0x10]
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224BDCC
_0224BCFA:
	ldrb r0, [r4, #0xe]
	cmp r0, #0xc
	bhs _0224BD06
	add r0, r0, #1
	strb r0, [r4, #0xe]
	b _0224BDCC
_0224BD06:
	mov r0, #0
	strb r0, [r4, #0xe]
	ldrb r0, [r4, #0xd]
	add r0, r0, #1
	strb r0, [r4, #0xd]
	ldrb r1, [r4, #0xd]
	ldrb r0, [r4, #0xc]
	cmp r1, r0
	bhs _0224BD1E
	mov r0, #1
	strb r0, [r4, #0xf]
	b _0224BDCC
_0224BD1E:
	add r0, r6, #0
	add r0, #0x9c
	ldrb r1, [r4, #0x10]
	ldr r0, [r0]
	bl MapPropManager_GetMapPropByIndex_Checked_RequireActive
	bl MapProp_GetRenderSurface
	add r3, r0, #0
	ldr r0, [r6, #0x58]
	mov r1, #0x10
	mov r2, #0
	bl MapPropOneShotAnimationManager_SetAnimationRenderObj
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224BDCC
_0224BD42:
	ldr r0, [r6, #0x58]
	mov r1, #0x10
	mov r2, #0
	bl MapPropOneShotAnimationManager_PlayAnimation
	ldr r0, [r6, #0x58]
	mov r1, #0x20
	mov r2, #0
	bl MapPropOneShotAnimationManager_PlayAnimation
	ldr r0, _0224BDE4 ; =SEQ_ME_ASA
	bl PlayFanfare
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224BDCC
_0224BD64:
	ldr r0, [r6, #0x58]
	mov r1, #0x10
	bl MapPropOneShotAnimationManager_IsAnimationLoopFinished
	cmp r0, #0
	beq _0224BDCC
	ldr r0, [r6, #0x58]
	mov r1, #0x20
	bl MapPropOneShotAnimationManager_IsAnimationLoopFinished
	cmp r0, #0
	beq _0224BDCC
	bl IsFanfarePlaying
	cmp r0, #0
	bne _0224BDCC
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	mov r2, #0x20
	bl MapPropOneShotAnimationManager_UnloadAnimation
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	mov r2, #0x10
	bl MapPropOneShotAnimationManager_UnloadAnimation
	ldrb r0, [r4, #0xc]
	mov r5, #0
	cmp r0, #0
	bls _0224BDBA
_0224BDA0:
	add r0, r4, r5
	add r1, r6, #0
	add r1, #0x9c
	ldrb r0, [r0, #0x10]
	ldr r1, [r1]
	bl MapPropManager_RemoveMapPropByIndex
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldrb r0, [r4, #0xc]
	cmp r5, r0
	blo _0224BDA0
_0224BDBA:
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224BDCC
_0224BDC2:
	bl Heap_Free
	add sp, #0x34
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_0224BDCC:
	mov r0, #0
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_0224BDD4: .word ov02_02253D90
_0224BDD8: .word ov02_02253D94
_0224BDDC: .word ov02_02253D98
_0224BDE0: .word SEQ_SE_DP_BOWA
_0224BDE4: .word SEQ_ME_ASA
	thumb_func_end PokecenterAnimRun

	thumb_func_start ov02_0224BDE8
ov02_0224BDE8: ; 0x0224BDE8
	push {r4, r5, r6, lr}
	add r6, r2, #0
	mov r2, #0
	add r4, r1, #0
	mov r1, #0xd0
	add r3, r2, #0
	add r5, r0, #0
	bl sub_02054C20
	cmp r0, #0
	beq _0224BE1A
	mov r0, #4
	add r1, r0, #0
	bl Heap_AllocAtEnd
	add r2, r0, #0
	strb r6, [r2]
	strb r4, [r2, #1]
	mov r0, #0
	strb r0, [r2, #2]
	ldr r0, [r5, #0x10]
	ldr r1, _0224BE20 ; =ov02_0224BE24
	bl TaskManager_Call
	pop {r4, r5, r6, pc}
_0224BE1A:
	bl GF_AssertFail
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224BE20: .word ov02_0224BE24
	thumb_func_end ov02_0224BDE8

	thumb_func_start ov02_0224BE24
ov02_0224BE24: ; 0x0224BE24
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r4, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r4, #0
	bl TaskManager_GetEnvironment
	add r4, r0, #0
	ldrb r1, [r4, #2]
	cmp r1, #4
	bls _0224BE40
	b _0224BF48
_0224BE40:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224BE4C: ; jump table
	.short _0224BE56 - _0224BE4C - 2 ; case 0
	.short _0224BED2 - _0224BE4C - 2 ; case 1
	.short _0224BF00 - _0224BE4C - 2 ; case 2
	.short _0224BF2C - _0224BE4C - 2 ; case 3
	.short _0224BF3E - _0224BE4C - 2 ; case 4
_0224BE56:
	ldr r1, [r6, #0x34]
	mov r0, #0xd0
	bl ov01_021FB90C
	ldr r0, [r0]
	bl NNS_G3dGetMdlSet
	cmp r0, #0
	beq _0224BE88
	add r2, r0, #0
	add r2, #8
	beq _0224BE7C
	ldrb r1, [r0, #9]
	cmp r1, #0
	bls _0224BE7C
	ldrh r1, [r0, #0xe]
	add r1, r2, r1
	add r1, r1, #4
	b _0224BE7E
_0224BE7C:
	mov r1, #0
_0224BE7E:
	cmp r1, #0
	beq _0224BE88
	ldr r1, [r1]
	add r7, r0, r1
	b _0224BE8A
_0224BE88:
	mov r7, #0
_0224BE8A:
	add r0, r6, #0
	mov r1, #0xd0
	add r2, sp, #0x18
	mov r3, #0
	bl sub_02054C20
	cmp r0, #0
	bne _0224BE9E
	bl GF_AssertFail
_0224BE9E:
	ldr r0, [sp, #0x18]
	bl MapProp_GetRenderSurface
	add r5, r0, #0
	ldr r0, [r6, #0x34]
	bl ov01_021FB9E0
	str r5, [sp]
	str r7, [sp, #4]
	str r0, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	ldrb r0, [r4]
	mov r2, #1
	mov r3, #0xd0
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0x14]
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	bl MapPropOneShotAnimationManager_LoadPropAnimations
	ldrb r0, [r4, #2]
	add r0, r0, #1
	strb r0, [r4, #2]
	b _0224BF48
_0224BED2:
	ldrb r0, [r4, #1]
	mov r1, #1
	cmp r0, #0
	beq _0224BEE0
	cmp r0, #1
	beq _0224BEE0
	mov r1, #0
_0224BEE0:
	cmp r1, #0
	bne _0224BEE8
	bl GF_AssertFail
_0224BEE8:
	ldrb r2, [r4, #1]
	ldr r0, [r6, #0x58]
	mov r1, #1
	bl MapPropOneShotAnimationManager_PlayAnimation
	ldr r0, _0224BF50 ; =SEQ_SE_DP_ELEBETA2
	bl PlaySE
	ldrb r0, [r4, #2]
	add r0, r0, #1
	strb r0, [r4, #2]
	b _0224BF48
_0224BF00:
	ldr r0, [r6, #0x58]
	mov r1, #1
	bl MapPropOneShotAnimationManager_IsAnimationLoopFinished
	cmp r0, #0
	beq _0224BF48
	ldr r0, _0224BF50 ; =SEQ_SE_DP_ELEBETA2
	mov r1, #0
	bl StopSE
	ldr r0, _0224BF54 ; =SEQ_SE_DP_PINPON
	bl PlaySE
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	mov r2, #1
	bl MapPropOneShotAnimationManager_UnloadAnimation
	ldrb r0, [r4, #2]
	add r0, r0, #1
	strb r0, [r4, #2]
	b _0224BF48
_0224BF2C:
	ldr r0, _0224BF54 ; =SEQ_SE_DP_PINPON
	bl IsSEPlaying
	cmp r0, #0
	bne _0224BF48
	ldrb r0, [r4, #2]
	add r0, r0, #1
	strb r0, [r4, #2]
	b _0224BF48
_0224BF3E:
	bl Heap_Free
	add sp, #0x1c
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_0224BF48:
	mov r0, #0
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	nop
_0224BF50: .word SEQ_SE_DP_ELEBETA2
_0224BF54: .word SEQ_SE_DP_PINPON
	thumb_func_end ov02_0224BE24

	thumb_func_start ov02_0224BF58
ov02_0224BF58: ; 0x0224BF58
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	ldr r2, _0224BFBC ; =ov02_022536E8
	add r7, r1, #0
	ldr r3, [r2]
	ldr r2, [r2, #4]
	str r3, [sp, #0x18]
	str r2, [sp, #0x1c]
	add r2, sp, #0x20
	str r2, [sp]
	add r1, sp, #0x18
	mov r2, #2
	add r3, sp, #0x24
	add r5, r0, #0
	bl sub_02054C90
	cmp r0, #0
	beq _0224BFB4
	ldr r0, [r5, #0x34]
	bl ov01_021FB9E0
	add r6, r0, #0
	ldr r0, [sp, #0x24]
	bl MapProp_GetRenderSurface
	add r4, r0, #0
	ldr r0, [sp, #0x24]
	bl MapProp_GetResModel
	str r4, [sp]
	str r0, [sp, #4]
	str r6, [sp, #8]
	mov r0, #2
	str r0, [sp, #0xc]
	mov r0, #1
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0x14]
	ldr r0, [r5, #0x54]
	ldr r1, [r5, #0x58]
	ldr r3, [sp, #0x20]
	add r2, r7, #0
	bl MapPropOneShotAnimationManager_LoadPropAnimations
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
_0224BFB4:
	bl GF_AssertFail
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224BFBC: .word ov02_022536E8
	thumb_func_end ov02_0224BF58

	thumb_func_start ov02_0224BFC0
ov02_0224BFC0: ; 0x0224BFC0
	ldr r3, _0224BFC8 ; =MapPropOneShotAnimationManager_PlayAnimation
	ldr r0, [r0, #0x58]
	mov r2, #0
	bx r3
	.balign 4, 0
_0224BFC8: .word MapPropOneShotAnimationManager_PlayAnimation
	thumb_func_end ov02_0224BFC0

	thumb_func_start ov02_0224BFCC
ov02_0224BFCC: ; 0x0224BFCC
	ldr r3, _0224BFD4 ; =MapPropOneShotAnimationManager_PlayAnimation
	ldr r0, [r0, #0x58]
	mov r2, #1
	bx r3
	.balign 4, 0
_0224BFD4: .word MapPropOneShotAnimationManager_PlayAnimation
	thumb_func_end ov02_0224BFCC

	thumb_func_start CreateFieldEscapeRopeTaskEnv
CreateFieldEscapeRopeTaskEnv: ; 0x0224BFD8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #0x30
	bl ov02_0224C660
	add r4, r0, #0
	mov r0, #0
	str r0, [r4, #0xc]
	str r5, [r4, #0x24]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetMapObject
	str r0, [r4, #0x20]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetState
	sub r0, r0, #1
	cmp r0, #1
	bhi _0224C006
	mov r0, #0
	str r0, [r4, #8]
	b _0224C01A
_0224C006:
	add r0, r5, #0
	bl FollowMon_IsActive
	cmp r0, #0
	beq _0224C016
	mov r0, #1
	str r0, [r4, #8]
	b _0224C01A
_0224C016:
	mov r0, #0
	str r0, [r4, #8]
_0224C01A:
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end CreateFieldEscapeRopeTaskEnv

	thumb_func_start Task_FieldEscapeRope
Task_FieldEscapeRope: ; 0x0224C020
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	bl TaskManager_GetFieldSystem
	add r7, r0, #0
	add r0, r6, #0
	bl TaskManager_GetEnvironment
	add r5, r0, #0
_0224C032:
	ldr r3, [r5]
	add r0, r6, #0
	lsl r4, r3, #2
	ldr r3, _0224C058 ; =ov02_02253700
	add r1, r7, #0
	ldr r3, [r3, r4]
	add r2, r5, #0
	blx r3
	add r4, r0, #0
	cmp r4, #2
	bne _0224C04E
	add r0, r5, #0
	bl Heap_Free
_0224C04E:
	cmp r4, #1
	beq _0224C032
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224C058: .word ov02_02253700
	thumb_func_end Task_FieldEscapeRope

	thumb_func_start ov02_0224C05C
ov02_0224C05C: ; 0x0224C05C
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #4
	add r4, r2, #0
	bl ov01_021FCD2C
	ldr r2, _0224C0A4 ; =0xFFF6A000
	str r0, [r4, #0x1c]
	mov r1, #1
	mov r3, #0xf
	bl ov01_021FCD8C
	ldr r0, [r4, #0x20]
	ldr r1, _0224C0A8 ; =ov02_02253820
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C092
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C0A8 ; =ov02_02253820
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C092:
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	ldr r0, _0224C0AC ; =SEQ_SE_DP_KAIDAN2
	bl PlaySE
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0224C0A4: .word 0xFFF6A000
_0224C0A8: .word ov02_02253820
_0224C0AC: .word SEQ_SE_DP_KAIDAN2
	thumb_func_end ov02_0224C05C

	thumb_func_start ov02_0224C0B0
ov02_0224C0B0: ; 0x0224C0B0
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #0
	bne _0224C0C8
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_0224C0C8:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C144 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C0F0
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C144 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C0F0:
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
	cmp r0, #8
	bge _0224C100
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_0224C100:
	ldr r0, [r4, #0xc]
	cmp r0, #2
	bne _0224C120
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	b _0224C138
_0224C120:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0
	ldr r3, _0224C148 ; =0x00007FFF
	add r1, r0, #0
	add r2, r0, #0
	bl BeginNormalPaletteFade
_0224C138:
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0224C144: .word ov02_02253794
_0224C148: .word 0x00007FFF
	thumb_func_end ov02_0224C0B0

	thumb_func_start ov02_0224C14C
ov02_0224C14C: ; 0x0224C14C
	push {r3, r4, r5, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #1
	bne _0224C184
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C1B4 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C184
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C1B4 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C184:
	bl IsPaletteFadeFinished
	cmp r0, #0
	bne _0224C190
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224C190:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C1A2
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
_0224C1A2:
	ldr r0, [r4, #0x1c]
	bl ov01_021FCD78
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_0224C1B4: .word ov02_02253794
	thumb_func_end ov02_0224C14C

	thumb_func_start ov02_0224C1B8
ov02_0224C1B8: ; 0x0224C1B8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r1, #0xc]
	add r4, r2, #0
	bl Save_LocalFieldData_Get
	bl LocalFieldData_GetSpecialSpawnWarpPtr
	add r1, r0, #0
	ldr r2, [r4, #0xc]
	add r0, r5, #0
	bl sub_02053B04
	mov r0, #2
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224C1B8

	thumb_func_start ov02_0224C1D8
ov02_0224C1D8: ; 0x0224C1D8
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #0x30
	add r6, r2, #0
	bl ov02_0224C660
	add r4, r0, #0
	str r6, [r4, #0xc]
	str r5, [r4, #0x24]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetMapObject
	str r0, [r4, #0x20]
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_0224C1D8

	thumb_func_start ov02_0224C1F8
ov02_0224C1F8: ; 0x0224C1F8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r5, #0
	bl TaskManager_GetEnvironment
	ldr r7, _0224C230 ; =ov02_022536F0
	add r4, r0, #0
_0224C20C:
	ldr r3, [r4]
	add r0, r5, #0
	lsl r3, r3, #2
	ldr r3, [r7, r3]
	add r1, r6, #0
	add r2, r4, #0
	blx r3
	cmp r0, #2
	bne _0224C228
	add r0, r4, #0
	bl Heap_Free
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0224C228:
	cmp r0, #1
	beq _0224C20C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224C230: .word ov02_022536F0
	thumb_func_end ov02_0224C1F8

	thumb_func_start ov02_0224C234
ov02_0224C234: ; 0x0224C234
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r2, #0
	ldr r0, [r4, #0xc]
	add r5, r1, #0
	cmp r0, #2
	bne _0224C25A
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	b _0224C270
_0224C25A:
	mov r0, #6
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	ldr r3, _0224C29C ; =0x00007FFF
	mov r0, #0
	add r2, r1, #0
	bl BeginNormalPaletteFade
_0224C270:
	add r0, r5, #0
	mov r1, #4
	bl ov01_021FCD2C
	mov r1, #1
	ldr r2, _0224C2A0 ; =0xFFF6A000
	str r0, [r4, #0x1c]
	add r3, r1, #0
	bl ov01_021FCD8C
	ldr r0, [r4, #0x20]
	ldr r1, _0224C2A4 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	nop
_0224C29C: .word 0x00007FFF
_0224C2A0: .word 0xFFF6A000
_0224C2A4: .word ov02_02253794
	thumb_func_end ov02_0224C234

	thumb_func_start ov02_0224C2A8
ov02_0224C2A8: ; 0x0224C2A8
	push {r4, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_IsFinish
	cmp r0, #1
	bne _0224C2C6
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C2E8 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
_0224C2C6:
	bl IsPaletteFadeFinished
	cmp r0, #0
	bne _0224C2D2
	mov r0, #0
	pop {r4, pc}
_0224C2D2:
	ldr r0, [r4, #0x1c]
	mov r1, #2
	mov r2, #0
	mov r3, #0x3c
	bl ov01_021FCD8C
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
_0224C2E8: .word ov02_02253794
	thumb_func_end ov02_0224C2A8

	thumb_func_start ov02_0224C2EC
ov02_0224C2EC: ; 0x0224C2EC
	push {r4, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_IsFinish
	cmp r0, #0
	bne _0224C2FE
	mov r0, #0
	pop {r4, pc}
_0224C2FE:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
	cmp r0, #4
	ldr r0, [r4, #0x20]
	bge _0224C31C
	ldr r1, _0224C330 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	mov r0, #0
	pop {r4, pc}
_0224C31C:
	ldr r1, _0224C334 ; =ov02_02253884
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	nop
_0224C330: .word ov02_02253794
_0224C334: .word ov02_02253884
	thumb_func_end ov02_0224C2EC

	thumb_func_start ov02_0224C338
ov02_0224C338: ; 0x0224C338
	push {r4, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_IsFinish
	cmp r0, #0
	bne _0224C34A
	mov r0, #0
	pop {r4, pc}
_0224C34A:
	ldr r0, [r4, #0x1c]
	bl ov01_021FCD6C
	cmp r0, #0
	bne _0224C358
	mov r0, #0
	pop {r4, pc}
_0224C358:
	ldr r0, [r4, #0x1c]
	bl ov01_021FCD78
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	mov r0, #2
	pop {r4, pc}
	thumb_func_end ov02_0224C338

	thumb_func_start FieldMoveTask_CreateDigEnvironment
FieldMoveTask_CreateDigEnvironment: ; 0x0224C368
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	add r0, r3, #0
	mov r1, #0x30
	add r7, r2, #0
	bl ov02_0224C660
	add r4, r0, #0
	mov r0, #1
	str r0, [r4, #0xc]
	str r5, [r4, #0x24]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetMapObject
	str r0, [r4, #0x20]
	add r0, r5, #0
	str r6, [r4, #0x28]
	bl ov01_02206268
	cmp r0, #0
	beq _0224C3A4
	add r0, r5, #0
	bl ov01_022062CC
	cmp r7, r0
	bne _0224C3A4
	mov r0, #1
	str r0, [r4, #8]
	b _0224C3A8
_0224C3A4:
	mov r0, #0
	str r0, [r4, #8]
_0224C3A8:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end FieldMoveTask_CreateDigEnvironment

	thumb_func_start Task_FieldDig
Task_FieldDig: ; 0x0224C3AC
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r7, #0
	bl TaskManager_GetEnvironment
	add r4, r0, #0
	add r0, r7, #0
	bl TaskManager_GetStatePtr
	add r5, r0, #0
	ldr r0, [r5]
	cmp r0, #3
	bhi _0224C4A2
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224C3D8: ; jump table
	.short _0224C3E0 - _0224C3D8 - 2 ; case 0
	.short _0224C3F8 - _0224C3D8 - 2 ; case 1
	.short _0224C42A - _0224C3D8 - 2 ; case 2
	.short _0224C45C - _0224C3D8 - 2 ; case 3
_0224C3E0:
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C3F0
	ldr r1, _0224C4A8 ; =ov01_02205A60
	add r0, r7, #0
	mov r2, #0
	bl TaskManager_Call
_0224C3F0:
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	b _0224C4A2
_0224C3F8:
	add r0, r0, #1
	str r0, [r5]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C42A
	add r0, r6, #0
	mov r1, #4
	bl ov02_02250780
	cmp r0, #0
	beq _0224C41E
	mov r0, #0x42
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r1, #1
	mov r4, #2
	bl FieldSystem_UnkSub108_AddMonMood
	b _0224C420
_0224C41E:
	mov r4, #1
_0224C420:
	add r0, r6, #0
	add r1, r4, #0
	bl ov02_022507B4
	b _0224C4A2
_0224C42A:
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C456
	ldr r0, [r4, #0x28]
	mov r1, #5
	mov r2, #0
	bl GetMonData
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r1, r0, #0
	ldr r0, [sp]
	lsl r1, r1, #0x18
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	lsr r1, r1, #0x18
	bl PlayCry
_0224C456:
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_0224C45C:
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C482
	bl IsCryFinished
	cmp r0, #0
	beq _0224C46E
	mov r5, #0
	b _0224C494
_0224C46E:
	ldr r3, [r4]
	add r0, r7, #0
	lsl r5, r3, #2
	ldr r3, _0224C4AC ; =ov02_02253710
	add r1, r6, #0
	ldr r3, [r3, r5]
	add r2, r4, #0
	blx r3
	add r5, r0, #0
	b _0224C494
_0224C482:
	ldr r3, [r4]
	add r0, r7, #0
	lsl r5, r3, #2
	ldr r3, _0224C4B0 ; =ov02_02253754
	add r1, r6, #0
	ldr r3, [r3, r5]
	add r2, r4, #0
	blx r3
	add r5, r0, #0
_0224C494:
	cmp r5, #2
	bne _0224C49E
	add r0, r4, #0
	bl Heap_Free
_0224C49E:
	cmp r5, #1
	beq _0224C45C
_0224C4A2:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224C4A8: .word ov01_02205A60
_0224C4AC: .word ov02_02253710
_0224C4B0: .word ov02_02253754
	thumb_func_end Task_FieldDig

	thumb_func_start ov02_0224C4B4
ov02_0224C4B4: ; 0x0224C4B4
	push {r3, r4, r5, lr}
	add r5, r1, #0
	ldr r0, [r5, #0x40]
	add r4, r2, #0
	bl PlayerAvatar_GetGender
	add r3, r0, #0
	ldr r2, [r4, #0x28]
	add r0, r5, #0
	mov r1, #0
	bl ov02_02249458
	str r0, [r4, #0x18]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224C4B4

	thumb_func_start ov02_0224C4D8
ov02_0224C4D8: ; 0x0224C4D8
	push {r4, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x18]
	bl ov02_0224953C
	cmp r0, #0
	bne _0224C4EA
	mov r0, #0
	pop {r4, pc}
_0224C4EA:
	ldr r0, [r4, #0x18]
	bl ov02_02249548
	ldr r0, [r4, #0x24]
	bl ov01_02205D68
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov02_0224C4D8

	thumb_func_start FieldMoveTask_CreateTeleportEnvironment
FieldMoveTask_CreateTeleportEnvironment: ; 0x0224C500
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r6, r1, #0
	add r0, r3, #0
	mov r1, #0x30
	add r7, r2, #0
	bl ov02_0224C660
	add r4, r0, #0
	mov r0, #2
	str r0, [r4, #0xc]
	str r5, [r4, #0x24]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetMapObject
	str r0, [r4, #0x20]
	str r6, [r4, #0x28]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetState
	sub r0, r0, #1
	cmp r0, #1
	bhi _0224C534
	mov r0, #0
	str r0, [r4, #8]
	b _0224C552
_0224C534:
	add r0, r5, #0
	bl ov01_02206268
	cmp r0, #0
	beq _0224C54E
	add r0, r5, #0
	bl ov01_022062CC
	cmp r7, r0
	bne _0224C54E
	mov r0, #1
	str r0, [r4, #8]
	b _0224C552
_0224C54E:
	mov r0, #0
	str r0, [r4, #8]
_0224C552:
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end FieldMoveTask_CreateTeleportEnvironment

	thumb_func_start Task_FieldTeleport
Task_FieldTeleport: ; 0x0224C558
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r7, #0
	bl TaskManager_GetEnvironment
	add r4, r0, #0
	add r0, r7, #0
	bl TaskManager_GetStatePtr
	add r5, r0, #0
	ldr r0, [r5]
	cmp r0, #3
	bhi _0224C64E
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224C584: ; jump table
	.short _0224C58C - _0224C584 - 2 ; case 0
	.short _0224C5A4 - _0224C584 - 2 ; case 1
	.short _0224C5D6 - _0224C584 - 2 ; case 2
	.short _0224C608 - _0224C584 - 2 ; case 3
_0224C58C:
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C59C
	ldr r1, _0224C654 ; =ov01_02205A60
	add r0, r7, #0
	mov r2, #0
	bl TaskManager_Call
_0224C59C:
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
	b _0224C64E
_0224C5A4:
	add r0, r0, #1
	str r0, [r5]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C5D6
	add r0, r6, #0
	mov r1, #0xe
	bl ov02_02250780
	cmp r0, #0
	beq _0224C5CA
	mov r0, #0x42
	lsl r0, r0, #2
	ldr r0, [r6, r0]
	mov r1, #1
	mov r4, #2
	bl FieldSystem_UnkSub108_AddMonMood
	b _0224C5CC
_0224C5CA:
	mov r4, #1
_0224C5CC:
	add r0, r6, #0
	add r1, r4, #0
	bl ov02_022507B4
	b _0224C64E
_0224C5D6:
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C602
	ldr r0, [r4, #0x28]
	mov r1, #5
	mov r2, #0
	bl GetMonData
	str r0, [sp]
	ldr r0, [r4, #0x28]
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r1, r0, #0
	ldr r0, [sp]
	lsl r1, r1, #0x18
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	lsr r1, r1, #0x18
	bl PlayCry
_0224C602:
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_0224C608:
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C62E
	bl IsCryFinished
	cmp r0, #0
	beq _0224C61A
	mov r5, #0
	b _0224C640
_0224C61A:
	ldr r3, [r4]
	add r0, r7, #0
	lsl r5, r3, #2
	ldr r3, _0224C658 ; =ov02_0225373C
	add r1, r6, #0
	ldr r3, [r3, r5]
	add r2, r4, #0
	blx r3
	add r5, r0, #0
	b _0224C640
_0224C62E:
	ldr r3, [r4]
	add r0, r7, #0
	lsl r5, r3, #2
	ldr r3, _0224C65C ; =ov02_02253724
	add r1, r6, #0
	ldr r3, [r3, r5]
	add r2, r4, #0
	blx r3
	add r5, r0, #0
_0224C640:
	cmp r5, #2
	bne _0224C64A
	add r0, r4, #0
	bl Heap_Free
_0224C64A:
	cmp r5, #1
	beq _0224C608
_0224C64E:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224C654: .word ov01_02205A60
_0224C658: .word ov02_0225373C
_0224C65C: .word ov02_02253724
	thumb_func_end Task_FieldTeleport

	thumb_func_start ov02_0224C660
ov02_0224C660: ; 0x0224C660
	push {r3, r4, r5, lr}
	add r5, r1, #0
	bl Heap_AllocAtEnd
	add r4, r0, #0
	bne _0224C670
	bl GF_AssertFail
_0224C670:
	add r0, r4, #0
	mov r1, #0
	add r2, r5, #0
	bl memset
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224C660

	thumb_func_start ov02_0224C680
ov02_0224C680: ; 0x0224C680
	push {r4, lr}
	add r4, r2, #0
	add r0, r1, #0
	mov r1, #2
	mov r2, #1
	bl ov01_022060B8
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov02_0224C680

	thumb_func_start ov02_0224C698
ov02_0224C698: ; 0x0224C698
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #4
	add r4, r2, #0
	bl ov01_021FCD2C
	ldr r2, _0224C6D0 ; =0xFFF6A000
	mov r1, #1
	mov r3, #0xf
	str r0, [r4, #0x1c]
	bl ov01_021FCD8C
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C6D4 ; =ov02_02253770
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	ldr r0, _0224C6D8 ; =SEQ_SE_DP_TELE
	bl PlaySE
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0224C6D0: .word 0xFFF6A000
_0224C6D4: .word ov02_02253770
_0224C6D8: .word SEQ_SE_DP_TELE
	thumb_func_end ov02_0224C698

	thumb_func_start ov02_0224C6DC
ov02_0224C6DC: ; 0x0224C6DC
	push {r3, r4, r5, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x14]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #0
	bne _0224C6F0
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224C6F0:
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C718 ; =ov02_02253820
	bl EventObjectMovementMan_Create
	add r5, #0xe4
	str r0, [r4, #0x10]
	ldr r0, [r5]
	ldr r1, _0224C718 ; =ov02_02253820
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0224C718: .word ov02_02253820
	thumb_func_end ov02_0224C6DC

	thumb_func_start ov02_0224C71C
ov02_0224C71C: ; 0x0224C71C
	push {r4, lr}
	add r0, r1, #0
	mov r1, #4
	add r4, r2, #0
	bl ov01_021FCD2C
	ldr r2, _0224C750 ; =0xFFF6A000
	str r0, [r4, #0x1c]
	mov r1, #1
	mov r3, #0xf
	bl ov01_021FCD8C
	ldr r0, [r4, #0x20]
	ldr r1, _0224C754 ; =ov02_02253820
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	ldr r0, _0224C758 ; =SEQ_SE_DP_TELE
	bl PlaySE
	mov r0, #0
	pop {r4, pc}
	nop
_0224C750: .word 0xFFF6A000
_0224C754: .word ov02_02253820
_0224C758: .word SEQ_SE_DP_TELE
	thumb_func_end ov02_0224C71C

	thumb_func_start ov02_0224C75C
ov02_0224C75C: ; 0x0224C75C
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #0
	bne _0224C774
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_0224C774:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C7D0 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C79C
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C7D0 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C79C:
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
	cmp r0, #8
	bge _0224C7AC
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_0224C7AC:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0224C7D0: .word ov02_02253794
	thumb_func_end ov02_0224C75C

	thumb_func_start ov02_0224C7D4
ov02_0224C7D4: ; 0x0224C7D4
	push {r3, r4, r5, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #1
	bne _0224C80C
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C83C ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C80C
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C83C ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C80C:
	bl IsPaletteFadeFinished
	cmp r0, #0
	bne _0224C818
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224C818:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C82A
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
_0224C82A:
	ldr r0, [r4, #0x1c]
	bl ov01_021FCD78
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_0224C83C: .word ov02_02253794
	thumb_func_end ov02_0224C7D4

	thumb_func_start ov02_0224C840
ov02_0224C840: ; 0x0224C840
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [r1, #0xc]
	add r4, r2, #0
	bl Save_LocalFieldData_Get
	add r6, r0, #0
	bl LocalFieldData_GetBlackoutSpawn
	add r1, sp, #0
	add r7, r0, #0
	bl GetFlyWarpData
	add r0, r6, #0
	bl LocalFieldData_GetSpecialSpawnWarpPtr
	add r1, r0, #0
	add r0, r7, #0
	bl GetSpecialSpawnWarpData
	ldr r2, [r4, #0xc]
	add r0, r5, #0
	add r1, sp, #0
	bl sub_02053B04
	mov r0, #2
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224C840

	thumb_func_start ov02_0224C87C
ov02_0224C87C: ; 0x0224C87C
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r0, r5, #0
	mov r1, #4
	add r4, r2, #0
	bl ov01_021FCD2C
	ldr r2, _0224C8C4 ; =0xFFF6A000
	str r0, [r4, #0x1c]
	mov r1, #1
	mov r3, #0xf
	bl ov01_021FCD8C
	ldr r0, [r4, #0x20]
	ldr r1, _0224C8C8 ; =ov02_022537DC
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C8B2
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C8C8 ; =ov02_022537DC
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C8B2:
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	ldr r0, _0224C8CC ; =SEQ_SE_DP_KAIDAN2
	bl PlaySE
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0224C8C4: .word 0xFFF6A000
_0224C8C8: .word ov02_022537DC
_0224C8CC: .word SEQ_SE_DP_KAIDAN2
	thumb_func_end ov02_0224C87C

	thumb_func_start ov02_0224C8D0
ov02_0224C8D0: ; 0x0224C8D0
	push {r3, r4, r5, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #0
	bne _0224C8E4
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224C8E4:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C938 ; =ov02_022537B8
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C90E
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	ldr r1, _0224C938 ; =ov02_022537B8
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C90E:
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetState
	cmp r0, #2
	beq _0224C92E
	ldr r0, [r4, #8]
	cmp r0, #0
	ldr r0, [r4, #0x24]
	beq _0224C928
	bl ov02_0224DDF4
	str r0, [r4, #0x2c]
	b _0224C92E
_0224C928:
	bl ov02_0224DDE0
	str r0, [r4, #0x2c]
_0224C92E:
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224C938: .word ov02_022537B8
	thumb_func_end ov02_0224C8D0

	thumb_func_start ov02_0224C93C
ov02_0224C93C: ; 0x0224C93C
	push {r4, r5, lr}
	sub sp, #0xc
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #0
	bne _0224C954
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_0224C954:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224C9B0 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C97C
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	add r5, #0xe4
	ldr r0, [r5]
	ldr r1, _0224C9B0 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C97C:
	ldr r0, [r4, #4]
	add r0, r0, #1
	str r0, [r4, #4]
	cmp r0, #8
	bge _0224C98C
	add sp, #0xc
	mov r0, #0
	pop {r4, r5, pc}
_0224C98C:
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0
	ldr r3, _0224C9B4 ; =0x00007FFF
	add r1, r0, #0
	add r2, r0, #0
	bl BeginNormalPaletteFade
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #0
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
_0224C9B0: .word ov02_02253794
_0224C9B4: .word 0x00007FFF
	thumb_func_end ov02_0224C93C

	thumb_func_start ov02_0224C9B8
ov02_0224C9B8: ; 0x0224C9B8
	push {r3, r4, r5, lr}
	add r4, r2, #0
	ldr r0, [r4, #0x10]
	add r5, r1, #0
	bl EventObjectMovementMan_IsFinish
	cmp r0, #1
	bne _0224C9F2
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r4, #0x20]
	ldr r1, _0224CA34 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x10]
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224C9F2
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
	add r0, r5, #0
	add r0, #0xe4
	ldr r0, [r0]
	ldr r1, _0224CA34 ; =ov02_02253794
	bl EventObjectMovementMan_Create
	str r0, [r4, #0x14]
_0224C9F2:
	bl IsPaletteFadeFinished
	cmp r0, #0
	bne _0224C9FE
	mov r0, #0
	pop {r3, r4, r5, pc}
_0224C9FE:
	ldr r0, [r4, #0x10]
	bl EventObjectMovementMan_Delete
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetState
	cmp r0, #2
	beq _0224CA18
	ldr r0, [r4, #0x2c]
	bl ov02_0224DE08
	mov r0, #0
	str r0, [r4, #0x2c]
_0224CA18:
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224CA24
	ldr r0, [r4, #0x14]
	bl EventObjectMovementMan_Delete
_0224CA24:
	ldr r0, [r4, #0x1c]
	bl ov01_021FCD78
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224CA34: .word ov02_02253794
	thumb_func_end ov02_0224C9B8

	thumb_func_start ov02_0224CA38
ov02_0224CA38: ; 0x0224CA38
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r1, #0xc]
	add r4, r2, #0
	bl Save_LocalFieldData_Get
	bl LocalFieldData_GetSpecialSpawnWarpPtr
	add r1, r0, #0
	ldr r2, [r4, #0xc]
	add r0, r5, #0
	bl sub_02053B04
	mov r0, #2
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224CA38

	thumb_func_start ov02_0224CA58
ov02_0224CA58: ; 0x0224CA58
	push {r4, r5, r6, r7}
	add r3, r0, #0
	add r0, r2, #0
	sub r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r2, #0
	beq _0224CAB4
	add r6, r3, r1
	sub r7, r1, #1
_0224CA6C:
	sub r1, r6, #1
	ldrb r2, [r1]
	mov r1, #1
	add r5, r7, #0
	and r1, r2
	lsl r1, r1, #0x18
	lsr r4, r1, #0x18
	cmp r7, #0
	ble _0224CA9A
_0224CA7E:
	ldrb r1, [r3, r5]
	add r2, r3, r5
	sub r2, r2, #1
	asr r1, r1, #1
	strb r1, [r3, r5]
	ldrb r2, [r2]
	ldrb r1, [r3, r5]
	lsl r2, r2, #0x1f
	lsr r2, r2, #0x18
	orr r1, r2
	strb r1, [r3, r5]
	sub r5, r5, #1
	cmp r5, #0
	bgt _0224CA7E
_0224CA9A:
	ldrb r1, [r3, r5]
	asr r1, r1, #1
	strb r1, [r3, r5]
	ldrb r2, [r3, r5]
	lsl r1, r4, #7
	orr r1, r2
	strb r1, [r3, r5]
	add r1, r0, #0
	sub r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	cmp r1, #0
	bne _0224CA6C
_0224CAB4:
	pop {r4, r5, r6, r7}
	bx lr
	thumb_func_end ov02_0224CA58

	thumb_func_start ov02_0224CAB8
ov02_0224CAB8: ; 0x0224CAB8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r6, r2, #0
	str r1, [sp]
	add r7, r3, #0
	bl WallpaperPasswordBank_GetCount
	add r4, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	strh r0, [r1, #4]
	add r0, r5, #0
	add r1, r7, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	strh r0, [r1, #6]
	add r1, sp, #0x18
	ldrh r1, [r1, #0x10]
	add r0, r5, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	strh r0, [r1, #8]
	add r1, sp, #0x18
	ldrh r1, [r1, #0x14]
	add r0, r5, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	mov r2, #0
	strh r0, [r1, #0xa]
	add r3, sp, #8
	add r5, sp, #4
	add r7, r2, #0
_0224CB06:
	ldrsh r0, [r3, r7]
	cmp r0, #0
	bge _0224CB14
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CB14:
	cmp r2, #0
	ble _0224CB48
	mov r6, #1
	mvn r6, r6
	ldrsh r6, [r3, r6]
	cmp r0, r6
	blt _0224CB34
	sub r0, r0, r6
	cmp r0, #0xff
	ble _0224CB30
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CB30:
	strb r0, [r5]
	b _0224CB5A
_0224CB34:
	sub r0, r6, r0
	sub r0, r4, r0
	cmp r0, #0xff
	ble _0224CB44
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CB44:
	strb r0, [r5]
	b _0224CB5A
_0224CB48:
	mov r0, #4
	ldrsh r0, [r1, r0]
	cmp r0, #0xff
	ble _0224CB58
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CB58:
	strb r0, [r1]
_0224CB5A:
	add r2, r2, #1
	add r3, r3, #2
	add r5, r5, #1
	cmp r2, #4
	blt _0224CB06
	add r0, sp, #4
	mov r1, #4
	mov r2, #5
	bl ov02_0224CA58
	mov r2, #0
	add r1, sp, #4
	add r4, sp, #4
	mov r3, #0xf0
_0224CB76:
	ldrb r5, [r4, #3]
	ldrb r0, [r1]
	add r2, r2, #1
	asr r6, r5, #4
	and r5, r3
	orr r5, r6
	eor r0, r5
	strb r0, [r1]
	add r1, r1, #1
	cmp r2, #3
	blt _0224CB76
	add r2, sp, #4
	ldrb r3, [r2, #3]
	mov r2, #0xf
	add r0, sp, #4
	and r2, r3
	lsl r2, r2, #0x18
	mov r1, #3
	lsr r2, r2, #0x18
	bl ov02_0224CA58
	add r1, sp, #4
	ldrb r5, [r1]
	mov r0, #0xf
	add r4, r5, #0
	and r4, r0
	cmp r4, #8
	blt _0224CBB4
	add sp, #0x10
	sub r0, #0x10
	pop {r3, r4, r5, r6, r7, pc}
_0224CBB4:
	ldrb r0, [r1, #1]
	eor r0, r5
	strb r0, [r1, #1]
	ldrb r0, [r1, #2]
	eor r0, r5
	strb r0, [r1, #2]
	ldrb r2, [r1, #1]
	ldrb r3, [r1, #2]
	lsl r0, r2, #8
	add r6, r0, #0
	ldr r0, [sp]
	orr r6, r3
	cmp r0, r6
	bne _0224CBEE
	mov r0, #0xf0
	and r0, r5
	asr r0, r0, #4
	cmp r0, #6
	bne _0224CBEE
	ldrb r0, [r1, #3]
	add r1, r5, r2
	mul r1, r3
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	cmp r0, r1
	bne _0224CBEE
	add sp, #0x10
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224CBEE:
	mov r0, #0
	mvn r0, r0
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224CAB8

	thumb_func_start ov02_0224CBF8
ov02_0224CBF8: ; 0x0224CBF8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r6, r2, #0
	str r1, [sp]
	add r7, r3, #0
	bl WallpaperPasswordBank_GetCount
	add r4, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	strh r0, [r1, #4]
	add r0, r5, #0
	add r1, r7, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	strh r0, [r1, #6]
	add r1, sp, #0x18
	ldrh r1, [r1, #0x10]
	add r0, r5, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	strh r0, [r1, #8]
	add r1, sp, #0x18
	ldrh r1, [r1, #0x14]
	add r0, r5, #0
	bl WallpaperPasswordBank_GetIndexOfWord
	add r1, sp, #4
	mov r2, #0
	strh r0, [r1, #0xa]
	add r3, sp, #8
	add r5, sp, #4
	add r7, r2, #0
_0224CC46:
	ldrsh r0, [r3, r7]
	cmp r0, #0
	bge _0224CC54
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CC54:
	cmp r2, #0
	ble _0224CC88
	mov r6, #1
	mvn r6, r6
	ldrsh r6, [r3, r6]
	cmp r0, r6
	blt _0224CC74
	sub r0, r0, r6
	cmp r0, #0xff
	ble _0224CC70
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CC70:
	strb r0, [r5]
	b _0224CC9A
_0224CC74:
	sub r0, r6, r0
	sub r0, r4, r0
	cmp r0, #0xff
	ble _0224CC84
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CC84:
	strb r0, [r5]
	b _0224CC9A
_0224CC88:
	mov r0, #4
	ldrsh r0, [r1, r0]
	cmp r0, #0xff
	ble _0224CC98
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CC98:
	strb r0, [r1]
_0224CC9A:
	add r2, r2, #1
	add r3, r3, #2
	add r5, r5, #1
	cmp r2, #4
	blt _0224CC46
	add r0, sp, #4
	mov r1, #4
	mov r2, #5
	bl ov02_0224CA58
	mov r2, #0
	add r1, sp, #4
	add r4, sp, #4
	mov r3, #0xf0
_0224CCB6:
	ldrb r5, [r4, #3]
	ldrb r0, [r1]
	add r2, r2, #1
	asr r6, r5, #4
	and r5, r3
	orr r5, r6
	eor r0, r5
	strb r0, [r1]
	add r1, r1, #1
	cmp r2, #3
	blt _0224CCB6
	add r2, sp, #4
	ldrb r3, [r2, #3]
	mov r2, #0xf
	add r0, sp, #4
	and r2, r3
	lsl r2, r2, #0x18
	mov r1, #3
	lsr r2, r2, #0x18
	bl ov02_0224CA58
	add r1, sp, #4
	ldrb r4, [r1]
	mov r0, #0xf
	and r0, r4
	lsl r2, r0, #0x18
	lsr r2, r2, #0x18
	cmp r2, #8
	blo _0224CCF4
	cmp r2, #0xb
	blo _0224CCFC
_0224CCF4:
	mov r0, #0
	add sp, #0x10
	mvn r0, r0
	pop {r3, r4, r5, r6, r7, pc}
_0224CCFC:
	ldrb r2, [r1, #1]
	eor r2, r4
	strb r2, [r1, #1]
	ldrb r2, [r1, #2]
	eor r2, r4
	strb r2, [r1, #2]
	ldrb r2, [r1, #1]
	ldrb r3, [r1, #2]
	lsl r5, r2, #8
	add r6, r5, #0
	ldr r5, [sp]
	orr r6, r3
	cmp r5, r6
	bne _0224CD30
	mov r5, #0xf0
	and r5, r4
	asr r5, r5, #4
	cmp r5, #6
	bne _0224CD30
	add r2, r4, r2
	mul r2, r3
	lsl r2, r2, #0x18
	ldrb r1, [r1, #3]
	lsr r2, r2, #0x18
	cmp r1, r2
	beq _0224CD34
_0224CD30:
	mov r0, #0
	mvn r0, r0
_0224CD34:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224CBF8

	thumb_func_start ov02_0224CD38
ov02_0224CD38: ; 0x0224CD38
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r0, #0
	ldr r0, [sp, #0x24]
	add r7, r1, #0
	str r2, [sp, #8]
	add r5, r3, #0
	bl WallpaperPasswordBank_Create
	add r4, r0, #0
	add r0, r6, #0
	bl PlayerProfile_GetTrainerID_VisibleHalf
	add r1, r0, #0
	str r5, [sp]
	add r0, sp, #0x10
	ldrh r0, [r0, #0x10]
	add r2, r7, #0
	str r0, [sp, #4]
	ldr r3, [sp, #8]
	add r0, r4, #0
	bl ov02_0224CAB8
	add r5, r0, #0
	add r0, r4, #0
	bl WallpaperPasswordBank_Delete
	add r0, r5, #0
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224CD38

	thumb_func_start ov02_0224CD74
ov02_0224CD74: ; 0x0224CD74
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r6, r0, #0
	ldr r0, [sp, #0x24]
	add r7, r1, #0
	str r2, [sp, #8]
	add r5, r3, #0
	bl WallpaperPasswordBank_Create
	add r4, r0, #0
	add r0, r6, #0
	bl PlayerProfile_GetTrainerID_VisibleHalf
	add r1, r0, #0
	str r5, [sp]
	add r0, sp, #0x10
	ldrh r0, [r0, #0x10]
	add r2, r7, #0
	str r0, [sp, #4]
	ldr r3, [sp, #8]
	add r0, r4, #0
	bl ov02_0224CBF8
	add r5, r0, #0
	add r0, r4, #0
	bl WallpaperPasswordBank_Delete
	add r0, r5, #0
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224CD74

	thumb_func_start ov02_0224CDB0
ov02_0224CDB0: ; 0x0224CDB0
	push {r4, r5, r6, lr}
	sub sp, #0x20
	add r6, r1, #0
	mov r1, #0x26
	add r2, sp, #4
	add r3, sp, #0
	add r5, r0, #0
	bl sub_02054C20
	cmp r0, #0
	beq _0224CE1C
	mov r0, #4
	mov r1, #0x18
	bl Heap_AllocAtEnd
	add r4, r0, #0
	strb r6, [r4, #0xc]
	mov r0, #0
	strb r0, [r4, #0xd]
	strb r0, [r4, #0xe]
	strb r0, [r4, #0xf]
	ldr r0, [r5, #0x30]
	bl MapMatrix_GetWidth
	add r1, r0, #0
	ldr r0, [sp]
	add r2, sp, #0x14
	bl sub_02054DC8
	ldr r1, [sp, #4]
	add r0, sp, #8
	bl MapProp_GetTranslation
	add r3, sp, #8
	ldmia r3!, {r0, r1}
	add r2, r4, #0
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r1, [r4]
	ldr r0, [sp, #0x14]
	add r2, r4, #0
	add r0, r1, r0
	str r0, [r4]
	ldr r1, [r4, #8]
	ldr r0, [sp, #0x1c]
	add r0, r1, r0
	str r0, [r4, #8]
	ldr r0, [r5, #0x10]
	ldr r1, _0224CE24 ; =ov02_0224CE28
	bl TaskManager_Call
	add sp, #0x20
	pop {r4, r5, r6, pc}
_0224CE1C:
	bl GF_AssertFail
	add sp, #0x20
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224CE24: .word ov02_0224CE28
	thumb_func_end ov02_0224CDB0

	thumb_func_start ov02_0224CE28
ov02_0224CE28: ; 0x0224CE28
	push {r4, r5, r6, lr}
	sub sp, #0x30
	add r4, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r4, #0
	bl TaskManager_GetEnvironment
	add r4, r0, #0
	ldrb r1, [r4, #0xf]
	cmp r1, #5
	bls _0224CE44
	b _0224CFC0
_0224CE44:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224CE50: ; jump table
	.short _0224CE5C - _0224CE50 - 2 ; case 0
	.short _0224CEBA - _0224CE50 - 2 ; case 1
	.short _0224CF1C - _0224CE50 - 2 ; case 2
	.short _0224CF64 - _0224CE50 - 2 ; case 3
	.short _0224CF76 - _0224CE50 - 2 ; case 4
	.short _0224CFB6 - _0224CE50 - 2 ; case 5
_0224CE5C:
	ldr r1, [r6, #0x34]
	mov r0, #0x6b
	bl ov01_021FB90C
	ldr r0, [r0]
	bl NNS_G3dGetMdlSet
	cmp r0, #0
	beq _0224CE8E
	add r2, r0, #0
	add r2, #8
	beq _0224CE82
	ldrb r1, [r0, #9]
	cmp r1, #0
	bls _0224CE82
	ldrh r1, [r0, #0xe]
	add r1, r2, r1
	add r1, r1, #4
	b _0224CE84
_0224CE82:
	mov r1, #0
_0224CE84:
	cmp r1, #0
	beq _0224CE8E
	ldr r1, [r1]
	add r5, r0, r1
	b _0224CE90
_0224CE8E:
	mov r5, #0
_0224CE90:
	ldr r0, [r6, #0x34]
	bl ov01_021FB9E0
	mov r1, #0
	str r1, [sp]
	str r5, [sp, #4]
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	str r1, [sp, #0x14]
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	mov r2, #0x10
	mov r3, #0x6b
	bl MapPropOneShotAnimationManager_LoadPropAnimations
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224CFC0
_0224CEBA:
	add r1, sp, #0x18
	mov r0, #0
	str r0, [r1]
	str r0, [r1, #4]
	str r0, [r1, #8]
	ldrb r2, [r4, #0xd]
	mov r1, #0xc
	ldr r0, [r4]
	add r3, r2, #0
	ldr r2, _0224CFC8 ; =ov02_02253DD8
	mul r3, r1
	ldr r2, [r2, r3]
	add r0, r0, r2
	str r0, [sp, #0x24]
	ldrb r2, [r4, #0xd]
	ldr r0, [r4, #4]
	add r3, r2, #0
	ldr r2, _0224CFCC ; =ov02_02253DDC
	mul r3, r1
	ldr r2, [r2, r3]
	add r0, r0, r2
	str r0, [sp, #0x28]
	ldrb r2, [r4, #0xd]
	ldr r0, [r4, #8]
	add r3, r2, #0
	mul r3, r1
	ldr r1, _0224CFD0 ; =ov02_02253DE0
	ldr r1, [r1, r3]
	add r0, r0, r1
	str r0, [sp, #0x2c]
	ldr r0, _0224CFD4 ; =SEQ_SE_DP_BOWA
	bl PlaySE
	ldr r0, [r6, #0x54]
	add r6, #0x9c
	str r0, [sp]
	ldr r0, [r6]
	mov r1, #0x6b
	add r2, sp, #0x24
	add r3, sp, #0x18
	bl MapPropManager_LoadOne
	ldrb r1, [r4, #0xd]
	add r1, r4, r1
	strb r0, [r1, #0x10]
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224CFC0
_0224CF1C:
	ldrb r0, [r4, #0xe]
	cmp r0, #0xf
	bhs _0224CF28
	add r0, r0, #1
	strb r0, [r4, #0xe]
	b _0224CFC0
_0224CF28:
	mov r0, #0
	strb r0, [r4, #0xe]
	ldrb r0, [r4, #0xd]
	add r0, r0, #1
	strb r0, [r4, #0xd]
	ldrb r1, [r4, #0xd]
	ldrb r0, [r4, #0xc]
	cmp r1, r0
	bhs _0224CF40
	mov r0, #1
	strb r0, [r4, #0xf]
	b _0224CFC0
_0224CF40:
	add r0, r6, #0
	add r0, #0x9c
	ldrb r1, [r4, #0x10]
	ldr r0, [r0]
	bl MapPropManager_GetMapPropByIndex_Checked_RequireActive
	bl MapProp_GetRenderSurface
	add r3, r0, #0
	ldr r0, [r6, #0x58]
	mov r1, #0x10
	mov r2, #0
	bl MapPropOneShotAnimationManager_SetAnimationRenderObj
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224CFC0
_0224CF64:
	ldr r0, [r6, #0x58]
	mov r1, #0x10
	mov r2, #0
	bl MapPropOneShotAnimationManager_PlayAnimation
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224CFC0
_0224CF76:
	ldr r0, [r6, #0x58]
	mov r1, #0x10
	bl MapPropOneShotAnimationManager_IsAnimationLoopFinished
	cmp r0, #0
	beq _0224CFC0
	ldr r0, [r6, #0x54]
	ldr r1, [r6, #0x58]
	mov r2, #0x10
	bl MapPropOneShotAnimationManager_UnloadAnimation
	ldrb r0, [r4, #0xc]
	mov r5, #0
	cmp r0, #0
	bls _0224CFAE
_0224CF94:
	add r0, r4, r5
	add r1, r6, #0
	add r1, #0x9c
	ldrb r0, [r0, #0x10]
	ldr r1, [r1]
	bl MapPropManager_RemoveMapPropByIndex
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldrb r0, [r4, #0xc]
	cmp r5, r0
	blo _0224CF94
_0224CFAE:
	ldrb r0, [r4, #0xf]
	add r0, r0, #1
	strb r0, [r4, #0xf]
	b _0224CFC0
_0224CFB6:
	bl Heap_Free
	add sp, #0x30
	mov r0, #1
	pop {r4, r5, r6, pc}
_0224CFC0:
	mov r0, #0
	add sp, #0x30
	pop {r4, r5, r6, pc}
	nop
_0224CFC8: .word ov02_02253DD8
_0224CFCC: .word ov02_02253DDC
_0224CFD0: .word ov02_02253DE0
_0224CFD4: .word SEQ_SE_DP_BOWA
	thumb_func_end ov02_0224CE28

	thumb_func_start ov02_0224CFD8
ov02_0224CFD8: ; 0x0224CFD8
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r2, #0
	bl MapObjectManager_GetFirstActiveObjectByID
	add r6, r0, #0
	add r1, sp, #0
	bl MapObject_CopyPositionVector
	add r0, r6, #0
	bl MapObject_GetXCoord
	add r5, r0, #0
	add r0, r6, #0
	bl MapObject_GetZCoord
	add r4, r0, #0
	add r0, r6, #0
	bl MapObject_GetFacingDirection
	cmp r0, #3
	bhi _0224D028
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224D010: ; jump table
	.short _0224D018 - _0224D010 - 2 ; case 0
	.short _0224D01C - _0224D010 - 2 ; case 1
	.short _0224D020 - _0224D010 - 2 ; case 2
	.short _0224D024 - _0224D010 - 2 ; case 3
_0224D018:
	sub r4, r4, #1
	b _0224D02C
_0224D01C:
	add r4, r4, #1
	b _0224D02C
_0224D020:
	sub r5, r5, #1
	b _0224D02C
_0224D024:
	add r5, r5, #1
	b _0224D02C
_0224D028:
	bl GF_AssertFail
_0224D02C:
	mov r3, #2
	lsl r1, r5, #0x10
	lsl r3, r3, #0xe
	ldr r2, [sp, #4]
	lsl r4, r4, #0x10
	add r1, r1, r3
	add r0, r7, #0
	add r3, r4, r3
	bl Field3dObject_SetPosEx
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224CFD8

	thumb_func_start ov02_0224D044
ov02_0224D044: ; 0x0224D044
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r1, #0
	add r6, r0, #0
	add r1, sp, #0
	bl PlayerAvatar_CopyPositionVector
	add r0, r6, #0
	bl PlayerAvatar_GetXCoord
	add r5, r0, #0
	add r0, r6, #0
	bl PlayerAvatar_GetZCoord
	add r4, r0, #0
	add r0, r6, #0
	bl PlayerAvatar_GetFacingDirection
	cmp r0, #3
	bhi _0224D090
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224D078: ; jump table
	.short _0224D080 - _0224D078 - 2 ; case 0
	.short _0224D084 - _0224D078 - 2 ; case 1
	.short _0224D088 - _0224D078 - 2 ; case 2
	.short _0224D08C - _0224D078 - 2 ; case 3
_0224D080:
	sub r4, r4, #1
	b _0224D094
_0224D084:
	add r4, r4, #1
	b _0224D094
_0224D088:
	sub r5, r5, #1
	b _0224D094
_0224D08C:
	add r5, r5, #1
	b _0224D094
_0224D090:
	bl GF_AssertFail
_0224D094:
	mov r3, #2
	lsl r1, r5, #0x10
	lsl r3, r3, #0xe
	ldr r2, [sp, #4]
	lsl r4, r4, #0x10
	add r1, r1, r3
	add r0, r7, #0
	add r3, r4, r3
	bl Field3dObject_SetPosEx
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224D044

	thumb_func_start ov02_0224D0AC
ov02_0224D0AC: ; 0x0224D0AC
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r1, #0
	add r1, sp, #0
	bl PlayerAvatar_CopyPositionVector
	ldr r1, [sp]
	ldr r2, [sp, #4]
	ldr r3, [sp, #8]
	add r0, r4, #0
	bl Field3dObject_SetPosEx
	add sp, #0xc
	pop {r3, r4, pc}
	thumb_func_end ov02_0224D0AC

	thumb_func_start ov02_0224D0C8
ov02_0224D0C8: ; 0x0224D0C8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r1, #0
	str r2, [sp, #8]
	add r6, r0, #0
	mov r1, #0
	mov r2, #0xdc
	add r4, r3, #0
	ldr r7, [sp, #0x28]
	bl memset
	add r0, r6, #0
	add r0, #0x78
	mov r1, #0x86
	add r2, r5, #0
	mov r3, #4
	bl Field3dModel_LoadFromFilesystem
	add r1, r6, #0
	add r0, r6, #0
	add r1, #0x78
	bl Field3dObject_InitFromModel
	add r0, r6, #0
	add r0, #0xd8
	str r4, [r0]
	add r0, r6, #0
	add r0, #0xd8
	ldr r0, [r0]
	mov r4, #0
	cmp r0, #0
	bls _0224D13E
	add r0, r6, #0
	add r5, r6, #0
	str r0, [sp, #0xc]
	add r0, #0x78
	add r5, #0x88
	str r0, [sp, #0xc]
_0224D114:
	ldr r3, [sp, #8]
	mov r0, #4
	str r0, [sp]
	ldr r1, [sp, #0xc]
	add r0, r5, #0
	mov r2, #0x86
	add r3, r3, r4
	str r7, [sp, #4]
	bl Field3dModelAnimation_LoadFromFilesystem
	add r0, r6, #0
	add r1, r5, #0
	bl Field3dObject_AddAnimation
	add r0, r6, #0
	add r0, #0xd8
	ldr r0, [r0]
	add r4, r4, #1
	add r5, #0x14
	cmp r4, r0
	blo _0224D114
_0224D13E:
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D0C8

	thumb_func_start ov02_0224D144
ov02_0224D144: ; 0x0224D144
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r0, #0x78
	add r7, r1, #0
	bl Field3dModel_Unload
	add r0, r6, #0
	add r0, #0xd8
	ldr r0, [r0]
	mov r4, #0
	cmp r0, #0
	bls _0224D176
	add r5, r6, #0
	add r5, #0x88
_0224D160:
	add r0, r5, #0
	add r1, r7, #0
	bl Field3dModelAnimation_Unload
	add r0, r6, #0
	add r0, #0xd8
	ldr r0, [r0]
	add r4, r4, #1
	add r5, #0x14
	cmp r4, r0
	blo _0224D160
_0224D176:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224D144

	thumb_func_start ov02_0224D178
ov02_0224D178: ; 0x0224D178
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r0, #0xd8
	ldr r0, [r0]
	mov r6, #1
	mov r4, #0
	cmp r0, #0
	bls _0224D1A6
	add r5, r7, #0
	add r5, #0x88
_0224D18C:
	mov r1, #1
	add r0, r5, #0
	lsl r1, r1, #0xc
	bl Field3dModelAnimation_FrameAdvanceAndCheck
	and r6, r0
	add r0, r7, #0
	add r0, #0xd8
	ldr r0, [r0]
	add r4, r4, #1
	add r5, #0x14
	cmp r4, r0
	blo _0224D18C
_0224D1A6:
	add r0, r6, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D178

	thumb_func_start ov02_0224D1AC
ov02_0224D1AC: ; 0x0224D1AC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r0, #0xd8
	ldr r0, [r0]
	mov r4, #0
	cmp r0, #0
	bls _0224D1D8
	add r5, r6, #0
	mov r7, #1
	add r5, #0x88
	lsl r7, r7, #0xc
_0224D1C2:
	add r0, r5, #0
	add r1, r7, #0
	bl Field3dModelAnimation_FrameAdvanceAndLoop
	add r0, r6, #0
	add r0, #0xd8
	ldr r0, [r0]
	add r4, r4, #1
	add r5, #0x14
	cmp r4, r0
	blo _0224D1C2
_0224D1D8:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D1AC

	thumb_func_start ov02_0224D1DC
ov02_0224D1DC: ; 0x0224D1DC
	ldr r3, _0224D1E0 ; =Field3dObject_Draw
	bx r3
	.balign 4, 0
_0224D1E0: .word Field3dObject_Draw
	thumb_func_end ov02_0224D1DC

	thumb_func_start ov02_0224D1E4
ov02_0224D1E4: ; 0x0224D1E4
	push {r3, r4, r5, lr}
	add r4, r2, #0
	add r5, r1, #0
	add r0, r4, #0
	mov r1, #0
	mov r2, #0xf0
	bl memset
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #3
	str r0, [sp]
	add r0, r4, #0
	mov r2, #0
	add r3, r1, #0
	bl ov02_0224D0C8
	ldr r0, [r5, #0x40]
	add r1, r4, #0
	bl ov02_0224D044
	ldr r0, _0224D228 ; =SEQ_SE_DP_FW015
	bl PlaySE
	mov r0, #0
	add r4, #0xec
	str r0, [r4]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224D228: .word SEQ_SE_DP_FW015
	thumb_func_end ov02_0224D1E4

	thumb_func_start ov02_0224D22C
ov02_0224D22C: ; 0x0224D22C
	push {r3, r4, r5, lr}
	add r4, r2, #0
	add r5, r1, #0
	add r0, r4, #0
	mov r1, #0
	mov r2, #0xf0
	bl memset
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #3
	str r0, [sp]
	add r0, r4, #0
	mov r2, #0
	add r3, r1, #0
	bl ov02_0224D0C8
	ldr r0, [r5, #0x3c]
	mov r1, #0xfd
	add r2, r4, #0
	bl ov02_0224CFD8
	ldr r0, _0224D274 ; =SEQ_SE_DP_FW015
	bl PlaySE
	mov r0, #0
	add r4, #0xec
	str r0, [r4]
	pop {r3, r4, r5, pc}
	nop
_0224D274: .word SEQ_SE_DP_FW015
	thumb_func_end ov02_0224D22C

	thumb_func_start ov02_0224D278
ov02_0224D278: ; 0x0224D278
	ldr r3, _0224D284 ; =ov02_0224D144
	add r0, r2, #0
	add r2, #0xdc
	add r1, r2, #0
	bx r3
	nop
_0224D284: .word ov02_0224D144
	thumb_func_end ov02_0224D278

	thumb_func_start ov02_0224D288
ov02_0224D288: ; 0x0224D288
	push {r4, lr}
	add r4, r2, #0
	add r0, r4, #0
	add r0, #0xec
	ldr r0, [r0]
	cmp r0, #0
	beq _0224D29A
	cmp r0, #1
	pop {r4, pc}
_0224D29A:
	add r0, r4, #0
	bl ov02_0224D178
	cmp r0, #1
	bne _0224D2B8
	add r0, r4, #0
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	add r0, r4, #0
	add r0, #0xec
	ldr r0, [r0]
	add r4, #0xec
	add r0, r0, #1
	str r0, [r4]
_0224D2B8:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D288

	thumb_func_start ov02_0224D2BC
ov02_0224D2BC: ; 0x0224D2BC
	ldr r3, _0224D2C4 ; =ov02_0224D1DC
	add r0, r2, #0
	bx r3
	nop
_0224D2C4: .word ov02_0224D1DC
	thumb_func_end ov02_0224D2BC

	thumb_func_start ov02_0224D2C8
ov02_0224D2C8: ; 0x0224D2C8
	ldr r0, [r0, #4]
	ldr r3, _0224D2D4 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224D2D8 ; =ov02_02253974
	bx r3
	nop
_0224D2D4: .word Field3dObjectTaskManager_CreateTask
_0224D2D8: .word ov02_02253974
	thumb_func_end ov02_0224D2C8

	thumb_func_start ov02_0224D2DC
ov02_0224D2DC: ; 0x0224D2DC
	ldr r0, [r0, #4]
	ldr r3, _0224D2E8 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224D2EC ; =ov02_022539BC
	bx r3
	nop
_0224D2E8: .word Field3dObjectTaskManager_CreateTask
_0224D2EC: .word ov02_022539BC
	thumb_func_end ov02_0224D2DC

	thumb_func_start ov02_0224D2F0
ov02_0224D2F0: ; 0x0224D2F0
	ldr r3, _0224D2F4 ; =Field3dObjectTask_Delete
	bx r3
	.balign 4, 0
_0224D2F4: .word Field3dObjectTask_Delete
	thumb_func_end ov02_0224D2F0

	thumb_func_start ov02_0224D2F8
ov02_0224D2F8: ; 0x0224D2F8
	push {r3, lr}
	bl Field3dObjectTask_GetData
	add r0, #0xec
	ldr r0, [r0]
	cmp r0, #1
	bne _0224D30A
	mov r0, #1
	pop {r3, pc}
_0224D30A:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D2F8

	thumb_func_start ov02_0224D310
ov02_0224D310: ; 0x0224D310
	push {r3, r4, r5, lr}
	add r4, r2, #0
	add r5, r1, #0
	add r0, r4, #0
	mov r1, #0
	mov r2, #0xf0
	bl memset
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r4, #0
	add r0, #0xdc
	mov r2, #4
	str r0, [sp]
	add r0, r4, #0
	mov r1, #8
	add r3, r2, #0
	bl ov02_0224D0C8
	ldr r0, [r5, #0x40]
	add r1, r4, #0
	bl ov02_0224D044
	ldr r0, _0224D354 ; =SEQ_SE_DP_FW088
	bl PlaySE
	mov r0, #0
	add r4, #0xec
	str r0, [r4]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224D354: .word SEQ_SE_DP_FW088
	thumb_func_end ov02_0224D310

	thumb_func_start ov02_0224D358
ov02_0224D358: ; 0x0224D358
	push {r3, r4, r5, lr}
	add r4, r2, #0
	add r5, r1, #0
	add r0, r4, #0
	mov r1, #0
	mov r2, #0xf0
	bl memset
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r4, #0
	add r0, #0xdc
	mov r2, #4
	str r0, [sp]
	add r0, r4, #0
	mov r1, #8
	add r3, r2, #0
	bl ov02_0224D0C8
	ldr r0, [r5, #0x3c]
	mov r1, #0xfd
	add r2, r4, #0
	bl ov02_0224CFD8
	ldr r0, _0224D3A0 ; =SEQ_SE_DP_FW088
	bl PlaySE
	mov r0, #0
	add r4, #0xec
	str r0, [r4]
	pop {r3, r4, r5, pc}
	nop
_0224D3A0: .word SEQ_SE_DP_FW088
	thumb_func_end ov02_0224D358

	thumb_func_start ov02_0224D3A4
ov02_0224D3A4: ; 0x0224D3A4
	ldr r3, _0224D3B0 ; =ov02_0224D144
	add r0, r2, #0
	add r2, #0xdc
	add r1, r2, #0
	bx r3
	nop
_0224D3B0: .word ov02_0224D144
	thumb_func_end ov02_0224D3A4

	thumb_func_start ov02_0224D3B4
ov02_0224D3B4: ; 0x0224D3B4
	push {r4, lr}
	add r4, r2, #0
	add r0, r4, #0
	add r0, #0xec
	ldr r0, [r0]
	cmp r0, #0
	beq _0224D3C6
	cmp r0, #1
	pop {r4, pc}
_0224D3C6:
	add r0, r4, #0
	bl ov02_0224D178
	cmp r0, #1
	bne _0224D3E4
	add r0, r4, #0
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	add r0, r4, #0
	add r0, #0xec
	ldr r0, [r0]
	add r4, #0xec
	add r0, r0, #1
	str r0, [r4]
_0224D3E4:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D3B4

	thumb_func_start ov02_0224D3E8
ov02_0224D3E8: ; 0x0224D3E8
	ldr r3, _0224D3F0 ; =ov02_0224D1DC
	add r0, r2, #0
	bx r3
	nop
_0224D3F0: .word ov02_0224D1DC
	thumb_func_end ov02_0224D3E8

	thumb_func_start ov02_0224D3F4
ov02_0224D3F4: ; 0x0224D3F4
	ldr r0, [r0, #4]
	ldr r3, _0224D400 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224D404 ; =ov02_022538FC
	bx r3
	nop
_0224D400: .word Field3dObjectTaskManager_CreateTask
_0224D404: .word ov02_022538FC
	thumb_func_end ov02_0224D3F4

	thumb_func_start ov02_0224D408
ov02_0224D408: ; 0x0224D408
	ldr r0, [r0, #4]
	ldr r3, _0224D414 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224D418 ; =ov02_0225398C
	bx r3
	nop
_0224D414: .word Field3dObjectTaskManager_CreateTask
_0224D418: .word ov02_0225398C
	thumb_func_end ov02_0224D408

	thumb_func_start ov02_0224D41C
ov02_0224D41C: ; 0x0224D41C
	ldr r3, _0224D420 ; =Field3dObjectTask_Delete
	bx r3
	.balign 4, 0
_0224D420: .word Field3dObjectTask_Delete
	thumb_func_end ov02_0224D41C

	thumb_func_start ov02_0224D424
ov02_0224D424: ; 0x0224D424
	push {r3, lr}
	bl Field3dObjectTask_GetData
	add r0, #0xec
	ldr r0, [r0]
	cmp r0, #1
	bne _0224D436
	mov r0, #1
	pop {r3, pc}
_0224D436:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D424

	thumb_func_start ov02_0224D43C
ov02_0224D43C: ; 0x0224D43C
	push {r4, lr}
	add r4, r2, #0
	mov r2, #0x73
	add r0, r4, #0
	mov r1, #0
	lsl r2, r2, #2
	bl memset
	mov r0, #0x6e
	lsl r0, r0, #2
	add r0, r4, r0
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	ldr r0, _0224D464 ; =0x000001CA
	mov r1, #0
	strh r1, [r4, r0]
	pop {r4, pc}
	nop
_0224D464: .word 0x000001CA
	thumb_func_end ov02_0224D43C

	thumb_func_start ov02_0224D468
ov02_0224D468: ; 0x0224D468
	push {r4, r5, r6, lr}
	mov r0, #0x6e
	add r5, r2, #0
	lsl r0, r0, #2
	mov r4, #0
	add r6, r5, r0
_0224D474:
	add r0, r5, #0
	add r1, r6, #0
	bl ov02_0224D144
	add r4, r4, #1
	add r5, #0xdc
	cmp r4, #2
	blt _0224D474
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D468

	thumb_func_start ov02_0224D488
ov02_0224D488: ; 0x0224D488
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	ldr r7, _0224D574 ; =0x000001CA
	add r4, r2, #0
	ldrh r0, [r4, r7]
	add r5, r1, #0
	cmp r0, #3
	bhi _0224D570
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224D4A4: ; jump table
	.short _0224D4AC - _0224D4A4 - 2 ; case 0
	.short _0224D50A - _0224D4A4 - 2 ; case 1
	.short _0224D522 - _0224D4A4 - 2 ; case 2
	.short _0224D55E - _0224D4A4 - 2 ; case 3
_0224D4AC:
	ldr r2, _0224D578 ; =ov02_022538EC
	add r1, sp, #4
	ldrb r3, [r2, #2]
	add r0, sp, #4
	add r1, #2
	strb r3, [r0, #2]
	ldrb r3, [r2, #3]
	strb r3, [r0, #3]
	ldrb r6, [r2, #4]
	add r3, sp, #4
	strb r6, [r0]
	ldrb r2, [r2, #5]
	strb r2, [r0, #1]
	sub r0, r7, #2
	ldrh r0, [r4, r0]
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	mov r0, #0xdc
	add r6, r2, #0
	mul r6, r0
	add r0, #0xdc
	add r0, r4, r0
	str r0, [sp]
	ldrb r1, [r1, r2]
	ldrb r2, [r3, r2]
	add r0, r4, r6
	mov r3, #2
	bl ov02_0224D0C8
	ldr r0, [r5, #0x40]
	add r1, r4, r6
	bl ov02_0224D0AC
	sub r1, r7, #2
	ldrh r0, [r4, r1]
	add r0, r0, #1
	strh r0, [r4, r1]
	ldrh r0, [r4, r1]
	cmp r0, #2
	blo _0224D570
	add r0, r1, #2
	ldrh r0, [r4, r0]
	add sp, #8
	add r2, r0, #1
	add r0, r1, #2
	strh r2, [r4, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0224D50A:
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	ldr r0, _0224D57C ; =SEQ_SE_DP_FW463
	bl PlaySE
	add r0, r7, #0
	ldrh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
_0224D522:
	add r0, r4, #0
	bl ov02_0224D178
	add r6, r0, #0
	ldr r0, [r5, #0x40]
	add r1, r4, #0
	bl ov02_0224D0AC
	cmp r6, #1
	bne _0224D570
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #1
	bl Field3dObject_SetActiveFlag
	add r0, r4, #0
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	add r1, r4, #0
	ldr r0, [r5, #0x40]
	add r1, #0xdc
	bl ov02_0224D0AC
	ldr r0, _0224D574 ; =0x000001CA
	add sp, #8
	ldrh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0224D55E:
	add r0, r4, #0
	add r0, #0xdc
	bl ov02_0224D1AC
	add r4, #0xdc
	ldr r0, [r5, #0x40]
	add r1, r4, #0
	bl ov02_0224D0AC
_0224D570:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224D574: .word 0x000001CA
_0224D578: .word ov02_022538EC
_0224D57C: .word SEQ_SE_DP_FW463
	thumb_func_end ov02_0224D488

	thumb_func_start ov02_0224D580
ov02_0224D580: ; 0x0224D580
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r4, #0
_0224D586:
	add r0, r5, #0
	bl ov02_0224D1DC
	add r4, r4, #1
	add r5, #0xdc
	cmp r4, #2
	blt _0224D586
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D580

	thumb_func_start ov02_0224D598
ov02_0224D598: ; 0x0224D598
	ldr r0, [r0, #4]
	ldr r3, _0224D5A4 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224D5A8 ; =ov02_02253944
	bx r3
	nop
_0224D5A4: .word Field3dObjectTaskManager_CreateTask
_0224D5A8: .word ov02_02253944
	thumb_func_end ov02_0224D598

	thumb_func_start ov02_0224D5AC
ov02_0224D5AC: ; 0x0224D5AC
	ldr r3, _0224D5B0 ; =Field3dObjectTask_Delete
	bx r3
	.balign 4, 0
_0224D5B0: .word Field3dObjectTask_Delete
	thumb_func_end ov02_0224D5AC

	thumb_func_start ov02_0224D5B4
ov02_0224D5B4: ; 0x0224D5B4
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r1, #0
	ldr r1, _0224D640 ; =ov02_022538EC
	add r4, r2, #0
	ldrb r2, [r1]
	add r0, sp, #4
	strb r2, [r0, #1]
	ldrb r2, [r1, #1]
	strb r2, [r0]
	ldrh r2, [r1, #6]
	strh r2, [r0, #2]
	ldrh r2, [r1, #8]
	strh r2, [r0, #4]
	ldrh r2, [r1, #0xa]
	strh r2, [r0, #6]
	ldrh r1, [r1, #0xc]
	mov r2, #0xf0
	strh r1, [r0, #8]
	add r0, r4, #0
	mov r1, #0
	bl memset
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetFacingDirection
	add r6, r0, #0
	add r0, r4, #0
	add r0, #0xdc
	str r0, [sp]
	add r2, sp, #4
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	add r0, r4, #0
	mov r3, #1
	bl ov02_0224D0C8
	add r0, r4, #0
	bl ov02_0224D1AC
	ldr r0, [r5, #0x40]
	add r1, r4, #0
	bl ov02_0224D0AC
	add r0, sp, #4
	lsl r1, r6, #1
	add r0, #2
	ldrh r0, [r0, r1]
	bl GF_DegreeToSinCosIdxNoWrap
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #1
	bl Field3dObject_SetXRotation
	ldr r0, _0224D644 ; =SEQ_SE_DP_FW463
	bl PlaySE
	mov r0, #0
	add r4, #0xec
	strh r0, [r4]
	add sp, #0x10
	pop {r4, r5, r6, pc}
	nop
_0224D640: .word ov02_022538EC
_0224D644: .word SEQ_SE_DP_FW463
	thumb_func_end ov02_0224D5B4

	thumb_func_start ov02_0224D648
ov02_0224D648: ; 0x0224D648
	ldr r3, _0224D654 ; =ov02_0224D144
	add r0, r2, #0
	add r2, #0xdc
	add r1, r2, #0
	bx r3
	nop
_0224D654: .word ov02_0224D144
	thumb_func_end ov02_0224D648

	thumb_func_start ov02_0224D658
ov02_0224D658: ; 0x0224D658
	push {r3, r4, r5, lr}
	add r4, r2, #0
	add r5, r1, #0
	add r0, r4, #0
	bl ov02_0224D1AC
	ldr r0, [r5, #0x40]
	add r1, r4, #0
	bl ov02_0224D0AC
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D658

	thumb_func_start ov02_0224D670
ov02_0224D670: ; 0x0224D670
	ldr r3, _0224D678 ; =ov02_0224D1DC
	add r0, r2, #0
	bx r3
	nop
_0224D678: .word ov02_0224D1DC
	thumb_func_end ov02_0224D670

	thumb_func_start ov02_0224D67C
ov02_0224D67C: ; 0x0224D67C
	ldr r0, [r0, #4]
	ldr r3, _0224D688 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224D68C ; =ov02_02253914
	bx r3
	nop
_0224D688: .word Field3dObjectTaskManager_CreateTask
_0224D68C: .word ov02_02253914
	thumb_func_end ov02_0224D67C

	thumb_func_start ov02_0224D690
ov02_0224D690: ; 0x0224D690
	ldr r3, _0224D694 ; =Field3dObjectTask_Delete
	bx r3
	.balign 4, 0
_0224D694: .word Field3dObjectTask_Delete
	thumb_func_end ov02_0224D690

	thumb_func_start ov02_0224D698
ov02_0224D698: ; 0x0224D698
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r7, r0, #0
	add r0, #0xc8
	ldr r0, [r0]
	add r6, r1, #0
	add r4, r2, #0
	add r5, r3, #0
	cmp r0, #0
	beq _0224D6B0
	bl GF_AssertFail
_0224D6B0:
	add r0, r6, #0
	add r1, sp, #0
	bl PlayerAvatar_CopyPositionVector
	ldr r2, [sp, #4]
	ldr r3, [sp, #8]
	ldr r1, [sp]
	add r0, r7, #0
	add r2, r2, r4
	add r3, r3, r5
	bl Field3dObject_SetPosEx
	add r0, r7, #0
	mov r4, #0
	add r5, r7, #0
	mov r1, #1
	add r0, #0xc8
	str r1, [r0]
	add r5, #0x78
	add r6, r4, #0
_0224D6D8:
	add r0, r5, #0
	add r1, r6, #0
	bl Field3dModelAnimation_FrameSet
	add r4, r4, #1
	add r5, #0x14
	cmp r4, #4
	blt _0224D6D8
	add r0, r7, #0
	mov r1, #1
	bl Field3dObject_SetActiveFlag
	ldr r0, _0224D6FC ; =SEQ_SE_DP_UG_023
	bl PlaySE
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_0224D6FC: .word SEQ_SE_DP_UG_023
	thumb_func_end ov02_0224D698

	thumb_func_start ov02_0224D700
ov02_0224D700: ; 0x0224D700
	push {r3, r4, r5, r6, r7, lr}
	str r0, [sp]
	add r0, #0xc8
	ldr r0, [r0]
	cmp r0, #0
	beq _0224D73A
	ldr r5, [sp]
	mov r4, #1
	mov r6, #0
	add r5, #0x78
	lsl r7, r4, #0xc
_0224D716:
	add r0, r5, #0
	add r1, r7, #0
	bl Field3dModelAnimation_FrameAdvanceAndCheck
	add r6, r6, #1
	and r4, r0
	add r5, #0x14
	cmp r6, #4
	blt _0224D716
	cmp r4, #1
	bne _0224D73A
	ldr r0, [sp]
	mov r1, #0
	add r0, #0xc8
	str r1, [r0]
	ldr r0, [sp]
	bl Field3dObject_SetActiveFlag
_0224D73A:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224D700

	thumb_func_start ov02_0224D73C
ov02_0224D73C: ; 0x0224D73C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	str r1, [sp]
	str r2, [sp, #4]
	mov r1, #0
	mov r2, #0xcc
	add r7, r0, #0
	add r5, r3, #0
	bl memset
	ldr r1, [sp]
	add r0, r7, #0
	bl Field3dObject_InitFromModel
	add r4, r7, #0
	mov r6, #0
	add r4, #0x78
_0224D75E:
	ldr r1, [sp]
	ldr r2, [r5]
	ldr r3, [sp, #4]
	add r0, r4, #0
	bl ov01_021FBE70
	add r0, r7, #0
	add r1, r4, #0
	bl Field3dObject_AddAnimation
	add r6, r6, #1
	add r5, r5, #4
	add r4, #0x14
	cmp r6, #4
	blt _0224D75E
	add r0, r7, #0
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224D73C

	thumb_func_start ov02_0224D788
ov02_0224D788: ; 0x0224D788
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r5, r7, #0
	add r6, r1, #0
	mov r4, #0
	add r5, #0x78
_0224D794:
	add r0, r5, #0
	add r1, r6, #0
	bl Field3dModelAnimation_Unload
	add r4, r4, #1
	add r5, #0x14
	cmp r4, #4
	blt _0224D794
	add r0, r7, #0
	mov r1, #0
	mov r2, #0xcc
	bl memset
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224D788

	thumb_func_start ov02_0224D7B0
ov02_0224D7B0: ; 0x0224D7B0
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0xce
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	add r1, sp, #0
	ldr r0, [r0, #0x40]
	bl PlayerAvatar_CopyPositionVector
	mov r1, #0xcf
	lsl r1, r1, #4
	ldr r2, [sp]
	ldr r0, [r4, r1]
	sub r0, r2, r0
	bne _0224D7F8
	add r0, r1, #4
	ldr r2, [sp, #4]
	ldr r0, [r4, r0]
	cmp r2, r0
	bge _0224D7F8
	add r0, r1, #0
	add r0, #8
	ldr r2, [sp, #8]
	ldr r0, [r4, r0]
	cmp r2, r0
	ble _0224D7F8
	add r0, r1, #0
	mov r2, #0
	sub r0, #8
	str r2, [r4, r0]
	mov r2, #2
	lsl r2, r2, #0x10
	sub r0, r1, #4
	str r2, [r4, r0]
	b _0224D806
_0224D7F8:
	mov r1, #2
	ldr r0, _0224D81C ; =0x00000CE8
	lsl r1, r1, #0x10
	str r1, [r4, r0]
	lsr r1, r1, #1
	add r0, r0, #4
	str r1, [r4, r0]
_0224D806:
	mov r0, #0xcf
	lsl r0, r0, #4
	add r3, sp, #0
	add r2, r4, r0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_0224D81C: .word 0x00000CE8
	thumb_func_end ov02_0224D7B0

	thumb_func_start ov02_0224D820
ov02_0224D820: ; 0x0224D820
	push {r4, lr}
	add r4, r0, #0
	bl ov02_0224D7B0
	mov r2, #0
	add r1, r4, #0
_0224D82C:
	add r0, r1, #0
	add r0, #0xd8
	ldr r0, [r0]
	cmp r0, #0
	bne _0224D858
	add r1, r4, #0
	mov r0, #0xcc
	mov r3, #0xce
	add r1, #0x10
	mul r0, r2
	lsl r3, r3, #4
	add r0, r1, r0
	ldr r1, [r4, r3]
	add r2, r3, #0
	add r2, #8
	add r3, #0xc
	ldr r1, [r1, #0x40]
	ldr r2, [r4, r2]
	ldr r3, [r4, r3]
	bl ov02_0224D698
	pop {r4, pc}
_0224D858:
	add r2, r2, #1
	add r1, #0xcc
	cmp r2, #0x10
	blt _0224D82C
	bl GF_AssertFail
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224D820

	thumb_func_start ov02_0224D868
ov02_0224D868: ; 0x0224D868
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
	add r5, #0x10
_0224D870:
	add r0, r5, #0
	bl ov02_0224D700
	add r4, r4, #1
	add r5, #0xcc
	cmp r4, #0x10
	blt _0224D870
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224D868

	thumb_func_start ov02_0224D880
ov02_0224D880: ; 0x0224D880
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r2, #0
	mov r2, #0xd1
	str r1, [sp, #4]
	add r0, r5, #0
	mov r1, #0
	lsl r2, r2, #4
	bl memset
	ldr r0, _0224D90C ; =0x00000CFC
	mov r1, #4
	add r0, r5, r0
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r5, #0
	mov r1, #0x86
	mov r2, #8
	mov r3, #4
	bl Field3dModel_LoadFromFilesystem
	mov r7, #0xcd
	mov r4, #0
	add r6, r5, #0
	lsl r7, r7, #4
_0224D8B4:
	mov r0, #0
	str r0, [sp]
	mov r0, #0x86
	add r1, r4, #4
	mov r2, #0
	mov r3, #4
	bl GfGfxLoader_LoadFromNarc
	str r0, [r6, r7]
	add r4, r4, #1
	add r6, r6, #4
	cmp r4, #4
	blt _0224D8B4
	add r4, r5, #0
	mov r7, #0xcd
	mov r6, #0
	add r4, #0x10
	lsl r7, r7, #4
_0224D8D8:
	ldr r2, _0224D90C ; =0x00000CFC
	add r0, r4, #0
	add r1, r5, #0
	add r2, r5, r2
	add r3, r5, r7
	bl ov02_0224D73C
	add r6, r6, #1
	add r4, #0xcc
	cmp r6, #0x10
	blt _0224D8D8
	mov r1, #0xce
	ldr r0, [sp, #4]
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r5, r1]
	add r1, #0x10
	ldr r0, [r0, #0x40]
	add r1, r5, r1
	bl PlayerAvatar_CopyPositionVector
	ldr r0, _0224D910 ; =0x00000D0C
	mov r1, #0
	str r1, [r5, r0]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224D90C: .word 0x00000CFC
_0224D910: .word 0x00000D0C
	thumb_func_end ov02_0224D880

	thumb_func_start ov02_0224D914
ov02_0224D914: ; 0x0224D914
	push {r3, r4, r5, r6, r7, lr}
	add r5, r2, #0
	add r4, r5, #0
	ldr r7, _0224D94C ; =0x00000CFC
	mov r6, #0
	add r4, #0x10
_0224D920:
	add r0, r4, #0
	add r1, r5, r7
	bl ov02_0224D788
	add r6, r6, #1
	add r4, #0xcc
	cmp r6, #0x10
	blt _0224D920
	add r0, r5, #0
	bl Field3dModel_Unload
	mov r6, #0xcd
	mov r4, #0
	lsl r6, r6, #4
_0224D93C:
	ldr r0, [r5, r6]
	bl Heap_Free
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _0224D93C
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224D94C: .word 0x00000CFC
	thumb_func_end ov02_0224D914

	thumb_func_start ov02_0224D950
ov02_0224D950: ; 0x0224D950
	push {r4, lr}
	ldr r1, _0224D988 ; =0x00000D0C
	add r4, r2, #0
	ldr r0, [r4, r1]
	cmp r0, #0
	bne _0224D986
	add r0, r1, #0
	sub r0, #0x28
	ldr r0, [r4, r0]
	sub r2, r0, #1
	add r0, r1, #0
	sub r0, #0x28
	str r2, [r4, r0]
	add r0, r1, #0
	sub r0, #0x28
	ldr r0, [r4, r0]
	cmp r0, #0
	bge _0224D980
	mov r0, #4
	sub r1, #0x28
	str r0, [r4, r1]
	add r0, r4, #0
	bl ov02_0224D820
_0224D980:
	add r0, r4, #0
	bl ov02_0224D868
_0224D986:
	pop {r4, pc}
	.balign 4, 0
_0224D988: .word 0x00000D0C
	thumb_func_end ov02_0224D950

	thumb_func_start ov02_0224D98C
ov02_0224D98C: ; 0x0224D98C
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r4, #0
	add r5, #0x10
_0224D994:
	add r0, r5, #0
	bl Field3dObject_Draw
	add r4, r4, #1
	add r5, #0xcc
	cmp r4, #0x10
	blt _0224D994
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224D98C

	thumb_func_start ov02_0224D9A4
ov02_0224D9A4: ; 0x0224D9A4
	ldr r0, [r0, #4]
	ldr r3, _0224D9B0 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224D9B4 ; =ov02_0225395C
	bx r3
	nop
_0224D9B0: .word Field3dObjectTaskManager_CreateTask
_0224D9B4: .word ov02_0225395C
	thumb_func_end ov02_0224D9A4

	thumb_func_start ov02_0224D9B8
ov02_0224D9B8: ; 0x0224D9B8
	ldr r3, _0224D9BC ; =Field3dObjectTask_Delete
	bx r3
	.balign 4, 0
_0224D9BC: .word Field3dObjectTask_Delete
	thumb_func_end ov02_0224D9B8

	thumb_func_start ov02_0224D9C0
ov02_0224D9C0: ; 0x0224D9C0
	push {r3, r4, r5, lr}
	sub sp, #0x28
	add r4, r2, #0
	mov r2, #0x45
	add r5, r1, #0
	add r0, r4, #0
	mov r1, #0
	lsl r2, r2, #2
	bl memset
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r4, #0
	add r0, #0xdc
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0x13
	mov r2, #0x11
	mov r3, #2
	bl ov02_0224D0C8
	ldr r0, [r5, #0x40]
	add r1, r4, #0
	bl ov02_0224D044
	ldr r1, [r5, #0x24]
	add r0, sp, #0x10
	bl Camera_GetLookAtCamTarget
	add r3, sp, #0x10
	add r2, r4, #0
	ldmia r3!, {r0, r1}
	add r2, #0xf8
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r1, [r5, #0x24]
	add r0, sp, #4
	bl Camera_GetLookAtCamPos
	add r3, sp, #4
	add r2, r4, #0
	ldmia r3!, {r0, r1}
	add r2, #0xec
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	add r1, sp, #0x1c
	str r0, [r2]
	mov r0, #0
	str r0, [r1]
	str r0, [r1, #4]
	str r0, [r1, #8]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetFacingDirection
	cmp r0, #3
	bhi _0224DA7C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224DA46: ; jump table
	.short _0224DA4E - _0224DA46 - 2 ; case 0
	.short _0224DA5A - _0224DA46 - 2 ; case 1
	.short _0224DA66 - _0224DA46 - 2 ; case 2
	.short _0224DA72 - _0224DA46 - 2 ; case 3
_0224DA4E:
	mov r0, #2
	ldr r1, [sp, #0x24]
	lsl r0, r0, #0xe
	sub r0, r1, r0
	str r0, [sp, #0x24]
	b _0224DA7C
_0224DA5A:
	mov r0, #2
	ldr r1, [sp, #0x24]
	lsl r0, r0, #0xe
	add r0, r1, r0
	str r0, [sp, #0x24]
	b _0224DA7C
_0224DA66:
	mov r0, #2
	ldr r1, [sp, #0x1c]
	lsl r0, r0, #0xe
	sub r0, r1, r0
	str r0, [sp, #0x1c]
	b _0224DA7C
_0224DA72:
	mov r0, #2
	ldr r1, [sp, #0x1c]
	lsl r0, r0, #0xe
	add r0, r1, r0
	str r0, [sp, #0x1c]
_0224DA7C:
	mov r0, #0x41
	lsl r0, r0, #2
	add r3, sp, #0x1c
	add r2, r4, r0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r0, _0224DA9C ; =SEQ_SE_GS_ZUTUKI
	bl PlaySE
	ldr r0, _0224DAA0 ; =0x00000113
	mov r1, #0
	strb r1, [r4, r0]
	add sp, #0x28
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0224DA9C: .word SEQ_SE_GS_ZUTUKI
_0224DAA0: .word 0x00000113
	thumb_func_end ov02_0224D9C0

	thumb_func_start ov02_0224DAA4
ov02_0224DAA4: ; 0x0224DAA4
	push {r3, r4, r5, lr}
	sub sp, #0x28
	add r4, r2, #0
	mov r2, #0x45
	add r5, r1, #0
	add r0, r4, #0
	mov r1, #0
	lsl r2, r2, #2
	bl memset
	add r0, r4, #0
	add r0, #0xdc
	mov r1, #4
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r4, #0
	add r0, #0xdc
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0x13
	mov r2, #0x11
	mov r3, #2
	bl ov02_0224D0C8
	ldr r0, [r5, #0x3c]
	mov r1, #0xfd
	add r2, r4, #0
	bl ov02_0224CFD8
	ldr r1, [r5, #0x24]
	add r0, sp, #0x10
	bl Camera_GetLookAtCamTarget
	add r3, sp, #0x10
	add r2, r4, #0
	ldmia r3!, {r0, r1}
	add r2, #0xf8
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r1, [r5, #0x24]
	add r0, sp, #4
	bl Camera_GetLookAtCamPos
	add r3, sp, #4
	add r2, r4, #0
	ldmia r3!, {r0, r1}
	add r2, #0xec
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	add r1, sp, #0x1c
	str r0, [r2]
	mov r0, #0
	str r0, [r1]
	str r0, [r1, #4]
	str r0, [r1, #8]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetFacingDirection
	cmp r0, #3
	bhi _0224DB62
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224DB2C: ; jump table
	.short _0224DB34 - _0224DB2C - 2 ; case 0
	.short _0224DB40 - _0224DB2C - 2 ; case 1
	.short _0224DB4C - _0224DB2C - 2 ; case 2
	.short _0224DB58 - _0224DB2C - 2 ; case 3
_0224DB34:
	mov r0, #2
	ldr r1, [sp, #0x24]
	lsl r0, r0, #0xe
	sub r0, r1, r0
	str r0, [sp, #0x24]
	b _0224DB62
_0224DB40:
	mov r0, #2
	ldr r1, [sp, #0x24]
	lsl r0, r0, #0xe
	add r0, r1, r0
	str r0, [sp, #0x24]
	b _0224DB62
_0224DB4C:
	mov r0, #2
	ldr r1, [sp, #0x1c]
	lsl r0, r0, #0xe
	sub r0, r1, r0
	str r0, [sp, #0x1c]
	b _0224DB62
_0224DB58:
	mov r0, #2
	ldr r1, [sp, #0x1c]
	lsl r0, r0, #0xe
	add r0, r1, r0
	str r0, [sp, #0x1c]
_0224DB62:
	mov r0, #0x41
	lsl r0, r0, #2
	add r3, sp, #0x1c
	add r2, r4, r0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	str r0, [r2]
	ldr r0, _0224DB84 ; =SEQ_SE_GS_ZUTUKI
	bl PlaySE
	ldr r0, _0224DB88 ; =0x00000113
	mov r1, #0
	strb r1, [r4, r0]
	add sp, #0x28
	pop {r3, r4, r5, pc}
	nop
_0224DB84: .word SEQ_SE_GS_ZUTUKI
_0224DB88: .word 0x00000113
	thumb_func_end ov02_0224DAA4

	thumb_func_start ov02_0224DB8C
ov02_0224DB8C: ; 0x0224DB8C
	ldr r3, _0224DB98 ; =ov02_0224D144
	add r0, r2, #0
	add r2, #0xdc
	add r1, r2, #0
	bx r3
	nop
_0224DB98: .word ov02_0224D144
	thumb_func_end ov02_0224DB8C

	thumb_func_start ov02_0224DB9C
ov02_0224DB9C: ; 0x0224DB9C
	push {r3, r4, r5, lr}
	add r5, r1, #0
	ldr r1, _0224DC50 ; =0x00000113
	add r4, r2, #0
	ldrb r0, [r4, r1]
	cmp r0, #0
	beq _0224DBB0
	cmp r0, #1
	beq _0224DC38
	pop {r3, r4, r5, pc}
_0224DBB0:
	sub r0, r1, #1
	ldrb r0, [r4, r0]
	cmp r0, #2
	bhs _0224DC1C
	sub r0, r1, #3
	ldrsb r0, [r4, r0]
	cmp r0, #0
	bgt _0224DC12
	mov r2, #1
	sub r0, r1, #3
	strb r2, [r4, r0]
	sub r0, r1, #2
	ldrb r0, [r4, r0]
	add r0, r0, #1
	lsr r2, r0, #0x1f
	lsl r1, r0, #0x1f
	sub r1, r1, r2
	mov r0, #0x1f
	ror r1, r0
	add r2, r2, r1
	add r1, r0, #0
	add r1, #0xf2
	strb r2, [r4, r1]
	add r1, r0, #0
	add r1, #0xf2
	ldrb r1, [r4, r1]
	cmp r1, #0
	beq _0224DBF4
	add r0, #0xe5
	ldr r1, [r5, #0x24]
	add r0, r4, r0
	bl Camera_OffsetLookAtPosAndTarget
	b _0224DC1C
_0224DBF4:
	add r0, r4, #0
	ldr r1, [r5, #0x24]
	add r0, #0xf8
	bl Camera_SetLookAtCamTarget
	add r0, r4, #0
	ldr r1, [r5, #0x24]
	add r0, #0xec
	bl Camera_SetLookAtCamPos
	ldr r0, _0224DC54 ; =0x00000112
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	b _0224DC1C
_0224DC12:
	sub r0, r1, #3
	ldrsb r0, [r4, r0]
	sub r2, r0, #1
	sub r0, r1, #3
	strb r2, [r4, r0]
_0224DC1C:
	add r0, r4, #0
	bl ov02_0224D178
	cmp r0, #1
	bne _0224DC4C
	add r0, r4, #0
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	ldr r0, _0224DC50 ; =0x00000113
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	pop {r3, r4, r5, pc}
_0224DC38:
	add r0, r4, #0
	ldr r1, [r5, #0x24]
	add r0, #0xf8
	bl Camera_SetLookAtCamTarget
	add r4, #0xec
	ldr r1, [r5, #0x24]
	add r0, r4, #0
	bl Camera_SetLookAtCamPos
_0224DC4C:
	pop {r3, r4, r5, pc}
	nop
_0224DC50: .word 0x00000113
_0224DC54: .word 0x00000112
	thumb_func_end ov02_0224DB9C

	thumb_func_start ov02_0224DC58
ov02_0224DC58: ; 0x0224DC58
	ldr r3, _0224DC60 ; =ov02_0224D1DC
	add r0, r2, #0
	bx r3
	nop
_0224DC60: .word ov02_0224D1DC
	thumb_func_end ov02_0224DC58

	thumb_func_start ov02_0224DC64
ov02_0224DC64: ; 0x0224DC64
	ldr r0, [r0, #4]
	ldr r3, _0224DC70 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224DC74 ; =ov02_022539A4
	bx r3
	nop
_0224DC70: .word Field3dObjectTaskManager_CreateTask
_0224DC74: .word ov02_022539A4
	thumb_func_end ov02_0224DC64

	thumb_func_start ov02_0224DC78
ov02_0224DC78: ; 0x0224DC78
	ldr r0, [r0, #4]
	ldr r3, _0224DC84 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224DC88 ; =ov02_0225392C
	bx r3
	nop
_0224DC84: .word Field3dObjectTaskManager_CreateTask
_0224DC88: .word ov02_0225392C
	thumb_func_end ov02_0224DC78

	thumb_func_start ov02_0224DC8C
ov02_0224DC8C: ; 0x0224DC8C
	ldr r3, _0224DC90 ; =Field3dObjectTask_Delete
	bx r3
	.balign 4, 0
_0224DC90: .word Field3dObjectTask_Delete
	thumb_func_end ov02_0224DC8C

	thumb_func_start ov02_0224DC94
ov02_0224DC94: ; 0x0224DC94
	push {r3, lr}
	bl Field3dObjectTask_GetData
	ldr r1, _0224DCAC ; =0x00000113
	ldrb r0, [r0, r1]
	cmp r0, #1
	bne _0224DCA6
	mov r0, #1
	pop {r3, pc}
_0224DCA6:
	mov r0, #0
	pop {r3, pc}
	nop
_0224DCAC: .word 0x00000113
	thumb_func_end ov02_0224DC94

	thumb_func_start ov02_0224DCB0
ov02_0224DCB0: ; 0x0224DCB0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r6, r2, #0
	str r1, [sp, #4]
	ldr r2, _0224DD28 ; =0x00000E9C
	add r0, r6, #0
	mov r1, #0
	bl memset
	ldr r0, _0224DD2C ; =0x00000E88
	mov r1, #4
	add r0, r6, r0
	mov r2, #0x20
	bl HeapExp_FndInitAllocator
	add r0, r6, #0
	mov r1, #0x86
	mov r2, #8
	mov r3, #4
	bl Field3dModel_LoadFromFilesystem
	ldr r7, _0224DD30 ; =0x00000E68
	mov r4, #0
	add r5, r6, #0
_0224DCE0:
	mov r0, #0
	str r0, [sp]
	mov r0, #0x86
	add r1, r4, #4
	mov r2, #0
	mov r3, #4
	bl GfGfxLoader_LoadFromNarc
	str r0, [r5, r7]
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _0224DCE0
	add r4, r6, #0
	ldr r7, _0224DD30 ; =0x00000E68
	mov r5, #0
	add r4, #0x10
_0224DD02:
	ldr r2, _0224DD2C ; =0x00000E88
	add r0, r4, #0
	add r1, r6, #0
	add r2, r6, r2
	add r3, r6, r7
	bl ov02_0224DEA8
	add r5, r5, #1
	add r4, #0xcc
	cmp r5, #0x12
	blt _0224DD02
	ldr r1, _0224DD34 ; =0x00000E78
	ldr r0, [sp, #4]
	str r0, [r6, r1]
	mov r0, #0
	add r1, #0x20
	strh r0, [r6, r1]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224DD28: .word 0x00000E9C
_0224DD2C: .word 0x00000E88
_0224DD30: .word 0x00000E68
_0224DD34: .word 0x00000E78
	thumb_func_end ov02_0224DCB0

	thumb_func_start ov02_0224DD38
ov02_0224DD38: ; 0x0224DD38
	push {r4, lr}
	add r4, r2, #0
	bl ov02_0224DCB0
	ldr r0, _0224DD48 ; =0x00000E9A
	mov r1, #1
	strh r1, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
_0224DD48: .word 0x00000E9A
	thumb_func_end ov02_0224DD38

	thumb_func_start ov02_0224DD4C
ov02_0224DD4C: ; 0x0224DD4C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r2, #0
	add r4, r5, #0
	ldr r7, _0224DD84 ; =0x00000E88
	mov r6, #0
	add r4, #0x10
_0224DD58:
	add r0, r4, #0
	add r1, r5, r7
	bl ov02_0224DEF4
	add r6, r6, #1
	add r4, #0xcc
	cmp r6, #0x12
	blt _0224DD58
	add r0, r5, #0
	bl Field3dModel_Unload
	ldr r6, _0224DD88 ; =0x00000E68
	mov r4, #0
_0224DD72:
	ldr r0, [r5, r6]
	bl Heap_Free
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #4
	blt _0224DD72
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224DD84: .word 0x00000E88
_0224DD88: .word 0x00000E68
	thumb_func_end ov02_0224DD4C

	thumb_func_start ov02_0224DD8C
ov02_0224DD8C: ; 0x0224DD8C
	push {r4, lr}
	ldr r1, _0224DDC4 ; =0x00000E98
	add r4, r2, #0
	ldrh r0, [r4, r1]
	cmp r0, #0
	bne _0224DDC2
	add r0, r1, #0
	sub r0, #0x1c
	ldr r0, [r4, r0]
	sub r2, r0, #1
	add r0, r1, #0
	sub r0, #0x1c
	str r2, [r4, r0]
	add r0, r1, #0
	sub r0, #0x1c
	ldr r0, [r4, r0]
	cmp r0, #0
	bge _0224DDBC
	mov r0, #4
	sub r1, #0x1c
	str r0, [r4, r1]
	add r0, r4, #0
	bl ov02_0224DF1C
_0224DDBC:
	add r0, r4, #0
	bl ov02_0224E008
_0224DDC2:
	pop {r4, pc}
	.balign 4, 0
_0224DDC4: .word 0x00000E98
	thumb_func_end ov02_0224DD8C

	thumb_func_start ov02_0224DDC8
ov02_0224DDC8: ; 0x0224DDC8
	push {r3, r4, r5, lr}
	add r5, r2, #0
	mov r4, #0
	add r5, #0x10
_0224DDD0:
	add r0, r5, #0
	bl Field3dObject_Draw
	add r4, r4, #1
	add r5, #0xcc
	cmp r4, #0x12
	blt _0224DDD0
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224DDC8

	thumb_func_start ov02_0224DDE0
ov02_0224DDE0: ; 0x0224DDE0
	ldr r0, [r0, #4]
	ldr r3, _0224DDEC ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224DDF0 ; =ov02_022539D4
	bx r3
	nop
_0224DDEC: .word Field3dObjectTaskManager_CreateTask
_0224DDF0: .word ov02_022539D4
	thumb_func_end ov02_0224DDE0

	thumb_func_start ov02_0224DDF4
ov02_0224DDF4: ; 0x0224DDF4
	ldr r0, [r0, #4]
	ldr r3, _0224DE00 ; =Field3dObjectTaskManager_CreateTask
	ldr r0, [r0, #4]
	ldr r1, _0224DE04 ; =ov02_022539EC
	bx r3
	nop
_0224DE00: .word Field3dObjectTaskManager_CreateTask
_0224DE04: .word ov02_022539EC
	thumb_func_end ov02_0224DDF4

	thumb_func_start ov02_0224DE08
ov02_0224DE08: ; 0x0224DE08
	ldr r3, _0224DE0C ; =Field3dObjectTask_Delete
	bx r3
	.balign 4, 0
_0224DE0C: .word Field3dObjectTask_Delete
	thumb_func_end ov02_0224DE08

	thumb_func_start ov02_0224DE10
ov02_0224DE10: ; 0x0224DE10
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r0, #0xc8
	ldr r0, [r0]
	add r4, r1, #0
	add r5, r2, #0
	add r6, r3, #0
	cmp r0, #0
	beq _0224DE26
	bl GF_AssertFail
_0224DE26:
	ldr r2, [r4, #4]
	ldr r3, [r4, #8]
	ldr r1, [r4]
	add r0, r7, #0
	add r2, r2, r5
	add r3, r3, r6
	bl Field3dObject_SetPosEx
	add r0, r7, #0
	mov r4, #0
	add r5, r7, #0
	mov r1, #1
	add r0, #0xc8
	str r1, [r0]
	add r5, #0x78
	add r6, r4, #0
_0224DE46:
	add r0, r5, #0
	add r1, r6, #0
	bl Field3dModelAnimation_FrameSet
	add r4, r4, #1
	add r5, #0x14
	cmp r4, #4
	blt _0224DE46
	add r0, r7, #0
	mov r1, #1
	bl Field3dObject_SetActiveFlag
	ldr r0, _0224DE68 ; =SEQ_SE_DP_UG_023
	bl PlaySE
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224DE68: .word SEQ_SE_DP_UG_023
	thumb_func_end ov02_0224DE10

	thumb_func_start ov02_0224DE6C
ov02_0224DE6C: ; 0x0224DE6C
	push {r3, r4, r5, r6, r7, lr}
	str r0, [sp]
	add r0, #0xc8
	ldr r0, [r0]
	cmp r0, #0
	beq _0224DEA6
	ldr r5, [sp]
	mov r4, #1
	mov r6, #0
	add r5, #0x78
	lsl r7, r4, #0xc
_0224DE82:
	add r0, r5, #0
	add r1, r7, #0
	bl Field3dModelAnimation_FrameAdvanceAndCheck
	add r6, r6, #1
	and r4, r0
	add r5, #0x14
	cmp r6, #4
	blt _0224DE82
	cmp r4, #1
	bne _0224DEA6
	ldr r0, [sp]
	mov r1, #0
	add r0, #0xc8
	str r1, [r0]
	ldr r0, [sp]
	bl Field3dObject_SetActiveFlag
_0224DEA6:
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224DE6C

	thumb_func_start ov02_0224DEA8
ov02_0224DEA8: ; 0x0224DEA8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	str r1, [sp]
	str r2, [sp, #4]
	mov r1, #0
	mov r2, #0xcc
	add r7, r0, #0
	add r5, r3, #0
	bl memset
	ldr r1, [sp]
	add r0, r7, #0
	bl Field3dObject_InitFromModel
	add r4, r7, #0
	mov r6, #0
	add r4, #0x78
_0224DECA:
	ldr r1, [sp]
	ldr r2, [r5]
	ldr r3, [sp, #4]
	add r0, r4, #0
	bl ov01_021FBE70
	add r0, r7, #0
	add r1, r4, #0
	bl Field3dObject_AddAnimation
	add r6, r6, #1
	add r5, r5, #4
	add r4, #0x14
	cmp r6, #4
	blt _0224DECA
	add r0, r7, #0
	mov r1, #0
	bl Field3dObject_SetActiveFlag
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224DEA8

	thumb_func_start ov02_0224DEF4
ov02_0224DEF4: ; 0x0224DEF4
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r5, r7, #0
	add r6, r1, #0
	mov r4, #0
	add r5, #0x78
_0224DF00:
	add r0, r5, #0
	add r1, r6, #0
	bl Field3dModelAnimation_Unload
	add r4, r4, #1
	add r5, #0x14
	cmp r4, #4
	blt _0224DF00
	add r0, r7, #0
	mov r1, #0
	mov r2, #0xcc
	bl memset
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224DEF4

	thumb_func_start ov02_0224DF1C
ov02_0224DF1C: ; 0x0224DF1C
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r4, r0, #0
	mov r0, #1
	mov r1, #0x3a
	mov r2, #3
	lsl r0, r0, #0xc
	lsl r1, r1, #6
	str r0, [r4, r1]
	add r0, r1, #4
	lsl r2, r2, #0xc
	sub r1, #8
	str r2, [r4, r0]
	ldr r0, [r4, r1]
	add r1, sp, #0xc
	ldr r0, [r0, #0x40]
	bl PlayerAvatar_CopyPositionVector
	ldr r0, _0224E004 ; =0x00000E9A
	ldrh r1, [r4, r0]
	cmp r1, #0
	beq _0224DFC6
	sub r0, #0x22
	ldr r0, [r4, r0]
	bl FollowMon_GetMapObject
	add r1, sp, #0
	bl MapObject_CopyPositionVector
	mov r5, #0
	add r1, r4, #0
_0224DF5A:
	add r0, r1, #0
	add r0, #0xd8
	ldr r0, [r0]
	cmp r0, #0
	bne _0224DF80
	mov r3, #0x3a
	lsl r3, r3, #6
	add r1, r4, #0
	mov r0, #0xcc
	ldr r2, [r4, r3]
	add r3, r3, #4
	add r1, #0x10
	mul r0, r5
	add r0, r1, r0
	ldr r3, [r4, r3]
	add r1, sp, #0xc
	bl ov02_0224DE10
	b _0224DF88
_0224DF80:
	add r5, r5, #1
	add r1, #0xcc
	cmp r5, #0x12
	blt _0224DF5A
_0224DF88:
	cmp r5, #0x12
	bne _0224DF90
	bl GF_AssertFail
_0224DF90:
	mov r0, #0
	add r2, r4, #0
_0224DF94:
	add r1, r2, #0
	add r1, #0xd8
	ldr r1, [r1]
	cmp r1, #0
	bne _0224DFBC
	add r2, r4, #0
	mov r1, #0xcc
	mov r3, #0x3a
	add r2, #0x10
	mul r1, r0
	add r0, r2, r1
	lsl r3, r3, #6
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r3, [r4, r3]
	add r1, sp, #0
	bl ov02_0224DE10
	add sp, #0x18
	pop {r3, r4, r5, pc}
_0224DFBC:
	add r0, r0, #1
	add r2, #0xcc
	cmp r0, #0x12
	blt _0224DF94
	b _0224DFFA
_0224DFC6:
	mov r0, #0
	add r2, r4, #0
_0224DFCA:
	add r1, r2, #0
	add r1, #0xd8
	ldr r1, [r1]
	cmp r1, #0
	bne _0224DFF2
	add r2, r4, #0
	mov r1, #0xcc
	mov r3, #0x3a
	add r2, #0x10
	mul r1, r0
	add r0, r2, r1
	lsl r3, r3, #6
	ldr r2, [r4, r3]
	add r3, r3, #4
	ldr r3, [r4, r3]
	add r1, sp, #0xc
	bl ov02_0224DE10
	add sp, #0x18
	pop {r3, r4, r5, pc}
_0224DFF2:
	add r0, r0, #1
	add r2, #0xcc
	cmp r0, #0x12
	blt _0224DFCA
_0224DFFA:
	bl GF_AssertFail
	add sp, #0x18
	pop {r3, r4, r5, pc}
	nop
_0224E004: .word 0x00000E9A
	thumb_func_end ov02_0224DF1C

	thumb_func_start ov02_0224E008
ov02_0224E008: ; 0x0224E008
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
	add r5, #0x10
_0224E010:
	add r0, r5, #0
	bl ov02_0224DE6C
	add r4, r4, #1
	add r5, #0xcc
	cmp r4, #0x12
	blt _0224E010
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224E008

	thumb_func_start ov02_0224E020
ov02_0224E020: ; 0x0224E020
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	ldr r0, [r4, #8]
	cmp r0, #0
	beq _0224E032
	cmp r0, #1
	beq _0224E04A
	pop {r3, r4, r5, pc}
_0224E032:
	ldr r1, [r4, #0xc]
	ldr r0, [r4]
	lsl r2, r1, #2
	ldr r1, _0224E06C ; =ov02_02253A34
	ldr r1, [r1, r2]
	blx r1
	cmp r0, #1
	bne _0224E068
	ldr r0, [r4, #8]
	add r0, r0, #1
	str r0, [r4, #8]
	pop {r3, r4, r5, pc}
_0224E04A:
	ldr r1, [r4, #0xc]
	ldr r0, [r4]
	lsl r2, r1, #2
	ldr r1, _0224E070 ; =ov02_02253A04
	ldr r1, [r1, r2]
	blx r1
	ldr r0, [r4, #4]
	mov r1, #1
	strh r1, [r0]
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
_0224E068:
	pop {r3, r4, r5, pc}
	nop
_0224E06C: .word ov02_02253A34
_0224E070: .word ov02_02253A04
	thumb_func_end ov02_0224E020

	thumb_func_start ov02_0224E074
ov02_0224E074: ; 0x0224E074
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	add r5, r1, #0
	add r0, r3, #0
	mov r1, #0x10
	add r4, r2, #0
	bl Heap_Alloc
	add r6, r0, #0
	add r2, r6, #0
	mov r1, #0x10
	mov r0, #0
_0224E08C:
	strb r0, [r2]
	add r2, r2, #1
	sub r1, r1, #1
	bne _0224E08C
	ldr r1, _0224E0B4 ; =ov02_02253A1C
	lsl r2, r4, #2
	ldr r1, [r1, r2]
	add r0, r7, #0
	blx r1
	str r0, [r6]
	str r5, [r6, #4]
	ldr r0, _0224E0B8 ; =ov02_0224E020
	str r4, [r6, #0xc]
	mov r2, #0
	add r1, r6, #0
	strh r2, [r5]
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0224E0B4: .word ov02_02253A1C
_0224E0B8: .word ov02_0224E020
	thumb_func_end ov02_0224E074

	thumb_func_start ov02_0224E0BC
ov02_0224E0BC: ; 0x0224E0BC
	push {r4, lr}
	add r4, r2, #0
	bl ov02_0224E0D4
	add r2, r0, #0
	ldr r1, _0224E0D0 ; =ov02_0224E0EC
	add r0, r4, #0
	bl TaskManager_Call
	pop {r4, pc}
	.balign 4, 0
_0224E0D0: .word ov02_0224E0EC
	thumb_func_end ov02_0224E0BC

	thumb_func_start ov02_0224E0D4
ov02_0224E0D4: ; 0x0224E0D4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #4
	mov r1, #0x20
	bl Heap_AllocAtEnd
	mov r1, #0
	str r1, [r0]
	str r5, [r0, #4]
	str r4, [r0, #8]
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224E0D4

	thumb_func_start ov02_0224E0EC
ov02_0224E0EC: ; 0x0224E0EC
	push {r4, r5, r6, lr}
	add r4, r0, #0
	bl TaskManager_GetFieldSystem
	add r6, r0, #0
	add r0, r4, #0
	bl TaskManager_GetEnvironment
	add r4, r0, #0
	ldr r0, [r4]
	mov r5, #0
	cmp r0, #5
	bls _0224E108
	b _0224E21E
_0224E108:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224E114: ; jump table
	.short _0224E120 - _0224E114 - 2 ; case 0
	.short _0224E130 - _0224E114 - 2 ; case 1
	.short _0224E156 - _0224E114 - 2 ; case 2
	.short _0224E1AA - _0224E114 - 2 ; case 3
	.short _0224E1C6 - _0224E114 - 2 ; case 4
	.short _0224E1F6 - _0224E114 - 2 ; case 5
_0224E120:
	add r0, r6, #0
	bl FollowMon_GetMapObject
	bl MapObject_UnpauseMovement
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
_0224E130:
	ldr r0, [r4, #4]
	bl MapObject_AreBitsSetForMovementScriptInit
	cmp r0, #0
	beq _0224E21E
	ldr r0, [r4, #8]
	bl MapObject_AreBitsSetForMovementScriptInit
	cmp r0, #0
	beq _0224E21E
	add r0, r6, #0
	bl FollowMon_GetMapObject
	bl MapObject_PauseMovement
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _0224E21E
_0224E156:
	ldr r0, [r4, #4]
	bl MapObject_GetXCoord
	str r0, [r4, #0xc]
	ldr r0, [r4, #4]
	bl MapObject_GetZCoord
	str r0, [r4, #0x10]
	ldr r0, [r4, #4]
	bl MapObject_GetFacingDirection
	str r0, [r4, #0x14]
	ldr r0, [r4, #8]
	bl MapObject_GetXCoord
	str r0, [r4, #0x18]
	ldr r0, [r4, #8]
	bl MapObject_GetZCoord
	str r0, [r4, #0x1c]
	add r0, r4, #0
	add r1, r4, #0
	add r0, #0xc
	add r1, #0x18
	bl ov02_0224E224
	add r6, r0, #0
	ldr r0, [r4, #4]
	add r1, r6, #0
	bl MapObject_SetHeldMovement
	add r0, r6, #0
	bl ov02_0224E2D4
	add r1, r0, #0
	ldr r0, [r4, #8]
	bl MapObject_SetHeldMovement
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _0224E21E
_0224E1AA:
	ldr r0, [r4, #4]
	bl MapObject_AreBitsSetForMovementScriptInit
	cmp r0, #0
	beq _0224E21E
	ldr r0, [r4, #8]
	bl MapObject_AreBitsSetForMovementScriptInit
	cmp r0, #0
	beq _0224E21E
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _0224E21E
_0224E1C6:
	ldr r0, [r4, #4]
	bl MapObject_GetFacingDirection
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl ov02_0224E2A0
	add r1, r0, #0
	ldr r0, [r4, #4]
	bl MapObject_SetHeldMovement
	ldr r0, [r4, #0x14]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	bl ov02_0224E26C
	add r1, r0, #0
	ldr r0, [r4, #8]
	bl MapObject_SetHeldMovement
	ldr r0, [r4]
	add r0, r0, #1
	str r0, [r4]
	b _0224E21E
_0224E1F6:
	ldr r0, [r4, #4]
	bl MapObject_AreBitsSetForMovementScriptInit
	cmp r0, #0
	beq _0224E21E
	ldr r0, [r4, #8]
	bl MapObject_AreBitsSetForMovementScriptInit
	cmp r0, #0
	beq _0224E21E
	ldr r0, [r4, #4]
	bl MapObject_ClearHeldMovementIfActive
	ldr r0, [r4, #8]
	bl MapObject_ClearHeldMovementIfActive
	add r0, r4, #0
	mov r5, #1
	bl Heap_Free
_0224E21E:
	add r0, r5, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov02_0224E0EC

	thumb_func_start ov02_0224E224
ov02_0224E224: ; 0x0224E224
	push {r3, r4, r5, lr}
	ldr r5, [r1]
	ldr r3, [r0]
	mov r4, #0xd
	cmp r3, r5
	bne _0224E246
	ldr r1, [r1, #4]
	ldr r0, [r0, #4]
	cmp r0, r1
	ble _0224E23C
	mov r4, #0xc
	b _0224E268
_0224E23C:
	cmp r0, r1
	blt _0224E268
	bl GF_AssertFail
	b _0224E268
_0224E246:
	ldr r2, [r0, #4]
	ldr r0, [r1, #4]
	cmp r2, r0
	bne _0224E264
	cmp r3, r5
	ble _0224E256
	mov r4, #0xe
	b _0224E268
_0224E256:
	cmp r3, r5
	bge _0224E25E
	mov r4, #0xf
	b _0224E268
_0224E25E:
	bl GF_AssertFail
	b _0224E268
_0224E264:
	bl GF_AssertFail
_0224E268:
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224E224

	thumb_func_start ov02_0224E26C
ov02_0224E26C: ; 0x0224E26C
	push {r3, lr}
	cmp r0, #3
	bhi _0224E296
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224E27E: ; jump table
	.short _0224E286 - _0224E27E - 2 ; case 0
	.short _0224E28A - _0224E27E - 2 ; case 1
	.short _0224E28E - _0224E27E - 2 ; case 2
	.short _0224E292 - _0224E27E - 2 ; case 3
_0224E286:
	mov r0, #0
	pop {r3, pc}
_0224E28A:
	mov r0, #1
	pop {r3, pc}
_0224E28E:
	mov r0, #2
	pop {r3, pc}
_0224E292:
	mov r0, #3
	pop {r3, pc}
_0224E296:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224E26C

	thumb_func_start ov02_0224E2A0
ov02_0224E2A0: ; 0x0224E2A0
	push {r3, lr}
	cmp r0, #3
	bhi _0224E2CA
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224E2B2: ; jump table
	.short _0224E2BA - _0224E2B2 - 2 ; case 0
	.short _0224E2BE - _0224E2B2 - 2 ; case 1
	.short _0224E2C2 - _0224E2B2 - 2 ; case 2
	.short _0224E2C6 - _0224E2B2 - 2 ; case 3
_0224E2BA:
	mov r0, #1
	pop {r3, pc}
_0224E2BE:
	mov r0, #0
	pop {r3, pc}
_0224E2C2:
	mov r0, #3
	pop {r3, pc}
_0224E2C6:
	mov r0, #2
	pop {r3, pc}
_0224E2CA:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224E2A0

	thumb_func_start ov02_0224E2D4
ov02_0224E2D4: ; 0x0224E2D4
	push {r3, lr}
	sub r0, #0xc
	cmp r0, #3
	bhi _0224E300
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224E2E8: ; jump table
	.short _0224E2F0 - _0224E2E8 - 2 ; case 0
	.short _0224E2F4 - _0224E2E8 - 2 ; case 1
	.short _0224E2F8 - _0224E2E8 - 2 ; case 2
	.short _0224E2FC - _0224E2E8 - 2 ; case 3
_0224E2F0:
	mov r0, #0xd
	pop {r3, pc}
_0224E2F4:
	mov r0, #0xc
	pop {r3, pc}
_0224E2F8:
	mov r0, #0xf
	pop {r3, pc}
_0224E2FC:
	mov r0, #0xe
	pop {r3, pc}
_0224E300:
	bl GF_AssertFail
	mov r0, #0
	pop {r3, pc}
	thumb_func_end ov02_0224E2D4

	thumb_func_start ov02_0224E308
ov02_0224E308: ; 0x0224E308
	ldr r1, _0224E318 ; =0x00000165
	cmp r0, r1
	bne _0224E312
	mov r0, #1
	bx lr
_0224E312:
	mov r0, #0
	bx lr
	nop
_0224E318: .word 0x00000165
	thumb_func_end ov02_0224E308

/*
 * int ov02_0224E31C(int x, int z) {
 *     int ret  = ((x - 32) / 32) + (((z - 32) / 32) * 3);
 *     if (ret < 0 || ret >= 6) {
 *         ret = 0;
 *     }
 *     return ret;
 * }
 */
	thumb_func_start ov02_0224E31C
ov02_0224E31C: ; 0x0224E31C
	sub r0, #0x20
	asr r2, r0, #4
	lsr r2, r2, #0x1b
	add r2, r0, r2
	sub r1, #0x20
	asr r0, r1, #4
	lsr r0, r0, #0x1b
	add r0, r1, r0
	asr r1, r0, #5
	lsl r0, r1, #1
	asr r2, r2, #5
	add r0, r1, r0
	add r0, r2, r0
	bmi _0224E33C
	cmp r0, #6
	blt _0224E33E
_0224E33C:
	mov r0, #0
_0224E33E:
	bx lr
	thumb_func_end ov02_0224E31C

	thumb_func_start ov02_0224E340
ov02_0224E340: ; 0x0224E340
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetXCoord
	add r4, r0, #0
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetZCoord
	add r1, r0, #0
	add r0, r4, #0
	bl ov02_0224E31C
	pop {r3, r4, r5, pc}
	thumb_func_end ov02_0224E340

	thumb_func_start ov02_0224E35C
ov02_0224E35C: ; 0x0224E35C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x1c
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	bl Save_VarsFlags_Get
	add r6, r0, #0
	ldr r0, [r5, #0xc]
	bl Save_LocalFieldData_Get
	bl LocalFieldData_GetCurrentPosition
	ldr r0, [r5, #0xc]
	bl Save_SafariZone_Get
	add r4, r0, #0
	ldr r0, [r5, #0x20]
	ldr r0, [r0]
	bl ov02_0224E308
	cmp r0, #0
	bne _0224E38E
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E38E:
	add r0, r6, #0
	bl Save_VarsFlags_CheckSafariSysFlag
	cmp r0, #0
	bne _0224E39E
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E39E:
	add r0, r4, #0
	bl sub_0202F620
	cmp r0, #0
	beq _0224E3AE
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E3AE:
	add r0, r4, #0
	bl SafariZone_GetObjectUnlockLevel
	cmp r0, #0
	bne _0224E3BE
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E3BE:
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetFacingDirection
	add r7, r0, #0
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetXCoord
	add r4, r0, #0
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetZCoord
	str r0, [sp, #8]
	add r0, r7, #0
	bl GetDeltaXByFacingDirection
	add r6, r4, r0
	add r0, r7, #0
	bl GetDeltaYByFacingDirection
	ldr r1, [sp, #8]
	add r4, r1, r0
	cmp r6, #0x20
	blt _0224E3F8
	cmp r6, #0x80
	bge _0224E3F8
	cmp r4, #0x20
	blt _0224E3F8
	cmp r4, #0x60
	blt _0224E3FE
_0224E3F8:
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E3FE:
	cmp r6, #0x20
	blt _0224E40E
	cmp r6, #0x80
	bge _0224E40E
	cmp r4, #0x20
	blt _0224E40E
	cmp r4, #0x60
	blt _0224E414
_0224E40E:
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E414:
	ldr r0, [r5, #0x40]
	add r1, sp, #0x10
	bl PlayerAvatar_CopyPositionVector
	add r0, sp, #0xc
	str r0, [sp]
	ldr r1, [sp, #0x14]
	ldr r2, [sp, #0x10]
	ldr r3, [sp, #0x18]
	add r0, r5, #0
	bl sub_02054774
	add r7, r0, #0
	add r0, sp, #0xc
	ldrb r0, [r0]
	cmp r0, #1
	beq _0224E43C
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E43C:
	lsl r0, r4, #4
	add r0, #8
	cmp r0, #0
	ble _0224E458
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	str r0, [sp, #4]
	b _0224E468
_0224E458:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
	str r0, [sp, #4]
_0224E468:
	lsl r0, r6, #4
	add r0, #8
	cmp r0, #0
	ble _0224E482
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _0224E490
_0224E482:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_0224E490:
	bl _ffix
	add r4, r0, #0
	ldr r0, [sp, #4]
	bl _ffix
	add r3, r0, #0
	add r0, sp, #0xc
	str r0, [sp]
	ldr r1, [sp, #0x14]
	add r0, r5, #0
	add r2, r4, #0
	bl sub_02054774
	add r1, sp, #0xc
	ldrb r1, [r1]
	cmp r1, #1
	beq _0224E4BA
	add sp, #0x1c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224E4BA:
	cmp r7, r0
	bne _0224E4C4
	add sp, #0x1c
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_0224E4C4:
	mov r0, #0
	add sp, #0x1c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224E35C

	thumb_func_start ov02_0224E4CC
ov02_0224E4CC: ; 0x0224E4CC
	push {r3, lr}
	cmp r1, #0
	beq _0224E4D6
	mov r0, #0
	pop {r3, pc}
_0224E4D6:
	bl sub_0205BAD0
	pop {r3, pc}
	thumb_func_end ov02_0224E4CC

	thumb_func_start ov02_0224E4DC
ov02_0224E4DC: ; 0x0224E4DC
	push {r3, lr}
	cmp r1, #0
	beq _0224E4E6
	mov r0, #0
	pop {r3, pc}
_0224E4E6:
	bl MetatileBehavior_IsSurfableWater_thunk
	pop {r3, pc}
	thumb_func_end ov02_0224E4DC

	thumb_func_start SafariDecoration_CreateArgs
SafariDecoration_CreateArgs: ; 0x0224E4EC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x2c
	add r5, r0, #0
	add r0, r1, #0
	mov r1, #0x24
	bl Heap_AllocAtEnd
	mov r1, #0
	mov r2, #0x24
	add r4, r0, #0
	bl MI_CpuFill8
	add r0, r5, #0
	bl FieldSystem_GetSaveData
	str r0, [r4]
	mov r0, #0x43
	lsl r0, r0, #2
	add r1, r5, r0
	add r0, r0, #5
	str r1, [r4, #4]
	add r0, r5, r0
	str r0, [r4, #0x20]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetState
	cmp r0, #2
	bne _0224E528
	mov r0, #1
	b _0224E52A
_0224E528:
	mov r0, #0
_0224E52A:
	lsl r0, r0, #0x18
	lsr r6, r0, #0x18
	strb r6, [r4, #0x18]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetFacingDirection
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x10]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetXCoord
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #0x14]
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetZCoord
	lsl r0, r0, #0x10
	asr r7, r0, #0x10
	ldr r0, [r5, #0x40]
	add r1, sp, #0x20
	bl PlayerAvatar_CopyPositionVector
	ldr r0, [sp, #0x14]
	add r1, r7, #0
	bl ov02_0224E31C
	strb r0, [r4, #0x19]
	add r0, sp, #0x18
	str r0, [sp]
	ldr r1, [sp, #0x24]
	ldr r2, [sp, #0x20]
	ldr r3, [sp, #0x28]
	add r0, r5, #0
	bl sub_02054774
	str r0, [sp, #0x24]
	add r1, sp, #0x18
	ldrb r1, [r1]
	cmp r1, #1
	beq _0224E584
	add sp, #0x2c
	add r0, r4, #0
	pop {r4, r5, r6, r7, pc}
_0224E584:
	asr r0, r0, #0xc
	strb r0, [r4, #0x1a]
	ldr r0, [sp, #0x10]
	bl GetDeltaXByFacingDirection
	ldr r1, [sp, #0x14]
	add r0, r1, r0
	strb r0, [r4, #9]
	ldr r0, [sp, #0x10]
	bl GetDeltaYByFacingDirection
	add r0, r7, r0
	strb r0, [r4, #0xb]
	mov r0, #1
	strb r0, [r4, #8]
	ldr r0, [sp, #0x24]
	add r2, r7, #0
	str r0, [sp]
	add r0, sp, #0x1c
	str r0, [sp, #4]
	add r0, sp, #0x18
	add r0, #2
	str r0, [sp, #8]
	str r6, [sp, #0xc]
	ldr r1, [sp, #0x14]
	ldr r3, [sp, #0x10]
	add r0, r5, #0
	bl ov02_0224E828
	cmp r0, #0
	beq _0224E5D4
	add r1, sp, #0x18
	mov r0, #4
	ldrsh r0, [r1, r0]
	strb r0, [r4, #0xd]
	mov r0, #2
	ldrsh r0, [r1, r0]
	strb r0, [r4, #0xf]
	mov r0, #1
	strb r0, [r4, #0xc]
_0224E5D4:
	ldr r0, [sp, #0x24]
	add r2, r7, #0
	str r0, [sp]
	add r0, sp, #0x1c
	str r0, [sp, #4]
	add r0, sp, #0x18
	add r0, #2
	str r0, [sp, #8]
	str r6, [sp, #0xc]
	ldr r1, [sp, #0x14]
	ldr r3, [sp, #0x10]
	add r0, r5, #0
	bl ov02_0224EB48
	cmp r0, #0
	beq _0224E606
	add r1, sp, #0x18
	mov r0, #4
	ldrsh r0, [r1, r0]
	strb r0, [r4, #0x11]
	mov r0, #2
	ldrsh r0, [r1, r0]
	strb r0, [r4, #0x13]
	mov r0, #1
	strb r0, [r4, #0x10]
_0224E606:
	ldr r0, [sp, #0x24]
	add r2, r7, #0
	str r0, [sp]
	add r0, sp, #0x1c
	str r0, [sp, #4]
	add r0, sp, #0x18
	add r0, #2
	str r0, [sp, #8]
	str r6, [sp, #0xc]
	ldr r1, [sp, #0x14]
	ldr r3, [sp, #0x10]
	add r0, r5, #0
	bl ov02_0224EE4C
	cmp r0, #0
	beq _0224E638
	add r1, sp, #0x18
	mov r0, #4
	ldrsh r0, [r1, r0]
	strb r0, [r4, #0x15]
	mov r0, #2
	ldrsh r0, [r1, r0]
	strb r0, [r4, #0x17]
	mov r0, #1
	strb r0, [r4, #0x14]
_0224E638:
	add r0, r4, #0
	add sp, #0x2c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end SafariDecoration_CreateArgs

	thumb_func_start ov02_0224E640
ov02_0224E640: ; 0x0224E640
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl Save_PlayerData_GetProfile
	bl PlayerProfile_GetTrainerID
	add r5, r0, #0
	add r0, r4, #0
	bl Save_SafariZone_Get
	bl SafariZone_GetObjectUnlockLevel
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #0xa
	bl _u32_div_f
	lsl r0, r1, #0x18
	lsr r0, r0, #0x18
	cmp r0, #6
	bhs _0224E672
	mov r1, #3
	bl _s32_div_f
	b _0224E67C
_0224E672:
	sub r1, r0, #6
	lsr r0, r1, #0x1f
	add r0, r1, r0
	asr r0, r0, #1
	add r0, r0, #2
_0224E67C:
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	mov r0, #3
	sub r0, r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	add r0, r0, #1
	cmp r4, r0
	blt _0224E692
	mov r0, #1
	pop {r3, r4, r5, pc}
_0224E692:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov02_0224E640

	thumb_func_start ov02_0224E698
ov02_0224E698: ; 0x0224E698
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetFacingDirection
	lsl r0, r0, #0x18
	lsr r7, r0, #0x18
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetXCoord
	lsl r0, r0, #0x10
	asr r6, r0, #0x10
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetZCoord
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	ldr r0, [r5, #0x40]
	add r1, sp, #0x14
	bl PlayerAvatar_CopyPositionVector
	ldr r0, [r5, #0xc]
	bl Save_SafariZone_Get
	mov r1, #0
	bl SafariZone_GetAreaSet
	add r2, r0, #0
	add r0, r6, #0
	sub r0, #0x20
	asr r1, r0, #4
	lsr r1, r1, #0x1b
	add r1, r0, r1
	add r0, r4, #0
	sub r0, #0x20
	asr r3, r0, #4
	lsr r3, r3, #0x1b
	add r3, r0, r3
	asr r3, r3, #5
	lsl r0, r3, #1
	asr r1, r1, #5
	add r0, r3, r0
	add r0, r1, r0
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	mov r0, #0x7a
	mul r0, r1
	add r0, r2, r0
	ldrb r0, [r0, #1]
	cmp r0, #0x1e
	blo _0224E706
	add sp, #0x20
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0224E706:
	ldr r0, [r5, #0x40]
	bl PlayerAvatar_GetState
	cmp r0, #2
	beq _0224E716
	add sp, #0x20
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224E716:
	ldr r0, [r5, #0xc]
	bl ov02_0224E640
	cmp r0, #0
	bne _0224E726
	add sp, #0x20
	mov r0, #2
	pop {r3, r4, r5, r6, r7, pc}
_0224E726:
	ldr r0, [sp, #0x18]
	add r1, r6, #0
	str r0, [sp]
	add r0, sp, #0x10
	add r0, #2
	str r0, [sp, #4]
	add r0, sp, #0x10
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r2, r4, #0
	add r3, r7, #0
	bl ov02_0224EE4C
	cmp r0, #0
	beq _0224E74E
	add sp, #0x20
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224E74E:
	mov r0, #3
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224E698

	thumb_func_start ov02_0224E754
ov02_0224E754: ; 0x0224E754
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r0, [r4, #0x40]
	str r1, [sp]
	bl PlayerAvatar_GetFacingDirection
	add r6, r0, #0
	ldr r0, [r4, #0x40]
	bl PlayerAvatar_GetXCoord
	add r5, r0, #0
	add r0, r6, #0
	bl GetDeltaXByFacingDirection
	add r7, r5, r0
	ldr r0, [r4, #0x40]
	bl PlayerAvatar_GetZCoord
	add r5, r0, #0
	add r0, r6, #0
	bl GetDeltaYByFacingDirection
	add r6, r5, r0
	ldr r0, [r4, #0xc]
	bl Save_PlayerData_GetProfile
	bl PlayerProfile_GetTrainerGender
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #4]
	add r0, r7, #0
	add r1, r6, #0
	bl ov02_0224E31C
	add r5, r0, #0
	lsr r1, r7, #0x1f
	lsl r0, r7, #0x1b
	sub r0, r0, r1
	mov r2, #0x1b
	ror r0, r2
	add r7, r1, r0
	lsr r1, r6, #0x1f
	lsl r0, r6, #0x1b
	sub r0, r0, r1
	ror r0, r2
	add r6, r1, r0
	ldr r0, [r4, #0xc]
	bl Save_SafariZone_Get
	mov r1, #0
	bl SafariZone_GetAreaSet
	mov r1, #0x7a
	mul r1, r5
	add r0, r0, r1
	str r0, [sp, #8]
	ldrb r0, [r0, #1]
	mov r4, #0
	cmp r0, #0
	ble _0224E81C
	ldr r0, [sp, #8]
	add r5, r0, #2
_0224E7D4:
	ldrb r1, [r5]
	ldr r2, [sp, #4]
	add r0, sp, #0xc
	bl GetSafariObjectConfig
	ldrb r1, [r5, #1]
	cmp r7, r1
	blt _0224E810
	ldrb r0, [r5, #3]
	cmp r6, r0
	bgt _0224E810
	add r2, sp, #0xc
	ldrb r2, [r2, #1]
	lsl r3, r2, #0x1c
	lsr r3, r3, #0x1d
	add r1, r1, r3
	cmp r7, r1
	bge _0224E810
	lsl r1, r2, #0x19
	lsr r1, r1, #0x1d
	sub r0, r0, r1
	cmp r6, r0
	ble _0224E810
	ldr r0, [sp]
	cmp r0, #0
	beq _0224E80A
	strh r4, [r0]
_0224E80A:
	add sp, #0x10
	ldrb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_0224E810:
	ldr r0, [sp, #8]
	add r4, r4, #1
	ldrb r0, [r0, #1]
	add r5, r5, #4
	cmp r4, r0
	blt _0224E7D4
_0224E81C:
	ldr r0, [sp]
	mov r1, #0
	strh r1, [r0]
	mov r0, #0xff
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov02_0224E754

	thumb_func_start ov02_0224E828
ov02_0224E828: ; 0x0224E828
	push {r4, r5, r6, r7, lr}
	sub sp, #0x6c
	add r4, r0, #0
	add r5, r1, #0
	ldr r0, [sp, #0x84]
	str r2, [sp, #4]
	ldr r1, _0224EB44 ; =ov02_02253A4C
	str r0, [sp, #0x84]
	ldr r0, [sp, #0x88]
	ldrb r2, [r1, #2]
	str r0, [sp, #0x88]
	ldrb r1, [r1, #3]
	str r3, [sp, #8]
	add r0, sp, #0x68
	strb r2, [r0, #1]
	strb r1, [r0, #2]
	ldr r1, [sp, #0x84]
	ldr r6, [sp, #0x80]
	strh r5, [r1]
	ldr r2, [sp, #4]
	ldr r1, [sp, #0x88]
	strh r2, [r1]
	ldr r1, [sp, #8]
	cmp r1, #3
	bls _0224E85C
	b _0224EB3E
_0224E85C:
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0224E868: ; jump table
	.short _0224E870 - _0224E868 - 2 ; case 0
	.short _0224E870 - _0224E868 - 2 ; case 1
	.short _0224E992 - _0224E868 - 2 ; case 2
	.short _0224E992 - _0224E868 - 2 ; case 3
_0224E870:
	mov r0, #0
	str r0, [sp, #0x50]
	ldr r0, [sp, #8]
	cmp r0, #0
	beq _0224E87E
	mov r0, #1
	b _0224E880
_0224E87E:
	ldr r0, [sp, #0x50]
_0224E880:
	lsl r0, r0, #0x18
	lsr r1, r0, #0x18
	mov r0, #0
	str r0, [sp, #0x54]
	add r0, sp, #0x68
	add r0, #1
	ldrsb r0, [r0, r1]
	ldr r7, [sp, #0x54]
	str r0, [sp, #0x38]
	add r0, sp, #0x70
	ldrb r0, [r0, #0x1c]
	str r0, [sp, #0x48]
	lsl r0, r5, #4
	str r0, [sp, #0x44]
	add r0, #8
	str r0, [sp, #0x44]
	lsl r0, r0, #0xc
	str r0, [sp, #0x40]
_0224E8A4:
	ldr r0, [sp, #0x38]
	add r1, r7, r0
	ldr r0, [sp, #4]
	add r0, r0, r1
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #0x3c]
	ldr r2, [sp, #0x3c]
	add r0, r4, #0
	add r1, r5, #0
	bl GetMetatileBehavior
	str r0, [sp, #0x58]
	ldr r2, [sp, #0x3c]
	add r0, r4, #0
	add r1, r5, #0
	bl sub_020548C0
	add r1, r0, #0
	ldr r0, [sp, #0x58]
	ldr r2, [sp, #0x48]
	bl ov02_0224EF6C
	cmp r0, #0
	beq _0224E95C
	ldr r0, [sp, #0x3c]
	lsl r0, r0, #4
	add r0, #8
	cmp r0, #0
	ble _0224E8F4
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	str r0, [sp, #0x14]
	b _0224E904
_0224E8F4:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
	str r0, [sp, #0x14]
_0224E904:
	ldr r0, [sp, #0x44]
	cmp r0, #0
	ble _0224E91C
	ldr r0, [sp, #0x40]
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _0224E92A
_0224E91C:
	ldr r0, [sp, #0x40]
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_0224E92A:
	bl _ffix
	str r0, [sp, #0x5c]
	ldr r0, [sp, #0x14]
	bl _ffix
	add r3, r0, #0
	add r0, sp, #0x68
	str r0, [sp]
	ldr r2, [sp, #0x5c]
	add r0, r4, #0
	add r1, r6, #0
	bl sub_02054774
	add r1, sp, #0x68
	ldrb r1, [r1]
	cmp r1, #1
	bne _0224E95C
	cmp r0, r6
	bne _0224E95C
	ldr r0, [sp, #0x50]
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x50]
_0224E95C:
	ldr r0, [sp, #0x38]
	add r7, r7, r0
	ldr r0, [sp, #0x54]
	add r0, r0, #1
	str r0, [sp, #0x54]
	cmp r0, #2
	blt _0224E8A4
	ldr r0, [sp, #0x50]
	cmp r0, #2
	beq _0224E972
	b _0224EB3E
_0224E972:
	ldr r0, [sp, #0x84]
	strh r5, [r0]
	ldr r0, [sp, #8]
	cmp r0, #0
	bne _0224E984
	ldr r0, [sp, #4]
	sub r1, r0, #1
	ldr r0, [sp, #0x88]
	b _0224E98A
_0224E984:
	ldr r0, [sp, #4]
	add r1, r0, #2
	ldr r0, [sp, #0x88]
_0224E98A:
	strh r1, [r0]
	add sp, #0x6c
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_0224E992:
	ldr r1, [sp, #8]
	cmp r1, #2
	bne _0224E99C
	mov r1, #1
	b _0224E99E
_0224E99C:
	mov r1, #2
_0224E99E:
	ldrsb r0, [r0, r1]
	ldr r2, [sp, #4]
	add r0, r5, r0
	lsl r0, r0, #0x10
	asr r5, r0, #0x10
	add r0, r4, #0
	add r1, r5, #0
	bl GetMetatileBehavior
	str r0, [sp, #0x20]
	ldr r2, [sp, #4]
	add r0, r4, #0
	add r1, r5, #0
	bl sub_020548C0
	str r0, [sp, #0x18]
	ldr r0, [sp, #4]
	lsl r0, r0, #4
	add r0, #8
	cmp r0, #0
	ble _0224E9DC
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	str r0, [sp, #0x10]
	b _0224E9EC
_0224E9DC:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
	str r0, [sp, #0x10]
_0224E9EC:
	lsl r0, r5, #4
	str r0, [sp, #0x2c]
	add r0, #8
	str r0, [sp, #0x2c]
	cmp r0, #0
	ble _0224EA0A
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _0224EA18
_0224EA0A:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_0224EA18:
	bl _ffix
	add r7, r0, #0
	ldr r0, [sp, #0x10]
	bl _ffix
	add r3, r0, #0
	add r0, sp, #0x68
	str r0, [sp]
	add r0, r4, #0
	add r1, r6, #0
	add r2, r7, #0
	bl sub_02054774
	add r7, r0, #0
	add r0, sp, #0x70
	ldrb r0, [r0, #0x1c]
	ldr r1, [sp, #0x18]
	str r0, [sp, #0x34]
	ldr r0, [sp, #0x20]
	ldr r2, [sp, #0x34]
	bl ov02_0224EF6C
	cmp r0, #0
	beq _0224EA56
	add r0, sp, #0x68
	ldrb r0, [r0]
	cmp r0, #1
	bne _0224EA56
	cmp r7, r6
	beq _0224EA5C
_0224EA56:
	add sp, #0x6c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0224EA5C:
	mov r0, #0
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x2c]
	add r7, sp, #0x68
	lsl r0, r0, #0xc
	add r7, #1
	str r0, [sp, #0x4c]
_0224EA6A:
	mov r0, #0
	ldrsb r1, [r7, r0]
	ldr r0, [sp, #4]
	add r0, r0, r1
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #0x30]
	ldr r2, [sp, #0x30]
	add r0, r4, #0
	add r1, r5, #0
	bl GetMetatileBehavior
	str r0, [sp, #0x24]
	ldr r2, [sp, #0x30]
	add r0, r4, #0
	add r1, r5, #0
	bl sub_020548C0
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x30]
	lsl r0, r0, #4
	add r0, #8
	cmp r0, #0
	ble _0224EAAE
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	str r0, [sp, #0xc]
	b _0224EABE
_0224EAAE:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
	str r0, [sp, #0xc]
_0224EABE:
	ldr r0, [sp, #0x2c]
	cmp r0, #0
	ble _0224EAD6
	ldr r0, [sp, #0x4c]
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _0224EAE4
_0224EAD6:
	ldr r0, [sp, #0x4c]
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_0224EAE4:
	bl _ffix
	str r0, [sp, #0x60]
	ldr r0, [sp, #0xc]
	bl _ffix
	add r3, r0, #0
	add r0, sp, #0x68
	str r0, [sp]
	ldr r2, [sp, #0x60]
	add r0, r4, #0
	add r1, r6, #0
	bl sub_02054774
	str r0, [sp, #0x64]
	ldr r0, [sp, #0x24]
	ldr r1, [sp, #0x1c]
	ldr r2, [sp, #0x34]
	bl ov02_0224EF6C
	cmp r0, #0
	beq _0224EB32
	add r0, sp, #0x68
	ldrb r0, [r0]
	cmp r0, #1
	bne _0224EB32
	ldr r0, [sp, #0x64]
	cmp r0, r6
	bne _0224EB32
	ldr r0, [sp, #0x84]
	strh r5, [r0]
	ldr r1, [sp, #4]
	ldr r0, [sp, #0x28]
	add r1, r1, r0
	ldr r0, [sp, #0x88]
	add sp, #0x6c
	strh r1, [r0]
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_0224EB32:
	ldr r0, [sp, #0x28]
	add r7, r7, #1
	add r0, r0, #1
	str r0, [sp, #0x28]
	cmp r0, #2
	blt _0224EA6A
_0224EB3E:
	mov r0, #0
	add sp, #0x6c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0224EB44: .word ov02_02253A4C
	thumb_func_end ov02_0224E828

	thumb_func_start ov02_0224EB48
ov02_0224EB48: ; 0x0224EB48
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x68
	add r4, r0, #0
	ldr r0, [sp, #0x84]
	str r1, [sp, #4]
	str r0, [sp, #0x84]
	ldr r0, [sp, #0x88]
	ldr r1, _0224EE48 ; =ov02_02253A4C
	str r0, [sp, #0x88]
	add r5, r2, #0
	add r2, r3, #0
	ldrb r0, [r1]
	add r3, sp, #0x64
	ldr r6, [sp, #0x80]
	strb r0, [r3, #1]
	ldrb r0, [r1, #1]
	cmp r2, #3
	strb r0, [r3, #2]
	ldr r1, [sp, #4]
	ldr r0, [sp, #0x84]
	strh r1, [r0]
	ldr r0, [sp, #0x88]
	strh r5, [r0]
	bls _0224EB7A
	b _0224EE42
_0224EB7A:
	add r0, r2, r2
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224EB86: ; jump table
	.short _0224EB8E - _0224EB86 - 2 ; case 0
	.short _0224EB8E - _0224EB86 - 2 ; case 1
	.short _0224ED3A - _0224EB86 - 2 ; case 2
	.short _0224ED3A - _0224EB86 - 2 ; case 3
_0224EB8E:
	cmp r2, #0
	bne _0224EB96
	mov r0, #1
	b _0224EB98
_0224EB96:
	mov r0, #2
_0224EB98:
	ldrsb r0, [r3, r0]
	ldr r1, [sp, #4]
	add r0, r5, r0
	lsl r0, r0, #0x10
	asr r5, r0, #0x10
	add r0, r4, #0
	add r2, r5, #0
	bl GetMetatileBehavior
	str r0, [sp, #0x50]
	ldr r1, [sp, #4]
	add r0, r4, #0
	add r2, r5, #0
	bl sub_020548C0
	str r0, [sp, #0x4c]
	lsl r0, r5, #4
	str r0, [sp, #0x24]
	add r0, #8
	str r0, [sp, #0x24]
	cmp r0, #0
	ble _0224EBD8
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	str r0, [sp, #0x14]
	b _0224EBE8
_0224EBD8:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
	str r0, [sp, #0x14]
_0224EBE8:
	ldr r0, [sp, #4]
	lsl r0, r0, #4
	add r0, #8
	cmp r0, #0
	ble _0224EC04
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _0224EC12
_0224EC04:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_0224EC12:
	bl _ffix
	add r7, r0, #0
	ldr r0, [sp, #0x14]
	bl _ffix
	add r3, r0, #0
	add r0, sp, #0x64
	str r0, [sp]
	add r0, r4, #0
	add r1, r6, #0
	add r2, r7, #0
	bl sub_02054774
	add r7, r0, #0
	add r0, sp, #0x70
	ldrb r0, [r0, #0x1c]
	ldr r1, [sp, #0x4c]
	str r0, [sp, #0x30]
	ldr r0, [sp, #0x50]
	ldr r2, [sp, #0x30]
	bl ov02_0224EF6C
	cmp r0, #0
	beq _0224EC50
	add r0, sp, #0x64
	ldrb r0, [r0]
	cmp r0, #1
	bne _0224EC50
	cmp r7, r6
	beq _0224EC56
_0224EC50:
	add sp, #0x68
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224EC56:
	mov r0, #0
	str r0, [sp, #0x48]
	ldr r0, [sp, #0x24]
	add r7, sp, #0x64
	lsl r0, r0, #0xc
	add r7, #1
	str r0, [sp, #0x34]
_0224EC64:
	mov r0, #0
	ldrsb r1, [r7, r0]
	ldr r0, [sp, #4]
	add r2, r5, #0
	sub r0, r0, r1
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #0x2c]
	ldr r1, [sp, #0x2c]
	add r0, r4, #0
	bl GetMetatileBehavior
	str r0, [sp, #0x20]
	ldr r1, [sp, #0x2c]
	add r0, r4, #0
	add r2, r5, #0
	bl sub_020548C0
	str r0, [sp, #0x1c]
	ldr r0, [sp, #0x24]
	cmp r0, #0
	ble _0224ECA4
	ldr r0, [sp, #0x34]
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	str r0, [sp, #0x10]
	b _0224ECB4
_0224ECA4:
	ldr r0, [sp, #0x34]
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
	str r0, [sp, #0x10]
_0224ECB4:
	ldr r0, [sp, #0x2c]
	lsl r0, r0, #4
	add r0, #8
	cmp r0, #0
	ble _0224ECD0
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _0224ECDE
_0224ECD0:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_0224ECDE:
	bl _ffix
	str r0, [sp, #0x54]
	ldr r0, [sp, #0x10]
	bl _ffix
	add r3, r0, #0
	add r0, sp, #0x64
	str r0, [sp]
	ldr r2, [sp, #0x54]
	add r0, r4, #0
	add r1, r6, #0
	bl sub_02054774
	str r0, [sp, #0x58]
	ldr r0, [sp, #0x20]
	ldr r1, [sp, #0x1c]
	ldr r2, [sp, #0x30]
	bl ov02_0224EF6C
	cmp r0, #0
	beq _0224ED2C
	add r0, sp, #0x64
	ldrb r0, [r0]
	cmp r0, #1
	bne _0224ED2C
	ldr r0, [sp, #0x58]
	cmp r0, r6
	bne _0224ED2C
	ldr r1, [sp, #4]
	ldr r0, [sp, #0x48]
	sub r1, r1, r0
	ldr r0, [sp, #0x84]
	strh r1, [r0]
	ldr r0, [sp, #0x88]
	add sp, #0x68
	strh r5, [r0]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0224ED2C:
	ldr r0, [sp, #0x48]
	add r7, r7, #1
	add r0, r0, #1
	str r0, [sp, #0x48]
	cmp r0, #2
	blt _0224EC64
	b _0224EE42
_0224ED3A:
	mov r0, #0
	str r0, [sp, #0x44]
	cmp r2, #2
	bne _0224ED4E
	ldr r0, [sp, #4]
	sub r0, r0, #2
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #0xc]
	b _0224ED58
_0224ED4E:
	ldr r0, [sp, #4]
	add r0, r0, #1
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #0xc]
_0224ED58:
	mov r0, #0
	str r0, [sp, #0x18]
	add r0, sp, #0x70
	ldrb r0, [r0, #0x1c]
	ldr r7, [sp, #0xc]
	str r0, [sp, #0x40]
	lsl r0, r5, #4
	str r0, [sp, #0x3c]
	add r0, #8
	str r0, [sp, #0x3c]
	lsl r0, r0, #0xc
	str r0, [sp, #0x38]
_0224ED70:
	lsl r0, r7, #0x10
	asr r0, r0, #0x10
	str r0, [sp, #0x28]
	ldr r1, [sp, #0x28]
	add r0, r4, #0
	add r2, r5, #0
	bl GetMetatileBehavior
	str r0, [sp, #0x5c]
	ldr r1, [sp, #0x28]
	add r0, r4, #0
	add r2, r5, #0
	bl sub_020548C0
	add r1, r0, #0
	ldr r0, [sp, #0x5c]
	ldr r2, [sp, #0x40]
	bl ov02_0224EF6C
	cmp r0, #0
	beq _0224EE20
	ldr r0, [sp, #0x3c]
	cmp r0, #0
	ble _0224EDB4
	ldr r0, [sp, #0x38]
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	str r0, [sp, #8]
	b _0224EDC4
_0224EDB4:
	ldr r0, [sp, #0x38]
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
	str r0, [sp, #8]
_0224EDC4:
	ldr r0, [sp, #0x28]
	lsl r0, r0, #4
	add r0, #8
	cmp r0, #0
	ble _0224EDE0
	lsl r0, r0, #0xc
	bl _fflt
	add r1, r0, #0
	mov r0, #0x3f
	lsl r0, r0, #0x18
	bl _fadd
	b _0224EDEE
_0224EDE0:
	lsl r0, r0, #0xc
	bl _fflt
	mov r1, #0x3f
	lsl r1, r1, #0x18
	bl _fsub
_0224EDEE:
	bl _ffix
	str r0, [sp, #0x60]
	ldr r0, [sp, #8]
	bl _ffix
	add r3, r0, #0
	add r0, sp, #0x64
	str r0, [sp]
	ldr r2, [sp, #0x60]
	add r0, r4, #0
	add r1, r6, #0
	bl sub_02054774
	add r1, sp, #0x64
	ldrb r1, [r1]
	cmp r1, #1
	bne _0224EE20
	cmp r0, r6
	bne _0224EE20
	ldr r0, [sp, #0x44]
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x44]
_0224EE20:
	ldr r0, [sp, #0x18]
	add r7, r7, #1
	add r0, r0, #1
	str r0, [sp, #0x18]
	cmp r0, #2
	blt _0224ED70
	ldr r0, [sp, #0x44]
	cmp r0, #2
	bne _0224EE42
	ldr r1, [sp, #0xc]
	ldr r0, [sp, #0x84]
	strh r1, [r0]
	ldr r0, [sp, #0x88]
	add sp, #0x68
	strh r5, [r0]
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0224EE42:
	mov r0, #0
	add sp, #0x68
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0224EE48: .word ov02_02253A4C
	thumb_func_end ov02_0224EB48

	thumb_func_start ov02_0224EE4C
ov02_0224EE4C: ; 0x0224EE4C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	str r1, [sp, #0x14]
	str r2, [sp, #0x18]
	ldr r4, [sp, #0x38]
	str r3, [sp, #0x1c]
	str r4, [sp, #0x38]
	ldr r4, [sp, #0x44]
	ldr r6, [sp, #0x3c]
	str r4, [sp, #0x44]
	ldr r4, _0224EF68 ; =ov02_02253A4C
	ldr r7, [sp, #0x40]
	ldrb r5, [r4, #4]
	add r4, sp, #0x20
	str r0, [sp, #0x10]
	strb r5, [r4]
	ldr r4, _0224EF68 ; =ov02_02253A4C
	ldrb r5, [r4, #5]
	add r4, sp, #0x20
	strb r5, [r4, #1]
	ldr r4, [sp, #0x14]
	strh r4, [r6]
	ldr r4, [sp, #0x18]
	strh r4, [r7]
	ldr r4, [sp, #0x1c]
	cmp r4, #3
	bhi _0224EF60
	add r4, r4, r4
	add r4, pc
	ldrh r4, [r4, #6]
	lsl r4, r4, #0x10
	asr r4, r4, #0x10
	add pc, r4
_0224EE8E: ; jump table
	.short _0224EE96 - _0224EE8E - 2 ; case 0
	.short _0224EE96 - _0224EE8E - 2 ; case 1
	.short _0224EEFC - _0224EE8E - 2 ; case 2
	.short _0224EEFC - _0224EE8E - 2 ; case 3
_0224EE96:
	ldr r4, [sp, #0x38]
	str r4, [sp]
	str r6, [sp, #4]
	str r7, [sp, #8]
	ldr r4, [sp, #0x44]
	str r4, [sp, #0xc]
	bl ov02_0224E828
	cmp r0, #0
	beq _0224EF60
	mov r4, #0
	add r5, sp, #0x20
_0224EEAE:
	ldr r0, [sp, #0x38]
	mov r1, #0
	str r0, [sp]
	str r6, [sp, #4]
	str r7, [sp, #8]
	ldr r0, [sp, #0x44]
	str r0, [sp, #0xc]
	ldrsb r2, [r5, r1]
	ldr r1, [sp, #0x14]
	ldr r0, [sp, #0x10]
	add r1, r1, r2
	lsl r1, r1, #0x10
	ldr r2, [sp, #0x18]
	ldr r3, [sp, #0x1c]
	asr r1, r1, #0x10
	bl ov02_0224E828
	cmp r0, #0
	beq _0224EEF2
	ldr r0, [sp, #0x14]
	sub r0, r0, r4
	strh r0, [r6]
	ldr r0, [sp, #0x1c]
	cmp r0, #0
	bne _0224EEE6
	ldr r0, [sp, #0x18]
	sub r0, r0, #1
	b _0224EEEA
_0224EEE6:
	ldr r0, [sp, #0x18]
	add r0, r0, #2
_0224EEEA:
	add sp, #0x24
	strh r0, [r7]
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_0224EEF2:
	add r4, r4, #1
	add r5, r5, #1
	cmp r4, #2
	blt _0224EEAE
	b _0224EF60
_0224EEFC:
	ldr r4, [sp, #0x38]
	str r4, [sp]
	str r6, [sp, #4]
	str r7, [sp, #8]
	ldr r4, [sp, #0x44]
	str r4, [sp, #0xc]
	bl ov02_0224EB48
	cmp r0, #0
	beq _0224EF60
	mov r5, #0
	add r4, sp, #0x20
_0224EF14:
	ldr r0, [sp, #0x38]
	mov r2, #0
	str r0, [sp]
	str r6, [sp, #4]
	str r7, [sp, #8]
	ldr r0, [sp, #0x44]
	str r0, [sp, #0xc]
	ldrsb r3, [r4, r2]
	ldr r2, [sp, #0x18]
	ldr r0, [sp, #0x10]
	sub r2, r2, r3
	lsl r2, r2, #0x10
	ldr r1, [sp, #0x14]
	ldr r3, [sp, #0x1c]
	asr r2, r2, #0x10
	bl ov02_0224EB48
	cmp r0, #0
	beq _0224EF58
	ldr r0, [sp, #0x1c]
	cmp r0, #2
	bne _0224EF46
	ldr r0, [sp, #0x14]
	sub r0, r0, #2
	b _0224EF4A
_0224EF46:
	ldr r0, [sp, #0x14]
	add r0, r0, #1
_0224EF4A:
	strh r0, [r6]
	ldr r0, [sp, #0x18]
	add sp, #0x24
	add r0, r0, r5
	strh r0, [r7]
	mov r0, #1
	pop {r4, r5, r6, r7, pc}
_0224EF58:
	add r5, r5, #1
	add r4, r4, #1
	cmp r5, #2
	blt _0224EF14
_0224EF60:
	mov r0, #0
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	nop
_0224EF68: .word ov02_02253A4C
	thumb_func_end ov02_0224EE4C

	thumb_func_start ov02_0224EF6C
ov02_0224EF6C: ; 0x0224EF6C
	push {r3, lr}
	cmp r2, #0
	bne _0224EF78
	bl ov02_0224E4CC
	pop {r3, pc}
_0224EF78:
	bl ov02_0224E4DC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov02_0224EF6C

	thumb_func_start FieldSystem_FollowMonInteract
FieldSystem_FollowMonInteract: ; 0x0224EF80
	ldr r3, _0224EF8C ; =TaskManager_Call
	ldr r0, [r0, #0x10]
	ldr r1, _0224EF90 ; =Task_FollowMonInteract
	mov r2, #0
	bx r3
	nop
_0224EF8C: .word TaskManager_Call
_0224EF90: .word Task_FollowMonInteract
	thumb_func_end FieldSystem_FollowMonInteract

	thumb_func_start ov02_0224EF94
ov02_0224EF94: ; 0x0224EF94
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x1b0
	add r7, r0, #0
	ldr r0, [r7, #0x20]
	ldr r0, [r0]
	bl MapHeader_GetMapSec
	add r2, r0, #0
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r7, r0]
	mov r1, #0xde
	add r0, #0x14
	add r2, r2, #1
	bl ReadWholeNarcMemberByIdPair
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r7, r0]
	mov r0, #0x9b
	lsl r0, r0, #2
	add r0, r1, r0
	mov r1, #0xde
	mov r2, #0
	bl ReadWholeNarcMemberByIdPair
	add r0, r7, #0
	add r1, sp, #4
	bl ov02_0224F058
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r0, [r7, r0]
	add r3, sp, #0x20
	str r0, [sp]
	add r0, #0x14
	str r0, [sp]
	mov r0, #0
	add r2, r0, #0
_0224EFE2:
	add r1, r2, #0
	add r1, #0x1e
	add r2, r2, #1
	add r0, r0, #1
	stmia r3!, {r1}
	cmp r2, #0xc
	blt _0224EFE2
	add r2, sp, #0x20
	lsl r1, r0, #2
	mov r3, #0
	add r1, r2, r1
_0224EFF8:
	stmia r1!, {r3}
	add r3, r3, #1
	add r0, r0, #1
	cmp r3, #0x1e
	blt _0224EFF8
	add r2, sp, #0x20
	lsl r1, r0, #2
	mov r3, #0x2a
	add r1, r2, r1
_0224F00A:
	stmia r1!, {r3}
	add r3, r3, #1
	add r0, r0, #1
	cmp r3, #0x64
	blt _0224F00A
	mov r5, #0
	add r4, sp, #0x20
_0224F018:
	ldr r1, [r4]
	mov r0, #0x14
	add r2, r1, #0
	mul r2, r0
	ldr r0, [sp]
	add r6, r0, r2
	ldrh r0, [r6, #0xa]
	lsl r0, r0, #0x10
	lsr r0, r0, #0x16
	beq _0224F044
	add r0, r7, #0
	add r1, r6, #0
	add r2, sp, #4
	bl ov02_0224F108
	cmp r0, #0
	beq _0224F044
	ldrh r0, [r6, #0xa]
	add sp, #0x1b0
	lsl r0, r0, #0x10
	lsr r0, r0, #0x16
	pop {r3, r4, r5, r6, r7, pc}
_0224F044:
	add r5, r5, #1
	add r4, r4, #4
	cmp r5, #0x64
	blt _0224F018
	bl GF_AssertFail
	mov r0, #0
	add sp, #0x1b0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224EF94

	thumb_func_start ov02_0224F058
ov02_0224F058: ; 0x0224F058
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	add r4, r1, #0
	bl SaveArray_Party_Get
	bl GetFirstAliveMonInParty_CrashIfNone
	mov r1, #5
	mov r2, #0
	add r6, r0, #0
	bl GetMonData
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r2, [r5, r1]
	ldr r1, _0224F100 ; =0x0000087E
	strh r0, [r2, r1]
	add r0, r6, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	mov r1, #0x12
	lsl r1, r1, #4
	ldr r2, [r5, r1]
	ldr r1, _0224F104 ; =0x0000087D
	strb r0, [r2, r1]
	add r0, r6, #0
	add r1, r4, #0
	bl ov02_0224F324
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F4BC
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F580
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F5D0
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F5FC
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F644
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F64C
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F698
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r3, [r5, r0]
	ldr r2, _0224F100 ; =0x0000087E
	add r0, r5, #0
	ldrh r1, [r3, r2]
	sub r2, r2, #1
	ldrb r2, [r3, r2]
	add r3, r4, #0
	bl ov02_0224F6AC
	add r0, r5, #0
	add r1, r4, #0
	bl ov02_0224F728
	mov r0, #0x12
	lsl r0, r0, #4
	ldr r1, [r5, r0]
	ldr r0, _0224F100 ; =0x0000087E
	ldrh r0, [r1, r0]
	add r1, r4, #0
	bl ov02_0224F76C
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224F100: .word 0x0000087E
_0224F104: .word 0x0000087D
	thumb_func_end ov02_0224F058

	thumb_func_start ov02_0224F108
ov02_0224F108: ; 0x0224F108
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r5, r1, #0
	add r4, r2, #0
	bl LCRandom
	mov r1, #0x64
	bl _s32_div_f
	ldrb r0, [r5, #0x11]
	cmp r1, r0
	blt _0224F124
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F124:
	ldrh r7, [r5, #0x12]
	cmp r7, #0
	beq _0224F13E
	ldr r0, [r6, #0xc]
	bl Save_VarsFlags_Get
	add r1, r7, #0
	bl Save_VarsFlags_CheckFlagInArray
	cmp r0, #0
	bne _0224F13E
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F13E:
	ldrb r0, [r5, #3]
	lsl r0, r0, #0x1b
	lsr r1, r0, #0x1b
	beq _0224F15E
	cmp r1, #9
	bne _0224F154
	ldrb r0, [r4]
	cmp r0, #0
	bne _0224F15E
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F154:
	ldrb r0, [r4, #1]
	cmp r1, r0
	beq _0224F15E
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F15E:
	ldrb r1, [r5]
	cmp r1, #0
	beq _0224F16E
	ldrb r0, [r4, #2]
	cmp r1, r0
	beq _0224F16E
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F16E:
	ldrb r0, [r5, #2]
	lsl r0, r0, #0x18
	lsr r1, r0, #0x1d
	beq _0224F19C
	cmp r1, #7
	ldrb r0, [r4, #3]
	bne _0224F194
	cmp r0, #2
	beq _0224F19C
	cmp r0, #3
	beq _0224F19C
	cmp r0, #4
	beq _0224F19C
	cmp r0, #5
	beq _0224F19C
	cmp r0, #8
	beq _0224F19C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F194:
	cmp r1, r0
	beq _0224F19C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F19C:
	ldrh r0, [r5, #0xa]
	lsl r0, r0, #0x1d
	lsr r1, r0, #0x1d
	beq _0224F1BA
	cmp r1, #5
	ldrb r0, [r4, #0xc]
	bne _0224F1B2
	cmp r0, #5
	bhs _0224F1BA
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F1B2:
	cmp r1, r0
	beq _0224F1BA
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F1BA:
	ldrb r0, [r5, #0x10]
	lsl r0, r0, #0x18
	lsr r1, r0, #0x1d
	beq _0224F1D8
	cmp r1, #4
	ldrb r0, [r4, #0xd]
	bne _0224F1D0
	cmp r0, #4
	bhs _0224F1D8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F1D0:
	cmp r1, r0
	beq _0224F1D8
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F1D8:
	ldrb r0, [r5, #0x10]
	lsl r0, r0, #0x1d
	lsr r1, r0, #0x1e
	beq _0224F1EA
	ldrb r0, [r4, #4]
	cmp r1, r0
	beq _0224F1EA
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F1EA:
	ldrb r0, [r5, #0x10]
	lsl r0, r0, #0x1b
	lsr r1, r0, #0x1e
	beq _0224F212
	cmp r1, #3
	bne _0224F200
	ldrb r0, [r4, #0xe]
	cmp r0, #0
	bne _0224F200
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F200:
	cmp r1, #1
	bne _0224F20E
	ldrb r0, [r4, #0xf]
	cmp r0, #0
	bne _0224F20E
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F20E:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F212:
	ldrb r0, [r5, #4]
	lsl r0, r0, #0x1b
	lsr r1, r0, #0x1b
	beq _0224F22A
	ldrb r0, [r4, #5]
	cmp r1, r0
	beq _0224F22A
	ldrb r0, [r4, #6]
	cmp r1, r0
	beq _0224F22A
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F22A:
	ldrh r0, [r5, #8]
	lsl r0, r0, #0x1d
	lsr r1, r0, #0x1d
	beq _0224F23C
	ldrb r0, [r4, #0x11]
	cmp r1, r0
	beq _0224F23C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F23C:
	ldrh r1, [r5, #0xe]
	cmp r1, #0
	beq _0224F24C
	ldrb r0, [r4, #0x12]
	cmp r1, r0
	beq _0224F24C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F24C:
	ldrb r1, [r5, #5]
	cmp r1, #0
	beq _0224F25C
	ldrb r0, [r4, #0x13]
	cmp r1, r0
	beq _0224F25C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F25C:
	ldrh r0, [r5, #0xc]
	cmp r0, #0
	beq _0224F26E
	sub r1, r0, #1
	ldrh r0, [r4, #0x1a]
	cmp r1, r0
	beq _0224F26E
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F26E:
	ldrh r0, [r5, #0xa]
	lsl r0, r0, #0x1a
	lsr r1, r0, #0x1d
	beq _0224F280
	ldrb r0, [r4, #0x14]
	cmp r1, r0
	beq _0224F280
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F280:
	ldrb r0, [r5, #1]
	lsl r0, r0, #0x1c
	lsr r0, r0, #0x1c
	beq _0224F298
	mov r1, #0x15
	ldrsb r1, [r4, r1]
	bl ov02_02250628
	cmp r0, #0
	bne _0224F298
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F298:
	ldrb r0, [r5, #4]
	lsl r0, r0, #0x18
	lsr r1, r0, #0x1d
	beq _0224F2AA
	ldrb r0, [r4, #0x16]
	cmp r1, r0
	beq _0224F2AA
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F2AA:
	ldrb r0, [r5, #1]
	lsl r0, r0, #0x18
	lsr r0, r0, #0x1c
	beq _0224F2C0
	ldrb r1, [r4, #7]
	bl ov02_02250594
	cmp r0, #0
	bne _0224F2C0
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F2C0:
	ldrb r0, [r5, #2]
	lsl r0, r0, #0x1d
	lsr r1, r0, #0x1d
	beq _0224F2D2
	ldrb r0, [r4, #8]
	cmp r1, r0
	beq _0224F2D2
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F2D2:
	ldrb r0, [r5, #6]
	cmp r0, #0
	beq _0224F2E6
	ldrb r1, [r4, #0xa]
	bl ov02_022506D4
	cmp r0, #0
	bne _0224F2E6
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F2E6:
	ldrb r0, [r5, #7]
	cmp r0, #0
	beq _0224F2FA
	ldrb r1, [r4, #0xb]
	bl ov02_02250738
	cmp r0, #0
	bne _0224F2FA
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F2FA:
	ldrb r0, [r5, #2]
	lsl r0, r0, #0x1b
	lsr r1, r0, #0x1e
	beq _0224F30C
	ldrb r0, [r4, #9]
	cmp r1, r0
	beq _0224F30C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F30C:
	ldrh r0, [r5, #8]
	lsl r0, r0, #0x10
	lsr r1, r0, #0x1d
	beq _0224F31E
	ldrb r0, [r4, #0x17]
	cmp r1, r0
	beq _0224F31E
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0224F31E:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F108

	thumb_func_start ov02_0224F324
ov02_0224F324: ; 0x0224F324
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r1, #0
	mov r1, #6
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	cmp r0, #0
	beq _0224F34E
	mov r1, #1
	lsl r0, r0, #0x10
	strb r1, [r5]
	lsr r0, r0, #0x10
	mov r1, #5
	mov r2, #0xb
	bl GetItemAttr
	bl ov02_0224F820
	b _0224F354
_0224F34E:
	mov r0, #0
	strb r0, [r5]
	mov r0, #8
_0224F354:
	strb r0, [r5, #1]
	add r0, r7, #0
	mov r1, #0xa3
	mov r2, #0
	bl GetMonData
	add r4, r0, #0
	add r0, r7, #0
	mov r1, #0xa4
	mov r2, #0
	bl GetMonData
	add r1, r0, #0
	mov r0, #0x64
	mul r0, r4
	bl _s32_div_f
	cmp r0, #0x64
	bne _0224F380
	mov r0, #1
	strb r0, [r5, #2]
	b _0224F3A2
_0224F380:
	cmp r0, #0x4b
	blt _0224F38A
	mov r0, #2
	strb r0, [r5, #2]
	b _0224F3A2
_0224F38A:
	cmp r0, #0x32
	blt _0224F394
	mov r0, #3
	strb r0, [r5, #2]
	b _0224F3A2
_0224F394:
	cmp r0, #0x19
	blt _0224F39E
	mov r0, #4
	strb r0, [r5, #2]
	b _0224F3A2
_0224F39E:
	mov r0, #5
	strb r0, [r5, #2]
_0224F3A2:
	add r0, r7, #0
	mov r1, #0xa0
	mov r2, #0
	bl GetMonData
	mov r1, #0x88
	tst r1, r0
	beq _0224F3B8
	mov r0, #5
	strb r0, [r5, #3]
	b _0224F3FA
_0224F3B8:
	mov r1, #7
	tst r1, r0
	beq _0224F3C4
	mov r0, #8
	strb r0, [r5, #3]
	b _0224F3FA
_0224F3C4:
	mov r1, #0x10
	tst r1, r0
	beq _0224F3D0
	mov r0, #2
	strb r0, [r5, #3]
	b _0224F3FA
_0224F3D0:
	mov r1, #0x20
	tst r1, r0
	beq _0224F3DC
	mov r0, #3
	strb r0, [r5, #3]
	b _0224F3FA
_0224F3DC:
	mov r1, #0x40
	tst r1, r0
	beq _0224F3E8
	mov r0, #4
	strb r0, [r5, #3]
	b _0224F3FA
_0224F3E8:
	cmp r0, #0
	bne _0224F3F2
	mov r0, #1
	strb r0, [r5, #3]
	b _0224F3FA
_0224F3F2:
	bl GF_AssertFail
	mov r0, #1
	strb r0, [r5, #3]
_0224F3FA:
	add r0, r7, #0
	mov r1, #0xa1
	mov r2, #0
	bl GetMonData
	add r1, r0, #2
	cmp r1, #0x32
	blt _0224F410
	mov r0, #4
	strb r0, [r5, #4]
	b _0224F420
_0224F410:
	sub r0, r0, #2
	cmp r0, #0x32
	bgt _0224F41C
	mov r0, #6
	strb r0, [r5, #4]
	b _0224F420
_0224F41C:
	mov r0, #5
	strb r0, [r5, #4]
_0224F420:
	add r0, r7, #0
	mov r1, #0xb1
	mov r2, #0
	bl GetMonData
	add r4, r0, #0
	add r0, r7, #0
	mov r1, #0xb2
	mov r2, #0
	bl GetMonData
	add r6, r0, #0
	add r0, r4, #0
	bl ov02_0224F79C
	strb r0, [r5, #5]
	add r0, r6, #0
	bl ov02_0224F79C
	strb r0, [r5, #6]
	add r0, r7, #0
	mov r1, #9
	mov r2, #0
	bl GetMonData
	strb r0, [r5, #7]
	add r0, r7, #0
	bl GetMonNature
	lsl r1, r0, #2
	ldr r0, _0224F4B4 ; =ov02_02253AC0
	mov r2, #0
	ldr r0, [r0, r1]
	mov r1, #0x6f
	strb r0, [r5, #8]
	add r0, r7, #0
	bl GetMonData
	cmp r0, #0
	bne _0224F474
	mov r0, #1
	b _0224F476
_0224F474:
	mov r0, #2
_0224F476:
	ldr r3, _0224F4B8 ; =ov02_02253A5C
	strb r0, [r5, #9]
	ldmia r3!, {r0, r1}
	add r2, sp, #0
	add r6, r2, #0
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r3]
	mov r4, #0
	str r0, [r2]
	strb r4, [r5, #0xb]
	add r5, #0xb
_0224F490:
	ldr r1, [r6]
	add r0, r7, #0
	mov r2, #0
	bl GetMonData
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	lsl r0, r4
	ldrb r1, [r5]
	add r4, r4, #1
	add r6, r6, #4
	orr r0, r1
	strb r0, [r5]
	cmp r4, #5
	blt _0224F490
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	nop
_0224F4B4: .word ov02_02253AC0
_0224F4B8: .word ov02_02253A5C
	thumb_func_end ov02_0224F324

	thumb_func_start ov02_0224F4BC
ov02_0224F4BC: ; 0x0224F4BC
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r4, r0, #0
	add r5, r1, #0
	mov r0, #0
	strb r0, [r5, #0xc]
	strb r0, [r5, #0xe]
	strb r0, [r5, #0xf]
	strb r0, [r5, #0x10]
	ldr r0, [r4, #0x40]
	bl PlayerAvatar_GetXCoord
	str r0, [sp, #4]
	ldr r0, [r4, #0x40]
	bl PlayerAvatar_GetZCoord
	str r0, [sp]
	ldr r0, [r4, #0x3c]
	bl MapObjectManager_GetObjectCount
	str r0, [sp, #8]
	ldr r0, [r4, #0x3c]
	bl MapObjectManager_GetObjects
	str r0, [sp, #0x10]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, [sp, #8]
	cmp r0, #0
	ble _0224F57A
	add r7, r5, #0
	add r7, #0xc
_0224F4FC:
	ldr r0, [sp, #0x10]
	bl MapObject_CheckActive
	cmp r0, #1
	bne _0224F568
	ldr r0, [sp, #0x10]
	bl MapObject_GetXCoord
	add r4, r0, #0
	ldr r0, [sp, #0x10]
	bl MapObject_GetZCoord
	ldr r1, [sp, #4]
	sub r6, r1, r4
	ldr r1, [sp]
	sub r4, r1, r0
	ldr r0, [sp, #0x10]
	bl MapObject_GetSpriteID
	cmp r0, #0x54
	bne _0224F52C
	mov r0, #1
	strb r0, [r5, #0xf]
	b _0224F568
_0224F52C:
	cmp r0, #0x55
	bne _0224F536
	mov r0, #1
	strb r0, [r5, #0xe]
	b _0224F568
_0224F536:
	cmp r0, #0x56
	bne _0224F540
	mov r0, #1
	strb r0, [r5, #0x10]
	b _0224F568
_0224F540:
	mov r0, #0
	mvn r0, r0
	cmp r6, r0
	blt _0224F568
	cmp r6, #1
	bgt _0224F568
	cmp r4, r0
	blt _0224F568
	cmp r4, #1
	bgt _0224F568
	ldr r0, [sp, #0x10]
	bl MapObject_GetID
	cmp r0, #0xfd
	beq _0224F568
	cmp r0, #0xff
	beq _0224F568
	ldrb r0, [r7]
	add r0, r0, #1
	strb r0, [r7]
_0224F568:
	add r0, sp, #0x10
	bl MapObjectArray_NextObject2
	ldr r0, [sp, #0xc]
	add r1, r0, #1
	ldr r0, [sp, #8]
	str r1, [sp, #0xc]
	cmp r1, r0
	blt _0224F4FC
_0224F57A:
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F4BC

	thumb_func_start ov02_0224F580
ov02_0224F580: ; 0x0224F580
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	str r0, [sp]
	str r1, [sp, #4]
	mov r4, #0
	bl Field_GetBgEvents
	add r5, r0, #0
	ldr r0, [sp]
	bl Field_GetNumBgEvents
	add r7, r0, #0
	beq _0224F5C6
	cmp r5, #0
	beq _0224F5C6
	add r6, r4, #0
	cmp r7, #0
	ble _0224F5C6
_0224F5A4:
	ldrh r0, [r5, #2]
	cmp r0, #2
	bne _0224F5BE
	ldrh r0, [r5]
	bl HiddenItemScriptNoToFlagId
	add r1, r0, #0
	ldr r0, [sp]
	bl FieldSystem_FlagCheck
	cmp r0, #0
	bne _0224F5BE
	add r4, r4, #1
_0224F5BE:
	add r6, r6, #1
	add r5, #0x14
	cmp r6, r7
	blt _0224F5A4
_0224F5C6:
	ldr r0, [sp, #4]
	strb r4, [r0, #0xd]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F580

	thumb_func_start ov02_0224F5D0
ov02_0224F5D0: ; 0x0224F5D0
	push {r4, lr}
	ldr r0, [r0, #0xc]
	add r4, r1, #0
	bl Save_LocalFieldData_Get
	bl LocalFieldData_GetWeatherType
	cmp r0, #0
	beq _0224F5E8
	cmp r0, #1
	beq _0224F5EE
	b _0224F5F4
_0224F5E8:
	mov r0, #1
	strb r0, [r4, #0x11]
	pop {r4, pc}
_0224F5EE:
	mov r0, #3
	strb r0, [r4, #0x11]
	pop {r4, pc}
_0224F5F4:
	mov r0, #0
	strb r0, [r4, #0x11]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F5D0

	thumb_func_start ov02_0224F5FC
ov02_0224F5FC: ; 0x0224F5FC
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl FollowMon_GetMapObject
	bl MapObject_GetXCoord
	add r6, r0, #0
	add r0, r5, #0
	bl FollowMon_GetMapObject
	bl MapObject_GetZCoord
	add r2, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	bl GetMetatileBehavior
	mov r1, #0x12
	strb r0, [r4, #0x12]
	lsl r1, r1, #4
	ldr r2, [r5, r1]
	ldr r1, _0224F640 ; =0x00000882
	strh r0, [r2, r1]
	bl MetatileBehavior_CanGenerateWalkingEncounters
	cmp r0, #0
	beq _0224F63A
	mov r0, #1
	strb r0, [r4, #0x13]
	pop {r4, r5, r6, pc}
_0224F63A:
	mov r0, #2
	strb r0, [r4, #0x13]
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0224F640: .word 0x00000882
	thumb_func_end ov02_0224F5FC

	thumb_func_start ov02_0224F644
ov02_0224F644: ; 0x0224F644
	ldr r0, [r0, #0x20]
	ldr r0, [r0]
	strh r0, [r1, #0x1a]
	bx lr
	thumb_func_end ov02_0224F644

	thumb_func_start ov02_0224F64C
ov02_0224F64C: ; 0x0224F64C
	push {r4, lr}
	add r4, r1, #0
	bl Field_GetTimeOfDay
	cmp r0, #4
	bhi _0224F68C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224F664: ; jump table
	.short _0224F66E - _0224F664 - 2 ; case 0
	.short _0224F674 - _0224F664 - 2 ; case 1
	.short _0224F67A - _0224F664 - 2 ; case 2
	.short _0224F680 - _0224F664 - 2 ; case 3
	.short _0224F686 - _0224F664 - 2 ; case 4
_0224F66E:
	mov r0, #1
	strb r0, [r4, #0x14]
	pop {r4, pc}
_0224F674:
	mov r0, #2
	strb r0, [r4, #0x14]
	pop {r4, pc}
_0224F67A:
	mov r0, #3
	strb r0, [r4, #0x14]
	pop {r4, pc}
_0224F680:
	mov r0, #4
	strb r0, [r4, #0x14]
	pop {r4, pc}
_0224F686:
	mov r0, #5
	strb r0, [r4, #0x14]
	pop {r4, pc}
_0224F68C:
	bl GF_AssertFail
	mov r0, #0
	strb r0, [r4, #0x14]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F64C

	thumb_func_start ov02_0224F698
ov02_0224F698: ; 0x0224F698
	push {r4, lr}
	add r4, r1, #0
	mov r1, #0x42
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bl FieldSystem_UnkSub108_GetMonMood
	strb r0, [r4, #0x15]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F698

	thumb_func_start ov02_0224F6AC
ov02_0224F6AC: ; 0x0224F6AC
	push {r4, r5, r6, lr}
	sub sp, #0x10
	ldr r0, [r0, #0xc]
	add r5, r3, #0
	bl SaveArray_Party_Get
	add r4, r0, #0
	bl GetIdxOfFirstAliveMonInParty_CrashIfNone
	add r6, r0, #0
	add r0, r4, #0
	add r1, sp, #8
	add r2, r6, #0
	bl Party_GetMonAprijuiceModifiers
	add r0, r4, #0
	add r1, r6, #0
	bl Party_GetMonByIndex
	add r1, r0, #0
	add r0, sp, #0
	add r2, sp, #8
	mov r3, #0xb
	bl CalcMonPokeathlonStars
	add r0, sp, #0
	ldrh r2, [r0]
	lsl r0, r2, #0x1d
	lsl r2, r2, #0x11
	lsr r1, r0, #0x1d
	lsr r2, r2, #0x1d
	mov r0, #1
	cmp r1, r2
	bhs _0224F6F4
	add r1, r2, #0
	mov r0, #2
_0224F6F4:
	add r2, sp, #0
	ldrh r2, [r2]
	lsl r2, r2, #0x14
	lsr r2, r2, #0x1d
	cmp r1, r2
	bhs _0224F704
	add r1, r2, #0
	mov r0, #4
_0224F704:
	add r2, sp, #0
	ldrh r2, [r2]
	lsl r2, r2, #0x1a
	lsr r2, r2, #0x1d
	cmp r1, r2
	bhs _0224F714
	add r1, r2, #0
	mov r0, #3
_0224F714:
	add r2, sp, #0
	ldrh r2, [r2]
	lsl r2, r2, #0x17
	lsr r2, r2, #0x1d
	cmp r1, r2
	bhs _0224F722
	mov r0, #5
_0224F722:
	strb r0, [r5, #0x16]
	add sp, #0x10
	pop {r4, r5, r6, pc}
	thumb_func_end ov02_0224F6AC

	thumb_func_start ov02_0224F728
ov02_0224F728: ; 0x0224F728
	push {r4, lr}
	add r0, #0xe4
	ldr r0, [r0]
	add r4, r1, #0
	bl MapObject_GetFacingDirection
	cmp r0, #3
	bhi _0224F764
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0224F744: ; jump table
	.short _0224F74C - _0224F744 - 2 ; case 0
	.short _0224F752 - _0224F744 - 2 ; case 1
	.short _0224F758 - _0224F744 - 2 ; case 2
	.short _0224F75E - _0224F744 - 2 ; case 3
_0224F74C:
	mov r0, #3
	strb r0, [r4, #0x17]
	pop {r4, pc}
_0224F752:
	mov r0, #4
	strb r0, [r4, #0x17]
	pop {r4, pc}
_0224F758:
	mov r0, #2
	strb r0, [r4, #0x17]
	pop {r4, pc}
_0224F75E:
	mov r0, #1
	strb r0, [r4, #0x17]
	pop {r4, pc}
_0224F764:
	mov r0, #0
	strb r0, [r4, #0x17]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov02_0224F728
