---
layout: default
title: SlideFlowコマンド設計
nav_order: 6
parent: 日本語
---

# SlideFlow コマンド体系の設計考察

作成日: 2025-07-06

## 現在のコマンド体系

### 基本構造
```
slideflow <command> [options] [path]
```

### コマンド一覧
- `new <name>` - 新しいプレゼンテーションを作成
- `preview [path]` - プレゼンテーションをプレビュー
- `ai [options] [path]` - AI支援（デフォルト：対話的フェーズ支援）
- `build [format] [path]` - プレゼンテーションをビルド
- `info [path]` - プレゼンテーション情報を表示
- `list [path]` - 作成済みプレゼンテーションを一覧表示
- `templates` - 利用可能なテンプレートを表示
- `instructions` - AI指示書システムの状況確認
- `help` - ヘルプを表示

### AIコマンドのオプション
- `ai [path]` - 対話的フェーズ支援
- `ai --quick <type> [path]` - 簡易支援（tech/business/academic）
- `ai --phase <phase> [path]` - 特定フェーズ（planning/research/design/creation/review）
- `ai --continue [path]` - 前回セッション継続

## 現状の評価

### 👍 良い点

1. **直感的なコマンド名**
   - 動詞ベースでわかりやすい（new, preview, build, list, info）
   - Gitなど既存ツールの慣習に従っている

2. **一貫したパス引数の扱い**
   - ほぼすべてのコマンドで `[path]` をオプション引数として受け付ける
   - デフォルトは現在のディレクトリ（`.`）
   - list と info の連携が良好

3. **AIコマンドの柔軟性**
   - 段階的な支援レベル（対話的/クイック/フェーズ指定）
   - オプションの組み合わせが論理的

4. **国際化対応**
   - LANG環境変数による言語切り替え
   - 日本語・英語の完全対応

## 改善提案

### 1. サブコマンド化の検討

現在のフラットな構造を、より組織的にできる可能性：

```bash
# 現在
slideflow ai --quick tech
slideflow ai --phase planning

# 提案（後方互換性を保ちつつ）
slideflow ai quick tech
slideflow ai phase planning
slideflow ai interactive  # デフォルトの対話的モード
```

### 2. グローバルオプションの追加

```bash
slideflow --lang en list          # 言語指定
slideflow --verbose build pdf      # 詳細出力
slideflow --quiet preview          # 静音モード
slideflow --config <file> new      # 設定ファイル指定
```

### 3. コマンドのグループ化

論理的にグループ化してヘルプを理解しやすくする：

```
基本操作:
  new         プレゼンテーションを作成
  list        既存プレゼンテーションを一覧表示
  info        プレゼンテーション情報を表示

開発・編集:
  preview     プレゼンテーションをプレビュー
  build       プレゼンテーションをビルド
  
AI支援:
  ai          AI支援機能

その他:
  templates   テンプレート一覧
  instructions AI指示書システム状況
  help        ヘルプ表示
```

### 4. 新しいコマンドの提案

#### プレゼンテーション管理
```bash
# 削除
slideflow remove <name>
slideflow rm <name>  # エイリアス

# コピー/移動
slideflow copy <source> <dest>
slideflow move <source> <dest>
slideflow mv <source> <dest>  # エイリアス

# 名前変更（moveのシンプル版）
slideflow rename <old> <new>
```

#### エクスポート/インポート
```bash
# アーカイブ化
slideflow export <path> --format zip
slideflow export <path> --format tar.gz

# インポート
slideflow import <archive>
```

#### 設定管理
```bash
# 設定の表示・変更
slideflow config --list
slideflow config --get <key>
slideflow config --set <key>=<value>

# 例
slideflow config --set default.template=academic
slideflow config --set preview.port=3000
```

#### バージョン管理連携
```bash
# Git連携
slideflow init --git    # Git初期化も同時に行う
slideflow commit        # 変更をコミット（コミットメッセージ自動生成）
```

### 5. パス引数の統一性向上

現在`templates`と`instructions`はパス引数を取らないが、一貫性のために：

```bash
slideflow templates [path]     # 特定ディレクトリのテンプレートを表示
slideflow instructions [path]  # 特定プロジェクトの指示書を表示
```

## 実装優先度

### 高優先度（互換性を保ちつつすぐ実装可能）
1. **グローバルオプション**
   - `--lang`, `--verbose`, `--quiet`
   - 既存の動作に影響しない

2. **removeコマンド**
   - 基本的な管理機能として必要
   - 実装が比較的簡単

3. **ヘルプのグループ化表示**
   - 視認性の向上
   - 実装が簡単

### 中優先度（将来的な拡張）
1. **copy/moveコマンド**
   - プレゼンテーション管理の利便性向上
   
2. **configコマンド**
   - カスタマイズ性の向上
   
3. **renameコマンド**
   - moveの便利なショートカット

4. **サブコマンド化**
   - 後方互換性を保ちながら段階的に実装

### 低優先度（大規模な変更）
1. **export/import機能**
   - 共有・配布機能として有用だが複雑
   
2. **バージョン管理連携**
   - Git統合は便利だが実装が複雑
   
3. **プラグインシステム**
   - 拡張性は高いが設計が必要

## 設計原則

1. **シンプルさを保つ**
   - 基本的な操作は簡単に
   - 高度な機能はオプションで

2. **後方互換性**
   - 既存のコマンドは動作を維持
   - 新機能は追加的に実装

3. **一貫性**
   - すべてのコマンドで同じパターンを使用
   - パス引数の扱いを統一

4. **発見可能性**
   - ヘルプで機能が見つけやすい
   - エラーメッセージが親切

## まとめ

現在のSlideFlowのコマンド体系は基本的に良好で、シンプルさと機能性のバランスが取れています。提案した改善は、このバランスを保ちながら、より強力で使いやすいツールへと成長させることを目的としています。

実装は優先度に従って段階的に行い、常にユーザビリティとシンプルさを重視することが重要です。