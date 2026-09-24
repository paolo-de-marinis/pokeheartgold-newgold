TRDATA_NARC := files/poketool/trainer/trdata.narc
TRPOKE_NARC := files/poketool/trainer/trpoke.narc
TRAINER_JSON := files/poketool/trainer/trainers.json
TRDATA_TEMPLATE := files/poketool/trainer/trdata.json.txt
TRPOKE_TEMPLATE := files/poketool/trainer/trpoke.json.txt

# The headers the template includes: a change to one changes what it compiles to.
$(TRDATA_NARC): include/trainer_data.h include/constants/items.h include/constants/trainer_class.h
$(TRPOKE_NARC): include/trainer_data.h include/constants/species.h include/constants/moves.h include/constants/items.h

$(TRDATA_NARC): %.narc: $(TRAINER_JSON) $(TRDATA_TEMPLATE)
	$(JSONPROC) $(filter-out %.h $(O2NARC) $(JSONPROC),$^) $*.c
	$(WINE) $(MWCC) $(MWCFLAGS) -c -o $*.o $*.c
	$(O2NARC) $*.o $@ -n
	@$(RM) $*.o $*.c

$(TRPOKE_NARC): %.narc: $(TRAINER_JSON) $(TRPOKE_TEMPLATE)
	$(JSONPROC) $(filter-out %.h $(O2NARC) $(JSONPROC),$^) $*.s
	$(WINE) $(MWAS) $(MWASFLAGS) -DPM_ASM -o $*.o $*.s
	$(O2NARC) $*.o $@ -n -p 0x00
	@$(RM) $*.o $*.s

$(TRDATA_NARC): MWCFLAGS += -include global.h
$(TRAINER_JSON): | $(WORK_DIR)/include/global.h

clean-trainer:
	$(RM) $(TRDATA_NARC) $(TRPOKE_NARC) \
	$(TRDATA_NARC:%.narc=%.o) $(TRPOKE_NARC:%.narc=%.o) \
	$(TRDATA_NARC:%.narc=%.c) $(TRPOKE_NARC:%.narc=%.s)

.PHONY: clean-trainer
clean-filesystem: clean-trainer
