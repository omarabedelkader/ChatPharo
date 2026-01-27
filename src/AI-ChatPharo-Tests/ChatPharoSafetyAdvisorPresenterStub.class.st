Class {
	#name : 'ChatPharoSafetyAdvisorPresenterStub',
	#superclass : 'Object',
	#instVars : [
		'alerts',
		'messages',
		'nextAnswer'
	],
	#category : 'AI-ChatPharo-Tests-Mock',
	#package : 'AI-ChatPharo-Tests',
	#tag : 'Mock'
}

{ #category : 'ui requests' }
ChatPharoSafetyAdvisorPresenterStub >> alert: aString [

	alerts add: aString
]

{ #category : 'ui requests' }
ChatPharoSafetyAdvisorPresenterStub >> alerts [

	^ alerts
]

{ #category : 'ui requests' }
ChatPharoSafetyAdvisorPresenterStub >> confirm: aString [

    messages add: aString.
    ^ nextAnswer ifNil: [ true ]
]

{ #category : 'ui requests' }
ChatPharoSafetyAdvisorPresenterStub >> initialize [

	super initialize.
	alerts := OrderedCollection new.
	messages := OrderedCollection new.
	nextAnswer := nil
]

{ #category : 'ui requests' }
ChatPharoSafetyAdvisorPresenterStub >> messages [

    ^ messages
]

{ #category : 'ui requests' }
ChatPharoSafetyAdvisorPresenterStub >> nextAnswer: aBoolean [

    nextAnswer := aBoolean
]
