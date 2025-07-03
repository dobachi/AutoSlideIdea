[English](scripts.en.md) | [日本語](scripts.md)

# Scripts Reference

## 🎯 manage-presentation.sh (Recommended)

Main script for unified management of presentation creation and updates. Executes appropriate actions through auto-detection.

### Usage

```bash
./scripts/manage-presentation.sh [options] <presentation-name>
```

### Auto-Detection Features

- **Existence Check**: Automatically detects if the specified presentation exists
- **Appropriate Processing**: Creates if new, suggests appropriate updates if existing
- **Error Avoidance**: Users don't need to be aware of existence

### Options

| Option | Description | Example |
|--------|-------------|---------|
| `--create` | Force create mode (fails if exists) | `--create` |
| `--update` | Force update mode (fails if not exists) | `--update` |
| `--template <name>` | Specify template to use | `--template academic` |
| `--full` | Include research/analysis/ideation structure | `--full` |
| `--github` | Set up as GitHub repository | `--github` |
| `--public` | Public repository (with --github) | `--public` |
| `--workflow <type>` | GitHub Actions workflow | `--workflow github-pages` |
| `--add-assets` | Add assets directory structure | `--add-assets` |
| `--add-research` | Add research/analysis/ideation structure | `--add-research` |
| `--lang <code>` | Language (ja, en) | `--lang en` |

### Template List

- `basic` - Basic presentation (default)
- `academic` - For academic presentations (background, methods, results)
- `business` - For business proposals (problem, solution, impact)
- `full-project` - Complete project structure (from research to implementation)

### Workflow Types

- `basic` - Basic PDF/HTML generation
- `full-featured` - Multi-format support, analysis tool integration
- `multi-language` - Multi-language build support
- `github-pages` - For GitHub Pages deployment

### Examples

#### Basic Usage

```bash
# Auto-detection (recommended)
./scripts/manage-presentation.sh my-talk

# GitHub integration (create if new, add if existing)
./scripts/manage-presentation.sh --github conference-2024

# Full project structure
./scripts/manage-presentation.sh --full research-project
```

#### Explicit Modes

```bash
# Force create (fails if exists)
./scripts/manage-presentation.sh --create new-presentation

# Force update (fails if not exists)
./scripts/manage-presentation.sh --update existing-presentation --workflow github-pages

# Structure extension
./scripts/manage-presentation.sh --add-assets --add-research my-project
```

#### GitHub Pages Support

```bash
# Create with GitHub Pages workflow
./scripts/manage-presentation.sh --github --workflow github-pages portfolio-2024

# Update existing presentation for GitHub Pages
./scripts/manage-presentation.sh --update --workflow github-pages existing-talk
```

> 💡 **Live Example**: Check out the [AutoSlideIdea Demo Site](https://dobachi.github.io/AutoSlideIdea/) to see GitHub Pages output

## create-presentation.sh (Deprecated)

Wrapper script maintained for compatibility. Automatically forwards to `manage-presentation.sh --create`.

### Usage

```bash
./scripts/create-presentation.sh [options] <presentation-name>
```

**⚠️ Warning**: This script is deprecated. Use `manage-presentation.sh` instead.

## update-presentation.sh (Deprecated)

Wrapper script maintained for compatibility. Automatically forwards to `manage-presentation.sh --update`.

### Usage

```bash
./scripts/update-presentation.sh [options] <presentation-name-or-path>
```

**⚠️ Warning**: This script is deprecated. Use `manage-presentation.sh` instead.

## build.sh

Helper script for building presentations.

### Usage

```bash
./scripts/build.sh <input-file> [output-file]
```

### Features

- Works as Marp wrapper
- Default output settings
- Error handling

### Examples

```bash
# Generate PDF (default)
./scripts/build.sh presentations/my-talk/slides.md

# Generate HTML
./scripts/build.sh presentations/my-talk/slides.md output.html

# With custom options
./scripts/build.sh presentations/my-talk/slides.md --theme custom.css
```

## Environment Variables

All scripts support the following environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `AUTOSLIDE_LANG` | Default language setting | `ja` |
| `AUTOSLIDE_TEMPLATE` | Default template | `basic` |

### Configuration Example

```bash
# Set English as default
export AUTOSLIDE_LANG=en

# Make permanent by adding to .bashrc or .zshrc
echo 'export AUTOSLIDE_LANG=en' >> ~/.bashrc
```

## Migration Guide

### From Legacy Scripts to Unified Script

| Legacy | Unified |
|--------|---------|
| `create-presentation.sh my-talk` | `manage-presentation.sh my-talk` |
| `create-presentation.sh --github talk` | `manage-presentation.sh --github talk` |
| `update-presentation.sh --add-github talk` | `manage-presentation.sh --github talk` |
| `update-presentation.sh --workflow github-pages talk` | `manage-presentation.sh --workflow github-pages talk` |

### Auto-Forwarding Mechanism

Legacy scripts work as follows:

1. Display deprecation warning
2. Forward to `manage-presentation.sh` with appropriate options
3. Execute the process

## Troubleshooting

### Permission Errors

```bash
# Grant execute permission to scripts
chmod +x scripts/*.sh
```

### Path Not Found

```bash
# Run from project root
cd /path/to/AutoSlideIdea
./scripts/manage-presentation.sh my-talk
```

### GitHub CLI Errors

```bash
# Check GitHub CLI installation
gh --version

# Check authentication status
gh auth status
```

### Auto-Detection Verification

```bash
# Check behavior for non-existing
./scripts/manage-presentation.sh non-existing-presentation

# Check behavior for existing (test)
mkdir -p presentations/test-existing
./scripts/manage-presentation.sh test-existing
```

## Best Practices

### 1. Utilize Unified Script

- 🎯 Prioritize using `manage-presentation.sh`
- Leverage auto-detection for simple operations
- Use explicit modes only when certainty is required

### 2. Workflow Design

```bash
# Development flow example
./scripts/manage-presentation.sh my-talk          # Create
./scripts/manage-presentation.sh --github my-talk # Add GitHub integration
./scripts/manage-presentation.sh --workflow github-pages my-talk # Pages support
```

### 3. Team Development

```bash
# Team members use unified method
./scripts/manage-presentation.sh --github --public team-presentation
```

## Customization

### Adding New Templates

1. Create new folder in `templates/` directory
2. Place necessary files (slides.md, README.md, etc.)
3. Use placeholders (`{{PRESENTATION_NAME}}`, `{{DATE}}`)

### Customizing Workflows

1. Create new YAML file in `templates/github-workflows/`
2. Becomes available via manage-presentation.sh `--workflow` option

## Related Documentation

- [Workflow Guide](workflow.en.md)
- [GitHub Pages Integration](github-pages.en.md)
- [Tips & Tricks](tips.en.md)