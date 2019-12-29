function f -d "Open the current directory in Finder"
  if is_macOs
    open $PWD
  else
    echo "Error: $_ only available on macOS" 1>&2
  end
end
