#!/usr/bin/env bash
# rebuild.sh — switch home-manager config and rebuild with herdr
# Usage: rebuild.sh [personal|work]
set -euo pipefail

PROFILE="${1:-personal}"
FLAKE_DIR="${HOME}/.config/home-manager"

echo "==> Switching to profile: $PROFILE"
home-manager switch --flake "$FLAKE_DIR#$PROFILE"

echo "==> Running herdr agent check"
if command -v herdr >/dev/null 2>&1; then
  herdr config check 2>/dev/null || echo "  (herdr config check skipped)"
fi

echo "==> Done. Profile: $PROFILE"