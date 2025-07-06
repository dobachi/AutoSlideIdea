---
layout: default
title: Markdown Syntax
nav_order: 2
parent: User Guide
---

# Markdown Syntax

Detailed explanation of Markdown syntax available in AutoSlideIdea.

## Basic Syntax

### Headings

```markdown
# Heading 1 (Slide Title)
## Heading 2 (Subtitle)
### Heading 3
#### Heading 4
```

### Text Formatting

```markdown
**Bold**
*Italic*
***Bold Italic***
~~Strikethrough~~
`Inline code`
```

### Lists

#### Bullet Lists

```markdown
- Item 1
- Item 2
  - Sub-item 2.1
  - Sub-item 2.2
- Item 3

* Alternative syntax
+ Also works
```

#### Numbered Lists

```markdown
1. First item
2. Next item
   1. Sub-item
   2. Sub-item
3. Last item
```

### Links and Images

```markdown
# Links
[AutoSlideIdea](https://github.com/dobachi/AutoSlideIdea)

# Images
![Alt text](assets/image.png)

# Image sizing
![width:300px](assets/logo.png)
![height:200px](assets/chart.png)
![width:50%](assets/diagram.png)
```

## Code Blocks

### Basic Code Blocks

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

### Supported Languages for Syntax Highlighting

- JavaScript/TypeScript
- Python
- Java
- C/C++
- Go
- Rust
- Ruby
- PHP
- Shell/Bash
- And many more

## Tables

```markdown
| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |

# Alignment
| Left | Center | Right |
|:-----|:------:|------:|
| Left | Center | Right |
```

## Blockquotes

```markdown
> This is a blockquote
> Multi-line quotes are supported
>
> > Nested quotes
> > Work like this
```

## Math Formulas (LaTeX)

```markdown
# Inline math
$E = mc^2$

# Block math
$$
\frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$
```

## Marp Directives

### Slide Settings

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

### Background Images

```markdown
<!-- _backgroundImage: url('assets/background.jpg') -->
<!-- _backgroundColor: #f0f0f0 -->
```

### Slide-specific Classes

```markdown
<!-- _class: lead -->
# Large Title

<!-- _class: invert -->
# Inverted Color Slide
```

## Advanced Layouts

### Two-Column Layout

```markdown
<div class="columns">
<div>

## Left Content
- Point 1
- Point 2
- Point 3

</div>
<div>

## Right Content
![](assets/diagram.png)

</div>
</div>
```

### Centering

```markdown
<!-- _class: center -->
# Centered Slide

All content is centered
```

## Best Practices

### 1. Information Per Slide

- One message per slide
- 3-5 bullet points maximum
- Maintain adequate white space

### 2. Visual Hierarchy

```markdown
# Main Message

## Sub-point 1
Detailed explanation...

## Sub-point 2
Detailed explanation...
```

### 3. Code Display

- Show only essential parts
- Keep to 10-15 lines
- Use syntax highlighting

### 4. Image Usage

- Use high-resolution images
- Compress file sizes appropriately
- Always include alt text

## Troubleshooting

### Escaping Special Characters

```markdown
\# This is not a heading
\* This is not a list
\\ Backslash itself
```

### Direct HTML

```markdown
<span style="color: red;">Red text</span>
<div style="text-align: center;">Centered</div>
```

## Related Pages

- [Basic Usage](basic-usage/)
- [Using Themes](themes/)
- [Mermaid Diagrams](mermaid/)