#!/bin/bash
# AI支援機能ライブラリ
# Phase 1: AI連携の基本実装

set -e

# カラー定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# AI CLIツールの検出
detect_ai_tools() {
    local tools=()
    
    # Claude Code検出
    if command -v claude >/dev/null 2>&1; then
        tools+=("claude")
        echo -e "${GREEN}✓ Claude Code が見つかりました${NC}" >&2
    fi
    
    # Gemini CLI検出
    if command -v gemini >/dev/null 2>&1; then
        tools+=("gemini")
        echo -e "${GREEN}✓ Gemini CLI が見つかりました${NC}" >&2
    fi
    
    # Cursor検出
    if command -v cursor >/dev/null 2>&1; then
        tools+=("cursor")
        echo -e "${GREEN}✓ Cursor が見つかりました${NC}" >&2
    fi
    
    if [ ${#tools[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠ AIツールが見つかりません${NC}" >&2
        echo -e "${YELLOW}  Claude Code、Gemini CLI、またはCursorをインストールしてください${NC}" >&2
    fi
    
    # カンマ区切りで返す
    echo "${tools[*]}" | tr ' ' ','
}

# プロジェクトコンテキストの収集
collect_context() {
    local context=""
    
    # 現在のディレクトリ
    context+="現在のディレクトリ: $(pwd)\n"
    
    # slides.mdの存在確認
    if [[ -f "slides.md" ]]; then
        context+="slides.md: 存在する\n"
        # 最初の数行を取得
        context+="最初の5行:\n$(head -5 slides.md)\n"
    else
        context+="slides.md: 存在しない\n"
    fi
    
    # その他の関連ファイル
    if [[ -f "README.md" ]]; then
        context+="README.md: 存在する\n"
    fi
    
    if [[ -f "config.yaml" ]]; then
        context+="config.yaml: 存在する\n"
    fi
    
    echo -e "$context"
}

# シチュエーション選択メニュー
select_situation() {
    set +e  # readコマンドでのエラー終了を防ぐ
    local situations_dir="$(dirname "${BASH_SOURCE[0]}")/../instructions/situations"
    local situations=()
    local selection
    
    # 利用可能な指示書を探索
    if [[ -d "$situations_dir" ]]; then
        while IFS= read -r -d '' file; do
            situations+=("$(basename "$file" .md)")
        done < <(find "$situations_dir" -name "*.md" -type f -print0 | sort -z)
    fi
    
    if [ ${#situations[@]} -eq 0 ]; then
        echo -e "${YELLOW}シチュエーション別指示書が見つかりません${NC}" >&2
        return 1
    fi
    
    echo -e "${BLUE}プレゼンテーションの種類を選択してください:${NC}"
    echo ""
    
    # メニュー表示
    for i in "${!situations[@]}"; do
        case "${situations[$i]}" in
            tech-presentation)
                echo "  $((i+1))) 技術プレゼンテーション"
                ;;
            business-proposal)
                echo "  $((i+1))) ビジネス提案"
                ;;
            academic-research)
                echo "  $((i+1))) 学術研究発表"
                ;;
            *)
                echo "  $((i+1))) ${situations[$i]}"
                ;;
        esac
    done
    echo ""
    
    # 選択 - Claude Code環境対応
    local attempts=0
    while true; do
        echo -n "番号を入力してください (1-${#situations[@]}): "
        
        # 出力をフラッシュしてからreadを実行
        exec 1>&1  # 標準出力をフラッシュ
        
        # 標準入力から読み取りを試みる
        if [[ -t 0 ]]; then
            # タイムアウト付きreadを試行
            if read -t 10 -r selection 2>/dev/null; then
                : # 成功
            else
                selection=""
            fi
        else
            # 非インタラクティブな場合はデフォルト選択
            echo -e "\n${YELLOW}非インタラクティブモードです。デフォルトで技術プレゼンテーションを選択します。${NC}"
            echo "tech-presentation"
            return 0
        fi
        
        # 3回失敗したらデフォルトを使用
        if [[ -z "$selection" ]]; then
            attempts=$((attempts + 1))
            if [[ $attempts -ge 3 ]]; then
                echo -e "\n${YELLOW}入力が検出されません。デフォルトで技術プレゼンテーションを選択します。${NC}"
                echo "tech-presentation"
                return 0
            fi
            echo -e "${YELLOW}何も入力されませんでした。もう一度お試しください。(試行 $attempts/3)${NC}"
            continue
        fi
        
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#situations[@]}" ]; then
            echo "${situations[$((selection-1))]}"
            return 0
        else
            echo -e "${YELLOW}無効な入力です。もう一度お試しください。${NC}"
        fi
    done
    
    set -e  # 元に戻す
}

# プロンプトの生成
generate_prompt() {
    local situation="$1"
    local context="$2"
    local instruction_file="$(dirname "${BASH_SOURCE[0]}")/../instructions/situations/${situation}.md"
    local prompt=""
    
    # 基本的なプロンプト構造
    prompt+="# プレゼンテーション作成支援\n\n"
    
    # 指示書の内容を読み込む
    if [[ -f "$instruction_file" ]]; then
        prompt+="## 指示内容\n"
        prompt+="$(cat "$instruction_file")\n\n"
    fi
    
    # コンテキストを追加
    prompt+="## 現在のコンテキスト\n"
    prompt+="$context\n\n"
    
    # 追加の指示
    prompt+="## お願い\n"
    prompt+="上記の指示に従って、プレゼンテーションの作成を支援してください。\n"
    prompt+="Marp形式（---で区切られたスライド）を使用してください。\n"
    
    echo -e "$prompt"
}

# AIツールの実行
execute_ai_command() {
    local tool="$1"
    local prompt="$2"
    local prompt_file="/tmp/slideflow_prompt_$$.txt"
    
    # プロンプトを一時ファイルに保存
    echo -e "$prompt" > "$prompt_file"
    
    case "$tool" in
        claude)
            echo -e "${CYAN}Claude Codeを起動しています...${NC}"
            claude "$prompt" 2>/dev/null || {
                echo -e "${YELLOW}Claude Codeの起動に失敗しました${NC}"
                return 1
            }
            ;;
        gemini)
            echo -e "${CYAN}Gemini CLIを起動しています...${NC}"
            gemini "$prompt" 2>/dev/null || {
                echo -e "${YELLOW}Gemini CLIの起動に失敗しました${NC}"
                return 1
            }
            ;;
        cursor)
            echo -e "${CYAN}Cursorを起動しています...${NC}"
            cursor . 2>/dev/null || {
                echo -e "${YELLOW}Cursorの起動に失敗しました${NC}"
                return 1
            }
            echo -e "${BLUE}プロンプトファイル: $prompt_file${NC}"
            ;;
        *)
            return 1
            ;;
    esac
    
    # 一時ファイルは削除しない（ユーザーが参照できるように）
    echo -e "${GREEN}プロンプトは以下に保存されています: $prompt_file${NC}"
    
    return 0
}

# クリップボードへのコピー（フォールバック）
copy_to_clipboard() {
    local content="$1"
    
    # macOS
    if command -v pbcopy >/dev/null 2>&1; then
        echo -e "$content" | pbcopy
        echo -e "${GREEN}✓ クリップボードにコピーしました（macOS）${NC}"
        return 0
    fi
    
    # Linux (X11)
    if command -v xclip >/dev/null 2>&1; then
        echo -e "$content" | xclip -selection clipboard
        echo -e "${GREEN}✓ クリップボードにコピーしました（Linux/X11）${NC}"
        return 0
    fi
    
    # Linux (Wayland)
    if command -v wl-copy >/dev/null 2>&1; then
        echo -e "$content" | wl-copy
        echo -e "${GREEN}✓ クリップボードにコピーしました（Linux/Wayland）${NC}"
        return 0
    fi
    
    # Windows (WSL)
    if command -v clip.exe >/dev/null 2>&1; then
        echo -e "$content" | clip.exe
        echo -e "${GREEN}✓ クリップボードにコピーしました（Windows/WSL）${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}クリップボードへのコピーに失敗しました${NC}"
    return 1
}