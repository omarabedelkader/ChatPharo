Class {
	#name : 'ChatPharoDirectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'director',
		'baseAgent'
	],
	#category : 'AI-ChatPharo-Tests-Director',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Director'
}

{ #category : 'examples' }
ChatPharoDirectorTest class >> exampleBasicUsage [ 
	"Demonstrates basic director usage with a simple request"
	<example>

	| director agent response |

	"Create a base agent (use your preferred agent type)"
	agent := ChatPharoClaudeAgent new
		apiKey: 'your-api-key-here';
		model: 'claude-sonnet-4-20250514';
		yourself.

	"Create director with automatic team"
	director := ChatPharoDirector withAgent: agent.

	"Handle a complex request - director will decompose and coordinate"
	response := director handleRequest: 'Analyze the ChatPharoAgent class hierarchy and suggest improvements'.

	"The director will:
	  1. Assign research task to Researcher agent
	  2. Assign improvement task to Coder agent
	  3. Merge results with Summarizer agent"

	^ response
]

{ #category : 'examples' }
ChatPharoDirectorTest class >> exampleCustomTeam [
	"Demonstrates creating a custom team with specific agents"
	<example>

	| director team coder researcher summarizer baseAgent |

	"Create base agent"
	baseAgent := ChatPharoClaudeAgent new
		apiKey: 'your-api-key-here';
		model: 'claude-sonnet-4-20250514';
		yourself.

	"Create specialized agents"
	coder := baseAgent copy.
	researcher := baseAgent copy.
	summarizer := baseAgent copy.

	"Build custom team"
	team := ChatPharoAgentTeam new
		addAgent: coder withRole: ChatPharoCoderRole new;
		addAgent: researcher withRole: ChatPharoResearcherRole new;
		addAgent: summarizer withRole: ChatPharoSummarizerRole new;
		yourself.

	"Create director with custom team"
	director := ChatPharoDirector new
		baseAgent: baseAgent;
		team: team;
		yourself.

	^ director handleRequest: 'Implement a caching system for API responses'
]

{ #category : 'examples' }
ChatPharoDirectorTest class >> exampleManualTaskAssignment [
	"Demonstrates manual task creation and assignment"
	<example>

	| director team task1 task2 task3 |

	director := self setupDirector.
	team := director team.

	"Create specific tasks manually"
	task1 := ChatPharoTask
		description: 'Find all authentication-related classes'
		role: ChatPharoResearcherRole.

	task2 := ChatPharoTask
		description: 'Implement two-factor authentication'
		role: ChatPharoCoderRole.

	task3 := ChatPharoTask
		description: 'Summarize authentication improvements'
		role: ChatPharoSummarizerRole.

	"Set up dependencies - task2 depends on task1"
	task2 dependencies add: task1.
	task3 dependencies add: task2.

	"Execute tasks"
	director tasks: { task1. task2. task3 }.
	director executeTasks.

	^ director mergeResults
]

{ #category : 'examples' }
ChatPharoDirectorTest class >> exampleRoleSpecialization [
	"Demonstrates how different roles handle the same request differently"
	<example>

	| baseAgent coder researcher summarizer request |

	baseAgent := self createMockAgent.
	request := 'Explain the Observer pattern'.

	"Each role interprets the request through their specialization"
	coder := baseAgent copy systemPrompt: ChatPharoCoderRole new systemPrompt.
	researcher := baseAgent copy systemPrompt: ChatPharoResearcherRole new systemPrompt.
	summarizer := baseAgent copy systemPrompt: ChatPharoSummarizerRole new systemPrompt.

	^ Dictionary new
		at: 'Coder' put: (coder getResponseForPrompt: request);
		at: 'Researcher' put: (researcher getResponseForPrompt: request);
		at: 'Summarizer' put: (summarizer getResponseForPrompt: request);
		yourself
]

{ #category : 'running' }
ChatPharoDirectorTest >> createMockAgent [
	"Create a mock agent for testing (replace with real agent in production)"

	^ ChatPharoNullAgent new
]

{ #category : 'running' }
ChatPharoDirectorTest >> setUp [

	super setUp.
	baseAgent := self createMockAgent.
	director := ChatPharoDirector withAgent: baseAgent
]

{ #category : 'running' }
ChatPharoDirectorTest >> testDirectorCreation [

	self assert: director notNil.
	self assert: director team notNil.
	self assert: director team size equals: 3. "Coder, Researcher, Summarizer"
]

{ #category : 'running' }
ChatPharoDirectorTest >> testRoleCreation [

	| coderRole researcherRole summarizerRole |

	coderRole := ChatPharoCoderRole new.
	researcherRole := ChatPharoResearcherRole new.
	summarizerRole := ChatPharoSummarizerRole new.

	self assert: coderRole name equals: 'Coder'.
	self assert: researcherRole name equals: 'Researcher'.
	self assert: summarizerRole name equals: 'Summarizer'.

	self assert: coderRole systemPrompt notNil.
	self assert: researcherRole systemPrompt notNil.
	self assert: summarizerRole systemPrompt notNil
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskCreation [

	| task |

	task := ChatPharoTask description: 'Test task'.

	self assert: task description equals: 'Test task'.
	self assert: task status equals: #pending.
	self assert: task priority equals: 5.
	self assert: task dependencies isEmpty
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskWithRole [

	| task |

	task := ChatPharoTask
		description: 'Write code'
		role: ChatPharoCoderRole.

	self assert: task requiredRole equals: ChatPharoCoderRole
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamAgentLookup [

	| team coder |

	team := director team.
	coder := team agentForRole: ChatPharoCoderRole.

	self assert: coder notNil.
	self assert: (coder systemPrompt includesSubstring: 'Pharo')
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamHasAllRoles [

	| team |

	team := director team.

	self assert: (team hasRole: ChatPharoCoderRole).
	self assert: (team hasRole: ChatPharoResearcherRole).
	self assert: (team hasRole: ChatPharoSummarizerRole)
]
