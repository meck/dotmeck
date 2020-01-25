# register completions (on-the-fly, non-cached, because the actual command won't be cached anyway
complete -c cheat -xa '(curl -s https://cheat.sh/:list)'
