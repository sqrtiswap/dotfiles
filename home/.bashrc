# .bashrc

# if not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# PATHS
if [ -e "$HOME"/.bash_paths ] ; then
	# shellcheck source=$HOME/.bash_paths
	. "$HOME"/.bash_paths
fi

# check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# PROMPT
_XTERM_TITLE='\[\033]0;\u@\h:\w\007\]'
_PS1_CLEAR='\[\033[0m\]'   # reset
_PS1_BLUE='\[\033[34m\]'   # blue
_PS1_RED='\[\033[1;31m\]'  # red
_PS1_GREEN='\[\033[32m\]'  # green
_SH_COLOUR='\[\033[33m\]'  # yellow
_GIT_COLOUR='\[\033[95m\]' # magenta
case "$(id -u)" in
	0) _PS1_COLOUR=$_PS1_RED ;;
	*) _PS1_COLOUR=$_PS1_GREEN ;;
esac

git_branch() {
	if git rev-parse --git-dir > /dev/null 2>&1 && git rev-parse --abbrev-ref HEAD > /dev/null 2>&1 ; then
		printf "%s" "$(git rev-parse --abbrev-ref HEAD)"
	else
		printf ""
	fi
}

ahead_behind() {
	if git rev-parse --git-dir > /dev/null 2>&1 && git rev-parse --abbrev-ref HEAD > /dev/null 2>&1 ; then
		# get branch
		curr_branch=$(git rev-parse --abbrev-ref HEAD)
		# get corresponding remote branch
		curr_remote=$(git config branch.$curr_branch.remote)
		if [ -n "${curr_remote}" ] ; then
			# get branch the remote should be merged into
			curr_merge_branch=$(git config branch.$curr_branch.merge | cut -d / -f 3)
			# count and compare commits
			git rev-list --left-right --count $curr_branch...$curr_remote/$curr_merge_branch | tr -s '\t' '|'
		else
			printf ""
		fi
	fi
}

#_shell='\[[$0]'
_shell='$0'
_exit_code="\[\033[0;\$((\$?==0?0:31))m\]\[[\${?}]"
if [[ "$TERM" =~ tmux ]] ; then
	_basics="$_XTERM_TITLE$_SH_COLOUR$_shell $_exit_code $_PS1_COLOUR\u $_PS1_BLUE\w$_PS1_CLEAR"
else
	_basics="$_XTERM_TITLE$_SH_COLOUR$_shell $_exit_code $_PS1_COLOUR\u@$_PS1_CLEAR\h $_PS1_BLUE\w$_PS1_CLEAR"
fi
_git_prompt="$_GIT_COLOUR\$(git_branch) \$(ahead_behind)"
_time="$_PS1_CLEAR\A"
_prompt="$_PS1_COLOUR\$$_PS1_CLEAR"
PS1="${_basics} ${_git_prompt}\n${_time} ${_prompt} "
PS2='> '

export PS1 PS2

# OS
_os=$(uname -s)
if [ "${_os}" = "OpenBSD" ] ; then
	OS="obsd"
	DOAS='doas'
elif [ "${_os}" = "Linux" ] ; then
	OS="linux"
	DOAS='sudo'
elif [ "${_os}" = "Darwin" ] ; then
	OS="macos"
	DOAS='sudo'
fi
export OS

# EDITOR, PAGER
if command -v nvim > /dev/null ; then
	VI='nvim'
elif command -v vim > /dev/null ; then
	VI='vim'
else
	VI='vi'
fi
export EDITOR=$VI
export VISUAL=$VI
export FCEDIT=$EDITOR
export PAGER=less
export LESS='-iMRS -x2'
alias vise="$VI"
alias svi="$DOAS $VI"

# emacs mode provides the familiar Ctrl-A, Ctrl-E, etc.
# using arrow keys to go through the history, too
set -o emacs

# vi mode provides vi shortcuts
# Esc+j/k to go through the history
# Esc+h/l to move the cursor in a long command
# Esc+/ to search and filter the history
#set -o vi

# in vi mode maybe get https://github.com/alols/xcape and add
# xcape -e 'Alt_L=Escape' &
# to $HOME/.xsession

# HISTORY
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL="erasedups:ignoreboth"
HISTTIMEFORMAT='%F %T '
# append to the history file, don't overwrite it
shopt -s histappend
HISTFILE="$HOME"/.bash_history
HISTSIZE=10000
HISTFILESIZE=2000
shopt -s cmdhist

# SETTING FLAGS/OPTIONS
if [ "$OS" = "obsd" ] ; then
	alias ls='ls -FHh'
	alias spkr='$DOAS mixerctl -t outputs.spkr_mute'
	alias norms='sndioctl output.level=0.510'
	alias normb='$DOAS wsconsctl display.brightness=70%'

	# PACKAGE MANAGEMENT
	alias pkga='$DOAS pkg_add'
	alias pkgi='pkg_info'
	alias pkgd='$DOAS pkg_delete'
	alias pkgan='pkg_add -s'

	alias checkrun='pgrep -q'
	alias top='top -Ci'

	alias pbrother='/usr/local/bin/lpr -P littlebrother'

	# MONITOR SETUPS
	alias mono="xrandr \
		--output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
		--output DP-1 --off \
		--output DP-2 --off \
		--output HDMI-1 --off \
		--output HDMI-2 --off"
	alias monw="xrandr \
		--output eDP-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
		--output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal"
elif [ "$OS" = "linux" ] ; then
	alias ls='LANG=C ls --color=auto --group-directories-first -FHh'

	# PACKAGE MANAGEMENT
	if command -v dnf > /dev/null ; then
		alias pkga='$DOAS dnf install'
		alias pkgi='dnf search'
		alias pkgd='$DOAS dnf remove'
	elif command -v dispatch-conf > /dev/null ; then
		alias dispatch-conf="$DOAS dispatch-conf"
	fi

	alias checkrun='pidof -q'
	alias top='top -i'

	alias backrem='remind -z -k"notify-send -w %s &" ~/.reminders &'

	# Uncomment to disable systemctl's auto-paging feature
	# export SYSTEMD_PAGER=
elif [ "$OS" = "macos" ] ; then
	alias ls='LANG=C ls --color=auto -FHh'

	alias checkrun='pgrep -qi'

	alias backrem='remind -z -k"terminal-notifier -message %s -title Remind" ~/.reminders > /dev/null 2>&1 &'

	export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo
	export LC_ALL=en_GB.UTF-8
	export LANG=en_GB.UTF-8
	alias scanthis='freshclam && clamscan -z --scan-pdf=yes'
	alias rmtorstate='rm ~/Library/Application\ Support/TorBrowser-Data/Tor/state'

	alias skim='open -a Skim.app'
	alias bmpd='brew services restart mpd'
	alias sha256sum='shasum -a 256'
fi
alias ll='ls -l'
alias la='ls -lA'
alias mkdir='mkdir -p'
alias df='df -h'
alias du='du -ch'
alias mount='$DOAS mount -v'
alias umount='$DOAS umount -v'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -v'
#alias man='man -Owidth=$(($COLUMNS<80?($COLUMNS-2):78))'

alias bye='$DOAS shutdown -p now'
alias reboot='$DOAS reboot'

alias teping='ping -c 3 www.gentoo.org'
alias wtf='wtf -o'

# coloured GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# PROGRAMS
alias clbin='man 1 clbin'
alias python='python3'

if [ "$OS" = "obsd" ] || [ "$OS" = "linux" ] ; then
	alias doc=zathura
	alias mup=mupdf
	if command -v nsxiv > /dev/null ; then
		alias img=nsxiv
	elif command -v sxiv > /dev/null ; then
		alias img=sxiv
	elif command -v imv > /dev/null ; then
		alias img=imv
	else
		alias img=feh
	fi
	alias scanthis='$DOAS freshclam && clamscan -z --scan-pdf=yes'
fi

# CALENDAR
if [ "$OS" = "macos" ] ; then
	alias cal='ncal -w $(date +%Y)'
else
	alias cal='cal -mwy'
fi
## remind
alias remind='remind -m -b1'
alias tkremind='tkremind -m -b1'
alias rem='rem -m -b1 -@ -gaadd'
alias remt='rem'
if [ -n "$DISPLAY" ] || [ "$OS" = "macos" ] ; then
	checkrun remind || backrem
	[ "$OS" = "linux" ] && disown "$(pidof remind)"
fi
## khal
if command -v khal > /dev/null ; then
	alias khali='khal interactive'
	alias khalt='khal list --day-format "" today 1d'
	alias khalw='khal list today 7d'
	alias calt='[ $(khalt | wc -l) -gt 0 ] && drawsep KHAL && khalt; [ $(remt | wc -l) -gt 0 ] && drawsep REMIND && remt'
	alias calw='remind -cu+1 ~/.reminders; drawsep; khalw'
	alias vsync='vdirsyncer sync'
else
	alias calt='[ $(remt | wc -l) -gt 0 ] && drawsep REMIND && remt'
	alias calw='remind -cu+1 ~/.reminders'
fi

# WEATHER
weather() {
	[ -n "$1" ] && location="$1" || location='Berlin'
	curl https://wttr.in/"${location}"
}
alias wberlin='weather Berlin'
alias wdetmold='weather Detmold'

# MPV
alias mpva='mpv --no-video'
alias mpv='mpv --no-audio-display'
alias mpvy='mpv --ytdl-format="bestvideo[ext=mp4][height<=?1080]+bestaudio"'
alias mpvg='mpv --ytdl-format="bestvideo[ext=mp4][height<=?1080]+bestaudio" --ytdl-raw-options=proxy="socks5://127.0.0.1:9150/"'

# YOUTUBE-DL
alias ytdl-a='youtube-dl -x -f bestaudio'
alias ytdl-v='youtube-dl -f bestvideo --recode-video mkv'
alias ytdl-av='youtube-dl -f bestvideo+bestaudio'
alias ytdl-va='ytdl-av'
alias ytdl-g='youtube-dl --proxy "socks5://127.0.0.1:9150/"'
alias ytdl-g-a='ytdl-g -x -f bestaudio'
alias ytdl-g-v='ytdl-g -f bestvideo --recode-video mkv'
alias ytdl-g-av='ytdl-g -f bestvideo+bestaudio'
alias ytdl-g-va='ytdl-g-av'

# PROJECTS
alias t=todo
export TODODIR="$HOME"/.todo
export TODO_COLOUR_A="\033[31m" # red
export TODO_COLOUR_B="\033[33m" # yellow
export TODO_COLOUR_C="\033[32m" # green
export TODO_COLOUR_D="\033[34m" # blue

export BACKUP_LISTDIR="$HOME"/sources/backup
export BACKUP_DATADIR="$HOME"/sources/dotfiles-data/Data

# F.I.S.T.
export FISTTODODIR="$HOME"/documents/fist/.todo
alias ft='TODODIR=$FISTTODODIR todo'
alias fticket='TODODIR=$FISTTODODIR ticket'

# UNI
UNIDIR="$HOME"/documents/uni/
alias uni='cd $UNIDIR && la'
export UNITODODIR="$UNIDIR"/.todo
alias ut='TODODIR=$UNITODODIR todo'
alias uticket='TODODIR=$UNITODODIR ticket'

# FIREFLY
export FIREFLY_PRIMARY_BOX='malcha'
export FIREFLY_PRIMARY_USER='alexanderm'
alias firefly='firefly -c -k ~/.ssh/id_fuberlin'

alias hooksync='lazyscript sync'
alias myscan='lazyscript scan'

# DIRECTORIES & FILES
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'

LITDIR="$HOME"/documents/literature/
alias lit='cd $LITDIR && la'

QRDIR="$HOME"/documents/quickreferences/
alias qr='cd $QRDIR && la'

export LAZYDIR="$HOME"/sources/housekeeping
export INBOX="$HOME"/inbox

# PLAN 9 FROM USER SPACE
alias acme='9 acme -a -f "$PLAN9"/font/fixed/unicode.9x18B.font &'
alias sam='9 sam -a &'

if [ -n "$DISPLAY" ] ; then
	if [ -d "$PLAN9" ] ; then
		if checkrun acme ; then
			checkrun fontsrv || ("$PLAN9"/bin/fontsrv &)
			checkrun plumber || ("$PLAN9"/bin/plumber &)
		#else
		#	pkill fontsrv
		#	pkill plumber
		fi
	fi
	if [ -f "$HOME"/bin/barstarter ] && [ "$OS" = "obsd" ] ; then
		checkrun -f termbar || ("$HOME"/bin/barstarter &)
		alias chbg='kill -9 $(checkrun -f backgroundmaker); backgroundmaker &'
	fi
fi

# COMPLETIONS
# enable programmable completion features
if ! shopt -oq posix ; then
	if [ -f /usr/share/bash-completion/bash_completion ] ; then
		. /usr/share/bash-completion/bash_completion
	fi
	if [ -f /etc/bash_completion ] ; then
		. /etc/bash_completion
	fi
fi
# completions installed via brew(1) are sourced in ~/.bash_profile
# homemade stuff
if [ -e "$HOME"/.bash_completions ] ; then
	. "$HOME"/.bash_completions
fi

# SSH
set_up_sshagent() {
	_gitlabssh=gitlab-fuphysik
	if checkrun ssh-agent ; then
		if ! ssh-add -l ; then
			ssh-add "$HOME"/.ssh/"${_gitlabssh}"
			ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
		else
			printf "ssh-agent already runs with PID: %s\n" "$(pidof ssh-agent)"
		fi
	else
		eval $(ssh-agent)
		ssh-add "$HOME"/.ssh/"${_gitlabssh}"
		ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock"
	fi
}
alias sshr=set_up_sshagent

# USEFUL VARIABLES
_today=$(date +%F)
_good="\033[32m" # green
_fail="\033[31m" # red
_warn="\033[33m" # yellow
_alrt="\033[34m" # blue
_rset="\033[0m"

# TERMINAL GREETING

agenda() {
	[ -z "$1" ] && command -v khal > /dev/null && drawsep 'KHAL' && khalt
	[ -z "$1" ] && drawsep 'REMIND' && remt
	drawsep 'PRIVATE todo (t)'
	todo today "$1"
	drawsep 'UNIVERSITY todo (ut)'
	ut today "$1"
	drawsep 'F.I.S.T. todo (ft)'
	ft today "$1"
	[ -n "$1" ] || emailinfo greeting
}

tmux_start() {
	if tmux list-sessions > /dev/null ; then
		exec tmux attach
	else
		exec tmux
	fi
}

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] ; then
	if [ -n "$DISPLAY" ] || [ "$OS" = "macos" ] ; then
		tmux_start
	fi
else
	uptime && export UPTIMETXT=$(uptime)

	if [ "$OS" = "obsd" ] ; then
		drawsep
		[ "$(sysctl -n kern.audio.record)" -eq 0 ] || echo "\033[1;34m[Recording] Audio recording is on.\033[0m"
		[ "$(sysctl -n kern.video.record)" -eq 0 ] || echo "\033[1;34m[Recording] Video recording is on.\033[0m"
		echo "proc:    $(sysctl -n kern.nprocs)/$(sysctl -n kern.maxproc)
		files:   $(sysctl -n kern.nfiles)/$(sysctl -n kern.maxfiles)
		threads: $(sysctl -n kern.nthreads)/$(sysctl -n kern.maxthread)"
		drawsep
	fi

	if [ -z "$DISPLAY" ] && [ "$OS" = "obsd" ] ; then
		_is_connected="$(sysctl -n hw.sensors.acpiac0.indicator0)"
		if [ "${_is_connected}" = "On (power supply)" ] ; then
			printf "${_good}[Power]${_rset} Connected (%s%%)" "$(apm -l)"
		elif [ "${_is_connected}" -eq 1 ] ; then
			printf "${_fail}[Power]${_rset} Time left: %sm (%s%%)" "$(apm -m)" "$(apm -l)"
		else
			printf "%s" "${_fail}[Power]${_rset} Something is weird. Check apm/sysctl ASAP!"
		fi
	else
		if [ "$(id -u)" != 0 ] ; then
			if grep -q "${_today}" "$LAZYDIR"/data/morning.run ; then
				agenda
			else
				printf "${_fail}lazyscript morning seems to not have run yet.\nThe last run was on %s.${_rset}\nDo it now (%s)? [y/n] " \
					"$(tail -1 "$LAZYDIR/data/morning.run")" \
					"$(date +%F)"
				IFS= read -r _morningrun
				[ "${_morningrun}" = "y" ] \
					&& lazyscript morning \
					&& agenda
			fi
		fi
	fi

	if ! checkrun ssh-agent ; then
		eval "$(ssh-agent)" > /dev/null
		if [ "$OS" = "macos" ] && [ "$(ssh-add -l | wc -l)" -lt 4 ] ; then
			ssh-add --apple-use-keychain ~/.ssh/gitlab-fuphysik 2>/dev/null
			ssh-add --apple-use-keychain ~/.ssh/github 2>/dev/null
			ssh-add --apple-use-keychain ~/.ssh/sourcehut 2>/dev/null
			ssh-add --apple-use-keychain ~/.ssh/gitlab 2>/dev/null
		#else
		#	if [ -e "$HOME"/.ssh/ssh_auth_sock ] || [ -h "$HOME"/.ssh/ssh_auth_sock ] ; then
		#		export SSH_AUTH_SOCK="$HOME"/.ssh/ssh_auth_sock
		#	fi
		fi
	fi
fi
