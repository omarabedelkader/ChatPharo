"
An **Agent Team** manages a collection of specialized agents working together.
* Maintains a roster of agents, each with a specific role
* Provides agent lookup by role type
* Can add, remove, and configure team members
* **Why** – organizes specialized agents into a cohesive team structure
Example:
```smalltalk
team := ChatPharoAgentTeam new
    addAgent: coderAgent withRole: ChatPharoCoderRole new;
    addAgent: researcherAgent withRole: ChatPharoResearcherRole new;
    yourself.
agent := team agentForRole: ChatPharoCoderRole.
"
Class {
	#name : 'ChatPharoAgentTeam',
	#superclass : 'Object',
	#instVars : [
		'members',
		'name'
	],
	#category : 'AI-ChatPharo-Director',
	#package : 'AI-ChatPharo-Director'
}

{ #category : 'as yet unclassified' }
ChatPharoAgentTeam class >> withBaseAgent: aBaseAgent [
	"Create a team with default specialized agents based on the given agent"

	^ self new
		createDefaultTeamFrom: aBaseAgent;
		yourself
]

{ #category : 'adding' }
ChatPharoAgentTeam >> addAgent: anAgent withRole: aRole [
	"Add an agent with a specific role to the team"

	self members at: aRole class put: anAgent.
	anAgent systemPrompt: aRole systemPrompt.
	^ anAgent
]

{ #category : 'accessing' }
ChatPharoAgentTeam >> agentForRole: aRoleClass [
	"Get the agent assigned to a specific role"

	^ self members at: aRoleClass ifAbsent: [ nil ]
]

{ #category : 'private' }
ChatPharoAgentTeam >> createDefaultTeamFrom: baseAgent [
	"Create a default team with Coder, Researcher, and Summarizer roles"

	| coder researcher summarizer |

	"Clone the base agent for each role"
	coder := baseAgent copy.
	researcher := baseAgent copy.
	summarizer := baseAgent copy.

	"Assign roles"
	self addAgent: coder withRole: ChatPharoCoderRole new.
	self addAgent: researcher withRole: ChatPharoResearcherRole new.
	self addAgent: summarizer withRole: ChatPharoSummarizerRole new.

	^ self
]

{ #category : 'testing' }
ChatPharoAgentTeam >> hasRole: aRoleClass [
	"Check if the team has an agent for the given role"

	^ self members includesKey: aRoleClass
]

{ #category : 'accessing' }
ChatPharoAgentTeam >> initialize [

	super initialize.
	members := Dictionary new.
	name := 'Team'
]

{ #category : 'accessing' }
ChatPharoAgentTeam >> members [

	^ members
]

{ #category : 'accessing' }
ChatPharoAgentTeam >> members: aDictionary [

	members := aDictionary
]

{ #category : 'accessing' }
ChatPharoAgentTeam >> name [

	^ name
]

{ #category : 'accessing' }
ChatPharoAgentTeam >> name: aString [

	name := aString
]

{ #category : 'removing' }
ChatPharoAgentTeam >> removeRole: aRoleClass [
	"Remove the agent assigned to a specific role"

	self members removeKey: aRoleClass ifAbsent: [  ]
]

{ #category : 'removing' }
ChatPharoAgentTeam >> roles [
	"Return all role classes in the team"

	^ self members keys
]

{ #category : 'accessing' }
ChatPharoAgentTeam >> size [
	"Return the number of agents in the team"

	^ self members size
]
