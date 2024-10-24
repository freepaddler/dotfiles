#!/bin/bash
set -e

# to be run from iOS ish emulator

echo "add packages"
sudo apk add ncurses

echo "mounts"

echo "bash_completion"
rm -rf "$HOME"/.bash_completion.d &> /dev/null
cp -rf "$HOME"/dotfiles/dot_bash_completion.d "$HOME"/.bash_completion.d
echo "bashrc.d"
rm -rf "$HOME"/.bashrc.d &> /dev/null
cp -rf "$HOME"/dotfiles/dot_bashrc.d "$HOME"/.bashrc.d
echo "bash_profile"
rm -f "$HOME"/.bash_profile &> /dev/null
cp -f "$HOME"/dotfiles/dot_bash_profile "$HOME"/.bash_profile
echo "bashrc"
rm -f "$HOME"/.bashrc &> /dev/null
cp -f "$HOME"/dotfiles/dot_bashrc "$HOME"/.bashrc
echo "inputrc"
rm -f "$HOME"/.inputrc &> /dev/null
cp -f "$HOME"/dotfiles/dot_inputrc "$HOME"/.inputrc
echo "tmux.conf"
rm -f "$HOME"/.tmux.conf &> /dev/null
cp -f "$HOME"/dotfiles/dot_tmux.conf "$HOME"/.tmux.conf

echo "vim"
mkdir -p "$HOME"/.vim
cp -rf "$HOME"/dotfiles/dot_vim/* "$HOME"/.vim/
rm -f "$HOME"/.vimrc &> /dev/null
cp -f "$HOME"/dotfiles/dot_vimrc "$HOME"/.vimrc

echo "ssh"
mkdir -p "$HOME"/.ssh/mastersocket
rm -f "$HOME"/.ssh/config &> /dev/null
age -d -i "$HOME"/.config/chezmoi.age "$HOME"/dotfiles/private_dot_ssh/encrypted_private_config.tmpl.age | sed "/^{{/d" >| "$HOME"/.ssh/config && chmod 600 "$HOME"/.ssh/config

source "$HOME"/.bashrc
echo
echo "env updated"