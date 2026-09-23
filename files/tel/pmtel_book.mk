PMTEL_BOOK_DAT := files/tel/pmtel_book.dat
PMTEL_BOOK_JSON := files/tel/pmtel_book.json
PMTEL_BOOK_TEMPLATE := files/tel/pmtel_book.json.txt

# The headers the template includes: a change to one changes what it compiles to.
$(PMTEL_BOOK_DAT): include/constants/phone_contacts.h include/constants/trainer_class.h \
	include/constants/trainers.h include/constants/items.h include/constants/phone_scripts.h include/constants/maps.h

$(PMTEL_BOOK_DAT): %.dat: $(PMTEL_BOOK_JSON) $(PMTEL_BOOK_TEMPLATE)
	$(JSONPROC) $(filter-out %.h,$^) $*.s
	$(WINE) $(MWAS) $(MWASFLAGS) -c -o $*.o $*.s
	$(OBJCOPY) -O binary $*.o $@
	@$(RM) $*.o $*.s

FS_RULE_OVERRIDES += $(PMTEL_BOOK_DAT)

clean-pmtel-book:
	$(RM) $(PMTEL_BOOK_DAT) $(PMTEL_BOOK_DAT:%.dat=%.c) $(PMTEL_BOOK_DAT:%.dat=%.o)

.PHONY: clean-pmtel-book
clean-filesystem: clean-pmtel-book
