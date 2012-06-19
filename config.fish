# vim: fdm=marker

# Environment variables {{{
set PATH "/usr/local/bin" $PATH
set PATH "/usr/local/sbin" $PATH
set PATH "$HOME/bin" $PATH
set PATH "$HOME/.cabal/bin" $PATH
set PATH "$HOME/.gem/ruby/1.9.1/bin" $PATH
set PATH "$HOME/.android/sdk/tools" $PATH
set PATH "$HOME/.android/sdk/platform-tools" $PATH
set PATH "$HOME/.npm/bin/.bin" $PATH

set -g -x fish_greeting ''
set -g -x VISUAL vim
set -g -x EDITOR vim
set -g -x PAGES less

set -g -x GREP_OPTIONS '--color=auto'
set -g -x PENTADACTYL_RUNTIME "$HOME/.cache/pentadactyl"

# Python
set -g -x PIP_DOWNLOAD_CACHE "$HOME/.pip/cache"
# set -g -x PYTHONSTARTUP "$HOME/.pythonrc.py"
set -g -x VIRTUAL_ENV_DISABLE_PROMPT true
# }}}

# Prompt {{{
function __git_prompt_status
    # TODO
    printf ''
end

function __git_prompt
    if git root >/dev/null 2>&1
        set_color normal
        printf ' on '
        set_color magenta
        printf '%s' (git currentbranch ^/dev/null)
        set_color green
        __git_prompt_status
        set_color normal
    end
end

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
    __git_prompt
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
alias cd.. 'cd ..'
alias md   'mkdir -p'

alias l1  'tree --dirsfirst -ChFL 1'
alias l2  'tree --dirsfirst -ChFL 2'
alias l3  'tree --dirsfirst -ChFL 3'
alias ll1 'tree --dirsfirst -ChFupDaL 1'
alias ll2 'tree --dirsfirst -ChFupDaL 2'
alias ll3 'tree --dirsfirst -ChFupDaL 3'
alias l   'l1'
alias ll  'll1'

alias start   'sudo rc.d start'
alias stop    'sudo rc.d stop'
alias restart 'sudo rc.d restart'

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
