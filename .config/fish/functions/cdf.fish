function cdf -d "cd to the current Finder directory"
  if is_macOs
    cd (pfd)
  else
    echo "Error: $_ only available on macOS" 1>&2
  end
end
