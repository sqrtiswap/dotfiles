dotdir = $(shell pwd)

.DEFAULT_GOAL := update

install: update link

link:
	ln -sf ${dotdir}/home/.tmux.conf ~/.tmux.conf

remove:
	rm -f ~/bin/shortpath

uninstall: remove unlink

unlink:
	rm -f ~/.tmux.conf

update:
	@mkdir -p ~/bin/
	cp -f bin/shortpath ~/bin/shortpath

.PHONY: install link remove uninstall unlink update
