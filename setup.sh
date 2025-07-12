#!/bin/bash
set -euo pipefail

# Path variables
DOTFILES_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
PICTURES_DIR="$HOME/Pictures"

echo "Starting setup..."

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing official packages..."
sudo pacman -S --needed --noconfirm pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber \
  gstreamer gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ffmpeg git base-devel rsync \
  gnome-keyring fastfetch nwg-look kde-cli-tools archlinux-xdg-menu mpd libappindicator-gtk3 mesa-utils \
  mesa lib32-mesa vulkan-intel vulkan-radeon ark kio-admin polkit-kde-agent qt5-wayland qt6-wayland \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-user-dirs-gtk \
  hyprland hyprlock hypridle hyprcursor hyprpaper hyprpicker hyprshot waybar kitty rofi-wayland dolphin \
  zsh vi vim curl less \
  dolphin-plugins vivaldi dunst cliphist mpv pavucontrol ttf-font-awesome ttf-jetbrains-mono-nerd papirus-icon-theme \
  ttf-opensans noto-fonts noto-fonts-emoji ttf-droid ttf-roboto ttf-fira-code ttf-fira-mono ttf-firacode-nerd ttf-cascadia-mono-nerd ttf-cascadia-code-nerd \
  otf-font-awesome

if ! command -v yay &> /dev/null; then
  echo "Installing yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
else
  echo "yay is already installed, skipping..."
fi

echo "Installing AUR packages..."
yay -S --noconfirm wlogout qview visual-studio-code-bin slack-bin swaync qt5ct-kde qt6ct-kde

echo "Setting up configuration files..."

mkdir -p "$CONFIG_DIR"

link_config() {
  src="$DOTFILES_DIR/.config/$1"
  dest="$CONFIG_DIR/$1"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "Backing up $dest to $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -sf "$src" "$dest"
  echo "Linked $src to $dest"
}

link_config hypr
link_config kitty
link_config waybar

if [ -e "$CONFIG_DIR/kdeglobals" ] || [ -L "$CONFIG_DIR/kdeglobals" ]; then
  echo "Backing up $CONFIG_DIR/kdeglobals to $CONFIG_DIR/kdeglobals.bak"
  mv "$CONFIG_DIR/kdeglobals" "$CONFIG_DIR/kdeglobals.bak"
fi
ln -sf "$DOTFILES_DIR/.config/kdeglobals" "$CONFIG_DIR/kdeglobals"
echo "Linked kdeglobals"

echo "Setting up wallpapers..."
mkdir -p "$PICTURES_DIR/wallpapers"

rsync -a --delete "$DOTFILES_DIR/Pictures/wallpapers/" "$PICTURES_DIR/wallpapers/"

if [[ "$SHELL" != "/bin/zsh" ]]; then
  echo "Setting ZSH as default shell..."
  chsh -s /bin/zsh
fi

echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed."
fi

echo "Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "Installing Powerlevel10k theme..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

echo "Linking Zsh configuration..."
if [ -e "$HOME/.zshrc" ] || [ -L "$HOME/.zshrc" ]; then
  echo "Backing up existing .zshrc to .zshrc.bak"
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi
ln -sf "$DOTFILES_DIR/.config/.zshrc" "$HOME/.zshrc"

if [ -f "$DOTFILES_DIR/.config/.p10k.zsh" ]; then
  if [ -e "$HOME/.p10k.zsh" ] || [ -L "$HOME/.p10k.zsh" ]; then
    echo "Backing up existing .p10k.zsh to .p10k.zsh.bak"
    mv "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak"
  fi
  ln -sf "$DOTFILES_DIR/.config/.p10k.zsh" "$HOME/.p10k.zsh"
fi

echo "Setup completed successfully!"
