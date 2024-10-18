if which doas &> /dev/null; then
    has_completion doas || complete -c -o bashdefault -o default doas
    alias doas="doas "
    alias doasshell='doas -s env HOME=$HOME TMUX=$TMUX SSH_TTY=$SSH_TTY'
fi

if which sudo &> /dev/null; then
    has_completion sudo || complete -c -o bashdefault -o default sudo
    alias sudo="sudo "
    alias sudoshell='sudo -s HOME=$HOME TMUX=$TMUX SSH_TTY=$SSH_TTY'
fi
