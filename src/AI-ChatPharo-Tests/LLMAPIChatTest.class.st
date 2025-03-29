"
An LLMAPIChatTest is a test class for testing the behavior of LLMAPIChat.
"
Class {
	#name : 'LLMAPIChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chatAPI'
	],
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'running' }
LLMAPIChatTest >> setUp [
	super setUp.
	chatAPI := LLMAPIChat new.
]

{ #category : 'running' }
LLMAPIChatTest >> tearDown [ 
	chatAPI := nil.
	super tearDown.
]

{ #category : 'tests' }
LLMAPIChatTest >> testLLMAPIChatHasCorrectPath [
	self assert: (chatAPI path = 'v1/chat/completions').
]

{ #category : 'tests' }
LLMAPIChatTest >> testLLMAPIChatHasCorrectPayloadClass [
	self assert: (chatAPI payloadClass = LLMAPIChatObjectPayload).
]

{ #category : 'tests' }
LLMAPIChatTest >> testLLMAPIChatRequestSetup [
	chatAPI apiKey: 'test-key'.
	chatAPI host: 'api.example.com'.
	chatAPI prepareRequest.

	self assert: (chatAPI host = 'api.example.com').

	self assert: ((chatAPI client request headers at: 'Authorization' ifAbsent: [ '' ]) 
		includesSubstring: 'Bearer test-key').
]

{ #category : 'tests' }
LLMAPIChatTest >> testLLMAPIChatPerformRequest [
	| mockClient mockResponse response |

	mockResponse := ZnResponse ok: (ZnEntity text: '{"id":"123","object":"chat.completion","choices":[{"message":{"role":"assistant","content":"Hello!"}}]}').
	mockResponse contentType: 'application/json'.

	mockClient := ZnClient new.
	mockClient beOneShot.
	mockClient https.
	mockClient host: 'api.example.com'.
	mockClient path: 'v1/chat/completions'.
	mockClient request headerAt: 'Authorization' put: 'Bearer test-key'.
	mockClient request contentType: 'application/json'.

	chatAPI apiKey: 'test-key'.
	chatAPI host: 'api.example.com'.
	chatAPI content: (LLMAPIChatObjectPayload new).
	chatAPI client: mockClient.

	[ response := chatAPI performRequest ] 
		on: Error 
		do: [ :error | self fail: 'HTTP request failed with error: ', error messageText ].

	self assert: (response isKindOf: ZnResponse).
	self assert: (response code = 200) ifFalse: [ self fail: 'Request did not return 200 OK' ].
]
