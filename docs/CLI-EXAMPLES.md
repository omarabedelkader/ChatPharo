# ChatPharo CLI - Real-World Examples

This document provides practical, real-world examples of using ChatPharo's terminal interface for various software development tasks.

---

## Table of Contents

1. [Code Review & Analysis](#code-review--analysis)
2. [Documentation Generation](#documentation-generation)
3. [Test Generation](#test-generation)
4. [Refactoring Assistance](#refactoring-assistance)
5. [Learning & Education](#learning--education)
6. [Debugging Help](#debugging-help)
7. [Architecture Planning](#architecture-planning)
8. [CI/CD Integration](#cicd-integration)
9. [Batch Processing](#batch-processing)
10. [Conversation Management](#conversation-management)

---

## Code Review & Analysis

### Basic Code Review

```bash
# Review a single class
pharo ChatPharo.image clap chatpharo ask \
  "Review this code for bugs, performance issues, and style problems" \
  --file src/UserManager.st
```

### Multi-File Architecture Review

```bash
# Analyze how multiple classes interact
pharo ChatPharo.image clap chatpharo ask \
  "Analyze the architecture and design patterns used in these classes. \
   Identify potential issues and suggest improvements." \
  --file src/models/User.st \
  --file src/models/UserRepository.st \
  --file src/controllers/UserController.st
```

### Security Review

```bash
# Focus on security issues
pharo ChatPharo.image clap chatpharo ask \
  "Perform a security review of this authentication code. \
   Look for SQL injection, XSS, CSRF, and other vulnerabilities." \
  --file src/security/AuthenticationManager.st \
  --system "You are a security expert focused on web application security"
```

### Pre-Commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

# Get list of modified .st files
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '.st$')

if [ -z "$FILES" ]; then
  exit 0
fi

echo "🤖 Running AI code review..."

for FILE in $FILES; do
  echo "Reviewing $FILE..."
  pharo ChatPharo.image clap chatpharo ask \
    "Quick review: Are there any critical bugs or security issues?" \
    --file "$FILE" \
    --json > /tmp/review-$$.json

  # Parse JSON and check for critical issues
  # (Implementation depends on your needs)
done

echo "✅ Review complete!"
```

---

## Documentation Generation

### Class Documentation

```bash
# Generate comprehensive class documentation
pharo ChatPharo.image clap chatpharo ask \
  "Generate comprehensive markdown documentation for this class. \
   Include: purpose, responsibilities, public API, usage examples, \
   and important implementation notes." \
  --file src/networking/HTTPClient.st \
  > docs/HTTPClient.md
```

### API Documentation

```bash
# Document a REST API controller
pharo ChatPharo.image clap chatpharo ask \
  "Generate API documentation in OpenAPI/Swagger format for this controller. \
   Include all endpoints, parameters, request/response formats, and examples." \
  --file src/api/UserAPIController.st \
  > docs/api/users.yml
```

### README Generation

```bash
# Generate project README
pharo ChatPharo.image clap chatpharo ask \
  "Based on these source files, generate a comprehensive README.md with: \
   project overview, features, installation, usage examples, and API reference." \
  --file src/Main.st \
  --file src/Config.st \
  --file src/API.st \
  > README.md
```

### Method Comment Generation

```bash
# Add comments to methods
pharo ChatPharo.image clap chatpharo ask \
  "For each method in this class, generate a clear comment explaining \
   what it does, its parameters, return value, and side effects. \
   Format as Pharo method comments." \
  --file src/algorithms/SortingAlgorithms.st
```

---

## Test Generation

### Unit Tests

```bash
# Generate SUnit tests
pharo ChatPharo.image clap chatpharo ask \
  "Generate comprehensive SUnit tests for this class. \
   Cover: normal cases, edge cases, error cases, and boundary conditions. \
   Use descriptive test names and include comments." \
  --file src/utilities/StringProcessor.st \
  > tests/StringProcessorTest.st
```

### Test Coverage Analysis

```bash
# Identify untested scenarios
pharo ChatPharo.image clap chatpharo ask \
  "Review this class and its test class. Identify scenarios that are not \
   tested and suggest additional test cases." \
  --file src/Calculator.st \
  --file tests/CalculatorTest.st
```

### Test Data Generation

```bash
# Generate test fixtures
pharo ChatPharo.image clap chatpharo ask \
  "Generate realistic test data (fixtures) for this model class. \
   Create at least 10 diverse examples covering various scenarios." \
  --file src/models/Order.st \
  > tests/fixtures/orders.json
```

### Mock Object Generation

```bash
# Create mocks for testing
pharo ChatPharo.image clap chatpharo ask \
  "Create mock objects for testing this class. \
   The mocks should simulate external dependencies like databases and APIs." \
  --file src/services/PaymentService.st
```

---

## Refactoring Assistance

### Extract Method Suggestions

```bash
# Identify refactoring opportunities
pharo ChatPharo.image clap chatpharo ask \
  "Analyze this class and suggest extract method refactorings. \
   Identify long methods that should be split up." \
  --file src/controllers/ComplexController.st
```

### Design Pattern Application

```bash
# Apply design patterns
pharo ChatPharo.image clap chatpharo ask \
  "This code has several conditional statements for handling different types. \
   Refactor it using the Strategy pattern. Provide the complete refactored code." \
  --file src/processors/DataProcessor.st
```

### Code Simplification

```bash
# Simplify complex code
pharo ChatPharo.image clap chatpharo ask \
  "Simplify this code while maintaining the same functionality. \
   Remove duplication, improve naming, and enhance readability." \
  --file src/legacy/LegacyBusinessLogic.st
```

### Dependency Reduction

```bash
# Reduce coupling
pharo ChatPharo.image clap chatpharo ask \
  "This class has too many dependencies. Suggest ways to reduce coupling \
   and improve testability using dependency injection or other patterns." \
  --file src/services/ReportGenerator.st
```

---

## Learning & Education

### Interactive Learning Session

```bash
# Start a tutoring session
pharo ChatPharo.image clap chatpharo chat \
  --system "You are a patient Pharo tutor. Explain concepts clearly with \
            code examples. Ask questions to check understanding. \
            Encourage hands-on practice."
```

**Example conversation:**
```
💬 You: How do blocks work in Pharo?
[AI explains blocks]

💬 You: Can you show an example with collections?
[AI provides example]

💬 You: /attach src/MyBlockExample.st
💬 You: Is this correct?
[AI reviews and provides feedback]
```

### Concept Explanation

```bash
# Understand a specific concept
pharo ChatPharo.image clap chatpharo ask \
  "Explain metaclasses in Pharo. Use examples and diagrams (ASCII art). \
   Start simple and progressively get more detailed."
```

### Code Explanation

```bash
# Understand existing code
pharo ChatPharo.image clap chatpharo ask \
  "Explain what this code does step by step. \
   Use simple language and highlight important concepts." \
  --file src/algorithms/QuickSort.st
```

### Best Practices Learning

```bash
# Learn Pharo idioms
pharo ChatPharo.image clap chatpharo ask \
  "What are the Pharo idioms and best practices for collection processing? \
   Provide examples of select:, collect:, inject:into:, and others."
```

---

## Debugging Help

### Bug Investigation

```bash
# Analyze buggy code
pharo ChatPharo.image clap chatpharo ask \
  "This code is supposed to sort users by registration date, but it's not working correctly. \
   Find the bug and explain why it's happening." \
  --file src/bugs/UserSorter.st
```

### Error Message Explanation

```bash
# Understand error messages
pharo ChatPharo.image clap chatpharo ask \
  "I'm getting this error: 'MessageNotUnderstood: receiver of \"at:\" is nil'. \
   What does this mean and how can I fix it? Here's my code:" \
  --file src/problematic/DataFetcher.st
```

### Performance Debugging

```bash
# Find performance bottlenecks
pharo ChatPharo.image clap chatpharo ask \
  "This code is running slowly with large datasets. \
   Identify performance bottlenecks and suggest optimizations." \
  --file src/slow/DataProcessor.st
```

### Interactive Debugging Session

```bash
pharo ChatPharo.image clap chatpharo chat
```

```
💬 You: I have a bug where users aren't being saved to the database
🤖: Can you share the code that saves users?

💬 You: /attach src/repositories/UserRepository.st
🤖: I see the issue. You're not committing the transaction...

💬 You: How do I fix that?
🤖: [Provides solution]

💬 You: /attach src/repositories/UserRepository-fixed.st
💬 You: Is this better?
🤖: Yes, that looks correct now!
```

---

## Architecture Planning

### System Design

```bash
# Plan a new feature
pharo ChatPharo.image clap chatpharo ask \
  "I need to add a notification system to my application. \
   Suggest an architecture with classes, responsibilities, and interactions. \
   Consider email, SMS, and push notifications."
```

### Database Schema Design

```bash
# Design data model
pharo ChatPharo.image clap chatpharo ask \
  "Design a database schema for an e-commerce system with: \
   users, products, orders, payments, and shipping. \
   Include relationships, constraints, and indexes."
```

### API Design

```bash
# Design REST API
pharo ChatPharo.image clap chatpharo ask \
  "Design a RESTful API for a task management system. \
   Include endpoints, HTTP methods, request/response formats, \
   authentication, and error handling."
```

### Migration Planning

```bash
# Plan legacy code migration
pharo ChatPharo.image clap chatpharo ask \
  "I need to migrate this legacy code to a modern architecture. \
   Provide a step-by-step migration plan with minimal disruption." \
  --file src/legacy/OldSystem.st
```

---

## CI/CD Integration

### GitHub Actions Example

`.github/workflows/ai-review.yml`:

```yaml
name: AI Code Review

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Pharo
        run: |
          wget https://get.pharo.org/64/stable+vm
          bash stable+vm
          # Load ChatPharo

      - name: Configure ChatPharo
        env:
          CLAUDE_API_KEY: ${{ secrets.CLAUDE_API_KEY }}
        run: |
          pharo Pharo.image clap chatpharo config set agent claude
          pharo Pharo.image clap chatpharo config set api-key $CLAUDE_API_KEY

      - name: Review Changed Files
        run: |
          echo "# AI Code Review" > review.md
          echo "" >> review.md

          for file in $(git diff --name-only origin/main...HEAD | grep '.st$'); do
            echo "## $file" >> review.md
            pharo Pharo.image clap chatpharo ask \
              "Review this code change. Focus on: bugs, performance, security, style." \
              --file "$file" >> review.md
            echo "" >> review.md
          done

      - name: Post Review as Comment
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: review
            });
```

### GitLab CI Example

`.gitlab-ci.yml`:

```yaml
ai-review:
  stage: review
  image: pharobot/pharo:latest
  script:
    - pharo Pharo.image clap chatpharo config set agent claude
    - pharo Pharo.image clap chatpharo config set api-key $CLAUDE_API_KEY
    - |
      for file in $(git diff --name-only $CI_MERGE_REQUEST_DIFF_BASE_SHA...HEAD | grep '.st$'); do
        pharo Pharo.image clap chatpharo ask \
          "Review this code" --file "$file" --json >> review.json
      done
  artifacts:
    reports:
      codequality: review.json
  only:
    - merge_requests
```

---

## Batch Processing

### Analyze Multiple Files

```bash
#!/bin/bash
# analyze-all.sh - Analyze all classes in a package

PHARO="pharo ChatPharo.image clap chatpharo"

echo "# Code Analysis Report" > report.md
echo "Generated: $(date)" >> report.md
echo "" >> report.md

for file in src/models/*.st; do
  echo "Analyzing $file..."
  echo "## $(basename $file)" >> report.md

  $PHARO ask "Provide a brief summary of this class: \
    purpose, responsibilities, and complexity rating (1-10)." \
    --file "$file" >> report.md

  echo "" >> report.md
done

echo "✅ Report generated: report.md"
```

### Generate Documentation for All Classes

```bash
#!/bin/bash
# document-all.sh

PHARO="pharo ChatPharo.image clap chatpharo"

mkdir -p docs/classes

for file in src/**/*.st; do
  classname=$(basename "$file" .st)
  echo "Documenting $classname..."

  $PHARO ask "Generate comprehensive documentation" \
    --file "$file" > "docs/classes/$classname.md"
done
```

### Batch Test Generation

```bash
#!/bin/bash
# generate-tests.sh

PHARO="pharo ChatPharo.image clap chatpharo"

for file in src/**/*.st; do
  classname=$(basename "$file" .st)

  # Skip if test already exists
  if [ -f "tests/${classname}Test.st" ]; then
    continue
  fi

  echo "Generating tests for $classname..."

  $PHARO ask "Generate SUnit tests" \
    --file "$file" > "tests/${classname}Test.st"
done
```

---

## Conversation Management

### Save Important Conversations

```bash
# During an interactive session, export periodically
pharo ChatPharo.image clap chatpharo chat

# In chat:
# /export conversations/refactoring-session-$(date +%Y%m%d).json
```

### Resume Previous Session

```bash
# Load previous conversation
pharo ChatPharo.image clap chatpharo chat \
  --load conversations/refactoring-session-20250128.json
```

### Create Knowledge Base

```bash
#!/bin/bash
# Build a searchable knowledge base from conversations

mkdir -p knowledge-base

# Export important chats
for topic in "authentication" "database" "ui" "testing"; do
  echo "Documenting $topic knowledge..."

  pharo ChatPharo.image clap chatpharo ask \
    "Summarize best practices and key insights about $topic in Pharo" \
    > "knowledge-base/$topic.md"
done
```

---

## Advanced Scripting

### Code Quality Dashboard

```bash
#!/bin/bash
# quality-dashboard.sh - Generate code quality metrics

PHARO="pharo ChatPharo.image clap chatpharo"

echo "Generating quality dashboard..."

# Complexity analysis
$PHARO ask "For each class in this directory, rate its complexity (1-10) \
  and justify the rating. Output as JSON." \
  --file src/**/*.st --json > complexity.json

# Test coverage gaps
$PHARO ask "Identify which classes lack proper test coverage" \
  --json > coverage-gaps.json

# Security issues
$PHARO ask "List any potential security vulnerabilities" \
  --json > security-issues.json

# Generate HTML dashboard
python3 generate-dashboard.py \
  --complexity complexity.json \
  --coverage coverage-gaps.json \
  --security security-issues.json \
  --output dashboard.html

echo "✅ Dashboard generated: dashboard.html"
```

---

## Tips & Best Practices

### 1. Use Descriptive Prompts

**❌ Bad:**
```bash
pharo ChatPharo.image clap chatpharo ask "Fix this" --file src/Bad.st
```

**✅ Good:**
```bash
pharo ChatPharo.image clap chatpharo ask \
  "Review this authentication code for security vulnerabilities, \
   especially SQL injection and XSS. Suggest fixes." \
  --file src/AuthManager.st
```

### 2. Leverage System Prompts

```bash
# For code reviews
--system "You are a senior developer focused on clean code and SOLID principles"

# For learning
--system "You are a patient tutor. Use simple language and provide examples"

# For security
--system "You are a security expert. Be thorough and cautious"
```

### 3. Chain Commands for Complex Workflows

```bash
# 1. Review code
pharo ChatPharo.image clap chatpharo ask "Review this" --file src/User.st > review.txt

# 2. If issues found, ask for fixes
pharo ChatPharo.image clap chatpharo ask "Based on this review, provide fixed code" \
  --file src/User.st --file review.txt > UserFixed.st

# 3. Generate tests
pharo ChatPharo.image clap chatpharo ask "Generate tests" --file UserFixed.st > UserTest.st
```

### 4. Use JSON Output for Automation

```bash
# Get JSON response
pharo ChatPharo.image clap chatpharo ask "Rate this code 1-10" \
  --file src/MyClass.st --json > rating.json

# Process with jq
RATING=$(jq -r '.response' rating.json | grep -o '[0-9]\+' | head -1)

if [ "$RATING" -lt 7 ]; then
  echo "⚠️ Code quality below threshold!"
  exit 1
fi
```

---

**For more examples and documentation, see:**
- [CLI-README.md](./CLI-README.md) - Full documentation
- [CLI-QUICKSTART.md](./CLI-QUICKSTART.md) - Quick start guide
