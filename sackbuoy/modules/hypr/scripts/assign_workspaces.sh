#!/usr/bin/env bash

homeMonRight="Dell Inc. DELL P2419HC DMC0L03"
homeMonLeft="Dell Inc. DELL P2419HC 6C9ZJ73"
builtin="BOE NE135A1M-NY1"
workMonLeft="LG Electronics LG HDR 4K 0x00060A6B"
workMonRight="LG Electronics LG HDR 4K 0x000609C5"

# monitor configurations:
home=("${homeMonLeft}" "${homeMonRight}" "${builtin}")
work=("${workMonLeft}" "${workMonRight}" "${builtin}")

MONITOR_DESCS=()
MONITOR_DESCS_STR=""
WORKSPACE_IDS=()
WORKSPACE_IDS_STR=""

while IFS= read -r line; do
  MONITOR_DESCS+=("$line")
  MONITOR_DESCS_STR+="$line"
done < <(hyprctl monitors -j | jq -r '.[] | .description')

while IFS= read -r line; do
  WORKSPACE_IDS+=("$line")
  WORKSPACE_IDS_STR+="$line"
done < <(hyprctl workspaces -j | jq -r '.[] | .id')


declare -A homeMappings
function setup_home() {
  homeMappings[$homeMonLeft]+="1"
  homeMappings[$homeMonRight]+="2"
  homeMappings[$builtin]+="3"
}
setup_home

declare -A workMappings
function setup_work() {
  workMappings[$workMonLeft]+="1"
  workMappings[$workMonRight]+="2"
  workMappings[$builtin]+="3"
}
setup_work

function is_home() {
  result=0 # true
  for desc in "${home[@]}"; do
    if [[ "${MONITOR_DESCS_STR}" != *"$desc"* ]]; then
      result=1 # false
    fi
  done
  return $result
}

function is_work() {
  result=0 # true
  for desc in "${work[@]}"; do
    if [[ "${MONITOR_DESCS_STR}" != *"$desc"* ]]; then
      result=1 # false
      break
    fi
  done
  return $result
}

if is_home; then
  for desc in "${!homeMappings[@]}"; do
    for ws in ${homeMappings[$desc]}; do
      hyprctl dispatch moveworkspacetomonitor "${ws}" "desc:${desc}"
    done
  done
elif is_work; then
  for desc in "${!workMappings[@]}"; do
    for ws in ${workMappings[$desc]}; do
      hyprctl dispatch moveworkspacetomonitor "${ws}" "desc:${desc}"
    done
  done
else
  for ws in "${WORKSPACE_IDS[@]}"; do
    hyprctl dispatch moveworkspacetomonitor "${ws}" "desc:${builtin}"
  done
fi

hyprctl reload

