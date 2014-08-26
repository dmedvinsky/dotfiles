# vim: fdm=marker

# Environment variables {{{
# Path
test -d "/bin"; and set PATH "/bin"
test -d "/sbin"; and set PATH "/sbin" $PATH
test -d "/usr/bin"; and set PATH "/usr/bin" $PATH
test -d "/usr/sbin"; and set PATH "/usr/sbin" $PATH
test -d "/usr/local/bin"; and set PATH "/usr/local/bin" $PATH
test -d "/usr/local/sbin"; and set PATH "/usr/local/sbin" $PATH
test -d "$HOME/.android/sdk/tools"; and set PATH "$HOME/.android/sdk/tools" $PATH
test -d "$HOME/.android/sdk/platform-tools"; and set PATH "$HOME/.android/sdk/platform-tools" $PATH
test -d "$HOME/.cabal/bin"; and set PATH "$HOME/.cabal/bin" $PATH
test -d "$HOME/.rbenv/bin"; and set PATH "$HOME/.rbenv/bin" $PATH
test -d "$HOME/.rbenv/shims"; and set PATH "$HOME/.rbenv/shims" $PATH
test -d "/opt/vagrant/bin"; and set PATH "/opt/vagrant/bin" $PATH
test -d "$HOME/src/go/bin"; and set PATH "$HOME/src/go/bin" $PATH
test -d "$HOME/.local/bin"; and set PATH "$HOME/.local/bin" $PATH
test -d ".cabal-sandbox/bin"; and set PATH ".cabal-sandbox/bin" $PATH

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

# Python
set -g -x PIP_DOWNLOAD_CACHE "$HOME/.cache/pip"
set -g -x VIRTUAL_ENV_DISABLE_PROMPT true
test -r "$HOME/.pythonrc.py"; and set -g -x PYTHONSTARTUP "$HOME/.pythonrc.py"

# Ruby
set -g -x GEM_SPEC "$HOME/.cache/gem"

# Go
set -g -x GOPATH "$HOME/src/go"

# Various programs
set -g -x GREP_OPTIONS '--color=auto'
set -g -x LESSHISTFILE "/dev/null"
set -g -x VIFM "$HOME/.config/vifm"
set -g -x PSQLRC "$HOME/.config/psql/psqlrc"
set -g -x HTTPIE_CONFIG_DIR "$HOME/.config/httpie"
# set -g -x CMUS_HOME "$HOME/.config/cmus"
# set -g -x RXVT_SOCKET "$HOME/.cache/urxvtd.sock"
# set -g -x PENTADACTYL_RUNTIME "$HOME/.config/pentadactyl"
# set -g -x VIMPERATOR_RUNTIME "$HOME/.config/vimperator"
# set -g -x VIMPERATOR_INIT ":source $HOME/.config/vimperator/vimperatorrc"
# set -g -x GIMP2_DIRECTORY "$HOME/.config/gimp"

# }}}

# Aliases {{{
# Fish config editing
function ef; vim ~/.config/fish/config.fish; end
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

function fm; vifm . .; end

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
