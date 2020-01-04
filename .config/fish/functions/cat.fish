function cat -d "Use bat instead of cat if installed"
  if command -qs bat
    bat $argv
  else
    command cat $argv
  end
end
