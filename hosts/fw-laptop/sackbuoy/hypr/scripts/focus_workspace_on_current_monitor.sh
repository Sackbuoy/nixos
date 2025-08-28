#!/usr/bin/env bash

current_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
current_ws=$(hyprctl activeworkspace -j | jq -r '.id')

# Create bash associative array
declare -A workspace_map

# Populate the map
while IFS=$'\t' read -r index ws_id; do
   workspace_map[$index]=$ws_id
done < <(hyprctl workspaces -j | jq -r --arg monitor "$current_monitor" '
 map(select(.monitor == $monitor)) | 
 sort_by(.id) | 
 to_entries | 
 map("\(.key)\t\(.value.id)") | 
 .[]
')

# Get the index of the current workspace
for index in "${!workspace_map[@]}"; do
   if [[ "${workspace_map[$index]}" == "$current_ws" ]]; then
       current_index=$index
       break
   fi
done

if [[ "$1" = "left" ]]; then
  hyprctl dispatch workspace "${workspace_map[$((current_index - 1))]}"
elif [[ "$1" = "right" ]]; then
  if [[ -v workspace_map[$((current_index + 1))] ]]; then
    hyprctl dispatch workspace "${workspace_map[$((current_index + 1))]}"
  else
    last_ws=$(hyprctl workspaces -j | jq '.[-1].id')
    hyprctl dispatch workspace $((last_ws + 1))
  fi
fi

