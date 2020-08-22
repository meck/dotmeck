#!/bin/bash

networkLocation=$(networksetup -getcurrentlocation)

case $networkLocation in
  "Automatic" )
    ;;
  * ) echo "$networkLocation| \
            ansi=true \
            size=20 \
            font=Courier \
            dropdown=false \
            trim=false color=#bf616a"
esac
