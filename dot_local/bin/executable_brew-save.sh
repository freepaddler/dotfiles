#!/bin/sh
set -e

echo "Backing up homebrew..."
echo

DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Sync"
[ -d "$DEST" ] || mkdir -p "$DEST"
mkdir -p "$DEST/Homebrew.backup"

dmark=$(date +%Y-%m-%d_%H-%M-%S)
[ -f "$DEST/Brewfile" ] && mv -fv "$DEST/Brewfile" "$DEST/Homebrew.backup/Brewfile_$dmark"

HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --file="$DEST/Brewfile"

echo
echo "Homebrew dump complete"

