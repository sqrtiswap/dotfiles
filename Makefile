.DEFAULT_GOAL := all

all: install

install:
	mkdir -p ~/bin/
	cp -f kbdlswitch ~/bin/kbdlswitch

.PHONY: all install
