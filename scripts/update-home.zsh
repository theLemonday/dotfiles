#!/usr/bin/env /home/southclementide/.nix-profile/bin/zsh

home_manager_dir="$HOME/.config/home-manager/"
cd "$home_manager_dir" || exit 1

nix_command="nh home switch $home_manager_dir --configuration personal"

# If there are no changes, run switch command and exit
if [[ -z "$(git status --porcelain)" ]]; then
  echo "✨ No changes to commit. Running Nix..."
  eval "$nix_command"
  ret=$?
  if [[ $ret -eq 0 ]]; then
    echo "✅ Nix command succeeded."
  else
    echo "❌ Nix command failed."
  fi
  exit $ret
fi

# Commit the changes
echo "📦 Committing changes..."
git commit -am "Updated $(date)"

# Run the Nix command
echo "⚙️ Running Nix command..."
eval "$nix_command"
ret=$?

if [[ $ret -eq 0 ]]; then
  echo "✅ Nix succeeded. Keeping commit."
else
  echo "❌ Nix failed. Reverting commit..."
  git reset --soft HEAD~1
fi

exit $ret
