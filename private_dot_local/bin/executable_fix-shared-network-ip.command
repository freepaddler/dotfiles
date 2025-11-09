#!/bin/sh

net="192.168.64.1"
plist="/Library/Preferences/SystemConfiguration/com.apple.vmnet.plist"
[ -f "$plist" ] || return 0
current=$(sudo plutil -extract Shared_Net_Address raw "$plist")
if [ "$current" = "$net" ]; then
    echo "No changes required ($net)"
elif ifconfig | grep -q "$current"; then
    echo "Stop all apps using shared network (UTM, docker) before running this fix"
else
    sudo plutil -replace Shared_Net_Address -string "$net" "$vmnet_plist"
    sudo plutil -replace Shared_Net_Mask -string "255.255.255.0" "$vmnet_plist"
    echo "Done ($current -> $net)"
fi 
