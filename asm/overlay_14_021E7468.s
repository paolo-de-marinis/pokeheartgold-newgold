#include "constants/pokemon.h"
	.include "asm/macros.inc"
	.include "overlay_14.inc"
	.include "global.inc"

	.text

	thumb_func_start ov14_021E7468
ov14_021E7468: ; 0x021E7468
	ldr r3, _021E746C ; =Heap_Free
	bx r3
	.balign 4, 0
_021E746C: .word Heap_Free
	thumb_func_end ov14_021E7468

	thumb_func_start ov14_021E7470
ov14_021E7470: ; 0x021E7470
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	str r1, [sp]
	bl ov14_021F5404
	mov r7, #0x2f
	add r6, r0, #0
	mov r4, #0
	lsl r7, r7, #4
_021E7482:
	ldr r2, [r5, #0x34]
	add r3, r6, r4
	ldr r0, [r2, r7]
	add r2, #0x30
	lsl r3, r3, #4
	mov r1, #0x10
	add r2, r2, r3
	bl sub_02019A60
	add r4, r4, #1
	cmp r4, #4
	blo _021E7482
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88A4
	ldr r1, [sp]
	add r0, r5, #0
	mov r2, #2
	bl ov14_021F36DC
	ldr r0, [r5, #0x34]
	ldr r1, _021E74EC ; =0x000088D0
	mov r2, #1
	ldrh r1, [r0, r1]
	eor r1, r2
	add r1, r1, #2
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	ldr r1, _021E74EC ; =0x000088D0
	mov r2, #0
	ldrh r1, [r0, r1]
	add r1, r1, #2
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	ldr r1, [sp]
	bl ov14_021F3D70
	ldr r1, [sp]
	add r0, r5, #0
	bl ov14_021F5368
	ldr r1, [sp]
	add r0, r5, #0
	ldrh r1, [r1, #0x10]
	bl ov14_021E895C
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E74EC: .word 0x000088D0
	thumb_func_end ov14_021E7470

	thumb_func_start ov14_021E74F0
ov14_021E74F0: ; 0x021E74F0
	push {r4, r5, r6, lr}
	add r4, r1, #0
	ldrh r1, [r4, #6]
	add r5, r0, #0
	cmp r1, #0
	beq _021E7534
	bl ov14_021F5564
	add r6, r0, #0
	mov r0, #0x2f
	ldr r2, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	add r2, #0x30
	lsl r3, r6, #4
	mov r1, #0x10
	add r2, r2, r3
	bl sub_02019A60
	mov r0, #0x2f
	add r3, r6, #1
	ldr r2, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	add r2, #0x30
	lsl r3, r3, #4
	mov r1, #0x10
	add r2, r2, r3
	bl sub_02019A60
	ldrh r1, [r4, #6]
	ldr r0, [r5, #0x34]
	bl ov14_021F38B0
_021E7534:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8944
	add r0, r5, #0
	add r1, r4, #0
	mov r2, #2
	bl ov14_021F36DC
	ldr r0, [r5, #0x34]
	ldr r1, _021E7584 ; =0x000088D0
	mov r2, #1
	ldrh r1, [r0, r1]
	eor r1, r2
	add r1, r1, #2
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	ldr r1, _021E7584 ; =0x000088D0
	mov r2, #0
	ldrh r1, [r0, r1]
	add r1, r1, #2
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	bl ov14_021F3D70
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F5368
	ldrh r1, [r4, #0x10]
	add r0, r5, #0
	bl ov14_021E895C
	pop {r4, r5, r6, pc}
	nop
_021E7584: .word 0x000088D0
	thumb_func_end ov14_021E74F0

	thumb_func_start ov14_021E7588
ov14_021E7588: ; 0x021E7588
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r2, r1, #0
	ldrb r1, [r5, #0x1f]
	bl ov14_021E60C0
	add r4, r0, #0
	beq _021E75E6
	bl AcquireBoxMonLock
	add r7, r0, #0
	add r0, r4, #0
	bl ov14_021E7358
	add r6, r0, #0
	beq _021E75CA
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021E75BA
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E74F0
	b _021E75C2
_021E75BA:
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E7470
_021E75C2:
	add r0, r6, #0
	bl ov14_021E7468
	b _021E75DC
_021E75CA:
	add r0, r5, #0
	bl ov14_021E765C
	add r0, r4, #0
	add r1, r7, #0
	bl ReleaseBoxMonLock
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E75DC:
	add r0, r4, #0
	add r1, r7, #0
	bl ReleaseBoxMonLock
	b _021E75F0
_021E75E6:
	add r0, r5, #0
	bl ov14_021E765C
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E75F0:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021E7588

	thumb_func_start ov14_021E75F4
ov14_021E75F4: ; 0x021E75F4
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r2, r1, #0
	ldrb r1, [r5, #0x1f]
	bl ov14_021E60C0
	add r4, r0, #0
	bl AcquireBoxMonLock
	add r7, r0, #0
	add r0, r4, #0
	bl ov14_021E7358
	add r6, r0, #0
	add r0, r5, #0
	add r1, r6, #0
	mov r2, #2
	bl ov14_021F36DC
	ldr r0, [r5, #0x34]
	ldr r1, _021E7658 ; =0x000088D0
	mov r2, #1
	ldrh r1, [r0, r1]
	eor r1, r2
	add r1, r1, #2
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	ldr r1, _021E7658 ; =0x000088D0
	mov r2, #0
	ldrh r1, [r0, r1]
	add r1, r1, #2
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	bl ov14_021F3D70
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021F5368
	add r0, r6, #0
	bl ov14_021E7468
	add r0, r4, #0
	add r1, r7, #0
	bl ReleaseBoxMonLock
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021E7658: .word 0x000088D0
	thumb_func_end ov14_021E75F4

	thumb_func_start ov14_021E765C
ov14_021E765C: ; 0x021E765C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #2
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #3
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0xd
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0xe
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	bl ov14_021F53C0
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E895C
	ldr r0, [r4]
	ldr r1, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021E76AC
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8944
	pop {r4, pc}
_021E76AC:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88A4
	pop {r4, pc}
	thumb_func_end ov14_021E765C

	thumb_func_start ov14_021E76B8
ov14_021E76B8: ; 0x021E76B8
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	mov r0, #0xff
	add r4, #0x21
	strb r0, [r4]
	pop {r4, pc}
	thumb_func_end ov14_021E76B8

	thumb_func_start ov14_021E76D0
ov14_021E76D0: ; 0x021E76D0
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0xa
	add r4, r3, #0
	str r0, [sp]
	mov r0, #0x13
	add r1, #0x10
	mov r2, #1
	add r3, sp, #4
	bl GfGfxLoader_GetCharData
	ldr r3, [sp, #4]
	add r6, r0, #0
	str r4, [sp]
	ldr r0, [r5, #0x34]
	ldr r2, [r3, #0x14]
	ldr r0, [r0, #0x14]
	ldr r3, [r3, #0x10]
	mov r1, #3
	bl BG_LoadCharTilesData
	mov r0, #3
	str r0, [sp]
	ldr r1, [sp, #4]
	add r4, #0x15
	ldr r2, [r1, #0x14]
	mov r1, #0x2a
	lsl r1, r1, #4
	add r1, r2, r1
	add r0, r5, #0
	add r2, r4, #0
	mov r3, #0x15
	bl ov14_021F5718
	add r0, r6, #0
	bl Heap_Free
	add sp, #8
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021E76D0

	thumb_func_start ov14_021E7720
ov14_021E7720: ; 0x021E7720
	push {r3, lr}
	sub sp, #8
	mov r0, #0x20
	add r3, r2, #0
	str r0, [sp]
	mov r0, #0xa
	str r0, [sp, #4]
	mov r0, #0x13
	add r1, #0x28
	mov r2, #0
	lsl r3, r3, #5
	bl GfGfxLoader_GXLoadPal
	add sp, #8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7720

	thumb_func_start ov14_021E7740
ov14_021E7740: ; 0x021E7740
	push {r4, r5, r6, r7, lr}
	sub sp, #0x34
	str r0, [sp, #0x10]
	mov r0, #0xa
	str r2, [sp, #0x14]
	str r3, [sp, #0x18]
	str r0, [sp]
	mov r0, #0x13
	mov r1, #0xf
	mov r2, #1
	add r3, sp, #0x30
	bl GfGfxLoader_GetScrnData
	str r0, [sp, #0x28]
	ldr r0, [sp, #0x30]
	str r0, [sp, #0x24]
	add r0, #0xc
	str r0, [sp, #0x24]
	mov r0, #0
	str r0, [sp, #0x20]
	ldr r0, [sp, #0x48]
	lsl r0, r0, #0xc
	str r0, [sp, #0x1c]
_021E776E:
	ldr r0, [sp, #0x20]
	mov r1, #0x15
	mul r1, r0
	ldr r0, [sp, #0x24]
	lsl r1, r1, #1
	add r6, r0, r1
	ldr r0, [sp, #0x20]
	ldr r4, [sp, #0x14]
	add r0, r0, #1
	lsl r0, r0, #0x18
	mov r5, #0
	lsr r7, r0, #0x18
_021E7786:
	lsl r0, r5, #1
	ldrh r1, [r6, r0]
	ldr r0, _021E7800 ; =0x00000FFF
	lsl r3, r4, #0x18
	and r1, r0
	ldr r0, [sp, #0x1c]
	add r2, sp, #0x2c
	add r1, r0, r1
	ldr r0, [sp, #0x18]
	lsr r3, r3, #0x18
	add r1, r0, r1
	add r0, sp, #0x2c
	strh r1, [r0]
	str r7, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [sp, #0x10]
	mov r1, #3
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0x14]
	bl LoadRectToBgTilemapRect
	add r4, r4, #1
	cmp r4, #0x40
	blo _021E77BC
	mov r4, #0
_021E77BC:
	add r0, r5, #1
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	cmp r5, #0x15
	blo _021E7786
	ldr r0, [sp, #0x20]
	add r0, r0, #1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp, #0x20]
	cmp r0, #0x14
	blo _021E776E
	ldr r0, [sp, #0x28]
	bl Heap_Free
	mov r0, #0
	str r0, [sp]
	mov r0, #2
	str r0, [sp, #4]
	mov r0, #0x14
	str r0, [sp, #8]
	mov r0, #0x11
	str r0, [sp, #0xc]
	ldr r0, [sp, #0x10]
	lsl r3, r4, #0x18
	ldr r0, [r0, #0x34]
	ldr r2, _021E7804 ; =0x00001001
	ldr r0, [r0, #0x14]
	mov r1, #3
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	add sp, #0x34
	pop {r4, r5, r6, r7, pc}
	.balign 4, 0
_021E7800: .word 0x00000FFF
_021E7804: .word 0x00001001
	thumb_func_end ov14_021E7740

	thumb_func_start ov14_021E7808
ov14_021E7808: ; 0x021E7808
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	add r4, r1, #0
	add r6, r2, #0
	add r7, r3, #0
	bl ov14_021E76D0
	ldr r2, [sp, #0x18]
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021E7720
	ldr r0, [sp, #0x18]
	add r1, r4, #0
	str r0, [sp]
	add r0, r5, #0
	add r2, r6, #0
	add r3, r7, #0
	bl ov14_021E7740
	ldr r0, [r5, #0x34]
	mov r1, #3
	ldr r0, [r0, #0x14]
	bl ScheduleBgTilemapBufferTransfer
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021E7808

	thumb_func_start ov14_021E783C
ov14_021E783C: ; 0x021E783C
	push {r3, r4, r5, r6, r7, lr}
	cmp r2, #0
	bne _021E785A
	ldr r4, [r0, #0x34]
	ldr r2, _021E78A4 ; =0x00000448
	ldrsb r3, [r4, r2]
	sub r3, #0x17
	strb r3, [r4, r2]
	ldr r4, [r0, #0x34]
	ldrsb r3, [r4, r2]
	cmp r3, #0
	bge _021E7874
	add r3, #0x40
	strb r3, [r4, r2]
	b _021E7874
_021E785A:
	cmp r2, #1
	bne _021E7874
	ldr r4, [r0, #0x34]
	ldr r2, _021E78A4 ; =0x00000448
	ldrsb r3, [r4, r2]
	add r3, #0x17
	strb r3, [r4, r2]
	ldr r4, [r0, #0x34]
	ldrsb r3, [r4, r2]
	cmp r3, #0x40
	blt _021E7874
	sub r3, #0x40
	strb r3, [r4, r2]
_021E7874:
	ldr r6, [r0, #0x34]
	ldr r2, _021E78A8 ; =0x00000449
	ldrb r2, [r6, r2]
	cmp r2, #0
	bne _021E7886
	mov r3, #0x97
	lsl r3, r3, #2
	mov r5, #0xe
	b _021E788A
_021E7886:
	mov r3, #0xb8
	mov r5, #0xf
_021E788A:
	ldr r7, _021E78A8 ; =0x00000449
	mov r2, #1
	ldrb r4, [r6, r7]
	eor r2, r4
	strb r2, [r6, r7]
	str r5, [sp]
	ldr r4, [r0, #0x34]
	sub r2, r7, #1
	ldrsb r2, [r4, r2]
	bl ov14_021E7808
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E78A4: .word 0x00000448
_021E78A8: .word 0x00000449
	thumb_func_end ov14_021E783C

	thumb_func_start ov14_021E78AC
ov14_021E78AC: ; 0x021E78AC
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r7, r1, #0
	ldr r0, [r5, #0x34]
	ldr r1, _021E7928 ; =0x00000449
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021E78C6
	mov r6, #0x97
	lsl r6, r6, #2
	mov r4, #0xe
	b _021E78CA
_021E78C6:
	mov r6, #0xb8
	mov r4, #0xf
_021E78CA:
	ldr r1, _021E7928 ; =0x00000449
	ldr r3, _021E7928 ; =0x00000449
	ldrb r2, [r0, r1]
	mov r1, #1
	sub r3, r3, #1
	eor r2, r1
	ldr r1, _021E7928 ; =0x00000449
	strb r2, [r0, r1]
	ldr r2, [r5, #0x34]
	add r0, r5, #0
	ldrsb r2, [r2, r3]
	add r1, r7, #0
	add r3, r6, #0
	bl ov14_021E76D0
	mov r0, #0
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	lsl r0, r4, #0x14
	lsr r0, r0, #0x10
	str r0, [sp, #8]
	ldr r0, [r5, #0x34]
	add r2, r7, #0
	ldr r0, [r0, #0x18]
	mov r1, #0x13
	add r2, #0x28
	mov r3, #0xa
	bl PaletteData_LoadNarc
	str r4, [sp]
	ldr r3, [r5, #0x34]
	ldr r2, _021E792C ; =0x00000448
	add r0, r5, #0
	ldrsb r2, [r3, r2]
	add r1, r7, #0
	add r3, r6, #0
	bl ov14_021E7740
	ldr r0, [r5, #0x34]
	mov r1, #3
	ldr r0, [r0, #0x14]
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021E7928: .word 0x00000449
_021E792C: .word 0x00000448
	thumb_func_end ov14_021E78AC

	thumb_func_start ov14_021E7930
ov14_021E7930: ; 0x021E7930
	push {r3, lr}
	ldr r0, [r0, #4]
	bl PCStorage_GetBoxWallpaper
	cmp r0, #0x10
	blo _021E793E
	sub r0, #0x10
_021E793E:
	pop {r3, pc}
	thumb_func_end ov14_021E7930

	thumb_func_start ov14_021E7940
ov14_021E7940: ; 0x021E7940
	ldrb r3, [r2]
	cmp r0, r3
	blt _021E795C
	ldrb r3, [r2, #1]
	cmp r0, r3
	bgt _021E795C
	ldrb r0, [r2, #2]
	cmp r1, r0
	blt _021E795C
	ldrb r0, [r2, #3]
	cmp r1, r0
	bge _021E795C
	mov r0, #1
	bx lr
_021E795C:
	mov r0, #0
	bx lr
	thumb_func_end ov14_021E7940

	thumb_func_start ov14_021E7960
ov14_021E7960: ; 0x021E7960
	push {r3, r4, r5, lr}
	ldr r2, _021E79A8 ; =_021F7BBC
	add r5, r0, #0
	add r4, r1, #0
	bl ov14_021E7940
	cmp r0, #1
	bne _021E79A4
	cmp r5, #0xc
	bge _021E7978
	mov r5, #0
	b _021E798E
_021E7978:
	cmp r5, #0x9c
	blt _021E7980
	mov r5, #5
	b _021E798E
_021E7980:
	sub r5, #0xc
	add r0, r5, #0
	mov r1, #0x18
	bl _s32_div_f
	lsl r0, r0, #0x10
	asr r5, r0, #0x10
_021E798E:
	sub r4, #0x28
	add r0, r4, #0
	mov r1, #0x18
	bl _s32_div_f
	lsl r0, r0, #0x10
	asr r1, r0, #0x10
	mov r0, #6
	mul r0, r1
	add r0, r5, r0
	pop {r3, r4, r5, pc}
_021E79A4:
	mov r0, #0xff
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E79A8: .word _021F7BBC
	thumb_func_end ov14_021E7960

	thumb_func_start ov14_021E79AC
ov14_021E79AC: ; 0x021E79AC
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	add r7, r1, #0
	add r5, r2, #0
	mov r4, #0
_021E79B6:
	add r0, r6, #0
	add r1, r7, #0
	add r2, r5, #0
	bl ov14_021E7940
	cmp r0, #1
	bne _021E79CA
	add r4, #0x1e
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E79CA:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blo _021E79B6
	mov r0, #0xff
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E79AC

	thumb_func_start ov14_021E79D8
ov14_021E79D8: ; 0x021E79D8
	push {r3, r4, r5, r6, r7, lr}
	ldr r5, _021E7A04 ; =ov14_021F7BD8
	add r6, r0, #0
	add r7, r1, #0
	mov r4, #0
_021E79E2:
	add r0, r6, #0
	add r1, r7, #0
	add r2, r5, #0
	bl ov14_021E7940
	cmp r0, #1
	bne _021E79F6
	add r4, #0x80
	add r0, r4, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E79F6:
	add r4, r4, #1
	add r5, r5, #4
	cmp r4, #6
	blo _021E79E2
	mov r0, #0xff
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E7A04: .word ov14_021F7BD8
	thumb_func_end ov14_021E79D8

	thumb_func_start ov14_021E7A08
ov14_021E7A08: ; 0x021E7A08
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r7, r1, #0
	ldr r1, [r0, #0x34]
	mov r0, #0xca
	lsl r0, r0, #2
	add r5, r2, #0
	ldr r4, [r1, #0xc]
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r1, #2
	add r2, sp, #4
	add r6, r3, #0
	bl ManagedSprite_GetPositionXY
	add r1, sp, #0
	add r0, r5, #0
	add r1, #2
	add r2, sp, #0
	add r3, r6, #0
	bl ov14_021F2F88
	ldr r0, [sp, #0x20]
	add r1, sp, #0
	cmp r0, #1
	bne _021E7A4C
	mov r0, #2
	ldrsh r0, [r1, r0]
	add r0, #8
	strh r0, [r1, #2]
	mov r0, #0
	ldrsh r0, [r1, r0]
	add r0, #8
	b _021E7A52
_021E7A4C:
	mov r0, #0
	ldrsh r0, [r1, r0]
	add r0, r0, #4
_021E7A52:
	strh r0, [r1]
	strh r5, [r4]
	strh r7, [r4, #2]
	ldr r2, [r4, #0x18]
	mov r0, #3
	and r0, r2
	str r0, [r4, #0x18]
	str r6, [r4, #4]
	add r3, sp, #0
	mov r0, #2
	mov r2, #6
	add r1, r4, #0
	ldrsh r0, [r3, r0]
	ldrsh r2, [r3, r2]
	add r1, #0x18
	cmp r2, r0
	ldr r5, [r1]
	ble _021E7A84
	mov r3, #1
	bic r5, r3
	mov r3, #1
	orr r3, r5
	str r3, [r1]
	sub r0, r2, r0
	b _021E7A8C
_021E7A84:
	mov r3, #1
	bic r5, r3
	str r5, [r1]
	sub r0, r0, r2
_021E7A8C:
	lsl r1, r0, #8
	asr r0, r1, #2
	lsr r0, r0, #0x1d
	add r0, r1, r0
	asr r0, r0, #3
	str r0, [r4, #0x10]
	add r3, sp, #0
	mov r0, #0
	mov r1, #4
	ldrsh r0, [r3, r0]
	ldrsh r1, [r3, r1]
	cmp r1, r0
	ldr r5, [r4, #0x18]
	ble _021E7AB2
	mov r3, #2
	orr r3, r5
	str r3, [r4, #0x18]
	sub r0, r1, r0
	b _021E7ABA
_021E7AB2:
	mov r3, #2
	bic r5, r3
	str r5, [r4, #0x18]
	sub r0, r0, r1
_021E7ABA:
	lsl r3, r0, #8
	asr r0, r3, #2
	lsr r0, r0, #0x1d
	add r0, r3, r0
	asr r0, r0, #3
	str r0, [r4, #0x14]
	lsl r0, r2, #8
	str r0, [r4, #8]
	lsl r0, r1, #8
	str r0, [r4, #0xc]
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7A08

	thumb_func_start ov14_021E7AD4
ov14_021E7AD4: ; 0x021E7AD4
	push {r3, r4, lr}
	sub sp, #4
	mov r4, #1
	str r4, [sp]
	bl ov14_021E7A08
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E7AD4

	thumb_func_start ov14_021E7AE4
ov14_021E7AE4: ; 0x021E7AE4
	push {r3, r4, lr}
	sub sp, #4
	add r4, r1, #0
	mov r1, #0
	str r1, [sp]
	add r3, r2, #0
	ldr r2, [r0, #0x34]
	ldr r1, _021E7B00 ; =0x0000044C
	ldrb r1, [r2, r1]
	add r2, r4, #0
	bl ov14_021E7A08
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021E7B00: .word 0x0000044C
	thumb_func_end ov14_021E7AE4

	thumb_func_start ov14_021E7B04
ov14_021E7B04: ; 0x021E7B04
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	ldr r2, [r4, #0x18]
	lsr r3, r2, #2
	cmp r3, #8
	bne _021E7B32
	cmp r1, #1
	ldrh r1, [r4]
	bne _021E7B22
	ldr r2, [r4, #4]
	bl ov14_021F396C
	b _021E7B28
_021E7B22:
	ldr r2, [r4, #4]
	bl ov14_021F39A0
_021E7B28:
	ldr r0, [r5, #0x34]
	bl ov14_021F3B5C
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E7B32:
	lsl r0, r2, #0x1f
	lsr r0, r0, #0x1f
	ldr r1, [r4, #8]
	bne _021E7B40
	ldr r0, [r4, #0x10]
	add r0, r1, r0
	b _021E7B44
_021E7B40:
	ldr r0, [r4, #0x10]
	sub r0, r1, r0
_021E7B44:
	str r0, [r4, #8]
	ldr r0, [r4, #0x18]
	ldr r1, [r4, #0xc]
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	bne _021E7B56
	ldr r0, [r4, #0x14]
	add r0, r1, r0
	b _021E7B5A
_021E7B56:
	ldr r0, [r4, #0x14]
	sub r0, r1, r0
_021E7B5A:
	str r0, [r4, #0xc]
	ldr r1, [r4, #8]
	ldr r2, [r4, #0xc]
	lsl r1, r1, #8
	lsl r2, r2, #8
	ldr r0, [r5, #0x34]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ov14_021F395C
	ldr r0, [r5, #0x34]
	bl ov14_021F3B5C
	ldr r1, [r4, #0x18]
	mov r0, #3
	add r2, r1, #0
	and r2, r0
	lsr r0, r1, #2
	add r0, r0, #1
	lsl r0, r0, #2
	orr r0, r2
	str r0, [r4, #0x18]
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7B04

	thumb_func_start ov14_021E7B8C
ov14_021E7B8C: ; 0x021E7B8C
	ldr r3, _021E7B94 ; =ov14_021E7B04
	mov r1, #1
	bx r3
	nop
_021E7B94: .word ov14_021E7B04
	thumb_func_end ov14_021E7B8C

	thumb_func_start ov14_021E7B98
ov14_021E7B98: ; 0x021E7B98
	ldr r3, _021E7BA0 ; =ov14_021E7B04
	mov r1, #0
	bx r3
	nop
_021E7BA0: .word ov14_021E7B04
	thumb_func_end ov14_021E7B98

	thumb_func_start ov14_021E7BA4
ov14_021E7BA4: ; 0x021E7BA4
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #2
	ldr r0, [r0, #0x14]
	mov r2, #0x11
	mov r3, #0xa
	bl sub_0201956C
	mov r1, #0x2f
	ldr r2, [r4, #0x34]
	lsl r1, r1, #4
	str r0, [r2, r1]
	mov r0, #7
	str r0, [sp]
	ldr r0, [r4, #0x34]
	mov r2, #1
	ldr r0, [r0, r1]
	mov r1, #0xd
	mov r3, #0x20
	bl sub_020195F4
	mov r0, #0x12
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	add r2, r1, #0
	mov r3, #0xb
	bl sub_020195F4
	mov r0, #0x12
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	mov r2, #0
	mov r3, #0xb
	bl sub_020195F4
	mov r0, #6
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xc
	mov r2, #0
	mov r3, #0xb
	bl sub_020195F4
	ldr r0, [r4, #0x34]
	bl ov14_021F6244
	ldr r0, [r4, #0x34]
	bl ov14_021F62CC
	ldr r0, [r4, #0x34]
	bl ov14_021F62E4
	ldr r0, [r4, #0x34]
	bl ov14_021F62FC
	add r0, r4, #0
	bl ov14_021F6314
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _021E7C62
	mov r0, #7
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	add r2, r1, #0
	mov r3, #0x20
	bl sub_020195F4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	mov r2, #0xc
	bl ov14_021E7D8C
	b _021E7C88
_021E7C62:
	mov r0, #6
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	mov r2, #1
	mov r3, #0x20
	bl sub_020195F4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	mov r2, #0xb
	bl ov14_021E7D8C
_021E7C88:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xd
	add r2, r1, #0
	bl ov14_021E7D8C
	ldr r0, [r4]
	ldr r1, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #1
	bhi _021E7CB2
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	mov r2, #9
	bl ov14_021E7D8C
	b _021E7CC4
_021E7CB2:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov14_021E81A8
	ldr r0, [r4, #0x34]
	bl ov14_021F63F0
_021E7CC4:
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021E7D06
	mov r0, #9
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	mov r2, #6
	mov r3, #0x20
	bl sub_020195F4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	mov r2, #0
	mov r3, #0x18
	bl sub_020196E8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	mov r2, #0x55
	bl ov14_021E7D8C
	b _021E7D3E
_021E7D06:
	mov r0, #0xa
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	mov r2, #6
	mov r3, #0xc
	bl sub_020195F4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	mov r2, #0x20
	mov r3, #0xc
	bl sub_020196E8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0x10
	mov r2, #0x56
	bl ov14_021E7D8C
_021E7D3E:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	mov r2, #0xa
	bl ov14_021E7D8C
	ldr r0, [r4, #0x34]
	bl ov14_021F63C8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8394
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85AC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8600
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E7BA4

	thumb_func_start ov14_021E7D7C
ov14_021E7D7C: ; 0x021E7D7C
	mov r1, #0x2f
	lsl r1, r1, #4
	ldr r3, _021E7D88 ; =sub_020195C0
	ldr r0, [r0, r1]
	bx r3
	nop
_021E7D88: .word sub_020195C0
	thumb_func_end ov14_021E7D7C

	thumb_func_start ov14_021E7D8C
ov14_021E7D8C: ; 0x021E7D8C
	push {r3, lr}
	add r3, r2, #0
	mov r2, #1
	str r2, [sp]
	mov r2, #0x13
	bl sub_02019688
	pop {r3, pc}
	thumb_func_end ov14_021E7D8C

	thumb_func_start ov14_021E7D9C
ov14_021E7D9C: ; 0x021E7D9C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r4, r1, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	bl sub_02019B08
	lsr r2, r4, #1
	lsl r1, r2, #1
	add r1, r2, r1
	add r1, r1, #2
	lsl r1, r1, #0x18
	lsr r2, r1, #0x18
	mov r1, #0xb
	mul r1, r2
	lsl r1, r1, #1
	add r1, r0, r1
	lsl r0, r4, #0x1f
	lsr r0, r0, #0x1d
	add r0, r0, #3
	lsl r0, r0, #0x18
	ldr r3, [r5, #0x34]
	ldr r2, _021E7DF4 ; =0x000040C0
	lsr r0, r0, #0x17
	ldr r3, [r3, r2]
	mov r2, #1
	lsl r2, r4
	tst r2, r3
	bne _021E7DE0
	add r4, #0xb
	b _021E7DE2
_021E7DE0:
	add r4, #0x2b
_021E7DE2:
	lsl r2, r4, #0x10
	lsr r4, r2, #0x10
	mov r2, #0xf
	ldrh r3, [r1, r0]
	lsl r2, r2, #0xc
	and r2, r3
	add r2, r2, r4
	strh r2, [r1, r0]
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E7DF4: .word 0x000040C0
	thumb_func_end ov14_021E7D9C

	thumb_func_start ov14_021E7DF8
ov14_021E7DF8: ; 0x021E7DF8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r4, #0
_021E7DFE:
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021E7D9C
	add r4, r4, #1
	cmp r4, #6
	blo _021E7DFE
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7DF8

	thumb_func_start ov14_021E7E10
ov14_021E7E10: ; 0x021E7E10
	push {r4, r5, r6, lr}
	add r4, r0, #0
	ldr r5, [r4, #0x34]
	ldr r6, _021E7E3C ; =0x000040C0
	mov r2, #1
	ldr r3, [r5, r6]
	lsl r2, r1
	eor r2, r3
	str r2, [r5, r6]
	bl ov14_021E7D9C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	mov r2, #0x15
	mov r3, #6
	bl sub_020196E8
	pop {r4, r5, r6, pc}
	nop
_021E7E3C: .word 0x000040C0
	thumb_func_end ov14_021E7E10

	thumb_func_start ov14_021E7E40
ov14_021E7E40: ; 0x021E7E40
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #2
	mov r2, #0x15
	mov r3, #0x18
	add r4, r0, #0
	bl sub_020196E8
	mov r0, #0x12
	mov r2, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #2
	sub r3, r2, #1
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E7E40

	thumb_func_start ov14_021E7E64
ov14_021E7E64: ; 0x021E7E64
	push {r3, lr}
	mov r1, #0x12
	str r1, [sp]
	mov r1, #2
	mov r2, #0
	mov r3, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7E64

	thumb_func_start ov14_021E7E78
ov14_021E7E78: ; 0x021E7E78
	push {r3, lr}
	mov r1, #1
	mov r2, #2
	mov r3, #6
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7E78

	thumb_func_start ov14_021E7E88
ov14_021E7E88: ; 0x021E7E88
	push {r3, lr}
	mov r1, #1
	mov r2, #0x15
	mov r3, #6
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7E88

	thumb_func_start ov14_021E7E98
ov14_021E7E98: ; 0x021E7E98
	push {r3, lr}
	sub sp, #0x10
	mov r1, #0x15
	str r1, [sp]
	mov r1, #0xb
	str r1, [sp, #4]
	mov r1, #0x12
	str r1, [sp, #8]
	mov r1, #0x10
	str r1, [sp, #0xc]
	ldr r0, [r0, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x14]
	mov r2, #0
	mov r3, #2
	bl FillBgTilemapRect
	add sp, #0x10
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7E98

	thumb_func_start ov14_021E7EC0
ov14_021E7EC0: ; 0x021E7EC0
	push {r3, lr}
	mov r1, #1
	mov r2, #2
	mov r3, #0x18
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7EC0

	thumb_func_start ov14_021E7ED0
ov14_021E7ED0: ; 0x021E7ED0
	push {r3, lr}
	mov r1, #1
	mov r2, #0x15
	mov r3, #0x18
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7ED0

	thumb_func_start ov14_021E7EE0
ov14_021E7EE0: ; 0x021E7EE0
	push {r3, r4, r5, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #1
	add r2, #1
	add r3, sp, #4
	add r4, r0, #0
	bl sub_02019B1C
	add r0, sp, #4
	mov r2, #0
	ldrsb r0, [r0, r2]
	cmp r0, #6
	beq _021E7F46
	sub r0, r0, #6
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	mov r1, #1
	str r0, [sp]
	add r0, r4, #0
	sub r3, r1, #2
	bl sub_020198FC
	add r5, sp, #4
	mov r0, #1
	ldrsb r0, [r5, r0]
	cmp r0, #2
	bne _021E7F46
	mov r3, #0
	ldrsb r3, [r5, r3]
	add r0, r4, #0
	mov r1, #0xa
	add r3, #0xf
	lsl r3, r3, #0x18
	mov r2, #0x18
	asr r3, r3, #0x18
	bl sub_020196E8
	mov r1, #0xa
	add r3, r1, #0
	add r0, r5, #0
	mov r2, #0
	ldrsb r0, [r0, r2]
	sub r3, #0xb
	sub r0, r0, #6
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	add r0, r4, #0
	bl sub_020198FC
_021E7F46:
	add sp, #8
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7EE0

	thumb_func_start ov14_021E7F4C
ov14_021E7F4C: ; 0x021E7F4C
	push {r3, r4, r5, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #1
	add r2, #1
	add r3, sp, #4
	add r4, r0, #0
	bl sub_02019B1C
	add r0, sp, #4
	mov r2, #0
	ldrsb r1, [r0, r2]
	cmp r1, #0x18
	beq _021E7FB4
	mov r0, #0x18
	sub r0, r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	mov r1, #1
	str r0, [sp]
	add r0, r4, #0
	add r3, r1, #0
	bl sub_020198FC
	add r5, sp, #4
	mov r0, #1
	ldrsb r0, [r5, r0]
	cmp r0, #2
	bne _021E7FB4
	mov r3, #0
	ldrsb r3, [r5, r3]
	add r0, r4, #0
	mov r1, #0xa
	add r3, #0xf
	lsl r3, r3, #0x18
	mov r2, #0x18
	asr r3, r3, #0x18
	bl sub_020196E8
	add r0, r5, #0
	mov r2, #0
	ldrsb r1, [r0, r2]
	mov r0, #0x18
	mov r3, #1
	sub r0, r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xa
	bl sub_020198FC
_021E7FB4:
	add sp, #8
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E7F4C

	thumb_func_start ov14_021E7FB8
ov14_021E7FB8: ; 0x021E7FB8
	push {r4, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #1
	add r2, #1
	add r3, sp, #4
	add r4, r0, #0
	bl sub_02019B1C
	add r0, sp, #4
	mov r2, #0
	ldrsb r1, [r0, r2]
	cmp r1, #0x18
	beq _021E7FE8
	mov r0, #0x18
	sub r0, r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	mov r1, #1
	str r0, [sp]
	add r0, r4, #0
	add r3, r1, #0
	bl sub_020198FC
_021E7FE8:
	add sp, #8
	pop {r4, pc}
	thumb_func_end ov14_021E7FB8

	thumb_func_start ov14_021E7FEC
ov14_021E7FEC: ; 0x021E7FEC
	push {r4, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #1
	add r2, #1
	add r3, sp, #4
	add r4, r0, #0
	bl sub_02019B1C
	add r0, sp, #4
	mov r2, #0
	ldrsb r0, [r0, r2]
	cmp r0, #6
	beq _021E801A
	sub r0, r0, #6
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	mov r1, #1
	str r0, [sp]
	add r0, r4, #0
	sub r3, r1, #2
	bl sub_020198FC
_021E801A:
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E7FEC

	thumb_func_start ov14_021E8020
ov14_021E8020: ; 0x021E8020
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0x13
	str r1, [sp]
	mov r1, #1
	add r2, r1, #0
	mov r3, #0
	add r4, r0, #0
	bl sub_020198FC
	mov r0, #0x13
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #1
	mov r3, #0
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E8020

	thumb_func_start ov14_021E8048
ov14_021E8048: ; 0x021E8048
	push {r3, lr}
	mov r1, #0x13
	str r1, [sp]
	mov r1, #1
	add r2, r1, #0
	mov r3, #0
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8048

	thumb_func_start ov14_021E805C
ov14_021E805C: ; 0x021E805C
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0x13
	str r1, [sp]
	mov r1, #1
	add r4, r0, #0
	sub r2, r1, #2
	mov r3, #0
	bl sub_020198FC
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x2b
	mov r3, #0x15
	bl sub_020196E8
	mov r1, #0xa
	mov r0, #0x13
	add r2, r1, #0
	str r0, [sp]
	add r0, r4, #0
	sub r2, #0xb
	mov r3, #0
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E805C

	thumb_func_start ov14_021E8094
ov14_021E8094: ; 0x021E8094
	push {r3, lr}
	mov r1, #0x13
	str r1, [sp]
	mov r1, #1
	sub r2, r1, #2
	mov r3, #0
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8094

	thumb_func_start ov14_021E80A8
ov14_021E80A8: ; 0x021E80A8
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r2, sp, #0
	add r3, sp, #0
	mov r1, #1
	add r2, #3
	add r3, #2
	bl sub_02019B1C
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xf
	bl sub_02019978
	mov r0, #0x2f
	add r2, sp, #0
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	add r2, #1
	add r3, sp, #0
	bl sub_02019B1C
	add r0, sp, #0
	mov r1, #3
	ldrsb r2, [r0, r1]
	mov r1, #1
	ldrsb r1, [r0, r1]
	cmp r2, r1
	bne _021E8120
	mov r1, #2
	ldrsb r2, [r0, r1]
	mov r1, #0
	ldrsb r0, [r0, r1]
	cmp r2, r0
	beq _021E8126
_021E8120:
	add r0, r5, #0
	bl ov14_021F32E0
_021E8126:
	cmp r6, #0
	bne _021E8134
	cmp r4, #0
	bne _021E8134
	add sp, #4
	mov r0, #0
	pop {r3, r4, r5, r6, pc}
_021E8134:
	mov r0, #1
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021E80A8

	thumb_func_start ov14_021E813C
ov14_021E813C: ; 0x021E813C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r2, sp, #0
	add r3, sp, #0
	mov r1, #1
	add r2, #3
	add r3, #2
	bl sub_02019B1C
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl sub_02019978
	add r4, r0, #0
	mov r0, #0x2f
	add r2, sp, #0
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	add r2, #1
	add r3, sp, #0
	bl sub_02019B1C
	add r1, sp, #0
	mov r0, #3
	ldrsb r2, [r1, r0]
	mov r0, #1
	ldrsb r0, [r1, r0]
	cmp r2, r0
	bne _021E8194
	mov r0, #2
	ldrsb r2, [r1, r0]
	mov r0, #0
	ldrsb r0, [r1, r0]
	cmp r2, r0
	beq _021E819A
_021E8194:
	add r0, r5, #0
	bl ov14_021F32E0
_021E819A:
	cmp r4, #0
	beq _021E81A2
	mov r0, #1
	pop {r3, r4, r5, pc}
_021E81A2:
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E813C

	thumb_func_start ov14_021E81A8
ov14_021E81A8: ; 0x021E81A8
	ldr r3, _021E81B0 ; =ov14_021E7D8C
	mov r2, #8
	bx r3
	nop
_021E81B0: .word ov14_021E7D8C
	thumb_func_end ov14_021E81A8

	thumb_func_start ov14_021E81B4
ov14_021E81B4: ; 0x021E81B4
	push {r3, r4, lr}
	sub sp, #4
	mov r2, #0
	mov r1, #0xd
	sub r3, r2, #7
	add r4, r0, #0
	bl sub_020196E8
	mov r0, #7
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xd
	mov r2, #0
	mov r3, #1
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E81B4

	thumb_func_start ov14_021E81D8
ov14_021E81D8: ; 0x021E81D8
	push {r3, r4, lr}
	sub sp, #4
	mov r2, #0
	mov r1, #0xd
	add r3, r2, #0
	add r4, r0, #0
	bl sub_020196E8
	mov r0, #7
	mov r2, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xd
	sub r3, r2, #1
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E81D8

	thumb_func_start ov14_021E81FC
ov14_021E81FC: ; 0x021E81FC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov14_021F5C84
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	mov r2, #0
	mov r3, #0x15
	bl sub_020196E8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E81FC

	thumb_func_start ov14_021E821C
ov14_021E821C: ; 0x021E821C
	push {r3, lr}
	ldr r1, [r0, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	mov r2, #0
	mov r3, #0x18
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E821C

	thumb_func_start ov14_021E8234
ov14_021E8234: ; 0x021E8234
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #8
	mov r2, #0
	mov r3, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8234

	thumb_func_start ov14_021E8248
ov14_021E8248: ; 0x021E8248
	push {r3, lr}
	mov r1, #3
	mov r2, #0
	str r1, [sp]
	mov r1, #8
	sub r3, r2, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8248

	thumb_func_start ov14_021E825C
ov14_021E825C: ; 0x021E825C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov14_021F5E94
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	mov r2, #0xc
	mov r3, #0x15
	bl sub_020196E8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E825C

	thumb_func_start ov14_021E827C
ov14_021E827C: ; 0x021E827C
	push {r3, lr}
	ldr r1, [r0, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	mov r2, #0xc
	mov r3, #0x18
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E827C

	thumb_func_start ov14_021E8294
ov14_021E8294: ; 0x021E8294
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #9
	mov r2, #0
	mov r3, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8294

	thumb_func_start ov14_021E82A8
ov14_021E82A8: ; 0x021E82A8
	push {r3, lr}
	mov r1, #3
	mov r2, #0
	str r1, [sp]
	mov r1, #9
	sub r3, r2, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E82A8

	thumb_func_start ov14_021E82BC
ov14_021E82BC: ; 0x021E82BC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	mov r2, #0x18
	mov r3, #0x15
	bl sub_020196E8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E82BC

	thumb_func_start ov14_021E82DC
ov14_021E82DC: ; 0x021E82DC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov14_021F5EC4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	mov r2, #0x18
	mov r3, #0x15
	bl sub_020196E8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E82DC

	thumb_func_start ov14_021E82FC
ov14_021E82FC: ; 0x021E82FC
	push {r4, lr}
	mov r1, #0xa
	add r4, r0, #0
	bl sub_0201980C
	mov r2, #0x18
	add r0, r4, #0
	mov r1, #0xa
	add r3, r2, #0
	bl sub_020196E8
	pop {r4, pc}
	thumb_func_end ov14_021E82FC

	thumb_func_start ov14_021E8314
ov14_021E8314: ; 0x021E8314
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #0xa
	mov r2, #0
	mov r3, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8314

	thumb_func_start ov14_021E8328
ov14_021E8328: ; 0x021E8328
	push {r3, r4, lr}
	sub sp, #4
	mov r2, #0x18
	mov r1, #0xa
	add r3, r2, #0
	add r4, r0, #0
	bl sub_020196E8
	mov r0, #3
	mov r2, #0
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xa
	sub r3, r2, #1
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E8328

	thumb_func_start ov14_021E834C
ov14_021E834C: ; 0x021E834C
	push {r3, lr}
	add r2, sp, #0
	mov r1, #0xb
	add r2, #1
	add r3, sp, #0
	bl sub_02019B1C
	add r1, sp, #0
	mov r0, #0
	ldrsb r1, [r1, r0]
	cmp r1, #0x15
	bne _021E8366
	mov r0, #1
_021E8366:
	pop {r3, pc}
	thumb_func_end ov14_021E834C

	thumb_func_start ov14_021E8368
ov14_021E8368: ; 0x021E8368
	push {r4, lr}
	add r4, r0, #0
	mov r1, #8
	bl sub_0201980C
	add r0, r4, #0
	mov r1, #9
	bl sub_0201980C
	add r0, r4, #0
	mov r1, #8
	mov r2, #0
	mov r3, #0x18
	bl sub_020196E8
	add r0, r4, #0
	mov r1, #9
	mov r2, #0xc
	mov r3, #0x18
	bl sub_020196E8
	pop {r4, pc}
	thumb_func_end ov14_021E8368

	thumb_func_start ov14_021E8394
ov14_021E8394: ; 0x021E8394
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r4, #0
	mov r5, #5
	mov r7, #0x20
_021E839E:
	lsl r3, r5, #0x18
	add r0, r6, #0
	add r1, r4, #3
	add r2, r7, #0
	asr r3, r3, #0x18
	bl sub_020196E8
	add r4, r4, #1
	add r5, r5, #3
	cmp r4, #5
	blo _021E839E
	mov r2, #0x18
	add r0, r6, #0
	mov r1, #0xb
	add r3, r2, #0
	bl sub_020196E8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8394

	thumb_func_start ov14_021E83C4
ov14_021E83C4: ; 0x021E83C4
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r4, #0
	mov r5, #5
	mov r7, #0x15
_021E83CE:
	lsl r3, r5, #0x18
	add r0, r6, #0
	add r1, r4, #3
	add r2, r7, #0
	asr r3, r3, #0x18
	bl sub_020196E8
	add r4, r4, #1
	add r5, r5, #3
	cmp r4, #5
	blo _021E83CE
	add r0, r6, #0
	mov r1, #0xb
	mov r2, #0x18
	mov r3, #0x15
	bl sub_020196E8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E83C4

	thumb_func_start ov14_021E83F4
ov14_021E83F4: ; 0x021E83F4
	push {r3, r4, r5, r6, r7, lr}
	add r6, r0, #0
	mov r4, #0
	mov r5, #5
	mov r7, #0x20
_021E83FE:
	add r0, r6, #0
	add r1, r4, #3
	bl sub_0201980C
	lsl r3, r5, #0x18
	add r0, r6, #0
	add r1, r4, #3
	add r2, r7, #0
	asr r3, r3, #0x18
	bl sub_020196E8
	add r4, r4, #1
	add r5, r5, #3
	cmp r4, #5
	blo _021E83FE
	add r0, r6, #0
	mov r1, #0xb
	bl sub_0201980C
	mov r2, #0x18
	add r0, r6, #0
	mov r1, #0xb
	add r3, r2, #0
	bl sub_020196E8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E83F4

	thumb_func_start ov14_021E8434
ov14_021E8434: ; 0x021E8434
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #3
	add r2, #1
	add r3, sp, #4
	add r5, r0, #0
	bl sub_02019B1C
	add r6, sp, #4
	mov r0, #1
	ldrsb r0, [r6, r0]
	cmp r0, #0x15
	beq _021E849E
	mov r4, #0
	mov r7, #1
_021E8454:
	ldrsb r0, [r6, r7]
	mov r2, #0
	add r1, r4, #3
	sub r0, #0x15
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	add r0, r5, #0
	mvn r2, r2
	mov r3, #0
	bl sub_020198FC
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #5
	blo _021E8454
	add r2, sp, #4
	add r0, r5, #0
	mov r1, #0xb
	add r2, #1
	add r3, sp, #4
	bl sub_02019B1C
	mov r1, #0xb
	add r3, r1, #0
	add r0, sp, #4
	mov r2, #0
	ldrsb r0, [r0, r2]
	sub r3, #0xc
	sub r0, #0x15
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	add r0, r5, #0
	bl sub_020198FC
_021E849E:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8434

	thumb_func_start ov14_021E84A4
ov14_021E84A4: ; 0x021E84A4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #3
	add r2, #1
	add r3, sp, #4
	add r5, r0, #0
	bl sub_02019B1C
	add r6, sp, #4
	mov r0, #1
	ldrsb r0, [r6, r0]
	cmp r0, #0x20
	beq _021E850E
	mov r4, #0
	mov r7, #0x20
_021E84C4:
	mov r0, #1
	ldrsb r0, [r6, r0]
	add r1, r4, #3
	mov r2, #1
	sub r0, r7, r0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	add r0, r5, #0
	mov r3, #0
	bl sub_020198FC
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #5
	blo _021E84C4
	add r2, sp, #4
	add r0, r5, #0
	mov r1, #0xb
	add r2, #1
	add r3, sp, #4
	bl sub_02019B1C
	add r0, sp, #4
	mov r2, #0
	ldrsb r1, [r0, r2]
	mov r0, #0x18
	mov r3, #1
	sub r0, r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	add r0, r5, #0
	mov r1, #0xb
	bl sub_020198FC
_021E850E:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E84A4

	thumb_func_start ov14_021E8514
ov14_021E8514: ; 0x021E8514
	push {r3, r4, r5, r6, r7, lr}
	mov r6, #0
	add r5, r0, #0
	add r4, r6, #0
	mov r7, #1
_021E851E:
	add r0, r5, #0
	add r1, r4, #3
	bl sub_02019978
	cmp r0, #1
	bne _021E852C
	add r6, r7, #0
_021E852C:
	add r4, r4, #1
	cmp r4, #5
	blo _021E851E
	add r0, r5, #0
	mov r1, #0xb
	bl sub_02019978
	cmp r0, #1
	bne _021E8540
	mov r6, #1
_021E8540:
	add r0, r6, #0
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021E8514

	thumb_func_start ov14_021E8544
ov14_021E8544: ; 0x021E8544
	push {r3, lr}
	add r2, sp, #0
	mov r1, #3
	add r2, #1
	add r3, sp, #0
	bl sub_02019B1C
	add r1, sp, #0
	mov r0, #1
	ldrsb r1, [r1, r0]
	cmp r1, #0x20
	bne _021E855E
	mov r0, #0
_021E855E:
	pop {r3, pc}
	thumb_func_end ov14_021E8544

	thumb_func_start ov14_021E8560
ov14_021E8560: ; 0x021E8560
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0xc
	mov r2, #0x20
	mov r3, #0xe
	add r4, r0, #0
	bl sub_020196E8
	mov r1, #0xc
	mov r0, #0xb
	add r2, r1, #0
	str r0, [sp]
	add r0, r4, #0
	sub r2, #0xd
	mov r3, #0
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8560

	thumb_func_start ov14_021E8588
ov14_021E8588: ; 0x021E8588
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0xc
	mov r2, #0x15
	mov r3, #0xe
	add r4, r0, #0
	bl sub_020196E8
	mov r0, #0xb
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #1
	mov r3, #0
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E8588

	thumb_func_start ov14_021E85AC
ov14_021E85AC: ; 0x021E85AC
	push {r3, lr}
	mov r1, #0xe
	mov r2, #0
	mov r3, #0x18
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E85AC

	thumb_func_start ov14_021E85BC
ov14_021E85BC: ; 0x021E85BC
	push {r3, lr}
	mov r1, #3
	mov r2, #0
	str r1, [sp]
	mov r1, #0xe
	sub r3, r2, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E85BC

	thumb_func_start ov14_021E85D0
ov14_021E85D0: ; 0x021E85D0
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #0xe
	mov r2, #0
	mov r3, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E85D0

	thumb_func_start ov14_021E85E4
ov14_021E85E4: ; 0x021E85E4
	push {r3, lr}
	add r2, sp, #0
	mov r1, #0xe
	add r2, #1
	add r3, sp, #0
	bl sub_02019B1C
	add r1, sp, #0
	mov r0, #0
	ldrsb r1, [r1, r0]
	cmp r1, #0x15
	bne _021E85FE
	mov r0, #1
_021E85FE:
	pop {r3, pc}
	thumb_func_end ov14_021E85E4

	thumb_func_start ov14_021E8600
ov14_021E8600: ; 0x021E8600
	push {r3, lr}
	mov r1, #0xf
	mov r2, #0
	mov r3, #0x18
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8600

	thumb_func_start ov14_021E8610
ov14_021E8610: ; 0x021E8610
	push {r3, lr}
	mov r1, #0xf
	mov r2, #0
	mov r3, #0x15
	bl sub_020196E8
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8610

	thumb_func_start ov14_021E8620
ov14_021E8620: ; 0x021E8620
	push {r3, lr}
	mov r1, #3
	mov r2, #0
	str r1, [sp]
	mov r1, #0xf
	sub r3, r2, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8620

	thumb_func_start ov14_021E8634
ov14_021E8634: ; 0x021E8634
	push {r3, lr}
	mov r1, #3
	str r1, [sp]
	mov r1, #0xf
	mov r2, #0
	mov r3, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8634

	thumb_func_start ov14_021E8648
ov14_021E8648: ; 0x021E8648
	push {r3, lr}
	add r2, sp, #0
	mov r1, #0xf
	add r2, #1
	add r3, sp, #0
	bl sub_02019B1C
	add r1, sp, #0
	mov r0, #0
	ldrsb r1, [r1, r0]
	cmp r1, #0x15
	bne _021E8662
	mov r0, #1
_021E8662:
	pop {r3, pc}
	thumb_func_end ov14_021E8648

	thumb_func_start ov14_021E8664
ov14_021E8664: ; 0x021E8664
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E82DC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_0201980C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_0201980C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	mov r2, #0
	mov r3, #0x18
	bl sub_020196E8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	mov r2, #0xc
	mov r3, #0x18
	bl sub_020196E8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	add r2, r1, #0
	add r3, r1, #0
	bl sub_020196E8
	add r0, r4, #0
	bl ov14_021F57B8
	add r0, r4, #0
	bl ov14_021F4720
	add r0, r4, #0
	bl ov14_021F4848
	add r0, r4, #0
	bl ov14_021F48B4
	add r0, r4, #0
	mov r1, #0x30
	bl ov14_021F47B8
	pop {r4, pc}
	thumb_func_end ov14_021E8664

	thumb_func_start ov14_021E86E0
ov14_021E86E0: ; 0x021E86E0
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0
	add r2, r1, #0
	sub r3, r1, #6
	add r4, r0, #0
	bl sub_020196E8
	mov r0, #6
	mov r1, #0
	str r0, [sp]
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #1
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E86E0

	thumb_func_start ov14_021E8704
ov14_021E8704: ; 0x021E8704
	push {r3, lr}
	mov r1, #6
	str r1, [sp]
	mov r1, #0
	add r2, r1, #0
	sub r3, r1, #1
	bl sub_020198FC
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8704

	thumb_func_start ov14_021E8718
ov14_021E8718: ; 0x021E8718
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0xc
	mov r2, #0x15
	mov r3, #8
	bl sub_020196E8
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x15
	mov r3, #0xe
	bl sub_020196E8
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x15
	mov r3, #0x11
	bl sub_020196E8
	pop {r4, pc}
	thumb_func_end ov14_021E8718

	thumb_func_start ov14_021E8740
ov14_021E8740: ; 0x021E8740
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E8664
	add r0, r4, #0
	bl ov14_021F6070
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8718
	pop {r4, pc}
	thumb_func_end ov14_021E8740

	thumb_func_start ov14_021E875C
ov14_021E875C: ; 0x021E875C
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	mov r1, #0xc
	mov r2, #0x20
	mov r3, #8
	bl sub_020196E8
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x20
	mov r3, #0xe
	bl sub_020196E8
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x20
	mov r3, #0x11
	bl sub_020196E8
	mov r1, #0xc
	mov r0, #0xb
	add r2, r1, #0
	str r0, [sp]
	add r0, r4, #0
	sub r2, #0xd
	mov r3, #0
	bl sub_020198FC
	mov r0, #0xb
	mov r1, #6
	str r0, [sp]
	add r0, r4, #0
	sub r2, r1, #7
	mov r3, #0
	bl sub_020198FC
	mov r1, #7
	mov r0, #0xb
	add r2, r1, #0
	str r0, [sp]
	add r0, r4, #0
	sub r2, #8
	mov r3, #0
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E875C

	thumb_func_start ov14_021E87BC
ov14_021E87BC: ; 0x021E87BC
	push {r3, r4, lr}
	sub sp, #4
	mov r1, #0xb
	str r1, [sp]
	mov r1, #0xc
	mov r2, #1
	mov r3, #0
	add r4, r0, #0
	bl sub_020198FC
	mov r0, #0xb
	str r0, [sp]
	add r0, r4, #0
	mov r1, #6
	mov r2, #1
	mov r3, #0
	bl sub_020198FC
	mov r0, #0xb
	str r0, [sp]
	add r0, r4, #0
	mov r1, #7
	mov r2, #1
	mov r3, #0
	bl sub_020198FC
	add sp, #4
	pop {r3, r4, pc}
	thumb_func_end ov14_021E87BC

	thumb_func_start ov14_021E87F4
ov14_021E87F4: ; 0x021E87F4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_0201980C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_0201980C
	add r0, r4, #0
	bl ov14_021E821C
	add r0, r4, #0
	bl ov14_021E827C
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E87F4

	thumb_func_start ov14_021E8824
ov14_021E8824: ; 0x021E8824
	push {r3, lr}
	ldr r1, _021E8848 ; =0x0000044E
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1d
	beq _021E8846
	mov r1, #0xc
	str r1, [sp]
	mov r1, #0x2f
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	mov r1, #0x10
	add r2, r1, #0
	sub r2, #0x11
	mov r3, #0
	bl sub_020198FC
_021E8846:
	pop {r3, pc}
	.balign 4, 0
_021E8848: .word 0x0000044E
	thumb_func_end ov14_021E8824

	thumb_func_start ov14_021E884C
ov14_021E884C: ; 0x021E884C
	push {r3, lr}
	ldr r1, _021E8870 ; =0x0000044E
	ldrb r1, [r0, r1]
	lsl r1, r1, #0x19
	lsr r1, r1, #0x1d
	beq _021E886C
	mov r1, #0xc
	str r1, [sp]
	mov r1, #0x2f
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	mov r1, #0x10
	mov r2, #1
	mov r3, #0
	bl sub_020198FC
_021E886C:
	pop {r3, pc}
	nop
_021E8870: .word 0x0000044E
	thumb_func_end ov14_021E884C

	thumb_func_start ov14_021E8874
ov14_021E8874: ; 0x021E8874
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E88A0 ; =0x0000044E
	ldrb r0, [r4, r0]
	lsl r0, r0, #0x19
	lsr r0, r0, #0x1d
	beq _021E889E
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0x10
	bl sub_0201980C
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0x10
	mov r2, #0x14
	mov r3, #0xc
	bl sub_020196E8
_021E889E:
	pop {r4, pc}
	.balign 4, 0
_021E88A0: .word 0x0000044E
	thumb_func_end ov14_021E8874

	thumb_func_start ov14_021E88A4
ov14_021E88A4: ; 0x021E88A4
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x10
	bl sub_0201980C
	add r0, r4, #0
	mov r1, #0x10
	mov r2, #0x20
	mov r3, #0xc
	bl sub_020196E8
	pop {r4, pc}
	thumb_func_end ov14_021E88A4

	thumb_func_start ov14_021E88BC
ov14_021E88BC: ; 0x021E88BC
	push {r4, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #0x10
	add r2, #1
	add r3, sp, #4
	add r4, r0, #0
	bl sub_02019B1C
	add r0, sp, #4
	mov r2, #0
	ldrsb r1, [r0, r2]
	cmp r1, #0xf
	beq _021E88F2
	mov r0, #0x18
	sub r1, r0, r1
	mov r0, #9
	sub r0, r0, r1
	lsl r0, r0, #0x18
	mov r1, #0x10
	lsr r0, r0, #0x18
	add r3, r1, #0
	str r0, [sp]
	add r0, r4, #0
	sub r3, #0x11
	bl sub_020198FC
_021E88F2:
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E88BC

	thumb_func_start ov14_021E88F8
ov14_021E88F8: ; 0x021E88F8
	push {r4, lr}
	sub sp, #8
	add r2, sp, #4
	mov r1, #0x10
	add r2, #1
	add r3, sp, #4
	add r4, r0, #0
	bl sub_02019B1C
	add r0, sp, #4
	mov r2, #0
	ldrsb r1, [r0, r2]
	cmp r1, #0x18
	beq _021E8928
	mov r0, #0x18
	sub r0, r0, r1
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	add r0, r4, #0
	mov r1, #0x10
	mov r3, #1
	bl sub_020198FC
_021E8928:
	add sp, #8
	pop {r4, pc}
	thumb_func_end ov14_021E88F8

	thumb_func_start ov14_021E892C
ov14_021E892C: ; 0x021E892C
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x10
	bl sub_0201980C
	add r0, r4, #0
	mov r1, #0x10
	mov r2, #0
	mov r3, #0xf
	bl sub_020196E8
	pop {r4, pc}
	thumb_func_end ov14_021E892C

	thumb_func_start ov14_021E8944
ov14_021E8944: ; 0x021E8944
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x10
	bl sub_0201980C
	add r0, r4, #0
	mov r1, #0x10
	mov r2, #0
	mov r3, #0x18
	bl sub_020196E8
	pop {r4, pc}
	thumb_func_end ov14_021E8944

	thumb_func_start ov14_021E895C
ov14_021E895C: ; 0x021E895C
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	add r6, r1, #0
	mov r4, #0
	mov r7, #1
_021E8968:
	add r0, r7, #0
	lsl r0, r4
	tst r0, r6
	beq _021E8976
	add r0, r4, #0
	add r0, #0x3a
	b _021E897A
_021E8976:
	add r0, r4, #0
	add r0, #0x1a
_021E897A:
	lsl r0, r0, #0x10
	lsr r2, r0, #0x10
	mov r0, #0x12
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r0, [sp, #8]
	mov r0, #0
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x34]
	add r3, r4, #0
	add r3, #0xf
	lsl r3, r3, #0x18
	ldr r0, [r0, #0x14]
	mov r1, #5
	lsr r3, r3, #0x18
	bl FillBgTilemapRect
	add r0, r4, #1
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	cmp r4, #6
	blo _021E8968
	ldr r0, [r5, #0x34]
	mov r1, #5
	ldr r0, [r0, #0x14]
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E895C

	thumb_func_start ov14_021E89B8
ov14_021E89B8: ; 0x021E89B8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #9
	mov r1, #0x3c
	bl Heap_Alloc
	str r0, [r5, #0x18]
	add r4, r0, #0
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021E89EE
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	mov r2, #0
	bl ov14_021E60C0
	str r0, [r4]
	mov r0, #2
	strb r0, [r4, #0x11]
	mov r0, #0x1e
	strb r0, [r4, #0x13]
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	b _021E8A06
_021E89EE:
	ldr r0, [r5, #8]
	str r0, [r4]
	mov r0, #1
	strb r0, [r4, #0x11]
	ldr r0, [r5, #8]
	bl Party_GetCount
	strb r0, [r4, #0x13]
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
_021E8A06:
	strb r0, [r4, #0x14]
	ldr r0, [r5, #0x10]
	str r0, [r4, #4]
	ldr r0, [r5]
	ldr r0, [r0]
	bl Save_PlayerData_GetProfile
	add r1, r0, #0
	add r0, r4, #0
	bl sub_0208AD34
	mov r0, #0
	strb r0, [r4, #0x12]
	ldr r1, _021E8A74 ; =ov14_021F7D0C
	add r0, r4, #0
	bl sub_02089D40
	mov r0, #0
	strb r0, [r4, #0x16]
	strb r0, [r4, #0x17]
	strh r0, [r4, #0x18]
	ldr r0, [r5]
	ldr r0, [r0]
	bl SaveArray_IsNatDexEnabled
	str r0, [r4, #0x1c]
	ldr r0, [r5]
	ldr r0, [r0]
	bl Save_SpecialRibbons_Get
	str r0, [r4, #0x20]
	mov r0, #0
	str r0, [r4, #0x24]
	str r0, [r4, #0x28]
	ldr r0, [r5]
	ldr r0, [r0]
	bl sub_02088288
	str r0, [r4, #0x2c]
	ldr r0, [r5]
	ldr r0, [r0]
	bl sub_0208828C
	str r0, [r4, #0x34]
	ldr r0, [r5]
	add r1, r4, #0
	ldr r0, [r0, #4]
	mov r2, #9
	str r0, [r4, #0x30]
	ldr r0, _021E8A78 ; =gOverlayTemplate_PokemonSummary
	bl OverlayManager_New
	str r0, [r5, #0x14]
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021E8A74: .word ov14_021F7D0C
_021E8A78: .word gOverlayTemplate_PokemonSummary
	thumb_func_end ov14_021E89B8

	thumb_func_start ov14_021E8A7C
ov14_021E8A7C: ; 0x021E8A7C
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x27
	ldrb r1, [r1]
	ldr r0, [r4, #0x18]
	cmp r1, #0
	bne _021E8AA8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldrb r2, [r0, #0x14]
	cmp r1, #0x1e
	bhs _021E8AA0
	add r1, r4, #0
	add r1, #0x21
	strb r2, [r1]
	b _021E8AA8
_021E8AA0:
	add r1, r4, #0
	add r2, #0x1e
	add r1, #0x21
	strb r2, [r1]
_021E8AA8:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	cmp r1, #0x1e
	bhs _021E8AC0
	ldr r0, [r0, #0x38]
	cmp r0, #1
	bne _021E8AC0
	ldrb r1, [r4, #0x1f]
	ldr r0, [r4, #4]
	bl PCStorage_SetBoxModified
_021E8AC0:
	ldr r0, [r4, #0x18]
	bl Heap_Free
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8A7C

	thumb_func_start ov14_021E8ACC
ov14_021E8ACC: ; 0x021E8ACC
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4]
	ldr r0, [r0]
	bl Save_Bag_Get
	ldr r1, _021E8B10 ; =ov14_021F7D14
	mov r2, #9
	bl Bag_CreateView
	str r0, [r4, #0x18]
	ldr r1, [r4]
	mov r2, #1
	ldr r0, [r1, #4]
	mov r3, #0
	str r0, [sp]
	ldr r0, [r4, #0x18]
	ldr r1, [r1]
	bl sub_0207789C
	ldr r0, _021E8B14 ; =FS_OVERLAY_ID(OVY_15)
	mov r1, #2
	bl HandleLoadOverlay
	ldr r0, _021E8B18 ; =ov15_022008B8
	ldr r1, [r4, #0x18]
	mov r2, #9
	bl OverlayManager_New
	str r0, [r4, #0x14]
	mov r0, #0
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021E8B10: .word ov14_021F7D14
_021E8B14: .word FS_OVERLAY_ID(OVY_15)
_021E8B18: .word ov15_022008B8
	thumb_func_end ov14_021E8ACC

	thumb_func_start ov14_021E8B1C
ov14_021E8B1C: ; 0x021E8B1C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021E8B38 ; =FS_OVERLAY_ID(OVY_15)
	bl UnloadOverlayByID
	ldr r0, [r4, #0x18]
	bl BagView_GetItemId
	strh r0, [r4, #0x1c]
	ldr r0, [r4, #0x18]
	bl Heap_Free
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021E8B38: .word FS_OVERLAY_ID(OVY_15)
	thumb_func_end ov14_021E8B1C

	thumb_func_start ov14_021E8B3C
ov14_021E8B3C: ; 0x021E8B3C
	push {r4, lr}
	sub sp, #8
	add r4, r0, #0
	ldr r0, [r4, #0x10]
	mov r1, #2
	str r0, [sp]
	ldr r0, [r4]
	mov r2, #0
	ldr r0, [r0, #4]
	mov r3, #8
	str r0, [sp, #4]
	mov r0, #9
	bl NamingScreen_CreateArgs
	str r0, [r4, #0x18]
	add r1, r4, #0
	add r1, #0x25
	ldr r2, [r4, #0x18]
	ldrb r1, [r1]
	ldr r0, [r4, #4]
	ldr r2, [r2, #0x18]
	bl PCStorage_GetBoxName
	ldr r0, _021E8B7C ; =gOverlayTemplate_NamingScreen
	ldr r1, [r4, #0x18]
	mov r2, #9
	bl OverlayManager_New
	str r0, [r4, #0x14]
	mov r0, #0
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
_021E8B7C: .word gOverlayTemplate_NamingScreen
	thumb_func_end ov14_021E8B3C

	thumb_func_start ov14_021E8B80
ov14_021E8B80: ; 0x021E8B80
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	ldr r4, [r5, #0x18]
	add r1, #0x25
	ldrb r1, [r1]
	ldr r0, [r5, #4]
	ldr r2, [r4, #0x18]
	bl PCStorage_SetBoxName
	ldr r0, [r4, #0x14]
	strh r0, [r5, #0x1c]
	ldr r0, [r5, #0x18]
	bl NamingScreen_DeleteArgs
	mov r0, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E8B80

	thumb_func_start ov14_021E8BA4
ov14_021E8BA4: ; 0x021E8BA4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r5, r0, #0
	mov r0, #0x2f
	ldr r4, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	bl ov14_021E8514
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_02019978
	add r7, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	str r0, [sp]
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	str r0, [sp, #4]
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021E8BF4
	cmp r0, #1
	beq _021E8CCC
	b _021E8D0C
_021E8BF4:
	add r0, sp, #0xc
	add r1, sp, #8
	bl System_GetTouchHeldCoords
	cmp r0, #0
	bne _021E8C86
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	mov r6, #0xff
	cmp r0, #0
	beq _021E8C24
	ldr r1, [r5, #0x34]
	ldr r2, _021E8D14 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E79D8
	add r6, r0, #0
_021E8C24:
	cmp r6, #0xff
	bne _021E8C40
	ldr r1, [r5, #0x34]
	ldr r2, _021E8D14 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E7960
	add r6, r0, #0
_021E8C40:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	add r2, r6, #0
	bl ov14_021E6CF8
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F40E8
	mov r0, #0x80
	tst r0, r6
	bne _021E8C6E
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E70B0
	add r1, r5, #0
	add r1, #0x21
	strb r0, [r1]
_021E8C6E:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	ldr r0, [r5, #0x34]
	bl ov14_021E8824
	mov r0, #1
	strh r0, [r4, #0x10]
	b _021E8D0C
_021E8C86:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	add r2, r0, r1
	ldr r1, _021E8D18 ; =0x00004094
	ldrb r1, [r2, r1]
	ldr r2, [sp, #8]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	lsl r2, r2, #0x10
	ldr r0, [r1, r0]
	ldr r1, [sp, #0xc]
	asr r2, r2, #0x10
	sub r2, #8
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r5, #0
	bl ov14_021F4174
	ldr r2, [sp, #0xc]
	ldr r1, [r5, #0x34]
	ldr r0, _021E8D14 ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp, #8]
	ldr r1, [r5, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021E8D0C
_021E8CCC:
	add r0, r5, #0
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E8D0C
	cmp r6, #0
	bne _021E8D0C
	cmp r7, #0
	bne _021E8D0C
	ldr r0, [sp]
	cmp r0, #0
	bne _021E8D0C
	ldr r0, [sp, #4]
	cmp r0, #0
	bne _021E8D0C
	ldr r1, [r4, #0xc]
	add r0, r5, #0
	bl ov14_021E7148
	add r0, r5, #0
	bl ov14_021F4174
	ldr r2, [r5, #0x34]
	ldr r1, _021E8D1C ; =0x000040C4
	add r0, r5, #0
	ldr r1, [r2, r1]
	bl ov14_021F40E8
	mov r0, #0
	add sp, #0x10
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021E8D0C:
	mov r0, #1
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E8D14: .word 0x000040B8
_021E8D18: .word 0x00004094
_021E8D1C: .word 0x000040C4
	thumb_func_end ov14_021E8BA4

	thumb_func_start ov14_021E8D20
ov14_021E8D20: ; 0x021E8D20
	push {r4, r5, r6, r7, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x2f
	ldr r5, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ov14_021E8514
	add r7, r0, #0
	ldrh r0, [r5, #0x10]
	cmp r0, #0
	bne _021E8D5C
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	add r2, r0, r1
	ldr r1, _021E8FC0 ; =0x00004094
	ldrb r1, [r2, r1]
	add r2, sp, #0
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	bl ManagedSprite_GetPositionXY
_021E8D5C:
	add r0, r4, #0
	bl ov14_021E80A8
	add r6, r0, #0
	ldrh r0, [r5, #0x10]
	cmp r0, #5
	bls _021E8D6C
	b _021E8FB8
_021E8D6C:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E8D78: ; jump table
	.short _021E8D84 - _021E8D78 - 2 ; case 0
	.short _021E8F1E - _021E8D78 - 2 ; case 1
	.short _021E8F1E - _021E8D78 - 2 ; case 2
	.short _021E8F62 - _021E8D78 - 2 ; case 3
	.short _021E8F96 - _021E8D78 - 2 ; case 4
	.short _021E8FA0 - _021E8D78 - 2 ; case 5
_021E8D84:
	ldr r0, [r4, #0x34]
	ldr r1, _021E8FC4 ; =0x0000044A
	ldrb r2, [r0, r1]
	cmp r2, #1
	bne _021E8DA8
	cmp r6, #0
	bne _021E8DA8
	mov r2, #2
	strb r2, [r0, r1]
	add r0, r4, #0
	mov r1, #0x28
	bl ov14_021F69F0
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
_021E8DA8:
	add r0, sp, #8
	add r1, sp, #4
	bl System_GetTouchHeldCoords
	cmp r0, #0
	bne _021E8EA8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	add r3, sp, #0
	add r2, r0, r1
	ldr r1, _021E8FC0 ; =0x00004094
	ldrb r1, [r2, r1]
	mov r2, #0
	ldrsh r2, [r3, r2]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	ldrsh r1, [r3, r1]
	bl ManagedSprite_SetPositionXY
	ldr r1, [r4, #0x34]
	ldr r0, _021E8FC4 ; =0x0000044A
	ldr r2, _021E8FC8 ; =0x000040B8
	ldrb r0, [r1, r0]
	cmp r0, #2
	bne _021E8DFA
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E7960
	b _021E8E0E
_021E8DFA:
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	ldr r2, _021E8FCC ; =ov14_021F7BF0
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E79AC
_021E8E0E:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r2, r0, #0
	add r0, r4, #0
	bl ov14_021E6CF8
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E70B0
	add r1, r4, #0
	add r1, #0x21
	strb r0, [r1]
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021E8E44
	mov r2, #0
	b _021E8E46
_021E8E44:
	mov r2, #1
_021E8E46:
	ldr r1, [r4, #0x34]
	ldr r0, _021E8FD0 ; =0x000040C4
	str r2, [r1, r0]
	add r0, r4, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0x1e
	bhs _021E8E84
	add r0, r4, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	bne _021E8E6A
	mov r0, #3
	strh r0, [r5, #0x10]
	b _021E8FB8
_021E8E6A:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	add r0, r4, #0
	mov r1, #0xff
	bl ov14_021E7588
	mov r0, #1
	strh r0, [r5, #0x10]
	b _021E8FB8
_021E8E84:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7FEC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	mov r0, #1
	strh r0, [r5, #0x10]
	b _021E8FB8
_021E8EA8:
	cmp r7, #0
	bne _021E8ED8
	ldr r0, [r4, #0x34]
	ldr r1, _021E8FC4 ; =0x0000044A
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021E8ED8
	ldr r2, [sp, #8]
	cmp r2, #0x10
	blo _021E8EC6
	ldr r1, [sp, #4]
	cmp r1, #0x30
	blo _021E8EC6
	cmp r2, #0x68
	blo _021E8ED8
_021E8EC6:
	ldr r1, _021E8FC4 ; =0x0000044A
	mov r2, #1
	strb r2, [r0, r1]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7FB8
_021E8ED8:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	add r2, r0, r1
	ldr r1, _021E8FC0 ; =0x00004094
	ldrb r1, [r2, r1]
	ldr r2, [sp, #4]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	lsl r2, r2, #0x10
	ldr r0, [r1, r0]
	ldr r1, [sp, #8]
	asr r2, r2, #0x10
	sub r2, #8
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	bl ov14_021F4174
	ldr r2, [sp, #8]
	ldr r1, [r4, #0x34]
	ldr r0, _021E8FC8 ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp, #4]
	ldr r1, [r4, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021E8FB8
_021E8F1E:
	add r0, r4, #0
	bl ov14_021E6814
	cmp r0, #0
	bne _021E8FB8
	cmp r7, #0
	bne _021E8FB8
	cmp r6, #0
	bne _021E8FB8
	ldr r1, [r5, #0xc]
	add r0, r4, #0
	bl ov14_021E7148
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021E8F4A
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
_021E8F4A:
	add r0, r4, #0
	bl ov14_021F4174
	ldr r2, [r4, #0x34]
	ldr r1, _021E8FD0 ; =0x000040C4
	add r0, r4, #0
	ldr r1, [r2, r1]
	bl ov14_021F40E8
	mov r0, #5
	strh r0, [r5, #0x10]
	b _021E8FB8
_021E8F62:
	add r0, r4, #0
	bl ov14_021E66F4
	cmp r0, #0
	bne _021E8FB8
	ldr r1, [r5, #0xc]
	add r0, r4, #0
	bl ov14_021E7148
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	add r0, r4, #0
	mov r1, #0xff
	bl ov14_021E7588
	mov r0, #0xff
	add r4, #0x21
	strb r0, [r4]
	ldrh r0, [r5, #0x10]
	add r0, r0, #1
	strh r0, [r5, #0x10]
	b _021E8FB8
_021E8F96:
	cmp r6, #0
	bne _021E8FB8
	mov r0, #5
	strh r0, [r5, #0x10]
	b _021E8FB8
_021E8FA0:
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	ldr r2, [r4, #0x34]
	ldr r1, _021E8FC4 ; =0x0000044A
	mov r0, #0
	strb r0, [r2, r1]
	add sp, #0xc
	strh r0, [r5, #0x10]
	pop {r4, r5, r6, r7, pc}
_021E8FB8:
	mov r0, #1
	add sp, #0xc
	pop {r4, r5, r6, r7, pc}
	nop
_021E8FC0: .word 0x00004094
_021E8FC4: .word 0x0000044A
_021E8FC8: .word 0x000040B8
_021E8FCC: .word ov14_021F7BF0
_021E8FD0: .word 0x000040C4
	thumb_func_end ov14_021E8D20

	thumb_func_start ov14_021E8FD4
ov14_021E8FD4: ; 0x021E8FD4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r5, r0, #0
	mov r0, #0x2f
	ldr r4, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xe
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xf
	bl sub_02019978
	add r7, r0, #0
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021E900C
	cmp r0, #1
	beq _021E90F8
	cmp r0, #2
	bne _021E900A
	b _021E914E
_021E900A:
	b _021E9180
_021E900C:
	add r0, sp, #4
	add r1, sp, #0
	bl System_GetTouchHeldCoords
	cmp r0, #0
	bne _021E90B2
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	mov r6, #0xff
	cmp r0, #0
	beq _021E903C
	ldr r1, [r5, #0x34]
	ldr r2, _021E9188 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E79D8
	add r6, r0, #0
_021E903C:
	cmp r6, #0xff
	bne _021E9058
	ldr r1, [r5, #0x34]
	ldr r2, _021E9188 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E7960
	add r6, r0, #0
_021E9058:
	cmp r6, #0xff
	bne _021E9076
	ldr r1, [r5, #0x34]
	ldr r2, _021E9188 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	ldr r2, _021E918C ; =ov14_021F7C08
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E79AC
	add r6, r0, #0
_021E9076:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	add r2, r6, #0
	bl ov14_021E6CF8
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F40E8
	mov r0, #0x80
	tst r0, r6
	bne _021E90A4
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E70B0
	add r1, r5, #0
	add r1, #0x21
	strb r0, [r1]
_021E90A4:
	ldr r0, [r5, #0x34]
	bl ov14_021E884C
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021E9180
_021E90B2:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	add r2, r0, r1
	ldr r1, _021E9190 ; =0x00004094
	ldrb r1, [r2, r1]
	ldr r2, [sp]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	lsl r2, r2, #0x10
	ldr r0, [r1, r0]
	ldr r1, [sp, #4]
	asr r2, r2, #0x10
	sub r2, #8
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r5, #0
	bl ov14_021F4174
	ldr r2, [sp, #4]
	ldr r1, [r5, #0x34]
	ldr r0, _021E9188 ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp]
	ldr r1, [r5, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021E9180
_021E90F8:
	cmp r6, #0
	bne _021E914E
	cmp r7, #0
	bne _021E914E
	ldr r6, [r4, #0xc]
	add r0, r6, #0
	add r0, #0xe8
	ldr r1, [r0]
	cmp r1, #0xff
	beq _021E913C
	mov r0, #0x80
	tst r0, r1
	beq _021E913C
	add r0, r6, #0
	add r0, #0xe4
	ldr r0, [r0]
	cmp r0, #0x1e
	blo _021E9148
	ldr r0, [r5, #8]
	bl Party_GetCount
	add r6, #0xe4
	ldr r1, [r6]
	sub r0, r0, #1
	sub r1, #0x1e
	cmp r1, r0
	bhs _021E9148
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	b _021E9148
_021E913C:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
_021E9148:
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021E914E:
	add r0, r5, #0
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E9180
	cmp r7, #0
	bne _021E9180
	ldrh r0, [r4, #0x10]
	cmp r0, #2
	bne _021E9180
	ldr r1, [r4, #0xc]
	add r0, r5, #0
	bl ov14_021E7148
	add r0, r5, #0
	bl ov14_021F4174
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F40E8
	mov r0, #0
	add sp, #8
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021E9180:
	mov r0, #1
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9188: .word 0x000040B8
_021E918C: .word ov14_021F7C08
_021E9190: .word 0x00004094
	thumb_func_end ov14_021E8FD4

	thumb_func_start ov14_021E9194
ov14_021E9194: ; 0x021E9194
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r4, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xa
	bl sub_02019978
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021E91B2
	cmp r0, #1
	beq _021E91C4
	b _021E91DC
_021E91B2:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E70E0
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021E91C4:
	add r0, r5, #0
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E91DC
	ldr r1, [r4, #0xc]
	add r0, r5, #0
	bl ov14_021E7148
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021E91DC:
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E9194

	thumb_func_start ov14_021E91E0
ov14_021E91E0: ; 0x021E91E0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021E91F2
	cmp r1, #1
	beq _021E9218
	b _021E922E
_021E91F2:
	ldr r0, [r5, #8]
	bl Party_GetCount
	add r2, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r2, #0x1e
	add r0, r5, #0
	bl ov14_021E6CF8
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F40E8
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021E922E
_021E9218:
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E922E
	ldr r1, [r4, #0xc]
	add r0, r5, #0
	bl ov14_021E7148
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021E922E:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E91E0

	thumb_func_start ov14_021E9234
ov14_021E9234: ; 0x021E9234
	push {r4, r5, r6, lr}
	sub sp, #8
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021E9248
	cmp r1, #1
	beq _021E927E
	b _021E92A6
_021E9248:
	ldrb r0, [r5, #0x1f]
	add r1, sp, #0
	add r2, sp, #4
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	ldr r0, [r5, #4]
	bl PCStorage_FindFirstEmptySlot
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r2, [sp, #4]
	add r0, r5, #0
	bl ov14_021E6CF8
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F40E8
	mov r0, #0xff
	add r5, #0x21
	strb r0, [r5]
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021E92A6
_021E927E:
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E92A6
	ldr r6, [r4, #0xc]
	ldr r0, [r5, #0x34]
	add r1, r6, #0
	add r1, #0xe4
	ldr r1, [r1]
	mov r2, #1
	bl ov14_021F34C8
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E7148
	mov r0, #0
	add sp, #8
	strh r0, [r4, #0x10]
	pop {r4, r5, r6, pc}
_021E92A6:
	mov r0, #1
	add sp, #8
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021E9234

	thumb_func_start ov14_021E92AC
ov14_021E92AC: ; 0x021E92AC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r1, [r5, #0x34]
	ldrh r0, [r1, #0x12]
	cmp r0, #0x17
	bne _021E92D8
	ldr r0, [r1, #0x2c]
	bl GridInputHandler_IsButtonInputMode
	cmp r0, #1
	bne _021E92CC
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
_021E92CC:
	ldr r1, [r5, #0x34]
	mov r0, #0
	strh r0, [r1, #0x12]
	ldr r1, [r5, #0x34]
	strh r0, [r1, #0x10]
	pop {r3, r4, r5, pc}
_021E92D8:
	ldr r0, [r1, #0x14]
	mov r1, #3
	mov r2, #2
	mov r3, #8
	bl ScheduleSetBgPosText
	add r0, r5, #0
	mov r1, #8
	bl ov14_021F3210
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xe
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xb
	bl sub_020199E4
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xb
	bl sub_020199E4
	cmp r4, #1
	bne _021E9362
	cmp r0, #0
	bne _021E9362
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
_021E9362:
	ldr r1, [r5, #0x34]
	ldrh r0, [r1, #0x12]
	add r0, r0, #1
	strh r0, [r1, #0x12]
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E92AC

	thumb_func_start ov14_021E9370
ov14_021E9370: ; 0x021E9370
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r1, [r5, #0x34]
	ldrh r0, [r1, #0x12]
	cmp r0, #0x17
	bne _021E939C
	ldr r0, [r1, #0x2c]
	bl GridInputHandler_IsButtonInputMode
	cmp r0, #1
	bne _021E9390
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
_021E9390:
	ldr r1, [r5, #0x34]
	mov r0, #0
	strh r0, [r1, #0x12]
	ldr r1, [r5, #0x34]
	strh r0, [r1, #0x10]
	pop {r3, r4, r5, pc}
_021E939C:
	ldr r0, [r1, #0x14]
	mov r1, #3
	mov r2, #1
	mov r3, #8
	bl ScheduleSetBgPosText
	mov r1, #7
	add r0, r5, #0
	mvn r1, r1
	bl ov14_021F3210
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xe
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xb
	bl sub_020199E4
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xb
	bl sub_020199E4
	cmp r4, #1
	bne _021E9428
	cmp r0, #0
	bne _021E9428
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
_021E9428:
	ldr r1, [r5, #0x34]
	ldrh r0, [r1, #0x12]
	add r0, r0, #1
	strh r0, [r1, #0x12]
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E9370

	thumb_func_start ov14_021E9434
ov14_021E9434: ; 0x021E9434
	push {r3, lr}
	ldr r1, [r0, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	cmp r0, #0
	beq _021E944A
	mov r0, #1
	pop {r3, pc}
_021E944A:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E9434

	thumb_func_start ov14_021E9450
ov14_021E9450: ; 0x021E9450
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	add r7, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r4, #0
	bne _021E94A4
	cmp r6, #0
	bne _021E94A4
	cmp r7, #0
	bne _021E94A4
	cmp r0, #0
	bne _021E94A4
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E94A4:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021E9450

	thumb_func_start ov14_021E94A8
ov14_021E94A8: ; 0x021E94A8
	ldr r1, [r0, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r3, _021E94B8 ; =sub_02019978
	mov r1, #2
	bx r3
	nop
_021E94B8: .word sub_02019978
	thumb_func_end ov14_021E94A8

	thumb_func_start ov14_021E94BC
ov14_021E94BC: ; 0x021E94BC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_02019978
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	add r7, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xb
	bl sub_02019978
	cmp r4, #0
	bne _021E9512
	cmp r6, #0
	bne _021E9512
	cmp r7, #0
	bne _021E9512
	cmp r0, #0
	bne _021E9512
	mov r0, #0
	pop {r3, r4, r5, r6, r7, pc}
_021E9512:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021E94BC

	thumb_func_start ov14_021E9518
ov14_021E9518: ; 0x021E9518
	push {r3, lr}
	bl ov14_021E80A8
	cmp r0, #0
	beq _021E9526
	mov r0, #1
	pop {r3, pc}
_021E9526:
	mov r0, #0
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021E9518

	thumb_func_start ov14_021E952C
ov14_021E952C: ; 0x021E952C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E80A8
	cmp r0, #0
	bne _021E953C
	mov r0, #0
	pop {r4, pc}
_021E953C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov14_021E952C

	thumb_func_start ov14_021E954C
ov14_021E954C: ; 0x021E954C
	ldr r3, _021E9550 ; =ov14_021E9518
	bx r3
	.balign 4, 0
_021E9550: .word ov14_021E9518
	thumb_func_end ov14_021E954C

	thumb_func_start ov14_021E9554
ov14_021E9554: ; 0x021E9554
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl sub_02019978
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xf
	bl sub_02019978
	add r6, r0, #0
	add r0, r5, #0
	mov r1, #8
	bl ov14_021F47B8
	cmp r4, #0
	bne _021E958C
	cmp r6, #0
	bne _021E958C
	mov r0, #0
	pop {r4, r5, r6, pc}
_021E958C:
	mov r0, #1
	pop {r4, r5, r6, pc}
	thumb_func_end ov14_021E9554

	thumb_func_start ov14_021E9590
ov14_021E9590: ; 0x021E9590
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0
	bl sub_02019978
	mov r1, #7
	add r5, r0, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F47B8
	add r0, r5, #0
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E9590

	thumb_func_start ov14_021E95B4
ov14_021E95B4: ; 0x021E95B4
	ldr r1, [r0, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r3, _021E95C4 ; =sub_02019978
	mov r1, #0xa
	bx r3
	nop
_021E95C4: .word sub_02019978
	thumb_func_end ov14_021E95B4

	thumb_func_start ov14_021E95C8
ov14_021E95C8: ; 0x021E95C8
	push {r4, lr}
	ldr r4, [r0, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021E95D8
	cmp r1, #1
	beq _021E95E8
	b _021E95FE
_021E95D8:
	bl ov14_021E9434
	cmp r0, #0
	bne _021E95FE
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021E95FE
_021E95E8:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xc
	bl sub_02019978
	cmp r0, #0
	bne _021E95FE
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r4, pc}
_021E95FE:
	mov r0, #1
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E95C8

	thumb_func_start ov14_021E9604
ov14_021E9604: ; 0x021E9604
	ldr r1, [r0, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r3, _021E9614 ; =sub_02019978
	mov r1, #0xc
	bx r3
	nop
_021E9614: .word sub_02019978
	thumb_func_end ov14_021E9604

	thumb_func_start ov14_021E9618
ov14_021E9618: ; 0x021E9618
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xc
	bl sub_02019978
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #6
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #7
	bl sub_02019978
	cmp r4, #0
	bne _021E965A
	cmp r6, #0
	bne _021E965A
	cmp r0, #0
	bne _021E965A
	mov r0, #0
	pop {r4, r5, r6, pc}
_021E965A:
	mov r0, #1
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021E9618

	thumb_func_start ov14_021E9660
ov14_021E9660: ; 0x021E9660
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021E9672
	cmp r1, #1
	beq _021E9682
	b _021E96A2
_021E9672:
	bl ov14_021E9618
	cmp r0, #0
	bne _021E96A2
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021E96A2
_021E9682:
	add r0, r4, #0
	mov r1, #8
	bl ov14_021F44B4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xd
	bl sub_02019978
	cmp r0, #0
	bne _021E96A2
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021E96A2:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E9660

	thumb_func_start ov14_021E96A8
ov14_021E96A8: ; 0x021E96A8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #7
	ldr r0, [r4, #0x34]
	mvn r1, r1
	bl ov14_021F44B4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xd
	bl sub_02019978
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021E96A8

	thumb_func_start ov14_021E96C8
ov14_021E96C8: ; 0x021E96C8
	push {r3, r4, r5, r6, lr}
	sub sp, #0x1c
	add r4, r0, #0
	mov r0, #0x2f
	ldr r6, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r6, r0]
	mov r1, #0
	bl sub_02019B08
	add r5, r0, #0
	ldrh r0, [r6, #0x10]
	cmp r0, #0xa
	bls _021E96E6
	b _021E988A
_021E96E6:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E96F2: ; jump table
	.short _021E9708 - _021E96F2 - 2 ; case 0
	.short _021E972E - _021E96F2 - 2 ; case 1
	.short _021E9776 - _021E96F2 - 2 ; case 2
	.short _021E97DA - _021E96F2 - 2 ; case 3
	.short _021E97FC - _021E96F2 - 2 ; case 4
	.short _021E9844 - _021E96F2 - 2 ; case 5
	.short _021E988A - _021E96F2 - 2 ; case 6
	.short _021E988A - _021E96F2 - 2 ; case 7
	.short _021E988A - _021E96F2 - 2 ; case 8
	.short _021E988A - _021E96F2 - 2 ; case 9
	.short _021E97BC - _021E96F2 - 2 ; case 10
_021E9708:
	mov r2, #0x20
	str r2, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	mov r0, #3
	str r0, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #9
	bl CopyToBgTilemapRect
	b _021E988A
_021E972E:
	mov r2, #0x20
	str r2, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #8
	bl CopyToBgTilemapRect
	mov r2, #0x20
	str r2, [sp]
	mov r0, #1
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	mov r0, #6
	str r0, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #0xa
	bl CopyToBgTilemapRect
	b _021E988A
_021E9776:
	mov r2, #0x20
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r3, #7
	str r3, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	bl CopyToBgTilemapRect
	mov r2, #0x20
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	mov r0, #5
	str r0, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #0xa
	bl CopyToBgTilemapRect
	b _021E988A
_021E97BC:
	mov r0, #4
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #0xb
	str r0, [sp, #8]
	mov r1, #0
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	add r3, r1, #0
	bl FillBgTilemapRect
_021E97DA:
	mov r2, #0x20
	str r2, [sp]
	mov r0, #7
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r2, [sp, #0x14]
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #6
	bl CopyToBgTilemapRect
	b _021E988A
_021E97FC:
	mov r2, #0x20
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #5
	bl CopyToBgTilemapRect
	mov r2, #0x20
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	mov r0, #5
	str r0, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #0xc
	bl CopyToBgTilemapRect
	b _021E988A
_021E9844:
	mov r2, #0x20
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	str r1, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #4
	bl CopyToBgTilemapRect
	mov r2, #0x20
	str r2, [sp]
	mov r0, #2
	str r0, [sp, #4]
	str r5, [sp, #8]
	mov r1, #0
	str r1, [sp, #0xc]
	mov r0, #5
	str r0, [sp, #0x10]
	str r2, [sp, #0x14]
	mov r0, #7
	str r0, [sp, #0x18]
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	mov r3, #0xd
	bl CopyToBgTilemapRect
_021E988A:
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x14]
	bl ScheduleBgTilemapBufferTransfer
	ldrh r0, [r6, #0x10]
	cmp r0, #0xa
	bne _021E98A2
	mov r0, #0
	add sp, #0x1c
	strh r0, [r6, #0x10]
	pop {r3, r4, r5, r6, pc}
_021E98A2:
	add r0, r0, #1
	strh r0, [r6, #0x10]
	mov r0, #1
	add sp, #0x1c
	pop {r3, r4, r5, r6, pc}
	thumb_func_end ov14_021E96C8

	thumb_func_start ov14_021E98AC
ov14_021E98AC: ; 0x021E98AC
	push {r3, r4, r5, lr}
	sub sp, #0x10
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	mov r1, #0
	ldrh r0, [r4, #0x10]
	add r2, r1, #0
	add r3, r1, #0
	add r0, r0, #6
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x14]
	bl FillBgTilemapRect
	ldrh r1, [r4, #0x10]
	mov r0, #0xc
	sub r0, r0, r1
	mov r1, #0
	lsl r0, r0, #0x18
	lsr r0, r0, #0x18
	str r0, [sp]
	mov r0, #0x20
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	mov r0, #0x10
	str r0, [sp, #0xc]
	ldr r0, [r5, #0x34]
	add r2, r1, #0
	ldr r0, [r0, #0x14]
	add r3, r1, #0
	bl FillBgTilemapRect
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x14]
	bl ScheduleBgTilemapBufferTransfer
	ldrh r0, [r4, #0x10]
	cmp r0, #3
	bne _021E9914
	mov r0, #0
	add sp, #0x10
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021E9914:
	add r0, r0, #1
	strh r0, [r4, #0x10]
	mov r0, #1
	add sp, #0x10
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E98AC

	thumb_func_start ov14_021E9920
ov14_021E9920: ; 0x021E9920
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021E9932
	cmp r0, #1
	beq _021E9956
	b _021E996C
_021E9932:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xf
	bl sub_02019978
	cmp r0, #0
	bne _021E996C
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85BC
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021E996C
_021E9956:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xe
	bl sub_02019978
	cmp r0, #0
	bne _021E996C
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021E996C:
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E9920

	thumb_func_start ov14_021E9970
ov14_021E9970: ; 0x021E9970
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xf
	bl sub_02019978
	cmp r0, #0
	bne _021E999C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xe
	bl sub_02019978
	cmp r0, #0
	bne _021E999C
	mov r0, #0
	pop {r4, pc}
_021E999C:
	mov r0, #1
	pop {r4, pc}
	thumb_func_end ov14_021E9970

	thumb_func_start ov14_021E99A0
ov14_021E99A0: ; 0x021E99A0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021E99B2
	cmp r0, #1
	beq _021E99D6
	b _021E99EC
_021E99B2:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xe
	bl sub_02019978
	cmp r0, #0
	bne _021E99EC
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021E99EC
_021E99D6:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xf
	bl sub_02019978
	cmp r0, #0
	bne _021E99EC
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021E99EC:
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021E99A0

	thumb_func_start ov14_021E99F0
ov14_021E99F0: ; 0x021E99F0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xc
	bl sub_02019978
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r4, #0
	bne _021E9A1E
	cmp r0, #0
	bne _021E9A1E
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E9A1E:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021E99F0

	thumb_func_start ov14_021E9A24
ov14_021E9A24: ; 0x021E9A24
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	ldr r5, [r4, #0x34]
	ldrh r0, [r5, #0x10]
	cmp r0, #1
	bhi _021E9A52
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	add r2, sp, #4
	add r1, r5, r0
	ldr r0, _021E9C78 ; =0x00004094
	ldrb r0, [r1, r0]
	lsl r0, r0, #2
	add r1, r5, r0
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #4
	add r1, #2
	bl ManagedSprite_GetPositionXY
_021E9A52:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	add r7, r0, #0
	add r0, r4, #0
	bl ov14_021E813C
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	str r0, [sp]
	ldrh r0, [r5, #0x10]
	cmp r0, #7
	bls _021E9A80
	b _021E9C70
_021E9A80:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E9A8C: ; jump table
	.short _021E9A9C - _021E9A8C - 2 ; case 0
	.short _021E9AA0 - _021E9A8C - 2 ; case 1
	.short _021E9BE2 - _021E9A8C - 2 ; case 2
	.short _021E9BE2 - _021E9A8C - 2 ; case 3
	.short _021E9BE2 - _021E9A8C - 2 ; case 4
	.short _021E9C14 - _021E9A8C - 2 ; case 5
	.short _021E9C44 - _021E9A8C - 2 ; case 6
	.short _021E9C4E - _021E9A8C - 2 ; case 7
_021E9A9C:
	mov r0, #1
	strh r0, [r5, #0x10]
_021E9AA0:
	ldr r0, [r4, #0x34]
	ldr r1, _021E9C7C ; =0x0000044A
	ldrb r2, [r0, r1]
	cmp r2, #1
	bne _021E9ABA
	cmp r6, #0
	bne _021E9ABA
	mov r2, #2
	strb r2, [r0, r1]
	add r0, r4, #0
	mov r1, #0x28
	bl ov14_021F69F0
_021E9ABA:
	add r0, sp, #0xc
	add r1, sp, #8
	bl System_GetTouchHeldCoords
	cmp r0, #0
	ldr r0, [r4, #0x34]
	bne _021E9B68
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r3, sp, #4
	add r2, r0, r1
	ldr r1, _021E9C78 ; =0x00004094
	ldrb r1, [r2, r1]
	mov r2, #0
	ldrsh r2, [r3, r2]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	ldrsh r1, [r3, r1]
	bl ManagedSprite_SetPositionXY
	ldr r1, [r4, #0x34]
	ldr r0, _021E9C7C ; =0x0000044A
	mov r2, #0xff
	ldrb r0, [r1, r0]
	cmp r0, #2
	bne _021E9B0E
	ldr r2, _021E9C80 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E7960
	add r2, r0, #0
_021E9B0E:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E6F3C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E70B0
	add r1, r4, #0
	add r1, #0x21
	strb r0, [r1]
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021E9B44
	mov r0, #5
	strh r0, [r5, #0x10]
	b _021E9C70
_021E9B44:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7FEC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	mov r0, #2
	strh r0, [r5, #0x10]
	b _021E9C70
_021E9B68:
	ldr r1, _021E9C7C ; =0x0000044A
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021E9B9C
	cmp r7, #0
	bne _021E9B9C
	ldr r1, [sp]
	cmp r1, #0
	bne _021E9B9C
	ldr r2, [sp, #0xc]
	cmp r2, #0x10
	blo _021E9B8A
	ldr r1, [sp, #8]
	cmp r1, #0x30
	blo _021E9B8A
	cmp r2, #0x68
	blo _021E9B9C
_021E9B8A:
	ldr r1, _021E9C7C ; =0x0000044A
	mov r2, #1
	strb r2, [r0, r1]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7FB8
_021E9B9C:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	add r2, r0, r1
	ldr r1, _021E9C78 ; =0x00004094
	ldrb r1, [r2, r1]
	ldr r2, [sp, #8]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	lsl r2, r2, #0x10
	ldr r0, [r1, r0]
	ldr r1, [sp, #0xc]
	asr r2, r2, #0x10
	sub r2, #8
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	bl ov14_021F4174
	ldr r2, [sp, #0xc]
	ldr r1, [r4, #0x34]
	ldr r0, _021E9C80 ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp, #8]
	ldr r1, [r4, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021E9C70
_021E9BE2:
	add r0, r4, #0
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E9C70
	cmp r6, #0
	bne _021E9C70
	cmp r7, #0
	bne _021E9C70
	ldr r1, [r5, #0xc]
	add r0, r4, #0
	bl ov14_021E7148
	add r0, r4, #0
	bl ov14_021F4174
	ldr r2, [r4, #0x34]
	ldr r1, _021E9C84 ; =0x000040C4
	add r0, r4, #0
	ldr r1, [r2, r1]
	bl ov14_021F40E8
	mov r0, #7
	strh r0, [r5, #0x10]
	b _021E9C70
_021E9C14:
	add r0, r4, #0
	bl ov14_021E66F4
	cmp r0, #0
	bne _021E9C70
	ldr r1, [r5, #0xc]
	add r0, r4, #0
	bl ov14_021E7148
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	mov r0, #0xff
	add r4, #0x21
	strb r0, [r4]
	mov r0, #6
	strh r0, [r5, #0x10]
	b _021E9C70
_021E9C44:
	cmp r6, #0
	bne _021E9C70
	mov r0, #7
	strh r0, [r5, #0x10]
	b _021E9C70
_021E9C4E:
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	ldr r2, [r4, #0x34]
	ldr r1, _021E9C7C ; =0x0000044A
	mov r0, #0
	strb r0, [r2, r1]
	add sp, #0x10
	strh r0, [r5, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021E9C70:
	mov r0, #1
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9C78: .word 0x00004094
_021E9C7C: .word 0x0000044A
_021E9C80: .word 0x000040B8
_021E9C84: .word 0x000040C4
	thumb_func_end ov14_021E9A24

	thumb_func_start ov14_021E9C88
ov14_021E9C88: ; 0x021E9C88
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #0x10
	add r4, r0, #0
	mov r0, #0x2f
	ldr r5, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ov14_021E8514
	str r0, [sp]
	add r0, r4, #0
	bl ov14_021E80A8
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	add r7, r0, #0
	ldrh r0, [r5, #0x10]
	cmp r0, #8
	bls _021E9CBC
	b _021E9F04
_021E9CBC:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021E9CC8: ; jump table
	.short _021E9CDA - _021E9CC8 - 2 ; case 0
	.short _021E9CDE - _021E9CC8 - 2 ; case 1
	.short _021E9E30 - _021E9CC8 - 2 ; case 2
	.short _021E9E4A - _021E9CC8 - 2 ; case 3
	.short _021E9E4A - _021E9CC8 - 2 ; case 4
	.short _021E9E8C - _021E9CC8 - 2 ; case 5
	.short _021E9EBA - _021E9CC8 - 2 ; case 6
	.short _021E9ED8 - _021E9CC8 - 2 ; case 7
	.short _021E9EE2 - _021E9CC8 - 2 ; case 8
_021E9CDA:
	mov r0, #1
	strh r0, [r5, #0x10]
_021E9CDE:
	ldr r0, [r4, #0x34]
	ldr r1, _021E9F0C ; =0x0000044A
	ldrb r2, [r0, r1]
	cmp r2, #1
	bne _021E9CF8
	cmp r6, #0
	bne _021E9CF8
	mov r2, #2
	strb r2, [r0, r1]
	add r0, r4, #0
	mov r1, #0x28
	bl ov14_021F69F0
_021E9CF8:
	add r0, sp, #0xc
	add r1, sp, #8
	bl System_GetTouchHeldCoords
	cmp r0, #0
	ldr r0, _021E9F0C ; =0x0000044A
	bne _021E9D78
	ldr r1, [r4, #0x34]
	mov r2, #0xff
	ldrb r0, [r1, r0]
	cmp r0, #2
	bne _021E9D28
	ldr r2, _021E9F10 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	ldr r2, _021E9F14 ; =ov14_021F7C08
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E79AC
	add r2, r0, #0
_021E9D28:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E7034
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E70B0
	add r1, r4, #0
	add r1, #0x21
	strb r0, [r1]
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021E9D5E
	mov r0, #5
	strh r0, [r5, #0x10]
	b _021E9F04
_021E9D5E:
	ldr r1, [r4, #0x34]
	ldr r0, _021E9F0C ; =0x0000044A
	ldrb r0, [r1, r0]
	cmp r0, #0
	beq _021E9D72
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
_021E9D72:
	mov r0, #2
	strh r0, [r5, #0x10]
	b _021E9F04
_021E9D78:
	ldr r1, [r4, #0x34]
	ldrb r0, [r1, r0]
	cmp r0, #0
	bne _021E9DEA
	ldr r0, [sp]
	cmp r0, #0
	bne _021E9DEA
	cmp r7, #0
	bne _021E9DEA
	add r0, r4, #0
	add r3, r4, #0
	add r0, #0x21
	add r3, #0x22
	add r1, sp, #4
	ldrb r0, [r0]
	ldrb r3, [r3]
	add r1, #2
	add r2, sp, #4
	bl ov14_021F2F88
	add r1, sp, #4
	mov r0, #2
	ldrsh r3, [r1, r0]
	ldr r2, [sp, #0xc]
	add r0, r3, #0
	sub r0, #0x10
	cmp r2, r0
	blo _021E9DCA
	add r3, #0x10
	cmp r2, r3
	bhs _021E9DCA
	mov r0, #0
	ldrsh r2, [r1, r0]
	ldr r1, [sp, #8]
	add r0, r2, #0
	sub r0, #0x10
	cmp r1, r0
	blo _021E9DCA
	add r2, #0x10
	cmp r1, r2
	blo _021E9DEA
_021E9DCA:
	ldr r1, [r4, #0x34]
	ldr r0, _021E9F0C ; =0x0000044A
	mov r2, #1
	strb r2, [r1, r0]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7ED0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
_021E9DEA:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	add r2, r0, r1
	ldr r1, _021E9F18 ; =0x00004094
	ldrb r1, [r2, r1]
	ldr r2, [sp, #8]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	lsl r2, r2, #0x10
	ldr r0, [r1, r0]
	ldr r1, [sp, #0xc]
	asr r2, r2, #0x10
	sub r2, #8
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	bl ov14_021F4174
	ldr r2, [sp, #0xc]
	ldr r1, [r4, #0x34]
	ldr r0, _021E9F10 ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp, #8]
	ldr r1, [r4, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021E9F04
_021E9E30:
	cmp r6, #0
	bne _021E9E4A
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	mov r0, #3
	strh r0, [r5, #0x10]
_021E9E4A:
	add r0, r4, #0
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E9E80
	ldrh r0, [r5, #0x10]
	cmp r0, #4
	bne _021E9E80
	ldr r0, [sp]
	cmp r0, #0
	bne _021E9E80
	ldr r1, [r5, #0xc]
	add r0, r4, #0
	bl ov14_021E7148
	add r0, r4, #0
	bl ov14_021F4174
	ldr r2, [r4, #0x34]
	ldr r1, _021E9F1C ; =0x000040C4
	add r0, r4, #0
	ldr r1, [r2, r1]
	bl ov14_021F40E8
	mov r0, #8
	strh r0, [r5, #0x10]
	b _021E9F04
_021E9E80:
	ldrh r0, [r5, #0x10]
	cmp r0, #3
	bne _021E9F04
	mov r0, #4
	strh r0, [r5, #0x10]
	b _021E9F04
_021E9E8C:
	add r0, r4, #0
	bl ov14_021E65C4
	cmp r0, #0
	bne _021E9F04
	ldr r1, [r5, #0xc]
	add r0, r4, #0
	bl ov14_021E7148
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
	ldrh r0, [r5, #0x10]
	add r0, r0, #1
	strh r0, [r5, #0x10]
	b _021E9F04
_021E9EBA:
	cmp r6, #0
	bne _021E9F04
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldrh r0, [r5, #0x10]
	add r0, r0, #1
	strh r0, [r5, #0x10]
	b _021E9F04
_021E9ED8:
	cmp r7, #0
	bne _021E9F04
	mov r0, #8
	strh r0, [r5, #0x10]
	b _021E9F04
_021E9EE2:
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	ldr r2, [r4, #0x34]
	ldr r1, _021E9F0C ; =0x0000044A
	mov r0, #0
	strb r0, [r2, r1]
	add sp, #0x10
	strh r0, [r5, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021E9F04:
	mov r0, #1
	add sp, #0x10
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021E9F0C: .word 0x0000044A
_021E9F10: .word 0x000040B8
_021E9F14: .word ov14_021F7C08
_021E9F18: .word 0x00004094
_021E9F1C: .word 0x000040C4
	thumb_func_end ov14_021E9C88

	thumb_func_start ov14_021E9F20
ov14_021E9F20: ; 0x021E9F20
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r1, [r5, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r4, [r1, #0xc]
	ldr r0, [r1, r0]
	mov r1, #0xf
	bl sub_02019978
	ldr r1, [r4, #4]
	lsr r2, r1, #2
	bne _021E9F98
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldrb r1, [r4]
	ldrb r2, [r4, #1]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	ldr r1, _021EA060 ; =0x0000044B
	ldrb r1, [r0, r1]
	cmp r1, #1
	bne _021E9F94
	ldr r1, [r5]
	ldr r1, [r1, #8]
	cmp r1, #3
	bne _021E9F72
	ldrb r2, [r4, #1]
	mov r1, #0xca
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	add r2, #8
	lsl r2, r2, #0x10
	ldrb r1, [r4]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	b _021E9F94
_021E9F72:
	add r5, #0x21
	ldrb r1, [r5]
	add r2, r0, r1
	ldr r1, _021EA064 ; =0x00004094
	ldrb r1, [r2, r1]
	ldrb r2, [r4, #1]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r2, r2, #4
	lsl r2, r2, #0x10
	ldrb r1, [r4]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
_021E9F94:
	mov r0, #0
	pop {r3, r4, r5, pc}
_021E9F98:
	mov r0, #3
	and r1, r0
	sub r0, r2, #1
	lsl r0, r0, #2
	orr r0, r1
	str r0, [r4, #4]
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	ldr r0, [r4, #4]
	add r1, sp, #0
	lsl r0, r0, #0x1f
	lsr r0, r0, #0x1f
	bne _021E9FCA
	mov r0, #2
	ldrsh r2, [r1, r0]
	ldrb r0, [r4, #2]
	add r0, r2, r0
	b _021E9FD2
_021E9FCA:
	mov r0, #2
	ldrsh r2, [r1, r0]
	ldrb r0, [r4, #2]
	sub r0, r2, r0
_021E9FD2:
	strh r0, [r1, #2]
	ldr r0, [r4, #4]
	add r1, sp, #0
	lsl r0, r0, #0x1e
	lsr r0, r0, #0x1f
	bne _021E9FE8
	mov r0, #0
	ldrsh r2, [r1, r0]
	ldrb r0, [r4, #3]
	add r0, r2, r0
	b _021E9FF0
_021E9FE8:
	mov r0, #0
	ldrsh r2, [r1, r0]
	ldrb r0, [r4, #3]
	sub r0, r2, r0
_021E9FF0:
	strh r0, [r1]
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r3, sp, #0
	mov r1, #2
	mov r2, #0
	ldrsh r1, [r3, r1]
	ldrsh r2, [r3, r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	ldr r1, _021EA060 ; =0x0000044B
	ldrb r1, [r0, r1]
	cmp r1, #1
	bne _021EA05C
	ldr r1, [r5]
	add r3, sp, #0
	ldr r1, [r1, #8]
	cmp r1, #3
	bne _021EA036
	mov r2, #0
	mov r1, #0xca
	ldrsh r2, [r3, r2]
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	mov r1, #2
	add r2, #8
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	b _021EA05C
_021EA036:
	add r5, #0x21
	ldrb r1, [r5]
	add r2, r0, r1
	ldr r1, _021EA064 ; =0x00004094
	ldrb r1, [r2, r1]
	mov r2, #0
	ldrsh r2, [r3, r2]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	add r2, r2, #4
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
_021EA05C:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EA060: .word 0x0000044B
_021EA064: .word 0x00004094
	thumb_func_end ov14_021E9F20

	thumb_func_start ov14_021EA068
ov14_021EA068: ; 0x021EA068
	push {r4, r5, r6, lr}
	add r6, r0, #0
	ldr r5, [r6, #0x34]
	ldrh r0, [r5, #0x10]
	cmp r0, #0
	beq _021EA07A
	cmp r0, #1
	beq _021EA092
	b _021EA0B2
_021EA07A:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r0, #0
	bne _021EA0B2
	ldrh r0, [r5, #0x10]
	add r0, r0, #1
	strh r0, [r5, #0x10]
	b _021EA0B2
_021EA092:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ov14_021E8514
	add r4, r0, #0
	add r0, r6, #0
	bl ov14_021E9F20
	cmp r4, #0
	bne _021EA0B2
	cmp r0, #0
	bne _021EA0B2
	mov r0, #0
	strh r0, [r5, #0x10]
	pop {r4, r5, r6, pc}
_021EA0B2:
	mov r0, #1
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021EA068

	thumb_func_start ov14_021EA0B8
ov14_021EA0B8: ; 0x021EA0B8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021EA0CA
	cmp r1, #1
	beq _021EA10A
	b _021EA12A
_021EA0CA:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #8
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	add r7, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r6, #0
	bne _021EA12A
	cmp r7, #0
	bne _021EA12A
	cmp r0, #0
	bne _021EA12A
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EA12A
_021EA10A:
	bl ov14_021E9F20
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	cmp r6, #0
	bne _021EA12A
	cmp r0, #0
	bne _021EA12A
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021EA12A:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov14_021EA0B8

	thumb_func_start ov14_021EA130
ov14_021EA130: ; 0x021EA130
	push {r4, r5, r6, lr}
	add r6, r0, #0
	ldr r5, [r6, #0x34]
	ldrh r0, [r5, #0x10]
	cmp r0, #0
	beq _021EA142
	cmp r0, #1
	beq _021EA164
	b _021EA17A
_021EA142:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ov14_021E8514
	add r4, r0, #0
	add r0, r6, #0
	bl ov14_021E9F20
	cmp r4, #0
	bne _021EA17A
	cmp r0, #0
	bne _021EA17A
	ldrh r0, [r5, #0x10]
	add r0, r0, #1
	strh r0, [r5, #0x10]
	b _021EA17A
_021EA164:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r0, #0
	bne _021EA17A
	mov r0, #0
	strh r0, [r5, #0x10]
	pop {r4, r5, r6, pc}
_021EA17A:
	mov r0, #1
	pop {r4, r5, r6, pc}
	.balign 4, 0
	thumb_func_end ov14_021EA130

	thumb_func_start ov14_021EA180
ov14_021EA180: ; 0x021EA180
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021EA192
	cmp r1, #1
	beq _021EA1AE
	b _021EA1EC
_021EA192:
	bl ov14_021E9F20
	add r6, r0, #0
	add r0, r5, #0
	bl ov14_021E9434
	cmp r6, #0
	bne _021EA1EC
	cmp r0, #0
	bne _021EA1EC
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EA1EC
_021EA1AE:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #8
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	add r7, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r6, #0
	bne _021EA1EC
	cmp r7, #0
	bne _021EA1EC
	cmp r0, #0
	bne _021EA1EC
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021EA1EC:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	thumb_func_end ov14_021EA180

	thumb_func_start ov14_021EA1F0
ov14_021EA1F0: ; 0x021EA1F0
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0xa
	bl ov14_021F29E4
	mov r0, #0x32
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	add r3, sp, #0
	add r2, r0, r1
	ldr r1, _021EA250 ; =0x00004094
	ldrb r1, [r2, r1]
	mov r2, #0
	ldrsh r2, [r3, r2]
	lsl r1, r1, #2
	add r1, r0, r1
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	add r2, r2, #4
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldr r0, [r4, #0x34]
	add r4, #0x21
	ldrb r1, [r4]
	mov r2, #0
	bl ov14_021F3190
	add sp, #4
	pop {r3, r4, pc}
	nop
_021EA250: .word 0x00004094
	thumb_func_end ov14_021EA1F0

	thumb_func_start ov14_021EA254
ov14_021EA254: ; 0x021EA254
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	mov r0, #0x2f
	ldr r4, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xf
	bl sub_02019978
	ldrh r0, [r4, #0x10]
	cmp r0, #3
	bhi _021EA36E
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EA27A: ; jump table
	.short _021EA282 - _021EA27A - 2 ; case 0
	.short _021EA292 - _021EA27A - 2 ; case 1
	.short _021EA2DA - _021EA27A - 2 ; case 2
	.short _021EA2EA - _021EA27A - 2 ; case 3
_021EA282:
	mov r1, #9
	ldr r0, [r5, #0x34]
	add r2, r1, #0
	bl ov14_021F29E4
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021EA292:
	ldrh r0, [r4, #0x12]
	cmp r0, #4
	bne _021EA2A4
	mov r0, #0
	strh r0, [r4, #0x12]
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EA36E
_021EA2A4:
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0x32
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	add r2, r2, #2
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldrh r0, [r4, #0x12]
	add r0, r0, #1
	strh r0, [r4, #0x12]
	b _021EA36E
_021EA2DA:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xa
	bl ov14_021F29E4
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021EA2EA:
	ldrh r0, [r4, #0x12]
	cmp r0, #4
	bne _021EA2FA
	mov r0, #0
	strh r0, [r4, #0x12]
	add sp, #4
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, r6, pc}
_021EA2FA:
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0x32
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	sub r2, r2, #2
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	add r2, r0, r1
	ldr r1, _021EA374 ; =0x00004094
	ldrb r1, [r2, r1]
	add r2, sp, #0
	lsl r6, r1, #2
	add r1, r0, r6
	mov r0, #0xbf
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	bl ManagedSprite_GetPositionXY
	ldr r0, [r5, #0x34]
	add r3, sp, #0
	mov r2, #0
	add r1, r0, r6
	mov r0, #0xbf
	ldrsh r2, [r3, r2]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	sub r2, r2, #2
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldrh r0, [r4, #0x12]
	add r0, r0, #1
	strh r0, [r4, #0x12]
_021EA36E:
	mov r0, #1
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EA374: .word 0x00004094
	thumb_func_end ov14_021EA254

	thumb_func_start ov14_021EA378
ov14_021EA378: ; 0x021EA378
	push {r4, r5, r6, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r4, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xf
	bl sub_02019978
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021EA396
	cmp r0, #1
	beq _021EA3DC
	b _021EA3FE
_021EA396:
	mov r1, #9
	ldr r0, [r5, #0x34]
	add r2, r1, #0
	bl ov14_021F29E4
	ldr r1, [r5, #0x34]
	ldr r0, _021EA404 ; =0x0000044C
	ldrb r6, [r1, r0]
	cmp r6, #0x25
	blo _021EA3B0
	cmp r6, #0x2a
	bhi _021EA3B0
	add r6, #0x5b
_021EA3B0:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	add r2, r6, #0
	bl ov14_021E6CF8
	mov r0, #0x80
	tst r0, r6
	bne _021EA3D6
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E70B0
	add r1, r5, #0
	add r1, #0x21
	strb r0, [r1]
_021EA3D6:
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021EA3DC:
	add r0, r5, #0
	bl ov14_021E65C4
	cmp r0, #0
	bne _021EA3FE
	ldr r1, [r4, #0xc]
	add r0, r5, #0
	bl ov14_021E7148
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r4, r5, r6, pc}
_021EA3FE:
	mov r0, #1
	pop {r4, r5, r6, pc}
	nop
_021EA404: .word 0x0000044C
	thumb_func_end ov14_021EA378

	thumb_func_start ov14_021EA408
ov14_021EA408: ; 0x021EA408
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021EA41E
	cmp r1, #1
	beq _021EA448
	cmp r1, #2
	beq _021EA48A
	b _021EA4C0
_021EA41E:
	ldr r0, _021EA4C4 ; =0x000088C8
	ldrh r0, [r4, r0]
	cmp r0, #0
	beq _021EA442
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
_021EA442:
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021EA448:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	add r7, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r6, #0
	bne _021EA4C0
	cmp r7, #0
	bne _021EA4C0
	cmp r0, #0
	bne _021EA4C0
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EA4C0
_021EA48A:
	bl ov14_021E9F20
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8514
	cmp r6, #0
	bne _021EA4C0
	cmp r0, #0
	bne _021EA4C0
	ldr r0, [r5, #0x34]
	ldr r1, _021EA4C4 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021EA4BA
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	bl ov14_021F3B3C
_021EA4BA:
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021EA4C0:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EA4C4: .word 0x000088C8
	thumb_func_end ov14_021EA408

	thumb_func_start ov14_021EA4C8
ov14_021EA4C8: ; 0x021EA4C8
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r4, r0, #0
	mov r0, #0x2f
	ldr r5, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ov14_021E8514
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #8
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	ldrh r0, [r5, #0x10]
	cmp r0, #0xa
	bls _021EA50E
	b _021EA664
_021EA50E:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EA51A: ; jump table
	.short _021EA530 - _021EA51A - 2 ; case 0
	.short _021EA56A - _021EA51A - 2 ; case 1
	.short _021EA588 - _021EA51A - 2 ; case 2
	.short _021EA632 - _021EA51A - 2 ; case 3
	.short _021EA664 - _021EA51A - 2 ; case 4
	.short _021EA664 - _021EA51A - 2 ; case 5
	.short _021EA664 - _021EA51A - 2 ; case 6
	.short _021EA664 - _021EA51A - 2 ; case 7
	.short _021EA664 - _021EA51A - 2 ; case 8
	.short _021EA664 - _021EA51A - 2 ; case 9
	.short _021EA642 - _021EA51A - 2 ; case 10
_021EA530:
	ldr r0, [r4, #0x34]
	ldr r1, _021EA66C ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021EA55A
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #1
	strh r0, [r5, #0x10]
	b _021EA664
_021EA55A:
	mov r1, #0x2f
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	bl ov14_021E8434
	mov r0, #0xa
	strh r0, [r5, #0x10]
	b _021EA664
_021EA56A:
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	beq _021EA664
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B3C
	mov r0, #2
	strh r0, [r5, #0x10]
_021EA588:
	add r0, sp, #4
	add r1, sp, #0
	bl System_GetTouchHeldCoords
	cmp r0, #0
	bne _021EA608
	ldr r1, [r4, #0x34]
	ldr r2, _021EA670 ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E7960
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	add r7, r6, #0
	cmp r6, #0xff
	bne _021EA5BC
	add r0, r4, #0
	add r0, #0x21
	ldrb r6, [r0]
	b _021EA5D4
_021EA5BC:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	add r2, r6, #0
	bl ov14_021E6AA0
	cmp r0, #0
	bne _021EA5D4
	add r0, r4, #0
	add r0, #0x21
	ldrb r6, [r0]
_021EA5D4:
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r6, r0
	ldr r1, [r4, #0x34]
	bne _021EA5EC
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	b _021EA5F6
_021EA5EC:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EA5F6:
	add r0, r4, #0
	add r1, r7, #0
	add r2, r6, #0
	mov r3, #2
	bl ov14_021E7AD4
	mov r0, #3
	strh r0, [r5, #0x10]
	b _021EA664
_021EA608:
	ldr r1, [sp, #4]
	ldr r2, [sp]
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r4, #0x34]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ov14_021F395C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B5C
	ldr r2, [sp, #4]
	ldr r1, [r4, #0x34]
	ldr r0, _021EA670 ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp]
	ldr r1, [r4, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021EA664
_021EA632:
	add r0, r4, #0
	bl ov14_021E7B8C
	cmp r0, #0
	bne _021EA664
	mov r0, #0xa
	strh r0, [r5, #0x10]
	b _021EA664
_021EA642:
	cmp r6, #0
	bne _021EA664
	ldr r0, [r4, #0x34]
	ldr r1, _021EA66C ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021EA65C
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B3C
_021EA65C:
	mov r0, #0
	add sp, #8
	strh r0, [r5, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021EA664:
	mov r0, #1
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EA66C: .word 0x000088C8
_021EA670: .word 0x000040B8
	thumb_func_end ov14_021EA4C8

	thumb_func_start ov14_021EA674
ov14_021EA674: ; 0x021EA674
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021EA68A
	cmp r0, #1
	beq _021EA6AA
	cmp r0, #2
	beq _021EA6C8
	b _021EA720
_021EA68A:
	ldr r0, _021EA724 ; =0x000088C8
	ldrh r0, [r4, r0]
	cmp r0, #0
	beq _021EA6A4
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
_021EA6A4:
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021EA6AA:
	add r0, r5, #0
	bl ov14_021E9F20
	add r6, r0, #0
	add r0, r5, #0
	bl ov14_021E9434
	cmp r6, #0
	bne _021EA720
	cmp r0, #0
	bne _021EA720
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EA720
_021EA6C8:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #8
	bl sub_02019978
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #9
	bl sub_02019978
	add r7, r0, #0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	cmp r6, #0
	bne _021EA720
	cmp r7, #0
	bne _021EA720
	cmp r0, #0
	bne _021EA720
	ldr r0, [r5, #0x34]
	ldr r1, _021EA724 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021EA71A
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
_021EA71A:
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021EA720:
	mov r0, #1
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EA724: .word 0x000088C8
	thumb_func_end ov14_021EA674

	thumb_func_start ov14_021EA728
ov14_021EA728: ; 0x021EA728
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #0
	beq _021EA73A
	cmp r1, #1
	beq _021EA766
	b _021EA774
_021EA73A:
	add r0, r4, #0
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	beq _021EA774
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	ldr r0, [r4, #0xc]
	mov r3, #2
	ldrh r2, [r0]
	add r0, r5, #0
	add r0, #0x21
	strb r2, [r0]
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021E7AD4
	mov r0, #1
	strh r0, [r4, #0x10]
	b _021EA774
_021EA766:
	bl ov14_021E7B8C
	cmp r0, #0
	bne _021EA774
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021EA774:
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021EA728

	thumb_func_start ov14_021EA778
ov14_021EA778: ; 0x021EA778
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r4, r0, #0
	mov r0, #0x2f
	ldr r5, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xe
	bl sub_02019978
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xf
	bl sub_02019978
	ldrh r0, [r5, #0x10]
	cmp r0, #6
	bhi _021EA7E8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EA7AC: ; jump table
	.short _021EA7BA - _021EA7AC - 2 ; case 0
	.short _021EA7DC - _021EA7AC - 2 ; case 1
	.short _021EA7FE - _021EA7AC - 2 ; case 2
	.short _021EA8A6 - _021EA7AC - 2 ; case 3
	.short _021EA8C8 - _021EA7AC - 2 ; case 4
	.short _021EA8E8 - _021EA7AC - 2 ; case 5
	.short _021EA90C - _021EA7AC - 2 ; case 6
_021EA7BA:
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #1
	strh r0, [r5, #0x10]
	b _021EA914
_021EA7DC:
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	beq _021EA7EA
_021EA7E8:
	b _021EA914
_021EA7EA:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B3C
	mov r0, #2
	strh r0, [r5, #0x10]
	b _021EA914
_021EA7FE:
	add r0, sp, #4
	add r1, sp, #0
	bl System_GetTouchHeldCoords
	cmp r0, #0
	bne _021EA87C
	ldr r1, [r4, #0x34]
	ldr r2, _021EA91C ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E7960
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	cmp r6, #0xff
	bne _021EA844
	ldr r1, [r4, #0x34]
	ldr r2, _021EA91C ; =0x000040B8
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	ldr r2, _021EA920 ; =ov14_021F7C08
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E79AC
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
_021EA844:
	add r7, r6, #0
	cmp r6, #0xff
	bne _021EA852
	add r0, r4, #0
	add r0, #0x21
	ldrb r6, [r0]
	b _021EA86A
_021EA852:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	add r2, r6, #0
	bl ov14_021E6AA0
	cmp r0, #0
	bne _021EA86A
	add r0, r4, #0
	add r0, #0x21
	ldrb r6, [r0]
_021EA86A:
	add r0, r4, #0
	add r1, r7, #0
	add r2, r6, #0
	mov r3, #2
	bl ov14_021E7AD4
	mov r0, #3
	strh r0, [r5, #0x10]
	b _021EA914
_021EA87C:
	ldr r1, [sp, #4]
	ldr r2, [sp]
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r4, #0x34]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ov14_021F395C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B5C
	ldr r2, [sp, #4]
	ldr r1, [r4, #0x34]
	ldr r0, _021EA91C ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp]
	ldr r1, [r4, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021EA914
_021EA8A6:
	add r0, r4, #0
	bl ov14_021E7B8C
	cmp r0, #0
	bne _021EA914
	ldr r0, _021EA924 ; =0x000005EA
	bl PlaySE
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	mov r0, #4
	strh r0, [r5, #0x10]
	b _021EA914
_021EA8C8:
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	mov r0, #5
	strh r0, [r5, #0x10]
	b _021EA914
_021EA8E8:
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EA914
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	mov r0, #6
	strh r0, [r5, #0x10]
	b _021EA914
_021EA90C:
	mov r0, #0
	add sp, #8
	strh r0, [r5, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021EA914:
	mov r0, #1
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EA91C: .word 0x000040B8
_021EA920: .word ov14_021F7C08
_021EA924: .word 0x000005EA
	thumb_func_end ov14_021EA778

	thumb_func_start ov14_021EA928
ov14_021EA928: ; 0x021EA928
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r1, [r4, #0x10]
	cmp r1, #6
	bhi _021EA9FC
	add r1, r1, r1
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021EA940: ; jump table
	.short _021EA94E - _021EA940 - 2 ; case 0
	.short _021EA970 - _021EA940 - 2 ; case 1
	.short _021EA98A - _021EA940 - 2 ; case 2
	.short _021EA9A6 - _021EA940 - 2 ; case 3
	.short _021EA9BA - _021EA940 - 2 ; case 4
	.short _021EA9D2 - _021EA940 - 2 ; case 5
	.short _021EA9F6 - _021EA940 - 2 ; case 6
_021EA94E:
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #1
	strh r0, [r4, #0x10]
	b _021EA9FC
_021EA970:
	add r0, r4, #0
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EA9FC
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	mov r0, #2
	strh r0, [r4, #0x10]
	b _021EA9FC
_021EA98A:
	add r1, r5, #0
	ldr r2, [r4, #0xc]
	add r1, #0x21
	ldrb r1, [r1]
	ldrh r2, [r2]
	add r5, #0x21
	mov r3, #2
	strb r2, [r5]
	add r2, r1, #0
	bl ov14_021E7AD4
	mov r0, #3
	strh r0, [r4, #0x10]
	b _021EA9FC
_021EA9A6:
	bl ov14_021E7B8C
	cmp r0, #0
	bne _021EA9FC
	ldr r0, _021EAA00 ; =0x000005EA
	bl PlaySE
	mov r0, #4
	strh r0, [r4, #0x10]
	b _021EA9FC
_021EA9BA:
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #5
	strh r0, [r4, #0x10]
	b _021EA9FC
_021EA9D2:
	add r0, r4, #0
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EA9FC
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	mov r0, #6
	strh r0, [r4, #0x10]
	b _021EA9FC
_021EA9F6:
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021EA9FC:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EAA00: .word 0x000005EA
	thumb_func_end ov14_021EA928

	thumb_func_start ov14_021EAA04
ov14_021EAA04: ; 0x021EAA04
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r0, #0x2f
	ldr r4, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r4, r0]
	mov r1, #0xf
	bl sub_02019978
	ldrh r0, [r4, #0x10]
	cmp r0, #5
	bls _021EAA1E
	b _021EAB4E
_021EAA1E:
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EAA2A: ; jump table
	.short _021EAA36 - _021EAA2A - 2 ; case 0
	.short _021EAA5A - _021EAA2A - 2 ; case 1
	.short _021EAA76 - _021EAA2A - 2 ; case 2
	.short _021EAA86 - _021EAA2A - 2 ; case 3
	.short _021EAACE - _021EAA2A - 2 ; case 4
	.short _021EAADE - _021EAA2A - 2 ; case 5
_021EAA36:
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EAB4E
_021EAA5A:
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EAB4E
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EAB4E
_021EAA76:
	mov r1, #9
	ldr r0, [r5, #0x34]
	add r2, r1, #0
	bl ov14_021F29E4
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021EAA86:
	ldrh r0, [r4, #0x12]
	cmp r0, #4
	bne _021EAA98
	mov r0, #0
	strh r0, [r4, #0x12]
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
	b _021EAB4E
_021EAA98:
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0x32
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	add r2, r2, #2
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldrh r0, [r4, #0x12]
	add r0, r0, #1
	strh r0, [r4, #0x12]
	b _021EAB4E
_021EAACE:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xa
	bl ov14_021F29E4
	ldrh r0, [r4, #0x10]
	add r0, r0, #1
	strh r0, [r4, #0x10]
_021EAADE:
	ldrh r0, [r4, #0x12]
	cmp r0, #4
	bne _021EAAEC
	mov r0, #0
	strh r0, [r4, #0x12]
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021EAAEC:
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0x32
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #2
	sub r2, r2, #2
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	mov r0, #0xca
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0xca
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	sub r2, r2, #2
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldrh r0, [r4, #0x12]
	add r0, r0, #1
	strh r0, [r4, #0x12]
_021EAB4E:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021EAA04

	thumb_func_start ov14_021EAB54
ov14_021EAB54: ; 0x021EAB54
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	ldrh r0, [r4, #0x10]
	cmp r0, #4
	bhi _021EAC20
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EAB6C: ; jump table
	.short _021EAB76 - _021EAB6C - 2 ; case 0
	.short _021EAB84 - _021EAB6C - 2 ; case 1
	.short _021EABCA - _021EAB6C - 2 ; case 2
	.short _021EABEC - _021EAB6C - 2 ; case 3
	.short _021EAC10 - _021EAB6C - 2 ; case 4
_021EAB76:
	mov r1, #9
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F29E4
	mov r0, #1
	strh r0, [r4, #0x10]
_021EAB84:
	ldrh r0, [r4, #0x12]
	cmp r0, #4
	bne _021EAB94
	mov r0, #0
	strh r0, [r4, #0x12]
	mov r0, #2
	strh r0, [r4, #0x10]
	b _021EAC20
_021EAB94:
	mov r0, #0xca
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	add r1, sp, #0
	add r1, #2
	add r2, sp, #0
	bl ManagedSprite_GetPositionXY
	mov r0, #0xca
	add r3, sp, #0
	mov r2, #0
	ldrsh r2, [r3, r2]
	ldr r1, [r5, #0x34]
	lsl r0, r0, #2
	ldr r0, [r1, r0]
	mov r1, #2
	add r2, r2, #2
	lsl r2, r2, #0x10
	ldrsh r1, [r3, r1]
	asr r2, r2, #0x10
	bl ManagedSprite_SetPositionXY
	ldrh r0, [r4, #0x12]
	add r0, r0, #1
	strh r0, [r4, #0x12]
	b _021EAC20
_021EABCA:
	add r0, r4, #0
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #3
	strh r0, [r4, #0x10]
	b _021EAC20
_021EABEC:
	add r0, r4, #0
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EAC20
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #4
	strh r0, [r4, #0x10]
	b _021EAC20
_021EAC10:
	add r0, r4, #0
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r3, r4, r5, pc}
_021EAC20:
	mov r0, #1
	pop {r3, r4, r5, pc}
	thumb_func_end ov14_021EAB54

	thumb_func_start ov14_021EAC24
ov14_021EAC24: ; 0x021EAC24
	push {r3, r4, r5, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r5, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	mov r1, #0xf
	bl sub_02019978
	ldrh r0, [r5, #0x10]
	cmp r0, #4
	bhi _021EACCC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EAC48: ; jump table
	.short _021EAC52 - _021EAC48 - 2 ; case 0
	.short _021EAC70 - _021EAC48 - 2 ; case 1
	.short _021EAC80 - _021EAC48 - 2 ; case 2
	.short _021EAC98 - _021EAC48 - 2 ; case 3
	.short _021EACBC - _021EAC48 - 2 ; case 4
_021EAC52:
	mov r1, #9
	ldr r0, [r4, #0x34]
	add r2, r1, #0
	bl ov14_021F29E4
	ldr r2, [r4, #0x34]
	ldr r1, _021EACD0 ; =0x000088CA
	add r0, r4, #0
	ldrh r1, [r2, r1]
	mov r2, #2
	bl ov14_021E7AE4
	mov r0, #1
	strh r0, [r5, #0x10]
	b _021EACCC
_021EAC70:
	add r0, r4, #0
	bl ov14_021E7B98
	cmp r0, #0
	bne _021EACCC
	mov r0, #2
	strh r0, [r5, #0x10]
	b _021EACCC
_021EAC80:
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #3
	strh r0, [r5, #0x10]
	b _021EACCC
_021EAC98:
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EACCC
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #4
	strh r0, [r5, #0x10]
	b _021EACCC
_021EACBC:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	mov r0, #0
	strh r0, [r5, #0x10]
	pop {r3, r4, r5, pc}
_021EACCC:
	mov r0, #1
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EACD0: .word 0x000088CA
	thumb_func_end ov14_021EAC24

	thumb_func_start ov14_021EACD4
ov14_021EACD4: ; 0x021EACD4
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	add r4, r0, #0
	mov r0, #0x2f
	ldr r5, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r5, r0]
	bl ov14_021E8514
	add r7, r0, #0
	add r0, r4, #0
	bl ov14_021E80A8
	add r6, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #0xa
	bl sub_02019978
	ldrh r0, [r5, #0x10]
	cmp r0, #0xa
	bhi _021EAD6C
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EAD10: ; jump table
	.short _021EAD26 - _021EAD10 - 2 ; case 0
	.short _021EAD60 - _021EAD10 - 2 ; case 1
	.short _021EAD80 - _021EAD10 - 2 ; case 2
	.short _021EAEBA - _021EAD10 - 2 ; case 3
	.short _021EAEF0 - _021EAD10 - 2 ; case 4
	.short _021EAEF0 - _021EAD10 - 2 ; case 5
	.short _021EAEF0 - _021EAD10 - 2 ; case 6
	.short _021EAEF0 - _021EAD10 - 2 ; case 7
	.short _021EAEF0 - _021EAD10 - 2 ; case 8
	.short _021EAEF0 - _021EAD10 - 2 ; case 9
	.short _021EAECA - _021EAD10 - 2 ; case 10
_021EAD26:
	ldr r0, [r4, #0x34]
	ldr r1, _021EAEF8 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021EAD50
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #1
	strh r0, [r5, #0x10]
	b _021EAEF0
_021EAD50:
	mov r1, #0x2f
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	bl ov14_021E8434
	mov r0, #0xa
	strh r0, [r5, #0x10]
	b _021EAEF0
_021EAD60:
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EAD6E
_021EAD6C:
	b _021EAEF0
_021EAD6E:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B3C
	mov r0, #2
	strh r0, [r5, #0x10]
_021EAD80:
	ldr r0, [r4, #0x34]
	ldr r1, _021EAEFC ; =0x0000044A
	ldrb r2, [r0, r1]
	cmp r2, #1
	bne _021EADA4
	cmp r6, #0
	bne _021EADA4
	mov r2, #2
	strb r2, [r0, r1]
	add r0, r4, #0
	mov r1, #0x28
	bl ov14_021F69F0
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #0
	bl ov14_021F3488
_021EADA4:
	add r0, sp, #4
	add r1, sp, #0
	bl System_GetTouchHeldCoords
	cmp r0, #0
	bne _021EAE60
	ldr r1, [r4, #0x34]
	ldr r0, _021EAEFC ; =0x0000044A
	ldr r2, _021EAF00 ; =0x000040B8
	ldrb r0, [r1, r0]
	cmp r0, #2
	bne _021EADD0
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E7960
	b _021EADE4
_021EADD0:
	ldr r0, [r1, r2]
	add r2, r2, #4
	ldr r1, [r1, r2]
	lsl r0, r0, #0x10
	lsl r1, r1, #0x10
	ldr r2, _021EAF04 ; =ov14_021F7BF0
	asr r0, r0, #0x10
	asr r1, r1, #0x10
	bl ov14_021E79AC
_021EADE4:
	lsl r0, r0, #0x10
	lsr r6, r0, #0x10
	add r7, r6, #0
	cmp r6, #0xff
	bne _021EADF6
	add r0, r4, #0
	add r0, #0x21
	ldrb r6, [r0]
	b _021EAE0E
_021EADF6:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	add r2, r6, #0
	bl ov14_021E6AA0
	cmp r0, #0
	bne _021EAE0E
	add r0, r4, #0
	add r0, #0x21
	ldrb r6, [r0]
_021EAE0E:
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r6, r0
	ldr r1, [r4, #0x34]
	bne _021EAE44
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	ldr r0, [r4, #0x34]
	ldr r1, _021EAEFC ; =0x0000044A
	ldrb r1, [r0, r1]
	cmp r1, #0
	beq _021EAE4E
	mov r1, #0x2f
	lsl r1, r1, #4
	ldr r0, [r0, r1]
	bl ov14_021E7FEC
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	b _021EAE4E
_021EAE44:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EAE4E:
	add r0, r4, #0
	add r1, r7, #0
	add r2, r6, #0
	mov r3, #1
	bl ov14_021E7AD4
	mov r0, #3
	strh r0, [r5, #0x10]
	b _021EAEF0
_021EAE60:
	cmp r7, #0
	bne _021EAE90
	ldr r0, [r4, #0x34]
	ldr r1, _021EAEFC ; =0x0000044A
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021EAE90
	ldr r2, [sp, #4]
	cmp r2, #0x10
	blo _021EAE7E
	ldr r1, [sp]
	cmp r1, #0x30
	blo _021EAE7E
	cmp r2, #0x68
	blo _021EAE90
_021EAE7E:
	ldr r1, _021EAEFC ; =0x0000044A
	mov r2, #1
	strb r2, [r0, r1]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7FB8
_021EAE90:
	ldr r1, [sp, #4]
	ldr r2, [sp]
	lsl r1, r1, #0x10
	lsl r2, r2, #0x10
	ldr r0, [r4, #0x34]
	asr r1, r1, #0x10
	asr r2, r2, #0x10
	bl ov14_021F395C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B5C
	ldr r2, [sp, #4]
	ldr r1, [r4, #0x34]
	ldr r0, _021EAF00 ; =0x000040B8
	str r2, [r1, r0]
	ldr r2, [sp]
	ldr r1, [r4, #0x34]
	add r0, r0, #4
	str r2, [r1, r0]
	b _021EAEF0
_021EAEBA:
	add r0, r4, #0
	bl ov14_021E7B8C
	cmp r0, #0
	bne _021EAEF0
	mov r0, #0xa
	strh r0, [r5, #0x10]
	b _021EAEF0
_021EAECA:
	cmp r7, #0
	bne _021EAEF0
	cmp r6, #0
	bne _021EAEF0
	ldr r0, [r4, #0x34]
	ldr r1, _021EAEF8 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	beq _021EAEE8
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	bl ov14_021F3B3C
_021EAEE8:
	mov r0, #0
	add sp, #8
	strh r0, [r5, #0x10]
	pop {r3, r4, r5, r6, r7, pc}
_021EAEF0:
	mov r0, #1
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EAEF8: .word 0x000088C8
_021EAEFC: .word 0x0000044A
_021EAF00: .word 0x000040B8
_021EAF04: .word ov14_021F7BF0
	thumb_func_end ov14_021EACD4

	thumb_func_start ov14_021EAF08
ov14_021EAF08: ; 0x021EAF08
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r4, [r5, #0x34]
	bl ov14_021E80A8
	add r6, r0, #0
	ldrh r0, [r4, #0x10]
	cmp r0, #0
	beq _021EAF20
	cmp r0, #1
	beq _021EAF70
	b _021EAF84
_021EAF20:
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EAF84
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	ldr r0, [r4, #0xc]
	mov r3, #1
	ldrh r2, [r0]
	add r0, r5, #0
	add r0, #0x21
	strb r2, [r0]
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021E7AD4
	ldr r2, [r5, #0x34]
	ldr r0, _021EAF88 ; =0x0000044A
	ldrb r1, [r2, r0]
	cmp r1, #0
	beq _021EAF6A
	mov r1, #0
	strb r1, [r2, r0]
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7FEC
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
_021EAF6A:
	mov r0, #1
	strh r0, [r4, #0x10]
	b _021EAF84
_021EAF70:
	add r0, r5, #0
	bl ov14_021E7B8C
	cmp r0, #0
	bne _021EAF84
	cmp r6, #0
	bne _021EAF84
	mov r0, #0
	strh r0, [r4, #0x10]
	pop {r4, r5, r6, pc}
_021EAF84:
	mov r0, #1
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EAF88: .word 0x0000044A
	thumb_func_end ov14_021EAF08

	thumb_func_start ov14_021EAF8C
ov14_021EAF8C: ; 0x021EAF8C
	push {r4, lr}
	add r4, r1, #0
	ldr r1, [r4]
	lsl r2, r1, #2
	ldr r1, _021EAFA8 ; =ov14_021F7D9C
	ldr r1, [r1, r2]
	blx r1
	str r0, [r4]
	cmp r0, #0xb3
	beq _021EAFA4
	mov r0, #1
	pop {r4, pc}
_021EAFA4:
	mov r0, #0
	pop {r4, pc}
	.balign 4, 0
_021EAFA8: .word ov14_021F7D9C
	thumb_func_end ov14_021EAF8C

	thumb_func_start ov14_021EAFAC
ov14_021EAFAC: ; 0x021EAFAC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl Main_SetVBlankIntrCB
	bl HBlankInterruptDisable
	mov r0, #0
	bl GfGfx_EngineASetPlanes
	mov r0, #0
	bl GfGfx_EngineBSetPlanes
	ldr r0, _021EB0C8 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	ldr r0, _021EB0CC ; =0x04001050
	strh r1, [r0]
	bl sub_020210BC
	mov r0, #4
	bl sub_02021148
	ldr r2, _021EB0D0 ; =0x04000304
	ldr r0, _021EB0D4 ; =0xFFFF7FFF
	ldrh r1, [r2]
	and r0, r1
	strh r0, [r2]
	mov r2, #2
	mov r0, #3
	mov r1, #0xa
	lsl r2, r2, #0x12
	bl Heap_Create
	ldr r1, _021EB0D8 ; =0x000088E0
	mov r0, #0xa
	bl Heap_Alloc
	ldr r2, _021EB0D8 ; =0x000088E0
	mov r1, #0
	str r0, [r4, #0x34]
	bl MI_CpuFill8
	mov r0, #2
	mov r1, #0xa
	bl NARC_New
	mov r1, #0x45
	ldr r2, [r4, #0x34]
	lsl r1, r1, #4
	str r0, [r2, r1]
	mov r0, #0x14
	mov r1, #0xa
	bl NARC_New
	ldr r2, [r4, #0x34]
	ldr r1, _021EB0DC ; =0x00000454
	str r0, [r2, r1]
	bl ov14_021E5A60
	add r0, r4, #0
	bl ov14_021E5A70
	add r0, r4, #0
	bl ov14_021E5E74
	add r0, r4, #0
	bl ov14_021E5C54
	add r0, r4, #0
	bl ov14_021E5D78
	add r0, r4, #0
	bl ov14_021E5DE0
	add r0, r4, #0
	bl ov14_021F4ED0
	add r0, r4, #0
	bl ov14_021F297C
	add r0, r4, #0
	bl ov14_021F2F20
	add r0, r4, #0
	bl ov14_021F2F3C
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021E7930
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #2
	bl ov14_021E783C
	add r0, r4, #0
	bl ov14_021E7BA4
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #1
	beq _021EB08C
	cmp r0, #0
	beq _021EB08C
	add r0, r4, #0
	bl ov14_021E81FC
	add r0, r4, #0
	bl ov14_021E825C
_021EB08C:
	add r0, r4, #0
	bl ov14_021E82BC
	add r0, r4, #0
	bl ov14_021E5ED0
	add r0, r4, #0
	bl ov14_021F5620
	add r0, r4, #0
	bl ov14_021F566C
	add r0, r4, #0
	bl ov14_021F49C8
	add r0, r4, #0
	bl ov14_021F6A44
	ldr r0, _021EB0E0 ; =ov14_021E59AC
	add r1, r4, #0
	mov r2, #0
	bl SysTask_CreateOnVBlankQueue
	ldr r1, [r4, #0x34]
	str r0, [r1]
	mov r0, #1
	bl ov14_021E5EAC
	ldr r0, [r4, #0x30]
	pop {r4, pc}
	.balign 4, 0
_021EB0C8: .word 0x04000050
_021EB0CC: .word 0x04001050
_021EB0D0: .word 0x04000304
_021EB0D4: .word 0xFFFF7FFF
_021EB0D8: .word 0x000088E0
_021EB0DC: .word 0x00000454
_021EB0E0: .word ov14_021E59AC
	thumb_func_end ov14_021EAFAC

	thumb_func_start ov14_021EB0E4
ov14_021EB0E4: ; 0x021EB0E4
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E6048
	ldr r0, [r4, #0x34]
	ldr r0, [r0]
	bl SysTask_Destroy
	add r0, r4, #0
	bl ov14_021F6B10
	add r0, r4, #0
	bl ov14_021E5EE8
	ldr r0, [r4, #0x34]
	bl ov14_021E7D7C
	ldr r0, [r4, #0x34]
	bl ov14_021F29AC
	add r0, r4, #0
	bl ov14_021F4F00
	add r0, r4, #0
	bl ov14_021E5DB8
	add r0, r4, #0
	bl ov14_021E5E94
	add r0, r4, #0
	bl ov14_021E5C00
	ldr r1, [r4, #0x34]
	ldr r0, _021EB164 ; =0x00000454
	ldr r0, [r1, r0]
	bl NARC_Delete
	mov r0, #0x45
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl NARC_Delete
	bl sub_02021238
	ldr r1, _021EB168 ; =0x04000050
	mov r0, #0
	strh r0, [r1]
	ldr r1, _021EB16C ; =0x04001050
	strh r0, [r1]
	bl GfGfx_EngineASetPlanes
	mov r0, #0
	bl GfGfx_EngineBSetPlanes
	ldr r0, [r4, #0x34]
	bl Heap_Free
	mov r0, #0xa
	bl Heap_Destroy
	ldr r0, [r4, #0x30]
	pop {r4, pc}
	nop
_021EB164: .word 0x00000454
_021EB168: .word 0x04000050
_021EB16C: .word 0x04001050
	thumb_func_end ov14_021EB0E4

	thumb_func_start ov14_021EB170
ov14_021EB170: ; 0x021EB170
	push {r4, lr}
	add r4, r0, #0
	bl IsPaletteFadeFinished
	cmp r0, #1
	bne _021EB186
	mov r0, #0x11
	ldr r1, [r4, #0x34]
	lsl r0, r0, #6
	ldr r0, [r1, r0]
	pop {r4, pc}
_021EB186:
	mov r0, #2
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EB170

	thumb_func_start ov14_021EB18C
ov14_021EB18C: ; 0x021EB18C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x18]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	bne _021EB1A0
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB1A0:
	mov r0, #3
	pop {r4, pc}
	thumb_func_end ov14_021EB18C

	thumb_func_start ov14_021EB1A4
ov14_021EB1A4: ; 0x021EB1A4
	ldr r3, [r0, #0x34]
	ldr r1, _021EB1BC ; =0x00000444
	ldr r2, [r3, r1]
	cmp r2, #0
	bne _021EB1B2
	ldr r0, [r0, #0x30]
	bx lr
_021EB1B2:
	sub r0, r2, #1
	str r0, [r3, r1]
	mov r0, #4
	bx lr
	nop
_021EB1BC: .word 0x00000444
	thumb_func_end ov14_021EB1A4

	thumb_func_start ov14_021EB1C0
ov14_021EB1C0: ; 0x021EB1C0
	push {r3, lr}
	ldr r1, [r0, #0x34]
	ldr r1, [r1, #4]
	cmp r1, #0
	bne _021EB1D6
	ldr r1, [r0, #0x30]
	lsl r2, r1, #2
	ldr r1, _021EB1DC ; =ov14_021F7D9C
	ldr r1, [r1, r2]
	blx r1
	pop {r3, pc}
_021EB1D6:
	mov r0, #5
	pop {r3, pc}
	nop
_021EB1DC: .word ov14_021F7D9C
	thumb_func_end ov14_021EB1C0

	thumb_func_start ov14_021EB1E0
ov14_021EB1E0: ; 0x021EB1E0
	push {r4, lr}
	add r4, r0, #0
	bl System_GetTouchNew
	cmp r0, #1
	bne _021EB1F6
	ldr r0, _021EB210 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB1F6:
	ldr r0, _021EB214 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #3
	tst r0, r1
	beq _021EB20A
	ldr r0, _021EB210 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB20A:
	mov r0, #6
	pop {r4, pc}
	nop
_021EB210: .word 0x000005DD
_021EB214: .word gSystem
	thumb_func_end ov14_021EB1E0

	thumb_func_start ov14_021EB218
ov14_021EB218: ; 0x021EB218
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x34]
	ldr r0, _021EB26C ; =0x00000434
	ldr r0, [r1, r0]
	bl YesNoPrompt_HandleInput
	cmp r0, #1
	beq _021EB230
	cmp r0, #2
	beq _021EB24C
	b _021EB268
_021EB230:
	ldr r1, [r4, #0x34]
	ldr r0, _021EB26C ; =0x00000434
	ldr r0, [r1, r0]
	bl YesNoPrompt_Reset
	ldr r2, [r4, #0x34]
	ldr r1, _021EB270 ; =0x00000438
	add r0, r4, #0
	ldrh r1, [r2, r1]
	lsl r2, r1, #3
	ldr r1, _021EB274 ; =ov14_021F7D74
	ldr r1, [r1, r2]
	blx r1
	pop {r4, pc}
_021EB24C:
	ldr r1, [r4, #0x34]
	ldr r0, _021EB26C ; =0x00000434
	ldr r0, [r1, r0]
	bl YesNoPrompt_Reset
	ldr r2, [r4, #0x34]
	ldr r1, _021EB270 ; =0x00000438
	add r0, r4, #0
	ldrh r1, [r2, r1]
	lsl r2, r1, #3
	ldr r1, _021EB278 ; =ov14_021F7D78
	ldr r1, [r1, r2]
	blx r1
	pop {r4, pc}
_021EB268:
	mov r0, #7
	pop {r4, pc}
	.balign 4, 0
_021EB26C: .word 0x00000434
_021EB270: .word 0x00000438
_021EB274: .word ov14_021F7D74
_021EB278: .word ov14_021F7D78
	thumb_func_end ov14_021EB218

	thumb_func_start ov14_021EB27C
ov14_021EB27C: ; 0x021EB27C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E5F4C
	cmp r0, #0
	bne _021EB28C
	ldr r0, [r4, #0x30]
	pop {r4, pc}
_021EB28C:
	mov r0, #8
	pop {r4, pc}
	thumb_func_end ov14_021EB27C

	thumb_func_start ov14_021EB290
ov14_021EB290: ; 0x021EB290
	push {r3, lr}
	ldrb r2, [r0, #0x1e]
	mov r1, #0xc
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021EB2A4 ; =ov14_021F7D50
	ldr r1, [r1, r3]
	blx r1
	mov r0, #0xa
	pop {r3, pc}
	.balign 4, 0
_021EB2A4: .word ov14_021F7D50
	thumb_func_end ov14_021EB290

	thumb_func_start ov14_021EB2A8
ov14_021EB2A8: ; 0x021EB2A8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x14]
	bl OverlayManager_Run
	cmp r0, #0
	bne _021EB2BA
	mov r0, #0xa
	pop {r4, pc}
_021EB2BA:
	ldr r0, [r4, #0x14]
	bl OverlayManager_Delete
	ldrb r2, [r4, #0x1e]
	mov r1, #0xc
	add r0, r4, #0
	add r3, r2, #0
	mul r3, r1
	ldr r1, _021EB2E4 ; =ov14_021F7D50 + 4
	ldr r1, [r1, r3]
	blx r1
	ldrb r1, [r4, #0x1e]
	mov r0, #0xc
	add r2, r1, #0
	mul r2, r0
	ldr r0, _021EB2E8 ; =ov14_021F7D50 + 8
	ldr r0, [r0, r2]
	str r0, [r4, #0x30]
	mov r0, #0
	pop {r4, pc}
	nop
_021EB2E4: .word ov14_021F7D50 + 4
_021EB2E8: .word ov14_021F7D50 + 8
	thumb_func_end ov14_021EB2A8

	thumb_func_start ov14_021EB2EC
ov14_021EB2EC: ; 0x021EB2EC
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, _021EB384 ; =0x0000060C
	bl PlaySE
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bhi _021EB37A
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EB30A: ; jump table
	.short _021EB312 - _021EB30A - 2 ; case 0
	.short _021EB342 - _021EB30A - 2 ; case 1
	.short _021EB35A - _021EB30A - 2 ; case 2
	.short _021EB366 - _021EB30A - 2 ; case 3
_021EB312:
	add r0, r4, #0
	bl ov14_021F0BF4
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #0x1e
	bl ov14_021E7588
	mov r5, #0x5b
	b _021EB37A
_021EB342:
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7588
	mov r5, #0x51
	b _021EB37A
_021EB35A:
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7588
	mov r5, #0xc
	b _021EB37A
_021EB366:
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7588
	mov r5, #0x75
_021EB37A:
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F01D8
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EB384: .word 0x0000060C
	thumb_func_end ov14_021EB2EC

	thumb_func_start ov14_021EB388
ov14_021EB388: ; 0x021EB388
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EB490
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EB3F4
	ldr r0, _021EB6E4 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EB6E8 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EB3D8
	ldr r1, _021EB6EC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
_021EB3D8:
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F039C
	pop {r3, r4, r5, pc}
_021EB3F4:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EB470
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EB6F0 ; =ov14_021EA180
	add r0, r4, #0
	mov r2, #0x4a
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EB470:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0xc
	pop {r3, r4, r5, pc}
_021EB490:
	add r0, r4, #0
	bl ov14_021F6F94
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EB4DC
	blo _021EB4A4
	b _021EB684
_021EB4A4:
	cmp r5, #0x29
	bhi _021EB4D0
	sub r0, #0x1e
	bmi _021EB4DA
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EB4B8: ; jump table
	.short _021EB4F2 - _021EB4B8 - 2 ; case 0
	.short _021EB506 - _021EB4B8 - 2 ; case 1
	.short _021EB530 - _021EB4B8 - 2 ; case 2
	.short _021EB55A - _021EB4B8 - 2 ; case 3
	.short _021EB56C - _021EB4B8 - 2 ; case 4
	.short _021EB6C8 - _021EB4B8 - 2 ; case 5
	.short _021EB58C - _021EB4B8 - 2 ; case 6
	.short _021EB5BA - _021EB4B8 - 2 ; case 7
	.short _021EB5D0 - _021EB4B8 - 2 ; case 8
	.short _021EB5E2 - _021EB4B8 - 2 ; case 9
	.short _021EB5F4 - _021EB4B8 - 2 ; case 10
	.short _021EB606 - _021EB4B8 - 2 ; case 11
_021EB4D0:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EB4DA
	b _021EB714
_021EB4DA:
	b _021EB750
_021EB4DC:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EB4E8
	bne _021EB4E6
	b _021EB6E0
_021EB4E6:
	b _021EB750
_021EB4E8:
	add r0, r1, #2
	cmp r5, r0
	bne _021EB4F0
	b _021EB63A
_021EB4F0:
	b _021EB750
_021EB4F2:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	bl ov14_021F1128
	pop {r3, r4, r5, pc}
_021EB506:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EB530:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EB55A:
	ldr r0, _021EB6FC ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #8
	mov r2, #0x95
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB56C:
	ldr r0, _021EB6FC ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	add r0, #0x2a
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #9
	mov r2, #0x96
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EB58C:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	bl System_GetTouchNew
	cmp r0, #0
	bne _021EB5A2
	add r0, r4, #0
	mov r1, #1
	add r0, #0x2a
	strb r1, [r0]
_021EB5A2:
	add r0, r4, #0
	add r0, #0x21
	ldrb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #3
	mov r2, #0xb2
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EB5BA:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	mov r0, #0x25
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB5D0:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x98
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB5E2:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB5F4:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB606:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0x9c
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB63A:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	cmp r0, #0x1e
	bne _021EB66C
	ldr r0, _021EB700 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _021EB666
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EB666:
	mov r0, #0x10
	tst r0, r1
	bne _021EB66E
_021EB66C:
	b _021EB79E
_021EB66E:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0xc
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EB684:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EB69A
	add r0, r4, #0
	bl ov14_021E7588
	b _021EB6B8
_021EB69A:
	cmp r1, #0x24
	beq _021EB6B8
	cmp r1, #0x25
	beq _021EB6B8
	cmp r1, #0x26
	beq _021EB6B8
	cmp r1, #0x27
	beq _021EB6B8
	cmp r1, #0x28
	beq _021EB6B8
	cmp r1, #0x29
	beq _021EB6B8
	add r0, r4, #0
	bl ov14_021E765C
_021EB6B8:
	ldr r0, _021EB6F8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x4a
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EB6C8:
	ldr r0, _021EB6F4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB6E0:
	ldr r0, _021EB6F4 ; =0x000005DD
	b _021EB704
	.balign 4, 0
_021EB6E4: .word 0x000005EB
_021EB6E8: .word 0x000040B8
_021EB6EC: .word ov14_021F7D3C
_021EB6F0: .word ov14_021EA180
_021EB6F4: .word 0x000005DD
_021EB6F8: .word 0x000005DC
_021EB6FC: .word 0x00000632
_021EB700: .word gSystem
_021EB704:
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EB714:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EB72A
	add r0, r4, #0
	bl ov14_021E7588
	b _021EB748
_021EB72A:
	cmp r1, #0x24
	beq _021EB748
	cmp r1, #0x25
	beq _021EB748
	cmp r1, #0x26
	beq _021EB748
	cmp r1, #0x27
	beq _021EB748
	cmp r1, #0x28
	beq _021EB748
	cmp r1, #0x29
	beq _021EB748
	add r0, r4, #0
	bl ov14_021E765C
_021EB748:
	ldr r0, _021EB7A4 ; =0x000005DC
	bl PlaySE
	b _021EB79E
_021EB750:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EB79E
	ldr r0, _021EB7A8 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EB7AC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0530
	pop {r3, r4, r5, pc}
_021EB79E:
	mov r0, #0xc
	pop {r3, r4, r5, pc}
	nop
_021EB7A4: .word 0x000005DC
_021EB7A8: .word 0x000005DD
_021EB7AC: .word ov14_021F7D3C
	thumb_func_end ov14_021EB388

	thumb_func_start ov14_021EB7B0
ov14_021EB7B0: ; 0x021EB7B0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021EB7E0 ; =0x000005EA
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E637C
	add r0, r4, #0
	bl ov14_021F08F0
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0xc
	pop {r4, pc}
	nop
_021EB7E0: .word 0x000005EA
	thumb_func_end ov14_021EB7B0

	thumb_func_start ov14_021EB7E4
ov14_021EB7E4: ; 0x021EB7E4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0x25
	bl ov14_021F6688
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021EB81E
	cmp r0, #1
	beq _021EB800
	cmp r0, #2
	b _021EB83C
_021EB800:
	ldr r1, _021EB8AC ; =ov14_021F7D2C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x5a
	b _021EB856
_021EB81E:
	ldr r1, _021EB8B0 ; =ov14_021F7D1C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x72
	b _021EB856
_021EB83C:
	ldr r1, _021EB8B4 ; =ov14_021F7D3C
	add r0, r5, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EB854
	mov r4, #0x4d
	b _021EB856
_021EB854:
	mov r4, #0x4e
_021EB856:
	ldr r0, [r5, #0x34]
	ldr r2, _021EB8B8 ; =0x0000044E
	ldrb r3, [r0, r2]
	lsl r1, r3, #0x18
	lsr r1, r1, #0x1f
	cmp r1, #1
	bne _021EB892
	mov r1, #0x80
	bic r3, r1
	strb r3, [r0, r2]
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EB880
	add r0, r5, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	b _021EB892
_021EB880:
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r5, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
_021EB892:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8434
	ldr r1, _021EB8BC ; =ov14_021E9434
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EB8AC: .word ov14_021F7D2C
_021EB8B0: .word ov14_021F7D1C
_021EB8B4: .word ov14_021F7D3C
_021EB8B8: .word 0x0000044E
_021EB8BC: .word ov14_021E9434
	thumb_func_end ov14_021EB7E4

	thumb_func_start ov14_021EB8C0
ov14_021EB8C0: ; 0x021EB8C0
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	bl ov14_021E7588
	add r0, r5, #0
	add r0, #0x26
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EB9D4
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021EB8EC
	ldr r1, _021EBAD8 ; =ov14_021F7D2C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	b _021EB954
_021EB8EC:
	cmp r0, #0
	bne _021EB90E
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	ldr r1, _021EBADC ; =ov14_021F7D1C
	add r0, r5, #0
	mov r2, #4
	bl ov14_021F5EE4
	b _021EB954
_021EB90E:
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EB934
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EB944
	add r0, r5, #0
	bl ov14_021E8664
	b _021EB944
_021EB934:
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EB944
	add r0, r5, #0
	bl ov14_021E8664
_021EB944:
	ldr r1, _021EBAE0 ; =ov14_021F7D3C
	add r0, r5, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r5, #0
	bl ov14_021E87F4
_021EB954:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E83C4
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	ldr r0, [r5]
	cmp r1, #0x1e
	bhs _021EB984
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021EB980
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x51
	b _021EB9BE
_021EB980:
	mov r4, #0xc
	b _021EB9BE
_021EB984:
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _021EB9A4
	add r0, r5, #0
	bl ov14_021F0BF4
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x5b
	b _021EB9BE
_021EB9A4:
	add r0, r5, #0
	bl ov14_021F0B70
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	add r0, r5, #0
	mov r1, #5
	mov r2, #9
	bl ov14_021F6AC0
	mov r4, #0x24
_021EB9BE:
	add r0, r5, #0
	bl ov14_021F3F6C
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBACC
	ldr r0, [r5, #0x34]
	bl ov14_021E8874
	b _021EBACC
_021EB9D4:
	add r0, r5, #0
	bl ov14_021F0BB4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8610
	add r0, r5, #0
	bl ov14_021F4720
	add r0, r5, #0
	bl ov14_021F4848
	add r0, r5, #0
	bl ov14_021F48B4
	add r0, r5, #0
	bl ov14_021F57B8
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E86E0
_021EBA0A:
	add r0, r5, #0
	bl ov14_021E9554
	cmp r0, #0
	bne _021EBA0A
	add r0, r5, #0
	add r0, #0x27
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EBA2E
	add r2, r5, #0
	add r2, #0x21
	ldrb r2, [r2]
	add r0, r5, #0
	mov r1, #4
	bl ov14_021F6AC0
	b _021EBA4A
_021EBA2E:
	add r2, r5, #0
	add r2, #0x28
	ldrb r2, [r2]
	add r0, r5, #0
	mov r1, #4
	bl ov14_021F6AC0
	ldr r1, [r5, #0x34]
	ldr r0, _021EBAE4 ; =0x0000044B
	mov r2, #1
	strb r2, [r1, r0]
	add r0, r5, #0
	bl ov14_021EA1F0
_021EBA4A:
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r2, [r5, #0x34]
	ldr r0, _021EBAE8 ; =0x0000043C
	add r1, #0x25
	str r1, [r2, r0]
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBA7E
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	mov r4, #0x82
	b _021EBA8E
_021EBA7E:
	add r0, r5, #0
	add r0, #0x27
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EBA8C
	mov r4, #0x29
	b _021EBA8E
_021EBA8C:
	mov r4, #0x73
_021EBA8E:
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBAA6
	add r0, r5, #0
	add r0, #0x27
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EBAA6
	ldr r0, [r5, #0x34]
	bl ov14_021E8874
_021EBAA6:
	add r0, r5, #0
	add r0, #0x29
	ldrb r0, [r0]
	cmp r0, #1
	bne _021EBAB8
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
_021EBAB8:
	add r0, r5, #0
	mov r1, #0
	add r0, #0x26
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x28
	strb r1, [r0]
	add r0, r5, #0
	add r0, #0x27
	strb r1, [r0]
_021EBACC:
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F01D8
	pop {r3, r4, r5, pc}
	nop
_021EBAD8: .word ov14_021F7D2C
_021EBADC: .word ov14_021F7D1C
_021EBAE0: .word ov14_021F7D3C
_021EBAE4: .word 0x0000044B
_021EBAE8: .word 0x0000043C
	thumb_func_end ov14_021EB8C0

	thumb_func_start ov14_021EBAEC
ov14_021EBAEC: ; 0x021EBAEC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #9
	mov r2, #0xa
	bl ov14_021F6AC0
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r2, [r4, #0x34]
	ldr r0, _021EBB38 ; =0x0000043C
	str r1, [r2, r0]
	add r0, r4, #0
	bl ov14_021E8740
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x27
	bl ov14_021F6844
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBB2C
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
_021EBB2C:
	add r0, r4, #0
	mov r1, #0x3d
	bl ov14_021F01D8
	pop {r4, pc}
	nop
_021EBB38: .word 0x0000043C
	thumb_func_end ov14_021EBAEC

	thumb_func_start ov14_021EBB3C
ov14_021EBB3C: ; 0x021EBB3C
	push {r3, r4, r5, r6, lr}
	sub sp, #4
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	cmp r1, #0x1e
	blo _021EBB62
	bl ov14_021F0B70
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
_021EBB62:
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBB70
	add r0, r5, #0
	bl ov14_021F3F6C
_021EBB70:
	ldr r0, [r5]
	ldr r0, [r0, #8]
	sub r0, r0, #2
	cmp r0, #1
	bhi _021EBB8C
	add r0, r5, #0
	bl ov14_021E87F4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82FC
_021EBB8C:
	ldrh r0, [r5, #0x1c]
	cmp r0, #0
	bne _021EBC04
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBBD2
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5FBC
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EBBBA
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	mov r4, #0x75
	b _021EBBF6
_021EBBBA:
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	add r0, r5, #0
	mov r1, #7
	mov r2, #8
	bl ov14_021F6AC0
	mov r4, #0x8b
	b _021EBBF6
_021EBBD2:
	ldr r1, _021EBDBC ; =ov14_021F7D3C
	add r0, r5, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EBBEA
	mov r4, #0xc
	b _021EBBF6
_021EBBEA:
	add r0, r5, #0
	mov r1, #5
	mov r2, #0xa
	bl ov14_021F6AC0
	mov r4, #0x24
_021EBBF6:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E83C4
	b _021EBD82
_021EBC04:
	mov r4, #0
	cmp r0, #0x70
	bne _021EBC24
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #5
	add r3, r4, #0
	bl ov14_021E6070
	ldr r1, _021EBDC0 ; =0x000001E7
	cmp r0, r1
	beq _021EBC24
	mov r4, #1
	b _021EBC72
_021EBC24:
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	add r1, r5, #0
	add r1, #0x21
	add r3, r5, #0
	add r6, r0, #0
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, #0x1c
	bl ov14_021E6094
	add r0, r6, #0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EBC66
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EBDC4 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EBC66:
	ldrh r1, [r5, #0x1c]
	ldr r0, [r5, #0xc]
	mov r2, #1
	mov r3, #0xa
	bl Bag_TakeItem
_021EBC72:
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r0, [r5]
	cmp r2, #0x1e
	blo _021EBC9C
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBC90
	add r0, r5, #0
	mov r1, #7
	sub r2, #0x1e
	bl ov14_021F6AC0
	b _021EBCD6
_021EBC90:
	add r0, r5, #0
	mov r1, #5
	mov r2, #0xa
	bl ov14_021F6AC0
	b _021EBCD6
_021EBC9C:
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBCD6
	ldr r0, [r5, #0x34]
	add r1, r2, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
_021EBCD6:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EBD78
	cmp r4, #0
	bne _021EBD50
	ldrh r2, [r5, #0x1c]
	ldr r0, [r5, #0x34]
	ldr r1, _021EBDC8 ; =0x000088C8
	strh r2, [r0, r1]
	ldr r0, [r5, #0x34]
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EBD2A
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #1
	bl ov14_021F396C
	b _021EBD42
_021EBD2A:
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F396C
_021EBD42:
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r0, [r5, #0x34]
	bl ov14_021F3B3C
	b _021EBD74
_021EBD50:
	mov r0, #0
	strh r0, [r5, #0x1c]
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EBD6A
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
	b _021EBD74
_021EBD6A:
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
_021EBD74:
	mov r4, #0x7d
	b _021EBD82
_021EBD78:
	cmp r4, #1
	bne _021EBD80
	mov r0, #0
	strh r0, [r5, #0x1c]
_021EBD80:
	mov r4, #0x12
_021EBD82:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E7588
	ldr r0, [r5]
	ldr r0, [r0, #8]
	cmp r0, #3
	beq _021EBD9E
	ldr r0, [r5, #0x34]
	bl ov14_021E8874
	b _021EBDB0
_021EBD9E:
	ldrh r0, [r5, #0x1c]
	cmp r0, #0
	beq _021EBDB0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E892C
_021EBDB0:
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F01D8
	add sp, #4
	pop {r3, r4, r5, r6, pc}
	.balign 4, 0
_021EBDBC: .word ov14_021F7D3C
_021EBDC0: .word 0x000001E7
_021EBDC4: .word 0x00004094
_021EBDC8: .word 0x000088C8
	thumb_func_end ov14_021EBB3C

	thumb_func_start ov14_021EBDCC
ov14_021EBDCC: ; 0x021EBDCC
	push {r4, lr}
	add r4, r0, #0
	ldrh r1, [r4, #0x1c]
	mov r2, #0x25
	bl ov14_021F6768
	mov r0, #0xe
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EBDCC

	thumb_func_start ov14_021EBDE0
ov14_021EBDE0: ; 0x021EBDE0
	ldr r3, _021EBDE4 ; =ov14_021EBDE8
	bx r3
	.balign 4, 0
_021EBDE4: .word ov14_021EBDE8
	thumb_func_end ov14_021EBDE0

	thumb_func_start ov14_021EBDE8
ov14_021EBDE8: ; 0x021EBDE8
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	mov r2, #0xb
	mov r3, #0
	bl ov14_021E6070
	ldr r2, [r4, #0x34]
	ldr r1, _021EBE24 ; =0x000040C0
	str r0, [r2, r1]
	add r0, r4, #0
	bl ov14_021E7DF8
	ldr r0, [r4, #0x34]
	bl ov14_021F638C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7E40
	ldr r1, _021EBE28 ; =ov14_021E94A8
	add r0, r4, #0
	mov r2, #0x15
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EBE24: .word 0x000040C0
_021EBE28: .word ov14_021E94A8
	thumb_func_end ov14_021EBDE8

	thumb_func_start ov14_021EBE2C
ov14_021EBE2C: ; 0x021EBE2C
	push {r4, lr}
	mov r1, #8
	mov r2, #0
	add r4, r0, #0
	bl ov14_021F6AC0
	mov r1, #1
	add r0, r4, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #2
	mov r2, #1
	bl ov14_021F3488
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r0, r4, #0
	mov r1, #0x26
	bl ov14_021F67A4
	mov r0, #0x16
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EBE2C

	thumb_func_start ov14_021EBE68
ov14_021EBE68: ; 0x021EBE68
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #3
	mvn r1, r1
	cmp r0, r1
	bhi _021EBEA0
	bhs _021EBF72
	cmp r0, #7
	bhi _021EBF78
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021EBE90: ; jump table
	.short _021EBEB4 - _021EBE90 - 2 ; case 0
	.short _021EBEC4 - _021EBE90 - 2 ; case 1
	.short _021EBED4 - _021EBE90 - 2 ; case 2
	.short _021EBEE4 - _021EBE90 - 2 ; case 3
	.short _021EBEF4 - _021EBE90 - 2 ; case 4
	.short _021EBF04 - _021EBE90 - 2 ; case 5
	.short _021EBF14 - _021EBE90 - 2 ; case 6
	.short _021EBF4C - _021EBE90 - 2 ; case 7
_021EBEA0:
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021EBEAC
	beq _021EBF60
	b _021EBF78
_021EBEAC:
	add r1, r1, #1
	cmp r0, r1
	beq _021EBF4C
	b _021EBF78
_021EBEB4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021E7E10
	b _021EBF78
_021EBEC4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021E7E10
	b _021EBF78
_021EBED4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #2
	bl ov14_021E7E10
	b _021EBF78
_021EBEE4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov14_021E7E10
	b _021EBF78
_021EBEF4:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #4
	bl ov14_021E7E10
	b _021EBF78
_021EBF04:
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	bl ov14_021E7E10
	b _021EBF78
_021EBF14:
	ldr r1, [r4, #0x34]
	ldr r0, _021EBF84 ; =0x000040C0
	mov r2, #0xb
	ldr r1, [r1, r0]
	add r0, sp, #0
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	add r3, sp, #0
	bl ov14_021E6094
	add r1, sp, #0
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E895C
	ldr r0, _021EBF80 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x9a
	bl ov14_021F23F0
	add sp, #4
	pop {r3, r4, pc}
_021EBF4C:
	ldr r0, _021EBF88 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0x9a
	bl ov14_021F23F0
	add sp, #4
	pop {r3, r4, pc}
_021EBF60:
	ldr r0, _021EBF88 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x18
	bl ov14_021F0244
	add sp, #4
	pop {r3, r4, pc}
_021EBF72:
	ldr r0, _021EBF88 ; =0x000005DC
	bl PlaySE
_021EBF78:
	mov r0, #0x16
	add sp, #4
	pop {r3, r4, pc}
	nop
_021EBF80: .word 0x000005DD
_021EBF84: .word 0x000040C0
_021EBF88: .word 0x000005DC
	thumb_func_end ov14_021EBE68

	thumb_func_start ov14_021EBF8C
ov14_021EBF8C: ; 0x021EBF8C
	ldr r3, _021EBF94 ; =ov14_021F0234
	ldr r1, _021EBF98 ; =ov14_021E94BC
	mov r2, #0xe
	bx r3
	.balign 4, 0
_021EBF94: .word ov14_021F0234
_021EBF98: .word ov14_021E94BC
	thumb_func_end ov14_021EBF8C

	thumb_func_start ov14_021EBF9C
ov14_021EBF9C: ; 0x021EBF9C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	cmp r1, #0x1e
	blo _021EC070
	mov r1, #2
	mov r2, #1
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	add r0, r5, #0
	sub r4, #0x1e
	add r1, r4, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021EBFF8
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EBFF8:
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r4, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EC03C
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EC03C:
	add r0, r4, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021EC090
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EC070:
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F43F4
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
_021EC090:
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	mov r1, #0x4c
	mov r2, #0
	bl GetBoxMonData
	cmp r0, #0
	beq _021EC0CE
	ldr r0, _021EC0E4 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #3
	mov r2, #0x25
	bl ov14_021F67B0
	ldr r3, [r5, #0x34]
	ldr r1, _021EC0E8 ; =0x0000044E
	mov r0, #0x80
	ldrb r2, [r3, r1]
	orr r0, r2
	strb r0, [r3, r1]
	mov r0, #0xe
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EC0CE:
	add r0, r5, #0
	mov r1, #0
	mov r2, #0x25
	bl ov14_021F67B0
	add r0, r5, #0
	mov r1, #1
	bl ov14_021F0254
	pop {r3, r4, r5, pc}
	nop
_021EC0E4: .word 0x000005F3
_021EC0E8: .word 0x0000044E
	thumb_func_end ov14_021EBF9C

	thumb_func_start ov14_021EC0EC
ov14_021EC0EC: ; 0x021EC0EC
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E7278
	ldr r1, [r4, #0x34]
	ldr r0, _021EC124 ; =0x000088DC
	ldr r0, [r1, r0]
	bl ov14_021F3380
	cmp r0, #0
	bne _021EC120
	ldr r1, [r4, #0x34]
	ldr r0, _021EC124 ; =0x000088DC
	ldr r0, [r1, r0]
	ldrb r1, [r0, #6]
	cmp r1, #0
	beq _021EC112
	mov r0, #0x1e
	pop {r4, pc}
_021EC112:
	bl ov14_021F33E8
	add r0, r4, #0
	bl ov14_021E7264
	mov r0, #0x1b
	pop {r4, pc}
_021EC120:
	mov r0, #0x1a
	pop {r4, pc}
	.balign 4, 0
_021EC124: .word 0x000088DC
	thumb_func_end ov14_021EC0EC

	thumb_func_start ov14_021EC128
ov14_021EC128: ; 0x021EC128
	push {r4, lr}
	mov r1, #1
	mov r2, #0x25
	add r4, r0, #0
	bl ov14_021F67B0
	mov r0, #0x1c
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EC128

	thumb_func_start ov14_021EC13C
ov14_021EC13C: ; 0x021EC13C
	push {r4, lr}
	mov r1, #2
	mov r2, #0x25
	add r4, r0, #0
	bl ov14_021F67B0
	mov r0, #0x1d
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EC13C

	thumb_func_start ov14_021EC150
ov14_021EC150: ; 0x021EC150
	push {r4, lr}
	add r4, r0, #0
	add r2, r4, #0
	add r2, #0x21
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r2]
	bl ov14_021E6100
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EC200
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021F4958
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021F4A20
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021EC1A2
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x51
	str r0, [r4, #0x30]
	b _021EC1BE
_021EC1A2:
	mov r0, #0xc
	str r0, [r4, #0x30]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
_021EC1BE:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r1, r4, #0
	ldr r0, [r4, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	ldr r1, _021EC234 ; =ov14_021E9450
	b _021EC22A
_021EC200:
	add r0, r4, #0
	bl ov14_021F08BC
	add r0, r4, #0
	mov r1, #1
	add r0, #0x22
	strb r1, [r0]
	mov r0, #0x21
	str r0, [r4, #0x30]
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	ldr r1, _021EC238 ; =ov14_021E9194
_021EC22A:
	ldr r2, [r4, #0x30]
	add r0, r4, #0
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EC234: .word ov14_021E9450
_021EC238: .word ov14_021E9194
	thumb_func_end ov14_021EC150

	thumb_func_start ov14_021EC23C
ov14_021EC23C: ; 0x021EC23C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F08F0
	add r0, r4, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EC254
	add r0, r4, #0
	bl ov14_021F57B8
_021EC254:
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E7588
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #0
	bne _021EC29E
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x5b
	pop {r4, pc}
_021EC29E:
	mov r0, #0x24
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EC23C

	thumb_func_start ov14_021EC2A4
ov14_021EC2A4: ; 0x021EC2A4
	push {r4, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x34]
	ldr r0, _021EC2E8 ; =0x000088DC
	ldr r0, [r1, r0]
	bl ov14_021F33B0
	cmp r0, #0
	bne _021EC2E4
	ldr r1, [r4, #0x34]
	ldr r0, _021EC2E8 ; =0x000088DC
	ldr r0, [r1, r0]
	bl ov14_021F33FC
	add r0, r4, #0
	bl ov14_021E7264
	add r0, r4, #0
	bl ov14_021F3F6C
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x25
	bl ov14_021F67B0
	ldr r0, [r4, #0x34]
	bl ov14_021E8824
	mov r0, #0x1f
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
_021EC2E4:
	mov r0, #0x1e
	pop {r4, pc}
	.balign 4, 0
_021EC2E8: .word 0x000088DC
	thumb_func_end ov14_021EC2A4

	thumb_func_start ov14_021EC2EC
ov14_021EC2EC: ; 0x021EC2EC
	push {r4, lr}
	mov r1, #5
	mov r2, #0x25
	add r4, r0, #0
	bl ov14_021F67B0
	mov r0, #0x20
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	thumb_func_end ov14_021EC2EC

	thumb_func_start ov14_021EC300
ov14_021EC300: ; 0x021EC300
	push {r4, lr}
	add r4, r0, #0
	mov r1, #1
	bl ov14_021F40E8
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EC328
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
	b _021EC332
_021EC328:
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
_021EC332:
	ldr r1, _021EC340 ; =ov14_021E9450
	add r0, r4, #0
	mov r2, #0xe
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EC340: .word ov14_021E9450
	thumb_func_end ov14_021EC300

	thumb_func_start ov14_021EC344
ov14_021EC344: ; 0x021EC344
	push {r3, lr}
	ldr r0, [r0, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x5b
	pop {r3, pc}
	thumb_func_end ov14_021EC344

	thumb_func_start ov14_021EC354
ov14_021EC354: ; 0x021EC354
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov14_021E81A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EC0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	ldr r0, [r4, #0x34]
	bl ov14_021F63F0
	ldr r0, [r4, #0x34]
	bl ov14_021F63A8
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EC4
	add r0, r4, #0
	bl ov14_021F2FDC
	ldr r1, _021EC3A4 ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x23
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EC3A4: .word ov14_021E9518
	thumb_func_end ov14_021EC354

	thumb_func_start ov14_021EC3A8
ov14_021EC3A8: ; 0x021EC3A8
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EC3C8
	add r0, r4, #0
	mov r1, #7
	mov r2, #0
	bl ov14_021F6AC0
	mov r0, #0x8b
	pop {r4, pc}
_021EC3C8:
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl ov14_021F6AC0
	mov r0, #0x24
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EC3A8

	thumb_func_start ov14_021EC3D8
ov14_021EC3D8: ; 0x021EC3D8
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A24
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EC4D4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC44A
	ldr r0, _021EC6F4 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EC6F8 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EC42A
	ldr r1, _021EC6FC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
_021EC42A:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0594
	pop {r3, r4, r5, pc}
_021EC44A:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EC4B4
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EC700 ; =ov14_021EA180
	add r0, r4, #0
	mov r2, #0x4c
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EC4B4:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x24
	pop {r3, r4, r5, pc}
_021EC4D4:
	add r0, r4, #0
	bl ov14_021F7388
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EC51E
	bhs _021EC5CA
	cmp r5, #0xd
	bhi _021EC512
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EC4F6: ; jump table
	.short _021EC69A - _021EC4F6 - 2 ; case 0
	.short _021EC69A - _021EC4F6 - 2 ; case 1
	.short _021EC69A - _021EC4F6 - 2 ; case 2
	.short _021EC69A - _021EC4F6 - 2 ; case 3
	.short _021EC69A - _021EC4F6 - 2 ; case 4
	.short _021EC69A - _021EC4F6 - 2 ; case 5
	.short _021EC532 - _021EC4F6 - 2 ; case 6
	.short _021EC610 - _021EC4F6 - 2 ; case 7
	.short _021EC550 - _021EC4F6 - 2 ; case 8
	.short _021EC57E - _021EC4F6 - 2 ; case 9
	.short _021EC594 - _021EC4F6 - 2 ; case 10
	.short _021EC5A6 - _021EC4F6 - 2 ; case 11
	.short _021EC5B8 - _021EC4F6 - 2 ; case 12
	.short _021EC622 - _021EC4F6 - 2 ; case 13
_021EC512:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EC51C
	b _021EC65C
_021EC51C:
	b _021EC69A
_021EC51E:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EC528
	beq _021EC610
	b _021EC69A
_021EC528:
	add r0, r1, #2
	cmp r5, r0
	bne _021EC530
	b _021EC6EE
_021EC530:
	b _021EC69A
_021EC532:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	add r0, #0x2a
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r2, #0x9d
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EC550:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	bl System_GetTouchNew
	cmp r0, #0
	bne _021EC566
	add r0, r4, #0
	mov r1, #2
	add r0, #0x2a
	strb r1, [r0]
_021EC566:
	add r0, r4, #0
	add r0, #0x21
	ldrb r1, [r0]
	add r0, r4, #0
	add r0, #0x2b
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x9d
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EC57E:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	mov r0, #9
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #4
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC594:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x98
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC5A6:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC5B8:
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC5CA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EC5E2
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EC600
_021EC5E2:
	cmp r1, #8
	beq _021EC600
	cmp r1, #9
	beq _021EC600
	cmp r1, #0xa
	beq _021EC600
	cmp r1, #0xb
	beq _021EC600
	cmp r1, #0xc
	beq _021EC600
	cmp r1, #0xd
	beq _021EC600
	add r0, r4, #0
	bl ov14_021E765C
_021EC600:
	ldr r0, _021EC708 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x4c
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EC610:
	ldr r0, _021EC70C ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x9f
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC622:
	ldr r0, _021EC708 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0x9e
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EC65C:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EC674
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EC692
_021EC674:
	cmp r1, #8
	beq _021EC692
	cmp r1, #9
	beq _021EC692
	cmp r1, #0xa
	beq _021EC692
	cmp r1, #0xb
	beq _021EC692
	cmp r1, #0xc
	beq _021EC692
	cmp r1, #0xd
	beq _021EC692
	add r0, r4, #0
	bl ov14_021E765C
_021EC692:
	ldr r0, _021EC708 ; =0x000005DC
	bl PlaySE
	b _021EC6EE
_021EC69A:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC6EE
	ldr r0, _021EC704 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EC6FC ; =ov14_021F7D3C
	add r0, r4, #0
	mov r2, #5
	bl ov14_021F5EE4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #8
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F07F0
	pop {r3, r4, r5, pc}
_021EC6EE:
	mov r0, #0x24
	pop {r3, r4, r5, pc}
	nop
_021EC6F4: .word 0x000005EB
_021EC6F8: .word 0x000040B8
_021EC6FC: .word ov14_021F7D3C
_021EC700: .word ov14_021EA180
_021EC704: .word 0x000005DD
_021EC708: .word 0x000005DC
_021EC70C: .word 0x00000633
	thumb_func_end ov14_021EC3D8

	thumb_func_start ov14_021EC710
ov14_021EC710: ; 0x021EC710
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
	ldr r1, _021EC72C ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x26
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EC72C: .word ov14_021E9518
	thumb_func_end ov14_021EC710

	thumb_func_start ov14_021EC730
ov14_021EC730: ; 0x021EC730
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021E7E98
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F43F4
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5C84
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5E94
	add r0, r4, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	bne _021EC762
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EB4
_021EC762:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EC7AE
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x21
	bl ov14_021F6AC0
	ldr r1, _021EC7D0 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x75
	bl ov14_021F0234
	pop {r4, pc}
_021EC7AE:
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x21
	bl ov14_021F6AC0
	ldr r1, _021EC7D0 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0xc
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EC7D0: .word ov14_021E94BC
	thumb_func_end ov14_021EC730

	thumb_func_start ov14_021EC7D4
ov14_021EC7D4: ; 0x021EC7D4
	push {r4, r5, r6, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	add r1, r4, #0
	add r1, #0xe4
	ldr r6, [r1]
	mov r1, #0x28
	bl ov14_021F6654
	ldr r0, _021EC850 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
	add r0, r5, #0
	bl ov14_021F08F0
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0xff
	ldr r0, [r5, #0x34]
	bne _021EC838
	add r1, r6, #0
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E7588
	b _021EC84A
_021EC838:
	ldr r0, [r0, #0x2c]
	mov r1, #8
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
_021EC84A:
	mov r0, #0x24
	pop {r4, r5, r6, pc}
	nop
_021EC850: .word 0x000005EA
	thumb_func_end ov14_021EC7D4

	thumb_func_start ov14_021EC854
ov14_021EC854: ; 0x021EC854
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r2, [r4, #0x34]
	ldr r0, _021EC8CC ; =0x0000043C
	add r1, #0x25
	str r1, [r2, r0]
	add r0, r4, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	beq _021EC8A2
	add r2, r4, #0
	add r2, #0x2b
	ldrb r2, [r2]
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F6AC0
	add r0, r4, #0
	add r0, #0x2b
	ldrb r1, [r0]
	add r0, r4, #0
	add r0, #0x21
	strb r1, [r0]
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021F1580
	mov r1, #0
	add r4, #0x2a
	strb r1, [r4]
	pop {r4, pc}
_021EC8A2:
	add r2, r4, #0
	add r2, #0x2b
	ldrb r2, [r2]
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F6AC0
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	bl ov14_021E7588
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EC8C8
	mov r0, #0x82
	pop {r4, pc}
_021EC8C8:
	mov r0, #0x29
	pop {r4, pc}
	.balign 4, 0
_021EC8CC: .word 0x0000043C
	thumb_func_end ov14_021EC854

	thumb_func_start ov14_021EC8D0
ov14_021EC8D0: ; 0x021EC8D0
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A34
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EC97E
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC928
	ldr r0, _021ECC30 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021ECC34 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F083C
	pop {r3, r4, r5, pc}
_021EC928:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	add r5, #0x1e
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EC960
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EC960:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EC97A
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EC97A:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021EC97E:
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021ECA20
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EC9CC
	ldr r0, _021ECC30 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021ECC34 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F083C
	pop {r3, r4, r5, pc}
_021EC9CC:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021ECA02
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECA02:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECA1C
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021ECA1C:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECA20:
	add r0, r4, #0
	bl ov14_021F7B7C
	cmp r0, #1
	bne _021ECA68
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r5, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ECA64
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	strb r5, [r0]
	add r0, r4, #0
	mov r1, #1
	add r0, #0x26
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0x97
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021ECA64:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECA68:
	add r0, r4, #0
	bl ov14_021F70C0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021ECAAE
	blo _021ECA7C
	b _021ECC6A
_021ECA7C:
	cmp r5, #0x2d
	bhi _021ECAA4
	sub r0, #0x24
	bmi _021ECAAC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021ECA90: ; jump table
	.short _021ECCFE - _021ECA90 - 2 ; case 0
	.short _021ECAC4 - _021ECA90 - 2 ; case 1
	.short _021ECADA - _021ECA90 - 2 ; case 2
	.short _021ECAF0 - _021ECA90 - 2 ; case 3
	.short _021ECB06 - _021ECA90 - 2 ; case 4
	.short _021ECB1C - _021ECA90 - 2 ; case 5
	.short _021ECB32 - _021ECA90 - 2 ; case 6
	.short _021ECB48 - _021ECA90 - 2 ; case 7
	.short _021ECBBA - _021ECA90 - 2 ; case 8
	.short _021ECC2A - _021ECA90 - 2 ; case 9
_021ECAA4:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021ECAC0
_021ECAAC:
	b _021ECD70
_021ECAAE:
	add r0, r1, #1
	cmp r5, r0
	bhi _021ECABA
	bne _021ECAB8
	b _021ECD1A
_021ECAB8:
	b _021ECD70
_021ECABA:
	add r0, r1, #2
	cmp r5, r0
	bne _021ECAC2
_021ECAC0:
	b _021ECD98
_021ECAC2:
	b _021ECD70
_021ECAC4:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECADA:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECAF0:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB06:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB1C:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB32:
	ldr r0, _021ECC38 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021ECB48:
	ldr r0, _021ECC3C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021ECB9C
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECB9C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECBB6
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021ECBB6:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECBBA:
	ldr r0, _021ECC3C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021ECC0C
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECC0C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECC26
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021ECC26:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
_021ECC2A:
	ldr r0, _021ECC3C ; =0x000005DC
	b _021ECC40
	nop
_021ECC30: .word 0x000005EB
_021ECC34: .word 0x000040B8
_021ECC38: .word 0x000005DD
_021ECC3C: .word 0x000005DC
_021ECC40:
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0xa0
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021ECC6A:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x25
	bhs _021ECCC4
	add r0, r4, #0
	bl ov14_021E7588
	cmp r0, #1
	ldr r1, [r4, #0x34]
	bne _021ECCA8
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #0
	bne _021ECCE6
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	b _021ECCE6
_021ECCA8:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECCE6
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
	b _021ECCE6
_021ECCC4:
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021ECCE6
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
_021ECCE6:
	ldr r0, _021ECD9C ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021ECD98
	add r0, r4, #0
	mov r1, #0x4b
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021ECCFE:
	ldr r0, _021ECDA0 ; =0x00000633
	bl PlaySE
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021ECD1A:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021ECD3C
	ldr r0, _021ECDA0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021ECD3C:
	ldr r0, _021ECD9C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	mov r1, #0x29
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021ECD70:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ECD98
	ldr r0, _021ECDA4 ; =0x000005EB
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1580
	pop {r3, r4, r5, pc}
_021ECD98:
	mov r0, #0x29
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021ECD9C: .word 0x000005DC
_021ECDA0: .word 0x00000633
_021ECDA4: .word 0x000005EB
	thumb_func_end ov14_021EC8D0

	thumb_func_start ov14_021ECDA8
ov14_021ECDA8: ; 0x021ECDA8
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r7, [r0, #0xc]
	add r0, r7, #0
	add r0, #0xe8
	ldr r6, [r0]
	add r0, r7, #0
	add r0, #0xec
	ldr r4, [r0]
	ldr r0, _021ECF50 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	mov r0, #0x80
	and r0, r6
	str r0, [sp]
	bne _021ECDE0
	add r1, r7, #0
	add r1, #0xe4
	add r7, #0xe8
	ldr r1, [r1]
	ldr r2, [r7]
	add r0, r5, #0
	bl ov14_021E6548
_021ECDE0:
	add r0, r5, #0
	bl ov14_021F08F0
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ECE04
	add r0, r5, #0
	bl ov14_021F57B8
_021ECE04:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	bne _021ECE20
	add r0, r5, #0
	bl ov14_021E765C
	b _021ECF40
_021ECE20:
	cmp r6, #0xff
	beq _021ECE3A
	ldr r0, [sp]
	cmp r0, #0
	bne _021ECE2C
	b _021ECF40
_021ECE2C:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	add r0, r5, #0
	bl ov14_021E7588
	b _021ECF40
_021ECE3A:
	add r0, r5, #0
	add r0, #0x21
	ldrb r6, [r0]
	cmp r6, #0x1e
	blo _021ECECE
	cmp r4, r6
	beq _021ECECE
	sub r6, #0x1e
	ldr r0, [r5, #8]
	add r1, r6, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021ECE82
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECE82:
	add r0, r7, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021ECEAA
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECEAA:
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021ECECE
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECECE:
	cmp r4, #0xff
	beq _021ECF40
	mov r0, #0x80
	tst r0, r4
	beq _021ECF40
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	mov r2, #0x80
	add r3, r4, #0
	eor r3, r2
	mov r2, #6
	mul r2, r0
	ldrb r1, [r5, #0x1f]
	add r0, r3, r2
	cmp r1, r0
	beq _021ECF40
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0x1e
	bhs _021ECF0E
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ECF32
_021ECF0E:
	add r0, r5, #0
	sub r1, #0x1e
	bl ov14_021E6480
	cmp r0, #1
	bne _021ECF28
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ECF32
_021ECF28:
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
_021ECF32:
	ldr r0, _021ECF54 ; =0x000005F3
	bl PlaySE
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ECF40:
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x29
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021ECF50: .word 0x000005EA
_021ECF54: .word 0x000005F3
	thumb_func_end ov14_021ECDA8

	thumb_func_start ov14_021ECF58
ov14_021ECF58: ; 0x021ECF58
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	add r0, r4, #0
	add r0, #0xe8
	ldr r6, [r0]
	ldr r0, _021ED1A0 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	mov r0, #0x80
	tst r0, r6
	bne _021ECF88
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
_021ECF88:
	add r0, r5, #0
	bl ov14_021F08F0
	add r0, r5, #0
	add r0, #0x24
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ECF9E
	add r0, r5, #0
	bl ov14_021F57B8
_021ECF9E:
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r4, r0, #0
	ldr r1, [r5, #0x34]
	ldr r0, _021ED1A4 ; =0x000088CC
	ldr r0, [r1, r0]
	cmp r0, #0
	bne _021ECFC0
	cmp r6, #0xff
	bne _021ECFC0
	add r0, r5, #0
	add r0, #0x21
	ldrb r6, [r0]
	cmp r4, r6
	bne _021ECFC2
_021ECFC0:
	b _021ED15C
_021ECFC2:
	cmp r6, #0x1e
	blo _021ED0B2
	sub r6, #0x1e
	ldr r0, [r5, #8]
	add r1, r6, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r7, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021ED022
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED022:
	add r0, r7, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021ED06C
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED06C:
	add r0, r5, #0
	add r1, r6, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021ED0B2
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED0B2:
	cmp r4, #0x25
	blo _021ED142
	cmp r4, #0x2a
	bhi _021ED142
	add r0, r5, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	add r3, r4, #0
	mov r2, #6
	ldrb r1, [r5, #0x1f]
	sub r3, #0x25
	mul r2, r0
	add r0, r3, r2
	cmp r1, r0
	beq _021ED142
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0x1e
	bhs _021ED0EE
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ED112
_021ED0EE:
	add r0, r5, #0
	sub r1, #0x1e
	bl ov14_021E6480
	cmp r0, #1
	bne _021ED108
	add r0, r5, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	b _021ED112
_021ED108:
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
_021ED112:
	ldr r0, _021ED1A8 ; =0x000005F3
	bl PlaySE
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	mov r0, #0x2c
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021ED142:
	add r0, r5, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	bne _021ED15C
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	add r0, r5, #0
	bl ov14_021E7588
_021ED15C:
	add r0, r5, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ED17E
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r5, #0
	bl ov14_021E76B8
	add r0, r5, #0
	bl ov14_021F0CD8
	pop {r3, r4, r5, r6, r7, pc}
_021ED17E:
	cmp r4, #0x25
	blo _021ED192
	cmp r4, #0x2a
	bhi _021ED192
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021ED19C
_021ED192:
	ldr r0, [r5, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED19C:
	mov r0, #0x29
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021ED1A0: .word 0x000005EA
_021ED1A4: .word 0x000088CC
_021ED1A8: .word 0x000005F3
	thumb_func_end ov14_021ECF58

	thumb_func_start ov14_021ED1AC
ov14_021ED1AC: ; 0x021ED1AC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6688
	add r0, r4, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	ldr r0, [r4, #0x34]
	beq _021ED1DA
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	bl ov14_021F0CD8
	pop {r4, pc}
_021ED1DA:
	ldr r0, [r0, #0x2c]
	mov r1, #1
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x29
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021ED1AC

	thumb_func_start ov14_021ED1E8
ov14_021ED1E8: ; 0x021ED1E8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F63B8
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021ED206
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021ED210
_021ED206:
	add r0, r4, #0
	mov r1, #1
	mov r2, #0
	bl ov14_021F3488
_021ED210:
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ED238
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
_021ED238:
	add r0, r4, #0
	mov r1, #1
	add r0, #0x24
	strb r1, [r0]
	add r0, r4, #0
	add r0, #0x29
	strb r1, [r0]
	add r0, r4, #0
	ldrb r1, [r4, #0x1f]
	add r0, #0x25
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #0x28
	bl ov14_021F1058
	pop {r4, pc}
	thumb_func_end ov14_021ED1E8

	thumb_func_start ov14_021ED258
ov14_021ED258: ; 0x021ED258
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	bl ov14_021F63A8
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021ED28A
	add r0, r4, #0
	mov r1, #7
	mov r2, #0
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	mov r0, #0x8b
	pop {r4, pc}
_021ED28A:
	add r0, r4, #0
	add r0, #0x2a
	ldrb r0, [r0]
	cmp r0, #0
	beq _021ED2A6
	add r2, r4, #0
	add r2, #0x2b
	ldrb r2, [r2]
	add r0, r4, #0
	mov r1, #5
	sub r2, #0x1e
	bl ov14_021F6AC0
	b _021ED2B0
_021ED2A6:
	add r0, r4, #0
	mov r1, #5
	mov r2, #0
	bl ov14_021F6AC0
_021ED2B0:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	mov r0, #0x24
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021ED258

	thumb_func_start ov14_021ED2C8
ov14_021ED2C8: ; 0x021ED2C8
	ldrb r2, [r0, #0x1f]
	add r1, r0, #0
	add r1, #0x25
	strb r2, [r1]
	ldr r3, _021ED2D8 ; =ov14_021F1058
	mov r1, #0x30
	bx r3
	nop
_021ED2D8: .word ov14_021F1058
	thumb_func_end ov14_021ED2C8

	thumb_func_start ov14_021ED2DC
ov14_021ED2DC: ; 0x021ED2DC
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #1
	bl ov14_021E81A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7ED0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	ldr r0, [r4, #0x34]
	bl ov14_021F63F0
	ldr r0, [r4, #0x34]
	bl ov14_021F63B8
	add r0, r4, #0
	bl ov14_021F3044
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	add r1, r4, #0
	add r1, #0x2b
	ldrb r1, [r1]
	add r0, r4, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021ED340
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
_021ED340:
	ldr r1, _021ED34C ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x28
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED34C: .word ov14_021E9518
	thumb_func_end ov14_021ED2DC

	thumb_func_start ov14_021ED350
ov14_021ED350: ; 0x021ED350
	ldr r3, _021ED358 ; =ov14_021F1090
	mov r1, #0x32
	bx r3
	nop
_021ED358: .word ov14_021F1090
	thumb_func_end ov14_021ED350

	thumb_func_start ov14_021ED35C
ov14_021ED35C: ; 0x021ED35C
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x29
	ldrb r1, [r1]
	cmp r1, #1
	bne _021ED370
	bl ov14_021F0C58
	pop {r4, pc}
_021ED370:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
	ldr r1, _021ED388 ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x33
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED388: .word ov14_021E9518
	thumb_func_end ov14_021ED35C

	thumb_func_start ov14_021ED38C
ov14_021ED38C: ; 0x021ED38C
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r1, [r5]
	ldr r1, [r1, #8]
	cmp r1, #3
	bne _021ED3A0
	mov r7, #6
	mov r6, #0x22
	mov r4, #0x75
	b _021ED3BC
_021ED3A0:
	add r1, r5, #0
	add r1, #0x2a
	ldrb r1, [r1]
	mov r7, #3
	mov r6, #0x22
	mov r4, #0xc
	cmp r1, #0
	beq _021ED3BC
	add r1, r5, #0
	add r1, #0x2b
	ldrb r6, [r1]
	add r1, r6, #0
	bl ov14_021E7588
_021ED3BC:
	add r0, r5, #0
	add r1, r7, #0
	add r2, r6, #0
	bl ov14_021F6AC0
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5C84
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5E94
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021ED410 ; =ov14_021E94BC
	add r0, r5, #0
	add r2, r4, #0
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021ED410: .word ov14_021E94BC
	thumb_func_end ov14_021ED38C

	thumb_func_start ov14_021ED414
ov14_021ED414: ; 0x021ED414
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #3
	mvn r1, r1
	cmp r0, r1
	bhi _021ED454
	blo _021ED42C
	b _021ED57C
_021ED42C:
	cmp r0, #0xb
	bhi _021ED45E
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021ED43C: ; jump table
	.short _021ED46A - _021ED43C - 2 ; case 0
	.short _021ED47A - _021ED43C - 2 ; case 1
	.short _021ED48A - _021ED43C - 2 ; case 2
	.short _021ED49A - _021ED43C - 2 ; case 3
	.short _021ED4AA - _021ED43C - 2 ; case 4
	.short _021ED4BA - _021ED43C - 2 ; case 5
	.short _021ED4CA - _021ED43C - 2 ; case 6
	.short _021ED4DC - _021ED43C - 2 ; case 7
	.short _021ED4EC - _021ED43C - 2 ; case 8
	.short _021ED526 - _021ED43C - 2 ; case 9
	.short _021ED542 - _021ED43C - 2 ; case 10
	.short _021ED584 - _021ED43C - 2 ; case 11
_021ED454:
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021ED460
	beq _021ED55E
_021ED45E:
	b _021ED5A0
_021ED460:
	add r1, r1, #1
	cmp r0, r1
	bne _021ED468
	b _021ED58E
_021ED468:
	b _021ED5A0
_021ED46A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F1170
	pop {r4, pc}
_021ED47A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1170
	pop {r4, pc}
_021ED48A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F1170
	pop {r4, pc}
_021ED49A:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F1170
	pop {r4, pc}
_021ED4AA:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F1170
	pop {r4, pc}
_021ED4BA:
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F1170
	pop {r4, pc}
_021ED4CA:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F11F8
	pop {r4, pc}
_021ED4DC:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F11F8
	pop {r4, pc}
_021ED4EC:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	add r0, #0x25
	ldrb r1, [r4, #0x1f]
	ldrb r0, [r0]
	cmp r1, r0
	bne _021ED514
	ldr r0, _021ED5AC ; =0x000005F3
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0x3d
	bl ov14_021F2270
	pop {r4, pc}
_021ED514:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xc
	mov r2, #0xa2
	bl ov14_021F2270
	pop {r4, pc}
_021ED526:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #6
	mov r2, #0xa3
	bl ov14_021F2270
	pop {r4, pc}
_021ED542:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, _021ED5A4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0xa4
	bl ov14_021F2270
	pop {r4, pc}
_021ED55E:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021ED5A0
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x3e
	bl ov14_021F0244
	pop {r4, pc}
_021ED57C:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	b _021ED5A0
_021ED584:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED58E:
	ldr r0, _021ED5A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x39
	bl ov14_021F2270
	pop {r4, pc}
_021ED5A0:
	mov r0, #0x3d
	pop {r4, pc}
	.balign 4, 0
_021ED5A4: .word 0x000005DD
_021ED5A8: .word 0x000005DC
_021ED5AC: .word 0x000005F3
	thumb_func_end ov14_021ED414

	thumb_func_start ov14_021ED5B0
ov14_021ED5B0: ; 0x021ED5B0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	ldr r1, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021ED5DA
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E834C
	cmp r0, #0
	bne _021ED5FC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	b _021ED5FC
_021ED5DA:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8234
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8294
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
_021ED5FC:
	ldr r1, _021ED608 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x35
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED608: .word ov14_021E94BC
	thumb_func_end ov14_021ED5B0

	thumb_func_start ov14_021ED60C
ov14_021ED60C: ; 0x021ED60C
	ldrb r2, [r0, #0x1f]
	add r1, r0, #0
	add r1, #0x25
	strb r2, [r1]
	ldr r3, _021ED61C ; =ov14_021F1058
	mov r1, #0x36
	bx r3
	nop
_021ED61C: .word ov14_021F1058
	thumb_func_end ov14_021ED60C

	thumb_func_start ov14_021ED620
ov14_021ED620: ; 0x021ED620
	ldr r3, _021ED628 ; =ov14_021F10B4
	mov r1, #0x37
	bx r3
	nop
_021ED628: .word ov14_021F10B4
	thumb_func_end ov14_021ED620

	thumb_func_start ov14_021ED62C
ov14_021ED62C: ; 0x021ED62C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F6070
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E875C
	ldr r1, _021ED64C ; =ov14_021E9618
	add r0, r4, #0
	mov r2, #0x38
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED64C: .word ov14_021E9618
	thumb_func_end ov14_021ED62C

	thumb_func_start ov14_021ED650
ov14_021ED650: ; 0x021ED650
	push {r4, lr}
	add r4, r0, #0
	ldr r2, [r4, #0x2c]
	mov r1, #9
	bl ov14_021F6AC0
	ldr r0, [r4, #0x2c]
	cmp r0, #5
	ldr r0, [r4, #0x34]
	bhi _021ED66E
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	b _021ED676
_021ED66E:
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED676:
	add r0, r4, #0
	mov r1, #0
	mov r2, #0x27
	bl ov14_021F6844
	mov r0, #0x3d
	pop {r4, pc}
	thumb_func_end ov14_021ED650

	thumb_func_start ov14_021ED684
ov14_021ED684: ; 0x021ED684
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #0x3a
	bl ov14_021F10DC
	pop {r4, pc}
	thumb_func_end ov14_021ED684

	thumb_func_start ov14_021ED6A4
ov14_021ED6A4: ; 0x021ED6A4
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E87BC
	ldr r1, _021ED6C0 ; =ov14_021E9618
	add r0, r4, #0
	mov r2, #0x3b
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED6C0: .word ov14_021E9618
	thumb_func_end ov14_021ED6A4

	thumb_func_start ov14_021ED6C4
ov14_021ED6C4: ; 0x021ED6C4
	ldr r3, _021ED6CC ; =ov14_021F1090
	mov r1, #0x3c
	bx r3
	nop
_021ED6CC: .word ov14_021F1090
	thumb_func_end ov14_021ED6C4

	thumb_func_start ov14_021ED6D0
ov14_021ED6D0: ; 0x021ED6D0
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #1
	bne _021ED71A
	add r0, r4, #0
	mov r1, #2
	mov r2, #0x1e
	bl ov14_021F6AC0
	ldr r1, _021ED758 ; =ov14_021E95B4
	add r0, r4, #0
	mov r2, #0x52
	bl ov14_021F0234
	pop {r4, pc}
_021ED71A:
	cmp r0, #3
	bne _021ED72A
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x1e
	bl ov14_021F6AC0
	b _021ED734
_021ED72A:
	add r0, r4, #0
	mov r1, #3
	mov r2, #0x1e
	bl ov14_021F6AC0
_021ED734:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	ldr r1, _021ED75C ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x4d
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED758: .word ov14_021E95B4
_021ED75C: .word ov14_021E94BC
	thumb_func_end ov14_021ED6D0

	thumb_func_start ov14_021ED760
ov14_021ED760: ; 0x021ED760
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x25
	ldrb r1, [r1]
	bl ov14_021E7930
	ldr r2, [r4, #0x34]
	ldr r1, _021ED7B0 ; =0x0000044D
	strb r0, [r2, r1]
	add r0, r4, #0
	bl ov14_021F4428
	add r0, r4, #0
	bl ov14_021F4530
	add r0, r4, #0
	bl ov14_021F459C
	add r0, r4, #0
	bl ov14_021F58B8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E87BC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E81B4
	ldr r1, _021ED7B4 ; =ov14_021E9660
	add r0, r4, #0
	mov r2, #0x40
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED7B0: .word 0x0000044D
_021ED7B4: .word ov14_021E9660
	thumb_func_end ov14_021ED760

	thumb_func_start ov14_021ED7B8
ov14_021ED7B8: ; 0x021ED7B8
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F6094
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8560
	ldr r1, _021ED7D8 ; =ov14_021E95C8
	add r0, r4, #0
	mov r2, #0x41
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED7D8: .word ov14_021E95C8
	thumb_func_end ov14_021ED7B8

	thumb_func_start ov14_021ED7DC
ov14_021ED7DC: ; 0x021ED7DC
	push {r4, r5, r6, lr}
	add r4, r0, #0
	ldr r1, [r4, #0x34]
	ldr r2, _021ED81C ; =0x0000044D
	ldrb r3, [r1, r2]
	lsr r6, r3, #0x1f
	lsl r5, r3, #0x1e
	sub r5, r5, r6
	mov r3, #0x1e
	ror r5, r3
	add r3, r2, #0
	add r5, r6, r5
	sub r3, #0x11
	str r5, [r1, r3]
	ldr r3, [r4, #0x34]
	sub r2, #0x11
	ldr r2, [r3, r2]
	mov r1, #0xa
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	add r0, r4, #0
	mov r1, #1
	mov r2, #0x27
	bl ov14_021F6844
	mov r0, #0x42
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021ED81C: .word 0x0000044D
	thumb_func_end ov14_021ED7DC

	thumb_func_start ov14_021ED820
ov14_021ED820: ; 0x021ED820
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021ED856
	bhs _021ED8E0
	cmp r0, #7
	bhi _021ED914
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021ED846: ; jump table
	.short _021ED860 - _021ED846 - 2 ; case 0
	.short _021ED872 - _021ED846 - 2 ; case 1
	.short _021ED884 - _021ED846 - 2 ; case 2
	.short _021ED896 - _021ED846 - 2 ; case 3
	.short _021ED8A8 - _021ED846 - 2 ; case 4
	.short _021ED8BC - _021ED846 - 2 ; case 5
	.short _021ED8CE - _021ED846 - 2 ; case 6
	.short _021ED8F8 - _021ED846 - 2 ; case 7
_021ED856:
	mov r1, #1
	mvn r1, r1
	cmp r0, r1
	beq _021ED902
	b _021ED914
_021ED860:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED872:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED884:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED896:
	ldr r0, _021ED918 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F129C
	mov r0, #0x42
	pop {r4, pc}
_021ED8A8:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1228
	mov r0, #0x42
	pop {r4, pc}
_021ED8BC:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1228
	mov r0, #0x42
	pop {r4, pc}
_021ED8CE:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	add r0, r4, #0
	bl ov14_021F131C
	pop {r4, pc}
_021ED8E0:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021ED914
	add r0, r4, #0
	mov r1, #0x49
	bl ov14_021F0244
	pop {r4, pc}
_021ED8F8:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021ED902:
	ldr r0, _021ED91C ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0xa6
	bl ov14_021F2270
	pop {r4, pc}
_021ED914:
	mov r0, #0x42
	pop {r4, pc}
	.balign 4, 0
_021ED918: .word 0x000005DD
_021ED91C: .word 0x000005DC
	thumb_func_end ov14_021ED820

	thumb_func_start ov14_021ED920
ov14_021ED920: ; 0x021ED920
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8588
	ldr r1, _021ED93C ; =ov14_021E9604
	add r0, r4, #0
	mov r2, #0x44
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED93C: .word ov14_021E9604
	thumb_func_end ov14_021ED920

	thumb_func_start ov14_021ED940
ov14_021ED940: ; 0x021ED940
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E81D8
	ldr r1, _021ED95C ; =ov14_021E96A8
	add r0, r4, #0
	mov r2, #0x45
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021ED95C: .word ov14_021E96A8
	thumb_func_end ov14_021ED940

	thumb_func_start ov14_021ED960
ov14_021ED960: ; 0x021ED960
	ldr r3, _021ED968 ; =ov14_021F1058
	mov r1, #0x37
	bx r3
	nop
_021ED968: .word ov14_021F1058
	thumb_func_end ov14_021ED960

	thumb_func_start ov14_021ED96C
ov14_021ED96C: ; 0x021ED96C
	push {r4, lr}
	add r4, r0, #0
	ldr r2, [r4, #0x34]
	ldr r1, _021ED9A8 ; =0x0000044D
	ldrb r1, [r2, r1]
	bl ov14_021E78AC
	ldr r1, [r4, #0x34]
	ldr r0, _021ED9A8 ; =0x0000044D
	ldrb r2, [r1, r0]
	ldr r0, [r4, #4]
	cmp r2, #0x10
	bhs _021ED98E
	ldrb r1, [r4, #0x1f]
	bl PCStorage_SetBoxWallpaper
	b _021ED996
_021ED98E:
	ldrb r1, [r4, #0x1f]
	add r2, #0x10
	bl PCStorage_SetBoxWallpaper
_021ED996:
	add r0, r4, #0
	bl ov14_021F4530
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021F4958
	mov r0, #0x48
	pop {r4, pc}
	.balign 4, 0
_021ED9A8: .word 0x0000044D
	thumb_func_end ov14_021ED96C

	thumb_func_start ov14_021ED9AC
ov14_021ED9AC: ; 0x021ED9AC
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0
	mov r3, #2
	ldr r0, [r0, #0x18]
	add r2, r1, #0
	lsl r3, r3, #8
	bl PaletteData_LoadPaletteSlotFromHardware
	mov r3, #0
	mov r2, #3
	str r3, [sp]
	mov r0, #0x10
	str r0, [sp, #4]
	ldr r0, _021ED9E8 ; =0x00007FFF
	mov r1, #1
	str r0, [sp, #8]
	ldr r0, [r4, #0x34]
	lsl r2, r2, #0xe
	ldr r0, [r0, #0x18]
	bl PaletteData_BeginPaletteFade
	mov r0, #0x46
	str r0, [r4, #0x30]
	mov r0, #3
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_021ED9E8: .word 0x00007FFF
	thumb_func_end ov14_021ED9AC

	thumb_func_start ov14_021ED9EC
ov14_021ED9EC: ; 0x021ED9EC
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r3, #0
	ldr r0, _021EDA18 ; =0x00007FFF
	str r3, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #0x34]
	mov r2, #3
	ldr r0, [r0, #0x18]
	mov r1, #1
	lsl r2, r2, #0xe
	bl PaletteData_BeginPaletteFade
	mov r0, #0x42
	str r0, [r4, #0x30]
	mov r0, #3
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_021EDA18: .word 0x00007FFF
	thumb_func_end ov14_021ED9EC

	thumb_func_start ov14_021EDA1C
ov14_021EDA1C: ; 0x021EDA1C
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r4]
	ldr r0, [r0, #8]
	cmp r0, #3
	bne _021EDA36
	mov r0, #0x75
	pop {r4, pc}
_021EDA36:
	mov r0, #0xc
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EDA1C

	thumb_func_start ov14_021EDA3C
ov14_021EDA3C: ; 0x021EDA3C
	push {r3, lr}
	ldr r0, [r0, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #0x24
	pop {r3, pc}
	thumb_func_end ov14_021EDA3C

	thumb_func_start ov14_021EDA4C
ov14_021EDA4C: ; 0x021EDA4C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EDB3C
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EDAB8
	ldr r2, [r4, #0x34]
	ldr r1, _021EDDA4 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EDA96
	ldr r1, _021EDDA8 ; =ov14_021F7D2C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
_021EDA96:
	ldr r0, _021EDDAC ; =0x000005EB
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0418
	pop {r3, r4, r5, pc}
_021EDAB8:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EDB1C
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EDDB0 ; =ov14_021EA130
	add r0, r4, #0
	mov r2, #0x59
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EDB1C:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x51
	pop {r3, r4, r5, pc}
_021EDB3C:
	add r0, r4, #0
	bl ov14_021F6E8C
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EDB82
	blo _021EDB50
	b _021EDCBA
_021EDB50:
	cmp r5, #0x26
	bhi _021EDB76
	sub r0, #0x1e
	bmi _021EDB80
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EDB64: ; jump table
	.short _021EDC32 - _021EDB64 - 2 ; case 0
	.short _021EDC4E - _021EDB64 - 2 ; case 1
	.short _021EDC84 - _021EDB64 - 2 ; case 2
	.short _021EDCFA - _021EDB64 - 2 ; case 3
	.short _021EDB98 - _021EDB64 - 2 ; case 4
	.short _021EDBBC - _021EDB64 - 2 ; case 5
	.short _021EDBD2 - _021EDB64 - 2 ; case 6
	.short _021EDBEC - _021EDB64 - 2 ; case 7
	.short _021EDBFE - _021EDB64 - 2 ; case 8
_021EDB76:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EDB80
	b _021EDD6C
_021EDB80:
	b _021EDDC4
_021EDB82:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EDB8E
	bne _021EDB8C
	b _021EDD12
_021EDB8C:
	b _021EDDC4
_021EDB8E:
	add r0, r1, #2
	cmp r5, r0
	bne _021EDB96
	b _021EDD24
_021EDB96:
	b _021EDDC4
_021EDB98:
	ldr r0, [r4, #8]
	bl Party_GetCount
	cmp r0, #6
	beq _021EDBAA
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	b _021EDBB0
_021EDBAA:
	ldr r0, _021EDDB8 ; =0x000005F3
	bl PlaySE
_021EDBB0:
	add r0, r4, #0
	mov r1, #4
	mov r2, #0xa7
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBBC:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	mov r0, #0x23
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBD2:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBEC:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDBFE:
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xa8
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDC32:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	bl ov14_021F1128
	pop {r3, r4, r5, pc}
_021EDC4E:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EDC84:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EDCBA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EDCD0
	add r0, r4, #0
	bl ov14_021E7588
	b _021EDCEA
_021EDCD0:
	cmp r1, #0x22
	beq _021EDCEA
	cmp r1, #0x23
	beq _021EDCEA
	cmp r1, #0x24
	beq _021EDCEA
	cmp r1, #0x25
	beq _021EDCEA
	cmp r1, #0x26
	beq _021EDCEA
	add r0, r4, #0
	bl ov14_021E765C
_021EDCEA:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x58
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EDCFA:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDD12:
	ldr r0, _021EDDB4 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EDD24:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	cmp r0, #0x1e
	bne _021EDE12
	ldr r0, _021EDDC0 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _021EDD50
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EDD50:
	mov r0, #0x10
	tst r0, r1
	beq _021EDE12
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x51
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EDD6C:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EDD82
	add r0, r4, #0
	bl ov14_021E7588
	b _021EDD9C
_021EDD82:
	cmp r1, #0x22
	beq _021EDD9C
	cmp r1, #0x23
	beq _021EDD9C
	cmp r1, #0x24
	beq _021EDD9C
	cmp r1, #0x25
	beq _021EDD9C
	cmp r1, #0x26
	beq _021EDD9C
	add r0, r4, #0
	bl ov14_021E765C
_021EDD9C:
	ldr r0, _021EDDBC ; =0x000005DC
	bl PlaySE
	b _021EDE12
	.balign 4, 0
_021EDDA4: .word 0x000040B8
_021EDDA8: .word ov14_021F7D2C
_021EDDAC: .word 0x000005EB
_021EDDB0: .word ov14_021EA130
_021EDDB4: .word 0x000005DD
_021EDDB8: .word 0x000005F3
_021EDDBC: .word 0x000005DC
_021EDDC0: .word gSystem
_021EDDC4:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EDE12
	ldr r0, _021EDE18 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EDE1C ; =ov14_021F7D2C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x22
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #0x22
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F04D4
	pop {r3, r4, r5, pc}
_021EDE12:
	mov r0, #0x51
	pop {r3, r4, r5, pc}
	nop
_021EDE18: .word 0x000005DD
_021EDE1C: .word ov14_021F7D2C
	thumb_func_end ov14_021EDA4C

	thumb_func_start ov14_021EDE20
ov14_021EDE20: ; 0x021EDE20
	push {r4, lr}
	mov r1, #0
	add r4, r0, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	bl ov14_021EDF90
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EDE20

	thumb_func_start ov14_021EDE38
ov14_021EDE38: ; 0x021EDE38
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F3044
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7ED0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	add r0, r4, #0
	mov r1, #2
	add r0, #0x22
	strb r1, [r0]
	ldr r1, _021EDE6C ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x54
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EDE6C: .word ov14_021E9518
	thumb_func_end ov14_021EDE38

	thumb_func_start ov14_021EDE70
ov14_021EDE70: ; 0x021EDE70
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F08BC
	ldr r1, _021EDE84 ; =ov14_021E91E0
	add r0, r4, #0
	mov r2, #0x55
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EDE84: .word ov14_021E91E0
	thumb_func_end ov14_021EDE70

	thumb_func_start ov14_021EDE88
ov14_021EDE88: ; 0x021EDE88
	push {r3, r4, lr}
	sub sp, #4
	add r4, r0, #0
	ldr r0, _021EDF00 ; =0x000005EA
	bl PlaySE
	add r1, r4, #0
	ldr r0, [r4, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r1, r4, #0
	ldr r0, [r4, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	add r0, r4, #0
	mov r1, #0xff
	add r0, #0x21
	strb r1, [r0]
	add r0, r4, #0
	bl ov14_021E637C
	add r0, r4, #0
	bl ov14_021F08F0
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7F4C
	ldr r1, _021EDF04 ; =ov14_021E9518
	add r0, r4, #0
	mov r2, #0x56
	bl ov14_021F0234
	add sp, #4
	pop {r3, r4, pc}
	.balign 4, 0
_021EDF00: .word 0x000005EA
_021EDF04: .word ov14_021E9518
	thumb_func_end ov14_021EDE88

	thumb_func_start ov14_021EDF08
ov14_021EDF08: ; 0x021EDF08
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021EDF24 ; =ov14_021E95B4
	add r0, r4, #0
	mov r2, #0x52
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EDF24: .word ov14_021E95B4
	thumb_func_end ov14_021EDF08

	thumb_func_start ov14_021EDF28
ov14_021EDF28: ; 0x021EDF28
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0xc]
	add r0, #0xe4
	ldr r4, [r0]
	ldr r0, _021EDF8C ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r0, r5, #0
	bl ov14_021F08F0
	ldr r0, [r5, #0x34]
	mov r1, #0x28
	bl ov14_021F6678
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0xff
	bne _021EDF66
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	b _021EDF72
_021EDF66:
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	mov r4, #0x22
_021EDF72:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x51
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EDF8C: .word 0x000005EA
	thumb_func_end ov14_021EDF28

	thumb_func_start ov14_021EDF90
ov14_021EDF90: ; 0x021EDF90
	push {r3, lr}
	ldr r0, [r0, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	mov r0, #0x51
	pop {r3, pc}
	thumb_func_end ov14_021EDF90

	thumb_func_start ov14_021EDFA0
ov14_021EDFA0: ; 0x021EDFA0
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A24
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EE0A4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EE012
	ldr r2, [r4, #0x34]
	ldr r1, _021EE254 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #0
	bne _021EDFEC
	ldr r1, _021EE258 ; =ov14_021F7D1C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
_021EDFEC:
	ldr r0, _021EE25C ; =0x000005EB
	bl PlaySE
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0660
	pop {r3, r4, r5, pc}
_021EE012:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EE084
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r4, #0x34]
	bl ov14_021E884C
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F40E8
	ldr r1, _021EE260 ; =ov14_021EA130
	add r0, r4, #0
	mov r2, #0x70
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EE084:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
_021EE0A4:
	add r0, r4, #0
	bl ov14_021F6BC0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EE0E8
	bhs _021EE1AA
	cmp r5, #0xb
	bhi _021EE0DE
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EE0C6: ; jump table
	.short _021EE1FA - _021EE0C6 - 2 ; case 0
	.short _021EE1FA - _021EE0C6 - 2 ; case 1
	.short _021EE1FA - _021EE0C6 - 2 ; case 2
	.short _021EE1FA - _021EE0C6 - 2 ; case 3
	.short _021EE1FA - _021EE0C6 - 2 ; case 4
	.short _021EE1FA - _021EE0C6 - 2 ; case 5
	.short _021EE1D0 - _021EE0C6 - 2 ; case 6
	.short _021EE0FC - _021EE0C6 - 2 ; case 7
	.short _021EE10E - _021EE0C6 - 2 ; case 8
	.short _021EE124 - _021EE0C6 - 2 ; case 9
	.short _021EE13E - _021EE0C6 - 2 ; case 10
	.short _021EE150 - _021EE0C6 - 2 ; case 11
_021EE0DE:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021EE18A
	b _021EE1FA
_021EE0E8:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EE0F2
	beq _021EE1E8
	b _021EE1FA
_021EE0F2:
	add r0, r1, #2
	cmp r5, r0
	bne _021EE0FA
	b _021EE24E
_021EE0FA:
	b _021EE1FA
_021EE0FC:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #4
	mov r2, #0xa9
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE10E:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	mov r0, #8
	str r0, [r4, #0x2c]
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x97
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE124:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #6
	mov r2, #0x99
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE13E:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x9b
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE150:
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, _021EE268 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xaa
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE18A:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #6
	bhi _021EE1A0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
_021EE1A0:
	ldr r0, _021EE268 ; =0x000005DC
	bl PlaySE
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
_021EE1AA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #6
	bhi _021EE1C0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
_021EE1C0:
	ldr r0, _021EE268 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x6f
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EE1D0:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE1E8:
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EE1FA:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EE24E
	ldr r0, _021EE264 ; =0x000005DD
	bl PlaySE
	ldr r1, _021EE258 ; =ov14_021F7D1C
	add r0, r4, #0
	mov r2, #4
	bl ov14_021F5EE4
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #7
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #7
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F0794
	pop {r3, r4, r5, pc}
_021EE24E:
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
	nop
_021EE254: .word 0x000040B8
_021EE258: .word ov14_021F7D1C
_021EE25C: .word 0x000005EB
_021EE260: .word ov14_021EA130
_021EE264: .word 0x000005DD
_021EE268: .word 0x000005DC
	thumb_func_end ov14_021EDFA0

	thumb_func_start ov14_021EE26C
ov14_021EE26C: ; 0x021EE26C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r4, [r1]
	sub r4, #0x1e
	add r1, r4, #0
	bl ov14_021E6480
	cmp r0, #0
	bne _021EE29A
	ldr r0, _021EE320 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #6
	mov r2, #0x25
	bl ov14_021F67B0
	mov r0, #0x5d
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EE29A:
	ldr r0, [r5, #8]
	add r1, r4, #0
	bl Party_GetMonByIndex
	mov r1, #6
	mov r2, #0
	add r4, r0, #0
	bl GetMonData
	lsl r0, r0, #0x10
	lsr r0, r0, #0x10
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EE2D2
	ldr r0, _021EE320 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #6
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x5d
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EE2D2:
	add r0, r4, #0
	mov r1, #0xa2
	mov r2, #0
	bl GetMonData
	cmp r0, #0
	beq _021EE2FA
	ldr r0, _021EE320 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0
	mov r2, #5
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x5d
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EE2FA:
	ldrb r1, [r5, #0x1f]
	add r0, r5, #0
	add r0, #0x25
	strb r1, [r0]
	add r0, r5, #0
	mov r1, #2
	mov r2, #1
	bl ov14_021F3488
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r1, _021EE324 ; =ov14_021E96C8
	add r0, r5, #0
	mov r2, #0x5e
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EE320: .word 0x000005F3
_021EE324: .word ov14_021E96C8
	thumb_func_end ov14_021EE26C

	thumb_func_start ov14_021EE328
ov14_021EE328: ; 0x021EE328
	ldr r3, _021EE330 ; =ov14_021F0234
	ldr r1, _021EE334 ; =ov14_021E9450
	mov r2, #0xe
	bx r3
	.balign 4, 0
_021EE330: .word ov14_021F0234
_021EE334: .word ov14_021E9450
	thumb_func_end ov14_021EE328

	thumb_func_start ov14_021EE338
ov14_021EE338: ; 0x021EE338
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F4BC0
	add r0, r4, #0
	bl ov14_021F4848
	add r0, r4, #0
	bl ov14_021F48B4
	add r0, r4, #0
	bl ov14_021F57B8
	add r0, r4, #0
	mov r1, #0x5f
	bl ov14_021F10B4
	pop {r4, pc}
	thumb_func_end ov14_021EE338

	thumb_func_start ov14_021EE35C
ov14_021EE35C: ; 0x021EE35C
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F60A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8560
	ldr r1, _021EE37C ; =ov14_021E95C8
	add r0, r4, #0
	mov r2, #0x60
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE37C: .word ov14_021E95C8
	thumb_func_end ov14_021EE35C

	thumb_func_start ov14_021EE380
ov14_021EE380: ; 0x021EE380
	push {r4, lr}
	add r4, r0, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	ldr r2, _021EE3C4 ; =0x0000043C
	str r1, [r0, r2]
	ldr r3, [r4, #0x34]
	add r0, r4, #0
	ldr r2, [r3, r2]
	mov r1, #1
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0xe
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	add r0, r4, #0
	mov r1, #0
	mov r2, #3
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x61
	pop {r4, pc}
	nop
_021EE3C4: .word 0x0000043C
	thumb_func_end ov14_021EE380

	thumb_func_start ov14_021EE3C8
ov14_021EE3C8: ; 0x021EE3C8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_HandleInput_AllowHold
	mov r1, #2
	mvn r1, r1
	cmp r0, r1
	bhi _021EE402
	bhs _021EE472
	cmp r0, #9
	bhi _021EE4A4
	add r1, r0, r0
	add r1, pc
	ldrh r1, [r1, #6]
	lsl r1, r1, #0x10
	asr r1, r1, #0x10
	add pc, r1
_021EE3EE: ; jump table
	.short _021EE40C - _021EE3EE - 2 ; case 0
	.short _021EE416 - _021EE3EE - 2 ; case 1
	.short _021EE420 - _021EE3EE - 2 ; case 2
	.short _021EE42A - _021EE3EE - 2 ; case 3
	.short _021EE434 - _021EE3EE - 2 ; case 4
	.short _021EE43E - _021EE3EE - 2 ; case 5
	.short _021EE448 - _021EE3EE - 2 ; case 6
	.short _021EE45A - _021EE3EE - 2 ; case 7
	.short _021EE46A - _021EE3EE - 2 ; case 8
	.short _021EE48A - _021EE3EE - 2 ; case 9
_021EE402:
	mov r1, #1
	mvn r1, r1
	cmp r0, r1
	beq _021EE494
	b _021EE4A4
_021EE40C:
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F1448
	pop {r4, pc}
_021EE416:
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1448
	pop {r4, pc}
_021EE420:
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F1448
	pop {r4, pc}
_021EE42A:
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F1448
	pop {r4, pc}
_021EE434:
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F1448
	pop {r4, pc}
_021EE43E:
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F1448
	pop {r4, pc}
_021EE448:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1504
	pop {r4, pc}
_021EE45A:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1504
	pop {r4, pc}
_021EE46A:
	add r0, r4, #0
	bl ov14_021F1540
	pop {r4, pc}
_021EE472:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021EE4A4
	add r0, r4, #0
	mov r1, #0x71
	bl ov14_021F0244
	pop {r4, pc}
_021EE48A:
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
_021EE494:
	ldr r0, _021EE4A8 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F1534
	pop {r4, pc}
_021EE4A4:
	mov r0, #0x61
	pop {r4, pc}
	.balign 4, 0
_021EE4A8: .word 0x000005DC
	thumb_func_end ov14_021EE3C8

	thumb_func_start ov14_021EE4AC
ov14_021EE4AC: ; 0x021EE4AC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8588
	ldr r1, _021EE4D4 ; =ov14_021E9604
	add r0, r4, #0
	mov r2, #0x63
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EE4D4: .word ov14_021E9604
	thumb_func_end ov14_021EE4AC

	thumb_func_start ov14_021EE4D8
ov14_021EE4D8: ; 0x021EE4D8
	ldr r3, _021EE4E0 ; =ov14_021F10DC
	mov r1, #0x64
	bx r3
	nop
_021EE4E0: .word ov14_021F10DC
	thumb_func_end ov14_021EE4D8

	thumb_func_start ov14_021EE4E4
ov14_021EE4E4: ; 0x021EE4E4
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F4CA0
	ldr r1, _021EE4F8 ; =ov14_021E98AC
	add r0, r4, #0
	mov r2, #0x65
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE4F8: .word ov14_021E98AC
	thumb_func_end ov14_021EE4E4

	thumb_func_start ov14_021EE4FC
ov14_021EE4FC: ; 0x021EE4FC
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	mov r2, #7
	bl ov14_021F6AC0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	bl ov14_021F3F6C
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F40E8
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	mov r0, #0xe
	pop {r4, pc}
	thumb_func_end ov14_021EE4FC

	thumb_func_start ov14_021EE538
ov14_021EE538: ; 0x021EE538
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8588
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8314
	ldr r1, _021EE574 ; =ov14_021E99F0
	add r0, r4, #0
	mov r2, #0x67
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE574: .word ov14_021E99F0
	thumb_func_end ov14_021EE538

	thumb_func_start ov14_021EE578
ov14_021EE578: ; 0x021EE578
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x25
	ldrb r1, [r1]
	ldr r0, [r4, #4]
	bl PCStorage_CountMonsAndEggsInBox
	cmp r0, #0x1e
	bne _021EE5A0
	add r0, r4, #0
	mov r1, #0
	mov r2, #4
	mov r3, #0x25
	bl ov14_021F685C
	mov r0, #0x5e
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
_021EE5A0:
	add r0, r4, #0
	mov r1, #2
	mov r2, #0
	bl ov14_021F3488
	ldr r0, [r4, #0x34]
	mov r1, #0x27
	bl ov14_021F6654
	add r0, r4, #0
	bl ov14_021F4CA0
	ldr r1, _021EE5C4 ; =ov14_021E98AC
	add r0, r4, #0
	mov r2, #0x68
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE5C4: .word ov14_021E98AC
	thumb_func_end ov14_021EE578

	thumb_func_start ov14_021EE5C8
ov14_021EE5C8: ; 0x021EE5C8
	push {r4, lr}
	add r4, r0, #0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8048
	ldr r1, _021EE5E4 ; =ov14_021E952C
	add r0, r4, #0
	mov r2, #0x69
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE5E4: .word ov14_021E952C
	thumb_func_end ov14_021EE5C8

	thumb_func_start ov14_021EE5E8
ov14_021EE5E8: ; 0x021EE5E8
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x25
	ldrb r2, [r4, #0x1f]
	ldrb r1, [r1]
	strb r1, [r4, #0x1f]
	add r1, r4, #0
	add r1, #0x25
	ldrb r1, [r1]
	cmp r2, r1
	bne _021EE604
	mov r0, #0x6a
	pop {r4, pc}
_021EE604:
	cmp r2, r1
	ldrb r1, [r4, #0x1f]
	bls _021EE62E
	bl ov14_021F2DE8
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021E7930
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #0
	bl ov14_021E783C
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r1, _021EE65C ; =ov14_021E92AC
	b _021EE650
_021EE62E:
	bl ov14_021F2DE8
	ldrb r1, [r4, #0x1f]
	add r0, r4, #0
	bl ov14_021E7930
	add r1, r0, #0
	add r0, r4, #0
	mov r2, #1
	bl ov14_021E783C
	ldr r0, [r4, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r1, _021EE660 ; =ov14_021E9370
_021EE650:
	add r0, r4, #0
	mov r2, #0x6a
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EE65C: .word ov14_021E92AC
_021EE660: .word ov14_021E9370
	thumb_func_end ov14_021EE5E8

	thumb_func_start ov14_021EE664
ov14_021EE664: ; 0x021EE664
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	mov r2, #2
	add r1, #0x22
	strb r2, [r1]
	bl ov14_021F08BC
	ldr r1, _021EE680 ; =ov14_021E9234
	add r0, r4, #0
	mov r2, #0x6b
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EE680: .word ov14_021E9234
	thumb_func_end ov14_021EE664

	thumb_func_start ov14_021EE684
ov14_021EE684: ; 0x021EE684
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	ldr r0, _021EE6C8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
	add r0, r5, #0
	bl ov14_021F08F0
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8094
	ldr r1, _021EE6CC ; =ov14_021E954C
	add r0, r5, #0
	mov r2, #0x6c
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EE6C8: .word 0x000005EA
_021EE6CC: .word ov14_021E954C
	thumb_func_end ov14_021EE684

	thumb_func_start ov14_021EE6D0
ov14_021EE6D0: ; 0x021EE6D0
	push {r4, lr}
	add r4, r0, #0
	mov r1, #0
	bl ov14_021F5EB4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021EE6F4 ; =ov14_021E95B4
	add r0, r4, #0
	mov r2, #0x6d
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EE6F4: .word ov14_021E95B4
	thumb_func_end ov14_021EE6D0

	thumb_func_start ov14_021EE6F8
ov14_021EE6F8: ; 0x021EE6F8
	push {r4, lr}
	mov r1, #0
	add r2, r1, #0
	add r4, r0, #0
	bl ov14_021F6AC0
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	add r0, r4, #0
	mov r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #8
	bl ov14_021F29E4
	mov r0, #0x5b
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE6F8

	thumb_func_start ov14_021EE728
ov14_021EE728: ; 0x021EE728
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	ldr r4, [r0, #0xc]
	ldr r0, _021EE7B0 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021E637C
	add r1, r4, #0
	add r1, #0xe4
	add r4, #0xe8
	ldr r1, [r1]
	ldr r2, [r4]
	add r0, r5, #0
	bl ov14_021E6548
	add r0, r5, #0
	bl ov14_021F08F0
	ldr r0, [r5, #0x34]
	mov r1, #0x28
	bl ov14_021F6678
	add r0, r5, #0
	add r0, #0x21
	ldrb r1, [r0]
	cmp r1, #0xff
	bne _021EE78E
	mov r1, #0
	add r0, r5, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	mov r1, #0x1e
	bl ov14_021E7588
	b _021EE7AC
_021EE78E:
	add r0, r5, #0
	mov r2, #1
	mov r3, #0x27
	bl ov14_021F685C
	ldr r0, [r5, #0x34]
	mov r1, #7
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
_021EE7AC:
	mov r0, #0x5b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EE7B0: .word 0x000005EA
	thumb_func_end ov14_021EE728

	thumb_func_start ov14_021EE7B4
ov14_021EE7B4: ; 0x021EE7B4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0xc
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7B4

	thumb_func_start ov14_021EE7C4
ov14_021EE7C4: ; 0x021EE7C4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x29
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7C4

	thumb_func_start ov14_021EE7D4
ov14_021EE7D4: ; 0x021EE7D4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x24
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7D4

	thumb_func_start ov14_021EE7E4
ov14_021EE7E4: ; 0x021EE7E4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x5b
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE7E4

	thumb_func_start ov14_021EE7F4
ov14_021EE7F4: ; 0x021EE7F4
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x5b
	pop {r4, pc}
	thumb_func_end ov14_021EE7F4

	thumb_func_start ov14_021EE810
ov14_021EE810: ; 0x021EE810
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x61
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE810

	thumb_func_start ov14_021EE820
ov14_021EE820: ; 0x021EE820
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x16
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE820

	thumb_func_start ov14_021EE830
ov14_021EE830: ; 0x021EE830
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x3d
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE830

	thumb_func_start ov14_021EE840
ov14_021EE840: ; 0x021EE840
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x42
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE840

	thumb_func_start ov14_021EE850
ov14_021EE850: ; 0x021EE850
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x51
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EE850

	thumb_func_start ov14_021EE860
ov14_021EE860: ; 0x021EE860
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r1, #0
	add r0, r4, #0
	add r2, r1, #0
	mov r3, #0x27
	bl ov14_021F685C
	mov r0, #0x51
	pop {r4, pc}
	thumb_func_end ov14_021EE860

	thumb_func_start ov14_021EE87C
ov14_021EE87C: ; 0x021EE87C
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EE976
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EE8CE
	ldr r0, _021EEBDC ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EEBE0 ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F18B0
	pop {r3, r4, r5, pc}
_021EE8CE:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EE956
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r1, [r4, #0x34]
	ldr r0, _021EEBE4 ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EE94A
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EE94A:
	ldr r1, _021EEBE8 ; =ov14_021EA674
	add r0, r4, #0
	mov r2, #0x76
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EE956:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x75
	pop {r3, r4, r5, pc}
_021EE976:
	add r0, r4, #0
	bl ov14_021F74B0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EE9BA
	blo _021EE98A
	b _021EEB08
_021EE98A:
	cmp r5, #0x25
	bhi _021EE9AE
	sub r0, #0x1e
	bmi _021EE9B8
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EE99E: ; jump table
	.short _021EE9CE - _021EE99E - 2 ; case 0
	.short _021EE9EC - _021EE99E - 2 ; case 1
	.short _021EEA20 - _021EE99E - 2 ; case 2
	.short _021EEA54 - _021EE99E - 2 ; case 3
	.short _021EEA66 - _021EE99E - 2 ; case 4
	.short _021EEB3C - _021EE99E - 2 ; case 5
	.short _021EEA78 - _021EE99E - 2 ; case 6
	.short _021EEA8A - _021EE99E - 2 ; case 7
_021EE9AE:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	bne _021EE9B8
	b _021EEB66
_021EE9B8:
	b _021EEB92
_021EE9BA:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EE9C6
	bne _021EE9C4
	b _021EEB54
_021EE9C4:
	b _021EEB92
_021EE9C6:
	add r0, r1, #2
	cmp r5, r0
	beq _021EEABE
	b _021EEB92
_021EE9CE:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	bl ov14_021F1128
	pop {r3, r4, r5, pc}
_021EE9EC:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EEA20:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #0x1e
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EEA54:
	ldr r0, _021EEBF4 ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #8
	mov r2, #0xab
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEA66:
	ldr r0, _021EEBF4 ; =0x00000632
	bl PlaySE
	add r0, r4, #0
	mov r1, #9
	mov r2, #0xac
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EEA78:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0xad
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEA8A:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r5, [r0]
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xae
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEABE:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	cmp r0, #0x1e
	beq _021EEACC
	b _021EEBD6
_021EEACC:
	ldr r0, _021EEBF8 ; =gSystem
	ldr r1, [r0, #0x48]
	mov r0, #0x20
	tst r0, r1
	beq _021EEAEC
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F028C
	pop {r3, r4, r5, pc}
_021EEAEC:
	mov r0, #0x10
	tst r0, r1
	beq _021EEBD6
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0x75
	bl ov14_021F0314
	pop {r3, r4, r5, pc}
_021EEB08:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EEB1E
	add r0, r4, #0
	bl ov14_021E7588
	b _021EEB2C
_021EEB1E:
	cmp r1, #0x24
	beq _021EEB2C
	cmp r1, #0x25
	beq _021EEB2C
	add r0, r4, #0
	bl ov14_021E765C
_021EEB2C:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x76
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EEB3C:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E765C
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x93
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEB54:
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x94
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EEB66:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x1e
	bhs _021EEB7C
	add r0, r4, #0
	bl ov14_021E7588
	b _021EEB8A
_021EEB7C:
	cmp r1, #0x24
	beq _021EEB8A
	cmp r1, #0x25
	beq _021EEB8A
	add r0, r4, #0
	bl ov14_021E765C
_021EEB8A:
	ldr r0, _021EEBF0 ; =0x000005DC
	bl PlaySE
	b _021EEBD6
_021EEB92:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EEBD6
	ldr r0, _021EEBEC ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1808
	pop {r3, r4, r5, pc}
_021EEBD6:
	mov r0, #0x75
	pop {r3, r4, r5, pc}
	nop
_021EEBDC: .word 0x000005EB
_021EEBE0: .word 0x000040B8
_021EEBE4: .word 0x000088C8
_021EEBE8: .word ov14_021EA674
_021EEBEC: .word 0x000005DD
_021EEBF0: .word 0x000005DC
_021EEBF4: .word 0x00000632
_021EEBF8: .word gSystem
	thumb_func_end ov14_021EE87C

	thumb_func_start ov14_021EEBFC
ov14_021EEBFC: ; 0x021EEBFC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A44
	cmp r0, #1
	bne _021EEC30
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EEC30:
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EEC72
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	add r0, r4, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021EEC7C
_021EEC72:
	add r0, r4, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
_021EEC7C:
	ldr r1, _021EEC88 ; =ov14_021E9450
	add r0, r4, #0
	mov r2, #0x7b
	bl ov14_021F0234
	pop {r4, pc}
	.balign 4, 0
_021EEC88: .word ov14_021E9450
	thumb_func_end ov14_021EEBFC

	thumb_func_start ov14_021EEC8C
ov14_021EEC8C: ; 0x021EEC8C
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x75
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EEC8C

	thumb_func_start ov14_021EEC9C
ov14_021EEC9C: ; 0x021EEC9C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	blo _021EED0C
	ldr r1, [r5, #0x34]
	ldr r0, _021EED20 ; =0x000088C8
	ldrh r0, [r1, r0]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EED0C
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x10
	lsr r4, r0, #0x10
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, _021EED24 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #4
	mov r2, #0x25
	bl ov14_021F68C0
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EED0C:
	add r0, r5, #0
	mov r1, #2
	mov r2, #0x25
	bl ov14_021F68C0
	add r0, r5, #0
	mov r1, #2
	bl ov14_021F0254
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EED20: .word 0x000088C8
_021EED24: .word 0x000005F3
	thumb_func_end ov14_021EEC9C

	thumb_func_start ov14_021EED28
ov14_021EED28: ; 0x021EED28
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #0
	bne _021EEDAE
	add r0, r5, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021EED48
	sub r4, #0x1e
	lsl r0, r4, #0x10
	lsr r4, r0, #0x10
_021EED48:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	add r0, r5, #0
	mov r1, #3
	mov r2, #0x25
	bl ov14_021F68C0
	add r0, r5, #0
	mov r1, #0
	bl ov14_021F5FBC
	ldr r1, [r5, #0x34]
	ldr r0, _021EEDB4 ; =0x000088C8
	mov r2, #0
	strh r2, [r1, r0]
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EEDAE:
	mov r0, #0x79
	pop {r3, r4, r5, pc}
	nop
_021EEDB4: .word 0x000088C8
	thumb_func_end ov14_021EED28

	thumb_func_start ov14_021EEDB8
ov14_021EEDB8: ; 0x021EEDB8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r1, r5, #0
	add r1, #0x21
	ldrb r4, [r1]
	cmp r4, #0x1e
	bhs _021EEDEA
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021EEDF8
_021EEDEA:
	sub r4, #0x1e
	lsl r1, r4, #0x10
	lsr r4, r1, #0x10
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
_021EEDF8:
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
	ldr r0, [r5, #0x34]
	mov r1, #0x25
	bl ov14_021F6654
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021EEE78
	add r0, r5, #0
	mov r1, #0x81
	mov r2, #1
	bl ov14_021F3488
	b _021EEE82
_021EEE78:
	add r0, r5, #0
	mov r1, #0x82
	mov r2, #1
	bl ov14_021F3488
_021EEE82:
	ldr r1, _021EEE90 ; =ov14_021E9450
	add r0, r5, #0
	mov r2, #0x7b
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
	nop
_021EEE90: .word ov14_021E9450
	thumb_func_end ov14_021EEDB8

	thumb_func_start ov14_021EEE94
ov14_021EEE94: ; 0x021EEE94
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EEEA8
	mov r0, #0x7b
	pop {r4, pc}
_021EEEA8:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #1
	bl ov14_021F2A18
	add r4, #0x21
	ldrb r0, [r4]
	cmp r0, #0x1e
	blo _021EEED0
	mov r0, #0x8b
	pop {r4, pc}
_021EEED0:
	mov r0, #0x75
	pop {r4, pc}
	thumb_func_end ov14_021EEE94

	thumb_func_start ov14_021EEED4
ov14_021EEED4: ; 0x021EEED4
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021EEEE6
	sub r4, #0x1e
	lsl r0, r4, #0x10
	lsr r4, r0, #0x10
_021EEEE6:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldr r0, _021EEF30 ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #5
	mov r2, #0x25
	bl ov14_021F68C0
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EEF30: .word 0x000005F3
	thumb_func_end ov14_021EEED4

	thumb_func_start ov14_021EEF34
ov14_021EEF34: ; 0x021EEF34
	push {r3, r4, r5, lr}
	add r5, r0, #0
	add r0, #0x21
	ldrb r4, [r0]
	cmp r4, #0x1e
	blo _021EEF46
	sub r4, #0x1e
	lsl r0, r4, #0x10
	lsr r4, r0, #0x10
_021EEF46:
	ldr r0, [r5, #0x34]
	lsl r1, r4, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	add r1, r4, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetDpadBox
	add r1, sp, #0
	add r1, #1
	add r2, sp, #0
	bl DpadMenuBox_GetPosition
	mov r0, #0x32
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	add r2, sp, #0
	ldr r0, [r1, r0]
	ldrb r1, [r2, #1]
	ldrb r2, [r2]
	bl ManagedSprite_SetPositionXY
	ldrh r1, [r5, #0x1c]
	add r0, r5, #0
	mov r2, #0x25
	bl ov14_021F6768
	mov r0, #0x77
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021EEF34

	thumb_func_start ov14_021EEF8C
ov14_021EEF8C: ; 0x021EEF8C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r2, [r5, #0x34]
	add r0, #0x21
	ldr r4, [r2, #0xc]
	ldrb r0, [r0]
	ldrh r1, [r4]
	cmp r1, r0
	beq _021EEFA6
	ldr r0, _021EF01C ; =0x000088C8
	ldrh r0, [r2, r0]
	cmp r0, #0
	bne _021EEFE2
_021EEFA6:
	add r0, r5, #0
	bl ov14_021F1F38
	ldr r1, [r5, #0x34]
	ldr r0, _021EF01C ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EEFCA
	ldr r0, _021EF020 ; =0x000005EA
	bl PlaySE
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
_021EEFCA:
	ldr r0, [r5, #0x34]
	mov r1, #0x24
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x75
	pop {r3, r4, r5, pc}
_021EEFE2:
	ldr r0, _021EF020 ; =0x000005EA
	bl PlaySE
	ldrh r1, [r4]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #1
	bl ov14_021F34C8
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x7f
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF01C: .word 0x000088C8
_021EF020: .word 0x000005EA
	thumb_func_end ov14_021EEF8C

	thumb_func_start ov14_021EF024
ov14_021EF024: ; 0x021EF024
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EF038
	mov r0, #0x7f
	pop {r3, r4, r5, r6, r7, pc}
_021EF038:
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r2, #6
	ldr r4, [r0, #0xc]
	add r0, r5, #0
	ldrh r1, [r4]
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldrh r1, [r4]
	ldr r6, [r5, #0x34]
	ldr r3, _021EF17C ; =0x000088C8
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	ldrb r1, [r5, #0x1f]
	ldrh r2, [r4]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF092
	ldrh r2, [r4]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF180 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF092:
	ldrh r1, [r4]
	add r0, r5, #0
	bl ov14_021E7588
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	ldr r3, _021EF17C ; =0x000088C8
	add r1, #0x21
	strh r7, [r0, r3]
	ldr r6, [r5, #0x34]
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF0DE
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF180 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF0DE:
	ldr r1, [r5, #0x34]
	ldr r0, _021EF17C ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	bne _021EF13E
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	ldr r1, _021EF184 ; =ov14_021E94BC
	add r0, r5, #0
	mov r2, #0x75
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
_021EF13E:
	ldr r0, _021EF188 ; =0x000005EB
	bl PlaySE
	ldr r0, [r5, #0x34]
	ldr r1, _021EF17C ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r1, _021EF18C ; =ov14_021EA728
	add r0, r5, #0
	mov r2, #0x80
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021EF17C: .word 0x000088C8
_021EF180: .word 0x00004094
_021EF184: .word ov14_021E94BC
_021EF188: .word 0x000005EB
_021EF18C: .word ov14_021EA728
	thumb_func_end ov14_021EF024

	thumb_func_start ov14_021EF190
ov14_021EF190: ; 0x021EF190
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r2, #0
	ldr r4, [r0, #0xc]
	ldrh r1, [r4]
	bl ov14_021F34C8
	ldr r0, _021EF1E8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	ldrh r1, [r4]
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	mov r0, #0x81
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF1E8: .word 0x000005EA
	thumb_func_end ov14_021EF190

	thumb_func_start ov14_021EF1EC
ov14_021EF1EC: ; 0x021EF1EC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EF200
	mov r0, #0x81
	pop {r4, pc}
_021EF200:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8248
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E82A8
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021EF244 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x75
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021EF244: .word ov14_021E94BC
	thumb_func_end ov14_021EF1EC

	thumb_func_start ov14_021EF248
ov14_021EF248: ; 0x021EF248
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A34
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EF2E2
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF28C
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F19F0
	pop {r3, r4, r5, pc}
_021EF28C:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	add r5, #0x1e
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF2C4
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF2C4:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF2DE
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF2DE:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF2E2:
	bl ov14_021F6A14
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EF370
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF31C
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F19F0
	pop {r3, r4, r5, pc}
_021EF31C:
	add r0, r4, #0
	bl ov14_021E765C
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF352
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF352:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF36C
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF36C:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF370:
	add r0, r4, #0
	bl ov14_021F7B7C
	cmp r0, #1
	bne _021EF3B8
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r5, r0, #0
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF3B4
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	strb r5, [r0]
	add r0, r4, #0
	mov r1, #1
	add r0, #0x26
	strb r1, [r0]
	add r0, r4, #0
	mov r1, #0xf
	mov r2, #0x97
	bl ov14_021F2330
	pop {r3, r4, r5, pc}
_021EF3B4:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF3B8:
	add r0, r4, #0
	bl ov14_021F70C0
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EF3FE
	blo _021EF3CC
	b _021EF5A6
_021EF3CC:
	cmp r5, #0x2d
	bhi _021EF3F4
	sub r0, #0x24
	bmi _021EF3FC
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EF3E0: ; jump table
	.short _021EF63A - _021EF3E0 - 2 ; case 0
	.short _021EF414 - _021EF3E0 - 2 ; case 1
	.short _021EF42A - _021EF3E0 - 2 ; case 2
	.short _021EF440 - _021EF3E0 - 2 ; case 3
	.short _021EF456 - _021EF3E0 - 2 ; case 4
	.short _021EF46C - _021EF3E0 - 2 ; case 5
	.short _021EF482 - _021EF3E0 - 2 ; case 6
	.short _021EF498 - _021EF3E0 - 2 ; case 7
	.short _021EF50A - _021EF3E0 - 2 ; case 8
	.short _021EF57A - _021EF3E0 - 2 ; case 9
_021EF3F4:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021EF410
_021EF3FC:
	b _021EF6A2
_021EF3FE:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EF40A
	bne _021EF408
	b _021EF64C
_021EF408:
	b _021EF6A2
_021EF40A:
	add r0, r1, #2
	cmp r5, r0
	bne _021EF412
_021EF410:
	b _021EF6C4
_021EF412:
	b _021EF6A2
_021EF414:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF42A:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF440:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #2
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF456:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #3
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF46C:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #4
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF482:
	ldr r0, _021EF6C8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #5
	bl ov14_021F0D58
	pop {r3, r4, r5, pc}
_021EF498:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	mov r1, #0
	add r0, r4, #0
	mvn r1, r1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF4EC
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF4EC:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF506
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF506:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF50A:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	bl ov14_021E76B8
	add r0, r4, #0
	mov r1, #1
	bl ov14_021F1004
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #1
	bne _021EF55C
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF55C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF576
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0D34
	pop {r3, r4, r5, pc}
_021EF576:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
_021EF57A:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xe
	mov r2, #0xaf
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EF5A6:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #0x24
	bhs _021EF600
	add r0, r4, #0
	bl ov14_021E7588
	cmp r0, #1
	ldr r1, [r4, #0x34]
	bne _021EF5E4
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #0
	bne _021EF622
	add r0, r4, #0
	mov r1, #0
	bl ov14_021F6408
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	b _021EF622
_021EF5E4:
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF622
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
	b _021EF622
_021EF600:
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8648
	cmp r0, #1
	bne _021EF622
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8634
_021EF622:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #8]
	cmp r0, #0
	beq _021EF6C4
	add r0, r4, #0
	mov r1, #0x83
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EF63A:
	ldr r0, _021EF6D0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EF64C:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E85E4
	cmp r0, #0
	bne _021EF66E
	ldr r0, _021EF6D0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #1
	mov r2, #0xa1
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EF66E:
	ldr r0, _021EF6CC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x25
	ldrb r0, [r0]
	mov r1, #6
	bl _s32_div_f
	ldr r0, [r4, #0x34]
	add r1, #0x25
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	mov r1, #0x82
	bl ov14_021F0EE8
	pop {r3, r4, r5, pc}
_021EF6A2:
	add r0, r4, #0
	add r1, r5, #0
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EF6C4
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021E7588
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1B4C
	pop {r3, r4, r5, pc}
_021EF6C4:
	mov r0, #0x82
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF6C8: .word 0x000005DD
_021EF6CC: .word 0x000005DC
_021EF6D0: .word 0x00000633
	thumb_func_end ov14_021EF248

	thumb_func_start ov14_021EF6D4
ov14_021EF6D4: ; 0x021EF6D4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x82
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EF6D4

	thumb_func_start ov14_021EF6E4
ov14_021EF6E4: ; 0x021EF6E4
	push {r4, lr}
	add r4, r0, #0
	bl ov14_021F40DC
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
	mov r0, #0x85
	pop {r4, pc}
	thumb_func_end ov14_021EF6E4

	thumb_func_start ov14_021EF6FC
ov14_021EF6FC: ; 0x021EF6FC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r1, [r5, #0x34]
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	ldr r4, [r1, #0xc]
	mov r1, #0x10
	bl sub_020199E4
	cmp r0, #0
	beq _021EF718
	mov r0, #0x85
	pop {r3, r4, r5, r6, r7, pc}
_021EF718:
	add r0, r5, #0
	add r0, #0x21
	ldrh r1, [r4]
	ldrb r0, [r0]
	cmp r1, r0
	bne _021EF784
	add r0, r5, #0
	ldrh r4, [r4, #2]
	bl ov14_021F1F38
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r1, [r5, #0x34]
	ldr r0, _021EF898 ; =0x000088C8
	ldrh r0, [r1, r0]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EF776
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r4, r0
	beq _021EF776
	ldr r0, _021EF89C ; =0x000005F3
	bl PlaySE
	add r0, r5, #0
	mov r1, #0x25
	bl ov14_021F6730
	mov r0, #0x87
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021EF776:
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r3, r4, r5, r6, r7, pc}
_021EF784:
	ldr r0, [r5, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	mov r2, #1
	bl ov14_021F34C8
	ldrh r1, [r4]
	add r0, r5, #0
	mov r2, #6
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldrh r1, [r4]
	ldr r6, [r5, #0x34]
	ldr r3, _021EF898 ; =0x000088C8
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	ldrb r1, [r5, #0x1f]
	ldrh r2, [r4]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF7DE
	ldrh r2, [r4]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF8A0 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF7DE:
	ldrh r1, [r4]
	add r0, r5, #0
	bl ov14_021E7588
	ldrh r1, [r4]
	ldr r0, [r5, #0x34]
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	ldr r3, _021EF898 ; =0x000088C8
	add r1, #0x21
	strh r7, [r0, r3]
	ldr r6, [r5, #0x34]
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EF838
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021EF8A0 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EF838:
	ldr r0, [r5, #0x34]
	ldr r1, _021EF898 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _021EF85E
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r3, r4, r5, r6, r7, pc}
_021EF85E:
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r0, _021EF8A4 ; =0x000005EB
	bl PlaySE
	ldr r1, _021EF8A8 ; =ov14_021EA928
	add r0, r5, #0
	mov r2, #0x86
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF898: .word 0x000088C8
_021EF89C: .word 0x000005F3
_021EF8A0: .word 0x00004094
_021EF8A4: .word 0x000005EB
_021EF8A8: .word ov14_021EA928
	thumb_func_end ov14_021EF6FC

	thumb_func_start ov14_021EF8AC
ov14_021EF8AC: ; 0x021EF8AC
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r2, #0
	ldr r7, [r0, #0xc]
	ldrh r1, [r7]
	bl ov14_021F34C8
	add r0, r5, #0
	add r0, #0x21
	ldrb r6, [r0]
	add r0, r5, #0
	ldrh r4, [r7, #2]
	ldrh r1, [r7]
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	ldr r3, [r5, #0x34]
	ldr r1, _021EF918 ; =0x000088C8
	mov r2, #0
	ldrh r0, [r3, r1]
	strh r2, [r3, r1]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EF908
	cmp r4, r6
	beq _021EF908
	ldr r0, _021EF91C ; =0x000005F3
	bl PlaySE
	ldr r0, [r5, #0x34]
	mov r1, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r5, #0
	mov r1, #0x25
	bl ov14_021F6730
	mov r0, #0x87
	str r0, [r5, #0x30]
	mov r0, #6
	pop {r3, r4, r5, r6, r7, pc}
_021EF908:
	ldr r0, [r5, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r3, r4, r5, r6, r7, pc}
	nop
_021EF918: .word 0x000088C8
_021EF91C: .word 0x000005F3
	thumb_func_end ov14_021EF8AC

	thumb_func_start ov14_021EF920
ov14_021EF920: ; 0x021EF920
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x25
	bl ov14_021F6688
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x82
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021EF920

	thumb_func_start ov14_021EF93C
ov14_021EF93C: ; 0x021EF93C
	push {r3, r4, r5, lr}
	add r5, r0, #0
	bl ov14_021F7A50
	add r4, r0, #0
	ldr r0, [r5, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_IsButtonInputMode
	cmp r0, #0
	bne _021EF956
	mov r4, #1
	mvn r4, r4
_021EF956:
	cmp r4, #0x24
	bhi _021EF95E
	beq _021EF990
	b _021EF9A0
_021EF95E:
	add r0, r4, #4
	cmp r0, #3
	bhi _021EF9A0
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EF970: ; jump table
	.short _021EF988 - _021EF970 - 2 ; case 0
	.short _021EF978 - _021EF970 - 2 ; case 1
	.short _021EF990 - _021EF970 - 2 ; case 2
	.short _021EF9B0 - _021EF970 - 2 ; case 3
_021EF978:
	ldr r0, _021EF9B4 ; =0x000005DC
	bl PlaySE
	add r0, r5, #0
	mov r1, #0x89
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EF988:
	ldr r0, _021EF9B4 ; =0x000005DC
	bl PlaySE
	b _021EF9B0
_021EF990:
	ldr r0, _021EF9B8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	mov r1, #0xff
	bl ov14_021F1C4C
	pop {r3, r4, r5, pc}
_021EF9A0:
	ldr r0, _021EF9B8 ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	add r1, r4, #0
	bl ov14_021F1C4C
	pop {r3, r4, r5, pc}
_021EF9B0:
	mov r0, #0x88
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EF9B4: .word 0x000005DC
_021EF9B8: .word 0x000005EA
	thumb_func_end ov14_021EF93C

	thumb_func_start ov14_021EF9BC
ov14_021EF9BC: ; 0x021EF9BC
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x88
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EF9BC

	thumb_func_start ov14_021EF9CC
ov14_021EF9CC: ; 0x021EF9CC
	push {r4, r5, r6, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	mov r2, #0
	ldrb r1, [r0, r1]
	bl ov14_021F34C8
	ldr r0, [r4, #0x34]
	ldr r2, _021EFB48 ; =0x0000044C
	ldr r3, _021EFB4C ; =0x000088CA
	ldrb r1, [r0, r2]
	ldrh r5, [r0, r3]
	cmp r1, r5
	bne _021EFA12
	mov r5, #0
	sub r1, r3, #2
	strh r5, [r0, r1]
	ldr r1, [r4, #0x34]
	add r0, r4, #0
	ldrb r1, [r1, r2]
	bl ov14_021E7588
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8620
	ldr r1, _021EFB50 ; =ov14_021E9970
	add r0, r4, #0
	mov r2, #0x82
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
_021EFA12:
	add r0, r4, #0
	mov r2, #6
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r5, r0, #0x10
	ldr r3, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	ldr r6, _021EFB54 ; =0x000088C8
	ldrb r1, [r3, r1]
	add r0, r4, #0
	mov r2, #6
	add r3, r3, r6
	bl ov14_021E6094
	ldr r3, [r4, #0x34]
	ldr r2, _021EFB48 ; =0x0000044C
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r3, r2]
	add r0, r4, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFA5C
	ldr r3, [r4, #0x34]
	ldr r0, _021EFB48 ; =0x0000044C
	ldrb r1, [r4, #0x1f]
	ldrb r2, [r3, r0]
	add r0, r4, #0
	add r6, r3, r2
	ldr r3, _021EFB58 ; =0x00004094
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EFA5C:
	ldr r2, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	add r0, r4, #0
	ldrb r1, [r2, r1]
	bl ov14_021E7588
	ldr r3, _021EFB54 ; =0x000088C8
	ldr r0, [r4, #0x34]
	add r1, r3, #2
	strh r5, [r0, r3]
	ldr r5, [r4, #0x34]
	add r0, r4, #0
	ldrh r1, [r5, r1]
	mov r2, #6
	add r3, r5, r3
	bl ov14_021E6094
	ldr r3, [r4, #0x34]
	ldr r2, _021EFB4C ; =0x000088CA
	ldrb r1, [r4, #0x1f]
	ldrh r2, [r3, r2]
	add r0, r4, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFAA8
	ldr r3, [r4, #0x34]
	ldr r0, _021EFB4C ; =0x000088CA
	ldrb r1, [r4, #0x1f]
	ldrh r2, [r3, r0]
	add r0, r4, #0
	add r5, r3, r2
	ldr r3, _021EFB58 ; =0x00004094
	ldrb r3, [r5, r3]
	bl ov14_021F2ED0
_021EFAA8:
	ldr r2, [r4, #0x34]
	ldr r0, _021EFB54 ; =0x000088C8
	ldrh r0, [r2, r0]
	cmp r0, #0
	bne _021EFAC8
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	bl ov14_021E8620
	ldr r1, _021EFB50 ; =ov14_021E9970
	add r0, r4, #0
	mov r2, #0x82
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
_021EFAC8:
	ldr r0, _021EFB5C ; =0x0000044B
	mov r1, #1
	strb r1, [r2, r0]
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB48 ; =0x0000044C
	mov r2, #2
	ldrb r1, [r0, r1]
	bl ov14_021F39A0
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB54 ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r2, [r4, #0x34]
	ldr r1, _021EFB54 ; =0x000088C8
	add r0, r4, #0
	ldrh r1, [r2, r1]
	bl ov14_021F5564
	add r5, r0, #0
	mov r0, #0x2f
	ldr r3, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r3, r0]
	add r3, #0x30
	lsl r2, r5, #4
	mov r1, #0x10
	add r2, r3, r2
	bl sub_02019A60
	mov r0, #0x2f
	add r3, r5, #1
	ldr r2, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r2, r0]
	add r2, #0x30
	lsl r3, r3, #4
	mov r1, #0x10
	add r2, r2, r3
	bl sub_02019A60
	ldr r0, [r4, #0x34]
	ldr r1, _021EFB54 ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F38B0
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88BC
	ldr r1, _021EFB60 ; =ov14_021EAA04
	add r0, r4, #0
	mov r2, #0x88
	bl ov14_021F0234
	pop {r4, r5, r6, pc}
	.balign 4, 0
_021EFB48: .word 0x0000044C
_021EFB4C: .word 0x000088CA
_021EFB50: .word ov14_021E9970
_021EFB54: .word 0x000088C8
_021EFB58: .word 0x00004094
_021EFB5C: .word 0x0000044B
_021EFB60: .word ov14_021EAA04
	thumb_func_end ov14_021EF9CC

	thumb_func_start ov14_021EFB64
ov14_021EFB64: ; 0x021EFB64
	push {r3, r4, r5, lr}
	add r4, r0, #0
	bl ov14_021F6A24
	add r5, r0, #0
	mov r0, #0
	mvn r0, r0
	cmp r5, r0
	beq _021EFC52
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EFBBC
	ldr r0, _021EFDC8 ; =0x000005EB
	bl PlaySE
	ldr r2, [r4, #0x34]
	ldr r1, _021EFDCC ; =0x000040B8
	add r0, r2, r1
	add r1, r1, #4
	add r1, r2, r1
	bl System_GetTouchNewCoords
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #9
	mov r2, #0
	bl ov14_021F2A18
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1D6C
	pop {r3, r4, r5, pc}
_021EFBBC:
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8544
	cmp r0, #1
	bne _021EFC32
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E84A4
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r1, [r4, #0x34]
	ldr r0, _021EFDD0 ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EFC26
	mov r0, #0x2f
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E88F8
_021EFC26:
	ldr r1, _021EFDD4 ; =ov14_021EA674
	add r0, r4, #0
	mov r2, #0x8c
	bl ov14_021F0234
	pop {r3, r4, r5, pc}
_021EFC32:
	ldr r0, [r4, #0x34]
	lsl r1, r5, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	add r0, r4, #0
	bl ov14_021E765C
	mov r0, #0x8b
	pop {r3, r4, r5, pc}
_021EFC52:
	add r0, r4, #0
	bl ov14_021F75C8
	mov r1, #2
	add r5, r0, #0
	mvn r1, r1
	cmp r5, r1
	bhi _021EFC92
	bhs _021EFCCA
	cmp r5, #9
	bhi _021EFC88
	add r0, r5, r5
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
_021EFC74: ; jump table
	.short _021EFD7A - _021EFC74 - 2 ; case 0
	.short _021EFD7A - _021EFC74 - 2 ; case 1
	.short _021EFD7A - _021EFC74 - 2 ; case 2
	.short _021EFD7A - _021EFC74 - 2 ; case 3
	.short _021EFD7A - _021EFC74 - 2 ; case 4
	.short _021EFD7A - _021EFC74 - 2 ; case 5
	.short _021EFCA6 - _021EFC74 - 2 ; case 6
	.short _021EFD00 - _021EFC74 - 2 ; case 7
	.short _021EFCB8 - _021EFC74 - 2 ; case 8
	.short _021EFD12 - _021EFC74 - 2 ; case 9
_021EFC88:
	mov r0, #3
	mvn r0, r0
	cmp r5, r0
	beq _021EFD4C
	b _021EFD7A
_021EFC92:
	add r0, r1, #1
	cmp r5, r0
	bhi _021EFC9C
	beq _021EFD00
	b _021EFD7A
_021EFC9C:
	add r0, r1, #2
	cmp r5, r0
	bne _021EFCA4
	b _021EFDC4
_021EFCA4:
	b _021EFD7A
_021EFCA6:
	ldr r0, _021EFDD8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #0
	mov r2, #0xb0
	bl ov14_021F2490
	pop {r3, r4, r5, pc}
_021EFCB8:
	ldr r0, _021EFDD8 ; =0x000005DD
	bl PlaySE
	add r0, r4, #0
	mov r1, #7
	mov r2, #0xad
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EFCCA:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EFCE2
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EFCF0
_021EFCE2:
	cmp r1, #8
	beq _021EFCF0
	cmp r1, #9
	beq _021EFCF0
	add r0, r4, #0
	bl ov14_021E765C
_021EFCF0:
	ldr r0, _021EFDDC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x8c
	bl ov14_021F0244
	pop {r3, r4, r5, pc}
_021EFD00:
	ldr r0, _021EFDE0 ; =0x00000633
	bl PlaySE
	add r0, r4, #0
	mov r1, #0xa
	mov r2, #0x9f
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EFD12:
	ldr r0, _021EFDDC ; =0x000005DC
	bl PlaySE
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	sub r0, #0x1e
	lsl r0, r0, #0x18
	lsr r5, r0, #0x18
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	add r1, r5, #0
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r0, r4, #0
	mov r1, #0xb
	mov r2, #0xb1
	bl ov14_021F2270
	pop {r3, r4, r5, pc}
_021EFD4C:
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r1, r0, #0
	cmp r1, #5
	bhi _021EFD64
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	b _021EFD72
_021EFD64:
	cmp r1, #8
	beq _021EFD72
	cmp r1, #9
	beq _021EFD72
	add r0, r4, #0
	bl ov14_021E765C
_021EFD72:
	ldr r0, _021EFDDC ; =0x000005DC
	bl PlaySE
	b _021EFDC4
_021EFD7A:
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	mov r2, #0xac
	mov r3, #0
	bl ov14_021E6070
	cmp r0, #0
	beq _021EFDC4
	ldr r0, _021EFDD8 ; =0x000005DD
	bl PlaySE
	add r1, r5, #0
	add r0, r4, #0
	add r1, #0x1e
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_GetNextInput
	add r2, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #8
	bl ov14_021F7AC4
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	add r5, #0x1e
	add r0, r4, #0
	add r1, r5, #0
	bl ov14_021F1CDC
	pop {r3, r4, r5, pc}
_021EFDC4:
	mov r0, #0x8b
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EFDC8: .word 0x000005EB
_021EFDCC: .word 0x000040B8
_021EFDD0: .word 0x000088C8
_021EFDD4: .word ov14_021EA674
_021EFDD8: .word 0x000005DD
_021EFDDC: .word 0x000005DC
_021EFDE0: .word 0x00000633
	thumb_func_end ov14_021EFB64

	thumb_func_start ov14_021EFDE4
ov14_021EFDE4: ; 0x021EFDE4
	push {r3, lr}
	ldr r0, [r0, #0x34]
	ldr r0, [r0, #0xc]
	bl Heap_Free
	mov r0, #0x8b
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021EFDE4

	thumb_func_start ov14_021EFDF4
ov14_021EFDF4: ; 0x021EFDF4
	push {r3, r4, r5, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	add r1, r4, #0
	ldr r5, [r0, #0xc]
	add r1, #0x21
	ldrh r2, [r5]
	ldrb r1, [r1]
	cmp r2, r1
	beq _021EFE10
	ldr r1, _021EFEF0 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _021EFEB0
_021EFE10:
	add r0, r4, #0
	ldrh r5, [r5, #2]
	bl ov14_021F1F38
	ldr r0, [r4, #0x34]
	ldr r1, _021EFEF4 ; =0x0000044A
	ldrb r1, [r0, r1]
	cmp r1, #0
	bne _021EFE6C
	ldr r1, _021EFEF0 ; =0x000088C8
	ldrh r0, [r0, r1]
	bl ItemIdIsMail
	cmp r0, #1
	bne _021EFE7A
	add r0, r4, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r5, r0
	beq _021EFE7A
	ldr r0, _021EFEF8 ; =0x000005F3
	bl PlaySE
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #7
	bl sub_0201980C
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r0, r4, #0
	mov r1, #7
	mov r2, #0x28
	bl ov14_021F68C0
	mov r0, #0x92
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r3, r4, r5, pc}
_021EFE6C:
	mov r1, #0x28
	bl ov14_021F6654
	ldr r1, [r4, #0x34]
	ldr r0, _021EFEF4 ; =0x0000044A
	mov r2, #0
	strb r2, [r1, r0]
_021EFE7A:
	ldr r1, [r4, #0x34]
	ldr r0, _021EFEF0 ; =0x000088C8
	ldrh r0, [r1, r0]
	cmp r0, #0
	beq _021EFE98
	ldr r0, _021EFEFC ; =0x000005EA
	bl PlaySE
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
_021EFE98:
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x8b
	pop {r3, r4, r5, pc}
_021EFEB0:
	mov r1, #0x28
	bl ov14_021F6654
	ldr r0, _021EFEFC ; =0x000005EA
	bl PlaySE
	ldrh r1, [r5]
	ldr r0, [r4, #0x34]
	mov r2, #0
	bl ov14_021F34C8
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r4, #0x34]
	mov r2, #1
	bl ov14_021F34C8
	add r0, r4, #0
	bl ov14_021F40DC
	ldr r0, [r4, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	mov r0, #0x8e
	pop {r3, r4, r5, pc}
	.balign 4, 0
_021EFEF0: .word 0x000088C8
_021EFEF4: .word 0x0000044A
_021EFEF8: .word 0x000005F3
_021EFEFC: .word 0x000005EA
	thumb_func_end ov14_021EFDF4

	thumb_func_start ov14_021EFF00
ov14_021EFF00: ; 0x021EFF00
	push {r3, r4, r5, r6, r7, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021EFF14
	mov r0, #0x8e
	pop {r3, r4, r5, r6, r7, pc}
_021EFF14:
	ldr r0, [r5, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	mov r2, #6
	ldr r4, [r0, #0xc]
	add r0, r5, #0
	ldrh r1, [r4]
	mov r3, #0
	bl ov14_021E6070
	lsl r0, r0, #0x10
	lsr r7, r0, #0x10
	ldrh r1, [r4]
	ldr r6, [r5, #0x34]
	ldr r3, _021F0084 ; =0x000088C8
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	ldrb r1, [r5, #0x1f]
	ldrh r2, [r4]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFF6E
	ldrh r2, [r4]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021F0088 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EFF6E:
	ldrh r1, [r4]
	add r0, r5, #0
	bl ov14_021E7588
	add r1, r5, #0
	ldr r0, [r5, #0x34]
	ldr r3, _021F0084 ; =0x000088C8
	add r1, #0x21
	strh r7, [r0, r3]
	ldr r6, [r5, #0x34]
	ldrb r1, [r1]
	add r0, r5, #0
	mov r2, #6
	add r3, r6, r3
	bl ov14_021E6094
	add r2, r5, #0
	add r2, #0x21
	ldrb r1, [r5, #0x1f]
	ldrb r2, [r2]
	add r0, r5, #0
	bl ov14_021E60C0
	bl ov14_021E64D0
	cmp r0, #1
	bne _021EFFBA
	add r0, r5, #0
	add r0, #0x21
	ldrb r2, [r0]
	ldr r3, [r5, #0x34]
	ldrb r1, [r5, #0x1f]
	add r6, r3, r2
	ldr r3, _021F0088 ; =0x00004094
	add r0, r5, #0
	ldrb r3, [r6, r3]
	bl ov14_021F2ED0
_021EFFBA:
	ldr r0, [r5, #0x34]
	ldr r1, _021F0084 ; =0x000088C8
	ldrh r1, [r0, r1]
	cmp r1, #0
	bne _021F0046
	ldr r1, _021F008C ; =0x0000044A
	ldrb r2, [r0, r1]
	cmp r2, #0
	bne _021F0006
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
	add r0, r5, #0
	bl ov14_021F1F38
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021F0090 ; =ov14_021E94BC
	add r0, r5, #0
	mov r2, #0x8f
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
_021F0006:
	mov r2, #0
	strb r2, [r0, r1]
	add r0, r5, #0
	bl ov14_021F1F38
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	mov r0, #0x2f
	ldr r1, [r5, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E7EE0
	mov r1, #1
	add r0, r5, #0
	add r2, r1, #0
	bl ov14_021F3488
	ldr r1, _021F0094 ; =ov14_021E9518
	add r0, r5, #0
	mov r2, #0x8f
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
_021F0046:
	ldr r0, _021F0098 ; =0x000005EB
	bl PlaySE
	ldr r0, [r5, #0x34]
	ldr r1, _021F0084 ; =0x000088C8
	ldrh r1, [r0, r1]
	bl ov14_021F3844
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F29E4
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #1
	bl ov14_021F2A18
	ldr r0, [r5, #0x34]
	bl ov14_021F39D0
	ldr r1, _021F009C ; =ov14_021EAF08
	add r0, r5, #0
	mov r2, #0x90
	bl ov14_021F0234
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F0084: .word 0x000088C8
_021F0088: .word 0x00004094
_021F008C: .word 0x0000044A
_021F0090: .word ov14_021E94BC
_021F0094: .word ov14_021E9518
_021F0098: .word 0x000005EB
_021F009C: .word ov14_021EAF08
	thumb_func_end ov14_021EFF00

	thumb_func_start ov14_021F00A0
ov14_021F00A0: ; 0x021F00A0
	push {r4, lr}
	add r4, r0, #0
	add r1, r4, #0
	add r1, #0x21
	ldrb r1, [r1]
	bl ov14_021E7588
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x8b
	pop {r4, pc}
	thumb_func_end ov14_021F00A0

	thumb_func_start ov14_021F00BC
ov14_021F00BC: ; 0x021F00BC
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0x34]
	mov r2, #0
	ldr r4, [r0, #0xc]
	ldrh r1, [r4]
	bl ov14_021F34C8
	ldr r0, _021F011C ; =0x000005EA
	bl PlaySE
	add r0, r5, #0
	bl ov14_021F40DC
	ldr r0, [r5, #0x34]
	mov r1, #1
	bl ov14_021F391C
	ldr r0, [r5, #0x34]
	mov r1, #0xb
	mov r2, #2
	bl ov14_021F29E4
	add r0, r5, #0
	add r0, #0x21
	ldrb r0, [r0]
	cmp r0, #0x1e
	bhs _021F00FC
	ldrh r1, [r4]
	add r0, r5, #0
	add r0, #0x21
	strb r1, [r0]
_021F00FC:
	add r1, r5, #0
	add r1, #0x21
	ldrb r1, [r1]
	ldr r0, [r5, #0x34]
	sub r1, #0x1e
	lsl r1, r1, #0x18
	ldr r0, [r0, #0x2c]
	lsr r1, r1, #0x18
	bl GridInputHandler_SetNextInput
	add r0, r5, #0
	bl ov14_021F1F38
	mov r0, #0x91
	pop {r3, r4, r5, pc}
	nop
_021F011C: .word 0x000005EA
	thumb_func_end ov14_021F00BC

	thumb_func_start ov14_021F0120
ov14_021F0120: ; 0x021F0120
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	bl ov14_021F2A04
	cmp r0, #1
	bne _021F0134
	mov r0, #0x91
	pop {r4, pc}
_021F0134:
	ldr r0, [r4, #0x34]
	mov r1, #0
	bl ov14_021F391C
	ldr r0, [r4, #0x34]
	mov r1, #0xb
	mov r2, #0
	bl ov14_021F2A18
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	bl ov14_021E8328
	ldr r1, _021F0160 ; =ov14_021E94BC
	add r0, r4, #0
	mov r2, #0x8f
	bl ov14_021F0234
	pop {r4, pc}
	nop
_021F0160: .word ov14_021E94BC
	thumb_func_end ov14_021F0120

	thumb_func_start ov14_021F0164
ov14_021F0164: ; 0x021F0164
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #0x34]
	mov r1, #0x28
	bl ov14_021F6654
	mov r0, #0x2f
	ldr r1, [r4, #0x34]
	lsl r0, r0, #4
	ldr r0, [r1, r0]
	mov r1, #7
	bl sub_020197F4
	ldr r0, [r4, #0x34]
	mov r1, #8
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetNextInput
	ldr r0, [r4, #0x34]
	mov r1, #1
	ldr r0, [r0, #0x2c]
	bl GridInputHandler_SetButtonInputMode
	mov r0, #0x8b
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0164

	thumb_func_start ov14_021F0198
ov14_021F0198: ; 0x021F0198
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F01B4 ; =0x000005F3
	bl PlaySE
	add r0, r4, #0
	mov r1, #5
	mov r2, #0x25
	bl ov14_021F68C0
	mov r0, #0xe
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	.balign 4, 0
_021F01B4: .word 0x000005F3
	thumb_func_end ov14_021F0198

	thumb_func_start ov14_021F01B8
ov14_021F01B8: ; 0x021F01B8
	push {r4, lr}
	add r4, r0, #0
	ldr r0, _021F01D4 ; =0x000005F3
	bl PlaySE
	add r0, r4, #0
	mov r1, #0x25
	bl ov14_021F6724
	mov r0, #0xe
	str r0, [r4, #0x30]
	mov r0, #6
	pop {r4, pc}
	nop
_021F01D4: .word 0x000005F3
	thumb_func_end ov14_021F01B8

	thumb_func_start ov14_021F01D8
ov14_021F01D8: ; 0x021F01D8
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #6
	add r4, r1, #0
	str r0, [sp]
	mov r1, #1
	str r1, [sp, #4]
	mov r0, #0xa
	str r0, [sp, #8]
	mov r0, #0
	add r2, r1, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0x11
	ldr r1, [r5, #0x34]
	lsl r0, r0, #6
	str r4, [r1, r0]
	mov r0, #2
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov14_021F01D8

	thumb_func_start ov14_021F0204
ov14_021F0204: ; 0x021F0204
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	mov r0, #6
	str r0, [sp]
	mov r0, #1
	str r0, [sp, #4]
	mov r0, #0xa
	str r0, [sp, #8]
	mov r0, #0
	add r4, r1, #0
	add r1, r0, #0
	add r2, r0, #0
	add r3, r0, #0
	bl BeginNormalPaletteFade
	mov r0, #0x11
	ldr r1, [r5, #0x34]
	lsl r0, r0, #6
	str r4, [r1, r0]
	mov r0, #2
	add sp, #0xc
	pop {r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0204

	thumb_func_start ov14_021F0234
ov14_021F0234: ; 0x021F0234
	push {r3, lr}
	str r2, [r0, #0x30]
	ldr r0, [r0, #0x34]
	bl ov14_021E5A44
	mov r0, #5
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0234

	thumb_func_start ov14_021F0244
ov14_021F0244: ; 0x021F0244
	push {r3, lr}
	str r1, [r0, #0x30]
	ldr r0, [r0, #0x34]
	bl ov14_021E5A54
	mov r0, #5
	pop {r3, pc}
	.balign 4, 0
	thumb_func_end ov14_021F0244

	thumb_func_start ov14_021F0254
ov14_021F0254: ; 0x021F0254
	push {r3, r4, r5, lr}
	add r4, r1, #0
	add r5, r0, #0
	cmp r4, #1
	bne _021F0266
	mov r1, #1
	bl ov14_021E5EFC
	b _021F026C
_021F0266:
	mov r1, #0
	bl ov14_021E5EFC
_021F026C:
	ldr r1, [r5, #0x34]
	ldr r0, _021F0278 ; =0x00000438
	strh r4, [r1, r0]
	mov r0, #7
	pop {r3, r4, r5, pc}
	nop
_021F0278: .word 0x00000438
	thumb_func_end ov14_021F0254

	thumb_func_start ov14_021F027C
ov14_021F027C: ; 0x021F027C
	ldr r3, _021F0288 ; =ov14_021F0204
	strb r1, [r0, #0x1e]
	mov r1, #9
	str r1, [r0, #0x30]
	mov r1, #1
	bx r3
	.balign 4, 0
_021F0288: .word ov14_021F0204
	thumb_func_end ov14_021F027C
