# AI支援プレゼンテーション作成ガイド

## 概要

このプロジェクトは、Claude CodeやGemini CLIなどのAIツールを活用して効率的にプレゼンテーション資料を作成するための方法論とツールセットを提供します。

## 主な機能

- **Markdownベースのスライド作成**: Marpを使用したシンプルなスライド作成
- **AI支援コンテンツ生成**: Claude Code/Gemini CLIによる構成案・内容生成
- **自動ビルド**: GitHub Actionsによる自動PDF生成
- **バージョン管理**: Gitによる変更履歴管理

## ディレクトリ構成

```
AutoSlideIdea/
├── README.md                  # このファイル
├── docs/                      # ドキュメント
│   ├── setup.md              # セットアップガイド
│   ├── workflow.md           # 作業フロー
│   └── tips.md               # Tips & Tricks
├── templates/                 # テンプレート集
│   ├── basic/                # 基本テンプレート
│   ├── academic/             # 学術発表用
│   └── business/             # ビジネス用
├── samples/                   # サンプルスライド
│   └── demo-presentation/    # デモプレゼンテーション
├── scripts/                   # 支援スクリプト
│   ├── build.sh              # ビルドスクリプト
│   └── new-presentation.sh   # 新規作成スクリプト
├── .github/                   # GitHub設定
│   └── workflows/            # GitHub Actions
└── config/                    # 設定ファイル
    └── marp/                 # Marp設定
```

## クイックスタート

1. **環境準備**
   ```bash
   # Marpのインストール
   npm install -g @marp-team/marp-cli
   
   # リポジトリのクローン
   git clone https://github.com/your-username/AutoSlideIdea.git
   cd AutoSlideIdea
   ```

2. **新規プレゼンテーション作成**
   ```bash
   # スクリプトを使用
   ./scripts/new-presentation.sh my-presentation
   
   # または手動で
   cp -r templates/basic/ presentations/my-presentation/
   ```

3. **AI支援でコンテンツ作成**
   - Claude Codeを起動
   - プロンプト例: "presentations/my-presentation/slides.md にAIに関する5枚のスライドを作成してください"

4. **ビルド**
   ```bash
   # PDFを生成
   marp presentations/my-presentation/slides.md -o presentations/my-presentation/output.pdf
   ```

## 詳細ドキュメント

- [セットアップガイド](docs/setup.md)
- [作業フロー](docs/workflow.md)
- [Tips & Tricks](docs/tips.md)

## ライセンス

Apache-2.0