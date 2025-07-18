"
One **conversation transcript**.

* Keeps an ordered list of UI `ChatPharoMessage` objects **and** a non-UI `ChatPharoHistory` that mirrors the same information in LLM-friendly format.
* Drives asynchronous prompting: forks a light process that asks the agent and posts the assistant reply back into both collections.
* Can clear its own history, cancel an in-flight request, and notify listeners when a reply arrives.
* **Why** – encapsulates everything that makes a single chat tick, so multiple chats can live side-by-side in a notebook UI.


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
		'history',
		'onToolExecution',
		'cache'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'running' }
ChatPharoChat >> addAssistantMessage: answerText [
    | label |
    history addAssistant: answerText.
    label := (self agent isKindOf: ChatPharoNullAgent)
                ifTrue: [ 'Assistant bot' ]
                ifFalse: [ 'Assistant' ].
    messages last
        answer: answerText;
        assistantLabel: label
]

{ #category : 'running' }
ChatPharoChat >> addUserMessage: text [

	history addUser: text.
	messages add: (ChatPharoMessage new
			 content: text;
			 yourself)
]

{ #category : 'accessing' }
ChatPharoChat >> agent [
    ^ agent ifNotNil: [ agent history: history. agent ]
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
ChatPharoChat >> clearCache [

	cache removeAll
]

{ #category : 'running' }
ChatPharoChat >> clearChat [

	self cancelMessage.
	history clear.
	messages removeAll.
	self clearCache
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
	history := ChatPharoHistory new.
	messages := OrderedCollection new.
	onToolExecution := nil.
	cache := Dictionary new
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

        | answer |
        self addUserMessage: aText.
        (cache includesKey: aText)
                ifTrue: [
                        answer := cache at: aText.
                        self addAssistantMessage: answer.
                        onAnswerReceived ifNotNil: [ :blk | blk value: messages last ]
                ]
                ifFalse: [
                        promptProcess := [
                                 | backend |
                                 backend := self agent.
                                 backend onToolExecution: [ self triggerToolExecution ].
                                 backend promptPrefix: history asPromptPrefix.
                                 answer := backend getResponseForPrompt: aText.
                                 cache at: aText put: answer.
                                 self addAssistantMessage: answer.
                                 onAnswerReceived ifNotNil: [ :blk | blk value: messages last ] ] fork
                ]
]

{ #category : 'running' }
ChatPharoChat >> triggerToolExecution [ 

        onToolExecution ifNotNil: [ :blk | blk value ]
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

{ #category : 'running' }
ChatPharoChat >> whenToolExecutionDo: aBlock [ 

        onToolExecution := aBlock
]
