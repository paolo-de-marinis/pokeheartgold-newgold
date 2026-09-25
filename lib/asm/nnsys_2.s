	.include "asm/macros.inc"
	.include "nnsys.inc"
	.include "global.inc"

	.text

	arm_func_start NNSi_SndArcLoadWaveArc
NNSi_SndArcLoadWaveArc: ; 0x020CA194
	stmdb sp!, {r4, r5, r6, lr}
	mov r6, r1
	mov r5, r2
	mov r4, r3
	bl NNS_SndArcGetWaveArcInfo
	cmp r0, #0
	moveq r0, #5
	ldmeqia sp!, {r4, r5, r6, pc}
	tst r6, #4
	ldr r0, [r0]
	beq _020CA200
	mov r1, r0, lsr #0x18
	tst r1, #1
	mov r0, r0, lsl #8
	mov r1, r5
	beq _020CA1E4
	mov r2, r4
	mov r0, r0, lsr #8
	bl LoadWaveArcTable
	b _020CA1F0
_020CA1E4:
	mov r2, r4
	mov r0, r0, lsr #8
	bl LoadWaveArc
_020CA1F0:
	cmp r0, #0
	bne _020CA20C
	mov r0, #9
	ldmia sp!, {r4, r5, r6, pc}
_020CA200:
	mov r0, r0, lsl #8
	mov r0, r0, lsr #8
	bl NNS_SndArcGetFileAddress
_020CA20C:
	ldr r1, [sp, #0x10]
	cmp r1, #0
	strne r0, [r1]
	mov r0, #0
	ldmia sp!, {r4, r5, r6, pc}
	arm_func_end NNSi_SndArcLoadWaveArc

	arm_func_start NNSi_SndArcLoadFile
NNSi_SndArcLoadFile: ; 0x020CA220
	stmdb sp!, {r3, r4, r5, r6, r7, r8, lr}
	sub sp, sp, #4
	mov r8, r0
	mov r7, r1
	mov r6, r2
	mov r4, r3
	bl NNS_SndArcGetFileSize
	movs r5, r0
	addeq sp, sp, #4
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, pc}
	ldr r0, [sp, #0x20]
	cmp r0, #0
	addeq sp, sp, #4
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, pc}
	mov r2, r7
	mov r3, r6
	add r1, r5, #0x20
	str r4, [sp]
	bl NNS_SndHeapAlloc
	movs r4, r0
	addeq sp, sp, #4
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, pc}
	mov r0, r8
	mov r1, r4
	mov r2, r5
	mov r3, #0
	bl NNS_SndArcReadFile
	cmp r5, r0
	addne sp, sp, #4
	movne r0, #0
	ldmneia sp!, {r3, r4, r5, r6, r7, r8, pc}
	mov r0, r4
	mov r1, r5
	bl DC_StoreRange
	mov r0, r4
	add sp, sp, #4
	ldmia sp!, {r3, r4, r5, r6, r7, r8, pc}
	arm_func_end NNSi_SndArcLoadFile

	arm_func_start LoadSeq
LoadSeq: ; 0x020CA2C0
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	mov r7, r0
	mov r6, r1
	mov r5, r2
	bl NNS_SndArcGetFileAddress
	movs r4, r0
	bne _020CA320
	cmp r5, #0
	moveq r2, #0
	beq _020CA2F0
	bl NNS_SndArcGetCurrent
	mov r2, r0
_020CA2F0:
	ldr r1, _020CA328 ; =SeqDisposeCallback
	mov r0, r7
	mov r3, r7
	str r6, [sp]
	bl NNSi_SndArcLoadFile
	mov r4, r0
	cmp r5, #0
	cmpne r4, #0
	beq _020CA320
	mov r0, r7
	mov r1, r4
	bl NNS_SndArcSetFileAddress
_020CA320:
	mov r0, r4
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_020CA328: .word SeqDisposeCallback
	arm_func_end LoadSeq

	arm_func_start LoadSeqArc
LoadSeqArc: ; 0x020CA32C
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	mov r7, r0
	mov r6, r1
	mov r5, r2
	bl NNS_SndArcGetFileAddress
	movs r4, r0
	bne _020CA38C
	cmp r5, #0
	moveq r2, #0
	beq _020CA35C
	bl NNS_SndArcGetCurrent
	mov r2, r0
_020CA35C:
	ldr r1, _020CA394 ; =SeqDisposeCallback
	mov r0, r7
	mov r3, r7
	str r6, [sp]
	bl NNSi_SndArcLoadFile
	mov r4, r0
	cmp r5, #0
	cmpne r4, #0
	beq _020CA38C
	mov r0, r7
	mov r1, r4
	bl NNS_SndArcSetFileAddress
_020CA38C:
	mov r0, r4
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_020CA394: .word SeqDisposeCallback
	arm_func_end LoadSeqArc

	arm_func_start LoadBank
LoadBank: ; 0x020CA398
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	mov r7, r0
	mov r6, r1
	mov r5, r2
	bl NNS_SndArcGetFileAddress
	movs r4, r0
	bne _020CA3F8
	cmp r5, #0
	moveq r2, #0
	beq _020CA3C8
	bl NNS_SndArcGetCurrent
	mov r2, r0
_020CA3C8:
	ldr r1, _020CA400 ; =BankDisposeCallback
	mov r0, r7
	mov r3, r7
	str r6, [sp]
	bl NNSi_SndArcLoadFile
	mov r4, r0
	cmp r5, #0
	cmpne r4, #0
	beq _020CA3F8
	mov r0, r7
	mov r1, r4
	bl NNS_SndArcSetFileAddress
_020CA3F8:
	mov r0, r4
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_020CA400: .word BankDisposeCallback
	arm_func_end LoadBank

	arm_func_start LoadWaveArc
LoadWaveArc: ; 0x020CA404
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	mov r7, r0
	mov r6, r1
	mov r5, r2
	bl NNS_SndArcGetFileAddress
	movs r4, r0
	bne _020CA464
	cmp r5, #0
	moveq r2, #0
	beq _020CA434
	bl NNS_SndArcGetCurrent
	mov r2, r0
_020CA434:
	ldr r1, _020CA46C ; =WaveArcDisposeCallback
	mov r0, r7
	mov r3, r7
	str r6, [sp]
	bl NNSi_SndArcLoadFile
	mov r4, r0
	cmp r5, #0
	cmpne r4, #0
	beq _020CA464
	mov r0, r7
	mov r1, r4
	bl NNS_SndArcSetFileAddress
_020CA464:
	mov r0, r4
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_020CA46C: .word WaveArcDisposeCallback
	arm_func_end LoadWaveArc

	arm_func_start LoadWaveArcTable
LoadWaveArcTable: ; 0x020CA470
	stmdb sp!, {r3, r4, r5, r6, r7, r8, sb, lr}
	mov sb, r0
	mov r8, r1
	mov r7, r2
	bl NNS_SndArcGetFileAddress
	movs r5, r0
	bne _020CA564
	ldr r1, _020CA56C ; =_021E0914
	mov r0, sb
	mov r2, #0x3c
	mov r3, #0
	bl NNS_SndArcReadFile
	cmp r0, #0x3c
	movne r0, #0
	ldmneia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	ldr r0, _020CA570 ; =_021E0914
	cmp r8, #0
	ldr r0, [r0, #0x38]
	mov r6, r0, lsl #2
	mov r4, r6, lsl #1
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	cmp r7, #0
	moveq r3, #0
	beq _020CA4DC
	bl NNS_SndArcGetCurrent
	mov r3, r0
_020CA4DC:
	ldr r2, _020CA574 ; =WaveArcTableDisposeCallback
	mov r0, r8
	add r1, r4, #0x5c
	str sb, [sp]
	bl NNS_SndHeapAlloc
	movs r5, r0
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	mov r0, sb
	mov r1, r5
	add r2, r6, #0x3c
	mov r3, #0
	bl NNS_SndArcReadFile
	add r1, r6, #0x3c
	cmp r0, r1
	movne r0, #0
	ldmneia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	ldr r1, [r5, #0x38]
	add r0, r5, #0x3c
	mov r2, r6
	add r1, r0, r1, lsl #2
	bl MI_CpuCopy8
	mov r2, r6
	add r0, r5, #0x3c
	mov r1, #0
	bl MI_CpuFill8
	mov r0, r5
	add r1, r4, #0x3c
	bl DC_StoreRange
	cmp r7, #0
	beq _020CA564
	mov r0, sb
	mov r1, r5
	bl NNS_SndArcSetFileAddress
_020CA564:
	mov r0, r5
	ldmia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	.align 2, 0
_020CA56C: .word _021E0914
_020CA570: .word _021E0914
_020CA574: .word WaveArcTableDisposeCallback
	arm_func_end LoadWaveArcTable

	arm_func_start DisposeCallback
DisposeCallback: ; 0x020CA578
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	movs r4, r1
	mov r7, r0
	mov r6, r2
	ldmeqia sp!, {r3, r4, r5, r6, r7, pc}
	bl OS_DisableInterrupts
	mov r5, r0
	mov r0, r4
	bl NNS_SndArcSetCurrent
	mov r4, r0
	mov r0, r6
	bl NNS_SndArcGetFileAddress
	cmp r7, r0
	bne _020CA5BC
	mov r0, r6
	mov r1, #0
	bl NNS_SndArcSetFileAddress
_020CA5BC:
	mov r0, r4
	bl NNS_SndArcSetCurrent
	mov r0, r5
	bl OS_RestoreInterrupts
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	arm_func_end DisposeCallback

	arm_func_start SeqDisposeCallback
SeqDisposeCallback: ; 0x020CA5D0
	stmdb sp!, {r3, r4, r5, lr}
	mov r4, r1
	mov r1, r2
	mov r5, r0
	mov r2, r3
	bl DisposeCallback
	mov r0, r5
	add r1, r5, r4
	bl SND_InvalidateSeqData
	ldmia sp!, {r3, r4, r5, pc}
	arm_func_end SeqDisposeCallback

	arm_func_start BankDisposeCallback
BankDisposeCallback: ; 0x020CA5F8
	stmdb sp!, {r3, r4, r5, lr}
	mov r4, r1
	mov r1, r2
	mov r5, r0
	mov r2, r3
	bl DisposeCallback
	mov r0, r5
	add r1, r5, r4
	bl SND_InvalidateBankData
	mov r0, r5
	bl SND_DestroyBank
	ldmia sp!, {r3, r4, r5, pc}
	arm_func_end BankDisposeCallback

	arm_func_start WaveArcDisposeCallback
WaveArcDisposeCallback: ; 0x020CA628
	stmdb sp!, {r3, r4, r5, lr}
	mov r4, r1
	mov r1, r2
	mov r5, r0
	mov r2, r3
	bl DisposeCallback
	mov r0, r5
	add r1, r5, r4
	bl SND_InvalidateWaveData
	mov r0, r5
	bl SND_DestroyWaveArc
	ldmia sp!, {r3, r4, r5, pc}
	arm_func_end WaveArcDisposeCallback

	arm_func_start WaveArcTableDisposeCallback
WaveArcTableDisposeCallback: ; 0x020CA658
	stmdb sp!, {r4, lr}
	mov r1, r2
	mov r4, r0
	mov r2, r3
	bl DisposeCallback
	mov r0, r4
	bl SND_DestroyWaveArc
	ldmia sp!, {r4, pc}
	arm_func_end WaveArcTableDisposeCallback

	arm_func_start SingleWaveDisposeCallback
SingleWaveDisposeCallback: ; 0x020CA678
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	mov r5, r2
	mov r7, r0
	mov r4, r3
	mov r6, r1
	mov r0, r5
	mov r1, r4
	bl SND_GetWaveDataAddress
	cmp r7, r0
	bne _020CA6B0
	mov r0, r5
	mov r1, r4
	mov r2, #0
	bl SND_SetWaveDataAddress
_020CA6B0:
	mov r0, r7
	add r1, r7, r6
	bl SND_InvalidateWaveData
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	arm_func_end SingleWaveDisposeCallback

	arm_func_start LoadSingleWave
LoadSingleWave: ; 0x020CA6C0
	stmdb sp!, {r3, r4, r5, r6, r7, r8, sb, lr}
	mov r8, r0
	mov r7, r1
	mov r6, r2
	mov r5, r3
	bl SND_GetWaveDataAddress
	cmp r0, #0
	movne r0, #1
	ldmneia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	mov r0, r8
	bl SND_GetWaveDataCount
	ldr r1, [r8, #0x38]
	sub r0, r0, #1
	add r1, r1, r7
	add r1, r8, r1, lsl #2
	cmp r7, r0
	ldrlo r0, [r1, #0x40]
	ldr r4, [r1, #0x3c]
	ldrhs r0, [r8, #8]
	cmp r5, #0
	sub sb, r0, r4
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	ldr r2, _020CA784 ; =SingleWaveDisposeCallback
	mov r0, r5
	mov r3, r8
	add r1, sb, #0x20
	str r7, [sp]
	bl NNS_SndHeapAlloc
	movs r5, r0
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	mov r0, r6
	mov r1, r5
	mov r2, sb
	mov r3, r4
	bl NNS_SndArcReadFile
	cmp sb, r0
	movne r0, #0
	ldmneia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	mov r0, r5
	mov r1, sb
	bl DC_StoreRange
	mov r0, r8
	mov r1, r7
	mov r2, r5
	bl SND_SetWaveDataAddress
	mov r0, #1
	ldmia sp!, {r3, r4, r5, r6, r7, r8, sb, pc}
	.align 2, 0
_020CA784: .word SingleWaveDisposeCallback
	arm_func_end LoadSingleWave

	arm_func_start LoadSingleWaves
LoadSingleWaves: ; 0x020CA788
	stmdb sp!, {r3, r4, r5, r6, r7, r8, sb, sl, lr}
	sub sp, sp, #0x1c
	mov r8, r0
	add r0, sp, #0
	mov r7, r1
	mov r6, r2
	mov r5, r3
	ldr r4, [sp, #0x40]
	bl SND_GetFirstInstDataPos
	ldr r1, [sp]
	ldr r0, [sp, #4]
	str r1, [sp, #8]
	str r0, [sp, #0xc]
	cmp r7, #0
	add r2, sp, #8
	addeq sp, sp, #0x1c
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, sb, sl, pc}
	add r1, sp, #0x10
	mov r0, r7
	bl SND_GetNextInstData
	cmp r0, #0
	beq _020CA83C
	add sl, sp, #0x10
	add sb, sp, #8
_020CA7EC:
	ldrb r0, [sp, #0x10]
	cmp r0, #1
	ldreqh r0, [sp, #0x14]
	cmpeq r6, r0
	bne _020CA824
	ldrh r1, [sp, #0x12]
	mov r0, r8
	mov r2, r5
	mov r3, r4
	bl LoadSingleWave
	cmp r0, #0
	addeq sp, sp, #0x1c
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, sb, sl, pc}
_020CA824:
	mov r0, r7
	mov r1, sl
	mov r2, sb
	bl SND_GetNextInstData
	cmp r0, #0
	bne _020CA7EC
_020CA83C:
	mov r0, #1
	add sp, sp, #0x1c
	ldmia sp!, {r3, r4, r5, r6, r7, r8, sb, sl, pc}
	arm_func_end LoadSingleWaves

	arm_func_start NNS_SndArcPlayerSetup
NNS_SndArcPlayerSetup: ; 0x020CA848
	stmdb sp!, {r4, r5, r6, r7, r8, lr}
	mov r4, r0
	bl NNS_SndArcGetCurrent
	mov r6, #0
	mov r5, r6
_020CA85C:
	mov r0, r6
	bl NNS_SndArcGetStrmInfo
	movs r7, r0
	beq _020CA8D0
	ldrb r1, [r7]
	mov r0, r6
	bl NNS_SndPlayerSetPlayableSeqCount
	ldrh r1, [r7, #2]
	mov r0, r6
	bl NNS_SndPlayerSetAllocatableChannel
	ldr r0, [r7, #4]
	cmp r0, #0
	cmpne r4, #0
	beq _020CA8D0
	ldrb r0, [r7]
	mov r8, r5
	cmp r0, #0
	ble _020CA8D0
_020CA8A4:
	ldr r2, [r7, #4]
	mov r0, r6
	mov r1, r4
	bl NNS_SndPlayerCreateHeap
	cmp r0, #0
	moveq r0, #0
	ldmeqia sp!, {r4, r5, r6, r7, r8, pc}
	ldrb r0, [r7]
	add r8, r8, #1
	cmp r8, r0
	blt _020CA8A4
_020CA8D0:
	add r6, r6, #1
	cmp r6, #0x20
	blt _020CA85C
	mov r0, #1
	ldmia sp!, {r4, r5, r6, r7, r8, pc}
	arm_func_end NNS_SndArcPlayerSetup

	arm_func_start NNS_SndArcPlayerStartSeqEx
NNS_SndArcPlayerStartSeqEx: ; 0x020CA8E4
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	sub sp, sp, #8
	mov r7, r0
	ldr r0, [sp, #0x20]
	mov r6, r1
	mov r5, r2
	mov r4, r3
	bl NNS_SndArcGetSeqInfo
	cmp r0, #0
	addeq sp, sp, #8
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, pc}
	cmp r4, #0
	ldrltb r4, [r0, #8]
	cmp r5, #0
	ldrlth r5, [r0, #4]
	cmp r6, #0
	ldrltb r6, [r0, #9]
	ldr ip, [sp, #0x20]
	mov r2, r5
	str r0, [sp]
	mov r0, r7
	mov r1, r6
	mov r3, r4
	str ip, [sp, #4]
	bl StartSeq
	add sp, sp, #8
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	arm_func_end NNS_SndArcPlayerStartSeqEx

	arm_func_start NNS_SndArcPlayerStartSeqArc
NNS_SndArcPlayerStartSeqArc: ; 0x020CA954
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	sub sp, sp, #0x10
	mov r6, r1
	mov r7, r0
	mov r0, r6
	mov r5, r2
	bl NNS_SndArcGetSeqArcInfo
	cmp r0, #0
	addeq sp, sp, #0x10
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, pc}
	ldr r0, [r0]
	bl NNS_SndArcGetFileAddress
	movs r4, r0
	addeq sp, sp, #0x10
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, pc}
	mov r1, r5
	bl NNSi_SndSeqArcGetSeqInfo
	cmp r0, #0
	addeq sp, sp, #0x10
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, pc}
	stmia sp, {r0, r4, r6}
	str r5, [sp, #0xc]
	ldrb r1, [r0, #9]
	ldrh r2, [r0, #4]
	ldrb r3, [r0, #8]
	mov r0, r7
	bl StartSeqArc
	add sp, sp, #0x10
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	arm_func_end NNS_SndArcPlayerStartSeqArc

	arm_func_start StartSeq
StartSeq: ; 0x020CA9D4
	stmdb sp!, {r3, r4, r5, r6, r7, r8, lr}
	sub sp, sp, #0xc
	mov r8, r2
	mov r2, r3
	ldr r5, [sp, #0x28]
	mov r6, r0
	mov r7, r1
	bl NNSi_SndPlayerAllocSeqPlayer
	movs r4, r0
	addeq sp, sp, #0xc
	moveq r0, #0
	ldmeqia sp!, {r3, r4, r5, r6, r7, r8, pc}
	mov r0, r7
	mov r1, r4
	bl NNSi_SndPlayerAllocHeap
	mov r7, r0
	add ip, sp, #4
	mov r0, r8
	mov r2, r7
	mov r1, #6
	mov r3, #0
	str ip, [sp]
	bl NNSi_SndArcLoadBank
	cmp r0, #0
	beq _020CAA4C
	mov r0, r4
	bl NNSi_SndPlayerFreeSeqPlayer
	add sp, sp, #0xc
	mov r0, #0
	ldmia sp!, {r3, r4, r5, r6, r7, r8, pc}
_020CAA4C:
	ldr r0, [sp, #0x2c]
	add ip, sp, #8
	mov r2, r7
	mov r1, #1
	mov r3, #0
	str ip, [sp]
	bl NNSi_SndArcLoadSeq
	cmp r0, #0
	beq _020CAA84
	mov r0, r4
	bl NNSi_SndPlayerFreeSeqPlayer
	add sp, sp, #0xc
	mov r0, #0
	ldmia sp!, {r3, r4, r5, r6, r7, r8, pc}
_020CAA84:
	ldr r2, [sp, #8]
	ldr r3, [sp, #4]
	ldr r1, [r2, #0x18]
	mov r0, r4
	add r1, r2, r1
	mov r2, #0
	bl NNSi_SndPlayerStartSeq
	ldrb r1, [r5, #6]
	mov r0, r6
	bl NNS_SndPlayerSetInitialVolume
	ldrb r1, [r5, #7]
	mov r0, r6
	bl NNS_SndPlayerSetChannelPriority
	ldr r1, [sp, #0x2c]
	mov r0, r6
	bl NNS_SndPlayerSetSeqNo
	mov r0, #1
	add sp, sp, #0xc
	ldmia sp!, {r3, r4, r5, r6, r7, r8, pc}
	arm_func_end StartSeq

	arm_func_start StartSeqArc
StartSeqArc: ; 0x020CAAD0
	stmdb sp!, {r4, r5, r6, r7, r8, lr}
	sub sp, sp, #8
	mov r7, r2
	mov r2, r3
	ldr r6, [sp, #0x20]
	mov r4, r0
	mov r8, r1
	bl NNSi_SndPlayerAllocSeqPlayer
	movs r5, r0
	addeq sp, sp, #8
	moveq r0, #0
	ldmeqia sp!, {r4, r5, r6, r7, r8, pc}
	mov r0, r8
	mov r1, r5
	bl NNSi_SndPlayerAllocHeap
	add ip, sp, #4
	mov r2, r0
	mov r0, r7
	mov r1, #6
	mov r3, #0
	str ip, [sp]
	bl NNSi_SndArcLoadBank
	cmp r0, #0
	beq _020CAB44
	mov r0, r5
	bl NNSi_SndPlayerFreeSeqPlayer
	add sp, sp, #8
	mov r0, #0
	ldmia sp!, {r4, r5, r6, r7, r8, pc}
_020CAB44:
	ldr ip, [sp, #0x24]
	ldr r2, [r6]
	ldr r1, [ip, #0x18]
	ldr r3, [sp, #4]
	mov r0, r5
	add r1, ip, r1
	bl NNSi_SndPlayerStartSeq
	ldrb r1, [r6, #6]
	mov r0, r4
	bl NNS_SndPlayerSetInitialVolume
	ldrb r1, [r6, #7]
	mov r0, r4
	bl NNS_SndPlayerSetChannelPriority
	ldr r1, [sp, #0x28]
	ldr r2, [sp, #0x2c]
	mov r0, r4
	bl NNS_SndPlayerSetSeqArcNo
	mov r0, #1
	add sp, sp, #8
	ldmia sp!, {r4, r5, r6, r7, r8, pc}
	arm_func_end StartSeqArc

	arm_func_start NNSi_SndArcStrmMain
NNSi_SndArcStrmMain: ; 0x020CAB94
	stmdb sp!, {r3, r4, r5, r6, r7, lr}
	ldr r7, _020CAC9C ; =_021E0FEC
	ldr r4, _020CACA0 ; =_0210D750
	mov r5, #0
_020CABA4:
	ldr r1, [r7, #0x110]
	mov r0, r1, lsl #0x1f
	movs r0, r0, asr #0x1f
	beq _020CAC88
	ldr r0, [r7, #0x114]
	cmp r0, #0
	bne _020CABCC
	mov r0, r7
	bl ForceStopStrm__SndArc
	b _020CAC88
_020CABCC:
	mov r0, r1, lsl #0x1d
	movs r0, r0, asr #0x1f
	ldrne r0, [r7, #0x118]
	cmpne r0, #0
	beq _020CABF8
	mov r0, r7
	bl NNS_SndStrmStart
	ldr r0, [r7, #0x110]
	orr r0, r0, #2
	bic r0, r0, #4
	str r0, [r7, #0x110]
_020CABF8:
	ldr r0, [r7, #0x110]
	mov r0, r0, lsl #0x1e
	movs r0, r0, asr #0x1f
	beq _020CAC88
	add r0, r7, #0xe8
	bl NNSi_SndFaderUpdate
	ldr r1, [r7, #0x154]
	add r0, r7, #0xe8
	mov r1, r1, lsl #1
	ldrsh r6, [r4, r1]
	bl NNSi_SndFaderGet
	mov r0, r0, asr #8
	ldr r1, [r7, #0x158]
	mov r0, r0, lsl #1
	mov r2, r1, lsl #1
	ldrsh r1, [r4, r0]
	ldrsh r2, [r4, r2]
	ldr r0, [r7, #0x15c]
	add r1, r1, r6
	add r6, r2, r1
	cmp r6, r0
	beq _020CAC60
	mov r0, r7
	mov r1, r6
	bl NNS_SndStrmSetVolume
	str r6, [r7, #0x15c]
_020CAC60:
	ldr r0, [r7, #0x110]
	mov r0, r0, lsl #0x1c
	movs r0, r0, asr #0x1f
	beq _020CAC88
	add r0, r7, #0xe8
	bl NNSi_SndFaderIsFinished
	cmp r0, #0
	beq _020CAC88
	mov r0, r7
	bl ForceStopStrm__SndArc
_020CAC88:
	add r5, r5, #1
	cmp r5, #4
	add r7, r7, #0x174
	blt _020CABA4
	ldmia sp!, {r3, r4, r5, r6, r7, pc}
	.align 2, 0
_020CAC9C: .word _021E0FEC
_020CACA0: .word _0210D750
	arm_func_end NNSi_SndArcStrmMain

	arm_func_start FreePlayer
FreePlayer: ; 0x020CACA4
	ldr r2, [r0, #0x14c]
	cmp r2, #0
	movne r1, #0
	strne r1, [r2]
	strne r1, [r0, #0x14c]
	ldr r1, [r0, #0x110]
	bic r2, r1, #1
	bic r1, r2, #4
	bic r1, r1, #2
	str r1, [r0, #0x110]
	bx lr
	arm_func_end FreePlayer

	arm_func_start ForceStopStrm__SndArc
ForceStopStrm__SndArc: ; 0x020CACD0
	stmdb sp!, {r4, lr}
	mov r4, r0
	ldr r0, _020CAD60 ; =_021E0FC8
	bl OS_LockMutex
	ldr r0, _020CAD64 ; =_021E0950
	ldr r0, [r0, #4]
	cmp r0, #0
	beq _020CACFC
	add r0, r0, #0xc8
	add r0, r0, #0x400
	bl OS_LockMutex
_020CACFC:
	ldr r0, [r4, #0x110]
	mov r0, r0, lsl #0x1e
	movs r0, r0, asr #0x1f
	beq _020CAD14
	mov r0, r4
	bl NNS_SndStrmStop
_020CAD14:
	ldr r0, [r4, #0x110]
	mov r0, r0, lsl #0x1f
	movs r0, r0, asr #0x1f
	beq _020CAD30
	ldr r1, [r4, #0x170]
	mov r0, r4
	blx r1
_020CAD30:
	mov r0, r4
	bl ShutdownPlayer__SndArc
	ldr r0, _020CAD60 ; =_021E0FC8
	bl OS_UnlockMutex
	ldr r0, _020CAD64 ; =_021E0950
	ldr r0, [r0, #4]
	cmp r0, #0
	ldmeqia sp!, {r4, pc}
	add r0, r0, #0xc8
	add r0, r0, #0x400
	bl OS_UnlockMutex
	ldmia sp!, {r4, pc}
	.align 2, 0
_020CAD60: .word _021E0FC8
_020CAD64: .word _021E0950
	arm_func_end ForceStopStrm__SndArc

	arm_func_start ShutdownPlayer__SndArc
ShutdownPlayer__SndArc: ; 0x020CAD68
	stmdb sp!, {r4, lr}
	mov r4, r0
	ldr r1, [r4, #0x110]
	mov r1, r1, lsl #0x1f
	movs r1, r1, asr #0x1f
	ldmeqia sp!, {r4, pc}
	bl FreeChannel
	ldr r1, [r4, #0x168]
	mov r0, r4
	blx r1
	ldr r0, _020CADC4 ; =_021E0FE0
	mov r1, r4
	bl RemoveCommandByPlayer
	ldr r0, _020CADC8 ; =_021E0950
	ldr r0, [r0, #4]
	cmp r0, #0
	beq _020CADB8
	mov r1, r4
	add r0, r0, #0x4e0
	bl RemoveCommandByPlayer
_020CADB8:
	mov r0, r4
	bl FreePlayer
	ldmia sp!, {r4, pc}
	.align 2, 0
_020CADC4: .word _021E0FE0
_020CADC8: .word _021E0950
	arm_func_end ShutdownPlayer__SndArc

	arm_func_start FreeChannel
FreeChannel: ; 0x020CADCC
	stmdb sp!, {r3, lr}
	ldr r1, [r0, #0x120]
	cmp r1, #0
	ldmeqia sp!, {r3, pc}
	subs r1, r1, #1
	str r1, [r0, #0x120]
	ldmneia sp!, {r3, pc}
	bl NNS_SndStrmFreeChannel
	ldmia sp!, {r3, pc}
	arm_func_end FreeChannel

	arm_func_start RemoveCommandByPlayer
RemoveCommandByPlayer: ; 0x020CADF0
	stmdb sp!, {r4, r5, r6, r7, r8, lr}
	mov r8, r0
	mov r7, r1
	bl OS_DisableInterrupts
	mov r4, r0
	mov r0, r8
	mov r1, #0
	bl NNS_FndGetNextListObject
	movs r5, r0
	beq _020CAE54
_020CAE18:
	mov r0, r8
	mov r1, r5
	bl NNS_FndGetNextListObject
	ldr r1, [r5, #8]
	mov r6, r0
	cmp r1, r7
	bne _020CAE48
	mov r0, r8
	mov r1, r5
	bl NNS_FndRemoveListObject
	mov r0, r5
	bl FreeCommandBuffer
_020CAE48:
	mov r5, r6
	cmp r6, #0
	bne _020CAE18
_020CAE54:
	mov r0, r4
	bl OS_RestoreInterrupts
	ldmia sp!, {r4, r5, r6, r7, r8, pc}
	arm_func_end RemoveCommandByPlayer

	arm_func_start FreeCommandBuffer
FreeCommandBuffer: ; 0x020CAE60
	stmdb sp!, {r3, r4, r5, lr}
	mov r5, r0
	bl OS_DisableInterrupts
	mov r4, r0
	ldr r0, _020CAE88 ; =_021E095C
	mov r1, r5
	bl NNS_FndAppendListObject
	mov r0, r4
	bl OS_RestoreInterrupts
	ldmia sp!, {r3, r4, r5, pc}
	.align 2, 0
_020CAE88: .word _021E095C
	arm_func_end FreeCommandBuffer

	arm_func_start NNSi_SndSeqArcGetSeqInfo
NNSi_SndSeqArcGetSeqInfo: ; 0x020CAE8C
	cmp r1, #0
	movlt r0, #0
	bxlt lr
	ldr r2, [r0, #0x1c]
	cmp r1, r2
	movhs r0, #0
	bxhs lr
	mov r2, #0xc
	mul r3, r1, r2
	add ip, r0, #0x20
	ldr r1, [ip, r3]
	sub r0, r2, #0xd
	cmp r1, r0
	add r0, ip, r3
	moveq r0, #0
	bx lr
	arm_func_end NNSi_SndSeqArcGetSeqInfo

	arm_func_start NNSi_SndFaderInit
NNSi_SndFaderInit: ; 0x020CAECC
	mov r1, #0
	str r1, [r0, #4]
	str r1, [r0]
	str r1, [r0, #0xc]
	str r1, [r0, #8]
	bx lr
	arm_func_end NNSi_SndFaderInit

	arm_func_start NNSi_SndFaderSet
NNSi_SndFaderSet: ; 0x020CAEE4
	stmdb sp!, {r4, r5, r6, lr}
	mov r6, r0
	mov r5, r1
	mov r4, r2
	bl NNSi_SndFaderGet
	stmia r6, {r0, r5}
	str r4, [r6, #0xc]
	mov r0, #0
	str r0, [r6, #8]
	ldmia sp!, {r4, r5, r6, pc}
	arm_func_end NNSi_SndFaderSet

	arm_func_start NNSi_SndFaderGet
NNSi_SndFaderGet: ; 0x020CAF0C
	stmdb sp!, {r4, lr}
	ldr r1, [r0, #0xc]
	ldr r2, [r0, #8]
	cmp r2, r1
	ldrge r0, [r0, #4]
	ldmgeia sp!, {r4, pc}
	ldr r4, [r0]
	ldr r0, [r0, #4]
	sub r0, r0, r4
	mul r0, r2, r0
	bl _s32_div_f
	add r0, r4, r0
	ldmia sp!, {r4, pc}
	arm_func_end NNSi_SndFaderGet

	arm_func_start NNSi_SndFaderUpdate
NNSi_SndFaderUpdate: ; 0x020CAF40
	ldr r2, [r0, #8]
	ldr r1, [r0, #0xc]
	cmp r2, r1
	addlt r1, r2, #1
	strlt r1, [r0, #8]
	bx lr
	arm_func_end NNSi_SndFaderUpdate

	arm_func_start NNSi_SndFaderIsFinished
NNSi_SndFaderIsFinished: ; 0x020CAF58
	ldr r1, [r0, #8]
	ldr r0, [r0, #0xc]
	cmp r1, r0
	movge r0, #1
	movlt r0, #0
	bx lr
	arm_func_end NNSi_SndFaderIsFinished

	.rodata

_02109200:
	.word AllocatorAllocForExpHeap
	.word AllocatorFreeForExpHeap
	.word AllocatorAllocForSDKHeap
	.word AllocatorFreeForSDKHeap
_02109210:
	.word DoTransfer3dTex
	.word DoTransfer3dTexPltt
	.word DoTransfer3dClearImageColor
	.word DoTransfer3dClearImageDepth
	.word DoTransfer2dBG0CharMain
	.word DoTransfer2dBG1CharMain
	.word DoTransfer2dBG2CharMain
	.word DoTransfer2dBG3CharMain
	.word DoTransfer2dBG0ScrMain
	.word DoTransfer2dBG1ScrMain
	.word DoTransfer2dBG2ScrMain
	.word DoTransfer2dBG3ScrMain
	.word DoTransfer2dBG2BmpMain
	.word DoTransfer2dBG3BmpMain
	.word DoTransfer2dObjPlttMain
	.word DoTransfer2dBGPlttMain
	.word DoTransfer2dObjExtPlttMain
	.word DoTransfer2dBGExtPlttMain
	.word DoTransfer2dObjOamMain
	.word DoTransfer2dObjCharMain
	.word DoTransfer2dBG0CharSub
	.word DoTransfer2dBG1CharSub
	.word DoTransfer2dBG2CharSub
	.word DoTransfer2dBG3CharSub
	.word DoTransfer2dBG0ScrSub
	.word DoTransfer2dBG1ScrSub
	.word DoTransfer2dBG2ScrSub
	.word DoTransfer2dBG3ScrSub
	.word DoTransfer2dBG2BmpSub
	.word DoTransfer2dBG3BmpSub
	.word DoTransfer2dObjPlttSub
	.word DoTransfer2dBGPlttSub
	.word DoTransfer2dObjExtPlttSub
	.word DoTransfer2dBGExtPlttSub
	.word DoTransfer2dObjOamSub
	.word DoTransfer2dObjCharSub
_021092A0:
	.byte 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x08, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x08, 0x00, 0x00
_021092E0:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_021092EC:
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0xFF, 0xFF
_021092F8:
	.byte 0x08, 0x00, 0x10, 0x00, 0x20, 0x00, 0x40, 0x00
	.byte 0x08, 0x00, 0x08, 0x00, 0x10, 0x00, 0x20, 0x00, 0x10, 0x00, 0x20, 0x00, 0x20, 0x00, 0x40, 0x00
_02109310:
	.byte 0x08, 0x00, 0x10, 0x00, 0x20, 0x00, 0x40, 0x00, 0x10, 0x00, 0x20, 0x00, 0x20, 0x00, 0x40, 0x00
	.byte 0x08, 0x00, 0x08, 0x00, 0x10, 0x00, 0x20, 0x00
_02109328:
	.byte 0x00, 0x00, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00
	.byte 0x23, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00
_0210933C:
	.byte 0x03, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0x00, 0x00
_02109344:
	.byte 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00
	.byte 0x08, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00
	.byte 0x80, 0x00, 0x00, 0x00
_02109364:
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00
_02109394:
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x03, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
_021093CC:
	.byte 0x00, 0x10, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
_021093F0:
	.word DrawGlyphLine, ClearLine, ClearAreaLine
_021093FC:
	.word DrawGlyphLine, ClearContinuous, ClearAreaLine
_02109408:
	.word DrawGlyph1D, ClearContinuous, ClearArea1D
_02109414:
	.byte 0x00, 0x00, 0x01, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00, 0x01, 0x01, 0x01
	.byte 0x02, 0x01, 0x02, 0x01, 0x00, 0x02, 0x01, 0x02, 0x02, 0x02, 0x03, 0x02, 0x00, 0x02, 0x01, 0x02
	.byte 0x02, 0x03, 0x03, 0x03
_02109434:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x40, 0x00, 0x40
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x40, 0x00, 0x80
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x40, 0x00, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
	.byte 0x00, 0x40, 0x00, 0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0xC0
	.byte 0x00, 0x00, 0x00, 0xC0
_02109474:
	.byte 0x00, 0x00, 0x00, 0x00, 0xFF, 0x7F, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x7F
	.byte 0xFF, 0x7F, 0xFF, 0x7F, 0x00, 0x80, 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x80, 0xFF, 0x7F
	.byte 0xFF, 0xFF, 0xFF, 0x7F
_02109494:
	.byte 0x04, 0x05, 0x07, 0x08, 0x03, 0x05, 0x06, 0x08, 0x03, 0x04, 0x06, 0x07
	.byte 0x01, 0x02, 0x07, 0x08, 0x00, 0x02, 0x06, 0x08, 0x00, 0x01, 0x06, 0x07, 0x01, 0x02, 0x04, 0x05
	.byte 0x00, 0x02, 0x03, 0x05, 0x00, 0x01, 0x03, 0x04
_021094B8:
	.byte 0x04, 0x05, 0x07, 0x08, 0x03, 0x05, 0x06, 0x08
	.byte 0x03, 0x04, 0x06, 0x07, 0x01, 0x02, 0x07, 0x08, 0x00, 0x02, 0x06, 0x08, 0x00, 0x01, 0x06, 0x07
	.byte 0x01, 0x02, 0x04, 0x05, 0x00, 0x02, 0x03, 0x05, 0x00, 0x01, 0x03, 0x04

	.data

	.public NNS_GfdDefaultFuncAllocTexVram
NNS_GfdDefaultFuncAllocTexVram:
	.word AllocTexVram_
	.public NNS_GfdDefaultFuncFreeTexVram
NNS_GfdDefaultFuncFreeTexVram:
	.word FreeTexVram_
	.public NNS_GfdDefaultFuncAllocPlttVram
NNS_GfdDefaultFuncAllocPlttVram:
	.word AllocPlttVram_
	.public NNS_GfdDefaultFuncFreePlttVram
NNS_GfdDefaultFuncFreePlttVram:
	.word FreePlttVram_
_02110934:
	.word _02110950
	.word _02110998
_0211093C:
	.word _021109B0
	.word _02110998
	.word _02110950
	.word _02110980
	.word _02110968
_02110950:
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
_02110968:
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x02, 0x00
_02110980:
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x02, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x03, 0x00
_02110998:
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x04, 0x00
_021109B0:
	.byte 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x04, 0x00, 0xFF, 0xFF, 0x00, 0x00, 0x06, 0x00
_021109C8:
	.word CpuLoadOAMMain_
	.word CpuLoadOAMSub_
	.word 0
	.word 0
	.word 0
_021109DC:
	.byte 0xFE, 0xFF, 0x00, 0x00
	.byte 0xFF, 0xFF, 0xFF, 0xFF
_021109E4:
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_021109FC:
	.byte 0x00, 0xF0, 0xFF, 0xFF
_02110A00:
	.byte 0x05, 0x00, 0x00, 0x00
_02110A04:
	.word NNSi_G3dAnmCalcNsBva
_02110A08:
	.word NNSi_G3dAnmCalcNsBca
	.public _02110A0C
_02110A0C:
	.word NNSi_G3dAnmCalcNsBta
_02110A10:
	.word NNSi_G3dAnmCalcNsBtp
_02110A14:
	.word NNSi_G3dAnmCalcNsBma
_02110A18:
	.word NNSi_G3dAnmBlendVis
_02110A1C:
	.word NNSi_G3dAnmBlendJnt
_02110A20:
	.word NNSi_G3dAnmBlendMat
_02110A24:
	.byte 0x4D, 0x00, 0x41, 0x4D
_02110A28:
	.word NNSi_G3dAnmObjInitNsBma
	.byte 0x4D, 0x00, 0x50, 0x54
	.word NNSi_G3dAnmObjInitNsBtp
	.byte 0x4D, 0x00, 0x41, 0x54
	.word NNSi_G3dAnmObjInitNsBta
	.byte 0x56, 0x00, 0x41, 0x56
	.word NNSi_G3dAnmObjInitNsBva
	.byte 0x4A, 0x00, 0x41, 0x43
	.word NNSi_G3dAnmObjInitNsBca
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
_02110A74:
	.word NNSi_G3dSendJointSRTBasic
	.word NNSi_G3dSendJointSRTMaya
	.word NNSi_G3dSendJointSRTSi3d
_02110A80:
	.word NNSi_G3dGetJointScaleBasic
	.word NNSi_G3dGetJointScaleMaya
	.word NNSi_G3dGetJointScaleSi3d
_02110A8C:
	.word NNSi_G3dSendTexSRTMaya
	.word NNSi_G3dSendTexSRTSi3d
	.word NNSi_G3dSendTexSRT3dsMax
	.word NNSi_G3dSendTexSRTXsi
_02110A9C:
	.byte 0x2A, 0x00, 0x00, 0x00
_02110AA0:
	.byte 0x00, 0x00, 0x00, 0x00, 0x2A, 0x00, 0x00, 0x00
_02110AA8:
	.byte 0x00, 0x00, 0x00, 0x00
_02110AAC:
	.word NNSi_G3dFuncSbc_MAT_InternalDefault
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02110ABC:
	.word NNSi_G3dFuncSbc_SHP_InternalDefault
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02110ACC:
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00
_02110B0C:
	.byte 0x12, 0x10, 0x17, 0x1B
_02110B10:
	.byte 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
_02110B18:
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00
_02110B3C:
	.byte 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02110B48:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
_02110B54:
	.byte 0x12, 0x10, 0x17, 0x1B
_02110B58:
	.byte 0x01, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
_02110B60:
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x10, 0x00, 0x00
_02110B84:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02110B90:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
_02110B9C:
	.word NNSi_G3dFuncSbc_NOP
	.word NNSi_G3dFuncSbc_RET
	.word NNSi_G3dFuncSbc_NODE
	.word NNSi_G3dFuncSbc_MTX
	.word NNSi_G3dFuncSbc_MAT
	.word NNSi_G3dFuncSbc_SHP
	.word NNSi_G3dFuncSbc_NODEDESC
	.word NNSi_G3dFuncSbc_BB
	.word NNSi_G3dFuncSbc_BBY
	.word NNSi_G3dFuncSbc_NODEMIX
	.word NNSi_G3dFuncSbc_CALLDL
	.word NNSi_G3dFuncSbc_POSSCALE
	.word NNSi_G3dFuncSbc_ENVMAP
	.word NNSi_G3dFuncSbc_PRJMAP
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
	.word 0x00000000
_02110C1C:
	.word texmtxCalc_flag_
	.word texmtxCalc_flagS_
	.word texmtxCalc_flagR_
	.word texmtxCalc_flagRS_
	.word texmtxCalc_flagT_
	.word texmtxCalc_flagTS_
	.word texmtxCalc_flagTR_
	.word texmtxCalc_flagTRS_
_02110C3C:
	.word texmtxCalc_flag___3dsmax
	.word texmtxCalc_flagS___3dsmax
	.word texmtxCalc_flagR___3dsmax
	.word texmtxCalc_flagRS___3dsmax
	.word texmtxCalc_flagT___3dsmax
	.word texmtxCalc_flagTS___3dsmax
	.word texmtxCalc_flagTR___3dsmax
	.word texmtxCalc_flagTRS___3dsmax
_02110C5C:
	.word texmtxCalc_flag___xsi
	.word texmtxCalc_flagS___xsi
	.word texmtxCalc_flagR___xsi
	.word texmtxCalc_flagRS___xsi
	.word texmtxCalc_flagT___xsi
	.word texmtxCalc_flagTS___xsi
	.word texmtxCalc_flagTR___xsi
	.word texmtxCalc_flagTRS___xsi
