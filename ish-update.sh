#!/bin/bash
set -e

# to be run from iOS ish emulator

echo "add packages"
sudo apk add rtorrent

echo "dotfiles"
rm -rf "$HOME"/.config/dotfiles &> /dev/null
mkdir -p "$HOME"/.config
for d in profile bash shell vim; do
    cp -rf "$HOME/dotfiles/dot_config/$d" "$HOME/.config/"
done

echo "profile"
rm -f "$HOME"/.profile &> /dev/null
cp -f "$HOME"/dotfiles/dot_profile "$HOME"/.profile
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
echo "vimrc"
rm -f  "$HOME"/.vimrc &> /dev/null
ln -sf "$HOME/.config/vim/vimrc" "$HOME"/.vimrc

echo "ssh"
mkdir -p "$HOME"/.ssh/mastersocket
rm -f "$HOME"/.ssh/config &> /dev/null
age -d -i "$HOME"/.config/chezmoi.age "$HOME"/dotfiles/private_dot_ssh/encrypted_private_config.tmpl.age | sed "/^{{/d" >| "$HOME"/.ssh/config && chmod 600 "$HOME"/.ssh/config

echo "sourcing profile"
. "$HOME/.profile"

echo
echo "env updated"

set +x