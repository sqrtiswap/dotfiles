.DEFAULT_GOAL := all

all: install

install:
	mkdir -p ~/bin/ ~/man/man1/
	cp -f wallpapermaker ~/bin/wallpapermaker

uninstall:
	rm -f ~/bin/wallpapermaker

.PHONY: all install uninstall
