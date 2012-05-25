# Check for an interactive session
[ -z "$PS1" ] && return


# Variables {{{1
export VISUAL=vim
export EDITOR=vim

addpath() {
    path="$PATH"
    path=$(echo $path | /bin/sed -re "s!$1:!!")
    [ -d "$1" ] && path="$1:$path"
    export PATH=$path
}

addpath "/usr/local/bin"
addpath "$HOME/.cabal/bin"
addpath "$HOME/bin"
# }}}1


# Prompt {{{1
if [ -n "$DISABLE_COLOR" ]; then
    export PS1='[\u@\h \W]\$ '
else
    export PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]]\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

console_code() {
    local codes=( $@ )
    local code=$(printf ";%s" "${codes[@]}")
    code=${code:1}
    echo "\[\e[${code}m\]"
}

prompt_command() {
    local RETURN_CODE="$?"

    local RESET=`console_code 0`
    local BOLD=1
    local FG_BLACK=30
    local FG_RED=31
    local FG_GREEN=32
    local FG_BROWN=33
    local FG_BLUE=34
    local FG_MAGENTA=35
    local FG_CYAN=36
    local FG_WHITE=37
    local BG_BLACK=40
    local BG_RED=41
    local BG_GREEN=42
    local BG_BROWN=43
    local BG_BLUE=44
    local BG_MAGENTA=45
    local BG_CYAN=46
    local BG_WHITE=47

    local DELIMIT_FMT=`console_code 0 $BOLD $WHITE`
    local USER_FMT=`console_code 0 $BOLD $FG_RED`
    local HOST_FMT=`console_code 0 $BOLD $FG_WHITE`
    local CWD_FMT=`console_code 0 $BOLD $FG_WHITE`

    local DATE_FMT=`console_code 0 $BOLD $FG_GREEN`
    local TIME_FMT=`console_code 0 $BOLD $FG_GREEN`
    local DATE_STRING="\$(date +%Y-%m-%d)"
    local TIME_STRING="\$(date +%H:%M:%S)"

    local PROMPT_FMT=`console_code 0 $BOLD $FG_WHITE`
    local PROMPT_STRING="\$"
    if (( $EUID == 0 )) ; then
        PROMPT_FMT=`console_code 0 $BOLD $FG_RED`
        PROMPT_STRING="#"
    fi

    local ADDITIONAL="$RESET"
    if [[ $RETURN_CODE != 0 ]] ; then
        ADDITIONAL="`console_code 0 $FG_RED`(ret $RETURN_CODE)$RESET "
    fi

    local GIT_STATUS=`git status 2>/dev/null`
    if [[ $GIT_STATUS != "" ]] ; then
        local REFS=$(git symbolic-ref HEAD 2>/dev/null)
        REFS="${REFS#refs/heads/}"
        if [[ `echo $GIT_STATUS | grep "modified:"` != "" ]] ; then
            REFS="$REFS `console_code 0 $BOLD $FG_RED`modified"
        fi
        if [[ `echo $GIT_STATUS | grep "ahead of"` != "" ]] ; then
            REFS="$REFS `console_code 0 $FG_CYAN`not pushed"
        fi
        local GIT_STASH_LIST=`git stash list 2>/dev/null | wc -l`
        if [[ $GIT_STASH_LIST != "0" ]] ; then
            REFS="$REFS `console_code 0 $FG_CYAN`$GIT_STASH_LIST stashes"
        fi
        ADDITIONAL="$ADDITIONAL$REFS$RESET "
    fi

    PS1="$DELIMIT_FMT[$USER_FMT\u $HOST_FMT\h $DATE_FMT$DATE_STRING $TIME_FMT$TIME_STRING $ADDITIONAL$CWD_FMT\w$DELIMIT_FMT]\n$PROMPT_FMT$PROMPT_STRING$RESET "
}
if [ -z "$DISABLE_GIT_STATUS" ]; then
    export PROMPT_COMMAND=prompt_command
fi
# }}}1


# Aliases {{{1
alias e='vim'

alias ls='ls --color=auto -F'
alias ll='ls -lh'
alias la='ll -a'
alias l='ll'

alias cal='cal -3m'

alias g='git'
alias get='git'
alias got='git'

alias svn='echo "svn my ass:why bother?:stop this" | tr ":" "\n" | sort -R | head -1 && svn'

alias c='cabal-dev'

test -r "${HOME}/.local/alias" && source "${HOME}/.local/alias"
# }}}1


# Local settings
[ -f "${HOME}/.local/bashrc" ] && source "${HOME}/.local/bashrc"
