"
UI for one chat tab: scrollable message column, a text field, and buttons for submit/cancel/clear. Receives push updates when the model posts a new assistant message.
"
Class {
	#name : 'ChatPharoChatPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'messagesLayout',
		'messageTextField',
		'submitButton',
		'cancelButton',
		'clearButton',
		'model',
		'inspectButton',
		'scrollableMessages',
		'generateTestButton'
	],
	#category : 'AI-ChatPharo-Spec-Core',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Core'
}

{ #category : 'initialization' }
ChatPharoChatPresenter >> connectPresenters [

	messageTextField whenSubmitDo: [ :text | self sendMessage ].
	submitButton action: [ self sendMessage ].
	cancelButton action: [
			model cancelMessage.
			messageTextField text: ''.
			submitButton enabled: true.
			messageTextField enabled: true ].
	inspectButton action: [ model inspect ].
	model whenAnswerReceivedDo: [ :message |
			messagesLayout add: message presenter withConstraints: [ :constraints | constraints height: (message height) * 2].
			messageTextField text: ''.
			submitButton enabled: true.
			messageTextField enabled: true ].
	 model whenToolExecutionDo: [
                        messageTextField text: 'Running, searching code and executing tools...' ]
]

{ #category : 'layout' }
ChatPharoChatPresenter >> defaultLayout [
    ^ SpBoxLayout newVertical
          spacing: 10;
          add: (SpScrollableLayout with: scrollableMessages);
          add: (SpBoxLayout newHorizontal
                   spacing: 5;
                   add: messageTextField;
                   add: submitButton expand: false;
                   add: cancelButton expand: false;
				   add: inspectButton expand: false;
				   add: generateTestButton expand: false;
                   yourself)
          expand: false;
          yourself
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> initializePresenters [

	messageTextField := self newTextInput
		                    placeholder: 'Type your message here...';
		                    yourself.

	submitButton := self newButton
		                label: 'Submit';
		                icon: (self iconNamed: #glamorousGo);
		                help: 'Submit prompt';
		                yourself.

	cancelButton := self newButton
		                label: 'Cancel';
		                icon: (self iconNamed: #delete);
		                help: 'Cancel prompt';
		                yourself.

	inspectButton := self newButton
		                 label: 'Inspect';
		                 icon: (self iconNamed: #inspect);
		                 help: 'Inspect the chat object';
		                 yourself.

	generateTestButton := self newButton
						label: 'Generate Test';
						icon: (self iconNamed: #smallTestIcon);
						help: 'Generate test for the current method';
						action: [ self generateTestCaseForCurrentMethod ];
						yourself.

	messagesLayout := SpBoxLayout newVertical.
	scrollableMessages := SpPresenter new.
	scrollableMessages layout: messagesLayout
]

{ #category : 'actions' }
ChatPharoChatPresenter >> generateTestCaseForCurrentMethod [

	| method class methodSource prompt response testClass testSelector |

	method := model agent method.
	method ifNil: [ ^ self inform: 'No method selected or method missing in agent.' ].

	class := method methodClass.
	methodSource := method sourceCode.

	prompt := String streamContents: [ :s |
		s nextPutAll: 'Here is a method from class ';
		  nextPutAll: class name;
		  nextPutAll: ':\n\n';
		  nextPutAll: method selector asString;
		  nextPutAll: '\n';
		  nextPutAll: methodSource;
		  nextPutAll: '\n\nPlease write a test method for it using Pharo Smalltalk.' ].

	response := model agent getResponseForPrompt: prompt.
	response ifNil: [ ^ self inform: 'No response received from LLM.' ].

	testClass := self ensureTestClassFor: class.
	testSelector := ('test_', method selector asString) asSymbol.

	(testClass canUnderstand: testSelector) ifTrue: [
		^ self inform: 'Test already exists: ', testSelector asString ].

	testClass compile: testSelector -> response.
	self inform: 'Test generated: ', testSelector asString.
]

{ #category : 'actions' }
ChatPharoChatPresenter >> ensureTestClassFor: aClass [
	| testClassName testClassSymbol |

	testClassName := aClass name, 'Test'.
	testClassSymbol := testClassName asSymbol.

	^ (Smalltalk includesKey: testClassSymbol)
		ifTrue: [ Smalltalk at: testClassSymbol ]
		ifFalse: [
			Object subclass: testClassSymbol
				instanceVariableNames: '';
				classVariableNames: '';
				package: 'AI-ChatPharo-Tests' ].
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter
		title: 'Pharo chat';
		initialExtent: 800@500
]

{ #category : 'initialization' }
ChatPharoChatPresenter >> sendMessage [

	| text |
	text := messageTextField text.
	        (model agent isConfigured)
                ifFalse: [
                        self inform: model agent configurationErrorMessage.
                        ^ self ].
	submitButton enabled: false.
	messageTextField enabled: false.
	messageTextField text: 'Running...'.
	model sendMessage: text
]

{ #category : 'accessing - model' }
ChatPharoChatPresenter >> setModelBeforeInitialization: anObject [

	model := anObject
]
