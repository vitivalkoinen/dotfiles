# Viti's dotfiles

## Dependencies

このdotfilesを使用するには以下のパッケージが必要です。
[chezmoi](https://www.chezmoi.io/)の`run_once_before_*`スクリプトにより、必須パッケージと推奨パッケージは`chezmoi apply`実行時に自動でインストールされます（`### 開発環境（オプション）` は対象外のため手動でインストールしてください）。

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
- **[chezmoi](https://www.chezmoi.io/)** - dotfiles管理ツール
- **[tmux](https://github.com/tmux/tmux)** - ターミナルマルチプレクサ

### 推奨パッケージ

- **[Github CLI](https://cli.github.com/)** - GitHub CLI
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - 高速なテキスト検索ツール

### 開発環境（オプション）

- **[Go](https://golang.org/)** - Go言語
- **[Rust](https://www.rust-lang.org/)** - Rust言語

### WSL環境（WSL使用時）

- **`wslview`** - WSL用ブラウザランチャー。[wslu](https://github.com/wslutilities/wslu)パッケージには依存せず、`~/.local/bin/wslview`として配置される軽量なスクリプトで代替しています（追加のパッケージインストールは不要です）。

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

以下のコマンド一発でセットアップが完了します（[chezmoi](https://www.chezmoi.io/)公式インストールスクリプトによりchezmoi自体の導入から行われます）。

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply vitivalkoinen/dotfiles
```

実行すると`chezmoi init`の対話プロンプトで`name`（Git用の名前）/`email`（Gitのメールアドレス）/`profile`（`work`または`personal`。マシンの用途を表す値）の入力を求められます。入力後、必須/推奨パッケージが未インストールであれば自動でインストールされ、続けてdotfileの配置が行われます（`apt` が使えない環境や対応外のアーキテクチャの場合は、その旨が表示されるので手動でインストールしてください）。一部のパッケージ（apt経由のパッケージ、nvim）のインストールには `sudo` 権限が必要です。

他のマシンで自分以外のGitHubユーザーのdotfilesを使う場合は、コマンド中の`vitivalkoinen/dotfiles`を対象のGitHubユーザー名/リポジトリ名に置き換えてください。
