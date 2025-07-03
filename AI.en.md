# AI Development Support Settings - Presentation Creation

This project uses the AI instruction system in `.ai-instructions/`.
At the start of a task, please load `.ai-instructions/instructions/en/system/ROOT_INSTRUCTION.md`.

## Project Settings
- Language: English (en)
- Checkpoint management: Enabled
- Log file: checkpoint.log

## Project-Specific Additional Instructions

This project is a framework for AI-assisted presentation creation.
When users create presentations, please support them according to the following guidelines.

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

2. **Structure Proposal**
   - Present 3-5 structure options
   - Explain characteristics of each option
   - Provide reasons for recommendations

3. **Slide Creation**
   - Create new with `./scripts/new-presentation.sh`
   - Support template selection
   - Assist with Markdown writing

4. **Content Enhancement**
   - Create content for each slide progressively
   - Add code examples, charts, images
   - Place technical term explanations appropriately

5. **Review and Improvement**
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

### Notes

- Understand user context before working
- Don't make it overly complex
- Provide executable commands
- Explain causes and solutions when errors occur