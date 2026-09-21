BAG_GRA_DIR := files/graphic/bag_gra
BAG_GRA_NARC := $(BAG_GRA_DIR).narc

# The palettes and the TM badge are built; the rest of the archive is the
# game's own, extracted as it stands.
BAG_GRA_PAL_OBJS := $(patsubst %.pal,%.NCLR,$(wildcard $(BAG_GRA_DIR)/*.pal))
BAG_GRA_PNG_OBJS := $(patsubst %.png,%.NCGR,$(wildcard $(BAG_GRA_DIR)/*.png))
BAG_GRA_MEMBERS := $(foreach ext,NANR NCER NCGR NSCR BCA0 BMD0 BTA0 BTP0,$(wildcard $(BAG_GRA_DIR)/*.$(ext)))

$(BAG_GRA_DIR)/%.NCLR: $(BAG_GRA_DIR)/%.pal
	$(GFX) $< $@ -bitdepth 4

$(BAG_GRA_DIR)/%.NCGR: $(BAG_GRA_DIR)/%.png
	$(GFX) $< $@ -version101 -sopc

$(BAG_GRA_NARC): %.narc: $(BAG_GRA_PAL_OBJS) $(BAG_GRA_PNG_OBJS) $(BAG_GRA_MEMBERS)
	$(NARC) -cf $@ --index-namespace $(BAG_GRA_DIR)

clean-bag-gra:
	$(RM) $(BAG_GRA_NARC) $(BAG_GRA_PAL_OBJS) $(BAG_GRA_PNG_OBJS)

.PHONY: clean-bag-gra
clean-filesystem: clean-bag-gra
