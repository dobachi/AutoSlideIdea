# Advanced Workflow Using AI Instruction System

## Overview

By leveraging the diverse instruction files in the AI instruction system, you can streamline the entire presentation creation process with AI assistance.

## Phase-Based Workflow

### 1. Research & Analysis Phase

#### Data Collection and Analysis
```bash
# Load data analysis instructions
"Please load `.ai-instructions/instructions/ja/analysis/basic_data_analysis.md`"

# Example analysis request
"Analyze the market research data and create graphs showing the trend of AI tool adoption rates"
```

#### Technical Research
```bash
# Research as Python expert
"Please load `.ai-instructions/instructions/ja/agent/python_expert.md`"

# Research the latest ML frameworks and create a comparison table
```

### 2. Idea Generation Phase

#### Brainstorming
```bash
# Utilize creative instructions
"Please load `.ai-instructions/instructions/ja/creative/basic_creative_work.md`"

# Propose 10 catchphrases for the presentation
```

#### Multi-perspective Consideration
```bash
# Consider from different perspectives
"From the perspectives of engineers, executives, and end-users, 
propose key points to emphasize in this presentation"
```

### 3. Structure Design Phase

#### Storyline Creation
```bash
# Structure as technical writer
"Please load `.ai-instructions/instructions/ja/agent/technical_writer.md`"

# Propose a structure that explains technical content clearly to non-technical audiences
```

### 4. Content Creation Phase

#### Slide Creation
```bash
# Streamline with basic code generation instructions
"Please load `.ai-instructions/instructions/ja/coding/basic_code_generation.md`"

# Create slides including Mermaid diagrams and code examples
```

#### Quality Check
```bash
# Improve quality with code review instructions
"Please load `.ai-instructions/instructions/ja/agent/code_reviewer.md`"

# Review the code examples in the slides and suggest improvements
```

## Practical Example: Creating a Technical Presentation

### Step 1: Market Research
```bash
# Analyze market data with data analysis instructions
"Analyze AI tool market growth rate data and create visually clear graphs"
```

### Step 2: Technical Comparison
```bash
# Technical evaluation as Python expert
"Create a performance comparison table of major AI frameworks and summarize their features"
```

### Step 3: Message Design
```bash
# Generate ideas with creative instructions
"Propose ideas for an impressive opening slide with the theme 'The Future of Development Changed by AI'"
```

### Step 4: Content Writing
```bash
# Write as technical writer
"Create slides that explain technical content in a way executives can understand"
```

### Step 5: Final Check
```bash
# Overall review
"Review the entire presentation and suggest improvements"
```

## Checkpoint Utilization

Progress in each phase is automatically recorded in `checkpoint.log`:

```
[2025-01-10 10:00:00] [TASK-a1b2c3] [START] Starting technical presentation creation (estimated 5 steps)
[2025-01-10 10:30:00] [TASK-a1b2c3] [COMPLETE] Outcome: Market research data analysis completed, 3 types of graphs created
[2025-01-10 11:00:00] [TASK-a1b2c3] [START] Technical comparison research
[2025-01-10 11:30:00] [TASK-a1b2c3] [COMPLETE] Outcome: 5 framework comparison table created
[2025-01-10 14:00:00] [TASK-a1b2c3] [START] Creating presentation first draft
[2025-01-10 15:00:00] [TASK-a1b2c3] [COMPLETE] Outcome: 20 slides, 3 demos completed
```

## Integrated Script Utilization

Using `create-presentation.sh`, you can build a consistent environment from research to presentation:

### Creating a Full Project
```bash
# Create complete structure with research, ideas, and slides
./scripts/create-presentation.sh --full research-presentation

# Manage as GitHub repository (with CI/CD)
./scripts/create-presentation.sh --github --full tech-conference-2025
```

### Created Structure (Full Project)
```
research-presentation/
├── research/          # Used in research phase
│   ├── notes.md      # Record research content with AI assistance
│   ├── data/         # Store raw data
│   └── analysis/     # Output analysis results
├── ideation/         # Idea generation phase
│   ├── brainstorm.md # Develop ideas with AI assistance
│   └── drafts/       # Structure drafts
├── assets/           # Visual materials
│   ├── images/       # Image materials
│   └── charts/       # Graphs and diagrams
└── slides.md         # Final presentation
```

## Tips

### Combining Instructions
- Utilize different instructions in the flow: research → analysis → creation → writing
- Review the same content from different perspectives

### Efficient Switching
```bash
# Work while switching instructions
"First analyze market data with the analysis instructions, 
then generate visual ideas with the creative instructions"
```

### Quality Improvement Tips
- Select appropriate expert-type instructions for each phase
- Regularly check progress with checkpoints
- Finally review from multiple perspectives

By utilizing the AI instruction system and integrated scripts this way, presentation creation can be managed as a comprehensive project.