Class {
	#name : 'ChatPharoDebuggerCommand',
	#superclass : 'CmdCommand',
	#category : 'AI-ChatPharo-Env-Debugger',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Debugger'
}

{ #category : 'default' }
ChatPharoDebuggerCommand class >> defaultDescription [

	^ 'Ask ChatPharo about this error'
]

{ #category : 'default' }
ChatPharoDebuggerCommand class >> defaultName [

	^ 'Ask ChatPharo'
]

{ #category : 'testing' }
ChatPharoDebuggerCommand >> canBeExecuted [
	"This command can be executed if the debugger feature is enabled and we have a valid debugger context"

	ChatPharoSettings default debuggerFeatureEnabled ifFalse: [ ^ false ].
	^ self context isNotNil and: [
		self context respondsTo: #interruptedContext ]
]

{ #category : 'testing' }
ChatPharoDebuggerCommand >> debugInfoFromContext: aDebugger [

	| debugContext exception errorMessage method receiver selector sourceCode stackTrace details |
	aDebugger ifNil: [ ^ nil ].
	debugContext := (aDebugger respondsTo: #interruptedContext)
		ifTrue: [ aDebugger interruptedContext ]
		ifFalse: [ nil ].
	exception := (aDebugger respondsTo: #exception)
		ifTrue: [ aDebugger exception ]
		ifFalse: [ nil ].
	errorMessage := exception
		ifNotNil: [ exception messageText ]
		ifNil: [ '' ].
	method := debugContext
		ifNotNil: [ debugContext method ]
		ifNil: [ nil ].
	receiver := debugContext ifNotNil: [
		(debugContext respondsTo: #receiver)
			ifTrue: [ debugContext receiver class name asString ]
			ifFalse: [ '' ] ] ifNil: [ '' ].
	selector := debugContext ifNotNil: [
		(debugContext respondsTo: #selector)
			ifTrue: [ debugContext selector asString ]
			ifFalse: [ '' ] ] ifNil: [ '' ].
	sourceCode := method
		ifNotNil: [
			(method respondsTo: #sourceCode)
				ifTrue: [ method sourceCode ]
				ifFalse: [ '' ] ]
		ifNil: [ '' ].
	stackTrace := self stackTraceFromDebugger: aDebugger context: debugContext.
	details := Dictionary new.
	exception ifNotNil: [ details at: 'exception' put: exception class name asString ].
	errorMessage isEmpty ifFalse: [ details at: 'errorMessage' put: errorMessage ].
	method ifNotNil: [ details at: 'method' put: method printString ].
	receiver isEmpty ifFalse: [ details at: 'receiver' put: receiver ].
	selector isEmpty ifFalse: [ details at: 'selector' put: selector ].
	sourceCode isEmpty ifFalse: [ details at: 'sourceCode' put: sourceCode ].
	stackTrace isEmpty ifFalse: [ details at: 'stackTrace' put: stackTrace ].
	^ details
]

{ #category : 'testing' }
ChatPharoDebuggerCommand >> execute [

	| debugInfo |
	debugInfo := self debugInfoFromContext: self context.
	debugInfo ifNil: [ ^ self ].
	ChatPharo askAboutDebugContext: debugInfo
]

{ #category : 'testing' }
ChatPharoDebuggerCommand >> icon [

	^ ChatPharoIcons chatPharoIcon
]

{ #category : 'testing' }
ChatPharoDebuggerCommand >> label [

	^ 'Ask ChatPharo'
]

{ #category : 'testing' }
ChatPharoDebuggerCommand >> stackTraceFromDebugger: aDebugger context: debugContext [

	| stackString |
	stackString := (aDebugger respondsTo: #stackString)
		ifTrue: [ aDebugger stackString ]
		ifFalse: [ '' ].
	stackString isEmpty ifTrue: [
		stackString := (debugContext respondsTo: #stackString)
			ifTrue: [ debugContext stackString ]
			ifFalse: [ '' ] ].
	stackString isEmpty ifTrue: [
		stackString := debugContext
			ifNotNil: [ debugContext printString ]
			ifNil: [ '' ] ].
	^ stackString
]
