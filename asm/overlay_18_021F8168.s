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

	thumb_func_start ov18_021F8168
ov18_021F8168: ; 0x021F8168
	push {r4, r5, lr}
	sub sp, #0xc
	add r5, r0, #0
	add r4, r1, #0
	; u32 size;
	; void * ret;
	; GF_ASSERT(a < 82);
	cmp r5, #0x52
	blo _021F8178
	bl GF_AssertFail
_021F8178:
	; ret = GfGfxLoader_LoadFromNarc_GetSizeOut(GetPokedexDataNarcID(), a0 + 11, FALSE, HEAP_ID_POKEDEX_APP, FALSE, &size);
	bl GetPokedexDataNarcID
	mov r2, #0
	str r2, [sp]
	add r1, sp, #8
	add r5, #0xb
	str r1, [sp, #4]
	add r1, r5, #0
	mov r3, #0x25
	bl GfGfxLoader_LoadFromNarc_GetSizeOut
	; *a1 = size / 2;
	ldr r1, [sp, #8]
	lsr r1, r1, #1
	str r1, [r4]
	; return ret;
	add sp, #0xc
	pop {r4, r5, pc}
	thumb_func_end ov18_021F8168

	thumb_func_start ov18_021F8198
ov18_021F8198: ; 0x021F8198
	push {r3, r4, r5, r6, r7, lr}
	sub sp, #8
	ldr r7, [sp, #0x20]
	add r5, r1, #0
	mov r6, #0
	add r4, r3, #0
	str r0, [sp]
	str r2, [sp, #4]
	str r6, [r5]
	cmp r7, #0
	bls _021F81D2
_021F81AE:
	ldrh r1, [r4]
	ldr r0, [sp, #4]
	bl Pokedex_CheckMonSeenFlag
	cmp r0, #0
	beq _021F81CA
	ldr r1, [r5]
	ldrh r0, [r4]
	lsl r2, r1, #1
	ldr r1, [sp]
	strh r0, [r1, r2]
	ldr r0, [r5]
	add r0, r0, #1
	str r0, [r5]
_021F81CA:
	add r6, r6, #1
	add r4, r4, #2
	cmp r6, r7
	blo _021F81AE
_021F81D2:
	add sp, #8
	pop {r3, r4, r5, r6, r7, pc}
	.balign 4, 0
	thumb_func_end ov18_021F8198
