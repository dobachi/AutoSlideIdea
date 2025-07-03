#!/bin/bash
# Marp HTMLを静的表示用に変換するスクリプト

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

# HTMLファイルを変換
# 1. body背景を白に変更
# 2. スライドを縦に並べる
# 3. ナビゲーションボタンを非表示

sed -i.bak '
s/body{background:#000/body{background:#fff/g
s/svg\.bespoke-marp-slide{/svg.bespoke-marp-slide{position:relative!important;display:block!important;opacity:1!important;margin:20px auto;box-shadow:0 4px 6px rgba(0,0,0,.1);max-width:1280px;/g
s/\.bespoke-marp-osc{display:none/.bespoke-marp-osc{display:none!important/g
' "$HTML_FILE"

echo "Converted: $HTML_FILE"