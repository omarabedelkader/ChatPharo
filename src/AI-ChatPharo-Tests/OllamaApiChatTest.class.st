Class {
	#name : 'OllamaApiChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'ollamaApiChat'
	],
	#category : 'AI-ChatPharo-Tests-Ollama',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Ollama'
}

{ #category : 'running' }
OllamaApiChatTest >> setUp [
	super setUp.

	"Put here a common initialization logic for tests"
	ollamaApiChat := OllamaApiChat new.
]

{ #category : 'tests' }
OllamaApiChatTest >> testAddRoleContent [

	"Nothing in the messages from the beginning"
	self assert: ollamaApiChat messages size = 0.
	
	"Add two, and chack"
	ollamaApiChat addRole: 'user' content: 'Killroy was here' .
	ollamaApiChat addRole: 'assistant' content: 'No, he could not come here' .
	
	self assert: (ollamaApiChat messages first at: 'content') equals: 'Killroy was here'.
	
	self assert: (ollamaApiChat messages second at: 'role') equals: 'assistant'
	
]

{ #category : 'tests' }
OllamaApiChatTest >> testMessagesInJSON [
	self assert: ollamaApiChat messagesInJSON size = 2. "[]"
	
	ollamaApiChat addRole: 'user' content:'Killroy was here' .
	self assert: ollamaApiChat messagesInJSON size = 2. "[]"
	
]
