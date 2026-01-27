"
A **Task** represents a unit of work to be assigned to a specialized agent.
* Holds the task description, assigned role, current status, and result
* Tracks task lifecycle: pending → assigned → in_progress → completed or failed
* Can specify which specialized role should handle this task
* **Why** – enables the director to decompose complex requests into manageable subtasks and track their progress


```smalltalk
task := ChatPharoTask new
    description: 'Analyze the authentication system';
    requiredRole: ChatPharoResearcherRole;
    yourself.
"
Class {
	#name : 'ChatPharoTask',
	#superclass : 'Object',
	#instVars : [
		'description',
		'requiredRole',
		'status',
		'result',
		'assignedAgent',
		'priority',
		'dependencies',
		'metadata'
	],
	#category : 'AI-ChatPharo-Director',
	#package : 'AI-ChatPharo-Director'
}

{ #category : 'accessing' }
ChatPharoTask class >> description: aString [
	"Create a new task with the given description"

	^ self new
		description: aString;
		yourself
]

{ #category : 'accessing' }
ChatPharoTask class >> description: aString role: aRoleClass [
	"Create a new task with description and required role"

	^ self new
		description: aString;
		requiredRole: aRoleClass;
		yourself
]

{ #category : 'accessing' }
ChatPharoTask >> assignedAgent [

	^ assignedAgent
]

{ #category : 'accessing' }
ChatPharoTask >> assignedAgent: anAgent [

	assignedAgent := anAgent
]

{ #category : 'accessing' }
ChatPharoTask >> dependencies [

	^ dependencies ifNil: [ dependencies := OrderedCollection new ]
]

{ #category : 'accessing' }
ChatPharoTask >> dependencies: aCollection [

	dependencies := aCollection
]

{ #category : 'accessing' }
ChatPharoTask >> description [

	^ description
]

{ #category : 'accessing' }
ChatPharoTask >> description: aString [

	description := aString
]

{ #category : 'accessing' }
ChatPharoTask >> initialize [

	super initialize.
	status := #pending.
	priority := 5. "Default medium priority (1-10 scale)"
	dependencies := OrderedCollection new.
	metadata := Dictionary new
]

{ #category : 'testing' }
ChatPharoTask >> isCompleted [

	^ status = #completed
]

{ #category : 'testing' }
ChatPharoTask >> isFailed [

	^ status = #failed
]

{ #category : 'testing' }
ChatPharoTask >> isPending [

	^ status = #pending
]

{ #category : 'testing' }
ChatPharoTask >> isReady [
	"Check if all dependencies are completed"

	^ self dependencies allSatisfy: [ :task | task isCompleted ]
]

{ #category : 'accessing' }
ChatPharoTask >> metadata [

	^ metadata
]

{ #category : 'accessing' }
ChatPharoTask >> metadata: aDictionary [

	metadata := aDictionary
]

{ #category : 'accessing' }
ChatPharoTask >> priority [

	^ priority
]

{ #category : 'accessing' }
ChatPharoTask >> priority: anInteger [
	"Set priority (1-10, where 1 is highest priority)"

	priority := anInteger
]

{ #category : 'accessing' }
ChatPharoTask >> requiredRole [

	^ requiredRole
]

{ #category : 'accessing' }
ChatPharoTask >> requiredRole: aRoleClass [

	requiredRole := aRoleClass
]

{ #category : 'accessing' }
ChatPharoTask >> result [

	^ result
]

{ #category : 'accessing' }
ChatPharoTask >> result: anObject [

	result := anObject
]

{ #category : 'accessing' }
ChatPharoTask >> status [ 

	^ status
]

{ #category : 'accessing' }
ChatPharoTask >> status: aSymbol [
	"Set task status: #pending, #assigned, #in_progress, #completed, #failed"

	status := aSymbol
]
