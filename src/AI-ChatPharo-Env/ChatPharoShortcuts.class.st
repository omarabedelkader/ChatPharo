Class {
	#name : 'ChatPharoShortcuts',
	#superclass : 'KMCategory',
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'world state' }
ChatPharoShortcuts class >> chatPharoShortcut [ 

    <shortcut>
    ^ KMKeymap
        shortcut: $o meta , $c meta
        action: [ self openTempChatPresenter ]
]

{ #category : 'world state' }
ChatPharoShortcuts class >> openTempChatPresenter [

    ChatPharoState openTempChatPresenter
]
