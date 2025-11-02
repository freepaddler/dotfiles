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
    kubecontext             # current kubernetes context (https://kubernetes.io/)
    terraform               # terraform workspace (https://www.terraform.io)
    terraform_version       # terraform version (https://www.terraform.io)
    aws                     # aws profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
    aws_eb_env              # aws elastic beanstalk environment (https://aws.amazon.com/elasticbeanstalk/)
    azure                   # azure account name (https://docs.microsoft.com/en-us/cli/azure)
    gcloud                  # google cloud cli account and project (https://cloud.google.com/)
    google_app_cred         # google application credentials (https://cloud.google.com/docs/authentication/production)
    toolbox                 # toolbox name (https://github.com/containers/toolbox)
#    context                 # user@hostname
    yazi                    # yazi shell (https://github.com/sxyazi/yazi)
    vim_shell               # vim shell indicator (:sh)
    midnight_commander      # midnight commander shell (https://midnight-commander.org/)
    chezmoi_shell           # chezmoi shell (https://www.chezmoi.io/)
    # =========================[ Line #2 ]=========================
    newline
  )


#################################[ os_icon: os identifier ]##################################
# OS identifier color.
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=7
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=0

################################[ prompt_char: prompt symbol ]################################
# Green prompt symbol if the last command succeeded.
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=10
# Red prompt symbol if the last command failed.
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=9

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

#####################################[ vcs: git status ]######################################
# Version control background colors.
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=4
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=4
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=4
typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=4
typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=4

# Branch icon. Set this parameter to '\UE0A0 ' for the popular Powerline branch icon.
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\UE0A0'

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

#######################[ go_version: go version (https://golang.org) ]########################
# Go version color.
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=6
typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=0
