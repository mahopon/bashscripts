#!/usr/bin/env bash
set -e

echo "==> Updating system"
sudo apt update

echo "==> Installing packages"
sudo apt install -y \
  curl \
  unzip \
  fontconfig \
  alacritty \
  eza \
  coreutils

########################################
# Fonts
########################################
echo "==> Installing JetBrainsMono Nerd Font"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

if ! ls JetBrainsMono*Nerd* >/dev/null 2>&1; then
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
  unzip -o JetBrainsMono.zip
  rm JetBrainsMono.zip
  fc-cache -fv
fi

########################################
# Starship
########################################
echo "==> Installing Starship"
if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

########################################
# Alacritty config (TOML)
########################################
echo "==> Writing Alacritty config"
mkdir -p "$HOME/.config/alacritty"

cat > "$HOME/.config/alacritty/alacritty.toml" <<'EOF'
[env]
TERM = "xterm-256color"

[window]
padding = { x = 10, y = 10 }
decorations = "full"
opacity = 1.0

[font]
size = 12.0

[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"

[font.bold]
family = "JetBrainsMono Nerd Font"
style = "Bold"

[cursor]
style = { shape = "Block", blinking = "On" }

[colors.primary]
background = "#0e1419"
foreground = "#eaeaea"

[colors.normal]
black   = "#1c252c"
red     = "#e06c75"
green   = "#98c379"
yellow  = "#e5c07b"
blue    = "#61afef"
magenta = "#c678dd"
cyan    = "#56b6c2"
white   = "#abb2bf"

[colors.bright]
black   = "#5c6370"
red     = "#e06c75"
green   = "#98c379"
yellow  = "#e5c07b"
blue    = "#61afef"
magenta = "#c678dd"
cyan    = "#56b6c2"
white   = "#ffffff"
EOF

########################################
# Starship config
########################################
echo "==> Writing Starship config"
mkdir -p "$HOME/.config"

cat > "$HOME/.config/starship.toml" <<'EOF'
add_newline = false

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[directory]
style = "bold cyan"
truncation_length = 3

[git_branch]
symbol = " "
style = "bold purple"

[git_status]
style = "bold yellow"

[cmd_duration]
style = "bold blue"
EOF

########################################
# Shell setup (bash + zsh)
########################################
setup_shell() {
  local RC_FILE="$1"
  local INIT_CMD="$2"

  if [ -f "$RC_FILE" ]; then
    if ! grep -q "STARSHIP SETUP" "$RC_FILE"; then
      cat >> "$RC_FILE" <<EOF

# ===== STARSHIP SETUP =====
$INIT_CMD

# Enable colors
export TERM=xterm-256color
if command -v dircolors >/dev/null 2>&1; then
  eval "\$(dircolors -b)"
fi

# Modern ls
alias ls='eza --icons --group-directories-first'
alias grep='grep --color=auto'
# =========================
EOF
    fi
  fi
}

echo "==> Configuring bash"
setup_shell "$HOME/.bashrc" 'eval "$(starship init bash)"'

echo "==> Configuring zsh"
setup_shell "$HOME/.zshrc" 'eval "$(starship init zsh)"'

########################################
# Done
########################################
echo
echo "✅ Terminal setup complete!"
echo
echo "Restart your shell or run:"
echo "  exec bash   # for bash"
echo "  exec zsh    # for zsh"
