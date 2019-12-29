function cat -d "Use bat instead of cat if installed"
  if command -qs bat
    bat $argv
  else
    cat $argv
  end
end
