#include "constants/scrcmd.h"
#include "fielddata/script/scr_seq/event_T21PC0101.h"
#include "msgdata/msg/msg_0552_T21PC0101.h"
	.include "asm/macros/script.inc"

	.rodata

	ScrDef scr_seq_T21PC0101_000
	ScrDef scr_seq_T21PC0101_001
	ScrDef scr_seq_T21PC0101_002
	ScrDef scr_seq_T21PC0101_003
	ScrDef scr_seq_T21PC0101_004
	ScrDef scr_seq_T21PC0101_005
	ScrDef scr_seq_T21PC0101_006
	ScrDefEnd

scr_seq_T21PC0101_000:
	SetVar VAR_SPECIAL_x8007, 0
	CallStd std_nurse_joy
	End

scr_seq_T21PC0101_004:
	SimpleNPCMsg msg_0552_T21PC0101_00004
	End

scr_seq_T21PC0101_005:
	SimpleNPCMsg msg_0552_T21PC0101_00005
	End

scr_seq_T21PC0101_003:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	Compare VAR_SCENE_ELMS_LAB, 3
	GoToIfLt _006A
	NPCMsg msg_0552_T21PC0101_00003
	GoTo _006D

_006A:
	NPCMsg msg_0552_T21PC0101_00002
_006D:
	WaitButton
	CloseMsg
	ReleaseAll
	End

scr_seq_T21PC0101_001:
	SimpleNPCMsg msg_0552_T21PC0101_00000
	End

scr_seq_T21PC0101_002:
	SimpleNPCMsg msg_0552_T21PC0101_00001
	End

; New Gold's EV/IV trainer: the trainer app for a Pokemon of the party, and
; the Bottle Caps Hyper Training takes and the seven Mochi, at their price.
scr_seq_T21PC0101_006:
	PlaySE SEQ_SE_DP_SELECT
	LockAll
	FacePlayer
	NPCMsg msg_0552_T21PC0101_00006
	TouchscreenMenuHide
	MenuInit 1, 1, 0, 1, VAR_SPECIAL_RESULT
	MenuItemAdd msg_0552_T21PC0101_00007, 255, 0
	MenuItemAdd msg_0552_T21PC0101_00008, 255, 1
	MenuItemAdd msg_0552_T21PC0101_00009, 255, 2
	MenuExec
	TouchscreenMenuShow
	Switch VAR_SPECIAL_RESULT
	Case 0, _EvIvTrain
	Case 1, _EvIvCaps
	GoTo _EvIvBye
	End

_EvIvTrain:
	FadeScreen 6, 1, 0, RGB_BLACK
	WaitFade
	CloseMsg
	EvIvTrainer VAR_SPECIAL_x8000
	RestoreOverworld
	FadeScreen 6, 1, 1, RGB_BLACK
	WaitFade
	Compare VAR_SPECIAL_x8000, 0
	GoToIfEq _EvIvBye
	NPCMsg msg_0552_T21PC0101_00012
	WaitButton
	CloseMsg
	ReleaseAll
	End

_EvIvCaps:
	NPCMsg msg_0552_T21PC0101_00010
	WaitButton
	HoldMsg ; let go, as std_mart_intro's callers do: the mart clears it, her next line opens a framed one
	SpecialMartBuy 30 ; the Bottle Caps, scrcmd_mart.c
	GoTo _EvIvBye
	End

_EvIvBye:
	NPCMsg msg_0552_T21PC0101_00011
	WaitButton
	CloseMsg
	ReleaseAll
	End
	.balign 4, 0
