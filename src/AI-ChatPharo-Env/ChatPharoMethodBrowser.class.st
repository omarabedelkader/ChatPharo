Class {
	#name : 'ChatPharoMethodBrowser',
	#superclass : 'ChatPharoPackageBrowser',
	#instVars : [
		'methodName'
	],
	#category : 'AI-ChatPharo-Env-System Browser',
	#package : 'AI-ChatPharo-Env',
	#tag : 'System Browser'
}

{ #category : 'testing' }
ChatPharoMethodBrowser class >> shouldBeActivatedInContext: aBrowserContext [

	^ (super shouldBeActivatedInContext: aBrowserContext) and: [ aBrowserContext isMethodSelected ]
]

{ #category : 'accessing' }
ChatPharoMethodBrowser class >> tabOrder [

	^ -12
]

{ #category : 'initialization' }
ChatPharoMethodBrowser >> defaultTitle [

	^ methodName
]

{ #category : 'accessing' }
ChatPharoMethodBrowser >> methodName [

	^ methodName
]

{ #category : 'accessing' }
ChatPharoMethodBrowser >> methodName: anObject [

	methodName := anObject
]

{ #category : 'initialization' }
ChatPharoMethodBrowser >> setUpModelFromContext [

	methodName := context lastSelectedMethod selector.
	self updateAgentMethodName

]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgent [ 

	self updateAgentMethodName 
]

{ #category : 'update' }
ChatPharoMethodBrowser >> updateAgentMethodName [

	(chat notNil and: [ chat agent respondsTo: #methodName: ]) ifTrue: [
		chat agent methodName: methodName ].
]

{ #category : 'actions' }
ChatPharoMethodBrowser >> generateTestMethodFor: aMethod [

	| testClass selector prompt response methodBody agent |
	testClass := self findOrCreateTestClassFor: aMethod methodClass.
	selector := self testSelectorFor: aMethod selector.
	aMethod sourceCode ifNil: [ ^ self inform: 'Cannot generate test. Source code is unavailable.' ].

	(testClass includesSelector: selector)
		ifTrue: [ ^ self inform: 'Test method already exists.' ].

	prompt := 'Generate a test method in Smalltalk SUnit style for the following method. Only return the method body (without the method header):', String cr, aMethod sourceCode.

	agent := ChatPharoMistralAgent new.
	response := agent prompt: prompt.

	methodBody := response ifNil: [ 'self assert: false.' ].

	self generateTestMethodNamed: selector in: testClass withBody: methodBody.
]

{ #category : 'actions' }
ChatPharoMethodBrowser >> generateTestMethodNamed: aSelector in: aClass withBody: methodBody [
	| indentedBody fullSource |
	indentedBody := String streamContents: [ :stream |
		(methodBody lines) do: [ :line |
			stream
				nextPutAll: '    ';
				nextPutAll: line;
				cr ] ].
	fullSource := String streamContents: [ :s |
		s
			nextPutAll: aSelector asString;
			cr;
			nextPutAll: indentedBody ].
	aClass compile: fullSource classified: 'tests'.
]

{ #category : 'utils' }
ChatPharoMethodBrowser >> findOrCreateTestClassFor: aClass [
	| testClassName testClass |
	testClassName := aClass name , 'Test'.
	testClass := Smalltalk at: testClassName ifAbsent: [
		Object subclass: testClassName asSymbol instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' category: aClass category.
	].
	^ testClass
]

{ #category : 'utils' }
ChatPharoMethodBrowser >> testSelectorFor: aSelector [
	^ ('test', (aSelector asString first asUppercase), (aSelector asString allButFirst)) asSymbol
]