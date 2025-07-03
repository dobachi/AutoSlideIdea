---
marp: true
theme: base
paginate: true
footer: 'Mermaid Integration Demo - 2025'
---

<!-- _class: title -->

# Mermaid図表の統合デモ

## Marpプレゼンテーションでの図表活用

技術デモンストレーション
2025年1月

---

# アジェンダ

1. Mermaidとは？
2. フローチャート
3. シーケンス図
4. ガントチャート
5. クラス図
6. 状態遷移図
7. 円グラフ
8. まとめ

---

# Mermaidとは？

- **テキストベース**の図表作成ツール
- **バージョン管理**に適している
- **多様な図表形式**をサポート
- **自動レイアウト**で美しい図表を生成

```mermaid
graph LR
    A[テキスト] --> B[Mermaid]
    B --> C[美しい図表]
```

---

# フローチャートの例

## システムアーキテクチャ

```mermaid
graph TD
    A[ユーザー] -->|HTTPリクエスト| B[ロードバランサー]
    B --> C[Webサーバー1]
    B --> D[Webサーバー2]
    C --> E[アプリケーションサーバー]
    D --> E
    E --> F[(データベース)]
    E --> G[キャッシュサーバー]
    G --> F
```

---

# シーケンス図

## API通信フロー

```mermaid
sequenceDiagram
    participant U as ユーザー
    participant F as フロントエンド
    participant A as API Gateway
    participant S as 認証サービス
    participant D as データベース
    
    U->>F: ログインリクエスト
    F->>A: POST /auth/login
    A->>S: 認証確認
    S->>D: ユーザー情報取得
    D-->>S: ユーザーデータ
    S-->>A: トークン発行
    A-->>F: 認証トークン
    F-->>U: ログイン成功
```

---

# ガントチャート

## プロジェクトスケジュール

```mermaid
gantt
    title AIプレゼンテーションツール開発
    dateFormat  YYYY-MM-DD
    
    section 調査フェーズ
    市場調査           :done,    des1, 2025-01-01, 2025-01-07
    技術選定           :done,    des2, 2025-01-05, 2025-01-10
    
    section 開発フェーズ
    基本機能実装       :active,  dev1, 2025-01-10, 30d
    Mermaid統合        :         dev2, after dev1, 20d
    テスト             :         test, after dev2, 15d
    
    section リリース
    ドキュメント作成   :         doc,  after dev2, 10d
    デプロイ           :         dep,  after test, 5d
```

---

# クラス図

## システム設計

```mermaid
classDiagram
    class Presentation {
        -String title
        -Date created
        -List~Slide~ slides
        +render() HTML
        +export(format) File
    }
    
    class Slide {
        -String content
        -int order
        -Theme theme
        +addDiagram(Diagram)
        +getHTML() String
    }
    
    class Diagram {
        <<interface>>
        +generate() SVG
    }
    
    class MermaidDiagram {
        -String definition
        -String type
        +generate() SVG
        +validate() boolean
    }
    
    Presentation "1" --> "*" Slide
    Slide "1" --> "*" Diagram
    MermaidDiagram ..|> Diagram
```

---

# 状態遷移図

## プレゼンテーション作成フロー

```mermaid
stateDiagram-v2
    [*] --> 新規作成
    新規作成 --> 編集中: テキスト入力
    
    編集中 --> Mermaid追加: 図表挿入
    Mermaid追加 --> 編集中: 完了
    
    編集中 --> プレビュー: プレビュー表示
    プレビュー --> 編集中: 編集再開
    
    編集中 --> ビルド中: ビルド開始
    ビルド中 --> エラー: ビルド失敗
    エラー --> 編集中: 修正
    
    ビルド中 --> 完成: ビルド成功
    完成 --> 公開済み: デプロイ
    公開済み --> [*]
```

---

# 円グラフ

## 技術スタック構成

```mermaid
pie title プロジェクトの言語構成
    "JavaScript" : 45
    "Markdown" : 25
    "Shell Script" : 15
    "CSS" : 10
    "その他" : 5
```

---

# より複雑な例

## マイクロサービスアーキテクチャ

```mermaid
graph TB
    subgraph "フロントエンド層"
        WEB[Webアプリ]
        MOB[モバイルアプリ]
    end
    
    subgraph "API Gateway"
        GW[Kong/nginx]
    end
    
    subgraph "マイクロサービス"
        AUTH[認証サービス]
        USER[ユーザーサービス]
        PRES[プレゼンサービス]
        MERM[Mermaidサービス]
    end
    
    subgraph "データ層"
        RDB[(PostgreSQL)]
        CACHE[(Redis)]
        S3[(オブジェクトストレージ)]
    end
    
    WEB --> GW
    MOB --> GW
    GW --> AUTH
    GW --> USER
    GW --> PRES
    GW --> MERM
    
    AUTH --> RDB
    USER --> RDB
    PRES --> RDB
    PRES --> S3
    MERM --> CACHE
    
    style WEB fill:#e1f5fe
    style MOB fill:#e1f5fe
    style GW fill:#fff3e0
    style AUTH fill:#f3e5f5
    style USER fill:#f3e5f5
    style PRES fill:#f3e5f5
    style MERM fill:#f3e5f5
```

---

# 統合のメリット

## なぜMermaidをMarpに統合するのか？

| メリット | 説明 |
|---------|------|
| **保守性** | テキストベースで管理可能 |
| **一貫性** | スタイルの統一が容易 |
| **自動化** | CI/CDでの自動生成 |
| **協業** | レビューが簡単 |
| **更新** | 図表の更新が即座に反映 |

---

# 実装方法

## 3つのアプローチ

1. **プリプロセッシング** ✅ 推奨
   - `mermaid-cli`で事前変換
   - 最も安定した方法

2. **Krokiサービス**
   - 外部サービスでレンダリング
   - ネットワーク依存

3. **ブラウザレンダリング**
   - HTMLのみ対応
   - PDFでは使用不可

---

<!-- _class: title -->

# まとめ

## Mermaid × Marp = 🚀

- **図表とスライドの統合管理**
- **バージョン管理に優しい**
- **自動化で効率アップ**
- **美しいプレゼンテーション**

### 今すぐ始めよう！

```bash
npm install -g @mermaid-js/mermaid-cli
./scripts/preprocess-mermaid.sh slides.md
```