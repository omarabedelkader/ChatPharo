Class {
	#name : 'ChatPharoWelcomeAgent',
	#superclass : 'ChatPharoAgent',
	#instVars : [],
	#category : 'AI-ChatPharo-Agent',
	#package : 'AI-ChatPharo-Agent'
}

{ #category : 'initialization' }
ChatPharoWelcomeAgent >> initialize [
	super initialize.
	self systemPrompt: 'Hi, I am Pharo — your assistant!';
	self response: ''.
]

{ #category : 'api' }
ChatPharoWelcomeAgent class >> displayName [
	^ 'Welcome'
]

{ #category : 'api' }
ChatPharoWelcomeAgent class >> isReachable [
	^ true
]

{ #category : 'api' }
ChatPharoWelcomeAgent class >> modelNames [
	^ #()
]

{ #category : 'initialization' }
ChatPharoWelcomeAgent >> getResponseForPrompt: prompt [
	"Respond only once, regardless of input"
	self history ifNil: [ self history: ChatPharoHistory new ].
	self history addMessage:
		(ChatPharoHistorySaver role: 'user' content: prompt).
	self response: '👋 Welcome to Pharo! Let me know how I can assist you.'.
	self history addMessage:
		(ChatPharoHistorySaver role: 'assistant' content: self response).
	^ self response
]

{ #category : 'accessing' }
ChatPharoWelcomeAgent >> isConfigured [
	^ true
]
