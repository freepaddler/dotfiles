# add function or variable to unset list
unset_add() {
   UNSET="$UNSET $*"
}
# should be called at the very end of bashrc
cleanup() {
    unset_add unset_add
    unset_add cleanup
    for u in $UNSET; do unset "$u"; done
}

### exit routines (when bash exits)
unset_add exit_add
exit_add() {
    EXIT="$EXIT $*"
}
_onExit() {
    for e in $EXIT; do $e; done
    [ -n "$BASH_EXEC_TIME" ] && rm -f "$BASH_EXEC_TIME" &>/dev/null
}
trap _onExit EXIT

# add path to the END
unset_add path_append
path_append() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH=${PATH:+$PATH:}$1 ;;
    esac
}
# add path to the BEGINNING
unset_add path_prepend
path_prepend() {
    # remove the existing entry if it exists
    PATH=$(echo ":$PATH:" | sed -e "s|:$1:|:|g" -e 's|^:||;s|:$||')
    PATH=$1${PATH:+:$PATH}
}

unset_add manpath_append
manpath_append() {
    case ":$MANPATH:" in
        *":$1:"*) ;;
        *) MANPATH=${MANPATH:+$MANPATH:}$1 ;;
    esac
}
unset_add manpath_prepend
manpath_prepend() {
    # remove the existing entry if it exists
    MANPATH=$(echo ":$MANPATH:" | sed -e "s|:$1:|:|g" -e 's|^:||;s|:$||')
    MANPATH=$1${MANPATH:+:$MANPATH}
}


# check os by kernel
kernel=$(uname -s); unset_add kernel
os_is() { [ "${kernel,,}" = "${1,,}" ]; }; unset_add os_is
# check if binary is busybox symlink
is_bb() { [[ "$(readlink "$(which "$1")")" = *"busybox" ]]; }; unset_add is_bb
# check if it is ish emulator
is_ish() { [[ "$(uname -r)" = *"-ish" ]]; }; unset_add is_ish

# system info
unset_add run_info
run_info() {
    local info="bash $BASH_VERSION @"
    if [ -f /ets/os-release ]; then
        source /etc/os-release
        info+=" $PRETTY_NAME"
    fi
    info+=" $(uname -smr)"
    echo "$info"
}

# temporary history control
hoff() { set +o history; }
hon() { set -o history; }

# generate passwords
apg() {
    echo
    local i=0
    while [ $i -lt 20 ]; do
        openssl rand -base64 $((((i / 5) + 2) * 3))
        i=$((i + 1))
    done
}

# random hex string
rand_x() {
    cat /dev/urandom | LC_CTYPE=POSIX tr -dc 'a-f0-9' | fold -w $1 | head -n 1
}

# short emacs-style help
hlp() {
    local b="\033[1m"
    local r="\033[0m"
    echo -ne "${b} SHELL Quick Help${r}
\t\t\t${b}MOVING${r}
${b}C-a / C-e${r} — start/end of line\t\t${b}C-f / C-b${r} — one char fwd/bwd
${b}M-f / M-b${r} — one word fwd/bwd\t\t${b}C-l${r} - cls & leave current line
${b}C-x C-x${r} - move to the start of line and back to current position
${b}M-<space>${r} - mark position to jump instead of start of the line
\t\t\t${b}CHANGE TEXT
${b}C-d / C-h${r} - delete/backspace\t\t${b}C-x C-u${r} - undo
${b}C-t / M-t${r} - change current character/word with previous one
${b}M-u / M-l /M-c${r} - upcase/downcase/capitalize word from current position
\t\t\t${b}KILL & YANK
${b}C-k / C-u${r} - kill to line end/start\t${b}C-y${r} - yank last killed text
${b}M-d / C-w${r} - delete from position to the end/start of word
\t\t\t${b}HISTORY
${b}M-.${r} - paste last arg\t\t\t${b}M-C-y${r} 1st arg of prev command
${b}PgUp / PgDn${r} - hist rev/fwd search\t${b}C-p / C-n${r} - prev/next command
${b}C-r${r} - incremental reverse search\t${b}C-j${r} - stop search and edit
\t\t\t${b}COMPLETIONS
${b}M-/ / M-\$ / M-!${r} - complete filename/variable/command
${b}M-TAB${r} - attempt complete with previous matches
\t\t\t${b}MISC
${b}M-#${r} - comment line\t\t\t${b}C-t${r} - send SIGINFO
${b}C-c / C-z / C-d${r} - SIGINT / SIGTSTP (suspend) / EOF - soft exit
${b}C-x C-e${r} - open $EDITOR to modify command, execute upon exit
\t\t\t${b}SPECIAL VARS
${b}\$?${r} - exit status of last command\t${b}%% / %n${r} - last/n job pid
${b}\$!${r} - last backgroud command pid\t\t${b}\$\$${r} - current shell pid
${b}!!${r} - previous command line\t\t${b}!:0${r} - name of prev command
${b}!:1 / !:-1 / !:*${r} - 1st(2nd..)/last/all params of prev command
"
    #${b}M-< / M->${r} - move to hist first/last line
    #${b}C-r / C-s${r} - incremental rev/fwd search
}
