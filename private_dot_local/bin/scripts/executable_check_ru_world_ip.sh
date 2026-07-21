#!/usr/bin/env bash

ip_world=$(curl -s https://api.ipify.org)
ip_ru=$(curl -s https://2ip.ru)

case $1 in
    bar)
        if [ "$ip_ru" != "$ip_world" ]; then
            echo "🌎"
        else
            echo "📍"
        fi
        ;;
    *)
        echo "🌎 $ip_world"
        echo "🇷🇺 $ip_ru"
        ;;
esac
