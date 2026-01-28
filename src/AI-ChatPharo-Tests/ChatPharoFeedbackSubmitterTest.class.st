Class {
	#name : 'ChatPharoFeedbackSubmitterTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Memory',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Memory'
}

{ #category : 'tests' }
ChatPharoFeedbackSubmitterTest >> testBackendUrlConfiguration [

	| originalUrl newUrl |
	originalUrl := ChatPharoFeedbackSubmitter backendUrl.

	[
	newUrl := 'https://test.example.com/feedback'.
	ChatPharoFeedbackSubmitter backendUrl: newUrl.
	self assert: ChatPharoFeedbackSubmitter backendUrl equals: newUrl ]
		ensure: [ ChatPharoFeedbackSubmitter backendUrl: originalUrl ]
]

{ #category : 'tests' }
ChatPharoFeedbackSubmitterTest >> testBuildRequestPayload [

	| feedbackDict payload parsedPayload |
	feedbackDict := Dictionary new
		                at: 'type' put: 'test';
		                at: 'content' put: 'Test feedback';
		                yourself.

	payload := ChatPharoFeedbackSubmitter buildRequestPayload:
		           feedbackDict.
	parsedPayload := STONJSON fromString: payload.

	self assert: (parsedPayload at: 'feedback') equals: feedbackDict.
	self assert: (parsedPayload includesKey: 'timestamp').
	self assert: (parsedPayload includesKey: 'pharoVersion').
	self assert: (parsedPayload includesKey: 'sessionId')
]

{ #category : 'tests' }
ChatPharoFeedbackSubmitterTest >> testEnabledConfiguration [

	| originalEnabled |
	originalEnabled := ChatPharoFeedbackSubmitter enabled.

	[
	ChatPharoFeedbackSubmitter enabled: true.
	self assert: ChatPharoFeedbackSubmitter enabled.

	ChatPharoFeedbackSubmitter enabled: false.
	self deny: ChatPharoFeedbackSubmitter enabled ]
		ensure: [ ChatPharoFeedbackSubmitter enabled: originalEnabled ]
]

{ #category : 'tests' }
ChatPharoFeedbackSubmitterTest >> testSubmitFeedbackWhenDisabled [

	| originalEnabled |
	originalEnabled := ChatPharoFeedbackSubmitter enabled.

	[
	ChatPharoFeedbackSubmitter enabled: false.
	"Should not raise an error when disabled"
	self
		shouldnt: [
			ChatPharoFeedbackSubmitter submitFeedback: (Dictionary new
						 at: 'type' put: 'test';
						 yourself) ]
		raise: Error ]
		ensure: [ ChatPharoFeedbackSubmitter enabled: originalEnabled ]
]

{ #category : 'tests' }
ChatPharoFeedbackSubmitterTest >> testSubmitMessageFeedback [

	| message feedbackDict originalEnabled |
	originalEnabled := ChatPharoFeedbackSubmitter enabled.

	[
	ChatPharoFeedbackSubmitter enabled: false. "Disable for testing"

	message := ChatPharoMessage new
		           content: 'Test question';
		           answer: 'Test answer';
		           yourself.

	"Should not raise an error"
	self
		shouldnt: [
			ChatPharoFeedbackSubmitter
				submitMessageFeedback: message
				positive: true ]
		raise: Error ]
		ensure: [ ChatPharoFeedbackSubmitter enabled: originalEnabled ]
]

{ #category : 'tests' }
ChatPharoFeedbackSubmitterTest >> testSubmitSuggestionAccepted [

	| suggestionDict originalEnabled |
	originalEnabled := ChatPharoFeedbackSubmitter enabled.

	[
	ChatPharoFeedbackSubmitter enabled: false. "Disable for testing"

	suggestionDict := Dictionary new
		                  at: 'messageId' put: 12345;
		                  at: 'content' put: 'Test suggestion';
		                  yourself.

	"Should not raise an error"
	self
		shouldnt: [
		ChatPharoFeedbackSubmitter submitSuggestionAccepted: suggestionDict ]
		raise: Error ]
		ensure: [ ChatPharoFeedbackSubmitter enabled: originalEnabled ]
]

{ #category : 'tests' }
ChatPharoFeedbackSubmitterTest >> testSubmitSuggestionRejected [

	| suggestionDict originalEnabled |
	originalEnabled := ChatPharoFeedbackSubmitter enabled.

	[
	ChatPharoFeedbackSubmitter enabled: false. "Disable for testing"

	suggestionDict := Dictionary new
		                  at: 'messageId' put: 12345;
		                  at: 'content' put: 'Test suggestion';
		                  yourself.

	"Should not raise an error"
	self
		shouldnt: [
		ChatPharoFeedbackSubmitter submitSuggestionRejected: suggestionDict ]
		raise: Error ]
		ensure: [ ChatPharoFeedbackSubmitter enabled: originalEnabled ]
]
