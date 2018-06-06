# vim: fdm=marker

# Environment variables {{{

# Path
test -d "/sbin"; and set PATH "/sbin" $PATH
test -d "/bin"; and set PATH "/bin"
test -d "/usr/sbin"; and set PATH "/usr/sbin" $PATH
test -d "/usr/bin"; and set PATH "/usr/bin" $PATH
test -d "/usr/local/sbin"; and set PATH "/usr/local/sbin" $PATH
test -d "/usr/local/bin"; and set PATH "/usr/local/bin" $PATH
test -d "$HOME/.local/bin"; and set PATH "$HOME/.local/bin" $PATH

# Globally recognised variables
set -g -x LANG en_US.UTF-8
set -g -x VISUAL vi
set -g -x EDITOR vi
set -g -x PAGER less

# Fish shell
set -g -x fish_greeting ''
set -g -x __fish_git_prompt_showdirtystate 1
set -g -x __fish_git_prompt_showstashstate 1
set -g -x __fish_git_prompt_showuntrackedfiles 1
set -g -x __fish_git_prompt_showupstream auto,verbose
set -g -x __fish_git_prompt_color magenta
set -g -x __fish_git_prompt_color_dirtystate red
set FISH_CLIPBOARD_CMD "cat"

# Python
set -g -x PIP_DOWNLOAD_CACHE "$HOME/.cache/pip"
set -g -x VIRTUAL_ENV_DISABLE_PROMPT true
test -r "$HOME/.config/pythonrc.py"; and set -g -x PYTHONSTARTUP "$HOME/.config/pythonrc.py"
test -d "$HOME/.pyenv/bin"; and set -x PATH "$HOME/.pyenv/bin" $PATH
test -d "$HOME/.pyenv/shims"; and set -x PATH "$HOME/.pyenv/shims" $PATH
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths
# Ruby
set -g -x GEM_SPEC "$HOME/.cache/gem"
test -d "$HOME/.rbenv/bin"; and set PATH "$HOME/.rbenv/bin" $PATH
test -d "$HOME/.rbenv/shims"; and set PATH "$HOME/.rbenv/shims" $PATH
# Go
set -g -x GOPATH "$HOME/src/go"
test -d "$HOME/src/go/bin"; and set PATH "$HOME/src/go/bin" $PATH
# JS
set -g -x NPM_CONFIG_USERCONFIG "$HOME/.config/npm/npmrc"
test -d "$HOME/.local/share/npm/bin"; and set PATH "$HOME/.local/share/npm/bin" $PATH
# Haskell
test -d "$HOME/.cabal/bin"; and set PATH "$HOME/.cabal/bin" $PATH
test -d ".cabal-sandbox/bin"; and set PATH ".cabal-sandbox/bin" $PATH
# Rust
set -g -x CARGO_HOME "$HOME/.local/share/cargo"
test -d "$HOME/.local/share/cargo/bin"; and set PATH "$HOME/.local/share/cargo/bin" $PATH
# Android
set -g -x ANDROID_HOME "$HOME/.android"
set -g -x ANDROID_SDK_ROOT "$HOME/.android"
test -d "$ANDROID_HOME/emulator"; and set PATH "$ANDROID_HOME/emulator" $PATH
test -d "$ANDROID_HOME/tools/bin"; and set PATH "$ANDROID_HOME/tools/bin" $PATH
test -d "$ANDROID_HOME/platform-tools"; and set PATH "$ANDROID_HOME/platform-tools" $PATH
test -d "$ANDROID_HOME/build-tools/26.0.0"; and set PATH "$ANDROID_HOME/build-tools/26.0.0" $PATH

# Various programs
set -g -x LESSHISTFILE "/dev/null"
set -g -x VIFM "$HOME/.config/vifm"
set -g -x PSQLRC "$HOME/.config/psql/psqlrc"
set -g -x HTTPIE_CONFIG_DIR "$HOME/.config/httpie"

# }}}

# Aliases {{{
# Fish config editing
function ef; eval $EDITOR ~/.config/fish/config.fish; end
function rf; . ~/.config/fish/config.fish; end

# Directories traversal
function ..; cd ..; end
function ...; cd ../..; end
function ....; cd ../../..; end
function cd..; cd ..; end

function less; command less -R $argv; end

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
    function ls; command ls -F $argv; end
    function ll; ls -lh $argv; end
    function la; ll -a $argv; end
    function l;  ll $argv; end
end

if which vifm >/dev/null ^/dev/null
    function fm; vifm . .; end
end

if which tmux >/dev/null ^/dev/null
    function a; tmux attach; end
end
if which tmuxp >/dev/null ^/dev/null
    function p; tmuxp load $argv; end
end

# Systemd
if which systemctl >/dev/null ^/dev/null
    function start;   sudo systemctl start $argv; end
    function stop;    sudo systemctl stop $argv; end
    function restart; sudo systemctl restart $argv; end
    function reboot;  sudo systemctl reboot $argv; end
end
# }}}

# Local Settings
if test -s $HOME/.local/config.fish
    . $HOME/.local/config.fish
end

if status --is-interactive
    if which pyenv >/dev/null ^/dev/null
        . (pyenv init - | psub)
        . (pyenv virtualenv-init - | psub)
    end

    if which rbenv >/dev/null ^/dev/null
        . (rbenv init -|psub)
    end

    if test -z "$SSH_ENV"
      set -xg SSH_ENV $HOME/.ssh/environment
    end
    if not __ssh_agent_is_started
        __ssh_agent_start
    end
end
