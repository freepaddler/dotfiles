# docker
if which docker &> /dev/null; then
    has_completion docker || complete -W "$(docker ps -a --format '{{.Names}}' 2>/dev/null; docker image ls --format '{{.Repository}}:{{.Tag}}' --filter "dangling=false" 2>/dev/null)" docker
    alias drm="docker run --rm"
    alias dps='docker ps --format "table {{.Names}}\\t{{.RunningFor}}\\t{{.Status}}\\t{{.Image}}"'
fi