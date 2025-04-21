"
For each aspect of History, I store role and content.
"
Class {
	#name : 'ChatPharoHistorySaver',
	#superclass : 'Object',
	#instVars : [
		'role',
		'content'
	],
	#category : 'AI-ChatPharo-API',
	#package : 'AI-ChatPharo',
	#tag : 'API'
}

{ #category : 'instance creation' }
ChatPharoHistorySaver class >> role: aRole content: aContent [

	^ self new
		  role: aRole;
		  content: aContent;
		  yourself
]

{ #category : 'converting' }
ChatPharoHistorySaver >> content [

	^ content
]

{ #category : 'converting' }
ChatPharoHistorySaver >> content: anObject [

	content := anObject
]

{ #category : 'ollama models' }
ChatPharoHistorySaver >> historyStringOn: stream [
	"I return a role content string"
	stream 
		nextPutAll: role;
		nextPutAll: ': ';
		nextPutAll: content;
		nextPutAll: String cr.
]

{ #category : 'openAI API' }
ChatPharoHistorySaver >> putOpenAIChatMessageOn: stream [

	stream nextPut: (Dictionary with: 'role' -> self role with: 'content' -> self content)
]

{ #category : 'converting' }
ChatPharoHistorySaver >> role [

	^ role
]

{ #category : 'converting' }
ChatPharoHistorySaver >> role: anObject [

	role := anObject
]
