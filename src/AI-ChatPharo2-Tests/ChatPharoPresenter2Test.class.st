Class {
	#name : 'ChatPharoPresenter2Test',
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
ChatPharoPresenter2Test >> setUp [ 

    super setUp.
    app := ChatPharo2 new.
    presenter := ChatPharoPresenter2 on: app.
    presenter initializePresenters
]

{ #category : 'running' }
ChatPharoPresenter2Test >> testAddNewChatAddsNotebookPage [ 

    presenter addNewChat.
    self assert: (presenter notebook pages size) equals: 1
]
