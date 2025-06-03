"
Equivalent sub-panel for the Ollama agent: lists local models and lets the user refresh/re-select them.
"
Class {
	#name : 'OllamaSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'modelsDrop',
		'refreshButton',
		'hostInput',
		'portInput',
		'temperatureInput'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo-Spec'
}

{ #category : 'initialization' }
OllamaSettingsPresenter >> connectPresenters [ 

    "When the user picks a different Ollama model:"
    modelsDrop whenSelectedItemChangedDo: [:name | model model: name ].

    "When the user edits the host field (e.g. 'api.myhost.com'): update the agent"
    hostInput whenTextChangedDo: [:text | model host: text ].

    "When the user edits the port field (e.g. '11434'): update the agent"
    portInput whenTextChangedDo: [:text | model port: text ].

    "When the user edits the temperature field (e.g. '0.7'): parse as Number and update"
    temperatureInput whenTextChangedDo: [:text |
        | num |
        num := 0.0.
        [ num := text asNumber ] on: Error do: [ :ex | num := model temperature ].  "keep old if parse fails"
        model temperature: num
    ].
]

{ #category : 'layout' }
OllamaSettingsPresenter >> defaultLayout [ 

    | mainLayout rowLayout modelRow hostRow portRow tempRow |

    "First row: model label, refresh button, and drop-down"
    modelRow := SpBoxLayout newHorizontal
        spacing: 8;
        add: (self newLabel label: 'Available models:') expand: false;
        add: self refreshButton expand: false;
        add: self modelsDrop height: 30;
        yourself.

    "Second row: host label + text input"
    hostRow := SpBoxLayout newHorizontal
        spacing: 8;
        add: (self newLabel label: 'Host (e.g. localhost):') expand: false;
        add: hostInput expand: true;
        yourself.

    "Third row: port label + text input"
    portRow := SpBoxLayout newHorizontal
        spacing: 8;
        add: (self newLabel label: 'Port (e.g. 11434):') expand: false;
        add: portInput expand: true;
        yourself.

    "Fourth row: temperature label + text input"
    tempRow := SpBoxLayout newHorizontal
        spacing: 8;
        add: (self newLabel label: 'Temperature (0.0 – 1.0):') expand: false;
        add: temperatureInput  expand: true;
        yourself.

    "Main vertical layout"
    mainLayout := SpBoxLayout newTopToBottom
        spacing: 8;
        borderWidth: 8;
        beNotHomogeneous;
        add: modelRow expand: false;
        add: hostRow expand: false;
        add: portRow expand: false;
        add: tempRow expand: false;
        yourself.

    ^ mainLayout
]

{ #category : 'initialization' }
OllamaSettingsPresenter >> initializePresenters [ 

    super initializePresenters.

    "Create the drop-list and button for models"
    modelsDrop    := SpDropListPresenter new.
    refreshButton := self newButton
        label: 'Refresh';
        icon: (self iconNamed: #refresh);
        action: [ self refreshModels ].
    self refreshModels.

    "Create host, port, temperature inputs and set their initial texts from the agent"
    hostInput := self newTextInput
        placeholder: 'localhost';
        text: (model host);
        yourself.

    portInput := self newTextInput
        placeholder: '11434';
        text: (model port);
        yourself.

    temperatureInput := self newTextInput
        placeholder: '0.0';
        text: (model temperature asString);
        yourself.

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
        display: [:eachModelName | eachModelName ].
    modelsDrop items ifNotEmpty: [ modelsDrop selectFirst ].
]

{ #category : 'accessing - model' }
OllamaSettingsPresenter >> setModelBeforeInitialization: anAgent [
	model := anAgent
]
