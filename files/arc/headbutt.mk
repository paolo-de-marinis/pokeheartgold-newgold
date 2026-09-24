HEADBUTT_DIR := files/arc/headbutt
HEADBUTT_NARC := $(HEADBUTT_DIR).$(buildname).narc

# The headers the template includes: a change to one changes what it compiles to.
$(HEADBUTT_NARC): include/constants/maps.h include/constants/species.h

$(HEADBUTT_NARC): %.$(buildname).narc: %.json %.json.txt
	$(JSONPROC) $(filter-out %.h $(O2NARC) $(JSONPROC),$^) $*.s
	$(WINE) $(MWAS) $(MWASFLAGS) -o $*.o $*.s
	$(O2NARC) $*.o $@ -n
	@$(RM) -f $*.s $*.o

clean-headbutt:
	$(RM) $(HEADBUTT_DIR).d \
	$(foreach bn,$(SUPPORTED_ROMS),$(HEADBUTT_DIR).$(bn).na{rc,ix})

.PHONY: clean-headbutt
clean-filesystem: clean-headbutt
