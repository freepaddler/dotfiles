tell application "System Events"
    set frontApp to first application process whose frontmost is true

    tell frontApp
        repeat with w in windows
            try
                set value of attribute "AXMinimized" of w to false
            end try
        end repeat
    end tell
end tell
