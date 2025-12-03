## fzf-tab

# SHIFT-TAB to switch fzf-tab and compsys
typeset -g fzf_tab_enabled=1
fzf-tab-toggle() {
    if (( fzf_tab_enabled )); then
        fzf_tab_enabled=0
        # restore default format
        zstyle ':completion:*:descriptions' format '%F{8}↳ %d %f'
    else
        fzf_tab_enabled=1
        zstyle ':completion:*:descriptions' format '<%d>'
    fi
    zle toggle-fzf-tab
}
zle -N fzf-tab-toggle
bindkey '^[[Z' fzf-tab-toggle

# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '<%d>'
# make fzf-tab follow FZF_DEFAULT_OPTS.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# custom opts
zstyle ':fzf-tab:*' fzf-flags --info=inline
# pop-up in tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# < and > to switch comletion groups
zstyle ':fzf-tab:*' switch-group '<' '>'
