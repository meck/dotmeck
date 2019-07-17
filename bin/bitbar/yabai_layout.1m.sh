#!/bin/bash

# <bitbar.title>chunkwm/skhd helper</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Meck</bitbar.author>
# <bitbar.author.github>meck</bitbar.author.github>
# <bitbar.desc>Plugin that displays desktop mode of chunkwm.</bitbar.desc>
# <bitbar.dependencies>brew,chunkwm,skhd</bitbar.dependencies>

# Info about chunkwm, see: https://github.com/koekeishiya/chunkwm
# For skhd, see: https://github.com/koekeishiya/skhd

export PATH=/usr/local/bin:$PATH

read -r -d '' iconBsp << EOM
iVBORw0KGgoAAAANSUhEUgAAACkAAAApCAYAAACoYAD2AAAAAXNSR0IArs4c6QAA
AAlwSFlzAAAWJQAAFiUBSVIk8AAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAA
ADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhN
UCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3
LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpE
ZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0i
aHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpP
cmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNj
cmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAARtJREFU
WAntmLEOwjAMRAMD384IOxvfB78AccVZVhoVOT5vthSlFc3L9ZJKF1qr4jtw6ch7
b6/ePs72/o0VBmqVN2OB2W79yitufP6qtBbmWZZiVxwcRQoDFeUp6wRi72VCRoHJ
4G2sM0NVNqNEshwuJ8tJlgMsTu3JcpLlAIuTuSclckVKx2eKfEYU9rGP2fgxdq3e
g43QK454WLvQi1glYEa0Eo5lyn24Mpc7LA6ATJFYbm9C3y03xErv2TdHz4IZPTNN
zzhHE3t+g0ivg+McdcaBk7Q+88MpkTQHWKBa7nKS5QCLU3syw0mN6wG4ZdjrFaSO
t8sdjfsixEb+KM+y9CWR/+QNxkTy717GyP/twkCt8mYsMKsPOfAFEHL+xByHGEcA
AAAASUVORK5CYII=
EOM
iconBsp=$(echo "$iconBsp" | tr -d '\n')

read -r -d '' iconFloat << EOM
iVBORw0KGgoAAAANSUhEUgAAACkAAAApCAYAAACoYAD2AAAAAXNSR0IArs4c6QAA
AAlwSFlzAAAWJQAAFiUBSVIk8AAAAVlpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAA
ADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhN
UCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3
LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpE
ZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0i
aHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iPgogICAgICAgICA8dGlmZjpP
cmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICA8L3JkZjpEZXNj
cmlwdGlvbj4KICAgPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KTMInWQAAAOlJREFU
WAntlzEOwyAMRZMOOUBP3bHZu+V8zRVaO0ojZDlRMMZIzbfEAML258Hw6TqEP4GB
So403jQ+zmNea3OPonhStrc4We9RpJCSaxCUIrlHdvRJBheMiLTnqX63U7sab4JI
rwsASZD0IuBVB28SJL0IeNXBm9whKZ2RnB96T7m59Vz1nhF+Mufgm/dM3+S0cz2t
lu9a498fh99Ezolr7l10Zrvk9XQsLCIWfel1RzQ19YBIEzYlCSQVKKYlkDRhU5JA
UoFiWgJJEzYl6a9JslOqHVsPK8kI7/kqpVDTex7+cUqFXzv/CxXT3LMLotJJAAAA
AElFTkSuQmCC
EOM
iconFloat=$(echo "$iconFloat" | tr -d '\n')

# Functions to call by argument
case $1 in
  "layout" )
    yabai -m space --layout "$2"
    exit 0
  ;;

  "stop" )
    brew services stop yabai
    brew services stop skhd
    exit 0
  ;;

  "restart" )
    brew services restart yabai
    brew services restart skhd
    exit 0
  ;;

  "quicklook" )
    qlmanage -p "$2" > /dev/null 2>&1
    exit 0
  ;;

esac


# Is the server running
yabai -m query --spaces > /dev/null 2>&1
state=$?

if [ $state != 0 ] ; then
  echo "╳"
else
  mode=$(yabai -m query --spaces --space | grep -o -E "float|bsp")
  case $mode in
    "bsp" )
      echo -e "| templateImage=$iconBsp"
      ;;
    "float" )
      echo -e "| templateImage=$iconFloat"
      ;;
    *)
      echo "Mode Error!"
      ;;
  esac
  echo "---"
  echo "BSP | bash='$0' param1=layout param2=bsp terminal=false refresh=true"
  echo "Float | bash='$0' param1=layout param2=float terminal=false refresh=true"

fi

echo "---"

if [ $state != 0 ] ; then
  echo "Stopped | color='red'"
else
  echo "Started | color='green'"
fi

echo "--Restart | bash='$0' param1=restart terminal=false refresh=true"
echo "--Stop | bash='$0' param1=stop terminal=false refresh=true"
echo "View Bindings | bash='$0' param1=quicklook param2='$HOME/.skhdrc' terminal=false"
