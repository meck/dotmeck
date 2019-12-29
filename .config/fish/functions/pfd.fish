function pfd -d "Return the path of the frontmost Finder window"
  if is_macOs
    osascript 2>/dev/null -e '
      tell application "Finder"
        return POSIX path of (target of window 1 as alias)
      end tell'
  else
    echo "Error: $_ only available on macOS" 1>&2
  end
end
