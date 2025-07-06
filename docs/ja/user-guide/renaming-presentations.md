---
layout: default
title: プレゼンテーションの名前変更
nav_order: 5
parent: ユーザーガイド
grand_parent: 日本語
---

# プレゼンテーションディレクトリの名前変更

既存のプレゼンテーションディレクトリ名を変更する際のガイドです。

## なぜ名前を変更するのか

- プロジェクトの進行に伴い、より適切な名前が必要になった
- 命名規則を統一したい
- バージョン管理やアーカイブのため

## 基本的な変更手順

### 1. シンプルな名前変更

最も一般的なケース：`presentations/`内での名前変更

```bash
# プレゼンテーションディレクトリに移動
cd presentations/

# 名前を変更
mv old-presentation-name new-presentation-name

# 変更を確認
ls -la

# 動作確認
cd new-presentation-name
../../slideflow/slideflow.sh preview
```

### 2. Gitを使用した変更（推奨）

バージョン管理されている場合：

```bash
# Gitで名前変更（履歴を保持）
git mv presentations/old-name presentations/new-name

# 変更をコミット
git add -A
git commit -m "rename: old-name → new-name プレゼンテーション

- 理由：より明確な名前に変更
- 影響：特になし"
```

## 注意すべきポイント

### 内部リンクの確認

プレゼンテーション内で相対パスを使用している場合は確認が必要：

```markdown
<!-- slides.md内の画像参照 -->
![](images/diagram.png)
![](../shared-assets/logo.png)  <!-- 要確認 -->
```

### ビルド出力

`output/`ディレクトリ内の生成物は自動的に再生成されますが、以下に注意：

- 古い出力ファイルは手動で削除
- GitHub Pagesで公開している場合はURLが変わる可能性

### スクリプトやコマンド

カスタムスクリプトがある場合：

```bash
# package.jsonやMakefileでパスを指定している場合
"scripts": {
  "build": "marp presentations/old-name/slides.md"  // 要更新
}
```

## 高度な使用例

### presentations/ディレクトリ外への移動

```bash
# 別の場所に移動
mv presentations/my-project ~/Documents/presentations/my-project

# 絶対パスで操作
cd ~/Documents/presentations/my-project
/path/to/AutoSlideIdea/slideflow/slideflow.sh preview
```

### デフォルトディレクトリの変更

```bash
# 環境変数で一時的に変更
export SLIDEFLOW_PRESENTATIONS_DIR=~/my-presentations
slideflow list  # 新しい場所を参照

# 設定ファイルで永続化
slideflow --config presentations_dir=~/my-presentations
```

## チェックリスト

名前変更前に確認：

- [ ] `slides.md`内の相対パス参照
- [ ] `images/`や`assets/`ディレクトリへのリンク
- [ ] カスタムCSSやテーマファイルのパス
- [ ] `package.json`などの設定ファイル
- [ ] CI/CD設定（GitHub Actionsなど）
- [ ] ドキュメントやREADMEでの参照

## トラブルシューティング

### 画像が表示されない

```bash
# 画像パスを確認
find . -name "*.md" -exec grep -l "images/" {} \;

# 必要に応じてパスを修正
```

### slideflow listに表示されない

```bash
# 現在の設定を確認
slideflow --show-config | grep presentations_dir

# リストを再確認
slideflow list --dir /path/to/new/location
```

### ビルドエラー

```bash
# クリーンビルド
rm -rf output/
slideflow build
```

## ベストプラクティス

### 推奨される命名規則

```
# 良い例
2025-01-tech-conference
product-demo-v2
customer-training-basic

# 避けるべき例
my presentation  # スペースは避ける
プレゼン１      # 日本語は環境により問題となる可能性
PRESENTATION    # 大文字のみは避ける
```

### ディレクトリ構造の維持

```
new-presentation-name/
├── slides.md          # メインのスライド
├── images/           # 画像ファイル
├── assets/           # その他のリソース
├── output/           # ビルド出力（自動生成）
└── README.md         # プレゼンテーションの説明
```

### バージョン管理

```bash
# タグを使用したバージョン管理
git tag -a v1.0 -m "初回発表版"
git push origin v1.0

# ブランチを使用した管理
git checkout -b conference-2025
```

## 関連項目

- [基本的な使い方](basic-usage.md)
- [プレゼンテーションの管理](../reference/scripts.md#manage-presentation)
- [Tips集](../guides/tips.md)