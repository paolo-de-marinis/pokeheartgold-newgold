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

.public ov18_021F8CCC
.public ov18_021F8F10
.public ov18_021F8FA0
.public ov18_021F91F0
.public ov18_021F95CC
.public ov18_021FBD60
.public ov18_021FBD7C
.public ov18_021FBD98

	.text

	thumb_func_start ov18_021F8884
ov18_021F8884: ; 0x021F8884
	push {r3, r4, r5, r6, r7, lr}
	ldr r2, _021F8900 ; =0x00001030
	add r5, r0, #0
	add r4, r1, #0
	add r1, r5, r2
	mov r0, #0
	lsr r2, r2, #1
	bl MIi_CpuClear32
	cmp r4, #1
	ldr r0, _021F8904 ; =0x0000102C
	bne _021F88D6
	ldrh r0, [r5, r0]
	mov r6, #0
	cmp r0, #0
	bls _021F88FE
	ldr r7, _021F8904 ; =0x0000102C
	add r4, r5, #0
_021F88A8:
	ldr r0, _021F8908 ; =0x00001858
	ldr r1, _021F890C ; =0x00000878
	ldrb r0, [r5, r0]
	ldrh r1, [r4, r1]
	bl Pokedex_ConvertToCurrentDexNo
	ldr r1, _021F890C ; =0x00000878
	sub r0, r0, #1
	ldrh r2, [r4, r1]
	lsl r0, r0, #2
	ldr r1, _021F8900 ; =0x00001030
	add r0, r5, r0
	strh r2, [r0, r1]
	ldr r1, _021F8910 ; =0x0000087A
	add r6, r6, #1
	ldrh r2, [r4, r1]
	ldr r1, _021F8914 ; =0x00001032
	add r4, r4, #4
	strh r2, [r0, r1]
	ldrh r0, [r5, r7]
	cmp r6, r0
	blo _021F88A8
	pop {r3, r4, r5, r6, r7, pc}
_021F88D6:
	ldrh r0, [r5, r0]
	mov r1, #0
	cmp r0, #0
	bls _021F88FE
	ldr r3, _021F8918 ; =0x00001034
	ldr r4, _021F8910 ; =0x0000087A
	add r7, r3, #0
	add r0, r5, #0
	add r6, r3, #2
	sub r7, #8
_021F88EA:
	ldr r2, _021F890C ; =0x00000878
	add r1, r1, #1
	ldrh r2, [r0, r2]
	strh r2, [r0, r3]
	ldrh r2, [r0, r4]
	strh r2, [r0, r6]
	ldrh r2, [r5, r7]
	add r0, r0, #4
	cmp r1, r2
	blo _021F88EA
_021F88FE:
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
_021F8900: .word 0x00001030
_021F8904: .word 0x0000102C
_021F8908: .word 0x00001858
_021F890C: .word 0x00000878
_021F8910: .word 0x0000087A
_021F8914: .word 0x00001032
_021F8918: .word 0x00001034
	thumb_func_end ov18_021F8884

	thumb_func_start ov18_021F891C
ov18_021F891C: ; 0x021F891C
	push {r3, lr}
	add r2, r0, #0
	cmp r1, #0
	bne _021F892A
	ldr r0, _021F8944 ; =0x0000102C
	ldrh r0, [r2, r0]
	pop {r3, pc}
_021F892A:
	ldr r1, _021F8944 ; =0x0000102C
	ldr r0, _021F8948 ; =0x00001858
	ldrh r1, [r2, r1]
	ldrb r0, [r2, r0]
	sub r1, r1, #1
	lsl r1, r1, #2
	add r2, r2, r1
	ldr r1, _021F894C ; =0x00000878
	ldrh r1, [r2, r1]
	bl Pokedex_ConvertToCurrentDexNo
	pop {r3, pc}
	nop
_021F8944: .word 0x0000102C
_021F8948: .word 0x00001858
_021F894C: .word 0x00000878
	thumb_func_end ov18_021F891C

	thumb_func_start ov18_021F8950
ov18_021F8950: ; 0x021F8950
	push {r3, lr}
	cmp r1, #0
	bne _021F8962
	bl ov18_021F891C
	mov r1, #0xf
	bl _u32_div_f
	pop {r3, pc}
_021F8962:
	bl ov18_021F891C
	sub r0, r0, #1
	mov r1, #0xf
	bl _u32_div_f
	pop {r3, pc}
	thumb_func_end ov18_021F8950

	thumb_func_start ov18_021F8970
ov18_021F8970: ; 0x021F8970
	bx lr
	.balign 4, 0
	thumb_func_end ov18_021F8970

	thumb_func_start ov18_021F8974
ov18_021F8974: ; 0x021F8974
	push {r3, r4, r5, lr}
	add r5, r0, #0
	mov r1, #0x96
	ldr r0, [r5, #0x14]
	lsl r1, r1, #2
	bl Heap_Alloc
	mov r2, #0x96
	mov r1, #0
	lsl r2, r2, #2
	add r4, r0, #0
	bl memset
	add r2, r4, #0
	mov r1, #0x18
_021F8992:
	ldrb r0, [r5]
	add r5, r5, #1
	strb r0, [r2]
	add r2, r2, #1
	sub r1, r1, #1
	bne _021F8992
	ldr r1, [r4, #0x14]
	mov r0, #0x44
	bl NARC_New
	str r0, [r4, #0x1c]
	mov r0, #9
	mov r2, #0
	lsl r0, r0, #6
	strh r2, [r4, r0]
	add r0, #0x14
	str r2, [r4, r0]
	ldr r0, _021F89C4 ; =ov18_021F89F8
	add r1, r4, #0
	bl SysTask_CreateOnMainQueue
	str r0, [r4, #0x18]
	add r0, r4, #0
	pop {r3, r4, r5, pc}
	nop
_021F89C4: .word ov18_021F89F8
	thumb_func_end ov18_021F8974

	thumb_func_start ov18_021F89C8
ov18_021F89C8: ; 0x021F89C8
	mov r1, #0x95
	lsl r1, r1, #2
	ldr r0, [r0, r1]
	bx lr
	thumb_func_end ov18_021F89C8

	thumb_func_start ov18_021F89D0
ov18_021F89D0: ; 0x021F89D0
	push {r4, lr}
	add r4, r0, #0
	bl ov18_021F91F0
	add r0, r4, #0
	bl ov18_021F8F10
	add r0, r4, #0
	bl ov18_021F8BEC
	ldr r0, [r4, #0x1c]
	bl NARC_Delete
	ldr r0, [r4, #0x18]
	bl SysTask_Destroy
	add r0, r4, #0
	bl Heap_Free
	pop {r4, pc}
	thumb_func_end ov18_021F89D0

	thumb_func_start ov18_021F89F8
ov18_021F89F8: ; 0x021F89F8
	push {r4, lr}
	sub sp, #8
	add r4, r1, #0
	mov r1, #9
	lsl r1, r1, #6
	ldrh r0, [r4, r1]
	cmp r0, #4
	bhi _021F8AA0
	add r0, r0, r0
	add r0, pc
	ldrh r0, [r0, #6]
	lsl r0, r0, #0x10
	asr r0, r0, #0x10
	add pc, r0
ov18_021F8A14: ; jump table
	.short ov18_021F8A1E - ov18_021F8A14 - 2 ; case 0
	.short ov18_021F8A52 - ov18_021F8A14 - 2 ; case 1
	.short ov18_021F8A66 - ov18_021F8A14 - 2 ; case 2
	.short ov18_021F8A8A - ov18_021F8A14 - 2 ; case 3
	.short _021F8AA0 - ov18_021F8A14 - 2 ; case 4
ov18_021F8A1E:
	ldr r0, _021F8AB4 ; =0x04000050
	mov r1, #0
	strh r1, [r0]
	add r0, r4, #0
	bl ov18_021F8AB8
	add r0, r4, #0
	bl ov18_021F8B10
	add r0, r4, #0
	bl ov18_021F8CCC
	add r0, r4, #0
	bl ov18_021F8FA0
	add r0, r4, #0
	bl ov18_021F95CC
	add r0, r4, #0
	bl ov18_021F8C0C
	mov r0, #9
	mov r1, #1
	lsl r0, r0, #6
	strh r1, [r4, r0]
	b _021F8AA0
ov18_021F8A52:
	add r0, r4, #0
	bl ov18_021F8C48
	cmp r0, #1
	bne _021F8AA0
	mov r0, #9
	mov r1, #2
	lsl r0, r0, #6
	strh r1, [r4, r0]
	b _021F8AA0
ov18_021F8A66:
	add r2, r1, #0
	sub r2, #0x41
	str r2, [sp]
	mov r0, #0
	str r0, [sp, #4]
	add r1, r1, #4
	ldr r1, [r4, r1]
	mov r0, #0xe
	lsl r1, r1, #0x10
	lsr r1, r1, #0x10
	add r3, r2, #0
	bl PlayCryEx
	mov r0, #9
	mov r1, #3
	lsl r0, r0, #6
	strh r1, [r4, r0]
	b _021F8AA0
ov18_021F8A8A:
	bl IsCryFinished
	cmp r0, #0
	bne _021F8AA0
	mov r0, #0x95
	mov r1, #1
	lsl r0, r0, #2
	str r1, [r4, r0]
	mov r1, #4
	sub r0, #0x14
	strh r1, [r4, r0]
_021F8AA0:
	add r0, r4, #0
	add r0, #0xb4
	ldr r0, [r0]
	bl SpriteList_RenderAndAnimateSprites
	add r0, r4, #0
	bl ov18_021F8C68
	add sp, #8
	pop {r4, pc}
	.balign 4, 0
_021F8AB4: .word 0x04000050
	thumb_func_end ov18_021F89F8

	thumb_func_start ov18_021F8AB8
ov18_021F8AB8: ; 0x021F8AB8
	push {r3, r4, r5, lr}
	add r5, r0, #0
	ldr r0, [r5, #0xc]
	bl AcquireMonLock
	add r4, r0, #0
	ldr r0, [r5, #0xc]
	mov r1, #5
	mov r2, #0
	bl GetMonData
	mov r1, #0x91
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	mov r1, #0x70
	mov r2, #0
	bl GetMonData
	mov r1, #0x92
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	mov r1, #0xb1
	mov r2, #0
	bl GetMonData
	mov r1, #0x93
	lsl r1, r1, #2
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	mov r1, #0xb2
	mov r2, #0
	bl GetMonData
	mov r1, #0x25
	lsl r1, r1, #4
	str r0, [r5, r1]
	ldr r0, [r5, #0xc]
	add r1, r4, #0
	bl ReleaseMonLock
	pop {r3, r4, r5, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8AB8

	thumb_func_start ov18_021F8B10
ov18_021F8B10: ; 0x021F8B10
	push {r4, r5, lr}
	sub sp, #0x64
	add r4, r0, #0
	mov r0, #0
	add r1, r0, #0
	bl SetBgPriority
	mov r0, #1
	add r1, r0, #0
	bl GfGfx_EngineATogglePlanes
	ldr r5, _021F8BE0 ; =ov18_021FBD7C
	add r3, sp, #0x48
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
	ldr r0, [r4]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r3, [r4, #0x14]
	mov r0, #1
	mov r1, #0x20
	mov r2, #0
	bl BG_ClearCharDataRange
	ldr r5, _021F8BE4 ; =ov18_021FBD60
	add r3, sp, #0x2c
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #2
	str r0, [r3]
	ldr r0, [r4]
	mov r3, #0
	bl InitBgFromTemplate
	ldr r5, _021F8BE8 ; =ov18_021FBD98
	add r3, sp, #0x10
	ldmia r5!, {r0, r1}
	add r2, r3, #0
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldmia r5!, {r0, r1}
	stmia r3!, {r0, r1}
	ldr r0, [r5]
	mov r1, #3
	str r0, [r3]
	ldr r0, [r4]
	mov r3, #0
	bl InitBgFromTemplate
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r4, #0x14]
	mov r1, #0x13
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x1c]
	ldr r2, [r4]
	mov r3, #2
	bl GfGfxLoader_LoadCharDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	mov r0, #1
	str r0, [sp, #8]
	ldr r0, [r4, #0x14]
	mov r1, #0x14
	str r0, [sp, #0xc]
	ldr r0, [r4, #0x1c]
	ldr r2, [r4]
	mov r3, #2
	bl GfGfxLoader_LoadScrnDataFromOpenNarc
	mov r0, #0
	str r0, [sp]
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	ldr r1, [r4, #0x1c]
	ldr r3, [r4, #0x14]
	mov r2, #0x12
	bl PaletteData_LoadOpenNarc
	add sp, #0x64
	pop {r4, r5, pc}
	nop
_021F8BE0: .word ov18_021FBD7C
_021F8BE4: .word ov18_021FBD60
_021F8BE8: .word ov18_021FBD98
	thumb_func_end ov18_021F8B10

	thumb_func_start ov18_021F8BEC
ov18_021F8BEC: ; 0x021F8BEC
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4]
	mov r1, #3
	bl FreeBgTilemapBuffer
	ldr r0, [r4]
	mov r1, #2
	bl FreeBgTilemapBuffer
	ldr r0, [r4]
	mov r1, #1
	bl FreeBgTilemapBuffer
	pop {r4, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8BEC

	thumb_func_start ov18_021F8C0C
ov18_021F8C0C: ; 0x021F8C0C
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	mov r0, #0x10
	str r0, [sp]
	mov r0, #0
	str r0, [sp, #4]
	str r0, [sp, #8]
	ldr r0, [r4, #4]
	ldr r2, _021F8C44 ; =0x0000FFFF
	mov r1, #5
	mov r3, #1
	bl PaletteData_BeginPaletteFade
	mov r2, #0
	str r2, [sp]
	ldr r0, [r4, #0x20]
	mov r1, #0x10
	add r3, r2, #0
	bl Pokepic_StartPaletteFade
	ldr r0, [r4, #4]
	mov r1, #0
	bl PaletteData_SetAutoTransparent
	add sp, #0xc
	pop {r3, r4, pc}
	nop
_021F8C44: .word 0x0000FFFF
	thumb_func_end ov18_021F8C0C

	thumb_func_start ov18_021F8C48
ov18_021F8C48: ; 0x021F8C48
	push {r4, lr}
	add r4, r0, #0
	ldr r0, [r4, #4]
	bl PaletteData_GetSelectedBuffersBitmask
	cmp r0, #0
	bne _021F8C64
	ldr r0, [r4, #0x20]
	bl Pokepic_ResumePaletteFade
	cmp r0, #0
	bne _021F8C64
	mov r0, #1
	pop {r4, pc}
_021F8C64:
	mov r0, #0
	pop {r4, pc}
	thumb_func_end ov18_021F8C48

	thumb_func_start ov18_021F8C68
ov18_021F8C68: ; 0x021F8C68
	push {r3, r4, lr}
	sub sp, #0xc
	add r4, r0, #0
	ldr r0, _021F8CC8 ; =0x00000242
	ldrh r1, [r4, r0]
	add r1, r1, #1
	strh r1, [r4, r0]
	ldrh r0, [r4, r0]
	cmp r0, #0x10
	bne _021F8C9E
	mov r0, #0x20
	str r0, [sp]
	mov r1, #2
	mov r2, #0
	str r1, [sp, #4]
	mov r0, #7
	str r0, [sp, #8]
	ldr r0, [r4]
	add r3, r2, #0
	bl BgTilemapRectChangePalette
	ldr r0, [r4]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	add sp, #0xc
	pop {r3, r4, pc}
_021F8C9E:
	cmp r0, #0x20
	bne _021F8CC4
	mov r0, #0x20
	str r0, [sp]
	mov r1, #2
	mov r2, #0
	str r1, [sp, #4]
	str r2, [sp, #8]
	ldr r0, [r4]
	add r3, r2, #0
	bl BgTilemapRectChangePalette
	ldr r0, [r4]
	mov r1, #2
	bl ScheduleBgTilemapBufferTransfer
	ldr r0, _021F8CC8 ; =0x00000242
	mov r1, #0
	strh r1, [r4, r0]
_021F8CC4:
	add sp, #0xc
	pop {r3, r4, pc}
	.balign 4, 0
_021F8CC8: .word 0x00000242
	thumb_func_end ov18_021F8C68
