#!/bin/bash

WORKINGDIR="$HOME/.config/rofi/custom_command/kitty"
MAP="$WORKINGDIR/cmd.csv"

cat "$MAP" \
    | cut -d ',' -f 1 \
    | rofi -dmenu -i -p "Kitty " \
    | head -n 1 \
    | xargs -i --no-run-if-empty grep "{}" "$MAP" \
    | cut -d ',' -f 2 \
    | head -n 1 \
    | xargs -i --no-run-if-empty /bin/bash -c "{}"

exit 0

