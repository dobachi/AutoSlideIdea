#!/bin/bash
# SlideFlow設定管理

# 設定ファイルのパス
CONFIG_DIR="${HOME}/.slideflow"
CONFIG_FILE="${CONFIG_DIR}/config"

# デフォルト設定
declare -A DEFAULT_CONFIG=(
    ["presentations_dir"]="${PROJECT_ROOT}/presentations"
    ["preview_port"]="8000"
    ["default_template"]="basic"
    ["default_lang"]="ja"
)

# 設定ファイルを読み込む
load_config() {
    declare -gA SLIDEFLOW_CONFIG
    
    # デフォルト設定をロード
    for key in "${!DEFAULT_CONFIG[@]}"; do
        SLIDEFLOW_CONFIG[$key]="${DEFAULT_CONFIG[$key]}"
    done
    
    # 設定ファイルが存在する場合は読み込む
    if [[ -f "$CONFIG_FILE" ]]; then
        while IFS='=' read -r key value; do
            # コメントと空行をスキップ
            [[ -z "$key" || "$key" =~ ^# ]] && continue
            # 前後の空白を削除
            key="${key// /}"
            value="${value#"${value%%[![:space:]]*}"}"
            value="${value%"${value##*[![:space:]]}"}"
            # 設定を保存
            SLIDEFLOW_CONFIG[$key]="$value"
        done < "$CONFIG_FILE"
    fi
}

# 設定値を取得
get_config() {
    local key="$1"
    local default_value="${2:-}"
    
    # 環境変数を優先
    case "$key" in
        "presentations_dir")
            echo "${SLIDEFLOW_PRESENTATIONS_DIR:-${SLIDEFLOW_CONFIG[$key]:-$default_value}}"
            ;;
        "preview_port")
            echo "${SLIDEFLOW_PREVIEW_PORT:-${SLIDEFLOW_CONFIG[$key]:-$default_value}}"
            ;;
        "default_template")
            echo "${SLIDEFLOW_DEFAULT_TEMPLATE:-${SLIDEFLOW_CONFIG[$key]:-$default_value}}"
            ;;
        "default_lang")
            echo "${SLIDEFLOW_LANG:-${SLIDEFLOW_CONFIG[$key]:-$default_value}}"
            ;;
        *)
            echo "${SLIDEFLOW_CONFIG[$key]:-$default_value}"
            ;;
    esac
}

# 設定値を保存
set_config() {
    local key="$1"
    local value="$2"
    
    # 設定ディレクトリを作成
    [[ ! -d "$CONFIG_DIR" ]] && mkdir -p "$CONFIG_DIR"
    
    # 既存の設定を読み込む
    local temp_file="${CONFIG_FILE}.tmp"
    local found=false
    
    if [[ -f "$CONFIG_FILE" ]]; then
        while IFS='=' read -r existing_key existing_value; do
            if [[ "$existing_key" =~ ^[[:space:]]*"$key"[[:space:]]*$ ]]; then
                echo "$key=$value" >> "$temp_file"
                found=true
            else
                echo "$existing_key=$existing_value" >> "$temp_file"
            fi
        done < "$CONFIG_FILE"
    fi
    
    # 新しい設定を追加
    if [[ "$found" == "false" ]]; then
        echo "$key=$value" >> "$temp_file"
    fi
    
    # ファイルを置き換え
    mv "$temp_file" "$CONFIG_FILE"
}

# 設定を表示
show_config() {
    echo "Current SlideFlow Configuration:"
    echo "================================"
    echo ""
    
    # 環境変数
    echo "Environment Variables (if set):"
    [[ -n "$SLIDEFLOW_PRESENTATIONS_DIR" ]] && echo "  SLIDEFLOW_PRESENTATIONS_DIR=$SLIDEFLOW_PRESENTATIONS_DIR"
    [[ -n "$SLIDEFLOW_PREVIEW_PORT" ]] && echo "  SLIDEFLOW_PREVIEW_PORT=$SLIDEFLOW_PREVIEW_PORT"
    [[ -n "$SLIDEFLOW_DEFAULT_TEMPLATE" ]] && echo "  SLIDEFLOW_DEFAULT_TEMPLATE=$SLIDEFLOW_DEFAULT_TEMPLATE"
    [[ -n "$SLIDEFLOW_LANG" ]] && echo "  SLIDEFLOW_LANG=$SLIDEFLOW_LANG"
    echo ""
    
    # 設定ファイル
    if [[ -f "$CONFIG_FILE" ]]; then
        echo "Config File ($CONFIG_FILE):"
        cat "$CONFIG_FILE" | while IFS='=' read -r key value; do
            [[ -z "$key" || "$key" =~ ^# ]] && continue
            echo "  $key=$value"
        done
    else
        echo "No config file found."
    fi
    echo ""
    
    # 有効な設定値
    echo "Effective Configuration:"
    echo "  presentations_dir=$(get_config presentations_dir)"
    echo "  preview_port=$(get_config preview_port)"
    echo "  default_template=$(get_config default_template)"
    echo "  default_lang=$(get_config default_lang)"
}

# 設定を初期化
load_config