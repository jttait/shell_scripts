################################################################################
# if not running interactively then don't do anything                          #
################################################################################

case $- in
    *i*) ;;
      *) return;;
esac

################################################################################
# bash history                                                                 #
################################################################################

shopt -s histappend # append to the history file, do not overwrite it
HISTCONTROL=ignoreboth # do not put duplicate lines or lines starting with space
                       # in the history
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

################################################################################
# prompt                                                                       #
################################################################################

PS1='${debian_chroot:+($debian_chroot)}\u\$ '

################################################################################
# If this is an xterm set the title to user@host:dir                           #
################################################################################

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

################################################################################
# colors for ls and grep                                                       #
################################################################################

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

################################################################################
# ls aliases                                                                   #
################################################################################

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias clr="clear"

################################################################################
# enable programmable completion features                                      #
################################################################################

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

################################################################################
# SDKMAN - must be at bottom of file for SDKMAN to work!                       #
################################################################################

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

