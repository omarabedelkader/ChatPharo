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
ChatPharoDirectorTest >> testDirectorMergeResultsWithNoTasks [

	| result |
	result := director mergeResults.
	self assert: result equals: 'No tasks were completed successfully.'
]

{ #category : 'running' }
ChatPharoDirectorTest >> testDirectorPlanningSystemPrompt [

	self assert: director planningSystemPrompt notNil.
	self assert: (director planningSystemPrompt includesSubstring: 'project manager')
]

{ #category : 'running' }
ChatPharoDirectorTest >> testDirectorPlanningSystemPromptSetter [

	director planningSystemPrompt: 'Custom prompt'.
	self assert: director planningSystemPrompt equals: 'Custom prompt'
]

{ #category : 'running' }
ChatPharoDirectorTest >> testDirectorRoleClassFromString [

	self assert: (director roleClassFromString: 'Coder') equals: ChatPharoCoderRole.
	self assert: (director roleClassFromString: 'Researcher') equals: ChatPharoResearcherRole.
	self assert: (director roleClassFromString: 'Summarizer') equals: ChatPharoSummarizerRole.
	self assert: (director roleClassFromString: 'Unknown') isNil
]

{ #category : 'running' }
ChatPharoDirectorTest >> testDirectorTasksInitiallyEmpty [

	self assert: director tasks isEmpty
]

{ #category : 'running' }
ChatPharoDirectorTest >> testDirectorTeamSetter [

	| newTeam |
	newTeam := ChatPharoAgentTeam new.
	director team: newTeam.
	self assert: director team equals: newTeam
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
ChatPharoDirectorTest >> testTaskAssignedAgent [

	| task |
	task := ChatPharoTask description: 'Test'.
	self assert: task assignedAgent isNil.

	task assignedAgent: baseAgent.
	self assert: task assignedAgent equals: baseAgent
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
ChatPharoDirectorTest >> testTaskFailed [

	| task |
	task := ChatPharoTask description: 'Test'.
	task status: #failed.

	self assert: task isFailed.
	self deny: task isCompleted.
	self deny: task isPending
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskIsNotReadyWithPendingDependencies [

	| task1 task2 |
	task1 := ChatPharoTask description: 'Dependency'.

	task2 := ChatPharoTask description: 'Main task'.
	task2 dependencies add: task1.

	self deny: task2 isReady
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskIsPending [

	| task |
	task := ChatPharoTask description: 'Test'.
	self assert: task isPending.
	self deny: task isCompleted.
	self deny: task isFailed
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskIsReadyWithCompletedDependencies [

	| task1 task2 |
	task1 := ChatPharoTask description: 'Dependency'.
	task1 status: #completed.

	task2 := ChatPharoTask description: 'Main task'.
	task2 dependencies add: task1.

	self assert: task2 isReady
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskIsReadyWithNoDependencies [

	| task |
	task := ChatPharoTask description: 'Test'.
	self assert: task isReady
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskMetadata [

	| task |
	task := ChatPharoTask description: 'Test'.
	self assert: task metadata isDictionary.
	self assert: task metadata isEmpty.

	task metadata at: 'key' put: 'value'.
	self assert: (task metadata at: 'key') equals: 'value'
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskPrioritySetter [

	| task |
	task := ChatPharoTask description: 'Test'.
	self assert: task priority equals: 5.

	task priority: 1.
	self assert: task priority equals: 1
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskResult [

	| task |
	task := ChatPharoTask description: 'Test'.
	self assert: task result isNil.

	task result: 'Some result'.
	self assert: task result equals: 'Some result'
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTaskStatusTransitions [

	| task |
	task := ChatPharoTask description: 'Test'.

	self assert: task isPending.

	task status: #assigned.
	self deny: task isPending.

	task status: #in_progress.
	self deny: task isPending.

	task status: #completed.
	self assert: task isCompleted.
	self deny: task isFailed
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
ChatPharoDirectorTest >> testTeamAddAgentWithRole [

	| team agent |
	team := ChatPharoAgentTeam new.
	agent := ChatPharoNullAgent new.

	team addAgent: agent withRole: ChatPharoCoderRole new.

	self assert: team size equals: 1.
	self assert: (team hasRole: ChatPharoCoderRole).
	self assert: (team agentForRole: ChatPharoCoderRole) equals: agent
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamAgentForMissingRole [

	| team result |
	team := ChatPharoAgentTeam new.
	result := team agentForRole: ChatPharoCoderRole.

	self assert: result isNil
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamAgentGetsRoleSystemPrompt [

	| team coderAgent |
	team := ChatPharoAgentTeam withBaseAgent: ChatPharoNullAgent new.
	coderAgent := team agentForRole: ChatPharoCoderRole.

	self assert: (coderAgent systemPrompt includesSubstring: 'Pharo')
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

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamName [

	| team |
	team := ChatPharoAgentTeam new.
	self assert: team name equals: 'Team'.

	team name: 'Custom Team'.
	self assert: team name equals: 'Custom Team'
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamRemoveNonExistentRole [

	| team |
	team := director team.
	team removeRole: 'FakeRole'.
	self assert: team size equals: 3
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamRemoveRole [

	| team |
	team := director team.

	self assert: team size equals: 3.
	team removeRole: ChatPharoCoderRole.
	self assert: team size equals: 2.
	self deny: (team hasRole: ChatPharoCoderRole)
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamRoles [

	| team roles |
	team := director team.
	roles := team roles.

	self assert: roles size equals: 3.
	self assert: (roles includes: ChatPharoCoderRole).
	self assert: (roles includes: ChatPharoResearcherRole).
	self assert: (roles includes: ChatPharoSummarizerRole)
]

{ #category : 'running' }
ChatPharoDirectorTest >> testTeamWithBaseAgent [

	| team |
	team := ChatPharoAgentTeam withBaseAgent: ChatPharoNullAgent new.

	self assert: team size equals: 3.
	self assert: (team hasRole: ChatPharoCoderRole).
	self assert: (team hasRole: ChatPharoResearcherRole).
	self assert: (team hasRole: ChatPharoSummarizerRole)
]
