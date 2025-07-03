#!/bin/bash

# プレゼンテーション作成統合スクリプト
# ローカル作業とGitHub連携の両方に対応

set -e

# デフォルト値
TEMPLATE="basic"
FULL_PROJECT=false
GITHUB_MODE=false
VISIBILITY="private"
LANG="ja"  # デフォルト言語
SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# 言語設定（環境変数からも取得可能）
if [ -n "$AUTOSLIDE_LANG" ]; then
    LANG="$AUTOSLIDE_LANG"
fi

# メッセージ表示関数
msg() {
    local key="$1"
    case "$key" in
        "error_no_name")
            [ "$LANG" = "en" ] && echo "Error: Please specify presentation name." || echo "エラー: プレゼンテーション名を指定してください。"
            ;;
        "error_exists")
            [ "$LANG" = "en" ] && echo "Error: '$2' already exists." || echo "エラー: '$2' は既に存在します。"
            ;;
        "creating")
            [ "$LANG" = "en" ] && echo "📝 Creating presentation..." || echo "📝 プレゼンテーションを作成中..."
            ;;
        "template_not_found")
            [ "$LANG" = "en" ] && echo "Error: Template '$2' not found." || echo "エラー: テンプレート '$2' が見つかりません。"
            ;;
        "github_setup")
            [ "$LANG" = "en" ] && echo "🔧 Setting up GitHub repository..." || echo "🔧 GitHubリポジトリを設定中..."
            ;;
        "complete")
            [ "$LANG" = "en" ] && echo "✅ Presentation created successfully!" || echo "✅ プレゼンテーション作成完了！"
            ;;
        "next_steps")
            [ "$LANG" = "en" ] && echo "📌 Next steps:" || echo "📌 次のステップ:"
            ;;
        "github_confirm")
            [ "$LANG" = "en" ] && echo "Create GitHub repository? (y/N)" || echo "GitHubリポジトリを作成しますか？ (y/N)"
            ;;
        "github_created")
            [ "$LANG" = "en" ] && echo "✅ GitHub repository created!" || echo "✅ GitHubリポジトリを作成しました！"
            ;;
        "github_pages_confirm")
            [ "$LANG" = "en" ] && echo "Enable GitHub Pages? (y/N)" || echo "GitHub Pagesを有効化しますか？ (y/N)"
            ;;
        "github_actions_wait")
            [ "$LANG" = "en" ] && echo "Waiting for initial GitHub Actions run..." || echo "GitHub Actionsの初回実行を待っています..."
            ;;
        "github_pages_attempted")
            [ "$LANG" = "en" ] && echo "Attempted to configure GitHub Pages." || echo "GitHub Pagesの設定を試みました。"
            ;;
        "no_gh_cli")
            [ "$LANG" = "en" ] && echo "⚠️  GitHub CLI is not installed." || echo "⚠️  GitHub CLIがインストールされていません。"
            ;;
        "manual_repo")
            [ "$LANG" = "en" ] && echo "Please create the repository manually." || echo "手動でリポジトリを作成してください。"
            ;;
        "setup_complete")
            [ "$LANG" = "en" ] && echo "🎉 Setup complete!" || echo "🎉 セットアップ完了！"
            ;;
        "edit_slides")
            [ "$LANG" = "en" ] && echo "1. Edit slides:" || echo "1. スライドを編集:"
            ;;
        "push_changes")
            [ "$LANG" = "en" ] && echo "2. Push changes:" || echo "2. 変更をプッシュ:"
            ;;
        "check_actions")
            [ "$LANG" = "en" ] && echo "3. Check GitHub Actions:" || echo "3. GitHub Actionsを確認:"
            ;;
        "local_build")
            [ "$LANG" = "en" ] && echo "Build locally:" || echo "ローカルでビルド:"
            ;;
        "preview")
            [ "$LANG" = "en" ] && echo "Preview:" || echo "プレビュー:"
            ;;
    esac
}

# 使い方表示
usage() {
    if [ "$LANG" = "en" ]; then
        echo "Usage: $0 [options] <presentation-name>"
        echo ""
        echo "Options:"
        echo "  --template <name>  - Specify template"
        echo "                       (basic, academic, business, full-project)"
        echo "  --full            - Include research/analysis/ideation structure"
        echo "  --github          - Set up as GitHub repository"
        echo "  --public          - Public repository (when using --github)"
        echo "  --workflow <type> - GitHub Actions workflow"
        echo "                      (basic, full-featured, multi-language)"
        echo "  --lang <code>     - Language (ja, en)"
        echo ""
        echo "Examples:"
        echo "  # For local work"
        echo "  $0 my-presentation"
        echo "  $0 --full research-project"
        echo "  $0 --lang en my-english-talk"
        echo ""
        echo "  # With GitHub integration"
        echo "  $0 --github conference-2024"
        echo "  $0 --github --public --full big-project"
    else
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
        echo "  --lang <code>     - 言語指定（ja, en）"
        echo ""
        echo "例:"
        echo "  # ローカル作業用"
        echo "  $0 my-presentation"
        echo "  $0 --full research-project"
        echo "  $0 --lang en my-english-talk"
        echo ""
        echo "  # GitHub連携"
        echo "  $0 --github conference-2024"
        echo "  $0 --github --public --full big-project"
    fi
    echo ""
    exit 1
}

# オプション解析
WORKFLOW_TYPE="basic"
while [[ $# -gt 0 ]]; do
    case $1 in
        --lang)
            LANG="$2"
            shift 2
            ;;
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
    msg "error_no_name"
    usage
fi

# 作業ディレクトリ
PRESENTATIONS_DIR="$PROJECT_ROOT/presentations"
WORK_DIR="$PRESENTATIONS_DIR/$PRESENTATION_NAME"

# 既存チェック
if [ -d "$WORK_DIR" ]; then
    msg "error_exists" "$WORK_DIR"
    exit 1
fi

# =================================================
# ステップ1: プレゼンテーション作成
# =================================================

msg "creating"

# ディレクトリ作成
mkdir -p "$WORK_DIR"

# テンプレートコピー
TEMPLATE_DIR="$PROJECT_ROOT/templates/$TEMPLATE"
if [ ! -d "$TEMPLATE_DIR" ]; then
    msg "template_not_found" "$TEMPLATE"
    [ "$LANG" = "en" ] && echo "Available templates:" || echo "利用可能なテンプレート:"
    ls -1 "$PROJECT_ROOT/templates/" | grep -v github-workflows
    exit 1
fi

cp -r "$TEMPLATE_DIR"/* "$WORK_DIR/"

# 言語別ファイルの処理
if [ "$LANG" = "en" ]; then
    # 英語版ファイルがある場合は、日本語版を英語版で置き換え
    find "$WORK_DIR" -name "*.en.md" | while read enfile; do
        basefile="${enfile%.en.md}.md"
        if [ -f "$basefile" ]; then
            mv "$enfile" "$basefile"
        fi
    done
else
    # 日本語版の場合は英語版ファイルを削除
    find "$WORK_DIR" -name "*.en.md" -delete
fi

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

msg "complete"
if [ "$LANG" = "en" ]; then
    echo "   Location: $WORK_DIR"
else
    echo "   場所: $WORK_DIR"
fi

# =================================================
# ステップ2: GitHub設定（オプション）
# =================================================

if [ "$GITHUB_MODE" = true ]; then
    echo ""
    msg "github_setup"
    
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
        if [ "$LANG" = "en" ]; then
            echo "This repository is configured with automated builds using GitHub Actions." >> README.md
            echo "PDF/HTML will be automatically generated when pushing to the main branch." >> README.md
        else
            echo "このリポジトリはGitHub Actionsによる自動ビルドが設定されています。" >> README.md
            echo "mainブランチへのpush時に自動的にPDF/HTMLが生成されます。" >> README.md
        fi
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
        msg "github_confirm"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            if [ "$VISIBILITY" = "public" ]; then
                gh repo create "$PRESENTATION_NAME" --public --source=. --remote=origin --push
            else
                gh repo create "$PRESENTATION_NAME" --private --source=. --remote=origin --push
            fi
            
            msg "github_created"
            echo "   URL: https://github.com/$(gh api user -q .login)/$PRESENTATION_NAME"
            
            # GitHub Pages（パブリックのみ）
            if [ "$VISIBILITY" = "public" ]; then
                echo ""
                msg "github_pages_confirm"
                read -r response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    # ワークフローの実行を待つ
                    msg "github_actions_wait"
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
    [ "$LANG" = "en" ] && echo "3. Push to GitHub (auto-build enabled):" || echo "3. GitHubにプッシュ（自動ビルドされます）:"
    echo "   git push"
else
    msg "edit_slides"
    echo "   cd $WORK_DIR && code slides.md"
    echo ""
    msg "local_build"
    [ "$LANG" = "en" ] && echo "   npx marp slides.md -o output.pdf" || echo "   npx marp slides.md -o output.pdf"
    echo ""
    [ "$LANG" = "en" ] && echo "3. To enable GitHub integration later:" || echo "3. 後からGitHub連携する場合:"
    echo "   cd $WORK_DIR"
    echo "   $SCRIPT_DIR/create-presentation.sh --github --from-existing ."
fi

if [ "$FULL_PROJECT" = true ]; then
    echo ""
    [ "$LANG" = "en" ] && echo "📊 Full project structure:" || echo "📊 フルプロジェクト構造:"
    [ "$LANG" = "en" ] && echo "   - research/   : Research & analysis" || echo "   - research/   : 調査・分析"
    [ "$LANG" = "en" ] && echo "   - ideation/   : Ideas & structure" || echo "   - ideation/   : アイデア・構成"
    [ "$LANG" = "en" ] && echo "   - assets/     : Images & resources" || echo "   - assets/     : 画像・リソース"
fi