Class {
	#name : 'ChatPharo2Tests',
	#superclass : 'TestCase',
	#instVars : [
		'chat',
		'settings'
	],
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
}

{ #category : 'running' }
ChatPharo2Tests >> setUp [
    settings := ChatPharoSettings2 new.
    settings ollamaApi: MockOllamaApi new.
    chat := ChatPharoChat2 new.
    chat ollamaApi: settings ollamaApi.
]

{ #category : 'running' }
ChatPharo2Tests >> tearDown [
    chat cancelMessage.
]

{ #category : 'running' }
ChatPharo2Tests >> testChatStartsEmpty [
    self assert: chat messages isEmpty.

]
