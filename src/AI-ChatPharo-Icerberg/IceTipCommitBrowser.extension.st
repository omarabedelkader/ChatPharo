Extension { #name : 'IceTipCommitBrowser' }

{ #category : '*AI-ChatPharo-Icerberg' }
IceTipCommitBrowser >> commentPanelClass [

	^ ChatPharoSettings default icebergExtensionEnabled
		ifTrue: [ ChatPharoIceTipCommentPanel ]
		ifFalse: [ IceTipCommentPanel ]
]
