---
layout: default
title: Installation
nav_order: 1
parent: English
nav_exclude: true
---

# Installation Guide

How to install AutoSlideIdea.

## Requirements

- Git
- Node.js (v14 or higher)
- npm or yarn

## Installation Steps

### 1. Clone Repository

```bash
git clone --recursive https://github.com/dobachi/AutoSlideIdea.git
cd AutoSlideIdea
```

The `--recursive` option is required to clone the AI instruction kit submodule.

### 2. Install Dependencies

```bash
npm install
```

or

```bash
yarn install
```

### 3. Verify Installation

```bash
# Check SlideFlow command
./slideflow/slideflow.sh --help

# Create a new presentation
./slideflow/slideflow.sh new my-presentation
```

## Troubleshooting

### Submodule Not Fetched

```bash
git submodule update --init --recursive
```

### Permission Denied

```bash
chmod +x slideflow/slideflow.sh
chmod +x scripts/*.sh
```

### Old Node.js Version

Install the latest LTS version from [Node.js official site](https://nodejs.org/).

## Next Steps

After installation, check out the [Quick Start](../quickstart/) to create your first presentation.