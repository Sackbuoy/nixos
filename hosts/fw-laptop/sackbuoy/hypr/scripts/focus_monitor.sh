#!/usr/bin/env bash

if [ "$1" == "" ]; then
  exit 1
fi

# Get monitor information from hyprctl
monitors=$(hyprctl monitors -j)

# Get the active monitor name
active_monitor=$(echo "$monitors" | jq -r '.[] | select(.focused == true) | .name')

# Create associative arrays
declare -A monitor_indices  # name -> index
declare -A monitor_map      # index -> name

# Get the sorted monitor data into an array
readarray -t monitor_lines < <(echo "$monitors" | jq -r '.[] | "\(.x) \(.name)"' | sort -n)

index=0
for line in "${monitor_lines[@]}"; do
    monitor_name=$(echo "$line" | cut -d' ' -f2-)
    monitor_indices["$monitor_name"]=$index
    monitor_map["$index"]="$monitor_name"
    index=$((index+1))
done

# Set CURRENT variable to the index of the active monitor
CURRENT=${monitor_indices["$active_monitor"]}
echo "Active monitor: $active_monitor, CURRENT=$CURRENT"

if [ "$1" = "left" ]; then
  hyprctl dispatch focusmonitor "${monitor_map[$((CURRENT - 1))]}"
elif [ "$1" = "right" ]; then
  hyprctl dispatch focusmonitor "${monitor_map[$((CURRENT + 1))]}"
fi
