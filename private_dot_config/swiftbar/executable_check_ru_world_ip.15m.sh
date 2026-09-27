#!/usr/bin/env bash

# <xbar.title>IP Widget</xbar.title>
# <xbar.version>2.0</xbar.version>
# <xbar.author>Victor Chu</xbar.author>
# <xbar.author.github>freepaddler</xbar.author.github>
# <xbar.desc>Shows global/RU IP</xbar.desc>
# <xbar.dependencies>curl</xbar.dependencies>

ip_world=$(curl -s https://api.ipify.org)
ip_ru=$(curl -s https://2ip.io)

case $1 in
    bar)
        if [ "$ip_ru" != "$ip_world" ]; then
            echo "🌎"
        else
            echo "📍"
        fi
        ;;
    *)
        echo ":bolt:"
        echo "---"
        echo "🌎 $ip_world"
        echo "🇷🇺 $ip_ru"
        echo "Refresh | refresh=true"
        ;;
esac
