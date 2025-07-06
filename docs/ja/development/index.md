---
layout: default
title: 開発者向け
nav_order: 6
has_children: true
---

# 開発者向けドキュメント

AutoSlideIdeaの開発に参加したい方向けの情報です。

## カテゴリ

### 貢献ガイド
- [コントリビューションガイド](contributing/) - 貢献方法とガイドライン
- [ローカライゼーション](localization/) - 翻訳・多言語対応

### 技術情報
- [ロードマップ](roadmap/) - 今後の開発計画
- [アーキテクチャ](architecture/) - システム設計と構造

### SlideFlow開発
- [SlideFlow概要](slideflow-overview/) - 統合管理ツールの詳細
- [AI指示書システム](ai-instructions/) - AI支援機能の仕組み

## はじめに

AutoSlideIdeaはオープンソースプロジェクトです。以下の方法で貢献できます：

1. **バグ報告** - Issueを作成
2. **機能提案** - Discussionsで議論
3. **コード貢献** - Pull Requestを送信
4. **ドキュメント改善** - 誤字修正から新規作成まで
5. **翻訳** - 多言語対応の支援

## 開発環境のセットアップ

```bash
# フォークしてクローン
git clone https://github.com/YOUR_USERNAME/AutoSlideIdea.git
cd AutoSlideIdea

# 開発ブランチを作成
git checkout -b feature/your-feature-name

# 依存関係をインストール
npm install
```

## コーディング規約

- ESLintの設定に従う
- コミットメッセージは[Conventional Commits](https://www.conventionalcommits.org/)形式
- テストを追加する
- ドキュメントを更新する