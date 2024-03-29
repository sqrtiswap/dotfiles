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
	@echo "---> tmux(1) config"
	@ln -sf ${dotdir}/home/.tmux.conf ~/.tmux.conf
	@echo "---> xmobar(1) config"
	@ln -sf ${dotdir}/home/.xmobarrc ~/.xmobarrc
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
	@ln -sf ~/.config/mpd/mpd.conf ~/.mpdconf
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
	@echo "---> qtile(1) config"
	@ln -sf ${dotdir}/config/qtile ~/.config/qtile
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
	@echo "==== Removing tools from ~/bin ================================================="
	rm -f ~/bin/agenda
	rm -f ~/bin/barstarter
	rm -f ~/bin/calt
	rm -f ~/bin/calw
	rm -f ~/bin/check_mutt_mailboxes
	rm -f ~/bin/drawsep
	rm -f ~/bin/emailinfo
	rm -f ~/bin/kbdlswitch
	rm -f ~/bin/lemonscript.sh
	rm -f ~/bin/mymail
	rm -f ~/bin/pass
	rm -f ~/bin/see
	rm -f ~/bin/shortpath
	rm -f ~/bin/tellme
	rm -f ~/bin/termbar.sh
	rm -f ~/bin/upgrade
	rm -f ~/bin/videocall
	rm -f ~/bin/vpn
	rm -f ~/bin/wallpapermaker
	@echo "==== Removing desktopfiles ====================================================="
	rm -f ~/.local/share/applications/acme.desktop
	rm -f ~/.local/share/applications/email.desktop
	rm -f ~/.local/share/applications/tkremind.desktop
	@echo "==== Removing xbar-plugins ====================================================="
	rm -f ~/Library/Application\ Support/xbar/plugins/mpd_control.10s.sh
	rm -f ~/Library/Application\ Support/xbar/plugins/todo_today.1s.sh

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
	@echo "---> tmux(1) config"
	@rm -f ~/.tmux.conf
	@echo "---> xmobar(1) config"
	@rm -f ~/.xmobarrc
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
	@rm -f ~/.mpdconf
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
	@echo "---> qtile(1) config"
	@rm -f ~/.config/qtile
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
	@echo "==== Updating tools in ~/bin ==================================================="
	@mkdir -p ~/bin/
	cp -f bin/agenda ~/bin/agenda
	cp -f bin/barstarter ~/bin/barstarter
	cp -f bin/calt ~/bin/calt
	cp -f bin/calw ~/bin/calw
	cp -f bin/check_mutt_mailboxes ~/bin/check_mutt_mailboxes
	cp -f bin/drawsep ~/bin/drawsep
	cp -f bin/emailinfo ~/bin/emailinfo
	cp -f bin/kbdlswitch ~/bin/kbdlswitch
	cp -f bin/lemonscript.sh ~/bin/lemonscript.sh
	cp -f bin/mymail ~/bin/mymail
	cp -f bin/pass ~/bin/pass
	cp -f bin/see ~/bin/see
	cp -f bin/shortpath ~/bin/shortpath
	cp -f bin/tellme ~/bin/tellme
	cp -f bin/termbar.sh ~/bin/termbar.sh
	cp -f bin/upgrade ~/bin/upgrade
	cp -f bin/videocall ~/bin/videocall
	cp -f bin/vpn ~/bin/vpn
	cp -f bin/wallpapermaker ~/bin/wallpapermaker
	@echo "==== Updating desktopfiles ====================================================="
	@mkdir -p ~/.local/share/applications
	cp -f desktopfiles/acme.desktop ~/.local/share/applications/acme.desktop
	cp -f desktopfiles/email.desktop ~/.local/share/applications/email.desktop
	cp -f desktopfiles/tkremind.desktop ~/.local/share/applications/tkremind.desktop
	@echo "==== Updating xbar-plugins ====================================================="
	@mkdir -p ~/Library/Application\ Support/xbar/plugins
	cp -f xbar-plugins/mpd_control.10s.sh ~/Library/Application\ Support/xbar/plugins/mpd_control.10s.sh
	cp -f xbar-plugins/todo_today.1s.sh ~/Library/Application\ Support/xbar/plugins/todo_today.1s.sh

.PHONY: install link remove uninstall unlink update
