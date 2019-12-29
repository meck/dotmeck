function on_exit
  if status --is-interactive && test -t 2
    echo "Don't look back, because someone might be gaining on you.
      -- Tom Waits
    " >&2
  end
end
