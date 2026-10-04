BATTLE_HALL_NARC := files/arc/battle_hall.narc
BATTLE_HALL_JSON := files/arc/battle_hall.json
BATTLE_HALL_TEMPLATE := files/arc/battle_hall.json.txt

# The headers the template includes: a change to one changes what it compiles to.
$(BATTLE_HALL_NARC): include/scrcmd_9.h include/constants/items.h include/constants/moves.h include/constants/pokemon.h include/constants/species.h

$(BATTLE_HALL_NARC): %.narc: $(BATTLE_HALL_JSON) $(BATTLE_HALL_TEMPLATE)
	$(JSONPROC) $(filter-out %.h $(O2NARC) $(JSONPROC),$^) $*.c
	$(WINE) $(MWCC) $(MWCFLAGS) -c -o $*.o $*.c
	$(O2NARC) $*.o $@ -n -p 0x00
	@$(RM) $*.o $*.c

$(BATTLE_HALL_JSON): | $(WORK_DIR)/include/global.h

clean-battle-hall:
	$(RM) $(BATTLE_HALL_NARC) $(BATTLE_HALL_NARC:%.narc=%.c) $(BATTLE_HALL_NARC:%.narc=%.o)

.PHONY: clean-battle-hall
clean-filesystem: clean-battle-hall
