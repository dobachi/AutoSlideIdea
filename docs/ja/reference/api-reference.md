---
layout: default
title: API仕様
nav_order: 1
parent: リファレンス
grand_parent: 日本語
---

# API仕様

AutoSlideIdeaをプログラムから利用するためのAPIリファレンス

## SlideFlow CLI API

### 基本コマンド

#### `slideflow new <name>`
新しいプレゼンテーションを作成します。

**パラメータ:**
- `name`: プレゼンテーション名（必須）

**例:**
```bash
./slideflow/slideflow.sh new my-presentation
```

#### `slideflow build <format>`
プレゼンテーションをビルドします。

**パラメータ:**
- `format`: 出力形式（html, pdf, pptx）

**例:**
```bash
./slideflow/slideflow.sh build pdf
```

#### `slideflow preview`
プレビューサーバーを起動します。

**例:**
```bash
./slideflow/slideflow.sh preview
```

### 研究フェーズAPI

#### `slideflow research init`
調査ディレクトリを初期化します。

#### `slideflow research ai-search <query>`
AI支援によるWeb検索を実行します。

**パラメータ:**
- `query`: 検索クエリ（必須）

#### `slideflow research interactive`
インタラクティブ調査モードを開始します。

## 設定ファイル

### プレゼンテーション設定
各プレゼンテーションの`slides.md`ファイルのfront matter設定：

```yaml
---
marp: true
theme: default
paginate: true
backgroundColor: "#ffffff"
---
```

### グローバル設定
`.slideflow/config.yaml`でのグローバル設定：

```yaml
default_theme: default
output_directory: output
preview_port: 8000
```

## 戻り値

- **成功**: 終了コード 0
- **エラー**: 終了コード 1
- **無効な引数**: 終了コード 2