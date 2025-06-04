Class {
	#name : 'AIChatPharoWorldMenu',
	#superclass : 'RSObject',
	#category : 'AI-ChatPharo-Env',
	#package : 'AI-ChatPharo-Env'
}

{ #category : 'loading' }
AIChatPharoWorldMenu class >> loadExporters [

	Metacello new
		githubUser: 'omarabedelkader'
		project: 'ChatPharo'
		commitish: 'main'
		path: 'src';
		baseline: 'AIChatPharo';
		load
]

{ #category : 'loading' }
AIChatPharoWorldMenu class >> loadFullVersion [
	"TODO do not discard changes"

	(UIManager default confirm:
		 'Do you want to load the last version of ChatPharo?') ifFalse: [
		^ self ].
	[
		Metacello new
			githubUser: 'omarabedelkader'
			project: 'ChatPharo'
			commitish: 'main'
			path: 'src';
			baseline: 'AIChatPharo';
			load ]
		on: MCMergeOrLoadWarning
		do: [ :warning | warning load ].
	self loadExporters
]

{ #category : 'loading' }
AIChatPharoWorldMenu class >> menu00ChatPharoOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharo)
		parent: #Tools;
		label: 'ChatPharo';
		help: 'An AI Assistant';
		order: 777.
	(aBuilder item: #ChatPharoHelp)
		parent: #ChatPharo;
		label: 'Help';
		icon: (self iconNamed: #help);
		help: 'Need help?';
		order: 1.
	(aBuilder item: #ChatPharoLoad)
		parent: #ChatPharo;
		label: 'Load...';
		icon: (self iconNamed: #smallLoadProject);
		help: 'Load ChatPharo projects';
		order: 2.
	(aBuilder item: #ChatPharoLoadFullVersion)
		parent: #ChatPharo;
		order: 3;
		label: 'Open ChatPharo';
		help: 'Open ChatPharo';
		action: [ ChatPharo new presenter open ]
]

{ #category : 'loading' }
AIChatPharoWorldMenu class >> menu04DocumentationOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharoDocumentation)
		parent: #ChatPharoHelp;
		order: 4;
		label: 'Online documentation';
		help:
			'Will open the webpage https://github.com/omarabedelkader/ChatPharo/wiki';
		icon: (self iconNamed: #smallHelp);
		action: [
			WebBrowser openOn:
					'https://github.com/omarabedelkader/ChatPharo/wiki' ]
]

{ #category : 'loading' }
AIChatPharoWorldMenu class >> menu06LoadFullVersionOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharoLoadFullVersion)
		parent: #ChatPharoLoad;
		order: 5;
		label: 'Load full version';
		help: 'Load full version of Roassal including examples';
		"icon: self chatpharoIcon;"action: [ self loadFullVersion ]
]

{ #category : 'loading' }
AIChatPharoWorldMenu class >> menu07ChatPharoOn: aBuilder [

	<worldMenu>
	(aBuilder item: #ChatPharoLoadFullVersion)
		parent: #ChatPharoLoad;
		order: 5;
		label: 'Open ChatPharo';
		help: 'Open ChatPharo';
		"icon: self chatpharoIcon;"action: [ ChatPharo new presenter open ]
]

{ #category : 'see class side' }
AIChatPharoWorldMenu >> seeClassSide [
]
