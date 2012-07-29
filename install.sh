#!/usr/bin/env bash
DIR=$(dirname $0)
BACKUP_DIR="${DIR}/backup"
DOTFILES_DIR=$(cd "${DIR}"; pwd)

cd "${DIR}" || exit 1
mkdir -p "${BACKUP_DIR}"
mkdir -p "${HOME}/.config"
if test -f "/usr/share/terminfo/r/rxvt-256color"; then :
else
    mkdir -p "${HOME}/.terminfo/r"
fi

install() {
    local dst=$1
    local src=$2
    test -e "${HOME}/${dst}" && mv "${HOME}/${dst}" "${BACKUP_DIR}/"
    test -r "${DIR}/${src}" && ln -s "${DOTFILES_DIR}/${src}" "${HOME}/${dst}"
}

install .profile profile
install .inputrc inputrc
install .bash_profile bash_profile
install .bashrc bashrc
install .zshrc zshrc
install .gitconfig gitconfig
install .hgrc hgrc
install .screenrc screenrc
install .tmux.conf tmux.conf
install .config/fish/config.fish config.fish

test -d "${HOME}/.terminfo/r" && install .terminfo/r/rxvt-256color terminfo/rxvt-256color

if [ "$1" = "x" ]; then
    install .xinitrc x/xinitrc
    install .XCompose x/XCompose
    install .Xdefaults x/Xdefaults
    install .Xdefaults.colors x/colors.zenburn
    install .gtkrc-2.0 x/gtkrc-2.0
    install .fonts.conf x/fonts.conf
    install .pentadactylrc x/pentadactylrc
fi

cd - >/dev/null
