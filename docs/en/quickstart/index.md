---
layout: default
title: Quick Start
nav_order: 5
---

# Quick Start

Create your first presentation in 5 minutes!

## Prerequisites

- Git installed
- Node.js 14+ installed
- Basic Markdown knowledge

## 1. Clone the Repository

```bash
git clone --recursive https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea
```

## 2. Install Dependencies

```bash
npm install
```

## 3. Create Your First Presentation

Use the SlideFlow command to create a new presentation:

```bash
./slideflow/slideflow.sh new my-first-presentation
```

This creates:
```
presentations/my-first-presentation/
├── slides.md          # Your presentation content
├── images/           # Images directory
└── assets/           # Other assets
```

## 4. Edit Your Presentation

Open `presentations/my-first-presentation/slides.md` in your favorite editor:

```markdown
---
marp: true
theme: default
---

# My First Presentation

Your Name
Date

---

# Agenda

1. Introduction
2. Main Content
3. Conclusion

---

# Introduction

- Point 1
- Point 2
- Point 3

---

# Thank You!

Questions?
```

## 5. Preview Your Presentation

```bash
# Navigate to your presentation
cd presentations/my-first-presentation

# Preview with live reload
./slideflow/slideflow.sh preview
```

Open http://localhost:8080 in your browser.

## 6. Build for Distribution

Generate PDF:
```bash
./slideflow/slideflow.sh build
```

Generate HTML:
```bash
./slideflow/slideflow.sh build --html
```

## Next Steps

### Enhance Your Presentation

1. **Add Themes**: Check out [CSS Themes](../features/css-themes/)
2. **Add Diagrams**: Learn about [Mermaid support](../features/mermaid/)
3. **Deploy Online**: See [GitHub Pages integration](../features/github-pages/)

### Learn More

- [Basic Usage Guide](../user-guide/basic-usage/) - Detailed command explanations
- [Markdown Syntax](../user-guide/markdown-syntax/) - Presentation-specific Markdown
- [Tips & Tricks](../guides/tips/) - Best practices

### Use AI Assistance

Create presentations faster with AI:

```bash
# Example with Claude Code
claude-code "Create a 10-slide presentation about Web Development Best Practices"
```

## Common Issues

### Command Not Found

```bash
# Make sure scripts are executable
chmod +x slideflow/slideflow.sh
```

### Japanese Characters Not Displaying

Install proper fonts:
```bash
# Ubuntu/Debian
sudo apt-get install fonts-noto-cjk

# macOS
brew install --cask font-noto-sans-cjk
```

## Sample Presentations

Check out our [demo presentations](../demos/) to see what's possible!

- [Basic Presentation](../../demos/sample-presentation/basic.html)
- [Business Presentation](../../demos/sample-presentation/business.html)
- [Technical Presentation](../../demos/sample-presentation/technical.html)

---

Ready to create amazing presentations? Let's get started! 🚀