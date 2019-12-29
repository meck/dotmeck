function brewme -d "Do all the homebrew stuff"
  if is_macOs
    brew update && brew upgrade && brew cleanup && brew doctor
  else
    echo "Error: $_ only available on macOS" 1>&2
  end
end
