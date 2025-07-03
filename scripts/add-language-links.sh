#!/bin/bash
# 各ドキュメントに言語切り替えリンクを追加するスクリプト

set -e

# docs/ディレクトリに移動
cd /home/dobachi/Sources/AutoSlideIdea/docs

# 日本語ファイルを処理
find . -name "*.md" -not -name "*.en.md" | while read -r jp_file; do
    en_file="${jp_file%.md}.en.md"
    
    # 英語版ファイルが存在する場合のみ処理
    if [ -f "$en_file" ]; then
        # 既に言語リンクがあるか確認
        if ! grep -q "^\[English\]" "$jp_file"; then
            echo "Adding language link to: $jp_file"
            # 一時ファイルを作成
            {
                echo "[English]($(basename "$en_file")) | 日本語"
                echo ""
                cat "$jp_file"
            } > "${jp_file}.tmp"
            mv "${jp_file}.tmp" "$jp_file"
        fi
    fi
done

# 英語ファイルを処理
find . -name "*.en.md" | while read -r en_file; do
    jp_file="${en_file%.en.md}.md"
    
    # 日本語版ファイルが存在する場合のみ処理
    if [ -f "$jp_file" ]; then
        # 既に言語リンクがあるか確認
        if ! grep -q "^\[English\]" "$en_file"; then
            echo "Adding language link to: $en_file"
            # 一時ファイルを作成
            {
                echo "[English]($(basename "$en_file")) | [日本語]($(basename "$jp_file"))"
                echo ""
                cat "$en_file"
            } > "${en_file}.tmp"
            mv "${en_file}.tmp" "$en_file"
        fi
    fi
done

echo "Language links added successfully!"