# AI開発支援設定

このプロジェクトでは`instructions/ai_instruction_kits/`のAI指示書システムを使用します。
タスク開始時は`instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

## プロジェクト設定
- 言語: 日本語 (ja)
- チェックポイント管理: 有効
- チェックポイントスクリプト: scripts/checkpoint.sh
- ログファイル: checkpoint.log

## 重要なパス
- AI指示書システム: `instructions/ai_instruction_kits/`
- チェックポイントスクリプト: `scripts/checkpoint.sh`
- プロジェクト固有の設定: このファイル（`instructions/PROJECT.md`）

## プロジェクト固有の追加指示

### 調査フェーズのサポート

プレゼンテーション作成時は、以下の調査フローをサポート：

1. **情報収集フェーズ**
   - `slideflow research`コマンドで調査開始
   - Web検索、ドキュメント分析、データ収集をサポート
   - research/ディレクトリに体系的に保存

2. **AI活用**
   - インタラクティブモード: 対話しながら調査を進める
   - ノン・インタラクティブモード: バッチ処理で情報収集
   - 情報の要約、分析、構造化を自動化

3. **AI調査結果の記録**
   - AIが調査した内容は必ずresearch/ai-research/に保存
   - 引用元URL、アクセス日時、著者情報を記録
   - 生データと要約の両方を保持
   - 再現性と透明性を確保

4. **プレゼンテーションへの変換**
   - 調査結果から自動的にスライド構成を提案
   - 重要なデータや図表の抽出
   - 引用元情報の自動挿入

#### AI調査時の記録フォーマット

Web検索やドキュメント分析を行った場合、以下の形式で保存：

```bash
# セッションディレクトリの作成
SESSION_DIR="research/ai-research/$(date +%Y-%m-%d-%H%M%S)-[調査タイプ]"
mkdir -p "$SESSION_DIR"/{raw-results,analysis}
```

記録内容：
- query.txt: 検索クエリ
- sources.json: 引用元情報（URL、タイトル、著者、日時）
- summary.md: AI生成の要約
- raw-results/: 各ソースの全文

### AI自動実行オプション

1. **AIコマンド対応**: 以下のコマンドがインストールされている場合は自動実行（優先順位順）
   - `claude`: Anthropic CLI
   - `gemini`: Google Generative AI CLI
   - `llm`: 汎用LLMツール
   - `ollama`: ローカルLLM
2. **インタラクティブモード**: `slideflow research interactive`でAI結果を貼り付け
3. **手動実行**: プロンプトをコピーしてAIツールで実行

### 使用例

```bash
# AI Web検索（自動実行）
slideflow research ai-search "生成AIの最新動向"

# ドキュメント分析（自動実行）
slideflow research ai-analyze document.pdf

# インタラクティブモード
slideflow research interactive
research> ai-search AI活用事例
research> ai-result
[AI結果を貼り付け]
```

## コミット時の注意事項
- AIツール名（Claude等）をコミットメッセージに含めないでください
- クリーンなコミットが必要な場合は `scripts/commit.sh` を使用してください
- コミットメッセージはシンプルに保ち、余計な情報を含めないでください 
