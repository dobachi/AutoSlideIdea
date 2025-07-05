#!/bin/bash
# 
# AI支援なしでクリーンなコミットメッセージを作成するスクリプト
#
# 使用方法:
#   scripts/commit.sh "コミットメッセージ"
#

if [ $# -eq 0 ]; then
    echo "エラー: コミットメッセージが必要です"
    echo "使用方法: $0 \"コミットメッセージ\""
    exit 1
fi

# コミットメッセージ
MESSAGE="$1"

# gitコミットを実行
git commit -m "$MESSAGE"

# 結果を表示
if [ $? -eq 0 ]; then
    echo "✅ コミット成功"
    git log --oneline -1
else
    echo "❌ コミット失敗"
fi