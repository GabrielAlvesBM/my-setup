- **Browser:** vivaldi
- **Menu:** rofi
- **Shell:** zsh
- **File Manager:** dolphin
- **Terminal:** kitty
- **Font:** CaskaydiaCove NFM 11pt
- **Icons:** Papirus-Dark
- **Theme:** Breeze-Dark 

`
sudo pacman -Syu
`
```
sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber gstreamer gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ffmpeg git gnome-keyring fastfetch nwg-look kde-cli-tools archlinux-xdg-menu mpd libappindicator-gtk3 mesa-utils mesa lib32-mesa vulkan-intel vulkan-radeon ark kio-admin polkit-kde-agent qt5-wayland qt6-wayland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-user-dirs-gtk
```
```
sudo pacman -S hyprland hyprlock hypridle hyprcursor hyprpaper hyprpicker hyprshot waybar kitty rofi-wayland dolphin dolphin-plugins vivaldi dunst cliphist mpv pavucontrol ttf-font-awesome ttf-jetbrains-mono-nerd ttf-opensans noto-fonts noto-fonts-emoji ttf-droid ttf-roboto ttf-fira-code ttf-fira-mono ttf-firacode-nerd otf-font-awesome
```
```
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si
```
```
yay -S --noconfirm wlogout qview visual-studio-code-bin slack swaync qt5ct-kde qt6ct-kde
```
```
systemctl --user enable pipewire pipewire-pulse wireplumber
```