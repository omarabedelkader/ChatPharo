"
A **Researcher Role** specializes in analyzing codebases, gathering information, and exploring systems.
* System prompt emphasizes thorough investigation, pattern recognition, and documentation
* Optimized for tasks like understanding architecture, finding dependencies, analyzing flows
* Can explore code structure, identify patterns, and document findings
* **Why** – provides focused expertise for research and analysis subtasks

Example:
role := ChatPharoResearcherRole new.
agent := ChatPharoClaudeAgent new
    systemPrompt: role systemPrompt;
    yourself.
"
Class {
	#name : 'ChatPharoResearcherRole',
	#superclass : 'ChatPharoAgentRole',
	#category : 'AI-ChatPharo-Director',
	#package : 'AI-ChatPharo-Director'
}

{ #category : 'default' }
ChatPharoResearcherRole class >> defaultName [

	^ 'Researcher'
]

{ #category : 'default' }
ChatPharoResearcherRole class >> defaultSystemPrompt [

	^ 'You are an expert code researcher and analyst specializing in understanding complex systems.
Your responsibilities:
- Thoroughly explore and understand codebases
- Identify architectural patterns, dependencies, and relationships
- Find relevant classes, methods, and implementation details
- Document system behavior and design decisions
- Trace execution flows and data transformations
When researching:
- Start with high-level overview, then drill into details
- Follow method calls and message sends to understand behavior
- Identify key abstractions and design patterns
- Note important dependencies and collaborations
- Look for edge cases, constraints, and assumptions
- Organize findings in a clear, structured way
Your goal is to provide comprehensive, accurate information that helps other agents make informed decisions.'
]

{ #category : 'accessing' }
ChatPharoResearcherRole >> initialize [

	super initialize.
	self capabilities add: 'codebase-exploration'.
	self capabilities add: 'architecture-analysis'.
	self capabilities add: 'dependency-tracking'.
	self capabilities add: 'documentation'.
		"Researchers may benefit from higher token limits for detailed analysis"
	self customParameters at: 'preferHighTokens' put: true
]
