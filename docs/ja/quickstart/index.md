---
layout: default
title: クイックスタート
nav_order: 2
parent: 日本語
---

# クイックスタート

5分でAutoSlideIdeaを始めよう！

## 1. インストール

```bash
# リポジトリをクローン（サブモジュール含む）
git clone --recursive https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea

# 依存関係をインストール
npm install
```

## 2. 最初のプレゼンテーション作成

```bash
# SlideFlowコマンドで新規作成
./slideflow/slideflow.sh new my-first-presentation

# 作成されたディレクトリに移動
cd presentations/my-first-presentation
```

## 3. スライドの編集

`slides.md`をお好みのエディタで開いて編集：

```markdown
---
marp: true
theme: default
paginate: true
---

# My First Presentation

AutoSlideIdeaで作る最初のプレゼンテーション

---

# セクション1

- ポイント1
- ポイント2
- ポイント3

---

# まとめ

ご清聴ありがとうございました！
```

## 4. プレビューで確認

```bash
# プロジェクトルートに戻る
cd ../..

# プレビューサーバーを起動
./slideflow/slideflow.sh preview my-first-presentation
```

ブラウザで http://localhost:8000 を開くと、リアルタイムでプレビューが表示されます。

## 5. HTMLファイルを生成

```bash
# HTMLファイルとしてビルド
./slideflow/slideflow.sh build my-first-presentation

# 生成されたファイルを確認
ls presentations/my-first-presentation/output/
# index.html が生成されています
```

## 次のステップ

- [基本的な使い方](../user-guide/basic-usage/) - より詳しい使い方
- [Markdown記法](../user-guide/markdown-syntax/) - スライド作成のテクニック
- [テーマの使い方](../user-guide/themes/) - デザインのカスタマイズ

## ヘルプ

```bash
# コマンドのヘルプを表示
./slideflow/slideflow.sh --help

# 特定のコマンドのヘルプ
./slideflow/slideflow.sh new --help
```