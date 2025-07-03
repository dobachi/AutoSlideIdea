# GitHub Actions ワークフローテンプレート

プレゼンテーションリポジトリ用のGitHub Actionsワークフローテンプレート集です。

## 利用可能なワークフロー

### basic.yml - 基本的なビルド
- PDF/HTML形式でのビルド
- GitHub Pagesへの自動デプロイ
- アーティファクトの保存

**使用例**:
```bash
cp templates/github-workflows/basic.yml .github/workflows/build-slides.yml
```

### full-featured.yml - フル機能版
- 複数のスライドファイルに対応
- 調査データの可視化を含む
- 複数フォーマット出力（PDF, HTML, PPTX）
- リリース作成機能

**使用例**:
```bash
cp templates/github-workflows/full-featured.yml .github/workflows/build-slides.yml
```

### multi-language.yml - 多言語対応
- 日本語・英語の同時ビルド
- 言語別のディレクトリ構成に対応
- 言語切り替え可能なGitHub Pages

**使用例**:
```bash
cp templates/github-workflows/multi-language.yml .github/workflows/build-slides.yml
```

## カスタマイズ

各ワークフローファイルの先頭にあるコメントを参考に、必要に応じて以下の項目をカスタマイズしてください：

- トリガー条件（branches, paths）
- Node.jsバージョン
- 追加のフォント
- 出力ファイル名
- GitHub Pagesの設定

## セキュリティ考慮事項

- `GITHUB_TOKEN`は自動的に提供されます
- カスタムドメインを使用する場合は、`cname`フィールドを設定してください
- プライベートリポジトリでは、GitHub Pagesは有料プランでのみ利用可能です

## トラブルシューティング

### 日本語が文字化けする
→ フォントのインストールステップが正しく実行されているか確認

### ビルドが失敗する
→ Marpのバージョンとスライドの記法の互換性を確認

### GitHub Pagesが表示されない
→ Settings > Pages でソースブランチが`gh-pages`に設定されているか確認