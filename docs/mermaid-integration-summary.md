# Mermaid統合実装まとめ

## 実装内容

### 1. ドキュメント
- **[mermaid-integration.md](./mermaid-integration.md)**: Mermaid統合の包括的なガイド
  - 統合方法の説明
  - 3つのアプローチ（プリプロセッシング、Kroki、ブラウザレンダリング）
  - トラブルシューティング

### 2. スクリプト
- **[preprocess-mermaid.sh](../scripts/preprocess-mermaid.sh)**: 単一ファイルの前処理スクリプト
  - Mermaidコードブロックを自動的にSVG/PNG/PDFに変換
  - カスタマイズ可能なオプション（テーマ、サイズ、背景色など）
  - エラーハンドリングと詳細なログ出力

- **[batch-preprocess-mermaid.sh](../scripts/batch-preprocess-mermaid.sh)**: 複数ファイルの一括処理スクリプト
  - ディレクトリ構造の保持オプション
  - 並列処理サポート（GNU parallel使用時）
  - ドライランモード

### 3. GitHub Actions
- **[mermaid-enabled.yml](../templates/github-workflows/mermaid-enabled.yml)**: Mermaid対応ワークフロー
  - 自動的なMermaid図表の検出と処理
  - 日本語フォント対応
  - マルチフォーマット出力（PDF、HTML、PPTX）
  - GitHub Pages自動デプロイ

### 4. サンプル
- **[mermaid-demo](../samples/mermaid-demo/)**: Mermaid統合のデモプレゼンテーション
  - 各種図表タイプの実例
  - 日本語対応の例
  - ビルド手順のドキュメント

## 使用方法

### 基本的な使い方

1. **Mermaid CLIのインストール**
   ```bash
   npm install -g @mermaid-js/mermaid-cli
   ```

2. **単一ファイルの処理**
   ```bash
   ./scripts/preprocess-mermaid.sh presentation.md
   marp presentation-processed.md --pdf
   ```

3. **複数ファイルの処理**
   ```bash
   ./scripts/batch-preprocess-mermaid.sh presentations/**/*.md
   ```

### GitHub Actionsでの使用

1. ワークフローファイルをコピー
   ```bash
   cp templates/github-workflows/mermaid-enabled.yml .github/workflows/
   ```

2. コミット＆プッシュで自動実行

## 技術的な詳細

### なぜプリプロセッシングが必要か

- Marpは現在Mermaidの直接サポートがない
- SVG foreignObject内でのフォントサイズ検出の問題
- PDFエクスポート時の互換性確保

### 対応している図表タイプ

- フローチャート（graph/flowchart）
- シーケンス図（sequenceDiagram）
- ガントチャート（gantt）
- クラス図（classDiagram）
- 状態遷移図（stateDiagram）
- 円グラフ（pie）
- ER図（erDiagram）
- ユーザージャーニー（journey）

## 今後の改善案

1. **キャッシュ機能の実装**
   - 変更されていない図表の再生成を回避
   - ビルド時間の短縮

2. **プラグイン化**
   - Marp CLIのカスタムエンジンとして実装
   - より密な統合

3. **リアルタイムプレビュー**
   - VS Code拡張機能との統合
   - ライブリロード対応

4. **テンプレート拡充**
   - Mermaid中心のプレゼンテーションテンプレート
   - 図表スタイルのプリセット

## 関連リンク

- [Mermaid公式ドキュメント](https://mermaid.js.org/)
- [Marp公式ドキュメント](https://marp.app/)
- [mermaid-cli GitHub](https://github.com/mermaid-js/mermaid-cli)