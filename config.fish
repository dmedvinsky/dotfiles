# vim: fdm=marker

# Environment variables {{{
# Path
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
test -d "$HOME/.rbenv/bin"; and set PATH "$HOME/.rbenv/bin" $PATH
test -d "$HOME/.rbenv/shims"; and set PATH "$HOME/.rbenv/shims" $PATH
test -d "/opt/vagrant"; and set PATH "/opt/vagrant/bin" $PATH
begin
    set -l gemdir (ruby -rubygems -e "puts Gem.user_dir")/bin
    test -n "$gemdir" -a -d "$gemdir"; and set PATH "$gemdir" $PATH
end
test -d "$HOME/bin"; and set PATH "$HOME/bin" $PATH

# Globally recognised variables
set -g -x VISUAL vim
set -g -x EDITOR vim
set -g -x PAGER less

# Fish shell
set -g -x fish_greeting ''
set -g -x __fish_git_prompt_showdirtystate 1
set -g -x __fish_git_prompt_showstashstate 1
set -g -x __fish_git_prompt_showuntrackedfiles 1
set -g -x __fish_git_prompt_showupstream auto,verbose
set -g -x __fish_git_prompt_color magenta
set -g -x __fish_git_prompt_color_dirtystate red

# Various programs
set -g -x GREP_OPTIONS '--color=auto'
set -g -x PENTADACTYL_RUNTIME "$HOME/.config/pentadactyl"
set -g -x VIMPERATOR_RUNTIME "$HOME/.config/vimperator"
set -g -x CMUS_HOME "$HOME/.config/cmus"
set -g -x GIMP2_DIRECTORY "$HOME/.config/gimp"

# Python
set -g -x PIP_DOWNLOAD_CACHE "$HOME/.pip/cache"
set -g -x VIRTUAL_ENV_DISABLE_PROMPT true
test -r "$HOME/.pythonrc.py"; and set -g -x PYTHONSTARTUP "$HOME/.pythonrc.py"

# Ruby
set -g -x RUBYOPT "-Ku"

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

    printf ' \n'

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

# Functions {{{
# Fish config editing
function ef; vim ~/.config/fish/config.fish; end
function rf; . ~/.config/fish/config.fish; end

# Directories traversal
function ..; cd ..; end
function ...; cd ../..; end
function ....; cd ../../..; end
function cd..; cd ..; end
function md; mkdir -p $argv; end

# Directories listing
if which tree >/dev/null ^/dev/null
    function l1;  tree --dirsfirst -ChFL 1 $argv; end
    function l2;  tree --dirsfirst -ChFL 2 $argv; end
    function l3;  tree --dirsfirst -ChFL 3 $argv; end
    function ll1; tree --dirsfirst -ChFupDaL 1 $argv; end
    function ll2; tree --dirsfirst -ChFupDaL 2 $argv; end
    function ll3; tree --dirsfirst -ChFupDaL 3 $argv; end
    function l;   l1 $argv; end
    function ll;  ll1 $argv; end
else
    function ls; ls -F $argv; end
    function ll; ls -lh $argv; end
    function la; ll -a $argv; end
    function l;  ll $argv; end
end

function less; command less -R $argv; end

# Git
function g;   git $argv; end
function gs;  git status $argv; end
function gd;  git diff $argv; end
function ga;  git add $argv; end
function go;  git checkout $argv; end
function gc;  git commit -v $argv; end
function gca; git commit -v --amend $argv; end
function gp;  git pull $argv; end
function gpr; git pull --rebase $argv; end
function gb;  git branch $argv; end
function ga.; git add . $argv; end
function gba; git branch -a $argv; end
function gri; git rebase --interactive $argv; end

# Tmux
function ta; tmux attach $argv; end

# Systemd
if which systemctl >/dev/null ^/dev/null
    function start; sudo systemctl start $argv; end
    function stop; sudo systemctl stop $argv; end
    function restart; sudo systemctl restart $argv; end
end

function venv
    # Activates Python virtualenv for current project.
    # Supports reading .env.
    # If that's directory with virtual env, activates it.
    # If that's file, reads path to virtual env from there.
    # Otherwise locates virtual env in ~/.pyenv/.
    set -l curdir (pwd)
    set -l gitroot (git root)
    set -l venv ""
    set -l locenv "$gitroot/.env"
    if [ -d "$locenv" ]
        # Prefer local environment if exists.
        set venv "$locenv"
    else
        if [ -f "$locenv" ]
            # If .env is a file, there must be the path to the env.
            set venv (cat "$locenv")
        else
            # If there is no env in repo root, use one from ~/.pyenv/.
            set -l projectname (basename "$gitroot")
            set venv "$HOME/.pyenv/$projectname"
        end
    end
    set -l activate "$venv/bin/activate.fish"
    if [ ! -r "$activate" ]
        echo "Cannot locate virtualenv for this project." >&2
    else
        . "$activate"
    end
end
# }}}

# Key bindings {{{
function fish_user_key_bindings
    # bind \ck accept-autosuggestion
end
# }}}

# Local Settings
if test -s $HOME/.local/config.fish
    source $HOME/.local/config.fish
end

set -gx HOSTNAME (hostname)
if status --is-interactive
    if which keychain >/dev/null 2>&1
        set -lx KEYCHAIN_DIR "$HOME/.cache/keychain"
        /usr/bin/keychain --agents ssh --dir "$KEYCHAIN_DIR" --noask --nocolor --nogui --quick --quiet --timeout 30
        [ -e "$KEYCHAIN_DIR/$HOSTNAME-fish" ]; and . "$KEYCHAIN_DIR/$HOSTNAME-fish"
        [ -e "$KEYCHAIN_DIR/$HOSTNAME-fish-gpg" ]; and . "$KEYCHAIN_DIR/$HOSTNAME-fish-gpg"
    end
end
