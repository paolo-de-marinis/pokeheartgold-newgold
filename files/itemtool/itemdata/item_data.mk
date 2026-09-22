ITEMDATA_NARC  := files/itemtool/itemdata/item_data.narc
ITEMICON_NARC  := files/itemtool/itemdata/item_icon.narc

$(ITEMDATA_NARC): MANIFEST = $(patsubst %.narc,%.txt,$@)
$(ITEMDATA_NARC): CSV2BINFLAGS += --pad 0xFF

$(ITEMDATA_NARC): %.narc: %.csv $(MANIFEST) $$(csvdep)
	$(CSV2BIN) compile $< $@ $(MANIFEST) $(CSV2BINFLAGS)

ITEMICON_DIR := files/itemtool/itemdata/item_icon

# The game's own icons are in the archive as they were extracted; New Gold's
# come from konefr's data/graphics/item, copied under their names there. Which
# PNG belongs to an item is not its name: data/graphics/itemgra.mk keys them by
# the archive member, which is the item's id plus two, and most of that
# directory is a blank placeholder -- snowball_pla.png among it, which belongs
# to another item entirely. Each of these eighteen is one 32x32 4bpp PNG and
# makes two members, the tiles and the palette, with the flags the reference
# builds item icons with.
define ITEMICON_FROM_PNG
$(ITEMICON_DIR)/item_icon_$(1).NCGR: $(ITEMICON_DIR)/$(3).png
	$$(GFX) $$< $$@ -clobbersize -version101 -bitdepth 4
$(ITEMICON_DIR)/item_icon_$(2).NCLR: $(ITEMICON_DIR)/$(3).png
	$$(GFX) $$< $$@ -ir -bitdepth 4
ITEMICON_OBJS += $(ITEMICON_DIR)/item_icon_$(1).NCGR $(ITEMICON_DIR)/item_icon_$(2).NCLR
endef

$(eval $(call ITEMICON_FROM_PNG,797,798,auspicious_armor))
$(eval $(call ITEMICON_FROM_PNG,799,800,chipped_pot))
$(eval $(call ITEMICON_FROM_PNG,801,802,cracked_pot))
$(eval $(call ITEMICON_FROM_PNG,803,804,galarica_cuff))
$(eval $(call ITEMICON_FROM_PNG,805,806,galarica_wreath))
$(eval $(call ITEMICON_FROM_PNG,807,808,malicious_armor))
$(eval $(call ITEMICON_FROM_PNG,809,810,metal_alloy))
$(eval $(call ITEMICON_FROM_PNG,811,812,scroll_of_darkness))
$(eval $(call ITEMICON_FROM_PNG,813,814,scroll_of_waters))
$(eval $(call ITEMICON_FROM_PNG,815,816,absorb_bulb))
$(eval $(call ITEMICON_FROM_PNG,817,818,air_balloon))
$(eval $(call ITEMICON_FROM_PNG,819,820,cell_battery))
$(eval $(call ITEMICON_FROM_PNG,821,822,electric_seed))
$(eval $(call ITEMICON_FROM_PNG,823,824,grassy_seed))
$(eval $(call ITEMICON_FROM_PNG,825,826,misty_seed))
$(eval $(call ITEMICON_FROM_PNG,827,828,psychic_seed))
$(eval $(call ITEMICON_FROM_PNG,829,830,pretty_feather))
$(eval $(call ITEMICON_FROM_PNG,831,832,snowball))

$(ITEMICON_NARC): $(wildcard files/itemtool/itemdata/item_icon/*.{NANR,NCLR,NCGR,NCER}) $(ITEMICON_OBJS)

clean-itemdata:
	$(RM) $(ITEMDATA_NARC) $(ITEMICON_NARC) $(ITEMICON_OBJS)

.PHONY: clean-itemdata
clean-filesystem: clean-itemdata
