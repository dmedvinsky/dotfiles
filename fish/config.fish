# vim: fdm=marker

function _myfish_check_prog
    which $argv >/dev/null 2>/dev/null
end

### Environment variables {{{

## Path
test -d "/sbin"; and fish_add_path "/sbin"
test -d "/bin"; and fish_add_path "/bin"
test -d "/usr/sbin"; and fish_add_path "/usr/sbin"
test -d "/usr/bin"; and fish_add_path "/usr/bin"
test -d "/usr/local/sbin"; and fish_add_path "/usr/local/sbin"
test -d "/usr/local/bin"; and fish_add_path "/usr/local/bin"
test -d "$HOME/.local/bin"; and fish_add_path "$HOME/.local/bin"

## Globally recognised variables
set -g -x LANG en_US.UTF-8
if _myfish_check_prog nvim
    set -g -x VISUAL nvim
    set -g -x EDITOR nvim
else if _myfish_check_prog vim
    set -g -x VISUAL vim
    set -g -x EDITOR vim
else
    set -g -x VISUAL vi
    set -g -x EDITOR vi
end
if _myfish_check_prog bat
  set -g -x PAGER bat
  set -g -x BAT_STYLE changes,header,rule,snip
else
  set -g -x PAGER less
end
set -g -x XDG_DATA_HOME "$HOME/.local/share"
set -g -x XDG_CONFIG_HOME "$HOME/.config"
set -g -x XDG_STATE_HOME "$HOME/.local/state"
set -g -x XDG_CACHE_HOME "$HOME/.cache"
set -g -x XDG_RUNTIME_DIR "/run/user/$UID"

## Python
set -g -x PIP_DOWNLOAD_CACHE "$HOME/.cache/pip"
set -g -x VIRTUAL_ENV_DISABLE_PROMPT true
# set -g -x PYENV_ROOT "$XDG_DATA_HOME"/pyenv
set -g fish_user_paths "/usr/local/opt/gettext/bin" $fish_user_paths
## Ruby
set -g -x GEM_SPEC "$HOME/.cache/gem"
set -g -x BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME"/bundle
set -g -x BUNDLE_USER_CACHE "$XDG_CACHE_HOME"/bundle
set -g -x BUNDLE_USER_PLUGIN "$XDG_DATA_HOME"/bundle
## JS
set -g -x NPM_CONFIG_USERCONFIG "$HOME/.config/npm/npmrc"
# set -g -x NVM_DIR "$XDG_DATA_HOME"/nvm
test -d "$HOME/.local/share/npm/bin"; and fish_add_path "$HOME/.local/share/npm/bin"
test -d "$HOME/.yarn"; and fish_add_path "$HOME/.yarn/bin"; and fish_add_path "$HOME/.config/yarn/global/node_modules/.bin"

## Various programs
set -g -x LESSHISTFILE "/dev/null"
set -g -x AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME"/aws/credentials
set -g -x AWS_CONFIG_FILE "$XDG_CONFIG_HOME"/aws/config
set -g -x PSQLRC "$HOME/.config/psql/psqlrc"
set -g -x VIFM "$HOME/.config/vifm"
set -g -x HTTPIE_CONFIG_DIR "$HOME/.config/httpie"
set -g -x GNUPGHOME "$XDG_DATA_HOME"/gnupg
set -g -x RIPORT 8079
# set -g -x DOCKER_CONFIG "$XDG_CONFIG_HOME"/docker


### }}}

### Aliases {{{
## Fish config editing
alias ef="eval $EDITOR ~/.config/fish/config.fish"
alias rf="source ~/.config/fish/config.fish"

alias vi="nvim"
alias vim="nvim"

## Directories listing
if _myfish_check_prog exa
    alias  l1="exa --tree --group-directories-first --level=1"
    alias  l2="exa --tree --group-directories-first --level=2"
    alias  l3="exa --tree --group-directories-first --level=3"
    alias ll1="exa --tree --long --all --group-directories-first --level=1"
    alias ll2="exa --tree --long --all --group-directories-first --level=2"
    alias ll3="exa --tree --long --all --group-directories-first --level=3"
    alias   l="l1"
    alias  ll="ll1"
else if _myfish_check_prog tree
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

## Various programs
if _myfish_check_prog bat
    alias cat="bat"
    alias less="bat"
else
    alias less="less -R"
end

if _myfish_check_prog nnn
    alias fm="nnn -dHi"
else if _myfish_check_prog vifm
    alias fm="vifm . ."
end

if _myfish_check_prog tmux
    abbr --add a tmux attach
end
if _myfish_check_prog tmuxp
    abbr --add p tmuxp load
end
# }}}

### Local Settings
if test -s $HOME/.local/config.fish
    . $HOME/.local/config.fish
end

### Startup
if status --is-interactive
    if _myfish_check_prog direnv
        eval (direnv hook fish)
    end

    if test -z "$SSH_ENV"
      set -xg SSH_ENV $HOME/.ssh/environment
    end
    if not __ssh_agent_is_started
        __ssh_agent_start
    end
end
