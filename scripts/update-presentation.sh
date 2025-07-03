#!/bin/bash

# プレゼンテーション更新スクリプト（wrapper）
# 
# 注意: このスクリプトは manage-presentation.sh に統合されました。
# 互換性のため残していますが、新しいスクリプトの使用を推奨します。
# 
# 新しい使い方: ./scripts/manage-presentation.sh [options] <name>

SCRIPT_DIR=$(dirname "$0")

# 警告メッセージ
echo "⚠️  update-presentation.sh は非推奨です。"
echo "🔄 manage-presentation.sh --update の使用を推奨します。"
echo ""
echo "🔄 自動的に新しいスクリプトに転送しています..."
echo ""

# manage-presentation.sh に転送（--update フラグ付き）
exec "$SCRIPT_DIR/manage-presentation.sh" --update "$@"