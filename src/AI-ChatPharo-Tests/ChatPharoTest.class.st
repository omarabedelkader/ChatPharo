Class {
	#name : 'ChatPharoTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoTest >> setUp [
    super setUp.
    presenter := ChatPharo new.
    presenter open.
    presenter initializePresenters. 
]

{ #category : 'running' }
ChatPharoTest >> tearDown [ 
    presenter window ifNotNil: [ :w | w close ].
    presenter := nil.
    super tearDown.
]

{ #category : 'running' }
ChatPharoTest >> testAddNewChat [ 
    self assert: presenter notebook pages size equals: 1.

    presenter addNewChat.
    self assert: presenter notebook pages size equals: 2.
    self assert: presenter notebook selectedPage title equals: 'New Chat'.
]

{ #category : 'running' }
ChatPharoTest >> testDeleteChat [
    | chatTitle originalPages |
    presenter addNewChat.
    
    chatTitle := presenter notebook selectedPage title.
    originalPages := presenter notebook pages size.

    presenter deleteChat: chatTitle force: true.

    self assert: presenter notebook pages size equals: (originalPages - 1).
    self assert: (presenter notebook pages anySatisfy: [ :p | p title = chatTitle ]) not.
]

{ #category : 'running' }
ChatPharoTest >> testInitialWindow [ 
    self assert: presenter window isDisplayed.
    self assert: presenter title equals: 'ChatPharo'.
    self assert: presenter notebook pages size equals: 1.
]

{ #category : 'running' }
ChatPharoTest >> testTitle [
	| inputTitle baseTitle|
	inputTitle := 'ChatPharo'.
	baseTitle  := (ChatPharo new) title.
	self assert: inputTitle equals: baseTitle.
]
