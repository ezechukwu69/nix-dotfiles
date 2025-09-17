#!/bin/sh

killall .waybar-wrapped
waybar -c ~/.config/waybar-niri/config.jsonc -s ~/.config/waybar-niri/styles.css &
