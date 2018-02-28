#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

zstyle ':prezto:module:editor:info:keymap:primary' format ''
zstyle ':prezto:module:editor:info:keymap:alternate' format '[NORMAL]'

RPS1='$editor_info[keymap]'

# dircolors
if [[ -s "$XDG_CONFIG_HOME/dircolors" ]]; then
  eval "$(dircolors "$XDG_CONFIG_HOME"/dircolors)"
fi

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

(( $+commands[fd] )) && export FZF_DEFAULT_COMMAND='fd --type file'
(( $+commands[fd] )) && export FZF_CTRL_T_COMMAND='fd --follow --hidden . $home'
(( $+commands[fd] )) && export FZF_ALT_C_COMMAND='fd --follow -t d . $HOME'


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


#############################
#  Machine Specific Extras  #
#############################

if [[ -r $HOME/.config/machine ]]; then
  source $HOME/.config/machine
fi
