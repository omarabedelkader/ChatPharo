"
Base class and specific implementations for different models used in API interactions.

•	fullName: Constructs the full name of the model for API requests.
•	name: Abstract method to return the model's name, implemented by subclasses.
"
Class {
	#name : 'OPhi3Model',
	#superclass : 'OModel',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
OPhi3Model class >> medium [

	<ollamaInit: 'phi3:medium'>
	^ self new
		  tag: 'medium';
		  yourself
]

{ #category : 'accessing' }
OPhi3Model class >> mini [

	<ollamaInit: 'phi3:mini'>
	^ self new
		  tag: 'mini';
		  yourself
]

{ #category : 'accessing' }
OPhi3Model >> name [

	^ 'phi3'
]
