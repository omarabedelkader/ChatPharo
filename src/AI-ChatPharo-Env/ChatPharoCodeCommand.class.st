Class {
	#name : 'ChatPharoCodeCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'element'
	],
	#category : 'AI-ChatPharo-Env-Menu',
	#package : 'AI-ChatPharo-Env',
	#tag : 'Menu'
}

{ #category : 'testing' }
ChatPharoCodeCommand class >> canBeExecutedInContext: aContext [

        (ChatPharoSettings default codeFeatureEnabled) ifFalse: [ ^ false ].
        ^ aContext selectedMethodItems notEmpty
]

{ #category : 'testing' }
ChatPharoCodeCommand class >> chatPharoActivation [

        <classAnnotation>
        ^ (CmdShortcutActivation by: $k meta shift for: ClyFullBrowserMethodContext)
]

{ #category : 'testing' }
ChatPharoCodeCommand class >> clyMenuActivation [

        <classAnnotation>
        ^ CmdContextMenuActivation
                byRootGroupItemFor: ClyFullBrowserMethodContext
]

{ #category : 'execution' }
ChatPharoCodeCommand >> execute [

        | method |
        element ifNil: [ ^ self ].
        method := element browserItem actualObject.
        ChatPharo codeForMethod: method
]

{ #category : 'execution' }
ChatPharoCodeCommand >> icon [

        ^ ChatPharoIcons chatPharoIcon
]

{ #category : 'execution' }
ChatPharoCodeCommand >> label [

        ^ 'Code ChatPharo'
]

{ #category : 'execution' }
ChatPharoCodeCommand >> readParametersFromContext: aContext [ 
        element := aContext selectedMethodItems first
]
