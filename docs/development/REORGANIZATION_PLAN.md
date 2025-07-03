[English](REORGANIZATION_PLAN.en.md) | 日本語

# ドキュメント再構成計画

## 現状の問題点
- 日本語と英語のファイルが同一階層に混在
- 機能別の分類がされていない
- 新機能（Mermaid統合）のドキュメントが散在
- ユーザーが必要な情報を見つけにくい

## 提案する新構造

```
docs/
├── README.md                 # ドキュメントのインデックス
├── ja/                       # 日本語ドキュメント
│   ├── getting-started/      # 初めての方向け
│   │   ├── setup.md         # セットアップ
│   │   ├── quickstart.md    # クイックスタート
│   │   └── basic-usage.md   # 基本的な使い方
│   ├── guides/              # ガイド
│   │   ├── workflow.md      # ワークフロー
│   │   ├── tips.md          # Tips & Tricks
│   │   └── best-practices.md # ベストプラクティス
│   ├── features/            # 機能説明
│   │   ├── mermaid/         # Mermaid統合
│   │   │   ├── overview.md  # 概要
│   │   │   └── technical.md # 技術詳細
│   │   ├── github-pages.md  # GitHub Pages
│   │   └── templates.md     # テンプレート
│   ├── reference/           # リファレンス
│   │   ├── scripts.md       # スクリプト
│   │   ├── config.md        # 設定
│   │   └── api.md          # API（将来用）
│   └── advanced/            # 上級者向け
│       ├── workflow.md      # 高度なワークフロー
│       └── customization.md # カスタマイズ
├── en/                      # 英語ドキュメント（同構造）
│   ├── getting-started/
│   ├── guides/
│   ├── features/
│   ├── reference/
│   └── advanced/
└── assets/                  # ドキュメント用画像
    ├── screenshots/
    └── diagrams/
```

## 移行マッピング

### 日本語ファイル
- `setup.md` → `ja/getting-started/setup.md`
- `workflow.md` → `ja/guides/workflow.md`
- `tips.md` → `ja/guides/tips.md`
- `advanced-workflow.md` → `ja/advanced/workflow.md`
- `github-pages.md` → `ja/features/github-pages.md`
- `scripts-reference.md` → `ja/reference/scripts.md`
- `mermaid-integration.md` → `ja/features/mermaid/technical.md`
- `mermaid-integration-summary.md` → `ja/features/mermaid/overview.md`

### 英語ファイル
- `*.en.md` → `en/`の対応するディレクトリへ

## 新規作成が必要なファイル

1. **docs/README.md** - ドキュメントのインデックス（両言語対応）
2. **ja/getting-started/quickstart.md** - 5分で始めるガイド
3. **ja/guides/best-practices.md** - ベストプラクティス集
4. **ja/features/templates.md** - テンプレートの詳細説明

## 実装手順

1. 新しいディレクトリ構造を作成
2. 既存ファイルを適切な場所に移動
3. 相対リンクを更新
4. README.mdでナビゲーションを提供
5. ルートのREADME.mdからドキュメントへのリンクを更新

## メリット

- **明確な構造**: 目的別にファイルが整理される
- **言語分離**: 各言語のドキュメントが独立
- **拡張性**: 新機能のドキュメントを追加しやすい
- **保守性**: ファイルの場所が予測可能
- **ユーザビリティ**: 必要な情報を見つけやすい

## 注意事項

- GitHubのリンクが変わるため、外部からのリンクに影響
- CI/CDスクリプトでドキュメントパスを参照している場合は更新が必要
- 移行は段階的に行い、リダイレクトを設定することを推奨