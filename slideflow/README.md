# SlideFlow - Phase 0 (超最小MVP)

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

## 使い方

### 新しいプレゼンテーションを作成

```bash
./slideflow.sh new my-presentation
```

### プレビューサーバーを起動

```bash
cd ../presentations/my-presentation
../../slideflow/slideflow.sh preview
# ブラウザで http://localhost:8000 を開く
```

### AI支援用の指示書を表示

```bash
./slideflow.sh ai
```

## コマンド一覧

- `new <name>` - 新しいプレゼンテーションを作成
- `preview` - プレゼンテーションをプレビュー（slides.mdがあるディレクトリで実行）
- `ai` - AI支援用の指示書を表示
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