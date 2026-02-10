Class {
	#name : 'ChatPharoIconsTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Icons',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Icons'
}

{ #category : 'tests' }
ChatPharoIconsTest >> testChatPharoIconBase64NotEmpty [

	self assert: ChatPharoIcons chatPharoIconBase64 notEmpty
]

{ #category : 'tests' }
ChatPharoIconsTest >> testChatPharoIconIsForm [

	self assert: (ChatPharoIcons chatPharoIcon isKindOf: Form)
]

{ #category : 'tests' }
ChatPharoIconsTest >> testChatPharoIconNotNil [ 

	self assert: ChatPharoIcons chatPharoIcon notNil
]

{ #category : 'tests' }
ChatPharoIconsTest >> testIconsReturnsDictionary [

	self assert: ChatPharoIcons icons isDictionary
]

{ #category : 'tests' }
ChatPharoIconsTest >> testResetIconsClearsCache [

	"After reset, icons should still be recreatable"
	ChatPharoIcons resetIcons.
	self assert: ChatPharoIcons chatPharoIcon notNil
]
