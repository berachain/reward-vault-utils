# Contributing to Reward Vault Utilities

Thank you for your interest in contributing to Reward Vault Utilities! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Foundry
- Git
- Basic knowledge of Solidity and TypeScript

### Development Setup
1. Fork the repository
2. Clone your fork locally
3. Install dependencies:
   ```bash
   pnpm install
   cd contracts && forge install && cd ..
   ```
4. Create a feature branch: `git checkout -b feature/your-feature-name`

## 📋 Contribution Guidelines

### Code Style

#### Solidity
- Follow the [Solidity Style Guide](https://docs.soliditylang.org/en/v0.8.19/style-guide.html)
- Use meaningful variable and function names
- Add comprehensive NatSpec documentation
- Keep functions focused and concise
- Use custom errors instead of require statements with strings

#### TypeScript
- Follow the [TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
- Use meaningful variable and function names
- Add JSDoc comments for public functions
- Prefer const over let when possible
- Use async/await over Promises

### Testing

#### Smart Contracts
- Write comprehensive tests for all functions
- Test both success and failure cases
- Use descriptive test names
- Aim for high test coverage
- Run tests before submitting: `forge test -vv`

#### Indexer (if applicable)
- Write unit tests for new features
- Test API endpoints
- Ensure database migrations work correctly
- Run tests: `pnpm test`

### Documentation

- Update relevant documentation files
- Add comments for complex logic
- Update README if adding new features
- Include examples for new functionality

## 🔄 Pull Request Process

1. **Create a feature branch** from the latest main branch
2. **Make your changes** following the code style guidelines
3. **Write tests** for new functionality
4. **Update documentation** as needed
5. **Run all tests** to ensure nothing is broken
6. **Commit your changes** with clear, descriptive commit messages
7. **Push to your fork** and create a Pull Request

### Commit Message Format

We use [conventional commits](https://www.conventionalcommits.org/) for consistent and meaningful commit messages. This helps with automated changelog generation and makes the project history more readable.

#### Format
```
type(scope): description

[optional body]

[optional footer]
```

#### Types
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

#### Examples
- `feat(lootbox): add new rarity tier`
- `fix(merkle): resolve proof verification issue`
- `docs(readme): update installation instructions`
- `test(contracts): add comprehensive test coverage`
- `refactor(entropy): simplify fee calculation logic`
- `chore(deps): update foundry dependencies`

### Pull Request Guidelines

- **Title**: Clear, descriptive title
- **Description**: Explain what the PR does and why
- **Related Issues**: Link to any related issues
- **Testing**: Describe how you tested the changes
- **Breaking Changes**: Note any breaking changes

## 🐛 Reporting Issues

When reporting issues, please include:

- **Description**: Clear description of the problem
- **Steps to Reproduce**: Detailed steps to reproduce the issue
- **Expected Behavior**: What you expected to happen
- **Actual Behavior**: What actually happened
- **Environment**: OS, Node.js version, Foundry version
- **Screenshots**: If applicable

## 💡 Feature Requests

When suggesting new features:

- **Description**: Clear description of the feature
- **Use Case**: Explain why this feature would be useful
- **Implementation Ideas**: If you have ideas on how to implement it
- **Priority**: Indicate if this is a high, medium, or low priority

## 🏷️ Issue Labels

We use the following labels to categorize issues:

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements or additions to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention is needed
- `question`: Further information is requested

## 🤝 Code Review

All contributions require review before merging. Reviewers will check for:

- Code quality and style
- Test coverage
- Documentation updates
- Security considerations
- Performance implications

## 📄 License

By contributing to Reward Vault Utilities, you agree that your contributions will be licensed under the MIT License.

## 🆘 Need Help?

If you need help with contributing:

- Check existing issues and pull requests
- Join our community discussions
- Ask questions in issues with the `question` label

Thank you for contributing to Reward Vault Utilities! 🎉 