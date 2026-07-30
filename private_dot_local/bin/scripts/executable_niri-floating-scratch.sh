#!/usr/bin/env bash

set -euo pipefail

PARK_WORKSPACE='~'

usage() {
    echo "Usage: $(basename "$0") APP_ID -- COMMAND [ARG...]" >&2
    exit 2
}

[[ $# -ge 2 ]] || usage

app_id=$1
shift

[[ ${1:-} == -- ]] && shift
[[ $# -gt 0 ]] || usage

window=$(niri msg -j windows | jq -c --arg app_id "$app_id" '.[] | select(.app_id ==$app_id)')

if [[ -z $window ]]; then
    "$@" &
    exit 0
fi

window_id=$(jq -r '.id' <<< "$window")
is_focused=$(jq -r '.is_focused' <<< "$window")

if [[ $is_focused == true ]]; then
    niri msg action focus-window-previous || true

    niri msg action move-window-to-workspace \
        --window-id "$window_id" \
        --focus=false \
        "$PARK_WORKSPACE"

    niri msg action move-window-to-tiling --id "$window_id"
    exit 0
fi

current_ws=$(niri msg -j workspaces | jq '.[] | select(.is_focused == true)' | jq .idx)
niri msg action move-window-to-workspace \
    --window-id "$window_id" \
    --focus=false \
    "$current_ws"

niri msg action move-window-to-floating --id "$window_id"
niri msg action focus-window --id "$window_id"
