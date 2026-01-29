Class {
	#name : 'ChatPharoPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'app',
		'presenter'
	],
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
}

{ #category : 'running' }
ChatPharoPresenterTest >> setUp [

	super setUp.
	ChatPharoSettings default welcomeMessageEnabled: false.
	app := ChatPharo new.
	presenter := ChatPharoPresenter on: app.
	presenter initializePresenters.
	app settings instVarNamed: #agent put: ChatPharoNullAgent new.
]

{ #category : 'running' }
ChatPharoPresenterTest >> tearDown [

	presenter := nil.
	app := nil.
	ChatPharoSettings resetDefault.
	super tearDown
]

{ #category : 'running' }
ChatPharoPresenterTest >> testAddChatIncrementsNotebookPage [ 

    presenter addNewChat.
    presenter addNewChat.
    self assert: presenter notebook pages size equals: 2.
]

{ #category : 'running' }
ChatPharoPresenterTest >> testAddNewChat [

	| initialSize |
	initialSize := (presenter instVarNamed: #notebook) pages size.
	presenter addNewChat.
	self assert: (presenter instVarNamed: #notebook) pages size equals: initialSize + 1
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
        equals: 'Disconnected'.
]

{ #category : 'tests' }
ChatPharoPresenterTest >> testDeleteAllChats [

	presenter addNewChat.
	presenter addNewChat.
	self assert: (presenter instVarNamed: #notebook) pages isNotEmpty.
	"Cannot test confirm dialog in automated test"
]

{ #category : 'tests' }
ChatPharoPresenterTest >> testHasConnectionStatusLabel [ 

	self assert: (presenter instVarNamed: #connectionStatusLabel) isNotNil.

	self assert: (presenter instVarNamed: #model) equals: app.

	self assert: (presenter instVarNamed: #notebook) isNotNil.

	self assert: (presenter instVarNamed: #toolbar) isNotNil
]

{ #category : 'tests' }
ChatPharoPresenterTest >> testInitialization [

	self assert: presenter isNotNil.
	self assert: (presenter isKindOf: SpPresenter)
]

{ #category : 'running' }
ChatPharoPresenterTest >> testInitializeWithoutAppIsSafe [ 

    | p |
    p := ChatPharoPresenter new.
    self shouldnt: [ p initializePresenters ] raise: Error.
]

{ #category : 'tests' }
ChatPharoPresenterTest >> testNotebookStartsEmpty [

	| notebook |
	notebook := presenter instVarNamed: #notebook.
	self assert: notebook pages isEmpty
]
