	.include "asm/macros.inc"
	.include "overlay_07.inc"
	.include "global.inc"

.public _02237840
.public ov07_0221F8B0
.public ov07_0221F8C4
.public ov07_0221F8C8
.public ov07_0221F980
.public ov07_0221FA04
.public ov07_0221FA48
.public ov07_0221FAB0
.public ov07_0221FAE8
.public ov07_0221FAEC
.public ov07_0221FAF8
.public ov07_0221FB04
.public ov07_0221FB30
.public ov07_0221FB58
.public ov07_0221FB7C
.public ov07_0221FE88
.public ov07_0221FEB0
.public ov07_0221FF18
.public ov07_0221FF2C
.public ov07_02221F80
.public ov07_02222BE4
.public ov07_02222C60
.public ov07_02222C84
.public ov07_02222D88
.public ov07_02222D90
.public ov07_02223038
.public ov07_0222304C
.public ov07_02231924
.public ov07_0223192C
.public ov07_0223197C
.public ov07_0223474C
.public ov07_0223475C
.public ov07_02234B98
.public ov07_02234BA8
.public ov07_02234BC0
.public ov07_02234BF0
.public ov07_02234C08
.public ov07_02234C20
.public ov07_02234C40
.public ov07_02234C64
.public ov07_02234CC8
.public ov07_02234D58
.public ov07_02237870
.public ov07_0223789C

	.text

	thumb_func_start ov07_0221BE20
ov07_0221BE20: ; 0x0221BE20
	add r1, r0, #0
	add r1, #0x8d
	ldrb r1, [r1]
	cmp r1, #0
	bne _0221BE32
	ldr r1, _0221BE40 ; =ov07_0221BE44
	add r0, #0xbc
	str r1, [r0]
	bx lr
_0221BE32:
	add r1, r0, #0
	add r1, #0x8d
	ldrb r1, [r1]
	add r0, #0x8d
	sub r1, r1, #1
	strb r1, [r0]
	bx lr
	.balign 4, 0
_0221BE40: .word ov07_0221BE44
	thumb_func_end ov07_0221BE20

	thumb_func_start ov07_0221BE44
ov07_0221BE44: ; 0x0221BE44
	push {r4, lr}
	add r4, r0, #0
_0221BE48:
	ldr r0, [r4, #0x18]
	ldr r0, [r0]
	bl ov07_0221F8B0
	add r1, r0, #0
	add r0, r4, #0
	blx r1
	add r0, r4, #0
	add r0, #0x8d
	ldrb r0, [r0]
	cmp r0, #0
	bne _0221BE66
	ldr r0, [r4, #0x10]
	cmp r0, #1
	beq _0221BE48
_0221BE66:
	pop {r4, pc}
	thumb_func_end ov07_0221BE44

	thumb_func_start ov07_0221BE68
ov07_0221BE68: ; 0x0221BE68
	push {r3, r4, r5, lr}
	add r5, r2, #0
	add r4, r3, #0
	cmp r0, #1
	beq _0221BE78
	cmp r0, #2
	beq _0221BE86
	b _0221BE94
_0221BE78:
	add r0, r1, #0
	add r0, #0x8e
	ldrh r0, [r0]
	add r1, #0x8e
	add r0, r0, #1
	strh r0, [r1]
	b _0221BE98
_0221BE86:
	add r0, r1, #0
	add r0, #0x90
	ldrh r0, [r0]
	add r1, #0x90
	add r0, r0, #1
	strh r0, [r1]
	b _0221BE98
_0221BE94:
	bl GF_AssertFail
_0221BE98:
	ldr r2, [sp, #0x10]
	add r0, r5, #0
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221BE68

	thumb_func_start ov07_0221BEA4
ov07_0221BEA4: ; 0x0221BEA4
	push {r4, lr}
	add r4, r2, #0
	cmp r0, #1
	beq _0221BEB2
	cmp r0, #2
	beq _0221BEC0
	b _0221BECE
_0221BEB2:
	add r0, r1, #0
	add r0, #0x8e
	ldrh r0, [r0]
	add r1, #0x8e
	sub r0, r0, #1
	strh r0, [r1]
	b _0221BED2
_0221BEC0:
	add r0, r1, #0
	add r0, #0x90
	ldrh r0, [r0]
	add r1, #0x90
	sub r0, r0, #1
	strh r0, [r1]
	b _0221BED2
_0221BECE:
	bl GF_AssertFail
_0221BED2:
	add r0, r4, #0
	bl SysTask_Destroy
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221BEA4

	thumb_func_start ov07_0221BEDC
ov07_0221BEDC: ; 0x0221BEDC
	push {r3, r4, r5, lr}
	mov r1, #0x72
	lsl r1, r1, #2
	add r5, r0, #0
	bl Heap_Alloc
	add r4, r0, #0
	bne _0221BEF8
	cmp r4, #0
	bne _0221BEF4
	bl GF_AssertFail
_0221BEF4:
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221BEF8:
	mov r2, #0x72
	mov r1, #0
	lsl r2, r2, #2
	bl memset
	mov r1, #0x47
	str r5, [r4]
	mov r0, #0
	str r0, [r4, #8]
	ldr r0, [r4]
	lsl r1, r1, #2
	bl Heap_Alloc
	add r1, r4, #0
	add r1, #0xc0
	str r0, [r1]
	mov r0, #7
	add r1, r5, #0
	bl NARC_New
	mov r1, #0x1b
	lsl r1, r1, #4
	str r0, [r4, r1]
	mov r0, #8
	add r1, r5, #0
	bl NARC_New
	mov r1, #0x6d
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x16
	add r1, r5, #0
	bl NARC_New
	mov r1, #0x6e
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x17
	add r1, r5, #0
	bl NARC_New
	mov r1, #0x6f
	lsl r1, r1, #2
	str r0, [r4, r1]
	mov r0, #0x18
	add r1, r5, #0
	bl NARC_New
	mov r1, #7
	lsl r1, r1, #6
	str r0, [r4, r1]
	mov r0, #0x19
	add r1, r5, #0
	bl NARC_New
	mov r2, #0x71
	lsl r2, r2, #2
	str r0, [r4, r2]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	cmp r0, #0
	bne _0221BF80
	bne _0221BF7C
	bl GF_AssertFail
_0221BF7C:
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221BF80:
	mov r1, #0
	sub r2, #0xa8
	bl memset
	mov r1, #0
	str r1, [r4, #0xc]
	str r1, [r4, #0x18]
	add r2, r4, #0
	add r3, r1, #0
_0221BF92:
	add r0, r2, #0
	add r0, #0xcc
	add r1, r1, #1
	add r2, r2, #4
	str r3, [r0]
	cmp r1, #4
	blt _0221BF92
	mov r0, #0x59
	add r2, r4, #0
	mov r1, #0
	lsl r0, r0, #2
_0221BFA8:
	add r3, r3, #1
	str r1, [r2, r0]
	add r2, r2, #4
	cmp r3, #5
	blt _0221BFA8
	mov r0, #0x5e
	lsl r0, r0, #2
	str r1, [r4, r0]
	mov r0, #1
	str r0, [r4, #0xc]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221BEDC

	thumb_func_start ov07_0221BFC0
ov07_0221BFC0: ; 0x0221BFC0
	push {r4, lr}
	add r4, r0, #0
	bne _0221BFCA
	bl GF_AssertFail
_0221BFCA:
	ldr r0, [r4, #8]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221BFC0

	thumb_func_start ov07_0221BFD0
ov07_0221BFD0: ; 0x0221BFD0
	push {r4, lr}
	add r4, r0, #0
	bne _0221BFDA
	bl GF_AssertFail
_0221BFDA:
	ldr r0, [r4]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221BFD0

	thumb_func_start ov07_0221BFE0
ov07_0221BFE0: ; 0x0221BFE0
	push {r3, r4, r5, r6, r7, lr}
	add r7, r0, #0
	bl ov07_0221C3DC
	cmp r0, #0
	bne _0221BFF0
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0221BFF0:
	mov r6, #0x1b
	mov r4, #0
	add r5, r7, #0
	lsl r6, r6, #4
_0221BFF8:
	ldr r0, [r5, r6]
	bl NARC_Delete
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blt _0221BFF8
	add r0, r7, #0
	add r0, #0xc0
	ldr r0, [r0]
	bl Heap_Free
	add r0, r7, #0
	bl Heap_Free
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov07_0221BFE0

	thumb_func_start ov07_0221C01C
ov07_0221C01C: ; 0x0221C01C
	push {r4, r5, r6, r7, lr}
	sub sp, #0x6c
	add r4, r0, #0
	add r5, r1, #0
	str r2, [sp]
	str r3, [sp, #4]
	bl ov07_0221C69C
	add r0, r4, #0
	bl ov07_0221C3DC
	cmp r0, #0
	bne _0221C03C
	add sp, #0x6c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0221C03C:
	mov r3, #0
	mov r2, #1
	add r1, r3, #0
_0221C042:
	add r0, r4, r3
	add r0, #0x6c
	strb r2, [r0]
	add r0, r4, r3
	add r0, #0x7c
	add r3, r3, #1
	strb r1, [r0]
	cmp r3, #0x10
	blt _0221C042
	add r3, r4, #0
	mov r0, #0
_0221C058:
	add r2, r3, #0
	add r2, #0x94
	add r1, r1, #1
	add r3, r3, #4
	str r0, [r2]
	cmp r1, #0xa
	blt _0221C058
	add r3, r4, #0
	mov r2, #0
_0221C06A:
	str r2, [r3, #0x30]
	add r1, r3, #0
	str r2, [r3, #0x28]
	add r1, #0x2c
	strb r2, [r1]
	add r1, r3, #0
	add r1, #0x2d
	add r0, r0, #1
	add r3, #0xc
	strb r2, [r1]
	cmp r0, #3
	blt _0221C06A
	add r0, r4, #0
	add r0, #0xc0
	ldrb r1, [r5]
	ldr r0, [r0]
	mov r3, #1
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0xc0
	ldrb r1, [r5, #1]
	ldr r0, [r0]
	strb r1, [r0, #1]
	add r0, r4, #0
	add r0, #0xc0
	ldrh r1, [r5, #2]
	ldr r0, [r0]
	strh r1, [r0, #2]
	add r0, r4, #0
	add r0, #0xc0
	ldr r1, [r5, #4]
	ldr r0, [r0]
	str r1, [r0, #4]
	add r0, r4, #0
	add r0, #0xc0
	ldrh r1, [r5, #8]
	ldr r0, [r0]
	strh r1, [r0, #8]
	add r0, r4, #0
	add r0, #0xc0
	ldrh r1, [r5, #0xc]
	ldr r0, [r0]
	strh r1, [r0, #0xa]
	add r0, r4, #0
	add r0, #0xc0
	ldr r1, [r5, #0x10]
	ldr r0, [r0]
	str r1, [r0, #0xc]
	add r0, r4, #0
	add r0, #0xc0
	ldrh r1, [r5, #0xa]
	ldr r0, [r0]
	strh r1, [r0, #0x10]
	add r0, r4, #0
	add r0, #0xc0
	ldr r1, [r5, #0x54]
	ldr r0, [r0]
	strh r1, [r0, #0x12]
	add r0, r4, #0
	add r0, #0xc0
	ldrh r1, [r5, #0x14]
	ldr r0, [r0]
	strh r1, [r0, #0x14]
	add r0, r4, #0
	add r0, #0xc0
	ldrh r1, [r5, #0x16]
	ldr r0, [r0]
	strh r1, [r0, #0x16]
	add r0, r4, #0
	add r0, #0xc0
	ldr r2, [r0]
	mov r0, #0x46
	lsl r0, r0, #2
	ldr r1, [r2, r0]
	bic r1, r3
	ldrh r3, [r5, #0xe]
	lsl r3, r3, #0x1e
	lsr r6, r3, #0x1f
	mov r3, #1
	and r3, r6
	orr r1, r3
	str r1, [r2, r0]
	add r1, r4, #0
	add r1, #0xc0
	ldr r2, [r1]
	mov r3, #2
	ldr r1, [r2, r0]
	bic r1, r3
	ldrh r3, [r5, #0xe]
	lsl r3, r3, #0x1d
	lsr r3, r3, #0x1f
	lsl r3, r3, #0x1f
	lsr r3, r3, #0x1e
	orr r1, r3
	str r1, [r2, r0]
	add r1, r4, #0
	add r1, #0xc0
	ldr r2, [r1]
	mov r3, #4
	ldr r1, [r2, r0]
	bic r1, r3
	ldrh r3, [r5, #0xe]
	lsl r3, r3, #0x1c
	lsr r3, r3, #0x1f
	lsl r3, r3, #0x1f
	lsr r3, r3, #0x1d
	orr r1, r3
	str r1, [r2, r0]
	ldr r0, [sp, #4]
	ldr r1, [r0]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	str r1, [r0]
	ldr r0, [sp, #4]
	ldr r0, [r0]
	cmp r0, #0
	bne _0221C15C
	bl GF_AssertFail
_0221C15C:
	ldr r0, [sp, #4]
	mov r2, #0
	ldr r1, [r0, #4]
	add r0, r4, #0
	add r0, #0xc4
	str r1, [r0]
	ldr r0, [sp, #4]
	add r7, r2, #0
	ldr r1, [r0, #8]
	add r0, r4, #0
	add r0, #0xc8
	str r1, [r0]
	ldr r0, [sp, #4]
	ldr r1, [r0, #0x30]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xd4
	str r1, [r0]
	ldr r0, [sp, #4]
	add r1, r2, #0
	add r3, r0, #0
	mov ip, r3
_0221C18A:
	add r5, r4, #0
	add r5, #0xc0
	ldr r5, [r5]
	ldr r3, [r0, #0xc]
	add r5, r5, r1
	add r5, #0xb0
	str r3, [r5]
	ldr r3, [sp, #4]
	add r5, r4, #0
	add r5, #0xc0
	add r6, r3, r2
	ldr r5, [r5]
	ldrb r3, [r6, #0x1c]
	add r5, r5, r2
	add r5, #0xc0
	strb r3, [r5]
	add r5, r4, #0
	add r5, #0xc0
	ldr r5, [r5]
	ldr r3, [r0, #0x20]
	add r5, r5, r1
	add r5, #0xc4
	str r3, [r5]
	add r5, r4, #0
	add r5, #0xc0
	mov r3, ip
	ldr r5, [r5]
	ldrh r3, [r3, #0x34]
	add r5, r5, r7
	add r5, #0xd8
	strh r3, [r5]
	add r5, r4, #0
	add r3, r6, #0
	add r5, #0xc0
	add r3, #0x3c
	ldr r5, [r5]
	ldrb r3, [r3]
	add r5, r5, r2
	add r5, #0xe0
	strb r3, [r5]
	add r3, r6, #0
	add r5, r4, #0
	add r5, #0xc0
	add r3, #0x40
	ldr r5, [r5]
	ldrb r3, [r3]
	add r5, r5, r2
	add r5, #0xe4
	strb r3, [r5]
	add r5, r4, #0
	add r5, #0xc0
	add r6, #0x44
	ldr r5, [r5]
	ldrb r3, [r6]
	add r5, r5, r2
	add r5, #0xe8
	strb r3, [r5]
	add r5, r4, #0
	add r5, #0xc0
	ldr r5, [r5]
	ldr r3, [r0, #0x48]
	add r5, r5, r1
	add r5, #0xec
	str r3, [r5]
	add r5, r4, #0
	add r5, #0xc0
	ldr r5, [r5]
	ldr r3, [r0, #0x58]
	add r5, r5, r1
	add r5, #0xfc
	str r3, [r5]
	mov r3, ip
	add r3, r3, #2
	add r2, r2, #1
	add r0, r0, #4
	add r1, r1, #4
	add r7, r7, #2
	mov ip, r3
	cmp r2, #4
	blt _0221C18A
	ldr r5, [sp, #4]
	mov r2, #0x19
	lsl r2, r2, #4
	add r5, #0x6c
	add r3, r4, r2
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [sp, #4]
	add r0, #0x84
	ldr r3, [r0]
	add r0, r4, #0
	add r0, #0xc0
	ldr r1, [r0]
	add r0, r2, #0
	sub r0, #0x84
	str r3, [r1, r0]
	ldr r0, [sp, #4]
	add r0, #0x8c
	ldr r3, [r0]
	add r0, r4, #0
	add r0, #0xc0
	ldr r1, [r0]
	add r0, r2, #0
	sub r0, #0x7c
	str r3, [r1, r0]
	ldr r0, [sp, #4]
	add r0, #0x88
	ldr r3, [r0]
	add r0, r4, #0
	add r0, #0xc0
	ldr r1, [r0]
	add r0, r2, #0
	sub r0, #0x80
	str r3, [r1, r0]
	ldr r0, [sp]
	sub r2, #0x6e
	cmp r0, r2
	bne _0221C2AA
	ldr r5, _0221C37C ; =ov07_02234C64
	add r3, sp, #8
	mov r2, #0xc
_0221C284:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0221C284
	ldr r0, [r5]
	str r0, [r3]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	ldrh r0, [r0, #0x12]
	cmp r0, #0x18
	blo _0221C2A2
	mov r0, #0xa1
	str r0, [sp]
	b _0221C2AA
_0221C2A2:
	lsl r1, r0, #2
	add r0, sp, #8
	ldr r0, [r0, r1]
	str r0, [sp]
_0221C2AA:
	ldr r0, [sp]
	cmp r0, #0
	beq _0221C2B6
	ldr r1, _0221C380 ; =0x000001D3
	cmp r0, r1
	ble _0221C2BA
_0221C2B6:
	mov r0, #1
	str r0, [sp]
_0221C2BA:
	ldr r0, [sp, #4]
	ldr r0, [r0, #0x68]
	str r0, [r4, #4]
	ldr r1, [sp]
	ldr r2, [r4]
	bl AllocAndReadWholeNarcMemberByIdPair
	str r0, [r4, #0x14]
	cmp r0, #0
	bne _0221C2DA
	bne _0221C2D4
	bl GF_AssertFail
_0221C2D4:
	add sp, #0x6c
	mov r0, #0
	pop {r4, r5, r6, r7, pc}
_0221C2DA:
	str r0, [r4, #0x18]
	add r0, r4, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #0
	bl GetBgPriority
	mov r1, #0x6b
	lsl r1, r1, #2
	strb r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #1
	bl GetBgPriority
	ldr r1, _0221C384 ; =0x000001AD
	strb r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #2
	bl GetBgPriority
	ldr r1, _0221C388 ; =0x000001AE
	strb r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #3
	bl GetBgPriority
	ldr r1, _0221C38C ; =0x000001AF
	mov r2, #0
	strb r0, [r4, r1]
	add r1, r4, #0
	add r5, r2, #0
_0221C324:
	add r0, r1, #0
	add r0, #0xdc
	add r2, r2, #1
	add r1, r1, #4
	str r5, [r0]
	cmp r2, #0xa
	blt _0221C324
	mov r0, #0x4f
	lsl r0, r0, #2
	add r1, r0, #0
	add r2, r4, #0
	mov r3, #0
	add r1, #0x14
_0221C33E:
	str r3, [r2, r0]
	str r3, [r2, r1]
	add r5, r5, #1
	add r2, r2, #4
	cmp r5, #5
	blt _0221C33E
	mov r0, #6
	add r1, r4, #0
	mov r2, #0
	lsl r0, r0, #6
_0221C352:
	add r3, r3, #1
	str r2, [r1, r0]
	add r1, r1, #4
	cmp r3, #4
	blt _0221C352
	add r0, r4, #0
	ldr r1, _0221C390 ; =ov07_0221BE44
	add r0, #0xbc
	str r1, [r0]
	add r0, r4, #0
	add r0, #0x8d
	mov r1, #0xff
	strb r2, [r0]
	add r0, r1, #0
	add r0, #0xa9
	str r1, [r4, r0]
	mov r0, #1
	str r0, [r4, #0x10]
	add sp, #0x6c
	pop {r4, r5, r6, r7, pc}
	nop
_0221C37C: .word ov07_02234C64
_0221C380: .word 0x000001D3
_0221C384: .word 0x000001AD
_0221C388: .word 0x000001AE
_0221C38C: .word 0x000001AF
_0221C390: .word ov07_0221BE44
	thumb_func_end ov07_0221C01C

	thumb_func_start ov07_0221C394
ov07_0221C394: ; 0x0221C394
	push {r4, lr}
	add r4, r0, #0
	bl ov07_0221C3DC
	cmp r0, #0
	bne _0221C3A4
	mov r0, #0
	pop {r4, pc}
_0221C3A4:
	add r0, r4, #0
	add r4, #0xbc
	ldr r1, [r4]
	blx r1
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov07_0221C394

	thumb_func_start ov07_0221C3B0
ov07_0221C3B0: ; 0x0221C3B0
	ldr r0, [r0, #0x10]
	cmp r0, #1
	bne _0221C3BA
	mov r0, #1
	bx lr
_0221C3BA:
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221C3B0

	thumb_func_start ov07_0221C3C0
ov07_0221C3C0: ; 0x0221C3C0
	push {r3, lr}
	ldr r0, [r0, #0x14]
	cmp r0, #0
	bne _0221C3D2
	bne _0221C3CE
	bl GF_AssertFail
_0221C3CE:
	mov r0, #0
	pop {r3, pc}
_0221C3D2:
	bl Heap_Free
	mov r0, #1
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov07_0221C3C0

	thumb_func_start ov07_0221C3DC
ov07_0221C3DC: ; 0x0221C3DC
	cmp r0, #0
	bne _0221C3E4
	mov r0, #0
	bx lr
_0221C3E4:
	ldr r0, [r0, #0xc]
	cmp r0, #1
	bne _0221C3EE
	mov r0, #1
	bx lr
_0221C3EE:
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221C3DC

	thumb_func_start ov07_0221C3F4
ov07_0221C3F4: ; 0x0221C3F4
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r6, r0, #0
	add r5, r1, #0
	add r4, r2, #0
	str r3, [sp]
	mov r0, #1
	add r1, r6, #0
	add r2, r5, #0
	add r3, r4, #0
	bl ov07_0221BE68
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov07_0221C3F4

	thumb_func_start ov07_0221C410
ov07_0221C410: ; 0x0221C410
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, _0221C428 ; =0x0000044C
	add r4, r1, #0
	add r3, r2, #0
	str r0, [sp]
	mov r0, #1
	add r1, r5, #0
	add r2, r4, #0
	bl ov07_0221BE68
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221C428: .word 0x0000044C
	thumb_func_end ov07_0221C410

	thumb_func_start ov07_0221C42C
ov07_0221C42C: ; 0x0221C42C
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r6, r0, #0
	add r5, r1, #0
	add r4, r2, #0
	str r3, [sp]
	mov r0, #2
	add r1, r6, #0
	add r2, r5, #0
	add r3, r4, #0
	bl ov07_0221BE68
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov07_0221C42C

	thumb_func_start ov07_0221C448
ov07_0221C448: ; 0x0221C448
	add r3, r0, #0
	add r2, r1, #0
	add r1, r3, #0
	ldr r3, _0221C454 ; =ov07_0221BEA4
	mov r0, #1
	bx r3
	.balign 4, 0
_0221C454: .word ov07_0221BEA4
	thumb_func_end ov07_0221C448

	thumb_func_start ov07_0221C458
ov07_0221C458: ; 0x0221C458
	add r3, r0, #0
	add r2, r1, #0
	add r1, r3, #0
	ldr r3, _0221C464 ; =ov07_0221BEA4
	mov r0, #2
	bx r3
	.balign 4, 0
_0221C464: .word ov07_0221BEA4
	thumb_func_end ov07_0221C458

	thumb_func_start ov07_0221C468
ov07_0221C468: ; 0x0221C468
	add r0, #0xc0
	ldr r0, [r0]
	ldrh r0, [r0, #0x14]
	bx lr
	thumb_func_end ov07_0221C468

	thumb_func_start ov07_0221C470
ov07_0221C470: ; 0x0221C470
	add r0, #0xc0
	ldr r0, [r0]
	ldrh r0, [r0, #0x16]
	bx lr
	thumb_func_end ov07_0221C470

	thumb_func_start ov07_0221C478
ov07_0221C478: ; 0x0221C478
	add r0, #0xc0
	ldr r1, [r0]
	ldr r0, [r1, #0x18]
	lsl r0, r0, #2
	add r0, r1, r0
	ldr r0, [r0, #0x1c]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221C478

	thumb_func_start ov07_0221C488
ov07_0221C488: ; 0x0221C488
	add r0, #0xc0
	ldr r2, [r0]
	lsl r0, r1, #2
	add r0, r2, r0
	ldr r0, [r0, #0x1c]
	bx lr
	thumb_func_end ov07_0221C488

	thumb_func_start ov07_0221C494
ov07_0221C494: ; 0x0221C494
	add r0, #0xc0
	ldr r2, [r0]
	lsl r0, r1, #2
	add r0, r2, r0
	ldr r0, [r0, #0x5c]
	bx lr
	thumb_func_end ov07_0221C494

	thumb_func_start ov07_0221C4A0
ov07_0221C4A0: ; 0x0221C4A0
	add r0, #0xc4
	ldr r0, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221C4A0

	thumb_func_start ov07_0221C4A8
ov07_0221C4A8: ; 0x0221C4A8
	push {r3, r4, r5, lr}
	add r5, r1, #0
	add r4, r0, #0
	cmp r5, #0xa
	blt _0221C4B6
	bl GF_AssertFail
_0221C4B6:
	lsl r0, r5, #2
	add r0, r4, r0
	add r0, #0x94
	ldr r0, [r0]
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221C4A8

	thumb_func_start ov07_0221C4C0
ov07_0221C4C0: ; 0x0221C4C0
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #0xa
	blt _0221C4CE
	bl GF_AssertFail
_0221C4CE:
	cmp r5, #0
	bne _0221C4D6
	bl GF_AssertFail
_0221C4D6:
	add r5, #0xdc
	lsl r4, r4, #2
	ldr r0, [r5, r4]
	cmp r0, #0
	bne _0221C4E4
	bl GF_AssertFail
_0221C4E4:
	ldr r0, [r5, r4]
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221C4C0

	thumb_func_start ov07_0221C4E8
ov07_0221C4E8: ; 0x0221C4E8
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #5
	blt _0221C4F6
	bl GF_AssertFail
_0221C4F6:
	cmp r5, #0
	bne _0221C4FE
	bl GF_AssertFail
_0221C4FE:
	mov r0, #0x4f
	lsl r0, r0, #2
	add r5, r5, r0
	lsl r4, r4, #2
	ldr r0, [r5, r4]
	cmp r0, #0
	bne _0221C510
	bl GF_AssertFail
_0221C510:
	ldr r0, [r5, r4]
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221C4E8

	thumb_func_start ov07_0221C514
ov07_0221C514: ; 0x0221C514
	push {r4, lr}
	add r4, r0, #0
	bne _0221C51E
	bl GF_AssertFail
_0221C51E:
	mov r0, #0x4e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221C514

	thumb_func_start ov07_0221C528
ov07_0221C528: ; 0x0221C528
	add r0, #0xcc
	ldr r0, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221C528

	thumb_func_start ov07_0221C530
ov07_0221C530: ; 0x0221C530
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221C530

	thumb_func_start ov07_0221C53C
ov07_0221C53C: ; 0x0221C53C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	mov r1, #0x3c
	bl Heap_Alloc
	add r4, r0, #0
	bne _0221C554
	bl GF_AssertFail
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221C554:
	mov r1, #0
	mov r2, #0x3c
	bl memset
	add r0, r5, #0
	add r0, #0x90
	ldrh r0, [r0]
	add r5, #0x90
	add r0, r0, #1
	strh r0, [r5]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221C53C

	thumb_func_start ov07_0221C56C
ov07_0221C56C: ; 0x0221C56C
	ldr r3, _0221C578 ; =SysTask_CreateOnMainQueue
	str r0, [r1, #0x38]
	ldr r0, _0221C57C ; =ov07_0221C584
	ldr r2, _0221C580 ; =0x0000044C
	bx r3
	nop
_0221C578: .word SysTask_CreateOnMainQueue
_0221C57C: .word ov07_0221C584
_0221C580: .word 0x0000044C
	thumb_func_end ov07_0221C56C

	thumb_func_start ov07_0221C584
ov07_0221C584: ; 0x0221C584
	push {r3, r4, r5, lr}
	add r4, r1, #0
	ldrb r1, [r4]
	add r5, r0, #0
	add r0, r4, #0
	lsl r2, r1, #2
	ldr r1, _0221C5C0 ; =ov07_02234C08
	ldr r1, [r1, r2]
	blx r1
	cmp r0, #0
	bne _0221C5BE
	ldr r0, [r4, #0x38]
	add r1, r0, #0
	add r1, #0x90
	ldrh r1, [r1]
	cmp r1, #0
	beq _0221C5B2
	add r1, r0, #0
	add r1, #0x90
	ldrh r1, [r1]
	add r0, #0x90
	sub r1, r1, #1
	strh r1, [r0]
_0221C5B2:
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
_0221C5BE:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221C5C0: .word ov07_02234C08
	thumb_func_end ov07_0221C584

	thumb_func_start ov07_0221C5C4
ov07_0221C5C4: ; 0x0221C5C4
	mov r0, #0
	bx lr
	thumb_func_end ov07_0221C5C4

	thumb_func_start ov07_0221C5C8
ov07_0221C5C8: ; 0x0221C5C8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldrb r1, [r5, #4]
	add r0, r1, #1
	strb r0, [r5, #4]
	ldrb r0, [r5, #3]
	cmp r1, r0
	bhs _0221C5DC
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221C5DC:
	mov r0, #0
	strb r0, [r5, #4]
	ldr r2, [r5, #0x14]
	ldr r1, [r5, #0x10]
	mov r4, #1
	add r1, r2, r1
	str r1, [r5, #0x14]
	ldr r1, [r5, #0x10]
	cmp r1, #0
	bne _0221C5F4
	add r4, r0, #0
	b _0221C60C
_0221C5F4:
	ldr r2, [r5, #0xc]
	ldr r1, [r5, #8]
	cmp r1, r2
	ldr r1, [r5, #0x14]
	bge _0221C606
	cmp r1, r2
	blt _0221C60C
	add r4, r0, #0
	b _0221C60C
_0221C606:
	cmp r1, r2
	bgt _0221C60C
	add r4, r0, #0
_0221C60C:
	ldr r0, [r5, #0x14]
	bl sub_020061EC
	ldrh r0, [r5, #0x1a]
	bl IsSEPlaying
	cmp r0, #0
	bne _0221C61E
	mov r4, #0
_0221C61E:
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov07_0221C5C8

	thumb_func_start ov07_0221C624
ov07_0221C624: ; 0x0221C624
	ldr r3, _0221C628 ; =ov07_0221C5C8
	bx r3
	.balign 4, 0
_0221C628: .word ov07_0221C5C8
	thumb_func_end ov07_0221C624

	thumb_func_start ov07_0221C62C
ov07_0221C62C: ; 0x0221C62C
	ldr r3, _0221C630 ; =ov07_0221C5C8
	bx r3
	.balign 4, 0
_0221C630: .word ov07_0221C5C8
	thumb_func_end ov07_0221C62C

	thumb_func_start ov07_0221C634
ov07_0221C634: ; 0x0221C634
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldrb r1, [r5, #4]
	add r0, r1, #1
	strb r0, [r5, #4]
	ldrb r0, [r5, #3]
	cmp r1, r0
	bhs _0221C648
	mov r0, #1
	pop {r3, r4, r5, pc}
_0221C648:
	mov r0, #0
	strb r0, [r5, #4]
	ldrb r0, [r5, #0x18]
	mov r4, #1
	sub r0, r0, #1
	strb r0, [r5, #0x18]
	ldrh r0, [r5, #0x1a]
	bl PlaySE
	ldrh r0, [r5, #0x1a]
	ldr r1, _0221C670 ; =0x0000FFFF
	ldr r2, [r5, #0x14]
	bl sub_020061B4
	ldrb r0, [r5, #0x18]
	cmp r0, #0
	bne _0221C66C
	mov r4, #0
_0221C66C:
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221C670: .word 0x0000FFFF
	thumb_func_end ov07_0221C634

	thumb_func_start ov07_0221C674
ov07_0221C674: ; 0x0221C674
	push {r4, lr}
	add r4, r0, #0
	ldrb r2, [r4, #3]
	mov r0, #1
	sub r1, r2, #1
	strb r1, [r4, #3]
	cmp r2, #0
	bne _0221C696
	ldrh r0, [r4, #0x1a]
	bl PlaySE
	ldrh r0, [r4, #0x1a]
	ldr r1, _0221C698 ; =0x0000FFFF
	ldr r2, [r4, #0x14]
	bl sub_020061B4
	mov r0, #0
_0221C696:
	pop {r4, pc}
	.balign 4, 0
_0221C698: .word 0x0000FFFF
	thumb_func_end ov07_0221C674

	thumb_func_start ov07_0221C69C
ov07_0221C69C: ; 0x0221C69C
	push {r3, lr}
	ldr r0, _0221C6B0 ; =0x04000050
	mov r3, #8
	mov r1, #0
	mov r2, #0x3f
	str r3, [sp]
	bl G2x_SetBlendAlpha_
	pop {r3, pc}
	nop
_0221C6B0: .word 0x04000050
	thumb_func_end ov07_0221C69C

	thumb_func_start ov07_0221C6B4
ov07_0221C6B4: ; 0x0221C6B4
	push {r3, r4}
	add r2, r0, #0
	mov r1, #1
	add r2, #0x8d
	strb r1, [r2]
	ldr r3, _0221C6E8 ; =gSystem
	lsl r2, r1, #9
	ldr r4, [r3, #0x44]
	tst r2, r4
	beq _0221C6E4
	add r2, r1, #0
	add r2, #0xff
	tst r2, r4
	beq _0221C6E4
	ldr r2, [r3, #0x48]
	lsl r1, r1, #0xa
	tst r1, r2
	beq _0221C6E4
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	mov r1, #0
	add r0, #0x8d
	strb r1, [r0]
_0221C6E4:
	pop {r3, r4}
	bx lr
	.balign 4, 0
_0221C6E8: .word gSystem
	thumb_func_end ov07_0221C6B4

	thumb_func_start ov07_0221C6EC
ov07_0221C6EC: ; 0x0221C6EC
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r0, #0
	add r1, #0x8d
	strb r2, [r1]
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r1, _0221C708 ; =ov07_0221BE20
	add r0, #0xbc
	str r1, [r0]
	bx lr
	.balign 4, 0
_0221C708: .word ov07_0221BE20
	thumb_func_end ov07_0221C6EC

	thumb_func_start ov07_0221C70C
ov07_0221C70C: ; 0x0221C70C
	add r1, r0, #0
	add r1, #0x8e
	ldrh r1, [r1]
	cmp r1, #0
	bne _0221C724
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	mov r1, #0
	add r0, #0x8d
	strb r1, [r0]
	bx lr
_0221C724:
	mov r1, #1
	add r0, #0x8d
	strb r1, [r0]
	bx lr
	thumb_func_end ov07_0221C70C

	thumb_func_start ov07_0221C72C
ov07_0221C72C: ; 0x0221C72C
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r3, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	cmp r3, #0xa
	bhs _0221C74A
	lsl r1, r3, #2
	add r0, r0, r1
	add r0, #0x94
	str r2, [r0]
_0221C74A:
	bx lr
	thumb_func_end ov07_0221C72C

	thumb_func_start ov07_0221C74C
ov07_0221C74C: ; 0x0221C74C
	ldr r1, [r0, #0x18]
	mov r3, #0
	add r1, r1, #4
	str r1, [r0, #0x18]
	add r2, r3, #0
_0221C756:
	add r1, r0, #0
	add r1, #0x94
	add r3, r3, #1
	add r0, r0, #4
	str r2, [r1]
	cmp r3, #0xa
	blt _0221C756
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221C74C

	thumb_func_start ov07_0221C768
ov07_0221C768: ; 0x0221C768
	cmp r1, #5
	bhi _0221C7B4
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221C778: ; jump table
	.short _0221C784 - _0221C778 - 2 ; case 0
	.short _0221C78C - _0221C778 - 2 ; case 1
	.short _0221C794 - _0221C778 - 2 ; case 2
	.short _0221C79C - _0221C778 - 2 ; case 3
	.short _0221C7A4 - _0221C778 - 2 ; case 4
	.short _0221C7AC - _0221C778 - 2 ; case 5
_0221C784:
	add r0, #0xc0
	ldr r0, [r0]
	ldr r0, [r0, #4]
	bx lr
_0221C78C:
	add r0, #0xc0
	ldr r0, [r0]
	ldrh r0, [r0, #8]
	bx lr
_0221C794:
	add r0, #0xc0
	ldr r0, [r0]
	ldrh r0, [r0, #0xa]
	bx lr
_0221C79C:
	add r0, #0xc0
	ldr r0, [r0]
	ldr r0, [r0, #0xc]
	bx lr
_0221C7A4:
	add r0, #0xc0
	ldr r0, [r0]
	ldrh r0, [r0, #0x10]
	bx lr
_0221C7AC:
	add r0, #0xc0
	ldr r0, [r0]
	ldrh r0, [r0, #0x12]
	bx lr
_0221C7B4:
	mov r0, #0
	bx lr
	thumb_func_end ov07_0221C768

	thumb_func_start ov07_0221C7B8
ov07_0221C7B8: ; 0x0221C7B8
	push {r3, r4, r5, r6, r7, lr}
	add r3, r0, #0
	mov r0, #0
	str r2, [sp]
	add r6, r0, #0
	add r5, r1, #0
	mov ip, r0
	add r7, r1, #0
_0221C7C8:
	add r2, r3, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r2, r2, r6
	add r2, #0xb0
	ldr r2, [r2]
	str r2, [r5, #8]
	add r2, r3, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r2, r2, r6
	add r2, #0xc4
	ldr r2, [r2]
	str r2, [r5, #0x18]
	add r2, r3, #0
	add r2, #0xc0
	ldr r4, [r2]
	mov r2, ip
	add r2, r4, r2
	add r2, #0xd8
	ldrh r2, [r2]
	strh r2, [r7, #0x28]
	add r2, r3, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r7, r7, #2
	add r2, r2, r0
	add r2, #0xe0
	ldrb r4, [r2]
	add r2, r1, r0
	add r2, #0x30
	strb r4, [r2]
	add r2, r3, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r2, r2, r0
	add r2, #0xe4
	ldrb r4, [r2]
	add r2, r1, r0
	add r2, #0x34
	strb r4, [r2]
	add r2, r3, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r2, r2, r0
	add r2, #0xe8
	ldrb r4, [r2]
	add r2, r1, r0
	add r2, #0x38
	strb r4, [r2]
	add r2, r3, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r2, r2, r6
	add r2, #0xec
	ldr r2, [r2]
	add r6, r6, #4
	str r2, [r5, #0x3c]
	add r2, r3, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r5, r5, #4
	add r2, r2, r0
	add r2, #0xc0
	ldrb r4, [r2]
	add r2, r1, r0
	add r2, #0x4c
	strb r4, [r2]
	mov r2, ip
	add r2, r2, #2
	add r0, r0, #1
	mov ip, r2
	cmp r0, #4
	blt _0221C7C8
	ldr r0, [sp]
	cmp r0, #3
	bhi _0221C8C6
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221C86E: ; jump table
	.short _0221C876 - _0221C86E - 2 ; case 0
	.short _0221C88A - _0221C86E - 2 ; case 1
	.short _0221C89E - _0221C86E - 2 ; case 2
	.short _0221C8B2 - _0221C86E - 2 ; case 3
_0221C876:
	add r0, r3, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r3, #0xc0
	ldrh r0, [r0, #0x14]
	str r0, [r1]
	ldr r0, [r3]
	ldrh r0, [r0, #0x16]
	str r0, [r1, #4]
	pop {r3, r4, r5, r6, r7, pc}
_0221C88A:
	add r0, r3, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r3, #0xc0
	ldrh r0, [r0, #0x14]
	str r0, [r1]
	ldr r0, [r3]
	ldrh r0, [r0, #0x14]
	str r0, [r1, #4]
	pop {r3, r4, r5, r6, r7, pc}
_0221C89E:
	add r0, r3, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r3, #0xc0
	ldrh r0, [r0, #0x14]
	str r0, [r1]
	ldr r0, [r3]
	ldrh r0, [r0, #0x14]
	str r0, [r1, #4]
	pop {r3, r4, r5, r6, r7, pc}
_0221C8B2:
	add r0, r3, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r3, #0xc0
	ldrh r0, [r0, #0x14]
	str r0, [r1]
	ldr r0, [r3]
	ldrh r0, [r0, #0x14]
	str r0, [r1, #4]
	pop {r3, r4, r5, r6, r7, pc}
_0221C8C6:
	bl GF_AssertFail
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov07_0221C7B8

	thumb_func_start ov07_0221C8CC
ov07_0221C8CC: ; 0x0221C8CC
	push {r3, r4, r5, lr}
	sub sp, #0x50
	add r5, r0, #0
	ldr r1, [r5, #0x18]
	add r1, r1, #4
	str r1, [r5, #0x18]
	ldr r4, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	add r1, sp, #0
	add r2, r4, #0
	bl ov07_0221C7B8
	cmp r4, #2
	add r0, sp, #0
	bne _0221C8F6
	ldr r1, [r5]
	bl ov07_02234A20
	add sp, #0x50
	pop {r3, r4, r5, pc}
_0221C8F6:
	cmp r4, #3
	bne _0221C904
	ldr r1, [r5]
	bl ov07_0223475C
	add sp, #0x50
	pop {r3, r4, r5, pc}
_0221C904:
	ldr r1, [r5]
	bl ov07_0223474C
	add sp, #0x50
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov07_0221C8CC

	thumb_func_start ov07_0221C910
ov07_0221C910: ; 0x0221C910
	push {r4, lr}
	sub sp, #0x50
	add r4, r0, #0
	ldr r1, [r4, #0x18]
	add r1, r1, #4
	str r1, [r4, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r4, #0x18]
	add r1, sp, #0
	bl ov07_0221C7B8
	ldr r1, [r4]
	add r0, sp, #0
	bl ov07_0223494C
	add sp, #0x50
	pop {r4, pc}
	thumb_func_end ov07_0221C910

	thumb_func_start ov07_0221C934
ov07_0221C934: ; 0x0221C934
	ldr r1, [r0, #0x18]
	mov r2, #0
	add r1, r1, #4
	str r1, [r0, #0x18]
	add r3, r0, #0
_0221C93E:
	ldr r1, [r3, #0x30]
	cmp r1, #1
	beq _0221C96A
	mov r1, #0xc
	mul r1, r2
	mov r2, #1
	add r1, r0, r1
	str r2, [r1, #0x30]
	add r2, r1, #0
	mov r3, #0
	add r2, #0x2c
	strb r3, [r2]
	ldr r2, [r0, #0x18]
	ldr r3, [r2]
	add r2, r1, #0
	add r2, #0x2d
	strb r3, [r2]
	ldr r2, [r0, #0x18]
	add r2, r2, #4
	str r2, [r0, #0x18]
	str r2, [r1, #0x28]
	bx lr
_0221C96A:
	add r2, r2, #1
	add r3, #0xc
	cmp r2, #3
	blt _0221C93E
	bx lr
	thumb_func_end ov07_0221C934

	thumb_func_start ov07_0221C974
ov07_0221C974: ; 0x0221C974
	push {r3, r4}
	ldr r1, [r0, #0x18]
	add r3, r0, #0
	add r1, r1, #4
	add r3, #0x18
	str r1, [r0, #0x18]
	mov r2, #2
_0221C982:
	ldr r1, [r3, #0x30]
	cmp r1, #0
	beq _0221C9B6
	add r4, r2, #0
	mov r1, #0xc
	add r2, r0, #0
	mul r4, r1
	add r2, #0x2c
	ldrb r1, [r2, r4]
	add r1, r1, #1
	strb r1, [r2, r4]
	ldrb r3, [r2, r4]
	add r2, r0, r4
	add r1, r2, #0
	add r1, #0x2d
	ldrb r1, [r1]
	cmp r3, r1
	bne _0221C9AE
	mov r0, #0
	str r0, [r2, #0x30]
	pop {r3, r4}
	bx lr
_0221C9AE:
	ldr r1, [r2, #0x28]
	str r1, [r0, #0x18]
	pop {r3, r4}
	bx lr
_0221C9B6:
	sub r3, #0xc
	sub r2, r2, #1
	bpl _0221C982
	pop {r3, r4}
	bx lr
	thumb_func_end ov07_0221C974

	thumb_func_start ov07_0221C9C0
ov07_0221C9C0: ; 0x0221C9C0
	push {r3, r4, r5, r6, r7, lr}
	ldr r1, _0221CBAC ; =0x0000017E
	add r5, r0, #0
	ldrb r0, [r5, r1]
	mov r6, #0
	cmp r0, #1
	bhs _0221C9DE
	add r0, r5, #0
	mov r2, #1
	add r0, #0x8d
	strb r2, [r0]
	ldrb r0, [r5, r1]
	add r0, r0, #1
	strb r0, [r5, r1]
	pop {r3, r4, r5, r6, r7, pc}
_0221C9DE:
	add r7, r6, #0
	add r4, r6, #0
_0221C9E2:
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, r0, r4
	ldr r0, [r0, #0x1c]
	cmp r0, #0
	beq _0221C9F6
	bl sub_020154B0
	add r6, r6, r0
_0221C9F6:
	add r7, r7, #1
	add r4, r4, #4
	cmp r7, #0x10
	blt _0221C9E2
	cmp r6, #0
	bne _0221CA16
	add r0, r5, #0
	add r0, #0x8e
	ldrh r0, [r0]
	cmp r0, #0
	bne _0221CA16
	add r0, r5, #0
	add r0, #0x90
	ldrh r0, [r0]
	cmp r0, #0
	beq _0221CA26
_0221CA16:
	add r0, r5, #0
	mov r1, #1
	add r0, #0x8d
	strb r1, [r0]
	ldr r0, _0221CBB0 ; =0x0000017D
	mov r1, #0
	strb r1, [r5, r0]
	pop {r3, r4, r5, r6, r7, pc}
_0221CA26:
	bl GF_IsAnySEPlaying
	cmp r0, #0
	beq _0221CA50
	ldr r0, _0221CBB0 ; =0x0000017D
	ldrb r1, [r5, r0]
	add r1, r1, #1
	strb r1, [r5, r0]
	ldrb r1, [r5, r0]
	cmp r1, #0x5a
	bls _0221CA48
	mov r1, #0
	strb r1, [r5, r0]
	add r0, r5, #0
	add r0, #0x8d
	strb r1, [r0]
	b _0221CA50
_0221CA48:
	mov r0, #1
	add r5, #0x8d
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_0221CA50:
	ldr r0, _0221CBB0 ; =0x0000017D
	mov r1, #0
	strb r1, [r5, r0]
	add r0, r0, #1
	strb r1, [r5, r0]
	add r0, r5, #0
	add r2, r1, #0
_0221CA5E:
	add r1, r1, #1
	str r2, [r0, #0x1c]
	add r0, r0, #4
	cmp r1, #3
	blt _0221CA5E
	add r1, r5, #0
	mov r4, #0
_0221CA6C:
	add r0, r1, #0
	str r4, [r1, #0x28]
	add r0, #0x2c
	strb r4, [r0]
	add r0, r1, #0
	add r0, #0x2d
	strb r4, [r0]
	str r4, [r1, #0x30]
	add r2, r2, #1
	add r1, #0xc
	cmp r2, #3
	blt _0221CA6C
	add r7, r5, #0
	mov r6, #0
_0221CA88:
	add r0, r7, #0
	add r0, #0xcc
	ldr r1, [r0]
	cmp r1, #0
	beq _0221CAA0
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteSystem_FreeResourcesAndManager
_0221CAA0:
	add r0, r7, #0
	add r0, #0xcc
	add r4, r4, #1
	add r7, r7, #4
	str r6, [r0]
	cmp r4, #4
	blt _0221CA88
_0221CAAE:
	add r0, r5, #0
	add r1, r6, #0
	bl ov07_0221D55C
	add r6, r6, #1
	cmp r6, #5
	blt _0221CAAE
	mov r6, #0
	add r4, r6, #0
	add r7, r6, #0
_0221CAC2:
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, r0, r4
	ldr r0, [r0, #0x1c]
	cmp r0, #0
	beq _0221CADE
	bl ov07_0221FF2C
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, r0, r4
	str r7, [r0, #0x1c]
_0221CADE:
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #0x10
	blt _0221CAC2
	mov r0, #6
	lsl r0, r0, #6
	add r0, r5, r0
	mov r1, #5
	bl ov07_0221DD14
	bl BattleSystem_SetDefaultBlend
	add r0, r5, #0
	mov r1, #1
	bl ov07_0221FAEC
	add r4, r0, #0
	add r0, r5, #0
	bl ov07_0221BFD0
	add r3, r0, #0
	lsl r0, r4, #0x18
	mov r1, #1
	lsr r0, r0, #0x18
	lsl r1, r1, #0xe
	mov r2, #0
	bl BG_ClearCharDataRange
	add r0, r5, #0
	bl ov07_0221C4A0
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #1
	bl ov07_0221FAEC
	add r1, r0, #0
	lsl r1, r1, #0x18
	add r0, r4, #0
	lsr r1, r1, #0x18
	bl BgClearTilemapBufferAndCommit
	mov r0, #2
	mov r1, #1
	bl ToggleBgLayer
	mov r1, #0x6b
	lsl r1, r1, #2
	ldrb r1, [r5, r1]
	mov r0, #0
	bl SetBgPriority
	ldr r1, _0221CBB4 ; =0x000001AD
	mov r0, #1
	ldrb r1, [r5, r1]
	bl SetBgPriority
	ldr r1, _0221CBB8 ; =0x000001AE
	mov r0, #2
	ldrb r1, [r5, r1]
	bl SetBgPriority
	ldr r1, _0221CBBC ; =0x000001AF
	mov r0, #3
	ldrb r1, [r5, r1]
	bl SetBgPriority
	add r0, r5, #0
	add r0, #0xc4
	mov r2, #0
	ldr r0, [r0]
	mov r1, #2
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r0, r5, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #2
	mov r2, #3
	mov r3, #0
	bl BgSetPosTextAndCommit
	add r0, r5, #0
	add r0, #0xc4
	mov r2, #0
	ldr r0, [r0]
	mov r1, #3
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	add r0, r5, #0
	add r0, #0xc4
	mov r1, #3
	ldr r0, [r0]
	add r2, r1, #0
	mov r3, #0
	bl BgSetPosTextAndCommit
	mov r0, #0
	str r0, [r5, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221CBAC: .word 0x0000017E
_0221CBB0: .word 0x0000017D
_0221CBB4: .word 0x000001AD
_0221CBB8: .word 0x000001AE
_0221CBBC: .word 0x000001AF
	thumb_func_end ov07_0221C9C0

	thumb_func_start ov07_0221CBC0
ov07_0221CBC0: ; 0x0221CBC0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r4, [r0]
	add r1, r0, #4
	str r1, [r5, #0x18]
	ldr r0, [r1]
	str r0, [sp]
	add r0, r1, #4
	str r0, [r5, #0x18]
	ldr r7, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	str r4, [r0, #0x18]
	add r0, r5, r4
	add r0, #0x7c
	ldrb r0, [r0]
	cmp r0, #0
	beq _0221CC1E
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	add r1, sp, #4
	bl sub_020154D4
	mov r0, #0
	ldr r1, [sp, #8]
	mvn r0, r0
	mul r0, r1
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, sp, #4
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	bl sub_020154E4
_0221CC1E:
	add r0, r5, #0
	add r0, #0xc0
	add r1, r5, r4
	add r1, #0x6c
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldrb r1, [r1]
	ldr r0, [r0, #0x1c]
	bl sub_02015528
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	ldr r1, [sp]
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	add r2, r7, #0
	add r3, r5, #0
	bl ov07_0221FF18
	add r5, #0xc0
	ldr r1, [r5]
	str r0, [r1, #0x5c]
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov07_0221CBC0

	thumb_func_start ov07_0221CC54
ov07_0221CC54: ; 0x0221CC54
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r4, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r7, [r0]
	add r1, r0, #4
	str r1, [r5, #0x18]
	ldr r0, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	str r0, [sp, #4]
	ldr r0, [r1]
	str r0, [sp]
	add r0, r1, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	str r4, [r0, #0x18]
	add r0, r5, r4
	add r0, #0x7c
	ldrb r0, [r0]
	cmp r0, #0
	beq _0221CCBA
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	add r1, sp, #8
	bl sub_020154D4
	mov r0, #0
	ldr r1, [sp, #0xc]
	mvn r0, r0
	mul r0, r1
	str r0, [sp, #0xc]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, sp, #8
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	bl sub_020154E4
_0221CCBA:
	add r0, r5, #0
	add r0, #0xc0
	add r1, r5, r4
	add r1, #0x6c
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldrb r1, [r1]
	ldr r0, [r0, #0x1c]
	bl sub_02015528
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	ldr r1, [sp, #4]
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	ldr r2, [sp]
	add r3, r5, #0
	bl ov07_0221FF18
	add r5, #0xc0
	ldr r2, [r5]
	lsl r1, r7, #2
	add r1, r2, r1
	str r0, [r1, #0x5c]
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov07_0221CC54

	thumb_func_start ov07_0221CCF4
ov07_0221CCF4: ; 0x0221CCF4
	push {r4, r5, r6, lr}
	sub sp, #0x90
	ldr r5, _0221CD48 ; =ov07_02234CC8
	add r4, r0, #0
	add r3, sp, #0
	mov r2, #0x12
_0221CD00:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0221CD00
	add r0, r4, #0
	bl ov07_0221C468
	add r5, r0, #0
	add r0, r4, #0
	bl ov07_0221C470
	add r6, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	bl ov07_02231924
	add r5, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	bl ov07_02231924
	mov r1, #0x18
	add r3, r5, #0
	mul r3, r1
	add r2, sp, #0
	lsl r1, r0, #2
	add r0, r2, r3
	ldr r4, [r1, r0]
	cmp r4, #0xff
	bne _0221CD40
	bl GF_AssertFail
_0221CD40:
	sub r0, r4, #1
	add sp, #0x90
	pop {r4, r5, r6, pc}
	nop
_0221CD48: .word ov07_02234CC8
	thumb_func_end ov07_0221CCF4

	thumb_func_start ov07_0221CD4C
ov07_0221CD4C: ; 0x0221CD4C
	push {r4, r5, r6, lr}
	sub sp, #0x90
	ldr r5, _0221CDA0 ; =ov07_02234D58
	add r4, r0, #0
	add r3, sp, #0
	mov r2, #0x12
_0221CD58:
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0221CD58
	add r0, r4, #0
	bl ov07_0221C468
	add r5, r0, #0
	add r0, r4, #0
	bl ov07_0221C470
	add r6, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	bl ov07_02231924
	add r5, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	bl ov07_02231924
	mov r1, #0x18
	add r3, r5, #0
	mul r3, r1
	add r2, sp, #0
	lsl r1, r0, #2
	add r0, r2, r3
	ldr r4, [r1, r0]
	cmp r4, #0xff
	bne _0221CD98
	bl GF_AssertFail
_0221CD98:
	add r0, r4, #0
	add sp, #0x90
	pop {r4, r5, r6, pc}
	nop
_0221CDA0: .word ov07_02234D58
	thumb_func_end ov07_0221CD4C

	thumb_func_start ov07_0221CDA4
ov07_0221CDA4: ; 0x0221CDA4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x28
	add r5, r0, #0
	ldr r1, [r5, #0x18]
	add r0, #0x18
	add r1, r1, #4
	str r1, [r5, #0x18]
	ldr r4, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	mov r1, #0
	add r2, sp, #0x10
_0221CDBC:
	ldr r3, [r5, #0x18]
	add r1, r1, #1
	ldr r3, [r3]
	str r3, [r2]
	ldr r3, [r0]
	add r2, r2, #4
	add r3, r3, #4
	str r3, [r0]
	cmp r1, #6
	blt _0221CDBC
	ldr r1, [r5, #0x18]
	ldr r1, [r1]
	str r1, [sp]
	ldr r1, [r0]
	add r1, r1, #4
	str r1, [r0]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	str r4, [r0, #0x18]
	add r0, r5, r4
	add r0, #0x7c
	ldrb r0, [r0]
	cmp r0, #0
	beq _0221CE1A
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	add r1, sp, #4
	bl sub_020154D4
	mov r0, #0
	ldr r1, [sp, #8]
	mvn r0, r0
	mul r0, r1
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, sp, #4
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	bl sub_020154E4
_0221CE1A:
	add r0, r5, #0
	bl ov07_0221CCF4
	add r7, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	add r1, r5, r4
	add r1, #0x6c
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldrb r1, [r1]
	ldr r0, [r0, #0x1c]
	bl sub_02015528
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r2, r7, #2
	add r0, r0, r6
	add r1, sp, #0x10
	ldr r1, [r1, r2]
	ldr r0, [r0, #0x1c]
	ldr r2, [sp]
	add r3, r5, #0
	bl ov07_0221FF18
	add r5, #0xc0
	ldr r1, [r5]
	str r0, [r1, #0x5c]
	add sp, #0x28
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov07_0221CDA4

	thumb_func_start ov07_0221CE5C
ov07_0221CE5C: ; 0x0221CE5C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x20
	add r5, r0, #0
	ldr r1, [r5, #0x18]
	add r0, #0x18
	add r1, r1, #4
	str r1, [r5, #0x18]
	ldr r4, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	mov r1, #0
	add r2, sp, #0x10
_0221CE74:
	ldr r3, [r5, #0x18]
	add r1, r1, #1
	ldr r3, [r3]
	str r3, [r2]
	ldr r3, [r0]
	add r2, r2, #4
	add r3, r3, #4
	str r3, [r0]
	cmp r1, #4
	blt _0221CE74
	ldr r1, [r5, #0x18]
	ldr r1, [r1]
	str r1, [sp]
	ldr r1, [r0]
	add r1, r1, #4
	str r1, [r0]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	str r4, [r0, #0x18]
	add r0, r5, r4
	add r0, #0x7c
	ldrb r0, [r0]
	cmp r0, #0
	beq _0221CED2
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	add r1, sp, #4
	bl sub_020154D4
	mov r0, #0
	ldr r1, [sp, #8]
	mvn r0, r0
	mul r0, r1
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, sp, #4
	add r0, r0, r6
	ldr r0, [r0, #0x1c]
	bl sub_020154E4
_0221CED2:
	add r0, r5, #0
	bl ov07_0221CD4C
	add r7, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	add r1, r5, r4
	add r1, #0x6c
	ldr r0, [r0]
	lsl r6, r4, #2
	add r0, r0, r6
	ldrb r1, [r1]
	ldr r0, [r0, #0x1c]
	bl sub_02015528
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r2, r7, #2
	add r0, r0, r6
	add r1, sp, #0x10
	ldr r1, [r1, r2]
	ldr r0, [r0, #0x1c]
	ldr r2, [sp]
	add r3, r5, #0
	bl ov07_0221FF18
	add r5, #0xc0
	ldr r1, [r5]
	str r0, [r1, #0x5c]
	add sp, #0x20
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov07_0221CE5C

	thumb_func_start ov07_0221CF14
ov07_0221CF14: ; 0x0221CF14
	push {r3, r4, r5, r6, r7, lr}
	mov r6, #0
	add r5, r0, #0
	add r7, r6, #0
	add r4, r6, #0
_0221CF1E:
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, r0, r4
	ldr r0, [r0, #0x1c]
	cmp r0, #0
	beq _0221CF32
	bl sub_020154B0
	add r6, r6, r0
_0221CF32:
	add r7, r7, #1
	add r4, r4, #4
	cmp r7, #0x10
	blt _0221CF1E
	cmp r6, #0
	bne _0221CF4C
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	mov r0, #0
	add r5, #0x8d
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
_0221CF4C:
	mov r0, #1
	add r5, #0x8d
	strb r0, [r5]
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov07_0221CF14

	thumb_func_start ov07_0221CF54
ov07_0221CF54: ; 0x0221CF54
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r4, r1, #2
	add r0, r0, r4
	ldr r0, [r0, #0x1c]
	cmp r0, #0
	beq _0221CF78
	bl GF_AssertFail
_0221CF78:
	ldr r0, [r5, #0x18]
	mov r2, #0
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r5]
	bl ov07_0221FE88
	add r1, r5, #0
	add r1, #0xc0
	ldr r1, [r1]
	add r1, r1, r4
	str r0, [r1, #0x1c]
	add r0, r5, #0
	mov r1, #2
	add r0, #0x8d
	strb r1, [r0]
	ldr r0, _0221CFA4 ; =ov07_0221BE20
	add r5, #0xbc
	str r0, [r5]
	pop {r3, r4, r5, pc}
	nop
_0221CFA4: .word ov07_0221BE20
	thumb_func_end ov07_0221CF54

	thumb_func_start ov07_0221CFA8
ov07_0221CFA8: ; 0x0221CFA8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r4, r1, #2
	add r0, r0, r4
	ldr r0, [r0, #0x1c]
	cmp r0, #0
	beq _0221CFCE
	bl GF_AssertFail
_0221CFCE:
	ldr r0, [r5, #0x18]
	mov r1, #0x60
	ldr r2, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r5]
	mov r3, #0
	bl ov07_0221FEB0
	add r1, r5, #0
	add r1, #0xc0
	ldr r1, [r1]
	add r1, r1, r4
	str r0, [r1, #0x1c]
	add r0, r5, #0
	mov r1, #2
	add r0, #0x8d
	strb r1, [r0]
	ldr r0, _0221CFFC ; =ov07_0221BE20
	add r5, #0xbc
	str r0, [r5]
	pop {r3, r4, r5, pc}
	nop
_0221CFFC: .word ov07_0221BE20
	thumb_func_end ov07_0221CFA8

	thumb_func_start ov07_0221D000
ov07_0221D000: ; 0x0221D000
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	lsl r4, r1, #2
	add r0, r0, r4
	ldr r0, [r0, #0x1c]
	bl ov07_0221FF2C
	add r5, #0xc0
	ldr r0, [r5]
	mov r1, #0
	add r0, r0, r4
	str r1, [r0, #0x1c]
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221D000

	thumb_func_start ov07_0221D02C
ov07_0221D02C: ; 0x0221D02C
	ldr r1, [r0, #0x18]
	mov r3, #0
	add r1, r1, #4
	str r1, [r0, #0x18]
	add r2, r0, #0
_0221D036:
	ldr r1, [r2, #0x1c]
	cmp r1, #0
	bne _0221D052
	ldr r1, [r0, #0x18]
	add r2, r1, #4
	lsl r1, r3, #2
	add r1, r0, r1
	str r2, [r1, #0x1c]
	ldr r2, [r0, #0x18]
	ldr r1, [r2]
	lsl r1, r1, #2
	add r1, r2, r1
	str r1, [r0, #0x18]
	bx lr
_0221D052:
	add r3, r3, #1
	add r2, r2, #4
	cmp r3, #3
	blt _0221D036
	bx lr
	thumb_func_end ov07_0221D02C

	thumb_func_start ov07_0221D05C
ov07_0221D05C: ; 0x0221D05C
	ldr r1, [r0, #0x18]
	add r3, r0, #0
	add r1, r1, #4
	str r1, [r0, #0x18]
	mov r2, #2
	add r3, #8
_0221D068:
	ldr r1, [r3, #0x1c]
	cmp r1, #0
	beq _0221D07E
	add r3, r0, #0
	add r3, #0x1c
	lsl r2, r2, #2
	ldr r1, [r3, r2]
	str r1, [r0, #0x18]
	mov r0, #0
	str r0, [r3, r2]
	bx lr
_0221D07E:
	sub r3, r3, #4
	sub r2, r2, #1
	bpl _0221D068
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221D05C

	thumb_func_start ov07_0221D088
ov07_0221D088: ; 0x0221D088
	push {r3, r4}
	ldr r2, [r0, #0x18]
	add r1, r0, #0
	add r2, r2, #4
	str r2, [r0, #0x18]
	ldr r4, [r2]
	add r2, r2, #4
	str r2, [r0, #0x18]
	ldr r3, [r2]
	add r2, r2, #4
	str r2, [r0, #0x18]
	lsl r2, r4, #2
	add r2, r0, r2
	add r2, #0x94
	ldr r2, [r2]
	add r1, #0x18
	cmp r3, r2
	bne _0221D0B6
	ldr r1, [r0, #0x18]
	ldr r1, [r1]
	str r1, [r0, #0x18]
	pop {r3, r4}
	bx lr
_0221D0B6:
	ldr r0, [r1]
	add r0, r0, #4
	str r0, [r1]
	pop {r3, r4}
	bx lr
	thumb_func_end ov07_0221D088

	thumb_func_start ov07_0221D0C0
ov07_0221D0C0: ; 0x0221D0C0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	str r0, [r4, #0x18]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	bl ov07_0221F8C4
	cmp r0, #0
	ldr r0, [r4, #0x18]
	beq _0221D0E0
	ldr r0, [r0]
	str r0, [r4, #0x18]
	pop {r4, pc}
_0221D0E0:
	add r0, r0, #4
	str r0, [r4, #0x18]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221D0C0

	thumb_func_start ov07_0221D0E8
ov07_0221D0E8: ; 0x0221D0E8
	push {r3, r4, r5, r6, r7, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	add r1, r0, #4
	str r1, [r4, #0x18]
	ldr r0, [r1]
	add r1, r1, #4
	str r1, [r4, #0x18]
	bl ov07_02223038
	add r7, r0, #0
	ldr r0, [r4, #0x18]
	add r2, r4, #0
	ldr r5, [r0]
	add r0, r0, #4
	add r2, #0x18
	mov r3, #0
	str r0, [r4, #0x18]
	cmp r5, #0
	bls _0221D12A
	add r6, r4, #0
_0221D112:
	ldr r0, [r4, #0x18]
	add r3, r3, #1
	ldr r1, [r0]
	add r0, r6, #0
	add r0, #0x94
	str r1, [r0]
	ldr r0, [r2]
	add r6, r6, #4
	add r0, r0, #4
	str r0, [r2]
	cmp r3, r5
	blo _0221D112
_0221D12A:
	cmp r3, #0xa
	bge _0221D142
	lsl r0, r3, #2
	add r2, r4, r0
	mov r1, #0
_0221D134:
	add r0, r2, #0
	add r0, #0x94
	add r3, r3, #1
	add r2, r2, #4
	str r1, [r0]
	cmp r3, #0xa
	blt _0221D134
_0221D142:
	add r0, r4, #0
	blx r7
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov07_0221D0E8

	thumb_func_start ov07_0221D148
ov07_0221D148: ; 0x0221D148
	ldr r2, [r0, #0x18]
	add r1, r0, #0
	add r2, r2, #4
	str r2, [r0, #0x18]
	add r2, r0, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r1, #0x18
	ldrh r3, [r2, #0x10]
	mov r2, #1
	tst r2, r3
	beq _0221D166
	ldr r2, [r1]
	add r2, r2, #4
	str r2, [r1]
_0221D166:
	ldr r2, [r0, #0x18]
	ldr r1, [r2]
	lsl r1, r1, #2
	add r1, r2, r1
	str r1, [r0, #0x18]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221D148

	thumb_func_start ov07_0221D174
ov07_0221D174: ; 0x0221D174
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x18]
	add r1, r1, #4
	str r1, [r4, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r4, #0x18]
	cmp r2, #0
	bne _0221D196
	add r1, r4, #0
	add r1, #0xc0
	ldr r1, [r1]
	ldrh r1, [r1, #0x14]
	bl ov07_0223192C
	b _0221D1A2
_0221D196:
	add r1, r4, #0
	add r1, #0xc0
	ldr r1, [r1]
	ldrh r1, [r1, #0x16]
	bl ov07_0223192C
_0221D1A2:
	cmp r0, #4
	bne _0221D1AC
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	str r0, [r4, #0x18]
_0221D1AC:
	ldr r1, [r4, #0x18]
	ldr r0, [r1]
	lsl r0, r0, #2
	add r0, r1, r0
	str r0, [r4, #0x18]
	pop {r4, pc}
	thumb_func_end ov07_0221D174

	thumb_func_start ov07_0221D1B8
ov07_0221D1B8: ; 0x0221D1B8
	push {r4, r5}
	sub sp, #0x10
	ldr r5, _0221D210 ; =ov07_02234B98
	add r2, sp, #0
	add r4, r0, #0
	add r3, r2, #0
	ldmia r5!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r1, [r4, #0x18]
	add r0, r4, #0
	add r1, r1, #4
	str r1, [r4, #0x18]
	add r1, r4, #0
	add r1, #0xc0
	ldr r1, [r1]
	add r0, #0x18
	ldr r1, [r1, #0xc]
	cmp r1, #0
	beq _0221D1FE
	ldr r2, [r0]
	add r2, r2, #4
	str r2, [r0]
	mov r2, #0
_0221D1EA:
	ldr r5, [r3]
	tst r5, r1
	bne _0221D1FE
	ldr r5, [r0]
	add r2, r2, #1
	add r5, r5, #4
	add r3, r3, #4
	str r5, [r0]
	cmp r2, #4
	blo _0221D1EA
_0221D1FE:
	ldr r1, [r4, #0x18]
	ldr r0, [r1]
	lsl r0, r0, #2
	add r0, r1, r0
	str r0, [r4, #0x18]
	add sp, #0x10
	pop {r4, r5}
	bx lr
	nop
_0221D210: .word ov07_02234B98
	thumb_func_end ov07_0221D1B8

	thumb_func_start ov07_0221D214
ov07_0221D214: ; 0x0221D214
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x18]
	add r1, r1, #4
	str r1, [r4, #0x18]
	bl ov07_0221BFC0
	cmp r0, #1
	bne _0221D232
	ldr r1, [r4, #0x18]
	ldr r0, [r1]
	lsl r0, r0, #2
	add r0, r1, r0
	str r0, [r4, #0x18]
	pop {r4, pc}
_0221D232:
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	str r0, [r4, #0x18]
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221D214

	thumb_func_start ov07_0221D23C
ov07_0221D23C: ; 0x0221D23C
	ldr r2, [r0, #0x18]
	add r1, r0, #0
	add r2, r2, #4
	str r2, [r0, #0x18]
	add r2, r0, #0
	add r2, #0xc0
	ldr r3, [r2]
	mov r2, #0x46
	lsl r2, r2, #2
	ldr r2, [r3, r2]
	add r1, #0x18
	lsl r2, r2, #0x1e
	asr r2, r2, #0x1f
	beq _0221D266
	ldr r0, [r0, #0x18]
	ldr r2, [r1]
	ldr r0, [r0]
	lsl r0, r0, #2
	add r0, r2, r0
	str r0, [r1]
	bx lr
_0221D266:
	ldr r0, [r1]
	add r0, r0, #4
	str r0, [r1]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221D23C

	thumb_func_start ov07_0221D270
ov07_0221D270: ; 0x0221D270
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r1, [r5, #0x18]
	add r1, r1, #4
	str r1, [r5, #0x18]
	add r1, r5, #0
	add r1, #0xc0
	ldr r1, [r1]
	ldrh r1, [r1, #0x14]
	bl ov07_0223192C
	add r1, r5, #0
	add r1, #0xc0
	ldr r1, [r1]
	add r4, r0, #0
	ldrh r1, [r1, #0x16]
	add r0, r5, #0
	bl ov07_0223192C
	cmp r4, r0
	bne _0221D2A6
	ldr r1, [r5, #0x18]
	ldr r0, [r1]
	lsl r0, r0, #2
	add r0, r1, r0
	str r0, [r5, #0x18]
	pop {r3, r4, r5, pc}
_0221D2A6:
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov07_0221D270

	thumb_func_start ov07_0221D2B0
ov07_0221D2B0: ; 0x0221D2B0
	ldr r2, [r0, #0x18]
	add r1, r0, #0
	add r2, r2, #4
	str r2, [r0, #0x18]
	ldr r3, [r2]
	add r2, r2, #4
	str r2, [r0, #0x18]
	add r2, r0, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r1, #0x18
	ldrh r2, [r2, #0x10]
	cmp r3, r2
	bne _0221D2DA
	ldr r0, [r0, #0x18]
	ldr r2, [r1]
	ldr r0, [r0]
	lsl r0, r0, #2
	add r0, r2, r0
	str r0, [r1]
	bx lr
_0221D2DA:
	ldr r0, [r1]
	add r0, r0, #4
	str r0, [r1]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221D2B0

	thumb_func_start ov07_0221D2E4
ov07_0221D2E4: ; 0x0221D2E4
	ldr r1, [r0, #0x18]
	add r2, r1, #4
	str r2, [r0, #0x18]
	ldr r1, [r2]
	lsl r1, r1, #2
	add r1, r2, r1
	str r1, [r0, #0x18]
	bx lr
	thumb_func_end ov07_0221D2E4

	thumb_func_start ov07_0221D2F4
ov07_0221D2F4: ; 0x0221D2F4
	push {r3, lr}
	cmp r1, #0
	beq _0221D314
	mov r1, #1
	str r1, [sp]
	ldr r0, [r0, #4]
	mov r1, #0x10
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	mov r2, #0
	mov r3, #0x3c
	bl StartBrightnessTransition
	pop {r3, pc}
_0221D314:
	mov r1, #1
	str r1, [sp]
	ldr r0, [r0, #4]
	mov r1, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	mov r2, #0x10
	mov r3, #0x3c
	bl StartBrightnessTransition
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov07_0221D2F4

	thumb_func_start ov07_0221D330
ov07_0221D330: ; 0x0221D330
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	bl DoAllScreenBrightnessTransitionStep
	mov r0, #1
	bl IsBrightnessTransitionActive
	cmp r0, #0
	beq _0221D370
	ldr r0, [r4, #4]
	lsl r0, r0, #0x17
	lsr r0, r0, #0x1f
	beq _0221D35E
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
	bl ov07_0221C69C
	pop {r3, r4, r5, pc}
_0221D35E:
	add r0, r4, #0
	mov r1, #0
	bl ov07_0221D2F4
	mov r0, #1
	ldr r1, [r4, #4]
	lsl r0, r0, #8
	orr r0, r1
	str r0, [r4, #4]
_0221D370:
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov07_0221D330

	thumb_func_start ov07_0221D374
ov07_0221D374: ; 0x0221D374
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	mov r1, #8
	bl Heap_Alloc
	add r4, r0, #0
	mov r1, #0
	mov r2, #8
	bl MI_CpuFill8
	str r5, [r4]
	ldr r0, [r5, #0x18]
	mov r1, #0xff
	add r2, r0, #4
	str r2, [r5, #0x18]
	ldr r0, [r4, #4]
	bic r0, r1
	ldr r1, [r2]
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	lsl r1, r1, #0x18
	lsr r1, r1, #0x18
	orr r0, r1
	str r0, [r4, #4]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	bl ScreenBrightnessData_InitAll
	add r0, r4, #0
	mov r1, #1
	bl ov07_0221D2F4
	ldr r0, _0221D3C4 ; =ov07_0221D330
	ldr r2, _0221D3C8 ; =0x00001001
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D3C4: .word ov07_0221D330
_0221D3C8: .word 0x00001001
	thumb_func_end ov07_0221D374

	thumb_func_start ov07_0221D3CC
ov07_0221D3CC: ; 0x0221D3CC
	push {r4, r5, r6, lr}
	add r4, r0, #0
	cmp r1, #7
	bhi _0221D4AA
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221D3E0: ; jump table
	.short _0221D3F0 - _0221D3E0 - 2 ; case 0
	.short _0221D3F8 - _0221D3E0 - 2 ; case 1
	.short _0221D400 - _0221D3E0 - 2 ; case 2
	.short _0221D40E - _0221D3E0 - 2 ; case 3
	.short _0221D41C - _0221D3E0 - 2 ; case 4
	.short _0221D442 - _0221D3E0 - 2 ; case 5
	.short _0221D468 - _0221D3E0 - 2 ; case 6
	.short _0221D48A - _0221D3E0 - 2 ; case 7
_0221D3F0:
	add r4, #0xc0
	ldr r0, [r4]
	ldrh r6, [r0, #0x14]
	b _0221D4AA
_0221D3F8:
	add r4, #0xc0
	ldr r0, [r4]
	ldrh r6, [r0, #0x16]
	b _0221D4AA
_0221D400:
	add r4, #0xc0
	ldr r1, [r4]
	ldrh r1, [r1, #0x14]
	bl ov07_0223197C
	add r6, r0, #0
	b _0221D4AA
_0221D40E:
	add r4, #0xc0
	ldr r1, [r4]
	ldrh r1, [r1, #0x16]
	bl ov07_0223197C
	add r6, r0, #0
	b _0221D4AA
_0221D41C:
	mov r6, #0xff
	mov r5, #0
_0221D420:
	add r0, r4, #0
	add r1, r5, #0
	bl ov07_0221FA04
	cmp r0, #0
	beq _0221D430
	cmp r0, #2
	bne _0221D434
_0221D430:
	add r6, r5, #0
	b _0221D43A
_0221D434:
	add r5, r5, #1
	cmp r5, #4
	blt _0221D420
_0221D43A:
	cmp r6, #0xff
	bne _0221D4AA
	mov r6, #0
	b _0221D4AA
_0221D442:
	mov r6, #0xff
	mov r5, #0
_0221D446:
	add r0, r4, #0
	add r1, r5, #0
	bl ov07_0221FA04
	cmp r0, #1
	beq _0221D456
	cmp r0, #3
	bne _0221D45A
_0221D456:
	add r6, r5, #0
	b _0221D460
_0221D45A:
	add r5, r5, #1
	cmp r5, #4
	blt _0221D446
_0221D460:
	cmp r6, #0xff
	bne _0221D4AA
	mov r6, #0
	b _0221D4AA
_0221D468:
	mov r6, #0xff
	mov r5, #0
_0221D46C:
	add r0, r4, #0
	add r1, r5, #0
	bl ov07_0221FA04
	cmp r0, #4
	bne _0221D47C
	add r6, r5, #0
	b _0221D482
_0221D47C:
	add r5, r5, #1
	cmp r5, #4
	blt _0221D46C
_0221D482:
	cmp r6, #0xff
	bne _0221D4AA
	mov r6, #0
	b _0221D4AA
_0221D48A:
	mov r6, #0xff
	mov r5, #0
_0221D48E:
	add r0, r4, #0
	add r1, r5, #0
	bl ov07_0221FA04
	cmp r0, #5
	bne _0221D49E
	add r6, r5, #0
	b _0221D4A4
_0221D49E:
	add r5, r5, #1
	cmp r5, #4
	blt _0221D48E
_0221D4A4:
	cmp r6, #0xff
	bne _0221D4AA
	mov r6, #0
_0221D4AA:
	add r0, r6, #0
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov07_0221D3CC

	thumb_func_start ov07_0221D4B0
ov07_0221D4B0: ; 0x0221D4B0
	push {r4, r5, r6, lr}
	add r5, r1, #0
	ldrb r0, [r5, #5]
	cmp r0, #0
	beq _0221D4CC
	ldrb r0, [r5, #4]
	add r0, r0, #1
	strb r0, [r5, #4]
	ldrb r1, [r5, #4]
	ldrb r0, [r5, #5]
	cmp r1, r0
	bne _0221D4FA
	mov r0, #0
	strb r0, [r5, #4]
_0221D4CC:
	ldr r0, [r5, #8]
	mov r1, #0
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r6, r0, #0x10
	ldr r0, [r5, #8]
	mov r1, #1
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	ldr r0, [r5, #8]
	mov r1, #0x29
	bl Pokepic_GetAttr
	sub r0, r4, r0
	lsl r0, r0, #0x10
	asr r2, r0, #0x10
	ldr r0, [r5]
	add r1, r6, #0
	bl ManagedSprite_SetPositionXY
_0221D4FA:
	pop {r4, r5, r6, pc}
	thumb_func_end ov07_0221D4B0

	thumb_func_start ov07_0221D4FC
ov07_0221D4FC: ; 0x0221D4FC
	push {r4, r5, r6, lr}
	add r5, r1, #0
	ldrb r0, [r5, #5]
	cmp r0, #0
	beq _0221D518
	ldrb r0, [r5, #4]
	add r0, r0, #1
	strb r0, [r5, #4]
	ldrb r1, [r5, #4]
	ldrb r0, [r5, #5]
	cmp r1, r0
	bne _0221D55A
	mov r0, #0
	strb r0, [r5, #4]
_0221D518:
	ldr r0, [r5, #8]
	mov r1, #0
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r6, r0, #0x10
	ldr r0, [r5, #8]
	mov r1, #1
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	ldr r0, [r5, #8]
	mov r1, #0x29
	bl Pokepic_GetAttr
	sub r0, r4, r0
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	sub r6, #0x28
	ldr r0, [r5]
	mov r1, #2
	mov r2, #0
	neg r3, r6
	bl BgSetPosTextAndCommit
	sub r4, #0x28
	ldr r0, [r5]
	mov r1, #2
	mov r2, #3
	neg r3, r4
	bl BgSetPosTextAndCommit
_0221D55A:
	pop {r4, r5, r6, pc}
	thumb_func_end ov07_0221D4FC

	thumb_func_start ov07_0221D55C
ov07_0221D55C: ; 0x0221D55C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	cmp r1, #4
	bne _0221D588
	mov r0, #0x5e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	cmp r0, #0
	beq _0221D5A6
	ldr r0, [r0, #0xc]
	bl SysTask_Destroy
	mov r0, #0x5e
	lsl r0, r0, #2
	ldr r0, [r4, r0]
	bl Heap_Free
	mov r0, #0x5e
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r3, r4, r5, pc}
_0221D588:
	mov r0, #0x59
	lsl r0, r0, #2
	lsl r5, r1, #2
	add r4, r4, r0
	ldr r0, [r4, r5]
	cmp r0, #0
	beq _0221D5A6
	ldr r0, [r0, #0xc]
	bl SysTask_Destroy
	ldr r0, [r4, r5]
	bl Heap_Free
	mov r0, #0
	str r0, [r4, r5]
_0221D5A6:
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221D55C

	thumb_func_start ov07_0221D5A8
ov07_0221D5A8: ; 0x0221D5A8
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221D5A8

	thumb_func_start ov07_0221D5AC
ov07_0221D5AC: ; 0x0221D5AC
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221D5AC

	thumb_func_start ov07_0221D5B0
ov07_0221D5B0: ; 0x0221D5B0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r1, [r5, #0x18]
	add r2, r1, #4
	str r2, [r5, #0x18]
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r5, #0x18]
	ldr r4, [r2]
	add r2, r2, #4
	str r2, [r5, #0x18]
	bl ov07_0221D3CC
	add r6, r0, #0
	add r0, r5, #0
	add r0, #0xc0
	ldr r1, [r0]
	lsl r0, r6, #2
	add r0, r1, r0
	add r0, #0xb0
	ldr r1, [r0]
	ldr r0, [r1, #4]
	ldr r7, [r1]
	str r0, [sp, #0x14]
	ldr r0, [r1, #8]
	str r0, [sp, #0x10]
	mov r0, #2
	bl BgGetCharPtr
	mov r2, #0x19
	mov r1, #0
	lsl r2, r2, #8
	bl MI_CpuFill8
	mov r0, #2
	mov r1, #0
	bl ToggleBgLayer
	mov r0, #0
	str r0, [sp]
	add r0, r5, #0
	add r0, #0xc4
	mov r3, #0x32
	ldr r0, [r0]
	mov r1, #2
	add r2, r7, #0
	lsl r3, r3, #6
	bl BG_LoadCharTilesData
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #0x80
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0xc8
	ldr r0, [r0]
	ldr r1, [sp, #0x14]
	ldr r2, [sp, #0x10]
	ldr r3, [r5]
	bl PaletteData_LoadNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r5]
	mov r1, #0x1b
	add r2, r5, #0
	str r0, [sp, #0xc]
	lsl r1, r1, #4
	add r2, #0xc4
	ldr r0, [r5, r1]
	ldr r2, [r2]
	sub r1, #0xa4
	mov r3, #2
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	cmp r4, #1
	bne _0221D696
	ldr r0, [r5]
	mov r1, #0x10
	bl Heap_Alloc
	mov r1, #0x5e
	lsl r1, r1, #2
	str r0, [r5, r1]
	add r0, r5, #0
	add r0, #0xc4
	ldr r2, [r0]
	ldr r0, [r5, r1]
	add r1, r6, #0
	str r2, [r0]
	add r0, r5, #0
	bl ov07_0221FA48
	mov r1, #0x5e
	lsl r1, r1, #2
	ldr r2, [r5, r1]
	str r0, [r2, #8]
	ldr r0, [r5, r1]
	mov r2, #0
	strb r2, [r0, #4]
	ldr r0, [r5, r1]
	strb r2, [r0, #5]
	ldr r0, _0221D710 ; =ov07_0221D4FC
	ldr r1, [r5, r1]
	ldr r2, _0221D714 ; =0x00001001
	bl SysTask_CreateOnMainQueue
	mov r1, #0x5e
	lsl r1, r1, #2
	ldr r1, [r5, r1]
	str r0, [r1, #0xc]
_0221D696:
	add r0, r5, #0
	add r1, r6, #0
	bl ov07_0221FA48
	mov r1, #0
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r7, r0, #0x10
	add r0, r5, #0
	add r1, r6, #0
	bl ov07_0221FA48
	mov r1, #1
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	add r0, r5, #0
	add r1, r6, #0
	bl ov07_0221FA48
	mov r1, #0x29
	bl Pokepic_GetAttr
	sub r0, r4, r0
	lsl r0, r0, #0x10
	asr r4, r0, #0x10
	add r0, r5, #0
	add r0, #0xc4
	sub r7, #0x28
	ldr r0, [r0]
	mov r1, #2
	mov r2, #0
	neg r3, r7
	bl BgSetPosTextAndCommit
	add r0, r5, #0
	add r0, #0xc4
	sub r4, #0x28
	ldr r0, [r0]
	mov r1, #2
	mov r2, #3
	neg r3, r4
	bl BgSetPosTextAndCommit
	mov r0, #2
	mov r1, #1
	bl ToggleBgLayer
	add r0, r5, #0
	bl ov07_0221FAE8
	add r1, r0, #0
	lsl r1, r1, #0x18
	mov r0, #2
	lsr r1, r1, #0x18
	bl SetBgPriority
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221D710: .word ov07_0221D4FC
_0221D714: .word 0x00001001
	thumb_func_end ov07_0221D5B0

	thumb_func_start ov07_0221D718
ov07_0221D718: ; 0x0221D718
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	add r0, r0, #4
	str r0, [r4, #0x18]
	mov r0, #2
	bl BgGetCharPtr
	mov r2, #0x19
	mov r1, #0
	lsl r2, r2, #8
	bl MI_CpuFill8
	add r0, r4, #0
	mov r1, #4
	bl ov07_0221D55C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221D718

	thumb_func_start ov07_0221D740
ov07_0221D740: ; 0x0221D740
	push {r4, lr}
	sub sp, #0x18
	ldr r3, _0221D7B4 ; =ov07_02234BF0
	add r2, sp, #0
	add r4, r0, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	str r0, [r4, #0x18]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteManager_New
	mov r1, #0x4e
	lsl r1, r1, #2
	str r0, [r4, r1]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	ldr r1, [r4, r1]
	add r0, #0xac
	ldr r0, [r0]
	mov r2, #5
	bl SpriteSystem_InitSprites
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteSystem_GetRenderer
	mov r2, #0x11
	mov r1, #0
	lsl r2, r2, #0x10
	bl G2dRenderer_SetSubSurfaceCoords
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	mov r1, #0x4e
	add r0, #0xac
	lsl r1, r1, #2
	ldr r0, [r0]
	ldr r1, [r4, r1]
	add r2, sp, #0
	bl SpriteSystem_InitManagerWithCapacities
	add sp, #0x18
	pop {r4, pc}
	.balign 4, 0
_0221D7B4: .word ov07_02234BF0
	thumb_func_end ov07_0221D740

	thumb_func_start ov07_0221D7B8
ov07_0221D7B8: ; 0x0221D7B8
	push {r3, r4, r5, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	ldr r1, _0221D870 ; =0x00004E21
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r2, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r4, r2, r1
	ldrh r3, [r0, #0x14]
	lsr r2, r1, #2
	add r0, #0xac
	mul r2, r3
	add r4, r4, r2
	mov r2, #0
	str r2, [sp]
	mov r2, #1
	str r2, [sp, #4]
	mov r2, #0x6d
	str r4, [sp, #8]
	lsr r1, r1, #6
	lsl r2, r2, #2
	ldr r0, [r0]
	ldr r1, [r5, r1]
	ldr r2, [r5, r2]
	mov r3, #0x4c
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	mov r0, #0x6d
	lsl r0, r0, #2
	ldr r0, [r5, r0]
	add r2, r5, #0
	str r0, [sp]
	mov r3, #0x4b
	str r3, [sp, #4]
	mov r0, #0
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0xc]
	str r0, [sp, #0x10]
	add r0, r5, #0
	str r4, [sp, #0x14]
	add r2, #0xc0
	ldr r2, [r2]
	add r0, #0xc8
	add r2, #0xac
	add r3, #0xed
	ldr r0, [r0]
	ldr r2, [r2]
	ldr r3, [r5, r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	mov r0, #0
	str r0, [sp]
	add r0, r5, #0
	mov r2, #0x4e
	str r4, [sp, #4]
	add r0, #0xc0
	ldr r0, [r0]
	lsl r2, r2, #2
	add r0, #0xac
	ldr r1, [r5, r2]
	add r2, #0x7c
	ldr r0, [r0]
	ldr r2, [r5, r2]
	mov r3, #0x4d
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	mov r0, #0
	str r0, [sp]
	add r0, r5, #0
	mov r2, #0x4e
	str r4, [sp, #4]
	add r0, #0xc0
	ldr r0, [r0]
	lsl r2, r2, #2
	add r0, #0xac
	ldr r1, [r5, r2]
	add r2, #0x7c
	ldr r0, [r0]
	ldr r2, [r5, r2]
	mov r3, #0x4e
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #0x18
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221D870: .word 0x00004E21
	thumb_func_end ov07_0221D7B8

	thumb_func_start ov07_0221D874
ov07_0221D874: ; 0x0221D874
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x70
	add r4, r0, #0
	ldr r1, [r4, #0x18]
	ldr r6, _0221DA68 ; =0x00004E21
	add r2, r1, #4
	str r2, [r4, #0x18]
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r4, #0x18]
	mov ip, r1
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r4, #0x18]
	str r1, [sp, #0x10]
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r4, #0x18]
	str r1, [sp, #0xc]
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r4, #0x18]
	add r2, r4, #0
	add r2, #0xc0
	ldr r2, [r2]
	add r1, r1, r6
	ldrh r3, [r2, #0x14]
	lsr r2, r6, #2
	mul r2, r3
	add r2, r1, r2
	str r2, [sp, #0x58]
	add r2, r4, #0
	add r2, #0xc0
	ldr r2, [r2]
	ldrh r3, [r2, #0x14]
	lsr r2, r6, #2
	mul r2, r3
	add r2, r1, r2
	str r2, [sp, #0x5c]
	add r2, r4, #0
	add r2, #0xc0
	ldr r2, [r2]
	ldrh r3, [r2, #0x14]
	lsr r2, r6, #2
	mul r2, r3
	add r2, r1, r2
	str r2, [sp, #0x60]
	add r2, r4, #0
	add r2, #0xc0
	ldr r2, [r2]
	lsr r3, r6, #2
	ldrh r2, [r2, #0x14]
	mul r3, r2
	add r1, r1, r3
	str r1, [sp, #0x64]
	mov r1, #0
	str r1, [sp, #0x68]
	str r1, [sp, #0x6c]
	mov r1, ip
	bl ov07_0221D3CC
	str r0, [sp, #0x1c]
	add r0, r4, #0
	add r0, #0xc0
	ldr r1, [r0]
	ldr r0, [sp, #0x1c]
	lsl r0, r0, #2
	add r0, r1, r0
	add r0, #0xb0
	ldr r1, [r0]
	ldr r0, [r1, #4]
	str r0, [sp, #0x18]
	ldr r0, [r1, #8]
	str r0, [sp, #0x14]
	ldr r0, [r1]
	ldr r1, [sp, #0x1c]
	str r0, [sp, #0x20]
	add r0, r4, #0
	bl ov07_0221FA48
	add r6, r0, #0
	beq _0221D93C
	mov r1, #0
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r7, r0, #0x10
	add r0, r6, #0
	mov r1, #1
	bl Pokepic_GetAttr
	lsl r0, r0, #0x10
	asr r5, r0, #0x10
	add r0, r6, #0
	mov r1, #0x29
	bl Pokepic_GetAttr
	sub r0, r5, r0
	lsl r0, r0, #0x10
	asr r5, r0, #0x10
_0221D93C:
	add r0, sp, #0x24
	strh r7, [r0]
	strh r5, [r0, #2]
	mov r1, #0
	strh r1, [r0, #4]
	strh r1, [r0, #6]
	mov r0, #0x64
	str r0, [sp, #0x2c]
	mov r0, #1
	str r1, [sp, #0x30]
	str r0, [sp, #0x34]
	str r0, [sp, #0x50]
	str r1, [sp, #0x54]
	add r2, sp, #0x58
	add r3, sp, #0x24
_0221D95A:
	ldr r0, [r2]
	add r1, r1, #1
	str r0, [r3, #0x14]
	add r2, r2, #4
	add r3, r3, #4
	cmp r1, #6
	blt _0221D95A
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	mov r1, #0x4e
	add r0, #0xac
	lsl r1, r1, #2
	ldr r0, [r0]
	ldr r1, [r4, r1]
	add r2, sp, #0x24
	bl SpriteSystem_NewSprite
	add r7, r0, #0
	cmp r6, #0
	bne _0221D98C
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	b _0221D9A0
_0221D98C:
	add r0, r6, #0
	mov r1, #6
	bl Pokepic_GetAttr
	cmp r0, #1
	bne _0221D9A0
	add r0, r7, #0
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
_0221D9A0:
	ldr r1, [sp, #0x1c]
	add r0, r4, #0
	bl ov07_0221FA48
	cmp r0, #0
	beq _0221D9C2
	ldr r0, [r7]
	bl Sprite_GetImageProxy
	add r1, r0, #0
	mov r3, #0x32
	ldr r1, [r1, #4]
	ldr r2, [sp, #0x20]
	mov r0, #0x13
	lsl r3, r3, #6
	bl GF_CreateNewVramTransferTask
_0221D9C2:
	ldr r1, [sp, #0x1c]
	add r0, r4, #0
	bl ov07_0221FA48
	cmp r0, #0
	beq _0221D9F8
	ldr r0, [r7]
	bl Sprite_GetPaletteProxy
	mov r1, #1
	bl ObjPlttTransfer_GetPaletteVramOffset
	mov r1, #2
	str r1, [sp]
	mov r1, #0x20
	lsl r0, r0, #0x14
	str r1, [sp, #4]
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	add r0, r4, #0
	add r0, #0xc8
	ldr r0, [r0]
	ldr r1, [sp, #0x18]
	ldr r2, [sp, #0x14]
	ldr r3, [r4]
	bl PaletteData_LoadNarc
_0221D9F8:
	ldr r0, [sp, #0xc]
	lsl r5, r0, #2
	mov r0, #0x4f
	lsl r0, r0, #2
	add r6, r4, r0
	ldr r0, [r6, r5]
	cmp r0, #0
	beq _0221DA0C
	bl GF_AssertFail
_0221DA0C:
	mov r0, #0x15
	str r7, [r6, r5]
	mov r2, #1
	add r1, r4, r5
	lsl r0, r0, #4
	str r2, [r1, r0]
	ldr r0, [sp, #0x10]
	cmp r0, #1
	bne _0221DA62
	ldr r1, [sp, #0x1c]
	add r0, r4, #0
	bl ov07_0221FA48
	cmp r0, #0
	beq _0221DA62
	mov r0, #0x59
	lsl r0, r0, #2
	add r6, r4, r0
	ldr r0, [r4]
	mov r1, #0x10
	bl Heap_Alloc
	str r0, [r6, r5]
	ldr r0, [r6, r5]
	ldr r1, [sp, #0x1c]
	str r7, [r0]
	add r0, r4, #0
	bl ov07_0221FA48
	ldr r1, [r6, r5]
	ldr r2, _0221DA6C ; =0x00001001
	str r0, [r1, #8]
	ldr r0, [r6, r5]
	mov r1, #0
	strb r1, [r0, #4]
	ldr r0, [r6, r5]
	strb r1, [r0, #5]
	ldr r0, _0221DA70 ; =ov07_0221D4B0
	ldr r1, [r6, r5]
	bl SysTask_CreateOnMainQueue
	ldr r1, [r6, r5]
	str r0, [r1, #0xc]
_0221DA62:
	add sp, #0x70
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DA68: .word 0x00004E21
_0221DA6C: .word 0x00001001
_0221DA70: .word ov07_0221D4B0
	thumb_func_end ov07_0221D874

	thumb_func_start ov07_0221DA74
ov07_0221DA74: ; 0x0221DA74
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	str r0, [r4, #0x18]
	mov r0, #0x4e
	lsl r0, r0, #2
	ldr r1, [r4, r0]
	cmp r1, #0
	beq _0221DA96
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteSystem_FreeResourcesAndManager
_0221DA96:
	mov r0, #0x4e
	mov r1, #0
	lsl r0, r0, #2
	str r1, [r4, r0]
	pop {r4, pc}
	thumb_func_end ov07_0221DA74

	thumb_func_start ov07_0221DAA0
ov07_0221DAA0: ; 0x0221DAA0
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	mov r0, #0x4f
	lsl r0, r0, #2
	lsl r4, r1, #2
	add r6, r5, r0
	ldr r0, [r6, r4]
	cmp r0, #0
	beq _0221DAC2
	bl Sprite_DeleteAndFreeResources
_0221DAC2:
	mov r0, #0x15
	mov r2, #0
	add r1, r5, r4
	lsl r0, r0, #4
	str r2, [r1, r0]
	str r2, [r6, r4]
	pop {r4, r5, r6, pc}
	thumb_func_end ov07_0221DAA0

	thumb_func_start ov07_0221DAD0
ov07_0221DAD0: ; 0x0221DAD0
	push {r3, lr}
	ldr r2, [r1, #0xc]
	cmp r2, #0
	bne _0221DADE
	bl SysTask_Destroy
	pop {r3, pc}
_0221DADE:
	mov r0, #0x4e
	ldr r2, [r1]
	lsl r0, r0, #2
	ldr r0, [r2, r0]
	cmp r0, #0
	beq _0221DAF0
	ldr r0, [r1, #4]
	bl SpriteSystem_DrawSprites
_0221DAF0:
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov07_0221DAD0

	thumb_func_start ov07_0221DAF4
ov07_0221DAF4: ; 0x0221DAF4
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r6, r5, #0
	add r1, r0, #4
	str r1, [r5, #0x18]
	ldr r0, [r1]
	add r6, #0x54
	str r0, [sp]
	add r0, r1, #4
	str r0, [r5, #0x18]
	ldr r2, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	lsl r4, r2, #4
	str r0, [sp, #8]
	add r0, #0x4c
	lsl r1, r1, #2
	str r0, [sp, #8]
	str r5, [r0, r4]
	mov r0, #0x4e
	lsl r0, r0, #2
	ldr r3, [r5, r0]
	add r2, r5, r4
	str r3, [r2, #0x50]
	add r1, r5, r1
	add r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	str r0, [r6, r4]
	mov r0, #1
	str r0, [r2, #0x58]
	ldr r0, [r6, r4]
	bl ManagedSprite_SetDrawFlag
	add r0, r5, #0
	bl ov07_0221FAB0
	cmp r0, #1
	beq _0221DB50
	b _0221DC9E
_0221DB50:
	add r0, r5, #0
	bl ov07_0221C468
	add r1, r0, #0
	add r0, r5, #0
	bl ov07_02231924
	str r0, [sp, #4]
	add r0, r5, #0
	bl ov07_0221C470
	add r1, r0, #0
	add r0, r5, #0
	bl ov07_02231924
	add r7, r0, #0
	ldr r1, [sp]
	add r0, r5, #0
	bl ov07_0221D3CC
	add r1, r0, #0
	add r0, r5, #0
	bl ov07_0221FA48
	cmp r0, #0
	beq _0221DB8C
	mov r1, #6
	bl Pokepic_GetAttr
	b _0221DB8E
_0221DB8C:
	mov r0, #0
_0221DB8E:
	cmp r0, #1
	ldr r0, [r6, r4]
	bne _0221DB9C
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	b _0221DBA2
_0221DB9C:
	mov r1, #1
	bl ManagedSprite_SetDrawFlag
_0221DBA2:
	ldr r0, [sp]
	cmp r0, #3
	bhi _0221DC90
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221DBB4: ; jump table
	.short _0221DBBC - _0221DBB4 - 2 ; case 0
	.short _0221DC0A - _0221DBB4 - 2 ; case 1
	.short _0221DBE2 - _0221DBB4 - 2 ; case 2
	.short _0221DC4E - _0221DBB4 - 2 ; case 3
_0221DBBC:
	ldr r0, [sp, #4]
	sub r0, r0, #3
	cmp r0, #1
	bhi _0221DBCE
	ldr r0, [r6, r4]
	mov r1, #1
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DBCE:
	add r5, #0x54
	ldr r0, [r5, r4]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r5, r4]
	mov r1, #0xff
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DBE2:
	ldr r0, [sp, #4]
	cmp r0, #5
	beq _0221DBEC
	cmp r0, #2
	bne _0221DBF6
_0221DBEC:
	ldr r0, [r6, r4]
	mov r1, #1
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DBF6:
	add r5, #0x54
	ldr r0, [r5, r4]
	mov r1, #0
	bl ManagedSprite_SetDrawFlag
	ldr r0, [r5, r4]
	mov r1, #0xff
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC0A:
	cmp r7, #5
	bhi _0221DC90
	add r0, r7, r7
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221DC1A: ; jump table
	.short _0221DC90 - _0221DC1A - 2 ; case 0
	.short _0221DC90 - _0221DC1A - 2 ; case 1
	.short _0221DC26 - _0221DC1A - 2 ; case 2
	.short _0221DC30 - _0221DC1A - 2 ; case 3
	.short _0221DC3A - _0221DC1A - 2 ; case 4
	.short _0221DC44 - _0221DC1A - 2 ; case 5
_0221DC26:
	ldr r0, [r6, r4]
	mov r1, #0xff
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC30:
	ldr r0, [r6, r4]
	mov r1, #1
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC3A:
	ldr r0, [r6, r4]
	mov r1, #1
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC44:
	ldr r0, [r6, r4]
	mov r1, #0xff
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC4E:
	cmp r7, #5
	bhi _0221DC90
	add r0, r7, r7
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221DC5E: ; jump table
	.short _0221DC90 - _0221DC5E - 2 ; case 0
	.short _0221DC90 - _0221DC5E - 2 ; case 1
	.short _0221DC6A - _0221DC5E - 2 ; case 2
	.short _0221DC74 - _0221DC5E - 2 ; case 3
	.short _0221DC7E - _0221DC5E - 2 ; case 4
	.short _0221DC88 - _0221DC5E - 2 ; case 5
_0221DC6A:
	ldr r0, [r6, r4]
	mov r1, #1
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC74:
	ldr r0, [r6, r4]
	mov r1, #0xff
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC7E:
	ldr r0, [r6, r4]
	mov r1, #0xff
	bl ManagedSprite_SetDrawPriority
	b _0221DC90
_0221DC88:
	ldr r0, [r6, r4]
	mov r1, #1
	bl ManagedSprite_SetDrawPriority
_0221DC90:
	ldr r1, [sp, #8]
	mov r2, #1
	ldr r0, _0221DCA4 ; =ov07_0221DAD0
	add r1, r1, r4
	lsl r2, r2, #0xc
	bl SysTask_CreateOnMainQueue
_0221DC9E:
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_0221DCA4: .word ov07_0221DAD0
	thumb_func_end ov07_0221DAF4

	thumb_func_start ov07_0221DCA8
ov07_0221DCA8: ; 0x0221DCA8
	ldr r1, [r0, #0x18]
	mov r2, #0
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r3, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	lsl r1, r3, #4
	add r0, r0, r1
	str r2, [r0, #0x58]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221DCA8

	thumb_func_start ov07_0221DCC0
ov07_0221DCC0: ; 0x0221DCC0
	ldr r1, [r0, #0x18]
	ldr r3, _0221DCD0 ; =ov07_0221D55C
	add r2, r1, #4
	str r2, [r0, #0x18]
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r0, #0x18]
	bx r3
	.balign 4, 0
_0221DCD0: .word ov07_0221D55C
	thumb_func_end ov07_0221DCC0

	thumb_func_start ov07_0221DCD4
ov07_0221DCD4: ; 0x0221DCD4
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r3, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	add r0, r0, r3
	add r0, #0x6c
	strb r2, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221DCD4

	thumb_func_start ov07_0221DCF0
ov07_0221DCF0: ; 0x0221DCF0
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r3, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	add r0, r0, r3
	add r0, #0x7c
	strb r2, [r0]
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221DCF0

	thumb_func_start ov07_0221DD0C
ov07_0221DD0C: ; 0x0221DD0C
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221DD0C

	thumb_func_start ov07_0221DD10
ov07_0221DD10: ; 0x0221DD10
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221DD10

	thumb_func_start ov07_0221DD14
ov07_0221DD14: ; 0x0221DD14
	push {r4, r5}
	mov r4, #0
	mov r2, #1
_0221DD1A:
	ldr r5, [r0]
	cmp r5, #0
	beq _0221DD2C
	cmp r1, #5
	beq _0221DD2A
	ldr r3, [r5, #0x1c]
	cmp r1, r3
	bne _0221DD2C
_0221DD2A:
	str r2, [r5, #0x18]
_0221DD2C:
	add r4, r4, #1
	add r0, r0, #4
	cmp r4, #4
	blt _0221DD1A
	pop {r4, r5}
	bx lr
	thumb_func_end ov07_0221DD14

	thumb_func_start ov07_0221DD38
ov07_0221DD38: ; 0x0221DD38
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r7, r1, #0
	add r6, r2, #0
	mov r4, #0
_0221DD42:
	lsl r0, r4, #2
	ldr r0, [r5, r0]
	cmp r0, #0
	beq _0221DD54
	ldr r0, [r0, #0x1c]
	cmp r6, r0
	bne _0221DD54
	bl GF_AssertFail
_0221DD54:
	add r0, r4, #1
	lsl r0, r0, #0x18
	lsr r4, r0, #0x18
	cmp r4, #4
	blo _0221DD42
	mov r2, #0
_0221DD60:
	lsl r1, r2, #2
	ldr r0, [r5, r1]
	cmp r0, #0
	bne _0221DD70
	str r7, [r5, r1]
	ldr r0, [r5, r1]
	str r6, [r0, #0x1c]
	pop {r3, r4, r5, r6, r7, pc}
_0221DD70:
	add r0, r2, #1
	lsl r0, r0, #0x18
	lsr r2, r0, #0x18
	cmp r2, #4
	blo _0221DD60
	ldr r0, _0221DD88 ; =_02237840
	cmp r0, #0
	beq _0221DD84
	bl GF_AssertFail
_0221DD84:
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DD88: .word _02237840
	thumb_func_end ov07_0221DD38

	thumb_func_start ov07_0221DD8C
ov07_0221DD8C: ; 0x0221DD8C
	push {r3, r4}
	mov r4, #0
_0221DD90:
	lsl r2, r4, #2
	ldr r3, [r0, r2]
	ldr r2, [r3, #0x1c]
	cmp r1, r2
	bne _0221DDA0
	add r0, r3, #0
	pop {r3, r4}
	bx lr
_0221DDA0:
	add r2, r4, #1
	lsl r2, r2, #0x18
	lsr r4, r2, #0x18
	cmp r4, #4
	blo _0221DD90
	mov r0, #0
	pop {r3, r4}
	bx lr
	thumb_func_end ov07_0221DD8C

	thumb_func_start ov07_0221DDB0
ov07_0221DDB0: ; 0x0221DDB0
	push {r3, r4, r5, r6, r7, lr}
	add r4, r1, #0
	add r1, #0xc0
	ldr r1, [r1]
	add r5, r0, #0
	ldrh r1, [r1, #0x14]
	add r0, r4, #0
	add r6, r2, #0
	bl ov07_0223192C
	add r7, r0, #0
	add r0, r4, #0
	add r4, #0xc0
	ldr r1, [r4]
	ldrh r1, [r1, #0x16]
	bl ov07_0223192C
	lsl r1, r6, #2
	add r1, r5, r1
	ldr r1, [r1, #0x1c]
	cmp r1, #2
	bne _0221DDF4
	cmp r7, r0
	bne _0221DDEC
	cmp r0, #3
	beq _0221DDE8
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0221DDE8:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_0221DDEC:
	cmp r0, #3
	bne _0221DE00
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0221DDF4:
	cmp r1, #0
	beq _0221DE00
	cmp r0, #3
	bne _0221DE00
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
_0221DE00:
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov07_0221DDB0

	thumb_func_start ov07_0221DE04
ov07_0221DE04: ; 0x0221DE04
	push {r4, r5, r6, r7, lr}
	sub sp, #0x14
	add r7, r0, #0
	add r5, r1, #0
	add r0, r3, #0
	mov r1, #0
	add r4, r2, #0
	str r3, [sp, #0x10]
	bl ov07_0221FB7C
	add r1, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5]
	add r2, r5, #0
	str r0, [sp, #0xc]
	add r2, #0xc4
	ldr r2, [r2]
	mov r0, #7
	add r3, r4, #0
	bl GfGfxLoader_LoadCharData
	ldr r0, [sp, #0x10]
	mov r1, #1
	bl ov07_0221FB7C
	add r2, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x90
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0xc8
	ldr r0, [r0]
	ldr r3, [r5]
	mov r1, #7
	bl PaletteData_LoadNarc
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	mov r6, #2
	bl ov07_0221BFC0
	cmp r0, #1
	bne _0221DE78
	mov r6, #4
	b _0221DE88
_0221DE78:
	add r0, r7, #0
	add r1, r5, #0
	mov r2, #7
	bl ov07_0221DDB0
	cmp r0, #1
	bne _0221DE88
	mov r6, #3
_0221DE88:
	ldr r0, [sp, #0x10]
	add r1, r6, #0
	bl ov07_0221FB7C
	add r1, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5]
	add r5, #0xc4
	str r0, [sp, #0xc]
	ldr r2, [r5]
	mov r0, #7
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnData
	add sp, #0x14
	pop {r4, r5, r6, r7, pc}
	thumb_func_end ov07_0221DE04

	thumb_func_start ov07_0221DEB0
ov07_0221DEB0: ; 0x0221DEB0
	lsl r0, r0, #0x10
	and r0, r1
	cmp r1, r0
	bne _0221DEBC
	mov r0, #1
	bx lr
_0221DEBC:
	mov r0, #0
	bx lr
	thumb_func_end ov07_0221DEB0

	thumb_func_start ov07_0221DEC0
ov07_0221DEC0: ; 0x0221DEC0
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	ldr r3, _0221DF14 ; =ov07_02234BA8
	add r2, sp, #0
	add r5, r0, #0
	add r4, r2, #0
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	ldr r7, _0221DF18 ; =ov07_02234C40
	mov r6, #0
_0221DEDC:
	ldr r0, [r5, #0x18]
	ldr r1, [r4]
	bl ov07_0221DEB0
	cmp r0, #0
	beq _0221DF06
	ldr r0, [r4]
	mov r1, #0
	lsr r2, r0, #0x10
	cmp r2, #2
	blt _0221DEFE
_0221DEF2:
	lsr r0, r2, #0x1f
	add r0, r2, r0
	asr r2, r0, #1
	add r1, r1, #1
	cmp r2, #2
	bge _0221DEF2
_0221DEFE:
	lsl r1, r1, #2
	ldr r1, [r7, r1]
	add r0, r5, #0
	blx r1
_0221DF06:
	add r6, r6, #1
	add r4, r4, #4
	cmp r6, #6
	blo _0221DEDC
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221DF14: .word ov07_02234BA8
_0221DF18: .word ov07_02234C40
	thumb_func_end ov07_0221DEC0

	thumb_func_start ov07_0221DF1C
ov07_0221DF1C: ; 0x0221DF1C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5]
	mov r1, #0x4c
	bl Heap_Alloc
	add r4, r0, #0
	bne _0221DF34
	bl GF_AssertFail
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221DF34:
	mov r1, #0
	mov r2, #0x4c
	bl memset
	mov r0, #0
	str r0, [r4]
	strb r0, [r4, #5]
	strb r0, [r4, #0xf]
	strb r0, [r4, #0xe]
	str r5, [r4, #0x48]
	strb r0, [r4, #9]
	mov r0, #0x1f
	strb r0, [r4, #0xa]
	mov r0, #0x1d
	strb r0, [r4, #0xb]
	mov r0, #2
	strb r0, [r4, #0xc]
	add r0, r5, #0
	mov r1, #5
	bl ov07_0221C4A8
	cmp r0, #1
	bne _0221DF72
	mov r0, #0
	strb r0, [r4, #9]
	mov r0, #0x1f
	strb r0, [r4, #0xa]
	mov r0, #0xf
	strb r0, [r4, #0xb]
	mov r0, #7
	strb r0, [r4, #0xc]
_0221DF72:
	add r0, r5, #0
	mov r1, #5
	bl ov07_0221C4A8
	cmp r0, #2
	bne _0221DF8E
	mov r0, #7
	strb r0, [r4, #9]
	mov r0, #0xf
	strb r0, [r4, #0xa]
	mov r0, #0x1d
	strb r0, [r4, #0xb]
	mov r0, #2
	strb r0, [r4, #0xc]
_0221DF8E:
	mov r1, #0
	add r2, r5, #0
	add r3, r4, #0
_0221DF94:
	add r0, r2, #0
	add r0, #0x94
	ldr r0, [r0]
	add r1, r1, #1
	str r0, [r3, #0x1c]
	add r2, r2, #4
	add r3, r3, #4
	cmp r1, #0xa
	blt _0221DF94
	mov r0, #0x5f
	mov r1, #1
	lsl r0, r0, #2
	strb r1, [r5, r0]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov07_0221DF1C

	thumb_func_start ov07_0221DFB4
ov07_0221DFB4: ; 0x0221DFB4
	push {r3, r4, r5, lr}
	add r5, r1, #0
	ldrb r0, [r5, #5]
	cmp r0, #0
	beq _0221DFC8
	cmp r0, #1
	beq _0221E006
	cmp r0, #2
	beq _0221E058
	b _0221E0A2
_0221DFC8:
	ldr r0, [r5, #0x48]
	mov r1, #2
	bl ov07_0221EB98
	ldr r0, [r5, #0x48]
	mov r1, #2
	bl ov07_0221FB04
	add r4, r0, #0
	ldr r0, [r5, #0x48]
	mov r1, #1
	bl ov07_0221FB04
	lsl r1, r4, #0x18
	mov r0, #3
	lsr r1, r1, #0x18
	bl SetBgPriority
	lsl r1, r4, #0x18
	mov r0, #2
	lsr r1, r1, #0x18
	bl SetBgPriority
	mov r0, #2
	mov r1, #1
	bl ToggleBgLayer
	ldrb r0, [r5, #5]
	add r0, r0, #1
	strb r0, [r5, #5]
	b _0221E0A6
_0221E006:
	ldr r0, [r5, #0x48]
	mov r1, #3
	add r0, #0xc4
	ldr r0, [r0]
	mov r2, #2
	add r3, r1, #0
	bl SetBgControlParam
	ldr r0, [r5, #0x48]
	bl ov07_0221BFC0
	cmp r0, #1
	beq _0221E030
	ldr r0, [r5, #0x48]
	mov r2, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #3
	add r3, r2, #0
	bl SetBgControlParam
_0221E030:
	ldr r1, [r5, #0x48]
	ldr r3, [r5, #0x10]
	add r0, r5, #0
	mov r2, #3
	bl ov07_0221DE04
	ldrb r0, [r5, #9]
	mov r1, #4
	mov r2, #8
	str r0, [sp]
	ldrb r3, [r5, #0xa]
	ldr r0, _0221E0AC ; =0x04000050
	bl G2x_SetBlendAlpha_
	add r0, r5, #0
	bl ov07_0221DEC0
	ldrb r0, [r5, #5]
	add r0, r0, #1
	strb r0, [r5, #5]
_0221E058:
	ldrb r1, [r5, #9]
	ldrb r0, [r5, #0xb]
	mov r2, #0
	cmp r1, r0
	bhs _0221E068
	add r0, r1, #2
	strb r0, [r5, #9]
	b _0221E06A
_0221E068:
	add r2, r2, #1
_0221E06A:
	ldrb r1, [r5, #0xa]
	ldrb r0, [r5, #0xc]
	cmp r1, r0
	bls _0221E078
	sub r0, r1, #2
	strb r0, [r5, #0xa]
	b _0221E07A
_0221E078:
	add r2, r2, #1
_0221E07A:
	cmp r2, #2
	bne _0221E08C
	ldrb r0, [r5, #0xb]
	strb r0, [r5, #9]
	ldrb r0, [r5, #0xc]
	strb r0, [r5, #0xa]
	ldrb r0, [r5, #5]
	add r0, r0, #1
	strb r0, [r5, #5]
_0221E08C:
	ldrb r0, [r5, #9]
	ldrb r1, [r5, #0xa]
	lsl r0, r0, #8
	orr r1, r0
	ldr r0, _0221E0B0 ; =0x04000052
	strh r1, [r0]
	ldrb r0, [r5, #5]
	cmp r0, #2
	beq _0221E0A6
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221E0A2:
	mov r0, #0
	pop {r3, r4, r5, pc}
_0221E0A6:
	mov r0, #1
	pop {r3, r4, r5, pc}
	nop
_0221E0AC: .word 0x04000050
_0221E0B0: .word 0x04000052
	thumb_func_end ov07_0221DFB4

	thumb_func_start ov07_0221E0B4
ov07_0221E0B4: ; 0x0221E0B4
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r1, #0
	ldrb r0, [r4, #5]
	cmp r0, #4
	bls _0221E0C2
	b _0221E26C
_0221E0C2:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221E0CE: ; jump table
	.short _0221E0D8 - _0221E0CE - 2 ; case 0
	.short _0221E0E6 - _0221E0CE - 2 ; case 1
	.short _0221E12A - _0221E0CE - 2 ; case 2
	.short _0221E170 - _0221E0CE - 2 ; case 3
	.short _0221E250 - _0221E0CE - 2 ; case 4
_0221E0D8:
	mov r0, #2
	mov r1, #1
	bl ToggleBgLayer
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E0E6:
	ldr r0, [r4, #0x48]
	mov r1, #2
	bl ov07_0221FB04
	add r5, r0, #0
	ldr r0, [r4, #0x48]
	mov r1, #1
	bl ov07_0221FB04
	lsl r1, r5, #0x18
	add r6, r0, #0
	mov r0, #3
	lsr r1, r1, #0x18
	bl SetBgPriority
	lsl r1, r6, #0x18
	mov r0, #2
	lsr r1, r1, #0x18
	bl SetBgPriority
	ldrb r0, [r4, #0xa]
	mov r1, #4
	mov r2, #8
	str r0, [sp]
	ldrb r3, [r4, #9]
	ldr r0, _0221E278 ; =0x04000050
	bl G2x_SetBlendAlpha_
	add r0, r4, #0
	bl ov07_0221DEC0
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E12A:
	ldrb r1, [r4, #9]
	ldrb r0, [r4, #0xb]
	mov r2, #0
	cmp r1, r0
	bhs _0221E13A
	add r0, r1, #2
	strb r0, [r4, #9]
	b _0221E13C
_0221E13A:
	add r2, r2, #1
_0221E13C:
	ldrb r1, [r4, #0xa]
	ldrb r0, [r4, #0xc]
	cmp r1, r0
	bls _0221E14A
	sub r0, r1, #2
	strb r0, [r4, #0xa]
	b _0221E14C
_0221E14A:
	add r2, r2, #1
_0221E14C:
	cmp r2, #2
	bne _0221E162
	ldrb r0, [r4, #0xb]
	add r0, r0, #2
	strb r0, [r4, #9]
	ldrb r0, [r4, #0xc]
	sub r0, r0, #2
	strb r0, [r4, #0xa]
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E162:
	ldrb r0, [r4, #0xa]
	ldrb r1, [r4, #9]
	lsl r0, r0, #8
	orr r1, r0
	ldr r0, _0221E27C ; =0x04000052
	strh r1, [r0]
	b _0221E272
_0221E170:
	add r0, r4, #0
	bl ov07_0221E664
	ldr r0, [r4, #0x48]
	mov r2, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #3
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	ldr r0, [r4, #0x48]
	mov r1, #3
	add r0, #0xc4
	ldr r0, [r0]
	add r2, r1, #0
	mov r3, #0
	bl BgSetPosTextAndCommit
	ldr r0, [r4, #0x48]
	mov r1, #3
	add r0, #0xc4
	ldr r0, [r0]
	mov r2, #2
	mov r3, #4
	bl SetBgControlParam
	ldr r0, [r4, #0x48]
	bl ov07_0221BFC0
	cmp r0, #0
	bne _0221E1D0
	ldr r0, [r4, #0x48]
	mov r1, #3
	add r0, #0xc4
	ldr r0, [r0]
	mov r2, #0
	mov r3, #1
	bl SetBgControlParam
	ldr r0, [r4, #0x48]
	mov r1, #3
	bl ov07_0221FB30
	ldr r0, [r4, #0x48]
	bl ov07_0221FB58
	b _0221E224
_0221E1D0:
	ldr r2, [r4, #0x48]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r2]
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [sp, #0xc]
	ldr r0, [r2, r1]
	add r1, r1, #4
	ldr r1, [r2, r1]
	add r2, #0xc4
	ldr r2, [r2]
	mov r3, #3
	bl GfGfxLoader_LoadCharData
	mov r2, #0x69
	lsl r2, r2, #2
	add r1, r2, #0
	ldr r3, [r4, #0x48]
	mov r0, #0
	str r0, [sp]
	ldr r0, [r3, r2]
	sub r1, #0x14
	lsl r0, r0, #5
	str r0, [sp, #4]
	sub r0, r2, #4
	ldr r0, [r3, r0]
	sub r2, #0xc
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	add r0, r3, #0
	add r0, #0xc8
	ldr r0, [r0]
	ldr r1, [r3, r1]
	ldr r2, [r3, r2]
	ldr r3, [r3]
	bl PaletteData_LoadNarc
_0221E224:
	ldr r2, [r4, #0x48]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r2]
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [sp, #0xc]
	ldr r0, [r2, r1]
	add r1, #0xc
	ldr r1, [r2, r1]
	add r2, #0xc4
	ldr r2, [r2]
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
	b _0221E272
_0221E250:
	bl BattleSystem_SetDefaultBlend
	mov r0, #2
	mov r1, #0
	bl ToggleBgLayer
	ldr r0, [r4, #0x48]
	mov r1, #2
	bl ov07_0221EC7C
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
	b _0221E272
_0221E26C:
	add sp, #0x10
	mov r0, #0
	pop {r4, r5, r6, pc}
_0221E272:
	mov r0, #1
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221E278: .word 0x04000050
_0221E27C: .word 0x04000052
	thumb_func_end ov07_0221E0B4

	thumb_func_start ov07_0221E280
ov07_0221E280: ; 0x0221E280
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r1, #0
	ldrb r0, [r4, #5]
	cmp r0, #0
	beq _0221E292
	cmp r0, #1
	beq _0221E316
	b _0221E39A
_0221E292:
	ldrb r0, [r4, #0xd]
	ldr r2, [r4, #0x48]
	cmp r0, #0
	bne _0221E2D4
	mov r1, #0
	str r1, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	mov r3, #0x6a
	str r1, [sp, #8]
	add r0, r2, #0
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	mov r3, #0xe
	add r0, #0xc8
	lsl r2, r2, #0x10
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	mov r1, #1
	lsr r2, r2, #0x10
	bl PaletteData_ForceBeginPaletteFade
	mov r1, #0
	str r1, [sp]
	ldr r0, [r4, #0x48]
	mov r2, #2
	add r0, #0xc8
	ldr r0, [r0]
	lsl r2, r2, #8
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	b _0221E310
_0221E2D4:
	mov r0, #0
	str r0, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	ldr r0, _0221E3B4 ; =0x0000FFFF
	mov r3, #0x6a
	str r0, [sp, #8]
	add r0, r2, #0
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	mov r3, #0xe
	add r0, #0xc8
	lsl r2, r2, #0x10
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	mov r1, #1
	lsr r2, r2, #0x10
	bl PaletteData_ForceBeginPaletteFade
	ldr r0, _0221E3B4 ; =0x0000FFFF
	mov r2, #2
	str r0, [sp]
	ldr r0, [r4, #0x48]
	mov r1, #0
	add r0, #0xc8
	ldr r0, [r0]
	lsl r2, r2, #8
	mov r3, #0x10
	bl PaletteData_BlendPalettes
_0221E310:
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E316:
	ldr r0, [r4, #0x48]
	add r0, #0xc8
	ldr r0, [r0]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	bne _0221E3AE
	ldr r0, [r4, #0x48]
	mov r2, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #3
	add r3, r2, #0
	bl SetBgControlParam
	ldr r1, [r4, #0x48]
	ldr r3, [r4, #0x10]
	add r0, r4, #0
	mov r2, #3
	bl ov07_0221DE04
	ldrb r0, [r4, #0xd]
	cmp r0, #0
	bne _0221E364
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #0x48]
	mov r3, #0xe
	add r0, #0xc8
	mov r1, #1
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	lsl r2, r1, #9
	bl PaletteData_ForceBeginPaletteFade
	b _0221E382
_0221E364:
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _0221E3B4 ; =0x0000FFFF
	mov r3, #0xe
	str r0, [sp, #8]
	ldr r0, [r4, #0x48]
	mov r1, #1
	add r0, #0xc8
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	lsl r2, r1, #9
	bl PaletteData_ForceBeginPaletteFade
_0221E382:
	add r0, r4, #0
	bl ov07_0221DEC0
	mov r0, #0x5f
	ldr r1, [r4, #0x48]
	mov r2, #2
	lsl r0, r0, #2
	strb r2, [r1, r0]
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
	b _0221E3AE
_0221E39A:
	ldr r0, [r4, #0x48]
	add r0, #0xc8
	ldr r0, [r0]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	bne _0221E3AE
	add sp, #0xc
	mov r0, #0
	pop {r3, r4, pc}
_0221E3AE:
	mov r0, #1
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_0221E3B4: .word 0x0000FFFF
	thumb_func_end ov07_0221E280

	thumb_func_start ov07_0221E3B8
ov07_0221E3B8: ; 0x0221E3B8
	push {r4, lr}
	sub sp, #0x10
	add r4, r1, #0
	ldrb r0, [r4, #5]
	cmp r0, #3
	bls _0221E3C6
	b _0221E5B0
_0221E3C6:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_0221E3D2: ; jump table
	.short _0221E3DA - _0221E3D2 - 2 ; case 0
	.short _0221E3E6 - _0221E3D2 - 2 ; case 1
	.short _0221E468 - _0221E3D2 - 2 ; case 2
	.short _0221E536 - _0221E3D2 - 2 ; case 3
_0221E3DA:
	add r0, r4, #0
	bl ov07_0221DEC0
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E3E6:
	ldrb r0, [r4, #0xd]
	cmp r0, #0
	bne _0221E426
	mov r1, #0
	str r1, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	str r1, [sp, #8]
	ldr r0, [r4, #0x48]
	mov r3, #0xf
	add r0, #0xc8
	mov r1, #1
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	lsl r2, r1, #9
	bl PaletteData_ForceBeginPaletteFade
	ldr r3, [r4, #0x48]
	mov r1, #0
	mov r2, #0x6a
	add r0, r3, #0
	str r1, [sp]
	lsl r2, r2, #2
	ldr r2, [r3, r2]
	add r0, #0xc8
	lsl r2, r2, #0x10
	ldr r0, [r0]
	lsr r2, r2, #0x10
	mov r3, #0x10
	bl PaletteData_BlendPalettes
	b _0221E462
_0221E426:
	mov r0, #0
	str r0, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	ldr r0, _0221E5DC ; =0x0000FFFF
	mov r3, #0xf
	str r0, [sp, #8]
	ldr r0, [r4, #0x48]
	mov r1, #1
	add r0, #0xc8
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	lsl r2, r1, #9
	bl PaletteData_ForceBeginPaletteFade
	mov r2, #0x6a
	ldr r3, [r4, #0x48]
	ldr r0, _0221E5DC ; =0x0000FFFF
	lsl r2, r2, #2
	str r0, [sp]
	add r0, r3, #0
	ldr r2, [r3, r2]
	add r0, #0xc8
	lsl r2, r2, #0x10
	ldr r0, [r0]
	mov r1, #0
	lsr r2, r2, #0x10
	mov r3, #0x10
	bl PaletteData_BlendPalettes
_0221E462:
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E468:
	ldr r0, [r4, #0x48]
	add r0, #0xc8
	ldr r0, [r0]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	beq _0221E478
	b _0221E5D4
_0221E478:
	add r0, r4, #0
	bl ov07_0221E664
	mov r0, #3
	mov r1, #0
	bl ToggleBgLayer
	ldr r0, [r4, #0x48]
	bl ov07_0221BFC0
	cmp r0, #0
	bne _0221E4B0
	ldr r0, [r4, #0x48]
	mov r1, #3
	add r0, #0xc4
	ldr r0, [r0]
	mov r2, #0
	mov r3, #1
	bl SetBgControlParam
	ldr r0, [r4, #0x48]
	mov r1, #3
	bl ov07_0221FB30
	ldr r0, [r4, #0x48]
	bl ov07_0221FB58
	b _0221E504
_0221E4B0:
	ldr r2, [r4, #0x48]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r2]
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [sp, #0xc]
	ldr r0, [r2, r1]
	add r1, r1, #4
	ldr r1, [r2, r1]
	add r2, #0xc4
	ldr r2, [r2]
	mov r3, #3
	bl GfGfxLoader_LoadCharData
	mov r2, #0x69
	lsl r2, r2, #2
	add r1, r2, #0
	ldr r3, [r4, #0x48]
	mov r0, #0
	str r0, [sp]
	ldr r0, [r3, r2]
	sub r1, #0x14
	lsl r0, r0, #5
	str r0, [sp, #4]
	sub r0, r2, #4
	ldr r0, [r3, r0]
	sub r2, #0xc
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	add r0, r3, #0
	add r0, #0xc8
	ldr r0, [r0]
	ldr r1, [r3, r1]
	ldr r2, [r3, r2]
	ldr r3, [r3]
	bl PaletteData_LoadNarc
_0221E504:
	ldr r2, [r4, #0x48]
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r2]
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [sp, #0xc]
	ldr r0, [r2, r1]
	add r1, #0xc
	ldr r1, [r2, r1]
	add r2, #0xc4
	ldr r2, [r2]
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
	mov r0, #3
	mov r1, #1
	bl ToggleBgLayer
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E536:
	ldr r0, [r4, #0x48]
	mov r2, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #3
	add r3, r2, #0
	bl BgSetPosTextAndCommit
	ldr r0, [r4, #0x48]
	mov r1, #3
	add r0, #0xc4
	ldr r0, [r0]
	add r2, r1, #0
	mov r3, #0
	bl BgSetPosTextAndCommit
	ldrb r0, [r4, #0xd]
	ldr r2, [r4, #0x48]
	cmp r0, #0
	bne _0221E584
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	mov r3, #0x6a
	str r0, [sp, #8]
	add r0, r2, #0
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	mov r3, #0xf
	add r0, #0xc8
	lsl r2, r2, #0x10
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	mov r1, #1
	lsr r2, r2, #0x10
	bl PaletteData_ForceBeginPaletteFade
	b _0221E5AA
_0221E584:
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, _0221E5DC ; =0x0000FFFF
	mov r3, #0x6a
	str r0, [sp, #8]
	add r0, r2, #0
	lsl r3, r3, #2
	ldr r2, [r2, r3]
	mov r3, #0xf
	add r0, #0xc8
	lsl r2, r2, #0x10
	ldrsb r3, [r4, r3]
	ldr r0, [r0]
	mov r1, #1
	lsr r2, r2, #0x10
	bl PaletteData_ForceBeginPaletteFade
_0221E5AA:
	ldrb r0, [r4, #5]
	add r0, r0, #1
	strb r0, [r4, #5]
_0221E5B0:
	ldr r0, [r4, #0x48]
	add r0, #0xc8
	ldr r0, [r0]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	bne _0221E5D4
	mov r0, #0x5f
	ldr r1, [r4, #0x48]
	mov r2, #2
	lsl r0, r0, #2
	strb r2, [r1, r0]
	ldrb r0, [r4, #5]
	add sp, #0x10
	add r0, r0, #1
	strb r0, [r4, #5]
	mov r0, #0
	pop {r4, pc}
_0221E5D4:
	mov r0, #1
	add sp, #0x10
	pop {r4, pc}
	nop
_0221E5DC: .word 0x0000FFFF
	thumb_func_end ov07_0221E3B8

	thumb_func_start ov07_0221E5E0
ov07_0221E5E0: ; 0x0221E5E0
	push {r3, lr}
	add r0, r1, #0
	bl ov07_0221DEC0
	mov r0, #0
	pop {r3, pc}
	thumb_func_end ov07_0221E5E0

	thumb_func_start ov07_0221E5EC
ov07_0221E5EC: ; 0x0221E5EC
	push {r4, lr}
	add r4, r1, #0
	add r0, r4, #0
	bl ov07_0221DEC0
	add r0, r4, #0
	bl ov07_0221E664
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov07_0221E5EC

	thumb_func_start ov07_0221E600
ov07_0221E600: ; 0x0221E600
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	ldr r0, [r4, #0x18]
	cmp r0, #1
	bne _0221E61A
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
	pop {r3, r4, r5, pc}
_0221E61A:
	mov r3, #4
	mov r1, #8
	ldrsh r2, [r4, r3]
	ldrsh r0, [r4, r1]
	add r0, r2, r0
	strh r0, [r4, #4]
	mov r0, #6
	ldrsh r2, [r4, r0]
	mov r0, #0xa
	ldrsh r0, [r4, r0]
	add r0, r2, r0
	strh r0, [r4, #6]
	ldrsh r0, [r4, r1]
	cmp r0, #0
	beq _0221E648
	ldr r1, [r4, #0xc]
	ldrsh r3, [r4, r3]
	lsl r1, r1, #0x18
	ldr r0, [r4]
	lsr r1, r1, #0x18
	mov r2, #0
	bl BgSetPosTextAndCommit
_0221E648:
	mov r0, #0xa
	ldrsh r0, [r4, r0]
	cmp r0, #0
	beq _0221E662
	ldr r1, [r4, #0xc]
	mov r3, #6
	lsl r1, r1, #0x18
	ldrsh r3, [r4, r3]
	ldr r0, [r4]
	lsr r1, r1, #0x18
	mov r2, #3
	bl BgSetPosTextAndCommit
_0221E662:
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221E600

	thumb_func_start ov07_0221E664
ov07_0221E664: ; 0x0221E664
	push {r4, lr}
	add r4, r0, #0
	bne _0221E66E
	bl GF_AssertFail
_0221E66E:
	ldr r0, [r4, #0x48]
	cmp r0, #0
	bne _0221E678
	bl GF_AssertFail
_0221E678:
	add r0, r4, #0
	add r0, #0x44
	ldrh r1, [r0]
	lsl r0, r1, #0x1f
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _0221E696
	mov r0, #6
	ldr r1, [r4, #0x48]
	lsl r0, r0, #6
	add r0, r1, r0
	mov r1, #1
	bl ov07_0221DD14
	pop {r4, pc}
_0221E696:
	lsl r0, r1, #0x1e
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _0221E6AE
	mov r0, #6
	ldr r1, [r4, #0x48]
	lsl r0, r0, #6
	add r0, r1, r0
	mov r1, #2
	bl ov07_0221DD14
	pop {r4, pc}
_0221E6AE:
	lsl r0, r1, #0x1d
	lsr r0, r0, #0x1f
	cmp r0, #1
	bne _0221E6C4
	mov r0, #6
	ldr r1, [r4, #0x48]
	lsl r0, r0, #6
	add r0, r1, r0
	mov r1, #3
	bl ov07_0221DD14
_0221E6C4:
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov07_0221E664

	thumb_func_start ov07_0221E6C8
ov07_0221E6C8: ; 0x0221E6C8
	mov r1, #0x6a
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bx lr
	thumb_func_end ov07_0221E6C8

	thumb_func_start ov07_0221E6D0
ov07_0221E6D0: ; 0x0221E6D0
	mov r0, #0
	bx lr
	thumb_func_end ov07_0221E6D0

	thumb_func_start ov07_0221E6D4
ov07_0221E6D4: ; 0x0221E6D4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x48]
	mov r1, #0x28
	ldr r0, [r0]
	bl Heap_Alloc
	add r4, r0, #0
	ldr r0, [r5, #0x48]
	mov r2, #6
	add r0, #0xc4
	ldr r0, [r0]
	str r0, [r4]
	ldr r0, [r5, #0x48]
	add r0, #0x9c
	ldr r0, [r0]
	strh r0, [r4, #4]
	ldr r0, [r5, #0x48]
	add r0, #0xa0
	ldr r0, [r0]
	strh r0, [r4, #6]
	ldr r0, [r5, #0x48]
	add r0, #0x94
	ldr r0, [r0]
	strh r0, [r4, #8]
	ldr r0, [r5, #0x48]
	add r0, #0x98
	ldr r0, [r0]
	strh r0, [r4, #0xa]
	mov r0, #3
	str r0, [r4, #0xc]
	str r0, [r4, #0x10]
	ldr r1, [r5, #0x48]
	add r0, r5, #0
	bl ov07_0221DDB0
	cmp r0, #1
	bne _0221E748
	mov r0, #8
	ldrsh r1, [r4, r0]
	sub r0, #9
	mul r0, r1
	strh r0, [r4, #8]
	mov r0, #0xa
	ldrsh r1, [r4, r0]
	sub r0, #0xb
	mul r0, r1
	strh r0, [r4, #0xa]
	mov r0, #4
	ldrsh r1, [r4, r0]
	sub r0, r0, #5
	mul r0, r1
	strh r0, [r4, #4]
	mov r0, #6
	ldrsh r1, [r4, r0]
	sub r0, r0, #7
	mul r0, r1
	strh r0, [r4, #6]
_0221E748:
	mov r2, #1
	str r2, [r4, #0x14]
	mov r0, #0
	str r0, [r4, #0x18]
	mov r0, #6
	ldr r1, [r5, #0x48]
	lsl r0, r0, #6
	add r0, r1, r0
	add r1, r4, #0
	bl ov07_0221DD38
	add r0, r5, #0
	add r0, #0x44
	ldrh r1, [r0]
	mov r0, #1
	add r5, #0x44
	bic r1, r0
	mov r0, #1
	orr r0, r1
	strh r0, [r5]
	ldr r0, _0221E780 ; =ov07_0221E600
	ldr r2, _0221E784 ; =0x00001001
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	mov r0, #0
	pop {r3, r4, r5, pc}
	nop
_0221E780: .word ov07_0221E600
_0221E784: .word 0x00001001
	thumb_func_end ov07_0221E6D4

	thumb_func_start ov07_0221E788
ov07_0221E788: ; 0x0221E788
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	ldr r4, [r0, #0x48]
	str r0, [sp]
	ldr r0, [r4]
	mov r1, #0x28
	bl Heap_Alloc
	add r6, r0, #0
	ldr r0, [r4]
	mov r1, #0xc4
	bl Heap_Alloc
	str r0, [r6, #0x20]
	mov r0, #6
	lsl r0, r0, #6
	add r0, r4, r0
	add r1, r6, #0
	mov r2, #2
	bl ov07_0221DD38
	ldr r0, [sp]
	mov r1, #2
	add r0, #0x44
	ldrh r0, [r0]
	add r2, r0, #0
	ldr r0, [sp]
	orr r2, r1
	add r0, #0x44
	strh r2, [r0]
	mov r0, #0
	str r0, [r6, #0x18]
	add r0, r4, #0
	bl ov07_0221FAF8
	bl ov07_02222D90
	add r5, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl ov07_02222D88
	add r1, r0, #0
	ldr r2, [r4]
	add r0, r5, #0
	bl ov07_02222BE4
	mov r4, #0
	ldr r1, [r6, #0x20]
	ldr r7, _0221E860 ; =ov07_02234C20
	add r1, #0xc0
	str r0, [r1]
	str r4, [sp, #4]
	add r5, r4, #0
_0221E7F4:
	ldr r0, [r6, #0x20]
	strh r4, [r0, r5]
	ldr r0, [r6, #0x20]
	add r1, r0, r5
	ldrsh r0, [r0, r5]
	add r0, #8
	strh r0, [r1, #2]
	mov r0, #0
	ldrsh r1, [r7, r0]
	ldr r0, [r6, #0x20]
	add r0, r0, r5
	strh r1, [r0, #4]
	ldr r0, [r6, #0x20]
	add r1, r0, r5
	mov r0, #0
	strh r0, [r1, #6]
	add r1, r0, #0
	bl ov07_02222D88
	ldr r1, [r6, #0x20]
	mov r2, #6
	add r1, r1, r5
	str r0, [r1, #8]
	ldr r0, [sp]
	add r1, r0, #0
	ldr r1, [r1, #0x48]
	bl ov07_0221DDB0
	cmp r0, #1
	bne _0221E83E
	ldr r0, [r6, #0x20]
	mov r1, #4
	add r0, r0, r5
	ldrsh r2, [r0, r1]
	sub r1, r1, #5
	mul r1, r2
	strh r1, [r0, #4]
_0221E83E:
	ldr r0, [sp, #4]
	add r4, #8
	add r0, r0, #1
	add r5, #0xc
	add r7, r7, #2
	str r0, [sp, #4]
	cmp r0, #0x10
	blt _0221E7F4
	mov r2, #1
	ldr r0, _0221E864 ; =ov07_0221E87C
	add r1, r6, #0
	lsl r2, r2, #0xc
	bl SysTask_CreateOnMainQueue
	mov r0, #0
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221E860: .word ov07_02234C20
_0221E864: .word ov07_0221E87C
	thumb_func_end ov07_0221E788

	thumb_func_start ov07_0221E868
ov07_0221E868: ; 0x0221E868
	add r1, r0, #0
	add r1, #0x44
	ldrh r2, [r1]
	mov r1, #2
	add r0, #0x44
	orr r1, r2
	strh r1, [r0]
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221E868

	thumb_func_start ov07_0221E87C
ov07_0221E87C: ; 0x0221E87C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r1, #0
	add r6, r0, #0
	ldr r0, [r5, #0x18]
	ldr r4, [r5, #0x20]
	cmp r0, #1
	bne _0221E8AA
	add r4, #0xc0
	ldr r0, [r4]
	bl ov07_02222C60
	ldr r0, [r5, #0x20]
	bl Heap_Free
	add r0, r5, #0
	bl Heap_Free
	add r0, r6, #0
	bl SysTask_Destroy
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
_0221E8AA:
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	bl ov07_02222C84
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
_0221E8BA:
	mov r0, #6
	ldrsh r1, [r4, r0]
	mov r0, #4
	ldrsh r0, [r4, r0]
	add r0, r1, r0
	strh r0, [r4, #6]
	mov r0, #0
	ldrsh r6, [r4, r0]
	mov r0, #2
	ldrsh r0, [r4, r0]
	cmp r6, r0
	bge _0221E902
	ldr r0, [sp]
	lsl r1, r6, #2
	add r5, r0, r1
	mov r7, #2
_0221E8DA:
	ldr r1, [r4, #8]
	mov r2, #6
	lsl r0, r1, #0x10
	asr r1, r1, #0x10
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	lsl r1, r1, #0x10
	ldrsh r2, [r4, r2]
	asr r0, r0, #0x10
	lsr r1, r1, #0x10
	add r0, r0, r2
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ov07_02222D88
	stmia r5!, {r0}
	ldrsh r0, [r4, r7]
	add r6, r6, #1
	cmp r6, r0
	blt _0221E8DA
_0221E902:
	ldr r0, [sp, #4]
	add r4, #0xc
	add r0, r0, #1
	str r0, [sp, #4]
	cmp r0, #0x10
	blt _0221E8BA
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov07_0221E87C

	thumb_func_start ov07_0221E914
ov07_0221E914: ; 0x0221E914
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r6, r1, #0
	add r5, r0, #0
	ldr r0, [r6, #0x18]
	ldr r4, [r6, #0x24]
	cmp r0, #1
	bne _0221E93A
	add r0, r4, #0
	bl Heap_Free
	add r0, r6, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
	add sp, #0x10
	pop {r4, r5, r6, pc}
_0221E93A:
	ldr r1, _0221E9CC ; =0x0000018B
	ldrb r0, [r4, r1]
	cmp r0, #0
	beq _0221E94A
	cmp r0, #1
	beq _0221E958
	add sp, #0x10
	pop {r4, r5, r6, pc}
_0221E94A:
	mov r2, #0xff
	add r0, r2, #0
	add r0, #0x8b
	strb r2, [r4, r0]
	ldrb r0, [r4, r1]
	add r0, r0, #1
	strb r0, [r4, r1]
_0221E958:
	mov r2, #0x63
	lsl r2, r2, #2
	ldrb r1, [r4, r2]
	sub r0, r2, #2
	ldrb r0, [r4, r0]
	lsl r3, r1, #1
	add r3, r4, r3
	add r3, #0x88
	ldrh r3, [r3]
	sub r3, r3, #2
	cmp r0, r3
	bge _0221E97E
	sub r0, r2, #2
	ldrb r0, [r4, r0]
	add sp, #0x10
	add r1, r0, #1
	sub r0, r2, #2
	strb r1, [r4, r0]
	pop {r4, r5, r6, pc}
_0221E97E:
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r2, #0x90
	str r2, [sp, #8]
	add r0, r4, r1
	ldrb r0, [r0, #8]
	add r2, #0xf9
	mov r1, #9
	lsl r0, r0, #0x14
	lsr r0, r0, #0x10
	str r0, [sp, #0xc]
	ldrb r2, [r4, r2]
	ldr r0, [r4, #4]
	ldr r3, [r4]
	bl PaletteData_LoadFromNarc
	ldr r1, _0221E9D0 ; =0x0000018A
	mov r0, #0
	strb r0, [r4, r1]
	add r2, r1, #2
	ldrb r3, [r4, r2]
	sub r2, r1, #2
	ldrb r2, [r4, r2]
	sub r2, r2, #1
	cmp r3, r2
	blt _0221E9BE
	add r1, r1, #2
	add sp, #0x10
	strb r0, [r4, r1]
	pop {r4, r5, r6, pc}
_0221E9BE:
	add r0, r1, #2
	ldrb r0, [r4, r0]
	add r2, r0, #1
	add r0, r1, #2
	strb r2, [r4, r0]
	add sp, #0x10
	pop {r4, r5, r6, pc}
	.balign 4, 0
_0221E9CC: .word 0x0000018B
_0221E9D0: .word 0x0000018A
	thumb_func_end ov07_0221E914

	thumb_func_start ov07_0221E9D4
ov07_0221E9D4: ; 0x0221E9D4
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r6, [r5, #0x48]
	mov r1, #0x28
	ldr r0, [r6]
	bl Heap_Alloc
	mov r1, #0
	mov r2, #0x28
	add r4, r0, #0
	bl MI_CpuFill8
	mov r1, #0x19
	ldr r0, [r6]
	lsl r1, r1, #4
	bl Heap_Alloc
	mov r2, #0x19
	mov r1, #0
	lsl r2, r2, #4
	str r0, [r4, #0x24]
	bl MI_CpuFill8
	add r0, r5, #0
	add r0, #0x44
	ldrh r1, [r0]
	mov r0, #4
	mov r2, #3
	orr r1, r0
	add r0, r5, #0
	add r0, #0x44
	strh r1, [r0]
	mov r0, #0
	str r0, [r4, #0x18]
	ldr r1, [r6]
	ldr r0, [r4, #0x24]
	str r1, [r0]
	add r0, r6, #0
	add r0, #0xc8
	ldr r1, [r0]
	ldr r0, [r4, #0x24]
	str r1, [r0, #4]
	mov r0, #6
	lsl r0, r0, #6
	add r0, r6, r0
	add r1, r4, #0
	bl ov07_0221DD38
	ldr r0, [r5, #0x10]
	cmp r0, #0x34
	bhi _0221EA8E
	bhs _0221EAB0
	cmp r0, #0x1d
	bhi _0221EA88
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221EA4C: ; jump table
	.short _0221EAA0 - _0221EA4C - 2 ; case 0
	.short _0221EAA0 - _0221EA4C - 2 ; case 1
	.short _0221EAD4 - _0221EA4C - 2 ; case 2
	.short _0221EAA0 - _0221EA4C - 2 ; case 3
	.short _0221EAA4 - _0221EA4C - 2 ; case 4
	.short _0221EAA0 - _0221EA4C - 2 ; case 5
	.short _0221EAE0 - _0221EA4C - 2 ; case 6
	.short _0221EAC8 - _0221EA4C - 2 ; case 7
	.short _0221EAE0 - _0221EA4C - 2 ; case 8
	.short _0221EAE0 - _0221EA4C - 2 ; case 9
	.short _0221EAE0 - _0221EA4C - 2 ; case 10
	.short _0221EAD8 - _0221EA4C - 2 ; case 11
	.short _0221EAE0 - _0221EA4C - 2 ; case 12
	.short _0221EAE0 - _0221EA4C - 2 ; case 13
	.short _0221EACC - _0221EA4C - 2 ; case 14
	.short _0221EAE0 - _0221EA4C - 2 ; case 15
	.short _0221EAE0 - _0221EA4C - 2 ; case 16
	.short _0221EAD0 - _0221EA4C - 2 ; case 17
	.short _0221EAE0 - _0221EA4C - 2 ; case 18
	.short _0221EAA8 - _0221EA4C - 2 ; case 19
	.short _0221EAE0 - _0221EA4C - 2 ; case 20
	.short _0221EAE0 - _0221EA4C - 2 ; case 21
	.short _0221EAB4 - _0221EA4C - 2 ; case 22
	.short _0221EAE0 - _0221EA4C - 2 ; case 23
	.short _0221EAE0 - _0221EA4C - 2 ; case 24
	.short _0221EAE0 - _0221EA4C - 2 ; case 25
	.short _0221EAE0 - _0221EA4C - 2 ; case 26
	.short _0221EAE0 - _0221EA4C - 2 ; case 27
	.short _0221EABC - _0221EA4C - 2 ; case 28
	.short _0221EAC0 - _0221EA4C - 2 ; case 29
_0221EA88:
	cmp r0, #0x2c
	beq _0221EADC
	b _0221EAE0
_0221EA8E:
	cmp r0, #0x39
	bhi _0221EA9A
	bhs _0221EAC4
	cmp r0, #0x35
	beq _0221EAAC
	b _0221EAE0
_0221EA9A:
	cmp r0, #0x3a
	beq _0221EAB8
	b _0221EAE0
_0221EAA0:
	mov r5, #0
	b _0221EAEC
_0221EAA4:
	mov r5, #2
	b _0221EAEC
_0221EAA8:
	mov r5, #4
	b _0221EAEC
_0221EAAC:
	mov r5, #6
	b _0221EAEC
_0221EAB0:
	mov r5, #8
	b _0221EAEC
_0221EAB4:
	mov r5, #0xa
	b _0221EAEC
_0221EAB8:
	mov r5, #0xc
	b _0221EAEC
_0221EABC:
	mov r5, #0xe
	b _0221EAEC
_0221EAC0:
	mov r5, #0x10
	b _0221EAEC
_0221EAC4:
	mov r5, #0x1a
	b _0221EAEC
_0221EAC8:
	mov r5, #0x1c
	b _0221EAEC
_0221EACC:
	mov r5, #0x14
	b _0221EAEC
_0221EAD0:
	mov r5, #0x12
	b _0221EAEC
_0221EAD4:
	mov r5, #0x16
	b _0221EAEC
_0221EAD8:
	mov r5, #0x18
	b _0221EAEC
_0221EADC:
	mov r5, #0x1e
	b _0221EAEC
_0221EAE0:
	ldr r0, _0221EB70 ; =ov07_02237870
	cmp r0, #0
	beq _0221EAEA
	bl GF_AssertFail
_0221EAEA:
	mov r5, #0
_0221EAEC:
	mov r0, #1
	str r0, [sp]
	ldr r3, [r6]
	mov r0, #9
	add r1, r5, #0
	mov r2, #0
	bl GfGfxLoader_LoadFromNarc
	add r7, r0, #0
	bne _0221EB04
	bl GF_AssertFail
_0221EB04:
	ldr r1, [r4, #0x24]
	ldr r0, _0221EB74 ; =0x00000189
	add r2, r5, #1
	strb r2, [r1, r0]
	ldrb r3, [r7]
	mov r1, #0
	add r0, r7, #0
	cmp r3, #0xff
	beq _0221EB2A
_0221EB16:
	ldr r2, [r4, #0x24]
	add r0, r0, #1
	add r2, r2, r1
	strb r3, [r2, #8]
	add r1, r1, #1
	lsl r1, r1, #0x10
	ldrb r3, [r0]
	lsr r1, r1, #0x10
	cmp r3, #0xff
	bne _0221EB16
_0221EB2A:
	mov r0, #0x62
	ldr r2, [r4, #0x24]
	lsl r0, r0, #2
	strb r1, [r2, r0]
	add r0, r7, #0
	add r0, #0x80
	ldrh r5, [r0]
	add r3, r7, #0
	ldr r0, _0221EB78 ; =0x0000FF98
	mov r6, #0
	add r3, #0x80
	cmp r5, r0
	beq _0221EB5C
_0221EB44:
	ldr r2, [r4, #0x24]
	lsl r1, r6, #1
	add r1, r2, r1
	add r1, #0x88
	strh r5, [r1]
	add r3, r3, #2
	add r1, r6, #1
	lsl r1, r1, #0x10
	ldrh r5, [r3]
	lsr r6, r1, #0x10
	cmp r5, r0
	bne _0221EB44
_0221EB5C:
	add r0, r7, #0
	bl Heap_Free
	ldr r0, _0221EB7C ; =ov07_0221E914
	ldr r2, _0221EB80 ; =0x00001001
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_0221EB70: .word ov07_02237870
_0221EB74: .word 0x00000189
_0221EB78: .word 0x0000FF98
_0221EB7C: .word ov07_0221E914
_0221EB80: .word 0x00001001
	thumb_func_end ov07_0221E9D4

	thumb_func_start ov07_0221EB84
ov07_0221EB84: ; 0x0221EB84
	add r1, r0, #0
	add r1, #0x44
	ldrh r2, [r1]
	mov r1, #4
	add r0, #0x44
	orr r1, r2
	strh r1, [r0]
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221EB84

	thumb_func_start ov07_0221EB98
ov07_0221EB98: ; 0x0221EB98
	ldr r3, _0221EBA0 ; =ov07_0221EBA4
	mov r2, #1
	bx r3
	nop
_0221EBA0: .word ov07_0221EBA4
	thumb_func_end ov07_0221EB98

	thumb_func_start ov07_0221EBA4
ov07_0221EBA4: ; 0x0221EBA4
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r4, r1, #0
	mov r1, #2
	add r5, r0, #0
	add r6, r2, #0
	bl ov07_0221FB04
	add r1, r0, #0
	lsl r0, r4, #0x18
	lsl r1, r1, #0x18
	lsr r0, r0, #0x18
	lsr r1, r1, #0x18
	bl SetBgPriority
	lsl r0, r4, #0x18
	lsr r0, r0, #0x18
	mov r1, #0
	bl ToggleBgLayer
	add r0, r5, #0
	bl ov07_0221BFC0
	cmp r0, #1
	bne _0221EBEA
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #2
	mov r3, #4
	bl SetBgControlParam
	b _0221EC10
_0221EBEA:
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	lsl r3, r6, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #0
	lsr r3, r3, #0x18
	bl SetBgControlParam
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #2
	mov r3, #4
	bl SetBgControlParam
_0221EC10:
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	bl BgClearTilemapBufferAndCommit
	add r0, r5, #0
	bl ov07_0221BFC0
	cmp r0, #1
	bne _0221EC4E
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5]
	mov r1, #0x19
	add r2, r5, #0
	lsl r1, r1, #4
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, r1, #4
	add r2, #0xc4
	ldr r1, [r5, r1]
	ldr r2, [r2]
	add r3, r4, #0
	bl GfGfxLoader_LoadCharData
	b _0221EC56
_0221EC4E:
	add r0, r5, #0
	add r1, r4, #0
	bl ov07_0221FB30
_0221EC56:
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5]
	mov r1, #0x19
	lsl r1, r1, #4
	str r0, [sp, #0xc]
	ldr r0, [r5, r1]
	add r1, #0xc
	ldr r1, [r5, r1]
	add r5, #0xc4
	ldr r2, [r5]
	add r3, r4, #0
	bl GfGfxLoader_LoadScrnData
	add sp, #0x10
	pop {r4, r5, r6, pc}
	thumb_func_end ov07_0221EBA4

	thumb_func_start ov07_0221EC7C
ov07_0221EC7C: ; 0x0221EC7C
	push {r3, r4, r5, lr}
	add r4, r1, #0
	mov r1, #1
	add r5, r0, #0
	bl ov07_0221FB04
	add r1, r0, #0
	lsl r0, r4, #0x18
	lsl r1, r1, #0x18
	lsr r0, r0, #0x18
	lsr r1, r1, #0x18
	bl SetBgPriority
	add r0, r5, #0
	bl ov07_0221BFC0
	cmp r0, #1
	bne _0221ECB4
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #2
	mov r3, #3
	bl SetBgControlParam
	b _0221ECD8
_0221ECB4:
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	mov r2, #0
	ldr r0, [r0]
	lsr r1, r1, #0x18
	add r3, r2, #0
	bl SetBgControlParam
	add r0, r5, #0
	add r0, #0xc4
	lsl r1, r4, #0x18
	ldr r0, [r0]
	lsr r1, r1, #0x18
	mov r2, #2
	mov r3, #3
	bl SetBgControlParam
_0221ECD8:
	add r5, #0xc4
	lsl r1, r4, #0x18
	ldr r0, [r5]
	lsr r1, r1, #0x18
	bl BgClearTilemapBufferAndCommit
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov07_0221EC7C

	thumb_func_start ov07_0221ECE8
ov07_0221ECE8: ; 0x0221ECE8
	add r1, r0, #0
	add r1, #0x44
	ldrh r2, [r1]
	mov r1, #1
	add r0, #0x44
	bic r2, r1
	mov r1, #1
	orr r1, r2
	strh r1, [r0]
	mov r0, #0
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221ECE8

	thumb_func_start ov07_0221ED00
ov07_0221ED00: ; 0x0221ED00
	push {r3, lr}
	ldr r1, [r0, #0x48]
	mov r0, #6
	lsl r0, r0, #6
	add r0, r1, r0
	mov r1, #5
	bl ov07_0221DD14
	mov r0, #0
	pop {r3, pc}
	thumb_func_end ov07_0221ED00

	thumb_func_start ov07_0221ED14
ov07_0221ED14: ; 0x0221ED14
	push {r3, r4, r5, lr}
	add r4, r1, #0
	ldr r2, [r4, #0x14]
	add r5, r0, #0
	lsl r3, r2, #2
	ldr r2, _0221ED40 ; =ov07_02234BC0
	ldr r2, [r2, r3]
	blx r2
	cmp r0, #0
	bne _0221ED3E
	mov r0, #0x5f
	ldr r1, [r4, #0x48]
	mov r2, #0
	lsl r0, r0, #2
	strb r2, [r1, r0]
	add r0, r4, #0
	bl Heap_Free
	add r0, r5, #0
	bl SysTask_Destroy
_0221ED3E:
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221ED40: .word ov07_02234BC0
	thumb_func_end ov07_0221ED14

	thumb_func_start ov07_0221ED44
ov07_0221ED44: ; 0x0221ED44
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221DF1C
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #4
	bl ov07_0221C4A8
	strb r0, [r4, #0xd]
	ldr r0, [r5, #0x18]
	ldr r2, _0221ED88 ; =0x0000044C
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	str r0, [r4, #0x10]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	lsl r0, r1, #0x10
	lsr r0, r0, #0x10
	str r0, [r4, #0x14]
	ldr r0, _0221ED8C ; =0xFFFF0000
	and r0, r1
	lsr r0, r0, #0x10
	str r0, [r4, #0x18]
	ldr r0, _0221ED90 ; =ov07_0221ED14
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221ED88: .word 0x0000044C
_0221ED8C: .word 0xFFFF0000
_0221ED90: .word ov07_0221ED14
	thumb_func_end ov07_0221ED44

	thumb_func_start ov07_0221ED94
ov07_0221ED94: ; 0x0221ED94
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221DF1C
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #4
	bl ov07_0221C4A8
	strb r0, [r4, #0xd]
	ldr r0, [r5, #0x18]
	ldr r2, _0221EE64 ; =0xFFFF0000
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	str r0, [r4, #0x10]
	ldr r0, [r5, #0x18]
	add r1, r0, #4
	str r1, [r5, #0x18]
	ldr r0, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	lsl r1, r0, #0x10
	lsr r1, r1, #0x10
	and r0, r2
	str r1, [r4, #0x14]
	lsr r0, r0, #0x10
	str r0, [r4, #0x18]
	ldr r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r1, #0
	and r0, r2
	lsr r0, r0, #0x10
	lsl r1, r1, #0x10
	lsl r0, r0, #0x10
	asr r1, r1, #0x10
	asr r0, r0, #0x10
	cmp r1, #6
	bhi _0221EE4C
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221EDF2: ; jump table
	.short _0221EE4C - _0221EDF2 - 2 ; case 0
	.short _0221EE00 - _0221EDF2 - 2 ; case 1
	.short _0221EE0A - _0221EDF2 - 2 ; case 2
	.short _0221EE14 - _0221EDF2 - 2 ; case 3
	.short _0221EE1E - _0221EDF2 - 2 ; case 4
	.short _0221EE28 - _0221EDF2 - 2 ; case 5
	.short _0221EE3A - _0221EDF2 - 2 ; case 6
_0221EE00:
	mov r1, #0xe
	ldrsb r1, [r4, r1]
	add r0, r1, r0
	strb r0, [r4, #0xe]
	b _0221EE56
_0221EE0A:
	mov r1, #0xe
	ldrsb r1, [r4, r1]
	sub r0, r1, r0
	strb r0, [r4, #0xe]
	b _0221EE56
_0221EE14:
	mov r1, #0xf
	ldrsb r1, [r4, r1]
	add r0, r1, r0
	strb r0, [r4, #0xf]
	b _0221EE56
_0221EE1E:
	mov r1, #0xf
	ldrsb r1, [r4, r1]
	sub r0, r1, r0
	strb r0, [r4, #0xf]
	b _0221EE56
_0221EE28:
	mov r1, #0xe
	ldrsb r1, [r4, r1]
	add r1, r1, r0
	strb r1, [r4, #0xe]
	mov r1, #0xf
	ldrsb r1, [r4, r1]
	add r0, r1, r0
	strb r0, [r4, #0xf]
	b _0221EE56
_0221EE3A:
	mov r1, #0xe
	ldrsb r1, [r4, r1]
	sub r1, r1, r0
	strb r1, [r4, #0xe]
	mov r1, #0xf
	ldrsb r1, [r4, r1]
	sub r0, r1, r0
	strb r0, [r4, #0xf]
	b _0221EE56
_0221EE4C:
	ldr r0, _0221EE68 ; =ov07_0223789C
	cmp r0, #0
	beq _0221EE56
	bl GF_AssertFail
_0221EE56:
	ldr r0, _0221EE6C ; =ov07_0221ED14
	ldr r2, _0221EE70 ; =0x0000044C
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, pc}
	nop
_0221EE64: .word 0xFFFF0000
_0221EE68: .word ov07_0223789C
_0221EE6C: .word ov07_0221ED14
_0221EE70: .word 0x0000044C
	thumb_func_end ov07_0221ED94

	thumb_func_start ov07_0221EE74
ov07_0221EE74: ; 0x0221EE74
	push {r3, r4, r5, lr}
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r5, [r1]
	add r2, r1, #4
	str r2, [r0, #0x18]
	ldr r1, [r2]
	lsl r1, r1, #0x10
	asr r4, r1, #0x10
	add r1, r2, #4
	str r1, [r0, #0x18]
	mov r1, #6
	lsl r1, r1, #6
	add r0, r0, r1
	mov r1, #1
	bl ov07_0221DD8C
	cmp r5, #3
	bhi _0221EEBE
	add r1, r5, r5
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_0221EEA8: ; jump table
	.short _0221EEB0 - _0221EEA8 - 2 ; case 0
	.short _0221EEB4 - _0221EEA8 - 2 ; case 1
	.short _0221EEB8 - _0221EEA8 - 2 ; case 2
	.short _0221EEBC - _0221EEA8 - 2 ; case 3
_0221EEB0:
	strh r4, [r0, #8]
	pop {r3, r4, r5, pc}
_0221EEB4:
	strh r4, [r0, #0xa]
	pop {r3, r4, r5, pc}
_0221EEB8:
	strh r4, [r0, #4]
	pop {r3, r4, r5, pc}
_0221EEBC:
	strh r4, [r0, #4]
_0221EEBE:
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221EE74

	thumb_func_start ov07_0221EEC0
ov07_0221EEC0: ; 0x0221EEC0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221DF1C
	add r4, r0, #0
	add r0, r5, #0
	mov r1, #4
	bl ov07_0221C4A8
	strb r0, [r4, #0xd]
	ldr r0, [r5, #0x18]
	ldr r2, _0221EF08 ; =0x0000044C
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	str r0, [r4, #0x10]
	ldr r0, [r5, #0x18]
	add r1, r0, #4
	str r1, [r5, #0x18]
	ldr r0, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	lsl r1, r0, #0x10
	lsr r1, r1, #0x10
	add r1, r1, #3
	str r1, [r4, #0x14]
	ldr r1, _0221EF0C ; =0xFFFF0000
	and r0, r1
	lsr r0, r0, #0x10
	str r0, [r4, #0x18]
	ldr r0, _0221EF10 ; =ov07_0221ED14
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, pc}
	nop
_0221EF08: .word 0x0000044C
_0221EF0C: .word 0xFFFF0000
_0221EF10: .word ov07_0221ED14
	thumb_func_end ov07_0221EEC0

	thumb_func_start ov07_0221EF14
ov07_0221EF14: ; 0x0221EF14
	mov r1, #0x5f
	lsl r1, r1, #2
	ldrb r1, [r0, r1]
	cmp r1, #2
	bne _0221EF2C
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	mov r1, #0
	add r0, #0x8d
	strb r1, [r0]
	bx lr
_0221EF2C:
	mov r1, #1
	add r0, #0x8d
	strb r1, [r0]
	bx lr
	thumb_func_end ov07_0221EF14

	thumb_func_start ov07_0221EF34
ov07_0221EF34: ; 0x0221EF34
	mov r1, #0x5f
	lsl r1, r1, #2
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _0221EF4C
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	mov r1, #0
	add r0, #0x8d
	strb r1, [r0]
	bx lr
_0221EF4C:
	mov r1, #1
	add r0, #0x8d
	strb r1, [r0]
	bx lr
	thumb_func_end ov07_0221EF34

	thumb_func_start ov07_0221EF54
ov07_0221EF54: ; 0x0221EF54
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	bl ov07_0221DF1C
	add r7, r0, #0
	ldr r0, [r5, #0x18]
	mov r1, #0
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r4, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	mov r0, #3
	bl ToggleBgLayer
	add r0, r5, #0
	add r0, #0xc4
	mov r2, #0
	ldr r0, [r0]
	mov r1, #3
	add r3, r2, #0
	bl SetBgControlParam
	add r0, r4, #0
	mov r1, #0
	bl ov07_0221FB7C
	add r1, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5]
	add r2, r5, #0
	str r0, [sp, #0xc]
	add r2, #0xc4
	ldr r2, [r2]
	mov r0, #7
	mov r3, #3
	bl GfGfxLoader_LoadCharData
	add r0, r4, #0
	mov r1, #1
	bl ov07_0221FB7C
	add r2, r0, #0
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0x90
	str r0, [sp, #8]
	add r0, r5, #0
	add r0, #0xc8
	ldr r0, [r0]
	ldr r3, [r5]
	mov r1, #7
	bl PaletteData_LoadNarc
	add r0, r5, #0
	add r0, #0xc4
	ldr r0, [r0]
	mov r1, #3
	bl BgClearTilemapBufferAndCommit
	add r0, r7, #0
	add r1, r5, #0
	mov r2, #7
	mov r6, #2
	bl ov07_0221DDB0
	cmp r0, #1
	bne _0221EFEC
	mov r6, #3
_0221EFEC:
	add r0, r4, #0
	add r1, r6, #0
	bl ov07_0221FB7C
	add r1, r0, #0
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r5]
	add r5, #0xc4
	str r0, [sp, #0xc]
	ldr r2, [r5]
	mov r0, #7
	mov r3, #3
	bl GfGfxLoader_LoadScrnData
	mov r0, #3
	mov r1, #1
	bl ToggleBgLayer
	add r0, r7, #0
	bl Heap_Free
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov07_0221EF54

	thumb_func_start ov07_0221F024
ov07_0221F024: ; 0x0221F024
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	bl ov07_0221DF1C
	add r4, r0, #0
	ldr r0, [r5, #0x18]
	add r1, r0, #4
	str r1, [r5, #0x18]
	ldr r0, [r1]
	str r0, [sp]
	add r0, r1, #4
	str r0, [r5, #0x18]
	ldr r7, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r6, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	add r0, r5, #0
	bl ov07_0221BFC0
	cmp r0, #1
	bne _0221F056
	str r6, [r4, #0x10]
	b _0221F06E
_0221F056:
	add r0, r5, #0
	add r5, #0xc0
	ldr r1, [r5]
	ldrh r1, [r1, #0x16]
	bl ov07_0223192C
	cmp r0, #3
	bne _0221F06A
	str r7, [r4, #0x10]
	b _0221F06E
_0221F06A:
	ldr r0, [sp]
	str r0, [r4, #0x10]
_0221F06E:
	ldr r0, _0221F07C ; =ov07_0221ED14
	ldr r2, _0221F080 ; =0x0000044C
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221F07C: .word ov07_0221ED14
_0221F080: .word 0x0000044C
	thumb_func_end ov07_0221F024

	thumb_func_start ov07_0221F084
ov07_0221F084: ; 0x0221F084
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F084

	thumb_func_start ov07_0221F088
ov07_0221F088: ; 0x0221F088
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F088

	thumb_func_start ov07_0221F08C
ov07_0221F08C: ; 0x0221F08C
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F08C

	thumb_func_start ov07_0221F090
ov07_0221F090: ; 0x0221F090
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F090

	thumb_func_start ov07_0221F094
ov07_0221F094: ; 0x0221F094
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F094

	thumb_func_start ov07_0221F098
ov07_0221F098: ; 0x0221F098
	ldr r1, [r0, #0x18]
	ldr r3, _0221F0AC ; =PlaySE
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	lsl r0, r2, #0x10
	lsr r0, r0, #0x10
	bx r3
	.balign 4, 0
_0221F0AC: .word PlaySE
	thumb_func_end ov07_0221F098

	thumb_func_start ov07_0221F0B0
ov07_0221F0B0: ; 0x0221F0B0
	ldr r1, [r0, #0x18]
	ldr r3, _0221F0C8 ; =StopSE
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	lsl r0, r2, #0x10
	lsr r0, r0, #0x10
	mov r1, #0
	bx r3
	nop
_0221F0C8: .word StopSE
	thumb_func_end ov07_0221F0B0

	thumb_func_start ov07_0221F0CC
ov07_0221F0CC: ; 0x0221F0CC
	push {r3, r4, r5, lr}
	ldr r1, [r0, #0x18]
	add r2, r1, #4
	str r2, [r0, #0x18]
	ldr r1, [r2]
	lsl r1, r1, #0x10
	lsr r4, r1, #0x10
	add r1, r2, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	lsl r1, r2, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	add r5, r0, #0
	add r0, r4, #0
	bl PlaySE
	ldr r1, _0221F100 ; =0x0000FFFF
	add r0, r4, #0
	add r2, r5, #0
	bl sub_020061B4
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221F100: .word 0x0000FFFF
	thumb_func_end ov07_0221F0CC

	thumb_func_start ov07_0221F104
ov07_0221F104: ; 0x0221F104
	push {r3, lr}
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	lsl r1, r2, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	bl sub_020061EC
	pop {r3, pc}
	thumb_func_end ov07_0221F104

	thumb_func_start ov07_0221F120
ov07_0221F120: ; 0x0221F120
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221C53C
	mov r1, #0
	mov r2, #0x3c
	add r4, r0, #0
	bl memset
	mov r0, #1
	strb r0, [r4]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strh r0, [r4, #0x1a]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	str r0, [r4, #8]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	str r0, [r4, #0xc]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	str r0, [r4, #0x10]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strb r0, [r4, #3]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r4, #8]
	add r0, r5, #0
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	str r0, [r4, #8]
	ldr r1, [r4, #0xc]
	add r0, r5, #0
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	str r0, [r4, #0xc]
	ldr r0, [r4, #8]
	ldr r1, [r4, #0xc]
	ldr r2, [r4, #0x10]
	lsl r0, r0, #0x18
	lsl r1, r1, #0x18
	lsl r2, r2, #0x18
	asr r0, r0, #0x18
	asr r1, r1, #0x18
	asr r2, r2, #0x18
	bl ov07_0221F980
	str r0, [r4, #0x10]
	ldrh r0, [r4, #0x1a]
	bl PlaySE
	ldrh r0, [r4, #0x1a]
	ldr r1, _0221F1BC ; =0x0000FFFF
	ldr r2, [r4, #8]
	bl sub_020061B4
	add r0, r5, #0
	add r1, r4, #0
	bl ov07_0221C56C
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221F1BC: .word 0x0000FFFF
	thumb_func_end ov07_0221F120

	thumb_func_start ov07_0221F1C0
ov07_0221F1C0: ; 0x0221F1C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221C53C
	mov r1, #0
	mov r2, #0x3c
	add r4, r0, #0
	bl memset
	mov r0, #2
	strb r0, [r4]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strh r0, [r4, #0x1a]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #8]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #0xc]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #0x10]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strb r0, [r4, #3]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldrh r0, [r4, #0x1a]
	bl PlaySE
	ldrh r0, [r4, #0x1a]
	ldr r1, _0221F234 ; =0x0000FFFF
	ldr r2, [r4, #8]
	bl sub_020061B4
	add r0, r5, #0
	add r1, r4, #0
	bl ov07_0221C56C
	pop {r3, r4, r5, pc}
	.balign 4, 0
_0221F234: .word 0x0000FFFF
	thumb_func_end ov07_0221F1C0

	thumb_func_start ov07_0221F238
ov07_0221F238: ; 0x0221F238
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221C53C
	mov r1, #0
	mov r2, #0x3c
	add r4, r0, #0
	bl memset
	mov r0, #1
	strb r0, [r4]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strh r0, [r4, #0x1a]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #8]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #0xc]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #0x10]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strb r0, [r4, #3]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r4, #8]
	add r0, r5, #0
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	str r0, [r4, #8]
	ldr r1, [r4, #0xc]
	add r0, r5, #0
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	str r0, [r4, #0xc]
	ldr r1, [r4, #0x10]
	add r0, r5, #0
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	str r0, [r4, #0x10]
	ldrh r0, [r4, #0x1a]
	bl PlaySE
	ldrh r0, [r4, #0x1a]
	ldr r1, _0221F2D8 ; =0x0000FFFF
	ldr r2, [r4, #8]
	bl sub_020061B4
	add r0, r5, #0
	add r1, r4, #0
	bl ov07_0221C56C
	pop {r3, r4, r5, pc}
	nop
_0221F2D8: .word 0x0000FFFF
	thumb_func_end ov07_0221F238

	thumb_func_start ov07_0221F2DC
ov07_0221F2DC: ; 0x0221F2DC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221C53C
	mov r1, #0
	mov r2, #0x3c
	add r4, r0, #0
	bl memset
	mov r0, #4
	strb r0, [r4]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strh r0, [r4, #0x1a]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #0x14]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strb r0, [r4, #3]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strb r0, [r4, #0x18]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldrb r0, [r4, #3]
	strb r0, [r4, #4]
	ldr r1, [r4, #0x14]
	add r0, r5, #0
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	str r0, [r4, #0x14]
	add r0, r5, #0
	add r1, r4, #0
	bl ov07_0221C56C
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221F2DC

	thumb_func_start ov07_0221F340
ov07_0221F340: ; 0x0221F340
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov07_0221C53C
	mov r1, #0
	mov r2, #0x3c
	add r4, r0, #0
	bl memset
	mov r0, #5
	strb r0, [r4]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strh r0, [r4, #0x1a]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	lsl r0, r0, #0x18
	asr r0, r0, #0x18
	str r0, [r4, #0x14]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r0, [r0]
	strb r0, [r4, #3]
	ldr r0, [r5, #0x18]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r4, #0x14]
	add r0, r5, #0
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	str r0, [r4, #0x14]
	add r0, r5, #0
	add r1, r4, #0
	bl ov07_0221C56C
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov07_0221F340

	thumb_func_start ov07_0221F398
ov07_0221F398: ; 0x0221F398
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F398

	thumb_func_start ov07_0221F39C
ov07_0221F39C: ; 0x0221F39C
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x90
	ldrh r0, [r0]
	cmp r0, #0
	beq _0221F3B8
	add r0, r4, #0
	mov r1, #1
	add r0, #0x8d
	strb r1, [r0]
	ldr r0, _0221F3F0 ; =0x0000017D
	mov r1, #0
	strb r1, [r4, r0]
	pop {r4, pc}
_0221F3B8:
	bl GF_IsAnySEPlaying
	cmp r0, #0
	beq _0221F3DC
	ldr r0, _0221F3F0 ; =0x0000017D
	ldrb r1, [r4, r0]
	add r1, r1, #1
	strb r1, [r4, r0]
	ldrb r1, [r4, r0]
	cmp r1, #0x5a
	bls _0221F3D4
	mov r1, #0
	strb r1, [r4, r0]
	pop {r4, pc}
_0221F3D4:
	mov r0, #1
	add r4, #0x8d
	strb r0, [r4]
	pop {r4, pc}
_0221F3DC:
	add r0, r4, #0
	mov r1, #0
	add r0, #0x8d
	strb r1, [r0]
	ldr r0, _0221F3F0 ; =0x0000017D
	strb r1, [r4, r0]
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	str r0, [r4, #0x18]
	pop {r4, pc}
	.balign 4, 0
_0221F3F0: .word 0x0000017D
	thumb_func_end ov07_0221F39C

	thumb_func_start ov07_0221F3F4
ov07_0221F3F4: ; 0x0221F3F4
	push {r3, lr}
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r3, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	str r1, [r0, #0x18]
	lsl r0, r2, #0x10
	lsr r0, r0, #0x10
	str r0, [sp]
	lsl r3, r3, #0x10
	ldr r0, _0221F420 ; =0x04001050
	mov r1, #1
	mov r2, #2
	lsr r3, r3, #0x10
	bl G2x_SetBlendAlpha_
	pop {r3, pc}
	nop
_0221F420: .word 0x04001050
	thumb_func_end ov07_0221F3F4

	thumb_func_start ov07_0221F424
ov07_0221F424: ; 0x0221F424
	ldr r3, _0221F428 ; =ov07_0221C69C
	bx r3
	.balign 4, 0
_0221F428: .word ov07_0221C69C
	thumb_func_end ov07_0221F424

	thumb_func_start ov07_0221F42C
ov07_0221F42C: ; 0x0221F42C
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F42C

	thumb_func_start ov07_0221F430
ov07_0221F430: ; 0x0221F430
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x18
	add r5, r0, #0
	ldr r0, [r5, #0x18]
	add r6, r5, #0
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r5, #0x18]
	ldr r7, [r0]
	add r0, r0, #4
	lsl r4, r1, #2
	add r6, #0xcc
	str r0, [r5, #0x18]
	ldr r0, [r6, r4]
	cmp r0, #0
	beq _0221F458
	bl GF_AssertFail
_0221F458:
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteManager_New
	str r0, [r6, r4]
	ldr r0, [r6, r4]
	cmp r0, #0
	bne _0221F472
	bl GF_AssertFail
_0221F472:
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	ldr r1, [r6, r4]
	add r0, #0xac
	ldr r0, [r0]
	add r2, r7, #0
	bl SpriteSystem_InitSprites
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteSystem_GetRenderer
	mov r2, #0x11
	mov r1, #0
	lsl r2, r2, #0x10
	bl G2dRenderer_SetSubSurfaceCoords
	add r0, r5, #0
	mov r1, #0
	add r2, sp, #0
	add r0, #0x18
_0221F4A4:
	ldr r3, [r5, #0x18]
	add r1, r1, #1
	ldr r3, [r3]
	str r3, [r2]
	ldr r3, [r0]
	add r2, r2, #4
	add r3, r3, #4
	str r3, [r0]
	cmp r1, #6
	blt _0221F4A4
	add r5, #0xc0
	ldr r0, [r5]
	ldr r1, [r6, r4]
	add r0, #0xac
	ldr r0, [r0]
	add r2, sp, #0
	bl SpriteSystem_InitManagerWithCapacities
	add sp, #0x18
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov07_0221F430

	thumb_func_start ov07_0221F4CC
ov07_0221F4CC: ; 0x0221F4CC
	push {r3, r4, lr}
	sub sp, #0xc
	add r2, r0, #0
	ldr r0, [r2, #0x18]
	mov r4, #0x6e
	add r0, r0, #4
	str r0, [r2, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r2, #0x18]
	ldr r3, [r0]
	add r0, r0, #4
	str r0, [r2, #0x18]
	mov r0, #1
	str r0, [sp]
	str r0, [sp, #4]
	ldr r0, _0221F510 ; =0x00001388
	lsl r1, r1, #2
	add r0, r3, r0
	str r0, [sp, #8]
	add r0, r2, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, r2, r1
	add r0, #0xac
	add r1, #0xcc
	lsl r4, r4, #2
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, [r2, r4]
	bl SpriteSystem_LoadCharResObjFromOpenNarc
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_0221F510: .word 0x00001388
	thumb_func_end ov07_0221F4CC

	thumb_func_start ov07_0221F514
ov07_0221F514: ; 0x0221F514
	push {r4, lr}
	sub sp, #0x18
	add r4, r0, #0
	ldr r0, [r4, #0x18]
	add r0, r0, #4
	str r0, [r4, #0x18]
	ldr r3, [r0]
	add r0, r0, #4
	str r0, [r4, #0x18]
	ldr r1, [r0]
	add r2, r0, #4
	str r2, [r4, #0x18]
	ldr r0, [r2]
	add r2, r2, #4
	str r2, [r4, #0x18]
	mov r2, #0x6f
	lsl r2, r2, #2
	ldr r2, [r4, r2]
	lsl r3, r3, #2
	str r2, [sp]
	str r1, [sp, #4]
	mov r2, #0
	str r2, [sp, #8]
	mov r2, #1
	str r2, [sp, #0xc]
	str r0, [sp, #0x10]
	ldr r0, _0221F570 ; =0x00001388
	add r2, r4, #0
	add r0, r1, r0
	str r0, [sp, #0x14]
	add r2, #0xc0
	ldr r2, [r2]
	add r0, r4, #0
	add r3, r4, r3
	add r0, #0xc8
	add r2, #0xac
	add r3, #0xcc
	ldr r0, [r0]
	ldr r2, [r2]
	ldr r3, [r3]
	mov r1, #2
	bl SpriteSystem_LoadPaletteBufferFromOpenNarc
	add sp, #0x18
	pop {r4, pc}
	nop
_0221F570: .word 0x00001388
	thumb_func_end ov07_0221F514

	thumb_func_start ov07_0221F574
ov07_0221F574: ; 0x0221F574
	push {r4, lr}
	sub sp, #8
	add r2, r0, #0
	ldr r0, [r2, #0x18]
	mov r4, #7
	add r0, r0, #4
	str r0, [r2, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r2, #0x18]
	ldr r3, [r0]
	add r0, r0, #4
	str r0, [r2, #0x18]
	mov r0, #1
	str r0, [sp]
	ldr r0, _0221F5B8 ; =0x00001388
	lsl r1, r1, #2
	add r0, r3, r0
	str r0, [sp, #4]
	add r0, r2, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, r2, r1
	add r0, #0xac
	add r1, #0xcc
	lsl r4, r4, #6
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, [r2, r4]
	bl SpriteSystem_LoadCellResObjFromOpenNarc
	add sp, #8
	pop {r4, pc}
	nop
_0221F5B8: .word 0x00001388
	thumb_func_end ov07_0221F574

	thumb_func_start ov07_0221F5BC
ov07_0221F5BC: ; 0x0221F5BC
	push {r4, lr}
	sub sp, #8
	add r2, r0, #0
	ldr r0, [r2, #0x18]
	mov r4, #0x71
	add r0, r0, #4
	str r0, [r2, #0x18]
	ldr r1, [r0]
	add r0, r0, #4
	str r0, [r2, #0x18]
	ldr r3, [r0]
	add r0, r0, #4
	str r0, [r2, #0x18]
	mov r0, #1
	str r0, [sp]
	ldr r0, _0221F600 ; =0x00001388
	lsl r1, r1, #2
	add r0, r3, r0
	str r0, [sp, #4]
	add r0, r2, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, r2, r1
	add r0, #0xac
	add r1, #0xcc
	lsl r4, r4, #2
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, [r2, r4]
	bl SpriteSystem_LoadAnimResObjFromOpenNarc
	add sp, #8
	pop {r4, pc}
	nop
_0221F600: .word 0x00001388
	thumb_func_end ov07_0221F5BC

	thumb_func_start ov07_0221F604
ov07_0221F604: ; 0x0221F604
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x40
	add r4, r0, #0
	ldr r1, [r4, #0x18]
	add r1, r1, #4
	str r1, [r4, #0x18]
	ldr r5, [r1]
	add r2, r1, #4
	str r2, [r4, #0x18]
	ldr r1, [r2]
	str r1, [sp]
	add r1, r2, #4
	str r1, [r4, #0x18]
	bl ov07_0221C470
	add r6, r0, #0
	add r0, r4, #0
	add r1, r6, #0
	mov r2, #0
	bl ov07_02221F80
	add r1, sp, #0xc
	strh r0, [r1]
	add r0, r4, #0
	add r1, r6, #0
	mov r2, #1
	bl ov07_02221F80
	add r2, sp, #0xc
	strh r0, [r2, #2]
	mov r1, #0
	strh r1, [r2, #4]
	strh r1, [r2, #6]
	mov r0, #0x64
	str r0, [sp, #0x14]
	mov r0, #1
	str r0, [sp, #0x1c]
	str r0, [sp, #0x38]
	add r0, r4, #0
	ldr r3, _0221F70C ; =0x00001388
	str r1, [sp, #0x18]
	str r1, [sp, #0x3c]
	add r2, sp, #0xc
	add r0, #0x18
_0221F65C:
	ldr r6, [r4, #0x18]
	add r1, r1, #1
	ldr r6, [r6]
	add r6, r6, r3
	str r6, [r2, #0x14]
	ldr r6, [r0]
	add r2, r2, #4
	add r6, r6, #4
	str r6, [r0]
	cmp r1, #6
	blt _0221F65C
	mov r0, #0x41
	lsl r0, r0, #2
	add r3, sp, #0xc
	add r2, r4, r0
	mov r6, #6
_0221F67C:
	ldmia r3!, {r0, r1}
	stmia r2!, {r0, r1}
	sub r6, r6, #1
	bne _0221F67C
	ldr r0, [r3]
	lsl r7, r5, #2
	str r0, [r2]
	add r0, r4, #0
	str r0, [sp, #8]
	add r0, #0xcc
	str r0, [sp, #8]
	add r0, r4, #0
	add r0, #0xc0
	ldr r0, [r0]
	ldr r1, [sp, #8]
	add r0, #0xac
	ldr r0, [r0]
	ldr r1, [r1, r7]
	add r2, sp, #0xc
	bl SpriteSystem_NewSprite
	str r0, [sp, #4]
	ldr r0, [r4, #0x18]
	add r2, r4, #0
	ldr r3, [r0]
	add r0, r0, #4
	add r2, #0x18
	mov r6, #0
	str r0, [r4, #0x18]
	cmp r3, #0
	ble _0221F6D4
	add r5, r4, #0
_0221F6BC:
	ldr r0, [r4, #0x18]
	add r6, r6, #1
	ldr r1, [r0]
	add r0, r5, #0
	add r0, #0x94
	str r1, [r0]
	ldr r0, [r2]
	add r5, r5, #4
	add r0, r0, #4
	str r0, [r2]
	cmp r6, r3
	blt _0221F6BC
_0221F6D4:
	cmp r6, #0xa
	bge _0221F6EC
	lsl r0, r6, #2
	add r2, r4, r0
	mov r1, #0
_0221F6DE:
	add r0, r2, #0
	add r0, #0x94
	add r6, r6, #1
	add r2, r2, #4
	str r1, [r0]
	cmp r6, #0xa
	blt _0221F6DE
_0221F6EC:
	ldr r0, [sp]
	bl ov07_0222304C
	add r5, r0, #0
	add r0, r4, #0
	add r4, #0xc0
	ldr r1, [r4]
	ldr r2, [sp, #8]
	add r1, #0xac
	ldr r1, [r1]
	ldr r2, [r2, r7]
	ldr r3, [sp, #4]
	blx r5
	add sp, #0x40
	pop {r3, r4, r5, r6, r7, pc}
	nop
_0221F70C: .word 0x00001388
	thumb_func_end ov07_0221F604

	thumb_func_start ov07_0221F710
ov07_0221F710: ; 0x0221F710
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	add r5, r0, #0
	ldr r1, [r5, #0x18]
	add r1, r1, #4
	str r1, [r5, #0x18]
	ldr r4, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	ldr r7, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	bl ov07_0221C470
	add r6, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #0
	bl ov07_02221F80
	add r1, sp, #0
	strh r0, [r1]
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #1
	bl ov07_02221F80
	add r2, sp, #0
	strh r0, [r2, #2]
	mov r1, #0
	strh r1, [r2, #4]
	strh r1, [r2, #6]
	mov r0, #0x64
	str r0, [sp, #8]
	mov r0, #1
	str r0, [sp, #0x10]
	str r0, [sp, #0x2c]
	add r0, r5, #0
	ldr r3, _0221F7C0 ; =0x00001388
	str r1, [sp, #0xc]
	str r1, [sp, #0x30]
	add r2, sp, #0
	add r0, #0x18
_0221F766:
	ldr r6, [r5, #0x18]
	add r1, r1, #1
	ldr r6, [r6]
	add r6, r6, r3
	str r6, [r2, #0x14]
	ldr r6, [r0]
	add r2, r2, #4
	add r6, r6, #4
	str r6, [r0]
	cmp r1, #6
	blt _0221F766
	mov r0, #0x41
	lsl r0, r0, #2
	add r6, sp, #0
	add r3, r5, r0
	mov r2, #6
_0221F786:
	ldmia r6!, {r0, r1}
	stmia r3!, {r0, r1}
	sub r2, r2, #1
	bne _0221F786
	ldr r0, [r6]
	lsl r1, r4, #2
	str r0, [r3]
	add r0, r5, #0
	add r0, #0xc0
	ldr r0, [r0]
	add r1, r5, r1
	add r0, #0xac
	add r1, #0xcc
	ldr r0, [r0]
	ldr r1, [r1]
	add r2, sp, #0
	bl SpriteSystem_NewSprite
	add r5, #0xdc
	lsl r4, r7, #2
	add r6, r0, #0
	ldr r0, [r5, r4]
	cmp r0, #0
	beq _0221F7BA
	bl GF_AssertFail
_0221F7BA:
	str r6, [r5, r4]
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_0221F7C0: .word 0x00001388
	thumb_func_end ov07_0221F710

	thumb_func_start ov07_0221F7C4
ov07_0221F7C4: ; 0x0221F7C4
	push {r3, r4, r5, lr}
	ldr r1, [r0, #0x18]
	add r5, r0, #0
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r2, [r1]
	add r1, r1, #4
	add r5, #0xcc
	lsl r4, r2, #2
	str r1, [r0, #0x18]
	ldr r1, [r5, r4]
	cmp r1, #0
	beq _0221F7EA
	add r0, #0xc0
	ldr r0, [r0]
	add r0, #0xac
	ldr r0, [r0]
	bl SpriteSystem_FreeResourcesAndManager
_0221F7EA:
	mov r0, #0
	str r0, [r5, r4]
	pop {r3, r4, r5, pc}
	thumb_func_end ov07_0221F7C4

	thumb_func_start ov07_0221F7F0
ov07_0221F7F0: ; 0x0221F7F0
	ldr r1, [r0, #0x18]
	add r1, r1, #4
	str r1, [r0, #0x18]
	ldr r3, [r1]
	add r2, r1, #4
	str r2, [r0, #0x18]
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r0, #0x18]
	lsl r2, r3, #2
	add r2, r0, r2
	mov r0, #0x4f
	lsl r0, r0, #2
	ldr r3, _0221F810 ; =ManagedSprite_SetDrawFlag
	ldr r0, [r2, r0]
	bx r3
	.balign 4, 0
_0221F810: .word ManagedSprite_SetDrawFlag
	thumb_func_end ov07_0221F7F0

	thumb_func_start ov07_0221F814
ov07_0221F814: ; 0x0221F814
	ldr r3, _0221F818 ; =GF_AssertFail
	bx r3
	.balign 4, 0
_0221F818: .word GF_AssertFail
	thumb_func_end ov07_0221F814

	thumb_func_start ov07_0221F81C
ov07_0221F81C: ; 0x0221F81C
	push {r4, r5, r6, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r1, [r5, #0x18]
	add r1, r1, #4
	str r1, [r5, #0x18]
	ldr r4, [r1]
	add r1, r1, #4
	str r1, [r5, #0x18]
	ldr r1, [r1]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	lsl r1, r1, #0x18
	asr r1, r1, #0x18
	bl ov07_0221F8C8
	ldr r1, [r5, #0x18]
	add r2, r1, #4
	str r2, [r5, #0x18]
	ldr r1, [r2]
	add r2, r2, #4
	str r2, [r5, #0x18]
	add r2, r5, #0
	add r2, #0xc0
	ldr r6, [r2]
	ldrh r3, [r6, #0x14]
	str r0, [sp]
	lsl r2, r3, #1
	mov r0, #0x46
	add r2, r6, r2
	add r3, r6, r3
	lsl r0, r0, #2
	str r1, [sp, #4]
	ldr r1, [r6, r0]
	add r2, #0xd8
	lsl r1, r1, #0x1f
	asr r1, r1, #0x1f
	str r1, [sp, #8]
	ldr r1, [r5]
	add r3, #0xe8
	str r1, [sp, #0xc]
	sub r0, #0xc
	ldrh r2, [r2]
	ldrb r3, [r3]
	ldr r0, [r6, r0]
	add r1, r4, #0
	bl sub_02071FDC
	add sp, #0x10
	pop {r4, r5, r6, pc}
	thumb_func_end ov07_0221F81C

	thumb_func_start ov07_0221F880
ov07_0221F880: ; 0x0221F880
	push {r4, lr}
	add r4, r0, #0
	bl IsCryFinished
	cmp r0, #0
	bne _0221F8A4
	ldr r0, [r4, #0x18]
	add r1, r0, #4
	str r1, [r4, #0x18]
	ldr r0, [r1]
	add r1, r1, #4
	str r1, [r4, #0x18]
	mov r1, #0
	add r4, #0x8d
	strb r1, [r4]
	bl sub_02006300
	pop {r4, pc}
_0221F8A4:
	mov r0, #1
	add r4, #0x8d
	strb r0, [r4]
	pop {r4, pc}
	thumb_func_end ov07_0221F880

	thumb_func_start ov07_0221F8AC
ov07_0221F8AC: ; 0x0221F8AC
	bx lr
	.balign 4, 0
	thumb_func_end ov07_0221F8AC
