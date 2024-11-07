if which doas &> /dev/null; then
    has_completion doas || complete -c -o bashdefault -o default doas
    alias doas="doas "
    if ! which sudo &> /dev/null; then
        alias sudo="doas "
    fi
fi

if which sudo &> /dev/null; then
    has_completion sudo || complete -c -o bashdefault -o default sudo

    # to be sure that this is not doas-sudo-shim
    if sudo --version &> /dev/null; then
	    unalias sudo &> /dev/null
        unset -f sudo &> /dev/null

        # sudo wrapper
	    # add -E to all sudo calls without -i, -u
	    # and set $HOME+ vars to -s calls
        sudo() {
			local args=()

			for arg in "$@"; do
				case "$arg" in
					-i|--login|-u|--user|-l|--list|-K|-k|-v|-h|--help|-V|--version)
						args=("$@")
                        local as_is=1
						break 
						;;
					-s|--shell)
						args+=("$arg")
						local is_shell=1
						;;
					*)
						args+=("$arg")
						;;
				esac
			done

			if [ -z "$as_is" ]; then
				if [ -n "$is_shell" ]; then
					args=("HOME=$HOME" "TMUX=$TMUX" "SSH_TTY=$SSH_TTY" "${args[@]}") 
				fi
				args=("-E" "${args[@]}")
			fi

			set -- "${args[@]}"
            # echo sudo "$@"
			command sudo "$@"
		}
	fi
	alias sudo="sudo "
fi
