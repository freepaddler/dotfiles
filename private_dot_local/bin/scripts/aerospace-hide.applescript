tell application "System Events"
    set frontApp to first application process whose frontmost is true
    key code 46 using command down -- Cmd+M
    --delay 0.05
    set visible of frontApp to false -- hide именно исходное приложение
end tell
