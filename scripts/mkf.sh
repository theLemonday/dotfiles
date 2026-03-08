#!/usr/bin/env bash
# bin/mkf.sh
# Usage: paste content then press Ctrl-D when done
# First line must be a comment with the filepath: # path/to/file.yaml

set -euo pipefail

echo "Paste content, press Ctrl-D when done..."

content=$(cat)

# extract filepath from first line — strips leading "# " or "#"
filepath=$(echo "$content" | head -1 | sed 's/^#[[:space:]]*//')

# validate it looks like a file path
if [[ "$filepath" != */* && "$filepath" != *.* ]]; then
  echo "error: first line does not look like a filepath: '$filepath'" >&2
  exit 1
fi

mkdir -p "$(dirname "$filepath")"

# tail -n +2 skips the first line (the directive comment)
echo "$content" | tail -n +2 >"$filepath"

echo "created: $filepath"
