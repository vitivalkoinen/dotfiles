# CLAUDE.md

このファイルは、このリポジトリでコードを扱う際にClaude Code (claude.ai/code) に向けたガイダンスを提供します。

## 応答言語について

このリポジトリでの作業では、原則として日本語で応答してください。

## コミット単位について

人間が10分程度で読み切れるレベルの単位でコミットを生成してください。

## リポジトリ構成について

このリポジトリは[chezmoi](https://www.chezmoi.io/)ベースで管理されています。`.chezmoiroot`により`home/`ディレクトリが実際のchezmoiソースディレクトリであり、リポジトリ直下の`README.md`/`SPEC.md`/`CLAUDE.md`等はchezmoiの管理対象外です。`home/dot_*`がdotfile本体、`home/run_once_before_*.sh.tmpl`が依存パッケージのインストールスクリプトです。詳細な要件は`SPEC.md`を参照してください。
