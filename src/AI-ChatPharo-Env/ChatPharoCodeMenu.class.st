Class {
	#name : 'ChatPharoCodeMenu',
	#superclass : 'RubSmalltalkCodeMode',
	#category : 'AI-ChatPharo-Env',
	#package : 'AI-ChatPharo-Env'
}

{ #category : 'menu' }
ChatPharoCodeMenu class >> menuOn: aBuilder [
	"Specify the menu used when writing code."

	<contextMenu>
	<RubSmalltalkCodeMenu>
	(aBuilder item: #'Ask ChatPharo' translated)
		order: 9;
		keyText: 'd';
		selector: #openChatCharo;
		help: nil;
		iconName: #announcement.
]
