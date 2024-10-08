# copy local env to remote host

has_completion ssh || complete -fW \
    "$({ grep -siE '^(host|hostname)' ~/.ssh/config | cut -d' ' -f2; cut -d' ' -f1 ~/.ssh/known_hosts 2> /dev/null; } | grep -v '\*' | sed 's/[][]//g' | sort | uniq)" \
        ssh ssh-copy-id scp sftp sshexit ssh-multi ssh-single ssh-x11

alias sshconfig &>/dev/null || alias sshconfig="vi ~/.ssh/config && resrc"
alias sshexit="ssh -O exit"
alias ssh-multi="ssh -M"
alias ssh-single="ssh -o ControlMaster=no"
alias ssh-x11="ssh -Y"

ssh-cp-env() {
    scp -r ~/.bashrc ~/.bash_profile ~/.bashrc.d ~/.screenrc ~/.inputrc ~/.vimrc ~/.tmux.conf ~/.bash_completion.d "$1":.
    ssh "$1" mkdir -p .vim/colors/ .ssh/
    scp -r ~/.vim/colors ~/.vim/autoload "$1":.vim/
}
clone_completion ssh ssh-cp-env

# delete record from known_hosts
ssh-del-knownhost() {
    if [ $# -eq 0 ]; then
        echo "nothing to delete from known_hosts"
        return 1
    else
        local h
        for h in "$@"; do
            echo "deleting '$h' from known_hosts"
            sed -ri '' "/^\[?$h(\ |\])/d" "$HOME/.ssh/known_hosts" 2>/dev/null || sed -i "/^\[?$h(\ |\])/d" "$HOME/.ssh/known_hosts" 2>/dev/null
        done
    fi
}
clone_completion ssh ssh-del-knownhost

# run shell script(s) over ssh
ssh-run() {
    local ssh_string="ssh"
    while [ $# -gt 0 ]; do
        case $1 in
            # multiple shell scripts without args
            --m)
                local m=yes
                ;;
            # one script with args
            --)
                shift
                break
                ;;
            *)
                ssh_string=${ssh_string:+$ssh_string $1}
                ;;
        esac
        shift
    done;
    echo "=== === ssh connection string: '$ssh_string'"

    case $1 in
        sudo|doas)
            local sudo="$1"
            echo "=== === using $1"
            shift
            ;;
    esac

    local script
    [ $# -eq 0 ] && { echo "=== === ERROR: no scripts to run. Usage: ssh-run.sh <ssh connection options> -- <path/to/script(s)>"; return 1; }
    if [ ! "$m" ]; then
        echo "=== === running '$*' on remote"
        script="$1"
        shift
        if [ -f "$script" ] && [ -x "$script" ]; then
            $ssh_string "$sudo /bin/sh -s" < "$script" $* || { echo "=== === ERROR: script execution failed "; return 1; }
        else
            echo "=== === can't find or not executable '$script'"
        fi
    else
        for script in $@; do
            if [ -f "$script" ] && [ -x "$script" ]; then
                echo "=== === running '$script' on remote"
                $ssh_string "$sudo /bin/sh -s" < "$script" || { echo "=== === ERROR: script execution failed "; return 1; }
            else
                echo "=== === can't find or not executable '$script'"
            fi
        done
    fi

    echo "=== === finished"
}
clone_completion ssh ssh-run