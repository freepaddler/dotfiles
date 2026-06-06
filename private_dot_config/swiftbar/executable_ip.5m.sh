#!/usr/bin/env bash

ip_ru=$(curl -s https://api64.ipify.org)
ip_world=$(curl -s https://api.ipify.org)

echo "⚡️"
echo "RU: $ip_ru"
echo "WORLD: $ip_world"
echo "---"
