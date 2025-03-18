"
Base class and specific implementations for the Zephyr model used in API interactions.

• fullName: Constructs the full name of the model for API requests.
• name: Abstract method to return the model's name, implemented by subclasses.
"

Class {
    #name : 'OZephyrModel',
    #superclass : 'OModel',
    #category : 'AI-ChatPharo-API',
    #package : 'AI-ChatPharo',
    #tag : 'API'
}

{ #category : 'accessing' }
OZephyrModel class >> sevenB [

    <ollamaInit: 'zephyr:7b'>
    ^ self new
        tag: '7b';
        yourself
]

{ #category : 'accessing' }
OZephyrModel class >> beta [

    <ollamaInit: 'zephyr:beta'>
    ^ self new
        tag: 'beta';
        yourself
]

{ #category : 'accessing' }
OZephyrModel class >> default [  

    <ollamaInit: 'zephyr:7b'>   
    ^ self new
        tag: '7b';
        yourself
]

{ #category : 'accessing' }
OZephyrModel >> name [

    ^ 'zephyr'
]
