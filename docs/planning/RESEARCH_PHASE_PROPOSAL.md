# 調査フェーズサポート機能の提案

## 概要
プレゼンテーション作成前の調査・情報収集フェーズを体系的にサポートする機能を追加する。

## 提案する機能

### 1. 新しいコマンド: `slideflow research`

#### インタラクティブモード
```bash
# 対話的に調査を進める
slideflow research --interactive [presentation-name]

# AIと対話しながら調査
slideflow research --ai-chat [presentation-name]
```

#### ノン・インタラクティブモード
```bash
# Webから情報収集
slideflow research fetch-web "query" [presentation-name]

# ファイルから情報抽出
slideflow research extract [file-path] [presentation-name]

# 調査メモの追加
slideflow research add-note "content" [presentation-name]

# データファイルの追加
slideflow research add-data [file-path] [presentation-name]
```

### 2. ディレクトリ構造

```
presentations/my-presentation/
├── research/              # 調査フェーズのデータ
│   ├── sources/          # 情報源
│   │   ├── web/          # Web収集した情報
│   │   ├── documents/    # ドキュメント
│   │   └── data/         # データファイル
│   ├── notes/            # 調査メモ
│   │   ├── YYYY-MM-DD-001.md
│   │   └── summary.md
│   ├── ai-sessions/      # AI対話ログ
│   └── outline.md        # プレゼン構成案
├── slides.md
├── images/
└── assets/
```

### 3. AI統合機能

#### A. 情報収集AI
```bash
# Web検索と要約
slideflow research ai-search "最新のAI技術動向" --summarize

# ドキュメント分析
slideflow research ai-analyze research/documents/*.pdf

# データ分析と可視化提案
slideflow research ai-data research/sources/data/stats.csv
```

#### AI調査結果の自動保存
AIが調査を実行した場合、以下の形式で自動的に記録：

```
research/
├── ai-research/
│   ├── 2024-07-06-143022-web-search/
│   │   ├── query.txt              # 検索クエリ
│   │   ├── sources.json           # 引用元情報
│   │   ├── raw-results/           # 生データ
│   │   │   ├── source-001.md      # 各ソースの全文
│   │   │   └── source-002.md
│   │   ├── summary.md             # AI生成の要約
│   │   └── metadata.json          # タイムスタンプ、AI設定等
│   └── 2024-07-06-144515-doc-analysis/
│       ├── input-files.txt        # 分析対象ファイル一覧
│       ├── analysis.md            # 分析結果
│       └── citations.json         # 引用箇所の詳細
```

**sources.json の例：**
```json
{
  "sources": [
    {
      "id": "source-001",
      "url": "https://example.com/article",
      "title": "記事タイトル",
      "accessed_at": "2024-07-06T14:30:22Z",
      "author": "著者名",
      "published_date": "2024-07-01",
      "relevance_score": 0.92
    }
  ]
}
```

#### B. 対話型調査AI
```bash
# インタラクティブな調査セッション
slideflow research --ai-chat
> AI: どのようなテーマについて調査しますか？
> User: 生成AIのビジネス活用について
> AI: 調査の焦点を教えてください：1)導入事例 2)ROI分析 3)技術比較
> User: 1
> AI: 情報を収集します... [Web検索実行]
> AI: 5つの主要な導入事例を見つけました。要約を作成しますか？
```

### 4. 実装詳細

#### A. slideflow.shへの追加
```bash
research)
    shift
    cmd_research "$@"
    ;;
```

#### B. 新規ライブラリ: lib/research.sh
```bash
#!/bin/bash
# 調査機能のライブラリ

# インタラクティブモードの処理
research_interactive() {
    local presentation="$1"
    # 対話的な調査フローの実装
}

# AI情報収集
research_ai_fetch() {
    local query="$1"
    local presentation="$2"
    # AI APIを使った情報収集
}

# ノートの追加
research_add_note() {
    local content="$1"
    local presentation="$2"
    # タイムスタンプ付きでノート保存
}
```

### 5. 調査から発表への変換

```bash
# 調査結果からスライド構成を生成
slideflow research to-slides [presentation-name]

# 調査サマリーの生成
slideflow research summarize [presentation-name]
```

## プロジェクト固有の指示書更新

### CLAUDE.mdへの追加内容
```markdown
## 調査フェーズのサポート

プレゼンテーション作成時は、以下の調査フローをサポート：

1. **情報収集フェーズ**
   - `slideflow research`コマンドで調査開始
   - Web検索、ドキュメント分析、データ収集をサポート
   - research/ディレクトリに体系的に保存

2. **AI活用**
   - インタラクティブモード: 対話しながら調査を進める
   - ノン・インタラクティブモード: バッチ処理で情報収集
   - 情報の要約、分析、構造化を自動化

3. **AI調査結果の記録**
   - AIが調査した内容は必ずresearch/ai-research/に保存
   - 引用元URL、アクセス日時、著者情報を記録
   - 生データと要約の両方を保持
   - 再現性と透明性を確保

4. **プレゼンテーションへの変換**
   - 調査結果から自動的にスライド構成を提案
   - 重要なデータや図表の抽出
   - 引用元情報の自動挿入
```

## サブモジュールへの対応

AI指示書キット（サブモジュール）には変更を加えず、必要に応じて以下のissueを作成：

### ai_instruction_kits リポジトリへのissue案
```
Title: 調査フェーズサポートのための拡張提案

AutoSlideIdeaプロジェクトで調査フェーズのサポートを追加するにあたり、
AI指示書システムに以下の拡張があると有用です：

1. 情報収集・調査に特化した指示テンプレート
2. 調査結果の構造化に関するガイドライン
3. 調査からプレゼンテーションへの変換支援

これらは汎用的な機能として他のプロジェクトでも活用可能と考えます。
```

## AIツール向けの実装ガイドライン

### Claude Code / Cursor等でAI調査を行う場合

AIツールがプレゼンテーションのための調査を行う際は、以下の形式で記録：

1. **調査開始時**
   ```bash
   # research/ディレクトリの作成
   mkdir -p presentations/[name]/research/ai-research/
   
   # セッションディレクトリの作成
   SESSION_DIR="research/ai-research/$(date +%Y-%m-%d-%H%M%S)-[調査タイプ]"
   mkdir -p "$SESSION_DIR"/{raw-results,analysis}
   ```

2. **調査実行時**
   - Web検索した場合：URLと取得日時を記録
   - ファイル分析した場合：対象ファイルパスを記録
   - 生成した要約・分析は必ず保存

3. **記録フォーマット例**
   ```markdown
   # research/ai-research/2024-07-06-150000-web-search/summary.md
   
   ## 調査概要
   - クエリ: "生成AIのビジネス活用事例"
   - 実行日時: 2024-07-06 15:00:00
   - 使用AI: Claude 3.5 Sonnet
   
   ## 主要な発見
   1. [タイトル](URL) - アクセス日: 2024-07-06
      - 要点1
      - 要点2
   
   2. [タイトル](URL) - アクセス日: 2024-07-06
      - 要点1
      - 要点2
   
   ## 引用元一覧
   - URL1: https://example.com/article1
   - URL2: https://example.com/article2
   ```

## 実装優先順位

### Phase 1（最優先）
1. 基本的な`research`コマンドの実装
2. research/ディレクトリ構造の作成
3. ノートとデータの追加機能

### Phase 2
1. AI情報収集機能
2. インタラクティブモード
3. 調査結果の要約機能

### Phase 3
1. 調査からスライドへの自動変換
2. 高度な分析機能
3. 複数調査プロジェクトの管理