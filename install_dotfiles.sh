#!/usr/bin/env bash
set -euo pipefail

readonly REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly BACKUP_ROOT="${HOME}/.config_backup"
readonly STAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
readonly BACKUP_DIR="${BACKUP_ROOT}/${STAMP}"

red=$'\033[31m'; green=$'\033[32m'; yellow=$'\033[33m'; blue=$'\033[34m'; reset=$'\033[0m'
log() { printf '%s==>%s %s\n' "$blue" "$reset" "$*"; }
ok() { printf '%sOK%s %s\n' "$green" "$reset" "$*"; }
warn() { printf '%sWARN%s %s\n' "$yellow" "$reset" "$*"; }
die() { printf '%sERROR%s %s\n' "$red" "$reset" "$*" >&2; exit 1; }

declare -a LINKS=(
  ".gitconfig:${HOME}/.gitconfig"
  "config/i3:${HOME}/.config/i3"
  "config/picom:${HOME}/.config/picom"
  "config/kitty:${HOME}/.config/kitty"
  "config/rofi:${HOME}/.config/rofi"
  "config/nvim:${HOME}/.config/nvim"
  "config/zsh:${HOME}/.config/zsh"
  "config/zsh.d:${HOME}/.config/zsh.d"
  "config/wal:${HOME}/.config/wal"
  "scripts:${HOME}/.local/bin/dotfiles"
  "wallpapers:${HOME}/.local/share/wallpapers"
)

ensure_dirs() {
  mkdir -p "${HOME}/.config" "${HOME}/.local/bin" "${HOME}/.local/share" "$BACKUP_ROOT"
}

is_repo_link() {
  local target=$1
  [[ -L "$target" ]] && [[ "$(readlink -- "$target")" == "${REPO_DIR}/"* ]]
}

backup_existing() {
  local target=$1
  [[ -e "$target" || -L "$target" ]] || return 0

  if is_repo_link "$target"; then
    rm -- "$target"
    return 0
  fi

  mkdir -p "$BACKUP_DIR"
  local rel backup_target
  rel="${target#${HOME}/}"
  backup_target="${BACKUP_DIR}/${rel}"
  mkdir -p "$(dirname -- "$backup_target")"
  mv -- "$target" "$backup_target"
  warn "Backed up ${target} to ${backup_target}"
}

link_one() {
  local source_rel=$1 target=$2 source
  source="${REPO_DIR}/${source_rel}"
  [[ -e "$source" ]] || die "Missing source: $source"
  mkdir -p "$(dirname -- "$target")"
  backup_existing "$target"
  ln -s -- "$source" "$target"
  ok "Linked ${target}"
}

install_shell_entrypoints() {
  local zshrc="${HOME}/.zshrc"
  backup_existing "$zshrc"
  ln -s -- "${REPO_DIR}/config/zsh/.zshrc" "$zshrc"
  ok "Linked ${zshrc}"
}

install_1password_agent_config() {
  local source="${REPO_DIR}/config/1Password/ssh/agent.toml"
  local target="${HOME}/.config/1Password/ssh/agent.toml"

  if [[ ! -e "$source" ]]; then
    warn "Skipping 1Password SSH agent config. Copy config/1Password/ssh/agent.example.toml to agent.toml to enable it."
    return 0
  fi

  mkdir -p "$(dirname -- "$target")"
  backup_existing "$target"
  ln -s -- "$source" "$target"
  ok "Linked ${target}"
}

main() {
  ensure_dirs
  for item in "${LINKS[@]}"; do
    IFS=: read -r source target <<<"$item"
    link_one "$source" "$target"
  done
  install_1password_agent_config
  install_shell_entrypoints
  log "Generating an initial wallpaper/theme if possible."
  "${REPO_DIR}/scripts/theme/random-wallpaper" || warn "Wallpaper setup skipped; add images to wallpapers/ and rerun random-wallpaper."
  printf '\nDotfiles installed. Backups, if needed, are in %s\n' "$BACKUP_DIR"
}

main "$@"
