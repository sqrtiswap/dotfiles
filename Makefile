.DEFAULT_GOAL := all

all: install

install:
	mkdir -p ~/bin/
	cp -f barstarter ~/bin/barstarter
	cp -f lemonscript.sh ~/bin/lemonscript.sh
	cp -f termbar.sh ~/bin/termbar.sh

uninstall:
	rm -f ~/bin/barstarter
	rm -f ~/bin/lemonscript.sh
	rm -f ~/bin/termbar.sh

.PHONY: all install uninstall
