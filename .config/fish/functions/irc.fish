function irc -d "Connect to weechat server on otzalun"
  ssh -t meck.dev "/run/current-system/sw/bin/tmux -S /var/lib/weechat/irc.sock attach -t irc"
end
