#!/bin/sh
if [ -f "$HOME/chezmoi.age" ]; then
    mkdir -p "$HOME/.config"
    mv -f "$HOME/chezmoi.age" "$HOME/.config/"
fi

