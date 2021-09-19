#!/bin/bash

set -e

# Takes 2 arguments:
# 1. The filepath of the donor file.
# 2. The filepath of the recipient file.
# Checks if the first line of the donor file exists in the recipient file.
# If not, appends the entirety of the donor file to the recipient file.
conditional_append() {
	if [[ ! -f "$2" ]]; then
		cat "$1" > "$2"
	elif ! (cat "$2" | grep -qxF "$(head -n1 $1)"); then
		echo >> "$2"
		cat "$1" >> "$2"
	fi
}

install_bash() {
	# Create the bashrc.d directory and populate it.
	mkdir -p ~/.bashrc.d
	cp home/bashrc.d/* ~/.bashrc.d/

	# Add the liens to bashrc that will include the bashrc.d files.
	conditional_append loaders/bashrc ~/.bashrc
}

install_vim() {
	# Create the vimrc.d directory and populate it.
	mkdir -p ~/.vimrc.d
	cp home/vimrc.d/* ~/.vimrc.d/

	# Add the lines to vimrc that will include the vimrc.d files.
	conditional_append loaders/vimrc ~/.vimrc

	# Get vim-plug and put it where it needs to be.
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
		https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# Install the specified plugins.
	vim +PlugInstall +qall
}

install_tmux() {
	# Create the tmux.conf.d directory and populate it.
	mkdir -p ~/.tmux.conf.d
	cp home/tmux.conf.d/* ~/.tmux.conf.d/

	# Add the lines to tmux.conf that will include the tmux.conf.d files.
	conditional_append loaders/tmux.conf ~/.tmux.conf
}

install_input() {
	# Create the inputrc.d directory and populate it.
	mkdir -p ~/.inputrc.d
	cp home/inputrc.d/* ~/.inputrc.d

	# Add the lines to inputrc that will include the inputrc.d files.
	conditional_append loaders/inputrc ~/.inputrc
}

# MAIN
install_bash
install_vim
install_tmux
install_input
