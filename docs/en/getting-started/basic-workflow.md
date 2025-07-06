---
layout: default
title: Basic Workflow
nav_order: 4
parent: English
---

# Basic Workflow

## Basic Workflow

> 💡 **Reference**: Check out the [sample presentations](../../demos/sample-presentation/) for actual output examples

### 1. Creating and Managing Presentations

🎯 **Recommended: Unified Management Script**

```bash
# Auto-detection mode (create if new, suggest update if exists)
./scripts/manage-presentation.sh my-presentation

# GitHub integration (create or update as needed)
./scripts/manage-presentation.sh --github conference-2024

# Full project (including research and analysis)
./scripts/manage-presentation.sh --full research-project

# Specify template
./scripts/manage-presentation.sh --template academic conference-talk

# Explicit modes
./scripts/manage-presentation.sh --create my-new-presentation   # Create only
./scripts/manage-presentation.sh --update existing-project     # Update only
```

📝 **Legacy Method (Deprecated)**

```bash
# Automatically forwarded to manage-presentation.sh
./scripts/create-presentation.sh my-presentation
./scripts/update-presentation.sh --add-github my-presentation
```

**Important**: The presentations/ directory is `.gitignore`d, so created presentations won't be pushed to the AutoSlideIdea repository.

#### Managing Presentations

1. **Keep as local work**: For confidential content
2. **Create as individual repository**: For sharing or GitHub Actions integration

```bash
# Create as GitHub repository (recommended)
./scripts/create-presentation.sh --github my-presentation

# Create as public repository
./scripts/create-presentation.sh --github --public my-presentation

# Create with GitHub Pages workflow
./scripts/create-presentation.sh --github --workflow github-pages my-presentation
```

#### Full Project Structure
```
research-project/
├── research/              # Research phase
│   ├── data/             # Raw data
│   ├── analysis/         # Analysis results
│   └── notes.md          # Research notes
├── ideation/             # Idea generation
│   ├── brainstorm.md     # Brainstorming
│   └── drafts/           # Structure drafts
├── assets/               # Resources
└── slides.md             # Final slides
```

### 2. Creating Structure with AI Assistance

#### Example with AI Tools (Claude Code, Gemini CLI, etc.)

```text
Example prompt:
"Create a 15-minute presentation structure on 'The Future of AI and Software Development' 
for a technical conference. The audience consists of experienced developers."
```

#### Expected Output

```markdown
1. Title & Introduction (1 min)
2. Current Challenges (2 min)
3. Evolution of AI Tools (3 min)
4. Practical Examples & Demo (5 min)
5. Future Outlook (3 min)
6. Summary & Q&A (1 min)
```

### 3. Content Creation

#### Phased Approach

1. **Create Outline**
   ```bash
   # Have AI add bullet points to each section
   "Add bullet points to each section in presentations/my-presentation/slides.md 
   based on the structure"
   ```

2. **Add Details**
   ```bash
   # Deep dive into specific slides
   "Add specific code examples and before/after comparisons 
   to the practical examples in slide 4"
   ```

3. **Add Visuals**
   ```bash
   # Add charts and graphs
   "Create a Mermaid timeline showing the evolution of AI tools 
   for slide 3"
   ```

### 4. Review and Improvement

#### Self-Review Checklist

- [ ] Is the time allocation appropriate?
- [ ] Is the message clear?
- [ ] Is it technically accurate?
- [ ] Are the visuals effective?
- [ ] Is the flow logical?

#### AI-Assisted Improvement

```bash
# Overall review
"Review this presentation and suggest 5 improvements"

# Specific aspect review
"Point out any technical inaccuracies that need correction"
```

### 5. Build and Distribution

#### Local Build

```bash
# Generate PDF
npm run pdf -- presentations/my-presentation/slides.md \
  -o presentations/my-presentation/output.pdf \
  --theme ../config/marp/base.css

# Generate HTML (presentation mode)
npm run html -- presentations/my-presentation/slides.md \
  -o presentations/my-presentation/index.html \
  --theme ../config/marp/base.css

# Preview mode
npm run preview -- presentations/my-presentation/slides.md
```

#### Automated Build with GitHub Actions

```yaml
# Automatically generate PDF on push
on:
  push:
    branches: [main]
    paths:
      - 'presentations/**/*.md'
```

### 6. Unified Management Script Details

`manage-presentation.sh` performs appropriate actions through auto-detection, but explicit options are also available.

#### Auto-Detection Behavior

```bash
# Check existence → create new or suggest update
./scripts/manage-presentation.sh my-presentation

# GitHub integration (create if new, add if existing)
./scripts/manage-presentation.sh --github existing-or-new-presentation
```

#### Explicit Operations

```bash
# Force create mode (fails if exists)
./scripts/manage-presentation.sh --create new-presentation

# Force update mode (fails if not exists)
./scripts/manage-presentation.sh --update existing-presentation --workflow github-pages

# Structure extension
./scripts/manage-presentation.sh --add-assets --add-research my-presentation
```

#### Legacy Script Compatibility

```bash
# The following are automatically forwarded to manage-presentation.sh
./scripts/update-presentation.sh --add-github my-presentation
# ↓ Actual execution
./scripts/manage-presentation.sh --update --add-github my-presentation
```

## Advanced Workflow

### Multi-language Support

```bash
# Generate English version from Japanese
"Translate presentations/my-presentation/slides.md to English 
and save as presentations/my-presentation/slides-en.md. 
Keep technical terms appropriate."
```

### Data-Driven Slides

```python
# Script to generate graphs from data
import matplotlib.pyplot as plt
import pandas as pd

# Load data
data = pd.read_csv('data.csv')

# Generate graph
plt.figure(figsize=(10, 6))
plt.plot(data['date'], data['value'])
plt.savefig('presentations/my-presentation/images/graph.png')
```

### Team Collaboration

```bash
# Branch strategy
git checkout -b feature/conference-presentation
# Work...
git add .
git commit -m "Add conference presentation draft"
git push origin feature/conference-presentation
# Create Pull Request
```

## Best Practices

### 1. Incremental Creation

- Don't try to complete everything at once
- Create and review section by section
- Frequently check with preview

### 2. Version Control Usage

```bash
# Meaningful commit messages
git commit -m "Add performance comparison data to slide 5"

# Tag important versions
git tag -a v1.0 -m "Conference presentation version"
```

### 3. AI Usage Tips

- **Specific instructions**: Specific requests over vague instructions
- **Gradual improvement**: Don't seek perfection at once
- **Provide context**: Give sufficient background information

### 4. Improve Reusability

```bash
# Create templates for common parts
mkdir -p templates/components
echo "# Company Introduction Slide" > templates/components/company-intro.md

# Use includes (not directly supported by Marp, handle with scripts)
./scripts/build-with-includes.sh
```

## Troubleshooting

### Common Issues and Solutions

1. **Slides too long**
   - AI-assisted summary: "Summarize this slide into 3 key points"
   - Move to supplementary slides

2. **Complex technical explanations**
   - Split into step-by-step explanations
   - Supplement with visuals

3. **Doesn't fit in time**
   - Set priorities
   - Change demo to recorded video