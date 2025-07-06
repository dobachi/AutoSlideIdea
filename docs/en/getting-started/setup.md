---
layout: default
title: Setup Guide
nav_order: 2
parent: English
nav_exclude: true
---

# Setup Guide

## Requirements

### Basic Requirements

- Node.js 14 or higher
- Git
- Text editor (VSCode recommended)

### AI Tools (choose one)

- Claude Code
- Gemini CLI
- Other AI assistants

## Installation Steps

### 1. Project Setup

```bash
# Clone the repository (including submodules)
git clone --recursive https://github.com/your-username/AutoSlideIdea.git
cd AutoSlideIdea

# Check directory structure
ls -la

# Add submodules to existing clone
git submodule update --init --recursive
```

### 2. Install Dependencies

```bash
# Run in project root
npm install

# Verify installation
npx marp --version
```

**Benefits**:
- No global installation required (no permission issues)
- Version management per project
- Clear dependencies in `package.json`

#### Global Installation (Optional)

For system-wide usage:

```bash
npm install -g @marp-team/marp-cli
```

### 3. VSCode Extensions (Recommended)

If using VSCode, install the following extensions:

1. **Marp for VS Code** - Slide preview
2. **Markdown All in One** - Markdown editing support
3. **GitHub Copilot** - AI completion (optional)

```bash
# Install from command line
code --install-extension marp-team.marp-vscode
code --install-extension yzhang.markdown-all-in-one
```

### 4. AI Tool Setup

Set up one of the following AI tools:

#### Claude Code
```bash
# Install Claude Code (see official documentation)
# https://docs.anthropic.com/claude-code/

# Verify setup
claude-code --version
```

#### Gemini CLI
```bash
# Install Gemini CLI (see official documentation)
# https://cloud.google.com/gemini/docs/cli

# Verify setup
gemini --version
```

### 5. Font Configuration (Japanese Support)

Configure fonts for proper Japanese display:

```bash
# Ubuntu/Debian
sudo apt-get install fonts-noto-cjk

# macOS (using Homebrew)
brew install --cask font-noto-sans-cjk
```

## Environment Verification

> 💡 **Reference**: Check out the [demo site](https://dobachi.github.io/AutoSlideIdea/) for actual output examples

### Create Test Slides

```bash
# 🎯 Recommended: Create test presentation with unified manager
./scripts/manage-presentation.sh test-presentation

# Generate PDF
cd presentations/test-presentation
npm run pdf -- slides.md -o test.pdf
# or
npx marp slides.md -o test.pdf

# View generated PDF
open test.pdf  # macOS
xdg-open test.pdf  # Linux
```

### Script Verification

```bash
# 🎯 Recommended: Check unified management script
./scripts/manage-presentation.sh --help

# Legacy scripts (automatically forwarded)
./scripts/create-presentation.sh --help
./scripts/update-presentation.sh --help
```

### Troubleshooting

#### Marp Not Found

```bash
# For local installation
npx marp --version

# Or use npm scripts
npm run marp -- --version

# Check PATH for global installation
echo $PATH
npm config get prefix
```

#### Japanese Characters Corrupted

1. Verify fonts are installed
2. Explicitly specify fonts in Marp configuration

```css
/* Add to config/marp/base.css */
section {
  font-family: 'Noto Sans JP', 'Hiragino Kaku Gothic ProN', sans-serif;
}
```

#### Large PDF Size

```bash
# Use compression options
npx marp slides.md -o output.pdf --pdf-notes --allow-local-files
```

## Next Steps

After completing setup:

1. Review the [workflow](workflow.md)
2. Create a new presentation
3. Enhance content with AI assistance