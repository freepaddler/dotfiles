# The list of segments shown on the left. Fill it with the most important segments.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  # =========================[ Line #1 ]=========================
  os_icon                 # os identifier
  context                 # user@host
  dir                     # current directory
  vcs                     # git status
  # =========================[ Line #2 ]=========================
  newline                 # \n
  prompt_char             # prompt symbol
)

# The list of segments shown on the right. Fill it with less important segments.
# Right prompt on the last prompt line (where you are typing your commands) gets
# automatically hidden when the input line reaches it. Right prompt above the
# last prompt line gets hidden if it would overlap with left prompt.
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  # =========================[ Line #1 ]=========================
  status                  # exit code of the last command
  command_execution_time  # duration of the last command
  background_jobs         # presence of background jobs
  go_version              # go version (https://golang.org)
  yazi                    # yazi shell (https://github.com/sxyazi/yazi)
  vim_shell               # vim shell indicator (:sh)
  chezmoi_shell           # chezmoi shell (https://www.chezmoi.io/)
  docker_context
  # =========================[ Line #2 ]=========================
  newline
)

#################################[ os_icon: os identifier ]##################################
# OS identifier color.
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=7
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=0

##################################[ context: user@hostname ]##################################
# Context color when running with privileges.
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=9
typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=0
# Context color in SSH without privileges.
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=10
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_BACKGROUND=0
# Default context color (no privileges, no SSH).
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=10
typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=0
# Context format when running with privileges: user
typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%B%n%b'
# Context format when in SSH without privileges: user@hostname
typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%B%n%b%F{7}@%F{3}%m%f'
# Default context format (no privileges, no SSH): user
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%B%n%b'
# Don't show context unless running with privileges or in SSH.
unset POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION

##################################[ dir: current directory ]##################################
# Current directory background color.
typeset -g POWERLEVEL9K_DIR_BACKGROUND=0
# Default current directory foreground color.
typeset -g POWERLEVEL9K_DIR_FOREGROUND=6
# Color of the shortened directory segments.
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=4
# Color of the anchor directory segments. Anchor segments are never shortened. The first
# segment is always an anchor.
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=6

################################[ prompt_char: prompt symbol ]################################
# Green prompt symbol if the last command succeeded.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=10
# Red prompt symbol if the last command failed.
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=9

#####################################[ vcs: git status ]######################################
# Version control background colors.
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=0
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=0
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=0
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=0
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=0

# Branch icon. Set this parameter to '\UE0A0 ' for the popular Powerline branch icon.
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0'

function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
        # If P9K_CONTENT is not empty, use it. It's either "loading" or from vcs_info (not from
        # gitstatus plugin). VCS_STATUS_* parameters are not available in this case.
        typeset -g my_git_format=$P9K_CONTENT
        return
    fi

    if (( $1 )); then
        # Styling for up-to-date Git status.
        local       meta='%7F'  # white
        local       info='%5F'  # magenta
        local      clean='%2F'  # green
        local   modified='%3F'  # yellow
        local  untracked='%4F'  # blue
        local conflicted='%1F'  # red
    else
        # Styling for incomplete and stale Git status.
        local       meta='%8F'  # grey foreground
        local       info='%8F'  # grey foreground
        local      clean='%8F'  # grey foreground
        local   modified='%8F'  # grey foreground
        local  untracked='%8F'  # grey foreground
        local conflicted='%8F'  # grey foreground
    fi

    local res

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
        local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
        # If local branch name is at most 32 characters long, show it in full.
        # Otherwise show the first 12 … the last 12.
        # Tip: To always show local branch name in full without truncation, delete the next line.
        (( $#branch > 32 )) && branch[13,-13]="…"  # <-- this line
        res+="${info}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_TAG
        # Show tag only if not on a branch.
        # Tip: To always show tag, delete the next line.
        && -z $VCS_STATUS_LOCAL_BRANCH  # <-- this line
        ]]; then
        local tag=${(V)VCS_STATUS_TAG}
        # If tag name is at most 32 characters long, show it in full.
        # Otherwise show the first 12 … the last 12.
        # Tip: To always show tag name in full without truncation, delete the next line.
        (( $#tag > 32 )) && tag[13,-13]="…"  # <-- this line
        res+="${meta}#${info}${tag//\%/%%}"
    fi

    # Display the current Git commit if there is no branch and no tag.
    # Tip: To always display the current Git commit, delete the next line.
    [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&  # <-- this line
        res+="${meta}@${info}${VCS_STATUS_COMMIT[1,8]}"

        # Show tracking branch name if it differs from local branch.
        if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
            res+="${meta}:${info}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
        fi

        # Display "wip" if the latest commit's summary contains "wip" or "WIP".
        if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
            res+=" ${modified}wip"
        fi

        if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
            # ⇣42 if behind the remote.
            (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${conflict}⇣${VCS_STATUS_COMMITS_BEHIND}"
            # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
            (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
            (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
        elif [[ -n $VCS_STATUS_REMOTE_BRANCH ]]; then
            # Tip: Uncomment the next line to display '=' if up to date with the remote.
            # res+=" ${clean}="
        fi

        # ⇠42 if behind the push remote.
        (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clonflict}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
        (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
        # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
        (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
        # *42 if have stashes.
        (( VCS_STATUS_STASHES        )) && res+=" ${info}*${VCS_STATUS_STASHES}"
        # 'merge' if the repo is in an unusual state.
        [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
        # ~42 if have merge conflicts.
        (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
        # +42 if have staged changes.
        (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
        # !42 if have unstaged changes.
        (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
        # ?42 if have untracked files. It's really a question mark, your font isn't broken.
        # See POWERLEVEL9K_VCS_UNTRACKED_ICON above if you want to use a different icon.
        # Remove the next line if you don't want to see untracked files at all.
        (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
        # "─" if the number of unstaged files is unknown. This can happen due to
        # POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY (see below) being set to a non-negative number lower
        # than the number of files in the Git index, or due to bash.showDirtyState being set to false
        # in the repository config. The number of staged and untracked files may also be unknown
        # in this case.
        (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

        typeset -g my_git_format=$res
    }
  functions -M my_git_formatter 2>/dev/null
#########################[ status: exit code of the last command ]###########################
typeset -g POWERLEVEL9K_STATUS_ERROR=true
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=0
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=1
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=0
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=1
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=0

###################[ command_execution_time: duration of the last command ]###################
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=7
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=0
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1

#######################[ background_jobs: presence of background jobs ]#######################
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=5
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=0
# Don't show the number of background jobs.
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false

####################[ yazi: yazi shell (https://github.com/sxyazi/yazi) ]#####################
typeset -g POWERLEVEL9K_YAZI_FOREGROUND=3
typeset -g POWERLEVEL9K_YAZI_BACKGROUND=0
#######################[ go_version: go version (https://golang.org) ]########################
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=6
typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=0
###########################[ vim_shell: vim shell indicator (:sh) ]###########################
typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=2
typeset -g POWERLEVEL9K_VIM_SHELL_BACKGROUND=0
##################[ chezmoi_shell: chezmoi shell (https://www.chezmoi.io/) ]##################
typeset -g POWERLEVEL9K_CHEZMOI_SHELL_FOREGROUND=2
typeset -g POWERLEVEL9K_CHEZMOI_SHELL_BACKGROUND=0

#######################[ docker_context: shows not default docker context ]###################
function prompt_docker_context() {
  emulate -L zsh

  # 1) Hide if docker command is missing
  (( $+commands[docker] )) || return

  # 2) Read config JSON if present
  local cfg=$HOME/.docker/config.json
  [[ -r $cfg ]] || return
  local json; json=$(<"$cfg")

  # 3) Extract currentContext (simple JSON parse)
  #    Matches: "currentContext" : "value"
  local ctx
  if [[ $json =~ '"currentContext"[[:space:]]*:[[:space:]]*"([^"]*)"' ]]; then
    ctx=${match[1]}
  else
    return
  fi

  # 4) Hide when empty or "default"
  [[ -z $ctx || $ctx == default ]] && return

  # 5) Render segment (tweak colors/icons as you like)
  p10k segment -i '🐳' -t "$ctx" -f 4 -b 0
}
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_FOREGROUND=4
typeset -g POWERLEVEL9K_DOCKER_CONTEXT_BACKGROUND=0

