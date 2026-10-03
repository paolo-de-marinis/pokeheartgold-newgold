# The Battle Frontier's graphics (a/1/8/3), member by member as the game has
# them. The Battle Hall's type board is built from the files beside them: its
# tilemap (member 24, compressed as the game's, padded) and its palettes (153).
FRONTIER_GRA_DIR := files/graphic/frontier_gra
FRONTIER_GRA_NARC := $(FRONTIER_GRA_DIR).narc
FRONTIER_GRA_MEMBERS := $(wildcard $(FRONTIER_GRA_DIR)/*.bin) \
	$(FRONTIER_GRA_DIR)/frontier_gra_00024.NSCR.lz \
	$(FRONTIER_GRA_DIR)/frontier_gra_00153.NCLR

$(FRONTIER_GRA_DIR)/frontier_gra_00024.NSCR.lz: LZ_FLAGS =

$(eval $(call numbered_narc,$(FRONTIER_GRA_NARC),$(FRONTIER_GRA_DIR),$(FRONTIER_GRA_MEMBERS)))

clean-frontier-gra:
	$(RM) $(FRONTIER_GRA_NARC) $(FRONTIER_GRA_DIR)/frontier_gra_00024.NSCR.lz $(FRONTIER_GRA_DIR)/.narcorder

.PHONY: clean-frontier-gra
clean-filesystem: clean-frontier-gra
