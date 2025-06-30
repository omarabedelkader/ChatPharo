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

    presenter addNewChat.
    presenter addNewChat.
    self assert: presenter notebook pages size equals: 2.
]

{ #category : 'running' }
ChatPharoPresenterTest >> testAddNewChatAddsNotebookPage [ 

    presenter addNewChat.
    self assert: (presenter notebook pages size) equals: 1
]

{ #category : 'running' }
ChatPharoPresenterTest >> testConnectionStatusUsesSettingsAgentWhenNoChat [

    presenter updateConnectionStatusOnce.
    self assert: (presenter instVarNamed: #connectionStatusLabel) label
        equals: 'Connected'.
]

{ #category : 'running' }
ChatPharoPresenterTest >> testInitializeWithoutAppIsSafe [ 

    | p |
    p := ChatPharoPresenter new.
    self shouldnt: [ p initializePresenters ] raise: Error.
]
