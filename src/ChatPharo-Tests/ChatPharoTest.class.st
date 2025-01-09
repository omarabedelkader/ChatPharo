Class {
	#name : 'ChatPharoTest',
	#superclass : 'TestCase',
	#category : 'ChatPharo-Tests',
	#package : 'ChatPharo-Tests'
}

{ #category : 'tests' }
ChatPharoTest >> setUp [
	"Set up each test."
	super setUp.
]

{ #category : 'tests' }
ChatPharoTest >> tearDown [
	"Tear down after each test."
	super tearDown.
]

{ #category : 'tests' }
ChatPharoTest >> testDefaultLayout [
    "Verify the default layout configuration binds components properly."
    
    | presenter layout |
    presenter := ChatPharo new.
    layout := presenter defaultLayout.
    self assert: layout notNil description: 'Layout should not be nil.'.
    
    "Check that the layout is an SpBoxLayout and has correct submorphs (toolbar, notebook)."
    self assert: (layout isKindOf: SpBoxLayout)
        description: 'Expected layout to be an instance of SpBoxLayout.'.
    self assert: (layout children size = 2)
        description: 'Expected 2 elements in the layout: toolbar and notebook.'.

]

{ #category : 'tests' }
ChatPharoTest >> testOpen [
	"Ensure the open method initializes and displays the chat interface correctly."
	
	| presenter |
	presenter := ChatPharo new.
	self deny: presenter isOpen  "If the framework has a #isOpen or equivalent"
		description: 'Presenter should not be open before we send #open.'.
	
	presenter open.
	
	self assert: presenter isOpen
		description: 'Presenter must be open after #open.'.
	
	presenter close.
	self deny: presenter isOpen.
]

{ #category : 'tests' }
ChatPharoTest >> testTitle [
    | chatPharo |
    chatPharo := ChatPharo new.
    self assert: chatPharo title equals: 'ChatPharo'.
]
