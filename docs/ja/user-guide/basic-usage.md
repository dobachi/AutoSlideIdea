---
layout: default
title: 基本的な使い方
nav_order: 1
parent: ユーザーガイド
---

# 基本的な使い方

AutoSlideIdeaを使ったプレゼンテーション作成の基本を説明します。

## 1. 新しいプレゼンテーションの作成

### SlideFlowコマンドを使う（推奨）

```bash
# 新規作成
./slideflow/slideflow.sh new my-presentation

# テンプレートを指定
./slideflow/slideflow.sh new --template business my-company-pitch
```

### 作成されるファイル構造

```
presentations/my-presentation/
├── slides.md         # メインのスライドファイル
├── assets/          # 画像やその他のリソース
└── output/          # ビルド結果の出力先
```

## 2. スライドの編集

### Markdown記法の基本

```markdown
---
marp: true
theme: default
paginate: true
---

# プレゼンテーションタイトル

発表者名
2024年7月6日

---

# セクション1

- ポイント1
- ポイント2
- ポイント3

---

# コード例

```javascript
function greet(name) {
    return `Hello, ${name}!`;
}
```
```

### スライドの区切り

- `---` （3つのハイフン）で新しいスライドを開始
- 各スライドは独立したページとして表示

## 3. AI支援機能の活用

### 包括的AI支援

```bash
# 対話的にプレゼンテーション全体を作成
./slideflow/slideflow.sh ai

# クイック作成（タイプ別）
./slideflow/slideflow.sh ai --quick tech     # 技術系
./slideflow/slideflow.sh ai --quick business  # ビジネス系
./slideflow/slideflow.sh ai --quick academic  # 学術系

# 特定フェーズの支援
./slideflow/slideflow.sh ai --phase planning  # 計画
./slideflow/slideflow.sh ai --phase research  # 調査
./slideflow/slideflow.sh ai --phase design    # 設計
./slideflow/slideflow.sh ai --phase creation  # 作成
./slideflow/slideflow.sh ai --phase review    # レビュー
```

### AI深層調査機能

プレゼンテーション作成前の詳細な調査に特化：

```bash
# 調査環境の初期化
cd presentations/my-presentation
./slideflow/slideflow.sh ai deep-research init

# Web検索（インタラクティブモード）
./slideflow/slideflow.sh ai deep-research search "調査したいトピック"

# 自動検索（バックグラウンド実行）
./slideflow/slideflow.sh ai deep-research search --auto "AI技術動向"

# タイムアウト設定（詳細調査用）
./slideflow/slideflow.sh ai deep-research search -t 600 "詳細な技術調査"

# ドキュメント分析
./slideflow/slideflow.sh ai deep-research analyze paper.pdf
```

## 4. プレビュー

### ローカルサーバーでのプレビュー

```bash
# プレビューサーバーを起動
./slideflow/slideflow.sh preview

# カスタムポートを指定
./slideflow/slideflow.sh preview --port 3000
```

ブラウザで `http://localhost:8000` を開いてプレビューを確認

### リアルタイム更新

- ファイルを編集すると自動的にブラウザが更新されます
- 即座に変更を確認できます

## 5. ビルドとエクスポート

### HTMLファイルの生成

```bash
# HTMLファイルを生成
./slideflow/slideflow.sh build

# 出力先：presentations/my-presentation/output/index.html
```

### PDFファイルの生成

```bash
# PDFファイルを生成
npm run pdf -- presentations/my-presentation/slides.md \
  -o presentations/my-presentation/output/slides.pdf
```

## 6. よく使うテクニック

### 画像の挿入

```markdown
![説明文](assets/image.png)

<!-- サイズ指定 -->
![width:500px](assets/diagram.png)

<!-- 中央揃え -->
![center](assets/logo.png)
```

### 2カラムレイアウト

```markdown
<div style="display: flex;">
<div style="flex: 1;">

左側のコンテンツ
- ポイント1
- ポイント2

</div>
<div style="flex: 1;">

右側のコンテンツ
![](assets/chart.png)

</div>
</div>
```

### 強調とスタイリング

```markdown
**太字**で強調
*斜体*で表現
~~取り消し線~~

> 引用文
> 複数行にわたる引用
```

## 次のステップ

- [Markdown記法](markdown-syntax/) - より詳しいMarkdownの使い方
- [テーマの使い方](themes/) - デザインのカスタマイズ
- [Mermaid図表](mermaid/) - フローチャートの作成