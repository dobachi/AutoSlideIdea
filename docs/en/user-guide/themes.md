---
layout: default
title: Using Themes
nav_order: 3
parent: User Guide
---

# Using Themes

Learn how to customize your presentation design in AutoSlideIdea.

## Built-in Themes

### Available Themes

1. **default** - Simple and clean design
2. **gaia** - More colorful and modern
3. **uncover** - Elegant and minimal

### How to Set a Theme

```markdown
---
marp: true
theme: gaia
---

# Presentation Title
```

## Custom CSS Themes

### Basic Custom Theme

```css
/* theme/custom.css */
@import 'default';

section {
  background-color: #f8f9fa;
  color: #333;
}

h1 {
  color: #2e86ab;
  border-bottom: 3px solid #2e86ab;
  padding-bottom: 10px;
}

h2 {
  color: #666;
}

code {
  background-color: #e9ecef;
  padding: 2px 4px;
  border-radius: 3px;
}
```

### Applying Custom Themes

```bash
# Using SlideFlow
./slideflow/slideflow.sh build --theme custom

# Using npm scripts
npm run pdf -- presentations/my-presentation/slides.md \
  --theme theme/custom.css
```

## Theme Customization Elements

### Colors and Fonts

```css
section {
  /* Background color */
  background-color: #ffffff;
  
  /* Text color */
  color: #333333;
  
  /* Font settings */
  font-family: 'Helvetica Neue', Arial, sans-serif;
  font-size: 28px;
  line-height: 1.5;
}
```

### Heading Styles

```css
h1 {
  font-size: 2.5em;
  font-weight: bold;
  margin-bottom: 0.5em;
  text-align: center;
}

h2 {
  font-size: 1.8em;
  color: #555;
  margin-top: 1em;
}
```

### List Styles

```css
ul {
  list-style-type: disc;
  padding-left: 1.5em;
}

ul li {
  margin-bottom: 0.5em;
}

/* Custom markers */
ul li::marker {
  color: #2e86ab;
}
```

### Code Block Styles

```css
pre {
  background-color: #f4f4f4;
  border: 1px solid #ddd;
  border-radius: 5px;
  padding: 1em;
  overflow-x: auto;
}

pre code {
  background-color: transparent;
  padding: 0;
}
```

## Advanced Customization

### Defining Slide Classes

```css
/* For lead slides */
section.lead {
  text-align: center;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

section.lead h1 {
  font-size: 3em;
  margin-bottom: 0.3em;
}

/* Inverted color slides */
section.invert {
  background-color: #333;
  color: #fff;
}
```

Usage:

```markdown
<!-- _class: lead -->
# Large Title
Subtitle

---

<!-- _class: invert -->
# Dark Theme Slide
```

### Responsive Design

```css
/* For projectors (4:3) */
@media (aspect-ratio: 4/3) {
  section {
    padding: 40px;
  }
}

/* For widescreen (16:9) */
@media (aspect-ratio: 16/9) {
  section {
    padding: 60px 80px;
  }
}
```

### Animations

```css
/* Fade-in effect */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

section {
  animation: fadeIn 0.5s ease-in;
}

/* Slide-in effect */
h1 {
  animation: slideInFromLeft 0.5s ease-out;
}

@keyframes slideInFromLeft {
  from {
    transform: translateX(-100%);
  }
  to {
    transform: translateX(0);
  }
}
```

## Theme Templates

### Business Theme

```css
/* theme/business.css */
@import 'default';

:root {
  --primary-color: #003366;
  --accent-color: #ff6600;
  --bg-color: #f5f5f5;
}

section {
  background: var(--bg-color);
  padding: 60px;
}

h1 {
  color: var(--primary-color);
  font-size: 2.2em;
  margin-bottom: 0.5em;
}

strong {
  color: var(--accent-color);
}

/* Charts and diagram styles */
img {
  border: 1px solid #ddd;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
```

### Academic Theme

```css
/* theme/academic.css */
@import 'default';

section {
  font-family: 'Times New Roman', serif;
  font-size: 24px;
  line-height: 1.6;
}

/* Math formula styles */
.katex {
  font-size: 1.1em;
}

/* Quote styles */
blockquote {
  border-left: 4px solid #666;
  padding-left: 1em;
  font-style: italic;
  color: #666;
}
```

## Best Practices

### 1. Maintain Consistency

- Keep a unified look within the same presentation
- Limit colors to 3-4
- Use no more than 2-3 font types

### 2. Ensure Readability

```css
/* Good example */
section {
  font-size: 28px;
  line-height: 1.5;
  color: #333;
  background: #fff;
}

/* Example to avoid */
section {
  font-size: 16px; /* Too small */
  line-height: 1;  /* Too tight */
  color: #ccc;     /* Poor contrast */
}
```

### 3. Projector Compatibility

- Maintain high contrast
- Avoid thin lines
- Use bright backgrounds

## Troubleshooting

### Theme Not Applied

1. Check CSS file path
2. Verify `@import` statement syntax
3. Check Marp configuration

### Style Conflicts

```css
/* Increase specificity for priority */
section.custom h1 {
  color: #2e86ab !important;
}
```

## Related Pages

- [Basic Usage](basic-usage/)
- [Markdown Syntax](markdown-syntax/)
- [Export](export/)