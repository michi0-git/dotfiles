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

# rustup is keg-only in Homebrew, so it is not on PATH until .zprofile is loaded
RUSTUP_BIN="$(brew --prefix rustup)/bin/rustup"
if [ ! -x "$RUSTUP_BIN" ]; then
    RUSTUP_BIN="$(command -v rustup || true)"
fi

if [ -z "$RUSTUP_BIN" ]; then
    echo "⏭️  rustup not found. Skipping Rust toolchain setup."
elif [[ "$("$RUSTUP_BIN" toolchain list 2>&1)" == *"no installed toolchains"* ]]; then
    echo "🦀 Installing Rust stable toolchain..."
    "$RUSTUP_BIN" default stable \
        || echo "⚠️  Failed to install Rust stable toolchain."
else
    echo "⏭️  Rust toolchain already installed. Skipping."
fi

if ! command -v stow &> /dev/null; then
    echo "❌ stow not found even after brew bundle. Aborting symlink step."
    exit 1
fi

DOT_CONFIGS=(nvim karabiner zsh git skhd yabai bin vscode)

# Create the VS Code user dir beforehand so stow links files, not the whole Code dir
mkdir -p "$HOME/Library/Application Support/Code/User"

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

VSCODE_EXTENSIONS_FILE="$DOTFILES_DIR/vscode/extensions.txt"
if command -v code &> /dev/null && [ -f "$VSCODE_EXTENSIONS_FILE" ]; then
    echo "🧩 Installing VS Code extensions..."
    while IFS= read -r extension || [ -n "$extension" ]; do
        [[ -z "$extension" || "$extension" == \#* ]] && continue
        # code CLI prints Node.js deprecation warnings to stderr; show them only on failure
        if ! extension_log="$(code --install-extension "$extension" --force < /dev/null 2>&1)"; then
            echo "⚠️  Failed to install VS Code extension: $extension"
            echo "$extension_log"
        fi
    done < "$VSCODE_EXTENSIONS_FILE"
else
    echo "⏭️  code command or extensions.txt not found. Skipping VS Code extensions."
fi

echo "✅ Setup process finished! Please restart your terminal."
