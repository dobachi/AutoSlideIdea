---
layout: default
title: Markdown記法
nav_order: 2
parent: ユーザーガイド
---

# Markdown記法

AutoSlideIdeaで使用できるMarkdown記法を詳しく説明します。

## 基本的な記法

### 見出し

```markdown
# 見出し1（スライドタイトル）
## 見出し2（サブタイトル）
### 見出し3
#### 見出し4
```

### テキストの装飾

```markdown
**太字**
*斜体*
***太字斜体***
~~取り消し線~~
`インラインコード`
```

### リスト

#### 箇条書きリスト

```markdown
- 項目1
- 項目2
  - サブ項目2.1
  - サブ項目2.2
- 項目3

* 別の書き方
+ これも使える
```

#### 番号付きリスト

```markdown
1. 最初の項目
2. 次の項目
   1. サブ項目
   2. サブ項目
3. 最後の項目
```

### リンクと画像

```markdown
# リンク
[AutoSlideIdea](https://github.com/dobachi/AutoSlideIdea)

# 画像
![代替テキスト](assets/image.png)

# 画像のサイズ指定
![width:300px](assets/logo.png)
![height:200px](assets/chart.png)
![width:50%](assets/diagram.png)
```

## コードブロック

### 基本的なコードブロック

````markdown
```javascript
function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}
```

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```
````

### シンタックスハイライト対応言語

- JavaScript/TypeScript
- Python
- Java
- C/C++
- Go
- Rust
- Ruby
- PHP
- Shell/Bash
- その他多数

## 表（テーブル）

```markdown
| ヘッダー1 | ヘッダー2 | ヘッダー3 |
|----------|----------|----------|
| セル1    | セル2    | セル3    |
| セル4    | セル5    | セル6    |

# 配置の指定
| 左寄せ | 中央 | 右寄せ |
|:------|:----:|------:|
| 左    | 中央 | 右    |
```

## 引用

```markdown
> これは引用文です
> 複数行にわたる引用も可能です
>
> > ネストした引用
> > こんな感じで使えます
```

## 数式（LaTeX）

```markdown
# インライン数式
$E = mc^2$

# ブロック数式
$$
\frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$
```

## Marpディレクティブ

### スライドの設定

```markdown
---
marp: true
theme: default
paginate: true
size: 16:9
header: 'AutoSlideIdea Demo'
footer: '© 2024'
---
```

### 背景画像

```markdown
<!-- _backgroundImage: url('assets/background.jpg') -->
<!-- _backgroundColor: #f0f0f0 -->
```

### スライド単位のクラス

```markdown
<!-- _class: lead -->
# 大きなタイトル

<!-- _class: invert -->
# 反転色のスライド
```

## 高度なレイアウト

### 2カラムレイアウト

```markdown
<div class="columns">
<div>

## 左側のコンテンツ
- ポイント1
- ポイント2
- ポイント3

</div>
<div>

## 右側のコンテンツ
![](assets/diagram.png)

</div>
</div>
```

### センタリング

```markdown
<!-- _class: center -->
# 中央揃えのスライド

すべてのコンテンツが中央に配置されます
```

## ベストプラクティス

### 1. スライドあたりの情報量

- 1スライド1メッセージ
- 箇条書きは3-5項目まで
- 適切な余白を確保

### 2. 視覚的な階層

```markdown
# メインメッセージ

## サブポイント1
詳細な説明...

## サブポイント2
詳細な説明...
```

### 3. コードの表示

- 重要な部分のみを表示
- 行数は10-15行程度まで
- シンタックスハイライトを活用

### 4. 画像の使用

- 高解像度の画像を使用
- ファイルサイズは適切に圧縮
- 代替テキストを必ず記述

## トラブルシューティング

### 特殊文字のエスケープ

```markdown
\# これは見出しではない
\* これはリストではない
\\ バックスラッシュ自体
```

### HTMLの直接記述

```markdown
<span style="color: red;">赤色のテキスト</span>
<div style="text-align: center;">中央揃え</div>
```

## 関連ページ

- [基本的な使い方](basic-usage/)
- [テーマの使い方](themes/)
- [Mermaid図表](mermaid/)