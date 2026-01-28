Class {
	#name : 'ChatPharoChatPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter',
		'chat'
	],
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
}

{ #category : 'running' }
ChatPharoChatPresenterTest >> setUp [

	super setUp.
	chat := ChatPharoChat new agent: ChatPharoNullAgent new.
	presenter := ChatPharoChatPresenter on: chat
]

{ #category : 'running' }
ChatPharoChatPresenterTest >> tearDown [

	presenter := nil.
	chat := nil.
	super tearDown
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testAttachedFilesInitiallyEmpty [

	self assert: (presenter instVarNamed: #attachedFiles) isEmpty
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testClearAttachments [

	| files |
	files := presenter instVarNamed: #attachedFiles.
	files add: FileLocator temp asFileReference.
	presenter clearAttachments.
	self assert: files isEmpty
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testHasAttachButton [

	self assert: (presenter instVarNamed: #attachButton) isNotNil
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testHasCancelButton [

	self assert: (presenter instVarNamed: #cancelButton) isNotNil
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testHasMessageTextField [

	self assert: (presenter instVarNamed: #messageTextField) isNotNil
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testHasMessagesLayout [

	self assert: (presenter instVarNamed: #messagesLayout) isNotNil
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testHasModel [

	self assert: (presenter instVarNamed: #model) equals: chat
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testHasNewChatButton [

	self assert: (presenter instVarNamed: #newChatButton) isNotNil
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testHasSubmitButton [

	self assert: (presenter instVarNamed: #submitButton) isNotNil
]

{ #category : 'tests' }
ChatPharoChatPresenterTest >> testInitialization [

	self assert: presenter isNotNil.
	self assert: (presenter isKindOf: SpPresenter)
]
