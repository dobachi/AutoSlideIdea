#!/bin/bash

# プレゼンテーションを個別Gitリポジトリとして設定するスクリプト

set -e

# 使い方表示
usage() {
    echo "使い方: $0 [オプション] <リポジトリ名>"
    echo ""
    echo "オプション:"
    echo "  --from-local <dir>  - 既存のローカルディレクトリから作成"
    echo "  --private          - プライベートリポジトリとして作成（デフォルト）"
    echo "  --public           - パブリックリポジトリとして作成"
    echo "  --no-github        - GitHubリポジトリを作成しない（ローカルのみ）"
    echo ""
    echo "例:"
    echo "  $0 my-conference-2024"
    echo "  $0 --from-local presentations/my-talk my-talk-repo"
    echo "  $0 --public tech-conference-2024"
    exit 1
}

# デフォルト値
VISIBILITY="private"
CREATE_GITHUB=true
FROM_LOCAL=""
SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

# オプション解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --from-local)
            FROM_LOCAL="$2"
            shift 2
            ;;
        --private)
            VISIBILITY="private"
            shift
            ;;
        --public)
            VISIBILITY="public"
            shift
            ;;
        --no-github)
            CREATE_GITHUB=false
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            REPO_NAME="$1"
            shift
            ;;
    esac
done

# リポジトリ名チェック
if [ -z "$REPO_NAME" ]; then
    echo "エラー: リポジトリ名を指定してください。"
    usage
fi

# 作業ディレクトリ設定
if [ -n "$FROM_LOCAL" ]; then
    # 既存ディレクトリから作成
    if [[ "$FROM_LOCAL" = /* ]]; then
        SOURCE_DIR="$FROM_LOCAL"
    else
        SOURCE_DIR="$PROJECT_ROOT/$FROM_LOCAL"
    fi
    
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "エラー: ディレクトリ '$SOURCE_DIR' が見つかりません。"
        exit 1
    fi
    
    WORK_DIR="$SOURCE_DIR"
else
    # 新規作成
    WORK_DIR="$PROJECT_ROOT/presentations/$REPO_NAME"
    
    if [ -d "$WORK_DIR" ]; then
        echo "エラー: ディレクトリ '$WORK_DIR' は既に存在します。"
        exit 1
    fi
    
    # 基本テンプレートで新規作成
    echo "新規プレゼンテーションを作成中..."
    "$SCRIPT_DIR/new-presentation.sh" "$REPO_NAME"
fi

cd "$WORK_DIR"

# Gitリポジトリ初期化
if [ ! -d .git ]; then
    echo "Gitリポジトリを初期化中..."
    git init
fi

# GitHub Actions ワークフローをコピー
echo "GitHub Actions設定をコピー中..."
mkdir -p .github/workflows
cp "$PROJECT_ROOT/templates/github-workflows/basic.yml" .github/workflows/build-slides.yml

# .gitignore作成
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'EOF'
# 出力ファイル
output/
dist/
*.pdf
*.pptx
*.html

# 大容量データファイル
research/data/*.csv
research/data/*.xlsx
research/data/*.json
research/data/*.db
# 分析結果は追跡
!research/analysis/*.png
!research/analysis/*.jpg
!research/analysis/*.svg

# エディタ設定
.vscode/
.idea/
*.swp
*~

# OS固有
.DS_Store
Thumbs.db

# 一時ファイル
*.tmp
*.temp
*.bak
.~lock.*
EOF
fi

# README.md作成（存在しない場合）
if [ ! -f README.md ]; then
    cat > README.md << EOF
# $REPO_NAME

このリポジトリは[AutoSlideIdea](https://github.com/dobachi/AutoSlideIdea)フレームワークを使用して作成されたプレゼンテーションです。

## ビルド方法

\`\`\`bash
# ローカルでビルド
marp slides.md -o output.pdf

# GitHub Actionsでの自動ビルド
# mainブランチへのpush時に自動実行されます
\`\`\`

## ディレクトリ構成

- \`slides.md\` - メインのプレゼンテーションファイル
- \`research/\` - 調査データと分析結果（フルプロジェクトの場合）
- \`ideation/\` - アイデアとドラフト（フルプロジェクトの場合）
- \`assets/\` - 画像やその他のリソース

## ライセンス

[適切なライセンスを選択してください]
EOF
fi

# 初期コミット
if [ -z "$(git status --porcelain)" ]; then
    echo "変更がないため、コミットをスキップします。"
else
    echo "初期コミットを作成中..."
    git add .
    git commit -m "Initial commit with AutoSlideIdea framework

- プレゼンテーションテンプレート
- GitHub Actions設定
- 基本的なディレクトリ構造"
fi

# GitHubリポジトリ作成
if [ "$CREATE_GITHUB" = true ]; then
    if command -v gh &> /dev/null; then
        echo "GitHubリポジトリを作成中..."
        
        # リポジトリ作成
        if [ "$VISIBILITY" = "public" ]; then
            gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
        else
            gh repo create "$REPO_NAME" --private --source=. --remote=origin --push
        fi
        
        echo "✅ GitHubリポジトリを作成しました: https://github.com/$(gh api user -q .login)/$REPO_NAME"
        
        # GitHub Pages設定（パブリックリポジトリの場合）
        if [ "$VISIBILITY" = "public" ]; then
            echo "GitHub Pagesを有効化しますか？ (y/N)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                gh api repos/:owner/:repo/pages -f source='{"branch":"gh-pages","path":"/"}'
                echo "GitHub Pagesが有効化されました。"
            fi
        fi
    else
        echo "⚠️  GitHub CLIがインストールされていません。"
        echo "手動でリポジトリを作成し、以下のコマンドでプッシュしてください："
        echo ""
        echo "git remote add origin git@github.com:YOUR_USERNAME/$REPO_NAME.git"
        echo "git push -u origin main"
    fi
fi

echo ""
echo "✅ セットアップが完了しました！"
echo ""
echo "作業ディレクトリ: $WORK_DIR"
echo ""
echo "次のステップ:"
echo "1. プレゼンテーションを編集:"
echo "   cd $WORK_DIR && code slides.md"
echo ""
echo "2. 変更をコミット:"
echo "   git add . && git commit -m 'Update slides'"
echo ""
echo "3. GitHubにプッシュ（自動ビルドが実行されます）:"
echo "   git push"