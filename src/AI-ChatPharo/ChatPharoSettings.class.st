"
User-editable configuration.

* Knows the currently selected `agent`.
* Produces the list of **available API choices** by returning associations `displayName -> class`.
* Delegates model selection (`useModel:`) and agent swapping (`useApi:`) to the agent it owns.
* **Why** – separates persistent/user-configurable concerns from transient chat state.


```smalltalk
(ChatPharoSettings new
	useModel: 'codellama:7b';
	ollamaApi)
		getResponseForPrompt: 'Bonjour'.

```
"
Class {
	#name : 'ChatPharoSettings',
	#superclass : 'Object',
	#instVars : [
		'agent',
		'browserExtensionEnabled',
		'browserToolsEnabled',
		'maximumIterations',
		'browserAutoTabEnabled',
		'cacheEnabled',
		'feedbackButtonsEnabled',
		'welcomeMessageEnabled'
	],
	#classInstVars : [
		'Default'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoSettings class >> default [

	Default ifNil: [ Default := self loadOrNew ].
	^ Default
]

{ #category : 'accessing' }
ChatPharoSettings class >> loadOrNew [

	| path |
	path := FileLocator imageDirectory / 'chatpharo-settings.ston'.

	path exists ifFalse: [ ^ self new ].

	^ path readStreamDo: [ :file |
			  [
				  | settings |
				  settings := STON fromStream: file.
				  settings browserExtensionEnabled ifNil: [
					  settings browserExtensionEnabled: false ].
				  settings browserAutoTabEnabled ifNil: [
					  settings browserAutoTabEnabled: true ].
				  settings browserToolsEnabled ifNil: [
						  settings browserToolsEnabled:
							  (ChatPharoBrowserEnvironment new tools collect: [ :t |
								   t name ]) asOrderedCollection ].
				  settings maximumIterations.
				  settings cacheEnabled ifNil: [ settings cacheEnabled: true ].
				  settings feedbackButtonsEnabled ifNil: [
					  settings feedbackButtonsEnabled: true ].
				settings welcomeMessageEnabled ifNil: [ settings welcomeMessageEnabled: true ].
				  ^ settings ]
				  on: Error
				  do: [ ^ self new ] ]
]

{ #category : 'accessing' }
ChatPharoSettings class >> resetDefault [

        <script>
        | path |
        Default := nil.
        path := FileLocator imageDirectory / 'chatpharo-settings.ston'.
        path deleteIfAbsent: [ ].
        ^ self
]

{ #category : 'accessing' }
ChatPharoSettings class >> saveDefault [

	| path |
	path := FileLocator imageDirectory / 'chatpharo-settings.ston'.
	path deleteIfAbsent: [ ].
	path writeStreamDo: [ :stream |
		STON put: self default onStream: stream ].
	^ self
]

{ #category : 'accessing' }
ChatPharoSettings class >> setDefault: aSettings [ 

	Default := aSettings
]

{ #category : 'initialization' }
ChatPharoSettings >> agent [

	^ agent
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApiChoices [

	^ (self availableApis collect: [ :cls | cls displayName -> cls ])
		  asOrderedCollection
]

{ #category : 'initialization' }
ChatPharoSettings >> availableApis [

	^ {
		  ChatPharoNullAgent.
		  ChatPharoGeminiAgent .
		ChatPharoOllamaAgent .
		ChatPharoMistralAgent}
]

{ #category : 'initialization' }
ChatPharoSettings >> browserAutoTabEnabled [ 

        ^ browserAutoTabEnabled
]

{ #category : 'initialization' }
ChatPharoSettings >> browserAutoTabEnabled: aBoolean [

        browserAutoTabEnabled := aBoolean.
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Browser auto-tab toggled'
                details: (Dictionary new
                        at: 'enabled' put: aBoolean;
                        yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> browserExtensionEnabled [ 

        ^ browserExtensionEnabled
]

{ #category : 'initialization' }
ChatPharoSettings >> browserExtensionEnabled: aBoolean [

	        browserExtensionEnabled := aBoolean.
                self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Browser extension toggled'
                details: (Dictionary new
                        at: 'enabled' put: aBoolean;
                        yourself)

]

{ #category : 'initialization' }
ChatPharoSettings >> browserToolsEnabled [

        ^ browserToolsEnabled
]

{ #category : 'initialization' }
ChatPharoSettings >> browserToolsEnabled: aCollection [

	browserToolsEnabled := aCollection.
	self class setDefault: self.
	self class saveDefault.
	        ChatPharoLogger logFrontend: 'Browser tools selection updated'
                details: (Dictionary new
                        at: 'tools' put: aCollection asArray printString;
                        yourself)
]

{ #category : 'accessing' }
ChatPharoSettings >> cacheEnabled [
    ^ cacheEnabled ifNil: [ false ]
]

{ #category : 'accessing' }
ChatPharoSettings >> cacheEnabled: aBoolean [

	cacheEnabled := aBoolean.
	self class setDefault: self.
	self class saveDefault.
	    ChatPharoLogger logFrontend: 'Response cache toggled'
            details: (Dictionary new
                    at: 'enabled' put: aBoolean;
                    yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> disableBrowserTool: toolName [

        browserToolsEnabled remove: toolName ifAbsent: [ ].
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Browser tool disabled'
                details: (Dictionary new
                        at: 'tool' put: toolName;
                        at: 'remainingTools' put: browserToolsEnabled asArray printString;
                        yourself)

]

{ #category : 'initialization' }
ChatPharoSettings >> enableBrowserTool: toolName [
        (browserToolsEnabled includes: toolName) ifFalse: [
                browserToolsEnabled add: toolName ].
        self class setDefault: self.
        self class saveDefault.
maximumIterations := 3.
        ChatPharoLogger logFrontend: 'Browser tool enabled'
                details: (Dictionary new
                        at: 'tool' put: toolName;
                        at: 'tools' put: browserToolsEnabled asArray printString;
                        yourself)
]

{ #category : 'accessing' }
ChatPharoSettings >> feedbackButtonsEnabled [
	^ feedbackButtonsEnabled ifNil: [ true ]
]

{ #category : 'accessing' }
ChatPharoSettings >> feedbackButtonsEnabled: aBoolean [

        feedbackButtonsEnabled := aBoolean.
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Feedback buttons toggled'
                details: (Dictionary new
                        at: 'enabled' put: aBoolean;
                        yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> initialize [

	super initialize.
	agent := ChatPharoNullAgent new.
	browserExtensionEnabled := false.
	browserAutoTabEnabled := true.
	cacheEnabled := true.
	feedbackButtonsEnabled := true.
	welcomeMessageEnabled := true.
        browserToolsEnabled := (ChatPharoBrowserEnvironment new tools
                                        collect: [ :t | t name ])
                                       asOrderedCollection.
        maximumIterations := 3.
        ChatPharoLogger logSystem: 'Settings initialized'
                details: (Dictionary new
                        at: 'defaultAgent' put: (ChatPharoLogger agentNameFor: agent);
                        yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> maximumIterations [ 

        ^ maximumIterations
]

{ #category : 'initialization' }
ChatPharoSettings >> maximumIterations: aNumber [

        maximumIterations := aNumber max: 1.
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Maximum iterations updated'
                details: (Dictionary new
                        at: 'value' put: maximumIterations;
                        yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> models [

	^ agent class modelNames
]

{ #category : 'initialization' }
ChatPharoSettings >> presenter [

	^  ChatPharoSettingsPresenter on: self
]

{ #category : 'initialization' }
ChatPharoSettings >> useApi: anAgentClass [

        agent := anAgentClass new.
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Active agent changed'
                details: (Dictionary new
                        at: 'agent' put: (ChatPharoLogger agentNameFor: agent);
                        yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> useModel: aModelName [

        agent model: aModelName.
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Model selection updated'
                details: (Dictionary new
                        at: 'agent' put: (ChatPharoLogger agentNameFor: agent);
                        at: 'model' put: aModelName;
                        yourself)
]

{ #category : 'accessing' }
ChatPharoSettings >> welcomeMessageEnabled [ 

       ^ welcomeMessageEnabled ifNil: [ true ]
]

{ #category : 'accessing' }
ChatPharoSettings >> welcomeMessageEnabled: aBoolean [

	welcomeMessageEnabled := aBoolean.
	self class setDefault: self.
	self class saveDefault.
       ChatPharoLogger logFrontend: 'Welcome message toggled'
               details: (Dictionary new
                       at: 'enabled' put: aBoolean;
                       yourself)
]
