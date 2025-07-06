[English](scripts.en.md) | 日本語

# スクリプトリファレンス

## 🎯 manage-presentation.sh（推奨）

プレゼンテーションの作成・更新を統合管理するメインスクリプトです。自動判定により適切な処理を実行します。

### 使用方法

```bash
./scripts/manage-presentation.sh [オプション] <プレゼンテーション名>
```

### 自動判定機能

- **既存チェック**: 指定されたプレゼンテーションが存在するかを自動判定
- **適切な処理**: 新規なら作成、既存なら適切な更新提案
- **エラー回避**: ユーザーが存在を意識する必要がない

### オプション

| オプション | 説明 | 例 |
|-----------|------|-----|
| `--create` | 強制作成モード（既存の場合はエラー） | `--create` |
| `--update` | 強制更新モード（存在しない場合はエラー） | `--update` |
| `--template <name>` | 使用するテンプレートを指定 | `--template academic` |
| `--full` | 調査・分析・アイデア創出を含む完全構造 | `--full` |
| `--github` | GitHubリポジトリとして設定 | `--github` |
| `--public` | パブリックリポジトリ（--github使用時） | `--public` |
| `--workflow <type>` | GitHub Actionsワークフロー | `--workflow github-pages` |
| `--add-assets` | アセットディレクトリ構造を追加 | `--add-assets` |
| `--add-research` | 調査・分析・アイデア創出構造を追加 | `--add-research` |
| `--lang <code>` | 言語指定（ja, en） | `--lang en` |

### テンプレート一覧

- `basic` - 基本的なプレゼンテーション（デフォルト）
- `academic` - 学術発表用（研究背景、手法、結果）
- `business` - ビジネス提案用（問題、解決策、効果）
- `full-project` - 完全プロジェクト構造（調査から実装まで）

### ワークフロータイプ

- `basic` - 基本的なPDF/HTML生成
- `full-featured` - 複数フォーマット対応、分析ツール連携
- `multi-language` - 多言語対応ビルド
- `github-pages` - GitHub Pages公開用

### 使用例

#### 基本的な使用

```bash
# 自動判定（推奨）
./scripts/manage-presentation.sh my-talk

# GitHub連携（新規なら作成、既存なら追加）
./scripts/manage-presentation.sh --github conference-2024

# フルプロジェクト構造
./scripts/manage-presentation.sh --full research-project
```

#### 明示的なモード

```bash
# 強制作成（既存の場合はエラー）
./scripts/manage-presentation.sh --create new-presentation

# 強制更新（存在しない場合はエラー）
./scripts/manage-presentation.sh --update existing-presentation --workflow github-pages

# 構造の拡張
./scripts/manage-presentation.sh --add-assets --add-research my-project
```

#### GitHub Pages対応

```bash
# GitHub Pages専用ワークフローで作成
./scripts/manage-presentation.sh --github --workflow github-pages portfolio-2024

# 既存プレゼンテーションをGitHub Pages対応に更新
./scripts/manage-presentation.sh --update --workflow github-pages existing-talk
```

> 💡 **実例**: [AutoSlideIdeaデモサイト](https://dobachi.github.io/AutoSlideIdea/)でGitHub Pages出力を確認

## create-presentation.sh（非推奨）

互換性のため残されているwrapperスクリプトです。`manage-presentation.sh --create`に自動転送されます。

### 使用方法

```bash
./scripts/create-presentation.sh [オプション] <プレゼンテーション名>
```

**⚠️ 警告**: このスクリプトは非推奨です。`manage-presentation.sh`の使用を推奨します。

## update-presentation.sh（非推奨）

互換性のため残されているwrapperスクリプトです。`manage-presentation.sh --update`に自動転送されます。

### 使用方法

```bash
./scripts/update-presentation.sh [オプション] <プレゼンテーション名またはパス>
```

**⚠️ 警告**: このスクリプトは非推奨です。`manage-presentation.sh`の使用を推奨します。

## build.sh

プレゼンテーションをビルドするためのヘルパースクリプトです。

### 使用方法

```bash
./scripts/build.sh <入力ファイル> [出力ファイル]
```

### 機能

- Marpのラッパーとして動作
- デフォルトの出力設定
- エラーハンドリング

### 使用例

```bash
# PDFを生成（デフォルト）
./scripts/build.sh presentations/my-talk/slides.md

# HTMLを生成
./scripts/build.sh presentations/my-talk/slides.md output.html

# カスタムオプション付き
./scripts/build.sh presentations/my-talk/slides.md --theme custom.css
```

## 環境変数

すべてのスクリプトで以下の環境変数を使用できます：

| 変数名 | 説明 | デフォルト |
|--------|------|-----------|
| `AUTOSLIDE_LANG` | デフォルト言語設定 | `ja` |
| `AUTOSLIDE_TEMPLATE` | デフォルトテンプレート | `basic` |

### 設定例

```bash
# 英語をデフォルトに設定
export AUTOSLIDE_LANG=en

# .bashrcや.zshrcに追加して永続化
echo 'export AUTOSLIDE_LANG=en' >> ~/.bashrc
```

## 移行ガイド

### 従来スクリプトから統合スクリプトへ

| 従来 | 統合版 |
|------|-------|
| `create-presentation.sh my-talk` | `manage-presentation.sh my-talk` |
| `create-presentation.sh --github talk` | `manage-presentation.sh --github talk` |
| `update-presentation.sh --add-github talk` | `manage-presentation.sh --github talk` |
| `update-presentation.sh --workflow github-pages talk` | `manage-presentation.sh --workflow github-pages talk` |

### 自動転送の仕組み

従来スクリプトは以下のように動作します：

1. 非推奨警告を表示
2. 適切なオプション付きで`manage-presentation.sh`に転送
3. 処理を実行

## トラブルシューティング

### 権限エラー

```bash
# スクリプトに実行権限を付与
chmod +x scripts/*.sh
```

### パスが見つからない

```bash
# プロジェクトルートから実行
cd /path/to/AutoSlideIdea
./scripts/manage-presentation.sh my-talk
```

### GitHub CLIエラー

```bash
# GitHub CLIのインストール確認
gh --version

# 認証状態の確認
gh auth status
```

### 自動判定の動作確認

```bash
# 存在しない場合の動作確認
./scripts/manage-presentation.sh non-existing-presentation

# 既存の場合の動作確認（テスト用）
mkdir -p presentations/test-existing
./scripts/manage-presentation.sh test-existing
```

## ベストプラクティス

### 1. 統合スクリプトの活用

- 🎯 `manage-presentation.sh`を優先的に使用
- 自動判定機能を活用してシンプルな操作を実現
- 明示的モードは確実性が必要な場合のみ使用

### 2. ワークフロー設計

```bash
# 開発フロー例
./scripts/manage-presentation.sh my-talk          # 作成
./scripts/manage-presentation.sh --github my-talk # GitHub連携追加
./scripts/manage-presentation.sh --workflow github-pages my-talk # Pages対応
```

### 3. チーム開発

```bash
# チームメンバーは統一された方法で操作
./scripts/manage-presentation.sh --github --public team-presentation
```

## カスタマイズ

### 新しいテンプレートの追加

1. `templates/`ディレクトリに新しいフォルダを作成
2. 必要なファイルを配置（slides.md, README.md など）
3. プレースホルダーを使用（`{{PRESENTATION_NAME}}`, `{{DATE}}`）

### ワークフローのカスタマイズ

1. `templates/github-workflows/`に新しいYAMLファイルを作成
2. manage-presentation.shの`--workflow`オプションで使用可能に

## 関連ドキュメント

- [作業フロー](workflow.md)
- [GitHub Pages連携](github-pages.md)
- [Tips & Tricks](tips.md)