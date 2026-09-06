#!/usr/bin/env bash
SESSION_FILE="$HOME/.config/hypr/saved_session.json"

if [ ! -f "$SESSION_FILE" ]; then
  exit 0
fi

jq -c '.[]' "$SESSION_FILE" | while read -r item; do
  class=$(echo "$item" | jq -r '.class')
  floating=$(echo "$item" | jq -r '.floating')
  x=$(echo "$item" | jq -r '.at[0]')
  y=$(echo "$item" | jq -r '.at[1]')
  w=$(echo "$item" | jq -r '.size[0]')
  h=$(echo "$item" | jq -r '.size[1]')
  ws=$(echo "$item" | jq -r '.workspace')

  # Launch app if class is valid
  if [ -n "$class" ] && [ "$class" != "null" ]; then
    gtk-launch "$class" &>/dev/null || "$class" &>/dev/null &
    
    # Wait for window to register, then apply position & size rules
    sleep 0.5
    if [ "$floating" = "true" ]; then
      hyprctl dispatch setfloating "class:^($class)$"
      hyprctl dispatch movewindowpixel "exact $x $y,class:^($class)$"
      hyprctl dispatch resizewindowpixel "exact $w $h,class:^($class)$"
    fi
    hyprctl dispatch movetoworkspace "$ws,class:^($class)$"
  fi
done