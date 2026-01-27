"
An **Agent Role** defines a specialization for an agent in the team.
* Provides a system prompt tailored to the role's expertise
* Defines capabilities and skills for specific types of tasks
* Can customize agent parameters (temperature, tokens, etc.) for the role
* **Why** – enables agents to specialize in different domains (coding, research, summarization, etc.)
Example:
```smalltalk
role := ChatPharoCoderRole new.
role systemPrompt. """"Returns coder-specific instructions""""
"
Class {
	#name : 'ChatPharoAgentRole',
	#superclass : 'Object',
	#instVars : [
		'name',
		'systemPrompt',
		'capabilities',
		'customParameters'
	],
	#category : 'AI-ChatPharo-Director',
	#package : 'AI-ChatPharo-Director'
}

{ #category : 'default' }
ChatPharoAgentRole class >> defaultName [
	"Return the default name for this role"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
ChatPharoAgentRole >> capabilities [

	^ capabilities ifNil: [ capabilities := OrderedCollection new ]
]

{ #category : 'accessing' }
ChatPharoAgentRole >> capabilities: aCollection [

	capabilities := aCollection
]

{ #category : 'accessing' }
ChatPharoAgentRole >> customParameters [

	^ customParameters ifNil: [ customParameters := Dictionary new ]
]

{ #category : 'accessing' }
ChatPharoAgentRole >> customParameters: aDictionary [

	customParameters := aDictionary
]

{ #category : 'accessing' }
ChatPharoAgentRole >> initialize [

	super initialize.
	name := self class defaultName.
	systemPrompt := self class defaultSystemPrompt.
	capabilities := OrderedCollection new.
	customParameters := Dictionary new
]

{ #category : 'accessing' }
ChatPharoAgentRole >> name [

	^ name
]

{ #category : 'accessing' }
ChatPharoAgentRole >> name: aString [

	name := aString
]

{ #category : 'accessing' }
ChatPharoAgentRole >> systemPrompt [

	^ systemPrompt
]

{ #category : 'accessing' }
ChatPharoAgentRole >> systemPrompt: aString [

	systemPrompt := aString
]
