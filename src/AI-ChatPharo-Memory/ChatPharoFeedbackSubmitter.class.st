"
Handles submission of user feedback to a backend API endpoint.
Provides asynchronous feedback submission with error handling and retry logic.
## Features:
- Configurable backend URL endpoint
- Asynchronous submission to avoid blocking UI
- Automatic retry on network failures
- Detailed logging of submission status
- Support for different feedback types (accepted, rejected, correction, preference)
## Usage:
```smalltalk
\""\""\""Configure the backend URL\""\""\""
ChatPharoFeedbackSubmitter backendUrl: 'https://example.com/api/feedback'.
\""\""\""Submit feedback asynchronously\""\""\""
ChatPharoFeedbackSubmitter submitFeedback:
    (Dictionary new
        at: 'type' put: 'suggestion_accepted';
        at: 'content' put: 'User accepted code suggestion';
        at: 'messageId' put: someMessage identityHash;
        yourself).
```
"
Class {
	#name : 'ChatPharoFeedbackSubmitter',
	#superclass : 'Object',
	#classInstVars : [
		'backendUrl',
		'enabled',
		'apiKey'
	],
	#category : 'AI-ChatPharo-Memory',
	#package : 'AI-ChatPharo-Memory'
}

{ #category : 'accessing' }
ChatPharoFeedbackSubmitter class >> apiKey [
	"Return the API key for backend authentication"

	^ apiKey ifNil: [ '' ]
]

{ #category : 'accessing' }
ChatPharoFeedbackSubmitter class >> apiKey: aString [
	"Set the API key for backend authentication"

	apiKey := aString
]

{ #category : 'accessing' }
ChatPharoFeedbackSubmitter class >> backendUrl [
	"Return the backend URL for feedback submission"

	^ backendUrl ifNil: [ 'https://api.example.com/feedback' ]
]

{ #category : 'accessing' }
ChatPharoFeedbackSubmitter class >> backendUrl: aString [
	"Set the backend URL for feedback submission"

	backendUrl := aString
]

{ #category : 'accessing' }
ChatPharoFeedbackSubmitter class >> buildRequestPayload: feedbackDict [
	"Build the JSON payload for feedback submission"

	| payload |
	payload := Dictionary new
		           at: 'feedback' put: feedbackDict;
		           at: 'timestamp' put: DateAndTime now asString;
		           at: 'pharoVersion' put: SystemVersion current version;
		           at: 'sessionId' put: Smalltalk session identityHash;
		           yourself.

	^ STONJSON toString: payload
]

{ #category : 'accessing' }
ChatPharoFeedbackSubmitter class >> enabled [
	"Return whether feedback submission is enabled"

	^ enabled ifNil: [ enabled := false ]
]

{ #category : 'accessing' }
ChatPharoFeedbackSubmitter class >> enabled: aBoolean [
	"Enable or disable feedback submission"

	enabled := aBoolean.
	ChatPharoLogger logSystem: 'Feedback submission toggled'
		details: (Dictionary new
				 at: 'enabled' put: aBoolean;
				 yourself)
]

{ #category : 'submit' }
ChatPharoFeedbackSubmitter class >> submitFeedback: feedbackDict [
	"Submit feedback to the backend asynchronously"

	self enabled ifFalse: [ ^ self ].
[ self submitFeedbackSync: feedbackDict ]
		forkAt: Processor userBackgroundPriority
		named: 'Feedback Submission'
]

{ #category : 'submit' }
ChatPharoFeedbackSubmitter class >> submitFeedbackSync: feedbackDict [
	"Submit feedback synchronously with retry logic"

	| payload response success retryCount maxRetries aChatPharoFeedbackSubmitter |
	aChatPharoFeedbackSubmitter := self new.
	maxRetries := 3.
	retryCount := 0.
	success := false.

	[ success not and: [ retryCount < maxRetries ] ] whileTrue: [
			[
				payload := self buildRequestPayload: feedbackDict.
				response := ZnClient new
					            url: self backendUrl;
					            entity: (ZnEntity json: payload);
					            headerAt: 'Authorization' put: 'Bearer ' , self apiKey;
					            post;
					            response.

				response isSuccess
					ifTrue: [
							success := true.
							ChatPharoLogger logSystem: 'Feedback submitted successfully' details: (Dictionary new
									 at: 'feedbackType' put: (feedbackDict at: 'type' ifAbsent: [ 'unknown' ]);
									 at: 'statusCode' put: response code;
									 yourself) ]
					ifFalse: [
							ChatPharoLogger logSystem: 'Feedback submission failed' details: (Dictionary new
									 at: 'statusCode' put: response code;
									 at: 'attempt' put: retryCount + 1;
									 at: 'willRetry' put: retryCount < maxRetries - 1;
									 yourself).
							retryCount := retryCount + 1.
							retryCount < maxRetries ifTrue: [ (Delay forSeconds: 2 ** retryCount) wait ] ] ]
				on: Error
				do: [ :ex |
						ChatPharoLogger logSystem: 'Feedback submission error' details: (Dictionary new
								 at: 'error' put: ex messageText;
								 at: 'attempt' put: retryCount + 1;
								 yourself).
						retryCount := retryCount + 1.
						retryCount < maxRetries ifTrue: [ (Delay forSeconds: 2 ** retryCount) wait ] ] ]
]

{ #category : 'submit' }
ChatPharoFeedbackSubmitter class >> submitMessageFeedback: aMessage positive: isPositive [
	"Submit feedback for a specific message"

	| feedbackDict |
	feedbackDict := Dictionary new
		                at: 'type' put: (isPositive
				                 ifTrue: [ 'positive' ]
				                 ifFalse: [ 'negative' ]);
		                at: 'messageContent' put: (aMessage content ifNil: [ '' ]);
		                at: 'messageAnswer' put: (aMessage answer ifNil: [ '' ]);
		                at: 'messageId' put: aMessage identityHash;
		                at: 'agentLabel' put: (aMessage assistantLabel ifNil: [ 'Assistant' ]);
		                yourself.
	self submitFeedback: feedbackDict
]

{ #category : 'submit' }
ChatPharoFeedbackSubmitter class >> submitSuggestionAccepted: suggestionDict [
	"Submit feedback when a suggestion is accepted"

	| feedbackDict |
	feedbackDict := Dictionary new
		                at: 'type' put: 'suggestion_accepted';
		                at: 'suggestion' put: suggestionDict;
		                yourself.
	self submitFeedback: feedbackDict
]

{ #category : 'submit' }
ChatPharoFeedbackSubmitter class >> submitSuggestionRejected: suggestionDict [
	"Submit feedback when a suggestion is rejected"

	| feedbackDict |
	feedbackDict := Dictionary new
		                at: 'type' put: 'suggestion_rejected';
		                at: 'suggestion' put: suggestionDict;
		                yourself.
	self submitFeedback: feedbackDict
]
