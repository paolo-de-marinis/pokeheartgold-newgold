PERSONAL_DIR := files/poketool/personal/personal
PERSONAL_NARC := $(PERSONAL_DIR).narc

$(PERSONAL_JSON): lib/include/nitro/fx/fx_const.h

# The headers the template includes: a change to one changes what it compiles to.
$(PERSONAL_NARC): include/pokemon.h include/pokemon_types_def.h include/constants/pokemon.h \
	include/constants/moves.h include/constants/abilities.h include/constants/items.h

$(PERSONAL_NARC): %.narc: %.json %.json.txt | include/global.h
	$(JSONPROC) $(filter-out %.h,$^) $*.c
	$(WINE) $(MWCC) $(MWCFLAGS) -c -o $*.o $*.c
	$(O2NARC) -n $*.o $@ -p 0
	@$(RM) $*.o $*.c

clean-personal:
	$(RM) $(PERSONAL_NARC)

.PHONY: clean-personal
clean-filesystem: clean-personal
