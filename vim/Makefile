.PHONY: install

install:
	mkdir -p bundle
	test -d bundle/vundle || git clone https://github.com/gmarik/vundle.git bundle/vundle
	test -f ${HOME}/.vimrc  && mv ${HOME}/.vimrc  ${HOME}/.vimrc.bak  || true
	test -f ${HOME}/.gvimrc && mv ${HOME}/.gvimrc ${HOME}/.gvimrc.bak || true
	ln -s ${HOME}/.vim/vimrc  ${HOME}/.vimrc
	ln -s ${HOME}/.vim/gvimrc ${HOME}/.gvimrc
