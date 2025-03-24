"
Base class and specific implementations for the Orca 2 model used in API interactions.

• fullName: Constructs the full name of the model for API requests.
• name: Abstract method to return the model's name, implemented by subclasses.
"
Class {
	#name : 'OOrca2Model',
	#superclass : 'OModel',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
OOrca2Model class >> b13 [

    <ollamaInit: 'orca2:13b'>
    ^ self new
        tag: '13b';
        yourself
]

{ #category : 'accessing' }
OOrca2Model class >> b7 [

    <ollamaInit: 'orca2:7b'>
    ^ self new
        tag: '7b';
        yourself
]

{ #category : 'accessing' }
OOrca2Model >> name [

    ^ 'orca2'
]
