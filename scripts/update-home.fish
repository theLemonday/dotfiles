#!/usr/bin/env /home/southclementide/.nix-profile/bin/fish

set home_manager_dir ~/.config/home-manager/
cd $home_manager_dir

set nix_command "nh home switch $home_manager_dir"

# If there's no changes, run switch command and exit
if test -z "$(git status --porcelain)"
    echo "✨ No changes to commit. Running Nix..."
    eval $nix_command
    if test $status -eq 0
        echo "✅ Nix command succeeded."
    else
        echo "❌ Nix command failed."
    end
    exit $status
end

# Commit the changes
echo "📦 Committing changes..."
git commit -am "Updated $(date)"

# Run the Nix command
echo "⚙️ Running Nix command..."
eval $nix_command

if test $status -eq 0
    echo "✅ Nix succeeded. Keeping commit."
else
    echo "❌ Nix failed. Reverting commit..."
    git reset --soft HEAD~1
end

exit $status
