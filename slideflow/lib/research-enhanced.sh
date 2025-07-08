#!/usr/bin/env bash

# Enhanced research functions with standardized directory structure
# Source this file to override the default research.sh functions

# 設定ファイルを読み込む
source "${SLIDEFLOW_HOME}/config/ai-research-config.sh"

# AI調査結果の検証関数
validate_ai_research_structure() {
    local session_dir="$1"
    local errors=()
    
    # 必須ディレクトリのチェック
    for dir in "${AI_RESEARCH_DIRS[@]}"; do
        if [[ ! -d "$session_dir/$dir" ]]; then
            errors+=("必須ディレクトリが不足: $dir")
        fi
    done
    
    # 必須ファイルのチェック
    for file in "${AI_RESEARCH_REQUIRED_FILES[@]}"; do
        if [[ ! -f "$session_dir/$file" ]]; then
            errors+=("必須ファイルが不足: $file")
        fi
    done
    
    # メタデータの検証
    if [[ -f "$session_dir/metadata.json" ]]; then
        # JSONの妥当性チェック
        if ! jq empty "$session_dir/metadata.json" 2>/dev/null; then
            errors+=("metadata.jsonが不正なJSON形式です")
        else
            # 必須フィールドのチェック
            for field in "${AI_RESEARCH_METADATA_FIELDS[@]}"; do
                if ! jq -e ".$field" "$session_dir/metadata.json" >/dev/null 2>&1; then
                    errors+=("metadata.jsonに必須フィールドが不足: $field")
                fi
            done
        fi
    fi
    
    # エラーがある場合は報告
    if [[ ${#errors[@]} -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  AI調査結果の構造に問題があります:${NC}"
        for error in "${errors[@]}"; do
            echo "  - $error"
        done
        return 1
    fi
    
    return 0
}

# 強化版 research_ai_search 関数
research_ai_search_enhanced() {
    local query="$1"
    local path="${2:-.}"
    local interactive_flag="${3:-true}"
    
    # 既存のバリデーション処理...
    path="$(resolve_presentation_path "$path")" || return 1
    cd "$path" || return 1
    
    # researchディレクトリの確認
    if [ ! -d "research" ]; then
        echo -e "${YELLOW}⚠️  researchディレクトリが見つかりません${NC}"
        echo "ヒント: slideflow research init で初期化してください"
        return 1
    fi
    
    # AI検索セッションの作成
    local session_name="$(date +%Y-%m-%d-%H%M%S)-search"
    local session_dir="research/ai-research/$session_name"
    
    # 必須ディレクトリ構造の作成
    mkdir -p "$session_dir"/{raw-results,analysis,sources}
    
    # クエリの保存
    echo "$query" > "$session_dir/query.txt"
    
    # メタデータの初期化
    cat > "$session_dir/metadata.json" <<EOF
{
    "query": "$query",
    "timestamp": "$(date -Iseconds)",
    "session_id": "$session_name",
    "status": "pending",
    "research_type": "web-search",
    "duration_seconds": 0,
    "sources_count": 0,
    "ai_tool": "",
    "language": "ja"
}
EOF
    
    # AI指示書テンプレートの読み込み
    local ai_instruction=""
    if [[ -f "$AI_RESEARCH_INSTRUCTION_TEMPLATE" ]]; then
        ai_instruction=$(cat "$AI_RESEARCH_INSTRUCTION_TEMPLATE")
    fi
    
    # 強化版AIプロンプトの作成
    local ai_prompt="# AI調査タスク

## 調査クエリ
「$query」

## 実行指示
以下の手順で調査を実行し、指定されたフォーマットで結果を保存してください。

### 1. 情報収集
WebSearchまたはWebFetchツールを使って情報を収集してください。

### 2. ファイル保存
調査結果は必ず以下のパスに保存してください：
- セッションディレクトリ: $session_dir/

### 3. 必須ファイル
以下のファイルを必ず作成してください：

#### summary.md (調査サマリー)
\`\`\`markdown
# 調査サマリー：$query

## 概要
[調査の簡潔な概要を記載]

## 主要な発見
1. [重要な発見1]
2. [重要な発見2]
3. [重要な発見3]

## 次のステップ
[推奨される次のアクション]
\`\`\`

#### report.md (詳細レポート)
\`\`\`markdown
# 調査レポート：$query

## エグゼクティブサマリー
- 調査の目的：[目的を記載]
- 主要な発見：[3-5点]
- 推奨事項：[主要な推奨事項]

## 調査概要
- 調査日時：$(date '+%Y-%m-%d %H:%M:%S')
- 調査手法：Web検索
- 検索キーワード：$query
- 調査範囲：[対象期間、地域、分野など]

## 詳細分析

### 1. [セクション名]
[詳細な内容]

### 2. [セクション名]
[詳細な内容]

## データと根拠
[収集したデータの要約、統計情報、重要な引用]

## 結論と推奨事項
- 主要な結論：[結論を記載]
- 次のステップの提案：[提案を記載]
- 追加調査が必要な領域：[必要に応じて記載]

## 参考文献
[以下のbibliography.jsonから生成]
\`\`\`

#### sources/bibliography.json (参考文献)
\`\`\`json
{
  \"sources\": [
    {
      \"id\": \"source-001\",
      \"title\": \"[記事タイトル]\",
      \"url\": \"[URL]\",
      \"author\": \"[著者名]\",
      \"publication_date\": \"[発行日]\",
      \"accessed_date\": \"$(date '+%Y-%m-%d')\",
      \"type\": \"web\",
      \"credibility\": \"high|medium|low\",
      \"summary\": \"[ソースの簡潔な要約]\"
    }
  ]
}
\`\`\`

#### raw-results/source-XXX.md (各ソースの全文)
各情報源の完全な内容を個別のファイルとして保存してください。

### 4. メタデータの更新
調査完了後、metadata.jsonを以下の内容で更新してください：
\`\`\`json
{
    \"query\": \"$query\",
    \"timestamp\": \"$(date -Iseconds)\",
    \"session_id\": \"$session_name\",
    \"status\": \"completed\",
    \"research_type\": \"web-search\",
    \"duration_seconds\": [実際の所要時間],
    \"sources_count\": [収集したソース数],
    \"ai_tool\": \"[使用したAIツール名]\",
    \"language\": \"ja\"
}
\`\`\`

$ai_instruction"
    
    # プロンプトファイルの保存
    echo "$ai_prompt" > "$session_dir/ai-prompt.txt"
    
    # 以下、既存のAI実行ロジック...
    # (元のresearch_ai_searchの実行部分をそのまま使用)
    
    # AI実行後の検証（インタラクティブモードでない場合）
    if [[ "$interactive_flag" == "false" ]]; then
        sleep 2  # AIの処理完了を待つ
        if validate_ai_research_structure "$session_dir"; then
            echo -e "${GREEN}✅ AI調査が正常に完了しました${NC}"
        else
            echo -e "${YELLOW}⚠️  AI調査結果の構造を確認してください${NC}"
        fi
    fi
}

# 既存の関数を上書き
alias research_ai_search=research_ai_search_enhanced