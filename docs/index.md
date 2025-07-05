---
layout: default
title: AutoSlideIdea - AI支援プレゼンテーション作成ガイド
---

# AutoSlideIdea

**Markdownベースのシンプルなプレゼンテーション作成ツール**

## 🚀 クイックナビゲーション

[セットアップ](getting-started/setup.md) | [基本ワークフロー](getting-started/basic-workflow.md) | [高度な使い方](guides/advanced-workflow.md) | [貢献方法](development/contributing.md)

---

## 📋 概要

AutoSlideIdeaは、**Markdownベースのシンプルさを追求**し、AI支援機能を活用して効率的にプレゼンテーション資料を作成するためのツールセットです。

### ✨ コアコンセプト
- 📝 **Markdownファースト**: すべてのコンテンツをMarkdownで管理
- 🎯 **シンプルさの追求**: 複雑な設定を排除し、本質に集中
- 🔄 **テキストベース**: バージョン管理と共有が容易

🎯 **[デモプレゼンテーションを見る](https://dobachi.github.io/AutoSlideIdea/)** - 実際の出力例を確認できます

## 🎨 主な機能

### 基本機能
- **Markdownベースのスライド作成** - Marpを使用したシンプルなスライド作成
- **4種類のテーマ** - base, academic, business, minimalから選択可能
- **Mermaid図表統合** - フローチャート、シーケンス図などの自動変換
- **マルチフォーマット出力** - HTML, PDF, PowerPoint形式に対応

### AI支援機能
- **コンテンツ生成支援** - AIによる構成案・内容生成
- **AI指示書システム** - 高度なプロンプト管理
- **対話的フェーズ支援** - プレゼンテーション作成の各段階でAIがサポート

### 自動化機能
- **GitHub Actions連携** - 自動ビルドとデプロイ
- **GitHub Pages対応** - プレゼンテーションをWebサイトとして公開
- **バージョン管理** - Gitによる変更履歴管理

## 💡 はじめ方

### 1. インストール
```bash
# リポジトリのクローン
git clone --recursive https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea

# 依存関係のインストール
npm install
```

### 2. 最初のプレゼンテーション作成
```bash
# SlideFlowを使用（推奨）
./slideflow/slideflow.sh new my-first-presentation

# プレビュー
./slideflow/slideflow.sh preview
```

### 3. AI支援を活用
```bash
# 対話的AI支援
./slideflow/slideflow.sh ai

# 簡易AI支援（技術プレゼンテーション）
./slideflow/slideflow.sh ai --quick tech
```

## 📚 ドキュメント

### Getting Started
- [セットアップガイド](getting-started/setup.md)
- [基本的な使い方](getting-started/basic-workflow.md)

### ユーザーガイド
- [Markdownでのスライド作成](guides/tips.md)
- [テーマの使い方](features/css-themes.md)
- [Mermaid図表の活用](features/mermaid.md)
- [GitHub Pages連携](features/github-pages.md)

### 高度な機能
- [SlideFlow統合システム](development/slideflow-plan.md)
- [AI指示書システム](guides/advanced-workflow.md)

### 開発者向け
- [コントリビューションガイド](development/contributing.md)
- [APIリファレンス](reference/scripts.md)
- [開発ロードマップ](development/roadmap.md)

## 🤝 コミュニティ

- [GitHub Issues](https://github.com/dobachi/AutoSlideIdea/issues) - バグ報告や機能要望
- [Discussions](https://github.com/dobachi/AutoSlideIdea/discussions) - 質問や議論

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

---

<div style="text-align: center; margin-top: 50px;">
  <a href="https://github.com/dobachi/AutoSlideIdea" class="btn">View on GitHub</a>
</div>