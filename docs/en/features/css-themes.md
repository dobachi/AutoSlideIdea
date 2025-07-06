[English](css-themes.en.md) | [日本語](css-themes.md)

# CSS Theme Guide

AutoSlideIdea provides four CSS themes based on the amount of information in your slides.

## Theme List

### 1. **base.css** - Standard Theme
- **Use case**: General presentations
- **Font size**: 28px
- **Padding**: 70px
- **Features**: Well-balanced standard layout

### 2. **relaxed.css** - Relaxed Theme
- **Use case**: Slides with less information, focusing on impact
- **Font size**: 32px (+14%)
- **Padding**: 90px
- **Features**: 
  - Large, readable text
  - Generous whitespace for a premium impression
  - Ideal for slides emphasizing key messages

### 3. **demo.css** - Demo Theme
- **Use case**: Demos and technical explanations with moderate information density
- **Font size**: 24px (-14%)
- **Padding**: 50px
- **Features**:
  - Slightly tighter layout than standard
  - Suitable for slides containing code examples and diagrams

### 4. **compact.css** - Compact Theme
- **Use case**: Information-dense slides
- **Font size**: 20px (-29%)
- **Padding**: 40px
- **Features**:
  - Maximizes information per slide
  - Ideal for technical specifications and detailed tables

## Usage

### Specifying with Marp CLI

```bash
# Standard theme
marp slides.md --theme config/marp/base.css

# Relaxed theme
marp slides.md --theme config/marp/relaxed.css

# Demo theme
marp slides.md --theme config/marp/demo.css

# Compact theme
marp slides.md --theme config/marp/compact.css
```

### Specifying in Front Matter

```markdown
---
marp: true
theme: ./config/marp/compact.css
---

# Presentation Title
```

## Selection Guidelines

| Slide Content | Recommended Theme | Points per Slide (Approx.) |
|---------------|-------------------|---------------------------|
| Key messages, vision | relaxed | 1-3 points |
| General explanations, overview | base | 3-5 points |
| Technical explanations, demos | demo | 5-8 points |
| Detailed specifications, data tables | compact | 8+ points |

## Customization

Each theme inherits from base.css using `@import 'base'`, allowing for partial customization as needed.

```css
/* my-custom.css */
@import 'demo';  /* Based on demo theme */

/* Adjust specific elements only */
h1 {
  color: #e74c3c;  /* Change headings to red */
}
```

## Notes

- The same theme is applied when exporting to PDF
- Image and graph sizes are not automatically adjusted; please resize individually as needed
- Themes with smaller font sizes (compact) may be difficult to read when projected