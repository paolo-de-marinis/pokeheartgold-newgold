POKE_ICON_DIR := files/poketool/icongra/poke_icon
POKE_ICON_NARC := $(POKE_ICON_DIR)/poke_icon.narc

# An icon is 4bpp whatever its PNG's depth: nitrogfx makes an 8-bit PNG an
# 8bpp NCGR unless told, and the game reads every icon as 4bpp, so an 8-bit
# one showed as stripes. Sixteen of the reference's icons are 8-bit PNGs; its
# own icon rule passes -bitdepth 4 as well.
POKE_ICON_GFX_FLAGS_ICON := -clobbersize -version101 -bitdepth 4
POKE_ICON_GFX_FLAGS_PAL := -bitdepth 4

POKE_ICON_PAL_FILES := $(wildcard $(POKE_ICON_DIR)/*.pal)
POKE_ICON_PAL_OBJS := $(patsubst $(POKE_ICON_DIR)/%.pal,$(POKE_ICON_DIR)/%.NCLR,$(POKE_ICON_PAL_FILES))
POKE_ICON_ANIM_FILES := $(POKE_ICON_DIR)/poke_icon_00000001.json $(POKE_ICON_DIR)/poke_icon_00000003.json $(POKE_ICON_DIR)/poke_icon_00000005.json
POKE_ICON_ANIM_OBJS := $(patsubst $(POKE_ICON_DIR)/%.json,$(POKE_ICON_DIR)/%.NANR,$(POKE_ICON_ANIM_FILES))
POKE_ICON_CELL_FILES := $(POKE_ICON_DIR)/poke_icon_00000002.json $(POKE_ICON_DIR)/poke_icon_00000004.json $(POKE_ICON_DIR)/poke_icon_00000006.json
POKE_ICON_CELL_OBJS := $(patsubst $(POKE_ICON_DIR)/%.json,$(POKE_ICON_DIR)/%.NCER,$(POKE_ICON_CELL_FILES))
POKE_ICON_ICON_FILES := $(wildcard $(POKE_ICON_DIR)/*.png)
POKE_ICON_ICON_OBJS := $(patsubst $(POKE_ICON_DIR)/%.png,$(POKE_ICON_DIR)/%.NCGR,$(POKE_ICON_ICON_FILES))

$(POKE_ICON_DIR)/%.NCLR: $(POKE_ICON_DIR)/%.pal
	$(GFX) $< $@ $(POKE_ICON_GFX_FLAGS_PAL)

$(POKE_ICON_DIR)/%.NCER: $(POKE_ICON_DIR)/%.json
	$(GFX) $< $@

$(POKE_ICON_DIR)/%.NANR: $(POKE_ICON_DIR)/%.json
	$(GFX) $< $@

# The flags are part of what an icon is built from: an icon built before
# they changed is built again.
$(POKE_ICON_DIR)/%.NCGR: $(POKE_ICON_DIR)/%.png $(POKE_ICON_DIR)/poke_icon.mk
	$(GFX) $< $@ $(POKE_ICON_GFX_FLAGS_ICON)

# The archive holds what the palette, the animations, the cells and the icons
# make, icon N at member N, and nothing else the folder holds (filesystem.mk).
$(eval $(call numbered_narc,$(POKE_ICON_NARC),$(POKE_ICON_DIR),$(POKE_ICON_PAL_OBJS) $(POKE_ICON_ANIM_OBJS) $(POKE_ICON_CELL_OBJS) $(POKE_ICON_ICON_OBJS)))

clean-poke-icon:
	$(RM) $(POKE_ICON_NARC) $(POKE_ICON_PAL_OBJS) $(POKE_ICON_ANIM_OBJS) $(POKE_ICON_CELL_OBJS) $(POKE_ICON_ICON_OBJS)

.PHONY: clean-poke-icon
clean-filesystem: clean-poke-icon
