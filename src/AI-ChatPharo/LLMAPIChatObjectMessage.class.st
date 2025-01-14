"
### `LLMAPIChatObjectMessage` Class
Represents a chat message in the API's expected format.

- **`asJsonableObject`**: Converts the message to a JSON-compatible object.
- **`role:` `content:`**: Constructor method for setting role and content.
"
Class {
	#name : 'LLMAPIChatObjectMessage',
	#superclass : 'LLMAPIObject',
	#instVars : [
		'role',
		'content'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'as yet unclassified' }
LLMAPIChatObjectMessage class >> role: aRole content: aContent [

	^ self new
		  role: aRole;
		  content: aContent;
		  yourself
]

{ #category : 'accessing' }
LLMAPIChatObjectMessage >> asJsonableObject [

	^ Dictionary new
		  at: #content put: self content;
		  at: #role put: self role;
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
