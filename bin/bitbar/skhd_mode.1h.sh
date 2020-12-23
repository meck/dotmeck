#!/bin/bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

export PATH=/usr/local/bin:$PATH

# skhd saves the current keyboard mode to this file
modefile=$TMPDIR/current_skhd_mode
if [[ -r $modefile ]]
    then
      mod="$(cat "$modefile")"
      mod="$(echo "$mod" | awk '{print toupper($0)}')"
      if [[ -n $mod ]]
          then
        skhd_mode="< $mod >"
        echo -e "$skhd_mode | \
          dropdown=false \
          trim=false \
          color=#bf616a"
      fi
fi
