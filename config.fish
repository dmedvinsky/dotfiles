# vim: fdm=marker

# Environment variables {{{
set PATH "/bin"
set PATH "/sbin" $PATH
set PATH "/usr/bin" $PATH
set PATH "/usr/sbin" $PATH
test -d "/usr/local/bin"; and set PATH "/usr/local/bin" $PATH
test -d "/usr/local/sbin"; and set PATH "/usr/local/sbin" $PATH
test -d "/usr/bin/vendor_perl"; and set PATH "/usr/bin/vendor_perl" $PATH
test -d "$HOME/.android/sdk/tools"; and set PATH "$HOME/.android/sdk/tools" $PATH
test -d "$HOME/.android/sdk/platform-tools"; and set PATH "$HOME/.android/sdk/platform-tools" $PATH
test -d "$HOME/.cabal/bin"; and set PATH "$HOME/.cabal/bin" $PATH
test -d "$HOME/bin"; and set PATH "$HOME/bin" $PATH

set -g -x fish_greeting ''
set -g -x __fish_git_prompt_showdirtystate 1
set -g -x __fish_git_prompt_showstashstate 1
set -g -x __fish_git_prompt_showuntrackedfiles 1
set -g -x __fish_git_prompt_showupstream auto,verbose
set -g -x __fish_git_prompt_color magenta
set -g -x __fish_git_prompt_color_dirtystate red

set -g -x VISUAL vim
set -g -x EDITOR vim
set -g -x PAGER less

set -g -x GREP_OPTIONS '--color=auto'
set -g -x PENTADACTYL_RUNTIME "$HOME/.cache/pentadactyl"

# Python
set -g -x PIP_DOWNLOAD_CACHE "$HOME/.pip/cache"
set -g -x VIRTUAL_ENV_DISABLE_PROMPT true
test -r "$HOME/.pythonrc.py"; and set -g -x PYTHONSTARTUP "$HOME/.pythonrc.py"
# }}}

# Prompt {{{
function __prompt_char
    if git root >/dev/null 2>&1
       printf '±'
    else
        if hg root >/dev/null 2>&1
            printf '☿'
        else
            printf '°'
        end
    end
end

function __virtual_env
    if test -n "$VIRTUAL_ENV"
        printf ' in '
        set_color -o yellow
        printf '%s' (basename "$VIRTUAL_ENV")
        printf ' environment'
        set_color normal
    end
end

function fish_prompt
    set last_status $status

    printf '\n'

    # username
    set_color magenta
    printf '%s' (whoami)
    # at
    set_color normal
    printf ' at '
    # host
    set_color yellow
    printf '%s' (hostname|cut -d . -f 1)
    # in
    set_color normal
    printf ' in '
    # pwd
    set_color $fish_color_cwd
    printf '%s' (prompt_pwd)
    set_color normal
    # cool stuff
    __fish_git_prompt
    __virtual_env

    printf '\n'

    if test $last_status -eq 0
        # scm-aware fishy
        set_color white -o
        printf '><(('
        __prompt_char
        printf '> '
    else
        # dead fishy
        set_color red -o
        printf '[%d] ><((ˣ> ' $last_status
    end

    set_color normal
end
# }}}

# Aliases {{{
alias ef   'vim ~/.config/fish/config.fish'
alias rf   '. ~/.config/fish/config.fish'

alias ..   'cd ..'
alias ...  'cd ../..'
alias .... 'cd ../../..'
alias cd.. 'cd ..'
alias md   'mkdir -p'

if which tree >/dev/null ^/dev/null
    alias l1  'tree --dirsfirst -ChFL 1'
    alias l2  'tree --dirsfirst -ChFL 2'
    alias l3  'tree --dirsfirst -ChFL 3'
    alias ll1 'tree --dirsfirst -ChFupDaL 1'
    alias ll2 'tree --dirsfirst -ChFupDaL 2'
    alias ll3 'tree --dirsfirst -ChFupDaL 3'
    alias l   'l1'
    alias ll  'll1'
else
    alias ls  'ls -F'
    alias ll  'ls -lh'
    alias la  'll -a'
    alias l   'll'
end

if which rc.d >/dev/null ^/dev/null
    alias start   'sudo rc.d start'
    alias stop    'sudo rc.d stop'
    alias restart 'sudo rc.d restart'
end

alias g   'git'
alias gs  'git status'
alias gd  'git diff'
alias ga  'git add'
alias go  'git checkout'
alias gc  'git commit -v'
alias gca 'git commit -v --amend'
alias gp  'git pull'
alias gb  'git branch'
alias ga. 'git add .'
alias gba 'git branch -a'
alias gri 'git rebase --interactive'
# }}}

# Functions {{{
function venv
    set -l curdir (pwd)
    set -l gitroot (git root)
    set -l projectname (basename "$gitroot")
    set -l venv "$HOME/.pyenv/$projectname"
    set -l activate "$venv/bin/activate.fish"
    . "$activate"
end
# }}}

# Local Settings {{{
if test -s $HOME/.local/config.fish
    source $HOME/.local/config.fish
end
#normal }}}

set -gx HOSTNAME (hostname)
if status --is-interactive
    if which keychain >/dev/null 2>&1
        keychain --nogui --quick --quiet
        [ -e $HOME/.keychain/$HOSTNAME-fish ]; and . $HOME/.keychain/$HOSTNAME-fish
        # set SSH_AGENT_PID
        # set SSH_AUTH_SOCK
        # eval (keychain --eval -Q --quiet)
    end
end
