#!/bin/bash
set -e

sudo apk add ncurses

# to be run from iOS ish emulator
cp -rf "$HOME"/dotfiles/dot_bash_completion.d "$HOME"/.bash_completion.d
cp -rf "$HOME"/dotfiles/dot_bashrc.d "$HOME"/.bashrc.d
cp -f "$HOME"/dotfiles/dot_bash_profile "$HOME"/.bash_profile
cp -f "$HOME"/dotfiles/dot_bashrc "$HOME"/.bashrc
cp -f "$HOME"/dotfiles/dot_inputrc "$HOME"/.inputrc
cp -f "$HOME"/dotfiles/dot_tmux.conf "$HOME"/.tmux.conf

mkdir -p "$HOME"/.vim
cp -rf "$HOME"/dotfiles/dot_vim/* "$HOME"/.vim/
cp -f "$HOME"/dotfiles/dot_vimrc "$HOME"/.vimrc

mkdir -p "$HOME"/.ssh/mastersocket
age -d -i "$HOME"/.config/chezmoi.age "$HOME"/dotfiles/private_dot_ssh/encrypted_private_config.tmpl.age | sed "/^{{/d" >| "$HOME"/.ssh/config && chmod 600 "$HOME"/.ssh/config

source "$HOME"/.bashrc
echo
echo "env updated"