#!/bin/bash
# SlideFlow - Phase 1
# Markdownベースのシンプルなプレゼンテーション管理ツール
# AI統合とインタラクティブ機能を追加

set -e

# カラー定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# プロジェクトルートディレクトリ
PROJECT_ROOT=$(cd "$(dirname "$0")/.." && pwd)
SLIDEFLOW_DIR="$(cd "$(dirname "$0")" && pwd)"

# グローバルオプション
GLOBAL_PRESENTATIONS_DIR=""

# ライブラリの読み込み
source "$SLIDEFLOW_DIR/lib/config.sh"
source "$SLIDEFLOW_DIR/lib/i18n.sh"
source "$SLIDEFLOW_DIR/lib/ai_helper.sh"
source "$SLIDEFLOW_DIR/lib/project.sh"
source "$SLIDEFLOW_DIR/lib/ai_instruction_system.sh"
source "$SLIDEFLOW_DIR/lib/interactive_ai.sh"
source "$SLIDEFLOW_DIR/lib/research.sh"

# ヘルプメッセージ
show_help() {
    cat << EOF
$(msg "sf.title")

$(msg "sf.usage"):
    slideflow [global-options] <command> [options] [path]

$(msg "sf.global_options"):
    --presentations-dir <dir>   $(msg "opt.presentations_dir")
    --config list              $(msg "opt.config_list")
    --config <key>=<value>     $(msg "opt.config_set")

$(msg "sf.commands"):
    new [path]          $(msg "cmd.new.desc")
    preview [path]      $(msg "cmd.preview.desc")
    ai [options] [path] $(msg "cmd.ai.desc")
    build [format] [path] $(msg "cmd.build.desc")
    info [path]         $(msg "cmd.info.desc")
    list [path]         $(msg "cmd.list.desc")
    templates           $(msg "cmd.templates.desc")
    phases              $(msg "cmd.phases.desc")
    instructions        $(msg "cmd.instructions.desc")
    config              $(msg "cmd.config.desc")
    research [cmd] [path] $(msg "cmd.research.desc")
    help                $(msg "cmd.help.desc")

$(msg "sf.examples"):
    slideflow new
    slideflow new my-presentation
    slideflow new projects/conference-2024
    slideflow preview presentations/my-presentation
    slideflow ai presentations/my-presentation
    slideflow ai --quick tech .
    slideflow ai --phase planning presentations/conference-2024
    slideflow build pdf presentations/my-presentation
    slideflow info .

$(msg "sf.options"):
    ai [path]                     $(msg "ai.option.interactive")
    ai --quick <type> [path]      $(msg "ai.option.quick")
    ai --phase <phase> [path]     $(msg "ai.option.phase")
    ai --continue [path]          $(msg "ai.option.continue")

$(msg "note.path_omitted")

EOF
}

# 新規プレゼンテーション作成
cmd_new() {
    local path="${1:-}"
    local name
    local full_path
    
    if [[ -z "$path" ]]; then
        # パスが指定されていない場合は、デフォルト名を生成
        name="presentation-$(date +%Y%m%d-%H%M%S)"
        local default_dir="${GLOBAL_PRESENTATIONS_DIR:-$(get_config presentations_dir)}"
        full_path="$default_dir/$name"
        echo -e "${YELLOW}$(msg "info.using_default_name" "$name")${NC}"
    elif [[ "$path" = /* ]]; then
        # 絶対パスの場合
        full_path="$path"
        name="$(basename "$path")"
    else
        # 相対パスの場合
        if [[ "$path" == */* ]]; then
            # ディレクトリ階層を含む場合
            full_path="$(pwd)/$path"
            name="$(basename "$path")"
        else
            # 名前のみの場合（デフォルトディレクトリを使用）
            name="$path"
            local default_dir="${GLOBAL_PRESENTATIONS_DIR:-$(get_config presentations_dir)}"
            full_path="$default_dir/$name"
        fi
    fi
    
    # 既存のスクリプトを利用
    echo -e "${BLUE}📝 $(msg "info.creating")${NC}"
    
    # テンプレートオプションを正しく処理
    local template="${TEMPLATE:-basic}"
    "$PROJECT_ROOT/scripts/manage-presentation.sh" "$full_path" --template "$template"
    
    echo -e "${GREEN}✅ $(msg "success.created")${NC}"
    echo -e "$(msg "success.next_steps")"
    echo -e "  cd $full_path"
    echo -e "  slideflow preview"
}

# プレビューサーバー起動
cmd_preview() {
    local path="${1:-.}"
    local port="${2:-8000}"
    
    # パスが数字の場合は、従来の互換性のためポート番号として扱う
    if [[ "$path" =~ ^[0-9]+$ ]]; then
        port="$path"
        path="."
    fi
    
    # 指定されたパスに移動してプレビュー
    (
        cd "$path" || {
            echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
            exit 1
        }
        start_preview_server "$port"
    )
}

# AI支援（統合版）
cmd_ai() {
    local first_arg="${1:-}"
    local path="."
    
    echo -e "${BLUE}🤖 $(msg "ai.support_mode")${NC}"
    echo ""
    
    # 引数解析
    case "$first_arg" in
        --quick)
            # 簡易モード
            local situation="${2:-}"
            path="${3:-.}"
            (
                cd "$path" || {
                    echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
                    exit 1
                }
                cmd_ai_quick "$situation"
            )
            ;;
        --phase)
            # 特定フェーズ
            local phase="${2:-}"
            path="${3:-.}"
            (
                cd "$path" || {
                    echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
                    exit 1
                }
                main_interactive "phase" "$phase"
            )
            ;;
        --continue)
            # セッション継続
            path="${2:-.}"
            (
                cd "$path" || {
                    echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
                    exit 1
                }
                main_interactive "continue"
            )
            ;;
        tech|business|academic)
            # 後方互換性：直接タイプ指定
            path="${2:-.}"
            (
                cd "$path" || {
                    echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
                    exit 1
                }
                cmd_ai_quick "$first_arg"
            )
            ;;
        "")
            # デフォルト：対話的フェーズ支援
            echo -e "${CYAN}$(msg "ai.starting_interactive")${NC}"
            echo -e "${YELLOW}$(msg "ai.hint_quick")${NC}"
            echo ""
            (
                cd "$path" || {
                    echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
                    exit 1
                }
                main_interactive "start"
            )
            ;;
        *)
            # パスが指定された場合
            if [[ -d "$first_arg" ]]; then
                path="$first_arg"
                echo -e "${CYAN}$(msg "ai.starting_interactive")${NC}"
                echo -e "${YELLOW}$(msg "ai.working_dir" "$path")${NC}"
                echo ""
                (
                    cd "$path" || {
                        echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
                        exit 1
                    }
                    main_interactive "start"
                )
            else
                echo -e "${YELLOW}$(msg "ai.unknown_option" "$first_arg")${NC}"
                echo "$(msg "ai.usage_ai")"
                return 1
            fi
            ;;
    esac
}

# 簡易AI支援（従来機能）
cmd_ai_quick() {
    local situation="${1:-}"
    
    echo -e "${CYAN}簡易AI支援モード${NC}"
    echo ""
    
    # AIツールの検出
    local available_tools=$(detect_ai_tools)
    
    if [[ -z "$available_tools" ]]; then
        echo -e "${YELLOW}AIツールが検出されませんでした${NC}"
        echo "プロンプトをクリップボードにコピーします。"
        echo ""
    fi
    
    # シチュエーション選択
    if [[ -z "$situation" ]]; then
        echo -e "${BLUE}プレゼンテーションの種類を選択してください:${NC}"
        echo ""
        echo "  1) 技術プレゼンテーション"
        echo "  2) ビジネス提案"
        echo "  3) 学術研究発表"
        echo ""
        echo -n "番号を入力してください (1-3, Enter=1): "
        
        read -r choice
        
        case "${choice:-1}" in
            1|"") situation="tech-presentation" ;;
            2) situation="business-proposal" ;;
            3) situation="academic-research" ;;
            *) 
                echo -e "${YELLOW}無効な選択です。技術プレゼンテーションを選択します。${NC}"
                situation="tech-presentation"
                ;;
        esac
    else
        # 引数で指定された場合は変換
        case "$situation" in
            tech) situation="tech-presentation" ;;
            business) situation="business-proposal" ;;
            academic) situation="academic-research" ;;
        esac
    fi
    
    echo -e "${GREEN}選択: $situation${NC}"
    echo ""
    echo -e "${BLUE}コンテキストを収集中...${NC}"
    local context=$(collect_context)
    
    # AI指示書システムを使用した高品質プロンプト生成
    local prompt=$(generate_enhanced_prompt "$situation" "planning" "$context")
    
    # AIツール実行
    if [[ -n "$available_tools" ]]; then
        echo ""
        echo -e "${BLUE}利用可能なAIツール:${NC}"
        IFS=',' read -ra tools <<< "$available_tools"
        for i in "${!tools[@]}"; do
            echo "  $((i+1))) ${tools[$i]}"
        done
        echo ""
        
        if [[ ${#tools[@]} -eq 1 ]]; then
            echo -e "${GREEN}${tools[0]}を使用します...${NC}"
            execute_ai_command "${tools[0]}" "$prompt"
        else
            echo -n "$(msg "info.select_tool" "${#tools[@]}")"
            read -r tool_choice
            
            local selected_index="${tool_choice:-1}"
            if [[ "$selected_index" =~ ^[0-9]+$ ]] && [ "$selected_index" -ge 1 ] && [ "$selected_index" -le "${#tools[@]}" ]; then
                local selected_tool="${tools[$((selected_index-1))]}"
                execute_ai_command "$selected_tool" "$prompt"
            else
                echo -e "${YELLOW}$(msg "error.invalid_selection")${NC}"
                copy_to_clipboard "$prompt"
            fi
        fi
    else
        copy_to_clipboard "$prompt"
    fi
    
    echo ""
    echo -e "${GREEN}$(msg "info.quick_support_complete")${NC}"
}

# ビルドコマンド
cmd_build() {
    local format="${1:-html}"
    local path="${2:-.}"
    
    # フォーマットがパスの場合（引数が1つの場合）
    if [[ -d "$format" ]]; then
        path="$format"
        format="html"
    fi
    
    echo -e "${BLUE}📦 $(msg "info.building")${NC}"
    
    # 指定されたパスで実行
    (
        cd "$path" || {
            echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
            exit 1
        }
        
        # slides.mdの存在確認
        if [[ ! -f "slides.md" ]]; then
            echo -e "${YELLOW}$(msg "error.no_slides")${NC}"
            echo "$(msg "error.check_dir" "$path")"
            exit 1
        fi
    
    case "$format" in
        html)
            echo -e "${BLUE}$(msg "info.building_as" "HTML")${NC}"
            # 現在のディレクトリを保存
            local current_dir="$(pwd)"
            # npxを使ってMarpでHTMLを生成
            (cd "$PROJECT_ROOT" && npx @marp-team/marp-cli "$current_dir/slides.md" -o "$current_dir/slides.html" --html --allow-local-files)
            # 背景を白に変更
            "$PROJECT_ROOT/scripts/generate-static-html.sh" slides.html
            echo -e "${GREEN}✅ slides.htmlを生成しました${NC}"
            ;;
        pdf)
            echo -e "${BLUE}$(msg "info.building_as" "PDF")${NC}"
            local current_dir="$(pwd)"
            (cd "$PROJECT_ROOT" && npx @marp-team/marp-cli "$current_dir/slides.md" -o "$current_dir/slides.pdf" --pdf --allow-local-files)
            echo -e "${GREEN}✅ slides.pdfを生成しました${NC}"
            ;;
        pptx)
            echo -e "${BLUE}$(msg "info.building_as" "PowerPoint")${NC}"
            local current_dir="$(pwd)"
            (cd "$PROJECT_ROOT" && npx @marp-team/marp-cli "$current_dir/slides.md" -o "$current_dir/slides.pptx" --pptx --allow-local-files)
            echo -e "${GREEN}✅ slides.pptxを生成しました${NC}"
            ;;
        *)
            echo -e "${YELLOW}$(msg "error.unsupported_format" "$format")${NC}"
            echo "$(msg "error.supported_formats")"
            exit 1
            ;;
    esac
    )
}

# プレゼンテーション情報表示
cmd_info() {
    local path="${1:-.}"
    
    # ファイルかディレクトリかを判定
    if [[ -f "$path" ]]; then
        # ファイルが指定された場合
        if [[ "$(basename "$path")" == "slides.md" ]]; then
            path="$(cd "$(dirname "$path")" && pwd)"
        else
            echo -e "${YELLOW}$(msg "error.not_presentation_file")${NC}"
            return 1
        fi
    elif [[ -d "$path" ]]; then
        # ディレクトリが指定された場合
        # パスを絶対パスに変換
        if [[ ! "$path" = /* ]]; then
            path="$(cd "$path" 2>/dev/null && pwd)" || path="$(pwd)/$path"
        fi
        
        # slides.mdを探す
        if [[ -f "$path/slides.md" ]]; then
            # 直下にslides.mdがある場合
            path="$path"
        else
            # サブディレクトリからslides.mdを探す
            local found_slide=""
            while IFS= read -r -d '' slide; do
                if [[ -z "$found_slide" ]]; then
                    found_slide="$(dirname "$slide")"
                else
                    # 複数見つかった場合
                    echo -e "${YELLOW}$(msg "info.multiple_presentations")${NC}"
                    echo "$(msg "info.please_specify"):"
                    find "$path" -name "slides.md" -type f | while read -r s; do
                        echo "  $(dirname "$s")"
                    done
                    return 1
                fi
            done < <(find "$path" -name "slides.md" -type f -print0)
            
            if [[ -n "$found_slide" ]]; then
                path="$found_slide"
            else
                echo -e "${YELLOW}$(msg "error.no_slides")${NC}"
                echo "$(msg "error.check_dir" "$path")"
                return 1
            fi
        fi
    else
        echo -e "${YELLOW}$(msg "error.path_not_found" "$path")${NC}"
        return 1
    fi
    
    echo -e "${BLUE}📊 $(msg "info.presentation_info")${NC}"
    echo -e "${CYAN}$(msg "info.path"): $path${NC}"
    echo ""
    
    # 指定されたパスで実行
    (
        cd "$path" || {
            echo -e "${YELLOW}$(msg "error.dir_not_found" "$path")${NC}"
            exit 1
        }
        
        # slides.mdの存在確認（念のため）
        if [[ ! -f "slides.md" ]]; then
            echo -e "${YELLOW}$(msg "error.no_slides")${NC}"
            exit 1
        fi
    
    # 基本情報
    echo -e "${GREEN}$(msg "info.file_info")${NC}"
    echo "  $(msg "info.path"): $(pwd)/slides.md"
    echo "  $(msg "info.size"): $(wc -c < slides.md) $(msg "misc.bytes")"
    echo "  $(msg "info.last_update"): $(date -r slides.md '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # スライド数
    local slide_count=$(grep -c '^---$' slides.md || echo 0)
    echo -e "${GREEN}$(msg "info.slides_count"):${NC} $((slide_count + 1))"
    echo ""
    
    # メタデータ抽出
    echo -e "${GREEN}$(msg "info.metadata")${NC}"
    local in_frontmatter=false
    while IFS= read -r line; do
        if [[ "$line" == "---" ]]; then
            if [[ "$in_frontmatter" == false ]]; then
                in_frontmatter=true
                continue
            else
                break
            fi
        fi
        if [[ "$in_frontmatter" == true ]] && [[ -n "$line" ]]; then
            echo "  $line"
        fi
    done < slides.md
    
    echo ""
    
    # 生成物の確認
    echo -e "${GREEN}$(msg "info.generated_files")${NC}"
    [[ -f "slides.html" ]] && echo "  ✓ slides.html ($(date -r slides.html '+%Y-%m-%d %H:%M:%S'))"
    [[ -f "slides.pdf" ]] && echo "  ✓ slides.pdf ($(date -r slides.pdf '+%Y-%m-%d %H:%M:%S'))"
    [[ -f "slides.pptx" ]] && echo "  ✓ slides.pptx ($(date -r slides.pptx '+%Y-%m-%d %H:%M:%S'))"
    )
}

# 既存プレゼンテーション一覧表示
cmd_list() {
    # デフォルトディレクトリを取得
    local default_dir="${GLOBAL_PRESENTATIONS_DIR:-$(get_config presentations_dir)}"
    local search_dir="${1:-$default_dir}"
    
    # パスを絶対パスに変換
    if [[ ! "$search_dir" = /* ]]; then
        search_dir="$(cd "$search_dir" 2>/dev/null && pwd)" || search_dir="$(pwd)/$search_dir"
    fi
    
    echo -e "${BLUE}📋 $(msg "info.existing_presentations")${NC}"
    echo -e "${CYAN}$(msg "info.path"): $search_dir${NC}"
    echo ""
    
    local found=false
    
    if [[ ! -d "$search_dir" ]]; then
        echo -e "${YELLOW}$(msg "error.dir_not_found" "$search_dir")${NC}"
        return 1
    fi
    
    # プレゼンテーション一覧を表示 (再帰的に検索)
    local presentation
    while IFS= read -r -d '' presentation; do
        found=true
        # 相対パスで表示
        local rel_path="${presentation#$search_dir/}"
        local name=$(basename "$presentation")
        
        # ディレクトリがネストされている場合はパスも表示
        if [[ "$rel_path" != "$name" ]]; then
            echo -e "${GREEN}$rel_path${NC}"
        else
            echo -e "${GREEN}$name${NC}"
        fi
            
            # slides.mdからメタデータを取得
            local title=""
            local description=""
            local in_frontmatter=false
            while IFS= read -r line; do
                if [[ "$line" == "---" ]]; then
                    if [[ "$in_frontmatter" == false ]]; then
                        in_frontmatter=true
                        continue
                    else
                        break
                    fi
                fi
                if [[ "$in_frontmatter" == true ]]; then
                    if [[ "$line" =~ ^title:\ *(.*)$ ]]; then
                        title="${BASH_REMATCH[1]}"
                        title="${title//\"/}"
                    elif [[ "$line" =~ ^description:\ *(.*)$ ]]; then
                        description="${BASH_REMATCH[1]}"
                        description="${description//\"/}"
                    fi
                fi
            done < "$presentation/slides.md"
            
            [[ -n "$title" ]] && echo "  $(msg "info.title"): $title"
            [[ -n "$description" ]] && echo "  $(msg "info.description"): $description"
            
            # 最終更新日時
            local last_update=$(date -r "$presentation/slides.md" '+%Y-%m-%d %H:%M')
            echo "  $(msg "info.last_update"): $last_update"
            echo ""
    done < <(find "$search_dir" -name "slides.md" -type f -print0 | xargs -0 dirname | sort -u | tr '\n' '\0')
    
    if [[ "$found" == false ]]; then
        echo -e "${YELLOW}$(msg "info.no_presentations")${NC}"
        echo ""
        echo -e "$(msg "info.create_first")"
        echo "  slideflow new my-first-presentation"
    else
        echo -e "${CYAN}$(msg "info.open_presentation")${NC}"
        echo "  cd <presentation-path>"
        echo "  slideflow preview"
    fi
}

# 設定管理
cmd_config() {
    local action="${1:-list}"
    
    case "$action" in
        list|show)
            show_config
            ;;
        get)
            local key="${2:-}"
            if [[ -z "$key" ]]; then
                echo -e "${YELLOW}$(msg "error.key_required")${NC}"
                exit 1
            fi
            echo "$(get_config "$key")"
            ;;
        set)
            local key_value="${2:-}"
            if [[ ! "$key_value" =~ ^([^=]+)=(.+)$ ]]; then
                echo -e "${YELLOW}$(msg "error.invalid_config_syntax")${NC}"
                exit 1
            fi
            set_config "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
            echo -e "${GREEN}$(msg "info.config_updated" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}")${NC}"
            ;;
        *)
            echo -e "${YELLOW}$(msg "error.unknown_config_action" "$action")${NC}"
            echo "$(msg "info.config_usage")"
            exit 1
            ;;
    esac
}

# 調査コマンド
cmd_research() {
    local subcommand="${1:-}"
    shift || true
    
    case "$subcommand" in
        init)
            research_init "$@"
            ;;
        add-note|note)
            if [ -z "$1" ]; then
                echo -e "${YELLOW}メモの内容を指定してください${NC}"
                echo "使用法: slideflow research add-note \"内容\" [path]"
                exit 1
            fi
            research_add_note "$@"
            ;;
        add-source|source)
            if [ -z "$1" ]; then
                echo -e "${YELLOW}ソースのURLまたはパスを指定してください${NC}"
                echo "使用法: slideflow research add-source \"URL\" [path] [type]"
                exit 1
            fi
            research_add_source "$@"
            ;;
        list|ls)
            research_list "$@"
            ;;
        summary)
            local path="${1:-.}"
            if [ -f "$path/research/summary.md" ]; then
                cat "$path/research/summary.md"
            else
                echo -e "${YELLOW}調査サマリーがまだありません${NC}"
                echo "ヒント: slideflow research init でディレクトリを初期化してください"
            fi
            ;;
        interactive|-i|--interactive)
            research_interactive "$@"
            ;;
        ""|help|--help|-h)
            echo -e "${BLUE}📚 SlideFlow Research - 調査フェーズサポート${NC}"
            echo ""
            echo "使用法:"
            echo "  slideflow research <subcommand> [options] [path]"
            echo ""
            echo "サブコマンド:"
            echo "  init [path]              調査ディレクトリを初期化"
            echo "  add-note \"内容\" [path]   メモを追加"
            echo "  add-source URL [path]    ソース情報を追加"
            echo "  list [path]              調査内容を一覧表示"
            echo "  summary [path]           調査サマリーを表示"
            echo "  interactive [path]       インタラクティブモード"
            echo ""
            echo "例:"
            echo "  slideflow research init"
            echo "  slideflow research add-note \"重要な発見：AIの活用方法\""
            echo "  slideflow research add-source \"https://example.com/article\""
            echo "  slideflow research interactive"
            ;;
        *)
            echo -e "${YELLOW}不明なサブコマンド: $subcommand${NC}"
            echo "ヘルプを表示: slideflow research help"
            exit 1
            ;;
    esac
}

# フェーズ一覧表示
cmd_phases() {
    echo -e "${BLUE}📦 $(msg "info.available_phases")${NC}"
    echo ""
    
    # フェーズの定義
    echo -e "${GREEN}planning${NC}"
    echo "  $(msg "phase.planning.desc")"
    echo "  $(msg "phase.planning.activities")"
    echo ""
    
    echo -e "${GREEN}research${NC}"
    echo "  $(msg "phase.research.desc")"
    echo "  $(msg "phase.research.activities")"
    echo ""
    
    echo -e "${GREEN}design${NC}"
    echo "  $(msg "phase.design.desc")"
    echo "  $(msg "phase.design.activities")"
    echo ""
    
    echo -e "${GREEN}creation${NC}"
    echo "  $(msg "phase.creation.desc")"
    echo "  $(msg "phase.creation.activities")"
    echo ""
    
    echo -e "${GREEN}review${NC}"
    echo "  $(msg "phase.review.desc")"
    echo "  $(msg "phase.review.activities")"
    echo ""
    
    echo -e "${CYAN}$(msg "info.phase_usage")${NC}"
    echo "  slideflow ai --phase <phase> [path]"
    echo ""
    echo -e "${CYAN}$(msg "info.phase_example")${NC}"
    echo "  slideflow ai --phase planning"
    echo "  slideflow ai --phase research ./presentations/my-presentation"
}

# テンプレート一覧表示
cmd_templates() {
    echo -e "${BLUE}📋 $(msg "info.available_templates")${NC}"
    echo ""
    
    local templates_dir="$PROJECT_ROOT/templates"
    
    if [[ ! -d "$templates_dir" ]]; then
        echo -e "${YELLOW}$(msg "error.template_dir_not_found")${NC}"
        exit 1
    fi
    
    # テンプレート一覧を表示
    for template in "$templates_dir"/*; do
        if [[ -d "$template" ]] && [[ -f "$template/template.yaml" ]]; then
            local template_name=$(basename "$template")
            local display_name=$(grep '^display_name:' "$template/template.yaml" | sed 's/^display_name: *//' | tr -d '"')
            local description=$(grep '^description:' "$template/template.yaml" | sed 's/^description: *//' | tr -d '"')
            
            echo -e "${GREEN}$template_name${NC}"
            [[ -n "$display_name" ]] && echo -e "  ${CYAN}[$display_name]${NC}"
            [[ -n "$description" ]] && echo "  $description"
            
            # 機能一覧
            if grep -q '^features:' "$template/template.yaml"; then
                echo "  $(msg "info.features")"
                sed -n '/^features:/,/^[^ ]/p' "$template/template.yaml" | grep '^  - ' | sed 's/^  /    /'
            fi
            
            echo ""
        fi
    done
    
    echo -e "${CYAN}$(msg "info.usage_template")${NC}"
    echo "  slideflow new <name> --template <template-name>"
}

# メインコマンド処理
main() {
    # グローバルオプションの処理
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --presentations-dir)
                GLOBAL_PRESENTATIONS_DIR="$2"
                shift 2
                ;;
            --config)
                if [[ "$2" == "list" ]]; then
                    show_config
                    exit 0
                elif [[ "$2" =~ ^([^=]+)=(.+)$ ]]; then
                    set_config "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
                    echo -e "${GREEN}$(msg "info.config_updated" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}")${NC}"
                    exit 0
                else
                    echo -e "${YELLOW}$(msg "error.invalid_config_syntax")${NC}"
                    exit 1
                fi
                ;;
            -*)
                echo -e "${YELLOW}$(msg "error.unknown_option" "$1")${NC}"
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done
    
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        new)
            cmd_new "$@"
            ;;
        preview)
            cmd_preview "$@"
            ;;
        ai)
            cmd_ai "$@"
            ;;
        build)
            cmd_build "$@"
            ;;
        info)
            cmd_info "$@"
            ;;
        list)
            cmd_list "$@"
            ;;
        templates)
            cmd_templates "$@"
            ;;
        phases)
            cmd_phases "$@"
            ;;
        instructions)
            list_available_instructions
            ;;
        config)
            cmd_config "$@"
            ;;
        research)
            cmd_research "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${YELLOW}$(msg "error.unknown_command" "$command")${NC}"
            show_help
            exit 1
            ;;
    esac
}

# 実行
main "$@"