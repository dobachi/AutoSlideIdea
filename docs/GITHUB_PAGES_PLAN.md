# GitHub Pagesドキュメントサイト構築計画

## 📋 プロジェクト概要

AutoSlideIdeaの公式ドキュメントサイトをGitHub Pagesで構築し、プロジェクトの使い方、機能、開発情報を体系的に提供する。

## 🎯 目標

1. **使いやすさ**: 初心者でも簡単に始められる明確なガイド
2. **包括性**: すべての機能とワークフローを網羅
3. **多言語対応**: 日本語と英語の両方をサポート
4. **検索可能**: サイト内検索機能の実装
5. **美しいデザイン**: プロフェッショナルな見た目

## 🏗️ サイト構造案

```
AutoSlideIdea Documentation
├── Home (ランディングページ)
│   ├── プロジェクト概要
│   ├── 主要機能の紹介
│   └── クイックスタート
├── Getting Started
│   ├── インストール
│   ├── 基本的な使い方
│   └── 最初のプレゼンテーション作成
├── User Guide
│   ├── Markdownでのスライド作成
│   ├── テーマの使い方
│   ├── Mermaid図表の活用
│   └── エクスポート機能
├── SlideFlow
│   ├── SlideFlowとは
│   ├── コマンドリファレンス
│   ├── AI支援機能
│   └── フェーズ管理
├── Advanced Topics
│   ├── AI指示書システム
│   ├── GitHub Actions連携
│   ├── カスタムテーマ作成
│   └── 拡張機能
├── API Reference
│   ├── スクリプトリファレンス
│   └── 設定オプション
├── Development
│   ├── コントリビューションガイド
│   ├── 開発環境構築
│   ├── ロードマップ
│   └── アーキテクチャ
└── Resources
    ├── FAQ
    ├── トラブルシューティング
    ├── 事例集
    └── リンク集
```

## 🛠️ 技術スタック候補

### 1. **MkDocs Material** (推奨)
- **利点**: 
  - Markdownネイティブ
  - 美しいMaterial Designテーマ
  - 多言語対応が簡単
  - 検索機能内蔵
  - GitHub Actionsとの統合が容易
- **設定例**:
  ```yaml
  site_name: AutoSlideIdea Documentation
  theme:
    name: material
    language: ja
    features:
      - navigation.tabs
      - search.suggest
      - content.code.copy
  ```

### 2. **Docusaurus**
- **利点**: 
  - React ベース
  - バージョニング機能
  - ブログ機能
- **欠点**: 
  - 設定が複雑
  - ビルド時間が長い

### 3. **VitePress**
- **利点**: 
  - Vue 3ベース
  - 高速なビルド
  - シンプルな設定
- **欠点**: 
  - 比較的新しい

## 📅 実装フェーズ

### Phase 1: 基盤構築（1週目）
1. MkDocs Materialのセットアップ
2. 基本的なサイト構造の作成
3. GitHub Actions自動デプロイ設定
4. 多言語サポートの実装

### Phase 2: コンテンツ移行（2週目）
1. 既存ドキュメントの整理・移行
2. ナビゲーション構造の最適化
3. 内部リンクの修正
4. 画像・アセットの整理

### Phase 3: 機能強化（3週目）
1. 検索機能の最適化
2. コードハイライトの改善
3. インタラクティブな例の追加
4. ダークモードサポート

### Phase 4: 公開準備（4週目）
1. レビューと修正
2. SEO最適化
3. アナリティクス設定
4. 正式公開

## 🎨 デザイン方針

1. **カラースキーム**: 
   - プライマリ: #2E86AB (青)
   - セカンダリ: #A23B72 (ピンク)
   - アクセント: #F18F01 (オレンジ)

2. **タイポグラフィ**: 
   - 見出し: Noto Sans JP
   - 本文: システムフォント

3. **レイアウト**: 
   - レスポンシブデザイン
   - サイドバーナビゲーション
   - 固定ヘッダー

## 📂 ディレクトリ構造

```
/docs-site/              # MkDocsプロジェクトルート
├── mkdocs.yml          # MkDocs設定
├── docs/               # ドキュメントソース
│   ├── index.md        # ホームページ
│   ├── getting-started/
│   ├── user-guide/
│   ├── slideflow/
│   ├── advanced/
│   ├── api/
│   ├── development/
│   └── resources/
├── overrides/          # カスタムテーマ
└── site/              # ビルド出力（.gitignore）
```

## 🚀 デプロイ設定

### GitHub Actions Workflow
```yaml
name: Deploy Documentation
on:
  push:
    branches: [main]
    paths:
      - 'docs-site/**'
      - '.github/workflows/docs.yml'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
      - run: pip install mkdocs-material
      - run: cd docs-site && mkdocs gh-deploy --force
```

## 📋 必要なアクション

1. [ ] MkDocs Materialのインストールと初期設定
2. [ ] 基本的なサイト構造の作成
3. [ ] GitHub Actionsワークフローの設定
4. [ ] 既存ドキュメントの移行開始
5. [ ] カスタムCSSとテーマの調整
6. [ ] 多言語切り替え機能の実装

## 🔗 参考リンク

- [MkDocs Material公式](https://squidfunk.github.io/mkdocs-material/)
- [GitHub Pages設定ガイド](https://docs.github.com/ja/pages)
- [MkDocs多言語対応](https://www.mkdocs.org/user-guide/localizing-your-theme/)

---

この計画に基づいて、美しく機能的なドキュメントサイトを構築します。