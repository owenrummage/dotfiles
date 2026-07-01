bindkey -e

bindkey '^[[1;5D' backward-word
bindkey '^[[5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[5C' forward-word

bindkey '^[[1;5A' up-line-or-search
bindkey '^[[5A' up-line-or-search
bindkey '^[[1;5B' down-line-or-search
bindkey '^[[5B' down-line-or-search

bindkey '^W' backward-kill-word
bindkey '^[[3;5~' kill-word
