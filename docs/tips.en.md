# Tips & Tricks

## AI Usage Tips

### Effective Prompts

#### Structure Generation

```text
Good example:
"Create a presentation structure for a 90-minute machine learning introductory seminar.
Target audience: Engineers with programming experience but beginners in machine learning
Content to include: Basic theory, implementation examples, hands-on
Content to avoid: Advanced mathematics, latest research papers"

Bad example:
"Make a machine learning presentation"
```

#### Content Enhancement

```text
Good example:
"Add explanations to slide 5 'Neural Network Basics' 
including the following points:
1. Simple diagram of 3 layers
2. Role of activation functions (using ReLU as example)
3. Python implementation example (within 10 lines)"

Bad example:
"Explain in more detail"
```

### Advanced Marp Features

#### Using Slide Classes

```markdown
---
marp: true
---

<!-- _class: title -->
# Title Slide

---

<!-- _class: lead -->
# Important Message

---

<!-- _class: invert -->
# Inverted Background
```

#### Two-Column Layout

```markdown
<style>
.columns {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1em;
}
</style>

<div class="columns">
<div>

## Left Column
- Point 1
- Point 2

</div>
<div>

## Right Column
```python
def example():
    pass
```

</div>
</div>
```

#### Image Placement

```markdown
# Background image
![bg](image.jpg)

# Right side placement
![bg right](image.jpg)

# Size specification
![bg right:40%](image.jpg)

# Apply filter
![bg opacity:0.3](image.jpg)
```

### Workflow Efficiency

#### Setting Aliases

```bash
# Add to ~/.bashrc or ~/.zshrc
alias marp-pdf='npx marp --pdf --allow-local-files'
alias marp-preview='npx marp --preview'
alias new-slide='~/AutoSlideIdea/scripts/create-presentation.sh'
```

#### VSCode Snippets

```json
// .vscode/markdown.code-snippets
{
  "Marp Header": {
    "prefix": "marp-header",
    "body": [
      "---",
      "marp: true",
      "theme: base",
      "paginate: true",
      "footer: '${1:Title} - ${2:Date}'",
      "---",
      "",
      "<!-- _class: title -->",
      "",
      "# ${1:Title}",
      "",
      "## ${3:Subtitle}",
      "",
      "${4:Author}",
      "${2:Date}"
    ]
  },
  "Two Column": {
    "prefix": "marp-2col",
    "body": [
      "<div class=\"columns\">",
      "<div>",
      "",
      "$1",
      "",
      "</div>",
      "<div>",
      "",
      "$2",
      "",
      "</div>",
      "</div>"
    ]
  }
}
```

### Performance Optimization

#### Image Optimization

```bash
# Image compression script
#!/bin/bash
for img in presentations/*/images/*.{jpg,png}; do
  # For JPEG
  jpegoptim --max=85 "$img"
  
  # For PNG
  optipng -o2 "$img"
done
```

#### Reduce Build Time

```yaml
# Parallel build configuration
- name: Parallel build
  run: |
    find presentations -name "*.md" -type f | \
    parallel -j 4 marp {} -o {.}.pdf
```

### Troubleshooting

#### Japanese Font Issues

```css
/* Load custom fonts */
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap');

section {
  font-family: 'Noto Sans JP', sans-serif !important;
}
```

#### Mermaid Not Displaying

```markdown
<!-- Enable Mermaid -->
<script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
<script>mermaid.initialize({ startOnLoad: true });</script>
```

### Presentation Tips

#### Presenter Notes

```markdown
---

# Slide Title

Main content

<!-- 
Presenter notes:
- Important points
- Speaking order
- Time allocation (3 minutes)
-->
```

#### Keyboard Shortcuts

- `F`: Fullscreen
- `G`: Grid view
- `P`: Presenter mode
- `B`: Blackout
- `C`: Drawing mode

### Collaboration

#### Review Comments

```markdown
<!-- TODO: Add data source for this graph -->
<!-- FIXME: Simplify technical term explanation -->
<!-- REVIEW: Check if this flow is easy to understand -->
```

#### Version Control

```bash
# Tag presentation version
git tag -a conference-v1.0 -m "○○ Conference presentation version"

# Get specific version
git checkout conference-v1.0
```

## Future Improvement Suggestions

### Short-term Improvements

1. **Template Expansion**
   - For technical meetups
   - For sales proposals
   - For research presentations

2. **Enhanced Automation**
   - Spell check
   - Proofreading
   - Time estimation

3. **Optimized AI Integration**
   - Prompt templates
   - Workflow automation

4. **Browser-based Solution**
   - GitHub Codespaces support (.devcontainer configuration)
   - No environment setup required with one click
   - Accessible from anywhere

### Long-term Vision

1. **Interactive Elements**
   - Survey features
   - Real-time Q&A
   - Participant feedback

2. **Multimedia Support**
   - Video embedding
   - Voice narration
   - Animations

3. **Analytics Features**
   - Viewing time analysis
   - Engagement measurement
   - AI-powered improvement suggestions

4. **Complete Web App**
   - In-browser editor (CodeMirror/Monaco)
   - Real-time preview
   - Cloud storage and sharing
   - PWA support (offline editing)
   - Complete in-browser execution with WebContainer API