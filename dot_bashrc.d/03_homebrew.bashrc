# homebrew setup

if [ -x /opt/homebrew/bin/brew ]; then
    path_append "/opt/homebrew/bin:/opt/homebrew/sbin"
    export HOMEBREW_PREFIX="/opt/homebrew"
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
    export HOMEBREW_REPOSITORY="/opt/homebrew"
    export INFOPATH=$INFOPATH:/opt/homebrew/share/info:
    export MANPATH=$MANPATH:/opt/homebrew/share/man
    export HOMEBREW_CASK_OPTS="--no-quarantine"
    alias brew_requested="brew leaves -r && echo && brew list --cask -1"
    brew-usage() {
        brew list --formula | xargs -n1 -P8 -I {} \
            sh -c "brew info {} | egrep '[0-9]* files, ' | sed 's/^.*[0-9]* files, \(.*\)).*$/{} \1/'" |
            sort -h -r -k2 - | column -t
    }
    brew-save() {
        set -e

        echo "Backing up homebrew..."
        echo

        DEST="$HOMEDIR/Library/Mobile Documents/com~apple~CloudDocs/Sync"
        [ -d "$DEST" ] || mkdir -p "$DEST"
        mkdir -p "$DEST/Homebrew.backup"

        dmark=$(date +%Y-%m-%d_%H-%M-%S)
        [ -f "$DEST/Brewfile" ] && mv -fv "$DEST/Brewfile" "$DEST/Homebrew.backup/Brewfile_$dmark"

        HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --file="$DEST/Brewfile"

        echo
        echo "Homebrew dump complete"
    }
fi