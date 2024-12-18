if which tmux &>/dev/null; then

    alias tml="tmux list-sessions"

    _tmux-session-selector() {
        t=1
        for arg in "$@"; do
            if [ "$arg" = "-A" ]; then
                t=2 # do not kill detached window
                break
            fi
        done
        tmux new-session "$@" \; set @t "$t" \; choose-tree -Zs \
    "run 'tmux set -u @t \; if -F \"#{m:=#S:*,%%}\" \"command-prompt -I \\\"#S\\\" \\\"rename-session %%\\\"\" \"switch-client -t %1; kill-session -t \\\"#S\\\"\"'"
    }


    _tmux-session-state() {
        if [ -z "$1" ] || ! tmux has-session -t="$1" &>/dev/null; then
            echo none;

        elif [ $(tmux list-clients -t="$1" 2>/dev/null | wc -l) -gt 0 ]; then
            echo attached
        else
            echo detached
        fi
    }

    tm() {
        sessions=$(tmux display -p '#{server_sessions}' 2>/dev/null || echo 0)
        session="TMUX"
        undef=
        [ -z "$1" ] && undef=1 || session="$1"
        state=$(_tmux-session-state "$session")

        if [ $sessions -eq 0 ]; then
            tmux new-session -s "$session"
        elif [ -n "$undef" ]; then
            if [ "$state" = "detached" ] && [ "$sessions" -eq 1 ]; then
                tmux attach-session -t="$session"
            elif [ "$state" = "detached" ]; then
                _tmux-session-selector -A -s "$session"
            elif [ "$state" = "none" ]; then
                _tmux-session-selector -s "$session"
            else
                _tmux-session-selector 
            fi
        else 
            if [ "$state" = "detached" ] || [ "$state" = "none" ]; then
                tmux new-session -A -s "$session"
            else
                echo "tmux default session is attached already (use 'tm' to manage)"
                tmux ls 2>/dev/null
                return 1
                #_tmux-session-selector 
            fi
        fi
    }

    # tmux auto-load
    if  [ -z "$NO_TMUX_AUTOLOAD" ] &&   # once loaded, don't retry on reload bashrc
        [ -z "$TMUX" ] &&               # no tmux in tmux
        ! is_ish &&                     # no tmux autoload in ish
        [ -z "$SUDO_USER" ] && [ -z "$DOAS_USER" ]
    then
        if [[ "$TERM" =~ (tmux|screen) ]]; then
            echo "terminal may be running screen or tmux (use 'tm' for tmux management)"
            tmux ls 2>/dev/null
        else
            tm TMUX && exit 0
        fi
    fi
    export NO_TMUX_AUTOLOAD=1

fi
set +x
