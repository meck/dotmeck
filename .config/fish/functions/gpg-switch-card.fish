function gpg-switch-card -d "Switch to the current gpg card stubs"
  gpg-connect-agent "scd serialno" "learn --force" /bye
end

