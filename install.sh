#!/usr/bin/env bash
set -euo pipefail

readonly AUR_HELPER="yay"
readonly YAY_REPO="https://aur.archlinux.org/yay.git"

bold=$'\033[1m'
red=$'\033[31m'
green=$'\033[32m'
yellow=$'\033[33m'
blue=$'\033[34m'
reset=$'\033[0m'

log() { printf '%s==>%s %s\n' "$blue" "$reset" "$*"; }
ok() { printf '%sOK%s %s\n' "$green" "$reset" "$*"; }
warn() { printf '%sWARN%s %s\n' "$yellow" "$reset" "$*"; }
die() { printf '%sERROR%s %s\n' "$red" "$reset" "$*" >&2; exit 1; }

require_arch() {
  [[ -r /etc/arch-release ]] || die "This installer is intended for Arch Linux."
  command -v pacman >/dev/null 2>&1 || die "pacman was not found."
}

detect_bluetooth_hardware() {
  local override="${DOTFILES_BLUETOOTH:-}"
  local output

  case "${override,,}" in
    1|yes|true|on)
      ok "Bluetooth install forced with DOTFILES_BLUETOOTH=${override}."
      return 0
      ;;
    0|no|false|off)
      warn "Bluetooth install disabled with DOTFILES_BLUETOOTH=${override}."
      return 1
      ;;
    "")
      ;;
    *)
      die "DOTFILES_BLUETOOTH must be one of: yes/no, true/false, 1/0."
      ;;
  esac

  if command -v lsusb >/dev/null 2>&1; then
    output="$(lsusb 2>/dev/null || true)"
    if grep -Eiq 'bluetooth|wireless.*bluetooth|bt[[:space:]-]' <<<"$output"; then
      ok "Bluetooth hardware detected with lsusb."
      return 0
    fi
  fi

  if command -v lspci >/dev/null 2>&1; then
    output="$(lspci 2>/dev/null || true)"
    if grep -Eiq 'bluetooth|wireless.*bluetooth|network controller.*bluetooth' <<<"$output"; then
      ok "Bluetooth hardware detected with lspci."
      return 0
    fi
  fi

  if compgen -G "/sys/class/bluetooth/hci*" >/dev/null; then
    ok "Bluetooth hardware detected in /sys/class/bluetooth."
    return 0
  fi

  warn "No Bluetooth hardware detected; skipping Bluetooth packages and service."
  return 1
}

install_yay() {
  if command -v "$AUR_HELPER" >/dev/null 2>&1; then
    ok "yay is already installed."
    return
  fi

  log "Installing yay AUR helper."
  sudo pacman -S --needed --noconfirm base-devel git

  local build_dir
  build_dir="$(mktemp -d)"

  git clone "$YAY_REPO" "$build_dir/yay"
  (cd "$build_dir/yay" && makepkg -si --noconfirm)
  rm -rf -- "$build_dir"
  command -v "$AUR_HELPER" >/dev/null 2>&1 || die "yay installation failed."
  ok "yay installed."
}

install_hardware_detection_tools() {
  log "Installing hardware detection tools."
  yay -S --needed --noconfirm usbutils pciutils
}

remove_conflicting_packages() {
  local conflicts=(
    "vesktop-bin:vesktop vesktop-git vesktop-canary-bin"
    "picom-ftlabs-git:picom picom-git picom-ibhagwan-git picom-jonaburg-git"
    "i3lock-color:i3lock i3lock-color-git i3lock-fancy-git"
    "pipewire-pulse:pulseaudio pulseaudio-alsa pulseaudio-bluetooth"
    "1password:1password-beta"
    "1password-cli:1password-cli-beta"
    "ly:ly-git"
  )
  local entry conflict
  local -a installed_conflicts=()

  for entry in "${conflicts[@]}"; do
    for conflict in ${entry#*:}; do
      if pacman -Qq "$conflict" >/dev/null 2>&1; then
        installed_conflicts+=("$conflict")
      fi
    done
  done

  ((${#installed_conflicts[@]})) || return 0

  log "Removing packages that conflict with this setup: ${installed_conflicts[*]}"
  sudo pacman -Rns --noconfirm "${installed_conflicts[@]}"
}

install_packages() {
  local has_bluetooth=$1
  local packages=(
    # Core X11 desktop
    xorg-server xorg-xinit xorg-xrandr xorg-xset xorg-xprop xorg-xinput
    i3-wm i3blocks i3lock-color xss-lock picom-ftlabs-git rofi feh ly

    # Theme and desktop integration
    pywal dunst polkit-gnome lxappearance papirus-icon-theme
    pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol

    # Terminal and shell
    kitty zsh git ripgrep fd fzf bat eza jq btop fastfetch unzip zip wget curl pv
    zsh-autosuggestions zsh-syntax-highlighting

    # Development
    neovim tree-sitter-cli nodejs npm python lua gcc make

    # Utilities
    playerctl brightnessctl networkmanager usbutils pciutils imagemagick xclip
    yt-dlp wl-clipboard maim xdotool

    # Applications
    firefox vesktop-bin
    1password       # Desktop app
    1password-cli   # Optional CLI support for integrations

    # Fonts
    ttf-jetbrains-mono-nerd ttf-font-awesome nerd-fonts
  )

  if [[ "$has_bluetooth" == true ]]; then
    packages+=(bluez blueman)
  else
    warn "Skipping Bluetooth packages."
  fi

  remove_conflicting_packages

  log "Installing desktop packages with yay."
  yay -S --needed --noconfirm "${packages[@]}"
}

enable_services() {
  local has_bluetooth=$1

  log "Enabling system services."
  sudo systemctl daemon-reload
  enable_service_if_present NetworkManager.service true
  if [[ "$has_bluetooth" == true ]]; then
    enable_service_if_present bluetooth.service true
  else
    warn "Not enabling bluetooth.service."
  fi
  enable_service_if_present ly.service false
  ok "Service enablement finished. Ly defaults are left untouched."
}

enable_service_if_present() {
  local unit=$1 required=$2

  if systemctl cat "$unit" >/dev/null 2>&1; then
    sudo systemctl enable "$unit"
    ok "Enabled ${unit}"
    return
  fi

  if [[ "$required" == true ]]; then
    die "Required systemd unit is missing after package installation: ${unit}"
  fi

  warn "Optional systemd unit is missing: ${unit}"
  if [[ "$unit" == "ly.service" ]]; then
    warn "Ly was requested for installation, but this package did not provide ly.service on this system."
    warn "No Ly configuration was modified."
  fi
}

main() {
  local has_bluetooth=false

  require_arch
  install_yay
  install_hardware_detection_tools
  if detect_bluetooth_hardware; then
    has_bluetooth=true
  fi
  install_packages "$has_bluetooth"
  enable_services "$has_bluetooth"
  printf '\n%sComplete.%s Run %s./install_dotfiles.sh%s, then reboot.\n' "$bold" "$reset" "$bold" "$reset"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
