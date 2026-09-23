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




.public ov18_021F51BC
.public ov18_021F51CC
.public ov18_021F5238
.public ov18_021F52A4
.public ov18_021F5310
.public ov18_021F537C
.public ov18_021F53E8
.public ov18_021F5454
.public ov18_021F5638
.public ov18_021F56DC
.public ov18_021F57B4
.public ov18_021F588C
.public ov18_021F5964
.public ov18_021F5A3C
.public ov18_021F5B14
.public ov18_021F5BEC
.public ov18_021F5CC4
.public ov18_021F6E98
.public ov18_021F6EAC
.public ov18_021F6F78
.public ov18_021F6F8C
.public ov18_021F7060
.public ov18_021F7104
.public ov18_021F71DC
.public ov18_021F7334
.public ov18_021F74B0
.public ov18_021F74C4
.public ov18_021F7634
.public ov18_021F7648
.public ov18_021F7720
.public ov18_021F7734
.public ov18_021F7800
.public ov18_021F7954
.public ov18_021F7B90

	.rodata
	.balign 4, 0

	.global ov18_021FBD50
ov18_021FBD50:
	.word 0x00000020, 0x00010000, 0x00004000, 0x00000000
	.size ov18_021FBD50,.-ov18_021FBD50

	.global ov18_021FBD60
	.balign 4, 0
ov18_021FBD60:
	.word 0x00000000, 0x00000000, 0x00000800, 0x00000000
	.byte 0x01, 0x00, 0x1E, 0x04, 0x00, 0x02, 0x00, 0x00
	.word 0x00000000
	.size ov18_021FBD60,.-ov18_021FBD60

	.global ov18_021FBD7C
	.balign 4, 0
ov18_021FBD7C:
	.word 0x00000000, 0x00000000, 0x00000800, 0x00000000
	.byte 0x01, 0x00, 0x1F, 0x00, 0x00, 0x01, 0x00, 0x00
	.word 0x00000000
	.size ov18_021FBD7C,.-ov18_021FBD7C

	.global ov18_021FBD98
	.balign 4, 0
ov18_021FBD98:
	.word 0x00000000, 0x00000000, 0x00000800, 0x00000000
	.byte 0x01, 0x00, 0x1D, 0x04, 0x00, 0x03, 0x00, 0x00
	.word 0x00000000
	.size ov18_021FBD98,.-ov18_021FBD98

	.global ov18_021FBDB4
	.balign 2, 0
ov18_021FBDB4:
	.byte 0x01, 0x02, 0x00, 0x1C, 0x02, 0x02
	.short 0x03C8
	.byte 0x01, 0x0F, 0x03, 0x04, 0x02, 0x00
	.short 0x03C0
	.byte 0x01, 0x13, 0x03, 0x09, 0x02, 0x00
	.short 0x03AE
	.byte 0x01, 0x0D, 0x05, 0x12, 0x02, 0x00
	.short 0x038A
	.byte 0x01, 0x02, 0x11, 0x1C, 0x06, 0x01
	.short 0x02E2
	.byte 0x01, 0x12, 0x0B, 0x05, 0x02, 0x01
	.short 0x02D8
	.byte 0x01, 0x17, 0x0B, 0x08, 0x02, 0x01
	.short 0x02C8
	.byte 0x01, 0x12, 0x0D, 0x05, 0x02, 0x01
	.short 0x02BE
	.byte 0x01, 0x17, 0x0D, 0x08, 0x02, 0x01
	.short 0x02AE
	.size ov18_021FBDB4,.-ov18_021FBDB4
