function fish_greeting
  if status --is-interactive && test -t 2 && type -q fortune
    fortune -s >&2
  end
end
