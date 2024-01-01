.DEFAULT_GOAL := all

all: install

install:
	mkdir -p ~/bin/
	cp -f see ~/bin/see

uninstall:
	rm -f ~/bin/see

.PHONY: all install uninstall
