"
This a class that class chatpharo at user request inside a specific env
"
Class {
	#name : 'ChatPharoState',
	#superclass : 'WorldState',
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'world state' }
ChatPharoState class >> aiWorldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharo)
		order: 1;
		icon: ChatPharoIcons chatPharoIcon;
		help: 'An AI Assistant'
]

{ #category : 'world state' }
ChatPharoState class >> chatPharoSettingsWorldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharoSettings)
		action: [ ChatPharoSettings default presenter open ];
		label: 'ChatPharo Settings';
		icon: (self iconNamed: #smallConfiguration);
		help: 'Open ChatPharo settings';
		parent: #ChatPharo
]

{ #category : 'world state' }
ChatPharoState class >> chatPharoShortcut [

	<shortcut>
	^ KMKeymap
		  shortcut: $o meta , $c meta
		  action: [ self openTempChatPresenter ]
]

{ #category : 'world state' }
ChatPharoState class >> chatPharoWikiWorldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharoDocumentation)
		action: [
			WebBrowser openOn:
					'https://github.com/omarabedelkader/ChatPharo/wiki' ];
		label: 'ChatPharo Wiki';
		icon: (self iconNamed: #smallHelp);
		help:
			'Will open the webpage https://github.com/omarabedelkader/ChatPharo/wiki';
			parent: #ChatPharo
]

{ #category : 'world state' }
ChatPharoState class >> openTempChatPresenter [

	ChatPharo new presenter open
]

{ #category : 'world state' }
ChatPharoState class >> tempChatPharoWorldMenuOn: aBuilder [

	<worldMenu>

	(aBuilder item: #TempChatPharo)
		parent: #ChatPharo;
		order: 1;
		keyText: 'o, c';
		label: 'Temp ChatPharo';
		icon: (self iconNamed: #announcement);
		help: 'Open Temp Chat';
		action: [ self openTempChatPresenter ]
]

{ #category : 'see class side' }
ChatPharoState >> seeClassSide [
]
