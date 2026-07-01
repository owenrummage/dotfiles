#!/usr/bin/env bash
set -euo pipefail

readonly REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

red=$'\033[31m'; green=$'\033[32m'; yellow=$'\033[33m'; blue=$'\033[34m'; reset=$'\033[0m'
log() { printf '%s==>%s %s\n' "$blue" "$reset" "$*"; }
ok() { printf '%sOK%s %s\n' "$green" "$reset" "$*"; }
warn() { printf '%sWARN%s %s\n' "$yellow" "$reset" "$*"; }

declare -a TARGETS=(
  "${HOME}/.config/i3"
  "${HOME}/.config/picom"
  "${HOME}/.config/kitty"
  "${HOME}/.config/rofi"
  "${HOME}/.config/dunst"
  "${HOME}/.config/nvim"
  "${HOME}/.config/zsh"
  "${HOME}/.config/zsh.d"
  "${HOME}/.config/wal"
  "${HOME}/.config/1Password/ssh/agent.toml"
  "${HOME}/.local/bin/dotfiles"
  "${HOME}/.local/share/wallpapers"
  "${HOME}/.zshrc"
)

remove_if_owned() {
  local target=$1 link
  if [[ ! -L "$target" ]]; then
    warn "Skipping non-symlink: $target"
    return
  fi
  link="$(readlink -- "$target")"
  if [[ "$link" == "${REPO_DIR}/"* ]]; then
    rm -- "$target"
    ok "Removed $target"
  else
    warn "Skipping symlink not owned by this repository: $target -> $link"
  fi
}

main() {
  log "Removing dotfile symlinks only. Packages and backups are untouched."
  local target
  for target in "${TARGETS[@]}"; do
    remove_if_owned "$target"
  done
}

main "$@"
