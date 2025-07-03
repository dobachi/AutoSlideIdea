# AI-Assisted Presentation Creation Guide

English | [日本語](README.md)

## Overview

This project provides a methodology and toolset for efficiently creating presentation materials using AI tools such as Claude Code and Gemini CLI.

🎯 **[View Demo Presentations](https://dobachi.github.io/AutoSlideIdea/)** - See examples of actual output

## Key Features

- **Markdown-based slide creation**: Simple slide creation using Marp
- **AI-assisted content generation**: Generate outlines and content with Claude Code/Gemini CLI
- **AI instruction system**: Advanced AI control via submodules
- **Automated builds**: Automatic PDF generation with GitHub Actions
- **GitHub Pages support**: Publish presentations as websites
- **Version control**: Change history management with Git

## Directory Structure

```
AutoSlideIdea/
├── README.md                  # Japanese README
├── README.en.md              # This file
├── AI.md                      # AI project instructions (Japanese)
├── AI.en.md                  # AI project instructions (English)
├── CLAUDE.md                  # Symbolic link for Claude Code
├── .ai-instructions/          # AI instruction system (submodule)
│   └── instructions/          # Detailed instructions
├── docs/                      # Documentation
│   ├── setup.md              # Setup guide
│   ├── workflow.md           # Workflow
│   └── tips.md               # Tips & Tricks
├── templates/                 # Template collection
│   ├── basic/                # Basic template
│   ├── academic/             # For academic presentations
│   ├── business/             # For business use
│   ├── full-project/         # Complete version with research/analysis
│   └── github-workflows/     # GitHub Actions configs
├── samples/                   # Sample slides
│   └── demo-presentation/    # Demo presentation
├── scripts/                   # Support scripts
│   ├── manage-presentation.sh # Unified presentation manager (recommended)
│   ├── create-presentation.sh # Create script (deprecated: wrapper)
│   ├── update-presentation.sh # Update script (deprecated: wrapper)
│   └── build.sh              # Build script
├── config/                    # Configuration files
│   └── marp/                 # Marp settings
├── presentations/             # Created presentations
├── package.json              # npm dependencies
└── CONTRIBUTING.md           # Contribution guidelines
```

## Quick Start

> 💡 **First, check out the [demo site](https://dobachi.github.io/AutoSlideIdea/) to see output examples**

1. **Environment Setup**
   ```bash
   # Clone repository (including submodules)
   git clone --recursive https://github.com/your-username/AutoSlideIdea.git
   cd AutoSlideIdea
   
   # Install dependencies (including Marp CLI)
   npm install
   
   # For existing clones, add submodules
   git submodule update --init --recursive
   ```

2. **Create and Manage Presentations**
   ```bash
   # 🎯 Recommended: Unified manager (auto-detection)
   ./scripts/manage-presentation.sh my-presentation
   
   # GitHub integration (create if new, add if existing)
   ./scripts/manage-presentation.sh --github conference-2024
   
   # Full project structure
   ./scripts/manage-presentation.sh --full research-project
   
   # GitHub Pages support
   ./scripts/manage-presentation.sh --github --workflow github-pages my-web-presentation
   
   # Explicit create mode (fails if exists)
   ./scripts/manage-presentation.sh --create --github new-project
   
   # Explicit update mode (fails if not exists)
   ./scripts/manage-presentation.sh --update --workflow github-pages existing-project
   ```

3. **AI-Assisted Content Creation**
   - Use AI tools (Claude Code, Gemini CLI, etc.)
   - Example prompt: "Create 5 slides about AI in presentations/my-presentation/slides.md"

4. **Build**
   ```bash
   # Generate PDF (using npm scripts)
   npm run pdf -- presentations/my-presentation/slides.md -o presentations/my-presentation/output.pdf
   
   # Or use npx
   npx marp presentations/my-presentation/slides.md -o presentations/my-presentation/output.pdf
   
   # Preview mode
   npm run preview -- presentations/my-presentation/slides.md
   ```

## Presentation Management

The presentations/ directory is excluded by `.gitignore`, allowing for two management approaches:

### 1. Local Work (Privacy-focused)
- Work directly in presentations/
- Not pushed to the AutoSlideIdea repository
- Ideal for presentations with confidential information

```bash
# Create presentation locally (legacy)
./scripts/create-presentation.sh my-local-presentation
# 🎯 Recommended:
./scripts/manage-presentation.sh my-local-presentation
cd presentations/my-local-presentation
# Work remains local only
```

### 2. Individual Repository Management (Sharing/CI/CD)
- Manage as independent Git repositories
- GitHub Actions auto-build support
- For team sharing or version control needs

```bash
# 🎯 Recommended: Unified manager (auto-detection)
./scripts/manage-presentation.sh --github my-conference-2024

# Create as public repository
./scripts/manage-presentation.sh --github --public tech-talk-2024

# Legacy method (deprecated, automatically forwarded)
./scripts/create-presentation.sh --github legacy-project
```

See [presentations/README.md](presentations/README.md) for details.

## About the AI Instruction System

This project uses the [AI Instruction System](https://github.com/dobachi/AI_Instruction_Sheet) as a submodule.

### Features

- **Systematic instruction management**: Manage project-specific instructions in `.ai-instructions/`
- **Checkpoint feature**: Automatically record work progress
- **Multi-language support**: Provides Japanese and English instructions
- **Reusable**: Use the same system in other projects

### Advanced Usage

The AI Instruction System's rich features enable advanced presentation development beyond simple slide creation:

#### Research & Analysis Phase
- Use **Data Analysis Instructions** (`basic_data_analysis.md`) to collect and analyze data for presentations
- **Python Expert Instructions** (`python_expert.md`) for data visualization and chart generation
- **Technical research**: Research latest technology trends and competitive analysis

#### Ideation Phase
- **Creative Instructions** (`basic_creative_work.md`) for brainstorming
- **Multiple perspectives**: Generate ideas by switching between different agent-type instructions
- **Structure optimization**: Explore optimal structures for target audiences

#### Content Creation Phase
- **Technical Writer Instructions** (`technical_writer.md`) to make technical content accessible
- **Code Review Instructions** (`code_reviewer.md`) to improve code example quality
- **Incremental improvements**: Manage progress at each stage with checkpoint features

This transforms presentation creation from simple "slide making" to a "comprehensive content development project."

### Customization

Project-specific instructions are defined in these files:

- `AI.md` / `AI.en.md` - AI instructions specialized for presentation creation
- `CLAUDE.md` / `CLAUDE.en.md` - For Claude Code (symbolic links to AI.md)

## Detailed Documentation

- [Setup Guide](docs/setup.en.md)
- [Workflow](docs/workflow.en.md)
- [Scripts Reference](docs/scripts-reference.en.md) - Details of create-presentation.sh, update-presentation.sh
- [GitHub Pages Integration](docs/github-pages.en.md) - Publish presentations as websites ([Demo](https://dobachi.github.io/AutoSlideIdea/))
- [Advanced Workflow](docs/advanced-workflow.en.md) - Research/analysis/ideation using AI instruction system
- [Tips & Tricks](docs/tips.en.md)

## License

Apache-2.0