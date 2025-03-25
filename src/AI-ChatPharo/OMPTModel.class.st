"
Base class and specific implementations for the MPT-Chat model used in API interactions.
fullName: Constructs the full name of the model for API requests.
name: Abstract method to return the model's name, implemented by subclasses.

b7: Initializes the 7B variant of the MPT-Chat model for Ollama.
b30: Initializes the 30B variant of the MPT-Chat model for Ollama.
"
Class {
	#name : 'OMPTChatModel',
	#superclass : 'OModel',
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'accessing' }
OMPTChatModel class >> b7 [

    <ollamaInit: 'mpt:7b-chat'>
    ^ self new
        tag: '7b';
        yourself
]

{ #category : 'accessing' }
OMPTChatModel class >> b30 [

    <ollamaInit: 'mpt:30b-chat'>
    ^ self new
        tag: '30b';
        yourself
]

{ #category : 'accessing' }
OMPTChatModel >> name [

    ^ 'mpt-chat'
]
