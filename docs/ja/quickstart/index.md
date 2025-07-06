---
layout: default
title: クイックスタート
nav_order: 2
parent: 日本語
---

# クイックスタート

5分でAutoSlideIdeaを始めよう！

## 必要な環境

- Git
- Node.js (v14以上)
- 基本的なMarkdownの知識

## 1. リポジトリのクローン

```bash
git clone --recursive https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea
```

`--recursive`オプションは、AI指示書キットのサブモジュールも一緒にクローンするために必要です。

## 2. 依存関係のインストール

```bash
npm install
```

または

```bash
yarn install
```

## 3. 最初のプレゼンテーション作成

SlideFlowコマンドで新規作成：

```bash
./slideflow/slideflow.sh new my-first-presentation
```

作成される構造：
```
presentations/my-first-presentation/
├── slides.md          # プレゼンテーション内容
├── images/            # 画像ディレクトリ
└── assets/            # その他のアセット
```

## 4. スライドの編集

`presentations/my-first-presentation/slides.md`をお好みのエディタで開いて編集：

```markdown
---
marp: true
theme: default
paginate: true
---

# My First Presentation

AutoSlideIdeaで作る最初のプレゼンテーション

あなたの名前
2025年

---

# アジェンダ

1. はじめに
2. メインコンテンツ
3. まとめ

---

# はじめに

- ポイント1
- ポイント2
- ポイント3

---

# ご清聴ありがとうございました！

質問はありますか？
```

## 5. プレビューで確認

```bash
# プレゼンテーションディレクトリに移動
cd presentations/my-first-presentation

# プレビューサーバーを起動（ライブリロード対応）
../../slideflow/slideflow.sh preview
```

ブラウザで http://localhost:8000 を開くと、リアルタイムでプレビューが表示されます。

## 6. 配布用ファイルの生成

PDF生成：
```bash
./slideflow/slideflow.sh build pdf
```

HTML生成：
```bash
./slideflow/slideflow.sh build html
```

## よくある問題

### コマンドが見つからない

```bash
# スクリプトに実行権限を付与
chmod +x slideflow/slideflow.sh
chmod +x scripts/*.sh
```

### サブモジュールが取得されていない

```bash
git submodule update --init --recursive
```

### 日本語フォントが表示されない

適切なフォントをインストール：
```bash
# Ubuntu/Debian
sudo apt-get install fonts-noto-cjk

# macOS
brew install --cask font-noto-sans-cjk
```

## 次のステップ

### プレゼンテーションを強化する

1. **テーマを追加**: [CSSテーマ](../features/css-themes/)を確認
2. **図表を追加**: [Mermaid対応](../features/mermaid/)を学習
3. **オンライン公開**: [GitHub Pages連携](../features/github-pages/)を活用

### さらに学ぶ

- [基本的な使い方](../user-guide/basic-usage/) - 詳細なコマンド説明
- [Markdown記法](../user-guide/markdown-syntax/) - プレゼンテーション専用の記法
- [Tips集](../guides/tips/) - ベストプラクティス

### AI支援を活用

AIでプレゼンテーション作成を高速化：

```bash
# 調査フェーズのサポート
./slideflow/slideflow.sh research init
./slideflow/slideflow.sh research ai-search "Web開発のベストプラクティス"

# インタラクティブモード
./slideflow/slideflow.sh research interactive
```

## サンプルプレゼンテーション

[デモプレゼンテーション](../demos/)で可能性を確認しましょう！

---

素晴らしいプレゼンテーションを作る準備ができました！🚀