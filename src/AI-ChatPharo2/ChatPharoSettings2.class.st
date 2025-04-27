Class {
	#name : 'ChatPharoSettings2',
	#superclass : 'Object',
	#instVars : [
		'ollamaApi'
	],
	#category : 'AI-ChatPharo2',
	#package : 'AI-ChatPharo2'
}

{ #category : 'initialization' }
ChatPharoSettings2 >> initialize [

	super initialize.
	ollamaApi := OllamaApi new
]

{ #category : 'initialization' }
ChatPharoSettings2 >> models [

	^ ollamaApi class modelNames
]

{ #category : 'initialization' }
ChatPharoSettings2 >> ollamaApi [

	^ ollamaApi
]

{ #category : 'initialization' }
ChatPharoSettings2 >> presenter [

	^  ChatPharoSettingsPresenter2 on: self
]

{ #category : 'initialization' }
ChatPharoSettings2 >> useModel: aModelName [

	ollamaApi model: aModelName
]
