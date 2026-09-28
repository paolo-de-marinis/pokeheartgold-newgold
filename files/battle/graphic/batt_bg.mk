BATT_BG_DIR := files/battle/graphic/batt_bg
BATT_BG_NARC := files/battle/graphic/batt_bg.narc

# The battle backgrounds' archive, a/0/0/7: the 351 members the game shipped
# with, then what this game adds after them. The shipped ones come out of
# the shipped archive, kept as it was; nitroarc packs them back byte for byte.
BATT_BG_RETAIL := $(BATT_BG_DIR)/retail.narc
BATT_BG_WORK := $(BATT_BG_RETAIL).d

# The backgrounds a terrain draws, hg-engine's, tiles then palette each, in
# the order of BATTLE_BG_ELECTRIC_TERRAIN and the three after it. Like the
# game's own they are 256-colour tiles laid out for its screen, member 2.
BATT_BG_TERRAINS := electric misty grassy psychic
BATT_BG_ADDED := $(foreach terrain,$(BATT_BG_TERRAINS),$(BATT_BG_DIR)/terrain_$(terrain).NCGR.lz $(BATT_BG_DIR)/terrain_$(terrain).NCLR)

$(BATT_BG_DIR)/%.NCGR: $(BATT_BG_DIR)/%.png $(GFX)
	$(GFX) $< $@ -bitdepth 8 -version101

$(BATT_BG_DIR)/%.NCGR.lz: $(BATT_BG_DIR)/%.NCGR $(GFX)
	$(GFX) $< $@

$(BATT_BG_DIR)/%.NCLR: $(BATT_BG_DIR)/%.png $(GFX)
	$(GFX) $< $@ -bitdepth 8 -pcmp

$(BATT_BG_NARC): $(BATT_BG_RETAIL) $(BATT_BG_ADDED) $(NARC)
	$(RM) -r $(BATT_BG_WORK)
	$(NARC) -xf $(BATT_BG_RETAIL)
	ls $(BATT_BG_WORK) | LC_ALL=C sort -V >$(BATT_BG_WORK)/.narcorder
	printf '%s\n' $(notdir $(BATT_BG_ADDED)) >>$(BATT_BG_WORK)/.narcorder
	cp $(BATT_BG_ADDED) $(BATT_BG_WORK)
	$(NARC) -cf $@ --index-namespace -E '*' $(BATT_BG_WORK)

clean-batt-bg:
	$(RM) -r $(BATT_BG_NARC) $(BATT_BG_WORK) $(BATT_BG_ADDED) $(BATT_BG_ADDED:%.lz=%)

.PHONY: clean-batt-bg
clean-filesystem: clean-batt-bg
