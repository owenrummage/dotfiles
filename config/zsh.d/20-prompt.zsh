_prompt_git() {
  command -v git >/dev/null 2>&1 || return 0
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local branch dirty
  branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
  [[ -n "$branch" ]] || return 0
  dirty=""
  [[ -n "$(git status --porcelain=v1 2>/dev/null)" ]] && dirty="*"
  printf ' %%F{1} %s%s%%f' "$branch" "$dirty"
}

_prompt_status() {
  local code=$1
  (( code == 0 )) && return 0
  printf '%%F{1}[%d]%%f ' "$code"
}

precmd() {
  local code=$?
  local path git_info
  path="%F{1}%~%f"
  git_info="$(_prompt_git)"
  PROMPT="$(_prompt_status "$code")${path}${git_info} "'%F{8}›%f '
}
