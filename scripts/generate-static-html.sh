#!/bin/bash
# Marp HTMLの背景を白に変更するスクリプト

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 <marp-html-file>"
    exit 1
fi

HTML_FILE="$1"

if [ ! -f "$HTML_FILE" ]; then
    echo "Error: File not found: $HTML_FILE"
    exit 1
fi

# body背景を白に変更するだけ
sed -i.bak 's/body{background:#000/body{background:#fff/g' "$HTML_FILE"

echo "Background changed to white: $HTML_FILE"