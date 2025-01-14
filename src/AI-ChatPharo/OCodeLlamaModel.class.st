"
Base class and specific implementations for different models used in API interactions.

•	fullName: Constructs the full name of the model for API requests.
•	name: Abstract method to return the model's name, implemented by subclasses.
"
Class {
	#name : 'OCodeLlamaModel',
	#superclass : 'OModel',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
OCodeLlamaModel class >> b13 [

	<ollamaInit: 'codellama:13b'>
	^ self new
		  tag: '13b';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> b7 [

	<ollamaInit: 'codellama:7b'>
	^ self new
		  tag: '7b';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> code [

	<ollamaInit: 'codellama:code'>
	^ self new
		  tag: 'code';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> code7b [

	<ollamaInit: 'codellama:7b-code'>
	^ self new
		  tag: '7b-code';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> codeLlama7binstructq3KS [

	<ollamaInit: 'codellama:7b-instruct-q3_K_S'>
	^ self new
		  tag: '7b-instruct-q3_K_S';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel class >> instruct7b [

	<ollamaInit: 'codellama:7b-instruct'>
	^ self new
		  tag: '7b-instruct';
		  yourself
]

{ #category : 'accessing' }
OCodeLlamaModel >> name [

	^ 'codellama'
]
