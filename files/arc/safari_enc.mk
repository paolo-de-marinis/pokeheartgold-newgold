SAFARI_ENC_JSON := files/arc/safari_enc.json
SAFARI_ENC_NARC := files/arc/safari_enc.narc

# The headers the template includes: a change to one changes what it compiles to.
$(SAFARI_ENC_NARC): include/constants/species.h include/constants/safari.h

$(SAFARI_ENC_NARC): $(SAFARI_ENC_JSON) $(SAFARI_ENC_JSON).txt
	$(JSONPROC) $(filter-out %.h,$^) $*.s
	$(WINE) $(MWAS) $(MWASFLAGS) -o $*.o $*.s
	$(O2NARC) $*.o $@
	@$(RM) $*.s $*.o

.PHONY: clean-safari-enc
clean-safari-enc:
	rm -f $(SAFARI_ENC_NARC)
