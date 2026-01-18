## pure
#autoload -U promptinit; promptinit

PURE_CMD_MAX_EXEC_TIME=1
VIRTUAL_ENV_DISABLE_PROMPT=1

## nord term colors
#zstyle :prompt:pure:user        color 10            # bright-green
#zstyle :prompt:pure:user:root   color 9             # bright-red
#zstyle :prompt:pure:host        color yellow
#zstyle :prompt:pure:path        color cyan
#
#zstyle :prompt:pure:suspended_jobs      color yellow
#zstyle :prompt:pure:prompt:error        color 9     # bright-red
#zstyle :prompt:pure:prompt:success      color green
#zstyle :prompt:pure:prompt:continuation color 8     # bright-black
#
#zstyle :prompt:pure:git:branch  color magenta
#zstyle :prompt:pure:git:dirty   color yellow
#zstyle :prompt:pure:git:stash   show yes
#zstyle :prompt:pure:git:stash   color 12            # bright-blue
#zstyle :prompt:pure:git:arrow   color 12            # bright-blue

# catppuccin term colors
zstyle :prompt:pure:user        color green         # bright-green
zstyle :prompt:pure:user:root   color red           # bright-red
zstyle :prompt:pure:host        color yellow

zstyle :prompt:pure:suspended_jobs      color yellow
zstyle :prompt:pure:prompt:error        color 9     # bright-red
zstyle :prompt:pure:prompt:success      color 10    # bright-green
zstyle :prompt:pure:prompt:continuation color 8     # bright-black

zstyle :prompt:pure:git:branch  color 13            # bright-magenta
zstyle :prompt:pure:git:dirty   color yellow
zstyle :prompt:pure:git:stash   show yes

#prompt pure

## right prompt segments
typeset -ga RPROMPT_SEGMENTS
RPROMPT_SEGMENTS=(
    _docker_context_prompt
)

function _docker_context_prompt() {
    local cfg="$HOME/.docker/config.json"
    local ctx="default"

    # Load context from config.json if it exists
    if [[ -f "$cfg" ]]; then
        # Extract JSON field without jq (portable & fast)
        ctx=$(grep -o '"currentContext"[[:space:]]*:[[:space:]]*"[^"]*"' "$cfg" \
              | sed 's/.*"currentContext"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
        [[ -z "$ctx" ]] && ctx="default"
    fi

    # Return empty if default
    [[ "$ctx" == "default" ]] && return 0

    # Non-default context segment (you can change colors/icon here)
    print -r -- "%F{blue}🐳 $ctx%f"
}


# right prompt builder
_update_rprompt() {
    local segments=()
    local fn seg

    for fn in "${RPROMPT_SEGMENTS[@]}"; do
        seg="$("$fn")"
        [[ -n "$seg" ]] && segments+=("$seg")
    done

    # No segments → empty RPROMPT
    if (( ${#segments[@]} == 0 )); then
        RPROMPT=''
        return
    fi

    local sep=" %F{8}|%f "
    local out="${segments[1]}"
    local i

    # Manually join with separator
    for (( i = 2; i <= ${#segments[@]}; i++ )); do
        out+="$sep${segments[i]}"
    done

    RPROMPT="$out"
}

# Hook into precmd so it updates before each prompt redraw
autoload -Uz add-zsh-hook
add-zsh-hook precmd _update_rprompt
