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
    echo "⚠️ Brewfile not found. Skipping brew bundle."
fi

DOT_CONFIGS=(nvim karabiner zsh git starship)

echo "🔗 Creating symbolic links with GNU Stow..."
for config in "${DOT_CONFIGS[@]}"; do
    if [ -d "$config" ]; then
        stow -v "$config"
    else
        echo "⏭️  Directory '$config' not found. Skipping."
    fi
done

echo "✅ Setup completed! Please restart your terminal."

