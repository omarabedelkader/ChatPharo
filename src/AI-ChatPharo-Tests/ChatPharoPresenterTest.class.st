Class {
	#name : 'ChatPharoPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'presenter'
	],
	#category : 'AI-ChatPharo-Tests-Core',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
ChatPharoPresenterTest >> setUp [ 

    super setUp.
    app := ChatPharo new.
    presenter := ChatPharoPresenter on: app.
    presenter initializePresenters
]

{ #category : 'running' }
ChatPharoPresenterTest >> testAddChatIncrementsNotebookPage [ 

    | initialCount |
    initialCount := presenter notebook pages size.
    presenter addNewChat.
    presenter addNewChat.
    self assert: presenter notebook pages size equals: initialCount + 2.

]

{ #category : 'running' }
ChatPharoPresenterTest >> testAddNewChatAddsNotebookPage [ 

    | initialCount |
    initialCount := presenter notebook pages size.
    presenter addNewChat.
    self assert: presenter notebook pages size equals: initialCount + 1.
]

{ #category : 'running' }
ChatPharoPresenterTest >> testInitializeWithoutAppIsSafe [ 

    | p |
    p := ChatPharoPresenter new.
    self shouldnt: [ p initializePresenters ] raise: Error.
]
