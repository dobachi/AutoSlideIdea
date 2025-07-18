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

---

# 使用技術

- **Marp**: Markdownベースのスライド作成ツール
- **AIツール**: Claude Code/Gemini CLIによるコンテンツ生成支援  
- **GitHub Actions**: 自動ビルド・配布

---

# なぜAI支援が有効か？

## 従来の課題

- 構成を考えるのに時間がかかる
- デザインの調整に労力を費やす
- 内容の推敲に何度も手直しが必要

---

# AI支援のメリット

✅ 構成案の即座な生成  
✅ コンテンツの自動補完  
✅ 表現の改善提案  
✅ 図表の自動生成

---

# Marpの特徴

## シンプルなMarkdown記法

```markdown
# スライドタイトル
- 箇条書き1
- 箇条書き2
```

---

# Marpの強力な機能

- 🎨 カスタマイズ可能なテーマ
- 📐 数式サポート（KaTeX）
- 🖼️ 画像の柔軟な配置
- 📱 レスポンシブデザイン

---

# AI活用の実例 (1/3)

## 構成の生成

AIツールに依頼：  
*"技術発表用に10枚のスライド構成を提案"*

---

# AI活用の実例 (2/3)

## コンテンツの充実

具体的な指示：  
*"スライド3の技術的詳細を追加"*

---

# AI活用の実例 (3/3)

## ビジュアルの改善

図表の作成：  
*"アーキテクチャ図をMermaidで作成"*

---

# ワークフロー (1/2)

## 作成プロセス 前半

1. **アイデア** → AIツールに相談
2. **構成作成** → AI支援で骨組み生成
3. **Markdown記述** → シンプルな記法で執筆
4. **プレビュー** → リアルタイム確認

---

# ワークフロー (2/2)

## 作成プロセス 後半

5. **改善** → AIで内容改善
6. **出力** → PDF/HTML生成
7. **自動化** → GitHub Actions

---

# 開発環境

- **AIツール**: Claude Code / Gemini CLI
- **エディタ**: VSCode + Marp拡張機能

---

# バージョン管理

- **リポジトリ**: Git/GitHub
- **CI/CD**: GitHub Actions

---

# 出力形式

- **PDF**: プレゼン配布用
- **HTML**: Web公開用
- **PPTX**: PowerPoint互換

---

# GitHub Actions自動実行

## トリガー

- Markdownファイル変更時
- `presentations/**/*.md`パスの監視

---

# 自動化のメリット

✅ 手動ビルド不要  
✅ 常に最新版  
✅ 統一環境

---

# ビルドステップ (1/2)

1. リポジトリ取得
2. Node.js設定
3. Marp CLI導入

---

# ビルドステップ (2/2)

4. PDF変換実行
5. 成果物保存

---

# 作成時間の比較

| 方法 | 構成 | 内容 | デザイン | 合計 |
|------|------|------|----------|------|
| 従来 | 30分 | 120分 | 60分 | **210分** |
| AI支援 | 5分 | 30分 | 10分 | **45分** |

---

# 品質向上の効果

- 📊 構成の論理性：**+20%**
- 📝 内容の充実度：**+35%**
- 🎯 明確さ：**+40%**

---

# 短期的改善計画

- 🤖 AIプロンプトのテンプレート化
- 📚 スタイルライブラリの拡充
- 🔄 CI/CDパイプラインの最適化

---

# 長期的ビジョン

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

---

# 今すぐ始めよう！

```bash
git clone https://github.com/your-username/AutoSlideIdea.git
cd AutoSlideIdea
./scripts/new-presentation.sh my-first-ai-presentation
```

ご清聴ありがとうございました！