#!/usr/bin/env /home/lemonday/.nix-profile/bin/fish

# Run home-manager switch
if home-manager switch
    echo "✅ Home Manager switch successful!"

    # Change to the Home Manager config directory (adjust if needed)
    cd ~/.config/home-manager || exit

    # Check for uncommitted changes
    if git diff --quiet && git diff --staged --quiet
        echo "📂 No changes to commit."
    else
        # Commit changes
        git add .
        set commit_msg "Updated $(date)"
        git commit -m "$commit_msg"
        echo "🚀 Changes committed and pushed!"
    end
else
    echo "❌ Home Manager switch failed!"
    exit 1
end

