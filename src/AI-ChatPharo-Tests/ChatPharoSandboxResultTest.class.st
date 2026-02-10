Class {
	#name : 'ChatPharoSandboxResultTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Sandbox',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Sandbox'
}

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testExecutionTimeDefaultNil [

	| result |
	result := ChatPharoSandboxResult success: 42.
	self assert: result executionTime isNil
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testExecutionTimeSetter [

	| result |
	result := ChatPharoSandboxResult success: 42.
	result executionTime: 150.
	self assert: result executionTime equals: 150
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testFailureAsDictionary [

	| result dict |
	result := ChatPharoSandboxResult failure: 'bad code' violations: #( 'violation1' ).
	dict := result asDictionary.

	self assert: (dict at: 'success') equals: false.
	self assert: (dict at: 'error') equals: 'bad code'.
	self assert: (dict at: 'violations') equals: #( 'violation1' )
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testFailurePrintOn [

	| result |
	result := ChatPharoSandboxResult failure: 'bad code' violations: #().
	self assert: (result printString includesSubstring: 'failure').
	self assert: (result printString includesSubstring: 'bad code')
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testFailureResultErrorMessage [

	| result |
	result := ChatPharoSandboxResult failure: 'bad code' violations: #().
	self assert: result errorMessage equals: 'bad code'
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testFailureResultIsFailure [

	| result |
	result := ChatPharoSandboxResult failure: 'something went wrong' violations: #( 'violation1' ).
	self assert: result isFailure.
	self deny: result isSuccess
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testFailureResultValueIsNil [

	| result |
	result := ChatPharoSandboxResult failure: 'error' violations: #().
	self assert: result value isNil
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testFailureResultViolations [

	| result |
	result := ChatPharoSandboxResult failure: 'error' violations: #( 'File system access' 'Network access' ).
	self assert: result hasViolations.
	self assert: result violations size equals: 2
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testSuccessAsDictionary [ 

	| result dict |
	result := ChatPharoSandboxResult success: 42.
	dict := result asDictionary.

	self assert: (dict at: 'success') equals: true.
	self assert: (dict at: 'value') equals: '42'
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testSuccessPrintOn [

	| result |
	result := ChatPharoSandboxResult success: 42.
	self assert: (result printString includesSubstring: 'success')
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testSuccessResultErrorMessageIsNil [

	| result |
	result := ChatPharoSandboxResult success: 42.
	self assert: result errorMessage isNil
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testSuccessResultHasNoViolations [

	| result |
	result := ChatPharoSandboxResult success: 42.
	self deny: result hasViolations.
	self assert: result violations isEmpty
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testSuccessResultIsSuccess [

	| result |
	result := ChatPharoSandboxResult success: 42.
	self assert: result isSuccess.
	self deny: result isFailure
]

{ #category : 'tests' }
ChatPharoSandboxResultTest >> testSuccessResultValue [

	| result |
	result := ChatPharoSandboxResult success: 'hello'.
	self assert: result value equals: 'hello'
]
