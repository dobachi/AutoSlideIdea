#!/bin/bash

# プレゼンテーション統合管理スクリプト
# 新規作成と既存更新を自動判定して処理

set -e

# デフォルト値
TEMPLATE="basic"
FULL_PROJECT=false
GITHUB_MODE=false
VISIBILITY="private"
LANG="ja"
WORKFLOW_TYPE="basic"
FORCE_MODE=""
ADD_ASSETS=false
ADD_RESEARCH=false
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
        "error_exists_use_update")
            [ "$LANG" = "en" ] && echo "⚠️  '$2' already exists. Use --update to modify it." || echo "⚠️  '$2' は既に存在します。--update を使用して変更してください。"
            ;;
        "error_not_exists_use_create")
            [ "$LANG" = "en" ] && echo "⚠️  '$2' does not exist. Creating new presentation..." || echo "⚠️  '$2' が存在しません。新規プレゼンテーションを作成中..."
            ;;
        "mode_create")
            [ "$LANG" = "en" ] && echo "📝 Creating new presentation..." || echo "📝 新規プレゼンテーションを作成中..."
            ;;
        "mode_update")
            [ "$LANG" = "en" ] && echo "🔄 Updating existing presentation..." || echo "🔄 既存プレゼンテーションを更新中..."
            ;;
        "auto_detected_create")
            [ "$LANG" = "en" ] && echo "🔍 Auto-detected: Creating new presentation" || echo "🔍 自動判定: 新規プレゼンテーション作成"
            ;;
        "auto_detected_update")
            [ "$LANG" = "en" ] && echo "🔍 Auto-detected: Updating existing presentation" || echo "🔍 自動判定: 既存プレゼンテーション更新"
            ;;
        "complete")
            [ "$LANG" = "en" ] && echo "✅ Operation completed successfully!" || echo "✅ 操作が完了しました！"
            ;;
        "template_not_found")
            [ "$LANG" = "en" ] && echo "Error: Template '$2' not found." || echo "エラー: テンプレート '$2' が見つかりません。"
            ;;
        "github_setup")
            [ "$LANG" = "en" ] && echo "🔧 Setting up GitHub integration..." || echo "🔧 GitHub連携を設定中..."
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
    esac
}

# 使い方表示
usage() {
    if [ "$LANG" = "en" ]; then
        echo "Usage: $0 [options] <presentation-name>"
        echo ""
        echo "Auto-detects whether to create new or update existing presentation."
        echo ""
        echo "Options:"
        echo "  --create              - Force create mode (fail if exists)"
        echo "  --update              - Force update mode (fail if not exists)"
        echo "  --template <name>     - Template (basic, academic, business, full-project)"
        echo "  --full                - Include research/analysis/ideation structure"
        echo "  --github              - Set up GitHub repository"
        echo "  --public              - Public repository (when using --github)"
        echo "  --workflow <type>     - GitHub Actions workflow (basic, full-featured, github-pages)"
        echo "  --add-assets          - Add assets directory"
        echo "  --add-research        - Add research/analysis structure"
        echo "  --lang <code>         - Language (ja, en)"
        echo ""
        echo "Examples:"
        echo "  # Auto-detect mode (recommended)"
        echo "  $0 my-presentation                     # Creates if new, suggests update if exists"
        echo "  $0 --github existing-presentation      # Adds GitHub to existing or creates with GitHub"
        echo ""
        echo "  # Explicit modes"
        echo "  $0 --create --github new-presentation  # Force create mode"
        echo "  $0 --update --workflow github-pages my-presentation  # Force update mode"
    else
        echo "使い方: $0 [オプション] <プレゼンテーション名>"
        echo ""
        echo "新規作成か既存更新かを自動判定して処理します。"
        echo ""
        echo "オプション:"
        echo "  --create              - 強制作成モード（既存の場合は失敗）"
        echo "  --update              - 強制更新モード（存在しない場合は失敗）"
        echo "  --template <name>     - テンプレート (basic, academic, business, full-project)"
        echo "  --full                - 調査・分析・アイデア創出を含む構造"
        echo "  --github              - GitHubリポジトリとして設定"
        echo "  --public              - パブリックリポジトリ（--github使用時）"
        echo "  --workflow <type>     - GitHub Actionsワークフロー (basic, full-featured, github-pages)"
        echo "  --add-assets          - アセットディレクトリを追加"
        echo "  --add-research        - 調査・分析構造を追加"
        echo "  --lang <code>         - 言語指定（ja, en）"
        echo ""
        echo "例:"
        echo "  # 自動判定モード（推奨）"
        echo "  $0 my-presentation                     # 新規なら作成、既存なら更新提案"
        echo "  $0 --github existing-presentation      # 既存にGitHub追加または GitHub付きで新規作成"
        echo ""
        echo "  # 明示的モード"
        echo "  $0 --create --github new-presentation  # 強制作成モード"
        echo "  $0 --update --workflow github-pages my-presentation  # 強制更新モード"
    fi
    echo ""
    exit 1
}

# オプション解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --create)
            FORCE_MODE="create"
            shift
            ;;
        --update)
            FORCE_MODE="update"
            shift
            ;;
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
            ADD_RESEARCH=true
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
        --add-assets)
            ADD_ASSETS=true
            shift
            ;;
        --add-research)
            ADD_RESEARCH=true
            shift
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

# 作業ディレクトリの決定
if [[ "$PRESENTATION_NAME" = /* ]]; then
    # 絶対パス
    WORK_DIR="$PRESENTATION_NAME"
elif [[ "$PRESENTATION_NAME" = ./* ]] || [[ "$PRESENTATION_NAME" = ../* ]]; then
    # 相対パス
    WORK_DIR="$(cd "$(dirname "$PRESENTATION_NAME")" && pwd)/$(basename "$PRESENTATION_NAME")"
else
    # プレゼンテーション名として扱う
    WORK_DIR="$PROJECT_ROOT/presentations/$PRESENTATION_NAME"
fi

# モード決定ロジック
OPERATION_MODE=""
if [ "$FORCE_MODE" = "create" ]; then
    if [ -d "$WORK_DIR" ]; then
        msg "error_exists_use_update" "$WORK_DIR"
        exit 1
    fi
    OPERATION_MODE="create"
    msg "mode_create"
elif [ "$FORCE_MODE" = "update" ]; then
    if [ ! -d "$WORK_DIR" ]; then
        msg "error_not_exists_use_create" "$WORK_DIR"
        exit 1
    fi
    OPERATION_MODE="update"
    msg "mode_update"
else
    # 自動判定
    if [ -d "$WORK_DIR" ]; then
        OPERATION_MODE="update"
        msg "auto_detected_update"
    else
        OPERATION_MODE="create"
        msg "auto_detected_create"
    fi
fi

# =================================================
# 作成モード
# =================================================
if [ "$OPERATION_MODE" = "create" ]; then
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
        find "$WORK_DIR" -name "*.en.md" | while read enfile; do
            basefile="${enfile%.en.md}.md"
            if [ -f "$basefile" ]; then
                mv "$enfile" "$basefile"
            fi
        done
    else
        find "$WORK_DIR" -name "*.en.md" -delete
    fi
    
    # プレースホルダー置換
    find "$WORK_DIR" -type f \( -name "*.md" -o -name "*.yml" \) | while read file; do
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/{{PRESENTATION_NAME}}/$(basename "$WORK_DIR")/g" "$file"
            sed -i '' "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$file"
        else
            sed -i "s/{{PRESENTATION_NAME}}/$(basename "$WORK_DIR")/g" "$file"
            sed -i "s/{{DATE}}/$(date +%Y-%m-%d)/g" "$file"
        fi
    done
fi

# =================================================
# 共通処理：GitHub設定、構造追加など
# =================================================
cd "$WORK_DIR"

# GitHub連携設定
if [ "$GITHUB_MODE" = true ]; then
    msg "github_setup"
    
    if [ ! -d .git ]; then
        git init
    fi
    
    # GitHub Actions設定
    mkdir -p .github/workflows
    if [ "$WORKFLOW_TYPE" = "github-pages" ]; then
        cp "$PROJECT_ROOT/templates/github-workflows/github-pages.yml" .github/workflows/github-pages.yml
        [ -f .github/workflows/build-slides.yml ] && rm .github/workflows/build-slides.yml
    else
        cp "$PROJECT_ROOT/templates/github-workflows/${WORKFLOW_TYPE}.yml" .github/workflows/build-slides.yml
        [ -f .github/workflows/github-pages.yml ] && rm .github/workflows/github-pages.yml
    fi
    
    # .gitignore作成
    if [ ! -f .gitignore ]; then
        cat > .gitignore << 'EOF'
# 出力ファイル
output/
dist/
*.pdf
*.pptx
*.html

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
    fi
    
    # コミット
    git add .
    if [ "$OPERATION_MODE" = "create" ]; then
        git commit -m "Initial commit: Create $(basename "$WORK_DIR")

- Created with AutoSlideIdea framework
- Template: $TEMPLATE
- GitHub Actions: $WORKFLOW_TYPE workflow"
    else
        git commit -m "Update: Add GitHub integration

- Workflow: $WORKFLOW_TYPE
- Updated with manage-presentation.sh"
    fi
    
    # GitHubリポジトリ作成（対話的）
    if command -v gh &> /dev/null; then
        echo ""
        msg "github_confirm"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            if [ "$VISIBILITY" = "public" ]; then
                gh repo create "$(basename "$WORK_DIR")" --public --source=. --remote=origin --push
            else
                gh repo create "$(basename "$WORK_DIR")" --private --source=. --remote=origin --push
            fi
            
            msg "github_created"
            echo "   URL: https://github.com/$(gh api user -q .login)/$(basename "$WORK_DIR")"
            
            # GitHub Pages設定
            if [ "$VISIBILITY" = "public" ] || [ "$WORKFLOW_TYPE" = "github-pages" ]; then
                echo ""
                msg "github_pages_confirm"
                read -r response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    if [ "$WORKFLOW_TYPE" = "github-pages" ]; then
                        if [ "$LANG" = "en" ]; then
                            echo "GitHub Pages will be automatically configured after the first workflow run."
                            echo "Your presentation will be available at:"
                            echo "https://$(gh api user -q .login).github.io/$(basename "$WORK_DIR")/"
                        else
                            echo "GitHub Pagesは最初のワークフロー実行後に自動的に設定されます。"
                            echo "プレゼンテーションは以下のURLで公開されます："
                            echo "https://$(gh api user -q .login).github.io/$(basename "$WORK_DIR")/"
                        fi
                    fi
                fi
            fi
        fi
    fi
fi

# アセット構造追加
if [ "$ADD_ASSETS" = true ]; then
    mkdir -p assets/{images,styles,fonts,data}
    touch assets/images/.gitkeep
    touch assets/styles/.gitkeep
    touch assets/fonts/.gitkeep
    touch assets/data/.gitkeep
    
    if [ -d .git ]; then
        git add assets/
        git commit -m "Add assets directory structure"
    fi
fi

# 調査構造追加
if [ "$ADD_RESEARCH" = true ]; then
    mkdir -p research/{sources,analysis,data}
    mkdir -p ideation/{brainstorm,structure,references}
    
    if [ ! -f research/README.md ]; then
        if [ "$LANG" = "en" ]; then
            cat > research/README.md << 'EOF'
# Research Materials

This directory contains research materials for the presentation.

## Structure
- `sources/` - Reference materials and sources
- `analysis/` - Analysis results and insights
- `data/` - Raw data and datasets
EOF
        else
            cat > research/README.md << 'EOF'
# 調査資料

このディレクトリにはプレゼンテーションの調査資料が含まれています。

## 構成
- `sources/` - 参考資料とソース
- `analysis/` - 分析結果と洞察
- `data/` - 生データとデータセット
EOF
        fi
    fi
    
    if [ -d .git ]; then
        git add research/ ideation/
        git commit -m "Add research and ideation structure"
    fi
fi

# =================================================
# 完了メッセージ
# =================================================
msg "complete"

if [ "$OPERATION_MODE" = "create" ]; then
    echo ""
    if [ "$LANG" = "en" ]; then
        echo "📁 Created: $WORK_DIR"
        echo ""
        echo "Next steps:"
        echo "1. Edit slides: cd $(basename "$WORK_DIR") && code slides.md"
        echo "2. Build: npx marp slides.md -o output.pdf"
    else
        echo "📁 作成場所: $WORK_DIR"
        echo ""
        echo "次のステップ:"
        echo "1. スライドを編集: cd $(basename "$WORK_DIR") && code slides.md"
        echo "2. ビルド: npx marp slides.md -o output.pdf"
    fi
else
    echo ""
    if [ "$LANG" = "en" ]; then
        echo "📁 Updated: $WORK_DIR"
        echo ""
        echo "Changes applied. Check your presentation directory for new features."
    else
        echo "📁 更新場所: $WORK_DIR"
        echo ""
        echo "変更が適用されました。プレゼンテーションディレクトリで新機能を確認してください。"
    fi
fi