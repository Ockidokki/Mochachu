#!/usr/bin/env bash
# Fetches all open clients and saves relevant state to a JSON file
hyprctl clients -j | jq '[.[] | {
  class: .class,
  title: .title,
  workspace: .workspace.name,
  floating: .floating,
  at: .at,
  size: .size
}]' > ~/.config/hypr/saved_session.json