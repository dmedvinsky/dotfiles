# Check for an interactive session
[ -z "$PS1" ] && return


# Variables {{{1
export VISUAL=vim
export EDITOR=vim

export PATH="/usr/local/bin:$PATH"
export PATH="~/bin:$PATH"
# }}}1


# Prompt {{{1
if [ -n "$DISABLE_COLOR" ]; then
    export PS1='[\u@\h \W]\$ '
else
    export PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]]\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

prompt_command() {
    local RETURN_CODE="$?"
    local ASCII_RESET="\[\e[0m\]"
    local ASCII_BOLD="\[\e[1m\]"
    local USER_COLOR="\[\e[1;33m\]"
    local PROMPT_COLOR="\[\e[1;32m\]"
    if (( $EUID == 0 )) ; then
        PROMPT_COLOR="\[\e[1;31m\]"
    fi
    local HOST_COLOR="\[\e[1;32m\]"
    local DATE_COLOR="\[\e[1;31m\]"
    local TIME_COLOR="\[\e[1;34m\]"
    local DATE_STRING="\$(date +%Y-%m-%d)"
    local TIME_STRING="\$(date +%H:%M:%S)"
    local CYAN_COLOR="\[\e[1;36m\]"
    local PINK_COLOR="\[\e[1;35m\]"

    local PROMPT_PREFIX="$PROMPT_COLOR"
    if [[ $RETURN_CODE != 0 ]] ; then
        PROMPT_PREFIX="$DATE_COLOR$RETURN_CODE$ASCII_RESET " # do nothing
    fi
    local GIT_STATUS=`git status 2>/dev/null`
    if [[ $GIT_STATUS != "" ]] ; then
        local REFS=$(git symbolic-ref HEAD 2>/dev/null)
        REFS="${REFS#refs/heads/}"
        if [[ `echo $GIT_STATUS | grep "modified:"` != "" ]] ; then
            REFS="$REFS$ASCII_RESET ${PINK_COLOR}modified"
        fi
        if [[ `echo $GIT_STATUS | grep "ahead of"` != "" ]] ; then
            REFS="$REFS$ASCII_RESET ${CYAN_COLOR}not pushed"
        fi
        local GIT_STASH_LIST=`git stash list 2>/dev/null | wc -l`
        if [[ $GIT_STASH_LIST != "0" ]] ; then
            REFS="$REFS$ASCII_RESET ${CYAN_COLOR}${GIT_STASH_LIST} stashes"
        fi
        PROMPT_PREFIX="$PROMPT_PREFIX$USER_COLOR$REFS$ASCII_RESET "
    fi

    PS1="$ASCII_BOLD[$USER_COLOR\u $HOST_COLOR\h $DATE_COLOR$DATE_STRING $TIME_COLOR$TIME_STRING $PROMPT_PREFIX$ASCII_RESET\w$ASCII_BOLD]$ASCII_RESET\n$PROMPT_COLOR\\\$$ASCII_RESET "
}
if [ -z "$DISABLE_GIT_STATUS" ]; then
    export PROMPT_COMMAND=prompt_command
fi
# }}}1


# Aliases {{{1
alias g='gvim --remote-silent'
alias :e='vim'
alias e=':e'
alias :q='exit'
alias :qa=':q'

alias ls='ls --color=auto -F'
alias ll='ls -lh'
alias la='ll -a'
alias l='ll'

alias cal='cal -3m'

alias get='git'
alias got='git'

alias svn='echo "svn my ass:why bother?:stop this" | tr ":" "\n" | sort -R | head -1 && svn'
alias upgrade_warnings='sudo cat /var/log/pacman.log | grep `date "+%Y-%m-%d"` | grep warning'
# }}}1


# Local settings
[ -f "$HOME/.bashrc.local" ] && source ~/.bashrc.local
