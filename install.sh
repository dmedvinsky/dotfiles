#!/bin/sh
cd `dirname $0` >/dev/null

H=$HOME
B=$HOME/.dotfiles.bak

bal() {
    mv $H/$1 $B/ 2>/dev/null
    ln -s $HOME/.dotfiles/$2 $H/$1 2>/dev/null
}

mkdir -p $B
mkdir -p $H/.terminfo/r

bal .profile profile
bal .inputrc inputrc
bal .bash_profile bash_profile
bal .bashrc bashrc
bal .zshrc zshrc
bal .gitconfig gitconfig
bal .hgrc hgrc
bal .screenrc screenrc
bal .tmux.conf tmux.conf
bal .ncmpcpp/config ncmpcpp.conf
bal .terminfo/r/rxvt-256color terminfo/rxvt-256color

bal .xinitrc x/xinitrc
bal .XCompose x/XCompose
bal .Xdefaults x/Xdefaults
bal .Xdefaults.colors x/colors.zenburn
bal .gtkrc-2.0 x/gtkrc-2.0
bal .fonts.conf x/fonts.conf

cd - >/dev/null
