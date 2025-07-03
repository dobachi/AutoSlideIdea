# GitHub Pages連携ガイド

[English](github-pages.en.md) | 日本語

## 概要

AutoSlideIdeaは、GitHub Pagesと統合してプレゼンテーションをWebサイトとして公開する機能を提供します。これにより、URLを共有するだけで誰でもプレゼンテーションにアクセスできるようになります。

## 主な機能

- **自動デプロイ**: mainブランチへのプッシュ時に自動的にWebサイトを更新
- **美しいギャラリー**: 複数のプレゼンテーションを一覧表示
- **検索・フィルタ機能**: タグや検索ワードでプレゼンテーションを絞り込み
- **レスポンシブデザイン**: PC・タブレット・スマートフォンに対応
- **ダークモード対応**: システム設定に応じて自動切り替え

## セットアップ方法

### 1. GitHub Pagesワークフローで新規作成

最も簡単な方法は、`create-presentation.sh`スクリプトでGitHub Pages専用ワークフローを使用することです：

```bash
# GitHub Pages対応のプレゼンテーションを作成
./scripts/create-presentation.sh --github --workflow github-pages my-portfolio

# パブリックリポジトリとして作成（推奨）
./scripts/create-presentation.sh --github --public --workflow github-pages conference-2024
```

このコマンドで以下が自動的に設定されます：
- GitHub Actionsワークフロー（`.github/workflows/github-pages.yml`）
- 必要な権限設定
- ビルドとデプロイの自動化

### 2. 既存プレゼンテーションへの追加

既存のプレゼンテーションリポジトリにGitHub Pages機能を追加する場合：

1. **ワークフローファイルをコピー**
   ```bash
   cp templates/github-workflows/github-pages.yml .github/workflows/
   ```

2. **コミットしてプッシュ**
   ```bash
   git add .github/workflows/github-pages.yml
   git commit -m "Add GitHub Pages workflow"
   git push origin main
   ```

3. **GitHub Pagesを有効化**
   - リポジトリの Settings → Pages へ移動
   - Source を "GitHub Actions" に設定

### 3. 初回デプロイ

プッシュ後、GitHub Actionsが自動的に実行されます：

1. **進行状況の確認**
   - リポジトリの Actions タブで進行状況を確認
   - 初回は5-10分程度かかる場合があります

2. **URL確認**
   ```
   https://[ユーザー名].github.io/[リポジトリ名]/
   ```

## プレゼンテーションの管理

### ディレクトリ構造

GitHub Pagesワークフローは以下の構造を前提としています：

```
your-presentation/
├── slides.md              # メインプレゼンテーション
├── additional-talk.md     # 追加のプレゼンテーション（任意）
├── assets/               # 画像・リソース
│   ├── images/
│   └── styles/
└── .github/
    └── workflows/
        └── github-pages.yml
```

### 複数プレゼンテーションの管理

1つのリポジトリで複数のプレゼンテーションを管理できます：

```
repository/
├── slides.md              # メイン
├── workshop/
│   └── hands-on.md       # ワークショップ資料
├── lightning-talks/
│   ├── intro.md          # 5分トーク
│   └── advanced.md       # 詳細版
└── assets/               # 共通リソース
```

すべての`.md`ファイルが自動的にHTML/PDFに変換され、ギャラリーに表示されます。

## カスタマイズ

### インデックスページのカスタマイズ

デフォルトのインデックスページをカスタマイズするには：

1. **テンプレートをコピー**
   ```bash
   cp templates/github-pages/index-template.html index-template.html
   ```

2. **プレースホルダーを編集**
   - `{{TITLE}}`: サイトタイトル
   - `{{DESCRIPTION}}`: サイト説明
   - `{{HEADER_TITLE}}`: ヘッダータイトル
   - その他のテキストを必要に応じて変更

3. **ワークフローを更新**
   カスタムテンプレートを使用するようワークフローを修正

### プレゼンテーションメタデータ

各プレゼンテーションにメタデータを追加して、ギャラリー表示を充実させることができます：

```markdown
---
title: AI時代のプレゼンテーション作成
author: 山田太郎
date: 2024-01-15
tags: [AI, 自動化, Marp]
description: AIツールを活用した効率的なプレゼンテーション作成方法
---

# スライドタイトル
```

## トラブルシューティング

### ビルドが失敗する場合

1. **Actions権限の確認**
   - Settings → Actions → General
   - "Read and write permissions" が有効になっているか確認

2. **ワークフローの確認**
   - Actions タブでエラーログを確認
   - 日本語フォントのインストールに失敗している場合が多い

### ページが表示されない場合

1. **GitHub Pages設定の確認**
   - Settings → Pages
   - Source が "GitHub Actions" になっているか確認
   - カスタムドメインを使用している場合はDNS設定も確認

2. **デプロイ状況の確認**
   - Actions タブで "pages build and deployment" が成功しているか確認

### スタイルが適用されない場合

1. **アセットパスの確認**
   - 相対パスが正しいか確認
   - `--allow-local-files` オプションが有効になっているか確認

2. **キャッシュのクリア**
   - ブラウザのキャッシュをクリア
   - GitHub Pagesのキャッシュは最大10分

## ベストプラクティス

1. **プレゼンテーションの整理**
   - 関連するプレゼンテーションはディレクトリでグループ化
   - 明確なファイル名を使用（日付やイベント名を含める）

2. **アセット管理**
   - 画像は適切に圧縮
   - 共通リソースは`assets/`ディレクトリに集約

3. **継続的な改善**
   - プレゼンテーション後もフィードバックを反映
   - 更新履歴をコミットメッセージで明確に

4. **セキュリティ**
   - 機密情報を含むプレゼンテーションは別管理
   - 必要に応じてプライベートリポジトリを使用

## 関連ドキュメント

- [作業フロー](workflow.md)
- [GitHub Actions設定](../templates/github-workflows/README.md)
- [Tips & Tricks](tips.md)