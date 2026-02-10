Class {
	#name : 'ChatPharoSandboxValidationTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Sandbox',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Sandbox'
}

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testInvalidPrintOn [

	| validation |
	validation := ChatPharoSandboxValidation invalid: 'bad code' violations: #().
	self assert: (validation printString includesSubstring: 'invalid').
	self assert: (validation printString includesSubstring: 'bad code')
]

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testInvalidResultErrorMessage [

	| validation |
	validation := ChatPharoSandboxValidation invalid: 'syntax error' violations: #( 'syntax_error' ).
	self assert: validation errorMessage equals: 'syntax error'
]

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testInvalidResultIsInvalid [

	| validation |
	validation := ChatPharoSandboxValidation invalid: 'bad code' violations: #( 'violation1' ).
	self assert: validation isInvalid.
	self deny: validation isValid
]

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testInvalidResultViolations [

	| validation |
	validation := ChatPharoSandboxValidation invalid: 'err' violations: #( 'file access' 'network access' ).
	self assert: validation violations size equals: 2.
	self assert: (validation violations includes: 'file access')
]

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testValidPrintOn [

	| validation |
	validation := ChatPharoSandboxValidation valid.
	self assert: (validation printString includesSubstring: 'valid')
]

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testValidResultErrorMessageIsNil [

	| validation |
	validation := ChatPharoSandboxValidation valid.
	self assert: validation errorMessage isNil
]

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testValidResultHasNoViolations [

	| validation |
	validation := ChatPharoSandboxValidation valid.
	self assert: validation violations isEmpty
]

{ #category : 'tests' }
ChatPharoSandboxValidationTest >> testValidResultIsValid [

	| validation |
	validation := ChatPharoSandboxValidation valid.
	self assert: validation isValid.
	self deny: validation isInvalid
]
