# SPEC.md — dotfiles 要件定義

このドキュメントは、本リポジトリを「WSL開発環境をコマンド一発で再現・配布できるdotfiles」として再構築するための要件定義です。実装に着手する前の合意事項をまとめたものであり、実装の詳細（ファイル名やテンプレート構文の細部）は実装時に本ドキュメントと矛盾しない範囲で調整可能とします。

## 1. 目的

- WSL（Ubuntu/Debian系）上の開発シェル環境を、新しいマシン/WSLディストロでも `git clone` + 1コマンドで再現できるようにする。
- 自分以外の環境（仕事用PC・個人用PCなど複数マシン）でも使えるよう、最低限のプロファイル分岐を持たせる。
- 個人配布を前提とし、過剰な汎用化（他OS対応やチーム配布向けの作り込み）はしない。

## 2. スコープ

### 2.1 対象プラットフォーム

- **WSL（Ubuntu/Debian系ディストロ）に特化する。** ネイティブLinuxやmacOSは対象外。
- `apt-get` が使える前提を維持してよい。他パッケージマネージャーへの対応は行わない。

### 2.2 対象外（Non-goals）

- macOS / 他Linuxディストロ（Fedora, Arch等）への対応
- チーム/組織での配布を想定した高度な設定（secrets管理基盤、SSO連携等）
- Windows側（Windows Terminalの設定ファイル、フォントの実ファイル配置）の完全自動化。WSL側から行える範囲（後述）に留める

## 3. 管理方式の刷新: chezmoiへの移行

現行の自作 `setup.zsh`（シンボリックリンク張り替え + apt一括インストール + 個別installer関数）から **[chezmoi](https://www.chezmoi.io/)** ベースの管理に移行する。

### 3.1 移行理由

- テンプレート機能（`.tmpl`）でマシン/プロファイルごとの値の差し込みが標準サポートされている
- `run_once_`/`run_onchange_` スクリプトで「パッケージインストールなどdotfile配置以外の手続き」をchezmoiのライフサイクルに統合できる
- `chezmoi init --apply <repo>` の1コマンドでブートストラップが完結し、「コマンド一発で再現可能」という目的に最も合致する
- 独自スクリプトの保守（symlink処理、bak退避処理等）から解放される

### 3.2 リポジトリ構成の変更

chezmoiのソースディレクトリ構造（`dot_` prefixによるdotfile表現、`run_once_*`によるスクリプト表現）を採用する。現行の `setup.zsh` は廃止し、役割を以下のように分割する。

| 現行 | 移行後 |
| --- | --- |
| `DOTFILES`配列 + `setup_symlink` | chezmoiの`dot_*`ファイル（自動でシンボリックリンクではなく実体コピー管理になる点に注意。symlink運用を維持したい場合は`symlink_`prefixを使う） |
| `install_apt_packages` | `run_once_before_10-install-apt-packages.sh.tmpl` |
| `install_sheldon` / `install_ghq` / `install_nvim` | `run_once_before_2x-install-<tool>.sh.tmpl`（ツールごとに分割し、既存の「コマンドが既に存在すればスキップ」ロジックを踏襲） |
| `is_wsl` / `detect_arch` | chezmoiのtemplate関数 or 共通シェルスニペットとして`.chezmoidata.yaml`/スクリプト内に保持 |

### 3.3 パッケージ・ツールのバージョン方針

- 現行踏襲で **常に最新版を取得する**（sheldon/ghq/nvim/starship等のバージョン固定は行わない）。
- 「再現可能」とは「同じ手順・同じ構成が再現される」ことを指し、「寸分違わぬバイナリバージョンの再現」までは求めない。

### 3.4 プラグインマネージャーの位置づけ

- 現行通り `sheldon` を採用するが、将来的に他の選択肢に乗り換える可能性を考慮し、Zshプラグイン管理のロジックは `.zshrc` 側で「プラグインマネージャー呼び出し」を1箇所に集約し、差し替えが容易な構造にする（設計の努力目標。今回のスコープで抽象化レイヤーを新設するところまでは求めない）。

## 4. マルチプロファイル対応

### 4.1 要件

- 仕事用PC・個人用PCなど、**複数マシンでの使い分けを本格的に対応する。**
- chezmoiの `.chezmoi.toml.tmpl`（`chezmoi init` 時の対話プロンプト、`promptString`等）を用いて、マシンごとのプロファイル値を取得・保持する。

### 4.2 初期対応する分岐値

初回実装では以下を分岐対象とする（将来的に増やす場合はこのSPECを更新の上で拡張する）。

- `.gitconfig` の `user.name` / `user.email`
- プロファイル種別（例: `work` / `personal`）を表す変数。この変数を使って、将来的にインストールするパッケージの取捨選択（例: 仕事用のみ特定ツールを入れる）ができる下地を用意する。ただし初回実装で具体的な差分パッケージが決まっていなければ、分岐の受け口だけ用意し中身は空でよい。

## 5. 管理対象dotfile/設定の拡大

現行の `.zshrc` のみから、以下を管理対象に追加する。

| 追加対象 | 内容 |
| --- | --- |
| `.gitconfig` | `user.name`/`user.email` をテンプレート変数化。それ以外（alias, core設定等）は固定値でよい |
| Neovim設定一式 | `init.lua` 等。**新規に最小構成を作成する**（既存の移植ではない）。プラグインなし、基本オプション設定とキーマップ程度のスコープ |
| `.tmux.conf` | tmuxを新規に依存パッケージへ追加し、設定ファイルも管理対象にする。プラグインマネージャー（TPM等）の要否は実装時に決める簡易スコープでよい |

## 6. WSL周辺対応

setup（chezmoiのrun_once script）に以下を加える。

- **Nerd Fontインストール補助**: eza/starshipのアイコン表示に必要なNerd Fontを、WSLのLinux側からWindows側フォントディレクトリへ配置する、またはダウンロードして案内するスクリプトを用意する（Windows側の設定適用＝レジストリ登録やフォント有効化まではLinux側から直接操作できないため、「配置 + 手動でのインストール手順案内」までをスコープとする）。
- **win32yank連携**: WSLでのクリップボード連携（vim/nvimのヤンク等）のため `win32yank.exe` を導入し、`.zshrc`または`init.lua`から参照できるようにする。

## 7. CI（自動検証）

- **GitHub Actionsを要件に含める。**
- Ubuntuコンテナ上で `chezmoi init --apply` 相当（ローカルリポジトリを対象にした適用）を実行し、以下を確認する:
  - スクリプトがエラーなく完走すること
  - 一度適用した状態で再度適用してもエラーにならないこと（べき等性）
- 費用面: GitHub Actionsはパブリックリポジトリなら無料無制限、プライベートでもFreeプランで月2,000分の無料枠がありLinuxランナーは等倍消費のため、このリポジトリの用途では無償枠で十分。

## 8. セットアップ手順（移行後のゴールイメージ）

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply <github-user>/dotfiles
```

の1コマンドで、依存パッケージのインストールとdotfile配置が完了する状態を目指す。

## 9. 移行計画（概要）

1. chezmoiをリポジトリの依存インストール対象に追加（`APT_PACKAGES`相当、あるいはchezmoi自体のインストールスクリプト）
2. 現行 `.zshrc` を `dot_zshrc` としてchezmoi管理下に移す
3. `install_apt_packages` / `install_sheldon` / `install_ghq` / `install_nvim` を `run_once_before_*.sh.tmpl` に分割移植
4. `.gitconfig.tmpl` を新規作成し、`.chezmoi.toml.tmpl` でプロンプト経由の変数入力を実装
5. Neovim最小構成・`.tmux.conf` を新規作成し管理対象に追加
6. Nerd Font導入補助・win32yank連携スクリプトを追加
7. GitHub Actionsワークフローを追加し、コンテナ内適用のべき等性を検証
8. README.md / CLAUDE.mdを新構成に合わせて更新し、旧 `setup.zsh` を削除

## 10. 未決事項・今後の検討事項

- work/personalプロファイルで実際にどのパッケージ/設定を差し替えるかの具体的なリスト
- tmuxのプラグインマネージャー要否
- Nerd Fontの具体的な配布方法（手動配置案内 vs 自動配置の可否）
