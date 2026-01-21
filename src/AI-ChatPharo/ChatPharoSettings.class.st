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
		'welcomeMessageEnabled',
		'loggingEnabled',
		'askFeatureEnabled',
		'codeFeatureEnabled',
		'skillsEnabled',
		'automaticSkillsEnabled',
		'skillToolsEnabled'
	],
	#classInstVars : [
		'Default'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'accessing' }
ChatPharoSettings class >> default [

	Default ifNil: [ self setDefault: self loadOrNew ].
	^ Default
]

{ #category : 'accessing' }
ChatPharoSettings class >> legacySettingsFileReference [

        ^ FileLocator imageDirectory / 'chatpharo-settings.ston'
]

{ #category : 'accessing' }
ChatPharoSettings class >> loadOrNew [

	| path |
	self migrateLegacySettingsIfNecessary.
	path := self settingsFileReference.
	path exists ifFalse: [ ^ self new ].

	^ path readStreamDo: [ :file |
			  [
				  | settings |
				  settings := STON fromStream: file.
				  settings browserExtensionEnabled ifNil: [ settings browserExtensionEnabled: false ].
				  settings browserAutoTabEnabled ifNil: [ settings browserAutoTabEnabled: true ].
				  settings browserToolsEnabled ifNil: [
					  settings browserToolsEnabled: (ChatPharoBrowserEnvironment new tools collect: [ :t | t name ]) asOrderedCollection ].
				  settings maximumIterations.
				  settings cacheEnabled ifNil: [ settings cacheEnabled: true ].
				  settings feedbackButtonsEnabled ifNil: [ settings feedbackButtonsEnabled: true ].
				  settings welcomeMessageEnabled ifNil: [ settings welcomeMessageEnabled: true ].
				  settings loggingEnabled.
				  settings askFeatureEnabled ifNil: [ settings askFeatureEnabled: true ].
				  settings codeFeatureEnabled ifNil: [ settings codeFeatureEnabled: true ].
								  settings skillsEnabled ifNil: [ settings skillsEnabled: OrderedCollection new ].
				  settings automaticSkillsEnabled ifNil: [ settings automaticSkillsEnabled: true ].
				  settings skillToolsEnabled ifNil: [ settings skillToolsEnabled: true ].
				  ^ settings ]
				  on: Error
				  do: [ ^ self new ] ]
]

{ #category : 'accessing' }
ChatPharoSettings class >> migrateLegacySettingsIfNecessary [

        | legacyPath newPath |
        newPath := self settingsFileReference.
        newPath exists ifTrue: [ ^ self ].
        legacyPath := self legacySettingsFileReference.
        legacyPath exists ifFalse: [ ^ self ].
        newPath parent ensureCreateDirectory.
        [ legacyPath moveTo: newPath ]
                on: Error
                do: [ legacyPath readStreamDo: [ :input |
                                newPath writeStreamDo: [ :output |
                                        output nextPutAll: input contents ] ].
                        legacyPath deleteIfAbsent: [ ] ]
]

{ #category : 'accessing' }
ChatPharoSettings class >> resetDefault [

	<script>
	| path directory |
	Default := nil.
	path := self settingsFileReference.
	path deleteIfAbsent: [ ].
	directory := path parent.
        (directory exists and: [ directory isDirectory and: [ directory children isEmpty ]])
                ifTrue: [ directory delete ].
        self legacySettingsFileReference deleteIfAbsent: [ ].
	^ self
]

{ #category : 'accessing' }
ChatPharoSettings class >> saveDefault [

| path |
        path := self settingsFileReference.
        path parent ensureCreateDirectory.
        path deleteIfAbsent: [ ].
        path writeStreamDo: [ :stream |
                STON put: self default onStream: stream ].
        self legacySettingsFileReference deleteIfAbsent: [ ].
        ^ self
]

{ #category : 'accessing' }
ChatPharoSettings class >> setDefault: aSettings [

	Default := aSettings.
	ChatPharoLogger loggingEnabled: aSettings loggingEnabled.
        ^ Default
]

{ #category : 'accessing' }
ChatPharoSettings class >> settingsDirectory [

	^ FileLocator imageDirectory / 'chatpharo'
]

{ #category : 'accessing' }
ChatPharoSettings class >> settingsFileReference [

        ^ self settingsDirectory / 'chatpharo-settings.ston'
]

{ #category : 'initialization' }
ChatPharoSettings >> agent [

	^ agent
]

{ #category : 'accessing' }
ChatPharoSettings >> askFeatureEnabled [

        ^ askFeatureEnabled ifNil: [ askFeatureEnabled := true ]
]

{ #category : 'accessing' }
ChatPharoSettings >> askFeatureEnabled: aBoolean [ 
        askFeatureEnabled := aBoolean.
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Ask feature toggled'
                details: (Dictionary new
                        at: 'enabled' put: aBoolean;
                        yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> automaticSkillsEnabled [
	"Whether skills can be automatically triggered based on query keywords"

	^ automaticSkillsEnabled ifNil: [ automaticSkillsEnabled := true ]
]

{ #category : 'initialization' }
ChatPharoSettings >> automaticSkillsEnabled: aBoolean [

	automaticSkillsEnabled := aBoolean.
	self class setDefault: self.
	self class saveDefault.
	ChatPharoLogger logFrontend: 'Automatic skills toggled'
		details: (Dictionary new
			at: 'enabled' put: aBoolean;
			yourself)
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

{ #category : 'accessing' }
ChatPharoSettings >> codeFeatureEnabled [

        ^ codeFeatureEnabled ifNil: [ codeFeatureEnabled := true ]
]

{ #category : 'accessing' }
ChatPharoSettings >> codeFeatureEnabled: aBoolean [
        codeFeatureEnabled := aBoolean.
        self class setDefault: self.
        self class saveDefault.
        ChatPharoLogger logFrontend: 'Code feature toggled'
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
ChatPharoSettings >> disableSkill: skillName [
	"Disable a manually enabled skill"

	skillsEnabled remove: skillName ifAbsent: [ ].
	self class setDefault: self.
	self class saveDefault.
	ChatPharoLogger logFrontend: 'Skill disabled'
		details: (Dictionary new
			at: 'skill' put: skillName;
			at: 'remainingSkills' put: skillsEnabled asArray printString;
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

{ #category : 'initialization' }
ChatPharoSettings >> enableSkill: skillName [
	"Enable a skill for manual inclusion"

	(skillsEnabled includes: skillName) ifFalse: [
		skillsEnabled add: skillName ].
	self class setDefault: self.
	self class saveDefault.
	ChatPharoLogger logFrontend: 'Skill enabled'
		details: (Dictionary new
			at: 'skill' put: skillName;
			at: 'skills' put: skillsEnabled asArray printString;
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
	loggingEnabled := true.
	askFeatureEnabled := true.
	codeFeatureEnabled := true.
	browserToolsEnabled := (ChatPharoBrowserEnvironment new tools collect: [ :t | t name ]) asOrderedCollection.
	maximumIterations := 3.
		skillsEnabled := OrderedCollection new.
	automaticSkillsEnabled := true.
	skillToolsEnabled := true.
	ChatPharoLogger loggingEnabled: true.
	ChatPharoLogger logSystem: 'Settings initialized' details: (Dictionary new
			 at: 'defaultAgent' put: (ChatPharoLogger agentNameFor: agent);
			 yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> loggingEnabled [

    ^ loggingEnabled ifNil: [ loggingEnabled := true ]
]

{ #category : 'initialization' }
ChatPharoSettings >> loggingEnabled: aBoolean [

    loggingEnabled = aBoolean ifTrue: [ ^ loggingEnabled ].
    loggingEnabled := aBoolean.
    self class setDefault: self.
    self class saveDefault
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
ChatPharoSettings >> skillToolsEnabled [
	"Whether skill tools (list_available_skills, get_skill_context) are available to the LLM"

	^ skillToolsEnabled ifNil: [ skillToolsEnabled := true ]
]

{ #category : 'initialization' }
ChatPharoSettings >> skillToolsEnabled: aBoolean [

	skillToolsEnabled := aBoolean.
	self class setDefault: self.
	self class saveDefault.
	ChatPharoLogger logFrontend: 'Skill tools toggled'
		details: (Dictionary new
			at: 'enabled' put: aBoolean;
			yourself)
]

{ #category : 'initialization' }
ChatPharoSettings >> skillsEnabled [
	"Collection of manually enabled skill names"

	^ skillsEnabled ifNil: [ skillsEnabled := OrderedCollection new ]
]

{ #category : 'initialization' }
ChatPharoSettings >> skillsEnabled: aCollection [

	skillsEnabled := aCollection.
	self class setDefault: self.
	self class saveDefault.
	ChatPharoLogger logFrontend: 'Skills selection updated'
		details: (Dictionary new
			at: 'skills' put: aCollection asArray printString;
			yourself)
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
