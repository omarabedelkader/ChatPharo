Class {
	#name : 'ChatPharoSpecChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'chat'
	],
	#category : 'ChatPharo-Tests',
	#package : 'ChatPharo-Tests'
}

{ #category : 'running' }
ChatPharoSpecChatTest >> setUp [

    super setUp.
    chat := ChatPharoSpecChat new
]

{ #category : 'running' }
ChatPharoSpecChatTest >> testInitialState [
 
    self assert: chat inputField text isEmpty.
    self assert: chat history model isEmpty

]
