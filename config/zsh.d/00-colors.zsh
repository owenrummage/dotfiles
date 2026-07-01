typeset -gA WAL

_load_wal_colors() {
  local cache="${HOME}/.cache/wal/colors.sh"
  if [[ -r "$cache" ]]; then
    source "$cache"
    WAL[fg]="${foreground:-white}"
    WAL[bg]="${background:-black}"
    WAL[accent]="${color9:-${color1:-blue}}"
    WAL[warn]="${color11:-${color3:-yellow}}"
    WAL[bad]="${color9:-${color1:-red}}"
    WAL[muted]="242"
  else
    WAL[fg]="white"
    WAL[bg]="black"
    WAL[accent]="blue"
    WAL[warn]="blue"
    WAL[bad]="red"
    WAL[muted]="242"
  fi
}

_load_wal_colors
