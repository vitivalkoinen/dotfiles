# ~/.zshrc

# パス設定
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/opt/nvim

autoload -U compinit
compinit -i

# Sheldonの初期化
eval "$(sheldon source)"

# Starshipプロンプト
eval "$(starship init zsh)"
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# 基本的なZshオプション
setopt AUTO_CD
setopt CORRECT
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# 補完機能
autoload -Uz compinit
compinit

# WSL設定
export BROWSER=/usr/bin/wslview

# Go設定
export PATH=$PATH:/usr/local/go/bin
export GOROOT=/usr/local/go
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin

# Rust設定
source ~/.cargo/env

# zoxide (ディレクトリジャンプ)
eval "$(zoxide init zsh)"

# エイリアス
alias ls='eza'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias cat='batcat'
alias vim='nvim'

# Git エイリアス
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'

# ghq
function ghq-fzf_change_directory() {
    # 選択したリポジトリへ移動 かつ
    # 右にリポジトリのディレクトリ詳細を表示
  local src=$(ghq list | fzf --preview "eza -l -g -a --icons $(ghq root)/{} | tail -n+4 | awk '{print \$6\"/\"\$8\" \"\$9 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}

zle -N ghq-fzf_change_directory
bindkey '^]' ghq-fzf_change_directory
