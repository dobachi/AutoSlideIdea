#!/bin/bash
# AI指示書システム統合ライブラリ
# instructions/ai_instruction_kits/ の指示書を活用

set -e

# AI指示書のパス
AI_INSTRUCTIONS_DIR="$(dirname "${BASH_SOURCE[0]}")/../../instructions/ai_instruction_kits/instructions/ja"

# 利用可能な指示書タイプ
declare -A INSTRUCTION_TYPES=(
    ["presentation"]="writing/presentation_creation.md"
    ["technical_writer"]="agent/technical_writer.md"
    ["data_analysis"]="analysis/basic_data_analysis.md"
    ["creative"]="creative/basic_creative_work.md"
    ["text_creation"]="writing/basic_text_creation.md"
)

# フェーズと指示書の対応
declare -A PHASE_INSTRUCTIONS=(
    ["planning"]="presentation,creative"
    ["research"]="data_analysis,text_creation"
    ["design"]="presentation,creative"
    ["creation"]="technical_writer,text_creation"
    ["review"]="technical_writer,presentation"
)

# 指示書の存在確認
check_instruction_exists() {
    local instruction_type="$1"
    local instruction_path="${INSTRUCTION_TYPES[$instruction_type]}"
    
    if [[ -z "$instruction_path" ]]; then
        return 1
    fi
    
    local full_path="$AI_INSTRUCTIONS_DIR/$instruction_path"
    [[ -f "$full_path" ]]
}

# 指示書の読み込み
load_instruction() {
    local instruction_type="$1"
    local instruction_path="${INSTRUCTION_TYPES[$instruction_type]}"
    
    if [[ -z "$instruction_path" ]]; then
        echo "エラー: 不明な指示書タイプ: $instruction_type" >&2
        return 1
    fi
    
    local full_path="$AI_INSTRUCTIONS_DIR/$instruction_path"
    
    if [[ ! -f "$full_path" ]]; then
        echo "エラー: 指示書が見つかりません: $full_path" >&2
        return 1
    fi
    
    cat "$full_path"
}

# フェーズに適した指示書の組み合わせ生成
generate_phase_instructions() {
    local phase="$1"
    local situation_type="$2"  # tech/business/academic
    
    local instruction_list="${PHASE_INSTRUCTIONS[$phase]}"
    if [[ -z "$instruction_list" ]]; then
        echo "エラー: 不明なフェーズ: $phase" >&2
        return 1
    fi
    
    local combined_instructions=""
    
    # フェーズの説明
    combined_instructions+="# $phase フェーズの AI支援\n\n"
    combined_instructions+="このフェーズでは以下の専門的な指示書を組み合わせて支援します。\n\n"
    
    # 各指示書を結合
    IFS=',' read -ra instructions <<< "$instruction_list"
    for instruction_type in "${instructions[@]}"; do
        if check_instruction_exists "$instruction_type"; then
            combined_instructions+="## $instruction_type 指示書\n\n"
            combined_instructions+="$(load_instruction "$instruction_type")\n\n"
            combined_instructions+="---\n\n"
        fi
    done
    
    # 状況特化の追加指示
    case "$situation_type" in
        tech)
            combined_instructions+="## 技術プレゼンテーション特化指示\n"
            combined_instructions+="- 技術的正確性を最優先する\n"
            combined_instructions+="- コード例や図解を積極的に活用する\n"
            combined_instructions+="- 開発者向けの用語を適切に使用する\n\n"
            ;;
        business)
            combined_instructions+="## ビジネス提案特化指示\n"
            combined_instructions+="- ROI や KPI などビジネス指標を重視する\n"
            combined_instructions+="- ステークホルダーの関心事を考慮する\n"
            combined_instructions+="- 意思決定に必要な情報を明確に提示する\n\n"
            ;;
        academic)
            combined_instructions+="## 学術研究特化指示\n"
            combined_instructions+="- 研究の妥当性と再現性を重視する\n"
            combined_instructions+="- 文献引用と参考資料を適切に管理する\n"
            combined_instructions+="- 学術的な厳密性を保つ\n\n"
            ;;
    esac
    
    echo -e "$combined_instructions"
}

# 高品質プロンプト生成
generate_enhanced_prompt() {
    local situation_type="$1"
    local phase="${2:-planning}"
    local context="$3"
    
    local prompt=""
    
    # 基本情報
    prompt+="# SlideFlow AI支援 - 高品質指示書統合版\n\n"
    prompt+="プレゼンテーション作成のプロフェッショナルとして、以下の指示書に従って支援してください。\n\n"
    
    # 指示書の統合
    prompt+="$(generate_phase_instructions "$phase" "$situation_type")\n\n"
    
    # コンテキスト情報
    prompt+="## 現在のコンテキスト\n"
    prompt+="$context\n\n"
    
    # 対話的支援の指示
    prompt+="## 対話的支援の方針\n"
    prompt+="上記の専門的な指示書に基づいて、ユーザーと対話しながら段階的に支援してください。\n"
    prompt+="一度にすべてを提供するのではなく、ユーザーの状況と回答に応じて適切な深度で進めてください。\n"
    prompt+="質問を通じてユーザーのニーズを明確にし、最適な提案を行ってください。\n\n"
    
    # 成果物の指示
    prompt+="## 期待する成果物\n"
    case "$phase" in
        planning)
            prompt+="- プレゼンテーション企画書\n"
            prompt+="- ターゲット聴衆分析\n"
            prompt+="- 基本構成案\n"
            ;;
        research)
            prompt+="- 調査計画書\n"
            prompt+="- 情報源リスト\n"
            prompt+="- データ分析結果\n"
            ;;
        design)
            prompt+="- 詳細構成案\n"
            prompt+="- ストーリーライン\n"
            prompt+="- 視覚化戦略\n"
            ;;
        creation)
            prompt+="- スライド原稿\n"
            prompt+="- 発表者ノート\n"
            prompt+="- 補助資料\n"
            ;;
        review)
            prompt+="- 改善提案\n"
            prompt+="- チェックリスト\n"
            prompt+="- 練習計画\n"
            ;;
    esac
    
    echo -e "$prompt"
}

# 利用可能な指示書一覧表示
list_available_instructions() {
    echo -e "${BLUE}利用可能なAI指示書:${NC}"
    echo ""
    
    for instruction_type in "${!INSTRUCTION_TYPES[@]}"; do
        local instruction_path="${INSTRUCTION_TYPES[$instruction_type]}"
        local full_path="$AI_INSTRUCTIONS_DIR/$instruction_path"
        
        if [[ -f "$full_path" ]]; then
            echo -e "${GREEN}✓ $instruction_type${NC} - $instruction_path"
        else
            echo -e "${YELLOW}✗ $instruction_type${NC} - $instruction_path (見つかりません)"
        fi
    done
    
    echo ""
    echo -e "${CYAN}フェーズ別指示書組み合わせ:${NC}"
    for phase in "${!PHASE_INSTRUCTIONS[@]}"; do
        echo -e "${PURPLE}$phase${NC}: ${PHASE_INSTRUCTIONS[$phase]}"
    done
}