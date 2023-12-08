.DEFAULT_GOAL := all

all: install

install:
	@echo "==== Linking HOME =============================================================="
	ln -sf ~/sources/dotfiles/home/.gitconfig ~/.gitconfig
	ln -sf ~/sources/dotfiles/home/.gitignore ~/.gitignore

uninstall:
	@echo "==== Removing links from HOME =================================================="
	rm -f ~/.gitconfig
	rm -f ~/.gitignore

.PHONY: all install uninstall
