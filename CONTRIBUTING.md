# Contributing to OpenVox Workshop

First off, thank you for considering contributing to OpenVox Workshop! We welcome contributions from everyone,
whether it's submitting bug reports, improving documentation, fixing bugs, or implementing new features.

## Ways to Contribute

### Reporting Issues

If you find a bug or have a suggestion for improvement:

1. First, check if the issue already exists in our [GitHub Issues](https://github.com/zaben903/OpenVox-Workshop/issues)
2. If not, create a new issue, providing:
    - A clear, descriptive title
    - A detailed description of the issue
    - Steps to reproduce (for bugs)
    - Expected vs actual behaviour
    - Screenshots if applicable
    - Your environment details (OS, Ruby version, etc.)

### Pull Requests

1. Fork the repository
2. Create a new branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```
3. Make your changes
4. Run the test suite:
   ```bash
   # Ensure code style
   bin/standard
   # Run tests
   bin/rails db:test:prepare test test:system
   ```
5. Commit your changes:
   ```bash
   git commit -m "Description of your changes"
   ```
6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
7. Open a Pull Request

## Development Guidelines

### Code Style

- Follow [StandardRB](https://github.com/standardrb/standard) Styling Rules.
- Use [YARD](https://yardoc.org/) documentation for all methods.
- Use meaningful variable and method names
- Include comments for complex logic
- Write descriptive commit messages

### Testing

- Add tests for new features
- Ensure all tests pass before submitting
- Update existing tests if necessary

### Documentation

- Update README.md if needed
- Add inline documentation for new code

## Review Process

1. All contributions will be reviewed by maintainers
2. Feedback may be given for necessary changes
3. Once approved, changes will be merged

## Getting Help

If you need help with your contribution:

- Comment on the relevant issue
- Start a [Discussion](https://github.com/zaben903/OpenVox-Workshop/discussions)
- Reach out to maintainers

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## Recognition

Contributors will be acknowledged in our project documentation and README.

## Questions?

Don't hesitate to ask questions if something is unclear. We're here to help!