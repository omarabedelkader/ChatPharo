Class {
	#name : 'OllamaSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'modelsDrop',
		'refreshButton'
	],
	#category : 'AI-ChatPharo2-Spec',
	#package : 'AI-ChatPharo2-Spec'
}

{ #category : 'initialization' }
OllamaSettingsPresenter >> connectPresenters [
	modelsDrop whenSelectedItemChangedDo: [:name | model model: name ].
]

{ #category : 'initialization' }
OllamaSettingsPresenter >> defaultLayout [
	^ SpBoxLayout newHorizontal
		add: refreshButton expand: false;
		add: modelsDrop;
		yourself

]

{ #category : 'initialization' }
OllamaSettingsPresenter >> initializePresenters [
	super initializePresenters.

	modelsDrop    := SpDropListPresenter new.
	refreshButton := self newButton
			label: 'Refresh';
			icon: (self iconNamed: #refresh);
			action: [ self refreshModels ].

	self refreshModels.
]

{ #category : 'accessing' }
OllamaSettingsPresenter >> model [

	^ model
]

{ #category : 'accessing' }
OllamaSettingsPresenter >> modelsDrop [

	^ modelsDrop
]

{ #category : 'accessing' }
OllamaSettingsPresenter >> modelsDrop: anObject [

	modelsDrop := anObject
]

{ #category : 'accessing' }
OllamaSettingsPresenter >> refreshButton [

	^ refreshButton
]

{ #category : 'accessing' }
OllamaSettingsPresenter >> refreshButton: anObject [

	refreshButton := anObject
]

{ #category : 'initialization' }
OllamaSettingsPresenter >> refreshModels [
	modelsDrop
		items: model class modelNames;
		display: [:e | e].
	modelsDrop items ifNotEmpty: [ modelsDrop selectFirst ].
]

{ #category : 'initialization' }
OllamaSettingsPresenter >> setModelBeforeInitialization: anAgent [
	model := anAgent
]
