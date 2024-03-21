#!/bin/bash

echo "Saving chezmoi state..."
echo

chezmoi git -- diff --quiet 2>/dev/null || \
    chezmoi git add .


chezmoi git -- diff --cached --quiet 2>/dev/null || {
    echo "Changes:"
    chezmoi git -- status -s
    sleep 2.5
    echo
    chezmoi git -- commit -m "${*:-$(chezmoi git -- status -s)}" -m "$(hostname -s)"
}

chezmoi git -- pull --rebase && chezmoi git push
