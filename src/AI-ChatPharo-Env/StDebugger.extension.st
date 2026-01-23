Extension { #name : 'StDebugger' }

{ #category : '*AI-ChatPharo-Env' }
StDebugger class >> chatPharoCommandsWith: aPresenter [
	"Extension method to add ChatPharo command to the debugger toolbar.
	This uses the Spec extension mechanism to integrate ChatPharo with StDebugger."

	<extensionCommands>
	^ { ChatPharoDebuggerCommand forSpecContext: aPresenter }
]
