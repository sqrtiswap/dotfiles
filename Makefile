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
	ln -sf ${dotdir}/config/hikari ~/.config/hikari
	ln -sf ${dotdir}/config/htop ~/.config/htop
	ln -sf ${dotdir}/config/mako ~/.config/mako
	ln -sf ${dotdir}/config/mpDris2 ~/.config/mpDris2
	ln -sf ${dotdir}/config/mpd ~/.config/mpd
	ln -sf ${dotdir}/config/ncmpcpp ~/.config/ncmpcpp
	ln -sf ${dotdir}/config/tkremindrc ~/.config/tkremindrc
	ln -sf ${dotdir}/config/user-dirs.dirs ~/.config/user-dirs.dirs
	ln -sf ${dotdir}/config/user-dirs.locale ~/.config/user-dirs.locale
	ln -sf ${dotdir}/config/vis ~/.config/vis
	ln -sf ${dotdir}/config/xfe ~/.config/xfe
	ln -sf ${dotdir}/config/yt-dlp ~/.config/yt-dlp
	ln -sf ${dotdir}/config/zathura ~/.config/zathura

remove:
	rm -f ~/bin/check_mutt_mailboxes
	rm -f ~/bin/emailinfo
	rm -f ~/bin/mymail
	rm -f ~/bin/pass

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
	rm -f ~/.config/hikari
	rm -f ~/.config/htop
	rm -f ~/.config/mako
	rm -f ~/.config/mpDris2
	rm -f ~/.config/mpd
	rm -f ~/.config/ncmpcpp
	rm -f ~/.config/tkremindrc
	rm -f ~/.config/user-dirs.dirs
	rm -f ~/.config/user-dirs.locale
	rm -f ~/.config/vis
	rm -f ~/.config/xfe
	rm -f ~/.config/yt-dlp
	rm -f ~/.config/zathura

update:
	mkdir -p ~/bin/
	cp -f bin/check_mutt_mailboxes ~/bin/check_mutt_mailboxes
	cp -f bin/emailinfo ~/bin/emailinfo
	cp -f bin/mymail ~/bin/mymail
	cp -f bin/pass ~/bin/pass

.PHONY: install link remove uninstall unlink update
