#######
# XDG #
#######

if not set -q XDG_CONFIG_HOME
  set -gx XDG_CONFIG_HOME "$HOME/.config"
end

if not set -q XDG_DATA_HOME
  set -gx XDG_DATA_HOME "$HOME/.local/share"
end


#####################
#  Temporary Files  #
#####################

# Set TMPDIR if the variable is not set/empty or the directory doesn't exist
if test -z "$TMPDIR"
  set -gx TMPDIR /tmp/fish-(id -u)
end

if test ! -d "$TMPDIR"
  mkdir -m 700 "$TMPDIR"
end

if test ! -d "$TMUX_TMPDIR"
  set -gx TMUX_TMPDIR /tmp/
end

set -gx TMPPREFIX "$TMPDIR/fish"

#####################
#  MacOs functions  #
#####################

if test (uname)  = "Darwin"
  set fish_function_path $XDG_CONFIG_HOME/fish/functions_macOs $fish_function_path
end

##########
#  Lang  #
##########

if not set -q LANG
  set -gx LANG 'en_US.UTF-8'
end

############
#  Fisher  #
############

if not functions -q fisher
  while true
    read -l -P 'Fisher missing, download and run? [y/n] ' confirm
    switch $confirm
      case Y y
        curl 'https://git.io/fisher' --create-dirs -sLo "$XDG_CONFIG_HOME/fish/functions/fisher.fish"
        exec fish -c fisher
        break
      case N n
        break
    end
  end
end

####################################
#  Editor, Visual, Pager, Browser  #
####################################

if type -q nvim
  set -gx VISUAL "nvim"
else
  set -gx VISUAL "vim"
end
set -gx EDITOR $VISUAL

set -gx PAGER "less"

# Set the default Less options.
set -x LESS "-g -i -M -R -w -z-4"

set -x LESS_TERMCAP_mb (printf "\e[01;34m")
set -x LESS_TERMCAP_md (printf "\e[01;34m")
set -x LESS_TERMCAP_me (printf "\e[0m")
set -x LESS_TERMCAP_se (printf "\e[0m")
set -x LESS_TERMCAP_so (printf "\e[01;44;30m")
set -x LESS_TERMCAP_ue (printf "\e[0m")
set -x LESS_TERMCAP_us (printf "\e[01;32m")

if command -qs src-hilite-lesspipe.sh
  set -x LESSOPEN "| "(command -s src-hilite-lesspipe.sh)" %s"
end

if test (uname)  = "Darwin"
  set -gx BROWSER "open"
end

set -gx BAT_CONFIG_PATH $XDG_CONFIG_HOME/bat/bat.conf


######################
#  Path and pkgmang  #
######################

# Homebrew
set -gx PATH /usr/local/bin /usr/local/sbin $PATH

# Coreutils path for GNU
# set -gx PATH "/usr/local/opt/coreutils/libexec/gnubin" $PATH
# set -gx MANPATH "/usr/local/opt/coreutils/libexec/gnuman" $MANPATH

# For my own scripts
set -gx PATH "$HOME/bin" $PATH

# Ghcup
set -gx PATH "$HOME/.ghcup/bin" $PATH

# For haskell cabal install
set -gx PATH "$HOME/.cabal/bin" $PATH

# For haskell stack install
set -gx PATH "$HOME/.local/bin" $PATH

# Rust
set -gx PATH "$HOME/.cargo/bin" $PATH
if type -q rustc
  set -gx RUST_SRC_PATH (rustc --print sysroot)"/lib/rustlib/src/rust/src"
end

# Go
set -gx GOPATH "$HOME/code/go"
if test (uname)  = "Darwin"
  set -gx GOROOT "/usr/local/opt/go/libexec"
  set -gx PATH $PATH "$GOROOT/bin" "$GOPATH/bin"
else
  set -gx PATH $PATH "/usr/local/go/bin" "$GOPATH/bin"
end

# Nix
if test -e "$HOME/.nix-profile/etc/profile.d/nix.sh" && functions -q bass
  bass source "$HOME/.nix-profile/etc/profile.d/nix.sh" ';' "NIX_PATH=\"\$NIX_PATH\"" ';' "export PATH=\"\$PATH\""
end

#########
#  FZF  #
#########

set -gx FZF_DEFAULT_OPTS '--color 16 --height 20'
if type -q fd
  set -gx FZF_FIND_FILE_COMMAND "fd --type f . \$dir"
  set -gx FZF_CD_COMMAND "fd --follow --type d . \$dir"
  set -gx FZF_CD_WITH_HIDDEN_COMMAND "fd --follow --hidden --type d . \$dir"
end


#############
#  Theming  #
#############

# Dircolors use brew version on macOS
if not type -q dircolors && type -q gdircolors
  alias dircolors gdircolors
end

if not set -q LS_COLORS && test -s $XDG_CONFIG_HOME/dircolors
  eval (dircolors -c $XDG_CONFIG_HOME/dircolors)
end

set -x EXA_COLORS uu=35:gu=35

set -gx SPACEFISH_CHAR_SYMBOL ❯

# Use starship for prompt if installed (Otherwise spacefish via fisher)
if command -qa starship
  starship init fish | source
end

# nord theme https://github.com/arcticicestudio/nord/issues/102
set nord0 2e3440
set nord1 3b4252
set nord2 434c5e
set nord3 4c566a
set nord4 d8dee9
set nord5 e5e9f0
set nord6 eceff4
set nord7 8fbcbb
set nord8 88c0d0
set nord9 81a1c1
set nord10 5e81ac
set nord11 bf616a
set nord12 d08770
set nord13 ebcb8b
set nord14 a3be8c
set nord15 b48ead

set fish_color_normal $nord4
set fish_color_command $nord9
set fish_color_quote $nord14
set fish_color_redirection $nord9
set fish_color_end $nord6
set fish_color_error $nord11
set fish_color_param $nord4
set fish_color_comment $nord3
set fish_color_match $nord8
set fish_color_search_match $nord8
set fish_color_operator $nord9
set fish_color_escape $nord13
set fish_color_cwd $nord8
set fish_color_autosuggestion $nord6
set fish_color_user $nord4
set fish_color_host $nord9
set fish_color_cancel $nord15
set fish_pager_color_prefix $nord13
set fish_pager_color_completion $nord6
set fish_pager_color_description $nord10
set fish_pager_color_progress $nord12
set fish_pager_color_secondary $nord1


##########
#  Misc  #
##########

# GPG
set -xg GPG_TTY (tty)


# Can functions be conditionally autoloaded
# with a fallback later in `$fish_function_path`?
if command -qs exa
  function ls --description 'List contents of directory'
    command exa $argv
  end
end

# Remove duplicates from $PATH
varclear PATH > /dev/null
