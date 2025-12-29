#!/usr/bin/env zsh

STATE_FILE="$HOME/.local/state/wraith/cycle-special.state"

# Get all special workspaces, sorted and exit if none found
specials=(
  ${(on)$(
    hyprctl workspaces -j \
    | jq -r '.[] | select(.name | startswith("special:")) | .name'
  )}
)

(( ${#specials[@]} == 0 )) && exit 0

# empty entry → means "hide"
specials+=("")

if [[ ! -f "$STATE_FILE" ]]; then
  print -r -- "${specials[1]}" > "$STATE_FILE"
fi

current=$(<"$STATE_FILE")

current_index=0
for i in {1..${#specials[@]}}; do
  if [[ "${specials[$i]}" == "$current" ]]; then
    current_index=$i
    break
  fi
done

(( current_index == 0 )) && current_index=1

next_index=$(( current_index + 1 ))
(( next_index > ${#specials[@]} )) && next_index=1

next="${specials[$next_index]}"

if [[ -z "$next" ]]; then
  hyprctl dispatch togglespecialworkspace "${current#*:}"
else
  hyprctl dispatch workspace "$next"
fi

print -r -- "$next" > "$STATE_FILE"
