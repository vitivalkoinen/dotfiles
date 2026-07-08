if [[ -z ${ZSH_VERSION} ]]; then
  echo 'You must use zsh to run install.zsh' >&2
  exit 1
fi

DOTFILES_REPO="$HOME/dotfiles"
DOTFILES=(".zshrc")
LOCAL_BIN="$HOME/.local/bin"

# apt パッケージ名でそのままインストールできるコマンド一覧
# (コマンド名 -> apt パッケージ名)
typeset -A APT_PACKAGES
APT_PACKAGES=(
  zsh       zsh
  git       git
  curl      curl
  fzf       fzf
  rg        ripgrep
  batcat    bat
  eza       eza
  gh        gh
  zoxide    zoxide
  starship  starship
)

is_wsl () {
  grep -qi microsoft /proc/version 2>/dev/null
}

detect_arch () {
  case "$(uname -m)" in
    x86_64|amd64) echo "amd64" ;;
    aarch64|arm64) echo "arm64" ;;
    *) echo "unknown" ;;
  esac
}

install_apt_packages () {
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "apt-get が見つかりません。必須/推奨パッケージは手動でインストールしてください（README.md参照）。" >&2
    return
  fi

  local missing=()
  local cmd pkg
  for cmd pkg in "${(@kv)APT_PACKAGES}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$pkg")
    fi
  done

  if is_wsl && ! command -v wslview >/dev/null 2>&1; then
    missing+=("wslu")
  fi

  if (( ${#missing[@]} == 0 )); then
    echo "apt パッケージは全てインストール済みです。"
    return
  fi

  echo "apt でインストールします: ${missing[*]}"
  sudo apt-get update
  if ! sudo apt-get install -y "${missing[@]}"; then
    echo "警告: 一部の apt パッケージのインストールに失敗しました。手動でインストールしてください。" >&2
  fi
}

install_sheldon () {
  if command -v sheldon >/dev/null 2>&1; then
    echo "sheldon はインストール済みです。"
    return
  fi
  echo "sheldon をインストールします..."
  mkdir -p "$LOCAL_BIN"
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to "$LOCAL_BIN"
}

install_ghq () {
  if command -v ghq >/dev/null 2>&1; then
    echo "ghq はインストール済みです。"
    return
  fi
  echo "ghq をインストールします..."
  local arch=$(detect_arch)
  if [[ "$arch" == "unknown" ]]; then
    echo "警告: 未対応のアーキテクチャのため ghq を自動インストールできません。" >&2
    return
  fi

  local tmpdir=$(mktemp -d)
  local version=$(curl -s https://api.github.com/repos/x-motemen/ghq/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
  local asset="ghq_linux_${arch}.zip"
  local url="https://github.com/x-motemen/ghq/releases/download/${version}/${asset}"

  if curl -fLsS -o "$tmpdir/$asset" "$url" && python3 -m zipfile -e "$tmpdir/$asset" "$tmpdir"; then
    mkdir -p "$LOCAL_BIN"
    mv "$tmpdir"/ghq_linux_${arch}/ghq "$LOCAL_BIN/ghq"
    chmod +x "$LOCAL_BIN/ghq"
    echo "ghq を $LOCAL_BIN/ghq にインストールしました。"
  else
    echo "警告: ghq のダウンロードに失敗しました。手動でインストールしてください。" >&2
  fi
  rm -rf "$tmpdir"
}

install_nvim () {
  if command -v nvim >/dev/null 2>&1; then
    echo "nvim はインストール済みです。"
    return
  fi
  echo "nvim (AppImage) をインストールします..."
  local arch=$(detect_arch)
  local nvim_arch
  case "$arch" in
    amd64) nvim_arch="x86_64" ;;
    arm64) nvim_arch="arm64" ;;
    *)
      echo "警告: 未対応のアーキテクチャのため nvim を自動インストールできません。" >&2
      return
      ;;
  esac

  local tmpdir=$(mktemp -d)
  local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.appimage"

  if curl -fLsS -o "$tmpdir/nvim.appimage" "$url"; then
    sudo mkdir -p /opt/nvim
    sudo mv "$tmpdir/nvim.appimage" /opt/nvim/nvim
    sudo chmod +x /opt/nvim/nvim
    echo "nvim を /opt/nvim/nvim にインストールしました。"
  else
    echo "警告: nvim のダウンロードに失敗しました。手動でインストールしてください。" >&2
  fi
  rm -rf "$tmpdir"
}

install_chezmoi () {
  if command -v chezmoi >/dev/null 2>&1; then
    echo "chezmoi はインストール済みです。"
    return
  fi
  echo "chezmoi をインストールします..."
  mkdir -p "$LOCAL_BIN"
  if ! sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$LOCAL_BIN"; then
    echo "警告: chezmoi のインストールに失敗しました。手動でインストールしてください。" >&2
  fi
}

install_dependencies () {
  echo "== 必須/推奨パッケージのインストールを開始します =="
  install_apt_packages
  install_sheldon
  install_ghq
  install_nvim
  install_chezmoi
  echo "== パッケージのインストールが完了しました =="
}

setup_symlink () {
  local file="$1"
  local target="$DOTFILES_REPO/$file"

  if [ -L "$HOME/$file" ]; then
    echo "Removing existing symlink: $HOME/$file"
    unlink "$HOME/$file"
  elif [ -e "$HOME/$file" ]; then
    echo "Backing up existing dotfile: $HOME/$file"
    mv "$HOME/$file" "$HOME/$file.bak"
  fi

  echo "Creating symlink: $HOME/$file -> $target"
  ln -s "$target" "$HOME/$file"
}
# Gitリポジトリが存在しない場合は終了
if [ ! -d "$DOTFILES_REPO" ]; then
  echo "Dotfiles repository not found: $DOTFILES_REPO"
  exit 1
fi

install_dependencies

# 各ドットファイルに対してシンボリックリンクを作成
for file in $DOTFILES; do
  setup_symlink "$file"
done
