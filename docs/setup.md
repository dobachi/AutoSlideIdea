# セットアップガイド

## 必要な環境

### 基本要件

- Node.js 14以上
- Git
- テキストエディタ（VSCode推奨）

### AIツール（いずれか）

- Claude Code
- Gemini CLI
- その他のAIアシスタント

## インストール手順

### 1. Marp CLIのインストール

```bash
# npmを使用
npm install -g @marp-team/marp-cli

# またはyarnを使用
yarn global add @marp-team/marp-cli

# 確認
marp --version
```

### 2. プロジェクトのセットアップ

```bash
# リポジトリのクローン
git clone https://github.com/your-username/AutoSlideIdea.git
cd AutoSlideIdea

# ディレクトリ構造の確認
ls -la
```

### 3. VSCode拡張機能（推奨）

VSCodeを使用する場合、以下の拡張機能をインストール：

1. **Marp for VS Code** - スライドのプレビュー
2. **Markdown All in One** - Markdown編集支援
3. **GitHub Copilot** - AI補完（オプション）

```bash
# コマンドラインからインストール
code --install-extension marp-team.marp-vscode
code --install-extension yzhang.markdown-all-in-one
```

### 4. AIツールのセットアップ

以下のAIツールのいずれかをセットアップ：

#### Claude Code
```bash
# Claude Codeのインストール（公式ドキュメント参照）
# https://docs.anthropic.com/claude-code/

# 設定確認
claude-code --version
```

#### Gemini CLI
```bash
# Gemini CLIのインストール（公式ドキュメント参照）
# https://cloud.google.com/gemini/docs/cli

# 設定確認
gemini --version
```

### 5. フォント設定（日本語対応）

日本語フォントが正しく表示されるように設定：

```bash
# Ubuntu/Debian
sudo apt-get install fonts-noto-cjk

# macOS（Homebrewを使用）
brew install --cask font-noto-sans-cjk
```

## 環境設定の確認

### テスト用スライドの作成

```bash
# サンプルをコピー
cp -r samples/demo-presentation test-presentation

# PDFを生成
cd test-presentation
marp slides.md -o test.pdf

# 生成されたPDFを確認
open test.pdf  # macOS
xdg-open test.pdf  # Linux
```

### トラブルシューティング

#### Marpが見つからない

```bash
# PATHの確認
echo $PATH

# npmのグローバルディレクトリを確認
npm config get prefix

# PATHに追加（.bashrcや.zshrcに記載）
export PATH="$PATH:$(npm config get prefix)/bin"
```

#### 日本語が文字化けする

1. フォントがインストールされているか確認
2. Marp設定でフォントを明示的に指定

```css
/* config/marp/base.css に追加 */
section {
  font-family: 'Noto Sans JP', 'Hiragino Kaku Gothic ProN', sans-serif;
}
```

#### PDFサイズが大きい

```bash
# 圧縮オプションを使用
marp slides.md -o output.pdf --pdf-notes --allow-local-files
```

## 次のステップ

セットアップが完了したら：

1. [ワークフロー](workflow.md)を確認
2. 新規プレゼンテーションを作成
3. AI支援でコンテンツを充実させる