#!/usr/bin/env bash

# AI調査設定ファイル
# このファイルはAI調査時の標準化されたディレクトリ構造とファイル名を定義します

# 必須ディレクトリ構造
export AI_RESEARCH_DIRS=(
    "raw-results"
    "analysis"
    "sources"
)

# 必須ファイル
export AI_RESEARCH_REQUIRED_FILES=(
    "metadata.json"
    "query.txt"
    "summary.md"
    "report.md"
    "sources/bibliography.json"
)

# オプショナルファイル
export AI_RESEARCH_OPTIONAL_FILES=(
    "analysis/key-findings.md"
    "analysis/data-tables.md"
    "ai-prompt.txt"
    "ai-result.txt"
)

# ファイルテンプレートパス
export AI_RESEARCH_INSTRUCTION_TEMPLATE="${SLIDEFLOW_HOME}/templates/ai-research-instruction.md"

# レポートセクション（順序を保証）
export AI_RESEARCH_REPORT_SECTIONS=(
    "エグゼクティブサマリー"
    "調査概要"
    "詳細分析"
    "データと根拠"
    "結論と推奨事項"
    "参考文献"
)

# メタデータフィールド
export AI_RESEARCH_METADATA_FIELDS=(
    "query"
    "timestamp"
    "session_id"
    "status"
    "research_type"
    "duration_seconds"
    "sources_count"
    "ai_tool"
    "language"
)

# ソース情報フィールド
export AI_RESEARCH_SOURCE_FIELDS=(
    "id"
    "title"
    "url"
    "author"
    "publication_date"
    "accessed_date"
    "type"
    "credibility"
    "summary"
)