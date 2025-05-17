"
```smalltalk
(ChatPharoChat new
	ollamaApi: (OllamaApi new
		model: 'codellama:7b';
		yourself);
	yourself) presenter open.
	
```
"
Class {
	#name : 'ChatPharoChat',
	#superclass : 'Object',
	#instVars : [
		'messages',
		'agent',
		'promptProcess',
		'onAnswerReceived'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoChat >> agent: anObject [

	agent := anObject
]

{ #category : 'running' }
ChatPharoChat >> cancelMessage [

	promptProcess terminate
]

{ #category : 'running' }
ChatPharoChat >> clearChat [

	self cancelMessage.
	messages := OrderedCollection new.

]

{ #category : 'running' }
ChatPharoChat >> history [

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
ChatPharoChat >> initialize [

	super initialize.
	messages := OrderedCollection new
]

{ #category : 'accessing' }
ChatPharoChat >> messages [

	^ messages
]

{ #category : 'accessing' }
ChatPharoChat >> messages: anObject [

	messages := anObject
]

{ #category : 'presenters' }
ChatPharoChat >> presenter [

	^ ChatPharoChatPresenter on: self
]

{ #category : 'running' }
ChatPharoChat >> sendMessage: aText [

	promptProcess := [
		                 messages add: (ChatPharoMessage new
				                  content: aText;
				                  answer: (agent
						                   system: self history;
						                   getResponseForPrompt: aText);
				                  yourself).
		                 onAnswerReceived ifNotNil: [ :action |
			                 action value: messages last ] ] fork
]

{ #category : 'running' }
ChatPharoChat >> waitForPromptProcessDone [ 
    | promptProcess |
promptProcess ifNotNil: [ promptProcess waitUntil: [ promptProcess isTerminated ] ].

]

{ #category : 'running' }
ChatPharoChat >> whenAnswerReceivedDo: aBlock [

	onAnswerReceived := aBlock
]
