#!/usr/bin/env bash

oneDriveDir=~/oneDrive
oneDriveCacheDir="$XDG_CACHE_HOME"/rclone/onedrive
mkdir -p "$oneDriveDir" "$oneDriveCacheDir"
rclone mount \
    onedrive: \
    "$oneDriveDir" \
    --exclude '/Personal Vault/**' \
    --vfs-cache-mode full \
    --cache-dir "$oneDriveCacheDir" \
    --vfs-cache-max-size 10G \
    --vfs-cache-max-age 24h \
    --dir-cache-time 1h \
    --poll-interval 1m
