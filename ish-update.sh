#!/bin/bash
set -e

sudo apk add ncurses

# to be run from iOS ish emulator
rm -rf "$HOME"/.bash_completion.d &> /dev/null
cp -rf "$HOME"/dotfiles/dot_bash_completion.d "$HOME"/.bash_completion.d

rm -rf "$HOME"/.bashrc.d &> /dev/null
cp -rf "$HOME"/dotfiles/dot_bashrc.d "$HOME"/.bashrc.d

rm -f "$HOME"/.bash_profile &> /dev/null
cp -f "$HOME"/dotfiles/dot_bash_profile "$HOME"/.bash_profile

rm -f "$HOME"/.bashrc &> /dev/null
cp -f "$HOME"/dotfiles/dot_bashrc "$HOME"/.bashrc

rm -f "$HOME"/.inputrc &> /dev/null
cp -f "$HOME"/dotfiles/dot_inputrc "$HOME"/.inputrc

rm -f "$HOME"/.tmux.conf &> /dev/null
cp -f "$HOME"/dotfiles/dot_tmux.conf "$HOME"/.tmux.conf

mkdir -p "$HOME"/.vim
cp -rf "$HOME"/dotfiles/dot_vim/* "$HOME"/.vim/
rm -f "$HOME"/.vimrc &> /dev/null
cp -f "$HOME"/dotfiles/dot_vimrc "$HOME"/.vimrc

mkdir -p "$HOME"/.ssh/mastersocket
rm -f "$HOME"/.ssh/config &> /dev/null
age -d -i "$HOME"/.config/chezmoi.age "$HOME"/dotfiles/private_dot_ssh/encrypted_private_config.tmpl.age | sed "/^{{/d" >| "$HOME"/.ssh/config && chmod 600 "$HOME"/.ssh/config

source "$HOME"/.bashrc
echo
echo "env updated"