Class {
	#name : 'ChatPharoToolSupportTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Tools',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
ChatPharoToolSupportTest >> testGeminiAgentEmbeddingModelDoesNotSupportTools [
	"Embedding models don't support tool calling"

	| agent |
	agent := ChatPharoGeminiAgent new.
	agent apiKey: 'test-key'.
	agent model: 'models/text-embedding-004'.
	self deny: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testGeminiAgentFlashModelSupportsTools [

	| agent |
	agent := ChatPharoGeminiAgent new.
	agent apiKey: 'test-key'.
	agent model: 'models/gemini-2.0-flash'.
	self assert: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testGeminiAgentProModelSupportsTools [

	| agent |
	agent := ChatPharoGeminiAgent new.
	agent apiKey: 'test-key'.
	agent model: 'models/gemini-1.5-pro'.
	self assert: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testGeminiAgentWithoutModelReturnsFalse [

	| agent |
	agent := ChatPharoGeminiAgent new.
	agent apiKey: 'test-key'.
	self deny: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testMistralAgentEmbedModelDoesNotSupportTools [

	| agent |
	agent := ChatPharoMistralAgent new.
	agent apiKey: 'test-key'.
	agent model: 'mistral-embed'.
	self deny: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testMistralAgentLargeModelSupportsTools [

	| agent |
	agent := ChatPharoMistralAgent new.
	agent apiKey: 'test-key'.
	agent model: 'mistral-large-latest'.
	self assert: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testMistralAgentSmallModelSupportsTools [

	| agent |
	agent := ChatPharoMistralAgent new.
	agent apiKey: 'test-key'.
	agent model: 'mistral-small-latest'.
	self assert: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testMistralAgentWithoutModelReturnsFalse [

	| agent |
	agent := ChatPharoMistralAgent new.
	agent apiKey: 'test-key'.
	self deny: agent supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testMockAgentSupportsTools [

	self assert: ChatPharoMockAgent new supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testNullAgentDoesNotSupportTools [

	self deny: ChatPharoNullAgent new supportsToolCalling
]

{ #category : 'tests' }
ChatPharoToolSupportTest >> testOllamaAgentWithoutModelReturnsFalse [
	"Agent without model should return false"

	| agent |
	agent := ChatPharoOllamaAgent new.
	agent model: ''.
	self deny: agent supportsToolCalling
]
