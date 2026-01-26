"
Immutable value object representing a single memory entry.
Captures user interactions, learned preferences, and experiences for later retrieval.
Memory types:
- 'conversation_summary': Summary of a completed conversation
- 'user_preference': Learned user preference (e.g., preferred code style)
- 'topic_knowledge': Knowledge about a topic discussed with the user
- 'feedback': User feedback on responses (positive/negative)
- 'correction': User correction of assistant's behavior
## Usage:
```smalltalk
ChatPharoMemoryItem
    type: 'user_preference'
    content: 'User prefers verbose code explanations'
    metadata: (Dictionary new
        at: 'source' put: 'explicit_feedback';
        yourself).
```
"
Class {
	#name : 'ChatPharoMemoryItem',
	#superclass : 'Object',
	#instVars : [
		'id',
		'type',
		'content',
		'metadata',
		'timestamp',
		'importance',
		'tags'
	],
	#category : 'AI-ChatPharo-Memory',
	#package : 'AI-ChatPharo-Memory'
}

{ #category : 'accessing' }
ChatPharoMemoryItem class >> content: aString [
	"Create a general memory item with just content"

	^ self type: 'general' content: aString metadata: Dictionary new
]

{ #category : 'accessing' }
ChatPharoMemoryItem class >> conversationSummary: aString [
	"Create a conversation summary memory"

	^ self type: 'conversation_summary' content: aString metadata: Dictionary new
]

{ #category : 'accessing' }
ChatPharoMemoryItem class >> correction: aString [
	"Create a correction memory"

	^ self type: 'correction' content: aString metadata: Dictionary new
]

{ #category : 'accessing' }
ChatPharoMemoryItem class >> feedback: aString positive: aBoolean [
	"Create a feedback memory"

	^ self
		  type: 'feedback'
		  content: aString
		  metadata: (Dictionary new
				   at: 'positive' put: aBoolean;
				   yourself)
]

{ #category : 'accessing' }
ChatPharoMemoryItem class >> topicKnowledge: aString topic: topicName [
	"Create a topic knowledge memory"

	^ self
		  type: 'topic_knowledge'
		  content: aString
		  metadata: (Dictionary new
				   at: 'topic' put: topicName;
				   yourself)
]

{ #category : 'accessing' }
ChatPharoMemoryItem class >> type: aType content: aContent metadata: aMetadata [
	"Create a new memory item with the given type, content, and metadata"

	^ self new
		  type: aType;
		  content: aContent;
		  metadata: aMetadata;
		  yourself
]

{ #category : 'accessing' }
ChatPharoMemoryItem class >> userPreference: aString [
	"Create a user preference memory"

	^ self type: 'user_preference' content: aString metadata: Dictionary new
]

{ #category : 'adding' }
ChatPharoMemoryItem >> addTag: aString [
	"Add a tag to this memory item"

	(tags includes: aString) ifFalse: [ tags add: aString ]
]

{ #category : 'adding' }
ChatPharoMemoryItem >> ageInDays [
	"Return the age of this memory in days"

	^ (DateAndTime now - timestamp) asDuration asDays
]

{ #category : 'adding' }
ChatPharoMemoryItem >> asContextString [
	"Return a string representation suitable for LLM context injection"

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: '[Memory: ';
			  nextPutAll: type;
			  nextPutAll: '] ';
			  nextPutAll: content ]
]

{ #category : 'adding' }
ChatPharoMemoryItem >> content [

	^ content
]

{ #category : 'adding' }
ChatPharoMemoryItem >> content: anObject [

	content := anObject
]

{ #category : 'adding' }
ChatPharoMemoryItem >> hasTag: aString [
	"Check if this memory has a specific tag"

	^ tags includes: aString
]

{ #category : 'adding' }
ChatPharoMemoryItem >> id [

	^ id
]

{ #category : 'adding' }
ChatPharoMemoryItem >> id: anObject [

	id := anObject
]

{ #category : 'adding' }
ChatPharoMemoryItem >> importance [

	^ importance
]

{ #category : 'adding' }
ChatPharoMemoryItem >> importance: aNumber [
	"Set importance (0.0 to 1.0)"

	importance := (aNumber max: 0.0) min: 1.0
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> initialize [

	super initialize.
	id := UUID new asString.
	timestamp := DateAndTime now.
	importance := 0.5.
	tags := OrderedCollection new.
	metadata := Dictionary new.
	type := 'general'.
	content := ''
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> isConversationSummary [

	^ type = 'conversation_summary'
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> isCorrection [

	^ type = 'correction'
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> isFeedback [

	^ type = 'feedback'
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> isTopicKnowledge [

	^ type = 'topic_knowledge'
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> isUserPreference [

	^ type = 'user_preference'
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> matchesKeywords: keywordCollection [
	"Check if this memory matches any of the given keywords"

	| lowerContent |
	lowerContent := content asLowercase.
	^ keywordCollection anySatisfy: [ :keyword |
		  (lowerContent includesSubstring: keyword asLowercase) or: [
			  tags anySatisfy: [ :tag | tag asLowercase = keyword asLowercase ] ] ]
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> metadata [

	^ metadata
]

{ #category : 'initialization' }
ChatPharoMemoryItem >> metadata: anObject [

	metadata := anObject
]

{ #category : 'printing' }
ChatPharoMemoryItem >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: type;
		nextPutAll: ': ';
		nextPutAll: (content truncateTo: 30);
		nextPutAll: ')'
]

{ #category : 'printing' }
ChatPharoMemoryItem >> removeTag: aString [
	"Remove a tag from this memory item"

	tags remove: aString ifAbsent: [ ]
]

{ #category : 'printing' }
ChatPharoMemoryItem >> tags [

	^ tags
]

{ #category : 'printing' }
ChatPharoMemoryItem >> tags: aCollection [

	tags := aCollection asOrderedCollection
]

{ #category : 'printing' }
ChatPharoMemoryItem >> timestamp [

	^ timestamp
]

{ #category : 'printing' }
ChatPharoMemoryItem >> timestamp: anObject [

	timestamp := anObject
]

{ #category : 'printing' }
ChatPharoMemoryItem >> type [

	^ type
]

{ #category : 'printing' }
ChatPharoMemoryItem >> type: anObject [

	type := anObject
]
