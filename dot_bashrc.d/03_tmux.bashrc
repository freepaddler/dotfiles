if which tmux &>/dev/null; then

    # load tmux immediately
    if  [ -z "$NO_TMUX_ON_SOURCE" ] &&  # don't try to attach default session on reload bashrc
        [ -z "$TMUX" ] &&               # no tmux in tmux
        #[[ ! "$TERM" =~ tmux ]] &&     # try no tmux in tmux in ssh	
        ! is_ish &&                     # no tmux by default in ish
        [ -z "$SUDO_USER" ] && [ -z "$DOAS_USER" ]
    then
        # no TMUX session or TMUX session is attached
        if ! tmux has-session -t TMUX &>/dev/null ||
            tmux list-sessions -F '#{session_name}:#{session_attached}' | grep -q ^TMUX:0
        then
            tmux new-session -A -s TMUX && exit 0 
        else
            if [ -n "$SSH_CONNECTION" ]; then
                first_free=$(tmux ls | grep -vm1 attached | cut -d: -f1)
                if [ -n "$first_free" ]; then
                    tmux a -t "$first_free" && exit 0 
               # else
               #     tmux new-session && exit 0 
                fi
            fi
            echo TMUX session NOT is attached
        fi
        export NO_TMUX_ON_SOURCE=1
    fi

    alias tm="tmux new-session -A -s TMUX"
    alias tmn="tmux new-session"
    alias tml="tmux list-sessions"
    alias tma="tmux attach-session"

fi
set +x
