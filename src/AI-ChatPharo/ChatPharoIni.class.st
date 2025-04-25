Class {
	#name : 'ChatPharoIni',
	#superclass : 'ClyBrowserToolMorph',
	#instVars : [
		'packageName'
	],
	#category : 'AI-ChatPharo',
	#package : 'AI-ChatPharo'
}

{ #category : 'activation' }
ChatPharoIni class >> packageActivation [
	<classAnnotation>
	^ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext
]

{ #category : 'building' }
ChatPharoIni >> build [

	| presenter geminiAPIKey |
	
	presenter := (ChatPharo on: (OpenAIChatAPI
	ollamaWithSystem: 'You are an AI coding assistant within the user''s Pharo image specifically in the package ', packageName
	tools: OpenAIChatToolsetOnBrowserEnvironment new tools ,
		{ OpenAIChatToolFunction toolOpenPlayground })).




"presenter := (ChatPharo on: (OpenAIChatAPI geminiWithAPIKey: geminiAPIKey
	system: 'You are an AI coding assistant within the user''s Pharo image. The user is currently browsing the package ', packageName , '. Assume that the user''s question is about classes and methods in this package, proactively explore its code.'
	tools: OpenAIChatToolsetOnBrowserEnvironment new tools ,
		{ OpenAIChatToolFunction toolOpenPlayground }))."
		
	self
		addMorph: presenter build
		fullFrame: LayoutFrame identity
]

{ #category : 'accessing' }
ChatPharoIni >> packageName [

	^ packageName
]

{ #category : 'accessing' }
ChatPharoIni >> packageName: anObject [

	packageName := anObject
]

{ #category : 'initialization' }
ChatPharoIni >> setUpModelFromContext [

	packageName := context lastSelectedClassGroup name
]
