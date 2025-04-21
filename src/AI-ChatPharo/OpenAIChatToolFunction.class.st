Class {
	#name : 'OpenAIChatToolFunction',
	#superclass : 'Object',
	#instVars : [
		'name',
		'description',
		'block',
		'parameters'
	],
	#category : 'AI-ChatPharo-OpenAI',
	#package : 'AI-ChatPharo',
	#tag : 'OpenAI'
}

{ #category : 'instance creation' }
OpenAIChatToolFunction class >> name: functionName description: description parameters: parameters block: block [

	^ self basicNew
		initializeWithName: functionName description: description parameters: parameters block: block;
		yourself

]

{ #category : 'examples' }
OpenAIChatToolFunction class >> toolGetCurrentWeather [

	<sampleInstance>
	
	| weatherDataPerCity |
	
	weatherDataPerCity := Dictionary with: 'Paris' ->
		(Dictionary with: 'degrees_centigrade' -> 10 with: 'precipitation' -> 'rain').
	^ self name: 'get_current_weather'
		description: 'Get the current weather for a city.'
		parameters: (Dictionary
			with: 'type' -> 'object'
			with: 'properties' -> (Dictionary
				with: 'city' -> (Dictionary
					with: 'type' -> 'string'
					with: 'description' -> 'The name of the city'))
			with: 'required' -> #('city'))
		block: [ :arguments | 
			(arguments at: 'city') in: [ :city |
				weatherDataPerCity at: city ifAbsent: [
					Dictionary with: 'error' -> ('No weather data available for ' , city) ] ] ]
]

{ #category : 'applying' }
OpenAIChatToolFunction >> applyTo: arguments [

	^ block value: arguments
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> block [

	^ block
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> description [

	^ description
]

{ #category : 'initialization' }
OpenAIChatToolFunction >> initializeWithName: initialName description: initialDescription parameters: initialParameters block: initialBlock [

	self initialize.
	name := initialName.
	description := initialDescription.
	parameters := initialParameters.
	block := initialBlock.

]

{ #category : 'accessing' }
OpenAIChatToolFunction >> name [

	^ name
]

{ #category : 'openAI API' }
OpenAIChatToolFunction >> openAIChatTool [

	^ Dictionary
		with: 'type' -> 'function'
		with: 'function' -> (Dictionary
			with: 'name' -> name
			with: 'description' -> description
			with: 'parameters' -> parameters)
]

{ #category : 'accessing' }
OpenAIChatToolFunction >> parameters [

	^ parameters
]
