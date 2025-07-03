#!/bin/bash

# 新規プレゼンテーション作成スクリプト

set -e

# 使い方表示
usage() {
    echo "使い方: $0 <プレゼンテーション名> [テンプレート]"
    echo ""
    echo "テンプレート:"
    echo "  basic     - 基本テンプレート（デフォルト）"
    echo "  academic  - 学術発表用"
    echo "  business  - ビジネス用"
    echo ""
    echo "例:"
    echo "  $0 my-presentation"
    echo "  $0 conference-talk academic"
    exit 1
}

# 引数チェック
if [ $# -lt 1 ]; then
    usage
fi

# 変数設定
PRESENTATION_NAME=$1
TEMPLATE=${2:-basic}
SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
PRESENTATIONS_DIR="$PROJECT_ROOT/presentations"
TEMPLATE_DIR="$PROJECT_ROOT/templates/$TEMPLATE"
NEW_PRESENTATION_DIR="$PRESENTATIONS_DIR/$PRESENTATION_NAME"

# テンプレートの存在確認
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "エラー: テンプレート '$TEMPLATE' が見つかりません。"
    echo "利用可能なテンプレート:"
    ls -1 "$PROJECT_ROOT/templates/"
    exit 1
fi

# 既存のプレゼンテーションチェック
if [ -d "$NEW_PRESENTATION_DIR" ]; then
    echo "エラー: プレゼンテーション '$PRESENTATION_NAME' は既に存在します。"
    exit 1
fi

# プレゼンテーションディレクトリ作成
echo "新規プレゼンテーション '$PRESENTATION_NAME' を作成中..."
mkdir -p "$NEW_PRESENTATION_DIR"

# テンプレートをコピー
cp -r "$TEMPLATE_DIR"/* "$NEW_PRESENTATION_DIR/"

# プレゼンテーション名を置換
if [ -f "$NEW_PRESENTATION_DIR/slides.md" ]; then
    # macOSとLinuxの両方で動作するsedコマンド
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$NEW_PRESENTATION_DIR/slides.md"
        sed -i '' "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$NEW_PRESENTATION_DIR/slides.md"
    else
        sed -i "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$NEW_PRESENTATION_DIR/slides.md"
        sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$NEW_PRESENTATION_DIR/slides.md"
    fi
fi

# 成功メッセージ
echo "✅ プレゼンテーション '$PRESENTATION_NAME' を作成しました！"
echo ""
echo "場所: $NEW_PRESENTATION_DIR"
echo ""
echo "次のステップ:"
echo "1. スライドを編集:"
echo "   cd $NEW_PRESENTATION_DIR && code slides.md"
echo ""
echo "2. プレビュー:"
echo "   marp --preview slides.md"
echo ""
echo "3. PDF生成:"
echo "   marp slides.md -o output.pdf"
echo ""
echo "4. AI支援でコンテンツ作成:"
echo "   Claude Codeで「$NEW_PRESENTATION_DIR/slides.md を編集してください」"