Class {
	#name : 'ChatPharoTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'ChatPharo-Tests',
	#package : 'ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoTest >> setUp [

   super setUp.
   presenter := ChatPharo new.
]

{ #category : 'running' }
ChatPharoTest >> tearDown [ 

    presenter window ifNotNil: [ :w | w close ].
    super tearDown
]

{ #category : 'running' }
ChatPharoTest >> testAddNewChat [ 

    presenter open.
    self assert: presenter notebook pages size equals: 1.

    presenter addNewChat.
    self assert: presenter notebook pages size equals: 2.
    self assert: presenter notebook selectedPage title equals: 'New Chat'
]

{ #category : 'running' }
ChatPharoTest >> testDeleteAllChats [

    presenter open.
    self assert: presenter notebook pages size equals: 1.

    presenter deleteAllChats.
    self assert: presenter notebook pages size equals: 1.
    self assert: presenter notebook selectedPage title equals: 'Chat'

]

{ #category : 'running' }
ChatPharoTest >> testInitialWindow [ 

    | window |
    window := presenter open.
    self assert: window isDisplayed.
    self assert: presenter title equals: 'ChatPharo'.
    self assert: presenter notebook pages size equals: 1
]

{ #category : 'running' }
ChatPharoTest >> testTitle [

	| inputTitle baseTitle|
	inputTitle := 'ChatPharo'.
	baseTitle  := (ChatPharo new) title.
	self assert: inputTitle equals: baseTitle
	
]
