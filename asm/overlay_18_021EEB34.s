	.include "asm/macros.inc"
	.include "overlay_18.inc"
	.include "global.inc"
	.extern ov18_021E5900
	.extern ov18_021E5904
	.extern ov18_021E5908
	.extern ov18_021E590C
	.extern ov18_021E595C
	.extern ov18_021E59A8
	.extern ov18_021E613C
	.extern ov18_021E6D10
	.extern ov18_021E7698
	.extern ov18_021E8AB0
	.extern ov18_021E8ACC
	.extern ov18_021E8AE0
	.extern ov18_021E8B0C
	.extern ov18_021E8B18
	.extern ov18_021E8B24
	.extern ov18_021E8B5C

.public ov18_021F95FC
.public ov18_021F9648

	.text

	thumb_func_start ov18_021EEB34
ov18_021EEB34: ; 0x021EEB34
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	add r7, r1, #0
	add r5, r2, #0
	add r6, r3, #0
	bl GetDexWeightMsgBank
	add r2, r0, #0
	mov r0, #0
	mov r1, #0x1b
	mov r3, #0x25
	bl NewMsgDataFromNarc
	str r0, [sp, #0xc]
	cmp r5, #2
	bne _021EEB5E
	add r1, r7, #0
	bl NewString_ReadMsgData
	b _021EEB64
_021EEB5E:
	mov r1, #0
	bl NewString_ReadMsgData
_021EEB64:
	add r5, r0, #0
	mov r0, #0
	str r0, [sp]
	ldr r0, [sp, #0x30]
	add r4, #0xc
	str r0, [sp, #4]
	ldr r0, [sp, #0x34]
	ldr r2, [sp, #0x28]
	str r0, [sp, #8]
	lsl r0, r6, #4
	ldr r3, [sp, #0x2c]
	add r0, r4, r0
	add r1, r5, #0
	bl ov18_021F95FC
	add r0, r5, #0
	bl String_Delete
	ldr r0, [sp, #0xc]
	bl DestroyMsgData
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021EEB34
