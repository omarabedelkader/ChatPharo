Class {
	#name : 'ChatPharoBrowser',
	#superclass : 'ClyBrowserToolMorph',
	#instVars : [
		'packagename',
		'packageName'
	],
	#category : 'AI-ChatPharo-Env',
	#package : 'AI-ChatPharo-Env'
}

{ #category : 'activation' }
ChatPharoBrowser class >> packageActivation [ 

    <classAnnotation>
    ^ ClyTabActivationStrategyAnnotation for: Package asCalypsoItemContext
]

{ #category : 'building' }
ChatPharoBrowser >> build [

    | chat presenter |
    chat := ChatPharoChat new
        agent: ChatPharoSettings default agent;
        yourself.
    presenter := chat presenter.
    self addMorph: presenter build fullFrame: LayoutFrame identity
]

{ #category : 'accessing' }
ChatPharoBrowser >> packagename [

	^ packagename
]

{ #category : 'accessing' }
ChatPharoBrowser >> packagename: anObject [

	packagename := anObject
]

{ #category : 'building' }
ChatPharoBrowser >> setUpModelFromContext [ 

    packageName := context lastSelectedClassGroup name
]
