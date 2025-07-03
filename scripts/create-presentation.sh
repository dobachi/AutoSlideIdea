#!/bin/bash

# プレゼンテーション作成統合スクリプト
# ローカル作業とGitHub連携の両方に対応

set -e

# デフォルト値
TEMPLATE="basic"
FULL_PROJECT=false
GITHUB_MODE=false
VISIBILITY="private"
SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# 使い方表示
usage() {
    echo "使い方: $0 [オプション] <プレゼンテーション名>"
    echo ""
    echo "オプション:"
    echo "  --template <name>  - テンプレートを指定"
    echo "                       (basic, academic, business, full-project)"
    echo "  --full            - 調査・分析・アイデア創出を含む構造"
    echo "  --github          - GitHubリポジトリとして設定"
    echo "  --public          - パブリックリポジトリ（--github使用時）"
    echo "  --workflow <type> - GitHub Actionsワークフロー"
    echo "                      (basic, full-featured, multi-language)"
    echo ""
    echo "例:"
    echo "  # ローカル作業用"
    echo "  $0 my-presentation"
    echo "  $0 --full research-project"
    echo ""
    echo "  # GitHub連携"
    echo "  $0 --github conference-2024"
    echo "  $0 --github --public --full big-project"
    echo ""
    exit 1
}

# オプション解析
WORKFLOW_TYPE="basic"
while [[ $# -gt 0 ]]; do
    case $1 in
        --template)
            TEMPLATE="$2"
            shift 2
            ;;
        --full)
            FULL_PROJECT=true
            TEMPLATE="full-project"
            shift
            ;;
        --github)
            GITHUB_MODE=true
            shift
            ;;
        --public)
            VISIBILITY="public"
            shift
            ;;
        --workflow)
            WORKFLOW_TYPE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            PRESENTATION_NAME="$1"
            shift
            ;;
    esac
done

# プレゼンテーション名チェック
if [ -z "$PRESENTATION_NAME" ]; then
    echo "エラー: プレゼンテーション名を指定してください。"
    usage
fi

# 作業ディレクトリ
PRESENTATIONS_DIR="$PROJECT_ROOT/presentations"
WORK_DIR="$PRESENTATIONS_DIR/$PRESENTATION_NAME"

# 既存チェック
if [ -d "$WORK_DIR" ]; then
    echo "エラー: '$WORK_DIR' は既に存在します。"
    exit 1
fi

# =================================================
# ステップ1: プレゼンテーション作成
# =================================================

echo "📝 プレゼンテーションを作成中..."

# ディレクトリ作成
mkdir -p "$WORK_DIR"

# テンプレートコピー
TEMPLATE_DIR="$PROJECT_ROOT/templates/$TEMPLATE"
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "エラー: テンプレート '$TEMPLATE' が見つかりません。"
    echo "利用可能なテンプレート:"
    ls -1 "$PROJECT_ROOT/templates/" | grep -v github-workflows
    exit 1
fi

cp -r "$TEMPLATE_DIR"/* "$WORK_DIR/"

# プレースホルダー置換
find "$WORK_DIR" -type f \( -name "*.md" -o -name "*.yml" \) | while read file; do
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$file"
        sed -i '' "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$file"
    else
        sed -i "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$file"
        sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$file"
    fi
done

echo "✅ プレゼンテーション '$PRESENTATION_NAME' を作成しました！"
echo "   場所: $WORK_DIR"

# =================================================
# ステップ2: GitHub設定（オプション）
# =================================================

if [ "$GITHUB_MODE" = true ]; then
    echo ""
    echo "🚀 GitHubリポジトリとして設定中..."
    
    cd "$WORK_DIR"
    
    # Git初期化
    git init
    
    # GitHub Actions設定
    mkdir -p .github/workflows
    cp "$PROJECT_ROOT/templates/github-workflows/${WORKFLOW_TYPE}.yml" .github/workflows/build-slides.yml
    
    # .gitignore作成
    cat > .gitignore << 'EOF'
# 出力ファイル
output/
dist/
*.pdf
*.pptx
*.html

# 調査データ（大容量ファイル）
research/data/*.csv
research/data/*.xlsx
research/data/*.json
research/data/*.db
!research/analysis/*.png
!research/analysis/*.jpg
!research/analysis/*.svg

# エディタ・OS設定
.vscode/
.idea/
*.swp
*~
.DS_Store
Thumbs.db

# 一時ファイル
*.tmp
*.temp
*.bak
.~lock.*
EOF

    # README.md更新
    if [ -f README.md ]; then
        echo "" >> README.md
        echo "## GitHub Actions" >> README.md
        echo "" >> README.md
        echo "このリポジトリはGitHub Actionsによる自動ビルドが設定されています。" >> README.md
        echo "mainブランチへのpush時に自動的にPDF/HTMLが生成されます。" >> README.md
    fi
    
    # 初期コミット
    git add .
    git commit -m "Initial commit: $PRESENTATION_NAME

- Created with AutoSlideIdea framework
- Template: $TEMPLATE
- GitHub Actions: $WORKFLOW_TYPE workflow"
    
    # GitHubリポジトリ作成
    if command -v gh &> /dev/null; then
        echo ""
        echo "GitHubリポジトリを作成しますか？ (y/N)"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            if [ "$VISIBILITY" = "public" ]; then
                gh repo create "$PRESENTATION_NAME" --public --source=. --remote=origin --push
            else
                gh repo create "$PRESENTATION_NAME" --private --source=. --remote=origin --push
            fi
            
            echo "✅ GitHubリポジトリを作成しました！"
            echo "   URL: https://github.com/$(gh api user -q .login)/$PRESENTATION_NAME"
            
            # GitHub Pages（パブリックのみ）
            if [ "$VISIBILITY" = "public" ]; then
                echo ""
                echo "GitHub Pagesを有効化しますか？ (y/N)"
                read -r response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    # ワークフローの実行を待つ
                    echo "GitHub Actionsの初回実行を待っています..."
                    sleep 5
                    gh api repos/:owner/:repo/pages -X POST -f source='{"branch":"gh-pages","path":"/"}' 2>/dev/null || true
                    echo "GitHub Pagesの設定を試みました。"
                fi
            fi
        fi
    else
        echo "⚠️  GitHub CLIがインストールされていません。"
        echo "手動でリポジトリを作成してください。"
    fi
fi

# =================================================
# 完了メッセージ
# =================================================

echo ""
echo "🎉 セットアップ完了！"
echo ""
echo "次のステップ:"

if [ "$GITHUB_MODE" = true ]; then
    echo "1. スライドを編集:"
    echo "   cd $WORK_DIR && code slides.md"
    echo ""
    echo "2. 変更をコミット:"
    echo "   git add . && git commit -m 'Update slides'"
    echo ""
    echo "3. GitHubにプッシュ（自動ビルドされます）:"
    echo "   git push"
else
    echo "1. スライドを編集:"
    echo "   cd $WORK_DIR && code slides.md"
    echo ""
    echo "2. ローカルでビルド:"
    echo "   marp slides.md -o output.pdf"
    echo ""
    echo "3. 後からGitHub連携する場合:"
    echo "   cd $WORK_DIR"
    echo "   $SCRIPT_DIR/create-presentation.sh --github --from-existing ."
fi

if [ "$FULL_PROJECT" = true ]; then
    echo ""
    echo "📊 フルプロジェクト構造:"
    echo "   - research/   : 調査・分析"
    echo "   - ideation/   : アイデア・構成"
    echo "   - assets/     : 画像・リソース"
fi