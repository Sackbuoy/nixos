#!/usr/bin/env bash

mapfile -t monitors < <(hyprctl monitors all -j | jq -r 'sort_by(.x) | .[].description' 2>/dev/null)

last_mon=$(( $(hyprctl monitors -j | jq 'map(.id) | max') ))

current_monitor=0
function increment_current_monitor {
  if [ $current_monitor -eq $last_mon ]; then
    current_monitor=0
  else
    ((++current_monitor))
  fi
}

current_ws=1
last_ws=$(( $(hyprctl workspaces -j | jq 'map(.id) | max') ))

while [ $current_ws -le $last_ws ]; do
  desc="${monitors[$current_monitor]}"
  hyprctl dispatch moveworkspacetomonitor "${current_ws}" desc:"${desc}"

  increment_current_monitor
  ((++current_ws))
done
