proj() {
  if (( $# != 1 )); then
    printf 'Usage: proj PROJECT\n' >&2
    return 2
  fi

  local root="${HOME}/Projects"
  local target="${root}/${1}"
  if [[ ! -d "$target" ]]; then
    printf 'Project does not exist.\nCreate it? [Y/n] '
    local reply
    read -r reply
    case "$reply" in
      ""|[Yy]|[Yy][Ee][Ss]) mkdir -p "$target" ;;
      *) return 1 ;;
    esac
  fi
  cd "$target" || return
}

_proj_complete() {
  local root="${HOME}/Projects"
  [[ -d "$root" ]] || return
  compadd -- "${(@f)$(find "$root" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' 2>/dev/null)}"
}
compdef _proj_complete proj

transfer() {
  if (( $# != 2 )); then
    printf 'Usage: transfer SOURCE DESTINATION\n' >&2
    return 2
  fi
  [[ -e "$1" ]] || { printf 'Source does not exist: %s\n' "$1" >&2; return 1; }

  if [[ -b "$2" ]]; then
    printf 'About to write to block device %s. Type YES to continue: ' "$2" >&2
    local confirm
    read -r confirm
    [[ "$confirm" == "YES" ]] || return 1
  fi

  sudo SOURCE_PATH="$1" DEST_PATH="$2" bash <<'TRANSFER_EOF'
set -euo pipefail
source_size="$(blockdev --getsize64 "$SOURCE_PATH" 2>/dev/null || stat --printf="%s" "$SOURCE_PATH")"
dd if="$SOURCE_PATH" ibs=1M status=none \
  | pv -s "$source_size" 2>"$(tty)" \
  | dd of="$DEST_PATH" obs=1M oflag=direct status=none
sync
TRANSFER_EOF
}

ytmp3() {
  if (( $# != 1 )); then
    printf 'Usage: ytmp3 URL\n' >&2
    return 2
  fi
  yt-dlp --extract-audio --audio-format mp3 "$1"
}
