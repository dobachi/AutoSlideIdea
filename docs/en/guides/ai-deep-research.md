---
layout: default
title: AI Deep Research Guide
nav_order: 4
parent: Guides
grand_parent: English
---

# AI Deep Research Guide

## Overview

SlideFlow's AI Deep Research feature (`ai deep-research`) is a specialized tool focused on the research phase of presentation creation. It provides integrated support for web search, document analysis, and information organization.

## Basic Usage

### 1. Initialize Research Environment

Initialize the research environment within your presentation directory:

```bash
cd presentations/my-presentation
slideflow ai deep-research init
```

This creates the following directory structure:

```
research/
├── sources/          # Information sources
│   ├── web/         # Web collection
│   ├── documents/   # Documents
│   └── data/        # Data files
├── notes/           # Research notes
├── ai-research/     # AI research results
└── analysis/        # Analysis results
```

### 2. AI Web Search

#### Interactive Mode (Default)

```bash
slideflow ai deep-research search "latest trends in generative AI"
```

Claude Code launches interactively, allowing you to monitor and guide the research process.

#### Automatic Mode

```bash
slideflow ai deep-research search --auto "machine learning algorithms"
```

Executes search and save operations automatically in the background.

#### Timeout Settings

```bash
# 10-minute (600 seconds) timeout for detailed research
slideflow ai deep-research search -t 600 "deep learning applications"

# Combining multiple options
slideflow ai deep-research search --auto -t 900 "large language models"
```

### 3. Document Analysis

Analyze PDFs, text files, and other documents:

```bash
slideflow ai deep-research analyze research-paper.pdf
slideflow ai deep-research analyze technical-spec.docx
```

### 4. Research Information Management

#### Adding Notes

```bash
slideflow ai deep-research add-note "GPT-4 features: multimodal support, 128k tokens"
```

#### Recording Source Information

```bash
slideflow ai deep-research add-source "https://openai.com/research/gpt-4"
slideflow ai deep-research add-source "/path/to/local/document.pdf" document
```

#### Viewing Research Content

```bash
# List research content
slideflow ai deep-research list

# Display summary
slideflow ai deep-research summary
```

## Advanced Usage

### AI Tool Priority

AI Deep Research attempts to use AI tools in the following order:

1. Claude Code
2. Gemini
3. llm (generic LLM command)
4. Ollama
5. Continue
6. aider
7. GitHub Copilot

Available tools are automatically detected and the optimal one is used.

### Research Session Management

Each research session is managed in the following format:

```
ai-research/
└── 2025-01-07-143025-web-search/
    ├── query.txt        # Search query
    ├── metadata.json    # Session information
    ├── summary.md       # Research results
    └── raw-results/     # Raw data
```

### Integration with Presentations

Research results can be directly utilized in presentation creation:

```bash
# Research phase
slideflow ai deep-research search "presentation topic"

# Review research results
slideflow ai deep-research summary

# Move to presentation creation phase
slideflow ai --phase creation
# → Create slides while referencing research results
```

## Best Practices

### 1. Systematic Research Flow

```bash
# 1. Initialize
slideflow ai deep-research init

# 2. Broad research
slideflow ai deep-research search "topic overview"

# 3. Detailed research
slideflow ai deep-research search -t 900 "specific technical details"

# 4. Document analysis
slideflow ai deep-research analyze important-paper.pdf

# 5. Record important information
slideflow ai deep-research add-note "key points"
slideflow ai deep-research add-source "https://source.url"

# 6. Review summary
slideflow ai deep-research summary
```

### 2. Leveraging Interactive Mode

- Default interactive mode allows you to monitor AI operations
- You can provide additional instructions as needed
- Research direction can be adjusted mid-process

### 3. Appropriate Timeout Settings

- Simple research: Default (300 seconds)
- Detailed research: 600-900 seconds
- Comprehensive research: 1200+ seconds

### 4. Utilizing Research Results

Research results are stored in a structured format in the `research/` directory:
- Easy to reference later
- Shareable with team members
- Can be directly cited during presentation creation

## Troubleshooting

### When Claude Code Doesn't Work

1. Verify Claude Code is installed
2. Other AI tools (Gemini, llm, etc.) will be used automatically

### Timeout Errors

```bash
# Extend timeout
slideflow ai deep-research search -t 1200 "complex topic"
```

### Directory Errors

```bash
# Execute within presentation directory
cd presentations/my-presentation
slideflow ai deep-research init
```

## Related Commands

- `slideflow ai` - Comprehensive AI assistance
- `slideflow ai --phase research` - General research phase assistance
- `slideflow new` - Create new presentation