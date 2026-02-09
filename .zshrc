# ================================
# Zsh + CachyOS-style autocomplete
# ================================

# --- Basic options ---
setopt histignorealldups sharehistory
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
bindkey -e  # emacs keybindings

# --- Completion system ---
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose true

eval "$(dircolors -b)"

# --- Aliases ---
alias ls='eza --icons --group-directories-first'
alias ll='ls -la'

# --- Starship prompt ---
eval "$(starship init zsh)"

# --- Load plugins manually ---
ZSH_AUTOSUGGEST_DIR="$HOME/.zsh/zsh-autosuggestions"
source "$ZSH_AUTOSUGGEST_DIR/zsh-autosuggestions.zsh"

# --- Autosuggestions style ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# --- Key bindings ---
bindkey '^E' autosuggest-accept                  # Ctrl+E: accept autosuggestion

# --- Optional: datetime support ---
zmodload zsh/datetime

