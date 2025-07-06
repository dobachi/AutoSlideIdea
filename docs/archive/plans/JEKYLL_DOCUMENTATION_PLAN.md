# Jekyll対応ドキュメント体系化計画

## 📋 概要

AutoSlideIdeaのドキュメントをJekyllで体系的に管理し、使いやすく美しいドキュメントサイトを構築します。

## 🎯 目標

1. **使いやすさ**: 初心者から上級者まで、必要な情報にすぐアクセスできる
2. **保守性**: 情報の重複を排除し、メンテナンスしやすい構造
3. **多言語対応**: 日本語と英語をシームレスに切り替え
4. **美しさ**: プロフェッショナルな見た目で信頼性を向上

## 🏗️ 新しいディレクトリ構造

```
docs/
├── _config.yml                    # Jekyll設定
├── _data/                        # データファイル
│   ├── navigation.yml           # ナビゲーション定義
│   └── i18n.yml                # 多言語対応データ
├── _includes/                    # 再利用可能なコンポーネント
│   ├── header.html
│   ├── footer.html
│   └── language-selector.html
├── _layouts/                     # レイアウトテンプレート
│   ├── default.html
│   ├── page.html
│   └── home.html
├── _sass/                        # スタイルシート
│   └── custom.scss
├── assets/                       # 静的ファイル
│   ├── css/
│   ├── js/
│   └── images/
├── index.md                      # ホームページ（日本語）
├── en/                          # 英語版
│   └── index.md
├── ja/                          # 日本語版（明示的）
│   ├── quickstart.md           # クイックスタート ⭐新規
│   ├── getting-started/        # 初心者向け
│   │   ├── installation.md     # インストール
│   │   ├── first-presentation.md # 最初のプレゼン
│   │   └── basic-concepts.md   # 基本概念
│   ├── user-guide/             # ユーザーガイド
│   │   ├── markdown-syntax.md  # Markdown記法
│   │   ├── themes.md           # テーマ使用法
│   │   ├── mermaid.md          # 図表作成
│   │   ├── export.md           # エクスポート
│   │   └── github-pages.md     # GitHub Pages公開
│   ├── slideflow/              # SlideFlow統合
│   │   ├── overview.md         # 概要
│   │   ├── commands.md         # コマンド一覧
│   │   ├── ai-support.md       # AI支援機能
│   │   └── phases.md           # フェーズ管理
│   ├── advanced/               # 高度な使い方
│   │   ├── ai-instructions.md  # AI指示書システム
│   │   ├── automation.md       # 自動化
│   │   ├── customization.md    # カスタマイズ
│   │   └── best-practices.md   # ベストプラクティス ⭐新規
│   ├── reference/              # リファレンス
│   │   ├── cli.md             # CLIリファレンス
│   │   ├── config.md          # 設定リファレンス ⭐新規
│   │   ├── templates.md       # テンプレート一覧 ⭐新規
│   │   └── api.md            # API（将来用）
│   ├── troubleshooting/       # トラブルシューティング ⭐新規
│   │   ├── common-issues.md   # よくある問題
│   │   └── faq.md            # FAQ
│   └── contributing/          # 貢献
│       ├── guidelines.md      # ガイドライン
│       ├── development.md     # 開発環境
│       └── localization.md    # 翻訳
├── planning/                    # 計画文書（別管理）
│   ├── github-pages-plan.md
│   ├── slideflow-roadmap.md
│   └── reorganization-plan.md
└── 404.html                    # 404ページ
```

## 🎨 Jekyllテーマ選定

### 推奨: Just the Docs

**理由**:
- ドキュメントサイト専用に設計
- 優れた検索機能
- レスポンシブデザイン
- 多言語対応が容易
- カスタマイズ性が高い

**代替案**:
1. **Minimal Mistakes** - 多機能で柔軟
2. **Documentation Theme** - シンプルで軽量
3. **Docsy Jekyll** - Google Docsy風

## 📝 _config.yml設定案

```yaml
# サイト設定
title: AutoSlideIdea Documentation
description: Markdownベースのシンプルなプレゼンテーション作成ツール
baseurl: "/AutoSlideIdea"
url: "https://dobachi.github.io"

# テーマ
remote_theme: just-the-docs/just-the-docs@v0.5.0

# 言語設定
lang: ja
languages: ["ja", "en"]
default_lang: "ja"

# Just the Docsの設定
search_enabled: true
search:
  heading_level: 2
  previews: 3
  preview_words_before: 5
  preview_words_after: 10

# ナビゲーション
nav_sort: case_sensitive

# カラースキーム
color_scheme: autoslideidea

# プラグイン
plugins:
  - jekyll-seo-tag
  - jekyll-sitemap
  - jekyll-redirect-from

# Markdown設定
markdown: kramdown
kramdown:
  syntax_highlighter: rouge
  syntax_highlighter_opts:
    block:
      line_numbers: true

# 除外ファイル
exclude:
  - "*.log"
  - "planning/"
  - "README.md"
```

## 🔄 移行計画

### Phase 1: 基盤構築（Week 1）
1. Jekyll設定ファイルの作成
2. Just the Docsテーマの導入
3. 基本レイアウトの構築
4. 多言語切り替え機能の実装

### Phase 2: コンテンツ移行（Week 2）
1. 既存ドキュメントの整理・統合
2. 新規ドキュメントの作成
   - クイックスタート
   - ベストプラクティス
   - トラブルシューティング
   - 設定リファレンス
3. 画像・アセットの整理

### Phase 3: 機能強化（Week 3）
1. 検索機能の最適化
2. サイドバーナビゲーションの調整
3. カスタムスタイルの適用
4. コードサンプルの整備

### Phase 4: 最終調整（Week 4）
1. リンクチェック
2. SEO最適化
3. パフォーマンス最適化
4. 最終レビューと公開

## 🌐 多言語対応戦略

### ディレクトリ構造
- `/ja/` - 日本語コンテンツ
- `/en/` - 英語コンテンツ
- 各ページに言語切り替えリンク

### Front Matter例
```yaml
---
layout: page
title: クイックスタート
lang: ja
permalink: /ja/quickstart/
nav_order: 1
parent: はじめに
translations:
  en: /en/quickstart/
---
```

### _data/i18n.yml
```yaml
ja:
  site_title: "AutoSlideIdea ドキュメント"
  nav_home: "ホーム"
  nav_quickstart: "クイックスタート"
  nav_guide: "ユーザーガイド"
  search_placeholder: "検索..."

en:
  site_title: "AutoSlideIdea Documentation"
  nav_home: "Home"
  nav_quickstart: "Quick Start"
  nav_guide: "User Guide"
  search_placeholder: "Search..."
```

## 📊 成功指標

1. **ページロード時間**: 3秒以内
2. **検索精度**: 関連ドキュメントが上位3件に表示
3. **ナビゲーション**: 3クリック以内で目的のページに到達
4. **モバイル対応**: スマートフォンでも快適に閲覧

## 🚀 実装優先順位

1. **必須（P0）**
   - Jekyll基本設定
   - ホームページ
   - クイックスタート
   - 基本的なナビゲーション

2. **重要（P1）**
   - 既存ドキュメントの移行
   - 検索機能
   - 多言語切り替え

3. **あると良い（P2）**
   - カスタムスタイル
   - アニメーション
   - 高度な検索フィルタ

## 📋 チェックリスト

- [ ] Jekyll設定ファイルの作成
- [ ] Just the Docsテーマの導入
- [ ] 基本ページの作成
- [ ] ナビゲーション構造の実装
- [ ] 多言語対応の実装
- [ ] 既存コンテンツの移行
- [ ] 新規コンテンツの作成
- [ ] スタイルのカスタマイズ
- [ ] テストとデバッグ
- [ ] デプロイと公開

---

この計画に基づいて、段階的にJekyll対応を進めていきます。