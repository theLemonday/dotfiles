#!/usr/bin/env bash
# rebuild.sh — switch home-manager config and rebuild
# Usage: rebuild.sh [personal|work]
set -euo pipefail

PROFILE="${1:-personal}"
FLAKE_DIR="${HOME}/.config/home-manager"

echo "==> Switching to profile: $PROFILE"
home-manager switch --flake "$FLAKE_DIR#$PROFILE"

echo "==> Done. Profile: $PROFILE"