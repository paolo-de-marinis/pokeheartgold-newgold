GROWTBL_NARC  := files/poketool/personal/growtbl.narc

$(GROWTBL_NARC): MANIFEST = $(patsubst %.narc,%.txt,$@)\

# csv2bin writes the index before the archive. Touched after it, the index
# is not older than its archive, which remade it on every run (make -n
# printed every object that includes it).
$(GROWTBL_NARC): %.narc: %.csv $(MANIFEST) $$(csvdep)
	$(CSV2BIN) compile $< $@ $(MANIFEST) $(CSV2BINFLAGS)
	@touch $*.naix

clean-growtbl:
	$(RM) $(GROWTBL_NARC)

.PHONY: clean-growtbl
clean-filesystem: clean-growtbl
