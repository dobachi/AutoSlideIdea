---
layout: default
title: テーマの使い方
nav_order: 3
parent: ユーザーガイド
---

# テーマの使い方

AutoSlideIdeaでプレゼンテーションのデザインをカスタマイズする方法を説明します。

## 組み込みテーマ

### 利用可能なテーマ

1. **default** - シンプルでクリーンなデザイン
2. **gaia** - よりカラフルで現代的
3. **uncover** - エレガントでミニマル

### テーマの設定方法

```markdown
---
marp: true
theme: gaia
---

# プレゼンテーションタイトル
```

## カスタムCSSテーマ

### 基本的なカスタムテーマ

```css
/* theme/custom.css */
@import 'default';

section {
  background-color: #f8f9fa;
  color: #333;
}

h1 {
  color: #2e86ab;
  border-bottom: 3px solid #2e86ab;
  padding-bottom: 10px;
}

h2 {
  color: #666;
}

code {
  background-color: #e9ecef;
  padding: 2px 4px;
  border-radius: 3px;
}
```

### カスタムテーマの適用

```bash
# SlideFlowでの使用
./slideflow/slideflow.sh build --theme custom

# npm scriptsでの使用
npm run pdf -- presentations/my-presentation/slides.md \
  --theme theme/custom.css
```

## テーマのカスタマイズ要素

### 色とフォント

```css
section {
  /* 背景色 */
  background-color: #ffffff;
  
  /* テキスト色 */
  color: #333333;
  
  /* フォント設定 */
  font-family: 'Helvetica Neue', Arial, sans-serif;
  font-size: 28px;
  line-height: 1.5;
}
```

### 見出しのスタイル

```css
h1 {
  font-size: 2.5em;
  font-weight: bold;
  margin-bottom: 0.5em;
  text-align: center;
}

h2 {
  font-size: 1.8em;
  color: #555;
  margin-top: 1em;
}
```

### リストのスタイル

```css
ul {
  list-style-type: disc;
  padding-left: 1.5em;
}

ul li {
  margin-bottom: 0.5em;
}

/* カスタムマーカー */
ul li::marker {
  color: #2e86ab;
}
```

### コードブロックのスタイル

```css
pre {
  background-color: #f4f4f4;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 1em;
  overflow-x: auto;
}

pre code {
  background-color: transparent;
  padding: 0;
}
```

## 高度なカスタマイズ

### スライドクラスの定義

```css
/* リードスライド用 */
section.lead {
  text-align: center;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

section.lead h1 {
  font-size: 3em;
  margin-bottom: 0.3em;
}

/* 反転色スライド */
section.invert {
  background-color: #333;
  color: #fff;
}
```

使用方法：

```markdown
<!-- _class: lead -->
# 大きなタイトル
サブタイトル

---

<!-- _class: invert -->
# ダークテーマのスライド
```

### レスポンシブデザイン

```css
/* プロジェクター用（4:3） */
@media (aspect-ratio: 4/3) {
  section {
    padding: 40px;
  }
}

/* ワイドスクリーン（16:9） */
@media (aspect-ratio: 16/9) {
  section {
    padding: 60px 80px;
  }
}
```

### アニメーション

```css
/* フェードイン効果 */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

section {
  animation: fadeIn 0.5s ease-in;
}

/* スライドイン効果 */
h1 {
  animation: slideInFromLeft 0.5s ease-out;
}

@keyframes slideInFromLeft {
  from {
    transform: translateX(-100%);
  }
  to {
    transform: translateX(0);
  }
}
```

## テーマテンプレート

### ビジネス向けテーマ

```css
/* theme/business.css */
@import 'default';

:root {
  --primary-color: #003366;
  --accent-color: #ff6600;
  --bg-color: #f5f5f5;
}

section {
  background: var(--bg-color);
  padding: 60px;
}

h1 {
  color: var(--primary-color);
  font-size: 2.2em;
  margin-bottom: 0.5em;
}

strong {
  color: var(--accent-color);
}

/* グラフや図表のスタイル */
img {
  border: 1px solid #ddd;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
```

### アカデミック向けテーマ

```css
/* theme/academic.css */
@import 'default';

section {
  font-family: 'Times New Roman', serif;
  font-size: 24px;
  line-height: 1.6;
}

/* 数式のスタイル */
.katex {
  font-size: 1.1em;
}

/* 引用のスタイル */
blockquote {
  border-left: 4px solid #666;
  padding-left: 1em;
  font-style: italic;
  color: #666;
}
```

## ベストプラクティス

### 1. 一貫性の維持

- 同じプレゼンテーション内で統一感を保つ
- 色数は3-4色程度に抑える
- フォントは2-3種類まで

### 2. 可読性の確保

```css
/* 良い例 */
section {
  font-size: 28px;
  line-height: 1.5;
  color: #333;
  background: #fff;
}

/* 避けるべき例 */
section {
  font-size: 16px; /* 小さすぎる */
  line-height: 1;  /* 狭すぎる */
  color: #ccc;     /* コントラスト不足 */
}
```

### 3. プロジェクター対応

- 高コントラストを維持
- 細い線は避ける
- 明るい背景を使用

## トラブルシューティング

### テーマが適用されない

1. CSSファイルのパスを確認
2. `@import`文の構文を確認
3. Marpの設定を確認

### スタイルの競合

```css
/* 詳細度を上げて優先順位を確保 */
section.custom h1 {
  color: #2e86ab !important;
}
```

## 関連ページ

- [基本的な使い方](basic-usage/)
- [Markdown記法](markdown-syntax/)
- [エクスポート](export/)