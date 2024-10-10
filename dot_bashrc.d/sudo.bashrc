if which doas &> /dev/null; then
    has_completion doas || complete -c -o bashdefault -o default doas
    alias doas="doas "
    alias doasshell='doas -s env HOMEDIR=$HOME'
fi

if which sudo &> /dev/null; then
    has_completion sudo || complete -c -o bashdefault -o default sudo
    alias sudo="sudo "
    alias sudoshell='sudo -s BASH_ENV=$HOME/.bashrc bash'
fi