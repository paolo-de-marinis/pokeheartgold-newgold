DATA_RESDAT_DIR = files/data/resdat
DATA_RESDAT_NARC = $(DATA_RESDAT_DIR).narc

DATA_RESDAT_JSON = $(wildcard $(DATA_RESDAT_DIR)/*.json)
DATA_RESDAT_BIN = $(DATA_RESDAT_JSON:%.json=%.bin)

# The headers the template includes: a change to one changes what it compiles to.
$(DATA_RESDAT_BIN): include/unk_02009D48.h include/filesystem_files_def.h

$(DATA_RESDAT_BIN): %.bin: %.json $(DATA_RESDAT_DIR).json.txt | $(WORK_DIR)/include/global.h
	$(JSONPROC) $(filter-out %.h $(O2NARC),$^) $*.c
	$(WINE) $(MWCC) $(MWCFLAGS) -c -o $*.o $*.c
	$(O2NARC) $*.o $@ -f
	@$(RM) $*.c $*.o

$(DATA_RESDAT_NARC): $(DATA_RESDAT_BIN)
	$(NARC) -cf $@ --index-namespace $(DATA_RESDAT_DIR)

clean-resdat:
	$(RM) $(DATA_RESDAT_NARC) $(DATA_RESDAT_BIN)

.PHONY: clean-resdat
clean-filesystem: clean-resdat
