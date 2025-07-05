#!/bin/bash
# プロジェクト管理機能ライブラリ
# Phase 1: プレゼンテーション管理の基本機能

set -e

# カラー定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# プロジェクトのルートディレクトリを取得
get_project_root() {
    local current_dir="$(pwd)"
    local root_dir=""
    
    # slideflowディレクトリから遡って探す
    while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/package.json" ]] && [[ -d "$current_dir/scripts" ]]; then
            root_dir="$current_dir"
            break
        fi
        current_dir="$(dirname "$current_dir")"
    done
    
    if [[ -z "$root_dir" ]]; then
        # フォールバック: slideflowの親ディレクトリ
        root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    fi
    
    echo "$root_dir"
}

# プレゼンテーションの存在確認
presentation_exists() {
    local name="$1"
    local root="$(get_project_root)"
    
    [[ -d "$root/presentations/$name" ]]
}

# 現在のプレゼンテーションを検出
detect_current_presentation() {
    local current_dir="$(pwd)"
    local root="$(get_project_root)"
    local presentations_dir="$root/presentations"
    
    # presentationsディレクトリ内にいるか確認
    if [[ "$current_dir" == "$presentations_dir"/* ]]; then
        # プレゼンテーション名を抽出
        local relative_path="${current_dir#$presentations_dir/}"
        local presentation_name="${relative_path%%/*}"
        
        if [[ -n "$presentation_name" ]] && [[ -d "$presentations_dir/$presentation_name" ]]; then
            echo "$presentation_name"
            return 0
        fi
    fi
    
    return 1
}

# テンプレートのリスト取得
list_templates() {
    local root="$(get_project_root)"
    local templates_dir="$root/templates"
    local templates=()
    
    if [[ -d "$templates_dir" ]]; then
        while IFS= read -r -d '' dir; do
            local template_name="$(basename "$dir")"
            # テンプレートとして有効なディレクトリのみ
            if [[ -f "$dir/slides.md" ]] || [[ -f "$dir/README.md" ]]; then
                templates+=("$template_name")
            fi
        done < <(find "$templates_dir" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
    fi
    
    printf '%s\n' "${templates[@]}"
}

# プレゼンテーション情報の表示
show_presentation_info() {
    local name="${1:-}"
    local root="$(get_project_root)"
    
    # 名前が指定されていない場合は現在のプレゼンテーションを検出
    if [[ -z "$name" ]]; then
        name="$(detect_current_presentation 2>/dev/null)" || {
            echo -e "${YELLOW}プレゼンテーションディレクトリ内で実行してください${NC}"
            return 1
        }
    fi
    
    local pres_dir="$root/presentations/$name"
    
    if [[ ! -d "$pres_dir" ]]; then
        echo -e "${RED}エラー: プレゼンテーション '$name' が見つかりません${NC}"
        return 1
    fi
    
    echo -e "${BLUE}プレゼンテーション情報${NC}"
    echo -e "名前: $name"
    echo -e "パス: $pres_dir"
    echo ""
    
    # ファイル情報
    echo -e "${BLUE}ファイル:${NC}"
    [[ -f "$pres_dir/slides.md" ]] && echo -e "  ✓ slides.md"
    [[ -f "$pres_dir/README.md" ]] && echo -e "  ✓ README.md"
    [[ -f "$pres_dir/config.yaml" ]] && echo -e "  ✓ config.yaml"
    [[ -f "$pres_dir/output.html" ]] && echo -e "  ✓ output.html"
    [[ -f "$pres_dir/output.pdf" ]] && echo -e "  ✓ output.pdf"
    
    # Git情報
    if [[ -d "$pres_dir/.git" ]]; then
        echo ""
        echo -e "${BLUE}Git情報:${NC}"
        cd "$pres_dir"
        local branch="$(git branch --show-current 2>/dev/null || echo "不明")"
        local remote="$(git remote get-url origin 2>/dev/null || echo "リモートなし")"
        echo -e "  ブランチ: $branch"
        echo -e "  リモート: $remote"
    fi
    
    # スライド数のカウント
    if [[ -f "$pres_dir/slides.md" ]]; then
        echo ""
        echo -e "${BLUE}統計:${NC}"
        local slide_count="$(grep -c '^---$' "$pres_dir/slides.md" || echo 0)"
        local line_count="$(wc -l < "$pres_dir/slides.md")"
        echo -e "  スライド数: $slide_count"
        echo -e "  行数: $line_count"
    fi
}

# プレビューサーバーの改善版
start_preview_server() {
    local port="${1:-8000}"
    local root_dir="$(pwd)"
    
    # slides.mdの存在確認
    if [[ ! -f "slides.md" ]]; then
        echo -e "${RED}エラー: slides.md が見つかりません${NC}"
        return 1
    fi
    
    # HTMLファイルの生成
    echo -e "${BLUE}HTMLを生成中...${NC}"
    local project_root="$(get_project_root)"
    if command -v npx >/dev/null 2>&1 && [[ -f "$project_root/package.json" ]]; then
        # slides.htmlが存在しない場合は生成
        if [[ ! -f "slides.html" ]]; then
            echo "  slides.html を生成中..."
            (cd "$project_root" && npx @marp-team/marp-cli "$root_dir/slides.md" -o "$root_dir/slides.html" --html --allow-local-files) && {
                # 背景を白に変更
                "$project_root/scripts/generate-static-html.sh" slides.html
            } || {
                echo -e "${YELLOW}slides.html の生成に失敗しました${NC}"
            }
        fi
    fi
    
    # ポートの使用確認
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}ポート $port は既に使用されています${NC}"
        echo -n "別のポート番号を入力してください [8001]: "
        read -r new_port
        port="${new_port:-8001}"
    fi
    
    echo -e "${GREEN}プレビューサーバーを起動中...${NC}"
    echo ""
    echo -e "${BLUE}スライドURL:${NC}"
    echo -e "  ${GREEN}http://localhost:$port/slides.html${NC} - HTMLスライド"
    [[ -f "slides.md" ]] && echo -e "  ${GREEN}http://localhost:$port/slides.md${NC} - Markdownソース"
    [[ -f "index.html" ]] && echo -e "  ${GREEN}http://localhost:$port/index.html${NC} - インデックスページ"
    echo ""
    echo -e "${YELLOW}終了するには Ctrl+C を押してください${NC}"
    echo ""
    
    # Python HTTPサーバーを起動
    python3 -m http.server "$port"
}

# ビルド機能
build_presentation() {
    local format="${1:-html}"
    local input_file="${2:-slides.md}"
    local output_file="${3:-}"
    
    if [[ ! -f "$input_file" ]]; then
        echo -e "${RED}エラー: $input_file が見つかりません${NC}"
        return 1
    fi
    
    # 出力ファイル名の決定
    if [[ -z "$output_file" ]]; then
        case "$format" in
            html)
                output_file="output.html"
                ;;
            pdf)
                output_file="output.pdf"
                ;;
            pptx)
                output_file="output.pptx"
                ;;
            *)
                echo -e "${RED}エラー: 不明な形式 '$format'${NC}"
                return 1
                ;;
        esac
    fi
    
    local project_root="$(get_project_root)"
    
    echo -e "${BLUE}ビルド中: $input_file → $output_file${NC}"
    
    case "$format" in
        html)
            (cd "$project_root" && npx marp "$PWD/$input_file" -o "$PWD/$output_file" --html) && \
            echo -e "${GREEN}✓ HTMLの生成が完了しました: $output_file${NC}"
            ;;
        pdf)
            (cd "$project_root" && npx marp "$PWD/$input_file" -o "$PWD/$output_file" --pdf --allow-local-files) && \
            echo -e "${GREEN}✓ PDFの生成が完了しました: $output_file${NC}"
            ;;
        pptx)
            (cd "$project_root" && npx marp "$PWD/$input_file" -o "$PWD/$output_file" --pptx) && \
            echo -e "${GREEN}✓ PPTXの生成が完了しました: $output_file${NC}"
            ;;
    esac
}