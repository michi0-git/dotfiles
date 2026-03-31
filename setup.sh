#!/bin/bash

echo "🚀 Starting dotfiles setup..."

if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -f "Brewfile" ]; then
    echo "📦 Installing tools from Brewfile..."
    brew bundle
else
    echo "⏭️  Brewfile not found. Skipping brew bundle."
fi

DOT_CONFIGS=(nvim karabiner zsh git)

echo "🔗 Creating symbolic links..."
for config in "${DOT_CONFIGS[@]}"; do
    if [ -d "$config" ]; then
        echo "--- Processing: $config ---"
        
        if stow -n -v "$config" 2>&1 | grep -q "conflict"; then
            echo "⚠️  Conflict detected for $config. Skipping to avoid overwriting your existing files."
            echo "💡 If you want to use dotfiles version, manually delete the existing file in home directory."
        else
            stow -v "$config"
        fi
    else
        echo "⏭️  Directory '$config' not found. Skipping."
    fi
done

echo "✅ Setup process finished! Please restart your terminal."
