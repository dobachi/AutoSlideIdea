---
layout: default
title: インストール
nav_order: 1
parent: 日本語
nav_exclude: true
---

# インストールガイド

AutoSlideIdeaのインストール方法を説明します。

## 必要な環境

- Git
- Node.js (v14以上)
- npm または yarn

## インストール手順

### 1. リポジトリのクローン

```bash
git clone --recursive https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea
```

`--recursive`オプションは、AI指示書キットのサブモジュールも一緒にクローンするために必要です。

### 2. 依存関係のインストール

```bash
npm install
```

または

```bash
yarn install
```

### 3. 動作確認

```bash
# SlideFlowコマンドの確認
./slideflow/slideflow.sh --help

# 新しいプレゼンテーションを作成
./slideflow/slideflow.sh new my-presentation
```

## トラブルシューティング

### サブモジュールが取得されていない場合

```bash
git submodule update --init --recursive
```

### 実行権限がない場合

```bash
chmod +x slideflow/slideflow.sh
chmod +x scripts/*.sh
```

### Node.jsのバージョンが古い場合

[Node.js公式サイト](https://nodejs.org/)から最新のLTS版をインストールしてください。

## 次のステップ

インストールが完了したら、[クイックスタート](../quickstart/)で実際にプレゼンテーションを作成してみましょう。