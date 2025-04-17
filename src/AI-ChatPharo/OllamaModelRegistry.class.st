Class {
	#name : 'OllamaModelRegistry',
	#superclass : 'Object',
	#instVars : [
		'registry'
	],
	#classVars : [
		'Instance'
	],
	#category : 'AI-ChatPharo-Ollama',
	#package : 'AI-ChatPharo',
	#tag : 'Ollama'
}

{ #category : 'initialization' }
OllamaModelRegistry >> initialize [
	registry := Dictionary new.
]

{ #category : 'accessing' }
OllamaModelRegistry >> getOrCreateApiForModel: modelName [
	^ registry at: modelName ifAbsentPut: [
		(OllamaApi new model: modelName; yourself)
	].
]

{ #category : 'accessing' }
OllamaModelRegistry >> hasModel: modelName [
	^ registry includesKey: modelName
]

{ #category : 'accessing' }
OllamaModelRegistry >> allModels [
	^ registry keys
]

{ #category : 'accessing' }
OllamaModelRegistry >> apiForModel: modelName [
	^ registry at: modelName ifAbsent: [ nil ]
]

{ #category : 'singleton' }
OllamaModelRegistry class >> instance [
	Instance ifNil: [ Instance := self new initialize ].
	^ Instance
]

{ #category : 'singleton' }
OllamaModelRegistry class >> reset [
	Instance := nil.
]