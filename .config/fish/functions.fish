function fish_greeting
  if status --is-interactive && test -t 2 && type -q fortune
    fortune -s >&2
  end
end

function on_exit --on-process %self
  if status --is-interactive && test -t 2
    echo "Don't look back, because someone might be gaining on you.
      -- Tom Waits
    " >&2
  end
end

function update-all -d "Update everything in the user Env"
 echo "Updating Yadm..."
 yadm pull --ff-only

 echo "Updating Yadm submodules..."
 yadm submodule update --init --recursive

 if functions -q brewme
   echo "Updating Homebrew..."
   brewme
 end

 echo "Updating Fisher..."
 fisher

 echo "Updating Neovim Plugins..."
 nvim +PlugUpdate +qa
end

function lvim -d "Start Neovim with a light theme"
 nvim --cmd "let daytheme=1" $argv
end

function irc -d "Connect to weechat server on otzalun"
  ssh -t meck.dev "/run/current-system/sw/bin/tmux -S /var/lib/weechat/irc.sock attach -t irc"
end

function varclear -d 'Remove duplicates from environment variable'
    if test (count $argv) = 1
        set -l newvar
        set -l count 0
        for v in $$argv
            if contains -- $v $newvar
                set count (math $count+1)
            else
                set newvar $newvar $v
            end
        end
        set $argv $newvar
        test $count -gt 0
        and echo Removed $count duplicates from $argv
    else
        for a in $argv
            varclear $a
        end
    end
end

###########
#  MacOs  #
###########

if test (uname) = "Darwin"

  function f -d "Open the current directory in Finder"
     open $PWD
  end

  function cdf -d "cd to the current Finder directory"
    cd (pfd)
  end

  function pfd -d "Return the path of the frontmost Finder window"
    osascript 2>/dev/null -e '
      tell application "Finder"
        return POSIX path of (target of window 1 as alias)
      end tell'
  end

  function ql -d "Quick Look a specified file or directory"
    if [ (count $argv) -gt 0 ]
      qlmanage >/dev/null 2> /dev/null -p $argv &
    else
      echo "No arguments given"
    end
  end

  function showhidden -d "Hides/reveals system files and folders in Finder"
    switch "$argv"
    case Yes YES yes
      defaults write com.apple.finder AppleShowAllFiles YES
      killall Finder /System/Library/CoreServices/Finder.app
    case No NO no
      defaults write com.apple.finder AppleShowAllFiles NO
      killall Finder /System/Library/CoreServices/Finder.app
    case '*'
      echo "Command input must be 'yes' or 'no'"
    end
  end

  function brewme -d "Do all the homebrew stuff"
    brew update && brew upgrade && brew cleanup && brew doctor
  end

end
