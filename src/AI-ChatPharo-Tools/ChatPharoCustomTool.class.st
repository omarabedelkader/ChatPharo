"
A user-defined custom tool that can be created through the UI.
Stores the tool definition including its parameters and code,
and can be converted to a ChatPharoClient for execution.
Instance Variables:
- name: String - the unique identifier for this tool
- description: String - human-readable description
- parameterDefinitions: OrderedCollection of Dictionaries - parameter specs
- codeString: String - Smalltalk code to execute (receives 'arguments' dictionary)
- enabled: Boolean - whether this tool is active
"
Class {
	#name : 'ChatPharoCustomTool',
	#superclass : 'Object',
	#instVars : [
		'name',
		'description',
		'parameterDefinitions',
		'codeString',
		'enabled'
	],
	#category : 'AI-ChatPharo-Tools',
	#package : 'AI-ChatPharo-Tools'
}

{ #category : 'instance creation' }
ChatPharoCustomTool class >> name: aName description: aDescription [

	^ self new
		name: aName;
		description: aDescription;
		yourself
]

{ #category : 'adding' }
ChatPharoCustomTool >> addParameterNamed: paramName type: paramType description: paramDescription required: isRequired [
	"Add a parameter definition to this tool"

	parameterDefinitions add: (Dictionary new
		at: 'name' put: paramName;
		at: 'type' put: paramType;
		at: 'description' put: paramDescription;
		at: 'required' put: isRequired;
		yourself)
]

{ #category : 'adding' }
ChatPharoCustomTool >> asChatPharoClient [
	"Convert this custom tool definition to an executable ChatPharoClient"

	^ ChatPharoClient
		name: name
		description: description
		parameters: self buildParametersSchema
		block: self buildBlock
]

{ #category : 'adding' }
ChatPharoCustomTool >> buildBlock [
	"Build an executable block from the code string"

	| compiledBlock |
	compiledBlock := Smalltalk compiler evaluate: '[ :arguments | ', codeString, ' ]'.
	^ [ :arguments |
		[ compiledBlock value: arguments ]
			on: Error
			do: [ :error |
				Dictionary with: 'error' -> error messageText ] ]
]

{ #category : 'adding' }
ChatPharoCustomTool >> buildParametersSchema [
	"Build JSON schema for parameters"

	| properties required |
	properties := Dictionary new.
	required := OrderedCollection new.

	parameterDefinitions do: [ :paramDef |
		| paramName propDict |
		paramName := paramDef at: 'name'.
		propDict := Dictionary new
			at: 'type' put: (paramDef at: 'type');
			at: 'description' put: (paramDef at: 'description');
			yourself.
		properties at: paramName put: propDict.
		(paramDef at: 'required') ifTrue: [ required add: paramName ] ].

	^ Dictionary
		with: 'type' -> 'object'
		with: 'properties' -> properties
		with: 'required' -> required asArray
]

{ #category : 'adding' }
ChatPharoCustomTool >> codeString [

	^ codeString ifNil: [ codeString := '| result |
result := ''Hello from custom tool!''.
Dictionary with: ''result'' -> result' ]
]

{ #category : 'adding' }
ChatPharoCustomTool >> codeString: aString [

	codeString := aString
]

{ #category : 'adding' }
ChatPharoCustomTool >> description [

	^ description ifNil: [ description := '' ]
]

{ #category : 'adding' }
ChatPharoCustomTool >> description: aString [

	description := aString
]

{ #category : 'adding' }
ChatPharoCustomTool >> enabled [

	^ enabled ifNil: [ enabled := true ]
]

{ #category : 'adding' }
ChatPharoCustomTool >> enabled: aBoolean [

	enabled := aBoolean
]

{ #category : 'adding' }
ChatPharoCustomTool >> initialize [

	super initialize.
	parameterDefinitions := OrderedCollection new.
	enabled := true
]

{ #category : 'adding' }
ChatPharoCustomTool >> name [

	^ name ifNil: [ name := '' ]
]

{ #category : 'adding' }
ChatPharoCustomTool >> name: aString [

	name := aString
]

{ #category : 'adding' }
ChatPharoCustomTool >> parameterDefinitions [

	^ parameterDefinitions ifNil: [ parameterDefinitions := OrderedCollection new ]
]

{ #category : 'adding' }
ChatPharoCustomTool >> parameterDefinitions: aCollection [

	parameterDefinitions := aCollection
]

{ #category : 'adding' }
ChatPharoCustomTool >> removeParameterNamed: paramName [
	"Remove a parameter definition by name"

	parameterDefinitions := parameterDefinitions reject: [ :paramDef |
		(paramDef at: 'name') = paramName ]
]

{ #category : 'adding' }
ChatPharoCustomTool >> testWithArguments: argumentsDict [
	"Test the tool execution with given arguments. Returns the result or error."

	| client |
	client := self asChatPharoClient.
	^ client applyTo: argumentsDict
]

{ #category : 'adding' }
ChatPharoCustomTool >> validateCode [
	"Validate the code string syntax. Returns nil if valid, error message if invalid."

	[ OCParser parseExpression: '[ :arguments | ', codeString, ' ]' ]
		on: OCCodeError
		do: [ :error | ^ 'Syntax error at position {1}: {2}' format: { error position. error messageText } ].
	^ nil
]

{ #category : 'adding' }
ChatPharoCustomTool >> validateName [
	"Validate the tool name. Returns nil if valid, error message if invalid."

	name isEmptyOrNil ifTrue: [ ^ 'Tool name is required' ].
	(name allSatisfy: [ :c | c isAlphaNumeric or: [ c = $_ ] ]) ifFalse: [
		^ 'Tool name must contain only letters, numbers, and underscores' ].
	^ nil
]
