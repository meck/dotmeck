#!/bin/bash

# <bitbar.title>chunkwm/skhd helper</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Shi Han NG</bitbar.author>
# <bitbar.author.github>shihanng</bitbar.author.github>
# <bitbar.desc>Plugin that displays desktop id and desktop mode of chunkwm.</bitbar.desc>
# <bitbar.dependencies>brew,chunkwm,skhd</bitbar.dependencies>

# Info about chunkwm, see: https://github.com/koekeishiya/chunkwm
# For skhd, see: https://github.com/koekeishiya/skhd

export PATH=/usr/local/bin:$PATH


# Functions to call by argument
case $1 in
  "layout" )
    chunkc "tiling::desktop" "--layout $2"
    exit 0
  ;;

  "stop" )
    brew services stop chunkwm
    brew services stop skhd
    exit 0
  ;;

  "restart" )
    brew services restart chunkwm
    brew services restart skhd
    exit 0
  ;;

  "load" )
    chunkc core::load "$2".so
    exit 0
  ;;

  "unload" )
    chunkc core::unload "$2".so
    exit 0
  ;;
esac


# Is the server running
chunkc tiling::query > /dev/null 2>&1
state=$?

if [ $state != 0 ] ; then
  echo "🖥"
else
  echo "$(chunkc tiling::query --desktop id) ▸ $(chunkc tiling::query --desktop mode  | awk '{print toupper(substr($0,1,1)) substr($0,2) }')"
  echo "---"
  echo "BSP | bash='$0' param1=layout param2=bsp terminal=false"
  echo "Monocle | bash='$0' param1=layout param2=monocle terminal=false"
  echo "Float | bash='$0' param1=layout param2=float terminal=false"
  echo "---"
  echo "MFF"
  echo "-- Start | bash='$0' param1=load param2=ffm terminal=false"
  echo "-- Stop | bash='$0' param1=unload param2=ffm terminal=false"
  echo "Border"
  echo "-- Start | bash='$0' param1=load param2=border terminal=false"
  echo "-- Stop | bash='$0' param1=unload param2=border terminal=false"

fi

echo "---"

if [ $state != 0 ] ; then
  echo "Stopped | color='red'"
else
  echo "Started | color='green'"
fi

echo "--Restart | bash='$0' param1=restart terminal=false"
echo "--Stop | bash='$0' param1=stop terminal=false"
