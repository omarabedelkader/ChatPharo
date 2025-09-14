Class {
	#name : 'ChatPharoAskCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'element'
	],
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'as yet unclassified' }
ChatPharoAskCommand class >> canBeExecutedInContext: aContext [

    ^ aContext selectedMethodItems notEmpty
]

{ #category : 'as yet unclassified' }
ChatPharoAskCommand class >> chatPharoActivation [

    <classAnnotation>
    ^ CmdShortcutActivation
        by: $p
        meta
        for: ClyFullBrowserMethodContext
]

{ #category : 'as yet unclassified' }
ChatPharoAskCommand class >> clyMenuActivation [

    <classAnnotation>
    ^ CmdContextMenuActivation
        byRootGroupItemFor: ClyFullBrowserMethodContext
]

{ #category : 'execution' }
ChatPharoAskCommand >> execute [

    | method |
    element ifNil: [ ^ self ].
    method := element browserItem actualObject.
    ChatPharo ask: method sourceCode
]

{ #category : 'execution' }
ChatPharoAskCommand >> icon [

    ^ ChatPharoIcons chatPharoIcon
]

{ #category : 'execution' }
ChatPharoAskCommand >> label [

    ^ 'Ask ChatPharo'
]

{ #category : 'execution' }
ChatPharoAskCommand >> readParametersFromContext: aContext [

    element := aContext selectedMethodItems first
]
