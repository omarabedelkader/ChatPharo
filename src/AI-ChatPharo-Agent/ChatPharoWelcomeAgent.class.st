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
	self systemPrompt: 'Hi, I am ChatPharo — your assistant. How would you like me to help you today?'.
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
    
	self history ifNil: [ self history: ChatPharoHistory new ].
	self history addMessage: (ChatPharoHistorySaver role: 'user' content: prompt).

	self response: '👋 Welcome to ChatPharo! I can help you with:

- Starting a new chat session
- Asking or answering questions
- Summarizing and explaining code
- Talking to different AI agents
- Switching models or API settings

How can I assist you today?'.

	self history addMessage: (ChatPharoHistorySaver role: 'assistant' content: self response).
	^ self response
]

{ #category : 'accessing' }
ChatPharoWelcomeAgent >> isConfigured [
	^ true
]