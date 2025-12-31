#!/usr/bin/env bash

# 1. Define where your projects live
# You can add multiple paths here
search_paths=(
    "$HOME/Documents"
)

# 2. Use find to get directories and pipe to fzf
# If an argument is provided, use it (for scripting). Otherwise, open fzf.
if [[ $# -eq 1 ]]; then
    selected=$1
else
    # find commands usually need to be adjusted based on your folder structure
    # This finds directories exactly 1 level deep inside the search paths
    selected=$(fd --min-depth=1 --max-depth=1 --type=d --full-path "${search_paths[@]}" | fzf)
fi

# 3. Exit if no selection was made (user pressed Esc)
if [[ -z $selected ]]; then
    exit 0
fi

# 4. Create a clean session name (replace dots with underscores)
# e.g., "my.project" -> "my_project"
session_name=$(basename "$selected" | tr . _)

# 5. Check if the session is already running
tmux_running=$(pgrep tmux)

# 6. Create the session if it doesn't exist (detached)
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    # If tmux isn't running at all, create new session and attach
    tmux new-session -s "$session_name" -c "$selected"
    exit 0
fi

# Create session if it doesn't exist, but don't attach yet
if ! tmux has-session -t="$session_name" 2> /dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi

# 7. Switch to the session
# If we are inside tmux, switch client. If outside, attach.
if [[ -n $TMUX ]]; then
    tmux switch-client -t "$session_name"
else
    tmux attach-session -t "$session_name"
fi
