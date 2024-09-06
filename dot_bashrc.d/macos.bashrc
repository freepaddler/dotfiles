if os_is darwin; then

    export COPYFILE_DISABLE=true

    # remove macOS zsh warning
    export BASH_SILENCE_DEPRECATION_WARNING=1

    # python path
    # shellcheck disable=SC2045
    for ver in $(ls -r ~/Library/Python/); do
        path_append ~/Library/Python/"$ver"/bin
    done
    unset ver

    # custom completions
    if [ -n "$BASH_COMPLETION_VERSINFO" ]; then
        custom_completions+="
           /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
           /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion
           /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion
           /opt/vagrant/embedded/gems/gems/vagrant-*/contrib/bash/completion.sh
        "
        for f in $custom_completions; do
            # shellcheck disable=SC1090
            [ -f "$f" ] && source "$f"
        done
        unset f
    fi

    # ssh-keygen override
    complete -f ssh-keygen

    alias plu="plutil -p"

    # logout other macos user
    logout_force() {
        sudo launchctl bootout "user/$(id -u "$1")"
    }

    # iina video player reset cache if hangs in network connection
    iina_reset_cache() {
        defaults delete com.colliderli.iina recentDocuments
    }

    # call vnc from terminal
    vnc() {
        if [ $# -lt 1 ]; then
            open vnc://localhost:5900
        elif [[ $1 =~ ^[0-9]+$ ]]; then
            open vnc://localhost:$1
        else
            open vnc://$1
        fi
    }
fi