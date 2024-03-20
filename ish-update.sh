#!/bin/sh
# to be run from iOS ish emulator

cp -rf $HOME/dotfiles/dot_bash_completion.d $HOME/.bash_completion.d
cp -rf $HOME/dotfiles/dot_vim $HOME/.vim
mkdir -p $HOME/.ssh/mastersocket
cp -f $HOME/dotfiles/dot_bash_functions $HOME/.bash_functions
cp -f $HOME/dotfiles/dot_bash_profile $HOME/.bash_profile
cp -f $HOME/dotfiles/dot_bashrc $HOME/.bashrc
cp -f $HOME/dotfiles/dot_inputrc $HOME/.inputrc
cp -f $HOME/dotfiles/dot_tmux.conf $HOME/.tmux.conf
cp -f $HOME/dotfiles/dot_vimrc $HOME/.vimrc
age -d -i $HOME/.config/chezmoi.age $HOME/dotfiles/private_dot_ssh/encrypted_private_config.tmpl.age | sed "/^{{/d" >| $HOME/.ssh/config && chmod 600 $HOME/.ssh/config
