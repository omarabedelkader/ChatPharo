Class {
	#name : 'ChatPharoSafetyAdvisor',
	#superclass : 'Object',
	#category : 'AI-ChatPharo-Safety',
	#package : 'AI-ChatPharo-Safety'
}

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> applyDefaultSettingsTo: aSettings [
	"Apply all recommended default settings to the given settings object.
	 Returns an OrderedCollection of step descriptions for progress tracking."

	| steps |
	steps := OrderedCollection new.

	"Step 1: Configure the recommended agent (Gemini)"
	steps add: [ :progressBlock |
		progressBlock value: 'Configuring AI agent...'.
		aSettings useApi: ChatPharoGeminiAgent.
		10 milliSeconds wait ].

	"Step 2: Enable all browser tools"
	steps add: [ :progressBlock |
		progressBlock value: 'Enabling browser tools...'.
		aSettings enableAllBrowserTools.
		10 milliSeconds wait ].

	"Step 3: Enable browser extension"
	steps add: [ :progressBlock |
		progressBlock value: 'Enabling browser extension...'.
		aSettings browserExtensionEnabled: true.
		10 milliSeconds wait ].

	"Step 4: Configure skills"
	steps add: [ :progressBlock |
		progressBlock value: 'Configuring skills...'.
		aSettings automaticSkillsEnabled: true.
		aSettings skillToolsEnabled: true.
		10 milliSeconds wait ].

	"Step 5: Enable ask and code features"
	steps add: [ :progressBlock |
		progressBlock value: 'Enabling code features...'.
		aSettings askFeatureEnabled: true.
		aSettings codeFeatureEnabled: true.
		10 milliSeconds wait ].

	"Step 6: Configure caching and feedback"
	steps add: [ :progressBlock |
		progressBlock value: 'Configuring caching...'.
		aSettings cacheEnabled: true.
		aSettings feedbackButtonsEnabled: true.
		10 milliSeconds wait ].

	"Step 7: Configure welcome message and logging"
	steps add: [ :progressBlock |
		progressBlock value: 'Configuring interface...'.
		aSettings welcomeMessageEnabled: true.
		aSettings loggingEnabled: true.
		10 milliSeconds wait ].

	"Step 8: Configure sandbox (safe defaults)"
	steps add: [ :progressBlock |
		progressBlock value: 'Configuring security sandbox...'.
		aSettings sandboxEnabled: true.
		aSettings sandboxRestrictFileSystem: true.
		aSettings sandboxRestrictNetwork: true.
		aSettings sandboxRestrictSystemAccess: true.
		aSettings sandboxTimeout: 5000.
		10 milliSeconds wait ].

	"Step 9: Set maximum iterations"
	steps add: [ :progressBlock |
		progressBlock value: 'Setting optimization parameters...'.
		aSettings maximumIterations: 3.
		10 milliSeconds wait ].

	"Step 10: Mark advisor defaults as configured"
	steps add: [ :progressBlock |
		progressBlock value: 'Finalizing configuration...'.
		aSettings advisorDefaultsConfigured: true.
		10 milliSeconds wait ].

	^ steps
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> confirmMaxIterationsOn: aPresenter [

    ^ aPresenter confirm: self maxIterationsMessage
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> confirmPromptModificationOn: aPresenter [ 

    ^ aPresenter confirm: self promptChangeMessage
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> confirmToolDisableOn: aPresenter [ 

    ^ aPresenter confirm: self toolDisableMessage
]

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> defaultSettingsDescription [
	"Return a description of what the default settings include"

	^ String streamContents: [ :stream |
		stream
			nextPutAll: 'The Advisor recommends the following configuration:'; cr; cr;
			nextPutAll: '• AI Agent: Gemini (Google AI)'; cr;
			nextPutAll: '• All browser tools enabled'; cr;
			nextPutAll: '• Browser extension enabled'; cr;
			nextPutAll: '• Automatic skills detection enabled'; cr;
			nextPutAll: '• Code assistant features enabled'; cr;
			nextPutAll: '• Response caching enabled'; cr;
			nextPutAll: '• Security sandbox enabled'; cr;
			nextPutAll: '• Welcome messages enabled'; cr; cr;
			nextPutAll: 'These settings provide the best experience for most users.' ]
]

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> defaultsPromptMessage [
	"Message shown when asking user about default settings"

	^ 'Would you like to use the recommended settings proposed by the Advisor?
This will automatically configure ChatPharo with optimal settings including:
- AI agent selection
- Tool configurations
- Security settings
- Interface preferences
You can always customize these settings later.'
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> maxIterationsMessage [

    ^ 'Maximum iterations must be at least 1.\nSet value to 1?'
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> promptChangeMessage [ 

    ^ 'For optimal performance we recommend you to not change the prompt.\nAre you sure you want to modify it?'
]

{ #category : 'safety' }
ChatPharoSafetyAdvisor class >> toolDisableMessage [ 

    ^ 'For optimal performance we recommend keeping all tools enabled.\nAre you sure you want to disable this tool?'
]

{ #category : 'as yet unclassified' }
ChatPharoSafetyAdvisor class >> totalDefaultSteps [
	"Return the total number of steps for applying defaults"

	^ 10
]
