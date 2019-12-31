function brewme -d "Do all the homebrew stuff"
  brew update && brew upgrade && brew cleanup && brew doctor
end
