function vi -d "Neovim alias if availible othervise vim"
  if type -q nvim
    command nvim $argv
  else if type -q vim
    command vim $argv
  else
    command vi $argv
  end
end
