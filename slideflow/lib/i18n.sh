#!/bin/bash
# 国際化(i18n)サポートライブラリ

# デフォルト言語
DEFAULT_LANG="ja"

# 現在の言語を取得
get_current_lang() {
    local lang="${SLIDEFLOW_LANG:-${LANG:-$DEFAULT_LANG}}"
    # 言語コードのみ抽出 (例: ja_JP.UTF-8 -> ja)
    echo "${lang%%_*}" | tr '[:upper:]' '[:lower:]'
}

# メッセージファイルのパス
I18N_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/i18n"

# メッセージをロード
declare -A MESSAGES

load_messages() {
    local lang=$(get_current_lang)
    local msg_file="$I18N_DIR/${lang}.sh"
    
    # フォールバック: 言語ファイルが存在しない場合は日本語を使用
    if [[ ! -f "$msg_file" ]]; then
        msg_file="$I18N_DIR/ja.sh"
    fi
    
    if [[ -f "$msg_file" ]]; then
        source "$msg_file"
    else
        echo "Warning: Message file not found: $msg_file" >&2
    fi
}

# メッセージを取得
msg() {
    local key="$1"
    shift
    local message="${MESSAGES[$key]:-$key}"
    
    # パラメータ置換 (%1, %2, ...)
    local i=1
    for param in "$@"; do
        message="${message//%$i/$param}"
        ((i++))
    done
    
    echo "$message"
}

# 初期化
load_messages