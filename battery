#!/bin/bash

usage() {
cat <<EOF
battery: usage:

  general:
    -h, --help    print this message
    -p            use pmset (more accurate)
    -t            output tmux status bar format
    -a            output ascii bar instead of spark's

  colors:
    -g <color>    good battery level      default: green or 1;32
    -m <color>    middle battery level    default: yellow or 1;33
    -w <color>    warn battery level      default: red or 0;31
EOF
}

if [[ $1 == '-h' || $1 == '--help' || $1 == '-?' ]]; then
  usage
  exit 0
fi

# For default behavior
setDefaults() {
  pmset_on=0
  output_tmux=0
  ascii=0
  ascii_bar='=========='
  good_color="1;32"
  middle_color="1;33"
  warn_color="0;31"
  connected=0
}

setDefaults

battery_info() {
    ioreg -n AppleSmartBattery -r | \
    grep -o '"[^"]*" = [^ ]*' | \
    sed -e 's/= //g' -e 's/"//g' | \
    sort
}

battery_charge() {
    battery_info | \
    while read key value; do
        case $key in
            "MaxCapacity")
                export maxcap=$value;;
            "CurrentCapacity")
                export curcap=$value;;
        esac
        if [[ -n "$maxcap" && -n $curcap ]]; then
            CAPACITY=$(( 100 * curcap / maxcap))
            printf "%d" $CAPACITY
            break
        fi
    done
}

battery_external_connected() {
  battery_info | grep "ExternalConnected" | cut -f2 -d' '
}

if [[ ! $(battery_external_connected) = "No" ]]; then
  connected=1
fi


run_battery() {
if ((pmset_on)); then
  BATTERY_STATUS="$(pmset -g batt | grep -o '[0-9]*%' | tr -d %)"
else
  BATTERY_STATUS="$(battery_charge)"
fi

[[ -z "$BATTERY_STATUS" ]] && exit 1
}

# Apply the correct color to the battery status prompt
apply_colors() {
# Green
if [[ $BATTERY_STATUS -ge 75 ]]; then
  if ((output_tmux)); then
    COLOR="#[fg=$good_color]"
  else
    COLOR=$good_color
  fi

# Yellow
elif [[ $BATTERY_STATUS -ge 25 ]] && [[ $BATTERY_STATUS -lt 75 ]]; then
  if ((output_tmux)); then
    COLOR="#[fg=$middle_color]"
  else
    COLOR=$middle_color
  fi

# Red
elif [[ $BATTERY_STATUS -lt 25 ]]; then
  if ((output_tmux)); then
    COLOR="#[fg=$warn_color]"
  else
    COLOR=$warn_color
  fi
fi
}

print_status() {
# Print the battery status
if ((connected)); then
  GRAPH="⚡"

elif ((ascii)); then
  barlength=${#ascii_bar}

  # Divides BATTTERY_STATUS by 10 to get a decimal number; i.e 7.6
  n=$(echo "scale = 1; $BATTERY_STATUS / 10" | bc)

  # Round the number to the nearest whole number
  rounded_n=$(printf "%.0f" "$n")

  # Creates the bar
  GRAPH=$(printf "[%-${barlength}s]" "${ascii_bar:0:rounded_n}")

else
  GRAPH=$(spark 0 ${BATTERY_STATUS} 100 | awk '{print substr($0,4,3)}')
fi

if ((output_tmux)); then
  printf "%s%s %s%s" "$COLOR" "[$BATTERY_STATUS%]" "$GRAPH" "#[default]"
else
  printf "\e[0;%sm%s %s \e[m\n"  "$COLOR" "[$BATTERY_STATUS%]"  "$GRAPH"
fi
}

# Read args
while getopts ":g:m:w:tap" opt; do
  case $opt in
    g)
      good_color=$OPTARG
      ;;
    m)
      middle_color=$OPTARG
      ;;
    w)
      warn_color=$OPTARG
      ;;
    t)
      output_tmux=1
      good_color="green"
      middle_color="yellow"
      warn_color="red"
      ;;
    a)
      ascii=1
      ;;
    p)
      pmset_on=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument"
      exit 1
      ;;
  esac
done


run_battery
apply_colors
print_status
