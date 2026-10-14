# =============================================================================
# .zprofile — Login shell environment setup
# PATH, exports only. Aliases/functions belong in .zshrc.
# =============================================================================

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# pyenv (PATH setup for login shell)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"

# Added by Toolbox App
export PATH="$PATH:/usr/local/bin"


# Rust (rustup is keg-only in Homebrew; cargo-installed binaries live in ~/.cargo/bin)
export PATH="/opt/homebrew/opt/rustup/bin:$HOME/.cargo/bin:$PATH"
