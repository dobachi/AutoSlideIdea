[English](tips.en.md) | 日本語

# Tips & Tricks

## AI活用のコツ

### 効果的なプロンプト

#### 構成生成

```text
良い例：
"機械学習入門セミナー（90分）のプレゼン構成を作成してください。
対象：プログラミング経験はあるが機械学習は初心者のエンジニア
含めるべき内容：基礎理論、実装例、ハンズオン
避けるべき内容：高度な数学、最新の研究論文"

悪い例：
"機械学習のプレゼンを作って"
```

#### コンテンツ充実

```text
良い例：
"スライド5の「ニューラルネットワークの基礎」について、
以下の点を含めて説明を追加してください：
1. 3層のシンプルな図解
2. 活性化関数の役割（ReLUを例に）
3. Pythonでの実装例（10行以内）"

悪い例：
"もっと詳しく説明して"
```

### Marpの高度な機能

#### スライドクラスの活用

```markdown
---
marp: true
---

<!-- _class: title -->
# タイトルスライド

---

<!-- _class: lead -->
# 強調したいメッセージ

---

<!-- _class: invert -->
# 背景を反転
```

#### 2カラムレイアウト

```markdown
<style>
.columns {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1em;
}
</style>

<div class="columns">
<div>

## 左カラム
- ポイント1
- ポイント2

</div>
<div>

## 右カラム
```python
def example():
    pass
```

</div>
</div>
```

#### 画像の配置

```markdown
# 背景画像
![bg](image.jpg)

# 右側配置
![bg right](image.jpg)

# サイズ指定
![bg right:40%](image.jpg)

# フィルター適用
![bg opacity:0.3](image.jpg)
```

### 作業効率化

#### エイリアスの設定

```bash
# ~/.bashrc または ~/.zshrc に追加
alias marp-pdf='npx marp --pdf --allow-local-files'
alias marp-preview='npx marp --preview'
alias new-slide='~/AutoSlideIdea/scripts/create-presentation.sh'
```

#### VSCodeスニペット

```json
// .vscode/markdown.code-snippets
{
  "Marp Header": {
    "prefix": "marp-header",
    "body": [
      "---",
      "marp: true",
      "theme: base",
      "paginate: true",
      "footer: '${1:Title} - ${2:Date}'",
      "---",
      "",
      "<!-- _class: title -->",
      "",
      "# ${1:Title}",
      "",
      "## ${3:Subtitle}",
      "",
      "${4:Author}",
      "${2:Date}"
    ]
  },
  "Two Column": {
    "prefix": "marp-2col",
    "body": [
      "<div class=\"columns\">",
      "<div>",
      "",
      "$1",
      "",
      "</div>",
      "<div>",
      "",
      "$2",
      "",
      "</div>",
      "</div>"
    ]
  }
}
```

### パフォーマンス最適化

#### 画像の最適化

```bash
# 画像圧縮スクリプト
#!/bin/bash
for img in presentations/*/images/*.{jpg,png}; do
  # JPEGの場合
  jpegoptim --max=85 "$img"
  
  # PNGの場合
  optipng -o2 "$img"
done
```

#### ビルド時間の短縮

```yaml
# 並列ビルド設定
- name: Parallel build
  run: |
    find presentations -name "*.md" -type f | \
    parallel -j 4 marp {} -o {.}.pdf
```

### トラブルシューティング

#### 日本語フォントの問題

```css
/* カスタムフォント読み込み */
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap');

section {
  font-family: 'Noto Sans JP', sans-serif !important;
}
```

#### Mermaidが表示されない

Mermaidの統合については、専用のガイドを参照してください：
- [Mermaid統合ガイド](./mermaid-integration.md)
- [プリプロセッシングスクリプト](../scripts/preprocess-mermaid.sh)
- [デモプレゼンテーション](../samples/mermaid-demo/)

簡易的な対処法（HTMLエクスポートのみ）：
```markdown
<!-- Mermaid有効化 -->
<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
<script>mermaid.initialize({ startOnLoad: true });</script>
```

### 発表時のTips

#### プレゼンターノート

```markdown
---

# スライドタイトル

本文

<!-- 
プレゼンターノート：
- 重要なポイント
- 話す順序
- 時間配分（3分）
-->
```

#### キーボードショートカット

- `F`: フルスクリーン
- `G`: グリッド表示
- `P`: プレゼンターモード
- `B`: ブラックアウト
- `C`: 描画モード

### 共同作業

#### レビューコメント

```markdown
<!-- TODO: このグラフのデータソースを追加 -->
<!-- FIXME: 技術用語の説明を簡潔に -->
<!-- REVIEW: この流れで理解しやすいか確認 -->
```

#### バージョン管理

```bash
# 発表バージョンをタグ付け
git tag -a conference-v1.0 -m "○○カンファレンス発表版"

# 特定バージョンの取得
git checkout conference-v1.0
```

## 今後の改善提案

### 短期的改善

1. **テンプレートの拡充**
   - 技術勉強会用
   - 営業提案用
   - 研究発表用

2. **自動化の強化**
   - スペルチェック
   - 文章校正
   - 時間見積もり

3. **AI連携の最適化**
   - プロンプトテンプレート
   - ワークフロー自動化

4. **ブラウザベース化**
   - GitHub Codespaces対応（.devcontainer設定）
   - ワンクリックで環境構築不要
   - どこからでもアクセス可能

### 長期的ビジョン

1. **インタラクティブ要素**
   - アンケート機能
   - リアルタイムQ&A
   - 参加者フィードバック

2. **マルチメディア対応**
   - 動画埋め込み
   - 音声ナレーション
   - アニメーション

3. **分析機能**
   - 視聴時間分析
   - エンゲージメント測定
   - 改善提案AI

4. **完全なWebアプリ化**
   - ブラウザ内エディタ（CodeMirror/Monaco）
   - リアルタイムプレビュー
   - クラウド保存・共有機能
   - PWA対応（オフライン編集）
   - WebContainer APIでの完全なブラウザ内実行