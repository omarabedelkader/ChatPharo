Class {
	#name : 'ChatPharoPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'presenter'
	],
	#category : 'AI-ChatPharo2-Tests-Core',
	#package : 'AI-ChatPharo2-Tests',
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
ChatPharoPresenterTest >> testAddNewChatAddsNotebookPage [ 

    presenter addNewChat.
    self assert: (presenter notebook pages size) equals: 1
]
