# AI自動実行機能の実装オプション

## 現状の課題
- 現在はプロンプトを生成するのみ
- ユーザーが手動でAIツールにコピペする必要がある
- 調査結果の自動保存が機能していない

## 実装オプション

### オプション1: 専用AIコマンドの活用
```bash
# 各プロバイダーの専用コマンド（優先順位順）
claude "検索クエリ"        # Anthropic CLI
gemini "検索クエリ"        # Google Generative AI CLI
llm "検索クエリ"           # 汎用LLMツール
ollama run llama2 "検索クエリ"  # ローカルLLM
```

**メリット**:
- 各プロバイダーの最新機能を活用可能
- 柔軟な設定とカスタマイズ
- より高速で安定した実行

**デメリット**:
- 各コマンドのインストールが必要
- APIキーの設定が必要（Ollama以外）

### オプション2: Claude API直接利用
```bash
# Anthropic API経由
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{
    "model": "claude-3-5-sonnet-20241022",
    "messages": [{"role": "user", "content": "..."}]
  }'
```

**メリット**:
- 最新のClaude APIを直接利用
- カスタマイズ可能

**デメリット**:
- APIキーの管理が必要
- コスト管理が必要

### オプション3: ローカルLLM（Ollama等）
```bash
# Ollamaを使用
ollama run llama2 "検索クエリ"
```

**メリット**:
- 無料で使用可能
- プライバシー保護

**デメリット**:
- ローカルリソースが必要
- 品質が劣る場合がある

### オプション4: MCP (Model Context Protocol) サーバー
```bash
# MCPサーバーとして実装
slideflow research --mcp-server
```

**メリット**:
- Claude DesktopやCursorから直接利用可能
- 標準化されたプロトコル

**デメリット**:
- 実装が複雑
- MCP対応クライアントが必要

### オプション5: インタラクティブモード強化
```bash
# ユーザーがAIの結果を貼り付けるモード
slideflow research interactive
> ai-result
結果をペーストしてください（Ctrl+Dで終了）：
[ユーザーが結果を貼り付け]
```

**メリット**:
- 追加の依存関係なし
- どんなAIツールでも対応可能

**デメリット**:
- 完全自動ではない

## 推奨実装

### Phase 1: インタラクティブモード強化
1. プロンプト生成
2. ユーザーがAI実行
3. 結果を貼り付けるインターフェース
4. 自動的に構造化して保存

### Phase 2: AIコマンド対応（実装済み）
```bash
# 優先順位で利用可能なAIコマンドを自動選択
if command -v claude >/dev/null 2>&1; then
    result=$(claude "$prompt")
elif command -v gemini >/dev/null 2>&1; then
    result=$(gemini "$prompt")
elif command -v llm >/dev/null 2>&1; then
    result=$(llm "$prompt")
elif command -v ollama >/dev/null 2>&1; then
    result=$(ollama run llama2 "$prompt")
else
    # インタラクティブモードにフォールバック
fi
```

### Phase 3: API統合
- 環境変数でAPIキーを設定可能に
- 複数のAIプロバイダーに対応