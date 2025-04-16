Class {
	#name : 'ChatPharoHistorySaverTest',
	#superclass : 'TestCase',
	#category : 'AI-ChatPharo-Tests-Spec',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Spec'
}

{ #category : 'tests' }
ChatPharoHistorySaverTest >> testHistoryStringOn [
	| historyItem stream |
	stream := WriteStream on: ''.
	historyItem := ChatPharoHistorySaver role: 'user' content: 'Killroy was here'.
	historyItem historyStringOn: stream.
	self assert: stream contents equals: ('user: Killroy was here', String cr)
]

{ #category : 'tests' }
ChatPharoHistorySaverTest >> testRoleContent [
	| historyItem |
	historyItem := ChatPharoHistorySaver role: 'user' content: 'Killroy was here'.
	self assert: historyItem role equals: 'user'.
	self assert: historyItem content equals: 'Killroy was here'
]
