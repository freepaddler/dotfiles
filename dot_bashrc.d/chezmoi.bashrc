if which chezmoi &>/dev/null; then
    alias cz="chezmoi "
    alias czu="chezmoi update"
    alias czs="chezmoi status"
    if [ "$(chezmoi execute-template '{{ .chezmoi.config.data.private }}' 2>/dev/null)" = "true" ]; then
        alias czs="chezmoi status; cz git -- status -s"
        alias cze="chezmoi edit --apply"
        #alias bashrc="cze ~/.bashrc && resrc"
        alias vimrc="cze ~/.vimrc"
        alias sshconfig="cze ~/.ssh/config && resrc"
    fi

    # remote local install chezmoi
    cz-ssh() {
        ssh "$@" 'sh <(curl -fsLS get.chezmoi.io/lb || wget -qO- get.chezmoi.io/lb) -- init --purge --force --apply freepaddler'
    }
    clone_completion ssh cz-ssh

    # chezmoi save all changes
    cz-save() {
        echo "Saving chezmoi changes to git..."
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

        echo
        echo "Chezmoi saved to git"
    }
fi
