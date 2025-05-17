Class {
	#name : 'GeminiSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'hostField',
		'apiKeyField',
		'modelDrop',
		'temperatureSlider',
		'model'
	],
	#category : 'AI-ChatPharo2-Spec',
	#package : 'AI-ChatPharo2-Spec'
}

{ #category : 'accessing' }
GeminiSettingsPresenter >> apiKeyField [

	^ apiKeyField
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> apiKeyField: anObject [

	apiKeyField := anObject
]

{ #category : 'layout' }
GeminiSettingsPresenter >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add:'Host:' expand:false;
		add:hostField expand:false;
		add:'API‑Key:' expand:false;
		add:apiKeyField expand:false;
		add:'Model:' expand:false;
		add:modelDrop expand:false;
		add:'Temperature:' expand:false;
		add:temperatureSlider expand:false;
		yourself
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> hostField [

	^ hostField
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> hostField: anObject [

	hostField := anObject
]

{ #category : 'initialization' }
GeminiSettingsPresenter >> initializePresenters [
	super initializePresenters.
	hostField         := self newTextInput placeholder:'generativelanguage.googleapis.com'.
	apiKeyField       := self newTextInput placeholder:'AI…'.
	modelDrop         := SpDropListPresenter new
							items: GeminiAgent modelNames;
							display: [:m|m].
	temperatureSlider := SpSliderPresenter new
							min: 0; max: 1; value: model temperature.

	"Bind widgets → model"
	hostField whenTextChangedDo: [:t| model host: t ].
	apiKeyField whenTextChangedDo: [:t| model apiKey: t ].
	modelDrop  whenSelectedItemChangedDo: [:m| model model: m ].
	temperatureSlider whenValueChangedDo: [:v| model temperature: v ]
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> model [

	^ model
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> modelDrop [

	^ modelDrop
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> modelDrop: anObject [

	modelDrop := anObject
]

{ #category : 'accessing - model' }
GeminiSettingsPresenter >> setModelBeforeInitialization: anAgent [
	model := anAgent	"instance of GeminiAgent"
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> temperatureSlider [

	^ temperatureSlider
]

{ #category : 'accessing' }
GeminiSettingsPresenter >> temperatureSlider: anObject [

	temperatureSlider := anObject
]
