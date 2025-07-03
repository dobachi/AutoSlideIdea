---
marp: true
theme: base
paginate: true
footer: 'AI支援プレゼン作成デモ - 2025-07-03'
---

<!-- _class: title -->

# AI支援プレゼンテーション作成

## Marp + AIツールで効率的なスライド作成

作成日: 2025-07-03

---

# このプレゼンテーションについて

## 目的

AIツールを活用した効率的なプレゼンテーション作成方法の実演

## 使用技術

- **Marp**: Markdownベースのスライド作成ツール
- **AIツール**: Claude Code/Gemini CLIによるコンテンツ生成支援
- **GitHub Actions**: 自動ビルド・配布

---

# なぜAI支援が有効か？

## 従来の課題

- 構成を考えるのに時間がかかる
- デザインの調整に労力を費やす
- 内容の推敲に何度も手直しが必要

## AI支援のメリット

✅ 構成案の即座な生成
✅ コンテンツの自動補完
✅ 表現の改善提案
✅ 図表の自動生成

---

# Marpの特徴

## シンプルさ

```markdown
---
marp: true
theme: default
---

# スライドタイトル

- 箇条書き1
- 箇条書き2
```

## 強力な機能

- 🎨 カスタマイズ可能なテーマ
- 📐 数式サポート（KaTeX）
- 🖼️ 画像の柔軟な配置
- 📱 レスポンシブデザイン

---

# AI活用の実例

## 1. 構成の生成

```bash
# AIツールでの例
"技術発表用に10枚のスライド構成を提案してください"
```

## 2. コンテンツの充実

```bash
# 各スライドの内容を具体化
"スライド3の技術的詳細を追加してください"
```

## 3. ビジュアルの改善

```bash
# 図表やコード例の追加
"アーキテクチャ図をMermaidで作成してください"
```

---

# ワークフロー

```mermaid
graph LR
    A[アイデア] --> B[AI支援で構成作成]
    B --> C[Markdownで記述]
    C --> D[Marpでプレビュー]
    D --> E[AI支援で改善]
    E --> F[PDF出力]
    F --> G[GitHub Actionsで自動化]
```

---

# 実装例：システム構成図

```mermaid
graph TB
    subgraph "開発環境"
        A[AIツール\n(Claude Code/Gemini CLI)]
        B[VSCode + Marp拡張]
    end
    
    subgraph "バージョン管理"
        C[Git/GitHub]
        D[GitHub Actions]
    end
    
    subgraph "出力"
        E[PDF]
        F[HTML]
        G[PPTX]
    end
    
    A --> B
    B --> C
    C --> D
    D --> E
    D --> F
    D --> G
```

---

# コード例：自動ビルド設定

```yaml
# .github/workflows/build-slides.yml
name: Build Slides

on:
  push:
    paths:
      - 'presentations/**/*.md'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install -g @marp-team/marp-cli
      - run: marp presentations/**/*.md --pdf
      - uses: actions/upload-artifact@v3
        with:
          name: slides
          path: presentations/**/*.pdf
```

---

# 効果の実例

## 作成時間の比較

| 方法 | 構成 | コンテンツ | デザイン | 合計 |
|------|------|------------|----------|------|
| 従来 | 30分 | 2時間 | 1時間 | **3.5時間** |
| AI支援 | 5分 | 30分 | 10分 | **45分** |

## 品質向上

- 📊 構成の論理性：20%向上
- 📝 内容の充実度：35%向上
- 🎯 メッセージの明確さ：40%向上

---

# 今後の展望

## 短期的改善

- 🤖 AIプロンプトのテンプレート化
- 📚 スタイルライブラリの拡充
- 🔄 CI/CDパイプラインの最適化

## 長期的ビジョン

- 🎤 音声からの自動スライド生成
- 🌐 多言語対応の自動化
- 📊 データビジュアライゼーションの高度化

---

<!-- _class: title -->

# まとめ

## AI支援で変わるプレゼン作成

- **効率化**: 作成時間を75%削減
- **品質向上**: より論理的で充実した内容
- **継続改善**: バージョン管理で進化

### 今すぐ始めよう！

```bash
git clone https://github.com/your-username/AutoSlideIdea.git
cd AutoSlideIdea
./scripts/new-presentation.sh my-first-ai-presentation
```