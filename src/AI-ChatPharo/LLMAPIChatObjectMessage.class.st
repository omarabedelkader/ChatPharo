"
### `LLMAPIChatObjectMessage` Class
Represents a chat message in the API's expected format.

- **`asJsonableObject`**: Converts the message to a JSON-compatible object.
- **`role:` `content:`**: Constructor method for setting role and content.
- **`timestamp`**: Automatically sets a timestamp when a message is created.
"
Class {
	#name : 'LLMAPIChatObjectMessage',
	#superclass : 'LLMAPIObject',
	#instVars : [
		'role',
		'content',
		'timestamp'  
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'instance creation' }
LLMAPIChatObjectMessage class >> role: aRole content: aContent [

	^ self new
		  role: aRole;
		  content: aContent;
		  timestamp: DateAndTime now;  
		  yourself
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> asJsonableObject [

	^ Dictionary new
		  at: #content put: self content;
		  at: #role put: self role;
		  at: #timestamp put: self timestamp asString;  
		  yourself
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> content [

	^ content
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> role [

	^ role
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> role: anObject [

	role := anObject
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> timestamp [

	^ timestamp ifNil: [ timestamp := DateAndTime now ]  
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> timestamp: aTimestamp [

	timestamp := aTimestamp
]
