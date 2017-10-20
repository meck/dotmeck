#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...


# Vim mode in promt
vim_ins_mode=""
vim_cmd_mode="[NORMAL]"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}

# don't display RPROMPT for previously accepted lines; only display it next to current line
setopt transient_rprompt

RPS1='${vim_mode}'




###########
#  PATHS  #
###########

# For my own scripts
export PATH=$HOME/bin:$PATH

# For haskell stack: ghc-mod hlint etc.
export PATH=$HOME/.local/bin:$PATH

# Go things
if [[ "$OSTYPE" == darwin* ]]; then
  export GOPATH=$HOME/go
  export GOROOT=/usr/local/opt/go/libexec
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
else
  export GOPATH=$HOME/go
  export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
fi

# Rust
path_to_rustc=$(which rustc)
if [[ -x "$path_to_rustc" ]]; then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi


#########
#  fzf  #
#########

# source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
(( $+commands[rg] )) && export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

#############
#  Aliases  #
#############

# MacOs Specific
if [[ "$OSTYPE" == darwin* ]]; then
  # Use f to open a finder window
  alias f='open $PWD'

  # Do all the homebrew stuff
  alias brewme='brew update && brew upgrade && brew cleanup && brew doctor'
fi
