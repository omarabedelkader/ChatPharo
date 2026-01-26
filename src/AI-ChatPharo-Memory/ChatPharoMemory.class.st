"
Central registry for ChatPharo long-term memory.
Manages the storage, retrieval, and lifecycle of memory items.
Persists memories to disk using STON format.
## Features:
- Persistent storage across sessions
- Memory search by keywords, type, and tags
- Automatic cleanup of old memories based on retention settings
- Context injection for LLM conversations
- Memory importance scoring for relevance ranking
## Usage:
```smalltalk
""""Add a new memory""""
ChatPharoMemory default addMemory: (ChatPharoMemoryItem userPreference: 'User prefers Spec2 for UI').
""""Retrieve relevant memories for a query""""
ChatPharoMemory default memoriesForQuery: 'How do I create a button?'.
""""Get context string for LLM injection""""
ChatPharoMemory default contextForQuery: 'Spec2 button creation'.
""""Clear all memories""""
ChatPharoMemory default clearAllMemories.
"
Class {
	#name : 'ChatPharoMemory',
	#superclass : 'Object',
	#instVars : [
		'memories',
		'enabled',
		'retentionDays',
		'maxMemories',
		'autoSummarize'
	],
	#classInstVars : [
		'default'
	],
	#category : 'AI-ChatPharo-Memory',
	#package : 'AI-ChatPharo-Memory'
}

{ #category : 'accessing' }
ChatPharoMemory class >> default [
	"Return the default memory registry, loading from disk if necessary"

	default ifNil: [ default := self loadOrNew ].
	^ default
]

{ #category : 'accessing' }
ChatPharoMemory class >> loadOrNew [
	"Load memory from disk or create a new instance"

	| path |
	path := self memoryFileReference.
	path exists ifFalse: [ ^ self new ].

	^ path readStreamDo: [ :file |
		  [
		  | loaded |
		  loaded := STON fromStream: file.
		  loaded enabled ifNil: [ loaded privateSetEnabled: true ].
		  loaded retentionDays ifNil: [ loaded privateSetRetentionDays: 30 ].
		  loaded maxMemories ifNil: [ loaded privateSetMaxMemories: 1000 ].
		  loaded autoSummarize ifNil: [ loaded privateSetAutoSummarize: true ].
		  loaded ]
			  on: Error
			  do: [ self new ] ]
]

{ #category : 'accessing' }
ChatPharoMemory class >> memoryDirectory [
	"Return the directory for memory storage"

	^ FileLocator imageDirectory / 'chatpharo'
]

{ #category : 'accessing' }
ChatPharoMemory class >> memoryFileReference [
	"Return the file reference for memory storage"

	^ self memoryDirectory / 'memory.ston'
]

{ #category : 'class initialization' }
ChatPharoMemory class >> reset [
	"Reset the default memory registry"

	<script>
	default := nil
]

{ #category : 'accessing' }
ChatPharoMemory class >> resetAndDelete [
	"Reset the registry and delete the storage file"

	<script>
	| path |
	default := nil.
	path := self memoryFileReference.
	path deleteIfAbsent: [ ]
]

{ #category : 'class initialization' }
ChatPharoMemory class >> saveDefault [
	"Save the default memory to disk"

	| path |
	default ifNil: [ ^ self ].
	path := self memoryFileReference.
	path parent ensureCreateDirectory.
	path deleteIfAbsent: [ ].
	path writeStreamDo: [ :stream | STON put: default onStream: stream ].
	^ self
]

{ #category : 'class initialization' }
ChatPharoMemory class >> setDefault: aMemory [
	"Set the default memory instance"

	default := aMemory
]

{ #category : 'adding' }
ChatPharoMemory >> addConversationSummary: aString [
	"Add a conversation summary memory"

	^ self addMemory: (ChatPharoMemoryItem conversationSummary: aString)
]

{ #category : 'adding' }
ChatPharoMemory >> addCorrection: aString [
	"Add a correction memory"

	| memory |
	memory := ChatPharoMemoryItem correction: aString.
	memory importance: 0.9. "Corrections are highly important"
	^ self addMemory: memory
]

{ #category : 'adding' }
ChatPharoMemory >> addFeedback: aString positive: aBoolean [
	"Add a feedback memory"

	| memory |
	memory := ChatPharoMemoryItem feedback: aString positive: aBoolean.
	memory importance: 0.7.
	^ self addMemory: memory
]

{ #category : 'adding' }
ChatPharoMemory >> addMemory: aMemoryItem [
	"Add a new memory item to the registry"

	enabled ifFalse: [ ^ aMemoryItem ].
	memories add: aMemoryItem.
	self enforceMemoryLimit.
	self class saveDefault.
	ChatPharoLogger logSystem: 'Memory item added'
		details: (Dictionary new
				 at: 'type' put: aMemoryItem type;
				 at: 'id' put: aMemoryItem id;
				 at: 'totalMemories' put: memories size;
				 yourself).
	^ aMemoryItem
]

{ #category : 'adding' }
ChatPharoMemory >> addTopicKnowledge: aString topic: topicName [
	"Add a topic knowledge memory"

	| memory |
	memory := ChatPharoMemoryItem topicKnowledge: aString topic: topicName.
	memory addTag: topicName.
	^ self addMemory: memory
]

{ #category : 'adding' }
ChatPharoMemory >> addUserPreference: aString [
	"Add a user preference memory"

	| memory |
	memory := ChatPharoMemoryItem userPreference: aString.
	memory importance: 0.8. "User preferences are important"
	^ self addMemory: memory
]

{ #category : 'adding' }
ChatPharoMemory >> allMemories [
	"Return all stored memories"

	^ memories
]

{ #category : 'adding' }
ChatPharoMemory >> autoSummarize [

	^ autoSummarize ifNil: [ autoSummarize := true ]
]

{ #category : 'adding' }
ChatPharoMemory >> autoSummarize: aBoolean [

	autoSummarize := aBoolean.
	self class saveDefault
]

{ #category : 'adding' }
ChatPharoMemory >> cleanupExpiredMemories [
	"Remove memories older than retentionDays"

	| expired |
	retentionDays ifNil: [ ^ self ].
	expired := memories select: [ :m | m ageInDays > retentionDays ].
	expired do: [ :m | memories remove: m ifAbsent: [ ] ].
	expired ifNotEmpty: [
		self class saveDefault.
		ChatPharoLogger logSystem: 'Expired memories cleaned up'
			details: (Dictionary new
					 at: 'removedCount' put: expired size;
					 at: 'retentionDays' put: retentionDays;
					 yourself) ]
]

{ #category : 'adding' }
ChatPharoMemory >> clearAllMemories [
	"Remove all stored memories"

	memories removeAll.
	self class saveDefault.
	ChatPharoLogger logSystem: 'All memories cleared' details: Dictionary new
]

{ #category : 'adding' }
ChatPharoMemory >> contextForEnabledMemories [
	"Return combined context string for all memories, sorted by importance"

	| relevantMemories |
	enabled ifFalse: [ ^ '' ].
	memories ifEmpty: [ ^ '' ].

	relevantMemories := memories sorted: [ :a :b | a importance > b importance ].
	relevantMemories := relevantMemories first: (10 min: relevantMemories size).

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: '### LONG-TERM MEMORY CONTEXT ###';
			  cr;
			  cr.
		  relevantMemories do: [ :memory |
			  stream
				  nextPutAll: memory asContextString;
				  cr ] ]
]

{ #category : 'adding' }
ChatPharoMemory >> contextForQuery: queryString [
	"Return context string for memories relevant to the query"

	| relevantMemories keywords |
	enabled ifFalse: [ ^ '' ].
	memories ifEmpty: [ ^ '' ].

	keywords := self extractKeywordsFrom: queryString.
	relevantMemories := self memoriesForKeywords: keywords.

	"Also include high-importance user preferences and corrections"
	relevantMemories := relevantMemories , (memories select: [ :m |
			                    (m isUserPreference or: [ m isCorrection ]) and: [
				                    m importance >= 0.7 ] ]).
	relevantMemories := relevantMemories asSet asOrderedCollection.
	relevantMemories := relevantMemories sorted: [ :a :b |
		                    a importance > b importance ].
	relevantMemories := relevantMemories first:
		                    (10 min: relevantMemories size).

	relevantMemories ifEmpty: [ ^ '' ].

	^ String streamContents: [ :stream |
		  stream
			  nextPutAll: '### RELEVANT MEMORY CONTEXT ###';
			  cr;
			  nextPutAll: '(Based on query keywords: ';
			  nextPutAll: (keywords joinUsing: ', ');
			  nextPutAll: ')';
			  cr;
			  cr.
		  relevantMemories do: [ :memory |
			  stream
				  nextPutAll: memory asContextString;
				  cr ] ]
]

{ #category : 'adding' }
ChatPharoMemory >> enabled [

	^ enabled ifNil: [ enabled := true ]
]

{ #category : 'adding' }
ChatPharoMemory >> enabled: aBoolean [

	enabled := aBoolean.
	self class saveDefault.
	ChatPharoLogger logSystem: 'Memory tracking toggled'
		details: (Dictionary new
				 at: 'enabled' put: aBoolean;
				 yourself)
]

{ #category : 'private' }
ChatPharoMemory >> enforceMemoryLimit [
	"Remove oldest memories if limit is exceeded"

	| toRemove |
	maxMemories ifNil: [ ^ self ].
	memories size <= maxMemories ifTrue: [ ^ self ].

	"Sort by importance (ascending) then age (oldest first) for removal"
	memories := (memories sorted: [ :a :b |
		             a importance = b importance
			             ifTrue: [ a timestamp < b timestamp ]
			             ifFalse: [ a importance > b importance ] ])
		            asOrderedCollection.

	toRemove := memories size - maxMemories.
	toRemove timesRepeat: [ memories removeLast ]
]

{ #category : 'private' }
ChatPharoMemory >> extractKeywordsFrom: queryString [
	"Extract potential keywords from a query string"

	| words |
	words := queryString substrings.
	^ words select: [ :word |
		  word size > 2 and: [
			  word first isUppercase or: [ word anySatisfy: [ :c | c isUppercase ] ] ] ]
]

{ #category : 'initialization' }
ChatPharoMemory >> initialize [

	super initialize.
	memories := OrderedCollection new.
	enabled := true.
	retentionDays := 30.
	maxMemories := 1000.
	autoSummarize := true
]

{ #category : 'accessing' }
ChatPharoMemory >> maxMemories [

	^ maxMemories ifNil: [ maxMemories := 1000 ]
]

{ #category : 'accessing' }
ChatPharoMemory >> maxMemories: aNumber [

	maxMemories := aNumber.
	self enforceMemoryLimit.
	self class saveDefault
]

{ #category : 'querying' }
ChatPharoMemory >> memoriesForKeywords: keywordCollection [
	"Return memories matching any of the given keywords"

	^ memories select: [ :memory | memory matchesKeywords: keywordCollection ]
]

{ #category : 'querying' }
ChatPharoMemory >> memoriesForQuery: queryString [
	"Return memories relevant to the query"

	| keywords |
	keywords := self extractKeywordsFrom: queryString.
	^ self memoriesForKeywords: keywords
]

{ #category : 'accessing' }
ChatPharoMemory >> memoriesOfType: aType [
	"Return all memories of a specific type"

	^ memories select: [ :m | m type = aType ]
]

{ #category : 'accessing' }
ChatPharoMemory >> memoriesWithTag: aTag [
	"Return all memories with a specific tag"

	^ memories select: [ :m | m hasTag: aTag ]
]

{ #category : 'initialization' }
ChatPharoMemory >> memoryCount [
	"Return the number of stored memories"

	^ memories size
]

{ #category : 'private' }
ChatPharoMemory >> privateSetAutoSummarize: aBoolean [
	"Set autoSummarize without triggering save. Used during loading."

	autoSummarize := aBoolean
]

{ #category : 'private' }
ChatPharoMemory >> privateSetEnabled: aBoolean [
	"Set enabled without triggering save. Used during loading."

	enabled := aBoolean
]

{ #category : 'private' }
ChatPharoMemory >> privateSetMaxMemories: aNumber [
	"Set maxMemories without triggering save. Used during loading."

	maxMemories := aNumber
]

{ #category : 'private' }
ChatPharoMemory >> privateSetRetentionDays: aNumber [
	"Set retentionDays without triggering save. Used during loading."

	retentionDays := aNumber
]

{ #category : 'removing' }
ChatPharoMemory >> removeMemory: aMemoryItem [
	"Remove a specific memory item"

	memories remove: aMemoryItem ifAbsent: [ ].
	self class saveDefault.
	ChatPharoLogger logSystem: 'Memory item removed'
		details: (Dictionary new
				 at: 'type' put: aMemoryItem type;
				 at: 'id' put: aMemoryItem id;
				 yourself)
]

{ #category : 'removing' }
ChatPharoMemory >> removeMemoryById: anId [
	"Remove a memory item by its ID"

	| memory |
	memory := memories detect: [ :m | m id = anId ] ifNone: [ nil ].
	memory ifNotNil: [ self removeMemory: memory ]
]

{ #category : 'removing' }
ChatPharoMemory >> retentionDays [

	^ retentionDays ifNil: [ retentionDays := 30 ]
]

{ #category : 'removing' }
ChatPharoMemory >> retentionDays: aNumber [

	retentionDays := aNumber.
	self cleanupExpiredMemories.
	self class saveDefault
]

{ #category : 'accessing' }
ChatPharoMemory >> userPreferences [
	"Return all user preference memories"

	^ self memoriesOfType: 'user_preference'
]
