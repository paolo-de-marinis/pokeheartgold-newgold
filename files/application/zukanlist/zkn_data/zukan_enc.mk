ZUKAN_ENC_PREF := files/application/zukanlist/zkn_data/zukan_enc
ZUKAN_ENC_NARC := $(ZUKAN_ENC_PREF)_$(shortname).narc
ZUKAN_ENC_NAIX := $(ZUKAN_ENC_PREF).naix
ZUKAN_ENC_JSON := $(ZUKAN_ENC_PREF).json
ZUKAN_ENC_JSON_TXT := $(ZUKAN_ENC_PREF).json.txt

# Normalize the NAIX to version-agnostic enums. Both versions write it, and
# with the version's name out of it, its guard's capitals too, both write the
# same: it is replaced only when that changes, so the other version's archive
# built again recompiles no Pokedex. The check runs in a dry run too (+),
# which then reads the index's time again and prints nothing behind it.
$(ZUKAN_ENC_NAIX): %.naix: %_$(shortname).naix
	+@$(SED) 's/_$(shortname)//gI' $< >$@.new; if cmp -s $@.new $@; then rm $@.new; else mv $@.new $@; fi
filesystem: $(ZUKAN_ENC_NAIX)
# The Pokedex includes it, so it is made before anything is compiled, as the
# archives' own indexes are: `filesystem` alone does not order it before the
# objects, and a first build, or one after clean-zukan-enc, could compile the
# Pokedex first.
files_for_compile: $(ZUKAN_ENC_NAIX)

# This explicit dependency is required for multi-core builds
$(ZUKAN_ENC_NARC:%.narc=%.naix): $(ZUKAN_ENC_NARC) ;

$(ZUKAN_ENC_NARC): %.narc: $(ZUKAN_ENC_JSON) $(ZUKAN_ENC_JSON_TXT)
	$(JSONPROC) $(filter-out %.h $(O2NARC) $(JSONPROC),$^) $*.s
	$(WINE) $(MWAS) $(MWASFLAGS) -DPM_ASM -o $*.o $*.s
	$(O2NARC) $*.o $@ -n -p 0x00
	@$(RM) $*.o $*.s

clean-zukan-enc:
	$(RM) $(ZUKAN_ENC_PREF)_gold.narc $(ZUKAN_ENC_PREF)_silver.narc $(ZUKAN_ENC_NAIX)

.PHONY: clean-zukan-enc
clean-filesystem: clean-zukan-enc
