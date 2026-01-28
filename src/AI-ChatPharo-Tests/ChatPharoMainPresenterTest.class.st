Class {
	#name : 'ChatPharoMainPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter',
		'app'
	],
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
}

{ #category : 'running' }
ChatPharoMainPresenterTest >> setUp [

	super setUp.
	ChatPharoSettings default welcomeMessageEnabled: false.
	app := ChatPharo new.
	app settings instVarNamed: #agent put: ChatPharoNullAgent new.
	presenter := ChatPharoPresenter on: app
]

{ #category : 'running' }
ChatPharoMainPresenterTest >> tearDown [

	presenter := nil.
	app := nil.
	ChatPharoSettings resetDefault.
	super tearDown
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testAddNewChat [

	| initialSize |
	initialSize := (presenter instVarNamed: #notebook) pages size.
	presenter addNewChat.
	self assert: (presenter instVarNamed: #notebook) pages size equals: initialSize + 1
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testDeleteAllChats [

	presenter addNewChat.
	presenter addNewChat.
	self assert: (presenter instVarNamed: #notebook) pages isNotEmpty.
	"Cannot test confirm dialog in automated test"
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testHasConnectionStatusLabel [

	self assert: (presenter instVarNamed: #connectionStatusLabel) isNotNil
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testHasModel [

	self assert: (presenter instVarNamed: #model) equals: app
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testHasNotebook [

	self assert: (presenter instVarNamed: #notebook) isNotNil
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testHasToolbar [

	self assert: (presenter instVarNamed: #toolbar) isNotNil
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testInitialization [

	self assert: presenter isNotNil.
	self assert: (presenter isKindOf: SpPresenter)
]

{ #category : 'tests' }
ChatPharoMainPresenterTest >> testNotebookStartsEmpty [

	| notebook |
	notebook := presenter instVarNamed: #notebook.
	self assert: notebook pages isEmpty
]
