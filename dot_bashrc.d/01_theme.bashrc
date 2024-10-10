# bash visual look

# colors
_c() {
    case "$1" in
        green_b) printf  '\033[1;32m';;
        red_b) printf    '\033[1;31m';;
        red) printf      '\033[0;31m';;
        cyan) printf     '\033[0;36m';;
        yellow) printf   '\033[0;33m';;
        yellow_b) printf '\033[1;33m';;
        white_b) printf  '\033[1;1m';;
        user) [ $(id -u) -eq 0 ] && _c red_b || _c green_b;;
        *) printf '\033[0m';; # reset color
    esac
}
_cw() { printf "\[$(_c $1)\]"; }


if [ "$TERM_PROGRAM" = "tmux" ]; then
    # tmux shows hostname in status line
    host=""
elif [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    # show hostname in remote session
    host="$(_cw)@$(_cw yellow)\H$(_cw)"
else
    # don't show hostname in local session
    host=""
fi

export PS0=
export PS1="\n$(_cw user)\u$host $(_cw cyan)\w\n$(_cw user)❯ $(_cw)"
#export PS1="\n\[\$([ \$(id -u) -eq 0 ] && printf '$( _cw red )'|| printf '$( _cw green_b )')\]\u$host $(_cw cyan)\w\n\[\$([ \$(id -u) -eq 0 ] && printf '$( _cw red )'|| printf '$( _cw green_b )')\]❯ $(_c)"
export PS2="$(_cw yellow_b)-> $(_cw)"

unset host

set_window_title() {
    printf "\033]2;%s\007" "$1"
}

if [ "$TERM_PROGRAM" == "Apple_Terminal" ]; then
    PROMPT_COMMAND="set_window_title${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
else
    PROMPT_COMMAND='printf "\033]0;%s@%s %s\007" "$USER" "$HOSTNAME" "${PWD/$HOME/"~"}"'
fi

# show last command exit code and execution time
BASH_EXEC_TIME="${TMPDIR:-/tmp}/$USER-$BASHPID.td"
BEC=1
_getstarttime() {
    [ -n $BASH_EXEC_TIME ] &&  date +%s >| "$BASH_EXEC_TIME"
}

_printexectime() {
	if [ -n "$BASH_EXEC_TIME" ] && [ -e "$BASH_EXEC_TIME" ]; then
		local diff_ts=$(($(cat "$BASH_EXEC_TIME") - $(date +%s)))
        [ $diff_ts -eq 0 ] && return 0
		((diff_ts < 0)) && diff_ts=$(( -diff_ts ))
		local hours=$(( diff_ts / 3600 ))
		local minutes=$(( (diff_ts % 3600) / 60 ))
		local seconds=$(( diff_ts % 60 ))
		if ((hours > 0)); then
			printf "%dh%dm%ds\n" "$hours" "$minutes" "$seconds"
		elif ((minutes > 10)); then
			printf "%dm%ds\n" "$minutes" "$seconds"
		elif ((minutes > 0)); then
			printf "%dm%ds\n" "$minutes" "$seconds"
		else
			printf "%ds\n" "$seconds"
		fi
	fi
}

_printexitcode() {
    local e="($?)"
    if [ $BEC -eq 0 ]; then
        local t="$(_printexectime)"
        tput sc
        local o=11
        if [ $e = "(0)" ]; then
            printf "%*s" $COLUMNS "${t:+done in $t}"
        else
            e=${e:+$(_c red)failed$e$(_c)}
            printf "%*s" $((COLUMNS+11)) "${e}${t:+ in $t}"
        fi
        tput rc
    fi
    BEC=1
}

# shellcheck disable=SC2016
PS0='$(_getstarttime)\[${BEC:0:${BASH_COMMAND:+$((BEC=0))}}\]'
PROMPT_COMMAND="_printexitcode; $PROMPT_COMMAND"

exit_add _rm_BASH_BASH_EXEC_TIME
_rm_BASH_BASH_EXEC_TIME() {
     [ -n "$BASH_EXEC_TIME" ] && rm -f "$BASH_EXEC_TIME" &>/dev/null
}
