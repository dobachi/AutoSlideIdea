# AI支援プレゼンテーション作成ガイド

[English](README.en.md) | 日本語

## 概要

このプロジェクトは、**Markdownベースのシンプルさを追求**し、Claude CodeやGemini CLIなどのAIツールを活用して効率的にプレゼンテーション資料を作成するための方法論とツールセットを提供します。

### コアコンセプト
- 📝 **Markdownファースト**: すべてのコンテンツをMarkdownで管理
- 🎯 **シンプルさの追求**: 複雑な設定を排除し、本質に集中
- 🔄 **テキストベース**: バージョン管理と共有が容易

🎯 **[デモプレゼンテーションを見る](https://dobachi.github.io/AutoSlideIdea/)** - 実際の出力例を確認できます

## 主な機能

- **Markdownベースのスライド作成**: Marpを使用したシンプルなスライド作成
- **AI支援コンテンツ生成**: Claude Code/Gemini CLIによる構成案・内容生成
- **AI指示書システム**: サブモジュールによる高度なAI制御
- **Mermaid図表統合**: フローチャート、シーケンス図、ガントチャートなどの自動変換
- **自動ビルド**: GitHub Actionsによる自動PDF生成
- **GitHub Pages対応**: プレゼンテーションをWebサイトとして公開
- **バージョン管理**: Gitによる変更履歴管理

## ディレクトリ構成

```
AutoSlideIdea/
├── README.md                  # このファイル
├── AI.md                      # AI向けプロジェクト指示書
├── CLAUDE.md                  # Claude Code用シンボリックリンク
├── slideflow/                 # SlideFlow統合プレゼンテーション管理システム
│   ├── slideflow.sh          # メインコマンド（AI統合、フェーズ管理）
│   ├── lib/                  # ライブラリ群
│   │   ├── ai_helper.sh      # AI支援機能
│   │   ├── interactive_ai.sh # 対話的AI支援
│   │   ├── ai_instruction_system.sh # AI指示書統合
│   │   └── project.sh        # プロジェクト管理
│   ├── instructions/         # フェーズ別指示書
│   │   ├── phases/          # プレゼンテーション作成フェーズ
│   │   └── situations/      # シチュエーション別指示
│   └── README.md            # SlideFlow詳細ドキュメント
├── instructions/              # AI指示書システム（高品質プロンプト）
│   └── ai_instruction_kits/  # 専門指示書パッケージ
├── docs/                      # ドキュメント
│   ├── setup.md              # セットアップガイド
│   ├── workflow.md           # 作業フロー
│   └── tips.md               # Tips & Tricks
├── templates/                 # テンプレート集
│   ├── basic/                # 基本テンプレート
│   ├── academic/             # 学術発表用
│   ├── business/             # ビジネス用
│   ├── full-project/         # 調査・分析含む完全版
│   └── github-workflows/     # GitHub Actions設定
├── samples/                   # サンプルスライド
│   └── demo-presentation/    # デモプレゼンテーション
├── scripts/                   # 支援スクリプト
│   ├── manage-presentation.sh # プレゼンテーション統合管理（推奨）
│   ├── create-presentation.sh # 作成スクリプト（非推奨：wrapper）
│   ├── update-presentation.sh # 更新スクリプト（非推奨：wrapper）
│   ├── preprocess-mermaid.sh  # Mermaid図表の前処理
│   ├── batch-preprocess-mermaid.sh # 複数ファイルのMermaid処理
│   └── build.sh              # ビルドスクリプト
├── config/                    # 設定ファイル
│   └── marp/                 # Marp設定
├── presentations/             # 作成したプレゼンテーション
└── package.json              # npm依存関係
```

## クイックスタート

> 💡 **まずは[デモサイト](https://dobachi.github.io/AutoSlideIdea/)で出力例を確認してみてください**

1. **環境準備**
   ```bash
   # リポジトリのクローン（サブモジュール含む）
   git clone --recursive https://github.com/your-username/AutoSlideIdea.git
   cd AutoSlideIdea
   
   # 依存関係のインストール（Marp CLI含む）
   npm install
   
   # 既存のクローンにサブモジュールを追加する場合
   git submodule update --init --recursive
   ```

2. **SlideFlowで統合プレゼンテーション管理**
   ```bash
   # 🎯 新推奨：SlideFlow統合システム
   ./slideflow/slideflow.sh new my-presentation
   
   # AI統合の対話的支援（フェーズ管理対応）
   ./slideflow/slideflow.sh ai
   
   # 簡易AI支援
   ./slideflow/slideflow.sh ai --quick tech
   
   # 特定フェーズの支援
   ./slideflow/slideflow.sh ai --phase planning
   
   # プレビューとビルド
   ./slideflow/slideflow.sh preview
   ./slideflow/slideflow.sh build pdf
   
   # 🔧 従来方式：スクリプト直接実行
   ./scripts/manage-presentation.sh my-presentation
   ./scripts/manage-presentation.sh --github conference-2024
   ```

3. **AI支援でコンテンツ作成**
   - **SlideFlow推奨**: 対話的フェーズ管理でステップバイステップ支援
   - **従来方式**: AIツール（Claude Code、Gemini CLIなど）を直接使用
   - プロンプト例: "presentations/my-presentation/slides.md にAIに関する5枚のスライドを作成してください"

4. **ビルド**
   ```bash
   # 🎯 SlideFlow推奨（統合コマンド）
   ./slideflow/slideflow.sh build html
   ./slideflow/slideflow.sh build pdf
   ./slideflow/slideflow.sh build pptx
   ./slideflow/slideflow.sh preview
   
   # 🔧 従来方式（直接実行）
   npm run html -- presentations/my-presentation/slides.md -o presentations/my-presentation/output.html
   npm run pdf -- presentations/my-presentation/slides.md -o presentations/my-presentation/output.pdf
   npm run preview -- presentations/my-presentation/slides.md
   ```

## プレゼンテーション管理

presentations/ディレクトリは`.gitignore`で除外されているため、以下の2つの方法で管理できます：

### 1. ローカル作業（機密性重視）
- presentations/内で直接作業
- AutoSlideIdeaリポジトリにはプッシュされない
- 機密情報を含むプレゼンテーションに最適

```bash
# 🎯 SlideFlow推奨（ローカル作業）
./slideflow/slideflow.sh new my-local-presentation
cd presentations/my-local-presentation
./slideflow/slideflow.sh ai  # AI支援でコンテンツ作成

# 🔧 従来方式
./scripts/create-presentation.sh my-local-presentation
```

### 2. 個別リポジトリ管理（共有・CI/CD対応）
- 独立したGitリポジトリとして管理
- GitHub Actions自動ビルド対応
- チーム共有やバージョン管理が必要な場合

```bash
# 🎯 推奨：統合管理スクリプト（自動判定）
./scripts/manage-presentation.sh --github my-conference-2024

# パブリックリポジトリとして作成
./scripts/manage-presentation.sh --github --public tech-talk-2024

# GitHub Pages専用ワークフローで作成（Webサイトとして公開）
./scripts/manage-presentation.sh --github --workflow github-pages portfolio-2024

# 従来方式（非推奨、自動転送される）
./scripts/create-presentation.sh --github legacy-project
```

詳細は[presentations/README.md](presentations/README.md)を参照してください。

## SlideFlow: 次世代プレゼンテーション作成システム

SlideFlowは、従来のスクリプトベースアプローチを統合し、AI支援を中核とした包括的なプレゼンテーション管理システムです。

### 主な特徴

- **フェーズ管理**: プレゼンテーション作成の各段階（企画→調査→設計→作成→レビュー）を体系的にサポート
- **対話的AI支援**: 各フェーズに最適化された専門的AI指示書との対話
- **セッション管理**: 作業進捗の継続的な追跡と再開機能
- **テンプレートシステム**: 用途別の豊富なテンプレート（学術、ビジネス、技術等）
- **マルチフォーマット**: HTML、PDF、PowerPoint等への一括変換

### 詳細情報

- [SlideFlow詳細ドキュメント](slideflow/README.md) - 機能一覧、API、使用例
- [AI指示書システム](instructions/ai_instruction_kits/) - 高品質プロンプトパッケージ

### 高度な活用方法

AI指示書システムの豊富な機能を活用することで、単なるスライド作成を超えた高度なプレゼンテーション開発が可能です：

#### 調査・分析フェーズ
- **データ分析指示書**（`basic_data_analysis.md`）を使用して、プレゼンに必要なデータを収集・分析
- **Python専門家指示書**（`python_expert.md`）でデータ可視化やグラフ生成
- **技術調査**: 最新技術トレンドの調査や競合分析

#### アイデア創出フェーズ
- **クリエイティブ指示書**（`basic_creative_work.md`）でブレインストーミング
- **複数の視点**: 異なるエージェント型指示書を切り替えて多角的なアイデア生成
- **構成の最適化**: 対象者に合わせた最適な構成を探索

#### コンテンツ作成フェーズ
- **テクニカルライター指示書**（`technical_writer.md`）で専門的な内容を分かりやすく
- **コードレビュー指示書**（`code_reviewer.md`）でコード例の品質向上
- **段階的な改善**: チェックポイント機能で各段階の進捗を管理

これにより、プレゼンテーション作成が単なる「スライド作り」から「総合的なコンテンツ開発プロジェクト」へと進化します。

### カスタマイズ

プロジェクト固有の指示は以下のファイルで定義されています：

- `AI.md` - プレゼン作成に特化したAI向け指示
- `CLAUDE.md` - Claude Code用（AI.mdへのシンボリックリンク）

## 詳細ドキュメント

- 📚 **[ドキュメントホーム](docs/)** - すべてのドキュメントの目次

### はじめに
- [セットアップガイド](docs/getting-started/setup.md)
- [基本ワークフロー](docs/getting-started/basic-workflow.md)

### ガイド
- [高度なワークフロー](docs/guides/advanced-workflow.md) - AI指示書システムを活用した調査・分析・アイデア創出
- [Tips & Tricks](docs/guides/tips.md)

### 機能
- [GitHub Pages連携](docs/features/github-pages.md) - プレゼンテーションをWebサイトとして公開（[デモ](https://dobachi.github.io/AutoSlideIdea/)）
- [CSSテーマ](docs/features/css-themes.md) - 情報量に応じた4種類のテーマ
- [Mermaid統合](docs/features/mermaid.md) - フローチャートや図表の作成

### リファレンス
- [スクリプトリファレンス](docs/reference/scripts.md) - create-presentation.sh, update-presentation.shの詳細

## プロジェクト情報

- [コントリビューションガイド](docs/development/contributing.md) - プロジェクトへの貢献方法
- [ロードマップ](docs/development/roadmap.md) - 今後の開発計画
- [ドキュメント一覧](docs/) - すべてのドキュメント

## ライセンス

MIT