#!/bin/bash

# プレゼンテーション作成統合スクリプト（多言語対応版）
# ローカル作業とGitHub連携の両方に対応

set -e

# デフォルト値
TEMPLATE="basic"
FULL_PROJECT=false
GITHUB_MODE=false
VISIBILITY="private"
SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# 言語設定（環境変数からデフォルト値を取得、なければ日本語）
LANG="${AUTOSLIDE_LANG:-ja}"

# 使い方表示（言語対応）
usage() {
    if [ "$LANG" = "en" ]; then
        echo "Usage: $0 [options] <presentation-name>"
        echo ""
        echo "Options:"
        echo "  --template <name>  - Specify template"
        echo "                       (basic, academic, business, full-project)"
        echo "  --full            - Include research/analysis/ideation structure"
        echo "  --github          - Setup as GitHub repository"
        echo "  --public          - Public repository (with --github)"
        echo "  --workflow <type> - GitHub Actions workflow"
        echo "                      (basic, full-featured, multi-language)"
        echo "  --lang <code>     - Language (ja, en)"
        echo ""
        echo "Examples:"
        echo "  # Local work"
        echo "  $0 my-presentation"
        echo "  $0 --lang en --full research-project"
        echo ""
        echo "  # GitHub integration"
        echo "  $0 --github conference-2024"
        echo "  $0 --github --public --full big-project"
        echo ""
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
        echo "  --lang <code>     - 言語（ja, en）"
        echo ""
        echo "例:"
        echo "  # ローカル作業用"
        echo "  $0 my-presentation"
        echo "  $0 --lang en --full research-project"
        echo ""
        echo "  # GitHub連携"
        echo "  $0 --github conference-2024"
        echo "  $0 --github --public --full big-project"
        echo ""
    fi
    exit 1
}

# メッセージ表示関数（言語対応）
message() {
    local key=$1
    case "$key" in
        "error_no_name")
            [ "$LANG" = "en" ] && echo "Error: Please specify presentation name." || echo "エラー: プレゼンテーション名を指定してください。"
            ;;
        "error_exists")
            [ "$LANG" = "en" ] && echo "Error: '$2' already exists." || echo "エラー: '$2' は既に存在します。"
            ;;
        "error_template")
            [ "$LANG" = "en" ] && echo "Error: Template '$2' not found." || echo "エラー: テンプレート '$2' が見つかりません。"
            ;;
        "creating")
            [ "$LANG" = "en" ] && echo "📝 Creating presentation..." || echo "📝 プレゼンテーションを作成中..."
            ;;
        "created")
            [ "$LANG" = "en" ] && echo "✅ Created presentation '$2'!" || echo "✅ プレゼンテーション '$2' を作成しました！"
            ;;
        "location")
            [ "$LANG" = "en" ] && echo "   Location: $2" || echo "   場所: $2"
            ;;
        "available_templates")
            [ "$LANG" = "en" ] && echo "Available templates:" || echo "利用可能なテンプレート:"
            ;;
        "setup_github")
            [ "$LANG" = "en" ] && echo "🚀 Setting up as GitHub repository..." || echo "🚀 GitHubリポジトリとして設定中..."
            ;;
        "complete")
            [ "$LANG" = "en" ] && echo "🎉 Setup complete!" || echo "🎉 セットアップ完了！"
            ;;
        "next_steps")
            [ "$LANG" = "en" ] && echo "Next steps:" || echo "次のステップ:"
            ;;
    esac
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
        --lang)
            LANG="$2"
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
    message "error_no_name"
    usage
fi

# 作業ディレクトリ
PRESENTATIONS_DIR="$PROJECT_ROOT/presentations"
WORK_DIR="$PRESENTATIONS_DIR/$PRESENTATION_NAME"

# 既存チェック
if [ -d "$WORK_DIR" ]; then
    message "error_exists" "$WORK_DIR"
    exit 1
fi

# =================================================
# ステップ1: プレゼンテーション作成
# =================================================

message "creating"

# ディレクトリ作成
mkdir -p "$WORK_DIR"

# テンプレートコピー
TEMPLATE_DIR="$PROJECT_ROOT/templates/$TEMPLATE"
if [ ! -d "$TEMPLATE_DIR" ]; then
    message "error_template" "$TEMPLATE"
    message "available_templates"
    ls -1 "$PROJECT_ROOT/templates/" | grep -v github-workflows
    exit 1
fi

# 言語別ファイルの選択とコピー
copy_with_language() {
    local src_dir=$1
    local dst_dir=$2
    
    # ディレクトリ内のすべてのファイルをループ
    find "$src_dir" -type f | while read src_file; do
        local rel_path="${src_file#$src_dir/}"
        local dst_file="$dst_dir/$rel_path"
        local dst_file_dir=$(dirname "$dst_file")
        
        # ディレクトリ作成
        mkdir -p "$dst_file_dir"
        
        # 言語別ファイルの処理
        if [[ "$LANG" = "en" && -f "${src_file%.md}.en.md" ]]; then
            # 英語版が存在する場合はそれを使用
            cp "${src_file%.md}.en.md" "$dst_file"
        elif [[ "$rel_path" =~ \.en\.md$ ]]; then
            # .en.mdファイルはスキップ（日本語モードの場合）
            continue
        else
            # 通常のファイルをコピー
            cp "$src_file" "$dst_file"
        fi
    done
}

# テンプレートを言語を考慮してコピー
copy_with_language "$TEMPLATE_DIR" "$WORK_DIR"

# プレースホルダー置換（言語別）
find "$WORK_DIR" -type f \( -name "*.md" -o -name "*.yml" \) | while read file; do
    # 日付の言語別フォーマット
    if [ "$LANG" = "en" ]; then
        DATE_FORMAT="%B %d, %Y"  # December 25, 2024
    else
        DATE_FORMAT="%Y年%m月%d日"  # 2024年12月25日
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$file"
        sed -i '' "s/{{DATE}}/$(date +"$DATE_FORMAT")/g" "$file"
        sed -i '' "s/{{LANG}}/$LANG/g" "$file"
    else
        sed -i "s/{{PRESENTATION_NAME}}/$PRESENTATION_NAME/g" "$file"
        sed -i "s/{{DATE}}/$(date +"$DATE_FORMAT")/g" "$file"
        sed -i "s/{{LANG}}/$LANG/g" "$file"
    fi
done

message "created" "$PRESENTATION_NAME"
message "location" "$WORK_DIR"

# =================================================
# ステップ2: GitHub設定（オプション）
# =================================================

if [ "$GITHUB_MODE" = true ]; then
    echo ""
    message "setup_github"
    
    cd "$WORK_DIR"
    
    # Git初期化
    git init
    
    # GitHub Actions設定
    mkdir -p .github/workflows
    
    # 多言語対応の場合は multi-language.yml を使用
    if [ "$WORKFLOW_TYPE" = "multi-language" ] || [ "$LANG" != "ja" ]; then
        cp "$PROJECT_ROOT/templates/github-workflows/multi-language.yml" .github/workflows/build-slides.yml
    else
        cp "$PROJECT_ROOT/templates/github-workflows/${WORKFLOW_TYPE}.yml" .github/workflows/build-slides.yml
    fi
    
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

    # README.md更新（言語別）
    if [ -f README.md ]; then
        if [ "$LANG" = "en" ]; then
            echo "" >> README.md
            echo "## GitHub Actions" >> README.md
            echo "" >> README.md
            echo "This repository has automatic build with GitHub Actions." >> README.md
            echo "PDF/HTML will be generated automatically when pushing to main branch." >> README.md
        else
            echo "" >> README.md
            echo "## GitHub Actions" >> README.md
            echo "" >> README.md
            echo "このリポジトリはGitHub Actionsによる自動ビルドが設定されています。" >> README.md
            echo "mainブランチへのpush時に自動的にPDF/HTMLが生成されます。" >> README.md
        fi
    fi
    
    # 初期コミット（言語別メッセージ）
    git add .
    if [ "$LANG" = "en" ]; then
        git commit -m "Initial commit: $PRESENTATION_NAME

- Created with AutoSlideIdea framework
- Template: $TEMPLATE
- Language: English
- GitHub Actions: $WORKFLOW_TYPE workflow"
    else
        git commit -m "Initial commit: $PRESENTATION_NAME

- Created with AutoSlideIdea framework
- Template: $TEMPLATE
- Language: Japanese
- GitHub Actions: $WORKFLOW_TYPE workflow"
    fi
    
    # GitHubリポジトリ作成
    if command -v gh &> /dev/null; then
        echo ""
        if [ "$LANG" = "en" ]; then
            echo "Create GitHub repository? (y/N)"
        else
            echo "GitHubリポジトリを作成しますか？ (y/N)"
        fi
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            if [ "$VISIBILITY" = "public" ]; then
                gh repo create "$PRESENTATION_NAME" --public --source=. --remote=origin --push
            else
                gh repo create "$PRESENTATION_NAME" --private --source=. --remote=origin --push
            fi
            
            if [ "$LANG" = "en" ]; then
                echo "✅ Created GitHub repository!"
            else
                echo "✅ GitHubリポジトリを作成しました！"
            fi
            echo "   URL: https://github.com/$(gh api user -q .login)/$PRESENTATION_NAME"
            
            # GitHub Pages（パブリックのみ）
            if [ "$VISIBILITY" = "public" ]; then
                echo ""
                if [ "$LANG" = "en" ]; then
                    echo "Enable GitHub Pages? (y/N)"
                else
                    echo "GitHub Pagesを有効化しますか？ (y/N)"
                fi
                read -r response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    # ワークフローの実行を待つ
                    if [ "$LANG" = "en" ]; then
                        echo "Waiting for initial GitHub Actions run..."
                    else
                        echo "GitHub Actionsの初回実行を待っています..."
                    fi
                    sleep 5
                    gh api repos/:owner/:repo/pages -X POST -f source='{"branch":"gh-pages","path":"/"}' 2>/dev/null || true
                    if [ "$LANG" = "en" ]; then
                        echo "Attempted to configure GitHub Pages."
                    else
                        echo "GitHub Pagesの設定を試みました。"
                    fi
                fi
            fi
        fi
    else
        if [ "$LANG" = "en" ]; then
            echo "⚠️  GitHub CLI is not installed."
            echo "Please create repository manually."
        else
            echo "⚠️  GitHub CLIがインストールされていません。"
            echo "手動でリポジトリを作成してください。"
        fi
    fi
fi

# =================================================
# 完了メッセージ
# =================================================

echo ""
message "complete"
echo ""
message "next_steps"

if [ "$GITHUB_MODE" = true ]; then
    if [ "$LANG" = "en" ]; then
        echo "1. Edit slides:"
        echo "   cd $WORK_DIR && code slides.md"
        echo ""
        echo "2. Commit changes:"
        echo "   git add . && git commit -m 'Update slides'"
        echo ""
        echo "3. Push to GitHub (auto-build):"
        echo "   git push"
    else
        echo "1. スライドを編集:"
        echo "   cd $WORK_DIR && code slides.md"
        echo ""
        echo "2. 変更をコミット:"
        echo "   git add . && git commit -m 'Update slides'"
        echo ""
        echo "3. GitHubにプッシュ（自動ビルドされます）:"
        echo "   git push"
    fi
else
    if [ "$LANG" = "en" ]; then
        echo "1. Edit slides:"
        echo "   cd $WORK_DIR && code slides.md"
        echo ""
        echo "2. Build locally:"
        echo "   marp slides.md -o output.pdf"
        echo ""
        echo "3. For GitHub integration later:"
        echo "   cd $WORK_DIR"
        echo "   $SCRIPT_DIR/create-presentation.sh --github --from-existing ."
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
fi

if [ "$FULL_PROJECT" = true ]; then
    echo ""
    if [ "$LANG" = "en" ]; then
        echo "📊 Full project structure:"
        echo "   - research/   : Research & Analysis"
        echo "   - ideation/   : Ideas & Structure"
        echo "   - assets/     : Images & Resources"
    else
        echo "📊 フルプロジェクト構造:"
        echo "   - research/   : 調査・分析"
        echo "   - ideation/   : アイデア・構成"
        echo "   - assets/     : 画像・リソース"
    fi
fi