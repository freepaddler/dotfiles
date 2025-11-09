#!/bin/sh
XDG_DATA_HOME=${XDG_DATA_HOME-:~/.local/share}
vimDir="$XDG_DATA_HOME/vim"
mkdir -m 4700 -p "$vimDir/undo"

# viminfo
for f in "$HOME/.vim/viminfo" "$HOME/.viminfo" "$HOME/.local/vim/viminfo"; do
    [ -f "$f" ] || continue
    if [ -f "$vimDir/viminfo" ]; then
        rm -f "$f"
    else
        mv "$f" "$vimDir/viminfo"
    fi
done

# vim undo
for d in "$HOME/.vim/undo" "$HOME/.local/vim/undo"; do
    [ -d "$d" ] || continue

    for src in "$d"/*; do
        fName=$(basename "$src")
        dst="$vimDir/undo/$fName"

        if [ ! -e "$dst" ] || [ "$src" -nt "$dst" ]; then
            mv -- "$src" "$dst"
        fi
    done
done

rm -rf "$HOME/.vim" "$HOME/.local/vim"
