function lock -d 'Lock macOs'
    osascript -e 'tell application "System Events" to keystroke "q" using {command down, control down}'
end
