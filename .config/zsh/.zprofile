#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#
# if [[ -x "$(command -v nvim)" ]]; then
path_to_nvim=$(which nvim)
if [[ -x "$path_to_nvim" ]]; then
  export VISUAL='nvim'
else
  export VISUAL='vim'
fi

export EDITOR="$VISUAL"

export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

# For haskell stack: ghc-mod hlint etc.
path=(
  $HOME/.local/bin
  $path
)

# Coreutils path for GNU
path=(
  /usr/local/opt/coreutils/libexec/gnubin
  $path
)

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# use nvim instead of vim if we got it
#if type nvim > /dev/null 2>&1; then
#  alias vim='nvim'
#fi

# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-g -i -M -R -S -w -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#
#
# Set TMPDIR if the variable is not set/empty or the directory doesn't exist
if [[ -z "${TMPDIR}" ]]; then
  export TMPDIR="/tmp/zsh-${UID}"
fi

if [[ ! -d "${TMPDIR}" ]]; then
  mkdir -m 700 "${TMPDIR}"
fi

if [[ ! -d "$TMUX_TMPDIR" ]]; then
  export TMUX_TMPDIR="/tmp/"
fi


TMPPREFIX="${TMPDIR%/}/zsh"

# To run global pip commands
gpip2(){
   PIP_REQUIRE_VIRTUALENV="" pip2 "$@"
}

gpip3(){
   PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

export PATH="$HOME/.cargo/bin:$PATH"
