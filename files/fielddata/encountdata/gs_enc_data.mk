
# Encounter data
ENCDATA_DIR := files/fielddata/encountdata
ENCDATA_NARCS := \
	$(ENCDATA_DIR)/g_enc_data.narc \
	$(ENCDATA_DIR)/s_enc_data.narc
ENCDATA_JSON := $(ENCDATA_DIR)/gs_enc_data.json

$(ENCDATA_DIR)/g_enc_data.narc: GAME_VERSION_S = ENC_HEARTGOLD
$(ENCDATA_DIR)/s_enc_data.narc: GAME_VERSION_S = ENC_SOULSILVER

# The headers the template includes: a change to one changes what it compiles to.
$(ENCDATA_NARCS): include/constants/species.h include/constants/maps.h include/wild_encounter.h

$(ENCDATA_NARCS): %.narc: $(ENCDATA_JSON) $(ENCDATA_JSON).txt | $(WORK_DIR)/include/global.h
	$(JSONPROC) $(filter-out %.h $(O2NARC),$^) $*.c
	$(WINE) $(MWCC) $(MWCFLAGS) -D$(GAME_VERSION_S) -c -o $*.o $*.c
	$(O2NARC) $*.o $@ -n
#	@$(RM) $*.o $*.c

clean-gs-enc-data:
	$(RM) $(ENCDATA_NARCS)

.PHONY: clean-gs-enc-data
clean-filesystem: clean-gs-enc-data
