"
Sub-panel inserted by ChatPharoSettingsPresenter when the Gemini agent is selected. Edits host, apiKey, model, and temperature.
"
Class {
	#name : 'ChatPharoGeminiSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'hostField',
		'apiKeyField',
		'modelDrop',
		'model',
		'temperatureInput'
	],
	#category : 'AI-ChatPharo-Spec-Agent',
	#package : 'AI-ChatPharo-Spec',
	#tag : 'Agent'
}

{ #category : 'accessing' }
ChatPharoGeminiSettingsPresenter >> apiKeyField [

	^ apiKeyField
]

{ #category : 'accessing' }
ChatPharoGeminiSettingsPresenter >> apiKeyField: anObject [

	apiKeyField := anObject
]

{ #category : 'layout' }
ChatPharoGeminiSettingsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: 'Host:' expand: false;
		  add: hostField expand: false;
		  add: 'API-KEY:' expand: false;
		  add: apiKeyField expand: false;
		  add: 'Model:' expand: false;
		  add: modelDrop expand: false;
		  add: 'Temperature:' expand: false;
		  add: temperatureInput expand: false;
		  yourself
]

{ #category : 'accessing' }
ChatPharoGeminiSettingsPresenter >> hostField [

	^ hostField
]

{ #category : 'accessing' }
ChatPharoGeminiSettingsPresenter >> hostField: anObject [

	hostField := anObject
]

{ #category : 'initialization' }
ChatPharoGeminiSettingsPresenter >> initializePresenters [

	super initializePresenters.
	hostField := self newTextInput 
							placeholder:'generativelanguage.googleapis.com';
							text: model host.

	apiKeyField := self newTextInput
							placeholder: 'API-KEY';
							text: model apiKey.
									

	modelDrop := SpDropListPresenter new.

	self refreshModels.

	hostField whenTextChangedDo: [ :t | model host: t ].

	apiKeyField whenTextChangedDo: [ :t |
			model apiKey: t.
			self refreshModels ].

	modelDrop whenSelectedItemChangedDo: [ :m | model model: m ].

	temperatureInput := self newTextInput
		                    placeholder: '0.0';
		                    text: model temperature asString;
		                    yourself
]

{ #category : 'accessing' }
ChatPharoGeminiSettingsPresenter >> model [

	^ model
]

{ #category : 'accessing' }
ChatPharoGeminiSettingsPresenter >> modelDrop [

	^ modelDrop
]

{ #category : 'accessing' }
ChatPharoGeminiSettingsPresenter >> modelDrop: anObject [

	modelDrop := anObject
]

{ #category : 'initialization' }
ChatPharoGeminiSettingsPresenter >> refreshModels [ 


        modelDrop
                items: model modelNames;
                display: [ :m | m ].
        modelDrop items ifNotEmpty: [ modelDrop selectFirst ]
]

{ #category : 'accessing - model' }
ChatPharoGeminiSettingsPresenter >> setModelBeforeInitialization: anAgent [

	model := anAgent
]
