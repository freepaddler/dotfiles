tell application "System Events"
    set frontApp to first application process whose frontmost is true
    key code 46 using command down -- Cmd+M
    set visible of frontApp to false
end tell
