"
Extention to suppord Ask ChatPharo when selecting a context
"
Class {
	#name : 'ChatPharoCodeMenu',
	#superclass : 'RubSmalltalkCodeMode',
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'menu' }
ChatPharoCodeMenu class >> menuOn: aBuilder [

	<contextMenu>
        <RubSmalltalkCodeMenu>
        (aBuilder item: #'Ask ChatPharo' translated)
                order: 9;
                keyText: 'cp';
                selector: #openChatCharo;
                help: 'Get help from ChatPharo to understand the code';
                icon: ChatPharoIcons chatPharoIcon
]
