## Dotmeck
#### [yadm](https://yadm.io) managed dotfiles

Mostly stuff thats not included in my nix setup

Setup a new machine:
``` bash
yadm clone "git@github.com:meck/dotmeck.git"
```

If yadm is not available via package manager, somewhat inadvisable from a security perspective:
``` bash
curl -L 'https://github.com/TheLocehiliosan/yadm/raw/master/bootstrap' | bash -s -- "https://github.com/meck/dotmeck.git" "master"
```
