Class {
	#name : 'MockOllamaApi',
	#superclass : 'OllamaApi',
	#instVars : [
		'modelName',
		'systemPrompt'
	],
	#category : 'AI-ChatPharo2-Tests',
	#package : 'AI-ChatPharo2-Tests'
}

{ #category : 'api' }
MockOllamaApi class >> modelNames [
    "Answer the list of available mock models"
    ^ #('mock-model').
]

{ #category : 'accessing' }
MockOllamaApi >> getResponseForPrompt: aPromptString [
    "Return a deterministic fake answer so that assertions can
    match it exactly"
    ^ 'Mock response to: ', aPromptString.
]

{ #category : 'accessing' }
MockOllamaApi >> model: aModelName [
    modelName := aModelName.
]

{ #category : 'accessing' }
MockOllamaApi >> modelName [
    ^ modelName.
]

{ #category : 'accessing' }
MockOllamaApi >> system: aHistoryString [
    "Store the system prompt and answer self for call chaining"
    systemPrompt := aHistoryString.
    ^ self.
]
