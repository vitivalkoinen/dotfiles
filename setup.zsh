if [[ -z ${ZSH_VERSION} ]]; then
  echo 'You must use zsh to run install.zsh' >&2
  exit 1
fi


DOTFILES_REPO="$HOME/dotfiles"
DOTFILES=(".zshrc" ".zimrc" ".zsh.d" ".zfunc")

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

# 各ドットファイルに対してシンボリックリンクを作成
for file in $DOTFILES; do
  setup_symlink "$file"
done
