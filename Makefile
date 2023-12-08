dotdir = $(shell pwd)

.DEFAULT_GOAL := all

install:
	@echo "==== Linking HOME =============================================================="
	ln -sf ${dotdir}/home/.bash_completions ~/.bash_completions
	ln -sf ${dotdir}/home/.bash_logout ~/.bash_logout
	ln -sf ${dotdir}/home/.bash_paths ~/.bash_paths
	ln -sf ${dotdir}/home/.bash_profile ~/.bash_profile
	ln -sf ${dotdir}/home/.bashrc ~/.bashrc
	ln -sf ${dotdir}/home/.exrc ~/.exrc
	ln -sf ${dotdir}/home/.gitconfig ~/.gitconfig
	ln -sf ${dotdir}/home/.gitignore ~/.gitignore
	ln -sf ${dotdir}/home/.ksh_completions ~/.ksh_completions
	ln -sf ${dotdir}/home/.ksh_paths ~/.ksh_paths
	ln -sf ${dotdir}/home/.kshrc ~/.kshrc

uninstall:
	@echo "==== Removing links from HOME =================================================="
	rm -f ~/.bash_completions
	rm -f ~/.bash_logout
	rm -f ~/.bash_paths
	rm -f ~/.bash_profile
	rm -f ~/.bashrc
	rm -f ~/.exrc
	rm -f ~/.gitconfig
	rm -f ~/.gitignore
	rm -f ~/.ksh_completions
	rm -f ~/.ksh_paths
	rm -f ~/.kshrc

.PHONY: all install uninstall
