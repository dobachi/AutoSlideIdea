---
layout: default
title: Basic Usage
nav_order: 1
parent: User Guide
---

# Basic Usage

Learn the basics of creating presentations with AutoSlideIdea.

## 1. Creating a New Presentation

### Using the SlideFlow Command (Recommended)

```bash
# Create new presentation
./slideflow/slideflow.sh new my-presentation

# Specify a template
./slideflow/slideflow.sh new --template business my-company-pitch
```

### Generated File Structure

```
presentations/my-presentation/
├── slides.md         # Main slide file
├── assets/          # Images and other resources
└── output/          # Build output directory
```

## 2. Editing Slides

### Basic Markdown Syntax

```markdown
---
marp: true
theme: default
paginate: true
---

# Presentation Title

Presenter Name
July 6, 2024

---

# Section 1

- Point 1
- Point 2
- Point 3

---

# Code Example

```javascript
function greet(name) {
    return `Hello, ${name}!`;
}
```
```

### Slide Separators

- Use `---` (three hyphens) to start a new slide
- Each slide is displayed as an independent page

## 3. Preview

### Local Server Preview

```bash
# Start preview server
./slideflow/slideflow.sh preview

# Specify custom port
./slideflow/slideflow.sh preview --port 3000
```

Open `http://localhost:8000` in your browser to view the preview

### Live Reload

- Browser automatically updates when files are edited
- See changes instantly

## 4. Build and Export

### Generate HTML Files

```bash
# Generate HTML files
./slideflow/slideflow.sh build

# Output location: presentations/my-presentation/output/index.html
```

### Generate PDF Files

```bash
# Generate PDF files
npm run pdf -- presentations/my-presentation/slides.md \
  -o presentations/my-presentation/output/slides.pdf
```

## 5. Common Techniques

### Inserting Images

```markdown
![Description](assets/image.png)

<!-- Size specification -->
![width:500px](assets/diagram.png)

<!-- Center alignment -->
![center](assets/logo.png)
```

### Two-Column Layout

```markdown
<div style="display: flex;">
<div style="flex: 1;">

Left column content
- Point 1
- Point 2

</div>
<div style="flex: 1;">

Right column content
![](assets/chart.png)

</div>
</div>
```

### Emphasis and Styling

```markdown
**Bold** for emphasis
*Italic* for expression
~~Strikethrough~~

> Quote
> Multi-line quote
```

## Next Steps

- [Markdown Syntax](markdown-syntax/) - Detailed Markdown usage
- [Using Themes](themes/) - Design customization
- [Mermaid Diagrams](mermaid/) - Creating flowcharts