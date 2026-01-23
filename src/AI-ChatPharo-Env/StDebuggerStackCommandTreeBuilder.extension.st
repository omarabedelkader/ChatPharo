Extension { #name : 'StDebuggerStackCommandTreeBuilder' }

{ #category : '*AI-ChatPharo-Env' }
StDebuggerStackCommandTreeBuilder >> chatPharoCommandsGroup [
	"Build a command group for ChatPharo in the stack context menu"

	| group |
	group := (CmCommandGroup named: 'ChatPharo') asSpecGroup.
	group beDisplayedAsGroup.
	group description: 'Ask ChatPharo about the debugging context'.
	group iconName: #smallQuestion.
	group register: (self buildSpecCommand: ChatPharoDebuggerCommand forContext: stDebuggerInstance).
	^ group
]

{ #category : '*AI-ChatPharo-Env' }
StDebuggerStackCommandTreeBuilder class >> chatPharoExtensionGroupName [
	"Return the name of the ChatPharo extension group"

	^ 'ChatPharo'
]
