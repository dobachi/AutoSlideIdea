# AI調査タスク実行ガイドライン

## 重要：ディレクトリ構造の厳守

調査結果は必ず以下の構造で保存してください：

```
research/
├── ai-research/
│   └── YYYY-MM-DD-HHMMSS-{調査タイプ}/
│       ├── metadata.json          # セッションメタデータ（必須）
│       ├── query.txt             # 検索クエリ（必須）
│       ├── summary.md            # 調査サマリー（必須）
│       ├── report.md             # 詳細レポート（必須）
│       ├── raw-results/          # 生データ
│       │   ├── source-001.md     # 各ソースの全文
│       │   ├── source-002.md
│       │   └── ...
│       ├── analysis/             # 分析結果
│       │   ├── key-findings.md   # 重要な発見
│       │   ├── data-tables.md    # データテーブル
│       │   └── visualizations/   # 図表など
│       └── sources/              # ソース情報
│           └── bibliography.json # 参考文献リスト
```

## レポートフォーマット（report.md）

必ず以下の構造でレポートを作成してください：

```markdown
# 調査レポート：[調査テーマ]

## エグゼクティブサマリー
- 調査の目的
- 主要な発見（3-5点）
- 推奨事項

## 調査概要
- 調査日時：YYYY-MM-DD HH:MM:SS
- 調査手法：Web検索/ドキュメント分析/データ収集
- 検索キーワード：[使用したキーワード]
- 調査範囲：[対象期間、地域、分野など]

## 詳細分析

### 1. [セクション名]
[内容]

### 2. [セクション名]
[内容]

## データと根拠
- 収集したデータの要約
- 統計情報
- 重要な引用

## 結論と推奨事項
- 主要な結論
- 次のステップの提案
- 追加調査が必要な領域

## 参考文献
[sources/bibliography.jsonから自動生成]
```

## メタデータフォーマット（metadata.json）

```json
{
  "query": "検索クエリ",
  "timestamp": "YYYY-MM-DDTHH:MM:SS+09:00",
  "session_id": "YYYY-MM-DD-HHMMSS-{調査タイプ}",
  "status": "completed",
  "research_type": "web-search|document-analysis|data-collection",
  "duration_seconds": 120,
  "sources_count": 10,
  "ai_tool": "claude|gemini|llm|ollama",
  "language": "ja"
}
```

## 参考文献フォーマット（bibliography.json）

```json
{
  "sources": [
    {
      "id": "source-001",
      "title": "記事タイトル",
      "url": "https://example.com/article",
      "author": "著者名",
      "publication_date": "2024-07-01",
      "accessed_date": "2024-07-07",
      "type": "web|document|data",
      "credibility": "high|medium|low",
      "summary": "ソースの簡潔な要約"
    }
  ]
}
```

## 実行時の注意事項

1. **新規ディレクトリの作成禁止**：上記以外のディレクトリを作成しないでください
2. **ファイル名の統一**：指定されたファイル名を使用してください
3. **言語の一貫性**：日本語の調査は日本語で、英語の調査は英語で記述
4. **データの完全性**：すべての必須ファイルを作成してください
5. **引用の明確化**：すべての情報源を正確に記録してください