---
layout: default
title: AI深層調査機能ガイド
nav_order: 4
parent: ガイド
grand_parent: 日本語
---

# AI深層調査機能ガイド

## 概要

SlideFlowのAI深層調査機能（`ai deep-research`）は、プレゼンテーション作成の調査フェーズに特化した専門ツールです。Web検索、ドキュメント分析、情報整理を統合的にサポートします。

## 基本的な使い方

### 1. 調査環境の初期化

プレゼンテーションディレクトリ内で調査環境を初期化します：

```bash
cd presentations/my-presentation
slideflow ai deep-research init
```

これにより、以下のディレクトリ構造が作成されます：

```
research/
├── sources/          # 情報源
│   ├── web/         # Web収集
│   ├── documents/   # ドキュメント
│   └── data/        # データファイル
├── notes/           # 調査メモ
├── ai-research/     # AI調査結果
└── analysis/        # 分析結果
```

### 2. AI Web検索

#### インタラクティブモード（デフォルト）

```bash
slideflow ai deep-research search "生成AIの最新トレンド"
```

Claude Codeが対話的に起動し、調査プロセスを確認しながら進められます。

#### 自動実行モード

```bash
slideflow ai deep-research search --auto "機械学習アルゴリズム"
```

バックグラウンドで自動的に検索・保存を実行します。

#### タイムアウト設定

```bash
# 10分（600秒）のタイムアウトで詳細調査
slideflow ai deep-research search -t 600 "ディープラーニングの応用事例"

# 複数オプションの組み合わせ
slideflow ai deep-research search --auto -t 900 "大規模言語モデル"
```

### 3. ドキュメント分析

PDF、テキストファイル、その他のドキュメントを分析：

```bash
slideflow ai deep-research analyze research-paper.pdf
slideflow ai deep-research analyze technical-spec.docx
```

### 4. 調査情報の管理

#### メモの追加

```bash
slideflow ai deep-research add-note "GPT-4の特徴：マルチモーダル対応、128kトークン"
```

#### ソース情報の記録

```bash
slideflow ai deep-research add-source "https://openai.com/research/gpt-4"
slideflow ai deep-research add-source "/path/to/local/document.pdf" document
```

#### 調査内容の確認

```bash
# 調査内容一覧
slideflow ai deep-research list

# サマリー表示
slideflow ai deep-research summary
```

## 高度な使用方法

### AIツールの優先順位

AI深層調査機能は以下の順序でAIツールを試行します：

1. Claude Code
2. Gemini
3. llm（汎用LLMコマンド）
4. Ollama
5. Continue
6. aider
7. GitHub Copilot

利用可能なツールが自動検出され、最適なものが使用されます。

### 調査セッションの管理

各調査は以下の形式でセッション管理されます：

```
ai-research/
└── 2025-01-07-143025-web-search/
    ├── query.txt        # 検索クエリ
    ├── metadata.json    # セッション情報
    ├── summary.md       # 調査結果
    └── raw-results/     # 生データ
```

### プレゼンテーションとの統合

調査結果は直接プレゼンテーション作成に活用できます：

```bash
# 調査フェーズ
slideflow ai deep-research search "プレゼンテーションのトピック"

# 調査結果を確認
slideflow ai deep-research summary

# プレゼンテーション作成フェーズへ
slideflow ai --phase creation
# → 調査結果を参照しながらスライド作成
```

## ベストプラクティス

### 1. 体系的な調査フロー

```bash
# 1. 初期化
slideflow ai deep-research init

# 2. 幅広い調査
slideflow ai deep-research search "トピックの概要"

# 3. 詳細調査
slideflow ai deep-research search -t 900 "具体的な技術詳細"

# 4. ドキュメント分析
slideflow ai deep-research analyze important-paper.pdf

# 5. 重要情報の記録
slideflow ai deep-research add-note "キーポイント"
slideflow ai deep-research add-source "https://source.url"

# 6. サマリー確認
slideflow ai deep-research summary
```

### 2. インタラクティブモードの活用

- デフォルトのインタラクティブモードでは、AIの動作を確認しながら進められます
- 必要に応じて追加指示を与えることができます
- 調査の方向性を途中で調整可能です

### 3. タイムアウトの適切な設定

- 簡単な調査: デフォルト（300秒）
- 詳細な調査: 600-900秒
- 包括的な調査: 1200秒以上

### 4. 調査結果の活用

調査結果は`research/`ディレクトリに構造化して保存されるため：
- 後から参照しやすい
- チームで共有可能
- プレゼンテーション作成時に直接引用できる

## トラブルシューティング

### Claude Codeが動作しない場合

1. Claude Codeがインストールされているか確認
2. 他のAIツール（Gemini、llmなど）が自動的に使用されます

### タイムアウトエラー

```bash
# タイムアウトを延長
slideflow ai deep-research search -t 1200 "複雑なトピック"
```

### ディレクトリエラー

```bash
# プレゼンテーションディレクトリ内で実行
cd presentations/my-presentation
slideflow ai deep-research init
```

## 関連コマンド

- `slideflow ai` - 包括的なAI支援機能
- `slideflow ai --phase research` - 調査フェーズの一般的な支援
- `slideflow new` - 新規プレゼンテーション作成