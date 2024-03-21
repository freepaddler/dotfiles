#!/bin/sh
set -e

echo "Backing up homebrew..."
echo

DEST="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Sync/Homebrew"
[ -d "$DEST" ] || mkdir -p "$DEST"
mkdir -p "$DEST/archive"

dmark=$(date +%Y-%m-%d_%H-%M-%S)
[ -f "$DEST/Brewfile" ] && mv -fv "$DEST/Brewfile" "$DEST/archive/Brewfile_$dmark"

HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --file="$DEST/Brewfile"

echo
echo "Homebrew dump complete"

