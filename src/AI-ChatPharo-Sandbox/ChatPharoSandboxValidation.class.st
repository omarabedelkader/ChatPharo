"
Represents the result of code validation before sandbox execution.
Contains:
* isValid - boolean indicating if code passed validation
* errorMessage - description of validation failure
* violations - array of specific violations found
"
Class {
	#name : 'ChatPharoSandboxValidation',
	#superclass : 'Object',
	#instVars : [
		'isValid',
		'errorMessage',
		'violations'
	],
	#category : 'AI-ChatPharo-Sandbox',
	#package : 'AI-ChatPharo-Sandbox'
}

{ #category : 'as yet unclassified' }
ChatPharoSandboxValidation class >> invalid: anErrorMessage violations: aViolationsArray [
	"Create an invalid validation result"

	^ self basicNew
		  initializeInvalid: anErrorMessage violations: aViolationsArray;
		  yourself
]

{ #category : 'as yet unclassified' }
ChatPharoSandboxValidation class >> valid [
	"Create a valid validation result"

	^ self basicNew
		  initializeValid;
		  yourself
]

{ #category : 'accessing' }
ChatPharoSandboxValidation >> errorMessage [

	^ errorMessage
]

{ #category : 'accessing' }
ChatPharoSandboxValidation >> initializeInvalid: anErrorMessage violations: aViolationsArray [

	super initialize.
	isValid := false.
	errorMessage := anErrorMessage.
	violations := aViolationsArray
]

{ #category : 'accessing' }
ChatPharoSandboxValidation >> initializeValid [

	super initialize.
	isValid := true.
	errorMessage := nil.
	violations := #(  )
]

{ #category : 'accessing' }
ChatPharoSandboxValidation >> isInvalid [

	^ isValid not
]

{ #category : 'accessing' }
ChatPharoSandboxValidation >> isValid [

	^ isValid
]

{ #category : 'accessing' }
ChatPharoSandboxValidation >> printOn: aStream [

	aStream nextPutAll: 'Validation('.
	isValid
		ifTrue: [ aStream nextPutAll: 'valid' ]
		ifFalse: [
			aStream
				nextPutAll: 'invalid: ';
				nextPutAll: errorMessage ].
	aStream nextPut: $)
]

{ #category : 'accessing' }
ChatPharoSandboxValidation >> violations [

	^ violations
]
