# SlideFlow AI指示書システム設計

## 概要

SlideFlowのAI支援機能で使用する指示書テンプレートの構造と内容を定義します。これらの指示書は、Claude CodeやGemini CLIなどの外部AIツールに渡され、高品質なプレゼンテーション作成を支援します。

## ディレクトリ構造

```
instructions/
└── slideflow/
    ├── situations/              # シチュエーション別指示書
    │   ├── tech-presentation.md # 技術発表
    │   ├── business-proposal.md # ビジネス提案
    │   ├── academic-research.md # 学術発表
    │   ├── workshop-tutorial.md # ワークショップ
    │   ├── product-demo.md     # 製品デモ
    │   └── lightning-talk.md   # ライトニングトーク
    │
    ├── tasks/                   # タスク別指示書
    │   ├── create-outline.md    # アウトライン作成
    │   ├── enhance-content.md   # コンテンツ改善
    │   ├── add-visuals.md      # 視覚要素追加
    │   ├── simplify.md         # 簡潔化
    │   └── translate.md        # 翻訳
    │
    └── components/              # コンポーネント別指示書
        ├── title-slide.md       # タイトルスライド
        ├── agenda.md           # アジェンダ
        ├── data-visualization.md # データ可視化
        └── conclusion.md       # まとめ
```

## 指示書テンプレート例

### 技術発表用（tech-presentation.md）

```markdown
# 技術発表用プレゼンテーション作成指示書

## 役割
あなたは技術カンファレンスや勉強会での発表を支援する専門家です。

## コンテキスト
- 対象: エンジニア、技術者
- 時間: 通常20-40分
- 目的: 技術的な知見の共有、問題解決の提案

## 構成ガイドライン

### 1. タイトルスライド
- プレゼンタイトル（キャッチー且つ技術的）
- 発表者情報（名前、所属、SNSアカウント）
- 日付とイベント名

### 2. 自己紹介（1枚）
- 簡潔に（30秒以内）
- 関連する経験や専門性

### 3. アジェンダ（1枚）
- 3-5つの主要トピック
- 予想時間配分

### 4. 背景・課題（2-3枚）
- なぜこのトピックが重要か
- 解決したい問題
- 現状の課題

### 5. 解決策・アプローチ（5-8枚）
- 技術的な詳細
- アーキテクチャ図（Mermaid推奨）
- コード例（シンタックスハイライト付き）

### 6. デモ・実装例（3-5枚）
- 実際の動作例
- パフォーマンス比較
- 実装のポイント

### 7. 結果・効果（2-3枚）
- 定量的な成果
- Before/After
- 学んだこと

### 8. まとめ・今後（1-2枚）
- 重要ポイントの再確認
- 今後の展望
- Call to Action

### 9. 参考資料（1枚）
- GitHub リポジトリ
- ブログ記事
- 関連ドキュメント

## スタイルガイド

### 文章
- 技術用語は正確に使用
- 略語は初出時に説明
- 箇条書きを活用（3-5項目）

### ビジュアル
- コードは見やすくフォーマット
- 図表にはキャプション追加
- 配色はアクセシブルに

### Marp固有
<!-- _class: title -->  # タイトルスライド用
<!-- _class: lead -->   # 強調スライド用

## 生成時の注意事項
1. 技術的正確性を最優先
2. 実践的な例を含める
3. 聴衆の技術レベルを考慮
4. 質疑応答を想定した構成
```

### ビジネス提案用（business-proposal.md）

```markdown
# ビジネス提案用プレゼンテーション作成指示書

## 役割
あなたはビジネス提案や企画プレゼンテーションを支援する専門家です。

## コンテキスト
- 対象: 経営層、意思決定者、ステークホルダー
- 時間: 通常15-30分
- 目的: 提案の承認獲得、予算確保、合意形成

## 構成ガイドライン

### 1. タイトルスライド
- 提案タイトル（明確で魅力的）
- 提案者・部署情報
- 日付

### 2. エグゼクティブサマリー（1枚）
- 提案の核心を3行で
- 期待される成果
- 必要な投資

### 3. 現状分析（2-3枚）
- 市場環境
- 競合状況
- 自社の課題

### 4. 提案内容（3-5枚）
- ソリューションの概要
- 実施計画
- 差別化ポイント

### 5. 期待効果（2-3枚）
- ROI（投資対効果）
- KPI目標
- リスクと対策

### 6. 実施スケジュール（1-2枚）
- マイルストーン
- フェーズ分け
- 重要な判断ポイント

### 7. 必要リソース（1-2枚）
- 予算
- 人員
- その他のリソース

### 8. まとめ・ネクストステップ（1枚）
- 重要ポイントの再確認
- 承認事項
- 次のアクション

## スタイルガイド

### 文章
- 結論先行型
- 数字で語る
- 専門用語は避ける

### ビジュアル
- グラフ・チャートを活用
- インフォグラフィックス
- ブランドカラーの使用

## 生成時の注意事項
1. ビジネスインパクトを明確に
2. データに基づく論理展開
3. 意思決定者の視点
4. アクションにつながる構成
```

## AI連携の実装方法

### 基本的な使用フロー

```bash
# 1. シチュエーション選択
slideflow ai --situation tech-presentation

# 2. タスク指定
slideflow ai --situation tech-presentation --task create-outline

# 3. インタラクティブモード
slideflow ai
> シチュエーションを選択してください
> タスクを選択してください
```

### コンテキスト統合

```javascript
// AI実行時のコンテキスト構築
const context = {
  // プロジェクト情報
  projectInfo: {
    name: "AI開発効率化",
    existingFiles: ["slides.md", "outline.md"],
    lastModified: "2025-01-05"
  },
  
  // 選択された指示書
  instructions: {
    situation: "tech-presentation",
    task: "create-outline",
    components: ["title-slide", "agenda"]
  },
  
  // ユーザー入力
  userInput: {
    title: "AIツールによる開発効率化",
    duration: 30,
    audience: "シニアエンジニア"
  }
};
```

### プロンプト生成例

```javascript
function generatePrompt(context) {
  return `
${loadInstruction(context.instructions.situation)}

## プロジェクト情報
- タイトル: ${context.userInput.title}
- 時間: ${context.userInput.duration}分
- 対象者: ${context.userInput.audience}

## 既存のコンテンツ
${context.projectInfo.existingFiles.map(f => `- ${f}`).join('\n')}

## タスク
${loadInstruction(context.instructions.task)}

Marp形式でスライドを生成してください。
`;
}
```

## 拡張性

### カスタム指示書の追加

```bash
# 企業固有の指示書を追加
instructions/slideflow/custom/
├── company-style-guide.md
├── compliance-rules.md
└── brand-guidelines.md
```

### プロファイル機能

```yaml
# .slideflowrc.yml
profiles:
  internal:
    defaultSituation: business-proposal
    includeInstructions:
      - custom/company-style-guide.md
      - custom/compliance-rules.md
  
  external:
    defaultSituation: tech-presentation
    excludeComponents:
      - internal-only-slides.md
```

## ベストプラクティス

1. **指示書の保守**
   - 定期的なレビューと更新
   - ユーザーフィードバックの反映
   - 成功事例の取り込み

2. **バージョン管理**
   - 指示書の変更履歴を管理
   - 後方互換性の維持
   - 変更ログの記載

3. **品質保証**
   - サンプル生成によるテスト
   - 複数のAIツールでの検証
   - ユーザーレビューの実施

---

最終更新: 2025-01-05