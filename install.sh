#!/usr/bin/env bash
DIR=$(dirname $0)
BACKUP_DIR="${DIR}/backup"
DOTFILES_DIR=$(cd "${DIR}"; pwd)

cd "${DIR}" || exit 1
mkdir -p "${BACKUP_DIR}"
mkdir -p "${HOME}/.config"

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
(cd ${DOTFILES_DIR}/vim && make)
install .vim vim

if test -f "/usr/share/terminfo/r/rxvt-256color"; then :
else
    mkdir -p "${HOME}/.terminfo/r"
    install .terminfo/r/rxvt-256color terminfo/rxvt-256color
fi

cd $OLDPWD
