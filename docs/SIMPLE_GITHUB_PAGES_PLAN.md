# GitHub Pages簡易ドキュメントサイト構築計画

## 📋 基本方針

GitHubの標準機能のみを使用して、メンテナンスが容易なドキュメントサイトを構築する。

## 🎯 シンプルな構成

### 1. **GitHub Pages標準テーマ**
- Jekyll（GitHub Pages標準）
- 追加のビルドツール不要
- `_config.yml`だけで設定完了

### 2. **ディレクトリ構造**
```
/docs/                    # GitHub Pagesのソース
├── index.md             # ホームページ
├── _config.yml          # Jekyll設定（最小限）
├── getting-started.md   # はじめに
├── user-guide.md        # 使い方
├── slideflow.md         # SlideFlow説明
├── api.md              # APIリファレンス
└── contributing.md      # 貢献方法
```

### 3. **最小限の設定（_config.yml）**
```yaml
theme: jekyll-theme-cayman
title: AutoSlideIdea
description: Markdownベースのシンプルなプレゼンテーション作成ツール
```

## 🚀 設定手順（5分で完了）

1. **GitHub リポジトリ設定**
   - Settings > Pages
   - Source: Deploy from a branch
   - Branch: main
   - Folder: /docs

2. **_config.yml作成**
   ```yaml
   theme: jekyll-theme-cayman  # または minimal, dinky など
   title: AutoSlideIdea Documentation
   ```

3. **index.mdの作成**
   - 既存のREADME.mdの内容を活用

## 📝 コンテンツ構成

### トップページ（index.md）
```markdown
# AutoSlideIdea

Markdownベースのシンプルなプレゼンテーション作成ツール

## クイックスタート
[はじめに](getting-started.md) | [使い方](user-guide.md) | [SlideFlow](slideflow.md)

## 主な機能
- ✨ Markdownでスライド作成
- 🎨 4種類のテーマ
- 🤖 AI支援機能
...
```

### 各ページの構成
- 既存のdocs/ディレクトリのMarkdownファイルをそのまま活用
- 相互リンクを追加するだけ

## 🎨 テーマ候補（GitHub標準）

1. **Cayman** - クリーンで読みやすい（推奨）
2. **Minimal** - シンプルで軽量
3. **Slate** - ダークで専門的
4. **Dinky** - コンパクトで機能的

## 📋 実装タスク（30分で完了可能）

1. [ ] docs/_config.ymlを作成（2分）
2. [ ] docs/index.mdを作成（README.mdから転記）（10分）
3. [ ] 既存ドキュメントへのリンクを追加（10分）
4. [ ] GitHub Pages設定を有効化（3分）
5. [ ] 動作確認（5分）

## 🔧 オプション機能（必要に応じて）

### カスタムドメイン
```
docs/CNAME
```

### Google Analytics
```yaml
google_analytics: UA-XXXXX-Y
```

### カスタムCSS
```
docs/assets/css/style.scss
---
---
@import "{{ site.theme }}";
// カスタムスタイル
```

## 💡 メリット

1. **設定不要**: GitHub側で自動的にビルド
2. **メンテナンス最小**: Markdownを書くだけ
3. **高速**: CDNで配信
4. **無料**: GitHub Pagesは無料
5. **バージョン管理**: Gitで自動的に履歴管理

## 🚫 制限事項

- 高度なカスタマイズは困難
- プラグインは限定的
- 検索機能は外部サービス（Algolia等）が必要

## 📌 結論

このシンプルなアプローチなら：
- **今すぐ始められる**
- **特別な知識不要**
- **メンテナンスが楽**
- **GitHubの標準機能で完結**

複雑な機能が必要になったら、後からMkDocsやDocusaurusに移行可能。