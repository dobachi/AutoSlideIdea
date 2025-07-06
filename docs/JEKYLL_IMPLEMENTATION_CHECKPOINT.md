# Jekyll実装再開用チェックポイント

## 🎯 現在の状況

### 完了済み
1. ✅ 現在のドキュメント構造の詳細分析
2. ✅ Jekyll対応計画書作成（`docs/JEKYLL_DOCUMENTATION_PLAN.md`）
3. ✅ 問題点の特定と解決策の策定

### 現在の状態
- GitHub Pagesは**静的HTML**で稼働中（Jekyll無効）
- `.nojekyll`ファイルが存在（Jekyll無効化）
- `docs/_config.yml`は削除済み
- `docs/index.html`が存在（静的HTML）

## 📋 次回作業時の実装手順

### Step 1: Jekyll有効化（5分）
```bash
# 1. Jekyll無効化ファイルを削除
rm .nojekyll
rm docs/.nojekyll

# 2. 静的HTMLファイルをバックアップ
mv docs/index.html docs/index_backup.html

# 3. 確認
git status
```

### Step 2: Jekyll設定ファイル作成（10分）
```bash
# 1. _config.yml作成
cat > docs/_config.yml << 'EOF'
# サイト設定
title: AutoSlideIdea Documentation
description: Markdownベースのシンプルなプレゼンテーション作成ツール
baseurl: ""
url: "https://dobachi.github.io/AutoSlideIdea"

# テーマ（GitHub Pages標準テーマから開始）
theme: jekyll-theme-cayman

# 言語設定
lang: ja

# プラグイン
plugins:
  - jekyll-sitemap
  - jekyll-seo-tag

# Markdown設定
markdown: kramdown
kramdown:
  syntax_highlighter: rouge
  input: GFM

# 除外ファイル
exclude:
  - "*.log"
  - "JEKYLL_*.md"
  - "planning/"
EOF

# 2. 確認
cat docs/_config.yml
```

### Step 3: 基本ディレクトリ構造作成（10分）
```bash
# 1. ディレクトリ作成
cd docs
mkdir -p _layouts _includes _data assets/css ja/quickstart en/quickstart planning

# 2. デフォルトレイアウト作成
cat > _layouts/default.html << 'EOF'
<!DOCTYPE html>
<html lang="{{ page.lang | default: site.lang | default: "ja" }}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ page.title }} - {{ site.title }}</title>
    <link rel="stylesheet" href="{{ '/assets/css/style.css' | relative_url }}">
</head>
<body>
    <header>
        <h1>{{ site.title }}</h1>
        <nav>
            <a href="{{ '/' | relative_url }}">ホーム</a>
            <a href="{{ '/ja/quickstart/' | relative_url }}">クイックスタート</a>
        </nav>
    </header>
    <main>
        {{ content }}
    </main>
    <footer>
        <p>&copy; 2024 {{ site.title }}</p>
    </footer>
</body>
</html>
EOF

# 3. 確認
ls -la _layouts/
```

### Step 4: 最初のコンテンツ作成（15分）
```bash
# 1. トップページ（日本語）
cat > index.md << 'EOF'
---
layout: default
title: ホーム
lang: ja
---

# AutoSlideIdea Documentation

Markdownベースのシンプルなプレゼンテーション作成ツール

## クイックリンク

- [クイックスタート](ja/quickstart/)
- [インストール](ja/getting-started/installation)
- [ユーザーガイド](ja/user-guide/)

## 特徴

- 📝 Markdownでスライド作成
- 🤖 AI支援機能
- 🎨 豊富なテーマ
- 📊 Mermaid図表対応
EOF

# 2. クイックスタート作成
cat > ja/quickstart/index.md << 'EOF'
---
layout: default
title: クイックスタート
lang: ja
---

# クイックスタート

5分でAutoSlideIdeaを始めよう！

## 1. インストール

```bash
git clone --recursive https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea
npm install
```

## 2. 最初のプレゼンテーション

```bash
./slideflow/slideflow.sh new my-first-presentation
```

## 3. プレビュー

```bash
./slideflow/slideflow.sh preview
```

ブラウザで http://localhost:8000 を開く
EOF

# 3. 確認
find . -name "*.md" -type f | head -10
```

### Step 5: スタイル設定（5分）
```bash
# 1. 基本スタイル作成
cat > assets/css/style.scss << 'EOF'
---
---

@import "{{ site.theme }}";

// カスタムスタイル
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
}

header {
    background: #2E86AB;
    color: white;
    padding: 1rem;
    
    h1 {
        margin: 0;
    }
    
    nav a {
        color: white;
        margin-left: 1rem;
    }
}

main {
    max-width: 800px;
    margin: 0 auto;
    padding: 2rem;
}

footer {
    text-align: center;
    padding: 2rem;
    background: #f5f5f5;
}
EOF
```

### Step 6: ローカルテスト（10分）
```bash
# 1. Jekyllインストール確認
gem install bundler jekyll

# 2. Gemfile作成
cat > Gemfile << 'EOF'
source "https://rubygems.org"
gem "jekyll", "~> 3.9"
gem "jekyll-theme-cayman"
gem "jekyll-sitemap"
gem "jekyll-seo-tag"
EOF

# 3. 依存関係インストール
bundle install

# 4. ローカルサーバー起動
bundle exec jekyll serve --source docs --destination _site

# 5. ブラウザで確認
# http://localhost:4000
```

### Step 7: コミット・プッシュ・確認（5分）
```bash
# 1. 変更をステージング
git add -A
git status

# 2. コミット
scripts/commit.sh "feat: Jekyll対応ドキュメントサイトの基盤実装"

# 3. プッシュ
git push origin main

# 4. GitHub Pages設定確認
# Settings > Pages > Source: main/docs
```

## 🔧 トラブルシューティング

### ビルドエラーが出た場合
1. `_config.yml`の構文エラーをチェック
2. YAMLのインデントを確認（スペース2個）
3. GitHub Pages対応プラグインのみ使用

### 404エラーが出た場合
1. `baseurl`設定を確認
2. リンクのパスを確認
3. ファイル名の大文字小文字を確認

### スタイルが適用されない場合
1. `assets/css/style.scss`のfront matterを確認
2. テーマ名のスペルを確認
3. ブラウザキャッシュをクリア

## 📊 進捗管理

### 残りのTODO
- [ ] Jekyll基本設定の実装
- [ ] Just the Docsテーマへの移行
- [ ] 多言語対応の実装
- [ ] 既存ドキュメントの移行
- [ ] 新規ドキュメントの作成
- [ ] ナビゲーション構造の実装
- [ ] 検索機能の追加
- [ ] 最終テストとデプロイ

### 優先順位
1. **P0**: Jekyll基本動作確認（上記Step 1-7）
2. **P1**: 既存コンテンツの移行
3. **P2**: Just the Docsテーマ導入
4. **P3**: 高度な機能実装

## 💡 ヒント

- 最初はGitHub Pages標準テーマ（Cayman）で開始
- 動作確認後にJust the Docsに移行
- 段階的に機能を追加（一度に全部やらない）
- こまめにコミット・プッシュして動作確認

---

作成日: 2025-01-06 02:42
次回作業予定: 準備完了次第実施可能