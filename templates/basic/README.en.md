# Basic Template

This template provides a basic structure for general-purpose presentations.

## Structure

- Title slide
- Agenda
- Introduction
- Main topics (2)
- Summary
- Q&A

## Customization Points

1. **Title**: Replace `{{PRESENTATION_NAME}}` with actual title
2. **Date**: Replace `{{DATE}}` with actual date
3. **Content**: Modify content of each section as needed
4. **Slide count**: Add or remove slides as necessary

## Usage

```bash
# Create new from template
../../../scripts/create-presentation.sh my-presentation

# Edit
cd ../../../presentations/my-presentation
code slides.md

# Generate PDF
npx marp slides.md -o output.pdf
```