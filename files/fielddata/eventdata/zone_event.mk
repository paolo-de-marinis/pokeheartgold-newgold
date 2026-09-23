ZONE_EVENT_STEM  := files/fielddata/eventdata/zone_event
ZONE_EVENT_NARC  := $(ZONE_EVENT_STEM).narc
ZONE_EVENT_TEMPL := $(ZONE_EVENT_STEM).json.txt
ZONE_EVENT_JSONS := $(sort $(wildcard $(ZONE_EVENT_STEM)/*.json))
ZONE_EVENT_S     := $(ZONE_EVENT_JSONS:%.json=%.s)
ZONE_EVENT_O     := $(ZONE_EVENT_JSONS:%.json=%.o)
ZONE_EVENT_DEPS  := $(ZONE_EVENT_JSONS:%.json=%.d)
ZONE_EVENT_BIN   := $(ZONE_EVENT_JSONS:%.json=%.bin)
ZONE_EVENT_BIN_DEPS := $(ZONE_EVENT_BIN:%=%.d)

$(ZONE_EVENT_NARC): $(ZONE_EVENT_BIN)

$(ZONE_EVENT_TEMPL):

$(ZONE_EVENT_BIN): $(ZONE_EVENT_TEMPL) include/constants/scrcmd.h

clean-zone-event:
	$(RM) $(ZONE_EVENT_NARC) $(ZONE_EVENT_BIN) $(ZONE_EVENT_DEPS) $(ZONE_EVENT_BIN_DEPS)

.PHONY: clean-zone-event
clean-filesystem: clean-zone-event

$(ZONE_EVENT_BIN): MWASFLAGS += -DPM_ASM
ifeq ($(NODEP),)
# A json names the script header its ids come from ({{ header }}), and that
# header and the constants scrcmd.h pulls in are only known to the assembler.
# Its dependency file is kept as X.bin.d, for X.bin and without the .s it
# names, which is deleted as soon as it is assembled; the X.d it writes is
# never read, so one left by an older build does no harm. A bin whose
# dependency file is missing is made again, which is how it gets one.
$(ZONE_EVENT_BIN_DEPS):
$(ZONE_EVENT_BIN): %.bin: %.json %.bin.d
	@echo event_data: gen $@
	@$(JSONPROC) $< $(ZONE_EVENT_TEMPL) $*.s
	@$(WINE) $(MWAS) $(MWASFLAGS) $(DEPFLAGS) -o $*.o $*.s
	@$(call fixdep,$*.d)
	@$(SED) '1s/\.o: [^ ]*/.bin:/' $*.d > $*.bin.d
	@$(OBJCOPY) -O binary $*.o $@
	@$(RM) $*.s $*.o $*.d
	@echo event_data: gen $@ done

include $(wildcard $(ZONE_EVENT_BIN_DEPS))
else
$(ZONE_EVENT_BIN): %.bin: %.json
	@echo event_data: gen $@
	@$(JSONPROC) $< $(ZONE_EVENT_TEMPL) $*.s
	@$(WINE) $(MWAS) $(MWASFLAGS) -o $*.o $*.s
	@$(OBJCOPY) -O binary $*.o $@
	@$(RM) $*.s $*.o
	@echo event_data: gen $@ done
endif
