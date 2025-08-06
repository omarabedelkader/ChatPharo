Class {
	#name : 'ChatPharoFailingClient',
	#superclass : 'Object',
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'adding' }
ChatPharoFailingClient >> addPath: aCollection [
    ^ self
]

{ #category : 'adding' }
ChatPharoFailingClient >> entity: anEntity [
    ^ self
]

{ #category : 'adding' }
ChatPharoFailingClient >> post [
    NetworkError signal: 'fail'
]

{ #category : 'adding' }
ChatPharoFailingClient >> response [
    ^ self
]

{ #category : 'adding' }
ChatPharoFailingClient >> timeout: seconds [
    ^ self
]
