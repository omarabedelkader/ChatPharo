Extension { #name : 'StDebuggerStackCommandTreeBuilder' }

{ #category : '*AI-ChatPharo-Env' }
StDebuggerStackCommandTreeBuilder >> chatPharoCommandsGroup [
	"Build a command group for ChatPharo in the stack context menu"

	| group debuggerContext |
	debuggerContext := self chatPharoDebuggerContext.
	group := (CmCommandGroup named: 'ChatPharo') asSpecGroup.
	group beDisplayedAsGroup.
	group description: 'Ask ChatPharo about the debugging context'.
	group iconName: #smallQuestion.
	group register: (self buildSpecCommand: ChatPharoDebuggerCommand forContext: stDebuggerInstance).
	debuggerContext ifNotNil: [
		group register: (self buildSpecCommand: ChatPharoDebuggerCommand forContext: debuggerContext) ].
	^ group
]

{ #category : '*AI-ChatPharo-Env' }
StDebuggerStackCommandTreeBuilder >> chatPharoDebuggerContext [
	"Return the debugger context for ChatPharo integration, handling Pharo debugger API differences."

	(self respondsTo: #debugger) ifTrue: [ ^ self debugger ].
	(self respondsTo: #stDebuggerInstance) ifTrue: [ ^ self stDebuggerInstance ].
	(self respondsTo: #debuggerPresenter) ifTrue: [ ^ self debuggerPresenter ].
	^ nil
]

{ #category : '*AI-ChatPharo-Env' }
StDebuggerStackCommandTreeBuilder class >> chatPharoExtensionGroupName [
	"Return the name of the ChatPharo extension group"

	^ 'ChatPharo'
]
