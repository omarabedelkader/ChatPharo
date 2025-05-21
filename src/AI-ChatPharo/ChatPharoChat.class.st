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
		'onAnswerReceived',
		'history'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'running' }
ChatPharoChat >> addAssistantMessage: answerText [
    history addAssistant: answerText.
    messages last answer: answerText
]

{ #category : 'running' }
ChatPharoChat >> addUserMessage: text [
    history addUser: text.
    "UI model"
    messages add: (ChatPharoMessage new content: text; yourself)
]

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
    history clear.
    messages removeAll
]

{ #category : 'running' }
ChatPharoChat >> history [
    ^ history asPromptPrefix
]

{ #category : 'running' }
ChatPharoChat >> historyPromptPrefix [
    ^ history asPromptPrefix
]

{ #category : 'initialization' }
ChatPharoChat >> initialize [

	super initialize.
	history := ChatHistory new.
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

	self addUserMessage: aText.
	promptProcess := [
		                 | answer |
		                 agent promptPrefix: history asPromptPrefix.
		
							history inspect.
							agent inspect.
		                 answer := agent getResponseForPrompt: aText.
		                 self addAssistantMessage: answer.
		                 onAnswerReceived ifNotNil: [ :blk |
			                 blk value: messages last ] ] fork
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
