export ZDOTDIR="${HOME}/.config/zsh"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export PATH="${HOME}/.local/bin:${HOME}/.local/bin/dotfiles:${PATH}"
export LIBVIRT_DEFAULT_URI="qemu:///system"

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}"

setopt AUTO_CD
setopt AUTO_PUSHD
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt PROMPT_SUBST

autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

for file in "${HOME}/.config/zsh.d"/*.zsh(N); do
  source "$file"
done
