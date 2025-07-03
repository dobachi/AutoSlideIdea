# AI支援プレゼンテーション作成ガイド

[English](README.en.md) | 日本語

## 概要

このプロジェクトは、Claude CodeやGemini CLIなどのAIツールを活用して効率的にプレゼンテーション資料を作成するための方法論とツールセットを提供します。

## 主な機能

- **Markdownベースのスライド作成**: Marpを使用したシンプルなスライド作成
- **AI支援コンテンツ生成**: Claude Code/Gemini CLIによる構成案・内容生成
- **AI指示書システム**: サブモジュールによる高度なAI制御
- **自動ビルド**: GitHub Actionsによる自動PDF生成
- **GitHub Pages対応**: プレゼンテーションをWebサイトとして公開
- **バージョン管理**: Gitによる変更履歴管理

## ディレクトリ構成

```
AutoSlideIdea/
├── README.md                  # このファイル
├── AI.md                      # AI向けプロジェクト指示書
├── CLAUDE.md                  # Claude Code用シンボリックリンク
├── .ai-instructions/          # AI指示書システム（サブモジュール）
│   └── instructions/          # 詳細な指示書群
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
│   └── build.sh              # ビルドスクリプト
├── config/                    # 設定ファイル
│   └── marp/                 # Marp設定
├── presentations/             # 作成したプレゼンテーション
├── package.json              # npm依存関係
└── CONTRIBUTING.md           # 貢献ガイドライン
```

## クイックスタート

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

2. **プレゼンテーション作成・管理**
   ```bash
   # 🎯 推奨：統合管理スクリプト（自動判定）
   ./scripts/manage-presentation.sh my-presentation
   
   # GitHub連携（新規なら作成、既存なら追加）
   ./scripts/manage-presentation.sh --github conference-2024
   
   # フルプロジェクト構造
   ./scripts/manage-presentation.sh --full research-project
   
   # GitHub Pages対応
   ./scripts/manage-presentation.sh --github --workflow github-pages my-web-presentation
   
   # 明示的な新規作成（既存の場合はエラー）
   ./scripts/manage-presentation.sh --create --github new-project
   
   # 明示的な更新（存在しない場合はエラー）  
   ./scripts/manage-presentation.sh --update --workflow github-pages existing-project
   ```

3. **AI支援でコンテンツ作成**
   - AIツール（Claude Code、Gemini CLIなど）を使用
   - プロンプト例: "presentations/my-presentation/slides.md にAIに関する5枚のスライドを作成してください"

4. **ビルド**
   ```bash
   # PDFを生成（npmスクリプト使用）
   npm run pdf -- presentations/my-presentation/slides.md -o presentations/my-presentation/output.pdf
   
   # またはnpxを使用
   npx marp presentations/my-presentation/slides.md -o presentations/my-presentation/output.pdf
   
   # プレビューモード
   npm run preview -- presentations/my-presentation/slides.md
   ```

## プレゼンテーション管理

presentations/ディレクトリは`.gitignore`で除外されているため、以下の2つの方法で管理できます：

### 1. ローカル作業（機密性重視）
- presentations/内で直接作業
- AutoSlideIdeaリポジトリにはプッシュされない
- 機密情報を含むプレゼンテーションに最適

```bash
# ローカルでプレゼンテーション作成
./scripts/create-presentation.sh my-local-presentation
cd presentations/my-local-presentation
# 作業はローカルのみで完結
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

## AI指示書システムについて

このプロジェクトは[AI指示書システム](https://github.com/dobachi/AI_Instruction_Sheet)をサブモジュールとして使用しています。

### 特徴

- **体系的な指示管理**: プロジェクト固有の指示を`.ai-instructions/`で管理
- **チェックポイント機能**: 作業進捗を自動的に記録
- **多言語対応**: 日本語・英語の指示書を提供
- **再利用可能**: 他のプロジェクトでも同じシステムを活用可能

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

- [セットアップガイド](docs/setup.md)
- [作業フロー](docs/workflow.md)
- [スクリプトリファレンス](docs/scripts-reference.md) - create-presentation.sh, update-presentation.shの詳細
- [GitHub Pages連携](docs/github-pages.md) - プレゼンテーションをWebサイトとして公開
- [高度なワークフロー](docs/advanced-workflow.md) - AI指示書システムを活用した調査・分析・アイデア創出
- [Tips & Tricks](docs/tips.md)

## ライセンス

Apache-2.0