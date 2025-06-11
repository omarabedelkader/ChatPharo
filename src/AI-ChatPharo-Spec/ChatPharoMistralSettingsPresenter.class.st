"
not supported yet
"
Class {
	#name : 'ChatPharoMistralSettingsPresenter',
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
ChatPharoMistralSettingsPresenter >> apiKeyField [

	^ apiKeyField
]

{ #category : 'accessing' }
ChatPharoMistralSettingsPresenter >> apiKeyField: anObject [

	apiKeyField := anObject
]

{ #category : 'layout' }
ChatPharoMistralSettingsPresenter >> defaultLayout [ 

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
ChatPharoMistralSettingsPresenter >> hostField [

	^ hostField
]

{ #category : 'accessing' }
ChatPharoMistralSettingsPresenter >> hostField: anObject [

	hostField := anObject
]

{ #category : 'layout' }
ChatPharoMistralSettingsPresenter >> initializePresenters [ 

    super initializePresenters.
    hostField := self newTextInput placeholder: 'api.mistral.ai'.
    apiKeyField := self newTextInput placeholder: 'API-KEY'.
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
ChatPharoMistralSettingsPresenter >> model [

	^ model
]

{ #category : 'accessing' }
ChatPharoMistralSettingsPresenter >> modelDrop [

	^ modelDrop
]

{ #category : 'accessing' }
ChatPharoMistralSettingsPresenter >> modelDrop: anObject [

	modelDrop := anObject
]

{ #category : 'layout' }
ChatPharoMistralSettingsPresenter >> refreshModels [ 

    modelDrop
        items: model modelNames;
        display: [ :m | m ].
    modelDrop items ifNotEmpty: [ modelDrop selectFirst ]
]

{ #category : 'layout' }
ChatPharoMistralSettingsPresenter >> setModelBeforeInitialization: anAgent [ 

    model := anAgent
]

{ #category : 'accessing' }
ChatPharoMistralSettingsPresenter >> temperatureInput [

	^ temperatureInput
]

{ #category : 'accessing' }
ChatPharoMistralSettingsPresenter >> temperatureInput: anObject [

	temperatureInput := anObject
]
