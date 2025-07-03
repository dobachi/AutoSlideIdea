# Contribution Guidelines

English | [日本語](CONTRIBUTING.md)

## Code of Conduct

We aim to build a community where everyone can participate comfortably. Please be respectful to all contributors.

## How to Contribute

### 1. Reporting Issues

- Check if the issue already exists before creating a new one
- Use the issue template if available
- Describe the issue clearly with steps to reproduce

### 2. Proposing Features

- Discuss in issues before implementing major features
- Explain why the feature is needed
- Consider backward compatibility

### 3. Submitting Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests if applicable
5. Commit your changes (see commit message format below)
6. Push to your branch
7. Create a Pull Request

## Commit Message Format

We follow a simplified version of Conventional Commits:

```
<type>: <description>

[optional body]

[optional footer]
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only changes
- `style`: Changes that don't affect code meaning (white-space, formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or modifying tests
- `chore`: Changes to build process or auxiliary tools

### Examples

```
feat: Add English language support

- Added English versions of all templates
- Updated create-presentation.sh for language selection
- Created English documentation

feat: Add multi-language support to create-presentation script

docs: Update README with language switching links

fix: Correct file path handling for English templates
```

## Commit Message Guidelines

**Important**: In this project, DO NOT include AI tool signatures (Claude, Co-Authored-By, etc.) in commit messages.

## Development Setup

```bash
# Clone the repository
git clone https://github.com/your-username/AutoSlideIdea.git
cd AutoSlideIdea

# Install dependencies
npm install

# Create a test presentation
./scripts/create-presentation.sh test-presentation
```

## Testing

- Test your changes with different templates
- Verify both Japanese and English language support
- Check that GitHub Actions integration works

## Documentation

- Update documentation for any user-facing changes
- Keep both Japanese and English docs in sync
- Add examples when introducing new features

## Questions?

Feel free to open an issue for any questions about contributing.