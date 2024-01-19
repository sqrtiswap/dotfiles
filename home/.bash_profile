#!/bin/bash

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ANALYTICS=1

# include ~/.bashrc if it exists
if [ -f "$HOME"/.bashrc ] ; then
	. "$HOME"/.bashrc
fi

# User specific environment and startup programs
if type brew &>/dev/null ; then
	HOMEBREW_PREFIX="$(brew --prefix)"
	if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]] ; then
		source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
	else
		for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"* ; do
			[[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
		done
	fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/alexander/.miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/alexander/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/alexander/.miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/alexander/.miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
