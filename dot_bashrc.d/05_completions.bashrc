### AUTOCOMPLETION
# try load completions
completion_script_locations="
    /usr/local/share/bash-completion
    ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/etc/profile.d}
    /opt/local/etc/profile.d
"
for bcsh in $completion_script_locations; do
        [ -n "$BASH_COMPLETION_VERSINFO" ] && break
        [ -f "$bcsh/bash_completion.sh" ] && source "$bcsh/bash_completion.sh"
done
unset bsch
unset completion_script_locations
# load personal completions
if [ -n "$BASH_COMPLETION_VERSINFO" ]; then
    for f in "$HOMEDIR"/.bash_completion.d/*; do
        # shellcheck disable=SC1090
        [ -f "$f" ] && source "$f"
    done
    unset f
fi

# check if command has completion
unset_add has_completion
has_completion() {
    # completion exists
    complete -p "$1" &> /dev/null && return 0
    # no loader -> no completion
    [ "$(type -t _completion_loader)" = "function" ] || return 1
    # try load completion
    _completion_loader "$1"
    # _minimal default to no completion
    [[ $(complete -p "$1" 2> /dev/null) = *_minimal* ]] || return 0
    # delete _minimal completion -> no completion
    complete -r "$1"
    return 1
}

# clone current completion
unset_add clone_completion
clone_completion() {
    if has_completion $1; then
        complete -r $2 &>/dev/null
        $(complete -p $1) "$2"
    fi
}

# if no bash-completion, let's make out life a little bit easier
has_completion man || complete -cf man
has_completion nohup || complete -c -o bashdefault -o default nohup
has_completion su || complete -c -o bashdefault -o default su