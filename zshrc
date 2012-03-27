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

# WORDCHARS=''
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

# autoload -U edit-command-line
# zle -N edit-command-line

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
# }}}

# PATH {{{
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
addpath() {
    path="$PATH"
    path=$(echo $path | /bin/sed -re "s!$1:!!")
    [ -d "$1" ] && path="$1:$path"
    export PATH=$path
}
addpath "$HOME/.cabal/bin"
addpath "$HOME/bin"
# }}}

# Environment {{{
set +o beep

export PAGER=less
export EDITOR=vim
export VISUAL=vim
export GREP_OPTIONS='--color=auto'
# }}}

# Aliases {{{
alias ll='ls --color -lh'
alias la='ll -a'
alias  l='ll'

alias start='sudo rc.d start'
alias stop='sudo rc.d stop'
alias restart='sudo rc.d restart'

alias ..='cd ..'
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

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg  root   >/dev/null 2>/dev/null && echo '☿' && return
    echo '$'
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}
$(prompt_char) '
# }}}


# Vi-mode {{{
bindkey -d
bindkey -v
bindkey ' ' magic-space

bindkey -M vicmd "^M" accept-line
# bindkey -M vicmd "v"  edit-command-line
bindkey -M vicmd "gg" beginning-of-history
bindkey -M vicmd "G"  end-of-history
bindkey -M vicmd "p"  history-search-backward
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
