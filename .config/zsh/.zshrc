#
# Executes commands at the start of an interactive session.
#
#

#####################
#  Temporary Files  #
#####################

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


###########
#  PATHS  #
###########

# Coreutils path for GNU
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# For my own scripts
export PATH=$HOME/bin:$PATH

# For haskell stack: ghc-mod hlint etc.
export PATH=$HOME/.local/bin:$PATH


###############
#  Dircolors  #
###############

if [[ -s "$XDG_CONFIG_HOME/dircolors" ]]; then
  eval "$(dircolors "$XDG_CONFIG_HOME"/dircolors)"
fi


###############
#  Languages  #
###############

# Rust
path_to_rustc=$(which rustc)
if [[ -x "$path_to_rustc" ]]; then
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi
export PATH="$HOME/.cargo/bin:$PATH"

# Go
if [[ "$OSTYPE" == darwin* ]]; then
  export GOPATH=$HOME/go
  export GOROOT=/usr/local/opt/go/libexec
  export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
else
  export GOPATH=$HOME/go
  export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
fi

# Python
# To run global pip commands
gpip2(){
   PIP_REQUIRE_VIRTUALENV="" pip2 "$@"
}

gpip3(){
   PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}


#########
#  Nix  #
#########

if [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi


############
#  Prezto  #
############

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


#########
#  fzf  #
#########

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--color 16'

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

# Start neovim with a light theme
alias lvim='nvim --cmd "let daytheme=1"'

#############################
#  Machine Specific Extras  #
#############################

if [[ -r $HOME/.config/machine ]]; then
  source $HOME/.config/machine
fi
