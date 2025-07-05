#!/bin/bash
# 対話的AI支援システム
# Phase 1.5: フェーズ対応の継続的支援

set -e

# カラー定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

# セッション管理
SESSION_DIR=".slideflow_session"
CURRENT_PHASE_FILE="$SESSION_DIR/current_phase"
SESSION_LOG="$SESSION_DIR/session.log"
CONTEXT_FILE="$SESSION_DIR/context.md"

# セッション初期化
init_session() {
    mkdir -p "$SESSION_DIR"
    echo "$(date): セッション開始" >> "$SESSION_LOG"
    
    if [[ ! -f "$CURRENT_PHASE_FILE" ]]; then
        echo "planning" > "$CURRENT_PHASE_FILE"
    fi
}

# 現在のフェーズを取得
get_current_phase() {
    if [[ -f "$CURRENT_PHASE_FILE" ]]; then
        cat "$CURRENT_PHASE_FILE"
    else
        echo "planning"
    fi
}

# フェーズを設定
set_current_phase() {
    local phase="$1"
    echo "$phase" > "$CURRENT_PHASE_FILE"
    echo "$(date): フェーズ変更 -> $phase" >> "$SESSION_LOG"
}

# 利用可能フェーズ
list_phases() {
    echo -e "${BLUE}利用可能なフェーズ:${NC}"
    echo "  1) planning  - 企画・構想"
    echo "  2) research  - 調査・分析" 
    echo "  3) design    - 構成設計"
    echo "  4) creation  - コンテンツ作成"
    echo "  5) review    - レビュー・改善"
}

# フェーズ選択
select_phase() {
    local current_phase=$(get_current_phase)
    
    echo -e "${PURPLE}=== フェーズ選択 ===${NC}"
    echo -e "${CYAN}現在のフェーズ: $current_phase${NC}"
    echo ""
    
    list_phases
    echo ""
    echo -n "移行したいフェーズを選択してください (1-5, Enter=継続): "
    
    read -r phase_choice
    
    case "${phase_choice:-continue}" in
        1) set_current_phase "planning" ;;
        2) set_current_phase "research" ;;
        3) set_current_phase "design" ;;
        4) set_current_phase "creation" ;;
        5) set_current_phase "review" ;;
        "") 
            echo -e "${GREEN}現在のフェーズ($current_phase)を継続します${NC}"
            ;;
        *)
            echo -e "${YELLOW}無効な選択です。現在のフェーズを継続します。${NC}"
            ;;
    esac
}

# コンテキスト収集
collect_session_context() {
    local context=""
    
    # 基本的なプロジェクト情報
    context+="プロジェクト: $(basename "$(pwd)")\n"
    context+="現在のフェーズ: $(get_current_phase)\n"
    context+="セッション開始: $(head -1 "$SESSION_LOG" 2>/dev/null || echo "不明")\n"
    
    # 既存のコンテキスト
    if [[ -f "$CONTEXT_FILE" ]]; then
        context+="前回までの進捗:\n"
        context+="$(cat "$CONTEXT_FILE")\n"
    fi
    
    # ファイル状況
    context+="現在のファイル:\n"
    [[ -f "slides.md" ]] && context+="- slides.md: 存在\n"
    [[ -f "planning.md" ]] && context+="- planning.md: 存在\n"
    [[ -f "research_plan.md" ]] && context+="- research_plan.md: 存在\n"
    
    echo -e "$context"
}

# 対話的セッション開始
start_interactive_session() {
    echo -e "${PURPLE}=== SlideFlow 対話的AI支援 ===${NC}"
    echo ""
    
    init_session
    select_phase
    
    local current_phase=$(get_current_phase)
    echo ""
    echo -e "${BLUE}$current_phase フェーズの支援を開始します${NC}"
    
    # フェーズ固有の支援を実行
    execute_phase_assistance "$current_phase"
}

# フェーズ固有の支援実行
execute_phase_assistance() {
    local phase="$1"
    local phase_file="$(dirname "${BASH_SOURCE[0]}")/../instructions/phases/${phase}.md"
    
    if [[ ! -f "$phase_file" ]]; then
        echo -e "${YELLOW}警告: $phase フェーズの指示書が見つかりません${NC}"
        return 1
    fi
    
    # コンテキスト収集
    local context=$(collect_session_context)
    
    # AI指示書システムを使用した高品質プロンプト生成
    source "$(dirname "${BASH_SOURCE[0]}")/ai_instruction_system.sh"
    
    # 現在のシチュエーションタイプを推定（セッションから取得、デフォルトはtech）
    local situation_type="tech"  # TODO: セッション管理で記録されたタイプを使用
    
    # 高品質プロンプト生成
    local prompt=$(generate_enhanced_prompt "$situation_type" "$phase" "$context")
    
    # AI実行
    echo ""
    echo -e "${GREEN}AIとの対話セッションを開始します...${NC}"
    
    # 利用可能なAIツールを検出して実行
    source "$(dirname "${BASH_SOURCE[0]}")/ai_helper.sh"
    local available_tools=$(detect_ai_tools)
    
    if [[ -n "$available_tools" ]]; then
        IFS=',' read -ra tools <<< "$available_tools"
        execute_ai_command "${tools[0]}" "$prompt"
    else
        copy_to_clipboard "$prompt"
    fi
    
    # セッション後処理
    echo ""
    echo -e "${BLUE}セッションが終了しました${NC}"
    echo -e "${CYAN}進捗や成果物があれば、適切なファイルに保存してください${NC}"
}

# セッション継続
continue_session() {
    if [[ ! -d "$SESSION_DIR" ]]; then
        echo -e "${YELLOW}アクティブなセッションが見つかりません${NC}"
        echo "新しいセッションを開始しますか？ (y/N): "
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            start_interactive_session
        fi
        return
    fi
    
    local current_phase=$(get_current_phase)
    echo -e "${GREEN}セッションを継続します (現在: $current_phase フェーズ)${NC}"
    
    execute_phase_assistance "$current_phase"
}

# メイン関数
main_interactive() {
    local action="${1:-start}"
    
    case "$action" in
        start|interactive)
            start_interactive_session
            ;;
        continue)
            continue_session
            ;;
        phase)
            local phase_name="${2:-}"
            if [[ -n "$phase_name" ]]; then
                set_current_phase "$phase_name"
                execute_phase_assistance "$phase_name"
            else
                select_phase
                execute_phase_assistance "$(get_current_phase)"
            fi
            ;;
        status)
            echo -e "${BLUE}セッション状況:${NC}"
            echo "現在のフェーズ: $(get_current_phase)"
            if [[ -f "$SESSION_LOG" ]]; then
                echo "最近の活動:"
                tail -3 "$SESSION_LOG"
            fi
            ;;
        *)
            echo "使用方法: interactive {start|continue|phase|status}"
            ;;
    esac
}