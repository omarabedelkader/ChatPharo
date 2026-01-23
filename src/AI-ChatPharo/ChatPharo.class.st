"
The **application root-object**.

* Owns global `settings` (which agent to use) and an ordered collection of open `chats`.
* Spawns new chat sessions through `newChat`.
* **Why** – single source of truth for top-level state; presenters bind to it to build windows/toolbars.


```samlltalk
ChatPharo new presenter open.

ChatPharoSettings new presenter open


```
"
Class {
	#name : 'ChatPharo',
	#superclass : 'Object',
	#instVars : [
		'settings',
		'chats'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'context' }
ChatPharo class >> ask: text [

^ self
                performQuickActionNamed: 'Quick ask'
                prompt: text
                additionalDetails: nil
                customizeAgent: nil
]

{ #category : 'context' }
ChatPharo class >> askAboutDebugContext: aDebugInfoDictionary [
	"Open ChatPharo with context from the debugger.
	aDebugInfoDictionary contains debugging information such as:
	- exception: the exception class name
	- errorMessage: the error message
	- method: the method where the error occurred
	- receiver: the receiver class
	- selector: the selector being executed
	- sourceCode: the source code of the method
	- stackTrace: the stack trace"

	| prompt details |
	prompt := self promptForDebugContext: aDebugInfoDictionary.
	details := aDebugInfoDictionary copy.
	^ self
		performQuickActionNamed: 'Debug ask'
		prompt: prompt
		additionalDetails: details
		customizeAgent: nil
]

{ #category : 'context' }
ChatPharo class >> askAboutMethod: aMethod [

        | methodClass source className selector packageName prompt details |
        methodClass := (aMethod respondsTo: #methodClass)
                        ifTrue: [ aMethod methodClass ]
                        ifFalse: [ nil ].
        source := (aMethod respondsTo: #sourceCode)
                        ifTrue: [ aMethod sourceCode ]
                        ifFalse: [ '' ].
        className := methodClass
                        ifNotNil: [ methodClass name asString ]
                        ifNil: [ nil ].
        selector := (aMethod respondsTo: #selector)
                        ifTrue: [ aMethod selector asString ]
                        ifFalse: [ nil ].
        packageName := (methodClass respondsTo: #package)
                        ifTrue: [
                                | package |
                                package := methodClass package.
                                package ifNotNil: [ package name asString ] ]
                        ifFalse: [ nil ].
        prompt := self
                        promptForMethodExplanationSource: source
                        className: className
                        selector: selector.
        details := Dictionary new.
        className ifNotNil: [ details at: 'class' put: className ].
        selector ifNotNil: [ details at: 'selector' put: selector ].
        packageName ifNotNil: [ details at: 'package' put: packageName ].
        ^ self
                performQuickActionNamed: 'Quick ask'
                prompt: prompt
                additionalDetails: details
                customizeAgent: [ :agent |
                        packageName ifNotNil: [
                                (agent respondsTo: #packageName:)
                                        ifTrue: [ agent packageName: packageName ] ] ]
]

{ #category : 'context' }
ChatPharo class >> code: sourceText [

        | prompt |
        prompt := self codePromptForSource: sourceText context: nil.
        ^ self
                performQuickActionNamed: 'Quick code'
                prompt: prompt
                additionalDetails: nil
                customizeAgent: nil

]

{ #category : 'context' }
ChatPharo class >> codeForMethod: aMethod [

        | methodClass source className selector packageName context details prompt |
        methodClass := (aMethod respondsTo: #methodClass)
                        ifTrue: [ aMethod methodClass ]
                        ifFalse: [ nil ].
        source := (aMethod respondsTo: #sourceCode)
                        ifTrue: [ aMethod sourceCode ]
                        ifFalse: [ '' ].
        className := methodClass
                        ifNotNil: [ methodClass name asString ]
                        ifNil: [ nil ].
        selector := (aMethod respondsTo: #selector)
                        ifTrue: [ aMethod selector asString ]
                        ifFalse: [ nil ].
        packageName := (methodClass respondsTo: #package)
                        ifTrue: [
                                | package |
                                package := methodClass package.
                                package ifNotNil: [ package name asString ] ]
                        ifFalse: [ nil ].
        context := Dictionary new.
        className ifNotNil: [ context at: 'Class' put: className ].
        selector ifNotNil: [ context at: 'Selector' put: selector ].
        context isEmpty ifTrue: [ context := nil ].
        prompt := self codePromptForSource: source context: context.
        details := Dictionary new.
        className ifNotNil: [ details at: 'class' put: className ].
        selector ifNotNil: [ details at: 'selector' put: selector ].
        packageName ifNotNil: [ details at: 'package' put: packageName ].
        ^ self
                performQuickActionNamed: 'Quick code'
                prompt: prompt
                additionalDetails: details
                customizeAgent: [ :agent |
                        packageName ifNotNil: [
                                (agent respondsTo: #packageName:)
                                        ifTrue: [ agent packageName: packageName ] ] ]
]

{ #category : 'context' }
ChatPharo class >> codePromptForSource: source context: contextDictionary [

    | lines safeSource |
    safeSource := source ifNil: [ '' ].

    lines := OrderedCollection new.
    contextDictionary ifNotNil: [
        contextDictionary associationsDo: [ :assoc |
            assoc value ifNotNil: [
                lines add: assoc key , ': ' , assoc value ] ] ].

    ^ String streamContents: [ :stream |
        stream
            nextPutAll: 'Suggest improvements or provide a revised Smalltalk implementation for the following code while preserving its behaviour.';
            cr;
            cr.
        lines do: [ :line |
            stream nextPutAll: line; cr ].
        lines isEmpty ifFalse: [ stream cr ].
        stream
            nextPutAll: '```smalltalk';
            cr;
            nextPutAll: safeSource;
            cr;
            nextPutAll: '```' ]

]

{ #category : 'context' }
ChatPharo class >> performQuickActionNamed: actionName prompt: prompt additionalDetails: details customizeAgent: customizationBlock [

        | agentCopy chat baseDetails frontendDetails backendDetails |
        baseDetails := details
                        ifNil: [ Dictionary new ]
                        ifNotNil: [ details copy ].
        baseDetails at: 'prompt' put: prompt.
        frontendDetails := baseDetails copy.
        ChatPharoLogger
                logFrontend: actionName , ' invoked'
                details: frontendDetails.
        agentCopy := ChatPharoSettings default agent.
        agentCopy := (agentCopy isKindOf: ChatPharoAgent)
                             ifTrue: [ agentCopy copyForChat ]
                             ifFalse: [ agentCopy ].
        customizationBlock ifNotNil: [ customizationBlock value: agentCopy ].
        chat := ChatPharoChat new
                        agent: ChatPharoSettings default agent;
                        agent: agentCopy;
                        yourself.
        chat presenter open.
        prompt ifNotEmpty: [ chat sendMessage: prompt ].
        backendDetails := baseDetails copy.
        backendDetails at: 'activeAgent' put: (ChatPharoLogger agentNameFor: agentCopy).
        ChatPharoLogger
                logSystem: actionName , ' completed'
                details: backendDetails.
        ^ chat
]

{ #category : 'context' }
ChatPharo class >> promptForDebugContext: aDebugInfoDictionary [
	"Build a prompt for asking about a debugging context"

	| exception errorMessage method receiver selector sourceCode stackTrace |
	exception := aDebugInfoDictionary at: 'exception' ifAbsent: [ 'Unknown' ].
	errorMessage := aDebugInfoDictionary at: 'errorMessage' ifAbsent: [ '' ].
	method := aDebugInfoDictionary at: 'method' ifAbsent: [ '' ].
	receiver := aDebugInfoDictionary at: 'receiver' ifAbsent: [ '' ].
	selector := aDebugInfoDictionary at: 'selector' ifAbsent: [ '' ].
	sourceCode := aDebugInfoDictionary at: 'sourceCode' ifAbsent: [ '' ].
	stackTrace := aDebugInfoDictionary at: 'stackTrace' ifAbsent: [ '' ].

	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'I encountered an error while debugging Smalltalk code. Please help me understand what went wrong and how to fix it.';
			cr;
			cr.
		stream nextPutAll: '## Error Information'; cr.
		stream nextPutAll: '- **Exception**: '; nextPutAll: exception; cr.
		errorMessage isEmpty ifFalse: [
			stream nextPutAll: '- **Message**: '; nextPutAll: errorMessage; cr ].
		receiver isEmpty ifFalse: [
			stream nextPutAll: '- **Receiver Class**: '; nextPutAll: receiver; cr ].
		selector isEmpty ifFalse: [
			stream nextPutAll: '- **Selector**: '; nextPutAll: selector; cr ].
		method isEmpty ifFalse: [
			stream nextPutAll: '- **Method**: '; nextPutAll: method; cr ].
		stream cr.
		sourceCode isEmpty ifFalse: [
			stream nextPutAll: '## Method Source Code'; cr.
			stream nextPutAll: '```smalltalk'; cr.
			stream nextPutAll: sourceCode; cr.
			stream nextPutAll: '```'; cr; cr ].
		stackTrace isEmpty ifFalse: [
			stream nextPutAll: '## Stack Trace'; cr.
			stream nextPutAll: '```'; cr.
			stream nextPutAll: stackTrace; cr.
			stream nextPutAll: '```'; cr; cr ].
		stream
			nextPutAll: 'Please explain:'; cr;
			nextPutAll: '1. What is causing this error?'; cr;
			nextPutAll: '2. How can I fix it?'; cr;
			nextPutAll: '3. Are there any common pitfalls related to this type of error?' ]
]

{ #category : 'context' }
ChatPharo class >> promptForMethodExplanationSource: source className: className selector: selector [

    | lines safeSource |
    safeSource := source ifNil: [ '' ].

    lines := OrderedCollection new.
    className ifNotNil: [ lines add: 'Class: ' , className ].
    selector ifNotNil: [ lines add: 'Selector: ' , selector ].

    ^ String streamContents: [ :stream |
        stream
            nextPutAll: 'Explain what the following Smalltalk method does and highlight any potential improvements or edge cases.';
            cr;
            cr.
        lines do: [ :line |
            stream nextPutAll: line; cr ].
        lines isEmpty ifFalse: [ stream cr ].
        stream
            nextPutAll: '```smalltalk';
            cr;
            nextPutAll: safeSource;
            cr;
            nextPutAll: '```' ]

]

{ #category : 'accessing' }
ChatPharo >> activeAgent [
    
    ^ chats isEmpty
        ifTrue: [ nil ]
        ifFalse: [ chats last agent ]
]

{ #category : 'initialization' }
ChatPharo >> chats [

	^ chats
]

{ #category : 'initialization' }
ChatPharo >> initialize [

	super initialize.
	settings := ChatPharoSettings default.
	settings agent systemPrompt isEmpty ifTrue: [ settings agent systemPrompt: ChatPharoAgent defaultSystemPrompt ].
	chats := OrderedCollection new.
	ChatPharoLogger logSystem: 'ChatPharo initialized' details: (Dictionary new
			 at: 'defaultAgent' put: (ChatPharoLogger agentNameFor: settings agent);
			 yourself)
]

{ #category : 'initialization' }
ChatPharo >> newChat [

	| agentCopy |
	agentCopy := self settings agent.
	agentCopy := (agentCopy isKindOf: ChatPharoAgent)
		             ifTrue: [ agentCopy copyForChat ]
		             ifFalse: [ agentCopy ].
	chats add: (ChatPharoChat new
			 agent: agentCopy;
			 yourself).
        ChatPharoLogger logFrontend: 'New chat session created'
                details: (Dictionary new
                        at: 'totalChats' put: chats size;
                        at: 'agent' put: (ChatPharoLogger agentNameFor: agentCopy);
                        yourself)
]

{ #category : 'initialization' }
ChatPharo >> presenter [

	^ ChatPharoPresenter on: self 
]

{ #category : 'accessing' }
ChatPharo >> removeAllChats [

	| removed |
	chats do: [ :each | each clearChat ].
	        removed := chats size.
        chats removeAll.
        ChatPharoLogger logFrontend: 'All chats removed'
                details: (Dictionary new
                        at: 'removedCount' put: removed;
                        yourself)
]

{ #category : 'accessing' }
ChatPharo >> removeChatAt: anIndex [

	        | removedChat agentName |
        removedChat := chats at: anIndex ifAbsent: [ nil ].
        chats removeAt: anIndex.
        agentName := removedChat
                ifNotNil: [ ChatPharoLogger agentNameFor: removedChat agent ]
                ifNil: [ 'None' ].
        ChatPharoLogger logFrontend: 'Chat removed'
                details: (Dictionary new
                        at: 'index' put: anIndex;
                        at: 'remainingChats' put: chats size;
                        at: 'agent' put: agentName;
                        yourself)
]

{ #category : 'accessing' }
ChatPharo >> settings [

	^ settings
]
