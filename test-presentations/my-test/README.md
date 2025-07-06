# 基本テンプレート

このテンプレートは汎用的なプレゼンテーション用の基本構成です。

## 構成

- タイトルスライド
- アジェンダ
- はじめに
- 主要トピック（2つ）
- まとめ
- 質疑応答

## カスタマイズポイント

1. **タイトル**: `my-test` を実際のタイトルに置換
2. **日付**: `2025-07-06` を実際の日付に置換
3. **内容**: 各セクションの内容を適宜変更
4. **スライド数**: 必要に応じてスライドを追加・削除

## 使い方

```bash
# テンプレートから新規作成
../../../scripts/new-presentation.sh my-presentation basic

# 編集
cd ../../../presentations/my-presentation
code slides.md

# PDF生成
marp slides.md -o output.pdf
```