Class {
	#name : 'ChatPharoShortcuts',
	#superclass : 'Object',
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'as yet unclassified' }
ChatPharoShortcuts class >> chatPharoKeymapOn: aBuilder [
	"Define the keyboard shortcut category for ChatPharo"
	<keymap>

	(aBuilder shortcut: #openChatPharo)
		category: #ChatPharo
		default: $o asKeyCombination, $c asKeyCombination
		do: [ :target | self openChatPharo ]
		description: 'Open ChatPharo'
]

{ #category : 'as yet unclassified' }
ChatPharoShortcuts class >> installAsGlobalCategory [
	"Install ChatPharo shortcuts as a global keyboard category"

	| category |
	category := KMCategory named: #ChatPharo.

	category
		addKeymapEntry: (KMKeymap
			shortcut: ($o asKeyCombination, $c asKeyCombination)
			action: [ self openChatPharo ]).

	KMRepository default addCategory: category.

	^ category
]

{ #category : 'as yet unclassified' }
ChatPharoShortcuts class >> openChatPharo [
	"Open a new ChatPharo window"

	ChatPharo new presenter open
]
