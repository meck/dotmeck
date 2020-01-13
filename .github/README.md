## Dotmeck
#### My [yadm](https://yadm.io) managed dotfiles

Neovim, fish, tmux, yabai, skhd, etc
For macOS and Linux

Setup a new machine:
``` bash
yadm clone "git@github.com:meck/dotmeck.git"
yadm bootstrap
```

If yadm is not available via package manager, somewhat inadvisable from a security perspective:
``` bash
curl -L 'https://github.com/TheLocehiliosan/yadm/raw/master/bootstrap' | bash -s -- "https://github.com/meck/dotmeck.git" "master"
```
