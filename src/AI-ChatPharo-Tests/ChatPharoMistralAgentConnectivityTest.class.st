Class {
	#name : 'ChatPharoMistralAgentConnectivityTest',
	#superclass : 'TestCase',
	#instVars : [
		'oldClass'
	],
	#classVars : [
		'LastOpened'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'running' }
ChatPharoMistralAgentConnectivityTest >> setUp [ 

    super setUp.
    oldClass := Smalltalk at: #ZnClient.
    Smalltalk at: #ZnClient put: ChatPharoZnClientReachabilityStub.
]

{ #category : 'running' }
ChatPharoMistralAgentConnectivityTest >> tearDown [ 

    Smalltalk at: #ZnClient put: oldClass.
    super tearDown
]

{ #category : 'running' }
ChatPharoMistralAgentConnectivityTest >> testIsReachableFalseOnNetworkError [ 

    ChatPharoZnClientReachabilityStub shouldFail: true.
    self deny: ChatPharoMistralAgent isReachable.
]

{ #category : 'running' }
ChatPharoMistralAgentConnectivityTest >> testIsReachableTrueWhenNoError [

    ChatPharoZnClientReachabilityStub shouldFail: false.
    self assert: ChatPharoMistralAgent isReachable.
]

{ #category : 'running' }
ChatPharoMistralAgentConnectivityTest >> testTestConnectionTrueWhenNoError [

    ChatPharoZnClientReachabilityStub shouldFail: false.
    self assert: (ChatPharoMistralAgent new testConnection).
]
