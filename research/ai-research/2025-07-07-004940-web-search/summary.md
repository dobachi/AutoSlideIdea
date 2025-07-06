# 調査結果

## 概要
- クエリ: Claude Codeの使い方
- 日時: 2025-07-07 00:49

## 主要な発見
1. **簡単なインストール**: npmを使用して `npm install -g @anthropic-ai/claude-code` でインストール可能
2. **ターミナルベースのAIペアプログラマー**: 自然言語でコーディング支援を受けられる統合開発環境
3. **豊富な機能**: ファイル編集、バグ修正、テスト実行、Git操作、PR作成まで幅広くサポート

## 詳細情報
### Claude Code公式ドキュメント
- URL: https://docs.anthropic.com/en/docs/claude-code/overview
- 要約: Claude Codeは「ターミナルに住むエージェント型コーディングツール」として、自然言語コマンドを通じて開発者の生産性を向上させる。ファイル編集、バグ修正、テスト実行、Git操作、ドキュメント参照など幅広い機能を提供。

### Claude Codeを徹底解説してみた（前編）
- URL: https://dev.classmethod.jp/articles/get-started-claude-code-1/
- 要約: インストール方法から基本的な使い方まで日本語で詳しく解説。初回起動時の認証、料金プラン（APIキー/Pro/$20/Max/$100）、テーマ選択、作業フォルダの信頼性確認など、セットアップの流れを詳細に説明。

### Claude Code とは？主な特徴や使い方、料金体系を徹底解説
- URL: https://www.ai-souken.com/article/what-is-claude-code
- 要約: Claude Codeの特徴として、コードベース全体の理解、ファイル横断的なバグ修正、アーキテクチャに関する質問への回答、大規模リファクタリングの提案・実行能力を解説。

### Claude Code のすすめ - Speaker Deck
- URL: https://speakerdeck.com/schroneko/getting-started-with-claude-code
- 要約: 実践的な使い方のヒントを提供。新規アプリ作成、リポジトリクローン、ファイル分析・編集、bashコマンド実行、Git支援など具体的な活用例を紹介。

### 【初心者向け】Claude Code とは？インストールから使い方まで徹底解説
- URL: https://zenn.dev/takuh/articles/b846841c67f55d
- 要約: 初心者向けに基本コマンドを解説。`/clear`（会話履歴クリア）、`Esc`（作業停止）、`Shift+Tab`（モード切替）など便利なショートカットを紹介。

## 基本的な使い方ガイド

### インストール手順
1. Node.jsがインストールされていることを確認（必要に応じて `brew install node` 等でインストール）
2. npmを使用してClaude Codeをインストール:
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

### 初回起動
1. プロジェクトディレクトリで `claude` コマンドを実行
2. 認証画面で料金プランを選択（APIキー/Pro/Max）
3. ターミナルテーマを選択（Dark/Light/Dark colorblind-friendly）
4. 作業フォルダの信頼性を確認

### 基本コマンド
- `claude`: インタラクティブセッションを開始
- `claude "タスク"`: 一度きりのタスクを実行
- `claude -p "クエリ"`: クイッククエリを実行
- `claude commit`: Gitコミットを作成
- `/help`: 利用可能なコマンドを表示
- `exit` または `Ctrl+C`: Claude Codeを終了

### 効果的な使い方のヒント
1. **具体的に指示する**: エンジニアに対するように明確な指示を出す
2. **段階的に進める**: 複雑なタスクは小さなステップに分割
3. **プロジェクト理解から始める**: 「このプロジェクトは何をするものですか？」から開始
4. **CLAUDE.mdを活用**: プロジェクトルートにCLAUDE.mdファイルを配置して文脈を共有

### IDE統合
- クイック起動: `Cmd+Esc` (Mac) / `Ctrl+Esc` (Win/Linux)
- 開いているファイルをチャットに追加: `Cmd+Option+K` (Mac) / `Alt+Ctrl+K` (Win/Linux)
- diff表示で変更箇所をハイライト表示

### セキュリティ機能
- 承認フローで危険な操作を防止
- curlやwgetなど外部アクセスコマンドを自動ブロック
- `--dangerously-skip-permissions`オプションの使用は非推奨

## 引用元
- [Claude Code公式ドキュメント](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Claude Codeを徹底解説してみた（前編） | DevelopersIO](https://dev.classmethod.jp/articles/get-started-claude-code-1/)
- [Claude Codeとは？主な特徴や使い方、料金体系を徹底解説【活用例付き】 | AI総合研究所](https://www.ai-souken.com/article/what-is-claude-code)
- [Claude Codeで実用的なWebサービスを作る｜himara2](https://note.com/himaratsu/n/nddf0efa67d42)
- [Claude Code の使い方｜npaka](https://note.com/npaka/n/n3d754c78f439)
- [【初心者向け】Claude Code とは？インストールから使い方まで徹底解説](https://zenn.dev/takuh/articles/b846841c67f55d)
- [Claude Code のすすめ - Speaker Deck](https://speakerdeck.com/schroneko/getting-started-with-claude-code)
- [Claude Codeを使ってみた](https://zenn.dev/mixi/articles/daee52c49e739b)
- [Claude Code を初めて使う人向けの実践ガイド](https://zenn.dev/hokuto_tech/articles/86d1edb33da61a)
- [バイブコーディングチュートリアル：Claude Code でカンバンアプリケーションを作成しよう](https://azukiazusa.dev/blog/vibe-coding-tutorial-create-app-with-claude-code/)