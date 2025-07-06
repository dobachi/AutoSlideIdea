# SlideFlow - Phase 0 (Minimal MVP)

## Overview

SlideFlow is a presentation management tool that pursues the simplicity of Markdown-based formats.
This Phase 0 version is a prototype for functionality verification with minimal features.

## Installation

```bash
# 1. Clone the repository
git clone https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea/slideflow

# 2. Grant execution permissions
chmod +x slideflow.sh

# 3. Add to PATH (optional)
export PATH="$PATH:$(pwd)"
```

## Language Settings

SlideFlow supports both Japanese and English. You can specify the language using the `LANG` or `SLIDEFLOW_LANG` environment variable.

```bash
# Use in English
export LANG=en_US.UTF-8
./slideflow.sh help

# Use in Japanese (default)
export LANG=ja_JP.UTF-8
./slideflow.sh help

# Temporarily change language
LANG=en slideflow.sh help
```

## Usage

### Create a new presentation

```bash
./slideflow.sh new my-presentation
```

### Start preview server

```bash
cd ../presentations/my-presentation
../../slideflow/slideflow.sh preview
# Open http://localhost:8000 in your browser
```

### List existing presentations

```bash
# Default (presentations directory)
./slideflow.sh list

# Search specific directory
./slideflow.sh list /path/to/directory
./slideflow.sh list .
```

### List available templates

```bash
./slideflow.sh templates
```

### AI assistance

```bash
# Interactive phase support
./slideflow.sh ai

# Quick support
./slideflow.sh ai --quick tech
```

## Command List

- `new <name>` - Create a new presentation
- `preview [path]` - Preview presentation
- `ai [options] [path]` - AI assistance
- `build [format] [path]` - Build presentation
- `info [path]` - Show presentation information
- `list [path]` - List existing presentations
- `templates` - List available templates
- `instructions` - Check AI instruction system status
- `help` - Show help

## Features

### Phase 0 MVP
✅ Create presentation from template
✅ Preview server with live reload
✅ AI assistance instructions
✅ Multi-language support (Japanese/English)

## Directory Structure

```
slideflow/
├── slideflow.sh        # Main command
├── lib/                # Library files
│   ├── i18n.sh         # Internationalization support
│   ├── i18n/           # Message files
│   │   ├── ja.sh       # Japanese messages
│   │   └── en.sh       # English messages
│   ├── ai_helper.sh    # AI assistance functions
│   └── project.sh      # Project management functions
├── instructions/       # AI instruction files
├── templates/          # Presentation templates
└── README.md           # This file
```

## Requirements

- Bash 4.0 or higher
- Python 3.x (for preview server)
- Git

## License

MIT License

## Author

dobachi

## Development Documents

- [Command System Design Considerations](/docs/slideflow/COMMAND_DESIGN.md) - Detailed command design and improvement proposals (Japanese)

## Related Projects

- [AI_Instruction_Kits](https://github.com/dobachi/AI_Instruction_Kits) - AI instruction management system