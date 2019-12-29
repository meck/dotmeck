function ql -d "Quick Look a specified file or directory"
  if is_macOs
    if [ (count $argv) -gt 0 ]
      qlmanage >/dev/null 2> /dev/null -p $argv &
    else
      echo "No arguments given"
    end
  else
    echo "Error: $_ only available on macOS" 1>&2
  end
end
