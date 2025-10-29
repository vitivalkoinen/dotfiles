# Viti's dotfiles

## Dependencies

このdotfilesを使用するには以下のパッケージが必要です：

### 必須パッケージ

- **[zsh](https://www.zsh.org/)** - メインシェル
- **[sheldon](https://github.com/rossmacarthur/sheldon)** - Zshプラグインマネージャー
- **[starship](https://starship.rs/)** - カスタムプロンプト
- **[fzf](https://github.com/junegunn/fzf)** - ファジーファインダー
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - ディレクトリジャンプツール
- **[ghq](https://github.com/x-motemen/ghq)** - Gitリポジトリ管理ツール
- **[eza](https://github.com/eza-community/eza)** - `ls`の代替
- **[bat](https://github.com/sharkdp/bat)** - `cat`の代替
- **[git](https://git-scm.com/)** - バージョン管理
- **[nvim](https://neovim.io/)** - Neovim (AppImageでのインストール必須)

### 推奨パッケージ

- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - 高速なテキスト検索ツール

### 開発環境（オプション）

- **[Go](https://golang.org/)** - Go言語
- **[Rust](https://www.rust-lang.org/)** - Rust言語

### WSL環境（WSL使用時）

- **[wslview](https://github.com/wslutilities/wslu)** - WSL用ブラウザランチャー

## Setup guide

1. Clone this repository in user home directory

    ```sh
    git clone https://github.com/vitivalkoinen/dotfiles.git 
    ```

1. Go to the `~/dotfiles` directory

    ```sh
    cd ~/dotfiles
    ```

1. Run `setup.zsh`

    ```sh
    zsh setup.zsh
    ```
