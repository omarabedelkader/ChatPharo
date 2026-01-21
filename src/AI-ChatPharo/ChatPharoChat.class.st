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
		assistantLabel: label.
	    ChatPharoLogger logBackend: 'Assistant response recorded'
            details: (Dictionary new
                    at: 'chatId' put: self identityHash;
                    at: 'agent' put: (ChatPharoLogger agentNameFor: self agent);
                    at: 'assistantLabel' put: label;
                    at: 'response' put: answerText;
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

	agent := anObject
]

{ #category : 'running' }
ChatPharoChat >> cancelMessage [

	promptProcess ifNotNil: [ :process | process terminate ]
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

{ #category : 'accessing' }
ChatPharoChat >> exportAsJson [

	| entries normalized |
	entries := Array streamContents: [ :stream |
		history putOpenAIChatMessagesOn: stream ].
	normalized := entries collect: [ :entry |
		| dict |
		dict := entry copy.
		(dict includesKey: 'role') ifTrue: [
			(dict includesKey: 'content') ifFalse: [
				dict at: 'content' put: '' ] ].
		dict ].
	^ STONJSON toString: normalized
]

{ #category : 'running' }
ChatPharoChat >> history [
    ^ history asPromptPrefix
]

{ #category : 'running' }
ChatPharoChat >> historyMessages [
    ^ history messages
]

{ #category : 'running' }
ChatPharoChat >> historyPromptPrefix [
    ^ history asPromptPrefix
]

{ #category : 'accessing' }
ChatPharoChat >> importFromJson: aJsonString [
    "Import a chat from a JSON string. The JSON should be an array of message objects
    with 'role' and 'content' keys, optionally with 'tool_calls' for assistant messages."

    | parsedMessages currentUserContent |
    self clearChat.
    parsedMessages := STONJSON fromString: aJsonString.
    currentUserContent := nil.

    parsedMessages do: [ :msgDict |
        | role content toolCalls historyMsg |
        role := msgDict at: 'role'.
        content := msgDict at: 'content' ifAbsent: [ '' ].
        toolCalls := msgDict at: 'tool_calls' ifAbsent: [ nil ].

        "Create tool calls if present"
        toolCalls ifNotNil: [
            toolCalls := toolCalls collect: [ :tcDict |
                | funcDict |
                funcDict := tcDict at: 'function' ifAbsent: [ Dictionary new ].
                ChatPharoHistorySaverToolCall
                    id: (tcDict at: 'id' ifAbsent: [ '' ])
                    functionName: (funcDict at: 'name' ifAbsent: [ '' ])
                    arguments: (funcDict at: 'arguments' ifAbsent: [ '' ])
                    content: nil ] ].

        "Add to history"
        historyMsg := ChatPharoHistoryMessage role: role content: content toolCalls: toolCalls.
        history addMessage: historyMsg.

        "Build UI messages - pair user with assistant"
        role = 'user' ifTrue: [ currentUserContent := content ].
        role = 'assistant' ifTrue: [
            messages add: (ChatPharoMessage new
                content: (currentUserContent ifNil: [ '' ]);
                answer: (content ifNil: [ '' ]);
                assistantLabel: 'Assistant';
                yourself).
            currentUserContent := nil ] ].

    ChatPharoLogger logBackend: 'Chat imported from JSON'
        details: (Dictionary new
            at: 'chatId' put: self identityHash;
            at: 'messagesImported' put: parsedMessages size;
            yourself)
]

{ #category : 'initialization' }
ChatPharoChat >> initialize [

	super initialize.
	history := ChatPharoHistory new.
	messages := OrderedCollection new.
	onToolExecution := nil.
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
