#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "🚀 Starting dotfiles setup..."

if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo "📦 Installing tools from Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
else
    echo "⏭️  Brewfile not found. Skipping brew bundle."
fi

if ! command -v stow &> /dev/null; then
    echo "❌ stow not found even after brew bundle. Aborting symlink step."
    exit 1
fi

DOT_CONFIGS=(nvim karabiner zsh git skhd yabai bin)

echo "🔗 Creating symbolic links..."
for config in "${DOT_CONFIGS[@]}"; do
    if [ -d "$DOTFILES_DIR/$config" ]; then
        echo "--- Processing: $config ---"

        if stow -n -v -d "$DOTFILES_DIR" -t "$HOME" "$config" 2>&1 | grep -q "conflict"; then
            echo "⚠️  Conflict detected for $config. Skipping to avoid overwriting your existing files."
            echo "💡 If you want to use dotfiles version, manually delete the existing file in home directory."
        else
            stow -v -d "$DOTFILES_DIR" -t "$HOME" "$config"
        fi
    else
        echo "⏭️  Directory '$config' not found. Skipping."
    fi
done

echo "✅ Setup process finished! Please restart your terminal."
