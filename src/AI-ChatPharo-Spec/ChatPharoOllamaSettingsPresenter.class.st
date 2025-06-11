"
Equivalent sub-panel for the Ollama agent: lists local models and lets the user refresh/re-select them.
"
Class {
	#name : 'ChatPharoOllamaSettingsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'modelsDrop',
		'refreshButton',
		'hostInput',
		'portInput',
		'temperatureInput',
		'installInput',
		'installButton',
		'pullButton',
		'pullInput'
	],
	#category : 'AI-ChatPharo-Spec',
	#package : 'AI-ChatPharo-Spec'
}

{ #category : 'initialization' }
ChatPharoOllamaSettingsPresenter >> connectPresenters [

	modelsDrop whenSelectedItemChangedDo: [ :name | model model: name ].
	hostInput whenTextChangedDo: [ :text | model host: text ].
	portInput whenTextChangedDo: [ :text | model port: text ].
	temperatureInput whenTextChangedDo: [ :text |
			| num |
			num := 0.0.
			[ num := text asNumber ]
				on: Error
				do: [ :ex | num := model temperature ].
			model temperature: num ].
]

{ #category : 'layout' }
ChatPharoOllamaSettingsPresenter >> defaultLayout [

	| mainLayout rowLayout modelRow hostRow portRow tempRow installRow |
	modelRow := SpBoxLayout newHorizontal
		            spacing: 8;
		            add: (self newLabel label: 'Available models:')
		            expand: false;
		            add: self modelsDrop expand: true;
		            add: self refreshButton expand: false;
		            yourself.

	installRow := SpBoxLayout newHorizontal
		              spacing: 8;
		              add: (self newLabel label: 'Pull model:')
		              expand: false;
		              add: installInput expand: true;
		              add: installButton expand: false;
		              yourself.

	hostRow := SpBoxLayout newHorizontal
		           spacing: 8;
		           add: (self newLabel label: 'Host (e.g. localhost):')
		           expand: false;
		           add: hostInput expand: true;
		           yourself.

	portRow := SpBoxLayout newHorizontal
		           spacing: 8;
		           add: (self newLabel label: 'Port (e.g. 11434):')
		           expand: false;
		           add: portInput expand: true;
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
		              add: modelRow expand: false;
		              add: installRow expand: false;
		              add: hostRow expand: false;
		              add: portRow expand: false;
		              add: tempRow expand: false;
		              yourself.

	^ mainLayout
]

{ #category : 'initialization' }
ChatPharoOllamaSettingsPresenter >> initializePresenters [

	super initializePresenters.

	modelsDrop := SpDropListPresenter new.
	refreshButton := self newButton
		                 label: 'Refresh';
		                 icon: (self iconNamed: #refresh);
		                 action: [ self refreshModels ].
	self refreshModels.
	hostInput := self newTextInput
		             placeholder: 'localhost';
		             text: model host;
		             yourself.

	portInput := self newTextInput
		             placeholder: '11434';
		             text: model port;
		             yourself.

	temperatureInput := self newTextInput
		                    placeholder: '0.0';
		                    text: model temperature asString;
		                    yourself.
	installInput := self newTextInput
		                placeholder: 'model name (e.g. codellama:7b)';
		                yourself.

	installButton := self newButton
		                 label: 'Install';
		                 icon: (self iconNamed: #add);
                                action: [
                                        model class pullModel: installInput text.
                                        self refreshModels.
                                        (model class isValidModel: installInput text)
                                                ifTrue: [
                                                        model class pullModel: installInput text.
                                                        self refreshModels
                                                ]
                                                ifFalse: [
                                                        self inform: 'Model ', installInput text, ' not found.'
                                                ]
                                ];
		                 yourself
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> installButton [

	^ installButton
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> installButton: anObject [

	installButton := anObject
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> installInput [

	^ installInput
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> installInput: anObject [

	installInput := anObject
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> model [

	^ model
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> modelsDrop [

	^ modelsDrop
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> modelsDrop: anObject [

	modelsDrop := anObject
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> refreshButton [

	^ refreshButton
]

{ #category : 'accessing' }
ChatPharoOllamaSettingsPresenter >> refreshButton: anObject [

	refreshButton := anObject
]

{ #category : 'initialization' }
ChatPharoOllamaSettingsPresenter >> refreshModels [ 

    modelsDrop
        items: model class modelNames;
        display: [:eachModelName | eachModelName ].
    modelsDrop items ifNotEmpty: [ modelsDrop selectFirst ].
]

{ #category : 'accessing - model' }
ChatPharoOllamaSettingsPresenter >> setModelBeforeInitialization: anAgent [
	model := anAgent
]
