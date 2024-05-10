HISTFILE=~/.zsh_history  # ヒストリーファイルのパス
HISTSIZE=1000           # メモリに保持するヒストリーの数
SAVEHIST=1000000        # ヒストリーファイルに保存するヒストリーの数

# my zsh settings
setopt auto_cd

# pyenv settings
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# posetry settings
export PATH=$PATH:$HOME/.local/bin

if [ -z "$SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
    if [ "$RUNNING_AGENT" = "0" ]; then
        # Launch a new instance of the agent
        ssh-agent -s &>| $HOME/.ssh/ssh-agent
    fi
    eval `cat $HOME/.ssh/ssh-agent`
fi

# go path
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# nvim path
export PATH="$PATH:/opt/nvim-linux64/bin"

# volta settings
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

fpath+=~/.zfunc
autoload -Uz compinit && compinit
