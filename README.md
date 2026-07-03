# Viti's dotfiles

## Dependencies

このdotfilesを使用するには以下のパッケージが必要です。
`setup.zsh` を実行すると、必須パッケージと推奨パッケージは自動でインストールされます（`### 開発環境（オプション）` は対象外のため手動でインストールしてください）。

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

- **[Github CLI](https://cli.github.com/)** - GitHub CLI
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - 高速なテキスト検索ツール

### 開発環境（オプション）

- **[Go](https://golang.org/)** - Go言語
- **[Rust](https://www.rust-lang.org/)** - Rust言語

### WSL環境（WSL使用時）

- **[wslview](https://github.com/wslutilities/wslu)** - WSL用ブラウザランチャー

## Aliases

`.zshrc` では以下のエイリアス・関数を設定しています。

### 基本コマンド

| エイリアス | 実体 | 説明 |
| --- | --- | --- |
| `ls` | `eza` | `ls`を`eza`に置き換え |
| `ll` | `ls -alF` | 詳細表示 |
| `la` | `ls -A` | 隠しファイルも表示 |
| `l` | `ls -CF` | シンプルな一覧表示 |
| `cd` | `z` | `zoxide`によるディレクトリジャンプ |
| `..` | `cd ..` | 一つ上の階層へ移動 |
| `...` | `cd ../..` | 二つ上の階層へ移動 |
| `cat` | `batcat --paging=never` | `cat`を`bat`に置き換え（ページャなし） |
| `vim` | `nvim` | `vim`を`neovim`に置き換え |
| `grep` | `grep --color=auto` | マッチ箇所を色付け |

### Git エイリアス

| エイリアス | 実体 |
| --- | --- |
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git log --oneline --graph` |
| `gco` | `git checkout` |
| `gb` | `git branch` |
| `gd` | `git diff` |

### ghqリポジトリジャンプ

`Ctrl + ]` で`ghq list`から`fzf`を使ってリポジトリを選択し、そのディレクトリへ移動できます（プレビューで詳細を確認可能）。

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

    必須/推奨パッケージが未インストールの場合は自動でインストールされます（`apt` が使えない環境や対応外のアーキテクチャの場合は、その旨が表示されるので手動でインストールしてください）。一部のパッケージ（apt経由のパッケージ、nvim）のインストールには `sudo` 権限が必要です。
