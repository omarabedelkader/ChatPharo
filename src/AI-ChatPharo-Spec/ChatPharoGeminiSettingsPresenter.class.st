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
		'temperatureInput',
		'testButton'
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

        | mainLayout hostRow keyRow modelRow tempRow |
        hostRow := SpBoxLayout newHorizontal
                             spacing: 8;
                             add: (self newLabel label: 'Host')
                             expand: false;
                             add: hostField expand: true;
                             yourself.

        keyRow := SpBoxLayout newHorizontal
                            spacing: 8;
                            add: (self newLabel label: 'API Key:')
                            expand: false;
                            add: apiKeyField expand: true;
                            yourself.

        modelRow := SpBoxLayout newHorizontal
                              spacing: 8;
                              add: (self newLabel label: 'Model:')
                              expand: false;
                              add: modelDrop expand: true;
                              yourself.

        tempRow := SpBoxLayout newHorizontal
                             spacing: 8;
                             add: (self newLabel label: 'Temperature (0.0 – 1.0):')
                             expand: false;
                             add: temperatureInput expand: true;
                             yourself.

        mainLayout := SpBoxLayout newTopToBottom
                              spacing: 8;
                              borderWidth: 8;
                              beNotHomogeneous;
                              add: hostRow expand: false;
                              add: keyRow expand: false;
                              add: modelRow expand: false;
                              add: tempRow expand: false;
                            add: testButton expand: false;
                              yourself.

        ^ mainLayout
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
		             placeholder: 'generativelanguage.googleapis.com';
		             text: model host.

	apiKeyField := self newTextInput
		               placeholder: 'API-KEY';
		               text: (model apiKey isEmpty
                                       ifTrue: ''
                                       ifFalse: (String new: model apiKey size withAll: $*)).


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
		                    yourself.
	testButton := self newButton
                                label: 'Test Connection';
                                icon: (self iconNamed: #glamorousGo);
                                action: [ self testConnection ];
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
	        modelDrop items ifNotEmpty: [
            | selected |
            selected := modelDrop items
                detect: [:each | each = model model] ifNone: [ nil ].
            selected
                ifNotNil: [ modelDrop selectItem: selected ]
                ifNil: [ modelDrop selectFirst ]
        ]
]

{ #category : 'accessing - model' }
ChatPharoGeminiSettingsPresenter >> setModelBeforeInitialization: anAgent [

	model := anAgent
]

{ #category : 'initialization' }
ChatPharoGeminiSettingsPresenter >> testButton [ 

        ^ testButton
]

{ #category : 'initialization' }
ChatPharoGeminiSettingsPresenter >> testButton: anObject [ 

        testButton := anObject
]

{ #category : 'initialization' }
ChatPharoGeminiSettingsPresenter >> testConnection [ 
        (model testConnection)
                ifTrue: [ self inform: 'Connection successful.' ]
                ifFalse: [ self inform: 'Connection failed.' ]

]
