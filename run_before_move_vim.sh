#!/bin/sh

vim_dir="$HOME/.local/vim"
pkdir -m 4700 -p "$vim_dir"

# viminfo
for f in "$HOME/vim/viminfo" "$HOME/.viminfo"; do
    if [ -f "$vim_dir/viminfo" ]; then
        rm "$f"
    else
        mv "$f" "$vim_dir/viminfo"
    fi
done

# vim dirs
if [ -d "$HOME/.vim" ]; then
    for d in swap undo backup; do
        if [ -d "$HOME/.vim/$d" ] && [ ! -d "$vim_dir/$d" ]; then
            mv "$HOME/.vim/$d" "$vim_dir/"
        fi
    done
    rm -rf "$HOME/.vim"
fi



