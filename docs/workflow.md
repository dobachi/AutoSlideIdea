# 作業フロー

## 基本的なワークフロー

### 1. プレゼンテーションの新規作成

```bash
# シンプルなプレゼンテーション作成（ローカル作業）
./scripts/new-presentation.sh my-presentation

# フルプロジェクトとして作成（調査・分析含む）
./scripts/new-presentation.sh --full research-project

# テンプレート指定
./scripts/new-presentation.sh conference-talk academic
```

**重要**: presentations/ディレクトリは`.gitignore`されているため、作成したプレゼンテーションはAutoSlideIdeaリポジトリにはプッシュされません。

#### プレゼンテーションの管理方法

1. **ローカル作業のまま**: 機密性が高い場合はそのまま作業
2. **個別リポジトリ化**: 共有やGitHub Actions連携が必要な場合

```bash
# 個別リポジトリとして設定
./scripts/setup-presentation-repo.sh --from-local presentations/my-presentation my-repo-name
```

#### フルプロジェクトの構造
```
research-project/
├── research/              # 調査フェーズ
│   ├── data/             # 生データ
│   ├── analysis/         # 分析結果
│   └── notes.md          # 調査メモ
├── ideation/             # アイデア創出
│   ├── brainstorm.md     # ブレインストーミング
│   └── drafts/           # 構成案
├── assets/               # リソース
└── slides.md             # 最終スライド
```

### 2. AI支援による構成作成

#### AIツールでの例（Claude Code、Gemini CLIなど）

```text
プロンプト例：
"技術カンファレンス向けに「AIとソフトウェア開発の未来」というテーマで
15分のプレゼンテーション構成を作成してください。
対象者は経験豊富な開発者です。"
```

#### 期待される出力

```markdown
1. タイトル＆自己紹介（1分）
2. 現状の課題（2分）
3. AIツールの進化（3分）
4. 実践例とデモ（5分）
5. 将来の展望（3分）
6. まとめ＆Q&A（1分）
```

### 3. コンテンツの作成

#### 段階的なアプローチ

1. **骨子の作成**
   ```bash
   # AIに構成を元に各スライドの骨子を作成してもらう
   "presentations/my-presentation/slides.md の各セクションに
   箇条書きでポイントを追加してください"
   ```

2. **詳細の追加**
   ```bash
   # 特定のスライドを深掘り
   "スライド4の実践例について、具体的なコード例と
   ビフォーアフターの比較を追加してください"
   ```

3. **ビジュアルの追加**
   ```bash
   # 図表やグラフの追加
   "スライド3にAIツールの進化を示すタイムラインを
   Mermaidで作成してください"
   ```

### 4. レビューと改善

#### セルフレビューのチェックリスト

- [ ] 時間配分は適切か？
- [ ] メッセージは明確か？
- [ ] 技術的な正確性は保たれているか？
- [ ] ビジュアルは効果的か？
- [ ] フローは論理的か？

#### AI支援による改善

```bash
# 全体的なレビュー
"このプレゼンテーションを見直して、
改善点を5つ提案してください"

# 特定の観点でのレビュー
"技術的な正確性の観点から、
修正が必要な箇所を指摘してください"
```

### 5. ビルドと配布

#### ローカルでのビルド

```bash
# PDF生成
marp presentations/my-presentation/slides.md \
  -o presentations/my-presentation/output.pdf \
  --theme ../config/marp/base.css

# HTML生成（プレゼンモード）
marp presentations/my-presentation/slides.md \
  -o presentations/my-presentation/index.html \
  --theme ../config/marp/base.css
```

#### GitHub Actionsでの自動ビルド

```yaml
# プッシュ時に自動的にPDFを生成
on:
  push:
    branches: [main]
    paths:
      - 'presentations/**/*.md'
```

## 高度なワークフロー

### マルチ言語対応

```bash
# 日本語版から英語版を生成
"presentations/my-presentation/slides.md を英語に翻訳して
presentations/my-presentation/slides-en.md として保存してください。
技術用語は適切に保ってください。"
```

### データ駆動型スライド

```python
# データからグラフを生成するスクリプト
import matplotlib.pyplot as plt
import pandas as pd

# データ読み込み
data = pd.read_csv('data.csv')

# グラフ生成
plt.figure(figsize=(10, 6))
plt.plot(data['date'], data['value'])
plt.savefig('presentations/my-presentation/images/graph.png')
```

### チーム協業

```bash
# ブランチ戦略
git checkout -b feature/conference-presentation
# 作業...
git add .
git commit -m "Add conference presentation draft"
git push origin feature/conference-presentation
# Pull Requestを作成
```

## ベストプラクティス

### 1. インクリメンタルな作成

- 一度にすべてを完成させない
- 小さなセクションごとに作成・レビュー
- 頻繁にプレビューで確認

### 2. バージョン管理の活用

```bash
# 意味のあるコミットメッセージ
git commit -m "Add performance comparison data to slide 5"

# タグ付けで重要なバージョンを記録
git tag -a v1.0 -m "Conference presentation version"
```

### 3. AI利用のコツ

- **具体的な指示**: 曖昧な指示より具体的な要求
- **段階的な改善**: 一度に完璧を求めない
- **コンテキストの提供**: 背景情報を十分に与える

### 4. 再利用性の向上

```bash
# 共通パーツをテンプレート化
mkdir -p templates/components
echo "# 会社紹介スライド" > templates/components/company-intro.md

# インクルード機能の活用（Marpでは直接サポートされないため、スクリプトで対応）
./scripts/build-with-includes.sh
```

## トラブルシューティング

### よくある問題と解決策

1. **スライドが長すぎる**
   - AI支援で要約: "このスライドを3つの要点に要約してください"
   - 補足資料として別スライドに移動

2. **技術的な説明が複雑**
   - 段階的な説明に分割
   - ビジュアルで補完

3. **時間内に収まらない**
   - 優先度を設定
   - デモを録画に変更