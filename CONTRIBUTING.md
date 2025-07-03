# コントリビューションガイド

[English](CONTRIBUTING.en.md) | 日本語

## コミットメッセージ

このプロジェクトでは、以下の形式でコミットメッセージを記述してください：

```
<type>: <subject>

<body>
```

### Type
- `feat`: 新機能
- `fix`: バグ修正
- `docs`: ドキュメントのみの変更
- `style`: コードの動作に影響しない変更
- `refactor`: リファクタリング
- `test`: テストの追加・修正
- `chore`: ビルドプロセスやツールの変更

### 例

```
feat: プレゼンテーション作成スクリプトを統合

- new-presentation.sh と setup-presentation-repo.sh を統合
- 新しい create-presentation.sh として一本化
- 使い方がシンプルで分かりやすくなった
```

## 注意事項

- コミットメッセージに外部ツールやAIアシスタントの署名は含めないでください
- 変更内容を明確に記述してください
- 日本語での記述を推奨します