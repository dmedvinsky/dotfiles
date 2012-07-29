# Options {{{
unsetopt menu_complete
setopt auto_menu
setopt complete_in_word
setopt always_to_end

setopt auto_cd
unsetopt cdablevars

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
unsetopt share_history

setopt prompt_subst

zmodload -i zsh/complist

# zstyle ':completion:function:completer:command:argument:tag'
zstyle ':completion:*' list-colors ''
# Case insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z-}={A-Za-z_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "${HOME}/.zsh_cache"

autoload -U compinit
compinit -i

autoload -U edit-command-line
zle -N edit-command-line

autoload colors
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr "$fg[green]!"
zstyle ':vcs_info:*' unstagedstr "$fg[red]!"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git hg
precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' %F{green}%b%c%u'
    }
    vcs_info
}

fpath=("${HOME}/src/universe/zsh-completions" $fpath)
# }}}

# Environment {{{
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
test -d "/usr/X11/bin" && PATH="/usr/X11/bin:${PATH}"
test -d "${HOME}/.gem/ruby/1.9.1/bin" && PATH="${HOME}/.gem/ruby/1.9.1/bin:${PATH}"
test -d "${HOME}/.android/sdk/tools" && PATH="${HOME}/.android/sdk/tools:${PATH}"
test -d "${HOME}/.android/sdk/platform-tools" && PATH="${HOME}/.android/sdk/platform-tools:${PATH}"
test -d "${HOME}/.cabal/bin" && PATH="${HOME}/.cabal/bin:${PATH}"
test -d "${HOME}/bin" && PATH="${HOME}/bin:${PATH}"
export $PATH

set +o beep

test -r $HOME/.config/LS_COLORS && eval $(dircolors $HOME/.config/LS_COLORS)

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export GREP_OPTIONS='--color=auto'
export VIRTUAL_ENV_DISABLE_PROMPT=true
export PENTADACTYL_RUNTIME="$HOME/.cache/pentadactyl"
# }}}

# Aliases {{{
if which tree >/dev/null 2>&1; then
    alias l1='tree --dirsfirst -ChFL 1'
    alias l2='tree --dirsfirst -ChFL 2'
    alias l3='tree --dirsfirst -ChFL 3'
    alias ll1='tree --dirsfirst -ChFupDaL 1'
    alias ll2='tree --dirsfirst -ChFupDaL 2'
    alias ll3='tree --dirsfirst -ChFupDaL 3'
    alias l='l1'
    alias ll='ll1'
else
    alias ls='ls -F'
    alias ll='ls -lh'
    alias la='ll -a'
    alias l='ll'
fi

if which rc.d >/dev/null 2>&1; then
    alias start='sudo rc.d start'
    alias stop='sudo rc.d stop'
    alias restart='sudo rc.d restart'
fi

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias cd..='cd ..'

alias gs='git status';          compdef _git gs=git-status
alias gd='git diff';            compdef _git gd=git-diff
alias ga='git add';             compdef _git ga=git-add
alias go='git checkout';        compdef _git go=git-checkout
alias gc='git commit -v';       compdef _git gc=git-commit
alias gp='git pull';            compdef _git gp=git-pull
alias gb='git branch';          compdef _git gb=git-branch
alias ga.='git add .';
alias gba='git branch -a';
alias gcount='git shortlog -sn';
# }}}

# Prompt {{{
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}
function __prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg  root   >/dev/null 2>/dev/null && echo '☿' && return
    echo '$'
}
function __virtual_env {
    if [ -n "$VIRTUAL_ENV" ]; then
        local name=$(basename $VIRTUAL_ENV)
        echo "(${name}) "
    fi
}

PROMPT='
%{$fg[red]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}
$(__virtual_env)$(__prompt_char) '
# }}}


# Vi-mode {{{
bindkey -d
bindkey -v
bindkey ' ' magic-space

bindkey -M vicmd "^M" accept-line
bindkey -M vicmd "v"  edit-command-line
bindkey -M vicmd "gg" beginning-of-history
bindkey -M vicmd "G"  end-of-history
bindkey -M vicmd "N"  history-search-backward
bindkey -M vicmd "n"  history-search-forward
bindkey -M vicmd "?"  history-incremental-search-backward
bindkey -M vicmd "/"  history-incremental-search-forward
bindkey -M vicmd "^L" clear-screen
bindkey -M vicmd " "  forward-char

bindkey -M viins "kj" vi-cmd-mode
bindkey -M viins "jk" vi-cmd-mode
bindkey -M viins "^R" history-incremental-search-backward

bindkey -M viins "${terminfo[khome]}" beginning-of-line
bindkey -M vicmd "${terminfo[khome]}" beginning-of-line
bindkey -M viins "${terminfo[kend]}" end-of-line
bindkey -M vicmd "${terminfo[kend]}" end-of-line
bindkey -M viins "${terminfo[kdch1]}" delete-char
bindkey -M vicmd "${terminfo[kdch1]}" delete-char
# bindkey -M viins "${terminfo[kpp]}" 
# bindkey -M vicmd "${terminfo[kpp]}" 
# bindkey -M viins "${terminfo[knp]}" 
# bindkey -M vicmd "${terminfo[knp]}" 
# }}}

test -r "${HOME}/.local/zshrc" && source "${HOME}/.local/zshrc"
