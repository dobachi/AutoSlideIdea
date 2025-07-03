# AI支援プレゼンテーション作成ガイド

## 概要

このプロジェクトは、Claude CodeやGemini CLIなどのAIツールを活用して効率的にプレゼンテーション資料を作成するための方法論とツールセットを提供します。

## 主な機能

- **Markdownベースのスライド作成**: Marpを使用したシンプルなスライド作成
- **AI支援コンテンツ生成**: Claude Code/Gemini CLIによる構成案・内容生成
- **AI指示書システム**: サブモジュールによる高度なAI制御
- **自動ビルド**: GitHub Actionsによる自動PDF生成
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
│   └── business/             # ビジネス用
├── samples/                   # サンプルスライド
│   └── demo-presentation/    # デモプレゼンテーション
├── scripts/                   # 支援スクリプト
│   ├── build.sh              # ビルドスクリプト
│   └── new-presentation.sh   # 新規作成スクリプト
├── .github/                   # GitHub設定
│   └── workflows/            # GitHub Actions
├── config/                    # 設定ファイル
│   └── marp/                 # Marp設定
└── presentations/             # 作成したプレゼンテーション
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

2. **新規プレゼンテーション作成**
   ```bash
   # ローカル作業用（デフォルト）
   ./scripts/create-presentation.sh my-presentation
   
   # GitHubリポジトリとして作成
   ./scripts/create-presentation.sh --github conference-2024
   
   # フルプロジェクト（調査・分析含む）
   ./scripts/create-presentation.sh --full research-project
   ./scripts/create-presentation.sh --github --full --public big-conference
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
# 最初からGitHubリポジトリとして作成
./scripts/create-presentation.sh --github my-conference-2024

# パブリックリポジトリとして作成（GitHub Pages対応）
./scripts/create-presentation.sh --github --public tech-talk-2024
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
- [高度なワークフロー](docs/advanced-workflow.md) - AI指示書システムを活用した調査・分析・アイデア創出
- [Tips & Tricks](docs/tips.md)

## ライセンス

Apache-2.0