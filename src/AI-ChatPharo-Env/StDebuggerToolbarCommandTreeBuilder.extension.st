Extension { #name : 'StDebuggerToolbarCommandTreeBuilder' }

{ #category : '*AI-ChatPharo-Env' }
StDebuggerToolbarCommandTreeBuilder >> chatPharoCommandsGroup [
	"Build a command group containing ChatPharo integration commands"

	| group debuggerContext |
	group := (CmCommandGroup named: 'ChatPharo') asSpecGroup.
	group beDisplayedAsGroup.
	group description: 'ChatPharo AI assistance'.
	group iconName: #smallQuestion.
	group register: (self buildSpecCommand: ChatPharoDebuggerCommand forContext: stDebuggerInstance).
	debuggerContext ifNotNil: [
		group register: (self buildSpecCommand: ChatPharoDebuggerCommand forContext: debuggerContext) ].
	^ group
]

{ #category : '*AI-ChatPharo-Env' }
StDebuggerToolbarCommandTreeBuilder >> chatPharoDebuggerContext [
	"Return the debugger context for ChatPharo integration, handling Pharo debugger API differences."

	(self respondsTo: #debugger) ifTrue: [ ^ self debugger ].
	(self respondsTo: #stDebuggerInstance) ifTrue: [ ^ self stDebuggerInstance ].
	(self respondsTo: #debuggerPresenter) ifTrue: [ ^ self debuggerPresenter ].
	^ nil
]

{ #category : '*AI-ChatPharo-Env' }
StDebuggerToolbarCommandTreeBuilder class >> chatPharoExtensionGroupName [
	"Return the name of the ChatPharo extension group"

	^ 'ChatPharo'
]
