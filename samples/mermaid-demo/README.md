# Mermaid統合デモ

このディレクトリには、MarpプレゼンテーションでMermaid図表を使用する例が含まれています。

## 含まれる図表の種類

- フローチャート
- シーケンス図
- ガントチャート
- クラス図
- 状態遷移図
- 円グラフ

## ビルド方法

### 1. Mermaidの前処理

```bash
# 単一ファイルの処理
../../scripts/preprocess-mermaid.sh slides.md

# または、バッチ処理
../../scripts/batch-preprocess-mermaid.sh -o processed/ slides.md
```

### 2. Marpでビルド

```bash
# 処理済みファイルからPDFを生成
marp slides-processed.md --pdf --allow-local-files

# HTMLを生成
marp slides-processed.md --html --allow-local-files

# プレビュー
marp slides-processed.md --preview
```

### 3. ワンライナーでの実行

```bash
# 前処理とPDF生成を一度に
../../scripts/preprocess-mermaid.sh slides.md && \
marp slides-processed.md --pdf --allow-local-files
```

## GitHub Actionsでの自動ビルド

このプロジェクトのルートで以下のワークフローを使用できます：

```yaml
name: Build Mermaid Demo
on:
  push:
    paths:
      - 'samples/mermaid-demo/**'

jobs:
  build:
    uses: ./.github/workflows/mermaid-enabled.yml
```

## カスタマイズ

### Mermaidテーマの変更

```bash
# ダークテーマを使用
../../scripts/preprocess-mermaid.sh -t dark slides.md

# フォレストテーマを使用
../../scripts/preprocess-mermaid.sh -t forest slides.md
```

### 図表フォーマットの変更

```bash
# PNG形式で出力
../../scripts/preprocess-mermaid.sh -f png slides.md

# PDF形式で出力（ベクター形式）
../../scripts/preprocess-mermaid.sh -f pdf slides.md
```

## トラブルシューティング

### 日本語が表示されない場合

1. システムに日本語フォントをインストール：
   ```bash
   sudo apt-get install fonts-noto-cjk
   ```

2. カスタム設定ファイルを使用：
   ```json
   {
     "theme": "default",
     "themeVariables": {
       "fontFamily": "Noto Sans CJK JP"
     }
   }
   ```

   ```bash
   ../../scripts/preprocess-mermaid.sh --config mermaid-ja.json slides.md
   ```

### 図表が大きすぎる場合

サイズを調整：
```bash
../../scripts/preprocess-mermaid.sh -w 1920 -h 1080 slides.md
```

## 関連ドキュメント

- [Mermaid統合ガイド](../../docs/mermaid-integration.md)
- [Mermaid公式ドキュメント](https://mermaid.js.org/)
- [Marp公式ドキュメント](https://marp.app/)