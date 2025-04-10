Class {
	#name : 'ChatPharoTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
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
ChatPharoTest >> testDeleteChat [

    | chatTitle originalPages |
    presenter open.
   
    presenter addNewChat.
    chatTitle := presenter notebook selectedPage title.
    originalPages := presenter notebook pages size.
            
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
ChatPharoTest >> testModelInformation [
	
	
]

{ #category : 'running' }
ChatPharoTest >> testTitle [

	| inputTitle baseTitle|
	inputTitle := 'ChatPharo'.
	baseTitle  := (ChatPharo new) title.
	self assert: inputTitle equals: baseTitle
	
]
