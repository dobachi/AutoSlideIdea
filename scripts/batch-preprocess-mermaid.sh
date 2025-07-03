#!/bin/bash
# 複数のMarkdownファイルのMermaid図表を一括処理するスクリプト

set -e

# カラー出力用の関数
print_info() {
    echo -e "\033[0;36m$1\033[0m"
}

print_success() {
    echo -e "\033[0;32m✓ $1\033[0m"
}

print_error() {
    echo -e "\033[0;31m✗ $1\033[0m"
}

print_warning() {
    echo -e "\033[0;33m⚠ $1\033[0m"
}

print_progress() {
    echo -e "\033[0;35m[$1/$2]\033[0m $3"
}

# 使用方法を表示
usage() {
    cat << EOF
Batch Mermaid Preprocessor for Multiple Marp Presentations

Usage: $0 [options] <files-or-patterns...>

Options:
  -o, --output-dir <dir>   Output directory (default: processed/)
  -t, --theme <theme>      Mermaid theme: default, forest, dark, neutral
  -b, --bg-color <color>   Background color (default: transparent)
  -w, --width <pixels>     Diagram width (default: 1280)
  -h, --height <pixels>    Diagram height (default: 720)
  -f, --format <format>    Output format: svg, png, pdf (default: svg)
  --config <file>          Mermaid config file
  --css <file>             Custom CSS file
  --parallel <n>           Process files in parallel (default: 1)
  --preserve-structure     Preserve directory structure in output
  --dry-run                Show what would be processed without doing it
  --help                   Show this help

Examples:
  $0 presentations/**/*.md
  $0 -o build/ -t dark --parallel 4 *.md
  $0 --preserve-structure -o processed/ presentations/

EOF
}

# デフォルト値
OUTPUT_DIR="processed"
THEME="default"
BG_COLOR="transparent"
WIDTH="1280"
HEIGHT="720"
FORMAT="svg"
CONFIG_FILE=""
CSS_FILE=""
PARALLEL=1
PRESERVE_STRUCTURE=false
DRY_RUN=false

# グローバル変数
declare -a FILES_TO_PROCESS
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREPROCESS_SCRIPT="$SCRIPT_DIR/preprocess-mermaid.sh"

# オプション解析
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -t|--theme)
            THEME="$2"
            shift 2
            ;;
        -b|--bg-color)
            BG_COLOR="$2"
            shift 2
            ;;
        -w|--width)
            WIDTH="$2"
            shift 2
            ;;
        -h|--height)
            HEIGHT="$2"
            shift 2
            ;;
        -f|--format)
            FORMAT="$2"
            shift 2
            ;;
        --config)
            CONFIG_FILE="$2"
            shift 2
            ;;
        --css)
            CSS_FILE="$2"
            shift 2
            ;;
        --parallel)
            PARALLEL="$2"
            shift 2
            ;;
        --preserve-structure)
            PRESERVE_STRUCTURE=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        -*)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

# 入力ファイルの収集
if [ $# -eq 0 ]; then
    print_error "No input files or patterns specified"
    usage
    exit 1
fi

# 前処理スクリプトの存在確認
if [ ! -f "$PREPROCESS_SCRIPT" ]; then
    print_error "Preprocessing script not found: $PREPROCESS_SCRIPT"
    print_info "Make sure preprocess-mermaid.sh exists in the same directory"
    exit 1
fi

# ファイルパターンの展開と収集
print_info "Searching for Markdown files..."
for pattern in "$@"; do
    # ディレクトリの場合は再帰的に検索
    if [ -d "$pattern" ]; then
        while IFS= read -r -d '' file; do
            FILES_TO_PROCESS+=("$file")
        done < <(find "$pattern" -name "*.md" -type f -print0)
    else
        # グロブパターンの展開
        for file in $pattern; do
            if [ -f "$file" ] && [[ "$file" == *.md ]]; then
                FILES_TO_PROCESS+=("$file")
            fi
        done
    fi
done

# 重複を除去
mapfile -t FILES_TO_PROCESS < <(printf '%s\n' "${FILES_TO_PROCESS[@]}" | sort -u)

# ファイル数の確認
TOTAL_FILES=${#FILES_TO_PROCESS[@]}
if [ $TOTAL_FILES -eq 0 ]; then
    print_warning "No Markdown files found matching the specified patterns"
    exit 0
fi

print_info "Found $TOTAL_FILES Markdown file(s) to process"

# ドライランモード
if [ "$DRY_RUN" = true ]; then
    print_info "DRY RUN MODE - No files will be modified"
    print_info "Files that would be processed:"
    for file in "${FILES_TO_PROCESS[@]}"; do
        if grep -q '```mermaid' "$file" 2>/dev/null; then
            echo "  ✓ $file (contains mermaid blocks)"
        else
            echo "  - $file (no mermaid blocks)"
        fi
    done
    exit 0
fi

# 出力ディレクトリの作成
mkdir -p "$OUTPUT_DIR"
print_info "Output directory: $OUTPUT_DIR"

# 処理関数
process_file() {
    local file="$1"
    local index="$2"
    local total="$3"
    
    # Mermaidブロックの存在確認
    if ! grep -q '```mermaid' "$file" 2>/dev/null; then
        print_progress "$index" "$total" "⏭️  Skipping $file (no mermaid blocks)"
        return 0
    fi
    
    # 出力パスの計算
    local output_file
    if [ "$PRESERVE_STRUCTURE" = true ]; then
        # ディレクトリ構造を保持
        local rel_path="${file#./}"
        local dir_path=$(dirname "$rel_path")
        local base_name=$(basename "$file")
        
        mkdir -p "$OUTPUT_DIR/$dir_path"
        output_file="$OUTPUT_DIR/$rel_path"
    else
        # フラットな構造
        local base_name=$(basename "$file" .md)
        output_file="$OUTPUT_DIR/${base_name}-processed.md"
    fi
    
    print_progress "$index" "$total" "🔄 Processing $file"
    
    # 前処理スクリプトのオプション構築
    local opts=(-o "$output_file" -t "$THEME" -b "$BG_COLOR" -w "$WIDTH" -h "$HEIGHT" -f "$FORMAT")
    
    if [ -n "$CONFIG_FILE" ]; then
        opts+=(--config "$CONFIG_FILE")
    fi
    
    if [ -n "$CSS_FILE" ]; then
        opts+=(--css "$CSS_FILE")
    fi
    
    # 処理実行
    if "$PREPROCESS_SCRIPT" "${opts[@]}" "$file" > /dev/null 2>&1; then
        print_progress "$index" "$total" "✅ Success: $file → $output_file"
        return 0
    else
        print_progress "$index" "$total" "❌ Failed: $file"
        return 1
    fi
}

# 並列処理のエクスポート
export -f process_file print_progress
export OUTPUT_DIR PRESERVE_STRUCTURE THEME BG_COLOR WIDTH HEIGHT FORMAT CONFIG_FILE CSS_FILE PREPROCESS_SCRIPT

# 処理開始時刻
START_TIME=$(date +%s)

print_info ""
print_info "Starting batch processing..."
print_info "Theme: $THEME, Background: $BG_COLOR, Format: $FORMAT"
print_info "Parallel jobs: $PARALLEL"
print_info ""

# 処理実行
if [ "$PARALLEL" -gt 1 ] && command -v parallel &> /dev/null; then
    # GNU parallelを使用した並列処理
    print_info "Using GNU parallel for processing..."
    
    printf '%s\n' "${FILES_TO_PROCESS[@]}" | \
    parallel -j "$PARALLEL" --progress --bar \
        process_file {} {#} "$TOTAL_FILES"
    
    SUCCESS=$?
else
    # 逐次処理
    if [ "$PARALLEL" -gt 1 ]; then
        print_warning "GNU parallel not found, falling back to sequential processing"
    fi
    
    SUCCESS=0
    PROCESSED=0
    FAILED=0
    
    for i in "${!FILES_TO_PROCESS[@]}"; do
        if process_file "${FILES_TO_PROCESS[$i]}" "$((i+1))" "$TOTAL_FILES"; then
            ((PROCESSED++))
        else
            ((FAILED++))
            SUCCESS=1
        fi
    done
fi

# 処理時間の計算
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

# 結果サマリー
print_info ""
print_info "========================================="
print_success "Batch processing complete!"
print_info "Total files: $TOTAL_FILES"
if [ "$SUCCESS" -eq 0 ]; then
    print_success "All files processed successfully"
else
    print_warning "Some files failed to process"
    [ -n "$FAILED" ] && print_error "Failed: $FAILED"
fi
print_info "Output directory: $OUTPUT_DIR"
print_info "Processing time: ${DURATION}s"
print_info "========================================="

# 次のステップの提案
if [ "$SUCCESS" -eq 0 ]; then
    print_info ""
    print_info "Next steps:"
    print_info "1. Build PDFs:"
    print_info "   find $OUTPUT_DIR -name '*.md' -exec marp {} --pdf --allow-local-files \;"
    print_info ""
    print_info "2. Build HTMLs:"
    print_info "   find $OUTPUT_DIR -name '*.md' -exec marp {} --html --allow-local-files \;"
    print_info ""
    print_info "3. Preview a specific file:"
    print_info "   marp --preview $OUTPUT_DIR/<filename>.md"
fi

exit $SUCCESS