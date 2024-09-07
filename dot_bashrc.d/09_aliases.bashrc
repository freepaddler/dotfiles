### ALIASES
#alias bashrc="vi ~/.bashrc && resrc"
alias root="su -m root"
alias hosts="vi /etc/hosts"

alias ls="ls -G"
os_is linux && alias ls="ls --color=auto"
alias l="ls -F"
alias la="ls -aF"
alias ll="ls -lhF"
alias lla="ls -alhF"
alias lll="ls -alhFi"
os_is freebsd && alias llll="ls -alhFio"
os_is darwin && alias llll="ls -alhFiOe@";

alias rm="rm -iv"
alias rmrf="rm -frv"
alias cp="cp -iv"
alias cpr="cp -iRv"
alias mv="mv -iv"

alias du="du -h"
alias df="df -h"

alias j="jobs -l"
alias h="history 25"
alias p="ps uw"
os_is linux && alias p="ps fuw"
is_bb ps && alias p="ps -o user,pid,ppid,vsz,rss,tty,stat,time,args"

alias t="top"
which htop &> /dev/null && alias t="htop"

alias grep="grep --color"
which igrep &> /dev/null || alias igrep="grep -i"
alias fgrep="fgrep --color"
alias egrep="egrep --color"

which screen &> /dev/null && alias sc="screen -U"
which vim &> /dev/null && {
    alias vi="vim -X"
    export VISUAL="vim -X"
}
alias vimrc="vi ~/.vimrc"

# iptables
if which iptables &> /dev/null; then
    alias iptl="iptables --line-numbers -vnL "
    alias ipt="iptables "
fi

if which doas &> /dev/null; then
    has_completion doas || complete -c -o bashdefault -o default doas
    alias doas="doas "
fi

if which sudo &> /dev/null; then
    has_completion sudo || complete -c -o bashdefault -o default sudo
    alias sudo="sudo "
fi

# glow (markdown in terminal)
which glow &> /dev/null && alias mdless="glow -p"

# vagrant
which vagrant &>/dev/null && alias vagrant-gui="GUI=1 vagrant "
