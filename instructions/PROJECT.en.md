# AI Development Support Settings

This project uses the AI instruction system in `instructions/ai_instruction_kits/`.
At the start of a task, please load `instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md`.

## Project Settings
- Language: English (en)
- Checkpoint management: Enabled
- Checkpoint script: scripts/checkpoint.sh
- Log file: checkpoint.log

## Project Overview

AutoSlideIdea is a framework for AI-assisted presentation creation.
It enables efficient slide creation using Marp (Markdown-based) with support from AI tools like Claude Code and Gemini CLI.

### Key Features
- **Markdown-based slide creation**: Simple and powerful slide generation with Marp
- **Multiple templates**: 4 types - basic, academic, business, full-project
- **AI-assisted content generation**: Create content progressively from outline to details
- **GitHub Actions integration**: Automated build and deployment
- **Research & analysis phase support**: Full-project template manages everything from research to presentation

### How to Use This Project
1. User creates new presentation using `create-presentation.sh`
2. AI confirms template type and suggests appropriate workflow
3. Content is created and improved progressively
4. Automated build/publish with GitHub Actions as needed

### Commit Message Guidelines

**Important**: Do not include AI tool signatures (Claude, Co-Authored-By, etc.) in commit messages for this project.
Instead, follow the format specified in CONTRIBUTING.md.

## Presentation Creation Support Guidelines

### Basic Principles

1. **Phased Approach**
   - First determine the structure
   - Create outline for each slide
   - Enrich the details
   - Add visuals

2. **Interactive Creation**
   - Confirm user's purpose and target audience
   - Present multiple options for proposals
   - Actively seek feedback

3. **Quality Focus**
   - Maintain logical flow
   - Keep appropriate amount of information
   - Make it visually clear

### Presentation Creation Process

1. **Initial Interview**
   ```
   - What is the theme?
   - Who is the audience?
   - How much time do you have?
   - What is the purpose? (persuasion, education, reporting, etc.)
   ```

2. **Working Directory Verification**
   - Confirm presentation name
   - Understand structure of `presentations/[name]/` directory
   - Check template type being used (basic/full-project, etc.)

3. **Structure Proposal**
   - Present 3-5 structure options
   - Explain characteristics of each option
   - Provide reasons for recommendations

4. **Slide Creation**
   - Create new with `./scripts/create-presentation.sh`
   - Support template selection
   - Assist with Markdown writing

5. **Content Enhancement**
   - Create content for each slide progressively
   - Add code examples, charts, images
   - Place technical term explanations appropriately

6. **Review and Improvement**
   - Check overall flow
   - Confirm time allocation
   - Verify message clarity

### Technical Guidelines

- **Marp Syntax**: Use correct Marp notation
- **Theme Usage**: Customize `config/marp/base.css`
- **Image Placement**: Utilize Marp features like background images, right placement
- **Code Display**: Use syntax highlighting appropriately
- **Chart Creation**: Generate diagrams using Mermaid

### Handling Common Requests

1. **"Create a presentation"**
   - First confirm the interview items above
   - Decide direction while showing samples

2. **"Add a slide"**
   - Confirm position and purpose of addition
   - Maintain consistency with surrounding slides

3. **"More detail"**
   - Confirm what to detail
   - Also suggest adding supplementary slides

4. **"Improve the design"**
   - Confirm specific improvement points
   - Suggest CSS customization or layout changes

### Output Format

- Always specify file paths during work
- Explain changes as diffs
- Guide preview commands

### Important Notes for Presentation Work

#### Recognizing Directory Structure
When working on presentations, always verify the directory structure:

1. **Check Template Type**
   ```bash
   # Check template type in README.md
   cat presentations/[name]/README.md
   ```
   - basic: Simple structure (slides.md only)
   - full-project: Complete structure including research/ideation

2. **Full-project Template Structure**
   ```
   presentations/[name]/
   ├── README.md         # Project description
   ├── slides.md         # Main slides
   ├── research/         # Research phase
   │   ├── notes.md      # Research notes
   │   ├── data/         # Raw data
   │   └── analysis/     # Analysis results
   ├── ideation/         # Ideation phase
   │   ├── brainstorm.md # Brainstorming
   │   └── drafts/       # Drafts
   └── assets/           # Images/charts
       ├── images/
       └── charts/
   ```

3. **Workflow (for full-project)**
   - Research phase: Record in `research/notes.md`
   - Ideation: Develop in `ideation/brainstorm.md`
   - Slide creation: Integrate above to create `slides.md`
   - Asset management: Place in `assets/`

#### File Editing Notes
- Always use relative paths (e.g., `./assets/images/figure.png` in slides.md)
- Replace placeholder `{{PRESENTATION_NAME}}` with actual name
- Use Marp syntax correctly (`---` for slide breaks, etc.)

### General Notes

- Understand user context before working
- Don't make it overly complex
- Provide executable commands
- Explain causes and solutions when errors occur
- presentations/ directory is .gitignored, requiring individual management