#!/bin/bash

export PATH=/usr/local/bin:$PATH

# skhd saves the current keyboard mode to this file
modefile=$TMPDIR/current_skhd_mode
if [[ -r $modefile ]]
    then
      mod="$(cat "$modefile")"
      mod="$(echo "$mod" | awk '{print toupper($0)}')"
      if [[ -n $mod ]]
          then
        skhd_mode=" --- $mod --- "
        echo -e "$skhd_mode | \
          ansi=true \
          size=20 \
          font=Courier \
          dropdown=false \
          trim=false color=#bf616a"
      fi
fi
