# git
if which git &> /dev/null; then
    alias gs="git status"
    alias ga="git add ."
    alias gco="git checkout"
    alias gcm="git commit -m"
    alias gcma="git commit -a -m"
    alias gi="git remote show origin"
    alias gl="git log --all --decorate --oneline --graph --date-order"
    alias glb="git log --oneline --decorate --walk-reflogs"
    alias gb="git branch -vv"
    alias gf="git fetch --tags --prune"
    alias gp="git push"
    alias gu="git pull"
    gh() { alias | grep git; }
fi
