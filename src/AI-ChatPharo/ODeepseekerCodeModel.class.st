"
Base class and specific implementations for different models used in API interactions.

•	fullName: Constructs the full name of the model for API requests.
•	name: Abstract method to return the model's name, implemented by subclasses.
"
Class {
	#name : 'ODeepseekerCodeModel',
	#superclass : 'OModel',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'as yet unclassified' }
ODeepseekerCodeModel class >> b33 [

	<ollamaInit: 'deepseek-coder:33b'>
	^ self new
		  tag: '33b';
		  yourself
]

{ #category : 'as yet unclassified' }
ODeepseekerCodeModel class >> b6 [

	<ollamaInit: 'deepseek-coder:6.7b'>
	^ self new
		  tag: '6.7b';
		  yourself
]

{ #category : 'accessing' }
ODeepseekerCodeModel >> name [

	^ 'deepseek-coder'
]
