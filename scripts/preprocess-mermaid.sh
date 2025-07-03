#!/bin/bash

# Mermaidダイアグラムを画像に変換する前処理スクリプト

set -e

# 引数チェック
if [ $# -ne 1 ]; then
    echo "使用方法: $0 <input.md>"
    exit 1
fi

INPUT_FILE="$1"
BASENAME=$(basename "$INPUT_FILE" .md)
DIRNAME=$(dirname "$INPUT_FILE")
OUTPUT_FILE="${DIRNAME}/${BASENAME}-processed.md"
MERMAID_DIR="${DIRNAME}/mermaid-images"

# Mermaid画像ディレクトリを作成
mkdir -p "$MERMAID_DIR"

# 一時ファイル
TEMP_FILE=$(mktemp)

# Mermaidブロックのカウンター
COUNTER=0

# 入力ファイルを処理
echo "Mermaidダイアグラムを処理中: $INPUT_FILE"

# ファイルを一行ずつ処理
IN_MERMAID=false
MERMAID_CONTENT=""

while IFS= read -r line || [ -n "$line" ]; do
    if [[ "$line" == '```mermaid' ]]; then
        IN_MERMAID=true
        MERMAID_CONTENT=""
    elif $IN_MERMAID && [[ "$line" == '```' ]]; then
        IN_MERMAID=false
        COUNTER=$((COUNTER + 1))
        
        # Mermaidコンテンツを一時ファイルに保存
        echo "$MERMAID_CONTENT" > "${TEMP_FILE}.mmd"
        
        # 画像ファイル名
        IMAGE_FILE="${MERMAID_DIR}/diagram-${COUNTER}.svg"
        
        # Mermaidで画像生成
        echo "  - ダイアグラム ${COUNTER} を生成中..."
        npx mmdc -i "${TEMP_FILE}.mmd" -o "$IMAGE_FILE" -t default -b transparent
        
        # Markdownに画像参照を追加
        echo "![Diagram ${COUNTER}](${IMAGE_FILE#$DIRNAME/})" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
    elif $IN_MERMAID; then
        if [ -z "$MERMAID_CONTENT" ]; then
            MERMAID_CONTENT="$line"
        else
            MERMAID_CONTENT="$MERMAID_CONTENT
$line"
        fi
    else
        echo "$line" >> "$TEMP_FILE"
    fi
done < "$INPUT_FILE"

# 処理済みファイルを出力
mv "$TEMP_FILE" "$OUTPUT_FILE"

# 一時ファイルをクリーンアップ
rm -f "${TEMP_FILE}.mmd"

echo "完了: $OUTPUT_FILE"
echo "生成された画像: ${COUNTER}個"