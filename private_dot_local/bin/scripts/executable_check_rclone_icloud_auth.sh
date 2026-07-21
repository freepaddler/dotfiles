#!/usr/bin/env bash

if rclone lsd icloud: > /dev/null 2>&1; then
    icon='🟢'
    text='👌 iCloud connection ok'
else
    icon='🟥'
    text=$(printf '%s\n%s\n%s' "⚠️ iCloud connection failed! Run:" "rclone-icloud config reconnect icloud:" "systemctl --user restart app-icloud@autostart.service")
fi

case $1 in
    bar)
        echo "$icon"
        ;;
    *)
        echo "$text"
        ;;
esac
