[English](github-pages.en.md) | [日本語](github-pages.md)

# GitHub Pages Integration Guide

## Overview

AutoSlideIdea provides seamless integration with GitHub Pages to publish your presentations as websites. This allows anyone to access your presentations simply by sharing a URL.

🎯 **[View Demo Site](https://dobachi.github.io/AutoSlideIdea/)** - See actual GitHub Pages output examples

## Key Features

- **Automatic Deployment**: Automatically updates the website when pushing to the main branch
- **Beautiful Gallery**: Displays multiple presentations in an organized layout
- **Search & Filter**: Filter presentations by tags or search keywords
- **Responsive Design**: Works on PCs, tablets, and smartphones
- **Dark Mode Support**: Automatically switches based on system preferences

## Setup Guide

### 1. Create New with GitHub Pages Workflow

The easiest way is to use the `create-presentation.sh` script with the GitHub Pages workflow:

```bash
# Create a GitHub Pages-enabled presentation
./scripts/create-presentation.sh --github --workflow github-pages my-portfolio

# Create as a public repository (recommended)
./scripts/create-presentation.sh --github --public --workflow github-pages conference-2024
```

This command automatically configures:
- GitHub Actions workflow (`.github/workflows/github-pages.yml`)
- Required permissions
- Build and deployment automation

### 2. Add to Existing Presentation

To add GitHub Pages functionality to an existing presentation repository:

1. **Copy the workflow file**
   ```bash
   cp templates/github-workflows/github-pages.yml .github/workflows/
   ```

2. **Commit and push**
   ```bash
   git add .github/workflows/github-pages.yml
   git commit -m "Add GitHub Pages workflow"
   git push origin main
   ```

3. **Enable GitHub Pages**
   - Go to repository Settings → Pages
   - Set Source to "GitHub Actions"

### 3. Initial Deployment

After pushing, GitHub Actions will run automatically:

1. **Check Progress**
   - Check progress in the repository's Actions tab
   - First deployment may take 5-10 minutes

2. **Access URL**
   ```
   https://[username].github.io/[repository-name]/
   ```

## Managing Presentations

### Directory Structure

The GitHub Pages workflow assumes the following structure:

```
your-presentation/
├── slides.md              # Main presentation
├── additional-talk.md     # Additional presentations (optional)
├── assets/               # Images and resources
│   ├── images/
│   └── styles/
└── .github/
    └── workflows/
        └── github-pages.yml
```

### Managing Multiple Presentations

You can manage multiple presentations in one repository:

```
repository/
├── slides.md              # Main presentation
├── workshop/
│   └── hands-on.md       # Workshop materials
├── lightning-talks/
│   ├── intro.md          # 5-minute talk
│   └── advanced.md       # Detailed version
└── assets/               # Shared resources
```

All `.md` files are automatically converted to HTML/PDF and displayed in the gallery.

## Customization

### Customizing the Index Page

To customize the default index page:

1. **Copy the template**
   ```bash
   cp templates/github-pages/index-template.html index-template.html
   ```

2. **Edit placeholders**
   - `{{TITLE}}`: Site title
   - `{{DESCRIPTION}}`: Site description
   - `{{HEADER_TITLE}}`: Header title
   - Modify other text as needed

3. **Update workflow**
   Modify the workflow to use your custom template

### Presentation Metadata

Add metadata to each presentation to enrich the gallery display:

```markdown
---
title: Presentation Creation in the AI Era
author: John Doe
date: 2024-01-15
tags: [AI, Automation, Marp]
description: Efficient presentation creation using AI tools
---

# Slide Title
```

## Troubleshooting

### Build Failures

1. **Check Actions Permissions**
   - Settings → Actions → General
   - Ensure "Read and write permissions" is enabled

2. **Check Workflow**
   - Review error logs in the Actions tab
   - Font installation failures are common

### Page Not Displaying

1. **Check GitHub Pages Settings**
   - Settings → Pages
   - Ensure Source is set to "GitHub Actions"
   - If using custom domain, check DNS settings

2. **Check Deployment Status**
   - Verify "pages build and deployment" succeeded in Actions tab

### Styles Not Applied

1. **Check Asset Paths**
   - Verify relative paths are correct
   - Ensure `--allow-local-files` option is enabled

2. **Clear Cache**
   - Clear browser cache
   - GitHub Pages cache lasts up to 10 minutes

## Best Practices

1. **Organize Presentations**
   - Group related presentations in directories
   - Use clear filenames (include dates or event names)

2. **Asset Management**
   - Properly compress images
   - Consolidate shared resources in `assets/` directory

3. **Continuous Improvement**
   - Incorporate feedback after presentations
   - Document updates clearly in commit messages

4. **Security**
   - Manage confidential presentations separately
   - Use private repositories when necessary

## Related Documentation

- [Workflow Guide](workflow.en.md)
- [GitHub Actions Configuration](../templates/github-workflows/README.en.md)
- [Tips & Tricks](tips.en.md)