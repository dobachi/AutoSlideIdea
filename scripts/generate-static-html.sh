#!/bin/bash
# Marp HTMLの背景を白に変更するスクリプト（全画面モード対応）

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

# body背景を白に変更（通常モードと全画面モード両方）
sed -i.bak -e 's/body{background:#000/body{background:#fff/g' \
           -e 's/body\[data-bespoke-view=presenter\]{background:#161616/body[data-bespoke-view=presenter]{background:#f5f5f5/g' \
           -e 's/\.bespoke-marp-presenter-next-container{background:#222/\.bespoke-marp-presenter-next-container{background:#e0e0e0/g' \
           -e 's/\.bespoke-marp-presenter-note-container{background:#222/\.bespoke-marp-presenter-note-container{background:#e0e0e0/g' \
           "$HTML_FILE"

# 全画面モード用の追加CSS
echo '<style>
/* 全画面モードでも白背景を維持 */
:fullscreen { background: #fff !important; }
:-webkit-full-screen { background: #fff !important; }
:-moz-full-screen { background: #fff !important; }
:-ms-fullscreen { background: #fff !important; }

/* スライド間の黒い隙間も白に */
.bespoke-marp-parent { background: #fff !important; }
</style>' >> "$HTML_FILE"

echo "Background changed to white (including fullscreen): $HTML_FILE"