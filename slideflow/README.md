# SlideFlow - Phase 0 (超最小MVP)

[🇬🇧 English Version](README.en.md)

## 概要

SlideFlowは、Markdownベースのシンプルさを追求したプレゼンテーション管理ツールです。
このPhase 0版は、最小限の機能で動作確認を行うためのプロトタイプです。

## インストール

```bash
# 1. リポジトリのクローン
git clone https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea/slideflow

# 2. 実行権限の付与
chmod +x slideflow.sh

# 3. パスを通す（オプション）
export PATH="$PATH:$(pwd)"
```

## 言語設定

SlideFlowは日本語と英語に対応しています。環境変数`LANG`または`SLIDEFLOW_LANG`で言語を指定できます。

```bash
# 英語で使用
export LANG=en_US.UTF-8
./slideflow.sh help

# 日本語で使用（デフォルト）
export LANG=ja_JP.UTF-8
./slideflow.sh help

# 一時的に言語を変更
LANG=en slideflow.sh help
```

## 使い方

### 新しいプレゼンテーションを作成

```bash
# デフォルト名で作成
./slideflow.sh new

# 名前を指定して作成
./slideflow.sh new my-presentation

# パスを指定して作成
./slideflow.sh new projects/conference-2024
```

### プレビューサーバーを起動

```bash
cd ../presentations/my-presentation
../../slideflow/slideflow.sh preview
# ブラウザで http://localhost:8000 を開く
```

### 作成済みプレゼンテーションを一覧表示

```bash
# デフォルト（presentationsディレクトリ）
./slideflow.sh list

# 特定のディレクトリを検索
./slideflow.sh list /path/to/directory
./slideflow.sh list .
```

### 利用可能なテンプレートを表示

```bash
./slideflow.sh templates
```

### AI支援

```bash
# 対話的フェーズ支援
./slideflow.sh ai

# クイック支援
./slideflow.sh ai --quick tech
```

## コマンド一覧

- `new [path]` - 新しいプレゼンテーションを作成
- `preview [path]` - プレゼンテーションをプレビュー
- `ai [options] [path]` - AI支援
- `build [format] [path]` - プレゼンテーションをビルド
- `info [path]` - プレゼンテーション情報を表示
- `list [path]` - 作成済みプレゼンテーションを一覧表示
- `templates` - 利用可能なテンプレートを表示
- `instructions` - AI指示書システムの状況確認
- `help` - ヘルプを表示

## 特徴

- 🎯 **シンプル**: 100行以下の単一スクリプト
- 📝 **Markdownファースト**: すべてのコンテンツはMarkdownで管理
- 🔄 **既存ツール活用**: AutoSlideIdeaの機能を活用
- 🤖 **AI対応**: Claude Code/Gemini CLIとの連携を想定

## 技術仕様

- **言語**: Bash
- **依存関係**: 
  - Python 3（プレビューサーバー用）
  - AutoSlideIdeaのスクリプト群
- **サイズ**: 約100行

## 設定

### プレゼンテーションディレクトリのカスタマイズ

プレゼンテーションを保存するデフォルトディレクトリをカスタマイズできます：

```bash
# 環境変数で設定（一時的）
export SLIDEFLOW_PRESENTATIONS_DIR=/path/to/my/presentations

# 設定ファイルで設定（永続的）
./slideflow.sh config set presentations_dir=/path/to/my/presentations

# コマンド実行時に指定
./slideflow.sh --presentations-dir /path/to/my/presentations new
```

### 設定管理

```bash
# 現在の設定を表示
./slideflow.sh config list

# 特定の設定値を取得
./slideflow.sh config get presentations_dir

# 設定値を変更
./slideflow.sh config set preview_port=3000
./slideflow.sh config set default_template=academic
```

### 設定の優先順位

1. コマンドラインオプション (`--presentations-dir`)
2. 環境変数 (`SLIDEFLOW_PRESENTATIONS_DIR`)
3. 設定ファイル (`~/.slideflow/config`)
4. デフォルト値

## 開発ドキュメント

- [コマンド体系の設計考察](/docs/slideflow/COMMAND_DESIGN.md) - コマンド設計の詳細と改善提案

## 今後の計画

これはPhase 0（超最小MVP）です。今後の開発計画：

1. **Phase 1**: Bashスクリプト版の機能拡張
2. **Phase 2**: Node.js移行
3. **Phase 3**: インタラクティブ機能
4. **Phase 4**: AI統合強化
5. **Phase 5**: プロダクション準備

詳細は[開発ロードマップ](../docs/development/slideflow-roadmap.md)を参照してください。

## ライセンス

MIT License（AutoSlideIdeaプロジェクトに準拠）

---

作成日: 2025-01-05
バージョン: 0.0.1 (Phase 0)