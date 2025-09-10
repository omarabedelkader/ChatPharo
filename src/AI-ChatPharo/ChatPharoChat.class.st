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
		'cache',
        'onAnswerStarted'
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
    (messages isEmpty)
        ifTrue: [
            messages add: (ChatPharoMessage new
                         answer: answerText;
                         assistantLabel: label;
                         yourself)
        ]
        ifFalse: [
            messages last
                answer: answerText;
                assistantLabel: label
        ].
]

{ #category : 'running' }
ChatPharoChat >> addErrorMessage: aString [
	history addAssistant: aString.
	messages add: (ChatPharoMessage new
			 content: aString;
			 assistantLabel: 'Error';
			 yourself)
]

{ #category : 'running' }
ChatPharoChat >> addUserMessage: text [

	history addUser: text.
	messages add: (ChatPharoMessage new
			 content: text;
			 yourself)
]

{ #category : 'initialization' }
ChatPharoChat >> addWelcomeMessage [ 

        | text message |
        text := 'Welcome to ChatPharo! I can answer questions, help explore your Pharo image, run snippets and search your code. Type a message to get started.'.
        history addAssistant: text.
        message := ChatPharoMessage new
                        answer: text;
                        assistantLabel: 'ChatPharo';
                        yourself.
        messages add: message
]

{ #category : 'accessing' }
ChatPharoChat >> agent [
    ^ agent ifNotNil: [ agent history: history. agent ]
]

{ #category : 'accessing' }
ChatPharoChat >> agent: anObject [

	agent := anObject.
    (agent respondsTo: #history:) ifTrue: [ agent history: history ].
]

{ #category : 'running' }
ChatPharoChat >> cancelMessage [
    promptProcess ifNotNil: [
        [ promptProcess terminate ] on: Error do: [ :ex | "ignore termination errors" ].
        promptProcess := nil.
    ].
]

{ #category : 'running' }
ChatPharoChat >> clearCache [

	cache removeAll
]

{ #category : 'running' }
ChatPharoChat >> clearCacheFor: aText [
	cache removeKey: aText ifAbsent: [ ].
]

{ #category : 'running' }
ChatPharoChat >> clearChat [

	self cancelMessage.
	history clear.
	messages removeAll.
	self clearCache
]

{ #category : 'accessing' }
ChatPharoChat >> exportAsJson [

    | msgs |
    msgs := history messages collect: [ :msg |
        | dict |
        dict := Dictionary new
            at: 'role' put: msg role;
            at: 'content' put: (msg content ifNil: [ '' ]);
            yourself.
        msg toolCalls ifNotNil: [
            dict at: 'tool_calls' put:
                (msg toolCalls collect: [ :tc |
                    (tc respondsTo: #openAIChatToolCall)
                        ifTrue: [ tc openAIChatToolCall ]
                        ifFalse: [ tc ] ] as: Array)
        ].
        dict ].
    ^ STONJSON toString: (msgs as: Array)
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
    onAnswerStarted := nil.
	onAnswerReceived := nil.
	cache := Dictionary new.
	        (ChatPharoSettings default welcomeMessageEnabled)
                ifTrue: [ self addWelcomeMessage ]
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

    | answer assistantPlaceholder proc backend |
    aText ifNil: [ ^ self ].
    (aText isString and: [ aText isEmpty ]) ifTrue: [
        self addUserMessage: aText.
        ^ self
    ].

    self addUserMessage: aText.

    (cache includesKey: aText) ifTrue: [
        answer := cache at: aText.
        self addAssistantMessage: answer.
        onAnswerReceived ifNotNil: [ :blk | blk value: messages last ].
        ^ self
    ].

    assistantPlaceholder := ChatPharoMessage new.
    assistantPlaceholder answer: ''.
    assistantPlaceholder assistantLabel: ((self agent isKindOf: ChatPharoNullAgent) ifTrue: ['Assistant bot'] ifFalse: ['Assistant']).
    messages add: assistantPlaceholder.

    onAnswerStarted ifNotNil: [ :blk | blk value ].

    proc := [
        [ 
            backend := self agent.
            (backend isNil or: [ backend isKindOf: ChatPharoNullAgent ]) ifTrue: [
                answer := 'No backend is configured'.
            ] ifFalse: [
                (backend respondsTo: #onToolExecution:) ifTrue: [
                    backend onToolExecution: [ self triggerToolExecution ].
                ].
                backend promptPrefix: history asPromptPrefix.
                answer := backend getResponseForPrompt: aText.
            ].
            cache at: aText put: answer.
            history addAssistant: answer.
            assistantPlaceholder answer: answer.
            onAnswerReceived ifNotNil: [ :blk | blk value: assistantPlaceholder ].
        ] on: Error do: [ :ex |
            answer := 'An error occurred: ', ex messageText.
            cache at: aText put: answer.
            history addAssistant: answer.
            assistantPlaceholder answer: answer.
            assistantPlaceholder assistantLabel: 'Error'.
            onAnswerReceived ifNotNil: [ :blk | blk value: assistantPlaceholder ].
        ] ensure: [
            promptProcess := nil
        ].
    ].
    promptProcess := proc fork.
]

{ #category : 'running' }
ChatPharoChat >> triggerToolExecution [ 

        onToolExecution ifNotNil: [ :blk | blk value ]
]

{ #category : 'running' }
ChatPharoChat >> waitForPromptProcessDone [ 
    
    promptProcess ifNotNil: [ promptProcess waitUntil: [ promptProcess isTerminated ] ].
]

{ #category : 'running' }
ChatPharoChat >> whenAnswerReceivedDo: aBlock [

	onAnswerReceived := aBlock
]

{ #category : 'running' }
ChatPharoChat >> whenAnswerStartedDo: aBlock [
    onAnswerStarted := aBlock
]

{ #category : 'running' }
ChatPharoChat >> whenToolExecutionDo: aBlock [ 

        onToolExecution := aBlock
]
