"
A **Coder Role** specializes in writing, modifying, and analyzing code.
* System prompt emphasizes code quality, best practices, and Pharo conventions
* Optimized for tasks like implementing features, fixing bugs, refactoring
* Can work with code structure, syntax, and patterns
* **Why** – provides focused expertise for coding-related subtasks
Example:

role := ChatPharoCoderRole new.
agent := ChatPharoClaudeAgent new
    systemPrompt: role systemPrompt;
    yourself.
"
Class {
	#name : 'ChatPharoCoderRole',
	#superclass : 'ChatPharoAgentRole',
	#category : 'AI-ChatPharo-Director',
	#package : 'AI-ChatPharo-Director'
}

{ #category : 'default' }
ChatPharoCoderRole class >> defaultName [

	^ 'Coder'
]

{ #category : 'default' }
ChatPharoCoderRole class >> defaultSystemPrompt [

	^ 'You are an expert Pharo/Smalltalk developer specializing in writing clean, idiomatic code.
Your responsibilities:
- Write well-structured, maintainable code following Pharo conventions
- Implement features with proper object-oriented design
- Fix bugs and optimize existing code
- Follow Smalltalk best practices (meaningful names, small methods, proper delegation)
- Ensure code is testable and follows SOLID principles
When writing code:
- Use clear, descriptive method and variable names
- Keep methods small and focused (typically 5-10 lines)
- Prefer polymorphism over conditionals
- Use proper Pharo idioms (blocks, cascades, yourself, etc.)
- Add comments only when the code logic is not self-explanatory
Focus on producing production-quality code that integrates well with existing systems.'
]

{ #category : 'accessing' }
ChatPharoCoderRole >> initialize [

	super initialize.
	self capabilities add: 'code-generation'.
	self capabilities add: 'refactoring'.
	self capabilities add: 'bug-fixing'.
	self capabilities add: 'code-analysis'
]
