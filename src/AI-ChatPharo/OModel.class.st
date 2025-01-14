"
### `OModel` and Subclasses (`OCodeLlamaModel`, `ODeepseekerCodeModel`, etc.)
Base class and specific implementations for different models used in API interactions.

- **`fullName`**: Constructs the full name of the model for API requests.
- **`name`**: Abstract method to return the model's name, implemented by subclasses.
"
Class {
	#name : 'OModel',
	#superclass : 'Object',
	#instVars : [
		'tag'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
OModel >> fullName [

	^ String streamContents: [ :stream |
		stream << self name.
		self tag ifNotNil: [ :t |
			stream << ':'.
			stream << t ] ]
]

{ #category : 'accessing' }
OModel >> name [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OModel >> tag [
	^ tag
]

{ #category : 'accessing' }
OModel >> tag: anObject [

	tag := anObject
]
