#!/usr/bin/env bash

iCloudDir=~/iCloud
iCloudCacheDir="$XDG_CACHE_HOME"/rclone/icloud
mkdir -p "$iCloudDir" "$iCloudCacheDir"
rclone mount \
    icloud: \
    "$iCloudDir" \
    --vfs-cache-mode full \
    --cache-dir "$iCloudCacheDir" \
    --vfs-cache-max-size 10G \
    --vfs-cache-max-age 24h \
    --dir-cache-time 5m \
    --allow-non-empty \
    --poll-interval 0
