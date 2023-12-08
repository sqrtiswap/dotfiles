dotdir = $(shell pwd)

.DEFAULT_GOAL := update

install: update link

link:
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
	@echo "==== Linking .config ==========================================================="
	ln -sf ${dotdir}/config/alacritty ~/.config/alacritty
	ln -sf ${dotdir}/config/dunst ~/.config/dunst
	ln -sf ${dotdir}/config/tkremindrc ~/.config/tkremindrc
	ln -sf ${dotdir}/config/vis ~/.config/vis
	ln -sf ${dotdir}/config/xfe ~/.config/xfe
	ln -sf ${dotdir}/config/yt-dlp ~/.config/yt-dlp
	ln -sf ${dotdir}/config/zathura ~/.config/zathura

remove:
	rm -f ~/bin/emailinfo

uninstall: remove unlink

unlink:
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
	@echo "==== Removing links from .config ==============================================="
	rm -f ~/.config/alacritty
	rm -f ~/.config/dunst
	rm -f ~/.config/tkremindrc
	rm -f ~/.config/vis
	rm -f ~/.config/xfe
	rm -f ~/.config/yt-dlp
	rm -f ~/.config/zathura

update:
	mkdir -p ~/bin/
	cp -f bin/emailinfo ~/bin/emailinfo

.PHONY: install link remove uninstall unlink update
