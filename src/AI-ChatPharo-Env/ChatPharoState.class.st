"
This a class that class chatpharo at user request inside a specific env
"
Class {
	#name : 'ChatPharoState',
	#superclass : 'WorldState',
	#classVars : 'CurrentEnv',
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'world state' }
ChatPharoState class >> aiWorldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharo)
		order: 10;
		icon: (self iconNamed: #announcement);
		help: 'An AI Assistant';
		with: [
				(aBuilder item: #TempChatPharo)
					action: [ ChatPharo new presenter open ];
					order:0;
					keyText: 'o,c';
					label: 'Temp ChatPharo';
					icon: (self iconNamed: #announcement);
					help: 'Open Temp Chat'.

				(aBuilder item: #ChatPharoSettings)
					action: [ ChatPharoSettings default presenter open ];
					label: 'ChatPharo Settings';
					icon: (self iconNamed: #smallConfiguration);
					help: 'Open ChatPharo settings'.

				(aBuilder item: #ChatPharoDocumentation)
					action: [
						WebBrowser openOn:
								'https://github.com/omarabedelkader/ChatPharo/wiki' ];
					label: 'ChatPharo Wiki';
					icon: (self iconNamed: #smallHelp);
					help:
						'Will open the webpage https://github.com/omarabedelkader/ChatPharo/wiki' ]
]

{ #category : 'see class side' }
ChatPharoState >> seeClassSide [
]

{ #category : 'env' }
ChatPharoState class >> setEnvironment: aString [
	CurrentEnv := aString.
]

{ #category : 'env' }
ChatPharoState class >> currentEnvironment [
	^ CurrentEnv ifNil: [ 'development' ]
]

{ #category : 'env' }
ChatPharoState class >> systemPromptFor: agentSymbolOrClass [
	| env agentSymbol |

	env := self currentEnvironment.
	agentSymbol := agentSymbolOrClass isBehavior
		ifTrue: [ agentSymbolOrClass agentSymbol ]
		ifFalse: [ agentSymbolOrClass ].

	^ ((env = 'production') and: [ agentSymbol = #gemini ]) ifTrue: [
		'You are an AI assistant for professional Pharo development.'
	] ifFalse: [
		'You are a helpful AI assistant working in development mode.'
	]
]