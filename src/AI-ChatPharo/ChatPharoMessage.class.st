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
		'assistantLabel',
		'feedback',
		'suggestionAccepted',
		'suggestionRejected',
		'feedbackTimestamp',
		'attachments',
		'thinking',
		'modelName',
		'inputTokens',
		'outputTokens',
		'responseSeconds',
		'tokensPerSecond'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'feedback' }
ChatPharoMessage >> acceptSuggestion [
	"Mark this message's suggestion as accepted"

	suggestionAccepted := true.
	suggestionRejected := false.
	feedbackTimestamp := DateAndTime now.

	"Submit to backend if enabled"
	ChatPharoFeedbackSubmitter submitSuggestionAccepted: (Dictionary new
			 at: 'messageId' put: self identityHash;
			 at: 'content' put: content;
			 at: 'answer' put: answer;
			 at: 'timestamp' put: feedbackTimestamp asString;
			 yourself)
]

{ #category : 'accessing' }
ChatPharoMessage >> addAttachment: aFileReference [

	attachments add: aFileReference
]

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
ChatPharoMessage >> attachments [

	^ attachments
]

{ #category : 'accessing' }
ChatPharoMessage >> attachments: aCollection [

	attachments := aCollection
]

{ #category : 'accessing' }
ChatPharoMessage >> content [

	^ content
]

{ #category : 'accessing' }
ChatPharoMessage >> content: anObject [

	content := anObject
]

{ #category : 'initialization' }
ChatPharoMessage >> feedback [ 

        ^ feedback
]

{ #category : 'initialization' }
ChatPharoMessage >> feedback: aBoolean [

        feedback := aBoolean
]

{ #category : 'feedback' }
ChatPharoMessage >> feedbackTimestamp [

	^ feedbackTimestamp
]

{ #category : 'feedback' }
ChatPharoMessage >> feedbackTimestamp: aDateAndTime [

	feedbackTimestamp := aDateAndTime
]

{ #category : 'accessing' }
ChatPharoMessage >> height [

	^ self presenter height
]

{ #category : 'initialization' }
ChatPharoMessage >> initialize [

	super initialize.
	content := String empty.
	answer := String empty.
	assistantLabel := 'Assistant'.
	feedback := nil.
	suggestionAccepted := false.
	suggestionRejected := false.
	feedbackTimestamp := nil.
	attachments := OrderedCollection new.
	thinking := String empty.
	modelName := ''.
	inputTokens := 0.
	outputTokens := 0.
	responseSeconds := 0.
	tokensPerSecond := 0
]

{ #category : 'initialization' }
ChatPharoMessage >> inputTokens [

	^ inputTokens ifNil: [ 0 ]
]

{ #category : 'initialization' }
ChatPharoMessage >> inputTokens: aNumber [

	inputTokens := aNumber
]

{ #category : 'initialization' }
ChatPharoMessage >> modelName [

	^ modelName ifNil: [ '' ]
]

{ #category : 'initialization' }
ChatPharoMessage >> modelName: aString [

	modelName := aString
]

{ #category : 'initialization' }
ChatPharoMessage >> outputTokens [

	^ outputTokens ifNil: [ 0 ]
]

{ #category : 'initialization' }
ChatPharoMessage >> outputTokens: aNumber [

	outputTokens := aNumber
]

{ #category : 'accessing' }
ChatPharoMessage >> presenter [

	^ presenter ifNil:[ presenter := ChatPharoMessagePresenter on: self ]
]

{ #category : 'feedback' }
ChatPharoMessage >> rejectSuggestion [
	"Mark this message's suggestion as rejected"

	suggestionRejected := true.
	suggestionAccepted := false.
	feedbackTimestamp := DateAndTime now.

	"Submit to backend if enabled"
	ChatPharoFeedbackSubmitter submitSuggestionRejected: (Dictionary new
			 at: 'messageId' put: self identityHash;
			 at: 'content' put: content;
			 at: 'answer' put: answer;
			 at: 'timestamp' put: feedbackTimestamp asString;
			 yourself)
]

{ #category : 'accessing' }
ChatPharoMessage >> removeAttachment: aFileReference [

	attachments remove: aFileReference ifAbsent: [  ]
]

{ #category : 'accessing' }
ChatPharoMessage >> resetPresenter [

	presenter := nil
]

{ #category : 'initialization' }
ChatPharoMessage >> responseSeconds [

	^ responseSeconds ifNil: [ 0 ]
]

{ #category : 'initialization' }
ChatPharoMessage >> responseSeconds: aNumber [

	responseSeconds := aNumber
]

{ #category : 'feedback' }
ChatPharoMessage >> suggestionAccepted [

	^ suggestionAccepted
]

{ #category : 'feedback' }
ChatPharoMessage >> suggestionAccepted: aBoolean [

	suggestionAccepted := aBoolean
]

{ #category : 'feedback' }
ChatPharoMessage >> suggestionRejected [

	^ suggestionRejected
]

{ #category : 'feedback' }
ChatPharoMessage >> suggestionRejected: aBoolean [

	suggestionRejected := aBoolean
]

{ #category : 'initialization' }
ChatPharoMessage >> thinking [
	"Return the thinking content from the agent response"

	^ thinking
]

{ #category : 'initialization' }
ChatPharoMessage >> thinking: aString [
	"Set the thinking content from the agent response"

	thinking := aString
]

{ #category : 'initialization' }
ChatPharoMessage >> tokensPerSecond [

	^ tokensPerSecond ifNil: [ 0 ]
]

{ #category : 'initialization' }
ChatPharoMessage >> tokensPerSecond: aNumber [

	tokensPerSecond := aNumber
]
