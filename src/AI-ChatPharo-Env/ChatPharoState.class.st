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
		parent: #ChatPharo;
		order: 2;
		action: [ ChatPharoSettings default presenter open ];
		label: 'ChatPharo Settings';
		icon: (self iconNamed: #smallConfiguration);
		help: 'Open ChatPharo settings'
]

{ #category : 'world state' }
ChatPharoState class >> chatPharoWikiWorldMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharoDocumentation)
		parent: #ChatPharo;
		order: 3;
		action: [
			WebBrowser openOn:
					'https://github.com/omarabedelkader/ChatPharo/wiki' ];
		label: 'ChatPharo Wiki';
		icon: (self iconNamed: #smallHelp);
		help:
			'Will open the webpage https://github.com/omarabedelkader/ChatPharo/wiki'
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
