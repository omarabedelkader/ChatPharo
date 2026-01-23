Extension { #name : 'StDebuggerToolbarCommandTreeBuilder' }

{ #category : '*AI-ChatPharo-Env' }
StDebuggerToolbarCommandTreeBuilder >> chatPharoCommandsGroup [
	"Build a command group containing ChatPharo integration commands"

	| group |
	group := (CmCommandGroup named: 'ChatPharo') asSpecGroup.
	group beDisplayedAsGroup.
	group description: 'ChatPharo AI assistance'.
	group iconName: #smallQuestion.
	group register: (self buildSpecCommand: ChatPharoDebuggerCommand forContext: stDebuggerInstance).
	^ group
]

{ #category : '*AI-ChatPharo-Env' }
StDebuggerToolbarCommandTreeBuilder class >> chatPharoExtensionGroupName [
	"Return the name of the ChatPharo extension group"

	^ 'ChatPharo'
]
