"
A **single user-and-assistant pair** as shown in the chat transcript.

* Just two strings: `content` (user) and `answer` (assistant).
* Knows how to build its own presenter lazily.
* **Why** – minimal View-Model used by the layout engine; keeps UI state separate from LLM history objects.


```smalltalk
(ChatPharoMessage new

	content: 'Bonjour';
	answer: 'Salut';
	yourself) presenter open.
```
"
Class {
	#name : 'ChatPharoMessage',
	#superclass : 'Object',
	#instVars : [
		'content',
		'answer',
		'presenter',
		'assistantLabel'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoMessage >> answer [

	^ answer
]

{ #category : 'accessing' }
ChatPharoMessage >> answer: anObject [

	answer := anObject
]

{ #category : 'accessing' }
ChatPharoMessage >> assistantLabel [

        ^ assistantLabel
]

{ #category : 'accessing' }
ChatPharoMessage >> assistantLabel: aString [

        assistantLabel := aString
]

{ #category : 'accessing' }
ChatPharoMessage >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoMessage >> content: anObject [

	content := anObject
]

{ #category : 'accessing' }
ChatPharoMessage >> height [
	^ 140.
]

{ #category : 'initialization' }
ChatPharoMessage >> initialize [

	super initialize.
	content := String empty.
	answer := String empty.
assistantLabel := 'Assistant'
]

{ #category : 'accessing' }
ChatPharoMessage >> presenter [

	^ presenter ifNil:[ presenter := ChatPharoMessagePresenter on: self ]
]
