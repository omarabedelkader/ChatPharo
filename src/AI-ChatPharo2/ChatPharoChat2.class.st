"
```smalltalk
(ChatPharoChat2 new
	ollamaApi: (OllamaApi new
		model: 'codellama:7b';
		yourself);
	yourself) presenter open.
	
```
"
Class {
	#name : 'ChatPharoChat2',
	#superclass : 'Object',
	#instVars : [
		'messages',
		'ollamaApi',
		'promptProcess',
		'onAnswerReceived'
	],
	#category : 'AI-ChatPharo2',
	#package : 'AI-ChatPharo2'
}

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> cancelMessage [

	promptProcess terminate
]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> clearChat [

	self cancelMessage.
	messages := OrderedCollection new.

]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> history [

	^ String streamContents: [ :stream | 
		messages collect: [ :m |
			stream nextPutAll: 'User: '.
			stream nextPutAll: m content.
			stream cr.
			stream nextPutAll: 'Assistant: '.
			stream nextPutAll: m answer.
			stream cr
		].
	] 
]

{ #category : 'initialization' }
ChatPharoChat2 >> initialize [

	super initialize.
	messages := OrderedCollection new
]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> messages [

	^ messages
]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> messages: anObject [

	messages := anObject
]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> ollamaApi: anObject [

	ollamaApi := anObject
]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> presenter [

	^ ChatPharoChatPresenter2 on: self
]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> sendMessage: aText [

	promptProcess := [
		                 messages add: (ChatPharoMessage2 new
				                  content: aText;
				                  answer: (ollamaApi
						                   system: self history;
						                   getResponseForPrompt: aText);
				                  yourself).
		                 onAnswerReceived ifNotNil: [ :action |
			                 action value: messages last ] ] fork
]

{ #category : 'as yet unclassified' }
ChatPharoChat2 >> whenAnswerReceivedDo: aBlock [

	onAnswerReceived := aBlock
]
