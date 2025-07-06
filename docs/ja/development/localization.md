---
layout: default
title: ローカライゼーション
nav_order: 2
parent: 開発者向け
---

# ローカライゼーション（多言語対応）ガイド

## 現状分析

### 既存の英語対応パターン
1. **AI指示書システム** (`/.ai-instructions/`)
   - 言語別ディレクトリ: `ja/`, `en/`
   - 完全な言語分離

2. **プロジェクトルート**
   - `.en.md`形式: `AI.en.md`, `CLAUDE.en.md`
   - 日本語版と同じディレクトリに配置

3. **GitHub Actionsテンプレート**
   - `multi-language.yml`: 複数言語対応済み
   - 言語別ディレクトリとファイル名形式の両方に対応

## 推奨方針

### 1. ファイル構造の統一方針

**`.en.md`形式を採用**（理由：保守性と可視性のバランス）

```
/
├── README.md         # 日本語版
├── README.en.md      # 英語版
├── docs/
│   ├── setup.md      # 日本語版
│   ├── setup.en.md   # 英語版
│   └── ...
├── templates/
│   ├── basic/
│   │   ├── README.md      # 日本語版
│   │   ├── README.en.md   # 英語版
│   │   ├── slides.md      # 日本語版
│   │   └── slides.en.md   # 英語版
│   └── ...
```

**メリット：**
- 言語版の対応関係が一目瞭然
- ファイル数が少ない場合に管理しやすい
- 既存のAI.en.mdパターンと一貫性

### 2. スクリプトの多言語対応

**環境変数 + コマンドラインオプション併用**

```bash
# 環境変数での指定
export AUTOSLIDE_LANG=en
./scripts/create-presentation.sh my-presentation

# オプションでの指定（優先）
./scripts/create-presentation.sh --lang en my-presentation

# デフォルトは日本語
./scripts/create-presentation.sh my-presentation  # ja
```

**実装例：**
```bash
# scripts/create-presentation.sh の改修
LANG="${AUTOSLIDE_LANG:-ja}"  # デフォルトは日本語

# オプション解析に追加
--lang)
    LANG="$2"
    shift 2
    ;;

# テンプレートファイル選択
if [ "$LANG" = "en" ] && [ -f "$TEMPLATE_DIR/slides.en.md" ]; then
    cp "$TEMPLATE_DIR/slides.en.md" "$WORK_DIR/slides.md"
else
    cp "$TEMPLATE_DIR/slides.md" "$WORK_DIR/slides.md"
fi
```

### 3. テンプレートの多言語化

**各テンプレートに英語版を追加**

```bash
templates/
├── basic/
│   ├── README.md
│   ├── README.en.md      # 追加
│   ├── slides.md
│   └── slides.en.md      # 追加
├── academic/
│   ├── slides.md
│   └── slides.en.md      # 追加
└── ...
```

**プレースホルダーも言語対応：**
```markdown
# 日本語版
発表者: {{PRESENTER_NAME}}
日付: {{DATE}}

# 英語版
Presenter: {{PRESENTER_NAME}}
Date: {{DATE}}
```

### 4. AI指示書システムとの連携

**CLAUDE.mdの言語切り替え**
```markdown
# CLAUDE.md に追加
## 言語設定
ユーザーが英語でコミュニケーションする場合、または`--lang en`が指定された場合：
- `.ai-instructions/instructions/en/`の指示書を使用
- 英語版テンプレート（.en.md）を優先
```

### 5. GitHub Actions の活用

**既存のmulti-language.ymlを改良**
```yaml
# .github/workflows/build-slides.yml
env:
  LANGUAGES: 'ja en'

# ビルドステップ
- name: Build presentations
  run: |
    # .en.md形式のファイルを検出してビルド
    for file in $(find . -name "slides.md" -o -name "slides.en.md"); do
      lang=$(echo $file | grep -o '\.en\.' > /dev/null && echo "en" || echo "ja")
      output_dir="dist/$lang"
      mkdir -p $output_dir
      marp $file -o $output_dir/$(basename $file .md).pdf
    done
```

## 実装優先順位

### Phase 1: 基盤整備（必須）
1. ✅ CLAUDE.en.md, AI.en.md（完了済み）
2. README.en.md の作成
3. scripts/create-presentation.sh の多言語対応

### Phase 2: ドキュメント（重要）
4. docs/*.en.md の作成
5. テンプレートのREADME.en.md

### Phase 3: テンプレート（段階的）
6. basic テンプレートの slides.en.md
7. 他のテンプレートの英語版

### Phase 4: 自動化（オプション）
8. GitHub Actions の調整
9. 言語自動検出機能

## 保守性のポイント

### 1. 翻訳の同期
- 日本語版を更新したら英語版も更新するルール
- コミットメッセージで言語版を明記
  ```
  Update setup documentation (ja/en)
  ```

### 2. テスト方法
```bash
# 英語環境でのテスト
export AUTOSLIDE_LANG=en
./scripts/create-presentation.sh test-en
```

### 3. 貢献者向けガイドライン
CONTRIBUTING.md に以下を追加：
- 新機能追加時は両言語のドキュメント更新必須
- プルリクエストテンプレートに言語チェックリスト

## 将来の拡張性

### 他言語への対応
同じパターンで他の言語も追加可能：
- `.zh.md` - 中国語
- `.es.md` - スペイン語
- `.fr.md` - フランス語

### 言語自動選択
```bash
# システムロケールから自動判定
LANG="${AUTOSLIDE_LANG:-${LANG%_*}}"
```

## まとめ

この方針により：
1. **一貫性**: 既存パターンを活かした統一的な構造
2. **保守性**: ファイルの対応関係が明確
3. **拡張性**: 将来の言語追加が容易
4. **互換性**: 既存の日本語版に影響なし

実装は段階的に進め、まずは基本的な部分（README、スクリプト）から着手することを推奨します。