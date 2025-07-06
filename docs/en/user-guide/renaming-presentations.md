---
layout: default
title: Renaming Presentations
nav_order: 5
parent: User Guide
grand_parent: English
---

# Renaming Presentation Directories

A guide for renaming existing presentation directories.

## Why Rename?

- Project evolution requires more appropriate naming
- Standardizing naming conventions
- Version management and archiving

## Basic Renaming Steps

### 1. Simple Rename

Most common case: renaming within `presentations/`

```bash
# Navigate to presentations directory
cd presentations/

# Rename the directory
mv old-presentation-name new-presentation-name

# Verify the change
ls -la

# Test functionality
cd new-presentation-name
../../slideflow/slideflow.sh preview
```

### 2. Using Git (Recommended)

For version-controlled projects:

```bash
# Rename with Git (preserves history)
git mv presentations/old-name presentations/new-name

# Commit the change
git add -A
git commit -m "rename: old-name → new-name presentation

- Reason: More descriptive naming
- Impact: None"
```

## Important Considerations

### Internal Links

Check relative paths used within presentations:

```markdown
<!-- Image references in slides.md -->
![](images/diagram.png)
![](../shared-assets/logo.png)  <!-- Needs verification -->
```

### Build Output

Files in `output/` directory are automatically regenerated, but note:

- Old output files need manual deletion
- GitHub Pages URLs may change

### Scripts and Commands

For custom scripts:

```bash
# If paths are specified in package.json or Makefile
"scripts": {
  "build": "marp presentations/old-name/slides.md"  // Needs update
}
```

## Advanced Usage

### Moving Outside presentations/

```bash
# Move to different location
mv presentations/my-project ~/Documents/presentations/my-project

# Operate with absolute path
cd ~/Documents/presentations/my-project
/path/to/AutoSlideIdea/slideflow/slideflow.sh preview
```

### Changing Default Directory

```bash
# Temporary change with environment variable
export SLIDEFLOW_PRESENTATIONS_DIR=~/my-presentations
slideflow list  # References new location

# Persist with config file
slideflow --config presentations_dir=~/my-presentations
```

## Checklist

Before renaming:

- [ ] Relative path references in `slides.md`
- [ ] Links to `images/` and `assets/` directories
- [ ] Custom CSS and theme file paths
- [ ] Configuration files like `package.json`
- [ ] CI/CD settings (GitHub Actions, etc.)
- [ ] Documentation and README references

## Troubleshooting

### Images Not Displaying

```bash
# Check image paths
find . -name "*.md" -exec grep -l "images/" {} \;

# Fix paths as needed
```

### Not Showing in slideflow list

```bash
# Check current configuration
slideflow --show-config | grep presentations_dir

# Recheck list
slideflow list --dir /path/to/new/location
```

### Build Errors

```bash
# Clean build
rm -rf output/
slideflow build
```

## Best Practices

### Recommended Naming Conventions

```
# Good examples
2025-01-tech-conference
product-demo-v2
customer-training-basic

# Avoid
my presentation  # Avoid spaces
presentation1    # Too generic
PRESENTATION    # Avoid all caps
```

### Maintaining Directory Structure

```
new-presentation-name/
├── slides.md          # Main slides
├── images/           # Image files
├── assets/           # Other resources
├── output/           # Build output (auto-generated)
└── README.md         # Presentation description
```

### Version Control

```bash
# Version management with tags
git tag -a v1.0 -m "First presentation version"
git push origin v1.0

# Branch-based management
git checkout -b conference-2025
```

## Related Topics

- [Basic Usage](basic-usage.md)
- [Presentation Management](../reference/scripts.md#manage-presentation)
- [Tips & Tricks](../guides/tips.md)