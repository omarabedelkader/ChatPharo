Class {
	#name : 'ChatPharoGeminiAgentConnectivityTest',
	#superclass : 'TestCase',
	#instVars : [
		'oldClass'
	],
	#classVars : [
		'LastOpened'
	],
	#category : 'AI-ChatPharo-Tests-Agent',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Agent'
}

{ #category : 'running' }
ChatPharoGeminiAgentConnectivityTest >> setUp [ 
    super setUp.
    oldClass := Smalltalk at: #ZnClient.
    Smalltalk at: #ZnClient put: ChatPharoZnClientReachabilityStub.
]

{ #category : 'running' }
ChatPharoGeminiAgentConnectivityTest >> tearDown [ 

    Smalltalk at: #ZnClient put: oldClass.
    super tearDown
]

{ #category : 'running' }
ChatPharoGeminiAgentConnectivityTest >> testIsReachableFalseOnNetworkError [ 

    ChatPharoZnClientReachabilityStub shouldFail: true.
    self deny: ChatPharoGeminiAgent isReachable.
]

{ #category : 'running' }
ChatPharoGeminiAgentConnectivityTest >> testIsReachableTrueWhenNoError [ 

    ChatPharoZnClientReachabilityStub shouldFail: false.
    self assert: ChatPharoGeminiAgent isReachable.
]

{ #category : 'running' }
ChatPharoGeminiAgentConnectivityTest >> testTestConnectionFalseOnFailure [ 

    ChatPharoZnClientReachabilityStub shouldFail: true.
    self deny: (ChatPharoGeminiAgent new testConnection).
]

{ #category : 'running' }
ChatPharoGeminiAgentConnectivityTest >> testTestConnectionTrueWhenNoError [ 

    ChatPharoZnClientReachabilityStub shouldFail: false.
    self assert: (ChatPharoGeminiAgent new testConnection).
]
