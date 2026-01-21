"
Represents the result of a sandbox code evaluation.
Contains:
* success - boolean indicating if execution succeeded
* value - the result value if successful
* errorMessage - error description if failed
* violations - array of security violations found
Usage:
```smalltalk
result := ChatPharoSandbox withDefaults evaluate: '1 + 2'.
result isSuccess ifTrue: [ result value ].
```
"
Class {
	#name : 'ChatPharoSandboxResult',
	#superclass : 'Object',
	#instVars : [
		'success',
		'value',
		'errorMessage',
		'violations',
		'executionTime'
	],
	#category : 'AI-ChatPharo-Sandbox',
	#package : 'AI-ChatPharo-Sandbox'
}

{ #category : 'as yet unclassified' }
ChatPharoSandboxResult class >> failure: anErrorMessage violations: aViolationsArray [
	"Create a failed result with error message and violations"

	^ self basicNew
		  initializeFailure: anErrorMessage violations: aViolationsArray;
		  yourself
]

{ #category : 'as yet unclassified' }
ChatPharoSandboxResult class >> success: aValue [
	"Create a successful result with the given value"

	^ self basicNew
		  initializeSuccess: aValue;
		  yourself
]

{ #category : 'converting' }
ChatPharoSandboxResult >> asDictionary [
	"Convert to dictionary format for tool responses"

	success ifTrue: [
		^ Dictionary
			  with: 'success' -> true
			  with: 'value' -> value asString ].

	^ Dictionary
		  with: 'success' -> false
		  with: 'error' -> errorMessage
		  with: 'violations' -> violations
]

{ #category : 'converting' }
ChatPharoSandboxResult >> errorMessage [

	^ errorMessage
]

{ #category : 'converting' }
ChatPharoSandboxResult >> executionTime [

	^ executionTime
]

{ #category : 'converting' }
ChatPharoSandboxResult >> executionTime: milliseconds [

	executionTime := milliseconds
]

{ #category : 'converting' }
ChatPharoSandboxResult >> hasViolations [

	^ violations notNil and: [ violations notEmpty ]
]

{ #category : 'converting' }
ChatPharoSandboxResult >> initializeFailure: anErrorMessage violations: aViolationsArray [

	super initialize.
	success := false.
	errorMessage := anErrorMessage.
	violations := aViolationsArray
]

{ #category : 'converting' }
ChatPharoSandboxResult >> initializeSuccess: aValue [

	super initialize.
	success := true.
	value := aValue.
	violations := #(  )
]

{ #category : 'converting' }
ChatPharoSandboxResult >> isFailure [

	^ success not
]

{ #category : 'converting' }
ChatPharoSandboxResult >> isSuccess [

	^ success
]

{ #category : 'converting' }
ChatPharoSandboxResult >> printOn: aStream [

	aStream nextPutAll: 'SandboxResult('.
	success
		ifTrue: [
			aStream
				nextPutAll: 'success: ';
				print: value ]
		ifFalse: [
			aStream
				nextPutAll: 'failure: ';
				nextPutAll: errorMessage ].
	aStream nextPut: $)
]

{ #category : 'converting' }
ChatPharoSandboxResult >> value [

	^ value
]

{ #category : 'converting' }
ChatPharoSandboxResult >> violations [

	^ violations
]
