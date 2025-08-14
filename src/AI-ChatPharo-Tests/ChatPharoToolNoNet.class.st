Class {
	#name : 'ChatPharoToolNoNet',
	#superclass : 'ChatPharoTool',
	#category : 'AI-ChatPharo-Tests',
	#package : 'AI-ChatPharo-Tests'
}

{ #category : 'initialization' }
ChatPharoToolNoNet >> initializeWithBaseURL: initialBaseURL apiKey: initialAPIKey system: initialSystem tools: initialTools [

	super initialize.
	baseURL := initialBaseURL.
	apiKey := initialAPIKey.
	systemPrompt := initialSystem.
	tools := initialTools.
	onToolExecution := nil.
	model := 'test-model'
]
