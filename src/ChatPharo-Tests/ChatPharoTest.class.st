Class {
	#name : 'ChatPharoTest',
	#superclass : 'TestCase',
	#category : 'ChatPharo-Tests',
	#package : 'ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoTest >> setUp [

	super setUp.
]

{ #category : 'running' }
ChatPharoTest >> tearDown [ 

	super tearDown.
]

{ #category : 'running' }
ChatPharoTest >> testInitializePresenters [
    | instance notebook toolbar page |
    
    "Create an instance of the class and call the method under test"
    instance := ChatPharo new.
    instance initializePresenters.
    
    "Verify that the notebook and toolbar are initialized"
    notebook := instance instVarNamed: 'notebook'.
    self assert: notebook equals: (SpNotebookPresenter new).
    
    toolbar := instance instVarNamed: 'toolbar'.
    self assert: toolbar equals: (SpMenuBarPresenter new).
    
    "Verify that the notebook contains the 'Chat' page"
    page := notebook pages detect: [ :each | each title = 'Chat' ] ifNone: [ nil ].
    self assert: page notNil.
]

{ #category : 'running' }
ChatPharoTest >> testTitle [
	| inputTitle baseTitle|
	inputTitle := 'ChatPharo'.
	baseTitle  := (ChatPharo new) title.
	self assert: inputTitle equals: baseTitle
	
]
