#!/bin/bash
# research.sh - 調査フェーズサポート機能

# カラー定義（親スクリプトから継承されない場合のため）
GREEN=${GREEN:-'\033[0;32m'}
BLUE=${BLUE:-'\033[0;34m'}
YELLOW=${YELLOW:-'\033[1;33m'}
RED=${RED:-'\033[0;31m'}
NC=${NC:-'\033[0m'}

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
                echo "利用可能: note, source, list, summary, exit"
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