"
Base class and specific implementations for different models used in API interactions.

•	fullName: Constructs the full name of the model for API requests.
•	name: Abstract method to return the model's name, implemented by subclasses.
"
Class {
	#name : 'OPhindCodeLlamaModel',
	#superclass : 'OModel',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
OPhindCodeLlamaModel class >> b7 [

	<ollamaInit: 'phind-codellama:34b-v2'>
	^ self new
		  tag: '34b-v2';
		  yourself
]

{ #category : 'accessing' }
OPhindCodeLlamaModel >> name [
	^ 'phind-codellama'
]
