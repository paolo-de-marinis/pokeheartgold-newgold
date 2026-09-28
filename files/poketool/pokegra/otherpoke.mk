POKEGRA_DIR := files/poketool/pokegra
OTHERPOKE_SPRITES_DIR := $(POKEGRA_DIR)/otherpoke
OTHERPOKE_BUILD_DIR := $(POKEGRA_DIR)/build-otherpoke
OTHERPOKE_NARC := $(POKEGRA_DIR)/otherpoke.narc

OTHERPOKE_MAP_TXT := $(POKEGRA_DIR)/otherpoke.txt

# Each picture and the .key nitrogfx reads beside it.
OTHERPOKE_PIC_FILES := $(shell find $(OTHERPOKE_SPRITES_DIR) -type f)

# The map names every member, so the folder is made again from it alone: a
# line taken out leaves no member of its own behind.
$(OTHERPOKE_NARC): %.narc: $(OTHERPOKE_PIC_FILES) $(OTHERPOKE_MAP_TXT) $(GFX) $(NARC)
	$(RM) -r $(OTHERPOKE_BUILD_DIR)
	mkdir -p $(OTHERPOKE_BUILD_DIR)
	while read -r line; do $(GFX) $$line; done < $(OTHERPOKE_MAP_TXT)
	$(NARC) -cf $@ --index-namespace $(OTHERPOKE_BUILD_DIR)

clean-otherpoke:
	$(RM) -r $(OTHERPOKE_NARC) $(OTHERPOKE_BUILD_DIR)

.PHONY: clean-otherpoke
clean-filesystem: clean-otherpoke
