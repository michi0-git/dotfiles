# =============================================================================
# Powerlevel10k Instant Prompt
# Must stay at the top. Code requiring console input must go above this block.
# =============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# =============================================================================
# PATH
# =============================================================================
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.docker/bin:/usr/local/go/bin"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

export PATH="$PATH:Develop/infra/script/assumerole"

# =============================================================================
# Build Flags
# =============================================================================
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/opt/homebrew/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig:/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

# =============================================================================
# Plugin Manager (Zinit)
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# =============================================================================
# Theme (Powerlevel10k)
# =============================================================================
source "$(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =============================================================================
# Completions
# =============================================================================
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# =============================================================================
# Development Tools
# =============================================================================

# pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# mise (runtime version manager)
eval "$(mise activate zsh)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# terraform
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# =============================================================================
# Shell Enhancements (via Homebrew)
# =============================================================================

# zsh-autosuggestions
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

# =============================================================================
# Aliases
# =============================================================================
alias cat='bat'
alias cd='z'

if command -v eza > /dev/null; then
  alias ls='eza --icons --git'
  alias ll='eza -al --icons --git --header'
  alias lt='eza --tree --level=2 --icons'
fi

