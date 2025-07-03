#!/bin/bash

# 新規プレゼンテーション作成スクリプト

set -e

# 使い方表示
usage() {
    echo "使い方: $0 [オプション] <プレゼンテーション名> [テンプレート]"
    echo ""
    echo "オプション:"
    echo "  --full    - 調査・分析・アイデア創出を含むフルプロジェクト構造"
    echo ""
    echo "テンプレート:"
    echo "  basic       - 基本テンプレート（デフォルト）"
    echo "  academic    - 学術発表用"
    echo "  business    - ビジネス用"
    echo "  full-project - フルプロジェクト（--fullオプション使用時のデフォルト）"
    echo ""
    echo "例:"
    echo "  $0 my-presentation"
    echo "  $0 conference-talk academic"
    echo "  $0 --full research-project"
    echo "  $0 --full big-conference full-project"
    exit 1
}

# フルプロジェクトフラグ
FULL_PROJECT=false

# オプション解析
if [ "$1" = "--full" ]; then
    FULL_PROJECT=true
    shift
fi

# 引数チェック
if [ $# -lt 1 ]; then
    usage
fi

# 変数設定
PRESENTATION_NAME=$1
if [ "$FULL_PROJECT" = true ]; then
    TEMPLATE=${2:-full-project}
else
    TEMPLATE=${2:-basic}
fi
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
find "$NEW_PRESENTATION_DIR" -type f \( -name "*.md" -o -name "*.yml" \) | while read file; do
    # macOSとLinuxの両方で動作するsedコマンド
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$file"
        sed -i '' "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$file"
    else
        sed -i "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$file"
        sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$file"
    fi
done

# 成功メッセージ
echo "✅ プレゼンテーション '$PRESENTATION_NAME' を作成しました！"
echo ""
echo "場所: $NEW_PRESENTATION_DIR"
echo ""
echo "次のステップ:"
if [ "$FULL_PROJECT" = true ]; then
    echo "1. 調査フェーズ:"
    echo "   cd $NEW_PRESENTATION_DIR/research"
    echo "   # データ収集と分析を実施"
    echo ""
    echo "2. アイデア創出:"
    echo "   cd $NEW_PRESENTATION_DIR/ideation"
    echo "   # ブレインストーミングと構成検討"
    echo ""
    echo "3. スライド作成:"
    echo "   cd $NEW_PRESENTATION_DIR && code slides.md"
    echo ""
    echo "4. AI指示書システムの活用:"
    echo "   - 調査: basic_data_analysis.md, python_expert.md"
    echo "   - 創造: basic_creative_work.md"
    echo "   - 執筆: technical_writer.md"
else
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
    echo "   AIツール（Claude Code/Gemini CLIなど）で「$NEW_PRESENTATION_DIR/slides.md を編集してください」"
fi