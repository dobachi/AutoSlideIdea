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

# ライブラリの読み込み
source "$SLIDEFLOW_DIR/lib/ai_helper.sh"
source "$SLIDEFLOW_DIR/lib/project.sh"
source "$SLIDEFLOW_DIR/lib/ai_instruction_system.sh"
source "$SLIDEFLOW_DIR/lib/interactive_ai.sh"

# ヘルプメッセージ
show_help() {
    cat << EOF
SlideFlow - Markdownベースのプレゼンテーション管理ツール

使い方:
    slideflow <command> [options] [path]

コマンド:
    new <name>          新しいプレゼンテーションを作成
    preview [path]      プレゼンテーションをプレビュー
    ai [options] [path] AI支援（デフォルト：対話的フェーズ支援）
    build [format] [path] プレゼンテーションをビルド
    info [path]         プレゼンテーション情報を表示
    list                利用可能なテンプレートを表示
    instructions        AI指示書システムの状況確認
    help                このヘルプを表示

例:
    slideflow new my-presentation
    slideflow preview presentations/my-presentation
    slideflow ai presentations/my-presentation
    slideflow ai --quick tech .
    slideflow ai --phase planning presentations/conference-2024
    slideflow build pdf presentations/my-presentation
    slideflow info .

AI支援オプション:
    ai [path]                     対話的フェーズ支援
    ai --quick <type> [path]      簡易支援（tech/business/academic）
    ai --phase <phase> [path]     特定フェーズ（planning/research/design/creation/review）
    ai --continue [path]          前回セッション継続

注: [path]を省略した場合は現在のディレクトリが使用されます

EOF
}

# 新規プレゼンテーション作成
cmd_new() {
    local name="${1:-}"
    
    if [[ -z "$name" ]]; then
        echo -e "${YELLOW}エラー: プレゼンテーション名を指定してください${NC}"
        echo "使い方: slideflow new <name>"
        exit 1
    fi
    
    # 既存のスクリプトを利用
    echo -e "${BLUE}📝 プレゼンテーションを作成中...${NC}"
    
    # テンプレートオプションを正しく処理
    local template="${TEMPLATE:-basic}"
    "$PROJECT_ROOT/scripts/manage-presentation.sh" "$name" --template "$template"
    
    echo -e "${GREEN}✅ 作成完了！${NC}"
    echo -e "次のステップ:"
    echo -e "  cd presentations/$name"
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
            echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
            exit 1
        }
        start_preview_server "$port"
    )
}

# AI支援（統合版）
cmd_ai() {
    local first_arg="${1:-}"
    local path="."
    
    echo -e "${BLUE}🤖 AI支援モード${NC}"
    echo ""
    
    # 引数解析
    case "$first_arg" in
        --quick)
            # 簡易モード
            local situation="${2:-}"
            path="${3:-.}"
            (
                cd "$path" || {
                    echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
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
                    echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
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
                    echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
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
                    echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
                    exit 1
                }
                cmd_ai_quick "$first_arg"
            )
            ;;
        "")
            # デフォルト：対話的フェーズ支援
            echo -e "${CYAN}対話的フェーズ支援を開始します${NC}"
            echo -e "${YELLOW}ヒント: 簡易支援が必要な場合は 'slideflow ai --quick <type>' を使用してください${NC}"
            echo ""
            (
                cd "$path" || {
                    echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
                    exit 1
                }
                main_interactive "start"
            )
            ;;
        *)
            # パスが指定された場合
            if [[ -d "$first_arg" ]]; then
                path="$first_arg"
                echo -e "${CYAN}対話的フェーズ支援を開始します${NC}"
                echo -e "${YELLOW}作業ディレクトリ: $path${NC}"
                echo ""
                (
                    cd "$path" || {
                        echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
                        exit 1
                    }
                    main_interactive "start"
                )
            else
                echo -e "${YELLOW}不明なオプションまたは無効なパス: $first_arg${NC}"
                echo "使用方法: slideflow ai [--quick <type>|--phase <phase>|--continue] [path]"
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
            echo -n "使用するツールを選択してください (1-${#tools[@]}, Enter=1): "
            read -r tool_choice
            
            local selected_index="${tool_choice:-1}"
            if [[ "$selected_index" =~ ^[0-9]+$ ]] && [ "$selected_index" -ge 1 ] && [ "$selected_index" -le "${#tools[@]}" ]; then
                local selected_tool="${tools[$((selected_index-1))]}"
                execute_ai_command "$selected_tool" "$prompt"
            else
                echo -e "${YELLOW}無効な選択です。クリップボードにコピーします。${NC}"
                copy_to_clipboard "$prompt"
            fi
        fi
    else
        copy_to_clipboard "$prompt"
    fi
    
    echo ""
    echo -e "${GREEN}簡易AI支援が完了しました！${NC}"
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
    
    echo -e "${BLUE}📦 プレゼンテーションをビルド中...${NC}"
    
    # 指定されたパスで実行
    (
        cd "$path" || {
            echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
            exit 1
        }
        
        # slides.mdの存在確認
        if [[ ! -f "slides.md" ]]; then
            echo -e "${YELLOW}エラー: slides.mdが見つかりません${NC}"
            echo "プレゼンテーションディレクトリを確認してください: $path"
            exit 1
        fi
    
    case "$format" in
        html)
            echo -e "${BLUE}HTMLとしてビルド中...${NC}"
            # 現在のディレクトリを保存
            local current_dir="$(pwd)"
            # npxを使ってMarpでHTMLを生成
            (cd "$PROJECT_ROOT" && npx @marp-team/marp-cli "$current_dir/slides.md" -o "$current_dir/slides.html" --html --allow-local-files)
            # 背景を白に変更
            "$PROJECT_ROOT/scripts/generate-static-html.sh" slides.html
            echo -e "${GREEN}✅ slides.htmlを生成しました${NC}"
            ;;
        pdf)
            echo -e "${BLUE}PDFとしてビルド中...${NC}"
            local current_dir="$(pwd)"
            (cd "$PROJECT_ROOT" && npx @marp-team/marp-cli "$current_dir/slides.md" -o "$current_dir/slides.pdf" --pdf --allow-local-files)
            echo -e "${GREEN}✅ slides.pdfを生成しました${NC}"
            ;;
        pptx)
            echo -e "${BLUE}PowerPointとしてビルド中...${NC}"
            local current_dir="$(pwd)"
            (cd "$PROJECT_ROOT" && npx @marp-team/marp-cli "$current_dir/slides.md" -o "$current_dir/slides.pptx" --pptx --allow-local-files)
            echo -e "${GREEN}✅ slides.pptxを生成しました${NC}"
            ;;
        *)
            echo -e "${YELLOW}エラー: 未対応のフォーマット '$format'${NC}"
            echo "対応フォーマット: html, pdf, pptx"
            exit 1
            ;;
    esac
    )
}

# プレゼンテーション情報表示
cmd_info() {
    local path="${1:-.}"
    
    echo -e "${BLUE}📊 プレゼンテーション情報${NC}"
    echo ""
    
    # 指定されたパスで実行
    (
        cd "$path" || {
            echo -e "${YELLOW}エラー: ディレクトリが見つかりません: $path${NC}"
            exit 1
        }
        
        # slides.mdの存在確認
        if [[ ! -f "slides.md" ]]; then
            echo -e "${YELLOW}エラー: slides.mdが見つかりません${NC}"
            echo "プレゼンテーションディレクトリを確認してください: $path"
            exit 1
        fi
    
    # 基本情報
    echo -e "${GREEN}ファイル情報:${NC}"
    echo "  パス: $(pwd)/slides.md"
    echo "  サイズ: $(wc -c < slides.md) バイト"
    echo "  最終更新: $(date -r slides.md '+%Y-%m-%d %H:%M:%S')"
    echo ""
    
    # スライド数
    local slide_count=$(grep -c '^---$' slides.md || echo 0)
    echo -e "${GREEN}スライド数:${NC} $((slide_count + 1))"
    echo ""
    
    # メタデータ抽出
    echo -e "${GREEN}メタデータ:${NC}"
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
    echo -e "${GREEN}生成済みファイル:${NC}"
    [[ -f "slides.html" ]] && echo "  ✓ slides.html ($(date -r slides.html '+%Y-%m-%d %H:%M:%S'))"
    [[ -f "slides.pdf" ]] && echo "  ✓ slides.pdf ($(date -r slides.pdf '+%Y-%m-%d %H:%M:%S'))"
    [[ -f "slides.pptx" ]] && echo "  ✓ slides.pptx ($(date -r slides.pptx '+%Y-%m-%d %H:%M:%S'))"
    )
}

# テンプレート一覧表示
cmd_list() {
    echo -e "${BLUE}📋 利用可能なテンプレート${NC}"
    echo ""
    
    local templates_dir="$PROJECT_ROOT/templates"
    
    if [[ ! -d "$templates_dir" ]]; then
        echo -e "${YELLOW}テンプレートディレクトリが見つかりません${NC}"
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
                echo "  機能:"
                sed -n '/^features:/,/^[^ ]/p' "$template/template.yaml" | grep '^  - ' | sed 's/^  /    /'
            fi
            
            echo ""
        fi
    done
    
    echo -e "${CYAN}使用方法:${NC}"
    echo "  slideflow new <name> --template <template-name>"
}

# メインコマンド処理
main() {
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
        instructions)
            list_available_instructions
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo -e "${YELLOW}エラー: 不明なコマンド '$command'${NC}"
            show_help
            exit 1
            ;;
    esac
}

# 実行
main "$@"