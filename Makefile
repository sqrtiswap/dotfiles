dotdir = $(shell pwd)

.DEFAULT_GOAL := all

install:
	@echo "==== Linking HOME =============================================================="
	ln -sf ${dotdir}/home/.exrc ~/.exrc
	ln -sf ${dotdir}/home/.gitconfig ~/.gitconfig
	ln -sf ${dotdir}/home/.gitignore ~/.gitignore

uninstall:
	@echo "==== Removing links from HOME =================================================="
	rm -f ~/.exrc
	rm -f ~/.gitconfig
	rm -f ~/.gitignore

.PHONY: all install uninstall
