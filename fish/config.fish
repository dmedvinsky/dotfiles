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
if which ruby >/dev/null ^/dev/null
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

# Aliases {{{
# Fish config editing
function ef; vim ~/.config/fish/config.fish; end
function rf; . ~/.config/fish/config.fish; end

# Directories traversal
function ..; cd ..; end
function ...; cd ../..; end
function ....; cd ../../..; end
function cd..; cd ..; end

function md; mkdir -p $argv; end
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

# Systemd
if which systemctl >/dev/null ^/dev/null
    function start;   sudo systemctl start $argv; end
    function stop;    sudo systemctl stop $argv; end
    function restart; sudo systemctl restart $argv; end
end
# }}}

# Local Settings
if test -s $HOME/.local/config.fish
    . $HOME/.local/config.fish
end

set -gx HOSTNAME (hostname)
if status --is-interactive
    if which keychain >/dev/null 2>&1
        set -lx KEYCHAIN_DIR "$HOME/.cache/keychain"
        keychain --agents ssh --dir "$KEYCHAIN_DIR" --noask --nocolor --nogui --quick --quiet --timeout 30
        [ -e "$KEYCHAIN_DIR/$HOSTNAME-fish" ]; and . "$KEYCHAIN_DIR/$HOSTNAME-fish"
        [ -e "$KEYCHAIN_DIR/$HOSTNAME-fish-gpg" ]; and . "$KEYCHAIN_DIR/$HOSTNAME-fish-gpg"
    end
end
