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
		'onAnswerReceived',
		'title'
	],
	#category : 'AI-ChatPharo2',
	#package : 'AI-ChatPharo2'
}

{ #category : 'running' }
ChatPharoChat2 >> cancelMessage [

	promptProcess terminate
]

{ #category : 'running' }
ChatPharoChat2 >> clearChat [

	self cancelMessage.
	messages := OrderedCollection new.

]

{ #category : 'running' }
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

{ #category : 'accessing' }
ChatPharoChat2 >> messages [

	^ messages
]

{ #category : 'accessing' }
ChatPharoChat2 >> messages: anObject [

	messages := anObject
]

{ #category : 'accessing' }
ChatPharoChat2 >> ollamaApi: anObject [

	ollamaApi := anObject
]

{ #category : 'presenters' }
ChatPharoChat2 >> presenter [

	^ ChatPharoChatPresenter2 on: self
]

{ #category : 'running' }
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

{ #category : 'running' }
ChatPharoChat2 >> waitForPromptProcessDone [ 
    | promptProcess |
promptProcess ifNotNil: [ promptProcess waitUntil: [ promptProcess isTerminated ] ].

]

{ #category : 'running' }
ChatPharoChat2 >> whenAnswerReceivedDo: aBlock [

	onAnswerReceived := aBlock
]

{ #category : 'accessing' }
ChatPharoChat2 >> title [

	^ title
]

{ #category : 'accessing' }
ChatPharoChat2 >> title: aString [

	title := aString
]
