#!/bin/bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

networkLocation=$(networksetup -getcurrentlocation)

case $networkLocation in
  "Automatic" )
    ;;
  * ) echo "$networkLocation| \
            dropdown=false \
            color=#bf616a"
esac
