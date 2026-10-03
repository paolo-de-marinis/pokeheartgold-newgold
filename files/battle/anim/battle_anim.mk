BATTLE_ANIM_DIR := files/battle/anim/battle_anim
BATTLE_ANIM_NARC := files/battle/anim/battle_anim.narc

# The battle animations' archive, a/0/6/1: the animations a battle script
# plays by number (PlayBattleAnimation, BATTLE_ANIMATION_*), in the script
# overlay 7 runs. The 50 members the game shipped with come out of the
# shipped archive, kept as it was; nitroarc packs them back byte for byte,
# what this game adds after them.
BATTLE_ANIM_RETAIL := $(BATTLE_ANIM_DIR)/retail.narc
BATTLE_ANIM_WORK := $(BATTLE_ANIM_RETAIL).d

# Assembled as the battle scripts are, with asm/macros/btlanim.inc, in the
# order of their numbers: a terrain's start, BATTLE_ANIMATION_GRASSY_TERRAIN
# (50) and the three after it.
BATTLE_ANIM_TERRAINS := grassy misty electric psychic
BATTLE_ANIM_SRCS := $(BATTLE_ANIM_TERRAINS:%=$(BATTLE_ANIM_DIR)/terrain_%.s)
BATTLE_ANIM_BINS := $(BATTLE_ANIM_SRCS:%.s=%.bin)
BATTLE_ANIM_OBJS := $(BATTLE_ANIM_SRCS:%.s=%.o)

$(BATTLE_ANIM_BINS): MWASFLAGS += -DPM_ASM
ifeq ($(NODEP),)
BATTLE_ANIM_DEPS := $(BATTLE_ANIM_BINS:%.bin=%.d)
$(BATTLE_ANIM_DEPS):

$(BATTLE_ANIM_BINS): %.bin: %.s
$(BATTLE_ANIM_BINS): %.bin: %.s %.d | $$(MWAS_PATCHED)
	@echo $(WINE) $(MWAS) $(MWASFLAGS) $(DEPFLAGS) -o $*.o $<
	@$(WINE) $(MWAS) $(MWASFLAGS) $(DEPFLAGS) -o $*.o $< || { rm -f $*.d; exit 1; }
	@$(call fixdep,$*.d)
	@$(SED) -i 's/\.o/.bin/' $*.d
	$(OBJCOPY) -O binary --file-alignment 4 $*.o $@
include $(wildcard $(BATTLE_ANIM_DEPS))
else
$(BATTLE_ANIM_BINS): %.bin: %.s | $$(MWAS_PATCHED)
	$(WINE) $(MWAS) $(MWASFLAGS) -o $*.o $<
	$(OBJCOPY) -O binary --file-alignment 4 $*.o $@
endif

$(BATTLE_ANIM_NARC): $(BATTLE_ANIM_RETAIL) $(BATTLE_ANIM_BINS) $(NARC)
	$(RM) -r $(BATTLE_ANIM_WORK)
	$(NARC) -xf $(BATTLE_ANIM_RETAIL)
	ls $(BATTLE_ANIM_WORK) | LC_ALL=C sort -V >$(BATTLE_ANIM_WORK)/.narcorder
	printf '%s\n' $(notdir $(BATTLE_ANIM_BINS)) >>$(BATTLE_ANIM_WORK)/.narcorder
	cp $(BATTLE_ANIM_BINS) $(BATTLE_ANIM_WORK)
	$(NARC) -cf $@ --index-namespace -E '*' $(BATTLE_ANIM_WORK)

clean-battle-anim:
	$(RM) -r $(BATTLE_ANIM_NARC) $(BATTLE_ANIM_WORK) $(BATTLE_ANIM_BINS) $(BATTLE_ANIM_OBJS) $(BATTLE_ANIM_DEPS)

.PHONY: clean-battle-anim
clean-filesystem: clean-battle-anim
