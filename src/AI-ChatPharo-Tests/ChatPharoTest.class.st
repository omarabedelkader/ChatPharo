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
   presenter := ChatPharo open.
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
    self assert: (presenter notebook selectedPage title truncateTo: 4) equals: 'Chat'
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

{ #category : 'tests' }
ChatPharoTest >> testLoadChat [
]

{ #category : 'running' }
ChatPharoTest >> testModelInformation [
	
	
]

{ #category : 'tests' }
ChatPharoTest >> testOpenSettings [
]

{ #category : 'tests' }
ChatPharoTest >> testSaveCurrentChat [
]

{ #category : 'running' }
ChatPharoTest >> testTitle [

	| inputTitle chatPharo|
	inputTitle := 'ChatPharo'.
	(chatPharo := ChatPharo new) setTitle.
	self assert: inputTitle equals: chatPharo title.
	
]
