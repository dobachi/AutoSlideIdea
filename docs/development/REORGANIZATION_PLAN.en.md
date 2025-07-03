[English](REORGANIZATION_PLAN.en.md) | [日本語](REORGANIZATION_PLAN.md)

# Documentation Reorganization Plan

## Current Issues
- Japanese and English files are mixed in the same directory level
- No categorization by functionality
- New feature documentation (Mermaid integration) is scattered
- Users have difficulty finding necessary information

## Proposed New Structure

```
docs/
├── README.md                 # Documentation index
├── ja/                       # Japanese documentation
│   ├── getting-started/      # For beginners
│   │   ├── setup.md         # Setup
│   │   ├── quickstart.md    # Quick start
│   │   └── basic-usage.md   # Basic usage
│   ├── guides/              # Guides
│   │   ├── workflow.md      # Workflow
│   │   ├── tips.md          # Tips & Tricks
│   │   └── best-practices.md # Best practices
│   ├── features/            # Feature descriptions
│   │   ├── mermaid/         # Mermaid integration
│   │   │   ├── overview.md  # Overview
│   │   │   └── technical.md # Technical details
│   │   ├── github-pages.md  # GitHub Pages
│   │   └── templates.md     # Templates
│   ├── reference/           # Reference
│   │   ├── scripts.md       # Scripts
│   │   ├── config.md        # Configuration
│   │   └── api.md          # API (for future use)
│   └── advanced/            # For advanced users
│       ├── workflow.md      # Advanced workflow
│       └── customization.md # Customization
├── en/                      # English documentation (same structure)
│   ├── getting-started/
│   ├── guides/
│   ├── features/
│   ├── reference/
│   └── advanced/
└── assets/                  # Images for documentation
    ├── screenshots/
    └── diagrams/
```

## Migration Mapping

### Japanese Files
- `setup.md` → `ja/getting-started/setup.md`
- `workflow.md` → `ja/guides/workflow.md`
- `tips.md` → `ja/guides/tips.md`
- `advanced-workflow.md` → `ja/advanced/workflow.md`
- `github-pages.md` → `ja/features/github-pages.md`
- `scripts-reference.md` → `ja/reference/scripts.md`
- `mermaid-integration.md` → `ja/features/mermaid/technical.md`
- `mermaid-integration-summary.md` → `ja/features/mermaid/overview.md`

### English Files
- `*.en.md` → Corresponding directories under `en/`

## Files to be Created

1. **docs/README.md** - Documentation index (bilingual support)
2. **ja/getting-started/quickstart.md** - 5-minute startup guide
3. **ja/guides/best-practices.md** - Collection of best practices
4. **ja/features/templates.md** - Detailed template descriptions

## Implementation Steps

1. Create new directory structure
2. Move existing files to appropriate locations
3. Update relative links
4. Provide navigation through README.md
5. Update links to documentation from root README.md

## Benefits

- **Clear structure**: Files organized by purpose
- **Language separation**: Independent documentation for each language
- **Extensibility**: Easy to add documentation for new features
- **Maintainability**: Predictable file locations
- **Usability**: Easy to find necessary information

## Considerations

- External links will be affected due to GitHub link changes
- CI/CD scripts referencing documentation paths need to be updated
- Recommend phased migration with redirect setup