#!/bin/bash
# research.sh - 調査フェーズサポート機能

# カラー定義（親スクリプトから継承されない場合のため）
GREEN=${GREEN:-'\033[0;32m'}
BLUE=${BLUE:-'\033[0;34m'}
YELLOW=${YELLOW:-'\033[1;33m'}
RED=${RED:-'\033[0;31m'}
CYAN=${CYAN:-'\033[0;36m'}
NC=${NC:-'\033[0m'}

# AI統合機能の有効化チェック
AI_ENABLED=false
if [ -f "$SLIDEFLOW_DIR/lib/ai_helper.sh" ]; then
    source "$SLIDEFLOW_DIR/lib/ai_helper.sh"
    AI_ENABLED=true
fi

# 調査ディレクトリの初期化
research_init() {
    local presentation_path="${1:-.}"
    local research_dir="$presentation_path/research"
    
    echo -e "${BLUE}📚 調査ディレクトリを初期化します...${NC}"
    
    # ディレクトリ構造の作成
    mkdir -p "$research_dir"/{sources/{web,documents,data},notes,ai-research,analysis}
    
    # README.mdの作成
    cat > "$research_dir/README.md" << EOF
# 調査資料

このディレクトリには、プレゼンテーション作成のための調査資料が保存されます。

## ディレクトリ構造

- **sources/** - 情報源
  - **web/** - Web収集した情報
  - **documents/** - ドキュメント
  - **data/** - データファイル
- **notes/** - 調査メモ
- **ai-research/** - AI調査結果
- **analysis/** - 分析結果

## 使い方

\`\`\`bash
# メモの追加
slideflow research add-note "重要な発見..."

# ソースの追加
slideflow research add-source "https://example.com/article"

# AI調査の実行
slideflow research ai-search "検索クエリ"
\`\`\`
EOF
    
    # .gitignoreの設定（大きなファイルを除外）
    if [ ! -f "$presentation_path/.gitignore" ]; then
        cat > "$presentation_path/.gitignore" << EOF
# 大きなデータファイル
research/sources/data/*.csv
research/sources/data/*.xlsx
research/sources/data/*.db

# 一時ファイル
*.tmp
*.cache

# プライベートメモ
research/notes/private/
EOF
    else
        # 既存の.gitignoreに追記
        if ! grep -q "research/sources/data/" "$presentation_path/.gitignore"; then
            echo -e "\n# Research data files\nresearch/sources/data/*.csv\nresearch/sources/data/*.xlsx" >> "$presentation_path/.gitignore"
        fi
    fi
    
    echo -e "${GREEN}✅ 調査ディレクトリを初期化しました: $research_dir${NC}"
}

# メモの追加
research_add_note() {
    local content="$1"
    local presentation_path="${2:-.}"
    local research_dir="$presentation_path/research"
    local notes_dir="$research_dir/notes"
    
    # ディレクトリの確認
    if [ ! -d "$notes_dir" ]; then
        echo -e "${YELLOW}⚠️  調査ディレクトリが見つかりません。初期化します...${NC}"
        research_init "$presentation_path"
    fi
    
    # タイムスタンプ付きファイル名
    local timestamp=$(date +%Y-%m-%d-%H%M%S)
    local note_file="$notes_dir/${timestamp}.md"
    
    # メモの保存
    cat > "$note_file" << EOF
# 調査メモ

**作成日時**: $(date "+%Y年%m月%d日 %H:%M:%S")

## 内容

$content

---
EOF
    
    echo -e "${GREEN}✅ メモを保存しました: $note_file${NC}"
    
    # summary.mdの更新
    update_research_summary "$presentation_path"
}

# ソース情報の追加
research_add_source() {
    local source_url="$1"
    local presentation_path="${2:-.}"
    local source_type="${3:-web}"
    local research_dir="$presentation_path/research"
    local sources_dir="$research_dir/sources/$source_type"
    
    # ディレクトリの確認
    if [ ! -d "$sources_dir" ]; then
        echo -e "${YELLOW}⚠️  調査ディレクトリが見つかりません。初期化します...${NC}"
        research_init "$presentation_path"
    fi
    
    # タイムスタンプ付きファイル名
    local timestamp=$(date +%Y-%m-%d-%H%M%S)
    local source_file="$sources_dir/${timestamp}-source.md"
    
    # ソース情報の保存
    cat > "$source_file" << EOF
# ソース情報

**URL/パス**: $source_url
**収集日時**: $(date "+%Y年%m月%d日 %H:%M:%S")
**タイプ**: $source_type

## メモ

（ここに要約や重要ポイントを記載）

---
EOF
    
    echo -e "${GREEN}✅ ソース情報を保存しました: $source_file${NC}"
    echo -e "${BLUE}💡 ヒント: ファイルを編集して要約や重要ポイントを追加してください${NC}"
}

# AI Web検索の実行
research_ai_search() {
    local query="$1"
    local presentation_path="${2:-.}"
    local research_dir="$presentation_path/research"
    
    # ディレクトリの確認
    if [ ! -d "$research_dir" ]; then
        echo -e "${YELLOW}⚠️  調査ディレクトリが見つかりません。初期化します...${NC}"
        research_init "$presentation_path"
    fi
    
    echo -e "${BLUE}🔍 AI Web検索を実行します...${NC}"
    echo -e "クエリ: $query"
    echo ""
    
    # セッションディレクトリの作成
    local session_name="$(date +%Y-%m-%d-%H%M%S)-web-search"
    local session_dir="$research_dir/ai-research/$session_name"
    mkdir -p "$session_dir"
    
    # クエリの保存
    echo "$query" > "$session_dir/query.txt"
    
    # AI指示の作成
    local ai_prompt="以下のクエリについてWeb検索を行い、関連情報を調査してください。
調査結果は必ず $session_dir/summary.md に保存してください。

クエリ: $query

調査タスク:
1. Web検索を実行して関連情報を収集
2. 各情報源のURLとアクセス日時を記録
3. 重要な情報を要約
4. 以下の形式で $session_dir/summary.md に保存

必須フォーマット:
\`\`\`markdown
# AI調査結果

## 調査概要
- **クエリ**: $query
- **実行日時**: $(date "+%Y年%m月%d日 %H:%M:%S")
- **使用AI**: [使用したAIツール名]

## 調査結果サマリー
1. [主要な発見1]
2. [主要な発見2]
3. [主要な発見3]

## 詳細情報

### 情報源1: [タイトル]
- **URL**: [実際のURL]
- **アクセス日時**: [日時]
- **要約**: [内容の要約]

### 情報源2: [タイトル]
- **URL**: [実際のURL]
- **アクセス日時**: [日時]
- **要約**: [内容の要約]

## 引用元一覧
- [タイトル1](URL1) - アクセス日: [日付]
- [タイトル2](URL2) - アクセス日: [日付]
\`\`\`

また、各情報源の詳細な内容を $session_dir/raw-results/ ディレクトリに source-001.md, source-002.md として保存してください。"
    
    # プロンプトファイルの保存
    echo "$ai_prompt" > "$session_dir/ai-prompt.txt"
    
    # 利用可能なAIコマンドを検索して自動実行
    local ai_executed=false
    local result=""
    
    # 優先順位: 1. claude, 2. gemini, 3. llm, 4. ollama, 5. continue, 6. aider, 7. gh copilot
    
    # 1. Claude
    if command -v claude >/dev/null 2>&1; then
        echo -e "${CYAN}claudeコマンドを使用してAI検索を実行します...${NC}"
        result=$(timeout 60 claude "$ai_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/summary.md"
            ai_executed=true
        else
            echo -e "${YELLOW}⚠️  claudeコマンドの実行に失敗しました${NC}"
        fi
    fi
    
    # 2. Gemini
    if [ "$ai_executed" = false ] && command -v gemini >/dev/null 2>&1; then
        echo -e "${CYAN}geminiコマンドを使用してAI検索を実行します...${NC}"
        result=$(timeout 60 gemini "$ai_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/summary.md"
            ai_executed=true
        else
            echo -e "${YELLOW}⚠️  geminiコマンドの実行に失敗しました${NC}"
        fi
    fi
    
    # 3. llm
    if [ "$ai_executed" = false ] && command -v llm >/dev/null 2>&1; then
        echo -e "${CYAN}llmコマンドを使用してAI検索を実行します...${NC}"
        result=$(timeout 60 llm "$ai_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/summary.md"
            ai_executed=true
        else
            echo -e "${YELLOW}⚠️  llmコマンドの実行に失敗しました${NC}"
        fi
    fi
    
    # 4. Ollama
    if [ "$ai_executed" = false ] && command -v ollama >/dev/null 2>&1; then
        echo -e "${CYAN}ollamaを使用してAI検索を実行します...${NC}"
        # Ollamaは少し異なる形式
        result=$(timeout 60 ollama run llama2 "$ai_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/summary.md"
            ai_executed=true
        else
            echo -e "${YELLOW}⚠️  ollamaコマンドの実行に失敗しました${NC}"
        fi
    fi
    
    # 5. Continue (VS Code Extension CLI)
    if [ "$ai_executed" = false ] && command -v continue >/dev/null 2>&1; then
        echo -e "${CYAN}continueコマンドを使用してAI検索を実行します...${NC}"
        result=$(timeout 60 continue ask "$ai_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/summary.md"
            ai_executed=true
        else
            echo -e "${YELLOW}⚠️  continueコマンドの実行に失敗しました${NC}"
        fi
    fi
    
    # 6. aider (AI pair programming tool)
    if [ "$ai_executed" = false ] && command -v aider >/dev/null 2>&1; then
        echo -e "${CYAN}aiderを使用してAI検索を実行します...${NC}"
        # aiderは一時ファイル経由で実行
        echo "$ai_prompt" | timeout 60 aider --no-git --yes --message-file - 2>/dev/null > "$session_dir/summary.md"
        if [ $? -eq 0 ] && [ -s "$session_dir/summary.md" ]; then
            ai_executed=true
        else
            echo -e "${YELLOW}⚠️  aiderコマンドの実行に失敗しました${NC}"
        fi
    fi
    
    # 7. GitHub Copilot CLI
    if [ "$ai_executed" = false ] && command -v gh >/dev/null 2>&1 && gh copilot --version >/dev/null 2>&1; then
        echo -e "${CYAN}GitHub Copilot CLIを使用してAI検索を実行します...${NC}"
        result=$(timeout 60 gh copilot suggest "$ai_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/summary.md"
            ai_executed=true
        else
            echo -e "${YELLOW}⚠️  GitHub Copilot CLIの実行に失敗しました${NC}"
        fi
    fi
    
    if [ "$ai_executed" = true ]; then
        echo -e "${GREEN}✅ AI検索が完了し、結果を保存しました${NC}"
        echo -e "保存先: $session_dir/summary.md"
        
        # ステータスを更新
        local temp_file=$(mktemp)
        jq '.status = "completed"' "$session_dir/metadata.json" > "$temp_file"
        mv "$temp_file" "$session_dir/metadata.json"
        
        # サマリーの更新
        update_research_summary "$presentation_path"
        return 0
    fi
    
    # llmコマンドが使えない場合は手動実行を促す
    echo -e "${GREEN}✅ AI検索プロンプトを作成しました${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "$ai_prompt"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}👉 以下のいずれかの方法で実行してください:${NC}"
    echo -e "${YELLOW}   1. 上記のプロンプトをAIツール（Claude Code、Cursor等）にコピー${NC}"
    echo -e "${YELLOW}   2. AIコマンドをインストール:${NC}"
    echo -e "${YELLOW}      - claude: Anthropic Claude CLI${NC}"
    echo -e "${YELLOW}      - gemini: Google Gemini CLI${NC}"
    echo -e "${YELLOW}      - llm: pip install llm${NC}"
    echo -e "${YELLOW}      - ollama: https://ollama.ai${NC}"
    echo -e "${YELLOW}      - continue: VS Code Continue拡張機能${NC}"
    echo -e "${YELLOW}      - aider: pip install aider-chat${NC}"
    echo -e "${YELLOW}      - gh copilot: gh extension install github/gh-copilot${NC}"
    echo -e "${YELLOW}   3. インタラクティブモードで結果を貼り付け: slideflow research interactive${NC}"
    echo ""
    echo -e "${YELLOW}AIが調査結果を保存する場所: $session_dir${NC}"
    echo ""
    
    # メタデータの保存
    cat > "$session_dir/metadata.json" << EOF
{
  "query": "$query",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "session_id": "$session_name",
  "status": "pending"
}
EOF
    
    # サマリーの更新
    update_research_summary "$presentation_path"
}

# AIドキュメント分析
research_ai_analyze() {
    local file_path="$1"
    local presentation_path="${2:-.}"
    local research_dir="$presentation_path/research"
    
    # ファイルの存在確認
    if [ ! -f "$file_path" ]; then
        echo -e "${YELLOW}⚠️  ファイルが見つかりません: $file_path${NC}"
        return 1
    fi
    
    # ディレクトリの確認
    if [ ! -d "$research_dir" ]; then
        echo -e "${YELLOW}⚠️  調査ディレクトリが見つかりません。初期化します...${NC}"
        research_init "$presentation_path"
    fi
    
    echo -e "${BLUE}📄 AIドキュメント分析プロンプトを生成します...${NC}"
    echo -e "対象ファイル: $file_path"
    echo ""
    
    # セッションディレクトリの作成
    local session_name="$(date +%Y-%m-%d-%H%M%S)-doc-analysis"
    local session_dir="$research_dir/ai-research/$session_name"
    mkdir -p "$session_dir"
    
    # ファイル情報の保存
    echo "$file_path" > "$session_dir/input-file.txt"
    
    # ファイルをコピー
    cp "$file_path" "$session_dir/original-document"
    
    # AI指示の作成
    local ai_prompt="以下のドキュメントを分析し、重要な情報を抽出してください。
分析結果は必ず $session_dir/analysis.md に保存してください。

対象ファイル: $file_path

分析タスク:
1. ドキュメントの概要を把握
2. 重要なポイントを抽出
3. プレゼンテーションに活用できる情報を特定
4. 以下の形式で $session_dir/analysis.md に保存

必須フォーマット:
\`\`\`markdown
# ドキュメント分析結果

## 分析概要
- **ファイル名**: $(basename "$file_path")
- **分析日時**: $(date "+%Y年%m月%d日 %H:%M:%S")
- **使用AI**: [使用したAIツール名]

## ドキュメント概要
[ドキュメントの主題と目的を2-3文で説明]

## 主要なポイント
1. [重要ポイント1]
2. [重要ポイント2]
3. [重要ポイント3]

## プレゼンテーションへの活用案

### スライド案1: [タイトル]
- ポイント1
- ポイント2
- ポイント3

### スライド案2: [タイトル]
- ポイント1
- ポイント2

## 引用可能な重要箇所
> [引用文1]
> （ページ番号または場所）

> [引用文2]
> （ページ番号または場所）

## キーワード
- キーワード1
- キーワード2
- キーワード3
\`\`\`"
    
    # プロンプトファイルの保存
    echo "$ai_prompt" > "$session_dir/ai-prompt.txt"
    
    # 利用可能なAIコマンドを検索して自動実行
    local ai_executed=false
    local result=""
    local full_prompt="$ai_prompt

以下がファイルの内容です:
---
$(cat "$file_path" 2>/dev/null | head -5000)
---"
    
    # 優先順位: 1. claude, 2. gemini, 3. llm, 4. ollama, 5. continue, 6. aider, 7. gh copilot
    
    # 1. Claude
    if command -v claude >/dev/null 2>&1; then
        echo -e "${CYAN}claudeコマンドを使用してドキュメント分析を実行します...${NC}"
        result=$(timeout 60 claude "$full_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/analysis.md"
            ai_executed=true
        fi
    fi
    
    # 2. Gemini
    if [ "$ai_executed" = false ] && command -v gemini >/dev/null 2>&1; then
        echo -e "${CYAN}geminiコマンドを使用してドキュメント分析を実行します...${NC}"
        result=$(timeout 60 gemini "$full_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/analysis.md"
            ai_executed=true
        fi
    fi
    
    # 3. llm
    if [ "$ai_executed" = false ] && command -v llm >/dev/null 2>&1; then
        echo -e "${CYAN}llmコマンドを使用してドキュメント分析を実行します...${NC}"
        result=$(timeout 60 llm "$full_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/analysis.md"
            ai_executed=true
        fi
    fi
    
    # 4. Ollama
    if [ "$ai_executed" = false ] && command -v ollama >/dev/null 2>&1; then
        echo -e "${CYAN}ollamaを使用してドキュメント分析を実行します...${NC}"
        result=$(timeout 60 ollama run llama2 "$full_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/analysis.md"
            ai_executed=true
        fi
    fi
    
    # 5. Continue
    if [ "$ai_executed" = false ] && command -v continue >/dev/null 2>&1; then
        echo -e "${CYAN}continueコマンドを使用してドキュメント分析を実行します...${NC}"
        result=$(timeout 60 continue ask "$full_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/analysis.md"
            ai_executed=true
        fi
    fi
    
    # 6. aider
    if [ "$ai_executed" = false ] && command -v aider >/dev/null 2>&1; then
        echo -e "${CYAN}aiderを使用してドキュメント分析を実行します...${NC}"
        echo "$full_prompt" | timeout 60 aider --no-git --yes --message-file - 2>/dev/null > "$session_dir/analysis.md"
        if [ $? -eq 0 ] && [ -s "$session_dir/analysis.md" ]; then
            ai_executed=true
        fi
    fi
    
    # 7. GitHub Copilot CLI
    if [ "$ai_executed" = false ] && command -v gh >/dev/null 2>&1 && gh copilot --version >/dev/null 2>&1; then
        echo -e "${CYAN}GitHub Copilot CLIを使用してドキュメント分析を実行します...${NC}"
        result=$(timeout 60 gh copilot suggest "$full_prompt" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$result" ]; then
            echo "$result" > "$session_dir/analysis.md"
            ai_executed=true
        fi
    fi
    
    if [ "$ai_executed" = true ]; then
        echo -e "${GREEN}✅ ドキュメント分析が完了し、結果を保存しました${NC}"
        echo -e "保存先: $session_dir/analysis.md"
        
        # ステータスを更新
        local temp_file=$(mktemp)
        jq '.status = "completed"' "$session_dir/metadata.json" > "$temp_file"
        mv "$temp_file" "$session_dir/metadata.json"
        
        # サマリーの更新
        update_research_summary "$presentation_path"
        return 0
    fi
    
    # llmコマンドが使えない場合は手動実行を促す
    echo -e "${GREEN}✅ AI分析プロンプトを作成しました${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "$ai_prompt"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}👉 以下のいずれかの方法で実行してください:${NC}"
    echo -e "${YELLOW}   1. 上記のプロンプトをAIツール（Claude Code、Cursor等）にコピー${NC}"
    echo -e "${YELLOW}   2. AIコマンドをインストール:${NC}"
    echo -e "${YELLOW}      - claude: Anthropic Claude CLI${NC}"
    echo -e "${YELLOW}      - gemini: Google Gemini CLI${NC}"
    echo -e "${YELLOW}      - llm: pip install llm${NC}"
    echo -e "${YELLOW}      - ollama: https://ollama.ai${NC}"
    echo -e "${YELLOW}      - continue: VS Code Continue拡張機能${NC}"
    echo -e "${YELLOW}      - aider: pip install aider-chat${NC}"
    echo -e "${YELLOW}      - gh copilot: gh extension install github/gh-copilot${NC}"
    echo -e "${YELLOW}   3. インタラクティブモードで結果を貼り付け: slideflow research interactive${NC}"
    echo ""
    echo -e "${YELLOW}対象ファイル: $file_path${NC}"
    echo -e "${YELLOW}AIが分析結果を保存する場所: $session_dir${NC}"
    echo ""
    
    # メタデータの保存
    cat > "$session_dir/metadata.json" << EOF
{
  "file_path": "$file_path",
  "file_name": "$(basename "$file_path")",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "session_id": "$session_name",
  "status": "pending"
}
EOF
    
    # サマリーの更新
    update_research_summary "$presentation_path"
}

# AI調査結果の保存
research_save_ai_result() {
    local query="$1"
    local result="$2"
    local sources="$3"
    local presentation_path="${4:-.}"
    local research_dir="$presentation_path/research"
    local ai_dir="$research_dir/ai-research"
    
    # セッションディレクトリの作成
    local session_name="$(date +%Y-%m-%d-%H%M%S)-web-search"
    local session_dir="$ai_dir/$session_name"
    mkdir -p "$session_dir"/{raw-results,analysis}
    
    # クエリの保存
    echo "$query" > "$session_dir/query.txt"
    
    # メタデータの保存
    cat > "$session_dir/metadata.json" << EOF
{
  "query": "$query",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "ai_model": "Claude 3.5 Sonnet",
  "search_type": "web_search"
}
EOF
    
    # 要約の保存
    cat > "$session_dir/summary.md" << EOF
# AI調査結果

## 調査概要
- **クエリ**: $query
- **実行日時**: $(date "+%Y年%m月%d日 %H:%M:%S")
- **使用AI**: Claude 3.5 Sonnet

## 調査結果

$result

## 引用元一覧

$sources
EOF
    
    echo -e "${GREEN}✅ AI調査結果を保存しました: $session_dir${NC}"
}

# 調査サマリーの更新
update_research_summary() {
    local presentation_path="${1:-.}"
    local research_dir="$presentation_path/research"
    local summary_file="$research_dir/summary.md"
    
    # サマリーファイルの作成/更新
    cat > "$summary_file" << EOF
# 調査サマリー

**最終更新**: $(date "+%Y年%m月%d日 %H:%M:%S")

## 最近のメモ

EOF
    
    # 最新5件のメモを追加
    if [ -d "$research_dir/notes" ]; then
        local note_count=0
        for note in $(ls -t "$research_dir/notes"/*.md 2>/dev/null | head -5); do
            if [ -f "$note" ]; then
                echo "### $(basename "$note" .md)" >> "$summary_file"
                # 最初の5行を抽出（ヘッダーを除く）
                grep -v "^#\|^**\|^---" "$note" | head -5 >> "$summary_file"
                echo "" >> "$summary_file"
                ((note_count++))
            fi
        done
    fi
    
    # AI調査結果のサマリー
    echo -e "\n## AI調査結果\n" >> "$summary_file"
    if [ -d "$research_dir/ai-research" ]; then
        for session in $(ls -t "$research_dir/ai-research" 2>/dev/null | head -3); do
            if [ -f "$research_dir/ai-research/$session/query.txt" ]; then
                echo "- **$session**: $(cat "$research_dir/ai-research/$session/query.txt")" >> "$summary_file"
            fi
        done
    fi
}

# インタラクティブモード
research_interactive() {
    local presentation_path="${1:-.}"
    
    echo -e "${BLUE}🔍 調査インタラクティブモード${NC}"
    echo -e "利用可能なコマンド:"
    echo -e "  ${GREEN}note${NC} - メモを追加"
    echo -e "  ${GREEN}source${NC} - ソースを追加"
    echo -e "  ${GREEN}ai-search${NC} - AI Web検索"
    echo -e "  ${GREEN}ai-result${NC} - AI結果を貼り付け"
    echo -e "  ${GREEN}list${NC} - 調査内容一覧"
    echo -e "  ${GREEN}summary${NC} - サマリーを表示"
    echo -e "  ${GREEN}exit${NC} - 終了"
    echo ""
    
    while true; do
        read -p "research> " cmd args
        
        case "$cmd" in
            note)
                if [ -z "$args" ]; then
                    echo "メモの内容を入力してください:"
                    read -r note_content
                else
                    note_content="$args"
                fi
                research_add_note "$note_content" "$presentation_path"
                ;;
            source)
                if [ -z "$args" ]; then
                    echo "ソースのURLまたはパスを入力してください:"
                    read -r source_url
                else
                    source_url="$args"
                fi
                research_add_source "$source_url" "$presentation_path"
                ;;
            ai-search)
                if [ -z "$args" ]; then
                    echo "検索クエリを入力してください:"
                    read -r query
                else
                    query="$args"
                fi
                research_ai_search "$query" "$presentation_path"
                ;;
            ai-result)
                echo -e "${BLUE}AI結果を貼り付けてください（Ctrl+Dで終了）:${NC}"
                local ai_result=""
                while IFS= read -r line; do
                    ai_result+="$line"$'\n'
                done
                
                # 最新のAIセッションを検索
                local latest_session=$(ls -t "$presentation_path/research/ai-research" 2>/dev/null | head -1)
                if [ -n "$latest_session" ]; then
                    local session_dir="$presentation_path/research/ai-research/$latest_session"
                    echo "$ai_result" > "$session_dir/summary.md"
                    echo -e "${GREEN}✅ AI結果を保存しました: $session_dir/summary.md${NC}"
                    
                    # ステータスを更新
                    if [ -f "$session_dir/metadata.json" ]; then
                        local temp_file=$(mktemp)
                        jq '.status = "completed"' "$session_dir/metadata.json" > "$temp_file"
                        mv "$temp_file" "$session_dir/metadata.json"
                    fi
                else
                    echo -e "${YELLOW}⚠️  AIセッションが見つかりません。先にai-searchを実行してください${NC}"
                fi
                ;;
            list)
                research_list "$presentation_path"
                ;;
            summary)
                if [ -f "$presentation_path/research/summary.md" ]; then
                    cat "$presentation_path/research/summary.md"
                else
                    echo -e "${YELLOW}サマリーがまだありません${NC}"
                fi
                ;;
            exit|quit)
                echo -e "${GREEN}調査モードを終了します${NC}"
                break
                ;;
            *)
                echo -e "${YELLOW}不明なコマンド: $cmd${NC}"
                echo "利用可能: note, source, ai-search, ai-result, list, summary, exit"
                ;;
        esac
        echo ""
    done
}

# 調査内容の一覧表示
research_list() {
    local presentation_path="${1:-.}"
    local research_dir="$presentation_path/research"
    
    if [ ! -d "$research_dir" ]; then
        echo -e "${YELLOW}調査ディレクトリが見つかりません${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📋 調査内容一覧${NC}"
    echo ""
    
    # メモ
    echo -e "${GREEN}[メモ]${NC}"
    if [ -d "$research_dir/notes" ]; then
        for note in $(ls -t "$research_dir/notes"/*.md 2>/dev/null | head -10); do
            if [ -f "$note" ]; then
                echo "  - $(basename "$note")"
            fi
        done
    fi
    echo ""
    
    # ソース
    echo -e "${GREEN}[ソース]${NC}"
    for type in web documents data; do
        if [ -d "$research_dir/sources/$type" ] && [ "$(ls -A "$research_dir/sources/$type" 2>/dev/null)" ]; then
            echo "  $type/:"
            for source in $(ls -t "$research_dir/sources/$type" 2>/dev/null | head -5); do
                echo "    - $source"
            done
        fi
    done
    echo ""
    
    # AI調査
    echo -e "${GREEN}[AI調査結果]${NC}"
    if [ -d "$research_dir/ai-research" ]; then
        for session in $(ls -t "$research_dir/ai-research" 2>/dev/null | head -5); do
            if [ -f "$research_dir/ai-research/$session/query.txt" ]; then
                echo "  - $session: $(cat "$research_dir/ai-research/$session/query.txt")"
            fi
        done
    fi
}