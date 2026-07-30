#!/usr/bin/env bash

dir=~/Pictures/iCloudPhotos
mkdir -p "$dir"

rclone mount icloud: "$dir" \
    --iclouddrive-service photos \
    --vfs-refresh \
    --dir-cache-time 1h \
    --vfs-cache-mode full \
    --attr-timeout 1m \
    --read-only
