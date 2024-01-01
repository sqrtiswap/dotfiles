.DEFAULT_GOAL := all

all: install

install:
	mkdir -p ~/bin/ ~/man/man1/
	cp -f tellme ~/bin/tellme

uninstall:
	rm -f ~/bin/tellme

.PHONY: all install uninstall
