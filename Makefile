dotdir = $(shell pwd)

.DEFAULT_GOAL := update

install: update link

link:
	@echo "==== Linking HOME =============================================================="
	@echo "---> bash(1) config"
	@ln -sf ${dotdir}/home/.bash_completions ~/.bash_completions
	@ln -sf ${dotdir}/home/.bash_logout ~/.bash_logout
	@ln -sf ${dotdir}/home/.bash_paths ~/.bash_paths
	@ln -sf ${dotdir}/home/.bash_profile ~/.bash_profile
	@ln -sf ${dotdir}/home/.bashrc ~/.bashrc
	@echo "---> vi(1) config"
	@ln -sf ${dotdir}/home/.exrc ~/.exrc
	@echo "---> git(1) config"
	@ln -sf ${dotdir}/home/.gitconfig ~/.gitconfig
	@ln -sf ${dotdir}/home/.gitignore ~/.gitignore
	@echo "---> ksh(1) config"
	@ln -sf ${dotdir}/home/.ksh_completions ~/.ksh_completions
	@ln -sf ${dotdir}/home/.ksh_paths ~/.ksh_paths
	@ln -sf ${dotdir}/home/.kshrc ~/.kshrc
	@echo "==== Linking .config ==========================================================="
	@echo "---> alacritty(1) config"
	@ln -sf ${dotdir}/config/alacritty ~/.config/alacritty
	@echo "---> dunst(1) config"
	@ln -sf ${dotdir}/config/dunst ~/.config/dunst
	@echo "---> hikari(1) config"
	@ln -sf ${dotdir}/config/hikari ~/.config/hikari
	@echo "---> htop(1) config"
	@ln -sf ${dotdir}/config/htop ~/.config/htop
	@echo "---> mako(1) config"
	@ln -sf ${dotdir}/config/mako ~/.config/mako
	@echo "---> mpDris2 config"
	@ln -sf ${dotdir}/config/mpDris2 ~/.config/mpDris2
	@echo "---> mpd config"
	@ln -sf ${dotdir}/config/mpd ~/.config/mpd
	@echo "---> mutt(1) config & scripts"
	@mkdir -p ~/.config/mutt
	@ln -sf ${dotdir}/config/mutt/bindings.muttrc ~/.config/mutt/bindings.muttrc
	@ln -sf ${dotdir}/config/mutt/colours.muttrc ~/.config/mutt/colours.muttrc
	@ln -sf ${dotdir}/config/mutt/global.muttrc ~/.config/mutt/global.muttrc
	@ln -sf ${dotdir}/config/mutt/macros.muttrc ~/.config/mutt/macros.muttrc
	@ln -sf ${dotdir}/config/mutt/mailcap ~/.config/mutt/mailcap
	@ln -sf ${dotdir}/config/mutt/message-hooks.muttrc ~/.config/mutt/message-hooks.muttrc
	@ln -sf ${dotdir}/config/mutt/muttrc ~/.config/mutt/muttrc
	@ln -sf ${dotdir}/config/mutt/scripts ~/.config/mutt/scripts
	@echo "---> ncmpcpp(1) config"
	@ln -sf ${dotdir}/config/ncmpcpp ~/.config/ncmpcpp
	@echo "---> tkremind(1) config"
	@ln -sf ${dotdir}/config/tkremindrc ~/.config/tkremindrc
	@echo "---> xdg config"
	@ln -sf ${dotdir}/config/user-dirs.dirs ~/.config/user-dirs.dirs
	@ln -sf ${dotdir}/config/user-dirs.locale ~/.config/user-dirs.locale
	@echo "---> vis(1) config"
	@ln -sf ${dotdir}/config/vis ~/.config/vis
	@echo "---> xfe(1) configs"
	@ln -sf ${dotdir}/config/xfe ~/.config/xfe
	@echo "---> yt-dlp(1) config"
	@ln -sf ${dotdir}/config/yt-dlp ~/.config/yt-dlp
	@echo "---> zathura(1) config"
	@ln -sf ${dotdir}/config/zathura ~/.config/zathura

remove:
	rm -f ~/bin/check_mutt_mailboxes
	rm -f ~/bin/emailinfo
	rm -f ~/bin/mymail
	rm -f ~/bin/pass
	rm -f ~/bin/upgrade

uninstall: remove unlink

unlink:
	@echo "==== Removing links from HOME =================================================="
	@echo "---> bash(1) config"
	@rm -f ~/.bash_completions
	@rm -f ~/.bash_logout
	@rm -f ~/.bash_paths
	@rm -f ~/.bash_profile
	@rm -f ~/.bashrc
	@echo "---> vi(1) config"
	@rm -f ~/.exrc
	@echo "---> git(1) config"
	@rm -f ~/.gitconfig
	@rm -f ~/.gitignore
	@echo "---> ksh(1) config"
	@rm -f ~/.ksh_completions
	@rm -f ~/.ksh_paths
	@rm -f ~/.kshrc
	@echo "==== Removing links from .config ==============================================="
	@echo "---> alacritty(1) config"
	@rm -f ~/.config/alacritty
	@echo "---> dunst(1) config"
	@rm -f ~/.config/dunst
	@echo "---> hikari(1) config"
	@rm -f ~/.config/hikari
	@echo "---> htop(1) config"
	@rm -f ~/.config/htop
	@echo "---> mako(1) config"
	@rm -f ~/.config/mako
	@echo "---> mpDris2 config"
	@rm -f ~/.config/mpDris2
	@echo "---> mpd config"
	@rm -f ~/.config/mpd
	@echo "---> mutt(1) config & scripts"
	@rm -f ~/.config/mutt/bindings.muttrc
	@rm -f ~/.config/mutt/colours.muttrc
	@rm -f ~/.config/mutt/global.muttrc
	@rm -f ~/.config/mutt/macros.muttrc
	@rm -f ~/.config/mutt/mailcap
	@rm -f ~/.config/mutt/message-hooks.muttrc
	@rm -f ~/.config/mutt/muttrc
	@rm -f ~/.config/mutt/scripts
	@echo "---> ncmpcpp(1) config"
	@rm -f ~/.config/ncmpcpp
	@echo "---> tkremind(1) config"
	@rm -f ~/.config/tkremindrc
	@echo "---> xdg config"
	@rm -f ~/.config/user-dirs.dirs
	@rm -f ~/.config/user-dirs.locale
	@echo "---> vis(1) config"
	@rm -f ~/.config/vis
	@echo "---> xfe(1) configs"
	@rm -f ~/.config/xfe
	@echo "---> yt-dlp(1) config"
	@rm -f ~/.config/yt-dlp
	@echo "---> zathura(1) config"
	@rm -f ~/.config/zathura

update:
	@mkdir -p ~/bin/
	cp -f bin/check_mutt_mailboxes ~/bin/check_mutt_mailboxes
	cp -f bin/emailinfo ~/bin/emailinfo
	cp -f bin/mymail ~/bin/mymail
	cp -f bin/pass ~/bin/pass
	cp -f bin/upgrade ~/bin/upgrade

.PHONY: install link remove uninstall unlink update
