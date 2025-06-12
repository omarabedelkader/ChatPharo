# Contributing to ChatPharo

Thank you for taking the time to contribute to **ChatPharo**! The following guidelines help us maintain a welcoming and consistent workflow.

## Getting Started

1. **Fork the repository** and create a feature branch from `main`.
2. Install the prerequisites listed in the [README](README.md) so you can build and run the project locally.
3. Before making changes, please search the [issues](https://github.com/omarabedelkader/ChatPharo/issues) to see if your idea or bug has already been reported. If not, open a new issue using the appropriate template.

## Development Guidelines

- Follow the existing Smalltalk coding style used in the project.
- Write tests for new features or bug fixes under `src/AI-ChatPharo-Tests`.
- Run the test suite locally with **smalltalkCI**. For example:
  ```bash
  smalltalkci -s Pharo64-14
  ```
  Adjust the Smalltalk version as needed.

## Submitting a Pull Request

1. Ensure your branch is up to date with `main`.
2. Commit your changes with clear messages and push to your fork.
3. Open a pull request targeting `main` and describe the motivation and changes.
4. A maintainer will review your PR. Be ready to make revisions if requested.

## Code of Conduct

Please be respectful in all interactions. We strive to maintain a friendly, cooperative environment.

Happy hacking!
