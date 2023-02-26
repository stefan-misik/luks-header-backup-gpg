PROJ = lukshdr

.PHONY: install uninstall
install: $(PROJ).sh
	cp $< $(HOME)/.local/bin/$(PROJ)

uninstall:
	$(RM) $(HOME)/.local/bin/$(PROJ)


