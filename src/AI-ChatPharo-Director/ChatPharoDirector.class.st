"
A **Director** coordinates a team of specialized agents to accomplish complex tasks.
* Decomposes user requests into subtasks
* Assigns subtasks to appropriate specialized agents based on their roles
* Manages task dependencies and execution order
* Merges results from multiple agents into a coherent response
* Ensures consistency across agent outputs
* **Why** – enables sophisticated multi-agent workflows where specialized agents collaborate
Example:


director := ChatPharoDirector new
    baseAgent: (ChatPharoClaudeAgent new apiKey: 'sk-...'; yourself);
    yourself.
response := director handleRequest: 'Analyze the authentication system and propose improvements'.
""""Director will:
  1. Assign research task to Researcher agent
  2. Assign code improvement task to Coder agent
  3. Merge results with Summarizer agent




# ChatPharo Director/Team Pattern

The Director/Team pattern enables sophisticated multi-agent collaboration where specialized agents work together to accomplish complex tasks.

## Overview

The Director/Team system consists of:

- **ChatPharoDirector**: Coordinates the team, decomposes requests, assigns tasks, and merges results
- **ChatPharoAgentTeam**: Manages a collection of specialized agents
- **ChatPharoAgentRole**: Defines agent specializations (Coder, Researcher, Summarizer)
- **ChatPharoTask**: Represents a unit of work with dependencies and status tracking

## Key Features

1. **Task Decomposition**: Director automatically breaks down complex requests into manageable subtasks
2. **Role Specialization**: Agents specialize in specific domains (coding, research, summarization)
3. **Dependency Management**: Tasks can depend on other tasks' results
4. **Result Merging**: Summarizer agent synthesizes outputs into coherent responses
5. **Consistency Checking**: Director ensures outputs are consistent and complete

## Basic Usage

```smalltalk
""Create a director with a base agent""
agent := ChatPharoClaudeAgent new
    apiKey: 'your-api-key';
    model: 'claude-sonnet-4-20250514';
    yourself.
director := ChatPharoDirector withAgent: agent.
""Handle a complex request""
response := director handleRequest: 'Analyze the authentication system and propose improvements'.
```

## How It Works

When you submit a request to the Director:

1. **Planning Phase**: Director analyzes the request and decomposes it into subtasks
2. **Assignment Phase**: Each subtask is assigned to the appropriate specialized agent
3. **Execution Phase**: Tasks are executed in priority order, respecting dependencies
4. **Merging Phase**: Summarizer agent synthesizes all results into a final response

## Specialized Roles

### Coder Role
- Writes, modifies, and analyzes code
- Follows Pharo/Smalltalk conventions
- Focuses on clean, maintainable implementations
- Best for: implementing features, fixing bugs, refactoring

### Researcher Role
- Explores and analyzes codebases
- Identifies patterns and relationships
- Documents findings thoroughly
- Best for: understanding systems, finding dependencies, architecture analysis

### Summarizer Role
- Synthesizes information from multiple sources
- Creates clear, concise summaries
- Ensures consistency across outputs
- Best for: final response generation, conflict resolution

## Advanced Usage

### Custom Team Configuration

```smalltalk
""Create specialized agents with custom settings""
coder := ChatPharoClaudeAgent new
    apiKey: 'key';
    model: 'claude-sonnet-4-20250514';
    maxTokens: 4096;
    yourself.
researcher := ChatPharoClaudeAgent new
    apiKey: 'key';
    model: 'claude-sonnet-4-20250514';
    maxTokens: 8192;  ""More tokens for detailed analysis""
    yourself.
""Build custom team""
team := ChatPharoAgentTeam new
    addAgent: coder withRole: ChatPharoCoderRole new;
    addAgent: researcher withRole: ChatPharoResearcherRole new;
    yourself.
director := ChatPharoDirector new
    baseAgent: coder;
    team: team;
    yourself.
```

### Manual Task Creation

```smalltalk
""Create tasks manually with explicit dependencies""
task1 := ChatPharoTask
    description: 'Find all authentication classes'
    role: ChatPharoResearcherRole.
task2 := ChatPharoTask
    description: 'Implement two-factor auth'
    role: ChatPharoCoderRole.
task2 dependencies add: task1.  ""task2 depends on task1""
task2 priority: 1.  ""High priority""
director tasks: { task1. task2 }.
director executeTasks.
result := director mergeResults.
```

## Architecture

```
ChatPharoDirector
  ├── analyzeRequest: (decomposes into tasks)
  ├── assignTask: (assigns to appropriate agent)
  ├── executeTasks (executes in priority order)
  └── mergeResults (synthesizes final output)
ChatPharoAgentTeam
  ├── members (Dictionary: Role Class -> Agent)
  └── agentForRole: (looks up agent by role)
ChatPharoTask
  ├── description
  ├── requiredRole
  ├── status (#pending, #assigned, #in_progress, #completed, #failed)
  ├── result
  ├── dependencies
  └── priority
ChatPharoAgentRole (abstract)
  ├── ChatPharoCoderRole
  ├── ChatPharoResearcherRole
  └── ChatPharoSummarizerRole
```

## Integration with Existing ChatPharo

The Director pattern integrates seamlessly with existing ChatPharo features:

- Uses existing agent hierarchy (ChatPharoAgent subclasses)
- Works with any agent backend (Claude, Ollama, Gemini, etc.)
- Compatible with tool calling and history management
- Can be used alongside ChatPharoMultivers for hybrid workflows

## Examples

See `ChatPharoDirectorTest` class for runnable examples:

- `exampleBasicUsage`: Simple director usage
- `exampleCustomTeam`: Building a custom team
- `exampleManualTaskAssignment`: Manual task management
- `exampleRoleSpecialization`: How roles differ in their approach

## Use Cases

The Director/Team pattern excels at:

1. **Complex Analysis Tasks**: Research codebase → Suggest improvements → Implement changes
2. **Multi-Step Implementations**: Design → Code → Test → Document
3. **Code Reviews**: Analyze code → Identify issues → Suggest fixes
4. **Architecture Design**: Research requirements → Design system → Generate implementation plan

## Performance Considerations

- **Sequential Execution**: Tasks currently execute sequentially (parallel execution planned)
- **Token Usage**: Each agent makes separate API calls, increasing token consumption
- **Latency**: Multiple round-trips add latency compared to single-agent workflows
- **Best For**: Complex tasks where specialization benefits outweigh overhead

## Future Enhancements

- Parallel task execution for independent tasks
- Agent communication and collaboration
- Dynamic role creation
- Task result caching
- Conflict detection and resolution
- Streaming results as tasks complete
"
Class {
	#name : 'ChatPharoDirector',
	#superclass : 'Object',
	#instVars : [
		'team',
		'tasks',
		'baseAgent',
		'planningSystemPrompt',
		'maxParallelTasks'
	],
	#category : 'AI-ChatPharo-Director',
	#package : 'AI-ChatPharo-Director'
}

{ #category : 'instance creation' }
ChatPharoDirector class >> planningSystemPrompt [

	^ 'You are a project manager coordinating a team of specialized AI agents.
Your team consists of:
- **Coder**: Expert at writing, modifying, and analyzing code
- **Researcher**: Expert at exploring codebases and understanding systems
- **Summarizer**: Expert at synthesizing information and creating clear summaries
Your job is to analyze user requests and break them down into specific subtasks that can be assigned to your team members.
Guidelines:
- Start with research/analysis tasks before implementation tasks
- Use the Coder for any code writing, modification, or refactoring
- Use the Researcher for understanding existing systems, finding patterns, or analyzing architecture
- Use the Summarizer for final result synthesis and ensuring consistency
- Assign appropriate priorities (1=highest, 10=lowest)
- Keep task descriptions clear and specific
Think step-by-step about what needs to be done and who is best suited for each part.'
]

{ #category : 'instance creation' }
ChatPharoDirector class >> withAgent: anAgent [
	"Create a director with a base agent"

	^ self new
		baseAgent: anAgent;
		yourself
]

{ #category : 'private' }
ChatPharoDirector >> analyzeRequest: aRequest [
	"Use the director's own intelligence to break down a request into tasks"

	| planningPrompt response taskDescriptions |

	planningPrompt := String streamContents: [ :stream |
		stream
			nextPutAll: self planningSystemPrompt;
			cr; cr;
			nextPutAll: 'User Request: ';
			nextPutAll: aRequest;
			cr; cr;
			nextPutAll: 'Break this request into specific subtasks. For each task, specify:';
			cr;
			nextPutAll: '1. Task description (what needs to be done)';
			cr;
			nextPutAll: '2. Required role (Coder, Researcher, or Summarizer)';
			cr;
			nextPutAll: '3. Priority (1-10, where 1 is highest)';
			cr; cr;
			nextPutAll: 'Format each task as: [ROLE] (Priority: N) Task description';
			cr;
			nextPutAll: 'Example: [Researcher] (Priority: 1) Analyze the authentication system';
			cr;
			nextPutAll: 'Example: [Coder] (Priority: 2) Implement password hashing' ].

	"Use base agent for planning"
	response := baseAgent getResponseForPrompt: planningPrompt.

	"Parse the response into tasks"
	taskDescriptions := self parseTaskDescriptions: response.

	^ taskDescriptions collect: [ :taskDesc |
		ChatPharoTask new
			description: taskDesc at: #description;
			requiredRole: (taskDesc at: #role);
			priority: (taskDesc at: #priority);
			yourself ]
]

{ #category : 'private' }
ChatPharoDirector >> assignTask: aTask [
	"Assign a task to the appropriate agent based on its required role"

	| agent |

	aTask requiredRole ifNil: [
		"No specific role required, use any available agent"
		agent := team members values first ].

	agent := team agentForRole: aTask requiredRole.

	agent ifNil: [
		"Role not available in team, use base agent"
		agent := baseAgent ].

	aTask assignedAgent: agent.
	aTask status: #assigned.

	^ agent
]

{ #category : 'private' }
ChatPharoDirector >> baseAgent [

	^ baseAgent
]

{ #category : 'private' }
ChatPharoDirector >> baseAgent: anAgent [ 
	"Set the base agent and create team from it"

	baseAgent := anAgent.
	team := ChatPharoAgentTeam withBaseAgent: baseAgent
]

{ #category : 'private' }
ChatPharoDirector >> executeTask: aTask [
	"Execute a single task using its assigned agent"

	| agent prompt result |

	agent := aTask assignedAgent ifNil: [ self assignTask: aTask ].
	aTask status: #in_progress.

	"Build prompt with task context"
	prompt := String streamContents: [ :stream |
		stream
			nextPutAll: 'Task: ';
			nextPutAll: aTask description;
			cr; cr.

		"Include results from dependent tasks"
		aTask dependencies do: [ :depTask |
			depTask isCompleted ifTrue: [
				stream
					nextPutAll: 'Context from previous task: ';
					nextPutAll: depTask result;
					cr; cr ] ] ].

	"Execute with assigned agent"
	result := agent getResponseForPrompt: prompt.

	aTask result: result.
	aTask status: #completed.

	^ result
]

{ #category : 'private' }
ChatPharoDirector >> executeTasks [
	"Execute all tasks, respecting dependencies and priorities"

	| sortedTasks |

	"Sort by priority (lower number = higher priority)"
	sortedTasks := tasks sorted: [ :a :b | a priority < b priority ].

	sortedTasks do: [ :task |
		"Wait for dependencies"
		task isReady ifTrue: [
			[ self executeTask: task ]
				on: Error
				do: [ :ex |
					task status: #failed.
					task result: 'Error: ' , ex messageText ] ] ]
]

{ #category : 'api' }
ChatPharoDirector >> handleRequest: aRequest [
	"Main entry point: analyze request, assign tasks, execute, and merge results"

	| finalResult |

	"Step 1: Analyze and decompose request"
	tasks := self analyzeRequest: aRequest.

	"Step 2: Execute all tasks"
	self executeTasks.

	"Step 3: Merge results"
	finalResult := self mergeResults.

	^ finalResult
]

{ #category : 'api' }
ChatPharoDirector >> initialize [

	super initialize.
	tasks := OrderedCollection new.
	maxParallelTasks := 3.
	planningSystemPrompt := self class planningSystemPrompt
]

{ #category : 'private' }
ChatPharoDirector >> mergeResults [
	"Use the Summarizer agent to merge all task results into a coherent response"

	| summarizerAgent mergePrompt completedTasks |

	completedTasks := tasks select: [ :task | task isCompleted ].

	completedTasks ifEmpty: [
		^ 'No tasks were completed successfully.' ].

	summarizerAgent := team agentForRole: ChatPharoSummarizerRole.
	summarizerAgent ifNil: [ ^ completedTasks first result ].

	"Build merge prompt with all results"
	mergePrompt := String streamContents: [ :stream |
		stream
			nextPutAll: 'Synthesize the following task results into a coherent, comprehensive response:';
			cr; cr.

		completedTasks do: [ :task |
			stream
				nextPutAll: '--- Task: ';
				nextPutAll: task description;
				nextPutAll: ' ---';
				cr;
				nextPutAll: task result;
				cr; cr ] ].

	^ summarizerAgent getResponseForPrompt: mergePrompt
]

{ #category : 'private' }
ChatPharoDirector >> parseTaskDescriptions: responseText [
	"Parse task descriptions from director's planning response"

	| lines parsedTasks |

	lines := responseText lines select: [ :line |
		line notEmpty and: [ line includesSubstring: '[' ] ].

	parsedTasks := lines collect: [ :line |
		| role priority description |

		"Extract role"
		role := (line copyFrom: (line indexOf: $[) + 1 to: (line indexOf: $]) - 1) trimBoth.
		role := self roleClassFromString: role.

		"Extract priority"
		priority := (line includesSubstring: 'Priority:')
			ifTrue: [
				| prioStart |
				prioStart := (line indexOfSubCollection: 'Priority:') + 9.
				(line copyFrom: prioStart to: (line indexOf: $) startingAt: prioStart) - 1) trimBoth asInteger ]
			ifFalse: [ 5 ].

		"Extract description (everything after the last ')')"
		description := (line copyAfterLast: $)) trimBoth.

		Dictionary new
			at: #role put: role;
			at: #priority put: priority;
			at: #description put: description;
			yourself ].

	^ parsedTasks
]

{ #category : 'private' }
ChatPharoDirector >> planningSystemPrompt [

	^ planningSystemPrompt
]

{ #category : 'private' }
ChatPharoDirector >> planningSystemPrompt: aString [

	planningSystemPrompt := aString
]

{ #category : 'private' }
ChatPharoDirector >> roleClassFromString: aString [
	"Convert role name string to role class"

	| roleMap |

	roleMap := Dictionary new
		at: 'Coder' put: ChatPharoCoderRole;
		at: 'Researcher' put: ChatPharoResearcherRole;
		at: 'Summarizer' put: ChatPharoSummarizerRole;
		yourself.

	^ roleMap at: aString ifAbsent: [ nil ]
]

{ #category : 'accessing' }
ChatPharoDirector >> tasks [

	^ tasks
]

{ #category : 'accessing' }
ChatPharoDirector >> team [

	^ team
]

{ #category : 'accessing' }
ChatPharoDirector >> team: anAgentTeam [

	team := anAgentTeam
]
