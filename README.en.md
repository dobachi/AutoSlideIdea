# AI-Assisted Presentation Creation Guide

English | [日本語](README.md)

## Overview

This project provides a methodology and toolset for efficiently creating presentation materials using AI tools such as Claude Code and Gemini CLI.

## Key Features

- **Markdown-based slide creation**: Simple slide creation using Marp
- **AI-assisted content generation**: Generate outlines and content with Claude Code/Gemini CLI
- **AI instruction system**: Advanced AI control via submodules
- **Automated builds**: Automatic PDF generation with GitHub Actions
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
│   ├── create-presentation.sh # Unified presentation creation
│   └── build.sh              # Build script
├── config/                    # Configuration files
│   └── marp/                 # Marp settings
├── presentations/             # Created presentations
├── package.json              # npm dependencies
└── CONTRIBUTING.md           # Contribution guidelines
```

## Quick Start

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

2. **Create New Presentation**
   ```bash
   # For local work (default)
   ./scripts/create-presentation.sh my-presentation
   
   # Create as GitHub repository
   ./scripts/create-presentation.sh --github conference-2024
   
   # Full project (including research/analysis)
   ./scripts/create-presentation.sh --full research-project
   ./scripts/create-presentation.sh --github --full --public big-conference
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
# Create presentation locally
./scripts/create-presentation.sh my-local-presentation
cd presentations/my-local-presentation
# Work remains local only
```

### 2. Individual Repository Management (Sharing/CI/CD)
- Manage as independent Git repositories
- GitHub Actions auto-build support
- For team sharing or version control needs

```bash
# Create as GitHub repository from the start
./scripts/create-presentation.sh --github my-conference-2024

# Create as public repository (GitHub Pages ready)
./scripts/create-presentation.sh --github --public tech-talk-2024
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
- [Advanced Workflow](docs/advanced-workflow.en.md) - Research/analysis/ideation using AI instruction system
- [Tips & Tricks](docs/tips.en.md)

## License

Apache-2.0