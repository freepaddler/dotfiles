#!/bin/sh

chezmoiDir="$HOME/.config/chezmoi"
mkdir -p "$chezmoiDir"

for dir in "$HOME" "$HOME/.config"; do
    [ -f "$dir/chezmoi.age" ] || continue
    echo "moving $dir/chezmoi.age to $chezmoiDir/"
    mv -f "$dir/chezmoi.age" "$chezmoiDir/"
done

exit 0
