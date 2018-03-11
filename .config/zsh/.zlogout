#
# Executes commands at logout.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Execute code only if STDERR is bound to a TTY.
[[ -o INTERACTIVE && -t 2 ]] && {

# Print the message.
cat <<-EOF

Don't look back, because someone might be gaining on you.
  -- Tom Waits
EOF

} >&2
