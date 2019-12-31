function vi -d "Neovim alias if availible othervise vim"
  if type -q nvim
    nvim $argv
  else if type -q vim
    vim $argv
  else
    vi $argv
  end
end
