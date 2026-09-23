#include "constants/items.h"
#include "constants/moves.h"
#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "unk_020755E8.inc"
	.include "global.inc"

	.rodata

_020FFEC0:
	.byte 0x01, 0x04, 0x00, 0x00
_020FFEC4:
	.byte 0x80, 0x00
_020FFEC6:
	.byte 0x48, 0x00, 0x80, 0x00, 0x78, 0x00
_020FFECC:
	.byte 0x32, 0x5C, 0x03, 0xFB
	.byte 0x63, 0x8C, 0x03, 0xFB
	.byte 0xFF, 0x00, 0x00, 0x00
_020FFED8:
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
_020FFEE8:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x40, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00
_020FFEFC:
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
_020FFF14:
	.byte 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x20, 0x00, 0x00, 0x00
_020FFF34:
	.byte 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00
_020FFF5C:
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_020FFF90:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x02, 0x03
	.byte 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x06, 0x04, 0x00, 0x03, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
_020FFFE4:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x0E, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x01, 0x00, 0x0D, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x0C, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

	.text

	thumb_func_start sub_020755E8
sub_020755E8: ; 0x020755E8
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	ldr r4, _0207562C ; =_020FFF5C
	add r6, r2, #0
	add r5, r3, #0
	add r7, r0, #0
	mov ip, r1
	add r3, sp, #0
	mov r2, #6
_020755FA:
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _020755FA
	ldr r0, [r4]
	add r1, sp, #0
	str r0, [r3]
	strh r6, [r1]
	strh r5, [r1, #2]
	add r0, sp, #0x38
	ldrb r0, [r0, #0x10]
	add r2, sp, #0
	strh r0, [r1, #6]
	add r0, r7, #0
	mov r1, ip
	bl SpriteSystem_NewSprite
	mov r1, #1
	add r4, r0, #0
	bl ManagedSprite_SetAnimateFlag
	add r0, r4, #0
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	nop
_0207562C: .word _020FFF5C
	thumb_func_end sub_020755E8

	thumb_func_start sub_02075630
sub_02075630: ; 0x02075630
	push {r4, r5, r6, r7, lr}
	sub sp, #0x5c
	add r5, r0, #0
	ldr r0, [r5, #0x5c]
	bl SpriteSystem_Alloc
	add r1, r5, #0
	add r1, #0xac
	str r0, [r1]
	add r0, r5, #0
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteManager_New
	add r1, r5, #0
	add r1, #0xb0
	add r2, sp, #0x3c
	ldr r4, _02075764 ; =_020FFF14
	str r0, [r1]
	ldmia r4!, {r0, r1}
	add r3, r2, #0
	stmia r2!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r4!, {r0, r1}
	ldr r6, _02075768 ; =_020FFEE8
	stmia r2!, {r0, r1}
	add r4, sp, #0x28
	ldmia r6!, {r0, r1}
	add r2, r4, #0
	stmia r4!, {r0, r1}
	ldmia r6!, {r0, r1}
	stmia r4!, {r0, r1}
	ldr r0, [r6]
	add r1, r3, #0
	str r0, [r4]
	mov r0, #0x10
	str r0, [sp, #0x28]
	add r0, r5, #0
	add r0, #0xac
	ldr r0, [r0]
	mov r3, #0x20
	bl SpriteSystem_Init
	add r0, r5, #0
	add r1, r5, #0
	add r0, #0xac
	add r1, #0xb0
	ldr r0, [r0]
	ldr r1, [r1]
	mov r2, #0x10
	bl SpriteSystem_InitSprites
	ldr r4, _0207576C ; =_020FFEFC
	add r3, sp, #0x10
	add r2, r3, #0
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r4!, {r0, r1}
	stmia r3!, {r0, r1}
	add r0, r5, #0
	add r1, r5, #0
	add r0, #0xac
	add r1, #0xb0
	ldr r0, [r0]
	ldr r1, [r1]
	bl SpriteSystem_InitManagerWithCapacities
	add r0, r5, #0
	add r0, #0xac
	ldr r6, [r0]
	add r0, r5, #0
	add r0, #0xb0
	ldr r4, [r0]
	ldr r1, [r5, #0x5c]
	mov r0, #0xef
	bl NARC_New
	add r7, r0, #0
	mov r1, #0
	str r1, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	str r1, [sp, #0xc]
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	mov r3, #0xb
	bl SpriteSystem_LoadPlttResObjFromOpenNarc
	mov r1, #0
	str r1, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r1, [sp, #8]
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	mov r3, #0xc
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	mov r3, #0xd
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	add r0, r6, #0
	add r1, r4, #0
	add r2, r7, #0
	mov r3, #0xe
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add r0, r7, #0
	bl NARC_Delete
	mov r0, #1
	str r0, [sp]
	add r0, r5, #0
	add r1, r5, #0
	add r0, #0xac
	add r1, #0xb0
	ldr r0, [r0]
	ldr r1, [r1]
	mov r2, #0x80
	mov r3, #0x48
	bl sub_020755E8
	add r1, r5, #0
	add r1, #0xb4
	str r0, [r1]
	add r0, r5, #0
	add r0, #0xb4
	ldr r0, [r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	mov r0, #1
	add r5, #0xb8
	str r0, [r5]
	add sp, #0x5c
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02075764: .word _020FFF14
_02075768: .word _020FFEE8
_0207576C: .word _020FFEFC
	thumb_func_end sub_02075630

	thumb_func_start sub_02075770
sub_02075770: ; 0x02075770
	push {r4, r5, r6, lr}
	add r5, r0, #0
	add r0, #0xac
	ldr r4, [r0]
	add r0, r5, #0
	add r0, #0xb0
	ldr r6, [r0]
	add r0, r5, #0
	add r0, #0xb4
	ldr r0, [r0]
	cmp r0, #0
	bne _0207578C
	bl GF_AssertFail
_0207578C:
	add r0, r5, #0
	add r0, #0xb4
	ldr r0, [r0]
	bl Sprite_DeleteAndFreeResources
	add r0, r4, #0
	add r1, r6, #0
	bl SpriteSystem_FreeResourcesAndManager
	add r0, r4, #0
	bl SpriteSystem_Free
	mov r0, #0
	add r5, #0xb8
	str r0, [r5]
	pop {r4, r5, r6, pc}
	thumb_func_end sub_02075770

	thumb_func_start sub_020757AC
sub_020757AC: ; 0x020757AC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0xb8
	ldr r0, [r0]
	cmp r0, #0
	bne _020757BC
	bl GF_AssertFail
_020757BC:
	add r0, r5, #0
	add r0, #0xb4
	ldr r0, [r0]
	cmp r0, #0
	bne _020757CA
	bl GF_AssertFail
_020757CA:
	add r0, r5, #0
	add r0, #0x8b
	ldrb r0, [r0]
	cmp r0, #1
	beq _020757DA
	cmp r0, #2
	beq _020757DE
	b _020757E2
_020757DA:
	mov r4, #0
	b _020757E6
_020757DE:
	mov r4, #1
	b _020757E6
_020757E2:
	bl GF_AssertFail
_020757E6:
	ldr r1, _020757FC ; =_020FFEC4
	lsl r3, r4, #2
	ldr r2, _02075800 ; =_020FFEC6
	add r5, #0xb4
	ldrsh r1, [r1, r3]
	ldrsh r2, [r2, r3]
	ldr r0, [r5]
	bl ManagedSprite_SetPositionXY
	pop {r3, r4, r5, pc}
	nop
_020757FC: .word _020FFEC4
_02075800: .word _020FFEC6
	thumb_func_end sub_020757AC

	thumb_func_start sub_02075804
sub_02075804: ; 0x02075804
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r5, r1, #0
	add r2, r3, #0
	ldr r0, [r4, #0xc]
	ldr r1, [r4, #8]
	ldr r3, [r4, #0x5c]
	bl ReadMsgData_ExpandPlaceholders
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #0
	bl FillWindowPixelBuffer
	mov r3, #0
	str r3, [sp]
	ldr r0, _02075848 ; =0x00010200
	str r3, [sp, #4]
	str r0, [sp, #8]
	add r0, r5, #0
	mov r1, #4
	add r2, r4, #0
	str r3, [sp, #0xc]
	bl AddTextPrinterParameterizedWithColor
	add r0, r5, #0
	bl CopyWindowToVram
	add r0, r4, #0
	bl String_Delete
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
_02075848: .word 0x00010200
	thumb_func_end sub_02075804

	thumb_func_start sub_0207584C
sub_0207584C: ; 0x0207584C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r0, #0xb8
	ldr r6, _020758C8 ; =0x0000049D
	ldr r0, [r0]
	add r7, r1, #0
	add r4, r6, #1
	cmp r0, #0
	bne _02075862
	bl GF_AssertFail
_02075862:
	cmp r7, #0
	bne _02075878
	add r2, r5, #0
	add r2, #0x6c
	ldrh r2, [r2]
	ldr r0, [r5, #0xc]
	mov r1, #0
	bl BufferMoveName
	ldr r6, _020758CC ; =0x000004A2
	add r4, r6, #1
_02075878:
	add r1, r5, #0
	ldr r2, [r5, #8]
	add r0, r5, #0
	add r1, #0x8c
	add r3, r6, #0
	bl sub_02075804
	add r1, r5, #0
	ldr r2, [r5, #8]
	add r0, r5, #0
	add r1, #0x9c
	add r3, r4, #0
	bl sub_02075804
	add r0, r5, #0
	mov r1, #0
	add r0, #0x8a
	strb r1, [r0]
	add r0, r5, #0
	mov r1, #1
	add r0, #0x8b
	strb r1, [r0]
	add r0, r5, #0
	bl sub_020757AC
	mov r0, #5
	mov r1, #1
	bl ToggleBgLayer
	mov r0, #6
	mov r1, #1
	bl ToggleBgLayer
	add r5, #0xb4
	ldr r0, [r5]
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
	pop {r3, r4, r5, r6, r7, pc}
	nop
_020758C8: .word 0x0000049D
_020758CC: .word 0x000004A2
	thumb_func_end sub_0207584C

	thumb_func_start sub_020758D0
sub_020758D0: ; 0x020758D0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, _020759C0 ; =_020FFECC
	mov r4, #0
	bl TouchscreenHitbox_FindRectAtTouchNew
	add r6, r0, #0
	add r0, r5, #0
	add r0, #0xb8
	ldr r0, [r0]
	cmp r0, #0
	bne _020758EC
	bl GF_AssertFail
_020758EC:
	mov r0, #0
	mvn r0, r0
	cmp r6, r0
	beq _02075920
	ldr r0, _020759C4 ; =0x000005DC
	bl PlaySE
	cmp r6, #0
	beq _02075904
	cmp r6, #1
	beq _0207590E
	b _0207591A
_02075904:
	add r0, r5, #0
	mov r4, #1
	add r0, #0x8b
	strb r4, [r0]
	b _020759A0
_0207590E:
	add r0, r5, #0
	mov r1, #2
	add r0, #0x8b
	strb r1, [r0]
	mov r4, #1
	b _020759A0
_0207591A:
	bl GF_AssertFail
	b _020759A0
_02075920:
	ldr r0, _020759C8 ; =gSystem
	mov r1, #0x40
	ldr r0, [r0, #0x48]
	tst r1, r0
	beq _0207594A
	add r0, r5, #0
	add r0, #0x8b
	ldrb r0, [r0]
	cmp r0, #1
	beq _020759A0
	add r0, r5, #0
	mov r1, #1
	add r0, #0x8b
	strb r1, [r0]
	add r0, r5, #0
	bl sub_020757AC
	ldr r0, _020759C4 ; =0x000005DC
	bl PlaySE
	b _020759A0
_0207594A:
	mov r1, #0x80
	tst r1, r0
	beq _02075970
	add r0, r5, #0
	add r0, #0x8b
	ldrb r0, [r0]
	cmp r0, #2
	beq _020759A0
	add r0, r5, #0
	mov r1, #2
	add r0, #0x8b
	strb r1, [r0]
	add r0, r5, #0
	bl sub_020757AC
	ldr r0, _020759C4 ; =0x000005DC
	bl PlaySE
	b _020759A0
_02075970:
	mov r1, #1
	add r2, r0, #0
	tst r2, r1
	beq _02075992
	add r0, r5, #0
	add r0, #0x8b
	ldrb r0, [r0]
	cmp r0, #0
	bne _0207598E
	bl GF_AssertFail
	add r0, r5, #0
	mov r1, #2
	add r0, #0x8b
	strb r1, [r0]
_0207598E:
	mov r4, #1
	b _020759A0
_02075992:
	mov r2, #2
	tst r0, r2
	beq _020759A0
	add r0, r5, #0
	add r0, #0x8b
	strb r2, [r0]
	add r4, r1, #0
_020759A0:
	cmp r4, #0
	beq _020759BA
	add r0, r5, #0
	bl sub_020757AC
	add r5, #0xb4
	ldr r0, [r5]
	mov r1, #3
	bl ManagedSprite_SetAnim
	ldr r0, _020759C4 ; =0x000005DC
	bl PlaySE
_020759BA:
	add r0, r4, #0
	pop {r4, r5, r6, pc}
	nop
_020759C0: .word _020FFECC
_020759C4: .word 0x000005DC
_020759C8: .word gSystem
	thumb_func_end sub_020758D0

	thumb_func_start sub_020759CC
sub_020759CC: ; 0x020759CC
	push {r4, lr}
	add r4, r0, #0
	add r0, #0xb8
	ldr r0, [r0]
	cmp r0, #0
	bne _020759DC
	bl GF_AssertFail
_020759DC:
	add r0, r4, #0
	add r0, #0xb4
	ldr r0, [r0]
	bl ManagedSprite_GetActiveAnim
	cmp r0, #3
	beq _020759EE
	bl GF_AssertFail
_020759EE:
	add r4, #0xb4
	ldr r0, [r4]
	bl ManagedSprite_IsAnimated
	cmp r0, #0
	bne _020759FE
	mov r0, #1
	pop {r4, pc}
_020759FE:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end sub_020759CC

	thumb_func_start sub_02075A04
sub_02075A04: ; 0x02075A04
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x8a
	ldrb r1, [r1]
	cmp r1, #0
	beq _02075A18
	cmp r1, #1
	beq _02075A2E
	b _02075A74
_02075A18:
	bl sub_020758D0
	cmp r0, #0
	beq _02075A78
	add r0, r4, #0
	add r0, #0x8a
	ldrb r0, [r0]
	add r4, #0x8a
	add r0, r0, #1
	strb r0, [r4]
	b _02075A78
_02075A2E:
	bl sub_020759CC
	cmp r0, #0
	beq _02075A78
	add r0, r4, #0
	add r0, #0xb8
	ldr r0, [r0]
	cmp r0, #0
	bne _02075A44
	bl GF_AssertFail
_02075A44:
	add r0, r4, #0
	add r0, #0x8b
	ldrb r0, [r0]
	cmp r0, #0
	bne _02075A52
	bl GF_AssertFail
_02075A52:
	mov r0, #5
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #6
	mov r1, #0
	bl ToggleBgLayer
	add r0, r4, #0
	add r0, #0xb4
	ldr r0, [r0]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	add r4, #0x8b
	ldrb r0, [r4]
	pop {r4, pc}
_02075A74:
	bl GF_AssertFail
_02075A78:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end sub_02075A04

	thumb_func_start sub_02075A7C
sub_02075A7C: ; 0x02075A7C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x24
	add r6, r0, #0
	add r7, r1, #0
	ldr r5, [sp, #0x50]
	ldr r0, _02075CFC ; =gSystem + 0x60
	mov r1, #0
	str r2, [sp, #0x14]
	str r3, [sp, #0x18]
	strb r1, [r0, #9]
	bl GfGfx_SwapDisplay
	mov r0, #4
	add r1, r5, #0
	bl FontID_Alloc
	add r0, r5, #0
	mov r1, #0xbc
	bl Heap_Alloc
	add r4, r0, #0
	mov r0, #0
	add r1, r4, #0
	mov r2, #0xbc
	bl MIi_CpuClearFast
	bl sub_02026E8C
	str r0, [sp, #0x1c]
	bl GetMainBgPlttAddr
	add r1, r0, #0
	ldr r2, [sp, #0x1c]
	mov r0, #0
	bl MIi_CpuClear16
	bl sub_02026E9C
	str r0, [sp, #0x20]
	bl GetSubBgPlttAddr
	add r1, r0, #0
	ldr r2, [sp, #0x20]
	mov r0, #0
	bl MIi_CpuClear16
	str r6, [r4, #0x24]
	add r0, r7, #0
	mov r1, #5
	mov r2, #0
	str r7, [r4, #0x28]
	bl GetMonData
	add r1, r4, #0
	add r1, #0x60
	strh r0, [r1]
	add r0, r7, #0
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	add r1, r4, #0
	add r1, #0x80
	strb r0, [r1]
	add r1, r4, #0
	ldr r0, [sp, #0x14]
	add r1, #0x62
	strh r0, [r1]
	str r5, [r4, #0x5c]
	mov r0, #0
	str r0, [r4, #0x38]
	mov r0, #0xb4
	add r1, r5, #0
	bl NARC_New
	add r1, r4, #0
	add r1, #0x84
	str r0, [r1]
	add r2, r4, #0
	add r0, r4, #0
	add r2, #0x60
	add r0, #0x84
	add r1, r4, #0
	ldrh r2, [r2]
	ldr r0, [r0]
	add r1, #0x88
	mov r3, #1
	bl sub_020729A4
	add r2, r4, #0
	add r0, r4, #0
	add r2, #0x62
	add r0, #0x84
	add r1, r4, #0
	ldrh r2, [r2]
	ldr r0, [r0]
	add r1, #0x89
	mov r3, #1
	bl sub_020729A4
	add r0, r5, #0
	bl PaletteData_Init
	str r0, [r4, #0x14]
	mov r1, #1
	bl PaletteData_SetAutoTransparent
	mov r2, #2
	ldr r0, [r4, #0x14]
	mov r1, #0
	lsl r2, r2, #8
	add r3, r5, #0
	bl PaletteData_AllocBuffers
	mov r1, #1
	ldr r0, [r4, #0x14]
	lsl r2, r1, #9
	add r3, r5, #0
	bl PaletteData_AllocBuffers
	mov r2, #7
	ldr r0, [r4, #0x14]
	mov r1, #2
	lsl r2, r2, #6
	add r3, r5, #0
	bl PaletteData_AllocBuffers
	add r0, r5, #0
	bl BgConfig_Alloc
	str r0, [r4]
	add r0, r5, #0
	mov r1, #1
	bl AllocWindows
	str r0, [r4, #4]
	ldr r0, [sp, #0x18]
	str r0, [r4, #0x2c]
	add r0, r5, #0
	bl sub_02077400
	str r0, [r4, #0x34]
	bl sub_020773AC
	bl sub_020773D4
	bl sub_020774A0
	ldr r1, [r4]
	add r0, r4, #0
	bl sub_02076E64
	add r0, r4, #0
	bl sub_02075630
	mov r0, #0x13
	str r0, [sp]
	mov r0, #0x1b
	str r0, [sp, #4]
	mov r0, #4
	str r0, [sp, #8]
	mov r0, #0xb
	str r0, [sp, #0xc]
	mov r0, #0x1f
	str r0, [sp, #0x10]
	ldr r0, [r4]
	ldr r1, [r4, #4]
	mov r2, #1
	mov r3, #2
	bl AddWindowParameterized
	ldr r0, [r4, #4]
	mov r1, #0xff
	bl FillWindowPixelBuffer
	ldr r0, [r4, #4]
	mov r1, #0
	mov r2, #1
	mov r3, #0xa
	bl DrawFrameAndWindow2
	mov r0, #8
	str r0, [sp]
	mov r0, #0x1a
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #0x50
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4]
	add r1, #0x8c
	mov r2, #6
	mov r3, #3
	bl AddWindowParameterized
	mov r0, #0xe
	str r0, [sp]
	mov r0, #0x1a
	str r0, [sp, #4]
	mov r0, #2
	str r0, [sp, #8]
	mov r0, #0xf
	str r0, [sp, #0xc]
	mov r0, #0x84
	str r0, [sp, #0x10]
	add r1, r4, #0
	ldr r0, [r4]
	add r1, #0x9c
	mov r2, #6
	mov r3, #3
	bl AddWindowParameterized
	add r0, r5, #0
	bl PokepicManager_Create
	str r0, [r4, #0x18]
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl sub_02016EDC
	str r0, [r4, #0x44]
	add r0, r4, #0
	mov r1, #0
	add r0, #0x67
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #2
	add r0, #0x66
	strb r1, [r0]
	mov r0, #1
	mov r1, #0x1b
	mov r2, #0xc5
	add r3, r5, #0
	bl NewMsgDataFromNarc
	str r0, [r4, #8]
	add r0, r5, #0
	bl MessageFormat_New
	str r0, [r4, #0xc]
	mov r0, #5
	lsl r0, r0, #6
	add r1, r5, #0
	bl String_New
	str r0, [r4, #0x10]
	add r0, r5, #0
	mov r1, #0x3c
	bl Heap_Alloc
	str r0, [r4, #0x3c]
	ldr r1, [r4, #0x3c]
	mov r0, #0
	mov r2, #0x3c
	bl MIi_CpuClearFast
	ldr r1, [sp, #0x38]
	ldr r0, [r4, #0x3c]
	str r1, [r0, #0x2c]
	ldr r0, [sp, #0x3c]
	str r0, [r4, #0x48]
	ldr r0, [sp, #0x40]
	str r0, [r4, #0x4c]
	ldr r0, [sp, #0x44]
	str r0, [r4, #0x50]
	ldr r0, [sp, #0x48]
	str r0, [r4, #0x78]
	ldr r0, [sp, #0x4c]
	str r0, [r4, #0x7c]
	add r0, r4, #0
	bl sub_020771E8
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #0x14]
	ldr r2, _02075D00 ; =0x0000FFFF
	mov r1, #0xf
	mov r3, #1
	bl PaletteData_BeginPaletteFade
	mov r2, #0
	str r2, [sp]
	ldr r0, [r4, #0x18]
	mov r1, #0x10
	add r3, r2, #0
	bl Pokepic_StartPaletteFadeAll
	ldr r0, [r4, #0x14]
	mov r1, #0
	mov r2, #0xb
	add r3, r5, #0
	bl sub_020163E0
	mov r1, #1
	str r0, [r4, #0x58]
	bl sub_0201649C
	ldr r0, _02075D04 ; =sub_02075D08
	add r1, r4, #0
	mov r2, #0
	bl SysTask_CreateOnMainQueue
	mov r0, #1
	bl TextFlags_SetCanABSpeedUpPrint
	mov r0, #1
	bl TextFlags_SetCanTouchSpeedUpPrint
	bl sub_0203A880
	add r0, r4, #0
	add sp, #0x24
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_02075CFC: .word gSystem + 0x60
_02075D00: .word 0x0000FFFF
_02075D04: .word sub_02075D08
	thumb_func_end sub_02075A7C

	thumb_func_start sub_02075D08
sub_02075D08: ; 0x02075D08
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	add r0, r4, #0
	bl sub_02075E14
	ldr r0, [r4, #0x38]
	cmp r0, #0
	bne _02075D2C
	ldr r0, [r4, #0x18]
	bl PokepicManager_DrawAll
	bl sub_020774E0
	mov r0, #1
	mov r1, #0
	bl RequestSwap3DBuffers
_02075D2C:
	add r4, #0x67
	ldrb r0, [r4]
	cmp r0, #0
	beq _02075D3A
	add r0, r5, #0
	bl SysTask_Destroy
_02075D3A:
	pop {r3, r4, r5, pc}
	thumb_func_end sub_02075D08

	thumb_func_start sub_02075D3C
sub_02075D3C: ; 0x02075D3C
	add r0, #0x67
	ldrb r0, [r0]
	cmp r0, #1
	bne _02075D48
	mov r0, #1
	bx lr
_02075D48:
	mov r0, #0
	bx lr
	thumb_func_end sub_02075D3C

	thumb_func_start sub_02075D4C
sub_02075D4C: ; 0x02075D4C
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl sub_0200FBF4
	mov r0, #1
	mov r1, #0
	bl sub_0200FBF4
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	mov r0, #4
	bl FontID_Release
	add r0, r4, #0
	bl sub_02075770
	ldr r0, [r4, #4]
	mov r1, #1
	bl WindowArray_Delete
	add r0, r4, #0
	add r0, #0x8c
	bl RemoveWindow
	add r0, r4, #0
	add r0, #0x9c
	bl RemoveWindow
	ldr r0, [r4, #0x14]
	mov r1, #0
	bl PaletteData_FreeBuffers
	ldr r0, [r4, #0x14]
	mov r1, #1
	bl PaletteData_FreeBuffers
	ldr r0, [r4, #0x14]
	mov r1, #2
	bl PaletteData_FreeBuffers
	ldr r0, [r4, #0x14]
	bl PaletteData_Free
	ldr r0, [r4, #0x18]
	bl PokepicManager_Delete
	ldr r0, [r4, #0x44]
	bl sub_02016F2C
	ldr r0, [r4, #0x34]
	bl GF_3DVramMan_Delete
	ldr r0, [r4]
	bl sub_020771A0
	ldr r0, [r4, #8]
	bl DestroyMsgData
	ldr r0, [r4, #0xc]
	bl MessageFormat_Delete
	ldr r0, [r4, #0x10]
	bl Heap_Free
	ldr r0, [r4, #0x3c]
	bl Heap_Free
	ldr r0, [r4, #0x58]
	bl sub_020164C4
	ldr r0, [r4]
	bl Heap_Free
	add r0, r4, #0
	add r0, #0x84
	ldr r0, [r0]
	bl NARC_Delete
	add r0, r4, #0
	bl Heap_Free
	mov r0, #0
	bl TextFlags_SetCanABSpeedUpPrint
	mov r0, #0
	bl TextFlags_SetCanTouchSpeedUpPrint
	ldr r0, _02075E10 ; =gSystem + 0x60
	mov r1, #1
	strb r1, [r0, #9]
	bl GfGfx_SwapDisplay
	pop {r4, pc}
	nop
_02075E10: .word gSystem + 0x60
	thumb_func_end sub_02075D4C
