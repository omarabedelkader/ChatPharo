Class {
	#name : 'ChatPharoCustomToolTest',
	#superclass : 'TestCase',
	#instVars : [
		'tool'
	],
	#category : 'AI-ChatPharo-Tests-Tools',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tools'
}

{ #category : 'running' }
ChatPharoCustomToolTest >> setUp [

	super setUp.
	tool := ChatPharoCustomTool new
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testAddMultipleParameters [

	tool addParameterNamed: 'query' type: 'string' description: 'Search query' required: true.
	tool addParameterNamed: 'limit' type: 'integer' description: 'Max results' required: false.

	self assert: tool parameterDefinitions size equals: 2
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testAddParameter [

	tool addParameterNamed: 'query' type: 'string' description: 'Search query' required: true.

	self assert: tool parameterDefinitions size equals: 1.
	self assert: (tool parameterDefinitions first at: 'name') equals: 'query'.
	self assert: (tool parameterDefinitions first at: 'type') equals: 'string'.
	self assert: (tool parameterDefinitions first at: 'description') equals: 'Search query'.
	self assert: (tool parameterDefinitions first at: 'required')
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testBuildBlockExecutes [

	| block result |
	tool codeString: 'arguments at: ''x'''.
	block := tool buildBlock.

	result := block value: (Dictionary with: 'x' -> 42).

	self assert: result equals: 42
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testBuildBlockHandlesErrors [

	| block result |
	tool codeString: '1 / 0'.
	block := tool buildBlock.

	result := block value: Dictionary new.

	self assert: (result at: 'error') notNil
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testBuildParametersSchema [

	| schema |
	tool addParameterNamed: 'query' type: 'string' description: 'Search query' required: true.
	tool addParameterNamed: 'limit' type: 'integer' description: 'Max results' required: false.

	schema := tool buildParametersSchema.

	self assert: (schema at: 'type') equals: 'object'.
	self assert: (schema at: 'properties') keys size equals: 2.
	self assert: ((schema at: 'properties') at: 'query') notNil.
	self assert: ((schema at: 'properties') at: 'limit') notNil.
	self assert: (schema at: 'required') equals: #( 'query' )
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testBuildParametersSchemaNoRequiredParams [

	| schema |
	tool addParameterNamed: 'limit' type: 'integer' description: 'Max results' required: false.

	schema := tool buildParametersSchema.

	self assert: (schema at: 'required') isEmpty
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testCodeStringSetter [

	tool codeString: 'arguments at: ''x'''.
	self assert: tool codeString equals: 'arguments at: ''x'''
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testDefaultCodeString [

	self assert: (tool codeString includesSubstring: 'Hello from custom tool')
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testEnabledSetter [

	tool enabled: false.
	self deny: tool enabled.

	tool enabled: true.
	self assert: tool enabled
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testInitializeDefaults [

	self assert: tool name equals: ''.
	self assert: tool description equals: ''.
	self assert: tool parameterDefinitions isEmpty.
	self assert: tool enabled
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testNameDescriptionFactoryMethod [

	| customTool |
	customTool := ChatPharoCustomTool name: 'my_tool' description: 'A test tool'.

	self assert: customTool name equals: 'my_tool'.
	self assert: customTool description equals: 'A test tool'
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testParameterDefinitionsSetter [

	| params |
	params := OrderedCollection with: (Dictionary new at: 'name' put: 'x'; yourself).
	tool parameterDefinitions: params.

	self assert: tool parameterDefinitions size equals: 1
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testRemoveNonExistentParameterDoesNotFail [

	tool addParameterNamed: 'query' type: 'string' description: 'Search query' required: true.
	tool removeParameterNamed: 'nonexistent'.

	self assert: tool parameterDefinitions size equals: 1
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testRemoveParameter [

	tool addParameterNamed: 'query' type: 'string' description: 'Search query' required: true.
	tool addParameterNamed: 'limit' type: 'integer' description: 'Max results' required: false.

	tool removeParameterNamed: 'query'.

	self assert: tool parameterDefinitions size equals: 1.
	self assert: (tool parameterDefinitions first at: 'name') equals: 'limit'
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testTestWithArguments [

	| result |
	tool codeString: '(arguments at: ''a'') + (arguments at: ''b'')'.

	result := tool testWithArguments: (Dictionary with: 'a' -> 3 with: 'b' -> 4).

	self assert: result equals: 7
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testValidateCodeInvalid [

	tool codeString: '1 +'.
	self assert: (tool validateCode includesSubstring: 'Syntax error')
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testValidateCodeValid [

	tool codeString: '1 + 2'.
	self assert: tool validateCode isNil
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testValidateNameEmpty [

	tool name: ''.
	self assert: tool validateName equals: 'Tool name is required'
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testValidateNameNil [

	tool name: nil.
	self assert: tool validateName equals: 'Tool name is required'
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testValidateNameValid [

	tool name: 'my_tool_123'.
	self assert: tool validateName isNil
]

{ #category : 'running' }
ChatPharoCustomToolTest >> testValidateNameWithSpecialChars [

	tool name: 'my-tool!'.
	self assert: (tool validateName includesSubstring: 'letters, numbers, and underscores')
]
