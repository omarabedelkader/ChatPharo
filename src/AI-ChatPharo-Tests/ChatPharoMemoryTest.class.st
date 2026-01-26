Class {
	#name : 'ChatPharoMemoryTest',
	#superclass : 'TestCase',
	#instVars : [
		'memory'
	],
	#category : 'AI-ChatPharo-Tests-Memory',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Memory'
}

{ #category : 'running' }
ChatPharoMemoryTest >> setUp [ 

	super setUp.
	ChatPharoMemory reset.
	memory := ChatPharoMemory new
]

{ #category : 'running' }
ChatPharoMemoryTest >> tearDown [

	ChatPharoMemory resetAndDelete.
	super tearDown
]

{ #category : 'running' }
ChatPharoMemoryTest >> testAddConversationSummary [

	memory addConversationSummary: 'Summary of conversation'.
	self assert: memory memoryCount equals: 1.
	self assert: memory allMemories first isConversationSummary
]

{ #category : 'running' }
ChatPharoMemoryTest >> testAddCorrection [

	memory addCorrection: 'Correction text'.
	self assert: memory memoryCount equals: 1.
	self assert: memory allMemories first isCorrection.
	self assert: memory allMemories first importance equals: 0.9
]

{ #category : 'running' }
ChatPharoMemoryTest >> testAddFeedback [

	memory addFeedback: 'Good answer' positive: true.
	self assert: memory memoryCount equals: 1.
	self assert: memory allMemories first isFeedback
]

{ #category : 'running' }
ChatPharoMemoryTest >> testAddMemory [

	| item |
	self assert: memory memoryCount equals: 0.
	item := ChatPharoMemoryItem userPreference: 'test preference'.
	memory addMemory: item.
	self assert: memory memoryCount equals: 1.
	self assert: (memory allMemories includes: item)
]

{ #category : 'running' }
ChatPharoMemoryTest >> testAddTopicKnowledge [

	memory addTopicKnowledge: 'Knowledge content' topic: 'TestTopic'.
	self assert: memory memoryCount equals: 1.
	self assert: memory allMemories first isTopicKnowledge.
	self assert: (memory allMemories first hasTag: 'TestTopic')
]

{ #category : 'running' }
ChatPharoMemoryTest >> testAddUserPreference [

	memory addUserPreference: 'User prefers X'.
	self assert: memory memoryCount equals: 1.
	self assert: memory allMemories first isUserPreference.
	self assert: memory allMemories first importance equals: 0.8
]

{ #category : 'running' }
ChatPharoMemoryTest >> testClearAllMemories [

	memory addUserPreference: 'test1'.
	memory addCorrection: 'test2'.
	self assert: memory memoryCount equals: 2.
	memory clearAllMemories.
	self assert: memory memoryCount equals: 0
]

{ #category : 'running' }
ChatPharoMemoryTest >> testContextForQuery [

	| context |
	memory addTopicKnowledge: 'Spec2 button knowledge' topic: 'Spec2'.
	memory addUserPreference: 'Prefers detailed code'.
	context := memory contextForQuery: 'How do I create a Spec2 button?'.
	self assert: (context includesSubstring: 'RELEVANT MEMORY CONTEXT').
	self assert: (context includesSubstring: 'Spec2')
]

{ #category : 'running' }
ChatPharoMemoryTest >> testDefaultSettings [

	self assert: memory enabled.
	self assert: memory retentionDays equals: 30.
	self assert: memory maxMemories equals: 1000.
	self assert: memory autoSummarize
]

{ #category : 'running' }
ChatPharoMemoryTest >> testDisabledMemoryDoesNotAdd [

	memory enabled: false.
	memory addUserPreference: 'should not be added'.
	self assert: memory memoryCount equals: 0
]

{ #category : 'running' }
ChatPharoMemoryTest >> testEnforceMemoryLimit [

	memory maxMemories: 3.
	memory addUserPreference: 'pref1'.
	memory addUserPreference: 'pref2'.
	memory addUserPreference: 'pref3'.
	memory addUserPreference: 'pref4'.
	self assert: memory memoryCount equals: 3
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoriesForKeywords [

	| results |
	memory addTopicKnowledge: 'Spec2 buttons' topic: 'Spec2'.
	memory addTopicKnowledge: 'Morphic shapes' topic: 'Morphic'.
	results := memory memoriesForKeywords: #( 'Spec2' ).
	self assert: results size equals: 1.
	self assert: (results first content includesSubstring: 'Spec2')
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoriesForQuery [

	| results |
	memory addTopicKnowledge: 'Spec2 buttons' topic: 'Spec2'.
	results := memory memoriesForQuery: 'How to create Spec2 button?'.
	self assert: results notEmpty
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoriesOfType [

	memory addUserPreference: 'pref1'.
	memory addCorrection: 'correction1'.
	memory addUserPreference: 'pref2'.
	self assert: (memory memoriesOfType: 'user_preference') size equals: 2.
	self assert: (memory memoriesOfType: 'correction') size equals: 1
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoriesWithTag [

	| item results |
	item := ChatPharoMemoryItem content: 'tagged content'.
	item addTag: 'important'.
	memory addMemory: item.
	memory addUserPreference: 'untagged'.
	results := memory memoriesWithTag: 'important'.
	self assert: results size equals: 1.
	self assert: results first content equals: 'tagged content'
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemAsContextString [

	| item context |
	item := ChatPharoMemoryItem userPreference: 'User prefers verbose explanations'.
	context := item asContextString.
	self assert: (context includesSubstring: '[Memory: user_preference]').
	self assert: (context includesSubstring: 'User prefers verbose explanations')
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemConversationSummary [

	| item |
	item := ChatPharoMemoryItem conversationSummary: 'Discussed Spec2 buttons'.
	self assert: item type equals: 'conversation_summary'.
	self assert: item content equals: 'Discussed Spec2 buttons'.
	self assert: item isConversationSummary
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemCorrection [
	| item |
	item := ChatPharoMemoryItem correction: 'The correct method is #yourself'.
	self assert: item type equals: 'correction'.
	self assert: item isCorrection
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemCreation [

	| item |
	item := ChatPharoMemoryItem
		        type: 'test_type'
		        content: 'test content'
		        metadata: (Dictionary new
				         at: 'key' put: 'value';
				         yourself).
	self assert: item type equals: 'test_type'.
	self assert: item content equals: 'test content'.
	self assert: (item metadata at: 'key') equals: 'value'.
	self assert: item id notNil.
	self assert: item timestamp notNil
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemFeedback [

	| item |
	item := ChatPharoMemoryItem feedback: 'Great explanation' positive: true.
	self assert: item type equals: 'feedback'.
	self assert: item isFeedback.
	self assert: (item metadata at: 'positive') equals: true
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemHasDefaultImportance [

	| item |
	item := ChatPharoMemoryItem content: 'test'.
	self assert: item importance equals: 0.5
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemImportanceClamps [

	| item |
	item := ChatPharoMemoryItem content: 'test'.
	item importance: 1.5.
	self assert: item importance equals: 1.0.
	item importance: -0.5.
	self assert: item importance equals: 0.0
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemMatchesKeywords [

	| item |
	item := ChatPharoMemoryItem topicKnowledge: 'Spec2 presenter creation' topic: 'Spec2'.
	self assert: (item matchesKeywords: #( 'Spec2' )).
	self assert: (item matchesKeywords: #( 'presenter' )).
	self deny: (item matchesKeywords: #( 'unknown' ))
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemTags [

	| item |
	item := ChatPharoMemoryItem content: 'test'.
	item addTag: 'pharo'.
	item addTag: 'spec2'.
	self assert: (item hasTag: 'pharo').
	self assert: (item hasTag: 'spec2').
	self deny: (item hasTag: 'unknown').
	item removeTag: 'pharo'.
	self deny: (item hasTag: 'pharo')
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemTopicKnowledge [

	| item |
	item := ChatPharoMemoryItem topicKnowledge: 'Spec2 knowledge' topic: 'Spec2'.
	self assert: item type equals: 'topic_knowledge'.
	self assert: item isTopicKnowledge.
	self assert: (item metadata at: 'topic') equals: 'Spec2'
]

{ #category : 'running' }
ChatPharoMemoryTest >> testMemoryItemUserPreference [

	| item |
	item := ChatPharoMemoryItem userPreference: 'Prefers verbose code'.
	self assert: item type equals: 'user_preference'.
	self assert: item isUserPreference
]

{ #category : 'running' }
ChatPharoMemoryTest >> testPersistenceRoundTrip [

	| loaded |
	ChatPharoMemory setDefault: memory.
	memory addUserPreference: 'persisted preference'.
	memory addCorrection: 'persisted correction'.
	ChatPharoMemory saveDefault.
	ChatPharoMemory reset.
	loaded := ChatPharoMemory loadOrNew.
	self assert: loaded memoryCount equals: 2.
	self assert: loaded allMemories first isUserPreference.
	self assert: loaded allMemories second isCorrection
]

{ #category : 'running' }
ChatPharoMemoryTest >> testPersistenceSettingsRoundTrip [

	| loaded |
	ChatPharoMemory setDefault: memory.
	memory enabled: false.
	memory retentionDays: 60.
	memory maxMemories: 500.
	memory autoSummarize: false.
	ChatPharoMemory saveDefault.
	ChatPharoMemory reset.
	loaded := ChatPharoMemory loadOrNew.
	self deny: loaded enabled.
	self assert: loaded retentionDays equals: 60.
	self assert: loaded maxMemories equals: 500.
	self deny: loaded autoSummarize
]

{ #category : 'running' }
ChatPharoMemoryTest >> testRemoveMemory [

	| item |
	item := ChatPharoMemoryItem userPreference: 'to remove'.
	memory addMemory: item.
	self assert: memory memoryCount equals: 1.
	memory removeMemory: item.
	self assert: memory memoryCount equals: 0
]

{ #category : 'running' }
ChatPharoMemoryTest >> testRemoveMemoryById [

	| item |
	item := ChatPharoMemoryItem userPreference: 'to remove'.
	memory addMemory: item.
	memory removeMemoryById: item id.
	self assert: memory memoryCount equals: 0
]

{ #category : 'running' }
ChatPharoMemoryTest >> testUserPreferences [

	memory addUserPreference: 'pref1'.
	memory addCorrection: 'correction'.
	memory addUserPreference: 'pref2'.
	self assert: memory userPreferences size equals: 2
]
