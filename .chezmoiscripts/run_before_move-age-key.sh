#!/bin/sh

chezmoiDir="$HOME/.config/chezmoi"
mkdir -p "$chezmoiDir"

for dir in "$HOME" "$HOME/.config"; do
    [ -f "$dir/chezmoi.age" ] && mv -f "$dir/chezmoi.age" "$chezmoiDir/"
done

exit 0
